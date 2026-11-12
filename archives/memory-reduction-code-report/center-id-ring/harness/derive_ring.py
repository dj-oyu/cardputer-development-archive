"""Mechanical specialization from pinned completed sources, never rejected work."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]; P=R/'private-build/product/main/ui/kasane'; C=R/'code'
aa=(P/'ksn_boundary_aa_impl.inc').read_text();sc=(P/'ksn_scene_composition_impl.inc').read_text()
def function(src,name):
 m=re.search(r'^static [^\n]*?\b'+name+r'\(',src,re.M);assert m,name
 start=m.start();op=src.index('{',m.end());depth=1;i=op+1
 while depth:
  depth+=(src[i]=='{')-(src[i]=='}');i+=1
 return src[start:i]+'\n'
names=['aa_guard','aa_charge','aa_bind','aa_target','aa_geometry','sc_mask','sc_shade_final']
def subst(s):
 s=re.sub(r'\bksn_aa_workspace\b','ksn_bounded_ring_workspace',s)
 for name in names:s=re.sub(r'\b'+name+r'\b','ring_'+name,s)
 return s
h=(P/'ksn_boundary_aa.h').read_text();start=h.index('typedef struct {\n uint16_t center_id');end=h.index('} ksn_aa_workspace;',start)+len('} ksn_aa_workspace;')
typecode=subst(h[start:end]).replace('center_id[KSN_AA_PIXELS]','center_id[10*240]')
api=(C/'ksn_bounded_hdr.h').read_text();decl=api[api.index('bool ksn_mesh_pixel_render_bounded'):api.index('\n#endif')]
(C/'ksn_bounded_ring.h').write_text('#ifndef KSN_BOUNDED_RING_H\n#define KSN_BOUNDED_RING_H\n#include "ksn_bounded_hdr.h"\n/* Opt-in bounded-HDR-only ABI. Generic AA retains its full-frame IDs. */\n'+typecode+'\n'+subst(decl).replace('ksn_mesh_pixel_render_bounded_hdr_experimental','ksn_mesh_pixel_render_bounded_ring_experimental')+'\n#endif\n')
helpers=''.join(subst(function(aa if n.startswith('aa_') else sc,n)) for n in names)
(C/'ksn_bounded_ring_helpers.inc').write_text('/* Mechanically specialized pinned workspace-dependent helpers. */\n'+helpers)
s=(C/'ksn_bounded_hdr_impl.inc').read_text();s=subst(s)
s=s.replace('#include "ksn_bounded_hdr.h"','#include "ksn_bounded_ring.h"\n#include "ksn_bounded_ring_helpers.inc"')
s=s.replace('==137312,"workspace unchanged"','==77312,"ring workspace"')
s=s.replace('ksn_mesh_pixel_render_bounded_hdr_experimental','ksn_mesh_pixel_render_bounded_ring_experimental')
s=re.sub(r'\brh_(\w+)',r'rrh_\1',s)
s=s.replace('#include "ksn_bounded_hdr_center.inc"','#include "ksn_bounded_ring_center.inc"')
s=s.replace('uint16_t c=w->center_id[p],u=y?w->center_id[p-240]:65535,l=x?w->center_id[p-1]:65535,rr=x<239?w->center_id[p+1]:65535,d=y<134?w->center_id[p+240]:65535;', 'unsigned row=(y%10)*240;uint16_t c=w->center_id[row+x],u=y?w->center_id[((y-1)%10)*240+x]:65535,l=x?w->center_id[row+x-1]:65535,rr=x<239?w->center_id[row+x+1]:65535,d=y<134?w->center_id[((y+1)%10)*240+x]:65535;')
s=s.replace('memset(w->center_id,0xff,sizeof w->center_id);','')
s=s.replace('  memset(w->reuse.hdr,0,rows*240*3*sizeof(double));','  /* Keep y-2 and y-1 alive until pending y-1 is finished. */\n  for(unsigned row=0;row<rows;row++)memset(w->center_id+((y+row)%10)*240,0xff,240*sizeof(uint16_t));\n  memset(w->reuse.hdr,0,rows*240*3*sizeof(double));',1)
(C/'ksn_bounded_ring_impl.inc').write_text(s)
s=subst((C/'ksn_bounded_hdr_center.inc').read_text());s=re.sub(r'\brh_(\w+)',r'rrh_\1',s);s=s.replace('aa->center_id[(unsigned)yy*KSN_PROC_W+(unsigned)x]','aa->center_id[((unsigned)yy%10)*KSN_PROC_W+(unsigned)x]')
(C/'ksn_bounded_ring_center.inc').write_text(s)
p=P/'ksn_mesh_depth.c';s=p.read_text();s=s.replace('\n#include "ksn_bounded_ring_impl.inc"\n','');s+='\n#include "ksn_bounded_ring_impl.inc"\n';p.write_text(s)
for filename in ['row_transport_bridge.h','row_transport_bridge.c','native_render_row.c','test_adapter.c']:
 p=R/'harness'/filename;s=p.read_text().replace('ksn_aa_workspace','ksn_bounded_ring_workspace').replace('ksn_mesh_pixel_render_bounded_hdr_experimental','ksn_mesh_pixel_render_bounded_ring_experimental').replace('#include "ksn_bounded_hdr.h"','#include "ksn_bounded_ring.h"');p.write_text(s)
p=R/'harness/run_synthetic.sh';p.write_text(p.read_text().replace('fox-v3-indexed-floor-world','fox-v3-center-id-ring'))
