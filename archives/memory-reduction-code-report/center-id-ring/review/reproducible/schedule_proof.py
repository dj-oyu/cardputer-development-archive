import json
W,H,N=240,135,10
ring=[None]*N
checks=0
pending=0
for y in range(0,H,8):
 rows=min(8,H-y)
 for row in range(y,y+rows): ring[row%N]=row
 finish=([y-1] if y else [])+[r for r in range(y,y+rows) if r!=y+rows-1 or y+rows==H]
 for row in finish:
  for q in (row-1,row,row+1):
   if 0<=q<H:
    assert ring[q%N]==q,(y,row,q,ring)
    checks+=1
  if row==y-1:
   assert ring[(y-2)%N]==y-2
   pending+=1
assert pending==16
# Show the tempting 9-row capacity is insufficient.
ring9=[None]*9
for row in range(8): ring9[row%9]=row
for row in range(8,16): ring9[row%9]=row
assert ring9[6%9]!=6
result={'status':'PASS','height':H,'bandRows':8,'ringRows':10,'finishedRows':135,'neighborLifetimeChecks':checks,'pendingPriorTwoRowChecks':pending,'tailRows':7,'nineRowsInsufficient':True,'centerArrayBeforeBytes':W*H*2,'centerArrayAfterBytes':W*N*2,'savingBytes':W*(H-N)*2,'note':'Independent symbolic schedule proof, not implementation or render test.'}
print(json.dumps(result,indent=2))
