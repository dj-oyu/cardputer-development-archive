"""Pose-only equivalent; keep original rig, mesh and cam unchanged."""
import bpy,math,os,json,sys
from pathlib import Path
from mathutils import Vector,Matrix
from mathutils.bvhtree import BVHTree
P=Path(__file__).resolve().parent
sc=bpy.context.scene; sc.frame_set(13);bpy.context.view_layer.update()
r=next(o for o in sc.objects if o.type=='ARMATURE')
bone=r.pose.bones
names=[q.name for q in bone]
rest={q.name:q.matrix_basis.copy() for q in bone}
matrices={q.name:q.matrix.copy() for q in bone}
dg=bpy.context.evaluated_depsgraph_get()
def upd():bpy.context.view_layer.update()
# Preserve previous actions as selectable assets, while previewing independent seated motion.
r.animation_data.action.use_fake_user=True;r.animation_data.action=None
coll=bpy.data.collections['Gaming Chair Prop']
saved_chair={}
for ob in coll.all_objects:
    if ob.animation_data and ob.animation_data.action:
        m=ob.matrix_world.copy();ob.animation_data.action.use_fake_user=True
        saved_chair[ob.name]=ob.animation_data.action.name;ob.animation_data.action=None;ob.matrix_world=m
legs={k:next(ob for ob in sc.objects if ob.type=='MESH' and ob.name.startswith('Thigh to shin') and ob.vertex_groups.get('thigh.'+k)) for k in ('L','R')}
sleeves={k:next(ob for ob in sc.objects if ob.type=='MESH' and ob.name.startswith('Long ivory varsity sleeve') and ob.vertex_groups.get('forearm.'+k)) for k in ('L','R')}
foremesh={k:next(ob for ob in sc.objects if ob.type=='MESH' and ob.name.startswith('Elbow and narrowing') and ob.vertex_groups.get('forearm.'+k)) for k in ('L','R')}
hands={k:[ob for ob in sc.objects if ob.type=='MESH' and ob.name.startswith(('Relaxed blockout fist','Separate resting thumb')) and ob.vertex_groups.get('hand.'+k)] for k in ('L','R')}
chair=next(ob for ob in coll.objects if ob.name.startswith('Engine chair'))
def objgeom(o):
    d=bpy.context.evaluated_depsgraph_get()
    q=o.evaluated_get(d);m=q.to_mesh();m.calc_loop_triangles()
    v=[q.matrix_world@x.co for x in m.vertices];t=[tuple(z.vertices) for z in m.loop_triangles]
    q.to_mesh_clear();return (v,t)
def as_bvh(v,t):return BVHTree.FromPolygons(v,t,all_triangles=True)
def tree(o):return as_bvh(*objgeom(o))
T={k:tree(o) for k,o in legs.items()}
chair_tree=tree(chair)
def main_y(m):return m.to_3x3()@Vector((0,1,0))
def turn(name,degs,axis='X'):
    q=bone[name];m=q.matrix.copy();rm=(Matrix.Rotation(math.radians(degs),3,axis)@m.to_3x3()).to_4x4();rm.translation=m.translation
    q.matrix=rm;upd()
def aim(name,goal,roll=0):
    q=bone[name];m=q.matrix.copy();v=goal-q.head
    rot=(main_y(m).rotation_difference(v).to_matrix()@m.to_3x3())
    if roll:rot=Matrix.Rotation(math.radians(roll),3,v.normalized())@rot
    pt=rot.to_4x4();pt.translation=m.translation;q.matrix=pt;upd()
def reset():
    for n in names:bone[n].matrix_basis=rest[n]
    upd()
def peak_targets(ix,y0,z0,sym=0):
    # Slight asymmetry while each elbow bears on its own thigh independently.
    return {k:Vector((a*ix,y0+sym*a,z0)) for k,a in [('L',1),('R',-1)]}
def pose(cfg,p=1,pre=0,settle=0):
    reset()
    if p==0 and pre==0:return
    turn('spine',cfg['spine']*p)
    turn('chest',cfg['chest']*p)
    turn('neck',cfg['neck']*p)
    turn('head',cfg['head']*p)
    # The lift stage clears the existing yellow arms before the weight transfer.
    goals=peak_targets(cfg['x'],cfg['y'],cfg['z']+settle,cfg.get('asym',0))
    for k,a in [('L',1),('R',-1)]:
        goals[k]+=Vector((a*cfg.get('x_'+k,0),cfg.get('y_'+k,0),cfg.get('z_'+k,0)))
    for k,a in [('L',1),('R',-1)]:
        el='forearm.'+k;arm='upper-arm.'+k;w='hand.'+k
        o=matrices[el].translation
        m=matrices[w].translation
        q=o.lerp(goals[k],p);q.z+=pre*.145
        q.x+=a*pre*.025
        aim(arm,q,cfg.get('roll',0)*a*p)
        e=bone[el].head.copy()
        # Keep hands separated and above/beyond the knees; elbows take the load.
        final=goals[k]+Vector((-a*cfg['inset'],cfg['w_y'],cfg['w_z']))
        wgoal=m.lerp(final,p);wgoal.z+=pre*.145
        aim(el,wgoal,cfg.get('twist',0)*a*p)
        w0=bone[w].head.copy()
        if p>0:
            target=w0+(bone[el].tail-bone[el].head).normalized()+Vector(((-a*.20)*p,0,-.105*p))
            current=bone[w].tail.copy()
            aim(w,current.lerp(target,.72*p),cfg.get('handroll',0)*a*p)
