#!/usr/bin/env python3
"""Check exact shared shading independently against the frozen original shader."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import platform
import subprocess
import sys

TEST = Path(__file__).resolve().parent
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--baseline-dir', type=Path, required=True)
parser.add_argument('--candidate-dir', type=Path, required=True)
parser.add_argument('--output-dir', type=Path, required=True)
parser.add_argument('--disable-leak-sanitizer', action='store_true')
parser.add_argument('--leak-sanitizer-disabled-reason', default='explicit caller opt-out')
args = parser.parse_args()
OUT = args.output_dir.resolve()
OUT.mkdir(parents=True, exist_ok=True)
ROOTS = {'baseline': args.baseline_dir.resolve(), 'candidate': args.candidate_dir.resolve()}
BASE = ['-std=c11', '-Wall', '-Wextra', '-Werror', '-ffp-contract=off', '-fexcess-precision=standard', '-fno-fast-math']
SAN = ['-g', '-fsanitize=address,undefined', '-fno-omit-frame-pointer', '-no-pie']
CONFIGS = {'O0': ['-O0'], 'O2': ['-O2'], 'asan_ubsan_O0': ['-O0', *SAN], 'asan_ubsan_O2': ['-O2', *SAN]}

def run(command, **kwargs):
    return subprocess.run([str(v) for v in command], capture_output=True, text=True, **kwargs)

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def identities():
    return {
        'sources': {name: {str(p.relative_to(root)): sha(p) for p in sorted((root / 'main').rglob('*'))
                           if p.is_file() and p.suffix in ('.c', '.h', '.inc')}
                    for name, root in ROOTS.items()},
        'harness': {name: sha(TEST / name) for name in ['shade_terms_stress.c', 'run_shade_stress.py']},
    }

report = {
    'scope': 'Synthetic finite numeric inputs only. Frozen original shader versus shared per-normal terms for two albedos. No assets, network, devices, timing, or target FPS claims.',
    'compiler': run(['cc', '--version']).stdout.splitlines()[0],
    'host': {'machine': platform.machine(), 'system': platform.system()},
    'floating_point': 'binary32, FE_TONEAREST, contraction off, standard excess precision, no fast-math',
    'instrumentation_limit': 'COUNT_MATH=1 counts source-level libm invocations and can inhibit compiler optimization. Separate COUNT_MATH=0 runs validate uninstrumented exactness. Counts are not native instruction counts or timing.',
    'leak_sanitizer': {'enabled': not args.disable_leak_sanitizer,
                       'disabled_reason': args.leak_sanitizer_disabled_reason if args.disable_leak_sanitizer else None},
    'identities_start': identities(), 'configs': {},
}

def save():
    (OUT / 'stress.json').write_text(json.dumps(report, indent=2) + '\n')

for cfg, flags in CONFIGS.items():
    for counted in (0, 1):
        key = cfg + ('_counted' if counted else '_plain')
        folder = OUT / key
        folder.mkdir(exist_ok=True)
        entry = {'flags': BASE + flags, 'instrumented': bool(counted), 'identities_start': identities()}
        report['configs'][key] = entry
        command = ['cc', *BASE, *flags, '-DCOUNT_MATH=' + str(counted)]
        for name, root in ROOTS.items():
            command.append('-D' + name.upper() + '_SHADE_HEADER="' + str(root / 'main/ayatsuri/ayatsuri_shade.h') + '"')
        command += [TEST / 'shade_terms_stress.c', '-lm', '-o', folder / 'stress']
        result = run(command)
        (folder / 'build.log').write_text(' '.join(map(str, command)) + '\n' + result.stdout + result.stderr)
        entry['build_exit_code'] = result.returncode
        if result.returncode == 0:
            result = run([folder / 'stress'], env={**os.environ,
                'ASAN_OPTIONS': ('detect_leaks=0' if args.disable_leak_sanitizer else 'detect_leaks=1') + ':halt_on_error=1',
                'UBSAN_OPTIONS': 'halt_on_error=1:print_stacktrace=1'})
            (folder / 'run.log').write_text(result.stdout + result.stderr)
            entry['run_exit_code'] = result.returncode
            if result.returncode == 0:
                try:
                    entry['result'] = json.loads(result.stdout)
                except ValueError:
                    entry['parse_error'] = 'Expected one JSON result from harness.'
        entry['identities_end'] = identities()
        entry['sources_stable'] = entry['identities_start'] == entry['identities_end']
        entry['status'] = 'passed' if (entry['sources_stable'] and entry.get('run_exit_code') == 0
            and entry.get('result', {}).get('passed') and entry['result']['cases'] > 0) else 'failed'
        save()
        print(key + ': ' + entry['status'], flush=True)

report['identities_end'] = identities()
report['sources_stable'] = report['identities_start'] == report['identities_end']
digests = {e['result']['digest'] for e in report['configs'].values() if 'result' in e}
report['all_configs_identical_digest'] = len(digests) == 1 and len(report['configs']) == 8 and all('result' in e for e in report['configs'].values())
report['passed'] = report['sources_stable'] and report['all_configs_identical_digest'] and all(e['status'] == 'passed' for e in report['configs'].values())
save()
def count_text(result, key):
    value = result.get(key)
    return f"{value:,}" if isinstance(value, int) else "unavailable"

plain = report['configs'].get('O2_plain', {}).get('result', {})
counted = report['configs'].get('O2_counted', {}).get('result', {})
lines = [
    '# Shared shading stress result', '',
    'Status: ' + ('PASS' if report['passed'] else 'FAIL') + '.', '',
    f"Compiler: {report['compiler']}. Host: {platform.machine()} {platform.system()}.",
    'O0 and O2, each plain and separately instrumented, plus ASan+UBSan at both optimization levels.',
    'Strict binary32 arithmetic: FE_TONEAREST, no fast-math, FP contraction off, standard excess precision.', '',
    f"Cases per configuration: {count_text(plain, 'cases')}. All 8 result digests identical: {report['all_configs_identical_digest']}.",
    f"Shared-output RGB565 comparisons per configuration: {count_text(plain, 'paired_color_checks')}; wrapper RGB565 comparisons: {count_text(plain, 'wrapper_color_checks')}.",
    f"Bitwise term comparisons per configuration: {count_text(plain, 'term_bit_checks')}. Baseline/candidate normalized basis and half-vector flags also compared.", '',
    '## Coverage', '',
    '- Nonzero SNORM16 normals, axes, grazing one-quantum normals, and separately quantized opposite-side half ties.',
    '- Finite light/view directions from FLT_TRUE_MIN through FLT_MAX, signed zero, exact opposing directions, and near-cancelled half vectors.',
    '- Material exponents 1 and 128, near-1 and fractional exponents; other coefficients in the accepted [0,1] range.',
    '- Thickness 0, 1, 127, 128, 254, and 255; randomized byte thicknesses.',
    '- All 65,536 RGB565 albedos in each color slot across eight scenarios; below/at/above float rounding thresholds for 31- and 63-step channels.',
    '- 200,000 deterministic xorshift cases; fixed seed 0x9e3779b9.',
    '- Zero, infinity, and NaN direction rejection checked separately; invalid directions never passed to sample.', '',
    '## Sharing evidence and limits', '',
    'Instrumented O2 source-call totals across all tested pairs of colors:',
    '- Baseline: ' + json.dumps(counted.get('baseline_math_calls', {})) + '.',
    '- Candidate: ' + json.dumps(counted.get('candidate_math_calls', {})) + '.',
    'Each pair requires exactly two baseline normal sqrt calls versus one shared candidate normal sqrt call. Conditional pow calls halve; channel round calls remain six. Direction preparation and oracle calls are excluded from these totals.',
    'Instrumentation proves source-call reuse only. It can inhibit optimization and does not establish emitted instruction savings, register spills, elapsed time, hardware throughput, or device FPS. Plain builds separately verify that uninstrumented optimization preserves results.',
    'The term oracle reproduces the original expression ordering independently of the new term API; the unchanged frozen baseline shader is the primary final-color oracle.', '',
    '## Sanitizer scope', '',
    ('LeakSanitizer disabled: ' + args.leak_sanitizer_disabled_reason + ' No leak-test claim.' if args.disable_leak_sanitizer else 'LeakSanitizer enabled.'),
    'ASan and UBSan remain enabled for all four sanitizer configurations. Source and harness hashes checked before and after each run.',
    'This is host binary32 differential testing, not proof for every input, other compilers/architectures, fast-math, or a device integration test.', '',
    'Reproduce:', '',
    'python3 tests/run_shade_stress.py --baseline-dir baseline --candidate-dir candidate --output-dir results/shade_stress' +
    (' --disable-leak-sanitizer --leak-sanitizer-disabled-reason "' + args.leak_sanitizer_disabled_reason + '"' if args.disable_leak_sanitizer else ''), '',
    'Machine-readable counts, status, options, hashes, and logs: stress.json and the per-configuration folders.', '',
]
(OUT / 'REPORT.md').write_text('\n'.join(lines))
print(json.dumps({'passed': report['passed'], 'cases_per_configuration': plain.get('cases'), 'digest': plain.get('digest'),
                  'all_configs_identical_digest': report['all_configs_identical_digest']}, indent=2))
sys.exit(0 if report['passed'] else 1)
