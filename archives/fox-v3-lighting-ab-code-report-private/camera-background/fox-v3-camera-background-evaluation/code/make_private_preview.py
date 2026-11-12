"""Original-size RGB565 to PNG8. Display only, never scoring or bundle input."""
from pathlib import Path
import sys,json,hashlib,numpy as np
from PIL import Image
D=Path(sys.argv[1]);done=json.load(open(D/'on/COMPLETED.json'));row=next(r for r in done['frames'] if (r['view'],r['case'],r['reverse'])==('oblique','baseline',False));p=D/'on'/row['prefix'];raw=Path(str(p)+'.u16le');assert hashlib.sha256(raw.read_bytes()).hexdigest()==row['files']['.u16le'];v=np.fromfile(raw,'<u2').reshape(135,240);rgb=np.stack([(v>>11)*255/31,((v>>5)&63)*255/63,(v&31)*255/31],axis=-1);out=D.parent/'private-preview';out.mkdir(exist_ok=True);target=out/'oblique-baseline-on.png';assert not target.exists();Image.fromarray(np.rint(rgb).astype(np.uint8),'RGB').save(target);print(target)
