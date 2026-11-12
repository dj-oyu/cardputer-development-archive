static __attribute__((noinline)) bool rrh_center_strip(const ksn_mesh_snapshot *s,uint16_t *pixels,unsigned y,unsigned height,float *z,const FoxDiskScene *scene,ksn_mesh_pixel_stats *stats,FoxDiskVisibilityCallback visibility,void *visibility_context,FoxPixelShader shader,void *shader_context,ksn_bounded_ring_workspace *aa,KsnBandHDRReport *rd){
    for(unsigned j=0;j<height*KSN_PROC_W;j++)z[j]=-INFINITY;
    size_t offset=0;unsigned records=0;
    while(offset<s->packets.size){
        co_view view;if(!co_read(s->packets.data+offset,s->packets.size-offset,&view))return false;
        const bool pixel=view.mode==CO_MODE_PIXEL||view.mode==CO_MODE_PIXEL_NORMAL_PAIR;
        if((scene&&!pixel)||(!scene&&pixel))return false;
        if(scene&&++records>s->packets.packets)return false;
        for(unsigned face=0;face<view.triangle_count;face++){
            uint8_t indices[3];co_vertex v[3];co_pixel_vertex fields[3];
            if(!co_triangle_at(&view,face,indices))return false;
            bool back;if(!co_triangle_side(&view,face,&back))return false;
            for(unsigned j=0;j<3;j++){if(!co_vertex_at_side(&view,indices[j],back,v+j))return false;if(scene&&!co_pixel_vertex_at(&view,indices[j],fields+j))return false;}
            double area=((double)v[1].x-v[0].x)*((double)v[2].y-v[0].y)-((double)v[1].y-v[0].y)*((double)v[2].x-v[0].x);
            if(!(area>1e-5))return false;
            /* Match painter arithmetic exactly: division per weight can flip
             * the authored mask sign at a material boundary. */
            const double inverse=1/area;
            int left=(int)ceil(fmin(v[0].x,fmin(v[1].x,v[2].x))),right=(int)floor(fmax(v[0].x,fmax(v[1].x,v[2].x)));
            int top=(int)ceil(fmin(v[0].y,fmin(v[1].y,v[2].y))),bottom=(int)floor(fmax(v[0].y,fmax(v[1].y,v[2].y)));
            if(left<0)left=0;
            if(right>=KSN_PROC_W)right=KSN_PROC_W-1;
            if(top<(int)y)top=(int)y;
            if(bottom>=(int)(y+height))bottom=(int)(y+height)-1;
            const gouraud_edge edge[3]={gouraud_make_edge(v+1,v+2),gouraud_make_edge(v+2,v),gouraud_make_edge(v,v+1)};
            for(int yy=top;yy<=bottom;yy++)for(int x=left;x<=right;x++){
                double w[3];bool inside=true;
                for(unsigned k=0;k<3;k++){w[k]=gouraud_edge_value(edge+k,x,yy);if(w[k]<0||(w[k]==0&&!edge[k].closed))inside=false;}
                if(!inside)continue;
                for(unsigned k=0;k<3;k++)w[k]*=inverse;
                const float depth=(float)(w[0]*v[0].depth+w[1]*v[1].depth+w[2]*v[2].depth);
                if(!isfinite(depth))return false;
                const unsigned at=(unsigned)(yy-(int)y)*KSN_PROC_W+(unsigned)x;
                if(depth<=z[at])continue;
                z[at]=depth;
                const bool second=w[0]*v[0].mask+w[1]*v[1].mask+w[2]*v[2].mask>=0;
                const uint16_t a=second?v[0].color_b:v[0].color_a,b=second?v[1].color_b:v[1].color_a,c=second?v[2].color_b:v[2].color_a;
                if(scene){
                    double world[3]={0,0,0},normal[3]={0,0,0},rho[3]={0,0,0};const uint16_t codes[3]={a,b,c};
                    for(unsigned j=0;j<3;j++){
                        const int16_t *n=back?fields[j].normal_back:fields[j].normal_front;
                        const float decoded[3]={ayatsuri_srgb_decode((codes[j]>>11)/31.0f),ayatsuri_srgb_decode(((codes[j]>>5)&63)/63.0f),ayatsuri_srgb_decode((codes[j]&31)/31.0f)};
                        for(unsigned k=0;k<3;k++){world[k]+=w[j]*fields[j].world[k];normal[k]+=w[j]*(n[k]/32767.0);rho[k]+=w[j]*decoded[k];}
                    }
                    for(unsigned k=0;k<3;k++){if(!isfinite(rho[k])||rho[k]<-64*DBL_EPSILON||rho[k]>1+64*DBL_EPSILON)return false;rho[k]=fmax(0,fmin(1,rho[k]));}
                    const double position[3]={world[0]/38,-world[2]/38,-world[1]/38},nn[3]={normal[0],-normal[2],-normal[1]};double rgb[3];
                    if(shader){if(!shader(shader_context,scene,position,nn,rho,rgb))return false;}else if((visibility?fox_disk_eval16_visible(scene,position,nn,rho,visibility,visibility_context,rgb):fox_disk_eval16(scene,position,nn,rho,rgb))!=FOX_DISK_OK)return false;
                    for(unsigned k=0;k<3;k++)if(!isfinite(rgb[k])||rgb[k]<0)return false;
                    unsigned q[3];for(unsigned k=0;k<3;k++){float value=ayatsuri_srgb_encode((float)fmin(1,rgb[k]));q[k]=(unsigned)lroundf(value*(k==1?63:31));}
                    if(stats->shade_updates==UINT64_MAX||stats->disk_samples>UINT64_MAX-48)return false;
                    pixels[at]=(uint16_t)((q[0]<<11)|(q[1]<<5)|q[2]);stats->shade_updates++;stats->disk_samples+=48;
                    /* Commit identity only AFTER the legacy shader/pixel/stats commit. */
                    if(view.node<1||view.node>aa->record_count||face>=64)return false;
                    if(!ring_aa_charge(aa,AA_CENTER_ID_UPDATE,1))return false;
                    aa->center_id[((unsigned)yy%10)*KSN_PROC_W+(unsigned)x]=aa->source[view.node][face];
                    if(!rrh_charge(rd,RH_STORE,3))return false;
                    for(unsigned k=0;k<3;k++){if(!isfinite(rgb[k])||rgb[k]<0)return false;aa->reuse.hdr[at][k]=rgb[k];}
                    continue;
                }
                const float cw[3]={(float)w[0],(float)w[1],(float)w[2]};
                const unsigned red=(unsigned)lroundf(fmaxf(0,fminf(31,cw[0]*(a>>11)+cw[1]*(b>>11)+cw[2]*(c>>11)))),
                    green=(unsigned)lroundf(fmaxf(0,fminf(63,cw[0]*((a>>5)&63)+cw[1]*((b>>5)&63)+cw[2]*((c>>5)&63)))),
                    blue=(unsigned)lroundf(fmaxf(0,fminf(31,cw[0]*(a&31)+cw[1]*(b&31)+cw[2]*(c&31))));
                pixels[at]=(uint16_t)((red<<11)|(green<<5)|blue);
            }
        }
        offset+=view.size;
    }
    return !scene||records==s->packets.packets;
}
