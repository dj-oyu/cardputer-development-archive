#!/usr/bin/env python3
"""Exhaustive scalar audit of fixed, pre-existing metrics; no quality aggregation."""
from collections import Counter

LOWER = {'rgbMAE', 'rgbRMSE', 'deltaLumaRMSE', 'deltaRGBRMSE',
         'centroidDistanceDiagonal', 'activeToInactive', 'reverse', 'brightFN',
         'darkFN', 'brightFP', 'darkFP', 'inactiveFP', 'stableLumaAbsErrorSum',
         'extraPixels', 'missingPixels', 'extraFractionOfFrame',
         'missingFractionOfFrame', 'missingFractionOfSource',
         'extraFractionOfCandidate', 'union', 'oneSideUnresponsive'}
HIGHER = {'rgbAgreementPercent', 'directionAgreementPercent',
          'responseMagnitudeAgreementPercent', 'signedCorrelation', 'IoU',
          'sourceRecall', 'candidatePrecision', 'intersection', 'intersectionPixels'}
ABS_LOWER = {'signedLumaMeanCandidateMinusReference',
             'signedRGBMeanCandidateMinusReference'}
SKIP = {'candidateMetadata', 'uncertainLocationsYX', 'uncertainSignFrequencyAtLocations'}


def leaves(value, path=()):
    if isinstance(value, dict):
        for key, item in value.items():
            if key not in SKIP:
                yield from leaves(item, path + (key,))
    elif isinstance(value, list):
        for i, item in enumerate(value):
            yield from leaves(item, path + (str(i),))
    elif value is None or isinstance(value, (int, float, bool)):
        yield path, value


def direction(path):
    metric = path[-1]
    if metric.isdecimal() and len(path) > 1:
        metric = path[-2]
    if 'confusion' in path:
        row, col = path[-2:]
        if row == 'uncertain':
            return 'neutral_unknown_never_pass'
        return 'higher' if row == col else 'lower'
    if 'unknownCandidateClassCounts' in path:
        return 'neutral_unknown_never_pass'
    if metric in LOWER:
        return 'lower'
    if metric in HIGHER:
        return 'higher'
    if metric in ABS_LOWER:
        return 'absolute_lower'
    return 'neutral_count_or_reference_diagnostic'


def compare(legacy, agx):
    """Audit every scalar leaf, retaining all directional regressions and null changes.

    Coordinates and per-pixel reference diagnostics are not scalar quality metrics.
    They remain in the unchanged formal reports and are excluded only from this
    comparison. Counts and all eight per-seed branches are included.
    """
    left, right = dict(leaves(legacy)), dict(leaves(agx))
    if left.keys() != right.keys():
        raise ValueError('metric scalar schema changed')
    counts, by_condition, by_domain = Counter(), {}, {}
    regressions, improvements, neutral_changes, undefined = [], [], [], []
    for path, a in left.items():
        b = right[path]
        rule = direction(path)
        status = 'unchanged'
        change = None if a is None or b is None else b - a
        row = {'path': '/'.join(path), 'legacy': a, 'agx': b,
               'agxMinusLegacy': change, 'comparisonRule': rule}
        if a is None or b is None:
            status = 'bothUndefined' if a is b else 'undefinedTransition'
            if a is not b:
                undefined.append(row)
        elif a != b:
            delta = abs(b) - abs(a) if rule == 'absolute_lower' else change
            if rule.startswith('neutral'):
                status = 'neutralChanged'
                neutral_changes.append(row)
            elif delta == 0:
                status = 'equalAbsoluteMagnitude'
                neutral_changes.append(row)
            else:
                worse = delta > 0 if rule in ('lower', 'absolute_lower') else delta < 0
                status = 'regression' if worse else 'improvement'
                (regressions if worse else improvements).append(row)
        counts[status] += 1
        counts['totalScalarLeaves'] += 1
        counts['directionalScalarLeaves' if rule in ('lower', 'higher', 'absolute_lower')
               else 'neutralScalarLeaves'] += 1
        condition = path[1] if len(path) > 1 else '<root>'
        by_condition.setdefault(condition, Counter())[status] += 1
        if path and path[0] == 'descriptive' and len(path) > 2:
            by_domain.setdefault(path[2], Counter())[status] += 1
    return {'scope': 'EXHAUSTIVE_SCALAR_AUDIT_NOT_AN_AGGREGATE_QUALITY_SCORE',
            'scalarCounts': dict(counts),
            'countsByCondition': {k: dict(v) for k, v in by_condition.items()},
            'countsByFixedDomain': {k: dict(v) for k, v in by_domain.items()},
            'regressions': regressions, 'improvements': improvements,
            'neutralChanges': neutral_changes, 'undefinedTransitions': undefined,
            'nullNeverZeroOrPass': True, 'unknownNeverPass': True,
            'notes': ['Overlapping domains, related metrics, stable/unknown and per-seed branches are counted separately. Counts are not independent tests or a quality vote.',
                      'Raw candidate/reference class population changes have no monotone quality direction. All changes are retained as neutral diagnostics.',
                      'Signed error regressions compare absolute bias; positive/negative signed changes alone are not called improvements.',
                      'Finite/null transitions are retained separately and never counted as quality passes.']}


def paired(a, b):
    return {'legacy': a, 'agx': b, 'agxMinusLegacy': None if a is None or b is None else b - a}


