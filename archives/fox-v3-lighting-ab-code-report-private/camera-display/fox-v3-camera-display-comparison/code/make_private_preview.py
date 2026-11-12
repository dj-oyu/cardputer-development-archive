"""Original-size, ordinary RGB565 decode only; never scoring/bundle input."""
from common import *
from PIL import Image
O=R/'run-001';j=json.load(open(O/'COMPLETED.json'));f=next(x for x in j['frames'] if (x['view'],x['case'])==('oblique','baseline'));p=O/'agx-oblique-baseline.u16le';assert sha(p)==f['agxSHA256'];v=np.fromfile(p,'<u2').reshape(135,240);rgb=np.stack([(v>>11)*255/31,((v>>5)&63)*255/63,(v&31)*255/31],axis=-1);dest=R/'private-preview';dest.mkdir(exist_ok=True);q=dest/'oblique-baseline-agx.png';assert not q.exists();Image.fromarray(np.rint(rgb).astype(np.uint8),'RGB').save(q);print(q)
