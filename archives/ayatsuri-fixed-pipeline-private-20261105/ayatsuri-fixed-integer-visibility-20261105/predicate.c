#include <stdint.h>
#include <limits.h>
typedef __int128 I;typedef unsigned __int128 U;
/* Proof domain: every input coordinate <=8*2^f, f=16 or20.
 * Status:0 miss,1 hit,2 epsilon-interval unresolved,3 domain/short segment.
 * All coordinates are exact lattice inputs. No float fallback is silently run. */
static I triple(const int64_t a[3],const int64_t b[3],const int64_t c[3]){return (I)a[0]*((I)b[1]*c[2]-(I)b[2]*c[1])+(I)a[1]*((I)b[2]*c[0]-(I)b[0]*c[2])+(I)a[2]*((I)b[0]*c[1]-(I)b[1]*c[0]);}
static int ratio(U a,U b,U c,U d){int sign=1;for(;;){U q=a/b,r=c/d;if(q!=r)return sign*(q>r?1:-1);a%=b;c%=d;if(!a||!c)return sign*(a?1:c?-1:0);U t=a;a=b;b=t;t=c;c=d;d=t;sign=-sign;}}
static uint64_t root(uint64_t n){uint64_t lo=0,hi=UINT64_C(1)<<32;while(lo+1<hi){uint64_t m=lo+(hi-lo)/2;if(m<=n/m)lo=m;else hi=m;}return lo;}
int qratio_compare(uint64_t ah,uint64_t al,uint64_t bh,uint64_t bl,uint64_t ch,uint64_t cl,uint64_t dh,uint64_t dl){U a=((U)ah<<64)|al,b=((U)bh<<64)|bl,c=((U)ch<<64)|cl,d=((U)dh<<64)|dl;if(!b||!d)return 9;return ratio(a,b,c,d);}
int qtriangle(const int32_t xyz[15],int f,uint64_t out[5]){if(f!=16&&f!=20)return 3;int64_t bound=INT64_C(8)<<f;for(int k=0;k<15;k++)if(xyz[k]<-bound||xyz[k]>bound)return 3;int64_t e1[3],e2[3],d[3],t[3];uint64_t l2=0;for(int k=0;k<3;k++){e1[k]=(int64_t)xyz[3+k]-xyz[k];e2[k]=(int64_t)xyz[6+k]-xyz[k];d[k]=(int64_t)xyz[12+k]-xyz[9+k];t[k]=(int64_t)xyz[9+k]-xyz[k];l2+=(uint64_t)(d[k]*d[k]);}uint64_t fl=root(l2),ce=fl+(fl*fl!=l2),scale=UINT64_C(1)<<f;if(fl*100000<=2*scale)return 3;I det=triple(e1,d,e2),u=triple(t,d,e2),v=triple(d,t,e1),num=triple(e2,t,e1);if(det<0){det=-det;u=-u;v=-v;num=-num;}if(!det||u<0||v<0||u+v>det||num<=0||num>=det)return 0;out[0]=(uint64_t)((U)num>>64);out[1]=(uint64_t)num;out[2]=(uint64_t)((U)det>>64);out[3]=(uint64_t)det;out[4]=(det<=INT64_MAX&&u<=INT64_MAX&&v<=INT64_MAX&&num<=INT64_MAX);I near=num<det-num?num:det-num;int above=ratio(near,det,scale,(U)100000*fl);if(above>0)return 1;int below=ratio(near,det,scale,(U)100000*ce);if(below<=0)return 0;return 2;}
/* Inclusive segment-vs-box broad phase. Integer slab ratios, no reciprocal.
 * Leaves endpoint epsilon to the narrow predicate, preventing false culls. */
int qbox(const int32_t a[12],int f){if(f!=16&&f!=20)return 3;int64_t B=INT64_C(8)<<f;for(int k=0;k<12;k++)if(a[k]<-B||a[k]>B)return 3;I ln=0,ld=1,hn=1,hd=1;for(int k=0;k<3;k++){int64_t lo=a[k],hi=a[3+k],o=a[6+k],d=(int64_t)a[9+k]-o;if(lo>hi)return 3;if(!d){if(o<lo||o>hi)return 0;continue;}I x=lo-o,z=hi-o,den=d;if(den<0){den=-den;I old=x;x=-z;z=-old;}if(z<0||x>den)return 0;if(x>0&&ratio(x,den,ln,ld)>0){ln=x;ld=den;}if(z>=0&&ratio(z,den,hn,hd)<0){hn=z;hd=den;}if(ratio(ln,ld,hn,hd)>0)return 0;}return 1;}