def test():
    ret={}
    for k in ('L','R'):
        el=bone['forearm.'+k].head.copy();w=bone['hand.'+k].head.copy()
        va,fa=objgeom(sleeves[k]);su=as_bvh(va,fa)
        fs=tree(foremesh[k])
        elbows=[v for v in va if (v-el).length<.29]
        if not elbows:elbows=va
        line=T[k]
        best=min((line.find_nearest(v)[3] for v in elbows),default=99.)
        contact=min(elbows,key=lambda v:line.find_nearest(v)[3])
        closest=line.find_nearest(contact)[0]
        # Each count means triangle overlap, not physical penetration distance.
        ret[k]={'sleeve_leg_overlaps':len(line.overlap(su)),'arm_skin_leg_overlaps':len(line.overlap(fs)),
            'hand_leg_overlaps':sum(len(tree(h).overlap(line)) for h in hands[k]),
            'opposite_leg_overlap':len(T['R' if k=='L' else 'L'].overlap(su))+len(T['R' if k=='L' else 'L'].overlap(fs)),
            'sleeve_chair_overlaps':len(chair_tree.overlap(su)), 'arm_skin_chair_overlaps':len(chair_tree.overlap(fs)),
            'hand_chair_overlaps':sum(len(tree(h).overlap(chair_tree)) for h in hands[k]), 'elbow_vertex_to_leg_surface':float(best),
            'elbow_closest_garment_pos':list(contact),'elbow_contact_point_on_leg':list(closest),
            'elbow':list(el),'wrist':list(w),
            'knee_z_below_elbow':float(line.ray_cast(Vector((el.x,el.y,3.3)),Vector((0,0,-1)))[0].z) if line.ray_cast(Vector((el.x,el.y,3.3)),Vector((0,0,-1)))[0] is not None else None}
    both=[tree(h) for q in hands.values() for h in q]
    ret['cross_hands']=sum(len(a.overlap(b)) for a in both[:2] for b in both[2:])
    return ret
base=dict(spine=35,chest=12,neck=-15,head=-6,x=.39,y=-1.02,z=2.1,asym=.004,inset=.20,w_y=-.67,w_z=.12,roll=0,twist=0,handroll=0)
base_zero=json.loads(Path('chair-idle-lean-knees-73/candidate-motion.json').read_text())['cfg']
# These are the seat's design axes, not eyes relative to an observer.
forward=(r.matrix_world.inverted().to_3x3()@chair.matrix_world.to_3x3()@Vector((0,-1,0))).normalized()
up=(r.matrix_world.inverted().to_3x3()@chair.matrix_world.to_3x3()@Vector((0,0,1))).normalized()
right=forward.cross(up).normalized()
old_pitch=math.degrees(math.asin(max(-1,min(1,(bone['head'].matrix.to_3x3()@Vector((0,0,1))).normalized().dot(up)))))
def aggregate(m):
    return sum(v for q in m.values() if isinstance(q,dict) for k,v in q.items() if k.endswith('overlaps') or k=='opposite_leg_overlap')+m['cross_hands']
def ease(t):
    t=max(0,min(1,t));return t*t*t*(10+t*(-15+6*t))
def wave(f):
    if f<=22:q=f
    elif f>=30:q=50-f
    else:q=22
    p=ease((q-4)/15)
    bump=math.sin(math.pi*max(0,min(1,(q-2)/17)))**1.15
    micro=.004*(.5-.5*math.cos((f-19)*math.tau/11)) if 19<=f<=30 else 0
    return p,bump*float(os.getenv("ARM_LIFT","1.77")),micro,q
def face_info():
    ret={}
    for n in ('head','neck'):
        m=bone[n].matrix.to_3x3()
        fw=(m@Vector((0,0,1))).normalized(); side=(m@Vector((1,0,0))).normalized()
        ret[n]={'seat_local_frontal_axis':[fw.dot(right),fw.dot(forward),fw.dot(up)],'pitch_deg':math.degrees(math.asin(max(-1,min(1,fw.dot(up))))),'yaw_deg':math.degrees(math.atan2(fw.dot(right),fw.dot(forward))), 'roll_component':side.dot(up)}
    return ret
