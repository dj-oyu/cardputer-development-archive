
analysis/typed-stores/typed_pair.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <ayatsuri_shade_from_terms.isra.0>:
   0:	41 56                	push   %r14
   2:	89 f8                	mov    %edi,%eax
   4:	49 89 f6             	mov    %rsi,%r14
   7:	41 55                	push   %r13
   9:	66 c1 e8 0b          	shr    $0xb,%ax
   d:	41 54                	push   %r12
   f:	0f b7 c0             	movzwl %ax,%eax
  12:	41 89 fc             	mov    %edi,%r12d
  15:	55                   	push   %rbp
  16:	48 89 d5             	mov    %rdx,%rbp
  19:	53                   	push   %rbx
  1a:	48 83 ec 10          	sub    $0x10,%rsp
  1e:	f3 0f 10 6a 04       	movss  0x4(%rdx),%xmm5
  23:	f3 0f 10 66 18       	movss  0x18(%rsi),%xmm4
  28:	f3 0f 59 5a 10       	mulss  0x10(%rdx),%xmm3
  2d:	f3 0f 10 3a          	movss  (%rdx),%xmm7
  31:	f3 0f 59 e8          	mulss  %xmm0,%xmm5
  35:	f3 0f 10 72 08       	movss  0x8(%rdx),%xmm6
  3a:	f3 0f 11 3c 24       	movss  %xmm7,(%rsp)
  3f:	f3 0f 59 f2          	mulss  %xmm2,%xmm6
  43:	f3 0f 59 d9          	mulss  %xmm1,%xmm3
  47:	66 0f ef c9          	pxor   %xmm1,%xmm1
  4b:	f3 0f 11 6c 24 04    	movss  %xmm5,0x4(%rsp)
  51:	f3 0f 59 ec          	mulss  %xmm4,%xmm5
  55:	f3 0f 2a c8          	cvtsi2ss %eax,%xmm1
  59:	f3 0f 59 0d 00 00 00 	mulss  0x0(%rip),%xmm1        # 61 <ayatsuri_shade_from_terms.isra.0+0x61>
  60:	00 
			5d: R_X86_64_PC32	.LC1-0x4
  61:	f3 0f 11 74 24 08    	movss  %xmm6,0x8(%rsp)
  67:	0f 28 c5             	movaps %xmm5,%xmm0
  6a:	f3 0f 58 c7          	addss  %xmm7,%xmm0
  6e:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
  72:	f3 0f 10 42 14       	movss  0x14(%rdx),%xmm0
  77:	f3 0f 59 c3          	mulss  %xmm3,%xmm0
  7b:	f3 0f 58 c6          	addss  %xmm6,%xmm0
  7f:	f3 0f 59 c4          	mulss  %xmm4,%xmm0
  83:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  87:	66 0f ef c0          	pxor   %xmm0,%xmm0
  8b:	0f 2f c1             	comiss %xmm1,%xmm0
  8e:	77 21                	ja     b1 <ayatsuri_shade_from_terms.isra.0+0xb1>
  90:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 98 <ayatsuri_shade_from_terms.isra.0+0x98>
  97:	00 
			94: R_X86_64_PC32	.LC2-0x4
  98:	0f 28 c2             	movaps %xmm2,%xmm0
  9b:	f3 0f c2 c1 01       	cmpltss %xmm1,%xmm0
  a0:	0f 54 d0             	andps  %xmm0,%xmm2
  a3:	0f 55 c1             	andnps %xmm1,%xmm0
  a6:	0f 56 c2             	orps   %xmm2,%xmm0
  a9:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # b1 <ayatsuri_shade_from_terms.isra.0+0xb1>
  b0:	00 
			ad: R_X86_64_PC32	.LC3-0x4
  b1:	f3 0f 11 5c 24 0c    	movss  %xmm3,0xc(%rsp)
  b7:	e8 00 00 00 00       	call   bc <ayatsuri_shade_from_terms.isra.0+0xbc>
			b8: R_X86_64_PLT32	lroundf-0x4
  bc:	f3 41 0f 10 56 1c    	movss  0x1c(%r14),%xmm2
  c2:	66 0f ef c9          	pxor   %xmm1,%xmm1
  c6:	f3 0f 10 44 24 04    	movss  0x4(%rsp),%xmm0
  cc:	48 89 c3             	mov    %rax,%rbx
  cf:	44 89 e0             	mov    %r12d,%eax
  d2:	f3 0f 10 5c 24 0c    	movss  0xc(%rsp),%xmm3
  d8:	f3 0f 59 c2          	mulss  %xmm2,%xmm0
  dc:	66 c1 e8 05          	shr    $0x5,%ax
  e0:	83 e0 3f             	and    $0x3f,%eax
  e3:	f3 0f 58 04 24       	addss  (%rsp),%xmm0
  e8:	f3 0f 2a c8          	cvtsi2ss %eax,%xmm1
  ec:	f3 0f 59 0d 00 00 00 	mulss  0x0(%rip),%xmm1        # f4 <ayatsuri_shade_from_terms.isra.0+0xf4>
  f3:	00 
			f0: R_X86_64_PC32	.LC4-0x4
  f4:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
  f8:	f3 0f 10 45 18       	movss  0x18(%rbp),%xmm0
  fd:	f3 0f 59 c3          	mulss  %xmm3,%xmm0
 101:	f3 0f 58 44 24 08    	addss  0x8(%rsp),%xmm0
 107:	f3 0f 59 c2          	mulss  %xmm2,%xmm0
 10b:	f3 0f 58 c8          	addss  %xmm0,%xmm1
 10f:	66 0f ef c0          	pxor   %xmm0,%xmm0
 113:	0f 2f c1             	comiss %xmm1,%xmm0
 116:	77 21                	ja     139 <ayatsuri_shade_from_terms.isra.0+0x139>
 118:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 120 <ayatsuri_shade_from_terms.isra.0+0x120>
 11f:	00 
			11c: R_X86_64_PC32	.LC2-0x4
 120:	0f 28 c2             	movaps %xmm2,%xmm0
 123:	f3 0f c2 c1 01       	cmpltss %xmm1,%xmm0
 128:	0f 54 d0             	andps  %xmm0,%xmm2
 12b:	0f 55 c1             	andnps %xmm1,%xmm0
 12e:	0f 56 c2             	orps   %xmm2,%xmm0
 131:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 139 <ayatsuri_shade_from_terms.isra.0+0x139>
 138:	00 
			135: R_X86_64_PC32	.LC5-0x4
 139:	f3 0f 11 5c 24 0c    	movss  %xmm3,0xc(%rsp)
 13f:	41 83 e4 1f          	and    $0x1f,%r12d
 143:	e8 00 00 00 00       	call   148 <ayatsuri_shade_from_terms.isra.0+0x148>
			144: R_X86_64_PLT32	lroundf-0x4
 148:	f3 41 0f 10 56 20    	movss  0x20(%r14),%xmm2
 14e:	66 0f ef c9          	pxor   %xmm1,%xmm1
 152:	f3 0f 10 44 24 04    	movss  0x4(%rsp),%xmm0
 158:	f3 41 0f 2a cc       	cvtsi2ss %r12d,%xmm1
 15d:	f3 0f 59 0d 00 00 00 	mulss  0x0(%rip),%xmm1        # 165 <ayatsuri_shade_from_terms.isra.0+0x165>
 164:	00 
			161: R_X86_64_PC32	.LC1-0x4
 165:	f3 0f 10 5c 24 0c    	movss  0xc(%rsp),%xmm3
 16b:	49 89 c5             	mov    %rax,%r13
 16e:	f3 0f 59 c2          	mulss  %xmm2,%xmm0
 172:	f3 0f 59 5d 1c       	mulss  0x1c(%rbp),%xmm3
 177:	f3 0f 58 04 24       	addss  (%rsp),%xmm0
 17c:	f3 0f 58 5c 24 08    	addss  0x8(%rsp),%xmm3
 182:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
 186:	66 0f ef c0          	pxor   %xmm0,%xmm0
 18a:	f3 0f 59 da          	mulss  %xmm2,%xmm3
 18e:	f3 0f 58 cb          	addss  %xmm3,%xmm1
 192:	0f 2f c1             	comiss %xmm1,%xmm0
 195:	77 21                	ja     1b8 <ayatsuri_shade_from_terms.isra.0+0x1b8>
 197:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 19f <ayatsuri_shade_from_terms.isra.0+0x19f>
 19e:	00 
			19b: R_X86_64_PC32	.LC2-0x4
 19f:	0f 28 c2             	movaps %xmm2,%xmm0
 1a2:	f3 0f c2 c1 01       	cmpltss %xmm1,%xmm0
 1a7:	0f 54 d0             	andps  %xmm0,%xmm2
 1aa:	0f 55 c1             	andnps %xmm1,%xmm0
 1ad:	0f 56 c2             	orps   %xmm2,%xmm0
 1b0:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 1b8 <ayatsuri_shade_from_terms.isra.0+0x1b8>
 1b7:	00 
			1b4: R_X86_64_PC32	.LC3-0x4
 1b8:	e8 00 00 00 00       	call   1bd <ayatsuri_shade_from_terms.isra.0+0x1bd>
			1b9: R_X86_64_PLT32	lroundf-0x4
 1bd:	41 c1 e5 05          	shl    $0x5,%r13d
 1c1:	c1 e3 0b             	shl    $0xb,%ebx
 1c4:	48 83 c4 10          	add    $0x10,%rsp
 1c8:	44 09 eb             	or     %r13d,%ebx
 1cb:	09 d8                	or     %ebx,%eax
 1cd:	5b                   	pop    %rbx
 1ce:	5d                   	pop    %rbp
 1cf:	41 5c                	pop    %r12
 1d1:	41 5d                	pop    %r13
 1d3:	41 5e                	pop    %r14
 1d5:	c3                   	ret
 1d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 1dd:	00 00 00 

