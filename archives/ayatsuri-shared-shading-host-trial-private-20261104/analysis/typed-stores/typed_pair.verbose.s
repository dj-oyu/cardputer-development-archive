	.file	"shade_pair.c"
# GNU C11 (Debian 14.2.0-19) version 14.2.0 (x86_64-linux-gnu)
#	compiled by GNU C version 14.2.0, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.27-GMP

# warning: MPFR header version 4.2.1 differs from library version 4.2.2.
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mtune=generic -march=x86-64 -O2 -std=c11 -ffp-contract=off -fexcess-precision=standard -fno-fast-math -fasynchronous-unwind-tables
	.text
	.p2align 4
	.type	ayatsuri_shade_from_terms.isra.0, @function
ayatsuri_shade_from_terms.isra.0:
.LFB7:
	.cfi_startproc
	pushq	%r14	#
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:49:     const unsigned r=ayatsuri_shade_channel(((albedo>>11)&31)*(1.0f/31),light[6],m[5],front,spec,back,thin,m,31);
	movl	%edi, %eax	# albedo, _10
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:46: static __attribute__((noinline)) uint16_t ayatsuri_shade_from_terms(uint16_t albedo,const float light[9],
	movq	%rsi, %r14	# tmp244, light
	pushq	%r13	#
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:49:     const unsigned r=ayatsuri_shade_channel(((albedo>>11)&31)*(1.0f/31),light[6],m[5],front,spec,back,thin,m,31);
	shrw	$11, %ax	#, _10
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:46: static __attribute__((noinline)) uint16_t ayatsuri_shade_from_terms(uint16_t albedo,const float light[9],
	pushq	%r12	#
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:49:     const unsigned r=ayatsuri_shade_channel(((albedo>>11)&31)*(1.0f/31),light[6],m[5],front,spec,back,thin,m,31);
	movzwl	%ax, %eax	# _10, _11
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:46: static __attribute__((noinline)) uint16_t ayatsuri_shade_from_terms(uint16_t albedo,const float light[9],
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
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	4(%rdx), %xmm5	# MEM[(const float *)m_5(D) + 4B], tmp246
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:49:     const unsigned r=ayatsuri_shade_channel(((albedo>>11)&31)*(1.0f/31),light[6],m[5],front,spec,back,thin,m,31);
	movss	24(%rsi), %xmm4	# MEM[(const float *)light_7(D) + 24B], _8
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	16(%rdx), %xmm3	# MEM[(const float *)m_5(D) + 16B], _98
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	(%rdx), %xmm7	# *m_5(D), _89
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm0, %xmm5	# tmp246, tmp246
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	8(%rdx), %xmm6	# MEM[(const float *)m_5(D) + 8B], tmp248
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	%xmm7, (%rsp)	# _89, %sfp
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm2, %xmm6	# tmp248, tmp248
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm1, %xmm3	# tmp247, _99
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:49:     const unsigned r=ayatsuri_shade_channel(((albedo>>11)&31)*(1.0f/31),light[6],m[5],front,spec,back,thin,m,31);
	pxor	%xmm1, %xmm1	# _12
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	%xmm5, 4(%rsp)	# _91, %sfp
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm4, %xmm5	# _8, _92
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:49:     const unsigned r=ayatsuri_shade_channel(((albedo>>11)&31)*(1.0f/31),light[6],m[5],front,spec,back,thin,m,31);
	cvtsi2ssl	%eax, %xmm1	# _11, _12
	mulss	.LC1(%rip), %xmm1	#, _13
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	%xmm6, 8(%rsp)	# _96, %sfp
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movaps	%xmm5, %xmm0	# _92, _92
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	addss	%xmm7, %xmm0	# _89, _93
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm0, %xmm1	# _93, _94
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	20(%rdx), %xmm0	# MEM[(const float *)m_5(D) + 20B], _100
	mulss	%xmm3, %xmm0	# _99, _100
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	addss	%xmm6, %xmm0	# _96, _101
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm4, %xmm0	# _8, _102
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	addss	%xmm0, %xmm1	# _102, v
	pxor	%xmm0, %xmm0	# _45
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:20:     if(v<0)v=0;
	comiss	%xmm1, %xmm0	# v, _45
	ja	.L2	#,
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:22:     return (unsigned)lroundf(v*(float)max);
	movss	.LC2(%rip), %xmm2	#, tmp187
	movaps	%xmm2, %xmm0	# tmp187, tmp189
	cmpltss	%xmm1, %xmm0	#, v, tmp189
	andps	%xmm0, %xmm2	# tmp189, tmp190
	andnps	%xmm1, %xmm0	# v, tmp191
	orps	%xmm2, %xmm0	# tmp190, _105
	mulss	.LC3(%rip), %xmm0	#, _45
.L2:
	movss	%xmm3, 12(%rsp)	# _99, %sfp
	call	lroundf@PLT	#
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:50:     const unsigned g=ayatsuri_shade_channel(((albedo>>5)&63)*(1.0f/63),light[7],m[6],front,spec,back,thin,m,63);
	movss	28(%r14), %xmm2	# MEM[(const float *)light_7(D) + 28B], _16
	pxor	%xmm1, %xmm1	# _20
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	4(%rsp), %xmm0	# %sfp, _70
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:22:     return (unsigned)lroundf(v*(float)max);
	movq	%rax, %rbx	# tmp250, tmp193
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:50:     const unsigned g=ayatsuri_shade_channel(((albedo>>5)&63)*(1.0f/63),light[7],m[6],front,spec,back,thin,m,63);
	movl	%r12d, %eax	# albedo, _17
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	12(%rsp), %xmm3	# %sfp, _99
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm2, %xmm0	# _16, _70
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:50:     const unsigned g=ayatsuri_shade_channel(((albedo>>5)&63)*(1.0f/63),light[7],m[6],front,spec,back,thin,m,63);
	shrw	$5, %ax	#, _17
	andl	$63, %eax	#, _19
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	addss	(%rsp), %xmm0	# %sfp, _71
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:50:     const unsigned g=ayatsuri_shade_channel(((albedo>>5)&63)*(1.0f/63),light[7],m[6],front,spec,back,thin,m,63);
	cvtsi2ssl	%eax, %xmm1	# _19, _20
	mulss	.LC4(%rip), %xmm1	#, _21
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm0, %xmm1	# _71, _72
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	24(%rbp), %xmm0	# MEM[(const float *)m_5(D) + 24B], _78
	mulss	%xmm3, %xmm0	# _99, _78
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	addss	8(%rsp), %xmm0	# %sfp, _79
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm2, %xmm0	# _16, _80
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	addss	%xmm0, %xmm1	# _80, v
	pxor	%xmm0, %xmm0	# _47
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:20:     if(v<0)v=0;
	comiss	%xmm1, %xmm0	# v, _47
	ja	.L3	#,
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:22:     return (unsigned)lroundf(v*(float)max);
	movss	.LC2(%rip), %xmm2	#, tmp209
	movaps	%xmm2, %xmm0	# tmp209, tmp211
	cmpltss	%xmm1, %xmm0	#, v, tmp211
	andps	%xmm0, %xmm2	# tmp211, tmp212
	andnps	%xmm1, %xmm0	# v, tmp213
	orps	%xmm2, %xmm0	# tmp212, _83
	mulss	.LC5(%rip), %xmm0	#, _47
.L3:
	movss	%xmm3, 12(%rsp)	# _99, %sfp
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:51:     const unsigned b=ayatsuri_shade_channel((albedo&31)*(1.0f/31),light[8],m[7],front,spec,back,thin,m,31);
	andl	$31, %r12d	#, _26
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:22:     return (unsigned)lroundf(v*(float)max);
	call	lroundf@PLT	#
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:51:     const unsigned b=ayatsuri_shade_channel((albedo&31)*(1.0f/31),light[8],m[7],front,spec,back,thin,m,31);
	movss	32(%r14), %xmm2	# MEM[(const float *)light_7(D) + 32B], _24
	pxor	%xmm1, %xmm1	# _27
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	4(%rsp), %xmm0	# %sfp, _91
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:51:     const unsigned b=ayatsuri_shade_channel((albedo&31)*(1.0f/31),light[8],m[7],front,spec,back,thin,m,31);
	cvtsi2ssl	%r12d, %xmm1	# _26, _27
	mulss	.LC1(%rip), %xmm1	#, _28
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	movss	12(%rsp), %xmm3	# %sfp, _99
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:22:     return (unsigned)lroundf(v*(float)max);
	movq	%rax, %r13	# tmp251, tmp215
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm2, %xmm0	# _24, _91
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	28(%rbp), %xmm3	# MEM[(const float *)m_5(D) + 28B], _56
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	addss	(%rsp), %xmm0	# %sfp, _49
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	addss	8(%rsp), %xmm3	# %sfp, _57
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm0, %xmm1	# _49, _50
	pxor	%xmm0, %xmm0	# _52
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	mulss	%xmm2, %xmm3	# _24, _58
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:19:     float v=base*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
	addss	%xmm3, %xmm1	# _58, v
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:20:     if(v<0)v=0;
	comiss	%xmm1, %xmm0	# v, _52
	ja	.L4	#,
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:22:     return (unsigned)lroundf(v*(float)max);
	movss	.LC2(%rip), %xmm2	#, tmp230
	movaps	%xmm2, %xmm0	# tmp230, tmp232
	cmpltss	%xmm1, %xmm0	#, v, tmp232
	andps	%xmm0, %xmm2	# tmp232, tmp233
	andnps	%xmm1, %xmm0	# v, tmp234
	orps	%xmm2, %xmm0	# tmp233, _61
	mulss	.LC3(%rip), %xmm0	#, _52
.L4:
	call	lroundf@PLT	#
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:52:     return (uint16_t)((r<<11)|(g<<5)|b);
	sall	$5, %r13d	#, _33
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:52:     return (uint16_t)((r<<11)|(g<<5)|b);
	sall	$11, %ebx	#, _31
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:53: }
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 48
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:52:     return (uint16_t)((r<<11)|(g<<5)|b);
	orl	%r13d, %ebx	# _33, _34
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:52:     return (uint16_t)((r<<11)|(g<<5)|b);
	orl	%ebx, %eax	# _34, _36
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:53: }
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
.LFE7:
	.size	ayatsuri_shade_from_terms.isra.0, .-ayatsuri_shade_from_terms.isra.0
	.p2align 4
	.globl	shade_pair
	.type	shade_pair, @function
shade_pair:
.LFB6:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	pxor	%xmm1, %xmm1	# _32
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	pxor	%xmm4, %xmm4	# _35
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	pxor	%xmm3, %xmm3	# _38
# analysis/typed-stores/shade_pair.c:4:         const float light[9],const float m[8],const ayatsuri_shade_basis *basis,uint16_t out[2]){
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%r9, %r15	# tmp210, basis
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rsi, %r13	# tmp206, albedo
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rcx, %r12	# tmp208, light
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%r8, %rbp	# tmp209, m
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movl	%edx, %ebx	# tmp207, thickness
	subq	$40, %rsp	#,
	.cfi_def_cfa_offset 96
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	movswl	(%rdi), %edx	# *normal_10(D), *normal_10(D)
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	movswl	4(%rdi), %eax	# MEM[(const int16_t *)normal_10(D) + 4B], MEM[(const int16_t *)normal_10(D) + 4B]
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	movss	.LC6(%rip), %xmm0	#, tmp164
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movss	.LC7(%rip), %xmm2	#, tmp172
# analysis/typed-stores/shade_pair.c:4:         const float light[9],const float m[8],const ayatsuri_shade_basis *basis,uint16_t out[2]){
	movq	96(%rsp), %r14	# out, out
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	cvtsi2ssl	%edx, %xmm1	# *normal_10(D), _32
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	movswl	2(%rdi), %edx	# MEM[(const int16_t *)normal_10(D) + 2B], MEM[(const int16_t *)normal_10(D) + 2B]
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	cvtsi2ssl	%eax, %xmm3	# MEM[(const int16_t *)normal_10(D) + 4B], _38
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	cvtsi2ssl	%edx, %xmm4	# MEM[(const int16_t *)normal_10(D) + 2B], _35
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	mulss	%xmm0, %xmm1	# tmp164, _32
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	mulss	%xmm0, %xmm3	# tmp164, z
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	mulss	%xmm0, %xmm4	# tmp164, y
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:38:     float x=normal[0]*(1.0f/32767),y=normal[1]*(1.0f/32767),z=normal[2]*(1.0f/32767);
	movss	%xmm1, 8(%rsp)	# _32, %sfp
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movaps	%xmm3, %xmm0	# z, _73
	movss	%xmm3, 12(%rsp)	# z, %sfp
	movaps	%xmm4, %xmm5	# y, _75
	andps	%xmm2, %xmm0	# tmp172, _73
	movss	%xmm4, 16(%rsp)	# y, %sfp
	andps	%xmm2, %xmm5	# tmp172, _75
	movaps	%xmm5, %xmm1	# _75, _75
	call	fmaxf@PLT	#
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:10:     const float scale=fmaxf(fabsf(*x),fmaxf(fabsf(*y),fabsf(*z)));
	movss	8(%rsp), %xmm1	# %sfp, tmp223
	movss	.LC7(%rip), %xmm2	#, tmp172
	andps	%xmm2, %xmm1	# tmp172, tmp223
	call	fmaxf@PLT	#
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:11:     if(!(scale>0)||!isfinite(scale))return false;
	pxor	%xmm1, %xmm1	# tmp177
	movss	12(%rsp), %xmm3	# %sfp, z
	movss	16(%rsp), %xmm4	# %sfp, y
	comiss	%xmm1, %xmm0	# tmp177, scale
	jbe	.L11	#,
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:11:     if(!(scale>0)||!isfinite(scale))return false;
	movss	.LC8(%rip), %xmm1	#, tmp178
	ucomiss	%xmm0, %xmm1	# scale, tmp178
	jnb	.L23	#,
.L11:
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	movaps	%xmm4, %xmm0	# y, _45
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	movss	8(%rsp), %xmm2	# %sfp, _42
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	pxor	%xmm1, %xmm1	#
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	movss	%xmm4, 24(%rsp)	# y, %sfp
	mulss	4(%r15), %xmm0	# basis_12(D)->ly, _45
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	movss	%xmm3, 20(%rsp)	# z, %sfp
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	mulss	(%r15), %xmm2	# basis_12(D)->lx, _42
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	addss	%xmm0, %xmm2	# _45, _46
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	movaps	%xmm3, %xmm0	# z, _49
	mulss	8(%r15), %xmm0	# basis_12(D)->lz, _49
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	addss	%xmm0, %xmm2	# _49, dot
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	movaps	%xmm2, %xmm0	# dot,
	movss	%xmm2, 16(%rsp)	# dot, %sfp
	call	fmaxf@PLT	#
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	movss	16(%rsp), %xmm2	# %sfp, dot
	pxor	%xmm1, %xmm1	#
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	movss	%xmm0, 12(%rsp)	# tmp213, %sfp
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	movaps	%xmm2, %xmm0	# dot, dot
	xorps	.LC9(%rip), %xmm0	#, dot
	call	fmaxf@PLT	#
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	cmpb	$0, 24(%r15)	#, basis_12(D)->half
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:42:     const float spec=front>0&&nh>0?powf(nh,m[3]):0,thin=1-thickness*(1.0f/255);
	pxor	%xmm2, %xmm2	# iftmp.7_66
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:40:     const float dot=x*basis->lx+y*basis->ly+z*basis->lz,front=fmaxf(0,dot),back=fmaxf(0,-dot);
	movss	%xmm0, 16(%rsp)	# tmp214, %sfp
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	je	.L13	#,
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:42:     const float spec=front>0&&nh>0?powf(nh,m[3]):0,thin=1-thickness*(1.0f/255);
	movss	12(%rsp), %xmm6	# %sfp, front
	comiss	%xmm2, %xmm6	# iftmp.7_66, front
	jbe	.L13	#,
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	movss	8(%rsp), %xmm0	# %sfp, x
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	movss	24(%rsp), %xmm4	# %sfp, y
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	movaps	%xmm2, %xmm1	#,
	movss	%xmm2, 28(%rsp)	# iftmp.7_66, %sfp
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	mulss	16(%r15), %xmm4	# basis_12(D)->hy, _58
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	movss	20(%rsp), %xmm3	# %sfp, z
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	mulss	12(%r15), %xmm0	# basis_12(D)->hx, x
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	mulss	20(%r15), %xmm3	# basis_12(D)->hz, _61
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	addss	%xmm4, %xmm0	# _58, _59
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:41:     const float nh=basis->half?fmaxf(0,x*basis->hx+y*basis->hy+z*basis->hz):0;
	addss	%xmm3, %xmm0	# _61, _62
	call	fmaxf@PLT	#
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:42:     const float spec=front>0&&nh>0?powf(nh,m[3]):0,thin=1-thickness*(1.0f/255);
	pxor	%xmm2, %xmm2	# iftmp.7_66
	comiss	%xmm2, %xmm0	# iftmp.7_66, iftmp.3_63
	jbe	.L13	#,
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:42:     const float spec=front>0&&nh>0?powf(nh,m[3]):0,thin=1-thickness*(1.0f/255);
	movss	12(%rbp), %xmm1	# MEM[(const float *)m_11(D) + 12B],
	call	powf@PLT	#
	movaps	%xmm0, %xmm2	# tmp216, iftmp.7_66
.L13:
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:42:     const float spec=front>0&&nh>0?powf(nh,m[3]):0,thin=1-thickness*(1.0f/255);
	movzbl	%bl, %ebx	# thickness, _67
	pxor	%xmm0, %xmm0	# _68
# analysis/typed-stores/shade_pair.c:7:     const uint16_t colors[2]={ayatsuri_shade_from_terms(albedo[0],light,m,&terms),
	movzwl	0(%r13), %edi	# *albedo_14(D), _3
	movq	%rbp, %rdx	# m,
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:42:     const float spec=front>0&&nh>0?powf(nh,m[3]):0,thin=1-thickness*(1.0f/255);
	cvtsi2ssl	%ebx, %xmm0	# _67, _68
	mulss	.LC10(%rip), %xmm0	#, _69
# analysis/typed-stores/shade_pair.c:7:     const uint16_t colors[2]={ayatsuri_shade_from_terms(albedo[0],light,m,&terms),
	movss	16(%rsp), %xmm1	# %sfp,
	movq	%r12, %rsi	# light,
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:42:     const float spec=front>0&&nh>0?powf(nh,m[3]):0,thin=1-thickness*(1.0f/255);
	movss	.LC2(%rip), %xmm3	#, tmp202
# analysis/typed-stores/shade_pair.c:7:     const uint16_t colors[2]={ayatsuri_shade_from_terms(albedo[0],light,m,&terms),
	movss	%xmm2, 8(%rsp)	# iftmp.7_66, %sfp
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:42:     const float spec=front>0&&nh>0?powf(nh,m[3]):0,thin=1-thickness*(1.0f/255);
	subss	%xmm0, %xmm3	# _69, thin
# analysis/typed-stores/shade_pair.c:7:     const uint16_t colors[2]={ayatsuri_shade_from_terms(albedo[0],light,m,&terms),
	movss	12(%rsp), %xmm0	# %sfp,
	movss	%xmm3, 20(%rsp)	# thin, %sfp
	call	ayatsuri_shade_from_terms.isra.0	#
# analysis/typed-stores/shade_pair.c:8:                             ayatsuri_shade_from_terms(albedo[1],light,m,&terms)};
	movzwl	2(%r13), %edi	# MEM[(const uint16_t *)albedo_14(D) + 2B], _6
	movq	%rbp, %rdx	# m,
	movss	20(%rsp), %xmm3	# %sfp, thin
	movss	8(%rsp), %xmm2	# %sfp, iftmp.7_66
	movss	16(%rsp), %xmm1	# %sfp,
	movq	%r12, %rsi	# light,
# analysis/typed-stores/shade_pair.c:7:     const uint16_t colors[2]={ayatsuri_shade_from_terms(albedo[0],light,m,&terms),
	movl	%eax, %ebx	# tmp217, _4
# analysis/typed-stores/shade_pair.c:8:                             ayatsuri_shade_from_terms(albedo[1],light,m,&terms)};
	movss	12(%rsp), %xmm0	# %sfp,
	call	ayatsuri_shade_from_terms.isra.0	#
# analysis/typed-stores/shade_pair.c:10:     out[0]=colors[0];out[1]=colors[1];
	movw	%bx, (%r14)	# _4, *out_18(D)
# analysis/typed-stores/shade_pair.c:10:     out[0]=colors[0];out[1]=colors[1];
	movw	%ax, 2(%r14)	# tmp218, MEM[(uint16_t *)out_18(D) + 2B]
# analysis/typed-stores/shade_pair.c:18: }
	addq	$40, %rsp	#,
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
.L23:
	.cfi_restore_state
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	movss	8(%rsp), %xmm1	# %sfp, x
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	divss	%xmm0, %xmm4	# scale, _82
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	divss	%xmm0, %xmm1	# scale, x
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	movaps	%xmm4, %xmm2	# _82, _88
	mulss	%xmm4, %xmm2	# _82, _88
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:12:     *x/=scale;*y/=scale;*z/=scale;
	divss	%xmm0, %xmm3	# scale, _84
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	movaps	%xmm1, %xmm0	# _80, _86
	mulss	%xmm1, %xmm0	# _80, _86
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	addss	%xmm2, %xmm0	# _88, _89
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	movaps	%xmm3, %xmm2	# _84, _90
	mulss	%xmm3, %xmm2	# _84, _90
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:13:     const float length=sqrtf((*x)*(*x)+(*y)*(*y)+(*z)*(*z));
	addss	%xmm2, %xmm0	# _90, _91
	sqrtss	%xmm0, %xmm0	# _91, length
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	divss	%xmm0, %xmm1	# length, _80
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	divss	%xmm0, %xmm4	# length, y
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	movss	%xmm1, 8(%rsp)	# _80, %sfp
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:14:     *x/=length;*y/=length;*z/=length;
	divss	%xmm0, %xmm3	# length, z
# candidate-typed-stores/main/ayatsuri/ayatsuri_shade.h:15:     return true;
	jmp	.L11	#
	.cfi_endproc
.LFE6:
	.size	shade_pair, .-shade_pair
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC1:
	.long	1023680776
	.align 4
.LC2:
	.long	1065353216
	.align 4
.LC3:
	.long	1106771968
	.align 4
.LC4:
	.long	1015154721
	.align 4
.LC5:
	.long	1115422720
	.align 4
.LC6:
	.long	939524352
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC7:
	.long	2147483647
	.long	0
	.long	0
	.long	0
	.section	.rodata.cst4
	.align 4
.LC8:
	.long	2139095039
	.section	.rodata.cst16
	.align 16
.LC9:
	.long	-2147483648
	.long	0
	.long	0
	.long	0
	.section	.rodata.cst4
	.align 4
.LC10:
	.long	998277249
	.ident	"GCC: (Debian 14.2.0-19) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
