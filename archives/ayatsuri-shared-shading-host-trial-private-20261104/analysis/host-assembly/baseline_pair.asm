
analysis/host-assembly/baseline_pair.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <ayatsuri_shade_sample>:
   0:	41 57                	push   %r15
   2:	66 0f ef c0          	pxor   %xmm0,%xmm0
   6:	66 0f ef e4          	pxor   %xmm4,%xmm4
   a:	66 0f ef db          	pxor   %xmm3,%xmm3
   e:	41 56                	push   %r14
  10:	41 89 d6             	mov    %edx,%r14d
  13:	4d 89 cf             	mov    %r9,%r15
  16:	41 55                	push   %r13
  18:	49 89 cd             	mov    %rcx,%r13
  1b:	41 54                	push   %r12
  1d:	41 89 f4             	mov    %esi,%r12d
  20:	55                   	push   %rbp
  21:	53                   	push   %rbx
  22:	4c 89 c3             	mov    %r8,%rbx
  25:	48 83 ec 28          	sub    $0x28,%rsp
  29:	0f bf 17             	movswl (%rdi),%edx
  2c:	0f bf 47 04          	movswl 0x4(%rdi),%eax
  30:	f3 0f 10 0d 00 00 00 	movss  0x0(%rip),%xmm1        # 38 <ayatsuri_shade_sample+0x38>
  37:	00 
			34: R_X86_64_PC32	.LC1-0x4
  38:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 40 <ayatsuri_shade_sample+0x40>
  3f:	00 
			3c: R_X86_64_PC32	.LC2-0x4
  40:	f3 0f 2a c2          	cvtsi2ss %edx,%xmm0
  44:	0f bf 57 02          	movswl 0x2(%rdi),%edx
  48:	f3 0f 2a d8          	cvtsi2ss %eax,%xmm3
  4c:	f3 0f 2a e2          	cvtsi2ss %edx,%xmm4
  50:	f3 0f 59 c1          	mulss  %xmm1,%xmm0
  54:	f3 0f 59 d9          	mulss  %xmm1,%xmm3
  58:	f3 0f 59 e1          	mulss  %xmm1,%xmm4
  5c:	66 0f 7e c5          	movd   %xmm0,%ebp
  60:	0f 28 c3             	movaps %xmm3,%xmm0
  63:	f3 0f 11 5c 24 0c    	movss  %xmm3,0xc(%rsp)
  69:	0f 28 cc             	movaps %xmm4,%xmm1
  6c:	0f 54 c2             	andps  %xmm2,%xmm0
  6f:	f3 0f 11 64 24 10    	movss  %xmm4,0x10(%rsp)
  75:	0f 54 ca             	andps  %xmm2,%xmm1
  78:	e8 00 00 00 00       	call   7d <ayatsuri_shade_sample+0x7d>
			79: R_X86_64_PLT32	fmaxf-0x4
  7d:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 85 <ayatsuri_shade_sample+0x85>
  84:	00 
			81: R_X86_64_PC32	.LC2-0x4
  85:	66 0f 6e cd          	movd   %ebp,%xmm1
  89:	0f 54 ca             	andps  %xmm2,%xmm1
  8c:	e8 00 00 00 00       	call   91 <ayatsuri_shade_sample+0x91>
			8d: R_X86_64_PLT32	fmaxf-0x4
  91:	66 0f ef c9          	pxor   %xmm1,%xmm1
  95:	f3 0f 10 5c 24 0c    	movss  0xc(%rsp),%xmm3
  9b:	f3 0f 10 64 24 10    	movss  0x10(%rsp),%xmm4
  a1:	0f 2f c1             	comiss %xmm1,%xmm0
  a4:	76 11                	jbe    b7 <ayatsuri_shade_sample+0xb7>
  a6:	f3 0f 10 0d 00 00 00 	movss  0x0(%rip),%xmm1        # ae <ayatsuri_shade_sample+0xae>
  ad:	00 
			aa: R_X86_64_PC32	.LC3-0x4
  ae:	0f 2e c8             	ucomiss %xmm0,%xmm1
  b1:	0f 83 d9 02 00 00    	jae    390 <ayatsuri_shade_sample+0x390>
  b7:	0f 28 c4             	movaps %xmm4,%xmm0
  ba:	66 0f 6e d5          	movd   %ebp,%xmm2
  be:	66 0f ef c9          	pxor   %xmm1,%xmm1
  c2:	f3 0f 11 64 24 18    	movss  %xmm4,0x18(%rsp)
  c8:	f3 41 0f 59 47 04    	mulss  0x4(%r15),%xmm0
  ce:	f3 0f 11 5c 24 14    	movss  %xmm3,0x14(%rsp)
  d4:	f3 41 0f 59 17       	mulss  (%r15),%xmm2
  d9:	f3 0f 58 d0          	addss  %xmm0,%xmm2
  dd:	0f 28 c3             	movaps %xmm3,%xmm0
  e0:	f3 41 0f 59 47 08    	mulss  0x8(%r15),%xmm0
  e6:	f3 0f 58 d0          	addss  %xmm0,%xmm2
  ea:	0f 28 c2             	movaps %xmm2,%xmm0
  ed:	f3 0f 11 54 24 0c    	movss  %xmm2,0xc(%rsp)
  f3:	e8 00 00 00 00       	call   f8 <ayatsuri_shade_sample+0xf8>
			f4: R_X86_64_PLT32	fmaxf-0x4
  f8:	f3 0f 10 54 24 0c    	movss  0xc(%rsp),%xmm2
  fe:	66 0f ef c9          	pxor   %xmm1,%xmm1
 102:	0f 57 15 00 00 00 00 	xorps  0x0(%rip),%xmm2        # 109 <ayatsuri_shade_sample+0x109>
			105: R_X86_64_PC32	.LC4-0x4
 109:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
 10f:	0f 28 c2             	movaps %xmm2,%xmm0
 112:	e8 00 00 00 00       	call   117 <ayatsuri_shade_sample+0x117>
			113: R_X86_64_PLT32	fmaxf-0x4
 117:	41 80 7f 18 00       	cmpb   $0x0,0x18(%r15)
 11c:	66 0f ef ed          	pxor   %xmm5,%xmm5
 120:	0f 28 d0             	movaps %xmm0,%xmm2
 123:	74 71                	je     196 <ayatsuri_shade_sample+0x196>
 125:	f3 0f 10 74 24 10    	movss  0x10(%rsp),%xmm6
 12b:	0f 2f f5             	comiss %xmm5,%xmm6
 12e:	76 66                	jbe    196 <ayatsuri_shade_sample+0x196>
 130:	f3 0f 11 44 24 1c    	movss  %xmm0,0x1c(%rsp)
 136:	f3 0f 10 64 24 18    	movss  0x18(%rsp),%xmm4
 13c:	66 0f 6e c5          	movd   %ebp,%xmm0
 140:	0f 28 cd             	movaps %xmm5,%xmm1
 143:	f3 41 0f 59 67 10    	mulss  0x10(%r15),%xmm4
 149:	f3 0f 10 5c 24 14    	movss  0x14(%rsp),%xmm3
 14f:	f3 0f 11 6c 24 0c    	movss  %xmm5,0xc(%rsp)
 155:	f3 41 0f 59 47 0c    	mulss  0xc(%r15),%xmm0
 15b:	f3 41 0f 59 5f 14    	mulss  0x14(%r15),%xmm3
 161:	f3 0f 58 c4          	addss  %xmm4,%xmm0
 165:	f3 0f 58 c3          	addss  %xmm3,%xmm0
 169:	e8 00 00 00 00       	call   16e <ayatsuri_shade_sample+0x16e>
			16a: R_X86_64_PLT32	fmaxf-0x4
 16e:	66 0f ef ed          	pxor   %xmm5,%xmm5
 172:	f3 0f 10 54 24 1c    	movss  0x1c(%rsp),%xmm2
 178:	0f 2f c5             	comiss %xmm5,%xmm0
 17b:	76 19                	jbe    196 <ayatsuri_shade_sample+0x196>
 17d:	f3 0f 10 4b 0c       	movss  0xc(%rbx),%xmm1
 182:	f3 0f 11 54 24 0c    	movss  %xmm2,0xc(%rsp)
 188:	e8 00 00 00 00       	call   18d <ayatsuri_shade_sample+0x18d>
			189: R_X86_64_PLT32	powf-0x4
 18d:	f3 0f 10 54 24 0c    	movss  0xc(%rsp),%xmm2
 193:	0f 28 e8             	movaps %xmm0,%xmm5
 196:	45 0f b6 f6          	movzbl %r14b,%r14d
 19a:	66 0f ef c0          	pxor   %xmm0,%xmm0
 19e:	44 89 e0             	mov    %r12d,%eax
 1a1:	f3 0f 10 23          	movss  (%rbx),%xmm4
 1a5:	f3 41 0f 2a c6       	cvtsi2ss %r14d,%xmm0
 1aa:	f3 0f 10 74 24 10    	movss  0x10(%rsp),%xmm6
 1b0:	66 c1 e8 0b          	shr    $0xb,%ax
 1b4:	f3 0f 10 0d 00 00 00 	movss  0x0(%rip),%xmm1        # 1bc <ayatsuri_shade_sample+0x1bc>
 1bb:	00 
			1b8: R_X86_64_PC32	.LC6-0x4
 1bc:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 1c4 <ayatsuri_shade_sample+0x1c4>
 1c3:	00 
			1c0: R_X86_64_PC32	.LC5-0x4
 1c4:	f3 41 0f 10 5d 18    	movss  0x18(%r13),%xmm3
 1ca:	0f b7 c0             	movzwl %ax,%eax
 1cd:	f3 0f 11 64 24 0c    	movss  %xmm4,0xc(%rsp)
 1d3:	f3 0f 59 73 04       	mulss  0x4(%rbx),%xmm6
 1d8:	f3 0f 10 7b 08       	movss  0x8(%rbx),%xmm7
 1dd:	f3 0f 59 fd          	mulss  %xmm5,%xmm7
 1e1:	f3 0f 5c c8          	subss  %xmm0,%xmm1
 1e5:	f3 0f 59 4b 10       	mulss  0x10(%rbx),%xmm1
 1ea:	f3 0f 11 74 24 10    	movss  %xmm6,0x10(%rsp)
 1f0:	f3 0f 59 f3          	mulss  %xmm3,%xmm6
 1f4:	f3 0f 11 7c 24 14    	movss  %xmm7,0x14(%rsp)
 1fa:	f3 0f 59 ca          	mulss  %xmm2,%xmm1
 1fe:	66 0f ef d2          	pxor   %xmm2,%xmm2
 202:	f3 0f 2a d0          	cvtsi2ss %eax,%xmm2
 206:	f3 0f 59 15 00 00 00 	mulss  0x0(%rip),%xmm2        # 20e <ayatsuri_shade_sample+0x20e>
 20d:	00 
			20a: R_X86_64_PC32	.LC7-0x4
 20e:	0f 28 c6             	movaps %xmm6,%xmm0
 211:	f3 0f 58 c4          	addss  %xmm4,%xmm0
 215:	f3 0f 59 d0          	mulss  %xmm0,%xmm2
 219:	f3 0f 10 43 14       	movss  0x14(%rbx),%xmm0
 21e:	f3 0f 59 c1          	mulss  %xmm1,%xmm0
 222:	f3 0f 58 c7          	addss  %xmm7,%xmm0
 226:	f3 0f 59 c3          	mulss  %xmm3,%xmm0
 22a:	f3 0f 58 d0          	addss  %xmm0,%xmm2
 22e:	66 0f ef c0          	pxor   %xmm0,%xmm0
 232:	0f 2f c2             	comiss %xmm2,%xmm0
 235:	77 26                	ja     25d <ayatsuri_shade_sample+0x25d>
 237:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 23f <ayatsuri_shade_sample+0x23f>
 23e:	00 
			23b: R_X86_64_PC32	.LC6-0x4
 23f:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 247 <ayatsuri_shade_sample+0x247>
 246:	00 
			243: R_X86_64_PC32	.LC6-0x4
 247:	f3 0f c2 c2 01       	cmpltss %xmm2,%xmm0
 24c:	0f 54 d8             	andps  %xmm0,%xmm3
 24f:	0f 55 c2             	andnps %xmm2,%xmm0
 252:	0f 56 c3             	orps   %xmm3,%xmm0
 255:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 25d <ayatsuri_shade_sample+0x25d>
 25c:	00 
			259: R_X86_64_PC32	.LC8-0x4
 25d:	f3 0f 11 4c 24 18    	movss  %xmm1,0x18(%rsp)
 263:	e8 00 00 00 00       	call   268 <ayatsuri_shade_sample+0x268>
			264: R_X86_64_PLT32	lroundf-0x4
 268:	f3 41 0f 10 5d 1c    	movss  0x1c(%r13),%xmm3
 26e:	66 0f ef d2          	pxor   %xmm2,%xmm2
 272:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
 278:	48 89 c5             	mov    %rax,%rbp
 27b:	44 89 e0             	mov    %r12d,%eax
 27e:	f3 0f 10 4c 24 18    	movss  0x18(%rsp),%xmm1
 284:	f3 0f 59 c3          	mulss  %xmm3,%xmm0
 288:	66 c1 e8 05          	shr    $0x5,%ax
 28c:	83 e0 3f             	and    $0x3f,%eax
 28f:	f3 0f 58 44 24 0c    	addss  0xc(%rsp),%xmm0
 295:	f3 0f 2a d0          	cvtsi2ss %eax,%xmm2
 299:	f3 0f 59 15 00 00 00 	mulss  0x0(%rip),%xmm2        # 2a1 <ayatsuri_shade_sample+0x2a1>
 2a0:	00 
			29d: R_X86_64_PC32	.LC9-0x4
 2a1:	f3 0f 59 d0          	mulss  %xmm0,%xmm2
 2a5:	f3 0f 10 43 18       	movss  0x18(%rbx),%xmm0
 2aa:	f3 0f 59 c1          	mulss  %xmm1,%xmm0
 2ae:	f3 0f 58 44 24 14    	addss  0x14(%rsp),%xmm0
 2b4:	f3 0f 59 c3          	mulss  %xmm3,%xmm0
 2b8:	f3 0f 58 d0          	addss  %xmm0,%xmm2
 2bc:	66 0f ef c0          	pxor   %xmm0,%xmm0
 2c0:	0f 2f c2             	comiss %xmm2,%xmm0
 2c3:	77 26                	ja     2eb <ayatsuri_shade_sample+0x2eb>
 2c5:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 2cd <ayatsuri_shade_sample+0x2cd>
 2cc:	00 
			2c9: R_X86_64_PC32	.LC6-0x4
 2cd:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 2d5 <ayatsuri_shade_sample+0x2d5>
 2d4:	00 
			2d1: R_X86_64_PC32	.LC6-0x4
 2d5:	f3 0f c2 c2 01       	cmpltss %xmm2,%xmm0
 2da:	0f 54 d8             	andps  %xmm0,%xmm3
 2dd:	0f 55 c2             	andnps %xmm2,%xmm0
 2e0:	0f 56 c3             	orps   %xmm3,%xmm0
 2e3:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 2eb <ayatsuri_shade_sample+0x2eb>
 2ea:	00 
			2e7: R_X86_64_PC32	.LC10-0x4
 2eb:	f3 0f 11 4c 24 18    	movss  %xmm1,0x18(%rsp)
 2f1:	41 83 e4 1f          	and    $0x1f,%r12d
 2f5:	e8 00 00 00 00       	call   2fa <ayatsuri_shade_sample+0x2fa>
			2f6: R_X86_64_PLT32	lroundf-0x4
 2fa:	f3 41 0f 10 5d 20    	movss  0x20(%r13),%xmm3
 300:	66 0f ef c0          	pxor   %xmm0,%xmm0
 304:	f3 0f 10 54 24 10    	movss  0x10(%rsp),%xmm2
 30a:	f3 41 0f 2a c4       	cvtsi2ss %r12d,%xmm0
 30f:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 317 <ayatsuri_shade_sample+0x317>
 316:	00 
			313: R_X86_64_PC32	.LC7-0x4
 317:	f3 0f 10 4c 24 18    	movss  0x18(%rsp),%xmm1
 31d:	49 89 c6             	mov    %rax,%r14
 320:	f3 0f 59 d3          	mulss  %xmm3,%xmm2
 324:	f3 0f 59 4b 1c       	mulss  0x1c(%rbx),%xmm1
 329:	f3 0f 58 54 24 0c    	addss  0xc(%rsp),%xmm2
 32f:	f3 0f 58 4c 24 14    	addss  0x14(%rsp),%xmm1
 335:	f3 0f 59 c2          	mulss  %xmm2,%xmm0
 339:	f3 0f 59 cb          	mulss  %xmm3,%xmm1
 33d:	f3 0f 58 c8          	addss  %xmm0,%xmm1
 341:	66 0f ef c0          	pxor   %xmm0,%xmm0
 345:	0f 2f c1             	comiss %xmm1,%xmm0
 348:	77 26                	ja     370 <ayatsuri_shade_sample+0x370>
 34a:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 352 <ayatsuri_shade_sample+0x352>
 351:	00 
			34e: R_X86_64_PC32	.LC6-0x4
 352:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 35a <ayatsuri_shade_sample+0x35a>
 359:	00 
			356: R_X86_64_PC32	.LC6-0x4
 35a:	f3 0f c2 c1 01       	cmpltss %xmm1,%xmm0
 35f:	0f 54 d0             	andps  %xmm0,%xmm2
 362:	0f 55 c1             	andnps %xmm1,%xmm0
 365:	0f 56 c2             	orps   %xmm2,%xmm0
 368:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 370 <ayatsuri_shade_sample+0x370>
 36f:	00 
			36c: R_X86_64_PC32	.LC8-0x4
 370:	e8 00 00 00 00       	call   375 <ayatsuri_shade_sample+0x375>
			371: R_X86_64_PLT32	lroundf-0x4
 375:	41 c1 e6 05          	shl    $0x5,%r14d
 379:	c1 e5 0b             	shl    $0xb,%ebp
 37c:	48 83 c4 28          	add    $0x28,%rsp
 380:	44 09 f5             	or     %r14d,%ebp
 383:	5b                   	pop    %rbx
 384:	09 e8                	or     %ebp,%eax
 386:	5d                   	pop    %rbp
 387:	41 5c                	pop    %r12
 389:	41 5d                	pop    %r13
 38b:	41 5e                	pop    %r14
 38d:	41 5f                	pop    %r15
 38f:	c3                   	ret
 390:	f3 0f 5e e0          	divss  %xmm0,%xmm4
 394:	66 0f 6e d5          	movd   %ebp,%xmm2
 398:	f3 0f 5e d0          	divss  %xmm0,%xmm2
 39c:	f3 0f 5e d8          	divss  %xmm0,%xmm3
 3a0:	0f 28 c4             	movaps %xmm4,%xmm0
 3a3:	f3 0f 59 c4          	mulss  %xmm4,%xmm0
 3a7:	0f 28 ca             	movaps %xmm2,%xmm1
 3aa:	f3 0f 59 ca          	mulss  %xmm2,%xmm1
 3ae:	f3 0f 58 c8          	addss  %xmm0,%xmm1
 3b2:	0f 28 c3             	movaps %xmm3,%xmm0
 3b5:	f3 0f 59 c3          	mulss  %xmm3,%xmm0
 3b9:	f3 0f 58 c8          	addss  %xmm0,%xmm1
 3bd:	f3 0f 51 c9          	sqrtss %xmm1,%xmm1
 3c1:	f3 0f 5e d1          	divss  %xmm1,%xmm2
 3c5:	f3 0f 5e e1          	divss  %xmm1,%xmm4
 3c9:	66 0f 7e d5          	movd   %xmm2,%ebp
 3cd:	f3 0f 5e d9          	divss  %xmm1,%xmm3
 3d1:	e9 e1 fc ff ff       	jmp    b7 <ayatsuri_shade_sample+0xb7>
 3d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 3dd:	00 00 00 

