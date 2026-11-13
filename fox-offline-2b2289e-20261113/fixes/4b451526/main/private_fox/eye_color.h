#ifndef FOX_EYE_COLOR_H
#define FOX_EYE_COLOR_H
#include <math.h>
/* Source Principled Base Color only, LINEAR RGB, unlit diagnostic. No BSDF,
 * light transport, roughness, reflection, view transform or alpha baked in.
 * Same material indices and object-local coordinates as eye_alpha.h.
 * finite controls in source UI domain are required (see contract.json).
 */
typedef struct {float blink_both,blink_neg,blink_pos,gaze_x,gaze_up,eye_style,show_highlights,environment_reflection,bubble_pressure,head_turn,head_tilt;} FoxEyeControls;
static inline FoxEyeControls fox_eye_default_controls(void) {
 FoxEyeControls c={0,0,0,0,0,0,1,0.5f,0,0,0};return c;
}
static inline float fec_clamp(float x){return fminf(1.0f,fmaxf(0.0f,x));}
static inline float fec_div(float a,float b){return b!=0.0f?a/b:0.0f;}
static inline void fec_material_0(float x,float y,float z,const FoxEyeControls *c,float out[3]) {

 out[0]=0.028000000864267349f; out[1]=0.008999999612569809f; out[2]=0.0030000000260770321f;
}
static inline void fec_material_1(float x,float y,float z,const FoxEyeControls *c,float out[3]) {

 out[0]=0.028000000864267349f; out[1]=0.008999999612569809f; out[2]=0.0030000000260770321f;
}
static inline void fec_material_2(float x,float y,float z,const FoxEyeControls *c,float out[3]) {
 float v0=(((-0.277144f)+(0.026298999999999999f*fmaxf(0.0f,c->gaze_x)))+((-0.024018000000000001f)*fmaxf(0.0f,(-c->gaze_x)))); /* Value Value channel 0 */
 float v1=(v0+0.0f); /* Math.020 Value channel 0 */
 float v2=(x-v1); /* Math.021 Value channel 0 */
 float v3=fec_div(v2,0.13899999856948853f); /* Math.022 Value channel 0 */
 float v4=(v3*v3); /* Math.026 Value channel 0 */
 float v5=((2.5402770000000001f+(0.015008000000000001f*fmaxf(0.0f,c->gaze_up)))-(0.015285f*fmaxf(0.0f,(-c->gaze_up)))); /* Value.001 Value channel 0 */
 float v6=(v5+0.0f); /* Math.023 Value channel 0 */
 float v7=(z-v6); /* Math.024 Value channel 0 */
 float v8=fec_div(v7,0.17200000584125519f); /* Math.025 Value channel 0 */
 float v9=(v8*v8); /* Math.027 Value channel 0 */
 float v10=(v4+v9); /* Math.028 Value channel 0 */
 float v11=(v10<=0.0f?0.0030000000260770321f:(v10<0.51999998092651367f?((1.0f-((v10-0.0f)/(0.51999998092651367f-0.0f)))*0.0030000000260770321f+((v10-0.0f)/(0.51999998092651367f-0.0f))*0.0040000001899898052f):(v10<0.56999999284744263f?((1.0f-((v10-0.51999998092651367f)/(0.56999999284744263f-0.51999998092651367f)))*0.0040000001899898052f+((v10-0.51999998092651367f)/(0.56999999284744263f-0.51999998092651367f))*0.20000000298023224f):(v10<0.81999999284744263f?((1.0f-((v10-0.56999999284744263f)/(0.81999999284744263f-0.56999999284744263f)))*0.20000000298023224f+((v10-0.56999999284744263f)/(0.81999999284744263f-0.56999999284744263f))*0.34000000357627869f):(v10<0.94999998807907104f?((1.0f-((v10-0.81999999284744263f)/(0.94999998807907104f-0.81999999284744263f)))*0.34000000357627869f+((v10-0.81999999284744263f)/(0.94999998807907104f-0.81999999284744263f))*0.045000001788139343f):(v10<0.99500000476837158f?((1.0f-((v10-0.94999998807907104f)/(0.99500000476837158f-0.94999998807907104f)))*0.045000001788139343f+((v10-0.94999998807907104f)/(0.99500000476837158f-0.94999998807907104f))*0.93999999761581421f):0.93999999761581421f)))))); /* Color Ramp Color channel 0 */
 float v12=c->eye_style; /* Value.002 Value channel 0 */
 float v13=(v12<1.5f?1.0f:0.0f); /* Math.029 Value channel 0 */
 float v14=((1.0f-fec_clamp(v13))*0.93999999761581421f+fec_clamp(v13)*v11); /* Mix (Legacy) Color channel 0 */
 float v15=(v12>0.5f?1.0f:0.0f); /* Math.030 Value channel 0 */
 float v16=(v12<1.5f?1.0f:0.0f); /* Math.031 Value channel 0 */
 float v17=(v15*v16); /* Math.032 Value channel 0 */
 float v18=(1.0f-v17); /* Math.033 Value channel 0 */
 float v19=(v0+0.035000000149011612f); /* Math.034 Value channel 0 */
 float v20=(x-v19); /* Math.035 Value channel 0 */
 float v21=fec_div(v20,0.02500000037252903f); /* Math.036 Value channel 0 */
 float v22=(v21*v21); /* Math.040 Value channel 0 */
 float v23=(v5+0.085000000894069672f); /* Math.037 Value channel 0 */
 float v24=(z-v23); /* Math.038 Value channel 0 */
 float v25=fec_div(v24,0.030999999493360519f); /* Math.039 Value channel 0 */
 float v26=(v25*v25); /* Math.041 Value channel 0 */
 float v27=(v22+v26); /* Math.042 Value channel 0 */
 float v28=(v27<1.0f?1.0f:0.0f); /* Math.043 Value channel 0 */
 float v29=(v18*v28); /* Math.056 Value channel 0 */
 float v30=(x-v0); /* Math.113 Value channel 0 */
 float v31=fec_div(v30,0.10019999742507935f); /* Math.114 Value channel 0 */
 float v32=fmaxf((-1.0f),fminf(1.0f,c->bubble_pressure)); /* Value.004 Value channel 0 */
 float v33=(0.10999999940395355f*v32); /* Math.117 Value channel 0 */
 float v34=(1.0f+v33); /* Math.118 Value channel 0 */
 float v35=((((((-0.0032688579999999999f)*powf(c->bubble_pressure,4.0f))+(0.00036920600000000002f*powf(c->bubble_pressure,3.0f)))+(0.011176145f*powf(c->bubble_pressure,2.0f)))-(0.046704309999999999f*c->bubble_pressure))+0.944728911f); /* Value.005 Value channel 0 */
 float v36=(v34*v35); /* Math.119 Value channel 0 */
 float v37=(0.89999997615814209f*v36); /* Math.120 Value channel 0 */
 float v38=(v37*v37); /* Math.125 Value channel 0 */
 float v39=(0.20000000298023224f*v32); /* Math.121 Value channel 0 */
 float v40=(1.0f-v39); /* Math.122 Value channel 0 */
 float v41=(v40*v35); /* Math.123 Value channel 0 */
 float v42=(0.55000001192092896f*v41); /* Math.124 Value channel 0 */
 float v43=(v42*v42); /* Math.126 Value channel 0 */
 float v44=(v38+v43); /* Math.127 Value channel 0 */
 float v45=(v37*v42); /* Math.128 Value channel 0 */
 float v46=(v44-v45); /* Math.129 Value channel 0 */
 float v47=sqrtf(fmaxf(0.0f,v46)); /* Math.130 Value channel 0 */
 float v48=(v47*0.36552762985229492f); /* Math.131 Value channel 0 */
 float v49=(0.10000000149011612f-v48); /* Math.133 Value channel 0 */
 float v50=(v31-v49); /* Math.137 Value channel 0 */
 float v51=(v50*v50); /* Math.138 Value channel 0 */
 float v52=(z-v5); /* Math.115 Value channel 0 */
 float v53=fec_div(v52,0.12399999797344208f); /* Math.116 Value channel 0 */
 float v54=(v47*-0.34115913510322571f); /* Math.132 Value channel 0 */
 float v55=(-0.11999999731779099f-v54); /* Math.134 Value channel 0 */
 float v56=(v53-v55); /* Math.139 Value channel 0 */
 float v57=(v56*v56); /* Math.140 Value channel 0 */
 float v58=(v51+v57); /* Math.141 Value channel 0 */
 float v59=(v37*v37); /* Math.142 Value channel 0 */
 float v60=(v58-v59); /* Math.143 Value channel 0 */
 float v61=(v60<0.0f?1.0f:0.0f); /* Math.154 Value channel 0 */
 float v62=(0.10000000149011612f+v48); /* Math.135 Value channel 0 */
 float v63=(v31-v62); /* Math.144 Value channel 0 */
 float v64=(v63*v63); /* Math.145 Value channel 0 */
 float v65=(-0.11999999731779099f+v54); /* Math.136 Value channel 0 */
 float v66=(v53-v65); /* Math.146 Value channel 0 */
 float v67=(v66*v66); /* Math.147 Value channel 0 */
 float v68=(v64+v67); /* Math.148 Value channel 0 */
 float v69=(v42*v42); /* Math.149 Value channel 0 */
 float v70=(v68-v69); /* Math.150 Value channel 0 */
 float v71=(v70<0.0f?1.0f:0.0f); /* Math.155 Value channel 0 */
 float v72=fmaxf(v61,v71); /* Math.156 Value channel 0 */
 float v73=fec_div(v37,v42); /* Math.151 Value channel 0 */
 float v74=(v73*v70); /* Math.152 Value channel 0 */
 float v75=(v60-v74); /* Math.153 Value channel 0 */
 float v76=(0.0f-0.035000000149011612f); /* Math.161 Value channel 0 */
 float v77=(v75<v76?1.0f:0.0f); /* Math.162 Value channel 0 */
 float v78=(v72*v77); /* Math.163 Value channel 0 */
 float v79=(v31*v31); /* Math.157 Value channel 0 */
 float v80=(v53*v53); /* Math.158 Value channel 0 */
 float v81=(v79+v80); /* Math.159 Value channel 0 */
 float v82=(v81<1.0f?1.0f:0.0f); /* Math.160 Value channel 0 */
 float v83=(v78*v82); /* Math.164 Value channel 0 */
 float v84=(v17*v83); /* Math.057 Value channel 0 */
 float v85=(v29+v84); /* Math.058 Value channel 0 */
 float v86=c->show_highlights; /* Value.003 Value channel 0 */
 float v87=(v85*v86); /* Math.059 Value channel 0 */
 float v88=((1.0f-fec_clamp(v87))*v14+fec_clamp(v87)*1.0f); /* Mix (Legacy).001 Color channel 0 */
 float v89=(v0+-0.035999998450279236f); /* Math.060 Value channel 0 */
 float v90=(x-v89); /* Math.061 Value channel 0 */
 float v91=fec_div(v90,0.0099999997764825821f); /* Math.062 Value channel 0 */
 float v92=(v91*v91); /* Math.066 Value channel 0 */
 float v93=(v5+-0.052000001072883606f); /* Math.063 Value channel 0 */
 float v94=(z-v93); /* Math.064 Value channel 0 */
 float v95=fec_div(v94,0.014000000432133675f); /* Math.065 Value channel 0 */
 float v96=(v95*v95); /* Math.067 Value channel 0 */
 float v97=(v92+v96); /* Math.068 Value channel 0 */
 float v98=(v97<1.0f?1.0f:0.0f); /* Math.069 Value channel 0 */
 float v99=(v18*v98); /* Math.080 Value channel 0 */
 float v100=(0.0f+0.035000000149011612f); /* Math.165 Value channel 0 */
 float v101=(v75>v100?1.0f:0.0f); /* Math.166 Value channel 0 */
 float v102=(v72*v101); /* Math.167 Value channel 0 */
 float v103=(v102*v82); /* Math.168 Value channel 0 */
 float v104=(v17*v103); /* Math.081 Value channel 0 */
 float v105=(v99+v104); /* Math.082 Value channel 0 */
 float v106=(v105*v86); /* Math.083 Value channel 0 */
 float v107=((1.0f-fec_clamp(v106))*v88+fec_clamp(v106)*1.0f); /* Mix (Legacy).002 Color channel 0 */
 float v108=(v10<=0.0f?0.0020000000949949026f:(v10<0.51999998092651367f?((1.0f-((v10-0.0f)/(0.51999998092651367f-0.0f)))*0.0020000000949949026f+((v10-0.0f)/(0.51999998092651367f-0.0f))*0.0020000000949949026f):(v10<0.56999999284744263f?((1.0f-((v10-0.51999998092651367f)/(0.56999999284744263f-0.51999998092651367f)))*0.0020000000949949026f+((v10-0.51999998092651367f)/(0.56999999284744263f-0.51999998092651367f))*0.054999999701976776f):(v10<0.81999999284744263f?((1.0f-((v10-0.56999999284744263f)/(0.81999999284744263f-0.56999999284744263f)))*0.054999999701976776f+((v10-0.56999999284744263f)/(0.81999999284744263f-0.56999999284744263f))*0.10999999940395355f):(v10<0.94999998807907104f?((1.0f-((v10-0.81999999284744263f)/(0.94999998807907104f-0.81999999284744263f)))*0.10999999940395355f+((v10-0.81999999284744263f)/(0.94999998807907104f-0.81999999284744263f))*0.010999999940395355f):(v10<0.99500000476837158f?((1.0f-((v10-0.94999998807907104f)/(0.99500000476837158f-0.94999998807907104f)))*0.010999999940395355f+((v10-0.94999998807907104f)/(0.99500000476837158f-0.94999998807907104f))*0.92000001668930054f):0.92000001668930054f)))))); /* Color Ramp Color channel 1 */
 float v109=((1.0f-fec_clamp(v13))*0.92000001668930054f+fec_clamp(v13)*v108); /* Mix (Legacy) Color channel 1 */
 float v110=((1.0f-fec_clamp(v87))*v109+fec_clamp(v87)*1.0f); /* Mix (Legacy).001 Color channel 1 */
 float v111=((1.0f-fec_clamp(v106))*v110+fec_clamp(v106)*1.0f); /* Mix (Legacy).002 Color channel 1 */
 float v112=(v10<=0.0f?0.0020000000949949026f:(v10<0.51999998092651367f?((1.0f-((v10-0.0f)/(0.51999998092651367f-0.0f)))*0.0020000000949949026f+((v10-0.0f)/(0.51999998092651367f-0.0f))*0.0010000000474974513f):(v10<0.56999999284744263f?((1.0f-((v10-0.51999998092651367f)/(0.56999999284744263f-0.51999998092651367f)))*0.0010000000474974513f+((v10-0.51999998092651367f)/(0.56999999284744263f-0.51999998092651367f))*0.008999999612569809f):(v10<0.81999999284744263f?((1.0f-((v10-0.56999999284744263f)/(0.81999999284744263f-0.56999999284744263f)))*0.008999999612569809f+((v10-0.56999999284744263f)/(0.81999999284744263f-0.56999999284744263f))*0.017999999225139618f):(v10<0.94999998807907104f?((1.0f-((v10-0.81999999284744263f)/(0.94999998807907104f-0.81999999284744263f)))*0.017999999225139618f+((v10-0.81999999284744263f)/(0.94999998807907104f-0.81999999284744263f))*0.0030000000260770321f):(v10<0.99500000476837158f?((1.0f-((v10-0.94999998807907104f)/(0.99500000476837158f-0.94999998807907104f)))*0.0030000000260770321f+((v10-0.94999998807907104f)/(0.99500000476837158f-0.94999998807907104f))*0.85000002384185791f):0.85000002384185791f)))))); /* Color Ramp Color channel 2 */
 float v113=((1.0f-fec_clamp(v13))*0.85000002384185791f+fec_clamp(v13)*v112); /* Mix (Legacy) Color channel 2 */
 float v114=((1.0f-fec_clamp(v87))*v113+fec_clamp(v87)*1.0f); /* Mix (Legacy).001 Color channel 2 */
 float v115=((1.0f-fec_clamp(v106))*v114+fec_clamp(v106)*1.0f); /* Mix (Legacy).002 Color channel 2 */
 out[0]=v107; out[1]=v111; out[2]=v115;
}
static inline void fec_material_3(float x,float y,float z,const FoxEyeControls *c,float out[3]) {
 float v0=((0.277144f+(0.024018000000000001f*fmaxf(0.0f,c->gaze_x)))+((-0.026298999999999999f)*fmaxf(0.0f,(-c->gaze_x)))); /* Value Value channel 0 */
 float v1=(v0+0.0f); /* Math.020 Value channel 0 */
 float v2=(x-v1); /* Math.021 Value channel 0 */
 float v3=fec_div(v2,0.13899999856948853f); /* Math.022 Value channel 0 */
 float v4=(v3*v3); /* Math.026 Value channel 0 */
 float v5=((2.5402770000000001f+(0.015008000000000001f*fmaxf(0.0f,c->gaze_up)))-(0.015285f*fmaxf(0.0f,(-c->gaze_up)))); /* Value.001 Value channel 0 */
 float v6=(v5+0.0f); /* Math.023 Value channel 0 */
 float v7=(z-v6); /* Math.024 Value channel 0 */
 float v8=fec_div(v7,0.17200000584125519f); /* Math.025 Value channel 0 */
 float v9=(v8*v8); /* Math.027 Value channel 0 */
 float v10=(v4+v9); /* Math.028 Value channel 0 */
 float v11=(v10<=0.0f?0.0030000000260770321f:(v10<0.51999998092651367f?((1.0f-((v10-0.0f)/(0.51999998092651367f-0.0f)))*0.0030000000260770321f+((v10-0.0f)/(0.51999998092651367f-0.0f))*0.0040000001899898052f):(v10<0.56999999284744263f?((1.0f-((v10-0.51999998092651367f)/(0.56999999284744263f-0.51999998092651367f)))*0.0040000001899898052f+((v10-0.51999998092651367f)/(0.56999999284744263f-0.51999998092651367f))*0.20000000298023224f):(v10<0.81999999284744263f?((1.0f-((v10-0.56999999284744263f)/(0.81999999284744263f-0.56999999284744263f)))*0.20000000298023224f+((v10-0.56999999284744263f)/(0.81999999284744263f-0.56999999284744263f))*0.34000000357627869f):(v10<0.94999998807907104f?((1.0f-((v10-0.81999999284744263f)/(0.94999998807907104f-0.81999999284744263f)))*0.34000000357627869f+((v10-0.81999999284744263f)/(0.94999998807907104f-0.81999999284744263f))*0.045000001788139343f):(v10<0.99500000476837158f?((1.0f-((v10-0.94999998807907104f)/(0.99500000476837158f-0.94999998807907104f)))*0.045000001788139343f+((v10-0.94999998807907104f)/(0.99500000476837158f-0.94999998807907104f))*0.93999999761581421f):0.93999999761581421f)))))); /* Color Ramp Color channel 0 */
 float v12=c->eye_style; /* Value.002 Value channel 0 */
 float v13=(v12<1.5f?1.0f:0.0f); /* Math.029 Value channel 0 */
 float v14=((1.0f-fec_clamp(v13))*0.93999999761581421f+fec_clamp(v13)*v11); /* Mix (Legacy) Color channel 0 */
 float v15=(v12>0.5f?1.0f:0.0f); /* Math.030 Value channel 0 */
 float v16=(v12<1.5f?1.0f:0.0f); /* Math.031 Value channel 0 */
 float v17=(v15*v16); /* Math.032 Value channel 0 */
 float v18=(1.0f-v17); /* Math.033 Value channel 0 */
 float v19=(v0+0.035000000149011612f); /* Math.034 Value channel 0 */
 float v20=(x-v19); /* Math.035 Value channel 0 */
 float v21=fec_div(v20,0.02500000037252903f); /* Math.036 Value channel 0 */
 float v22=(v21*v21); /* Math.040 Value channel 0 */
 float v23=(v5+0.085000000894069672f); /* Math.037 Value channel 0 */
 float v24=(z-v23); /* Math.038 Value channel 0 */
 float v25=fec_div(v24,0.030999999493360519f); /* Math.039 Value channel 0 */
 float v26=(v25*v25); /* Math.041 Value channel 0 */
 float v27=(v22+v26); /* Math.042 Value channel 0 */
 float v28=(v27<1.0f?1.0f:0.0f); /* Math.043 Value channel 0 */
 float v29=(v18*v28); /* Math.056 Value channel 0 */
 float v30=(x-v0); /* Math.113 Value channel 0 */
 float v31=fec_div(v30,0.10019999742507935f); /* Math.114 Value channel 0 */
 float v32=fmaxf((-1.0f),fminf(1.0f,c->bubble_pressure)); /* Value.004 Value channel 0 */
 float v33=(0.10999999940395355f*v32); /* Math.117 Value channel 0 */
 float v34=(1.0f+v33); /* Math.118 Value channel 0 */
 float v35=((((((-0.0032688579999999999f)*powf(c->bubble_pressure,4.0f))+(0.00036920600000000002f*powf(c->bubble_pressure,3.0f)))+(0.011176145f*powf(c->bubble_pressure,2.0f)))-(0.046704309999999999f*c->bubble_pressure))+0.944728911f); /* Value.005 Value channel 0 */
 float v36=(v34*v35); /* Math.119 Value channel 0 */
 float v37=(0.89999997615814209f*v36); /* Math.120 Value channel 0 */
 float v38=(v37*v37); /* Math.125 Value channel 0 */
 float v39=(0.20000000298023224f*v32); /* Math.121 Value channel 0 */
 float v40=(1.0f-v39); /* Math.122 Value channel 0 */
 float v41=(v40*v35); /* Math.123 Value channel 0 */
 float v42=(0.55000001192092896f*v41); /* Math.124 Value channel 0 */
 float v43=(v42*v42); /* Math.126 Value channel 0 */
 float v44=(v38+v43); /* Math.127 Value channel 0 */
 float v45=(v37*v42); /* Math.128 Value channel 0 */
 float v46=(v44-v45); /* Math.129 Value channel 0 */
 float v47=sqrtf(fmaxf(0.0f,v46)); /* Math.130 Value channel 0 */
 float v48=(v47*0.36552762985229492f); /* Math.131 Value channel 0 */
 float v49=(0.10000000149011612f-v48); /* Math.133 Value channel 0 */
 float v50=(v31-v49); /* Math.137 Value channel 0 */
 float v51=(v50*v50); /* Math.138 Value channel 0 */
 float v52=(z-v5); /* Math.115 Value channel 0 */
 float v53=fec_div(v52,0.12399999797344208f); /* Math.116 Value channel 0 */
 float v54=(v47*-0.34115913510322571f); /* Math.132 Value channel 0 */
 float v55=(-0.11999999731779099f-v54); /* Math.134 Value channel 0 */
 float v56=(v53-v55); /* Math.139 Value channel 0 */
 float v57=(v56*v56); /* Math.140 Value channel 0 */
 float v58=(v51+v57); /* Math.141 Value channel 0 */
 float v59=(v37*v37); /* Math.142 Value channel 0 */
 float v60=(v58-v59); /* Math.143 Value channel 0 */
 float v61=(v60<0.0f?1.0f:0.0f); /* Math.154 Value channel 0 */
 float v62=(0.10000000149011612f+v48); /* Math.135 Value channel 0 */
 float v63=(v31-v62); /* Math.144 Value channel 0 */
 float v64=(v63*v63); /* Math.145 Value channel 0 */
 float v65=(-0.11999999731779099f+v54); /* Math.136 Value channel 0 */
 float v66=(v53-v65); /* Math.146 Value channel 0 */
 float v67=(v66*v66); /* Math.147 Value channel 0 */
 float v68=(v64+v67); /* Math.148 Value channel 0 */
 float v69=(v42*v42); /* Math.149 Value channel 0 */
 float v70=(v68-v69); /* Math.150 Value channel 0 */
 float v71=(v70<0.0f?1.0f:0.0f); /* Math.155 Value channel 0 */
 float v72=fmaxf(v61,v71); /* Math.156 Value channel 0 */
 float v73=fec_div(v37,v42); /* Math.151 Value channel 0 */
 float v74=(v73*v70); /* Math.152 Value channel 0 */
 float v75=(v60-v74); /* Math.153 Value channel 0 */
 float v76=(0.0f-0.035000000149011612f); /* Math.161 Value channel 0 */
 float v77=(v75<v76?1.0f:0.0f); /* Math.162 Value channel 0 */
 float v78=(v72*v77); /* Math.163 Value channel 0 */
 float v79=(v31*v31); /* Math.157 Value channel 0 */
 float v80=(v53*v53); /* Math.158 Value channel 0 */
 float v81=(v79+v80); /* Math.159 Value channel 0 */
 float v82=(v81<1.0f?1.0f:0.0f); /* Math.160 Value channel 0 */
 float v83=(v78*v82); /* Math.164 Value channel 0 */
 float v84=(v17*v83); /* Math.057 Value channel 0 */
 float v85=(v29+v84); /* Math.058 Value channel 0 */
 float v86=c->show_highlights; /* Value.003 Value channel 0 */
 float v87=(v85*v86); /* Math.059 Value channel 0 */
 float v88=((1.0f-fec_clamp(v87))*v14+fec_clamp(v87)*1.0f); /* Mix (Legacy).001 Color channel 0 */
 float v89=(v0+-0.035999998450279236f); /* Math.060 Value channel 0 */
 float v90=(x-v89); /* Math.061 Value channel 0 */
 float v91=fec_div(v90,0.0099999997764825821f); /* Math.062 Value channel 0 */
 float v92=(v91*v91); /* Math.066 Value channel 0 */
 float v93=(v5+-0.052000001072883606f); /* Math.063 Value channel 0 */
 float v94=(z-v93); /* Math.064 Value channel 0 */
 float v95=fec_div(v94,0.014000000432133675f); /* Math.065 Value channel 0 */
 float v96=(v95*v95); /* Math.067 Value channel 0 */
 float v97=(v92+v96); /* Math.068 Value channel 0 */
 float v98=(v97<1.0f?1.0f:0.0f); /* Math.069 Value channel 0 */
 float v99=(v18*v98); /* Math.080 Value channel 0 */
 float v100=(0.0f+0.035000000149011612f); /* Math.165 Value channel 0 */
 float v101=(v75>v100?1.0f:0.0f); /* Math.166 Value channel 0 */
 float v102=(v72*v101); /* Math.167 Value channel 0 */
 float v103=(v102*v82); /* Math.168 Value channel 0 */
 float v104=(v17*v103); /* Math.081 Value channel 0 */
 float v105=(v99+v104); /* Math.082 Value channel 0 */
 float v106=(v105*v86); /* Math.083 Value channel 0 */
 float v107=((1.0f-fec_clamp(v106))*v88+fec_clamp(v106)*1.0f); /* Mix (Legacy).002 Color channel 0 */
 float v108=(v10<=0.0f?0.0020000000949949026f:(v10<0.51999998092651367f?((1.0f-((v10-0.0f)/(0.51999998092651367f-0.0f)))*0.0020000000949949026f+((v10-0.0f)/(0.51999998092651367f-0.0f))*0.0020000000949949026f):(v10<0.56999999284744263f?((1.0f-((v10-0.51999998092651367f)/(0.56999999284744263f-0.51999998092651367f)))*0.0020000000949949026f+((v10-0.51999998092651367f)/(0.56999999284744263f-0.51999998092651367f))*0.054999999701976776f):(v10<0.81999999284744263f?((1.0f-((v10-0.56999999284744263f)/(0.81999999284744263f-0.56999999284744263f)))*0.054999999701976776f+((v10-0.56999999284744263f)/(0.81999999284744263f-0.56999999284744263f))*0.10999999940395355f):(v10<0.94999998807907104f?((1.0f-((v10-0.81999999284744263f)/(0.94999998807907104f-0.81999999284744263f)))*0.10999999940395355f+((v10-0.81999999284744263f)/(0.94999998807907104f-0.81999999284744263f))*0.010999999940395355f):(v10<0.99500000476837158f?((1.0f-((v10-0.94999998807907104f)/(0.99500000476837158f-0.94999998807907104f)))*0.010999999940395355f+((v10-0.94999998807907104f)/(0.99500000476837158f-0.94999998807907104f))*0.92000001668930054f):0.92000001668930054f)))))); /* Color Ramp Color channel 1 */
 float v109=((1.0f-fec_clamp(v13))*0.92000001668930054f+fec_clamp(v13)*v108); /* Mix (Legacy) Color channel 1 */
 float v110=((1.0f-fec_clamp(v87))*v109+fec_clamp(v87)*1.0f); /* Mix (Legacy).001 Color channel 1 */
 float v111=((1.0f-fec_clamp(v106))*v110+fec_clamp(v106)*1.0f); /* Mix (Legacy).002 Color channel 1 */
 float v112=(v10<=0.0f?0.0020000000949949026f:(v10<0.51999998092651367f?((1.0f-((v10-0.0f)/(0.51999998092651367f-0.0f)))*0.0020000000949949026f+((v10-0.0f)/(0.51999998092651367f-0.0f))*0.0010000000474974513f):(v10<0.56999999284744263f?((1.0f-((v10-0.51999998092651367f)/(0.56999999284744263f-0.51999998092651367f)))*0.0010000000474974513f+((v10-0.51999998092651367f)/(0.56999999284744263f-0.51999998092651367f))*0.008999999612569809f):(v10<0.81999999284744263f?((1.0f-((v10-0.56999999284744263f)/(0.81999999284744263f-0.56999999284744263f)))*0.008999999612569809f+((v10-0.56999999284744263f)/(0.81999999284744263f-0.56999999284744263f))*0.017999999225139618f):(v10<0.94999998807907104f?((1.0f-((v10-0.81999999284744263f)/(0.94999998807907104f-0.81999999284744263f)))*0.017999999225139618f+((v10-0.81999999284744263f)/(0.94999998807907104f-0.81999999284744263f))*0.0030000000260770321f):(v10<0.99500000476837158f?((1.0f-((v10-0.94999998807907104f)/(0.99500000476837158f-0.94999998807907104f)))*0.0030000000260770321f+((v10-0.94999998807907104f)/(0.99500000476837158f-0.94999998807907104f))*0.85000002384185791f):0.85000002384185791f)))))); /* Color Ramp Color channel 2 */
 float v113=((1.0f-fec_clamp(v13))*0.85000002384185791f+fec_clamp(v13)*v112); /* Mix (Legacy) Color channel 2 */
 float v114=((1.0f-fec_clamp(v87))*v113+fec_clamp(v87)*1.0f); /* Mix (Legacy).001 Color channel 2 */
 float v115=((1.0f-fec_clamp(v106))*v114+fec_clamp(v106)*1.0f); /* Mix (Legacy).002 Color channel 2 */
 out[0]=v107; out[1]=v111; out[2]=v115;
}
static inline void fec_material_4(float x,float y,float z,const FoxEyeControls *c,float out[3]) {

 out[0]=0.028000000864267349f; out[1]=0.008999999612569809f; out[2]=0.0030000000260770321f;
}
static inline void fec_material_5(float x,float y,float z,const FoxEyeControls *c,float out[3]) {

 out[0]=0.028000000864267349f; out[1]=0.008999999612569809f; out[2]=0.0030000000260770321f;
}
static inline void fox_eye_base_color(int material,float x,float y,float z,const FoxEyeControls *c,float out[3]) {
 switch(material){
 case 0:fec_material_0(x,y,z,c,out);return;
 case 1:fec_material_1(x,y,z,c,out);return;
 case 2:fec_material_2(x,y,z,c,out);return;
 case 3:fec_material_3(x,y,z,c,out);return;
 case 4:fec_material_4(x,y,z,c,out);return;
 case 5:fec_material_5(x,y,z,c,out);return;
 default:out[0]=out[1]=out[2]=0.0f;return;
 }
}
#endif