def compact_summary(formal, descriptive):
    result = {}
    for key in formal['legacy']['conditions']:
        f = [formal[a]['conditions'][key] for a in ('legacy', 'agx')]
        d = [descriptive[a]['conditions'][key] for a in ('legacy', 'agx')]
        cs = [r['colorMeanPrecision']['candidateScores']['stableSubset'] for r in f]
        item = {'formalStableRGBMAE': paired(*[x.get('rgbMAE') for x in cs]),
                'fullForegroundRGBMAE': paired(*[x['fullForeground']['color']['all']['rgbMAE'] for x in d]),
                'fullFrameRGBMAE': paired(*[x['fullFrame']['color']['all']['rgbMAE'] for x in d]),
                'backgroundRGBMAE': paired(*[x['background']['color']['all']['rgbMAE'] for x in d]),
                'shapeUnchanged': f[0]['shapeFullFrame'] == f[1]['shapeFullFrame'],
                'shape': f[0]['shapeFullFrame']}
        if 'response' in f[0]:
            rs = [x['response']['candidateScores']['stableSubset'] for x in f]
            item['formalStableResponse'] = {m: paired(*[x[m] for x in rs]) for m in
                ('directionAgreementPercent', 'responseMagnitudeAgreementPercent', 'deltaLumaRMSE', 'deltaRGBRMSE')}
            item['formalStableResponse'].update({m+'IoU': paired(*[x[m]['IoU'] for x in rs]) for m in ('brightening', 'darkening')})
            conf = [x['fullForeground']['response']['confusionAndUnknown'] for x in d]
            item['foregroundConfusion'] = {m: paired(*[x[m] for x in conf]) for m in
                ('pixels', 'stable', 'unknown', 'activeToInactive', 'reverse', 'brightFN', 'darkFN', 'brightFP', 'darkFP', 'inactiveFP')}
        result[key] = item
    return result


def report(summary, audit):
    n = lambda x: 'N/A' if x is None else format(x, '.7g')
    arrow = lambda v: n(v['legacy']) + ' → ' + n(v['agx'])
    lines = ['# Fixed composed HDR: legacy display versus AgX float65', '',
        'Both arms use the identical reconstructed v38 camera-floor HDR. All10 legacy RGB565 files must first match the saved v38 scene-composition bytes exactly. The alternate arm applies the previously frozen official-OCIO-derived LUT approximation once after the fixed quarter average, not an exact OCIO processor.', '',
        'Original character-only depth, original reference images, stable/uncertain/full-foreground masks and formal v3 math are unchanged. There is no exposure, filtering, sample, geometry, light, material, threshold, mask or reference change. Shape is not inferred from composed RGB.', '',
        'Goal60 and global acceptance remain unestablished. Full-frame/background results, unknowns, full-foreground pooled scores and per-seed results are descriptive; they are never pooled into a formal acceptance score. LUT-domain clipping is retained in all metrics, with no exclusion or normalization.', '',
        '## All10 color errors', '',
        '| Condition | Formal stable RGB MAE | Full foreground RGB MAE | Full frame RGB MAE | Background RGB MAE |',
        '|---|---:|---:|---:|---:|']
    for key, item in summary.items():
        lines.append('| ' + key + ' | ' + ' | '.join(arrow(item[m]) for m in
            ('formalStableRGBMAE', 'fullForegroundRGBMAE', 'fullFrameRGBMAE', 'backgroundRGBMAE')) + ' |')
    lines += ['', 'All arrows are legacy → AgX; lower MAE is better.', '',
        '## All8 formal stable response contrasts', '',
        '| Contrast | Direction % | Magnitude % | Bright IoU | Dark IoU | Δ luma RMSE | Δ RGB RMSE |',
        '|---|---:|---:|---:|---:|---:|---:|']
    for key, item in summary.items():
        if 'formalStableResponse' not in item:
            continue
        r = item['formalStableResponse']
        lines.append('| ' + key + ' | ' + ' | '.join(arrow(r[m]) for m in
            ('directionAgreementPercent', 'responseMagnitudeAgreementPercent', 'brighteningIoU', 'darkeningIoU', 'deltaLumaRMSE', 'deltaRGBRMSE')) + ' |')
    lines += ['', '## Full-foreground response counts', '',
        '| Contrast | Active→inactive | Reversed | Bright FN | Dark FN | Bright FP | Dark FP | Inactive FP | Unknown |',
        '|---|---:|---:|---:|---:|---:|---:|---:|---:|']
    for key, item in summary.items():
        if 'foregroundConfusion' not in item:
            continue
        r = item['foregroundConfusion']
        lines.append('| ' + key + ' | ' + ' | '.join(arrow(r[m]) for m in
            ('activeToInactive', 'reverse', 'brightFN', 'darkFN', 'brightFP', 'darkFP', 'inactiveFP', 'unknown')) + ' |')
    lines += ['', '## Exhaustive regression audit', '',
        'SCALAR_AUDIT.json retains every directional regression, improvement, neutral scalar/count change and defined/undefined transition across formal and all fixed descriptive strata, including all eight reference seeds. The detailed arm reports retain every metric and all reference unknown diagnostics. No metric is selected based on output.']
    lines += ['- ' + k + ': ' + str(v) for k, v in audit['scalarCounts'].items()]
    lines += ['', 'These are overlapping scalar diagnostic counts, not independent tests or a quality vote. A candidate-only class population, significant-pixel count, unknown-class count or response sum has no assumed monotone quality direction. Such changes remain visible as neutral diagnostics. Unknowns and undefined values are never passes.', '',
        '## Limits', '',
        'No renderer execution, new renderer benchmark, background reflection transport, model/source edit, reference edit, product HDR-storage implementation, device result or budget-fit claim is made. Original negative old1M/8M gates are unchanged. Profile payload, HDR/output buffers and host timing are reported separately by the reconstruction/display run. The saved analysis allowlist contains code and aggregate reports only; it excludes source assets, raw HDR, composition/sample events, depth buffers, generated pixels, masks and raw LUT assets.', '']
    return '\n'.join(lines)
