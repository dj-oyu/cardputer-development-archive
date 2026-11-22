import math
N=48
FPS=10
def track(tm,durations):
 f=round(tm*1000)%sum(durations)
 for i,d in enumerate(durations):
  if f<d:return i
  f-=d
 return 0
def state(i):
 tm=i/FPS
 yaw=-35*math.cos(2*math.pi*i/N)
 b=track(tm,(115,110,130,105,75,120))
 slosh=('left','settled','right','settled')[track(tm,(460,340,460,340))]
 engine=track(tm,(120,115,115,120,120,130)*2)
 return yaw,b,slosh,engine
