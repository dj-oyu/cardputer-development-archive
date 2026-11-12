#include "render_adapter.h"
#include <string.h>
static bool surface(void*u,const fox_fragment*f,float rgb[3],float*a){const fox_eye_snapshot*s=u;if(s->hidden[f->object]){*a=0;rgb[0]=rgb[1]=rgb[2]=0;return true;}return fox_eye_snapshot_surface(s,f->material,f->local[0],f->local[1],f->local[2],rgb,a);}
bool render_leased(lease_pool*snapshots,lease_key key,lease_pool*strips,render_scratch*w,bool(*submit)(void*,const leased_strip*,lease_ticket),bool(*pump)(void*),void*ctx){
 lease_ticket read;const void*borrow;if(!lease_pin(snapshots,key,&read,&borrow))return false;
 const fox_eye_snapshot*s=borrow;scene_times times;bool ok=false;
 if(!fox_scene_prepare_local(NULL,&w->frame,&w->workspace,-1,3,-1,&times,s->local)||!fox_scene_composite_preflight(&w->frame,&w->workspace,s->local,surface,(void*)s,16,&w->composite))goto done;
 for(unsigned y=0;y<135;y+=4){lease_key k;void*p;
  if(!lease_acquire(strips,&k,&p)){if(!pump||!pump(ctx)||!lease_acquire(strips,&k,&p))goto done;}
  leased_strip*b=p;b->y=y;b->height=135-y<4?135-y:4;memset(b->pixels,0,sizeof b->pixels);
  if(!fox_scene_composite(&w->frame,b->pixels,y,b->height,30,&w->workspace,s->local,surface,(void*)s,16,&w->composite)){lease_abort(strips,k);goto done;}
  if(!lease_publish(strips,k)){lease_abort(strips,k);goto done;}
  lease_ticket t;const void*immutable;if(!lease_pin(strips,k,&t,&immutable)){lease_retire(strips,k);goto done;}
  lease_retire(strips,k); /* stop new pins; transport already owns its ticket */
  if(!submit(ctx,immutable,t))goto done;
 }
 ok=true;
 done: lease_complete(snapshots,read);return ok;
}
