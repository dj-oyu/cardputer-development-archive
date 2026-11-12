/* Verbatim pure helpers from indexed-bounds private-build/transport/bounce.c. */
static double dot(const double a[3],const double b[3]){return a[0]*b[0]+a[1]*b[1]+a[2]*b[2];}
static int norm(const double n[3],double out[3]){double m=fmax(fabs(n[0]),fmax(fabs(n[1]),fabs(n[2])));if(!isfinite(n[0])||!isfinite(n[1])||!isfinite(n[2])||!(m>0))return 0;double t[3]={n[0]/m,n[1]/m,n[2]/m};double l=sqrt(dot(t,t));for(int k=0;k<3;k++)out[k]=t[k]/l;return 1;}
static void cross(const double a[3],const double b[3],double r[3]){r[0]=a[1]*b[2]-a[2]*b[1];r[1]=a[2]*b[0]-a[0]*b[2];r[2]=a[0]*b[1]-a[1]*b[0];}
static void direction(const double n[3],unsigned count,unsigned idx,double d[3]){
 unsigned m=count==16?2:4,az=idx%(4*m),ring=idx/(4*m);double r=sqrt((ring+.5)/m),phi=6.283185307179586476925286766559*(az+.5*(ring%2))/(4*m);
 double ref[3]={0,0,0},u[3],v[3];int axis=0;if(fabs(n[1])<fabs(n[axis]))axis=1;if(fabs(n[2])<fabs(n[axis]))axis=2;ref[axis]=1;cross(ref,n,u);norm(u,u);cross(n,u,v);
 for(int k=0;k<3;k++)d[k]=r*cos(phi)*u[k]+r*sin(phi)*v[k]+sqrt(1-r*r)*n[k];
 norm(d,d);
}
