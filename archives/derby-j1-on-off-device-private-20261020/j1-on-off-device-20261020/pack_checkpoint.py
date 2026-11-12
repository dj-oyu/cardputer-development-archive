#!/usr/bin/env python3
from pathlib import Path
import hashlib,json,zipfile
root=Path(__file__).resolve().parent
files=sorted(p for p in root.rglob('*') if p.is_file() and p.name!='MANIFEST.json' and '__pycache__' not in p.parts)
manifest=[{'path':str(p.relative_to(root)),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in files]
(root/'MANIFEST.json').write_text(json.dumps(manifest,indent=2)+'\n')
packet=root.parent/'derby-j1-on-off-device-private-20261020.zip'
with zipfile.ZipFile(packet,'w',zipfile.ZIP_DEFLATED) as z:
 for p in sorted(root.rglob('*')):
  if p.is_file() and '__pycache__' not in p.parts:z.write(p,root.name+'/'+str(p.relative_to(root)))
packet.chmod(0o600)
out={'path':str(packet),'bytes':packet.stat().st_size,'sha256':hashlib.sha256(packet.read_bytes()).hexdigest(),'manifest_entries':len(files)}
(root.parent/'J1-ON-OFF-DEVICE-PACKET.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out))

