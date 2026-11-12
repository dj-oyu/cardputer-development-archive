static bounce_status reference_hit_material(const bounce_scene *s,const vis_hit *hit,const double incoming[3],double ns[3],double rho[3],int *reflect,bounce_counters *c){
 if(hit->triangle_ordinal>=s->count)return BOUNCE_INVALID;
 const bounce_triangle *a=((const bounce_triangle *)s->attrs)+hit->triangle_ordinal;
 double ngv=-s->orientation_sign*dot(hit->geometric_normal,incoming);if(fabs(ngv)<=1e-12)c->grazing_ng_v++;
 int front=ngv>=0;*reflect=0;if(!front&&!a->double_sided){c->back_single_discard++;return BOUNCE_OK;}
 double mask=0,n[3]={0,0,0};for(int j=0;j<3;j++){mask+=hit->bary[j]*a->v[j].mask;const int16_t *nn=front?a->v[j].front:a->v[j].back;for(int k=0;k<3;k++)n[k]+=hit->bary[j]*sn(nn[k]);}
 if(!norm(n,ns))return BOUNCE_INVALID;
 if(-dot(ns,incoming)<=0){c->zero_reflection_ns_v++;return BOUNCE_OK;}
 for(int k=0;k<3;k++)rho[k]=0;
 for(int j=0;j<3;j++){uint16_t q=mask>=0?a->v[j].b565:a->v[j].a565;float rgb[3]={decode((q>>11)/31.0f),decode(((q>>5)&63)/63.0f),decode((q&31)/31.0f)};for(int k=0;k<3;k++)rho[k]+=hit->bary[j]*rgb[k];}
 for(int k=0;k<3;k++){if(!isfinite(rho[k])||rho[k]<-1e-12||rho[k]>1+1e-12)return BOUNCE_INVALID;rho[k]=fmax(0,fmin(1,rho[k]));}*reflect=1;return BOUNCE_OK;
}
