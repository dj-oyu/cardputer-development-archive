#!/usr/bin/env python3
"""Synthetic geometry only. Independent Gauss-Legendre radial integration.
No Blender, images, or renderer oracle are imported/read by this test.
"""
import ctypes as C
import json
import math
from pathlib import Path
import numpy as np

HERE = Path(__file__).resolve().parent
D3 = C.c_double * 3
class Input(C.Structure):
    _fields_ = [('shape', C.c_int), ('center', D3), ('rotation_xyz', D3), ('color', D3), ('power', C.c_double), ('diameter', C.c_double)]
class Light(C.Structure):
    _fields_ = [('center', D3), ('normal', D3), ('axis_u', D3), ('axis_v', D3), ('power_rgb_over_pi_squared', D3), ('radius', C.c_double)]
class Scene(C.Structure):
    _fields_ = [('lights', Light*3), ('world_radiance', D3)]
lib = C.CDLL(str(HERE/'libfox_disk_lighting.so'))
lib.fox_disk_scene_init.argtypes = [C.POINTER(Scene), C.POINTER(Input), C.POINTER(C.c_double), C.c_double]
lib.fox_disk_eval16.argtypes = [C.POINTER(Scene)] + [C.POINTER(C.c_double)]*4
lib.fox_disk_eval_diagnostic.argtypes = [C.POINTER(Scene)] + [C.POINTER(C.c_double)]*3 + [C.c_uint, C.POINTER(C.c_double)]

def rotation(e):
    x,y,z = e
    cx,sx,cy,sy,cz,sz = math.cos(x),math.sin(x),math.cos(y),math.sin(y),math.cos(z),math.sin(z)
    rx = np.array([[1,0,0],[0,cx,-sx],[0,sx,cx]],dtype=float)
    ry = np.array([[cy,0,sy],[0,1,0],[-sy,0,cy]],dtype=float)
    rz = np.array([[cz,-sz,0],[sz,cz,0],[0,0,1]],dtype=float)
    return rz@ry@rx

NODES = {}
def independent(case, radial=256, azimuth=2048):
    # Uniform-area disk: t=(r/R)^2 uniform in [0,1]; average over phi.
    if radial not in NODES:
        t,w = np.polynomial.legendre.leggauss(radial)
        NODES[radial] = ((t+1)/2,w/2)
    t,w = NODES[radial]
    phi = 2*math.pi*(np.arange(azimuth)+0.5)/azimuth
    rr = np.sqrt(t)[:,None]*case.get('radius',1)
    x,y = rr*np.cos(phi),rr*np.sin(phi)
    points = np.stack([x,y,np.zeros_like(x)],axis=-1)
    r = rotation(case.get('euler',[0,0,0]))
    delta = points@r.T + np.array(case.get('center',[0,0,2])) - np.array(case.get('position',[0,0,0]))
    r2 = np.sum(delta*delta,axis=-1)
    wi = delta / np.sqrt(r2)[...,None]
    sn = r@np.array([0,0,-1])
    rn = np.array(case.get('normal',[0,0,1]),dtype=float)
    rn /= np.linalg.norm(rn)
    kernel = np.maximum(0,-wi@sn)*np.maximum(0,wi@rn)/r2
    mean = float(w@np.mean(kernel,axis=1))
    return case.get('power',1)*case.get('rho',1)*mean/(math.pi**2)

def native(case, bands=None):
    inputs = (Input*3)()
    for j in range(3):
        inputs[j] = Input(1,D3(*case.get('center',[0,0,2])),D3(*case.get('euler',[0,0,0])),D3(*([1,1,1] if j==0 else [0,0,0])),case.get('power',1),2*case.get('radius',1))
    scene=Scene()
    assert lib.fox_disk_scene_init(C.byref(scene),inputs,D3(0,0,0),0)==0
    p=D3(*case.get('position',[0,0,0])); n=D3(*case.get('normal',[0,0,1])); rho=D3(*([case.get('rho',1)]*3)); out=D3()
    if bands is None:
        status=lib.fox_disk_eval16(C.byref(scene),p,n,rho,out)
    else:
        status=lib.fox_disk_eval_diagnostic(C.byref(scene),p,n,rho,bands,out)
    assert status==0, (case,status)
    assert all(math.isfinite(x) and x>=0 for x in out)
    return out[0]

