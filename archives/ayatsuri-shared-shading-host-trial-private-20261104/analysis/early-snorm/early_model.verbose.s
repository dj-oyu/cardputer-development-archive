	.file	"ayatsuri_model.c"
# GNU C11 (Debian 14.2.0-19) version 14.2.0 (x86_64-linux-gnu)
#	compiled by GNU C version 14.2.0, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.27-GMP

# warning: MPFR header version 4.2.1 differs from library version 4.2.2.
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mtune=generic -march=x86-64 -O2 -std=c11 -ffp-contract=off -fexcess-precision=standard -fno-fast-math -fasynchronous-unwind-tables
	.text
	.p2align 4
	.type	md, @function
md:
.LFB12:
	.cfi_startproc
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:18: static double md(const uint8_t *p){uint64_t bits=(uint64_t)m32(p)|(uint64_t)m32(p+4)<<32;double d;memcpy(&d,&bits,8);return d;}
	movsd	(%rdi), %xmm0	# MEM <long unsigned int> [(const uint8_t *)p_6(D)], <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:18: static double md(const uint8_t *p){uint64_t bits=(uint64_t)m32(p)|(uint64_t)m32(p+4)<<32;double d;memcpy(&d,&bits,8);return d;}
	ret	
	.cfi_endproc
.LFE12:
	.size	md, .-md
	.p2align 4
	.type	float_rows_valid, @function
float_rows_valid:
.LFB22:
	.cfi_startproc
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:44: static bool float_rows_valid(const uint8_t *data,uint32_t count,unsigned floats,unsigned positive_start){
	movq	%rdi, %r9	# tmp123, data
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:45:     for(uint32_t i=0;i<count;++i)for(unsigned k=0;k<floats;++k){
	testl	%esi, %esi	# count
	je	.L12	#,
	movss	.LC1(%rip), %xmm2	#, tmp120
	xorl	%r10d, %r10d	# ivtmp.145
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:45:     for(uint32_t i=0;i<count;++i)for(unsigned k=0;k<floats;++k){
	xorl	%r11d, %r11d	# i
	movss	.LC0(%rip), %xmm3	#, tmp119
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:47:         if(!isfinite(value)||(k>=positive_start&&!(value>0)))return false;
	pxor	%xmm4, %xmm4	# tmp121
.L4:
	leal	0(,%r10,4), %edi	#, ivtmp.139
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:45:     for(uint32_t i=0;i<count;++i)for(unsigned k=0;k<floats;++k){
	xorl	%eax, %eax	# k
	.p2align 4
	.p2align 3
.L8:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:46:         const float value=mf(data+(i*floats+k)*4);
	movl	%edi, %r8d	# ivtmp.139, _4
	movss	(%r9,%r8), %xmm0	# MEM <unsigned int> [(const uint8_t *)_5], _32
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:47:         if(!isfinite(value)||(k>=positive_start&&!(value>0)))return false;
	movaps	%xmm0, %xmm1	# _32, _6
	andps	%xmm3, %xmm1	# tmp119, _6
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:47:         if(!isfinite(value)||(k>=positive_start&&!(value>0)))return false;
	ucomiss	%xmm1, %xmm2	# _6, tmp120
	jb	.L14	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:47:         if(!isfinite(value)||(k>=positive_start&&!(value>0)))return false;
	cmpl	%ecx, %eax	# positive_start, k
	jb	.L6	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:47:         if(!isfinite(value)||(k>=positive_start&&!(value>0)))return false;
	comiss	%xmm4, %xmm0	# tmp121, _32
	jbe	.L14	#,
.L6:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:45:     for(uint32_t i=0;i<count;++i)for(unsigned k=0;k<floats;++k){
	addl	$1, %eax	#, k
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:45:     for(uint32_t i=0;i<count;++i)for(unsigned k=0;k<floats;++k){
	addl	$4, %edi	#, ivtmp.139
	cmpl	%eax, %edx	# k, floats
	jne	.L8	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:45:     for(uint32_t i=0;i<count;++i)for(unsigned k=0;k<floats;++k){
	addl	$1, %r11d	#, i
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:45:     for(uint32_t i=0;i<count;++i)for(unsigned k=0;k<floats;++k){
	addl	%edx, %r10d	# floats, ivtmp.145
	cmpl	%r11d, %esi	# i, count
	jne	.L4	#,
.L12:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:49:     return true;
	movl	$1, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:50: }
	ret	
	.p2align 4,,10
	.p2align 3
.L14:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:47:         if(!isfinite(value)||(k>=positive_start&&!(value>0)))return false;
	xorl	%eax, %eax	# <retval>
	ret	
	.cfi_endproc
.LFE22:
	.size	float_rows_valid, .-float_rows_valid
	.p2align 4
	.type	mesh_project, @function
mesh_project:
.LFB45:
	.cfi_startproc
	movss	(%rsi), %xmm0	# MEM <unsigned int> [(const uint8_t *)xyz_38(D)], _91
	movss	4(%rsi), %xmm3	# MEM <unsigned int> [(const uint8_t *)xyz_38(D) + 4B], _76
	xorl	%eax, %eax	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:437:     *x=projection[0]*a+projection[1]*b+projection[2]*c+projection[3];
	movss	(%rdi), %xmm1	# *projection_42(D), _2
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:437:     *x=projection[0]*a+projection[1]*b+projection[2]*c+projection[3];
	movss	4(%rdi), %xmm4	# MEM[(const float *)projection_42(D) + 4B], _4
	movss	8(%rsi), %xmm2	# MEM <unsigned int> [(const uint8_t *)xyz_38(D) + 8B], _61
	mulss	%xmm3, %xmm4	# _76, _4
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:437:     *x=projection[0]*a+projection[1]*b+projection[2]*c+projection[3];
	mulss	%xmm0, %xmm1	# _91, _2
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:437:     *x=projection[0]*a+projection[1]*b+projection[2]*c+projection[3];
	addss	%xmm4, %xmm1	# _4, _5
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:437:     *x=projection[0]*a+projection[1]*b+projection[2]*c+projection[3];
	movss	8(%rdi), %xmm4	# MEM[(const float *)projection_42(D) + 8B], _7
	mulss	%xmm2, %xmm4	# _61, _7
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:437:     *x=projection[0]*a+projection[1]*b+projection[2]*c+projection[3];
	addss	%xmm4, %xmm1	# _7, _8
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:437:     *x=projection[0]*a+projection[1]*b+projection[2]*c+projection[3];
	addss	12(%rdi), %xmm1	# MEM[(const float *)projection_42(D) + 12B], _10
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:437:     *x=projection[0]*a+projection[1]*b+projection[2]*c+projection[3];
	movss	%xmm1, (%rdx)	# _10, *x_43(D)
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:438:     *y=projection[4]*a+projection[5]*b+projection[6]*c+projection[7];
	movss	16(%rdi), %xmm1	# MEM[(const float *)projection_42(D) + 16B], _12
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:438:     *y=projection[4]*a+projection[5]*b+projection[6]*c+projection[7];
	movss	20(%rdi), %xmm4	# MEM[(const float *)projection_42(D) + 20B], _14
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:438:     *y=projection[4]*a+projection[5]*b+projection[6]*c+projection[7];
	mulss	%xmm0, %xmm1	# _91, _12
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:438:     *y=projection[4]*a+projection[5]*b+projection[6]*c+projection[7];
	mulss	%xmm3, %xmm4	# _76, _14
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:438:     *y=projection[4]*a+projection[5]*b+projection[6]*c+projection[7];
	addss	%xmm4, %xmm1	# _14, _15
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:438:     *y=projection[4]*a+projection[5]*b+projection[6]*c+projection[7];
	movss	24(%rdi), %xmm4	# MEM[(const float *)projection_42(D) + 24B], _17
	mulss	%xmm2, %xmm4	# _61, _17
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:438:     *y=projection[4]*a+projection[5]*b+projection[6]*c+projection[7];
	addss	%xmm4, %xmm1	# _17, _18
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:438:     *y=projection[4]*a+projection[5]*b+projection[6]*c+projection[7];
	addss	28(%rdi), %xmm1	# MEM[(const float *)projection_42(D) + 28B], _20
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:438:     *y=projection[4]*a+projection[5]*b+projection[6]*c+projection[7];
	movss	%xmm1, (%rcx)	# _20, *y_45(D)
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:439:     *depth=projection[8]*a+projection[9]*b+projection[10]*c+projection[11];
	mulss	36(%rdi), %xmm3	# MEM[(const float *)projection_42(D) + 36B], _24
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:439:     *depth=projection[8]*a+projection[9]*b+projection[10]*c+projection[11];
	mulss	32(%rdi), %xmm0	# MEM[(const float *)projection_42(D) + 32B], _22
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:439:     *depth=projection[8]*a+projection[9]*b+projection[10]*c+projection[11];
	mulss	40(%rdi), %xmm2	# MEM[(const float *)projection_42(D) + 40B], _27
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:439:     *depth=projection[8]*a+projection[9]*b+projection[10]*c+projection[11];
	addss	%xmm3, %xmm0	# _24, _25
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:440:     return isfinite(*x)&&isfinite(*y)&&fabsf(*x)<=4096&&fabsf(*y)<=4096&&isfinite(*depth);
	movss	.LC0(%rip), %xmm3	#, tmp167
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:439:     *depth=projection[8]*a+projection[9]*b+projection[10]*c+projection[11];
	addss	%xmm2, %xmm0	# _27, _28
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:439:     *depth=projection[8]*a+projection[9]*b+projection[10]*c+projection[11];
	addss	44(%rdi), %xmm0	# MEM[(const float *)projection_42(D) + 44B], _30
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:440:     return isfinite(*x)&&isfinite(*y)&&fabsf(*x)<=4096&&fabsf(*y)<=4096&&isfinite(*depth);
	movss	.LC1(%rip), %xmm2	#, tmp168
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:439:     *depth=projection[8]*a+projection[9]*b+projection[10]*c+projection[11];
	movss	%xmm0, (%r8)	# _30, *depth_47(D)
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:440:     return isfinite(*x)&&isfinite(*y)&&fabsf(*x)<=4096&&fabsf(*y)<=4096&&isfinite(*depth);
	movss	(%rdx), %xmm1	# *x_43(D), *x_43(D)
	andps	%xmm3, %xmm1	# tmp167, _32
	ucomiss	%xmm1, %xmm2	# _32, tmp168
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:440:     return isfinite(*x)&&isfinite(*y)&&fabsf(*x)<=4096&&fabsf(*y)<=4096&&isfinite(*depth);
	jb	.L15	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:440:     return isfinite(*x)&&isfinite(*y)&&fabsf(*x)<=4096&&fabsf(*y)<=4096&&isfinite(*depth);
	movss	(%rcx), %xmm4	# *y_45(D), *y_45(D)
	andps	%xmm3, %xmm4	# tmp167, _34
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:440:     return isfinite(*x)&&isfinite(*y)&&fabsf(*x)<=4096&&fabsf(*y)<=4096&&isfinite(*depth);
	ucomiss	%xmm4, %xmm2	# _34, tmp168
	jb	.L15	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:440:     return isfinite(*x)&&isfinite(*y)&&fabsf(*x)<=4096&&fabsf(*y)<=4096&&isfinite(*depth);
	movss	.LC3(%rip), %xmm5	#, tmp172
	comiss	%xmm1, %xmm5	# _32, tmp172
	jb	.L15	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:440:     return isfinite(*x)&&isfinite(*y)&&fabsf(*x)<=4096&&fabsf(*y)<=4096&&isfinite(*depth);
	comiss	%xmm4, %xmm5	# _34, tmp172
	jb	.L15	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:440:     return isfinite(*x)&&isfinite(*y)&&fabsf(*x)<=4096&&fabsf(*y)<=4096&&isfinite(*depth);
	andps	%xmm3, %xmm0	# tmp167, _35
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:440:     return isfinite(*x)&&isfinite(*y)&&fabsf(*x)<=4096&&fabsf(*y)<=4096&&isfinite(*depth);
	ucomiss	%xmm0, %xmm2	# _35, tmp168
	setnb	%al	#, <retval>
.L15:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:441: }
	ret	
	.cfi_endproc
.LFE45:
	.size	mesh_project, .-mesh_project
	.p2align 4
	.type	pack_rgb, @function
pack_rgb:
.LFB39:
	.cfi_startproc
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:315:     return (uint16_t)(floor((color>>16)*31.0/255+0.5)*2048+
	movl	%edi, %edx	# color, _1
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:315:     return (uint16_t)(floor((color>>16)*31.0/255+0.5)*2048+
	pxor	%xmm0, %xmm0	# _2
	movsd	.LC4(%rip), %xmm7	#, tmp189
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:314: static uint16_t pack_rgb(uint32_t color){
	movl	%edi, %eax	# tmp194, color
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:315:     return (uint16_t)(floor((color>>16)*31.0/255+0.5)*2048+
	shrl	$16, %edx	#, _1
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:315:     return (uint16_t)(floor((color>>16)*31.0/255+0.5)*2048+
	movsd	.LC5(%rip), %xmm6	#, tmp190
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:315:     return (uint16_t)(floor((color>>16)*31.0/255+0.5)*2048+
	movsd	.LC6(%rip), %xmm4	#, tmp191
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:315:     return (uint16_t)(floor((color>>16)*31.0/255+0.5)*2048+
	cvtsi2sdl	%edx, %xmm0	# _1, _2
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:315:     return (uint16_t)(floor((color>>16)*31.0/255+0.5)*2048+
	movq	.LC8(%rip), %xmm3	#, tmp193
	movsd	.LC7(%rip), %xmm5	#, tmp192
	movapd	%xmm3, %xmm2	# tmp193, tmp138
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:315:     return (uint16_t)(floor((color>>16)*31.0/255+0.5)*2048+
	mulsd	%xmm7, %xmm0	# tmp189, _3
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:315:     return (uint16_t)(floor((color>>16)*31.0/255+0.5)*2048+
	divsd	%xmm6, %xmm0	# tmp190, _4
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:315:     return (uint16_t)(floor((color>>16)*31.0/255+0.5)*2048+
	addsd	%xmm4, %xmm0	# tmp191, _5
	movapd	%xmm0, %xmm1	# _5, tmp136
	andpd	%xmm3, %xmm1	# tmp138, tmp136
	ucomisd	%xmm1, %xmm5	# tmp136, tmp192
	jbe	.L26	#,
	cvttsd2siq	%xmm0, %rdx	# _5, tmp139
	pxor	%xmm1, %xmm1	# tmp136
	andnpd	%xmm0, %xmm2	# _5, tmp143
	movsd	.LC9(%rip), %xmm9	#, tmp140
	cvtsi2sdq	%rdx, %xmm1	# tmp139, tmp136
	movapd	%xmm1, %xmm8	# tmp136, tmp141
	cmpnlesd	%xmm0, %xmm8	#, _5, tmp141
	andpd	%xmm9, %xmm8	# tmp140, tmp141
	subsd	%xmm8, %xmm1	# tmp141, tmp142
	movapd	%xmm1, %xmm0	# tmp142, tmp142
	orpd	%xmm2, %xmm0	# tmp143, tmp142
.L26:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:316:         floor(((color>>8)&255)*63.0/255+0.5)*32+floor((color&255)*31.0/255+0.5));
	movzbl	%ah, %edx	# color, _9
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:316:         floor(((color>>8)&255)*63.0/255+0.5)*32+floor((color&255)*31.0/255+0.5));
	pxor	%xmm1, %xmm1	# _10
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:316:         floor(((color>>8)&255)*63.0/255+0.5)*32+floor((color&255)*31.0/255+0.5));
	movapd	%xmm3, %xmm8	# tmp193, tmp157
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:316:         floor(((color>>8)&255)*63.0/255+0.5)*32+floor((color&255)*31.0/255+0.5));
	cvtsi2sdl	%edx, %xmm1	# _9, _10
	mulsd	.LC10(%rip), %xmm1	#, _11
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:316:         floor(((color>>8)&255)*63.0/255+0.5)*32+floor((color&255)*31.0/255+0.5));
	divsd	%xmm6, %xmm1	# tmp190, _12
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:316:         floor(((color>>8)&255)*63.0/255+0.5)*32+floor((color&255)*31.0/255+0.5));
	addsd	%xmm4, %xmm1	# tmp191, _13
	movapd	%xmm1, %xmm2	# _13, tmp155
	andpd	%xmm3, %xmm2	# tmp157, tmp155
	ucomisd	%xmm2, %xmm5	# tmp155, tmp192
	jbe	.L27	#,
	cvttsd2siq	%xmm1, %rdx	# _13, tmp158
	pxor	%xmm2, %xmm2	# tmp155
	andnpd	%xmm1, %xmm8	# _13, tmp162
	movsd	.LC9(%rip), %xmm10	#, tmp159
	cvtsi2sdq	%rdx, %xmm2	# tmp158, tmp155
	movapd	%xmm2, %xmm9	# tmp155, tmp160
	cmpnlesd	%xmm1, %xmm9	#, _13, tmp160
	andpd	%xmm10, %xmm9	# tmp159, tmp160
	subsd	%xmm9, %xmm2	# tmp160, tmp161
	movapd	%xmm2, %xmm1	# tmp161, tmp161
	orpd	%xmm8, %xmm1	# tmp162, tmp161
.L27:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:316:         floor(((color>>8)&255)*63.0/255+0.5)*32+floor((color&255)*31.0/255+0.5));
	movzbl	%al, %eax	# color, _17
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:316:         floor(((color>>8)&255)*63.0/255+0.5)*32+floor((color&255)*31.0/255+0.5));
	pxor	%xmm2, %xmm2	# _18
	cvtsi2sdl	%eax, %xmm2	# _17, _18
	mulsd	%xmm7, %xmm2	# tmp189, _19
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:316:         floor(((color>>8)&255)*63.0/255+0.5)*32+floor((color&255)*31.0/255+0.5));
	divsd	%xmm6, %xmm2	# tmp190, _20
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:316:         floor(((color>>8)&255)*63.0/255+0.5)*32+floor((color&255)*31.0/255+0.5));
	addsd	%xmm4, %xmm2	# tmp191, _21
	movapd	%xmm2, %xmm4	# _21, tmp173
	andpd	%xmm3, %xmm4	# tmp175, tmp173
	ucomisd	%xmm4, %xmm5	# tmp173, tmp192
	jbe	.L28	#,
	cvttsd2siq	%xmm2, %rax	# _21, tmp176
	pxor	%xmm4, %xmm4	# tmp173
	movsd	.LC9(%rip), %xmm6	#, tmp177
	andnpd	%xmm2, %xmm3	# _21, tmp180
	cvtsi2sdq	%rax, %xmm4	# tmp176, tmp173
	movapd	%xmm4, %xmm5	# tmp173, tmp178
	cmpnlesd	%xmm2, %xmm5	#, _21, tmp178
	andpd	%xmm6, %xmm5	# tmp177, tmp178
	subsd	%xmm5, %xmm4	# tmp178, tmp179
	orpd	%xmm3, %xmm4	# tmp180, tmp179
	movapd	%xmm4, %xmm2	# tmp179, _21
.L28:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:315:     return (uint16_t)(floor((color>>16)*31.0/255+0.5)*2048+
	mulsd	.LC11(%rip), %xmm0	#, _7
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:316:         floor(((color>>8)&255)*63.0/255+0.5)*32+floor((color&255)*31.0/255+0.5));
	mulsd	.LC12(%rip), %xmm1	#, _15
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:315:     return (uint16_t)(floor((color>>16)*31.0/255+0.5)*2048+
	addsd	%xmm1, %xmm0	# _15, _16
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:316:         floor(((color>>8)&255)*63.0/255+0.5)*32+floor((color&255)*31.0/255+0.5));
	addsd	%xmm2, %xmm0	# _21, _23
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:315:     return (uint16_t)(floor((color>>16)*31.0/255+0.5)*2048+
	cvttsd2sil	%xmm0, %eax	# _23, _25
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:317: }
	ret	
	.cfi_endproc
.LFE39:
	.size	pack_rgb, .-pack_rgb
	.p2align 4
	.type	slot_bytes, @function
slot_bytes:
.LFB17:
	.cfi_startproc
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	movzbl	2(%rdi), %edx	# MEM[(const uint8_t *)node_4(D) + 2B], _1
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	movl	$84, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	testb	%dl, %dl	# _1
	je	.L29	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	movl	$264, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	cmpb	$1, %dl	#, _1
	je	.L29	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	movzwl	6(%rdi), %eax	# MEM <short unsigned int> [(const uint8_t *)node_4(D) + 6B], _13
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	imull	$108, %eax, %eax	#, _13, _14
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	addl	$316, %eax	#, <retval>
.L29:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	ret	
	.cfi_endproc
.LFE17:
	.size	slot_bytes, .-slot_bytes
	.p2align 4
	.type	ayatsuri_shade_from_terms.isra.0, @function
ayatsuri_shade_from_terms.isra.0:
.LFB58:
	.cfi_startproc
	pushq	%r14	#
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:49:     const unsigned r=ayatsuri_shade_channel(((albedo>>11)&31)*(1.0f/31),light[6],m[5],front,spec,back,thin,m,31);
	movl	%edi, %eax	# albedo, _10
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:46: static __attribute__((noinline)) uint16_t ayatsuri_shade_from_terms(uint16_t albedo,const float light[9],
	movq	%rsi, %r14	# tmp244, light
	pushq	%r13	#
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:49:     const unsigned r=ayatsuri_shade_channel(((albedo>>11)&31)*(1.0f/31),light[6],m[5],front,spec,back,thin,m,31);
	shrw	$11, %ax	#, _10
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:46: static __attribute__((noinline)) uint16_t ayatsuri_shade_from_terms(uint16_t albedo,const float light[9],
	pushq	%r12	#
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:49:     const unsigned r=ayatsuri_shade_channel(((albedo>>11)&31)*(1.0f/31),light[6],m[5],front,spec,back,thin,m,31);
	movzwl	%ax, %eax	# _10, _11
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:46: static __attribute__((noinline)) uint16_t ayatsuri_shade_from_terms(uint16_t albedo,const float light[9],
	movl	%edi, %r12d	# tmp243, albedo
	pushq	%rbp	#
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	%rdx, %rbp	# tmp245, m
	pushq	%rbx	#
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$16, %rsp	#,
	.cfi_def_cfa_offset 64
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	4(%rdx), %xmm5	# MEM[(const float *)m_5(D) + 4B], tmp246
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:49:     const unsigned r=ayatsuri_shade_channel(((albedo>>11)&31)*(1.0f/31),light[6],m[5],front,spec,back,thin,m,31);
	movss	24(%rsi), %xmm4	# MEM[(const float *)light_7(D) + 24B], _8
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	16(%rdx), %xmm3	# MEM[(const float *)m_5(D) + 16B], _98
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	(%rdx), %xmm7	# *m_5(D), _89
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm0, %xmm5	# tmp246, tmp246
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	8(%rdx), %xmm6	# MEM[(const float *)m_5(D) + 8B], tmp248
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	%xmm7, (%rsp)	# _89, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm2, %xmm6	# tmp248, tmp248
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm1, %xmm3	# tmp247, _99
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:49:     const unsigned r=ayatsuri_shade_channel(((albedo>>11)&31)*(1.0f/31),light[6],m[5],front,spec,back,thin,m,31);
	pxor	%xmm1, %xmm1	# _12
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	%xmm5, 4(%rsp)	# _91, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm4, %xmm5	# _8, _92
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:49:     const unsigned r=ayatsuri_shade_channel(((albedo>>11)&31)*(1.0f/31),light[6],m[5],front,spec,back,thin,m,31);
	cvtsi2ssl	%eax, %xmm1	# _11, _12
	mulss	.LC14(%rip), %xmm1	#, _13
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	%xmm6, 8(%rsp)	# _96, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movaps	%xmm5, %xmm0	# _92, _92
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	addss	%xmm7, %xmm0	# _89, _93
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm0, %xmm1	# _93, _94
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	20(%rdx), %xmm0	# MEM[(const float *)m_5(D) + 20B], _100
	mulss	%xmm3, %xmm0	# _99, _100
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	addss	%xmm6, %xmm0	# _96, _101
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm4, %xmm0	# _8, _102
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	addss	%xmm0, %xmm1	# _102, v
	pxor	%xmm0, %xmm0	# _45
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:20:     if(v<0)v=0;
	comiss	%xmm1, %xmm0	# v, _45
	ja	.L36	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:22:     return (unsigned)lroundf(v*(float)max);
	movss	.LC15(%rip), %xmm2	#, tmp187
	movaps	%xmm2, %xmm0	# tmp187, tmp189
	cmpltss	%xmm1, %xmm0	#, v, tmp189
	andps	%xmm0, %xmm2	# tmp189, tmp190
	andnps	%xmm1, %xmm0	# v, tmp191
	orps	%xmm2, %xmm0	# tmp190, _105
	mulss	.LC16(%rip), %xmm0	#, _45
.L36:
	movss	%xmm3, 12(%rsp)	# _99, %sfp
	call	lroundf@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:50:     const unsigned g=ayatsuri_shade_channel(((albedo>>5)&63)*(1.0f/63),light[7],m[6],front,spec,back,thin,m,63);
	movss	28(%r14), %xmm2	# MEM[(const float *)light_7(D) + 28B], _16
	pxor	%xmm1, %xmm1	# _20
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	4(%rsp), %xmm0	# %sfp, _70
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:22:     return (unsigned)lroundf(v*(float)max);
	movq	%rax, %rbx	# tmp250, tmp193
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:50:     const unsigned g=ayatsuri_shade_channel(((albedo>>5)&63)*(1.0f/63),light[7],m[6],front,spec,back,thin,m,63);
	movl	%r12d, %eax	# albedo, _17
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	12(%rsp), %xmm3	# %sfp, _99
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm2, %xmm0	# _16, _70
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:50:     const unsigned g=ayatsuri_shade_channel(((albedo>>5)&63)*(1.0f/63),light[7],m[6],front,spec,back,thin,m,63);
	shrw	$5, %ax	#, _17
	andl	$63, %eax	#, _19
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	addss	(%rsp), %xmm0	# %sfp, _71
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:50:     const unsigned g=ayatsuri_shade_channel(((albedo>>5)&63)*(1.0f/63),light[7],m[6],front,spec,back,thin,m,63);
	cvtsi2ssl	%eax, %xmm1	# _19, _20
	mulss	.LC17(%rip), %xmm1	#, _21
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm0, %xmm1	# _71, _72
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	24(%rbp), %xmm0	# MEM[(const float *)m_5(D) + 24B], _78
	mulss	%xmm3, %xmm0	# _99, _78
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	addss	8(%rsp), %xmm0	# %sfp, _79
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm2, %xmm0	# _16, _80
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	addss	%xmm0, %xmm1	# _80, v
	pxor	%xmm0, %xmm0	# _47
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:20:     if(v<0)v=0;
	comiss	%xmm1, %xmm0	# v, _47
	ja	.L37	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:22:     return (unsigned)lroundf(v*(float)max);
	movss	.LC15(%rip), %xmm2	#, tmp209
	movaps	%xmm2, %xmm0	# tmp209, tmp211
	cmpltss	%xmm1, %xmm0	#, v, tmp211
	andps	%xmm0, %xmm2	# tmp211, tmp212
	andnps	%xmm1, %xmm0	# v, tmp213
	orps	%xmm2, %xmm0	# tmp212, _83
	mulss	.LC18(%rip), %xmm0	#, _47
.L37:
	movss	%xmm3, 12(%rsp)	# _99, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:51:     const unsigned b=ayatsuri_shade_channel((albedo&31)*(1.0f/31),light[8],m[7],front,spec,back,thin,m,31);
	andl	$31, %r12d	#, _26
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:22:     return (unsigned)lroundf(v*(float)max);
	call	lroundf@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:51:     const unsigned b=ayatsuri_shade_channel((albedo&31)*(1.0f/31),light[8],m[7],front,spec,back,thin,m,31);
	movss	32(%r14), %xmm2	# MEM[(const float *)light_7(D) + 32B], _24
	pxor	%xmm1, %xmm1	# _27
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	4(%rsp), %xmm0	# %sfp, _91
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:51:     const unsigned b=ayatsuri_shade_channel((albedo&31)*(1.0f/31),light[8],m[7],front,spec,back,thin,m,31);
	cvtsi2ssl	%r12d, %xmm1	# _26, _27
	mulss	.LC14(%rip), %xmm1	#, _28
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	12(%rsp), %xmm3	# %sfp, _99
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:22:     return (unsigned)lroundf(v*(float)max);
	movq	%rax, %r13	# tmp251, tmp215
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm2, %xmm0	# _24, _91
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	28(%rbp), %xmm3	# MEM[(const float *)m_5(D) + 28B], _56
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	addss	(%rsp), %xmm0	# %sfp, _49
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	addss	8(%rsp), %xmm3	# %sfp, _57
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm0, %xmm1	# _49, _50
	pxor	%xmm0, %xmm0	# _52
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm2, %xmm3	# _24, _58
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	addss	%xmm3, %xmm1	# _58, v
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:20:     if(v<0)v=0;
	comiss	%xmm1, %xmm0	# v, _52
	ja	.L38	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:22:     return (unsigned)lroundf(v*(float)max);
	movss	.LC15(%rip), %xmm2	#, tmp230
	movaps	%xmm2, %xmm0	# tmp230, tmp232
	cmpltss	%xmm1, %xmm0	#, v, tmp232
	andps	%xmm0, %xmm2	# tmp232, tmp233
	andnps	%xmm1, %xmm0	# v, tmp234
	orps	%xmm2, %xmm0	# tmp233, _61
	mulss	.LC16(%rip), %xmm0	#, _52
.L38:
	call	lroundf@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:52:     return (uint16_t)((r<<11)|(g<<5)|b);
	sall	$5, %r13d	#, _33
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:52:     return (uint16_t)((r<<11)|(g<<5)|b);
	sall	$11, %ebx	#, _31
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:53: }
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 48
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:52:     return (uint16_t)((r<<11)|(g<<5)|b);
	orl	%r13d, %ebx	# _33, _34
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:52:     return (uint16_t)((r<<11)|(g<<5)|b);
	orl	%ebx, %eax	# _34, _36
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:53: }
	popq	%rbx	#
	.cfi_def_cfa_offset 40
	popq	%rbp	#
	.cfi_def_cfa_offset 32
	popq	%r12	#
	.cfi_def_cfa_offset 24
	popq	%r13	#
	.cfi_def_cfa_offset 16
	popq	%r14	#
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE58:
	.size	ayatsuri_shade_from_terms.isra.0, .-ayatsuri_shade_from_terms.isra.0
	.p2align 4
	.type	ayatsuri_shade_terms_prepare.isra.0, @function
ayatsuri_shade_terms_prepare.isra.0:
.LFB59:
	.cfi_startproc
	pushq	%r14	#
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r12	#
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rdx, %r12	# tmp206, m
	pushq	%rbp	#
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movl	%ecx, %ebp	# tmp213, ISRA.169
	pushq	%rbx	#
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movl	%esi, %ebx	# tmp205, thickness
	subq	$56, %rsp	#,
	.cfi_def_cfa_offset 96
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	movswl	(%rdi), %edx	# *normal_1(D), *normal_1(D)
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	movswl	4(%rdi), %eax	# MEM[(const int16_t *)normal_1(D) + 4B], MEM[(const int16_t *)normal_1(D) + 4B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:36: static inline ayatsuri_shade_terms ayatsuri_shade_terms_prepare(const int16_t normal[3],uint8_t thickness,
	movss	%xmm1, 28(%rsp)	# ISRA.164, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	pxor	%xmm1, %xmm1	# _3
	cvtsi2ssl	%edx, %xmm1	# *normal_1(D), _3
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:36: static inline ayatsuri_shade_terms ayatsuri_shade_terms_prepare(const int16_t normal[3],uint8_t thickness,
	movss	%xmm0, 32(%rsp)	# ISRA.163, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	movswl	2(%rdi), %edx	# MEM[(const int16_t *)normal_1(D) + 2B], MEM[(const int16_t *)normal_1(D) + 2B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	movss	.LC19(%rip), %xmm0	#, tmp158
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:36: static inline ayatsuri_shade_terms ayatsuri_shade_terms_prepare(const int16_t normal[3],uint8_t thickness,
	movss	%xmm5, 44(%rsp)	# tmp212, %sfp
	movss	%xmm3, 36(%rsp)	# tmp210, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movss	.LC0(%rip), %xmm3	#, tmp166
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:36: static inline ayatsuri_shade_terms ayatsuri_shade_terms_prepare(const int16_t normal[3],uint8_t thickness,
	movss	%xmm2, 24(%rsp)	# ISRA.165, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	mulss	%xmm0, %xmm1	# tmp158, _3
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:36: static inline ayatsuri_shade_terms ayatsuri_shade_terms_prepare(const int16_t normal[3],uint8_t thickness,
	movss	%xmm4, 40(%rsp)	# tmp211, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	movss	%xmm1, 12(%rsp)	# _3, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	pxor	%xmm1, %xmm1	# _6
	cvtsi2ssl	%edx, %xmm1	# MEM[(const int16_t *)normal_1(D) + 2B], _6
	movaps	%xmm1, %xmm5	# _6, _6
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	pxor	%xmm1, %xmm1	# _9
	cvtsi2ssl	%eax, %xmm1	# MEM[(const int16_t *)normal_1(D) + 4B], _9
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	mulss	%xmm0, %xmm5	# tmp158, _6
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	movaps	%xmm1, %xmm6	# _9, _9
	mulss	%xmm0, %xmm6	# tmp158, _9
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movaps	%xmm5, %xmm7	# _6, _69
	movss	%xmm5, 16(%rsp)	# y, %sfp
	andps	%xmm3, %xmm7	# tmp166, _69
	movaps	%xmm7, %xmm1	# _69, _69
	movaps	%xmm6, %xmm0	# z, _67
	movss	%xmm6, 20(%rsp)	# z, %sfp
	andps	%xmm3, %xmm0	# tmp166, _67
	call	fmaxf@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movss	12(%rsp), %xmm1	# %sfp, tmp226
	movss	.LC0(%rip), %xmm3	#, tmp166
	andps	%xmm3, %xmm1	# tmp166, tmp226
	call	fmaxf@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:11:     if(!(scale>0)||!isfinite(scale))return false;
	pxor	%xmm1, %xmm1	# tmp171
	movss	24(%rsp), %xmm2	# %sfp, ISRA.165
	movss	28(%rsp), %xmm7	# %sfp, ISRA.164
	comiss	%xmm1, %xmm0	# tmp171, scale
	movss	32(%rsp), %xmm6	# %sfp, ISRA.163
	jbe	.L44	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:11:     if(!(scale>0)||!isfinite(scale))return false;
	movss	.LC1(%rip), %xmm1	#, tmp172
	ucomiss	%xmm0, %xmm1	# scale, tmp172
	jnb	.L57	#,
.L44:
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	mulss	16(%rsp), %xmm7	# %sfp, _16
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	pxor	%xmm1, %xmm1	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	mulss	12(%rsp), %xmm6	# %sfp, _13
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	mulss	20(%rsp), %xmm2	# %sfp, _20
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	addss	%xmm7, %xmm6	# _16, _17
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	addss	%xmm6, %xmm2	# _17, dot
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	movaps	%xmm2, %xmm0	# dot,
	movss	%xmm2, 24(%rsp)	# dot, %sfp
	call	fmaxf@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	movss	24(%rsp), %xmm2	# %sfp, dot
	pxor	%xmm1, %xmm1	#
	xorps	.LC20(%rip), %xmm2	#, dot
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	movd	%xmm0, %r14d	# tmp216, front
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	movaps	%xmm2, %xmm0	# dot, _23
	call	fmaxf@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:42:     const float spec=front>0&&nh>0?powf(nh,m[3]):0,thin=1-thickness*(1.0f/255);
	pxor	%xmm4, %xmm4	# iftmp.52_38
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	movaps	%xmm0, %xmm3	# tmp217, back
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	testb	%bpl, %bpl	# ISRA.169
	je	.L46	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:42:     const float spec=front>0&&nh>0?powf(nh,m[3]):0,thin=1-thickness*(1.0f/255);
	movd	%r14d, %xmm6	# front, front
	comiss	%xmm4, %xmm6	# iftmp.52_38, front
	jbe	.L46	#,
	movss	%xmm0, 24(%rsp)	# back, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	movss	40(%rsp), %xmm1	# %sfp, ISRA.167
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	movss	36(%rsp), %xmm0	# %sfp, ISRA.166
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	mulss	16(%rsp), %xmm1	# %sfp, ISRA.167
	movss	%xmm4, 28(%rsp)	# iftmp.52_38, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	mulss	12(%rsp), %xmm0	# %sfp, ISRA.166
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	addss	%xmm1, %xmm0	# _29, _30
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	movss	44(%rsp), %xmm1	# %sfp, ISRA.168
	mulss	20(%rsp), %xmm1	# %sfp, ISRA.168
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	addss	%xmm1, %xmm0	# _32, _33
	movaps	%xmm4, %xmm1	#,
	call	fmaxf@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:42:     const float spec=front>0&&nh>0?powf(nh,m[3]):0,thin=1-thickness*(1.0f/255);
	pxor	%xmm4, %xmm4	# iftmp.52_38
	movss	24(%rsp), %xmm3	# %sfp, back
	comiss	%xmm4, %xmm0	# iftmp.52_38, iftmp.48_34
	jbe	.L46	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:42:     const float spec=front>0&&nh>0?powf(nh,m[3]):0,thin=1-thickness*(1.0f/255);
	movss	12(%r12), %xmm1	# MEM[(const float *)m_36(D) + 12B],
	movss	%xmm3, 12(%rsp)	# back, %sfp
	call	powf@PLT	#
	movss	12(%rsp), %xmm3	# %sfp, back
	movaps	%xmm0, %xmm4	# tmp219, iftmp.52_38
.L46:
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:42:     const float spec=front>0&&nh>0?powf(nh,m[3]):0,thin=1-thickness*(1.0f/255);
	pxor	%xmm0, %xmm0	# _41
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:43:     return (ayatsuri_shade_terms){front,back,spec,thin};
	movd	%r14d, %xmm7	# front, tmp247
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:44: }
	movaps	%xmm4, %xmm1	# iftmp.52_38, tmp248
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:42:     const float spec=front>0&&nh>0?powf(nh,m[3]):0,thin=1-thickness*(1.0f/255);
	movzbl	%bl, %ebx	# thickness, _40
	cvtsi2ssl	%ebx, %xmm0	# _40, _41
	mulss	.LC21(%rip), %xmm0	#, _42
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:42:     const float spec=front>0&&nh>0?powf(nh,m[3]):0,thin=1-thickness*(1.0f/255);
	movss	.LC15(%rip), %xmm2	#, tmp198
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:43:     return (ayatsuri_shade_terms){front,back,spec,thin};
	unpcklps	%xmm3, %xmm7	# back, tmp247
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:44: }
	addq	$56, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx	#
	.cfi_def_cfa_offset 32
	popq	%rbp	#
	.cfi_def_cfa_offset 24
	popq	%r12	#
	.cfi_def_cfa_offset 16
	popq	%r14	#
	.cfi_def_cfa_offset 8
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:42:     const float spec=front>0&&nh>0?powf(nh,m[3]):0,thin=1-thickness*(1.0f/255);
	subss	%xmm0, %xmm2	# _42, thin_43
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:43:     return (ayatsuri_shade_terms){front,back,spec,thin};
	movaps	%xmm7, %xmm0	# tmp247, D.6779
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:44: }
	unpcklps	%xmm2, %xmm1	# thin_43, tmp248
	ret	
	.p2align 4,,10
	.p2align 3
.L57:
	.cfi_restore_state
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	movss	12(%rsp), %xmm4	# %sfp, x
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	movss	16(%rsp), %xmm3	# %sfp, y
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	movss	20(%rsp), %xmm1	# %sfp, z
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	divss	%xmm0, %xmm3	# scale, y
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	divss	%xmm0, %xmm4	# scale, x
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	movaps	%xmm3, %xmm5	# _76, _82
	mulss	%xmm3, %xmm5	# _76, _82
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	divss	%xmm0, %xmm1	# scale, z
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	movaps	%xmm4, %xmm0	# _74, _80
	mulss	%xmm4, %xmm0	# _74, _80
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	addss	%xmm5, %xmm0	# _82, _83
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	movaps	%xmm1, %xmm5	# _78, _84
	mulss	%xmm1, %xmm5	# _78, _84
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	addss	%xmm5, %xmm0	# _84, _85
	sqrtss	%xmm0, %xmm0	# _85, length
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	divss	%xmm0, %xmm4	# length, _74
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	divss	%xmm0, %xmm3	# length, _76
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	movss	%xmm4, 12(%rsp)	# _74, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	divss	%xmm0, %xmm1	# length, _78
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	movss	%xmm3, 16(%rsp)	# _76, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	movss	%xmm1, 20(%rsp)	# _78, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:15:     return true;
	jmp	.L44	#
	.cfi_endproc
.LFE59:
	.size	ayatsuri_shade_terms_prepare.isra.0, .-ayatsuri_shade_terms_prepare.isra.0
	.p2align 4
	.type	node_slot_bytes, @function
node_slot_bytes:
.LFB21:
	.cfi_startproc
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:39:     if(node[2]==3){const uint8_t *d=row(m,9,m16(node+4),32);
	movzbl	2(%rdx), %eax	# MEM[(const uint8_t *)node_7(D) + 2B], _1
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:38: static unsigned node_slot_bytes(const ayatsuri_model *m,unsigned id,const uint8_t *node){
	movl	%esi, %ecx	# tmp178, id
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:39:     if(node[2]==3){const uint8_t *d=row(m,9,m16(node+4),32);
	cmpb	$3, %al	#, _1
	je	.L73	#,
	movl	$84, %esi	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	testb	%al, %al	# _1
	je	.L58	#,
	movl	$264, %esi	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	cmpb	$1, %al	#, _1
	je	.L58	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	movzwl	6(%rdx), %r8d	# MEM <short unsigned int> [(const uint8_t *)node_7(D) + 6B], _78
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	imull	$108, %r8d, %r8d	#, _78, _79
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	leal	316(%r8), %esi	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:42:     return slot_bytes(node)+(node[2]==2&&node_region(m,id)?24u:0u);
	cmpb	$2, %al	#, _1
	je	.L74	#,
.L58:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:43: }
	movl	%esi, %eax	# <retval>,
	ret	
	.p2align 4,,10
	.p2align 3
.L73:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:39:     if(node[2]==3){const uint8_t *d=row(m,9,m16(node+4),32);
	movzwl	4(%rdx), %eax	# MEM <short unsigned int> [(const uint8_t *)node_7(D) + 4B], _22
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	(%rdi), %rcx	# m_9(D)->data, _23
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	84(%rdi), %esi	# m_9(D)->section[8].offset, _25
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	movl	120(%rdi), %r8d	# m_9(D)->section[12].count,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	sall	$5, %eax	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:40:         const unsigned nv=m16(d+2);
	addq	%rcx, %rax	# _23, tmp147
	movzwl	2(%rsi,%rax), %eax	# MEM <short unsigned int> [(const uint8_t *)_29 + 2B], nv
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:36: static unsigned mesh_legacy_bytes(unsigned nv){return (84u+sizeof(ksn_proc_gouraud_patch)+12u*nv+7u)&~7u;}
	leal	(%rax,%rax,2), %esi	#, _38
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:36: static unsigned mesh_legacy_bytes(unsigned nv){return (84u+sizeof(ksn_proc_gouraud_patch)+12u*nv+7u)&~7u;}
	leal	1131(,%rsi,4), %esi	#, _39
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:36: static unsigned mesh_legacy_bytes(unsigned nv){return (84u+sizeof(ksn_proc_gouraud_patch)+12u*nv+7u)&~7u;}
	andl	$-8, %esi	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	testl	%r8d, %r8d	#
	je	.L58	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	movzwl	8(%rdx), %edx	# MEM <short unsigned int> [(const uint8_t *)node_7(D) + 8B], _57
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	116(%rdi), %edi	# m_9(D)->section[12].offset, _60
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	sall	$2, %edx	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	addq	%rdx, %rcx	# _62, tmp158
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	cmpb	$1, (%rcx,%rdi)	#, *_64
	jne	.L58	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:41:         return mesh_legacy_bytes(nv)+(mesh_double(m,node)?((4u*nv+8u+7u)&~7u):0u);}
	leal	15(,%rax,4), %eax	#, _43
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:41:         return mesh_legacy_bytes(nv)+(mesh_double(m,node)?((4u*nv+8u+7u)&~7u):0u);}
	andl	$-8, %eax	#, iftmp.9_44
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:41:         return mesh_legacy_bytes(nv)+(mesh_double(m,node)?((4u*nv+8u+7u)&~7u):0u);}
	addl	%eax, %esi	# iftmp.9_44, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:43: }
	movl	%esi, %eax	# <retval>,
	ret	
	.p2align 4,,10
	.p2align 3
.L74:
	movq	(%rdi), %r9	# MEM[(const uint8_t * *)m_9(D)], _12
	movl	76(%rdi), %eax	# MEM[(unsigned int *)m_9(D) + 76B],
	movl	80(%rdi), %edi	# MEM[(unsigned int *)m_9(D) + 80B], _14
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:30:     for(uint32_t k=0;k<m->section[7].count;++k){const uint8_t *r=row(m,8,k,32);if(m16(r)==id)return r;}
	testl	%edi, %edi	# _14
	je	.L58	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:30:     for(uint32_t k=0;k<m->section[7].count;++k){const uint8_t *r=row(m,8,k,32);if(m16(r)==id)return r;}
	xorl	%edx, %edx	# k
	addq	%rax, %r9	# _47, tmp170
	jmp	.L64	#
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L75:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:30:     for(uint32_t k=0;k<m->section[7].count;++k){const uint8_t *r=row(m,8,k,32);if(m16(r)==id)return r;}
	addl	$1, %edx	#, k
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:30:     for(uint32_t k=0;k<m->section[7].count;++k){const uint8_t *r=row(m,8,k,32);if(m16(r)==id)return r;}
	cmpl	%edx, %edi	# k, _14
	je	.L58	#,
.L64:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	%edx, %eax	# k, _51
	sall	$5, %eax	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:30:     for(uint32_t k=0;k<m->section[7].count;++k){const uint8_t *r=row(m,8,k,32);if(m16(r)==id)return r;}
	movzwl	(%r9,%rax), %eax	# MEM <short unsigned int> [(const uint8_t *)_89], _97
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:30:     for(uint32_t k=0;k<m->section[7].count;++k){const uint8_t *r=row(m,8,k,32);if(m16(r)==id)return r;}
	cmpl	%eax, %ecx	# _97, id
	jne	.L75	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:42:     return slot_bytes(node)+(node[2]==2&&node_region(m,id)?24u:0u);
	leal	340(%r8), %esi	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:43: }
	movl	%esi, %eax	# <retval>,
	ret	
	.cfi_endproc
.LFE21:
	.size	node_slot_bytes, .-node_slot_bytes
	.p2align 4
	.type	mesh_packet, @function
mesh_packet:
.LFB48:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movl	%esi, %eax	# tmp1155,
	movq	%rdi, %r11	# tmp1154, i
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	%eax, %esi	# id, _422
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:470: static __attribute__((noinline)) bool mesh_packet(ayatsuri_model_instance *i,unsigned id,const float right[3],const float down[3],const float forward[3],bool light_only){
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	sall	$4, %esi	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:470: static __attribute__((noinline)) bool mesh_packet(ayatsuri_model_instance *i,unsigned id,const float right[3],const float down[3],const float forward[3],bool light_only){
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$1432, %rsp	#,
	.cfi_def_cfa_offset 1488
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:471:     const ayatsuri_model *model=i->model;const uint8_t *node=row(model,1,id,16),*d=row(model,9,m16(node+4),32),
	movq	(%rdi), %rbx	# i_265(D)->model, model
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:470: static __attribute__((noinline)) bool mesh_packet(ayatsuri_model_instance *i,unsigned id,const float right[3],const float down[3],const float forward[3],bool light_only){
	movl	%r9d, 244(%rsp)	# light_only, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	20(%rbx), %edi	# model_266->section[0].offset, _421
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	(%rbx), %r12	# model_266->data, _419
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:470: static __attribute__((noinline)) bool mesh_packet(ayatsuri_model_instance *i,unsigned id,const float right[3],const float down[3],const float forward[3],bool light_only){
	movb	%r9b, 119(%rsp)	# tmp1393, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:471:     const ayatsuri_model *model=i->model;const uint8_t *node=row(model,1,id,16),*d=row(model,9,m16(node+4),32),
	movq	%rbx, 24(%rsp)	# model, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rsi, %rdi	# _423, _424
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	movl	$0, 40(%rsp)	#, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%r12, %rdi	# _419, _425
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	cmpb	$3, 2(%rdi)	#, MEM[(const uint8_t *)_425 + 2B]
	movzwl	8(%rdi), %esi	# MEM <short unsigned int> [(const uint8_t *)_425 + 8B],
	je	.L218	#,
.L77:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movq	8(%r11), %r14	# i_265(D)->arena, _322
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	leaq	(%rax,%rax,2), %rax	#, _318
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:476:     const double a=m[0],b=m[1],c=m[2],e=m[4],f=m[5],g=m[6],h=m[8],j=m[9],k=m[10],
	pxor	%xmm5, %xmm5	# f
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:476:     const double a=m[0],b=m[1],c=m[2],e=m[4],f=m[5],g=m[6],h=m[8],j=m[9],k=m[10],
	pxor	%xmm7, %xmm7	# k
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	leaq	0(,%rax,8), %rbx	#, tmp702
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:476:     const double a=m[0],b=m[1],c=m[2],e=m[4],f=m[5],g=m[6],h=m[8],j=m[9],k=m[10],
	pxor	%xmm9, %xmm9	# g
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:476:     const double a=m[0],b=m[1],c=m[2],e=m[4],f=m[5],g=m[6],h=m[8],j=m[9],k=m[10],
	pxor	%xmm10, %xmm10	# j
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movl	8(%r14,%rax,8), %eax	# _314->offset, _332
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:476:     const double a=m[0],b=m[1],c=m[2],e=m[4],f=m[5],g=m[6],h=m[8],j=m[9],k=m[10],
	pxor	%xmm8, %xmm8	# e
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:476:     const double a=m[0],b=m[1],c=m[2],e=m[4],f=m[5],g=m[6],h=m[8],j=m[9],k=m[10],
	pxor	%xmm6, %xmm6	# h
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:476:     const double a=m[0],b=m[1],c=m[2],e=m[4],f=m[5],g=m[6],h=m[8],j=m[9],k=m[10],
	pxor	%xmm14, %xmm14	# a
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:476:     const double a=m[0],b=m[1],c=m[2],e=m[4],f=m[5],g=m[6],h=m[8],j=m[9],k=m[10],
	pxor	%xmm2, %xmm2	# b
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:476:     const double a=m[0],b=m[1],c=m[2],e=m[4],f=m[5],g=m[6],h=m[8],j=m[9],k=m[10],
	pxor	%xmm15, %xmm15	# c
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movq	%rbx, 232(%rsp)	# tmp702, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	addq	%rax, %r14	# _332, _331
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:476:     const double a=m[0],b=m[1],c=m[2],e=m[4],f=m[5],g=m[6],h=m[8],j=m[9],k=m[10],
	cvtss2sd	20(%r14), %xmm5	# MEM[(float *)_331 + 20B], f
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	movapd	%xmm5, %xmm1	# f, _15
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:476:     const double a=m[0],b=m[1],c=m[2],e=m[4],f=m[5],g=m[6],h=m[8],j=m[9],k=m[10],
	cvtss2sd	24(%r14), %xmm9	# MEM[(float *)_331 + 24B], g
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:476:     const double a=m[0],b=m[1],c=m[2],e=m[4],f=m[5],g=m[6],h=m[8],j=m[9],k=m[10],
	cvtss2sd	40(%r14), %xmm7	# MEM[(float *)_331 + 40B], k
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	movapd	%xmm9, %xmm0	# g, _16
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	movapd	%xmm9, %xmm11	# g, _20
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:476:     const double a=m[0],b=m[1],c=m[2],e=m[4],f=m[5],g=m[6],h=m[8],j=m[9],k=m[10],
	cvtss2sd	(%r14), %xmm14	# *_331, a
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:476:     const double a=m[0],b=m[1],c=m[2],e=m[4],f=m[5],g=m[6],h=m[8],j=m[9],k=m[10],
	cvtss2sd	36(%r14), %xmm10	# MEM[(float *)_331 + 36B], j
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	mulsd	%xmm7, %xmm1	# k, _15
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:476:     const double a=m[0],b=m[1],c=m[2],e=m[4],f=m[5],g=m[6],h=m[8],j=m[9],k=m[10],
	cvtss2sd	16(%r14), %xmm8	# MEM[(float *)_331 + 16B], e
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	movapd	%xmm8, %xmm12	# e, _19
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:476:     const double a=m[0],b=m[1],c=m[2],e=m[4],f=m[5],g=m[6],h=m[8],j=m[9],k=m[10],
	cvtss2sd	32(%r14), %xmm6	# MEM[(float *)_331 + 32B], h
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	mulsd	%xmm10, %xmm0	# j, _16
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:476:     const double a=m[0],b=m[1],c=m[2],e=m[4],f=m[5],g=m[6],h=m[8],j=m[9],k=m[10],
	cvtss2sd	4(%r14), %xmm2	# MEM[(float *)_331 + 4B], b
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:476:     const double a=m[0],b=m[1],c=m[2],e=m[4],f=m[5],g=m[6],h=m[8],j=m[9],k=m[10],
	cvtss2sd	8(%r14), %xmm15	# MEM[(float *)_331 + 8B], c
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	mulsd	%xmm7, %xmm12	# k, _19
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	mulsd	%xmm6, %xmm11	# h, _20
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	movapd	%xmm1, %xmm3	# _15, _15
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	movapd	%xmm8, %xmm1	# e, _24
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	subsd	%xmm0, %xmm3	# _16, _15
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	mulsd	%xmm10, %xmm1	# j, _24
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	movapd	%xmm5, %xmm0	# f, _25
	mulsd	%xmm6, %xmm0	# h, _25
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	movsd	%xmm12, 32(%rsp)	# _19, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	movsd	%xmm11, 48(%rsp)	# _20, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	movapd	%xmm3, %xmm4	# _17, _18
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	movsd	%xmm3, (%rsp)	# _17, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:478:     if(!isfinite(det)||det==0)return false;
	movsd	.LC22(%rip), %xmm3	#, tmp1415
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	mulsd	%xmm14, %xmm4	# a, _18
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	subsd	%xmm0, %xmm1	# _25, _24
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	movapd	%xmm12, %xmm0	# _19, _21
	subsd	%xmm11, %xmm0	# _20, _21
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	movsd	%xmm1, 56(%rsp)	# _26, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	mulsd	%xmm15, %xmm1	# c, _27
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	mulsd	%xmm2, %xmm0	# b, _22
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	subsd	%xmm0, %xmm4	# _22, _23
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:477:         det=a*(f*k-g*j)-b*(e*k-g*h)+c*(e*j-f*h);
	addsd	%xmm1, %xmm4	# _27, det
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:478:     if(!isfinite(det)||det==0)return false;
	movapd	%xmm4, %xmm0	# det, _28
	andpd	.LC8(%rip), %xmm0	#, _28
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:478:     if(!isfinite(det)||det==0)return false;
	ucomisd	%xmm0, %xmm3	# _28, tmp1415
	jb	.L80	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:478:     if(!isfinite(det)||det==0)return false;
	pxor	%xmm0, %xmm0	# tmp716
	ucomisd	%xmm0, %xmm4	# tmp716, det
	jp	.L148	#,
	je	.L80	#,
.L148:
	movss	.LC0(%rip), %xmm11	#, tmp1133
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:471:     const ayatsuri_model *model=i->model;const uint8_t *node=row(model,1,id,16),*d=row(model,9,m16(node+4),32),
	movzwl	4(%rdi), %ebx	# MEM <short unsigned int> [(const uint8_t *)_425 + 4B], _1
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	24(%rsp), %rdi	# %sfp, model
	movl	84(%rdi), %eax	# model_266->section[8].offset, _407
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	sall	$5, %ebx	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	52(%rdi), %r13d	# model_266->section[4].offset,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rax, %rbx	# _407, _410
	addq	%r12, %rbx	# _419, _411
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:485:     if(!light_only){
	cmpb	$0, 244(%rsp)	#, %sfp
	movzwl	2(%rbx), %eax	# MEM <short unsigned int> [(const uint8_t *)_411 + 2B], load_dst_871
	movw	%ax, 304(%rsp)	# load_dst_871, %sfp
	movzwl	6(%rbx), %eax	# MEM <short unsigned int> [(const uint8_t *)_411 + 6B], load_dst_992
	movw	%ax, 306(%rsp)	# load_dst_992, %sfp
	jne	.L83	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:490:             projection[4*r+3]=zoom*(basis[r][0]*(m[3]-i->camera[3])+basis[r][1]*(m[7]-i->camera[4])+basis[r][2]*(m[11]-i->camera[5]));
	movss	12(%r14), %xmm0	# MEM[(float *)_331 + 12B], MEM[(float *)_331 + 12B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:490:             projection[4*r+3]=zoom*(basis[r][0]*(m[3]-i->camera[3])+basis[r][1]*(m[7]-i->camera[4])+basis[r][2]*(m[11]-i->camera[5]));
	movss	28(%r14), %xmm13	# MEM[(float *)_331 + 28B], MEM[(float *)_331 + 28B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:486:         const float *basis[3]={right,down,forward};
	movq	%rcx, 920(%rsp)	# down, MEM[(const float *[3] *)_414][1]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:490:             projection[4*r+3]=zoom*(basis[r][0]*(m[3]-i->camera[3])+basis[r][1]*(m[7]-i->camera[4])+basis[r][2]*(m[11]-i->camera[5]));
	xorl	%ecx, %ecx	# ivtmp.359
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:490:             projection[4*r+3]=zoom*(basis[r][0]*(m[3]-i->camera[3])+basis[r][1]*(m[7]-i->camera[4])+basis[r][2]*(m[11]-i->camera[5]));
	subss	52(%r11), %xmm0	# i_265(D)->camera[3], MEM[(float *)_331 + 12B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:490:             projection[4*r+3]=zoom*(basis[r][0]*(m[3]-i->camera[3])+basis[r][1]*(m[7]-i->camera[4])+basis[r][2]*(m[11]-i->camera[5]));
	subss	56(%r11), %xmm13	# i_265(D)->camera[4], _93
	movl	%r13d, %r15d	# _336, _336
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:486:         const float *basis[3]={right,down,forward};
	movq	%r8, 928(%rsp)	# forward, MEM[(const float *[3] *)_414][2]
	leaq	352(%rsp), %r8	#, tmp1135
	leaq	12(%r14), %r9	#, _1437
	movl	%ecx, %r13d	# ivtmp.359, r
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:490:             projection[4*r+3]=zoom*(basis[r][0]*(m[3]-i->camera[3])+basis[r][1]*(m[7]-i->camera[4])+basis[r][2]*(m[11]-i->camera[5]));
	movss	44(%r14), %xmm12	# MEM[(float *)_331 + 44B], MEM[(float *)_331 + 44B]
	movq	%r8, 96(%rsp)	# ivtmp.348, %sfp
	subss	60(%r11), %xmm12	# i_265(D)->camera[5], _99
	movq	%r8, %rdi	# tmp1135, ivtmp.375
	leaq	912(%rsp), %r10	#, tmp1132
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:486:         const float *basis[3]={right,down,forward};
	movq	%rdx, 912(%rsp)	# right, MEM[(const float *[3] *)_414][0]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:490:             projection[4*r+3]=zoom*(basis[r][0]*(m[3]-i->camera[3])+basis[r][1]*(m[7]-i->camera[4])+basis[r][2]*(m[11]-i->camera[5]));
	movss	%xmm0, 64(%rsp)	# MEM[(float *)_331 + 12B], %sfp
	movss	%xmm13, 80(%rsp)	# _93, %sfp
	movsd	%xmm2, 88(%rsp)	# b, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:488:             const float zoom=r<2?i->camera[6]:1;
	cmpq	$2, %rcx	#, ivtmp.359
	je	.L144	#,
.L219:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:488:             const float zoom=r<2?i->camera[6]:1;
	movss	64(%r11), %xmm11	# i_265(D)->camera[6], iftmp.31_245
.L84:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:489:             for(unsigned col=0;col<3;col++)projection[4*r+col]=zoom*(basis[r][0]*m[col]+basis[r][1]*m[4+col]+basis[r][2]*m[8+col]);
	movq	(%r10,%rcx,8), %rdx	# MEM[(const float * *)_414 + ivtmp.359_1436 * 8], _58
	sall	$2, %r13d	#, ivtmp.356
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:489:             for(unsigned col=0;col<3;col++)projection[4*r+col]=zoom*(basis[r][0]*m[col]+basis[r][1]*m[4+col]+basis[r][2]*m[8+col]);
	movss	(%rdx), %xmm3	# *_58, _59
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:489:             for(unsigned col=0;col<3;col++)projection[4*r+col]=zoom*(basis[r][0]*m[col]+basis[r][1]*m[4+col]+basis[r][2]*m[8+col]);
	movss	4(%rdx), %xmm1	# MEM[(const float *)_58 + 4B], _65
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:489:             for(unsigned col=0;col<3;col++)projection[4*r+col]=zoom*(basis[r][0]*m[col]+basis[r][1]*m[4+col]+basis[r][2]*m[8+col]);
	movss	8(%rdx), %xmm2	# MEM[(const float *)_58 + 8B], _73
	movq	%r14, %rdx	# _331, ivtmp.355
.L85:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:489:             for(unsigned col=0;col<3;col++)projection[4*r+col]=zoom*(basis[r][0]*m[col]+basis[r][1]*m[4+col]+basis[r][2]*m[8+col]);
	movss	(%rdx), %xmm13	# MEM[(float *)_1441], _64
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:489:             for(unsigned col=0;col<3;col++)projection[4*r+col]=zoom*(basis[r][0]*m[col]+basis[r][1]*m[4+col]+basis[r][2]*m[8+col]);
	movss	16(%rdx), %xmm0	# MEM[(float *)_1441 + 16B], _71
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:489:             for(unsigned col=0;col<3;col++)projection[4*r+col]=zoom*(basis[r][0]*m[col]+basis[r][1]*m[4+col]+basis[r][2]*m[8+col]);
	movl	%r13d, %eax	# ivtmp.356, ivtmp.356
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:489:             for(unsigned col=0;col<3;col++)projection[4*r+col]=zoom*(basis[r][0]*m[col]+basis[r][1]*m[4+col]+basis[r][2]*m[8+col]);
	addq	$4, %rdx	#, ivtmp.355
	addl	$1, %r13d	#, ivtmp.356
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:489:             for(unsigned col=0;col<3;col++)projection[4*r+col]=zoom*(basis[r][0]*m[col]+basis[r][1]*m[4+col]+basis[r][2]*m[8+col]);
	mulss	%xmm3, %xmm13	# _59, _64
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:489:             for(unsigned col=0;col<3;col++)projection[4*r+col]=zoom*(basis[r][0]*m[col]+basis[r][1]*m[4+col]+basis[r][2]*m[8+col]);
	mulss	%xmm1, %xmm0	# _65, _71
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:489:             for(unsigned col=0;col<3;col++)projection[4*r+col]=zoom*(basis[r][0]*m[col]+basis[r][1]*m[4+col]+basis[r][2]*m[8+col]);
	addss	%xmm13, %xmm0	# _64, _72
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:489:             for(unsigned col=0;col<3;col++)projection[4*r+col]=zoom*(basis[r][0]*m[col]+basis[r][1]*m[4+col]+basis[r][2]*m[8+col]);
	movss	28(%rdx), %xmm13	# MEM[(float *)_1441 + 32B], _79
	mulss	%xmm2, %xmm13	# _73, _79
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:489:             for(unsigned col=0;col<3;col++)projection[4*r+col]=zoom*(basis[r][0]*m[col]+basis[r][1]*m[4+col]+basis[r][2]*m[8+col]);
	addss	%xmm13, %xmm0	# _79, _80
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:489:             for(unsigned col=0;col<3;col++)projection[4*r+col]=zoom*(basis[r][0]*m[col]+basis[r][1]*m[4+col]+basis[r][2]*m[8+col]);
	mulss	%xmm11, %xmm0	# iftmp.31_245, _83
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:489:             for(unsigned col=0;col<3;col++)projection[4*r+col]=zoom*(basis[r][0]*m[col]+basis[r][1]*m[4+col]+basis[r][2]*m[8+col]);
	movss	%xmm0, 352(%rsp,%rax,4)	# _83, projection[ivtmp.356_1444]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:489:             for(unsigned col=0;col<3;col++)projection[4*r+col]=zoom*(basis[r][0]*m[col]+basis[r][1]*m[4+col]+basis[r][2]*m[8+col]);
	cmpq	%rdx, %r9	# ivtmp.355, _1437
	jne	.L85	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:490:             projection[4*r+3]=zoom*(basis[r][0]*(m[3]-i->camera[3])+basis[r][1]*(m[7]-i->camera[4])+basis[r][2]*(m[11]-i->camera[5]));
	mulss	64(%rsp), %xmm3	# %sfp, _89
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:491:             if(r<2)projection[4*r+3]+=i->camera[7+r];
	addq	$1, %rcx	#, ivtmp.359
	addq	$16, %rdi	#, ivtmp.375
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:490:             projection[4*r+3]=zoom*(basis[r][0]*(m[3]-i->camera[3])+basis[r][1]*(m[7]-i->camera[4])+basis[r][2]*(m[11]-i->camera[5]));
	mulss	80(%rsp), %xmm1	# %sfp, _94
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:490:             projection[4*r+3]=zoom*(basis[r][0]*(m[3]-i->camera[3])+basis[r][1]*(m[7]-i->camera[4])+basis[r][2]*(m[11]-i->camera[5]));
	mulss	%xmm12, %xmm2	# _99, _100
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:490:             projection[4*r+3]=zoom*(basis[r][0]*(m[3]-i->camera[3])+basis[r][1]*(m[7]-i->camera[4])+basis[r][2]*(m[11]-i->camera[5]));
	addss	%xmm3, %xmm1	# _89, _95
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:490:             projection[4*r+3]=zoom*(basis[r][0]*(m[3]-i->camera[3])+basis[r][1]*(m[7]-i->camera[4])+basis[r][2]*(m[11]-i->camera[5]));
	addss	%xmm2, %xmm1	# _100, _101
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:490:             projection[4*r+3]=zoom*(basis[r][0]*(m[3]-i->camera[3])+basis[r][1]*(m[7]-i->camera[4])+basis[r][2]*(m[11]-i->camera[5]));
	mulss	%xmm11, %xmm1	# iftmp.31_245, _104
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:490:             projection[4*r+3]=zoom*(basis[r][0]*(m[3]-i->camera[3])+basis[r][1]*(m[7]-i->camera[4])+basis[r][2]*(m[11]-i->camera[5]));
	movss	%xmm1, -4(%rdi)	# _104, MEM[(float *)_1429 + 12B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:491:             if(r<2)projection[4*r+3]+=i->camera[7+r];
	cmpq	$3, %rcx	#, ivtmp.359
	je	.L86	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:491:             if(r<2)projection[4*r+3]+=i->camera[7+r];
	addss	64(%r11,%rcx,4), %xmm1	# MEM[(float *)i_265(D) + 64B + ivtmp.359_1435 * 4], _107
	movl	%ecx, %r13d	# ivtmp.359, r
	movss	%xmm1, -4(%rdi)	# _107, MEM[(float *)_1430 + -4B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:488:             const float zoom=r<2?i->camera[6]:1;
	cmpq	$2, %rcx	#, ivtmp.359
	jne	.L219	#,
.L144:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:488:             const float zoom=r<2?i->camera[6]:1;
	movss	.LC15(%rip), %xmm11	#, iftmp.31_245
	jmp	.L84	#
	.p2align 4,,10
	.p2align 3
.L86:
	movsd	88(%rsp), %xmm2	# %sfp, b
	movq	96(%rsp), %rax	# %sfp, ivtmp.348
	movl	%r15d, %r13d	# _336,
	addq	$48, %r8	#, _1448
	movss	.LC1(%rip), %xmm1	#, tmp1134
	movss	.LC0(%rip), %xmm11	#, tmp1133
	.p2align 5
	.p2align 4
	.p2align 3
.L90:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:493:         for(unsigned r=0;r<12;r++)if(!isfinite(projection[r]))return false;
	movss	(%rax), %xmm0	# MEM[(float *)_1450], MEM[(float *)_1450]
	andps	%xmm11, %xmm0	# tmp1133, _109
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:493:         for(unsigned r=0;r<12;r++)if(!isfinite(projection[r]))return false;
	ucomiss	%xmm0, %xmm1	# _109, tmp1134
	jb	.L80	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:493:         for(unsigned r=0;r<12;r++)if(!isfinite(projection[r]))return false;
	addq	$4, %rax	#, ivtmp.348
	cmpq	%rax, %r8	# ivtmp.348, _1448
	jne	.L90	#,
.L83:
	leaq	(%rsi,%rsi,8), %rax	#, _504
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:27:     float lx=light[0],ly=light[1],lz=light[2],vx=light[3],vy=light[4],vz=light[5];
	movss	100(%r11), %xmm1	# MEM[(const float *)i_265(D) + 100B], _649
	movsd	%xmm6, 192(%rsp)	# h, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:27:     float lx=light[0],ly=light[1],lz=light[2],vx=light[3],vy=light[4],vz=light[5];
	movss	104(%r11), %xmm6	# MEM[(const float *)i_265(D) + 104B], _650
	leaq	0(%r13,%rax,8), %rax	#, _507
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:27:     float lx=light[0],ly=light[1],lz=light[2],vx=light[3],vy=light[4],vz=light[5];
	movq	%r11, 120(%rsp)	# i, %sfp
	addq	%r12, %rax	# _419, vectp.220
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:27:     float lx=light[0],ly=light[1],lz=light[2],vx=light[3],vy=light[4],vz=light[5];
	movss	%xmm1, 64(%rsp)	# _649, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:15: static uint32_t m32(const uint8_t *p){return (uint32_t)p[0]|(uint32_t)p[1]<<8|(uint32_t)p[2]<<16|(uint32_t)p[3]<<24;}
	movdqu	(%rax), %xmm0	# MEM <vector(4) unsigned int> [(const uint8_t *)vectp.220_502], vect__439.221_268
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movss	%xmm6, 80(%rsp)	# _650, %sfp
	movsd	%xmm5, 224(%rsp)	# f, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:27:     float lx=light[0],ly=light[1],lz=light[2],vx=light[3],vy=light[4],vz=light[5];
	movss	108(%r11), %xmm5	# MEM[(const float *)i_265(D) + 108B], _651
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:495:     for(unsigned r=0;r<8;r++)coeff[r]=mf(material+4*r);
	movaps	%xmm0, 320(%rsp)	# vect__439.221_268, MEM <vector(4) float> [(float *)&coeff]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:15: static uint32_t m32(const uint8_t *p){return (uint32_t)p[0]|(uint32_t)p[1]<<8|(uint32_t)p[2]<<16|(uint32_t)p[3]<<24;}
	movdqu	16(%rax), %xmm0	# MEM <vector(4) unsigned int> [(const uint8_t *)vectp.220_502 + 16B], vect__439.221_509
	movsd	%xmm7, 248(%rsp)	# k, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movaps	%xmm6, %xmm7	# _650, _674
	andps	%xmm11, %xmm7	# tmp1133, _674
	movss	%xmm5, 88(%rsp)	# _651, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:495:     for(unsigned r=0;r<8;r++)coeff[r]=mf(material+4*r);
	movaps	%xmm0, 336(%rsp)	# vect__439.221_509, MEM <vector(4) float> [(float *)&coeff + 16B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movaps	%xmm5, %xmm0	# _651, _672
	movaps	%xmm7, %xmm1	# _674, _674
	andps	%xmm11, %xmm0	# tmp1133, _672
	movaps	%xmm11, 96(%rsp)	# tmp1133, %sfp
	movsd	%xmm4, 272(%rsp)	# det, %sfp
	movsd	%xmm10, 208(%rsp)	# j, %sfp
	movsd	%xmm9, 176(%rsp)	# g, %sfp
	movsd	%xmm8, 168(%rsp)	# e, %sfp
	movsd	%xmm15, 160(%rsp)	# c, %sfp
	movsd	%xmm2, 152(%rsp)	# b, %sfp
	movsd	%xmm14, 128(%rsp)	# a, %sfp
	call	fmaxf@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movaps	96(%rsp), %xmm11	# %sfp, tmp1133
	movss	64(%rsp), %xmm1	# %sfp, tmp1431
	andps	%xmm11, %xmm1	# tmp1133, tmp1431
	call	fmaxf@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:11:     if(!(scale>0)||!isfinite(scale))return false;
	pxor	%xmm4, %xmm4	# tmp1432
	comiss	%xmm4, %xmm0	# tmp1432, scale
	jbe	.L80	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:11:     if(!(scale>0)||!isfinite(scale))return false;
	movss	.LC1(%rip), %xmm4	#, tmp1433
	movss	%xmm0, 136(%rsp)	# scale, %sfp
	ucomiss	%xmm0, %xmm4	# scale, tmp1433
	jnb	.L220	#,
	.p2align 4
	.p2align 3
.L80:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:478:     if(!isfinite(det)||det==0)return false;
	xorl	%eax, %eax	# <retval>
.L76:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:555: }
	addq	$1432, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
	.p2align 4,,10
	.p2align 3
.L218:
	.cfi_restore_state
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	movl	120(%rbx), %r10d	# model_266->section[12].count,
	testl	%r10d, %r10d	#
	je	.L77	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	116(%rbx), %r10d	# model_266->section[12].offset, _641
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	leaq	0(,%rsi,4), %r9	#, _642
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	xorl	%ebx, %ebx	# _632
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	andl	$262140, %r9d	#, _643
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	addq	%r12, %r10	# _419, tmp694
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	cmpb	$1, (%r10,%r9)	#, *_645
	sete	%bl	#, _632
	movl	%ebx, 40(%rsp)	# _632, %sfp
	jmp	.L77	#
	.p2align 4,,10
	.p2align 3
.L220:
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:27:     float lx=light[0],ly=light[1],lz=light[2],vx=light[3],vy=light[4],vz=light[5];
	movq	120(%rsp), %r11	# %sfp, i
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movaps	96(%rsp), %xmm11	# %sfp, tmp1133
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:27:     float lx=light[0],ly=light[1],lz=light[2],vx=light[3],vy=light[4],vz=light[5];
	movl	116(%r11), %r13d	# MEM[(const float *)i_265(D) + 116B], _653
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:27:     float lx=light[0],ly=light[1],lz=light[2],vx=light[3],vy=light[4],vz=light[5];
	movl	120(%r11), %r15d	# MEM[(const float *)i_265(D) + 120B], _654
	movq	%r11, 280(%rsp)	# i, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:27:     float lx=light[0],ly=light[1],lz=light[2],vx=light[3],vy=light[4],vz=light[5];
	movss	112(%r11), %xmm4	# MEM[(const float *)i_265(D) + 112B], _652
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movd	%r13d, %xmm3	# _653, _701
	andps	%xmm11, %xmm3	# tmp1133, _701
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:27:     float lx=light[0],ly=light[1],lz=light[2],vx=light[3],vy=light[4],vz=light[5];
	movss	%xmm4, 120(%rsp)	# _652, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movaps	%xmm3, %xmm1	# _701, _701
	movd	%r15d, %xmm3	# _654, _699
	andps	%xmm11, %xmm3	# tmp1133, _699
	movaps	%xmm3, %xmm0	# _699, _699
	call	fmaxf@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movaps	96(%rsp), %xmm11	# %sfp, tmp1133
	movss	120(%rsp), %xmm4	# %sfp, tmp1437
	movaps	%xmm11, 256(%rsp)	# tmp1133, %sfp
	andps	%xmm11, %xmm4	# tmp1133, tmp1437
	movaps	%xmm4, %xmm1	# tmp1437,
	call	fmaxf@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:11:     if(!(scale>0)||!isfinite(scale))return false;
	pxor	%xmm3, %xmm3	# tmp1438
	comiss	%xmm3, %xmm0	# tmp1438, scale
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movaps	%xmm0, %xmm13	# tmp1163, scale
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:11:     if(!(scale>0)||!isfinite(scale))return false;
	jbe	.L80	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:11:     if(!(scale>0)||!isfinite(scale))return false;
	movss	.LC1(%rip), %xmm3	#, tmp1439
	ucomiss	%xmm0, %xmm3	# scale, tmp1439
	jb	.L80	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	movss	136(%rsp), %xmm12	# %sfp, scale
	movss	64(%rsp), %xmm1	# %sfp, _649
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movaps	256(%rsp), %xmm11	# %sfp, tmp1133
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	movss	88(%rsp), %xmm5	# %sfp, _651
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	divss	%xmm12, %xmm1	# scale, _649
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movaps	%xmm11, 64(%rsp)	# tmp1133, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	divss	%xmm12, %xmm5	# scale, _651
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	movaps	%xmm1, %xmm0	# _649, _679
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	movss	80(%rsp), %xmm1	# %sfp, _650
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	movaps	%xmm0, %xmm3	# _679, _685
	mulss	%xmm0, %xmm3	# _679, _685
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	divss	%xmm12, %xmm1	# scale, _650
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	movaps	%xmm1, %xmm6	# _681, _687
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	movaps	%xmm1, %xmm7	# _681, _681
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	mulss	%xmm1, %xmm6	# _681, _687
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	movd	%r15d, %xmm1	# _654, _654
	divss	%xmm13, %xmm1	# scale, _654
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	movaps	%xmm6, %xmm12	# _687, _687
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	movaps	%xmm0, %xmm6	# _679, _679
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	addss	%xmm3, %xmm12	# _685, _688
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	movaps	%xmm5, %xmm3	# _683, _689
	mulss	%xmm5, %xmm3	# _683, _689
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	addss	%xmm3, %xmm12	# _689, _690
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	movd	%r13d, %xmm3	# _653, _653
	divss	%xmm13, %xmm3	# scale, _653
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	sqrtss	%xmm12, %xmm12	# _690, length
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	divss	%xmm12, %xmm7	# length, _681
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	movaps	%xmm3, %xmm0	# _708, _714
	mulss	%xmm3, %xmm0	# _708, _714
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	divss	%xmm12, %xmm6	# length, _679
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	movss	%xmm7, 144(%rsp)	# _694, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	divss	%xmm12, %xmm5	# length, _683
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	movss	120(%rsp), %xmm12	# %sfp, _652
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	movss	%xmm6, 140(%rsp)	# _692, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	divss	%xmm13, %xmm12	# scale, _652
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	movss	%xmm5, 148(%rsp)	# _696, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	movaps	%xmm12, %xmm13	# _706, _712
	mulss	%xmm12, %xmm13	# _706, _712
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	addss	%xmm13, %xmm0	# _712, _715
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	movaps	%xmm1, %xmm13	# _710, _716
	mulss	%xmm1, %xmm13	# _710, _716
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	addss	%xmm13, %xmm0	# _716, _717
	sqrtss	%xmm0, %xmm0	# _717, length
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	divss	%xmm0, %xmm3	# length, _721
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	divss	%xmm0, %xmm12	# length, _719
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	divss	%xmm0, %xmm1	# length, _723
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:29:     float hx=lx+vx,hy=ly+vy,hz=lz+vz;
	addss	%xmm6, %xmm12	# _692, _719
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:29:     float hx=lx+vx,hy=ly+vy,hz=lz+vz;
	movaps	%xmm3, %xmm6	# _721, _721
	addss	%xmm7, %xmm6	# _694, _721
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:29:     float hx=lx+vx,hy=ly+vy,hz=lz+vz;
	movss	%xmm12, 96(%rsp)	# _719, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movss	%xmm6, 120(%rsp)	# hy, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:29:     float hx=lx+vx,hy=ly+vy,hz=lz+vz;
	addss	%xmm5, %xmm1	# _696, _723
	movaps	%xmm1, %xmm5	# _723, hz
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movaps	%xmm6, %xmm1	# hy, _728
	movss	%xmm5, 136(%rsp)	# hz, %sfp
	movaps	%xmm5, %xmm0	# hz, _726
	andps	%xmm11, %xmm1	# tmp1133, _728
	andps	%xmm11, %xmm0	# tmp1133, _726
	call	fmaxf@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movaps	64(%rsp), %xmm11	# %sfp, tmp1133
	movss	96(%rsp), %xmm1	# %sfp, tmp1464
	andps	%xmm11, %xmm1	# tmp1133, tmp1464
	call	fmaxf@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:11:     if(!(scale>0)||!isfinite(scale))return false;
	pxor	%xmm7, %xmm7	# tmp1465
	movq	280(%rsp), %r11	# %sfp, i
	movsd	128(%rsp), %xmm14	# %sfp, a
	movsd	152(%rsp), %xmm2	# %sfp, b
	comiss	%xmm7, %xmm0	# tmp1465, scale
	movsd	160(%rsp), %xmm15	# %sfp, c
	movsd	168(%rsp), %xmm8	# %sfp, e
	movsd	224(%rsp), %xmm5	# %sfp, f
	movsd	176(%rsp), %xmm9	# %sfp, g
	movsd	192(%rsp), %xmm6	# %sfp, h
	movsd	208(%rsp), %xmm10	# %sfp, j
	movsd	248(%rsp), %xmm7	# %sfp, k
	movsd	272(%rsp), %xmm4	# %sfp, det
	jbe	.L214	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:11:     if(!(scale>0)||!isfinite(scale))return false;
	movss	.LC1(%rip), %xmm3	#, tmp1466
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:11:     if(!(scale>0)||!isfinite(scale))return false;
	movb	$0, 128(%rsp)	#, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:11:     if(!(scale>0)||!isfinite(scale))return false;
	ucomiss	%xmm0, %xmm3	# scale, tmp1466
	jnb	.L221	#,
.L93:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:473:     const unsigned nv=m16(d+2),nt=m16(d+6);const bool sided=mesh_double(model,node);float *m=work(i,id);
	movzwl	304(%rsp), %eax	# %sfp, nv
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:475:     float *xy=(float *)((uint8_t *)p+sizeof *p),*depth=xy+2*nv;
	leaq	1124(%r14), %r10	#, xy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:473:     const unsigned nv=m16(d+2),nt=m16(d+6);const bool sided=mesh_double(model,node);float *m=work(i,id);
	movl	%eax, 152(%rsp)	# nv, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:475:     float *xy=(float *)((uint8_t *)p+sizeof *p),*depth=xy+2*nv;
	addl	%eax, %eax	# nv,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:497:     if(!light_only){memset(p,0,sizeof *p);p->header.vertices=(uint8_t)nv;p->header.holes=d[10];}
	cmpb	$0, 244(%rsp)	#, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:475:     float *xy=(float *)((uint8_t *)p+sizeof *p),*depth=xy+2*nv;
	movl	%eax, %eax	#,
	movq	%rax, 312(%rsp)	# _4, %sfp
	movq	%rax, %rdx	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:475:     float *xy=(float *)((uint8_t *)p+sizeof *p),*depth=xy+2*nv;
	leaq	(%r10,%rax,4), %rax	#, depth
	movq	%rax, 280(%rsp)	# depth, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:497:     if(!light_only){memset(p,0,sizeof *p);p->header.vertices=(uint8_t)nv;p->header.holes=d[10];}
	je	.L222	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:498:     for(unsigned v=0;v<nv;v++){
	movl	152(%rsp), %esi	# %sfp,
	leaq	92(%r14), %r8	#, ivtmp.332
	testl	%esi, %esi	#
	je	.L112	#,
.L110:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:482:         (c*j-b*k)/det,(a*k-c*h)/det,(b*h-a*j)/det,
	movapd	%xmm15, %xmm0	# c, _33
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:482:         (c*j-b*k)/det,(a*k-c*h)/det,(b*h-a*j)/det,
	movapd	%xmm2, %xmm1	# b, _34
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:496:     ayatsuri_shade_basis shade;if(!ayatsuri_shade_prepare(i->lighting,&shade))return false;
	leaq	100(%r11), %rax	#, _113
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:443:     return (uint16_t *)((uint8_t *)work(i,id)+mesh_legacy_bytes(nv));
	xorl	%r13d, %r13d	# v
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:482:         (c*j-b*k)/det,(a*k-c*h)/det,(b*h-a*j)/det,
	mulsd	%xmm7, %xmm1	# k, _34
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:482:         (c*j-b*k)/det,(a*k-c*h)/det,(b*h-a*j)/det,
	movapd	%xmm15, %xmm3	# c, _38
	movq	%r12, %rsi	# _419, _419
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:496:     ayatsuri_shade_basis shade;if(!ayatsuri_shade_prepare(i->lighting,&shade))return false;
	movq	%rax, 80(%rsp)	# _113, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:482:         (c*j-b*k)/det,(a*k-c*h)/det,(b*h-a*j)/det,
	mulsd	%xmm10, %xmm0	# j, _33
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:36: static unsigned mesh_legacy_bytes(unsigned nv){return (84u+sizeof(ksn_proc_gouraud_patch)+12u*nv+7u)&~7u;}
	movl	152(%rsp), %eax	# %sfp, nv
	movq	%r10, 248(%rsp)	# xy, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:482:         (c*j-b*k)/det,(a*k-c*h)/det,(b*h-a*j)/det,
	mulsd	%xmm6, %xmm3	# h, _38
	movq	%r14, 296(%rsp)	# _331, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:482:         (c*j-b*k)/det,(a*k-c*h)/det,(b*h-a*j)/det,
	mulsd	%xmm14, %xmm7	# a, _37
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:36: static unsigned mesh_legacy_bytes(unsigned nv){return (84u+sizeof(ksn_proc_gouraud_patch)+12u*nv+7u)&~7u;}
	addl	%edx, %eax	# tmp1139, _547
	movl	%edx, 308(%rsp)	# tmp1139, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:482:         (c*j-b*k)/det,(a*k-c*h)/det,(b*h-a*j)/det,
	mulsd	%xmm2, %xmm6	# b, _41
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:36: static unsigned mesh_legacy_bytes(unsigned nv){return (84u+sizeof(ksn_proc_gouraud_patch)+12u*nv+7u)&~7u;}
	leal	1131(,%rax,4), %eax	#, _548
	movq	%r11, 272(%rsp)	# i, %sfp
	movsd	%xmm4, 288(%rsp)	# det, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:482:         (c*j-b*k)/det,(a*k-c*h)/det,(b*h-a*j)/det,
	mulsd	%xmm14, %xmm10	# a, _42
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:443:     return (uint16_t *)((uint8_t *)work(i,id)+mesh_legacy_bytes(nv));
	movl	%eax, %ecx	# _548, _550
	movq	280(%rsp), %rax	# %sfp, depth
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:482:         (c*j-b*k)/det,(a*k-c*h)/det,(b*h-a*j)/det,
	subsd	%xmm1, %xmm0	# _34, _35
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:481:     const double normal[9]={(f*k-g*j)/det,(g*h-e*k)/det,(e*j-f*h)/det,
	movsd	(%rsp), %xmm1	# %sfp, _432
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:443:     return (uint16_t *)((uint8_t *)work(i,id)+mesh_legacy_bytes(nv));
	andl	$2097144, %ecx	#, _550
	movq	%rcx, 256(%rsp)	# _550, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:482:         (c*j-b*k)/det,(a*k-c*h)/det,(b*h-a*j)/det,
	subsd	%xmm3, %xmm7	# _38, _39
	movq	%rax, 88(%rsp)	# depth, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:481:     const double normal[9]={(f*k-g*j)/det,(g*h-e*k)/det,(e*j-f*h)/det,
	unpcklpd	%xmm0, %xmm1	# _35, _432
	movapd	%xmm4, %xmm0	# det, tmp809
	unpcklpd	%xmm0, %xmm0	# tmp809
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:482:         (c*j-b*k)/det,(a*k-c*h)/det,(b*h-a*j)/det,
	subsd	%xmm10, %xmm6	# _42, _43
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:481:     const double normal[9]={(f*k-g*j)/det,(g*h-e*k)/det,(e*j-f*h)/det,
	divpd	%xmm0, %xmm1	# tmp809, _432
	movaps	%xmm1, 176(%rsp)	# _432, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:481:     const double normal[9]={(f*k-g*j)/det,(g*h-e*k)/det,(e*j-f*h)/det,
	movsd	48(%rsp), %xmm1	# %sfp, _20
	subsd	32(%rsp), %xmm1	# %sfp, _20
	movq	%r8, 32(%rsp)	# ivtmp.332, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:481:     const double normal[9]={(f*k-g*j)/det,(g*h-e*k)/det,(e*j-f*h)/det,
	unpcklpd	%xmm7, %xmm1	# _39, _436
	divpd	%xmm0, %xmm1	# tmp809, _436
	movaps	%xmm1, 192(%rsp)	# _436, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:481:     const double normal[9]={(f*k-g*j)/det,(g*h-e*k)/det,(e*j-f*h)/det,
	movsd	56(%rsp), %xmm1	# %sfp, _450
	unpcklpd	%xmm6, %xmm1	# _43, _450
	divpd	%xmm0, %xmm1	# tmp809, _450
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:483:         (b*g-c*f)/det,(c*e-a*g)/det,(a*f-b*e)/det};
	movapd	%xmm2, %xmm0	# b, _45
	mulsd	%xmm9, %xmm0	# g, _45
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:483:         (b*g-c*f)/det,(c*e-a*g)/det,(a*f-b*e)/det};
	mulsd	%xmm14, %xmm9	# a, _50
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:481:     const double normal[9]={(f*k-g*j)/det,(g*h-e*k)/det,(e*j-f*h)/det,
	movaps	%xmm1, 208(%rsp)	# _450, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:483:         (b*g-c*f)/det,(c*e-a*g)/det,(a*f-b*e)/det};
	movapd	%xmm15, %xmm1	# c, _46
	mulsd	%xmm5, %xmm1	# f, _46
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:483:         (b*g-c*f)/det,(c*e-a*g)/det,(a*f-b*e)/det};
	mulsd	%xmm14, %xmm5	# a, _53
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:483:         (b*g-c*f)/det,(c*e-a*g)/det,(a*f-b*e)/det};
	subsd	%xmm1, %xmm0	# _46, _47
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:483:         (b*g-c*f)/det,(c*e-a*g)/det,(a*f-b*e)/det};
	divsd	%xmm4, %xmm0	# det, _47
	movsd	%xmm0, 160(%rsp)	# _47, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:483:         (b*g-c*f)/det,(c*e-a*g)/det,(a*f-b*e)/det};
	movapd	%xmm15, %xmm0	# c, c
	mulsd	%xmm8, %xmm0	# e, c
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:483:         (b*g-c*f)/det,(c*e-a*g)/det,(a*f-b*e)/det};
	mulsd	%xmm2, %xmm8	# b, _54
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:483:         (b*g-c*f)/det,(c*e-a*g)/det,(a*f-b*e)/det};
	subsd	%xmm9, %xmm0	# _50, _51
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:483:         (b*g-c*f)/det,(c*e-a*g)/det,(a*f-b*e)/det};
	subsd	%xmm8, %xmm5	# _54, _55
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:483:         (b*g-c*f)/det,(c*e-a*g)/det,(a*f-b*e)/det};
	divsd	%xmm4, %xmm0	# det, _51
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:483:         (b*g-c*f)/det,(c*e-a*g)/det,(a*f-b*e)/det};
	divsd	%xmm4, %xmm5	# det, _55
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:483:         (b*g-c*f)/det,(c*e-a*g)/det,(a*f-b*e)/det};
	movsd	%xmm0, 168(%rsp)	# _51, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:483:         (b*g-c*f)/det,(c*e-a*g)/det,(a*f-b*e)/det};
	movsd	%xmm5, 224(%rsp)	# _55, %sfp
	.p2align 4
	.p2align 3
.L109:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:499:         const uint8_t *cold=row(model,10,m16(d)+v,28);ksn_proc_gouraud_vertex *out=p->vertices+v;
	movzwl	(%rbx), %eax	# MEM <short unsigned int> [(const uint8_t *)_411], _117
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	24(%rsp), %rcx	# %sfp, model
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:499:         const uint8_t *cold=row(model,10,m16(d)+v,28);ksn_proc_gouraud_vertex *out=p->vertices+v;
	addl	%r13d, %eax	# v, _118
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	92(%rcx), %edx	# model_266->section[9].offset, _443
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	imull	$28, %eax, %eax	#, _118,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rdx, %rax	# _443, _446
	addq	%rax, %rsi	# _446, _447
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:500:         if(!light_only){
	cmpb	$0, 119(%rsp)	#, %sfp
	jne	.L99	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:501:             if(!mesh_project(projection,cold,xy+2*v,xy+2*v+1,depth+v))return false;
	movq	248(%rsp), %rdi	# %sfp, xy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:501:             if(!mesh_project(projection,cold,xy+2*v,xy+2*v+1,depth+v))return false;
	leal	1(%r13,%r13), %eax	#, _126
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:501:             if(!mesh_project(projection,cold,xy+2*v,xy+2*v+1,depth+v))return false;
	movq	88(%rsp), %r8	# %sfp,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:501:             if(!mesh_project(projection,cold,xy+2*v,xy+2*v+1,depth+v))return false;
	salq	$2, %rax	#, _127
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:501:             if(!mesh_project(projection,cold,xy+2*v,xy+2*v+1,depth+v))return false;
	leaq	(%rdi,%rax), %rcx	#, _128
	leaq	-4(%rdi,%rax), %rdx	#, _130
	leaq	352(%rsp), %rdi	#, tmp1135
	call	mesh_project	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:501:             if(!mesh_project(projection,cold,xy+2*v,xy+2*v+1,depth+v))return false;
	testb	%al, %al	# tmp1166
	je	.L80	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:502:             out->x=xy[2*v];out->y=xy[2*v+1];out->mask=mf(cold+24);
	movss	(%rdx), %xmm0	# *_130, _132
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:502:             out->x=xy[2*v];out->y=xy[2*v+1];out->mask=mf(cold+24);
	movq	32(%rsp), %rax	# %sfp, ivtmp.332
	movss	%xmm0, (%rax)	# _132, MEM[(float *)_1459]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:502:             out->x=xy[2*v];out->y=xy[2*v+1];out->mask=mf(cold+24);
	movss	(%rcx), %xmm0	# *_128, _133
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:502:             out->x=xy[2*v];out->y=xy[2*v+1];out->mask=mf(cold+24);
	movq	%rax, %rcx	# ivtmp.332, ivtmp.332
	movss	%xmm0, 4(%rax)	# _133, MEM[(float *)_1459 + 4B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:502:             out->x=xy[2*v];out->y=xy[2*v+1];out->mask=mf(cold+24);
	movl	24(%rsi), %eax	# MEM <unsigned int> [(const uint8_t *)_447 + 24B], MEM <unsigned int> [(const uint8_t *)_447 + 24B]
	movl	%eax, 8(%rcx)	# MEM <unsigned int> [(const uint8_t *)_447 + 24B], MEM[(float *)_1459 + 8B]
.L99:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:504:         const double x=normal[0]*mf(cold+12)+normal[1]*mf(cold+16)+normal[2]*mf(cold+20),
	pxor	%xmm0, %xmm0	# _134
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:504:         const double x=normal[0]*mf(cold+12)+normal[1]*mf(cold+16)+normal[2]*mf(cold+20),
	pxor	%xmm3, %xmm3	# _136
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:504:         const double x=normal[0]*mf(cold+12)+normal[1]*mf(cold+16)+normal[2]*mf(cold+20),
	pxor	%xmm1, %xmm1	# _139
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:504:         const double x=normal[0]*mf(cold+12)+normal[1]*mf(cold+16)+normal[2]*mf(cold+20),
	cvtss2sd	12(%rsi), %xmm0	# MEM <unsigned int> [(const uint8_t *)_447 + 12B], _134
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:504:         const double x=normal[0]*mf(cold+12)+normal[1]*mf(cold+16)+normal[2]*mf(cold+20),
	cvtss2sd	16(%rsi), %xmm3	# MEM <unsigned int> [(const uint8_t *)_447 + 16B], _136
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:504:         const double x=normal[0]*mf(cold+12)+normal[1]*mf(cold+16)+normal[2]*mf(cold+20),
	movapd	%xmm0, %xmm2	# _134, _925
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:504:         const double x=normal[0]*mf(cold+12)+normal[1]*mf(cold+16)+normal[2]*mf(cold+20),
	movapd	%xmm3, %xmm4	# _136, _453
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:504:         const double x=normal[0]*mf(cold+12)+normal[1]*mf(cold+16)+normal[2]*mf(cold+20),
	unpcklpd	%xmm2, %xmm2	# _925
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:504:         const double x=normal[0]*mf(cold+12)+normal[1]*mf(cold+16)+normal[2]*mf(cold+20),
	unpcklpd	%xmm4, %xmm4	# _453
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:504:         const double x=normal[0]*mf(cold+12)+normal[1]*mf(cold+16)+normal[2]*mf(cold+20),
	cvtss2sd	20(%rsi), %xmm1	# MEM <unsigned int> [(const uint8_t *)_447 + 20B], _139
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:504:         const double x=normal[0]*mf(cold+12)+normal[1]*mf(cold+16)+normal[2]*mf(cold+20),
	mulpd	192(%rsp), %xmm4	# %sfp, vect__137.230_448
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:504:         const double x=normal[0]*mf(cold+12)+normal[1]*mf(cold+16)+normal[2]*mf(cold+20),
	mulpd	176(%rsp), %xmm2	# %sfp, vect__135.228_435
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:506:             z=normal[6]*mf(cold+12)+normal[7]*mf(cold+16)+normal[8]*mf(cold+20),length=hypot3(x,y,z);
	mulsd	168(%rsp), %xmm3	# %sfp, _146
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:506:             z=normal[6]*mf(cold+12)+normal[7]*mf(cold+16)+normal[8]*mf(cold+20),length=hypot3(x,y,z);
	mulsd	160(%rsp), %xmm0	# %sfp, _145
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:504:         const double x=normal[0]*mf(cold+12)+normal[1]*mf(cold+16)+normal[2]*mf(cold+20),
	addpd	%xmm4, %xmm2	# vect__137.230_448, vect__138.231_449
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:504:         const double x=normal[0]*mf(cold+12)+normal[1]*mf(cold+16)+normal[2]*mf(cold+20),
	movapd	%xmm1, %xmm4	# _139, _570
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:506:             z=normal[6]*mf(cold+12)+normal[7]*mf(cold+16)+normal[8]*mf(cold+20),length=hypot3(x,y,z);
	mulsd	224(%rsp), %xmm1	# %sfp, _148
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:504:         const double x=normal[0]*mf(cold+12)+normal[1]*mf(cold+16)+normal[2]*mf(cold+20),
	unpcklpd	%xmm4, %xmm4	# _570
	mulpd	208(%rsp), %xmm4	# %sfp, vect__140.233_565
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:506:             z=normal[6]*mf(cold+12)+normal[7]*mf(cold+16)+normal[8]*mf(cold+20),length=hypot3(x,y,z);
	addsd	%xmm3, %xmm0	# _146, _147
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:506:             z=normal[6]*mf(cold+12)+normal[7]*mf(cold+16)+normal[8]*mf(cold+20),length=hypot3(x,y,z);
	addsd	%xmm1, %xmm0	# _148, _147
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:504:         const double x=normal[0]*mf(cold+12)+normal[1]*mf(cold+16)+normal[2]*mf(cold+20),
	addpd	%xmm4, %xmm2	# vect__140.233_565, vect_x_346.234
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:506:             z=normal[6]*mf(cold+12)+normal[7]*mf(cold+16)+normal[8]*mf(cold+20),length=hypot3(x,y,z);
	movq	%xmm0, %r12	# _147, z
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:308: static double hypot3(double x,double y,double z){return hypot(hypot(x,y),z);}
	movapd	%xmm2, %xmm5	# vect_x_346.234, vect_x_346.234
	movapd	%xmm2, %xmm0	# vect_x_346.234, _567
	movaps	%xmm2, (%rsp)	# vect_x_346.234, %sfp
	unpckhpd	%xmm5, %xmm5	# vect_x_346.234
	movapd	%xmm5, %xmm1	# vect_x_346.234,
	call	hypot@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:308: static double hypot3(double x,double y,double z){return hypot(hypot(x,y),z);}
	movq	%r12, %xmm1	# z,
	call	hypot@PLT	#
	movapd	%xmm0, %xmm3	# tmp1168, _753
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:507:         if(!(length>0)||!isfinite(length))return false;
	pxor	%xmm0, %xmm0	# tmp866
	comisd	%xmm0, %xmm3	# tmp866, _753
	jbe	.L80	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:507:         if(!(length>0)||!isfinite(length))return false;
	movsd	.LC22(%rip), %xmm6	#, tmp1527
	ucomisd	%xmm3, %xmm6	# _753, tmp1527
	jb	.L80	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:508:         int16_t snorm[3];const double components[3]={x,y,z};
	movapd	(%rsp), %xmm2	# %sfp, vect_x_346.234
	xorl	%r15d, %r15d	# ivtmp.319
	movq	%r12, 928(%rsp)	# z, MEM[(double[3] *)_414][2]
	leaq	912(%rsp), %r14	#, tmp1132
	leaq	464(%rsp), %r12	#, tmp1129
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:509:         for(unsigned r=0;r<3;r++)snorm[r]=(int16_t)fmax(-32767,fmin(32767,floor(components[r]*32767/length+0.5)));
	movsd	%xmm3, (%rsp)	# _753, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:508:         int16_t snorm[3];const double components[3]={x,y,z};
	movaps	%xmm2, 912(%rsp)	# vect_x_346.234, MEM <vector(2) double> [(double *)_414]
.L103:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:509:         for(unsigned r=0;r<3;r++)snorm[r]=(int16_t)fmax(-32767,fmin(32767,floor(components[r]*32767/length+0.5)));
	movsd	.LC24(%rip), %xmm0	#, _151
	mulsd	(%r14,%r15,8), %xmm0	# MEM[(double *)_414 + ivtmp.319_740 * 8], _151
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:509:         for(unsigned r=0;r<3;r++)snorm[r]=(int16_t)fmax(-32767,fmin(32767,floor(components[r]*32767/length+0.5)));
	divsd	(%rsp), %xmm0	# %sfp, _152
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:509:         for(unsigned r=0;r<3;r++)snorm[r]=(int16_t)fmax(-32767,fmin(32767,floor(components[r]*32767/length+0.5)));
	addsd	.LC6(%rip), %xmm0	#, _153
	movsd	.LC13(%rip), %xmm1	#, tmp877
	movsd	.LC7(%rip), %xmm6	#, tmp1531
	andpd	%xmm0, %xmm1	# _153, tmp877
	ucomisd	%xmm1, %xmm6	# tmp877, tmp1531
	jbe	.L102	#,
	cvttsd2siq	%xmm0, %rax	# _153, tmp880
	pxor	%xmm1, %xmm1	# tmp877
	movsd	.LC9(%rip), %xmm5	#, tmp1533
	cvtsi2sdq	%rax, %xmm1	# tmp880, tmp877
	movapd	%xmm1, %xmm2	# tmp877, tmp882
	cmpnlesd	%xmm0, %xmm2	#, _153, tmp882
	andpd	%xmm5, %xmm2	# tmp1533, tmp882
	subsd	%xmm2, %xmm1	# tmp882, tmp883
	movsd	.LC13(%rip), %xmm2	#, tmp884
	andnpd	%xmm0, %xmm2	# _153, tmp884
	orpd	%xmm2, %xmm1	# tmp884, tmp883
	movapd	%xmm1, %xmm0	# tmp883, _153
.L102:
	movsd	.LC24(%rip), %xmm1	#,
	call	fmin@PLT	#
	movsd	.LC25(%rip), %xmm1	#,
	call	fmax@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:509:         for(unsigned r=0;r<3;r++)snorm[r]=(int16_t)fmax(-32767,fmin(32767,floor(components[r]*32767/length+0.5)));
	cvttsd2sil	%xmm0, %eax	# tmp1170, tmp888
	movw	%ax, (%r12,%r15,2)	# tmp888, MEM[(short int *)_82 + ivtmp.319_740 * 2]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:509:         for(unsigned r=0;r<3;r++)snorm[r]=(int16_t)fmax(-32767,fmin(32767,floor(components[r]*32767/length+0.5)));
	addq	$1, %r15	#, ivtmp.319
	cmpq	$3, %r15	#, ivtmp.319
	jne	.L103	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:510:         if(!snorm[0]&&!snorm[1]&&!snorm[2])return false;
	movzwl	464(%rsp), %eax	# MEM[(int16_t[3] *)_82][0], MEM[(int16_t[3] *)_82][0]
	orw	466(%rsp), %ax	# MEM[(int16_t[3] *)_82][1], _1019
	orw	468(%rsp), %ax	# MEM[(int16_t[3] *)_82][2], tmp1190
	je	.L80	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:512:         if(sided){
	movl	40(%rsp), %r8d	# %sfp,
	testl	%r8d, %r8d	#
	jne	.L223	#,
.L104:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:517:             const ayatsuri_shade_terms terms=ayatsuri_shade_terms_prepare(snorm,d[18],coeff,&shade);
	movss	140(%rsp), %xmm0	# %sfp,
	movss	120(%rsp), %xmm4	# %sfp,
	movq	%r12, %rdi	# tmp1129,
	leaq	320(%rsp), %r14	#, tmp915
	movzbl	128(%rsp), %ecx	# %sfp,
	movzbl	18(%rbx), %esi	# MEM[(const uint8_t *)_411 + 18B], _171
	movq	%r14, %rdx	# tmp915,
	movss	136(%rsp), %xmm5	# %sfp,
	movss	96(%rsp), %xmm3	# %sfp,
	movss	144(%rsp), %xmm1	# %sfp,
	movss	148(%rsp), %xmm2	# %sfp,
	call	ayatsuri_shade_terms_prepare.isra.0	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:518:             const uint16_t colors[2]={ayatsuri_shade_from_terms(m16(d+14),i->lighting,coeff,&terms),
	movq	80(%rsp), %r15	# %sfp, _113
	movzwl	14(%rbx), %edi	# MEM <short unsigned int> [(const uint8_t *)_411 + 14B], _172
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:517:             const ayatsuri_shade_terms terms=ayatsuri_shade_terms_prepare(snorm,d[18],coeff,&shade);
	movq	%xmm0, %rax	# tmp1173, tmp918
	movq	%xmm1, %rdx	# tmp1174, tmp919
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:518:             const uint16_t colors[2]={ayatsuri_shade_from_terms(m16(d+14),i->lighting,coeff,&terms),
	movss	%xmm0, (%rsp)	# _618, %sfp
	movd	%edx, %xmm2	# terms, tmp924
	shrq	$32, %rax	#,
	movq	%r15, %rsi	# _113,
	shrq	$32, %rdx	#,
	movd	%eax, %xmm1	# tmp923, _619
	movss	%xmm2, 56(%rsp)	# _620, %sfp
	movd	%edx, %xmm3	# tmp927, _621
	movl	%edx, 64(%rsp)	# _621, %sfp
	movq	%r14, %rdx	# tmp915,
	movl	%eax, 48(%rsp)	# _619, %sfp
	call	ayatsuri_shade_from_terms.isra.0	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:519:                 ayatsuri_shade_from_terms(m16(d+16),i->lighting,coeff,&terms)};
	movzwl	16(%rbx), %edi	# MEM <short unsigned int> [(const uint8_t *)_411 + 16B], _174
	movss	(%rsp), %xmm0	# %sfp, _618
	movq	%r14, %rdx	# tmp915,
	movss	64(%rsp), %xmm3	# %sfp, _621
	movss	56(%rsp), %xmm2	# %sfp, _620
	movq	%r15, %rsi	# _113,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:518:             const uint16_t colors[2]={ayatsuri_shade_from_terms(m16(d+14),i->lighting,coeff,&terms),
	movw	%ax, %bp	# tmp1175, colors
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:519:                 ayatsuri_shade_from_terms(m16(d+16),i->lighting,coeff,&terms)};
	movss	48(%rsp), %xmm1	# %sfp, _619
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:518:             const uint16_t colors[2]={ayatsuri_shade_from_terms(m16(d+14),i->lighting,coeff,&terms),
	movzwl	%bp, %ebp	# colors, colors
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:519:                 ayatsuri_shade_from_terms(m16(d+16),i->lighting,coeff,&terms)};
	call	ayatsuri_shade_from_terms.isra.0	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:522:         if(sided){
	movl	40(%rsp), %edi	# %sfp,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:518:             const uint16_t colors[2]={ayatsuri_shade_from_terms(m16(d+14),i->lighting,coeff,&terms),
	sall	$16, %eax	#, tmp933
	orl	%eax, %ebp	# tmp933, colors
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:520:             memcpy((uint8_t *)out+offsetof(ksn_proc_gouraud_vertex,color_a),colors,sizeof colors);
	movq	32(%rsp), %rax	# %sfp, ivtmp.332
	movl	%ebp, 12(%rax)	# colors, MEM <unsigned int> [(char * {ref-all})_1456 + 12B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:522:         if(sided){
	testl	%edi, %edi	#
	jne	.L224	#,
.L107:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:498:     for(unsigned v=0;v<nv;v++){
	movl	152(%rsp), %eax	# %sfp, nv
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:498:     for(unsigned v=0;v<nv;v++){
	addl	$1, %r13d	#, v
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:498:     for(unsigned v=0;v<nv;v++){
	addq	$16, 32(%rsp)	#, %sfp
	addq	$4, 88(%rsp)	#, %sfp
	cmpl	%eax, %r13d	# nv, v
	jnb	.L108	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	24(%rsp), %rax	# %sfp, model
	movq	(%rax), %rsi	# model_266->data, _419
	jmp	.L109	#
	.p2align 4,,10
	.p2align 3
.L224:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movq	272(%rsp), %rax	# %sfp, i
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:524:             const ayatsuri_shade_terms terms=ayatsuri_shade_terms_prepare(back_snorm,d[18],coeff,&shade);
	movss	120(%rsp), %xmm4	# %sfp,
	leaq	528(%rsp), %rdi	#, tmp1130
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:523:             uint16_t *back=mesh_back_colors(i,id,nv)+2*v;
	movq	256(%rsp), %rcx	# %sfp, _550
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:524:             const ayatsuri_shade_terms terms=ayatsuri_shade_terms_prepare(back_snorm,d[18],coeff,&shade);
	movzbl	18(%rbx), %esi	# MEM[(const uint8_t *)_411 + 18B], _180
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movq	8(%rax), %rdx	# i_265(D)->arena, _543
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:524:             const ayatsuri_shade_terms terms=ayatsuri_shade_terms_prepare(back_snorm,d[18],coeff,&shade);
	movss	96(%rsp), %xmm3	# %sfp,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movq	232(%rsp), %rax	# %sfp, tmp702
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:524:             const ayatsuri_shade_terms terms=ayatsuri_shade_terms_prepare(back_snorm,d[18],coeff,&shade);
	movss	140(%rsp), %xmm0	# %sfp,
	movss	136(%rsp), %xmm5	# %sfp,
	movss	144(%rsp), %xmm1	# %sfp,
	movss	148(%rsp), %xmm2	# %sfp,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movl	8(%rdx,%rax), %eax	# _544->offset, _546
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:523:             uint16_t *back=mesh_back_colors(i,id,nv)+2*v;
	addq	%rcx, %rax	# _550, _551
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:523:             uint16_t *back=mesh_back_colors(i,id,nv)+2*v;
	leal	(%r13,%r13), %ecx	#, _177
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:523:             uint16_t *back=mesh_back_colors(i,id,nv)+2*v;
	leaq	(%rax,%rcx,2), %rax	#, _596
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:524:             const ayatsuri_shade_terms terms=ayatsuri_shade_terms_prepare(back_snorm,d[18],coeff,&shade);
	movzbl	128(%rsp), %ecx	# %sfp,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:523:             uint16_t *back=mesh_back_colors(i,id,nv)+2*v;
	leaq	(%rdx,%rax), %r12	#, back
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:524:             const ayatsuri_shade_terms terms=ayatsuri_shade_terms_prepare(back_snorm,d[18],coeff,&shade);
	movq	%r14, %rdx	# tmp915,
	call	ayatsuri_shade_terms_prepare.isra.0	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:525:             const uint16_t colors[2]={ayatsuri_shade_from_terms(m16(d+14),i->lighting,coeff,&terms),
	movzwl	14(%rbx), %edi	# MEM <short unsigned int> [(const uint8_t *)_411 + 14B], _181
	movq	80(%rsp), %rsi	# %sfp,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:524:             const ayatsuri_shade_terms terms=ayatsuri_shade_terms_prepare(back_snorm,d[18],coeff,&shade);
	movq	%xmm0, %rax	# tmp1177, tmp945
	movq	%xmm1, %rdx	# tmp1178, tmp946
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:525:             const uint16_t colors[2]={ayatsuri_shade_from_terms(m16(d+14),i->lighting,coeff,&terms),
	movss	%xmm0, (%rsp)	# _603, %sfp
	movd	%edx, %xmm2	# terms, tmp951
	shrq	$32, %rax	#,
	shrq	$32, %rdx	#,
	movd	%eax, %xmm1	# tmp950, _604
	movss	%xmm2, 56(%rsp)	# _605, %sfp
	movd	%edx, %xmm3	# tmp954, _606
	movl	%edx, 64(%rsp)	# _606, %sfp
	movq	%r14, %rdx	# tmp915,
	movl	%eax, 48(%rsp)	# _604, %sfp
	call	ayatsuri_shade_from_terms.isra.0	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:525:             const uint16_t colors[2]={ayatsuri_shade_from_terms(m16(d+14),i->lighting,coeff,&terms),
	movl	240(%rsp), %r15d	# %sfp, colors
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:526:                 ayatsuri_shade_from_terms(m16(d+16),i->lighting,coeff,&terms)};
	movzwl	16(%rbx), %edi	# MEM <short unsigned int> [(const uint8_t *)_411 + 16B], _183
	movq	%r14, %rdx	# tmp915,
	movss	64(%rsp), %xmm3	# %sfp, _606
	movss	56(%rsp), %xmm2	# %sfp, _605
	movss	48(%rsp), %xmm1	# %sfp, _604
	movss	(%rsp), %xmm0	# %sfp, _603
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:525:             const uint16_t colors[2]={ayatsuri_shade_from_terms(m16(d+14),i->lighting,coeff,&terms),
	movw	%ax, %r15w	# tmp1179, colors
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:526:                 ayatsuri_shade_from_terms(m16(d+16),i->lighting,coeff,&terms)};
	movq	80(%rsp), %rsi	# %sfp,
	call	ayatsuri_shade_from_terms.isra.0	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:525:             const uint16_t colors[2]={ayatsuri_shade_from_terms(m16(d+14),i->lighting,coeff,&terms),
	movzwl	%r15w, %edx	# colors, colors
	sall	$16, %eax	#, tmp960
	orl	%eax, %edx	# tmp960, colors
	movl	%edx, 240(%rsp)	# colors, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:527:             memcpy(back,colors,sizeof colors);
	movl	%edx, (%r12)	# colors, MEM <unsigned int> [(char * {ref-all})back_374]
	jmp	.L107	#
	.p2align 4,,10
	.p2align 3
.L223:
	xorl	%eax, %eax	# ivtmp.311
	leaq	528(%rsp), %rdi	#, tmp1130
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:514:             for(unsigned r=0;r<3;r++)back_snorm[r]=(int16_t)fmax(-32767,fmin(32767,floor(-components[r]*32767/length+0.5)));
	movq	%rbx, 48(%rsp)	# _411, %sfp
	movq	%r14, %rbx	# tmp1132, tmp1132
	movq	%rdi, %r15	# tmp1130, tmp1130
	movq	%rax, %r14	# ivtmp.311, ivtmp.311
.L106:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:514:             for(unsigned r=0;r<3;r++)back_snorm[r]=(int16_t)fmax(-32767,fmin(32767,floor(-components[r]*32767/length+0.5)));
	movsd	(%rbx,%r14,8), %xmm0	# MEM[(double *)_414 + ivtmp.311_584 * 8], MEM[(double *)_414 + ivtmp.311_584 * 8]
	xorpd	.LC26(%rip), %xmm0	#, _162
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:514:             for(unsigned r=0;r<3;r++)back_snorm[r]=(int16_t)fmax(-32767,fmin(32767,floor(-components[r]*32767/length+0.5)));
	mulsd	.LC24(%rip), %xmm0	#, _163
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:514:             for(unsigned r=0;r<3;r++)back_snorm[r]=(int16_t)fmax(-32767,fmin(32767,floor(-components[r]*32767/length+0.5)));
	movsd	.LC13(%rip), %xmm1	#, tmp903
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:514:             for(unsigned r=0;r<3;r++)back_snorm[r]=(int16_t)fmax(-32767,fmin(32767,floor(-components[r]*32767/length+0.5)));
	divsd	(%rsp), %xmm0	# %sfp, _164
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:514:             for(unsigned r=0;r<3;r++)back_snorm[r]=(int16_t)fmax(-32767,fmin(32767,floor(-components[r]*32767/length+0.5)));
	addsd	.LC6(%rip), %xmm0	#, _165
	movsd	.LC7(%rip), %xmm7	#, tmp1539
	andpd	%xmm0, %xmm1	# _165, tmp903
	ucomisd	%xmm1, %xmm7	# tmp903, tmp1539
	jbe	.L105	#,
	cvttsd2siq	%xmm0, %rax	# _165, tmp906
	pxor	%xmm1, %xmm1	# tmp903
	movsd	.LC9(%rip), %xmm6	#, tmp1541
	cvtsi2sdq	%rax, %xmm1	# tmp906, tmp903
	movapd	%xmm1, %xmm2	# tmp903, tmp908
	cmpnlesd	%xmm0, %xmm2	#, _165, tmp908
	andpd	%xmm6, %xmm2	# tmp1541, tmp908
	subsd	%xmm2, %xmm1	# tmp908, tmp909
	movsd	.LC13(%rip), %xmm2	#, tmp910
	andnpd	%xmm0, %xmm2	# _165, tmp910
	orpd	%xmm2, %xmm1	# tmp910, tmp909
	movapd	%xmm1, %xmm0	# tmp909, _165
.L105:
	movsd	.LC24(%rip), %xmm1	#,
	call	fmin@PLT	#
	movsd	.LC25(%rip), %xmm1	#,
	call	fmax@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:514:             for(unsigned r=0;r<3;r++)back_snorm[r]=(int16_t)fmax(-32767,fmin(32767,floor(-components[r]*32767/length+0.5)));
	cvttsd2sil	%xmm0, %eax	# tmp1172, tmp914
	movw	%ax, (%r15,%r14,2)	# tmp914, MEM[(short int *)_111 + ivtmp.311_584 * 2]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:514:             for(unsigned r=0;r<3;r++)back_snorm[r]=(int16_t)fmax(-32767,fmin(32767,floor(-components[r]*32767/length+0.5)));
	addq	$1, %r14	#, ivtmp.311
	cmpq	$3, %r14	#, ivtmp.311
	jne	.L106	#,
	movq	48(%rsp), %rbx	# %sfp, _411
	jmp	.L104	#
.L222:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:497:     if(!light_only){memset(p,0,sizeof *p);p->header.vertices=(uint8_t)nv;p->header.holes=d[10];}
	leaq	92(%r14), %r8	#, ivtmp.332
	movl	%r14d, %eax	# _331, tmp806
	movq	$0, 84(%r14)	#,
	movq	$0, 1116(%r14)	#,
	movq	%r8, %rdi	# ivtmp.332, tmp805
	andq	$-8, %rdi	#, tmp805
	subl	%edi, %eax	# tmp805, tmp806
	leal	1124(%rax), %ecx	#, tmp800
	xorl	%eax, %eax	# tmp801
	shrl	$3, %ecx	#,
	rep stosq
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:497:     if(!light_only){memset(p,0,sizeof *p);p->header.vertices=(uint8_t)nv;p->header.holes=d[10];}
	movzbl	304(%rsp), %eax	# %sfp, tmp1484
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:498:     for(unsigned v=0;v<nv;v++){
	movl	152(%rsp), %r9d	# %sfp,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:497:     if(!light_only){memset(p,0,sizeof *p);p->header.vertices=(uint8_t)nv;p->header.holes=d[10];}
	movb	%al, 84(%r14)	# tmp1484, MEM[(struct ksn_proc_gouraud_patch *)_331 + 84B].header.vertices
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:497:     if(!light_only){memset(p,0,sizeof *p);p->header.vertices=(uint8_t)nv;p->header.holes=d[10];}
	movzbl	10(%rbx), %eax	# MEM[(const uint8_t *)_411 + 10B], _116
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:497:     if(!light_only){memset(p,0,sizeof *p);p->header.vertices=(uint8_t)nv;p->header.holes=d[10];}
	movb	%al, 86(%r14)	# _116, MEM[(struct ksn_proc_gouraud_patch *)_331 + 84B].header.holes
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:498:     for(unsigned v=0;v<nv;v++){
	testl	%r9d, %r9d	#
	je	.L113	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	24(%rsp), %rax	# %sfp, model
	movq	(%rax), %r12	# model_266->data, _419
	jmp	.L110	#
.L108:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:534:     if(light_only)return true;
	cmpb	$0, 244(%rsp)	#, %sfp
	movq	248(%rsp), %r10	# %sfp, xy
	movsd	288(%rsp), %xmm4	# %sfp, det
	movq	296(%rsp), %r14	# %sfp, _331
	movq	272(%rsp), %r11	# %sfp, i
	movl	308(%rsp), %edx	# %sfp, tmp1139
	jne	.L112	#,
.L113:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:473:     const unsigned nv=m16(d+2),nt=m16(d+6);const bool sided=mesh_double(model,node);float *m=work(i,id);
	movzwl	306(%rsp), %r8d	# %sfp, nt
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:537:     for(unsigned t=0;t<nt;t++)for(unsigned v=0;v<3;v++)indices[3*t+v]=m16(row(model,11,m16(d+4)+t,6)+2*v);
	testl	%r8d, %r8d	# nt
	je	.L98	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	24(%rsp), %rax	# %sfp, model
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:537:     for(unsigned t=0;t<nt;t++)for(unsigned v=0;v<3;v++)indices[3*t+v]=m16(row(model,11,m16(d+4)+t,6)+2*v);
	xorl	%edi, %edi	# t
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	(%rax), %rbp	# model_266->data, _559
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	100(%rax), %r9d	# model_266->section[10].offset, _561
	.p2align 4
	.p2align 3
.L114:
	leal	(%rdi,%rdi,2), %esi	#, ivtmp.305
	xorl	%ecx, %ecx	# ivtmp.304
.L115:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:537:     for(unsigned t=0;t<nt;t++)for(unsigned v=0;v<3;v++)indices[3*t+v]=m16(row(model,11,m16(d+4)+t,6)+2*v);
	movzwl	4(%rbx), %eax	# MEM <short unsigned int> [(const uint8_t *)_411 + 4B], _185
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:537:     for(unsigned t=0;t<nt;t++)for(unsigned v=0;v<3;v++)indices[3*t+v]=m16(row(model,11,m16(d+4)+t,6)+2*v);
	addl	%edi, %eax	# t, _186
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	leal	(%rax,%rax,2), %eax	#, _562
	leal	(%rax,%rax), %r12d	#, _563
	leaq	0(%rbp,%rcx), %rax	#, tmp971
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:537:     for(unsigned t=0;t<nt;t++)for(unsigned v=0;v<3;v++)indices[3*t+v]=m16(row(model,11,m16(d+4)+t,6)+2*v);
	addq	$2, %rcx	#, ivtmp.304
	addq	%r9, %rax	# _561, tmp970
	movzwl	(%rax,%r12), %r12d	# MEM <short unsigned int> [(const uint8_t *)_189], load_dst_1026
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:537:     for(unsigned t=0;t<nt;t++)for(unsigned v=0;v<3;v++)indices[3*t+v]=m16(row(model,11,m16(d+4)+t,6)+2*v);
	movl	%esi, %eax	# ivtmp.305, ivtmp.305
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:537:     for(unsigned t=0;t<nt;t++)for(unsigned v=0;v<3;v++)indices[3*t+v]=m16(row(model,11,m16(d+4)+t,6)+2*v);
	addl	$1, %esi	#, ivtmp.305
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:537:     for(unsigned t=0;t<nt;t++)for(unsigned v=0;v<3;v++)indices[3*t+v]=m16(row(model,11,m16(d+4)+t,6)+2*v);
	movw	%r12w, 528(%rsp,%rax,2)	# load_dst_1026, MEM[(uint16_t[192] *)_111][ivtmp.305_556]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:537:     for(unsigned t=0;t<nt;t++)for(unsigned v=0;v<3;v++)indices[3*t+v]=m16(row(model,11,m16(d+4)+t,6)+2*v);
	cmpq	$6, %rcx	#, ivtmp.304
	jne	.L115	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:537:     for(unsigned t=0;t<nt;t++)for(unsigned v=0;v<3;v++)indices[3*t+v]=m16(row(model,11,m16(d+4)+t,6)+2*v);
	addl	$1, %edi	#, t
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:537:     for(unsigned t=0;t<nt;t++)for(unsigned v=0;v<3;v++)indices[3*t+v]=m16(row(model,11,m16(d+4)+t,6)+2*v);
	cmpl	%edi, %r8d	# t, nt
	jne	.L114	#,
.L98:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:538:     if(sided){
	movl	40(%rsp), %ecx	# %sfp,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:540:         mesh_select_sided(xy,depth,indices,nt,d[11],det<0,p,bits);counts[0]=p->header.triangles;
	movzbl	11(%rbx), %r15d	# MEM[(const uint8_t *)_411 + 11B], pretmp_1489
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:538:     if(sided){
	testl	%ecx, %ecx	#
	je	.L116	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movq	8(%r11), %rcx	# i_265(D)->arena, _572
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movq	232(%rsp), %rax	# %sfp, tmp702
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:540:         mesh_select_sided(xy,depth,indices,nt,d[11],det<0,p,bits);counts[0]=p->header.triangles;
	pxor	%xmm0, %xmm0	# tmp990
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:539:         uint8_t *bits=(uint8_t *)(mesh_back_colors(i,id,nv)+2*nv);
	movq	312(%rsp), %rdi	# %sfp, _4
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movl	8(%rcx,%rax), %eax	# _573->offset, _575
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:539:         uint8_t *bits=(uint8_t *)(mesh_back_colors(i,id,nv)+2*nv);
	leaq	(%rax,%rdi,2), %rax	#, _1022
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:36: static unsigned mesh_legacy_bytes(unsigned nv){return (84u+sizeof(ksn_proc_gouraud_patch)+12u*nv+7u)&~7u;}
	movl	152(%rsp), %edi	# %sfp, nv
	addl	%edi, %edx	# nv, _576
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:36: static unsigned mesh_legacy_bytes(unsigned nv){return (84u+sizeof(ksn_proc_gouraud_patch)+12u*nv+7u)&~7u;}
	leal	1131(,%rdx,4), %edx	#, _577
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:443:     return (uint16_t *)((uint8_t *)work(i,id)+mesh_legacy_bytes(nv));
	andl	$2097144, %edx	#, _579
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:539:         uint8_t *bits=(uint8_t *)(mesh_back_colors(i,id,nv)+2*nv);
	addq	%rdx, %rax	# _579, _598
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:540:         mesh_select_sided(xy,depth,indices,nt,d[11],det<0,p,bits);counts[0]=p->header.triangles;
	comisd	%xmm4, %xmm0	# det, tmp990
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:539:         uint8_t *bits=(uint8_t *)(mesh_back_colors(i,id,nv)+2*nv);
	leaq	(%rcx,%rax), %rdi	#, bits
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:450:     memset(bits,0,8);
	movq	$0, (%rdi)	#, MEM <char[1:8]> [(void *)bits_315]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:540:         mesh_select_sided(xy,depth,indices,nt,d[11],det<0,p,bits);counts[0]=p->header.triangles;
	seta	(%rsp)	#, %sfp
	movzbl	(%rsp), %edx	# %sfp, _193
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:451:     for(unsigned t=0;t<nt;t++){
	testl	%r8d, %r8d	# nt
	je	.L147	#,
	leaq	528(%rsp), %r9	#, tmp1130
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:456:         flags[t]=(uint8_t)((area<0?1:0)|((area<0)!=reflected?2:0));
	movq	%rdi, (%rsp)	# bits, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:451:     for(unsigned t=0;t<nt;t++){
	xorl	%esi, %esi	# ivtmp.293
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:449:     uint8_t ids[64],flags[64];double keys[64];unsigned count=0;
	xorl	%eax, %eax	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:456:         flags[t]=(uint8_t)((area<0?1:0)|((area<0)!=reflected?2:0));
	movq	%rbx, 40(%rsp)	# _411, %sfp
	movq	%r9, %rcx	# tmp1130, ivtmp.295
	movapd	%xmm0, %xmm4	#, tmp1147
	movsd	.LC27(%rip), %xmm3	#, tmp1127
	movq	%r9, 48(%rsp)	# tmp1130, %sfp
	movq	280(%rsp), %r11	# %sfp, depth
	movq	%r14, 32(%rsp)	# _331, %sfp
	movl	%edx, %r14d	# _193, _193
	.p2align 4
	.p2align 3
.L123:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:452:         const uint16_t *v=in+3*t;const double ax=xy[2*v[0]],ay=xy[2*v[0]+1],
	movzwl	(%rcx), %ebp	# MEM[(const uint16_t *)_358],
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:453:             bx=xy[2*v[1]],by=xy[2*v[1]+1],cx=xy[2*v[2]],cy=xy[2*v[2]+1],
	movzwl	2(%rcx), %ebx	# MEM[(const uint16_t *)_358 + 2B],
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:452:         const uint16_t *v=in+3*t;const double ax=xy[2*v[0]],ay=xy[2*v[0]+1],
	pxor	%xmm5, %xmm5	# ax
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:452:         const uint16_t *v=in+3*t;const double ax=xy[2*v[0]],ay=xy[2*v[0]+1],
	pxor	%xmm2, %xmm2	# ay
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:453:             bx=xy[2*v[1]],by=xy[2*v[1]+1],cx=xy[2*v[2]],cy=xy[2*v[2]+1],
	movzwl	4(%rcx), %r9d	# MEM[(const uint16_t *)_358 + 4B],
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:453:             bx=xy[2*v[1]],by=xy[2*v[1]+1],cx=xy[2*v[2]],cy=xy[2*v[2]+1],
	pxor	%xmm0, %xmm0	# cy_798
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:453:             bx=xy[2*v[1]],by=xy[2*v[1]+1],cx=xy[2*v[2]],cy=xy[2*v[2]+1],
	pxor	%xmm1, %xmm1	# bx_780
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:452:         const uint16_t *v=in+3*t;const double ax=xy[2*v[0]],ay=xy[2*v[0]+1],
	leaq	(%rbp,%rbp), %rdx	#, _762
	andl	$131070, %edx	#, _763
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:453:             bx=xy[2*v[1]],by=xy[2*v[1]+1],cx=xy[2*v[2]],cy=xy[2*v[2]+1],
	leaq	(%r9,%r9), %rdi	#, _788
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:452:         const uint16_t *v=in+3*t;const double ax=xy[2*v[0]],ay=xy[2*v[0]+1],
	cvtss2sd	4(%r10,%rdx,4), %xmm2	# *_770, ay
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:452:         const uint16_t *v=in+3*t;const double ax=xy[2*v[0]],ay=xy[2*v[0]+1],
	cvtss2sd	(%r10,%rdx,4), %xmm5	# *_765, ax
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:453:             bx=xy[2*v[1]],by=xy[2*v[1]+1],cx=xy[2*v[2]],cy=xy[2*v[2]+1],
	leaq	(%rbx,%rbx), %rdx	#, _775
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:453:             bx=xy[2*v[1]],by=xy[2*v[1]+1],cx=xy[2*v[2]],cy=xy[2*v[2]+1],
	andl	$131070, %edi	#, _789
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:453:             bx=xy[2*v[1]],by=xy[2*v[1]+1],cx=xy[2*v[2]],cy=xy[2*v[2]+1],
	andl	$131070, %edx	#, _776
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:453:             bx=xy[2*v[1]],by=xy[2*v[1]+1],cx=xy[2*v[2]],cy=xy[2*v[2]+1],
	cvtss2sd	4(%r10,%rdi,4), %xmm0	# *_796, cy_798
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:454:             area=(bx-ax)*(cy-ay)-(by-ay)*(cx-ax);
	subsd	%xmm2, %xmm0	# ay, _800
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:453:             bx=xy[2*v[1]],by=xy[2*v[1]+1],cx=xy[2*v[2]],cy=xy[2*v[2]+1],
	cvtss2sd	(%r10,%rdx,4), %xmm1	# *_778, bx_780
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:454:             area=(bx-ax)*(cy-ay)-(by-ay)*(cx-ax);
	subsd	%xmm5, %xmm1	# ax, _799
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:454:             area=(bx-ax)*(cy-ay)-(by-ay)*(cx-ax);
	mulsd	%xmm1, %xmm0	# _799, _801
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:453:             bx=xy[2*v[1]],by=xy[2*v[1]+1],cx=xy[2*v[2]],cy=xy[2*v[2]+1],
	pxor	%xmm1, %xmm1	# by_785
	cvtss2sd	4(%r10,%rdx,4), %xmm1	# *_783, by_785
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:454:             area=(bx-ax)*(cy-ay)-(by-ay)*(cx-ax);
	subsd	%xmm2, %xmm1	# ay, _802
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:453:             bx=xy[2*v[1]],by=xy[2*v[1]+1],cx=xy[2*v[2]],cy=xy[2*v[2]+1],
	pxor	%xmm2, %xmm2	# cx_793
	cvtss2sd	(%r10,%rdi,4), %xmm2	# *_791, cx_793
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:454:             area=(bx-ax)*(cy-ay)-(by-ay)*(cx-ax);
	subsd	%xmm5, %xmm2	# ax, _803
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:454:             area=(bx-ax)*(cy-ay)-(by-ay)*(cx-ax);
	mulsd	%xmm2, %xmm1	# _803, _804
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:454:             area=(bx-ax)*(cy-ay)-(by-ay)*(cx-ax);
	subsd	%xmm1, %xmm0	# _804, area
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:455:         if(fabs(area)<=1e-5)continue;
	movapd	%xmm0, %xmm1	# area, _806
	andpd	.LC8(%rip), %xmm1	#, _806
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:455:         if(fabs(area)<=1e-5)continue;
	comisd	%xmm1, %xmm3	# _806, tmp1127
	jnb	.L118	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:456:         flags[t]=(uint8_t)((area<0?1:0)|((area<0)!=reflected?2:0));
	comisd	%xmm0, %xmm4	# area, tmp1147
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:457:         const double key=(double)depth[v[0]]+depth[v[1]]+depth[v[2]];unsigned at=count++;
	pxor	%xmm1, %xmm1	# _821
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:457:         const double key=(double)depth[v[0]]+depth[v[1]]+depth[v[2]];unsigned at=count++;
	pxor	%xmm0, %xmm0	# _816
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:456:         flags[t]=(uint8_t)((area<0?1:0)|((area<0)!=reflected?2:0));
	movl	%r14d, %edx	# _193, _1044
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:457:         const double key=(double)depth[v[0]]+depth[v[1]]+depth[v[2]];unsigned at=count++;
	cvtss2sd	(%r11,%rbx,4), %xmm1	# *_819, _821
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:457:         const double key=(double)depth[v[0]]+depth[v[1]]+depth[v[2]];unsigned at=count++;
	cvtss2sd	(%r11,%rbp,4), %xmm0	# *_814, _816
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:457:         const double key=(double)depth[v[0]]+depth[v[1]]+depth[v[2]];unsigned at=count++;
	addsd	%xmm1, %xmm0	# _821, _822
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:457:         const double key=(double)depth[v[0]]+depth[v[1]]+depth[v[2]];unsigned at=count++;
	pxor	%xmm1, %xmm1	# _827
	cvtss2sd	(%r11,%r9,4), %xmm1	# *_825, _827
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:457:         const double key=(double)depth[v[0]]+depth[v[1]]+depth[v[2]];unsigned at=count++;
	leal	1(%rax), %ebx	#, count
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:456:         flags[t]=(uint8_t)((area<0?1:0)|((area<0)!=reflected?2:0));
	seta	%dil	#, _1021
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:456:         flags[t]=(uint8_t)((area<0?1:0)|((area<0)!=reflected?2:0));
	xorl	%edi, %edx	# _1021, _1044
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:457:         const double key=(double)depth[v[0]]+depth[v[1]]+depth[v[2]];unsigned at=count++;
	addsd	%xmm1, %xmm0	# _827, key
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:456:         flags[t]=(uint8_t)((area<0?1:0)|((area<0)!=reflected?2:0));
	addl	%edx, %edx	# _249
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:456:         flags[t]=(uint8_t)((area<0?1:0)|((area<0)!=reflected?2:0));
	orl	%edi, %edx	# _1021, tmp1019
	movb	%dl, 464(%rsp,%rsi)	# tmp1019, MEM[(unsigned char *)_82 + ivtmp.293_487 * 1]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:458:         if(order==AYATSURI_VISIBILITY_CENTROID_DEPTH)
	cmpb	$1, %r15b	#, pretmp_1489
	je	.L225	#,
.L119:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:460:         keys[at]=key;ids[at]=(uint8_t)t;
	movb	%sil, 400(%rsp,%rax)	# ivtmp.293, ids[at_835]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:460:         keys[at]=key;ids[at]=(uint8_t)t;
	movsd	%xmm0, 912(%rsp,%rax,8)	# key, MEM[(double[64] *)_414][at_835]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:457:         const double key=(double)depth[v[0]]+depth[v[1]]+depth[v[2]];unsigned at=count++;
	movl	%ebx, %eax	# count,
.L118:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:451:     for(unsigned t=0;t<nt;t++){
	addq	$1, %rsi	#, ivtmp.293
	addq	$6, %rcx	#, ivtmp.295
	cmpl	%r8d, %esi	# nt, ivtmp.293
	jb	.L123	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:462:     for(unsigned t=0;t<count;t++){
	movq	(%rsp), %rdi	# %sfp, bits
	movq	32(%rsp), %r14	# %sfp, _331
	movq	40(%rsp), %rbx	# %sfp, _411
	movq	48(%rsp), %r9	# %sfp, tmp1130
	testl	%eax, %eax	# count
	je	.L124	#,
	leaq	604(%r14), %rsi	#, ivtmp.277
	movl	%eax, %r11d	# count, _492
	xorl	%r8d, %r8d	# ivtmp.274
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:465:         if(flags[id]&2)bits[t/8]|=(uint8_t)(1u<<(t%8));
	movl	$1, %ebp	#, tmp1146
	leaq	400(%rsp), %r10	#, tmp1122
	jmp	.L128	#
.L226:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:464:         dst[0]=v[0];dst[1]=v[(flags[id]&1)?2:1];dst[2]=v[(flags[id]&1)?1:2];
	movzwl	2(%rcx), %r13d	# MEM[(const uint16_t *)v_844 + 2B], cstore_638
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:464:         dst[0]=v[0];dst[1]=v[(flags[id]&1)?2:1];dst[2]=v[(flags[id]&1)?1:2];
	movl	$4, %r12d	#, iftmp.57_856
.L126:
	movw	%r13w, 2(%rsi)	# cstore_638, MEM[(uint16_t *)_488 + 2B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:464:         dst[0]=v[0];dst[1]=v[(flags[id]&1)?2:1];dst[2]=v[(flags[id]&1)?1:2];
	movzwl	(%rcx,%r12), %ecx	# *_857, _858
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:465:         if(flags[id]&2)bits[t/8]|=(uint8_t)(1u<<(t%8));
	andl	$2, %edx	#, _851
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:464:         dst[0]=v[0];dst[1]=v[(flags[id]&1)?2:1];dst[2]=v[(flags[id]&1)?1:2];
	movw	%cx, 4(%rsi)	# _858, MEM[(uint16_t *)_488 + 4B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:465:         if(flags[id]&2)bits[t/8]|=(uint8_t)(1u<<(t%8));
	je	.L127	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:465:         if(flags[id]&2)bits[t/8]|=(uint8_t)(1u<<(t%8));
	movl	%r8d, %edx	# ivtmp.274, _860
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:465:         if(flags[id]&2)bits[t/8]|=(uint8_t)(1u<<(t%8));
	movl	%r8d, %ecx	# ivtmp.274, _864
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:465:         if(flags[id]&2)bits[t/8]|=(uint8_t)(1u<<(t%8));
	movl	%ebp, %r15d	# tmp1146, _865
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:465:         if(flags[id]&2)bits[t/8]|=(uint8_t)(1u<<(t%8));
	shrl	$3, %edx	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:465:         if(flags[id]&2)bits[t/8]|=(uint8_t)(1u<<(t%8));
	andl	$7, %ecx	#, _864
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:465:         if(flags[id]&2)bits[t/8]|=(uint8_t)(1u<<(t%8));
	sall	%cl, %r15d	# _864, _865
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:465:         if(flags[id]&2)bits[t/8]|=(uint8_t)(1u<<(t%8));
	orb	%r15b, (%rdi,%rdx)	# _865, *_862
.L127:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:462:     for(unsigned t=0;t<count;t++){
	addq	$1, %r8	#, ivtmp.274
	addq	$6, %rsi	#, ivtmp.277
	cmpq	%r11, %r8	# _492, ivtmp.274
	je	.L124	#,
.L128:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:463:         unsigned id=ids[t];const uint16_t *v=in+3*id;uint16_t *dst=out->indices+3*t;
	movzbl	(%r10,%r8), %edx	# MEM[(unsigned char *)&ids + ivtmp.274_373 * 1],
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:463:         unsigned id=ids[t];const uint16_t *v=in+3*id;uint16_t *dst=out->indices+3*t;
	leal	(%rdx,%rdx,2), %ecx	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:464:         dst[0]=v[0];dst[1]=v[(flags[id]&1)?2:1];dst[2]=v[(flags[id]&1)?1:2];
	movzbl	464(%rsp,%rdx), %edx	# MEM[(uint8_t[64] *)_82][id_840], _851
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:463:         unsigned id=ids[t];const uint16_t *v=in+3*id;uint16_t *dst=out->indices+3*t;
	leaq	(%r9,%rcx,2), %rcx	#, v
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:464:         dst[0]=v[0];dst[1]=v[(flags[id]&1)?2:1];dst[2]=v[(flags[id]&1)?1:2];
	movzwl	(%rcx), %r12d	# *v_844, _850
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:464:         dst[0]=v[0];dst[1]=v[(flags[id]&1)?2:1];dst[2]=v[(flags[id]&1)?1:2];
	movw	%r12w, (%rsi)	# _850, MEM[(uint16_t *)_488]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:464:         dst[0]=v[0];dst[1]=v[(flags[id]&1)?2:1];dst[2]=v[(flags[id]&1)?1:2];
	testb	$1, %dl	#, _851
	je	.L226	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:464:         dst[0]=v[0];dst[1]=v[(flags[id]&1)?2:1];dst[2]=v[(flags[id]&1)?1:2];
	movzwl	4(%rcx), %r13d	# MEM[(const uint16_t *)v_844 + 4B], cstore_638
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:464:         dst[0]=v[0];dst[1]=v[(flags[id]&1)?2:1];dst[2]=v[(flags[id]&1)?1:2];
	movl	$2, %r12d	#, iftmp.57_856
	jmp	.L126	#
.L221:
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	movss	96(%rsp), %xmm11	# %sfp, hx
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	movss	120(%rsp), %xmm3	# %sfp, hy
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:15:     return true;
	movb	$1, 128(%rsp)	#, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	movss	136(%rsp), %xmm1	# %sfp, hz
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	divss	%xmm0, %xmm11	# scale, hx
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	divss	%xmm0, %xmm3	# scale, hy
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	movaps	%xmm11, %xmm12	# _733, _739
	mulss	%xmm11, %xmm12	# _733, _739
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	divss	%xmm0, %xmm1	# scale, hz
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	movaps	%xmm3, %xmm0	# _735, _741
	mulss	%xmm3, %xmm0	# _735, _741
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	addss	%xmm12, %xmm0	# _739, _742
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	movaps	%xmm1, %xmm12	# _737, _743
	mulss	%xmm1, %xmm12	# _737, _743
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	addss	%xmm12, %xmm0	# _743, _744
	sqrtss	%xmm0, %xmm0	# _744, length
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	divss	%xmm0, %xmm11	# length, _733
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	divss	%xmm0, %xmm3	# length, _735
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	movss	%xmm11, 96(%rsp)	# _733, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	divss	%xmm0, %xmm1	# length, _737
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	movss	%xmm3, 120(%rsp)	# _735, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	movss	%xmm1, 136(%rsp)	# _737, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:15:     return true;
	jmp	.L93	#
.L227:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:552:         if(counts[0]&&!mesh_hole_valid(clip))return false;
	movl	912(%rsp), %eax	# MEM[(uint32_t[3] *)_414][0],
	testl	%eax, %eax	#
	je	.L135	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:421:     for(unsigned i=0;i<p->count;i++){
	testl	%esi, %esi	# _226
	je	.L135	#,
	xorl	%ebp, %ebp	# ivtmp.246
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:420:     int orientation=0;
	xorl	%r8d, %r8d	# orientation
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:424:         if(dx==0&&dy==0)return false;
	pxor	%xmm2, %xmm2	# tmp1088
	xorl	%r12d, %r12d	# tmp1090
.L140:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:422:         const unsigned next=(i+1)%p->count;const double ax=p->xy[2*i],ay=p->xy[2*i+1],
	xorl	%edx, %edx	# next_874
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:422:         const unsigned next=(i+1)%p->count;const double ax=p->xy[2*i],ay=p->xy[2*i+1],
	leal	1(%rbp), %eax	#, _872
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:422:         const unsigned next=(i+1)%p->count;const double ax=p->xy[2*i],ay=p->xy[2*i+1],
	pxor	%xmm5, %xmm5	# ax
	movl	%ebp, %r10d	# ivtmp.246, _517
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:423:             dx=(double)p->xy[2*next]-ax,dy=(double)p->xy[2*next+1]-ay;
	pxor	%xmm3, %xmm3	# _883
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:422:         const unsigned next=(i+1)%p->count;const double ax=p->xy[2*i],ay=p->xy[2*i+1],
	cvtss2sd	4(%r14,%rbp,8), %xmm5	# MEM[(float *)clip_320 + 4B + ivtmp.246_519 * 8], ax
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:423:             dx=(double)p->xy[2*next]-ax,dy=(double)p->xy[2*next+1]-ay;
	pxor	%xmm4, %xmm4	# _887
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:422:         const unsigned next=(i+1)%p->count;const double ax=p->xy[2*i],ay=p->xy[2*i+1],
	pxor	%xmm6, %xmm6	# ay
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:422:         const unsigned next=(i+1)%p->count;const double ax=p->xy[2*i],ay=p->xy[2*i+1],
	divl	%esi	# _226
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:422:         const unsigned next=(i+1)%p->count;const double ax=p->xy[2*i],ay=p->xy[2*i+1],
	cvtss2sd	8(%r14,%rbp,8), %xmm6	# MEM[(float *)clip_320 + 8B + ivtmp.246_519 * 8], ay
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:423:             dx=(double)p->xy[2*next]-ax,dy=(double)p->xy[2*next+1]-ay;
	leal	(%rdx,%rdx), %edi	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:423:             dx=(double)p->xy[2*next]-ax,dy=(double)p->xy[2*next+1]-ay;
	cvtss2sd	4(%r14,%rdi,4), %xmm3	# MEM[(const struct ksn_proc_ellipsoid_clip *)clip_320].xy[_881], _883
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:423:             dx=(double)p->xy[2*next]-ax,dy=(double)p->xy[2*next+1]-ay;
	subsd	%xmm5, %xmm3	# ax, dx
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:423:             dx=(double)p->xy[2*next]-ax,dy=(double)p->xy[2*next+1]-ay;
	movq	%rdi, %rax	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:423:             dx=(double)p->xy[2*next]-ax,dy=(double)p->xy[2*next+1]-ay;
	addl	$1, %eax	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:423:             dx=(double)p->xy[2*next]-ax,dy=(double)p->xy[2*next+1]-ay;
	cvtss2sd	4(%r14,%rax,4), %xmm4	# MEM[(const struct ksn_proc_ellipsoid_clip *)clip_320].xy[_885], _887
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:423:             dx=(double)p->xy[2*next]-ax,dy=(double)p->xy[2*next+1]-ay;
	subsd	%xmm6, %xmm4	# ay, dy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:424:         if(dx==0&&dy==0)return false;
	ucomisd	%xmm2, %xmm3	# tmp1088, dx
	setnp	%al	#, tmp1087
	cmovne	%r12d, %eax	# tmp1087,, tmp1090, _1034
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:424:         if(dx==0&&dy==0)return false;
	testb	%al, %al	# _1034
	je	.L153	#,
	ucomisd	%xmm2, %xmm4	# tmp1088, dy
	setnp	%al	#, tmp1095
	cmovne	%r12d, %eax	# tmp1095,, tmp1090, _1042
	testb	%al, %al	# _1042
	jne	.L80	#,
.L153:
	movl	%esi, (%rsp)	# _226, %sfp
	xorl	%eax, %eax	# ivtmp.238
	.p2align 4
	.p2align 3
.L139:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:425:         for(unsigned j=0;j<p->count;j++)if(j!=i&&j!=next){
	cmpl	%eax, %r10d	# ivtmp.238, _517
	je	.L137	#,
	cmpl	%eax, %edx	# ivtmp.238, next_874
	je	.L137	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:426:             const double cross=dx*((double)p->xy[2*j+1]-ay)-dy*((double)p->xy[2*j]-ax);
	pxor	%xmm0, %xmm0	# _896
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:426:             const double cross=dx*((double)p->xy[2*j+1]-ay)-dy*((double)p->xy[2*j]-ax);
	pxor	%xmm1, %xmm1	# _900
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:427:             const int sign=(cross>0)-(cross<0);
	xorl	%esi, %esi	# _904
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:426:             const double cross=dx*((double)p->xy[2*j+1]-ay)-dy*((double)p->xy[2*j]-ax);
	cvtss2sd	8(%r14,%rax,8), %xmm0	# MEM[(float *)clip_320 + 8B + ivtmp.238_430 * 8], _896
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:426:             const double cross=dx*((double)p->xy[2*j+1]-ay)-dy*((double)p->xy[2*j]-ax);
	cvtss2sd	4(%r14,%rax,8), %xmm1	# MEM[(float *)clip_320 + 4B + ivtmp.238_430 * 8], _900
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:426:             const double cross=dx*((double)p->xy[2*j+1]-ay)-dy*((double)p->xy[2*j]-ax);
	subsd	%xmm6, %xmm0	# ay, _897
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:426:             const double cross=dx*((double)p->xy[2*j+1]-ay)-dy*((double)p->xy[2*j]-ax);
	subsd	%xmm5, %xmm1	# ax, _901
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:426:             const double cross=dx*((double)p->xy[2*j+1]-ay)-dy*((double)p->xy[2*j]-ax);
	mulsd	%xmm3, %xmm0	# dx, _898
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:426:             const double cross=dx*((double)p->xy[2*j+1]-ay)-dy*((double)p->xy[2*j]-ax);
	mulsd	%xmm4, %xmm1	# dy, _902
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:426:             const double cross=dx*((double)p->xy[2*j+1]-ay)-dy*((double)p->xy[2*j]-ax);
	subsd	%xmm1, %xmm0	# _902, cross
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:427:             const int sign=(cross>0)-(cross<0);
	comisd	%xmm2, %xmm0	# tmp1088, cross
	seta	%sil	#, _904
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:427:             const int sign=(cross>0)-(cross<0);
	xorl	%edi, %edi	# _906
	comisd	%xmm0, %xmm2	# cross, tmp1088
	seta	%dil	#, _906
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:428:             if(!sign||(orientation&&sign!=orientation))return false;
	subl	%edi, %esi	# _906, sign
	je	.L80	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:428:             if(!sign||(orientation&&sign!=orientation))return false;
	testl	%r8d, %r8d	# orientation
	je	.L154	#,
	cmpl	%esi, %r8d	# sign, orientation
	jne	.L80	#,
.L154:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:429:             orientation=sign;
	movl	%esi, %r8d	# sign, orientation
.L137:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:425:         for(unsigned j=0;j<p->count;j++)if(j!=i&&j!=next){
	addq	$1, %rax	#, ivtmp.238
	cmpq	%rcx, %rax	# _516, ivtmp.238
	jne	.L139	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:421:     for(unsigned i=0;i<p->count;i++){
	addq	$1, %rbp	#, ivtmp.246
	movl	(%rsp), %esi	# %sfp, _226
	cmpq	%rbp, %rcx	# ivtmp.246, _516
	jne	.L140	#,
.L135:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:546:     for(unsigned hole=0;hole<d[10];hole++){
	movzbl	10(%rbx), %eax	# MEM[(const uint8_t *)_411 + 10B], _230
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:546:     for(unsigned hole=0;hole<d[10];hole++){
	addq	$1, %r13	#, ivtmp.264
	addq	$68, %r14	#, ivtmp.268
	cmpl	%eax, %r13d	# _230, ivtmp.264
	jb	.L141	#,
.L112:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:534:     if(light_only)return true;
	movl	$1, %eax	#, <retval>
	jmp	.L76	#
.L214:
# candidate-early-snorm/main/ayatsuri/ayatsuri_shade.h:11:     if(!(scale>0)||!isfinite(scale))return false;
	movb	$0, 128(%rsp)	#, %sfp
	jmp	.L93	#
.L116:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:542:         if(ayatsuri_visibility_select(xy,depth,nv,indices,nt,(ayatsuri_visibility_order)d[11],p->indices,3*nt,counts)!=AYATSURI_VISIBILITY_OK)return false;
	movzwl	304(%rsp), %edx	# %sfp, _205
	leaq	528(%rsp), %rcx	#, tmp1052
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 1496
	movzbl	%r15b, %r9d	# pretmp_1489,
	leaq	920(%rsp), %rax	#, tmp1054
	movq	%r10, %rdi	# xy,
	pushq	%rax	# tmp1054
	.cfi_def_cfa_offset 1504
	leal	(%r8,%r8,2), %eax	#, _200
	pushq	%rax	# _200
	.cfi_def_cfa_offset 1512
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:542:         if(ayatsuri_visibility_select(xy,depth,nv,indices,nt,(ayatsuri_visibility_order)d[11],p->indices,3*nt,counts)!=AYATSURI_VISIBILITY_OK)return false;
	leaq	604(%r14), %rax	#, _201
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:542:         if(ayatsuri_visibility_select(xy,depth,nv,indices,nt,(ayatsuri_visibility_order)d[11],p->indices,3*nt,counts)!=AYATSURI_VISIBILITY_OK)return false;
	pushq	%rax	# _201
	.cfi_def_cfa_offset 1520
	movq	312(%rsp), %rsi	# %sfp,
	movzwl	338(%rsp), %r8d	# %sfp,
	call	ayatsuri_visibility_select@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:542:         if(ayatsuri_visibility_select(xy,depth,nv,indices,nt,(ayatsuri_visibility_order)d[11],p->indices,3*nt,counts)!=AYATSURI_VISIBILITY_OK)return false;
	addq	$32, %rsp	#,
	.cfi_def_cfa_offset 1488
	testl	%eax, %eax	# tmp1181
	jne	.L80	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:543:         p->header.triangles=(uint8_t)counts[0];
	movl	912(%rsp), %eax	# MEM[(uint32_t[3] *)_414][0], MEM[(uint32_t[3] *)_414][0]
	movb	%al, 85(%r14)	# MEM[(uint32_t[3] *)_414][0], MEM[(struct ksn_proc_gouraud_patch *)_331 + 84B].header.triangles
.L129:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:546:     for(unsigned hole=0;hole<d[10];hole++){
	cmpb	$0, 10(%rbx)	#, MEM[(const uint8_t *)_411 + 10B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:545:     unsigned hole_at=m16(d+8);
	movzwl	8(%rbx), %r9d	# MEM <short unsigned int> [(const uint8_t *)_411 + 8B], hole_at
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:546:     for(unsigned hole=0;hole<d[10];hole++){
	je	.L112	#,
	movq	24(%rsp), %r15	# %sfp, model
	addq	$988, %r14	#, ivtmp.268
	xorl	%r13d, %r13d	# ivtmp.264
	leaq	352(%rsp), %r11	#, tmp1143
.L141:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:547:         ksn_proc_ellipsoid_clip *clip=p->clips+hole;clip->count=d[12+hole];
	movzbl	12(%rbx,%r13), %eax	# MEM[(const uint8_t *)_411 + 12B + ivtmp.264_527 * 1], _215
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:547:         ksn_proc_ellipsoid_clip *clip=p->clips+hole;clip->count=d[12+hole];
	movb	%al, (%r14)	# _215, MEM[(unsigned char *)clip_320]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:548:         for(unsigned v=0;v<clip->count;v++){
	testb	%al, %al	# _215
	je	.L135	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	(%r15), %r12	# model_266->data, pretmp_1483
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	108(%r15), %ebp	# model_266->section[11].offset, _1487
	leaq	4(%r14), %rdx	#, ivtmp.259
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:548:         for(unsigned v=0;v<clip->count;v++){
	xorl	%r10d, %r10d	# v
	leaq	464(%rsp), %r8	#, tmp1129
	jmp	.L132	#
	.p2align 4,,10
	.p2align 3
.L228:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:548:         for(unsigned v=0;v<clip->count;v++){
	movzbl	(%r14), %esi	# MEM[(unsigned char *)clip_320],
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:548:         for(unsigned v=0;v<clip->count;v++){
	addl	$1, %r10d	#, v
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:548:         for(unsigned v=0;v<clip->count;v++){
	addq	$8, %rdx	#, ivtmp.259
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:548:         for(unsigned v=0;v<clip->count;v++){
	movq	%rsi, %rcx	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:548:         for(unsigned v=0;v<clip->count;v++){
	cmpl	%esi, %r10d	# _226, v
	jnb	.L227	#,
.L132:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:550:             if(!mesh_project(projection,row(model,12,hole_at++,12),clip->xy+2*v,clip->xy+2*v+1,&unused))return false;
	addl	$1, %r9d	#, hole_at
	leaq	4(%rdx), %rcx	#, _522
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:550:             if(!mesh_project(projection,row(model,12,hole_at++,12),clip->xy+2*v,clip->xy+2*v+1,&unused))return false;
	movq	%r11, %rdi	# tmp1143,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	leal	(%r9,%r9,2), %eax	#, _523
	leal	-12(,%rax,4), %esi	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rbp, %rsi	# _1487, _593
	addq	%r12, %rsi	# pretmp_1483, _594
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:550:             if(!mesh_project(projection,row(model,12,hole_at++,12),clip->xy+2*v,clip->xy+2*v+1,&unused))return false;
	call	mesh_project	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:550:             if(!mesh_project(projection,row(model,12,hole_at++,12),clip->xy+2*v,clip->xy+2*v+1,&unused))return false;
	testb	%al, %al	# tmp1182
	jne	.L228	#,
	jmp	.L80	#
.L225:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:459:             while(at&&keys[at-1]>key){keys[at]=keys[at-1];ids[at]=ids[at-1];--at;}
	testl	%eax, %eax	# count
	je	.L120	#,
	leal	-1(%rax), %r13d	#, _439
	movl	%eax, %ebp	# count, _496
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:459:             while(at&&keys[at-1]>key){keys[at]=keys[at-1];ids[at]=ids[at-1];--at;}
	movq	%r13, %r12	# _439, _276
	leaq	912(%rsp,%rbp,8), %rdi	#, ivtmp.287
	leaq	400(%rsp,%rbp), %r9	#, ivtmp.289
	subq	%rbp, %r12	# _496, _276
	jmp	.L121	#
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L122:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:459:             while(at&&keys[at-1]>key){keys[at]=keys[at-1];ids[at]=ids[at-1];--at;}
	movq	%r9, %rdx	# ivtmp.289, _953
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:459:             while(at&&keys[at-1]>key){keys[at]=keys[at-1];ids[at]=ids[at-1];--at;}
	movsd	%xmm1, (%rdi)	# _831, MEM[(double *)_397]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:459:             while(at&&keys[at-1]>key){keys[at]=keys[at-1];ids[at]=ids[at-1];--at;}
	subq	$1, %r9	#, ivtmp.289
	subq	$8, %rdi	#, ivtmp.287
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:459:             while(at&&keys[at-1]>key){keys[at]=keys[at-1];ids[at]=ids[at-1];--at;}
	subq	%rbp, %rdx	# _496, _953
	movzbl	(%rdx,%r13), %edx	# MEM[(unsigned char *)_508 + _439 * 1], _834
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:459:             while(at&&keys[at-1]>key){keys[at]=keys[at-1];ids[at]=ids[at-1];--at;}
	movb	%dl, 1(%r9)	# _834, MEM[(unsigned char *)_456]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:459:             while(at&&keys[at-1]>key){keys[at]=keys[at-1];ids[at]=ids[at-1];--at;}
	testl	%eax, %eax	# at
	je	.L120	#,
.L121:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:459:             while(at&&keys[at-1]>key){keys[at]=keys[at-1];ids[at]=ids[at-1];--at;}
	movsd	(%rdi,%r12,8), %xmm1	# MEM[(double *)_397 + _276 * 8], _831
	movl	%eax, %edx	# at, at
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:459:             while(at&&keys[at-1]>key){keys[at]=keys[at-1];ids[at]=ids[at-1];--at;}
	subl	$1, %eax	#, at
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:459:             while(at&&keys[at-1]>key){keys[at]=keys[at-1];ids[at]=ids[at-1];--at;}
	comisd	%xmm0, %xmm1	# key, _831
	ja	.L122	#,
	movl	%edx, %eax	# at,
	jmp	.L119	#
.L120:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:457:         const double key=(double)depth[v[0]]+depth[v[1]]+depth[v[2]];unsigned at=count++;
	xorl	%eax, %eax	#
	jmp	.L119	#
.L147:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:451:     for(unsigned t=0;t<nt;t++){
	xorl	%edx, %edx	# prephitmp_1482
.L117:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:467:     out->header.triangles=(uint8_t)count;
	movb	%dl, 85(%r14)	# prephitmp_1482, MEM[(struct ksn_proc_gouraud_patch *)_331 + 84B].header.triangles
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:540:         mesh_select_sided(xy,depth,indices,nt,d[11],det<0,p,bits);counts[0]=p->header.triangles;
	movl	%r8d, 912(%rsp)	# nt, MEM[(uint32_t[3] *)_414][0]
	jmp	.L129	#
.L124:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:467:     out->header.triangles=(uint8_t)count;
	movl	%eax, %edx	# count, prephitmp_1482
	movl	%eax, %r8d	# count, nt
	jmp	.L117	#
	.cfi_endproc
.LFE48:
	.size	mesh_packet, .-mesh_packet
	.p2align 4
	.globl	ayatsuri_model_open
	.type	ayatsuri_model_open, @function
ayatsuri_model_open:
.LFB24:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$280, %rsp	#,
	.cfi_def_cfa_offset 336
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:94:     if(!data||!out||bytes<32||bytes>AYATSURI_MODEL_MAX_BYTES||overlaps(out,sizeof *out,data,bytes))
	testq	%rdi, %rdi	# data
	je	.L230	#,
	movq	%rdx, %rbp	# tmp1033, out
	testq	%rdx, %rdx	# out
	je	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:94:     if(!data||!out||bytes<32||bytes>AYATSURI_MODEL_MAX_BYTES||overlaps(out,sizeof *out,data,bytes))
	leaq	-32(%rsi), %rax	#, _4
	cmpq	$1048544, %rax	#, _4
	ja	.L230	#,
	movq	%rdi, %rbx	# tmp1031, data
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rdx, %rdi	# out, data
	jb	.L231	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rdi, %rdx	# data, _208
	subq	%rbp, %rdx	# out, _208
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$127, %rdx	#, _208
	ja	.L232	#,
	.p2align 4
	.p2align 3
.L230:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:95:         return AYATSURI_MODEL_INVALID;
	movl	$1, %r12d	#, <retval>
.L229:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:200: }
	addq	$280, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movl	%r12d, %eax	# <retval>,
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
	.p2align 4,,10
	.p2align 3
.L231:
	.cfi_restore_state
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%rdi, %rdx	# data, _207
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rsi, %rdx	# bytes, _207
	jb	.L230	#,
.L232:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:97:     if(memcmp(p,"AYNM",4)||m16(p+4)!=1||m16(p+6)!=32||m32(p+8)!=bytes||
	cmpl	$1296980289, (%rbx)	#, MEM <unsigned int> [(char * {ref-all})data_172(D)]
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:97:     if(memcmp(p,"AYNM",4)||m16(p+4)!=1||m16(p+6)!=32||m32(p+8)!=bytes||
	cmpw	$1, 4(%rbx)	#, MEM <short unsigned int> [(const uint8_t *)data_172(D) + 4B]
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:97:     if(memcmp(p,"AYNM",4)||m16(p+4)!=1||m16(p+6)!=32||m32(p+8)!=bytes||
	cmpw	$32, 6(%rbx)	#, MEM <short unsigned int> [(const uint8_t *)data_172(D) + 6B]
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:97:     if(memcmp(p,"AYNM",4)||m16(p+4)!=1||m16(p+6)!=32||m32(p+8)!=bytes||
	movl	8(%rbx), %edx	# MEM <unsigned int> [(const uint8_t *)data_172(D) + 8B], _6
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:97:     if(memcmp(p,"AYNM",4)||m16(p+4)!=1||m16(p+6)!=32||m32(p+8)!=bytes||
	cmpq	%rsi, %rdx	# bytes, _6
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:15: static uint32_t m32(const uint8_t *p){return (uint32_t)p[0]|(uint32_t)p[1]<<8|(uint32_t)p[2]<<16|(uint32_t)p[3]<<24;}
	movl	12(%rbx), %r8d	# MEM <unsigned int> [(const uint8_t *)data_172(D) + 12B], _227
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:98:        sections<7||sections>AYATSURI_MODEL_MAX_SECTIONS||m32(p+16)!=32||m32(p+20)!=20||m32(p+24)||m32(p+28)||
	leal	-7(%r8), %edx	#, _7
	cmpl	$57, %edx	#, _7
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:98:        sections<7||sections>AYATSURI_MODEL_MAX_SECTIONS||m32(p+16)!=32||m32(p+20)!=20||m32(p+24)||m32(p+28)||
	cmpl	$32, 16(%rbx)	#, MEM <unsigned int> [(const uint8_t *)data_172(D) + 16B]
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:98:        sections<7||sections>AYATSURI_MODEL_MAX_SECTIONS||m32(p+16)!=32||m32(p+20)!=20||m32(p+24)||m32(p+28)||
	cmpl	$20, 20(%rbx)	#, MEM <unsigned int> [(const uint8_t *)data_172(D) + 20B]
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:98:        sections<7||sections>AYATSURI_MODEL_MAX_SECTIONS||m32(p+16)!=32||m32(p+20)!=20||m32(p+24)||m32(p+28)||
	movl	24(%rbx), %edx	# MEM <unsigned int> [(const uint8_t *)data_172(D) + 24B],
	testl	%edx, %edx	#
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:15: static uint32_t m32(const uint8_t *p){return (uint32_t)p[0]|(uint32_t)p[1]<<8|(uint32_t)p[2]<<16|(uint32_t)p[3]<<24;}
	movl	28(%rbx), %r12d	# MEM <unsigned int> [(const uint8_t *)data_172(D) + 28B], <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:98:        sections<7||sections>AYATSURI_MODEL_MAX_SECTIONS||m32(p+16)!=32||m32(p+20)!=20||m32(p+24)||m32(p+28)||
	testl	%r12d, %r12d	# <retval>
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:99:        sections>(bytes-32)/20)return AYATSURI_MODEL_INVALID;
	movabsq	$-3689348814741910323, %rdx	#, tmp607
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:99:        sections>(bytes-32)/20)return AYATSURI_MODEL_INVALID;
	movl	%r8d, %ecx	# _227, _8
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:99:        sections>(bytes-32)/20)return AYATSURI_MODEL_INVALID;
	mulq	%rdx	# tmp607
	movq	%rdx, %rax	# tmp606, tmp606
	shrq	$4, %rax	#, tmp606
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:98:        sections<7||sections>AYATSURI_MODEL_MAX_SECTIONS||m32(p+16)!=32||m32(p+20)!=20||m32(p+24)||m32(p+28)||
	cmpq	%rcx, %rax	# _8, _9
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:100:     const uint32_t directory_end=32+20*sections;
	imull	$20, %r8d, %eax	#, _227, _10
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:101:     ayatsuri_model candidate={.data=p,.bytes=(uint32_t)bytes};unsigned seen=0;
	movl	$29, %ecx	#, tmp611
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:103:     for(uint32_t i=0;i<sections;++i){
	xorl	%edx, %edx	# i
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:101:     ayatsuri_model candidate={.data=p,.bytes=(uint32_t)bytes};unsigned seen=0;
	xorl	%r15d, %r15d	# seen
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:101:     ayatsuri_model candidate={.data=p,.bytes=(uint32_t)bytes};unsigned seen=0;
	leaq	156(%rsp), %rdi	#, tmp609
	movq	%rbx, 144(%rsp)	# data, candidate.data
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:101:     ayatsuri_model candidate={.data=p,.bytes=(uint32_t)bytes};unsigned seen=0;
	movl	%esi, 152(%rsp)	# bytes, candidate.bytes
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:100:     const uint32_t directory_end=32+20*sections;
	addl	$32, %eax	#, directory_end
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:101:     ayatsuri_model candidate={.data=p,.bytes=(uint32_t)bytes};unsigned seen=0;
	movl	%edx, 8(%rsp)	# i, %sfp
	movl	%r12d, %edx	# <retval>, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:100:     const uint32_t directory_end=32+20*sections;
	movl	%eax, 12(%rsp)	# directory_end, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:101:     ayatsuri_model candidate={.data=p,.bytes=(uint32_t)bytes};unsigned seen=0;
	xorl	%eax, %eax	# tmp610
	rep stosl
	leaq	36(%rbx), %rax	#, ivtmp.537
	movq	%rax, 16(%rsp)	# ivtmp.537, %sfp
	movq	%rax, %r13	# ivtmp.537, ivtmp.548
.L239:
	movzwl	-2(%r13), %edi	# MEM <short unsigned int> [(const uint8_t *)_368 + -2B], load_dst_1233
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:15: static uint32_t m32(const uint8_t *p){return (uint32_t)p[0]|(uint32_t)p[1]<<8|(uint32_t)p[2]<<16|(uint32_t)p[3]<<24;}
	movl	0(%r13), %r9d	# MEM <unsigned int> [(const uint8_t *)_368], _366
	movl	4(%r13), %r10d	# MEM <unsigned int> [(const uint8_t *)_368 + 4B],
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:106:         if(flags>1||(offset&7)||offset<directory_end||offset>bytes||length>bytes-offset)
	cmpw	$1, %di	#, load_dst_1233
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:106:         if(flags>1||(offset&7)||offset<directory_end||offset>bytes||length>bytes-offset)
	testb	$7, %r9b	#, _366
	jne	.L230	#,
	movl	12(%rsp), %eax	# %sfp, directory_end
	cmpl	%eax, %r9d	# directory_end, _366
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:106:         if(flags>1||(offset&7)||offset<directory_end||offset>bytes||length>bytes-offset)
	movl	%r9d, %r12d	# _366, _16
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:106:         if(flags>1||(offset&7)||offset<directory_end||offset>bytes||length>bytes-offset)
	cmpq	%r12, %rsi	# _16, bytes
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:106:         if(flags>1||(offset&7)||offset<directory_end||offset>bytes||length>bytes-offset)
	movq	%rsi, %rax	# bytes, _18
	subq	%r12, %rax	# _16, _18
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:106:         if(flags>1||(offset&7)||offset<directory_end||offset>bytes||length>bytes-offset)
	cmpq	%r10, %rax	# _17, _18
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:108:         for(uint32_t j=0;j<i;++j){
	movl	8(%rsp), %eax	# %sfp,
	testl	%eax, %eax	#
	je	.L233	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%r10, %r10	# _17
	movl	%r15d, 56(%rsp)	# seen, %sfp
	movq	16(%rsp), %rax	# %sfp, ivtmp.537
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:110:             if(overlaps(p+offset,length,p+m32(prior+4),m32(prior+8)))return AYATSURI_MODEL_INVALID;
	leaq	(%rbx,%r12), %r14	#, _1926
	movl	%r8d, 24(%rsp)	# _227, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	setne	%r11b	#, _774
	jmp	.L236	#
.L395:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%r12, %r8	# _16, _777
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r10, %r8	# _17, _777
	jb	.L230	#,
.L234:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:108:         for(uint32_t j=0;j<i;++j){
	addq	$20, %rax	#, ivtmp.537
	cmpq	%r13, %rax	# ivtmp.548, ivtmp.537
	je	.L394	#,
.L236:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:110:             if(overlaps(p+offset,length,p+m32(prior+4),m32(prior+8)))return AYATSURI_MODEL_INVALID;
	movl	4(%rax), %ecx	# MEM <unsigned int> [(const uint8_t *)_374 + 4B], _21
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rcx, %rcx	# _21
	je	.L234	#,
	testb	%r11b, %r11b	# _774
	je	.L234	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:110:             if(overlaps(p+offset,length,p+m32(prior+4),m32(prior+8)))return AYATSURI_MODEL_INVALID;
	movl	(%rax), %r8d	# MEM <unsigned int> [(const uint8_t *)_374], _22
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:110:             if(overlaps(p+offset,length,p+m32(prior+4),m32(prior+8)))return AYATSURI_MODEL_INVALID;
	leaq	(%rbx,%r8), %r15	#, _23
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r14, %r15	# _1926, _23
	jnb	.L395	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r12, %r15	# _16, _778
	subq	%r8, %r15	# _22, _778
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rcx, %r15	# _21, _778
	jb	.L230	#,
	jmp	.L234	#
.L394:
	movl	56(%rsp), %r15d	# %sfp, seen
	movl	24(%rsp), %r8d	# %sfp, _227
.L233:
	movzwl	-4(%r13), %ecx	# MEM <short unsigned int> [(const uint8_t *)_368 + -4B],
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:15: static uint32_t m32(const uint8_t *p){return (uint32_t)p[0]|(uint32_t)p[1]<<8|(uint32_t)p[2]<<16|(uint32_t)p[3]<<24;}
	movd	8(%r13), %xmm0	# MEM <unsigned int> [(const uint8_t *)_368 + 8B], _338
	movl	12(%r13), %eax	# MEM <unsigned int> [(const uint8_t *)_368 + 12B],
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:112:         if(type>=1&&type<=13){
	leal	-1(%rcx), %r11d	#, _26
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:112:         if(type>=1&&type<=13){
	cmpw	$12, %r11w	#, _26
	ja	.L237	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:113:             const unsigned bit=1u<<(type-1);
	subl	$1, %ecx	#, _28
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:113:             const unsigned bit=1u<<(type-1);
	movl	$1, %r11d	#, tmp626
	sall	%cl, %r11d	# _28, bit
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:114:             if(flags!=1||(seen&bit)||stride!=strides[type-1]||(uint64_t)count*stride!=length)
	subw	$1, %di	#, load_dst_1233
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:114:             if(flags!=1||(seen&bit)||stride!=strides[type-1]||(uint64_t)count*stride!=length)
	testl	%r15d, %r11d	# seen, bit
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:114:             if(flags!=1||(seen&bit)||stride!=strides[type-1]||(uint64_t)count*stride!=length)
	movslq	%ecx, %rcx	# _28, _28
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:114:             if(flags!=1||(seen&bit)||stride!=strides[type-1]||(uint64_t)count*stride!=length)
	leaq	strides.0(%rip), %rdi	#, tmp628
	cmpl	%eax, (%rdi,%rcx,4)	# _324, strides[_28]
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:114:             if(flags!=1||(seen&bit)||stride!=strides[type-1]||(uint64_t)count*stride!=length)
	movd	%xmm0, %edi	# _338, _31
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:114:             if(flags!=1||(seen&bit)||stride!=strides[type-1]||(uint64_t)count*stride!=length)
	imulq	%rdi, %rax	# _31, _33
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:114:             if(flags!=1||(seen&bit)||stride!=strides[type-1]||(uint64_t)count*stride!=length)
	cmpq	%rax, %r10	# _33, _17
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:116:             candidate.section[type-1]=(ayatsuri_model_section){offset,count};seen|=bit;
	movd	%r9d, %xmm1	# _366, _937
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:116:             candidate.section[type-1]=(ayatsuri_model_section){offset,count};seen|=bit;
	orl	%r11d, %r15d	# bit, seen
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:116:             candidate.section[type-1]=(ayatsuri_model_section){offset,count};seen|=bit;
	punpckldq	%xmm0, %xmm1	# _338, _937
	movq	%xmm1, 164(%rsp,%rcx,8)	# _937, MEM <vector(2) unsigned int> [(unsigned int *)vectp.405_936]
.L238:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:103:     for(uint32_t i=0;i<sections;++i){
	addl	$1, 8(%rsp)	#, %sfp
	movl	8(%rsp), %eax	# %sfp, i
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:103:     for(uint32_t i=0;i<sections;++i){
	addq	$20, %r13	#, ivtmp.548
	cmpl	%eax, %r8d	# i, _227
	jne	.L239	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:120:     if((seen&127)!=127||((seen&0xf00)&&(seen&0xf00)!=0xf00))return AYATSURI_MODEL_INVALID;
	movl	%r15d, %eax	# seen, tmp1054
	movl	%edx, %r12d	# <retval>, <retval>
	notl	%eax	# tmp1054
	testb	$127, %al	#, tmp1054
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:120:     if((seen&127)!=127||((seen&0xf00)&&(seen&0xf00)!=0xf00))return AYATSURI_MODEL_INVALID;
	movl	%r15d, %eax	# seen, _188
	andl	$3840, %eax	#, _188
	movl	%eax, 56(%rsp)	# _188, %sfp
	je	.L319	#,
	cmpl	$3840, %eax	#, _188
	jne	.L230	#,
.L319:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:121:     const uint32_t count=candidate.section[0].count;
	movl	168(%rsp), %r13d	# candidate.section[0].count, count
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:122:     if(!count||count>AYATSURI_MODEL_MAX_NODES||candidate.section[1].count!=count||candidate.section[5].count!=count||
	leal	-1(%r13), %eax	#, _41
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:122:     if(!count||count>AYATSURI_MODEL_MAX_NODES||candidate.section[1].count!=count||candidate.section[5].count!=count||
	cmpl	$255, %eax	#, _41
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:122:     if(!count||count>AYATSURI_MODEL_MAX_NODES||candidate.section[1].count!=count||candidate.section[5].count!=count||
	cmpl	%r13d, 176(%rsp)	# count, candidate.section[1].count
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:122:     if(!count||count>AYATSURI_MODEL_MAX_NODES||candidate.section[1].count!=count||candidate.section[5].count!=count||
	cmpl	%r13d, 208(%rsp)	# count, candidate.section[5].count
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:123:        candidate.section[2].count>count||candidate.section[3].count>8*count||candidate.section[4].count>count||
	movl	184(%rsp), %eax	# candidate.section[2].count, _44
	movl	%eax, 12(%rsp)	# _44, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:122:     if(!count||count>AYATSURI_MODEL_MAX_NODES||candidate.section[1].count!=count||candidate.section[5].count!=count||
	cmpl	%eax, %r13d	# _44, count
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:123:        candidate.section[2].count>count||candidate.section[3].count>8*count||candidate.section[4].count>count||
	movl	192(%rsp), %ecx	# candidate.section[3].count, _45
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:123:        candidate.section[2].count>count||candidate.section[3].count>8*count||candidate.section[4].count>count||
	leal	0(,%r13,8), %eax	#, _46
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:123:        candidate.section[2].count>count||candidate.section[3].count>8*count||candidate.section[4].count>count||
	movl	%ecx, 16(%rsp)	# _45, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:123:        candidate.section[2].count>count||candidate.section[3].count>8*count||candidate.section[4].count>count||
	cmpl	%ecx, %eax	# _45, _46
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:123:        candidate.section[2].count>count||candidate.section[3].count>8*count||candidate.section[4].count>count||
	movl	200(%rsp), %eax	# candidate.section[4].count, _47
	movl	%eax, 8(%rsp)	# _47, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:123:        candidate.section[2].count>count||candidate.section[3].count>8*count||candidate.section[4].count>count||
	cmpl	%eax, %r13d	# _47, count
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:124:        candidate.section[6].count>127*count||
	imull	$127, %r13d, %eax	#, count, _49
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:124:        candidate.section[6].count>127*count||
	movl	216(%rsp), %r14d	# candidate.section[6].count, _48
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:123:        candidate.section[2].count>count||candidate.section[3].count>8*count||candidate.section[4].count>count||
	cmpl	%r14d, %eax	# _48, _49
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:124:        candidate.section[6].count>127*count||
	testb	$-128, %r15b	#, seen
	je	.L241	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:125:        ((seen&128)&&(!candidate.section[7].count||candidate.section[7].count>count))||
	movl	224(%rsp), %eax	# candidate.section[7].count, tmp1269
	subl	$1, %eax	#, _167
	cmpl	%r13d, %eax	# count, _167
	jnb	.L230	#,
.L241:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:125:        ((seen&128)&&(!candidate.section[7].count||candidate.section[7].count>count))||
	cmpl	$0, 56(%rsp)	#, %sfp
	je	.L242	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:126:        ((seen&0xf00)&&(!candidate.section[8].count||candidate.section[8].count>count||
	movl	232(%rsp), %eax	# candidate.section[8].count, tmp1271
	subl	$1, %eax	#, _154
	cmpl	%r13d, %eax	# count, _154
	jnb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:127:         candidate.section[9].count>32*count||candidate.section[10].count>64*count||candidate.section[11].count>16*count)))return AYATSURI_MODEL_INVALID;
	movl	%r13d, %eax	# count, _54
	sall	$5, %eax	#, _54
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:126:        ((seen&0xf00)&&(!candidate.section[8].count||candidate.section[8].count>count||
	cmpl	240(%rsp), %eax	# candidate.section[9].count, _54
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:127:         candidate.section[9].count>32*count||candidate.section[10].count>64*count||candidate.section[11].count>16*count)))return AYATSURI_MODEL_INVALID;
	movl	%r13d, %eax	# count, _56
	sall	$6, %eax	#, _56
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:127:         candidate.section[9].count>32*count||candidate.section[10].count>64*count||candidate.section[11].count>16*count)))return AYATSURI_MODEL_INVALID;
	cmpl	248(%rsp), %eax	# candidate.section[10].count, _56
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:127:         candidate.section[9].count>32*count||candidate.section[10].count>64*count||candidate.section[11].count>16*count)))return AYATSURI_MODEL_INVALID;
	movl	%r13d, %eax	# count, _58
	sall	$4, %eax	#, _58
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:127:         candidate.section[9].count>32*count||candidate.section[10].count>64*count||candidate.section[11].count>16*count)))return AYATSURI_MODEL_INVALID;
	cmpl	256(%rsp), %eax	# candidate.section[11].count, _58
	jb	.L230	#,
.L242:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:128:     if(seen&(1u<<12)){
	andl	$4096, %r15d	#, seen
	je	.L243	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:129:         if(!candidate.section[12].count||candidate.section[12].count!=candidate.section[4].count)return AYATSURI_MODEL_INVALID;
	movl	264(%rsp), %ecx	# candidate.section[12].count, _60
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:129:         if(!candidate.section[12].count||candidate.section[12].count!=candidate.section[4].count)return AYATSURI_MODEL_INVALID;
	testl	%ecx, %ecx	# _60
	je	.L230	#,
	cmpl	%ecx, 8(%rsp)	# _60, %sfp
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	260(%rsp), %eax	# candidate.section[12].offset, _410
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:130:         for(uint32_t j=0;j<candidate.section[12].count;j++){
	xorl	%edx, %edx	# j
	addq	%rbx, %rax	# data, ivtmp.533
	jmp	.L244	#
.L396:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:132:             if(v[0]>1||v[1]||v[2]||v[3])return AYATSURI_MODEL_INVALID;
	cmpb	$0, 1(%rax)	#, MEM[(const uint8_t *)_297 + 1B]
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:132:             if(v[0]>1||v[1]||v[2]||v[3])return AYATSURI_MODEL_INVALID;
	cmpb	$0, 2(%rax)	#, MEM[(const uint8_t *)_297 + 2B]
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:132:             if(v[0]>1||v[1]||v[2]||v[3])return AYATSURI_MODEL_INVALID;
	cmpb	$0, 3(%rax)	#, MEM[(const uint8_t *)_297 + 3B]
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:130:         for(uint32_t j=0;j<candidate.section[12].count;j++){
	addl	$1, %edx	#, j
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:130:         for(uint32_t j=0;j<candidate.section[12].count;j++){
	addq	$4, %rax	#, ivtmp.533
	cmpl	%ecx, %edx	# _60, j
	jnb	.L243	#,
.L244:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:132:             if(v[0]>1||v[1]||v[2]||v[3])return AYATSURI_MODEL_INVALID;
	cmpb	$1, (%rax)	#, MEM[(const uint8_t *)_297]
	jbe	.L396	#,
	jmp	.L230	#
.L237:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:117:         }else if(flags&1)return AYATSURI_MODEL_INVALID;
	testw	%di, %di	# load_dst_1233
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:118:         else if(stride&&(uint64_t)count*stride>length)return AYATSURI_MODEL_INVALID;
	testl	%eax, %eax	# _324
	je	.L238	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:118:         else if(stride&&(uint64_t)count*stride>length)return AYATSURI_MODEL_INVALID;
	movd	%xmm0, %ecx	# _338, _34
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:118:         else if(stride&&(uint64_t)count*stride>length)return AYATSURI_MODEL_INVALID;
	imulq	%rcx, %rax	# _34, _36
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:118:         else if(stride&&(uint64_t)count*stride>length)return AYATSURI_MODEL_INVALID;
	cmpq	%rax, %r10	# _36, _17
	jnb	.L238	#,
	jmp	.L230	#
.L243:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:54:     for(uint32_t k=0;k<m->section[9].count;k++){
	movl	240(%rsp), %eax	# candidate.section[9].count, _818
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	236(%rsp), %r8d	# candidate.section[9].offset, _783
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:54:     for(uint32_t k=0;k<m->section[9].count;k++){
	xorl	%edx, %edx	# k
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:135:     candidate.node_count=(uint16_t)count;
	movw	%r13w, 156(%rsp)	# count, candidate.node_count
	movss	.LC1(%rip), %xmm4	#, tmp1027
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:60:         if(fabs(length-1)>1e-4)return false;
	movq	.LC8(%rip), %xmm3	#, tmp1029
	movss	.LC0(%rip), %xmm5	#, tmp1026
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:54:     for(uint32_t k=0;k<m->section[9].count;k++){
	movl	%eax, 24(%rsp)	# _818, %sfp
.L245:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:54:     for(uint32_t k=0;k<m->section[9].count;k++){
	movl	24(%rsp), %eax	# %sfp, _818
	cmpl	%eax, %edx	# _818, k
	je	.L397	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	imull	$28, %edx, %ecx	#, k,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	xorl	%eax, %eax	# ivtmp.515
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:55:         const uint8_t *v=row(m,10,k,28);double length=0;
	pxor	%xmm0, %xmm0	# length
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%r8, %rcx	# _783, _787
	addq	%rbx, %rcx	# data, _287
.L249:
	movss	(%rcx,%rax,4), %xmm1	# MEM <unsigned int> [(const uint8_t *)_287 + ivtmp.515_285 * 4], _807
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:57:             const float x=mf(v+4*j);if(!isfinite(x)||fabsf(x)>4096)return false;
	movaps	%xmm1, %xmm2	# _807, _808
	andps	%xmm5, %xmm2	# tmp1026, _808
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:57:             const float x=mf(v+4*j);if(!isfinite(x)||fabsf(x)>4096)return false;
	ucomiss	%xmm2, %xmm4	# _808, tmp1027
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:57:             const float x=mf(v+4*j);if(!isfinite(x)||fabsf(x)>4096)return false;
	comiss	.LC3(%rip), %xmm2	#, _808
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:58:             if(j>=3&&j<6)length+=(double)x*x;
	leal	-3(%rax), %esi	#, _290
	cmpl	$2, %esi	#, _290
	jbe	.L398	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:56:         for(unsigned j=0;j<7;j++){
	addq	$1, %rax	#, ivtmp.515
	cmpq	$7, %rax	#, ivtmp.515
	jne	.L249	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:60:         if(fabs(length-1)>1e-4)return false;
	subsd	.LC9(%rip), %xmm0	#, _815
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:60:         if(fabs(length-1)>1e-4)return false;
	andpd	%xmm3, %xmm0	# tmp1029, _816
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:60:         if(fabs(length-1)>1e-4)return false;
	comisd	.LC29(%rip), %xmm0	#, _816
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:54:     for(uint32_t k=0;k<m->section[9].count;k++){
	addl	$1, %edx	#, k
	jmp	.L245	#
.L397:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:62:     for(uint32_t k=0;k<m->section[10].count;k++)for(unsigned j=0;j<3;j++)
	movl	248(%rsp), %eax	# candidate.section[10].count, _840
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:62:     for(uint32_t k=0;k<m->section[10].count;k++)for(unsigned j=0;j<3;j++)
	xorl	%edx, %edx	# k
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:62:     for(uint32_t k=0;k<m->section[10].count;k++)for(unsigned j=0;j<3;j++)
	movl	%eax, 40(%rsp)	# _840, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	244(%rsp), %eax	# candidate.section[10].offset, _821
	movq	%rax, 32(%rsp)	# _821, %sfp
.L251:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:62:     for(uint32_t k=0;k<m->section[10].count;k++)for(unsigned j=0;j<3;j++)
	movl	40(%rsp), %eax	# %sfp, _840
	cmpl	%eax, %edx	# _840, k
	je	.L399	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	imull	$6, %edx, %eax	#, k,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	32(%rsp), %rcx	# %sfp, _821
	addq	%rcx, %rax	# _821, _825
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:63:         if(m16(row(m,11,k,6)+2*j)>=32)return false;
	cmpw	$31, (%rbx,%rax)	#, MEM <short unsigned int> [(const uint8_t *)_240]
	ja	.L230	#,
	cmpw	$31, 2(%rbx,%rax)	#, MEM <short unsigned int> [(const uint8_t *)_225]
	ja	.L230	#,
	cmpw	$31, 4(%rbx,%rax)	#, MEM <short unsigned int> [(const uint8_t *)_830]
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:62:     for(uint32_t k=0;k<m->section[10].count;k++)for(unsigned j=0;j<3;j++)
	addl	$1, %edx	#, k
	jmp	.L251	#
.L398:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:58:             if(j>=3&&j<6)length+=(double)x*x;
	cvtss2sd	%xmm1, %xmm1	# _807, _810
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:58:             if(j>=3&&j<6)length+=(double)x*x;
	mulsd	%xmm1, %xmm1	# _810, _811
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:56:         for(unsigned j=0;j<7;j++){
	addq	$1, %rax	#, ivtmp.515
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:58:             if(j>=3&&j<6)length+=(double)x*x;
	addsd	%xmm1, %xmm0	# _811, length
	jmp	.L249	#
.L399:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:64:     for(uint32_t k=0;k<m->section[11].count;k++)for(unsigned j=0;j<3;j++){
	movl	256(%rsp), %eax	# candidate.section[11].count, _871
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	252(%rsp), %esi	# candidate.section[11].offset, _843
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:64:     for(uint32_t k=0;k<m->section[11].count;k++)for(unsigned j=0;j<3;j++){
	xorl	%edx, %edx	# k
	movss	.LC0(%rip), %xmm2	#, tmp1024
	movss	.LC1(%rip), %xmm1	#, tmp1025
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:64:     for(uint32_t k=0;k<m->section[11].count;k++)for(unsigned j=0;j<3;j++){
	movl	%eax, 48(%rsp)	# _871, %sfp
.L253:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:64:     for(uint32_t k=0;k<m->section[11].count;k++)for(unsigned j=0;j<3;j++){
	movl	48(%rsp), %eax	# %sfp, _871
	cmpl	%eax, %edx	# _871, k
	je	.L400	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	imull	$12, %edx, %eax	#, k,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	xorl	%ecx, %ecx	# ivtmp.496
	addq	%rsi, %rax	# _843, _847
	addq	%rbx, %rax	# data, _273
.L254:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:65:         const float x=mf(row(m,12,k,12)+4*j);if(!isfinite(x)||fabsf(x)>4096)return false;
	movss	(%rax,%rcx,4), %xmm0	# MEM <unsigned int> [(const uint8_t *)_273 + ivtmp.496_175 * 4], _868
	andps	%xmm2, %xmm0	# tmp1024, _868
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:65:         const float x=mf(row(m,12,k,12)+4*j);if(!isfinite(x)||fabsf(x)>4096)return false;
	ucomiss	%xmm0, %xmm1	# _868, tmp1025
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:65:         const float x=mf(row(m,12,k,12)+4*j);if(!isfinite(x)||fabsf(x)>4096)return false;
	comiss	.LC3(%rip), %xmm0	#, _868
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:64:     for(uint32_t k=0;k<m->section[11].count;k++)for(unsigned j=0;j<3;j++){
	addq	$1, %rcx	#, ivtmp.496
	cmpq	$3, %rcx	#, ivtmp.496
	jne	.L254	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:64:     for(uint32_t k=0;k<m->section[11].count;k++)for(unsigned j=0;j<3;j++){
	addl	$1, %edx	#, k
	jmp	.L253	#
.L400:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:67:     for(uint32_t k=0;k<m->section[8].count;k++){
	movl	232(%rsp), %eax	# candidate.section[8].count, _102
	movq	%rbp, 72(%rsp)	# out, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:67:     for(uint32_t k=0;k<m->section[8].count;k++){
	xorl	%edx, %edx	# k
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:86:             if(x==0&&y==0&&z==0)return false;
	pxor	%xmm6, %xmm6	# tmp1022
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:67:     for(uint32_t k=0;k<m->section[8].count;k++){
	movl	%eax, 60(%rsp)	# _102, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	228(%rsp), %eax	# candidate.section[8].offset, _874
	movq	%rax, 64(%rsp)	# _874, %sfp
.L256:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:67:     for(uint32_t k=0;k<m->section[8].count;k++){
	movl	60(%rsp), %eax	# %sfp, _102
	cmpl	%eax, %edx	# _102, k
	je	.L401	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	64(%rsp), %rcx	# %sfp, _874
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	%edx, %eax	# k, _176
	sall	$5, %eax	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rcx, %rax	# _874, _878
	addq	%rbx, %rax	# data, _879
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:68:         const uint8_t *d=row(m,9,k,32);const unsigned first=m16(d),nv=m16(d+2),tri=m16(d+4),nt=m16(d+6),hole=m16(d+8);
	movzwl	2(%rax), %r10d	# MEM <short unsigned int> [(const uint8_t *)_879 + 2B], nv
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:68:         const uint8_t *d=row(m,9,k,32);const unsigned first=m16(d),nv=m16(d+2),tri=m16(d+4),nt=m16(d+6),hole=m16(d+8);
	movzwl	(%rax), %r9d	# MEM <short unsigned int> [(const uint8_t *)_879], first
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:68:         const uint8_t *d=row(m,9,k,32);const unsigned first=m16(d),nv=m16(d+2),tri=m16(d+4),nt=m16(d+6),hole=m16(d+8);
	movzwl	4(%rax), %ecx	# MEM <short unsigned int> [(const uint8_t *)_879 + 4B], tri
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:68:         const uint8_t *d=row(m,9,k,32);const unsigned first=m16(d),nv=m16(d+2),tri=m16(d+4),nt=m16(d+6),hole=m16(d+8);
	movzwl	6(%rax), %r11d	# MEM <short unsigned int> [(const uint8_t *)_879 + 6B], nt
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:69:         if(nv<3||nv>32||!nt||nt>64||d[10]>2||d[11]>1||
	leal	-3(%r10), %esi	#, _920
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:68:         const uint8_t *d=row(m,9,k,32);const unsigned first=m16(d),nv=m16(d+2),tri=m16(d+4),nt=m16(d+6),hole=m16(d+8);
	movzwl	8(%rax), %ebp	# MEM <short unsigned int> [(const uint8_t *)_879 + 8B], hole
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:69:         if(nv<3||nv>32||!nt||nt>64||d[10]>2||d[11]>1||
	cmpl	$29, %esi	#, _920
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:69:         if(nv<3||nv>32||!nt||nt>64||d[10]>2||d[11]>1||
	leal	-1(%r11), %esi	#, _921
	cmpl	$63, %esi	#, _921
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:69:         if(nv<3||nv>32||!nt||nt>64||d[10]>2||d[11]>1||
	movzbl	10(%rax), %edi	# MEM[(const uint8_t *)_879 + 10B], _922
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:69:         if(nv<3||nv>32||!nt||nt>64||d[10]>2||d[11]>1||
	cmpb	$2, %dil	#, _922
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:69:         if(nv<3||nv>32||!nt||nt>64||d[10]>2||d[11]>1||
	cmpb	$1, 11(%rax)	#, MEM[(const uint8_t *)_879 + 11B]
	ja	.L230	#,
	movl	24(%rsp), %esi	# %sfp, _818
	cmpl	%r9d, %esi	# first, _818
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:70:            first>m->section[9].count||nv>m->section[9].count-first||
	subl	%r9d, %esi	# first, _924
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:70:            first>m->section[9].count||nv>m->section[9].count-first||
	cmpl	%r10d, %esi	# nv, _924
	jb	.L230	#,
	movl	40(%rsp), %esi	# %sfp, _840
	cmpl	%ecx, %esi	# tri, _840
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:71:            tri>m->section[10].count||nt>m->section[10].count-tri)return false;
	subl	%ecx, %esi	# tri, _925
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:71:            tri>m->section[10].count||nt>m->section[10].count-tri)return false;
	cmpl	%r11d, %esi	# nt, _925
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:75:             else if(d[12+j])return false;
	movzbl	12(%rax), %esi	# MEM[(const uint8_t *)_879 + 12B],
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:74:             if(j<d[10]){if(d[12+j]<3||d[12+j]>8)return false;holes+=d[12+j];}
	testb	%dil, %dil	# _922
	jne	.L257	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:75:             else if(d[12+j])return false;
	testb	%sil, %sil	# pretmp_1941
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:72:         unsigned holes=0;
	xorl	%esi, %esi	# holes
.L258:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:75:             else if(d[12+j])return false;
	cmpb	$0, 13(%rax)	#, MEM[(const uint8_t *)_879 + 13B]
	jne	.L230	#,
.L260:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:77:         if(hole>m->section[11].count||holes>m->section[11].count-hole)return false;
	movl	48(%rsp), %edi	# %sfp, _871
	cmpl	%ebp, %edi	# hole, _871
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:77:         if(hole>m->section[11].count||holes>m->section[11].count-hole)return false;
	subl	%ebp, %edi	# hole, _941
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:77:         if(hole>m->section[11].count||holes>m->section[11].count-hole)return false;
	cmpl	%esi, %edi	# holes, _941
	jb	.L230	#,
	movl	$19, %esi	#, ivtmp.485
.L261:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:78:         for(unsigned j=19;j<32;j++)if(d[j])return false;
	cmpb	$0, (%rax,%rsi)	#, MEM[(const uint8_t *)_879 + ivtmp.485_177 * 1]
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:78:         for(unsigned j=19;j<32;j++)if(d[j])return false;
	addq	$1, %rsi	#, ivtmp.485
	cmpq	$32, %rsi	#, ivtmp.485
	jne	.L261	#,
	imull	$6, %ecx, %edi	#, tri,
	movq	32(%rsp), %rax	# %sfp, _821
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:79:         for(unsigned j=0;j<nt;j++){
	xorl	%ebp, %ebp	# j
	addq	%rax, %rdi	# _821, _183
	addq	%rbx, %rdi	# data, ivtmp.480
.L263:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:80:             const uint8_t *t=row(m,11,tri+j,6);const unsigned a=m16(t),b=m16(t+2),c=m16(t+4);
	movzwl	(%rdi), %ecx	# MEM <short unsigned int> [(const uint8_t *)_181], a
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:80:             const uint8_t *t=row(m,11,tri+j,6);const unsigned a=m16(t),b=m16(t+2),c=m16(t+4);
	movzwl	2(%rdi), %eax	# MEM <short unsigned int> [(const uint8_t *)_181 + 2B], b
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:80:             const uint8_t *t=row(m,11,tri+j,6);const unsigned a=m16(t),b=m16(t+2),c=m16(t+4);
	movzwl	4(%rdi), %esi	# MEM <short unsigned int> [(const uint8_t *)_181 + 4B], c
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:81:             if(a>=nv||b>=nv||c>=nv||a==b||a==c||b==c)return false;
	cmpl	%eax, %ecx	# b, a
	movl	%eax, %r15d	# b, _979
	cmovnb	%ecx, %r15d	# a,, _979
	cmpl	%r10d, %r15d	# nv, _979
	jnb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:81:             if(a>=nv||b>=nv||c>=nv||a==b||a==c||b==c)return false;
	cmpl	%r10d, %esi	# nv, c
	jnb	.L230	#,
	cmpl	%eax, %ecx	# b, a
	je	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:81:             if(a>=nv||b>=nv||c>=nv||a==b||a==c||b==c)return false;
	cmpl	%esi, %ecx	# c, a
	je	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:81:             if(a>=nv||b>=nv||c>=nv||a==b||a==c||b==c)return false;
	cmpl	%esi, %eax	# c, b
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:81:             if(a>=nv||b>=nv||c>=nv||a==b||a==c||b==c)return false;
	sete	%r15b	#, _984
	je	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:82:             const uint8_t *va=row(m,10,first+a,28),*vb=row(m,10,first+b,28),*vc=row(m,10,first+c,28);
	addl	%r9d, %ecx	# first, _986
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:82:             const uint8_t *va=row(m,10,first+a,28),*vb=row(m,10,first+b,28),*vc=row(m,10,first+c,28);
	addl	%r9d, %eax	# first, _993
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:83:             const double ux=(double)mf(vb)-mf(va),uy=(double)mf(vb+4)-mf(va+4),uz=(double)mf(vb+8)-mf(va+8),
	pxor	%xmm5, %xmm5	# _1034
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:82:             const uint8_t *va=row(m,10,first+a,28),*vb=row(m,10,first+b,28),*vc=row(m,10,first+c,28);
	addl	%r9d, %esi	# first, _998
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	imull	$28, %ecx, %ecx	#, _986,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:83:             const double ux=(double)mf(vb)-mf(va),uy=(double)mf(vb+4)-mf(va+4),uz=(double)mf(vb+8)-mf(va+8),
	pxor	%xmm0, %xmm0	# _1018
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:84:                 vx=(double)mf(vc)-mf(va),vy=(double)mf(vc+4)-mf(va+4),vz=(double)mf(vc+8)-mf(va+8),
	pxor	%xmm4, %xmm4	# _1117
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	imull	$28, %eax, %eax	#, _993,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:83:             const double ux=(double)mf(vb)-mf(va),uy=(double)mf(vb+4)-mf(va+4),uz=(double)mf(vb+8)-mf(va+8),
	pxor	%xmm3, %xmm3	# _1067
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:83:             const double ux=(double)mf(vb)-mf(va),uy=(double)mf(vb+4)-mf(va+4),uz=(double)mf(vb+8)-mf(va+8),
	pxor	%xmm2, %xmm2	# _1051
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	imull	$28, %esi, %esi	#, _998,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:83:             const double ux=(double)mf(vb)-mf(va),uy=(double)mf(vb+4)-mf(va+4),uz=(double)mf(vb+8)-mf(va+8),
	pxor	%xmm7, %xmm7	# _1100
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:83:             const double ux=(double)mf(vb)-mf(va),uy=(double)mf(vb+4)-mf(va+4),uz=(double)mf(vb+8)-mf(va+8),
	pxor	%xmm1, %xmm1	# _1084
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%r8, %rcx	# _783, _991
	addq	%r8, %rax	# _783, _996
	addq	%rbx, %rcx	# data, _992
	addq	%r8, %rsi	# _783, _1001
	addq	%rbx, %rax	# data, _997
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:83:             const double ux=(double)mf(vb)-mf(va),uy=(double)mf(vb+4)-mf(va+4),uz=(double)mf(vb+8)-mf(va+8),
	cvtss2sd	(%rcx), %xmm5	# MEM <unsigned int> [(const uint8_t *)_992], _1034
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:83:             const double ux=(double)mf(vb)-mf(va),uy=(double)mf(vb+4)-mf(va+4),uz=(double)mf(vb+8)-mf(va+8),
	cvtss2sd	4(%rcx), %xmm3	# MEM <unsigned int> [(const uint8_t *)_992 + 4B], _1067
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rbx, %rsi	# data, _1002
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:83:             const double ux=(double)mf(vb)-mf(va),uy=(double)mf(vb+4)-mf(va+4),uz=(double)mf(vb+8)-mf(va+8),
	cvtss2sd	(%rax), %xmm0	# MEM <unsigned int> [(const uint8_t *)_997], _1018
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:83:             const double ux=(double)mf(vb)-mf(va),uy=(double)mf(vb+4)-mf(va+4),uz=(double)mf(vb+8)-mf(va+8),
	subsd	%xmm5, %xmm0	# _1034, ux
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:83:             const double ux=(double)mf(vb)-mf(va),uy=(double)mf(vb+4)-mf(va+4),uz=(double)mf(vb+8)-mf(va+8),
	cvtss2sd	8(%rcx), %xmm7	# MEM <unsigned int> [(const uint8_t *)_992 + 8B], _1100
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:84:                 vx=(double)mf(vc)-mf(va),vy=(double)mf(vc+4)-mf(va+4),vz=(double)mf(vc+8)-mf(va+8),
	cvtss2sd	(%rsi), %xmm4	# MEM <unsigned int> [(const uint8_t *)_1002], _1117
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:84:                 vx=(double)mf(vc)-mf(va),vy=(double)mf(vc+4)-mf(va+4),vz=(double)mf(vc+8)-mf(va+8),
	subsd	%xmm5, %xmm4	# _1034, vx
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:84:                 vx=(double)mf(vc)-mf(va),vy=(double)mf(vc+4)-mf(va+4),vz=(double)mf(vc+8)-mf(va+8),
	pxor	%xmm5, %xmm5	# _1134
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:83:             const double ux=(double)mf(vb)-mf(va),uy=(double)mf(vb+4)-mf(va+4),uz=(double)mf(vb+8)-mf(va+8),
	cvtss2sd	4(%rax), %xmm2	# MEM <unsigned int> [(const uint8_t *)_997 + 4B], _1051
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:83:             const double ux=(double)mf(vb)-mf(va),uy=(double)mf(vb+4)-mf(va+4),uz=(double)mf(vb+8)-mf(va+8),
	cvtss2sd	8(%rax), %xmm1	# MEM <unsigned int> [(const uint8_t *)_997 + 8B], _1084
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:83:             const double ux=(double)mf(vb)-mf(va),uy=(double)mf(vb+4)-mf(va+4),uz=(double)mf(vb+8)-mf(va+8),
	subsd	%xmm3, %xmm2	# _1067, uy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:83:             const double ux=(double)mf(vb)-mf(va),uy=(double)mf(vb+4)-mf(va+4),uz=(double)mf(vb+8)-mf(va+8),
	subsd	%xmm7, %xmm1	# _1100, uz
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:84:                 vx=(double)mf(vc)-mf(va),vy=(double)mf(vc+4)-mf(va+4),vz=(double)mf(vc+8)-mf(va+8),
	cvtss2sd	4(%rsi), %xmm5	# MEM <unsigned int> [(const uint8_t *)_1002 + 4B], _1134
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:84:                 vx=(double)mf(vc)-mf(va),vy=(double)mf(vc+4)-mf(va+4),vz=(double)mf(vc+8)-mf(va+8),
	subsd	%xmm3, %xmm5	# _1067, vy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:84:                 vx=(double)mf(vc)-mf(va),vy=(double)mf(vc+4)-mf(va+4),vz=(double)mf(vc+8)-mf(va+8),
	pxor	%xmm3, %xmm3	# _1151
	cvtss2sd	8(%rsi), %xmm3	# MEM <unsigned int> [(const uint8_t *)_1002 + 8B], _1151
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:84:                 vx=(double)mf(vc)-mf(va),vy=(double)mf(vc+4)-mf(va+4),vz=(double)mf(vc+8)-mf(va+8),
	subsd	%xmm7, %xmm3	# _1100, vz
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:85:                 x=uy*vz-uz*vy,y=uz*vx-ux*vz,z=ux*vy-uy*vx;
	movapd	%xmm1, %xmm8	# uz, _1154
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:85:                 x=uy*vz-uz*vy,y=uz*vx-ux*vz,z=ux*vy-uy*vx;
	movapd	%xmm2, %xmm7	# uy, _1153
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:85:                 x=uy*vz-uz*vy,y=uz*vx-ux*vz,z=ux*vy-uy*vx;
	mulsd	%xmm5, %xmm8	# vy, _1154
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:85:                 x=uy*vz-uz*vy,y=uz*vx-ux*vz,z=ux*vy-uy*vx;
	mulsd	%xmm3, %xmm7	# vz, _1153
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:85:                 x=uy*vz-uz*vy,y=uz*vx-ux*vz,z=ux*vy-uy*vx;
	mulsd	%xmm4, %xmm1	# vx, _1156
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:85:                 x=uy*vz-uz*vy,y=uz*vx-ux*vz,z=ux*vy-uy*vx;
	mulsd	%xmm0, %xmm3	# ux, _1157
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:85:                 x=uy*vz-uz*vy,y=uz*vx-ux*vz,z=ux*vy-uy*vx;
	subsd	%xmm8, %xmm7	# _1154, x_1155
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:85:                 x=uy*vz-uz*vy,y=uz*vx-ux*vz,z=ux*vy-uy*vx;
	subsd	%xmm3, %xmm1	# _1157, y_1158
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:86:             if(x==0&&y==0&&z==0)return false;
	ucomisd	%xmm6, %xmm7	# tmp1022, x_1155
	setnp	%al	#, tmp749
	cmovne	%r15d, %eax	# tmp749,, _984, _1262
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:86:             if(x==0&&y==0&&z==0)return false;
	ucomisd	%xmm6, %xmm1	# tmp1022, y_1158
	setnp	%cl	#, tmp760
	cmovne	%r15d, %ecx	# tmp760,, _984, _1263
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:86:             if(x==0&&y==0&&z==0)return false;
	testb	%cl, %al	# _1263, _1262
	je	.L320	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:85:                 x=uy*vz-uz*vy,y=uz*vx-ux*vz,z=ux*vy-uy*vx;
	mulsd	%xmm5, %xmm0	# vy, _1159
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:85:                 x=uy*vz-uz*vy,y=uz*vx-ux*vz,z=ux*vy-uy*vx;
	mulsd	%xmm4, %xmm2	# vx, _1160
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:85:                 x=uy*vz-uz*vy,y=uz*vx-ux*vz,z=ux*vy-uy*vx;
	subsd	%xmm2, %xmm0	# _1160, z_1161
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:86:             if(x==0&&y==0&&z==0)return false;
	ucomisd	%xmm6, %xmm0	# tmp1022, z_1161
	setnp	%al	#, tmp772
	cmovne	%r15d, %eax	# tmp772,, _984, _1253
	testb	%al, %al	# _1253
	jne	.L230	#,
.L320:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:79:         for(unsigned j=0;j<nt;j++){
	addl	$1, %ebp	#, j
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:79:         for(unsigned j=0;j<nt;j++){
	addq	$6, %rdi	#, ivtmp.480
	cmpl	%r11d, %ebp	# nt, j
	jb	.L263	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:67:     for(uint32_t k=0;k<m->section[8].count;k++){
	addl	$1, %edx	#, k
	jmp	.L256	#
.L257:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:74:             if(j<d[10]){if(d[12+j]<3||d[12+j]>8)return false;holes+=d[12+j];}
	leal	-3(%rsi), %r15d	#, _1177
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:74:             if(j<d[10]){if(d[12+j]<3||d[12+j]>8)return false;holes+=d[12+j];}
	cmpb	$5, %r15b	#, _1177
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:74:             if(j<d[10]){if(d[12+j]<3||d[12+j]>8)return false;holes+=d[12+j];}
	movzbl	13(%rax), %r15d	# MEM[(const uint8_t *)_879 + 13B],
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:74:             if(j<d[10]){if(d[12+j]<3||d[12+j]>8)return false;holes+=d[12+j];}
	cmpb	$2, %dil	#, _922
	jne	.L258	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:74:             if(j<d[10]){if(d[12+j]<3||d[12+j]>8)return false;holes+=d[12+j];}
	leal	-3(%r15), %edi	#, _1193
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:74:             if(j<d[10]){if(d[12+j]<3||d[12+j]>8)return false;holes+=d[12+j];}
	cmpb	$5, %dil	#, _1193
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:74:             if(j<d[10]){if(d[12+j]<3||d[12+j]>8)return false;holes+=d[12+j];}
	addl	%r15d, %esi	# _1194, holes
	jmp	.L260	#
.L401:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	212(%rsp), %eax	# candidate.section[6].offset, _416
	movq	72(%rsp), %rbp	# %sfp, out
	movq	%rax, %rcx	# _416, _416
	movq	%rax, 24(%rsp)	# _416, %sfp
	xorl	%eax, %eax	# ivtmp.471
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:137:     for(uint32_t k=0;k<candidate.section[6].count;++k){const uint8_t c=*row(&candidate,7,k,1);
	addq	%rbx, %rcx	# data, _277
	jmp	.L317	#
	.p2align 5
.L266:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:138:         if(c<32||c>126)return AYATSURI_MODEL_INVALID;}
	movzbl	(%rcx,%rax), %edi	# MEM[(const uint8_t *)_277 + ivtmp.471_194 * 1], tmp1301
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:138:         if(c<32||c>126)return AYATSURI_MODEL_INVALID;}
	addq	$1, %rax	#, ivtmp.471
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:138:         if(c<32||c>126)return AYATSURI_MODEL_INVALID;}
	leal	-32(%rdi), %edx	#, _67
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:138:         if(c<32||c>126)return AYATSURI_MODEL_INVALID;}
	cmpb	$94, %dl	#, _67
	ja	.L230	#,
.L317:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:137:     for(uint32_t k=0;k<candidate.section[6].count;++k){const uint8_t c=*row(&candidate,7,k,1);
	cmpl	%r14d, %eax	# _48, ivtmp.471
	jb	.L266	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	172(%rsp), %eax	# candidate.section[1].offset, _421
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:139:     if(!float_rows_valid(row(&candidate,2,0,36),count,9,9)||
	movl	$9, %ecx	#,
	movl	$9, %edx	#,
	movl	%r13d, %esi	# count,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rbx, %rax	# data, ivtmp.437
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:139:     if(!float_rows_valid(row(&candidate,2,0,36),count,9,9)||
	movq	%rax, %rdi	# ivtmp.437,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	%rax, 40(%rsp)	# ivtmp.437, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:139:     if(!float_rows_valid(row(&candidate,2,0,36),count,9,9)||
	call	float_rows_valid	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:139:     if(!float_rows_valid(row(&candidate,2,0,36),count,9,9)||
	testb	%al, %al	# tmp1034
	je	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	180(%rsp), %edi	# candidate.section[2].offset, _424
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:140:        !float_rows_valid(row(&candidate,3,0,12),candidate.section[2].count,3,0)||
	movl	12(%rsp), %esi	# %sfp,
	xorl	%ecx, %ecx	#
	movl	$3, %edx	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rbx, %rdi	# data, _425
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:140:        !float_rows_valid(row(&candidate,3,0,12),candidate.section[2].count,3,0)||
	call	float_rows_valid	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:139:     if(!float_rows_valid(row(&candidate,2,0,36),count,9,9)||
	testb	%al, %al	# tmp1035
	je	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	188(%rsp), %edi	# candidate.section[3].offset, _427
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:141:        !float_rows_valid(row(&candidate,4,0,24),candidate.section[3].count,6,3))return AYATSURI_MODEL_INVALID;
	movl	16(%rsp), %esi	# %sfp,
	movl	$3, %ecx	#,
	movl	$6, %edx	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rbx, %rdi	# data, _428
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:141:        !float_rows_valid(row(&candidate,4,0,24),candidate.section[3].count,6,3))return AYATSURI_MODEL_INVALID;
	call	float_rows_valid	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:140:        !float_rows_valid(row(&candidate,3,0,12),candidate.section[2].count,3,0)||
	testb	%al, %al	# _70
	je	.L230	#,
	movl	8(%rsp), %ecx	# %sfp, _256
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	196(%rsp), %edi	# candidate.section[4].offset, _430
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	movq	.LC8(%rip), %xmm2	#, tmp1016
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	movsd	.LC22(%rip), %xmm1	#, tmp1017
	imulq	$72, %rcx, %rcx	#, _256, _255
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	%rdi, 72(%rsp)	# _430, %sfp
	leaq	(%rbx,%rdi), %rdx	#, ivtmp.455
	addq	%rdi, %rcx	# _430, _1278
	addq	%rbx, %rcx	# data, _246
.L267:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:142:     for(uint32_t i=0;i<candidate.section[4].count;++i){
	cmpq	%rcx, %rdx	# _246, ivtmp.455
	je	.L402	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	xorl	%esi, %esi	# ivtmp.441
.L273:
	movss	(%rdx,%rsi,4), %xmm0	# MEM <unsigned int> [(const uint8_t *)_434 + ivtmp.441_217 * 4], _449
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:146:             if(k==3){if(!isfinite(value)||value<1||value>128)return AYATSURI_MODEL_INVALID;}
	cmpq	$3, %rsi	#, ivtmp.441
	je	.L403	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:147:             else if(!unit(value))return AYATSURI_MODEL_INVALID;
	pxor	%xmm3, %xmm3	# _75
	cvtss2sd	%xmm0, %xmm3	# _449, _75
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	andpd	%xmm2, %xmm3	# tmp1016, _450
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	ucomisd	%xmm3, %xmm1	# _450, tmp1017
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	pxor	%xmm3, %xmm3	# tmp795
	comiss	%xmm3, %xmm0	# tmp795, _449
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	movss	.LC15(%rip), %xmm3	#, tmp796
	comiss	%xmm0, %xmm3	# _449, tmp796
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:144:         for(unsigned k=0;k<11;++k){
	addq	$1, %rsi	#, ivtmp.441
	cmpq	$11, %rsi	#, ivtmp.441
	jne	.L273	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:149:         if(m32(material+44)>0xffffff||!unit(md(material+48))||!unit(md(material+56))||!unit(md(material+64)))
	cmpl	$16777215, 44(%rdx)	#, MEM <unsigned int> [(const uint8_t *)_434 + 44B]
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:149:         if(m32(material+44)>0xffffff||!unit(md(material+48))||!unit(md(material+56))||!unit(md(material+64)))
	leaq	48(%rdx), %rdi	#, _196
	call	md	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	movapd	%xmm0, %xmm3	# _77, _465
	andpd	%xmm2, %xmm3	# tmp1016, _465
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	ucomisd	%xmm3, %xmm1	# _465, tmp1017
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	pxor	%xmm3, %xmm3	# tmp801
	comisd	%xmm3, %xmm0	# tmp801, _77
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	movsd	.LC9(%rip), %xmm3	#, tmp990
	comisd	%xmm0, %xmm3	# _77, tmp990
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:149:         if(m32(material+44)>0xffffff||!unit(md(material+48))||!unit(md(material+56))||!unit(md(material+64)))
	leaq	56(%rdx), %rdi	#, _197
	call	md	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	movapd	%xmm0, %xmm4	# _79, _466
	andpd	%xmm2, %xmm4	# tmp1016, _466
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	ucomisd	%xmm4, %xmm1	# _466, tmp1017
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	pxor	%xmm4, %xmm4	# tmp807
	comisd	%xmm4, %xmm0	# tmp807, _79
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	comisd	%xmm0, %xmm3	# _79, tmp990
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:149:         if(m32(material+44)>0xffffff||!unit(md(material+48))||!unit(md(material+56))||!unit(md(material+64)))
	leaq	64(%rdx), %rdi	#, _199
	call	md	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	movapd	%xmm0, %xmm5	# _81, _467
	andpd	%xmm2, %xmm5	# tmp1016, _467
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	ucomisd	%xmm5, %xmm1	# _467, tmp1017
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	comisd	%xmm4, %xmm0	# tmp807, _81
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	addq	$72, %rdx	#, ivtmp.455
	comisd	%xmm0, %xmm3	# _81, tmp990
	jb	.L230	#,
	jmp	.L267	#
.L402:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:161:             if(n[2]!=3&&candidate.section[12].count&&row(&candidate,13,material,4)[0])return AYATSURI_MODEL_INVALID;
	movl	264(%rsp), %edi	# candidate.section[12].count, _94
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	164(%rsp), %ecx	# candidate.section[0].offset, _526
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:181:         candidate.slot_bytes+=n[2]==3?node_slot_bytes(&candidate,i,n):slot_bytes(n);
	movb	%al, 99(%rsp)	# _70, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:152:     for(uint32_t i=0;i<count;++i){
	xorl	%r10d, %r10d	# i
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	260(%rsp), %edx	# candidate.section[12].offset, _547
	movq	40(%rsp), %r11	# %sfp, ivtmp.437
	addq	%rbx, %rcx	# data, tmp983
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:161:             if(n[2]!=3&&candidate.section[12].count&&row(&candidate,13,material,4)[0])return AYATSURI_MODEL_INVALID;
	movl	%edi, 64(%rsp)	# _94, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	204(%rsp), %edi	# candidate.section[5].offset, _587
	movq	%rcx, 48(%rsp)	# tmp983, %sfp
	movq	%rcx, %r15	# tmp983, ivtmp.434
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:161:             if(n[2]!=3&&candidate.section[12].count&&row(&candidate,13,material,4)[0])return AYATSURI_MODEL_INVALID;
	leaq	(%rbx,%rdx), %rcx	#, tmp1012
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:181:         candidate.slot_bytes+=n[2]==3?node_slot_bytes(&candidate,i,n):slot_bytes(n);
	xchgq	%r11, %rbp	# ivtmp.437, out
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:161:             if(n[2]!=3&&candidate.section[12].count&&row(&candidate,13,material,4)[0])return AYATSURI_MODEL_INVALID;
	movq	%rcx, 80(%rsp)	# tmp1012, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:181:         candidate.slot_bytes+=n[2]==3?node_slot_bytes(&candidate,i,n):slot_bytes(n);
	leaq	144(%rsp), %rcx	#, tmp1390
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	%rdi, 32(%rsp)	# _587, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:181:         candidate.slot_bytes+=n[2]==3?node_slot_bytes(&candidate,i,n):slot_bytes(n);
	movq	%rcx, 88(%rsp)	# tmp1390, %sfp
	movq	%rbx, %rcx	# data, data
	movl	%r10d, %ebx	# i, i
	movl	%r12d, %r10d	# <retval>, <retval>
	movq	%rcx, %r12	# data, data
.L302:
	movzwl	(%r15), %edx	# MEM <short unsigned int> [(const uint8_t *)_530], load_dst_250
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:16: static int parent_id(const uint8_t *p){const uint16_t x=m16(p);return x<=INT16_MAX?(int)x:(int)x-65536;}
	movl	%edx, %eax	# load_dst_250, iftmp.7_521
	orl	$-65536, %eax	#, iftmp.7_521
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:16: static int parent_id(const uint8_t *p){const uint16_t x=m16(p);return x<=INT16_MAX?(int)x:(int)x-65536;}
	testw	%dx, %dx	# load_dst_250
	js	.L282	#,
	movzwl	%dx, %eax	# load_dst_250, iftmp.7_521
.L282:
	movzwl	4(%r15), %esi	# MEM <short unsigned int> [(const uint8_t *)_530 + 4B],
	movzwl	6(%r15), %edi	# MEM <short unsigned int> [(const uint8_t *)_530 + 6B],
	movzwl	8(%r15), %edx	# MEM <short unsigned int> [(const uint8_t *)_530 + 8B],
	movzwl	10(%r15), %r8d	# MEM <short unsigned int> [(const uint8_t *)_530 + 10B],
	movss	12(%r15), %xmm0	# MEM <unsigned int> [(const uint8_t *)_530 + 12B], _482
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:156:         if(parent< -1||parent>=(int)i||n[2]>3||n[3]>1||binding>=count||!isfinite(blend))return AYATSURI_MODEL_INVALID;
	cmpl	$-1, %eax	#, iftmp.7_521
	jl	.L230	#,
	cmpl	%eax, %ebx	# iftmp.7_521, i
	jle	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:156:         if(parent< -1||parent>=(int)i||n[2]>3||n[3]>1||binding>=count||!isfinite(blend))return AYATSURI_MODEL_INVALID;
	movzbl	2(%r15), %eax	# MEM[(const uint8_t *)_530 + 2B], _86
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:156:         if(parent< -1||parent>=(int)i||n[2]>3||n[3]>1||binding>=count||!isfinite(blend))return AYATSURI_MODEL_INVALID;
	cmpb	$3, %al	#, _86
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:156:         if(parent< -1||parent>=(int)i||n[2]>3||n[3]>1||binding>=count||!isfinite(blend))return AYATSURI_MODEL_INVALID;
	cmpb	$1, 3(%r15)	#, MEM[(const uint8_t *)_530 + 3B]
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:156:         if(parent< -1||parent>=(int)i||n[2]>3||n[3]>1||binding>=count||!isfinite(blend))return AYATSURI_MODEL_INVALID;
	cmpl	%r13d, %r8d	# count, _88
	jnb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:156:         if(parent< -1||parent>=(int)i||n[2]>3||n[3]>1||binding>=count||!isfinite(blend))return AYATSURI_MODEL_INVALID;
	movss	.LC1(%rip), %xmm6	#, tmp1317
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:156:         if(parent< -1||parent>=(int)i||n[2]>3||n[3]>1||binding>=count||!isfinite(blend))return AYATSURI_MODEL_INVALID;
	movaps	%xmm0, %xmm1	# _482, _89
	andps	.LC0(%rip), %xmm1	#, _89
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:156:         if(parent< -1||parent>=(int)i||n[2]>3||n[3]>1||binding>=count||!isfinite(blend))return AYATSURI_MODEL_INVALID;
	ucomiss	%xmm1, %xmm6	# _89, tmp1317
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:157:         for(unsigned k=6;k<9;++k)if(mf(pose+4*k)==0)return AYATSURI_MODEL_INVALID;
	movss	24(%rbp), %xmm1	# MEM <unsigned int> [(const uint8_t *)_1276 + 24B], MEM <unsigned int> [(const uint8_t *)_1276 + 24B]
	pxor	%xmm6, %xmm6	# tmp1318
	ucomiss	%xmm6, %xmm1	# tmp1318, MEM <unsigned int> [(const uint8_t *)_1276 + 24B]
	jp	.L328	#,
	je	.L230	#,
.L328:
	movss	28(%rbp), %xmm1	# MEM <unsigned int> [(const uint8_t *)_1276 + 28B], MEM <unsigned int> [(const uint8_t *)_1276 + 28B]
	pxor	%xmm6, %xmm6	# tmp1319
	ucomiss	%xmm6, %xmm1	# tmp1319, MEM <unsigned int> [(const uint8_t *)_1276 + 28B]
	jp	.L329	#,
	je	.L230	#,
.L329:
	movss	32(%rbp), %xmm1	# MEM <unsigned int> [(const uint8_t *)_1276 + 32B], MEM <unsigned int> [(const uint8_t *)_1276 + 32B]
	pxor	%xmm6, %xmm6	# tmp1320
	ucomiss	%xmm6, %xmm1	# tmp1320, MEM <unsigned int> [(const uint8_t *)_1276 + 32B]
	jp	.L330	#,
	je	.L230	#,
.L330:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:158:         if(!n[2]){if(shape!=UINT16_MAX||material!=UINT16_MAX||lobes||blend!=0)return AYATSURI_MODEL_INVALID;}
	testb	%al, %al	# _86
	jne	.L286	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:158:         if(!n[2]){if(shape!=UINT16_MAX||material!=UINT16_MAX||lobes||blend!=0)return AYATSURI_MODEL_INVALID;}
	pxor	%xmm7, %xmm7	# tmp1321
	movl	$1, %ecx	#, tmp1322
	ucomiss	%xmm7, %xmm0	# tmp1321, _482
	setp	%r9b	#, tmp843
	cmovne	%ecx, %r9d	# tmp843,, tmp1322, _1248
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:158:         if(!n[2]){if(shape!=UINT16_MAX||material!=UINT16_MAX||lobes||blend!=0)return AYATSURI_MODEL_INVALID;}
	testw	%di, %di	# load_dst_288
	setne	%dil	#, _1251
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:158:         if(!n[2]){if(shape!=UINT16_MAX||material!=UINT16_MAX||lobes||blend!=0)return AYATSURI_MODEL_INVALID;}
	orb	%r9b, %dil	# _1248, tmp1056
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:158:         if(!n[2]){if(shape!=UINT16_MAX||material!=UINT16_MAX||lobes||blend!=0)return AYATSURI_MODEL_INVALID;}
	andl	%esi, %edx	# load_dst_302, _845
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:158:         if(!n[2]){if(shape!=UINT16_MAX||material!=UINT16_MAX||lobes||blend!=0)return AYATSURI_MODEL_INVALID;}
	addw	$1, %dx	#, _845
	jne	.L230	#,
.L287:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	32(%rsp), %rcx	# %sfp, _587
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	leal	0(,%r8,8), %edx	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rcx, %rdx	# _587, _590
	addq	%r12, %rdx	# data, _591
	movzwl	2(%rdx), %r8d	# MEM <short unsigned int> [(const uint8_t *)_591 + 2B], load_dst_344
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:15: static uint32_t m32(const uint8_t *p){return (uint32_t)p[0]|(uint32_t)p[1]<<8|(uint32_t)p[2]<<16|(uint32_t)p[3]<<24;}
	movl	4(%rdx), %edi	# MEM <unsigned int> [(const uint8_t *)_591 + 4B],
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:173:         if(m16(b)!=i||!length||length>127||start>candidate.section[6].count||length>candidate.section[6].count-start)
	movzwl	(%rdx), %edx	# MEM <short unsigned int> [(const uint8_t *)_591], _111
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:173:         if(m16(b)!=i||!length||length>127||start>candidate.section[6].count||length>candidate.section[6].count-start)
	cmpl	%ebx, %edx	# i, _111
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:173:         if(m16(b)!=i||!length||length>127||start>candidate.section[6].count||length>candidate.section[6].count-start)
	leal	-1(%r8), %edx	#, _112
	cmpw	$126, %dx	#, _112
	seta	%sil	#, _1235
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:173:         if(m16(b)!=i||!length||length>127||start>candidate.section[6].count||length>candidate.section[6].count-start)
	cmpl	%edi, %r14d	# _578, _48
	setb	%dl	#, _1236
	orb	%dl, %sil	# _1236, _1235
	movb	%sil, 40(%rsp)	# _1235, %sfp
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:173:         if(m16(b)!=i||!length||length>127||start>candidate.section[6].count||length>candidate.section[6].count-start)
	movl	%r14d, %esi	# _48, _114
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:173:         if(m16(b)!=i||!length||length>127||start>candidate.section[6].count||length>candidate.section[6].count-start)
	movzwl	%r8w, %edx	# load_dst_344, _113
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:173:         if(m16(b)!=i||!length||length>127||start>candidate.section[6].count||length>candidate.section[6].count-start)
	subl	%edi, %esi	# _578, _114
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:173:         if(m16(b)!=i||!length||length>127||start>candidate.section[6].count||length>candidate.section[6].count-start)
	cmpl	%edx, %esi	# _113, _114
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	24(%rsp), %rcx	# %sfp, _416
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:176:         for(unsigned k=0;k<length;++k)if(name[k]<32||name[k]>126)return AYATSURI_MODEL_INVALID;
	xorl	%esi, %esi	# ivtmp.425
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rcx, %rdi	# _416, _595
	addq	%r12, %rdi	# data, _596
.L295:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:176:         for(unsigned k=0;k<length;++k)if(name[k]<32||name[k]>126)return AYATSURI_MODEL_INVALID;
	cmpl	%edx, %esi	# _113, ivtmp.425
	jnb	.L404	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:176:         for(unsigned k=0;k<length;++k)if(name[k]<32||name[k]>126)return AYATSURI_MODEL_INVALID;
	movzbl	(%rdi,%rsi), %ecx	# MEM[(const uint8_t *)_596 + ivtmp.425_1186 * 1], tmp1341
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:176:         for(unsigned k=0;k<length;++k)if(name[k]<32||name[k]>126)return AYATSURI_MODEL_INVALID;
	addq	$1, %rsi	#, ivtmp.425
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:176:         for(unsigned k=0;k<length;++k)if(name[k]<32||name[k]>126)return AYATSURI_MODEL_INVALID;
	subl	$32, %ecx	#, _118
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:176:         for(unsigned k=0;k<length;++k)if(name[k]<32||name[k]>126)return AYATSURI_MODEL_INVALID;
	cmpb	$94, %cl	#, _118
	jbe	.L295	#,
	jmp	.L230	#
.L403:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:146:             if(k==3){if(!isfinite(value)||value<1||value>128)return AYATSURI_MODEL_INVALID;}
	movss	.LC1(%rip), %xmm4	#, tmp789
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:146:             if(k==3){if(!isfinite(value)||value<1||value>128)return AYATSURI_MODEL_INVALID;}
	movaps	%xmm0, %xmm3	# _449, _74
	andps	.LC0(%rip), %xmm3	#, _74
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:146:             if(k==3){if(!isfinite(value)||value<1||value>128)return AYATSURI_MODEL_INVALID;}
	ucomiss	%xmm3, %xmm4	# _74, tmp789
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:146:             if(k==3){if(!isfinite(value)||value<1||value>128)return AYATSURI_MODEL_INVALID;}
	movss	.LC15(%rip), %xmm3	#, tmp790
	comiss	%xmm0, %xmm3	# _449, tmp790
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:146:             if(k==3){if(!isfinite(value)||value<1||value>128)return AYATSURI_MODEL_INVALID;}
	comiss	.LC30(%rip), %xmm0	#, _449
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:144:         for(unsigned k=0;k<11;++k){
	movl	$4, %esi	#, ivtmp.441
	jmp	.L273	#
.L404:
	movq	48(%rsp), %r9	# %sfp, ivtmp.422
	movl	%r13d, 100(%rsp)	# count, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:179:             if(m16(prior+2)==length&&!memcmp(name,row(&candidate,7,m32(prior+4),1),length))return AYATSURI_MODEL_INVALID;
	movzwl	%r8w, %edx	# load_dst_344, _120
	movl	%eax, %r13d	# _86, _86
	movl	%ebx, 128(%rsp)	# i, %sfp
	movq	%rbp, 104(%rsp)	# ivtmp.437, %sfp
	movq	%r9, %rbx	# ivtmp.422, ivtmp.422
	movl	%r8d, %ebp	# load_dst_344, load_dst_344
.L297:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:177:         for(uint32_t j=0;j<i;++j){
	cmpq	%rbx, %r15	# ivtmp.422, ivtmp.434
	je	.L405	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:178:             const uint8_t *prior_node=row(&candidate,1,j,16),*prior=row(&candidate,6,m16(prior_node+10),8);
	movzwl	10(%rbx), %eax	# MEM <short unsigned int> [(const uint8_t *)_237 + 10B], _119
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	32(%rsp), %rcx	# %sfp, _587
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	sall	$3, %eax	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rcx, %rax	# _587, _606
	addq	%r12, %rax	# data, _607
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:179:             if(m16(prior+2)==length&&!memcmp(name,row(&candidate,7,m32(prior+4),1),length))return AYATSURI_MODEL_INVALID;
	cmpw	%bp, 2(%rax)	# load_dst_344, MEM <short unsigned int> [(const uint8_t *)_607 + 2B]
	je	.L406	#,
.L298:
	addq	$16, %rbx	#, ivtmp.422
	jmp	.L297	#
.L286:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:160:             if(material>=candidate.section[4].count)return AYATSURI_MODEL_INVALID;
	movl	8(%rsp), %ecx	# %sfp, _47
	cmpl	%ecx, %edx	# _47, _93
	jnb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:161:             if(n[2]!=3&&candidate.section[12].count&&row(&candidate,13,material,4)[0])return AYATSURI_MODEL_INVALID;
	cmpb	$3, %al	#, _86
	je	.L288	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:161:             if(n[2]!=3&&candidate.section[12].count&&row(&candidate,13,material,4)[0])return AYATSURI_MODEL_INVALID;
	cmpl	$0, 64(%rsp)	#, %sfp
	je	.L289	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:161:             if(n[2]!=3&&candidate.section[12].count&&row(&candidate,13,material,4)[0])return AYATSURI_MODEL_INVALID;
	movq	80(%rsp), %rcx	# %sfp, tmp1012
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	sall	$2, %edx	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:161:             if(n[2]!=3&&candidate.section[12].count&&row(&candidate,13,material,4)[0])return AYATSURI_MODEL_INVALID;
	cmpb	$0, (%rcx,%rdx)	#, *_551
	jne	.L230	#,
.L289:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:162:             if(n[2]==1){if(shape>=candidate.section[2].count||lobes||blend!=0)return AYATSURI_MODEL_INVALID;}
	cmpb	$1, %al	#, _86
	je	.L407	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:163:             else if(n[2]==2){if(!lobes||lobes>8||shape>candidate.section[3].count||lobes>candidate.section[3].count-shape||blend<0||blend>128)
	leal	-1(%rdi), %edx	#, _97
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:163:             else if(n[2]==2){if(!lobes||lobes>8||shape>candidate.section[3].count||lobes>candidate.section[3].count-shape||blend<0||blend>128)
	cmpw	$7, %dx	#, _97
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:163:             else if(n[2]==2){if(!lobes||lobes>8||shape>candidate.section[3].count||lobes>candidate.section[3].count-shape||blend<0||blend>128)
	movl	16(%rsp), %ecx	# %sfp, _45
	cmpl	%esi, %ecx	# _98, _45
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:163:             else if(n[2]==2){if(!lobes||lobes>8||shape>candidate.section[3].count||lobes>candidate.section[3].count-shape||blend<0||blend>128)
	subl	%esi, %ecx	# _98, _100
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:163:             else if(n[2]==2){if(!lobes||lobes>8||shape>candidate.section[3].count||lobes>candidate.section[3].count-shape||blend<0||blend>128)
	cmpl	%edi, %ecx	# _99, _100
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:163:             else if(n[2]==2){if(!lobes||lobes>8||shape>candidate.section[3].count||lobes>candidate.section[3].count-shape||blend<0||blend>128)
	pxor	%xmm7, %xmm7	# tmp1330
	comiss	%xmm0, %xmm7	# _482, tmp1330
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:163:             else if(n[2]==2){if(!lobes||lobes>8||shape>candidate.section[3].count||lobes>candidate.section[3].count-shape||blend<0||blend>128)
	comiss	.LC30(%rip), %xmm0	#, _482
	ja	.L230	#,
.L291:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:170:             ++candidate.packet_count;
	addw	$1, 158(%rsp)	#, candidate.packet_count
	jmp	.L287	#
.L288:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:166:                 if(!(seen&0xf00)||shape>=candidate.section[8].count||lobes||blend!=0)return AYATSURI_MODEL_INVALID;
	cmpl	$0, 56(%rsp)	#, %sfp
	je	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:166:                 if(!(seen&0xf00)||shape>=candidate.section[8].count||lobes||blend!=0)return AYATSURI_MODEL_INVALID;
	movl	60(%rsp), %ecx	# %sfp, _102
	cmpl	%ecx, %esi	# _102, _101
	setnb	%sil	#, _1240
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:166:                 if(!(seen&0xf00)||shape>=candidate.section[8].count||lobes||blend!=0)return AYATSURI_MODEL_INVALID;
	testw	%di, %di	# load_dst_288
	setne	%dil	#, _1241
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:166:                 if(!(seen&0xf00)||shape>=candidate.section[8].count||lobes||blend!=0)return AYATSURI_MODEL_INVALID;
	orb	%dil, %sil	# _1241, tmp1058
	jne	.L230	#,
	pxor	%xmm6, %xmm6	# tmp1333
	movl	$1, %ecx	#, tmp1334
	ucomiss	%xmm6, %xmm0	# tmp1333, _482
	setp	%sil	#, tmp885
	cmovne	%ecx, %esi	# tmp885,, tmp1334, _1238
	testb	%sil, %sil	# _1238
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	imull	$72, %edx, %edx	#, _93,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	72(%rsp), %rcx	# %sfp, _430
	leaq	(%rdx,%rcx), %rsi	#, _556
	addq	%r12, %rsi	# data, _557
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:168:                 if(md(fixed+48)!=1||md(fixed+56)!=1||md(fixed+64)!=0)return AYATSURI_MODEL_INVALID;
	leaq	48(%rsi), %rdi	#, _103
	call	md	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:168:                 if(md(fixed+48)!=1||md(fixed+56)!=1||md(fixed+64)!=0)return AYATSURI_MODEL_INVALID;
	ucomisd	.LC9(%rip), %xmm0	#, tmp1040
	jp	.L230	#,
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:168:                 if(md(fixed+48)!=1||md(fixed+56)!=1||md(fixed+64)!=0)return AYATSURI_MODEL_INVALID;
	leaq	56(%rsi), %rdi	#, _105
	call	md	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:168:                 if(md(fixed+48)!=1||md(fixed+56)!=1||md(fixed+64)!=0)return AYATSURI_MODEL_INVALID;
	ucomisd	.LC9(%rip), %xmm0	#, tmp1041
	jp	.L230	#,
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:168:                 if(md(fixed+48)!=1||md(fixed+56)!=1||md(fixed+64)!=0)return AYATSURI_MODEL_INVALID;
	leaq	64(%rsi), %rdi	#, _107
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:168:                 if(md(fixed+48)!=1||md(fixed+56)!=1||md(fixed+64)!=0)return AYATSURI_MODEL_INVALID;
	pxor	%xmm7, %xmm7	# tmp1336
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:168:                 if(md(fixed+48)!=1||md(fixed+56)!=1||md(fixed+64)!=0)return AYATSURI_MODEL_INVALID;
	call	md	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:168:                 if(md(fixed+48)!=1||md(fixed+56)!=1||md(fixed+64)!=0)return AYATSURI_MODEL_INVALID;
	ucomisd	%xmm7, %xmm0	# tmp1336, tmp1042
	jp	.L230	#,
	je	.L291	#,
	jmp	.L230	#
.L407:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:162:             if(n[2]==1){if(shape>=candidate.section[2].count||lobes||blend!=0)return AYATSURI_MODEL_INVALID;}
	pxor	%xmm6, %xmm6	# tmp1326
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:162:             if(n[2]==1){if(shape>=candidate.section[2].count||lobes||blend!=0)return AYATSURI_MODEL_INVALID;}
	movl	12(%rsp), %ecx	# %sfp, _44
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:162:             if(n[2]==1){if(shape>=candidate.section[2].count||lobes||blend!=0)return AYATSURI_MODEL_INVALID;}
	ucomiss	%xmm6, %xmm0	# tmp1326, _482
	setp	%dl	#, tmp861
	cmovne	%eax, %edx	# tmp861,, _86, _1243
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:162:             if(n[2]==1){if(shape>=candidate.section[2].count||lobes||blend!=0)return AYATSURI_MODEL_INVALID;}
	cmpl	%ecx, %esi	# _44, _96
	setnb	%sil	#, _1245
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:162:             if(n[2]==1){if(shape>=candidate.section[2].count||lobes||blend!=0)return AYATSURI_MODEL_INVALID;}
	orb	%dl, %sil	# _1243, tmp1057
	jne	.L230	#,
	testw	%di, %di	# load_dst_288
	je	.L291	#,
	jmp	.L230	#
.L406:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	4(%rax), %esi	# MEM <unsigned int> [(const uint8_t *)_607 + 4B], _619
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	24(%rsp), %rax	# %sfp, _416
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:179:             if(m16(prior+2)==length&&!memcmp(name,row(&candidate,7,m32(prior+4),1),length))return AYATSURI_MODEL_INVALID;
	movq	%rdx, 120(%rsp)	# _120, %sfp
	movq	%r11, 136(%rsp)	# out, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rax, %rsi	# _416, _620
	movl	%r10d, 132(%rsp)	# <retval>, %sfp
	addq	%r12, %rsi	# data, _621
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:179:             if(m16(prior+2)==length&&!memcmp(name,row(&candidate,7,m32(prior+4),1),length))return AYATSURI_MODEL_INVALID;
	movq	%rdi, 112(%rsp)	# _596, %sfp
	call	memcmp@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:179:             if(m16(prior+2)==length&&!memcmp(name,row(&candidate,7,m32(prior+4),1),length))return AYATSURI_MODEL_INVALID;
	movq	112(%rsp), %rdi	# %sfp, _596
	movq	120(%rsp), %rdx	# %sfp, _120
	testl	%eax, %eax	# tmp1043
	movl	132(%rsp), %r10d	# %sfp, <retval>
	movq	136(%rsp), %r11	# %sfp, out
	jne	.L298	#,
	jmp	.L230	#
.L405:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:181:         candidate.slot_bytes+=n[2]==3?node_slot_bytes(&candidate,i,n):slot_bytes(n);
	movl	%r13d, %eax	# _86, _86
	movl	128(%rsp), %ebx	# %sfp, i
	movl	100(%rsp), %r13d	# %sfp, count
	movq	104(%rsp), %rbp	# %sfp, ivtmp.437
	cmpb	$3, %al	#, _86
	je	.L408	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:181:         candidate.slot_bytes+=n[2]==3?node_slot_bytes(&candidate,i,n):slot_bytes(n);
	movq	%r15, %rdi	# ivtmp.434,
	call	slot_bytes	#
.L301:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:181:         candidate.slot_bytes+=n[2]==3?node_slot_bytes(&candidate,i,n):slot_bytes(n);
	addl	160(%rsp), %eax	# candidate.slot_bytes, iftmp.2_161
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:152:     for(uint32_t i=0;i<count;++i){
	addl	$1, %ebx	#, i
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:152:     for(uint32_t i=0;i<count;++i){
	addq	$16, %r15	#, ivtmp.434
	addq	$36, %rbp	#, ivtmp.437
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:181:         candidate.slot_bytes+=n[2]==3?node_slot_bytes(&candidate,i,n):slot_bytes(n);
	movl	%eax, 160(%rsp)	# candidate_slot_bytes_lsm.399, candidate.slot_bytes
	movl	%eax, %edx	# iftmp.2_161, candidate_slot_bytes_lsm.399
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:152:     for(uint32_t i=0;i<count;++i){
	cmpl	%r13d, %ebx	# count, i
	jb	.L302	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	220(%rsp), %r9d	# candidate.section[7].offset, _719
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:185:     for(uint32_t k=0;k<candidate.section[7].count;++k){
	movq	%r12, %rbx	# data, data
	movq	%r11, %rbp	# out, out
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:185:     for(uint32_t k=0;k<candidate.section[7].count;++k){
	xorl	%esi, %esi	# k
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:185:     for(uint32_t k=0;k<candidate.section[7].count;++k){
	movzbl	99(%rsp), %eax	# %sfp, _70
	movl	224(%rsp), %r14d	# candidate.section[7].count, _145
	movl	%r10d, %r12d	# <retval>, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:194:            !isfinite(offset)||offset< -limit||offset>limit||!isfinite(feather)||
	movss	.LC20(%rip), %xmm9	#, tmp1001
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:193:            !isfinite(x)||!isfinite(y)||!isfinite(z)||fabs(x*x+y*y+z*z-1)>1e-4||
	movq	.LC8(%rip), %xmm3	#, tmp997
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:192:         if(!((kind==1&&region[2]==4)||(kind==2&&region[2]==5))||region[3]||m32(region+28)||
	movsd	.LC22(%rip), %xmm6	#, tmp998
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:196:         for(uint32_t j=0;j<k;++j)if(m16(row(&candidate,8,j,32))==id)return AYATSURI_MODEL_INVALID;
	leaq	(%rbx,%r9), %r11	#, tmp1003
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:195:            (feather!=0&&(feather<1e-4f||feather>limit))||m32(region+24)>0xffffff)return AYATSURI_MODEL_INVALID;
	movss	.LC31(%rip), %xmm8	#, tmp1002
.L303:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:185:     for(uint32_t k=0;k<candidate.section[7].count;++k){
	cmpl	%esi, %r14d	# k, _145
	je	.L409	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:187:         const double x=mf(region+4),y=mf(region+8),z=mf(region+12);
	pxor	%xmm0, %xmm0	# x
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:187:         const double x=mf(region+4),y=mf(region+8),z=mf(region+12);
	pxor	%xmm1, %xmm1	# y
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:187:         const double x=mf(region+4),y=mf(region+8),z=mf(region+12);
	pxor	%xmm2, %xmm2	# z
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	%esi, %ecx	# k, _168
	sall	$5, %ecx	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%r9, %rcx	# _719, _722
	addq	%rbx, %rcx	# data, _723
	movzwl	(%rcx), %edi	# MEM <short unsigned int> [(const uint8_t *)_723],
	movss	16(%rcx), %xmm7	# MEM <unsigned int> [(const uint8_t *)_723 + 16B], _665
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:187:         const double x=mf(region+4),y=mf(region+8),z=mf(region+12);
	cvtss2sd	4(%rcx), %xmm0	# MEM <unsigned int> [(const uint8_t *)_723 + 4B], x
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:187:         const double x=mf(region+4),y=mf(region+8),z=mf(region+12);
	cvtss2sd	8(%rcx), %xmm1	# MEM <unsigned int> [(const uint8_t *)_723 + 8B], y
	movss	20(%rcx), %xmm4	# MEM <unsigned int> [(const uint8_t *)_723 + 20B], _650
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:187:         const double x=mf(region+4),y=mf(region+8),z=mf(region+12);
	cvtss2sd	12(%rcx), %xmm2	# MEM <unsigned int> [(const uint8_t *)_723 + 12B], z
	movl	%edi, %r10d	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:189:         if(id>=count)return AYATSURI_MODEL_INVALID;
	cmpl	%r13d, %edi	# count, _125
	jnb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:190:         const unsigned kind=row(&candidate,1,id,16)[2];
	movq	48(%rsp), %r15	# %sfp, tmp983
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:191:         const float limit=region[2]==5?4096:2;
	movzbl	2(%rcx), %r8d	# MEM[(const uint8_t *)_723 + 2B], _128
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	sall	$4, %edi	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:190:         const unsigned kind=row(&candidate,1,id,16)[2];
	movzbl	2(%rdi,%r15), %edi	# MEM[(const uint8_t *)_729 + 2B], _126
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:191:         const float limit=region[2]==5?4096:2;
	cmpb	$5, %r8b	#, _128
	je	.L410	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:192:         if(!((kind==1&&region[2]==4)||(kind==2&&region[2]==5))||region[3]||m32(region+28)||
	subb	$1, %dil	#, _126
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:192:         if(!((kind==1&&region[2]==4)||(kind==2&&region[2]==5))||region[3]||m32(region+28)||
	cmpb	$4, %r8b	#, _128
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:191:         const float limit=region[2]==5?4096:2;
	movss	.LC28(%rip), %xmm5	#, iftmp.4_942
.L316:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:192:         if(!((kind==1&&region[2]==4)||(kind==2&&region[2]==5))||region[3]||m32(region+28)||
	cmpb	$0, 3(%rcx)	#, MEM[(const uint8_t *)_723 + 3B]
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:15: static uint32_t m32(const uint8_t *p){return (uint32_t)p[0]|(uint32_t)p[1]<<8|(uint32_t)p[2]<<16|(uint32_t)p[3]<<24;}
	movl	28(%rcx), %edi	# MEM <unsigned int> [(const uint8_t *)_723 + 28B], j
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:192:         if(!((kind==1&&region[2]==4)||(kind==2&&region[2]==5))||region[3]||m32(region+28)||
	testl	%edi, %edi	# j
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:193:            !isfinite(x)||!isfinite(y)||!isfinite(z)||fabs(x*x+y*y+z*z-1)>1e-4||
	movapd	%xmm0, %xmm10	# x, _130
	andpd	%xmm3, %xmm10	# tmp997, _130
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:192:         if(!((kind==1&&region[2]==4)||(kind==2&&region[2]==5))||region[3]||m32(region+28)||
	ucomisd	%xmm10, %xmm6	# _130, tmp998
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:193:            !isfinite(x)||!isfinite(y)||!isfinite(z)||fabs(x*x+y*y+z*z-1)>1e-4||
	movapd	%xmm1, %xmm10	# y, _131
	andpd	%xmm3, %xmm10	# tmp997, _131
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:193:            !isfinite(x)||!isfinite(y)||!isfinite(z)||fabs(x*x+y*y+z*z-1)>1e-4||
	ucomisd	%xmm10, %xmm6	# _131, tmp998
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:193:            !isfinite(x)||!isfinite(y)||!isfinite(z)||fabs(x*x+y*y+z*z-1)>1e-4||
	movapd	%xmm2, %xmm10	# z, _132
	andpd	%xmm3, %xmm10	# tmp997, _132
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:193:            !isfinite(x)||!isfinite(y)||!isfinite(z)||fabs(x*x+y*y+z*z-1)>1e-4||
	ucomisd	%xmm10, %xmm6	# _132, tmp998
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:193:            !isfinite(x)||!isfinite(y)||!isfinite(z)||fabs(x*x+y*y+z*z-1)>1e-4||
	mulsd	%xmm0, %xmm0	# x, _133
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:193:            !isfinite(x)||!isfinite(y)||!isfinite(z)||fabs(x*x+y*y+z*z-1)>1e-4||
	mulsd	%xmm1, %xmm1	# y, _134
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:193:            !isfinite(x)||!isfinite(y)||!isfinite(z)||fabs(x*x+y*y+z*z-1)>1e-4||
	mulsd	%xmm2, %xmm2	# z, _136
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:193:            !isfinite(x)||!isfinite(y)||!isfinite(z)||fabs(x*x+y*y+z*z-1)>1e-4||
	addsd	%xmm1, %xmm0	# _134, _135
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:193:            !isfinite(x)||!isfinite(y)||!isfinite(z)||fabs(x*x+y*y+z*z-1)>1e-4||
	addsd	%xmm2, %xmm0	# _136, _137
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:193:            !isfinite(x)||!isfinite(y)||!isfinite(z)||fabs(x*x+y*y+z*z-1)>1e-4||
	subsd	.LC9(%rip), %xmm0	#, _138
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:193:            !isfinite(x)||!isfinite(y)||!isfinite(z)||fabs(x*x+y*y+z*z-1)>1e-4||
	andpd	%xmm3, %xmm0	# tmp997, _139
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:193:            !isfinite(x)||!isfinite(y)||!isfinite(z)||fabs(x*x+y*y+z*z-1)>1e-4||
	comisd	.LC29(%rip), %xmm0	#, _139
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:193:            !isfinite(x)||!isfinite(y)||!isfinite(z)||fabs(x*x+y*y+z*z-1)>1e-4||
	movss	.LC1(%rip), %xmm2	#, tmp1351
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:194:            !isfinite(offset)||offset< -limit||offset>limit||!isfinite(feather)||
	movaps	%xmm7, %xmm0	# _665, _140
	andps	.LC0(%rip), %xmm0	#, _140
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:193:            !isfinite(x)||!isfinite(y)||!isfinite(z)||fabs(x*x+y*y+z*z-1)>1e-4||
	ucomiss	%xmm0, %xmm2	# _140, tmp1351
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:194:            !isfinite(offset)||offset< -limit||offset>limit||!isfinite(feather)||
	movaps	%xmm5, %xmm0	# iftmp.4_942, _141
	xorps	%xmm9, %xmm0	# tmp1001, _141
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:194:            !isfinite(offset)||offset< -limit||offset>limit||!isfinite(feather)||
	comiss	%xmm7, %xmm0	# _665, _141
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:194:            !isfinite(offset)||offset< -limit||offset>limit||!isfinite(feather)||
	comiss	%xmm5, %xmm7	# iftmp.4_942, _665
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:194:            !isfinite(offset)||offset< -limit||offset>limit||!isfinite(feather)||
	movaps	%xmm4, %xmm0	# _650, _142
	andps	.LC0(%rip), %xmm0	#, _142
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:194:            !isfinite(offset)||offset< -limit||offset>limit||!isfinite(feather)||
	ucomiss	%xmm0, %xmm2	# _142, tmp1354
	jb	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:194:            !isfinite(offset)||offset< -limit||offset>limit||!isfinite(feather)||
	pxor	%xmm0, %xmm0	# tmp969
	ucomiss	%xmm0, %xmm4	# tmp969, _650
	jp	.L333	#,
	je	.L308	#,
.L333:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:195:            (feather!=0&&(feather<1e-4f||feather>limit))||m32(region+24)>0xffffff)return AYATSURI_MODEL_INVALID;
	comiss	%xmm4, %xmm8	# _650, tmp1002
	ja	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:195:            (feather!=0&&(feather<1e-4f||feather>limit))||m32(region+24)>0xffffff)return AYATSURI_MODEL_INVALID;
	comiss	%xmm5, %xmm4	# iftmp.4_942, _650
	ja	.L230	#,
.L308:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:195:            (feather!=0&&(feather<1e-4f||feather>limit))||m32(region+24)>0xffffff)return AYATSURI_MODEL_INVALID;
	cmpl	$16777215, 24(%rcx)	#, MEM <unsigned int> [(const uint8_t *)_723 + 24B]
	ja	.L230	#,
.L310:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:196:         for(uint32_t j=0;j<k;++j)if(m16(row(&candidate,8,j,32))==id)return AYATSURI_MODEL_INVALID;
	cmpl	%edi, %esi	# j, k
	je	.L411	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	%edi, %ecx	# j, _25
	sall	$5, %ecx	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:196:         for(uint32_t j=0;j<k;++j)if(m16(row(&candidate,8,j,32))==id)return AYATSURI_MODEL_INVALID;
	cmpw	%r10w, (%r11,%rcx)	# load_dst_400, MEM <short unsigned int> [(const uint8_t *)_768]
	je	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:196:         for(uint32_t j=0;j<k;++j)if(m16(row(&candidate,8,j,32))==id)return AYATSURI_MODEL_INVALID;
	addl	$1, %edi	#, j
	jmp	.L310	#
.L410:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:192:         if(!((kind==1&&region[2]==4)||(kind==2&&region[2]==5))||region[3]||m32(region+28)||
	cmpb	$2, %dil	#, _126
	jne	.L230	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:191:         const float limit=region[2]==5?4096:2;
	movss	.LC3(%rip), %xmm5	#, iftmp.4_942
	jmp	.L316	#
.L408:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:181:         candidate.slot_bytes+=n[2]==3?node_slot_bytes(&candidate,i,n):slot_bytes(n);
	movq	88(%rsp), %rdi	# %sfp,
	movq	%r15, %rdx	# ivtmp.434,
	movl	%ebx, %esi	# i,
	call	node_slot_bytes	#
	jmp	.L301	#
.L409:
	cmpb	$0, 40(%rsp)	#, %sfp
	je	.L314	#,
	movl	%edx, 160(%rsp)	# candidate_slot_bytes_lsm.399, candidate.slot_bytes
.L314:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:199:     *out=candidate;return AYATSURI_MODEL_OK;
	leaq	144(%rsp), %rsi	#, tmp977
	movl	$32, %ecx	#, tmp978
	movq	%rbp, %rdi	# out, out
	rep movsl
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:199:     *out=candidate;return AYATSURI_MODEL_OK;
	jmp	.L229	#
.L411:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:197:         if(region[2]==5)candidate.slot_bytes+=24;
	cmpb	$5, %r8b	#, _128
	jne	.L312	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:197:         if(region[2]==5)candidate.slot_bytes+=24;
	movb	%al, 40(%rsp)	# _70, %sfp
	addl	$24, %edx	#, candidate_slot_bytes_lsm.399
.L312:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:185:     for(uint32_t k=0;k<candidate.section[7].count;++k){
	addl	$1, %esi	#, k
	jmp	.L303	#
	.cfi_endproc
.LFE24:
	.size	ayatsuri_model_open, .-ayatsuri_model_open
	.p2align 4
	.globl	ayatsuri_model_find_node
	.type	ayatsuri_model_find_node, @function
ayatsuri_model_find_node:
.LFB25:
	.cfi_startproc
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:202:     if(!m||!m->data||!name||!out||!bytes||bytes>127||overlaps(out,sizeof *out,m,sizeof *m)||
	testq	%rdi, %rdi	# m
	je	.L422	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:201: ayatsuri_model_status ayatsuri_model_find_node(const ayatsuri_model *m,const char *name,size_t bytes,uint16_t *out){
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rdi, %rbp	# tmp165, m
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp	#,
	.cfi_def_cfa_offset 80
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:202:     if(!m||!m->data||!name||!out||!bytes||bytes>127||overlaps(out,sizeof *out,m,sizeof *m)||
	movq	(%rdi), %r15	# m_15(D)->data, _1
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:202:     if(!m||!m->data||!name||!out||!bytes||bytes>127||overlaps(out,sizeof *out,m,sizeof *m)||
	testq	%r15, %r15	# _1
	je	.L424	#,
	movq	%rsi, %r14	# tmp166, name
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:202:     if(!m||!m->data||!name||!out||!bytes||bytes>127||overlaps(out,sizeof *out,m,sizeof *m)||
	testq	%rsi, %rsi	# name
	je	.L424	#,
	movq	%rcx, %r13	# tmp168, out
	testq	%rcx, %rcx	# out
	je	.L424	#,
	movq	%rdx, %r12	# tmp167, bytes
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:202:     if(!m||!m->data||!name||!out||!bytes||bytes>127||overlaps(out,sizeof *out,m,sizeof *m)||
	leaq	-1(%rdx), %rdx	#, _5
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:203:        overlaps(out,sizeof *out,m->data,m->bytes))return AYATSURI_MODEL_INVALID;
	movl	$1, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:202:     if(!m||!m->data||!name||!out||!bytes||bytes>127||overlaps(out,sizeof *out,m,sizeof *m)||
	cmpq	$126, %rdx	#, _5
	ja	.L412	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rcx, %rdi	# out, m
	jnb	.L436	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rcx, %rdx	# out, _20
	subq	%rdi, %rdx	# m, _20
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$127, %rdx	#, _20
	jbe	.L412	#,
.L415:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:203:        overlaps(out,sizeof *out,m->data,m->bytes))return AYATSURI_MODEL_INVALID;
	movl	8(%rbp), %edx	# m_15(D)->bytes, _7
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rdx, %rdx	# _7
	je	.L419	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r13, %r15	# out, _1
	jb	.L418	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r15, %rdx	# _1, _27
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:203:        overlaps(out,sizeof *out,m->data,m->bytes))return AYATSURI_MODEL_INVALID;
	movl	$1, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%r13, %rdx	# out, _27
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$1, %rdx	#, _27
	jbe	.L412	#,
	.p2align 4
	.p2align 3
.L419:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:204:     for(unsigned i=0;i<m->node_count;++i){const uint8_t *b=row(m,6,i,8);
	movzwl	12(%rbp), %eax	# m_15(D)->node_count, _71
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:204:     for(unsigned i=0;i<m->node_count;++i){const uint8_t *b=row(m,6,i,8);
	testl	%eax, %eax	# _71
	je	.L435	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	60(%rbp), %ebx	# m_15(D)->section[5].offset, _37
	subl	$1, %eax	#, _49
	addq	%r15, %rbx	# _1, ivtmp.558
	leaq	8(%rbx,%rax,8), %rcx	#, _53
	jmp	.L421	#
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L420:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:204:     for(unsigned i=0;i<m->node_count;++i){const uint8_t *b=row(m,6,i,8);
	addq	$8, %rbx	#, ivtmp.558
	cmpq	%rbx, %rcx	# ivtmp.558, _53
	je	.L435	#,
.L421:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:205:         if(m16(b+2)==bytes&&!memcmp(row(m,7,m32(b+4),1),name,bytes)){*out=m16(b);return AYATSURI_MODEL_OK;}}
	movzwl	2(%rbx), %eax	# MEM <short unsigned int> [(const uint8_t *)_41 + 2B], _8
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:205:         if(m16(b+2)==bytes&&!memcmp(row(m,7,m32(b+4),1),name,bytes)){*out=m16(b);return AYATSURI_MODEL_OK;}}
	cmpq	%r12, %rax	# bytes, _8
	jne	.L420	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	4(%rbx), %eax	# MEM <unsigned int> [(const uint8_t *)_41 + 4B], _44
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	68(%rbp), %edi	# m_15(D)->section[6].offset, _43
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:205:         if(m16(b+2)==bytes&&!memcmp(row(m,7,m32(b+4),1),name,bytes)){*out=m16(b);return AYATSURI_MODEL_OK;}}
	movq	%r12, %rdx	# bytes,
	movq	%r14, %rsi	# name,
	movq	%rcx, 8(%rsp)	# _53, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rax, %rdi	# _44, _45
	addq	%r15, %rdi	# _1, _46
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:205:         if(m16(b+2)==bytes&&!memcmp(row(m,7,m32(b+4),1),name,bytes)){*out=m16(b);return AYATSURI_MODEL_OK;}}
	call	memcmp@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:205:         if(m16(b+2)==bytes&&!memcmp(row(m,7,m32(b+4),1),name,bytes)){*out=m16(b);return AYATSURI_MODEL_OK;}}
	movq	8(%rsp), %rcx	# %sfp, _53
	testl	%eax, %eax	# tmp169
	jne	.L420	#,
	movzwl	(%rbx), %eax	# MEM <short unsigned int> [(const uint8_t *)_41], load_dst_11
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:205:         if(m16(b+2)==bytes&&!memcmp(row(m,7,m32(b+4),1),name,bytes)){*out=m16(b);return AYATSURI_MODEL_OK;}}
	movw	%ax, 0(%r13)	# load_dst_11, *out_18(D)
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:205:         if(m16(b+2)==bytes&&!memcmp(row(m,7,m32(b+4),1),name,bytes)){*out=m16(b);return AYATSURI_MODEL_OK;}}
	xorl	%eax, %eax	# <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:205:         if(m16(b+2)==bytes&&!memcmp(row(m,7,m32(b+4),1),name,bytes)){*out=m16(b);return AYATSURI_MODEL_OK;}}
	jmp	.L412	#
	.p2align 4,,10
	.p2align 3
.L424:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:203:        overlaps(out,sizeof *out,m->data,m->bytes))return AYATSURI_MODEL_INVALID;
	movl	$1, %eax	#, <retval>
.L412:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:207: }
	addq	$24, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
	.p2align 4,,10
	.p2align 3
.L436:
	.cfi_restore_state
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rdi, %rdx	# m, _21
	subq	%rcx, %rdx	# out, _21
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$1, %rdx	#, _21
	jbe	.L412	#,
	jmp	.L415	#
	.p2align 4,,10
	.p2align 3
.L422:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:203:        overlaps(out,sizeof *out,m->data,m->bytes))return AYATSURI_MODEL_INVALID;
	movl	$1, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:207: }
	ret	
	.p2align 4,,10
	.p2align 3
.L435:
	.cfi_def_cfa_offset 80
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:206:     return AYATSURI_MODEL_DONE;
	movl	$5, %eax	#, <retval>
	jmp	.L412	#
	.p2align 4,,10
	.p2align 3
.L418:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r13, %rcx	# out, _28
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:203:        overlaps(out,sizeof *out,m->data,m->bytes))return AYATSURI_MODEL_INVALID;
	movl	$1, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%r15, %rcx	# _1, _28
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rdx, %rcx	# _7, _28
	jb	.L412	#,
	jmp	.L419	#
	.cfi_endproc
.LFE25:
	.size	ayatsuri_model_find_node, .-ayatsuri_model_find_node
	.p2align 4
	.globl	ayatsuri_model_instance_bytes
	.type	ayatsuri_model_instance_bytes, @function
ayatsuri_model_instance_bytes:
.LFB26:
	.cfi_startproc
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:209:     return m&&m->data?((sizeof(model_node_state)*m->node_count+7u)&~(size_t)7u)+m->slot_bytes:0;
	xorl	%eax, %eax	# <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:209:     return m&&m->data?((sizeof(model_node_state)*m->node_count+7u)&~(size_t)7u)+m->slot_bytes:0;
	testq	%rdi, %rdi	# m
	je	.L437	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:209:     return m&&m->data?((sizeof(model_node_state)*m->node_count+7u)&~(size_t)7u)+m->slot_bytes:0;
	cmpq	$0, (%rdi)	#, m_3(D)->data
	je	.L437	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:209:     return m&&m->data?((sizeof(model_node_state)*m->node_count+7u)&~(size_t)7u)+m->slot_bytes:0;
	movzwl	12(%rdi), %eax	# MEM[(short unsigned int *)m_3(D) + 12B], _9
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:209:     return m&&m->data?((sizeof(model_node_state)*m->node_count+7u)&~(size_t)7u)+m->slot_bytes:0;
	leaq	(%rax,%rax,2), %rdx	#, _10
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:209:     return m&&m->data?((sizeof(model_node_state)*m->node_count+7u)&~(size_t)7u)+m->slot_bytes:0;
	movl	16(%rdi), %eax	# MEM[(unsigned int *)m_3(D) + 16B], _14
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:209:     return m&&m->data?((sizeof(model_node_state)*m->node_count+7u)&~(size_t)7u)+m->slot_bytes:0;
	leaq	(%rax,%rdx,8), %rax	#, <retval>
.L437:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:210: }
	ret	
	.cfi_endproc
.LFE26:
	.size	ayatsuri_model_instance_bytes, .-ayatsuri_model_instance_bytes
	.p2align 4
	.globl	ayatsuri_model_instance_init
	.type	ayatsuri_model_instance_init, @function
ayatsuri_model_instance_init:
.LFB31:
	.cfi_startproc
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:225:        overlaps(out,sizeof *out,m->data,m->bytes))return AYATSURI_MODEL_INVALID;
	movl	$1, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:209:     return m&&m->data?((sizeof(model_node_state)*m->node_count+7u)&~(size_t)7u)+m->slot_bytes:0;
	testq	%rdi, %rdi	# m
	je	.L492	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:220:         const void *owner,uint32_t generation,ayatsuri_model_instance *out){
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rcx, %rbp	# tmp347, owner
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx	# tmp344, m
	subq	$200, %rsp	#,
	.cfi_def_cfa_offset 256
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:209:     return m&&m->data?((sizeof(model_node_state)*m->node_count+7u)&~(size_t)7u)+m->slot_bytes:0;
	movq	(%rdi), %rcx	# m_44(D)->data, _162
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:209:     return m&&m->data?((sizeof(model_node_state)*m->node_count+7u)&~(size_t)7u)+m->slot_bytes:0;
	testq	%rcx, %rcx	# _162
	je	.L442	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:209:     return m&&m->data?((sizeof(model_node_state)*m->node_count+7u)&~(size_t)7u)+m->slot_bytes:0;
	movzwl	12(%rdi), %eax	# MEM[(short unsigned int *)m_44(D) + 12B], _168
	movq	%rsi, %r10	# tmp345, arena
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:209:     return m&&m->data?((sizeof(model_node_state)*m->node_count+7u)&~(size_t)7u)+m->slot_bytes:0;
	leaq	(%rax,%rax,2), %rsi	#, _169
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:209:     return m&&m->data?((sizeof(model_node_state)*m->node_count+7u)&~(size_t)7u)+m->slot_bytes:0;
	movl	16(%rdi), %eax	# MEM[(unsigned int *)m_44(D) + 16B], _173
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:209:     return m&&m->data?((sizeof(model_node_state)*m->node_count+7u)&~(size_t)7u)+m->slot_bytes:0;
	leaq	(%rax,%rsi,8), %r12	#, iftmp.14_174
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:222:     if(!need||!arena||!owner||!out||!generation||((uintptr_t)arena&7)||bytes<need||
	testq	%r12, %r12	# iftmp.14_174
	je	.L463	#,
	testq	%r10, %r10	# arena
	je	.L463	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:222:     if(!need||!arena||!owner||!out||!generation||((uintptr_t)arena&7)||bytes<need||
	testq	%rbp, %rbp	# owner
	sete	%al	#, _4
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:222:     if(!need||!arena||!owner||!out||!generation||((uintptr_t)arena&7)||bytes<need||
	testq	%r9, %r9	# out
	sete	%sil	#, _5
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:222:     if(!need||!arena||!owner||!out||!generation||((uintptr_t)arena&7)||bytes<need||
	orb	%sil, %al	# _5, tmp365
	jne	.L463	#,
	testl	%r8d, %r8d	# generation
	je	.L463	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:222:     if(!need||!arena||!owner||!out||!generation||((uintptr_t)arena&7)||bytes<need||
	movq	%r10, %r13	# arena, ivtmp.585
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:222:     if(!need||!arena||!owner||!out||!generation||((uintptr_t)arena&7)||bytes<need||
	testb	$7, %r10b	#, arena
	jne	.L463	#,
	cmpq	%r12, %rdx	# iftmp.14_174, bytes
	jb	.L463	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:223:        overlaps(arena,need,m->data,m->bytes)||overlaps(arena,need,m,sizeof *m)||
	movl	8(%rdi), %edx	# m_44(D)->bytes, _10
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rdx, %rdx	# _10
	je	.L444	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r10, %rcx	# arena, _162
	jb	.L445	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rcx, %rsi	# _162, _181
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:225:        overlaps(out,sizeof *out,m->data,m->bytes))return AYATSURI_MODEL_INVALID;
	movl	$1, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%r10, %rsi	# arena, _181
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r12, %rsi	# iftmp.14_174, _181
	jnb	.L444	#,
.L442:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:244: }
	addq	$200, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
	.p2align 4,,10
	.p2align 3
.L463:
	.cfi_restore_state
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:225:        overlaps(out,sizeof *out,m->data,m->bytes))return AYATSURI_MODEL_INVALID;
	movl	$1, %eax	#, <retval>
	jmp	.L442	#
	.p2align 4,,10
	.p2align 3
.L492:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:244: }
	ret	
	.p2align 4,,10
	.p2align 3
.L445:
	.cfi_def_cfa_offset 256
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r10, %rsi	# arena, _182
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:225:        overlaps(out,sizeof *out,m->data,m->bytes))return AYATSURI_MODEL_INVALID;
	movl	$1, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%rcx, %rsi	# _162, _182
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rdx, %rsi	# _10, _182
	jb	.L442	#,
	.p2align 4
	.p2align 3
.L444:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r10, %rbx	# arena, m
	jnb	.L495	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r10, %rsi	# arena, _64
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:225:        overlaps(out,sizeof *out,m->data,m->bytes))return AYATSURI_MODEL_INVALID;
	movl	$1, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%rbx, %rsi	# m, _64
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$127, %rsi	#, _64
	jbe	.L442	#,
.L447:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r10, %r9	# arena, out
	jb	.L448	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r9, %rsi	# out, _52
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:225:        overlaps(out,sizeof *out,m->data,m->bytes))return AYATSURI_MODEL_INVALID;
	movl	$1, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%r10, %rsi	# arena, _52
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r12, %rsi	# iftmp.14_174, _52
	jb	.L442	#,
.L449:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r9, %rbx	# out, m
	jb	.L450	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rbx, %rsi	# m, _83
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:225:        overlaps(out,sizeof *out,m->data,m->bytes))return AYATSURI_MODEL_INVALID;
	movl	$1, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%r9, %rsi	# out, _83
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$167, %rsi	#, _83
	jbe	.L442	#,
.L451:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rdx, %rdx	# _10
	je	.L452	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r9, %rcx	# out, _162
	jb	.L453	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%r9, %rcx	# out, _86
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:225:        overlaps(out,sizeof *out,m->data,m->bytes))return AYATSURI_MODEL_INVALID;
	movl	$1, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$167, %rcx	#, _86
	jbe	.L442	#,
.L452:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:226:     memset(arena,0,need);
	movq	%r10, %rdi	# arena,
	movq	%r12, %rdx	# iftmp.14_174,
	xorl	%esi, %esi	#
	movq	%r9, 8(%rsp)	# out, %sfp
	movl	%r8d, 4(%rsp)	# generation, %sfp
	call	memset@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:228:     uint32_t offset=(uint32_t)((sizeof(model_node_state)*m->node_count+7u)&~(size_t)7u);
	movzwl	12(%rbx), %edx	# m_44(D)->node_count,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:227:     ayatsuri_model_instance result={.model=m,.arena=arena,.owner=owner,.arena_bytes=need,.generation=generation,.alive=true};
	leaq	16(%rsp), %rdi	#, tmp240
	movl	$21, %ecx	#, tmp242
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:226:     memset(arena,0,need);
	movq	%rax, %r10	#, arena
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:227:     ayatsuri_model_instance result={.model=m,.arena=arena,.owner=owner,.arena_bytes=need,.generation=generation,.alive=true};
	xorl	%eax, %eax	# tmp241
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:229:     for(unsigned j=0;j<m->node_count;++j){
	movl	4(%rsp), %r8d	# %sfp, generation
	movq	8(%rsp), %r9	# %sfp, out
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:227:     ayatsuri_model_instance result={.model=m,.arena=arena,.owner=owner,.arena_bytes=need,.generation=generation,.alive=true};
	rep stosq
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:228:     uint32_t offset=(uint32_t)((sizeof(model_node_state)*m->node_count+7u)&~(size_t)7u);
	movl	%edx, %eax	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:228:     uint32_t offset=(uint32_t)((sizeof(model_node_state)*m->node_count+7u)&~(size_t)7u);
	leal	(%rdx,%rdx,2), %edx	#, _15
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:229:     for(unsigned j=0;j<m->node_count;++j){
	testw	%ax, %ax	# _13
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:228:     uint32_t offset=(uint32_t)((sizeof(model_node_state)*m->node_count+7u)&~(size_t)7u);
	leal	0(,%rdx,8), %r14d	#, offset
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:229:     for(unsigned j=0;j<m->node_count;++j){
	je	.L474	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:238:             if(node[2]==1){work(&result,j)[63]=work(&result,j)[64]=1;}
	movq	.LC32(%rip), %xmm1	#, tmp341
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:229:     for(unsigned j=0;j<m->node_count;++j){
	xorl	%r11d, %r11d	# ivtmp.582
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:227:     ayatsuri_model_instance result={.model=m,.arena=arena,.owner=owner,.arena_bytes=need,.generation=generation,.alive=true};
	xorl	%r15d, %r15d	# result$156
	jmp	.L458	#
	.p2align 4,,10
	.p2align 3
.L497:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	$-45, %ecx	#, tmp363
	cmpl	%ecx, %r15d	# tmp363, result$156
	cmovbe	%r15d, %ecx	# result$156,, _205
	leal	44(%rcx), %r15d	#, result$156
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:239:             else work(&result,j)[77]=mf(node+12);
	movl	12(%rdx), %ecx	# MEM <unsigned int> [(const uint8_t *)_105 + 12B], MEM <unsigned int> [(const uint8_t *)_105 + 12B]
	movl	%ecx, 308(%rsi)	# MEM <unsigned int> [(const uint8_t *)_105 + 12B], MEM[(float *)_226 + 308B]
.L455:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:241:         offset+=node_slot_bytes(m,j,node);
	movl	%eax, %esi	# _145,
	movq	%rbx, %rdi	# m,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:229:     for(unsigned j=0;j<m->node_count;++j){
	addq	$1, %r11	#, ivtmp.582
	addq	$24, %r13	#, ivtmp.585
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:241:         offset+=node_slot_bytes(m,j,node);
	call	node_slot_bytes	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:241:         offset+=node_slot_bytes(m,j,node);
	addl	%eax, %r14d	# tmp351, offset
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:229:     for(unsigned j=0;j<m->node_count;++j){
	movzwl	12(%rbx), %eax	# m_44(D)->node_count, _33
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:229:     for(unsigned j=0;j<m->node_count;++j){
	cmpl	%eax, %r11d	# _33, ivtmp.582
	jnb	.L496	#,
.L458:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	20(%rbx), %edx	# m_44(D)->section[0].offset, _101
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	%r11, %rsi	# ivtmp.582, _153
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	(%rbx), %rcx	# m_44(D)->data, _99
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:231:         s->offset=offset;s->enabled=node[3];memcpy(work(&result,j)+12,row(m,2,j,36),36);
	movl	%r14d, 8(%r13)	# offset, MEM[(unsigned int *)_151 + 8B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	salq	$4, %rsi	#, _153
	leaq	(%r11,%r11,8), %r8	#, _146
	movl	%r11d, %eax	# ivtmp.582, _145
	addq	%rsi, %rdx	# _153, _104
	addq	%rcx, %rdx	# _99, _105
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:231:         s->offset=offset;s->enabled=node[3];memcpy(work(&result,j)+12,row(m,2,j,36),36);
	movzbl	3(%rdx), %esi	# MEM[(const uint8_t *)_105 + 3B], _19
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:231:         s->offset=offset;s->enabled=node[3];memcpy(work(&result,j)+12,row(m,2,j,36),36);
	movb	%sil, 16(%r13)	# _19, MEM[(unsigned char *)_151 + 16B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	28(%rbx), %edi	# m_44(D)->section[1].offset, _94
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movl	%r14d, %esi	# offset, _92
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:231:         s->offset=offset;s->enabled=node[3];memcpy(work(&result,j)+12,row(m,2,j,36),36);
	leaq	48(%r10,%rsi), %rsi	#, _20
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	leaq	(%rdi,%r8,4), %rdi	#, _97
	addq	%rdi, %rcx	# _97, _98
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:231:         s->offset=offset;s->enabled=node[3];memcpy(work(&result,j)+12,row(m,2,j,36),36);
	movdqu	(%rcx), %xmm0	# MEM <char[1:36]> [(void *)_98], MEM <char[1:36]> [(void *)_98]
	movups	%xmm0, (%rsi)	# MEM <char[1:36]> [(void *)_98], MEM <char[1:36]> [(void *)_20]
	movdqu	16(%rcx), %xmm0	# MEM <char[1:36]> [(void *)_98], MEM <char[1:36]> [(void *)_98]
	movups	%xmm0, 16(%rsi)	# MEM <char[1:36]> [(void *)_98], MEM <char[1:36]> [(void *)_20]
	movl	32(%rcx), %ecx	# MEM <char[1:36]> [(void *)_98], MEM <char[1:36]> [(void *)_98]
	movl	%ecx, 32(%rsi)	# MEM <char[1:36]> [(void *)_98], MEM <char[1:36]> [(void *)_20]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	$-37, %ecx	#, tmp364
	cmpl	%ecx, %r15d	# tmp364, result$156
	cmovbe	%r15d, %ecx	# result$156,, _202
	leal	36(%rcx), %r15d	#, result$156
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:233:         if(node[2]&&node[2]!=3){
	movzbl	2(%rdx), %ecx	# MEM[(const uint8_t *)_105 + 2B], _21
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:233:         if(node[2]&&node[2]!=3){
	testb	%cl, %cl	# _21
	je	.L455	#,
	cmpb	$3, %cl	#, _21
	je	.L455	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:234:             const uint8_t *material=row(m,5,m16(node+8),72);
	movzwl	8(%rdx), %ecx	# MEM <short unsigned int> [(const uint8_t *)_105 + 8B], _25
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:236:             memcpy((uint8_t *)work(&result,j)+(node[2]==1?164:264),material,node[2]==1?32:44);
	movl	$264, %r8d	#, iftmp.17_38
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	leal	(%rcx,%rcx,8), %esi	#, _123
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	52(%rbx), %ecx	# m_44(D)->section[4].offset, _122
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	sall	$3, %esi	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rcx, %rsi	# _122, _125
	addq	(%rbx), %rsi	# m_44(D)->data, _126
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:15: static uint32_t m32(const uint8_t *p){return (uint32_t)p[0]|(uint32_t)p[1]<<8|(uint32_t)p[2]<<16|(uint32_t)p[3]<<24;}
	movl	44(%rsi), %ecx	# MEM <unsigned int> [(const uint8_t *)_126 + 44B], _119
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:235:             s->color=m32(material+44);s->opacity=md(material+56);
	leaq	56(%rsi), %rdi	#, _26
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:235:             s->color=m32(material+44);s->opacity=md(material+56);
	movl	%ecx, 12(%r13)	# _119, MEM[(unsigned int *)_151 + 12B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:236:             memcpy((uint8_t *)work(&result,j)+(node[2]==1?164:264),material,node[2]==1?32:44);
	movl	$44, %ecx	#, iftmp.16_208
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:235:             s->color=m32(material+44);s->opacity=md(material+56);
	call	md	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movl	8(%r13), %edi	# MEM[(unsigned int *)_151 + 8B], _228
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:235:             s->color=m32(material+44);s->opacity=md(material+56);
	movsd	%xmm0, 0(%r13)	# tmp350, MEM[(double *)_151]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:236:             memcpy((uint8_t *)work(&result,j)+(node[2]==1?164:264),material,node[2]==1?32:44);
	cmpb	$1, 2(%rdx)	#, MEM[(const uint8_t *)_105 + 2B]
	jne	.L456	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:236:             memcpy((uint8_t *)work(&result,j)+(node[2]==1?164:264),material,node[2]==1?32:44);
	movl	$32, %ecx	#, iftmp.16_208
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:236:             memcpy((uint8_t *)work(&result,j)+(node[2]==1?164:264),material,node[2]==1?32:44);
	movl	$164, %r8d	#, iftmp.17_38
.L456:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:236:             memcpy((uint8_t *)work(&result,j)+(node[2]==1?164:264),material,node[2]==1?32:44);
	addq	%rdi, %r8	# _228, _160
	movq	(%rsi), %rdi	#* _126, tmp285
	addq	%r10, %r8	# arena, _29
	movq	%rdi, (%r8)	# tmp285,* _29
	movq	-8(%rsi,%rcx), %rdi	#, tmp292
	movq	%rdi, -8(%rcx,%r8)	# tmp292,
	leaq	8(%r8), %rdi	#, tmp293
	andq	$-8, %rdi	#, tmp293
	subq	%rdi, %r8	# tmp293, tmp294
	addl	%r8d, %ecx	# tmp294, iftmp.16_208
	subq	%r8, %rsi	# tmp294, _126
	shrl	$3, %ecx	#,
	rep movsq
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movl	8(%r13), %ecx	# MEM[(unsigned int *)_151 + 8B], _225
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:237:             add_count(&result.stats.init_copy_bytes,node[2]==1?32:44);
	cmpb	$1, 2(%rdx)	#, MEM[(const uint8_t *)_105 + 2B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	leaq	(%r10,%rcx), %rsi	#, _226
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:237:             add_count(&result.stats.init_copy_bytes,node[2]==1?32:44);
	jne	.L497	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	$-33, %ecx	#, tmp362
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:238:             if(node[2]==1){work(&result,j)[63]=work(&result,j)[64]=1;}
	movlps	%xmm1, 252(%rsi)	# tmp341, MEM <vector(2) float> [(float *)_226 + 252B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	cmpl	%ecx, %r15d	# tmp362, result$156
	cmovbe	%r15d, %ecx	# result$156,, _206
	leal	32(%rcx), %r15d	#, result$156
	jmp	.L455	#
	.p2align 4,,10
	.p2align 3
.L495:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rbx, %rsi	# m, _66
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:225:        overlaps(out,sizeof *out,m->data,m->bytes))return AYATSURI_MODEL_INVALID;
	movl	$1, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%r10, %rsi	# arena, _66
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r12, %rsi	# iftmp.14_174, _66
	jb	.L442	#,
	jmp	.L447	#
	.p2align 4,,10
	.p2align 3
.L448:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r10, %rsi	# arena, _51
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:225:        overlaps(out,sizeof *out,m->data,m->bytes))return AYATSURI_MODEL_INVALID;
	movl	$1, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%r9, %rsi	# out, _51
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$167, %rsi	#, _51
	jbe	.L442	#,
	jmp	.L449	#
	.p2align 4,,10
	.p2align 3
.L450:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r9, %rsi	# out, _84
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:225:        overlaps(out,sizeof *out,m->data,m->bytes))return AYATSURI_MODEL_INVALID;
	movl	$1, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%rbx, %rsi	# m, _84
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$127, %rsi	#, _84
	jbe	.L442	#,
	jmp	.L451	#
.L496:
	movl	4(%rsp), %r8d	# %sfp, generation
	movq	8(%rsp), %r9	# %sfp, out
.L454:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:243:     *out=result;return AYATSURI_MODEL_OK;
	movq	%rbx, 16(%rsp)	# m, result.model
	movq	%r10, 24(%rsp)	# arena, result.arena
	movdqa	16(%rsp), %xmm0	# result, result
	movq	%rbp, 32(%rsp)	# owner, result.owner
	movq	%r12, 40(%rsp)	# iftmp.14_174, result.arena_bytes
	movups	%xmm0, (%r9)	# result, *out_48(D)
	movdqa	32(%rsp), %xmm0	# result, result
	movl	%r8d, 48(%rsp)	# generation, result.generation
	movups	%xmm0, 16(%r9)	# result, *out_48(D)
	movdqa	48(%rsp), %xmm0	# result, result
	movl	%r15d, 172(%rsp)	# result$156, MEM <uint32_t> [(struct  *)&result + 156B]
	movups	%xmm0, 32(%r9)	# result, *out_48(D)
	movdqa	64(%rsp), %xmm0	# result, result
	movb	$1, 180(%rsp)	#, MEM <unsigned char> [(struct  *)&result + 164B]
	movq	176(%rsp), %rax	# result, result
	movups	%xmm0, 48(%r9)	# result, *out_48(D)
	movdqa	80(%rsp), %xmm0	# result, result
	movq	%rax, 160(%r9)	# result, *out_48(D)
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:243:     *out=result;return AYATSURI_MODEL_OK;
	xorl	%eax, %eax	# <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:243:     *out=result;return AYATSURI_MODEL_OK;
	movups	%xmm0, 64(%r9)	# result, *out_48(D)
	movdqa	96(%rsp), %xmm0	# result, result
	movups	%xmm0, 80(%r9)	# result, *out_48(D)
	movdqa	112(%rsp), %xmm0	# result, result
	movups	%xmm0, 96(%r9)	# result, *out_48(D)
	movdqa	128(%rsp), %xmm0	# result, result
	movups	%xmm0, 112(%r9)	# result, *out_48(D)
	movdqa	144(%rsp), %xmm0	# result, result
	movups	%xmm0, 128(%r9)	# result, *out_48(D)
	movdqa	160(%rsp), %xmm0	# result, result
	movups	%xmm0, 144(%r9)	# result, *out_48(D)
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:243:     *out=result;return AYATSURI_MODEL_OK;
	jmp	.L442	#
.L453:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r9, %rsi	# out, _87
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:225:        overlaps(out,sizeof *out,m->data,m->bytes))return AYATSURI_MODEL_INVALID;
	movl	$1, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%rcx, %rsi	# _162, _87
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rdx, %rsi	# _10, _87
	jb	.L442	#,
	jmp	.L452	#
.L474:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:227:     ayatsuri_model_instance result={.model=m,.arena=arena,.owner=owner,.arena_bytes=need,.generation=generation,.alive=true};
	xorl	%r15d, %r15d	# result$156
	jmp	.L454	#
	.cfi_endproc
.LFE31:
	.size	ayatsuri_model_instance_init, .-ayatsuri_model_instance_init
	.p2align 4
	.globl	ayatsuri_model_instance_dispose
	.type	ayatsuri_model_instance_dispose, @function
ayatsuri_model_instance_dispose:
.LFB32:
	.cfi_startproc
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:246:     if(!i||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	movl	$3, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:246:     if(!i||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	testq	%rdi, %rdi	# i
	je	.L498	#,
	testq	%rsi, %rsi	# owner
	je	.L498	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:246:     if(!i||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpq	%rsi, 16(%rdi)	# owner, i_9(D)->owner
	jne	.L498	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:246:     if(!i||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpl	%edx, 32(%rdi)	# generation, i_9(D)->generation
	jne	.L498	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:247:     if(i->busy)return AYATSURI_MODEL_BUSY;
	cmpb	$0, 165(%rdi)	#, i_9(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:247:     if(i->busy)return AYATSURI_MODEL_BUSY;
	movl	$4, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:247:     if(i->busy)return AYATSURI_MODEL_BUSY;
	jne	.L498	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:248:     i->alive=false;i->evaluated=false;i->arena=NULL;i->arena_bytes=0;return AYATSURI_MODEL_OK;
	movb	$0, 164(%rdi)	#, i_9(D)->alive
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:248:     i->alive=false;i->evaluated=false;i->arena=NULL;i->arena_bytes=0;return AYATSURI_MODEL_OK;
	xorl	%eax, %eax	# <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:248:     i->alive=false;i->evaluated=false;i->arena=NULL;i->arena_bytes=0;return AYATSURI_MODEL_OK;
	movb	$0, 166(%rdi)	#, i_9(D)->evaluated
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:248:     i->alive=false;i->evaluated=false;i->arena=NULL;i->arena_bytes=0;return AYATSURI_MODEL_OK;
	movq	$0, 8(%rdi)	#, i_9(D)->arena
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:248:     i->alive=false;i->evaluated=false;i->arena=NULL;i->arena_bytes=0;return AYATSURI_MODEL_OK;
	movq	$0, 24(%rdi)	#, i_9(D)->arena_bytes
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:248:     i->alive=false;i->evaluated=false;i->arena=NULL;i->arena_bytes=0;return AYATSURI_MODEL_OK;
	ret	
	.p2align 4,,10
	.p2align 3
.L498:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:249: }
	ret	
	.cfi_endproc
.LFE32:
	.size	ayatsuri_model_instance_dispose, .-ayatsuri_model_instance_dispose
	.p2align 4
	.globl	ayatsuri_model_instance_targets
	.type	ayatsuri_model_instance_targets, @function
ayatsuri_model_instance_targets:
.LFB33:
	.cfi_startproc
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	testq	%rdi, %rdi	# i
	je	.L552	#,
	movq	%rdi, %rax	# tmp393, i
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:252:     ayatsuri_model_status status=enter(i,owner,generation);if(status)return status;
	movl	$3, %edi	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpb	$1, 164(%rax)	#, i_91(D)->alive
	jne	.L656	#,
	testq	%rsi, %rsi	# owner
	je	.L656	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpq	16(%rax), %rsi	# i_91(D)->owner, owner
	jne	.L656	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpl	32(%rax), %edx	# i_91(D)->generation, generation
	jne	.L656	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:215:     if(i->busy)return AYATSURI_MODEL_BUSY;
	cmpb	$0, 165(%rax)	#, i_91(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:252:     ayatsuri_model_status status=enter(i,owner,generation);if(status)return status;
	movl	$4, %edi	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:215:     if(i->busy)return AYATSURI_MODEL_BUSY;
	jne	.L656	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:251:         uint32_t generation,const ayatsuri_model_targets *t){
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp	#,
	.cfi_def_cfa_offset 80
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:253:     const size_t count=i->model->node_count;
	movq	(%rax), %rdi	# i_91(D)->model, _1
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:216:     i->busy=true;return AYATSURI_MODEL_OK;
	movb	$1, 165(%rax)	#, i_91(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:253:     const size_t count=i->model->node_count;
	movzwl	12(%rdi), %edx	# _1->node_count,
	movq	%rdx, %rbx	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:254:     if(!t||t->count!=count||!t->dirty||!t->pose||!t->color||!t->opacity||
	testq	%rcx, %rcx	# t
	je	.L506	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:254:     if(!t||t->count!=count||!t->dirty||!t->pose||!t->color||!t->opacity||
	cmpq	%rdx, 32(%rcx)	# count, t_97(D)->count
	jne	.L506	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:254:     if(!t||t->count!=count||!t->dirty||!t->pose||!t->color||!t->opacity||
	movq	(%rcx), %rsi	# t_97(D)->dirty, _4
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:254:     if(!t||t->count!=count||!t->dirty||!t->pose||!t->color||!t->opacity||
	testq	%rsi, %rsi	# _4
	je	.L506	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:254:     if(!t||t->count!=count||!t->dirty||!t->pose||!t->color||!t->opacity||
	movq	8(%rcx), %r8	# t_97(D)->pose, _5
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:254:     if(!t||t->count!=count||!t->dirty||!t->pose||!t->color||!t->opacity||
	testq	%r8, %r8	# _5
	je	.L506	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:254:     if(!t||t->count!=count||!t->dirty||!t->pose||!t->color||!t->opacity||
	movq	16(%rcx), %r10	# t_97(D)->color, _6
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:254:     if(!t||t->count!=count||!t->dirty||!t->pose||!t->color||!t->opacity||
	testq	%r10, %r10	# _6
	je	.L506	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:254:     if(!t||t->count!=count||!t->dirty||!t->pose||!t->color||!t->opacity||
	movq	24(%rcx), %r11	# t_97(D)->opacity, _7
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:254:     if(!t||t->count!=count||!t->dirty||!t->pose||!t->color||!t->opacity||
	testq	%r11, %r11	# _7
	je	.L506	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:255:        overlaps(t->dirty,count,i->arena,i->arena_bytes)||overlaps(t->pose,count*36,i->arena,i->arena_bytes)||
	movq	24(%rax), %rbp	# i_91(D)->arena_bytes, _8
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:255:        overlaps(t->dirty,count,i->arena,i->arena_bytes)||overlaps(t->pose,count*36,i->arena,i->arena_bytes)||
	movq	8(%rax), %r9	# i_91(D)->arena, _9
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rbp, %rbp	# _8
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:22:     const uintptr_t x=(uintptr_t)a,y=(uintptr_t)b;
	movq	%r9, %rcx	# _9, ivtmp.610
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	setne	%r12b	#, _173
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rdx, %rdx	# count
	je	.L507	#,
	testb	%r12b, %r12b	# _173
	je	.L507	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rsi, %r9	# _4, _9
	jnb	.L662	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rsi, %r13	# _4, _176
	subq	%r9, %r13	# _9, _176
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rbp, %r13	# _8, _176
	jb	.L506	#,
.L643:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:255:        overlaps(t->dirty,count,i->arena,i->arena_bytes)||overlaps(t->pose,count*36,i->arena,i->arena_bytes)||
	leaq	0(,%rdx,8), %r13	#, _15
	leaq	0(%r13,%rdx), %r15	#, _242
	salq	$2, %r15	#, _242
	jmp	.L510	#
	.p2align 4,,10
	.p2align 3
.L552:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:252:     ayatsuri_model_status status=enter(i,owner,generation);if(status)return status;
	movl	$3, %edi	#, <retval>
.L656:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:280: }
	movl	%edi, %eax	# <retval>,
	ret	
	.p2align 4,,10
	.p2align 3
.L662:
	.cfi_def_cfa_offset 80
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r9, %r13	# _9, _175
	subq	%rsi, %r13	# _4, _175
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rdx, %r13	# count, _175
	jnb	.L643	#,
	.p2align 4
	.p2align 3
.L506:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%rax)	#, i_91(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:257:         return leave(i,AYATSURI_MODEL_INVALID);
	movl	$1, %edi	#, <retval>
.L504:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:280: }
	addq	$24, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movl	%edi, %eax	# <retval>,
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
	.p2align 4,,10
	.p2align 3
.L507:
	.cfi_restore_state
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:255:        overlaps(t->dirty,count,i->arena,i->arena_bytes)||overlaps(t->pose,count*36,i->arena,i->arena_bytes)||
	leaq	0(,%rdx,8), %r13	#, _15
	leaq	0(%r13,%rdx), %r14	#, _11
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	leaq	0(,%r14,4), %r15	#, _242
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%r14, %r14	# _11
	je	.L511	#,
	testb	%r12b, %r12b	# _173
	je	.L511	#,
	.p2align 4
	.p2align 3
.L510:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %r9	# _5, _9
	jb	.L512	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r9, %r14	# _9, _184
	subq	%r8, %r14	# _5, _184
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r15, %r14	# _242, _184
	jb	.L506	#,
	.p2align 4
	.p2align 3
.L511:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	leaq	0(,%rdx,4), %r14	#, _13
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rdx, %rdx	# count
	je	.L513	#,
	testb	%r12b, %r12b	# _173
	je	.L513	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r10, %r9	# _6, _9
	jb	.L514	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r9, %rdx	# _9, _193
	subq	%r10, %rdx	# _6, _193
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r14, %rdx	# _13, _193
	jb	.L506	#,
	.p2align 4
	.p2align 3
.L513:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%r13, %r13	# _15
	je	.L515	#,
	testb	%r12b, %r12b	# _173
	je	.L515	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r11, %r9	# _7, _9
	jb	.L516	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r9, %rdx	# _9, _202
	subq	%r11, %rdx	# _7, _202
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r13, %rdx	# _15, _202
	jb	.L506	#,
	.p2align 4
	.p2align 3
.L515:
	movzwl	%bx, %r15d	# _2, _198
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:258:     for(unsigned j=0;j<count;++j){
	testl	%r15d, %r15d	# _198
	je	.L529	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	20(%rdi), %edx	# _1->section[0].offset, _116
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:262:             if(!isfinite(v)||(k>=6&&v==0))return leave(i,AYATSURI_MODEL_INVALID);}
	movq	%r11, (%rsp)	# _7, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	xorl	%ebp, %ebp	# ivtmp.624
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:261:         for(unsigned k=0;k<9;++k)if(flags&(1u<<(k/3))){const float v=t->pose[j*9+k];
	movl	$2863311531, %ebx	#, tmp384
	movq	(%rdi), %rdi	# _1->data, _1->data
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:262:             if(!isfinite(v)||(k>=6&&v==0))return leave(i,AYATSURI_MODEL_INVALID);}
	movq	%r9, 8(%rsp)	# _9, %sfp
	pxor	%xmm4, %xmm4	# tmp387
	xorl	%r14d, %r14d	# tmp388
	movq	%rcx, 16(%rsp)	# ivtmp.610, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:262:             if(!isfinite(v)||(k>=6&&v==0))return leave(i,AYATSURI_MODEL_INVALID);}
	movss	.LC1(%rip), %xmm2	#, tmp386
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:262:             if(!isfinite(v)||(k>=6&&v==0))return leave(i,AYATSURI_MODEL_INVALID);}
	movss	.LC0(%rip), %xmm3	#, tmp385
	leaq	2(%rdi,%rdx), %rdx	#, ivtmp.628
.L526:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:259:         const unsigned flags=t->dirty[j];const uint8_t *node=row(i->model,1,j,16);
	movzbl	(%rsi,%rbp), %r9d	# MEM[(const uint8_t *)_4 + ivtmp.624_234 * 1],
	movl	%r9d, %r12d	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:260:         if(flags>127||(flags&24)==24||((!node[2]||node[2]==3)&&(flags&96)))return leave(i,AYATSURI_MODEL_INVALID);
	testb	%r9b, %r9b	# _19
	js	.L506	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:260:         if(flags>127||(flags&24)==24||((!node[2]||node[2]==3)&&(flags&96)))return leave(i,AYATSURI_MODEL_INVALID);
	movl	%r9d, %ecx	# _19, tmp408
	notl	%ecx	# tmp408
	andl	$24, %ecx	#, tmp408
	je	.L506	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:260:         if(flags>127||(flags&24)==24||((!node[2]||node[2]==3)&&(flags&96)))return leave(i,AYATSURI_MODEL_INVALID);
	movzbl	(%rdx), %ecx	# MEM[(const uint8_t *)_206], _20
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:260:         if(flags>127||(flags&24)==24||((!node[2]||node[2]==3)&&(flags&96)))return leave(i,AYATSURI_MODEL_INVALID);
	testb	%cl, %cl	# _20
	je	.L557	#,
	cmpb	$3, %cl	#, _20
	je	.L557	#,
.L517:
	movl	%ebp, %r11d	# ivtmp.624, _205
	leal	0(%rbp,%rbp,8), %r13d	#, _204
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	xorl	%edi, %edi	# k
	.p2align 4
	.p2align 3
.L521:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:261:         for(unsigned k=0;k<9;++k)if(flags&(1u<<(k/3))){const float v=t->pose[j*9+k];
	movl	%edi, %ecx	# k, k
	imulq	%rbx, %rcx	# tmp384, tmp293
	shrq	$33, %rcx	#, _24
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:261:         for(unsigned k=0;k<9;++k)if(flags&(1u<<(k/3))){const float v=t->pose[j*9+k];
	btl	%ecx, %r9d	# _24, flags
	jnc	.L519	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:261:         for(unsigned k=0;k<9;++k)if(flags&(1u<<(k/3))){const float v=t->pose[j*9+k];
	leal	0(%r13,%rdi), %ecx	#, _29
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:261:         for(unsigned k=0;k<9;++k)if(flags&(1u<<(k/3))){const float v=t->pose[j*9+k];
	movss	(%r8,%rcx,4), %xmm0	# *_31, v
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:262:             if(!isfinite(v)||(k>=6&&v==0))return leave(i,AYATSURI_MODEL_INVALID);}
	movaps	%xmm0, %xmm1	# v, _32
	andps	%xmm3, %xmm1	# tmp385, _32
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:262:             if(!isfinite(v)||(k>=6&&v==0))return leave(i,AYATSURI_MODEL_INVALID);}
	ucomiss	%xmm1, %xmm2	# _32, tmp386
	jb	.L506	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:262:             if(!isfinite(v)||(k>=6&&v==0))return leave(i,AYATSURI_MODEL_INVALID);}
	cmpl	$5, %edi	#, k
	jbe	.L519	#,
	ucomiss	%xmm4, %xmm0	# tmp387, v
	setnp	%cl	#, tmp314
	cmovne	%r14d, %ecx	# tmp314,, tmp388, _180
	testb	%cl, %cl	# _180
	jne	.L506	#,
.L519:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:261:         for(unsigned k=0;k<9;++k)if(flags&(1u<<(k/3))){const float v=t->pose[j*9+k];
	addl	$1, %edi	#, k
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:261:         for(unsigned k=0;k<9;++k)if(flags&(1u<<(k/3))){const float v=t->pose[j*9+k];
	cmpl	$9, %edi	#, k
	jne	.L521	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:263:         if((flags&32)&&t->color[j]>0xffffff)return leave(i,AYATSURI_MODEL_INVALID);
	testb	$32, %r12b	#, _19
	je	.L522	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:263:         if((flags&32)&&t->color[j]>0xffffff)return leave(i,AYATSURI_MODEL_INVALID);
	cmpl	$16777215, (%r10,%rbp,4)	#, MEM[(const uint32_t *)_6 + ivtmp.624_234 * 4]
	ja	.L506	#,
.L522:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:264:         if((flags&64)&&!unit(md((const uint8_t *)t->opacity+8*j)))return leave(i,AYATSURI_MODEL_INVALID);
	andl	$64, %r12d	#, _19
	je	.L523	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:264:         if((flags&64)&&!unit(md((const uint8_t *)t->opacity+8*j)))return leave(i,AYATSURI_MODEL_INVALID);
	movq	(%rsp), %rcx	# %sfp, _7
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:264:         if((flags&64)&&!unit(md((const uint8_t *)t->opacity+8*j)))return leave(i,AYATSURI_MODEL_INVALID);
	leal	0(,%r11,8), %edi	#, _37
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:264:         if((flags&64)&&!unit(md((const uint8_t *)t->opacity+8*j)))return leave(i,AYATSURI_MODEL_INVALID);
	addq	%rcx, %rdi	# _7, _38
	call	md	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	movsd	.LC22(%rip), %xmm5	#, tmp325
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	movapd	%xmm0, %xmm1	# _39, _98
	andpd	.LC8(%rip), %xmm1	#, _98
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	ucomisd	%xmm1, %xmm5	# _98, tmp325
	jb	.L506	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	pxor	%xmm1, %xmm1	# tmp326
	comisd	%xmm1, %xmm0	# tmp326, _39
	jb	.L506	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	movsd	.LC9(%rip), %xmm1	#, tmp327
	comisd	%xmm0, %xmm1	# _39, tmp327
	jb	.L506	#,
	.p2align 4
	.p2align 3
.L523:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:258:     for(unsigned j=0;j<count;++j){
	addq	$1, %rbp	#, ivtmp.624
	addq	$16, %rdx	#, ivtmp.628
	cmpl	%r15d, %ebp	# _198, ivtmp.624
	jb	.L526	#,
	leal	(%r15,%r15,8), %ebx	#, _229
	movq	(%rsp), %r11	# %sfp, _7
	movq	8(%rsp), %r9	# %sfp, _9
	xorl	%r13d, %r13d	# ivtmp.614
	movl	%ebx, (%rsp)	# _229, %sfp
	movq	16(%rsp), %rcx	# %sfp, ivtmp.610
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:270:         for(unsigned k=0;k<9;++k)if((flags&(1u<<(k/3)))&&pose[k]!=t->pose[j*9+k]){
	movl	$2863311531, %r12d	#, tmp331
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:266:     bool changed=false;
	movb	$0, 8(%rsp)	#, %sfp
.L546:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:268:         const unsigned flags=t->dirty[j];model_node_state *s=states(i)+j;float *pose=work(i,j)+12;
	movzbl	(%rsi), %ebx	# MEM[(const uint8_t *)_162],
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movl	8(%rcx), %ebp	# MEM[(unsigned int *)_222 + 8B], _124
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:269:         bool node_changed=false;
	xorl	%r15d, %r15d	# node_changed
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	xorl	%edi, %edi	# ivtmp.598
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:268:         const unsigned flags=t->dirty[j];model_node_state *s=states(i)+j;float *pose=work(i,j)+12;
	movl	%ebx, %r14d	#,
	addq	%r9, %rbp	# _9, _211
	.p2align 4
	.p2align 3
.L532:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:270:         for(unsigned k=0;k<9;++k)if((flags&(1u<<(k/3)))&&pose[k]!=t->pose[j*9+k]){
	movl	%edi, %edx	# ivtmp.598, _207
	imulq	%r12, %rdx	# tmp331, tmp330
	shrq	$33, %rdx	#, _45
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:270:         for(unsigned k=0;k<9;++k)if((flags&(1u<<(k/3)))&&pose[k]!=t->pose[j*9+k]){
	btl	%edx, %ebx	# _45, flags
	jnc	.L530	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:270:         for(unsigned k=0;k<9;++k)if((flags&(1u<<(k/3)))&&pose[k]!=t->pose[j*9+k]){
	leal	0(%r13,%rdi), %edx	#, _54
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:270:         for(unsigned k=0;k<9;++k)if((flags&(1u<<(k/3)))&&pose[k]!=t->pose[j*9+k]){
	movss	(%r8,%rdx,4), %xmm0	# *_56, _57
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:270:         for(unsigned k=0;k<9;++k)if((flags&(1u<<(k/3)))&&pose[k]!=t->pose[j*9+k]){
	ucomiss	48(%rbp,%rdi,4), %xmm0	# MEM[(float *)_211 + 48B + ivtmp.598_169 * 4], _57
	jp	.L559	#,
	je	.L530	#,
.L559:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	160(%rax), %edx	# MEM[(uint32_t *)i_91(D) + 160B], MEM[(uint32_t *)i_91(D) + 160B]
	movl	$-5, %r15d	#, tmp407
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:271:             pose[k]=t->pose[j*9+k];node_changed=true;add_count(&i->stats.target_copy_bytes,4);}
	movss	%xmm0, 48(%rbp,%rdi,4)	# _57, MEM[(float *)_211 + 48B + ivtmp.598_169 * 4]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	cmpl	%r15d, %edx	# tmp407, MEM[(uint32_t *)i_91(D) + 160B]
	cmova	%r15d, %edx	# MEM[(uint32_t *)i_91(D) + 160B],, tmp407, _253
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:271:             pose[k]=t->pose[j*9+k];node_changed=true;add_count(&i->stats.target_copy_bytes,4);}
	movl	$1, %r15d	#, node_changed
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	addl	$4, %edx	#, tmp344
	movl	%edx, 160(%rax)	# tmp344, MEM[(uint32_t *)i_91(D) + 160B]
.L530:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:270:         for(unsigned k=0;k<9;++k)if((flags&(1u<<(k/3)))&&pose[k]!=t->pose[j*9+k]){
	addq	$1, %rdi	#, ivtmp.598
	cmpq	$9, %rdi	#, ivtmp.598
	jne	.L532	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:272:         if((flags&24)&&s->enabled!=!!(flags&8)){s->enabled=!!(flags&8);node_changed=true;add_count(&i->stats.target_copy_bytes,1);}
	testb	$24, %r14b	#, _43
	je	.L533	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:272:         if((flags&24)&&s->enabled!=!!(flags&8)){s->enabled=!!(flags&8);node_changed=true;add_count(&i->stats.target_copy_bytes,1);}
	movl	%r14d, %edx	# _43, _149
	shrb	$3, %dl	#, _149
	andl	$1, %edx	#, _149
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:272:         if((flags&24)&&s->enabled!=!!(flags&8)){s->enabled=!!(flags&8);node_changed=true;add_count(&i->stats.target_copy_bytes,1);}
	cmpb	%dl, 16(%rcx)	# _149, MEM[(unsigned char *)_222 + 16B]
	je	.L533	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:272:         if((flags&24)&&s->enabled!=!!(flags&8)){s->enabled=!!(flags&8);node_changed=true;add_count(&i->stats.target_copy_bytes,1);}
	movb	%dl, 16(%rcx)	# _149, MEM[(unsigned char *)_222 + 16B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	160(%rax), %edx	# MEM[(uint32_t *)i_91(D) + 160B], _128
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	xorl	%edi, %edi	# tmp360
	cmpl	$-1, %edx	#, _128
	setne	%dil	#, tmp360
	addl	%edi, %edx	# tmp360, _128
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	%edx, 160(%rax)	# _128, MEM[(uint32_t *)i_91(D) + 160B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:273:         if((flags&32)&&s->color!=t->color[j]){s->color=t->color[j];node_changed=true;add_count(&i->stats.target_copy_bytes,4);}
	testb	$32, %r14b	#, _43
	je	.L661	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:273:         if((flags&32)&&s->color!=t->color[j]){s->color=t->color[j];node_changed=true;add_count(&i->stats.target_copy_bytes,4);}
	movl	(%r10), %edx	# MEM[(const uint32_t *)_148], _63
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:273:         if((flags&32)&&s->color!=t->color[j]){s->color=t->color[j];node_changed=true;add_count(&i->stats.target_copy_bytes,4);}
	cmpl	%edx, 12(%rcx)	# _63, MEM[(unsigned int *)_222 + 12B]
	je	.L661	#,
.L536:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:273:         if((flags&32)&&s->color!=t->color[j]){s->color=t->color[j];node_changed=true;add_count(&i->stats.target_copy_bytes,4);}
	movl	%edx, 12(%rcx)	# _63, MEM[(unsigned int *)_222 + 12B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	160(%rax), %edx	# MEM[(uint32_t *)i_91(D) + 160B], MEM[(uint32_t *)i_91(D) + 160B]
	movl	$-5, %edi	#, tmp406
	cmpl	%edi, %edx	# tmp406, MEM[(uint32_t *)i_91(D) + 160B]
	cmova	%edi, %edx	# MEM[(uint32_t *)i_91(D) + 160B],, tmp406, _257
	addl	$4, %edx	#, tmp352
	movl	%edx, 160(%rax)	# tmp352, MEM[(uint32_t *)i_91(D) + 160B]
.L661:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:274:         if(flags&64){const double value=md((const uint8_t *)t->opacity+8*j);
	andl	$64, %r14d	#, _43
	je	.L540	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:274:         if(flags&64){const double value=md((const uint8_t *)t->opacity+8*j);
	movq	%r11, %rdi	# ivtmp.612,
	call	md	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:275:             if(s->opacity!=value){s->opacity=value;node_changed=true;add_count(&i->stats.target_copy_bytes,8);}}
	ucomisd	(%rcx), %xmm0	# MEM[(double *)_222], value
	jp	.L549	#,
	je	.L540	#,
.L549:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	160(%rax), %edx	# MEM[(uint32_t *)i_91(D) + 160B], MEM[(uint32_t *)i_91(D) + 160B]
	movl	$-9, %edi	#, tmp405
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:275:             if(s->opacity!=value){s->opacity=value;node_changed=true;add_count(&i->stats.target_copy_bytes,8);}}
	movsd	%xmm0, (%rcx)	# value, MEM[(double *)_222]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	cmpl	%edi, %edx	# tmp405, MEM[(uint32_t *)i_91(D) + 160B]
	cmova	%edi, %edx	# MEM[(uint32_t *)i_91(D) + 160B],, tmp405, _259
	addl	$8, %edx	#, tmp357
	movl	%edx, 160(%rax)	# tmp357, MEM[(uint32_t *)i_91(D) + 160B]
.L540:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	152(%rax), %edx	# MEM[(uint32_t *)i_91(D) + 152B], _137
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	xorl	%edi, %edi	# tmp362
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:276:         if(node_changed){changed=true;add_count(&i->stats.target_changed,1);}
	movb	$1, 8(%rsp)	#, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	cmpl	$-1, %edx	#, _137
	setne	%dil	#, tmp362
	addl	%edi, %edx	# tmp362, _137
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	%edx, 152(%rax)	# _137, MEM[(uint32_t *)i_91(D) + 152B]
.L544:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:267:     for(unsigned j=0;j<count;++j){
	movl	(%rsp), %ebx	# %sfp, _229
	addl	$9, %r13d	#, ivtmp.614
	addq	$1, %rsi	#, ivtmp.609
	addq	$24, %rcx	#, ivtmp.610
	addq	$8, %r11	#, ivtmp.612
	addq	$4, %r10	#, ivtmp.613
	cmpl	%ebx, %r13d	# _229, ivtmp.614
	jne	.L546	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:278:     if(changed){add_count(&i->mutation_epoch,1);i->evaluated=false;}
	cmpb	$0, 8(%rsp)	#, %sfp
	je	.L529	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	36(%rax), %edx	# MEM[(uint32_t *)i_91(D) + 36B], _140
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	cmpl	$-1, %edx	#, _140
	je	.L548	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	addl	$1, %edx	#, _140
.L548:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	%edx, 36(%rax)	# _140, MEM[(uint32_t *)i_91(D) + 36B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:278:     if(changed){add_count(&i->mutation_epoch,1);i->evaluated=false;}
	movb	$0, 166(%rax)	#, i_91(D)->evaluated
.L529:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%rax)	#, i_91(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:279:     return leave(i,AYATSURI_MODEL_OK);
	xorl	%edi, %edi	# <retval>
	jmp	.L504	#
	.p2align 4,,10
	.p2align 3
.L512:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %r14	# _5, _185
	subq	%r9, %r14	# _9, _185
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rbp, %r14	# _8, _185
	jb	.L506	#,
	jmp	.L511	#
	.p2align 4,,10
	.p2align 3
.L557:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:260:         if(flags>127||(flags&24)==24||((!node[2]||node[2]==3)&&(flags&96)))return leave(i,AYATSURI_MODEL_INVALID);
	testb	$96, %r12b	#, _19
	je	.L517	#,
	jmp	.L506	#
	.p2align 4,,10
	.p2align 3
.L514:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r10, %rdx	# _6, _194
	subq	%r9, %rdx	# _9, _194
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rbp, %rdx	# _8, _194
	jb	.L506	#,
	jmp	.L513	#
.L516:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r11, %rdx	# _7, _203
	subq	%r9, %rdx	# _9, _203
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rbp, %rdx	# _8, _203
	jnb	.L515	#,
	jmp	.L506	#
.L533:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:273:         if((flags&32)&&s->color!=t->color[j]){s->color=t->color[j];node_changed=true;add_count(&i->stats.target_copy_bytes,4);}
	testb	$32, %r14b	#, _43
	je	.L541	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:273:         if((flags&32)&&s->color!=t->color[j]){s->color=t->color[j];node_changed=true;add_count(&i->stats.target_copy_bytes,4);}
	movl	(%r10), %edx	# MEM[(const uint32_t *)_228], _63
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:273:         if((flags&32)&&s->color!=t->color[j]){s->color=t->color[j];node_changed=true;add_count(&i->stats.target_copy_bytes,4);}
	cmpl	%edx, 12(%rcx)	# _63, MEM[(unsigned int *)_222 + 12B]
	jne	.L536	#,
.L541:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:274:         if(flags&64){const double value=md((const uint8_t *)t->opacity+8*j);
	andl	$64, %r14d	#, _43
	je	.L542	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:274:         if(flags&64){const double value=md((const uint8_t *)t->opacity+8*j);
	movq	%r11, %rdi	# ivtmp.612,
	call	md	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:275:             if(s->opacity!=value){s->opacity=value;node_changed=true;add_count(&i->stats.target_copy_bytes,8);}}
	ucomisd	(%rcx), %xmm0	# MEM[(double *)_222], value
	jp	.L549	#,
	jne	.L549	#,
.L542:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:276:         if(node_changed){changed=true;add_count(&i->stats.target_changed,1);}
	testb	%r15b, %r15b	# node_changed
	je	.L544	#,
	jmp	.L540	#
	.cfi_endproc
.LFE33:
	.size	ayatsuri_model_instance_targets, .-ayatsuri_model_instance_targets
	.p2align 4
	.globl	ayatsuri_model_instance_node_kind
	.type	ayatsuri_model_instance_node_kind, @function
ayatsuri_model_instance_node_kind:
.LFB34:
	.cfi_startproc
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:282:         uint32_t generation,uint16_t node,uint8_t *out){
	movq	%rdi, %rax	# tmp151, i
	movl	%ecx, %edi	# tmp154, node
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:283:     ayatsuri_model_status status=enter(i,owner,generation);if(status)return status;
	movl	$3, %ecx	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	testq	%rax, %rax	# i
	je	.L663	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpb	$1, 164(%rax)	#, i_13(D)->alive
	jne	.L663	#,
	testq	%rsi, %rsi	# owner
	je	.L663	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpq	16(%rax), %rsi	# i_13(D)->owner, owner
	jne	.L663	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpl	32(%rax), %edx	# i_13(D)->generation, generation
	jne	.L663	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:215:     if(i->busy)return AYATSURI_MODEL_BUSY;
	cmpb	$0, 165(%rax)	#, i_13(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:283:     ayatsuri_model_status status=enter(i,owner,generation);if(status)return status;
	movl	$4, %ecx	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:215:     if(i->busy)return AYATSURI_MODEL_BUSY;
	jne	.L663	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:216:     i->busy=true;return AYATSURI_MODEL_OK;
	movb	$1, 165(%rax)	#, i_13(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:284:     if(!out||node>=i->model->node_count||overlaps(out,1,i,sizeof *i)||
	testq	%r8, %r8	# out
	je	.L665	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:284:     if(!out||node>=i->model->node_count||overlaps(out,1,i,sizeof *i)||
	movq	(%rax), %rdx	# i_13(D)->model, _1
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:284:     if(!out||node>=i->model->node_count||overlaps(out,1,i,sizeof *i)||
	cmpw	12(%rdx), %di	# _1->node_count, node
	jnb	.L665	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %rax	# out, i
	jnb	.L688	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %rcx	# out, _23
	subq	%rax, %rcx	# i, _23
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$167, %rcx	#, _23
	jbe	.L665	#,
.L667:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %rdx	# out, _1
	jb	.L668	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rdx, %r8	# _1, out
	jne	.L669	#,
	.p2align 4
	.p2align 3
.L665:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%rax)	#, i_13(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:286:        overlaps(out,1,i->model->data,i->model->bytes))return leave(i,AYATSURI_MODEL_INVALID);
	movl	$1, %ecx	#, <retval>
.L663:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:288: }
	movl	%ecx, %eax	# <retval>,
	ret	
	.p2align 4,,10
	.p2align 3
.L688:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	je	.L665	#,
	jmp	.L667	#
	.p2align 4,,10
	.p2align 3
.L668:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %rcx	# out, _25
	subq	%rdx, %rcx	# _1, _25
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$127, %rcx	#, _25
	jbe	.L665	#,
.L669:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:285:        overlaps(out,1,i->model,sizeof *i->model)||overlaps(out,1,i->arena,i->arena_bytes)||
	movq	24(%rax), %rcx	# i_13(D)->arena_bytes, _3
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rcx, %rcx	# _3
	je	.L670	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:22:     const uintptr_t x=(uintptr_t)a,y=(uintptr_t)b;
	movq	8(%rax), %rsi	# i_13(D)->arena, y
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %rsi	# out, y
	jb	.L671	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rsi, %r8	# y, out
	je	.L665	#,
	.p2align 4
	.p2align 3
.L670:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:286:        overlaps(out,1,i->model->data,i->model->bytes))return leave(i,AYATSURI_MODEL_INVALID);
	movl	8(%rdx), %ecx	# _1->bytes, _6
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:286:        overlaps(out,1,i->model->data,i->model->bytes))return leave(i,AYATSURI_MODEL_INVALID);
	movq	(%rdx), %rsi	# _1->data, _7
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rcx, %rcx	# _6
	je	.L672	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %rsi	# out, _7
	jb	.L673	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rsi, %r8	# _7, out
	je	.L665	#,
	.p2align 4
	.p2align 3
.L672:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	20(%rdx), %edx	# _1->section[0].offset, _31
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	%rdi, %rcx	# node, _32
	salq	$4, %rcx	#, _32
	andl	$1048560, %ecx	#, _33
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:287:     *out=row(i->model,1,node,16)[2];return leave(i,AYATSURI_MODEL_OK);
	addq	%rdx, %rsi	# _31, tmp148
	movzbl	2(%rcx,%rsi), %edx	# MEM[(const uint8_t *)_35 + 2B], _9
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:287:     *out=row(i->model,1,node,16)[2];return leave(i,AYATSURI_MODEL_OK);
	xorl	%ecx, %ecx	# <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:287:     *out=row(i->model,1,node,16)[2];return leave(i,AYATSURI_MODEL_OK);
	movb	%dl, (%r8)	# _9, *out_18(D)
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%rax)	#, i_13(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:287:     *out=row(i->model,1,node,16)[2];return leave(i,AYATSURI_MODEL_OK);
	jmp	.L663	#
	.p2align 4,,10
	.p2align 3
.L671:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %r9	# out, _27
	subq	%rsi, %r9	# y, _27
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rcx, %r9	# _3, _27
	jb	.L665	#,
	jmp	.L670	#
	.p2align 4,,10
	.p2align 3
.L673:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %r9	# out, _29
	subq	%rsi, %r9	# _7, _29
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rcx, %r9	# _6, _29
	jnb	.L672	#,
	jmp	.L665	#
	.cfi_endproc
.LFE34:
	.size	ayatsuri_model_instance_node_kind, .-ayatsuri_model_instance_node_kind
	.p2align 4
	.globl	ayatsuri_model_instance_read_pose
	.type	ayatsuri_model_instance_read_pose, @function
ayatsuri_model_instance_read_pose:
.LFB35:
	.cfi_startproc
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:290:         uint32_t generation,uint16_t node,float out[9]){
	movq	%rdi, %rax	# tmp165, i
	movl	%ecx, %edi	# tmp168, node
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:291:     ayatsuri_model_status status=enter(i,owner,generation);if(status)return status;
	movl	$3, %ecx	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	testq	%rax, %rax	# i
	je	.L689	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpb	$1, 164(%rax)	#, i_12(D)->alive
	jne	.L689	#,
	testq	%rsi, %rsi	# owner
	je	.L689	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpq	16(%rax), %rsi	# i_12(D)->owner, owner
	jne	.L689	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpl	32(%rax), %edx	# i_12(D)->generation, generation
	jne	.L689	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:215:     if(i->busy)return AYATSURI_MODEL_BUSY;
	cmpb	$0, 165(%rax)	#, i_12(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:291:     ayatsuri_model_status status=enter(i,owner,generation);if(status)return status;
	movl	$4, %ecx	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:215:     if(i->busy)return AYATSURI_MODEL_BUSY;
	jne	.L689	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:216:     i->busy=true;return AYATSURI_MODEL_OK;
	movb	$1, 165(%rax)	#, i_12(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:292:     if(!out||node>=i->model->node_count||overlaps(out,36,i,sizeof *i)||
	testq	%r8, %r8	# out
	je	.L691	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:292:     if(!out||node>=i->model->node_count||overlaps(out,36,i,sizeof *i)||
	movq	(%rax), %rdx	# i_12(D)->model, _1
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:292:     if(!out||node>=i->model->node_count||overlaps(out,36,i,sizeof *i)||
	cmpw	12(%rdx), %di	# _1->node_count, node
	jnb	.L691	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %rax	# out, i
	jnb	.L714	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %rcx	# out, _23
	subq	%rax, %rcx	# i, _23
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$167, %rcx	#, _23
	jbe	.L691	#,
.L693:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %rdx	# out, _1
	jb	.L694	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rdx, %rcx	# _1, _25
	subq	%r8, %rcx	# out, _25
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$35, %rcx	#, _25
	ja	.L695	#,
	.p2align 4
	.p2align 3
.L691:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%rax)	#, i_12(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:294:        overlaps(out,36,i->model->data,i->model->bytes))return leave(i,AYATSURI_MODEL_INVALID);
	movl	$1, %ecx	#, <retval>
.L689:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:296: }
	movl	%ecx, %eax	# <retval>,
	ret	
	.p2align 4,,10
	.p2align 3
.L714:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rax, %rcx	# i, _22
	subq	%r8, %rcx	# out, _22
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$35, %rcx	#, _22
	jbe	.L691	#,
	jmp	.L693	#
	.p2align 4,,10
	.p2align 3
.L694:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %rcx	# out, _26
	subq	%rdx, %rcx	# _1, _26
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$127, %rcx	#, _26
	jbe	.L691	#,
.L695:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:293:        overlaps(out,36,i->model,sizeof *i->model)||overlaps(out,36,i->arena,i->arena_bytes)||
	movq	24(%rax), %rcx	# i_12(D)->arena_bytes, _3
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:293:        overlaps(out,36,i->model,sizeof *i->model)||overlaps(out,36,i->arena,i->arena_bytes)||
	movq	8(%rax), %rsi	# i_12(D)->arena, _4
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rcx, %rcx	# _3
	je	.L696	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %rsi	# out, _4
	jb	.L697	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rsi, %rcx	# _4, _28
	subq	%r8, %rcx	# out, _28
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$35, %rcx	#, _28
	jbe	.L691	#,
	.p2align 4
	.p2align 3
.L696:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:294:        overlaps(out,36,i->model->data,i->model->bytes))return leave(i,AYATSURI_MODEL_INVALID);
	movl	8(%rdx), %ecx	# _1->bytes, _6
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rcx, %rcx	# _6
	je	.L698	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:22:     const uintptr_t x=(uintptr_t)a,y=(uintptr_t)b;
	movq	(%rdx), %rdx	# _1->data, y
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %rdx	# out, y
	jb	.L699	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%r8, %rdx	# out, _31
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$35, %rdx	#, _31
	jbe	.L691	#,
	.p2align 4
	.p2align 3
.L698:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movzwl	%di, %ecx	# node, _33
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	leaq	(%rcx,%rcx,2), %rdx	#, tmp155
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:295:     memcpy(out,work(i,node)+12,36);return leave(i,AYATSURI_MODEL_OK);
	xorl	%ecx, %ecx	# <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movl	8(%rsi,%rdx,8), %edx	# _35->offset, _37
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:295:     memcpy(out,work(i,node)+12,36);return leave(i,AYATSURI_MODEL_OK);
	leaq	48(%rsi,%rdx), %rdx	#, _8
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:295:     memcpy(out,work(i,node)+12,36);return leave(i,AYATSURI_MODEL_OK);
	movdqu	(%rdx), %xmm0	# MEM <char[1:36]> [(void *)_8], MEM <char[1:36]> [(void *)_8]
	movups	%xmm0, (%r8)	# MEM <char[1:36]> [(void *)_8], MEM <char[1:36]> [(void *)out_17(D)]
	movdqu	16(%rdx), %xmm0	# MEM <char[1:36]> [(void *)_8], MEM <char[1:36]> [(void *)_8]
	movups	%xmm0, 16(%r8)	# MEM <char[1:36]> [(void *)_8], MEM <char[1:36]> [(void *)out_17(D)]
	movl	32(%rdx), %edx	# MEM <char[1:36]> [(void *)_8], MEM <char[1:36]> [(void *)_8]
	movl	%edx, 32(%r8)	# MEM <char[1:36]> [(void *)_8], MEM <char[1:36]> [(void *)out_17(D)]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%rax)	#, i_12(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:295:     memcpy(out,work(i,node)+12,36);return leave(i,AYATSURI_MODEL_OK);
	jmp	.L689	#
	.p2align 4,,10
	.p2align 3
.L697:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %r9	# out, _29
	subq	%rsi, %r9	# _4, _29
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rcx, %r9	# _3, _29
	jb	.L691	#,
	jmp	.L696	#
	.p2align 4,,10
	.p2align 3
.L699:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %r9	# out, _32
	subq	%rdx, %r9	# y, _32
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rcx, %r9	# _6, _32
	jnb	.L698	#,
	jmp	.L691	#
	.cfi_endproc
.LFE35:
	.size	ayatsuri_model_instance_read_pose, .-ayatsuri_model_instance_read_pose
	.p2align 4
	.globl	ayatsuri_model_instance_stats
	.type	ayatsuri_model_instance_stats, @function
ayatsuri_model_instance_stats:
.LFB36:
	.cfi_startproc
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:298:         uint32_t generation,ayatsuri_model_stats *out){
	movq	%rdi, %rax	# tmp144, i
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:299:     ayatsuri_model_status status=enter(i,owner,generation);if(status)return status;
	movl	$3, %edi	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	testq	%rax, %rax	# i
	je	.L715	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpb	$1, 164(%rax)	#, i_10(D)->alive
	jne	.L715	#,
	testq	%rsi, %rsi	# owner
	je	.L715	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpq	16(%rax), %rsi	# i_10(D)->owner, owner
	jne	.L715	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpl	32(%rax), %edx	# i_10(D)->generation, generation
	jne	.L715	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:215:     if(i->busy)return AYATSURI_MODEL_BUSY;
	cmpb	$0, 165(%rax)	#, i_10(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:299:     ayatsuri_model_status status=enter(i,owner,generation);if(status)return status;
	movl	$4, %edi	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:215:     if(i->busy)return AYATSURI_MODEL_BUSY;
	jne	.L715	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:300:     if(!out||overlaps(out,sizeof *out,i,sizeof *i)||overlaps(out,sizeof *out,i->model,sizeof *i->model)||
	testq	%rcx, %rcx	# out
	je	.L730	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rcx, %rax	# out, i
	jb	.L717	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rax, %rdx	# i, _19
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:302:        overlaps(out,sizeof *out,i->model->data,i->model->bytes))return leave(i,AYATSURI_MODEL_INVALID);
	movl	$1, %edi	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%rcx, %rdx	# out, _19
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$27, %rdx	#, _19
	ja	.L718	#,
.L715:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:304: }
	movl	%edi, %eax	# <retval>,
	ret	
	.p2align 4,,10
	.p2align 3
.L717:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rcx, %rdx	# out, _20
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:302:        overlaps(out,sizeof *out,i->model->data,i->model->bytes))return leave(i,AYATSURI_MODEL_INVALID);
	movl	$1, %edi	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%rax, %rdx	# i, _20
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$167, %rdx	#, _20
	jbe	.L715	#,
.L718:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:300:     if(!out||overlaps(out,sizeof *out,i,sizeof *i)||overlaps(out,sizeof *out,i->model,sizeof *i->model)||
	movq	(%rax), %rdx	# i_10(D)->model, _1
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rcx, %rdx	# out, _1
	jnb	.L745	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rcx, %rsi	# out, _23
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:302:        overlaps(out,sizeof *out,i->model->data,i->model->bytes))return leave(i,AYATSURI_MODEL_INVALID);
	movl	$1, %edi	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%rdx, %rsi	# _1, _23
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$127, %rsi	#, _23
	jbe	.L715	#,
.L720:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:301:        overlaps(out,sizeof *out,i->arena,i->arena_bytes)||
	movq	24(%rax), %rsi	# i_10(D)->arena_bytes, _2
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rsi, %rsi	# _2
	je	.L721	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:22:     const uintptr_t x=(uintptr_t)a,y=(uintptr_t)b;
	movq	8(%rax), %rdi	# i_10(D)->arena, y
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rcx, %rdi	# out, y
	jb	.L722	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%rcx, %rdi	# out, y
	movq	%rdi, %rsi	# y, _25
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:302:        overlaps(out,sizeof *out,i->model->data,i->model->bytes))return leave(i,AYATSURI_MODEL_INVALID);
	movl	$1, %edi	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$27, %rsi	#, _25
	jbe	.L715	#,
	.p2align 4
	.p2align 3
.L721:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:302:        overlaps(out,sizeof *out,i->model->data,i->model->bytes))return leave(i,AYATSURI_MODEL_INVALID);
	movl	8(%rdx), %esi	# _1->bytes, _5
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rsi, %rsi	# _5
	je	.L723	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:22:     const uintptr_t x=(uintptr_t)a,y=(uintptr_t)b;
	movq	(%rdx), %rdx	# _1->data, y
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rcx, %rdx	# out, y
	jb	.L724	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%rcx, %rdx	# out, _28
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:302:        overlaps(out,sizeof *out,i->model->data,i->model->bytes))return leave(i,AYATSURI_MODEL_INVALID);
	movl	$1, %edi	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$27, %rdx	#, _28
	jbe	.L715	#,
	.p2align 4
	.p2align 3
.L723:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:303:     *out=i->stats;return leave(i,AYATSURI_MODEL_OK);
	movdqu	136(%rax), %xmm0	# i_10(D)->stats, i_10(D)->stats
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:303:     *out=i->stats;return leave(i,AYATSURI_MODEL_OK);
	xorl	%edi, %edi	# <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:303:     *out=i->stats;return leave(i,AYATSURI_MODEL_OK);
	movups	%xmm0, (%rcx)	# i_10(D)->stats, *out_15(D)
	movdqu	148(%rax), %xmm0	# i_10(D)->stats, i_10(D)->stats
	movups	%xmm0, 12(%rcx)	# i_10(D)->stats, *out_15(D)
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%rax)	#, i_10(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:303:     *out=i->stats;return leave(i,AYATSURI_MODEL_OK);
	jmp	.L715	#
	.p2align 4,,10
	.p2align 3
.L745:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rdx, %rsi	# _1, _22
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:302:        overlaps(out,sizeof *out,i->model->data,i->model->bytes))return leave(i,AYATSURI_MODEL_INVALID);
	movl	$1, %edi	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%rcx, %rsi	# out, _22
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$27, %rsi	#, _22
	jbe	.L715	#,
	jmp	.L720	#
	.p2align 4,,10
	.p2align 3
.L730:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:302:        overlaps(out,sizeof *out,i->model->data,i->model->bytes))return leave(i,AYATSURI_MODEL_INVALID);
	movl	$1, %edi	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:304: }
	movl	%edi, %eax	# <retval>,
	ret	
	.p2align 4,,10
	.p2align 3
.L722:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rcx, %r8	# out, _26
	subq	%rdi, %r8	# y, _26
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:302:        overlaps(out,sizeof *out,i->model->data,i->model->bytes))return leave(i,AYATSURI_MODEL_INVALID);
	movl	$1, %edi	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rsi, %r8	# _2, _26
	jb	.L715	#,
	jmp	.L721	#
	.p2align 4,,10
	.p2align 3
.L724:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rcx, %r8	# out, _29
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:302:        overlaps(out,sizeof *out,i->model->data,i->model->bytes))return leave(i,AYATSURI_MODEL_INVALID);
	movl	$1, %edi	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	subq	%rdx, %r8	# y, _29
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rsi, %r8	# _5, _29
	jb	.L715	#,
	jmp	.L723	#
	.cfi_endproc
.LFE36:
	.size	ayatsuri_model_instance_stats, .-ayatsuri_model_instance_stats
	.p2align 4
	.globl	ayatsuri_model_instance_evaluate
	.type	ayatsuri_model_instance_evaluate, @function
ayatsuri_model_instance_evaluate:
.LFB49:
	.cfi_startproc
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	testq	%rdi, %rdi	# i
	je	.L882	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:557:         uint32_t generation,const float camera[9],const float light[6]){
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:558:     ayatsuri_model_status status=enter(i,owner,generation);if(status)return status;
	movl	$3, %eax	#, <retval>
	movq	%rdi, %r15	# tmp1946, i
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:557:         uint32_t generation,const float camera[9],const float light[6]){
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$1096, %rsp	#,
	.cfi_def_cfa_offset 1152
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpb	$1, 164(%rdi)	#, i_128(D)->alive
	jne	.L746	#,
	testq	%rsi, %rsi	# owner
	je	.L746	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpq	16(%rdi), %rsi	# i_128(D)->owner, owner
	jne	.L746	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpl	32(%rdi), %edx	# i_128(D)->generation, generation
	jne	.L746	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:215:     if(i->busy)return AYATSURI_MODEL_BUSY;
	cmpb	$0, 165(%rdi)	#, i_128(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:558:     ayatsuri_model_status status=enter(i,owner,generation);if(status)return status;
	movl	$4, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:215:     if(i->busy)return AYATSURI_MODEL_BUSY;
	jne	.L746	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	136(%rdi), %eax	# MEM[(uint32_t *)i_128(D) + 136B], iftmp.19_167
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	xorl	%edx, %edx	# tmp1873
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:216:     i->busy=true;return AYATSURI_MODEL_OK;
	movb	$1, 165(%rdi)	#, i_128(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	cmpl	$-1, %eax	#, iftmp.19_167
	setne	%dl	#, tmp1873
	addl	%edx, %eax	# tmp1873, iftmp.19_167
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	%eax, 136(%rdi)	# iftmp.19_167, MEM[(uint32_t *)i_128(D) + 136B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:561:     if(!camera||!light){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}
	testq	%rcx, %rcx	# camera
	je	.L751	#,
	testq	%r8, %r8	# light
	je	.L751	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:560:     bool same=i->evaluated;
	movzbl	166(%rdi), %r9d	# i_128(D)->evaluated, same
	xorl	%eax, %eax	# ivtmp.956
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:562:     for(unsigned k=0;k<9;++k){if(!isfinite(camera[k])){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(camera[k]!=i->camera[k])same=false;}
	xorl	%edi, %edi	# tmp1945
	movss	.LC1(%rip), %xmm14	#, iftmp.26_1507
	movss	.LC0(%rip), %xmm10	#, tmp1837
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:560:     bool same=i->evaluated;
	movl	%r9d, %esi	# same, _1645
	.p2align 6
	.p2align 4
	.p2align 3
.L752:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:562:     for(unsigned k=0;k<9;++k){if(!isfinite(camera[k])){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(camera[k]!=i->camera[k])same=false;}
	movss	(%rcx,%rax), %xmm0	# MEM[(const float *)camera_134(D) + ivtmp.956_1396 * 1], _7
	movaps	%xmm0, %xmm1	# _7, _8
	andps	%xmm10, %xmm1	# tmp1837, _8
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:562:     for(unsigned k=0;k<9;++k){if(!isfinite(camera[k])){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(camera[k]!=i->camera[k])same=false;}
	ucomiss	%xmm1, %xmm14	# _8, iftmp.26_1507
	jb	.L751	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:562:     for(unsigned k=0;k<9;++k){if(!isfinite(camera[k])){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(camera[k]!=i->camera[k])same=false;}
	ucomiss	40(%r15,%rax), %xmm0	# MEM[(float *)i_128(D) + 40B + ivtmp.956_1396 * 1], _7
	setnp	%dl	#, tmp1103
	cmovne	%edi, %edx	# tmp1103,, tmp1945, _1689
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:562:     for(unsigned k=0;k<9;++k){if(!isfinite(camera[k])){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(camera[k]!=i->camera[k])same=false;}
	addq	$4, %rax	#, ivtmp.956
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:562:     for(unsigned k=0;k<9;++k){if(!isfinite(camera[k])){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(camera[k]!=i->camera[k])same=false;}
	andl	%edx, %esi	# _1689, _1645
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:562:     for(unsigned k=0;k<9;++k){if(!isfinite(camera[k])){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(camera[k]!=i->camera[k])same=false;}
	cmpq	$36, %rax	#, ivtmp.956
	jne	.L752	#,
	xorl	%eax, %eax	# ivtmp.938
.L758:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:563:     for(unsigned k=0;k<6;++k){if(!isfinite(light[k])||(k>=3&&!unit(light[k]))){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(light[k]!=i->light[k])same=false;}
	movss	(%r8,%rax,4), %xmm1	# MEM[(const float *)light_135(D) + ivtmp.938_1392 * 4], _13
	movaps	%xmm1, %xmm0	# _13, _14
	andps	%xmm10, %xmm0	# tmp1837, _14
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:563:     for(unsigned k=0;k<6;++k){if(!isfinite(light[k])||(k>=3&&!unit(light[k]))){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(light[k]!=i->light[k])same=false;}
	ucomiss	%xmm0, %xmm14	# _14, iftmp.26_1507
	jb	.L751	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:563:     for(unsigned k=0;k<6;++k){if(!isfinite(light[k])||(k>=3&&!unit(light[k]))){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(light[k]!=i->light[k])same=false;}
	cmpq	$2, %rax	#, ivtmp.938
	jbe	.L1030	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:563:     for(unsigned k=0;k<6;++k){if(!isfinite(light[k])||(k>=3&&!unit(light[k]))){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(light[k]!=i->light[k])same=false;}
	pxor	%xmm0, %xmm0	# _15
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	movsd	.LC22(%rip), %xmm7	#, tmp2294
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:563:     for(unsigned k=0;k<6;++k){if(!isfinite(light[k])||(k>=3&&!unit(light[k]))){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(light[k]!=i->light[k])same=false;}
	cvtss2sd	%xmm1, %xmm0	# _13, _15
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	andpd	.LC8(%rip), %xmm0	#, _164
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	ucomisd	%xmm0, %xmm7	# _164, tmp2294
	jb	.L751	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	pxor	%xmm0, %xmm0	# tmp1118
	comiss	%xmm0, %xmm1	# tmp1118, _13
	jb	.L751	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:19: static bool unit(double n){return isfinite(n)&&n>=0&&n<=1;}
	movss	.LC15(%rip), %xmm7	#, tmp2295
	comiss	%xmm1, %xmm7	# _13, tmp2295
	jnb	.L1031	#,
	.p2align 4
	.p2align 3
.L751:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	xorl	%edx, %edx	#
	movw	%dx, 165(%r15)	#, MEM <vector(2) unsigned char> [(_Bool *)i_128(D) + 165B]
.L782:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:561:     if(!camera||!light){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}
	movl	$1, %eax	#, <retval>
.L746:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:606: }
	addq	$1096, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
	.p2align 4,,10
	.p2align 3
.L1030:
	.cfi_restore_state
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:563:     for(unsigned k=0;k<6;++k){if(!isfinite(light[k])||(k>=3&&!unit(light[k]))){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(light[k]!=i->light[k])same=false;}
	ucomiss	76(%r15,%rax,4), %xmm1	# MEM[(float *)i_128(D) + 76B + ivtmp.938_1392 * 4], _13
	movl	$0, %edi	#, tmp1113
	setnp	%dl	#, tmp1112
	cmovne	%edi, %edx	# tmp1112,, tmp1113, _214
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:563:     for(unsigned k=0;k<6;++k){if(!isfinite(light[k])||(k>=3&&!unit(light[k]))){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(light[k]!=i->light[k])same=false;}
	addq	$1, %rax	#, ivtmp.938
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:563:     for(unsigned k=0;k<6;++k){if(!isfinite(light[k])||(k>=3&&!unit(light[k]))){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(light[k]!=i->light[k])same=false;}
	andl	%edx, %esi	# _214, _1645
	jmp	.L758	#
	.p2align 4,,10
	.p2align 3
.L882:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:558:     ayatsuri_model_status status=enter(i,owner,generation);if(status)return status;
	movl	$3, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:606: }
	ret	
	.p2align 4,,10
	.p2align 3
.L1031:
	.cfi_def_cfa_offset 1152
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:563:     for(unsigned k=0;k<6;++k){if(!isfinite(light[k])||(k>=3&&!unit(light[k]))){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(light[k]!=i->light[k])same=false;}
	ucomiss	76(%r15,%rax,4), %xmm1	# MEM[(float *)i_128(D) + 76B + ivtmp.938_1392 * 4], _13
	movl	$0, %edi	#, tmp1125
	setnp	%dl	#, tmp1124
	cmovne	%edi, %edx	# tmp1124,, tmp1125, _1697
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:563:     for(unsigned k=0;k<6;++k){if(!isfinite(light[k])||(k>=3&&!unit(light[k]))){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(light[k]!=i->light[k])same=false;}
	addq	$1, %rax	#, ivtmp.938
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:563:     for(unsigned k=0;k<6;++k){if(!isfinite(light[k])||(k>=3&&!unit(light[k]))){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(light[k]!=i->light[k])same=false;}
	andl	%edx, %esi	# _1697, _1645
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:563:     for(unsigned k=0;k<6;++k){if(!isfinite(light[k])||(k>=3&&!unit(light[k]))){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}if(light[k]!=i->light[k])same=false;}
	cmpq	$6, %rax	#, ivtmp.938
	jne	.L758	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:564:     if(!(camera[6]>0)){i->evaluated=false;return leave(i,AYATSURI_MODEL_INVALID);}
	movss	24(%rcx), %xmm1	# MEM[(const float *)camera_134(D) + 24B], MEM[(const float *)camera_134(D) + 24B]
	comiss	%xmm0, %xmm1	# tmp1118, MEM[(const float *)camera_134(D) + 24B]
	jbe	.L751	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:565:     if(same)return leave(i,AYATSURI_MODEL_OK);
	testb	%sil, %sil	# _1645
	jne	.L1032	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:571:     const bool light_only=i->evaluated&&!memcmp(camera,i->camera,36)&&
	leaq	40(%r15), %rsi	#, tmp1825
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:572:         !overlaps(camera,36,i,sizeof *i)&&!overlaps(light,24,i,sizeof *i);
	testb	%r9b, %r9b	# same
	je	.L761	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:571:     const bool light_only=i->evaluated&&!memcmp(camera,i->camera,36)&&
	movq	(%rcx), %rax	# MEM <char[1:36]> [(void *)camera_134(D)], tmp2012
	movq	8(%rcx), %rdx	# MEM <char[1:36]> [(void *)camera_134(D)], tmp2014
	xorq	40(%r15), %rax	# MEM <char[1:36]> [(void *)i_128(D) + 40B], tmp2011
	xorq	48(%r15), %rdx	# MEM <char[1:36]> [(void *)i_128(D) + 40B], tmp2013
	orq	%rdx, %rax	# tmp2013, tmp2011
	je	.L1033	#,
.L761:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:583:     i->evaluated=false;memcpy(i->camera,camera,36);memcpy(i->light,light,24);
	movb	$0, 166(%r15)	#, i_128(D)->evaluated
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:583:     i->evaluated=false;memcpy(i->camera,camera,36);memcpy(i->light,light,24);
	movdqu	(%rcx), %xmm0	# MEM <char[1:36]> [(void *)camera_134(D)], MEM <char[1:36]> [(void *)camera_134(D)]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:584:     double fx=(double)camera[0]-camera[3],fy=(double)camera[1]-camera[4],fz=(double)camera[2]-camera[5];
	pxor	%xmm1, %xmm1	# _47
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:583:     i->evaluated=false;memcpy(i->camera,camera,36);memcpy(i->light,light,24);
	movq	%r8, 24(%rsp)	# light, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:583:     i->evaluated=false;memcpy(i->camera,camera,36);memcpy(i->light,light,24);
	movups	%xmm0, 40(%r15)	# MEM <char[1:36]> [(void *)camera_134(D)], MEM <char[1:36]> [(void *)i_128(D) + 40B]
	movdqu	16(%rcx), %xmm0	# MEM <char[1:36]> [(void *)camera_134(D)], MEM <char[1:36]> [(void *)camera_134(D)]
	movups	%xmm0, 16(%rsi)	# MEM <char[1:36]> [(void *)camera_134(D)], MEM <char[1:36]> [(void *)i_128(D) + 40B]
	movl	32(%rcx), %eax	# MEM <char[1:36]> [(void *)camera_134(D)], MEM <char[1:36]> [(void *)camera_134(D)]
	movl	%eax, 32(%rsi)	# MEM <char[1:36]> [(void *)camera_134(D)], MEM <char[1:36]> [(void *)i_128(D) + 40B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:583:     i->evaluated=false;memcpy(i->camera,camera,36);memcpy(i->light,light,24);
	movdqu	(%r8), %xmm0	# MEM <char[1:24]> [(void *)light_135(D)], MEM <char[1:24]> [(void *)light_135(D)]
	movups	%xmm0, 76(%r15)	# MEM <char[1:24]> [(void *)light_135(D)], MEM <char[1:24]> [(void *)i_128(D) + 76B]
	movq	16(%r8), %rax	# MEM <char[1:24]> [(void *)light_135(D)], MEM <char[1:24]> [(void *)light_135(D)]
	movq	%rax, 92(%r15)	# MEM <char[1:24]> [(void *)light_135(D)], MEM <char[1:24]> [(void *)i_128(D) + 76B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:584:     double fx=(double)camera[0]-camera[3],fy=(double)camera[1]-camera[4],fz=(double)camera[2]-camera[5];
	cvtps2pd	12(%rcx), %xmm0	# MEM <const vector(2) float> [(const float *)camera_134(D) + 12B], vect__40.687_727
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:584:     double fx=(double)camera[0]-camera[3],fy=(double)camera[1]-camera[4],fz=(double)camera[2]-camera[5];
	cvtps2pd	(%rcx), %xmm2	# MEM <const vector(2) float> [(const float *)camera_134(D)], vect__38.683_22
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:584:     double fx=(double)camera[0]-camera[3],fy=(double)camera[1]-camera[4],fz=(double)camera[2]-camera[5];
	subpd	%xmm0, %xmm2	# vect__40.687_727, vect_fx_139.688
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:584:     double fx=(double)camera[0]-camera[3],fy=(double)camera[1]-camera[4],fz=(double)camera[2]-camera[5];
	pxor	%xmm0, %xmm0	# _49
	cvtss2sd	20(%rcx), %xmm0	# MEM[(const float *)camera_134(D) + 20B], _49
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:584:     double fx=(double)camera[0]-camera[3],fy=(double)camera[1]-camera[4],fz=(double)camera[2]-camera[5];
	cvtss2sd	8(%rcx), %xmm1	# MEM[(const float *)camera_134(D) + 8B], _47
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:584:     double fx=(double)camera[0]-camera[3],fy=(double)camera[1]-camera[4],fz=(double)camera[2]-camera[5];
	subsd	%xmm0, %xmm1	# _49, _47
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:308: static double hypot3(double x,double y,double z){return hypot(hypot(x,y),z);}
	movapd	%xmm2, %xmm7	# vect_fx_139.688, vect_fx_139.688
	unpckhpd	%xmm7, %xmm7	# vect_fx_139.688
	movapd	%xmm2, %xmm0	# vect_fx_139.688, _724
	movaps	%xmm2, (%rsp)	# vect_fx_139.688, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:584:     double fx=(double)camera[0]-camera[3],fy=(double)camera[1]-camera[4],fz=(double)camera[2]-camera[5];
	movq	%xmm1, %rbx	# _47, fz
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:308: static double hypot3(double x,double y,double z){return hypot(hypot(x,y),z);}
	movapd	%xmm7, %xmm1	# vect_fx_139.688,
	call	hypot@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:308: static double hypot3(double x,double y,double z){return hypot(hypot(x,y),z);}
	movq	%rbx, %xmm1	# fz,
	call	hypot@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:586:     if(!(distance>0)||!isfinite(distance))return leave(i,AYATSURI_MODEL_INVALID);
	pxor	%xmm1, %xmm1	# tmp1149
	movapd	(%rsp), %xmm2	# %sfp, vect_fx_139.688
	movq	24(%rsp), %r8	# %sfp, light
	comisd	%xmm1, %xmm0	# tmp1149, _288
	jbe	.L769	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:586:     if(!(distance>0)||!isfinite(distance))return leave(i,AYATSURI_MODEL_INVALID);
	movsd	.LC22(%rip), %xmm6	#, tmp2304
	ucomisd	%xmm0, %xmm6	# _288, tmp2304
	jb	.L769	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:587:     fx/=distance;fy/=distance;fz/=distance;
	movapd	%xmm0, %xmm1	# _288, _722
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:587:     fx/=distance;fy/=distance;fz/=distance;
	movq	%rbx, %xmm3	# fz, fz
	movq	%r8, 56(%rsp)	# light, %sfp
	divsd	%xmm0, %xmm3	# _288, fz
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:587:     fx/=distance;fy/=distance;fz/=distance;
	unpcklpd	%xmm1, %xmm1	# _722
	divpd	%xmm1, %xmm2	# _722, vect_fx_139.688
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:588:     double rx=fz,rz=-fx,length=hypot(rx,rz);
	movapd	%xmm3, %xmm0	# fz,
	movsd	%xmm3, (%rsp)	# fz, %sfp
	movapd	%xmm2, %xmm5	# vect_fx_144.689, vect_fx_144.689
	movapd	%xmm2, %xmm1	# vect_fx_144.689, _1584
	movaps	%xmm2, 32(%rsp)	# vect_fx_144.689, %sfp
	unpckhpd	%xmm5, %xmm5	# vect_fx_144.689
	movsd	%xmm2, 24(%rsp)	# _1584, %sfp
	movsd	%xmm5, 48(%rsp)	# _485, %sfp
	call	hypot@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:589:     if(length<1e-6){rx=1;rz=0;length=1;}rx/=length;rz/=length;
	movsd	(%rsp), %xmm3	# %sfp, fz
	movq	56(%rsp), %r8	# %sfp, light
	movss	.LC0(%rip), %xmm10	#, tmp1837
	movsd	.LC37(%rip), %xmm2	#, tmp1163
	movsd	24(%rsp), %xmm1	# %sfp, _1584
	movapd	32(%rsp), %xmm4	# %sfp, vect_fx_144.689
	movsd	48(%rsp), %xmm5	# %sfp, _485
	movss	.LC1(%rip), %xmm14	#, iftmp.26_1507
	comisd	%xmm0, %xmm2	# length, tmp1163
	ja	.L888	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:589:     if(length<1e-6){rx=1;rz=0;length=1;}rx/=length;rz/=length;
	movapd	%xmm3, %xmm6	# fz, _2291
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:588:     double rx=fz,rz=-fx,length=hypot(rx,rz);
	movq	.LC26(%rip), %xmm7	#, tmp1830
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:591:         down[3]={(float)(fy*rz),(float)(fz*rx-fx*rz),(float)(-fy*rx)};
	movapd	%xmm3, %xmm8	# fz, _2299
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:590:     const float forward[3]={(float)fx,(float)fy,(float)fz},right[3]={(float)rx,0,(float)rz},
	pxor	%xmm2, %xmm2	# _2293
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:589:     if(length<1e-6){rx=1;rz=0;length=1;}rx/=length;rz/=length;
	divsd	%xmm0, %xmm6	# length, _2291
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:588:     double rx=fz,rz=-fx,length=hypot(rx,rz);
	movaps	%xmm7, 128(%rsp)	# tmp1830, %sfp
	xorpd	%xmm1, %xmm7	# _1584, tmp1830
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:589:     if(length<1e-6){rx=1;rz=0;length=1;}rx/=length;rz/=length;
	divsd	%xmm0, %xmm7	# length, _2295
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:590:     const float forward[3]={(float)fx,(float)fy,(float)fz},right[3]={(float)rx,0,(float)rz},
	pxor	%xmm0, %xmm0	# _2297
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:591:         down[3]={(float)(fy*rz),(float)(fz*rx-fx*rz),(float)(-fy*rx)};
	mulsd	%xmm6, %xmm8	# _2291, _2299
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:590:     const float forward[3]={(float)fx,(float)fy,(float)fz},right[3]={(float)rx,0,(float)rz},
	cvtsd2ss	%xmm6, %xmm2	# _2291, _2293
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:590:     const float forward[3]={(float)fx,(float)fy,(float)fz},right[3]={(float)rx,0,(float)rz},
	cvtsd2ss	%xmm7, %xmm0	# _2295, _2297
.L783:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:591:         down[3]={(float)(fy*rz),(float)(fz*rx-fx*rz),(float)(-fy*rx)};
	mulsd	%xmm7, %xmm1	# _2295, _59
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:590:     const float forward[3]={(float)fx,(float)fy,(float)fz},right[3]={(float)rx,0,(float)rz},
	cvtpd2ps	%xmm4, %xmm4	# vect_fx_144.689, vect__51.690
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:593:     for(unsigned j=0;j<i->model->node_count;++j){
	movq	(%r15), %rax	# i_128(D)->model, _95
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:590:     const float forward[3]={(float)fx,(float)fy,(float)fz},right[3]={(float)rx,0,(float)rz},
	cvtsd2ss	%xmm3, %xmm3	# fz, _53
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:590:     const float forward[3]={(float)fx,(float)fy,(float)fz},right[3]={(float)rx,0,(float)rz},
	movss	%xmm0, 492(%rsp)	# _2297, right[2]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:591:         down[3]={(float)(fy*rz),(float)(fz*rx-fx*rz),(float)(-fy*rx)};
	movapd	%xmm5, %xmm0	# _485, _56
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:591:         down[3]={(float)(fy*rz),(float)(fz*rx-fx*rz),(float)(-fy*rx)};
	xorpd	128(%rsp), %xmm5	# %sfp, _485
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:591:         down[3]={(float)(fy*rz),(float)(fz*rx-fx*rz),(float)(-fy*rx)};
	mulsd	%xmm7, %xmm0	# _2295, _56
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:593:     for(unsigned j=0;j<i->model->node_count;++j){
	cmpw	$0, 12(%rax)	#, _1693->node_count
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:590:     const float forward[3]={(float)fx,(float)fy,(float)fz},right[3]={(float)rx,0,(float)rz},
	movlps	%xmm4, 456(%rsp)	# vect__51.690, MEM <vector(2) float> [(float *)&forward]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:590:     const float forward[3]={(float)fx,(float)fy,(float)fz},right[3]={(float)rx,0,(float)rz},
	movl	$0x00000000, 488(%rsp)	#, right[1]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:590:     const float forward[3]={(float)fx,(float)fy,(float)fz},right[3]={(float)rx,0,(float)rz},
	movss	%xmm3, 464(%rsp)	# _53, forward[2]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:590:     const float forward[3]={(float)fx,(float)fy,(float)fz},right[3]={(float)rx,0,(float)rz},
	movss	%xmm2, 484(%rsp)	# _2293, right[0]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:591:         down[3]={(float)(fy*rz),(float)(fz*rx-fx*rz),(float)(-fy*rx)};
	subsd	%xmm1, %xmm8	# _59, _60
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:591:         down[3]={(float)(fy*rz),(float)(fz*rx-fx*rz),(float)(-fy*rx)};
	unpcklpd	%xmm8, %xmm0	# _60, _477
	cvtpd2ps	%xmm0, %xmm0	# _477, tmp1171
	movlps	%xmm0, 472(%rsp)	# tmp1171, MEM <vector(2) float> [(float *)&down]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:591:         down[3]={(float)(fy*rz),(float)(fz*rx-fx*rz),(float)(-fy*rx)};
	movapd	%xmm5, %xmm0	# _485, _62
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:591:         down[3]={(float)(fy*rz),(float)(fz*rx-fx*rz),(float)(-fy*rx)};
	mulsd	%xmm6, %xmm0	# _2291, _63
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:591:         down[3]={(float)(fy*rz),(float)(fz*rx-fx*rz),(float)(-fy*rx)};
	cvtsd2ss	%xmm0, %xmm0	# _63, tmp1176
	movss	%xmm0, 480(%rsp)	# tmp1176, down[2]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:592:     for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[3+k]=forward[k];i->lighting[6+k]=light[3+k];}
	movss	(%r8), %xmm0	# *light_135(D), _464
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:592:     for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[3+k]=forward[k];i->lighting[6+k]=light[3+k];}
	movss	%xmm4, 112(%r15)	# vect__51.690, i_128(D)->lighting[3]
	shufps	$0xe5, %xmm4, %xmm4	# vect__51.690
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:592:     for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[3+k]=forward[k];i->lighting[6+k]=light[3+k];}
	movss	%xmm0, 100(%r15)	# _464, i_128(D)->lighting[0]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:592:     for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[3+k]=forward[k];i->lighting[6+k]=light[3+k];}
	movss	12(%r8), %xmm0	# MEM[(const float *)light_135(D) + 12B], _811
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:592:     for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[3+k]=forward[k];i->lighting[6+k]=light[3+k];}
	movss	%xmm0, 124(%r15)	# _811, i_128(D)->lighting[6]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:592:     for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[3+k]=forward[k];i->lighting[6+k]=light[3+k];}
	movss	4(%r8), %xmm0	# MEM[(const float *)light_135(D) + 4B], _110
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:592:     for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[3+k]=forward[k];i->lighting[6+k]=light[3+k];}
	movss	%xmm4, 116(%r15)	# vect__51.690, i_128(D)->lighting[4]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:592:     for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[3+k]=forward[k];i->lighting[6+k]=light[3+k];}
	movss	%xmm0, 104(%r15)	# _110, i_128(D)->lighting[1]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:592:     for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[3+k]=forward[k];i->lighting[6+k]=light[3+k];}
	movss	16(%r8), %xmm0	# MEM[(const float *)light_135(D) + 16B], _732
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:592:     for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[3+k]=forward[k];i->lighting[6+k]=light[3+k];}
	movss	%xmm0, 128(%r15)	# _732, i_128(D)->lighting[7]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:592:     for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[3+k]=forward[k];i->lighting[6+k]=light[3+k];}
	movss	8(%r8), %xmm0	# MEM[(const float *)light_135(D) + 8B], _68
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:592:     for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[3+k]=forward[k];i->lighting[6+k]=light[3+k];}
	movss	%xmm3, 120(%r15)	# _53, i_128(D)->lighting[5]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:592:     for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[3+k]=forward[k];i->lighting[6+k]=light[3+k];}
	movss	%xmm0, 108(%r15)	# _68, i_128(D)->lighting[2]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:592:     for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[3+k]=forward[k];i->lighting[6+k]=light[3+k];}
	movss	20(%r8), %xmm0	# MEM[(const float *)light_135(D) + 20B], _75
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:592:     for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[3+k]=forward[k];i->lighting[6+k]=light[3+k];}
	movss	%xmm0, 132(%r15)	# _75, i_128(D)->lighting[8]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:593:     for(unsigned j=0;j<i->model->node_count;++j){
	je	.L779	#,
	leaq	472(%rsp), %rcx	#, tmp1826
	leaq	484(%rsp), %rbx	#, tmp1827
	xorl	%r13d, %r13d	# ivtmp.929
	movq	%rcx, 376(%rsp)	# tmp1826, %sfp
	movq	%rbx, %xmm7	# tmp1827, _1327
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:78:         candidate.m[k]=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;
	movq	%r13, %r10	# ivtmp.929, ivtmp.929
	leaq	592(%rsp), %r14	#, ivtmp.927
	movq	%rbx, 384(%rsp)	# tmp1827, %sfp
	leaq	604(%rsp), %rbx	#, _159
	movq	%r14, %r11	# ivtmp.927, ivtmp.927
	movq	%rbx, 120(%rsp)	# _159, %sfp
	movhps	376(%rsp), %xmm7	# %sfp, _1327
	movaps	%xmm7, 416(%rsp)	# _1327, %sfp
	.p2align 4
	.p2align 3
.L881:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	20(%rax), %r12d	# _1678->section[0].offset, _239
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movq	8(%r15), %rbp	# i_128(D)->arena, pretmp_2395
	movq	%r10, %rcx	# ivtmp.929, _152
	leaq	(%r10,%r10,2), %r8	#, _1363
	salq	$4, %rcx	#, _152
	leaq	0(,%r8,8), %rdx	#, tmp1188
	movl	%r10d, 24(%rsp)	# ivtmp.929, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rcx, %r12	# _152, _242
	addq	(%rax), %r12	# _1678->data, _243
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	leaq	0(%rbp,%rdx), %rax	#, _2398
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movl	8(%rax), %edi	# _2398->offset, _2400
	movzwl	(%r12), %esi	# MEM <short unsigned int> [(const uint8_t *)_243],
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:595:         ayatsuri_pose pose;ayatsuri_transform p,result;memcpy(&pose,work(i,j)+12,36);
	leaq	48(%rbp,%rdi), %rdi	#, _2402
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:16: static int parent_id(const uint8_t *p){const uint16_t x=m16(p);return x<=INT16_MAX?(int)x:(int)x-65536;}
	testw	%si, %si	# load_dst_1661
	js	.L784	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:595:         ayatsuri_pose pose;ayatsuri_transform p,result;memcpy(&pose,work(i,j)+12,36);
	movdqu	(%rdi), %xmm0	# MEM <char[1:36]> [(void *)_2402], MEM <char[1:36]> [(void *)_2402]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:16: static int parent_id(const uint8_t *p){const uint16_t x=m16(p);return x<=INT16_MAX?(int)x:(int)x-65536;}
	movzwl	%si, %r9d	# load_dst_1661, iftmp.7_233
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	leaq	(%rsi,%rsi,2), %rsi	#, tmp1200
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:597:         if(ayatsuri_transform_evaluate(&pose,parent<0?NULL:&p,&result)!=AYATSURI_OK)return leave(i,AYATSURI_MODEL_RANGE);
	leaq	640(%rsp), %rbx	#, iftmp.22_112
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movl	8(%rbp,%rsi,8), %esi	# _246->offset, _248
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:595:         ayatsuri_pose pose;ayatsuri_transform p,result;memcpy(&pose,work(i,j)+12,36);
	movaps	%xmm0, (%r11)	# MEM <char[1:36]> [(void *)_2402], MEM <char[1:36]> [(void *)&pose]
	movdqu	16(%rdi), %xmm0	# MEM <char[1:36]> [(void *)_2402], MEM <char[1:36]> [(void *)_2402]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	addq	%rbp, %rsi	# pretmp_2395, _249
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:595:         ayatsuri_pose pose;ayatsuri_transform p,result;memcpy(&pose,work(i,j)+12,36);
	movaps	%xmm0, 16(%r11)	# MEM <char[1:36]> [(void *)_2402], MEM <char[1:36]> [(void *)&pose]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:596:         if(parent>=0)memcpy(&p,work(i,(unsigned)parent),48);
	movdqu	(%rsi), %xmm0	# MEM <char[1:48]> [(void *)_249], MEM <char[1:48]> [(void *)_249]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:595:         ayatsuri_pose pose;ayatsuri_transform p,result;memcpy(&pose,work(i,j)+12,36);
	movl	32(%rdi), %edi	# MEM <char[1:36]> [(void *)_2402], MEM <char[1:36]> [(void *)_2402]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:596:         if(parent>=0)memcpy(&p,work(i,(unsigned)parent),48);
	movaps	%xmm0, 640(%rsp)	# MEM <char[1:48]> [(void *)_249], MEM <char[1:48]> [(void *)&p]
	movdqu	16(%rsi), %xmm0	# MEM <char[1:48]> [(void *)_249], MEM <char[1:48]> [(void *)_249]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:595:         ayatsuri_pose pose;ayatsuri_transform p,result;memcpy(&pose,work(i,j)+12,36);
	movl	%edi, 32(%r11)	# MEM <char[1:36]> [(void *)_2402], MEM <char[1:36]> [(void *)&pose]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:596:         if(parent>=0)memcpy(&p,work(i,(unsigned)parent),48);
	movaps	%xmm0, 656(%rsp)	# MEM <char[1:48]> [(void *)_249], MEM <char[1:48]> [(void *)&p]
	movdqu	32(%rsi), %xmm0	# MEM <char[1:48]> [(void *)_249], MEM <char[1:48]> [(void *)_249]
	movaps	%xmm0, 672(%rsp)	# MEM <char[1:48]> [(void *)_249], MEM <char[1:48]> [(void *)&p]
.L785:
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:47:            !isfinite(pose->scale[k])||pose->scale[k]==0)return AYATSURI_INVALID;
	movq	120(%rsp), %rdi	# %sfp, _159
	movq	%r11, %rsi	# ivtmp.927, ivtmp.927
	pxor	%xmm2, %xmm2	# tmp1940
.L788:
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:46:         if(!isfinite(pose->position[k])||!isfinite(pose->rotation[k])||
	movss	(%rsi), %xmm0	# MEM[(float *)_1525], MEM[(float *)_1525]
	andps	%xmm10, %xmm0	# tmp1837, _294
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:46:         if(!isfinite(pose->position[k])||!isfinite(pose->rotation[k])||
	ucomiss	%xmm0, %xmm14	# _294, iftmp.26_1507
	jb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:46:         if(!isfinite(pose->position[k])||!isfinite(pose->rotation[k])||
	movss	12(%rsi), %xmm0	# MEM[(float *)_1525 + 12B], MEM[(float *)_1525 + 12B]
	andps	%xmm10, %xmm0	# tmp1837, _296
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:46:         if(!isfinite(pose->position[k])||!isfinite(pose->rotation[k])||
	ucomiss	%xmm0, %xmm14	# _296, iftmp.26_1507
	jb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:47:            !isfinite(pose->scale[k])||pose->scale[k]==0)return AYATSURI_INVALID;
	movss	24(%rsi), %xmm0	# MEM[(float *)_1525 + 24B], _297
	movaps	%xmm0, %xmm1	# _297, _298
	andps	%xmm10, %xmm1	# tmp1837, _298
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:46:         if(!isfinite(pose->position[k])||!isfinite(pose->rotation[k])||
	ucomiss	%xmm1, %xmm14	# _298, iftmp.26_1507
	jb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:47:            !isfinite(pose->scale[k])||pose->scale[k]==0)return AYATSURI_INVALID;
	ucomiss	%xmm2, %xmm0	# tmp1940, _297
	jp	.L905	#,
	je	.L801	#,
.L905:
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:45:     for(unsigned k=0;k<3;++k)
	addq	$4, %rsi	#, ivtmp.927
	cmpq	%rsi, %rdi	# ivtmp.927, _159
	jne	.L788	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:48:     if(parent)for(unsigned k=0;k<12;++k)
	testq	%rbx, %rbx	# iftmp.22_112
	je	.L789	#,
	movq	%rbx, %rsi	# iftmp.22_112, ivtmp.920
	leaq	48(%rbx), %rdi	#, _1530
	.p2align 5
	.p2align 4
	.p2align 3
.L790:
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:49:         if(!isfinite(parent->m[k]))return AYATSURI_INVALID;
	movss	(%rsi), %xmm0	# MEM[(float *)_1532], MEM[(float *)_1532]
	andps	%xmm10, %xmm0	# tmp1837, _302
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:49:         if(!isfinite(parent->m[k]))return AYATSURI_INVALID;
	ucomiss	%xmm0, %xmm14	# _302, iftmp.26_1507
	jb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:48:     if(parent)for(unsigned k=0;k<12;++k)
	addq	$4, %rsi	#, ivtmp.920
	cmpq	%rsi, %rdi	# ivtmp.920, _1530
	jne	.L790	#,
.L789:
	leaq	440(%rsp), %r13	#, tmp1230
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:51:     const double x=pose->rotation[0],y=pose->rotation[1],z=pose->rotation[2],
	pxor	%xmm0, %xmm0	# x_305
	movq	%r11, 112(%rsp)	# ivtmp.927, %sfp
	leaq	432(%rsp), %r14	#, tmp1231
	movq	%r14, %rsi	# tmp1231,
	movq	%r13, %rdi	# tmp1230,
	movq	%r10, 104(%rsp)	# ivtmp.929, %sfp
	cvtss2sd	604(%rsp), %xmm0	# pose.rotation[0], x_305
	movq	%rdx, 96(%rsp)	# tmp1188, %sfp
	movq	%r8, 88(%rsp)	# _1363, %sfp
	movq	%rax, 80(%rsp)	# _2398, %sfp
	movl	%r9d, 72(%rsp)	# iftmp.7_233, %sfp
	movq	%rcx, 64(%rsp)	# _152, %sfp
	call	sincos@PLT	#
	movq	%r14, %rsi	# tmp1231,
	movq	%r13, %rdi	# tmp1230,
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:51:     const double x=pose->rotation[0],y=pose->rotation[1],z=pose->rotation[2],
	pxor	%xmm0, %xmm0	# y_307
	movsd	432(%rsp), %xmm2	#, sincostmp_108
	movsd	440(%rsp), %xmm9	#, sincostmp_108
	cvtss2sd	608(%rsp), %xmm0	# pose.rotation[1], y_307
	movsd	%xmm2, 56(%rsp)	# sincostmp_108, %sfp
	movsd	%xmm9, 48(%rsp)	# sincostmp_108, %sfp
	call	sincos@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:51:     const double x=pose->rotation[0],y=pose->rotation[1],z=pose->rotation[2],
	pxor	%xmm0, %xmm0	# z_309
	movq	%r14, %rsi	# tmp1231,
	movq	%r13, %rdi	# tmp1230,
	movsd	432(%rsp), %xmm7	#, sincostmp_107
	movsd	440(%rsp), %xmm4	#, sincostmp_107
	cvtss2sd	612(%rsp), %xmm0	# pose.rotation[2], z_309
	movsd	%xmm7, 32(%rsp)	# sincostmp_107, %sfp
	movsd	%xmm4, (%rsp)	# sincostmp_107, %sfp
	call	sincos@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	movsd	(%rsp), %xmm4	# %sfp, sincostmp_107
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	pxor	%xmm12, %xmm12	# _318
	movsd	432(%rsp), %xmm0	#, sincostmp_113
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	movsd	48(%rsp), %xmm9	# %sfp, sincostmp_108
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	movsd	56(%rsp), %xmm2	# %sfp, sincostmp_108
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:58:     if(!parent){
	testq	%rbx, %rbx	# iftmp.22_112
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	cvtps2pd	616(%rsp), %xmm11	# MEM <const vector(2) float> [(float *)&pose + 24B], vect__318.700
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	movapd	%xmm4, %xmm3	# sincostmp_107, _320
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	movsd	32(%rsp), %xmm7	# %sfp, sincostmp_107
	movsd	440(%rsp), %xmm1	#, sincostmp_113
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	cvtss2sd	616(%rsp), %xmm12	# pose.scale[0], _318
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	mulsd	%xmm0, %xmm3	# sincostmp_113, _320
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	movapd	%xmm9, %xmm6	# sincostmp_108, _321
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	movapd	%xmm2, %xmm8	# sincostmp_108, _322
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:58:     if(!parent){
	movq	64(%rsp), %rcx	# %sfp, _152
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	mulsd	%xmm1, %xmm8	# sincostmp_113, _322
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	movapd	%xmm7, %xmm5	# sincostmp_107, _316
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:55:         e=(sz*sy*sx+cz*cx)*pose->scale[1],f=(sz*sy*cx-cz*sx)*pose->scale[2],
	movapd	%xmm9, %xmm13	# sincostmp_108, _336
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:58:     if(!parent){
	movslq	72(%rsp), %r9	# %sfp,
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	mulsd	%xmm0, %xmm5	# sincostmp_113, _316
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:55:         e=(sz*sy*sx+cz*cx)*pose->scale[1],f=(sz*sy*cx-cz*sx)*pose->scale[2],
	movapd	%xmm2, %xmm15	# sincostmp_108, _337
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:58:     if(!parent){
	movq	80(%rsp), %rax	# %sfp, _2398
	movq	88(%rsp), %r8	# %sfp, _1363
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:55:         e=(sz*sy*sx+cz*cx)*pose->scale[1],f=(sz*sy*cx-cz*sx)*pose->scale[2],
	mulsd	%xmm0, %xmm15	# sincostmp_113, _337
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:58:     if(!parent){
	movq	96(%rsp), %rdx	# %sfp, tmp1188
	movq	104(%rsp), %r10	# %sfp, ivtmp.929
	movss	.LC0(%rip), %xmm10	#, tmp1837
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:55:         e=(sz*sy*sx+cz*cx)*pose->scale[1],f=(sz*sy*cx-cz*sx)*pose->scale[2],
	mulsd	%xmm9, %xmm0	# sincostmp_108, _341
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:58:     if(!parent){
	movq	112(%rsp), %r11	# %sfp, ivtmp.927
	movss	.LC1(%rip), %xmm14	#, iftmp.26_1507
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	mulsd	%xmm3, %xmm6	# _320, _321
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:54:         c=(cz*sy*cx+sz*sx)*pose->scale[2],d=sz*cy*pose->scale[0],
	mulsd	%xmm2, %xmm3	# sincostmp_108, _327
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	mulsd	%xmm12, %xmm5	# _318, a_319
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	subsd	%xmm8, %xmm6	# _322, _323
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	movapd	%xmm11, %xmm8	# vect__318.700, vect__318.700
	unpckhpd	%xmm8, %xmm8	# vect__318.700
	mulsd	%xmm8, %xmm6	# _773, b_326
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:54:         c=(cz*sy*cx+sz*sx)*pose->scale[2],d=sz*cy*pose->scale[0],
	pxor	%xmm8, %xmm8	# _331
	cvtss2sd	624(%rsp), %xmm8	# pose.scale[2], _331
	unpcklpd	%xmm6, %xmm5	# b_326, _832
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:54:         c=(cz*sy*cx+sz*sx)*pose->scale[2],d=sz*cy*pose->scale[0],
	movapd	%xmm9, %xmm6	# sincostmp_108, _328
	mulsd	%xmm1, %xmm6	# sincostmp_113, _328
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:54:         c=(cz*sy*cx+sz*sx)*pose->scale[2],d=sz*cy*pose->scale[0],
	addsd	%xmm6, %xmm3	# _328, _329
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:54:         c=(cz*sy*cx+sz*sx)*pose->scale[2],d=sz*cy*pose->scale[0],
	movapd	%xmm7, %xmm6	# sincostmp_107, _333
	mulsd	%xmm1, %xmm6	# sincostmp_113, _333
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:55:         e=(sz*sy*sx+cz*cx)*pose->scale[1],f=(sz*sy*cx-cz*sx)*pose->scale[2],
	mulsd	%xmm4, %xmm1	# sincostmp_107, _335
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:56:         g=-sy*pose->scale[0],h=cy*sx*pose->scale[1],j=cy*cx*pose->scale[2];
	xorpd	128(%rsp), %xmm4	# %sfp, _344
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:54:         c=(cz*sy*cx+sz*sx)*pose->scale[2],d=sz*cy*pose->scale[0],
	mulsd	%xmm8, %xmm3	# _331, c
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:55:         e=(sz*sy*sx+cz*cx)*pose->scale[1],f=(sz*sy*cx-cz*sx)*pose->scale[2],
	mulsd	%xmm1, %xmm13	# _335, _336
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:55:         e=(sz*sy*sx+cz*cx)*pose->scale[1],f=(sz*sy*cx-cz*sx)*pose->scale[2],
	mulsd	%xmm2, %xmm1	# sincostmp_108, _340
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:56:         g=-sy*pose->scale[0],h=cy*sx*pose->scale[1],j=cy*cx*pose->scale[2];
	mulsd	%xmm7, %xmm2	# sincostmp_107, _348
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:55:         e=(sz*sy*sx+cz*cx)*pose->scale[1],f=(sz*sy*cx-cz*sx)*pose->scale[2],
	addsd	%xmm15, %xmm13	# _337, _338
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:55:         e=(sz*sy*sx+cz*cx)*pose->scale[1],f=(sz*sy*cx-cz*sx)*pose->scale[2],
	subsd	%xmm0, %xmm1	# _341, _342
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:56:         g=-sy*pose->scale[0],h=cy*sx*pose->scale[1],j=cy*cx*pose->scale[2];
	movapd	%xmm9, %xmm0	# sincostmp_108, sincostmp_108
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:61:         world[8]=g;world[9]=h;world[10]=j;world[11]=pose->position[2];
	pxor	%xmm9, %xmm9	# _2394
	cvtss2sd	600(%rsp), %xmm9	# pose.position[2], _2394
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:56:         g=-sy*pose->scale[0],h=cy*sx*pose->scale[1],j=cy*cx*pose->scale[2];
	mulsd	%xmm7, %xmm0	# sincostmp_107, sincostmp_108
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:59:         world[0]=a;world[1]=b;world[2]=c;world[3]=pose->position[0];
	pxor	%xmm7, %xmm7	# _2390
	cvtss2sd	592(%rsp), %xmm7	# pose.position[0], _2390
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:56:         g=-sy*pose->scale[0],h=cy*sx*pose->scale[1],j=cy*cx*pose->scale[2];
	mulsd	%xmm8, %xmm2	# _331, j
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:55:         e=(sz*sy*sx+cz*cx)*pose->scale[1],f=(sz*sy*cx-cz*sx)*pose->scale[2],
	mulsd	%xmm8, %xmm1	# _331, f
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:60:         world[4]=d;world[5]=e;world[6]=f;world[7]=pose->position[1];
	pxor	%xmm8, %xmm8	# _2392
	cvtss2sd	596(%rsp), %xmm8	# pose.position[1], _2392
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:58:     if(!parent){
	je	.L1034	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:54:         c=(cz*sy*cx+sz*sx)*pose->scale[2],d=sz*cy*pose->scale[0],
	unpcklpd	%xmm13, %xmm6	# _338, _774
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:56:         g=-sy*pose->scale[0],h=cy*sx*pose->scale[1],j=cy*cx*pose->scale[2];
	unpcklpd	%xmm0, %xmm4	# _346, _789
	leaq	912(%rsp), %r13	#, ivtmp.780
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:54:         c=(cz*sy*cx+sz*sx)*pose->scale[2],d=sz*cy*pose->scale[0],
	mulpd	%xmm11, %xmm6	# vect__318.700, vect_d_334.701
	movq	%r13, %rsi	# ivtmp.780, ivtmp.913
	leaq	48(%rbx), %rdi	#, _1543
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:56:         g=-sy*pose->scale[0],h=cy*sx*pose->scale[1],j=cy*cx*pose->scale[2];
	mulpd	%xmm11, %xmm4	# vect__318.700, vect_g_345.704
.L793:
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:64:         world[k]=p[k]*a+p[k+1]*d+p[k+2]*g;
	pxor	%xmm0, %xmm0	# _362
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:64:         world[k]=p[k]*a+p[k+1]*d+p[k+2]*g;
	pxor	%xmm12, %xmm12	# _369
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:62:     }else for(unsigned k=0;k<12;k+=4){
	addq	$16, %rbx	#, ivtmp.912
	addq	$32, %rsi	#, ivtmp.913
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:64:         world[k]=p[k]*a+p[k+1]*d+p[k+2]*g;
	cvtss2sd	-16(%rbx), %xmm0	# MEM[(const float *)_1552], _362
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:64:         world[k]=p[k]*a+p[k+1]*d+p[k+2]*g;
	cvtss2sd	-12(%rbx), %xmm12	# MEM[(const float *)_1552 + 4B], _369
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:64:         world[k]=p[k]*a+p[k+1]*d+p[k+2]*g;
	movapd	%xmm0, %xmm13	# _362, _474
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:64:         world[k]=p[k]*a+p[k+1]*d+p[k+2]*g;
	movapd	%xmm12, %xmm15	# _369, _786
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:64:         world[k]=p[k]*a+p[k+1]*d+p[k+2]*g;
	unpcklpd	%xmm13, %xmm13	# _474
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:64:         world[k]=p[k]*a+p[k+1]*d+p[k+2]*g;
	unpcklpd	%xmm15, %xmm15	# _786
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:64:         world[k]=p[k]*a+p[k+1]*d+p[k+2]*g;
	pxor	%xmm11, %xmm11	# _377
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:64:         world[k]=p[k]*a+p[k+1]*d+p[k+2]*g;
	mulpd	%xmm6, %xmm15	# vect_d_334.701, vect__370.702_787
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:64:         world[k]=p[k]*a+p[k+1]*d+p[k+2]*g;
	cvtss2sd	-8(%rbx), %xmm11	# MEM[(const float *)_1552 + 8B], _377
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:64:         world[k]=p[k]*a+p[k+1]*d+p[k+2]*g;
	mulpd	%xmm5, %xmm13	# _832, vect__363.696_473
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:64:         world[k]=p[k]*a+p[k+1]*d+p[k+2]*g;
	addpd	%xmm15, %xmm13	# vect__370.702_787, vect__371.703_788
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:64:         world[k]=p[k]*a+p[k+1]*d+p[k+2]*g;
	movapd	%xmm11, %xmm15	# _377, _816
	unpcklpd	%xmm15, %xmm15	# _816
	mulpd	%xmm4, %xmm15	# vect_g_345.704, vect__378.705_817
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:64:         world[k]=p[k]*a+p[k+1]*d+p[k+2]*g;
	addpd	%xmm15, %xmm13	# vect__378.705_817, vect__379.706_818
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:66:         world[k+2]=p[k]*c+p[k+1]*f+p[k+2]*j;
	movapd	%xmm1, %xmm15	# f, _386
	mulsd	%xmm12, %xmm15	# _369, _386
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:67:         world[k+3]=p[k]*(double)pose->position[0]+p[k+1]*(double)pose->position[1]+
	mulsd	%xmm8, %xmm12	# _2392, _395
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:64:         world[k]=p[k]*a+p[k+1]*d+p[k+2]*g;
	movaps	%xmm13, -32(%rsi)	# vect__379.706_818, MEM <vector(2) double> [(double *)_1548]
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:66:         world[k+2]=p[k]*c+p[k+1]*f+p[k+2]*j;
	movapd	%xmm3, %xmm13	# c, _385
	mulsd	%xmm0, %xmm13	# _362, _385
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:67:         world[k+3]=p[k]*(double)pose->position[0]+p[k+1]*(double)pose->position[1]+
	mulsd	%xmm7, %xmm0	# _2390, _392
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:66:         world[k+2]=p[k]*c+p[k+1]*f+p[k+2]*j;
	addsd	%xmm15, %xmm13	# _386, _387
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:66:         world[k+2]=p[k]*c+p[k+1]*f+p[k+2]*j;
	movapd	%xmm2, %xmm15	# j, _388
	mulsd	%xmm11, %xmm15	# _377, _388
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:67:         world[k+3]=p[k]*(double)pose->position[0]+p[k+1]*(double)pose->position[1]+
	addsd	%xmm12, %xmm0	# _395, _396
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:68:                    p[k+2]*(double)pose->position[2]+p[k+3];
	mulsd	%xmm9, %xmm11	# _2394, _399
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:66:         world[k+2]=p[k]*c+p[k+1]*f+p[k+2]*j;
	addsd	%xmm15, %xmm13	# _388, _389
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:67:         world[k+3]=p[k]*(double)pose->position[0]+p[k+1]*(double)pose->position[1]+
	addsd	%xmm11, %xmm0	# _399, _400
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:68:                    p[k+2]*(double)pose->position[2]+p[k+3];
	pxor	%xmm11, %xmm11	# _406
	cvtss2sd	-4(%rbx), %xmm11	# MEM[(const float *)_1552 + 12B], _406
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:66:         world[k+2]=p[k]*c+p[k+1]*f+p[k+2]*j;
	movsd	%xmm13, -16(%rsi)	# _389, MEM[(double *)_1548 + 16B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:68:                    p[k+2]*(double)pose->position[2]+p[k+3];
	addsd	%xmm11, %xmm0	# _406, _407
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:67:         world[k+3]=p[k]*(double)pose->position[0]+p[k+1]*(double)pose->position[1]+
	movsd	%xmm0, -8(%rsi)	# _407, MEM[(double *)_1548 + 24B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:62:     }else for(unsigned k=0;k<12;k+=4){
	cmpq	%rbx, %rdi	# ivtmp.912, _1543
	jne	.L793	#,
.L792:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:597:         if(ayatsuri_transform_evaluate(&pose,parent<0?NULL:&p,&result)!=AYATSURI_OK)return leave(i,AYATSURI_MODEL_RANGE);
	xorl	%esi, %esi	# ivtmp.897
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:78:         candidate.m[k]=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;
	pxor	%xmm2, %xmm2	# tmp1937
	jmp	.L797	#
	.p2align 4,,10
	.p2align 3
.L1036:
	comisd	%xmm1, %xmm2	# v, tmp1937
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:78:         candidate.m[k]=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;
	movss	.LC33(%rip), %xmm0	#, iftmp.24_412
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:78:         candidate.m[k]=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;
	ja	.L796	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:78:         candidate.m[k]=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;
	movaps	%xmm14, %xmm0	# iftmp.26_1507, iftmp.24_412
.L796:
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:78:         candidate.m[k]=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;
	leaq	816(%rsp), %rbx	#, tmp1843
	movss	%xmm0, (%rbx,%rsi,4)	# iftmp.24_412, MEM[(float *)_1360 + ivtmp.897_1570 * 4]
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:75:     for(unsigned k=0;k<12;++k){
	addq	$1, %rsi	#, ivtmp.897
	cmpq	$12, %rsi	#, ivtmp.897
	je	.L1035	#,
.L797:
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:76:         const double v=world[k],magnitude=fabs(v);
	movsd	0(%r13,%rsi,8), %xmm1	# MEM[(double *)_883 + ivtmp.897_1570 * 8], v
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:77:         if(!isfinite(v)||magnitude>=midpoint)return AYATSURI_RANGE;
	movsd	.LC22(%rip), %xmm5	#, tmp2343
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:76:         const double v=world[k],magnitude=fabs(v);
	movapd	%xmm1, %xmm0	# v, magnitude
	andpd	.LC8(%rip), %xmm0	#, magnitude
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:77:         if(!isfinite(v)||magnitude>=midpoint)return AYATSURI_RANGE;
	ucomisd	%xmm0, %xmm5	# magnitude, tmp2343
	jb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:77:         if(!isfinite(v)||magnitude>=midpoint)return AYATSURI_RANGE;
	comisd	.LC38(%rip), %xmm0	#, magnitude
	jnb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:78:         candidate.m[k]=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;
	comisd	.LC39(%rip), %xmm0	#, magnitude
	ja	.L1036	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:78:         candidate.m[k]=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;
	pxor	%xmm0, %xmm0	# iftmp.24_412
	cvtsd2ss	%xmm1, %xmm0	# v, iftmp.24_412
	jmp	.L796	#
	.p2align 4,,10
	.p2align 3
.L1035:
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:80:     memcpy(out,&candidate,sizeof candidate);
	movdqa	816(%rsp), %xmm0	# MEM <unsigned char[48]> [(char * {ref-all})_1360], MEM <unsigned char[48]> [(char * {ref-all})_1360]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	140(%r15), %esi	# MEM[(uint32_t *)i_128(D) + 140B], _254
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	xorl	%edi, %edi	# tmp1849
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:80:     memcpy(out,&candidate,sizeof candidate);
	movaps	%xmm0, 688(%rsp)	# MEM <unsigned char[48]> [(char * {ref-all})_1360], MEM <unsigned char[48]> [(char * {ref-all})&result]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	cmpl	$-1, %esi	#, _254
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:80:     memcpy(out,&candidate,sizeof candidate);
	movdqa	832(%rsp), %xmm0	# MEM <unsigned char[48]> [(char * {ref-all})_1360], MEM <unsigned char[48]> [(char * {ref-all})_1360]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	setne	%dil	#, tmp1849
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:80:     memcpy(out,&candidate,sizeof candidate);
	movaps	%xmm0, 704(%rsp)	# MEM <unsigned char[48]> [(char * {ref-all})_1360], MEM <unsigned char[48]> [(char * {ref-all})&result]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	addl	%edi, %esi	# tmp1849, _254
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:80:     memcpy(out,&candidate,sizeof candidate);
	movdqa	848(%rsp), %xmm0	# MEM <unsigned char[48]> [(char * {ref-all})_1360], MEM <unsigned char[48]> [(char * {ref-all})_1360]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	%esi, 140(%r15)	# _254, MEM[(uint32_t *)i_128(D) + 140B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:80:     memcpy(out,&candidate,sizeof candidate);
	movaps	%xmm0, 720(%rsp)	# MEM <unsigned char[48]> [(char * {ref-all})_1360], MEM <unsigned char[48]> [(char * {ref-all})&result]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movl	8(%rax), %eax	# _2398->offset, _252
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:599:         memcpy(work(i,j),&result,48);states(i)[j].world_enabled=states(i)[j].enabled&&(parent<0||states(i)[parent].world_enabled);
	movdqa	688(%rsp), %xmm0	# MEM <char[1:48]> [(void *)&result], MEM <char[1:48]> [(void *)&result]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	addq	%rax, %rbp	# _252, _253
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:599:         memcpy(work(i,j),&result,48);states(i)[j].world_enabled=states(i)[j].enabled&&(parent<0||states(i)[parent].world_enabled);
	movups	%xmm0, 0(%rbp)	# MEM <char[1:48]> [(void *)&result], MEM <char[1:48]> [(void *)_253]
	movdqa	704(%rsp), %xmm0	# MEM <char[1:48]> [(void *)&result], MEM <char[1:48]> [(void *)&result]
	movups	%xmm0, 16(%rbp)	# MEM <char[1:48]> [(void *)&result], MEM <char[1:48]> [(void *)_253]
	movdqa	720(%rsp), %xmm0	# MEM <char[1:48]> [(void *)&result], MEM <char[1:48]> [(void *)&result]
	movups	%xmm0, 32(%rbp)	# MEM <char[1:48]> [(void *)&result], MEM <char[1:48]> [(void *)_253]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:211: static model_node_state *states(ayatsuri_model_instance *i){return i->arena;}
	movq	8(%r15), %rax	# i_128(D)->arena, _250
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:599:         memcpy(work(i,j),&result,48);states(i)[j].world_enabled=states(i)[j].enabled&&(parent<0||states(i)[parent].world_enabled);
	leaq	(%rax,%rdx), %rsi	#, _80
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:599:         memcpy(work(i,j),&result,48);states(i)[j].world_enabled=states(i)[j].enabled&&(parent<0||states(i)[parent].world_enabled);
	movzbl	16(%rsi), %edi	# _80->enabled, _81
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:599:         memcpy(work(i,j),&result,48);states(i)[j].world_enabled=states(i)[j].enabled&&(parent<0||states(i)[parent].world_enabled);
	testb	%dil, %dil	# _81
	je	.L802	#,
	movl	$1, %edi	#, _81
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:599:         memcpy(work(i,j),&result,48);states(i)[j].world_enabled=states(i)[j].enabled&&(parent<0||states(i)[parent].world_enabled);
	testl	%r9d, %r9d	# iftmp.7_233
	js	.L802	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:599:         memcpy(work(i,j),&result,48);states(i)[j].world_enabled=states(i)[j].enabled&&(parent<0||states(i)[parent].world_enabled);
	leaq	(%r9,%r9,2), %rdi	#, tmp1307
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:599:         memcpy(work(i,j),&result,48);states(i)[j].world_enabled=states(i)[j].enabled&&(parent<0||states(i)[parent].world_enabled);
	cmpb	$0, 17(%rax,%rdi,8)	#, _84->world_enabled
	setne	%dil	#, _81
.L802:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:599:         memcpy(work(i,j),&result,48);states(i)[j].world_enabled=states(i)[j].enabled&&(parent<0||states(i)[parent].world_enabled);
	movb	%dil, 17(%rsi)	# _81, _80->world_enabled
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:600:         if((node[2]==1&&!ellipse_packet(i,j,right,down))||(node[2]==2&&!blend_packet(i,j,right,down,forward))||
	movzbl	2(%r12), %edi	# MEM[(const uint8_t *)_243 + 2B], _87
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:600:         if((node[2]==1&&!ellipse_packet(i,j,right,down))||(node[2]==2&&!blend_packet(i,j,right,down,forward))||
	cmpb	$1, %dil	#, _87
	je	.L1037	#,
.L803:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:600:         if((node[2]==1&&!ellipse_packet(i,j,right,down))||(node[2]==2&&!blend_packet(i,j,right,down,forward))||
	cmpb	$2, %dil	#, _87
	je	.L1038	#,
.L837:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:600:         if((node[2]==1&&!ellipse_packet(i,j,right,down))||(node[2]==2&&!blend_packet(i,j,right,down,forward))||
	cmpb	$3, %dil	#, _87
	je	.L1039	#,
.L877:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:603:         if(node[2]){add_count(&i->stats.projection_updates,1);add_count(&i->stats.shade_updates,1);}
	testb	%dil, %dil	# _87
	je	.L878	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	144(%r15), %eax	# MEM[(uint32_t *)i_128(D) + 144B], _260
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	xorl	%edx, %edx	# tmp1871
	cmpl	$-1, %eax	#, _260
	setne	%dl	#, tmp1871
	addl	%edx, %eax	# tmp1871, _260
	xorl	%edx, %edx	# tmp1903
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	%eax, 144(%r15)	# _260, MEM[(uint32_t *)i_128(D) + 144B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	148(%r15), %eax	# MEM[(uint32_t *)i_128(D) + 148B], _257
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	cmpl	$-1, %eax	#, _257
	setne	%dl	#, tmp1903
	addl	%edx, %eax	# tmp1903, _257
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	%eax, 148(%r15)	# _257, MEM[(uint32_t *)i_128(D) + 148B]
.L878:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:593:     for(unsigned j=0;j<i->model->node_count;++j){
	movq	(%r15), %rax	# i_128(D)->model, _95
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:593:     for(unsigned j=0;j<i->model->node_count;++j){
	addq	$1, %r10	#, ivtmp.929
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:593:     for(unsigned j=0;j<i->model->node_count;++j){
	movzwl	12(%rax), %edx	# _95->node_count, _97
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:593:     for(unsigned j=0;j<i->model->node_count;++j){
	cmpl	%edx, %r10d	# _97, ivtmp.929
	jb	.L881	#,
.L779:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movl	$256, %eax	#,
	movw	%ax, 165(%r15)	#, MEM <vector(2) unsigned char> [(_Bool *)i_128(D) + 165B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:565:     if(same)return leave(i,AYATSURI_MODEL_OK);
	xorl	%eax, %eax	# <retval>
	jmp	.L746	#
	.p2align 4,,10
	.p2align 3
.L784:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:595:         ayatsuri_pose pose;ayatsuri_transform p,result;memcpy(&pose,work(i,j)+12,36);
	movdqu	(%rdi), %xmm0	# MEM <char[1:36]> [(void *)_2402], MEM <char[1:36]> [(void *)_2402]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:16: static int parent_id(const uint8_t *p){const uint16_t x=m16(p);return x<=INT16_MAX?(int)x:(int)x-65536;}
	movl	%esi, %r9d	# load_dst_1661, iftmp.7_233
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:597:         if(ayatsuri_transform_evaluate(&pose,parent<0?NULL:&p,&result)!=AYATSURI_OK)return leave(i,AYATSURI_MODEL_RANGE);
	xorl	%ebx, %ebx	# iftmp.22_112
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:16: static int parent_id(const uint8_t *p){const uint16_t x=m16(p);return x<=INT16_MAX?(int)x:(int)x-65536;}
	orl	$-65536, %r9d	#, iftmp.7_233
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:595:         ayatsuri_pose pose;ayatsuri_transform p,result;memcpy(&pose,work(i,j)+12,36);
	movaps	%xmm0, (%r11)	# MEM <char[1:36]> [(void *)_2402], MEM <char[1:36]> [(void *)&pose]
	movdqu	16(%rdi), %xmm0	# MEM <char[1:36]> [(void *)_2402], MEM <char[1:36]> [(void *)_2402]
	movaps	%xmm0, 16(%r11)	# MEM <char[1:36]> [(void *)_2402], MEM <char[1:36]> [(void *)&pose]
	movl	32(%rdi), %esi	# MEM <char[1:36]> [(void *)_2402], MEM <char[1:36]> [(void *)_2402]
	movl	%esi, 32(%r11)	# MEM <char[1:36]> [(void *)_2402], MEM <char[1:36]> [(void *)&pose]
	jmp	.L785	#
	.p2align 4,,10
	.p2align 3
.L1037:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:322:     const ayatsuri_model *model=i->model;const uint8_t *node=row(model,1,id,16),*r=row(model,3,m16(node+4),12);
	movq	(%r15), %r14	# i_128(D)->model, model
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	20(%r14), %r9d	# model_416->section[0].offset, _419
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	(%r14), %rdi	# model_416->data, _417
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	36(%r14), %ebp	# model_416->section[2].offset, _433
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rcx, %r9	# _152, _422
	movq	%rdi, (%rsp)	# _417, %sfp
	addq	%rdi, %r9	# _417, _423
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:322:     const ayatsuri_model *model=i->model;const uint8_t *node=row(model,1,id,16),*r=row(model,3,m16(node+4),12);
	movzwl	4(%r9), %edi	# MEM <short unsigned int> [(const uint8_t *)_423 + 4B], _431
	movzwl	8(%r9), %r9d	# MEM <short unsigned int> [(const uint8_t *)_423 + 8B], load_dst_1655
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	leal	(%rdi,%rdi,2), %edi	#, _434
	sall	$2, %edi	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rbp, %rdi	# _433, _436
	movq	(%rsp), %rbp	# %sfp, _417
	addq	%rbp, %rdi	# _417, _437
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	52(%r14), %ebp	# model_416->section[4].offset, _446
	movl	%ebp, 48(%rsp)	# _446, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movl	8(%rsi), %ebp	# _80->offset, _457
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	addq	%rax, %rbp	# _250, _458
	xorl	%eax, %eax	# ivtmp.889
.L804:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:324:     double m[12];for(unsigned k=0;k<12;++k)m[k]=w[k];
	movups	0(%rbp,%rax), %xmm1	# MEM <vector(4) float> [(float *)_458 + ivtmp.889_1572 * 1], MEM <vector(4) float> [(float *)_458 + ivtmp.889_1572 * 1]
	cvtps2pd	%xmm1, %xmm0	# MEM <vector(4) float> [(float *)_458 + ivtmp.889_1572 * 1], vect__464.674_510
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:324:     double m[12];for(unsigned k=0;k<12;++k)m[k]=w[k];
	movaps	%xmm0, 0(%r13,%rax,2)	# vect__464.674_510, MEM <vector(2) double> [(double *)_883 + ivtmp.889_1572 * 2]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:324:     double m[12];for(unsigned k=0;k<12;++k)m[k]=w[k];
	pxor	%xmm0, %xmm0	# tmp1327
	movhlps	%xmm1, %xmm0	# MEM <vector(4) float> [(float *)_458 + ivtmp.889_1572 * 1], tmp1327
	cvtps2pd	%xmm0, %xmm0	# tmp1327, vect__464.674_716
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:324:     double m[12];for(unsigned k=0;k<12;++k)m[k]=w[k];
	movaps	%xmm0, 16(%r13,%rax,2)	# vect__464.674_716, MEM <vector(2) double> [(double *)_883 + 16B + ivtmp.889_1572 * 2]
	addq	$16, %rax	#, ivtmp.889
	cmpq	$48, %rax	#, ivtmp.889
	jne	.L804	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:326:         a=m[0]*radii[0],b=m[1]*radii[1],c=m[2]*radii[2],d=m[4]*radii[0],e=m[5]*radii[1],f=m[6]*radii[2],
	movsd	920(%rsp), %xmm15	# MEM[(double[12] *)_883][1], b
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:15: static uint32_t m32(const uint8_t *p){return (uint32_t)p[0]|(uint32_t)p[1]<<8|(uint32_t)p[2]<<16|(uint32_t)p[3]<<24;}
	movq	(%rdi), %xmm0	# MEM <vector(2) unsigned int> [(const uint8_t *)_437], vect__479.715_843
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:326:         a=m[0]*radii[0],b=m[1]*radii[1],c=m[2]*radii[2],d=m[4]*radii[0],e=m[5]*radii[1],f=m[6]*radii[2],
	movsd	960(%rsp), %xmm5	# MEM[(double[12] *)_883][6], _524
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:326:         a=m[0]*radii[0],b=m[1]*radii[1],c=m[2]*radii[2],d=m[4]*radii[0],e=m[5]*radii[1],f=m[6]*radii[2],
	movsd	952(%rsp), %xmm9	# MEM[(double[12] *)_883][5], e
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:326:         a=m[0]*radii[0],b=m[1]*radii[1],c=m[2]*radii[2],d=m[4]*radii[0],e=m[5]*radii[1],f=m[6]*radii[2],
	movsd	944(%rsp), %xmm8	# MEM[(double[12] *)_883][4], d
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:325:     const double radii[3]={mf(r),mf(r+4),mf(r+8)},
	cvtps2pd	%xmm0, %xmm0	# vect__479.715_843, vect__481.717
	movapd	%xmm0, %xmm7	# vect__481.717, vect__481.717
	movapd	%xmm0, %xmm1	# vect__481.717, _850
	unpckhpd	%xmm7, %xmm7	# vect__481.717
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:326:         a=m[0]*radii[0],b=m[1]*radii[1],c=m[2]*radii[2],d=m[4]*radii[0],e=m[5]*radii[1],f=m[6]*radii[2],
	movsd	%xmm5, 64(%rsp)	# _524, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:326:         a=m[0]*radii[0],b=m[1]*radii[1],c=m[2]*radii[2],d=m[4]*radii[0],e=m[5]*radii[1],f=m[6]*radii[2],
	movsd	912(%rsp), %xmm13	# MEM[(double[12] *)_883][0], a
	movapd	%xmm7, %xmm2	# vect__481.717, _851
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:325:     const double radii[3]={mf(r),mf(r+4),mf(r+8)},
	movaps	%xmm0, 736(%rsp)	# vect__481.717, MEM <vector(2) double> [(double *)_1358]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:325:     const double radii[3]={mf(r),mf(r+4),mf(r+8)},
	pxor	%xmm0, %xmm0	# _513
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:326:         a=m[0]*radii[0],b=m[1]*radii[1],c=m[2]*radii[2],d=m[4]*radii[0],e=m[5]*radii[1],f=m[6]*radii[2],
	mulsd	%xmm7, %xmm15	# _851, b
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:325:     const double radii[3]={mf(r),mf(r+4),mf(r+8)},
	cvtss2sd	8(%rdi), %xmm0	# MEM <unsigned int> [(const uint8_t *)_437 + 8B], _513
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:326:         a=m[0]*radii[0],b=m[1]*radii[1],c=m[2]*radii[2],d=m[4]*radii[0],e=m[5]*radii[1],f=m[6]*radii[2],
	movsd	928(%rsp), %xmm7	# MEM[(double[12] *)_883][2], _518
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:325:     const double radii[3]={mf(r),mf(r+4),mf(r+8)},
	movsd	%xmm0, 752(%rsp)	# _513, MEM[(double[3] *)_1358][2]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:326:         a=m[0]*radii[0],b=m[1]*radii[1],c=m[2]*radii[2],d=m[4]*radii[0],e=m[5]*radii[1],f=m[6]*radii[2],
	mulsd	%xmm2, %xmm9	# _851, e
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:326:         a=m[0]*radii[0],b=m[1]*radii[1],c=m[2]*radii[2],d=m[4]*radii[0],e=m[5]*radii[1],f=m[6]*radii[2],
	movsd	%xmm7, 56(%rsp)	# _518, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:326:         a=m[0]*radii[0],b=m[1]*radii[1],c=m[2]*radii[2],d=m[4]*radii[0],e=m[5]*radii[1],f=m[6]*radii[2],
	mulsd	%xmm1, %xmm8	# _850, d
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:326:         a=m[0]*radii[0],b=m[1]*radii[1],c=m[2]*radii[2],d=m[4]*radii[0],e=m[5]*radii[1],f=m[6]*radii[2],
	movapd	%xmm7, %xmm6	# _518, c
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:326:         a=m[0]*radii[0],b=m[1]*radii[1],c=m[2]*radii[2],d=m[4]*radii[0],e=m[5]*radii[1],f=m[6]*radii[2],
	movapd	%xmm5, %xmm7	# _524, f
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	992(%rsp), %xmm5	# MEM[(double[12] *)_883][10], _530
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:326:         a=m[0]*radii[0],b=m[1]*radii[1],c=m[2]*radii[2],d=m[4]*radii[0],e=m[5]*radii[1],f=m[6]*radii[2],
	mulsd	%xmm0, %xmm7	# _513, f
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:326:         a=m[0]*radii[0],b=m[1]*radii[1],c=m[2]*radii[2],d=m[4]*radii[0],e=m[5]*radii[1],f=m[6]*radii[2],
	mulsd	%xmm0, %xmm6	# _513, c
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	984(%rsp), %xmm2	# MEM[(double[12] *)_883][9], h
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	%xmm5, 72(%rsp)	# _530, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm5, %xmm0	# _530, j
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm9, %xmm5	# e, _532
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:326:         a=m[0]*radii[0],b=m[1]*radii[1],c=m[2]*radii[2],d=m[4]*radii[0],e=m[5]*radii[1],f=m[6]*radii[2],
	mulsd	%xmm1, %xmm13	# _850, a
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm8, %xmm12	# d, _536
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm8, %xmm4	# d, _541
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	976(%rsp), %xmm1	# MEM[(double[12] *)_883][8], g
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm7, %xmm3	# f, _533
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm7, %xmm11	# f, _537
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm2, %xmm3	# h, _533
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm0, %xmm5	# j, _532
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm0, %xmm12	# j, _536
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm1, %xmm11	# g, _537
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm2, %xmm4	# h, _541
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	subsd	%xmm3, %xmm5	# _533, _534
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm9, %xmm3	# e, _542
	mulsd	%xmm1, %xmm3	# g, _542
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	%xmm12, 32(%rsp)	# _536, %sfp
	subsd	%xmm11, %xmm12	# _537, _538
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm4, %xmm10	# _541, _541
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:328:     if(!isfinite(det)||fabs(det)<1e-12)return false;
	movsd	.LC22(%rip), %xmm4	#, tmp2369
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm15, %xmm12	# b, _539
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	subsd	%xmm3, %xmm10	# _542, _541
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm13, %xmm3	# a, _535
	mulsd	%xmm5, %xmm3	# _534, _535
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	subsd	%xmm12, %xmm3	# _539, _540
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm6, %xmm12	# c, _544
	mulsd	%xmm10, %xmm12	# _543, _544
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:327:         g=m[8]*radii[0],h=m[9]*radii[1],j=m[10]*radii[2],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	addsd	%xmm12, %xmm3	# _544, det
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:328:     if(!isfinite(det)||fabs(det)<1e-12)return false;
	movapd	%xmm3, %xmm12	# det, _546
	andpd	.LC8(%rip), %xmm12	#, _546
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:328:     if(!isfinite(det)||fabs(det)<1e-12)return false;
	ucomisd	%xmm12, %xmm4	# _546, tmp2369
	jb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:328:     if(!isfinite(det)||fabs(det)<1e-12)return false;
	movsd	.LC40(%rip), %xmm4	#, tmp2370
	comisd	%xmm12, %xmm4	# _546, tmp2370
	ja	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	subsd	32(%rsp), %xmm11	# %sfp, _548
	movapd	%xmm3, %xmm12	# det, tmp1343
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	movapd	%xmm10, %xmm4	# _543, _1232
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	xorl	%eax, %eax	# ivtmp.885
	unpcklpd	%xmm12, %xmm12	# tmp1343
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	unpcklpd	%xmm11, %xmm5	# _548, _856
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	movapd	%xmm6, %xmm11	# c, _551
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	divpd	%xmm12, %xmm5	# tmp1343, vect__547.720_864
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	mulsd	%xmm2, %xmm11	# h, _551
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:330:         (b*g-a*h)/det,(b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det};
	mulsd	%xmm13, %xmm2	# a, _560
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	movaps	%xmm5, 816(%rsp)	# vect__547.720_864, MEM <vector(2) double> [(double *)_1360]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	movapd	%xmm15, %xmm5	# b, _552
	mulsd	%xmm0, %xmm5	# j, _552
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	mulsd	%xmm13, %xmm0	# a, _555
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	subsd	%xmm5, %xmm11	# _552, _553
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	unpcklpd	%xmm11, %xmm4	# _553, _1232
	divpd	%xmm12, %xmm4	# tmp1343, vect__547.720_865
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	movaps	%xmm4, 832(%rsp)	# vect__547.720_865, MEM <vector(2) double> [(double *)_1360 + 16B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	movapd	%xmm6, %xmm4	# c, _556
	mulsd	%xmm1, %xmm4	# g, _556
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:330:         (b*g-a*h)/det,(b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det};
	mulsd	%xmm15, %xmm1	# b, _559
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	subsd	%xmm4, %xmm0	# _556, _557
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:330:         (b*g-a*h)/det,(b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det};
	subsd	%xmm2, %xmm1	# _560, _561
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	unpcklpd	%xmm1, %xmm0	# _561, _855
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:330:         (b*g-a*h)/det,(b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det};
	movapd	%xmm6, %xmm1	# c, _564
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	divpd	%xmm12, %xmm0	# tmp1343, vect__547.720_866
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:330:         (b*g-a*h)/det,(b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det};
	mulsd	%xmm9, %xmm1	# e, _564
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:330:         (b*g-a*h)/det,(b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det};
	mulsd	%xmm8, %xmm6	# d, _567
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	movaps	%xmm0, 848(%rsp)	# vect__547.720_866, MEM <vector(2) double> [(double *)_1360 + 32B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:330:         (b*g-a*h)/det,(b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det};
	movapd	%xmm15, %xmm0	# b, _563
	mulsd	%xmm7, %xmm0	# f, _563
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:330:         (b*g-a*h)/det,(b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det};
	mulsd	%xmm13, %xmm7	# a, _568
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:330:         (b*g-a*h)/det,(b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det};
	subsd	%xmm1, %xmm0	# _564, _565
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:330:         (b*g-a*h)/det,(b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det};
	movapd	%xmm15, %xmm1	# b, b
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:330:         (b*g-a*h)/det,(b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det};
	subsd	%xmm7, %xmm6	# _568, _569
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:330:         (b*g-a*h)/det,(b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det};
	mulsd	%xmm8, %xmm1	# d, b
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	unpcklpd	%xmm6, %xmm0	# _569, _854
	divpd	%xmm12, %xmm0	# tmp1343, vect__547.720_867
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	movaps	%xmm0, 864(%rsp)	# vect__547.720_867, MEM <vector(2) double> [(double *)_1360 + 48B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:330:         (b*g-a*h)/det,(b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det};
	movapd	%xmm13, %xmm0	# a, a
	mulsd	%xmm9, %xmm0	# e, a
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:330:         (b*g-a*h)/det,(b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det};
	subsd	%xmm1, %xmm0	# _572, _573
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:330:         (b*g-a*h)/det,(b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det};
	divsd	%xmm3, %xmm0	# det, _574
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:329:     const double normal[9]={(e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,
	movsd	%xmm0, 880(%rsp)	# _574, MEM[(double[9] *)_1360][8]
.L813:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:331:     for(unsigned k=0;k<9;++k)if(!narrow(normal[k],w+32+k))return false;
	movsd	(%rbx,%rax,2), %xmm1	# MEM[(double *)_1360 + ivtmp.885_1586 * 2], _580
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	movsd	.LC22(%rip), %xmm7	#, tmp2381
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:310:     const double magnitude=fabs(v),midpoint=(double)FLT_MAX+0x1p103;
	movapd	%xmm1, %xmm0	# _580, magnitude
	andpd	.LC8(%rip), %xmm0	#, magnitude
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	ucomisd	%xmm0, %xmm7	# magnitude, tmp2381
	jb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	comisd	.LC38(%rip), %xmm0	#, magnitude
	jnb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	comisd	.LC39(%rip), %xmm0	#, magnitude
	jbe	.L972	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	pxor	%xmm2, %xmm2	# tmp1377
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	.LC33(%rip), %xmm0	#, iftmp.26_582
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	comisd	%xmm1, %xmm2	# _580, tmp1377
	ja	.L812	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movaps	%xmm14, %xmm0	# iftmp.26_1507, iftmp.26_582
.L812:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	%xmm0, 128(%rbp,%rax)	# iftmp.26_582, MEM[(float *)_458 + 128B + ivtmp.885_1586 * 1]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:331:     for(unsigned k=0;k<9;++k)if(!narrow(normal[k],w+32+k))return false;
	addq	$4, %rax	#, ivtmp.885
	cmpq	$36, %rax	#, ivtmp.885
	jne	.L813	#,
	movq	%rdx, 80(%rsp)	# tmp1188, %sfp
	leaq	736(%rsp), %rax	#, tmp1842
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:332:     const double zoom=i->camera[6];
	pxor	%xmm1, %xmm1	# zoom
	xorl	%edi, %edi	# ivtmp.875
	movq	%rax, 32(%rsp)	# tmp1842, %sfp
	movq	%r13, %rax	# ivtmp.780, ivtmp.870
	cvtss2sd	64(%r15), %xmm1	# i_128(D)->camera[6], zoom
.L820:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:334:         if(!narrow(zoom*(right[0]*m[k]+right[1]*m[4+k]+right[2]*m[8+k])*radii[k],w+24+k)||
	movsd	(%rax), %xmm6	# MEM[(double *)_1590], _594
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:334:         if(!narrow(zoom*(right[0]*m[k]+right[1]*m[4+k]+right[2]*m[8+k])*radii[k],w+24+k)||
	movsd	32(%rax), %xmm5	# MEM[(double *)_1590 + 32B], _599
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:334:         if(!narrow(zoom*(right[0]*m[k]+right[1]*m[4+k]+right[2]*m[8+k])*radii[k],w+24+k)||
	pxor	%xmm0, %xmm0	# _593
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:334:         if(!narrow(zoom*(right[0]*m[k]+right[1]*m[4+k]+right[2]*m[8+k])*radii[k],w+24+k)||
	pxor	%xmm3, %xmm3	# _597
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:334:         if(!narrow(zoom*(right[0]*m[k]+right[1]*m[4+k]+right[2]*m[8+k])*radii[k],w+24+k)||
	cvtss2sd	484(%rsp), %xmm0	# MEM[(const float *)&right], _593
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:334:         if(!narrow(zoom*(right[0]*m[k]+right[1]*m[4+k]+right[2]*m[8+k])*radii[k],w+24+k)||
	movsd	64(%rax), %xmm4	# MEM[(double *)_1590 + 64B], _605
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:334:         if(!narrow(zoom*(right[0]*m[k]+right[1]*m[4+k]+right[2]*m[8+k])*radii[k],w+24+k)||
	cvtss2sd	488(%rsp), %xmm3	# MEM[(const float *)&right + 4B], _597
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:334:         if(!narrow(zoom*(right[0]*m[k]+right[1]*m[4+k]+right[2]*m[8+k])*radii[k],w+24+k)||
	movq	32(%rsp), %rdx	# %sfp, tmp1842
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:334:         if(!narrow(zoom*(right[0]*m[k]+right[1]*m[4+k]+right[2]*m[8+k])*radii[k],w+24+k)||
	mulsd	%xmm5, %xmm3	# _599, _600
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	movsd	.LC22(%rip), %xmm7	#, tmp2385
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:334:         if(!narrow(zoom*(right[0]*m[k]+right[1]*m[4+k]+right[2]*m[8+k])*radii[k],w+24+k)||
	mulsd	%xmm6, %xmm0	# _594, _595
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:334:         if(!narrow(zoom*(right[0]*m[k]+right[1]*m[4+k]+right[2]*m[8+k])*radii[k],w+24+k)||
	movsd	(%rdx,%rdi,2), %xmm2	# MEM[(double *)_1358 + ivtmp.875_1592 * 2], _609
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:334:         if(!narrow(zoom*(right[0]*m[k]+right[1]*m[4+k]+right[2]*m[8+k])*radii[k],w+24+k)||
	addsd	%xmm3, %xmm0	# _600, _601
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:334:         if(!narrow(zoom*(right[0]*m[k]+right[1]*m[4+k]+right[2]*m[8+k])*radii[k],w+24+k)||
	pxor	%xmm3, %xmm3	# _603
	cvtss2sd	492(%rsp), %xmm3	# MEM[(const float *)&right + 8B], _603
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:334:         if(!narrow(zoom*(right[0]*m[k]+right[1]*m[4+k]+right[2]*m[8+k])*radii[k],w+24+k)||
	mulsd	%xmm4, %xmm3	# _605, _606
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:334:         if(!narrow(zoom*(right[0]*m[k]+right[1]*m[4+k]+right[2]*m[8+k])*radii[k],w+24+k)||
	addsd	%xmm3, %xmm0	# _606, _607
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:334:         if(!narrow(zoom*(right[0]*m[k]+right[1]*m[4+k]+right[2]*m[8+k])*radii[k],w+24+k)||
	mulsd	%xmm1, %xmm0	# zoom, _608
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:334:         if(!narrow(zoom*(right[0]*m[k]+right[1]*m[4+k]+right[2]*m[8+k])*radii[k],w+24+k)||
	mulsd	%xmm2, %xmm0	# _609, _610
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:310:     const double magnitude=fabs(v),midpoint=(double)FLT_MAX+0x1p103;
	movapd	%xmm0, %xmm3	# _610, magnitude
	andpd	.LC8(%rip), %xmm3	#, magnitude
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	ucomisd	%xmm3, %xmm7	# magnitude, tmp2385
	jb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	comisd	.LC38(%rip), %xmm3	#, magnitude
	jnb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	comisd	.LC39(%rip), %xmm3	#, magnitude
	jbe	.L973	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	pxor	%xmm3, %xmm3	# tmp1392
	comisd	%xmm0, %xmm3	# _610, tmp1392
	ja	.L892	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movaps	%xmm14, %xmm0	# iftmp.26_1507, iftmp.26_613
.L816:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	%xmm0, 96(%rbp,%rdi)	# iftmp.26_613, MEM[(float *)_458 + 96B + ivtmp.875_1592 * 1]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:335:            !narrow(zoom*(down[0]*m[k]+down[1]*m[4+k]+down[2]*m[8+k])*radii[k],w+28+k))return false;
	pxor	%xmm3, %xmm3	# _621
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:335:            !narrow(zoom*(down[0]*m[k]+down[1]*m[4+k]+down[2]*m[8+k])*radii[k],w+28+k))return false;
	pxor	%xmm0, %xmm0	# _618
	cvtss2sd	472(%rsp), %xmm0	# MEM[(const float *)&down], _618
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:335:            !narrow(zoom*(down[0]*m[k]+down[1]*m[4+k]+down[2]*m[8+k])*radii[k],w+28+k))return false;
	mulsd	%xmm6, %xmm0	# _594, _619
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:335:            !narrow(zoom*(down[0]*m[k]+down[1]*m[4+k]+down[2]*m[8+k])*radii[k],w+28+k))return false;
	cvtss2sd	476(%rsp), %xmm3	# MEM[(const float *)&down + 4B], _621
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	movsd	.LC22(%rip), %xmm6	#, tmp2387
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:335:            !narrow(zoom*(down[0]*m[k]+down[1]*m[4+k]+down[2]*m[8+k])*radii[k],w+28+k))return false;
	mulsd	%xmm5, %xmm3	# _599, _622
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:335:            !narrow(zoom*(down[0]*m[k]+down[1]*m[4+k]+down[2]*m[8+k])*radii[k],w+28+k))return false;
	addsd	%xmm3, %xmm0	# _622, _623
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:335:            !narrow(zoom*(down[0]*m[k]+down[1]*m[4+k]+down[2]*m[8+k])*radii[k],w+28+k))return false;
	pxor	%xmm3, %xmm3	# _625
	cvtss2sd	480(%rsp), %xmm3	# MEM[(const float *)&down + 8B], _625
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:335:            !narrow(zoom*(down[0]*m[k]+down[1]*m[4+k]+down[2]*m[8+k])*radii[k],w+28+k))return false;
	mulsd	%xmm4, %xmm3	# _605, _626
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:335:            !narrow(zoom*(down[0]*m[k]+down[1]*m[4+k]+down[2]*m[8+k])*radii[k],w+28+k))return false;
	addsd	%xmm3, %xmm0	# _626, _627
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:335:            !narrow(zoom*(down[0]*m[k]+down[1]*m[4+k]+down[2]*m[8+k])*radii[k],w+28+k))return false;
	mulsd	%xmm1, %xmm0	# zoom, _628
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:335:            !narrow(zoom*(down[0]*m[k]+down[1]*m[4+k]+down[2]*m[8+k])*radii[k],w+28+k))return false;
	mulsd	%xmm2, %xmm0	# _609, _629
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:310:     const double magnitude=fabs(v),midpoint=(double)FLT_MAX+0x1p103;
	movapd	%xmm0, %xmm2	# _629, magnitude
	andpd	.LC8(%rip), %xmm2	#, magnitude
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	ucomisd	%xmm2, %xmm6	# magnitude, tmp2387
	jb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	comisd	.LC38(%rip), %xmm2	#, magnitude
	jnb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	comisd	.LC39(%rip), %xmm2	#, magnitude
	jbe	.L974	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	pxor	%xmm2, %xmm2	# tmp1406
	comisd	%xmm0, %xmm2	# _629, tmp1406
	ja	.L893	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movaps	%xmm14, %xmm0	# iftmp.26_1507, iftmp.26_632
.L819:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	%xmm0, 112(%rbp,%rdi)	# iftmp.26_632, MEM[(float *)_458 + 112B + ivtmp.875_1592 * 1]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:333:     for(unsigned k=0;k<3;++k){
	addq	$4, %rdi	#, ivtmp.875
	addq	$8, %rax	#, ivtmp.870
	cmpq	$12, %rdi	#, ivtmp.875
	jne	.L820	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:337:     const double x=m[3]-i->camera[3],y=m[7]-i->camera[4],z=m[11]-i->camera[5];
	pxor	%xmm0, %xmm0	# _636
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:338:     if(!narrow(i->camera[7]+zoom*(right[0]*x+right[1]*y+right[2]*z),w+27)||
	pxor	%xmm5, %xmm5	# _652
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:337:     const double x=m[3]-i->camera[3],y=m[7]-i->camera[4],z=m[11]-i->camera[5];
	movsd	936(%rsp), %xmm4	# MEM[(double[12] *)_883][3], MEM[(double[12] *)_883][3]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:337:     const double x=m[3]-i->camera[3],y=m[7]-i->camera[4],z=m[11]-i->camera[5];
	movsd	968(%rsp), %xmm3	# MEM[(double[12] *)_883][7], MEM[(double[12] *)_883][7]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:337:     const double x=m[3]-i->camera[3],y=m[7]-i->camera[4],z=m[11]-i->camera[5];
	cvtss2sd	52(%r15), %xmm0	# i_128(D)->camera[3], _636
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	movsd	.LC22(%rip), %xmm6	#, tmp2389
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:337:     const double x=m[3]-i->camera[3],y=m[7]-i->camera[4],z=m[11]-i->camera[5];
	movsd	1000(%rsp), %xmm2	# MEM[(double[12] *)_883][11], MEM[(double[12] *)_883][11]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:338:     if(!narrow(i->camera[7]+zoom*(right[0]*x+right[1]*y+right[2]*z),w+27)||
	cvtss2sd	488(%rsp), %xmm5	# MEM[(const float *)&right + 4B], _652
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:337:     const double x=m[3]-i->camera[3],y=m[7]-i->camera[4],z=m[11]-i->camera[5];
	subsd	%xmm0, %xmm4	# _636, x
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:337:     const double x=m[3]-i->camera[3],y=m[7]-i->camera[4],z=m[11]-i->camera[5];
	pxor	%xmm0, %xmm0	# _640
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:337:     const double x=m[3]-i->camera[3],y=m[7]-i->camera[4],z=m[11]-i->camera[5];
	movq	80(%rsp), %rdx	# %sfp, tmp1188
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:337:     const double x=m[3]-i->camera[3],y=m[7]-i->camera[4],z=m[11]-i->camera[5];
	cvtss2sd	56(%r15), %xmm0	# i_128(D)->camera[4], _640
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:337:     const double x=m[3]-i->camera[3],y=m[7]-i->camera[4],z=m[11]-i->camera[5];
	subsd	%xmm0, %xmm3	# _640, y
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:337:     const double x=m[3]-i->camera[3],y=m[7]-i->camera[4],z=m[11]-i->camera[5];
	pxor	%xmm0, %xmm0	# _644
	cvtss2sd	60(%r15), %xmm0	# i_128(D)->camera[5], _644
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:337:     const double x=m[3]-i->camera[3],y=m[7]-i->camera[4],z=m[11]-i->camera[5];
	subsd	%xmm0, %xmm2	# _644, z
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:338:     if(!narrow(i->camera[7]+zoom*(right[0]*x+right[1]*y+right[2]*z),w+27)||
	pxor	%xmm0, %xmm0	# _649
	cvtss2sd	484(%rsp), %xmm0	# MEM[(const float *)&right], _649
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:338:     if(!narrow(i->camera[7]+zoom*(right[0]*x+right[1]*y+right[2]*z),w+27)||
	mulsd	%xmm4, %xmm0	# x, _650
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:338:     if(!narrow(i->camera[7]+zoom*(right[0]*x+right[1]*y+right[2]*z),w+27)||
	mulsd	%xmm3, %xmm5	# y, _653
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:338:     if(!narrow(i->camera[7]+zoom*(right[0]*x+right[1]*y+right[2]*z),w+27)||
	addsd	%xmm5, %xmm0	# _653, _654
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:338:     if(!narrow(i->camera[7]+zoom*(right[0]*x+right[1]*y+right[2]*z),w+27)||
	pxor	%xmm5, %xmm5	# _656
	cvtss2sd	492(%rsp), %xmm5	# MEM[(const float *)&right + 8B], _656
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:338:     if(!narrow(i->camera[7]+zoom*(right[0]*x+right[1]*y+right[2]*z),w+27)||
	mulsd	%xmm2, %xmm5	# z, _657
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:338:     if(!narrow(i->camera[7]+zoom*(right[0]*x+right[1]*y+right[2]*z),w+27)||
	addsd	%xmm5, %xmm0	# _657, _658
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:338:     if(!narrow(i->camera[7]+zoom*(right[0]*x+right[1]*y+right[2]*z),w+27)||
	pxor	%xmm5, %xmm5	# _647
	cvtss2sd	68(%r15), %xmm5	# i_128(D)->camera[7], _647
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:338:     if(!narrow(i->camera[7]+zoom*(right[0]*x+right[1]*y+right[2]*z),w+27)||
	mulsd	%xmm1, %xmm0	# zoom, _659
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:338:     if(!narrow(i->camera[7]+zoom*(right[0]*x+right[1]*y+right[2]*z),w+27)||
	addsd	%xmm5, %xmm0	# _647, _660
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:310:     const double magnitude=fabs(v),midpoint=(double)FLT_MAX+0x1p103;
	movapd	%xmm0, %xmm5	# _660, magnitude
	andpd	.LC8(%rip), %xmm5	#, magnitude
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	ucomisd	%xmm5, %xmm6	# magnitude, tmp2389
	jb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	comisd	.LC38(%rip), %xmm5	#, magnitude
	jnb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	comisd	.LC39(%rip), %xmm5	#, magnitude
	jbe	.L975	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	pxor	%xmm5, %xmm5	# tmp1427
	comisd	%xmm0, %xmm5	# _660, tmp1427
	ja	.L1040	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movaps	%xmm14, %xmm0	# iftmp.26_1507, iftmp.26_663
.L823:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	%xmm0, 108(%rbp)	# iftmp.26_663, MEM[(float *)_458 + 108B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:339:        !narrow(i->camera[8]+zoom*(down[0]*x+down[1]*y+down[2]*z),w+31))return false;
	pxor	%xmm0, %xmm0	# _667
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	movsd	.LC22(%rip), %xmm6	#, tmp2391
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:339:        !narrow(i->camera[8]+zoom*(down[0]*x+down[1]*y+down[2]*z),w+31))return false;
	cvtss2sd	472(%rsp), %xmm0	# MEM[(const float *)&down], _667
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:339:        !narrow(i->camera[8]+zoom*(down[0]*x+down[1]*y+down[2]*z),w+31))return false;
	mulsd	%xmm4, %xmm0	# x, _668
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:339:        !narrow(i->camera[8]+zoom*(down[0]*x+down[1]*y+down[2]*z),w+31))return false;
	pxor	%xmm4, %xmm4	# _670
	cvtss2sd	476(%rsp), %xmm4	# MEM[(const float *)&down + 4B], _670
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:339:        !narrow(i->camera[8]+zoom*(down[0]*x+down[1]*y+down[2]*z),w+31))return false;
	mulsd	%xmm4, %xmm3	# _670, _671
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:339:        !narrow(i->camera[8]+zoom*(down[0]*x+down[1]*y+down[2]*z),w+31))return false;
	addsd	%xmm3, %xmm0	# _671, _672
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:339:        !narrow(i->camera[8]+zoom*(down[0]*x+down[1]*y+down[2]*z),w+31))return false;
	pxor	%xmm3, %xmm3	# _674
	cvtss2sd	480(%rsp), %xmm3	# MEM[(const float *)&down + 8B], _674
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:339:        !narrow(i->camera[8]+zoom*(down[0]*x+down[1]*y+down[2]*z),w+31))return false;
	mulsd	%xmm3, %xmm2	# _674, _675
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:339:        !narrow(i->camera[8]+zoom*(down[0]*x+down[1]*y+down[2]*z),w+31))return false;
	addsd	%xmm2, %xmm0	# _675, _676
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:339:        !narrow(i->camera[8]+zoom*(down[0]*x+down[1]*y+down[2]*z),w+31))return false;
	mulsd	%xmm1, %xmm0	# zoom, _677
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:339:        !narrow(i->camera[8]+zoom*(down[0]*x+down[1]*y+down[2]*z),w+31))return false;
	pxor	%xmm1, %xmm1	# _665
	cvtss2sd	72(%r15), %xmm1	# i_128(D)->camera[8], _665
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:339:        !narrow(i->camera[8]+zoom*(down[0]*x+down[1]*y+down[2]*z),w+31))return false;
	addsd	%xmm1, %xmm0	# _665, _678
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:310:     const double magnitude=fabs(v),midpoint=(double)FLT_MAX+0x1p103;
	movapd	%xmm0, %xmm1	# _678, magnitude
	andpd	.LC8(%rip), %xmm1	#, magnitude
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	ucomisd	%xmm1, %xmm6	# magnitude, tmp2391
	jb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	comisd	.LC38(%rip), %xmm1	#, magnitude
	jnb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	comisd	.LC39(%rip), %xmm1	#, magnitude
	jbe	.L977	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	pxor	%xmm1, %xmm1	# tmp1442
	comisd	%xmm0, %xmm1	# _678, tmp1442
	ja	.L1041	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movaps	%xmm14, %xmm0	# iftmp.26_1507, iftmp.26_681
.L827:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movzwl	%r9w, %edi	# load_dst_1655, _448
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	48(%rsp), %eax	# %sfp, _447
	movq	%rcx, 88(%rsp)	# _152, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	imulq	$72, %rdi, %rdi	#, _448, _449
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	(%rsp), %rcx	# %sfp, _417
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	%xmm0, 124(%rbp)	# iftmp.26_681, MEM[(float *)_458 + 124B]
	movq	%r11, 144(%rsp)	# ivtmp.927, %sfp
	movq	%r10, 112(%rsp)	# ivtmp.929, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rdi, %rax	# _449, _450
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:340:     const uint16_t color=pack_rgb(states(i)[id].color),opacity=(uint16_t)floor(states(i)[id].opacity*255+0.5),
	movl	12(%rsi), %edi	# _80->color, _80->color
	movq	%rdx, 104(%rsp)	# tmp1188, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rax, %rcx	# _450, _417
	movq	%r8, 96(%rsp)	# _1363, %sfp
	movq	%rcx, (%rsp)	# _417, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:340:     const uint16_t color=pack_rgb(states(i)[id].color),opacity=(uint16_t)floor(states(i)[id].opacity*255+0.5),
	call	pack_rgb	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:340:     const uint16_t color=pack_rgb(states(i)[id].color),opacity=(uint16_t)floor(states(i)[id].opacity*255+0.5),
	movsd	.LC5(%rip), %xmm0	#, _685
	mulsd	(%rsi), %xmm0	# _80->opacity, _685
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:340:     const uint16_t color=pack_rgb(states(i)[id].color),opacity=(uint16_t)floor(states(i)[id].opacity*255+0.5),
	addsd	.LC6(%rip), %xmm0	#, _686
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:340:     const uint16_t color=pack_rgb(states(i)[id].color),opacity=(uint16_t)floor(states(i)[id].opacity*255+0.5),
	movw	%ax, 32(%rsp)	# tmp1955, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:340:     const uint16_t color=pack_rgb(states(i)[id].color),opacity=(uint16_t)floor(states(i)[id].opacity*255+0.5),
	call	floor@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:341:         thickness=(uint16_t)floor(fmin(1,md(material+48)*hypot3(m[2],m[6],m[10]))*255+0.5);
	movq	(%rsp), %rcx	# %sfp, _451
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:340:     const uint16_t color=pack_rgb(states(i)[id].color),opacity=(uint16_t)floor(states(i)[id].opacity*255+0.5),
	movsd	%xmm0, 80(%rsp)	# _687, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:341:         thickness=(uint16_t)floor(fmin(1,md(material+48)*hypot3(m[2],m[6],m[10]))*255+0.5);
	leaq	48(%rcx), %rdi	#, _689
	call	md	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:308: static double hypot3(double x,double y,double z){return hypot(hypot(x,y),z);}
	movsd	64(%rsp), %xmm1	# %sfp,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:341:         thickness=(uint16_t)floor(fmin(1,md(material+48)*hypot3(m[2],m[6],m[10]))*255+0.5);
	movsd	%xmm0, 48(%rsp)	# tmp1957, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:308: static double hypot3(double x,double y,double z){return hypot(hypot(x,y),z);}
	movsd	56(%rsp), %xmm0	# %sfp,
	call	hypot@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:308: static double hypot3(double x,double y,double z){return hypot(hypot(x,y),z);}
	movsd	72(%rsp), %xmm1	# %sfp,
	call	hypot@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:341:         thickness=(uint16_t)floor(fmin(1,md(material+48)*hypot3(m[2],m[6],m[10]))*255+0.5);
	mulsd	48(%rsp), %xmm0	# %sfp, _692
	movsd	.LC9(%rip), %xmm1	#,
	call	fmin@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:341:         thickness=(uint16_t)floor(fmin(1,md(material+48)*hypot3(m[2],m[6],m[10]))*255+0.5);
	mulsd	.LC5(%rip), %xmm0	#, _694
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:341:         thickness=(uint16_t)floor(fmin(1,md(material+48)*hypot3(m[2],m[6],m[10]))*255+0.5);
	addsd	.LC6(%rip), %xmm0	#, _695
	call	floor@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:340:     const uint16_t color=pack_rgb(states(i)[id].color),opacity=(uint16_t)floor(states(i)[id].opacity*255+0.5),
	movsd	80(%rsp), %xmm2	# %sfp, _687
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:347:     if(!narrow(md(material+64),w+55))return false;
	movq	(%rsp), %rcx	# %sfp, _451
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:319:     memcpy((uint8_t *)storage+offset+2*index,&value,2);
	movw	$0, 240(%rbp)	#, MEM <unsigned short> [(char * {ref-all})_458 + 240B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:346:     w[49]=1;w[50]=-0.0f;w[51]=0;w[52]=0;w[53]=1;w[54]=0;
	movq	$1065353216, 212(%rbp)	#, MEM <vector(2) float> [(float *)_458 + 212B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:341:         thickness=(uint16_t)floor(fmin(1,md(material+48)*hypot3(m[2],m[6],m[10]))*255+0.5);
	cvttsd2sil	%xmm0, %eax	# tmp1961, tmp1465
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:346:     w[49]=1;w[50]=-0.0f;w[51]=0;w[52]=0;w[53]=1;w[54]=0;
	movaps	.LC41(%rip), %xmm0	#, tmp1476
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:340:     const uint16_t color=pack_rgb(states(i)[id].color),opacity=(uint16_t)floor(states(i)[id].opacity*255+0.5),
	cvttsd2sil	%xmm2, %esi	# _687, tmp1463
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:347:     if(!narrow(md(material+64),w+55))return false;
	leaq	64(%rcx), %rdi	#, _698
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:346:     w[49]=1;w[50]=-0.0f;w[51]=0;w[52]=0;w[53]=1;w[54]=0;
	movups	%xmm0, 196(%rbp)	# tmp1476, MEM <vector(4) float> [(float *)_458 + 196B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:319:     memcpy((uint8_t *)storage+offset+2*index,&value,2);
	movzwl	%ax, %eax	# tmp1465, thickness_697
	movzwl	%si, %esi	# tmp1463, opacity_688
	salq	$16, %rax	#, tmp1468
	orq	%rsi, %rax	# opacity_688, tmp1469
	movzwl	32(%rsp), %esi	# %sfp, color
	salq	$16, %rax	#, tmp1471
	orq	%rsi, %rax	# color, tmp1472
	salq	$16, %rax	#, tmp1474
	orq	%rsi, %rax	# color, tmp1475
	movq	%rax, 232(%rbp)	# tmp1475, MEM <vector(4) unsigned short> [(char * {ref-all})_458 + 232B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:347:     if(!narrow(md(material+64),w+55))return false;
	call	md	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	movsd	.LC22(%rip), %xmm6	#, tmp2400
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:310:     const double magnitude=fabs(v),midpoint=(double)FLT_MAX+0x1p103;
	movapd	%xmm0, %xmm1	# _699, magnitude
	andpd	.LC8(%rip), %xmm1	#, magnitude
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	ucomisd	%xmm1, %xmm6	# magnitude, tmp2400
	jb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	comisd	.LC38(%rip), %xmm1	#, magnitude
	jnb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	comisd	.LC39(%rip), %xmm1	#, magnitude
	movq	88(%rsp), %rcx	# %sfp, _152
	movss	.LC0(%rip), %xmm10	#, tmp1837
	movq	96(%rsp), %r8	# %sfp, _1363
	movq	104(%rsp), %rdx	# %sfp, tmp1188
	movss	.LC1(%rip), %xmm14	#, iftmp.26_1507
	movq	112(%rsp), %r10	# %sfp, ivtmp.929
	movq	144(%rsp), %r11	# %sfp, ivtmp.927
	jbe	.L979	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	pxor	%xmm1, %xmm1	# tmp1483
	comisd	%xmm0, %xmm1	# _699, tmp1483
	ja	.L1042	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movaps	%xmm14, %xmm0	# iftmp.26_1507, iftmp.26_702
.L831:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:349:     for(uint32_t k=0;k<model->section[7].count;++k){
	movl	80(%r14), %r9d	# model_416->section[7].count, _760
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:348:     w[56]=0;w[57]=1;
	movl	$127, %eax	#, tmp2401
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	%xmm0, 220(%rbp)	# iftmp.26_702, MEM[(float *)_458 + 220B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:349:     for(uint32_t k=0;k<model->section[7].count;++k){
	xorl	%edi, %edi	# k
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:348:     w[56]=0;w[57]=1;
	salq	$55, %rax	#, tmp2401
	movq	%rax, 224(%rbp)	# tmp2401, MEM <unsigned long> [(float *)_458 + 224B]
	movl	%r9d, (%rsp)	# _760, %sfp
.L833:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:349:     for(uint32_t k=0;k<model->section[7].count;++k){
	movl	(%rsp), %eax	# %sfp, _760
	cmpl	%eax, %edi	# _760, k
	je	.L1043	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	76(%r14), %esi	# model_416->section[7].offset, _705
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	%edi, %eax	# k, _1596
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:351:         if(m16(region)!=id)continue;
	movl	24(%rsp), %r9d	# %sfp, _1506
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	sall	$5, %eax	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rax, %rsi	# _708, _709
	addq	(%r14), %rsi	# model_416->data, _710
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:351:         if(m16(region)!=id)continue;
	movzwl	(%rsi), %eax	# MEM <short unsigned int> [(const uint8_t *)_710], _718
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:351:         if(m16(region)!=id)continue;
	cmpl	%r9d, %eax	# _1506, _718
	je	.L834	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:349:     for(uint32_t k=0;k<model->section[7].count;++k){
	addl	$1, %edi	#, k
	jmp	.L833	#
	.p2align 4,,10
	.p2align 3
.L1039:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:601:            (node[2]==3&&!mesh_packet(i,j,right,down,forward,false)))
	movl	24(%rsp), %esi	# %sfp,
	xorl	%r9d, %r9d	#
	movq	%r15, %rdi	# i,
	movq	%r11, 32(%rsp)	# ivtmp.927, %sfp
	movq	376(%rsp), %rcx	# %sfp,
	movq	384(%rsp), %rdx	# %sfp,
	leaq	456(%rsp), %r8	#,
	movq	%r10, (%rsp)	# ivtmp.929, %sfp
	call	mesh_packet	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:601:            (node[2]==3&&!mesh_packet(i,j,right,down,forward,false)))
	testb	%al, %al	# tmp1973
	je	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:603:         if(node[2]){add_count(&i->stats.projection_updates,1);add_count(&i->stats.shade_updates,1);}
	movzbl	2(%r12), %edi	# MEM[(const uint8_t *)_243 + 2B], _87
	movq	32(%rsp), %r11	# %sfp, ivtmp.927
	movss	.LC0(%rip), %xmm10	#, tmp1837
	movss	.LC1(%rip), %xmm14	#, iftmp.26_1507
	movq	(%rsp), %r10	# %sfp, ivtmp.929
	jmp	.L877	#
	.p2align 4,,10
	.p2align 3
.L1038:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:386:     const ayatsuri_model *model=i->model;const uint8_t *node=row(model,1,id,16),*material=row(model,5,m16(node+8),72);
	movq	(%r15), %r14	# i_128(D)->model, model
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movq	8(%r15), %rbp	# i_128(D)->arena, _794
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	20(%r14), %eax	# model_764->section[0].offset, _767
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	(%r14), %rdi	# model_764->data, _765
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rcx, %rax	# _152, _770
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	%rdi, 184(%rsp)	# _765, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	leaq	(%rdi,%rax), %r9	#, _771
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	52(%r14), %eax	# model_764->section[4].offset, _780
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:387:     const unsigned count=m16(node+6);float *w=work(i,id),*packet=w+79+6*count;
	movzwl	6(%r9), %edi	# MEM <short unsigned int> [(const uint8_t *)_771 + 6B], count
	movzwl	8(%r9), %esi	# MEM <short unsigned int> [(const uint8_t *)_771 + 8B], load_dst_1701
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	%eax, 396(%rsp)	# _780, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	leaq	0(%rbp,%rdx), %rax	#, _797
	movq	%rax, 400(%rsp)	# _797, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movl	8(%rax), %eax	# _797->offset, _799
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	addq	%rax, %rbp	# _799, _800
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:387:     const unsigned count=m16(node+6);float *w=work(i,id),*packet=w+79+6*count;
	leal	(%rdi,%rdi,2), %eax	#, _801
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:387:     const unsigned count=m16(node+6);float *w=work(i,id),*packet=w+79+6*count;
	leal	79(%rax,%rax), %eax	#,
	movq	%rax, 208(%rsp)	# ivtmp.833, %sfp
	xorl	%eax, %eax	# ivtmp.838
.L838:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:388:     double m[12];for(unsigned k=0;k<12;++k)m[k]=w[k];
	movups	0(%rbp,%rax), %xmm1	# MEM <vector(4) float> [(float *)_800 + ivtmp.838_1600 * 1], MEM <vector(4) float> [(float *)_800 + ivtmp.838_1600 * 1]
	cvtps2pd	%xmm1, %xmm0	# MEM <vector(4) float> [(float *)_800 + ivtmp.838_1600 * 1], vect__811.668_492
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:388:     double m[12];for(unsigned k=0;k<12;++k)m[k]=w[k];
	movaps	%xmm0, (%rbx,%rax,2)	# vect__811.668_492, MEM <vector(2) double> [(double *)_1360 + ivtmp.838_1600 * 2]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:388:     double m[12];for(unsigned k=0;k<12;++k)m[k]=w[k];
	pxor	%xmm0, %xmm0	# tmp1507
	movhlps	%xmm1, %xmm0	# MEM <vector(4) float> [(float *)_800 + ivtmp.838_1600 * 1], tmp1507
	cvtps2pd	%xmm0, %xmm0	# tmp1507, vect__811.668_493
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:388:     double m[12];for(unsigned k=0;k<12;++k)m[k]=w[k];
	movaps	%xmm0, 16(%rbx,%rax,2)	# vect__811.668_493, MEM <vector(2) double> [(double *)_1360 + 16B + ivtmp.838_1600 * 2]
	addq	$16, %rax	#, ivtmp.838
	cmpq	$48, %rax	#, ivtmp.838
	jne	.L838	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:389:     const double zoom=i->camera[6];
	pxor	%xmm6, %xmm6	# zoom
	cvtss2sd	64(%r15), %xmm6	# i_128(D)->camera[6], zoom
	movapd	%xmm6, %xmm7	# zoom, _882
	movsd	%xmm6, 32(%rsp)	# zoom, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:412:     surface_write(w,252,2,(uint16_t)floor(fmin(1,md(material+48)*hypot3(m[2],m[6],m[10]))*255+0.5));
	movsd	896(%rsp), %xmm6	# MEM[(double[12] *)_1360][10], pretmp_2388
	unpcklpd	%xmm7, %xmm7	# _882
	movaps	%xmm7, 192(%rsp)	# _882, %sfp
	movsd	832(%rsp), %xmm7	# MEM[(double[12] *)_1360][2], pretmp_2386
	movsd	%xmm6, 112(%rsp)	# pretmp_2388, %sfp
	movsd	%xmm7, 96(%rsp)	# pretmp_2386, %sfp
	movsd	864(%rsp), %xmm7	# MEM[(double[12] *)_1360][6], pretmp_2387
	movsd	%xmm7, 104(%rsp)	# pretmp_2387, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:390:     for(unsigned l=0;l<count;++l){
	testl	%edi, %edi	# count
	je	.L839	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:393:             a=m[0]*rx,b=m[1]*ry,c=m[2]*rz,d=m[4]*rx,e=m[5]*ry,f=m[6]*rz,g=m[8]*rx,h=m[9]*ry,j=m[10]*rz,
	movapd	880(%rsp), %xmm6	# MEM <vector(2) double> [(double *)_1360 + 64B], vect__939.747
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	44(%r14), %eax	# model_764->section[3].offset, _826
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:390:     for(unsigned l=0;l<count;++l){
	movl	$0, 392(%rsp)	#, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:393:             a=m[0]*rx,b=m[1]*ry,c=m[2]*rz,d=m[4]*rx,e=m[5]*ry,f=m[6]*rz,g=m[8]*rx,h=m[9]*ry,j=m[10]*rz,
	movapd	848(%rsp), %xmm7	# MEM <vector(2) double> [(double *)_1360 + 32B], vect__933.741
	movq	%rcx, 408(%rsp)	# _152, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:393:             a=m[0]*rx,b=m[1]*ry,c=m[2]*rz,d=m[4]*rx,e=m[5]*ry,f=m[6]*rz,g=m[8]*rx,h=m[9]*ry,j=m[10]*rz,
	movaps	%xmm6, 304(%rsp)	# vect__939.747, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:393:             a=m[0]*rx,b=m[1]*ry,c=m[2]*rz,d=m[4]*rx,e=m[5]*ry,f=m[6]*rz,g=m[8]*rx,h=m[9]*ry,j=m[10]*rz,
	movapd	816(%rsp), %xmm5	# MEM <vector(2) double> [(double *)_1360], vect__927.736
	movhpd	%xmm6, 336(%rsp)	# vect__939.747, %sfp
	movlpd	%xmm6, 328(%rsp)	# vect__939.747, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	movsd	840(%rsp), %xmm6	# MEM[(double[12] *)_1360][3], _950
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	%rax, 256(%rsp)	# _826, %sfp
	leaq	1080(%rsp), %rax	#, _1630
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:393:             a=m[0]*rx,b=m[1]*ry,c=m[2]*rz,d=m[4]*rx,e=m[5]*ry,f=m[6]*rz,g=m[8]*rx,h=m[9]*ry,j=m[10]*rz,
	movaps	%xmm7, 272(%rsp)	# vect__933.741, %sfp
	movhpd	%xmm7, 320(%rsp)	# vect__933.741, %sfp
	movlpd	%xmm7, 296(%rsp)	# vect__933.741, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	movsd	872(%rsp), %xmm7	# MEM[(double[12] *)_1360][7], _960
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	movsd	%xmm6, 344(%rsp)	# _950, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	904(%rsp), %xmm6	# MEM[(double[12] *)_1360][11], _970
	movq	%rax, 368(%rsp)	# _1630, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:393:             a=m[0]*rx,b=m[1]*ry,c=m[2]*rz,d=m[4]*rx,e=m[5]*ry,f=m[6]*rz,g=m[8]*rx,h=m[9]*ry,j=m[10]*rz,
	movaps	%xmm5, 240(%rsp)	# vect__927.736, %sfp
	movhpd	%xmm5, 288(%rsp)	# vect__927.736, %sfp
	movlpd	%xmm5, 264(%rsp)	# vect__927.736, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	movsd	%xmm7, 352(%rsp)	# _960, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	%xmm6, 360(%rsp)	# _970, %sfp
.L847:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:391:         const uint8_t *local=row(model,4,m16(node+4)+l,24);
	movl	392(%rsp), %ebx	# %sfp, l
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:391:         const uint8_t *local=row(model,4,m16(node+4)+l,24);
	movzwl	4(%r9), %eax	# MEM <short unsigned int> [(const uint8_t *)_771 + 4B], _822
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:392:         const double x=mf(local),y=mf(local+4),z=mf(local+8),rx=mf(local+12),ry=mf(local+16),rz=mf(local+20),
	pxor	%xmm2, %xmm2	# rz
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:392:         const double x=mf(local),y=mf(local+4),z=mf(local+8),rx=mf(local+12),ry=mf(local+16),rz=mf(local+20),
	pxor	%xmm12, %xmm12	# x
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:393:             a=m[0]*rx,b=m[1]*ry,c=m[2]*rz,d=m[4]*rx,e=m[5]*ry,f=m[6]*rz,g=m[8]*rx,h=m[9]*ry,j=m[10]*rz,
	movsd	96(%rsp), %xmm0	# %sfp, c
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:393:             a=m[0]*rx,b=m[1]*ry,c=m[2]*rz,d=m[4]*rx,e=m[5]*ry,f=m[6]*rz,g=m[8]*rx,h=m[9]*ry,j=m[10]*rz,
	movsd	104(%rsp), %xmm5	# %sfp, f
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:392:         const double x=mf(local),y=mf(local+4),z=mf(local+8),rx=mf(local+12),ry=mf(local+16),rz=mf(local+20),
	pxor	%xmm3, %xmm3	# y
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:392:         const double x=mf(local),y=mf(local+4),z=mf(local+8),rx=mf(local+12),ry=mf(local+16),rz=mf(local+20),
	pxor	%xmm11, %xmm11	# z
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	movsd	264(%rsp), %xmm13	# %sfp, _945
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:391:         const uint8_t *local=row(model,4,m16(node+4)+l,24);
	addl	%ebx, %eax	# l, _824
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	256(%rsp), %rbx	# %sfp, _826
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	movsd	288(%rsp), %xmm4	# %sfp, _946
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	leal	(%rax,%rax,2), %eax	#, _827
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:393:             a=m[0]*rx,b=m[1]*ry,c=m[2]*rz,d=m[4]*rx,e=m[5]*ry,f=m[6]*rz,g=m[8]*rx,h=m[9]*ry,j=m[10]*rz,
	movapd	304(%rsp), %xmm15	# %sfp, vect_g_940.748
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	leal	0(,%rax,8), %eax	#, _828
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:393:             a=m[0]*rx,b=m[1]*ry,c=m[2]*rz,d=m[4]*rx,e=m[5]*ry,f=m[6]*rz,g=m[8]*rx,h=m[9]*ry,j=m[10]*rz,
	movapd	272(%rsp), %xmm9	# %sfp, vect_d_934.742
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rbx, %rax	# _826, _829
	movq	184(%rsp), %rbx	# %sfp, _765
	addq	%rbx, %rax	# _765, _830
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:392:         const double x=mf(local),y=mf(local+4),z=mf(local+8),rx=mf(local+12),ry=mf(local+16),rz=mf(local+20),
	cvtss2sd	20(%rax), %xmm2	# MEM <unsigned int> [(const uint8_t *)_830 + 20B], rz
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:393:             a=m[0]*rx,b=m[1]*ry,c=m[2]*rz,d=m[4]*rx,e=m[5]*ry,f=m[6]*rz,g=m[8]*rx,h=m[9]*ry,j=m[10]*rz,
	mulsd	%xmm2, %xmm5	# rz, f
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:392:         const double x=mf(local),y=mf(local+4),z=mf(local+8),rx=mf(local+12),ry=mf(local+16),rz=mf(local+20),
	cvtss2sd	(%rax), %xmm12	# MEM <unsigned int> [(const uint8_t *)_830], x
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:392:         const double x=mf(local),y=mf(local+4),z=mf(local+8),rx=mf(local+12),ry=mf(local+16),rz=mf(local+20),
	cvtss2sd	4(%rax), %xmm3	# MEM <unsigned int> [(const uint8_t *)_830 + 4B], y
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:393:             a=m[0]*rx,b=m[1]*ry,c=m[2]*rz,d=m[4]*rx,e=m[5]*ry,f=m[6]*rz,g=m[8]*rx,h=m[9]*ry,j=m[10]*rz,
	mulsd	%xmm2, %xmm0	# rz, c
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:392:         const double x=mf(local),y=mf(local+4),z=mf(local+8),rx=mf(local+12),ry=mf(local+16),rz=mf(local+20),
	cvtss2sd	8(%rax), %xmm11	# MEM <unsigned int> [(const uint8_t *)_830 + 8B], z
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:15: static uint32_t m32(const uint8_t *p){return (uint32_t)p[0]|(uint32_t)p[1]<<8|(uint32_t)p[2]<<16|(uint32_t)p[3]<<24;}
	movq	12(%rax), %xmm8	# MEM <vector(2) unsigned int> [(const uint8_t *)_830 + 12B], vect__892.731_885
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:393:             a=m[0]*rx,b=m[1]*ry,c=m[2]*rz,d=m[4]*rx,e=m[5]*ry,f=m[6]*rz,g=m[8]*rx,h=m[9]*ry,j=m[10]*rz,
	mulsd	112(%rsp), %xmm2	# %sfp, rz
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	mulsd	%xmm12, %xmm13	# x, _945
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:392:         const double x=mf(local),y=mf(local+4),z=mf(local+8),rx=mf(local+12),ry=mf(local+16),rz=mf(local+20),
	cvtps2pd	%xmm8, %xmm8	# vect__892.731_885, vect_rx_894.733
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	mulsd	%xmm3, %xmm4	# y, _946
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:393:             a=m[0]*rx,b=m[1]*ry,c=m[2]*rz,d=m[4]*rx,e=m[5]*ry,f=m[6]*rz,g=m[8]*rx,h=m[9]*ry,j=m[10]*rz,
	mulpd	%xmm8, %xmm15	# vect_rx_894.733, vect_g_940.748
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:393:             a=m[0]*rx,b=m[1]*ry,c=m[2]*rz,d=m[4]*rx,e=m[5]*ry,f=m[6]*rz,g=m[8]*rx,h=m[9]*ry,j=m[10]*rz,
	mulpd	%xmm8, %xmm9	# vect_rx_894.733, vect_d_934.742
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:393:             a=m[0]*rx,b=m[1]*ry,c=m[2]*rz,d=m[4]*rx,e=m[5]*ry,f=m[6]*rz,g=m[8]*rx,h=m[9]*ry,j=m[10]*rz,
	mulpd	240(%rsp), %xmm8	# %sfp, vect_a_928.737
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:393:             a=m[0]*rx,b=m[1]*ry,c=m[2]*rz,d=m[4]*rx,e=m[5]*ry,f=m[6]*rz,g=m[8]*rx,h=m[9]*ry,j=m[10]*rz,
	movsd	%xmm2, (%rsp)	# rz, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	movsd	96(%rsp), %xmm2	# %sfp, _948
	mulsd	%xmm11, %xmm2	# z, _948
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	addsd	%xmm13, %xmm4	# _945, _947
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	pxor	%xmm13, %xmm13	# _953
	cvtss2sd	52(%r15), %xmm13	# i_128(D)->camera[3], _953
	movhpd	%xmm15, 56(%rsp)	# vect_g_940.748, %sfp
	movhpd	%xmm9, 48(%rsp)	# vect_d_934.742, %sfp
	movapd	%xmm9, %xmm1	# vect_d_934.742, _1241
	movapd	%xmm8, %xmm7	# vect_a_928.737, vect_a_928.737
	unpckhpd	%xmm7, %xmm7	# vect_a_928.737
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	addsd	%xmm2, %xmm4	# _948, _949
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	movsd	104(%rsp), %xmm2	# %sfp, _958
	movapd	%xmm7, %xmm6	# vect_a_928.737, _896
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	addsd	344(%rsp), %xmm4	# %sfp, _951
	movapd	%xmm8, %xmm7	# vect_a_928.737, _895
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	mulsd	%xmm11, %xmm2	# z, _958
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	subsd	%xmm13, %xmm4	# _953, _951
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	movsd	296(%rsp), %xmm13	# %sfp, _955
	mulsd	%xmm12, %xmm13	# x, _955
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	328(%rsp), %xmm12	# %sfp, _965
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	movsd	%xmm4, 72(%rsp)	# _951, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	movsd	320(%rsp), %xmm4	# %sfp, _956
	mulsd	%xmm3, %xmm4	# y, _956
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	336(%rsp), %xmm3	# %sfp, _966
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	addsd	%xmm13, %xmm4	# _955, _957
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	pxor	%xmm13, %xmm13	# _963
	cvtss2sd	56(%r15), %xmm13	# i_128(D)->camera[4], _963
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	addsd	%xmm12, %xmm3	# _965, _967
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	addsd	%xmm2, %xmm4	# _958, _959
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	addsd	352(%rsp), %xmm4	# %sfp, _961
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:394:             wx=m[0]*x+m[1]*y+m[2]*z+m[3]-i->camera[3],wy=m[4]*x+m[5]*y+m[6]*z+m[7]-i->camera[4],
	subsd	%xmm13, %xmm4	# _963, _961
	movsd	%xmm4, 80(%rsp)	# _961, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	112(%rsp), %xmm11	# %sfp, _968
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	pxor	%xmm4, %xmm4	# _973
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	48(%rsp), %xmm13	# %sfp, _904
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	cvtss2sd	60(%r15), %xmm4	# i_128(D)->camera[5], _973
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	(%rsp), %xmm2	# %sfp, j
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	%xmm15, 64(%rsp)	# _915, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	addsd	%xmm11, %xmm3	# _968, _969
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	addsd	360(%rsp), %xmm3	# %sfp, _971
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:396:         if(!isfinite(det)||fabs(det)<1e-12)return false;
	movsd	.LC22(%rip), %xmm11	#, tmp2469
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	subsd	%xmm4, %xmm3	# _973, _971
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm13, %xmm4	# _904, _975
	mulsd	%xmm2, %xmm4	# j, _975
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm9, %xmm2	# _1241, _979
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	%xmm3, 88(%rsp)	# _971, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	56(%rsp), %xmm3	# %sfp, _976
	mulsd	%xmm5, %xmm3	# f, _976
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm4, %xmm12	# _975, _975
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	56(%rsp), %xmm4	# %sfp, _984
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	%xmm2, 152(%rsp)	# _979, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm9, %xmm4	# _1241, _984
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	subsd	%xmm3, %xmm12	# _976, _975
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm13, %xmm3	# _904, _985
	mulsd	%xmm15, %xmm3	# tmp47, _985
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	%xmm12, 144(%rsp)	# _975, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm15, %xmm12	# _915, _980
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm4, %xmm13	# _984, _984
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm5, %xmm12	# f, _980
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	subsd	%xmm3, %xmm13	# _985, _984
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	144(%rsp), %xmm3	# %sfp, _978
	mulsd	%xmm8, %xmm3	# _895, _978
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	%xmm13, 168(%rsp)	# _986, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	subsd	%xmm12, %xmm2	#, _981
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm0, %xmm13	# c, _987
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	%xmm12, 160(%rsp)	# _980, %sfp
	movapd	%xmm2, %xmm4	# _981, _981
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm6, %xmm4	# _896, _982
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	subsd	%xmm4, %xmm3	# _982, _983
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:395:             wz=m[8]*x+m[9]*y+m[10]*z+m[11]-i->camera[5],det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	addsd	%xmm13, %xmm3	# _987, _983
	movapd	%xmm3, %xmm13	# _983, det
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:396:         if(!isfinite(det)||fabs(det)<1e-12)return false;
	andpd	.LC8(%rip), %xmm3	#, _989
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:396:         if(!isfinite(det)||fabs(det)<1e-12)return false;
	ucomisd	%xmm3, %xmm11	# _989, tmp2469
	jb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:396:         if(!isfinite(det)||fabs(det)<1e-12)return false;
	movsd	.LC40(%rip), %xmm11	#, tmp2470
	comisd	%xmm3, %xmm11	# _989, tmp2470
	ja	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:398:             zoom*(right[0]*a+right[1]*d+right[2]*g),zoom*(right[0]*b+right[1]*e+right[2]*h),
	pxor	%xmm2, %xmm2	# _991
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:398:             zoom*(right[0]*a+right[1]*d+right[2]*g),zoom*(right[0]*b+right[1]*e+right[2]*h),
	pxor	%xmm4, %xmm4	# _994
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:398:             zoom*(right[0]*a+right[1]*d+right[2]*g),zoom*(right[0]*b+right[1]*e+right[2]*h),
	pxor	%xmm12, %xmm12	# _998
	movq	%r13, %rax	# ivtmp.780, ivtmp.827
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:398:             zoom*(right[0]*a+right[1]*d+right[2]*g),zoom*(right[0]*b+right[1]*e+right[2]*h),
	cvtss2sd	484(%rsp), %xmm2	# MEM[(const float *)&right], _991
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:398:             zoom*(right[0]*a+right[1]*d+right[2]*g),zoom*(right[0]*b+right[1]*e+right[2]*h),
	movapd	%xmm2, %xmm3	# _991, _897
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	pxor	%xmm11, %xmm11	# _1024
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:398:             zoom*(right[0]*a+right[1]*d+right[2]*g),zoom*(right[0]*b+right[1]*e+right[2]*h),
	cvtss2sd	488(%rsp), %xmm4	# MEM[(const float *)&right + 4B], _994
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:398:             zoom*(right[0]*a+right[1]*d+right[2]*g),zoom*(right[0]*b+right[1]*e+right[2]*h),
	unpcklpd	%xmm3, %xmm3	# _897
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:397:         const double values[21]={
	movl	$-8, %ecx	#, ivtmp.829
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:398:             zoom*(right[0]*a+right[1]*d+right[2]*g),zoom*(right[0]*b+right[1]*e+right[2]*h),
	cvtss2sd	492(%rsp), %xmm12	# MEM[(const float *)&right + 8B], _998
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	movsd	%xmm2, 176(%rsp)	# _991, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	cvtss2sd	472(%rsp), %xmm11	# MEM[(const float *)&down], _1024
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:398:             zoom*(right[0]*a+right[1]*d+right[2]*g),zoom*(right[0]*b+right[1]*e+right[2]*h),
	mulpd	%xmm3, %xmm8	# _897, vect__992.738_898
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:398:             zoom*(right[0]*a+right[1]*d+right[2]*g),zoom*(right[0]*b+right[1]*e+right[2]*h),
	movapd	%xmm4, %xmm3	# _994, _905
	unpcklpd	%xmm3, %xmm3	# _905
	mulpd	%xmm9, %xmm3	# vect_d_934.742, vect__995.743_906
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	movapd	%xmm5, %xmm9	# f, _1009
	mulsd	%xmm4, %xmm9	# _994, _1009
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	mulsd	80(%rsp), %xmm4	# %sfp, _1017
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:398:             zoom*(right[0]*a+right[1]*d+right[2]*g),zoom*(right[0]*b+right[1]*e+right[2]*h),
	addpd	%xmm8, %xmm3	# vect__992.738_898, vect__996.744_907
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:398:             zoom*(right[0]*a+right[1]*d+right[2]*g),zoom*(right[0]*b+right[1]*e+right[2]*h),
	movapd	%xmm12, %xmm8	# _998, _918
	unpcklpd	%xmm8, %xmm8	# _918
	mulpd	%xmm15, %xmm8	# vect_g_940.748, vect__999.749_919
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:401:             zoom*(down[0]*c+down[1]*f+down[2]*j),i->camera[8]+zoom*(down[0]*wx+down[1]*wy+down[2]*wz),
	movsd	72(%rsp), %xmm15	# %sfp, _1049
	mulsd	%xmm11, %xmm15	# _1024, _1049
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:398:             zoom*(right[0]*a+right[1]*d+right[2]*g),zoom*(right[0]*b+right[1]*e+right[2]*h),
	addpd	%xmm8, %xmm3	# vect__999.749_919, vect__1000.750_1242
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	movapd	%xmm2, %xmm8	# _991, _1008
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	movsd	32(%rsp), %xmm2	# %sfp, zoom
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:398:             zoom*(right[0]*a+right[1]*d+right[2]*g),zoom*(right[0]*b+right[1]*e+right[2]*h),
	mulpd	192(%rsp), %xmm3	# %sfp, vect__1001.751_920
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	mulsd	%xmm0, %xmm8	# c, _1008
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:397:         const double values[21]={
	movaps	%xmm3, 912(%rsp)	# vect__1001.751_920, MEM <vector(2) double> [(double *)_883]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	movapd	%xmm9, %xmm3	# _1009, _1009
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	pxor	%xmm9, %xmm9	# _1031
	cvtss2sd	480(%rsp), %xmm9	# MEM[(const float *)&down + 8B], _1031
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	addsd	%xmm8, %xmm3	# _1008, _1010
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	movsd	(%rsp), %xmm8	# %sfp, _1011
	mulsd	%xmm12, %xmm8	# _998, _1011
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	mulsd	88(%rsp), %xmm12	# %sfp, _1019
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	addsd	%xmm8, %xmm3	# _1011, _1012
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:401:             zoom*(down[0]*c+down[1]*f+down[2]*j),i->camera[8]+zoom*(down[0]*wx+down[1]*wy+down[2]*wz),
	movsd	80(%rsp), %xmm8	# %sfp, _1050
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	mulsd	%xmm2, %xmm3	# zoom, _1013
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:397:         const double values[21]={
	movsd	%xmm3, 928(%rsp)	# _1013, MEM[(double[21] *)_883][2]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	pxor	%xmm3, %xmm3	# _1027
	cvtss2sd	476(%rsp), %xmm3	# MEM[(const float *)&down + 4B], _1027
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:401:             zoom*(down[0]*c+down[1]*f+down[2]*j),i->camera[8]+zoom*(down[0]*wx+down[1]*wy+down[2]*wz),
	mulsd	%xmm3, %xmm8	# _1027, _1050
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:401:             zoom*(down[0]*c+down[1]*f+down[2]*j),i->camera[8]+zoom*(down[0]*wx+down[1]*wy+down[2]*wz),
	addsd	%xmm15, %xmm8	# _1049, _1051
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:401:             zoom*(down[0]*c+down[1]*f+down[2]*j),i->camera[8]+zoom*(down[0]*wx+down[1]*wy+down[2]*wz),
	movsd	88(%rsp), %xmm15	# %sfp, _1052
	mulsd	%xmm9, %xmm15	# _1031, _1052
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:401:             zoom*(down[0]*c+down[1]*f+down[2]*j),i->camera[8]+zoom*(down[0]*wx+down[1]*wy+down[2]*wz),
	addsd	%xmm15, %xmm8	# _1052, _1053
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:401:             zoom*(down[0]*c+down[1]*f+down[2]*j),i->camera[8]+zoom*(down[0]*wx+down[1]*wy+down[2]*wz),
	pxor	%xmm15, %xmm15	# _1048
	cvtss2sd	72(%r15), %xmm15	# i_128(D)->camera[8], _1048
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:401:             zoom*(down[0]*c+down[1]*f+down[2]*j),i->camera[8]+zoom*(down[0]*wx+down[1]*wy+down[2]*wz),
	mulsd	%xmm2, %xmm8	#, _1054
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:401:             zoom*(down[0]*c+down[1]*f+down[2]*j),i->camera[8]+zoom*(down[0]*wx+down[1]*wy+down[2]*wz),
	addsd	%xmm15, %xmm8	# _1048, _1055
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	movsd	144(%rsp), %xmm15	# %sfp, _977
	divsd	%xmm13, %xmm15	# det, _977
	movapd	%xmm8, %xmm2	# _1055, tmp1571
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:404:             forward[0]*a+forward[1]*d+forward[2]*g,forward[0]*b+forward[1]*e+forward[2]*h,
	pxor	%xmm8, %xmm8	# _1088
	cvtss2sd	460(%rsp), %xmm8	# MEM[(const float *)&forward + 4B], _1088
	movsd	%xmm8, 144(%rsp)	# _1088, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:404:             forward[0]*a+forward[1]*d+forward[2]*g,forward[0]*b+forward[1]*e+forward[2]*h,
	pxor	%xmm8, %xmm8	# _1092
	cvtss2sd	464(%rsp), %xmm8	# MEM[(const float *)&forward + 8B], _1092
	movsd	%xmm8, 216(%rsp)	# _1092, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	pxor	%xmm8, %xmm8	# _1015
	cvtss2sd	68(%r15), %xmm8	# i_128(D)->camera[7], _1015
	unpcklpd	%xmm15, %xmm2	# _1056, tmp1571
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:404:             forward[0]*a+forward[1]*d+forward[2]*g,forward[0]*b+forward[1]*e+forward[2]*h,
	pxor	%xmm15, %xmm15	# _1085
	movaps	%xmm2, 224(%rsp)	# tmp1571, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	movsd	176(%rsp), %xmm2	# %sfp, _991
	mulsd	72(%rsp), %xmm2	# %sfp, _991
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:404:             forward[0]*a+forward[1]*d+forward[2]*g,forward[0]*b+forward[1]*e+forward[2]*h,
	cvtss2sd	456(%rsp), %xmm15	# MEM[(const float *)&forward], _1085
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	addsd	%xmm2, %xmm4	# _1016, _1018
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	movsd	32(%rsp), %xmm2	# %sfp, zoom
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	addsd	%xmm12, %xmm4	# _1019, _1020
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	movapd	%xmm7, %xmm12	# _895, _1025
	mulsd	%xmm11, %xmm12	# _1024, _1025
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	mulsd	%xmm2, %xmm4	# zoom, _1021
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:399:             zoom*(right[0]*c+right[1]*f+right[2]*j),i->camera[7]+zoom*(right[0]*wx+right[1]*wy+right[2]*wz),
	addsd	%xmm4, %xmm8	# _1021, _1022
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	movapd	%xmm3, %xmm4	# _1027, _1028
	mulsd	%xmm1, %xmm4	# _1241, _1028
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	addsd	%xmm12, %xmm4	# _1025, _1029
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	movsd	64(%rsp), %xmm12	# %sfp, _1032
	mulsd	%xmm9, %xmm12	# _1031, _1032
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	addsd	%xmm12, %xmm4	# _1032, _1033
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	movsd	48(%rsp), %xmm12	# %sfp, _904
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	mulsd	%xmm2, %xmm4	# zoom, _1034
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:397:         const double values[21]={
	unpcklpd	%xmm4, %xmm8	# _1034, _1180
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	movapd	%xmm6, %xmm4	# _896, _1035
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:397:         const double values[21]={
	movups	%xmm8, 936(%rsp)	# _1180, MEM <vector(2) double> [(double *)_883 + 24B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	mulsd	%xmm11, %xmm4	# _1024, _1035
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:401:             zoom*(down[0]*c+down[1]*f+down[2]*j),i->camera[8]+zoom*(down[0]*wx+down[1]*wy+down[2]*wz),
	mulsd	%xmm0, %xmm11	# c, _1041
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	movapd	%xmm4, %xmm8	# _1035, _1035
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	movapd	%xmm12, %xmm4	# _904, _1036
	mulsd	%xmm3, %xmm4	# _1027, _1036
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:401:             zoom*(down[0]*c+down[1]*f+down[2]*j),i->camera[8]+zoom*(down[0]*wx+down[1]*wy+down[2]*wz),
	mulsd	%xmm5, %xmm3	# f, _1042
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	addsd	%xmm8, %xmm4	# _1035, _1037
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	movsd	56(%rsp), %xmm8	# %sfp, _1038
	movq	208(%rsp), %rbx	# %sfp, ivtmp.833
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:401:             zoom*(down[0]*c+down[1]*f+down[2]*j),i->camera[8]+zoom*(down[0]*wx+down[1]*wy+down[2]*wz),
	addsd	%xmm11, %xmm3	# _1041, _1043
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	movsd	56(%rsp), %xmm11	# %sfp, _917
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	mulsd	%xmm9, %xmm8	# _1031, _1038
	leaq	0(%rbp,%rbx,4), %rbx	#, ivtmp.828
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	addsd	%xmm8, %xmm4	# _1038, _1039
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:400:             zoom*(down[0]*a+down[1]*d+down[2]*g),zoom*(down[0]*b+down[1]*e+down[2]*h),
	movapd	%xmm2, %xmm8	# zoom, zoom
	mulsd	%xmm2, %xmm4	# zoom, _1040
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:401:             zoom*(down[0]*c+down[1]*f+down[2]*j),i->camera[8]+zoom*(down[0]*wx+down[1]*wy+down[2]*wz),
	movsd	(%rsp), %xmm2	# %sfp, j
	mulsd	%xmm2, %xmm9	# j, _1044
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:401:             zoom*(down[0]*c+down[1]*f+down[2]*j),i->camera[8]+zoom*(down[0]*wx+down[1]*wy+down[2]*wz),
	addsd	%xmm9, %xmm3	# _1044, _1045
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	movsd	64(%rsp), %xmm9	# %sfp, _915
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:401:             zoom*(down[0]*c+down[1]*f+down[2]*j),i->camera[8]+zoom*(down[0]*wx+down[1]*wy+down[2]*wz),
	mulsd	%xmm8, %xmm3	# zoom, _1046
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:397:         const double values[21]={
	unpcklpd	%xmm3, %xmm4	# _1046, _1179
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	movsd	160(%rsp), %xmm3	# %sfp, _980
	subsd	152(%rsp), %xmm3	# %sfp, _980
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:397:         const double values[21]={
	movups	%xmm4, 952(%rsp)	# _1179, MEM <vector(2) double> [(double *)_883 + 40B]
	movapd	224(%rsp), %xmm4	# %sfp, tmp1571
	movups	%xmm4, 968(%rsp)	# tmp1571, MEM <vector(2) double> [(double *)_883 + 56B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	divsd	%xmm13, %xmm3	# det, _1058
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	movsd	168(%rsp), %xmm4	# %sfp, _986
	divsd	%xmm13, %xmm4	# det, _986
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:397:         const double values[21]={
	unpcklpd	%xmm4, %xmm3	# _1059, _1177
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	movapd	%xmm6, %xmm4	# _896, _1061
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:397:         const double values[21]={
	movups	%xmm3, 984(%rsp)	# _1177, MEM <vector(2) double> [(double *)_883 + 72B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	movapd	%xmm11, %xmm3	# _917, _1060
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	mulsd	%xmm2, %xmm4	# j, _1061
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	mulsd	%xmm0, %xmm3	# c, _1060
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	subsd	%xmm4, %xmm3	# _1061, _1062
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	movapd	%xmm7, %xmm4	# _895, _1064
	mulsd	%xmm2, %xmm4	#, _1064
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:404:             forward[0]*a+forward[1]*d+forward[2]*g,forward[0]*b+forward[1]*e+forward[2]*h,
	movsd	144(%rsp), %xmm2	# %sfp, _1088
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	divsd	%xmm13, %xmm3	# det, _1063
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	movapd	%xmm4, %xmm8	# _1064, _1064
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	movapd	%xmm9, %xmm4	# _915, _1065
	mulsd	%xmm0, %xmm4	# c, _1065
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	subsd	%xmm4, %xmm8	# _1065, _1066
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	movapd	%xmm11, %xmm4	# _917, _1069
	mulsd	%xmm7, %xmm4	# _895, _1069
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	divsd	%xmm13, %xmm8	# det, _1067
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:397:         const double values[21]={
	unpcklpd	%xmm8, %xmm3	# _1067, _1176
	movups	%xmm3, 1000(%rsp)	# _1176, MEM <vector(2) double> [(double *)_883 + 88B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	movapd	%xmm9, %xmm3	# _915, _1068
	mulsd	%xmm6, %xmm3	# _896, _1068
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	subsd	%xmm4, %xmm3	# _1069, _1070
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:403:             (b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det,
	movapd	%xmm6, %xmm4	# _896, _1072
	mulsd	%xmm5, %xmm4	# f, _1072
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:402:             (e*j-f*h)/det,(f*g-d*j)/det,(d*h-e*g)/det,(c*h-b*j)/det,(a*j-c*g)/det,(b*g-a*h)/det,
	divsd	%xmm13, %xmm3	# det, _1071
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:403:             (b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det,
	movapd	%xmm4, %xmm8	# _1072, _1072
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:403:             (b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det,
	movapd	%xmm12, %xmm4	# _904, _1073
	mulsd	%xmm0, %xmm4	# c, _1073
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:403:             (b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det,
	subsd	%xmm4, %xmm8	# _1073, _1074
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:403:             (b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det,
	movapd	%xmm0, %xmm4	# c, _1076
	mulsd	%xmm1, %xmm4	# _1241, _1076
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:405:             forward[0]*c+forward[1]*f+forward[2]*j,forward[0]*wx+forward[1]*wy+forward[2]*wz};
	mulsd	%xmm15, %xmm0	# _1085, _1100
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:403:             (b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det,
	divsd	%xmm13, %xmm8	# det, _1075
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:397:         const double values[21]={
	unpcklpd	%xmm8, %xmm3	# _1075, _1181
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:403:             (b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det,
	movapd	%xmm4, %xmm8	# _1076, _1076
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:403:             (b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det,
	movapd	%xmm12, %xmm4	# _904, _1080
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:397:         const double values[21]={
	movups	%xmm3, 1016(%rsp)	# _1181, MEM <vector(2) double> [(double *)_883 + 104B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:403:             (b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det,
	mulsd	%xmm7, %xmm4	# _895, _1080
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:403:             (b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det,
	movapd	%xmm7, %xmm3	# _895, _1077
	mulsd	%xmm5, %xmm3	# f, _1077
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:404:             forward[0]*a+forward[1]*d+forward[2]*g,forward[0]*b+forward[1]*e+forward[2]*h,
	mulsd	%xmm15, %xmm7	# _1085, _1086
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:404:             forward[0]*a+forward[1]*d+forward[2]*g,forward[0]*b+forward[1]*e+forward[2]*h,
	mulsd	%xmm2, %xmm12	# _1088, _904
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:405:             forward[0]*c+forward[1]*f+forward[2]*j,forward[0]*wx+forward[1]*wy+forward[2]*wz};
	mulsd	%xmm2, %xmm5	# _1088, _1101
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:403:             (b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det,
	subsd	%xmm3, %xmm8	# _1077, _1078
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:403:             (b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det,
	movapd	%xmm6, %xmm3	# _896, _1081
	mulsd	%xmm1, %xmm3	# _1241, _1081
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:404:             forward[0]*a+forward[1]*d+forward[2]*g,forward[0]*b+forward[1]*e+forward[2]*h,
	mulsd	%xmm2, %xmm1	# _1088, _1089
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:403:             (b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det,
	divsd	%xmm13, %xmm8	# det, _1079
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:405:             forward[0]*c+forward[1]*f+forward[2]*j,forward[0]*wx+forward[1]*wy+forward[2]*wz};
	addsd	%xmm5, %xmm0	# _1101, _1102
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:404:             forward[0]*a+forward[1]*d+forward[2]*g,forward[0]*b+forward[1]*e+forward[2]*h,
	mulsd	%xmm15, %xmm6	# _1085, _1095
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:403:             (b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det,
	subsd	%xmm3, %xmm4	# _1081, _1082
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:404:             forward[0]*a+forward[1]*d+forward[2]*g,forward[0]*b+forward[1]*e+forward[2]*h,
	addsd	%xmm7, %xmm1	# _1086, _1090
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:404:             forward[0]*a+forward[1]*d+forward[2]*g,forward[0]*b+forward[1]*e+forward[2]*h,
	movapd	%xmm2, %xmm7	# _1088, _1088
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:405:             forward[0]*c+forward[1]*f+forward[2]*j,forward[0]*wx+forward[1]*wy+forward[2]*wz};
	movsd	(%rsp), %xmm2	# %sfp, j
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:397:         const double values[21]={
	movq	%rdx, (%rsp)	# tmp1188, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:403:             (b*f-c*e)/det,(c*d-a*f)/det,(a*e-b*d)/det,
	divsd	%xmm13, %xmm4	# det, _1083
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:397:         const double values[21]={
	movapd	%xmm8, %xmm3	# _1079, _923
	unpcklpd	%xmm4, %xmm3	# _1083, _923
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:404:             forward[0]*a+forward[1]*d+forward[2]*g,forward[0]*b+forward[1]*e+forward[2]*h,
	movapd	%xmm11, %xmm4	# _917, _917
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:397:         const double values[21]={
	movups	%xmm3, 1032(%rsp)	# _923, MEM <vector(2) double> [(double *)_883 + 120B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:404:             forward[0]*a+forward[1]*d+forward[2]*g,forward[0]*b+forward[1]*e+forward[2]*h,
	movapd	%xmm9, %xmm3	# _915, _915
	movsd	216(%rsp), %xmm9	# %sfp, _1092
	mulsd	%xmm9, %xmm3	# _1092, _915
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:404:             forward[0]*a+forward[1]*d+forward[2]*g,forward[0]*b+forward[1]*e+forward[2]*h,
	mulsd	%xmm9, %xmm4	# _1092, _917
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:405:             forward[0]*c+forward[1]*f+forward[2]*j,forward[0]*wx+forward[1]*wy+forward[2]*wz};
	mulsd	%xmm9, %xmm2	# _1092, j
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:404:             forward[0]*a+forward[1]*d+forward[2]*g,forward[0]*b+forward[1]*e+forward[2]*h,
	addsd	%xmm3, %xmm1	# _1093, _1094
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:404:             forward[0]*a+forward[1]*d+forward[2]*g,forward[0]*b+forward[1]*e+forward[2]*h,
	movapd	%xmm12, %xmm3	# _904, _1096
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:404:             forward[0]*a+forward[1]*d+forward[2]*g,forward[0]*b+forward[1]*e+forward[2]*h,
	addsd	%xmm6, %xmm3	# _1095, _1097
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:405:             forward[0]*c+forward[1]*f+forward[2]*j,forward[0]*wx+forward[1]*wy+forward[2]*wz};
	addsd	%xmm2, %xmm0	# _1103, _1104
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:404:             forward[0]*a+forward[1]*d+forward[2]*g,forward[0]*b+forward[1]*e+forward[2]*h,
	addsd	%xmm4, %xmm3	# _1098, _1099
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:397:         const double values[21]={
	movsd	%xmm0, 1064(%rsp)	# _1104, MEM[(double[21] *)_883][19]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:405:             forward[0]*c+forward[1]*f+forward[2]*j,forward[0]*wx+forward[1]*wy+forward[2]*wz};
	movsd	72(%rsp), %xmm0	# %sfp, wx
	mulsd	%xmm15, %xmm0	# _1085, wx
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:397:         const double values[21]={
	unpcklpd	%xmm3, %xmm1	# _1099, _922
	movups	%xmm1, 1048(%rsp)	# _922, MEM <vector(2) double> [(double *)_883 + 136B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:405:             forward[0]*c+forward[1]*f+forward[2]*j,forward[0]*wx+forward[1]*wy+forward[2]*wz};
	movsd	80(%rsp), %xmm1	# %sfp, wy
	mulsd	%xmm7, %xmm1	# _1088, wy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:405:             forward[0]*c+forward[1]*f+forward[2]*j,forward[0]*wx+forward[1]*wy+forward[2]*wz};
	addsd	%xmm1, %xmm0	# _1106, _1107
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:405:             forward[0]*c+forward[1]*f+forward[2]*j,forward[0]*wx+forward[1]*wy+forward[2]*wz};
	movsd	88(%rsp), %xmm1	# %sfp, wz
	mulsd	%xmm9, %xmm1	# _1092, wz
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:405:             forward[0]*c+forward[1]*f+forward[2]*j,forward[0]*wx+forward[1]*wy+forward[2]*wz};
	addsd	%xmm1, %xmm0	# _1108, _1109
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:397:         const double values[21]={
	movsd	%xmm0, 1072(%rsp)	# _1109, MEM[(double[21] *)_883][20]
.L846:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:407:             if(!narrow(values[k],packet+21*l+k)||fabs(packet[21*l+k])>(k>=8&&k<17?1e6:4096))return false;
	movsd	(%rax), %xmm1	# MEM[(double *)_188], _1117
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	movsd	.LC22(%rip), %xmm5	#, tmp2535
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:310:     const double magnitude=fabs(v),midpoint=(double)FLT_MAX+0x1p103;
	movapd	%xmm1, %xmm0	# _1117, magnitude
	andpd	.LC8(%rip), %xmm0	#, magnitude
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	ucomisd	%xmm0, %xmm5	# magnitude, tmp2535
	jb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	comisd	.LC38(%rip), %xmm0	#, magnitude
	jnb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	comisd	.LC39(%rip), %xmm0	#, magnitude
	jbe	.L981	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	pxor	%xmm2, %xmm2	# tmp1666
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	.LC33(%rip), %xmm0	#, iftmp.26_1510
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	comisd	%xmm1, %xmm2	# _1117, tmp1666
	ja	.L844	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movaps	%xmm14, %xmm0	# iftmp.26_1507, iftmp.26_1510
.L844:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	%xmm0, (%rbx)	# iftmp.26_1510, MEM[(float *)_1628]
	.p2align 4
	.p2align 3
.L801:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%r15)	#, i_128(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:578:             if(kind==3&&!mesh_packet(i,j,NULL,NULL,NULL,true))return leave(i,AYATSURI_MODEL_RANGE);
	movl	$2, %eax	#, <retval>
	jmp	.L746	#
	.p2align 4,,10
	.p2align 3
.L1034:
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	pxor	%xmm11, %xmm11	# _325
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:59:         world[0]=a;world[1]=b;world[2]=c;world[3]=pose->position[0];
	movaps	%xmm5, 912(%rsp)	# _832, MEM <vector(2) double> [(double *)_883]
	leaq	912(%rsp), %r13	#, ivtmp.780
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:53:         a=cz*cy*pose->scale[0],b=(cz*sy*sx-sz*cx)*pose->scale[1],
	cvtss2sd	620(%rsp), %xmm11	# pose.scale[1], _325
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:54:         c=(cz*sy*cx+sz*sx)*pose->scale[2],d=sz*cy*pose->scale[0],
	mulsd	%xmm12, %xmm6	# _318, d_334
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:59:         world[0]=a;world[1]=b;world[2]=c;world[3]=pose->position[0];
	movsd	%xmm3, 928(%rsp)	# c, MEM[(double[12] *)_883][2]
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:61:         world[8]=g;world[9]=h;world[10]=j;world[11]=pose->position[2];
	movsd	%xmm9, 1000(%rsp)	# _2394, MEM[(double[12] *)_883][11]
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:55:         e=(sz*sy*sx+cz*cx)*pose->scale[1],f=(sz*sy*cx-cz*sx)*pose->scale[2],
	mulsd	%xmm11, %xmm13	# _325, e_339
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:56:         g=-sy*pose->scale[0],h=cy*sx*pose->scale[1],j=cy*cx*pose->scale[2];
	mulsd	%xmm4, %xmm12	# _344, g_345
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:56:         g=-sy*pose->scale[0],h=cy*sx*pose->scale[1],j=cy*cx*pose->scale[2];
	mulsd	%xmm0, %xmm11	# _346, h_347
# candidate-early-snorm/main/ayatsuri/ayatsuri_transform.h:59:         world[0]=a;world[1]=b;world[2]=c;world[3]=pose->position[0];
	unpcklpd	%xmm6, %xmm7	# d_334, _838
	unpcklpd	%xmm1, %xmm13	# f, _837
	movups	%xmm7, 936(%rsp)	# _838, MEM <vector(2) double> [(double *)_883 + 24B]
	movups	%xmm13, 952(%rsp)	# _837, MEM <vector(2) double> [(double *)_883 + 40B]
	unpcklpd	%xmm12, %xmm8	# g_345, _835
	movups	%xmm8, 968(%rsp)	# _835, MEM <vector(2) double> [(double *)_883 + 56B]
	unpcklpd	%xmm2, %xmm11	# j, _834
	movups	%xmm11, 984(%rsp)	# _834, MEM <vector(2) double> [(double *)_883 + 72B]
	jmp	.L792	#
.L769:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%r15)	#, i_128(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:586:     if(!(distance>0)||!isfinite(distance))return leave(i,AYATSURI_MODEL_INVALID);
	jmp	.L782	#
.L1032:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%r15)	#, i_128(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:565:     if(same)return leave(i,AYATSURI_MODEL_OK);
	xorl	%eax, %eax	# <retval>
	jmp	.L746	#
.L1043:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:600:         if((node[2]==1&&!ellipse_packet(i,j,right,down))||(node[2]==2&&!blend_packet(i,j,right,down,forward))||
	movzbl	2(%r12), %edi	# MEM[(const uint8_t *)_243 + 2B], _87
	jmp	.L803	#
.L981:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	cvtsd2ss	%xmm1, %xmm1	# _1117, iftmp.26_1119
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	%xmm1, (%rbx)	# iftmp.26_1119, MEM[(float *)_1629]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:407:             if(!narrow(values[k],packet+21*l+k)||fabs(packet[21*l+k])>(k>=8&&k<17?1e6:4096))return false;
	andps	%xmm10, %xmm1	# tmp1837, _1126
	cvtss2sd	%xmm1, %xmm1	# _1126, _1127
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:407:             if(!narrow(values[k],packet+21*l+k)||fabs(packet[21*l+k])>(k>=8&&k<17?1e6:4096))return false;
	cmpl	$8, %ecx	#, ivtmp.829
	jbe	.L897	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:407:             if(!narrow(values[k],packet+21*l+k)||fabs(packet[21*l+k])>(k>=8&&k<17?1e6:4096))return false;
	movsd	.LC35(%rip), %xmm0	#, iftmp.28_1129
.L845:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:407:             if(!narrow(values[k],packet+21*l+k)||fabs(packet[21*l+k])>(k>=8&&k<17?1e6:4096))return false;
	comisd	%xmm0, %xmm1	# iftmp.28_1129, _1127
	ja	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:406:         for(unsigned k=0;k<21;++k){
	movq	368(%rsp), %rdx	# %sfp, _1630
	addq	$8, %rax	#, ivtmp.827
	addq	$4, %rbx	#, ivtmp.828
	addl	$1, %ecx	#, ivtmp.829
	cmpq	%rdx, %rax	# _1630, ivtmp.827
	jne	.L846	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:390:     for(unsigned l=0;l<count;++l){
	addl	$1, 392(%rsp)	#, %sfp
	movl	392(%rsp), %eax	# %sfp, l
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:390:     for(unsigned l=0;l<count;++l){
	addq	$21, 208(%rsp)	#, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:390:     for(unsigned l=0;l<count;++l){
	movq	(%rsp), %rdx	# %sfp, tmp1188
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:390:     for(unsigned l=0;l<count;++l){
	cmpl	%eax, %edi	# l, count
	jne	.L847	#,
	movq	408(%rsp), %rcx	# %sfp, _152
.L839:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movzwl	%si, %eax	# load_dst_1701, _782
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	396(%rsp), %esi	# %sfp, _781
	movq	%r11, 64(%rsp)	# ivtmp.927, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	imulq	$72, %rax, %rax	#, _782, _783
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	184(%rsp), %rbx	# %sfp, _765
	movq	%r10, 56(%rsp)	# ivtmp.929, %sfp
	movq	%rdx, 48(%rsp)	# tmp1188, %sfp
	movq	%rcx, 32(%rsp)	# _152, %sfp
	addq	%rsi, %rax	# _781, _784
	addq	%rax, %rbx	# _784, _765
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:410:     surface_write(w,252,0,pack_rgb(states(i)[id].color));
	movq	400(%rsp), %rax	# %sfp, _797
	movl	12(%rax), %edi	# _797->color, _797->color
	call	pack_rgb	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:411:     surface_write(w,252,1,(uint16_t)floor(states(i)[id].opacity*255+0.5));
	movsd	.LC5(%rip), %xmm0	#, _1137
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:319:     memcpy((uint8_t *)storage+offset+2*index,&value,2);
	movw	%ax, 252(%rbp)	# tmp1964, MEM <unsigned short> [(char * {ref-all})_800 + 252B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:411:     surface_write(w,252,1,(uint16_t)floor(states(i)[id].opacity*255+0.5));
	movq	8(%r15), %rax	# i_128(D)->arena, i_128(D)->arena
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:411:     surface_write(w,252,1,(uint16_t)floor(states(i)[id].opacity*255+0.5));
	mulsd	(%rax,%r8,8), %xmm0	# _1135->opacity, _1137
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:411:     surface_write(w,252,1,(uint16_t)floor(states(i)[id].opacity*255+0.5));
	addsd	.LC6(%rip), %xmm0	#, _1138
	call	floor@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:412:     surface_write(w,252,2,(uint16_t)floor(fmin(1,md(material+48)*hypot3(m[2],m[6],m[10]))*255+0.5));
	leaq	48(%rbx), %rdi	#, _1141
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:411:     surface_write(w,252,1,(uint16_t)floor(states(i)[id].opacity*255+0.5));
	cvttsd2sil	%xmm0, %eax	# tmp1965, tmp1681
	movw	%ax, 254(%rbp)	# tmp1681, MEM <unsigned short> [(char * {ref-all})_800 + 254B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:412:     surface_write(w,252,2,(uint16_t)floor(fmin(1,md(material+48)*hypot3(m[2],m[6],m[10]))*255+0.5));
	call	md	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:308: static double hypot3(double x,double y,double z){return hypot(hypot(x,y),z);}
	movsd	104(%rsp), %xmm1	# %sfp,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:412:     surface_write(w,252,2,(uint16_t)floor(fmin(1,md(material+48)*hypot3(m[2],m[6],m[10]))*255+0.5));
	movsd	%xmm0, (%rsp)	# tmp1966, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:308: static double hypot3(double x,double y,double z){return hypot(hypot(x,y),z);}
	movsd	96(%rsp), %xmm0	# %sfp,
	call	hypot@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:308: static double hypot3(double x,double y,double z){return hypot(hypot(x,y),z);}
	movsd	112(%rsp), %xmm1	# %sfp,
	call	hypot@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:412:     surface_write(w,252,2,(uint16_t)floor(fmin(1,md(material+48)*hypot3(m[2],m[6],m[10]))*255+0.5));
	mulsd	(%rsp), %xmm0	# %sfp, _1147
	movsd	.LC9(%rip), %xmm1	#,
	call	fmin@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:412:     surface_write(w,252,2,(uint16_t)floor(fmin(1,md(material+48)*hypot3(m[2],m[6],m[10]))*255+0.5));
	mulsd	.LC5(%rip), %xmm0	#, _1149
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:412:     surface_write(w,252,2,(uint16_t)floor(fmin(1,md(material+48)*hypot3(m[2],m[6],m[10]))*255+0.5));
	addsd	.LC6(%rip), %xmm0	#, _1150
	call	floor@PLT	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:413:     if(!narrow(md(material+64),w+78))return false;
	leaq	64(%rbx), %rdi	#, _1153
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:412:     surface_write(w,252,2,(uint16_t)floor(fmin(1,md(material+48)*hypot3(m[2],m[6],m[10]))*255+0.5));
	cvttsd2sil	%xmm0, %eax	# tmp1970, tmp1689
	movw	%ax, 256(%rbp)	# tmp1689, MEM <unsigned short> [(char * {ref-all})_800 + 256B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:413:     if(!narrow(md(material+64),w+78))return false;
	call	md	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	movsd	.LC22(%rip), %xmm6	#, tmp2546
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:310:     const double magnitude=fabs(v),midpoint=(double)FLT_MAX+0x1p103;
	movapd	%xmm0, %xmm1	# _1154, magnitude
	andpd	.LC8(%rip), %xmm1	#, magnitude
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	ucomisd	%xmm1, %xmm6	# magnitude, tmp2546
	jb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	comisd	.LC38(%rip), %xmm1	#, magnitude
	jnb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	comisd	.LC39(%rip), %xmm1	#, magnitude
	movq	32(%rsp), %rcx	# %sfp, _152
	movss	.LC0(%rip), %xmm10	#, tmp1837
	movq	48(%rsp), %rdx	# %sfp, tmp1188
	movq	56(%rsp), %r10	# %sfp, ivtmp.929
	movss	.LC1(%rip), %xmm14	#, iftmp.26_1507
	movq	64(%rsp), %r11	# %sfp, ivtmp.927
	jbe	.L982	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	pxor	%xmm1, %xmm1	# tmp1695
	comisd	%xmm0, %xmm1	# _1154, tmp1695
	ja	.L1044	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movaps	%xmm14, %xmm0	# iftmp.26_1507, iftmp.26_1157
.L853:
	movl	80(%r14), %r8d	# MEM[(unsigned int *)model_764 + 80B], _1165
	movq	(%r14), %r9	# MEM[(const uint8_t * *)model_764], _1163
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	%xmm0, 312(%rbp)	# iftmp.26_1157, MEM[(float *)_800 + 312B]
	movl	76(%r14), %edi	# MEM[(unsigned int *)model_764 + 76B],
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:30:     for(uint32_t k=0;k<m->section[7].count;++k){const uint8_t *r=row(m,8,k,32);if(m16(r)==id)return r;}
	testl	%r8d, %r8d	# _1165
	je	.L855	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:30:     for(uint32_t k=0;k<m->section[7].count;++k){const uint8_t *r=row(m,8,k,32);if(m16(r)==id)return r;}
	xorl	%esi, %esi	# k
	jmp	.L857	#
.L1045:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:30:     for(uint32_t k=0;k<m->section[7].count;++k){const uint8_t *r=row(m,8,k,32);if(m16(r)==id)return r;}
	addl	$1, %esi	#, k
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:30:     for(uint32_t k=0;k<m->section[7].count;++k){const uint8_t *r=row(m,8,k,32);if(m16(r)==id)return r;}
	cmpl	%esi, %r8d	# k, _1165
	je	.L855	#,
.L857:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	%esi, %eax	# k, _1459
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:30:     for(uint32_t k=0;k<m->section[7].count;++k){const uint8_t *r=row(m,8,k,32);if(m16(r)==id)return r;}
	movl	24(%rsp), %r14d	# %sfp, _1506
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	sall	$5, %eax	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rdi, %rax	# _2364, _1174
	addq	%r9, %rax	# _1163, _1175
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:30:     for(uint32_t k=0;k<m->section[7].count;++k){const uint8_t *r=row(m,8,k,32);if(m16(r)==id)return r;}
	movzwl	(%rax), %ebx	# MEM <short unsigned int> [(const uint8_t *)_1175], _1183
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:30:     for(uint32_t k=0;k<m->section[7].count;++k){const uint8_t *r=row(m,8,k,32);if(m16(r)==id)return r;}
	cmpl	%r14d, %ebx	# _1506, _1183
	jne	.L1045	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movq	8(%r15), %rsi	# i_128(D)->arena, _1187
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:366:         t[r]=zoom*((double)basis[r][0]*((double)w[3]-i->camera[3])+
	pxor	%xmm5, %xmm5	# _1236
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:366:         t[r]=zoom*((double)basis[r][0]*((double)w[3]-i->camera[3])+
	pxor	%xmm0, %xmm0	# _1238
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:367:             (double)basis[r][1]*((double)w[7]-i->camera[4])+(double)basis[r][2]*((double)w[11]-i->camera[5]));
	pxor	%xmm4, %xmm4	# _1244
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:366:         t[r]=zoom*((double)basis[r][0]*((double)w[3]-i->camera[3])+
	cvtss2sd	52(%r15), %xmm0	# i_128(D)->camera[3], _1238
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:367:             (double)basis[r][1]*((double)w[7]-i->camera[4])+(double)basis[r][2]*((double)w[11]-i->camera[5]));
	pxor	%xmm3, %xmm3	# _1253
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:360:     float *w=work(i,id);double q[9],t[3];const float *basis[3]={right,down,forward};
	movdqa	416(%rsp), %xmm6	# %sfp, _1327
	leaq	528(%rsp), %r9	#, tmp1831
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movl	8(%rsi,%rdx), %edx	# _1190->offset, _1192
	leaq	496(%rsp), %rbp	#, tmp1828
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:360:     float *w=work(i,id);double q[9],t[3];const float *basis[3]={right,down,forward};
	movaps	%xmm6, 528(%rsp)	# _1327, MEM <vector(2) long unsigned int> [(const float * *)&basis]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	addq	%rdx, %rsi	# _1192, _1193
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:360:     float *w=work(i,id);double q[9],t[3];const float *basis[3]={right,down,forward};
	leaq	456(%rsp), %rdx	#, tmp1816
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:366:         t[r]=zoom*((double)basis[r][0]*((double)w[3]-i->camera[3])+
	cvtss2sd	12(%rsi), %xmm5	# MEM[(float *)_1193 + 12B], _1236
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:366:         t[r]=zoom*((double)basis[r][0]*((double)w[3]-i->camera[3])+
	subsd	%xmm0, %xmm5	# _1238, _1239
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:367:             (double)basis[r][1]*((double)w[7]-i->camera[4])+(double)basis[r][2]*((double)w[11]-i->camera[5]));
	pxor	%xmm0, %xmm0	# _1246
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:367:             (double)basis[r][1]*((double)w[7]-i->camera[4])+(double)basis[r][2]*((double)w[11]-i->camera[5]));
	cvtss2sd	28(%rsi), %xmm4	# MEM[(float *)_1193 + 28B], _1244
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:367:             (double)basis[r][1]*((double)w[7]-i->camera[4])+(double)basis[r][2]*((double)w[11]-i->camera[5]));
	cvtss2sd	56(%r15), %xmm0	# i_128(D)->camera[4], _1246
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:367:             (double)basis[r][1]*((double)w[7]-i->camera[4])+(double)basis[r][2]*((double)w[11]-i->camera[5]));
	subsd	%xmm0, %xmm4	# _1246, _1247
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:367:             (double)basis[r][1]*((double)w[7]-i->camera[4])+(double)basis[r][2]*((double)w[11]-i->camera[5]));
	pxor	%xmm0, %xmm0	# _1255
	leaq	12(%rsi), %r14	#, _747
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:367:             (double)basis[r][1]*((double)w[7]-i->camera[4])+(double)basis[r][2]*((double)w[11]-i->camera[5]));
	cvtss2sd	44(%rsi), %xmm3	# MEM[(float *)_1193 + 44B], _1253
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:367:             (double)basis[r][1]*((double)w[7]-i->camera[4])+(double)basis[r][2]*((double)w[11]-i->camera[5]));
	cvtss2sd	60(%r15), %xmm0	# i_128(D)->camera[5], _1255
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:367:             (double)basis[r][1]*((double)w[7]-i->camera[4])+(double)basis[r][2]*((double)w[11]-i->camera[5]));
	subsd	%xmm0, %xmm3	# _1255, _1256
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:360:     float *w=work(i,id);double q[9],t[3];const float *basis[3]={right,down,forward};
	movq	%rdx, 544(%rsp)	# tmp1816, basis[2]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:367:             (double)basis[r][1]*((double)w[7]-i->camera[4])+(double)basis[r][2]*((double)w[11]-i->camera[5]));
	xorl	%edx, %edx	# ivtmp.794
.L863:
	movl	%edx, %r8d	# ivtmp.794, r
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:364:         const double zoom=r<2?i->camera[6]:1;
	cmpq	$2, %rdx	#, ivtmp.794
	je	.L899	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:364:         const double zoom=r<2?i->camera[6]:1;
	pxor	%xmm6, %xmm6	# iftmp.30_1229
	cvtss2sd	64(%r15), %xmm6	# i_128(D)->camera[6], iftmp.30_1229
.L858:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	movq	(%r9,%rdx,8), %rdi	# MEM[(const float * *)&basis + ivtmp.794_750 * 8], _1197
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	pxor	%xmm0, %xmm0	# _1199
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	pxor	%xmm7, %xmm7	# _1208
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	pxor	%xmm2, %xmm2	# _1218
	leal	(%r8,%r8,2), %r8d	#, ivtmp.790
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	cvtss2sd	(%rdi), %xmm0	# *_1197, _1199
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	cvtss2sd	4(%rdi), %xmm7	# MEM[(const float *)_1197 + 4B], _1208
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	cvtss2sd	8(%rdi), %xmm2	# MEM[(const float *)_1197 + 8B], _1218
	movq	%rsi, %rdi	# _1193, ivtmp.789
.L859:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	pxor	%xmm1, %xmm1	# _1205
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	pxor	%xmm8, %xmm8	# _1214
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	movl	%r8d, %ebx	# ivtmp.790, ivtmp.790
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	addq	$4, %rdi	#, ivtmp.789
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	cvtss2sd	-4(%rdi), %xmm1	# MEM[(float *)_729], _1205
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	cvtss2sd	12(%rdi), %xmm8	# MEM[(float *)_729 + 16B], _1214
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	mulsd	%xmm0, %xmm1	# _1199, _1206
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	addl	$1, %r8d	#, ivtmp.790
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	mulsd	%xmm7, %xmm8	# _1208, _1215
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	addsd	%xmm8, %xmm1	# _1215, _1216
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	pxor	%xmm8, %xmm8	# _1224
	cvtss2sd	28(%rdi), %xmm8	# MEM[(float *)_729 + 32B], _1224
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	mulsd	%xmm2, %xmm8	# _1218, _1225
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	addsd	%xmm8, %xmm1	# _1225, _1226
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	mulsd	%xmm6, %xmm1	# iftmp.30_1229, _1230
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	movsd	%xmm1, 736(%rsp,%rbx,8)	# _1230, MEM[(double[9] *)_1358][ivtmp.790_69]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:365:         for(unsigned c=0;c<3;++c)q[3*r+c]=zoom*((double)basis[r][0]*w[c]+(double)basis[r][1]*w[4+c]+(double)basis[r][2]*w[8+c]);
	cmpq	%r14, %rdi	# _747, ivtmp.789
	jne	.L859	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:366:         t[r]=zoom*((double)basis[r][0]*((double)w[3]-i->camera[3])+
	mulsd	%xmm5, %xmm0	# _1239, _1240
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:367:             (double)basis[r][1]*((double)w[7]-i->camera[4])+(double)basis[r][2]*((double)w[11]-i->camera[5]));
	mulsd	%xmm4, %xmm7	# _1247, _1248
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:367:             (double)basis[r][1]*((double)w[7]-i->camera[4])+(double)basis[r][2]*((double)w[11]-i->camera[5]));
	mulsd	%xmm3, %xmm2	# _1256, _1257
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:366:         t[r]=zoom*((double)basis[r][0]*((double)w[3]-i->camera[3])+
	addsd	%xmm7, %xmm0	# _1248, _1249
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:367:             (double)basis[r][1]*((double)w[7]-i->camera[4])+(double)basis[r][2]*((double)w[11]-i->camera[5]));
	addsd	%xmm2, %xmm0	# _1257, _1258
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:366:         t[r]=zoom*((double)basis[r][0]*((double)w[3]-i->camera[3])+
	mulsd	%xmm6, %xmm0	# iftmp.30_1229, _1259
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:366:         t[r]=zoom*((double)basis[r][0]*((double)w[3]-i->camera[3])+
	movsd	%xmm0, 0(%rbp,%rdx,8)	# _1259, MEM[(double *)&t + ivtmp.794_750 * 8]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:368:         if(r<2)t[r]+=i->camera[7+r];
	cmpq	$2, %rdx	#, ivtmp.794
	je	.L1046	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:368:         if(r<2)t[r]+=i->camera[7+r];
	pxor	%xmm1, %xmm1	# _1262
	cvtss2sd	68(%r15,%rdx,4), %xmm1	# MEM[(float *)i_128(D) + 68B + ivtmp.794_750 * 4], _1262
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:368:         if(r<2)t[r]+=i->camera[7+r];
	addsd	%xmm0, %xmm1	# _1259, _1263
	movsd	%xmm1, 0(%rbp,%rdx,8)	# _1263, MEM[(double *)&t + ivtmp.794_750 * 8]
	addq	$1, %rdx	#, ivtmp.794
	jmp	.L863	#
	.p2align 4,,10
	.p2align 3
.L1033:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:571:     const bool light_only=i->evaluated&&!memcmp(camera,i->camera,36)&&
	movq	16(%rcx), %rax	# MEM <char[1:36]> [(void *)camera_134(D)], tmp2008
	movq	24(%rcx), %rdx	# MEM <char[1:36]> [(void *)camera_134(D)], tmp2010
	xorq	16(%rsi), %rax	# MEM <char[1:36]> [(void *)i_128(D) + 40B], tmp2007
	xorq	24(%rsi), %rdx	# MEM <char[1:36]> [(void *)i_128(D) + 40B], tmp2009
	orq	%rdx, %rax	# tmp2009, tmp2007
	jne	.L761	#,
	movl	32(%rsi), %eax	# MEM <char[1:36]> [(void *)i_128(D) + 40B], tmp2296
	cmpl	%eax, 32(%rcx)	# tmp2296, MEM <char[1:36]> [(void *)camera_134(D)]
	jne	.L761	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rcx, %r15	# camera, i
	jb	.L764	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r15, %rax	# i, _205
	subq	%rcx, %rax	# camera, _205
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$35, %rax	#, _205
	jbe	.L761	#,
.L765:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %r15	# light, i
	jb	.L766	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r15, %rax	# i, _208
	subq	%r8, %rax	# light, _208
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$23, %rax	#, _208
	jbe	.L761	#,
.L767:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:574:         i->evaluated=false;memcpy(i->light,light,24);
	movb	$0, 166(%r15)	#, i_128(D)->evaluated
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:574:         i->evaluated=false;memcpy(i->light,light,24);
	movdqu	(%r8), %xmm0	# MEM <char[1:24]> [(void *)light_135(D)], MEM <char[1:24]> [(void *)light_135(D)]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:576:         for(unsigned j=0;j<i->model->node_count;++j){
	xorl	%ebx, %ebx	# ivtmp.934
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:576:         for(unsigned j=0;j<i->model->node_count;++j){
	movq	(%r15), %rdx	# i_128(D)->model, _32
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:574:         i->evaluated=false;memcpy(i->light,light,24);
	movups	%xmm0, 76(%r15)	# MEM <char[1:24]> [(void *)light_135(D)], MEM <char[1:24]> [(void *)i_128(D) + 76B]
	movq	16(%r8), %rax	# MEM <char[1:24]> [(void *)light_135(D)], MEM <char[1:24]> [(void *)light_135(D)]
	movq	%rax, 92(%r15)	# MEM <char[1:24]> [(void *)light_135(D)], MEM <char[1:24]> [(void *)i_128(D) + 76B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:575:         for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[6+k]=light[3+k];}
	movss	(%r8), %xmm0	# *light_135(D), _1561
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:576:         for(unsigned j=0;j<i->model->node_count;++j){
	cmpw	$0, 12(%rdx)	#, _1702->node_count
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:575:         for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[6+k]=light[3+k];}
	movss	%xmm0, 100(%r15)	# _1561, i_128(D)->lighting[0]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:575:         for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[6+k]=light[3+k];}
	movss	12(%r8), %xmm0	# MEM[(const float *)light_135(D) + 12B], _1146
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:575:         for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[6+k]=light[3+k];}
	movss	%xmm0, 124(%r15)	# _1146, i_128(D)->lighting[6]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:575:         for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[6+k]=light[3+k];}
	movss	4(%r8), %xmm0	# MEM[(const float *)light_135(D) + 4B], _50
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:575:         for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[6+k]=light[3+k];}
	movss	%xmm0, 104(%r15)	# _50, i_128(D)->lighting[1]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:575:         for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[6+k]=light[3+k];}
	movss	16(%r8), %xmm0	# MEM[(const float *)light_135(D) + 16B], _1648
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:575:         for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[6+k]=light[3+k];}
	movss	%xmm0, 128(%r15)	# _1648, i_128(D)->lighting[7]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:575:         for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[6+k]=light[3+k];}
	movss	8(%r8), %xmm0	# MEM[(const float *)light_135(D) + 8B], _1656
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:575:         for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[6+k]=light[3+k];}
	movss	%xmm0, 108(%r15)	# _1656, i_128(D)->lighting[2]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:575:         for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[6+k]=light[3+k];}
	movss	20(%r8), %xmm0	# MEM[(const float *)light_135(D) + 20B], _1663
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:575:         for(unsigned k=0;k<3;++k){i->lighting[k]=light[k];i->lighting[6+k]=light[3+k];}
	movss	%xmm0, 132(%r15)	# _1663, i_128(D)->lighting[8]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:576:         for(unsigned j=0;j<i->model->node_count;++j){
	jne	.L770	#,
	jmp	.L779	#
	.p2align 4,,10
	.p2align 3
.L778:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:576:         for(unsigned j=0;j<i->model->node_count;++j){
	movzwl	12(%rdx), %eax	# _32->node_count, _34
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:576:         for(unsigned j=0;j<i->model->node_count;++j){
	addq	$1, %rbx	#, ivtmp.934
	cmpl	%eax, %ebx	# _34, ivtmp.934
	jnb	.L779	#,
.L770:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	20(%rdx), %ecx	# _1688->section[0].offset, _212
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:577:             const uint8_t kind=row(i->model,1,j,16)[2];
	movq	%rbx, %rax	# ivtmp.934, tmp1157
	salq	$4, %rax	#, tmp1157
	addq	(%rdx), %rax	# _1688->data, tmp1156
	movzbl	2(%rcx,%rax), %eax	# MEM[(const uint8_t *)_216 + 2B], kind
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:578:             if(kind==3&&!mesh_packet(i,j,NULL,NULL,NULL,true))return leave(i,AYATSURI_MODEL_RANGE);
	cmpb	$3, %al	#, kind
	je	.L1047	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:579:             if(kind)add_count(&i->stats.shade_updates,1);
	testb	%al, %al	# kind
	je	.L778	#,
.L777:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	148(%r15), %eax	# MEM[(uint32_t *)i_128(D) + 148B], _217
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	xorl	%ecx, %ecx	# tmp1845
	cmpl	$-1, %eax	#, _217
	setne	%cl	#, tmp1845
	addl	%ecx, %eax	# tmp1845, _217
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	movl	%eax, 148(%r15)	# _217, MEM[(uint32_t *)i_128(D) + 148B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:20: static void add_count(uint32_t *counter,uint32_t n){*counter=UINT32_MAX-*counter<n?UINT32_MAX:*counter+n;}
	jmp	.L778	#
.L1047:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:578:             if(kind==3&&!mesh_packet(i,j,NULL,NULL,NULL,true))return leave(i,AYATSURI_MODEL_RANGE);
	xorl	%r8d, %r8d	#
	xorl	%ecx, %ecx	#
	xorl	%edx, %edx	#
	movl	$1, %r9d	#,
	movl	%ebx, %esi	# ivtmp.934, ivtmp.934
	movq	%r15, %rdi	# i,
	call	mesh_packet	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:578:             if(kind==3&&!mesh_packet(i,j,NULL,NULL,NULL,true))return leave(i,AYATSURI_MODEL_RANGE);
	testb	%al, %al	# tmp1953
	je	.L801	#,
	movq	(%r15), %rdx	# i_128(D)->model, _32
	jmp	.L777	#
.L764:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rcx, %rax	# camera, _206
	subq	%r15, %rax	# i, _206
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$167, %rax	#, _206
	jbe	.L761	#,
	jmp	.L765	#
.L888:
	movss	.LC15(%rip), %xmm2	#, _2293
	movapd	%xmm3, %xmm8	# fz, _2299
	pxor	%xmm0, %xmm0	# _2297
	movq	.LC26(%rip), %xmm9	#, tmp1830
	movsd	.LC9(%rip), %xmm6	#, _2291
	pxor	%xmm7, %xmm7	# _2295
	movaps	%xmm9, 128(%rsp)	# tmp1830, %sfp
	jmp	.L783	#
.L972:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	pxor	%xmm0, %xmm0	# iftmp.26_582
	cvtsd2ss	%xmm1, %xmm0	# _580, iftmp.26_582
	jmp	.L812	#
.L766:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %rax	# light, _209
	subq	%r15, %rax	# i, _209
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$167, %rax	#, _209
	ja	.L767	#,
	jmp	.L761	#
.L973:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	cvtsd2ss	%xmm0, %xmm0	# _610, iftmp.26_613
	jmp	.L816	#
.L892:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	.LC33(%rip), %xmm0	#, iftmp.26_613
	jmp	.L816	#
.L974:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	cvtsd2ss	%xmm0, %xmm0	# _629, iftmp.26_632
	jmp	.L819	#
.L975:
	cvtsd2ss	%xmm0, %xmm0	# _660, iftmp.26_663
	jmp	.L823	#
.L982:
	cvtsd2ss	%xmm0, %xmm0	# _1154, iftmp.26_1157
	jmp	.L853	#
.L855:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:601:            (node[2]==3&&!mesh_packet(i,j,right,down,forward,false)))
	movzbl	2(%r12), %edi	# MEM[(const uint8_t *)_243 + 2B], _87
	jmp	.L837	#
.L1046:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:370:     const double a=q[0],b=q[1],c=q[2],d=q[3],e=q[4],f=q[5],g=q[6],h=q[7],j=q[8],
	movsd	768(%rsp), %xmm11	# MEM[(double[9] *)_1358][4], e
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:370:     const double a=q[0],b=q[1],c=q[2],d=q[3],e=q[4],f=q[5],g=q[6],h=q[7],j=q[8],
	movsd	776(%rsp), %xmm8	# MEM[(double[9] *)_1358][5], f
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:370:     const double a=q[0],b=q[1],c=q[2],d=q[3],e=q[4],f=q[5],g=q[6],h=q[7],j=q[8],
	movsd	792(%rsp), %xmm7	# MEM[(double[9] *)_1358][7], h
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:370:     const double a=q[0],b=q[1],c=q[2],d=q[3],e=q[4],f=q[5],g=q[6],h=q[7],j=q[8],
	movsd	800(%rsp), %xmm0	# MEM[(double[9] *)_1358][8], j
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm11, %xmm5	# e, _1274
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm8, %xmm3	# f, _1275
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:370:     const double a=q[0],b=q[1],c=q[2],d=q[3],e=q[4],f=q[5],g=q[6],h=q[7],j=q[8],
	movsd	760(%rsp), %xmm9	# MEM[(double[9] *)_1358][3], d
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:370:     const double a=q[0],b=q[1],c=q[2],d=q[3],e=q[4],f=q[5],g=q[6],h=q[7],j=q[8],
	movsd	784(%rsp), %xmm4	# MEM[(double[9] *)_1358][6], g
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm7, %xmm3	# h, _1275
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm8, %xmm13	# f, _1279
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:370:     const double a=q[0],b=q[1],c=q[2],d=q[3],e=q[4],f=q[5],g=q[6],h=q[7],j=q[8],
	movsd	736(%rsp), %xmm1	# MEM[(double[9] *)_1358][0], a
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:370:     const double a=q[0],b=q[1],c=q[2],d=q[3],e=q[4],f=q[5],g=q[6],h=q[7],j=q[8],
	movsd	744(%rsp), %xmm6	# MEM[(double[9] *)_1358][1], b
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm0, %xmm5	# j, _1274
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm9, %xmm12	# d, _1283
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm9, %xmm15	# d, _1278
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:370:     const double a=q[0],b=q[1],c=q[2],d=q[3],e=q[4],f=q[5],g=q[6],h=q[7],j=q[8],
	movsd	752(%rsp), %xmm2	# MEM[(double[9] *)_1358][2], c
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm7, %xmm12	# h, _1283
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm0, %xmm15	# j, _1278
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm4, %xmm13	# g, _1279
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	subsd	%xmm3, %xmm5	# _1275, _1274
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm11, %xmm3	# e, _1284
	mulsd	%xmm4, %xmm3	# g, _1284
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	%xmm15, 32(%rsp)	# _1278, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	%xmm5, (%rsp)	# _1274, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	subsd	%xmm3, %xmm12	# _1284, _1283
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movsd	(%rsp), %xmm3	# %sfp, _1277
	mulsd	%xmm1, %xmm3	# a, _1277
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm12, %xmm5	# _1283, _1285
	movsd	%xmm12, 48(%rsp)	# _1285, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm15, %xmm12	# _1278, _1280
	subsd	%xmm13, %xmm12	# _1279, _1280
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm6, %xmm12	# b, _1281
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	subsd	%xmm12, %xmm3	# _1281, _1282
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	movapd	%xmm5, %xmm12	# _1285, _1286
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:372:     if(!isfinite(det)||det==0)return false;
	movsd	.LC22(%rip), %xmm5	#, tmp2560
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	mulsd	%xmm2, %xmm12	# c, _1286
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:371:         det=a*(e*j-f*h)-b*(d*j-f*g)+c*(d*h-e*g);
	addsd	%xmm12, %xmm3	# _1286, det
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:372:     if(!isfinite(det)||det==0)return false;
	movapd	%xmm3, %xmm12	# det, _1288
	andpd	.LC8(%rip), %xmm12	#, _1288
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:372:     if(!isfinite(det)||det==0)return false;
	ucomisd	%xmm12, %xmm5	# _1288, tmp2560
	jb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:372:     if(!isfinite(det)||det==0)return false;
	pxor	%xmm12, %xmm12	# tmp1732
	ucomisd	%xmm12, %xmm3	# tmp1732, det
	jp	.L919	#,
	je	.L801	#,
.L919:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	movapd	%xmm2, %xmm15	# c, _1290
	movapd	%xmm3, %xmm12	# det, tmp1734
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:374:         (f*g-d*j)/det,(a*j-c*g)/det,(c*d-a*f)/det,
	subsd	32(%rsp), %xmm13	# %sfp, _1298
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:377:     for(unsigned k=0;k<3;++k)plane[k]=mf(region+4)*inv[k]+mf(region+8)*inv[3+k]+mf(region+12)*inv[6+k];
	xorl	%edi, %edi	# ivtmp.782
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	mulsd	%xmm7, %xmm15	# h, _1290
	unpcklpd	%xmm12, %xmm12	# tmp1734
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:375:         (d*h-e*g)/det,(b*g-a*h)/det,(a*e-b*d)/det};
	mulsd	%xmm1, %xmm7	# a, _1310
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	movq	%xmm15, %rdx	# _1290, _1290
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	movapd	%xmm6, %xmm15	# b, _1291
	mulsd	%xmm0, %xmm15	# j, _1291
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	movq	%rdx, %xmm5	# _1290, _1290
	leaq	560(%rsp), %rdx	#, tmp1832
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:374:         (f*g-d*j)/det,(a*j-c*g)/det,(c*d-a*f)/det,
	mulsd	%xmm1, %xmm0	# a, _1300
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	subsd	%xmm15, %xmm5	# _1291, _1290
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	movsd	(%rsp), %xmm15	# %sfp, _1338
	unpcklpd	%xmm5, %xmm15	# _1292, _1338
	movapd	%xmm15, %xmm5	# _1338, _1338
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	movapd	%xmm6, %xmm15	# b, _1294
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	divpd	%xmm12, %xmm5	# tmp1734, vect__1289.758_1344
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	mulsd	%xmm8, %xmm15	# f, _1294
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:374:         (f*g-d*j)/det,(a*j-c*g)/det,(c*d-a*f)/det,
	mulsd	%xmm1, %xmm8	# a, _1305
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:375:         (d*h-e*g)/det,(b*g-a*h)/det,(a*e-b*d)/det};
	mulsd	%xmm11, %xmm1	# e, a
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	movaps	%xmm5, 912(%rsp)	# vect__1289.758_1344, MEM <vector(2) double> [(double *)_883]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	movapd	%xmm2, %xmm5	# c, _1295
	mulsd	%xmm11, %xmm5	# e, _1295
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	subsd	%xmm5, %xmm15	# _1295, _1296
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	movapd	%xmm15, %xmm5	# _1296, _1337
	unpcklpd	%xmm13, %xmm5	# _1298, _1337
	divpd	%xmm12, %xmm5	# tmp1734, vect__1289.758_1503
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	movaps	%xmm5, 928(%rsp)	# vect__1289.758_1503, MEM <vector(2) double> [(double *)_883 + 16B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:374:         (f*g-d*j)/det,(a*j-c*g)/det,(c*d-a*f)/det,
	movapd	%xmm2, %xmm5	# c, _1301
	mulsd	%xmm4, %xmm5	# g, _1301
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:374:         (f*g-d*j)/det,(a*j-c*g)/det,(c*d-a*f)/det,
	mulsd	%xmm9, %xmm2	# d, _1304
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:375:         (d*h-e*g)/det,(b*g-a*h)/det,(a*e-b*d)/det};
	mulsd	%xmm6, %xmm4	# b, _1309
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:375:         (d*h-e*g)/det,(b*g-a*h)/det,(a*e-b*d)/det};
	mulsd	%xmm9, %xmm6	# d, _1314
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:374:         (f*g-d*j)/det,(a*j-c*g)/det,(c*d-a*f)/det,
	subsd	%xmm5, %xmm0	# _1301, _1302
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:374:         (f*g-d*j)/det,(a*j-c*g)/det,(c*d-a*f)/det,
	subsd	%xmm8, %xmm2	# _1305, _1306
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:375:         (d*h-e*g)/det,(b*g-a*h)/det,(a*e-b*d)/det};
	subsd	%xmm7, %xmm4	# _1310, _1311
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	unpcklpd	%xmm2, %xmm0	# _1306, _1336
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:377:     for(unsigned k=0;k<3;++k)plane[k]=mf(region+4)*inv[k]+mf(region+8)*inv[3+k]+mf(region+12)*inv[6+k];
	pxor	%xmm2, %xmm2	# _1351
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	divpd	%xmm12, %xmm0	# tmp1734, vect__1289.758_1345
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:377:     for(unsigned k=0;k<3;++k)plane[k]=mf(region+4)*inv[k]+mf(region+8)*inv[3+k]+mf(region+12)*inv[6+k];
	cvtss2sd	8(%rax), %xmm2	# MEM <unsigned int> [(const uint8_t *)_1175 + 8B], _1351
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	movaps	%xmm0, 944(%rsp)	# vect__1289.758_1345, MEM <vector(2) double> [(double *)_883 + 32B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	movsd	48(%rsp), %xmm0	# %sfp, _1329
	unpcklpd	%xmm4, %xmm0	# _1311, _1329
	divpd	%xmm12, %xmm0	# tmp1734, vect__1289.758_1346
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	movaps	%xmm0, 960(%rsp)	# vect__1289.758_1346, MEM <vector(2) double> [(double *)_883 + 48B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:375:         (d*h-e*g)/det,(b*g-a*h)/det,(a*e-b*d)/det};
	movapd	%xmm1, %xmm0	# a, _1313
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:377:     for(unsigned k=0;k<3;++k)plane[k]=mf(region+4)*inv[k]+mf(region+8)*inv[3+k]+mf(region+12)*inv[6+k];
	pxor	%xmm1, %xmm1	# _1371
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:375:         (d*h-e*g)/det,(b*g-a*h)/det,(a*e-b*d)/det};
	subsd	%xmm6, %xmm0	# _1314, _1315
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:377:     for(unsigned k=0;k<3;++k)plane[k]=mf(region+4)*inv[k]+mf(region+8)*inv[3+k]+mf(region+12)*inv[6+k];
	cvtss2sd	12(%rax), %xmm1	# MEM <unsigned int> [(const uint8_t *)_1175 + 12B], _1371
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:375:         (d*h-e*g)/det,(b*g-a*h)/det,(a*e-b*d)/det};
	divsd	%xmm3, %xmm0	# det, _1316
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:377:     for(unsigned k=0;k<3;++k)plane[k]=mf(region+4)*inv[k]+mf(region+8)*inv[3+k]+mf(region+12)*inv[6+k];
	pxor	%xmm3, %xmm3	# _1332
	cvtss2sd	4(%rax), %xmm3	# MEM <unsigned int> [(const uint8_t *)_1175 + 4B], _1332
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:373:     const double inv[9]={(e*j-f*h)/det,(c*h-b*j)/det,(b*f-c*e)/det,
	movsd	%xmm0, 976(%rsp)	# _1316, MEM[(double[9] *)_883][8]
.L865:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:377:     for(unsigned k=0;k<3;++k)plane[k]=mf(region+4)*inv[k]+mf(region+8)*inv[3+k]+mf(region+12)*inv[6+k];
	movsd	0(%r13), %xmm0	# MEM[(double *)_466], _1335
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:377:     for(unsigned k=0;k<3;++k)plane[k]=mf(region+4)*inv[k]+mf(region+8)*inv[3+k]+mf(region+12)*inv[6+k];
	movsd	24(%r13), %xmm4	# MEM[(double *)_466 + 24B], _1354
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:377:     for(unsigned k=0;k<3;++k)plane[k]=mf(region+4)*inv[k]+mf(region+8)*inv[3+k]+mf(region+12)*inv[6+k];
	addq	$8, %r13	#, ivtmp.780
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:377:     for(unsigned k=0;k<3;++k)plane[k]=mf(region+4)*inv[k]+mf(region+8)*inv[3+k]+mf(region+12)*inv[6+k];
	mulsd	%xmm2, %xmm4	# _1351, _1354
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:377:     for(unsigned k=0;k<3;++k)plane[k]=mf(region+4)*inv[k]+mf(region+8)*inv[3+k]+mf(region+12)*inv[6+k];
	mulsd	%xmm3, %xmm0	# _1332, _1335
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:377:     for(unsigned k=0;k<3;++k)plane[k]=mf(region+4)*inv[k]+mf(region+8)*inv[3+k]+mf(region+12)*inv[6+k];
	addsd	%xmm4, %xmm0	# _1354, _1355
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:377:     for(unsigned k=0;k<3;++k)plane[k]=mf(region+4)*inv[k]+mf(region+8)*inv[3+k]+mf(region+12)*inv[6+k];
	movsd	40(%r13), %xmm4	# MEM[(double *)_466 + 48B], _1374
	mulsd	%xmm1, %xmm4	# _1371, _1374
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:377:     for(unsigned k=0;k<3;++k)plane[k]=mf(region+4)*inv[k]+mf(region+8)*inv[3+k]+mf(region+12)*inv[6+k];
	addsd	%xmm4, %xmm0	# _1374, _1375
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:377:     for(unsigned k=0;k<3;++k)plane[k]=mf(region+4)*inv[k]+mf(region+8)*inv[3+k]+mf(region+12)*inv[6+k];
	movsd	%xmm0, (%rdx,%rdi)	# _1375, MEM[(double *)&plane + ivtmp.782_506 * 1]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:377:     for(unsigned k=0;k<3;++k)plane[k]=mf(region+4)*inv[k]+mf(region+8)*inv[3+k]+mf(region+12)*inv[6+k];
	addq	$8, %rdi	#, ivtmp.782
	cmpq	$24, %rdi	#, ivtmp.782
	jne	.L865	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:378:     plane[3]=-plane[0]*t[0]-plane[1]*t[1]-plane[2]*t[2]-mf(region+16);
	movsd	560(%rsp), %xmm0	# plane[0], plane[0]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:379:     const unsigned at=slot_bytes(row(i->model,1,id,16));float *out=w+at/4;
	movq	(%r15), %r8	# i_128(D)->model, _1406
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:378:     plane[3]=-plane[0]*t[0]-plane[1]*t[1]-plane[2]*t[2]-mf(region+16);
	xorpd	128(%rsp), %xmm0	# %sfp, _1378
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:378:     plane[3]=-plane[0]*t[0]-plane[1]*t[1]-plane[2]*t[2]-mf(region+16);
	movsd	568(%rsp), %xmm1	# plane[1], plane[1]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:378:     plane[3]=-plane[0]*t[0]-plane[1]*t[1]-plane[2]*t[2]-mf(region+16);
	mulsd	496(%rsp), %xmm0	# t[0], _1380
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	20(%r8), %edi	# _1406->section[0].offset, _1409
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:378:     plane[3]=-plane[0]*t[0]-plane[1]*t[1]-plane[2]*t[2]-mf(region+16);
	mulsd	504(%rsp), %xmm1	# t[1], _1383
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%rdi, %rcx	# _1409, _1412
	addq	(%r8), %rcx	# _1406->data, _1413
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	movzbl	2(%rcx), %edi	# MEM[(const uint8_t *)_1413 + 2B], _1468
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:378:     plane[3]=-plane[0]*t[0]-plane[1]*t[1]-plane[2]*t[2]-mf(region+16);
	subsd	%xmm1, %xmm0	# _1383, _1384
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:378:     plane[3]=-plane[0]*t[0]-plane[1]*t[1]-plane[2]*t[2]-mf(region+16);
	movsd	576(%rsp), %xmm1	# plane[2], plane[2]
	mulsd	512(%rsp), %xmm1	# t[2], _1387
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:378:     plane[3]=-plane[0]*t[0]-plane[1]*t[1]-plane[2]*t[2]-mf(region+16);
	subsd	%xmm1, %xmm0	# _1387, _1388
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:378:     plane[3]=-plane[0]*t[0]-plane[1]*t[1]-plane[2]*t[2]-mf(region+16);
	pxor	%xmm1, %xmm1	# _1404
	cvtss2sd	16(%rax), %xmm1	# MEM <unsigned int> [(const uint8_t *)_1175 + 16B], _1404
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:378:     plane[3]=-plane[0]*t[0]-plane[1]*t[1]-plane[2]*t[2]-mf(region+16);
	subsd	%xmm1, %xmm0	# _1404, _1405
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:378:     plane[3]=-plane[0]*t[0]-plane[1]*t[1]-plane[2]*t[2]-mf(region+16);
	movsd	%xmm0, 584(%rsp)	# _1405, plane[3]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	testb	%dil, %dil	# _1468
	je	.L900	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	subb	$1, %dil	#, _1468
	je	.L901	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	movzwl	6(%rcx), %ecx	# MEM <short unsigned int> [(const uint8_t *)_1413 + 6B], _1478
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	imull	$108, %ecx, %ecx	#, _1478, _1479
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	addl	$316, %ecx	#, iftmp.12_1470
.L866:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:379:     const unsigned at=slot_bytes(row(i->model,1,id,16));float *out=w+at/4;
	movl	%ecx, %edi	# iftmp.12_1470, _1415
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:379:     const unsigned at=slot_bytes(row(i->model,1,id,16));float *out=w+at/4;
	xorl	%r8d, %r8d	# ivtmp.773
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:379:     const unsigned at=slot_bytes(row(i->model,1,id,16));float *out=w+at/4;
	shrl	$2, %edi	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:379:     const unsigned at=slot_bytes(row(i->model,1,id,16));float *out=w+at/4;
	leaq	(%rsi,%rdi,4), %rdi	#, out
.L872:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:380:     for(unsigned k=0;k<4;++k)if(!narrow(plane[k],out+k)||fabs(out[k])>1e6)return false;
	movsd	(%rdx,%r8,2), %xmm0	# MEM[(double *)&plane + ivtmp.773_756 * 2], _1423
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	movsd	.LC22(%rip), %xmm7	#, tmp2579
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:310:     const double magnitude=fabs(v),midpoint=(double)FLT_MAX+0x1p103;
	movapd	%xmm0, %xmm1	# _1423, magnitude
	andpd	.LC8(%rip), %xmm1	#, magnitude
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	ucomisd	%xmm1, %xmm7	# magnitude, tmp2579
	jb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:311:     if(!isfinite(v)||magnitude>=midpoint)return false;
	comisd	.LC38(%rip), %xmm1	#, magnitude
	jnb	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	comisd	.LC39(%rip), %xmm1	#, magnitude
	jbe	.L985	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	pxor	%xmm1, %xmm1	# tmp1798
	comisd	%xmm0, %xmm1	# _1423, tmp1798
	ja	.L870	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movaps	%xmm14, %xmm0	# iftmp.26_1507, iftmp.26_1507
.L871:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	%xmm0, (%rdi,%r8)	# iftmp.26_1507, *_1422
	jmp	.L801	#
.L1040:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	.LC33(%rip), %xmm0	#, iftmp.26_663
	jmp	.L823	#
.L897:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:407:             if(!narrow(values[k],packet+21*l+k)||fabs(packet[21*l+k])>(k>=8&&k<17?1e6:4096))return false;
	movsd	.LC34(%rip), %xmm0	#, iftmp.28_1129
	jmp	.L845	#
.L1044:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	.LC33(%rip), %xmm0	#, iftmp.26_1157
	jmp	.L853	#
.L834:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:352:         surface_write(w,232,1,pack_rgb(m32(region+24)));surface_write(w,232,4,4);
	movl	24(%rsi), %edi	# MEM <unsigned int> [(const uint8_t *)_710 + 24B], MEM <unsigned int> [(const uint8_t *)_710 + 24B]
	movq	%rdx, (%rsp)	# tmp1188, %sfp
	call	pack_rgb	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:319:     memcpy((uint8_t *)storage+offset+2*index,&value,2);
	movq	(%rsp), %rdx	# %sfp, tmp1188
	movw	$4, 240(%rbp)	#, MEM <unsigned short> [(char * {ref-all})_458 + 240B]
	movss	.LC0(%rip), %xmm10	#, tmp1837
	movw	%ax, 234(%rbp)	# tmp1963, MEM <unsigned short> [(char * {ref-all})_458 + 234B]
	xorl	%eax, %eax	# ivtmp.855
.L835:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:353:         for(unsigned j=0;j<5;++j)w[49+j]=mf(region+4+4*j);
	movl	4(%rsi,%rax), %edi	# MEM <unsigned int> [(const uint8_t *)_710 + 4B + ivtmp.855_1598 * 1], MEM <unsigned int> [(const uint8_t *)_710 + 4B + ivtmp.855_1598 * 1]
	movl	%edi, 196(%rbp,%rax)	# MEM <unsigned int> [(const uint8_t *)_710 + 4B + ivtmp.855_1598 * 1], MEM[(float *)_458 + 196B + ivtmp.855_1598 * 1]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:353:         for(unsigned j=0;j<5;++j)w[49+j]=mf(region+4+4*j);
	addq	$4, %rax	#, ivtmp.855
	cmpq	$20, %rax	#, ivtmp.855
	jne	.L835	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:354:         w[54]=0;break;
	movl	$0x00000000, 216(%rbp)	#, MEM[(float *)_458 + 216B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:600:         if((node[2]==1&&!ellipse_packet(i,j,right,down))||(node[2]==2&&!blend_packet(i,j,right,down,forward))||
	movzbl	2(%r12), %edi	# MEM[(const uint8_t *)_243 + 2B], _87
	jmp	.L803	#
.L1042:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	.LC33(%rip), %xmm0	#, iftmp.26_702
	jmp	.L831	#
.L979:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	cvtsd2ss	%xmm0, %xmm0	# _699, iftmp.26_702
	jmp	.L831	#
.L899:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:364:         const double zoom=r<2?i->camera[6]:1;
	movsd	.LC9(%rip), %xmm6	#, iftmp.30_1229
	jmp	.L858	#
.L893:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	.LC33(%rip), %xmm0	#, iftmp.26_632
	jmp	.L819	#
.L1041:
	movss	.LC33(%rip), %xmm0	#, iftmp.26_681
	jmp	.L827	#
.L977:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	cvtsd2ss	%xmm0, %xmm0	# _678, iftmp.26_681
	jmp	.L827	#
.L870:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	.LC33(%rip), %xmm0	#, iftmp.26_1507
	jmp	.L871	#
.L985:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	cvtsd2ss	%xmm0, %xmm0	# _1423, iftmp.26_1425
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:312:     *out=magnitude>(double)FLT_MAX?(v<0?-FLT_MAX:FLT_MAX):(float)v;return true;
	movss	%xmm0, (%rdi,%r8)	# iftmp.26_1425, MEM[(float *)out_1418 + ivtmp.773_756 * 1]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:380:     for(unsigned k=0;k<4;++k)if(!narrow(plane[k],out+k)||fabs(out[k])>1e6)return false;
	andps	%xmm10, %xmm0	# tmp1837, _1427
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:380:     for(unsigned k=0;k<4;++k)if(!narrow(plane[k],out+k)||fabs(out[k])>1e6)return false;
	comiss	.LC43(%rip), %xmm0	#, _1427
	ja	.L801	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:380:     for(unsigned k=0;k<4;++k)if(!narrow(plane[k],out+k)||fabs(out[k])>1e6)return false;
	addq	$4, %r8	#, ivtmp.773
	cmpq	$16, %r8	#, ivtmp.773
	jne	.L872	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:381:     if(out[0]==0&&out[1]==0&&out[2]==0)return false;
	pxor	%xmm0, %xmm0	# tmp1801
	ucomiss	(%rdi), %xmm0	# *out_1418, tmp1801
	jp	.L873	#,
	jne	.L873	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:381:     if(out[0]==0&&out[1]==0&&out[2]==0)return false;
	ucomiss	4(%rdi), %xmm0	# MEM[(float *)out_1418 + 4B], tmp1801
	jp	.L873	#,
	jne	.L873	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:381:     if(out[0]==0&&out[1]==0&&out[2]==0)return false;
	ucomiss	8(%rdi), %xmm0	# MEM[(float *)out_1418 + 8B], tmp1801
	jp	.L873	#,
	je	.L801	#,
.L873:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:382:     out[4]=mf(region+20);surface_write(w,at+20,0,pack_rgb(m32(region+24)));surface_write(w,at+20,1,0);
	movl	20(%rax), %edx	# MEM <unsigned int> [(const uint8_t *)_1175 + 20B], MEM <unsigned int> [(const uint8_t *)_1175 + 20B]
	movl	%edx, 16(%rdi)	# MEM <unsigned int> [(const uint8_t *)_1175 + 20B], MEM[(float *)out_1418 + 16B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:382:     out[4]=mf(region+20);surface_write(w,at+20,0,pack_rgb(m32(region+24)));surface_write(w,at+20,1,0);
	movl	24(%rax), %edi	# MEM <unsigned int> [(const uint8_t *)_1175 + 24B], MEM <unsigned int> [(const uint8_t *)_1175 + 24B]
	call	pack_rgb	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:601:            (node[2]==3&&!mesh_packet(i,j,right,down,forward,false)))
	movss	.LC0(%rip), %xmm10	#, tmp1837
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:382:     out[4]=mf(region+20);surface_write(w,at+20,0,pack_rgb(m32(region+24)));surface_write(w,at+20,1,0);
	movl	%eax, %edx	#, tmp1972
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:382:     out[4]=mf(region+20);surface_write(w,at+20,0,pack_rgb(m32(region+24)));surface_write(w,at+20,1,0);
	leal	20(%rcx), %eax	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:319:     memcpy((uint8_t *)storage+offset+2*index,&value,2);
	movw	%dx, (%rsi,%rax)	# tmp1972, MEM <unsigned short> [(char * {ref-all})_1464]
	movw	$0, 2(%rsi,%rax)	#, MEM <unsigned short> [(char * {ref-all})_1466]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:601:            (node[2]==3&&!mesh_packet(i,j,right,down,forward,false)))
	movzbl	2(%r12), %edi	# MEM[(const uint8_t *)_243 + 2B], _87
	jmp	.L837	#
.L901:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	movl	$264, %ecx	#, iftmp.12_1470
	jmp	.L866	#
.L900:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:28: static unsigned slot_bytes(const uint8_t *node){return node[2]==0?84:node[2]==1?264:316+108u*m16(node+6);}
	movl	$84, %ecx	#, iftmp.12_1470
	jmp	.L866	#
	.cfi_endproc
.LFE49:
	.size	ayatsuri_model_instance_evaluate, .-ayatsuri_model_instance_evaluate
	.p2align 4
	.globl	ayatsuri_model_instance_next
	.type	ayatsuri_model_instance_next, @function
ayatsuri_model_instance_next:
.LFB50:
	.cfi_startproc
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	testq	%rdi, %rdi	# i
	je	.L1049	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpb	$1, 164(%rdi)	#, i_32(D)->alive
	movq	%rdi, %r10	# tmp245, i
	jne	.L1049	#,
	testq	%rsi, %rsi	# owner
	je	.L1049	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpq	16(%rdi), %rsi	# i_32(D)->owner, owner
	jne	.L1049	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpl	32(%rdi), %edx	# i_32(D)->generation, generation
	jne	.L1049	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:215:     if(i->busy)return AYATSURI_MODEL_BUSY;
	cmpb	$0, 165(%rdi)	#, i_32(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:609:     ayatsuri_model_status status=enter(i,owner,generation);if(status)return status;
	movl	$4, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:215:     if(i->busy)return AYATSURI_MODEL_BUSY;
	jne	.L1102	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:610:     if(!i->evaluated)return leave(i,AYATSURI_MODEL_STATE);
	cmpb	$0, 166(%rdi)	#, i_32(D)->evaluated
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:216:     i->busy=true;return AYATSURI_MODEL_OK;
	movb	$1, 165(%rdi)	#, i_32(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:610:     if(!i->evaluated)return leave(i,AYATSURI_MODEL_STATE);
	je	.L1105	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:611:     if(!cursor||!out||overlaps(cursor,sizeof *cursor,out,sizeof *out)||
	testq	%rcx, %rcx	# cursor
	je	.L1103	#,
	testq	%r8, %r8	# out
	je	.L1103	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rcx, %r8	# cursor, out
	jnb	.L1106	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rcx, %rax	# cursor, _43
	subq	%r8, %rax	# out, _43
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$23, %rax	#, _43
	jbe	.L1103	#,
.L1054:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rcx, %r10	# cursor, i
	jb	.L1055	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r10, %rax	# i, _40
	subq	%rcx, %rax	# cursor, _40
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$3, %rax	#, _40
	ja	.L1056	#,
	.p2align 4
	.p2align 3
.L1103:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%r10)	#, i_32(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:616:        *cursor>i->model->node_count)return leave(i,AYATSURI_MODEL_INVALID);
	movl	$1, %eax	#, <retval>
.L1102:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:626: }
	ret	
	.p2align 4,,10
	.p2align 3
.L1105:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%rdi)	#, i_32(D)->busy
.L1049:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:610:     if(!i->evaluated)return leave(i,AYATSURI_MODEL_STATE);
	movl	$3, %eax	#, <retval>
	ret	
	.p2align 4,,10
	.p2align 3
.L1106:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %rax	# out, _44
	subq	%rcx, %rax	# cursor, _44
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$3, %rax	#, _44
	jbe	.L1103	#,
	jmp	.L1054	#
	.p2align 4,,10
	.p2align 3
.L1055:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rcx, %rax	# cursor, _39
	subq	%r10, %rax	# i, _39
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$167, %rax	#, _39
	jbe	.L1103	#,
.L1056:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:612:        overlaps(cursor,sizeof *cursor,i,sizeof *i)||overlaps(cursor,sizeof *cursor,i->model,sizeof *i->model)||
	movq	(%r10), %rdi	# i_32(D)->model, _5
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rcx, %rdi	# cursor, _5
	jnb	.L1107	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rcx, %rax	# cursor, _59
	subq	%rdi, %rax	# _5, _59
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$127, %rax	#, _59
	jbe	.L1103	#,
.L1058:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:613:        overlaps(cursor,sizeof *cursor,i->arena,i->arena_bytes)||overlaps(cursor,sizeof *cursor,i->model->data,i->model->bytes)||
	movq	24(%r10), %rax	# i_32(D)->arena_bytes, _6
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:613:        overlaps(cursor,sizeof *cursor,i->arena,i->arena_bytes)||overlaps(cursor,sizeof *cursor,i->model->data,i->model->bytes)||
	movq	8(%r10), %rdx	# i_32(D)->arena, _7
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rax, %rax	# _6
	je	.L1059	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rcx, %rdx	# cursor, _7
	jb	.L1060	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rdx, %rsi	# _7, _61
	subq	%rcx, %rsi	# cursor, _61
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$3, %rsi	#, _61
	jbe	.L1103	#,
	.p2align 4
	.p2align 3
.L1059:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:608:         uint32_t generation,uint32_t *cursor,ayatsuri_model_packet *out){
	pushq	%r14	#
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13	#
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12	#
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp	#
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx	#
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$24, %rsp	#,
	.cfi_def_cfa_offset 72
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:613:        overlaps(cursor,sizeof *cursor,i->arena,i->arena_bytes)||overlaps(cursor,sizeof *cursor,i->model->data,i->model->bytes)||
	movl	8(%rdi), %r9d	# _5->bytes, _9
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:613:        overlaps(cursor,sizeof *cursor,i->arena,i->arena_bytes)||overlaps(cursor,sizeof *cursor,i->model->data,i->model->bytes)||
	movq	(%rdi), %rbx	# _5->data, _10
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%r9, %r9	# _9
	je	.L1061	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rcx, %rbx	# cursor, _10
	jb	.L1062	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rbx, %rsi	# _10, _64
	subq	%rcx, %rsi	# cursor, _64
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$3, %rsi	#, _64
	jbe	.L1052	#,
	.p2align 4
	.p2align 3
.L1061:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %r10	# out, i
	jb	.L1063	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r10, %rsi	# i, _66
	subq	%r8, %rsi	# out, _66
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$23, %rsi	#, _66
	jbe	.L1052	#,
.L1064:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %rdi	# out, _5
	jb	.L1065	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rdi, %rsi	# _5, _68
	subq	%r8, %rsi	# out, _68
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$23, %rsi	#, _68
	jbe	.L1052	#,
.L1066:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rax, %rax	# _6
	je	.L1067	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %rdx	# out, _7
	jb	.L1068	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rdx, %rax	# _7, _70
	subq	%r8, %rax	# out, _70
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$23, %rax	#, _70
	jbe	.L1052	#,
.L1067:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%r9, %r9	# _9
	je	.L1069	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %rbx	# out, _10
	jb	.L1070	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rbx, %rax	# _10, _72
	subq	%r8, %rax	# out, _72
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$23, %rax	#, _72
	jbe	.L1052	#,
.L1069:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:616:        *cursor>i->model->node_count)return leave(i,AYATSURI_MODEL_INVALID);
	movl	(%rcx), %ebp	# *cursor_37(D), j
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:616:        *cursor>i->model->node_count)return leave(i,AYATSURI_MODEL_INVALID);
	movzwl	12(%rdi), %esi	# _5->node_count, _13
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:615:        overlaps(out,sizeof *out,i->arena,i->arena_bytes)||overlaps(out,sizeof *out,i->model->data,i->model->bytes)||
	cmpl	%ebp, %esi	# j, _13
	jb	.L1052	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:617:     for(unsigned j=*cursor;j<i->model->node_count;++j){const uint8_t *node=row(i->model,1,j,16);
	cmpl	%esi, %ebp	# _13, j
	jnb	.L1072	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	20(%rdi), %r12d	# _5->section[0].offset, _75
	movl	%ebp, %eax	# j, _141
	sall	$4, %eax	#,
	addq	%rbx, %r12	# _10, _105
	addq	%rax, %r12	# _137, ivtmp.966
	movl	%ebp, %eax	# j, _129
	leaq	(%rax,%rax,2), %rax	#, _127
	leaq	8(%rdx,%rax,8), %rax	#, ivtmp.968
	.p2align 4
	.p2align 3
.L1077:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:618:         if(node[2]&&states(i)[j].world_enabled){
	movzbl	2(%r12), %r13d	# MEM[(const uint8_t *)_79 + 2B], _14
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:618:         if(node[2]&&states(i)[j].world_enabled){
	testb	%r13b, %r13b	# _14
	je	.L1073	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:618:         if(node[2]&&states(i)[j].world_enabled){
	cmpb	$0, 9(%rax)	#, MEM[(unsigned char *)_100 + 9B]
	je	.L1073	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movl	(%rax), %r14d	# MEM[(unsigned int *)_100], _151
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	addq	%rdx, %r14	# _7, _152
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:619:             if(node[2]==3&&!((const ksn_proc_gouraud_patch *)((const uint8_t *)work(i,j)+84))->header.triangles)continue;
	cmpb	$3, %r13b	#, _14
	jne	.L1108	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:619:             if(node[2]==3&&!((const ksn_proc_gouraud_patch *)((const uint8_t *)work(i,j)+84))->header.triangles)continue;
	cmpb	$0, 85(%r14)	#, MEM[(const struct ksn_proc_gouraud_patch *)_152 + 84B].header.triangles
	je	.L1073	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:620:             const unsigned bytes=node_slot_bytes(i->model,j,node);
	movl	%ebp, %esi	# j,
	movq	%r12, %rdx	# ivtmp.966,
	movq	%r8, 16(%rsp)	# out, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:622:                 (uint8_t)(node[2]==3?(mesh_double(i->model,node)?5:4):node[2]==2&&bytes>slot_bytes(node)?3:node[2]),(uint8_t)m16(node+6)};
	movl	$4, %r13d	#, _14
	movq	%rcx, 8(%rsp)	# cursor, %sfp
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:620:             const unsigned bytes=node_slot_bytes(i->model,j,node);
	movq	%rdi, (%rsp)	# _5, %sfp
	call	node_slot_bytes	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	movq	(%rsp), %rdi	# %sfp, _5
	movq	8(%rsp), %rcx	# %sfp, cursor
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:621:             *out=(ayatsuri_model_packet){(const uint8_t *)work(i,j),i->lighting,(uint16_t)j,(uint16_t)bytes,
	movl	%ebp, %esi	# j, _21
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:621:             *out=(ayatsuri_model_packet){(const uint8_t *)work(i,j),i->lighting,(uint16_t)j,(uint16_t)bytes,
	movl	%eax, %r11d	# tmp251, _22
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	movq	16(%rsp), %r8	# %sfp, out
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:621:             *out=(ayatsuri_model_packet){(const uint8_t *)work(i,j),i->lighting,(uint16_t)j,(uint16_t)bytes,
	leaq	100(%r10), %r9	#, _20
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	movl	120(%rdi), %eax	# _5->section[12].count,
	testl	%eax, %eax	#
	je	.L1075	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	movzwl	8(%r12), %eax	# MEM <short unsigned int> [(const uint8_t *)_79 + 8B], _112
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	116(%rdi), %edx	# _5->section[12].offset, _115
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	sall	$2, %eax	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	addq	%rax, %rbx	# _117, tmp227
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:622:                 (uint8_t)(node[2]==3?(mesh_double(i->model,node)?5:4):node[2]==2&&bytes>slot_bytes(node)?3:node[2]),(uint8_t)m16(node+6)};
	cmpb	$1, (%rbx,%rdx)	#, *_119
	sete	%r13b	#, tmp236
	addl	$4, %r13d	#, _14
.L1075:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:622:                 (uint8_t)(node[2]==3?(mesh_double(i->model,node)?5:4):node[2]==2&&bytes>slot_bytes(node)?3:node[2]),(uint8_t)m16(node+6)};
	movzwl	6(%r12), %eax	# MEM <short unsigned int> [(const uint8_t *)_79 + 6B], MEM <short unsigned int> [(const uint8_t *)_79 + 6B]
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:623:             *cursor=j+1;return leave(i,AYATSURI_MODEL_OK);
	addl	$1, %ebp	#, tmp230
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:621:             *out=(ayatsuri_model_packet){(const uint8_t *)work(i,j),i->lighting,(uint16_t)j,(uint16_t)bytes,
	movq	%r14, (%r8)	# _152, out_38(D)->storage
	movq	%r9, 8(%r8)	# _20, out_38(D)->lighting
	movb	%al, 21(%r8)	# MEM <short unsigned int> [(const uint8_t *)_79 + 6B], out_38(D)->lobe_count
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:623:             *cursor=j+1;return leave(i,AYATSURI_MODEL_OK);
	xorl	%eax, %eax	# <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:621:             *out=(ayatsuri_model_packet){(const uint8_t *)work(i,j),i->lighting,(uint16_t)j,(uint16_t)bytes,
	movw	%si, 16(%r8)	# _21, out_38(D)->node_id
	movw	%r11w, 18(%r8)	# _22, out_38(D)->bytes
	movb	%r13b, 20(%r8)	# _14, out_38(D)->kind
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:623:             *cursor=j+1;return leave(i,AYATSURI_MODEL_OK);
	movl	%ebp, (%rcx)	# tmp230, *cursor_37(D)
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%r10)	#, i_32(D)->busy
.L1048:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:626: }
	addq	$24, %rsp	#,
	.cfi_def_cfa_offset 48
	popq	%rbx	#
	.cfi_def_cfa_offset 40
	popq	%rbp	#
	.cfi_def_cfa_offset 32
	popq	%r12	#
	.cfi_def_cfa_offset 24
	popq	%r13	#
	.cfi_def_cfa_offset 16
	popq	%r14	#
	.cfi_def_cfa_offset 8
	ret	
	.p2align 4,,10
	.p2align 3
.L1107:
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rdi, %rax	# _5, _58
	subq	%rcx, %rax	# cursor, _58
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$3, %rax	#, _58
	jbe	.L1103	#,
	jmp	.L1058	#
	.p2align 4,,10
	.p2align 3
.L1063:
	.cfi_def_cfa_offset 72
	.cfi_offset 3, -48
	.cfi_offset 6, -40
	.cfi_offset 12, -32
	.cfi_offset 13, -24
	.cfi_offset 14, -16
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %rsi	# out, _67
	subq	%r10, %rsi	# i, _67
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$167, %rsi	#, _67
	ja	.L1064	#,
.L1052:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%r10)	#, i_32(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:626: }
	addq	$24, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 48
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:616:        *cursor>i->model->node_count)return leave(i,AYATSURI_MODEL_INVALID);
	movl	$1, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:626: }
	popq	%rbx	#
	.cfi_def_cfa_offset 40
	popq	%rbp	#
	.cfi_def_cfa_offset 32
	popq	%r12	#
	.cfi_def_cfa_offset 24
	popq	%r13	#
	.cfi_def_cfa_offset 16
	popq	%r14	#
	.cfi_def_cfa_offset 8
	ret	
	.p2align 4,,10
	.p2align 3
.L1073:
	.cfi_restore_state
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:617:     for(unsigned j=*cursor;j<i->model->node_count;++j){const uint8_t *node=row(i->model,1,j,16);
	addl	$1, %ebp	#, j
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:617:     for(unsigned j=*cursor;j<i->model->node_count;++j){const uint8_t *node=row(i->model,1,j,16);
	addq	$16, %r12	#, ivtmp.966
	addq	$24, %rax	#, ivtmp.968
	cmpl	%ebp, %esi	# j, _13
	jne	.L1077	#,
.L1072:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:625:     *cursor=i->model->node_count;return leave(i,AYATSURI_MODEL_DONE);
	movl	%esi, (%rcx)	# _13, *cursor_37(D)
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:625:     *cursor=i->model->node_count;return leave(i,AYATSURI_MODEL_DONE);
	movl	$5, %eax	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%r10)	#, i_32(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:625:     *cursor=i->model->node_count;return leave(i,AYATSURI_MODEL_DONE);
	jmp	.L1048	#
	.p2align 4,,10
	.p2align 3
.L1060:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rcx, %rsi	# cursor, _62
	subq	%rdx, %rsi	# _7, _62
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rax, %rsi	# _6, _62
	jb	.L1103	#,
	jmp	.L1059	#
.L1062:
	.cfi_def_cfa_offset 72
	.cfi_offset 3, -48
	.cfi_offset 6, -40
	.cfi_offset 12, -32
	.cfi_offset 13, -24
	.cfi_offset 14, -16
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rcx, %rsi	# cursor, _65
	subq	%rbx, %rsi	# _10, _65
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r9, %rsi	# _9, _65
	jb	.L1052	#,
	jmp	.L1061	#
.L1065:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %rsi	# out, _69
	subq	%rdi, %rsi	# _5, _69
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$127, %rsi	#, _69
	jbe	.L1052	#,
	jmp	.L1066	#
.L1068:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %rsi	# out, _71
	subq	%rdx, %rsi	# _7, _71
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rax, %rsi	# _6, _71
	jb	.L1052	#,
	jmp	.L1067	#
.L1070:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %rax	# out, _73
	subq	%rbx, %rax	# _10, _73
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r9, %rax	# _9, _73
	jb	.L1052	#,
	jmp	.L1069	#
.L1108:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:620:             const unsigned bytes=node_slot_bytes(i->model,j,node);
	movl	%ebp, %esi	# j,
	movq	%r12, %rdx	# ivtmp.966,
	movq	%r8, 8(%rsp)	# out, %sfp
	movq	%rcx, (%rsp)	# cursor, %sfp
	call	node_slot_bytes	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:622:                 (uint8_t)(node[2]==3?(mesh_double(i->model,node)?5:4):node[2]==2&&bytes>slot_bytes(node)?3:node[2]),(uint8_t)m16(node+6)};
	cmpb	$2, %r13b	#, _14
	movq	(%rsp), %rcx	# %sfp, cursor
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:621:             *out=(ayatsuri_model_packet){(const uint8_t *)work(i,j),i->lighting,(uint16_t)j,(uint16_t)bytes,
	movl	%ebp, %esi	# j, _21
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:622:                 (uint8_t)(node[2]==3?(mesh_double(i->model,node)?5:4):node[2]==2&&bytes>slot_bytes(node)?3:node[2]),(uint8_t)m16(node+6)};
	movq	8(%rsp), %r8	# %sfp, out
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:620:             const unsigned bytes=node_slot_bytes(i->model,j,node);
	movl	%eax, %ebx	# tmp250, bytes
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:621:             *out=(ayatsuri_model_packet){(const uint8_t *)work(i,j),i->lighting,(uint16_t)j,(uint16_t)bytes,
	leaq	100(%r10), %r9	#, _20
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:621:             *out=(ayatsuri_model_packet){(const uint8_t *)work(i,j),i->lighting,(uint16_t)j,(uint16_t)bytes,
	movl	%eax, %r11d	# bytes, _22
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:622:                 (uint8_t)(node[2]==3?(mesh_double(i->model,node)?5:4):node[2]==2&&bytes>slot_bytes(node)?3:node[2]),(uint8_t)m16(node+6)};
	jne	.L1075	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:622:                 (uint8_t)(node[2]==3?(mesh_double(i->model,node)?5:4):node[2]==2&&bytes>slot_bytes(node)?3:node[2]),(uint8_t)m16(node+6)};
	movq	%r12, %rdi	# ivtmp.966,
	call	slot_bytes	#
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:622:                 (uint8_t)(node[2]==3?(mesh_double(i->model,node)?5:4):node[2]==2&&bytes>slot_bytes(node)?3:node[2]),(uint8_t)m16(node+6)};
	cmpl	%ebx, %eax	# bytes, tmp252
	jnb	.L1075	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:622:                 (uint8_t)(node[2]==3?(mesh_double(i->model,node)?5:4):node[2]==2&&bytes>slot_bytes(node)?3:node[2]),(uint8_t)m16(node+6)};
	movl	$3, %r13d	#, _14
	jmp	.L1075	#
	.cfi_endproc
.LFE50:
	.size	ayatsuri_model_instance_next, .-ayatsuri_model_instance_next
	.p2align 4
	.globl	ayatsuri_model_instance_mesh_view
	.type	ayatsuri_model_instance_mesh_view, @function
ayatsuri_model_instance_mesh_view:
.LFB51:
	.cfi_startproc
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:629:         const void *owner,uint32_t generation,uint16_t id,ayatsuri_model_mesh_view *out){
	movq	%rdi, %rax	# tmp203, i
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	testq	%rdi, %rdi	# i
	je	.L1110	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpb	$1, 164(%rdi)	#, i_25(D)->alive
	jne	.L1110	#,
	testq	%rsi, %rsi	# owner
	je	.L1110	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpq	16(%rdi), %rsi	# i_25(D)->owner, owner
	jne	.L1110	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpl	32(%rdi), %edx	# i_25(D)->generation, generation
	jne	.L1110	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:215:     if(i->busy)return AYATSURI_MODEL_BUSY;
	cmpb	$0, 165(%rdi)	#, i_25(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:630:     ayatsuri_model_status status=enter(i,owner,generation);if(status)return status;
	movl	$4, %edx	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:215:     if(i->busy)return AYATSURI_MODEL_BUSY;
	jne	.L1109	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:631:     if(!i->evaluated)return leave(i,AYATSURI_MODEL_STATE);
	cmpb	$0, 166(%rdi)	#, i_25(D)->evaluated
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:216:     i->busy=true;return AYATSURI_MODEL_OK;
	movb	$1, 165(%rdi)	#, i_25(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:631:     if(!i->evaluated)return leave(i,AYATSURI_MODEL_STATE);
	je	.L1138	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:632:     if(!out||id>=i->model->node_count||
	testq	%r8, %r8	# out
	je	.L1115	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:632:     if(!out||id>=i->model->node_count||
	movq	(%rdi), %rdx	# i_25(D)->model, _2
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:632:     if(!out||id>=i->model->node_count||
	cmpw	12(%rdx), %cx	# _2->node_count, id
	jnb	.L1115	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %rdi	# out, i
	jnb	.L1139	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %rsi	# out, _32
	subq	%rdi, %rsi	# i, _32
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$167, %rsi	#, _32
	jbe	.L1115	#,
.L1117:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %rdx	# out, _2
	jb	.L1118	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rdx, %rsi	# _2, _43
	subq	%r8, %rsi	# out, _43
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$23, %rsi	#, _43
	ja	.L1119	#,
.L1115:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:635:         return leave(i,AYATSURI_MODEL_INVALID);
	movl	$1, %edx	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%rax)	#, i_25(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:642: }
	movl	%edx, %eax	# <retval>,
	ret	
	.p2align 4,,10
	.p2align 3
.L1138:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%rdi)	#, i_25(D)->busy
	.p2align 4
	.p2align 3
.L1110:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:630:     ayatsuri_model_status status=enter(i,owner,generation);if(status)return status;
	movl	$3, %edx	#, <retval>
.L1109:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:642: }
	movl	%edx, %eax	# <retval>,
	ret	
	.p2align 4,,10
	.p2align 3
.L1139:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rdi, %rsi	# i, _33
	subq	%r8, %rsi	# out, _33
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$23, %rsi	#, _33
	jbe	.L1115	#,
	jmp	.L1117	#
	.p2align 4,,10
	.p2align 3
.L1118:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %rsi	# out, _44
	subq	%rdx, %rsi	# _2, _44
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$127, %rsi	#, _44
	jbe	.L1115	#,
.L1119:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:634:        overlaps(out,sizeof *out,i->arena,i->arena_bytes)||overlaps(out,sizeof *out,i->model->data,i->model->bytes))
	movq	24(%rax), %rsi	# i_25(D)->arena_bytes, _4
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:634:        overlaps(out,sizeof *out,i->arena,i->arena_bytes)||overlaps(out,sizeof *out,i->model->data,i->model->bytes))
	movq	8(%rax), %rdi	# i_25(D)->arena, _5
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rsi, %rsi	# _4
	je	.L1120	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %rdi	# out, _5
	jb	.L1121	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rdi, %rsi	# _5, _46
	subq	%r8, %rsi	# out, _46
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$23, %rsi	#, _46
	jbe	.L1115	#,
	.p2align 4
	.p2align 3
.L1120:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:634:        overlaps(out,sizeof *out,i->arena,i->arena_bytes)||overlaps(out,sizeof *out,i->model->data,i->model->bytes))
	movl	8(%rdx), %esi	# _2->bytes, _7
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:634:        overlaps(out,sizeof *out,i->arena,i->arena_bytes)||overlaps(out,sizeof *out,i->model->data,i->model->bytes))
	movq	(%rdx), %r10	# _2->data, _8
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rsi, %rsi	# _7
	jne	.L1140	#,
.L1122:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	%rcx, %r9	# id, _53
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	20(%rdx), %esi	# _2->section[0].offset, _52
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	salq	$4, %r9	#, _53
	andl	$1048560, %r9d	#, _54
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%r9, %rsi	# _54, _55
	addq	%r10, %rsi	# _8, _56
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:637:     if(node[2]!=3||mesh_double(i->model,node)||!states(i)[id].world_enabled)return leave(i,AYATSURI_MODEL_INVALID);
	cmpb	$3, 2(%rsi)	#, MEM[(const uint8_t *)_56 + 2B]
	jne	.L1115	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	movl	120(%rdx), %r9d	# _2->section[12].count,
	testl	%r9d, %r9d	#
	je	.L1124	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	movzwl	8(%rsi), %esi	# MEM <short unsigned int> [(const uint8_t *)_56 + 8B], _81
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	116(%rdx), %edx	# _2->section[12].offset, _84
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	sall	$2, %esi	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	addq	%rsi, %r10	# _86, tmp187
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	cmpb	$1, (%r10,%rdx)	#, *_88
	je	.L1115	#,
.L1124:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:637:     if(node[2]!=3||mesh_double(i->model,node)||!states(i)[id].world_enabled)return leave(i,AYATSURI_MODEL_INVALID);
	movzwl	%cx, %edx	# id, _12
	leaq	(%rdx,%rdx,2), %rdx	#, _13
	leaq	(%rdi,%rdx,8), %rdx	#, _14
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:637:     if(node[2]!=3||mesh_double(i->model,node)||!states(i)[id].world_enabled)return leave(i,AYATSURI_MODEL_INVALID);
	cmpb	$0, 17(%rdx)	#, _14->world_enabled
	je	.L1115	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movl	8(%rdx), %edx	# _14->offset, _58
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	addq	%rdx, %rdi	# _58, _59
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:640:     *out=(ayatsuri_model_mesh_view){p,xy+2*p->header.vertices,id,p->header.vertices};
	movzbl	84(%rdi), %esi	# MEM[(const struct ksn_proc_gouraud_patch *)_59 + 84B].header.vertices, _16
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:638:     const ksn_proc_gouraud_patch *p=(const ksn_proc_gouraud_patch *)((const uint8_t *)work(i,id)+84);
	leaq	84(%rdi), %rdx	#, tmp195
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:640:     *out=(ayatsuri_model_mesh_view){p,xy+2*p->header.vertices,id,p->header.vertices};
	movw	%cx, 16(%r8)	# id, out_30(D)->node_id
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:638:     const ksn_proc_gouraud_patch *p=(const ksn_proc_gouraud_patch *)((const uint8_t *)work(i,id)+84);
	movq	%rdx, (%r8)	# tmp195, out_30(D)->patch
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:640:     *out=(ayatsuri_model_mesh_view){p,xy+2*p->header.vertices,id,p->header.vertices};
	leaq	0(,%rsi,8), %rdx	#, _19
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:640:     *out=(ayatsuri_model_mesh_view){p,xy+2*p->header.vertices,id,p->header.vertices};
	movb	%sil, 18(%r8)	# _16, out_30(D)->vertices
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:640:     *out=(ayatsuri_model_mesh_view){p,xy+2*p->header.vertices,id,p->header.vertices};
	andl	$2040, %edx	#, _20
	leaq	1124(%rdi,%rdx), %rdx	#, tmp201
	movq	%rdx, 8(%r8)	# tmp201, out_30(D)->depth
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:641:     return leave(i,AYATSURI_MODEL_OK);
	xorl	%edx, %edx	# <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%rax)	#, i_25(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:641:     return leave(i,AYATSURI_MODEL_OK);
	jmp	.L1109	#
	.p2align 4,,10
	.p2align 3
.L1140:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %r10	# out, _8
	jb	.L1123	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r10, %rsi	# _8, _49
	subq	%r8, %rsi	# out, _49
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$23, %rsi	#, _49
	jbe	.L1115	#,
	jmp	.L1122	#
	.p2align 4,,10
	.p2align 3
.L1121:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %r9	# out, _47
	subq	%rdi, %r9	# _5, _47
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rsi, %r9	# _4, _47
	jb	.L1115	#,
	jmp	.L1120	#
	.p2align 4,,10
	.p2align 3
.L1123:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %r9	# out, _50
	subq	%r10, %r9	# _8, _50
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rsi, %r9	# _7, _50
	jnb	.L1122	#,
	jmp	.L1115	#
	.cfi_endproc
.LFE51:
	.size	ayatsuri_model_instance_mesh_view, .-ayatsuri_model_instance_mesh_view
	.p2align 4
	.globl	ayatsuri_model_instance_sided_mesh_view
	.type	ayatsuri_model_instance_sided_mesh_view, @function
ayatsuri_model_instance_sided_mesh_view:
.LFB52:
	.cfi_startproc
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:645:         const void *owner,uint32_t generation,uint16_t id,ayatsuri_model_sided_mesh_view *out){
	movq	%rdi, %rax	# tmp221, i
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	testq	%rdi, %rdi	# i
	je	.L1142	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpb	$1, 164(%rdi)	#, i_27(D)->alive
	jne	.L1142	#,
	testq	%rsi, %rsi	# owner
	je	.L1142	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpq	16(%rdi), %rsi	# i_27(D)->owner, owner
	jne	.L1142	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:214:     if(!i||!i->alive||!owner||i->owner!=owner||i->generation!=generation)return AYATSURI_MODEL_STATE;
	cmpl	32(%rdi), %edx	# i_27(D)->generation, generation
	jne	.L1142	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:215:     if(i->busy)return AYATSURI_MODEL_BUSY;
	cmpb	$0, 165(%rdi)	#, i_27(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:646:     ayatsuri_model_status status=enter(i,owner,generation);if(status)return status;
	movl	$4, %edx	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:215:     if(i->busy)return AYATSURI_MODEL_BUSY;
	jne	.L1141	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:647:     if(!i->evaluated)return leave(i,AYATSURI_MODEL_STATE);
	cmpb	$0, 166(%rdi)	#, i_27(D)->evaluated
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:216:     i->busy=true;return AYATSURI_MODEL_OK;
	movb	$1, 165(%rdi)	#, i_27(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:647:     if(!i->evaluated)return leave(i,AYATSURI_MODEL_STATE);
	je	.L1169	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:648:     if(!out||id>=i->model->node_count||overlaps(out,sizeof *out,i,sizeof *i)||
	testq	%r8, %r8	# out
	je	.L1147	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:648:     if(!out||id>=i->model->node_count||overlaps(out,sizeof *out,i,sizeof *i)||
	movq	(%rdi), %rdx	# i_27(D)->model, _2
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:648:     if(!out||id>=i->model->node_count||overlaps(out,sizeof *out,i,sizeof *i)||
	cmpw	12(%rdx), %cx	# _2->node_count, id
	jnb	.L1147	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %rdi	# out, i
	jnb	.L1170	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %rsi	# out, _34
	subq	%rdi, %rsi	# i, _34
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$167, %rsi	#, _34
	jbe	.L1147	#,
.L1149:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %rdx	# out, _2
	jb	.L1150	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rdx, %rsi	# _2, _47
	subq	%r8, %rsi	# out, _47
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$39, %rsi	#, _47
	ja	.L1151	#,
.L1147:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:650:        overlaps(out,sizeof *out,i->model->data,i->model->bytes))return leave(i,AYATSURI_MODEL_INVALID);
	movl	$1, %edx	#, <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%rax)	#, i_27(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:658: }
	movl	%edx, %eax	# <retval>,
	ret	
	.p2align 4,,10
	.p2align 3
.L1169:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%rdi)	#, i_27(D)->busy
	.p2align 4
	.p2align 3
.L1142:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:646:     ayatsuri_model_status status=enter(i,owner,generation);if(status)return status;
	movl	$3, %edx	#, <retval>
.L1141:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:658: }
	movl	%edx, %eax	# <retval>,
	ret	
	.p2align 4,,10
	.p2align 3
.L1170:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rdi, %rsi	# i, _35
	subq	%r8, %rsi	# out, _35
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$39, %rsi	#, _35
	jbe	.L1147	#,
	jmp	.L1149	#
	.p2align 4,,10
	.p2align 3
.L1150:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %rsi	# out, _48
	subq	%rdx, %rsi	# _2, _48
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$127, %rsi	#, _48
	jbe	.L1147	#,
.L1151:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:649:        overlaps(out,sizeof *out,i->model,sizeof *i->model)||overlaps(out,sizeof *out,i->arena,i->arena_bytes)||
	movq	24(%rax), %rdi	# i_27(D)->arena_bytes, _4
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:649:        overlaps(out,sizeof *out,i->model,sizeof *i->model)||overlaps(out,sizeof *out,i->arena,i->arena_bytes)||
	movq	8(%rax), %rsi	# i_27(D)->arena, _5
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rdi, %rdi	# _4
	je	.L1152	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %rsi	# out, _5
	jb	.L1153	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%rsi, %rdi	# _5, _50
	subq	%r8, %rdi	# out, _50
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$39, %rdi	#, _50
	jbe	.L1147	#,
	.p2align 4
	.p2align 3
.L1152:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:650:        overlaps(out,sizeof *out,i->model->data,i->model->bytes))return leave(i,AYATSURI_MODEL_INVALID);
	movl	8(%rdx), %edi	# _2->bytes, _7
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:650:        overlaps(out,sizeof *out,i->model->data,i->model->bytes))return leave(i,AYATSURI_MODEL_INVALID);
	movq	(%rdx), %r9	# _2->data, _8
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	testq	%rdi, %rdi	# _7
	jne	.L1171	#,
.L1154:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movq	%rcx, %r10	# id, _57
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	20(%rdx), %edi	# _2->section[0].offset, _56
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	salq	$4, %r10	#, _57
	andl	$1048560, %r10d	#, _58
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	addq	%r10, %rdi	# _58, _59
	addq	%r9, %rdi	# _8, _60
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	cmpb	$3, 2(%rdi)	#, MEM[(const uint8_t *)_60 + 2B]
	jne	.L1147	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	movl	120(%rdx), %r10d	# _2->section[12].count,
	testl	%r10d, %r10d	#
	je	.L1147	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	movzwl	8(%rdi), %edi	# MEM <short unsigned int> [(const uint8_t *)_60 + 8B], _91
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	movl	116(%rdx), %edx	# _2->section[12].offset, _94
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:26:     return m->data+m->section[section-1].offset+index*stride;
	sall	$2, %edi	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	addq	%rdi, %r9	# _96, tmp196
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:34:     return node[2]==3&&m->section[12].count&&row(m,13,m16(node+8),4)[0]==1;
	cmpb	$1, (%r9,%rdx)	#, *_98
	jne	.L1147	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:652:     if(!mesh_double(i->model,node)||!states(i)[id].world_enabled)return leave(i,AYATSURI_MODEL_INVALID);
	movzwl	%cx, %edx	# id, _11
	leaq	(%rdx,%rdx,2), %rdx	#, _12
	leaq	(%rsi,%rdx,8), %rdx	#, _13
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:652:     if(!mesh_double(i->model,node)||!states(i)[id].world_enabled)return leave(i,AYATSURI_MODEL_INVALID);
	cmpb	$0, 17(%rdx)	#, _13->world_enabled
	je	.L1147	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	movl	8(%rdx), %r11d	# _13->offset, _68
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:212: static float *work(ayatsuri_model_instance *i,unsigned node){return (float *)((uint8_t *)i->arena+states(i)[node].offset);}
	leaq	(%rsi,%r11), %r9	#, _69
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:655:     const uint16_t *back=mesh_back_colors(i,id,p->header.vertices);
	movzbl	84(%r9), %edi	# MEM[(const struct ksn_proc_gouraud_patch *)_69 + 84B].header.vertices,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:656:     *out=(ayatsuri_model_sided_mesh_view){p,xy+2*p->header.vertices,back,(const uint8_t *)(back+2*p->header.vertices),id,p->header.vertices};
	movw	%cx, 32(%r8)	# id, out_32(D)->node_id
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:36: static unsigned mesh_legacy_bytes(unsigned nv){return (84u+sizeof(ksn_proc_gouraud_patch)+12u*nv+7u)&~7u;}
	leal	(%rdi,%rdi), %edx	#, tmp205
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:655:     const uint16_t *back=mesh_back_colors(i,id,p->header.vertices);
	movl	%edi, %r10d	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:36: static unsigned mesh_legacy_bytes(unsigned nv){return (84u+sizeof(ksn_proc_gouraud_patch)+12u*nv+7u)&~7u;}
	addl	%edx, %edi	# tmp205, _61
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:656:     *out=(ayatsuri_model_sided_mesh_view){p,xy+2*p->header.vertices,back,(const uint8_t *)(back+2*p->header.vertices),id,p->header.vertices};
	movslq	%edx, %rdx	# tmp205, _19
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:656:     *out=(ayatsuri_model_sided_mesh_view){p,xy+2*p->header.vertices,back,(const uint8_t *)(back+2*p->header.vertices),id,p->header.vertices};
	movb	%r10b, 34(%r8)	# _15, out_32(D)->vertices
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:36: static unsigned mesh_legacy_bytes(unsigned nv){return (84u+sizeof(ksn_proc_gouraud_patch)+12u*nv+7u)&~7u;}
	leal	1131(,%rdi,4), %edi	#, _62
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:443:     return (uint16_t *)((uint8_t *)work(i,id)+mesh_legacy_bytes(nv));
	andl	$8184, %edi	#, _64
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:443:     return (uint16_t *)((uint8_t *)work(i,id)+mesh_legacy_bytes(nv));
	addq	%r11, %rdi	# _68, _65
	addq	%rdi, %rsi	# _65, _66
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:653:     const ksn_proc_gouraud_patch *p=(const ksn_proc_gouraud_patch *)((const uint8_t *)work(i,id)+84);
	leaq	84(%r9), %rdi	#, tmp214
	movq	%rdi, (%r8)	# tmp214, out_32(D)->patch
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:656:     *out=(ayatsuri_model_sided_mesh_view){p,xy+2*p->header.vertices,back,(const uint8_t *)(back+2*p->header.vertices),id,p->header.vertices};
	leaq	1124(%r9,%rdx,4), %rdi	#, tmp217
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:656:     *out=(ayatsuri_model_sided_mesh_view){p,xy+2*p->header.vertices,back,(const uint8_t *)(back+2*p->header.vertices),id,p->header.vertices};
	leaq	(%rsi,%rdx,2), %rdx	#, tmp219
	movq	%rdx, 24(%r8)	# tmp219, out_32(D)->back_faces
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:657:     return leave(i,AYATSURI_MODEL_OK);
	xorl	%edx, %edx	# <retval>
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:656:     *out=(ayatsuri_model_sided_mesh_view){p,xy+2*p->header.vertices,back,(const uint8_t *)(back+2*p->header.vertices),id,p->header.vertices};
	movq	%rdi, 8(%r8)	# tmp217, out_32(D)->depth
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:656:     *out=(ayatsuri_model_sided_mesh_view){p,xy+2*p->header.vertices,back,(const uint8_t *)(back+2*p->header.vertices),id,p->header.vertices};
	movq	%rsi, 16(%r8)	# _66, out_32(D)->back_colors
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:218: static ayatsuri_model_status leave(ayatsuri_model_instance *i,ayatsuri_model_status status){i->busy=false;return status;}
	movb	$0, 165(%rax)	#, i_27(D)->busy
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:657:     return leave(i,AYATSURI_MODEL_OK);
	jmp	.L1141	#
	.p2align 4,,10
	.p2align 3
.L1171:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%r8, %r9	# out, _8
	jb	.L1155	#,
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r9, %rdi	# _8, _53
	subq	%r8, %rdi	# out, _53
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	$39, %rdi	#, _53
	jbe	.L1147	#,
	jmp	.L1154	#
	.p2align 4,,10
	.p2align 3
.L1153:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %r9	# out, _51
	subq	%rsi, %r9	# _5, _51
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rdi, %r9	# _4, _51
	jb	.L1147	#,
	jmp	.L1152	#
	.p2align 4,,10
	.p2align 3
.L1155:
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	movq	%r8, %r10	# out, _54
	subq	%r9, %r10	# _8, _54
# candidate-early-snorm/main/ayatsuri/ayatsuri_model.c:23:     return an&&bn&&(x<=y?y-x<an:x-y<bn);
	cmpq	%rdi, %r10	# _7, _54
	jnb	.L1154	#,
	jmp	.L1147	#
	.cfi_endproc
.LFE52:
	.size	ayatsuri_model_instance_sided_mesh_view, .-ayatsuri_model_instance_sided_mesh_view
	.section	.rodata
	.align 32
	.type	strides.0, @object
	.size	strides.0, 52
strides.0:
	.long	16
	.long	36
	.long	12
	.long	24
	.long	72
	.long	8
	.long	1
	.long	32
	.long	32
	.long	28
	.long	6
	.long	12
	.long	4
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC0:
	.long	2147483647
	.long	0
	.long	0
	.long	0
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC1:
	.long	2139095039
	.align 4
.LC3:
	.long	1166016512
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC4:
	.long	0
	.long	1077870592
	.align 8
.LC5:
	.long	0
	.long	1081073664
	.align 8
.LC6:
	.long	0
	.long	1071644672
	.align 8
.LC7:
	.long	0
	.long	1127219200
	.section	.rodata.cst16
	.align 16
.LC8:
	.long	-1
	.long	2147483647
	.long	0
	.long	0
	.section	.rodata.cst8
	.align 8
.LC9:
	.long	0
	.long	1072693248
	.align 8
.LC10:
	.long	0
	.long	1078951936
	.align 8
.LC11:
	.long	0
	.long	1084227584
	.align 8
.LC12:
	.long	0
	.long	1077936128
	.set	.LC13,.LC8
	.section	.rodata.cst4
	.align 4
.LC14:
	.long	1023680776
	.set	.LC15,.LC41
	.align 4
.LC16:
	.long	1106771968
	.align 4
.LC17:
	.long	1015154721
	.align 4
.LC18:
	.long	1115422720
	.align 4
.LC19:
	.long	939524352
	.section	.rodata.cst16
	.align 16
.LC20:
	.long	-2147483648
	.long	0
	.long	0
	.long	0
	.section	.rodata.cst4
	.align 4
.LC21:
	.long	998277249
	.section	.rodata.cst8
	.align 8
.LC22:
	.long	-1
	.long	2146435071
	.align 8
.LC24:
	.long	0
	.long	1088421824
	.align 8
.LC25:
	.long	0
	.long	-1059061824
	.section	.rodata.cst16
	.align 16
.LC26:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.section	.rodata.cst8
	.align 8
.LC27:
	.long	-1998362383
	.long	1055193269
	.section	.rodata.cst4
	.align 4
.LC28:
	.long	1073741824
	.section	.rodata.cst8
	.align 8
.LC29:
	.long	-350469331
	.long	1058682594
	.section	.rodata.cst4
	.align 4
.LC30:
	.long	1124073472
	.align 4
.LC31:
	.long	953267991
	.section	.rodata.cst8
	.align 8
.LC32:
	.long	1065353216
	.long	1065353216
	.section	.rodata.cst4
	.align 4
.LC33:
	.long	-8388609
	.section	.rodata.cst8
	.align 8
.LC34:
	.long	0
	.long	1093567616
	.align 8
.LC35:
	.long	0
	.long	1085276160
	.align 8
.LC37:
	.long	-1598689907
	.long	1051772663
	.align 8
.LC38:
	.long	-268435456
	.long	1206910975
	.align 8
.LC39:
	.long	-536870912
	.long	1206910975
	.align 8
.LC40:
	.long	-2127697391
	.long	1030854553
	.section	.rodata.cst16
	.align 16
.LC41:
	.long	1065353216
	.long	-2147483648
	.long	0
	.long	0
	.section	.rodata.cst4
	.align 4
.LC43:
	.long	1232348160
	.ident	"GCC: (Debian 14.2.0-19) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