00000000000003e0 <shade_pair>:
 3e0:	41 57                	push   %r15
 3e2:	49 89 f7             	mov    %rsi,%r15
 3e5:	41 56                	push   %r14
 3e7:	4d 89 ce             	mov    %r9,%r14
 3ea:	41 55                	push   %r13
 3ec:	4d 89 c5             	mov    %r8,%r13
 3ef:	41 54                	push   %r12
 3f1:	49 89 cc             	mov    %rcx,%r12
 3f4:	55                   	push   %rbp
 3f5:	0f b6 ea             	movzbl %dl,%ebp
 3f8:	53                   	push   %rbx
 3f9:	89 ea                	mov    %ebp,%edx
 3fb:	48 89 fb             	mov    %rdi,%rbx
 3fe:	48 83 ec 08          	sub    $0x8,%rsp
 402:	0f b7 36             	movzwl (%rsi),%esi
 405:	e8 f6 fb ff ff       	call   0 <ayatsuri_shade_sample>
 40a:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 40f:	4d 89 f1             	mov    %r14,%r9
 412:	4d 89 e8             	mov    %r13,%r8
 415:	4c 89 e1             	mov    %r12,%rcx
 418:	48 89 df             	mov    %rbx,%rdi
 41b:	66 89 02             	mov    %ax,(%rdx)
 41e:	41 0f b7 77 02       	movzwl 0x2(%r15),%esi
 423:	89 ea                	mov    %ebp,%edx
 425:	e8 d6 fb ff ff       	call   0 <ayatsuri_shade_sample>
 42a:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
 42f:	66 89 43 02          	mov    %ax,0x2(%rbx)
 433:	48 83 c4 08          	add    $0x8,%rsp
 437:	5b                   	pop    %rbx
 438:	5d                   	pop    %rbp
 439:	41 5c                	pop    %r12
 43b:	41 5d                	pop    %r13
 43d:	41 5e                	pop    %r14
 43f:	41 5f                	pop    %r15
 441:	c3                   	ret
