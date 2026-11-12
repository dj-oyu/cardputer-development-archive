from pathlib import Path
base=Path('fox-v3-visibility-lifetime-reduction/tests/test_semantics.c').read_text()
base=base.replace('#include "../../fox-v3-bvh-node-capacity/private-build/visibility/visibility.c"','#include "../../fox-v3-visibility-lifetime-reduction/private-build/visibility/visibility.c"')
a=base.index('#ifdef BASELINE',base.index('static void canonical'))
b=base.index('#endif',a)+len('#endif')
base=base[:a]+''' triangle_points(s,&s->tri[i],p);
 for(size_t j=0;j<3;j++)assert(s->tri[i].vertex[j]==indices[3*(size_t)ordinal+j]);
 for(int k=0;k<3;k++){lo[k]=fmin(p[0][k],fmin(p[1][k],p[2][k]));hi[k]=fmax(p[0][k],fmax(p[1][k],p[2][k]));center[k]=(lo[k]+hi[k])*0.5;}
'''+base[b:]
base=base.replace('mode<3','mode<6')
base=base.replace('double v[9]={x,y,z,x+0.8,y,z+0.125,x,y+0.9,z+0.25};memcpy(xyz+9*t,v,sizeof(v));','''double v[9]={x,y,z,x+0.8,y,z+0.125,x,y+0.9,z+0.25};
   if(mode==3)for(int j=0;j<3;j++)v[3*j+2]=(t&(1u<<j))?-0.0:0.0;
   if(mode==4)for(int j=0;j<9;j++)v[j]*=1e48;
   if(mode==5)for(int j=0;j<3;j++)v[3*j+2]=(t&(1u<<j))?-0x1p-1074:0x1p-1074;
   memcpy(xyz+9*t,v,sizeof(v));''')
base=base.replace('hash(s->tree[i].lo,sizeof(s->tree[i].lo));hash(s->tree[i].hi,sizeof(s->tree[i].hi));','''double lo[3],hi[3];
#ifdef BASELINE
    memcpy(lo,s->tree[i].lo,sizeof(lo));memcpy(hi,s->tree[i].hi,sizeof(hi));
#else
    for(int k=0;k<3;k++){assert(s->tree[i].lo_vertex[k]<vertices && s->tree[i].hi_vertex[k]<vertices);lo[k]=bound_value(s,s->tree[i].lo_vertex[k],k);hi[k]=bound_value(s,s->tree[i].hi_vertex[k],k);}
#endif
    HASH(lo);HASH(hi);''')
base=base.replace('vis_budget budget={{100,100000,100000},{0,0,0}};','''if(mode==4)for(int k=0;k<3;k++){from[k]*=1e48;to[k]*=1e48;}
    if(q%7==0 && dir[0]==0)dir[0]=-0.0;
    if(q%11==0 && dir[1]==0)dir[1]=-0.0;
    vis_budget budget={{100,100000,100000},{0,0,0}};''')
base=base.replace('s->tree[i]','VIEW(s)[i]');pos=base.index('#endif')+len('#endif');base=base[:pos]+'\n#ifdef BASELINE\n#define VIEW(s) ((s)->tree)\n#else\n#define VIEW(s) scene_nodes(s)\n#endif\n'+base[pos:]
Path('fox-v3-indexed-bvh-bounds/review/test_independent_semantics.c').write_text(base)
