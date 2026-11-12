from pathlib import Path
exec((Path('/workspace/scratch/6d8dcdbcdc54/fox-v3-contact-protected/audit.py')).read_text().split('reports=[]')[0])
rows=[]
for stage in ['protected-contact']:
 C={k:Shape(x) for k,x in load(R/'fox-v3-ground-transport/le-001/inputs/geometry-source-sided.glb' if stage=='baseline' else O/(stage+'.glb')).items()};row={'stage':stage,'pairs':[]}
 for side in [-1,1]:
  sn=f'Smile {side}';pn=f'Muzzle pad {side}';pair={'side':side,'families':{}}
  for family,points in [('source',S[sn].samples),('candidate',C[sn].samples)]:
   pair['families'][family]={}
   for kind,vv in views.items():
    counts=collections.Counter()
    for view in vv:
     d=Vector(view['direction'])
     for p in points:
      a=label(S[sn],S[pn],p,d);b=label(C[sn],C[pn],p,d);counts[a+'->'+b]+=1
    pair['families'][family][kind]=dict(counts)
  row['pairs'].append(pair)
 rows.append(row)
(O/'ray-families.json').write_text(json.dumps(rows,indent=2))
