import sys
sys.dont_write_bytecode=True
from model import *
def rejects(fn):
 try:fn()
 except DomainError:return
 raise AssertionError('expected domain rejection')
for n,expected in [(1,0),(3,2),(5,2),(-1,0),(-3,-2),(-5,-2)]:assert rnd(n,2)==expected
rejects(lambda:mul(I64MAX,2));rejects(lambda:check(I64MIN-1))
for bits in (16,20,24):
 S=1<<bits
 assert qvalue(2**(-bits-2),S)==0
 rejects(lambda:fixed_div(S,qvalue(2**(-bits-2),S),S,True))
 assert fixed_div(S,0,S,False)==0
 for a in (-2,-1,0,1,2,S-1,S,S+1):
  r=fsqrt(a,S);v=max(a,0)*S
  assert (r==0 or abs(r*r-v)<=abs((r-1)*(r-1)-v)) and abs(r*r-v)<=abs((r+1)*(r+1)-v)
 for p in load_programs():
  frame=p.frame(BASE_CONTROLS,bits)
  rejects(lambda:p.block(frame,[(0,2*S)]*3))
  rejects(lambda:p.evaluate(frame,(0,4*S)))
  rejects(lambda:p.evaluate(frame,(0.,2*S)))
  # Existing source ramp endpoint and cell-boundary selection, not a replacement LUT.
  for fac in (-1,0,S//256,S,S+1):
   f=min(S,max(0,fac))*256;i=min(256,f//S);t=f-i*S
   assert 0<=i<=256 and 0<=t<S and (i<256 or t==0)
print('PASS ties, overflow, source-zero versus quantized-zero, sqrt near zero, domains, block widths, ramp indexing')
