import numpy as np,ctypes

def filter_grid(n):
 assert n in (1,3,5)
 if n==1:return np.array([0.]),np.array([1.])
 x=-1.5+(np.arange(n)+.5)*3/n;t=2*np.pi*(x/3+.5)
 w=.35875-.48829*np.cos(t)+.14128*np.cos(2*t)-.01168*np.cos(3*t)
 assert np.isfinite(w).all() and (w>0).all();w=w/w.sum()
 assert np.allclose(w,w[::-1],rtol=0,atol=1e-15) and abs(w.sum()-1)<1e-15
 return x,w

def tests(raster):
 for n in (1,3,5):
  x,w=filter_grid(n);ww=np.outer(w,w);assert abs(ww.sum()-1)<1e-15;assert np.allclose(np.sum(ww[...,None]*np.array([.2,.7,2.]),axis=(0,1)),[.2,.7,2.],rtol=0,atol=1e-15)
 assert np.array_equal(.5*np.array([1.,.5,.2])+.5*np.zeros(3),[.5,.25,.1])
 # Shared-edge square, tie keeps earlier submitted face, closer face wins.
 t=np.array([[1,0,0,0,1,2,10,10,1,12,10,1,12,12,1],[1,1,0,0,2,3,10,10,1,12,12,1,10,12,1]],np.float32)
 def call(a,x=0,y=0):
  a=np.ascontiguousarray(a,dtype=np.float32);win=np.zeros((135,240),np.int32);ws=np.zeros((135,240,3),np.float32);rc=raster(a.ctypes.data,len(a),x,y,win.ctypes.data,ws.ctypes.data);return rc,win,ws
 rc,w,_=call(t);assert rc==1 and (w>=0).sum()==4
 duplicate=np.concatenate([t,t]);assert np.array_equal(call(duplicate)[1],w)
 duplicate[2:, [8,11,14]]=2;new=call(duplicate)[1];assert np.array_equal(new[new>=0],w[w>=0]+2)
 for value in [np.nan,np.inf,1e30]:
  bad=t.copy();bad[0,6]=value;assert call(bad)[0]==0
 bad=t.copy();bad[0,9:12]=bad[0,6:9];assert call(bad)[0]==0
 assert call(t,2,0)[0]==0
 return {'passed':True,'filterGrids':{str(n):{'offsets':filter_grid(n)[0].tolist(),'weights1D':filter_grid(n)[1].tolist()} for n in (1,3,5)}}
