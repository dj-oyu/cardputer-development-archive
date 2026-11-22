"""Draw project-native makeup atlases for the preexisting 1024×1024 face UV."""
import math
from pathlib import Path
from PIL import Image, ImageDraw, ImageChops, ImageFilter
import numpy as np
P=Path(__file__).resolve().parent/'assets'
im=Image.open(P/'neutral.png').convert('RGBA')
assert im.size==(1024,1024)
C=1026
EYE_LEFT=[(331,476),(362,488),(398,473),(435,472),(470,487),(484,528),(484,575),(480,590),(466,599),(429,604),(389,599),(363,581),(345,549),(336,520),(331,500)]
MIRROR=lambda x: 1026-x
def mx(pts):return [(MIRROR(x),y) for x,y in pts]
EYE_RIGHT=mx(EYE_LEFT)
ink=(55,26,18,255)
line=(94,40,29,255)
brow=(85,40,25,246)
brow_side=(105,55,31,240)
blushline=(190,82,65,240)
shadow=(61,20,22,255)
inside=(108,33,33,255)
peach=(251,142,120,254)
offwhite=(255,242,220,255)
def clear(o, polys):
 mask=Image.new('L',im.size);d=ImageDraw.Draw(mask)
 for p in polys:d.polygon(p,fill=255)
 a=o.getchannel('A')
 o.putalpha(ImageChops.subtract(a,mask))
def section(x0,y0,x1,y1):return [(x0,y0),(x1,y0),(x1,y1),(x0,y1)]
BROWS=[section(330,409,485,473),section(541,409,696,473)]
MOUTH=[section(435,626,590,704)]
def sample(c1,c2,c3,c4,n=28):
 out=[]
 for k in range(n+1):
  t=k/n;u=1-t
  out.append((u*u*u*c1[0]+3*u*u*t*c2[0]+3*u*t*t*c3[0]+t*t*t*c4[0],u*u*u*c1[1]+3*u*u*t*c2[1]+3*u*t*t*c3[1]+t*t*t*c4[1]))
 return out
def poly(ar,points,color): ImageDraw.Draw(ar,'RGBA').polygon(points,fill=color) 
def oval(ar,x,y,w,h,fill,outline=None,width=1):ImageDraw.Draw(ar,'RGBA').ellipse((x-w/2,y-h/2,x+w/2,y+h/2),fill=fill,outline=outline,width=width)
def curve(ar,a,b,c,d,col,width):
 p=sample(a,b,c,d)
 q=ImageDraw.Draw(ar,'RGBA');q.line(p,width=width,fill=col,joint='curve')
 for x,y in (a,d):
  w=width/2;q.ellipse((x-w,y-w,x+w,y+w),fill=col)
def load_skin(state):
 o=im.copy()
 clear(o,BROWS+MOUTH+( [EYE_LEFT,EYE_RIGHT] if state!='worried' else [] ))
 return o
def twobrows(o,p):
 poly(o,p,brow)
 poly(o,mx(p),brow)
# Golden markings and previously established head/cheek/eye UV remain in place for the worried state.
o=load_skin('worried')
p=sample((347,465),(387,465),(420,428),(468,422))+sample((468,422),(471,425),(476,438),(466,443))+sample((466,443),(429,446),(386,479),(347,465))
twobrows(o,p)
curve(o,(469,656),(489,630),(530,628),(557,655),line,14)
curve(o,(487,660),(504,654),(519,654),(537,659),(212,110,80,195),6)
o.save(P/'face-worried.png',optimize=True)
# Awake rounded whites, familiar amber irises, smaller pupil and fine highlights.
o=load_skin('surprised')
for lr in (1,-1):
 x=411 if lr==1 else 615;y=540
 oval(o,x,y,132,125,ink)
 oval(o,x+lr*2,y+4,109,105,offwhite)
 oval(o,x+lr*8,y+6,65,83,(158,78,22,255))
 oval(o,x+lr*8,y+11,56,72,(206,105,21,255))
 oval(o,x+lr*8,y+24,49,40,(237,145,39,255))
 oval(o,x+lr*8,y+4,31,50,(46,20,13,255))
 oval(o,x+lr*17,y-15,16,17,(255,249,224,255))
 oval(o,x+lr*1,y+23,8,8,(255,243,196,255))
 p=[(x-lr*65,y-45),(x-lr*78,y-58),(x-lr*68,y-31),(x-lr*55,y-21)]
 poly(o,p,ink)
p=sample((348,450),(379,413),(437,409),(474,445))+sample((474,445),(438,428),(390,437),(348,450))
twobrows(o,p)
oval(o,513,656,75,57,line)
oval(o,513,656,60,44,shadow)
oval(o,513,669,38,15,peach)
o.save(P/'face-surprised.png',optimize=True)
# Two true black/dark dots and hand-drawn epsilon, matching the established cloud/fox comic reduction.
o=load_skin('gag')
for x in (418,608):oval(o,x,551,49,54,(39,21,17,255))
p=sample((357,471),(387,451),(429,452),(462,466))+sample((462,466),(426,464),(388,465),(357,471))
twobrows(o,p)
curve(o,(558,642),(506,617),(458,638),(519,653),ink,19)
curve(o,(519,653),(467,662),(485,684),(559,674),ink,19)
o.save(P/'face-gag.png',optimize=True)
# Half-mast eyelids and small yawn; not identical to the legacy closed-eye blink.
o=load_skin('sleepy')
p=sample((347,464),(386,473),(427,459),(470,450))+sample((470,450),(474,455),(468,468),(455,470))+sample((455,470),(422,470),(375,482),(347,464))
twobrows(o,p)
def sleepy_eye(o,flip=False):
 q=sample((345,533),(383,551),(445,555),(478,542))+sample((478,542),(476,575),(449,589),(416,584))+sample((416,584),(380,579),(354,561),(345,533))
 if flip:q=mx(q)
 poly(o,q,ink)
 q=sample((361,548),(389,556),(433,561),(470,552))+sample((470,552),(461,574),(437,577),(417,577))+sample((417,577),(391,575),(371,565),(361,548))
 if flip:q=mx(q)
 poly(o,q,offwhite)
 mask=Image.new('L',im.size,0);ImageDraw.Draw(mask).polygon(q,fill=255)
 eye=Image.new('RGBA',im.size)
 cx=428 if not flip else MIRROR(428)
 oval(eye,cx,554,49,60,(165,89,26,255));oval(eye,cx,557,36,44,(194,105,32,255))
 oval(eye,cx,552,22,42,ink);oval(eye,cx+6*(1 if not flip else -1),557,8,8,(255,248,217,255))
 eye.putalpha(ImageChops.multiply(eye.getchannel('A'),mask));o.alpha_composite(eye)
sleepy_eye(o);sleepy_eye(o,True)
oval(o,515,656,48,31,line)
oval(o,515,656,37,21,inside)
o.save(P/'face-sleepy.png',optimize=True)
