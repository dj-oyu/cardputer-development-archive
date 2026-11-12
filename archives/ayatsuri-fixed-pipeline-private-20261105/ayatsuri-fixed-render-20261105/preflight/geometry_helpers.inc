/* Verbatim unchanged geometry helpers from pinned ksn_mesh_depth.c. */
typedef struct {double a,b,c;int sign;bool closed;} gouraud_edge;
static gouraud_edge gouraud_make_edge(const co_vertex *a,const co_vertex *b){
    const double dx=(double)b->x-a->x,dy=(double)b->y-a->y;
    gouraud_edge edge={.sign=1,.closed=dy<0||(dy==0&&dx>0)};
    /* Both triangles evaluate a shared edge in the same canonical direction.
     * Reversing it only negates the result, including exact zero at ties. */
    if(a->x>b->x||(a->x==b->x&&a->y>b->y)){
        const co_vertex *swap=a;a=b;b=swap;edge.sign=-1;
    }
    edge.a=(double)a->y-b->y;edge.b=(double)b->x-a->x;
    edge.c=((double)b->y-a->y)*a->x-((double)b->x-a->x)*a->y;return edge;
}
static double gouraud_edge_value(const gouraud_edge *e,int x,int y){return e->sign*(e->a*x+e->b*y+e->c);}

