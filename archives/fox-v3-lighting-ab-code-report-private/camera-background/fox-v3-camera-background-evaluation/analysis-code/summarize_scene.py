#!/usr/bin/env python3
"""Summarize every fixed-domain comparison without introducing acceptance metrics."""
import argparse
import json
from pathlib import Path
from strict_scene_score import HERE, VIEWS, CASES, require, verify, sha, read_json


def difference(off, on):
    return None if off is None or on is None else on - off


def pair(off, on):
    return {'off': off, 'on': on, 'onMinusOff': difference(off, on)}


def number(x):
    return 'N/A' if x is None else format(x, '.6g')


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--analysis', type=Path, required=True)
    p.add_argument('--analysis-completed-sha256', required=True)
    p.add_argument('--output', type=Path, required=True)
    a = p.parse_args()
    root, output = a.analysis.resolve(), a.output.resolve()
    require(root.is_relative_to(HERE) and output.is_relative_to(HERE) and not output.exists(), 'fresh analysis-code output required')
    complete = read_json(verify(root / 'COMPLETED.json', a.analysis_completed_sha256))
    require(complete['status'] == 'ANALYSIS_COMPLETE_NOT_GLOBAL_ACCEPTANCE', 'analysis incomplete')
    for name, item in complete['files'].items():
        verify(root / name, item['sha256'])
    formal = {arm: read_json(root / ('formal-' + arm + '.json')) for arm in ('off', 'on')}
    descriptive = {arm: read_json(root / ('descriptive-' + arm + '.json')) for arm in ('off', 'on', 'background')}
    summary = {'status': 'DESCRIPTIVE_COMPARISON_NOT_GLOBAL_ACCEPTANCE',
        'analysisCompletedSHA256': a.analysis_completed_sha256, 'sixtyPercentGoal': 'NOT_ESTABLISHED',
        'backgroundNeverFormalCandidate': True, 'conditions': {}, 'domains': {}}
    lines = ['# Fixed camera-background scene comparison', '',
        'OFF and ON retain identical original character geometry. Scene color filling a center-missing pixel does not repair shape.',
        'Formal scores use unchanged v3 mathematics and original foreground. Global acceptance and goal60 remain unestablished. Full-frame, background and control results are descriptive and never pooled into formal quality.', '',
        '## All10 stable-foreground color and fixed full-frame errors', '',
        '| Case | Formal stable RGB MAE OFF | ON | Δ ON−OFF | Full-frame MAE OFF | ON | Background MAE ON |',
        '|---|---:|---:|---:|---:|---:|---:|']
    for view in VIEWS:
        for case in CASES:
            key = view + '-' + case
            f0, f1 = (formal[arm]['conditions'][key] for arm in ('off', 'on'))
            d0, d1, db = (descriptive[arm]['conditions'][key] for arm in ('off', 'on', 'background'))
            require(f0['shapeFullFrame'] == f1['shapeFullFrame'], 'shape changed')
            c0, c1 = (f['colorMeanPrecision']['candidateScores']['stableSubset'] for f in (f0, f1))
            condition = {'formalStableRGBMAE': pair(c0.get('rgbMAE'), c1.get('rgbMAE')),
                'formalStableRGBAgreementPercent': pair(c0.get('rgbAgreementPercent'), c1.get('rgbAgreementPercent')),
                'formalShapeUnchanged': True, 'shape': f0['shapeFullFrame']}
            domains = {}
            for name in d0:
                entry = {'color': {subset: {metric: pair(d0[name]['color'][subset][metric], d1[name]['color'][subset][metric])
                    for metric in ('rgbMAE', 'rgbRMSE', 'signedLumaMeanCandidateMinusReference')}
                    for subset in ('all', 'stable', 'unknown')},
                    'backgroundControlColor': db[name]['color']['all']}
                if case != 'baseline':
                    x, y = (d[name]['response']['confusionAndUnknown'] for d in (d0, d1))
                    entry['responseCounts'] = {metric: pair(x[metric], y[metric]) for metric in
                        ('pixels', 'stable', 'unknown', 'activeToInactive', 'reverse', 'brightFN', 'darkFN', 'brightFP', 'darkFP', 'inactiveFP')}
                    entry['responseMagnitudes'] = {metric: pair(x[metric], y[metric]) for metric in
                        ('stableLumaAbsErrorSum', 'activeReferenceAbsResponseSum', 'activeCandidateAbsResponseSum')}
                domains[name] = entry
            summary['domains'][key] = domains
            if case != 'baseline':
                x, y = (f['response']['candidateScores']['stableSubset'] for f in (f0, f1))
                condition['formalStableResponse'] = {metric: pair(x[metric], y[metric]) for metric in
                    ('directionAgreementPercent', 'responseMagnitudeAgreementPercent', 'deltaLumaRMSE', 'deltaRGBRMSE')}
                condition['formalStableResponse']['brighteningIoU'] = pair(x['brightening']['IoU'], y['brightening']['IoU'])
                condition['formalStableResponse']['darkeningIoU'] = pair(x['darkening']['IoU'], y['darkening']['IoU'])
                condition['foregroundConfusion'] = domains['fullForeground']['responseCounts']
            summary['conditions'][key] = condition
            color = condition['formalStableRGBMAE']
            vals = [color['off'], color['on'], color['onMinusOff'], d0['fullFrame']['color']['all']['rgbMAE'],
                    d1['fullFrame']['color']['all']['rgbMAE'], d1['background']['color']['all']['rgbMAE']]
            lines.append('| ' + key + ' | ' + ' | '.join(map(number, vals)) + ' |')
    lines += ['', 'Negative MAE deltas are lower error. These values are not a new acceptance score.', '',
        '## All8 formal stable response contrasts', '',
        '| Contrast | Direction % OFF→ON | Magnitude % OFF→ON | Bright IoU OFF→ON | Dark IoU OFF→ON |',
        '|---|---:|---:|---:|---:|']
    for key, item in summary['conditions'].items():
        if 'formalStableResponse' not in item: continue
        r = item['formalStableResponse']
        vals = [r[k] for k in ('directionAgreementPercent', 'responseMagnitudeAgreementPercent', 'brighteningIoU', 'darkeningIoU')]
        lines.append('| ' + key + ' | ' + ' | '.join(number(v['off']) + ' → ' + number(v['on']) for v in vals) + ' |')
    lines += ['', '## All8 full-foreground confusion counts', '',
        '| Contrast | Active→inactive OFF→ON | Reverse OFF→ON | Inactive FP OFF→ON | Unknown OFF→ON |',
        '|---|---:|---:|---:|---:|']
    for key, item in summary['conditions'].items():
        if 'foregroundConfusion' not in item: continue
        r = item['foregroundConfusion']
        vals = [r[k] for k in ('activeToInactive', 'reverse', 'inactiveFP', 'unknown')]
        lines.append('| ' + key + ' | ' + ' | '.join(number(v['off']) + ' → ' + number(v['on']) for v in vals) + ' |')
    changes = {'formalRegressions': [], 'foregroundConfusionRegressions': [], 'descriptiveDomainErrorRegressions': []}
    for key, item in summary['conditions'].items():
        value = item['formalStableRGBMAE']
        if value['onMinusOff'] is not None and value['onMinusOff'] > 0:
            changes['formalRegressions'].append({'condition': key, 'metric': 'stableRGBMAE', **value})
        for metric, value in item.get('formalStableResponse', {}).items():
            worse = value['onMinusOff'] is not None and (value['onMinusOff'] > 0 if metric.endswith('RMSE') else value['onMinusOff'] < 0)
            if worse: changes['formalRegressions'].append({'condition': key, 'metric': metric, **value})
        for metric, value in item.get('foregroundConfusion', {}).items():
            if metric not in ('pixels', 'stable', 'unknown') and value['onMinusOff'] > 0:
                changes['foregroundConfusionRegressions'].append({'condition': key, 'metric': metric, **value})
        for domain, values in summary['domains'][key].items():
            for subset, metrics in values['color'].items():
                value = metrics['rgbMAE']
                if value['onMinusOff'] is not None and value['onMinusOff'] > 0:
                    changes['descriptiveDomainErrorRegressions'].append({'condition': key, 'domain': domain, 'subset': subset, **value})
    summary['regressions'] = changes
    lines += ['', '## Preserved regressions', '',
              str(len(changes['formalRegressions'])) + ' worsening formal metrics and ' + str(len(changes['foregroundConfusionRegressions'])) + ' worsening full-foreground confusion counts. Every worsening fixed-domain color subset is retained in COMPARISON.json (' + str(len(changes['descriptiveDomainErrorRegressions'])) + ' overlapping descriptive entries).']
    for row in changes['formalRegressions'] + changes['foregroundConfusionRegressions']:
        lines.append('- ' + row['condition'] + ' ' + row['metric'] + ': ' + number(row['off']) + ' → ' + number(row['on']))
    lines += ['', 'The JSON companion includes every fixed stratum for all10 cases, all FP/FN and unknown counts, and background-control errors. Full detailed reports retain per-seed and uncertain metrics. Unknowns are never counted as passes. Baseline has no response contrast.', '',
        'Full-frame/background gains do not imply foreground response gains, character lighting improvements, repaired geometry, old-budget compliance, device fit or global acceptance. Original old1M/8M negative composition gates remain negative; added host-budget accounting is reported separately.', '']
    output.mkdir()
    (output / 'COMPARISON.json').write_text(json.dumps(summary, indent=2, allow_nan=False) + '\n')
    (output / 'REPORT.md').write_text('\n'.join(lines))
    inventory = {name: sha(output / name) for name in ('COMPARISON.json', 'REPORT.md')}
    (output / 'COMPLETED.json').write_text(json.dumps({'status': 'COMPARISON_COMPLETE_NOT_ACCEPTANCE', 'files': inventory,
        'sourceAnalysisCompletedSHA256': a.analysis_completed_sha256, 'summarizerSHA256': sha(Path(__file__))}, indent=2) + '\n')
    print('ALL_FIXED_DOMAINS_COMPARED', output)


if __name__ == '__main__':
    main()
