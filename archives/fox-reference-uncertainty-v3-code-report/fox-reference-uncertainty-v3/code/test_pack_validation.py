import tempfile,pathlib,json,hashlib,subprocess,sys,unittest,copy,shutil
import numpy as np
from PIL import Image
import evaluator as E
class PackTests(unittest.TestCase):
 def test_validation_and_reference_only(self):
  with tempfile.TemporaryDirectory() as td:
   root=pathlib.Path(td);(root/'input').mkdir();(root/'images').mkdir()
   source=root/'source';source.write_text('synthetic');config={'expectedCaseMetadata':{c:{} for c in E.PLAN['cases']},'metadataFloatTolerance':1e-5,'expectedRenderInvariantSettings':{},'resolution':[2,2],'seeds':E.PLAN['seeds'],'source':str(source),'sourceSHA256':hashlib.sha256(source.read_bytes()).hexdigest(),'frozenCode':{}};cp=root/'input/config.json'
   original=pathlib.Path(__file__).resolve().parents[1]
   for file in list(original.glob('code/*.py'))+[original/x for x in ['PLAN.md','plan.json','plan-freeze.json','NUMERIC_ADDENDUM.md','numeric-freeze.json']]:
    dest=root/file.relative_to(original);dest.parent.mkdir(exist_ok=True);shutil.copyfile(file,dest);config['frozenCode'][str(file.relative_to(original))]=hashlib.sha256(dest.read_bytes()).hexdigest()
   cp.write_text(json.dumps(config));sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();ch=sha(cp)
   geo={'cameraMatrix':[[1]],'clip':[.1,100],'orthoScale':4.8,'resolution':[2,2,100],'objects':[{'name':'fox','hideRender':False}]}
   manifest={'sourceSHA256':config['sourceSHA256'],'renderInvariantSettings':{},'configSHA256':ch,'images':[],'foreground':{}}
   for view in E.PLAN['views']:
    file=f'images/foreground-{view}.png';Image.fromarray(np.full((2,2,4),255,np.uint8)).save(root/file);manifest['foreground'][view]={'file':file,'sha256':sha(root/file),'geometry':geo,'contract':'synthetic'}
    for seed in E.PLAN['seeds']:
     for case in E.PLAN['cases']:
      stem=f'images/seed-{seed}-{view}-{case}';file=stem+'.png';meta=stem+'.json'
      Image.fromarray(np.full((2,2,3),128 if case=='baseline' else 131,np.uint8)).save(root/file)
      (root/meta).write_text(json.dumps({'seed':seed,'view':view,'case':case,'samplesMaximum':2048,'threads':8,'configSHA256':ch,'geometry':geo,'pngSHA256':sha(root/file),'invariantSettings':{}}))
      manifest['images'].append({'seed':seed,'view':view,'case':case,'file':file,'metadata':meta,'metadataSHA256':sha(root/meta),'sha256':sha(root/file)})
   def run(m):
    (root/'render-manifest.json').write_text(json.dumps(m));return subprocess.run([sys.executable,str(pathlib.Path(__file__).with_name('evaluate_pack.py')),str(root)],capture_output=True)
   res=run(manifest);self.assertEqual(res.returncode,0,res.stderr.decode())
   result=json.loads((root/'evaluation.json').read_text());self.assertEqual(result['sixtyPercentGoal'],'NOT_EVALUATED_NO_CANDIDATE')
   for variant in ['duplicate','missing','metadata','hash','seed']:
    m=copy.deepcopy(manifest)
    if variant=='duplicate':m['images'][-1]=m['images'][0]
    if variant=='missing':m['images'].pop()
    if variant=='metadata':m['images'][0]['metadata']=m['images'][1]['metadata'];m['images'][0]['metadataSHA256']=m['images'][1]['metadataSHA256']
    if variant=='hash':m['images'][0]['sha256']='0'*64
    if variant=='seed':m['images'][0]['seed']=999
    self.assertNotEqual(run(m).returncode,0,variant)
   m=copy.deepcopy(manifest);fgfile=root/m['foreground']['front']['file'];Image.fromarray(np.full((2,2,3),128,np.uint8)).save(fgfile);m['foreground']['front']['sha256']=sha(fgfile)
   self.assertNotEqual(run(m).returncode,0,'RGB mask has no alpha')
if __name__=='__main__':unittest.main(verbosity=2)
