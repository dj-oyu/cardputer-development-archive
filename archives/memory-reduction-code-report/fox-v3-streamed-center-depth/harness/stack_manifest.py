"""Conservative named source call-chain sums from the exact build .su files."""
from pathlib import Path
import json,hashlib,sys
R=Path(__file__).resolve().parents[1];product='--product' in sys.argv;B=R/('build-product' if product else 'build-adapter');frames={}
for p in [B/name for name in json.loads((B/'BUILD.json').read_text())['stackFiles']]:
 for line in p.read_text().splitlines():
  loc,amount,kind=line.split('\t');name=loc.rsplit(':',1)[-1];frames[p.stem+':'+name]=int(amount)
F=lambda file,name:file+':'+name
bridge=[F('row_transport_bridge','row_transport_render_stream_depth')];core=bridge+[F('ksn_mesh_depth','ksn_mesh_pixel_render_stream_depth_private')]
bg=[F('background','fox_bg_compose'),F('background','resolve_impl'),F('fox_disk_lighting','fox_disk_eval16_visible'),F('fox_disk_lighting','eval.part.0'),F('background','visible'),F('visibility','vis_segment_occluded'),F('visibility','box_hit.constprop')]
tx=[F('row_transport_bridge','shade'),F('bounce','bounce_eval_floor_experimental'),F('bounce','bounce_eval_impl'),F('fox_disk_lighting','fox_disk_eval16_visible'),F('fox_disk_lighting','eval.part.0'),F('bounce','visible'),F('visibility','vis_segment_occluded'),F('visibility','box_hit.constprop')]
chains={
 'quarter_background':core+[F('ksn_mesh_depth','sc_resolve')]+bg,
 'center_background':core+[F('ksn_mesh_depth','stream_finish_row'),F('ksn_mesh_depth','sc_resolve')]+bg,
 'quarter_transport_floor_direct':core+tx,
 'center_transport_floor_direct':core+[F('ksn_mesh_depth','rrh_center_strip.constprop')]+tx,
 'quarter_transport_nearest':core+tx[:3]+[F('visibility','vis_ray_nearest'),F('visibility','box_hit.constprop')],
 'quarter_transport_direction':core+tx[:3]+[F('bounce','direction')],
 'center_profile':core+[F('ksn_mesh_depth','stream_finish_row'),F('ksn_mesh_depth','cached_encode'),F('profile_bridge','agx_cache_profile_eval')],
 'quarter_profile':core+[F('ksn_mesh_depth','cached_encode'),F('profile_bridge','agx_cache_profile_eval')],
 'core_admission':core+[F('ksn_mesh_depth','stream_admission'),F('ksn_mesh_depth','sc_binding_spans'),F('background','fox_bg_context_overlaps'),F('background','fox_bg_scene_overlaps'),F('visibility','vis_scene_overlaps')],
 'bridge_admission':bridge+[F('row_transport_bridge','row_stream_validate_depth'),F('background','fox_bg_context_overlaps'),F('background','fox_bg_scene_overlaps'),F('visibility','vis_scene_overlaps')],
 'bridge_finish':bridge+[F('row_transport_bridge','row_stream_finish'),F('background','fox_bg_context_finish'),F('background','work_valid')],
}
chains['quarter_transport_world_nearest']=core+[F('row_transport_bridge','shade'),F('bounce','bounce_eval_floor_world_experimental'),F('bounce','bounce_eval_impl'),F('visibility','vis_ray_nearest'),F('visibility','box_hit.constprop')]
chains['quarter_transport_world_direction']=core+[F('row_transport_bridge','shade'),F('bounce','bounce_eval_floor_world_experimental'),F('bounce','bounce_eval_impl'),F('bounce','direction')]
if not product:chains['diagnostic_hdr_copy']=core+[F('ksn_mesh_depth','stream_finish_row'),F('ksn_mesh_depth','cached_encode'),F('hdr_observer','row_hdr_observe')]
# Quarter resolution and transport execute inside the emitted 960-byte shader frame.
for name in list(chains):
 if name=='quarter_background' or name.startswith('quarter_transport_'):
  chains[name].insert(len(core),F('ksn_mesh_depth','ring_sc_shade_final.constprop'))
for name in ['center_profile','quarter_profile']:chains[name]+=[F('block_cache','agx_cache_fetch4'),F('block_cache','header')]
out={name:{'frames':[{'name':n,'bytes':frames[n]} for n in ns],'bytes':sum(frames[n] for n in ns)} for name,ns in chains.items()}
x={'status':'COMPILED_NAMED_CHAIN_REVIEW_PENDING','actualFrames':0,'chains':out,'backgroundPeak':max(out['quarter_background']['bytes'],out['center_background']['bytes']),'backgroundCap':4096,'rendererPeak':max(v['bytes'] for v in out.values()),'rendererCap':8192,'mainStack':frames['native_render_row:main'],'compactTransportBaselineMainStack':83744,'mainStackIncrease':frames['native_render_row:main']-83744,'mainStackCountedSeparately':True,'stackFiles':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [B/name for name in json.loads((B/'BUILD.json').read_text())['stackFiles']]},'exclusions':['libc/libm call stacks and ABI runtime','source construction chains are separate from rendering','allocator metadata and executable globals'],'inlinedFunctions':'Included in compiler emitted caller frame; sibling/tail frames conservatively summed where listed; no recursion on render path','wholeHostOrDeviceFitClaim':False}
assert x['backgroundPeak']<=4096 and x['rendererPeak']<=8192
(R/('PRODUCT_NAMED_STACK.json' if product else 'NAMED_STACK.json')).write_text(json.dumps(x,indent=2)+'\n');print(json.dumps({k:x[k] for k in ['backgroundPeak','rendererPeak','mainStack']}))
