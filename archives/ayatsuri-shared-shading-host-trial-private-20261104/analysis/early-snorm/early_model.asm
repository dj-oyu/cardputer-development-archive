
analysis/early-snorm/early_model.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <md>:
       0:	f2 0f 10 07          	movsd  (%rdi),%xmm0
       4:	c3                   	ret
       5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
       c:	00 00 00 00 

0000000000000010 <float_rows_valid>:
      10:	49 89 f9             	mov    %rdi,%r9
      13:	85 f6                	test   %esi,%esi
      15:	74 5c                	je     73 <float_rows_valid+0x63>
      17:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 1f <float_rows_valid+0xf>
      1e:	00 
			1b: R_X86_64_PC32	.LC1-0x4
      1f:	45 31 d2             	xor    %r10d,%r10d
      22:	45 31 db             	xor    %r11d,%r11d
      25:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 2d <float_rows_valid+0x1d>
      2c:	00 
			29: R_X86_64_PC32	.LC0-0x4
      2d:	66 0f ef e4          	pxor   %xmm4,%xmm4
      31:	42 8d 3c 95 00 00 00 	lea    0x0(,%r10,4),%edi
      38:	00 
      39:	31 c0                	xor    %eax,%eax
      3b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
      40:	41 89 f8             	mov    %edi,%r8d
      43:	f3 43 0f 10 04 01    	movss  (%r9,%r8,1),%xmm0
      49:	0f 28 c8             	movaps %xmm0,%xmm1
      4c:	0f 54 cb             	andps  %xmm3,%xmm1
      4f:	0f 2e d1             	ucomiss %xmm1,%xmm2
      52:	72 2c                	jb     80 <float_rows_valid+0x70>
      54:	39 c8                	cmp    %ecx,%eax
      56:	72 05                	jb     5d <float_rows_valid+0x4d>
      58:	0f 2f c4             	comiss %xmm4,%xmm0
      5b:	76 23                	jbe    80 <float_rows_valid+0x70>
      5d:	83 c0 01             	add    $0x1,%eax
      60:	83 c7 04             	add    $0x4,%edi
      63:	39 c2                	cmp    %eax,%edx
      65:	75 d9                	jne    40 <float_rows_valid+0x30>
      67:	41 83 c3 01          	add    $0x1,%r11d
      6b:	41 01 d2             	add    %edx,%r10d
      6e:	44 39 de             	cmp    %r11d,%esi
      71:	75 be                	jne    31 <float_rows_valid+0x21>
      73:	b8 01 00 00 00       	mov    $0x1,%eax
      78:	c3                   	ret
      79:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
      80:	31 c0                	xor    %eax,%eax
      82:	c3                   	ret
      83:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
      8a:	00 00 00 00 
      8e:	66 90                	xchg   %ax,%ax

0000000000000090 <mesh_project>:
      90:	f3 0f 10 06          	movss  (%rsi),%xmm0
      94:	f3 0f 10 5e 04       	movss  0x4(%rsi),%xmm3
      99:	31 c0                	xor    %eax,%eax
      9b:	f3 0f 10 0f          	movss  (%rdi),%xmm1
      9f:	f3 0f 10 67 04       	movss  0x4(%rdi),%xmm4
      a4:	f3 0f 10 56 08       	movss  0x8(%rsi),%xmm2
      a9:	f3 0f 59 e3          	mulss  %xmm3,%xmm4
      ad:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
      b1:	f3 0f 58 cc          	addss  %xmm4,%xmm1
      b5:	f3 0f 10 67 08       	movss  0x8(%rdi),%xmm4
      ba:	f3 0f 59 e2          	mulss  %xmm2,%xmm4
      be:	f3 0f 58 cc          	addss  %xmm4,%xmm1
      c2:	f3 0f 58 4f 0c       	addss  0xc(%rdi),%xmm1
      c7:	f3 0f 11 0a          	movss  %xmm1,(%rdx)
      cb:	f3 0f 10 4f 10       	movss  0x10(%rdi),%xmm1
      d0:	f3 0f 10 67 14       	movss  0x14(%rdi),%xmm4
      d5:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
      d9:	f3 0f 59 e3          	mulss  %xmm3,%xmm4
      dd:	f3 0f 58 cc          	addss  %xmm4,%xmm1
      e1:	f3 0f 10 67 18       	movss  0x18(%rdi),%xmm4
      e6:	f3 0f 59 e2          	mulss  %xmm2,%xmm4
      ea:	f3 0f 58 cc          	addss  %xmm4,%xmm1
      ee:	f3 0f 58 4f 1c       	addss  0x1c(%rdi),%xmm1
      f3:	f3 0f 11 09          	movss  %xmm1,(%rcx)
      f7:	f3 0f 59 5f 24       	mulss  0x24(%rdi),%xmm3
      fc:	f3 0f 59 47 20       	mulss  0x20(%rdi),%xmm0
     101:	f3 0f 59 57 28       	mulss  0x28(%rdi),%xmm2
     106:	f3 0f 58 c3          	addss  %xmm3,%xmm0
     10a:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 112 <mesh_project+0x82>
     111:	00 
			10e: R_X86_64_PC32	.LC0-0x4
     112:	f3 0f 58 c2          	addss  %xmm2,%xmm0
     116:	f3 0f 58 47 2c       	addss  0x2c(%rdi),%xmm0
     11b:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 123 <mesh_project+0x93>
     122:	00 
			11f: R_X86_64_PC32	.LC1-0x4
     123:	f3 41 0f 11 00       	movss  %xmm0,(%r8)
     128:	f3 0f 10 0a          	movss  (%rdx),%xmm1
     12c:	0f 54 cb             	andps  %xmm3,%xmm1
     12f:	0f 2e d1             	ucomiss %xmm1,%xmm2
     132:	72 27                	jb     15b <mesh_project+0xcb>
     134:	f3 0f 10 21          	movss  (%rcx),%xmm4
     138:	0f 54 e3             	andps  %xmm3,%xmm4
     13b:	0f 2e d4             	ucomiss %xmm4,%xmm2
     13e:	72 1b                	jb     15b <mesh_project+0xcb>
     140:	f3 0f 10 2d 00 00 00 	movss  0x0(%rip),%xmm5        # 148 <mesh_project+0xb8>
     147:	00 
			144: R_X86_64_PC32	.LC3-0x4
     148:	0f 2f e9             	comiss %xmm1,%xmm5
     14b:	72 0e                	jb     15b <mesh_project+0xcb>
     14d:	0f 2f ec             	comiss %xmm4,%xmm5
     150:	72 09                	jb     15b <mesh_project+0xcb>
     152:	0f 54 c3             	andps  %xmm3,%xmm0
     155:	0f 2e d0             	ucomiss %xmm0,%xmm2
     158:	0f 93 c0             	setae  %al
     15b:	c3                   	ret
     15c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000000160 <pack_rgb>:
     160:	89 fa                	mov    %edi,%edx
     162:	66 0f ef c0          	pxor   %xmm0,%xmm0
     166:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 16e <pack_rgb+0xe>
     16d:	00 
			16a: R_X86_64_PC32	.LC4-0x4
     16e:	89 f8                	mov    %edi,%eax
     170:	c1 ea 10             	shr    $0x10,%edx
     173:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 17b <pack_rgb+0x1b>
     17a:	00 
			177: R_X86_64_PC32	.LC5-0x4
     17b:	f2 0f 10 25 00 00 00 	movsd  0x0(%rip),%xmm4        # 183 <pack_rgb+0x23>
     182:	00 
			17f: R_X86_64_PC32	.LC6-0x4
     183:	f2 0f 2a c2          	cvtsi2sd %edx,%xmm0
     187:	f3 0f 7e 1d 00 00 00 	movq   0x0(%rip),%xmm3        # 18f <pack_rgb+0x2f>
     18e:	00 
			18b: R_X86_64_PC32	.LC8-0x4
     18f:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 197 <pack_rgb+0x37>
     196:	00 
			193: R_X86_64_PC32	.LC7-0x4
     197:	66 0f 28 d3          	movapd %xmm3,%xmm2
     19b:	f2 0f 59 c7          	mulsd  %xmm7,%xmm0
     19f:	f2 0f 5e c6          	divsd  %xmm6,%xmm0
     1a3:	f2 0f 58 c4          	addsd  %xmm4,%xmm0
     1a7:	66 0f 28 c8          	movapd %xmm0,%xmm1
     1ab:	66 0f 54 cb          	andpd  %xmm3,%xmm1
     1af:	66 0f 2e e9          	ucomisd %xmm1,%xmm5
     1b3:	76 38                	jbe    1ed <pack_rgb+0x8d>
     1b5:	f2 48 0f 2c d0       	cvttsd2si %xmm0,%rdx
     1ba:	66 0f ef c9          	pxor   %xmm1,%xmm1
     1be:	66 0f 55 d0          	andnpd %xmm0,%xmm2
     1c2:	f2 44 0f 10 0d 00 00 	movsd  0x0(%rip),%xmm9        # 1cb <pack_rgb+0x6b>
     1c9:	00 00 
			1c7: R_X86_64_PC32	.LC9-0x4
     1cb:	f2 48 0f 2a ca       	cvtsi2sd %rdx,%xmm1
     1d0:	66 44 0f 28 c1       	movapd %xmm1,%xmm8
     1d5:	f2 44 0f c2 c0 06    	cmpnlesd %xmm0,%xmm8
     1db:	66 45 0f 54 c1       	andpd  %xmm9,%xmm8
     1e0:	f2 41 0f 5c c8       	subsd  %xmm8,%xmm1
     1e5:	66 0f 28 c1          	movapd %xmm1,%xmm0
     1e9:	66 0f 56 c2          	orpd   %xmm2,%xmm0
     1ed:	0f b6 d4             	movzbl %ah,%edx
     1f0:	66 0f ef c9          	pxor   %xmm1,%xmm1
     1f4:	66 44 0f 28 c3       	movapd %xmm3,%xmm8
     1f9:	f2 0f 2a ca          	cvtsi2sd %edx,%xmm1
     1fd:	f2 0f 59 0d 00 00 00 	mulsd  0x0(%rip),%xmm1        # 205 <pack_rgb+0xa5>
     204:	00 
			201: R_X86_64_PC32	.LC10-0x4
     205:	f2 0f 5e ce          	divsd  %xmm6,%xmm1
     209:	f2 0f 58 cc          	addsd  %xmm4,%xmm1
     20d:	66 0f 28 d1          	movapd %xmm1,%xmm2
     211:	66 0f 54 d3          	andpd  %xmm3,%xmm2
     215:	66 0f 2e ea          	ucomisd %xmm2,%xmm5
     219:	76 3a                	jbe    255 <pack_rgb+0xf5>
     21b:	f2 48 0f 2c d1       	cvttsd2si %xmm1,%rdx
     220:	66 0f ef d2          	pxor   %xmm2,%xmm2
     224:	66 44 0f 55 c1       	andnpd %xmm1,%xmm8
     229:	f2 44 0f 10 15 00 00 	movsd  0x0(%rip),%xmm10        # 232 <pack_rgb+0xd2>
     230:	00 00 
			22e: R_X86_64_PC32	.LC9-0x4
     232:	f2 48 0f 2a d2       	cvtsi2sd %rdx,%xmm2
     237:	66 44 0f 28 ca       	movapd %xmm2,%xmm9
     23c:	f2 44 0f c2 c9 06    	cmpnlesd %xmm1,%xmm9
     242:	66 45 0f 54 ca       	andpd  %xmm10,%xmm9
     247:	f2 41 0f 5c d1       	subsd  %xmm9,%xmm2
     24c:	66 0f 28 ca          	movapd %xmm2,%xmm1
     250:	66 41 0f 56 c8       	orpd   %xmm8,%xmm1
     255:	0f b6 c0             	movzbl %al,%eax
     258:	66 0f ef d2          	pxor   %xmm2,%xmm2
     25c:	f2 0f 2a d0          	cvtsi2sd %eax,%xmm2
     260:	f2 0f 59 d7          	mulsd  %xmm7,%xmm2
     264:	f2 0f 5e d6          	divsd  %xmm6,%xmm2
     268:	f2 0f 58 d4          	addsd  %xmm4,%xmm2
     26c:	66 0f 28 e2          	movapd %xmm2,%xmm4
     270:	66 0f 54 e3          	andpd  %xmm3,%xmm4
     274:	66 0f 2e ec          	ucomisd %xmm4,%xmm5
     278:	76 33                	jbe    2ad <pack_rgb+0x14d>
     27a:	f2 48 0f 2c c2       	cvttsd2si %xmm2,%rax
     27f:	66 0f ef e4          	pxor   %xmm4,%xmm4
     283:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 28b <pack_rgb+0x12b>
     28a:	00 
			287: R_X86_64_PC32	.LC9-0x4
     28b:	66 0f 55 da          	andnpd %xmm2,%xmm3
     28f:	f2 48 0f 2a e0       	cvtsi2sd %rax,%xmm4
     294:	66 0f 28 ec          	movapd %xmm4,%xmm5
     298:	f2 0f c2 ea 06       	cmpnlesd %xmm2,%xmm5
     29d:	66 0f 54 ee          	andpd  %xmm6,%xmm5
     2a1:	f2 0f 5c e5          	subsd  %xmm5,%xmm4
     2a5:	66 0f 56 e3          	orpd   %xmm3,%xmm4
     2a9:	66 0f 28 d4          	movapd %xmm4,%xmm2
     2ad:	f2 0f 59 05 00 00 00 	mulsd  0x0(%rip),%xmm0        # 2b5 <pack_rgb+0x155>
     2b4:	00 
			2b1: R_X86_64_PC32	.LC11-0x4
     2b5:	f2 0f 59 0d 00 00 00 	mulsd  0x0(%rip),%xmm1        # 2bd <pack_rgb+0x15d>
     2bc:	00 
			2b9: R_X86_64_PC32	.LC12-0x4
     2bd:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
     2c1:	f2 0f 58 c2          	addsd  %xmm2,%xmm0
     2c5:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
     2c9:	c3                   	ret
     2ca:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000000002d0 <slot_bytes>:
     2d0:	0f b6 57 02          	movzbl 0x2(%rdi),%edx
     2d4:	b8 54 00 00 00       	mov    $0x54,%eax
     2d9:	84 d2                	test   %dl,%dl
     2db:	74 16                	je     2f3 <slot_bytes+0x23>
     2dd:	b8 08 01 00 00       	mov    $0x108,%eax
     2e2:	80 fa 01             	cmp    $0x1,%dl
     2e5:	74 0c                	je     2f3 <slot_bytes+0x23>
     2e7:	0f b7 47 06          	movzwl 0x6(%rdi),%eax
     2eb:	6b c0 6c             	imul   $0x6c,%eax,%eax
     2ee:	05 3c 01 00 00       	add    $0x13c,%eax
     2f3:	c3                   	ret
     2f4:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     2fb:	00 00 00 00 
     2ff:	90                   	nop

0000000000000300 <ayatsuri_shade_from_terms.isra.0>:
     300:	41 56                	push   %r14
     302:	89 f8                	mov    %edi,%eax
     304:	49 89 f6             	mov    %rsi,%r14
     307:	41 55                	push   %r13
     309:	66 c1 e8 0b          	shr    $0xb,%ax
     30d:	41 54                	push   %r12
     30f:	0f b7 c0             	movzwl %ax,%eax
     312:	41 89 fc             	mov    %edi,%r12d
     315:	55                   	push   %rbp
     316:	48 89 d5             	mov    %rdx,%rbp
     319:	53                   	push   %rbx
     31a:	48 83 ec 10          	sub    $0x10,%rsp
     31e:	f3 0f 10 6a 04       	movss  0x4(%rdx),%xmm5
     323:	f3 0f 10 66 18       	movss  0x18(%rsi),%xmm4
     328:	f3 0f 59 5a 10       	mulss  0x10(%rdx),%xmm3
     32d:	f3 0f 10 3a          	movss  (%rdx),%xmm7
     331:	f3 0f 59 e8          	mulss  %xmm0,%xmm5
     335:	f3 0f 10 72 08       	movss  0x8(%rdx),%xmm6
     33a:	f3 0f 11 3c 24       	movss  %xmm7,(%rsp)
     33f:	f3 0f 59 f2          	mulss  %xmm2,%xmm6
     343:	f3 0f 59 d9          	mulss  %xmm1,%xmm3
     347:	66 0f ef c9          	pxor   %xmm1,%xmm1
     34b:	f3 0f 11 6c 24 04    	movss  %xmm5,0x4(%rsp)
     351:	f3 0f 59 ec          	mulss  %xmm4,%xmm5
     355:	f3 0f 2a c8          	cvtsi2ss %eax,%xmm1
     359:	f3 0f 59 0d 00 00 00 	mulss  0x0(%rip),%xmm1        # 361 <ayatsuri_shade_from_terms.isra.0+0x61>
     360:	00 
			35d: R_X86_64_PC32	.LC14-0x4
     361:	f3 0f 11 74 24 08    	movss  %xmm6,0x8(%rsp)
     367:	0f 28 c5             	movaps %xmm5,%xmm0
     36a:	f3 0f 58 c7          	addss  %xmm7,%xmm0
     36e:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     372:	f3 0f 10 42 14       	movss  0x14(%rdx),%xmm0
     377:	f3 0f 59 c3          	mulss  %xmm3,%xmm0
     37b:	f3 0f 58 c6          	addss  %xmm6,%xmm0
     37f:	f3 0f 59 c4          	mulss  %xmm4,%xmm0
     383:	f3 0f 58 c8          	addss  %xmm0,%xmm1
     387:	66 0f ef c0          	pxor   %xmm0,%xmm0
     38b:	0f 2f c1             	comiss %xmm1,%xmm0
     38e:	77 21                	ja     3b1 <ayatsuri_shade_from_terms.isra.0+0xb1>
     390:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 398 <ayatsuri_shade_from_terms.isra.0+0x98>
     397:	00 
			394: R_X86_64_PC32	.LC15-0x4
     398:	0f 28 c2             	movaps %xmm2,%xmm0
     39b:	f3 0f c2 c1 01       	cmpltss %xmm1,%xmm0
     3a0:	0f 54 d0             	andps  %xmm0,%xmm2
     3a3:	0f 55 c1             	andnps %xmm1,%xmm0
     3a6:	0f 56 c2             	orps   %xmm2,%xmm0
     3a9:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 3b1 <ayatsuri_shade_from_terms.isra.0+0xb1>
     3b0:	00 
			3ad: R_X86_64_PC32	.LC16-0x4
     3b1:	f3 0f 11 5c 24 0c    	movss  %xmm3,0xc(%rsp)
     3b7:	e8 00 00 00 00       	call   3bc <ayatsuri_shade_from_terms.isra.0+0xbc>
			3b8: R_X86_64_PLT32	lroundf-0x4
     3bc:	f3 41 0f 10 56 1c    	movss  0x1c(%r14),%xmm2
     3c2:	66 0f ef c9          	pxor   %xmm1,%xmm1
     3c6:	f3 0f 10 44 24 04    	movss  0x4(%rsp),%xmm0
     3cc:	48 89 c3             	mov    %rax,%rbx
     3cf:	44 89 e0             	mov    %r12d,%eax
     3d2:	f3 0f 10 5c 24 0c    	movss  0xc(%rsp),%xmm3
     3d8:	f3 0f 59 c2          	mulss  %xmm2,%xmm0
     3dc:	66 c1 e8 05          	shr    $0x5,%ax
     3e0:	83 e0 3f             	and    $0x3f,%eax
     3e3:	f3 0f 58 04 24       	addss  (%rsp),%xmm0
     3e8:	f3 0f 2a c8          	cvtsi2ss %eax,%xmm1
     3ec:	f3 0f 59 0d 00 00 00 	mulss  0x0(%rip),%xmm1        # 3f4 <ayatsuri_shade_from_terms.isra.0+0xf4>
     3f3:	00 
			3f0: R_X86_64_PC32	.LC17-0x4
     3f4:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     3f8:	f3 0f 10 45 18       	movss  0x18(%rbp),%xmm0
     3fd:	f3 0f 59 c3          	mulss  %xmm3,%xmm0
     401:	f3 0f 58 44 24 08    	addss  0x8(%rsp),%xmm0
     407:	f3 0f 59 c2          	mulss  %xmm2,%xmm0
     40b:	f3 0f 58 c8          	addss  %xmm0,%xmm1
     40f:	66 0f ef c0          	pxor   %xmm0,%xmm0
     413:	0f 2f c1             	comiss %xmm1,%xmm0
     416:	77 21                	ja     439 <ayatsuri_shade_from_terms.isra.0+0x139>
     418:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 420 <ayatsuri_shade_from_terms.isra.0+0x120>
     41f:	00 
			41c: R_X86_64_PC32	.LC15-0x4
     420:	0f 28 c2             	movaps %xmm2,%xmm0
     423:	f3 0f c2 c1 01       	cmpltss %xmm1,%xmm0
     428:	0f 54 d0             	andps  %xmm0,%xmm2
     42b:	0f 55 c1             	andnps %xmm1,%xmm0
     42e:	0f 56 c2             	orps   %xmm2,%xmm0
     431:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 439 <ayatsuri_shade_from_terms.isra.0+0x139>
     438:	00 
			435: R_X86_64_PC32	.LC18-0x4
     439:	f3 0f 11 5c 24 0c    	movss  %xmm3,0xc(%rsp)
     43f:	41 83 e4 1f          	and    $0x1f,%r12d
     443:	e8 00 00 00 00       	call   448 <ayatsuri_shade_from_terms.isra.0+0x148>
			444: R_X86_64_PLT32	lroundf-0x4
     448:	f3 41 0f 10 56 20    	movss  0x20(%r14),%xmm2
     44e:	66 0f ef c9          	pxor   %xmm1,%xmm1
     452:	f3 0f 10 44 24 04    	movss  0x4(%rsp),%xmm0
     458:	f3 41 0f 2a cc       	cvtsi2ss %r12d,%xmm1
     45d:	f3 0f 59 0d 00 00 00 	mulss  0x0(%rip),%xmm1        # 465 <ayatsuri_shade_from_terms.isra.0+0x165>
     464:	00 
			461: R_X86_64_PC32	.LC14-0x4
     465:	f3 0f 10 5c 24 0c    	movss  0xc(%rsp),%xmm3
     46b:	49 89 c5             	mov    %rax,%r13
     46e:	f3 0f 59 c2          	mulss  %xmm2,%xmm0
     472:	f3 0f 59 5d 1c       	mulss  0x1c(%rbp),%xmm3
     477:	f3 0f 58 04 24       	addss  (%rsp),%xmm0
     47c:	f3 0f 58 5c 24 08    	addss  0x8(%rsp),%xmm3
     482:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     486:	66 0f ef c0          	pxor   %xmm0,%xmm0
     48a:	f3 0f 59 da          	mulss  %xmm2,%xmm3
     48e:	f3 0f 58 cb          	addss  %xmm3,%xmm1
     492:	0f 2f c1             	comiss %xmm1,%xmm0
     495:	77 21                	ja     4b8 <ayatsuri_shade_from_terms.isra.0+0x1b8>
     497:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 49f <ayatsuri_shade_from_terms.isra.0+0x19f>
     49e:	00 
			49b: R_X86_64_PC32	.LC15-0x4
     49f:	0f 28 c2             	movaps %xmm2,%xmm0
     4a2:	f3 0f c2 c1 01       	cmpltss %xmm1,%xmm0
     4a7:	0f 54 d0             	andps  %xmm0,%xmm2
     4aa:	0f 55 c1             	andnps %xmm1,%xmm0
     4ad:	0f 56 c2             	orps   %xmm2,%xmm0
     4b0:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 4b8 <ayatsuri_shade_from_terms.isra.0+0x1b8>
     4b7:	00 
			4b4: R_X86_64_PC32	.LC16-0x4
     4b8:	e8 00 00 00 00       	call   4bd <ayatsuri_shade_from_terms.isra.0+0x1bd>
			4b9: R_X86_64_PLT32	lroundf-0x4
     4bd:	41 c1 e5 05          	shl    $0x5,%r13d
     4c1:	c1 e3 0b             	shl    $0xb,%ebx
     4c4:	48 83 c4 10          	add    $0x10,%rsp
     4c8:	44 09 eb             	or     %r13d,%ebx
     4cb:	09 d8                	or     %ebx,%eax
     4cd:	5b                   	pop    %rbx
     4ce:	5d                   	pop    %rbp
     4cf:	41 5c                	pop    %r12
     4d1:	41 5d                	pop    %r13
     4d3:	41 5e                	pop    %r14
     4d5:	c3                   	ret
     4d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
     4dd:	00 00 00 

00000000000004e0 <ayatsuri_shade_terms_prepare.isra.0>:
     4e0:	41 56                	push   %r14
     4e2:	41 54                	push   %r12
     4e4:	49 89 d4             	mov    %rdx,%r12
     4e7:	55                   	push   %rbp
     4e8:	89 cd                	mov    %ecx,%ebp
     4ea:	53                   	push   %rbx
     4eb:	89 f3                	mov    %esi,%ebx
     4ed:	48 83 ec 38          	sub    $0x38,%rsp
     4f1:	0f bf 17             	movswl (%rdi),%edx
     4f4:	0f bf 47 04          	movswl 0x4(%rdi),%eax
     4f8:	f3 0f 11 4c 24 1c    	movss  %xmm1,0x1c(%rsp)
     4fe:	66 0f ef c9          	pxor   %xmm1,%xmm1
     502:	f3 0f 2a ca          	cvtsi2ss %edx,%xmm1
     506:	f3 0f 11 44 24 20    	movss  %xmm0,0x20(%rsp)
     50c:	0f bf 57 02          	movswl 0x2(%rdi),%edx
     510:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 518 <ayatsuri_shade_terms_prepare.isra.0+0x38>
     517:	00 
			514: R_X86_64_PC32	.LC19-0x4
     518:	f3 0f 11 6c 24 2c    	movss  %xmm5,0x2c(%rsp)
     51e:	f3 0f 11 5c 24 24    	movss  %xmm3,0x24(%rsp)
     524:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 52c <ayatsuri_shade_terms_prepare.isra.0+0x4c>
     52b:	00 
			528: R_X86_64_PC32	.LC0-0x4
     52c:	f3 0f 11 54 24 18    	movss  %xmm2,0x18(%rsp)
     532:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     536:	f3 0f 11 64 24 28    	movss  %xmm4,0x28(%rsp)
     53c:	f3 0f 11 4c 24 0c    	movss  %xmm1,0xc(%rsp)
     542:	66 0f ef c9          	pxor   %xmm1,%xmm1
     546:	f3 0f 2a ca          	cvtsi2ss %edx,%xmm1
     54a:	0f 28 e9             	movaps %xmm1,%xmm5
     54d:	66 0f ef c9          	pxor   %xmm1,%xmm1
     551:	f3 0f 2a c8          	cvtsi2ss %eax,%xmm1
     555:	f3 0f 59 e8          	mulss  %xmm0,%xmm5
     559:	0f 28 f1             	movaps %xmm1,%xmm6
     55c:	f3 0f 59 f0          	mulss  %xmm0,%xmm6
     560:	0f 28 fd             	movaps %xmm5,%xmm7
     563:	f3 0f 11 6c 24 10    	movss  %xmm5,0x10(%rsp)
     569:	0f 54 fb             	andps  %xmm3,%xmm7
     56c:	0f 28 cf             	movaps %xmm7,%xmm1
     56f:	0f 28 c6             	movaps %xmm6,%xmm0
     572:	f3 0f 11 74 24 14    	movss  %xmm6,0x14(%rsp)
     578:	0f 54 c3             	andps  %xmm3,%xmm0
     57b:	e8 00 00 00 00       	call   580 <ayatsuri_shade_terms_prepare.isra.0+0xa0>
			57c: R_X86_64_PLT32	fmaxf-0x4
     580:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
     586:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 58e <ayatsuri_shade_terms_prepare.isra.0+0xae>
     58d:	00 
			58a: R_X86_64_PC32	.LC0-0x4
     58e:	0f 54 cb             	andps  %xmm3,%xmm1
     591:	e8 00 00 00 00       	call   596 <ayatsuri_shade_terms_prepare.isra.0+0xb6>
			592: R_X86_64_PLT32	fmaxf-0x4
     596:	66 0f ef c9          	pxor   %xmm1,%xmm1
     59a:	f3 0f 10 54 24 18    	movss  0x18(%rsp),%xmm2
     5a0:	f3 0f 10 7c 24 1c    	movss  0x1c(%rsp),%xmm7
     5a6:	0f 2f c1             	comiss %xmm1,%xmm0
     5a9:	f3 0f 10 74 24 20    	movss  0x20(%rsp),%xmm6
     5af:	76 11                	jbe    5c2 <ayatsuri_shade_terms_prepare.isra.0+0xe2>
     5b1:	f3 0f 10 0d 00 00 00 	movss  0x0(%rip),%xmm1        # 5b9 <ayatsuri_shade_terms_prepare.isra.0+0xd9>
     5b8:	00 
			5b5: R_X86_64_PC32	.LC1-0x4
     5b9:	0f 2e c8             	ucomiss %xmm0,%xmm1
     5bc:	0f 83 0e 01 00 00    	jae    6d0 <ayatsuri_shade_terms_prepare.isra.0+0x1f0>
     5c2:	f3 0f 59 7c 24 10    	mulss  0x10(%rsp),%xmm7
     5c8:	66 0f ef c9          	pxor   %xmm1,%xmm1
     5cc:	f3 0f 59 74 24 0c    	mulss  0xc(%rsp),%xmm6
     5d2:	f3 0f 59 54 24 14    	mulss  0x14(%rsp),%xmm2
     5d8:	f3 0f 58 f7          	addss  %xmm7,%xmm6
     5dc:	f3 0f 58 d6          	addss  %xmm6,%xmm2
     5e0:	0f 28 c2             	movaps %xmm2,%xmm0
     5e3:	f3 0f 11 54 24 18    	movss  %xmm2,0x18(%rsp)
     5e9:	e8 00 00 00 00       	call   5ee <ayatsuri_shade_terms_prepare.isra.0+0x10e>
			5ea: R_X86_64_PLT32	fmaxf-0x4
     5ee:	f3 0f 10 54 24 18    	movss  0x18(%rsp),%xmm2
     5f4:	66 0f ef c9          	pxor   %xmm1,%xmm1
     5f8:	0f 57 15 00 00 00 00 	xorps  0x0(%rip),%xmm2        # 5ff <ayatsuri_shade_terms_prepare.isra.0+0x11f>
			5fb: R_X86_64_PC32	.LC20-0x4
     5ff:	66 41 0f 7e c6       	movd   %xmm0,%r14d
     604:	0f 28 c2             	movaps %xmm2,%xmm0
     607:	e8 00 00 00 00       	call   60c <ayatsuri_shade_terms_prepare.isra.0+0x12c>
			608: R_X86_64_PLT32	fmaxf-0x4
     60c:	66 0f ef e4          	pxor   %xmm4,%xmm4
     610:	0f 28 d8             	movaps %xmm0,%xmm3
     613:	40 84 ed             	test   %bpl,%bpl
     616:	74 74                	je     68c <ayatsuri_shade_terms_prepare.isra.0+0x1ac>
     618:	66 41 0f 6e f6       	movd   %r14d,%xmm6
     61d:	0f 2f f4             	comiss %xmm4,%xmm6
     620:	76 6a                	jbe    68c <ayatsuri_shade_terms_prepare.isra.0+0x1ac>
     622:	f3 0f 11 44 24 18    	movss  %xmm0,0x18(%rsp)
     628:	f3 0f 10 4c 24 28    	movss  0x28(%rsp),%xmm1
     62e:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
     634:	f3 0f 59 4c 24 10    	mulss  0x10(%rsp),%xmm1
     63a:	f3 0f 11 64 24 1c    	movss  %xmm4,0x1c(%rsp)
     640:	f3 0f 59 44 24 0c    	mulss  0xc(%rsp),%xmm0
     646:	f3 0f 58 c1          	addss  %xmm1,%xmm0
     64a:	f3 0f 10 4c 24 2c    	movss  0x2c(%rsp),%xmm1
     650:	f3 0f 59 4c 24 14    	mulss  0x14(%rsp),%xmm1
     656:	f3 0f 58 c1          	addss  %xmm1,%xmm0
     65a:	0f 28 cc             	movaps %xmm4,%xmm1
     65d:	e8 00 00 00 00       	call   662 <ayatsuri_shade_terms_prepare.isra.0+0x182>
			65e: R_X86_64_PLT32	fmaxf-0x4
     662:	66 0f ef e4          	pxor   %xmm4,%xmm4
     666:	f3 0f 10 5c 24 18    	movss  0x18(%rsp),%xmm3
     66c:	0f 2f c4             	comiss %xmm4,%xmm0
     66f:	76 1b                	jbe    68c <ayatsuri_shade_terms_prepare.isra.0+0x1ac>
     671:	f3 41 0f 10 4c 24 0c 	movss  0xc(%r12),%xmm1
     678:	f3 0f 11 5c 24 0c    	movss  %xmm3,0xc(%rsp)
     67e:	e8 00 00 00 00       	call   683 <ayatsuri_shade_terms_prepare.isra.0+0x1a3>
			67f: R_X86_64_PLT32	powf-0x4
     683:	f3 0f 10 5c 24 0c    	movss  0xc(%rsp),%xmm3
     689:	0f 28 e0             	movaps %xmm0,%xmm4
     68c:	66 0f ef c0          	pxor   %xmm0,%xmm0
     690:	66 41 0f 6e fe       	movd   %r14d,%xmm7
     695:	0f 28 cc             	movaps %xmm4,%xmm1
     698:	0f b6 db             	movzbl %bl,%ebx
     69b:	f3 0f 2a c3          	cvtsi2ss %ebx,%xmm0
     69f:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 6a7 <ayatsuri_shade_terms_prepare.isra.0+0x1c7>
     6a6:	00 
			6a3: R_X86_64_PC32	.LC21-0x4
     6a7:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 6af <ayatsuri_shade_terms_prepare.isra.0+0x1cf>
     6ae:	00 
			6ab: R_X86_64_PC32	.LC15-0x4
     6af:	0f 14 fb             	unpcklps %xmm3,%xmm7
     6b2:	48 83 c4 38          	add    $0x38,%rsp
     6b6:	5b                   	pop    %rbx
     6b7:	5d                   	pop    %rbp
     6b8:	41 5c                	pop    %r12
     6ba:	41 5e                	pop    %r14
     6bc:	f3 0f 5c d0          	subss  %xmm0,%xmm2
     6c0:	0f 28 c7             	movaps %xmm7,%xmm0
     6c3:	0f 14 ca             	unpcklps %xmm2,%xmm1
     6c6:	c3                   	ret
     6c7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
     6ce:	00 00 
     6d0:	f3 0f 10 64 24 0c    	movss  0xc(%rsp),%xmm4
     6d6:	f3 0f 10 5c 24 10    	movss  0x10(%rsp),%xmm3
     6dc:	f3 0f 10 4c 24 14    	movss  0x14(%rsp),%xmm1
     6e2:	f3 0f 5e d8          	divss  %xmm0,%xmm3
     6e6:	f3 0f 5e e0          	divss  %xmm0,%xmm4
     6ea:	0f 28 eb             	movaps %xmm3,%xmm5
     6ed:	f3 0f 59 eb          	mulss  %xmm3,%xmm5
     6f1:	f3 0f 5e c8          	divss  %xmm0,%xmm1
     6f5:	0f 28 c4             	movaps %xmm4,%xmm0
     6f8:	f3 0f 59 c4          	mulss  %xmm4,%xmm0
     6fc:	f3 0f 58 c5          	addss  %xmm5,%xmm0
     700:	0f 28 e9             	movaps %xmm1,%xmm5
     703:	f3 0f 59 e9          	mulss  %xmm1,%xmm5
     707:	f3 0f 58 c5          	addss  %xmm5,%xmm0
     70b:	f3 0f 51 c0          	sqrtss %xmm0,%xmm0
     70f:	f3 0f 5e e0          	divss  %xmm0,%xmm4
     713:	f3 0f 5e d8          	divss  %xmm0,%xmm3
     717:	f3 0f 11 64 24 0c    	movss  %xmm4,0xc(%rsp)
     71d:	f3 0f 5e c8          	divss  %xmm0,%xmm1
     721:	f3 0f 11 5c 24 10    	movss  %xmm3,0x10(%rsp)
     727:	f3 0f 11 4c 24 14    	movss  %xmm1,0x14(%rsp)
     72d:	e9 90 fe ff ff       	jmp    5c2 <ayatsuri_shade_terms_prepare.isra.0+0xe2>
     732:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     739:	00 00 00 00 
     73d:	0f 1f 00             	nopl   (%rax)

0000000000000740 <node_slot_bytes>:
     740:	0f b6 42 02          	movzbl 0x2(%rdx),%eax
     744:	89 f1                	mov    %esi,%ecx
     746:	3c 03                	cmp    $0x3,%al
     748:	74 2e                	je     778 <node_slot_bytes+0x38>
     74a:	be 54 00 00 00       	mov    $0x54,%esi
     74f:	84 c0                	test   %al,%al
     751:	74 1d                	je     770 <node_slot_bytes+0x30>
     753:	be 08 01 00 00       	mov    $0x108,%esi
     758:	3c 01                	cmp    $0x1,%al
     75a:	74 14                	je     770 <node_slot_bytes+0x30>
     75c:	44 0f b7 42 06       	movzwl 0x6(%rdx),%r8d
     761:	45 6b c0 6c          	imul   $0x6c,%r8d,%r8d
     765:	41 8d b0 3c 01 00 00 	lea    0x13c(%r8),%esi
     76c:	3c 02                	cmp    $0x2,%al
     76e:	74 58                	je     7c8 <node_slot_bytes+0x88>
     770:	89 f0                	mov    %esi,%eax
     772:	c3                   	ret
     773:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
     778:	0f b7 42 04          	movzwl 0x4(%rdx),%eax
     77c:	48 8b 0f             	mov    (%rdi),%rcx
     77f:	8b 77 54             	mov    0x54(%rdi),%esi
     782:	44 8b 47 78          	mov    0x78(%rdi),%r8d
     786:	c1 e0 05             	shl    $0x5,%eax
     789:	48 01 c8             	add    %rcx,%rax
     78c:	0f b7 44 06 02       	movzwl 0x2(%rsi,%rax,1),%eax
     791:	8d 34 40             	lea    (%rax,%rax,2),%esi
     794:	8d 34 b5 6b 04 00 00 	lea    0x46b(,%rsi,4),%esi
     79b:	83 e6 f8             	and    $0xfffffff8,%esi
     79e:	45 85 c0             	test   %r8d,%r8d
     7a1:	74 cd                	je     770 <node_slot_bytes+0x30>
     7a3:	0f b7 52 08          	movzwl 0x8(%rdx),%edx
     7a7:	8b 7f 74             	mov    0x74(%rdi),%edi
     7aa:	c1 e2 02             	shl    $0x2,%edx
     7ad:	48 01 d1             	add    %rdx,%rcx
     7b0:	80 3c 39 01          	cmpb   $0x1,(%rcx,%rdi,1)
     7b4:	75 ba                	jne    770 <node_slot_bytes+0x30>
     7b6:	8d 04 85 0f 00 00 00 	lea    0xf(,%rax,4),%eax
     7bd:	83 e0 f8             	and    $0xfffffff8,%eax
     7c0:	01 c6                	add    %eax,%esi
     7c2:	89 f0                	mov    %esi,%eax
     7c4:	c3                   	ret
     7c5:	0f 1f 00             	nopl   (%rax)
     7c8:	4c 8b 0f             	mov    (%rdi),%r9
     7cb:	8b 47 4c             	mov    0x4c(%rdi),%eax
     7ce:	8b 7f 50             	mov    0x50(%rdi),%edi
     7d1:	85 ff                	test   %edi,%edi
     7d3:	74 9b                	je     770 <node_slot_bytes+0x30>
     7d5:	31 d2                	xor    %edx,%edx
     7d7:	49 01 c1             	add    %rax,%r9
     7da:	eb 0b                	jmp    7e7 <node_slot_bytes+0xa7>
     7dc:	0f 1f 40 00          	nopl   0x0(%rax)
     7e0:	83 c2 01             	add    $0x1,%edx
     7e3:	39 d7                	cmp    %edx,%edi
     7e5:	74 89                	je     770 <node_slot_bytes+0x30>
     7e7:	89 d0                	mov    %edx,%eax
     7e9:	c1 e0 05             	shl    $0x5,%eax
     7ec:	41 0f b7 04 01       	movzwl (%r9,%rax,1),%eax
     7f1:	39 c1                	cmp    %eax,%ecx
     7f3:	75 eb                	jne    7e0 <node_slot_bytes+0xa0>
     7f5:	41 8d b0 54 01 00 00 	lea    0x154(%r8),%esi
     7fc:	89 f0                	mov    %esi,%eax
     7fe:	c3                   	ret
     7ff:	90                   	nop

0000000000000800 <mesh_packet>:
     800:	41 57                	push   %r15
     802:	89 f0                	mov    %esi,%eax
     804:	49 89 fb             	mov    %rdi,%r11
     807:	41 56                	push   %r14
     809:	89 c6                	mov    %eax,%esi
     80b:	41 55                	push   %r13
     80d:	c1 e6 04             	shl    $0x4,%esi
     810:	41 54                	push   %r12
     812:	55                   	push   %rbp
     813:	53                   	push   %rbx
     814:	48 81 ec 98 05 00 00 	sub    $0x598,%rsp
     81b:	48 8b 1f             	mov    (%rdi),%rbx
     81e:	44 89 8c 24 f4 00 00 	mov    %r9d,0xf4(%rsp)
     825:	00 
     826:	8b 7b 14             	mov    0x14(%rbx),%edi
     829:	4c 8b 23             	mov    (%rbx),%r12
     82c:	44 88 4c 24 77       	mov    %r9b,0x77(%rsp)
     831:	48 89 5c 24 18       	mov    %rbx,0x18(%rsp)
     836:	48 01 f7             	add    %rsi,%rdi
     839:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%rsp)
     840:	00 
     841:	4c 01 e7             	add    %r12,%rdi
     844:	80 7f 02 03          	cmpb   $0x3,0x2(%rdi)
     848:	0f b7 77 08          	movzwl 0x8(%rdi),%esi
     84c:	0f 84 26 04 00 00    	je     c78 <mesh_packet+0x478>
     852:	4d 8b 73 08          	mov    0x8(%r11),%r14
     856:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
     85a:	66 0f ef ed          	pxor   %xmm5,%xmm5
     85e:	66 0f ef ff          	pxor   %xmm7,%xmm7
     862:	48 8d 1c c5 00 00 00 	lea    0x0(,%rax,8),%rbx
     869:	00 
     86a:	66 45 0f ef c9       	pxor   %xmm9,%xmm9
     86f:	66 45 0f ef d2       	pxor   %xmm10,%xmm10
     874:	41 8b 44 c6 08       	mov    0x8(%r14,%rax,8),%eax
     879:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
     87e:	66 0f ef f6          	pxor   %xmm6,%xmm6
     882:	66 45 0f ef f6       	pxor   %xmm14,%xmm14
     887:	66 0f ef d2          	pxor   %xmm2,%xmm2
     88b:	66 45 0f ef ff       	pxor   %xmm15,%xmm15
     890:	48 89 9c 24 e8 00 00 	mov    %rbx,0xe8(%rsp)
     897:	00 
     898:	49 01 c6             	add    %rax,%r14
     89b:	f3 41 0f 5a 6e 14    	cvtss2sd 0x14(%r14),%xmm5
     8a1:	66 0f 28 cd          	movapd %xmm5,%xmm1
     8a5:	f3 45 0f 5a 4e 18    	cvtss2sd 0x18(%r14),%xmm9
     8ab:	f3 41 0f 5a 7e 28    	cvtss2sd 0x28(%r14),%xmm7
     8b1:	66 41 0f 28 c1       	movapd %xmm9,%xmm0
     8b6:	66 45 0f 28 d9       	movapd %xmm9,%xmm11
     8bb:	f3 45 0f 5a 36       	cvtss2sd (%r14),%xmm14
     8c0:	f3 45 0f 5a 56 24    	cvtss2sd 0x24(%r14),%xmm10
     8c6:	f2 0f 59 cf          	mulsd  %xmm7,%xmm1
     8ca:	f3 45 0f 5a 46 10    	cvtss2sd 0x10(%r14),%xmm8
     8d0:	66 45 0f 28 e0       	movapd %xmm8,%xmm12
     8d5:	f3 41 0f 5a 76 20    	cvtss2sd 0x20(%r14),%xmm6
     8db:	f2 41 0f 59 c2       	mulsd  %xmm10,%xmm0
     8e0:	f3 41 0f 5a 56 04    	cvtss2sd 0x4(%r14),%xmm2
     8e6:	f3 45 0f 5a 7e 08    	cvtss2sd 0x8(%r14),%xmm15
     8ec:	f2 44 0f 59 e7       	mulsd  %xmm7,%xmm12
     8f1:	f2 44 0f 59 de       	mulsd  %xmm6,%xmm11
     8f6:	66 0f 28 d9          	movapd %xmm1,%xmm3
     8fa:	66 41 0f 28 c8       	movapd %xmm8,%xmm1
     8ff:	f2 0f 5c d8          	subsd  %xmm0,%xmm3
     903:	f2 41 0f 59 ca       	mulsd  %xmm10,%xmm1
     908:	66 0f 28 c5          	movapd %xmm5,%xmm0
     90c:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
     910:	f2 44 0f 11 64 24 20 	movsd  %xmm12,0x20(%rsp)
     917:	f2 44 0f 11 5c 24 30 	movsd  %xmm11,0x30(%rsp)
     91e:	66 0f 28 e3          	movapd %xmm3,%xmm4
     922:	f2 0f 11 1c 24       	movsd  %xmm3,(%rsp)
     927:	f2 0f 10 1d 00 00 00 	movsd  0x0(%rip),%xmm3        # 92f <mesh_packet+0x12f>
     92e:	00 
			92b: R_X86_64_PC32	.LC22-0x4
     92f:	f2 41 0f 59 e6       	mulsd  %xmm14,%xmm4
     934:	f2 0f 5c c8          	subsd  %xmm0,%xmm1
     938:	66 41 0f 28 c4       	movapd %xmm12,%xmm0
     93d:	f2 41 0f 5c c3       	subsd  %xmm11,%xmm0
     942:	f2 0f 11 4c 24 38    	movsd  %xmm1,0x38(%rsp)
     948:	f2 41 0f 59 cf       	mulsd  %xmm15,%xmm1
     94d:	f2 0f 59 c2          	mulsd  %xmm2,%xmm0
     951:	f2 0f 5c e0          	subsd  %xmm0,%xmm4
     955:	f2 0f 58 e1          	addsd  %xmm1,%xmm4
     959:	66 0f 28 c4          	movapd %xmm4,%xmm0
     95d:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 965 <mesh_packet+0x165>
     964:	00 
			961: R_X86_64_PC32	.LC8-0x4
     965:	66 0f 2e d8          	ucomisd %xmm0,%xmm3
     969:	0f 82 f1 02 00 00    	jb     c60 <mesh_packet+0x460>
     96f:	66 0f ef c0          	pxor   %xmm0,%xmm0
     973:	66 0f 2e e0          	ucomisd %xmm0,%xmm4
     977:	7a 06                	jp     97f <mesh_packet+0x17f>
     979:	0f 84 e1 02 00 00    	je     c60 <mesh_packet+0x460>
     97f:	f3 44 0f 10 1d 00 00 	movss  0x0(%rip),%xmm11        # 988 <mesh_packet+0x188>
     986:	00 00 
			984: R_X86_64_PC32	.LC0-0x4
     988:	0f b7 5f 04          	movzwl 0x4(%rdi),%ebx
     98c:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
     991:	8b 47 54             	mov    0x54(%rdi),%eax
     994:	c1 e3 05             	shl    $0x5,%ebx
     997:	44 8b 6f 34          	mov    0x34(%rdi),%r13d
     99b:	48 01 c3             	add    %rax,%rbx
     99e:	4c 01 e3             	add    %r12,%rbx
     9a1:	80 bc 24 f4 00 00 00 	cmpb   $0x0,0xf4(%rsp)
     9a8:	00 
     9a9:	0f b7 43 02          	movzwl 0x2(%rbx),%eax
     9ad:	66 89 84 24 30 01 00 	mov    %ax,0x130(%rsp)
     9b4:	00 
     9b5:	0f b7 43 06          	movzwl 0x6(%rbx),%eax
     9b9:	66 89 84 24 32 01 00 	mov    %ax,0x132(%rsp)
     9c0:	00 
     9c1:	0f 85 93 01 00 00    	jne    b5a <mesh_packet+0x35a>
     9c7:	f3 41 0f 10 46 0c    	movss  0xc(%r14),%xmm0
     9cd:	f3 45 0f 10 6e 1c    	movss  0x1c(%r14),%xmm13
     9d3:	48 89 8c 24 98 03 00 	mov    %rcx,0x398(%rsp)
     9da:	00 
     9db:	31 c9                	xor    %ecx,%ecx
     9dd:	f3 41 0f 5c 43 34    	subss  0x34(%r11),%xmm0
     9e3:	f3 45 0f 5c 6b 38    	subss  0x38(%r11),%xmm13
     9e9:	45 89 ef             	mov    %r13d,%r15d
     9ec:	4c 89 84 24 a0 03 00 	mov    %r8,0x3a0(%rsp)
     9f3:	00 
     9f4:	4c 8d 84 24 60 01 00 	lea    0x160(%rsp),%r8
     9fb:	00 
     9fc:	4d 8d 4e 0c          	lea    0xc(%r14),%r9
     a00:	41 89 cd             	mov    %ecx,%r13d
     a03:	f3 45 0f 10 66 2c    	movss  0x2c(%r14),%xmm12
     a09:	4c 89 44 24 60       	mov    %r8,0x60(%rsp)
     a0e:	f3 45 0f 5c 63 3c    	subss  0x3c(%r11),%xmm12
     a14:	4c 89 c7             	mov    %r8,%rdi
     a17:	4c 8d 94 24 90 03 00 	lea    0x390(%rsp),%r10
     a1e:	00 
     a1f:	48 89 94 24 90 03 00 	mov    %rdx,0x390(%rsp)
     a26:	00 
     a27:	f3 0f 11 44 24 40    	movss  %xmm0,0x40(%rsp)
     a2d:	f3 44 0f 11 6c 24 50 	movss  %xmm13,0x50(%rsp)
     a34:	f2 0f 11 54 24 58    	movsd  %xmm2,0x58(%rsp)
     a3a:	48 83 f9 02          	cmp    $0x2,%rcx
     a3e:	0f 84 af 00 00 00    	je     af3 <mesh_packet+0x2f3>
     a44:	f3 45 0f 10 5b 40    	movss  0x40(%r11),%xmm11
     a4a:	49 8b 14 ca          	mov    (%r10,%rcx,8),%rdx
     a4e:	41 c1 e5 02          	shl    $0x2,%r13d
     a52:	f3 0f 10 1a          	movss  (%rdx),%xmm3
     a56:	f3 0f 10 4a 04       	movss  0x4(%rdx),%xmm1
     a5b:	f3 0f 10 52 08       	movss  0x8(%rdx),%xmm2
     a60:	4c 89 f2             	mov    %r14,%rdx
     a63:	f3 44 0f 10 2a       	movss  (%rdx),%xmm13
     a68:	f3 0f 10 42 10       	movss  0x10(%rdx),%xmm0
     a6d:	44 89 e8             	mov    %r13d,%eax
     a70:	48 83 c2 04          	add    $0x4,%rdx
     a74:	41 83 c5 01          	add    $0x1,%r13d
     a78:	f3 44 0f 59 eb       	mulss  %xmm3,%xmm13
     a7d:	f3 0f 59 c1          	mulss  %xmm1,%xmm0
     a81:	f3 41 0f 58 c5       	addss  %xmm13,%xmm0
     a86:	f3 44 0f 10 6a 1c    	movss  0x1c(%rdx),%xmm13
     a8c:	f3 44 0f 59 ea       	mulss  %xmm2,%xmm13
     a91:	f3 41 0f 58 c5       	addss  %xmm13,%xmm0
     a96:	f3 41 0f 59 c3       	mulss  %xmm11,%xmm0
     a9b:	f3 0f 11 84 84 60 01 	movss  %xmm0,0x160(%rsp,%rax,4)
     aa2:	00 00 
     aa4:	49 39 d1             	cmp    %rdx,%r9
     aa7:	75 ba                	jne    a63 <mesh_packet+0x263>
     aa9:	f3 0f 59 5c 24 40    	mulss  0x40(%rsp),%xmm3
     aaf:	48 83 c1 01          	add    $0x1,%rcx
     ab3:	48 83 c7 10          	add    $0x10,%rdi
     ab7:	f3 0f 59 4c 24 50    	mulss  0x50(%rsp),%xmm1
     abd:	f3 41 0f 59 d4       	mulss  %xmm12,%xmm2
     ac2:	f3 0f 58 cb          	addss  %xmm3,%xmm1
     ac6:	f3 0f 58 ca          	addss  %xmm2,%xmm1
     aca:	f3 41 0f 59 cb       	mulss  %xmm11,%xmm1
     acf:	f3 0f 11 4f fc       	movss  %xmm1,-0x4(%rdi)
     ad4:	48 83 f9 03          	cmp    $0x3,%rcx
     ad8:	74 2e                	je     b08 <mesh_packet+0x308>
     ada:	f3 41 0f 58 4c 8b 40 	addss  0x40(%r11,%rcx,4),%xmm1
     ae1:	41 89 cd             	mov    %ecx,%r13d
     ae4:	f3 0f 11 4f fc       	movss  %xmm1,-0x4(%rdi)
     ae9:	48 83 f9 02          	cmp    $0x2,%rcx
     aed:	0f 85 51 ff ff ff    	jne    a44 <mesh_packet+0x244>
     af3:	f3 44 0f 10 1d 00 00 	movss  0x0(%rip),%xmm11        # afc <mesh_packet+0x2fc>
     afa:	00 00 
			af8: R_X86_64_PC32	.LC15-0x4
     afc:	e9 49 ff ff ff       	jmp    a4a <mesh_packet+0x24a>
     b01:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
     b08:	f2 0f 10 54 24 58    	movsd  0x58(%rsp),%xmm2
     b0e:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
     b13:	45 89 fd             	mov    %r15d,%r13d
     b16:	49 83 c0 30          	add    $0x30,%r8
     b1a:	f3 0f 10 0d 00 00 00 	movss  0x0(%rip),%xmm1        # b22 <mesh_packet+0x322>
     b21:	00 
			b1e: R_X86_64_PC32	.LC1-0x4
     b22:	f3 44 0f 10 1d 00 00 	movss  0x0(%rip),%xmm11        # b2b <mesh_packet+0x32b>
     b29:	00 00 
			b27: R_X86_64_PC32	.LC0-0x4
     b2b:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     b32:	00 00 00 00 
     b36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
     b3d:	00 00 00 
     b40:	f3 0f 10 00          	movss  (%rax),%xmm0
     b44:	41 0f 54 c3          	andps  %xmm11,%xmm0
     b48:	0f 2e c8             	ucomiss %xmm0,%xmm1
     b4b:	0f 82 0f 01 00 00    	jb     c60 <mesh_packet+0x460>
     b51:	48 83 c0 04          	add    $0x4,%rax
     b55:	49 39 c0             	cmp    %rax,%r8
     b58:	75 e6                	jne    b40 <mesh_packet+0x340>
     b5a:	48 8d 04 f6          	lea    (%rsi,%rsi,8),%rax
     b5e:	f3 41 0f 10 4b 64    	movss  0x64(%r11),%xmm1
     b64:	f2 0f 11 b4 24 c0 00 	movsd  %xmm6,0xc0(%rsp)
     b6b:	00 00 
     b6d:	f3 41 0f 10 73 68    	movss  0x68(%r11),%xmm6
     b73:	49 8d 44 c5 00       	lea    0x0(%r13,%rax,8),%rax
     b78:	4c 89 5c 24 78       	mov    %r11,0x78(%rsp)
     b7d:	4c 01 e0             	add    %r12,%rax
     b80:	f3 0f 11 4c 24 40    	movss  %xmm1,0x40(%rsp)
     b86:	f3 0f 6f 00          	movdqu (%rax),%xmm0
     b8a:	f3 0f 11 74 24 50    	movss  %xmm6,0x50(%rsp)
     b90:	f2 0f 11 ac 24 e0 00 	movsd  %xmm5,0xe0(%rsp)
     b97:	00 00 
     b99:	f3 41 0f 10 6b 6c    	movss  0x6c(%r11),%xmm5
     b9f:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
     ba6:	00 
     ba7:	f3 0f 6f 40 10       	movdqu 0x10(%rax),%xmm0
     bac:	f2 0f 11 bc 24 f8 00 	movsd  %xmm7,0xf8(%rsp)
     bb3:	00 00 
     bb5:	0f 28 fe             	movaps %xmm6,%xmm7
     bb8:	41 0f 54 fb          	andps  %xmm11,%xmm7
     bbc:	f3 0f 11 6c 24 58    	movss  %xmm5,0x58(%rsp)
     bc2:	0f 29 84 24 50 01 00 	movaps %xmm0,0x150(%rsp)
     bc9:	00 
     bca:	0f 28 c5             	movaps %xmm5,%xmm0
     bcd:	0f 28 cf             	movaps %xmm7,%xmm1
     bd0:	41 0f 54 c3          	andps  %xmm11,%xmm0
     bd4:	44 0f 29 5c 24 60    	movaps %xmm11,0x60(%rsp)
     bda:	f2 0f 11 a4 24 10 01 	movsd  %xmm4,0x110(%rsp)
     be1:	00 00 
     be3:	f2 44 0f 11 94 24 d0 	movsd  %xmm10,0xd0(%rsp)
     bea:	00 00 00 
     bed:	f2 44 0f 11 8c 24 b0 	movsd  %xmm9,0xb0(%rsp)
     bf4:	00 00 00 
     bf7:	f2 44 0f 11 84 24 a8 	movsd  %xmm8,0xa8(%rsp)
     bfe:	00 00 00 
     c01:	f2 44 0f 11 bc 24 a0 	movsd  %xmm15,0xa0(%rsp)
     c08:	00 00 00 
     c0b:	f2 0f 11 94 24 98 00 	movsd  %xmm2,0x98(%rsp)
     c12:	00 00 
     c14:	f2 44 0f 11 b4 24 80 	movsd  %xmm14,0x80(%rsp)
     c1b:	00 00 00 
     c1e:	e8 00 00 00 00       	call   c23 <mesh_packet+0x423>
			c1f: R_X86_64_PLT32	fmaxf-0x4
     c23:	44 0f 28 5c 24 60    	movaps 0x60(%rsp),%xmm11
     c29:	f3 0f 10 4c 24 40    	movss  0x40(%rsp),%xmm1
     c2f:	41 0f 54 cb          	andps  %xmm11,%xmm1
     c33:	e8 00 00 00 00       	call   c38 <mesh_packet+0x438>
			c34: R_X86_64_PLT32	fmaxf-0x4
     c38:	66 0f ef e4          	pxor   %xmm4,%xmm4
     c3c:	0f 2f c4             	comiss %xmm4,%xmm0
     c3f:	76 1f                	jbe    c60 <mesh_packet+0x460>
     c41:	f3 0f 10 25 00 00 00 	movss  0x0(%rip),%xmm4        # c49 <mesh_packet+0x449>
     c48:	00 
			c45: R_X86_64_PC32	.LC1-0x4
     c49:	f3 0f 11 84 24 88 00 	movss  %xmm0,0x88(%rsp)
     c50:	00 00 
     c52:	0f 2e e0             	ucomiss %xmm0,%xmm4
     c55:	73 59                	jae    cb0 <mesh_packet+0x4b0>
     c57:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
     c5e:	00 00 
     c60:	31 c0                	xor    %eax,%eax
     c62:	48 81 c4 98 05 00 00 	add    $0x598,%rsp
     c69:	5b                   	pop    %rbx
     c6a:	5d                   	pop    %rbp
     c6b:	41 5c                	pop    %r12
     c6d:	41 5d                	pop    %r13
     c6f:	41 5e                	pop    %r14
     c71:	41 5f                	pop    %r15
     c73:	c3                   	ret
     c74:	0f 1f 40 00          	nopl   0x0(%rax)
     c78:	44 8b 53 78          	mov    0x78(%rbx),%r10d
     c7c:	45 85 d2             	test   %r10d,%r10d
     c7f:	0f 84 cd fb ff ff    	je     852 <mesh_packet+0x52>
     c85:	44 8b 53 74          	mov    0x74(%rbx),%r10d
     c89:	4c 8d 0c b5 00 00 00 	lea    0x0(,%rsi,4),%r9
     c90:	00 
     c91:	31 db                	xor    %ebx,%ebx
     c93:	41 81 e1 fc ff 03 00 	and    $0x3fffc,%r9d
     c9a:	4d 01 e2             	add    %r12,%r10
     c9d:	43 80 3c 0a 01       	cmpb   $0x1,(%r10,%r9,1)
     ca2:	0f 94 c3             	sete   %bl
     ca5:	89 5c 24 28          	mov    %ebx,0x28(%rsp)
     ca9:	e9 a4 fb ff ff       	jmp    852 <mesh_packet+0x52>
     cae:	66 90                	xchg   %ax,%ax
     cb0:	4c 8b 5c 24 78       	mov    0x78(%rsp),%r11
     cb5:	44 0f 28 5c 24 60    	movaps 0x60(%rsp),%xmm11
     cbb:	45 8b 6b 74          	mov    0x74(%r11),%r13d
     cbf:	45 8b 7b 78          	mov    0x78(%r11),%r15d
     cc3:	4c 89 9c 24 18 01 00 	mov    %r11,0x118(%rsp)
     cca:	00 
     ccb:	f3 41 0f 10 63 70    	movss  0x70(%r11),%xmm4
     cd1:	66 41 0f 6e dd       	movd   %r13d,%xmm3
     cd6:	41 0f 54 db          	andps  %xmm11,%xmm3
     cda:	f3 0f 11 64 24 78    	movss  %xmm4,0x78(%rsp)
     ce0:	0f 28 cb             	movaps %xmm3,%xmm1
     ce3:	66 41 0f 6e df       	movd   %r15d,%xmm3
     ce8:	41 0f 54 db          	andps  %xmm11,%xmm3
     cec:	0f 28 c3             	movaps %xmm3,%xmm0
     cef:	e8 00 00 00 00       	call   cf4 <mesh_packet+0x4f4>
			cf0: R_X86_64_PLT32	fmaxf-0x4
     cf4:	44 0f 28 5c 24 60    	movaps 0x60(%rsp),%xmm11
     cfa:	f3 0f 10 64 24 78    	movss  0x78(%rsp),%xmm4
     d00:	44 0f 29 9c 24 00 01 	movaps %xmm11,0x100(%rsp)
     d07:	00 00 
     d09:	41 0f 54 e3          	andps  %xmm11,%xmm4
     d0d:	0f 28 cc             	movaps %xmm4,%xmm1
     d10:	e8 00 00 00 00       	call   d15 <mesh_packet+0x515>
			d11: R_X86_64_PLT32	fmaxf-0x4
     d15:	66 0f ef db          	pxor   %xmm3,%xmm3
     d19:	0f 2f c3             	comiss %xmm3,%xmm0
     d1c:	44 0f 28 e8          	movaps %xmm0,%xmm13
     d20:	0f 86 3a ff ff ff    	jbe    c60 <mesh_packet+0x460>
     d26:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # d2e <mesh_packet+0x52e>
     d2d:	00 
			d2a: R_X86_64_PC32	.LC1-0x4
     d2e:	0f 2e d8             	ucomiss %xmm0,%xmm3
     d31:	0f 82 29 ff ff ff    	jb     c60 <mesh_packet+0x460>
     d37:	f3 44 0f 10 a4 24 88 	movss  0x88(%rsp),%xmm12
     d3e:	00 00 00 
     d41:	f3 0f 10 4c 24 40    	movss  0x40(%rsp),%xmm1
     d47:	44 0f 28 9c 24 00 01 	movaps 0x100(%rsp),%xmm11
     d4e:	00 00 
     d50:	f3 0f 10 6c 24 58    	movss  0x58(%rsp),%xmm5
     d56:	f3 41 0f 5e cc       	divss  %xmm12,%xmm1
     d5b:	44 0f 29 5c 24 40    	movaps %xmm11,0x40(%rsp)
     d61:	f3 41 0f 5e ec       	divss  %xmm12,%xmm5
     d66:	0f 28 c1             	movaps %xmm1,%xmm0
     d69:	f3 0f 10 4c 24 50    	movss  0x50(%rsp),%xmm1
     d6f:	0f 28 d8             	movaps %xmm0,%xmm3
     d72:	f3 0f 59 d8          	mulss  %xmm0,%xmm3
     d76:	f3 41 0f 5e cc       	divss  %xmm12,%xmm1
     d7b:	0f 28 f1             	movaps %xmm1,%xmm6
     d7e:	0f 28 f9             	movaps %xmm1,%xmm7
     d81:	f3 0f 59 f1          	mulss  %xmm1,%xmm6
     d85:	66 41 0f 6e cf       	movd   %r15d,%xmm1
     d8a:	f3 41 0f 5e cd       	divss  %xmm13,%xmm1
     d8f:	44 0f 28 e6          	movaps %xmm6,%xmm12
     d93:	0f 28 f0             	movaps %xmm0,%xmm6
     d96:	f3 44 0f 58 e3       	addss  %xmm3,%xmm12
     d9b:	0f 28 dd             	movaps %xmm5,%xmm3
     d9e:	f3 0f 59 dd          	mulss  %xmm5,%xmm3
     da2:	f3 44 0f 58 e3       	addss  %xmm3,%xmm12
     da7:	66 41 0f 6e dd       	movd   %r13d,%xmm3
     dac:	f3 41 0f 5e dd       	divss  %xmm13,%xmm3
     db1:	f3 45 0f 51 e4       	sqrtss %xmm12,%xmm12
     db6:	f3 41 0f 5e fc       	divss  %xmm12,%xmm7
     dbb:	0f 28 c3             	movaps %xmm3,%xmm0
     dbe:	f3 0f 59 c3          	mulss  %xmm3,%xmm0
     dc2:	f3 41 0f 5e f4       	divss  %xmm12,%xmm6
     dc7:	f3 0f 11 bc 24 90 00 	movss  %xmm7,0x90(%rsp)
     dce:	00 00 
     dd0:	f3 41 0f 5e ec       	divss  %xmm12,%xmm5
     dd5:	f3 44 0f 10 64 24 78 	movss  0x78(%rsp),%xmm12
     ddc:	f3 0f 11 b4 24 8c 00 	movss  %xmm6,0x8c(%rsp)
     de3:	00 00 
     de5:	f3 45 0f 5e e5       	divss  %xmm13,%xmm12
     dea:	f3 0f 11 ac 24 94 00 	movss  %xmm5,0x94(%rsp)
     df1:	00 00 
     df3:	45 0f 28 ec          	movaps %xmm12,%xmm13
     df7:	f3 45 0f 59 ec       	mulss  %xmm12,%xmm13
     dfc:	f3 41 0f 58 c5       	addss  %xmm13,%xmm0
     e01:	44 0f 28 e9          	movaps %xmm1,%xmm13
     e05:	f3 44 0f 59 e9       	mulss  %xmm1,%xmm13
     e0a:	f3 41 0f 58 c5       	addss  %xmm13,%xmm0
     e0f:	f3 0f 51 c0          	sqrtss %xmm0,%xmm0
     e13:	f3 0f 5e d8          	divss  %xmm0,%xmm3
     e17:	f3 44 0f 5e e0       	divss  %xmm0,%xmm12
     e1c:	f3 0f 5e c8          	divss  %xmm0,%xmm1
     e20:	f3 44 0f 58 e6       	addss  %xmm6,%xmm12
     e25:	0f 28 f3             	movaps %xmm3,%xmm6
     e28:	f3 0f 58 f7          	addss  %xmm7,%xmm6
     e2c:	f3 44 0f 11 64 24 60 	movss  %xmm12,0x60(%rsp)
     e33:	f3 0f 11 74 24 78    	movss  %xmm6,0x78(%rsp)
     e39:	f3 0f 58 cd          	addss  %xmm5,%xmm1
     e3d:	0f 28 e9             	movaps %xmm1,%xmm5
     e40:	0f 28 ce             	movaps %xmm6,%xmm1
     e43:	f3 0f 11 ac 24 88 00 	movss  %xmm5,0x88(%rsp)
     e4a:	00 00 
     e4c:	0f 28 c5             	movaps %xmm5,%xmm0
     e4f:	41 0f 54 cb          	andps  %xmm11,%xmm1
     e53:	41 0f 54 c3          	andps  %xmm11,%xmm0
     e57:	e8 00 00 00 00       	call   e5c <mesh_packet+0x65c>
			e58: R_X86_64_PLT32	fmaxf-0x4
     e5c:	44 0f 28 5c 24 40    	movaps 0x40(%rsp),%xmm11
     e62:	f3 0f 10 4c 24 60    	movss  0x60(%rsp),%xmm1
     e68:	41 0f 54 cb          	andps  %xmm11,%xmm1
     e6c:	e8 00 00 00 00       	call   e71 <mesh_packet+0x671>
			e6d: R_X86_64_PLT32	fmaxf-0x4
     e71:	66 0f ef ff          	pxor   %xmm7,%xmm7
     e75:	4c 8b 9c 24 18 01 00 	mov    0x118(%rsp),%r11
     e7c:	00 
     e7d:	f2 44 0f 10 b4 24 80 	movsd  0x80(%rsp),%xmm14
     e84:	00 00 00 
     e87:	f2 0f 10 94 24 98 00 	movsd  0x98(%rsp),%xmm2
     e8e:	00 00 
     e90:	0f 2f c7             	comiss %xmm7,%xmm0
     e93:	f2 44 0f 10 bc 24 a0 	movsd  0xa0(%rsp),%xmm15
     e9a:	00 00 00 
     e9d:	f2 44 0f 10 84 24 a8 	movsd  0xa8(%rsp),%xmm8
     ea4:	00 00 00 
     ea7:	f2 0f 10 ac 24 e0 00 	movsd  0xe0(%rsp),%xmm5
     eae:	00 00 
     eb0:	f2 44 0f 10 8c 24 b0 	movsd  0xb0(%rsp),%xmm9
     eb7:	00 00 00 
     eba:	f2 0f 10 b4 24 c0 00 	movsd  0xc0(%rsp),%xmm6
     ec1:	00 00 
     ec3:	f2 44 0f 10 94 24 d0 	movsd  0xd0(%rsp),%xmm10
     eca:	00 00 00 
     ecd:	f2 0f 10 bc 24 f8 00 	movsd  0xf8(%rsp),%xmm7
     ed4:	00 00 
     ed6:	f2 0f 10 a4 24 10 01 	movsd  0x110(%rsp),%xmm4
     edd:	00 00 
     edf:	0f 86 d3 0b 00 00    	jbe    1ab8 <mesh_packet+0x12b8>
     ee5:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # eed <mesh_packet+0x6ed>
     eec:	00 
			ee9: R_X86_64_PC32	.LC1-0x4
     eed:	c6 84 24 80 00 00 00 	movb   $0x0,0x80(%rsp)
     ef4:	00 
     ef5:	0f 2e d8             	ucomiss %xmm0,%xmm3
     ef8:	0f 83 13 0a 00 00    	jae    1911 <mesh_packet+0x1111>
     efe:	0f b7 84 24 30 01 00 	movzwl 0x130(%rsp),%eax
     f05:	00 
     f06:	4d 8d 96 64 04 00 00 	lea    0x464(%r14),%r10
     f0d:	89 84 24 98 00 00 00 	mov    %eax,0x98(%rsp)
     f14:	01 c0                	add    %eax,%eax
     f16:	80 bc 24 f4 00 00 00 	cmpb   $0x0,0xf4(%rsp)
     f1d:	00 
     f1e:	89 c0                	mov    %eax,%eax
     f20:	48 89 84 24 38 01 00 	mov    %rax,0x138(%rsp)
     f27:	00 
     f28:	48 89 c2             	mov    %rax,%rdx
     f2b:	49 8d 04 82          	lea    (%r10,%rax,4),%rax
     f2f:	48 89 84 24 18 01 00 	mov    %rax,0x118(%rsp)
     f36:	00 
     f37:	0f 84 76 06 00 00    	je     15b3 <mesh_packet+0xdb3>
     f3d:	8b b4 24 98 00 00 00 	mov    0x98(%rsp),%esi
     f44:	4d 8d 46 5c          	lea    0x5c(%r14),%r8
     f48:	85 f6                	test   %esi,%esi
     f4a:	0f 84 5e 0b 00 00    	je     1aae <mesh_packet+0x12ae>
     f50:	66 41 0f 28 c7       	movapd %xmm15,%xmm0
     f55:	66 0f 28 ca          	movapd %xmm2,%xmm1
     f59:	49 8d 43 64          	lea    0x64(%r11),%rax
     f5d:	45 31 ed             	xor    %r13d,%r13d
     f60:	f2 0f 59 cf          	mulsd  %xmm7,%xmm1
     f64:	66 41 0f 28 df       	movapd %xmm15,%xmm3
     f69:	4c 89 e6             	mov    %r12,%rsi
     f6c:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
     f71:	f2 41 0f 59 c2       	mulsd  %xmm10,%xmm0
     f76:	8b 84 24 98 00 00 00 	mov    0x98(%rsp),%eax
     f7d:	4c 89 94 24 f8 00 00 	mov    %r10,0xf8(%rsp)
     f84:	00 
     f85:	f2 0f 59 de          	mulsd  %xmm6,%xmm3
     f89:	4c 89 b4 24 28 01 00 	mov    %r14,0x128(%rsp)
     f90:	00 
     f91:	f2 41 0f 59 fe       	mulsd  %xmm14,%xmm7
     f96:	01 d0                	add    %edx,%eax
     f98:	89 94 24 34 01 00 00 	mov    %edx,0x134(%rsp)
     f9f:	f2 0f 59 f2          	mulsd  %xmm2,%xmm6
     fa3:	8d 04 85 6b 04 00 00 	lea    0x46b(,%rax,4),%eax
     faa:	4c 89 9c 24 10 01 00 	mov    %r11,0x110(%rsp)
     fb1:	00 
     fb2:	f2 0f 11 a4 24 20 01 	movsd  %xmm4,0x120(%rsp)
     fb9:	00 00 
     fbb:	f2 45 0f 59 d6       	mulsd  %xmm14,%xmm10
     fc0:	89 c1                	mov    %eax,%ecx
     fc2:	48 8b 84 24 18 01 00 	mov    0x118(%rsp),%rax
     fc9:	00 
     fca:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
     fce:	f2 0f 10 0c 24       	movsd  (%rsp),%xmm1
     fd3:	81 e1 f8 ff 1f 00    	and    $0x1ffff8,%ecx
     fd9:	48 89 8c 24 00 01 00 	mov    %rcx,0x100(%rsp)
     fe0:	00 
     fe1:	f2 0f 5c fb          	subsd  %xmm3,%xmm7
     fe5:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
     fea:	66 0f 14 c8          	unpcklpd %xmm0,%xmm1
     fee:	66 0f 28 c4          	movapd %xmm4,%xmm0
     ff2:	66 0f 14 c0          	unpcklpd %xmm0,%xmm0
     ff6:	f2 41 0f 5c f2       	subsd  %xmm10,%xmm6
     ffb:	66 0f 5e c8          	divpd  %xmm0,%xmm1
     fff:	0f 29 8c 24 b0 00 00 	movaps %xmm1,0xb0(%rsp)
    1006:	00 
    1007:	f2 0f 10 4c 24 30    	movsd  0x30(%rsp),%xmm1
    100d:	f2 0f 5c 4c 24 20    	subsd  0x20(%rsp),%xmm1
    1013:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
    1018:	66 0f 14 cf          	unpcklpd %xmm7,%xmm1
    101c:	66 0f 5e c8          	divpd  %xmm0,%xmm1
    1020:	0f 29 8c 24 c0 00 00 	movaps %xmm1,0xc0(%rsp)
    1027:	00 
    1028:	f2 0f 10 4c 24 38    	movsd  0x38(%rsp),%xmm1
    102e:	66 0f 14 ce          	unpcklpd %xmm6,%xmm1
    1032:	66 0f 5e c8          	divpd  %xmm0,%xmm1
    1036:	66 0f 28 c2          	movapd %xmm2,%xmm0
    103a:	f2 41 0f 59 c1       	mulsd  %xmm9,%xmm0
    103f:	f2 45 0f 59 ce       	mulsd  %xmm14,%xmm9
    1044:	0f 29 8c 24 d0 00 00 	movaps %xmm1,0xd0(%rsp)
    104b:	00 
    104c:	66 41 0f 28 cf       	movapd %xmm15,%xmm1
    1051:	f2 0f 59 cd          	mulsd  %xmm5,%xmm1
    1055:	f2 41 0f 59 ee       	mulsd  %xmm14,%xmm5
    105a:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    105e:	f2 0f 5e c4          	divsd  %xmm4,%xmm0
    1062:	f2 0f 11 84 24 a0 00 	movsd  %xmm0,0xa0(%rsp)
    1069:	00 00 
    106b:	66 41 0f 28 c7       	movapd %xmm15,%xmm0
    1070:	f2 41 0f 59 c0       	mulsd  %xmm8,%xmm0
    1075:	f2 44 0f 59 c2       	mulsd  %xmm2,%xmm8
    107a:	f2 41 0f 5c c1       	subsd  %xmm9,%xmm0
    107f:	f2 41 0f 5c e8       	subsd  %xmm8,%xmm5
    1084:	f2 0f 5e c4          	divsd  %xmm4,%xmm0
    1088:	f2 0f 5e ec          	divsd  %xmm4,%xmm5
    108c:	f2 0f 11 84 24 a8 00 	movsd  %xmm0,0xa8(%rsp)
    1093:	00 00 
    1095:	f2 0f 11 ac 24 e0 00 	movsd  %xmm5,0xe0(%rsp)
    109c:	00 00 
    109e:	66 90                	xchg   %ax,%ax
    10a0:	0f b7 03             	movzwl (%rbx),%eax
    10a3:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
    10a8:	44 01 e8             	add    %r13d,%eax
    10ab:	8b 51 5c             	mov    0x5c(%rcx),%edx
    10ae:	6b c0 1c             	imul   $0x1c,%eax,%eax
    10b1:	48 01 d0             	add    %rdx,%rax
    10b4:	48 01 c6             	add    %rax,%rsi
    10b7:	80 7c 24 77 00       	cmpb   $0x0,0x77(%rsp)
    10bc:	75 53                	jne    1111 <mesh_packet+0x911>
    10be:	48 8b bc 24 f8 00 00 	mov    0xf8(%rsp),%rdi
    10c5:	00 
    10c6:	43 8d 44 2d 01       	lea    0x1(%r13,%r13,1),%eax
    10cb:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
    10d0:	48 c1 e0 02          	shl    $0x2,%rax
    10d4:	48 8d 0c 07          	lea    (%rdi,%rax,1),%rcx
    10d8:	48 8d 54 07 fc       	lea    -0x4(%rdi,%rax,1),%rdx
    10dd:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
    10e4:	00 
    10e5:	e8 a6 ef ff ff       	call   90 <mesh_project>
    10ea:	84 c0                	test   %al,%al
    10ec:	0f 84 6e fb ff ff    	je     c60 <mesh_packet+0x460>
    10f2:	f3 0f 10 02          	movss  (%rdx),%xmm0
    10f6:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
    10fb:	f3 0f 11 00          	movss  %xmm0,(%rax)
    10ff:	f3 0f 10 01          	movss  (%rcx),%xmm0
    1103:	48 89 c1             	mov    %rax,%rcx
    1106:	f3 0f 11 40 04       	movss  %xmm0,0x4(%rax)
    110b:	8b 46 18             	mov    0x18(%rsi),%eax
    110e:	89 41 08             	mov    %eax,0x8(%rcx)
    1111:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1115:	66 0f ef db          	pxor   %xmm3,%xmm3
    1119:	66 0f ef c9          	pxor   %xmm1,%xmm1
    111d:	f3 0f 5a 46 0c       	cvtss2sd 0xc(%rsi),%xmm0
    1122:	f3 0f 5a 5e 10       	cvtss2sd 0x10(%rsi),%xmm3
    1127:	66 0f 28 d0          	movapd %xmm0,%xmm2
    112b:	66 0f 28 e3          	movapd %xmm3,%xmm4
    112f:	66 0f 14 d2          	unpcklpd %xmm2,%xmm2
    1133:	66 0f 14 e4          	unpcklpd %xmm4,%xmm4
    1137:	f3 0f 5a 4e 14       	cvtss2sd 0x14(%rsi),%xmm1
    113c:	66 0f 59 a4 24 c0 00 	mulpd  0xc0(%rsp),%xmm4
    1143:	00 00 
    1145:	66 0f 59 94 24 b0 00 	mulpd  0xb0(%rsp),%xmm2
    114c:	00 00 
    114e:	f2 0f 59 9c 24 a8 00 	mulsd  0xa8(%rsp),%xmm3
    1155:	00 00 
    1157:	f2 0f 59 84 24 a0 00 	mulsd  0xa0(%rsp),%xmm0
    115e:	00 00 
    1160:	66 0f 58 d4          	addpd  %xmm4,%xmm2
    1164:	66 0f 28 e1          	movapd %xmm1,%xmm4
    1168:	f2 0f 59 8c 24 e0 00 	mulsd  0xe0(%rsp),%xmm1
    116f:	00 00 
    1171:	66 0f 14 e4          	unpcklpd %xmm4,%xmm4
    1175:	66 0f 59 a4 24 d0 00 	mulpd  0xd0(%rsp),%xmm4
    117c:	00 00 
    117e:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    1182:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    1186:	66 0f 58 d4          	addpd  %xmm4,%xmm2
    118a:	66 49 0f 7e c4       	movq   %xmm0,%r12
    118f:	66 0f 28 ea          	movapd %xmm2,%xmm5
    1193:	66 0f 28 c2          	movapd %xmm2,%xmm0
    1197:	0f 29 14 24          	movaps %xmm2,(%rsp)
    119b:	66 0f 15 ed          	unpckhpd %xmm5,%xmm5
    119f:	66 0f 28 cd          	movapd %xmm5,%xmm1
    11a3:	e8 00 00 00 00       	call   11a8 <mesh_packet+0x9a8>
			11a4: R_X86_64_PLT32	hypot-0x4
    11a8:	66 49 0f 6e cc       	movq   %r12,%xmm1
    11ad:	e8 00 00 00 00       	call   11b2 <mesh_packet+0x9b2>
			11ae: R_X86_64_PLT32	hypot-0x4
    11b2:	66 0f 28 d8          	movapd %xmm0,%xmm3
    11b6:	66 0f ef c0          	pxor   %xmm0,%xmm0
    11ba:	66 0f 2f d8          	comisd %xmm0,%xmm3
    11be:	0f 86 9c fa ff ff    	jbe    c60 <mesh_packet+0x460>
    11c4:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 11cc <mesh_packet+0x9cc>
    11cb:	00 
			11c8: R_X86_64_PC32	.LC22-0x4
    11cc:	66 0f 2e f3          	ucomisd %xmm3,%xmm6
    11d0:	0f 82 8a fa ff ff    	jb     c60 <mesh_packet+0x460>
    11d6:	66 0f 28 14 24       	movapd (%rsp),%xmm2
    11db:	45 31 ff             	xor    %r15d,%r15d
    11de:	4c 89 a4 24 a0 03 00 	mov    %r12,0x3a0(%rsp)
    11e5:	00 
    11e6:	4c 8d b4 24 90 03 00 	lea    0x390(%rsp),%r14
    11ed:	00 
    11ee:	4c 8d a4 24 d0 01 00 	lea    0x1d0(%rsp),%r12
    11f5:	00 
    11f6:	f2 0f 11 1c 24       	movsd  %xmm3,(%rsp)
    11fb:	0f 29 94 24 90 03 00 	movaps %xmm2,0x390(%rsp)
    1202:	00 
    1203:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 120b <mesh_packet+0xa0b>
    120a:	00 
			1207: R_X86_64_PC32	.LC24-0x4
    120b:	f2 43 0f 59 04 fe    	mulsd  (%r14,%r15,8),%xmm0
    1211:	f2 0f 5e 04 24       	divsd  (%rsp),%xmm0
    1216:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 121e <mesh_packet+0xa1e>
    121d:	00 
			121a: R_X86_64_PC32	.LC6-0x4
    121e:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 1226 <mesh_packet+0xa26>
    1225:	00 
			1222: R_X86_64_PC32	.LC13-0x4
    1226:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 122e <mesh_packet+0xa2e>
    122d:	00 
			122a: R_X86_64_PC32	.LC7-0x4
    122e:	66 0f 54 c8          	andpd  %xmm0,%xmm1
    1232:	66 0f 2e f1          	ucomisd %xmm1,%xmm6
    1236:	76 3b                	jbe    1273 <mesh_packet+0xa73>
    1238:	f2 48 0f 2c c0       	cvttsd2si %xmm0,%rax
    123d:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1241:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 1249 <mesh_packet+0xa49>
    1248:	00 
			1245: R_X86_64_PC32	.LC9-0x4
    1249:	f2 48 0f 2a c8       	cvtsi2sd %rax,%xmm1
    124e:	66 0f 28 d1          	movapd %xmm1,%xmm2
    1252:	f2 0f c2 d0 06       	cmpnlesd %xmm0,%xmm2
    1257:	66 0f 54 d5          	andpd  %xmm5,%xmm2
    125b:	f2 0f 5c ca          	subsd  %xmm2,%xmm1
    125f:	f2 0f 10 15 00 00 00 	movsd  0x0(%rip),%xmm2        # 1267 <mesh_packet+0xa67>
    1266:	00 
			1263: R_X86_64_PC32	.LC13-0x4
    1267:	66 0f 55 d0          	andnpd %xmm0,%xmm2
    126b:	66 0f 56 ca          	orpd   %xmm2,%xmm1
    126f:	66 0f 28 c1          	movapd %xmm1,%xmm0
    1273:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 127b <mesh_packet+0xa7b>
    127a:	00 
			1277: R_X86_64_PC32	.LC24-0x4
    127b:	e8 00 00 00 00       	call   1280 <mesh_packet+0xa80>
			127c: R_X86_64_PLT32	fmin-0x4
    1280:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 1288 <mesh_packet+0xa88>
    1287:	00 
			1284: R_X86_64_PC32	.LC25-0x4
    1288:	e8 00 00 00 00       	call   128d <mesh_packet+0xa8d>
			1289: R_X86_64_PLT32	fmax-0x4
    128d:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    1291:	66 43 89 04 7c       	mov    %ax,(%r12,%r15,2)
    1296:	49 83 c7 01          	add    $0x1,%r15
    129a:	49 83 ff 03          	cmp    $0x3,%r15
    129e:	0f 85 5f ff ff ff    	jne    1203 <mesh_packet+0xa03>
    12a4:	0f b7 84 24 d0 01 00 	movzwl 0x1d0(%rsp),%eax
    12ab:	00 
    12ac:	66 0b 84 24 d2 01 00 	or     0x1d2(%rsp),%ax
    12b3:	00 
    12b4:	66 0b 84 24 d4 01 00 	or     0x1d4(%rsp),%ax
    12bb:	00 
    12bc:	0f 84 9e f9 ff ff    	je     c60 <mesh_packet+0x460>
    12c2:	44 8b 44 24 28       	mov    0x28(%rsp),%r8d
    12c7:	45 85 c0             	test   %r8d,%r8d
    12ca:	0f 85 18 02 00 00    	jne    14e8 <mesh_packet+0xce8>
    12d0:	f3 0f 10 84 24 8c 00 	movss  0x8c(%rsp),%xmm0
    12d7:	00 00 
    12d9:	f3 0f 10 64 24 78    	movss  0x78(%rsp),%xmm4
    12df:	4c 89 e7             	mov    %r12,%rdi
    12e2:	4c 8d b4 24 40 01 00 	lea    0x140(%rsp),%r14
    12e9:	00 
    12ea:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
    12f1:	00 
    12f2:	0f b6 73 12          	movzbl 0x12(%rbx),%esi
    12f6:	4c 89 f2             	mov    %r14,%rdx
    12f9:	f3 0f 10 ac 24 88 00 	movss  0x88(%rsp),%xmm5
    1300:	00 00 
    1302:	f3 0f 10 5c 24 60    	movss  0x60(%rsp),%xmm3
    1308:	f3 0f 10 8c 24 90 00 	movss  0x90(%rsp),%xmm1
    130f:	00 00 
    1311:	f3 0f 10 94 24 94 00 	movss  0x94(%rsp),%xmm2
    1318:	00 00 
    131a:	e8 c1 f1 ff ff       	call   4e0 <ayatsuri_shade_terms_prepare.isra.0>
    131f:	4c 8b 7c 24 50       	mov    0x50(%rsp),%r15
    1324:	0f b7 7b 0e          	movzwl 0xe(%rbx),%edi
    1328:	66 48 0f 7e c0       	movq   %xmm0,%rax
    132d:	66 48 0f 7e ca       	movq   %xmm1,%rdx
    1332:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
    1337:	66 0f 6e d2          	movd   %edx,%xmm2
    133b:	48 c1 e8 20          	shr    $0x20,%rax
    133f:	4c 89 fe             	mov    %r15,%rsi
    1342:	48 c1 ea 20          	shr    $0x20,%rdx
    1346:	66 0f 6e c8          	movd   %eax,%xmm1
    134a:	f3 0f 11 54 24 38    	movss  %xmm2,0x38(%rsp)
    1350:	66 0f 6e da          	movd   %edx,%xmm3
    1354:	89 54 24 40          	mov    %edx,0x40(%rsp)
    1358:	4c 89 f2             	mov    %r14,%rdx
    135b:	89 44 24 30          	mov    %eax,0x30(%rsp)
    135f:	e8 9c ef ff ff       	call   300 <ayatsuri_shade_from_terms.isra.0>
    1364:	0f b7 7b 10          	movzwl 0x10(%rbx),%edi
    1368:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
    136d:	4c 89 f2             	mov    %r14,%rdx
    1370:	f3 0f 10 5c 24 40    	movss  0x40(%rsp),%xmm3
    1376:	f3 0f 10 54 24 38    	movss  0x38(%rsp),%xmm2
    137c:	4c 89 fe             	mov    %r15,%rsi
    137f:	66 89 c5             	mov    %ax,%bp
    1382:	f3 0f 10 4c 24 30    	movss  0x30(%rsp),%xmm1
    1388:	0f b7 ed             	movzwl %bp,%ebp
    138b:	e8 70 ef ff ff       	call   300 <ayatsuri_shade_from_terms.isra.0>
    1390:	8b 7c 24 28          	mov    0x28(%rsp),%edi
    1394:	c1 e0 10             	shl    $0x10,%eax
    1397:	09 c5                	or     %eax,%ebp
    1399:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
    139e:	89 68 0c             	mov    %ebp,0xc(%rax)
    13a1:	85 ff                	test   %edi,%edi
    13a3:	75 33                	jne    13d8 <mesh_packet+0xbd8>
    13a5:	8b 84 24 98 00 00 00 	mov    0x98(%rsp),%eax
    13ac:	41 83 c5 01          	add    $0x1,%r13d
    13b0:	48 83 44 24 20 10    	addq   $0x10,0x20(%rsp)
    13b6:	48 83 44 24 58 04    	addq   $0x4,0x58(%rsp)
    13bc:	41 39 c5             	cmp    %eax,%r13d
    13bf:	0f 83 4d 02 00 00    	jae    1612 <mesh_packet+0xe12>
    13c5:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    13ca:	48 8b 30             	mov    (%rax),%rsi
    13cd:	e9 ce fc ff ff       	jmp    10a0 <mesh_packet+0x8a0>
    13d2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    13d8:	48 8b 84 24 10 01 00 	mov    0x110(%rsp),%rax
    13df:	00 
    13e0:	f3 0f 10 64 24 78    	movss  0x78(%rsp),%xmm4
    13e6:	48 8d bc 24 10 02 00 	lea    0x210(%rsp),%rdi
    13ed:	00 
    13ee:	48 8b 8c 24 00 01 00 	mov    0x100(%rsp),%rcx
    13f5:	00 
    13f6:	0f b6 73 12          	movzbl 0x12(%rbx),%esi
    13fa:	48 8b 50 08          	mov    0x8(%rax),%rdx
    13fe:	f3 0f 10 5c 24 60    	movss  0x60(%rsp),%xmm3
    1404:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
    140b:	00 
    140c:	f3 0f 10 84 24 8c 00 	movss  0x8c(%rsp),%xmm0
    1413:	00 00 
    1415:	f3 0f 10 ac 24 88 00 	movss  0x88(%rsp),%xmm5
    141c:	00 00 
    141e:	f3 0f 10 8c 24 90 00 	movss  0x90(%rsp),%xmm1
    1425:	00 00 
    1427:	f3 0f 10 94 24 94 00 	movss  0x94(%rsp),%xmm2
    142e:	00 00 
    1430:	8b 44 02 08          	mov    0x8(%rdx,%rax,1),%eax
    1434:	48 01 c8             	add    %rcx,%rax
    1437:	43 8d 4c 2d 00       	lea    0x0(%r13,%r13,1),%ecx
    143c:	48 8d 04 48          	lea    (%rax,%rcx,2),%rax
    1440:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
    1447:	00 
    1448:	4c 8d 24 02          	lea    (%rdx,%rax,1),%r12
    144c:	4c 89 f2             	mov    %r14,%rdx
    144f:	e8 8c f0 ff ff       	call   4e0 <ayatsuri_shade_terms_prepare.isra.0>
    1454:	0f b7 7b 0e          	movzwl 0xe(%rbx),%edi
    1458:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
    145d:	66 48 0f 7e c0       	movq   %xmm0,%rax
    1462:	66 48 0f 7e ca       	movq   %xmm1,%rdx
    1467:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
    146c:	66 0f 6e d2          	movd   %edx,%xmm2
    1470:	48 c1 e8 20          	shr    $0x20,%rax
    1474:	48 c1 ea 20          	shr    $0x20,%rdx
    1478:	66 0f 6e c8          	movd   %eax,%xmm1
    147c:	f3 0f 11 54 24 38    	movss  %xmm2,0x38(%rsp)
    1482:	66 0f 6e da          	movd   %edx,%xmm3
    1486:	89 54 24 40          	mov    %edx,0x40(%rsp)
    148a:	4c 89 f2             	mov    %r14,%rdx
    148d:	89 44 24 30          	mov    %eax,0x30(%rsp)
    1491:	e8 6a ee ff ff       	call   300 <ayatsuri_shade_from_terms.isra.0>
    1496:	44 8b bc 24 f0 00 00 	mov    0xf0(%rsp),%r15d
    149d:	00 
    149e:	0f b7 7b 10          	movzwl 0x10(%rbx),%edi
    14a2:	4c 89 f2             	mov    %r14,%rdx
    14a5:	f3 0f 10 5c 24 40    	movss  0x40(%rsp),%xmm3
    14ab:	f3 0f 10 54 24 38    	movss  0x38(%rsp),%xmm2
    14b1:	f3 0f 10 4c 24 30    	movss  0x30(%rsp),%xmm1
    14b7:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
    14bc:	66 41 89 c7          	mov    %ax,%r15w
    14c0:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
    14c5:	e8 36 ee ff ff       	call   300 <ayatsuri_shade_from_terms.isra.0>
    14ca:	41 0f b7 d7          	movzwl %r15w,%edx
    14ce:	c1 e0 10             	shl    $0x10,%eax
    14d1:	09 c2                	or     %eax,%edx
    14d3:	89 94 24 f0 00 00 00 	mov    %edx,0xf0(%rsp)
    14da:	41 89 14 24          	mov    %edx,(%r12)
    14de:	e9 c2 fe ff ff       	jmp    13a5 <mesh_packet+0xba5>
    14e3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    14e8:	31 c0                	xor    %eax,%eax
    14ea:	48 8d bc 24 10 02 00 	lea    0x210(%rsp),%rdi
    14f1:	00 
    14f2:	48 89 5c 24 30       	mov    %rbx,0x30(%rsp)
    14f7:	4c 89 f3             	mov    %r14,%rbx
    14fa:	49 89 ff             	mov    %rdi,%r15
    14fd:	49 89 c6             	mov    %rax,%r14
    1500:	f2 42 0f 10 04 f3    	movsd  (%rbx,%r14,8),%xmm0
    1506:	66 0f 57 05 00 00 00 	xorpd  0x0(%rip),%xmm0        # 150e <mesh_packet+0xd0e>
    150d:	00 
			150a: R_X86_64_PC32	.LC26-0x4
    150e:	f2 0f 59 05 00 00 00 	mulsd  0x0(%rip),%xmm0        # 1516 <mesh_packet+0xd16>
    1515:	00 
			1512: R_X86_64_PC32	.LC24-0x4
    1516:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 151e <mesh_packet+0xd1e>
    151d:	00 
			151a: R_X86_64_PC32	.LC13-0x4
    151e:	f2 0f 5e 04 24       	divsd  (%rsp),%xmm0
    1523:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 152b <mesh_packet+0xd2b>
    152a:	00 
			1527: R_X86_64_PC32	.LC6-0x4
    152b:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 1533 <mesh_packet+0xd33>
    1532:	00 
			152f: R_X86_64_PC32	.LC7-0x4
    1533:	66 0f 54 c8          	andpd  %xmm0,%xmm1
    1537:	66 0f 2e f9          	ucomisd %xmm1,%xmm7
    153b:	76 3b                	jbe    1578 <mesh_packet+0xd78>
    153d:	f2 48 0f 2c c0       	cvttsd2si %xmm0,%rax
    1542:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1546:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 154e <mesh_packet+0xd4e>
    154d:	00 
			154a: R_X86_64_PC32	.LC9-0x4
    154e:	f2 48 0f 2a c8       	cvtsi2sd %rax,%xmm1
    1553:	66 0f 28 d1          	movapd %xmm1,%xmm2
    1557:	f2 0f c2 d0 06       	cmpnlesd %xmm0,%xmm2
    155c:	66 0f 54 d6          	andpd  %xmm6,%xmm2
    1560:	f2 0f 5c ca          	subsd  %xmm2,%xmm1
    1564:	f2 0f 10 15 00 00 00 	movsd  0x0(%rip),%xmm2        # 156c <mesh_packet+0xd6c>
    156b:	00 
			1568: R_X86_64_PC32	.LC13-0x4
    156c:	66 0f 55 d0          	andnpd %xmm0,%xmm2
    1570:	66 0f 56 ca          	orpd   %xmm2,%xmm1
    1574:	66 0f 28 c1          	movapd %xmm1,%xmm0
    1578:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 1580 <mesh_packet+0xd80>
    157f:	00 
			157c: R_X86_64_PC32	.LC24-0x4
    1580:	e8 00 00 00 00       	call   1585 <mesh_packet+0xd85>
			1581: R_X86_64_PLT32	fmin-0x4
    1585:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 158d <mesh_packet+0xd8d>
    158c:	00 
			1589: R_X86_64_PC32	.LC25-0x4
    158d:	e8 00 00 00 00       	call   1592 <mesh_packet+0xd92>
			158e: R_X86_64_PLT32	fmax-0x4
    1592:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    1596:	66 43 89 04 77       	mov    %ax,(%r15,%r14,2)
    159b:	49 83 c6 01          	add    $0x1,%r14
    159f:	49 83 fe 03          	cmp    $0x3,%r14
    15a3:	0f 85 57 ff ff ff    	jne    1500 <mesh_packet+0xd00>
    15a9:	48 8b 5c 24 30       	mov    0x30(%rsp),%rbx
    15ae:	e9 1d fd ff ff       	jmp    12d0 <mesh_packet+0xad0>
    15b3:	4d 8d 46 5c          	lea    0x5c(%r14),%r8
    15b7:	44 89 f0             	mov    %r14d,%eax
    15ba:	49 c7 46 54 00 00 00 	movq   $0x0,0x54(%r14)
    15c1:	00 
    15c2:	49 c7 86 5c 04 00 00 	movq   $0x0,0x45c(%r14)
    15c9:	00 00 00 00 
    15cd:	4c 89 c7             	mov    %r8,%rdi
    15d0:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
    15d4:	29 f8                	sub    %edi,%eax
    15d6:	8d 88 64 04 00 00    	lea    0x464(%rax),%ecx
    15dc:	31 c0                	xor    %eax,%eax
    15de:	c1 e9 03             	shr    $0x3,%ecx
    15e1:	f3 48 ab             	rep stos %rax,%es:(%rdi)
    15e4:	0f b6 84 24 30 01 00 	movzbl 0x130(%rsp),%eax
    15eb:	00 
    15ec:	44 8b 8c 24 98 00 00 	mov    0x98(%rsp),%r9d
    15f3:	00 
    15f4:	41 88 46 54          	mov    %al,0x54(%r14)
    15f8:	0f b6 43 0a          	movzbl 0xa(%rbx),%eax
    15fc:	41 88 46 56          	mov    %al,0x56(%r14)
    1600:	45 85 c9             	test   %r9d,%r9d
    1603:	74 43                	je     1648 <mesh_packet+0xe48>
    1605:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    160a:	4c 8b 20             	mov    (%rax),%r12
    160d:	e9 3e f9 ff ff       	jmp    f50 <mesh_packet+0x750>
    1612:	80 bc 24 f4 00 00 00 	cmpb   $0x0,0xf4(%rsp)
    1619:	00 
    161a:	4c 8b 94 24 f8 00 00 	mov    0xf8(%rsp),%r10
    1621:	00 
    1622:	f2 0f 10 a4 24 20 01 	movsd  0x120(%rsp),%xmm4
    1629:	00 00 
    162b:	4c 8b b4 24 28 01 00 	mov    0x128(%rsp),%r14
    1632:	00 
    1633:	4c 8b 9c 24 10 01 00 	mov    0x110(%rsp),%r11
    163a:	00 
    163b:	8b 94 24 34 01 00 00 	mov    0x134(%rsp),%edx
    1642:	0f 85 66 04 00 00    	jne    1aae <mesh_packet+0x12ae>
    1648:	44 0f b7 84 24 32 01 	movzwl 0x132(%rsp),%r8d
    164f:	00 00 
    1651:	45 85 c0             	test   %r8d,%r8d
    1654:	74 59                	je     16af <mesh_packet+0xeaf>
    1656:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    165b:	31 ff                	xor    %edi,%edi
    165d:	48 8b 28             	mov    (%rax),%rbp
    1660:	44 8b 48 64          	mov    0x64(%rax),%r9d
    1664:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    166b:	00 00 00 00 
    166f:	90                   	nop
    1670:	8d 34 7f             	lea    (%rdi,%rdi,2),%esi
    1673:	31 c9                	xor    %ecx,%ecx
    1675:	0f b7 43 04          	movzwl 0x4(%rbx),%eax
    1679:	01 f8                	add    %edi,%eax
    167b:	8d 04 40             	lea    (%rax,%rax,2),%eax
    167e:	44 8d 24 00          	lea    (%rax,%rax,1),%r12d
    1682:	48 8d 44 0d 00       	lea    0x0(%rbp,%rcx,1),%rax
    1687:	48 83 c1 02          	add    $0x2,%rcx
    168b:	4c 01 c8             	add    %r9,%rax
    168e:	46 0f b7 24 20       	movzwl (%rax,%r12,1),%r12d
    1693:	89 f0                	mov    %esi,%eax
    1695:	83 c6 01             	add    $0x1,%esi
    1698:	66 44 89 a4 44 10 02 	mov    %r12w,0x210(%rsp,%rax,2)
    169f:	00 00 
    16a1:	48 83 f9 06          	cmp    $0x6,%rcx
    16a5:	75 ce                	jne    1675 <mesh_packet+0xe75>
    16a7:	83 c7 01             	add    $0x1,%edi
    16aa:	41 39 f8             	cmp    %edi,%r8d
    16ad:	75 c1                	jne    1670 <mesh_packet+0xe70>
    16af:	8b 4c 24 28          	mov    0x28(%rsp),%ecx
    16b3:	44 0f b6 7b 0b       	movzbl 0xb(%rbx),%r15d
    16b8:	85 c9                	test   %ecx,%ecx
    16ba:	0f 84 05 04 00 00    	je     1ac5 <mesh_packet+0x12c5>
    16c0:	49 8b 4b 08          	mov    0x8(%r11),%rcx
    16c4:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
    16cb:	00 
    16cc:	66 0f ef c0          	pxor   %xmm0,%xmm0
    16d0:	48 8b bc 24 38 01 00 	mov    0x138(%rsp),%rdi
    16d7:	00 
    16d8:	8b 44 01 08          	mov    0x8(%rcx,%rax,1),%eax
    16dc:	48 8d 04 78          	lea    (%rax,%rdi,2),%rax
    16e0:	8b bc 24 98 00 00 00 	mov    0x98(%rsp),%edi
    16e7:	01 fa                	add    %edi,%edx
    16e9:	8d 14 95 6b 04 00 00 	lea    0x46b(,%rdx,4),%edx
    16f0:	81 e2 f8 ff 1f 00    	and    $0x1ffff8,%edx
    16f6:	48 01 d0             	add    %rdx,%rax
    16f9:	66 0f 2f c4          	comisd %xmm4,%xmm0
    16fd:	48 8d 3c 01          	lea    (%rcx,%rax,1),%rdi
    1701:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
    1708:	0f 97 04 24          	seta   (%rsp)
    170c:	0f b6 14 24          	movzbl (%rsp),%edx
    1710:	45 85 c0             	test   %r8d,%r8d
    1713:	0f 84 25 05 00 00    	je     1c3e <mesh_packet+0x143e>
    1719:	4c 8d 8c 24 10 02 00 	lea    0x210(%rsp),%r9
    1720:	00 
    1721:	48 89 3c 24          	mov    %rdi,(%rsp)
    1725:	31 f6                	xor    %esi,%esi
    1727:	31 c0                	xor    %eax,%eax
    1729:	48 89 5c 24 28       	mov    %rbx,0x28(%rsp)
    172e:	4c 89 c9             	mov    %r9,%rcx
    1731:	66 0f 28 e0          	movapd %xmm0,%xmm4
    1735:	f2 0f 10 1d 00 00 00 	movsd  0x0(%rip),%xmm3        # 173d <mesh_packet+0xf3d>
    173c:	00 
			1739: R_X86_64_PC32	.LC27-0x4
    173d:	4c 89 4c 24 30       	mov    %r9,0x30(%rsp)
    1742:	4c 8b 9c 24 18 01 00 	mov    0x118(%rsp),%r11
    1749:	00 
    174a:	4c 89 74 24 20       	mov    %r14,0x20(%rsp)
    174f:	41 89 d6             	mov    %edx,%r14d
    1752:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    1759:	00 00 00 00 
    175d:	0f 1f 00             	nopl   (%rax)
    1760:	0f b7 29             	movzwl (%rcx),%ebp
    1763:	0f b7 59 02          	movzwl 0x2(%rcx),%ebx
    1767:	66 0f ef ed          	pxor   %xmm5,%xmm5
    176b:	66 0f ef d2          	pxor   %xmm2,%xmm2
    176f:	44 0f b7 49 04       	movzwl 0x4(%rcx),%r9d
    1774:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1778:	66 0f ef c9          	pxor   %xmm1,%xmm1
    177c:	48 8d 54 2d 00       	lea    0x0(%rbp,%rbp,1),%rdx
    1781:	81 e2 fe ff 01 00    	and    $0x1fffe,%edx
    1787:	4b 8d 3c 09          	lea    (%r9,%r9,1),%rdi
    178b:	f3 41 0f 5a 54 92 04 	cvtss2sd 0x4(%r10,%rdx,4),%xmm2
    1792:	f3 41 0f 5a 2c 92    	cvtss2sd (%r10,%rdx,4),%xmm5
    1798:	48 8d 14 1b          	lea    (%rbx,%rbx,1),%rdx
    179c:	81 e7 fe ff 01 00    	and    $0x1fffe,%edi
    17a2:	81 e2 fe ff 01 00    	and    $0x1fffe,%edx
    17a8:	f3 41 0f 5a 44 ba 04 	cvtss2sd 0x4(%r10,%rdi,4),%xmm0
    17af:	f2 0f 5c c2          	subsd  %xmm2,%xmm0
    17b3:	f3 41 0f 5a 0c 92    	cvtss2sd (%r10,%rdx,4),%xmm1
    17b9:	f2 0f 5c cd          	subsd  %xmm5,%xmm1
    17bd:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    17c1:	66 0f ef c9          	pxor   %xmm1,%xmm1
    17c5:	f3 41 0f 5a 4c 92 04 	cvtss2sd 0x4(%r10,%rdx,4),%xmm1
    17cc:	f2 0f 5c ca          	subsd  %xmm2,%xmm1
    17d0:	66 0f ef d2          	pxor   %xmm2,%xmm2
    17d4:	f3 41 0f 5a 14 ba    	cvtss2sd (%r10,%rdi,4),%xmm2
    17da:	f2 0f 5c d5          	subsd  %xmm5,%xmm2
    17de:	f2 0f 59 ca          	mulsd  %xmm2,%xmm1
    17e2:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    17e6:	66 0f 28 c8          	movapd %xmm0,%xmm1
    17ea:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 17f2 <mesh_packet+0xff2>
    17f1:	00 
			17ee: R_X86_64_PC32	.LC8-0x4
    17f2:	66 0f 2f d9          	comisd %xmm1,%xmm3
    17f6:	73 5e                	jae    1856 <mesh_packet+0x1056>
    17f8:	66 0f 2f e0          	comisd %xmm0,%xmm4
    17fc:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1800:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1804:	44 89 f2             	mov    %r14d,%edx
    1807:	f3 41 0f 5a 0c 9b    	cvtss2sd (%r11,%rbx,4),%xmm1
    180d:	f3 41 0f 5a 04 ab    	cvtss2sd (%r11,%rbp,4),%xmm0
    1813:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    1817:	66 0f ef c9          	pxor   %xmm1,%xmm1
    181b:	f3 43 0f 5a 0c 8b    	cvtss2sd (%r11,%r9,4),%xmm1
    1821:	8d 58 01             	lea    0x1(%rax),%ebx
    1824:	40 0f 97 c7          	seta   %dil
    1828:	31 fa                	xor    %edi,%edx
    182a:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    182e:	01 d2                	add    %edx,%edx
    1830:	09 fa                	or     %edi,%edx
    1832:	88 94 34 d0 01 00 00 	mov    %dl,0x1d0(%rsp,%rsi,1)
    1839:	41 80 ff 01          	cmp    $0x1,%r15b
    183d:	0f 84 6f 03 00 00    	je     1bb2 <mesh_packet+0x13b2>
    1843:	40 88 b4 04 90 01 00 	mov    %sil,0x190(%rsp,%rax,1)
    184a:	00 
    184b:	f2 0f 11 84 c4 90 03 	movsd  %xmm0,0x390(%rsp,%rax,8)
    1852:	00 00 
    1854:	89 d8                	mov    %ebx,%eax
    1856:	48 83 c6 01          	add    $0x1,%rsi
    185a:	48 83 c1 06          	add    $0x6,%rcx
    185e:	44 39 c6             	cmp    %r8d,%esi
    1861:	0f 82 f9 fe ff ff    	jb     1760 <mesh_packet+0xf60>
    1867:	48 8b 3c 24          	mov    (%rsp),%rdi
    186b:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
    1870:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
    1875:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
    187a:	85 c0                	test   %eax,%eax
    187c:	0f 84 cf 03 00 00    	je     1c51 <mesh_packet+0x1451>
    1882:	49 8d b6 5c 02 00 00 	lea    0x25c(%r14),%rsi
    1889:	41 89 c3             	mov    %eax,%r11d
    188c:	45 31 c0             	xor    %r8d,%r8d
    188f:	bd 01 00 00 00       	mov    $0x1,%ebp
    1894:	4c 8d 94 24 90 01 00 	lea    0x190(%rsp),%r10
    189b:	00 
    189c:	eb 45                	jmp    18e3 <mesh_packet+0x10e3>
    189e:	44 0f b7 69 02       	movzwl 0x2(%rcx),%r13d
    18a3:	41 bc 04 00 00 00    	mov    $0x4,%r12d
    18a9:	66 44 89 6e 02       	mov    %r13w,0x2(%rsi)
    18ae:	42 0f b7 0c 21       	movzwl (%rcx,%r12,1),%ecx
    18b3:	83 e2 02             	and    $0x2,%edx
    18b6:	66 89 4e 04          	mov    %cx,0x4(%rsi)
    18ba:	74 16                	je     18d2 <mesh_packet+0x10d2>
    18bc:	44 89 c2             	mov    %r8d,%edx
    18bf:	44 89 c1             	mov    %r8d,%ecx
    18c2:	41 89 ef             	mov    %ebp,%r15d
    18c5:	c1 ea 03             	shr    $0x3,%edx
    18c8:	83 e1 07             	and    $0x7,%ecx
    18cb:	41 d3 e7             	shl    %cl,%r15d
    18ce:	44 08 3c 17          	or     %r15b,(%rdi,%rdx,1)
    18d2:	49 83 c0 01          	add    $0x1,%r8
    18d6:	48 83 c6 06          	add    $0x6,%rsi
    18da:	4d 39 d8             	cmp    %r11,%r8
    18dd:	0f 84 6e 03 00 00    	je     1c51 <mesh_packet+0x1451>
    18e3:	43 0f b6 14 02       	movzbl (%r10,%r8,1),%edx
    18e8:	8d 0c 52             	lea    (%rdx,%rdx,2),%ecx
    18eb:	0f b6 94 14 d0 01 00 	movzbl 0x1d0(%rsp,%rdx,1),%edx
    18f2:	00 
    18f3:	49 8d 0c 49          	lea    (%r9,%rcx,2),%rcx
    18f7:	44 0f b7 21          	movzwl (%rcx),%r12d
    18fb:	66 44 89 26          	mov    %r12w,(%rsi)
    18ff:	f6 c2 01             	test   $0x1,%dl
    1902:	74 9a                	je     189e <mesh_packet+0x109e>
    1904:	44 0f b7 69 04       	movzwl 0x4(%rcx),%r13d
    1909:	41 bc 02 00 00 00    	mov    $0x2,%r12d
    190f:	eb 98                	jmp    18a9 <mesh_packet+0x10a9>
    1911:	f3 44 0f 10 5c 24 60 	movss  0x60(%rsp),%xmm11
    1918:	f3 0f 10 5c 24 78    	movss  0x78(%rsp),%xmm3
    191e:	c6 84 24 80 00 00 00 	movb   $0x1,0x80(%rsp)
    1925:	01 
    1926:	f3 0f 10 8c 24 88 00 	movss  0x88(%rsp),%xmm1
    192d:	00 00 
    192f:	f3 44 0f 5e d8       	divss  %xmm0,%xmm11
    1934:	f3 0f 5e d8          	divss  %xmm0,%xmm3
    1938:	45 0f 28 e3          	movaps %xmm11,%xmm12
    193c:	f3 45 0f 59 e3       	mulss  %xmm11,%xmm12
    1941:	f3 0f 5e c8          	divss  %xmm0,%xmm1
    1945:	0f 28 c3             	movaps %xmm3,%xmm0
    1948:	f3 0f 59 c3          	mulss  %xmm3,%xmm0
    194c:	f3 41 0f 58 c4       	addss  %xmm12,%xmm0
    1951:	44 0f 28 e1          	movaps %xmm1,%xmm12
    1955:	f3 44 0f 59 e1       	mulss  %xmm1,%xmm12
    195a:	f3 41 0f 58 c4       	addss  %xmm12,%xmm0
    195f:	f3 0f 51 c0          	sqrtss %xmm0,%xmm0
    1963:	f3 44 0f 5e d8       	divss  %xmm0,%xmm11
    1968:	f3 0f 5e d8          	divss  %xmm0,%xmm3
    196c:	f3 44 0f 11 5c 24 60 	movss  %xmm11,0x60(%rsp)
    1973:	f3 0f 5e c8          	divss  %xmm0,%xmm1
    1977:	f3 0f 11 5c 24 78    	movss  %xmm3,0x78(%rsp)
    197d:	f3 0f 11 8c 24 88 00 	movss  %xmm1,0x88(%rsp)
    1984:	00 00 
    1986:	e9 73 f5 ff ff       	jmp    efe <mesh_packet+0x6fe>
    198b:	8b 84 24 90 03 00 00 	mov    0x390(%rsp),%eax
    1992:	85 c0                	test   %eax,%eax
    1994:	0f 84 ff 00 00 00    	je     1a99 <mesh_packet+0x1299>
    199a:	85 f6                	test   %esi,%esi
    199c:	0f 84 f7 00 00 00    	je     1a99 <mesh_packet+0x1299>
    19a2:	31 ed                	xor    %ebp,%ebp
    19a4:	45 31 c0             	xor    %r8d,%r8d
    19a7:	66 0f ef d2          	pxor   %xmm2,%xmm2
    19ab:	45 31 e4             	xor    %r12d,%r12d
    19ae:	31 d2                	xor    %edx,%edx
    19b0:	8d 45 01             	lea    0x1(%rbp),%eax
    19b3:	66 0f ef ed          	pxor   %xmm5,%xmm5
    19b7:	41 89 ea             	mov    %ebp,%r10d
    19ba:	66 0f ef db          	pxor   %xmm3,%xmm3
    19be:	f3 41 0f 5a 6c ee 04 	cvtss2sd 0x4(%r14,%rbp,8),%xmm5
    19c5:	66 0f ef e4          	pxor   %xmm4,%xmm4
    19c9:	66 0f ef f6          	pxor   %xmm6,%xmm6
    19cd:	f7 f6                	div    %esi
    19cf:	f3 41 0f 5a 74 ee 08 	cvtss2sd 0x8(%r14,%rbp,8),%xmm6
    19d6:	8d 3c 12             	lea    (%rdx,%rdx,1),%edi
    19d9:	f3 41 0f 5a 5c be 04 	cvtss2sd 0x4(%r14,%rdi,4),%xmm3
    19e0:	f2 0f 5c dd          	subsd  %xmm5,%xmm3
    19e4:	48 89 f8             	mov    %rdi,%rax
    19e7:	83 c0 01             	add    $0x1,%eax
    19ea:	f3 41 0f 5a 64 86 04 	cvtss2sd 0x4(%r14,%rax,4),%xmm4
    19f1:	f2 0f 5c e6          	subsd  %xmm6,%xmm4
    19f5:	66 0f 2e da          	ucomisd %xmm2,%xmm3
    19f9:	0f 9b c0             	setnp  %al
    19fc:	41 0f 45 c4          	cmovne %r12d,%eax
    1a00:	84 c0                	test   %al,%al
    1a02:	74 13                	je     1a17 <mesh_packet+0x1217>
    1a04:	66 0f 2e e2          	ucomisd %xmm2,%xmm4
    1a08:	0f 9b c0             	setnp  %al
    1a0b:	41 0f 45 c4          	cmovne %r12d,%eax
    1a0f:	84 c0                	test   %al,%al
    1a11:	0f 85 49 f2 ff ff    	jne    c60 <mesh_packet+0x460>
    1a17:	89 34 24             	mov    %esi,(%rsp)
    1a1a:	31 c0                	xor    %eax,%eax
    1a1c:	0f 1f 40 00          	nopl   0x0(%rax)
    1a20:	41 39 c2             	cmp    %eax,%r10d
    1a23:	74 5b                	je     1a80 <mesh_packet+0x1280>
    1a25:	39 c2                	cmp    %eax,%edx
    1a27:	74 57                	je     1a80 <mesh_packet+0x1280>
    1a29:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1a2d:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1a31:	31 f6                	xor    %esi,%esi
    1a33:	f3 41 0f 5a 44 c6 08 	cvtss2sd 0x8(%r14,%rax,8),%xmm0
    1a3a:	f3 41 0f 5a 4c c6 04 	cvtss2sd 0x4(%r14,%rax,8),%xmm1
    1a41:	f2 0f 5c c6          	subsd  %xmm6,%xmm0
    1a45:	f2 0f 5c cd          	subsd  %xmm5,%xmm1
    1a49:	f2 0f 59 c3          	mulsd  %xmm3,%xmm0
    1a4d:	f2 0f 59 cc          	mulsd  %xmm4,%xmm1
    1a51:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    1a55:	66 0f 2f c2          	comisd %xmm2,%xmm0
    1a59:	40 0f 97 c6          	seta   %sil
    1a5d:	31 ff                	xor    %edi,%edi
    1a5f:	66 0f 2f d0          	comisd %xmm0,%xmm2
    1a63:	40 0f 97 c7          	seta   %dil
    1a67:	29 fe                	sub    %edi,%esi
    1a69:	0f 84 f1 f1 ff ff    	je     c60 <mesh_packet+0x460>
    1a6f:	45 85 c0             	test   %r8d,%r8d
    1a72:	74 09                	je     1a7d <mesh_packet+0x127d>
    1a74:	41 39 f0             	cmp    %esi,%r8d
    1a77:	0f 85 e3 f1 ff ff    	jne    c60 <mesh_packet+0x460>
    1a7d:	41 89 f0             	mov    %esi,%r8d
    1a80:	48 83 c0 01          	add    $0x1,%rax
    1a84:	48 39 c8             	cmp    %rcx,%rax
    1a87:	75 97                	jne    1a20 <mesh_packet+0x1220>
    1a89:	48 83 c5 01          	add    $0x1,%rbp
    1a8d:	8b 34 24             	mov    (%rsp),%esi
    1a90:	48 39 e9             	cmp    %rbp,%rcx
    1a93:	0f 85 15 ff ff ff    	jne    19ae <mesh_packet+0x11ae>
    1a99:	0f b6 43 0a          	movzbl 0xa(%rbx),%eax
    1a9d:	49 83 c5 01          	add    $0x1,%r13
    1aa1:	49 83 c6 44          	add    $0x44,%r14
    1aa5:	41 39 c5             	cmp    %eax,%r13d
    1aa8:	0f 82 97 00 00 00    	jb     1b45 <mesh_packet+0x1345>
    1aae:	b8 01 00 00 00       	mov    $0x1,%eax
    1ab3:	e9 aa f1 ff ff       	jmp    c62 <mesh_packet+0x462>
    1ab8:	c6 84 24 80 00 00 00 	movb   $0x0,0x80(%rsp)
    1abf:	00 
    1ac0:	e9 39 f4 ff ff       	jmp    efe <mesh_packet+0x6fe>
    1ac5:	0f b7 94 24 30 01 00 	movzwl 0x130(%rsp),%edx
    1acc:	00 
    1acd:	48 8d 8c 24 10 02 00 	lea    0x210(%rsp),%rcx
    1ad4:	00 
    1ad5:	48 83 ec 08          	sub    $0x8,%rsp
    1ad9:	45 0f b6 cf          	movzbl %r15b,%r9d
    1add:	48 8d 84 24 98 03 00 	lea    0x398(%rsp),%rax
    1ae4:	00 
    1ae5:	4c 89 d7             	mov    %r10,%rdi
    1ae8:	50                   	push   %rax
    1ae9:	43 8d 04 40          	lea    (%r8,%r8,2),%eax
    1aed:	50                   	push   %rax
    1aee:	49 8d 86 5c 02 00 00 	lea    0x25c(%r14),%rax
    1af5:	50                   	push   %rax
    1af6:	48 8b b4 24 38 01 00 	mov    0x138(%rsp),%rsi
    1afd:	00 
    1afe:	44 0f b7 84 24 52 01 	movzwl 0x152(%rsp),%r8d
    1b05:	00 00 
    1b07:	e8 00 00 00 00       	call   1b0c <mesh_packet+0x130c>
			1b08: R_X86_64_PLT32	ayatsuri_visibility_select-0x4
    1b0c:	48 83 c4 20          	add    $0x20,%rsp
    1b10:	85 c0                	test   %eax,%eax
    1b12:	0f 85 48 f1 ff ff    	jne    c60 <mesh_packet+0x460>
    1b18:	8b 84 24 90 03 00 00 	mov    0x390(%rsp),%eax
    1b1f:	41 88 46 55          	mov    %al,0x55(%r14)
    1b23:	80 7b 0a 00          	cmpb   $0x0,0xa(%rbx)
    1b27:	44 0f b7 4b 08       	movzwl 0x8(%rbx),%r9d
    1b2c:	74 80                	je     1aae <mesh_packet+0x12ae>
    1b2e:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
    1b33:	49 81 c6 dc 03 00 00 	add    $0x3dc,%r14
    1b3a:	45 31 ed             	xor    %r13d,%r13d
    1b3d:	4c 8d 9c 24 60 01 00 	lea    0x160(%rsp),%r11
    1b44:	00 
    1b45:	42 0f b6 44 2b 0c    	movzbl 0xc(%rbx,%r13,1),%eax
    1b4b:	41 88 06             	mov    %al,(%r14)
    1b4e:	84 c0                	test   %al,%al
    1b50:	0f 84 43 ff ff ff    	je     1a99 <mesh_packet+0x1299>
    1b56:	4d 8b 27             	mov    (%r15),%r12
    1b59:	41 8b 6f 6c          	mov    0x6c(%r15),%ebp
    1b5d:	49 8d 56 04          	lea    0x4(%r14),%rdx
    1b61:	45 31 d2             	xor    %r10d,%r10d
    1b64:	4c 8d 84 24 d0 01 00 	lea    0x1d0(%rsp),%r8
    1b6b:	00 
    1b6c:	eb 1a                	jmp    1b88 <mesh_packet+0x1388>
    1b6e:	66 90                	xchg   %ax,%ax
    1b70:	41 0f b6 36          	movzbl (%r14),%esi
    1b74:	41 83 c2 01          	add    $0x1,%r10d
    1b78:	48 83 c2 08          	add    $0x8,%rdx
    1b7c:	48 89 f1             	mov    %rsi,%rcx
    1b7f:	41 39 f2             	cmp    %esi,%r10d
    1b82:	0f 83 03 fe ff ff    	jae    198b <mesh_packet+0x118b>
    1b88:	41 83 c1 01          	add    $0x1,%r9d
    1b8c:	48 8d 4a 04          	lea    0x4(%rdx),%rcx
    1b90:	4c 89 df             	mov    %r11,%rdi
    1b93:	43 8d 04 49          	lea    (%r9,%r9,2),%eax
    1b97:	8d 34 85 f4 ff ff ff 	lea    -0xc(,%rax,4),%esi
    1b9e:	48 01 ee             	add    %rbp,%rsi
    1ba1:	4c 01 e6             	add    %r12,%rsi
    1ba4:	e8 e7 e4 ff ff       	call   90 <mesh_project>
    1ba9:	84 c0                	test   %al,%al
    1bab:	75 c3                	jne    1b70 <mesh_packet+0x1370>
    1bad:	e9 ae f0 ff ff       	jmp    c60 <mesh_packet+0x460>
    1bb2:	85 c0                	test   %eax,%eax
    1bb4:	0f 84 7d 00 00 00    	je     1c37 <mesh_packet+0x1437>
    1bba:	44 8d 68 ff          	lea    -0x1(%rax),%r13d
    1bbe:	89 c5                	mov    %eax,%ebp
    1bc0:	4d 89 ec             	mov    %r13,%r12
    1bc3:	48 8d bc ec 90 03 00 	lea    0x390(%rsp,%rbp,8),%rdi
    1bca:	00 
    1bcb:	4c 8d 8c 2c 90 01 00 	lea    0x190(%rsp,%rbp,1),%r9
    1bd2:	00 
    1bd3:	49 29 ec             	sub    %rbp,%r12
    1bd6:	eb 47                	jmp    1c1f <mesh_packet+0x141f>
    1bd8:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    1bdf:	00 00 00 00 
    1be3:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    1bea:	00 00 00 00 
    1bee:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    1bf5:	00 00 00 00 
    1bf9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    1c00:	4c 89 ca             	mov    %r9,%rdx
    1c03:	f2 0f 11 0f          	movsd  %xmm1,(%rdi)
    1c07:	49 83 e9 01          	sub    $0x1,%r9
    1c0b:	48 83 ef 08          	sub    $0x8,%rdi
    1c0f:	48 29 ea             	sub    %rbp,%rdx
    1c12:	42 0f b6 14 2a       	movzbl (%rdx,%r13,1),%edx
    1c17:	41 88 51 01          	mov    %dl,0x1(%r9)
    1c1b:	85 c0                	test   %eax,%eax
    1c1d:	74 18                	je     1c37 <mesh_packet+0x1437>
    1c1f:	f2 42 0f 10 0c e7    	movsd  (%rdi,%r12,8),%xmm1
    1c25:	89 c2                	mov    %eax,%edx
    1c27:	83 e8 01             	sub    $0x1,%eax
    1c2a:	66 0f 2f c8          	comisd %xmm0,%xmm1
    1c2e:	77 d0                	ja     1c00 <mesh_packet+0x1400>
    1c30:	89 d0                	mov    %edx,%eax
    1c32:	e9 0c fc ff ff       	jmp    1843 <mesh_packet+0x1043>
    1c37:	31 c0                	xor    %eax,%eax
    1c39:	e9 05 fc ff ff       	jmp    1843 <mesh_packet+0x1043>
    1c3e:	31 d2                	xor    %edx,%edx
    1c40:	41 88 56 55          	mov    %dl,0x55(%r14)
    1c44:	44 89 84 24 90 03 00 	mov    %r8d,0x390(%rsp)
    1c4b:	00 
    1c4c:	e9 d2 fe ff ff       	jmp    1b23 <mesh_packet+0x1323>
    1c51:	89 c2                	mov    %eax,%edx
    1c53:	41 89 c0             	mov    %eax,%r8d
    1c56:	eb e8                	jmp    1c40 <mesh_packet+0x1440>
    1c58:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    1c5f:	00 

0000000000001c60 <ayatsuri_model_open>:
    1c60:	41 57                	push   %r15
    1c62:	41 56                	push   %r14
    1c64:	41 55                	push   %r13
    1c66:	41 54                	push   %r12
    1c68:	55                   	push   %rbp
    1c69:	53                   	push   %rbx
    1c6a:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
    1c71:	48 85 ff             	test   %rdi,%rdi
    1c74:	74 2a                	je     1ca0 <ayatsuri_model_open+0x40>
    1c76:	48 89 d5             	mov    %rdx,%rbp
    1c79:	48 85 d2             	test   %rdx,%rdx
    1c7c:	74 22                	je     1ca0 <ayatsuri_model_open+0x40>
    1c7e:	48 8d 46 e0          	lea    -0x20(%rsi),%rax
    1c82:	48 3d e0 ff 0f 00    	cmp    $0xfffe0,%rax
    1c88:	77 16                	ja     1ca0 <ayatsuri_model_open+0x40>
    1c8a:	48 89 fb             	mov    %rdi,%rbx
    1c8d:	48 39 d7             	cmp    %rdx,%rdi
    1c90:	72 2e                	jb     1cc0 <ayatsuri_model_open+0x60>
    1c92:	48 89 fa             	mov    %rdi,%rdx
    1c95:	48 29 ea             	sub    %rbp,%rdx
    1c98:	48 83 fa 7f          	cmp    $0x7f,%rdx
    1c9c:	77 2a                	ja     1cc8 <ayatsuri_model_open+0x68>
    1c9e:	66 90                	xchg   %ax,%ax
    1ca0:	41 bc 01 00 00 00    	mov    $0x1,%r12d
    1ca6:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
    1cad:	44 89 e0             	mov    %r12d,%eax
    1cb0:	5b                   	pop    %rbx
    1cb1:	5d                   	pop    %rbp
    1cb2:	41 5c                	pop    %r12
    1cb4:	41 5d                	pop    %r13
    1cb6:	41 5e                	pop    %r14
    1cb8:	41 5f                	pop    %r15
    1cba:	c3                   	ret
    1cbb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    1cc0:	48 29 fa             	sub    %rdi,%rdx
    1cc3:	48 39 f2             	cmp    %rsi,%rdx
    1cc6:	72 d8                	jb     1ca0 <ayatsuri_model_open+0x40>
    1cc8:	81 3b 41 59 4e 4d    	cmpl   $0x4d4e5941,(%rbx)
    1cce:	75 d0                	jne    1ca0 <ayatsuri_model_open+0x40>
    1cd0:	66 83 7b 04 01       	cmpw   $0x1,0x4(%rbx)
    1cd5:	75 c9                	jne    1ca0 <ayatsuri_model_open+0x40>
    1cd7:	66 83 7b 06 20       	cmpw   $0x20,0x6(%rbx)
    1cdc:	75 c2                	jne    1ca0 <ayatsuri_model_open+0x40>
    1cde:	8b 53 08             	mov    0x8(%rbx),%edx
    1ce1:	48 39 f2             	cmp    %rsi,%rdx
    1ce4:	75 ba                	jne    1ca0 <ayatsuri_model_open+0x40>
    1ce6:	44 8b 43 0c          	mov    0xc(%rbx),%r8d
    1cea:	41 8d 50 f9          	lea    -0x7(%r8),%edx
    1cee:	83 fa 39             	cmp    $0x39,%edx
    1cf1:	77 ad                	ja     1ca0 <ayatsuri_model_open+0x40>
    1cf3:	83 7b 10 20          	cmpl   $0x20,0x10(%rbx)
    1cf7:	75 a7                	jne    1ca0 <ayatsuri_model_open+0x40>
    1cf9:	83 7b 14 14          	cmpl   $0x14,0x14(%rbx)
    1cfd:	75 a1                	jne    1ca0 <ayatsuri_model_open+0x40>
    1cff:	8b 53 18             	mov    0x18(%rbx),%edx
    1d02:	85 d2                	test   %edx,%edx
    1d04:	75 9a                	jne    1ca0 <ayatsuri_model_open+0x40>
    1d06:	44 8b 63 1c          	mov    0x1c(%rbx),%r12d
    1d0a:	45 85 e4             	test   %r12d,%r12d
    1d0d:	75 91                	jne    1ca0 <ayatsuri_model_open+0x40>
    1d0f:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
    1d16:	cc cc cc 
    1d19:	44 89 c1             	mov    %r8d,%ecx
    1d1c:	48 f7 e2             	mul    %rdx
    1d1f:	48 89 d0             	mov    %rdx,%rax
    1d22:	48 c1 e8 04          	shr    $0x4,%rax
    1d26:	48 39 c8             	cmp    %rcx,%rax
    1d29:	0f 82 71 ff ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    1d2f:	41 6b c0 14          	imul   $0x14,%r8d,%eax
    1d33:	b9 1d 00 00 00       	mov    $0x1d,%ecx
    1d38:	31 d2                	xor    %edx,%edx
    1d3a:	45 31 ff             	xor    %r15d,%r15d
    1d3d:	48 8d bc 24 9c 00 00 	lea    0x9c(%rsp),%rdi
    1d44:	00 
    1d45:	48 89 9c 24 90 00 00 	mov    %rbx,0x90(%rsp)
    1d4c:	00 
    1d4d:	89 b4 24 98 00 00 00 	mov    %esi,0x98(%rsp)
    1d54:	83 c0 20             	add    $0x20,%eax
    1d57:	89 54 24 08          	mov    %edx,0x8(%rsp)
    1d5b:	44 89 e2             	mov    %r12d,%edx
    1d5e:	89 44 24 0c          	mov    %eax,0xc(%rsp)
    1d62:	31 c0                	xor    %eax,%eax
    1d64:	f3 ab                	rep stos %eax,%es:(%rdi)
    1d66:	48 8d 43 24          	lea    0x24(%rbx),%rax
    1d6a:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
    1d6f:	49 89 c5             	mov    %rax,%r13
    1d72:	41 0f b7 7d fe       	movzwl -0x2(%r13),%edi
    1d77:	45 8b 4d 00          	mov    0x0(%r13),%r9d
    1d7b:	45 8b 55 04          	mov    0x4(%r13),%r10d
    1d7f:	66 83 ff 01          	cmp    $0x1,%di
    1d83:	0f 87 17 ff ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    1d89:	41 f6 c1 07          	test   $0x7,%r9b
    1d8d:	0f 85 0d ff ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    1d93:	8b 44 24 0c          	mov    0xc(%rsp),%eax
    1d97:	41 39 c1             	cmp    %eax,%r9d
    1d9a:	0f 82 00 ff ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    1da0:	45 89 cc             	mov    %r9d,%r12d
    1da3:	4c 39 e6             	cmp    %r12,%rsi
    1da6:	0f 82 f4 fe ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    1dac:	48 89 f0             	mov    %rsi,%rax
    1daf:	4c 29 e0             	sub    %r12,%rax
    1db2:	4c 39 d0             	cmp    %r10,%rax
    1db5:	0f 82 e5 fe ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    1dbb:	8b 44 24 08          	mov    0x8(%rsp),%eax
    1dbf:	85 c0                	test   %eax,%eax
    1dc1:	74 65                	je     1e28 <ayatsuri_model_open+0x1c8>
    1dc3:	4d 85 d2             	test   %r10,%r10
    1dc6:	44 89 7c 24 38       	mov    %r15d,0x38(%rsp)
    1dcb:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    1dd0:	4e 8d 34 23          	lea    (%rbx,%r12,1),%r14
    1dd4:	44 89 44 24 18       	mov    %r8d,0x18(%rsp)
    1dd9:	41 0f 95 c3          	setne  %r11b
    1ddd:	eb 15                	jmp    1df4 <ayatsuri_model_open+0x194>
    1ddf:	4d 29 e0             	sub    %r12,%r8
    1de2:	4d 39 d0             	cmp    %r10,%r8
    1de5:	0f 82 b5 fe ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    1deb:	48 83 c0 14          	add    $0x14,%rax
    1def:	4c 39 e8             	cmp    %r13,%rax
    1df2:	74 2a                	je     1e1e <ayatsuri_model_open+0x1be>
    1df4:	8b 48 04             	mov    0x4(%rax),%ecx
    1df7:	48 85 c9             	test   %rcx,%rcx
    1dfa:	74 ef                	je     1deb <ayatsuri_model_open+0x18b>
    1dfc:	45 84 db             	test   %r11b,%r11b
    1dff:	74 ea                	je     1deb <ayatsuri_model_open+0x18b>
    1e01:	44 8b 00             	mov    (%rax),%r8d
    1e04:	4e 8d 3c 03          	lea    (%rbx,%r8,1),%r15
    1e08:	4d 39 f7             	cmp    %r14,%r15
    1e0b:	73 d2                	jae    1ddf <ayatsuri_model_open+0x17f>
    1e0d:	4d 89 e7             	mov    %r12,%r15
    1e10:	4d 29 c7             	sub    %r8,%r15
    1e13:	49 39 cf             	cmp    %rcx,%r15
    1e16:	0f 82 84 fe ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    1e1c:	eb cd                	jmp    1deb <ayatsuri_model_open+0x18b>
    1e1e:	44 8b 7c 24 38       	mov    0x38(%rsp),%r15d
    1e23:	44 8b 44 24 18       	mov    0x18(%rsp),%r8d
    1e28:	41 0f b7 4d fc       	movzwl -0x4(%r13),%ecx
    1e2d:	66 41 0f 6e 45 08    	movd   0x8(%r13),%xmm0
    1e33:	41 8b 45 0c          	mov    0xc(%r13),%eax
    1e37:	44 8d 59 ff          	lea    -0x1(%rcx),%r11d
    1e3b:	66 41 83 fb 0c       	cmp    $0xc,%r11w
    1e40:	0f 87 f5 01 00 00    	ja     203b <ayatsuri_model_open+0x3db>
    1e46:	83 e9 01             	sub    $0x1,%ecx
    1e49:	41 bb 01 00 00 00    	mov    $0x1,%r11d
    1e4f:	41 d3 e3             	shl    %cl,%r11d
    1e52:	66 83 ef 01          	sub    $0x1,%di
    1e56:	0f 85 44 fe ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    1e5c:	45 85 fb             	test   %r15d,%r11d
    1e5f:	0f 85 3b fe ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    1e65:	48 63 c9             	movslq %ecx,%rcx
    1e68:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 1e6f <ayatsuri_model_open+0x20f>
			1e6b: R_X86_64_PC32	.rodata-0x4
    1e6f:	39 04 8f             	cmp    %eax,(%rdi,%rcx,4)
    1e72:	0f 85 28 fe ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    1e78:	66 0f 7e c7          	movd   %xmm0,%edi
    1e7c:	48 0f af c7          	imul   %rdi,%rax
    1e80:	49 39 c2             	cmp    %rax,%r10
    1e83:	0f 85 17 fe ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    1e89:	66 41 0f 6e c9       	movd   %r9d,%xmm1
    1e8e:	45 09 df             	or     %r11d,%r15d
    1e91:	66 0f 62 c8          	punpckldq %xmm0,%xmm1
    1e95:	66 0f d6 8c cc a4 00 	movq   %xmm1,0xa4(%rsp,%rcx,8)
    1e9c:	00 00 
    1e9e:	83 44 24 08 01       	addl   $0x1,0x8(%rsp)
    1ea3:	8b 44 24 08          	mov    0x8(%rsp),%eax
    1ea7:	49 83 c5 14          	add    $0x14,%r13
    1eab:	41 39 c0             	cmp    %eax,%r8d
    1eae:	0f 85 be fe ff ff    	jne    1d72 <ayatsuri_model_open+0x112>
    1eb4:	44 89 f8             	mov    %r15d,%eax
    1eb7:	41 89 d4             	mov    %edx,%r12d
    1eba:	f7 d0                	not    %eax
    1ebc:	a8 7f                	test   $0x7f,%al
    1ebe:	0f 85 dc fd ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    1ec4:	44 89 f8             	mov    %r15d,%eax
    1ec7:	25 00 0f 00 00       	and    $0xf00,%eax
    1ecc:	89 44 24 38          	mov    %eax,0x38(%rsp)
    1ed0:	74 0b                	je     1edd <ayatsuri_model_open+0x27d>
    1ed2:	3d 00 0f 00 00       	cmp    $0xf00,%eax
    1ed7:	0f 85 c3 fd ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    1edd:	44 8b ac 24 a8 00 00 	mov    0xa8(%rsp),%r13d
    1ee4:	00 
    1ee5:	41 8d 45 ff          	lea    -0x1(%r13),%eax
    1ee9:	3d ff 00 00 00       	cmp    $0xff,%eax
    1eee:	0f 87 ac fd ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    1ef4:	44 39 ac 24 b0 00 00 	cmp    %r13d,0xb0(%rsp)
    1efb:	00 
    1efc:	0f 85 9e fd ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    1f02:	44 39 ac 24 d0 00 00 	cmp    %r13d,0xd0(%rsp)
    1f09:	00 
    1f0a:	0f 85 90 fd ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    1f10:	8b 84 24 b8 00 00 00 	mov    0xb8(%rsp),%eax
    1f17:	89 44 24 0c          	mov    %eax,0xc(%rsp)
    1f1b:	41 39 c5             	cmp    %eax,%r13d
    1f1e:	0f 82 7c fd ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    1f24:	8b 8c 24 c0 00 00 00 	mov    0xc0(%rsp),%ecx
    1f2b:	42 8d 04 ed 00 00 00 	lea    0x0(,%r13,8),%eax
    1f32:	00 
    1f33:	89 4c 24 10          	mov    %ecx,0x10(%rsp)
    1f37:	39 c8                	cmp    %ecx,%eax
    1f39:	0f 82 61 fd ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    1f3f:	8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%eax
    1f46:	89 44 24 08          	mov    %eax,0x8(%rsp)
    1f4a:	41 39 c5             	cmp    %eax,%r13d
    1f4d:	0f 82 4d fd ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    1f53:	41 6b c5 7f          	imul   $0x7f,%r13d,%eax
    1f57:	44 8b b4 24 d8 00 00 	mov    0xd8(%rsp),%r14d
    1f5e:	00 
    1f5f:	44 39 f0             	cmp    %r14d,%eax
    1f62:	0f 82 38 fd ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    1f68:	41 f6 c7 80          	test   $0x80,%r15b
    1f6c:	74 13                	je     1f81 <ayatsuri_model_open+0x321>
    1f6e:	8b 84 24 e0 00 00 00 	mov    0xe0(%rsp),%eax
    1f75:	83 e8 01             	sub    $0x1,%eax
    1f78:	44 39 e8             	cmp    %r13d,%eax
    1f7b:	0f 83 1f fd ff ff    	jae    1ca0 <ayatsuri_model_open+0x40>
    1f81:	83 7c 24 38 00       	cmpl   $0x0,0x38(%rsp)
    1f86:	74 4c                	je     1fd4 <ayatsuri_model_open+0x374>
    1f88:	8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%eax
    1f8f:	83 e8 01             	sub    $0x1,%eax
    1f92:	44 39 e8             	cmp    %r13d,%eax
    1f95:	0f 83 05 fd ff ff    	jae    1ca0 <ayatsuri_model_open+0x40>
    1f9b:	44 89 e8             	mov    %r13d,%eax
    1f9e:	c1 e0 05             	shl    $0x5,%eax
    1fa1:	3b 84 24 f0 00 00 00 	cmp    0xf0(%rsp),%eax
    1fa8:	0f 82 f2 fc ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    1fae:	44 89 e8             	mov    %r13d,%eax
    1fb1:	c1 e0 06             	shl    $0x6,%eax
    1fb4:	3b 84 24 f8 00 00 00 	cmp    0xf8(%rsp),%eax
    1fbb:	0f 82 df fc ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    1fc1:	44 89 e8             	mov    %r13d,%eax
    1fc4:	c1 e0 04             	shl    $0x4,%eax
    1fc7:	3b 84 24 00 01 00 00 	cmp    0x100(%rsp),%eax
    1fce:	0f 82 cc fc ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    1fd4:	41 81 e7 00 10 00 00 	and    $0x1000,%r15d
    1fdb:	0f 84 81 00 00 00    	je     2062 <ayatsuri_model_open+0x402>
    1fe1:	8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%ecx
    1fe8:	85 c9                	test   %ecx,%ecx
    1fea:	0f 84 b0 fc ff ff    	je     1ca0 <ayatsuri_model_open+0x40>
    1ff0:	39 4c 24 08          	cmp    %ecx,0x8(%rsp)
    1ff4:	0f 85 a6 fc ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    1ffa:	8b 84 24 04 01 00 00 	mov    0x104(%rsp),%eax
    2001:	31 d2                	xor    %edx,%edx
    2003:	48 01 d8             	add    %rbx,%rax
    2006:	eb 29                	jmp    2031 <ayatsuri_model_open+0x3d1>
    2008:	80 78 01 00          	cmpb   $0x0,0x1(%rax)
    200c:	0f 85 8e fc ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    2012:	80 78 02 00          	cmpb   $0x0,0x2(%rax)
    2016:	0f 85 84 fc ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    201c:	80 78 03 00          	cmpb   $0x0,0x3(%rax)
    2020:	0f 85 7a fc ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    2026:	83 c2 01             	add    $0x1,%edx
    2029:	48 83 c0 04          	add    $0x4,%rax
    202d:	39 ca                	cmp    %ecx,%edx
    202f:	73 31                	jae    2062 <ayatsuri_model_open+0x402>
    2031:	80 38 01             	cmpb   $0x1,(%rax)
    2034:	76 d2                	jbe    2008 <ayatsuri_model_open+0x3a8>
    2036:	e9 65 fc ff ff       	jmp    1ca0 <ayatsuri_model_open+0x40>
    203b:	66 85 ff             	test   %di,%di
    203e:	0f 85 5c fc ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    2044:	85 c0                	test   %eax,%eax
    2046:	0f 84 52 fe ff ff    	je     1e9e <ayatsuri_model_open+0x23e>
    204c:	66 0f 7e c1          	movd   %xmm0,%ecx
    2050:	48 0f af c1          	imul   %rcx,%rax
    2054:	49 39 c2             	cmp    %rax,%r10
    2057:	0f 83 41 fe ff ff    	jae    1e9e <ayatsuri_model_open+0x23e>
    205d:	e9 3e fc ff ff       	jmp    1ca0 <ayatsuri_model_open+0x40>
    2062:	8b 84 24 f0 00 00 00 	mov    0xf0(%rsp),%eax
    2069:	44 8b 84 24 ec 00 00 	mov    0xec(%rsp),%r8d
    2070:	00 
    2071:	31 d2                	xor    %edx,%edx
    2073:	66 44 89 ac 24 9c 00 	mov    %r13w,0x9c(%rsp)
    207a:	00 00 
    207c:	f3 0f 10 25 00 00 00 	movss  0x0(%rip),%xmm4        # 2084 <ayatsuri_model_open+0x424>
    2083:	00 
			2080: R_X86_64_PC32	.LC1-0x4
    2084:	f3 0f 7e 1d 00 00 00 	movq   0x0(%rip),%xmm3        # 208c <ayatsuri_model_open+0x42c>
    208b:	00 
			2088: R_X86_64_PC32	.LC8-0x4
    208c:	f3 0f 10 2d 00 00 00 	movss  0x0(%rip),%xmm5        # 2094 <ayatsuri_model_open+0x434>
    2093:	00 
			2090: R_X86_64_PC32	.LC0-0x4
    2094:	89 44 24 18          	mov    %eax,0x18(%rsp)
    2098:	8b 44 24 18          	mov    0x18(%rsp),%eax
    209c:	39 c2                	cmp    %eax,%edx
    209e:	74 61                	je     2101 <ayatsuri_model_open+0x4a1>
    20a0:	6b ca 1c             	imul   $0x1c,%edx,%ecx
    20a3:	31 c0                	xor    %eax,%eax
    20a5:	66 0f ef c0          	pxor   %xmm0,%xmm0
    20a9:	4c 01 c1             	add    %r8,%rcx
    20ac:	48 01 d9             	add    %rbx,%rcx
    20af:	f3 0f 10 0c 81       	movss  (%rcx,%rax,4),%xmm1
    20b4:	0f 28 d1             	movaps %xmm1,%xmm2
    20b7:	0f 54 d5             	andps  %xmm5,%xmm2
    20ba:	0f 2e e2             	ucomiss %xmm2,%xmm4
    20bd:	0f 82 dd fb ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    20c3:	0f 2f 15 00 00 00 00 	comiss 0x0(%rip),%xmm2        # 20ca <ayatsuri_model_open+0x46a>
			20c6: R_X86_64_PC32	.LC3-0x4
    20ca:	0f 87 d0 fb ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    20d0:	8d 70 fd             	lea    -0x3(%rax),%esi
    20d3:	83 fe 02             	cmp    $0x2,%esi
    20d6:	76 7d                	jbe    2155 <ayatsuri_model_open+0x4f5>
    20d8:	48 83 c0 01          	add    $0x1,%rax
    20dc:	48 83 f8 07          	cmp    $0x7,%rax
    20e0:	75 cd                	jne    20af <ayatsuri_model_open+0x44f>
    20e2:	f2 0f 5c 05 00 00 00 	subsd  0x0(%rip),%xmm0        # 20ea <ayatsuri_model_open+0x48a>
    20e9:	00 
			20e6: R_X86_64_PC32	.LC9-0x4
    20ea:	66 0f 54 c3          	andpd  %xmm3,%xmm0
    20ee:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 20f6 <ayatsuri_model_open+0x496>
    20f5:	00 
			20f2: R_X86_64_PC32	.LC29-0x4
    20f6:	0f 87 a4 fb ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    20fc:	83 c2 01             	add    $0x1,%edx
    20ff:	eb 97                	jmp    2098 <ayatsuri_model_open+0x438>
    2101:	8b 84 24 f8 00 00 00 	mov    0xf8(%rsp),%eax
    2108:	31 d2                	xor    %edx,%edx
    210a:	89 44 24 28          	mov    %eax,0x28(%rsp)
    210e:	8b 84 24 f4 00 00 00 	mov    0xf4(%rsp),%eax
    2115:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
    211a:	8b 44 24 28          	mov    0x28(%rsp),%eax
    211e:	39 c2                	cmp    %eax,%edx
    2120:	74 48                	je     216a <ayatsuri_model_open+0x50a>
    2122:	6b c2 06             	imul   $0x6,%edx,%eax
    2125:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    212a:	48 01 c8             	add    %rcx,%rax
    212d:	66 83 3c 03 1f       	cmpw   $0x1f,(%rbx,%rax,1)
    2132:	0f 87 68 fb ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    2138:	66 83 7c 03 02 1f    	cmpw   $0x1f,0x2(%rbx,%rax,1)
    213e:	0f 87 5c fb ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    2144:	66 83 7c 03 04 1f    	cmpw   $0x1f,0x4(%rbx,%rax,1)
    214a:	0f 87 50 fb ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    2150:	83 c2 01             	add    $0x1,%edx
    2153:	eb c5                	jmp    211a <ayatsuri_model_open+0x4ba>
    2155:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
    2159:	f2 0f 59 c9          	mulsd  %xmm1,%xmm1
    215d:	48 83 c0 01          	add    $0x1,%rax
    2161:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    2165:	e9 45 ff ff ff       	jmp    20af <ayatsuri_model_open+0x44f>
    216a:	8b 84 24 00 01 00 00 	mov    0x100(%rsp),%eax
    2171:	8b b4 24 fc 00 00 00 	mov    0xfc(%rsp),%esi
    2178:	31 d2                	xor    %edx,%edx
    217a:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 2182 <ayatsuri_model_open+0x522>
    2181:	00 
			217e: R_X86_64_PC32	.LC0-0x4
    2182:	f3 0f 10 0d 00 00 00 	movss  0x0(%rip),%xmm1        # 218a <ayatsuri_model_open+0x52a>
    2189:	00 
			2186: R_X86_64_PC32	.LC1-0x4
    218a:	89 44 24 30          	mov    %eax,0x30(%rsp)
    218e:	8b 44 24 30          	mov    0x30(%rsp),%eax
    2192:	39 c2                	cmp    %eax,%edx
    2194:	74 38                	je     21ce <ayatsuri_model_open+0x56e>
    2196:	6b c2 0c             	imul   $0xc,%edx,%eax
    2199:	31 c9                	xor    %ecx,%ecx
    219b:	48 01 f0             	add    %rsi,%rax
    219e:	48 01 d8             	add    %rbx,%rax
    21a1:	f3 0f 10 04 88       	movss  (%rax,%rcx,4),%xmm0
    21a6:	0f 54 c2             	andps  %xmm2,%xmm0
    21a9:	0f 2e c8             	ucomiss %xmm0,%xmm1
    21ac:	0f 82 ee fa ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    21b2:	0f 2f 05 00 00 00 00 	comiss 0x0(%rip),%xmm0        # 21b9 <ayatsuri_model_open+0x559>
			21b5: R_X86_64_PC32	.LC3-0x4
    21b9:	0f 87 e1 fa ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    21bf:	48 83 c1 01          	add    $0x1,%rcx
    21c3:	48 83 f9 03          	cmp    $0x3,%rcx
    21c7:	75 d8                	jne    21a1 <ayatsuri_model_open+0x541>
    21c9:	83 c2 01             	add    $0x1,%edx
    21cc:	eb c0                	jmp    218e <ayatsuri_model_open+0x52e>
    21ce:	8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%eax
    21d5:	48 89 6c 24 48       	mov    %rbp,0x48(%rsp)
    21da:	31 d2                	xor    %edx,%edx
    21dc:	66 0f ef f6          	pxor   %xmm6,%xmm6
    21e0:	89 44 24 3c          	mov    %eax,0x3c(%rsp)
    21e4:	8b 84 24 e4 00 00 00 	mov    0xe4(%rsp),%eax
    21eb:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
    21f0:	8b 44 24 3c          	mov    0x3c(%rsp),%eax
    21f4:	39 c2                	cmp    %eax,%edx
    21f6:	0f 84 5c 02 00 00    	je     2458 <ayatsuri_model_open+0x7f8>
    21fc:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
    2201:	89 d0                	mov    %edx,%eax
    2203:	c1 e0 05             	shl    $0x5,%eax
    2206:	48 01 c8             	add    %rcx,%rax
    2209:	48 01 d8             	add    %rbx,%rax
    220c:	44 0f b7 50 02       	movzwl 0x2(%rax),%r10d
    2211:	44 0f b7 08          	movzwl (%rax),%r9d
    2215:	0f b7 48 04          	movzwl 0x4(%rax),%ecx
    2219:	44 0f b7 58 06       	movzwl 0x6(%rax),%r11d
    221e:	41 8d 72 fd          	lea    -0x3(%r10),%esi
    2222:	0f b7 68 08          	movzwl 0x8(%rax),%ebp
    2226:	83 fe 1d             	cmp    $0x1d,%esi
    2229:	0f 87 71 fa ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    222f:	41 8d 73 ff          	lea    -0x1(%r11),%esi
    2233:	83 fe 3f             	cmp    $0x3f,%esi
    2236:	0f 87 64 fa ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    223c:	0f b6 78 0a          	movzbl 0xa(%rax),%edi
    2240:	40 80 ff 02          	cmp    $0x2,%dil
    2244:	0f 87 56 fa ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    224a:	80 78 0b 01          	cmpb   $0x1,0xb(%rax)
    224e:	0f 87 4c fa ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    2254:	8b 74 24 18          	mov    0x18(%rsp),%esi
    2258:	44 39 ce             	cmp    %r9d,%esi
    225b:	0f 82 3f fa ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    2261:	44 29 ce             	sub    %r9d,%esi
    2264:	44 39 d6             	cmp    %r10d,%esi
    2267:	0f 82 33 fa ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    226d:	8b 74 24 28          	mov    0x28(%rsp),%esi
    2271:	39 ce                	cmp    %ecx,%esi
    2273:	0f 82 27 fa ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    2279:	29 ce                	sub    %ecx,%esi
    227b:	44 39 de             	cmp    %r11d,%esi
    227e:	0f 82 1c fa ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    2284:	0f b6 70 0c          	movzbl 0xc(%rax),%esi
    2288:	40 84 ff             	test   %dil,%dil
    228b:	0f 85 94 01 00 00    	jne    2425 <ayatsuri_model_open+0x7c5>
    2291:	40 84 f6             	test   %sil,%sil
    2294:	0f 85 06 fa ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    229a:	31 f6                	xor    %esi,%esi
    229c:	80 78 0d 00          	cmpb   $0x0,0xd(%rax)
    22a0:	0f 85 fa f9 ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    22a6:	8b 7c 24 30          	mov    0x30(%rsp),%edi
    22aa:	39 ef                	cmp    %ebp,%edi
    22ac:	0f 82 ee f9 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    22b2:	29 ef                	sub    %ebp,%edi
    22b4:	39 f7                	cmp    %esi,%edi
    22b6:	0f 82 e4 f9 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    22bc:	be 13 00 00 00       	mov    $0x13,%esi
    22c1:	80 3c 30 00          	cmpb   $0x0,(%rax,%rsi,1)
    22c5:	0f 85 d5 f9 ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    22cb:	48 83 c6 01          	add    $0x1,%rsi
    22cf:	48 83 fe 20          	cmp    $0x20,%rsi
    22d3:	75 ec                	jne    22c1 <ayatsuri_model_open+0x661>
    22d5:	6b f9 06             	imul   $0x6,%ecx,%edi
    22d8:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
    22dd:	31 ed                	xor    %ebp,%ebp
    22df:	48 01 c7             	add    %rax,%rdi
    22e2:	48 01 df             	add    %rbx,%rdi
    22e5:	0f b7 0f             	movzwl (%rdi),%ecx
    22e8:	0f b7 47 02          	movzwl 0x2(%rdi),%eax
    22ec:	0f b7 77 04          	movzwl 0x4(%rdi),%esi
    22f0:	39 c1                	cmp    %eax,%ecx
    22f2:	41 89 c7             	mov    %eax,%r15d
    22f5:	44 0f 43 f9          	cmovae %ecx,%r15d
    22f9:	45 39 d7             	cmp    %r10d,%r15d
    22fc:	0f 83 9e f9 ff ff    	jae    1ca0 <ayatsuri_model_open+0x40>
    2302:	44 39 d6             	cmp    %r10d,%esi
    2305:	0f 83 95 f9 ff ff    	jae    1ca0 <ayatsuri_model_open+0x40>
    230b:	39 c1                	cmp    %eax,%ecx
    230d:	0f 84 8d f9 ff ff    	je     1ca0 <ayatsuri_model_open+0x40>
    2313:	39 f1                	cmp    %esi,%ecx
    2315:	0f 84 85 f9 ff ff    	je     1ca0 <ayatsuri_model_open+0x40>
    231b:	39 f0                	cmp    %esi,%eax
    231d:	41 0f 94 c7          	sete   %r15b
    2321:	0f 84 79 f9 ff ff    	je     1ca0 <ayatsuri_model_open+0x40>
    2327:	44 01 c9             	add    %r9d,%ecx
    232a:	44 01 c8             	add    %r9d,%eax
    232d:	66 0f ef ed          	pxor   %xmm5,%xmm5
    2331:	44 01 ce             	add    %r9d,%esi
    2334:	6b c9 1c             	imul   $0x1c,%ecx,%ecx
    2337:	66 0f ef c0          	pxor   %xmm0,%xmm0
    233b:	66 0f ef e4          	pxor   %xmm4,%xmm4
    233f:	6b c0 1c             	imul   $0x1c,%eax,%eax
    2342:	66 0f ef db          	pxor   %xmm3,%xmm3
    2346:	66 0f ef d2          	pxor   %xmm2,%xmm2
    234a:	6b f6 1c             	imul   $0x1c,%esi,%esi
    234d:	66 0f ef ff          	pxor   %xmm7,%xmm7
    2351:	66 0f ef c9          	pxor   %xmm1,%xmm1
    2355:	4c 01 c1             	add    %r8,%rcx
    2358:	4c 01 c0             	add    %r8,%rax
    235b:	48 01 d9             	add    %rbx,%rcx
    235e:	4c 01 c6             	add    %r8,%rsi
    2361:	48 01 d8             	add    %rbx,%rax
    2364:	f3 0f 5a 29          	cvtss2sd (%rcx),%xmm5
    2368:	f3 0f 5a 59 04       	cvtss2sd 0x4(%rcx),%xmm3
    236d:	48 01 de             	add    %rbx,%rsi
    2370:	f3 0f 5a 00          	cvtss2sd (%rax),%xmm0
    2374:	f2 0f 5c c5          	subsd  %xmm5,%xmm0
    2378:	f3 0f 5a 79 08       	cvtss2sd 0x8(%rcx),%xmm7
    237d:	f3 0f 5a 26          	cvtss2sd (%rsi),%xmm4
    2381:	f2 0f 5c e5          	subsd  %xmm5,%xmm4
    2385:	66 0f ef ed          	pxor   %xmm5,%xmm5
    2389:	f3 0f 5a 50 04       	cvtss2sd 0x4(%rax),%xmm2
    238e:	f3 0f 5a 48 08       	cvtss2sd 0x8(%rax),%xmm1
    2393:	f2 0f 5c d3          	subsd  %xmm3,%xmm2
    2397:	f2 0f 5c cf          	subsd  %xmm7,%xmm1
    239b:	f3 0f 5a 6e 04       	cvtss2sd 0x4(%rsi),%xmm5
    23a0:	f2 0f 5c eb          	subsd  %xmm3,%xmm5
    23a4:	66 0f ef db          	pxor   %xmm3,%xmm3
    23a8:	f3 0f 5a 5e 08       	cvtss2sd 0x8(%rsi),%xmm3
    23ad:	f2 0f 5c df          	subsd  %xmm7,%xmm3
    23b1:	66 44 0f 28 c1       	movapd %xmm1,%xmm8
    23b6:	66 0f 28 fa          	movapd %xmm2,%xmm7
    23ba:	f2 44 0f 59 c5       	mulsd  %xmm5,%xmm8
    23bf:	f2 0f 59 fb          	mulsd  %xmm3,%xmm7
    23c3:	f2 0f 59 cc          	mulsd  %xmm4,%xmm1
    23c7:	f2 0f 59 d8          	mulsd  %xmm0,%xmm3
    23cb:	f2 41 0f 5c f8       	subsd  %xmm8,%xmm7
    23d0:	f2 0f 5c cb          	subsd  %xmm3,%xmm1
    23d4:	66 0f 2e fe          	ucomisd %xmm6,%xmm7
    23d8:	0f 9b c0             	setnp  %al
    23db:	41 0f 45 c7          	cmovne %r15d,%eax
    23df:	66 0f 2e ce          	ucomisd %xmm6,%xmm1
    23e3:	0f 9b c1             	setnp  %cl
    23e6:	41 0f 45 cf          	cmovne %r15d,%ecx
    23ea:	84 c8                	test   %cl,%al
    23ec:	74 1f                	je     240d <ayatsuri_model_open+0x7ad>
    23ee:	f2 0f 59 c5          	mulsd  %xmm5,%xmm0
    23f2:	f2 0f 59 d4          	mulsd  %xmm4,%xmm2
    23f6:	f2 0f 5c c2          	subsd  %xmm2,%xmm0
    23fa:	66 0f 2e c6          	ucomisd %xmm6,%xmm0
    23fe:	0f 9b c0             	setnp  %al
    2401:	41 0f 45 c7          	cmovne %r15d,%eax
    2405:	84 c0                	test   %al,%al
    2407:	0f 85 93 f8 ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    240d:	83 c5 01             	add    $0x1,%ebp
    2410:	48 83 c7 06          	add    $0x6,%rdi
    2414:	44 39 dd             	cmp    %r11d,%ebp
    2417:	0f 82 c8 fe ff ff    	jb     22e5 <ayatsuri_model_open+0x685>
    241d:	83 c2 01             	add    $0x1,%edx
    2420:	e9 cb fd ff ff       	jmp    21f0 <ayatsuri_model_open+0x590>
    2425:	44 8d 7e fd          	lea    -0x3(%rsi),%r15d
    2429:	41 80 ff 05          	cmp    $0x5,%r15b
    242d:	0f 87 6d f8 ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    2433:	44 0f b6 78 0d       	movzbl 0xd(%rax),%r15d
    2438:	40 80 ff 02          	cmp    $0x2,%dil
    243c:	0f 85 5a fe ff ff    	jne    229c <ayatsuri_model_open+0x63c>
    2442:	41 8d 7f fd          	lea    -0x3(%r15),%edi
    2446:	40 80 ff 05          	cmp    $0x5,%dil
    244a:	0f 87 50 f8 ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    2450:	44 01 fe             	add    %r15d,%esi
    2453:	e9 4e fe ff ff       	jmp    22a6 <ayatsuri_model_open+0x646>
    2458:	8b 84 24 d4 00 00 00 	mov    0xd4(%rsp),%eax
    245f:	48 8b 6c 24 48       	mov    0x48(%rsp),%rbp
    2464:	48 89 c1             	mov    %rax,%rcx
    2467:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
    246c:	31 c0                	xor    %eax,%eax
    246e:	48 01 d9             	add    %rbx,%rcx
    2471:	eb 21                	jmp    2494 <ayatsuri_model_open+0x834>
    2473:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    247a:	00 00 00 00 
    247e:	66 90                	xchg   %ax,%ax
    2480:	0f b6 3c 01          	movzbl (%rcx,%rax,1),%edi
    2484:	48 83 c0 01          	add    $0x1,%rax
    2488:	8d 57 e0             	lea    -0x20(%rdi),%edx
    248b:	80 fa 5e             	cmp    $0x5e,%dl
    248e:	0f 87 0c f8 ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    2494:	44 39 f0             	cmp    %r14d,%eax
    2497:	72 e7                	jb     2480 <ayatsuri_model_open+0x820>
    2499:	8b 84 24 ac 00 00 00 	mov    0xac(%rsp),%eax
    24a0:	b9 09 00 00 00       	mov    $0x9,%ecx
    24a5:	ba 09 00 00 00       	mov    $0x9,%edx
    24aa:	44 89 ee             	mov    %r13d,%esi
    24ad:	48 01 d8             	add    %rbx,%rax
    24b0:	48 89 c7             	mov    %rax,%rdi
    24b3:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
    24b8:	e8 53 db ff ff       	call   10 <float_rows_valid>
    24bd:	84 c0                	test   %al,%al
    24bf:	0f 84 db f7 ff ff    	je     1ca0 <ayatsuri_model_open+0x40>
    24c5:	8b bc 24 b4 00 00 00 	mov    0xb4(%rsp),%edi
    24cc:	8b 74 24 0c          	mov    0xc(%rsp),%esi
    24d0:	31 c9                	xor    %ecx,%ecx
    24d2:	ba 03 00 00 00       	mov    $0x3,%edx
    24d7:	48 01 df             	add    %rbx,%rdi
    24da:	e8 31 db ff ff       	call   10 <float_rows_valid>
    24df:	84 c0                	test   %al,%al
    24e1:	0f 84 b9 f7 ff ff    	je     1ca0 <ayatsuri_model_open+0x40>
    24e7:	8b bc 24 bc 00 00 00 	mov    0xbc(%rsp),%edi
    24ee:	8b 74 24 10          	mov    0x10(%rsp),%esi
    24f2:	b9 03 00 00 00       	mov    $0x3,%ecx
    24f7:	ba 06 00 00 00       	mov    $0x6,%edx
    24fc:	48 01 df             	add    %rbx,%rdi
    24ff:	e8 0c db ff ff       	call   10 <float_rows_valid>
    2504:	84 c0                	test   %al,%al
    2506:	0f 84 94 f7 ff ff    	je     1ca0 <ayatsuri_model_open+0x40>
    250c:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
    2510:	8b bc 24 c4 00 00 00 	mov    0xc4(%rsp),%edi
    2517:	f3 0f 7e 15 00 00 00 	movq   0x0(%rip),%xmm2        # 251f <ayatsuri_model_open+0x8bf>
    251e:	00 
			251b: R_X86_64_PC32	.LC8-0x4
    251f:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 2527 <ayatsuri_model_open+0x8c7>
    2526:	00 
			2523: R_X86_64_PC32	.LC22-0x4
    2527:	48 6b c9 48          	imul   $0x48,%rcx,%rcx
    252b:	48 89 7c 24 48       	mov    %rdi,0x48(%rsp)
    2530:	48 8d 14 3b          	lea    (%rbx,%rdi,1),%rdx
    2534:	48 01 f9             	add    %rdi,%rcx
    2537:	48 01 d9             	add    %rbx,%rcx
    253a:	48 39 ca             	cmp    %rcx,%rdx
    253d:	0f 84 02 01 00 00    	je     2645 <ayatsuri_model_open+0x9e5>
    2543:	31 f6                	xor    %esi,%esi
    2545:	f3 0f 10 04 b2       	movss  (%rdx,%rsi,4),%xmm0
    254a:	48 83 fe 03          	cmp    $0x3,%rsi
    254e:	0f 84 bd 02 00 00    	je     2811 <ayatsuri_model_open+0xbb1>
    2554:	66 0f ef db          	pxor   %xmm3,%xmm3
    2558:	f3 0f 5a d8          	cvtss2sd %xmm0,%xmm3
    255c:	66 0f 54 da          	andpd  %xmm2,%xmm3
    2560:	66 0f 2e cb          	ucomisd %xmm3,%xmm1
    2564:	0f 82 36 f7 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    256a:	66 0f ef db          	pxor   %xmm3,%xmm3
    256e:	0f 2f c3             	comiss %xmm3,%xmm0
    2571:	0f 82 29 f7 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    2577:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 257f <ayatsuri_model_open+0x91f>
    257e:	00 
			257b: R_X86_64_PC32	.LC15-0x4
    257f:	0f 2f d8             	comiss %xmm0,%xmm3
    2582:	0f 82 18 f7 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    2588:	48 83 c6 01          	add    $0x1,%rsi
    258c:	48 83 fe 0b          	cmp    $0xb,%rsi
    2590:	75 b3                	jne    2545 <ayatsuri_model_open+0x8e5>
    2592:	81 7a 2c ff ff ff 00 	cmpl   $0xffffff,0x2c(%rdx)
    2599:	0f 87 01 f7 ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    259f:	48 8d 7a 30          	lea    0x30(%rdx),%rdi
    25a3:	e8 58 da ff ff       	call   0 <md>
    25a8:	66 0f 28 d8          	movapd %xmm0,%xmm3
    25ac:	66 0f 54 da          	andpd  %xmm2,%xmm3
    25b0:	66 0f 2e cb          	ucomisd %xmm3,%xmm1
    25b4:	0f 82 e6 f6 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    25ba:	66 0f ef db          	pxor   %xmm3,%xmm3
    25be:	66 0f 2f c3          	comisd %xmm3,%xmm0
    25c2:	0f 82 d8 f6 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    25c8:	f2 0f 10 1d 00 00 00 	movsd  0x0(%rip),%xmm3        # 25d0 <ayatsuri_model_open+0x970>
    25cf:	00 
			25cc: R_X86_64_PC32	.LC9-0x4
    25d0:	66 0f 2f d8          	comisd %xmm0,%xmm3
    25d4:	0f 82 c6 f6 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    25da:	48 8d 7a 38          	lea    0x38(%rdx),%rdi
    25de:	e8 1d da ff ff       	call   0 <md>
    25e3:	66 0f 28 e0          	movapd %xmm0,%xmm4
    25e7:	66 0f 54 e2          	andpd  %xmm2,%xmm4
    25eb:	66 0f 2e cc          	ucomisd %xmm4,%xmm1
    25ef:	0f 82 ab f6 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    25f5:	66 0f ef e4          	pxor   %xmm4,%xmm4
    25f9:	66 0f 2f c4          	comisd %xmm4,%xmm0
    25fd:	0f 82 9d f6 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    2603:	66 0f 2f d8          	comisd %xmm0,%xmm3
    2607:	0f 82 93 f6 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    260d:	48 8d 7a 40          	lea    0x40(%rdx),%rdi
    2611:	e8 ea d9 ff ff       	call   0 <md>
    2616:	66 0f 28 e8          	movapd %xmm0,%xmm5
    261a:	66 0f 54 ea          	andpd  %xmm2,%xmm5
    261e:	66 0f 2e cd          	ucomisd %xmm5,%xmm1
    2622:	0f 82 78 f6 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    2628:	66 0f 2f c4          	comisd %xmm4,%xmm0
    262c:	0f 82 6e f6 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    2632:	48 83 c2 48          	add    $0x48,%rdx
    2636:	66 0f 2f d8          	comisd %xmm0,%xmm3
    263a:	0f 82 60 f6 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    2640:	e9 f5 fe ff ff       	jmp    253a <ayatsuri_model_open+0x8da>
    2645:	8b bc 24 08 01 00 00 	mov    0x108(%rsp),%edi
    264c:	8b 8c 24 a4 00 00 00 	mov    0xa4(%rsp),%ecx
    2653:	88 44 24 63          	mov    %al,0x63(%rsp)
    2657:	45 31 d2             	xor    %r10d,%r10d
    265a:	8b 94 24 04 01 00 00 	mov    0x104(%rsp),%edx
    2661:	4c 8b 5c 24 28       	mov    0x28(%rsp),%r11
    2666:	48 01 d9             	add    %rbx,%rcx
    2669:	89 7c 24 40          	mov    %edi,0x40(%rsp)
    266d:	8b bc 24 cc 00 00 00 	mov    0xcc(%rsp),%edi
    2674:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
    2679:	49 89 cf             	mov    %rcx,%r15
    267c:	48 8d 0c 13          	lea    (%rbx,%rdx,1),%rcx
    2680:	4c 87 dd             	xchg   %r11,%rbp
    2683:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
    2688:	48 8d 8c 24 90 00 00 	lea    0x90(%rsp),%rcx
    268f:	00 
    2690:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
    2695:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
    269a:	48 89 d9             	mov    %rbx,%rcx
    269d:	44 89 d3             	mov    %r10d,%ebx
    26a0:	45 89 e2             	mov    %r12d,%r10d
    26a3:	49 89 cc             	mov    %rcx,%r12
    26a6:	41 0f b7 17          	movzwl (%r15),%edx
    26aa:	89 d0                	mov    %edx,%eax
    26ac:	0d 00 00 ff ff       	or     $0xffff0000,%eax
    26b1:	66 85 d2             	test   %dx,%dx
    26b4:	78 03                	js     26b9 <ayatsuri_model_open+0xa59>
    26b6:	0f b7 c2             	movzwl %dx,%eax
    26b9:	41 0f b7 77 04       	movzwl 0x4(%r15),%esi
    26be:	41 0f b7 7f 06       	movzwl 0x6(%r15),%edi
    26c3:	41 0f b7 57 08       	movzwl 0x8(%r15),%edx
    26c8:	45 0f b7 47 0a       	movzwl 0xa(%r15),%r8d
    26cd:	f3 41 0f 10 47 0c    	movss  0xc(%r15),%xmm0
    26d3:	83 f8 ff             	cmp    $0xffffffff,%eax
    26d6:	0f 8c c4 f5 ff ff    	jl     1ca0 <ayatsuri_model_open+0x40>
    26dc:	39 c3                	cmp    %eax,%ebx
    26de:	0f 8e bc f5 ff ff    	jle    1ca0 <ayatsuri_model_open+0x40>
    26e4:	41 0f b6 47 02       	movzbl 0x2(%r15),%eax
    26e9:	3c 03                	cmp    $0x3,%al
    26eb:	0f 87 af f5 ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    26f1:	41 80 7f 03 01       	cmpb   $0x1,0x3(%r15)
    26f6:	0f 87 a4 f5 ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    26fc:	45 39 e8             	cmp    %r13d,%r8d
    26ff:	0f 83 9b f5 ff ff    	jae    1ca0 <ayatsuri_model_open+0x40>
    2705:	f3 0f 10 35 00 00 00 	movss  0x0(%rip),%xmm6        # 270d <ayatsuri_model_open+0xaad>
    270c:	00 
			2709: R_X86_64_PC32	.LC1-0x4
    270d:	0f 28 c8             	movaps %xmm0,%xmm1
    2710:	0f 54 0d 00 00 00 00 	andps  0x0(%rip),%xmm1        # 2717 <ayatsuri_model_open+0xab7>
			2713: R_X86_64_PC32	.LC0-0x4
    2717:	0f 2e f1             	ucomiss %xmm1,%xmm6
    271a:	0f 82 80 f5 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    2720:	f3 0f 10 4d 18       	movss  0x18(%rbp),%xmm1
    2725:	66 0f ef f6          	pxor   %xmm6,%xmm6
    2729:	0f 2e ce             	ucomiss %xmm6,%xmm1
    272c:	7a 06                	jp     2734 <ayatsuri_model_open+0xad4>
    272e:	0f 84 6c f5 ff ff    	je     1ca0 <ayatsuri_model_open+0x40>
    2734:	f3 0f 10 4d 1c       	movss  0x1c(%rbp),%xmm1
    2739:	66 0f ef f6          	pxor   %xmm6,%xmm6
    273d:	0f 2e ce             	ucomiss %xmm6,%xmm1
    2740:	7a 06                	jp     2748 <ayatsuri_model_open+0xae8>
    2742:	0f 84 58 f5 ff ff    	je     1ca0 <ayatsuri_model_open+0x40>
    2748:	f3 0f 10 4d 20       	movss  0x20(%rbp),%xmm1
    274d:	66 0f ef f6          	pxor   %xmm6,%xmm6
    2751:	0f 2e ce             	ucomiss %xmm6,%xmm1
    2754:	7a 06                	jp     275c <ayatsuri_model_open+0xafc>
    2756:	0f 84 44 f5 ff ff    	je     1ca0 <ayatsuri_model_open+0x40>
    275c:	84 c0                	test   %al,%al
    275e:	0f 85 3e 01 00 00    	jne    28a2 <ayatsuri_model_open+0xc42>
    2764:	66 0f ef ff          	pxor   %xmm7,%xmm7
    2768:	b9 01 00 00 00       	mov    $0x1,%ecx
    276d:	0f 2e c7             	ucomiss %xmm7,%xmm0
    2770:	41 0f 9a c1          	setp   %r9b
    2774:	44 0f 45 c9          	cmovne %ecx,%r9d
    2778:	66 85 ff             	test   %di,%di
    277b:	40 0f 95 c7          	setne  %dil
    277f:	44 08 cf             	or     %r9b,%dil
    2782:	0f 85 18 f5 ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    2788:	21 f2                	and    %esi,%edx
    278a:	66 83 c2 01          	add    $0x1,%dx
    278e:	0f 85 0c f5 ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    2794:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    2799:	42 8d 14 c5 00 00 00 	lea    0x0(,%r8,8),%edx
    27a0:	00 
    27a1:	48 01 ca             	add    %rcx,%rdx
    27a4:	4c 01 e2             	add    %r12,%rdx
    27a7:	44 0f b7 42 02       	movzwl 0x2(%rdx),%r8d
    27ac:	8b 7a 04             	mov    0x4(%rdx),%edi
    27af:	0f b7 12             	movzwl (%rdx),%edx
    27b2:	39 da                	cmp    %ebx,%edx
    27b4:	0f 85 e6 f4 ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    27ba:	41 8d 50 ff          	lea    -0x1(%r8),%edx
    27be:	66 83 fa 7e          	cmp    $0x7e,%dx
    27c2:	40 0f 97 c6          	seta   %sil
    27c6:	41 39 fe             	cmp    %edi,%r14d
    27c9:	0f 92 c2             	setb   %dl
    27cc:	40 08 d6             	or     %dl,%sil
    27cf:	40 88 74 24 28       	mov    %sil,0x28(%rsp)
    27d4:	0f 85 c6 f4 ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    27da:	44 89 f6             	mov    %r14d,%esi
    27dd:	41 0f b7 d0          	movzwl %r8w,%edx
    27e1:	29 fe                	sub    %edi,%esi
    27e3:	39 d6                	cmp    %edx,%esi
    27e5:	0f 82 b5 f4 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    27eb:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
    27f0:	31 f6                	xor    %esi,%esi
    27f2:	48 01 cf             	add    %rcx,%rdi
    27f5:	4c 01 e7             	add    %r12,%rdi
    27f8:	39 d6                	cmp    %edx,%esi
    27fa:	73 58                	jae    2854 <ayatsuri_model_open+0xbf4>
    27fc:	0f b6 0c 37          	movzbl (%rdi,%rsi,1),%ecx
    2800:	48 83 c6 01          	add    $0x1,%rsi
    2804:	83 e9 20             	sub    $0x20,%ecx
    2807:	80 f9 5e             	cmp    $0x5e,%cl
    280a:	76 ec                	jbe    27f8 <ayatsuri_model_open+0xb98>
    280c:	e9 8f f4 ff ff       	jmp    1ca0 <ayatsuri_model_open+0x40>
    2811:	f3 0f 10 25 00 00 00 	movss  0x0(%rip),%xmm4        # 2819 <ayatsuri_model_open+0xbb9>
    2818:	00 
			2815: R_X86_64_PC32	.LC1-0x4
    2819:	0f 28 d8             	movaps %xmm0,%xmm3
    281c:	0f 54 1d 00 00 00 00 	andps  0x0(%rip),%xmm3        # 2823 <ayatsuri_model_open+0xbc3>
			281f: R_X86_64_PC32	.LC0-0x4
    2823:	0f 2e e3             	ucomiss %xmm3,%xmm4
    2826:	0f 82 74 f4 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    282c:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 2834 <ayatsuri_model_open+0xbd4>
    2833:	00 
			2830: R_X86_64_PC32	.LC15-0x4
    2834:	0f 2f d8             	comiss %xmm0,%xmm3
    2837:	0f 87 63 f4 ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    283d:	0f 2f 05 00 00 00 00 	comiss 0x0(%rip),%xmm0        # 2844 <ayatsuri_model_open+0xbe4>
			2840: R_X86_64_PC32	.LC30-0x4
    2844:	0f 87 56 f4 ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    284a:	be 04 00 00 00       	mov    $0x4,%esi
    284f:	e9 f1 fc ff ff       	jmp    2545 <ayatsuri_model_open+0x8e5>
    2854:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
    2859:	44 89 6c 24 64       	mov    %r13d,0x64(%rsp)
    285e:	41 0f b7 d0          	movzwl %r8w,%edx
    2862:	41 89 c5             	mov    %eax,%r13d
    2865:	89 9c 24 80 00 00 00 	mov    %ebx,0x80(%rsp)
    286c:	48 89 6c 24 68       	mov    %rbp,0x68(%rsp)
    2871:	4c 89 cb             	mov    %r9,%rbx
    2874:	44 89 c5             	mov    %r8d,%ebp
    2877:	49 39 df             	cmp    %rbx,%r15
    287a:	0f 84 cc 01 00 00    	je     2a4c <ayatsuri_model_open+0xdec>
    2880:	0f b7 43 0a          	movzwl 0xa(%rbx),%eax
    2884:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    2889:	c1 e0 03             	shl    $0x3,%eax
    288c:	48 01 c8             	add    %rcx,%rax
    288f:	4c 01 e0             	add    %r12,%rax
    2892:	66 39 68 02          	cmp    %bp,0x2(%rax)
    2896:	0f 84 5c 01 00 00    	je     29f8 <ayatsuri_model_open+0xd98>
    289c:	48 83 c3 10          	add    $0x10,%rbx
    28a0:	eb d5                	jmp    2877 <ayatsuri_model_open+0xc17>
    28a2:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
    28a6:	39 ca                	cmp    %ecx,%edx
    28a8:	0f 83 f2 f3 ff ff    	jae    1ca0 <ayatsuri_model_open+0x40>
    28ae:	3c 03                	cmp    $0x3,%al
    28b0:	74 6c                	je     291e <ayatsuri_model_open+0xcbe>
    28b2:	83 7c 24 40 00       	cmpl   $0x0,0x40(%rsp)
    28b7:	74 12                	je     28cb <ayatsuri_model_open+0xc6b>
    28b9:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
    28be:	c1 e2 02             	shl    $0x2,%edx
    28c1:	80 3c 11 00          	cmpb   $0x0,(%rcx,%rdx,1)
    28c5:	0f 85 d5 f3 ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    28cb:	3c 01                	cmp    $0x1,%al
    28cd:	0f 84 f7 00 00 00    	je     29ca <ayatsuri_model_open+0xd6a>
    28d3:	8d 57 ff             	lea    -0x1(%rdi),%edx
    28d6:	66 83 fa 07          	cmp    $0x7,%dx
    28da:	0f 87 c0 f3 ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    28e0:	8b 4c 24 10          	mov    0x10(%rsp),%ecx
    28e4:	39 f1                	cmp    %esi,%ecx
    28e6:	0f 82 b4 f3 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    28ec:	29 f1                	sub    %esi,%ecx
    28ee:	39 f9                	cmp    %edi,%ecx
    28f0:	0f 82 aa f3 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    28f6:	66 0f ef ff          	pxor   %xmm7,%xmm7
    28fa:	0f 2f f8             	comiss %xmm0,%xmm7
    28fd:	0f 87 9d f3 ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    2903:	0f 2f 05 00 00 00 00 	comiss 0x0(%rip),%xmm0        # 290a <ayatsuri_model_open+0xcaa>
			2906: R_X86_64_PC32	.LC30-0x4
    290a:	0f 87 90 f3 ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    2910:	66 83 84 24 9e 00 00 	addw   $0x1,0x9e(%rsp)
    2917:	00 01 
    2919:	e9 76 fe ff ff       	jmp    2794 <ayatsuri_model_open+0xb34>
    291e:	83 7c 24 38 00       	cmpl   $0x0,0x38(%rsp)
    2923:	0f 84 77 f3 ff ff    	je     1ca0 <ayatsuri_model_open+0x40>
    2929:	8b 4c 24 3c          	mov    0x3c(%rsp),%ecx
    292d:	39 ce                	cmp    %ecx,%esi
    292f:	40 0f 93 c6          	setae  %sil
    2933:	66 85 ff             	test   %di,%di
    2936:	40 0f 95 c7          	setne  %dil
    293a:	40 08 fe             	or     %dil,%sil
    293d:	0f 85 5d f3 ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    2943:	66 0f ef f6          	pxor   %xmm6,%xmm6
    2947:	b9 01 00 00 00       	mov    $0x1,%ecx
    294c:	0f 2e c6             	ucomiss %xmm6,%xmm0
    294f:	40 0f 9a c6          	setp   %sil
    2953:	0f 45 f1             	cmovne %ecx,%esi
    2956:	40 84 f6             	test   %sil,%sil
    2959:	0f 85 41 f3 ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    295f:	6b d2 48             	imul   $0x48,%edx,%edx
    2962:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
    2967:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
    296b:	4c 01 e6             	add    %r12,%rsi
    296e:	48 8d 7e 30          	lea    0x30(%rsi),%rdi
    2972:	e8 89 d6 ff ff       	call   0 <md>
    2977:	66 0f 2e 05 00 00 00 	ucomisd 0x0(%rip),%xmm0        # 297f <ayatsuri_model_open+0xd1f>
    297e:	00 
			297b: R_X86_64_PC32	.LC9-0x4
    297f:	0f 8a 1b f3 ff ff    	jp     1ca0 <ayatsuri_model_open+0x40>
    2985:	0f 85 15 f3 ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    298b:	48 8d 7e 38          	lea    0x38(%rsi),%rdi
    298f:	e8 6c d6 ff ff       	call   0 <md>
    2994:	66 0f 2e 05 00 00 00 	ucomisd 0x0(%rip),%xmm0        # 299c <ayatsuri_model_open+0xd3c>
    299b:	00 
			2998: R_X86_64_PC32	.LC9-0x4
    299c:	0f 8a fe f2 ff ff    	jp     1ca0 <ayatsuri_model_open+0x40>
    29a2:	0f 85 f8 f2 ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    29a8:	48 8d 7e 40          	lea    0x40(%rsi),%rdi
    29ac:	66 0f ef ff          	pxor   %xmm7,%xmm7
    29b0:	e8 4b d6 ff ff       	call   0 <md>
    29b5:	66 0f 2e c7          	ucomisd %xmm7,%xmm0
    29b9:	0f 8a e1 f2 ff ff    	jp     1ca0 <ayatsuri_model_open+0x40>
    29bf:	0f 84 4b ff ff ff    	je     2910 <ayatsuri_model_open+0xcb0>
    29c5:	e9 d6 f2 ff ff       	jmp    1ca0 <ayatsuri_model_open+0x40>
    29ca:	66 0f ef f6          	pxor   %xmm6,%xmm6
    29ce:	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
    29d2:	0f 2e c6             	ucomiss %xmm6,%xmm0
    29d5:	0f 9a c2             	setp   %dl
    29d8:	0f 45 d0             	cmovne %eax,%edx
    29db:	39 ce                	cmp    %ecx,%esi
    29dd:	40 0f 93 c6          	setae  %sil
    29e1:	40 08 d6             	or     %dl,%sil
    29e4:	0f 85 b6 f2 ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    29ea:	66 85 ff             	test   %di,%di
    29ed:	0f 84 1d ff ff ff    	je     2910 <ayatsuri_model_open+0xcb0>
    29f3:	e9 a8 f2 ff ff       	jmp    1ca0 <ayatsuri_model_open+0x40>
    29f8:	8b 70 04             	mov    0x4(%rax),%esi
    29fb:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    2a00:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
    2a05:	4c 89 9c 24 88 00 00 	mov    %r11,0x88(%rsp)
    2a0c:	00 
    2a0d:	48 01 c6             	add    %rax,%rsi
    2a10:	44 89 94 24 84 00 00 	mov    %r10d,0x84(%rsp)
    2a17:	00 
    2a18:	4c 01 e6             	add    %r12,%rsi
    2a1b:	48 89 7c 24 70       	mov    %rdi,0x70(%rsp)
    2a20:	e8 00 00 00 00       	call   2a25 <ayatsuri_model_open+0xdc5>
			2a21: R_X86_64_PLT32	memcmp-0x4
    2a25:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
    2a2a:	48 8b 54 24 78       	mov    0x78(%rsp),%rdx
    2a2f:	85 c0                	test   %eax,%eax
    2a31:	44 8b 94 24 84 00 00 	mov    0x84(%rsp),%r10d
    2a38:	00 
    2a39:	4c 8b 9c 24 88 00 00 	mov    0x88(%rsp),%r11
    2a40:	00 
    2a41:	0f 85 55 fe ff ff    	jne    289c <ayatsuri_model_open+0xc3c>
    2a47:	e9 54 f2 ff ff       	jmp    1ca0 <ayatsuri_model_open+0x40>
    2a4c:	44 89 e8             	mov    %r13d,%eax
    2a4f:	8b 9c 24 80 00 00 00 	mov    0x80(%rsp),%ebx
    2a56:	44 8b 6c 24 64       	mov    0x64(%rsp),%r13d
    2a5b:	48 8b 6c 24 68       	mov    0x68(%rsp),%rbp
    2a60:	3c 03                	cmp    $0x3,%al
    2a62:	0f 84 17 02 00 00    	je     2c7f <ayatsuri_model_open+0x101f>
    2a68:	4c 89 ff             	mov    %r15,%rdi
    2a6b:	e8 60 d8 ff ff       	call   2d0 <slot_bytes>
    2a70:	03 84 24 a0 00 00 00 	add    0xa0(%rsp),%eax
    2a77:	83 c3 01             	add    $0x1,%ebx
    2a7a:	49 83 c7 10          	add    $0x10,%r15
    2a7e:	48 83 c5 24          	add    $0x24,%rbp
    2a82:	89 84 24 a0 00 00 00 	mov    %eax,0xa0(%rsp)
    2a89:	89 c2                	mov    %eax,%edx
    2a8b:	44 39 eb             	cmp    %r13d,%ebx
    2a8e:	0f 82 12 fc ff ff    	jb     26a6 <ayatsuri_model_open+0xa46>
    2a94:	44 8b 8c 24 dc 00 00 	mov    0xdc(%rsp),%r9d
    2a9b:	00 
    2a9c:	4c 89 e3             	mov    %r12,%rbx
    2a9f:	4c 89 dd             	mov    %r11,%rbp
    2aa2:	31 f6                	xor    %esi,%esi
    2aa4:	0f b6 44 24 63       	movzbl 0x63(%rsp),%eax
    2aa9:	44 8b b4 24 e0 00 00 	mov    0xe0(%rsp),%r14d
    2ab0:	00 
    2ab1:	45 89 d4             	mov    %r10d,%r12d
    2ab4:	f3 44 0f 10 0d 00 00 	movss  0x0(%rip),%xmm9        # 2abd <ayatsuri_model_open+0xe5d>
    2abb:	00 00 
			2ab9: R_X86_64_PC32	.LC20-0x4
    2abd:	f3 0f 7e 1d 00 00 00 	movq   0x0(%rip),%xmm3        # 2ac5 <ayatsuri_model_open+0xe65>
    2ac4:	00 
			2ac1: R_X86_64_PC32	.LC8-0x4
    2ac5:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 2acd <ayatsuri_model_open+0xe6d>
    2acc:	00 
			2ac9: R_X86_64_PC32	.LC22-0x4
    2acd:	4e 8d 1c 0b          	lea    (%rbx,%r9,1),%r11
    2ad1:	f3 44 0f 10 05 00 00 	movss  0x0(%rip),%xmm8        # 2ada <ayatsuri_model_open+0xe7a>
    2ad8:	00 00 
			2ad6: R_X86_64_PC32	.LC31-0x4
    2ada:	41 39 f6             	cmp    %esi,%r14d
    2add:	0f 84 b0 01 00 00    	je     2c93 <ayatsuri_model_open+0x1033>
    2ae3:	66 0f ef c0          	pxor   %xmm0,%xmm0
    2ae7:	66 0f ef c9          	pxor   %xmm1,%xmm1
    2aeb:	66 0f ef d2          	pxor   %xmm2,%xmm2
    2aef:	89 f1                	mov    %esi,%ecx
    2af1:	c1 e1 05             	shl    $0x5,%ecx
    2af4:	4c 01 c9             	add    %r9,%rcx
    2af7:	48 01 d9             	add    %rbx,%rcx
    2afa:	0f b7 39             	movzwl (%rcx),%edi
    2afd:	f3 0f 10 79 10       	movss  0x10(%rcx),%xmm7
    2b02:	f3 0f 5a 41 04       	cvtss2sd 0x4(%rcx),%xmm0
    2b07:	f3 0f 5a 49 08       	cvtss2sd 0x8(%rcx),%xmm1
    2b0c:	f3 0f 10 61 14       	movss  0x14(%rcx),%xmm4
    2b11:	f3 0f 5a 51 0c       	cvtss2sd 0xc(%rcx),%xmm2
    2b16:	41 89 fa             	mov    %edi,%r10d
    2b19:	44 39 ef             	cmp    %r13d,%edi
    2b1c:	0f 83 7e f1 ff ff    	jae    1ca0 <ayatsuri_model_open+0x40>
    2b22:	4c 8b 7c 24 30       	mov    0x30(%rsp),%r15
    2b27:	44 0f b6 41 02       	movzbl 0x2(%rcx),%r8d
    2b2c:	c1 e7 04             	shl    $0x4,%edi
    2b2f:	42 0f b6 7c 3f 02    	movzbl 0x2(%rdi,%r15,1),%edi
    2b35:	41 80 f8 05          	cmp    $0x5,%r8b
    2b39:	0f 84 29 01 00 00    	je     2c68 <ayatsuri_model_open+0x1008>
    2b3f:	40 80 ef 01          	sub    $0x1,%dil
    2b43:	0f 85 57 f1 ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    2b49:	41 80 f8 04          	cmp    $0x4,%r8b
    2b4d:	0f 85 4d f1 ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    2b53:	f3 0f 10 2d 00 00 00 	movss  0x0(%rip),%xmm5        # 2b5b <ayatsuri_model_open+0xefb>
    2b5a:	00 
			2b57: R_X86_64_PC32	.LC28-0x4
    2b5b:	80 79 03 00          	cmpb   $0x0,0x3(%rcx)
    2b5f:	0f 85 3b f1 ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    2b65:	8b 79 1c             	mov    0x1c(%rcx),%edi
    2b68:	85 ff                	test   %edi,%edi
    2b6a:	0f 85 30 f1 ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    2b70:	66 44 0f 28 d0       	movapd %xmm0,%xmm10
    2b75:	66 44 0f 54 d3       	andpd  %xmm3,%xmm10
    2b7a:	66 41 0f 2e f2       	ucomisd %xmm10,%xmm6
    2b7f:	0f 82 1b f1 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    2b85:	66 44 0f 28 d1       	movapd %xmm1,%xmm10
    2b8a:	66 44 0f 54 d3       	andpd  %xmm3,%xmm10
    2b8f:	66 41 0f 2e f2       	ucomisd %xmm10,%xmm6
    2b94:	0f 82 06 f1 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    2b9a:	66 44 0f 28 d2       	movapd %xmm2,%xmm10
    2b9f:	66 44 0f 54 d3       	andpd  %xmm3,%xmm10
    2ba4:	66 41 0f 2e f2       	ucomisd %xmm10,%xmm6
    2ba9:	0f 82 f1 f0 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    2baf:	f2 0f 59 c0          	mulsd  %xmm0,%xmm0
    2bb3:	f2 0f 59 c9          	mulsd  %xmm1,%xmm1
    2bb7:	f2 0f 59 d2          	mulsd  %xmm2,%xmm2
    2bbb:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    2bbf:	f2 0f 58 c2          	addsd  %xmm2,%xmm0
    2bc3:	f2 0f 5c 05 00 00 00 	subsd  0x0(%rip),%xmm0        # 2bcb <ayatsuri_model_open+0xf6b>
    2bca:	00 
			2bc7: R_X86_64_PC32	.LC9-0x4
    2bcb:	66 0f 54 c3          	andpd  %xmm3,%xmm0
    2bcf:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 2bd7 <ayatsuri_model_open+0xf77>
    2bd6:	00 
			2bd3: R_X86_64_PC32	.LC29-0x4
    2bd7:	0f 87 c3 f0 ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    2bdd:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 2be5 <ayatsuri_model_open+0xf85>
    2be4:	00 
			2be1: R_X86_64_PC32	.LC1-0x4
    2be5:	0f 28 c7             	movaps %xmm7,%xmm0
    2be8:	0f 54 05 00 00 00 00 	andps  0x0(%rip),%xmm0        # 2bef <ayatsuri_model_open+0xf8f>
			2beb: R_X86_64_PC32	.LC0-0x4
    2bef:	0f 2e d0             	ucomiss %xmm0,%xmm2
    2bf2:	0f 82 a8 f0 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    2bf8:	0f 28 c5             	movaps %xmm5,%xmm0
    2bfb:	41 0f 57 c1          	xorps  %xmm9,%xmm0
    2bff:	0f 2f c7             	comiss %xmm7,%xmm0
    2c02:	0f 87 98 f0 ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    2c08:	0f 2f fd             	comiss %xmm5,%xmm7
    2c0b:	0f 87 8f f0 ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    2c11:	0f 28 c4             	movaps %xmm4,%xmm0
    2c14:	0f 54 05 00 00 00 00 	andps  0x0(%rip),%xmm0        # 2c1b <ayatsuri_model_open+0xfbb>
			2c17: R_X86_64_PC32	.LC0-0x4
    2c1b:	0f 2e d0             	ucomiss %xmm0,%xmm2
    2c1e:	0f 82 7c f0 ff ff    	jb     1ca0 <ayatsuri_model_open+0x40>
    2c24:	66 0f ef c0          	pxor   %xmm0,%xmm0
    2c28:	0f 2e e0             	ucomiss %xmm0,%xmm4
    2c2b:	7a 02                	jp     2c2f <ayatsuri_model_open+0xfcf>
    2c2d:	74 13                	je     2c42 <ayatsuri_model_open+0xfe2>
    2c2f:	44 0f 2f c4          	comiss %xmm4,%xmm8
    2c33:	0f 87 67 f0 ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    2c39:	0f 2f e5             	comiss %xmm5,%xmm4
    2c3c:	0f 87 5e f0 ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    2c42:	81 79 18 ff ff ff 00 	cmpl   $0xffffff,0x18(%rcx)
    2c49:	0f 87 51 f0 ff ff    	ja     1ca0 <ayatsuri_model_open+0x40>
    2c4f:	39 fe                	cmp    %edi,%esi
    2c51:	74 65                	je     2cb8 <ayatsuri_model_open+0x1058>
    2c53:	89 f9                	mov    %edi,%ecx
    2c55:	c1 e1 05             	shl    $0x5,%ecx
    2c58:	66 45 39 14 0b       	cmp    %r10w,(%r11,%rcx,1)
    2c5d:	0f 84 3d f0 ff ff    	je     1ca0 <ayatsuri_model_open+0x40>
    2c63:	83 c7 01             	add    $0x1,%edi
    2c66:	eb e7                	jmp    2c4f <ayatsuri_model_open+0xfef>
    2c68:	40 80 ff 02          	cmp    $0x2,%dil
    2c6c:	0f 85 2e f0 ff ff    	jne    1ca0 <ayatsuri_model_open+0x40>
    2c72:	f3 0f 10 2d 00 00 00 	movss  0x0(%rip),%xmm5        # 2c7a <ayatsuri_model_open+0x101a>
    2c79:	00 
			2c76: R_X86_64_PC32	.LC3-0x4
    2c7a:	e9 dc fe ff ff       	jmp    2b5b <ayatsuri_model_open+0xefb>
    2c7f:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
    2c84:	4c 89 fa             	mov    %r15,%rdx
    2c87:	89 de                	mov    %ebx,%esi
    2c89:	e8 b2 da ff ff       	call   740 <node_slot_bytes>
    2c8e:	e9 dd fd ff ff       	jmp    2a70 <ayatsuri_model_open+0xe10>
    2c93:	80 7c 24 28 00       	cmpb   $0x0,0x28(%rsp)
    2c98:	74 07                	je     2ca1 <ayatsuri_model_open+0x1041>
    2c9a:	89 94 24 a0 00 00 00 	mov    %edx,0xa0(%rsp)
    2ca1:	48 8d b4 24 90 00 00 	lea    0x90(%rsp),%rsi
    2ca8:	00 
    2ca9:	b9 20 00 00 00       	mov    $0x20,%ecx
    2cae:	48 89 ef             	mov    %rbp,%rdi
    2cb1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
    2cb3:	e9 ee ef ff ff       	jmp    1ca6 <ayatsuri_model_open+0x46>
    2cb8:	41 80 f8 05          	cmp    $0x5,%r8b
    2cbc:	75 07                	jne    2cc5 <ayatsuri_model_open+0x1065>
    2cbe:	88 44 24 28          	mov    %al,0x28(%rsp)
    2cc2:	83 c2 18             	add    $0x18,%edx
    2cc5:	83 c6 01             	add    $0x1,%esi
    2cc8:	e9 0d fe ff ff       	jmp    2ada <ayatsuri_model_open+0xe7a>
    2ccd:	0f 1f 00             	nopl   (%rax)

0000000000002cd0 <ayatsuri_model_find_node>:
    2cd0:	48 85 ff             	test   %rdi,%rdi
    2cd3:	0f 84 1f 01 00 00    	je     2df8 <ayatsuri_model_find_node+0x128>
    2cd9:	41 57                	push   %r15
    2cdb:	41 56                	push   %r14
    2cdd:	41 55                	push   %r13
    2cdf:	41 54                	push   %r12
    2ce1:	55                   	push   %rbp
    2ce2:	48 89 fd             	mov    %rdi,%rbp
    2ce5:	53                   	push   %rbx
    2ce6:	48 83 ec 18          	sub    $0x18,%rsp
    2cea:	4c 8b 3f             	mov    (%rdi),%r15
    2ced:	4d 85 ff             	test   %r15,%r15
    2cf0:	0f 84 d2 00 00 00    	je     2dc8 <ayatsuri_model_find_node+0xf8>
    2cf6:	49 89 f6             	mov    %rsi,%r14
    2cf9:	48 85 f6             	test   %rsi,%rsi
    2cfc:	0f 84 c6 00 00 00    	je     2dc8 <ayatsuri_model_find_node+0xf8>
    2d02:	49 89 cd             	mov    %rcx,%r13
    2d05:	48 85 c9             	test   %rcx,%rcx
    2d08:	0f 84 ba 00 00 00    	je     2dc8 <ayatsuri_model_find_node+0xf8>
    2d0e:	49 89 d4             	mov    %rdx,%r12
    2d11:	48 8d 52 ff          	lea    -0x1(%rdx),%rdx
    2d15:	b8 01 00 00 00       	mov    $0x1,%eax
    2d1a:	48 83 fa 7e          	cmp    $0x7e,%rdx
    2d1e:	0f 87 a9 00 00 00    	ja     2dcd <ayatsuri_model_find_node+0xfd>
    2d24:	48 39 cf             	cmp    %rcx,%rdi
    2d27:	0f 83 b3 00 00 00    	jae    2de0 <ayatsuri_model_find_node+0x110>
    2d2d:	48 89 ca             	mov    %rcx,%rdx
    2d30:	48 29 fa             	sub    %rdi,%rdx
    2d33:	48 83 fa 7f          	cmp    $0x7f,%rdx
    2d37:	0f 86 90 00 00 00    	jbe    2dcd <ayatsuri_model_find_node+0xfd>
    2d3d:	8b 55 08             	mov    0x8(%rbp),%edx
    2d40:	48 85 d2             	test   %rdx,%rdx
    2d43:	74 1b                	je     2d60 <ayatsuri_model_find_node+0x90>
    2d45:	4d 39 ef             	cmp    %r13,%r15
    2d48:	0f 82 c2 00 00 00    	jb     2e10 <ayatsuri_model_find_node+0x140>
    2d4e:	4c 89 fa             	mov    %r15,%rdx
    2d51:	b8 01 00 00 00       	mov    $0x1,%eax
    2d56:	4c 29 ea             	sub    %r13,%rdx
    2d59:	48 83 fa 01          	cmp    $0x1,%rdx
    2d5d:	76 6e                	jbe    2dcd <ayatsuri_model_find_node+0xfd>
    2d5f:	90                   	nop
    2d60:	0f b7 45 0c          	movzwl 0xc(%rbp),%eax
    2d64:	85 c0                	test   %eax,%eax
    2d66:	0f 84 94 00 00 00    	je     2e00 <ayatsuri_model_find_node+0x130>
    2d6c:	8b 5d 3c             	mov    0x3c(%rbp),%ebx
    2d6f:	83 e8 01             	sub    $0x1,%eax
    2d72:	4c 01 fb             	add    %r15,%rbx
    2d75:	48 8d 4c c3 08       	lea    0x8(%rbx,%rax,8),%rcx
    2d7a:	eb 0d                	jmp    2d89 <ayatsuri_model_find_node+0xb9>
    2d7c:	0f 1f 40 00          	nopl   0x0(%rax)
    2d80:	48 83 c3 08          	add    $0x8,%rbx
    2d84:	48 39 d9             	cmp    %rbx,%rcx
    2d87:	74 77                	je     2e00 <ayatsuri_model_find_node+0x130>
    2d89:	0f b7 43 02          	movzwl 0x2(%rbx),%eax
    2d8d:	4c 39 e0             	cmp    %r12,%rax
    2d90:	75 ee                	jne    2d80 <ayatsuri_model_find_node+0xb0>
    2d92:	8b 43 04             	mov    0x4(%rbx),%eax
    2d95:	8b 7d 44             	mov    0x44(%rbp),%edi
    2d98:	4c 89 e2             	mov    %r12,%rdx
    2d9b:	4c 89 f6             	mov    %r14,%rsi
    2d9e:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    2da3:	48 01 c7             	add    %rax,%rdi
    2da6:	4c 01 ff             	add    %r15,%rdi
    2da9:	e8 00 00 00 00       	call   2dae <ayatsuri_model_find_node+0xde>
			2daa: R_X86_64_PLT32	memcmp-0x4
    2dae:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
    2db3:	85 c0                	test   %eax,%eax
    2db5:	75 c9                	jne    2d80 <ayatsuri_model_find_node+0xb0>
    2db7:	0f b7 03             	movzwl (%rbx),%eax
    2dba:	66 41 89 45 00       	mov    %ax,0x0(%r13)
    2dbf:	31 c0                	xor    %eax,%eax
    2dc1:	eb 0a                	jmp    2dcd <ayatsuri_model_find_node+0xfd>
    2dc3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    2dc8:	b8 01 00 00 00       	mov    $0x1,%eax
    2dcd:	48 83 c4 18          	add    $0x18,%rsp
    2dd1:	5b                   	pop    %rbx
    2dd2:	5d                   	pop    %rbp
    2dd3:	41 5c                	pop    %r12
    2dd5:	41 5d                	pop    %r13
    2dd7:	41 5e                	pop    %r14
    2dd9:	41 5f                	pop    %r15
    2ddb:	c3                   	ret
    2ddc:	0f 1f 40 00          	nopl   0x0(%rax)
    2de0:	48 89 fa             	mov    %rdi,%rdx
    2de3:	48 29 ca             	sub    %rcx,%rdx
    2de6:	48 83 fa 01          	cmp    $0x1,%rdx
    2dea:	76 e1                	jbe    2dcd <ayatsuri_model_find_node+0xfd>
    2dec:	e9 4c ff ff ff       	jmp    2d3d <ayatsuri_model_find_node+0x6d>
    2df1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    2df8:	b8 01 00 00 00       	mov    $0x1,%eax
    2dfd:	c3                   	ret
    2dfe:	66 90                	xchg   %ax,%ax
    2e00:	b8 05 00 00 00       	mov    $0x5,%eax
    2e05:	eb c6                	jmp    2dcd <ayatsuri_model_find_node+0xfd>
    2e07:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    2e0e:	00 00 
    2e10:	4c 89 e9             	mov    %r13,%rcx
    2e13:	b8 01 00 00 00       	mov    $0x1,%eax
    2e18:	4c 29 f9             	sub    %r15,%rcx
    2e1b:	48 39 d1             	cmp    %rdx,%rcx
    2e1e:	72 ad                	jb     2dcd <ayatsuri_model_find_node+0xfd>
    2e20:	e9 3b ff ff ff       	jmp    2d60 <ayatsuri_model_find_node+0x90>
    2e25:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    2e2c:	00 00 00 00 

0000000000002e30 <ayatsuri_model_instance_bytes>:
    2e30:	31 c0                	xor    %eax,%eax
    2e32:	48 85 ff             	test   %rdi,%rdi
    2e35:	74 15                	je     2e4c <ayatsuri_model_instance_bytes+0x1c>
    2e37:	48 83 3f 00          	cmpq   $0x0,(%rdi)
    2e3b:	74 0f                	je     2e4c <ayatsuri_model_instance_bytes+0x1c>
    2e3d:	0f b7 47 0c          	movzwl 0xc(%rdi),%eax
    2e41:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
    2e45:	8b 47 10             	mov    0x10(%rdi),%eax
    2e48:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
    2e4c:	c3                   	ret
    2e4d:	0f 1f 00             	nopl   (%rax)

0000000000002e50 <ayatsuri_model_instance_init>:
    2e50:	b8 01 00 00 00       	mov    $0x1,%eax
    2e55:	48 85 ff             	test   %rdi,%rdi
    2e58:	0f 84 a2 00 00 00    	je     2f00 <ayatsuri_model_instance_init+0xb0>
    2e5e:	41 57                	push   %r15
    2e60:	41 56                	push   %r14
    2e62:	41 55                	push   %r13
    2e64:	41 54                	push   %r12
    2e66:	55                   	push   %rbp
    2e67:	48 89 cd             	mov    %rcx,%rbp
    2e6a:	53                   	push   %rbx
    2e6b:	48 89 fb             	mov    %rdi,%rbx
    2e6e:	48 81 ec c8 00 00 00 	sub    $0xc8,%rsp
    2e75:	48 8b 0f             	mov    (%rdi),%rcx
    2e78:	48 85 c9             	test   %rcx,%rcx
    2e7b:	74 5e                	je     2edb <ayatsuri_model_instance_init+0x8b>
    2e7d:	0f b7 47 0c          	movzwl 0xc(%rdi),%eax
    2e81:	49 89 f2             	mov    %rsi,%r10
    2e84:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
    2e88:	8b 47 10             	mov    0x10(%rdi),%eax
    2e8b:	4c 8d 24 f0          	lea    (%rax,%rsi,8),%r12
    2e8f:	4d 85 e4             	test   %r12,%r12
    2e92:	74 5c                	je     2ef0 <ayatsuri_model_instance_init+0xa0>
    2e94:	4d 85 d2             	test   %r10,%r10
    2e97:	74 57                	je     2ef0 <ayatsuri_model_instance_init+0xa0>
    2e99:	48 85 ed             	test   %rbp,%rbp
    2e9c:	0f 94 c0             	sete   %al
    2e9f:	4d 85 c9             	test   %r9,%r9
    2ea2:	40 0f 94 c6          	sete   %sil
    2ea6:	40 08 f0             	or     %sil,%al
    2ea9:	75 45                	jne    2ef0 <ayatsuri_model_instance_init+0xa0>
    2eab:	45 85 c0             	test   %r8d,%r8d
    2eae:	74 40                	je     2ef0 <ayatsuri_model_instance_init+0xa0>
    2eb0:	4d 89 d5             	mov    %r10,%r13
    2eb3:	41 f6 c2 07          	test   $0x7,%r10b
    2eb7:	75 37                	jne    2ef0 <ayatsuri_model_instance_init+0xa0>
    2eb9:	4c 39 e2             	cmp    %r12,%rdx
    2ebc:	72 32                	jb     2ef0 <ayatsuri_model_instance_init+0xa0>
    2ebe:	8b 57 08             	mov    0x8(%rdi),%edx
    2ec1:	48 85 d2             	test   %rdx,%rdx
    2ec4:	74 5a                	je     2f20 <ayatsuri_model_instance_init+0xd0>
    2ec6:	4c 39 d1             	cmp    %r10,%rcx
    2ec9:	72 3d                	jb     2f08 <ayatsuri_model_instance_init+0xb8>
    2ecb:	48 89 ce             	mov    %rcx,%rsi
    2ece:	b8 01 00 00 00       	mov    $0x1,%eax
    2ed3:	4c 29 d6             	sub    %r10,%rsi
    2ed6:	4c 39 e6             	cmp    %r12,%rsi
    2ed9:	73 45                	jae    2f20 <ayatsuri_model_instance_init+0xd0>
    2edb:	48 81 c4 c8 00 00 00 	add    $0xc8,%rsp
    2ee2:	5b                   	pop    %rbx
    2ee3:	5d                   	pop    %rbp
    2ee4:	41 5c                	pop    %r12
    2ee6:	41 5d                	pop    %r13
    2ee8:	41 5e                	pop    %r14
    2eea:	41 5f                	pop    %r15
    2eec:	c3                   	ret
    2eed:	0f 1f 00             	nopl   (%rax)
    2ef0:	b8 01 00 00 00       	mov    $0x1,%eax
    2ef5:	eb e4                	jmp    2edb <ayatsuri_model_instance_init+0x8b>
    2ef7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    2efe:	00 00 
    2f00:	c3                   	ret
    2f01:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    2f08:	4c 89 d6             	mov    %r10,%rsi
    2f0b:	b8 01 00 00 00       	mov    $0x1,%eax
    2f10:	48 29 ce             	sub    %rcx,%rsi
    2f13:	48 39 d6             	cmp    %rdx,%rsi
    2f16:	72 c3                	jb     2edb <ayatsuri_model_instance_init+0x8b>
    2f18:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    2f1f:	00 
    2f20:	4c 39 d3             	cmp    %r10,%rbx
    2f23:	0f 83 27 02 00 00    	jae    3150 <ayatsuri_model_instance_init+0x300>
    2f29:	4c 89 d6             	mov    %r10,%rsi
    2f2c:	b8 01 00 00 00       	mov    $0x1,%eax
    2f31:	48 29 de             	sub    %rbx,%rsi
    2f34:	48 83 fe 7f          	cmp    $0x7f,%rsi
    2f38:	76 a1                	jbe    2edb <ayatsuri_model_instance_init+0x8b>
    2f3a:	4d 39 d1             	cmp    %r10,%r9
    2f3d:	0f 82 2d 02 00 00    	jb     3170 <ayatsuri_model_instance_init+0x320>
    2f43:	4c 89 ce             	mov    %r9,%rsi
    2f46:	b8 01 00 00 00       	mov    $0x1,%eax
    2f4b:	4c 29 d6             	sub    %r10,%rsi
    2f4e:	4c 39 e6             	cmp    %r12,%rsi
    2f51:	72 88                	jb     2edb <ayatsuri_model_instance_init+0x8b>
    2f53:	4c 39 cb             	cmp    %r9,%rbx
    2f56:	0f 82 34 02 00 00    	jb     3190 <ayatsuri_model_instance_init+0x340>
    2f5c:	48 89 de             	mov    %rbx,%rsi
    2f5f:	b8 01 00 00 00       	mov    $0x1,%eax
    2f64:	4c 29 ce             	sub    %r9,%rsi
    2f67:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    2f6e:	0f 86 67 ff ff ff    	jbe    2edb <ayatsuri_model_instance_init+0x8b>
    2f74:	48 85 d2             	test   %rdx,%rdx
    2f77:	74 1e                	je     2f97 <ayatsuri_model_instance_init+0x147>
    2f79:	4c 39 c9             	cmp    %r9,%rcx
    2f7c:	0f 82 ed 02 00 00    	jb     326f <ayatsuri_model_instance_init+0x41f>
    2f82:	4c 29 c9             	sub    %r9,%rcx
    2f85:	b8 01 00 00 00       	mov    $0x1,%eax
    2f8a:	48 81 f9 a7 00 00 00 	cmp    $0xa7,%rcx
    2f91:	0f 86 44 ff ff ff    	jbe    2edb <ayatsuri_model_instance_init+0x8b>
    2f97:	4c 89 d7             	mov    %r10,%rdi
    2f9a:	4c 89 e2             	mov    %r12,%rdx
    2f9d:	31 f6                	xor    %esi,%esi
    2f9f:	4c 89 4c 24 08       	mov    %r9,0x8(%rsp)
    2fa4:	44 89 44 24 04       	mov    %r8d,0x4(%rsp)
    2fa9:	e8 00 00 00 00       	call   2fae <ayatsuri_model_instance_init+0x15e>
			2faa: R_X86_64_PLT32	memset-0x4
    2fae:	0f b7 53 0c          	movzwl 0xc(%rbx),%edx
    2fb2:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
    2fb7:	b9 15 00 00 00       	mov    $0x15,%ecx
    2fbc:	49 89 c2             	mov    %rax,%r10
    2fbf:	31 c0                	xor    %eax,%eax
    2fc1:	44 8b 44 24 04       	mov    0x4(%rsp),%r8d
    2fc6:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
    2fcb:	f3 48 ab             	rep stos %rax,%es:(%rdi)
    2fce:	89 d0                	mov    %edx,%eax
    2fd0:	8d 14 52             	lea    (%rdx,%rdx,2),%edx
    2fd3:	66 85 c0             	test   %ax,%ax
    2fd6:	44 8d 34 d5 00 00 00 	lea    0x0(,%rdx,8),%r14d
    2fdd:	00 
    2fde:	0f 84 a4 02 00 00    	je     3288 <ayatsuri_model_instance_init+0x438>
    2fe4:	f3 0f 7e 0d 00 00 00 	movq   0x0(%rip),%xmm1        # 2fec <ayatsuri_model_instance_init+0x19c>
    2feb:	00 
			2fe8: R_X86_64_PC32	.LC32-0x4
    2fec:	45 31 db             	xor    %r11d,%r11d
    2fef:	45 31 ff             	xor    %r15d,%r15d
    2ff2:	eb 3f                	jmp    3033 <ayatsuri_model_instance_init+0x1e3>
    2ff4:	0f 1f 40 00          	nopl   0x0(%rax)
    2ff8:	b9 d3 ff ff ff       	mov    $0xffffffd3,%ecx
    2ffd:	41 39 cf             	cmp    %ecx,%r15d
    3000:	41 0f 46 cf          	cmovbe %r15d,%ecx
    3004:	44 8d 79 2c          	lea    0x2c(%rcx),%r15d
    3008:	8b 4a 0c             	mov    0xc(%rdx),%ecx
    300b:	89 8e 34 01 00 00    	mov    %ecx,0x134(%rsi)
    3011:	89 c6                	mov    %eax,%esi
    3013:	48 89 df             	mov    %rbx,%rdi
    3016:	49 83 c3 01          	add    $0x1,%r11
    301a:	49 83 c5 18          	add    $0x18,%r13
    301e:	e8 1d d7 ff ff       	call   740 <node_slot_bytes>
    3023:	41 01 c6             	add    %eax,%r14d
    3026:	0f b7 43 0c          	movzwl 0xc(%rbx),%eax
    302a:	41 39 c3             	cmp    %eax,%r11d
    302d:	0f 83 77 01 00 00    	jae    31aa <ayatsuri_model_instance_init+0x35a>
    3033:	8b 53 14             	mov    0x14(%rbx),%edx
    3036:	4c 89 de             	mov    %r11,%rsi
    3039:	48 8b 0b             	mov    (%rbx),%rcx
    303c:	45 89 75 08          	mov    %r14d,0x8(%r13)
    3040:	48 c1 e6 04          	shl    $0x4,%rsi
    3044:	4f 8d 04 db          	lea    (%r11,%r11,8),%r8
    3048:	44 89 d8             	mov    %r11d,%eax
    304b:	48 01 f2             	add    %rsi,%rdx
    304e:	48 01 ca             	add    %rcx,%rdx
    3051:	0f b6 72 03          	movzbl 0x3(%rdx),%esi
    3055:	41 88 75 10          	mov    %sil,0x10(%r13)
    3059:	8b 7b 1c             	mov    0x1c(%rbx),%edi
    305c:	44 89 f6             	mov    %r14d,%esi
    305f:	49 8d 74 32 30       	lea    0x30(%r10,%rsi,1),%rsi
    3064:	4a 8d 3c 87          	lea    (%rdi,%r8,4),%rdi
    3068:	48 01 f9             	add    %rdi,%rcx
    306b:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
    306f:	0f 11 06             	movups %xmm0,(%rsi)
    3072:	f3 0f 6f 41 10       	movdqu 0x10(%rcx),%xmm0
    3077:	0f 11 46 10          	movups %xmm0,0x10(%rsi)
    307b:	8b 49 20             	mov    0x20(%rcx),%ecx
    307e:	89 4e 20             	mov    %ecx,0x20(%rsi)
    3081:	b9 db ff ff ff       	mov    $0xffffffdb,%ecx
    3086:	41 39 cf             	cmp    %ecx,%r15d
    3089:	41 0f 46 cf          	cmovbe %r15d,%ecx
    308d:	44 8d 79 24          	lea    0x24(%rcx),%r15d
    3091:	0f b6 4a 02          	movzbl 0x2(%rdx),%ecx
    3095:	84 c9                	test   %cl,%cl
    3097:	0f 84 74 ff ff ff    	je     3011 <ayatsuri_model_instance_init+0x1c1>
    309d:	80 f9 03             	cmp    $0x3,%cl
    30a0:	0f 84 6b ff ff ff    	je     3011 <ayatsuri_model_instance_init+0x1c1>
    30a6:	0f b7 4a 08          	movzwl 0x8(%rdx),%ecx
    30aa:	41 b8 08 01 00 00    	mov    $0x108,%r8d
    30b0:	8d 34 c9             	lea    (%rcx,%rcx,8),%esi
    30b3:	8b 4b 34             	mov    0x34(%rbx),%ecx
    30b6:	c1 e6 03             	shl    $0x3,%esi
    30b9:	48 01 ce             	add    %rcx,%rsi
    30bc:	48 03 33             	add    (%rbx),%rsi
    30bf:	8b 4e 2c             	mov    0x2c(%rsi),%ecx
    30c2:	48 8d 7e 38          	lea    0x38(%rsi),%rdi
    30c6:	41 89 4d 0c          	mov    %ecx,0xc(%r13)
    30ca:	b9 2c 00 00 00       	mov    $0x2c,%ecx
    30cf:	e8 2c cf ff ff       	call   0 <md>
    30d4:	41 8b 7d 08          	mov    0x8(%r13),%edi
    30d8:	f2 41 0f 11 45 00    	movsd  %xmm0,0x0(%r13)
    30de:	80 7a 02 01          	cmpb   $0x1,0x2(%rdx)
    30e2:	75 0b                	jne    30ef <ayatsuri_model_instance_init+0x29f>
    30e4:	b9 20 00 00 00       	mov    $0x20,%ecx
    30e9:	41 b8 a4 00 00 00    	mov    $0xa4,%r8d
    30ef:	49 01 f8             	add    %rdi,%r8
    30f2:	48 8b 3e             	mov    (%rsi),%rdi
    30f5:	4d 01 d0             	add    %r10,%r8
    30f8:	49 89 38             	mov    %rdi,(%r8)
    30fb:	48 8b 7c 0e f8       	mov    -0x8(%rsi,%rcx,1),%rdi
    3100:	4a 89 7c 01 f8       	mov    %rdi,-0x8(%rcx,%r8,1)
    3105:	49 8d 78 08          	lea    0x8(%r8),%rdi
    3109:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
    310d:	49 29 f8             	sub    %rdi,%r8
    3110:	44 01 c1             	add    %r8d,%ecx
    3113:	4c 29 c6             	sub    %r8,%rsi
    3116:	c1 e9 03             	shr    $0x3,%ecx
    3119:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    311c:	41 8b 4d 08          	mov    0x8(%r13),%ecx
    3120:	80 7a 02 01          	cmpb   $0x1,0x2(%rdx)
    3124:	49 8d 34 0a          	lea    (%r10,%rcx,1),%rsi
    3128:	0f 85 ca fe ff ff    	jne    2ff8 <ayatsuri_model_instance_init+0x1a8>
    312e:	b9 df ff ff ff       	mov    $0xffffffdf,%ecx
    3133:	0f 13 8e fc 00 00 00 	movlps %xmm1,0xfc(%rsi)
    313a:	41 39 cf             	cmp    %ecx,%r15d
    313d:	41 0f 46 cf          	cmovbe %r15d,%ecx
    3141:	44 8d 79 20          	lea    0x20(%rcx),%r15d
    3145:	e9 c7 fe ff ff       	jmp    3011 <ayatsuri_model_instance_init+0x1c1>
    314a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3150:	48 89 de             	mov    %rbx,%rsi
    3153:	b8 01 00 00 00       	mov    $0x1,%eax
    3158:	4c 29 d6             	sub    %r10,%rsi
    315b:	4c 39 e6             	cmp    %r12,%rsi
    315e:	0f 82 77 fd ff ff    	jb     2edb <ayatsuri_model_instance_init+0x8b>
    3164:	e9 d1 fd ff ff       	jmp    2f3a <ayatsuri_model_instance_init+0xea>
    3169:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3170:	4c 89 d6             	mov    %r10,%rsi
    3173:	b8 01 00 00 00       	mov    $0x1,%eax
    3178:	4c 29 ce             	sub    %r9,%rsi
    317b:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    3182:	0f 86 53 fd ff ff    	jbe    2edb <ayatsuri_model_instance_init+0x8b>
    3188:	e9 c6 fd ff ff       	jmp    2f53 <ayatsuri_model_instance_init+0x103>
    318d:	0f 1f 00             	nopl   (%rax)
    3190:	4c 89 ce             	mov    %r9,%rsi
    3193:	b8 01 00 00 00       	mov    $0x1,%eax
    3198:	48 29 de             	sub    %rbx,%rsi
    319b:	48 83 fe 7f          	cmp    $0x7f,%rsi
    319f:	0f 86 36 fd ff ff    	jbe    2edb <ayatsuri_model_instance_init+0x8b>
    31a5:	e9 ca fd ff ff       	jmp    2f74 <ayatsuri_model_instance_init+0x124>
    31aa:	44 8b 44 24 04       	mov    0x4(%rsp),%r8d
    31af:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
    31b4:	48 89 5c 24 10       	mov    %rbx,0x10(%rsp)
    31b9:	4c 89 54 24 18       	mov    %r10,0x18(%rsp)
    31be:	66 0f 6f 44 24 10    	movdqa 0x10(%rsp),%xmm0
    31c4:	48 89 6c 24 20       	mov    %rbp,0x20(%rsp)
    31c9:	4c 89 64 24 28       	mov    %r12,0x28(%rsp)
    31ce:	41 0f 11 01          	movups %xmm0,(%r9)
    31d2:	66 0f 6f 44 24 20    	movdqa 0x20(%rsp),%xmm0
    31d8:	44 89 44 24 30       	mov    %r8d,0x30(%rsp)
    31dd:	41 0f 11 41 10       	movups %xmm0,0x10(%r9)
    31e2:	66 0f 6f 44 24 30    	movdqa 0x30(%rsp),%xmm0
    31e8:	44 89 bc 24 ac 00 00 	mov    %r15d,0xac(%rsp)
    31ef:	00 
    31f0:	41 0f 11 41 20       	movups %xmm0,0x20(%r9)
    31f5:	66 0f 6f 44 24 40    	movdqa 0x40(%rsp),%xmm0
    31fb:	c6 84 24 b4 00 00 00 	movb   $0x1,0xb4(%rsp)
    3202:	01 
    3203:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
    320a:	00 
    320b:	41 0f 11 41 30       	movups %xmm0,0x30(%r9)
    3210:	66 0f 6f 44 24 50    	movdqa 0x50(%rsp),%xmm0
    3216:	49 89 81 a0 00 00 00 	mov    %rax,0xa0(%r9)
    321d:	31 c0                	xor    %eax,%eax
    321f:	41 0f 11 41 40       	movups %xmm0,0x40(%r9)
    3224:	66 0f 6f 44 24 60    	movdqa 0x60(%rsp),%xmm0
    322a:	41 0f 11 41 50       	movups %xmm0,0x50(%r9)
    322f:	66 0f 6f 44 24 70    	movdqa 0x70(%rsp),%xmm0
    3235:	41 0f 11 41 60       	movups %xmm0,0x60(%r9)
    323a:	66 0f 6f 84 24 80 00 	movdqa 0x80(%rsp),%xmm0
    3241:	00 00 
    3243:	41 0f 11 41 70       	movups %xmm0,0x70(%r9)
    3248:	66 0f 6f 84 24 90 00 	movdqa 0x90(%rsp),%xmm0
    324f:	00 00 
    3251:	41 0f 11 81 80 00 00 	movups %xmm0,0x80(%r9)
    3258:	00 
    3259:	66 0f 6f 84 24 a0 00 	movdqa 0xa0(%rsp),%xmm0
    3260:	00 00 
    3262:	41 0f 11 81 90 00 00 	movups %xmm0,0x90(%r9)
    3269:	00 
    326a:	e9 6c fc ff ff       	jmp    2edb <ayatsuri_model_instance_init+0x8b>
    326f:	4c 89 ce             	mov    %r9,%rsi
    3272:	b8 01 00 00 00       	mov    $0x1,%eax
    3277:	48 29 ce             	sub    %rcx,%rsi
    327a:	48 39 d6             	cmp    %rdx,%rsi
    327d:	0f 82 58 fc ff ff    	jb     2edb <ayatsuri_model_instance_init+0x8b>
    3283:	e9 0f fd ff ff       	jmp    2f97 <ayatsuri_model_instance_init+0x147>
    3288:	45 31 ff             	xor    %r15d,%r15d
    328b:	e9 24 ff ff ff       	jmp    31b4 <ayatsuri_model_instance_init+0x364>

0000000000003290 <ayatsuri_model_instance_dispose>:
    3290:	b8 03 00 00 00       	mov    $0x3,%eax
    3295:	48 85 ff             	test   %rdi,%rdi
    3298:	74 46                	je     32e0 <ayatsuri_model_instance_dispose+0x50>
    329a:	48 85 f6             	test   %rsi,%rsi
    329d:	74 41                	je     32e0 <ayatsuri_model_instance_dispose+0x50>
    329f:	48 39 77 10          	cmp    %rsi,0x10(%rdi)
    32a3:	75 3b                	jne    32e0 <ayatsuri_model_instance_dispose+0x50>
    32a5:	39 57 20             	cmp    %edx,0x20(%rdi)
    32a8:	75 36                	jne    32e0 <ayatsuri_model_instance_dispose+0x50>
    32aa:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    32b1:	b8 04 00 00 00       	mov    $0x4,%eax
    32b6:	75 28                	jne    32e0 <ayatsuri_model_instance_dispose+0x50>
    32b8:	c6 87 a4 00 00 00 00 	movb   $0x0,0xa4(%rdi)
    32bf:	31 c0                	xor    %eax,%eax
    32c1:	c6 87 a6 00 00 00 00 	movb   $0x0,0xa6(%rdi)
    32c8:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
    32cf:	00 
    32d0:	48 c7 47 18 00 00 00 	movq   $0x0,0x18(%rdi)
    32d7:	00 
    32d8:	c3                   	ret
    32d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    32e0:	c3                   	ret
    32e1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    32e8:	00 00 00 00 
    32ec:	0f 1f 40 00          	nopl   0x0(%rax)

00000000000032f0 <ayatsuri_model_instance_targets>:
    32f0:	48 85 ff             	test   %rdi,%rdi
    32f3:	0f 84 d7 00 00 00    	je     33d0 <ayatsuri_model_instance_targets+0xe0>
    32f9:	48 89 f8             	mov    %rdi,%rax
    32fc:	bf 03 00 00 00       	mov    $0x3,%edi
    3301:	80 b8 a4 00 00 00 01 	cmpb   $0x1,0xa4(%rax)
    3308:	0f 85 c7 00 00 00    	jne    33d5 <ayatsuri_model_instance_targets+0xe5>
    330e:	48 85 f6             	test   %rsi,%rsi
    3311:	0f 84 be 00 00 00    	je     33d5 <ayatsuri_model_instance_targets+0xe5>
    3317:	48 3b 70 10          	cmp    0x10(%rax),%rsi
    331b:	0f 85 b4 00 00 00    	jne    33d5 <ayatsuri_model_instance_targets+0xe5>
    3321:	3b 50 20             	cmp    0x20(%rax),%edx
    3324:	0f 85 ab 00 00 00    	jne    33d5 <ayatsuri_model_instance_targets+0xe5>
    332a:	80 b8 a5 00 00 00 00 	cmpb   $0x0,0xa5(%rax)
    3331:	bf 04 00 00 00       	mov    $0x4,%edi
    3336:	0f 85 99 00 00 00    	jne    33d5 <ayatsuri_model_instance_targets+0xe5>
    333c:	41 57                	push   %r15
    333e:	41 56                	push   %r14
    3340:	41 55                	push   %r13
    3342:	41 54                	push   %r12
    3344:	55                   	push   %rbp
    3345:	53                   	push   %rbx
    3346:	48 83 ec 18          	sub    $0x18,%rsp
    334a:	48 8b 38             	mov    (%rax),%rdi
    334d:	c6 80 a5 00 00 00 01 	movb   $0x1,0xa5(%rax)
    3354:	0f b7 57 0c          	movzwl 0xc(%rdi),%edx
    3358:	48 89 d3             	mov    %rdx,%rbx
    335b:	48 85 c9             	test   %rcx,%rcx
    335e:	0f 84 8c 00 00 00    	je     33f0 <ayatsuri_model_instance_targets+0x100>
    3364:	48 39 51 20          	cmp    %rdx,0x20(%rcx)
    3368:	0f 85 82 00 00 00    	jne    33f0 <ayatsuri_model_instance_targets+0x100>
    336e:	48 8b 31             	mov    (%rcx),%rsi
    3371:	48 85 f6             	test   %rsi,%rsi
    3374:	74 7a                	je     33f0 <ayatsuri_model_instance_targets+0x100>
    3376:	4c 8b 41 08          	mov    0x8(%rcx),%r8
    337a:	4d 85 c0             	test   %r8,%r8
    337d:	74 71                	je     33f0 <ayatsuri_model_instance_targets+0x100>
    337f:	4c 8b 51 10          	mov    0x10(%rcx),%r10
    3383:	4d 85 d2             	test   %r10,%r10
    3386:	74 68                	je     33f0 <ayatsuri_model_instance_targets+0x100>
    3388:	4c 8b 59 18          	mov    0x18(%rcx),%r11
    338c:	4d 85 db             	test   %r11,%r11
    338f:	74 5f                	je     33f0 <ayatsuri_model_instance_targets+0x100>
    3391:	48 8b 68 18          	mov    0x18(%rax),%rbp
    3395:	4c 8b 48 08          	mov    0x8(%rax),%r9
    3399:	48 85 ed             	test   %rbp,%rbp
    339c:	4c 89 c9             	mov    %r9,%rcx
    339f:	41 0f 95 c4          	setne  %r12b
    33a3:	48 85 d2             	test   %rdx,%rdx
    33a6:	74 68                	je     3410 <ayatsuri_model_instance_targets+0x120>
    33a8:	45 84 e4             	test   %r12b,%r12b
    33ab:	74 63                	je     3410 <ayatsuri_model_instance_targets+0x120>
    33ad:	49 39 f1             	cmp    %rsi,%r9
    33b0:	73 2e                	jae    33e0 <ayatsuri_model_instance_targets+0xf0>
    33b2:	49 89 f5             	mov    %rsi,%r13
    33b5:	4d 29 cd             	sub    %r9,%r13
    33b8:	49 39 ed             	cmp    %rbp,%r13
    33bb:	72 33                	jb     33f0 <ayatsuri_model_instance_targets+0x100>
    33bd:	4c 8d 2c d5 00 00 00 	lea    0x0(,%rdx,8),%r13
    33c4:	00 
    33c5:	4d 8d 7c 15 00       	lea    0x0(%r13,%rdx,1),%r15
    33ca:	49 c1 e7 02          	shl    $0x2,%r15
    33ce:	eb 60                	jmp    3430 <ayatsuri_model_instance_targets+0x140>
    33d0:	bf 03 00 00 00       	mov    $0x3,%edi
    33d5:	89 f8                	mov    %edi,%eax
    33d7:	c3                   	ret
    33d8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    33df:	00 
    33e0:	4d 89 cd             	mov    %r9,%r13
    33e3:	49 29 f5             	sub    %rsi,%r13
    33e6:	49 39 d5             	cmp    %rdx,%r13
    33e9:	73 d2                	jae    33bd <ayatsuri_model_instance_targets+0xcd>
    33eb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    33f0:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    33f7:	bf 01 00 00 00       	mov    $0x1,%edi
    33fc:	48 83 c4 18          	add    $0x18,%rsp
    3400:	89 f8                	mov    %edi,%eax
    3402:	5b                   	pop    %rbx
    3403:	5d                   	pop    %rbp
    3404:	41 5c                	pop    %r12
    3406:	41 5d                	pop    %r13
    3408:	41 5e                	pop    %r14
    340a:	41 5f                	pop    %r15
    340c:	c3                   	ret
    340d:	0f 1f 00             	nopl   (%rax)
    3410:	4c 8d 2c d5 00 00 00 	lea    0x0(,%rdx,8),%r13
    3417:	00 
    3418:	4d 8d 74 15 00       	lea    0x0(%r13,%rdx,1),%r14
    341d:	4e 8d 3c b5 00 00 00 	lea    0x0(,%r14,4),%r15
    3424:	00 
    3425:	4d 85 f6             	test   %r14,%r14
    3428:	74 26                	je     3450 <ayatsuri_model_instance_targets+0x160>
    342a:	45 84 e4             	test   %r12b,%r12b
    342d:	74 21                	je     3450 <ayatsuri_model_instance_targets+0x160>
    342f:	90                   	nop
    3430:	4d 39 c1             	cmp    %r8,%r9
    3433:	0f 82 67 03 00 00    	jb     37a0 <ayatsuri_model_instance_targets+0x4b0>
    3439:	4d 89 ce             	mov    %r9,%r14
    343c:	4d 29 c6             	sub    %r8,%r14
    343f:	4d 39 fe             	cmp    %r15,%r14
    3442:	72 ac                	jb     33f0 <ayatsuri_model_instance_targets+0x100>
    3444:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    344b:	00 00 00 00 
    344f:	90                   	nop
    3450:	4c 8d 34 95 00 00 00 	lea    0x0(,%rdx,4),%r14
    3457:	00 
    3458:	48 85 d2             	test   %rdx,%rdx
    345b:	74 23                	je     3480 <ayatsuri_model_instance_targets+0x190>
    345d:	45 84 e4             	test   %r12b,%r12b
    3460:	74 1e                	je     3480 <ayatsuri_model_instance_targets+0x190>
    3462:	4d 39 d1             	cmp    %r10,%r9
    3465:	0f 82 65 03 00 00    	jb     37d0 <ayatsuri_model_instance_targets+0x4e0>
    346b:	4c 89 ca             	mov    %r9,%rdx
    346e:	4c 29 d2             	sub    %r10,%rdx
    3471:	4c 39 f2             	cmp    %r14,%rdx
    3474:	0f 82 76 ff ff ff    	jb     33f0 <ayatsuri_model_instance_targets+0x100>
    347a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3480:	4d 85 ed             	test   %r13,%r13
    3483:	74 2b                	je     34b0 <ayatsuri_model_instance_targets+0x1c0>
    3485:	45 84 e4             	test   %r12b,%r12b
    3488:	74 26                	je     34b0 <ayatsuri_model_instance_targets+0x1c0>
    348a:	4d 39 d9             	cmp    %r11,%r9
    348d:	0f 82 51 03 00 00    	jb     37e4 <ayatsuri_model_instance_targets+0x4f4>
    3493:	4c 89 ca             	mov    %r9,%rdx
    3496:	4c 29 da             	sub    %r11,%rdx
    3499:	4c 39 ea             	cmp    %r13,%rdx
    349c:	0f 82 4e ff ff ff    	jb     33f0 <ayatsuri_model_instance_targets+0x100>
    34a2:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    34a9:	00 00 00 00 
    34ad:	0f 1f 00             	nopl   (%rax)
    34b0:	44 0f b7 fb          	movzwl %bx,%r15d
    34b4:	45 85 ff             	test   %r15d,%r15d
    34b7:	0f 84 d3 02 00 00    	je     3790 <ayatsuri_model_instance_targets+0x4a0>
    34bd:	8b 57 14             	mov    0x14(%rdi),%edx
    34c0:	4c 89 1c 24          	mov    %r11,(%rsp)
    34c4:	31 ed                	xor    %ebp,%ebp
    34c6:	bb ab aa aa aa       	mov    $0xaaaaaaab,%ebx
    34cb:	48 8b 3f             	mov    (%rdi),%rdi
    34ce:	4c 89 4c 24 08       	mov    %r9,0x8(%rsp)
    34d3:	66 0f ef e4          	pxor   %xmm4,%xmm4
    34d7:	45 31 f6             	xor    %r14d,%r14d
    34da:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
    34df:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 34e7 <ayatsuri_model_instance_targets+0x1f7>
    34e6:	00 
			34e3: R_X86_64_PC32	.LC1-0x4
    34e7:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 34ef <ayatsuri_model_instance_targets+0x1ff>
    34ee:	00 
			34eb: R_X86_64_PC32	.LC0-0x4
    34ef:	48 8d 54 17 02       	lea    0x2(%rdi,%rdx,1),%rdx
    34f4:	44 0f b6 0c 2e       	movzbl (%rsi,%rbp,1),%r9d
    34f9:	45 89 cc             	mov    %r9d,%r12d
    34fc:	45 84 c9             	test   %r9b,%r9b
    34ff:	0f 88 eb fe ff ff    	js     33f0 <ayatsuri_model_instance_targets+0x100>
    3505:	44 89 c9             	mov    %r9d,%ecx
    3508:	f7 d1                	not    %ecx
    350a:	83 e1 18             	and    $0x18,%ecx
    350d:	0f 84 dd fe ff ff    	je     33f0 <ayatsuri_model_instance_targets+0x100>
    3513:	0f b6 0a             	movzbl (%rdx),%ecx
    3516:	84 c9                	test   %cl,%cl
    3518:	0f 84 9a 02 00 00    	je     37b8 <ayatsuri_model_instance_targets+0x4c8>
    351e:	80 f9 03             	cmp    $0x3,%cl
    3521:	0f 84 91 02 00 00    	je     37b8 <ayatsuri_model_instance_targets+0x4c8>
    3527:	41 89 eb             	mov    %ebp,%r11d
    352a:	44 8d 6c ed 00       	lea    0x0(%rbp,%rbp,8),%r13d
    352f:	31 ff                	xor    %edi,%edi
    3531:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    3538:	00 00 00 00 
    353c:	0f 1f 40 00          	nopl   0x0(%rax)
    3540:	89 f9                	mov    %edi,%ecx
    3542:	48 0f af cb          	imul   %rbx,%rcx
    3546:	48 c1 e9 21          	shr    $0x21,%rcx
    354a:	41 0f a3 c9          	bt     %ecx,%r9d
    354e:	73 31                	jae    3581 <ayatsuri_model_instance_targets+0x291>
    3550:	41 8d 4c 3d 00       	lea    0x0(%r13,%rdi,1),%ecx
    3555:	f3 41 0f 10 04 88    	movss  (%r8,%rcx,4),%xmm0
    355b:	0f 28 c8             	movaps %xmm0,%xmm1
    355e:	0f 54 cb             	andps  %xmm3,%xmm1
    3561:	0f 2e d1             	ucomiss %xmm1,%xmm2
    3564:	0f 82 86 fe ff ff    	jb     33f0 <ayatsuri_model_instance_targets+0x100>
    356a:	83 ff 05             	cmp    $0x5,%edi
    356d:	76 12                	jbe    3581 <ayatsuri_model_instance_targets+0x291>
    356f:	0f 2e c4             	ucomiss %xmm4,%xmm0
    3572:	0f 9b c1             	setnp  %cl
    3575:	41 0f 45 ce          	cmovne %r14d,%ecx
    3579:	84 c9                	test   %cl,%cl
    357b:	0f 85 6f fe ff ff    	jne    33f0 <ayatsuri_model_instance_targets+0x100>
    3581:	83 c7 01             	add    $0x1,%edi
    3584:	83 ff 09             	cmp    $0x9,%edi
    3587:	75 b7                	jne    3540 <ayatsuri_model_instance_targets+0x250>
    3589:	41 f6 c4 20          	test   $0x20,%r12b
    358d:	74 0e                	je     359d <ayatsuri_model_instance_targets+0x2ad>
    358f:	41 81 3c aa ff ff ff 	cmpl   $0xffffff,(%r10,%rbp,4)
    3596:	00 
    3597:	0f 87 53 fe ff ff    	ja     33f0 <ayatsuri_model_instance_targets+0x100>
    359d:	41 83 e4 40          	and    $0x40,%r12d
    35a1:	74 5d                	je     3600 <ayatsuri_model_instance_targets+0x310>
    35a3:	48 8b 0c 24          	mov    (%rsp),%rcx
    35a7:	42 8d 3c dd 00 00 00 	lea    0x0(,%r11,8),%edi
    35ae:	00 
    35af:	48 01 cf             	add    %rcx,%rdi
    35b2:	e8 49 ca ff ff       	call   0 <md>
    35b7:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 35bf <ayatsuri_model_instance_targets+0x2cf>
    35be:	00 
			35bb: R_X86_64_PC32	.LC22-0x4
    35bf:	66 0f 28 c8          	movapd %xmm0,%xmm1
    35c3:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 35cb <ayatsuri_model_instance_targets+0x2db>
    35ca:	00 
			35c7: R_X86_64_PC32	.LC8-0x4
    35cb:	66 0f 2e e9          	ucomisd %xmm1,%xmm5
    35cf:	0f 82 1b fe ff ff    	jb     33f0 <ayatsuri_model_instance_targets+0x100>
    35d5:	66 0f ef c9          	pxor   %xmm1,%xmm1
    35d9:	66 0f 2f c1          	comisd %xmm1,%xmm0
    35dd:	0f 82 0d fe ff ff    	jb     33f0 <ayatsuri_model_instance_targets+0x100>
    35e3:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 35eb <ayatsuri_model_instance_targets+0x2fb>
    35ea:	00 
			35e7: R_X86_64_PC32	.LC9-0x4
    35eb:	66 0f 2f c8          	comisd %xmm0,%xmm1
    35ef:	0f 82 fb fd ff ff    	jb     33f0 <ayatsuri_model_instance_targets+0x100>
    35f5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    35fc:	00 00 00 00 
    3600:	48 83 c5 01          	add    $0x1,%rbp
    3604:	48 83 c2 10          	add    $0x10,%rdx
    3608:	44 39 fd             	cmp    %r15d,%ebp
    360b:	0f 82 e3 fe ff ff    	jb     34f4 <ayatsuri_model_instance_targets+0x204>
    3611:	43 8d 1c ff          	lea    (%r15,%r15,8),%ebx
    3615:	4c 8b 1c 24          	mov    (%rsp),%r11
    3619:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
    361e:	45 31 ed             	xor    %r13d,%r13d
    3621:	89 1c 24             	mov    %ebx,(%rsp)
    3624:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
    3629:	41 bc ab aa aa aa    	mov    $0xaaaaaaab,%r12d
    362f:	c6 44 24 08 00       	movb   $0x0,0x8(%rsp)
    3634:	0f b6 1e             	movzbl (%rsi),%ebx
    3637:	8b 69 08             	mov    0x8(%rcx),%ebp
    363a:	45 31 ff             	xor    %r15d,%r15d
    363d:	31 ff                	xor    %edi,%edi
    363f:	41 89 de             	mov    %ebx,%r14d
    3642:	4c 01 cd             	add    %r9,%rbp
    3645:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    364c:	00 00 00 00 
    3650:	89 fa                	mov    %edi,%edx
    3652:	49 0f af d4          	imul   %r12,%rdx
    3656:	48 c1 ea 21          	shr    $0x21,%rdx
    365a:	0f a3 d3             	bt     %edx,%ebx
    365d:	73 3c                	jae    369b <ayatsuri_model_instance_targets+0x3ab>
    365f:	41 8d 54 3d 00       	lea    0x0(%r13,%rdi,1),%edx
    3664:	f3 41 0f 10 04 90    	movss  (%r8,%rdx,4),%xmm0
    366a:	0f 2e 44 bd 30       	ucomiss 0x30(%rbp,%rdi,4),%xmm0
    366f:	7a 02                	jp     3673 <ayatsuri_model_instance_targets+0x383>
    3671:	74 28                	je     369b <ayatsuri_model_instance_targets+0x3ab>
    3673:	8b 90 a0 00 00 00    	mov    0xa0(%rax),%edx
    3679:	41 bf fb ff ff ff    	mov    $0xfffffffb,%r15d
    367f:	f3 0f 11 44 bd 30    	movss  %xmm0,0x30(%rbp,%rdi,4)
    3685:	44 39 fa             	cmp    %r15d,%edx
    3688:	41 0f 47 d7          	cmova  %r15d,%edx
    368c:	41 bf 01 00 00 00    	mov    $0x1,%r15d
    3692:	83 c2 04             	add    $0x4,%edx
    3695:	89 90 a0 00 00 00    	mov    %edx,0xa0(%rax)
    369b:	48 83 c7 01          	add    $0x1,%rdi
    369f:	48 83 ff 09          	cmp    $0x9,%rdi
    36a3:	75 ab                	jne    3650 <ayatsuri_model_instance_targets+0x360>
    36a5:	41 f6 c6 18          	test   $0x18,%r14b
    36a9:	0f 84 49 01 00 00    	je     37f8 <ayatsuri_model_instance_targets+0x508>
    36af:	44 89 f2             	mov    %r14d,%edx
    36b2:	c0 ea 03             	shr    $0x3,%dl
    36b5:	83 e2 01             	and    $0x1,%edx
    36b8:	38 51 10             	cmp    %dl,0x10(%rcx)
    36bb:	0f 84 37 01 00 00    	je     37f8 <ayatsuri_model_instance_targets+0x508>
    36c1:	88 51 10             	mov    %dl,0x10(%rcx)
    36c4:	8b 90 a0 00 00 00    	mov    0xa0(%rax),%edx
    36ca:	31 ff                	xor    %edi,%edi
    36cc:	83 fa ff             	cmp    $0xffffffff,%edx
    36cf:	40 0f 95 c7          	setne  %dil
    36d3:	01 fa                	add    %edi,%edx
    36d5:	89 90 a0 00 00 00    	mov    %edx,0xa0(%rax)
    36db:	41 f6 c6 20          	test   $0x20,%r14b
    36df:	74 24                	je     3705 <ayatsuri_model_instance_targets+0x415>
    36e1:	41 8b 12             	mov    (%r10),%edx
    36e4:	39 51 0c             	cmp    %edx,0xc(%rcx)
    36e7:	74 1c                	je     3705 <ayatsuri_model_instance_targets+0x415>
    36e9:	89 51 0c             	mov    %edx,0xc(%rcx)
    36ec:	8b 90 a0 00 00 00    	mov    0xa0(%rax),%edx
    36f2:	bf fb ff ff ff       	mov    $0xfffffffb,%edi
    36f7:	39 fa                	cmp    %edi,%edx
    36f9:	0f 47 d7             	cmova  %edi,%edx
    36fc:	83 c2 04             	add    $0x4,%edx
    36ff:	89 90 a0 00 00 00    	mov    %edx,0xa0(%rax)
    3705:	41 83 e6 40          	and    $0x40,%r14d
    3709:	74 2d                	je     3738 <ayatsuri_model_instance_targets+0x448>
    370b:	4c 89 df             	mov    %r11,%rdi
    370e:	e8 ed c8 ff ff       	call   0 <md>
    3713:	66 0f 2e 01          	ucomisd (%rcx),%xmm0
    3717:	7a 02                	jp     371b <ayatsuri_model_instance_targets+0x42b>
    3719:	74 1d                	je     3738 <ayatsuri_model_instance_targets+0x448>
    371b:	8b 90 a0 00 00 00    	mov    0xa0(%rax),%edx
    3721:	bf f7 ff ff ff       	mov    $0xfffffff7,%edi
    3726:	f2 0f 11 01          	movsd  %xmm0,(%rcx)
    372a:	39 fa                	cmp    %edi,%edx
    372c:	0f 47 d7             	cmova  %edi,%edx
    372f:	83 c2 08             	add    $0x8,%edx
    3732:	89 90 a0 00 00 00    	mov    %edx,0xa0(%rax)
    3738:	8b 90 98 00 00 00    	mov    0x98(%rax),%edx
    373e:	31 ff                	xor    %edi,%edi
    3740:	c6 44 24 08 01       	movb   $0x1,0x8(%rsp)
    3745:	83 fa ff             	cmp    $0xffffffff,%edx
    3748:	40 0f 95 c7          	setne  %dil
    374c:	01 fa                	add    %edi,%edx
    374e:	89 90 98 00 00 00    	mov    %edx,0x98(%rax)
    3754:	8b 1c 24             	mov    (%rsp),%ebx
    3757:	41 83 c5 09          	add    $0x9,%r13d
    375b:	48 83 c6 01          	add    $0x1,%rsi
    375f:	48 83 c1 18          	add    $0x18,%rcx
    3763:	49 83 c3 08          	add    $0x8,%r11
    3767:	49 83 c2 04          	add    $0x4,%r10
    376b:	41 39 dd             	cmp    %ebx,%r13d
    376e:	0f 85 c0 fe ff ff    	jne    3634 <ayatsuri_model_instance_targets+0x344>
    3774:	80 7c 24 08 00       	cmpb   $0x0,0x8(%rsp)
    3779:	74 15                	je     3790 <ayatsuri_model_instance_targets+0x4a0>
    377b:	8b 50 24             	mov    0x24(%rax),%edx
    377e:	83 fa ff             	cmp    $0xffffffff,%edx
    3781:	74 03                	je     3786 <ayatsuri_model_instance_targets+0x496>
    3783:	83 c2 01             	add    $0x1,%edx
    3786:	89 50 24             	mov    %edx,0x24(%rax)
    3789:	c6 80 a6 00 00 00 00 	movb   $0x0,0xa6(%rax)
    3790:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    3797:	31 ff                	xor    %edi,%edi
    3799:	e9 5e fc ff ff       	jmp    33fc <ayatsuri_model_instance_targets+0x10c>
    379e:	66 90                	xchg   %ax,%ax
    37a0:	4d 89 c6             	mov    %r8,%r14
    37a3:	4d 29 ce             	sub    %r9,%r14
    37a6:	49 39 ee             	cmp    %rbp,%r14
    37a9:	0f 82 41 fc ff ff    	jb     33f0 <ayatsuri_model_instance_targets+0x100>
    37af:	e9 9c fc ff ff       	jmp    3450 <ayatsuri_model_instance_targets+0x160>
    37b4:	0f 1f 40 00          	nopl   0x0(%rax)
    37b8:	41 f6 c4 60          	test   $0x60,%r12b
    37bc:	0f 84 65 fd ff ff    	je     3527 <ayatsuri_model_instance_targets+0x237>
    37c2:	e9 29 fc ff ff       	jmp    33f0 <ayatsuri_model_instance_targets+0x100>
    37c7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    37ce:	00 00 
    37d0:	4c 89 d2             	mov    %r10,%rdx
    37d3:	4c 29 ca             	sub    %r9,%rdx
    37d6:	48 39 ea             	cmp    %rbp,%rdx
    37d9:	0f 82 11 fc ff ff    	jb     33f0 <ayatsuri_model_instance_targets+0x100>
    37df:	e9 9c fc ff ff       	jmp    3480 <ayatsuri_model_instance_targets+0x190>
    37e4:	4c 89 da             	mov    %r11,%rdx
    37e7:	4c 29 ca             	sub    %r9,%rdx
    37ea:	48 39 ea             	cmp    %rbp,%rdx
    37ed:	0f 83 bd fc ff ff    	jae    34b0 <ayatsuri_model_instance_targets+0x1c0>
    37f3:	e9 f8 fb ff ff       	jmp    33f0 <ayatsuri_model_instance_targets+0x100>
    37f8:	41 f6 c6 20          	test   $0x20,%r14b
    37fc:	74 0c                	je     380a <ayatsuri_model_instance_targets+0x51a>
    37fe:	41 8b 12             	mov    (%r10),%edx
    3801:	39 51 0c             	cmp    %edx,0xc(%rcx)
    3804:	0f 85 df fe ff ff    	jne    36e9 <ayatsuri_model_instance_targets+0x3f9>
    380a:	41 83 e6 40          	and    $0x40,%r14d
    380e:	74 18                	je     3828 <ayatsuri_model_instance_targets+0x538>
    3810:	4c 89 df             	mov    %r11,%rdi
    3813:	e8 e8 c7 ff ff       	call   0 <md>
    3818:	66 0f 2e 01          	ucomisd (%rcx),%xmm0
    381c:	0f 8a f9 fe ff ff    	jp     371b <ayatsuri_model_instance_targets+0x42b>
    3822:	0f 85 f3 fe ff ff    	jne    371b <ayatsuri_model_instance_targets+0x42b>
    3828:	45 84 ff             	test   %r15b,%r15b
    382b:	0f 84 23 ff ff ff    	je     3754 <ayatsuri_model_instance_targets+0x464>
    3831:	e9 02 ff ff ff       	jmp    3738 <ayatsuri_model_instance_targets+0x448>
    3836:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    383d:	00 00 00 

0000000000003840 <ayatsuri_model_instance_node_kind>:
    3840:	48 89 f8             	mov    %rdi,%rax
    3843:	89 cf                	mov    %ecx,%edi
    3845:	b9 03 00 00 00       	mov    $0x3,%ecx
    384a:	48 85 c0             	test   %rax,%rax
    384d:	74 6d                	je     38bc <ayatsuri_model_instance_node_kind+0x7c>
    384f:	80 b8 a4 00 00 00 01 	cmpb   $0x1,0xa4(%rax)
    3856:	75 64                	jne    38bc <ayatsuri_model_instance_node_kind+0x7c>
    3858:	48 85 f6             	test   %rsi,%rsi
    385b:	74 5f                	je     38bc <ayatsuri_model_instance_node_kind+0x7c>
    385d:	48 3b 70 10          	cmp    0x10(%rax),%rsi
    3861:	75 59                	jne    38bc <ayatsuri_model_instance_node_kind+0x7c>
    3863:	3b 50 20             	cmp    0x20(%rax),%edx
    3866:	75 54                	jne    38bc <ayatsuri_model_instance_node_kind+0x7c>
    3868:	80 b8 a5 00 00 00 00 	cmpb   $0x0,0xa5(%rax)
    386f:	b9 04 00 00 00       	mov    $0x4,%ecx
    3874:	75 46                	jne    38bc <ayatsuri_model_instance_node_kind+0x7c>
    3876:	c6 80 a5 00 00 00 01 	movb   $0x1,0xa5(%rax)
    387d:	4d 85 c0             	test   %r8,%r8
    3880:	74 2e                	je     38b0 <ayatsuri_model_instance_node_kind+0x70>
    3882:	48 8b 10             	mov    (%rax),%rdx
    3885:	66 3b 7a 0c          	cmp    0xc(%rdx),%di
    3889:	73 25                	jae    38b0 <ayatsuri_model_instance_node_kind+0x70>
    388b:	4c 39 c0             	cmp    %r8,%rax
    388e:	73 30                	jae    38c0 <ayatsuri_model_instance_node_kind+0x80>
    3890:	4c 89 c1             	mov    %r8,%rcx
    3893:	48 29 c1             	sub    %rax,%rcx
    3896:	48 81 f9 a7 00 00 00 	cmp    $0xa7,%rcx
    389d:	76 11                	jbe    38b0 <ayatsuri_model_instance_node_kind+0x70>
    389f:	4c 39 c2             	cmp    %r8,%rdx
    38a2:	72 24                	jb     38c8 <ayatsuri_model_instance_node_kind+0x88>
    38a4:	49 39 d0             	cmp    %rdx,%r8
    38a7:	75 2b                	jne    38d4 <ayatsuri_model_instance_node_kind+0x94>
    38a9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    38b0:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    38b7:	b9 01 00 00 00       	mov    $0x1,%ecx
    38bc:	89 c8                	mov    %ecx,%eax
    38be:	c3                   	ret
    38bf:	90                   	nop
    38c0:	74 ee                	je     38b0 <ayatsuri_model_instance_node_kind+0x70>
    38c2:	eb db                	jmp    389f <ayatsuri_model_instance_node_kind+0x5f>
    38c4:	0f 1f 40 00          	nopl   0x0(%rax)
    38c8:	4c 89 c1             	mov    %r8,%rcx
    38cb:	48 29 d1             	sub    %rdx,%rcx
    38ce:	48 83 f9 7f          	cmp    $0x7f,%rcx
    38d2:	76 dc                	jbe    38b0 <ayatsuri_model_instance_node_kind+0x70>
    38d4:	48 8b 48 18          	mov    0x18(%rax),%rcx
    38d8:	48 85 c9             	test   %rcx,%rcx
    38db:	74 13                	je     38f0 <ayatsuri_model_instance_node_kind+0xb0>
    38dd:	48 8b 70 08          	mov    0x8(%rax),%rsi
    38e1:	4c 39 c6             	cmp    %r8,%rsi
    38e4:	72 5a                	jb     3940 <ayatsuri_model_instance_node_kind+0x100>
    38e6:	49 39 f0             	cmp    %rsi,%r8
    38e9:	74 c5                	je     38b0 <ayatsuri_model_instance_node_kind+0x70>
    38eb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    38f0:	8b 4a 08             	mov    0x8(%rdx),%ecx
    38f3:	48 8b 32             	mov    (%rdx),%rsi
    38f6:	48 85 c9             	test   %rcx,%rcx
    38f9:	74 15                	je     3910 <ayatsuri_model_instance_node_kind+0xd0>
    38fb:	4c 39 c6             	cmp    %r8,%rsi
    38fe:	72 58                	jb     3958 <ayatsuri_model_instance_node_kind+0x118>
    3900:	49 39 f0             	cmp    %rsi,%r8
    3903:	74 ab                	je     38b0 <ayatsuri_model_instance_node_kind+0x70>
    3905:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    390c:	00 00 00 00 
    3910:	8b 52 14             	mov    0x14(%rdx),%edx
    3913:	48 89 f9             	mov    %rdi,%rcx
    3916:	48 c1 e1 04          	shl    $0x4,%rcx
    391a:	81 e1 f0 ff 0f 00    	and    $0xffff0,%ecx
    3920:	48 01 d6             	add    %rdx,%rsi
    3923:	0f b6 54 31 02       	movzbl 0x2(%rcx,%rsi,1),%edx
    3928:	31 c9                	xor    %ecx,%ecx
    392a:	41 88 10             	mov    %dl,(%r8)
    392d:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    3934:	eb 86                	jmp    38bc <ayatsuri_model_instance_node_kind+0x7c>
    3936:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    393d:	00 00 00 
    3940:	4d 89 c1             	mov    %r8,%r9
    3943:	49 29 f1             	sub    %rsi,%r9
    3946:	49 39 c9             	cmp    %rcx,%r9
    3949:	0f 82 61 ff ff ff    	jb     38b0 <ayatsuri_model_instance_node_kind+0x70>
    394f:	eb 9f                	jmp    38f0 <ayatsuri_model_instance_node_kind+0xb0>
    3951:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3958:	4d 89 c1             	mov    %r8,%r9
    395b:	49 29 f1             	sub    %rsi,%r9
    395e:	49 39 c9             	cmp    %rcx,%r9
    3961:	73 ad                	jae    3910 <ayatsuri_model_instance_node_kind+0xd0>
    3963:	e9 48 ff ff ff       	jmp    38b0 <ayatsuri_model_instance_node_kind+0x70>
    3968:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    396f:	00 

0000000000003970 <ayatsuri_model_instance_read_pose>:
    3970:	48 89 f8             	mov    %rdi,%rax
    3973:	89 cf                	mov    %ecx,%edi
    3975:	b9 03 00 00 00       	mov    $0x3,%ecx
    397a:	48 85 c0             	test   %rax,%rax
    397d:	74 6d                	je     39ec <ayatsuri_model_instance_read_pose+0x7c>
    397f:	80 b8 a4 00 00 00 01 	cmpb   $0x1,0xa4(%rax)
    3986:	75 64                	jne    39ec <ayatsuri_model_instance_read_pose+0x7c>
    3988:	48 85 f6             	test   %rsi,%rsi
    398b:	74 5f                	je     39ec <ayatsuri_model_instance_read_pose+0x7c>
    398d:	48 3b 70 10          	cmp    0x10(%rax),%rsi
    3991:	75 59                	jne    39ec <ayatsuri_model_instance_read_pose+0x7c>
    3993:	3b 50 20             	cmp    0x20(%rax),%edx
    3996:	75 54                	jne    39ec <ayatsuri_model_instance_read_pose+0x7c>
    3998:	80 b8 a5 00 00 00 00 	cmpb   $0x0,0xa5(%rax)
    399f:	b9 04 00 00 00       	mov    $0x4,%ecx
    39a4:	75 46                	jne    39ec <ayatsuri_model_instance_read_pose+0x7c>
    39a6:	c6 80 a5 00 00 00 01 	movb   $0x1,0xa5(%rax)
    39ad:	4d 85 c0             	test   %r8,%r8
    39b0:	74 2e                	je     39e0 <ayatsuri_model_instance_read_pose+0x70>
    39b2:	48 8b 10             	mov    (%rax),%rdx
    39b5:	66 3b 7a 0c          	cmp    0xc(%rdx),%di
    39b9:	73 25                	jae    39e0 <ayatsuri_model_instance_read_pose+0x70>
    39bb:	4c 39 c0             	cmp    %r8,%rax
    39be:	73 30                	jae    39f0 <ayatsuri_model_instance_read_pose+0x80>
    39c0:	4c 89 c1             	mov    %r8,%rcx
    39c3:	48 29 c1             	sub    %rax,%rcx
    39c6:	48 81 f9 a7 00 00 00 	cmp    $0xa7,%rcx
    39cd:	76 11                	jbe    39e0 <ayatsuri_model_instance_read_pose+0x70>
    39cf:	4c 39 c2             	cmp    %r8,%rdx
    39d2:	72 2c                	jb     3a00 <ayatsuri_model_instance_read_pose+0x90>
    39d4:	48 89 d1             	mov    %rdx,%rcx
    39d7:	4c 29 c1             	sub    %r8,%rcx
    39da:	48 83 f9 23          	cmp    $0x23,%rcx
    39de:	77 2c                	ja     3a0c <ayatsuri_model_instance_read_pose+0x9c>
    39e0:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    39e7:	b9 01 00 00 00       	mov    $0x1,%ecx
    39ec:	89 c8                	mov    %ecx,%eax
    39ee:	c3                   	ret
    39ef:	90                   	nop
    39f0:	48 89 c1             	mov    %rax,%rcx
    39f3:	4c 29 c1             	sub    %r8,%rcx
    39f6:	48 83 f9 23          	cmp    $0x23,%rcx
    39fa:	76 e4                	jbe    39e0 <ayatsuri_model_instance_read_pose+0x70>
    39fc:	eb d1                	jmp    39cf <ayatsuri_model_instance_read_pose+0x5f>
    39fe:	66 90                	xchg   %ax,%ax
    3a00:	4c 89 c1             	mov    %r8,%rcx
    3a03:	48 29 d1             	sub    %rdx,%rcx
    3a06:	48 83 f9 7f          	cmp    $0x7f,%rcx
    3a0a:	76 d4                	jbe    39e0 <ayatsuri_model_instance_read_pose+0x70>
    3a0c:	48 8b 48 18          	mov    0x18(%rax),%rcx
    3a10:	48 8b 70 08          	mov    0x8(%rax),%rsi
    3a14:	48 85 c9             	test   %rcx,%rcx
    3a17:	74 17                	je     3a30 <ayatsuri_model_instance_read_pose+0xc0>
    3a19:	4c 39 c6             	cmp    %r8,%rsi
    3a1c:	72 72                	jb     3a90 <ayatsuri_model_instance_read_pose+0x120>
    3a1e:	48 89 f1             	mov    %rsi,%rcx
    3a21:	4c 29 c1             	sub    %r8,%rcx
    3a24:	48 83 f9 23          	cmp    $0x23,%rcx
    3a28:	76 b6                	jbe    39e0 <ayatsuri_model_instance_read_pose+0x70>
    3a2a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3a30:	8b 4a 08             	mov    0x8(%rdx),%ecx
    3a33:	48 85 c9             	test   %rcx,%rcx
    3a36:	74 18                	je     3a50 <ayatsuri_model_instance_read_pose+0xe0>
    3a38:	48 8b 12             	mov    (%rdx),%rdx
    3a3b:	4c 39 c2             	cmp    %r8,%rdx
    3a3e:	72 68                	jb     3aa8 <ayatsuri_model_instance_read_pose+0x138>
    3a40:	4c 29 c2             	sub    %r8,%rdx
    3a43:	48 83 fa 23          	cmp    $0x23,%rdx
    3a47:	76 97                	jbe    39e0 <ayatsuri_model_instance_read_pose+0x70>
    3a49:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3a50:	0f b7 cf             	movzwl %di,%ecx
    3a53:	48 8d 14 49          	lea    (%rcx,%rcx,2),%rdx
    3a57:	31 c9                	xor    %ecx,%ecx
    3a59:	8b 54 d6 08          	mov    0x8(%rsi,%rdx,8),%edx
    3a5d:	48 8d 54 16 30       	lea    0x30(%rsi,%rdx,1),%rdx
    3a62:	f3 0f 6f 02          	movdqu (%rdx),%xmm0
    3a66:	41 0f 11 00          	movups %xmm0,(%r8)
    3a6a:	f3 0f 6f 42 10       	movdqu 0x10(%rdx),%xmm0
    3a6f:	41 0f 11 40 10       	movups %xmm0,0x10(%r8)
    3a74:	8b 52 20             	mov    0x20(%rdx),%edx
    3a77:	41 89 50 20          	mov    %edx,0x20(%r8)
    3a7b:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    3a82:	e9 65 ff ff ff       	jmp    39ec <ayatsuri_model_instance_read_pose+0x7c>
    3a87:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    3a8e:	00 00 
    3a90:	4d 89 c1             	mov    %r8,%r9
    3a93:	49 29 f1             	sub    %rsi,%r9
    3a96:	49 39 c9             	cmp    %rcx,%r9
    3a99:	0f 82 41 ff ff ff    	jb     39e0 <ayatsuri_model_instance_read_pose+0x70>
    3a9f:	eb 8f                	jmp    3a30 <ayatsuri_model_instance_read_pose+0xc0>
    3aa1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3aa8:	4d 89 c1             	mov    %r8,%r9
    3aab:	49 29 d1             	sub    %rdx,%r9
    3aae:	49 39 c9             	cmp    %rcx,%r9
    3ab1:	73 9d                	jae    3a50 <ayatsuri_model_instance_read_pose+0xe0>
    3ab3:	e9 28 ff ff ff       	jmp    39e0 <ayatsuri_model_instance_read_pose+0x70>
    3ab8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    3abf:	00 

0000000000003ac0 <ayatsuri_model_instance_stats>:
    3ac0:	48 89 f8             	mov    %rdi,%rax
    3ac3:	bf 03 00 00 00       	mov    $0x3,%edi
    3ac8:	48 85 c0             	test   %rax,%rax
    3acb:	74 46                	je     3b13 <ayatsuri_model_instance_stats+0x53>
    3acd:	80 b8 a4 00 00 00 01 	cmpb   $0x1,0xa4(%rax)
    3ad4:	75 3d                	jne    3b13 <ayatsuri_model_instance_stats+0x53>
    3ad6:	48 85 f6             	test   %rsi,%rsi
    3ad9:	74 38                	je     3b13 <ayatsuri_model_instance_stats+0x53>
    3adb:	48 3b 70 10          	cmp    0x10(%rax),%rsi
    3adf:	75 32                	jne    3b13 <ayatsuri_model_instance_stats+0x53>
    3ae1:	3b 50 20             	cmp    0x20(%rax),%edx
    3ae4:	75 2d                	jne    3b13 <ayatsuri_model_instance_stats+0x53>
    3ae6:	80 b8 a5 00 00 00 00 	cmpb   $0x0,0xa5(%rax)
    3aed:	bf 04 00 00 00       	mov    $0x4,%edi
    3af2:	75 1f                	jne    3b13 <ayatsuri_model_instance_stats+0x53>
    3af4:	48 85 c9             	test   %rcx,%rcx
    3af7:	0f 84 fb 00 00 00    	je     3bf8 <ayatsuri_model_instance_stats+0x138>
    3afd:	48 39 c8             	cmp    %rcx,%rax
    3b00:	72 1e                	jb     3b20 <ayatsuri_model_instance_stats+0x60>
    3b02:	48 89 c2             	mov    %rax,%rdx
    3b05:	bf 01 00 00 00       	mov    $0x1,%edi
    3b0a:	48 29 ca             	sub    %rcx,%rdx
    3b0d:	48 83 fa 1b          	cmp    $0x1b,%rdx
    3b11:	77 21                	ja     3b34 <ayatsuri_model_instance_stats+0x74>
    3b13:	89 f8                	mov    %edi,%eax
    3b15:	c3                   	ret
    3b16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    3b1d:	00 00 00 
    3b20:	48 89 ca             	mov    %rcx,%rdx
    3b23:	bf 01 00 00 00       	mov    $0x1,%edi
    3b28:	48 29 c2             	sub    %rax,%rdx
    3b2b:	48 81 fa a7 00 00 00 	cmp    $0xa7,%rdx
    3b32:	76 df                	jbe    3b13 <ayatsuri_model_instance_stats+0x53>
    3b34:	48 8b 10             	mov    (%rax),%rdx
    3b37:	48 39 ca             	cmp    %rcx,%rdx
    3b3a:	0f 83 98 00 00 00    	jae    3bd8 <ayatsuri_model_instance_stats+0x118>
    3b40:	48 89 ce             	mov    %rcx,%rsi
    3b43:	bf 01 00 00 00       	mov    $0x1,%edi
    3b48:	48 29 d6             	sub    %rdx,%rsi
    3b4b:	48 83 fe 7f          	cmp    $0x7f,%rsi
    3b4f:	76 c2                	jbe    3b13 <ayatsuri_model_instance_stats+0x53>
    3b51:	48 8b 70 18          	mov    0x18(%rax),%rsi
    3b55:	48 85 f6             	test   %rsi,%rsi
    3b58:	74 26                	je     3b80 <ayatsuri_model_instance_stats+0xc0>
    3b5a:	48 8b 78 08          	mov    0x8(%rax),%rdi
    3b5e:	48 39 cf             	cmp    %rcx,%rdi
    3b61:	0f 82 99 00 00 00    	jb     3c00 <ayatsuri_model_instance_stats+0x140>
    3b67:	48 29 cf             	sub    %rcx,%rdi
    3b6a:	48 89 fe             	mov    %rdi,%rsi
    3b6d:	bf 01 00 00 00       	mov    $0x1,%edi
    3b72:	48 83 fe 1b          	cmp    $0x1b,%rsi
    3b76:	76 9b                	jbe    3b13 <ayatsuri_model_instance_stats+0x53>
    3b78:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    3b7f:	00 
    3b80:	8b 72 08             	mov    0x8(%rdx),%esi
    3b83:	48 85 f6             	test   %rsi,%rsi
    3b86:	74 28                	je     3bb0 <ayatsuri_model_instance_stats+0xf0>
    3b88:	48 8b 12             	mov    (%rdx),%rdx
    3b8b:	48 39 ca             	cmp    %rcx,%rdx
    3b8e:	0f 82 8c 00 00 00    	jb     3c20 <ayatsuri_model_instance_stats+0x160>
    3b94:	48 29 ca             	sub    %rcx,%rdx
    3b97:	bf 01 00 00 00       	mov    $0x1,%edi
    3b9c:	48 83 fa 1b          	cmp    $0x1b,%rdx
    3ba0:	0f 86 6d ff ff ff    	jbe    3b13 <ayatsuri_model_instance_stats+0x53>
    3ba6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    3bad:	00 00 00 
    3bb0:	f3 0f 6f 80 88 00 00 	movdqu 0x88(%rax),%xmm0
    3bb7:	00 
    3bb8:	31 ff                	xor    %edi,%edi
    3bba:	0f 11 01             	movups %xmm0,(%rcx)
    3bbd:	f3 0f 6f 80 94 00 00 	movdqu 0x94(%rax),%xmm0
    3bc4:	00 
    3bc5:	0f 11 41 0c          	movups %xmm0,0xc(%rcx)
    3bc9:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    3bd0:	e9 3e ff ff ff       	jmp    3b13 <ayatsuri_model_instance_stats+0x53>
    3bd5:	0f 1f 00             	nopl   (%rax)
    3bd8:	48 89 d6             	mov    %rdx,%rsi
    3bdb:	bf 01 00 00 00       	mov    $0x1,%edi
    3be0:	48 29 ce             	sub    %rcx,%rsi
    3be3:	48 83 fe 1b          	cmp    $0x1b,%rsi
    3be7:	0f 86 26 ff ff ff    	jbe    3b13 <ayatsuri_model_instance_stats+0x53>
    3bed:	e9 5f ff ff ff       	jmp    3b51 <ayatsuri_model_instance_stats+0x91>
    3bf2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3bf8:	bf 01 00 00 00       	mov    $0x1,%edi
    3bfd:	89 f8                	mov    %edi,%eax
    3bff:	c3                   	ret
    3c00:	49 89 c8             	mov    %rcx,%r8
    3c03:	49 29 f8             	sub    %rdi,%r8
    3c06:	bf 01 00 00 00       	mov    $0x1,%edi
    3c0b:	49 39 f0             	cmp    %rsi,%r8
    3c0e:	0f 82 ff fe ff ff    	jb     3b13 <ayatsuri_model_instance_stats+0x53>
    3c14:	e9 67 ff ff ff       	jmp    3b80 <ayatsuri_model_instance_stats+0xc0>
    3c19:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3c20:	49 89 c8             	mov    %rcx,%r8
    3c23:	bf 01 00 00 00       	mov    $0x1,%edi
    3c28:	49 29 d0             	sub    %rdx,%r8
    3c2b:	49 39 f0             	cmp    %rsi,%r8
    3c2e:	0f 82 df fe ff ff    	jb     3b13 <ayatsuri_model_instance_stats+0x53>
    3c34:	e9 77 ff ff ff       	jmp    3bb0 <ayatsuri_model_instance_stats+0xf0>
    3c39:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000003c40 <ayatsuri_model_instance_evaluate>:
    3c40:	48 85 ff             	test   %rdi,%rdi
    3c43:	0f 84 7f 01 00 00    	je     3dc8 <ayatsuri_model_instance_evaluate+0x188>
    3c49:	41 57                	push   %r15
    3c4b:	b8 03 00 00 00       	mov    $0x3,%eax
    3c50:	49 89 ff             	mov    %rdi,%r15
    3c53:	41 56                	push   %r14
    3c55:	41 55                	push   %r13
    3c57:	41 54                	push   %r12
    3c59:	55                   	push   %rbp
    3c5a:	53                   	push   %rbx
    3c5b:	48 81 ec 48 04 00 00 	sub    $0x448,%rsp
    3c62:	80 bf a4 00 00 00 01 	cmpb   $0x1,0xa4(%rdi)
    3c69:	0f 85 20 01 00 00    	jne    3d8f <ayatsuri_model_instance_evaluate+0x14f>
    3c6f:	48 85 f6             	test   %rsi,%rsi
    3c72:	0f 84 17 01 00 00    	je     3d8f <ayatsuri_model_instance_evaluate+0x14f>
    3c78:	48 3b 77 10          	cmp    0x10(%rdi),%rsi
    3c7c:	0f 85 0d 01 00 00    	jne    3d8f <ayatsuri_model_instance_evaluate+0x14f>
    3c82:	3b 57 20             	cmp    0x20(%rdi),%edx
    3c85:	0f 85 04 01 00 00    	jne    3d8f <ayatsuri_model_instance_evaluate+0x14f>
    3c8b:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    3c92:	b8 04 00 00 00       	mov    $0x4,%eax
    3c97:	0f 85 f2 00 00 00    	jne    3d8f <ayatsuri_model_instance_evaluate+0x14f>
    3c9d:	8b 87 88 00 00 00    	mov    0x88(%rdi),%eax
    3ca3:	31 d2                	xor    %edx,%edx
    3ca5:	c6 87 a5 00 00 00 01 	movb   $0x1,0xa5(%rdi)
    3cac:	83 f8 ff             	cmp    $0xffffffff,%eax
    3caf:	0f 95 c2             	setne  %dl
    3cb2:	01 d0                	add    %edx,%eax
    3cb4:	89 87 88 00 00 00    	mov    %eax,0x88(%rdi)
    3cba:	48 85 c9             	test   %rcx,%rcx
    3cbd:	0f 84 bd 00 00 00    	je     3d80 <ayatsuri_model_instance_evaluate+0x140>
    3cc3:	4d 85 c0             	test   %r8,%r8
    3cc6:	0f 84 b4 00 00 00    	je     3d80 <ayatsuri_model_instance_evaluate+0x140>
    3ccc:	44 0f b6 8f a6 00 00 	movzbl 0xa6(%rdi),%r9d
    3cd3:	00 
    3cd4:	31 c0                	xor    %eax,%eax
    3cd6:	31 ff                	xor    %edi,%edi
    3cd8:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 3ce1 <ayatsuri_model_instance_evaluate+0xa1>
    3cdf:	00 00 
			3cdd: R_X86_64_PC32	.LC1-0x4
    3ce1:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 3cea <ayatsuri_model_instance_evaluate+0xaa>
    3ce8:	00 00 
			3ce6: R_X86_64_PC32	.LC0-0x4
    3cea:	44 89 ce             	mov    %r9d,%esi
    3ced:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    3cf4:	00 00 00 00 
    3cf8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    3cff:	00 
    3d00:	f3 0f 10 04 01       	movss  (%rcx,%rax,1),%xmm0
    3d05:	0f 28 c8             	movaps %xmm0,%xmm1
    3d08:	41 0f 54 ca          	andps  %xmm10,%xmm1
    3d0c:	44 0f 2e f1          	ucomiss %xmm1,%xmm14
    3d10:	72 6e                	jb     3d80 <ayatsuri_model_instance_evaluate+0x140>
    3d12:	41 0f 2e 44 07 28    	ucomiss 0x28(%r15,%rax,1),%xmm0
    3d18:	0f 9b c2             	setnp  %dl
    3d1b:	0f 45 d7             	cmovne %edi,%edx
    3d1e:	48 83 c0 04          	add    $0x4,%rax
    3d22:	21 d6                	and    %edx,%esi
    3d24:	48 83 f8 24          	cmp    $0x24,%rax
    3d28:	75 d6                	jne    3d00 <ayatsuri_model_instance_evaluate+0xc0>
    3d2a:	31 c0                	xor    %eax,%eax
    3d2c:	f3 41 0f 10 0c 80    	movss  (%r8,%rax,4),%xmm1
    3d32:	0f 28 c1             	movaps %xmm1,%xmm0
    3d35:	41 0f 54 c2          	andps  %xmm10,%xmm0
    3d39:	44 0f 2e f0          	ucomiss %xmm0,%xmm14
    3d3d:	72 41                	jb     3d80 <ayatsuri_model_instance_evaluate+0x140>
    3d3f:	48 83 f8 02          	cmp    $0x2,%rax
    3d43:	76 63                	jbe    3da8 <ayatsuri_model_instance_evaluate+0x168>
    3d45:	66 0f ef c0          	pxor   %xmm0,%xmm0
    3d49:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 3d51 <ayatsuri_model_instance_evaluate+0x111>
    3d50:	00 
			3d4d: R_X86_64_PC32	.LC22-0x4
    3d51:	f3 0f 5a c1          	cvtss2sd %xmm1,%xmm0
    3d55:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 3d5d <ayatsuri_model_instance_evaluate+0x11d>
    3d5c:	00 
			3d59: R_X86_64_PC32	.LC8-0x4
    3d5d:	66 0f 2e f8          	ucomisd %xmm0,%xmm7
    3d61:	72 1d                	jb     3d80 <ayatsuri_model_instance_evaluate+0x140>
    3d63:	66 0f ef c0          	pxor   %xmm0,%xmm0
    3d67:	0f 2f c8             	comiss %xmm0,%xmm1
    3d6a:	72 14                	jb     3d80 <ayatsuri_model_instance_evaluate+0x140>
    3d6c:	f3 0f 10 3d 00 00 00 	movss  0x0(%rip),%xmm7        # 3d74 <ayatsuri_model_instance_evaluate+0x134>
    3d73:	00 
			3d70: R_X86_64_PC32	.LC15-0x4
    3d74:	0f 2f f9             	comiss %xmm1,%xmm7
    3d77:	73 57                	jae    3dd0 <ayatsuri_model_instance_evaluate+0x190>
    3d79:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3d80:	31 d2                	xor    %edx,%edx
    3d82:	66 41 89 97 a5 00 00 	mov    %dx,0xa5(%r15)
    3d89:	00 
    3d8a:	b8 01 00 00 00       	mov    $0x1,%eax
    3d8f:	48 81 c4 48 04 00 00 	add    $0x448,%rsp
    3d96:	5b                   	pop    %rbx
    3d97:	5d                   	pop    %rbp
    3d98:	41 5c                	pop    %r12
    3d9a:	41 5d                	pop    %r13
    3d9c:	41 5e                	pop    %r14
    3d9e:	41 5f                	pop    %r15
    3da0:	c3                   	ret
    3da1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3da8:	41 0f 2e 4c 87 4c    	ucomiss 0x4c(%r15,%rax,4),%xmm1
    3dae:	bf 00 00 00 00       	mov    $0x0,%edi
    3db3:	0f 9b c2             	setnp  %dl
    3db6:	0f 45 d7             	cmovne %edi,%edx
    3db9:	48 83 c0 01          	add    $0x1,%rax
    3dbd:	21 d6                	and    %edx,%esi
    3dbf:	e9 68 ff ff ff       	jmp    3d2c <ayatsuri_model_instance_evaluate+0xec>
    3dc4:	0f 1f 40 00          	nopl   0x0(%rax)
    3dc8:	b8 03 00 00 00       	mov    $0x3,%eax
    3dcd:	c3                   	ret
    3dce:	66 90                	xchg   %ax,%ax
    3dd0:	41 0f 2e 4c 87 4c    	ucomiss 0x4c(%r15,%rax,4),%xmm1
    3dd6:	bf 00 00 00 00       	mov    $0x0,%edi
    3ddb:	0f 9b c2             	setnp  %dl
    3dde:	0f 45 d7             	cmovne %edi,%edx
    3de1:	48 83 c0 01          	add    $0x1,%rax
    3de5:	21 d6                	and    %edx,%esi
    3de7:	48 83 f8 06          	cmp    $0x6,%rax
    3deb:	0f 85 3b ff ff ff    	jne    3d2c <ayatsuri_model_instance_evaluate+0xec>
    3df1:	f3 0f 10 49 18       	movss  0x18(%rcx),%xmm1
    3df6:	0f 2f c8             	comiss %xmm0,%xmm1
    3df9:	76 85                	jbe    3d80 <ayatsuri_model_instance_evaluate+0x140>
    3dfb:	40 84 f6             	test   %sil,%sil
    3dfe:	0f 85 c2 1a 00 00    	jne    58c6 <ayatsuri_model_instance_evaluate+0x1c86>
    3e04:	49 8d 77 28          	lea    0x28(%r15),%rsi
    3e08:	45 84 c9             	test   %r9b,%r9b
    3e0b:	74 18                	je     3e25 <ayatsuri_model_instance_evaluate+0x1e5>
    3e0d:	48 8b 01             	mov    (%rcx),%rax
    3e10:	48 8b 51 08          	mov    0x8(%rcx),%rdx
    3e14:	49 33 47 28          	xor    0x28(%r15),%rax
    3e18:	49 33 57 30          	xor    0x30(%r15),%rdx
    3e1c:	48 09 d0             	or     %rdx,%rax
    3e1f:	0f 84 1b 1e 00 00    	je     5c40 <ayatsuri_model_instance_evaluate+0x2000>
    3e25:	41 c6 87 a6 00 00 00 	movb   $0x0,0xa6(%r15)
    3e2c:	00 
    3e2d:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
    3e31:	66 0f ef c9          	pxor   %xmm1,%xmm1
    3e35:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
    3e3a:	41 0f 11 47 28       	movups %xmm0,0x28(%r15)
    3e3f:	f3 0f 6f 41 10       	movdqu 0x10(%rcx),%xmm0
    3e44:	0f 11 46 10          	movups %xmm0,0x10(%rsi)
    3e48:	8b 41 20             	mov    0x20(%rcx),%eax
    3e4b:	89 46 20             	mov    %eax,0x20(%rsi)
    3e4e:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
    3e53:	41 0f 11 47 4c       	movups %xmm0,0x4c(%r15)
    3e58:	49 8b 40 10          	mov    0x10(%r8),%rax
    3e5c:	49 89 47 5c          	mov    %rax,0x5c(%r15)
    3e60:	0f 5a 41 0c          	cvtps2pd 0xc(%rcx),%xmm0
    3e64:	0f 5a 11             	cvtps2pd (%rcx),%xmm2
    3e67:	66 0f 5c d0          	subpd  %xmm0,%xmm2
    3e6b:	66 0f ef c0          	pxor   %xmm0,%xmm0
    3e6f:	f3 0f 5a 41 14       	cvtss2sd 0x14(%rcx),%xmm0
    3e74:	f3 0f 5a 49 08       	cvtss2sd 0x8(%rcx),%xmm1
    3e79:	f2 0f 5c c8          	subsd  %xmm0,%xmm1
    3e7d:	66 0f 28 fa          	movapd %xmm2,%xmm7
    3e81:	66 0f 15 ff          	unpckhpd %xmm7,%xmm7
    3e85:	66 0f 28 c2          	movapd %xmm2,%xmm0
    3e89:	0f 29 14 24          	movaps %xmm2,(%rsp)
    3e8d:	66 48 0f 7e cb       	movq   %xmm1,%rbx
    3e92:	66 0f 28 cf          	movapd %xmm7,%xmm1
    3e96:	e8 00 00 00 00       	call   3e9b <ayatsuri_model_instance_evaluate+0x25b>
			3e97: R_X86_64_PLT32	hypot-0x4
    3e9b:	66 48 0f 6e cb       	movq   %rbx,%xmm1
    3ea0:	e8 00 00 00 00       	call   3ea5 <ayatsuri_model_instance_evaluate+0x265>
			3ea1: R_X86_64_PLT32	hypot-0x4
    3ea5:	66 0f ef c9          	pxor   %xmm1,%xmm1
    3ea9:	66 0f 28 14 24       	movapd (%rsp),%xmm2
    3eae:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
    3eb3:	66 0f 2f c1          	comisd %xmm1,%xmm0
    3eb7:	0f 86 fc 19 00 00    	jbe    58b9 <ayatsuri_model_instance_evaluate+0x1c79>
    3ebd:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 3ec5 <ayatsuri_model_instance_evaluate+0x285>
    3ec4:	00 
			3ec1: R_X86_64_PC32	.LC22-0x4
    3ec5:	66 0f 2e f0          	ucomisd %xmm0,%xmm6
    3ec9:	0f 82 ea 19 00 00    	jb     58b9 <ayatsuri_model_instance_evaluate+0x1c79>
    3ecf:	66 0f 28 c8          	movapd %xmm0,%xmm1
    3ed3:	66 48 0f 6e db       	movq   %rbx,%xmm3
    3ed8:	4c 89 44 24 38       	mov    %r8,0x38(%rsp)
    3edd:	f2 0f 5e d8          	divsd  %xmm0,%xmm3
    3ee1:	66 0f 14 c9          	unpcklpd %xmm1,%xmm1
    3ee5:	66 0f 5e d1          	divpd  %xmm1,%xmm2
    3ee9:	66 0f 28 c3          	movapd %xmm3,%xmm0
    3eed:	f2 0f 11 1c 24       	movsd  %xmm3,(%rsp)
    3ef2:	66 0f 28 ea          	movapd %xmm2,%xmm5
    3ef6:	66 0f 28 ca          	movapd %xmm2,%xmm1
    3efa:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
    3eff:	66 0f 15 ed          	unpckhpd %xmm5,%xmm5
    3f03:	f2 0f 11 54 24 18    	movsd  %xmm2,0x18(%rsp)
    3f09:	f2 0f 11 6c 24 30    	movsd  %xmm5,0x30(%rsp)
    3f0f:	e8 00 00 00 00       	call   3f14 <ayatsuri_model_instance_evaluate+0x2d4>
			3f10: R_X86_64_PLT32	hypot-0x4
    3f14:	f2 0f 10 1c 24       	movsd  (%rsp),%xmm3
    3f19:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
    3f1e:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 3f27 <ayatsuri_model_instance_evaluate+0x2e7>
    3f25:	00 00 
			3f23: R_X86_64_PC32	.LC0-0x4
    3f27:	f2 0f 10 15 00 00 00 	movsd  0x0(%rip),%xmm2        # 3f2f <ayatsuri_model_instance_evaluate+0x2ef>
    3f2e:	00 
			3f2b: R_X86_64_PC32	.LC37-0x4
    3f2f:	f2 0f 10 4c 24 18    	movsd  0x18(%rsp),%xmm1
    3f35:	66 0f 28 64 24 20    	movapd 0x20(%rsp),%xmm4
    3f3b:	f2 0f 10 6c 24 30    	movsd  0x30(%rsp),%xmm5
    3f41:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 3f4a <ayatsuri_model_instance_evaluate+0x30a>
    3f48:	00 00 
			3f46: R_X86_64_PC32	.LC1-0x4
    3f4a:	66 0f 2f d0          	comisd %xmm0,%xmm2
    3f4e:	0f 87 3b 1e 00 00    	ja     5d8f <ayatsuri_model_instance_evaluate+0x214f>
    3f54:	66 0f 28 f3          	movapd %xmm3,%xmm6
    3f58:	f3 0f 7e 3d 00 00 00 	movq   0x0(%rip),%xmm7        # 3f60 <ayatsuri_model_instance_evaluate+0x320>
    3f5f:	00 
			3f5c: R_X86_64_PC32	.LC26-0x4
    3f60:	66 44 0f 28 c3       	movapd %xmm3,%xmm8
    3f65:	66 0f ef d2          	pxor   %xmm2,%xmm2
    3f69:	f2 0f 5e f0          	divsd  %xmm0,%xmm6
    3f6d:	0f 29 bc 24 80 00 00 	movaps %xmm7,0x80(%rsp)
    3f74:	00 
    3f75:	66 0f 57 f9          	xorpd  %xmm1,%xmm7
    3f79:	f2 0f 5e f8          	divsd  %xmm0,%xmm7
    3f7d:	66 0f ef c0          	pxor   %xmm0,%xmm0
    3f81:	f2 44 0f 59 c6       	mulsd  %xmm6,%xmm8
    3f86:	f2 0f 5a d6          	cvtsd2ss %xmm6,%xmm2
    3f8a:	f2 0f 5a c7          	cvtsd2ss %xmm7,%xmm0
    3f8e:	f2 0f 59 cf          	mulsd  %xmm7,%xmm1
    3f92:	66 0f 5a e4          	cvtpd2ps %xmm4,%xmm4
    3f96:	49 8b 07             	mov    (%r15),%rax
    3f99:	f2 0f 5a db          	cvtsd2ss %xmm3,%xmm3
    3f9d:	f3 0f 11 84 24 ec 01 	movss  %xmm0,0x1ec(%rsp)
    3fa4:	00 00 
    3fa6:	66 0f 28 c5          	movapd %xmm5,%xmm0
    3faa:	66 0f 57 ac 24 80 00 	xorpd  0x80(%rsp),%xmm5
    3fb1:	00 00 
    3fb3:	f2 0f 59 c7          	mulsd  %xmm7,%xmm0
    3fb7:	66 83 78 0c 00       	cmpw   $0x0,0xc(%rax)
    3fbc:	0f 13 a4 24 c8 01 00 	movlps %xmm4,0x1c8(%rsp)
    3fc3:	00 
    3fc4:	c7 84 24 e8 01 00 00 	movl   $0x0,0x1e8(%rsp)
    3fcb:	00 00 00 00 
    3fcf:	f3 0f 11 9c 24 d0 01 	movss  %xmm3,0x1d0(%rsp)
    3fd6:	00 00 
    3fd8:	f3 0f 11 94 24 e4 01 	movss  %xmm2,0x1e4(%rsp)
    3fdf:	00 00 
    3fe1:	f2 44 0f 5c c1       	subsd  %xmm1,%xmm8
    3fe6:	66 41 0f 14 c0       	unpcklpd %xmm8,%xmm0
    3feb:	66 0f 5a c0          	cvtpd2ps %xmm0,%xmm0
    3fef:	0f 13 84 24 d8 01 00 	movlps %xmm0,0x1d8(%rsp)
    3ff6:	00 
    3ff7:	66 0f 28 c5          	movapd %xmm5,%xmm0
    3ffb:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
    3fff:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    4003:	f3 0f 11 84 24 e0 01 	movss  %xmm0,0x1e0(%rsp)
    400a:	00 00 
    400c:	f3 41 0f 10 00       	movss  (%r8),%xmm0
    4011:	f3 41 0f 11 67 70    	movss  %xmm4,0x70(%r15)
    4017:	0f c6 e4 e5          	shufps $0xe5,%xmm4,%xmm4
    401b:	f3 41 0f 11 47 64    	movss  %xmm0,0x64(%r15)
    4021:	f3 41 0f 10 40 0c    	movss  0xc(%r8),%xmm0
    4027:	f3 41 0f 11 47 7c    	movss  %xmm0,0x7c(%r15)
    402d:	f3 41 0f 10 40 04    	movss  0x4(%r8),%xmm0
    4033:	f3 41 0f 11 67 74    	movss  %xmm4,0x74(%r15)
    4039:	f3 41 0f 11 47 68    	movss  %xmm0,0x68(%r15)
    403f:	f3 41 0f 10 40 10    	movss  0x10(%r8),%xmm0
    4045:	f3 41 0f 11 87 80 00 	movss  %xmm0,0x80(%r15)
    404c:	00 00 
    404e:	f3 41 0f 10 40 08    	movss  0x8(%r8),%xmm0
    4054:	f3 41 0f 11 5f 78    	movss  %xmm3,0x78(%r15)
    405a:	f3 41 0f 11 47 6c    	movss  %xmm0,0x6c(%r15)
    4060:	f3 41 0f 10 40 14    	movss  0x14(%r8),%xmm0
    4066:	f3 41 0f 11 87 84 00 	movss  %xmm0,0x84(%r15)
    406d:	00 00 
    406f:	0f 84 1d 06 00 00    	je     4692 <ayatsuri_model_instance_evaluate+0xa52>
    4075:	48 8d 8c 24 d8 01 00 	lea    0x1d8(%rsp),%rcx
    407c:	00 
    407d:	48 8d 9c 24 e4 01 00 	lea    0x1e4(%rsp),%rbx
    4084:	00 
    4085:	45 31 ed             	xor    %r13d,%r13d
    4088:	48 89 8c 24 78 01 00 	mov    %rcx,0x178(%rsp)
    408f:	00 
    4090:	66 48 0f 6e fb       	movq   %rbx,%xmm7
    4095:	4d 89 ea             	mov    %r13,%r10
    4098:	4c 8d b4 24 50 02 00 	lea    0x250(%rsp),%r14
    409f:	00 
    40a0:	48 89 9c 24 80 01 00 	mov    %rbx,0x180(%rsp)
    40a7:	00 
    40a8:	48 8d 9c 24 5c 02 00 	lea    0x25c(%rsp),%rbx
    40af:	00 
    40b0:	4d 89 f3             	mov    %r14,%r11
    40b3:	48 89 5c 24 78       	mov    %rbx,0x78(%rsp)
    40b8:	0f 16 bc 24 78 01 00 	movhps 0x178(%rsp),%xmm7
    40bf:	00 
    40c0:	0f 29 bc 24 a0 01 00 	movaps %xmm7,0x1a0(%rsp)
    40c7:	00 
    40c8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    40cf:	00 
    40d0:	44 8b 60 14          	mov    0x14(%rax),%r12d
    40d4:	49 8b 6f 08          	mov    0x8(%r15),%rbp
    40d8:	4c 89 d1             	mov    %r10,%rcx
    40db:	4f 8d 04 52          	lea    (%r10,%r10,2),%r8
    40df:	48 c1 e1 04          	shl    $0x4,%rcx
    40e3:	4a 8d 14 c5 00 00 00 	lea    0x0(,%r8,8),%rdx
    40ea:	00 
    40eb:	44 89 54 24 18       	mov    %r10d,0x18(%rsp)
    40f0:	49 01 cc             	add    %rcx,%r12
    40f3:	4c 03 20             	add    (%rax),%r12
    40f6:	48 8d 44 15 00       	lea    0x0(%rbp,%rdx,1),%rax
    40fb:	8b 78 08             	mov    0x8(%rax),%edi
    40fe:	41 0f b7 34 24       	movzwl (%r12),%esi
    4103:	48 8d 7c 3d 30       	lea    0x30(%rbp,%rdi,1),%rdi
    4108:	66 85 f6             	test   %si,%si
    410b:	0f 88 9f 05 00 00    	js     46b0 <ayatsuri_model_instance_evaluate+0xa70>
    4111:	f3 0f 6f 07          	movdqu (%rdi),%xmm0
    4115:	44 0f b7 ce          	movzwl %si,%r9d
    4119:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
    411d:	48 8d 9c 24 80 02 00 	lea    0x280(%rsp),%rbx
    4124:	00 
    4125:	8b 74 f5 08          	mov    0x8(%rbp,%rsi,8),%esi
    4129:	41 0f 29 03          	movaps %xmm0,(%r11)
    412d:	f3 0f 6f 47 10       	movdqu 0x10(%rdi),%xmm0
    4132:	48 01 ee             	add    %rbp,%rsi
    4135:	41 0f 29 43 10       	movaps %xmm0,0x10(%r11)
    413a:	f3 0f 6f 06          	movdqu (%rsi),%xmm0
    413e:	8b 7f 20             	mov    0x20(%rdi),%edi
    4141:	0f 29 84 24 80 02 00 	movaps %xmm0,0x280(%rsp)
    4148:	00 
    4149:	f3 0f 6f 46 10       	movdqu 0x10(%rsi),%xmm0
    414e:	41 89 7b 20          	mov    %edi,0x20(%r11)
    4152:	0f 29 84 24 90 02 00 	movaps %xmm0,0x290(%rsp)
    4159:	00 
    415a:	f3 0f 6f 46 20       	movdqu 0x20(%rsi),%xmm0
    415f:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
    4166:	00 
    4167:	48 8b 7c 24 78       	mov    0x78(%rsp),%rdi
    416c:	4c 89 de             	mov    %r11,%rsi
    416f:	66 0f ef d2          	pxor   %xmm2,%xmm2
    4173:	f3 0f 10 06          	movss  (%rsi),%xmm0
    4177:	41 0f 54 c2          	andps  %xmm10,%xmm0
    417b:	44 0f 2e f0          	ucomiss %xmm0,%xmm14
    417f:	0f 82 9b 16 00 00    	jb     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    4185:	f3 0f 10 46 0c       	movss  0xc(%rsi),%xmm0
    418a:	41 0f 54 c2          	andps  %xmm10,%xmm0
    418e:	44 0f 2e f0          	ucomiss %xmm0,%xmm14
    4192:	0f 82 88 16 00 00    	jb     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    4198:	f3 0f 10 46 18       	movss  0x18(%rsi),%xmm0
    419d:	0f 28 c8             	movaps %xmm0,%xmm1
    41a0:	41 0f 54 ca          	andps  %xmm10,%xmm1
    41a4:	44 0f 2e f1          	ucomiss %xmm1,%xmm14
    41a8:	0f 82 72 16 00 00    	jb     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    41ae:	0f 2e c2             	ucomiss %xmm2,%xmm0
    41b1:	7a 06                	jp     41b9 <ayatsuri_model_instance_evaluate+0x579>
    41b3:	0f 84 67 16 00 00    	je     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    41b9:	48 83 c6 04          	add    $0x4,%rsi
    41bd:	48 39 f7             	cmp    %rsi,%rdi
    41c0:	75 b1                	jne    4173 <ayatsuri_model_instance_evaluate+0x533>
    41c2:	48 85 db             	test   %rbx,%rbx
    41c5:	74 34                	je     41fb <ayatsuri_model_instance_evaluate+0x5bb>
    41c7:	48 89 de             	mov    %rbx,%rsi
    41ca:	48 8d 7b 30          	lea    0x30(%rbx),%rdi
    41ce:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    41d5:	00 00 00 00 
    41d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    41e0:	f3 0f 10 06          	movss  (%rsi),%xmm0
    41e4:	41 0f 54 c2          	andps  %xmm10,%xmm0
    41e8:	44 0f 2e f0          	ucomiss %xmm0,%xmm14
    41ec:	0f 82 2e 16 00 00    	jb     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    41f2:	48 83 c6 04          	add    $0x4,%rsi
    41f6:	48 39 f7             	cmp    %rsi,%rdi
    41f9:	75 e5                	jne    41e0 <ayatsuri_model_instance_evaluate+0x5a0>
    41fb:	4c 8d ac 24 b8 01 00 	lea    0x1b8(%rsp),%r13
    4202:	00 
    4203:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4207:	4c 89 5c 24 70       	mov    %r11,0x70(%rsp)
    420c:	4c 8d b4 24 b0 01 00 	lea    0x1b0(%rsp),%r14
    4213:	00 
    4214:	4c 89 f6             	mov    %r14,%rsi
    4217:	4c 89 ef             	mov    %r13,%rdi
    421a:	4c 89 54 24 68       	mov    %r10,0x68(%rsp)
    421f:	f3 0f 5a 84 24 5c 02 	cvtss2sd 0x25c(%rsp),%xmm0
    4226:	00 00 
    4228:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
    422d:	4c 89 44 24 58       	mov    %r8,0x58(%rsp)
    4232:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
    4237:	44 89 4c 24 48       	mov    %r9d,0x48(%rsp)
    423c:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
    4241:	e8 00 00 00 00       	call   4246 <ayatsuri_model_instance_evaluate+0x606>
			4242: R_X86_64_PLT32	sincos-0x4
    4246:	4c 89 f6             	mov    %r14,%rsi
    4249:	4c 89 ef             	mov    %r13,%rdi
    424c:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4250:	f2 0f 10 94 24 b0 01 	movsd  0x1b0(%rsp),%xmm2
    4257:	00 00 
    4259:	f2 44 0f 10 8c 24 b8 	movsd  0x1b8(%rsp),%xmm9
    4260:	01 00 00 
    4263:	f3 0f 5a 84 24 60 02 	cvtss2sd 0x260(%rsp),%xmm0
    426a:	00 00 
    426c:	f2 0f 11 54 24 38    	movsd  %xmm2,0x38(%rsp)
    4272:	f2 44 0f 11 4c 24 30 	movsd  %xmm9,0x30(%rsp)
    4279:	e8 00 00 00 00       	call   427e <ayatsuri_model_instance_evaluate+0x63e>
			427a: R_X86_64_PLT32	sincos-0x4
    427e:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4282:	4c 89 f6             	mov    %r14,%rsi
    4285:	4c 89 ef             	mov    %r13,%rdi
    4288:	f2 0f 10 bc 24 b0 01 	movsd  0x1b0(%rsp),%xmm7
    428f:	00 00 
    4291:	f2 0f 10 a4 24 b8 01 	movsd  0x1b8(%rsp),%xmm4
    4298:	00 00 
    429a:	f3 0f 5a 84 24 64 02 	cvtss2sd 0x264(%rsp),%xmm0
    42a1:	00 00 
    42a3:	f2 0f 11 7c 24 20    	movsd  %xmm7,0x20(%rsp)
    42a9:	f2 0f 11 24 24       	movsd  %xmm4,(%rsp)
    42ae:	e8 00 00 00 00       	call   42b3 <ayatsuri_model_instance_evaluate+0x673>
			42af: R_X86_64_PLT32	sincos-0x4
    42b3:	f2 0f 10 24 24       	movsd  (%rsp),%xmm4
    42b8:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    42bd:	f2 0f 10 84 24 b0 01 	movsd  0x1b0(%rsp),%xmm0
    42c4:	00 00 
    42c6:	f2 44 0f 10 4c 24 30 	movsd  0x30(%rsp),%xmm9
    42cd:	f2 0f 10 54 24 38    	movsd  0x38(%rsp),%xmm2
    42d3:	48 85 db             	test   %rbx,%rbx
    42d6:	44 0f 5a 9c 24 68 02 	cvtps2pd 0x268(%rsp),%xmm11
    42dd:	00 00 
    42df:	66 0f 28 dc          	movapd %xmm4,%xmm3
    42e3:	f2 0f 10 7c 24 20    	movsd  0x20(%rsp),%xmm7
    42e9:	f2 0f 10 8c 24 b8 01 	movsd  0x1b8(%rsp),%xmm1
    42f0:	00 00 
    42f2:	f3 44 0f 5a a4 24 68 	cvtss2sd 0x268(%rsp),%xmm12
    42f9:	02 00 00 
    42fc:	f2 0f 59 d8          	mulsd  %xmm0,%xmm3
    4300:	66 41 0f 28 f1       	movapd %xmm9,%xmm6
    4305:	66 44 0f 28 c2       	movapd %xmm2,%xmm8
    430a:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
    430f:	f2 44 0f 59 c1       	mulsd  %xmm1,%xmm8
    4314:	66 0f 28 ef          	movapd %xmm7,%xmm5
    4318:	66 45 0f 28 e9       	movapd %xmm9,%xmm13
    431d:	4c 63 4c 24 48       	movslq 0x48(%rsp),%r9
    4322:	f2 0f 59 e8          	mulsd  %xmm0,%xmm5
    4326:	66 44 0f 28 fa       	movapd %xmm2,%xmm15
    432b:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
    4330:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
    4335:	f2 44 0f 59 f8       	mulsd  %xmm0,%xmm15
    433a:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
    433f:	4c 8b 54 24 68       	mov    0x68(%rsp),%r10
    4344:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 434d <ayatsuri_model_instance_evaluate+0x70d>
    434b:	00 00 
			4349: R_X86_64_PC32	.LC0-0x4
    434d:	f2 41 0f 59 c1       	mulsd  %xmm9,%xmm0
    4352:	4c 8b 5c 24 70       	mov    0x70(%rsp),%r11
    4357:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 4360 <ayatsuri_model_instance_evaluate+0x720>
    435e:	00 00 
			435c: R_X86_64_PC32	.LC1-0x4
    4360:	f2 0f 59 f3          	mulsd  %xmm3,%xmm6
    4364:	f2 0f 59 da          	mulsd  %xmm2,%xmm3
    4368:	f2 41 0f 59 ec       	mulsd  %xmm12,%xmm5
    436d:	f2 41 0f 5c f0       	subsd  %xmm8,%xmm6
    4372:	66 45 0f 28 c3       	movapd %xmm11,%xmm8
    4377:	66 45 0f 15 c0       	unpckhpd %xmm8,%xmm8
    437c:	f2 41 0f 59 f0       	mulsd  %xmm8,%xmm6
    4381:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    4386:	f3 44 0f 5a 84 24 70 	cvtss2sd 0x270(%rsp),%xmm8
    438d:	02 00 00 
    4390:	66 0f 14 ee          	unpcklpd %xmm6,%xmm5
    4394:	66 41 0f 28 f1       	movapd %xmm9,%xmm6
    4399:	f2 0f 59 f1          	mulsd  %xmm1,%xmm6
    439d:	f2 0f 58 de          	addsd  %xmm6,%xmm3
    43a1:	66 0f 28 f7          	movapd %xmm7,%xmm6
    43a5:	f2 0f 59 f1          	mulsd  %xmm1,%xmm6
    43a9:	f2 0f 59 cc          	mulsd  %xmm4,%xmm1
    43ad:	66 0f 57 a4 24 80 00 	xorpd  0x80(%rsp),%xmm4
    43b4:	00 00 
    43b6:	f2 41 0f 59 d8       	mulsd  %xmm8,%xmm3
    43bb:	f2 44 0f 59 e9       	mulsd  %xmm1,%xmm13
    43c0:	f2 0f 59 ca          	mulsd  %xmm2,%xmm1
    43c4:	f2 0f 59 d7          	mulsd  %xmm7,%xmm2
    43c8:	f2 45 0f 58 ef       	addsd  %xmm15,%xmm13
    43cd:	f2 0f 5c c8          	subsd  %xmm0,%xmm1
    43d1:	66 41 0f 28 c1       	movapd %xmm9,%xmm0
    43d6:	66 45 0f ef c9       	pxor   %xmm9,%xmm9
    43db:	f3 44 0f 5a 8c 24 58 	cvtss2sd 0x258(%rsp),%xmm9
    43e2:	02 00 00 
    43e5:	f2 0f 59 c7          	mulsd  %xmm7,%xmm0
    43e9:	66 0f ef ff          	pxor   %xmm7,%xmm7
    43ed:	f3 0f 5a bc 24 50 02 	cvtss2sd 0x250(%rsp),%xmm7
    43f4:	00 00 
    43f6:	f2 41 0f 59 d0       	mulsd  %xmm8,%xmm2
    43fb:	f2 41 0f 59 c8       	mulsd  %xmm8,%xmm1
    4400:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    4405:	f3 44 0f 5a 84 24 54 	cvtss2sd 0x254(%rsp),%xmm8
    440c:	02 00 00 
    440f:	0f 84 23 14 00 00    	je     5838 <ayatsuri_model_instance_evaluate+0x1bf8>
    4415:	66 41 0f 14 f5       	unpcklpd %xmm13,%xmm6
    441a:	66 0f 14 e0          	unpcklpd %xmm0,%xmm4
    441e:	4c 8d ac 24 90 03 00 	lea    0x390(%rsp),%r13
    4425:	00 
    4426:	66 41 0f 59 f3       	mulpd  %xmm11,%xmm6
    442b:	4c 89 ee             	mov    %r13,%rsi
    442e:	48 8d 7b 30          	lea    0x30(%rbx),%rdi
    4432:	66 41 0f 59 e3       	mulpd  %xmm11,%xmm4
    4437:	66 0f ef c0          	pxor   %xmm0,%xmm0
    443b:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    4440:	48 83 c3 10          	add    $0x10,%rbx
    4444:	48 83 c6 20          	add    $0x20,%rsi
    4448:	f3 0f 5a 43 f0       	cvtss2sd -0x10(%rbx),%xmm0
    444d:	f3 44 0f 5a 63 f4    	cvtss2sd -0xc(%rbx),%xmm12
    4453:	66 44 0f 28 e8       	movapd %xmm0,%xmm13
    4458:	66 45 0f 28 fc       	movapd %xmm12,%xmm15
    445d:	66 45 0f 14 ed       	unpcklpd %xmm13,%xmm13
    4462:	66 45 0f 14 ff       	unpcklpd %xmm15,%xmm15
    4467:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    446c:	66 44 0f 59 fe       	mulpd  %xmm6,%xmm15
    4471:	f3 44 0f 5a 5b f8    	cvtss2sd -0x8(%rbx),%xmm11
    4477:	66 44 0f 59 ed       	mulpd  %xmm5,%xmm13
    447c:	66 45 0f 58 ef       	addpd  %xmm15,%xmm13
    4481:	66 45 0f 28 fb       	movapd %xmm11,%xmm15
    4486:	66 45 0f 14 ff       	unpcklpd %xmm15,%xmm15
    448b:	66 44 0f 59 fc       	mulpd  %xmm4,%xmm15
    4490:	66 45 0f 58 ef       	addpd  %xmm15,%xmm13
    4495:	66 44 0f 28 f9       	movapd %xmm1,%xmm15
    449a:	f2 45 0f 59 fc       	mulsd  %xmm12,%xmm15
    449f:	f2 45 0f 59 e0       	mulsd  %xmm8,%xmm12
    44a4:	44 0f 29 6e e0       	movaps %xmm13,-0x20(%rsi)
    44a9:	66 44 0f 28 eb       	movapd %xmm3,%xmm13
    44ae:	f2 44 0f 59 e8       	mulsd  %xmm0,%xmm13
    44b3:	f2 0f 59 c7          	mulsd  %xmm7,%xmm0
    44b7:	f2 45 0f 58 ef       	addsd  %xmm15,%xmm13
    44bc:	66 44 0f 28 fa       	movapd %xmm2,%xmm15
    44c1:	f2 45 0f 59 fb       	mulsd  %xmm11,%xmm15
    44c6:	f2 41 0f 58 c4       	addsd  %xmm12,%xmm0
    44cb:	f2 45 0f 59 d9       	mulsd  %xmm9,%xmm11
    44d0:	f2 45 0f 58 ef       	addsd  %xmm15,%xmm13
    44d5:	f2 41 0f 58 c3       	addsd  %xmm11,%xmm0
    44da:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    44df:	f3 44 0f 5a 5b fc    	cvtss2sd -0x4(%rbx),%xmm11
    44e5:	f2 44 0f 11 6e f0    	movsd  %xmm13,-0x10(%rsi)
    44eb:	f2 41 0f 58 c3       	addsd  %xmm11,%xmm0
    44f0:	f2 0f 11 46 f8       	movsd  %xmm0,-0x8(%rsi)
    44f5:	48 39 df             	cmp    %rbx,%rdi
    44f8:	0f 85 39 ff ff ff    	jne    4437 <ayatsuri_model_instance_evaluate+0x7f7>
    44fe:	31 f6                	xor    %esi,%esi
    4500:	66 0f ef d2          	pxor   %xmm2,%xmm2
    4504:	eb 33                	jmp    4539 <ayatsuri_model_instance_evaluate+0x8f9>
    4506:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    450d:	00 00 00 
    4510:	66 0f 2f d1          	comisd %xmm1,%xmm2
    4514:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 451c <ayatsuri_model_instance_evaluate+0x8dc>
    451b:	00 
			4518: R_X86_64_PC32	.LC33-0x4
    451c:	77 04                	ja     4522 <ayatsuri_model_instance_evaluate+0x8e2>
    451e:	41 0f 28 c6          	movaps %xmm14,%xmm0
    4522:	48 8d 9c 24 30 03 00 	lea    0x330(%rsp),%rbx
    4529:	00 
    452a:	f3 0f 11 04 b3       	movss  %xmm0,(%rbx,%rsi,4)
    452f:	48 83 c6 01          	add    $0x1,%rsi
    4533:	48 83 fe 0c          	cmp    $0xc,%rsi
    4537:	74 47                	je     4580 <ayatsuri_model_instance_evaluate+0x940>
    4539:	f2 41 0f 10 4c f5 00 	movsd  0x0(%r13,%rsi,8),%xmm1
    4540:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 4548 <ayatsuri_model_instance_evaluate+0x908>
    4547:	00 
			4544: R_X86_64_PC32	.LC22-0x4
    4548:	66 0f 28 c1          	movapd %xmm1,%xmm0
    454c:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 4554 <ayatsuri_model_instance_evaluate+0x914>
    4553:	00 
			4550: R_X86_64_PC32	.LC8-0x4
    4554:	66 0f 2e e8          	ucomisd %xmm0,%xmm5
    4558:	0f 82 c2 12 00 00    	jb     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    455e:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 4566 <ayatsuri_model_instance_evaluate+0x926>
    4565:	00 
			4562: R_X86_64_PC32	.LC38-0x4
    4566:	0f 83 b4 12 00 00    	jae    5820 <ayatsuri_model_instance_evaluate+0x1be0>
    456c:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 4574 <ayatsuri_model_instance_evaluate+0x934>
    4573:	00 
			4570: R_X86_64_PC32	.LC39-0x4
    4574:	77 9a                	ja     4510 <ayatsuri_model_instance_evaluate+0x8d0>
    4576:	66 0f ef c0          	pxor   %xmm0,%xmm0
    457a:	f2 0f 5a c1          	cvtsd2ss %xmm1,%xmm0
    457e:	eb a2                	jmp    4522 <ayatsuri_model_instance_evaluate+0x8e2>
    4580:	66 0f 6f 84 24 30 03 	movdqa 0x330(%rsp),%xmm0
    4587:	00 00 
    4589:	41 8b b7 8c 00 00 00 	mov    0x8c(%r15),%esi
    4590:	31 ff                	xor    %edi,%edi
    4592:	0f 29 84 24 b0 02 00 	movaps %xmm0,0x2b0(%rsp)
    4599:	00 
    459a:	83 fe ff             	cmp    $0xffffffff,%esi
    459d:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
    45a4:	00 00 
    45a6:	40 0f 95 c7          	setne  %dil
    45aa:	0f 29 84 24 c0 02 00 	movaps %xmm0,0x2c0(%rsp)
    45b1:	00 
    45b2:	01 fe                	add    %edi,%esi
    45b4:	66 0f 6f 84 24 50 03 	movdqa 0x350(%rsp),%xmm0
    45bb:	00 00 
    45bd:	41 89 b7 8c 00 00 00 	mov    %esi,0x8c(%r15)
    45c4:	0f 29 84 24 d0 02 00 	movaps %xmm0,0x2d0(%rsp)
    45cb:	00 
    45cc:	8b 40 08             	mov    0x8(%rax),%eax
    45cf:	66 0f 6f 84 24 b0 02 	movdqa 0x2b0(%rsp),%xmm0
    45d6:	00 00 
    45d8:	48 01 c5             	add    %rax,%rbp
    45db:	0f 11 45 00          	movups %xmm0,0x0(%rbp)
    45df:	66 0f 6f 84 24 c0 02 	movdqa 0x2c0(%rsp),%xmm0
    45e6:	00 00 
    45e8:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
    45ec:	66 0f 6f 84 24 d0 02 	movdqa 0x2d0(%rsp),%xmm0
    45f3:	00 00 
    45f5:	0f 11 45 20          	movups %xmm0,0x20(%rbp)
    45f9:	49 8b 47 08          	mov    0x8(%r15),%rax
    45fd:	48 8d 34 10          	lea    (%rax,%rdx,1),%rsi
    4601:	0f b6 7e 10          	movzbl 0x10(%rsi),%edi
    4605:	40 84 ff             	test   %dil,%dil
    4608:	74 17                	je     4621 <ayatsuri_model_instance_evaluate+0x9e1>
    460a:	bf 01 00 00 00       	mov    $0x1,%edi
    460f:	45 85 c9             	test   %r9d,%r9d
    4612:	78 0d                	js     4621 <ayatsuri_model_instance_evaluate+0x9e1>
    4614:	4b 8d 3c 49          	lea    (%r9,%r9,2),%rdi
    4618:	80 7c f8 11 00       	cmpb   $0x0,0x11(%rax,%rdi,8)
    461d:	40 0f 95 c7          	setne  %dil
    4621:	40 88 7e 11          	mov    %dil,0x11(%rsi)
    4625:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    462b:	40 80 ff 01          	cmp    $0x1,%dil
    462f:	0f 84 ab 00 00 00    	je     46e0 <ayatsuri_model_instance_evaluate+0xaa0>
    4635:	40 80 ff 02          	cmp    $0x2,%dil
    4639:	0f 84 01 09 00 00    	je     4f40 <ayatsuri_model_instance_evaluate+0x1300>
    463f:	40 80 ff 03          	cmp    $0x3,%dil
    4643:	0f 84 97 08 00 00    	je     4ee0 <ayatsuri_model_instance_evaluate+0x12a0>
    4649:	40 84 ff             	test   %dil,%dil
    464c:	74 30                	je     467e <ayatsuri_model_instance_evaluate+0xa3e>
    464e:	41 8b 87 90 00 00 00 	mov    0x90(%r15),%eax
    4655:	31 d2                	xor    %edx,%edx
    4657:	83 f8 ff             	cmp    $0xffffffff,%eax
    465a:	0f 95 c2             	setne  %dl
    465d:	01 d0                	add    %edx,%eax
    465f:	31 d2                	xor    %edx,%edx
    4661:	41 89 87 90 00 00 00 	mov    %eax,0x90(%r15)
    4668:	41 8b 87 94 00 00 00 	mov    0x94(%r15),%eax
    466f:	83 f8 ff             	cmp    $0xffffffff,%eax
    4672:	0f 95 c2             	setne  %dl
    4675:	01 d0                	add    %edx,%eax
    4677:	41 89 87 94 00 00 00 	mov    %eax,0x94(%r15)
    467e:	49 8b 07             	mov    (%r15),%rax
    4681:	49 83 c2 01          	add    $0x1,%r10
    4685:	0f b7 50 0c          	movzwl 0xc(%rax),%edx
    4689:	41 39 d2             	cmp    %edx,%r10d
    468c:	0f 82 3e fa ff ff    	jb     40d0 <ayatsuri_model_instance_evaluate+0x490>
    4692:	b8 00 01 00 00       	mov    $0x100,%eax
    4697:	66 41 89 87 a5 00 00 	mov    %ax,0xa5(%r15)
    469e:	00 
    469f:	31 c0                	xor    %eax,%eax
    46a1:	e9 e9 f6 ff ff       	jmp    3d8f <ayatsuri_model_instance_evaluate+0x14f>
    46a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    46ad:	00 00 00 
    46b0:	f3 0f 6f 07          	movdqu (%rdi),%xmm0
    46b4:	41 89 f1             	mov    %esi,%r9d
    46b7:	31 db                	xor    %ebx,%ebx
    46b9:	41 81 c9 00 00 ff ff 	or     $0xffff0000,%r9d
    46c0:	41 0f 29 03          	movaps %xmm0,(%r11)
    46c4:	f3 0f 6f 47 10       	movdqu 0x10(%rdi),%xmm0
    46c9:	41 0f 29 43 10       	movaps %xmm0,0x10(%r11)
    46ce:	8b 77 20             	mov    0x20(%rdi),%esi
    46d1:	41 89 73 20          	mov    %esi,0x20(%r11)
    46d5:	e9 8d fa ff ff       	jmp    4167 <ayatsuri_model_instance_evaluate+0x527>
    46da:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    46e0:	4d 8b 37             	mov    (%r15),%r14
    46e3:	45 8b 4e 14          	mov    0x14(%r14),%r9d
    46e7:	49 8b 3e             	mov    (%r14),%rdi
    46ea:	41 8b 6e 24          	mov    0x24(%r14),%ebp
    46ee:	49 01 c9             	add    %rcx,%r9
    46f1:	48 89 3c 24          	mov    %rdi,(%rsp)
    46f5:	49 01 f9             	add    %rdi,%r9
    46f8:	41 0f b7 79 04       	movzwl 0x4(%r9),%edi
    46fd:	45 0f b7 49 08       	movzwl 0x8(%r9),%r9d
    4702:	8d 3c 7f             	lea    (%rdi,%rdi,2),%edi
    4705:	c1 e7 02             	shl    $0x2,%edi
    4708:	48 01 ef             	add    %rbp,%rdi
    470b:	48 8b 2c 24          	mov    (%rsp),%rbp
    470f:	48 01 ef             	add    %rbp,%rdi
    4712:	41 8b 6e 34          	mov    0x34(%r14),%ebp
    4716:	89 6c 24 30          	mov    %ebp,0x30(%rsp)
    471a:	8b 6e 08             	mov    0x8(%rsi),%ebp
    471d:	48 01 c5             	add    %rax,%rbp
    4720:	31 c0                	xor    %eax,%eax
    4722:	0f 10 4c 05 00       	movups 0x0(%rbp,%rax,1),%xmm1
    4727:	0f 5a c1             	cvtps2pd %xmm1,%xmm0
    472a:	41 0f 29 44 45 00    	movaps %xmm0,0x0(%r13,%rax,2)
    4730:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4734:	0f 12 c1             	movhlps %xmm1,%xmm0
    4737:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
    473a:	41 0f 29 44 45 10    	movaps %xmm0,0x10(%r13,%rax,2)
    4740:	48 83 c0 10          	add    $0x10,%rax
    4744:	48 83 f8 30          	cmp    $0x30,%rax
    4748:	75 d8                	jne    4722 <ayatsuri_model_instance_evaluate+0xae2>
    474a:	f2 44 0f 10 bc 24 98 	movsd  0x398(%rsp),%xmm15
    4751:	03 00 00 
    4754:	f3 0f 7e 07          	movq   (%rdi),%xmm0
    4758:	f2 0f 10 ac 24 c0 03 	movsd  0x3c0(%rsp),%xmm5
    475f:	00 00 
    4761:	f2 44 0f 10 8c 24 b8 	movsd  0x3b8(%rsp),%xmm9
    4768:	03 00 00 
    476b:	f2 44 0f 10 84 24 b0 	movsd  0x3b0(%rsp),%xmm8
    4772:	03 00 00 
    4775:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
    4778:	66 0f 28 f8          	movapd %xmm0,%xmm7
    477c:	66 0f 28 c8          	movapd %xmm0,%xmm1
    4780:	66 0f 15 ff          	unpckhpd %xmm7,%xmm7
    4784:	f2 0f 11 6c 24 40    	movsd  %xmm5,0x40(%rsp)
    478a:	f2 44 0f 10 ac 24 90 	movsd  0x390(%rsp),%xmm13
    4791:	03 00 00 
    4794:	66 0f 28 d7          	movapd %xmm7,%xmm2
    4798:	0f 29 84 24 e0 02 00 	movaps %xmm0,0x2e0(%rsp)
    479f:	00 
    47a0:	66 0f ef c0          	pxor   %xmm0,%xmm0
    47a4:	f2 44 0f 59 ff       	mulsd  %xmm7,%xmm15
    47a9:	f3 0f 5a 47 08       	cvtss2sd 0x8(%rdi),%xmm0
    47ae:	f2 0f 10 bc 24 a0 03 	movsd  0x3a0(%rsp),%xmm7
    47b5:	00 00 
    47b7:	f2 0f 11 84 24 f0 02 	movsd  %xmm0,0x2f0(%rsp)
    47be:	00 00 
    47c0:	f2 44 0f 59 ca       	mulsd  %xmm2,%xmm9
    47c5:	f2 0f 11 7c 24 38    	movsd  %xmm7,0x38(%rsp)
    47cb:	f2 44 0f 59 c1       	mulsd  %xmm1,%xmm8
    47d0:	66 0f 28 f7          	movapd %xmm7,%xmm6
    47d4:	66 0f 28 fd          	movapd %xmm5,%xmm7
    47d8:	f2 0f 10 ac 24 e0 03 	movsd  0x3e0(%rsp),%xmm5
    47df:	00 00 
    47e1:	f2 0f 59 f8          	mulsd  %xmm0,%xmm7
    47e5:	f2 0f 59 f0          	mulsd  %xmm0,%xmm6
    47e9:	f2 0f 59 94 24 d8 03 	mulsd  0x3d8(%rsp),%xmm2
    47f0:	00 00 
    47f2:	f2 0f 11 6c 24 48    	movsd  %xmm5,0x48(%rsp)
    47f8:	f2 0f 59 c5          	mulsd  %xmm5,%xmm0
    47fc:	66 41 0f 28 e9       	movapd %xmm9,%xmm5
    4801:	f2 44 0f 59 e9       	mulsd  %xmm1,%xmm13
    4806:	66 45 0f 28 e0       	movapd %xmm8,%xmm12
    480b:	66 41 0f 28 e0       	movapd %xmm8,%xmm4
    4810:	f2 0f 59 8c 24 d0 03 	mulsd  0x3d0(%rsp),%xmm1
    4817:	00 00 
    4819:	66 0f 28 df          	movapd %xmm7,%xmm3
    481d:	66 44 0f 28 df       	movapd %xmm7,%xmm11
    4822:	f2 0f 59 da          	mulsd  %xmm2,%xmm3
    4826:	f2 0f 59 e8          	mulsd  %xmm0,%xmm5
    482a:	f2 44 0f 59 e0       	mulsd  %xmm0,%xmm12
    482f:	f2 44 0f 59 d9       	mulsd  %xmm1,%xmm11
    4834:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    4838:	f2 0f 5c eb          	subsd  %xmm3,%xmm5
    483c:	66 41 0f 28 d9       	movapd %xmm9,%xmm3
    4841:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
    4845:	f2 44 0f 11 64 24 20 	movsd  %xmm12,0x20(%rsp)
    484c:	f2 45 0f 5c e3       	subsd  %xmm11,%xmm12
    4851:	66 44 0f 28 d4       	movapd %xmm4,%xmm10
    4856:	f2 0f 10 25 00 00 00 	movsd  0x0(%rip),%xmm4        # 485e <ayatsuri_model_instance_evaluate+0xc1e>
    485d:	00 
			485a: R_X86_64_PC32	.LC22-0x4
    485e:	f2 45 0f 59 e7       	mulsd  %xmm15,%xmm12
    4863:	f2 44 0f 5c d3       	subsd  %xmm3,%xmm10
    4868:	66 41 0f 28 dd       	movapd %xmm13,%xmm3
    486d:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    4871:	f2 41 0f 5c dc       	subsd  %xmm12,%xmm3
    4876:	66 44 0f 28 e6       	movapd %xmm6,%xmm12
    487b:	f2 45 0f 59 e2       	mulsd  %xmm10,%xmm12
    4880:	f2 41 0f 58 dc       	addsd  %xmm12,%xmm3
    4885:	66 44 0f 28 e3       	movapd %xmm3,%xmm12
    488a:	66 44 0f 54 25 00 00 	andpd  0x0(%rip),%xmm12        # 4893 <ayatsuri_model_instance_evaluate+0xc53>
    4891:	00 00 
			488f: R_X86_64_PC32	.LC8-0x4
    4893:	66 41 0f 2e e4       	ucomisd %xmm12,%xmm4
    4898:	0f 82 82 0f 00 00    	jb     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    489e:	f2 0f 10 25 00 00 00 	movsd  0x0(%rip),%xmm4        # 48a6 <ayatsuri_model_instance_evaluate+0xc66>
    48a5:	00 
			48a2: R_X86_64_PC32	.LC40-0x4
    48a6:	66 41 0f 2f e4       	comisd %xmm12,%xmm4
    48ab:	0f 87 6f 0f 00 00    	ja     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    48b1:	f2 44 0f 5c 5c 24 20 	subsd  0x20(%rsp),%xmm11
    48b8:	66 44 0f 28 e3       	movapd %xmm3,%xmm12
    48bd:	66 41 0f 28 e2       	movapd %xmm10,%xmm4
    48c2:	31 c0                	xor    %eax,%eax
    48c4:	66 45 0f 14 e4       	unpcklpd %xmm12,%xmm12
    48c9:	66 41 0f 14 eb       	unpcklpd %xmm11,%xmm5
    48ce:	66 44 0f 28 de       	movapd %xmm6,%xmm11
    48d3:	66 41 0f 5e ec       	divpd  %xmm12,%xmm5
    48d8:	f2 44 0f 59 da       	mulsd  %xmm2,%xmm11
    48dd:	f2 41 0f 59 d5       	mulsd  %xmm13,%xmm2
    48e2:	0f 29 ac 24 30 03 00 	movaps %xmm5,0x330(%rsp)
    48e9:	00 
    48ea:	66 41 0f 28 ef       	movapd %xmm15,%xmm5
    48ef:	f2 0f 59 e8          	mulsd  %xmm0,%xmm5
    48f3:	f2 41 0f 59 c5       	mulsd  %xmm13,%xmm0
    48f8:	f2 44 0f 5c dd       	subsd  %xmm5,%xmm11
    48fd:	66 41 0f 14 e3       	unpcklpd %xmm11,%xmm4
    4902:	66 41 0f 5e e4       	divpd  %xmm12,%xmm4
    4907:	0f 29 a4 24 40 03 00 	movaps %xmm4,0x340(%rsp)
    490e:	00 
    490f:	66 0f 28 e6          	movapd %xmm6,%xmm4
    4913:	f2 0f 59 e1          	mulsd  %xmm1,%xmm4
    4917:	f2 41 0f 59 cf       	mulsd  %xmm15,%xmm1
    491c:	f2 0f 5c c4          	subsd  %xmm4,%xmm0
    4920:	f2 0f 5c ca          	subsd  %xmm2,%xmm1
    4924:	66 0f 14 c1          	unpcklpd %xmm1,%xmm0
    4928:	66 0f 28 ce          	movapd %xmm6,%xmm1
    492c:	66 41 0f 5e c4       	divpd  %xmm12,%xmm0
    4931:	f2 41 0f 59 c9       	mulsd  %xmm9,%xmm1
    4936:	f2 41 0f 59 f0       	mulsd  %xmm8,%xmm6
    493b:	0f 29 84 24 50 03 00 	movaps %xmm0,0x350(%rsp)
    4942:	00 
    4943:	66 41 0f 28 c7       	movapd %xmm15,%xmm0
    4948:	f2 0f 59 c7          	mulsd  %xmm7,%xmm0
    494c:	f2 41 0f 59 fd       	mulsd  %xmm13,%xmm7
    4951:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    4955:	66 41 0f 28 cf       	movapd %xmm15,%xmm1
    495a:	f2 0f 5c f7          	subsd  %xmm7,%xmm6
    495e:	f2 41 0f 59 c8       	mulsd  %xmm8,%xmm1
    4963:	66 0f 14 c6          	unpcklpd %xmm6,%xmm0
    4967:	66 41 0f 5e c4       	divpd  %xmm12,%xmm0
    496c:	0f 29 84 24 60 03 00 	movaps %xmm0,0x360(%rsp)
    4973:	00 
    4974:	66 41 0f 28 c5       	movapd %xmm13,%xmm0
    4979:	f2 41 0f 59 c1       	mulsd  %xmm9,%xmm0
    497e:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    4982:	f2 0f 5e c3          	divsd  %xmm3,%xmm0
    4986:	f2 0f 11 84 24 70 03 	movsd  %xmm0,0x370(%rsp)
    498d:	00 00 
    498f:	f2 0f 10 0c 43       	movsd  (%rbx,%rax,2),%xmm1
    4994:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 499c <ayatsuri_model_instance_evaluate+0xd5c>
    499b:	00 
			4998: R_X86_64_PC32	.LC22-0x4
    499c:	66 0f 28 c1          	movapd %xmm1,%xmm0
    49a0:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 49a8 <ayatsuri_model_instance_evaluate+0xd68>
    49a7:	00 
			49a4: R_X86_64_PC32	.LC8-0x4
    49a8:	66 0f 2e f8          	ucomisd %xmm0,%xmm7
    49ac:	0f 82 6e 0e 00 00    	jb     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    49b2:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 49ba <ayatsuri_model_instance_evaluate+0xd7a>
    49b9:	00 
			49b6: R_X86_64_PC32	.LC38-0x4
    49ba:	0f 83 60 0e 00 00    	jae    5820 <ayatsuri_model_instance_evaluate+0x1be0>
    49c0:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 49c8 <ayatsuri_model_instance_evaluate+0xd88>
    49c7:	00 
			49c4: R_X86_64_PC32	.LC39-0x4
    49c8:	0f 86 f5 13 00 00    	jbe    5dc3 <ayatsuri_model_instance_evaluate+0x2183>
    49ce:	66 0f ef d2          	pxor   %xmm2,%xmm2
    49d2:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 49da <ayatsuri_model_instance_evaluate+0xd9a>
    49d9:	00 
			49d6: R_X86_64_PC32	.LC33-0x4
    49da:	66 0f 2f d1          	comisd %xmm1,%xmm2
    49de:	77 04                	ja     49e4 <ayatsuri_model_instance_evaluate+0xda4>
    49e0:	41 0f 28 c6          	movaps %xmm14,%xmm0
    49e4:	f3 0f 11 84 05 80 00 	movss  %xmm0,0x80(%rbp,%rax,1)
    49eb:	00 00 
    49ed:	48 83 c0 04          	add    $0x4,%rax
    49f1:	48 83 f8 24          	cmp    $0x24,%rax
    49f5:	75 98                	jne    498f <ayatsuri_model_instance_evaluate+0xd4f>
    49f7:	48 89 54 24 50       	mov    %rdx,0x50(%rsp)
    49fc:	48 8d 84 24 e0 02 00 	lea    0x2e0(%rsp),%rax
    4a03:	00 
    4a04:	66 0f ef c9          	pxor   %xmm1,%xmm1
    4a08:	31 ff                	xor    %edi,%edi
    4a0a:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
    4a0f:	4c 89 e8             	mov    %r13,%rax
    4a12:	f3 41 0f 5a 4f 40    	cvtss2sd 0x40(%r15),%xmm1
    4a18:	f2 0f 10 30          	movsd  (%rax),%xmm6
    4a1c:	f2 0f 10 68 20       	movsd  0x20(%rax),%xmm5
    4a21:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4a25:	66 0f ef db          	pxor   %xmm3,%xmm3
    4a29:	f3 0f 5a 84 24 e4 01 	cvtss2sd 0x1e4(%rsp),%xmm0
    4a30:	00 00 
    4a32:	f2 0f 10 60 40       	movsd  0x40(%rax),%xmm4
    4a37:	f3 0f 5a 9c 24 e8 01 	cvtss2sd 0x1e8(%rsp),%xmm3
    4a3e:	00 00 
    4a40:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
    4a45:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    4a49:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 4a51 <ayatsuri_model_instance_evaluate+0xe11>
    4a50:	00 
			4a4d: R_X86_64_PC32	.LC22-0x4
    4a51:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
    4a55:	f2 0f 10 14 7a       	movsd  (%rdx,%rdi,2),%xmm2
    4a5a:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    4a5e:	66 0f ef db          	pxor   %xmm3,%xmm3
    4a62:	f3 0f 5a 9c 24 ec 01 	cvtss2sd 0x1ec(%rsp),%xmm3
    4a69:	00 00 
    4a6b:	f2 0f 59 dc          	mulsd  %xmm4,%xmm3
    4a6f:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    4a73:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    4a77:	f2 0f 59 c2          	mulsd  %xmm2,%xmm0
    4a7b:	66 0f 28 d8          	movapd %xmm0,%xmm3
    4a7f:	66 0f 54 1d 00 00 00 	andpd  0x0(%rip),%xmm3        # 4a87 <ayatsuri_model_instance_evaluate+0xe47>
    4a86:	00 
			4a83: R_X86_64_PC32	.LC8-0x4
    4a87:	66 0f 2e fb          	ucomisd %xmm3,%xmm7
    4a8b:	0f 82 8f 0d 00 00    	jb     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    4a91:	66 0f 2f 1d 00 00 00 	comisd 0x0(%rip),%xmm3        # 4a99 <ayatsuri_model_instance_evaluate+0xe59>
    4a98:	00 
			4a95: R_X86_64_PC32	.LC38-0x4
    4a99:	0f 83 81 0d 00 00    	jae    5820 <ayatsuri_model_instance_evaluate+0x1be0>
    4a9f:	66 0f 2f 1d 00 00 00 	comisd 0x0(%rip),%xmm3        # 4aa7 <ayatsuri_model_instance_evaluate+0xe67>
    4aa6:	00 
			4aa3: R_X86_64_PC32	.LC39-0x4
    4aa7:	0f 86 3a 13 00 00    	jbe    5de7 <ayatsuri_model_instance_evaluate+0x21a7>
    4aad:	66 0f ef db          	pxor   %xmm3,%xmm3
    4ab1:	66 0f 2f d8          	comisd %xmm0,%xmm3
    4ab5:	0f 87 35 13 00 00    	ja     5df0 <ayatsuri_model_instance_evaluate+0x21b0>
    4abb:	41 0f 28 c6          	movaps %xmm14,%xmm0
    4abf:	f3 0f 11 44 3d 60    	movss  %xmm0,0x60(%rbp,%rdi,1)
    4ac5:	66 0f ef db          	pxor   %xmm3,%xmm3
    4ac9:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4acd:	f3 0f 5a 84 24 d8 01 	cvtss2sd 0x1d8(%rsp),%xmm0
    4ad4:	00 00 
    4ad6:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
    4ada:	f3 0f 5a 9c 24 dc 01 	cvtss2sd 0x1dc(%rsp),%xmm3
    4ae1:	00 00 
    4ae3:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 4aeb <ayatsuri_model_instance_evaluate+0xeab>
    4aea:	00 
			4ae7: R_X86_64_PC32	.LC22-0x4
    4aeb:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    4aef:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    4af3:	66 0f ef db          	pxor   %xmm3,%xmm3
    4af7:	f3 0f 5a 9c 24 e0 01 	cvtss2sd 0x1e0(%rsp),%xmm3
    4afe:	00 00 
    4b00:	f2 0f 59 dc          	mulsd  %xmm4,%xmm3
    4b04:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    4b08:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    4b0c:	f2 0f 59 c2          	mulsd  %xmm2,%xmm0
    4b10:	66 0f 28 d0          	movapd %xmm0,%xmm2
    4b14:	66 0f 54 15 00 00 00 	andpd  0x0(%rip),%xmm2        # 4b1c <ayatsuri_model_instance_evaluate+0xedc>
    4b1b:	00 
			4b18: R_X86_64_PC32	.LC8-0x4
    4b1c:	66 0f 2e f2          	ucomisd %xmm2,%xmm6
    4b20:	0f 82 fa 0c 00 00    	jb     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    4b26:	66 0f 2f 15 00 00 00 	comisd 0x0(%rip),%xmm2        # 4b2e <ayatsuri_model_instance_evaluate+0xeee>
    4b2d:	00 
			4b2a: R_X86_64_PC32	.LC38-0x4
    4b2e:	0f 83 ec 0c 00 00    	jae    5820 <ayatsuri_model_instance_evaluate+0x1be0>
    4b34:	66 0f 2f 15 00 00 00 	comisd 0x0(%rip),%xmm2        # 4b3c <ayatsuri_model_instance_evaluate+0xefc>
    4b3b:	00 
			4b38: R_X86_64_PC32	.LC39-0x4
    4b3c:	0f 86 bb 12 00 00    	jbe    5dfd <ayatsuri_model_instance_evaluate+0x21bd>
    4b42:	66 0f ef d2          	pxor   %xmm2,%xmm2
    4b46:	66 0f 2f d0          	comisd %xmm0,%xmm2
    4b4a:	0f 87 c6 16 00 00    	ja     6216 <ayatsuri_model_instance_evaluate+0x25d6>
    4b50:	41 0f 28 c6          	movaps %xmm14,%xmm0
    4b54:	f3 0f 11 44 3d 70    	movss  %xmm0,0x70(%rbp,%rdi,1)
    4b5a:	48 83 c7 04          	add    $0x4,%rdi
    4b5e:	48 83 c0 08          	add    $0x8,%rax
    4b62:	48 83 ff 0c          	cmp    $0xc,%rdi
    4b66:	0f 85 ac fe ff ff    	jne    4a18 <ayatsuri_model_instance_evaluate+0xdd8>
    4b6c:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4b70:	66 0f ef ed          	pxor   %xmm5,%xmm5
    4b74:	f2 0f 10 a4 24 a8 03 	movsd  0x3a8(%rsp),%xmm4
    4b7b:	00 00 
    4b7d:	f2 0f 10 9c 24 c8 03 	movsd  0x3c8(%rsp),%xmm3
    4b84:	00 00 
    4b86:	f3 41 0f 5a 47 34    	cvtss2sd 0x34(%r15),%xmm0
    4b8c:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 4b94 <ayatsuri_model_instance_evaluate+0xf54>
    4b93:	00 
			4b90: R_X86_64_PC32	.LC22-0x4
    4b94:	f2 0f 10 94 24 e8 03 	movsd  0x3e8(%rsp),%xmm2
    4b9b:	00 00 
    4b9d:	f3 0f 5a ac 24 e8 01 	cvtss2sd 0x1e8(%rsp),%xmm5
    4ba4:	00 00 
    4ba6:	f2 0f 5c e0          	subsd  %xmm0,%xmm4
    4baa:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4bae:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
    4bb3:	f3 41 0f 5a 47 38    	cvtss2sd 0x38(%r15),%xmm0
    4bb9:	f2 0f 5c d8          	subsd  %xmm0,%xmm3
    4bbd:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4bc1:	f3 41 0f 5a 47 3c    	cvtss2sd 0x3c(%r15),%xmm0
    4bc7:	f2 0f 5c d0          	subsd  %xmm0,%xmm2
    4bcb:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4bcf:	f3 0f 5a 84 24 e4 01 	cvtss2sd 0x1e4(%rsp),%xmm0
    4bd6:	00 00 
    4bd8:	f2 0f 59 c4          	mulsd  %xmm4,%xmm0
    4bdc:	f2 0f 59 eb          	mulsd  %xmm3,%xmm5
    4be0:	f2 0f 58 c5          	addsd  %xmm5,%xmm0
    4be4:	66 0f ef ed          	pxor   %xmm5,%xmm5
    4be8:	f3 0f 5a ac 24 ec 01 	cvtss2sd 0x1ec(%rsp),%xmm5
    4bef:	00 00 
    4bf1:	f2 0f 59 ea          	mulsd  %xmm2,%xmm5
    4bf5:	f2 0f 58 c5          	addsd  %xmm5,%xmm0
    4bf9:	66 0f ef ed          	pxor   %xmm5,%xmm5
    4bfd:	f3 41 0f 5a 6f 44    	cvtss2sd 0x44(%r15),%xmm5
    4c03:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    4c07:	f2 0f 58 c5          	addsd  %xmm5,%xmm0
    4c0b:	66 0f 28 e8          	movapd %xmm0,%xmm5
    4c0f:	66 0f 54 2d 00 00 00 	andpd  0x0(%rip),%xmm5        # 4c17 <ayatsuri_model_instance_evaluate+0xfd7>
    4c16:	00 
			4c13: R_X86_64_PC32	.LC8-0x4
    4c17:	66 0f 2e f5          	ucomisd %xmm5,%xmm6
    4c1b:	0f 82 ff 0b 00 00    	jb     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    4c21:	66 0f 2f 2d 00 00 00 	comisd 0x0(%rip),%xmm5        # 4c29 <ayatsuri_model_instance_evaluate+0xfe9>
    4c28:	00 
			4c25: R_X86_64_PC32	.LC38-0x4
    4c29:	0f 83 f1 0b 00 00    	jae    5820 <ayatsuri_model_instance_evaluate+0x1be0>
    4c2f:	66 0f 2f 2d 00 00 00 	comisd 0x0(%rip),%xmm5        # 4c37 <ayatsuri_model_instance_evaluate+0xff7>
    4c36:	00 
			4c33: R_X86_64_PC32	.LC39-0x4
    4c37:	0f 86 c9 11 00 00    	jbe    5e06 <ayatsuri_model_instance_evaluate+0x21c6>
    4c3d:	66 0f ef ed          	pxor   %xmm5,%xmm5
    4c41:	66 0f 2f e8          	comisd %xmm0,%xmm5
    4c45:	0f 87 2c 15 00 00    	ja     6177 <ayatsuri_model_instance_evaluate+0x2537>
    4c4b:	41 0f 28 c6          	movaps %xmm14,%xmm0
    4c4f:	f3 0f 11 45 6c       	movss  %xmm0,0x6c(%rbp)
    4c54:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4c58:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 4c60 <ayatsuri_model_instance_evaluate+0x1020>
    4c5f:	00 
			4c5c: R_X86_64_PC32	.LC22-0x4
    4c60:	f3 0f 5a 84 24 d8 01 	cvtss2sd 0x1d8(%rsp),%xmm0
    4c67:	00 00 
    4c69:	f2 0f 59 c4          	mulsd  %xmm4,%xmm0
    4c6d:	66 0f ef e4          	pxor   %xmm4,%xmm4
    4c71:	f3 0f 5a a4 24 dc 01 	cvtss2sd 0x1dc(%rsp),%xmm4
    4c78:	00 00 
    4c7a:	f2 0f 59 dc          	mulsd  %xmm4,%xmm3
    4c7e:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    4c82:	66 0f ef db          	pxor   %xmm3,%xmm3
    4c86:	f3 0f 5a 9c 24 e0 01 	cvtss2sd 0x1e0(%rsp),%xmm3
    4c8d:	00 00 
    4c8f:	f2 0f 59 d3          	mulsd  %xmm3,%xmm2
    4c93:	f2 0f 58 c2          	addsd  %xmm2,%xmm0
    4c97:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    4c9b:	66 0f ef c9          	pxor   %xmm1,%xmm1
    4c9f:	f3 41 0f 5a 4f 48    	cvtss2sd 0x48(%r15),%xmm1
    4ca5:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    4ca9:	66 0f 28 c8          	movapd %xmm0,%xmm1
    4cad:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 4cb5 <ayatsuri_model_instance_evaluate+0x1075>
    4cb4:	00 
			4cb1: R_X86_64_PC32	.LC8-0x4
    4cb5:	66 0f 2e f1          	ucomisd %xmm1,%xmm6
    4cb9:	0f 82 61 0b 00 00    	jb     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    4cbf:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 4cc7 <ayatsuri_model_instance_evaluate+0x1087>
    4cc6:	00 
			4cc3: R_X86_64_PC32	.LC38-0x4
    4cc7:	0f 83 53 0b 00 00    	jae    5820 <ayatsuri_model_instance_evaluate+0x1be0>
    4ccd:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 4cd5 <ayatsuri_model_instance_evaluate+0x1095>
    4cd4:	00 
			4cd1: R_X86_64_PC32	.LC39-0x4
    4cd5:	0f 86 55 15 00 00    	jbe    6230 <ayatsuri_model_instance_evaluate+0x25f0>
    4cdb:	66 0f ef c9          	pxor   %xmm1,%xmm1
    4cdf:	66 0f 2f c8          	comisd %xmm0,%xmm1
    4ce3:	0f 87 3a 15 00 00    	ja     6223 <ayatsuri_model_instance_evaluate+0x25e3>
    4ce9:	41 0f 28 c6          	movaps %xmm14,%xmm0
    4ced:	41 0f b7 f9          	movzwl %r9w,%edi
    4cf1:	8b 44 24 30          	mov    0x30(%rsp),%eax
    4cf5:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
    4cfa:	48 6b ff 48          	imul   $0x48,%rdi,%rdi
    4cfe:	48 8b 0c 24          	mov    (%rsp),%rcx
    4d02:	f3 0f 11 45 7c       	movss  %xmm0,0x7c(%rbp)
    4d07:	4c 89 9c 24 90 00 00 	mov    %r11,0x90(%rsp)
    4d0e:	00 
    4d0f:	4c 89 54 24 70       	mov    %r10,0x70(%rsp)
    4d14:	48 01 f8             	add    %rdi,%rax
    4d17:	8b 7e 0c             	mov    0xc(%rsi),%edi
    4d1a:	48 89 54 24 68       	mov    %rdx,0x68(%rsp)
    4d1f:	48 01 c1             	add    %rax,%rcx
    4d22:	4c 89 44 24 60       	mov    %r8,0x60(%rsp)
    4d27:	48 89 0c 24          	mov    %rcx,(%rsp)
    4d2b:	e8 30 b4 ff ff       	call   160 <pack_rgb>
    4d30:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 4d38 <ayatsuri_model_instance_evaluate+0x10f8>
    4d37:	00 
			4d34: R_X86_64_PC32	.LC5-0x4
    4d38:	f2 0f 59 06          	mulsd  (%rsi),%xmm0
    4d3c:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 4d44 <ayatsuri_model_instance_evaluate+0x1104>
    4d43:	00 
			4d40: R_X86_64_PC32	.LC6-0x4
    4d44:	66 89 44 24 20       	mov    %ax,0x20(%rsp)
    4d49:	e8 00 00 00 00       	call   4d4e <ayatsuri_model_instance_evaluate+0x110e>
			4d4a: R_X86_64_PLT32	floor-0x4
    4d4e:	48 8b 0c 24          	mov    (%rsp),%rcx
    4d52:	f2 0f 11 44 24 50    	movsd  %xmm0,0x50(%rsp)
    4d58:	48 8d 79 30          	lea    0x30(%rcx),%rdi
    4d5c:	e8 9f b2 ff ff       	call   0 <md>
    4d61:	f2 0f 10 4c 24 40    	movsd  0x40(%rsp),%xmm1
    4d67:	f2 0f 11 44 24 30    	movsd  %xmm0,0x30(%rsp)
    4d6d:	f2 0f 10 44 24 38    	movsd  0x38(%rsp),%xmm0
    4d73:	e8 00 00 00 00       	call   4d78 <ayatsuri_model_instance_evaluate+0x1138>
			4d74: R_X86_64_PLT32	hypot-0x4
    4d78:	f2 0f 10 4c 24 48    	movsd  0x48(%rsp),%xmm1
    4d7e:	e8 00 00 00 00       	call   4d83 <ayatsuri_model_instance_evaluate+0x1143>
			4d7f: R_X86_64_PLT32	hypot-0x4
    4d83:	f2 0f 59 44 24 30    	mulsd  0x30(%rsp),%xmm0
    4d89:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 4d91 <ayatsuri_model_instance_evaluate+0x1151>
    4d90:	00 
			4d8d: R_X86_64_PC32	.LC9-0x4
    4d91:	e8 00 00 00 00       	call   4d96 <ayatsuri_model_instance_evaluate+0x1156>
			4d92: R_X86_64_PLT32	fmin-0x4
    4d96:	f2 0f 59 05 00 00 00 	mulsd  0x0(%rip),%xmm0        # 4d9e <ayatsuri_model_instance_evaluate+0x115e>
    4d9d:	00 
			4d9a: R_X86_64_PC32	.LC5-0x4
    4d9e:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 4da6 <ayatsuri_model_instance_evaluate+0x1166>
    4da5:	00 
			4da2: R_X86_64_PC32	.LC6-0x4
    4da6:	e8 00 00 00 00       	call   4dab <ayatsuri_model_instance_evaluate+0x116b>
			4da7: R_X86_64_PLT32	floor-0x4
    4dab:	f2 0f 10 54 24 50    	movsd  0x50(%rsp),%xmm2
    4db1:	48 8b 0c 24          	mov    (%rsp),%rcx
    4db5:	66 c7 85 f0 00 00 00 	movw   $0x0,0xf0(%rbp)
    4dbc:	00 00 
    4dbe:	48 c7 85 d4 00 00 00 	movq   $0x3f800000,0xd4(%rbp)
    4dc5:	00 00 80 3f 
    4dc9:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    4dcd:	0f 28 05 00 00 00 00 	movaps 0x0(%rip),%xmm0        # 4dd4 <ayatsuri_model_instance_evaluate+0x1194>
			4dd0: R_X86_64_PC32	.LC41-0x4
    4dd4:	f2 0f 2c f2          	cvttsd2si %xmm2,%esi
    4dd8:	48 8d 79 40          	lea    0x40(%rcx),%rdi
    4ddc:	0f 11 85 c4 00 00 00 	movups %xmm0,0xc4(%rbp)
    4de3:	0f b7 c0             	movzwl %ax,%eax
    4de6:	0f b7 f6             	movzwl %si,%esi
    4de9:	48 c1 e0 10          	shl    $0x10,%rax
    4ded:	48 09 f0             	or     %rsi,%rax
    4df0:	0f b7 74 24 20       	movzwl 0x20(%rsp),%esi
    4df5:	48 c1 e0 10          	shl    $0x10,%rax
    4df9:	48 09 f0             	or     %rsi,%rax
    4dfc:	48 c1 e0 10          	shl    $0x10,%rax
    4e00:	48 09 f0             	or     %rsi,%rax
    4e03:	48 89 85 e8 00 00 00 	mov    %rax,0xe8(%rbp)
    4e0a:	e8 f1 b1 ff ff       	call   0 <md>
    4e0f:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 4e17 <ayatsuri_model_instance_evaluate+0x11d7>
    4e16:	00 
			4e13: R_X86_64_PC32	.LC22-0x4
    4e17:	66 0f 28 c8          	movapd %xmm0,%xmm1
    4e1b:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 4e23 <ayatsuri_model_instance_evaluate+0x11e3>
    4e22:	00 
			4e1f: R_X86_64_PC32	.LC8-0x4
    4e23:	66 0f 2e f1          	ucomisd %xmm1,%xmm6
    4e27:	0f 82 f3 09 00 00    	jb     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    4e2d:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 4e35 <ayatsuri_model_instance_evaluate+0x11f5>
    4e34:	00 
			4e31: R_X86_64_PC32	.LC38-0x4
    4e35:	0f 83 e5 09 00 00    	jae    5820 <ayatsuri_model_instance_evaluate+0x1be0>
    4e3b:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 4e43 <ayatsuri_model_instance_evaluate+0x1203>
    4e42:	00 
			4e3f: R_X86_64_PC32	.LC39-0x4
    4e43:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
    4e48:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 4e51 <ayatsuri_model_instance_evaluate+0x1211>
    4e4f:	00 00 
			4e4d: R_X86_64_PC32	.LC0-0x4
    4e51:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
    4e56:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
    4e5b:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 4e64 <ayatsuri_model_instance_evaluate+0x1224>
    4e62:	00 00 
			4e60: R_X86_64_PC32	.LC1-0x4
    4e64:	4c 8b 54 24 70       	mov    0x70(%rsp),%r10
    4e69:	4c 8b 9c 24 90 00 00 	mov    0x90(%rsp),%r11
    4e70:	00 
    4e71:	0f 86 89 13 00 00    	jbe    6200 <ayatsuri_model_instance_evaluate+0x25c0>
    4e77:	66 0f ef c9          	pxor   %xmm1,%xmm1
    4e7b:	66 0f 2f c8          	comisd %xmm0,%xmm1
    4e7f:	0f 87 6e 13 00 00    	ja     61f3 <ayatsuri_model_instance_evaluate+0x25b3>
    4e85:	41 0f 28 c6          	movaps %xmm14,%xmm0
    4e89:	45 8b 4e 50          	mov    0x50(%r14),%r9d
    4e8d:	b8 7f 00 00 00       	mov    $0x7f,%eax
    4e92:	f3 0f 11 85 dc 00 00 	movss  %xmm0,0xdc(%rbp)
    4e99:	00 
    4e9a:	31 ff                	xor    %edi,%edi
    4e9c:	48 c1 e0 37          	shl    $0x37,%rax
    4ea0:	48 89 85 e0 00 00 00 	mov    %rax,0xe0(%rbp)
    4ea7:	44 89 0c 24          	mov    %r9d,(%rsp)
    4eab:	8b 04 24             	mov    (%rsp),%eax
    4eae:	39 c7                	cmp    %eax,%edi
    4eb0:	0f 84 1f 0a 00 00    	je     58d5 <ayatsuri_model_instance_evaluate+0x1c95>
    4eb6:	41 8b 76 4c          	mov    0x4c(%r14),%esi
    4eba:	89 f8                	mov    %edi,%eax
    4ebc:	44 8b 4c 24 18       	mov    0x18(%rsp),%r9d
    4ec1:	c1 e0 05             	shl    $0x5,%eax
    4ec4:	48 01 c6             	add    %rax,%rsi
    4ec7:	49 03 36             	add    (%r14),%rsi
    4eca:	0f b7 06             	movzwl (%rsi),%eax
    4ecd:	44 39 c8             	cmp    %r9d,%eax
    4ed0:	0f 84 c8 12 00 00    	je     619e <ayatsuri_model_instance_evaluate+0x255e>
    4ed6:	83 c7 01             	add    $0x1,%edi
    4ed9:	eb d0                	jmp    4eab <ayatsuri_model_instance_evaluate+0x126b>
    4edb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    4ee0:	8b 74 24 18          	mov    0x18(%rsp),%esi
    4ee4:	45 31 c9             	xor    %r9d,%r9d
    4ee7:	4c 89 ff             	mov    %r15,%rdi
    4eea:	4c 89 5c 24 20       	mov    %r11,0x20(%rsp)
    4eef:	48 8b 8c 24 78 01 00 	mov    0x178(%rsp),%rcx
    4ef6:	00 
    4ef7:	48 8b 94 24 80 01 00 	mov    0x180(%rsp),%rdx
    4efe:	00 
    4eff:	4c 8d 84 24 c8 01 00 	lea    0x1c8(%rsp),%r8
    4f06:	00 
    4f07:	4c 89 14 24          	mov    %r10,(%rsp)
    4f0b:	e8 f0 b8 ff ff       	call   800 <mesh_packet>
    4f10:	84 c0                	test   %al,%al
    4f12:	0f 84 08 09 00 00    	je     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    4f18:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    4f1e:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
    4f23:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 4f2c <ayatsuri_model_instance_evaluate+0x12ec>
    4f2a:	00 00 
			4f28: R_X86_64_PC32	.LC0-0x4
    4f2c:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 4f35 <ayatsuri_model_instance_evaluate+0x12f5>
    4f33:	00 00 
			4f31: R_X86_64_PC32	.LC1-0x4
    4f35:	4c 8b 14 24          	mov    (%rsp),%r10
    4f39:	e9 0b f7 ff ff       	jmp    4649 <ayatsuri_model_instance_evaluate+0xa09>
    4f3e:	66 90                	xchg   %ax,%ax
    4f40:	4d 8b 37             	mov    (%r15),%r14
    4f43:	49 8b 6f 08          	mov    0x8(%r15),%rbp
    4f47:	41 8b 46 14          	mov    0x14(%r14),%eax
    4f4b:	49 8b 3e             	mov    (%r14),%rdi
    4f4e:	48 01 c8             	add    %rcx,%rax
    4f51:	48 89 bc 24 b8 00 00 	mov    %rdi,0xb8(%rsp)
    4f58:	00 
    4f59:	4c 8d 0c 07          	lea    (%rdi,%rax,1),%r9
    4f5d:	41 8b 46 34          	mov    0x34(%r14),%eax
    4f61:	41 0f b7 79 06       	movzwl 0x6(%r9),%edi
    4f66:	41 0f b7 71 08       	movzwl 0x8(%r9),%esi
    4f6b:	89 84 24 8c 01 00 00 	mov    %eax,0x18c(%rsp)
    4f72:	48 8d 44 15 00       	lea    0x0(%rbp,%rdx,1),%rax
    4f77:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
    4f7e:	00 
    4f7f:	8b 40 08             	mov    0x8(%rax),%eax
    4f82:	48 01 c5             	add    %rax,%rbp
    4f85:	8d 04 7f             	lea    (%rdi,%rdi,2),%eax
    4f88:	8d 44 00 4f          	lea    0x4f(%rax,%rax,1),%eax
    4f8c:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
    4f93:	00 
    4f94:	31 c0                	xor    %eax,%eax
    4f96:	0f 10 4c 05 00       	movups 0x0(%rbp,%rax,1),%xmm1
    4f9b:	0f 5a c1             	cvtps2pd %xmm1,%xmm0
    4f9e:	0f 29 04 43          	movaps %xmm0,(%rbx,%rax,2)
    4fa2:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4fa6:	0f 12 c1             	movhlps %xmm1,%xmm0
    4fa9:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
    4fac:	0f 29 44 43 10       	movaps %xmm0,0x10(%rbx,%rax,2)
    4fb1:	48 83 c0 10          	add    $0x10,%rax
    4fb5:	48 83 f8 30          	cmp    $0x30,%rax
    4fb9:	75 db                	jne    4f96 <ayatsuri_model_instance_evaluate+0x1356>
    4fbb:	66 0f ef f6          	pxor   %xmm6,%xmm6
    4fbf:	f3 41 0f 5a 77 40    	cvtss2sd 0x40(%r15),%xmm6
    4fc5:	66 0f 28 fe          	movapd %xmm6,%xmm7
    4fc9:	f2 0f 11 74 24 20    	movsd  %xmm6,0x20(%rsp)
    4fcf:	f2 0f 10 b4 24 80 03 	movsd  0x380(%rsp),%xmm6
    4fd6:	00 00 
    4fd8:	66 0f 14 ff          	unpcklpd %xmm7,%xmm7
    4fdc:	0f 29 bc 24 c0 00 00 	movaps %xmm7,0xc0(%rsp)
    4fe3:	00 
    4fe4:	f2 0f 10 bc 24 40 03 	movsd  0x340(%rsp),%xmm7
    4feb:	00 00 
    4fed:	f2 0f 11 74 24 70    	movsd  %xmm6,0x70(%rsp)
    4ff3:	f2 0f 11 7c 24 60    	movsd  %xmm7,0x60(%rsp)
    4ff9:	f2 0f 10 bc 24 60 03 	movsd  0x360(%rsp),%xmm7
    5000:	00 00 
    5002:	f2 0f 11 7c 24 68    	movsd  %xmm7,0x68(%rsp)
    5008:	85 ff                	test   %edi,%edi
    500a:	0f 84 43 09 00 00    	je     5953 <ayatsuri_model_instance_evaluate+0x1d13>
    5010:	66 0f 28 b4 24 70 03 	movapd 0x370(%rsp),%xmm6
    5017:	00 00 
    5019:	41 8b 46 2c          	mov    0x2c(%r14),%eax
    501d:	c7 84 24 88 01 00 00 	movl   $0x0,0x188(%rsp)
    5024:	00 00 00 00 
    5028:	66 0f 28 bc 24 50 03 	movapd 0x350(%rsp),%xmm7
    502f:	00 00 
    5031:	48 89 8c 24 98 01 00 	mov    %rcx,0x198(%rsp)
    5038:	00 
    5039:	0f 29 b4 24 30 01 00 	movaps %xmm6,0x130(%rsp)
    5040:	00 
    5041:	66 0f 28 ac 24 30 03 	movapd 0x330(%rsp),%xmm5
    5048:	00 00 
    504a:	66 0f 17 b4 24 50 01 	movhpd %xmm6,0x150(%rsp)
    5051:	00 00 
    5053:	66 0f 13 b4 24 48 01 	movlpd %xmm6,0x148(%rsp)
    505a:	00 00 
    505c:	f2 0f 10 b4 24 48 03 	movsd  0x348(%rsp),%xmm6
    5063:	00 00 
    5065:	48 89 84 24 00 01 00 	mov    %rax,0x100(%rsp)
    506c:	00 
    506d:	48 8d 84 24 38 04 00 	lea    0x438(%rsp),%rax
    5074:	00 
    5075:	0f 29 bc 24 10 01 00 	movaps %xmm7,0x110(%rsp)
    507c:	00 
    507d:	66 0f 17 bc 24 40 01 	movhpd %xmm7,0x140(%rsp)
    5084:	00 00 
    5086:	66 0f 13 bc 24 28 01 	movlpd %xmm7,0x128(%rsp)
    508d:	00 00 
    508f:	f2 0f 10 bc 24 68 03 	movsd  0x368(%rsp),%xmm7
    5096:	00 00 
    5098:	f2 0f 11 b4 24 58 01 	movsd  %xmm6,0x158(%rsp)
    509f:	00 00 
    50a1:	f2 0f 10 b4 24 88 03 	movsd  0x388(%rsp),%xmm6
    50a8:	00 00 
    50aa:	48 89 84 24 70 01 00 	mov    %rax,0x170(%rsp)
    50b1:	00 
    50b2:	0f 29 ac 24 f0 00 00 	movaps %xmm5,0xf0(%rsp)
    50b9:	00 
    50ba:	66 0f 17 ac 24 20 01 	movhpd %xmm5,0x120(%rsp)
    50c1:	00 00 
    50c3:	66 0f 13 ac 24 08 01 	movlpd %xmm5,0x108(%rsp)
    50ca:	00 00 
    50cc:	f2 0f 11 bc 24 60 01 	movsd  %xmm7,0x160(%rsp)
    50d3:	00 00 
    50d5:	f2 0f 11 b4 24 68 01 	movsd  %xmm6,0x168(%rsp)
    50dc:	00 00 
    50de:	8b 9c 24 88 01 00 00 	mov    0x188(%rsp),%ebx
    50e5:	41 0f b7 41 04       	movzwl 0x4(%r9),%eax
    50ea:	66 0f ef d2          	pxor   %xmm2,%xmm2
    50ee:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    50f3:	f2 0f 10 44 24 60    	movsd  0x60(%rsp),%xmm0
    50f9:	f2 0f 10 6c 24 68    	movsd  0x68(%rsp),%xmm5
    50ff:	66 0f ef db          	pxor   %xmm3,%xmm3
    5103:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    5108:	f2 44 0f 10 ac 24 08 	movsd  0x108(%rsp),%xmm13
    510f:	01 00 00 
    5112:	01 d8                	add    %ebx,%eax
    5114:	48 8b 9c 24 00 01 00 	mov    0x100(%rsp),%rbx
    511b:	00 
    511c:	f2 0f 10 a4 24 20 01 	movsd  0x120(%rsp),%xmm4
    5123:	00 00 
    5125:	8d 04 40             	lea    (%rax,%rax,2),%eax
    5128:	66 44 0f 28 bc 24 30 	movapd 0x130(%rsp),%xmm15
    512f:	01 00 00 
    5132:	8d 04 c5 00 00 00 00 	lea    0x0(,%rax,8),%eax
    5139:	66 44 0f 28 8c 24 10 	movapd 0x110(%rsp),%xmm9
    5140:	01 00 00 
    5143:	48 01 d8             	add    %rbx,%rax
    5146:	48 8b 9c 24 b8 00 00 	mov    0xb8(%rsp),%rbx
    514d:	00 
    514e:	48 01 d8             	add    %rbx,%rax
    5151:	f3 0f 5a 50 14       	cvtss2sd 0x14(%rax),%xmm2
    5156:	f2 0f 59 ea          	mulsd  %xmm2,%xmm5
    515a:	f3 44 0f 5a 20       	cvtss2sd (%rax),%xmm12
    515f:	f3 0f 5a 58 04       	cvtss2sd 0x4(%rax),%xmm3
    5164:	f2 0f 59 c2          	mulsd  %xmm2,%xmm0
    5168:	f3 44 0f 5a 58 08    	cvtss2sd 0x8(%rax),%xmm11
    516e:	f3 44 0f 7e 40 0c    	movq   0xc(%rax),%xmm8
    5174:	f2 0f 59 54 24 70    	mulsd  0x70(%rsp),%xmm2
    517a:	f2 45 0f 59 ec       	mulsd  %xmm12,%xmm13
    517f:	45 0f 5a c0          	cvtps2pd %xmm8,%xmm8
    5183:	f2 0f 59 e3          	mulsd  %xmm3,%xmm4
    5187:	66 45 0f 59 f8       	mulpd  %xmm8,%xmm15
    518c:	66 45 0f 59 c8       	mulpd  %xmm8,%xmm9
    5191:	66 44 0f 59 84 24 f0 	mulpd  0xf0(%rsp),%xmm8
    5198:	00 00 00 
    519b:	f2 0f 11 14 24       	movsd  %xmm2,(%rsp)
    51a0:	f2 0f 10 54 24 60    	movsd  0x60(%rsp),%xmm2
    51a6:	f2 41 0f 59 d3       	mulsd  %xmm11,%xmm2
    51ab:	f2 41 0f 58 e5       	addsd  %xmm13,%xmm4
    51b0:	66 45 0f ef ed       	pxor   %xmm13,%xmm13
    51b5:	f3 45 0f 5a 6f 34    	cvtss2sd 0x34(%r15),%xmm13
    51bb:	66 44 0f 17 7c 24 38 	movhpd %xmm15,0x38(%rsp)
    51c2:	66 44 0f 17 4c 24 30 	movhpd %xmm9,0x30(%rsp)
    51c9:	66 41 0f 28 c9       	movapd %xmm9,%xmm1
    51ce:	66 41 0f 28 f8       	movapd %xmm8,%xmm7
    51d3:	66 0f 15 ff          	unpckhpd %xmm7,%xmm7
    51d7:	f2 0f 58 e2          	addsd  %xmm2,%xmm4
    51db:	f2 0f 10 54 24 68    	movsd  0x68(%rsp),%xmm2
    51e1:	66 0f 28 f7          	movapd %xmm7,%xmm6
    51e5:	f2 0f 58 a4 24 58 01 	addsd  0x158(%rsp),%xmm4
    51ec:	00 00 
    51ee:	66 41 0f 28 f8       	movapd %xmm8,%xmm7
    51f3:	f2 41 0f 59 d3       	mulsd  %xmm11,%xmm2
    51f8:	f2 41 0f 5c e5       	subsd  %xmm13,%xmm4
    51fd:	f2 44 0f 10 ac 24 28 	movsd  0x128(%rsp),%xmm13
    5204:	01 00 00 
    5207:	f2 45 0f 59 ec       	mulsd  %xmm12,%xmm13
    520c:	f2 44 0f 59 a4 24 48 	mulsd  0x148(%rsp),%xmm12
    5213:	01 00 00 
    5216:	f2 0f 11 64 24 48    	movsd  %xmm4,0x48(%rsp)
    521c:	f2 0f 10 a4 24 40 01 	movsd  0x140(%rsp),%xmm4
    5223:	00 00 
    5225:	f2 0f 59 e3          	mulsd  %xmm3,%xmm4
    5229:	f2 0f 59 9c 24 50 01 	mulsd  0x150(%rsp),%xmm3
    5230:	00 00 
    5232:	f2 41 0f 58 e5       	addsd  %xmm13,%xmm4
    5237:	66 45 0f ef ed       	pxor   %xmm13,%xmm13
    523c:	f3 45 0f 5a 6f 38    	cvtss2sd 0x38(%r15),%xmm13
    5242:	f2 41 0f 58 dc       	addsd  %xmm12,%xmm3
    5247:	f2 0f 58 e2          	addsd  %xmm2,%xmm4
    524b:	f2 0f 58 a4 24 60 01 	addsd  0x160(%rsp),%xmm4
    5252:	00 00 
    5254:	f2 41 0f 5c e5       	subsd  %xmm13,%xmm4
    5259:	f2 0f 11 64 24 50    	movsd  %xmm4,0x50(%rsp)
    525f:	f2 44 0f 59 5c 24 70 	mulsd  0x70(%rsp),%xmm11
    5266:	66 0f ef e4          	pxor   %xmm4,%xmm4
    526a:	f2 44 0f 10 6c 24 30 	movsd  0x30(%rsp),%xmm13
    5271:	f3 41 0f 5a 67 3c    	cvtss2sd 0x3c(%r15),%xmm4
    5277:	f2 0f 10 14 24       	movsd  (%rsp),%xmm2
    527c:	f2 44 0f 11 7c 24 40 	movsd  %xmm15,0x40(%rsp)
    5283:	f2 41 0f 58 db       	addsd  %xmm11,%xmm3
    5288:	f2 0f 58 9c 24 68 01 	addsd  0x168(%rsp),%xmm3
    528f:	00 00 
    5291:	f2 44 0f 10 1d 00 00 	movsd  0x0(%rip),%xmm11        # 529a <ayatsuri_model_instance_evaluate+0x165a>
    5298:	00 00 
			5296: R_X86_64_PC32	.LC22-0x4
    529a:	f2 0f 5c dc          	subsd  %xmm4,%xmm3
    529e:	66 41 0f 28 e5       	movapd %xmm13,%xmm4
    52a3:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    52a7:	f2 41 0f 59 d1       	mulsd  %xmm9,%xmm2
    52ac:	f2 0f 11 5c 24 58    	movsd  %xmm3,0x58(%rsp)
    52b2:	f2 0f 10 5c 24 38    	movsd  0x38(%rsp),%xmm3
    52b8:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    52bc:	66 44 0f 28 e4       	movapd %xmm4,%xmm12
    52c1:	f2 0f 10 64 24 38    	movsd  0x38(%rsp),%xmm4
    52c7:	f2 0f 11 94 24 98 00 	movsd  %xmm2,0x98(%rsp)
    52ce:	00 00 
    52d0:	f2 41 0f 59 e1       	mulsd  %xmm9,%xmm4
    52d5:	f2 44 0f 5c e3       	subsd  %xmm3,%xmm12
    52da:	66 41 0f 28 dd       	movapd %xmm13,%xmm3
    52df:	f2 41 0f 59 df       	mulsd  %xmm15,%xmm3
    52e4:	f2 44 0f 11 a4 24 90 	movsd  %xmm12,0x90(%rsp)
    52eb:	00 00 00 
    52ee:	66 45 0f 28 e7       	movapd %xmm15,%xmm12
    52f3:	66 44 0f 28 ec       	movapd %xmm4,%xmm13
    52f8:	f2 44 0f 59 e5       	mulsd  %xmm5,%xmm12
    52fd:	f2 44 0f 5c eb       	subsd  %xmm3,%xmm13
    5302:	f2 0f 10 9c 24 90 00 	movsd  0x90(%rsp),%xmm3
    5309:	00 00 
    530b:	f2 41 0f 59 d8       	mulsd  %xmm8,%xmm3
    5310:	f2 44 0f 11 ac 24 a8 	movsd  %xmm13,0xa8(%rsp)
    5317:	00 00 00 
    531a:	f2 41 0f 5c d4       	subsd  %xmm12,%xmm2
    531f:	f2 44 0f 59 e8       	mulsd  %xmm0,%xmm13
    5324:	f2 44 0f 11 a4 24 a0 	movsd  %xmm12,0xa0(%rsp)
    532b:	00 00 00 
    532e:	66 0f 28 e2          	movapd %xmm2,%xmm4
    5332:	f2 0f 59 e6          	mulsd  %xmm6,%xmm4
    5336:	f2 0f 5c dc          	subsd  %xmm4,%xmm3
    533a:	f2 41 0f 58 dd       	addsd  %xmm13,%xmm3
    533f:	66 44 0f 28 eb       	movapd %xmm3,%xmm13
    5344:	66 0f 54 1d 00 00 00 	andpd  0x0(%rip),%xmm3        # 534c <ayatsuri_model_instance_evaluate+0x170c>
    534b:	00 
			5348: R_X86_64_PC32	.LC8-0x4
    534c:	66 44 0f 2e db       	ucomisd %xmm3,%xmm11
    5351:	0f 82 c9 04 00 00    	jb     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    5357:	f2 44 0f 10 1d 00 00 	movsd  0x0(%rip),%xmm11        # 5360 <ayatsuri_model_instance_evaluate+0x1720>
    535e:	00 00 
			535c: R_X86_64_PC32	.LC40-0x4
    5360:	66 44 0f 2f db       	comisd %xmm3,%xmm11
    5365:	0f 87 b5 04 00 00    	ja     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    536b:	66 0f ef d2          	pxor   %xmm2,%xmm2
    536f:	66 0f ef e4          	pxor   %xmm4,%xmm4
    5373:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    5378:	4c 89 e8             	mov    %r13,%rax
    537b:	f3 0f 5a 94 24 e4 01 	cvtss2sd 0x1e4(%rsp),%xmm2
    5382:	00 00 
    5384:	66 0f 28 da          	movapd %xmm2,%xmm3
    5388:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    538d:	f3 0f 5a a4 24 e8 01 	cvtss2sd 0x1e8(%rsp),%xmm4
    5394:	00 00 
    5396:	66 0f 14 db          	unpcklpd %xmm3,%xmm3
    539a:	b9 f8 ff ff ff       	mov    $0xfffffff8,%ecx
    539f:	f3 44 0f 5a a4 24 ec 	cvtss2sd 0x1ec(%rsp),%xmm12
    53a6:	01 00 00 
    53a9:	f2 0f 11 94 24 b0 00 	movsd  %xmm2,0xb0(%rsp)
    53b0:	00 00 
    53b2:	f3 44 0f 5a 9c 24 d8 	cvtss2sd 0x1d8(%rsp),%xmm11
    53b9:	01 00 00 
    53bc:	66 44 0f 59 c3       	mulpd  %xmm3,%xmm8
    53c1:	66 0f 28 dc          	movapd %xmm4,%xmm3
    53c5:	66 0f 14 db          	unpcklpd %xmm3,%xmm3
    53c9:	66 41 0f 59 d9       	mulpd  %xmm9,%xmm3
    53ce:	66 44 0f 28 cd       	movapd %xmm5,%xmm9
    53d3:	f2 44 0f 59 cc       	mulsd  %xmm4,%xmm9
    53d8:	f2 0f 59 64 24 50    	mulsd  0x50(%rsp),%xmm4
    53de:	66 41 0f 58 d8       	addpd  %xmm8,%xmm3
    53e3:	66 45 0f 28 c4       	movapd %xmm12,%xmm8
    53e8:	66 45 0f 14 c0       	unpcklpd %xmm8,%xmm8
    53ed:	66 45 0f 59 c7       	mulpd  %xmm15,%xmm8
    53f2:	f2 44 0f 10 7c 24 48 	movsd  0x48(%rsp),%xmm15
    53f9:	f2 45 0f 59 fb       	mulsd  %xmm11,%xmm15
    53fe:	66 41 0f 58 d8       	addpd  %xmm8,%xmm3
    5403:	66 44 0f 28 c2       	movapd %xmm2,%xmm8
    5408:	f2 0f 10 54 24 20    	movsd  0x20(%rsp),%xmm2
    540e:	66 0f 59 9c 24 c0 00 	mulpd  0xc0(%rsp),%xmm3
    5415:	00 00 
    5417:	f2 44 0f 59 c0       	mulsd  %xmm0,%xmm8
    541c:	0f 29 9c 24 90 03 00 	movaps %xmm3,0x390(%rsp)
    5423:	00 
    5424:	66 41 0f 28 d9       	movapd %xmm9,%xmm3
    5429:	66 45 0f ef c9       	pxor   %xmm9,%xmm9
    542e:	f3 44 0f 5a 8c 24 e0 	cvtss2sd 0x1e0(%rsp),%xmm9
    5435:	01 00 00 
    5438:	f2 41 0f 58 d8       	addsd  %xmm8,%xmm3
    543d:	f2 44 0f 10 04 24    	movsd  (%rsp),%xmm8
    5443:	f2 45 0f 59 c4       	mulsd  %xmm12,%xmm8
    5448:	f2 44 0f 59 64 24 58 	mulsd  0x58(%rsp),%xmm12
    544f:	f2 41 0f 58 d8       	addsd  %xmm8,%xmm3
    5454:	f2 44 0f 10 44 24 50 	movsd  0x50(%rsp),%xmm8
    545b:	f2 0f 59 da          	mulsd  %xmm2,%xmm3
    545f:	f2 0f 11 9c 24 a0 03 	movsd  %xmm3,0x3a0(%rsp)
    5466:	00 00 
    5468:	66 0f ef db          	pxor   %xmm3,%xmm3
    546c:	f3 0f 5a 9c 24 dc 01 	cvtss2sd 0x1dc(%rsp),%xmm3
    5473:	00 00 
    5475:	f2 44 0f 59 c3       	mulsd  %xmm3,%xmm8
    547a:	f2 45 0f 58 c7       	addsd  %xmm15,%xmm8
    547f:	f2 44 0f 10 7c 24 58 	movsd  0x58(%rsp),%xmm15
    5486:	f2 45 0f 59 f9       	mulsd  %xmm9,%xmm15
    548b:	f2 45 0f 58 c7       	addsd  %xmm15,%xmm8
    5490:	66 45 0f ef ff       	pxor   %xmm15,%xmm15
    5495:	f3 45 0f 5a 7f 48    	cvtss2sd 0x48(%r15),%xmm15
    549b:	f2 44 0f 59 c2       	mulsd  %xmm2,%xmm8
    54a0:	f2 45 0f 58 c7       	addsd  %xmm15,%xmm8
    54a5:	f2 44 0f 10 bc 24 90 	movsd  0x90(%rsp),%xmm15
    54ac:	00 00 00 
    54af:	f2 45 0f 5e fd       	divsd  %xmm13,%xmm15
    54b4:	66 41 0f 28 d0       	movapd %xmm8,%xmm2
    54b9:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    54be:	f3 44 0f 5a 84 24 cc 	cvtss2sd 0x1cc(%rsp),%xmm8
    54c5:	01 00 00 
    54c8:	f2 44 0f 11 84 24 90 	movsd  %xmm8,0x90(%rsp)
    54cf:	00 00 00 
    54d2:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    54d7:	f3 44 0f 5a 84 24 d0 	cvtss2sd 0x1d0(%rsp),%xmm8
    54de:	01 00 00 
    54e1:	f2 44 0f 11 84 24 d8 	movsd  %xmm8,0xd8(%rsp)
    54e8:	00 00 00 
    54eb:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    54f0:	f3 45 0f 5a 47 44    	cvtss2sd 0x44(%r15),%xmm8
    54f6:	66 41 0f 14 d7       	unpcklpd %xmm15,%xmm2
    54fb:	66 45 0f ef ff       	pxor   %xmm15,%xmm15
    5500:	0f 29 94 24 e0 00 00 	movaps %xmm2,0xe0(%rsp)
    5507:	00 
    5508:	f2 0f 10 94 24 b0 00 	movsd  0xb0(%rsp),%xmm2
    550f:	00 00 
    5511:	f2 0f 59 54 24 48    	mulsd  0x48(%rsp),%xmm2
    5517:	f3 44 0f 5a bc 24 c8 	cvtss2sd 0x1c8(%rsp),%xmm15
    551e:	01 00 00 
    5521:	f2 0f 58 e2          	addsd  %xmm2,%xmm4
    5525:	f2 0f 10 54 24 20    	movsd  0x20(%rsp),%xmm2
    552b:	f2 41 0f 58 e4       	addsd  %xmm12,%xmm4
    5530:	66 44 0f 28 e7       	movapd %xmm7,%xmm12
    5535:	f2 45 0f 59 e3       	mulsd  %xmm11,%xmm12
    553a:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    553e:	f2 44 0f 58 c4       	addsd  %xmm4,%xmm8
    5543:	66 0f 28 e3          	movapd %xmm3,%xmm4
    5547:	f2 0f 59 e1          	mulsd  %xmm1,%xmm4
    554b:	f2 41 0f 58 e4       	addsd  %xmm12,%xmm4
    5550:	f2 44 0f 10 64 24 40 	movsd  0x40(%rsp),%xmm12
    5557:	f2 45 0f 59 e1       	mulsd  %xmm9,%xmm12
    555c:	f2 41 0f 58 e4       	addsd  %xmm12,%xmm4
    5561:	f2 44 0f 10 64 24 30 	movsd  0x30(%rsp),%xmm12
    5568:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    556c:	66 44 0f 14 c4       	unpcklpd %xmm4,%xmm8
    5571:	66 0f 28 e6          	movapd %xmm6,%xmm4
    5575:	44 0f 11 84 24 a8 03 	movups %xmm8,0x3a8(%rsp)
    557c:	00 00 
    557e:	f2 41 0f 59 e3       	mulsd  %xmm11,%xmm4
    5583:	f2 44 0f 59 d8       	mulsd  %xmm0,%xmm11
    5588:	66 44 0f 28 c4       	movapd %xmm4,%xmm8
    558d:	66 41 0f 28 e4       	movapd %xmm12,%xmm4
    5592:	f2 0f 59 e3          	mulsd  %xmm3,%xmm4
    5596:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    559a:	f2 41 0f 58 e0       	addsd  %xmm8,%xmm4
    559f:	f2 44 0f 10 44 24 38 	movsd  0x38(%rsp),%xmm8
    55a6:	48 8b 9c 24 d0 00 00 	mov    0xd0(%rsp),%rbx
    55ad:	00 
    55ae:	f2 41 0f 58 db       	addsd  %xmm11,%xmm3
    55b3:	f2 44 0f 10 5c 24 38 	movsd  0x38(%rsp),%xmm11
    55ba:	f2 45 0f 59 c1       	mulsd  %xmm9,%xmm8
    55bf:	48 8d 5c 9d 00       	lea    0x0(%rbp,%rbx,4),%rbx
    55c4:	f2 41 0f 58 e0       	addsd  %xmm8,%xmm4
    55c9:	66 44 0f 28 c2       	movapd %xmm2,%xmm8
    55ce:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    55d2:	f2 0f 10 14 24       	movsd  (%rsp),%xmm2
    55d7:	f2 44 0f 59 ca       	mulsd  %xmm2,%xmm9
    55dc:	f2 41 0f 58 d9       	addsd  %xmm9,%xmm3
    55e1:	f2 44 0f 10 4c 24 40 	movsd  0x40(%rsp),%xmm9
    55e8:	f2 41 0f 59 d8       	mulsd  %xmm8,%xmm3
    55ed:	66 0f 14 e3          	unpcklpd %xmm3,%xmm4
    55f1:	f2 0f 10 9c 24 a0 00 	movsd  0xa0(%rsp),%xmm3
    55f8:	00 00 
    55fa:	f2 0f 5c 9c 24 98 00 	subsd  0x98(%rsp),%xmm3
    5601:	00 00 
    5603:	0f 11 a4 24 b8 03 00 	movups %xmm4,0x3b8(%rsp)
    560a:	00 
    560b:	66 0f 28 a4 24 e0 00 	movapd 0xe0(%rsp),%xmm4
    5612:	00 00 
    5614:	0f 11 a4 24 c8 03 00 	movups %xmm4,0x3c8(%rsp)
    561b:	00 
    561c:	f2 41 0f 5e dd       	divsd  %xmm13,%xmm3
    5621:	f2 0f 10 a4 24 a8 00 	movsd  0xa8(%rsp),%xmm4
    5628:	00 00 
    562a:	f2 41 0f 5e e5       	divsd  %xmm13,%xmm4
    562f:	66 0f 14 dc          	unpcklpd %xmm4,%xmm3
    5633:	66 0f 28 e6          	movapd %xmm6,%xmm4
    5637:	0f 11 9c 24 d8 03 00 	movups %xmm3,0x3d8(%rsp)
    563e:	00 
    563f:	66 41 0f 28 db       	movapd %xmm11,%xmm3
    5644:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    5648:	f2 0f 59 d8          	mulsd  %xmm0,%xmm3
    564c:	f2 0f 5c dc          	subsd  %xmm4,%xmm3
    5650:	66 0f 28 e7          	movapd %xmm7,%xmm4
    5654:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    5658:	f2 0f 10 94 24 90 00 	movsd  0x90(%rsp),%xmm2
    565f:	00 00 
    5661:	f2 41 0f 5e dd       	divsd  %xmm13,%xmm3
    5666:	66 44 0f 28 c4       	movapd %xmm4,%xmm8
    566b:	66 41 0f 28 e1       	movapd %xmm9,%xmm4
    5670:	f2 0f 59 e0          	mulsd  %xmm0,%xmm4
    5674:	f2 44 0f 5c c4       	subsd  %xmm4,%xmm8
    5679:	66 41 0f 28 e3       	movapd %xmm11,%xmm4
    567e:	f2 0f 59 e7          	mulsd  %xmm7,%xmm4
    5682:	f2 45 0f 5e c5       	divsd  %xmm13,%xmm8
    5687:	66 41 0f 14 d8       	unpcklpd %xmm8,%xmm3
    568c:	0f 11 9c 24 e8 03 00 	movups %xmm3,0x3e8(%rsp)
    5693:	00 
    5694:	66 41 0f 28 d9       	movapd %xmm9,%xmm3
    5699:	f2 0f 59 de          	mulsd  %xmm6,%xmm3
    569d:	f2 0f 5c dc          	subsd  %xmm4,%xmm3
    56a1:	66 0f 28 e6          	movapd %xmm6,%xmm4
    56a5:	f2 0f 59 e5          	mulsd  %xmm5,%xmm4
    56a9:	f2 41 0f 5e dd       	divsd  %xmm13,%xmm3
    56ae:	66 44 0f 28 c4       	movapd %xmm4,%xmm8
    56b3:	66 41 0f 28 e4       	movapd %xmm12,%xmm4
    56b8:	f2 0f 59 e0          	mulsd  %xmm0,%xmm4
    56bc:	f2 44 0f 5c c4       	subsd  %xmm4,%xmm8
    56c1:	66 0f 28 e0          	movapd %xmm0,%xmm4
    56c5:	f2 0f 59 e1          	mulsd  %xmm1,%xmm4
    56c9:	f2 41 0f 59 c7       	mulsd  %xmm15,%xmm0
    56ce:	f2 45 0f 5e c5       	divsd  %xmm13,%xmm8
    56d3:	66 41 0f 14 d8       	unpcklpd %xmm8,%xmm3
    56d8:	66 44 0f 28 c4       	movapd %xmm4,%xmm8
    56dd:	66 41 0f 28 e4       	movapd %xmm12,%xmm4
    56e2:	0f 11 9c 24 f8 03 00 	movups %xmm3,0x3f8(%rsp)
    56e9:	00 
    56ea:	f2 0f 59 e7          	mulsd  %xmm7,%xmm4
    56ee:	66 0f 28 df          	movapd %xmm7,%xmm3
    56f2:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    56f6:	f2 41 0f 59 ff       	mulsd  %xmm15,%xmm7
    56fb:	f2 44 0f 59 e2       	mulsd  %xmm2,%xmm12
    5700:	f2 0f 59 ea          	mulsd  %xmm2,%xmm5
    5704:	f2 44 0f 5c c3       	subsd  %xmm3,%xmm8
    5709:	66 0f 28 de          	movapd %xmm6,%xmm3
    570d:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
    5711:	f2 0f 59 ca          	mulsd  %xmm2,%xmm1
    5715:	f2 45 0f 5e c5       	divsd  %xmm13,%xmm8
    571a:	f2 0f 58 c5          	addsd  %xmm5,%xmm0
    571e:	f2 41 0f 59 f7       	mulsd  %xmm15,%xmm6
    5723:	f2 0f 5c e3          	subsd  %xmm3,%xmm4
    5727:	f2 0f 58 cf          	addsd  %xmm7,%xmm1
    572b:	66 0f 28 fa          	movapd %xmm2,%xmm7
    572f:	f2 0f 10 14 24       	movsd  (%rsp),%xmm2
    5734:	48 89 14 24          	mov    %rdx,(%rsp)
    5738:	f2 41 0f 5e e5       	divsd  %xmm13,%xmm4
    573d:	66 41 0f 28 d8       	movapd %xmm8,%xmm3
    5742:	66 0f 14 dc          	unpcklpd %xmm4,%xmm3
    5746:	66 41 0f 28 e3       	movapd %xmm11,%xmm4
    574b:	0f 11 9c 24 08 04 00 	movups %xmm3,0x408(%rsp)
    5752:	00 
    5753:	66 41 0f 28 d9       	movapd %xmm9,%xmm3
    5758:	f2 44 0f 10 8c 24 d8 	movsd  0xd8(%rsp),%xmm9
    575f:	00 00 00 
    5762:	f2 41 0f 59 d9       	mulsd  %xmm9,%xmm3
    5767:	f2 41 0f 59 e1       	mulsd  %xmm9,%xmm4
    576c:	f2 41 0f 59 d1       	mulsd  %xmm9,%xmm2
    5771:	f2 0f 58 cb          	addsd  %xmm3,%xmm1
    5775:	66 41 0f 28 dc       	movapd %xmm12,%xmm3
    577a:	f2 0f 58 de          	addsd  %xmm6,%xmm3
    577e:	f2 0f 58 c2          	addsd  %xmm2,%xmm0
    5782:	f2 0f 58 dc          	addsd  %xmm4,%xmm3
    5786:	f2 0f 11 84 24 28 04 	movsd  %xmm0,0x428(%rsp)
    578d:	00 00 
    578f:	f2 0f 10 44 24 48    	movsd  0x48(%rsp),%xmm0
    5795:	f2 41 0f 59 c7       	mulsd  %xmm15,%xmm0
    579a:	66 0f 14 cb          	unpcklpd %xmm3,%xmm1
    579e:	0f 11 8c 24 18 04 00 	movups %xmm1,0x418(%rsp)
    57a5:	00 
    57a6:	f2 0f 10 4c 24 50    	movsd  0x50(%rsp),%xmm1
    57ac:	f2 0f 59 cf          	mulsd  %xmm7,%xmm1
    57b0:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    57b4:	f2 0f 10 4c 24 58    	movsd  0x58(%rsp),%xmm1
    57ba:	f2 41 0f 59 c9       	mulsd  %xmm9,%xmm1
    57bf:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    57c3:	f2 0f 11 84 24 30 04 	movsd  %xmm0,0x430(%rsp)
    57ca:	00 00 
    57cc:	f2 0f 10 08          	movsd  (%rax),%xmm1
    57d0:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 57d8 <ayatsuri_model_instance_evaluate+0x1b98>
    57d7:	00 
			57d4: R_X86_64_PC32	.LC22-0x4
    57d8:	66 0f 28 c1          	movapd %xmm1,%xmm0
    57dc:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 57e4 <ayatsuri_model_instance_evaluate+0x1ba4>
    57e3:	00 
			57e0: R_X86_64_PC32	.LC8-0x4
    57e4:	66 0f 2e e8          	ucomisd %xmm0,%xmm5
    57e8:	72 36                	jb     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    57ea:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 57f2 <ayatsuri_model_instance_evaluate+0x1bb2>
    57f1:	00 
			57ee: R_X86_64_PC32	.LC38-0x4
    57f2:	73 2c                	jae    5820 <ayatsuri_model_instance_evaluate+0x1be0>
    57f4:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 57fc <ayatsuri_model_instance_evaluate+0x1bbc>
    57fb:	00 
			57f8: R_X86_64_PC32	.LC39-0x4
    57fc:	0f 86 de 00 00 00    	jbe    58e0 <ayatsuri_model_instance_evaluate+0x1ca0>
    5802:	66 0f ef d2          	pxor   %xmm2,%xmm2
    5806:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 580e <ayatsuri_model_instance_evaluate+0x1bce>
    580d:	00 
			580a: R_X86_64_PC32	.LC33-0x4
    580e:	66 0f 2f d1          	comisd %xmm1,%xmm2
    5812:	77 04                	ja     5818 <ayatsuri_model_instance_evaluate+0x1bd8>
    5814:	41 0f 28 c6          	movaps %xmm14,%xmm0
    5818:	f3 0f 11 03          	movss  %xmm0,(%rbx)
    581c:	0f 1f 40 00          	nopl   0x0(%rax)
    5820:	41 c6 87 a5 00 00 00 	movb   $0x0,0xa5(%r15)
    5827:	00 
    5828:	b8 02 00 00 00       	mov    $0x2,%eax
    582d:	e9 5d e5 ff ff       	jmp    3d8f <ayatsuri_model_instance_evaluate+0x14f>
    5832:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    5838:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    583d:	0f 29 ac 24 90 03 00 	movaps %xmm5,0x390(%rsp)
    5844:	00 
    5845:	4c 8d ac 24 90 03 00 	lea    0x390(%rsp),%r13
    584c:	00 
    584d:	f3 44 0f 5a 9c 24 6c 	cvtss2sd 0x26c(%rsp),%xmm11
    5854:	02 00 00 
    5857:	f2 41 0f 59 f4       	mulsd  %xmm12,%xmm6
    585c:	f2 0f 11 9c 24 a0 03 	movsd  %xmm3,0x3a0(%rsp)
    5863:	00 00 
    5865:	f2 44 0f 11 8c 24 e8 	movsd  %xmm9,0x3e8(%rsp)
    586c:	03 00 00 
    586f:	f2 45 0f 59 eb       	mulsd  %xmm11,%xmm13
    5874:	f2 44 0f 59 e4       	mulsd  %xmm4,%xmm12
    5879:	f2 44 0f 59 d8       	mulsd  %xmm0,%xmm11
    587e:	66 0f 14 fe          	unpcklpd %xmm6,%xmm7
    5882:	66 44 0f 14 e9       	unpcklpd %xmm1,%xmm13
    5887:	0f 11 bc 24 a8 03 00 	movups %xmm7,0x3a8(%rsp)
    588e:	00 
    588f:	44 0f 11 ac 24 b8 03 	movups %xmm13,0x3b8(%rsp)
    5896:	00 00 
    5898:	66 45 0f 14 c4       	unpcklpd %xmm12,%xmm8
    589d:	44 0f 11 84 24 c8 03 	movups %xmm8,0x3c8(%rsp)
    58a4:	00 00 
    58a6:	66 44 0f 14 da       	unpcklpd %xmm2,%xmm11
    58ab:	44 0f 11 9c 24 d8 03 	movups %xmm11,0x3d8(%rsp)
    58b2:	00 00 
    58b4:	e9 45 ec ff ff       	jmp    44fe <ayatsuri_model_instance_evaluate+0x8be>
    58b9:	41 c6 87 a5 00 00 00 	movb   $0x0,0xa5(%r15)
    58c0:	00 
    58c1:	e9 c4 e4 ff ff       	jmp    3d8a <ayatsuri_model_instance_evaluate+0x14a>
    58c6:	41 c6 87 a5 00 00 00 	movb   $0x0,0xa5(%r15)
    58cd:	00 
    58ce:	31 c0                	xor    %eax,%eax
    58d0:	e9 ba e4 ff ff       	jmp    3d8f <ayatsuri_model_instance_evaluate+0x14f>
    58d5:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    58db:	e9 55 ed ff ff       	jmp    4635 <ayatsuri_model_instance_evaluate+0x9f5>
    58e0:	f2 0f 5a c9          	cvtsd2ss %xmm1,%xmm1
    58e4:	f3 0f 11 0b          	movss  %xmm1,(%rbx)
    58e8:	41 0f 54 ca          	andps  %xmm10,%xmm1
    58ec:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
    58f0:	83 f9 08             	cmp    $0x8,%ecx
    58f3:	0f 86 8b 08 00 00    	jbe    6184 <ayatsuri_model_instance_evaluate+0x2544>
    58f9:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 5901 <ayatsuri_model_instance_evaluate+0x1cc1>
    5900:	00 
			58fd: R_X86_64_PC32	.LC35-0x4
    5901:	66 0f 2f c8          	comisd %xmm0,%xmm1
    5905:	0f 87 15 ff ff ff    	ja     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    590b:	48 8b 94 24 70 01 00 	mov    0x170(%rsp),%rdx
    5912:	00 
    5913:	48 83 c0 08          	add    $0x8,%rax
    5917:	48 83 c3 04          	add    $0x4,%rbx
    591b:	83 c1 01             	add    $0x1,%ecx
    591e:	48 39 d0             	cmp    %rdx,%rax
    5921:	0f 85 a5 fe ff ff    	jne    57cc <ayatsuri_model_instance_evaluate+0x1b8c>
    5927:	83 84 24 88 01 00 00 	addl   $0x1,0x188(%rsp)
    592e:	01 
    592f:	8b 84 24 88 01 00 00 	mov    0x188(%rsp),%eax
    5936:	48 83 84 24 d0 00 00 	addq   $0x15,0xd0(%rsp)
    593d:	00 15 
    593f:	48 8b 14 24          	mov    (%rsp),%rdx
    5943:	39 c7                	cmp    %eax,%edi
    5945:	0f 85 93 f7 ff ff    	jne    50de <ayatsuri_model_instance_evaluate+0x149e>
    594b:	48 8b 8c 24 98 01 00 	mov    0x198(%rsp),%rcx
    5952:	00 
    5953:	0f b7 c6             	movzwl %si,%eax
    5956:	8b b4 24 8c 01 00 00 	mov    0x18c(%rsp),%esi
    595d:	4c 89 5c 24 40       	mov    %r11,0x40(%rsp)
    5962:	48 6b c0 48          	imul   $0x48,%rax,%rax
    5966:	48 8b 9c 24 b8 00 00 	mov    0xb8(%rsp),%rbx
    596d:	00 
    596e:	4c 89 54 24 38       	mov    %r10,0x38(%rsp)
    5973:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
    5978:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
    597d:	48 01 f0             	add    %rsi,%rax
    5980:	48 01 c3             	add    %rax,%rbx
    5983:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
    598a:	00 
    598b:	8b 78 0c             	mov    0xc(%rax),%edi
    598e:	e8 cd a7 ff ff       	call   160 <pack_rgb>
    5993:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 599b <ayatsuri_model_instance_evaluate+0x1d5b>
    599a:	00 
			5997: R_X86_64_PC32	.LC5-0x4
    599b:	66 89 85 fc 00 00 00 	mov    %ax,0xfc(%rbp)
    59a2:	49 8b 47 08          	mov    0x8(%r15),%rax
    59a6:	f2 42 0f 59 04 c0    	mulsd  (%rax,%r8,8),%xmm0
    59ac:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 59b4 <ayatsuri_model_instance_evaluate+0x1d74>
    59b3:	00 
			59b0: R_X86_64_PC32	.LC6-0x4
    59b4:	e8 00 00 00 00       	call   59b9 <ayatsuri_model_instance_evaluate+0x1d79>
			59b5: R_X86_64_PLT32	floor-0x4
    59b9:	48 8d 7b 30          	lea    0x30(%rbx),%rdi
    59bd:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    59c1:	66 89 85 fe 00 00 00 	mov    %ax,0xfe(%rbp)
    59c8:	e8 33 a6 ff ff       	call   0 <md>
    59cd:	f2 0f 10 4c 24 68    	movsd  0x68(%rsp),%xmm1
    59d3:	f2 0f 11 04 24       	movsd  %xmm0,(%rsp)
    59d8:	f2 0f 10 44 24 60    	movsd  0x60(%rsp),%xmm0
    59de:	e8 00 00 00 00       	call   59e3 <ayatsuri_model_instance_evaluate+0x1da3>
			59df: R_X86_64_PLT32	hypot-0x4
    59e3:	f2 0f 10 4c 24 70    	movsd  0x70(%rsp),%xmm1
    59e9:	e8 00 00 00 00       	call   59ee <ayatsuri_model_instance_evaluate+0x1dae>
			59ea: R_X86_64_PLT32	hypot-0x4
    59ee:	f2 0f 59 04 24       	mulsd  (%rsp),%xmm0
    59f3:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 59fb <ayatsuri_model_instance_evaluate+0x1dbb>
    59fa:	00 
			59f7: R_X86_64_PC32	.LC9-0x4
    59fb:	e8 00 00 00 00       	call   5a00 <ayatsuri_model_instance_evaluate+0x1dc0>
			59fc: R_X86_64_PLT32	fmin-0x4
    5a00:	f2 0f 59 05 00 00 00 	mulsd  0x0(%rip),%xmm0        # 5a08 <ayatsuri_model_instance_evaluate+0x1dc8>
    5a07:	00 
			5a04: R_X86_64_PC32	.LC5-0x4
    5a08:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 5a10 <ayatsuri_model_instance_evaluate+0x1dd0>
    5a0f:	00 
			5a0c: R_X86_64_PC32	.LC6-0x4
    5a10:	e8 00 00 00 00       	call   5a15 <ayatsuri_model_instance_evaluate+0x1dd5>
			5a11: R_X86_64_PLT32	floor-0x4
    5a15:	48 8d 7b 40          	lea    0x40(%rbx),%rdi
    5a19:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    5a1d:	66 89 85 00 01 00 00 	mov    %ax,0x100(%rbp)
    5a24:	e8 d7 a5 ff ff       	call   0 <md>
    5a29:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 5a31 <ayatsuri_model_instance_evaluate+0x1df1>
    5a30:	00 
			5a2d: R_X86_64_PC32	.LC22-0x4
    5a31:	66 0f 28 c8          	movapd %xmm0,%xmm1
    5a35:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 5a3d <ayatsuri_model_instance_evaluate+0x1dfd>
    5a3c:	00 
			5a39: R_X86_64_PC32	.LC8-0x4
    5a3d:	66 0f 2e f1          	ucomisd %xmm1,%xmm6
    5a41:	0f 82 d9 fd ff ff    	jb     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    5a47:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 5a4f <ayatsuri_model_instance_evaluate+0x1e0f>
    5a4e:	00 
			5a4b: R_X86_64_PC32	.LC38-0x4
    5a4f:	0f 83 cb fd ff ff    	jae    5820 <ayatsuri_model_instance_evaluate+0x1be0>
    5a55:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 5a5d <ayatsuri_model_instance_evaluate+0x1e1d>
    5a5c:	00 
			5a59: R_X86_64_PC32	.LC39-0x4
    5a5d:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    5a62:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 5a6b <ayatsuri_model_instance_evaluate+0x1e2b>
    5a69:	00 00 
			5a67: R_X86_64_PC32	.LC0-0x4
    5a6b:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
    5a70:	4c 8b 54 24 38       	mov    0x38(%rsp),%r10
    5a75:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 5a7e <ayatsuri_model_instance_evaluate+0x1e3e>
    5a7c:	00 00 
			5a7a: R_X86_64_PC32	.LC1-0x4
    5a7e:	4c 8b 5c 24 40       	mov    0x40(%rsp),%r11
    5a83:	0f 86 86 03 00 00    	jbe    5e0f <ayatsuri_model_instance_evaluate+0x21cf>
    5a89:	66 0f ef c9          	pxor   %xmm1,%xmm1
    5a8d:	66 0f 2f c8          	comisd %xmm0,%xmm1
    5a91:	0f 87 fa 06 00 00    	ja     6191 <ayatsuri_model_instance_evaluate+0x2551>
    5a97:	41 0f 28 c6          	movaps %xmm14,%xmm0
    5a9b:	45 8b 46 50          	mov    0x50(%r14),%r8d
    5a9f:	4d 8b 0e             	mov    (%r14),%r9
    5aa2:	f3 0f 11 85 38 01 00 	movss  %xmm0,0x138(%rbp)
    5aa9:	00 
    5aaa:	41 8b 7e 4c          	mov    0x4c(%r14),%edi
    5aae:	45 85 c0             	test   %r8d,%r8d
    5ab1:	0f 84 61 03 00 00    	je     5e18 <ayatsuri_model_instance_evaluate+0x21d8>
    5ab7:	31 f6                	xor    %esi,%esi
    5ab9:	eb 0c                	jmp    5ac7 <ayatsuri_model_instance_evaluate+0x1e87>
    5abb:	83 c6 01             	add    $0x1,%esi
    5abe:	41 39 f0             	cmp    %esi,%r8d
    5ac1:	0f 84 51 03 00 00    	je     5e18 <ayatsuri_model_instance_evaluate+0x21d8>
    5ac7:	89 f0                	mov    %esi,%eax
    5ac9:	44 8b 74 24 18       	mov    0x18(%rsp),%r14d
    5ace:	c1 e0 05             	shl    $0x5,%eax
    5ad1:	48 01 f8             	add    %rdi,%rax
    5ad4:	4c 01 c8             	add    %r9,%rax
    5ad7:	0f b7 18             	movzwl (%rax),%ebx
    5ada:	44 39 f3             	cmp    %r14d,%ebx
    5add:	75 dc                	jne    5abb <ayatsuri_model_instance_evaluate+0x1e7b>
    5adf:	49 8b 77 08          	mov    0x8(%r15),%rsi
    5ae3:	66 0f ef ed          	pxor   %xmm5,%xmm5
    5ae7:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5aeb:	66 0f ef e4          	pxor   %xmm4,%xmm4
    5aef:	f3 41 0f 5a 47 34    	cvtss2sd 0x34(%r15),%xmm0
    5af5:	66 0f ef db          	pxor   %xmm3,%xmm3
    5af9:	66 0f 6f b4 24 a0 01 	movdqa 0x1a0(%rsp),%xmm6
    5b00:	00 00 
    5b02:	4c 8d 8c 24 10 02 00 	lea    0x210(%rsp),%r9
    5b09:	00 
    5b0a:	8b 54 16 08          	mov    0x8(%rsi,%rdx,1),%edx
    5b0e:	48 8d ac 24 f0 01 00 	lea    0x1f0(%rsp),%rbp
    5b15:	00 
    5b16:	0f 29 b4 24 10 02 00 	movaps %xmm6,0x210(%rsp)
    5b1d:	00 
    5b1e:	48 01 d6             	add    %rdx,%rsi
    5b21:	48 8d 94 24 c8 01 00 	lea    0x1c8(%rsp),%rdx
    5b28:	00 
    5b29:	f3 0f 5a 6e 0c       	cvtss2sd 0xc(%rsi),%xmm5
    5b2e:	f2 0f 5c e8          	subsd  %xmm0,%xmm5
    5b32:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5b36:	f3 0f 5a 66 1c       	cvtss2sd 0x1c(%rsi),%xmm4
    5b3b:	f3 41 0f 5a 47 38    	cvtss2sd 0x38(%r15),%xmm0
    5b41:	f2 0f 5c e0          	subsd  %xmm0,%xmm4
    5b45:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5b49:	4c 8d 76 0c          	lea    0xc(%rsi),%r14
    5b4d:	f3 0f 5a 5e 2c       	cvtss2sd 0x2c(%rsi),%xmm3
    5b52:	f3 41 0f 5a 47 3c    	cvtss2sd 0x3c(%r15),%xmm0
    5b58:	f2 0f 5c d8          	subsd  %xmm0,%xmm3
    5b5c:	48 89 94 24 20 02 00 	mov    %rdx,0x220(%rsp)
    5b63:	00 
    5b64:	31 d2                	xor    %edx,%edx
    5b66:	41 89 d0             	mov    %edx,%r8d
    5b69:	48 83 fa 02          	cmp    $0x2,%rdx
    5b6d:	0f 84 96 06 00 00    	je     6209 <ayatsuri_model_instance_evaluate+0x25c9>
    5b73:	66 0f ef f6          	pxor   %xmm6,%xmm6
    5b77:	f3 41 0f 5a 77 40    	cvtss2sd 0x40(%r15),%xmm6
    5b7d:	49 8b 3c d1          	mov    (%r9,%rdx,8),%rdi
    5b81:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5b85:	66 0f ef ff          	pxor   %xmm7,%xmm7
    5b89:	66 0f ef d2          	pxor   %xmm2,%xmm2
    5b8d:	47 8d 04 40          	lea    (%r8,%r8,2),%r8d
    5b91:	f3 0f 5a 07          	cvtss2sd (%rdi),%xmm0
    5b95:	f3 0f 5a 7f 04       	cvtss2sd 0x4(%rdi),%xmm7
    5b9a:	f3 0f 5a 57 08       	cvtss2sd 0x8(%rdi),%xmm2
    5b9f:	48 89 f7             	mov    %rsi,%rdi
    5ba2:	66 0f ef c9          	pxor   %xmm1,%xmm1
    5ba6:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    5bab:	44 89 c3             	mov    %r8d,%ebx
    5bae:	48 83 c7 04          	add    $0x4,%rdi
    5bb2:	f3 0f 5a 4f fc       	cvtss2sd -0x4(%rdi),%xmm1
    5bb7:	f3 44 0f 5a 47 0c    	cvtss2sd 0xc(%rdi),%xmm8
    5bbd:	f2 0f 59 c8          	mulsd  %xmm0,%xmm1
    5bc1:	41 83 c0 01          	add    $0x1,%r8d
    5bc5:	f2 44 0f 59 c7       	mulsd  %xmm7,%xmm8
    5bca:	f2 41 0f 58 c8       	addsd  %xmm8,%xmm1
    5bcf:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    5bd4:	f3 44 0f 5a 47 1c    	cvtss2sd 0x1c(%rdi),%xmm8
    5bda:	f2 44 0f 59 c2       	mulsd  %xmm2,%xmm8
    5bdf:	f2 41 0f 58 c8       	addsd  %xmm8,%xmm1
    5be4:	f2 0f 59 ce          	mulsd  %xmm6,%xmm1
    5be8:	f2 0f 11 8c dc e0 02 	movsd  %xmm1,0x2e0(%rsp,%rbx,8)
    5bef:	00 00 
    5bf1:	4c 39 f7             	cmp    %r14,%rdi
    5bf4:	75 ac                	jne    5ba2 <ayatsuri_model_instance_evaluate+0x1f62>
    5bf6:	f2 0f 59 c5          	mulsd  %xmm5,%xmm0
    5bfa:	f2 0f 59 fc          	mulsd  %xmm4,%xmm7
    5bfe:	f2 0f 59 d3          	mulsd  %xmm3,%xmm2
    5c02:	f2 0f 58 c7          	addsd  %xmm7,%xmm0
    5c06:	f2 0f 58 c2          	addsd  %xmm2,%xmm0
    5c0a:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
    5c0e:	f2 0f 11 44 d5 00    	movsd  %xmm0,0x0(%rbp,%rdx,8)
    5c14:	48 83 fa 02          	cmp    $0x2,%rdx
    5c18:	0f 84 05 02 00 00    	je     5e23 <ayatsuri_model_instance_evaluate+0x21e3>
    5c1e:	66 0f ef c9          	pxor   %xmm1,%xmm1
    5c22:	f3 41 0f 5a 4c 97 44 	cvtss2sd 0x44(%r15,%rdx,4),%xmm1
    5c29:	f2 0f 58 c8          	addsd  %xmm0,%xmm1
    5c2d:	f2 0f 11 4c d5 00    	movsd  %xmm1,0x0(%rbp,%rdx,8)
    5c33:	48 83 c2 01          	add    $0x1,%rdx
    5c37:	e9 2a ff ff ff       	jmp    5b66 <ayatsuri_model_instance_evaluate+0x1f26>
    5c3c:	0f 1f 40 00          	nopl   0x0(%rax)
    5c40:	48 8b 41 10          	mov    0x10(%rcx),%rax
    5c44:	48 8b 51 18          	mov    0x18(%rcx),%rdx
    5c48:	48 33 46 10          	xor    0x10(%rsi),%rax
    5c4c:	48 33 56 18          	xor    0x18(%rsi),%rdx
    5c50:	48 09 d0             	or     %rdx,%rax
    5c53:	0f 85 cc e1 ff ff    	jne    3e25 <ayatsuri_model_instance_evaluate+0x1e5>
    5c59:	8b 46 20             	mov    0x20(%rsi),%eax
    5c5c:	39 41 20             	cmp    %eax,0x20(%rcx)
    5c5f:	0f 85 c0 e1 ff ff    	jne    3e25 <ayatsuri_model_instance_evaluate+0x1e5>
    5c65:	49 39 cf             	cmp    %rcx,%r15
    5c68:	0f 82 0a 01 00 00    	jb     5d78 <ayatsuri_model_instance_evaluate+0x2138>
    5c6e:	4c 89 f8             	mov    %r15,%rax
    5c71:	48 29 c8             	sub    %rcx,%rax
    5c74:	48 83 f8 23          	cmp    $0x23,%rax
    5c78:	0f 86 a7 e1 ff ff    	jbe    3e25 <ayatsuri_model_instance_evaluate+0x1e5>
    5c7e:	4d 39 c7             	cmp    %r8,%r15
    5c81:	0f 82 49 01 00 00    	jb     5dd0 <ayatsuri_model_instance_evaluate+0x2190>
    5c87:	4c 89 f8             	mov    %r15,%rax
    5c8a:	4c 29 c0             	sub    %r8,%rax
    5c8d:	48 83 f8 17          	cmp    $0x17,%rax
    5c91:	0f 86 8e e1 ff ff    	jbe    3e25 <ayatsuri_model_instance_evaluate+0x1e5>
    5c97:	41 c6 87 a6 00 00 00 	movb   $0x0,0xa6(%r15)
    5c9e:	00 
    5c9f:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
    5ca4:	31 db                	xor    %ebx,%ebx
    5ca6:	49 8b 17             	mov    (%r15),%rdx
    5ca9:	41 0f 11 47 4c       	movups %xmm0,0x4c(%r15)
    5cae:	49 8b 40 10          	mov    0x10(%r8),%rax
    5cb2:	49 89 47 5c          	mov    %rax,0x5c(%r15)
    5cb6:	f3 41 0f 10 00       	movss  (%r8),%xmm0
    5cbb:	66 83 7a 0c 00       	cmpw   $0x0,0xc(%rdx)
    5cc0:	f3 41 0f 11 47 64    	movss  %xmm0,0x64(%r15)
    5cc6:	f3 41 0f 10 40 0c    	movss  0xc(%r8),%xmm0
    5ccc:	f3 41 0f 11 47 7c    	movss  %xmm0,0x7c(%r15)
    5cd2:	f3 41 0f 10 40 04    	movss  0x4(%r8),%xmm0
    5cd8:	f3 41 0f 11 47 68    	movss  %xmm0,0x68(%r15)
    5cde:	f3 41 0f 10 40 10    	movss  0x10(%r8),%xmm0
    5ce4:	f3 41 0f 11 87 80 00 	movss  %xmm0,0x80(%r15)
    5ceb:	00 00 
    5ced:	f3 41 0f 10 40 08    	movss  0x8(%r8),%xmm0
    5cf3:	f3 41 0f 11 47 6c    	movss  %xmm0,0x6c(%r15)
    5cf9:	f3 41 0f 10 40 14    	movss  0x14(%r8),%xmm0
    5cff:	f3 41 0f 11 87 84 00 	movss  %xmm0,0x84(%r15)
    5d06:	00 00 
    5d08:	75 16                	jne    5d20 <ayatsuri_model_instance_evaluate+0x20e0>
    5d0a:	e9 83 e9 ff ff       	jmp    4692 <ayatsuri_model_instance_evaluate+0xa52>
    5d0f:	90                   	nop
    5d10:	0f b7 42 0c          	movzwl 0xc(%rdx),%eax
    5d14:	48 83 c3 01          	add    $0x1,%rbx
    5d18:	39 c3                	cmp    %eax,%ebx
    5d1a:	0f 83 72 e9 ff ff    	jae    4692 <ayatsuri_model_instance_evaluate+0xa52>
    5d20:	8b 4a 14             	mov    0x14(%rdx),%ecx
    5d23:	48 89 d8             	mov    %rbx,%rax
    5d26:	48 c1 e0 04          	shl    $0x4,%rax
    5d2a:	48 03 02             	add    (%rdx),%rax
    5d2d:	0f b6 44 01 02       	movzbl 0x2(%rcx,%rax,1),%eax
    5d32:	3c 03                	cmp    $0x3,%al
    5d34:	74 1e                	je     5d54 <ayatsuri_model_instance_evaluate+0x2114>
    5d36:	84 c0                	test   %al,%al
    5d38:	74 d6                	je     5d10 <ayatsuri_model_instance_evaluate+0x20d0>
    5d3a:	41 8b 87 94 00 00 00 	mov    0x94(%r15),%eax
    5d41:	31 c9                	xor    %ecx,%ecx
    5d43:	83 f8 ff             	cmp    $0xffffffff,%eax
    5d46:	0f 95 c1             	setne  %cl
    5d49:	01 c8                	add    %ecx,%eax
    5d4b:	41 89 87 94 00 00 00 	mov    %eax,0x94(%r15)
    5d52:	eb bc                	jmp    5d10 <ayatsuri_model_instance_evaluate+0x20d0>
    5d54:	45 31 c0             	xor    %r8d,%r8d
    5d57:	31 c9                	xor    %ecx,%ecx
    5d59:	31 d2                	xor    %edx,%edx
    5d5b:	41 b9 01 00 00 00    	mov    $0x1,%r9d
    5d61:	89 de                	mov    %ebx,%esi
    5d63:	4c 89 ff             	mov    %r15,%rdi
    5d66:	e8 95 aa ff ff       	call   800 <mesh_packet>
    5d6b:	84 c0                	test   %al,%al
    5d6d:	0f 84 ad fa ff ff    	je     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    5d73:	49 8b 17             	mov    (%r15),%rdx
    5d76:	eb c2                	jmp    5d3a <ayatsuri_model_instance_evaluate+0x20fa>
    5d78:	48 89 c8             	mov    %rcx,%rax
    5d7b:	4c 29 f8             	sub    %r15,%rax
    5d7e:	48 3d a7 00 00 00    	cmp    $0xa7,%rax
    5d84:	0f 86 9b e0 ff ff    	jbe    3e25 <ayatsuri_model_instance_evaluate+0x1e5>
    5d8a:	e9 ef fe ff ff       	jmp    5c7e <ayatsuri_model_instance_evaluate+0x203e>
    5d8f:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 5d97 <ayatsuri_model_instance_evaluate+0x2157>
    5d96:	00 
			5d93: R_X86_64_PC32	.LC15-0x4
    5d97:	66 44 0f 28 c3       	movapd %xmm3,%xmm8
    5d9c:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5da0:	f3 44 0f 7e 0d 00 00 	movq   0x0(%rip),%xmm9        # 5da9 <ayatsuri_model_instance_evaluate+0x2169>
    5da7:	00 00 
			5da5: R_X86_64_PC32	.LC26-0x4
    5da9:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 5db1 <ayatsuri_model_instance_evaluate+0x2171>
    5db0:	00 
			5dad: R_X86_64_PC32	.LC9-0x4
    5db1:	66 0f ef ff          	pxor   %xmm7,%xmm7
    5db5:	44 0f 29 8c 24 80 00 	movaps %xmm9,0x80(%rsp)
    5dbc:	00 00 
    5dbe:	e9 cb e1 ff ff       	jmp    3f8e <ayatsuri_model_instance_evaluate+0x34e>
    5dc3:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5dc7:	f2 0f 5a c1          	cvtsd2ss %xmm1,%xmm0
    5dcb:	e9 14 ec ff ff       	jmp    49e4 <ayatsuri_model_instance_evaluate+0xda4>
    5dd0:	4c 89 c0             	mov    %r8,%rax
    5dd3:	4c 29 f8             	sub    %r15,%rax
    5dd6:	48 3d a7 00 00 00    	cmp    $0xa7,%rax
    5ddc:	0f 87 b5 fe ff ff    	ja     5c97 <ayatsuri_model_instance_evaluate+0x2057>
    5de2:	e9 3e e0 ff ff       	jmp    3e25 <ayatsuri_model_instance_evaluate+0x1e5>
    5de7:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    5deb:	e9 cf ec ff ff       	jmp    4abf <ayatsuri_model_instance_evaluate+0xe7f>
    5df0:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 5df8 <ayatsuri_model_instance_evaluate+0x21b8>
    5df7:	00 
			5df4: R_X86_64_PC32	.LC33-0x4
    5df8:	e9 c2 ec ff ff       	jmp    4abf <ayatsuri_model_instance_evaluate+0xe7f>
    5dfd:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    5e01:	e9 4e ed ff ff       	jmp    4b54 <ayatsuri_model_instance_evaluate+0xf14>
    5e06:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    5e0a:	e9 40 ee ff ff       	jmp    4c4f <ayatsuri_model_instance_evaluate+0x100f>
    5e0f:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    5e13:	e9 83 fc ff ff       	jmp    5a9b <ayatsuri_model_instance_evaluate+0x1e5b>
    5e18:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    5e1e:	e9 1c e8 ff ff       	jmp    463f <ayatsuri_model_instance_evaluate+0x9ff>
    5e23:	f2 44 0f 10 9c 24 00 	movsd  0x300(%rsp),%xmm11
    5e2a:	03 00 00 
    5e2d:	f2 44 0f 10 84 24 08 	movsd  0x308(%rsp),%xmm8
    5e34:	03 00 00 
    5e37:	f2 0f 10 bc 24 18 03 	movsd  0x318(%rsp),%xmm7
    5e3e:	00 00 
    5e40:	f2 0f 10 84 24 20 03 	movsd  0x320(%rsp),%xmm0
    5e47:	00 00 
    5e49:	66 41 0f 28 eb       	movapd %xmm11,%xmm5
    5e4e:	66 41 0f 28 d8       	movapd %xmm8,%xmm3
    5e53:	f2 44 0f 10 8c 24 f8 	movsd  0x2f8(%rsp),%xmm9
    5e5a:	02 00 00 
    5e5d:	f2 0f 10 a4 24 10 03 	movsd  0x310(%rsp),%xmm4
    5e64:	00 00 
    5e66:	f2 0f 59 df          	mulsd  %xmm7,%xmm3
    5e6a:	66 45 0f 28 e8       	movapd %xmm8,%xmm13
    5e6f:	f2 0f 10 8c 24 e0 02 	movsd  0x2e0(%rsp),%xmm1
    5e76:	00 00 
    5e78:	f2 0f 10 b4 24 e8 02 	movsd  0x2e8(%rsp),%xmm6
    5e7f:	00 00 
    5e81:	f2 0f 59 e8          	mulsd  %xmm0,%xmm5
    5e85:	66 45 0f 28 e1       	movapd %xmm9,%xmm12
    5e8a:	66 45 0f 28 f9       	movapd %xmm9,%xmm15
    5e8f:	f2 0f 10 94 24 f0 02 	movsd  0x2f0(%rsp),%xmm2
    5e96:	00 00 
    5e98:	f2 44 0f 59 e7       	mulsd  %xmm7,%xmm12
    5e9d:	f2 44 0f 59 f8       	mulsd  %xmm0,%xmm15
    5ea2:	f2 44 0f 59 ec       	mulsd  %xmm4,%xmm13
    5ea7:	f2 0f 5c eb          	subsd  %xmm3,%xmm5
    5eab:	66 41 0f 28 db       	movapd %xmm11,%xmm3
    5eb0:	f2 0f 59 dc          	mulsd  %xmm4,%xmm3
    5eb4:	f2 44 0f 11 7c 24 20 	movsd  %xmm15,0x20(%rsp)
    5ebb:	f2 0f 11 2c 24       	movsd  %xmm5,(%rsp)
    5ec0:	f2 44 0f 5c e3       	subsd  %xmm3,%xmm12
    5ec5:	f2 0f 10 1c 24       	movsd  (%rsp),%xmm3
    5eca:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
    5ece:	66 41 0f 28 ec       	movapd %xmm12,%xmm5
    5ed3:	f2 44 0f 11 64 24 30 	movsd  %xmm12,0x30(%rsp)
    5eda:	66 45 0f 28 e7       	movapd %xmm15,%xmm12
    5edf:	f2 45 0f 5c e5       	subsd  %xmm13,%xmm12
    5ee4:	f2 44 0f 59 e6       	mulsd  %xmm6,%xmm12
    5ee9:	f2 41 0f 5c dc       	subsd  %xmm12,%xmm3
    5eee:	66 44 0f 28 e5       	movapd %xmm5,%xmm12
    5ef3:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 5efb <ayatsuri_model_instance_evaluate+0x22bb>
    5efa:	00 
			5ef7: R_X86_64_PC32	.LC22-0x4
    5efb:	f2 44 0f 59 e2       	mulsd  %xmm2,%xmm12
    5f00:	f2 41 0f 58 dc       	addsd  %xmm12,%xmm3
    5f05:	66 44 0f 28 e3       	movapd %xmm3,%xmm12
    5f0a:	66 44 0f 54 25 00 00 	andpd  0x0(%rip),%xmm12        # 5f13 <ayatsuri_model_instance_evaluate+0x22d3>
    5f11:	00 00 
			5f0f: R_X86_64_PC32	.LC8-0x4
    5f13:	66 41 0f 2e ec       	ucomisd %xmm12,%xmm5
    5f18:	0f 82 02 f9 ff ff    	jb     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    5f1e:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    5f23:	66 41 0f 2e dc       	ucomisd %xmm12,%xmm3
    5f28:	7a 06                	jp     5f30 <ayatsuri_model_instance_evaluate+0x22f0>
    5f2a:	0f 84 f0 f8 ff ff    	je     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    5f30:	66 44 0f 28 fa       	movapd %xmm2,%xmm15
    5f35:	66 44 0f 28 e3       	movapd %xmm3,%xmm12
    5f3a:	f2 44 0f 5c 6c 24 20 	subsd  0x20(%rsp),%xmm13
    5f41:	31 ff                	xor    %edi,%edi
    5f43:	f2 44 0f 59 ff       	mulsd  %xmm7,%xmm15
    5f48:	66 45 0f 14 e4       	unpcklpd %xmm12,%xmm12
    5f4d:	f2 0f 59 f9          	mulsd  %xmm1,%xmm7
    5f51:	66 4c 0f 7e fa       	movq   %xmm15,%rdx
    5f56:	66 44 0f 28 fe       	movapd %xmm6,%xmm15
    5f5b:	f2 44 0f 59 f8       	mulsd  %xmm0,%xmm15
    5f60:	66 48 0f 6e ea       	movq   %rdx,%xmm5
    5f65:	48 8d 94 24 30 02 00 	lea    0x230(%rsp),%rdx
    5f6c:	00 
    5f6d:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    5f71:	f2 41 0f 5c ef       	subsd  %xmm15,%xmm5
    5f76:	f2 44 0f 10 3c 24    	movsd  (%rsp),%xmm15
    5f7c:	66 44 0f 14 fd       	unpcklpd %xmm5,%xmm15
    5f81:	66 41 0f 28 ef       	movapd %xmm15,%xmm5
    5f86:	66 44 0f 28 fe       	movapd %xmm6,%xmm15
    5f8b:	66 41 0f 5e ec       	divpd  %xmm12,%xmm5
    5f90:	f2 45 0f 59 f8       	mulsd  %xmm8,%xmm15
    5f95:	f2 44 0f 59 c1       	mulsd  %xmm1,%xmm8
    5f9a:	f2 41 0f 59 cb       	mulsd  %xmm11,%xmm1
    5f9f:	0f 29 ac 24 90 03 00 	movaps %xmm5,0x390(%rsp)
    5fa6:	00 
    5fa7:	66 0f 28 ea          	movapd %xmm2,%xmm5
    5fab:	f2 41 0f 59 eb       	mulsd  %xmm11,%xmm5
    5fb0:	f2 44 0f 5c fd       	subsd  %xmm5,%xmm15
    5fb5:	66 41 0f 28 ef       	movapd %xmm15,%xmm5
    5fba:	66 41 0f 14 ed       	unpcklpd %xmm13,%xmm5
    5fbf:	66 41 0f 5e ec       	divpd  %xmm12,%xmm5
    5fc4:	0f 29 ac 24 a0 03 00 	movaps %xmm5,0x3a0(%rsp)
    5fcb:	00 
    5fcc:	66 0f 28 ea          	movapd %xmm2,%xmm5
    5fd0:	f2 0f 59 ec          	mulsd  %xmm4,%xmm5
    5fd4:	f2 41 0f 59 d1       	mulsd  %xmm9,%xmm2
    5fd9:	f2 0f 59 e6          	mulsd  %xmm6,%xmm4
    5fdd:	f2 41 0f 59 f1       	mulsd  %xmm9,%xmm6
    5fe2:	f2 0f 5c c5          	subsd  %xmm5,%xmm0
    5fe6:	f2 41 0f 5c d0       	subsd  %xmm8,%xmm2
    5feb:	f2 0f 5c e7          	subsd  %xmm7,%xmm4
    5fef:	66 0f 14 c2          	unpcklpd %xmm2,%xmm0
    5ff3:	66 0f ef d2          	pxor   %xmm2,%xmm2
    5ff7:	66 41 0f 5e c4       	divpd  %xmm12,%xmm0
    5ffc:	f3 0f 5a 50 08       	cvtss2sd 0x8(%rax),%xmm2
    6001:	0f 29 84 24 b0 03 00 	movaps %xmm0,0x3b0(%rsp)
    6008:	00 
    6009:	f2 0f 10 44 24 30    	movsd  0x30(%rsp),%xmm0
    600f:	66 0f 14 c4          	unpcklpd %xmm4,%xmm0
    6013:	66 41 0f 5e c4       	divpd  %xmm12,%xmm0
    6018:	0f 29 84 24 c0 03 00 	movaps %xmm0,0x3c0(%rsp)
    601f:	00 
    6020:	66 0f 28 c1          	movapd %xmm1,%xmm0
    6024:	66 0f ef c9          	pxor   %xmm1,%xmm1
    6028:	f2 0f 5c c6          	subsd  %xmm6,%xmm0
    602c:	f3 0f 5a 48 0c       	cvtss2sd 0xc(%rax),%xmm1
    6031:	f2 0f 5e c3          	divsd  %xmm3,%xmm0
    6035:	66 0f ef db          	pxor   %xmm3,%xmm3
    6039:	f3 0f 5a 58 04       	cvtss2sd 0x4(%rax),%xmm3
    603e:	f2 0f 11 84 24 d0 03 	movsd  %xmm0,0x3d0(%rsp)
    6045:	00 00 
    6047:	f2 41 0f 10 45 00    	movsd  0x0(%r13),%xmm0
    604d:	f2 41 0f 10 65 18    	movsd  0x18(%r13),%xmm4
    6053:	49 83 c5 08          	add    $0x8,%r13
    6057:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    605b:	f2 0f 59 c3          	mulsd  %xmm3,%xmm0
    605f:	f2 0f 58 c4          	addsd  %xmm4,%xmm0
    6063:	f2 41 0f 10 65 28    	movsd  0x28(%r13),%xmm4
    6069:	f2 0f 59 e1          	mulsd  %xmm1,%xmm4
    606d:	f2 0f 58 c4          	addsd  %xmm4,%xmm0
    6071:	f2 0f 11 04 3a       	movsd  %xmm0,(%rdx,%rdi,1)
    6076:	48 83 c7 08          	add    $0x8,%rdi
    607a:	48 83 ff 18          	cmp    $0x18,%rdi
    607e:	75 c7                	jne    6047 <ayatsuri_model_instance_evaluate+0x2407>
    6080:	f2 0f 10 84 24 30 02 	movsd  0x230(%rsp),%xmm0
    6087:	00 00 
    6089:	4d 8b 07             	mov    (%r15),%r8
    608c:	66 0f 57 84 24 80 00 	xorpd  0x80(%rsp),%xmm0
    6093:	00 00 
    6095:	f2 0f 10 8c 24 38 02 	movsd  0x238(%rsp),%xmm1
    609c:	00 00 
    609e:	f2 0f 59 84 24 f0 01 	mulsd  0x1f0(%rsp),%xmm0
    60a5:	00 00 
    60a7:	41 8b 78 14          	mov    0x14(%r8),%edi
    60ab:	f2 0f 59 8c 24 f8 01 	mulsd  0x1f8(%rsp),%xmm1
    60b2:	00 00 
    60b4:	48 01 f9             	add    %rdi,%rcx
    60b7:	49 03 08             	add    (%r8),%rcx
    60ba:	0f b6 79 02          	movzbl 0x2(%rcx),%edi
    60be:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    60c2:	f2 0f 10 8c 24 40 02 	movsd  0x240(%rsp),%xmm1
    60c9:	00 00 
    60cb:	f2 0f 59 8c 24 00 02 	mulsd  0x200(%rsp),%xmm1
    60d2:	00 00 
    60d4:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    60d8:	66 0f ef c9          	pxor   %xmm1,%xmm1
    60dc:	f3 0f 5a 48 10       	cvtss2sd 0x10(%rax),%xmm1
    60e1:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    60e5:	f2 0f 11 84 24 48 02 	movsd  %xmm0,0x248(%rsp)
    60ec:	00 00 
    60ee:	40 84 ff             	test   %dil,%dil
    60f1:	0f 84 d3 01 00 00    	je     62ca <ayatsuri_model_instance_evaluate+0x268a>
    60f7:	40 80 ef 01          	sub    $0x1,%dil
    60fb:	0f 84 bf 01 00 00    	je     62c0 <ayatsuri_model_instance_evaluate+0x2680>
    6101:	0f b7 49 06          	movzwl 0x6(%rcx),%ecx
    6105:	6b c9 6c             	imul   $0x6c,%ecx,%ecx
    6108:	81 c1 3c 01 00 00    	add    $0x13c,%ecx
    610e:	89 cf                	mov    %ecx,%edi
    6110:	45 31 c0             	xor    %r8d,%r8d
    6113:	c1 ef 02             	shr    $0x2,%edi
    6116:	48 8d 3c be          	lea    (%rsi,%rdi,4),%rdi
    611a:	f2 42 0f 10 04 42    	movsd  (%rdx,%r8,2),%xmm0
    6120:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 6128 <ayatsuri_model_instance_evaluate+0x24e8>
    6127:	00 
			6124: R_X86_64_PC32	.LC22-0x4
    6128:	66 0f 28 c8          	movapd %xmm0,%xmm1
    612c:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 6134 <ayatsuri_model_instance_evaluate+0x24f4>
    6133:	00 
			6130: R_X86_64_PC32	.LC8-0x4
    6134:	66 0f 2e f9          	ucomisd %xmm1,%xmm7
    6138:	0f 82 e2 f6 ff ff    	jb     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    613e:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 6146 <ayatsuri_model_instance_evaluate+0x2506>
    6145:	00 
			6142: R_X86_64_PC32	.LC38-0x4
    6146:	0f 83 d4 f6 ff ff    	jae    5820 <ayatsuri_model_instance_evaluate+0x1be0>
    614c:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 6154 <ayatsuri_model_instance_evaluate+0x2514>
    6153:	00 
			6150: R_X86_64_PC32	.LC39-0x4
    6154:	0f 86 ec 00 00 00    	jbe    6246 <ayatsuri_model_instance_evaluate+0x2606>
    615a:	66 0f ef c9          	pxor   %xmm1,%xmm1
    615e:	66 0f 2f c8          	comisd %xmm0,%xmm1
    6162:	0f 87 d1 00 00 00    	ja     6239 <ayatsuri_model_instance_evaluate+0x25f9>
    6168:	41 0f 28 c6          	movaps %xmm14,%xmm0
    616c:	f3 42 0f 11 04 07    	movss  %xmm0,(%rdi,%r8,1)
    6172:	e9 a9 f6 ff ff       	jmp    5820 <ayatsuri_model_instance_evaluate+0x1be0>
    6177:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 617f <ayatsuri_model_instance_evaluate+0x253f>
    617e:	00 
			617b: R_X86_64_PC32	.LC33-0x4
    617f:	e9 cb ea ff ff       	jmp    4c4f <ayatsuri_model_instance_evaluate+0x100f>
    6184:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 618c <ayatsuri_model_instance_evaluate+0x254c>
    618b:	00 
			6188: R_X86_64_PC32	.LC34-0x4
    618c:	e9 70 f7 ff ff       	jmp    5901 <ayatsuri_model_instance_evaluate+0x1cc1>
    6191:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 6199 <ayatsuri_model_instance_evaluate+0x2559>
    6198:	00 
			6195: R_X86_64_PC32	.LC33-0x4
    6199:	e9 fd f8 ff ff       	jmp    5a9b <ayatsuri_model_instance_evaluate+0x1e5b>
    619e:	8b 7e 18             	mov    0x18(%rsi),%edi
    61a1:	48 89 14 24          	mov    %rdx,(%rsp)
    61a5:	e8 b6 9f ff ff       	call   160 <pack_rgb>
    61aa:	48 8b 14 24          	mov    (%rsp),%rdx
    61ae:	66 c7 85 f0 00 00 00 	movw   $0x4,0xf0(%rbp)
    61b5:	04 00 
    61b7:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 61c0 <ayatsuri_model_instance_evaluate+0x2580>
    61be:	00 00 
			61bc: R_X86_64_PC32	.LC0-0x4
    61c0:	66 89 85 ea 00 00 00 	mov    %ax,0xea(%rbp)
    61c7:	31 c0                	xor    %eax,%eax
    61c9:	8b 7c 06 04          	mov    0x4(%rsi,%rax,1),%edi
    61cd:	89 bc 05 c4 00 00 00 	mov    %edi,0xc4(%rbp,%rax,1)
    61d4:	48 83 c0 04          	add    $0x4,%rax
    61d8:	48 83 f8 14          	cmp    $0x14,%rax
    61dc:	75 eb                	jne    61c9 <ayatsuri_model_instance_evaluate+0x2589>
    61de:	c7 85 d8 00 00 00 00 	movl   $0x0,0xd8(%rbp)
    61e5:	00 00 00 
    61e8:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    61ee:	e9 42 e4 ff ff       	jmp    4635 <ayatsuri_model_instance_evaluate+0x9f5>
    61f3:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 61fb <ayatsuri_model_instance_evaluate+0x25bb>
    61fa:	00 
			61f7: R_X86_64_PC32	.LC33-0x4
    61fb:	e9 89 ec ff ff       	jmp    4e89 <ayatsuri_model_instance_evaluate+0x1249>
    6200:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    6204:	e9 80 ec ff ff       	jmp    4e89 <ayatsuri_model_instance_evaluate+0x1249>
    6209:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 6211 <ayatsuri_model_instance_evaluate+0x25d1>
    6210:	00 
			620d: R_X86_64_PC32	.LC9-0x4
    6211:	e9 67 f9 ff ff       	jmp    5b7d <ayatsuri_model_instance_evaluate+0x1f3d>
    6216:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 621e <ayatsuri_model_instance_evaluate+0x25de>
    621d:	00 
			621a: R_X86_64_PC32	.LC33-0x4
    621e:	e9 31 e9 ff ff       	jmp    4b54 <ayatsuri_model_instance_evaluate+0xf14>
    6223:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 622b <ayatsuri_model_instance_evaluate+0x25eb>
    622a:	00 
			6227: R_X86_64_PC32	.LC33-0x4
    622b:	e9 bd ea ff ff       	jmp    4ced <ayatsuri_model_instance_evaluate+0x10ad>
    6230:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    6234:	e9 b4 ea ff ff       	jmp    4ced <ayatsuri_model_instance_evaluate+0x10ad>
    6239:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 6241 <ayatsuri_model_instance_evaluate+0x2601>
    6240:	00 
			623d: R_X86_64_PC32	.LC33-0x4
    6241:	e9 26 ff ff ff       	jmp    616c <ayatsuri_model_instance_evaluate+0x252c>
    6246:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    624a:	f3 42 0f 11 04 07    	movss  %xmm0,(%rdi,%r8,1)
    6250:	41 0f 54 c2          	andps  %xmm10,%xmm0
    6254:	0f 2f 05 00 00 00 00 	comiss 0x0(%rip),%xmm0        # 625b <ayatsuri_model_instance_evaluate+0x261b>
			6257: R_X86_64_PC32	.LC43-0x4
    625b:	0f 87 bf f5 ff ff    	ja     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    6261:	49 83 c0 04          	add    $0x4,%r8
    6265:	49 83 f8 10          	cmp    $0x10,%r8
    6269:	0f 85 ab fe ff ff    	jne    611a <ayatsuri_model_instance_evaluate+0x24da>
    626f:	66 0f ef c0          	pxor   %xmm0,%xmm0
    6273:	0f 2e 07             	ucomiss (%rdi),%xmm0
    6276:	7a 16                	jp     628e <ayatsuri_model_instance_evaluate+0x264e>
    6278:	75 14                	jne    628e <ayatsuri_model_instance_evaluate+0x264e>
    627a:	0f 2e 47 04          	ucomiss 0x4(%rdi),%xmm0
    627e:	7a 0e                	jp     628e <ayatsuri_model_instance_evaluate+0x264e>
    6280:	75 0c                	jne    628e <ayatsuri_model_instance_evaluate+0x264e>
    6282:	0f 2e 47 08          	ucomiss 0x8(%rdi),%xmm0
    6286:	7a 06                	jp     628e <ayatsuri_model_instance_evaluate+0x264e>
    6288:	0f 84 92 f5 ff ff    	je     5820 <ayatsuri_model_instance_evaluate+0x1be0>
    628e:	8b 50 14             	mov    0x14(%rax),%edx
    6291:	89 57 10             	mov    %edx,0x10(%rdi)
    6294:	8b 78 18             	mov    0x18(%rax),%edi
    6297:	e8 c4 9e ff ff       	call   160 <pack_rgb>
    629c:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 62a5 <ayatsuri_model_instance_evaluate+0x2665>
    62a3:	00 00 
			62a1: R_X86_64_PC32	.LC0-0x4
    62a5:	89 c2                	mov    %eax,%edx
    62a7:	8d 41 14             	lea    0x14(%rcx),%eax
    62aa:	66 89 14 06          	mov    %dx,(%rsi,%rax,1)
    62ae:	66 c7 44 06 02 00 00 	movw   $0x0,0x2(%rsi,%rax,1)
    62b5:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    62bb:	e9 7f e3 ff ff       	jmp    463f <ayatsuri_model_instance_evaluate+0x9ff>
    62c0:	b9 08 01 00 00       	mov    $0x108,%ecx
    62c5:	e9 44 fe ff ff       	jmp    610e <ayatsuri_model_instance_evaluate+0x24ce>
    62ca:	b9 54 00 00 00       	mov    $0x54,%ecx
    62cf:	e9 3a fe ff ff       	jmp    610e <ayatsuri_model_instance_evaluate+0x24ce>
    62d4:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    62db:	00 00 00 00 
    62df:	90                   	nop

00000000000062e0 <ayatsuri_model_instance_next>:
    62e0:	48 85 ff             	test   %rdi,%rdi
    62e3:	0f 84 7e 00 00 00    	je     6367 <ayatsuri_model_instance_next+0x87>
    62e9:	80 bf a4 00 00 00 01 	cmpb   $0x1,0xa4(%rdi)
    62f0:	49 89 fa             	mov    %rdi,%r10
    62f3:	75 72                	jne    6367 <ayatsuri_model_instance_next+0x87>
    62f5:	48 85 f6             	test   %rsi,%rsi
    62f8:	74 6d                	je     6367 <ayatsuri_model_instance_next+0x87>
    62fa:	48 3b 77 10          	cmp    0x10(%rdi),%rsi
    62fe:	75 67                	jne    6367 <ayatsuri_model_instance_next+0x87>
    6300:	3b 57 20             	cmp    0x20(%rdi),%edx
    6303:	75 62                	jne    6367 <ayatsuri_model_instance_next+0x87>
    6305:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    630c:	b8 04 00 00 00       	mov    $0x4,%eax
    6311:	75 4a                	jne    635d <ayatsuri_model_instance_next+0x7d>
    6313:	80 bf a6 00 00 00 00 	cmpb   $0x0,0xa6(%rdi)
    631a:	c6 87 a5 00 00 00 01 	movb   $0x1,0xa5(%rdi)
    6321:	74 3d                	je     6360 <ayatsuri_model_instance_next+0x80>
    6323:	48 85 c9             	test   %rcx,%rcx
    6326:	74 28                	je     6350 <ayatsuri_model_instance_next+0x70>
    6328:	4d 85 c0             	test   %r8,%r8
    632b:	74 23                	je     6350 <ayatsuri_model_instance_next+0x70>
    632d:	49 39 c8             	cmp    %rcx,%r8
    6330:	73 3e                	jae    6370 <ayatsuri_model_instance_next+0x90>
    6332:	48 89 c8             	mov    %rcx,%rax
    6335:	4c 29 c0             	sub    %r8,%rax
    6338:	48 83 f8 17          	cmp    $0x17,%rax
    633c:	76 12                	jbe    6350 <ayatsuri_model_instance_next+0x70>
    633e:	49 39 ca             	cmp    %rcx,%r10
    6341:	72 3d                	jb     6380 <ayatsuri_model_instance_next+0xa0>
    6343:	4c 89 d0             	mov    %r10,%rax
    6346:	48 29 c8             	sub    %rcx,%rax
    6349:	48 83 f8 03          	cmp    $0x3,%rax
    634d:	77 3f                	ja     638e <ayatsuri_model_instance_next+0xae>
    634f:	90                   	nop
    6350:	41 c6 82 a5 00 00 00 	movb   $0x0,0xa5(%r10)
    6357:	00 
    6358:	b8 01 00 00 00       	mov    $0x1,%eax
    635d:	c3                   	ret
    635e:	66 90                	xchg   %ax,%ax
    6360:	c6 87 a5 00 00 00 00 	movb   $0x0,0xa5(%rdi)
    6367:	b8 03 00 00 00       	mov    $0x3,%eax
    636c:	c3                   	ret
    636d:	0f 1f 00             	nopl   (%rax)
    6370:	4c 89 c0             	mov    %r8,%rax
    6373:	48 29 c8             	sub    %rcx,%rax
    6376:	48 83 f8 03          	cmp    $0x3,%rax
    637a:	76 d4                	jbe    6350 <ayatsuri_model_instance_next+0x70>
    637c:	eb c0                	jmp    633e <ayatsuri_model_instance_next+0x5e>
    637e:	66 90                	xchg   %ax,%ax
    6380:	48 89 c8             	mov    %rcx,%rax
    6383:	4c 29 d0             	sub    %r10,%rax
    6386:	48 3d a7 00 00 00    	cmp    $0xa7,%rax
    638c:	76 c2                	jbe    6350 <ayatsuri_model_instance_next+0x70>
    638e:	49 8b 3a             	mov    (%r10),%rdi
    6391:	48 39 cf             	cmp    %rcx,%rdi
    6394:	0f 83 e6 01 00 00    	jae    6580 <ayatsuri_model_instance_next+0x2a0>
    639a:	48 89 c8             	mov    %rcx,%rax
    639d:	48 29 f8             	sub    %rdi,%rax
    63a0:	48 83 f8 7f          	cmp    $0x7f,%rax
    63a4:	76 aa                	jbe    6350 <ayatsuri_model_instance_next+0x70>
    63a6:	49 8b 42 18          	mov    0x18(%r10),%rax
    63aa:	49 8b 52 08          	mov    0x8(%r10),%rdx
    63ae:	48 85 c0             	test   %rax,%rax
    63b1:	74 1d                	je     63d0 <ayatsuri_model_instance_next+0xf0>
    63b3:	48 39 ca             	cmp    %rcx,%rdx
    63b6:	0f 82 34 02 00 00    	jb     65f0 <ayatsuri_model_instance_next+0x310>
    63bc:	48 89 d6             	mov    %rdx,%rsi
    63bf:	48 29 ce             	sub    %rcx,%rsi
    63c2:	48 83 fe 03          	cmp    $0x3,%rsi
    63c6:	76 88                	jbe    6350 <ayatsuri_model_instance_next+0x70>
    63c8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    63cf:	00 
    63d0:	41 56                	push   %r14
    63d2:	41 55                	push   %r13
    63d4:	41 54                	push   %r12
    63d6:	55                   	push   %rbp
    63d7:	53                   	push   %rbx
    63d8:	48 83 ec 18          	sub    $0x18,%rsp
    63dc:	44 8b 4f 08          	mov    0x8(%rdi),%r9d
    63e0:	48 8b 1f             	mov    (%rdi),%rbx
    63e3:	4d 85 c9             	test   %r9,%r9
    63e6:	74 28                	je     6410 <ayatsuri_model_instance_next+0x130>
    63e8:	48 39 cb             	cmp    %rcx,%rbx
    63eb:	0f 82 13 02 00 00    	jb     6604 <ayatsuri_model_instance_next+0x324>
    63f1:	48 89 de             	mov    %rbx,%rsi
    63f4:	48 29 ce             	sub    %rcx,%rsi
    63f7:	48 83 fe 03          	cmp    $0x3,%rsi
    63fb:	0f 86 aa 01 00 00    	jbe    65ab <ayatsuri_model_instance_next+0x2cb>
    6401:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    6408:	00 00 00 00 
    640c:	0f 1f 40 00          	nopl   0x0(%rax)
    6410:	4d 39 c2             	cmp    %r8,%r10
    6413:	0f 82 7f 01 00 00    	jb     6598 <ayatsuri_model_instance_next+0x2b8>
    6419:	4c 89 d6             	mov    %r10,%rsi
    641c:	4c 29 c6             	sub    %r8,%rsi
    641f:	48 83 fe 17          	cmp    $0x17,%rsi
    6423:	0f 86 82 01 00 00    	jbe    65ab <ayatsuri_model_instance_next+0x2cb>
    6429:	4c 39 c7             	cmp    %r8,%rdi
    642c:	0f 82 e2 01 00 00    	jb     6614 <ayatsuri_model_instance_next+0x334>
    6432:	48 89 fe             	mov    %rdi,%rsi
    6435:	4c 29 c6             	sub    %r8,%rsi
    6438:	48 83 fe 17          	cmp    $0x17,%rsi
    643c:	0f 86 69 01 00 00    	jbe    65ab <ayatsuri_model_instance_next+0x2cb>
    6442:	48 85 c0             	test   %rax,%rax
    6445:	74 19                	je     6460 <ayatsuri_model_instance_next+0x180>
    6447:	4c 39 c2             	cmp    %r8,%rdx
    644a:	0f 82 d5 01 00 00    	jb     6625 <ayatsuri_model_instance_next+0x345>
    6450:	48 89 d0             	mov    %rdx,%rax
    6453:	4c 29 c0             	sub    %r8,%rax
    6456:	48 83 f8 17          	cmp    $0x17,%rax
    645a:	0f 86 4b 01 00 00    	jbe    65ab <ayatsuri_model_instance_next+0x2cb>
    6460:	4d 85 c9             	test   %r9,%r9
    6463:	74 19                	je     647e <ayatsuri_model_instance_next+0x19e>
    6465:	4c 39 c3             	cmp    %r8,%rbx
    6468:	0f 82 cb 01 00 00    	jb     6639 <ayatsuri_model_instance_next+0x359>
    646e:	48 89 d8             	mov    %rbx,%rax
    6471:	4c 29 c0             	sub    %r8,%rax
    6474:	48 83 f8 17          	cmp    $0x17,%rax
    6478:	0f 86 2d 01 00 00    	jbe    65ab <ayatsuri_model_instance_next+0x2cb>
    647e:	8b 29                	mov    (%rcx),%ebp
    6480:	0f b7 77 0c          	movzwl 0xc(%rdi),%esi
    6484:	39 ee                	cmp    %ebp,%esi
    6486:	0f 82 1f 01 00 00    	jb     65ab <ayatsuri_model_instance_next+0x2cb>
    648c:	39 f5                	cmp    %esi,%ebp
    648e:	0f 83 47 01 00 00    	jae    65db <ayatsuri_model_instance_next+0x2fb>
    6494:	44 8b 67 14          	mov    0x14(%rdi),%r12d
    6498:	89 e8                	mov    %ebp,%eax
    649a:	c1 e0 04             	shl    $0x4,%eax
    649d:	49 01 dc             	add    %rbx,%r12
    64a0:	49 01 c4             	add    %rax,%r12
    64a3:	89 e8                	mov    %ebp,%eax
    64a5:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
    64a9:	48 8d 44 c2 08       	lea    0x8(%rdx,%rax,8),%rax
    64ae:	66 90                	xchg   %ax,%ax
    64b0:	45 0f b6 6c 24 02    	movzbl 0x2(%r12),%r13d
    64b6:	45 84 ed             	test   %r13b,%r13b
    64b9:	0f 84 09 01 00 00    	je     65c8 <ayatsuri_model_instance_next+0x2e8>
    64bf:	80 78 09 00          	cmpb   $0x0,0x9(%rax)
    64c3:	0f 84 ff 00 00 00    	je     65c8 <ayatsuri_model_instance_next+0x2e8>
    64c9:	44 8b 30             	mov    (%rax),%r14d
    64cc:	49 01 d6             	add    %rdx,%r14
    64cf:	41 80 fd 03          	cmp    $0x3,%r13b
    64d3:	0f 85 74 01 00 00    	jne    664d <ayatsuri_model_instance_next+0x36d>
    64d9:	41 80 7e 55 00       	cmpb   $0x0,0x55(%r14)
    64de:	0f 84 e4 00 00 00    	je     65c8 <ayatsuri_model_instance_next+0x2e8>
    64e4:	89 ee                	mov    %ebp,%esi
    64e6:	4c 89 e2             	mov    %r12,%rdx
    64e9:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
    64ee:	41 bd 04 00 00 00    	mov    $0x4,%r13d
    64f4:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    64f9:	48 89 3c 24          	mov    %rdi,(%rsp)
    64fd:	e8 3e a2 ff ff       	call   740 <node_slot_bytes>
    6502:	48 8b 3c 24          	mov    (%rsp),%rdi
    6506:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
    650b:	89 ee                	mov    %ebp,%esi
    650d:	41 89 c3             	mov    %eax,%r11d
    6510:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
    6515:	4d 8d 4a 64          	lea    0x64(%r10),%r9
    6519:	8b 47 78             	mov    0x78(%rdi),%eax
    651c:	85 c0                	test   %eax,%eax
    651e:	74 1b                	je     653b <ayatsuri_model_instance_next+0x25b>
    6520:	41 0f b7 44 24 08    	movzwl 0x8(%r12),%eax
    6526:	8b 57 74             	mov    0x74(%rdi),%edx
    6529:	c1 e0 02             	shl    $0x2,%eax
    652c:	48 01 c3             	add    %rax,%rbx
    652f:	80 3c 13 01          	cmpb   $0x1,(%rbx,%rdx,1)
    6533:	41 0f 94 c5          	sete   %r13b
    6537:	41 83 c5 04          	add    $0x4,%r13d
    653b:	41 0f b7 44 24 06    	movzwl 0x6(%r12),%eax
    6541:	83 c5 01             	add    $0x1,%ebp
    6544:	4d 89 30             	mov    %r14,(%r8)
    6547:	4d 89 48 08          	mov    %r9,0x8(%r8)
    654b:	41 88 40 15          	mov    %al,0x15(%r8)
    654f:	31 c0                	xor    %eax,%eax
    6551:	66 41 89 70 10       	mov    %si,0x10(%r8)
    6556:	66 45 89 58 12       	mov    %r11w,0x12(%r8)
    655b:	45 88 68 14          	mov    %r13b,0x14(%r8)
    655f:	89 29                	mov    %ebp,(%rcx)
    6561:	41 c6 82 a5 00 00 00 	movb   $0x0,0xa5(%r10)
    6568:	00 
    6569:	48 83 c4 18          	add    $0x18,%rsp
    656d:	5b                   	pop    %rbx
    656e:	5d                   	pop    %rbp
    656f:	41 5c                	pop    %r12
    6571:	41 5d                	pop    %r13
    6573:	41 5e                	pop    %r14
    6575:	c3                   	ret
    6576:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    657d:	00 00 00 
    6580:	48 89 f8             	mov    %rdi,%rax
    6583:	48 29 c8             	sub    %rcx,%rax
    6586:	48 83 f8 03          	cmp    $0x3,%rax
    658a:	0f 86 c0 fd ff ff    	jbe    6350 <ayatsuri_model_instance_next+0x70>
    6590:	e9 11 fe ff ff       	jmp    63a6 <ayatsuri_model_instance_next+0xc6>
    6595:	0f 1f 00             	nopl   (%rax)
    6598:	4c 89 c6             	mov    %r8,%rsi
    659b:	4c 29 d6             	sub    %r10,%rsi
    659e:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    65a5:	0f 87 7e fe ff ff    	ja     6429 <ayatsuri_model_instance_next+0x149>
    65ab:	41 c6 82 a5 00 00 00 	movb   $0x0,0xa5(%r10)
    65b2:	00 
    65b3:	48 83 c4 18          	add    $0x18,%rsp
    65b7:	b8 01 00 00 00       	mov    $0x1,%eax
    65bc:	5b                   	pop    %rbx
    65bd:	5d                   	pop    %rbp
    65be:	41 5c                	pop    %r12
    65c0:	41 5d                	pop    %r13
    65c2:	41 5e                	pop    %r14
    65c4:	c3                   	ret
    65c5:	0f 1f 00             	nopl   (%rax)
    65c8:	83 c5 01             	add    $0x1,%ebp
    65cb:	49 83 c4 10          	add    $0x10,%r12
    65cf:	48 83 c0 18          	add    $0x18,%rax
    65d3:	39 ee                	cmp    %ebp,%esi
    65d5:	0f 85 d5 fe ff ff    	jne    64b0 <ayatsuri_model_instance_next+0x1d0>
    65db:	89 31                	mov    %esi,(%rcx)
    65dd:	b8 05 00 00 00       	mov    $0x5,%eax
    65e2:	41 c6 82 a5 00 00 00 	movb   $0x0,0xa5(%r10)
    65e9:	00 
    65ea:	e9 7a ff ff ff       	jmp    6569 <ayatsuri_model_instance_next+0x289>
    65ef:	90                   	nop
    65f0:	48 89 ce             	mov    %rcx,%rsi
    65f3:	48 29 d6             	sub    %rdx,%rsi
    65f6:	48 39 c6             	cmp    %rax,%rsi
    65f9:	0f 82 51 fd ff ff    	jb     6350 <ayatsuri_model_instance_next+0x70>
    65ff:	e9 cc fd ff ff       	jmp    63d0 <ayatsuri_model_instance_next+0xf0>
    6604:	48 89 ce             	mov    %rcx,%rsi
    6607:	48 29 de             	sub    %rbx,%rsi
    660a:	4c 39 ce             	cmp    %r9,%rsi
    660d:	72 9c                	jb     65ab <ayatsuri_model_instance_next+0x2cb>
    660f:	e9 fc fd ff ff       	jmp    6410 <ayatsuri_model_instance_next+0x130>
    6614:	4c 89 c6             	mov    %r8,%rsi
    6617:	48 29 fe             	sub    %rdi,%rsi
    661a:	48 83 fe 7f          	cmp    $0x7f,%rsi
    661e:	76 8b                	jbe    65ab <ayatsuri_model_instance_next+0x2cb>
    6620:	e9 1d fe ff ff       	jmp    6442 <ayatsuri_model_instance_next+0x162>
    6625:	4c 89 c6             	mov    %r8,%rsi
    6628:	48 29 d6             	sub    %rdx,%rsi
    662b:	48 39 c6             	cmp    %rax,%rsi
    662e:	0f 82 77 ff ff ff    	jb     65ab <ayatsuri_model_instance_next+0x2cb>
    6634:	e9 27 fe ff ff       	jmp    6460 <ayatsuri_model_instance_next+0x180>
    6639:	4c 89 c0             	mov    %r8,%rax
    663c:	48 29 d8             	sub    %rbx,%rax
    663f:	4c 39 c8             	cmp    %r9,%rax
    6642:	0f 82 63 ff ff ff    	jb     65ab <ayatsuri_model_instance_next+0x2cb>
    6648:	e9 31 fe ff ff       	jmp    647e <ayatsuri_model_instance_next+0x19e>
    664d:	89 ee                	mov    %ebp,%esi
    664f:	4c 89 e2             	mov    %r12,%rdx
    6652:	4c 89 44 24 08       	mov    %r8,0x8(%rsp)
    6657:	48 89 0c 24          	mov    %rcx,(%rsp)
    665b:	e8 e0 a0 ff ff       	call   740 <node_slot_bytes>
    6660:	41 80 fd 02          	cmp    $0x2,%r13b
    6664:	48 8b 0c 24          	mov    (%rsp),%rcx
    6668:	89 ee                	mov    %ebp,%esi
    666a:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
    666f:	89 c3                	mov    %eax,%ebx
    6671:	4d 8d 4a 64          	lea    0x64(%r10),%r9
    6675:	41 89 c3             	mov    %eax,%r11d
    6678:	0f 85 bd fe ff ff    	jne    653b <ayatsuri_model_instance_next+0x25b>
    667e:	4c 89 e7             	mov    %r12,%rdi
    6681:	e8 4a 9c ff ff       	call   2d0 <slot_bytes>
    6686:	39 d8                	cmp    %ebx,%eax
    6688:	0f 83 ad fe ff ff    	jae    653b <ayatsuri_model_instance_next+0x25b>
    668e:	41 bd 03 00 00 00    	mov    $0x3,%r13d
    6694:	e9 a2 fe ff ff       	jmp    653b <ayatsuri_model_instance_next+0x25b>
    6699:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

00000000000066a0 <ayatsuri_model_instance_mesh_view>:
    66a0:	48 89 f8             	mov    %rdi,%rax
    66a3:	48 85 ff             	test   %rdi,%rdi
    66a6:	0f 84 84 00 00 00    	je     6730 <ayatsuri_model_instance_mesh_view+0x90>
    66ac:	80 bf a4 00 00 00 01 	cmpb   $0x1,0xa4(%rdi)
    66b3:	75 7b                	jne    6730 <ayatsuri_model_instance_mesh_view+0x90>
    66b5:	48 85 f6             	test   %rsi,%rsi
    66b8:	74 76                	je     6730 <ayatsuri_model_instance_mesh_view+0x90>
    66ba:	48 3b 77 10          	cmp    0x10(%rdi),%rsi
    66be:	75 70                	jne    6730 <ayatsuri_model_instance_mesh_view+0x90>
    66c0:	3b 57 20             	cmp    0x20(%rdi),%edx
    66c3:	75 6b                	jne    6730 <ayatsuri_model_instance_mesh_view+0x90>
    66c5:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    66cc:	ba 04 00 00 00       	mov    $0x4,%edx
    66d1:	75 62                	jne    6735 <ayatsuri_model_instance_mesh_view+0x95>
    66d3:	80 bf a6 00 00 00 00 	cmpb   $0x0,0xa6(%rdi)
    66da:	c6 87 a5 00 00 00 01 	movb   $0x1,0xa5(%rdi)
    66e1:	74 45                	je     6728 <ayatsuri_model_instance_mesh_view+0x88>
    66e3:	4d 85 c0             	test   %r8,%r8
    66e6:	74 2e                	je     6716 <ayatsuri_model_instance_mesh_view+0x76>
    66e8:	48 8b 17             	mov    (%rdi),%rdx
    66eb:	66 3b 4a 0c          	cmp    0xc(%rdx),%cx
    66ef:	73 25                	jae    6716 <ayatsuri_model_instance_mesh_view+0x76>
    66f1:	4c 39 c7             	cmp    %r8,%rdi
    66f4:	73 4a                	jae    6740 <ayatsuri_model_instance_mesh_view+0xa0>
    66f6:	4c 89 c6             	mov    %r8,%rsi
    66f9:	48 29 fe             	sub    %rdi,%rsi
    66fc:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    6703:	76 11                	jbe    6716 <ayatsuri_model_instance_mesh_view+0x76>
    6705:	4c 39 c2             	cmp    %r8,%rdx
    6708:	72 46                	jb     6750 <ayatsuri_model_instance_mesh_view+0xb0>
    670a:	48 89 d6             	mov    %rdx,%rsi
    670d:	4c 29 c6             	sub    %r8,%rsi
    6710:	48 83 fe 17          	cmp    $0x17,%rsi
    6714:	77 46                	ja     675c <ayatsuri_model_instance_mesh_view+0xbc>
    6716:	ba 01 00 00 00       	mov    $0x1,%edx
    671b:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    6722:	89 d0                	mov    %edx,%eax
    6724:	c3                   	ret
    6725:	0f 1f 00             	nopl   (%rax)
    6728:	c6 87 a5 00 00 00 00 	movb   $0x0,0xa5(%rdi)
    672f:	90                   	nop
    6730:	ba 03 00 00 00       	mov    $0x3,%edx
    6735:	89 d0                	mov    %edx,%eax
    6737:	c3                   	ret
    6738:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    673f:	00 
    6740:	48 89 fe             	mov    %rdi,%rsi
    6743:	4c 29 c6             	sub    %r8,%rsi
    6746:	48 83 fe 17          	cmp    $0x17,%rsi
    674a:	76 ca                	jbe    6716 <ayatsuri_model_instance_mesh_view+0x76>
    674c:	eb b7                	jmp    6705 <ayatsuri_model_instance_mesh_view+0x65>
    674e:	66 90                	xchg   %ax,%ax
    6750:	4c 89 c6             	mov    %r8,%rsi
    6753:	48 29 d6             	sub    %rdx,%rsi
    6756:	48 83 fe 7f          	cmp    $0x7f,%rsi
    675a:	76 ba                	jbe    6716 <ayatsuri_model_instance_mesh_view+0x76>
    675c:	48 8b 70 18          	mov    0x18(%rax),%rsi
    6760:	48 8b 78 08          	mov    0x8(%rax),%rdi
    6764:	48 85 f6             	test   %rsi,%rsi
    6767:	74 17                	je     6780 <ayatsuri_model_instance_mesh_view+0xe0>
    6769:	4c 39 c7             	cmp    %r8,%rdi
    676c:	0f 82 de 00 00 00    	jb     6850 <ayatsuri_model_instance_mesh_view+0x1b0>
    6772:	48 89 fe             	mov    %rdi,%rsi
    6775:	4c 29 c6             	sub    %r8,%rsi
    6778:	48 83 fe 17          	cmp    $0x17,%rsi
    677c:	76 98                	jbe    6716 <ayatsuri_model_instance_mesh_view+0x76>
    677e:	66 90                	xchg   %ax,%ax
    6780:	8b 72 08             	mov    0x8(%rdx),%esi
    6783:	4c 8b 12             	mov    (%rdx),%r10
    6786:	48 85 f6             	test   %rsi,%rsi
    6789:	0f 85 a1 00 00 00    	jne    6830 <ayatsuri_model_instance_mesh_view+0x190>
    678f:	49 89 c9             	mov    %rcx,%r9
    6792:	8b 72 14             	mov    0x14(%rdx),%esi
    6795:	49 c1 e1 04          	shl    $0x4,%r9
    6799:	41 81 e1 f0 ff 0f 00 	and    $0xffff0,%r9d
    67a0:	4c 01 ce             	add    %r9,%rsi
    67a3:	4c 01 d6             	add    %r10,%rsi
    67a6:	80 7e 02 03          	cmpb   $0x3,0x2(%rsi)
    67aa:	0f 85 66 ff ff ff    	jne    6716 <ayatsuri_model_instance_mesh_view+0x76>
    67b0:	44 8b 4a 78          	mov    0x78(%rdx),%r9d
    67b4:	45 85 c9             	test   %r9d,%r9d
    67b7:	74 18                	je     67d1 <ayatsuri_model_instance_mesh_view+0x131>
    67b9:	0f b7 76 08          	movzwl 0x8(%rsi),%esi
    67bd:	8b 52 74             	mov    0x74(%rdx),%edx
    67c0:	c1 e6 02             	shl    $0x2,%esi
    67c3:	49 01 f2             	add    %rsi,%r10
    67c6:	41 80 3c 12 01       	cmpb   $0x1,(%r10,%rdx,1)
    67cb:	0f 84 45 ff ff ff    	je     6716 <ayatsuri_model_instance_mesh_view+0x76>
    67d1:	0f b7 d1             	movzwl %cx,%edx
    67d4:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
    67d8:	48 8d 14 d7          	lea    (%rdi,%rdx,8),%rdx
    67dc:	80 7a 11 00          	cmpb   $0x0,0x11(%rdx)
    67e0:	0f 84 30 ff ff ff    	je     6716 <ayatsuri_model_instance_mesh_view+0x76>
    67e6:	8b 52 08             	mov    0x8(%rdx),%edx
    67e9:	48 01 d7             	add    %rdx,%rdi
    67ec:	0f b6 77 54          	movzbl 0x54(%rdi),%esi
    67f0:	48 8d 57 54          	lea    0x54(%rdi),%rdx
    67f4:	66 41 89 48 10       	mov    %cx,0x10(%r8)
    67f9:	49 89 10             	mov    %rdx,(%r8)
    67fc:	48 8d 14 f5 00 00 00 	lea    0x0(,%rsi,8),%rdx
    6803:	00 
    6804:	41 88 70 12          	mov    %sil,0x12(%r8)
    6808:	81 e2 f8 07 00 00    	and    $0x7f8,%edx
    680e:	48 8d 94 17 64 04 00 	lea    0x464(%rdi,%rdx,1),%rdx
    6815:	00 
    6816:	49 89 50 08          	mov    %rdx,0x8(%r8)
    681a:	31 d2                	xor    %edx,%edx
    681c:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    6823:	e9 0d ff ff ff       	jmp    6735 <ayatsuri_model_instance_mesh_view+0x95>
    6828:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    682f:	00 
    6830:	4d 39 c2             	cmp    %r8,%r10
    6833:	72 33                	jb     6868 <ayatsuri_model_instance_mesh_view+0x1c8>
    6835:	4c 89 d6             	mov    %r10,%rsi
    6838:	4c 29 c6             	sub    %r8,%rsi
    683b:	48 83 fe 17          	cmp    $0x17,%rsi
    683f:	0f 86 d1 fe ff ff    	jbe    6716 <ayatsuri_model_instance_mesh_view+0x76>
    6845:	e9 45 ff ff ff       	jmp    678f <ayatsuri_model_instance_mesh_view+0xef>
    684a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    6850:	4d 89 c1             	mov    %r8,%r9
    6853:	49 29 f9             	sub    %rdi,%r9
    6856:	49 39 f1             	cmp    %rsi,%r9
    6859:	0f 82 b7 fe ff ff    	jb     6716 <ayatsuri_model_instance_mesh_view+0x76>
    685f:	e9 1c ff ff ff       	jmp    6780 <ayatsuri_model_instance_mesh_view+0xe0>
    6864:	0f 1f 40 00          	nopl   0x0(%rax)
    6868:	4d 89 c1             	mov    %r8,%r9
    686b:	4d 29 d1             	sub    %r10,%r9
    686e:	49 39 f1             	cmp    %rsi,%r9
    6871:	0f 83 18 ff ff ff    	jae    678f <ayatsuri_model_instance_mesh_view+0xef>
    6877:	e9 9a fe ff ff       	jmp    6716 <ayatsuri_model_instance_mesh_view+0x76>
    687c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000006880 <ayatsuri_model_instance_sided_mesh_view>:
    6880:	48 89 f8             	mov    %rdi,%rax
    6883:	48 85 ff             	test   %rdi,%rdi
    6886:	0f 84 84 00 00 00    	je     6910 <ayatsuri_model_instance_sided_mesh_view+0x90>
    688c:	80 bf a4 00 00 00 01 	cmpb   $0x1,0xa4(%rdi)
    6893:	75 7b                	jne    6910 <ayatsuri_model_instance_sided_mesh_view+0x90>
    6895:	48 85 f6             	test   %rsi,%rsi
    6898:	74 76                	je     6910 <ayatsuri_model_instance_sided_mesh_view+0x90>
    689a:	48 3b 77 10          	cmp    0x10(%rdi),%rsi
    689e:	75 70                	jne    6910 <ayatsuri_model_instance_sided_mesh_view+0x90>
    68a0:	3b 57 20             	cmp    0x20(%rdi),%edx
    68a3:	75 6b                	jne    6910 <ayatsuri_model_instance_sided_mesh_view+0x90>
    68a5:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    68ac:	ba 04 00 00 00       	mov    $0x4,%edx
    68b1:	75 62                	jne    6915 <ayatsuri_model_instance_sided_mesh_view+0x95>
    68b3:	80 bf a6 00 00 00 00 	cmpb   $0x0,0xa6(%rdi)
    68ba:	c6 87 a5 00 00 00 01 	movb   $0x1,0xa5(%rdi)
    68c1:	74 45                	je     6908 <ayatsuri_model_instance_sided_mesh_view+0x88>
    68c3:	4d 85 c0             	test   %r8,%r8
    68c6:	74 2e                	je     68f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    68c8:	48 8b 17             	mov    (%rdi),%rdx
    68cb:	66 3b 4a 0c          	cmp    0xc(%rdx),%cx
    68cf:	73 25                	jae    68f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    68d1:	4c 39 c7             	cmp    %r8,%rdi
    68d4:	73 4a                	jae    6920 <ayatsuri_model_instance_sided_mesh_view+0xa0>
    68d6:	4c 89 c6             	mov    %r8,%rsi
    68d9:	48 29 fe             	sub    %rdi,%rsi
    68dc:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    68e3:	76 11                	jbe    68f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    68e5:	4c 39 c2             	cmp    %r8,%rdx
    68e8:	72 46                	jb     6930 <ayatsuri_model_instance_sided_mesh_view+0xb0>
    68ea:	48 89 d6             	mov    %rdx,%rsi
    68ed:	4c 29 c6             	sub    %r8,%rsi
    68f0:	48 83 fe 27          	cmp    $0x27,%rsi
    68f4:	77 46                	ja     693c <ayatsuri_model_instance_sided_mesh_view+0xbc>
    68f6:	ba 01 00 00 00       	mov    $0x1,%edx
    68fb:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    6902:	89 d0                	mov    %edx,%eax
    6904:	c3                   	ret
    6905:	0f 1f 00             	nopl   (%rax)
    6908:	c6 87 a5 00 00 00 00 	movb   $0x0,0xa5(%rdi)
    690f:	90                   	nop
    6910:	ba 03 00 00 00       	mov    $0x3,%edx
    6915:	89 d0                	mov    %edx,%eax
    6917:	c3                   	ret
    6918:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    691f:	00 
    6920:	48 89 fe             	mov    %rdi,%rsi
    6923:	4c 29 c6             	sub    %r8,%rsi
    6926:	48 83 fe 27          	cmp    $0x27,%rsi
    692a:	76 ca                	jbe    68f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    692c:	eb b7                	jmp    68e5 <ayatsuri_model_instance_sided_mesh_view+0x65>
    692e:	66 90                	xchg   %ax,%ax
    6930:	4c 89 c6             	mov    %r8,%rsi
    6933:	48 29 d6             	sub    %rdx,%rsi
    6936:	48 83 fe 7f          	cmp    $0x7f,%rsi
    693a:	76 ba                	jbe    68f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    693c:	48 8b 78 18          	mov    0x18(%rax),%rdi
    6940:	48 8b 70 08          	mov    0x8(%rax),%rsi
    6944:	48 85 ff             	test   %rdi,%rdi
    6947:	74 17                	je     6960 <ayatsuri_model_instance_sided_mesh_view+0xe0>
    6949:	4c 39 c6             	cmp    %r8,%rsi
    694c:	0f 82 fe 00 00 00    	jb     6a50 <ayatsuri_model_instance_sided_mesh_view+0x1d0>
    6952:	48 89 f7             	mov    %rsi,%rdi
    6955:	4c 29 c7             	sub    %r8,%rdi
    6958:	48 83 ff 27          	cmp    $0x27,%rdi
    695c:	76 98                	jbe    68f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    695e:	66 90                	xchg   %ax,%ax
    6960:	8b 7a 08             	mov    0x8(%rdx),%edi
    6963:	4c 8b 0a             	mov    (%rdx),%r9
    6966:	48 85 ff             	test   %rdi,%rdi
    6969:	0f 85 c1 00 00 00    	jne    6a30 <ayatsuri_model_instance_sided_mesh_view+0x1b0>
    696f:	49 89 ca             	mov    %rcx,%r10
    6972:	8b 7a 14             	mov    0x14(%rdx),%edi
    6975:	49 c1 e2 04          	shl    $0x4,%r10
    6979:	41 81 e2 f0 ff 0f 00 	and    $0xffff0,%r10d
    6980:	4c 01 d7             	add    %r10,%rdi
    6983:	4c 01 cf             	add    %r9,%rdi
    6986:	80 7f 02 03          	cmpb   $0x3,0x2(%rdi)
    698a:	0f 85 66 ff ff ff    	jne    68f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6990:	44 8b 52 78          	mov    0x78(%rdx),%r10d
    6994:	45 85 d2             	test   %r10d,%r10d
    6997:	0f 84 59 ff ff ff    	je     68f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    699d:	0f b7 7f 08          	movzwl 0x8(%rdi),%edi
    69a1:	8b 52 74             	mov    0x74(%rdx),%edx
    69a4:	c1 e7 02             	shl    $0x2,%edi
    69a7:	49 01 f9             	add    %rdi,%r9
    69aa:	41 80 3c 11 01       	cmpb   $0x1,(%r9,%rdx,1)
    69af:	0f 85 41 ff ff ff    	jne    68f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    69b5:	0f b7 d1             	movzwl %cx,%edx
    69b8:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
    69bc:	48 8d 14 d6          	lea    (%rsi,%rdx,8),%rdx
    69c0:	80 7a 11 00          	cmpb   $0x0,0x11(%rdx)
    69c4:	0f 84 2c ff ff ff    	je     68f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    69ca:	44 8b 5a 08          	mov    0x8(%rdx),%r11d
    69ce:	4e 8d 0c 1e          	lea    (%rsi,%r11,1),%r9
    69d2:	41 0f b6 79 54       	movzbl 0x54(%r9),%edi
    69d7:	66 41 89 48 20       	mov    %cx,0x20(%r8)
    69dc:	8d 14 3f             	lea    (%rdi,%rdi,1),%edx
    69df:	41 89 fa             	mov    %edi,%r10d
    69e2:	01 d7                	add    %edx,%edi
    69e4:	48 63 d2             	movslq %edx,%rdx
    69e7:	45 88 50 22          	mov    %r10b,0x22(%r8)
    69eb:	8d 3c bd 6b 04 00 00 	lea    0x46b(,%rdi,4),%edi
    69f2:	81 e7 f8 1f 00 00    	and    $0x1ff8,%edi
    69f8:	4c 01 df             	add    %r11,%rdi
    69fb:	48 01 fe             	add    %rdi,%rsi
    69fe:	49 8d 79 54          	lea    0x54(%r9),%rdi
    6a02:	49 89 38             	mov    %rdi,(%r8)
    6a05:	49 8d bc 91 64 04 00 	lea    0x464(%r9,%rdx,4),%rdi
    6a0c:	00 
    6a0d:	48 8d 14 56          	lea    (%rsi,%rdx,2),%rdx
    6a11:	49 89 50 18          	mov    %rdx,0x18(%r8)
    6a15:	31 d2                	xor    %edx,%edx
    6a17:	49 89 78 08          	mov    %rdi,0x8(%r8)
    6a1b:	49 89 70 10          	mov    %rsi,0x10(%r8)
    6a1f:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    6a26:	e9 ea fe ff ff       	jmp    6915 <ayatsuri_model_instance_sided_mesh_view+0x95>
    6a2b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    6a30:	4d 39 c1             	cmp    %r8,%r9
    6a33:	72 33                	jb     6a68 <ayatsuri_model_instance_sided_mesh_view+0x1e8>
    6a35:	4c 89 cf             	mov    %r9,%rdi
    6a38:	4c 29 c7             	sub    %r8,%rdi
    6a3b:	48 83 ff 27          	cmp    $0x27,%rdi
    6a3f:	0f 86 b1 fe ff ff    	jbe    68f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6a45:	e9 25 ff ff ff       	jmp    696f <ayatsuri_model_instance_sided_mesh_view+0xef>
    6a4a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    6a50:	4d 89 c1             	mov    %r8,%r9
    6a53:	49 29 f1             	sub    %rsi,%r9
    6a56:	49 39 f9             	cmp    %rdi,%r9
    6a59:	0f 82 97 fe ff ff    	jb     68f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6a5f:	e9 fc fe ff ff       	jmp    6960 <ayatsuri_model_instance_sided_mesh_view+0xe0>
    6a64:	0f 1f 40 00          	nopl   0x0(%rax)
    6a68:	4d 89 c2             	mov    %r8,%r10
    6a6b:	4d 29 ca             	sub    %r9,%r10
    6a6e:	49 39 fa             	cmp    %rdi,%r10
    6a71:	0f 83 f8 fe ff ff    	jae    696f <ayatsuri_model_instance_sided_mesh_view+0xef>
    6a77:	e9 7a fe ff ff       	jmp    68f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
