#!/usr/bin/env python3
"""Package native evidence; all work is local and no API/device is invoked."""
from pathlib import Path
import argparse
import hashlib
import json
import zipfile

p = argparse.ArgumentParser()
p.add_argument('--phase', choices=['source-build', 'device-final'], required=True)
args = p.parse_args()
root = Path(__file__).resolve().parent
files = sorted(p for p in root.rglob('*') if p.is_file() and p.name != 'SHA256SUMS' and '__pycache__' not in p.parts)
if args.phase == 'source-build':
    files = [p for p in files if not p.name.startswith('INDEPENDENT-NATIVE-SOURCE-BUILD')]
items = [(p, 'native/' + str(p.relative_to(root))) for p in files]
if args.phase == 'device-final':
    prior = root.parent / 'derby-controller-native-source-build-private-20261020.zip'
    expected = json.loads((root.parent / 'CONTROLLER-NATIVE-SOURCE-BUILD-ARCHIVE.json').read_text())['sha256']
    assert hashlib.sha256(prior.read_bytes()).hexdigest() == expected
    items.append((prior, 'native-source-build-v0.zip'))
manifest = ''.join(hashlib.sha256(p.read_bytes()).hexdigest() + '  ' + name + '\n' for p, name in items)
(root / 'SHA256SUMS').write_text(manifest)
archive = root.parent / ('derby-controller-native-' + args.phase + '-private-20261020.zip')
with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED, compresslevel=6) as z:
    for path, name in items:
        z.write(path, name)
    z.writestr('SHA256SUMS', manifest)
with zipfile.ZipFile(archive) as z:
    assert z.testzip() is None
    for line in z.read('SHA256SUMS').decode().splitlines():
        expected, name = line.split('  ', 1)
        assert hashlib.sha256(z.read(name)).hexdigest() == expected, name
info = {'path': str(archive), 'bytes': archive.stat().st_size, 'sha256': hashlib.sha256(archive.read_bytes()).hexdigest(), 'manifest_files': len(items), 'phase': args.phase, 'firmware_bodies_included': False}
(root.parent / ('CONTROLLER-NATIVE-' + args.phase.upper() + '-ARCHIVE.json')).write_text(json.dumps(info, indent=2) + '\n')
print(json.dumps(info))
