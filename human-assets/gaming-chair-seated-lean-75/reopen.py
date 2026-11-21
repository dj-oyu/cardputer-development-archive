"""Reopen verified candidate, do no pose edits. Collision, anchors, render diagnostics."""
import bpy,sys,math,json,os
from pathlib import Path
from mathutils import Vector
from hashlib import sha256
from mathutils.bvhtree import BVHTree
P=Path(__file__).resolve().parent
s=bpy.context.scene;r=next(o for o in s.objects if o.type=='ARMATURE');control=next(o for o in s.objects if o.name.startswith('CAM CONTROLS'))
mode=os.getenv('CHECK','verify')
def upd():bpy.context.view_layer.update()
def geom(o):
    g=bpy.context.evaluated_depsgraph_get()
    e=o.evaluated_get(g);m=e.to_mesh();m.calc_loop_triangles()
    vs=[e.matrix_world@v.co for v in m.vertices];pol=[tuple(t.vertices) for t in m.loop_triangles]
    e.to_mesh_clear();return vs,pol
if mode=='verify':
    s.frame_set(1);upd()
    coll=bpy.data.collections['Gaming Chair Prop']
    moving=[x for x in coll.objects if x.type=='MESH']
    stand={o.name:geom(o)[0] for o in moving}
    def tree(o):
        vs,pol=geom(o)
        return BVHTree.FromPolygons(vs,pol,all_triangles=True)
    def get(suffix,starting):
        return [o for o in s.objects if o.type=='MESH' and o.name.startswith(starting) and any(g.name.endswith('.'+suffix) for g in o.vertex_groups)]
    legs={k:tree(get(k,'Thigh to shin')[0]) for k in ('L','R')}
    arms={k:get(k,('Long ivory varsity sleeve','Elbow and narrowing','Relaxed blockout fist','Separate resting thumb')) for k in ('L','R')}
    sh=next(o for o in moving if o.name.startswith('Engine chair'))
    shell=tree(sh)
    local=sh.matrix_world.inverted().to_3x3()
    def seatface(n,v):
        return (local@r.matrix_world.to_3x3()@r.pose.bones[n].matrix.to_3x3()@Vector(v)).normalized()
    torso=[o for o in s.objects if o.type=='MESH' and o.name.startswith(('Soft ivory tee base','Jacket cut front and back','Cropped jacket hem','Open jacket front binding'))]
    headob=[o for o in s.objects if o.type=='MESH' and o.name.startswith(('Sculpted cheeks','Ear shell','Bob back','Large right side-sweep','Left wide brushed','Little lifted','Left swept','Right framing'))]
    stationary_nodes=['root','pelvis',*[f'{b}.{k}' for b in ('thigh','shin','foot') for k in ('L','R')]]
    bones0={n:r.pose.bones[n].matrix.copy() for n in stationary_nodes}
    neutral_head={n:r.pose.bones[n].head.copy() for n in ('spine','head','forearm.L','forearm.R')}
    vals=[] 
    for tick in range(97):
        frame=tick//2+1;sub=(tick%2)/2
        s.frame_set(frame,subframe=sub);upd()
        now={o.name:geom(o)[0] for o in moving}
        chair_d=max((x-y).length for ob,v in stand.items() for x,y in zip(v,now[ob]))
        fixed=max(abs(m[i][j]-r.pose.bones[n].matrix[i][j]) for n,m in bones0.items() for i in range(4) for j in range(4))
        q={}
        for k in ('L','R'):
            hu=[tree(o) for o in arms[k]]
            a=sum(len(o.overlap(other)) for o in hu for other in (*legs.values(),shell))
            el=r.pose.bones['forearm.'+k].head.copy()
            vs=list(v for v in geom(arms[k][0])[0] if (v-el).length<.29)
            assert vs
            gap=min(legs[k].find_nearest(v)[3] for v in vs)
            q[k]={'triangle_crossings_with_any_leg_or_shell':a,'gap_elbow_to_leg':float(gap),
                  'elbow_head':list(el)}
        assert chair_d==0 and fixed<1e-6 and all(t['triangle_crossings_with_any_leg_or_shell']==0 for t in q.values()),(tick,chair_d,fixed,q)
        fwd=seatface('head',(0,0,1));neck=seatface('neck',(0,0,1));roll=seatface('head',(1,0,0))
        z=frame+sub
        still=(z <= 2 or 19 <= z <= 31 or z >= 48)
        if still:
            assert (fwd-Vector((0,-1,0))).length < 2e-5 and (roll-Vector((1,0,0))).length < 2e-5,(z,fwd,roll)
        body=[tree(o) for o in torso]
        nh=sum(len(tree(o).overlap(tr)) for o in headob for tr in body+[shell])
        assert nh==0,(tick,'new head intersection',nh)
        vals.append({'face_seat_space':list(fwd),'head_roll_axis_seat_space':list(roll),'neck_seat_space':list(neck),'exact_forward_required':still,'head_body_overlap':nh,'f':frame+sub,'chair_vertex_drift_BU':chair_d,'fixed_hip_leg_and_root_matrix_diff':fixed,
                     'elbows':q,'head_forward':float(neutral_head['head'].y-r.pose.bones['head'].head.y)})
    act=r.animation_data.action
    assert act.name.startswith('v75')
    assert 'v74 +.12 BU • synchronized seat, planted feet' in bpy.data.actions and 'v70 • seated upper-frame swivel, fixed soles' in bpy.data.actions and 'Cardputer | 椅子に座る・待機' in bpy.data.actions
    assert not any(any(z in k.data_path for z in ('"root"','"pelvis"','"thigh.','"shin.','"foot.')) for k in act.fcurves)
    act_name=act.name; a_names=[x.name for x in bpy.data.actions]
    candidate=bpy.data.filepath
    def model_signature():
        return {o.name:[[(tuple(v.co),[(g.group,g.weight) for g in v.groups]) for v in o.data.vertices],[(tuple(v.vertices),v.material_index,v.use_smooth) for v in o.data.polygons],list(m.name for m in o.data.materials)] for o in s.objects if o.type=='MESH'}
    m0=model_signature(); source=Path(os.environ['SOURCE']).resolve();source_expected=os.environ['SOURCE_SHA']
    assert sha256(source.read_bytes()).hexdigest()==source_expected
    bpy.ops.wm.open_mainfile(filepath=str(source))
    s=bpy.context.scene;r=next(o for o in s.objects if o.type=='ARMATURE')
    s.frame_set(13);upd()
    assert m0==model_signature()
    exact0={n:max(abs(r.pose.bones[n].matrix[i][j]-m[i][j]) for i in range(4) for j in range(4)) for n,m in bones0.items()}
    assert max(exact0.values())<1e-6,exact0
    coll=bpy.data.collections['Gaming Chair Prop']
    chair_at_neutral=max((v-w).length for o in coll.objects if o.type=='MESH' for v,w in zip(geom(o)[0],stand[o.name]))
    assert chair_at_neutral==0
    print('NEUTRAL exact',exact0,'chair',chair_at_neutral)
    rec={'mesh_data_exact_to_v74':True,'v74_source_sha256':source_expected,'v74_neutral_match_by_bone':exact0,'v74_neutral_chair_surface_drift':chair_at_neutral,'subframe_pass':vals,'active_action':act_name,'other_actions':a_names}
    (P/'reopen-receipt.json').write_text(json.dumps(rec,indent=2)+'\n')