00000000000001e0 <shade_pair>:
 1e0:	41 57                	push   %r15
 1e2:	66 0f ef c9          	pxor   %xmm1,%xmm1
 1e6:	66 0f ef e4          	pxor   %xmm4,%xmm4
 1ea:	66 0f ef db          	pxor   %xmm3,%xmm3
 1ee:	41 56                	push   %r14
 1f0:	4d 89 cf             	mov    %r9,%r15
 1f3:	41 55                	push   %r13
 1f5:	49 89 f5             	mov    %rsi,%r13
 1f8:	41 54                	push   %r12
 1fa:	49 89 cc             	mov    %rcx,%r12
 1fd:	55                   	push   %rbp
 1fe:	4c 89 c5             	mov    %r8,%rbp
 201:	53                   	push   %rbx
 202:	89 d3                	mov    %edx,%ebx
 204:	48 83 ec 28          	sub    $0x28,%rsp
 208:	0f bf 17             	movswl (%rdi),%edx
 20b:	0f bf 47 04          	movswl 0x4(%rdi),%eax
 20f:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 217 <shade_pair+0x37>
 216:	00 
			213: R_X86_64_PC32	.LC6-0x4
 217:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 21f <shade_pair+0x3f>
 21e:	00 
			21b: R_X86_64_PC32	.LC7-0x4
 21f:	4c 8b 74 24 60       	mov    0x60(%rsp),%r14
 224:	f3 0f 2a ca          	cvtsi2ss %edx,%xmm1
 228:	0f bf 57 02          	movswl 0x2(%rdi),%edx
 22c:	f3 0f 2a d8          	cvtsi2ss %eax,%xmm3
 230:	f3 0f 2a e2          	cvtsi2ss %edx,%xmm4
 234:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
 238:	f3 0f 59 d8          	mulss  %xmm0,%xmm3
 23c:	f3 0f 59 e0          	mulss  %xmm0,%xmm4
 240:	f3 0f 11 4c 24 08    	movss  %xmm1,0x8(%rsp)
 246:	0f 28 c3             	movaps %xmm3,%xmm0
 249:	f3 0f 11 5c 24 0c    	movss  %xmm3,0xc(%rsp)
 24f:	0f 28 ec             	movaps %xmm4,%xmm5
 252:	0f 54 c2             	andps  %xmm2,%xmm0
 255:	f3 0f 11 64 24 10    	movss  %xmm4,0x10(%rsp)
 25b:	0f 54 ea             	andps  %xmm2,%xmm5
 25e:	0f 28 cd             	movaps %xmm5,%xmm1
 261:	e8 00 00 00 00       	call   266 <shade_pair+0x86>
			262: R_X86_64_PLT32	fmaxf-0x4
 266:	f3 0f 10 4c 24 08    	movss  0x8(%rsp),%xmm1
 26c:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 274 <shade_pair+0x94>
 273:	00 
			270: R_X86_64_PC32	.LC7-0x4
 274:	0f 54 ca             	andps  %xmm2,%xmm1
 277:	e8 00 00 00 00       	call   27c <shade_pair+0x9c>
			278: R_X86_64_PLT32	fmaxf-0x4
 27c:	66 0f ef c9          	pxor   %xmm1,%xmm1
 280:	f3 0f 10 5c 24 0c    	movss  0xc(%rsp),%xmm3
 286:	f3 0f 10 64 24 10    	movss  0x10(%rsp),%xmm4
 28c:	0f 2f c1             	comiss %xmm1,%xmm0
 28f:	76 11                	jbe    2a2 <shade_pair+0xc2>
 291:	f3 0f 10 0d 00 00 00 	movss  0x0(%rip),%xmm1        # 299 <shade_pair+0xb9>
 298:	00 
			295: R_X86_64_PC32	.LC8-0x4
 299:	0f 2e c8             	ucomiss %xmm0,%xmm1
 29c:	0f 83 5e 01 00 00    	jae    400 <shade_pair+0x220>
 2a2:	0f 28 c4             	movaps %xmm4,%xmm0
 2a5:	f3 0f 10 54 24 08    	movss  0x8(%rsp),%xmm2
 2ab:	66 0f ef c9          	pxor   %xmm1,%xmm1
 2af:	f3 0f 11 64 24 18    	movss  %xmm4,0x18(%rsp)
 2b5:	f3 41 0f 59 47 04    	mulss  0x4(%r15),%xmm0
 2bb:	f3 0f 11 5c 24 14    	movss  %xmm3,0x14(%rsp)
 2c1:	f3 41 0f 59 17       	mulss  (%r15),%xmm2
 2c6:	f3 0f 58 d0          	addss  %xmm0,%xmm2
 2ca:	0f 28 c3             	movaps %xmm3,%xmm0
 2cd:	f3 41 0f 59 47 08    	mulss  0x8(%r15),%xmm0
 2d3:	f3 0f 58 d0          	addss  %xmm0,%xmm2
 2d7:	0f 28 c2             	movaps %xmm2,%xmm0
 2da:	f3 0f 11 54 24 10    	movss  %xmm2,0x10(%rsp)
 2e0:	e8 00 00 00 00       	call   2e5 <shade_pair+0x105>
			2e1: R_X86_64_PLT32	fmaxf-0x4
 2e5:	f3 0f 10 54 24 10    	movss  0x10(%rsp),%xmm2
 2eb:	66 0f ef c9          	pxor   %xmm1,%xmm1
 2ef:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
 2f5:	0f 28 c2             	movaps %xmm2,%xmm0
 2f8:	0f 57 05 00 00 00 00 	xorps  0x0(%rip),%xmm0        # 2ff <shade_pair+0x11f>
			2fb: R_X86_64_PC32	.LC9-0x4
 2ff:	e8 00 00 00 00       	call   304 <shade_pair+0x124>
			300: R_X86_64_PLT32	fmaxf-0x4
 304:	41 80 7f 18 00       	cmpb   $0x0,0x18(%r15)
 309:	66 0f ef d2          	pxor   %xmm2,%xmm2
 30d:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
 313:	74 5b                	je     370 <shade_pair+0x190>
 315:	f3 0f 10 74 24 0c    	movss  0xc(%rsp),%xmm6
 31b:	0f 2f f2             	comiss %xmm2,%xmm6
 31e:	76 50                	jbe    370 <shade_pair+0x190>
 320:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
 326:	f3 0f 10 64 24 18    	movss  0x18(%rsp),%xmm4
 32c:	0f 28 ca             	movaps %xmm2,%xmm1
 32f:	f3 0f 11 54 24 1c    	movss  %xmm2,0x1c(%rsp)
 335:	f3 41 0f 59 67 10    	mulss  0x10(%r15),%xmm4
 33b:	f3 0f 10 5c 24 14    	movss  0x14(%rsp),%xmm3
 341:	f3 41 0f 59 47 0c    	mulss  0xc(%r15),%xmm0
 347:	f3 41 0f 59 5f 14    	mulss  0x14(%r15),%xmm3
 34d:	f3 0f 58 c4          	addss  %xmm4,%xmm0
 351:	f3 0f 58 c3          	addss  %xmm3,%xmm0
 355:	e8 00 00 00 00       	call   35a <shade_pair+0x17a>
			356: R_X86_64_PLT32	fmaxf-0x4
 35a:	66 0f ef d2          	pxor   %xmm2,%xmm2
 35e:	0f 2f c2             	comiss %xmm2,%xmm0
 361:	76 0d                	jbe    370 <shade_pair+0x190>
 363:	f3 0f 10 4d 0c       	movss  0xc(%rbp),%xmm1
 368:	e8 00 00 00 00       	call   36d <shade_pair+0x18d>
			369: R_X86_64_PLT32	powf-0x4
 36d:	0f 28 d0             	movaps %xmm0,%xmm2
 370:	0f b6 db             	movzbl %bl,%ebx
 373:	66 0f ef c0          	pxor   %xmm0,%xmm0
 377:	41 0f b7 7d 00       	movzwl 0x0(%r13),%edi
 37c:	48 89 ea             	mov    %rbp,%rdx
 37f:	f3 0f 2a c3          	cvtsi2ss %ebx,%xmm0
 383:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 38b <shade_pair+0x1ab>
 38a:	00 
			387: R_X86_64_PC32	.LC10-0x4
 38b:	f3 0f 10 4c 24 10    	movss  0x10(%rsp),%xmm1
 391:	4c 89 e6             	mov    %r12,%rsi
 394:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 39c <shade_pair+0x1bc>
 39b:	00 
			398: R_X86_64_PC32	.LC2-0x4
 39c:	f3 0f 11 54 24 08    	movss  %xmm2,0x8(%rsp)
 3a2:	f3 0f 5c d8          	subss  %xmm0,%xmm3
 3a6:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
 3ac:	f3 0f 11 5c 24 14    	movss  %xmm3,0x14(%rsp)
 3b2:	e8 49 fc ff ff       	call   0 <ayatsuri_shade_from_terms.isra.0>
 3b7:	41 0f b7 7d 02       	movzwl 0x2(%r13),%edi
 3bc:	48 89 ea             	mov    %rbp,%rdx
 3bf:	f3 0f 10 5c 24 14    	movss  0x14(%rsp),%xmm3
 3c5:	f3 0f 10 54 24 08    	movss  0x8(%rsp),%xmm2
 3cb:	f3 0f 10 4c 24 10    	movss  0x10(%rsp),%xmm1
 3d1:	4c 89 e6             	mov    %r12,%rsi
 3d4:	89 c3                	mov    %eax,%ebx
 3d6:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
 3dc:	e8 1f fc ff ff       	call   0 <ayatsuri_shade_from_terms.isra.0>
 3e1:	66 41 89 1e          	mov    %bx,(%r14)
 3e5:	66 41 89 46 02       	mov    %ax,0x2(%r14)
 3ea:	48 83 c4 28          	add    $0x28,%rsp
 3ee:	5b                   	pop    %rbx
 3ef:	5d                   	pop    %rbp
 3f0:	41 5c                	pop    %r12
 3f2:	41 5d                	pop    %r13
 3f4:	41 5e                	pop    %r14
 3f6:	41 5f                	pop    %r15
 3f8:	c3                   	ret
 3f9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 400:	f3 0f 10 4c 24 08    	movss  0x8(%rsp),%xmm1
 406:	f3 0f 5e e0          	divss  %xmm0,%xmm4
 40a:	f3 0f 5e c8          	divss  %xmm0,%xmm1
 40e:	0f 28 d4             	movaps %xmm4,%xmm2
 411:	f3 0f 59 d4          	mulss  %xmm4,%xmm2
 415:	f3 0f 5e d8          	divss  %xmm0,%xmm3
 419:	0f 28 c1             	movaps %xmm1,%xmm0
 41c:	f3 0f 59 c1          	mulss  %xmm1,%xmm0
 420:	f3 0f 58 c2          	addss  %xmm2,%xmm0
 424:	0f 28 d3             	movaps %xmm3,%xmm2
 427:	f3 0f 59 d3          	mulss  %xmm3,%xmm2
 42b:	f3 0f 58 c2          	addss  %xmm2,%xmm0
 42f:	f3 0f 51 c0          	sqrtss %xmm0,%xmm0
 433:	f3 0f 5e c8          	divss  %xmm0,%xmm1
 437:	f3 0f 5e e0          	divss  %xmm0,%xmm4
 43b:	f3 0f 11 4c 24 08    	movss  %xmm1,0x8(%rsp)
 441:	f3 0f 5e d8          	divss  %xmm0,%xmm3
 445:	e9 58 fe ff ff       	jmp    2a2 <shade_pair+0xc2>
