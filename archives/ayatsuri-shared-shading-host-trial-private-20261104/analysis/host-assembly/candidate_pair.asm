
analysis/host-assembly/candidate_pair.o:     file format elf64-x86-64


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
 1e2:	66 0f ef c0          	pxor   %xmm0,%xmm0
 1e6:	66 0f ef db          	pxor   %xmm3,%xmm3
 1ea:	66 0f ef e4          	pxor   %xmm4,%xmm4
 1ee:	41 56                	push   %r14
 1f0:	4d 89 ce             	mov    %r9,%r14
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
 20f:	f3 0f 10 0d 00 00 00 	movss  0x0(%rip),%xmm1        # 217 <shade_pair+0x37>
 216:	00 
			213: R_X86_64_PC32	.LC6-0x4
 217:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 21f <shade_pair+0x3f>
 21e:	00 
			21b: R_X86_64_PC32	.LC7-0x4
 21f:	f3 0f 2a c2          	cvtsi2ss %edx,%xmm0
 223:	0f bf 57 02          	movswl 0x2(%rdi),%edx
 227:	f3 0f 2a d8          	cvtsi2ss %eax,%xmm3
 22b:	f3 0f 2a e2          	cvtsi2ss %edx,%xmm4
 22f:	f3 0f 59 c1          	mulss  %xmm1,%xmm0
 233:	f3 0f 59 d9          	mulss  %xmm1,%xmm3
 237:	f3 0f 59 e1          	mulss  %xmm1,%xmm4
 23b:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
 241:	0f 28 eb             	movaps %xmm3,%xmm5
 244:	f3 0f 11 5c 24 10    	movss  %xmm3,0x10(%rsp)
 24a:	0f 28 cc             	movaps %xmm4,%xmm1
 24d:	0f 54 ea             	andps  %xmm2,%xmm5
 250:	f3 0f 11 64 24 14    	movss  %xmm4,0x14(%rsp)
 256:	0f 54 ca             	andps  %xmm2,%xmm1
 259:	0f 28 c5             	movaps %xmm5,%xmm0
 25c:	e8 00 00 00 00       	call   261 <shade_pair+0x81>
			25d: R_X86_64_PLT32	fmaxf-0x4
 261:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
 267:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 26f <shade_pair+0x8f>
 26e:	00 
			26b: R_X86_64_PC32	.LC7-0x4
 26f:	0f 54 ca             	andps  %xmm2,%xmm1
 272:	e8 00 00 00 00       	call   277 <shade_pair+0x97>
			273: R_X86_64_PLT32	fmaxf-0x4
 277:	66 0f ef c9          	pxor   %xmm1,%xmm1
 27b:	f3 0f 10 5c 24 10    	movss  0x10(%rsp),%xmm3
 281:	f3 0f 10 64 24 14    	movss  0x14(%rsp),%xmm4
 287:	0f 2f c1             	comiss %xmm1,%xmm0
 28a:	76 11                	jbe    29d <shade_pair+0xbd>
 28c:	f3 0f 10 0d 00 00 00 	movss  0x0(%rip),%xmm1        # 294 <shade_pair+0xb4>
 293:	00 
			290: R_X86_64_PC32	.LC8-0x4
 294:	0f 2e c8             	ucomiss %xmm0,%xmm1
 297:	0f 83 5b 01 00 00    	jae    3f8 <shade_pair+0x218>
 29d:	0f 28 c4             	movaps %xmm4,%xmm0
 2a0:	f3 0f 10 54 24 0c    	movss  0xc(%rsp),%xmm2
 2a6:	66 0f ef c9          	pxor   %xmm1,%xmm1
 2aa:	f3 0f 11 64 24 18    	movss  %xmm4,0x18(%rsp)
 2b0:	f3 41 0f 59 46 04    	mulss  0x4(%r14),%xmm0
 2b6:	f3 0f 11 5c 24 14    	movss  %xmm3,0x14(%rsp)
 2bc:	f3 41 0f 59 16       	mulss  (%r14),%xmm2
 2c1:	f3 0f 58 d0          	addss  %xmm0,%xmm2
 2c5:	0f 28 c3             	movaps %xmm3,%xmm0
 2c8:	f3 41 0f 59 46 08    	mulss  0x8(%r14),%xmm0
 2ce:	f3 0f 58 d0          	addss  %xmm0,%xmm2
 2d2:	0f 28 c2             	movaps %xmm2,%xmm0
 2d5:	f3 0f 11 54 24 10    	movss  %xmm2,0x10(%rsp)
 2db:	e8 00 00 00 00       	call   2e0 <shade_pair+0x100>
			2dc: R_X86_64_PLT32	fmaxf-0x4
 2e0:	f3 0f 10 54 24 10    	movss  0x10(%rsp),%xmm2
 2e6:	66 0f ef c9          	pxor   %xmm1,%xmm1
 2ea:	66 41 0f 7e c7       	movd   %xmm0,%r15d
 2ef:	0f 28 c2             	movaps %xmm2,%xmm0
 2f2:	0f 57 05 00 00 00 00 	xorps  0x0(%rip),%xmm0        # 2f9 <shade_pair+0x119>
			2f5: R_X86_64_PC32	.LC9-0x4
 2f9:	e8 00 00 00 00       	call   2fe <shade_pair+0x11e>
			2fa: R_X86_64_PLT32	fmaxf-0x4
 2fe:	41 80 7e 18 00       	cmpb   $0x0,0x18(%r14)
 303:	66 0f ef d2          	pxor   %xmm2,%xmm2
 307:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
 30d:	74 5a                	je     369 <shade_pair+0x189>
 30f:	66 41 0f 6e f7       	movd   %r15d,%xmm6
 314:	0f 2f f2             	comiss %xmm2,%xmm6
 317:	76 50                	jbe    369 <shade_pair+0x189>
 319:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
 31f:	f3 0f 10 64 24 18    	movss  0x18(%rsp),%xmm4
 325:	0f 28 ca             	movaps %xmm2,%xmm1
 328:	f3 0f 11 54 24 1c    	movss  %xmm2,0x1c(%rsp)
 32e:	f3 41 0f 59 66 10    	mulss  0x10(%r14),%xmm4
 334:	f3 0f 10 5c 24 14    	movss  0x14(%rsp),%xmm3
 33a:	f3 41 0f 59 46 0c    	mulss  0xc(%r14),%xmm0
 340:	f3 41 0f 59 5e 14    	mulss  0x14(%r14),%xmm3
 346:	f3 0f 58 c4          	addss  %xmm4,%xmm0
 34a:	f3 0f 58 c3          	addss  %xmm3,%xmm0
 34e:	e8 00 00 00 00       	call   353 <shade_pair+0x173>
			34f: R_X86_64_PLT32	fmaxf-0x4
 353:	66 0f ef d2          	pxor   %xmm2,%xmm2
 357:	0f 2f c2             	comiss %xmm2,%xmm0
 35a:	76 0d                	jbe    369 <shade_pair+0x189>
 35c:	f3 0f 10 4d 0c       	movss  0xc(%rbp),%xmm1
 361:	e8 00 00 00 00       	call   366 <shade_pair+0x186>
			362: R_X86_64_PLT32	powf-0x4
 366:	0f 28 d0             	movaps %xmm0,%xmm2
 369:	0f b6 db             	movzbl %bl,%ebx
 36c:	66 0f ef c0          	pxor   %xmm0,%xmm0
 370:	41 0f b7 7d 00       	movzwl 0x0(%r13),%edi
 375:	48 89 ea             	mov    %rbp,%rdx
 378:	f3 0f 2a c3          	cvtsi2ss %ebx,%xmm0
 37c:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 384 <shade_pair+0x1a4>
 383:	00 
			380: R_X86_64_PC32	.LC10-0x4
 384:	f3 0f 10 4c 24 10    	movss  0x10(%rsp),%xmm1
 38a:	4c 89 e6             	mov    %r12,%rsi
 38d:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 395 <shade_pair+0x1b5>
 394:	00 
			391: R_X86_64_PC32	.LC2-0x4
 395:	f3 0f 11 54 24 0c    	movss  %xmm2,0xc(%rsp)
 39b:	f3 0f 5c d8          	subss  %xmm0,%xmm3
 39f:	66 41 0f 6e c7       	movd   %r15d,%xmm0
 3a4:	f3 0f 11 5c 24 14    	movss  %xmm3,0x14(%rsp)
 3aa:	e8 51 fc ff ff       	call   0 <ayatsuri_shade_from_terms.isra.0>
 3af:	41 0f b7 7d 02       	movzwl 0x2(%r13),%edi
 3b4:	66 41 0f 6e c7       	movd   %r15d,%xmm0
 3b9:	f3 0f 10 5c 24 14    	movss  0x14(%rsp),%xmm3
 3bf:	f3 0f 10 54 24 0c    	movss  0xc(%rsp),%xmm2
 3c5:	48 89 ea             	mov    %rbp,%rdx
 3c8:	4c 89 e6             	mov    %r12,%rsi
 3cb:	0f b7 d8             	movzwl %ax,%ebx
 3ce:	f3 0f 10 4c 24 10    	movss  0x10(%rsp),%xmm1
 3d4:	e8 27 fc ff ff       	call   0 <ayatsuri_shade_from_terms.isra.0>
 3d9:	c1 e0 10             	shl    $0x10,%eax
 3dc:	09 c3                	or     %eax,%ebx
 3de:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
 3e3:	89 18                	mov    %ebx,(%rax)
 3e5:	48 83 c4 28          	add    $0x28,%rsp
 3e9:	5b                   	pop    %rbx
 3ea:	5d                   	pop    %rbp
 3eb:	41 5c                	pop    %r12
 3ed:	41 5d                	pop    %r13
 3ef:	41 5e                	pop    %r14
 3f1:	41 5f                	pop    %r15
 3f3:	c3                   	ret
 3f4:	0f 1f 40 00          	nopl   0x0(%rax)
 3f8:	f3 0f 10 54 24 0c    	movss  0xc(%rsp),%xmm2
 3fe:	f3 0f 5e e0          	divss  %xmm0,%xmm4
 402:	f3 0f 5e d0          	divss  %xmm0,%xmm2
 406:	f3 0f 5e d8          	divss  %xmm0,%xmm3
 40a:	0f 28 c4             	movaps %xmm4,%xmm0
 40d:	f3 0f 59 c4          	mulss  %xmm4,%xmm0
 411:	0f 28 ca             	movaps %xmm2,%xmm1
 414:	f3 0f 59 ca          	mulss  %xmm2,%xmm1
 418:	f3 0f 58 c8          	addss  %xmm0,%xmm1
 41c:	0f 28 c3             	movaps %xmm3,%xmm0
 41f:	f3 0f 59 c3          	mulss  %xmm3,%xmm0
 423:	f3 0f 58 c8          	addss  %xmm0,%xmm1
 427:	f3 0f 51 c9          	sqrtss %xmm1,%xmm1
 42b:	f3 0f 5e d1          	divss  %xmm1,%xmm2
 42f:	f3 0f 5e e1          	divss  %xmm1,%xmm4
 433:	f3 0f 11 54 24 0c    	movss  %xmm2,0xc(%rsp)
 439:	f3 0f 5e d9          	divss  %xmm1,%xmm3
 43d:	e9 5b fe ff ff       	jmp    29d <shade_pair+0xbd>