else:
    yaw,pitch={'side':(90,7.31),'three-quarter':(145,10.),'front':(180,10.)}[mode]
    control['yaw_deg']=float(yaw);control['pitch_deg']=float(pitch);control.update_tag();upd()
    s.render.engine='CYCLES';s.cycles.samples=24;s.cycles.seed=177;s.cycles.use_adaptive_sampling=False;s.cycles.use_denoising=False
    s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100
    s.render.film_transparent=False;s.render.image_settings.file_format='PNG';s.render.image_settings.color_mode='RGB'
    for o in s.objects:
        if o.type=='LIGHT' or 'floor' in o.name.lower():o.hide_render=True
    def light(x,p,radius):
        d=bpy.data.lights.new('QA area','AREA');d.energy=p;d.shape='DISK';d.size=radius
        o=bpy.data.objects.new('QA area',d);s.collection.objects.link(o);o.location=x
        o.rotation_euler=(Vector((0,0,2))-o.location).to_track_quat('-Z','Y').to_euler()
    light((3,5,6),730,5);light((-4,4,5),410,4);light((0,-5,6),590,5)
    s.world=bpy.data.worlds.new('Neutral studio');s.world.use_nodes=True
    s.world.node_tree.nodes['Background'].inputs[0].default_value=(.18,.18,.18,1)
    s.world.node_tree.nodes['Background'].inputs[1].default_value=.70
    out=P/'renders'/os.getenv('LABEL','final')/mode;out.mkdir(exist_ok=True,parents=True)
    fs=[1,10,22,34,49] if os.getenv('STILLS') else range(1,50)
    for f in fs:
        s.frame_set(f);upd()
        s.render.filepath=str(out/f'{f:03}.png')
        bpy.ops.render.render(write_still=True)
