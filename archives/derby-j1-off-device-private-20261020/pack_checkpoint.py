"""Update this single private Library artifact; prior Library versions persist."""
from pathlib import Path
import hashlib
import json
import zipfile

root = Path(__file__).resolve().parent
archive = root.parent / 'derby-j1-off-device-private-20261020.zip'
files = sorted(p for p in root.rglob('*') if p.is_file() and p.name != 'MANIFEST.json')
manifest = dict(private=True, scope='J1 OFF build/device comparison evidence', files=[
    dict(path=str(p.relative_to(root)), bytes=p.stat().st_size, sha256=hashlib.sha256(p.read_bytes()).hexdigest())
    for p in files])
(root/'MANIFEST.json').write_text(json.dumps(manifest, indent=2)+'\n')
with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED) as z:
    for path in sorted(root.rglob('*')):
        if path.is_file():
            z.write(path, path.relative_to(root))
archive.chmod(0o600)
print(json.dumps(dict(path=str(archive), bytes=archive.stat().st_size,
                     sha256=hashlib.sha256(archive.read_bytes()).hexdigest(), manifest_entries=len(files))))
