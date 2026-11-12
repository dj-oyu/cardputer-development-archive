"""Diagnostic-only byte codec. E4 is not a product wire-mode assignment.
Python struct uses byte offsets, not potentially unaligned typed loads.
No float/normal recomputation. Integer comparison has no int16 overflow.
"""
import struct,json,hashlib
from pathlib import Path
ROOT=Path(__file__).resolve().parent
DIAG=0xE4

def align4(n):return (n+3)&~3

def records(data,compact=False):
 if len(data)<416:raise ValueError('truncated scene prefix')
 at=416;out=[]
 while at<len(data):
  if len(data)-at<12:raise ValueError('truncated header')
  nv,nt,mode,res=struct.unpack_from('<BBBB',data,at);size=struct.unpack_from('<H',data,at+10)[0]
  if not 3<=nv<=32 or not 1<=nt<=64 or mode not in ((4,DIAG) if compact else (4,)) or res:raise ValueError('invalid record header')
  if struct.unpack_from('<H',data,at+6)[0] or struct.unpack_from('<H',data,at+8)[0]:raise ValueError('invalid reserved/color fields')
  stride=50 if mode==DIAG else 56;side=(nt+7)//8;raw=12+stride*nv+3*nt+side;expected=align4(raw)
  if size!=expected or at+size>len(data):raise ValueError('invalid/truncated record length')
  record=data[at:at+size];ixstart=12+stride*nv;ix=record[ixstart:ixstart+3*nt]
  if any(v>=nv for v in ix) or any(len(set(ix[k:k+3]))!=3 for k in range(0,len(ix),3)):raise ValueError('invalid indices')
  if nt%8 and record[raw-1]>>(nt%8):raise ValueError('unused side bits')
  if any(record[raw:]):raise ValueError('nonzero padding')
  out.append((at,record,nv,nt,stride,raw));at+=size
 if at!=len(data):raise ValueError('trailing data')
 return out

def examine(rec,nv):
 good=[];mismatch=0;minimum=0
 for i in range(nv):
  front=struct.unpack_from('<3h',rec,12+56*i+44);back=struct.unpack_from('<3h',rec,12+56*i+50)
  # Python ints are widened; INT16_MIN negation is +32768, never wrap.
  minimum+=sum(x==-32768 for x in front)
  equal=[b==-int(f) for f,b in zip(front,back)];mismatch+=sum(not x for x in equal);good.append(all(equal))
 return all(good),sum(good),mismatch,minimum

def encode(data):
 result=bytearray(data[:416]);audit=[]
 for index,(offset,rec,nv,nt,stride,raw) in enumerate(records(data)):
  eligible,vertices,mismatch,minimum=examine(rec,nv)
  if eligible:
   body=bytearray(rec[:12]);body[2]=DIAG
   for i in range(nv):body+=rec[12+56*i:12+56*i+50]
   body+=rec[12+56*nv:raw];body+=bytes(align4(len(body))-len(body));struct.pack_into('<H',body,10,len(body));result+=body;newsize=len(body)
  else:result+=rec;newsize=len(rec)
  audit.append({'recordOrdinal':index,'nodeId':struct.unpack_from('<H',rec,4)[0],'vertices':nv,'triangles':nt,'eligibleVertices':vertices,'eligibleRecord':eligible,'fallbackRecord':not eligible,'mismatchingComponents':mismatch,'frontInt16MinimumComponents':minimum,'originalBytes':len(rec),'encodedBytes':newsize,'savedBytesAfterAlignment':len(rec)-newsize})
 return bytes(result),audit

def decode(data):
 result=bytearray(data[:416])
 for offset,rec,nv,nt,stride,raw in records(data,True):
  if stride==56:result+=rec;continue
  body=bytearray(rec[:12]);body[2]=4
  for i in range(nv):
   vertex=rec[12+50*i:12+50*i+50];front=struct.unpack_from('<3h',vertex,44)
   if any(x==-32768 for x in front):raise ValueError('compact INT16_MIN cannot reconstruct')
   body+=vertex+struct.pack('<3h',*[-int(x) for x in front])
  body+=rec[12+50*nv:raw];body+=bytes(align4(len(body))-len(body));struct.pack_into('<H',body,10,len(body));result+=body
 return bytes(result)

def main():
 manifest=json.loads((ROOT/'dump-summary.json').read_text());D=ROOT/'private-encoded';D.mkdir(exist_ok=False);rows=[]
 for f in manifest['rows']:
  p=ROOT/f['file'];data=p.read_bytes();assert hashlib.sha256(data).hexdigest()==f['sha256'];encoded,audit=encode(data);decoded=decode(encoded);assert decoded==data;assert encoded[:416]==data[:416];assert len(audit)==51;assert sum(a['vertices'] for a in audit)==1066
  (D/(p.stem+'.diag-e4')).write_bytes(encoded);rows.append({'view':f['view'],'case':f['case'],'reverse':f['reverse'],'originalBytes':len(data),'encodedBytes':len(encoded),'savedBytes':len(data)-len(encoded),'headroomUnderUnchanged65536':65536-len(encoded),'eligibleRecords':sum(a['eligibleRecord'] for a in audit),'fallbackRecords':sum(a['fallbackRecord'] for a in audit),'eligibleVerticesWithinEligibleRecords':sum(a['vertices'] for a in audit if a['eligibleRecord']),'eligibleVerticesAnywhere':sum(a['eligibleVertices'] for a in audit),'mismatchingComponents':sum(a['mismatchingComponents'] for a in audit),'allBytesRoundTripExact':True,'scenePrefixExact':True,'decodedSHA256':hashlib.sha256(decoded).hexdigest(),'encodedSHA256':hashlib.sha256(encoded).hexdigest(),'records':audit})
 result={'status':'DIAGNOSTIC_ONLY_NOT_PRODUCT_IMPLEMENTED','formatTag':DIAG,'snapshots':20,'all20RoundTripByteExact':True,'scenePrefixBytes':416,'recordHeaderBytes':12,'originalStride':56,'conditionalStride':50,'fullRecordFallbackStride':56,'fallbackWorstCaseSnapshotBytes':65216,'fallbackWorstCaseHeadroom':320,'productChanged':False,'producerParserChanged':False,'cpuEncodeDecodeMeasured':False,'rows':rows};(ROOT/'capacity-summary.json').write_text(json.dumps(result,indent=2));print(json.dumps([{k:v for k,v in row.items() if k not in ['records','decodedSHA256','encodedSHA256']} for row in rows],indent=2))
if __name__=='__main__':main()
