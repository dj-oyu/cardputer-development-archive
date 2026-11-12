#!/usr/bin/env python3
"""Package baseline ON success and preserve prior stop/review v1 intact."""
from pathlib import Path
import hashlib
import json
import zipfile

root = Path(__file__).resolve().parent
prior = root.parent / 'derby-controller-baseline-device-gate-review-private-20261020.zip'
assert hashlib.sha256(prior.read_bytes()).hexdigest() == 'e7d4158dc169ea2e2f46b223c94cef876a75139a7dc4f46b8f62f0c9035e5c20'
files = sorted(p for p in root.rglob('*') if p.is_file() and p.name != 'SHA256SUMS' and '__pycache__' not in p.parts)
items = [(p, 'baseline-current-receipt/' + str(p.relative_to(root))) for p in files]
items.append((prior, 'prior-stop-and-receipt-review-v1.zip'))
manifest = ''.join(hashlib.sha256(p.read_bytes()).hexdigest() + '  ' + name + '\n' for p, name in items)
(root / 'SHA256SUMS').write_text(manifest)
archive = root.parent / 'derby-controller-baseline-on-accepted-private-20261020.zip'
with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED, compresslevel=6) as zipped:
    for path, name in items:
        zipped.write(path, name)
    zipped.writestr('SHA256SUMS', manifest)
with zipfile.ZipFile(archive) as zipped:
    assert zipped.testzip() is None
    for line in zipped.read('SHA256SUMS').decode().splitlines():
        expected, name = line.split('  ', 1)
        assert hashlib.sha256(zipped.read(name)).hexdigest() == expected, name
info = {
    'path': str(archive), 'bytes': archive.stat().st_size,
    'sha256': hashlib.sha256(archive.read_bytes()).hexdigest(), 'manifest_files': len(items),
    'prior_v1_sha256': hashlib.sha256(prior.read_bytes()).hexdigest(),
    'scope': 'Baseline dc2c5e04 exact flash/readback/boot and strict ON one fresh boot/three dependent replays accepted; prior stop and receipt review v1 nested intact; no BIN/ELF bodies or live capability',
}
(root.parent / 'CONTROLLER-BASELINE-ACCEPTED-ARCHIVE.json').write_text(json.dumps(info, indent=2) + '\n')
print(json.dumps(info))
