import numpy as np
EPS_AREA=1e-12
EPS_FACING=1e-12

def geometric_normal(triangle,view):
 t=np.asarray(triangle,dtype=np.float64);v=np.asarray(view,dtype=np.float64)
 if t.shape!=(3,3) or v.shape!=(3,) or not np.isfinite(t).all() or not np.isfinite(v).all():raise ValueError('nonfinite/shape')
 vnorm=np.linalg.norm(v)
 if not np.isfinite(vnorm) or vnorm<=0:raise ValueError('zero view')
 v=v/vnorm;n=np.cross(t[1]-t[0],t[2]-t[0]);length=np.linalg.norm(n)
 if not np.isfinite(length) or length<=EPS_AREA:raise ValueError('zero/tiny triangle')
 facing=float(n@v)
 if not np.isfinite(facing) or abs(facing)<=EPS_FACING:raise ValueError('ambiguous edge-on')
 if facing<0:n=-n
 return np.ascontiguousarray(n)

def tests():
 t=np.array([[0,0,0],[1,0,0],[0,1,0]],float)
 for rev in [False,True]:
  p=t[::-1] if rev else t
  assert np.array_equal(geometric_normal(p,[0,0,1]),[0,0,1])
  assert np.array_equal(geometric_normal(p,[0,0,-1]),[0,0,-1])
 for p,v in [(np.zeros((3,3)),[0,0,1]),(t,[0,0,0]),(t,[1,0,0]),(t*np.nan,[0,0,1]),(t,[0,0,np.inf]),(t*1e-7,[0,0,1])]:
  try:geometric_normal(p,v)
  except ValueError:continue
  raise AssertionError('expected rejection')
 return {'windingAndViewOrientations':4,'rejectionCases':6,'pass':True}
if __name__=='__main__':print(tests())