def face(q,p):
    # Split part of the compensation across the neck; hold exact head facing at both terminal poses.
    settle=ease((q-11)/8)
    turn('neck',float(os.getenv('NECK_DELTA','13'))*p*settle)
    neck=bone['neck'];hm=neck.matrix.copy()
    neck.scale.y*=1+p*settle*float(os.getenv('STRETCH','0'))
    upd()
    b=bone['head']
    # In the head's parent/rest frame, solve the true inverse-transformed forward vector.
    basis=b.matrix_basis.to_3x3()
    parent_rest=(b.parent.matrix@b.parent.bone.matrix_local.inverted()@b.bone.matrix_local).to_3x3()
    cur=(basis@Vector((0,0,1))).normalized()
    want=(parent_rest.inverted()@forward).normalized()
    fix=cur.rotation_difference(want)
    w=max(1-ease((q-2)/8),settle)
    if w>0:
        rot=fix.to_matrix() if w>=1 else fix.__class__((1,0,0,0)).slerp(fix,w).to_matrix()
        b.rotation_euler=(rot@basis).to_euler('XYZ',b.rotation_euler);upd()
if os.getenv('MODE','search')=='search':
    import random
    rng=random.Random(193)
    for k in ['L','R']:
        opts=[]
        for j in range(750):
            cfg=dict(base_zero)
            cfg['chest']+=float(os.getenv('CHEST_DELTA','0'))
            # The knees move medially and remain near old height on the .12 raised neutral.
            for component,mid,extent in [('x',-.045,.095),('y',.006,.135),('z',-.006,.12)]:
                tag=component+'_'+k
                cfg[tag]=base_zero.get(tag,0)+mid+(rng.uniform(-extent,extent) if j else 0)
            pose(cfg,settle=.003)
            m=test()[k]
            bad=sum(v for x,v in m.items() if x.endswith('overlaps') or x=='opposite_leg_overlap')
            gap=m['elbow_vertex_to_leg_surface']
            cost=bad*1000+abs(gap-({'L':.024,'R':.016}[k]))*110
            cost+=sum((cfg.get(t+'_'+k,0)-base_zero.get(t+'_'+k,0))**2 for t in ('x','y','z'))*55
            if m['knee_z_below_elbow'] is None:cost+=4
            opts.append((cost,j,cfg,m))
        opts.sort(key=lambda t:t[:2])
        (P/f'opt_{k}.json').write_text(json.dumps(opts[:30],indent=2))
        print('OPT',k,opts[0])
    sys.exit(0)

L=json.loads((P/'opt_L.json').read_text());R=json.loads((P/'opt_R.json').read_text())
newcfg=dict(base_zero)
newcfg['chest']+=float(os.getenv('CHEST_DELTA','0'))
for k,opts in [('L',L),('R',R)]:
    newcfg.update({t+'_'+k:opts[0][2][t+'_'+k] for t in ('x','y','z')})
print('CFG',newcfg)
arm_keys=[f'{p}.{i}' for p in ('upper-arm','forearm','hand') for i in ('L','R')]
cols=('spine','chest','neck','head',*arm_keys)
act=bpy.data.actions.new('v75 • seated lean, face forward')
act.use_fake_user=True;r.animation_data.action=act
torso=[ob for ob in sc.objects if ob.type=='MESH' and ob.name.startswith(('Soft ivory tee base','Jacket cut front and back','Cropped jacket hem','Open jacket front binding'))]
head_mesh=[ob for ob in sc.objects if ob.type=='MESH' and ob.name.startswith(('Sculpted cheeks','Ear shell','Bob back','Large right side-sweep','Left wide brushed','Little lifted','Left swept','Right framing'))]
def crossings():
    z={}
    for ob in torso:
        m=tree(ob);z[ob.name]={'chair':len(m.overlap(chair_tree)),'thigh':sum(len(m.overlap(t)) for t in T.values())}
    return z
def head_crossings():
    # Avoid hair/body, chair/body here only for those meshes adjusted near neck.
    chest_refs=[tree(ob) for ob in torso]
    return {o.name:{'collar':sum(len(tree(o).overlap(t)) for t in chest_refs),'chair':len(tree(o).overlap(chair_tree))} for o in head_mesh}
