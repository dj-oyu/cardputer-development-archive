"""Diagnostic only: compare adopted Q20 point then Q16 versus direct weighted Q16."""
import pathlib,json,hashlib,fractions
P=pathlib.Path(__file__).resolve().parent;source=P.parent/'kernel-chain-prototype/fixtures.json';data=json.loads(source.read_text())
def rne(n,d):
 sign=-1 if n<0 else 1;q,r=divmod(abs(n),d);return sign*(q+(2*r>d or (2*r==d and q%2)))
result={}
for domain,axes in [('world',[0,1,2]),('local',[0,2])]:
 cases=[];changed_points=set();total=0;max_staged=fractions.Fraction(0);max_direct=fractions.Fraction(0)
 for f in data['fixtures']:
  for slot,b in enumerate(f['bary_q14']):
   for axis in axes:
    total+=1;n=sum(b[i]*f['corners'][i][domain+'_xyz'][axis] for i in range(3));q20=rne(n,16384);staged=rne(q20,16);direct=rne(n,16384*16);exact=fractions.Fraction(n,16384*16)
    max_staged=max(max_staged,abs(staged-exact));max_direct=max(max_direct,abs(direct-exact))
    if staged!=direct:
     changed_points.add((f['part_id'],f['triangle'],slot));cases.append(dict(object_id=f['object_id'],part_id=f['part_id'],triangle=f['triangle'],slot=slot,axis=axis,weighted_sum=n,adopted_q20=q20,adopted_q16=staged,diagnostic_direct_q16=direct,delta_q16=staged-direct))
 result[domain]=dict(tested_components=total,changed_components=len(cases),tested_supplied_points=len(data['fixtures'])*4,changed_points=len(changed_points),maximum_absolute_q16_code_difference=max([abs(c['delta_q16']) for c in cases],default=0),maximum_adopted_error_relative_to_exact_weighted_coordinate_in_q16_codes=str(max_staged),maximum_direct_error_relative_to_exact_weighted_coordinate_in_q16_codes=str(max_direct),differences=cases)
report=dict(schema='latest-canonical-q20-coordinate-rounding-diagnostic-v1',input_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),counting='155 triangle fixtures x4 declared points, once; states/visibility/Q alternatives do not multiply identical coordinate observations; shared vertices can appear in multiple declared tuples',adopted='RNE(RNE(sum(Q20_corner*Q14_weight)/16384)/16)',diagnostic_only='RNE(sum(Q20_corner*Q14_weight)/(16384*16)); NOT adopted',units='One Q16 code = 1/65536 metre',not_pixel_aa=True,no_runtime_change=True,results=result)
(P/'coordinate-rounding-diagnostic.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps({d:{k:v for k,v in r.items() if k!='differences'} for d,r in result.items()},indent=2))
