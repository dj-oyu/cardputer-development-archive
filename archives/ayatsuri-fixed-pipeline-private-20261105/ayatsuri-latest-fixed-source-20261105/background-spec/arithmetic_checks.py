"""Pure supplied RGB arithmetic, not a renderer or background-acquisition test."""
from fractions import Fraction as F
from pathlib import Path
import json,math
P=Path(__file__).resolve().parent
# Existing background.c:112, with direct already supplied. No evaluator invoked.
direct=[F(1,4),F(2),F(0)];rho=[F(1,2),F(1,4),F(1)];world=[F(1,2),F(4),F(1,8)];emission=[F(1,8),F(0),F(1,2)]
combined=[direct[k]+rho[k]*world[k]+emission[k] for k in range(3)]
assert combined==[F(5,8),F(3),F(5,8)]
# Source specifies average first, then clamp. HDR highlights expose wrong order.
samples=[F(4),F(0),F(0),F(0)];mean=sum(samples)/4
clamp_after=min(F(1),mean);clamp_before=sum(min(F(1),v) for v in samples)/4
assert clamp_after==1 and clamp_before==F(1,4)
# Pure mathematical sRGB analogue of shade.h:47, NOT bit-exact float32 powf parity.
def encode(x):return 12.92*x if x<=.0031308 else 1.055*x**(1/2.4)-.055
def quant(x,n):return math.floor(encode(min(1,x))*n+.5)
linear_half=F(1,2);correct=encode(float(linear_half));encoded_average=(encode(1)+encode(0))/2
assert correct>encoded_average and quant(.5,31)==23 and quant(.5,63)==46
# Linear averaging supplied slots must retain distinct per-slot values.
rgb_slots=[[F(1),F(0),F(0)],[F(0),F(1),F(0)],[F(0),F(0),F(1)],[F(1),F(1),F(1)]]
assert [sum(row[k] for row in rgb_slots)/4 for k in range(3)]==[F(1,2)]*3
out={'scope':'Independent supplied RGB scalar arithmetic only; no acquisition, depth/visibility test, alpha-over implementation, runtime integration or float32 encoder parity claim.','component_formula':{'direct':[float(v) for v in direct],'rho':[float(v) for v in rho],'world':[float(v) for v in world],'emission':[float(v) for v in emission],'combined':[float(v) for v in combined]},'clamp_order':{'supplied_samples':[4,0,0,0],'average_then_clamp':float(clamp_after),'incorrect_clamp_then_average':float(clamp_before)},'transfer_order':{'linear_mean':.5,'encode_linear_mean':correct,'incorrect_mean_encoded':encoded_average,'mathematical_rgb565_channels':[23,46,23]},'checks':'PASS'}
(P/'arithmetic-results.json').write_text(json.dumps(out,indent=2));print('PASS: supplied component sum, HDR average/clamp order, linear/display order')
