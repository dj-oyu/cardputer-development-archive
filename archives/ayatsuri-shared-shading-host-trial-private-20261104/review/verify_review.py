#!/usr/bin/env python3
"""Independent review checks; do not alter product sources or supplied tests."""
from pathlib import Path
import hashlib
import json
import os
import subprocess

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'review' / 'recheck'
OUT.mkdir(parents=True, exist_ok=True)

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def run(cmd, log):
    p = subprocess.run([str(x) for x in cmd], capture_output=True, text=True,
        env={**os.environ, 'ASAN_OPTIONS': 'detect_leaks=0:halt_on_error=1',
             'UBSAN_OPTIONS': 'halt_on_error=1:print_stacktrace=1'})
    log.write_text(' '.join(str(x) for x in cmd) + '\n' + p.stdout + p.stderr)
    if p.returncode:
        raise RuntimeError(f'{log}: exit {p.returncode}')
    return p.stdout

report = {'recorded_matrix_checks': [], 'recorded_stress_checks': {}, 'fresh_O2': {}}
freeze = json.loads((ROOT / 'BASE_SOURCE_FREEZE.json').read_text())
assert all(sha(ROOT / 'baseline' / p) == h for p, h in freeze['files'].items())
report['baseline_freeze_verified'] = True
for suite, source in [('paired-colors', 'candidate'), ('bounded-colors', 'candidate-bounded')]:
    directory = ROOT / 'results' / suite
    data = json.loads((directory / 'matrix.json').read_text())
    assert data['passed'] and data['sources_stable']
    for identity in [data['identities_start'], data['identities_end']]:
        for variant, tree in [('baseline', 'baseline'), ('candidate', source)]:
            for path, h in identity['sources'][variant].items():
                assert sha(ROOT / tree / path) == h
        for path, h in identity['harness'].items():
            assert sha(ROOT / 'tests' / path) == h
        for name, h in identity['fixtures'].items():
            assert sha(directory / 'fixtures' / (name + '.aynm')) == h
    for config, value in data['configs'].items():
        if config == 'm32':
            assert value['status'] == 'not_run' and not data['m32_toolchain_probe']['available']
            continue
        assert value['status'] == 'passed'
        for name, pair in value['fixtures'].items():
            a = directory / config / ('baseline_' + name + '.bin')
            b = directory / config / ('candidate_' + name + '.bin')
            assert a.read_bytes() == b.read_bytes()
            assert sha(a) == pair['baseline']['sha256'] == pair['candidate']['sha256']
            assert (directory / config / ('baseline_' + name + '.tsv')).read_bytes() == (directory / config / ('candidate_' + name + '.tsv')).read_bytes()
            report['recorded_matrix_checks'].append({'suite': suite, 'config': config,
                'fixture': name, 'bytes': a.stat().st_size, 'sha256': sha(a)})
for suite, source in [('shade_stress', 'candidate'), ('shade_stress_bounded', 'candidate-bounded')]:
    directory = ROOT / 'results' / suite
    data = json.loads((directory / 'stress.json').read_text())
    assert data['passed'] and data['sources_stable'] and data['all_configs_identical_digest']
    assert len(data['configs']) == 8
    for identity in [data['identities_start'], data['identities_end']]:
        for variant, tree in [('baseline', 'baseline'), ('candidate', source)]:
            for path, h in identity['sources'][variant].items():
                assert sha(ROOT / tree / path) == h
        for path, h in identity['harness'].items():
            assert sha(ROOT / 'tests' / path) == h
    for config, value in data['configs'].items():
        assert value['status'] == 'passed' and value['build_exit_code'] == value['run_exit_code'] == 0
        result = json.loads((directory / config / 'run.log').read_text())
        assert result == value['result'] and result['cases'] == 775078 and result['failures'] == 0
        assert result['digest'] == '292ef07cc5ef172f'
    report['recorded_stress_checks'][suite] = {'configs': 8, 'cases_per_config': 775078,
        'digest': '292ef07cc5ef172f'}

flags = ['-std=c11', '-O2', '-ffp-contract=off', '-fexcess-precision=standard', '-fno-fast-math']
sources = ['main/ayatsuri/ayatsuri_model.c', 'main/ayatsuri/ayatsuri_visibility.c',
    'main/ayatsuri/compact_opaque.c', 'main/ui/kasane/ksn_procedural.c', 'main/ui/kasane/ksn_mesh_depth.c']
for variant in ['baseline', 'candidate', 'candidate-bounded']:
    tree = ROOT / variant
    exe = OUT / (variant + '_production')
    run(['cc', *flags, '-ffunction-sections', '-fdata-sections', '-I' + str(tree / 'main'),
        '-DCANDIDATE=1', ROOT / 'tests/evaluate_test.c', *[tree / p for p in sources],
        '-Wl,--gc-sections', *['-Wl,--wrap=' + f for f in ['malloc', 'calloc', 'realloc', 'free']],
        '-lm', '-o', exe], OUT / (variant + '_production.build.log'))
    result = {}
    for fixture in ['mixed', 'mesh_only']:
        output = OUT / (variant + '_' + fixture + '.bin')
        tsv = OUT / (variant + '_' + fixture + '.tsv')
        result[fixture] = json.loads(run([exe, ROOT / 'tests' / (fixture + '.aynm'), output, tsv],
            OUT / (variant + '_' + fixture + '.run.log')))
        expected = ROOT / 'results/paired-colors/O2' / ('baseline_' + fixture + '.bin')
        assert output.read_bytes() == expected.read_bytes()
        result[fixture]['sha256'] = sha(output)
    if variant != 'baseline':
        exe = OUT / (variant + '_stress')
        run(['cc', *flags, '-Wall', '-Wextra', '-Werror', '-DCOUNT_MATH=0',
            '-DBASELINE_SHADE_HEADER="' + str(ROOT / 'baseline/main/ayatsuri/ayatsuri_shade.h') + '"',
            '-DCANDIDATE_SHADE_HEADER="' + str(tree / 'main/ayatsuri/ayatsuri_shade.h') + '"',
            ROOT / 'tests/shade_terms_stress.c', '-lm', '-o', exe], OUT / (variant + '_stress.build.log'))
        result['stress'] = json.loads(run([exe], OUT / (variant + '_stress.run.log')))
        assert result['stress']['passed'] and result['stress']['digest'] == '292ef07cc5ef172f'
    report['fresh_O2'][variant] = result
report['passed'] = True
(OUT / 'verification.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps({'passed': True, 'matrix_pairs_verified': len(report['recorded_matrix_checks']),
    'fresh_production_runs': 6, 'fresh_stress_runs': 2, 'report': str(OUT / 'verification.json')}))
