"""Deterministic SVG-like brush strokes in the existing face UV, no extra geometry."""
from pathlib import Path
from PIL import Image, ImageChops, ImageDraw, ImageFilter
P=Path(__file__).resolve().parent/'assets'
src=Image.open(P/'neutral.png').convert('RGBA');assert src.size==(1024,1024)
S=2
mirror=lambda poly:[(1026-x,y) for x,y in poly]
def rect(x0,y0,x1,y1):return [(x0,y0),(x1,y0),(x1,y1),(x0,y1)]
old_eye=[(331,476),(362,488),(398,473),(435,472),(470,487),(484,528),(484,575),(480,590),(466,599),(429,604),(389,599),(363,581),(345,549),(336,520),(331,500)]
rm=[rect(330,408,485,473),rect(541,408,696,473),rect(435,627,590,704),old_eye,mirror(old_eye)]
mask=Image.new('L',src.size);d=ImageDraw.Draw(mask)
for p in rm:d.polygon(p,fill=255)
src.putalpha(ImageChops.subtract(src.getchannel('A'),mask))
def px(p):return [(round(x*S),round(y*S)) for x,y in p]
def layer():return Image.new('RGBA',(1024*S,1024*S))
def poly(dest,pts,color,flip=False):
 d=ImageDraw.Draw(dest);d.polygon(px(mirror(pts) if flip else pts),fill=color)
def ell(dest,cx,cy,w,h,color,flip=False):
 if flip:cx=1026-cx
 ImageDraw.Draw(dest).ellipse((round((cx-w/2)*S),round((cy-h/2)*S),round((cx+w/2)*S),round((cy+h/2)*S)),fill=color)
def line(dest,pts,color,width,flip=False):
 ImageDraw.Draw(dest).line(px(mirror(pts) if flip else pts),fill=color,width=round(width*S),joint='curve')
def composite(dest,l):dest.alpha_composite(l)
def pair(d,p,col):
 poly(d,p,col);poly(d,p,col,True)
# Shadow only sits around the lower outer eye corner, and has no connection across the nose.
# Warm muted hue retains the character's skin; layered ochre fades remain transparent.
p=layer()
shadow1=[(348,550),(380,562),(421,587),(403,614),(366,595),(349,578)]
shadow2=[(358,564),(394,578),(412,597),(377,583)]
pair(p,shadow1,(101,45,27,171))
pair(p,shadow2,(81,38,25,136))
src.alpha_composite(p.resize((1024,1024),Image.Resampling.LANCZOS))
front=layer()
# Angular inner drop in the deep eyebrows, thickened to survive roughly 1-pixel native raster width.
pair(front,[(338,438),(357,424),(397,433),(443,447),(468,463),(480,480),(456,481),(416,465),(371,453),(343,450)],(42,19,14,255))
pair(front,[(356,432),(369,432),(398,439),(423,447),(450,457),(411,447),(375,440)],(105,57,37,183))
# Squint: sharp sloping upper corners, golden iris tucked under the lid, stronger sepia contours.
ink=(41,19,13,255)
shadow_eye=(71,34,22,255)
white=(234,197,158,255)
shape=[(335,482),(367,488),(411,504),(455,518),(479,522),(473,550),(450,563),(410,563),(376,550),(350,520)]
socket=[(349,502),(373,506),(415,525),(460,534),(468,535),(461,546),(441,553),(412,552),(386,541),(366,526)]
for flip in (False,True):
 poly(front,shape,ink,flip)
 poly(front,socket,white,flip)
 pupil=layer()
 ell(pupil,423,530,52,60,(135,56,19,255),flip)
 ell(pupil,424,534,39,48,(201,105,23,255),flip)
 ell(pupil,425,529,25,43,(49,20,12,255),flip)
 ell(pupil,431,530,9,11,(255,235,166,255),flip)
 pm=Image.new('L',pupil.size);ImageDraw.Draw(pm).polygon(px(mirror(socket) if flip else socket),fill=255)
 pupil.putalpha(ImageChops.multiply(pupil.getchannel('A'),pm));front.alpha_composite(pupil)
 # Rim tension mark, separated from the main cheek shape; never a bar across both eyes.
 line(front,[(357,544),(374,555),(391,559)],(101,42,28,240),7,flip)
 line(front,[(455,569),(443,573)],(124,61,38,204),6,flip)
# Small short bridge creases make the brow contraction intentional; baseline sculpted nose is untouched.
line(front,[(487,476),(495,495)],(101,44,30,198),8)
line(front,[(540,476),(534,496)],(101,44,30,198),8)
# Closed angular mouth, no cloud epsilon or open grin.
poly(front,[(449,649),(470,642),(496,644),(515,646),(545,642),(576,651),(572,663),(547,658),(518,660),(500,657),(470,658),(450,665)],(60,23,16,255))
poly(front,[(487,669),(513,672),(536,668),(545,666),(533,676),(512,679),(495,675)],(171,79,62,188))
src.alpha_composite(front.resize((1024,1024),Image.Resampling.LANCZOS))
src.save(P/'face-gekiga.png',optimize=True)
