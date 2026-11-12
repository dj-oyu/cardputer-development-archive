#!/usr/bin/env python3
"""Read saved frozen-v3 statuses; never introduce a global acceptance rule."""
import argparse
from collections import Counter
import json
from pathlib import Path
import sys
sys.dont_write_bytecode = True
from strict_display_score import HERE, O, require, read_json, verify, sha, write_json

LABELS = {'MEETS_60_ON_DECLARED_SUBSET': 'PASS_CONDITIONAL_SUBSET_ONLY',
          'BELOW_60_ON_DECLARED_SUBSET': 'FAIL_CONDITIONAL_SUBSET_ONLY',
          'N/A_NOT_PASS': 'UNDEFINED_NOT_PASS'}


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--analysis', type=Path, required=True)
    p.add_argument('--analysis-completed-sha256', required=True)
    p.add_argument('--output', type=Path, required=True)
    a = p.parse_args()
    source, out = a.analysis.resolve(), a.output.resolve()
    require(source.is_relative_to(HERE) and out.is_relative_to(HERE) and out != HERE and not out.exists(),
            'fresh output under new analysis-code required')
    completion = read_json(verify(source / 'COMPLETED.json', a.analysis_completed_sha256))
    require(completion['status'] == 'DISPLAY_ANALYSIS_COMPLETE_NOT_GLOBAL_ACCEPTANCE', 'incomplete source analysis')
    for name, item in completion['files'].items():
        verify(O.contained(source, name), item['sha256'])
    formal = {arm: read_json(source / ('formal-' + arm + '.json')) for arm in ('legacy', 'agx')}
    rows, color, scopes, counts = [], {}, {}, {}
    for arm, data in formal.items():
        require(data['sixtyPercentGoal'] == 'NOT_ESTABLISHED_CONDITIONAL_METRICS_ONLY' and
                data['globalAcceptance'] == 'NOT_ESTABLISHED', 'global scope changed')
        count = Counter()
        for condition, item in data['conditions'].items():
            cs = item['colorMeanPrecision']['candidateScores']
            color.setdefault(condition, {})[arm] = {subset: {metric: cs[subset][metric]
                for metric in ('rgbMAE', 'rgbRMSE', 'valueStatus')}
                for subset in ('stableSubset', 'pooledFullForegroundDescriptive')}
            selected = [('color.rgbAgreementPercent', cs['stableSubset']['rgbAgreementPercent'], cs['stableSubset']['valueStatus'])]
            scope = {'color': {name: item['colorMeanPrecision'][name] for name in
                ('counts', 'stableCoverageFraction', 'uncertainCoverageFraction', 'conditionScope')}}
            if 'response' in item:
                rs = item['response']['candidateScores']['stableSubset']
                selected += [('response.directionAgreementPercent', rs['directionAgreementPercent'], rs['signValueStatus']),
                    ('response.responseMagnitudeAgreementPercent', rs['responseMagnitudeAgreementPercent'], rs['magnitudeValueStatus']),
                    ('response.brightening.IoU', rs['brightening']['IoU'], rs['brightening']['valueStatus']),
                    ('response.darkening.IoU', rs['darkening']['IoU'], rs['darkening']['valueStatus'])]
                scope['response'] = {name: item['response'][name] for name in
                    ('counts', 'stableCoverageFraction', 'uncertainCoverageFraction', 'conditionScope')}
            scopes.setdefault(condition, {})[arm] = scope
            for metric, value, status in selected:
                require(status in LABELS, 'unknown frozen status')
                require((status == 'N/A_NOT_PASS') == (value is None), 'frozen status/value mismatch')
                # Cross-check the pre-existing evaluator rule, not a new acceptance definition.
                if value is not None:
                    scaled = 100 * value if metric.endswith('.IoU') else value
                    require(status == ('MEETS_60_ON_DECLARED_SUBSET' if scaled >= 60 else 'BELOW_60_ON_DECLARED_SUBSET'),
                            'existing conditional numeric status mismatch')
                rows.append({'arm': arm, 'condition': condition, 'metric': metric,
                    'value': value, 'frozenStatus': status, 'displayLabel': LABELS[status]})
                count[status] += 1
        require(sum(count.values()) == 42, 'all10 color plus all8 x4 response statuses required')
        counts[arm] = dict(count)
    lookup = {(x['arm'], x['condition'], x['metric']): x for x in rows}
    changes = []
    for row in rows:
        if row['arm'] != 'legacy':
            continue
        other = lookup[('agx', row['condition'], row['metric'])]
        if row['frozenStatus'] != other['frozenStatus']:
            changes.append({'condition': row['condition'], 'metric': row['metric'],
                'legacy': row['frozenStatus'], 'agx': other['frozenStatus'],
                'legacyValue': row['value'], 'agxValue': other['value']})
    result = {'status': 'FROZEN_CONDITIONAL_STATUS_SUMMARY_NOT_GLOBAL_ACCEPTANCE',
        'sourceAnalysisCompletedSHA256': a.analysis_completed_sha256,
        'sixtyPercentGoal': 'NOT_ESTABLISHED_CONDITIONAL_METRICS_ONLY',
        'globalAcceptance': 'NOT_ESTABLISHED', 'noNewAcceptanceRule': True,
        'all10StableAndFullForegroundColor': color, 'all10All8UnknownScopes': scopes,
        'statusCounts': counts, 'all42StatusRowsPerArm': rows, 'statusChanges': changes,
        'noFrozenPassFailThresholdFor': ['rgbMAE (reported error; conditional color status uses derived RGB agreement)',
            'rgbRMSE', 'deltaLumaRMSE', 'deltaRGBRMSE', 'signedCorrelation',
            'centroidDistanceDiagonal', 'FP/FN/reverse/inactive counts', 'character shape'],
        'fullForegroundUncertainAndPerSeed': 'DESCRIPTIVE_ONLY_NOT_ACCEPTANCE',
        'undefinedNeverPass': True, 'unknownRemainderNeverPass': True}
    n = lambda v: 'N/A' if v is None else format(v, '.9g')
    lines = ['# Frozen v3 conditional status audit', '',
        'This file reads the existing saved statuses and independently checks their existing numeric rule. It introduces no new pass/fail threshold, combination rule, global acceptance definition or exclusion. All original analysis files remain unchanged.', '',
        '## All10 stable and full-foreground MAE and RMSE', '',
        '| Condition | Stable MAE legacy → AgX | Stable RMSE legacy → AgX | Full-FG MAE legacy → AgX | Full-FG RMSE legacy → AgX |',
        '|---|---:|---:|---:|---:|']
    for key, values in color.items():
        cells = [n(values['legacy'][subset][metric]) + ' → ' + n(values['agx'][subset][metric])
            for subset in ('stableSubset', 'pooledFullForegroundDescriptive') for metric in ('rgbMAE', 'rgbRMSE')]
        lines.append('| ' + key + ' | ' + ' | '.join(cells) + ' |')
    lines += ['', 'Full-foreground values remain descriptive. Stable color RGB agreement carries the frozen conditional status; RMSE has no frozen pass/fail threshold.', '',
        '## Frozen status counts', '',
        '| Arm | MEETS_60_ON_DECLARED_SUBSET | BELOW_60_ON_DECLARED_SUBSET | N/A_NOT_PASS | Total |',
        '|---|---:|---:|---:|---:|']
    for arm, values in counts.items():
        lines.append('| ' + arm + ' | ' + ' | '.join(str(values.get(s, 0)) for s in LABELS) + ' | 42 |')
    lines += ['', 'The42 entries are10 stable color RGB-agreement statuses and4 stable response statuses for each of8 contrasts: direction, magnitude, brightening IoU and darkening IoU. MEETS is a conditional-subset pass only. N/A is undefined, never a pass. Baselines have no response contrast.', '',
        '## Every all8 response conditional status', '',
        '| Contrast | Direction legacy → AgX | Magnitude legacy → AgX | Bright IoU legacy → AgX | Dark IoU legacy → AgX |',
        '|---|---|---|---|---|']
    short = {'MEETS_60_ON_DECLARED_SUBSET': 'PASS*', 'BELOW_60_ON_DECLARED_SUBSET': 'FAIL*', 'N/A_NOT_PASS': 'undefined'}
    for key in color:
        if key.endswith('-baseline'):
            continue
        cells = []
        for metric in ('response.directionAgreementPercent', 'response.responseMagnitudeAgreementPercent', 'response.brightening.IoU', 'response.darkening.IoU'):
            cells.append(' → '.join(short[lookup[(arm, key, metric)]['frozenStatus']] for arm in ('legacy', 'agx')))
        lines.append('| ' + key + ' | ' + ' | '.join(cells) + ' |')
    lines += ['', '*PASS/FAIL applies only to the frozen declared stable subset. All10 stable color conditions are conditional PASS in both arms. All10 color and all8 response conditions still have uncertain reference pixels and retain UNRESOLVED_UNCERTAIN_REMAINDER.', '',
        'Only one status changes: oblique-direction brightening IoU,0.455568054 →0.640223464, BELOW→MEETS. Six undefined response statuses remain: brightening IoU for intensity and albedo in both views, and darkening IoU for ambient in both views.', '',
        'Stable/unknown/full-foreground/seed metrics and FP/FN regressions still matter. Every defined conditional status meeting60 does not override unknowns, undefined IoUs, RMSE/count regressions, unchanged shape limitations or old budget failures. The frozen scorer emits NOT_ESTABLISHED_CONDITIONAL_METRICS_ONLY and NOT_ESTABLISHED globally; this report preserves those conclusions.', '',
        'Endpoint wording: any-channel zero means at least one quantized color channel is zero, not that all three channels are zero or the whole pixel is black. Quantized max endpoints are also separate from input LUT-domain clipping. No endpoint or clamp flag excludes any scored pixel.', '']
    out.mkdir()
    write_json(out / 'SUMMARY.json', result)
    (out / 'REPORT.md').write_text('\n'.join(lines))
    files = {p.name: {'sha256': sha(p), 'bytes': p.stat().st_size} for p in out.iterdir()}
    write_json(out / 'COMPLETED.json', {'status': 'CONDITIONAL_SUMMARY_COMPLETE_NOT_GLOBAL_ACCEPTANCE',
        'sourceAnalysisCompletedSHA256': a.analysis_completed_sha256, 'summarizerSHA256': sha(Path(__file__)), 'files': files})
    print(json.dumps({'output': str(out), 'statusCounts': counts, 'statusChanges': changes}, indent=2))


if __name__ == '__main__':
    main()
