"""Same camera overlays with hair-only projected meshes and native pixel measurement."""
from PIL import Image,ImageDraw,ImageFont,ImageFilter,ImageChops
import json
from pathlib import Path
import numpy as np
root=Path(__file__).resolve().parent
a,b=[json.loads((root/(k+'-projection.json')).read_text()) for k in ('before','after')]
font='/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc'
f=lambda s:ImageFont.truetype(font,s,index=0)
panel=Image.new('RGB',(1270,908),'#1d262c');d=ImageDraw.Draw(panel)
d.text((20,12),'髪の輪郭  中腹だけ少し内へ、裾の丸みは残す',font=f(25),fill='#f5ede0')
d.text((20,47),'輪郭：橙＝変更前、青緑＝調整後。立体の毛束・表情・塗りはそのまま。',font=f(17),fill='#c5d2dc')
def bg(im):
 im=im.convert('RGBA')
 base=Image.new('RGBA',im.size,(227,219,203,255));base.alpha_composite(im);return base
def mask(j,name):
 k=j['projected'][name];w,h=k['resolution'];scale=4
 img=Image.new('L',(w*scale,h*scale));dg=ImageDraw.Draw(img)
 for tri in k['triangles']:
  dg.polygon([tuple(round(c*scale) for c in p) for p in tri],fill=255)
 return img.resize((w,h),Image.Resampling.LANCZOS)
proof={}
for idx, (v,label,deg) in enumerate((('front','正面','0'),('oblique','斜め35°','-35'),('back','後ろ','180'))):
 x=20+idx*310
 d.text((x,78),label,font=f(18),fill='#f7f1e7')
 source='face-'+v
 im=[bg(Image.open(root/k/(source+'.png'))) for k in ('before','after')]
 # Show rendered changes and the independent hair-only contour.
 overlay=im[1].copy()
 for j,color in ((a,(254,130,57)),(b,(58,216,198))):
   m=mask(j,source).point(lambda p:255 if p>=128 else 0)
   edge=ImageChops.subtract(m.filter(ImageFilter.MaxFilter(3)),m.filter(ImageFilter.MinFilter(3)))
   layer=Image.new('RGBA',m.size,color);layer.putalpha(edge.point(lambda p:p if p<200 else 200));overlay.alpha_composite(layer)
 for k,(im0,y,title) in enumerate(zip((im[0],im[1],overlay),(104,369,634),('変更前','調整後','髪のみの輪郭を重ねた比較'))):
   panel.paste(im0.resize((292,260),Image.Resampling.LANCZOS).convert('RGB'),(x,y));d.text((x+5,y+5),title,font=f(14),fill='#182834')
 native='native-'+v
 na,nb=[np.asarray(mask(j,native))>=128 for j in (a,b)]
 s1=a['sections']['4.64'][deg];s2=b['sections']['4.64'][deg]
 subtotal=lambda p:round((1-s2[p][2]/s1[p][2])*100,3)
 proof[v]={'cap_width_at_z_4_64':[s1['cap'][2],s2['cap'][2]],'all_hair_width_at_z_4_64':[s1['all_hair'][2],s2['all_hair'][2]],'cap_narrow_percent':subtotal('cap'),'all_hair_narrow_percent':subtotal('all_hair'),'native_mask_pixels_changed':int(np.logical_xor(na,nb).sum()),'native_hair_area':[int(na.sum()),int(nb.sum())]}
 assert all(abs(a['sections'][z][deg]['all_hair'][2]-b['sections'][z][deg]['all_hair'][2])<1.e-7 for z in ('4.26','4.32'))
 bounds=[b['sections'][str(z)][deg]['cap'] for z in (4.43,4.50,4.57,4.64,4.71,4.78,4.85,4.92)]
 assert all(l[0]<=r[0] and (l[1]>=r[1] or v=='oblique') for l,r in zip(bounds,bounds[1:])),bounds
 if v=='oblique':
  assert all(abs(a['sections'][z][deg]['all_hair'][1]-b['sections'][z][deg]['all_hair'][1])<.01 for z in ('4.5','4.57','4.64','4.71','4.78','4.85','4.92'))
native_x=963
d.text((native_x,78),'240×135  斜め / 後ろ',font=f(17),fill='#f7f1e7')
for k,y in (('before',104),('after',369)):
 for v,x in [('oblique',native_x),('back',native_x+147)]:
  im=bg(Image.open(root/k/('native-'+v+'.png'))).crop((99,1,146,50)).resize((141,147),Image.Resampling.NEAREST)
  panel.paste(im.convert('RGB'),(x,y))
d.text((native_x,649),'中腹の横幅',font=f(16),fill='#e2eee9')
d.text((native_x,680),f"正面・後ろ：約{proof['front']['all_hair_narrow_percent']:.1f}%減",font=f(16),fill='#d3dce4')
d.text((native_x,713),f"斜め：約{proof['oblique']['all_hair_narrow_percent']:.1f}%減",font=f(16),fill='#d3dce4')
d.text((native_x,744),'裾は維持',font=f(16),fill='#d3dce4')
d.text((native_x,865),'Blender比較・実機未検証',font=f(13),fill='#c0ccd3')
panel.save(root/'hair-trim-private-review.png')
assert a['temple_triangle_pair_contacts']==b['temple_triangle_pair_contacts']
(root/'outline-proof.json').write_text(json.dumps({'width_measurement_z_BU':4.64,'views':proof,'lower_z_4_26_and_4_32_width_exact':True,'visible_trimmed_cap_edges_monotone_at_sampled_4_43_to_4_92':True,'temple_face_pair_overlap_unchanged':a['temple_triangle_pair_contacts']},indent=2)+'\n')