def relative(value, reference):
    return (value/reference-1) if reference>1e-15 else None

cases = [
    {'name':'axis_radius1_height2'},
    {'name':'axis_radius1_height1','center':[0,0,1]},
    {'name':'axis_near_disk_height0.25','center':[0,0,0.25]},
    {'name':'axis_far_height10','center':[0,0,10]},
    {'name':'offset_x0.9_y0.3','position':[0.9,0.3,0]},
    {'name':'receiver_tilt60','normal':[math.sin(math.pi/3),0,math.cos(math.pi/3)]},
    {'name':'receiver_grazing85','normal':[math.sin(85*math.pi/180),0,math.cos(85*math.pi/180)]},
    {'name':'source_tilt45','euler':[math.pi/4,0,0]},
    {'name':'source_general_rotation','euler':[0.5,-0.25,0.7],'position':[0.4,-0.2,0],'normal':[-0.3,0.1,1]},
    {'name':'small_radius0.2','radius':0.2},
    {'name':'large_radius2','radius':2},
    {'name':'source_back','euler':[math.pi,0,0]},
    {'name':'receiver_back','normal':[0,0,-1]},
    {'name':'energy_rho','power':2.5,'rho':0.3},
]
rows=[]
for case in cases:
    ref1=independent(case,128,1024)
    ref=independent(case)
    vals = {'fixed16':native(case),'diagnostic64':native(case,4),'diagnostic65536':native(case,128),'diagnostic262144':native(case,256)}
    if case['name']=='axis_near_disk_height0.25':
        vals['diagnostic1048576']=native(case,512)
    row={'case':case,'reference_gauss256_azimuth2048':ref,'reference_coarse_delta_abs':abs(ref-ref1),'values':vals,'relative_errors':{k:relative(v,ref) for k,v in vals.items()},'absolute_errors':{k:abs(v-ref) for k,v in vals.items()}}
    if ref>1e-15:
        assert abs(ref-ref1)/ref < 3e-5, row
    else:
        assert max(vals.values())<1e-15
    rows.append(row)

analytic=1/(5*math.pi**2)
assert abs(rows[0]['reference_gauss256_azimuth2048']/analytic-1)<1e-13
assert abs(rows[0]['relative_errors']['fixed16'])<0.0033
assert abs(rows[0]['relative_errors']['diagnostic64'])<0.0008
assert abs(rows[0]['relative_errors']['diagnostic262144'])<2e-7
# The hard near-source case is a disclosed quadrature limitation, not a pass
# criterion that would allow tuning the fixed production rule to an image.
summary={
    'kind':'synthetic_direct_Lambert_DISK_only',
    'production_rule':'2 radial equal-area midpoint bands x 8 azimuths; alternate ring half-step phase',
    'diagnostic_rule':'m bands x 4m azimuths; same deterministic family',
    'independent_reference':'256-point Gauss-Legendre in squared radius x 2048 midpoint azimuths, compared with128 x1024',
    'rows':rows,
    'max_fixed16_abs_relative_error_nonzero':max(abs(r['relative_errors']['fixed16']) for r in rows if r['relative_errors']['fixed16'] is not None),
    'max_diagnostic64_abs_relative_error_nonzero':max(abs(r['relative_errors']['diagnostic64']) for r in rows if r['relative_errors']['diagnostic64'] is not None),
    'image_oracle_inputs':False,
}
(HERE/'convergence-report.json').write_text(json.dumps(summary,indent=2)+'\n')
print('case | fixed16 rel% | diagnostic64 rel% | 262144 rel% | independent')
for row in rows:
    e=row['relative_errors']
    def fmt(k): return f'{100*e[k]:+.7f}' if e[k] is not None else 'exact-zero'
    print(f"{row['case']['name']} | {fmt('fixed16')} | {fmt('diagnostic64')} | {fmt('diagnostic262144')} | {row['reference_gauss256_azimuth2048']:.12g}")
print('PASS: independent quadrature convergence and synthetic physical invariants.')
