from PIL import Image,ImageDraw
import pathlib,json
P=pathlib.Path(__file__).resolve().parent;d=json.load(open(P/'source-projected-strokes.json'))
meta={'resolution':[128,64],'supersample':4,'channels':'8-bit scalar coverage, opaque receiver color mix; no transparent geometry','regions':{'brow':[-.42,.42,2.68,3.13],'mouth':[-.38,.38,2.075,2.34]},'states':{n:v['controls'] for n,v in d.items()}}
for n,v in d.items():
 for group in ['brow','mouth']:
  x0,x1,z0,z1=meta['regions'][group];im=Image.new('L',(512,256));draw=ImageDraw.Draw(im)
  for t in v[group]:draw.polygon([((p[0]-x0)/(x1-x0)*512,(z1-p[2])/(z1-z0)*256) for p in t],fill=255)
  im.resize((128,64),Image.Resampling.LANCZOS).save(P/f'{group}-{n}-mask.png')
(P/'mask-spec.json').write_text(json.dumps(meta,indent=2));print('MASKS_READY')