if os.getenv('MODE')=='contact':
    scan=[]
    basech=newcfg['chest']
    for n in (-34,-29,-24,-21,-18,-15,-12,-9,-6,-3,0):
        os.environ['NECK_DELTA']=str(n)
        for c in (-10,-8,-6,-4,-2,0):
            newcfg['chest']=basech+c
            for qy in (0,.05,.08,.11,.14,.17,.20,.22,.25,.27):
                os.environ['STRETCH']=str(qy)
                strength,pre,st,q=wave(22);pose(newcfg,strength,pre,st);face(q,strength)
                checks=head_crossings()
                cv=sum(o['collar'] for o in checks.values());hv=sum(o['chair'] for o in checks.values())
                cf=abs(face_info()['head']['pitch_deg'])
                obj=cv*500+hv*500+3*abs(n)/12+abs(c)*1.8+qy*220+50*cf
                scan.append((obj,n,c,qy,cv,hv,cf))
    (P/'head-options-2.json').write_text(json.dumps(sorted(scan),indent=2))
    print(sorted(scan)[:15])
    sys.exit(0)
if os.getenv('MODE')=='contact_old':
    scan=[]
    for n in (-12,-7,-3,0,4,8,12,20,28,38):
        os.environ['NECK_DELTA']=str(n)
        for fw in (0,.015,.03,.045,.06,.08,.10,.12):
            os.environ['NECK_FWD']=str(fw)
            for z in (0,.015,.03,.045,.06,.08,.09,.12):
                os.environ['NECK_UP']=str(z)
                strength,pre,st,q=wave(22);pose(newcfg,strength,pre,st);face(q,strength)
                checks=head_crossings()
                cv=sum(o['collar'] for o in checks.values());hv=sum(o['chair'] for o in checks.values())
                c=cv*500+hv*500+2*abs(n)/12+(fw**2+z**2)**.5*100
                scan.append((c,n,fw,z,cv,hv))
    (P/'head-options.json').write_text(json.dumps(sorted(scan),indent=2))
    print(sorted(scan)[:10])
    sys.exit(0)
if os.getenv('MODE')=='profiles':
    scan=[]
    for n in (-8,-4,0,4,8,12,16,20,24,28):
        os.environ['NECK_DELTA']=str(n)
        for u in (1.56,1.68,1.80,1.92):
            os.environ['ARM_LIFT']=str(u)
            a=0; c=0; h=0; charges=[]
            for i in range(81):
                f=5+i*.25
                strength,pre,st,q=wave(f);pose(newcfg,strength,pre,st);face(q,strength)
                m=aggregate(test());hc=head_crossings()
                cv=sum(o['collar'] for o in hc.values());hv=sum(o['chair'] for o in hc.values())
                a+=m;c+=cv;h+=hv
                if m or cv or hv:charges.append((f,m,cv,hv))
            print(n,u,a,c,h,flush=True)
            scan.append((a+c+h,n,u,a,c,h,charges))
    (P/'path-options.json').write_text(json.dumps(sorted(scan),indent=2))
    sys.exit(0)
recs=[]; issues=[]
for f in range(1,50):
    strength,pre,st,q=wave(f)
    pose(newcfg,strength,pre,st)
    before=face_info()
    face(q,strength)
    m=test();ct=crossings()
    bad=aggregate(m)
    hc=head_crossings()
    if recs:
        if any(any(v>recs[0]['torso_overlap'][n][k] for k,v in a.items()) for n,a in ct.items()):issues.append((f,'torso',ct))
        if any(any(v>recs[0]['head_overlap'][n][k] for k,v in a.items()) for n,a in hc.items()):issues.append((f,'head',hc))
    if bad:issues.append((f,'arm',bad,m))
    recs.append({'f':f,'old_head_uncompensated':before,'seated_head':face_info(),'elbows':m,'overlap':bad,'torso_overlap':ct,'head_overlap':hc})
    for n in cols:
        b=bone[n];b.keyframe_insert('rotation_euler',frame=f,group=n)
        if n in ('spine','chest','neck','head'):b.keyframe_insert('location',frame=f,group=n)
        if n=='neck' and float(os.getenv('STRETCH','0')):
            b.keyframe_insert('scale',frame=f,group=n)
print('MOTION_CHECK',json.dumps(issues))
package={'source':bpy.data.filepath,'selected_v73_profile':base_zero,'retargeted_profile':newcfg,'before_neutral_pitch_deg':old_pitch,'chair_forward_armature_space':list(forward),'checks':recs,'issues':issues,
         'previous_chair_actions':saved_chair,'parent_action':sc.get('v74_selected_fit',None)}
(P/'candidate-motion.json').write_text(json.dumps(package,indent=2))
assert not issues,issues
for curve in act.fcurves:
    for k in curve.keyframe_points:k.interpolation='LINEAR'
sc['v75_idle']='Isolated lean at the v74 neutral seat, authored f1–49 at 10fps. Retargeted elbows and seat-local horizontal face at settles/return. v74 chair and human swivel tracks retained as inactive actions.'
sc['v75_original_rig_action']='v74 +.12 BU • synchronized seat, planted feet'
sc['v75_original_chair_actions']=json.dumps(saved_chair)
sc.frame_set(22)
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(P/'chair-idle-lean-forward-v75.blend'),compress=True)
