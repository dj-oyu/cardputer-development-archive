
analysis/typed-stores/bounded_model.o:     file format elf64-x86-64


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
     802:	49 89 fb             	mov    %rdi,%r11
     805:	89 f0                	mov    %esi,%eax
     807:	41 56                	push   %r14
     809:	89 c6                	mov    %eax,%esi
     80b:	45 89 ce             	mov    %r9d,%r14d
     80e:	41 55                	push   %r13
     810:	c1 e6 04             	shl    $0x4,%esi
     813:	41 54                	push   %r12
     815:	55                   	push   %rbp
     816:	53                   	push   %rbx
     817:	48 81 ec 88 05 00 00 	sub    $0x588,%rsp
     81e:	48 8b 3f             	mov    (%rdi),%rdi
     821:	44 88 4c 24 73       	mov    %r9b,0x73(%rsp)
     826:	4c 8b 2f             	mov    (%rdi),%r13
     829:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
     82e:	8b 7f 14             	mov    0x14(%rdi),%edi
     831:	c7 44 24 64 00 00 00 	movl   $0x0,0x64(%rsp)
     838:	00 
     839:	48 01 f7             	add    %rsi,%rdi
     83c:	4c 01 ef             	add    %r13,%rdi
     83f:	80 7f 02 03          	cmpb   $0x3,0x2(%rdi)
     843:	0f b7 77 08          	movzwl 0x8(%rdi),%esi
     847:	0f 84 2b 04 00 00    	je     c78 <mesh_packet+0x478>
     84d:	49 8b 5b 08          	mov    0x8(%r11),%rbx
     851:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
     855:	66 0f ef ed          	pxor   %xmm5,%xmm5
     859:	66 0f ef ff          	pxor   %xmm7,%xmm7
     85d:	4c 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%r9
     864:	00 
     865:	66 45 0f ef c9       	pxor   %xmm9,%xmm9
     86a:	66 45 0f ef d2       	pxor   %xmm10,%xmm10
     86f:	8b 44 c3 08          	mov    0x8(%rbx,%rax,8),%eax
     873:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
     878:	66 0f ef f6          	pxor   %xmm6,%xmm6
     87c:	66 45 0f ef f6       	pxor   %xmm14,%xmm14
     881:	66 0f ef d2          	pxor   %xmm2,%xmm2
     885:	66 45 0f ef ff       	pxor   %xmm15,%xmm15
     88a:	4c 89 8c 24 e0 00 00 	mov    %r9,0xe0(%rsp)
     891:	00 
     892:	48 01 c3             	add    %rax,%rbx
     895:	f3 0f 5a 6b 14       	cvtss2sd 0x14(%rbx),%xmm5
     89a:	66 0f 28 cd          	movapd %xmm5,%xmm1
     89e:	f3 44 0f 5a 4b 18    	cvtss2sd 0x18(%rbx),%xmm9
     8a4:	f3 0f 5a 7b 28       	cvtss2sd 0x28(%rbx),%xmm7
     8a9:	66 41 0f 28 c1       	movapd %xmm9,%xmm0
     8ae:	f3 0f 5a 73 20       	cvtss2sd 0x20(%rbx),%xmm6
     8b3:	66 45 0f 28 d9       	movapd %xmm9,%xmm11
     8b8:	f3 44 0f 5a 53 24    	cvtss2sd 0x24(%rbx),%xmm10
     8be:	f2 0f 59 cf          	mulsd  %xmm7,%xmm1
     8c2:	f3 44 0f 5a 43 10    	cvtss2sd 0x10(%rbx),%xmm8
     8c8:	66 45 0f 28 e0       	movapd %xmm8,%xmm12
     8cd:	f3 44 0f 5a 33       	cvtss2sd (%rbx),%xmm14
     8d2:	f2 41 0f 59 c2       	mulsd  %xmm10,%xmm0
     8d7:	f3 0f 5a 53 04       	cvtss2sd 0x4(%rbx),%xmm2
     8dc:	f3 44 0f 5a 7b 08    	cvtss2sd 0x8(%rbx),%xmm15
     8e2:	f2 44 0f 59 e7       	mulsd  %xmm7,%xmm12
     8e7:	f2 44 0f 59 de       	mulsd  %xmm6,%xmm11
     8ec:	66 0f 28 d9          	movapd %xmm1,%xmm3
     8f0:	66 41 0f 28 c8       	movapd %xmm8,%xmm1
     8f5:	f2 0f 5c d8          	subsd  %xmm0,%xmm3
     8f9:	f2 41 0f 59 ca       	mulsd  %xmm10,%xmm1
     8fe:	66 0f 28 c5          	movapd %xmm5,%xmm0
     902:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
     906:	f2 44 0f 11 64 24 18 	movsd  %xmm12,0x18(%rsp)
     90d:	f2 44 0f 11 5c 24 40 	movsd  %xmm11,0x40(%rsp)
     914:	f2 0f 11 5c 24 08    	movsd  %xmm3,0x8(%rsp)
     91a:	f2 41 0f 59 de       	mulsd  %xmm14,%xmm3
     91f:	f2 0f 5c c8          	subsd  %xmm0,%xmm1
     923:	66 41 0f 28 c4       	movapd %xmm12,%xmm0
     928:	f2 41 0f 5c c3       	subsd  %xmm11,%xmm0
     92d:	66 0f 28 e3          	movapd %xmm3,%xmm4
     931:	f2 0f 10 1d 00 00 00 	movsd  0x0(%rip),%xmm3        # 939 <mesh_packet+0x139>
     938:	00 
			935: R_X86_64_PC32	.LC22-0x4
     939:	f2 0f 11 4c 24 20    	movsd  %xmm1,0x20(%rsp)
     93f:	f2 41 0f 59 cf       	mulsd  %xmm15,%xmm1
     944:	f2 0f 59 c2          	mulsd  %xmm2,%xmm0
     948:	f2 0f 5c e0          	subsd  %xmm0,%xmm4
     94c:	f2 0f 58 e1          	addsd  %xmm1,%xmm4
     950:	66 0f 28 c4          	movapd %xmm4,%xmm0
     954:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 95c <mesh_packet+0x15c>
     95b:	00 
			958: R_X86_64_PC32	.LC8-0x4
     95c:	66 0f 2e d8          	ucomisd %xmm0,%xmm3
     960:	0f 82 fa 02 00 00    	jb     c60 <mesh_packet+0x460>
     966:	66 0f ef c0          	pxor   %xmm0,%xmm0
     96a:	66 0f 2e e0          	ucomisd %xmm0,%xmm4
     96e:	7a 06                	jp     976 <mesh_packet+0x176>
     970:	0f 84 ea 02 00 00    	je     c60 <mesh_packet+0x460>
     976:	f3 44 0f 10 1d 00 00 	movss  0x0(%rip),%xmm11        # 97f <mesh_packet+0x17f>
     97d:	00 00 
			97b: R_X86_64_PC32	.LC0-0x4
     97f:	44 0f b7 57 04       	movzwl 0x4(%rdi),%r10d
     984:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
     989:	8b 47 54             	mov    0x54(%rdi),%eax
     98c:	41 c1 e2 05          	shl    $0x5,%r10d
     990:	49 01 c2             	add    %rax,%r10
     993:	4f 8d 7c 15 00       	lea    0x0(%r13,%r10,1),%r15
     998:	44 8b 57 34          	mov    0x34(%rdi),%r10d
     99c:	41 0f b7 47 02       	movzwl 0x2(%r15),%eax
     9a1:	66 89 84 24 04 01 00 	mov    %ax,0x104(%rsp)
     9a8:	00 
     9a9:	41 0f b7 47 06       	movzwl 0x6(%r15),%eax
     9ae:	66 89 84 24 06 01 00 	mov    %ax,0x106(%rsp)
     9b5:	00 
     9b6:	45 84 f6             	test   %r14b,%r14b
     9b9:	0f 85 9b 01 00 00    	jne    b5a <mesh_packet+0x35a>
     9bf:	f3 0f 10 43 0c       	movss  0xc(%rbx),%xmm0
     9c4:	f3 44 0f 10 6b 1c    	movss  0x1c(%rbx),%xmm13
     9ca:	48 89 8c 24 88 03 00 	mov    %rcx,0x388(%rsp)
     9d1:	00 
     9d2:	31 c9                	xor    %ecx,%ecx
     9d4:	f3 41 0f 5c 43 34    	subss  0x34(%r11),%xmm0
     9da:	f3 45 0f 5c 6b 38    	subss  0x38(%r11),%xmm13
     9e0:	4c 89 7c 24 50       	mov    %r15,0x50(%rsp)
     9e5:	45 89 d7             	mov    %r10d,%r15d
     9e8:	4c 89 84 24 90 03 00 	mov    %r8,0x390(%rsp)
     9ef:	00 
     9f0:	4c 8d 4b 0c          	lea    0xc(%rbx),%r9
     9f4:	41 89 ca             	mov    %ecx,%r10d
     9f7:	4c 8d 84 24 50 01 00 	lea    0x150(%rsp),%r8
     9fe:	00 
     9ff:	f3 44 0f 10 63 2c    	movss  0x2c(%rbx),%xmm12
     a05:	48 89 94 24 80 03 00 	mov    %rdx,0x380(%rsp)
     a0c:	00 
     a0d:	4c 89 c7             	mov    %r8,%rdi
     a10:	4c 8d a4 24 80 03 00 	lea    0x380(%rsp),%r12
     a17:	00 
     a18:	f3 45 0f 5c 63 3c    	subss  0x3c(%r11),%xmm12
     a1e:	4c 89 44 24 68       	mov    %r8,0x68(%rsp)
     a23:	f3 0f 11 44 24 30    	movss  %xmm0,0x30(%rsp)
     a29:	f3 44 0f 11 6c 24 60 	movss  %xmm13,0x60(%rsp)
     a30:	f2 0f 11 54 24 48    	movsd  %xmm2,0x48(%rsp)
     a36:	48 83 f9 02          	cmp    $0x2,%rcx
     a3a:	0f 84 af 00 00 00    	je     aef <mesh_packet+0x2ef>
     a40:	f3 45 0f 10 5b 40    	movss  0x40(%r11),%xmm11
     a46:	49 8b 14 cc          	mov    (%r12,%rcx,8),%rdx
     a4a:	41 c1 e2 02          	shl    $0x2,%r10d
     a4e:	f3 0f 10 1a          	movss  (%rdx),%xmm3
     a52:	f3 0f 10 4a 04       	movss  0x4(%rdx),%xmm1
     a57:	f3 0f 10 52 08       	movss  0x8(%rdx),%xmm2
     a5c:	48 89 da             	mov    %rbx,%rdx
     a5f:	f3 44 0f 10 2a       	movss  (%rdx),%xmm13
     a64:	f3 0f 10 42 10       	movss  0x10(%rdx),%xmm0
     a69:	44 89 d0             	mov    %r10d,%eax
     a6c:	48 83 c2 04          	add    $0x4,%rdx
     a70:	41 83 c2 01          	add    $0x1,%r10d
     a74:	f3 44 0f 59 eb       	mulss  %xmm3,%xmm13
     a79:	f3 0f 59 c1          	mulss  %xmm1,%xmm0
     a7d:	f3 41 0f 58 c5       	addss  %xmm13,%xmm0
     a82:	f3 44 0f 10 6a 1c    	movss  0x1c(%rdx),%xmm13
     a88:	f3 44 0f 59 ea       	mulss  %xmm2,%xmm13
     a8d:	f3 41 0f 58 c5       	addss  %xmm13,%xmm0
     a92:	f3 41 0f 59 c3       	mulss  %xmm11,%xmm0
     a97:	f3 0f 11 84 84 50 01 	movss  %xmm0,0x150(%rsp,%rax,4)
     a9e:	00 00 
     aa0:	49 39 d1             	cmp    %rdx,%r9
     aa3:	75 ba                	jne    a5f <mesh_packet+0x25f>
     aa5:	f3 0f 59 5c 24 30    	mulss  0x30(%rsp),%xmm3
     aab:	48 83 c1 01          	add    $0x1,%rcx
     aaf:	48 83 c7 10          	add    $0x10,%rdi
     ab3:	f3 0f 59 4c 24 60    	mulss  0x60(%rsp),%xmm1
     ab9:	f3 41 0f 59 d4       	mulss  %xmm12,%xmm2
     abe:	f3 0f 58 cb          	addss  %xmm3,%xmm1
     ac2:	f3 0f 58 ca          	addss  %xmm2,%xmm1
     ac6:	f3 41 0f 59 cb       	mulss  %xmm11,%xmm1
     acb:	f3 0f 11 4f fc       	movss  %xmm1,-0x4(%rdi)
     ad0:	48 83 f9 03          	cmp    $0x3,%rcx
     ad4:	74 2a                	je     b00 <mesh_packet+0x300>
     ad6:	f3 41 0f 58 4c 8b 40 	addss  0x40(%r11,%rcx,4),%xmm1
     add:	41 89 ca             	mov    %ecx,%r10d
     ae0:	f3 0f 11 4f fc       	movss  %xmm1,-0x4(%rdi)
     ae5:	48 83 f9 02          	cmp    $0x2,%rcx
     ae9:	0f 85 51 ff ff ff    	jne    a40 <mesh_packet+0x240>
     aef:	f3 44 0f 10 1d 00 00 	movss  0x0(%rip),%xmm11        # af8 <mesh_packet+0x2f8>
     af6:	00 00 
			af4: R_X86_64_PC32	.LC15-0x4
     af8:	e9 49 ff ff ff       	jmp    a46 <mesh_packet+0x246>
     afd:	0f 1f 00             	nopl   (%rax)
     b00:	45 89 fa             	mov    %r15d,%r10d
     b03:	f2 0f 10 54 24 48    	movsd  0x48(%rsp),%xmm2
     b09:	4c 8b 7c 24 50       	mov    0x50(%rsp),%r15
     b0e:	49 83 c0 30          	add    $0x30,%r8
     b12:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
     b17:	f3 0f 10 0d 00 00 00 	movss  0x0(%rip),%xmm1        # b1f <mesh_packet+0x31f>
     b1e:	00 
			b1b: R_X86_64_PC32	.LC1-0x4
     b1f:	f3 44 0f 10 1d 00 00 	movss  0x0(%rip),%xmm11        # b28 <mesh_packet+0x328>
     b26:	00 00 
			b24: R_X86_64_PC32	.LC0-0x4
     b28:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     b2f:	00 00 00 00 
     b33:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     b3a:	00 00 00 00 
     b3e:	66 90                	xchg   %ax,%ax
     b40:	f3 0f 10 00          	movss  (%rax),%xmm0
     b44:	41 0f 54 c3          	andps  %xmm11,%xmm0
     b48:	0f 2e c8             	ucomiss %xmm0,%xmm1
     b4b:	0f 82 0f 01 00 00    	jb     c60 <mesh_packet+0x460>
     b51:	48 83 c0 04          	add    $0x4,%rax
     b55:	49 39 c0             	cmp    %rax,%r8
     b58:	75 e6                	jne    b40 <mesh_packet+0x340>
     b5a:	48 8d 04 f6          	lea    (%rsi,%rsi,8),%rax
     b5e:	44 89 d2             	mov    %r10d,%edx
     b61:	f2 0f 11 b4 24 c0 00 	movsd  %xmm6,0xc0(%rsp)
     b68:	00 00 
     b6a:	f3 41 0f 10 73 68    	movss  0x68(%r11),%xmm6
     b70:	48 8d 04 c2          	lea    (%rdx,%rax,8),%rax
     b74:	f3 41 0f 10 4b 64    	movss  0x64(%r11),%xmm1
     b7a:	f2 0f 11 ac 24 a8 00 	movsd  %xmm5,0xa8(%rsp)
     b81:	00 00 
     b83:	f3 41 0f 10 6b 6c    	movss  0x6c(%r11),%xmm5
     b89:	4c 01 e8             	add    %r13,%rax
     b8c:	4c 89 5c 24 68       	mov    %r11,0x68(%rsp)
     b91:	f3 0f 6f 00          	movdqu (%rax),%xmm0
     b95:	f3 0f 11 4c 24 30    	movss  %xmm1,0x30(%rsp)
     b9b:	f2 0f 11 bc 24 e8 00 	movsd  %xmm7,0xe8(%rsp)
     ba2:	00 00 
     ba4:	0f 28 fe             	movaps %xmm6,%xmm7
     ba7:	0f 29 84 24 30 01 00 	movaps %xmm0,0x130(%rsp)
     bae:	00 
     baf:	f3 0f 6f 40 10       	movdqu 0x10(%rax),%xmm0
     bb4:	41 0f 54 fb          	andps  %xmm11,%xmm7
     bb8:	0f 28 cf             	movaps %xmm7,%xmm1
     bbb:	f3 0f 11 74 24 60    	movss  %xmm6,0x60(%rsp)
     bc1:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
     bc8:	00 
     bc9:	0f 28 c5             	movaps %xmm5,%xmm0
     bcc:	41 0f 54 c3          	andps  %xmm11,%xmm0
     bd0:	f3 0f 11 6c 24 48    	movss  %xmm5,0x48(%rsp)
     bd6:	f2 0f 11 a4 24 f0 00 	movsd  %xmm4,0xf0(%rsp)
     bdd:	00 00 
     bdf:	f2 44 0f 11 94 24 d0 	movsd  %xmm10,0xd0(%rsp)
     be6:	00 00 00 
     be9:	f2 44 0f 11 8c 24 b0 	movsd  %xmm9,0xb0(%rsp)
     bf0:	00 00 00 
     bf3:	f2 44 0f 11 84 24 a0 	movsd  %xmm8,0xa0(%rsp)
     bfa:	00 00 00 
     bfd:	f2 44 0f 11 bc 24 98 	movsd  %xmm15,0x98(%rsp)
     c04:	00 00 00 
     c07:	f2 0f 11 94 24 90 00 	movsd  %xmm2,0x90(%rsp)
     c0e:	00 00 
     c10:	f2 44 0f 11 74 24 78 	movsd  %xmm14,0x78(%rsp)
     c17:	44 0f 29 5c 24 50    	movaps %xmm11,0x50(%rsp)
     c1d:	e8 00 00 00 00       	call   c22 <mesh_packet+0x422>
			c1e: R_X86_64_PLT32	fmaxf-0x4
     c22:	44 0f 28 5c 24 50    	movaps 0x50(%rsp),%xmm11
     c28:	f3 0f 10 4c 24 30    	movss  0x30(%rsp),%xmm1
     c2e:	41 0f 54 cb          	andps  %xmm11,%xmm1
     c32:	e8 00 00 00 00       	call   c37 <mesh_packet+0x437>
			c33: R_X86_64_PLT32	fmaxf-0x4
     c37:	66 0f ef db          	pxor   %xmm3,%xmm3
     c3b:	0f 2f c3             	comiss %xmm3,%xmm0
     c3e:	76 20                	jbe    c60 <mesh_packet+0x460>
     c40:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # c48 <mesh_packet+0x448>
     c47:	00 
			c44: R_X86_64_PC32	.LC1-0x4
     c48:	f3 0f 11 44 24 74    	movss  %xmm0,0x74(%rsp)
     c4e:	0f 2e d8             	ucomiss %xmm0,%xmm3
     c51:	73 65                	jae    cb8 <mesh_packet+0x4b8>
     c53:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     c5a:	00 00 00 00 
     c5e:	66 90                	xchg   %ax,%ax
     c60:	31 c0                	xor    %eax,%eax
     c62:	48 81 c4 88 05 00 00 	add    $0x588,%rsp
     c69:	5b                   	pop    %rbx
     c6a:	5d                   	pop    %rbp
     c6b:	41 5c                	pop    %r12
     c6d:	41 5d                	pop    %r13
     c6f:	41 5e                	pop    %r14
     c71:	41 5f                	pop    %r15
     c73:	c3                   	ret
     c74:	0f 1f 40 00          	nopl   0x0(%rax)
     c78:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
     c7d:	44 8b 53 78          	mov    0x78(%rbx),%r10d
     c81:	45 85 d2             	test   %r10d,%r10d
     c84:	0f 84 c3 fb ff ff    	je     84d <mesh_packet+0x4d>
     c8a:	44 8b 53 74          	mov    0x74(%rbx),%r10d
     c8e:	4c 8d 0c b5 00 00 00 	lea    0x0(,%rsi,4),%r9
     c95:	00 
     c96:	31 db                	xor    %ebx,%ebx
     c98:	41 81 e1 fc ff 03 00 	and    $0x3fffc,%r9d
     c9f:	4d 01 ea             	add    %r13,%r10
     ca2:	43 80 3c 0a 01       	cmpb   $0x1,(%r10,%r9,1)
     ca7:	0f 94 c3             	sete   %bl
     caa:	89 5c 24 64          	mov    %ebx,0x64(%rsp)
     cae:	e9 9a fb ff ff       	jmp    84d <mesh_packet+0x4d>
     cb3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
     cb8:	4c 8b 5c 24 68       	mov    0x68(%rsp),%r11
     cbd:	44 0f 28 5c 24 50    	movaps 0x50(%rsp),%xmm11
     cc3:	f3 41 0f 10 5b 70    	movss  0x70(%r11),%xmm3
     cc9:	45 8b 63 74          	mov    0x74(%r11),%r12d
     ccd:	4c 89 9c 24 f8 00 00 	mov    %r11,0xf8(%rsp)
     cd4:	00 
     cd5:	f3 0f 11 5c 24 68    	movss  %xmm3,0x68(%rsp)
     cdb:	66 41 0f 6e e4       	movd   %r12d,%xmm4
     ce0:	f3 41 0f 10 5b 78    	movss  0x78(%r11),%xmm3
     ce6:	41 0f 54 e3          	andps  %xmm11,%xmm4
     cea:	f3 0f 11 9c 24 80 00 	movss  %xmm3,0x80(%rsp)
     cf1:	00 00 
     cf3:	0f 28 cc             	movaps %xmm4,%xmm1
     cf6:	0f 28 e3             	movaps %xmm3,%xmm4
     cf9:	41 0f 54 e3          	andps  %xmm11,%xmm4
     cfd:	0f 28 c4             	movaps %xmm4,%xmm0
     d00:	e8 00 00 00 00       	call   d05 <mesh_packet+0x505>
			d01: R_X86_64_PLT32	fmaxf-0x4
     d05:	44 0f 28 5c 24 50    	movaps 0x50(%rsp),%xmm11
     d0b:	f3 0f 10 5c 24 68    	movss  0x68(%rsp),%xmm3
     d11:	41 0f 54 db          	andps  %xmm11,%xmm3
     d15:	0f 28 cb             	movaps %xmm3,%xmm1
     d18:	e8 00 00 00 00       	call   d1d <mesh_packet+0x51d>
			d19: R_X86_64_PLT32	fmaxf-0x4
     d1d:	66 0f ef e4          	pxor   %xmm4,%xmm4
     d21:	0f 2f c4             	comiss %xmm4,%xmm0
     d24:	44 0f 28 e8          	movaps %xmm0,%xmm13
     d28:	0f 86 32 ff ff ff    	jbe    c60 <mesh_packet+0x460>
     d2e:	f3 0f 10 25 00 00 00 	movss  0x0(%rip),%xmm4        # d36 <mesh_packet+0x536>
     d35:	00 
			d32: R_X86_64_PC32	.LC1-0x4
     d36:	0f 2e e0             	ucomiss %xmm0,%xmm4
     d39:	0f 82 21 ff ff ff    	jb     c60 <mesh_packet+0x460>
     d3f:	f3 44 0f 10 64 24 74 	movss  0x74(%rsp),%xmm12
     d46:	f3 0f 10 4c 24 30    	movss  0x30(%rsp),%xmm1
     d4c:	f3 0f 10 6c 24 48    	movss  0x48(%rsp),%xmm5
     d52:	44 0f 28 5c 24 50    	movaps 0x50(%rsp),%xmm11
     d58:	f3 0f 10 9c 24 80 00 	movss  0x80(%rsp),%xmm3
     d5f:	00 00 
     d61:	f3 41 0f 5e cc       	divss  %xmm12,%xmm1
     d66:	44 0f 29 5c 24 30    	movaps %xmm11,0x30(%rsp)
     d6c:	f3 41 0f 5e ec       	divss  %xmm12,%xmm5
     d71:	0f 28 c1             	movaps %xmm1,%xmm0
     d74:	f3 0f 10 4c 24 60    	movss  0x60(%rsp),%xmm1
     d7a:	0f 28 f0             	movaps %xmm0,%xmm6
     d7d:	f3 0f 59 f0          	mulss  %xmm0,%xmm6
     d81:	f3 41 0f 5e cc       	divss  %xmm12,%xmm1
     d86:	f3 41 0f 5e dd       	divss  %xmm13,%xmm3
     d8b:	0f 28 f9             	movaps %xmm1,%xmm7
     d8e:	0f 28 e1             	movaps %xmm1,%xmm4
     d91:	f3 0f 59 f9          	mulss  %xmm1,%xmm7
     d95:	44 0f 28 e7          	movaps %xmm7,%xmm12
     d99:	0f 28 fd             	movaps %xmm5,%xmm7
     d9c:	f3 0f 59 fd          	mulss  %xmm5,%xmm7
     da0:	f3 44 0f 58 e6       	addss  %xmm6,%xmm12
     da5:	66 41 0f 6e f4       	movd   %r12d,%xmm6
     daa:	f3 41 0f 5e f5       	divss  %xmm13,%xmm6
     daf:	f3 44 0f 58 e7       	addss  %xmm7,%xmm12
     db4:	0f 28 f8             	movaps %xmm0,%xmm7
     db7:	0f 28 cb             	movaps %xmm3,%xmm1
     dba:	f3 45 0f 51 e4       	sqrtss %xmm12,%xmm12
     dbf:	f3 41 0f 5e e4       	divss  %xmm12,%xmm4
     dc4:	0f 28 c6             	movaps %xmm6,%xmm0
     dc7:	f3 0f 59 c6          	mulss  %xmm6,%xmm0
     dcb:	f3 41 0f 5e fc       	divss  %xmm12,%xmm7
     dd0:	f3 0f 11 a4 24 88 00 	movss  %xmm4,0x88(%rsp)
     dd7:	00 00 
     dd9:	f3 41 0f 5e ec       	divss  %xmm12,%xmm5
     dde:	f3 44 0f 10 64 24 68 	movss  0x68(%rsp),%xmm12
     de5:	f3 0f 11 bc 24 84 00 	movss  %xmm7,0x84(%rsp)
     dec:	00 00 
     dee:	f3 45 0f 5e e5       	divss  %xmm13,%xmm12
     df3:	f3 0f 11 ac 24 8c 00 	movss  %xmm5,0x8c(%rsp)
     dfa:	00 00 
     dfc:	45 0f 28 ec          	movaps %xmm12,%xmm13
     e00:	f3 45 0f 59 ec       	mulss  %xmm12,%xmm13
     e05:	f3 41 0f 58 c5       	addss  %xmm13,%xmm0
     e0a:	44 0f 28 eb          	movaps %xmm3,%xmm13
     e0e:	f3 44 0f 59 eb       	mulss  %xmm3,%xmm13
     e13:	f3 41 0f 58 c5       	addss  %xmm13,%xmm0
     e18:	f3 0f 51 c0          	sqrtss %xmm0,%xmm0
     e1c:	f3 0f 5e f0          	divss  %xmm0,%xmm6
     e20:	f3 44 0f 5e e0       	divss  %xmm0,%xmm12
     e25:	f3 0f 5e c8          	divss  %xmm0,%xmm1
     e29:	f3 44 0f 58 e7       	addss  %xmm7,%xmm12
     e2e:	0f 28 fe             	movaps %xmm6,%xmm7
     e31:	f3 0f 58 fc          	addss  %xmm4,%xmm7
     e35:	f3 44 0f 11 64 24 68 	movss  %xmm12,0x68(%rsp)
     e3c:	f3 0f 11 7c 24 74    	movss  %xmm7,0x74(%rsp)
     e42:	f3 0f 58 cd          	addss  %xmm5,%xmm1
     e46:	0f 28 e9             	movaps %xmm1,%xmm5
     e49:	0f 28 cf             	movaps %xmm7,%xmm1
     e4c:	f3 0f 11 ac 24 80 00 	movss  %xmm5,0x80(%rsp)
     e53:	00 00 
     e55:	0f 28 c5             	movaps %xmm5,%xmm0
     e58:	41 0f 54 cb          	andps  %xmm11,%xmm1
     e5c:	41 0f 54 c3          	andps  %xmm11,%xmm0
     e60:	e8 00 00 00 00       	call   e65 <mesh_packet+0x665>
			e61: R_X86_64_PLT32	fmaxf-0x4
     e65:	44 0f 28 5c 24 30    	movaps 0x30(%rsp),%xmm11
     e6b:	f3 0f 10 4c 24 68    	movss  0x68(%rsp),%xmm1
     e71:	41 0f 54 cb          	andps  %xmm11,%xmm1
     e75:	e8 00 00 00 00       	call   e7a <mesh_packet+0x67a>
			e76: R_X86_64_PLT32	fmaxf-0x4
     e7a:	66 0f ef f6          	pxor   %xmm6,%xmm6
     e7e:	4c 8b 9c 24 f8 00 00 	mov    0xf8(%rsp),%r11
     e85:	00 
     e86:	f2 44 0f 10 74 24 78 	movsd  0x78(%rsp),%xmm14
     e8d:	f2 0f 10 94 24 90 00 	movsd  0x90(%rsp),%xmm2
     e94:	00 00 
     e96:	0f 2f c6             	comiss %xmm6,%xmm0
     e99:	f2 44 0f 10 bc 24 98 	movsd  0x98(%rsp),%xmm15
     ea0:	00 00 00 
     ea3:	f2 44 0f 10 84 24 a0 	movsd  0xa0(%rsp),%xmm8
     eaa:	00 00 00 
     ead:	f2 0f 10 ac 24 a8 00 	movsd  0xa8(%rsp),%xmm5
     eb4:	00 00 
     eb6:	f2 44 0f 10 8c 24 b0 	movsd  0xb0(%rsp),%xmm9
     ebd:	00 00 00 
     ec0:	f2 0f 10 b4 24 c0 00 	movsd  0xc0(%rsp),%xmm6
     ec7:	00 00 
     ec9:	f2 44 0f 10 94 24 d0 	movsd  0xd0(%rsp),%xmm10
     ed0:	00 00 00 
     ed3:	f2 0f 10 bc 24 e8 00 	movsd  0xe8(%rsp),%xmm7
     eda:	00 00 
     edc:	f2 0f 10 a4 24 f0 00 	movsd  0xf0(%rsp),%xmm4
     ee3:	00 00 
     ee5:	0f 86 ad 0b 00 00    	jbe    1a98 <mesh_packet+0x1298>
     eeb:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # ef3 <mesh_packet+0x6f3>
     ef2:	00 
			eef: R_X86_64_PC32	.LC1-0x4
     ef3:	c6 44 24 78 00       	movb   $0x0,0x78(%rsp)
     ef8:	0f 2e d8             	ucomiss %xmm0,%xmm3
     efb:	0f 83 f1 09 00 00    	jae    18f2 <mesh_packet+0x10f2>
     f01:	0f b7 84 24 04 01 00 	movzwl 0x104(%rsp),%eax
     f08:	00 
     f09:	48 8d 8b 64 04 00 00 	lea    0x464(%rbx),%rcx
     f10:	48 89 8c 24 e8 00 00 	mov    %rcx,0xe8(%rsp)
     f17:	00 
     f18:	89 84 24 90 00 00 00 	mov    %eax,0x90(%rsp)
     f1f:	01 c0                	add    %eax,%eax
     f21:	89 c0                	mov    %eax,%eax
     f23:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
     f2a:	00 
     f2b:	48 89 c2             	mov    %rax,%rdx
     f2e:	4c 8d 14 81          	lea    (%rcx,%rax,4),%r10
     f32:	45 84 f6             	test   %r14b,%r14b
     f35:	0f 84 55 06 00 00    	je     1590 <mesh_packet+0xd90>
     f3b:	8b b4 24 90 00 00 00 	mov    0x90(%rsp),%esi
     f42:	4c 8d 43 5c          	lea    0x5c(%rbx),%r8
     f46:	85 f6                	test   %esi,%esi
     f48:	0f 84 40 0b 00 00    	je     1a8e <mesh_packet+0x128e>
     f4e:	66 41 0f 28 c7       	movapd %xmm15,%xmm0
     f53:	66 0f 28 ca          	movapd %xmm2,%xmm1
     f57:	49 8d 43 64          	lea    0x64(%r11),%rax
     f5b:	45 31 e4             	xor    %r12d,%r12d
     f5e:	f2 0f 59 cf          	mulsd  %xmm7,%xmm1
     f62:	66 41 0f 28 df       	movapd %xmm15,%xmm3
     f67:	4c 89 ee             	mov    %r13,%rsi
     f6a:	4c 89 54 24 50       	mov    %r10,0x50(%rsp)
     f6f:	f2 41 0f 59 c2       	mulsd  %xmm10,%xmm0
     f74:	4c 89 94 24 08 01 00 	mov    %r10,0x108(%rsp)
     f7b:	00 
     f7c:	f2 0f 59 de          	mulsd  %xmm6,%xmm3
     f80:	48 89 9c 24 18 01 00 	mov    %rbx,0x118(%rsp)
     f87:	00 
     f88:	f2 41 0f 59 fe       	mulsd  %xmm14,%xmm7
     f8d:	4c 89 9c 24 f0 00 00 	mov    %r11,0xf0(%rsp)
     f94:	00 
     f95:	f2 0f 59 f2          	mulsd  %xmm2,%xmm6
     f99:	44 89 b4 24 20 01 00 	mov    %r14d,0x120(%rsp)
     fa0:	00 
     fa1:	f2 45 0f 59 d6       	mulsd  %xmm14,%xmm10
     fa6:	89 94 24 24 01 00 00 	mov    %edx,0x124(%rsp)
     fad:	f2 0f 11 a4 24 10 01 	movsd  %xmm4,0x110(%rsp)
     fb4:	00 00 
     fb6:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
     fba:	f2 0f 10 4c 24 08    	movsd  0x8(%rsp),%xmm1
     fc0:	f2 0f 5c fb          	subsd  %xmm3,%xmm7
     fc4:	66 0f 14 c8          	unpcklpd %xmm0,%xmm1
     fc8:	66 0f 28 c4          	movapd %xmm4,%xmm0
     fcc:	66 0f 14 c0          	unpcklpd %xmm0,%xmm0
     fd0:	f2 41 0f 5c f2       	subsd  %xmm10,%xmm6
     fd5:	66 0f 5e c8          	divpd  %xmm0,%xmm1
     fd9:	0f 29 8c 24 b0 00 00 	movaps %xmm1,0xb0(%rsp)
     fe0:	00 
     fe1:	f2 0f 10 4c 24 40    	movsd  0x40(%rsp),%xmm1
     fe7:	f2 0f 5c 4c 24 18    	subsd  0x18(%rsp),%xmm1
     fed:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
     ff2:	8b 84 24 90 00 00 00 	mov    0x90(%rsp),%eax
     ff9:	4c 89 44 24 40       	mov    %r8,0x40(%rsp)
     ffe:	66 0f 14 cf          	unpcklpd %xmm7,%xmm1
    1002:	01 d0                	add    %edx,%eax
    1004:	66 0f 5e c8          	divpd  %xmm0,%xmm1
    1008:	8d 04 85 6b 04 00 00 	lea    0x46b(,%rax,4),%eax
    100f:	89 c1                	mov    %eax,%ecx
    1011:	81 e1 f8 ff 1f 00    	and    $0x1ffff8,%ecx
    1017:	48 89 8c 24 f8 00 00 	mov    %rcx,0xf8(%rsp)
    101e:	00 
    101f:	0f 29 8c 24 c0 00 00 	movaps %xmm1,0xc0(%rsp)
    1026:	00 
    1027:	f2 0f 10 4c 24 20    	movsd  0x20(%rsp),%xmm1
    102d:	66 0f 14 ce          	unpcklpd %xmm6,%xmm1
    1031:	66 0f 5e c8          	divpd  %xmm0,%xmm1
    1035:	66 0f 28 c2          	movapd %xmm2,%xmm0
    1039:	f2 41 0f 59 c1       	mulsd  %xmm9,%xmm0
    103e:	f2 45 0f 59 ce       	mulsd  %xmm14,%xmm9
    1043:	0f 29 8c 24 d0 00 00 	movaps %xmm1,0xd0(%rsp)
    104a:	00 
    104b:	66 41 0f 28 cf       	movapd %xmm15,%xmm1
    1050:	f2 0f 59 cd          	mulsd  %xmm5,%xmm1
    1054:	f2 41 0f 59 ee       	mulsd  %xmm14,%xmm5
    1059:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    105d:	f2 0f 5e c4          	divsd  %xmm4,%xmm0
    1061:	f2 0f 11 84 24 98 00 	movsd  %xmm0,0x98(%rsp)
    1068:	00 00 
    106a:	66 41 0f 28 c7       	movapd %xmm15,%xmm0
    106f:	f2 41 0f 59 c0       	mulsd  %xmm8,%xmm0
    1074:	f2 44 0f 59 c2       	mulsd  %xmm2,%xmm8
    1079:	f2 41 0f 5c c1       	subsd  %xmm9,%xmm0
    107e:	f2 41 0f 5c e8       	subsd  %xmm8,%xmm5
    1083:	f2 0f 5e c4          	divsd  %xmm4,%xmm0
    1087:	f2 0f 5e ec          	divsd  %xmm4,%xmm5
    108b:	f2 0f 11 84 24 a0 00 	movsd  %xmm0,0xa0(%rsp)
    1092:	00 00 
    1094:	f2 0f 11 ac 24 a8 00 	movsd  %xmm5,0xa8(%rsp)
    109b:	00 00 
    109d:	0f 1f 00             	nopl   (%rax)
    10a0:	41 0f b7 07          	movzwl (%r15),%eax
    10a4:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
    10a9:	44 01 e0             	add    %r12d,%eax
    10ac:	8b 51 5c             	mov    0x5c(%rcx),%edx
    10af:	6b c0 1c             	imul   $0x1c,%eax,%eax
    10b2:	48 01 d0             	add    %rdx,%rax
    10b5:	48 01 c6             	add    %rax,%rsi
    10b8:	80 7c 24 73 00       	cmpb   $0x0,0x73(%rsp)
    10bd:	75 53                	jne    1112 <mesh_packet+0x912>
    10bf:	48 8b bc 24 e8 00 00 	mov    0xe8(%rsp),%rdi
    10c6:	00 
    10c7:	43 8d 44 24 01       	lea    0x1(%r12,%r12,1),%eax
    10cc:	4c 8b 44 24 50       	mov    0x50(%rsp),%r8
    10d1:	48 c1 e0 02          	shl    $0x2,%rax
    10d5:	48 8d 0c 07          	lea    (%rdi,%rax,1),%rcx
    10d9:	48 8d 54 07 fc       	lea    -0x4(%rdi,%rax,1),%rdx
    10de:	48 8d bc 24 50 01 00 	lea    0x150(%rsp),%rdi
    10e5:	00 
    10e6:	e8 a5 ef ff ff       	call   90 <mesh_project>
    10eb:	84 c0                	test   %al,%al
    10ed:	0f 84 6d fb ff ff    	je     c60 <mesh_packet+0x460>
    10f3:	f3 0f 10 02          	movss  (%rdx),%xmm0
    10f7:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
    10fc:	f3 0f 11 00          	movss  %xmm0,(%rax)
    1100:	f3 0f 10 01          	movss  (%rcx),%xmm0
    1104:	48 89 c1             	mov    %rax,%rcx
    1107:	f3 0f 11 40 04       	movss  %xmm0,0x4(%rax)
    110c:	8b 46 18             	mov    0x18(%rsi),%eax
    110f:	89 41 08             	mov    %eax,0x8(%rcx)
    1112:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1116:	66 0f ef db          	pxor   %xmm3,%xmm3
    111a:	66 0f ef c9          	pxor   %xmm1,%xmm1
    111e:	f3 0f 5a 46 0c       	cvtss2sd 0xc(%rsi),%xmm0
    1123:	f3 0f 5a 5e 10       	cvtss2sd 0x10(%rsi),%xmm3
    1128:	66 0f 28 d0          	movapd %xmm0,%xmm2
    112c:	66 0f 28 e3          	movapd %xmm3,%xmm4
    1130:	66 0f 14 d2          	unpcklpd %xmm2,%xmm2
    1134:	66 0f 14 e4          	unpcklpd %xmm4,%xmm4
    1138:	f3 0f 5a 4e 14       	cvtss2sd 0x14(%rsi),%xmm1
    113d:	66 0f 59 a4 24 c0 00 	mulpd  0xc0(%rsp),%xmm4
    1144:	00 00 
    1146:	66 0f 59 94 24 b0 00 	mulpd  0xb0(%rsp),%xmm2
    114d:	00 00 
    114f:	f2 0f 59 9c 24 a0 00 	mulsd  0xa0(%rsp),%xmm3
    1156:	00 00 
    1158:	f2 0f 59 84 24 98 00 	mulsd  0x98(%rsp),%xmm0
    115f:	00 00 
    1161:	66 0f 58 d4          	addpd  %xmm4,%xmm2
    1165:	66 0f 28 e1          	movapd %xmm1,%xmm4
    1169:	f2 0f 59 8c 24 a8 00 	mulsd  0xa8(%rsp),%xmm1
    1170:	00 00 
    1172:	66 0f 14 e4          	unpcklpd %xmm4,%xmm4
    1176:	66 0f 59 a4 24 d0 00 	mulpd  0xd0(%rsp),%xmm4
    117d:	00 00 
    117f:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    1183:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    1187:	66 0f 58 d4          	addpd  %xmm4,%xmm2
    118b:	66 48 0f 7e c3       	movq   %xmm0,%rbx
    1190:	66 0f 28 ea          	movapd %xmm2,%xmm5
    1194:	66 0f 28 c2          	movapd %xmm2,%xmm0
    1198:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
    119d:	66 0f 15 ed          	unpckhpd %xmm5,%xmm5
    11a1:	66 0f 28 cd          	movapd %xmm5,%xmm1
    11a5:	e8 00 00 00 00       	call   11aa <mesh_packet+0x9aa>
			11a6: R_X86_64_PLT32	hypot-0x4
    11aa:	66 48 0f 6e cb       	movq   %rbx,%xmm1
    11af:	e8 00 00 00 00       	call   11b4 <mesh_packet+0x9b4>
			11b0: R_X86_64_PLT32	hypot-0x4
    11b4:	66 0f 28 e8          	movapd %xmm0,%xmm5
    11b8:	f2 0f 11 44 24 08    	movsd  %xmm0,0x8(%rsp)
    11be:	66 0f ef c0          	pxor   %xmm0,%xmm0
    11c2:	66 0f 2f e8          	comisd %xmm0,%xmm5
    11c6:	0f 86 94 fa ff ff    	jbe    c60 <mesh_packet+0x460>
    11cc:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 11d4 <mesh_packet+0x9d4>
    11d3:	00 
			11d0: R_X86_64_PC32	.LC22-0x4
    11d4:	66 0f 2e fd          	ucomisd %xmm5,%xmm7
    11d8:	0f 82 82 fa ff ff    	jb     c60 <mesh_packet+0x460>
    11de:	66 0f 28 54 24 20    	movapd 0x20(%rsp),%xmm2
    11e4:	48 89 9c 24 90 03 00 	mov    %rbx,0x390(%rsp)
    11eb:	00 
    11ec:	45 31 f6             	xor    %r14d,%r14d
    11ef:	4c 8d ac 24 80 03 00 	lea    0x380(%rsp),%r13
    11f6:	00 
    11f7:	48 8d 9c 24 00 02 00 	lea    0x200(%rsp),%rbx
    11fe:	00 
    11ff:	0f 29 94 24 80 03 00 	movaps %xmm2,0x380(%rsp)
    1206:	00 
    1207:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 120f <mesh_packet+0xa0f>
    120e:	00 
			120b: R_X86_64_PC32	.LC24-0x4
    120f:	f2 43 0f 59 44 f5 00 	mulsd  0x0(%r13,%r14,8),%xmm0
    1216:	f2 0f 5e 44 24 08    	divsd  0x8(%rsp),%xmm0
    121c:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 1224 <mesh_packet+0xa24>
    1223:	00 
			1220: R_X86_64_PC32	.LC6-0x4
    1224:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 122c <mesh_packet+0xa2c>
    122b:	00 
			1228: R_X86_64_PC32	.LC13-0x4
    122c:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 1234 <mesh_packet+0xa34>
    1233:	00 
			1230: R_X86_64_PC32	.LC7-0x4
    1234:	66 0f 54 c8          	andpd  %xmm0,%xmm1
    1238:	66 0f 2e f1          	ucomisd %xmm1,%xmm6
    123c:	76 3b                	jbe    1279 <mesh_packet+0xa79>
    123e:	f2 48 0f 2c c0       	cvttsd2si %xmm0,%rax
    1243:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1247:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 124f <mesh_packet+0xa4f>
    124e:	00 
			124b: R_X86_64_PC32	.LC9-0x4
    124f:	f2 48 0f 2a c8       	cvtsi2sd %rax,%xmm1
    1254:	66 0f 28 d1          	movapd %xmm1,%xmm2
    1258:	f2 0f c2 d0 06       	cmpnlesd %xmm0,%xmm2
    125d:	66 0f 54 d7          	andpd  %xmm7,%xmm2
    1261:	f2 0f 5c ca          	subsd  %xmm2,%xmm1
    1265:	f2 0f 10 15 00 00 00 	movsd  0x0(%rip),%xmm2        # 126d <mesh_packet+0xa6d>
    126c:	00 
			1269: R_X86_64_PC32	.LC13-0x4
    126d:	66 0f 55 d0          	andnpd %xmm0,%xmm2
    1271:	66 0f 56 ca          	orpd   %xmm2,%xmm1
    1275:	66 0f 28 c1          	movapd %xmm1,%xmm0
    1279:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 1281 <mesh_packet+0xa81>
    1280:	00 
			127d: R_X86_64_PC32	.LC24-0x4
    1281:	e8 00 00 00 00       	call   1286 <mesh_packet+0xa86>
			1282: R_X86_64_PLT32	fmin-0x4
    1286:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 128e <mesh_packet+0xa8e>
    128d:	00 
			128a: R_X86_64_PC32	.LC25-0x4
    128e:	e8 00 00 00 00       	call   1293 <mesh_packet+0xa93>
			128f: R_X86_64_PLT32	fmax-0x4
    1293:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    1297:	66 42 89 04 73       	mov    %ax,(%rbx,%r14,2)
    129c:	49 83 c6 01          	add    $0x1,%r14
    12a0:	49 83 fe 03          	cmp    $0x3,%r14
    12a4:	0f 85 5d ff ff ff    	jne    1207 <mesh_packet+0xa07>
    12aa:	0f b7 84 24 00 02 00 	movzwl 0x200(%rsp),%eax
    12b1:	00 
    12b2:	66 0b 84 24 02 02 00 	or     0x202(%rsp),%ax
    12b9:	00 
    12ba:	66 0b 84 24 04 02 00 	or     0x204(%rsp),%ax
    12c1:	00 
    12c2:	0f 84 98 f9 ff ff    	je     c60 <mesh_packet+0x460>
    12c8:	0f b6 4c 24 78       	movzbl 0x78(%rsp),%ecx
    12cd:	f3 0f 10 64 24 74    	movss  0x74(%rsp),%xmm4
    12d3:	48 89 df             	mov    %rbx,%rdi
    12d6:	4c 8d b4 24 30 01 00 	lea    0x130(%rsp),%r14
    12dd:	00 
    12de:	41 0f b6 77 12       	movzbl 0x12(%r15),%esi
    12e3:	f3 0f 10 5c 24 68    	movss  0x68(%rsp),%xmm3
    12e9:	4c 89 f2             	mov    %r14,%rdx
    12ec:	f3 0f 10 84 24 84 00 	movss  0x84(%rsp),%xmm0
    12f3:	00 00 
    12f5:	f3 0f 10 ac 24 80 00 	movss  0x80(%rsp),%xmm5
    12fc:	00 00 
    12fe:	f3 0f 10 8c 24 88 00 	movss  0x88(%rsp),%xmm1
    1305:	00 00 
    1307:	f3 0f 10 94 24 8c 00 	movss  0x8c(%rsp),%xmm2
    130e:	00 00 
    1310:	e8 cb f1 ff ff       	call   4e0 <ayatsuri_shade_terms_prepare.isra.0>
    1315:	41 0f b7 7f 0e       	movzwl 0xe(%r15),%edi
    131a:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
    131f:	66 48 0f 7e c0       	movq   %xmm0,%rax
    1324:	66 48 0f 7e ca       	movq   %xmm1,%rdx
    1329:	f3 0f 11 44 24 20    	movss  %xmm0,0x20(%rsp)
    132f:	66 0f 6e d2          	movd   %edx,%xmm2
    1333:	48 c1 e8 20          	shr    $0x20,%rax
    1337:	48 c1 ea 20          	shr    $0x20,%rdx
    133b:	66 0f 6e c8          	movd   %eax,%xmm1
    133f:	f3 0f 11 54 24 60    	movss  %xmm2,0x60(%rsp)
    1345:	66 0f 6e da          	movd   %edx,%xmm3
    1349:	89 54 24 48          	mov    %edx,0x48(%rsp)
    134d:	4c 89 f2             	mov    %r14,%rdx
    1350:	89 44 24 30          	mov    %eax,0x30(%rsp)
    1354:	e8 a7 ef ff ff       	call   300 <ayatsuri_shade_from_terms.isra.0>
    1359:	41 0f b7 7f 10       	movzwl 0x10(%r15),%edi
    135e:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
    1363:	4c 89 f2             	mov    %r14,%rdx
    1366:	f3 0f 10 5c 24 48    	movss  0x48(%rsp),%xmm3
    136c:	f3 0f 10 54 24 60    	movss  0x60(%rsp),%xmm2
    1372:	66 89 c5             	mov    %ax,%bp
    1375:	f3 0f 10 4c 24 30    	movss  0x30(%rsp),%xmm1
    137b:	f3 0f 10 44 24 20    	movss  0x20(%rsp),%xmm0
    1381:	0f b7 ed             	movzwl %bp,%ebp
    1384:	e8 77 ef ff ff       	call   300 <ayatsuri_shade_from_terms.isra.0>
    1389:	8b 7c 24 64          	mov    0x64(%rsp),%edi
    138d:	c1 e0 10             	shl    $0x10,%eax
    1390:	09 c5                	or     %eax,%ebp
    1392:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
    1397:	89 68 0c             	mov    %ebp,0xc(%rax)
    139a:	85 ff                	test   %edi,%edi
    139c:	75 32                	jne    13d0 <mesh_packet+0xbd0>
    139e:	8b 84 24 90 00 00 00 	mov    0x90(%rsp),%eax
    13a5:	41 83 c4 01          	add    $0x1,%r12d
    13a9:	48 83 44 24 40 10    	addq   $0x10,0x40(%rsp)
    13af:	48 83 44 24 50 04    	addq   $0x4,0x50(%rsp)
    13b5:	41 39 c4             	cmp    %eax,%r12d
    13b8:	0f 83 2f 02 00 00    	jae    15ed <mesh_packet+0xded>
    13be:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    13c3:	48 8b 30             	mov    (%rax),%rsi
    13c6:	e9 d5 fc ff ff       	jmp    10a0 <mesh_packet+0x8a0>
    13cb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    13d0:	31 c0                	xor    %eax,%eax
    13d2:	89 6c 24 20          	mov    %ebp,0x20(%rsp)
    13d6:	4c 89 ed             	mov    %r13,%rbp
    13d9:	49 89 c5             	mov    %rax,%r13
    13dc:	f2 42 0f 10 44 ed 00 	movsd  0x0(%rbp,%r13,8),%xmm0
    13e3:	66 0f 57 05 00 00 00 	xorpd  0x0(%rip),%xmm0        # 13eb <mesh_packet+0xbeb>
    13ea:	00 
			13e7: R_X86_64_PC32	.LC26-0x4
    13eb:	f2 0f 59 05 00 00 00 	mulsd  0x0(%rip),%xmm0        # 13f3 <mesh_packet+0xbf3>
    13f2:	00 
			13ef: R_X86_64_PC32	.LC24-0x4
    13f3:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 13fb <mesh_packet+0xbfb>
    13fa:	00 
			13f7: R_X86_64_PC32	.LC13-0x4
    13fb:	f2 0f 5e 44 24 08    	divsd  0x8(%rsp),%xmm0
    1401:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 1409 <mesh_packet+0xc09>
    1408:	00 
			1405: R_X86_64_PC32	.LC6-0x4
    1409:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 1411 <mesh_packet+0xc11>
    1410:	00 
			140d: R_X86_64_PC32	.LC7-0x4
    1411:	66 0f 54 c8          	andpd  %xmm0,%xmm1
    1415:	66 0f 2e f9          	ucomisd %xmm1,%xmm7
    1419:	76 3b                	jbe    1456 <mesh_packet+0xc56>
    141b:	f2 48 0f 2c c0       	cvttsd2si %xmm0,%rax
    1420:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1424:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 142c <mesh_packet+0xc2c>
    142b:	00 
			1428: R_X86_64_PC32	.LC9-0x4
    142c:	f2 48 0f 2a c8       	cvtsi2sd %rax,%xmm1
    1431:	66 0f 28 d1          	movapd %xmm1,%xmm2
    1435:	f2 0f c2 d0 06       	cmpnlesd %xmm0,%xmm2
    143a:	66 0f 54 d6          	andpd  %xmm6,%xmm2
    143e:	f2 0f 5c ca          	subsd  %xmm2,%xmm1
    1442:	f2 0f 10 15 00 00 00 	movsd  0x0(%rip),%xmm2        # 144a <mesh_packet+0xc4a>
    1449:	00 
			1446: R_X86_64_PC32	.LC13-0x4
    144a:	66 0f 55 d0          	andnpd %xmm0,%xmm2
    144e:	66 0f 56 ca          	orpd   %xmm2,%xmm1
    1452:	66 0f 28 c1          	movapd %xmm1,%xmm0
    1456:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 145e <mesh_packet+0xc5e>
    145d:	00 
			145a: R_X86_64_PC32	.LC24-0x4
    145e:	e8 00 00 00 00       	call   1463 <mesh_packet+0xc63>
			145f: R_X86_64_PLT32	fmin-0x4
    1463:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 146b <mesh_packet+0xc6b>
    146a:	00 
			1467: R_X86_64_PC32	.LC25-0x4
    146b:	e8 00 00 00 00       	call   1470 <mesh_packet+0xc70>
			146c: R_X86_64_PLT32	fmax-0x4
    1470:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    1474:	66 42 89 04 6b       	mov    %ax,(%rbx,%r13,2)
    1479:	49 83 c5 01          	add    $0x1,%r13
    147d:	49 83 fd 03          	cmp    $0x3,%r13
    1481:	0f 85 55 ff ff ff    	jne    13dc <mesh_packet+0xbdc>
    1487:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
    148e:	00 
    148f:	48 89 df             	mov    %rbx,%rdi
    1492:	8b 6c 24 20          	mov    0x20(%rsp),%ebp
    1496:	48 8b 8c 24 f8 00 00 	mov    0xf8(%rsp),%rcx
    149d:	00 
    149e:	f3 0f 10 64 24 74    	movss  0x74(%rsp),%xmm4
    14a4:	48 8b 50 08          	mov    0x8(%rax),%rdx
    14a8:	41 0f b6 77 12       	movzbl 0x12(%r15),%esi
    14ad:	48 8b 84 24 e0 00 00 	mov    0xe0(%rsp),%rax
    14b4:	00 
    14b5:	f3 0f 10 5c 24 68    	movss  0x68(%rsp),%xmm3
    14bb:	f3 0f 10 84 24 84 00 	movss  0x84(%rsp),%xmm0
    14c2:	00 00 
    14c4:	f3 0f 10 ac 24 80 00 	movss  0x80(%rsp),%xmm5
    14cb:	00 00 
    14cd:	f3 0f 10 8c 24 88 00 	movss  0x88(%rsp),%xmm1
    14d4:	00 00 
    14d6:	8b 44 02 08          	mov    0x8(%rdx,%rax,1),%eax
    14da:	f3 0f 10 94 24 8c 00 	movss  0x8c(%rsp),%xmm2
    14e1:	00 00 
    14e3:	48 01 c8             	add    %rcx,%rax
    14e6:	43 8d 0c 24          	lea    (%r12,%r12,1),%ecx
    14ea:	48 8d 04 48          	lea    (%rax,%rcx,2),%rax
    14ee:	0f b6 4c 24 78       	movzbl 0x78(%rsp),%ecx
    14f3:	4c 8d 2c 02          	lea    (%rdx,%rax,1),%r13
    14f7:	4c 89 f2             	mov    %r14,%rdx
    14fa:	e8 e1 ef ff ff       	call   4e0 <ayatsuri_shade_terms_prepare.isra.0>
    14ff:	41 0f b7 7f 0e       	movzwl 0xe(%r15),%edi
    1504:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
    1509:	66 48 0f 7e ca       	movq   %xmm1,%rdx
    150e:	66 48 0f 7e c0       	movq   %xmm0,%rax
    1513:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
    1519:	48 89 d3             	mov    %rdx,%rbx
    151c:	48 c1 e8 20          	shr    $0x20,%rax
    1520:	66 0f 6e d2          	movd   %edx,%xmm2
    1524:	48 c1 ea 20          	shr    $0x20,%rdx
    1528:	66 0f 6e c8          	movd   %eax,%xmm1
    152c:	89 5c 24 30          	mov    %ebx,0x30(%rsp)
    1530:	66 0f 6e da          	movd   %edx,%xmm3
    1534:	89 54 24 60          	mov    %edx,0x60(%rsp)
    1538:	4c 89 f2             	mov    %r14,%rdx
    153b:	89 44 24 20          	mov    %eax,0x20(%rsp)
    153f:	e8 bc ed ff ff       	call   300 <ayatsuri_shade_from_terms.isra.0>
    1544:	8b 9c 24 00 01 00 00 	mov    0x100(%rsp),%ebx
    154b:	41 0f b7 7f 10       	movzwl 0x10(%r15),%edi
    1550:	4c 89 f2             	mov    %r14,%rdx
    1553:	f3 0f 10 5c 24 60    	movss  0x60(%rsp),%xmm3
    1559:	f3 0f 10 54 24 30    	movss  0x30(%rsp),%xmm2
    155f:	f3 0f 10 4c 24 20    	movss  0x20(%rsp),%xmm1
    1565:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
    156b:	66 89 c3             	mov    %ax,%bx
    156e:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
    1573:	e8 88 ed ff ff       	call   300 <ayatsuri_shade_from_terms.isra.0>
    1578:	0f b7 d3             	movzwl %bx,%edx
    157b:	c1 e0 10             	shl    $0x10,%eax
    157e:	09 c2                	or     %eax,%edx
    1580:	89 94 24 00 01 00 00 	mov    %edx,0x100(%rsp)
    1587:	41 89 55 00          	mov    %edx,0x0(%r13)
    158b:	e9 0e fe ff ff       	jmp    139e <mesh_packet+0xb9e>
    1590:	4c 8d 43 5c          	lea    0x5c(%rbx),%r8
    1594:	89 d8                	mov    %ebx,%eax
    1596:	48 c7 43 54 00 00 00 	movq   $0x0,0x54(%rbx)
    159d:	00 
    159e:	48 c7 83 5c 04 00 00 	movq   $0x0,0x45c(%rbx)
    15a5:	00 00 00 00 
    15a9:	4c 89 c7             	mov    %r8,%rdi
    15ac:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
    15b0:	29 f8                	sub    %edi,%eax
    15b2:	8d 88 64 04 00 00    	lea    0x464(%rax),%ecx
    15b8:	31 c0                	xor    %eax,%eax
    15ba:	c1 e9 03             	shr    $0x3,%ecx
    15bd:	f3 48 ab             	rep stos %rax,%es:(%rdi)
    15c0:	0f b6 84 24 04 01 00 	movzbl 0x104(%rsp),%eax
    15c7:	00 
    15c8:	44 8b 8c 24 90 00 00 	mov    0x90(%rsp),%r9d
    15cf:	00 
    15d0:	88 43 54             	mov    %al,0x54(%rbx)
    15d3:	41 0f b6 47 0a       	movzbl 0xa(%r15),%eax
    15d8:	88 43 56             	mov    %al,0x56(%rbx)
    15db:	45 85 c9             	test   %r9d,%r9d
    15de:	74 46                	je     1626 <mesh_packet+0xe26>
    15e0:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    15e5:	4c 8b 28             	mov    (%rax),%r13
    15e8:	e9 61 f9 ff ff       	jmp    f4e <mesh_packet+0x74e>
    15ed:	44 8b b4 24 20 01 00 	mov    0x120(%rsp),%r14d
    15f4:	00 
    15f5:	4c 8b 94 24 08 01 00 	mov    0x108(%rsp),%r10
    15fc:	00 
    15fd:	f2 0f 10 a4 24 10 01 	movsd  0x110(%rsp),%xmm4
    1604:	00 00 
    1606:	48 8b 9c 24 18 01 00 	mov    0x118(%rsp),%rbx
    160d:	00 
    160e:	4c 8b 9c 24 f0 00 00 	mov    0xf0(%rsp),%r11
    1615:	00 
    1616:	8b 94 24 24 01 00 00 	mov    0x124(%rsp),%edx
    161d:	45 84 f6             	test   %r14b,%r14b
    1620:	0f 85 68 04 00 00    	jne    1a8e <mesh_packet+0x128e>
    1626:	44 0f b7 84 24 06 01 	movzwl 0x106(%rsp),%r8d
    162d:	00 00 
    162f:	45 85 c0             	test   %r8d,%r8d
    1632:	74 5c                	je     1690 <mesh_packet+0xe90>
    1634:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    1639:	31 ff                	xor    %edi,%edi
    163b:	48 8b 28             	mov    (%rax),%rbp
    163e:	44 8b 48 64          	mov    0x64(%rax),%r9d
    1642:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    1649:	00 00 00 00 
    164d:	0f 1f 00             	nopl   (%rax)
    1650:	8d 34 7f             	lea    (%rdi,%rdi,2),%esi
    1653:	31 c9                	xor    %ecx,%ecx
    1655:	41 0f b7 47 04       	movzwl 0x4(%r15),%eax
    165a:	01 f8                	add    %edi,%eax
    165c:	8d 04 40             	lea    (%rax,%rax,2),%eax
    165f:	44 8d 24 00          	lea    (%rax,%rax,1),%r12d
    1663:	48 8d 44 0d 00       	lea    0x0(%rbp,%rcx,1),%rax
    1668:	48 83 c1 02          	add    $0x2,%rcx
    166c:	4c 01 c8             	add    %r9,%rax
    166f:	46 0f b7 24 20       	movzwl (%rax,%r12,1),%r12d
    1674:	89 f0                	mov    %esi,%eax
    1676:	83 c6 01             	add    $0x1,%esi
    1679:	66 44 89 a4 44 00 02 	mov    %r12w,0x200(%rsp,%rax,2)
    1680:	00 00 
    1682:	48 83 f9 06          	cmp    $0x6,%rcx
    1686:	75 cd                	jne    1655 <mesh_packet+0xe55>
    1688:	83 c7 01             	add    $0x1,%edi
    168b:	41 39 f8             	cmp    %edi,%r8d
    168e:	75 c0                	jne    1650 <mesh_packet+0xe50>
    1690:	8b 4c 24 64          	mov    0x64(%rsp),%ecx
    1694:	41 0f b6 6f 0b       	movzbl 0xb(%r15),%ebp
    1699:	85 c9                	test   %ecx,%ecx
    169b:	0f 84 01 04 00 00    	je     1aa2 <mesh_packet+0x12a2>
    16a1:	49 8b 4b 08          	mov    0x8(%r11),%rcx
    16a5:	48 8b 84 24 e0 00 00 	mov    0xe0(%rsp),%rax
    16ac:	00 
    16ad:	66 0f ef c0          	pxor   %xmm0,%xmm0
    16b1:	48 8b b4 24 28 01 00 	mov    0x128(%rsp),%rsi
    16b8:	00 
    16b9:	8b 44 01 08          	mov    0x8(%rcx,%rax,1),%eax
    16bd:	48 8d 04 70          	lea    (%rax,%rsi,2),%rax
    16c1:	8b b4 24 90 00 00 00 	mov    0x90(%rsp),%esi
    16c8:	01 f2                	add    %esi,%edx
    16ca:	8d 14 95 6b 04 00 00 	lea    0x46b(,%rdx,4),%edx
    16d1:	81 e2 f8 ff 1f 00    	and    $0x1ffff8,%edx
    16d7:	48 01 d0             	add    %rdx,%rax
    16da:	66 0f 2f c4          	comisd %xmm4,%xmm0
    16de:	48 8d 3c 01          	lea    (%rcx,%rax,1),%rdi
    16e2:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
    16e9:	0f 97 44 24 08       	seta   0x8(%rsp)
    16ee:	44 0f b6 74 24 08    	movzbl 0x8(%rsp),%r14d
    16f4:	45 85 c0             	test   %r8d,%r8d
    16f7:	0f 84 02 05 00 00    	je     1bff <mesh_packet+0x13ff>
    16fd:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
    1702:	31 f6                	xor    %esi,%esi
    1704:	31 c0                	xor    %eax,%eax
    1706:	66 0f 28 e0          	movapd %xmm0,%xmm4
    170a:	4c 8d 8c 24 00 02 00 	lea    0x200(%rsp),%r9
    1711:	00 
    1712:	48 89 5c 24 18       	mov    %rbx,0x18(%rsp)
    1717:	f2 0f 10 1d 00 00 00 	movsd  0x0(%rip),%xmm3        # 171f <mesh_packet+0xf1f>
    171e:	00 
			171b: R_X86_64_PC32	.LC27-0x4
    171f:	4c 89 4c 24 20       	mov    %r9,0x20(%rsp)
    1724:	48 8b 94 24 e8 00 00 	mov    0xe8(%rsp),%rdx
    172b:	00 
    172c:	4c 89 c9             	mov    %r9,%rcx
    172f:	4c 89 7c 24 40       	mov    %r15,0x40(%rsp)
    1734:	41 89 ef             	mov    %ebp,%r15d
    1737:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    173e:	00 00 
    1740:	0f b7 29             	movzwl (%rcx),%ebp
    1743:	0f b7 59 02          	movzwl 0x2(%rcx),%ebx
    1747:	66 0f ef ed          	pxor   %xmm5,%xmm5
    174b:	66 0f ef d2          	pxor   %xmm2,%xmm2
    174f:	44 0f b7 59 04       	movzwl 0x4(%rcx),%r11d
    1754:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1758:	66 0f ef c9          	pxor   %xmm1,%xmm1
    175c:	48 8d 7c 2d 00       	lea    0x0(%rbp,%rbp,1),%rdi
    1761:	81 e7 fe ff 01 00    	and    $0x1fffe,%edi
    1767:	4f 8d 0c 1b          	lea    (%r11,%r11,1),%r9
    176b:	f3 0f 5a 54 ba 04    	cvtss2sd 0x4(%rdx,%rdi,4),%xmm2
    1771:	f3 0f 5a 2c ba       	cvtss2sd (%rdx,%rdi,4),%xmm5
    1776:	48 8d 3c 1b          	lea    (%rbx,%rbx,1),%rdi
    177a:	41 81 e1 fe ff 01 00 	and    $0x1fffe,%r9d
    1781:	81 e7 fe ff 01 00    	and    $0x1fffe,%edi
    1787:	f3 42 0f 5a 44 8a 04 	cvtss2sd 0x4(%rdx,%r9,4),%xmm0
    178e:	f2 0f 5c c2          	subsd  %xmm2,%xmm0
    1792:	f3 0f 5a 0c ba       	cvtss2sd (%rdx,%rdi,4),%xmm1
    1797:	f2 0f 5c cd          	subsd  %xmm5,%xmm1
    179b:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    179f:	66 0f ef c9          	pxor   %xmm1,%xmm1
    17a3:	f3 0f 5a 4c ba 04    	cvtss2sd 0x4(%rdx,%rdi,4),%xmm1
    17a9:	f2 0f 5c ca          	subsd  %xmm2,%xmm1
    17ad:	66 0f ef d2          	pxor   %xmm2,%xmm2
    17b1:	f3 42 0f 5a 14 8a    	cvtss2sd (%rdx,%r9,4),%xmm2
    17b7:	f2 0f 5c d5          	subsd  %xmm5,%xmm2
    17bb:	f2 0f 59 ca          	mulsd  %xmm2,%xmm1
    17bf:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    17c3:	66 0f 28 c8          	movapd %xmm0,%xmm1
    17c7:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 17cf <mesh_packet+0xfcf>
    17ce:	00 
			17cb: R_X86_64_PC32	.LC8-0x4
    17cf:	66 0f 2f d9          	comisd %xmm1,%xmm3
    17d3:	73 61                	jae    1836 <mesh_packet+0x1036>
    17d5:	66 0f 2f e0          	comisd %xmm0,%xmm4
    17d9:	66 0f ef c9          	pxor   %xmm1,%xmm1
    17dd:	66 0f ef c0          	pxor   %xmm0,%xmm0
    17e1:	44 89 f7             	mov    %r14d,%edi
    17e4:	f3 41 0f 5a 0c 9a    	cvtss2sd (%r10,%rbx,4),%xmm1
    17ea:	f3 41 0f 5a 04 aa    	cvtss2sd (%r10,%rbp,4),%xmm0
    17f0:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    17f4:	66 0f ef c9          	pxor   %xmm1,%xmm1
    17f8:	f3 43 0f 5a 0c 9a    	cvtss2sd (%r10,%r11,4),%xmm1
    17fe:	8d 58 01             	lea    0x1(%rax),%ebx
    1801:	41 0f 97 c1          	seta   %r9b
    1805:	44 31 cf             	xor    %r9d,%edi
    1808:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    180c:	01 ff                	add    %edi,%edi
    180e:	44 09 cf             	or     %r9d,%edi
    1811:	40 88 bc 34 c0 01 00 	mov    %dil,0x1c0(%rsp,%rsi,1)
    1818:	00 
    1819:	41 80 ff 01          	cmp    $0x1,%r15b
    181d:	0f 84 6e 03 00 00    	je     1b91 <mesh_packet+0x1391>
    1823:	40 88 b4 04 80 01 00 	mov    %sil,0x180(%rsp,%rax,1)
    182a:	00 
    182b:	f2 0f 11 84 c4 80 03 	movsd  %xmm0,0x380(%rsp,%rax,8)
    1832:	00 00 
    1834:	89 d8                	mov    %ebx,%eax
    1836:	48 83 c6 01          	add    $0x1,%rsi
    183a:	48 83 c1 06          	add    $0x6,%rcx
    183e:	44 39 c6             	cmp    %r8d,%esi
    1841:	0f 82 f9 fe ff ff    	jb     1740 <mesh_packet+0xf40>
    1847:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
    184c:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
    1851:	4c 8b 7c 24 40       	mov    0x40(%rsp),%r15
    1856:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
    185b:	85 c0                	test   %eax,%eax
    185d:	0f 84 ae 03 00 00    	je     1c11 <mesh_packet+0x1411>
    1863:	48 8d b3 5c 02 00 00 	lea    0x25c(%rbx),%rsi
    186a:	89 c5                	mov    %eax,%ebp
    186c:	45 31 c0             	xor    %r8d,%r8d
    186f:	41 bc 01 00 00 00    	mov    $0x1,%r12d
    1875:	4c 8d 9c 24 80 01 00 	lea    0x180(%rsp),%r11
    187c:	00 
    187d:	eb 45                	jmp    18c4 <mesh_packet+0x10c4>
    187f:	44 0f b7 69 02       	movzwl 0x2(%rcx),%r13d
    1884:	41 ba 04 00 00 00    	mov    $0x4,%r10d
    188a:	66 44 89 6e 02       	mov    %r13w,0x2(%rsi)
    188f:	42 0f b7 0c 11       	movzwl (%rcx,%r10,1),%ecx
    1894:	83 e2 02             	and    $0x2,%edx
    1897:	66 89 4e 04          	mov    %cx,0x4(%rsi)
    189b:	74 16                	je     18b3 <mesh_packet+0x10b3>
    189d:	44 89 c2             	mov    %r8d,%edx
    18a0:	44 89 c1             	mov    %r8d,%ecx
    18a3:	45 89 e2             	mov    %r12d,%r10d
    18a6:	c1 ea 03             	shr    $0x3,%edx
    18a9:	83 e1 07             	and    $0x7,%ecx
    18ac:	41 d3 e2             	shl    %cl,%r10d
    18af:	44 08 14 17          	or     %r10b,(%rdi,%rdx,1)
    18b3:	49 83 c0 01          	add    $0x1,%r8
    18b7:	48 83 c6 06          	add    $0x6,%rsi
    18bb:	49 39 e8             	cmp    %rbp,%r8
    18be:	0f 84 4d 03 00 00    	je     1c11 <mesh_packet+0x1411>
    18c4:	43 0f b6 14 03       	movzbl (%r11,%r8,1),%edx
    18c9:	8d 0c 52             	lea    (%rdx,%rdx,2),%ecx
    18cc:	0f b6 94 14 c0 01 00 	movzbl 0x1c0(%rsp,%rdx,1),%edx
    18d3:	00 
    18d4:	49 8d 0c 49          	lea    (%r9,%rcx,2),%rcx
    18d8:	44 0f b7 11          	movzwl (%rcx),%r10d
    18dc:	66 44 89 16          	mov    %r10w,(%rsi)
    18e0:	f6 c2 01             	test   $0x1,%dl
    18e3:	74 9a                	je     187f <mesh_packet+0x107f>
    18e5:	44 0f b7 69 04       	movzwl 0x4(%rcx),%r13d
    18ea:	41 ba 02 00 00 00    	mov    $0x2,%r10d
    18f0:	eb 98                	jmp    188a <mesh_packet+0x108a>
    18f2:	f3 44 0f 10 5c 24 68 	movss  0x68(%rsp),%xmm11
    18f9:	f3 0f 10 5c 24 74    	movss  0x74(%rsp),%xmm3
    18ff:	c6 44 24 78 01       	movb   $0x1,0x78(%rsp)
    1904:	f3 0f 10 8c 24 80 00 	movss  0x80(%rsp),%xmm1
    190b:	00 00 
    190d:	f3 44 0f 5e d8       	divss  %xmm0,%xmm11
    1912:	f3 0f 5e d8          	divss  %xmm0,%xmm3
    1916:	45 0f 28 e3          	movaps %xmm11,%xmm12
    191a:	f3 45 0f 59 e3       	mulss  %xmm11,%xmm12
    191f:	f3 0f 5e c8          	divss  %xmm0,%xmm1
    1923:	0f 28 c3             	movaps %xmm3,%xmm0
    1926:	f3 0f 59 c3          	mulss  %xmm3,%xmm0
    192a:	f3 41 0f 58 c4       	addss  %xmm12,%xmm0
    192f:	44 0f 28 e1          	movaps %xmm1,%xmm12
    1933:	f3 44 0f 59 e1       	mulss  %xmm1,%xmm12
    1938:	f3 41 0f 58 c4       	addss  %xmm12,%xmm0
    193d:	f3 0f 51 c0          	sqrtss %xmm0,%xmm0
    1941:	f3 44 0f 5e d8       	divss  %xmm0,%xmm11
    1946:	f3 0f 5e d8          	divss  %xmm0,%xmm3
    194a:	f3 44 0f 11 5c 24 68 	movss  %xmm11,0x68(%rsp)
    1951:	f3 0f 5e c8          	divss  %xmm0,%xmm1
    1955:	f3 0f 11 5c 24 74    	movss  %xmm3,0x74(%rsp)
    195b:	f3 0f 11 8c 24 80 00 	movss  %xmm1,0x80(%rsp)
    1962:	00 00 
    1964:	e9 98 f5 ff ff       	jmp    f01 <mesh_packet+0x701>
    1969:	8b 84 24 80 03 00 00 	mov    0x380(%rsp),%eax
    1970:	85 c0                	test   %eax,%eax
    1972:	0f 84 00 01 00 00    	je     1a78 <mesh_packet+0x1278>
    1978:	85 f6                	test   %esi,%esi
    197a:	0f 84 f8 00 00 00    	je     1a78 <mesh_packet+0x1278>
    1980:	45 31 db             	xor    %r11d,%r11d
    1983:	45 31 c0             	xor    %r8d,%r8d
    1986:	66 0f ef d2          	pxor   %xmm2,%xmm2
    198a:	45 31 e4             	xor    %r12d,%r12d
    198d:	31 d2                	xor    %edx,%edx
    198f:	41 8d 43 01          	lea    0x1(%r11),%eax
    1993:	66 0f ef ed          	pxor   %xmm5,%xmm5
    1997:	45 89 da             	mov    %r11d,%r10d
    199a:	66 0f ef db          	pxor   %xmm3,%xmm3
    199e:	f3 42 0f 5a 6c db 04 	cvtss2sd 0x4(%rbx,%r11,8),%xmm5
    19a5:	66 0f ef e4          	pxor   %xmm4,%xmm4
    19a9:	66 0f ef f6          	pxor   %xmm6,%xmm6
    19ad:	f7 f6                	div    %esi
    19af:	f3 42 0f 5a 74 db 08 	cvtss2sd 0x8(%rbx,%r11,8),%xmm6
    19b6:	8d 3c 12             	lea    (%rdx,%rdx,1),%edi
    19b9:	f3 0f 5a 5c bb 04    	cvtss2sd 0x4(%rbx,%rdi,4),%xmm3
    19bf:	f2 0f 5c dd          	subsd  %xmm5,%xmm3
    19c3:	48 89 f8             	mov    %rdi,%rax
    19c6:	83 c0 01             	add    $0x1,%eax
    19c9:	f3 0f 5a 64 83 04    	cvtss2sd 0x4(%rbx,%rax,4),%xmm4
    19cf:	f2 0f 5c e6          	subsd  %xmm6,%xmm4
    19d3:	66 0f 2e da          	ucomisd %xmm2,%xmm3
    19d7:	0f 9b c0             	setnp  %al
    19da:	41 0f 45 c4          	cmovne %r12d,%eax
    19de:	84 c0                	test   %al,%al
    19e0:	74 13                	je     19f5 <mesh_packet+0x11f5>
    19e2:	66 0f 2e e2          	ucomisd %xmm2,%xmm4
    19e6:	0f 9b c0             	setnp  %al
    19e9:	41 0f 45 c4          	cmovne %r12d,%eax
    19ed:	84 c0                	test   %al,%al
    19ef:	0f 85 6b f2 ff ff    	jne    c60 <mesh_packet+0x460>
    19f5:	89 74 24 08          	mov    %esi,0x8(%rsp)
    19f9:	31 c0                	xor    %eax,%eax
    19fb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    1a00:	41 39 c2             	cmp    %eax,%r10d
    1a03:	74 59                	je     1a5e <mesh_packet+0x125e>
    1a05:	39 c2                	cmp    %eax,%edx
    1a07:	74 55                	je     1a5e <mesh_packet+0x125e>
    1a09:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1a0d:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1a11:	31 f6                	xor    %esi,%esi
    1a13:	f3 0f 5a 44 c3 08    	cvtss2sd 0x8(%rbx,%rax,8),%xmm0
    1a19:	f3 0f 5a 4c c3 04    	cvtss2sd 0x4(%rbx,%rax,8),%xmm1
    1a1f:	f2 0f 5c c6          	subsd  %xmm6,%xmm0
    1a23:	f2 0f 5c cd          	subsd  %xmm5,%xmm1
    1a27:	f2 0f 59 c3          	mulsd  %xmm3,%xmm0
    1a2b:	f2 0f 59 cc          	mulsd  %xmm4,%xmm1
    1a2f:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    1a33:	66 0f 2f c2          	comisd %xmm2,%xmm0
    1a37:	40 0f 97 c6          	seta   %sil
    1a3b:	31 ff                	xor    %edi,%edi
    1a3d:	66 0f 2f d0          	comisd %xmm0,%xmm2
    1a41:	40 0f 97 c7          	seta   %dil
    1a45:	29 fe                	sub    %edi,%esi
    1a47:	0f 84 13 f2 ff ff    	je     c60 <mesh_packet+0x460>
    1a4d:	45 85 c0             	test   %r8d,%r8d
    1a50:	74 09                	je     1a5b <mesh_packet+0x125b>
    1a52:	41 39 f0             	cmp    %esi,%r8d
    1a55:	0f 85 05 f2 ff ff    	jne    c60 <mesh_packet+0x460>
    1a5b:	41 89 f0             	mov    %esi,%r8d
    1a5e:	48 83 c0 01          	add    $0x1,%rax
    1a62:	48 39 c8             	cmp    %rcx,%rax
    1a65:	75 99                	jne    1a00 <mesh_packet+0x1200>
    1a67:	49 83 c3 01          	add    $0x1,%r11
    1a6b:	8b 74 24 08          	mov    0x8(%rsp),%esi
    1a6f:	4c 39 d9             	cmp    %r11,%rcx
    1a72:	0f 85 15 ff ff ff    	jne    198d <mesh_packet+0x118d>
    1a78:	41 0f b6 47 0a       	movzbl 0xa(%r15),%eax
    1a7d:	49 83 c6 01          	add    $0x1,%r14
    1a81:	48 83 c3 44          	add    $0x44,%rbx
    1a85:	41 39 c6             	cmp    %eax,%r14d
    1a88:	0f 82 94 00 00 00    	jb     1b22 <mesh_packet+0x1322>
    1a8e:	b8 01 00 00 00       	mov    $0x1,%eax
    1a93:	e9 ca f1 ff ff       	jmp    c62 <mesh_packet+0x462>
    1a98:	c6 44 24 78 00       	movb   $0x0,0x78(%rsp)
    1a9d:	e9 5f f4 ff ff       	jmp    f01 <mesh_packet+0x701>
    1aa2:	0f b7 94 24 04 01 00 	movzwl 0x104(%rsp),%edx
    1aa9:	00 
    1aaa:	48 8d 8c 24 00 02 00 	lea    0x200(%rsp),%rcx
    1ab1:	00 
    1ab2:	48 83 ec 08          	sub    $0x8,%rsp
    1ab6:	44 0f b6 cd          	movzbl %bpl,%r9d
    1aba:	48 8d 84 24 88 03 00 	lea    0x388(%rsp),%rax
    1ac1:	00 
    1ac2:	4c 89 d6             	mov    %r10,%rsi
    1ac5:	50                   	push   %rax
    1ac6:	43 8d 04 40          	lea    (%r8,%r8,2),%eax
    1aca:	50                   	push   %rax
    1acb:	48 8d 83 5c 02 00 00 	lea    0x25c(%rbx),%rax
    1ad2:	50                   	push   %rax
    1ad3:	48 8b bc 24 08 01 00 	mov    0x108(%rsp),%rdi
    1ada:	00 
    1adb:	44 0f b7 84 24 26 01 	movzwl 0x126(%rsp),%r8d
    1ae2:	00 00 
    1ae4:	e8 00 00 00 00       	call   1ae9 <mesh_packet+0x12e9>
			1ae5: R_X86_64_PLT32	ayatsuri_visibility_select-0x4
    1ae9:	48 83 c4 20          	add    $0x20,%rsp
    1aed:	85 c0                	test   %eax,%eax
    1aef:	0f 85 6b f1 ff ff    	jne    c60 <mesh_packet+0x460>
    1af5:	8b 84 24 80 03 00 00 	mov    0x380(%rsp),%eax
    1afc:	88 43 55             	mov    %al,0x55(%rbx)
    1aff:	41 80 7f 0a 00       	cmpb   $0x0,0xa(%r15)
    1b04:	45 0f b7 4f 08       	movzwl 0x8(%r15),%r9d
    1b09:	74 83                	je     1a8e <mesh_packet+0x128e>
    1b0b:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
    1b10:	48 81 c3 dc 03 00 00 	add    $0x3dc,%rbx
    1b17:	45 31 f6             	xor    %r14d,%r14d
    1b1a:	48 8d ac 24 50 01 00 	lea    0x150(%rsp),%rbp
    1b21:	00 
    1b22:	43 0f b6 44 37 0c    	movzbl 0xc(%r15,%r14,1),%eax
    1b28:	88 03                	mov    %al,(%rbx)
    1b2a:	84 c0                	test   %al,%al
    1b2c:	0f 84 46 ff ff ff    	je     1a78 <mesh_packet+0x1278>
    1b32:	4d 8b 65 00          	mov    0x0(%r13),%r12
    1b36:	45 8b 5d 6c          	mov    0x6c(%r13),%r11d
    1b3a:	48 8d 53 04          	lea    0x4(%rbx),%rdx
    1b3e:	45 31 d2             	xor    %r10d,%r10d
    1b41:	4c 8d 84 24 c0 01 00 	lea    0x1c0(%rsp),%r8
    1b48:	00 
    1b49:	eb 1c                	jmp    1b67 <mesh_packet+0x1367>
    1b4b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    1b50:	0f b6 33             	movzbl (%rbx),%esi
    1b53:	41 83 c2 01          	add    $0x1,%r10d
    1b57:	48 83 c2 08          	add    $0x8,%rdx
    1b5b:	48 89 f1             	mov    %rsi,%rcx
    1b5e:	41 39 f2             	cmp    %esi,%r10d
    1b61:	0f 83 02 fe ff ff    	jae    1969 <mesh_packet+0x1169>
    1b67:	41 83 c1 01          	add    $0x1,%r9d
    1b6b:	48 8d 4a 04          	lea    0x4(%rdx),%rcx
    1b6f:	48 89 ef             	mov    %rbp,%rdi
    1b72:	43 8d 04 49          	lea    (%r9,%r9,2),%eax
    1b76:	8d 34 85 f4 ff ff ff 	lea    -0xc(,%rax,4),%esi
    1b7d:	4c 01 de             	add    %r11,%rsi
    1b80:	4c 01 e6             	add    %r12,%rsi
    1b83:	e8 08 e5 ff ff       	call   90 <mesh_project>
    1b88:	84 c0                	test   %al,%al
    1b8a:	75 c4                	jne    1b50 <mesh_packet+0x1350>
    1b8c:	e9 cf f0 ff ff       	jmp    c60 <mesh_packet+0x460>
    1b91:	85 c0                	test   %eax,%eax
    1b93:	74 63                	je     1bf8 <mesh_packet+0x13f8>
    1b95:	44 8d 68 ff          	lea    -0x1(%rax),%r13d
    1b99:	89 c5                	mov    %eax,%ebp
    1b9b:	4d 89 ec             	mov    %r13,%r12
    1b9e:	4c 8d 8c ec 80 03 00 	lea    0x380(%rsp,%rbp,8),%r9
    1ba5:	00 
    1ba6:	4c 8d 9c 2c 80 01 00 	lea    0x180(%rsp,%rbp,1),%r11
    1bad:	00 
    1bae:	49 29 ec             	sub    %rbp,%r12
    1bb1:	eb 2d                	jmp    1be0 <mesh_packet+0x13e0>
    1bb3:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    1bba:	00 00 00 00 
    1bbe:	66 90                	xchg   %ax,%ax
    1bc0:	4c 89 df             	mov    %r11,%rdi
    1bc3:	f2 41 0f 11 09       	movsd  %xmm1,(%r9)
    1bc8:	49 83 eb 01          	sub    $0x1,%r11
    1bcc:	49 83 e9 08          	sub    $0x8,%r9
    1bd0:	48 29 ef             	sub    %rbp,%rdi
    1bd3:	42 0f b6 3c 2f       	movzbl (%rdi,%r13,1),%edi
    1bd8:	41 88 7b 01          	mov    %dil,0x1(%r11)
    1bdc:	85 c0                	test   %eax,%eax
    1bde:	74 18                	je     1bf8 <mesh_packet+0x13f8>
    1be0:	f2 43 0f 10 0c e1    	movsd  (%r9,%r12,8),%xmm1
    1be6:	89 c7                	mov    %eax,%edi
    1be8:	83 e8 01             	sub    $0x1,%eax
    1beb:	66 0f 2f c8          	comisd %xmm0,%xmm1
    1bef:	77 cf                	ja     1bc0 <mesh_packet+0x13c0>
    1bf1:	89 f8                	mov    %edi,%eax
    1bf3:	e9 2b fc ff ff       	jmp    1823 <mesh_packet+0x1023>
    1bf8:	31 c0                	xor    %eax,%eax
    1bfa:	e9 24 fc ff ff       	jmp    1823 <mesh_packet+0x1023>
    1bff:	31 d2                	xor    %edx,%edx
    1c01:	88 53 55             	mov    %dl,0x55(%rbx)
    1c04:	44 89 84 24 80 03 00 	mov    %r8d,0x380(%rsp)
    1c0b:	00 
    1c0c:	e9 ee fe ff ff       	jmp    1aff <mesh_packet+0x12ff>
    1c11:	89 c2                	mov    %eax,%edx
    1c13:	41 89 c0             	mov    %eax,%r8d
    1c16:	eb e9                	jmp    1c01 <mesh_packet+0x1401>
    1c18:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    1c1f:	00 

0000000000001c20 <ayatsuri_model_open>:
    1c20:	41 57                	push   %r15
    1c22:	41 56                	push   %r14
    1c24:	41 55                	push   %r13
    1c26:	41 54                	push   %r12
    1c28:	55                   	push   %rbp
    1c29:	53                   	push   %rbx
    1c2a:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
    1c31:	48 85 ff             	test   %rdi,%rdi
    1c34:	74 2a                	je     1c60 <ayatsuri_model_open+0x40>
    1c36:	48 89 d5             	mov    %rdx,%rbp
    1c39:	48 85 d2             	test   %rdx,%rdx
    1c3c:	74 22                	je     1c60 <ayatsuri_model_open+0x40>
    1c3e:	48 8d 46 e0          	lea    -0x20(%rsi),%rax
    1c42:	48 3d e0 ff 0f 00    	cmp    $0xfffe0,%rax
    1c48:	77 16                	ja     1c60 <ayatsuri_model_open+0x40>
    1c4a:	48 89 fb             	mov    %rdi,%rbx
    1c4d:	48 39 d7             	cmp    %rdx,%rdi
    1c50:	72 2e                	jb     1c80 <ayatsuri_model_open+0x60>
    1c52:	48 89 fa             	mov    %rdi,%rdx
    1c55:	48 29 ea             	sub    %rbp,%rdx
    1c58:	48 83 fa 7f          	cmp    $0x7f,%rdx
    1c5c:	77 2a                	ja     1c88 <ayatsuri_model_open+0x68>
    1c5e:	66 90                	xchg   %ax,%ax
    1c60:	41 bc 01 00 00 00    	mov    $0x1,%r12d
    1c66:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
    1c6d:	44 89 e0             	mov    %r12d,%eax
    1c70:	5b                   	pop    %rbx
    1c71:	5d                   	pop    %rbp
    1c72:	41 5c                	pop    %r12
    1c74:	41 5d                	pop    %r13
    1c76:	41 5e                	pop    %r14
    1c78:	41 5f                	pop    %r15
    1c7a:	c3                   	ret
    1c7b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    1c80:	48 29 fa             	sub    %rdi,%rdx
    1c83:	48 39 f2             	cmp    %rsi,%rdx
    1c86:	72 d8                	jb     1c60 <ayatsuri_model_open+0x40>
    1c88:	81 3b 41 59 4e 4d    	cmpl   $0x4d4e5941,(%rbx)
    1c8e:	75 d0                	jne    1c60 <ayatsuri_model_open+0x40>
    1c90:	66 83 7b 04 01       	cmpw   $0x1,0x4(%rbx)
    1c95:	75 c9                	jne    1c60 <ayatsuri_model_open+0x40>
    1c97:	66 83 7b 06 20       	cmpw   $0x20,0x6(%rbx)
    1c9c:	75 c2                	jne    1c60 <ayatsuri_model_open+0x40>
    1c9e:	8b 53 08             	mov    0x8(%rbx),%edx
    1ca1:	48 39 f2             	cmp    %rsi,%rdx
    1ca4:	75 ba                	jne    1c60 <ayatsuri_model_open+0x40>
    1ca6:	44 8b 43 0c          	mov    0xc(%rbx),%r8d
    1caa:	41 8d 50 f9          	lea    -0x7(%r8),%edx
    1cae:	83 fa 39             	cmp    $0x39,%edx
    1cb1:	77 ad                	ja     1c60 <ayatsuri_model_open+0x40>
    1cb3:	83 7b 10 20          	cmpl   $0x20,0x10(%rbx)
    1cb7:	75 a7                	jne    1c60 <ayatsuri_model_open+0x40>
    1cb9:	83 7b 14 14          	cmpl   $0x14,0x14(%rbx)
    1cbd:	75 a1                	jne    1c60 <ayatsuri_model_open+0x40>
    1cbf:	8b 53 18             	mov    0x18(%rbx),%edx
    1cc2:	85 d2                	test   %edx,%edx
    1cc4:	75 9a                	jne    1c60 <ayatsuri_model_open+0x40>
    1cc6:	44 8b 63 1c          	mov    0x1c(%rbx),%r12d
    1cca:	45 85 e4             	test   %r12d,%r12d
    1ccd:	75 91                	jne    1c60 <ayatsuri_model_open+0x40>
    1ccf:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
    1cd6:	cc cc cc 
    1cd9:	44 89 c1             	mov    %r8d,%ecx
    1cdc:	48 f7 e2             	mul    %rdx
    1cdf:	48 89 d0             	mov    %rdx,%rax
    1ce2:	48 c1 e8 04          	shr    $0x4,%rax
    1ce6:	48 39 c8             	cmp    %rcx,%rax
    1ce9:	0f 82 71 ff ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    1cef:	41 6b c0 14          	imul   $0x14,%r8d,%eax
    1cf3:	b9 1d 00 00 00       	mov    $0x1d,%ecx
    1cf8:	31 d2                	xor    %edx,%edx
    1cfa:	45 31 ff             	xor    %r15d,%r15d
    1cfd:	48 8d bc 24 9c 00 00 	lea    0x9c(%rsp),%rdi
    1d04:	00 
    1d05:	48 89 9c 24 90 00 00 	mov    %rbx,0x90(%rsp)
    1d0c:	00 
    1d0d:	89 b4 24 98 00 00 00 	mov    %esi,0x98(%rsp)
    1d14:	83 c0 20             	add    $0x20,%eax
    1d17:	89 54 24 08          	mov    %edx,0x8(%rsp)
    1d1b:	44 89 e2             	mov    %r12d,%edx
    1d1e:	89 44 24 0c          	mov    %eax,0xc(%rsp)
    1d22:	31 c0                	xor    %eax,%eax
    1d24:	f3 ab                	rep stos %eax,%es:(%rdi)
    1d26:	48 8d 43 24          	lea    0x24(%rbx),%rax
    1d2a:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
    1d2f:	49 89 c5             	mov    %rax,%r13
    1d32:	41 0f b7 7d fe       	movzwl -0x2(%r13),%edi
    1d37:	45 8b 4d 00          	mov    0x0(%r13),%r9d
    1d3b:	45 8b 55 04          	mov    0x4(%r13),%r10d
    1d3f:	66 83 ff 01          	cmp    $0x1,%di
    1d43:	0f 87 17 ff ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    1d49:	41 f6 c1 07          	test   $0x7,%r9b
    1d4d:	0f 85 0d ff ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    1d53:	8b 44 24 0c          	mov    0xc(%rsp),%eax
    1d57:	41 39 c1             	cmp    %eax,%r9d
    1d5a:	0f 82 00 ff ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    1d60:	45 89 cc             	mov    %r9d,%r12d
    1d63:	4c 39 e6             	cmp    %r12,%rsi
    1d66:	0f 82 f4 fe ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    1d6c:	48 89 f0             	mov    %rsi,%rax
    1d6f:	4c 29 e0             	sub    %r12,%rax
    1d72:	4c 39 d0             	cmp    %r10,%rax
    1d75:	0f 82 e5 fe ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    1d7b:	8b 44 24 08          	mov    0x8(%rsp),%eax
    1d7f:	85 c0                	test   %eax,%eax
    1d81:	74 65                	je     1de8 <ayatsuri_model_open+0x1c8>
    1d83:	4d 85 d2             	test   %r10,%r10
    1d86:	44 89 7c 24 38       	mov    %r15d,0x38(%rsp)
    1d8b:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    1d90:	4e 8d 34 23          	lea    (%rbx,%r12,1),%r14
    1d94:	44 89 44 24 18       	mov    %r8d,0x18(%rsp)
    1d99:	41 0f 95 c3          	setne  %r11b
    1d9d:	eb 15                	jmp    1db4 <ayatsuri_model_open+0x194>
    1d9f:	4d 29 e0             	sub    %r12,%r8
    1da2:	4d 39 d0             	cmp    %r10,%r8
    1da5:	0f 82 b5 fe ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    1dab:	48 83 c0 14          	add    $0x14,%rax
    1daf:	4c 39 e8             	cmp    %r13,%rax
    1db2:	74 2a                	je     1dde <ayatsuri_model_open+0x1be>
    1db4:	8b 48 04             	mov    0x4(%rax),%ecx
    1db7:	48 85 c9             	test   %rcx,%rcx
    1dba:	74 ef                	je     1dab <ayatsuri_model_open+0x18b>
    1dbc:	45 84 db             	test   %r11b,%r11b
    1dbf:	74 ea                	je     1dab <ayatsuri_model_open+0x18b>
    1dc1:	44 8b 00             	mov    (%rax),%r8d
    1dc4:	4e 8d 3c 03          	lea    (%rbx,%r8,1),%r15
    1dc8:	4d 39 f7             	cmp    %r14,%r15
    1dcb:	73 d2                	jae    1d9f <ayatsuri_model_open+0x17f>
    1dcd:	4d 89 e7             	mov    %r12,%r15
    1dd0:	4d 29 c7             	sub    %r8,%r15
    1dd3:	49 39 cf             	cmp    %rcx,%r15
    1dd6:	0f 82 84 fe ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    1ddc:	eb cd                	jmp    1dab <ayatsuri_model_open+0x18b>
    1dde:	44 8b 7c 24 38       	mov    0x38(%rsp),%r15d
    1de3:	44 8b 44 24 18       	mov    0x18(%rsp),%r8d
    1de8:	41 0f b7 4d fc       	movzwl -0x4(%r13),%ecx
    1ded:	66 41 0f 6e 45 08    	movd   0x8(%r13),%xmm0
    1df3:	41 8b 45 0c          	mov    0xc(%r13),%eax
    1df7:	44 8d 59 ff          	lea    -0x1(%rcx),%r11d
    1dfb:	66 41 83 fb 0c       	cmp    $0xc,%r11w
    1e00:	0f 87 f5 01 00 00    	ja     1ffb <ayatsuri_model_open+0x3db>
    1e06:	83 e9 01             	sub    $0x1,%ecx
    1e09:	41 bb 01 00 00 00    	mov    $0x1,%r11d
    1e0f:	41 d3 e3             	shl    %cl,%r11d
    1e12:	66 83 ef 01          	sub    $0x1,%di
    1e16:	0f 85 44 fe ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    1e1c:	45 85 fb             	test   %r15d,%r11d
    1e1f:	0f 85 3b fe ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    1e25:	48 63 c9             	movslq %ecx,%rcx
    1e28:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 1e2f <ayatsuri_model_open+0x20f>
			1e2b: R_X86_64_PC32	.rodata-0x4
    1e2f:	39 04 8f             	cmp    %eax,(%rdi,%rcx,4)
    1e32:	0f 85 28 fe ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    1e38:	66 0f 7e c7          	movd   %xmm0,%edi
    1e3c:	48 0f af c7          	imul   %rdi,%rax
    1e40:	49 39 c2             	cmp    %rax,%r10
    1e43:	0f 85 17 fe ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    1e49:	66 41 0f 6e c9       	movd   %r9d,%xmm1
    1e4e:	45 09 df             	or     %r11d,%r15d
    1e51:	66 0f 62 c8          	punpckldq %xmm0,%xmm1
    1e55:	66 0f d6 8c cc a4 00 	movq   %xmm1,0xa4(%rsp,%rcx,8)
    1e5c:	00 00 
    1e5e:	83 44 24 08 01       	addl   $0x1,0x8(%rsp)
    1e63:	8b 44 24 08          	mov    0x8(%rsp),%eax
    1e67:	49 83 c5 14          	add    $0x14,%r13
    1e6b:	41 39 c0             	cmp    %eax,%r8d
    1e6e:	0f 85 be fe ff ff    	jne    1d32 <ayatsuri_model_open+0x112>
    1e74:	44 89 f8             	mov    %r15d,%eax
    1e77:	41 89 d4             	mov    %edx,%r12d
    1e7a:	f7 d0                	not    %eax
    1e7c:	a8 7f                	test   $0x7f,%al
    1e7e:	0f 85 dc fd ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    1e84:	44 89 f8             	mov    %r15d,%eax
    1e87:	25 00 0f 00 00       	and    $0xf00,%eax
    1e8c:	89 44 24 38          	mov    %eax,0x38(%rsp)
    1e90:	74 0b                	je     1e9d <ayatsuri_model_open+0x27d>
    1e92:	3d 00 0f 00 00       	cmp    $0xf00,%eax
    1e97:	0f 85 c3 fd ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    1e9d:	44 8b ac 24 a8 00 00 	mov    0xa8(%rsp),%r13d
    1ea4:	00 
    1ea5:	41 8d 45 ff          	lea    -0x1(%r13),%eax
    1ea9:	3d ff 00 00 00       	cmp    $0xff,%eax
    1eae:	0f 87 ac fd ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    1eb4:	44 39 ac 24 b0 00 00 	cmp    %r13d,0xb0(%rsp)
    1ebb:	00 
    1ebc:	0f 85 9e fd ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    1ec2:	44 39 ac 24 d0 00 00 	cmp    %r13d,0xd0(%rsp)
    1ec9:	00 
    1eca:	0f 85 90 fd ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    1ed0:	8b 84 24 b8 00 00 00 	mov    0xb8(%rsp),%eax
    1ed7:	89 44 24 0c          	mov    %eax,0xc(%rsp)
    1edb:	41 39 c5             	cmp    %eax,%r13d
    1ede:	0f 82 7c fd ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    1ee4:	8b 8c 24 c0 00 00 00 	mov    0xc0(%rsp),%ecx
    1eeb:	42 8d 04 ed 00 00 00 	lea    0x0(,%r13,8),%eax
    1ef2:	00 
    1ef3:	89 4c 24 10          	mov    %ecx,0x10(%rsp)
    1ef7:	39 c8                	cmp    %ecx,%eax
    1ef9:	0f 82 61 fd ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    1eff:	8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%eax
    1f06:	89 44 24 08          	mov    %eax,0x8(%rsp)
    1f0a:	41 39 c5             	cmp    %eax,%r13d
    1f0d:	0f 82 4d fd ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    1f13:	41 6b c5 7f          	imul   $0x7f,%r13d,%eax
    1f17:	44 8b b4 24 d8 00 00 	mov    0xd8(%rsp),%r14d
    1f1e:	00 
    1f1f:	44 39 f0             	cmp    %r14d,%eax
    1f22:	0f 82 38 fd ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    1f28:	41 f6 c7 80          	test   $0x80,%r15b
    1f2c:	74 13                	je     1f41 <ayatsuri_model_open+0x321>
    1f2e:	8b 84 24 e0 00 00 00 	mov    0xe0(%rsp),%eax
    1f35:	83 e8 01             	sub    $0x1,%eax
    1f38:	44 39 e8             	cmp    %r13d,%eax
    1f3b:	0f 83 1f fd ff ff    	jae    1c60 <ayatsuri_model_open+0x40>
    1f41:	83 7c 24 38 00       	cmpl   $0x0,0x38(%rsp)
    1f46:	74 4c                	je     1f94 <ayatsuri_model_open+0x374>
    1f48:	8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%eax
    1f4f:	83 e8 01             	sub    $0x1,%eax
    1f52:	44 39 e8             	cmp    %r13d,%eax
    1f55:	0f 83 05 fd ff ff    	jae    1c60 <ayatsuri_model_open+0x40>
    1f5b:	44 89 e8             	mov    %r13d,%eax
    1f5e:	c1 e0 05             	shl    $0x5,%eax
    1f61:	3b 84 24 f0 00 00 00 	cmp    0xf0(%rsp),%eax
    1f68:	0f 82 f2 fc ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    1f6e:	44 89 e8             	mov    %r13d,%eax
    1f71:	c1 e0 06             	shl    $0x6,%eax
    1f74:	3b 84 24 f8 00 00 00 	cmp    0xf8(%rsp),%eax
    1f7b:	0f 82 df fc ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    1f81:	44 89 e8             	mov    %r13d,%eax
    1f84:	c1 e0 04             	shl    $0x4,%eax
    1f87:	3b 84 24 00 01 00 00 	cmp    0x100(%rsp),%eax
    1f8e:	0f 82 cc fc ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    1f94:	41 81 e7 00 10 00 00 	and    $0x1000,%r15d
    1f9b:	0f 84 81 00 00 00    	je     2022 <ayatsuri_model_open+0x402>
    1fa1:	8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%ecx
    1fa8:	85 c9                	test   %ecx,%ecx
    1faa:	0f 84 b0 fc ff ff    	je     1c60 <ayatsuri_model_open+0x40>
    1fb0:	39 4c 24 08          	cmp    %ecx,0x8(%rsp)
    1fb4:	0f 85 a6 fc ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    1fba:	8b 84 24 04 01 00 00 	mov    0x104(%rsp),%eax
    1fc1:	31 d2                	xor    %edx,%edx
    1fc3:	48 01 d8             	add    %rbx,%rax
    1fc6:	eb 29                	jmp    1ff1 <ayatsuri_model_open+0x3d1>
    1fc8:	80 78 01 00          	cmpb   $0x0,0x1(%rax)
    1fcc:	0f 85 8e fc ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    1fd2:	80 78 02 00          	cmpb   $0x0,0x2(%rax)
    1fd6:	0f 85 84 fc ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    1fdc:	80 78 03 00          	cmpb   $0x0,0x3(%rax)
    1fe0:	0f 85 7a fc ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    1fe6:	83 c2 01             	add    $0x1,%edx
    1fe9:	48 83 c0 04          	add    $0x4,%rax
    1fed:	39 ca                	cmp    %ecx,%edx
    1fef:	73 31                	jae    2022 <ayatsuri_model_open+0x402>
    1ff1:	80 38 01             	cmpb   $0x1,(%rax)
    1ff4:	76 d2                	jbe    1fc8 <ayatsuri_model_open+0x3a8>
    1ff6:	e9 65 fc ff ff       	jmp    1c60 <ayatsuri_model_open+0x40>
    1ffb:	66 85 ff             	test   %di,%di
    1ffe:	0f 85 5c fc ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    2004:	85 c0                	test   %eax,%eax
    2006:	0f 84 52 fe ff ff    	je     1e5e <ayatsuri_model_open+0x23e>
    200c:	66 0f 7e c1          	movd   %xmm0,%ecx
    2010:	48 0f af c1          	imul   %rcx,%rax
    2014:	49 39 c2             	cmp    %rax,%r10
    2017:	0f 83 41 fe ff ff    	jae    1e5e <ayatsuri_model_open+0x23e>
    201d:	e9 3e fc ff ff       	jmp    1c60 <ayatsuri_model_open+0x40>
    2022:	8b 84 24 f0 00 00 00 	mov    0xf0(%rsp),%eax
    2029:	44 8b 84 24 ec 00 00 	mov    0xec(%rsp),%r8d
    2030:	00 
    2031:	31 d2                	xor    %edx,%edx
    2033:	66 44 89 ac 24 9c 00 	mov    %r13w,0x9c(%rsp)
    203a:	00 00 
    203c:	f3 0f 10 25 00 00 00 	movss  0x0(%rip),%xmm4        # 2044 <ayatsuri_model_open+0x424>
    2043:	00 
			2040: R_X86_64_PC32	.LC1-0x4
    2044:	f3 0f 7e 1d 00 00 00 	movq   0x0(%rip),%xmm3        # 204c <ayatsuri_model_open+0x42c>
    204b:	00 
			2048: R_X86_64_PC32	.LC8-0x4
    204c:	f3 0f 10 2d 00 00 00 	movss  0x0(%rip),%xmm5        # 2054 <ayatsuri_model_open+0x434>
    2053:	00 
			2050: R_X86_64_PC32	.LC0-0x4
    2054:	89 44 24 18          	mov    %eax,0x18(%rsp)
    2058:	8b 44 24 18          	mov    0x18(%rsp),%eax
    205c:	39 c2                	cmp    %eax,%edx
    205e:	74 61                	je     20c1 <ayatsuri_model_open+0x4a1>
    2060:	6b ca 1c             	imul   $0x1c,%edx,%ecx
    2063:	31 c0                	xor    %eax,%eax
    2065:	66 0f ef c0          	pxor   %xmm0,%xmm0
    2069:	4c 01 c1             	add    %r8,%rcx
    206c:	48 01 d9             	add    %rbx,%rcx
    206f:	f3 0f 10 0c 81       	movss  (%rcx,%rax,4),%xmm1
    2074:	0f 28 d1             	movaps %xmm1,%xmm2
    2077:	0f 54 d5             	andps  %xmm5,%xmm2
    207a:	0f 2e e2             	ucomiss %xmm2,%xmm4
    207d:	0f 82 dd fb ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    2083:	0f 2f 15 00 00 00 00 	comiss 0x0(%rip),%xmm2        # 208a <ayatsuri_model_open+0x46a>
			2086: R_X86_64_PC32	.LC3-0x4
    208a:	0f 87 d0 fb ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    2090:	8d 70 fd             	lea    -0x3(%rax),%esi
    2093:	83 fe 02             	cmp    $0x2,%esi
    2096:	76 7d                	jbe    2115 <ayatsuri_model_open+0x4f5>
    2098:	48 83 c0 01          	add    $0x1,%rax
    209c:	48 83 f8 07          	cmp    $0x7,%rax
    20a0:	75 cd                	jne    206f <ayatsuri_model_open+0x44f>
    20a2:	f2 0f 5c 05 00 00 00 	subsd  0x0(%rip),%xmm0        # 20aa <ayatsuri_model_open+0x48a>
    20a9:	00 
			20a6: R_X86_64_PC32	.LC9-0x4
    20aa:	66 0f 54 c3          	andpd  %xmm3,%xmm0
    20ae:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 20b6 <ayatsuri_model_open+0x496>
    20b5:	00 
			20b2: R_X86_64_PC32	.LC29-0x4
    20b6:	0f 87 a4 fb ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    20bc:	83 c2 01             	add    $0x1,%edx
    20bf:	eb 97                	jmp    2058 <ayatsuri_model_open+0x438>
    20c1:	8b 84 24 f8 00 00 00 	mov    0xf8(%rsp),%eax
    20c8:	31 d2                	xor    %edx,%edx
    20ca:	89 44 24 28          	mov    %eax,0x28(%rsp)
    20ce:	8b 84 24 f4 00 00 00 	mov    0xf4(%rsp),%eax
    20d5:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
    20da:	8b 44 24 28          	mov    0x28(%rsp),%eax
    20de:	39 c2                	cmp    %eax,%edx
    20e0:	74 48                	je     212a <ayatsuri_model_open+0x50a>
    20e2:	6b c2 06             	imul   $0x6,%edx,%eax
    20e5:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    20ea:	48 01 c8             	add    %rcx,%rax
    20ed:	66 83 3c 03 1f       	cmpw   $0x1f,(%rbx,%rax,1)
    20f2:	0f 87 68 fb ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    20f8:	66 83 7c 03 02 1f    	cmpw   $0x1f,0x2(%rbx,%rax,1)
    20fe:	0f 87 5c fb ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    2104:	66 83 7c 03 04 1f    	cmpw   $0x1f,0x4(%rbx,%rax,1)
    210a:	0f 87 50 fb ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    2110:	83 c2 01             	add    $0x1,%edx
    2113:	eb c5                	jmp    20da <ayatsuri_model_open+0x4ba>
    2115:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
    2119:	f2 0f 59 c9          	mulsd  %xmm1,%xmm1
    211d:	48 83 c0 01          	add    $0x1,%rax
    2121:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    2125:	e9 45 ff ff ff       	jmp    206f <ayatsuri_model_open+0x44f>
    212a:	8b 84 24 00 01 00 00 	mov    0x100(%rsp),%eax
    2131:	8b b4 24 fc 00 00 00 	mov    0xfc(%rsp),%esi
    2138:	31 d2                	xor    %edx,%edx
    213a:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 2142 <ayatsuri_model_open+0x522>
    2141:	00 
			213e: R_X86_64_PC32	.LC0-0x4
    2142:	f3 0f 10 0d 00 00 00 	movss  0x0(%rip),%xmm1        # 214a <ayatsuri_model_open+0x52a>
    2149:	00 
			2146: R_X86_64_PC32	.LC1-0x4
    214a:	89 44 24 30          	mov    %eax,0x30(%rsp)
    214e:	8b 44 24 30          	mov    0x30(%rsp),%eax
    2152:	39 c2                	cmp    %eax,%edx
    2154:	74 38                	je     218e <ayatsuri_model_open+0x56e>
    2156:	6b c2 0c             	imul   $0xc,%edx,%eax
    2159:	31 c9                	xor    %ecx,%ecx
    215b:	48 01 f0             	add    %rsi,%rax
    215e:	48 01 d8             	add    %rbx,%rax
    2161:	f3 0f 10 04 88       	movss  (%rax,%rcx,4),%xmm0
    2166:	0f 54 c2             	andps  %xmm2,%xmm0
    2169:	0f 2e c8             	ucomiss %xmm0,%xmm1
    216c:	0f 82 ee fa ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    2172:	0f 2f 05 00 00 00 00 	comiss 0x0(%rip),%xmm0        # 2179 <ayatsuri_model_open+0x559>
			2175: R_X86_64_PC32	.LC3-0x4
    2179:	0f 87 e1 fa ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    217f:	48 83 c1 01          	add    $0x1,%rcx
    2183:	48 83 f9 03          	cmp    $0x3,%rcx
    2187:	75 d8                	jne    2161 <ayatsuri_model_open+0x541>
    2189:	83 c2 01             	add    $0x1,%edx
    218c:	eb c0                	jmp    214e <ayatsuri_model_open+0x52e>
    218e:	8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%eax
    2195:	48 89 6c 24 48       	mov    %rbp,0x48(%rsp)
    219a:	31 d2                	xor    %edx,%edx
    219c:	66 0f ef f6          	pxor   %xmm6,%xmm6
    21a0:	89 44 24 3c          	mov    %eax,0x3c(%rsp)
    21a4:	8b 84 24 e4 00 00 00 	mov    0xe4(%rsp),%eax
    21ab:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
    21b0:	8b 44 24 3c          	mov    0x3c(%rsp),%eax
    21b4:	39 c2                	cmp    %eax,%edx
    21b6:	0f 84 5c 02 00 00    	je     2418 <ayatsuri_model_open+0x7f8>
    21bc:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
    21c1:	89 d0                	mov    %edx,%eax
    21c3:	c1 e0 05             	shl    $0x5,%eax
    21c6:	48 01 c8             	add    %rcx,%rax
    21c9:	48 01 d8             	add    %rbx,%rax
    21cc:	44 0f b7 50 02       	movzwl 0x2(%rax),%r10d
    21d1:	44 0f b7 08          	movzwl (%rax),%r9d
    21d5:	0f b7 48 04          	movzwl 0x4(%rax),%ecx
    21d9:	44 0f b7 58 06       	movzwl 0x6(%rax),%r11d
    21de:	41 8d 72 fd          	lea    -0x3(%r10),%esi
    21e2:	0f b7 68 08          	movzwl 0x8(%rax),%ebp
    21e6:	83 fe 1d             	cmp    $0x1d,%esi
    21e9:	0f 87 71 fa ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    21ef:	41 8d 73 ff          	lea    -0x1(%r11),%esi
    21f3:	83 fe 3f             	cmp    $0x3f,%esi
    21f6:	0f 87 64 fa ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    21fc:	0f b6 78 0a          	movzbl 0xa(%rax),%edi
    2200:	40 80 ff 02          	cmp    $0x2,%dil
    2204:	0f 87 56 fa ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    220a:	80 78 0b 01          	cmpb   $0x1,0xb(%rax)
    220e:	0f 87 4c fa ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    2214:	8b 74 24 18          	mov    0x18(%rsp),%esi
    2218:	44 39 ce             	cmp    %r9d,%esi
    221b:	0f 82 3f fa ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    2221:	44 29 ce             	sub    %r9d,%esi
    2224:	44 39 d6             	cmp    %r10d,%esi
    2227:	0f 82 33 fa ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    222d:	8b 74 24 28          	mov    0x28(%rsp),%esi
    2231:	39 ce                	cmp    %ecx,%esi
    2233:	0f 82 27 fa ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    2239:	29 ce                	sub    %ecx,%esi
    223b:	44 39 de             	cmp    %r11d,%esi
    223e:	0f 82 1c fa ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    2244:	0f b6 70 0c          	movzbl 0xc(%rax),%esi
    2248:	40 84 ff             	test   %dil,%dil
    224b:	0f 85 94 01 00 00    	jne    23e5 <ayatsuri_model_open+0x7c5>
    2251:	40 84 f6             	test   %sil,%sil
    2254:	0f 85 06 fa ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    225a:	31 f6                	xor    %esi,%esi
    225c:	80 78 0d 00          	cmpb   $0x0,0xd(%rax)
    2260:	0f 85 fa f9 ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    2266:	8b 7c 24 30          	mov    0x30(%rsp),%edi
    226a:	39 ef                	cmp    %ebp,%edi
    226c:	0f 82 ee f9 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    2272:	29 ef                	sub    %ebp,%edi
    2274:	39 f7                	cmp    %esi,%edi
    2276:	0f 82 e4 f9 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    227c:	be 13 00 00 00       	mov    $0x13,%esi
    2281:	80 3c 30 00          	cmpb   $0x0,(%rax,%rsi,1)
    2285:	0f 85 d5 f9 ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    228b:	48 83 c6 01          	add    $0x1,%rsi
    228f:	48 83 fe 20          	cmp    $0x20,%rsi
    2293:	75 ec                	jne    2281 <ayatsuri_model_open+0x661>
    2295:	6b f9 06             	imul   $0x6,%ecx,%edi
    2298:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
    229d:	31 ed                	xor    %ebp,%ebp
    229f:	48 01 c7             	add    %rax,%rdi
    22a2:	48 01 df             	add    %rbx,%rdi
    22a5:	0f b7 0f             	movzwl (%rdi),%ecx
    22a8:	0f b7 47 02          	movzwl 0x2(%rdi),%eax
    22ac:	0f b7 77 04          	movzwl 0x4(%rdi),%esi
    22b0:	39 c1                	cmp    %eax,%ecx
    22b2:	41 89 c7             	mov    %eax,%r15d
    22b5:	44 0f 43 f9          	cmovae %ecx,%r15d
    22b9:	45 39 d7             	cmp    %r10d,%r15d
    22bc:	0f 83 9e f9 ff ff    	jae    1c60 <ayatsuri_model_open+0x40>
    22c2:	44 39 d6             	cmp    %r10d,%esi
    22c5:	0f 83 95 f9 ff ff    	jae    1c60 <ayatsuri_model_open+0x40>
    22cb:	39 c1                	cmp    %eax,%ecx
    22cd:	0f 84 8d f9 ff ff    	je     1c60 <ayatsuri_model_open+0x40>
    22d3:	39 f1                	cmp    %esi,%ecx
    22d5:	0f 84 85 f9 ff ff    	je     1c60 <ayatsuri_model_open+0x40>
    22db:	39 f0                	cmp    %esi,%eax
    22dd:	41 0f 94 c7          	sete   %r15b
    22e1:	0f 84 79 f9 ff ff    	je     1c60 <ayatsuri_model_open+0x40>
    22e7:	44 01 c9             	add    %r9d,%ecx
    22ea:	44 01 c8             	add    %r9d,%eax
    22ed:	66 0f ef ed          	pxor   %xmm5,%xmm5
    22f1:	44 01 ce             	add    %r9d,%esi
    22f4:	6b c9 1c             	imul   $0x1c,%ecx,%ecx
    22f7:	66 0f ef c0          	pxor   %xmm0,%xmm0
    22fb:	66 0f ef e4          	pxor   %xmm4,%xmm4
    22ff:	6b c0 1c             	imul   $0x1c,%eax,%eax
    2302:	66 0f ef db          	pxor   %xmm3,%xmm3
    2306:	66 0f ef d2          	pxor   %xmm2,%xmm2
    230a:	6b f6 1c             	imul   $0x1c,%esi,%esi
    230d:	66 0f ef ff          	pxor   %xmm7,%xmm7
    2311:	66 0f ef c9          	pxor   %xmm1,%xmm1
    2315:	4c 01 c1             	add    %r8,%rcx
    2318:	4c 01 c0             	add    %r8,%rax
    231b:	48 01 d9             	add    %rbx,%rcx
    231e:	4c 01 c6             	add    %r8,%rsi
    2321:	48 01 d8             	add    %rbx,%rax
    2324:	f3 0f 5a 29          	cvtss2sd (%rcx),%xmm5
    2328:	f3 0f 5a 59 04       	cvtss2sd 0x4(%rcx),%xmm3
    232d:	48 01 de             	add    %rbx,%rsi
    2330:	f3 0f 5a 00          	cvtss2sd (%rax),%xmm0
    2334:	f2 0f 5c c5          	subsd  %xmm5,%xmm0
    2338:	f3 0f 5a 79 08       	cvtss2sd 0x8(%rcx),%xmm7
    233d:	f3 0f 5a 26          	cvtss2sd (%rsi),%xmm4
    2341:	f2 0f 5c e5          	subsd  %xmm5,%xmm4
    2345:	66 0f ef ed          	pxor   %xmm5,%xmm5
    2349:	f3 0f 5a 50 04       	cvtss2sd 0x4(%rax),%xmm2
    234e:	f3 0f 5a 48 08       	cvtss2sd 0x8(%rax),%xmm1
    2353:	f2 0f 5c d3          	subsd  %xmm3,%xmm2
    2357:	f2 0f 5c cf          	subsd  %xmm7,%xmm1
    235b:	f3 0f 5a 6e 04       	cvtss2sd 0x4(%rsi),%xmm5
    2360:	f2 0f 5c eb          	subsd  %xmm3,%xmm5
    2364:	66 0f ef db          	pxor   %xmm3,%xmm3
    2368:	f3 0f 5a 5e 08       	cvtss2sd 0x8(%rsi),%xmm3
    236d:	f2 0f 5c df          	subsd  %xmm7,%xmm3
    2371:	66 44 0f 28 c1       	movapd %xmm1,%xmm8
    2376:	66 0f 28 fa          	movapd %xmm2,%xmm7
    237a:	f2 44 0f 59 c5       	mulsd  %xmm5,%xmm8
    237f:	f2 0f 59 fb          	mulsd  %xmm3,%xmm7
    2383:	f2 0f 59 cc          	mulsd  %xmm4,%xmm1
    2387:	f2 0f 59 d8          	mulsd  %xmm0,%xmm3
    238b:	f2 41 0f 5c f8       	subsd  %xmm8,%xmm7
    2390:	f2 0f 5c cb          	subsd  %xmm3,%xmm1
    2394:	66 0f 2e fe          	ucomisd %xmm6,%xmm7
    2398:	0f 9b c0             	setnp  %al
    239b:	41 0f 45 c7          	cmovne %r15d,%eax
    239f:	66 0f 2e ce          	ucomisd %xmm6,%xmm1
    23a3:	0f 9b c1             	setnp  %cl
    23a6:	41 0f 45 cf          	cmovne %r15d,%ecx
    23aa:	84 c8                	test   %cl,%al
    23ac:	74 1f                	je     23cd <ayatsuri_model_open+0x7ad>
    23ae:	f2 0f 59 c5          	mulsd  %xmm5,%xmm0
    23b2:	f2 0f 59 d4          	mulsd  %xmm4,%xmm2
    23b6:	f2 0f 5c c2          	subsd  %xmm2,%xmm0
    23ba:	66 0f 2e c6          	ucomisd %xmm6,%xmm0
    23be:	0f 9b c0             	setnp  %al
    23c1:	41 0f 45 c7          	cmovne %r15d,%eax
    23c5:	84 c0                	test   %al,%al
    23c7:	0f 85 93 f8 ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    23cd:	83 c5 01             	add    $0x1,%ebp
    23d0:	48 83 c7 06          	add    $0x6,%rdi
    23d4:	44 39 dd             	cmp    %r11d,%ebp
    23d7:	0f 82 c8 fe ff ff    	jb     22a5 <ayatsuri_model_open+0x685>
    23dd:	83 c2 01             	add    $0x1,%edx
    23e0:	e9 cb fd ff ff       	jmp    21b0 <ayatsuri_model_open+0x590>
    23e5:	44 8d 7e fd          	lea    -0x3(%rsi),%r15d
    23e9:	41 80 ff 05          	cmp    $0x5,%r15b
    23ed:	0f 87 6d f8 ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    23f3:	44 0f b6 78 0d       	movzbl 0xd(%rax),%r15d
    23f8:	40 80 ff 02          	cmp    $0x2,%dil
    23fc:	0f 85 5a fe ff ff    	jne    225c <ayatsuri_model_open+0x63c>
    2402:	41 8d 7f fd          	lea    -0x3(%r15),%edi
    2406:	40 80 ff 05          	cmp    $0x5,%dil
    240a:	0f 87 50 f8 ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    2410:	44 01 fe             	add    %r15d,%esi
    2413:	e9 4e fe ff ff       	jmp    2266 <ayatsuri_model_open+0x646>
    2418:	8b 84 24 d4 00 00 00 	mov    0xd4(%rsp),%eax
    241f:	48 8b 6c 24 48       	mov    0x48(%rsp),%rbp
    2424:	48 89 c1             	mov    %rax,%rcx
    2427:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
    242c:	31 c0                	xor    %eax,%eax
    242e:	48 01 d9             	add    %rbx,%rcx
    2431:	eb 21                	jmp    2454 <ayatsuri_model_open+0x834>
    2433:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    243a:	00 00 00 00 
    243e:	66 90                	xchg   %ax,%ax
    2440:	0f b6 3c 01          	movzbl (%rcx,%rax,1),%edi
    2444:	48 83 c0 01          	add    $0x1,%rax
    2448:	8d 57 e0             	lea    -0x20(%rdi),%edx
    244b:	80 fa 5e             	cmp    $0x5e,%dl
    244e:	0f 87 0c f8 ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    2454:	44 39 f0             	cmp    %r14d,%eax
    2457:	72 e7                	jb     2440 <ayatsuri_model_open+0x820>
    2459:	8b 84 24 ac 00 00 00 	mov    0xac(%rsp),%eax
    2460:	b9 09 00 00 00       	mov    $0x9,%ecx
    2465:	ba 09 00 00 00       	mov    $0x9,%edx
    246a:	44 89 ee             	mov    %r13d,%esi
    246d:	48 01 d8             	add    %rbx,%rax
    2470:	48 89 c7             	mov    %rax,%rdi
    2473:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
    2478:	e8 93 db ff ff       	call   10 <float_rows_valid>
    247d:	84 c0                	test   %al,%al
    247f:	0f 84 db f7 ff ff    	je     1c60 <ayatsuri_model_open+0x40>
    2485:	8b bc 24 b4 00 00 00 	mov    0xb4(%rsp),%edi
    248c:	8b 74 24 0c          	mov    0xc(%rsp),%esi
    2490:	31 c9                	xor    %ecx,%ecx
    2492:	ba 03 00 00 00       	mov    $0x3,%edx
    2497:	48 01 df             	add    %rbx,%rdi
    249a:	e8 71 db ff ff       	call   10 <float_rows_valid>
    249f:	84 c0                	test   %al,%al
    24a1:	0f 84 b9 f7 ff ff    	je     1c60 <ayatsuri_model_open+0x40>
    24a7:	8b bc 24 bc 00 00 00 	mov    0xbc(%rsp),%edi
    24ae:	8b 74 24 10          	mov    0x10(%rsp),%esi
    24b2:	b9 03 00 00 00       	mov    $0x3,%ecx
    24b7:	ba 06 00 00 00       	mov    $0x6,%edx
    24bc:	48 01 df             	add    %rbx,%rdi
    24bf:	e8 4c db ff ff       	call   10 <float_rows_valid>
    24c4:	84 c0                	test   %al,%al
    24c6:	0f 84 94 f7 ff ff    	je     1c60 <ayatsuri_model_open+0x40>
    24cc:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
    24d0:	8b bc 24 c4 00 00 00 	mov    0xc4(%rsp),%edi
    24d7:	f3 0f 7e 15 00 00 00 	movq   0x0(%rip),%xmm2        # 24df <ayatsuri_model_open+0x8bf>
    24de:	00 
			24db: R_X86_64_PC32	.LC8-0x4
    24df:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 24e7 <ayatsuri_model_open+0x8c7>
    24e6:	00 
			24e3: R_X86_64_PC32	.LC22-0x4
    24e7:	48 6b c9 48          	imul   $0x48,%rcx,%rcx
    24eb:	48 89 7c 24 48       	mov    %rdi,0x48(%rsp)
    24f0:	48 8d 14 3b          	lea    (%rbx,%rdi,1),%rdx
    24f4:	48 01 f9             	add    %rdi,%rcx
    24f7:	48 01 d9             	add    %rbx,%rcx
    24fa:	48 39 ca             	cmp    %rcx,%rdx
    24fd:	0f 84 02 01 00 00    	je     2605 <ayatsuri_model_open+0x9e5>
    2503:	31 f6                	xor    %esi,%esi
    2505:	f3 0f 10 04 b2       	movss  (%rdx,%rsi,4),%xmm0
    250a:	48 83 fe 03          	cmp    $0x3,%rsi
    250e:	0f 84 bd 02 00 00    	je     27d1 <ayatsuri_model_open+0xbb1>
    2514:	66 0f ef db          	pxor   %xmm3,%xmm3
    2518:	f3 0f 5a d8          	cvtss2sd %xmm0,%xmm3
    251c:	66 0f 54 da          	andpd  %xmm2,%xmm3
    2520:	66 0f 2e cb          	ucomisd %xmm3,%xmm1
    2524:	0f 82 36 f7 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    252a:	66 0f ef db          	pxor   %xmm3,%xmm3
    252e:	0f 2f c3             	comiss %xmm3,%xmm0
    2531:	0f 82 29 f7 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    2537:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 253f <ayatsuri_model_open+0x91f>
    253e:	00 
			253b: R_X86_64_PC32	.LC15-0x4
    253f:	0f 2f d8             	comiss %xmm0,%xmm3
    2542:	0f 82 18 f7 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    2548:	48 83 c6 01          	add    $0x1,%rsi
    254c:	48 83 fe 0b          	cmp    $0xb,%rsi
    2550:	75 b3                	jne    2505 <ayatsuri_model_open+0x8e5>
    2552:	81 7a 2c ff ff ff 00 	cmpl   $0xffffff,0x2c(%rdx)
    2559:	0f 87 01 f7 ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    255f:	48 8d 7a 30          	lea    0x30(%rdx),%rdi
    2563:	e8 98 da ff ff       	call   0 <md>
    2568:	66 0f 28 d8          	movapd %xmm0,%xmm3
    256c:	66 0f 54 da          	andpd  %xmm2,%xmm3
    2570:	66 0f 2e cb          	ucomisd %xmm3,%xmm1
    2574:	0f 82 e6 f6 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    257a:	66 0f ef db          	pxor   %xmm3,%xmm3
    257e:	66 0f 2f c3          	comisd %xmm3,%xmm0
    2582:	0f 82 d8 f6 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    2588:	f2 0f 10 1d 00 00 00 	movsd  0x0(%rip),%xmm3        # 2590 <ayatsuri_model_open+0x970>
    258f:	00 
			258c: R_X86_64_PC32	.LC9-0x4
    2590:	66 0f 2f d8          	comisd %xmm0,%xmm3
    2594:	0f 82 c6 f6 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    259a:	48 8d 7a 38          	lea    0x38(%rdx),%rdi
    259e:	e8 5d da ff ff       	call   0 <md>
    25a3:	66 0f 28 e0          	movapd %xmm0,%xmm4
    25a7:	66 0f 54 e2          	andpd  %xmm2,%xmm4
    25ab:	66 0f 2e cc          	ucomisd %xmm4,%xmm1
    25af:	0f 82 ab f6 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    25b5:	66 0f ef e4          	pxor   %xmm4,%xmm4
    25b9:	66 0f 2f c4          	comisd %xmm4,%xmm0
    25bd:	0f 82 9d f6 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    25c3:	66 0f 2f d8          	comisd %xmm0,%xmm3
    25c7:	0f 82 93 f6 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    25cd:	48 8d 7a 40          	lea    0x40(%rdx),%rdi
    25d1:	e8 2a da ff ff       	call   0 <md>
    25d6:	66 0f 28 e8          	movapd %xmm0,%xmm5
    25da:	66 0f 54 ea          	andpd  %xmm2,%xmm5
    25de:	66 0f 2e cd          	ucomisd %xmm5,%xmm1
    25e2:	0f 82 78 f6 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    25e8:	66 0f 2f c4          	comisd %xmm4,%xmm0
    25ec:	0f 82 6e f6 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    25f2:	48 83 c2 48          	add    $0x48,%rdx
    25f6:	66 0f 2f d8          	comisd %xmm0,%xmm3
    25fa:	0f 82 60 f6 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    2600:	e9 f5 fe ff ff       	jmp    24fa <ayatsuri_model_open+0x8da>
    2605:	8b bc 24 08 01 00 00 	mov    0x108(%rsp),%edi
    260c:	8b 8c 24 a4 00 00 00 	mov    0xa4(%rsp),%ecx
    2613:	88 44 24 63          	mov    %al,0x63(%rsp)
    2617:	45 31 d2             	xor    %r10d,%r10d
    261a:	8b 94 24 04 01 00 00 	mov    0x104(%rsp),%edx
    2621:	4c 8b 5c 24 28       	mov    0x28(%rsp),%r11
    2626:	48 01 d9             	add    %rbx,%rcx
    2629:	89 7c 24 40          	mov    %edi,0x40(%rsp)
    262d:	8b bc 24 cc 00 00 00 	mov    0xcc(%rsp),%edi
    2634:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
    2639:	49 89 cf             	mov    %rcx,%r15
    263c:	48 8d 0c 13          	lea    (%rbx,%rdx,1),%rcx
    2640:	4c 87 dd             	xchg   %r11,%rbp
    2643:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
    2648:	48 8d 8c 24 90 00 00 	lea    0x90(%rsp),%rcx
    264f:	00 
    2650:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
    2655:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
    265a:	48 89 d9             	mov    %rbx,%rcx
    265d:	44 89 d3             	mov    %r10d,%ebx
    2660:	45 89 e2             	mov    %r12d,%r10d
    2663:	49 89 cc             	mov    %rcx,%r12
    2666:	41 0f b7 17          	movzwl (%r15),%edx
    266a:	89 d0                	mov    %edx,%eax
    266c:	0d 00 00 ff ff       	or     $0xffff0000,%eax
    2671:	66 85 d2             	test   %dx,%dx
    2674:	78 03                	js     2679 <ayatsuri_model_open+0xa59>
    2676:	0f b7 c2             	movzwl %dx,%eax
    2679:	41 0f b7 77 04       	movzwl 0x4(%r15),%esi
    267e:	41 0f b7 7f 06       	movzwl 0x6(%r15),%edi
    2683:	41 0f b7 57 08       	movzwl 0x8(%r15),%edx
    2688:	45 0f b7 47 0a       	movzwl 0xa(%r15),%r8d
    268d:	f3 41 0f 10 47 0c    	movss  0xc(%r15),%xmm0
    2693:	83 f8 ff             	cmp    $0xffffffff,%eax
    2696:	0f 8c c4 f5 ff ff    	jl     1c60 <ayatsuri_model_open+0x40>
    269c:	39 c3                	cmp    %eax,%ebx
    269e:	0f 8e bc f5 ff ff    	jle    1c60 <ayatsuri_model_open+0x40>
    26a4:	41 0f b6 47 02       	movzbl 0x2(%r15),%eax
    26a9:	3c 03                	cmp    $0x3,%al
    26ab:	0f 87 af f5 ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    26b1:	41 80 7f 03 01       	cmpb   $0x1,0x3(%r15)
    26b6:	0f 87 a4 f5 ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    26bc:	45 39 e8             	cmp    %r13d,%r8d
    26bf:	0f 83 9b f5 ff ff    	jae    1c60 <ayatsuri_model_open+0x40>
    26c5:	f3 0f 10 35 00 00 00 	movss  0x0(%rip),%xmm6        # 26cd <ayatsuri_model_open+0xaad>
    26cc:	00 
			26c9: R_X86_64_PC32	.LC1-0x4
    26cd:	0f 28 c8             	movaps %xmm0,%xmm1
    26d0:	0f 54 0d 00 00 00 00 	andps  0x0(%rip),%xmm1        # 26d7 <ayatsuri_model_open+0xab7>
			26d3: R_X86_64_PC32	.LC0-0x4
    26d7:	0f 2e f1             	ucomiss %xmm1,%xmm6
    26da:	0f 82 80 f5 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    26e0:	f3 0f 10 4d 18       	movss  0x18(%rbp),%xmm1
    26e5:	66 0f ef f6          	pxor   %xmm6,%xmm6
    26e9:	0f 2e ce             	ucomiss %xmm6,%xmm1
    26ec:	7a 06                	jp     26f4 <ayatsuri_model_open+0xad4>
    26ee:	0f 84 6c f5 ff ff    	je     1c60 <ayatsuri_model_open+0x40>
    26f4:	f3 0f 10 4d 1c       	movss  0x1c(%rbp),%xmm1
    26f9:	66 0f ef f6          	pxor   %xmm6,%xmm6
    26fd:	0f 2e ce             	ucomiss %xmm6,%xmm1
    2700:	7a 06                	jp     2708 <ayatsuri_model_open+0xae8>
    2702:	0f 84 58 f5 ff ff    	je     1c60 <ayatsuri_model_open+0x40>
    2708:	f3 0f 10 4d 20       	movss  0x20(%rbp),%xmm1
    270d:	66 0f ef f6          	pxor   %xmm6,%xmm6
    2711:	0f 2e ce             	ucomiss %xmm6,%xmm1
    2714:	7a 06                	jp     271c <ayatsuri_model_open+0xafc>
    2716:	0f 84 44 f5 ff ff    	je     1c60 <ayatsuri_model_open+0x40>
    271c:	84 c0                	test   %al,%al
    271e:	0f 85 3e 01 00 00    	jne    2862 <ayatsuri_model_open+0xc42>
    2724:	66 0f ef ff          	pxor   %xmm7,%xmm7
    2728:	b9 01 00 00 00       	mov    $0x1,%ecx
    272d:	0f 2e c7             	ucomiss %xmm7,%xmm0
    2730:	41 0f 9a c1          	setp   %r9b
    2734:	44 0f 45 c9          	cmovne %ecx,%r9d
    2738:	66 85 ff             	test   %di,%di
    273b:	40 0f 95 c7          	setne  %dil
    273f:	44 08 cf             	or     %r9b,%dil
    2742:	0f 85 18 f5 ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    2748:	21 f2                	and    %esi,%edx
    274a:	66 83 c2 01          	add    $0x1,%dx
    274e:	0f 85 0c f5 ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    2754:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    2759:	42 8d 14 c5 00 00 00 	lea    0x0(,%r8,8),%edx
    2760:	00 
    2761:	48 01 ca             	add    %rcx,%rdx
    2764:	4c 01 e2             	add    %r12,%rdx
    2767:	44 0f b7 42 02       	movzwl 0x2(%rdx),%r8d
    276c:	8b 7a 04             	mov    0x4(%rdx),%edi
    276f:	0f b7 12             	movzwl (%rdx),%edx
    2772:	39 da                	cmp    %ebx,%edx
    2774:	0f 85 e6 f4 ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    277a:	41 8d 50 ff          	lea    -0x1(%r8),%edx
    277e:	66 83 fa 7e          	cmp    $0x7e,%dx
    2782:	40 0f 97 c6          	seta   %sil
    2786:	41 39 fe             	cmp    %edi,%r14d
    2789:	0f 92 c2             	setb   %dl
    278c:	40 08 d6             	or     %dl,%sil
    278f:	40 88 74 24 28       	mov    %sil,0x28(%rsp)
    2794:	0f 85 c6 f4 ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    279a:	44 89 f6             	mov    %r14d,%esi
    279d:	41 0f b7 d0          	movzwl %r8w,%edx
    27a1:	29 fe                	sub    %edi,%esi
    27a3:	39 d6                	cmp    %edx,%esi
    27a5:	0f 82 b5 f4 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    27ab:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
    27b0:	31 f6                	xor    %esi,%esi
    27b2:	48 01 cf             	add    %rcx,%rdi
    27b5:	4c 01 e7             	add    %r12,%rdi
    27b8:	39 d6                	cmp    %edx,%esi
    27ba:	73 58                	jae    2814 <ayatsuri_model_open+0xbf4>
    27bc:	0f b6 0c 37          	movzbl (%rdi,%rsi,1),%ecx
    27c0:	48 83 c6 01          	add    $0x1,%rsi
    27c4:	83 e9 20             	sub    $0x20,%ecx
    27c7:	80 f9 5e             	cmp    $0x5e,%cl
    27ca:	76 ec                	jbe    27b8 <ayatsuri_model_open+0xb98>
    27cc:	e9 8f f4 ff ff       	jmp    1c60 <ayatsuri_model_open+0x40>
    27d1:	f3 0f 10 25 00 00 00 	movss  0x0(%rip),%xmm4        # 27d9 <ayatsuri_model_open+0xbb9>
    27d8:	00 
			27d5: R_X86_64_PC32	.LC1-0x4
    27d9:	0f 28 d8             	movaps %xmm0,%xmm3
    27dc:	0f 54 1d 00 00 00 00 	andps  0x0(%rip),%xmm3        # 27e3 <ayatsuri_model_open+0xbc3>
			27df: R_X86_64_PC32	.LC0-0x4
    27e3:	0f 2e e3             	ucomiss %xmm3,%xmm4
    27e6:	0f 82 74 f4 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    27ec:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 27f4 <ayatsuri_model_open+0xbd4>
    27f3:	00 
			27f0: R_X86_64_PC32	.LC15-0x4
    27f4:	0f 2f d8             	comiss %xmm0,%xmm3
    27f7:	0f 87 63 f4 ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    27fd:	0f 2f 05 00 00 00 00 	comiss 0x0(%rip),%xmm0        # 2804 <ayatsuri_model_open+0xbe4>
			2800: R_X86_64_PC32	.LC30-0x4
    2804:	0f 87 56 f4 ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    280a:	be 04 00 00 00       	mov    $0x4,%esi
    280f:	e9 f1 fc ff ff       	jmp    2505 <ayatsuri_model_open+0x8e5>
    2814:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
    2819:	44 89 6c 24 64       	mov    %r13d,0x64(%rsp)
    281e:	41 0f b7 d0          	movzwl %r8w,%edx
    2822:	41 89 c5             	mov    %eax,%r13d
    2825:	89 9c 24 80 00 00 00 	mov    %ebx,0x80(%rsp)
    282c:	48 89 6c 24 68       	mov    %rbp,0x68(%rsp)
    2831:	4c 89 cb             	mov    %r9,%rbx
    2834:	44 89 c5             	mov    %r8d,%ebp
    2837:	49 39 df             	cmp    %rbx,%r15
    283a:	0f 84 cc 01 00 00    	je     2a0c <ayatsuri_model_open+0xdec>
    2840:	0f b7 43 0a          	movzwl 0xa(%rbx),%eax
    2844:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    2849:	c1 e0 03             	shl    $0x3,%eax
    284c:	48 01 c8             	add    %rcx,%rax
    284f:	4c 01 e0             	add    %r12,%rax
    2852:	66 39 68 02          	cmp    %bp,0x2(%rax)
    2856:	0f 84 5c 01 00 00    	je     29b8 <ayatsuri_model_open+0xd98>
    285c:	48 83 c3 10          	add    $0x10,%rbx
    2860:	eb d5                	jmp    2837 <ayatsuri_model_open+0xc17>
    2862:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
    2866:	39 ca                	cmp    %ecx,%edx
    2868:	0f 83 f2 f3 ff ff    	jae    1c60 <ayatsuri_model_open+0x40>
    286e:	3c 03                	cmp    $0x3,%al
    2870:	74 6c                	je     28de <ayatsuri_model_open+0xcbe>
    2872:	83 7c 24 40 00       	cmpl   $0x0,0x40(%rsp)
    2877:	74 12                	je     288b <ayatsuri_model_open+0xc6b>
    2879:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
    287e:	c1 e2 02             	shl    $0x2,%edx
    2881:	80 3c 11 00          	cmpb   $0x0,(%rcx,%rdx,1)
    2885:	0f 85 d5 f3 ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    288b:	3c 01                	cmp    $0x1,%al
    288d:	0f 84 f7 00 00 00    	je     298a <ayatsuri_model_open+0xd6a>
    2893:	8d 57 ff             	lea    -0x1(%rdi),%edx
    2896:	66 83 fa 07          	cmp    $0x7,%dx
    289a:	0f 87 c0 f3 ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    28a0:	8b 4c 24 10          	mov    0x10(%rsp),%ecx
    28a4:	39 f1                	cmp    %esi,%ecx
    28a6:	0f 82 b4 f3 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    28ac:	29 f1                	sub    %esi,%ecx
    28ae:	39 f9                	cmp    %edi,%ecx
    28b0:	0f 82 aa f3 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    28b6:	66 0f ef ff          	pxor   %xmm7,%xmm7
    28ba:	0f 2f f8             	comiss %xmm0,%xmm7
    28bd:	0f 87 9d f3 ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    28c3:	0f 2f 05 00 00 00 00 	comiss 0x0(%rip),%xmm0        # 28ca <ayatsuri_model_open+0xcaa>
			28c6: R_X86_64_PC32	.LC30-0x4
    28ca:	0f 87 90 f3 ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    28d0:	66 83 84 24 9e 00 00 	addw   $0x1,0x9e(%rsp)
    28d7:	00 01 
    28d9:	e9 76 fe ff ff       	jmp    2754 <ayatsuri_model_open+0xb34>
    28de:	83 7c 24 38 00       	cmpl   $0x0,0x38(%rsp)
    28e3:	0f 84 77 f3 ff ff    	je     1c60 <ayatsuri_model_open+0x40>
    28e9:	8b 4c 24 3c          	mov    0x3c(%rsp),%ecx
    28ed:	39 ce                	cmp    %ecx,%esi
    28ef:	40 0f 93 c6          	setae  %sil
    28f3:	66 85 ff             	test   %di,%di
    28f6:	40 0f 95 c7          	setne  %dil
    28fa:	40 08 fe             	or     %dil,%sil
    28fd:	0f 85 5d f3 ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    2903:	66 0f ef f6          	pxor   %xmm6,%xmm6
    2907:	b9 01 00 00 00       	mov    $0x1,%ecx
    290c:	0f 2e c6             	ucomiss %xmm6,%xmm0
    290f:	40 0f 9a c6          	setp   %sil
    2913:	0f 45 f1             	cmovne %ecx,%esi
    2916:	40 84 f6             	test   %sil,%sil
    2919:	0f 85 41 f3 ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    291f:	6b d2 48             	imul   $0x48,%edx,%edx
    2922:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
    2927:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
    292b:	4c 01 e6             	add    %r12,%rsi
    292e:	48 8d 7e 30          	lea    0x30(%rsi),%rdi
    2932:	e8 c9 d6 ff ff       	call   0 <md>
    2937:	66 0f 2e 05 00 00 00 	ucomisd 0x0(%rip),%xmm0        # 293f <ayatsuri_model_open+0xd1f>
    293e:	00 
			293b: R_X86_64_PC32	.LC9-0x4
    293f:	0f 8a 1b f3 ff ff    	jp     1c60 <ayatsuri_model_open+0x40>
    2945:	0f 85 15 f3 ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    294b:	48 8d 7e 38          	lea    0x38(%rsi),%rdi
    294f:	e8 ac d6 ff ff       	call   0 <md>
    2954:	66 0f 2e 05 00 00 00 	ucomisd 0x0(%rip),%xmm0        # 295c <ayatsuri_model_open+0xd3c>
    295b:	00 
			2958: R_X86_64_PC32	.LC9-0x4
    295c:	0f 8a fe f2 ff ff    	jp     1c60 <ayatsuri_model_open+0x40>
    2962:	0f 85 f8 f2 ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    2968:	48 8d 7e 40          	lea    0x40(%rsi),%rdi
    296c:	66 0f ef ff          	pxor   %xmm7,%xmm7
    2970:	e8 8b d6 ff ff       	call   0 <md>
    2975:	66 0f 2e c7          	ucomisd %xmm7,%xmm0
    2979:	0f 8a e1 f2 ff ff    	jp     1c60 <ayatsuri_model_open+0x40>
    297f:	0f 84 4b ff ff ff    	je     28d0 <ayatsuri_model_open+0xcb0>
    2985:	e9 d6 f2 ff ff       	jmp    1c60 <ayatsuri_model_open+0x40>
    298a:	66 0f ef f6          	pxor   %xmm6,%xmm6
    298e:	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
    2992:	0f 2e c6             	ucomiss %xmm6,%xmm0
    2995:	0f 9a c2             	setp   %dl
    2998:	0f 45 d0             	cmovne %eax,%edx
    299b:	39 ce                	cmp    %ecx,%esi
    299d:	40 0f 93 c6          	setae  %sil
    29a1:	40 08 d6             	or     %dl,%sil
    29a4:	0f 85 b6 f2 ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    29aa:	66 85 ff             	test   %di,%di
    29ad:	0f 84 1d ff ff ff    	je     28d0 <ayatsuri_model_open+0xcb0>
    29b3:	e9 a8 f2 ff ff       	jmp    1c60 <ayatsuri_model_open+0x40>
    29b8:	8b 70 04             	mov    0x4(%rax),%esi
    29bb:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    29c0:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
    29c5:	4c 89 9c 24 88 00 00 	mov    %r11,0x88(%rsp)
    29cc:	00 
    29cd:	48 01 c6             	add    %rax,%rsi
    29d0:	44 89 94 24 84 00 00 	mov    %r10d,0x84(%rsp)
    29d7:	00 
    29d8:	4c 01 e6             	add    %r12,%rsi
    29db:	48 89 7c 24 70       	mov    %rdi,0x70(%rsp)
    29e0:	e8 00 00 00 00       	call   29e5 <ayatsuri_model_open+0xdc5>
			29e1: R_X86_64_PLT32	memcmp-0x4
    29e5:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
    29ea:	48 8b 54 24 78       	mov    0x78(%rsp),%rdx
    29ef:	85 c0                	test   %eax,%eax
    29f1:	44 8b 94 24 84 00 00 	mov    0x84(%rsp),%r10d
    29f8:	00 
    29f9:	4c 8b 9c 24 88 00 00 	mov    0x88(%rsp),%r11
    2a00:	00 
    2a01:	0f 85 55 fe ff ff    	jne    285c <ayatsuri_model_open+0xc3c>
    2a07:	e9 54 f2 ff ff       	jmp    1c60 <ayatsuri_model_open+0x40>
    2a0c:	44 89 e8             	mov    %r13d,%eax
    2a0f:	8b 9c 24 80 00 00 00 	mov    0x80(%rsp),%ebx
    2a16:	44 8b 6c 24 64       	mov    0x64(%rsp),%r13d
    2a1b:	48 8b 6c 24 68       	mov    0x68(%rsp),%rbp
    2a20:	3c 03                	cmp    $0x3,%al
    2a22:	0f 84 17 02 00 00    	je     2c3f <ayatsuri_model_open+0x101f>
    2a28:	4c 89 ff             	mov    %r15,%rdi
    2a2b:	e8 a0 d8 ff ff       	call   2d0 <slot_bytes>
    2a30:	03 84 24 a0 00 00 00 	add    0xa0(%rsp),%eax
    2a37:	83 c3 01             	add    $0x1,%ebx
    2a3a:	49 83 c7 10          	add    $0x10,%r15
    2a3e:	48 83 c5 24          	add    $0x24,%rbp
    2a42:	89 84 24 a0 00 00 00 	mov    %eax,0xa0(%rsp)
    2a49:	89 c2                	mov    %eax,%edx
    2a4b:	44 39 eb             	cmp    %r13d,%ebx
    2a4e:	0f 82 12 fc ff ff    	jb     2666 <ayatsuri_model_open+0xa46>
    2a54:	44 8b 8c 24 dc 00 00 	mov    0xdc(%rsp),%r9d
    2a5b:	00 
    2a5c:	4c 89 e3             	mov    %r12,%rbx
    2a5f:	4c 89 dd             	mov    %r11,%rbp
    2a62:	31 f6                	xor    %esi,%esi
    2a64:	0f b6 44 24 63       	movzbl 0x63(%rsp),%eax
    2a69:	44 8b b4 24 e0 00 00 	mov    0xe0(%rsp),%r14d
    2a70:	00 
    2a71:	45 89 d4             	mov    %r10d,%r12d
    2a74:	f3 44 0f 10 0d 00 00 	movss  0x0(%rip),%xmm9        # 2a7d <ayatsuri_model_open+0xe5d>
    2a7b:	00 00 
			2a79: R_X86_64_PC32	.LC20-0x4
    2a7d:	f3 0f 7e 1d 00 00 00 	movq   0x0(%rip),%xmm3        # 2a85 <ayatsuri_model_open+0xe65>
    2a84:	00 
			2a81: R_X86_64_PC32	.LC8-0x4
    2a85:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 2a8d <ayatsuri_model_open+0xe6d>
    2a8c:	00 
			2a89: R_X86_64_PC32	.LC22-0x4
    2a8d:	4e 8d 1c 0b          	lea    (%rbx,%r9,1),%r11
    2a91:	f3 44 0f 10 05 00 00 	movss  0x0(%rip),%xmm8        # 2a9a <ayatsuri_model_open+0xe7a>
    2a98:	00 00 
			2a96: R_X86_64_PC32	.LC31-0x4
    2a9a:	41 39 f6             	cmp    %esi,%r14d
    2a9d:	0f 84 b0 01 00 00    	je     2c53 <ayatsuri_model_open+0x1033>
    2aa3:	66 0f ef c0          	pxor   %xmm0,%xmm0
    2aa7:	66 0f ef c9          	pxor   %xmm1,%xmm1
    2aab:	66 0f ef d2          	pxor   %xmm2,%xmm2
    2aaf:	89 f1                	mov    %esi,%ecx
    2ab1:	c1 e1 05             	shl    $0x5,%ecx
    2ab4:	4c 01 c9             	add    %r9,%rcx
    2ab7:	48 01 d9             	add    %rbx,%rcx
    2aba:	0f b7 39             	movzwl (%rcx),%edi
    2abd:	f3 0f 10 79 10       	movss  0x10(%rcx),%xmm7
    2ac2:	f3 0f 5a 41 04       	cvtss2sd 0x4(%rcx),%xmm0
    2ac7:	f3 0f 5a 49 08       	cvtss2sd 0x8(%rcx),%xmm1
    2acc:	f3 0f 10 61 14       	movss  0x14(%rcx),%xmm4
    2ad1:	f3 0f 5a 51 0c       	cvtss2sd 0xc(%rcx),%xmm2
    2ad6:	41 89 fa             	mov    %edi,%r10d
    2ad9:	44 39 ef             	cmp    %r13d,%edi
    2adc:	0f 83 7e f1 ff ff    	jae    1c60 <ayatsuri_model_open+0x40>
    2ae2:	4c 8b 7c 24 30       	mov    0x30(%rsp),%r15
    2ae7:	44 0f b6 41 02       	movzbl 0x2(%rcx),%r8d
    2aec:	c1 e7 04             	shl    $0x4,%edi
    2aef:	42 0f b6 7c 3f 02    	movzbl 0x2(%rdi,%r15,1),%edi
    2af5:	41 80 f8 05          	cmp    $0x5,%r8b
    2af9:	0f 84 29 01 00 00    	je     2c28 <ayatsuri_model_open+0x1008>
    2aff:	40 80 ef 01          	sub    $0x1,%dil
    2b03:	0f 85 57 f1 ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    2b09:	41 80 f8 04          	cmp    $0x4,%r8b
    2b0d:	0f 85 4d f1 ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    2b13:	f3 0f 10 2d 00 00 00 	movss  0x0(%rip),%xmm5        # 2b1b <ayatsuri_model_open+0xefb>
    2b1a:	00 
			2b17: R_X86_64_PC32	.LC28-0x4
    2b1b:	80 79 03 00          	cmpb   $0x0,0x3(%rcx)
    2b1f:	0f 85 3b f1 ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    2b25:	8b 79 1c             	mov    0x1c(%rcx),%edi
    2b28:	85 ff                	test   %edi,%edi
    2b2a:	0f 85 30 f1 ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    2b30:	66 44 0f 28 d0       	movapd %xmm0,%xmm10
    2b35:	66 44 0f 54 d3       	andpd  %xmm3,%xmm10
    2b3a:	66 41 0f 2e f2       	ucomisd %xmm10,%xmm6
    2b3f:	0f 82 1b f1 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    2b45:	66 44 0f 28 d1       	movapd %xmm1,%xmm10
    2b4a:	66 44 0f 54 d3       	andpd  %xmm3,%xmm10
    2b4f:	66 41 0f 2e f2       	ucomisd %xmm10,%xmm6
    2b54:	0f 82 06 f1 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    2b5a:	66 44 0f 28 d2       	movapd %xmm2,%xmm10
    2b5f:	66 44 0f 54 d3       	andpd  %xmm3,%xmm10
    2b64:	66 41 0f 2e f2       	ucomisd %xmm10,%xmm6
    2b69:	0f 82 f1 f0 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    2b6f:	f2 0f 59 c0          	mulsd  %xmm0,%xmm0
    2b73:	f2 0f 59 c9          	mulsd  %xmm1,%xmm1
    2b77:	f2 0f 59 d2          	mulsd  %xmm2,%xmm2
    2b7b:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    2b7f:	f2 0f 58 c2          	addsd  %xmm2,%xmm0
    2b83:	f2 0f 5c 05 00 00 00 	subsd  0x0(%rip),%xmm0        # 2b8b <ayatsuri_model_open+0xf6b>
    2b8a:	00 
			2b87: R_X86_64_PC32	.LC9-0x4
    2b8b:	66 0f 54 c3          	andpd  %xmm3,%xmm0
    2b8f:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 2b97 <ayatsuri_model_open+0xf77>
    2b96:	00 
			2b93: R_X86_64_PC32	.LC29-0x4
    2b97:	0f 87 c3 f0 ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    2b9d:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 2ba5 <ayatsuri_model_open+0xf85>
    2ba4:	00 
			2ba1: R_X86_64_PC32	.LC1-0x4
    2ba5:	0f 28 c7             	movaps %xmm7,%xmm0
    2ba8:	0f 54 05 00 00 00 00 	andps  0x0(%rip),%xmm0        # 2baf <ayatsuri_model_open+0xf8f>
			2bab: R_X86_64_PC32	.LC0-0x4
    2baf:	0f 2e d0             	ucomiss %xmm0,%xmm2
    2bb2:	0f 82 a8 f0 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    2bb8:	0f 28 c5             	movaps %xmm5,%xmm0
    2bbb:	41 0f 57 c1          	xorps  %xmm9,%xmm0
    2bbf:	0f 2f c7             	comiss %xmm7,%xmm0
    2bc2:	0f 87 98 f0 ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    2bc8:	0f 2f fd             	comiss %xmm5,%xmm7
    2bcb:	0f 87 8f f0 ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    2bd1:	0f 28 c4             	movaps %xmm4,%xmm0
    2bd4:	0f 54 05 00 00 00 00 	andps  0x0(%rip),%xmm0        # 2bdb <ayatsuri_model_open+0xfbb>
			2bd7: R_X86_64_PC32	.LC0-0x4
    2bdb:	0f 2e d0             	ucomiss %xmm0,%xmm2
    2bde:	0f 82 7c f0 ff ff    	jb     1c60 <ayatsuri_model_open+0x40>
    2be4:	66 0f ef c0          	pxor   %xmm0,%xmm0
    2be8:	0f 2e e0             	ucomiss %xmm0,%xmm4
    2beb:	7a 02                	jp     2bef <ayatsuri_model_open+0xfcf>
    2bed:	74 13                	je     2c02 <ayatsuri_model_open+0xfe2>
    2bef:	44 0f 2f c4          	comiss %xmm4,%xmm8
    2bf3:	0f 87 67 f0 ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    2bf9:	0f 2f e5             	comiss %xmm5,%xmm4
    2bfc:	0f 87 5e f0 ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    2c02:	81 79 18 ff ff ff 00 	cmpl   $0xffffff,0x18(%rcx)
    2c09:	0f 87 51 f0 ff ff    	ja     1c60 <ayatsuri_model_open+0x40>
    2c0f:	39 fe                	cmp    %edi,%esi
    2c11:	74 65                	je     2c78 <ayatsuri_model_open+0x1058>
    2c13:	89 f9                	mov    %edi,%ecx
    2c15:	c1 e1 05             	shl    $0x5,%ecx
    2c18:	66 45 39 14 0b       	cmp    %r10w,(%r11,%rcx,1)
    2c1d:	0f 84 3d f0 ff ff    	je     1c60 <ayatsuri_model_open+0x40>
    2c23:	83 c7 01             	add    $0x1,%edi
    2c26:	eb e7                	jmp    2c0f <ayatsuri_model_open+0xfef>
    2c28:	40 80 ff 02          	cmp    $0x2,%dil
    2c2c:	0f 85 2e f0 ff ff    	jne    1c60 <ayatsuri_model_open+0x40>
    2c32:	f3 0f 10 2d 00 00 00 	movss  0x0(%rip),%xmm5        # 2c3a <ayatsuri_model_open+0x101a>
    2c39:	00 
			2c36: R_X86_64_PC32	.LC3-0x4
    2c3a:	e9 dc fe ff ff       	jmp    2b1b <ayatsuri_model_open+0xefb>
    2c3f:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
    2c44:	4c 89 fa             	mov    %r15,%rdx
    2c47:	89 de                	mov    %ebx,%esi
    2c49:	e8 f2 da ff ff       	call   740 <node_slot_bytes>
    2c4e:	e9 dd fd ff ff       	jmp    2a30 <ayatsuri_model_open+0xe10>
    2c53:	80 7c 24 28 00       	cmpb   $0x0,0x28(%rsp)
    2c58:	74 07                	je     2c61 <ayatsuri_model_open+0x1041>
    2c5a:	89 94 24 a0 00 00 00 	mov    %edx,0xa0(%rsp)
    2c61:	48 8d b4 24 90 00 00 	lea    0x90(%rsp),%rsi
    2c68:	00 
    2c69:	b9 20 00 00 00       	mov    $0x20,%ecx
    2c6e:	48 89 ef             	mov    %rbp,%rdi
    2c71:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
    2c73:	e9 ee ef ff ff       	jmp    1c66 <ayatsuri_model_open+0x46>
    2c78:	41 80 f8 05          	cmp    $0x5,%r8b
    2c7c:	75 07                	jne    2c85 <ayatsuri_model_open+0x1065>
    2c7e:	88 44 24 28          	mov    %al,0x28(%rsp)
    2c82:	83 c2 18             	add    $0x18,%edx
    2c85:	83 c6 01             	add    $0x1,%esi
    2c88:	e9 0d fe ff ff       	jmp    2a9a <ayatsuri_model_open+0xe7a>
    2c8d:	0f 1f 00             	nopl   (%rax)

0000000000002c90 <ayatsuri_model_find_node>:
    2c90:	48 85 ff             	test   %rdi,%rdi
    2c93:	0f 84 1f 01 00 00    	je     2db8 <ayatsuri_model_find_node+0x128>
    2c99:	41 57                	push   %r15
    2c9b:	41 56                	push   %r14
    2c9d:	41 55                	push   %r13
    2c9f:	41 54                	push   %r12
    2ca1:	55                   	push   %rbp
    2ca2:	48 89 fd             	mov    %rdi,%rbp
    2ca5:	53                   	push   %rbx
    2ca6:	48 83 ec 18          	sub    $0x18,%rsp
    2caa:	4c 8b 3f             	mov    (%rdi),%r15
    2cad:	4d 85 ff             	test   %r15,%r15
    2cb0:	0f 84 d2 00 00 00    	je     2d88 <ayatsuri_model_find_node+0xf8>
    2cb6:	49 89 f6             	mov    %rsi,%r14
    2cb9:	48 85 f6             	test   %rsi,%rsi
    2cbc:	0f 84 c6 00 00 00    	je     2d88 <ayatsuri_model_find_node+0xf8>
    2cc2:	49 89 cd             	mov    %rcx,%r13
    2cc5:	48 85 c9             	test   %rcx,%rcx
    2cc8:	0f 84 ba 00 00 00    	je     2d88 <ayatsuri_model_find_node+0xf8>
    2cce:	49 89 d4             	mov    %rdx,%r12
    2cd1:	48 8d 52 ff          	lea    -0x1(%rdx),%rdx
    2cd5:	b8 01 00 00 00       	mov    $0x1,%eax
    2cda:	48 83 fa 7e          	cmp    $0x7e,%rdx
    2cde:	0f 87 a9 00 00 00    	ja     2d8d <ayatsuri_model_find_node+0xfd>
    2ce4:	48 39 cf             	cmp    %rcx,%rdi
    2ce7:	0f 83 b3 00 00 00    	jae    2da0 <ayatsuri_model_find_node+0x110>
    2ced:	48 89 ca             	mov    %rcx,%rdx
    2cf0:	48 29 fa             	sub    %rdi,%rdx
    2cf3:	48 83 fa 7f          	cmp    $0x7f,%rdx
    2cf7:	0f 86 90 00 00 00    	jbe    2d8d <ayatsuri_model_find_node+0xfd>
    2cfd:	8b 55 08             	mov    0x8(%rbp),%edx
    2d00:	48 85 d2             	test   %rdx,%rdx
    2d03:	74 1b                	je     2d20 <ayatsuri_model_find_node+0x90>
    2d05:	4d 39 ef             	cmp    %r13,%r15
    2d08:	0f 82 c2 00 00 00    	jb     2dd0 <ayatsuri_model_find_node+0x140>
    2d0e:	4c 89 fa             	mov    %r15,%rdx
    2d11:	b8 01 00 00 00       	mov    $0x1,%eax
    2d16:	4c 29 ea             	sub    %r13,%rdx
    2d19:	48 83 fa 01          	cmp    $0x1,%rdx
    2d1d:	76 6e                	jbe    2d8d <ayatsuri_model_find_node+0xfd>
    2d1f:	90                   	nop
    2d20:	0f b7 45 0c          	movzwl 0xc(%rbp),%eax
    2d24:	85 c0                	test   %eax,%eax
    2d26:	0f 84 94 00 00 00    	je     2dc0 <ayatsuri_model_find_node+0x130>
    2d2c:	8b 5d 3c             	mov    0x3c(%rbp),%ebx
    2d2f:	83 e8 01             	sub    $0x1,%eax
    2d32:	4c 01 fb             	add    %r15,%rbx
    2d35:	48 8d 4c c3 08       	lea    0x8(%rbx,%rax,8),%rcx
    2d3a:	eb 0d                	jmp    2d49 <ayatsuri_model_find_node+0xb9>
    2d3c:	0f 1f 40 00          	nopl   0x0(%rax)
    2d40:	48 83 c3 08          	add    $0x8,%rbx
    2d44:	48 39 d9             	cmp    %rbx,%rcx
    2d47:	74 77                	je     2dc0 <ayatsuri_model_find_node+0x130>
    2d49:	0f b7 43 02          	movzwl 0x2(%rbx),%eax
    2d4d:	4c 39 e0             	cmp    %r12,%rax
    2d50:	75 ee                	jne    2d40 <ayatsuri_model_find_node+0xb0>
    2d52:	8b 43 04             	mov    0x4(%rbx),%eax
    2d55:	8b 7d 44             	mov    0x44(%rbp),%edi
    2d58:	4c 89 e2             	mov    %r12,%rdx
    2d5b:	4c 89 f6             	mov    %r14,%rsi
    2d5e:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    2d63:	48 01 c7             	add    %rax,%rdi
    2d66:	4c 01 ff             	add    %r15,%rdi
    2d69:	e8 00 00 00 00       	call   2d6e <ayatsuri_model_find_node+0xde>
			2d6a: R_X86_64_PLT32	memcmp-0x4
    2d6e:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
    2d73:	85 c0                	test   %eax,%eax
    2d75:	75 c9                	jne    2d40 <ayatsuri_model_find_node+0xb0>
    2d77:	0f b7 03             	movzwl (%rbx),%eax
    2d7a:	66 41 89 45 00       	mov    %ax,0x0(%r13)
    2d7f:	31 c0                	xor    %eax,%eax
    2d81:	eb 0a                	jmp    2d8d <ayatsuri_model_find_node+0xfd>
    2d83:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    2d88:	b8 01 00 00 00       	mov    $0x1,%eax
    2d8d:	48 83 c4 18          	add    $0x18,%rsp
    2d91:	5b                   	pop    %rbx
    2d92:	5d                   	pop    %rbp
    2d93:	41 5c                	pop    %r12
    2d95:	41 5d                	pop    %r13
    2d97:	41 5e                	pop    %r14
    2d99:	41 5f                	pop    %r15
    2d9b:	c3                   	ret
    2d9c:	0f 1f 40 00          	nopl   0x0(%rax)
    2da0:	48 89 fa             	mov    %rdi,%rdx
    2da3:	48 29 ca             	sub    %rcx,%rdx
    2da6:	48 83 fa 01          	cmp    $0x1,%rdx
    2daa:	76 e1                	jbe    2d8d <ayatsuri_model_find_node+0xfd>
    2dac:	e9 4c ff ff ff       	jmp    2cfd <ayatsuri_model_find_node+0x6d>
    2db1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    2db8:	b8 01 00 00 00       	mov    $0x1,%eax
    2dbd:	c3                   	ret
    2dbe:	66 90                	xchg   %ax,%ax
    2dc0:	b8 05 00 00 00       	mov    $0x5,%eax
    2dc5:	eb c6                	jmp    2d8d <ayatsuri_model_find_node+0xfd>
    2dc7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    2dce:	00 00 
    2dd0:	4c 89 e9             	mov    %r13,%rcx
    2dd3:	b8 01 00 00 00       	mov    $0x1,%eax
    2dd8:	4c 29 f9             	sub    %r15,%rcx
    2ddb:	48 39 d1             	cmp    %rdx,%rcx
    2dde:	72 ad                	jb     2d8d <ayatsuri_model_find_node+0xfd>
    2de0:	e9 3b ff ff ff       	jmp    2d20 <ayatsuri_model_find_node+0x90>
    2de5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    2dec:	00 00 00 00 

0000000000002df0 <ayatsuri_model_instance_bytes>:
    2df0:	31 c0                	xor    %eax,%eax
    2df2:	48 85 ff             	test   %rdi,%rdi
    2df5:	74 15                	je     2e0c <ayatsuri_model_instance_bytes+0x1c>
    2df7:	48 83 3f 00          	cmpq   $0x0,(%rdi)
    2dfb:	74 0f                	je     2e0c <ayatsuri_model_instance_bytes+0x1c>
    2dfd:	0f b7 47 0c          	movzwl 0xc(%rdi),%eax
    2e01:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
    2e05:	8b 47 10             	mov    0x10(%rdi),%eax
    2e08:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
    2e0c:	c3                   	ret
    2e0d:	0f 1f 00             	nopl   (%rax)

0000000000002e10 <ayatsuri_model_instance_init>:
    2e10:	b8 01 00 00 00       	mov    $0x1,%eax
    2e15:	48 85 ff             	test   %rdi,%rdi
    2e18:	0f 84 a2 00 00 00    	je     2ec0 <ayatsuri_model_instance_init+0xb0>
    2e1e:	41 57                	push   %r15
    2e20:	41 56                	push   %r14
    2e22:	41 55                	push   %r13
    2e24:	41 54                	push   %r12
    2e26:	55                   	push   %rbp
    2e27:	48 89 cd             	mov    %rcx,%rbp
    2e2a:	53                   	push   %rbx
    2e2b:	48 89 fb             	mov    %rdi,%rbx
    2e2e:	48 81 ec c8 00 00 00 	sub    $0xc8,%rsp
    2e35:	48 8b 0f             	mov    (%rdi),%rcx
    2e38:	48 85 c9             	test   %rcx,%rcx
    2e3b:	74 5e                	je     2e9b <ayatsuri_model_instance_init+0x8b>
    2e3d:	0f b7 47 0c          	movzwl 0xc(%rdi),%eax
    2e41:	49 89 f2             	mov    %rsi,%r10
    2e44:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
    2e48:	8b 47 10             	mov    0x10(%rdi),%eax
    2e4b:	4c 8d 24 f0          	lea    (%rax,%rsi,8),%r12
    2e4f:	4d 85 e4             	test   %r12,%r12
    2e52:	74 5c                	je     2eb0 <ayatsuri_model_instance_init+0xa0>
    2e54:	4d 85 d2             	test   %r10,%r10
    2e57:	74 57                	je     2eb0 <ayatsuri_model_instance_init+0xa0>
    2e59:	48 85 ed             	test   %rbp,%rbp
    2e5c:	0f 94 c0             	sete   %al
    2e5f:	4d 85 c9             	test   %r9,%r9
    2e62:	40 0f 94 c6          	sete   %sil
    2e66:	40 08 f0             	or     %sil,%al
    2e69:	75 45                	jne    2eb0 <ayatsuri_model_instance_init+0xa0>
    2e6b:	45 85 c0             	test   %r8d,%r8d
    2e6e:	74 40                	je     2eb0 <ayatsuri_model_instance_init+0xa0>
    2e70:	4d 89 d5             	mov    %r10,%r13
    2e73:	41 f6 c2 07          	test   $0x7,%r10b
    2e77:	75 37                	jne    2eb0 <ayatsuri_model_instance_init+0xa0>
    2e79:	4c 39 e2             	cmp    %r12,%rdx
    2e7c:	72 32                	jb     2eb0 <ayatsuri_model_instance_init+0xa0>
    2e7e:	8b 57 08             	mov    0x8(%rdi),%edx
    2e81:	48 85 d2             	test   %rdx,%rdx
    2e84:	74 5a                	je     2ee0 <ayatsuri_model_instance_init+0xd0>
    2e86:	4c 39 d1             	cmp    %r10,%rcx
    2e89:	72 3d                	jb     2ec8 <ayatsuri_model_instance_init+0xb8>
    2e8b:	48 89 ce             	mov    %rcx,%rsi
    2e8e:	b8 01 00 00 00       	mov    $0x1,%eax
    2e93:	4c 29 d6             	sub    %r10,%rsi
    2e96:	4c 39 e6             	cmp    %r12,%rsi
    2e99:	73 45                	jae    2ee0 <ayatsuri_model_instance_init+0xd0>
    2e9b:	48 81 c4 c8 00 00 00 	add    $0xc8,%rsp
    2ea2:	5b                   	pop    %rbx
    2ea3:	5d                   	pop    %rbp
    2ea4:	41 5c                	pop    %r12
    2ea6:	41 5d                	pop    %r13
    2ea8:	41 5e                	pop    %r14
    2eaa:	41 5f                	pop    %r15
    2eac:	c3                   	ret
    2ead:	0f 1f 00             	nopl   (%rax)
    2eb0:	b8 01 00 00 00       	mov    $0x1,%eax
    2eb5:	eb e4                	jmp    2e9b <ayatsuri_model_instance_init+0x8b>
    2eb7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    2ebe:	00 00 
    2ec0:	c3                   	ret
    2ec1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    2ec8:	4c 89 d6             	mov    %r10,%rsi
    2ecb:	b8 01 00 00 00       	mov    $0x1,%eax
    2ed0:	48 29 ce             	sub    %rcx,%rsi
    2ed3:	48 39 d6             	cmp    %rdx,%rsi
    2ed6:	72 c3                	jb     2e9b <ayatsuri_model_instance_init+0x8b>
    2ed8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    2edf:	00 
    2ee0:	4c 39 d3             	cmp    %r10,%rbx
    2ee3:	0f 83 27 02 00 00    	jae    3110 <ayatsuri_model_instance_init+0x300>
    2ee9:	4c 89 d6             	mov    %r10,%rsi
    2eec:	b8 01 00 00 00       	mov    $0x1,%eax
    2ef1:	48 29 de             	sub    %rbx,%rsi
    2ef4:	48 83 fe 7f          	cmp    $0x7f,%rsi
    2ef8:	76 a1                	jbe    2e9b <ayatsuri_model_instance_init+0x8b>
    2efa:	4d 39 d1             	cmp    %r10,%r9
    2efd:	0f 82 2d 02 00 00    	jb     3130 <ayatsuri_model_instance_init+0x320>
    2f03:	4c 89 ce             	mov    %r9,%rsi
    2f06:	b8 01 00 00 00       	mov    $0x1,%eax
    2f0b:	4c 29 d6             	sub    %r10,%rsi
    2f0e:	4c 39 e6             	cmp    %r12,%rsi
    2f11:	72 88                	jb     2e9b <ayatsuri_model_instance_init+0x8b>
    2f13:	4c 39 cb             	cmp    %r9,%rbx
    2f16:	0f 82 34 02 00 00    	jb     3150 <ayatsuri_model_instance_init+0x340>
    2f1c:	48 89 de             	mov    %rbx,%rsi
    2f1f:	b8 01 00 00 00       	mov    $0x1,%eax
    2f24:	4c 29 ce             	sub    %r9,%rsi
    2f27:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    2f2e:	0f 86 67 ff ff ff    	jbe    2e9b <ayatsuri_model_instance_init+0x8b>
    2f34:	48 85 d2             	test   %rdx,%rdx
    2f37:	74 1e                	je     2f57 <ayatsuri_model_instance_init+0x147>
    2f39:	4c 39 c9             	cmp    %r9,%rcx
    2f3c:	0f 82 ed 02 00 00    	jb     322f <ayatsuri_model_instance_init+0x41f>
    2f42:	4c 29 c9             	sub    %r9,%rcx
    2f45:	b8 01 00 00 00       	mov    $0x1,%eax
    2f4a:	48 81 f9 a7 00 00 00 	cmp    $0xa7,%rcx
    2f51:	0f 86 44 ff ff ff    	jbe    2e9b <ayatsuri_model_instance_init+0x8b>
    2f57:	4c 89 d7             	mov    %r10,%rdi
    2f5a:	4c 89 e2             	mov    %r12,%rdx
    2f5d:	31 f6                	xor    %esi,%esi
    2f5f:	4c 89 4c 24 08       	mov    %r9,0x8(%rsp)
    2f64:	44 89 44 24 04       	mov    %r8d,0x4(%rsp)
    2f69:	e8 00 00 00 00       	call   2f6e <ayatsuri_model_instance_init+0x15e>
			2f6a: R_X86_64_PLT32	memset-0x4
    2f6e:	0f b7 53 0c          	movzwl 0xc(%rbx),%edx
    2f72:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
    2f77:	b9 15 00 00 00       	mov    $0x15,%ecx
    2f7c:	49 89 c2             	mov    %rax,%r10
    2f7f:	31 c0                	xor    %eax,%eax
    2f81:	44 8b 44 24 04       	mov    0x4(%rsp),%r8d
    2f86:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
    2f8b:	f3 48 ab             	rep stos %rax,%es:(%rdi)
    2f8e:	89 d0                	mov    %edx,%eax
    2f90:	8d 14 52             	lea    (%rdx,%rdx,2),%edx
    2f93:	66 85 c0             	test   %ax,%ax
    2f96:	44 8d 34 d5 00 00 00 	lea    0x0(,%rdx,8),%r14d
    2f9d:	00 
    2f9e:	0f 84 a4 02 00 00    	je     3248 <ayatsuri_model_instance_init+0x438>
    2fa4:	f3 0f 7e 0d 00 00 00 	movq   0x0(%rip),%xmm1        # 2fac <ayatsuri_model_instance_init+0x19c>
    2fab:	00 
			2fa8: R_X86_64_PC32	.LC32-0x4
    2fac:	45 31 db             	xor    %r11d,%r11d
    2faf:	45 31 ff             	xor    %r15d,%r15d
    2fb2:	eb 3f                	jmp    2ff3 <ayatsuri_model_instance_init+0x1e3>
    2fb4:	0f 1f 40 00          	nopl   0x0(%rax)
    2fb8:	b9 d3 ff ff ff       	mov    $0xffffffd3,%ecx
    2fbd:	41 39 cf             	cmp    %ecx,%r15d
    2fc0:	41 0f 46 cf          	cmovbe %r15d,%ecx
    2fc4:	44 8d 79 2c          	lea    0x2c(%rcx),%r15d
    2fc8:	8b 4a 0c             	mov    0xc(%rdx),%ecx
    2fcb:	89 8e 34 01 00 00    	mov    %ecx,0x134(%rsi)
    2fd1:	89 c6                	mov    %eax,%esi
    2fd3:	48 89 df             	mov    %rbx,%rdi
    2fd6:	49 83 c3 01          	add    $0x1,%r11
    2fda:	49 83 c5 18          	add    $0x18,%r13
    2fde:	e8 5d d7 ff ff       	call   740 <node_slot_bytes>
    2fe3:	41 01 c6             	add    %eax,%r14d
    2fe6:	0f b7 43 0c          	movzwl 0xc(%rbx),%eax
    2fea:	41 39 c3             	cmp    %eax,%r11d
    2fed:	0f 83 77 01 00 00    	jae    316a <ayatsuri_model_instance_init+0x35a>
    2ff3:	8b 53 14             	mov    0x14(%rbx),%edx
    2ff6:	4c 89 de             	mov    %r11,%rsi
    2ff9:	48 8b 0b             	mov    (%rbx),%rcx
    2ffc:	45 89 75 08          	mov    %r14d,0x8(%r13)
    3000:	48 c1 e6 04          	shl    $0x4,%rsi
    3004:	4f 8d 04 db          	lea    (%r11,%r11,8),%r8
    3008:	44 89 d8             	mov    %r11d,%eax
    300b:	48 01 f2             	add    %rsi,%rdx
    300e:	48 01 ca             	add    %rcx,%rdx
    3011:	0f b6 72 03          	movzbl 0x3(%rdx),%esi
    3015:	41 88 75 10          	mov    %sil,0x10(%r13)
    3019:	8b 7b 1c             	mov    0x1c(%rbx),%edi
    301c:	44 89 f6             	mov    %r14d,%esi
    301f:	49 8d 74 32 30       	lea    0x30(%r10,%rsi,1),%rsi
    3024:	4a 8d 3c 87          	lea    (%rdi,%r8,4),%rdi
    3028:	48 01 f9             	add    %rdi,%rcx
    302b:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
    302f:	0f 11 06             	movups %xmm0,(%rsi)
    3032:	f3 0f 6f 41 10       	movdqu 0x10(%rcx),%xmm0
    3037:	0f 11 46 10          	movups %xmm0,0x10(%rsi)
    303b:	8b 49 20             	mov    0x20(%rcx),%ecx
    303e:	89 4e 20             	mov    %ecx,0x20(%rsi)
    3041:	b9 db ff ff ff       	mov    $0xffffffdb,%ecx
    3046:	41 39 cf             	cmp    %ecx,%r15d
    3049:	41 0f 46 cf          	cmovbe %r15d,%ecx
    304d:	44 8d 79 24          	lea    0x24(%rcx),%r15d
    3051:	0f b6 4a 02          	movzbl 0x2(%rdx),%ecx
    3055:	84 c9                	test   %cl,%cl
    3057:	0f 84 74 ff ff ff    	je     2fd1 <ayatsuri_model_instance_init+0x1c1>
    305d:	80 f9 03             	cmp    $0x3,%cl
    3060:	0f 84 6b ff ff ff    	je     2fd1 <ayatsuri_model_instance_init+0x1c1>
    3066:	0f b7 4a 08          	movzwl 0x8(%rdx),%ecx
    306a:	41 b8 08 01 00 00    	mov    $0x108,%r8d
    3070:	8d 34 c9             	lea    (%rcx,%rcx,8),%esi
    3073:	8b 4b 34             	mov    0x34(%rbx),%ecx
    3076:	c1 e6 03             	shl    $0x3,%esi
    3079:	48 01 ce             	add    %rcx,%rsi
    307c:	48 03 33             	add    (%rbx),%rsi
    307f:	8b 4e 2c             	mov    0x2c(%rsi),%ecx
    3082:	48 8d 7e 38          	lea    0x38(%rsi),%rdi
    3086:	41 89 4d 0c          	mov    %ecx,0xc(%r13)
    308a:	b9 2c 00 00 00       	mov    $0x2c,%ecx
    308f:	e8 6c cf ff ff       	call   0 <md>
    3094:	41 8b 7d 08          	mov    0x8(%r13),%edi
    3098:	f2 41 0f 11 45 00    	movsd  %xmm0,0x0(%r13)
    309e:	80 7a 02 01          	cmpb   $0x1,0x2(%rdx)
    30a2:	75 0b                	jne    30af <ayatsuri_model_instance_init+0x29f>
    30a4:	b9 20 00 00 00       	mov    $0x20,%ecx
    30a9:	41 b8 a4 00 00 00    	mov    $0xa4,%r8d
    30af:	49 01 f8             	add    %rdi,%r8
    30b2:	48 8b 3e             	mov    (%rsi),%rdi
    30b5:	4d 01 d0             	add    %r10,%r8
    30b8:	49 89 38             	mov    %rdi,(%r8)
    30bb:	48 8b 7c 0e f8       	mov    -0x8(%rsi,%rcx,1),%rdi
    30c0:	4a 89 7c 01 f8       	mov    %rdi,-0x8(%rcx,%r8,1)
    30c5:	49 8d 78 08          	lea    0x8(%r8),%rdi
    30c9:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
    30cd:	49 29 f8             	sub    %rdi,%r8
    30d0:	44 01 c1             	add    %r8d,%ecx
    30d3:	4c 29 c6             	sub    %r8,%rsi
    30d6:	c1 e9 03             	shr    $0x3,%ecx
    30d9:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    30dc:	41 8b 4d 08          	mov    0x8(%r13),%ecx
    30e0:	80 7a 02 01          	cmpb   $0x1,0x2(%rdx)
    30e4:	49 8d 34 0a          	lea    (%r10,%rcx,1),%rsi
    30e8:	0f 85 ca fe ff ff    	jne    2fb8 <ayatsuri_model_instance_init+0x1a8>
    30ee:	b9 df ff ff ff       	mov    $0xffffffdf,%ecx
    30f3:	0f 13 8e fc 00 00 00 	movlps %xmm1,0xfc(%rsi)
    30fa:	41 39 cf             	cmp    %ecx,%r15d
    30fd:	41 0f 46 cf          	cmovbe %r15d,%ecx
    3101:	44 8d 79 20          	lea    0x20(%rcx),%r15d
    3105:	e9 c7 fe ff ff       	jmp    2fd1 <ayatsuri_model_instance_init+0x1c1>
    310a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3110:	48 89 de             	mov    %rbx,%rsi
    3113:	b8 01 00 00 00       	mov    $0x1,%eax
    3118:	4c 29 d6             	sub    %r10,%rsi
    311b:	4c 39 e6             	cmp    %r12,%rsi
    311e:	0f 82 77 fd ff ff    	jb     2e9b <ayatsuri_model_instance_init+0x8b>
    3124:	e9 d1 fd ff ff       	jmp    2efa <ayatsuri_model_instance_init+0xea>
    3129:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3130:	4c 89 d6             	mov    %r10,%rsi
    3133:	b8 01 00 00 00       	mov    $0x1,%eax
    3138:	4c 29 ce             	sub    %r9,%rsi
    313b:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    3142:	0f 86 53 fd ff ff    	jbe    2e9b <ayatsuri_model_instance_init+0x8b>
    3148:	e9 c6 fd ff ff       	jmp    2f13 <ayatsuri_model_instance_init+0x103>
    314d:	0f 1f 00             	nopl   (%rax)
    3150:	4c 89 ce             	mov    %r9,%rsi
    3153:	b8 01 00 00 00       	mov    $0x1,%eax
    3158:	48 29 de             	sub    %rbx,%rsi
    315b:	48 83 fe 7f          	cmp    $0x7f,%rsi
    315f:	0f 86 36 fd ff ff    	jbe    2e9b <ayatsuri_model_instance_init+0x8b>
    3165:	e9 ca fd ff ff       	jmp    2f34 <ayatsuri_model_instance_init+0x124>
    316a:	44 8b 44 24 04       	mov    0x4(%rsp),%r8d
    316f:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
    3174:	48 89 5c 24 10       	mov    %rbx,0x10(%rsp)
    3179:	4c 89 54 24 18       	mov    %r10,0x18(%rsp)
    317e:	66 0f 6f 44 24 10    	movdqa 0x10(%rsp),%xmm0
    3184:	48 89 6c 24 20       	mov    %rbp,0x20(%rsp)
    3189:	4c 89 64 24 28       	mov    %r12,0x28(%rsp)
    318e:	41 0f 11 01          	movups %xmm0,(%r9)
    3192:	66 0f 6f 44 24 20    	movdqa 0x20(%rsp),%xmm0
    3198:	44 89 44 24 30       	mov    %r8d,0x30(%rsp)
    319d:	41 0f 11 41 10       	movups %xmm0,0x10(%r9)
    31a2:	66 0f 6f 44 24 30    	movdqa 0x30(%rsp),%xmm0
    31a8:	44 89 bc 24 ac 00 00 	mov    %r15d,0xac(%rsp)
    31af:	00 
    31b0:	41 0f 11 41 20       	movups %xmm0,0x20(%r9)
    31b5:	66 0f 6f 44 24 40    	movdqa 0x40(%rsp),%xmm0
    31bb:	c6 84 24 b4 00 00 00 	movb   $0x1,0xb4(%rsp)
    31c2:	01 
    31c3:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
    31ca:	00 
    31cb:	41 0f 11 41 30       	movups %xmm0,0x30(%r9)
    31d0:	66 0f 6f 44 24 50    	movdqa 0x50(%rsp),%xmm0
    31d6:	49 89 81 a0 00 00 00 	mov    %rax,0xa0(%r9)
    31dd:	31 c0                	xor    %eax,%eax
    31df:	41 0f 11 41 40       	movups %xmm0,0x40(%r9)
    31e4:	66 0f 6f 44 24 60    	movdqa 0x60(%rsp),%xmm0
    31ea:	41 0f 11 41 50       	movups %xmm0,0x50(%r9)
    31ef:	66 0f 6f 44 24 70    	movdqa 0x70(%rsp),%xmm0
    31f5:	41 0f 11 41 60       	movups %xmm0,0x60(%r9)
    31fa:	66 0f 6f 84 24 80 00 	movdqa 0x80(%rsp),%xmm0
    3201:	00 00 
    3203:	41 0f 11 41 70       	movups %xmm0,0x70(%r9)
    3208:	66 0f 6f 84 24 90 00 	movdqa 0x90(%rsp),%xmm0
    320f:	00 00 
    3211:	41 0f 11 81 80 00 00 	movups %xmm0,0x80(%r9)
    3218:	00 
    3219:	66 0f 6f 84 24 a0 00 	movdqa 0xa0(%rsp),%xmm0
    3220:	00 00 
    3222:	41 0f 11 81 90 00 00 	movups %xmm0,0x90(%r9)
    3229:	00 
    322a:	e9 6c fc ff ff       	jmp    2e9b <ayatsuri_model_instance_init+0x8b>
    322f:	4c 89 ce             	mov    %r9,%rsi
    3232:	b8 01 00 00 00       	mov    $0x1,%eax
    3237:	48 29 ce             	sub    %rcx,%rsi
    323a:	48 39 d6             	cmp    %rdx,%rsi
    323d:	0f 82 58 fc ff ff    	jb     2e9b <ayatsuri_model_instance_init+0x8b>
    3243:	e9 0f fd ff ff       	jmp    2f57 <ayatsuri_model_instance_init+0x147>
    3248:	45 31 ff             	xor    %r15d,%r15d
    324b:	e9 24 ff ff ff       	jmp    3174 <ayatsuri_model_instance_init+0x364>

0000000000003250 <ayatsuri_model_instance_dispose>:
    3250:	b8 03 00 00 00       	mov    $0x3,%eax
    3255:	48 85 ff             	test   %rdi,%rdi
    3258:	74 46                	je     32a0 <ayatsuri_model_instance_dispose+0x50>
    325a:	48 85 f6             	test   %rsi,%rsi
    325d:	74 41                	je     32a0 <ayatsuri_model_instance_dispose+0x50>
    325f:	48 39 77 10          	cmp    %rsi,0x10(%rdi)
    3263:	75 3b                	jne    32a0 <ayatsuri_model_instance_dispose+0x50>
    3265:	39 57 20             	cmp    %edx,0x20(%rdi)
    3268:	75 36                	jne    32a0 <ayatsuri_model_instance_dispose+0x50>
    326a:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    3271:	b8 04 00 00 00       	mov    $0x4,%eax
    3276:	75 28                	jne    32a0 <ayatsuri_model_instance_dispose+0x50>
    3278:	c6 87 a4 00 00 00 00 	movb   $0x0,0xa4(%rdi)
    327f:	31 c0                	xor    %eax,%eax
    3281:	c6 87 a6 00 00 00 00 	movb   $0x0,0xa6(%rdi)
    3288:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
    328f:	00 
    3290:	48 c7 47 18 00 00 00 	movq   $0x0,0x18(%rdi)
    3297:	00 
    3298:	c3                   	ret
    3299:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    32a0:	c3                   	ret
    32a1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    32a8:	00 00 00 00 
    32ac:	0f 1f 40 00          	nopl   0x0(%rax)

00000000000032b0 <ayatsuri_model_instance_targets>:
    32b0:	48 85 ff             	test   %rdi,%rdi
    32b3:	0f 84 d7 00 00 00    	je     3390 <ayatsuri_model_instance_targets+0xe0>
    32b9:	48 89 f8             	mov    %rdi,%rax
    32bc:	bf 03 00 00 00       	mov    $0x3,%edi
    32c1:	80 b8 a4 00 00 00 01 	cmpb   $0x1,0xa4(%rax)
    32c8:	0f 85 c7 00 00 00    	jne    3395 <ayatsuri_model_instance_targets+0xe5>
    32ce:	48 85 f6             	test   %rsi,%rsi
    32d1:	0f 84 be 00 00 00    	je     3395 <ayatsuri_model_instance_targets+0xe5>
    32d7:	48 3b 70 10          	cmp    0x10(%rax),%rsi
    32db:	0f 85 b4 00 00 00    	jne    3395 <ayatsuri_model_instance_targets+0xe5>
    32e1:	3b 50 20             	cmp    0x20(%rax),%edx
    32e4:	0f 85 ab 00 00 00    	jne    3395 <ayatsuri_model_instance_targets+0xe5>
    32ea:	80 b8 a5 00 00 00 00 	cmpb   $0x0,0xa5(%rax)
    32f1:	bf 04 00 00 00       	mov    $0x4,%edi
    32f6:	0f 85 99 00 00 00    	jne    3395 <ayatsuri_model_instance_targets+0xe5>
    32fc:	41 57                	push   %r15
    32fe:	41 56                	push   %r14
    3300:	41 55                	push   %r13
    3302:	41 54                	push   %r12
    3304:	55                   	push   %rbp
    3305:	53                   	push   %rbx
    3306:	48 83 ec 18          	sub    $0x18,%rsp
    330a:	48 8b 38             	mov    (%rax),%rdi
    330d:	c6 80 a5 00 00 00 01 	movb   $0x1,0xa5(%rax)
    3314:	0f b7 57 0c          	movzwl 0xc(%rdi),%edx
    3318:	48 89 d3             	mov    %rdx,%rbx
    331b:	48 85 c9             	test   %rcx,%rcx
    331e:	0f 84 8c 00 00 00    	je     33b0 <ayatsuri_model_instance_targets+0x100>
    3324:	48 39 51 20          	cmp    %rdx,0x20(%rcx)
    3328:	0f 85 82 00 00 00    	jne    33b0 <ayatsuri_model_instance_targets+0x100>
    332e:	48 8b 31             	mov    (%rcx),%rsi
    3331:	48 85 f6             	test   %rsi,%rsi
    3334:	74 7a                	je     33b0 <ayatsuri_model_instance_targets+0x100>
    3336:	4c 8b 41 08          	mov    0x8(%rcx),%r8
    333a:	4d 85 c0             	test   %r8,%r8
    333d:	74 71                	je     33b0 <ayatsuri_model_instance_targets+0x100>
    333f:	4c 8b 51 10          	mov    0x10(%rcx),%r10
    3343:	4d 85 d2             	test   %r10,%r10
    3346:	74 68                	je     33b0 <ayatsuri_model_instance_targets+0x100>
    3348:	4c 8b 59 18          	mov    0x18(%rcx),%r11
    334c:	4d 85 db             	test   %r11,%r11
    334f:	74 5f                	je     33b0 <ayatsuri_model_instance_targets+0x100>
    3351:	48 8b 68 18          	mov    0x18(%rax),%rbp
    3355:	4c 8b 48 08          	mov    0x8(%rax),%r9
    3359:	48 85 ed             	test   %rbp,%rbp
    335c:	4c 89 c9             	mov    %r9,%rcx
    335f:	41 0f 95 c4          	setne  %r12b
    3363:	48 85 d2             	test   %rdx,%rdx
    3366:	74 68                	je     33d0 <ayatsuri_model_instance_targets+0x120>
    3368:	45 84 e4             	test   %r12b,%r12b
    336b:	74 63                	je     33d0 <ayatsuri_model_instance_targets+0x120>
    336d:	49 39 f1             	cmp    %rsi,%r9
    3370:	73 2e                	jae    33a0 <ayatsuri_model_instance_targets+0xf0>
    3372:	49 89 f5             	mov    %rsi,%r13
    3375:	4d 29 cd             	sub    %r9,%r13
    3378:	49 39 ed             	cmp    %rbp,%r13
    337b:	72 33                	jb     33b0 <ayatsuri_model_instance_targets+0x100>
    337d:	4c 8d 2c d5 00 00 00 	lea    0x0(,%rdx,8),%r13
    3384:	00 
    3385:	4d 8d 7c 15 00       	lea    0x0(%r13,%rdx,1),%r15
    338a:	49 c1 e7 02          	shl    $0x2,%r15
    338e:	eb 60                	jmp    33f0 <ayatsuri_model_instance_targets+0x140>
    3390:	bf 03 00 00 00       	mov    $0x3,%edi
    3395:	89 f8                	mov    %edi,%eax
    3397:	c3                   	ret
    3398:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    339f:	00 
    33a0:	4d 89 cd             	mov    %r9,%r13
    33a3:	49 29 f5             	sub    %rsi,%r13
    33a6:	49 39 d5             	cmp    %rdx,%r13
    33a9:	73 d2                	jae    337d <ayatsuri_model_instance_targets+0xcd>
    33ab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    33b0:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    33b7:	bf 01 00 00 00       	mov    $0x1,%edi
    33bc:	48 83 c4 18          	add    $0x18,%rsp
    33c0:	89 f8                	mov    %edi,%eax
    33c2:	5b                   	pop    %rbx
    33c3:	5d                   	pop    %rbp
    33c4:	41 5c                	pop    %r12
    33c6:	41 5d                	pop    %r13
    33c8:	41 5e                	pop    %r14
    33ca:	41 5f                	pop    %r15
    33cc:	c3                   	ret
    33cd:	0f 1f 00             	nopl   (%rax)
    33d0:	4c 8d 2c d5 00 00 00 	lea    0x0(,%rdx,8),%r13
    33d7:	00 
    33d8:	4d 8d 74 15 00       	lea    0x0(%r13,%rdx,1),%r14
    33dd:	4e 8d 3c b5 00 00 00 	lea    0x0(,%r14,4),%r15
    33e4:	00 
    33e5:	4d 85 f6             	test   %r14,%r14
    33e8:	74 26                	je     3410 <ayatsuri_model_instance_targets+0x160>
    33ea:	45 84 e4             	test   %r12b,%r12b
    33ed:	74 21                	je     3410 <ayatsuri_model_instance_targets+0x160>
    33ef:	90                   	nop
    33f0:	4d 39 c1             	cmp    %r8,%r9
    33f3:	0f 82 67 03 00 00    	jb     3760 <ayatsuri_model_instance_targets+0x4b0>
    33f9:	4d 89 ce             	mov    %r9,%r14
    33fc:	4d 29 c6             	sub    %r8,%r14
    33ff:	4d 39 fe             	cmp    %r15,%r14
    3402:	72 ac                	jb     33b0 <ayatsuri_model_instance_targets+0x100>
    3404:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    340b:	00 00 00 00 
    340f:	90                   	nop
    3410:	4c 8d 34 95 00 00 00 	lea    0x0(,%rdx,4),%r14
    3417:	00 
    3418:	48 85 d2             	test   %rdx,%rdx
    341b:	74 23                	je     3440 <ayatsuri_model_instance_targets+0x190>
    341d:	45 84 e4             	test   %r12b,%r12b
    3420:	74 1e                	je     3440 <ayatsuri_model_instance_targets+0x190>
    3422:	4d 39 d1             	cmp    %r10,%r9
    3425:	0f 82 65 03 00 00    	jb     3790 <ayatsuri_model_instance_targets+0x4e0>
    342b:	4c 89 ca             	mov    %r9,%rdx
    342e:	4c 29 d2             	sub    %r10,%rdx
    3431:	4c 39 f2             	cmp    %r14,%rdx
    3434:	0f 82 76 ff ff ff    	jb     33b0 <ayatsuri_model_instance_targets+0x100>
    343a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3440:	4d 85 ed             	test   %r13,%r13
    3443:	74 2b                	je     3470 <ayatsuri_model_instance_targets+0x1c0>
    3445:	45 84 e4             	test   %r12b,%r12b
    3448:	74 26                	je     3470 <ayatsuri_model_instance_targets+0x1c0>
    344a:	4d 39 d9             	cmp    %r11,%r9
    344d:	0f 82 51 03 00 00    	jb     37a4 <ayatsuri_model_instance_targets+0x4f4>
    3453:	4c 89 ca             	mov    %r9,%rdx
    3456:	4c 29 da             	sub    %r11,%rdx
    3459:	4c 39 ea             	cmp    %r13,%rdx
    345c:	0f 82 4e ff ff ff    	jb     33b0 <ayatsuri_model_instance_targets+0x100>
    3462:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    3469:	00 00 00 00 
    346d:	0f 1f 00             	nopl   (%rax)
    3470:	44 0f b7 fb          	movzwl %bx,%r15d
    3474:	45 85 ff             	test   %r15d,%r15d
    3477:	0f 84 d3 02 00 00    	je     3750 <ayatsuri_model_instance_targets+0x4a0>
    347d:	8b 57 14             	mov    0x14(%rdi),%edx
    3480:	4c 89 1c 24          	mov    %r11,(%rsp)
    3484:	31 ed                	xor    %ebp,%ebp
    3486:	bb ab aa aa aa       	mov    $0xaaaaaaab,%ebx
    348b:	48 8b 3f             	mov    (%rdi),%rdi
    348e:	4c 89 4c 24 08       	mov    %r9,0x8(%rsp)
    3493:	66 0f ef e4          	pxor   %xmm4,%xmm4
    3497:	45 31 f6             	xor    %r14d,%r14d
    349a:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
    349f:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 34a7 <ayatsuri_model_instance_targets+0x1f7>
    34a6:	00 
			34a3: R_X86_64_PC32	.LC1-0x4
    34a7:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 34af <ayatsuri_model_instance_targets+0x1ff>
    34ae:	00 
			34ab: R_X86_64_PC32	.LC0-0x4
    34af:	48 8d 54 17 02       	lea    0x2(%rdi,%rdx,1),%rdx
    34b4:	44 0f b6 0c 2e       	movzbl (%rsi,%rbp,1),%r9d
    34b9:	45 89 cc             	mov    %r9d,%r12d
    34bc:	45 84 c9             	test   %r9b,%r9b
    34bf:	0f 88 eb fe ff ff    	js     33b0 <ayatsuri_model_instance_targets+0x100>
    34c5:	44 89 c9             	mov    %r9d,%ecx
    34c8:	f7 d1                	not    %ecx
    34ca:	83 e1 18             	and    $0x18,%ecx
    34cd:	0f 84 dd fe ff ff    	je     33b0 <ayatsuri_model_instance_targets+0x100>
    34d3:	0f b6 0a             	movzbl (%rdx),%ecx
    34d6:	84 c9                	test   %cl,%cl
    34d8:	0f 84 9a 02 00 00    	je     3778 <ayatsuri_model_instance_targets+0x4c8>
    34de:	80 f9 03             	cmp    $0x3,%cl
    34e1:	0f 84 91 02 00 00    	je     3778 <ayatsuri_model_instance_targets+0x4c8>
    34e7:	41 89 eb             	mov    %ebp,%r11d
    34ea:	44 8d 6c ed 00       	lea    0x0(%rbp,%rbp,8),%r13d
    34ef:	31 ff                	xor    %edi,%edi
    34f1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    34f8:	00 00 00 00 
    34fc:	0f 1f 40 00          	nopl   0x0(%rax)
    3500:	89 f9                	mov    %edi,%ecx
    3502:	48 0f af cb          	imul   %rbx,%rcx
    3506:	48 c1 e9 21          	shr    $0x21,%rcx
    350a:	41 0f a3 c9          	bt     %ecx,%r9d
    350e:	73 31                	jae    3541 <ayatsuri_model_instance_targets+0x291>
    3510:	41 8d 4c 3d 00       	lea    0x0(%r13,%rdi,1),%ecx
    3515:	f3 41 0f 10 04 88    	movss  (%r8,%rcx,4),%xmm0
    351b:	0f 28 c8             	movaps %xmm0,%xmm1
    351e:	0f 54 cb             	andps  %xmm3,%xmm1
    3521:	0f 2e d1             	ucomiss %xmm1,%xmm2
    3524:	0f 82 86 fe ff ff    	jb     33b0 <ayatsuri_model_instance_targets+0x100>
    352a:	83 ff 05             	cmp    $0x5,%edi
    352d:	76 12                	jbe    3541 <ayatsuri_model_instance_targets+0x291>
    352f:	0f 2e c4             	ucomiss %xmm4,%xmm0
    3532:	0f 9b c1             	setnp  %cl
    3535:	41 0f 45 ce          	cmovne %r14d,%ecx
    3539:	84 c9                	test   %cl,%cl
    353b:	0f 85 6f fe ff ff    	jne    33b0 <ayatsuri_model_instance_targets+0x100>
    3541:	83 c7 01             	add    $0x1,%edi
    3544:	83 ff 09             	cmp    $0x9,%edi
    3547:	75 b7                	jne    3500 <ayatsuri_model_instance_targets+0x250>
    3549:	41 f6 c4 20          	test   $0x20,%r12b
    354d:	74 0e                	je     355d <ayatsuri_model_instance_targets+0x2ad>
    354f:	41 81 3c aa ff ff ff 	cmpl   $0xffffff,(%r10,%rbp,4)
    3556:	00 
    3557:	0f 87 53 fe ff ff    	ja     33b0 <ayatsuri_model_instance_targets+0x100>
    355d:	41 83 e4 40          	and    $0x40,%r12d
    3561:	74 5d                	je     35c0 <ayatsuri_model_instance_targets+0x310>
    3563:	48 8b 0c 24          	mov    (%rsp),%rcx
    3567:	42 8d 3c dd 00 00 00 	lea    0x0(,%r11,8),%edi
    356e:	00 
    356f:	48 01 cf             	add    %rcx,%rdi
    3572:	e8 89 ca ff ff       	call   0 <md>
    3577:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 357f <ayatsuri_model_instance_targets+0x2cf>
    357e:	00 
			357b: R_X86_64_PC32	.LC22-0x4
    357f:	66 0f 28 c8          	movapd %xmm0,%xmm1
    3583:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 358b <ayatsuri_model_instance_targets+0x2db>
    358a:	00 
			3587: R_X86_64_PC32	.LC8-0x4
    358b:	66 0f 2e e9          	ucomisd %xmm1,%xmm5
    358f:	0f 82 1b fe ff ff    	jb     33b0 <ayatsuri_model_instance_targets+0x100>
    3595:	66 0f ef c9          	pxor   %xmm1,%xmm1
    3599:	66 0f 2f c1          	comisd %xmm1,%xmm0
    359d:	0f 82 0d fe ff ff    	jb     33b0 <ayatsuri_model_instance_targets+0x100>
    35a3:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 35ab <ayatsuri_model_instance_targets+0x2fb>
    35aa:	00 
			35a7: R_X86_64_PC32	.LC9-0x4
    35ab:	66 0f 2f c8          	comisd %xmm0,%xmm1
    35af:	0f 82 fb fd ff ff    	jb     33b0 <ayatsuri_model_instance_targets+0x100>
    35b5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    35bc:	00 00 00 00 
    35c0:	48 83 c5 01          	add    $0x1,%rbp
    35c4:	48 83 c2 10          	add    $0x10,%rdx
    35c8:	44 39 fd             	cmp    %r15d,%ebp
    35cb:	0f 82 e3 fe ff ff    	jb     34b4 <ayatsuri_model_instance_targets+0x204>
    35d1:	43 8d 1c ff          	lea    (%r15,%r15,8),%ebx
    35d5:	4c 8b 1c 24          	mov    (%rsp),%r11
    35d9:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
    35de:	45 31 ed             	xor    %r13d,%r13d
    35e1:	89 1c 24             	mov    %ebx,(%rsp)
    35e4:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
    35e9:	41 bc ab aa aa aa    	mov    $0xaaaaaaab,%r12d
    35ef:	c6 44 24 08 00       	movb   $0x0,0x8(%rsp)
    35f4:	0f b6 1e             	movzbl (%rsi),%ebx
    35f7:	8b 69 08             	mov    0x8(%rcx),%ebp
    35fa:	45 31 ff             	xor    %r15d,%r15d
    35fd:	31 ff                	xor    %edi,%edi
    35ff:	41 89 de             	mov    %ebx,%r14d
    3602:	4c 01 cd             	add    %r9,%rbp
    3605:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    360c:	00 00 00 00 
    3610:	89 fa                	mov    %edi,%edx
    3612:	49 0f af d4          	imul   %r12,%rdx
    3616:	48 c1 ea 21          	shr    $0x21,%rdx
    361a:	0f a3 d3             	bt     %edx,%ebx
    361d:	73 3c                	jae    365b <ayatsuri_model_instance_targets+0x3ab>
    361f:	41 8d 54 3d 00       	lea    0x0(%r13,%rdi,1),%edx
    3624:	f3 41 0f 10 04 90    	movss  (%r8,%rdx,4),%xmm0
    362a:	0f 2e 44 bd 30       	ucomiss 0x30(%rbp,%rdi,4),%xmm0
    362f:	7a 02                	jp     3633 <ayatsuri_model_instance_targets+0x383>
    3631:	74 28                	je     365b <ayatsuri_model_instance_targets+0x3ab>
    3633:	8b 90 a0 00 00 00    	mov    0xa0(%rax),%edx
    3639:	41 bf fb ff ff ff    	mov    $0xfffffffb,%r15d
    363f:	f3 0f 11 44 bd 30    	movss  %xmm0,0x30(%rbp,%rdi,4)
    3645:	44 39 fa             	cmp    %r15d,%edx
    3648:	41 0f 47 d7          	cmova  %r15d,%edx
    364c:	41 bf 01 00 00 00    	mov    $0x1,%r15d
    3652:	83 c2 04             	add    $0x4,%edx
    3655:	89 90 a0 00 00 00    	mov    %edx,0xa0(%rax)
    365b:	48 83 c7 01          	add    $0x1,%rdi
    365f:	48 83 ff 09          	cmp    $0x9,%rdi
    3663:	75 ab                	jne    3610 <ayatsuri_model_instance_targets+0x360>
    3665:	41 f6 c6 18          	test   $0x18,%r14b
    3669:	0f 84 49 01 00 00    	je     37b8 <ayatsuri_model_instance_targets+0x508>
    366f:	44 89 f2             	mov    %r14d,%edx
    3672:	c0 ea 03             	shr    $0x3,%dl
    3675:	83 e2 01             	and    $0x1,%edx
    3678:	38 51 10             	cmp    %dl,0x10(%rcx)
    367b:	0f 84 37 01 00 00    	je     37b8 <ayatsuri_model_instance_targets+0x508>
    3681:	88 51 10             	mov    %dl,0x10(%rcx)
    3684:	8b 90 a0 00 00 00    	mov    0xa0(%rax),%edx
    368a:	31 ff                	xor    %edi,%edi
    368c:	83 fa ff             	cmp    $0xffffffff,%edx
    368f:	40 0f 95 c7          	setne  %dil
    3693:	01 fa                	add    %edi,%edx
    3695:	89 90 a0 00 00 00    	mov    %edx,0xa0(%rax)
    369b:	41 f6 c6 20          	test   $0x20,%r14b
    369f:	74 24                	je     36c5 <ayatsuri_model_instance_targets+0x415>
    36a1:	41 8b 12             	mov    (%r10),%edx
    36a4:	39 51 0c             	cmp    %edx,0xc(%rcx)
    36a7:	74 1c                	je     36c5 <ayatsuri_model_instance_targets+0x415>
    36a9:	89 51 0c             	mov    %edx,0xc(%rcx)
    36ac:	8b 90 a0 00 00 00    	mov    0xa0(%rax),%edx
    36b2:	bf fb ff ff ff       	mov    $0xfffffffb,%edi
    36b7:	39 fa                	cmp    %edi,%edx
    36b9:	0f 47 d7             	cmova  %edi,%edx
    36bc:	83 c2 04             	add    $0x4,%edx
    36bf:	89 90 a0 00 00 00    	mov    %edx,0xa0(%rax)
    36c5:	41 83 e6 40          	and    $0x40,%r14d
    36c9:	74 2d                	je     36f8 <ayatsuri_model_instance_targets+0x448>
    36cb:	4c 89 df             	mov    %r11,%rdi
    36ce:	e8 2d c9 ff ff       	call   0 <md>
    36d3:	66 0f 2e 01          	ucomisd (%rcx),%xmm0
    36d7:	7a 02                	jp     36db <ayatsuri_model_instance_targets+0x42b>
    36d9:	74 1d                	je     36f8 <ayatsuri_model_instance_targets+0x448>
    36db:	8b 90 a0 00 00 00    	mov    0xa0(%rax),%edx
    36e1:	bf f7 ff ff ff       	mov    $0xfffffff7,%edi
    36e6:	f2 0f 11 01          	movsd  %xmm0,(%rcx)
    36ea:	39 fa                	cmp    %edi,%edx
    36ec:	0f 47 d7             	cmova  %edi,%edx
    36ef:	83 c2 08             	add    $0x8,%edx
    36f2:	89 90 a0 00 00 00    	mov    %edx,0xa0(%rax)
    36f8:	8b 90 98 00 00 00    	mov    0x98(%rax),%edx
    36fe:	31 ff                	xor    %edi,%edi
    3700:	c6 44 24 08 01       	movb   $0x1,0x8(%rsp)
    3705:	83 fa ff             	cmp    $0xffffffff,%edx
    3708:	40 0f 95 c7          	setne  %dil
    370c:	01 fa                	add    %edi,%edx
    370e:	89 90 98 00 00 00    	mov    %edx,0x98(%rax)
    3714:	8b 1c 24             	mov    (%rsp),%ebx
    3717:	41 83 c5 09          	add    $0x9,%r13d
    371b:	48 83 c6 01          	add    $0x1,%rsi
    371f:	48 83 c1 18          	add    $0x18,%rcx
    3723:	49 83 c3 08          	add    $0x8,%r11
    3727:	49 83 c2 04          	add    $0x4,%r10
    372b:	41 39 dd             	cmp    %ebx,%r13d
    372e:	0f 85 c0 fe ff ff    	jne    35f4 <ayatsuri_model_instance_targets+0x344>
    3734:	80 7c 24 08 00       	cmpb   $0x0,0x8(%rsp)
    3739:	74 15                	je     3750 <ayatsuri_model_instance_targets+0x4a0>
    373b:	8b 50 24             	mov    0x24(%rax),%edx
    373e:	83 fa ff             	cmp    $0xffffffff,%edx
    3741:	74 03                	je     3746 <ayatsuri_model_instance_targets+0x496>
    3743:	83 c2 01             	add    $0x1,%edx
    3746:	89 50 24             	mov    %edx,0x24(%rax)
    3749:	c6 80 a6 00 00 00 00 	movb   $0x0,0xa6(%rax)
    3750:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    3757:	31 ff                	xor    %edi,%edi
    3759:	e9 5e fc ff ff       	jmp    33bc <ayatsuri_model_instance_targets+0x10c>
    375e:	66 90                	xchg   %ax,%ax
    3760:	4d 89 c6             	mov    %r8,%r14
    3763:	4d 29 ce             	sub    %r9,%r14
    3766:	49 39 ee             	cmp    %rbp,%r14
    3769:	0f 82 41 fc ff ff    	jb     33b0 <ayatsuri_model_instance_targets+0x100>
    376f:	e9 9c fc ff ff       	jmp    3410 <ayatsuri_model_instance_targets+0x160>
    3774:	0f 1f 40 00          	nopl   0x0(%rax)
    3778:	41 f6 c4 60          	test   $0x60,%r12b
    377c:	0f 84 65 fd ff ff    	je     34e7 <ayatsuri_model_instance_targets+0x237>
    3782:	e9 29 fc ff ff       	jmp    33b0 <ayatsuri_model_instance_targets+0x100>
    3787:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    378e:	00 00 
    3790:	4c 89 d2             	mov    %r10,%rdx
    3793:	4c 29 ca             	sub    %r9,%rdx
    3796:	48 39 ea             	cmp    %rbp,%rdx
    3799:	0f 82 11 fc ff ff    	jb     33b0 <ayatsuri_model_instance_targets+0x100>
    379f:	e9 9c fc ff ff       	jmp    3440 <ayatsuri_model_instance_targets+0x190>
    37a4:	4c 89 da             	mov    %r11,%rdx
    37a7:	4c 29 ca             	sub    %r9,%rdx
    37aa:	48 39 ea             	cmp    %rbp,%rdx
    37ad:	0f 83 bd fc ff ff    	jae    3470 <ayatsuri_model_instance_targets+0x1c0>
    37b3:	e9 f8 fb ff ff       	jmp    33b0 <ayatsuri_model_instance_targets+0x100>
    37b8:	41 f6 c6 20          	test   $0x20,%r14b
    37bc:	74 0c                	je     37ca <ayatsuri_model_instance_targets+0x51a>
    37be:	41 8b 12             	mov    (%r10),%edx
    37c1:	39 51 0c             	cmp    %edx,0xc(%rcx)
    37c4:	0f 85 df fe ff ff    	jne    36a9 <ayatsuri_model_instance_targets+0x3f9>
    37ca:	41 83 e6 40          	and    $0x40,%r14d
    37ce:	74 18                	je     37e8 <ayatsuri_model_instance_targets+0x538>
    37d0:	4c 89 df             	mov    %r11,%rdi
    37d3:	e8 28 c8 ff ff       	call   0 <md>
    37d8:	66 0f 2e 01          	ucomisd (%rcx),%xmm0
    37dc:	0f 8a f9 fe ff ff    	jp     36db <ayatsuri_model_instance_targets+0x42b>
    37e2:	0f 85 f3 fe ff ff    	jne    36db <ayatsuri_model_instance_targets+0x42b>
    37e8:	45 84 ff             	test   %r15b,%r15b
    37eb:	0f 84 23 ff ff ff    	je     3714 <ayatsuri_model_instance_targets+0x464>
    37f1:	e9 02 ff ff ff       	jmp    36f8 <ayatsuri_model_instance_targets+0x448>
    37f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    37fd:	00 00 00 

0000000000003800 <ayatsuri_model_instance_node_kind>:
    3800:	48 89 f8             	mov    %rdi,%rax
    3803:	89 cf                	mov    %ecx,%edi
    3805:	b9 03 00 00 00       	mov    $0x3,%ecx
    380a:	48 85 c0             	test   %rax,%rax
    380d:	74 6d                	je     387c <ayatsuri_model_instance_node_kind+0x7c>
    380f:	80 b8 a4 00 00 00 01 	cmpb   $0x1,0xa4(%rax)
    3816:	75 64                	jne    387c <ayatsuri_model_instance_node_kind+0x7c>
    3818:	48 85 f6             	test   %rsi,%rsi
    381b:	74 5f                	je     387c <ayatsuri_model_instance_node_kind+0x7c>
    381d:	48 3b 70 10          	cmp    0x10(%rax),%rsi
    3821:	75 59                	jne    387c <ayatsuri_model_instance_node_kind+0x7c>
    3823:	3b 50 20             	cmp    0x20(%rax),%edx
    3826:	75 54                	jne    387c <ayatsuri_model_instance_node_kind+0x7c>
    3828:	80 b8 a5 00 00 00 00 	cmpb   $0x0,0xa5(%rax)
    382f:	b9 04 00 00 00       	mov    $0x4,%ecx
    3834:	75 46                	jne    387c <ayatsuri_model_instance_node_kind+0x7c>
    3836:	c6 80 a5 00 00 00 01 	movb   $0x1,0xa5(%rax)
    383d:	4d 85 c0             	test   %r8,%r8
    3840:	74 2e                	je     3870 <ayatsuri_model_instance_node_kind+0x70>
    3842:	48 8b 10             	mov    (%rax),%rdx
    3845:	66 3b 7a 0c          	cmp    0xc(%rdx),%di
    3849:	73 25                	jae    3870 <ayatsuri_model_instance_node_kind+0x70>
    384b:	4c 39 c0             	cmp    %r8,%rax
    384e:	73 30                	jae    3880 <ayatsuri_model_instance_node_kind+0x80>
    3850:	4c 89 c1             	mov    %r8,%rcx
    3853:	48 29 c1             	sub    %rax,%rcx
    3856:	48 81 f9 a7 00 00 00 	cmp    $0xa7,%rcx
    385d:	76 11                	jbe    3870 <ayatsuri_model_instance_node_kind+0x70>
    385f:	4c 39 c2             	cmp    %r8,%rdx
    3862:	72 24                	jb     3888 <ayatsuri_model_instance_node_kind+0x88>
    3864:	49 39 d0             	cmp    %rdx,%r8
    3867:	75 2b                	jne    3894 <ayatsuri_model_instance_node_kind+0x94>
    3869:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3870:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    3877:	b9 01 00 00 00       	mov    $0x1,%ecx
    387c:	89 c8                	mov    %ecx,%eax
    387e:	c3                   	ret
    387f:	90                   	nop
    3880:	74 ee                	je     3870 <ayatsuri_model_instance_node_kind+0x70>
    3882:	eb db                	jmp    385f <ayatsuri_model_instance_node_kind+0x5f>
    3884:	0f 1f 40 00          	nopl   0x0(%rax)
    3888:	4c 89 c1             	mov    %r8,%rcx
    388b:	48 29 d1             	sub    %rdx,%rcx
    388e:	48 83 f9 7f          	cmp    $0x7f,%rcx
    3892:	76 dc                	jbe    3870 <ayatsuri_model_instance_node_kind+0x70>
    3894:	48 8b 48 18          	mov    0x18(%rax),%rcx
    3898:	48 85 c9             	test   %rcx,%rcx
    389b:	74 13                	je     38b0 <ayatsuri_model_instance_node_kind+0xb0>
    389d:	48 8b 70 08          	mov    0x8(%rax),%rsi
    38a1:	4c 39 c6             	cmp    %r8,%rsi
    38a4:	72 5a                	jb     3900 <ayatsuri_model_instance_node_kind+0x100>
    38a6:	49 39 f0             	cmp    %rsi,%r8
    38a9:	74 c5                	je     3870 <ayatsuri_model_instance_node_kind+0x70>
    38ab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    38b0:	8b 4a 08             	mov    0x8(%rdx),%ecx
    38b3:	48 8b 32             	mov    (%rdx),%rsi
    38b6:	48 85 c9             	test   %rcx,%rcx
    38b9:	74 15                	je     38d0 <ayatsuri_model_instance_node_kind+0xd0>
    38bb:	4c 39 c6             	cmp    %r8,%rsi
    38be:	72 58                	jb     3918 <ayatsuri_model_instance_node_kind+0x118>
    38c0:	49 39 f0             	cmp    %rsi,%r8
    38c3:	74 ab                	je     3870 <ayatsuri_model_instance_node_kind+0x70>
    38c5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    38cc:	00 00 00 00 
    38d0:	8b 52 14             	mov    0x14(%rdx),%edx
    38d3:	48 89 f9             	mov    %rdi,%rcx
    38d6:	48 c1 e1 04          	shl    $0x4,%rcx
    38da:	81 e1 f0 ff 0f 00    	and    $0xffff0,%ecx
    38e0:	48 01 d6             	add    %rdx,%rsi
    38e3:	0f b6 54 31 02       	movzbl 0x2(%rcx,%rsi,1),%edx
    38e8:	31 c9                	xor    %ecx,%ecx
    38ea:	41 88 10             	mov    %dl,(%r8)
    38ed:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    38f4:	eb 86                	jmp    387c <ayatsuri_model_instance_node_kind+0x7c>
    38f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    38fd:	00 00 00 
    3900:	4d 89 c1             	mov    %r8,%r9
    3903:	49 29 f1             	sub    %rsi,%r9
    3906:	49 39 c9             	cmp    %rcx,%r9
    3909:	0f 82 61 ff ff ff    	jb     3870 <ayatsuri_model_instance_node_kind+0x70>
    390f:	eb 9f                	jmp    38b0 <ayatsuri_model_instance_node_kind+0xb0>
    3911:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3918:	4d 89 c1             	mov    %r8,%r9
    391b:	49 29 f1             	sub    %rsi,%r9
    391e:	49 39 c9             	cmp    %rcx,%r9
    3921:	73 ad                	jae    38d0 <ayatsuri_model_instance_node_kind+0xd0>
    3923:	e9 48 ff ff ff       	jmp    3870 <ayatsuri_model_instance_node_kind+0x70>
    3928:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    392f:	00 

0000000000003930 <ayatsuri_model_instance_read_pose>:
    3930:	48 89 f8             	mov    %rdi,%rax
    3933:	89 cf                	mov    %ecx,%edi
    3935:	b9 03 00 00 00       	mov    $0x3,%ecx
    393a:	48 85 c0             	test   %rax,%rax
    393d:	74 6d                	je     39ac <ayatsuri_model_instance_read_pose+0x7c>
    393f:	80 b8 a4 00 00 00 01 	cmpb   $0x1,0xa4(%rax)
    3946:	75 64                	jne    39ac <ayatsuri_model_instance_read_pose+0x7c>
    3948:	48 85 f6             	test   %rsi,%rsi
    394b:	74 5f                	je     39ac <ayatsuri_model_instance_read_pose+0x7c>
    394d:	48 3b 70 10          	cmp    0x10(%rax),%rsi
    3951:	75 59                	jne    39ac <ayatsuri_model_instance_read_pose+0x7c>
    3953:	3b 50 20             	cmp    0x20(%rax),%edx
    3956:	75 54                	jne    39ac <ayatsuri_model_instance_read_pose+0x7c>
    3958:	80 b8 a5 00 00 00 00 	cmpb   $0x0,0xa5(%rax)
    395f:	b9 04 00 00 00       	mov    $0x4,%ecx
    3964:	75 46                	jne    39ac <ayatsuri_model_instance_read_pose+0x7c>
    3966:	c6 80 a5 00 00 00 01 	movb   $0x1,0xa5(%rax)
    396d:	4d 85 c0             	test   %r8,%r8
    3970:	74 2e                	je     39a0 <ayatsuri_model_instance_read_pose+0x70>
    3972:	48 8b 10             	mov    (%rax),%rdx
    3975:	66 3b 7a 0c          	cmp    0xc(%rdx),%di
    3979:	73 25                	jae    39a0 <ayatsuri_model_instance_read_pose+0x70>
    397b:	4c 39 c0             	cmp    %r8,%rax
    397e:	73 30                	jae    39b0 <ayatsuri_model_instance_read_pose+0x80>
    3980:	4c 89 c1             	mov    %r8,%rcx
    3983:	48 29 c1             	sub    %rax,%rcx
    3986:	48 81 f9 a7 00 00 00 	cmp    $0xa7,%rcx
    398d:	76 11                	jbe    39a0 <ayatsuri_model_instance_read_pose+0x70>
    398f:	4c 39 c2             	cmp    %r8,%rdx
    3992:	72 2c                	jb     39c0 <ayatsuri_model_instance_read_pose+0x90>
    3994:	48 89 d1             	mov    %rdx,%rcx
    3997:	4c 29 c1             	sub    %r8,%rcx
    399a:	48 83 f9 23          	cmp    $0x23,%rcx
    399e:	77 2c                	ja     39cc <ayatsuri_model_instance_read_pose+0x9c>
    39a0:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    39a7:	b9 01 00 00 00       	mov    $0x1,%ecx
    39ac:	89 c8                	mov    %ecx,%eax
    39ae:	c3                   	ret
    39af:	90                   	nop
    39b0:	48 89 c1             	mov    %rax,%rcx
    39b3:	4c 29 c1             	sub    %r8,%rcx
    39b6:	48 83 f9 23          	cmp    $0x23,%rcx
    39ba:	76 e4                	jbe    39a0 <ayatsuri_model_instance_read_pose+0x70>
    39bc:	eb d1                	jmp    398f <ayatsuri_model_instance_read_pose+0x5f>
    39be:	66 90                	xchg   %ax,%ax
    39c0:	4c 89 c1             	mov    %r8,%rcx
    39c3:	48 29 d1             	sub    %rdx,%rcx
    39c6:	48 83 f9 7f          	cmp    $0x7f,%rcx
    39ca:	76 d4                	jbe    39a0 <ayatsuri_model_instance_read_pose+0x70>
    39cc:	48 8b 48 18          	mov    0x18(%rax),%rcx
    39d0:	48 8b 70 08          	mov    0x8(%rax),%rsi
    39d4:	48 85 c9             	test   %rcx,%rcx
    39d7:	74 17                	je     39f0 <ayatsuri_model_instance_read_pose+0xc0>
    39d9:	4c 39 c6             	cmp    %r8,%rsi
    39dc:	72 72                	jb     3a50 <ayatsuri_model_instance_read_pose+0x120>
    39de:	48 89 f1             	mov    %rsi,%rcx
    39e1:	4c 29 c1             	sub    %r8,%rcx
    39e4:	48 83 f9 23          	cmp    $0x23,%rcx
    39e8:	76 b6                	jbe    39a0 <ayatsuri_model_instance_read_pose+0x70>
    39ea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    39f0:	8b 4a 08             	mov    0x8(%rdx),%ecx
    39f3:	48 85 c9             	test   %rcx,%rcx
    39f6:	74 18                	je     3a10 <ayatsuri_model_instance_read_pose+0xe0>
    39f8:	48 8b 12             	mov    (%rdx),%rdx
    39fb:	4c 39 c2             	cmp    %r8,%rdx
    39fe:	72 68                	jb     3a68 <ayatsuri_model_instance_read_pose+0x138>
    3a00:	4c 29 c2             	sub    %r8,%rdx
    3a03:	48 83 fa 23          	cmp    $0x23,%rdx
    3a07:	76 97                	jbe    39a0 <ayatsuri_model_instance_read_pose+0x70>
    3a09:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3a10:	0f b7 cf             	movzwl %di,%ecx
    3a13:	48 8d 14 49          	lea    (%rcx,%rcx,2),%rdx
    3a17:	31 c9                	xor    %ecx,%ecx
    3a19:	8b 54 d6 08          	mov    0x8(%rsi,%rdx,8),%edx
    3a1d:	48 8d 54 16 30       	lea    0x30(%rsi,%rdx,1),%rdx
    3a22:	f3 0f 6f 02          	movdqu (%rdx),%xmm0
    3a26:	41 0f 11 00          	movups %xmm0,(%r8)
    3a2a:	f3 0f 6f 42 10       	movdqu 0x10(%rdx),%xmm0
    3a2f:	41 0f 11 40 10       	movups %xmm0,0x10(%r8)
    3a34:	8b 52 20             	mov    0x20(%rdx),%edx
    3a37:	41 89 50 20          	mov    %edx,0x20(%r8)
    3a3b:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    3a42:	e9 65 ff ff ff       	jmp    39ac <ayatsuri_model_instance_read_pose+0x7c>
    3a47:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    3a4e:	00 00 
    3a50:	4d 89 c1             	mov    %r8,%r9
    3a53:	49 29 f1             	sub    %rsi,%r9
    3a56:	49 39 c9             	cmp    %rcx,%r9
    3a59:	0f 82 41 ff ff ff    	jb     39a0 <ayatsuri_model_instance_read_pose+0x70>
    3a5f:	eb 8f                	jmp    39f0 <ayatsuri_model_instance_read_pose+0xc0>
    3a61:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3a68:	4d 89 c1             	mov    %r8,%r9
    3a6b:	49 29 d1             	sub    %rdx,%r9
    3a6e:	49 39 c9             	cmp    %rcx,%r9
    3a71:	73 9d                	jae    3a10 <ayatsuri_model_instance_read_pose+0xe0>
    3a73:	e9 28 ff ff ff       	jmp    39a0 <ayatsuri_model_instance_read_pose+0x70>
    3a78:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    3a7f:	00 

0000000000003a80 <ayatsuri_model_instance_stats>:
    3a80:	48 89 f8             	mov    %rdi,%rax
    3a83:	bf 03 00 00 00       	mov    $0x3,%edi
    3a88:	48 85 c0             	test   %rax,%rax
    3a8b:	74 46                	je     3ad3 <ayatsuri_model_instance_stats+0x53>
    3a8d:	80 b8 a4 00 00 00 01 	cmpb   $0x1,0xa4(%rax)
    3a94:	75 3d                	jne    3ad3 <ayatsuri_model_instance_stats+0x53>
    3a96:	48 85 f6             	test   %rsi,%rsi
    3a99:	74 38                	je     3ad3 <ayatsuri_model_instance_stats+0x53>
    3a9b:	48 3b 70 10          	cmp    0x10(%rax),%rsi
    3a9f:	75 32                	jne    3ad3 <ayatsuri_model_instance_stats+0x53>
    3aa1:	3b 50 20             	cmp    0x20(%rax),%edx
    3aa4:	75 2d                	jne    3ad3 <ayatsuri_model_instance_stats+0x53>
    3aa6:	80 b8 a5 00 00 00 00 	cmpb   $0x0,0xa5(%rax)
    3aad:	bf 04 00 00 00       	mov    $0x4,%edi
    3ab2:	75 1f                	jne    3ad3 <ayatsuri_model_instance_stats+0x53>
    3ab4:	48 85 c9             	test   %rcx,%rcx
    3ab7:	0f 84 fb 00 00 00    	je     3bb8 <ayatsuri_model_instance_stats+0x138>
    3abd:	48 39 c8             	cmp    %rcx,%rax
    3ac0:	72 1e                	jb     3ae0 <ayatsuri_model_instance_stats+0x60>
    3ac2:	48 89 c2             	mov    %rax,%rdx
    3ac5:	bf 01 00 00 00       	mov    $0x1,%edi
    3aca:	48 29 ca             	sub    %rcx,%rdx
    3acd:	48 83 fa 1b          	cmp    $0x1b,%rdx
    3ad1:	77 21                	ja     3af4 <ayatsuri_model_instance_stats+0x74>
    3ad3:	89 f8                	mov    %edi,%eax
    3ad5:	c3                   	ret
    3ad6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    3add:	00 00 00 
    3ae0:	48 89 ca             	mov    %rcx,%rdx
    3ae3:	bf 01 00 00 00       	mov    $0x1,%edi
    3ae8:	48 29 c2             	sub    %rax,%rdx
    3aeb:	48 81 fa a7 00 00 00 	cmp    $0xa7,%rdx
    3af2:	76 df                	jbe    3ad3 <ayatsuri_model_instance_stats+0x53>
    3af4:	48 8b 10             	mov    (%rax),%rdx
    3af7:	48 39 ca             	cmp    %rcx,%rdx
    3afa:	0f 83 98 00 00 00    	jae    3b98 <ayatsuri_model_instance_stats+0x118>
    3b00:	48 89 ce             	mov    %rcx,%rsi
    3b03:	bf 01 00 00 00       	mov    $0x1,%edi
    3b08:	48 29 d6             	sub    %rdx,%rsi
    3b0b:	48 83 fe 7f          	cmp    $0x7f,%rsi
    3b0f:	76 c2                	jbe    3ad3 <ayatsuri_model_instance_stats+0x53>
    3b11:	48 8b 70 18          	mov    0x18(%rax),%rsi
    3b15:	48 85 f6             	test   %rsi,%rsi
    3b18:	74 26                	je     3b40 <ayatsuri_model_instance_stats+0xc0>
    3b1a:	48 8b 78 08          	mov    0x8(%rax),%rdi
    3b1e:	48 39 cf             	cmp    %rcx,%rdi
    3b21:	0f 82 99 00 00 00    	jb     3bc0 <ayatsuri_model_instance_stats+0x140>
    3b27:	48 29 cf             	sub    %rcx,%rdi
    3b2a:	48 89 fe             	mov    %rdi,%rsi
    3b2d:	bf 01 00 00 00       	mov    $0x1,%edi
    3b32:	48 83 fe 1b          	cmp    $0x1b,%rsi
    3b36:	76 9b                	jbe    3ad3 <ayatsuri_model_instance_stats+0x53>
    3b38:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    3b3f:	00 
    3b40:	8b 72 08             	mov    0x8(%rdx),%esi
    3b43:	48 85 f6             	test   %rsi,%rsi
    3b46:	74 28                	je     3b70 <ayatsuri_model_instance_stats+0xf0>
    3b48:	48 8b 12             	mov    (%rdx),%rdx
    3b4b:	48 39 ca             	cmp    %rcx,%rdx
    3b4e:	0f 82 8c 00 00 00    	jb     3be0 <ayatsuri_model_instance_stats+0x160>
    3b54:	48 29 ca             	sub    %rcx,%rdx
    3b57:	bf 01 00 00 00       	mov    $0x1,%edi
    3b5c:	48 83 fa 1b          	cmp    $0x1b,%rdx
    3b60:	0f 86 6d ff ff ff    	jbe    3ad3 <ayatsuri_model_instance_stats+0x53>
    3b66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    3b6d:	00 00 00 
    3b70:	f3 0f 6f 80 88 00 00 	movdqu 0x88(%rax),%xmm0
    3b77:	00 
    3b78:	31 ff                	xor    %edi,%edi
    3b7a:	0f 11 01             	movups %xmm0,(%rcx)
    3b7d:	f3 0f 6f 80 94 00 00 	movdqu 0x94(%rax),%xmm0
    3b84:	00 
    3b85:	0f 11 41 0c          	movups %xmm0,0xc(%rcx)
    3b89:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    3b90:	e9 3e ff ff ff       	jmp    3ad3 <ayatsuri_model_instance_stats+0x53>
    3b95:	0f 1f 00             	nopl   (%rax)
    3b98:	48 89 d6             	mov    %rdx,%rsi
    3b9b:	bf 01 00 00 00       	mov    $0x1,%edi
    3ba0:	48 29 ce             	sub    %rcx,%rsi
    3ba3:	48 83 fe 1b          	cmp    $0x1b,%rsi
    3ba7:	0f 86 26 ff ff ff    	jbe    3ad3 <ayatsuri_model_instance_stats+0x53>
    3bad:	e9 5f ff ff ff       	jmp    3b11 <ayatsuri_model_instance_stats+0x91>
    3bb2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3bb8:	bf 01 00 00 00       	mov    $0x1,%edi
    3bbd:	89 f8                	mov    %edi,%eax
    3bbf:	c3                   	ret
    3bc0:	49 89 c8             	mov    %rcx,%r8
    3bc3:	49 29 f8             	sub    %rdi,%r8
    3bc6:	bf 01 00 00 00       	mov    $0x1,%edi
    3bcb:	49 39 f0             	cmp    %rsi,%r8
    3bce:	0f 82 ff fe ff ff    	jb     3ad3 <ayatsuri_model_instance_stats+0x53>
    3bd4:	e9 67 ff ff ff       	jmp    3b40 <ayatsuri_model_instance_stats+0xc0>
    3bd9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3be0:	49 89 c8             	mov    %rcx,%r8
    3be3:	bf 01 00 00 00       	mov    $0x1,%edi
    3be8:	49 29 d0             	sub    %rdx,%r8
    3beb:	49 39 f0             	cmp    %rsi,%r8
    3bee:	0f 82 df fe ff ff    	jb     3ad3 <ayatsuri_model_instance_stats+0x53>
    3bf4:	e9 77 ff ff ff       	jmp    3b70 <ayatsuri_model_instance_stats+0xf0>
    3bf9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000003c00 <ayatsuri_model_instance_evaluate>:
    3c00:	48 85 ff             	test   %rdi,%rdi
    3c03:	0f 84 7f 01 00 00    	je     3d88 <ayatsuri_model_instance_evaluate+0x188>
    3c09:	41 57                	push   %r15
    3c0b:	b8 03 00 00 00       	mov    $0x3,%eax
    3c10:	49 89 ff             	mov    %rdi,%r15
    3c13:	41 56                	push   %r14
    3c15:	41 55                	push   %r13
    3c17:	41 54                	push   %r12
    3c19:	55                   	push   %rbp
    3c1a:	53                   	push   %rbx
    3c1b:	48 81 ec 48 04 00 00 	sub    $0x448,%rsp
    3c22:	80 bf a4 00 00 00 01 	cmpb   $0x1,0xa4(%rdi)
    3c29:	0f 85 20 01 00 00    	jne    3d4f <ayatsuri_model_instance_evaluate+0x14f>
    3c2f:	48 85 f6             	test   %rsi,%rsi
    3c32:	0f 84 17 01 00 00    	je     3d4f <ayatsuri_model_instance_evaluate+0x14f>
    3c38:	48 3b 77 10          	cmp    0x10(%rdi),%rsi
    3c3c:	0f 85 0d 01 00 00    	jne    3d4f <ayatsuri_model_instance_evaluate+0x14f>
    3c42:	3b 57 20             	cmp    0x20(%rdi),%edx
    3c45:	0f 85 04 01 00 00    	jne    3d4f <ayatsuri_model_instance_evaluate+0x14f>
    3c4b:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    3c52:	b8 04 00 00 00       	mov    $0x4,%eax
    3c57:	0f 85 f2 00 00 00    	jne    3d4f <ayatsuri_model_instance_evaluate+0x14f>
    3c5d:	8b 87 88 00 00 00    	mov    0x88(%rdi),%eax
    3c63:	31 d2                	xor    %edx,%edx
    3c65:	c6 87 a5 00 00 00 01 	movb   $0x1,0xa5(%rdi)
    3c6c:	83 f8 ff             	cmp    $0xffffffff,%eax
    3c6f:	0f 95 c2             	setne  %dl
    3c72:	01 d0                	add    %edx,%eax
    3c74:	89 87 88 00 00 00    	mov    %eax,0x88(%rdi)
    3c7a:	48 85 c9             	test   %rcx,%rcx
    3c7d:	0f 84 bd 00 00 00    	je     3d40 <ayatsuri_model_instance_evaluate+0x140>
    3c83:	4d 85 c0             	test   %r8,%r8
    3c86:	0f 84 b4 00 00 00    	je     3d40 <ayatsuri_model_instance_evaluate+0x140>
    3c8c:	44 0f b6 8f a6 00 00 	movzbl 0xa6(%rdi),%r9d
    3c93:	00 
    3c94:	31 c0                	xor    %eax,%eax
    3c96:	31 ff                	xor    %edi,%edi
    3c98:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 3ca1 <ayatsuri_model_instance_evaluate+0xa1>
    3c9f:	00 00 
			3c9d: R_X86_64_PC32	.LC1-0x4
    3ca1:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 3caa <ayatsuri_model_instance_evaluate+0xaa>
    3ca8:	00 00 
			3ca6: R_X86_64_PC32	.LC0-0x4
    3caa:	44 89 ce             	mov    %r9d,%esi
    3cad:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    3cb4:	00 00 00 00 
    3cb8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    3cbf:	00 
    3cc0:	f3 0f 10 04 01       	movss  (%rcx,%rax,1),%xmm0
    3cc5:	0f 28 c8             	movaps %xmm0,%xmm1
    3cc8:	41 0f 54 ca          	andps  %xmm10,%xmm1
    3ccc:	44 0f 2e f1          	ucomiss %xmm1,%xmm14
    3cd0:	72 6e                	jb     3d40 <ayatsuri_model_instance_evaluate+0x140>
    3cd2:	41 0f 2e 44 07 28    	ucomiss 0x28(%r15,%rax,1),%xmm0
    3cd8:	0f 9b c2             	setnp  %dl
    3cdb:	0f 45 d7             	cmovne %edi,%edx
    3cde:	48 83 c0 04          	add    $0x4,%rax
    3ce2:	21 d6                	and    %edx,%esi
    3ce4:	48 83 f8 24          	cmp    $0x24,%rax
    3ce8:	75 d6                	jne    3cc0 <ayatsuri_model_instance_evaluate+0xc0>
    3cea:	31 c0                	xor    %eax,%eax
    3cec:	f3 41 0f 10 0c 80    	movss  (%r8,%rax,4),%xmm1
    3cf2:	0f 28 c1             	movaps %xmm1,%xmm0
    3cf5:	41 0f 54 c2          	andps  %xmm10,%xmm0
    3cf9:	44 0f 2e f0          	ucomiss %xmm0,%xmm14
    3cfd:	72 41                	jb     3d40 <ayatsuri_model_instance_evaluate+0x140>
    3cff:	48 83 f8 02          	cmp    $0x2,%rax
    3d03:	76 63                	jbe    3d68 <ayatsuri_model_instance_evaluate+0x168>
    3d05:	66 0f ef c0          	pxor   %xmm0,%xmm0
    3d09:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 3d11 <ayatsuri_model_instance_evaluate+0x111>
    3d10:	00 
			3d0d: R_X86_64_PC32	.LC22-0x4
    3d11:	f3 0f 5a c1          	cvtss2sd %xmm1,%xmm0
    3d15:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 3d1d <ayatsuri_model_instance_evaluate+0x11d>
    3d1c:	00 
			3d19: R_X86_64_PC32	.LC8-0x4
    3d1d:	66 0f 2e f8          	ucomisd %xmm0,%xmm7
    3d21:	72 1d                	jb     3d40 <ayatsuri_model_instance_evaluate+0x140>
    3d23:	66 0f ef c0          	pxor   %xmm0,%xmm0
    3d27:	0f 2f c8             	comiss %xmm0,%xmm1
    3d2a:	72 14                	jb     3d40 <ayatsuri_model_instance_evaluate+0x140>
    3d2c:	f3 0f 10 3d 00 00 00 	movss  0x0(%rip),%xmm7        # 3d34 <ayatsuri_model_instance_evaluate+0x134>
    3d33:	00 
			3d30: R_X86_64_PC32	.LC15-0x4
    3d34:	0f 2f f9             	comiss %xmm1,%xmm7
    3d37:	73 57                	jae    3d90 <ayatsuri_model_instance_evaluate+0x190>
    3d39:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3d40:	31 d2                	xor    %edx,%edx
    3d42:	66 41 89 97 a5 00 00 	mov    %dx,0xa5(%r15)
    3d49:	00 
    3d4a:	b8 01 00 00 00       	mov    $0x1,%eax
    3d4f:	48 81 c4 48 04 00 00 	add    $0x448,%rsp
    3d56:	5b                   	pop    %rbx
    3d57:	5d                   	pop    %rbp
    3d58:	41 5c                	pop    %r12
    3d5a:	41 5d                	pop    %r13
    3d5c:	41 5e                	pop    %r14
    3d5e:	41 5f                	pop    %r15
    3d60:	c3                   	ret
    3d61:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3d68:	41 0f 2e 4c 87 4c    	ucomiss 0x4c(%r15,%rax,4),%xmm1
    3d6e:	bf 00 00 00 00       	mov    $0x0,%edi
    3d73:	0f 9b c2             	setnp  %dl
    3d76:	0f 45 d7             	cmovne %edi,%edx
    3d79:	48 83 c0 01          	add    $0x1,%rax
    3d7d:	21 d6                	and    %edx,%esi
    3d7f:	e9 68 ff ff ff       	jmp    3cec <ayatsuri_model_instance_evaluate+0xec>
    3d84:	0f 1f 40 00          	nopl   0x0(%rax)
    3d88:	b8 03 00 00 00       	mov    $0x3,%eax
    3d8d:	c3                   	ret
    3d8e:	66 90                	xchg   %ax,%ax
    3d90:	41 0f 2e 4c 87 4c    	ucomiss 0x4c(%r15,%rax,4),%xmm1
    3d96:	bf 00 00 00 00       	mov    $0x0,%edi
    3d9b:	0f 9b c2             	setnp  %dl
    3d9e:	0f 45 d7             	cmovne %edi,%edx
    3da1:	48 83 c0 01          	add    $0x1,%rax
    3da5:	21 d6                	and    %edx,%esi
    3da7:	48 83 f8 06          	cmp    $0x6,%rax
    3dab:	0f 85 3b ff ff ff    	jne    3cec <ayatsuri_model_instance_evaluate+0xec>
    3db1:	f3 0f 10 49 18       	movss  0x18(%rcx),%xmm1
    3db6:	0f 2f c8             	comiss %xmm0,%xmm1
    3db9:	76 85                	jbe    3d40 <ayatsuri_model_instance_evaluate+0x140>
    3dbb:	40 84 f6             	test   %sil,%sil
    3dbe:	0f 85 c2 1a 00 00    	jne    5886 <ayatsuri_model_instance_evaluate+0x1c86>
    3dc4:	49 8d 77 28          	lea    0x28(%r15),%rsi
    3dc8:	45 84 c9             	test   %r9b,%r9b
    3dcb:	74 18                	je     3de5 <ayatsuri_model_instance_evaluate+0x1e5>
    3dcd:	48 8b 01             	mov    (%rcx),%rax
    3dd0:	48 8b 51 08          	mov    0x8(%rcx),%rdx
    3dd4:	49 33 47 28          	xor    0x28(%r15),%rax
    3dd8:	49 33 57 30          	xor    0x30(%r15),%rdx
    3ddc:	48 09 d0             	or     %rdx,%rax
    3ddf:	0f 84 1b 1e 00 00    	je     5c00 <ayatsuri_model_instance_evaluate+0x2000>
    3de5:	41 c6 87 a6 00 00 00 	movb   $0x0,0xa6(%r15)
    3dec:	00 
    3ded:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
    3df1:	66 0f ef c9          	pxor   %xmm1,%xmm1
    3df5:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
    3dfa:	41 0f 11 47 28       	movups %xmm0,0x28(%r15)
    3dff:	f3 0f 6f 41 10       	movdqu 0x10(%rcx),%xmm0
    3e04:	0f 11 46 10          	movups %xmm0,0x10(%rsi)
    3e08:	8b 41 20             	mov    0x20(%rcx),%eax
    3e0b:	89 46 20             	mov    %eax,0x20(%rsi)
    3e0e:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
    3e13:	41 0f 11 47 4c       	movups %xmm0,0x4c(%r15)
    3e18:	49 8b 40 10          	mov    0x10(%r8),%rax
    3e1c:	49 89 47 5c          	mov    %rax,0x5c(%r15)
    3e20:	0f 5a 41 0c          	cvtps2pd 0xc(%rcx),%xmm0
    3e24:	0f 5a 11             	cvtps2pd (%rcx),%xmm2
    3e27:	66 0f 5c d0          	subpd  %xmm0,%xmm2
    3e2b:	66 0f ef c0          	pxor   %xmm0,%xmm0
    3e2f:	f3 0f 5a 41 14       	cvtss2sd 0x14(%rcx),%xmm0
    3e34:	f3 0f 5a 49 08       	cvtss2sd 0x8(%rcx),%xmm1
    3e39:	f2 0f 5c c8          	subsd  %xmm0,%xmm1
    3e3d:	66 0f 28 fa          	movapd %xmm2,%xmm7
    3e41:	66 0f 15 ff          	unpckhpd %xmm7,%xmm7
    3e45:	66 0f 28 c2          	movapd %xmm2,%xmm0
    3e49:	0f 29 14 24          	movaps %xmm2,(%rsp)
    3e4d:	66 48 0f 7e cb       	movq   %xmm1,%rbx
    3e52:	66 0f 28 cf          	movapd %xmm7,%xmm1
    3e56:	e8 00 00 00 00       	call   3e5b <ayatsuri_model_instance_evaluate+0x25b>
			3e57: R_X86_64_PLT32	hypot-0x4
    3e5b:	66 48 0f 6e cb       	movq   %rbx,%xmm1
    3e60:	e8 00 00 00 00       	call   3e65 <ayatsuri_model_instance_evaluate+0x265>
			3e61: R_X86_64_PLT32	hypot-0x4
    3e65:	66 0f ef c9          	pxor   %xmm1,%xmm1
    3e69:	66 0f 28 14 24       	movapd (%rsp),%xmm2
    3e6e:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
    3e73:	66 0f 2f c1          	comisd %xmm1,%xmm0
    3e77:	0f 86 fc 19 00 00    	jbe    5879 <ayatsuri_model_instance_evaluate+0x1c79>
    3e7d:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 3e85 <ayatsuri_model_instance_evaluate+0x285>
    3e84:	00 
			3e81: R_X86_64_PC32	.LC22-0x4
    3e85:	66 0f 2e f0          	ucomisd %xmm0,%xmm6
    3e89:	0f 82 ea 19 00 00    	jb     5879 <ayatsuri_model_instance_evaluate+0x1c79>
    3e8f:	66 0f 28 c8          	movapd %xmm0,%xmm1
    3e93:	66 48 0f 6e db       	movq   %rbx,%xmm3
    3e98:	4c 89 44 24 38       	mov    %r8,0x38(%rsp)
    3e9d:	f2 0f 5e d8          	divsd  %xmm0,%xmm3
    3ea1:	66 0f 14 c9          	unpcklpd %xmm1,%xmm1
    3ea5:	66 0f 5e d1          	divpd  %xmm1,%xmm2
    3ea9:	66 0f 28 c3          	movapd %xmm3,%xmm0
    3ead:	f2 0f 11 1c 24       	movsd  %xmm3,(%rsp)
    3eb2:	66 0f 28 ea          	movapd %xmm2,%xmm5
    3eb6:	66 0f 28 ca          	movapd %xmm2,%xmm1
    3eba:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
    3ebf:	66 0f 15 ed          	unpckhpd %xmm5,%xmm5
    3ec3:	f2 0f 11 54 24 18    	movsd  %xmm2,0x18(%rsp)
    3ec9:	f2 0f 11 6c 24 30    	movsd  %xmm5,0x30(%rsp)
    3ecf:	e8 00 00 00 00       	call   3ed4 <ayatsuri_model_instance_evaluate+0x2d4>
			3ed0: R_X86_64_PLT32	hypot-0x4
    3ed4:	f2 0f 10 1c 24       	movsd  (%rsp),%xmm3
    3ed9:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
    3ede:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 3ee7 <ayatsuri_model_instance_evaluate+0x2e7>
    3ee5:	00 00 
			3ee3: R_X86_64_PC32	.LC0-0x4
    3ee7:	f2 0f 10 15 00 00 00 	movsd  0x0(%rip),%xmm2        # 3eef <ayatsuri_model_instance_evaluate+0x2ef>
    3eee:	00 
			3eeb: R_X86_64_PC32	.LC37-0x4
    3eef:	f2 0f 10 4c 24 18    	movsd  0x18(%rsp),%xmm1
    3ef5:	66 0f 28 64 24 20    	movapd 0x20(%rsp),%xmm4
    3efb:	f2 0f 10 6c 24 30    	movsd  0x30(%rsp),%xmm5
    3f01:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 3f0a <ayatsuri_model_instance_evaluate+0x30a>
    3f08:	00 00 
			3f06: R_X86_64_PC32	.LC1-0x4
    3f0a:	66 0f 2f d0          	comisd %xmm0,%xmm2
    3f0e:	0f 87 3b 1e 00 00    	ja     5d4f <ayatsuri_model_instance_evaluate+0x214f>
    3f14:	66 0f 28 f3          	movapd %xmm3,%xmm6
    3f18:	f3 0f 7e 3d 00 00 00 	movq   0x0(%rip),%xmm7        # 3f20 <ayatsuri_model_instance_evaluate+0x320>
    3f1f:	00 
			3f1c: R_X86_64_PC32	.LC26-0x4
    3f20:	66 44 0f 28 c3       	movapd %xmm3,%xmm8
    3f25:	66 0f ef d2          	pxor   %xmm2,%xmm2
    3f29:	f2 0f 5e f0          	divsd  %xmm0,%xmm6
    3f2d:	0f 29 bc 24 80 00 00 	movaps %xmm7,0x80(%rsp)
    3f34:	00 
    3f35:	66 0f 57 f9          	xorpd  %xmm1,%xmm7
    3f39:	f2 0f 5e f8          	divsd  %xmm0,%xmm7
    3f3d:	66 0f ef c0          	pxor   %xmm0,%xmm0
    3f41:	f2 44 0f 59 c6       	mulsd  %xmm6,%xmm8
    3f46:	f2 0f 5a d6          	cvtsd2ss %xmm6,%xmm2
    3f4a:	f2 0f 5a c7          	cvtsd2ss %xmm7,%xmm0
    3f4e:	f2 0f 59 cf          	mulsd  %xmm7,%xmm1
    3f52:	66 0f 5a e4          	cvtpd2ps %xmm4,%xmm4
    3f56:	49 8b 07             	mov    (%r15),%rax
    3f59:	f2 0f 5a db          	cvtsd2ss %xmm3,%xmm3
    3f5d:	f3 0f 11 84 24 ec 01 	movss  %xmm0,0x1ec(%rsp)
    3f64:	00 00 
    3f66:	66 0f 28 c5          	movapd %xmm5,%xmm0
    3f6a:	66 0f 57 ac 24 80 00 	xorpd  0x80(%rsp),%xmm5
    3f71:	00 00 
    3f73:	f2 0f 59 c7          	mulsd  %xmm7,%xmm0
    3f77:	66 83 78 0c 00       	cmpw   $0x0,0xc(%rax)
    3f7c:	0f 13 a4 24 c8 01 00 	movlps %xmm4,0x1c8(%rsp)
    3f83:	00 
    3f84:	c7 84 24 e8 01 00 00 	movl   $0x0,0x1e8(%rsp)
    3f8b:	00 00 00 00 
    3f8f:	f3 0f 11 9c 24 d0 01 	movss  %xmm3,0x1d0(%rsp)
    3f96:	00 00 
    3f98:	f3 0f 11 94 24 e4 01 	movss  %xmm2,0x1e4(%rsp)
    3f9f:	00 00 
    3fa1:	f2 44 0f 5c c1       	subsd  %xmm1,%xmm8
    3fa6:	66 41 0f 14 c0       	unpcklpd %xmm8,%xmm0
    3fab:	66 0f 5a c0          	cvtpd2ps %xmm0,%xmm0
    3faf:	0f 13 84 24 d8 01 00 	movlps %xmm0,0x1d8(%rsp)
    3fb6:	00 
    3fb7:	66 0f 28 c5          	movapd %xmm5,%xmm0
    3fbb:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
    3fbf:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    3fc3:	f3 0f 11 84 24 e0 01 	movss  %xmm0,0x1e0(%rsp)
    3fca:	00 00 
    3fcc:	f3 41 0f 10 00       	movss  (%r8),%xmm0
    3fd1:	f3 41 0f 11 67 70    	movss  %xmm4,0x70(%r15)
    3fd7:	0f c6 e4 e5          	shufps $0xe5,%xmm4,%xmm4
    3fdb:	f3 41 0f 11 47 64    	movss  %xmm0,0x64(%r15)
    3fe1:	f3 41 0f 10 40 0c    	movss  0xc(%r8),%xmm0
    3fe7:	f3 41 0f 11 47 7c    	movss  %xmm0,0x7c(%r15)
    3fed:	f3 41 0f 10 40 04    	movss  0x4(%r8),%xmm0
    3ff3:	f3 41 0f 11 67 74    	movss  %xmm4,0x74(%r15)
    3ff9:	f3 41 0f 11 47 68    	movss  %xmm0,0x68(%r15)
    3fff:	f3 41 0f 10 40 10    	movss  0x10(%r8),%xmm0
    4005:	f3 41 0f 11 87 80 00 	movss  %xmm0,0x80(%r15)
    400c:	00 00 
    400e:	f3 41 0f 10 40 08    	movss  0x8(%r8),%xmm0
    4014:	f3 41 0f 11 5f 78    	movss  %xmm3,0x78(%r15)
    401a:	f3 41 0f 11 47 6c    	movss  %xmm0,0x6c(%r15)
    4020:	f3 41 0f 10 40 14    	movss  0x14(%r8),%xmm0
    4026:	f3 41 0f 11 87 84 00 	movss  %xmm0,0x84(%r15)
    402d:	00 00 
    402f:	0f 84 1d 06 00 00    	je     4652 <ayatsuri_model_instance_evaluate+0xa52>
    4035:	48 8d 8c 24 d8 01 00 	lea    0x1d8(%rsp),%rcx
    403c:	00 
    403d:	48 8d 9c 24 e4 01 00 	lea    0x1e4(%rsp),%rbx
    4044:	00 
    4045:	45 31 ed             	xor    %r13d,%r13d
    4048:	48 89 8c 24 78 01 00 	mov    %rcx,0x178(%rsp)
    404f:	00 
    4050:	66 48 0f 6e fb       	movq   %rbx,%xmm7
    4055:	4d 89 ea             	mov    %r13,%r10
    4058:	4c 8d b4 24 50 02 00 	lea    0x250(%rsp),%r14
    405f:	00 
    4060:	48 89 9c 24 80 01 00 	mov    %rbx,0x180(%rsp)
    4067:	00 
    4068:	48 8d 9c 24 5c 02 00 	lea    0x25c(%rsp),%rbx
    406f:	00 
    4070:	4d 89 f3             	mov    %r14,%r11
    4073:	48 89 5c 24 78       	mov    %rbx,0x78(%rsp)
    4078:	0f 16 bc 24 78 01 00 	movhps 0x178(%rsp),%xmm7
    407f:	00 
    4080:	0f 29 bc 24 a0 01 00 	movaps %xmm7,0x1a0(%rsp)
    4087:	00 
    4088:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    408f:	00 
    4090:	44 8b 60 14          	mov    0x14(%rax),%r12d
    4094:	49 8b 6f 08          	mov    0x8(%r15),%rbp
    4098:	4c 89 d1             	mov    %r10,%rcx
    409b:	4f 8d 04 52          	lea    (%r10,%r10,2),%r8
    409f:	48 c1 e1 04          	shl    $0x4,%rcx
    40a3:	4a 8d 14 c5 00 00 00 	lea    0x0(,%r8,8),%rdx
    40aa:	00 
    40ab:	44 89 54 24 18       	mov    %r10d,0x18(%rsp)
    40b0:	49 01 cc             	add    %rcx,%r12
    40b3:	4c 03 20             	add    (%rax),%r12
    40b6:	48 8d 44 15 00       	lea    0x0(%rbp,%rdx,1),%rax
    40bb:	8b 78 08             	mov    0x8(%rax),%edi
    40be:	41 0f b7 34 24       	movzwl (%r12),%esi
    40c3:	48 8d 7c 3d 30       	lea    0x30(%rbp,%rdi,1),%rdi
    40c8:	66 85 f6             	test   %si,%si
    40cb:	0f 88 9f 05 00 00    	js     4670 <ayatsuri_model_instance_evaluate+0xa70>
    40d1:	f3 0f 6f 07          	movdqu (%rdi),%xmm0
    40d5:	44 0f b7 ce          	movzwl %si,%r9d
    40d9:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
    40dd:	48 8d 9c 24 80 02 00 	lea    0x280(%rsp),%rbx
    40e4:	00 
    40e5:	8b 74 f5 08          	mov    0x8(%rbp,%rsi,8),%esi
    40e9:	41 0f 29 03          	movaps %xmm0,(%r11)
    40ed:	f3 0f 6f 47 10       	movdqu 0x10(%rdi),%xmm0
    40f2:	48 01 ee             	add    %rbp,%rsi
    40f5:	41 0f 29 43 10       	movaps %xmm0,0x10(%r11)
    40fa:	f3 0f 6f 06          	movdqu (%rsi),%xmm0
    40fe:	8b 7f 20             	mov    0x20(%rdi),%edi
    4101:	0f 29 84 24 80 02 00 	movaps %xmm0,0x280(%rsp)
    4108:	00 
    4109:	f3 0f 6f 46 10       	movdqu 0x10(%rsi),%xmm0
    410e:	41 89 7b 20          	mov    %edi,0x20(%r11)
    4112:	0f 29 84 24 90 02 00 	movaps %xmm0,0x290(%rsp)
    4119:	00 
    411a:	f3 0f 6f 46 20       	movdqu 0x20(%rsi),%xmm0
    411f:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
    4126:	00 
    4127:	48 8b 7c 24 78       	mov    0x78(%rsp),%rdi
    412c:	4c 89 de             	mov    %r11,%rsi
    412f:	66 0f ef d2          	pxor   %xmm2,%xmm2
    4133:	f3 0f 10 06          	movss  (%rsi),%xmm0
    4137:	41 0f 54 c2          	andps  %xmm10,%xmm0
    413b:	44 0f 2e f0          	ucomiss %xmm0,%xmm14
    413f:	0f 82 9b 16 00 00    	jb     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    4145:	f3 0f 10 46 0c       	movss  0xc(%rsi),%xmm0
    414a:	41 0f 54 c2          	andps  %xmm10,%xmm0
    414e:	44 0f 2e f0          	ucomiss %xmm0,%xmm14
    4152:	0f 82 88 16 00 00    	jb     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    4158:	f3 0f 10 46 18       	movss  0x18(%rsi),%xmm0
    415d:	0f 28 c8             	movaps %xmm0,%xmm1
    4160:	41 0f 54 ca          	andps  %xmm10,%xmm1
    4164:	44 0f 2e f1          	ucomiss %xmm1,%xmm14
    4168:	0f 82 72 16 00 00    	jb     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    416e:	0f 2e c2             	ucomiss %xmm2,%xmm0
    4171:	7a 06                	jp     4179 <ayatsuri_model_instance_evaluate+0x579>
    4173:	0f 84 67 16 00 00    	je     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    4179:	48 83 c6 04          	add    $0x4,%rsi
    417d:	48 39 f7             	cmp    %rsi,%rdi
    4180:	75 b1                	jne    4133 <ayatsuri_model_instance_evaluate+0x533>
    4182:	48 85 db             	test   %rbx,%rbx
    4185:	74 34                	je     41bb <ayatsuri_model_instance_evaluate+0x5bb>
    4187:	48 89 de             	mov    %rbx,%rsi
    418a:	48 8d 7b 30          	lea    0x30(%rbx),%rdi
    418e:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    4195:	00 00 00 00 
    4199:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    41a0:	f3 0f 10 06          	movss  (%rsi),%xmm0
    41a4:	41 0f 54 c2          	andps  %xmm10,%xmm0
    41a8:	44 0f 2e f0          	ucomiss %xmm0,%xmm14
    41ac:	0f 82 2e 16 00 00    	jb     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    41b2:	48 83 c6 04          	add    $0x4,%rsi
    41b6:	48 39 f7             	cmp    %rsi,%rdi
    41b9:	75 e5                	jne    41a0 <ayatsuri_model_instance_evaluate+0x5a0>
    41bb:	4c 8d ac 24 b8 01 00 	lea    0x1b8(%rsp),%r13
    41c2:	00 
    41c3:	66 0f ef c0          	pxor   %xmm0,%xmm0
    41c7:	4c 89 5c 24 70       	mov    %r11,0x70(%rsp)
    41cc:	4c 8d b4 24 b0 01 00 	lea    0x1b0(%rsp),%r14
    41d3:	00 
    41d4:	4c 89 f6             	mov    %r14,%rsi
    41d7:	4c 89 ef             	mov    %r13,%rdi
    41da:	4c 89 54 24 68       	mov    %r10,0x68(%rsp)
    41df:	f3 0f 5a 84 24 5c 02 	cvtss2sd 0x25c(%rsp),%xmm0
    41e6:	00 00 
    41e8:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
    41ed:	4c 89 44 24 58       	mov    %r8,0x58(%rsp)
    41f2:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
    41f7:	44 89 4c 24 48       	mov    %r9d,0x48(%rsp)
    41fc:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
    4201:	e8 00 00 00 00       	call   4206 <ayatsuri_model_instance_evaluate+0x606>
			4202: R_X86_64_PLT32	sincos-0x4
    4206:	4c 89 f6             	mov    %r14,%rsi
    4209:	4c 89 ef             	mov    %r13,%rdi
    420c:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4210:	f2 0f 10 94 24 b0 01 	movsd  0x1b0(%rsp),%xmm2
    4217:	00 00 
    4219:	f2 44 0f 10 8c 24 b8 	movsd  0x1b8(%rsp),%xmm9
    4220:	01 00 00 
    4223:	f3 0f 5a 84 24 60 02 	cvtss2sd 0x260(%rsp),%xmm0
    422a:	00 00 
    422c:	f2 0f 11 54 24 38    	movsd  %xmm2,0x38(%rsp)
    4232:	f2 44 0f 11 4c 24 30 	movsd  %xmm9,0x30(%rsp)
    4239:	e8 00 00 00 00       	call   423e <ayatsuri_model_instance_evaluate+0x63e>
			423a: R_X86_64_PLT32	sincos-0x4
    423e:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4242:	4c 89 f6             	mov    %r14,%rsi
    4245:	4c 89 ef             	mov    %r13,%rdi
    4248:	f2 0f 10 bc 24 b0 01 	movsd  0x1b0(%rsp),%xmm7
    424f:	00 00 
    4251:	f2 0f 10 a4 24 b8 01 	movsd  0x1b8(%rsp),%xmm4
    4258:	00 00 
    425a:	f3 0f 5a 84 24 64 02 	cvtss2sd 0x264(%rsp),%xmm0
    4261:	00 00 
    4263:	f2 0f 11 7c 24 20    	movsd  %xmm7,0x20(%rsp)
    4269:	f2 0f 11 24 24       	movsd  %xmm4,(%rsp)
    426e:	e8 00 00 00 00       	call   4273 <ayatsuri_model_instance_evaluate+0x673>
			426f: R_X86_64_PLT32	sincos-0x4
    4273:	f2 0f 10 24 24       	movsd  (%rsp),%xmm4
    4278:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    427d:	f2 0f 10 84 24 b0 01 	movsd  0x1b0(%rsp),%xmm0
    4284:	00 00 
    4286:	f2 44 0f 10 4c 24 30 	movsd  0x30(%rsp),%xmm9
    428d:	f2 0f 10 54 24 38    	movsd  0x38(%rsp),%xmm2
    4293:	48 85 db             	test   %rbx,%rbx
    4296:	44 0f 5a 9c 24 68 02 	cvtps2pd 0x268(%rsp),%xmm11
    429d:	00 00 
    429f:	66 0f 28 dc          	movapd %xmm4,%xmm3
    42a3:	f2 0f 10 7c 24 20    	movsd  0x20(%rsp),%xmm7
    42a9:	f2 0f 10 8c 24 b8 01 	movsd  0x1b8(%rsp),%xmm1
    42b0:	00 00 
    42b2:	f3 44 0f 5a a4 24 68 	cvtss2sd 0x268(%rsp),%xmm12
    42b9:	02 00 00 
    42bc:	f2 0f 59 d8          	mulsd  %xmm0,%xmm3
    42c0:	66 41 0f 28 f1       	movapd %xmm9,%xmm6
    42c5:	66 44 0f 28 c2       	movapd %xmm2,%xmm8
    42ca:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
    42cf:	f2 44 0f 59 c1       	mulsd  %xmm1,%xmm8
    42d4:	66 0f 28 ef          	movapd %xmm7,%xmm5
    42d8:	66 45 0f 28 e9       	movapd %xmm9,%xmm13
    42dd:	4c 63 4c 24 48       	movslq 0x48(%rsp),%r9
    42e2:	f2 0f 59 e8          	mulsd  %xmm0,%xmm5
    42e6:	66 44 0f 28 fa       	movapd %xmm2,%xmm15
    42eb:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
    42f0:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
    42f5:	f2 44 0f 59 f8       	mulsd  %xmm0,%xmm15
    42fa:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
    42ff:	4c 8b 54 24 68       	mov    0x68(%rsp),%r10
    4304:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 430d <ayatsuri_model_instance_evaluate+0x70d>
    430b:	00 00 
			4309: R_X86_64_PC32	.LC0-0x4
    430d:	f2 41 0f 59 c1       	mulsd  %xmm9,%xmm0
    4312:	4c 8b 5c 24 70       	mov    0x70(%rsp),%r11
    4317:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 4320 <ayatsuri_model_instance_evaluate+0x720>
    431e:	00 00 
			431c: R_X86_64_PC32	.LC1-0x4
    4320:	f2 0f 59 f3          	mulsd  %xmm3,%xmm6
    4324:	f2 0f 59 da          	mulsd  %xmm2,%xmm3
    4328:	f2 41 0f 59 ec       	mulsd  %xmm12,%xmm5
    432d:	f2 41 0f 5c f0       	subsd  %xmm8,%xmm6
    4332:	66 45 0f 28 c3       	movapd %xmm11,%xmm8
    4337:	66 45 0f 15 c0       	unpckhpd %xmm8,%xmm8
    433c:	f2 41 0f 59 f0       	mulsd  %xmm8,%xmm6
    4341:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    4346:	f3 44 0f 5a 84 24 70 	cvtss2sd 0x270(%rsp),%xmm8
    434d:	02 00 00 
    4350:	66 0f 14 ee          	unpcklpd %xmm6,%xmm5
    4354:	66 41 0f 28 f1       	movapd %xmm9,%xmm6
    4359:	f2 0f 59 f1          	mulsd  %xmm1,%xmm6
    435d:	f2 0f 58 de          	addsd  %xmm6,%xmm3
    4361:	66 0f 28 f7          	movapd %xmm7,%xmm6
    4365:	f2 0f 59 f1          	mulsd  %xmm1,%xmm6
    4369:	f2 0f 59 cc          	mulsd  %xmm4,%xmm1
    436d:	66 0f 57 a4 24 80 00 	xorpd  0x80(%rsp),%xmm4
    4374:	00 00 
    4376:	f2 41 0f 59 d8       	mulsd  %xmm8,%xmm3
    437b:	f2 44 0f 59 e9       	mulsd  %xmm1,%xmm13
    4380:	f2 0f 59 ca          	mulsd  %xmm2,%xmm1
    4384:	f2 0f 59 d7          	mulsd  %xmm7,%xmm2
    4388:	f2 45 0f 58 ef       	addsd  %xmm15,%xmm13
    438d:	f2 0f 5c c8          	subsd  %xmm0,%xmm1
    4391:	66 41 0f 28 c1       	movapd %xmm9,%xmm0
    4396:	66 45 0f ef c9       	pxor   %xmm9,%xmm9
    439b:	f3 44 0f 5a 8c 24 58 	cvtss2sd 0x258(%rsp),%xmm9
    43a2:	02 00 00 
    43a5:	f2 0f 59 c7          	mulsd  %xmm7,%xmm0
    43a9:	66 0f ef ff          	pxor   %xmm7,%xmm7
    43ad:	f3 0f 5a bc 24 50 02 	cvtss2sd 0x250(%rsp),%xmm7
    43b4:	00 00 
    43b6:	f2 41 0f 59 d0       	mulsd  %xmm8,%xmm2
    43bb:	f2 41 0f 59 c8       	mulsd  %xmm8,%xmm1
    43c0:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    43c5:	f3 44 0f 5a 84 24 54 	cvtss2sd 0x254(%rsp),%xmm8
    43cc:	02 00 00 
    43cf:	0f 84 23 14 00 00    	je     57f8 <ayatsuri_model_instance_evaluate+0x1bf8>
    43d5:	66 41 0f 14 f5       	unpcklpd %xmm13,%xmm6
    43da:	66 0f 14 e0          	unpcklpd %xmm0,%xmm4
    43de:	4c 8d ac 24 90 03 00 	lea    0x390(%rsp),%r13
    43e5:	00 
    43e6:	66 41 0f 59 f3       	mulpd  %xmm11,%xmm6
    43eb:	4c 89 ee             	mov    %r13,%rsi
    43ee:	48 8d 7b 30          	lea    0x30(%rbx),%rdi
    43f2:	66 41 0f 59 e3       	mulpd  %xmm11,%xmm4
    43f7:	66 0f ef c0          	pxor   %xmm0,%xmm0
    43fb:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    4400:	48 83 c3 10          	add    $0x10,%rbx
    4404:	48 83 c6 20          	add    $0x20,%rsi
    4408:	f3 0f 5a 43 f0       	cvtss2sd -0x10(%rbx),%xmm0
    440d:	f3 44 0f 5a 63 f4    	cvtss2sd -0xc(%rbx),%xmm12
    4413:	66 44 0f 28 e8       	movapd %xmm0,%xmm13
    4418:	66 45 0f 28 fc       	movapd %xmm12,%xmm15
    441d:	66 45 0f 14 ed       	unpcklpd %xmm13,%xmm13
    4422:	66 45 0f 14 ff       	unpcklpd %xmm15,%xmm15
    4427:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    442c:	66 44 0f 59 fe       	mulpd  %xmm6,%xmm15
    4431:	f3 44 0f 5a 5b f8    	cvtss2sd -0x8(%rbx),%xmm11
    4437:	66 44 0f 59 ed       	mulpd  %xmm5,%xmm13
    443c:	66 45 0f 58 ef       	addpd  %xmm15,%xmm13
    4441:	66 45 0f 28 fb       	movapd %xmm11,%xmm15
    4446:	66 45 0f 14 ff       	unpcklpd %xmm15,%xmm15
    444b:	66 44 0f 59 fc       	mulpd  %xmm4,%xmm15
    4450:	66 45 0f 58 ef       	addpd  %xmm15,%xmm13
    4455:	66 44 0f 28 f9       	movapd %xmm1,%xmm15
    445a:	f2 45 0f 59 fc       	mulsd  %xmm12,%xmm15
    445f:	f2 45 0f 59 e0       	mulsd  %xmm8,%xmm12
    4464:	44 0f 29 6e e0       	movaps %xmm13,-0x20(%rsi)
    4469:	66 44 0f 28 eb       	movapd %xmm3,%xmm13
    446e:	f2 44 0f 59 e8       	mulsd  %xmm0,%xmm13
    4473:	f2 0f 59 c7          	mulsd  %xmm7,%xmm0
    4477:	f2 45 0f 58 ef       	addsd  %xmm15,%xmm13
    447c:	66 44 0f 28 fa       	movapd %xmm2,%xmm15
    4481:	f2 45 0f 59 fb       	mulsd  %xmm11,%xmm15
    4486:	f2 41 0f 58 c4       	addsd  %xmm12,%xmm0
    448b:	f2 45 0f 59 d9       	mulsd  %xmm9,%xmm11
    4490:	f2 45 0f 58 ef       	addsd  %xmm15,%xmm13
    4495:	f2 41 0f 58 c3       	addsd  %xmm11,%xmm0
    449a:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    449f:	f3 44 0f 5a 5b fc    	cvtss2sd -0x4(%rbx),%xmm11
    44a5:	f2 44 0f 11 6e f0    	movsd  %xmm13,-0x10(%rsi)
    44ab:	f2 41 0f 58 c3       	addsd  %xmm11,%xmm0
    44b0:	f2 0f 11 46 f8       	movsd  %xmm0,-0x8(%rsi)
    44b5:	48 39 df             	cmp    %rbx,%rdi
    44b8:	0f 85 39 ff ff ff    	jne    43f7 <ayatsuri_model_instance_evaluate+0x7f7>
    44be:	31 f6                	xor    %esi,%esi
    44c0:	66 0f ef d2          	pxor   %xmm2,%xmm2
    44c4:	eb 33                	jmp    44f9 <ayatsuri_model_instance_evaluate+0x8f9>
    44c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    44cd:	00 00 00 
    44d0:	66 0f 2f d1          	comisd %xmm1,%xmm2
    44d4:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 44dc <ayatsuri_model_instance_evaluate+0x8dc>
    44db:	00 
			44d8: R_X86_64_PC32	.LC33-0x4
    44dc:	77 04                	ja     44e2 <ayatsuri_model_instance_evaluate+0x8e2>
    44de:	41 0f 28 c6          	movaps %xmm14,%xmm0
    44e2:	48 8d 9c 24 30 03 00 	lea    0x330(%rsp),%rbx
    44e9:	00 
    44ea:	f3 0f 11 04 b3       	movss  %xmm0,(%rbx,%rsi,4)
    44ef:	48 83 c6 01          	add    $0x1,%rsi
    44f3:	48 83 fe 0c          	cmp    $0xc,%rsi
    44f7:	74 47                	je     4540 <ayatsuri_model_instance_evaluate+0x940>
    44f9:	f2 41 0f 10 4c f5 00 	movsd  0x0(%r13,%rsi,8),%xmm1
    4500:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 4508 <ayatsuri_model_instance_evaluate+0x908>
    4507:	00 
			4504: R_X86_64_PC32	.LC22-0x4
    4508:	66 0f 28 c1          	movapd %xmm1,%xmm0
    450c:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 4514 <ayatsuri_model_instance_evaluate+0x914>
    4513:	00 
			4510: R_X86_64_PC32	.LC8-0x4
    4514:	66 0f 2e e8          	ucomisd %xmm0,%xmm5
    4518:	0f 82 c2 12 00 00    	jb     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    451e:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 4526 <ayatsuri_model_instance_evaluate+0x926>
    4525:	00 
			4522: R_X86_64_PC32	.LC38-0x4
    4526:	0f 83 b4 12 00 00    	jae    57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    452c:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 4534 <ayatsuri_model_instance_evaluate+0x934>
    4533:	00 
			4530: R_X86_64_PC32	.LC39-0x4
    4534:	77 9a                	ja     44d0 <ayatsuri_model_instance_evaluate+0x8d0>
    4536:	66 0f ef c0          	pxor   %xmm0,%xmm0
    453a:	f2 0f 5a c1          	cvtsd2ss %xmm1,%xmm0
    453e:	eb a2                	jmp    44e2 <ayatsuri_model_instance_evaluate+0x8e2>
    4540:	66 0f 6f 84 24 30 03 	movdqa 0x330(%rsp),%xmm0
    4547:	00 00 
    4549:	41 8b b7 8c 00 00 00 	mov    0x8c(%r15),%esi
    4550:	31 ff                	xor    %edi,%edi
    4552:	0f 29 84 24 b0 02 00 	movaps %xmm0,0x2b0(%rsp)
    4559:	00 
    455a:	83 fe ff             	cmp    $0xffffffff,%esi
    455d:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
    4564:	00 00 
    4566:	40 0f 95 c7          	setne  %dil
    456a:	0f 29 84 24 c0 02 00 	movaps %xmm0,0x2c0(%rsp)
    4571:	00 
    4572:	01 fe                	add    %edi,%esi
    4574:	66 0f 6f 84 24 50 03 	movdqa 0x350(%rsp),%xmm0
    457b:	00 00 
    457d:	41 89 b7 8c 00 00 00 	mov    %esi,0x8c(%r15)
    4584:	0f 29 84 24 d0 02 00 	movaps %xmm0,0x2d0(%rsp)
    458b:	00 
    458c:	8b 40 08             	mov    0x8(%rax),%eax
    458f:	66 0f 6f 84 24 b0 02 	movdqa 0x2b0(%rsp),%xmm0
    4596:	00 00 
    4598:	48 01 c5             	add    %rax,%rbp
    459b:	0f 11 45 00          	movups %xmm0,0x0(%rbp)
    459f:	66 0f 6f 84 24 c0 02 	movdqa 0x2c0(%rsp),%xmm0
    45a6:	00 00 
    45a8:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
    45ac:	66 0f 6f 84 24 d0 02 	movdqa 0x2d0(%rsp),%xmm0
    45b3:	00 00 
    45b5:	0f 11 45 20          	movups %xmm0,0x20(%rbp)
    45b9:	49 8b 47 08          	mov    0x8(%r15),%rax
    45bd:	48 8d 34 10          	lea    (%rax,%rdx,1),%rsi
    45c1:	0f b6 7e 10          	movzbl 0x10(%rsi),%edi
    45c5:	40 84 ff             	test   %dil,%dil
    45c8:	74 17                	je     45e1 <ayatsuri_model_instance_evaluate+0x9e1>
    45ca:	bf 01 00 00 00       	mov    $0x1,%edi
    45cf:	45 85 c9             	test   %r9d,%r9d
    45d2:	78 0d                	js     45e1 <ayatsuri_model_instance_evaluate+0x9e1>
    45d4:	4b 8d 3c 49          	lea    (%r9,%r9,2),%rdi
    45d8:	80 7c f8 11 00       	cmpb   $0x0,0x11(%rax,%rdi,8)
    45dd:	40 0f 95 c7          	setne  %dil
    45e1:	40 88 7e 11          	mov    %dil,0x11(%rsi)
    45e5:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    45eb:	40 80 ff 01          	cmp    $0x1,%dil
    45ef:	0f 84 ab 00 00 00    	je     46a0 <ayatsuri_model_instance_evaluate+0xaa0>
    45f5:	40 80 ff 02          	cmp    $0x2,%dil
    45f9:	0f 84 01 09 00 00    	je     4f00 <ayatsuri_model_instance_evaluate+0x1300>
    45ff:	40 80 ff 03          	cmp    $0x3,%dil
    4603:	0f 84 97 08 00 00    	je     4ea0 <ayatsuri_model_instance_evaluate+0x12a0>
    4609:	40 84 ff             	test   %dil,%dil
    460c:	74 30                	je     463e <ayatsuri_model_instance_evaluate+0xa3e>
    460e:	41 8b 87 90 00 00 00 	mov    0x90(%r15),%eax
    4615:	31 d2                	xor    %edx,%edx
    4617:	83 f8 ff             	cmp    $0xffffffff,%eax
    461a:	0f 95 c2             	setne  %dl
    461d:	01 d0                	add    %edx,%eax
    461f:	31 d2                	xor    %edx,%edx
    4621:	41 89 87 90 00 00 00 	mov    %eax,0x90(%r15)
    4628:	41 8b 87 94 00 00 00 	mov    0x94(%r15),%eax
    462f:	83 f8 ff             	cmp    $0xffffffff,%eax
    4632:	0f 95 c2             	setne  %dl
    4635:	01 d0                	add    %edx,%eax
    4637:	41 89 87 94 00 00 00 	mov    %eax,0x94(%r15)
    463e:	49 8b 07             	mov    (%r15),%rax
    4641:	49 83 c2 01          	add    $0x1,%r10
    4645:	0f b7 50 0c          	movzwl 0xc(%rax),%edx
    4649:	41 39 d2             	cmp    %edx,%r10d
    464c:	0f 82 3e fa ff ff    	jb     4090 <ayatsuri_model_instance_evaluate+0x490>
    4652:	b8 00 01 00 00       	mov    $0x100,%eax
    4657:	66 41 89 87 a5 00 00 	mov    %ax,0xa5(%r15)
    465e:	00 
    465f:	31 c0                	xor    %eax,%eax
    4661:	e9 e9 f6 ff ff       	jmp    3d4f <ayatsuri_model_instance_evaluate+0x14f>
    4666:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    466d:	00 00 00 
    4670:	f3 0f 6f 07          	movdqu (%rdi),%xmm0
    4674:	41 89 f1             	mov    %esi,%r9d
    4677:	31 db                	xor    %ebx,%ebx
    4679:	41 81 c9 00 00 ff ff 	or     $0xffff0000,%r9d
    4680:	41 0f 29 03          	movaps %xmm0,(%r11)
    4684:	f3 0f 6f 47 10       	movdqu 0x10(%rdi),%xmm0
    4689:	41 0f 29 43 10       	movaps %xmm0,0x10(%r11)
    468e:	8b 77 20             	mov    0x20(%rdi),%esi
    4691:	41 89 73 20          	mov    %esi,0x20(%r11)
    4695:	e9 8d fa ff ff       	jmp    4127 <ayatsuri_model_instance_evaluate+0x527>
    469a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    46a0:	4d 8b 37             	mov    (%r15),%r14
    46a3:	45 8b 4e 14          	mov    0x14(%r14),%r9d
    46a7:	49 8b 3e             	mov    (%r14),%rdi
    46aa:	41 8b 6e 24          	mov    0x24(%r14),%ebp
    46ae:	49 01 c9             	add    %rcx,%r9
    46b1:	48 89 3c 24          	mov    %rdi,(%rsp)
    46b5:	49 01 f9             	add    %rdi,%r9
    46b8:	41 0f b7 79 04       	movzwl 0x4(%r9),%edi
    46bd:	45 0f b7 49 08       	movzwl 0x8(%r9),%r9d
    46c2:	8d 3c 7f             	lea    (%rdi,%rdi,2),%edi
    46c5:	c1 e7 02             	shl    $0x2,%edi
    46c8:	48 01 ef             	add    %rbp,%rdi
    46cb:	48 8b 2c 24          	mov    (%rsp),%rbp
    46cf:	48 01 ef             	add    %rbp,%rdi
    46d2:	41 8b 6e 34          	mov    0x34(%r14),%ebp
    46d6:	89 6c 24 30          	mov    %ebp,0x30(%rsp)
    46da:	8b 6e 08             	mov    0x8(%rsi),%ebp
    46dd:	48 01 c5             	add    %rax,%rbp
    46e0:	31 c0                	xor    %eax,%eax
    46e2:	0f 10 4c 05 00       	movups 0x0(%rbp,%rax,1),%xmm1
    46e7:	0f 5a c1             	cvtps2pd %xmm1,%xmm0
    46ea:	41 0f 29 44 45 00    	movaps %xmm0,0x0(%r13,%rax,2)
    46f0:	66 0f ef c0          	pxor   %xmm0,%xmm0
    46f4:	0f 12 c1             	movhlps %xmm1,%xmm0
    46f7:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
    46fa:	41 0f 29 44 45 10    	movaps %xmm0,0x10(%r13,%rax,2)
    4700:	48 83 c0 10          	add    $0x10,%rax
    4704:	48 83 f8 30          	cmp    $0x30,%rax
    4708:	75 d8                	jne    46e2 <ayatsuri_model_instance_evaluate+0xae2>
    470a:	f2 44 0f 10 bc 24 98 	movsd  0x398(%rsp),%xmm15
    4711:	03 00 00 
    4714:	f3 0f 7e 07          	movq   (%rdi),%xmm0
    4718:	f2 0f 10 ac 24 c0 03 	movsd  0x3c0(%rsp),%xmm5
    471f:	00 00 
    4721:	f2 44 0f 10 8c 24 b8 	movsd  0x3b8(%rsp),%xmm9
    4728:	03 00 00 
    472b:	f2 44 0f 10 84 24 b0 	movsd  0x3b0(%rsp),%xmm8
    4732:	03 00 00 
    4735:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
    4738:	66 0f 28 f8          	movapd %xmm0,%xmm7
    473c:	66 0f 28 c8          	movapd %xmm0,%xmm1
    4740:	66 0f 15 ff          	unpckhpd %xmm7,%xmm7
    4744:	f2 0f 11 6c 24 40    	movsd  %xmm5,0x40(%rsp)
    474a:	f2 44 0f 10 ac 24 90 	movsd  0x390(%rsp),%xmm13
    4751:	03 00 00 
    4754:	66 0f 28 d7          	movapd %xmm7,%xmm2
    4758:	0f 29 84 24 e0 02 00 	movaps %xmm0,0x2e0(%rsp)
    475f:	00 
    4760:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4764:	f2 44 0f 59 ff       	mulsd  %xmm7,%xmm15
    4769:	f3 0f 5a 47 08       	cvtss2sd 0x8(%rdi),%xmm0
    476e:	f2 0f 10 bc 24 a0 03 	movsd  0x3a0(%rsp),%xmm7
    4775:	00 00 
    4777:	f2 0f 11 84 24 f0 02 	movsd  %xmm0,0x2f0(%rsp)
    477e:	00 00 
    4780:	f2 44 0f 59 ca       	mulsd  %xmm2,%xmm9
    4785:	f2 0f 11 7c 24 38    	movsd  %xmm7,0x38(%rsp)
    478b:	f2 44 0f 59 c1       	mulsd  %xmm1,%xmm8
    4790:	66 0f 28 f7          	movapd %xmm7,%xmm6
    4794:	66 0f 28 fd          	movapd %xmm5,%xmm7
    4798:	f2 0f 10 ac 24 e0 03 	movsd  0x3e0(%rsp),%xmm5
    479f:	00 00 
    47a1:	f2 0f 59 f8          	mulsd  %xmm0,%xmm7
    47a5:	f2 0f 59 f0          	mulsd  %xmm0,%xmm6
    47a9:	f2 0f 59 94 24 d8 03 	mulsd  0x3d8(%rsp),%xmm2
    47b0:	00 00 
    47b2:	f2 0f 11 6c 24 48    	movsd  %xmm5,0x48(%rsp)
    47b8:	f2 0f 59 c5          	mulsd  %xmm5,%xmm0
    47bc:	66 41 0f 28 e9       	movapd %xmm9,%xmm5
    47c1:	f2 44 0f 59 e9       	mulsd  %xmm1,%xmm13
    47c6:	66 45 0f 28 e0       	movapd %xmm8,%xmm12
    47cb:	66 41 0f 28 e0       	movapd %xmm8,%xmm4
    47d0:	f2 0f 59 8c 24 d0 03 	mulsd  0x3d0(%rsp),%xmm1
    47d7:	00 00 
    47d9:	66 0f 28 df          	movapd %xmm7,%xmm3
    47dd:	66 44 0f 28 df       	movapd %xmm7,%xmm11
    47e2:	f2 0f 59 da          	mulsd  %xmm2,%xmm3
    47e6:	f2 0f 59 e8          	mulsd  %xmm0,%xmm5
    47ea:	f2 44 0f 59 e0       	mulsd  %xmm0,%xmm12
    47ef:	f2 44 0f 59 d9       	mulsd  %xmm1,%xmm11
    47f4:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    47f8:	f2 0f 5c eb          	subsd  %xmm3,%xmm5
    47fc:	66 41 0f 28 d9       	movapd %xmm9,%xmm3
    4801:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
    4805:	f2 44 0f 11 64 24 20 	movsd  %xmm12,0x20(%rsp)
    480c:	f2 45 0f 5c e3       	subsd  %xmm11,%xmm12
    4811:	66 44 0f 28 d4       	movapd %xmm4,%xmm10
    4816:	f2 0f 10 25 00 00 00 	movsd  0x0(%rip),%xmm4        # 481e <ayatsuri_model_instance_evaluate+0xc1e>
    481d:	00 
			481a: R_X86_64_PC32	.LC22-0x4
    481e:	f2 45 0f 59 e7       	mulsd  %xmm15,%xmm12
    4823:	f2 44 0f 5c d3       	subsd  %xmm3,%xmm10
    4828:	66 41 0f 28 dd       	movapd %xmm13,%xmm3
    482d:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    4831:	f2 41 0f 5c dc       	subsd  %xmm12,%xmm3
    4836:	66 44 0f 28 e6       	movapd %xmm6,%xmm12
    483b:	f2 45 0f 59 e2       	mulsd  %xmm10,%xmm12
    4840:	f2 41 0f 58 dc       	addsd  %xmm12,%xmm3
    4845:	66 44 0f 28 e3       	movapd %xmm3,%xmm12
    484a:	66 44 0f 54 25 00 00 	andpd  0x0(%rip),%xmm12        # 4853 <ayatsuri_model_instance_evaluate+0xc53>
    4851:	00 00 
			484f: R_X86_64_PC32	.LC8-0x4
    4853:	66 41 0f 2e e4       	ucomisd %xmm12,%xmm4
    4858:	0f 82 82 0f 00 00    	jb     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    485e:	f2 0f 10 25 00 00 00 	movsd  0x0(%rip),%xmm4        # 4866 <ayatsuri_model_instance_evaluate+0xc66>
    4865:	00 
			4862: R_X86_64_PC32	.LC40-0x4
    4866:	66 41 0f 2f e4       	comisd %xmm12,%xmm4
    486b:	0f 87 6f 0f 00 00    	ja     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    4871:	f2 44 0f 5c 5c 24 20 	subsd  0x20(%rsp),%xmm11
    4878:	66 44 0f 28 e3       	movapd %xmm3,%xmm12
    487d:	66 41 0f 28 e2       	movapd %xmm10,%xmm4
    4882:	31 c0                	xor    %eax,%eax
    4884:	66 45 0f 14 e4       	unpcklpd %xmm12,%xmm12
    4889:	66 41 0f 14 eb       	unpcklpd %xmm11,%xmm5
    488e:	66 44 0f 28 de       	movapd %xmm6,%xmm11
    4893:	66 41 0f 5e ec       	divpd  %xmm12,%xmm5
    4898:	f2 44 0f 59 da       	mulsd  %xmm2,%xmm11
    489d:	f2 41 0f 59 d5       	mulsd  %xmm13,%xmm2
    48a2:	0f 29 ac 24 30 03 00 	movaps %xmm5,0x330(%rsp)
    48a9:	00 
    48aa:	66 41 0f 28 ef       	movapd %xmm15,%xmm5
    48af:	f2 0f 59 e8          	mulsd  %xmm0,%xmm5
    48b3:	f2 41 0f 59 c5       	mulsd  %xmm13,%xmm0
    48b8:	f2 44 0f 5c dd       	subsd  %xmm5,%xmm11
    48bd:	66 41 0f 14 e3       	unpcklpd %xmm11,%xmm4
    48c2:	66 41 0f 5e e4       	divpd  %xmm12,%xmm4
    48c7:	0f 29 a4 24 40 03 00 	movaps %xmm4,0x340(%rsp)
    48ce:	00 
    48cf:	66 0f 28 e6          	movapd %xmm6,%xmm4
    48d3:	f2 0f 59 e1          	mulsd  %xmm1,%xmm4
    48d7:	f2 41 0f 59 cf       	mulsd  %xmm15,%xmm1
    48dc:	f2 0f 5c c4          	subsd  %xmm4,%xmm0
    48e0:	f2 0f 5c ca          	subsd  %xmm2,%xmm1
    48e4:	66 0f 14 c1          	unpcklpd %xmm1,%xmm0
    48e8:	66 0f 28 ce          	movapd %xmm6,%xmm1
    48ec:	66 41 0f 5e c4       	divpd  %xmm12,%xmm0
    48f1:	f2 41 0f 59 c9       	mulsd  %xmm9,%xmm1
    48f6:	f2 41 0f 59 f0       	mulsd  %xmm8,%xmm6
    48fb:	0f 29 84 24 50 03 00 	movaps %xmm0,0x350(%rsp)
    4902:	00 
    4903:	66 41 0f 28 c7       	movapd %xmm15,%xmm0
    4908:	f2 0f 59 c7          	mulsd  %xmm7,%xmm0
    490c:	f2 41 0f 59 fd       	mulsd  %xmm13,%xmm7
    4911:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    4915:	66 41 0f 28 cf       	movapd %xmm15,%xmm1
    491a:	f2 0f 5c f7          	subsd  %xmm7,%xmm6
    491e:	f2 41 0f 59 c8       	mulsd  %xmm8,%xmm1
    4923:	66 0f 14 c6          	unpcklpd %xmm6,%xmm0
    4927:	66 41 0f 5e c4       	divpd  %xmm12,%xmm0
    492c:	0f 29 84 24 60 03 00 	movaps %xmm0,0x360(%rsp)
    4933:	00 
    4934:	66 41 0f 28 c5       	movapd %xmm13,%xmm0
    4939:	f2 41 0f 59 c1       	mulsd  %xmm9,%xmm0
    493e:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    4942:	f2 0f 5e c3          	divsd  %xmm3,%xmm0
    4946:	f2 0f 11 84 24 70 03 	movsd  %xmm0,0x370(%rsp)
    494d:	00 00 
    494f:	f2 0f 10 0c 43       	movsd  (%rbx,%rax,2),%xmm1
    4954:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 495c <ayatsuri_model_instance_evaluate+0xd5c>
    495b:	00 
			4958: R_X86_64_PC32	.LC22-0x4
    495c:	66 0f 28 c1          	movapd %xmm1,%xmm0
    4960:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 4968 <ayatsuri_model_instance_evaluate+0xd68>
    4967:	00 
			4964: R_X86_64_PC32	.LC8-0x4
    4968:	66 0f 2e f8          	ucomisd %xmm0,%xmm7
    496c:	0f 82 6e 0e 00 00    	jb     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    4972:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 497a <ayatsuri_model_instance_evaluate+0xd7a>
    4979:	00 
			4976: R_X86_64_PC32	.LC38-0x4
    497a:	0f 83 60 0e 00 00    	jae    57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    4980:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 4988 <ayatsuri_model_instance_evaluate+0xd88>
    4987:	00 
			4984: R_X86_64_PC32	.LC39-0x4
    4988:	0f 86 f5 13 00 00    	jbe    5d83 <ayatsuri_model_instance_evaluate+0x2183>
    498e:	66 0f ef d2          	pxor   %xmm2,%xmm2
    4992:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 499a <ayatsuri_model_instance_evaluate+0xd9a>
    4999:	00 
			4996: R_X86_64_PC32	.LC33-0x4
    499a:	66 0f 2f d1          	comisd %xmm1,%xmm2
    499e:	77 04                	ja     49a4 <ayatsuri_model_instance_evaluate+0xda4>
    49a0:	41 0f 28 c6          	movaps %xmm14,%xmm0
    49a4:	f3 0f 11 84 05 80 00 	movss  %xmm0,0x80(%rbp,%rax,1)
    49ab:	00 00 
    49ad:	48 83 c0 04          	add    $0x4,%rax
    49b1:	48 83 f8 24          	cmp    $0x24,%rax
    49b5:	75 98                	jne    494f <ayatsuri_model_instance_evaluate+0xd4f>
    49b7:	48 89 54 24 50       	mov    %rdx,0x50(%rsp)
    49bc:	48 8d 84 24 e0 02 00 	lea    0x2e0(%rsp),%rax
    49c3:	00 
    49c4:	66 0f ef c9          	pxor   %xmm1,%xmm1
    49c8:	31 ff                	xor    %edi,%edi
    49ca:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
    49cf:	4c 89 e8             	mov    %r13,%rax
    49d2:	f3 41 0f 5a 4f 40    	cvtss2sd 0x40(%r15),%xmm1
    49d8:	f2 0f 10 30          	movsd  (%rax),%xmm6
    49dc:	f2 0f 10 68 20       	movsd  0x20(%rax),%xmm5
    49e1:	66 0f ef c0          	pxor   %xmm0,%xmm0
    49e5:	66 0f ef db          	pxor   %xmm3,%xmm3
    49e9:	f3 0f 5a 84 24 e4 01 	cvtss2sd 0x1e4(%rsp),%xmm0
    49f0:	00 00 
    49f2:	f2 0f 10 60 40       	movsd  0x40(%rax),%xmm4
    49f7:	f3 0f 5a 9c 24 e8 01 	cvtss2sd 0x1e8(%rsp),%xmm3
    49fe:	00 00 
    4a00:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
    4a05:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    4a09:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 4a11 <ayatsuri_model_instance_evaluate+0xe11>
    4a10:	00 
			4a0d: R_X86_64_PC32	.LC22-0x4
    4a11:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
    4a15:	f2 0f 10 14 7a       	movsd  (%rdx,%rdi,2),%xmm2
    4a1a:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    4a1e:	66 0f ef db          	pxor   %xmm3,%xmm3
    4a22:	f3 0f 5a 9c 24 ec 01 	cvtss2sd 0x1ec(%rsp),%xmm3
    4a29:	00 00 
    4a2b:	f2 0f 59 dc          	mulsd  %xmm4,%xmm3
    4a2f:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    4a33:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    4a37:	f2 0f 59 c2          	mulsd  %xmm2,%xmm0
    4a3b:	66 0f 28 d8          	movapd %xmm0,%xmm3
    4a3f:	66 0f 54 1d 00 00 00 	andpd  0x0(%rip),%xmm3        # 4a47 <ayatsuri_model_instance_evaluate+0xe47>
    4a46:	00 
			4a43: R_X86_64_PC32	.LC8-0x4
    4a47:	66 0f 2e fb          	ucomisd %xmm3,%xmm7
    4a4b:	0f 82 8f 0d 00 00    	jb     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    4a51:	66 0f 2f 1d 00 00 00 	comisd 0x0(%rip),%xmm3        # 4a59 <ayatsuri_model_instance_evaluate+0xe59>
    4a58:	00 
			4a55: R_X86_64_PC32	.LC38-0x4
    4a59:	0f 83 81 0d 00 00    	jae    57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    4a5f:	66 0f 2f 1d 00 00 00 	comisd 0x0(%rip),%xmm3        # 4a67 <ayatsuri_model_instance_evaluate+0xe67>
    4a66:	00 
			4a63: R_X86_64_PC32	.LC39-0x4
    4a67:	0f 86 3a 13 00 00    	jbe    5da7 <ayatsuri_model_instance_evaluate+0x21a7>
    4a6d:	66 0f ef db          	pxor   %xmm3,%xmm3
    4a71:	66 0f 2f d8          	comisd %xmm0,%xmm3
    4a75:	0f 87 35 13 00 00    	ja     5db0 <ayatsuri_model_instance_evaluate+0x21b0>
    4a7b:	41 0f 28 c6          	movaps %xmm14,%xmm0
    4a7f:	f3 0f 11 44 3d 60    	movss  %xmm0,0x60(%rbp,%rdi,1)
    4a85:	66 0f ef db          	pxor   %xmm3,%xmm3
    4a89:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4a8d:	f3 0f 5a 84 24 d8 01 	cvtss2sd 0x1d8(%rsp),%xmm0
    4a94:	00 00 
    4a96:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
    4a9a:	f3 0f 5a 9c 24 dc 01 	cvtss2sd 0x1dc(%rsp),%xmm3
    4aa1:	00 00 
    4aa3:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 4aab <ayatsuri_model_instance_evaluate+0xeab>
    4aaa:	00 
			4aa7: R_X86_64_PC32	.LC22-0x4
    4aab:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    4aaf:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    4ab3:	66 0f ef db          	pxor   %xmm3,%xmm3
    4ab7:	f3 0f 5a 9c 24 e0 01 	cvtss2sd 0x1e0(%rsp),%xmm3
    4abe:	00 00 
    4ac0:	f2 0f 59 dc          	mulsd  %xmm4,%xmm3
    4ac4:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    4ac8:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    4acc:	f2 0f 59 c2          	mulsd  %xmm2,%xmm0
    4ad0:	66 0f 28 d0          	movapd %xmm0,%xmm2
    4ad4:	66 0f 54 15 00 00 00 	andpd  0x0(%rip),%xmm2        # 4adc <ayatsuri_model_instance_evaluate+0xedc>
    4adb:	00 
			4ad8: R_X86_64_PC32	.LC8-0x4
    4adc:	66 0f 2e f2          	ucomisd %xmm2,%xmm6
    4ae0:	0f 82 fa 0c 00 00    	jb     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    4ae6:	66 0f 2f 15 00 00 00 	comisd 0x0(%rip),%xmm2        # 4aee <ayatsuri_model_instance_evaluate+0xeee>
    4aed:	00 
			4aea: R_X86_64_PC32	.LC38-0x4
    4aee:	0f 83 ec 0c 00 00    	jae    57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    4af4:	66 0f 2f 15 00 00 00 	comisd 0x0(%rip),%xmm2        # 4afc <ayatsuri_model_instance_evaluate+0xefc>
    4afb:	00 
			4af8: R_X86_64_PC32	.LC39-0x4
    4afc:	0f 86 bb 12 00 00    	jbe    5dbd <ayatsuri_model_instance_evaluate+0x21bd>
    4b02:	66 0f ef d2          	pxor   %xmm2,%xmm2
    4b06:	66 0f 2f d0          	comisd %xmm0,%xmm2
    4b0a:	0f 87 c6 16 00 00    	ja     61d6 <ayatsuri_model_instance_evaluate+0x25d6>
    4b10:	41 0f 28 c6          	movaps %xmm14,%xmm0
    4b14:	f3 0f 11 44 3d 70    	movss  %xmm0,0x70(%rbp,%rdi,1)
    4b1a:	48 83 c7 04          	add    $0x4,%rdi
    4b1e:	48 83 c0 08          	add    $0x8,%rax
    4b22:	48 83 ff 0c          	cmp    $0xc,%rdi
    4b26:	0f 85 ac fe ff ff    	jne    49d8 <ayatsuri_model_instance_evaluate+0xdd8>
    4b2c:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4b30:	66 0f ef ed          	pxor   %xmm5,%xmm5
    4b34:	f2 0f 10 a4 24 a8 03 	movsd  0x3a8(%rsp),%xmm4
    4b3b:	00 00 
    4b3d:	f2 0f 10 9c 24 c8 03 	movsd  0x3c8(%rsp),%xmm3
    4b44:	00 00 
    4b46:	f3 41 0f 5a 47 34    	cvtss2sd 0x34(%r15),%xmm0
    4b4c:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 4b54 <ayatsuri_model_instance_evaluate+0xf54>
    4b53:	00 
			4b50: R_X86_64_PC32	.LC22-0x4
    4b54:	f2 0f 10 94 24 e8 03 	movsd  0x3e8(%rsp),%xmm2
    4b5b:	00 00 
    4b5d:	f3 0f 5a ac 24 e8 01 	cvtss2sd 0x1e8(%rsp),%xmm5
    4b64:	00 00 
    4b66:	f2 0f 5c e0          	subsd  %xmm0,%xmm4
    4b6a:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4b6e:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
    4b73:	f3 41 0f 5a 47 38    	cvtss2sd 0x38(%r15),%xmm0
    4b79:	f2 0f 5c d8          	subsd  %xmm0,%xmm3
    4b7d:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4b81:	f3 41 0f 5a 47 3c    	cvtss2sd 0x3c(%r15),%xmm0
    4b87:	f2 0f 5c d0          	subsd  %xmm0,%xmm2
    4b8b:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4b8f:	f3 0f 5a 84 24 e4 01 	cvtss2sd 0x1e4(%rsp),%xmm0
    4b96:	00 00 
    4b98:	f2 0f 59 c4          	mulsd  %xmm4,%xmm0
    4b9c:	f2 0f 59 eb          	mulsd  %xmm3,%xmm5
    4ba0:	f2 0f 58 c5          	addsd  %xmm5,%xmm0
    4ba4:	66 0f ef ed          	pxor   %xmm5,%xmm5
    4ba8:	f3 0f 5a ac 24 ec 01 	cvtss2sd 0x1ec(%rsp),%xmm5
    4baf:	00 00 
    4bb1:	f2 0f 59 ea          	mulsd  %xmm2,%xmm5
    4bb5:	f2 0f 58 c5          	addsd  %xmm5,%xmm0
    4bb9:	66 0f ef ed          	pxor   %xmm5,%xmm5
    4bbd:	f3 41 0f 5a 6f 44    	cvtss2sd 0x44(%r15),%xmm5
    4bc3:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    4bc7:	f2 0f 58 c5          	addsd  %xmm5,%xmm0
    4bcb:	66 0f 28 e8          	movapd %xmm0,%xmm5
    4bcf:	66 0f 54 2d 00 00 00 	andpd  0x0(%rip),%xmm5        # 4bd7 <ayatsuri_model_instance_evaluate+0xfd7>
    4bd6:	00 
			4bd3: R_X86_64_PC32	.LC8-0x4
    4bd7:	66 0f 2e f5          	ucomisd %xmm5,%xmm6
    4bdb:	0f 82 ff 0b 00 00    	jb     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    4be1:	66 0f 2f 2d 00 00 00 	comisd 0x0(%rip),%xmm5        # 4be9 <ayatsuri_model_instance_evaluate+0xfe9>
    4be8:	00 
			4be5: R_X86_64_PC32	.LC38-0x4
    4be9:	0f 83 f1 0b 00 00    	jae    57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    4bef:	66 0f 2f 2d 00 00 00 	comisd 0x0(%rip),%xmm5        # 4bf7 <ayatsuri_model_instance_evaluate+0xff7>
    4bf6:	00 
			4bf3: R_X86_64_PC32	.LC39-0x4
    4bf7:	0f 86 c9 11 00 00    	jbe    5dc6 <ayatsuri_model_instance_evaluate+0x21c6>
    4bfd:	66 0f ef ed          	pxor   %xmm5,%xmm5
    4c01:	66 0f 2f e8          	comisd %xmm0,%xmm5
    4c05:	0f 87 2c 15 00 00    	ja     6137 <ayatsuri_model_instance_evaluate+0x2537>
    4c0b:	41 0f 28 c6          	movaps %xmm14,%xmm0
    4c0f:	f3 0f 11 45 6c       	movss  %xmm0,0x6c(%rbp)
    4c14:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4c18:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 4c20 <ayatsuri_model_instance_evaluate+0x1020>
    4c1f:	00 
			4c1c: R_X86_64_PC32	.LC22-0x4
    4c20:	f3 0f 5a 84 24 d8 01 	cvtss2sd 0x1d8(%rsp),%xmm0
    4c27:	00 00 
    4c29:	f2 0f 59 c4          	mulsd  %xmm4,%xmm0
    4c2d:	66 0f ef e4          	pxor   %xmm4,%xmm4
    4c31:	f3 0f 5a a4 24 dc 01 	cvtss2sd 0x1dc(%rsp),%xmm4
    4c38:	00 00 
    4c3a:	f2 0f 59 dc          	mulsd  %xmm4,%xmm3
    4c3e:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    4c42:	66 0f ef db          	pxor   %xmm3,%xmm3
    4c46:	f3 0f 5a 9c 24 e0 01 	cvtss2sd 0x1e0(%rsp),%xmm3
    4c4d:	00 00 
    4c4f:	f2 0f 59 d3          	mulsd  %xmm3,%xmm2
    4c53:	f2 0f 58 c2          	addsd  %xmm2,%xmm0
    4c57:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    4c5b:	66 0f ef c9          	pxor   %xmm1,%xmm1
    4c5f:	f3 41 0f 5a 4f 48    	cvtss2sd 0x48(%r15),%xmm1
    4c65:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    4c69:	66 0f 28 c8          	movapd %xmm0,%xmm1
    4c6d:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 4c75 <ayatsuri_model_instance_evaluate+0x1075>
    4c74:	00 
			4c71: R_X86_64_PC32	.LC8-0x4
    4c75:	66 0f 2e f1          	ucomisd %xmm1,%xmm6
    4c79:	0f 82 61 0b 00 00    	jb     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    4c7f:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 4c87 <ayatsuri_model_instance_evaluate+0x1087>
    4c86:	00 
			4c83: R_X86_64_PC32	.LC38-0x4
    4c87:	0f 83 53 0b 00 00    	jae    57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    4c8d:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 4c95 <ayatsuri_model_instance_evaluate+0x1095>
    4c94:	00 
			4c91: R_X86_64_PC32	.LC39-0x4
    4c95:	0f 86 55 15 00 00    	jbe    61f0 <ayatsuri_model_instance_evaluate+0x25f0>
    4c9b:	66 0f ef c9          	pxor   %xmm1,%xmm1
    4c9f:	66 0f 2f c8          	comisd %xmm0,%xmm1
    4ca3:	0f 87 3a 15 00 00    	ja     61e3 <ayatsuri_model_instance_evaluate+0x25e3>
    4ca9:	41 0f 28 c6          	movaps %xmm14,%xmm0
    4cad:	41 0f b7 f9          	movzwl %r9w,%edi
    4cb1:	8b 44 24 30          	mov    0x30(%rsp),%eax
    4cb5:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
    4cba:	48 6b ff 48          	imul   $0x48,%rdi,%rdi
    4cbe:	48 8b 0c 24          	mov    (%rsp),%rcx
    4cc2:	f3 0f 11 45 7c       	movss  %xmm0,0x7c(%rbp)
    4cc7:	4c 89 9c 24 90 00 00 	mov    %r11,0x90(%rsp)
    4cce:	00 
    4ccf:	4c 89 54 24 70       	mov    %r10,0x70(%rsp)
    4cd4:	48 01 f8             	add    %rdi,%rax
    4cd7:	8b 7e 0c             	mov    0xc(%rsi),%edi
    4cda:	48 89 54 24 68       	mov    %rdx,0x68(%rsp)
    4cdf:	48 01 c1             	add    %rax,%rcx
    4ce2:	4c 89 44 24 60       	mov    %r8,0x60(%rsp)
    4ce7:	48 89 0c 24          	mov    %rcx,(%rsp)
    4ceb:	e8 70 b4 ff ff       	call   160 <pack_rgb>
    4cf0:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 4cf8 <ayatsuri_model_instance_evaluate+0x10f8>
    4cf7:	00 
			4cf4: R_X86_64_PC32	.LC5-0x4
    4cf8:	f2 0f 59 06          	mulsd  (%rsi),%xmm0
    4cfc:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 4d04 <ayatsuri_model_instance_evaluate+0x1104>
    4d03:	00 
			4d00: R_X86_64_PC32	.LC6-0x4
    4d04:	66 89 44 24 20       	mov    %ax,0x20(%rsp)
    4d09:	e8 00 00 00 00       	call   4d0e <ayatsuri_model_instance_evaluate+0x110e>
			4d0a: R_X86_64_PLT32	floor-0x4
    4d0e:	48 8b 0c 24          	mov    (%rsp),%rcx
    4d12:	f2 0f 11 44 24 50    	movsd  %xmm0,0x50(%rsp)
    4d18:	48 8d 79 30          	lea    0x30(%rcx),%rdi
    4d1c:	e8 df b2 ff ff       	call   0 <md>
    4d21:	f2 0f 10 4c 24 40    	movsd  0x40(%rsp),%xmm1
    4d27:	f2 0f 11 44 24 30    	movsd  %xmm0,0x30(%rsp)
    4d2d:	f2 0f 10 44 24 38    	movsd  0x38(%rsp),%xmm0
    4d33:	e8 00 00 00 00       	call   4d38 <ayatsuri_model_instance_evaluate+0x1138>
			4d34: R_X86_64_PLT32	hypot-0x4
    4d38:	f2 0f 10 4c 24 48    	movsd  0x48(%rsp),%xmm1
    4d3e:	e8 00 00 00 00       	call   4d43 <ayatsuri_model_instance_evaluate+0x1143>
			4d3f: R_X86_64_PLT32	hypot-0x4
    4d43:	f2 0f 59 44 24 30    	mulsd  0x30(%rsp),%xmm0
    4d49:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 4d51 <ayatsuri_model_instance_evaluate+0x1151>
    4d50:	00 
			4d4d: R_X86_64_PC32	.LC9-0x4
    4d51:	e8 00 00 00 00       	call   4d56 <ayatsuri_model_instance_evaluate+0x1156>
			4d52: R_X86_64_PLT32	fmin-0x4
    4d56:	f2 0f 59 05 00 00 00 	mulsd  0x0(%rip),%xmm0        # 4d5e <ayatsuri_model_instance_evaluate+0x115e>
    4d5d:	00 
			4d5a: R_X86_64_PC32	.LC5-0x4
    4d5e:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 4d66 <ayatsuri_model_instance_evaluate+0x1166>
    4d65:	00 
			4d62: R_X86_64_PC32	.LC6-0x4
    4d66:	e8 00 00 00 00       	call   4d6b <ayatsuri_model_instance_evaluate+0x116b>
			4d67: R_X86_64_PLT32	floor-0x4
    4d6b:	f2 0f 10 54 24 50    	movsd  0x50(%rsp),%xmm2
    4d71:	48 8b 0c 24          	mov    (%rsp),%rcx
    4d75:	66 c7 85 f0 00 00 00 	movw   $0x0,0xf0(%rbp)
    4d7c:	00 00 
    4d7e:	48 c7 85 d4 00 00 00 	movq   $0x3f800000,0xd4(%rbp)
    4d85:	00 00 80 3f 
    4d89:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    4d8d:	0f 28 05 00 00 00 00 	movaps 0x0(%rip),%xmm0        # 4d94 <ayatsuri_model_instance_evaluate+0x1194>
			4d90: R_X86_64_PC32	.LC41-0x4
    4d94:	f2 0f 2c f2          	cvttsd2si %xmm2,%esi
    4d98:	48 8d 79 40          	lea    0x40(%rcx),%rdi
    4d9c:	0f 11 85 c4 00 00 00 	movups %xmm0,0xc4(%rbp)
    4da3:	0f b7 c0             	movzwl %ax,%eax
    4da6:	0f b7 f6             	movzwl %si,%esi
    4da9:	48 c1 e0 10          	shl    $0x10,%rax
    4dad:	48 09 f0             	or     %rsi,%rax
    4db0:	0f b7 74 24 20       	movzwl 0x20(%rsp),%esi
    4db5:	48 c1 e0 10          	shl    $0x10,%rax
    4db9:	48 09 f0             	or     %rsi,%rax
    4dbc:	48 c1 e0 10          	shl    $0x10,%rax
    4dc0:	48 09 f0             	or     %rsi,%rax
    4dc3:	48 89 85 e8 00 00 00 	mov    %rax,0xe8(%rbp)
    4dca:	e8 31 b2 ff ff       	call   0 <md>
    4dcf:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 4dd7 <ayatsuri_model_instance_evaluate+0x11d7>
    4dd6:	00 
			4dd3: R_X86_64_PC32	.LC22-0x4
    4dd7:	66 0f 28 c8          	movapd %xmm0,%xmm1
    4ddb:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 4de3 <ayatsuri_model_instance_evaluate+0x11e3>
    4de2:	00 
			4ddf: R_X86_64_PC32	.LC8-0x4
    4de3:	66 0f 2e f1          	ucomisd %xmm1,%xmm6
    4de7:	0f 82 f3 09 00 00    	jb     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    4ded:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 4df5 <ayatsuri_model_instance_evaluate+0x11f5>
    4df4:	00 
			4df1: R_X86_64_PC32	.LC38-0x4
    4df5:	0f 83 e5 09 00 00    	jae    57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    4dfb:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 4e03 <ayatsuri_model_instance_evaluate+0x1203>
    4e02:	00 
			4dff: R_X86_64_PC32	.LC39-0x4
    4e03:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
    4e08:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 4e11 <ayatsuri_model_instance_evaluate+0x1211>
    4e0f:	00 00 
			4e0d: R_X86_64_PC32	.LC0-0x4
    4e11:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
    4e16:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
    4e1b:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 4e24 <ayatsuri_model_instance_evaluate+0x1224>
    4e22:	00 00 
			4e20: R_X86_64_PC32	.LC1-0x4
    4e24:	4c 8b 54 24 70       	mov    0x70(%rsp),%r10
    4e29:	4c 8b 9c 24 90 00 00 	mov    0x90(%rsp),%r11
    4e30:	00 
    4e31:	0f 86 89 13 00 00    	jbe    61c0 <ayatsuri_model_instance_evaluate+0x25c0>
    4e37:	66 0f ef c9          	pxor   %xmm1,%xmm1
    4e3b:	66 0f 2f c8          	comisd %xmm0,%xmm1
    4e3f:	0f 87 6e 13 00 00    	ja     61b3 <ayatsuri_model_instance_evaluate+0x25b3>
    4e45:	41 0f 28 c6          	movaps %xmm14,%xmm0
    4e49:	45 8b 4e 50          	mov    0x50(%r14),%r9d
    4e4d:	b8 7f 00 00 00       	mov    $0x7f,%eax
    4e52:	f3 0f 11 85 dc 00 00 	movss  %xmm0,0xdc(%rbp)
    4e59:	00 
    4e5a:	31 ff                	xor    %edi,%edi
    4e5c:	48 c1 e0 37          	shl    $0x37,%rax
    4e60:	48 89 85 e0 00 00 00 	mov    %rax,0xe0(%rbp)
    4e67:	44 89 0c 24          	mov    %r9d,(%rsp)
    4e6b:	8b 04 24             	mov    (%rsp),%eax
    4e6e:	39 c7                	cmp    %eax,%edi
    4e70:	0f 84 1f 0a 00 00    	je     5895 <ayatsuri_model_instance_evaluate+0x1c95>
    4e76:	41 8b 76 4c          	mov    0x4c(%r14),%esi
    4e7a:	89 f8                	mov    %edi,%eax
    4e7c:	44 8b 4c 24 18       	mov    0x18(%rsp),%r9d
    4e81:	c1 e0 05             	shl    $0x5,%eax
    4e84:	48 01 c6             	add    %rax,%rsi
    4e87:	49 03 36             	add    (%r14),%rsi
    4e8a:	0f b7 06             	movzwl (%rsi),%eax
    4e8d:	44 39 c8             	cmp    %r9d,%eax
    4e90:	0f 84 c8 12 00 00    	je     615e <ayatsuri_model_instance_evaluate+0x255e>
    4e96:	83 c7 01             	add    $0x1,%edi
    4e99:	eb d0                	jmp    4e6b <ayatsuri_model_instance_evaluate+0x126b>
    4e9b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    4ea0:	8b 74 24 18          	mov    0x18(%rsp),%esi
    4ea4:	45 31 c9             	xor    %r9d,%r9d
    4ea7:	4c 89 ff             	mov    %r15,%rdi
    4eaa:	4c 89 5c 24 20       	mov    %r11,0x20(%rsp)
    4eaf:	48 8b 8c 24 78 01 00 	mov    0x178(%rsp),%rcx
    4eb6:	00 
    4eb7:	48 8b 94 24 80 01 00 	mov    0x180(%rsp),%rdx
    4ebe:	00 
    4ebf:	4c 8d 84 24 c8 01 00 	lea    0x1c8(%rsp),%r8
    4ec6:	00 
    4ec7:	4c 89 14 24          	mov    %r10,(%rsp)
    4ecb:	e8 30 b9 ff ff       	call   800 <mesh_packet>
    4ed0:	84 c0                	test   %al,%al
    4ed2:	0f 84 08 09 00 00    	je     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    4ed8:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    4ede:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
    4ee3:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 4eec <ayatsuri_model_instance_evaluate+0x12ec>
    4eea:	00 00 
			4ee8: R_X86_64_PC32	.LC0-0x4
    4eec:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 4ef5 <ayatsuri_model_instance_evaluate+0x12f5>
    4ef3:	00 00 
			4ef1: R_X86_64_PC32	.LC1-0x4
    4ef5:	4c 8b 14 24          	mov    (%rsp),%r10
    4ef9:	e9 0b f7 ff ff       	jmp    4609 <ayatsuri_model_instance_evaluate+0xa09>
    4efe:	66 90                	xchg   %ax,%ax
    4f00:	4d 8b 37             	mov    (%r15),%r14
    4f03:	49 8b 6f 08          	mov    0x8(%r15),%rbp
    4f07:	41 8b 46 14          	mov    0x14(%r14),%eax
    4f0b:	49 8b 3e             	mov    (%r14),%rdi
    4f0e:	48 01 c8             	add    %rcx,%rax
    4f11:	48 89 bc 24 b8 00 00 	mov    %rdi,0xb8(%rsp)
    4f18:	00 
    4f19:	4c 8d 0c 07          	lea    (%rdi,%rax,1),%r9
    4f1d:	41 8b 46 34          	mov    0x34(%r14),%eax
    4f21:	41 0f b7 79 06       	movzwl 0x6(%r9),%edi
    4f26:	41 0f b7 71 08       	movzwl 0x8(%r9),%esi
    4f2b:	89 84 24 8c 01 00 00 	mov    %eax,0x18c(%rsp)
    4f32:	48 8d 44 15 00       	lea    0x0(%rbp,%rdx,1),%rax
    4f37:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
    4f3e:	00 
    4f3f:	8b 40 08             	mov    0x8(%rax),%eax
    4f42:	48 01 c5             	add    %rax,%rbp
    4f45:	8d 04 7f             	lea    (%rdi,%rdi,2),%eax
    4f48:	8d 44 00 4f          	lea    0x4f(%rax,%rax,1),%eax
    4f4c:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
    4f53:	00 
    4f54:	31 c0                	xor    %eax,%eax
    4f56:	0f 10 4c 05 00       	movups 0x0(%rbp,%rax,1),%xmm1
    4f5b:	0f 5a c1             	cvtps2pd %xmm1,%xmm0
    4f5e:	0f 29 04 43          	movaps %xmm0,(%rbx,%rax,2)
    4f62:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4f66:	0f 12 c1             	movhlps %xmm1,%xmm0
    4f69:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
    4f6c:	0f 29 44 43 10       	movaps %xmm0,0x10(%rbx,%rax,2)
    4f71:	48 83 c0 10          	add    $0x10,%rax
    4f75:	48 83 f8 30          	cmp    $0x30,%rax
    4f79:	75 db                	jne    4f56 <ayatsuri_model_instance_evaluate+0x1356>
    4f7b:	66 0f ef f6          	pxor   %xmm6,%xmm6
    4f7f:	f3 41 0f 5a 77 40    	cvtss2sd 0x40(%r15),%xmm6
    4f85:	66 0f 28 fe          	movapd %xmm6,%xmm7
    4f89:	f2 0f 11 74 24 20    	movsd  %xmm6,0x20(%rsp)
    4f8f:	f2 0f 10 b4 24 80 03 	movsd  0x380(%rsp),%xmm6
    4f96:	00 00 
    4f98:	66 0f 14 ff          	unpcklpd %xmm7,%xmm7
    4f9c:	0f 29 bc 24 c0 00 00 	movaps %xmm7,0xc0(%rsp)
    4fa3:	00 
    4fa4:	f2 0f 10 bc 24 40 03 	movsd  0x340(%rsp),%xmm7
    4fab:	00 00 
    4fad:	f2 0f 11 74 24 70    	movsd  %xmm6,0x70(%rsp)
    4fb3:	f2 0f 11 7c 24 60    	movsd  %xmm7,0x60(%rsp)
    4fb9:	f2 0f 10 bc 24 60 03 	movsd  0x360(%rsp),%xmm7
    4fc0:	00 00 
    4fc2:	f2 0f 11 7c 24 68    	movsd  %xmm7,0x68(%rsp)
    4fc8:	85 ff                	test   %edi,%edi
    4fca:	0f 84 43 09 00 00    	je     5913 <ayatsuri_model_instance_evaluate+0x1d13>
    4fd0:	66 0f 28 b4 24 70 03 	movapd 0x370(%rsp),%xmm6
    4fd7:	00 00 
    4fd9:	41 8b 46 2c          	mov    0x2c(%r14),%eax
    4fdd:	c7 84 24 88 01 00 00 	movl   $0x0,0x188(%rsp)
    4fe4:	00 00 00 00 
    4fe8:	66 0f 28 bc 24 50 03 	movapd 0x350(%rsp),%xmm7
    4fef:	00 00 
    4ff1:	48 89 8c 24 98 01 00 	mov    %rcx,0x198(%rsp)
    4ff8:	00 
    4ff9:	0f 29 b4 24 30 01 00 	movaps %xmm6,0x130(%rsp)
    5000:	00 
    5001:	66 0f 28 ac 24 30 03 	movapd 0x330(%rsp),%xmm5
    5008:	00 00 
    500a:	66 0f 17 b4 24 50 01 	movhpd %xmm6,0x150(%rsp)
    5011:	00 00 
    5013:	66 0f 13 b4 24 48 01 	movlpd %xmm6,0x148(%rsp)
    501a:	00 00 
    501c:	f2 0f 10 b4 24 48 03 	movsd  0x348(%rsp),%xmm6
    5023:	00 00 
    5025:	48 89 84 24 00 01 00 	mov    %rax,0x100(%rsp)
    502c:	00 
    502d:	48 8d 84 24 38 04 00 	lea    0x438(%rsp),%rax
    5034:	00 
    5035:	0f 29 bc 24 10 01 00 	movaps %xmm7,0x110(%rsp)
    503c:	00 
    503d:	66 0f 17 bc 24 40 01 	movhpd %xmm7,0x140(%rsp)
    5044:	00 00 
    5046:	66 0f 13 bc 24 28 01 	movlpd %xmm7,0x128(%rsp)
    504d:	00 00 
    504f:	f2 0f 10 bc 24 68 03 	movsd  0x368(%rsp),%xmm7
    5056:	00 00 
    5058:	f2 0f 11 b4 24 58 01 	movsd  %xmm6,0x158(%rsp)
    505f:	00 00 
    5061:	f2 0f 10 b4 24 88 03 	movsd  0x388(%rsp),%xmm6
    5068:	00 00 
    506a:	48 89 84 24 70 01 00 	mov    %rax,0x170(%rsp)
    5071:	00 
    5072:	0f 29 ac 24 f0 00 00 	movaps %xmm5,0xf0(%rsp)
    5079:	00 
    507a:	66 0f 17 ac 24 20 01 	movhpd %xmm5,0x120(%rsp)
    5081:	00 00 
    5083:	66 0f 13 ac 24 08 01 	movlpd %xmm5,0x108(%rsp)
    508a:	00 00 
    508c:	f2 0f 11 bc 24 60 01 	movsd  %xmm7,0x160(%rsp)
    5093:	00 00 
    5095:	f2 0f 11 b4 24 68 01 	movsd  %xmm6,0x168(%rsp)
    509c:	00 00 
    509e:	8b 9c 24 88 01 00 00 	mov    0x188(%rsp),%ebx
    50a5:	41 0f b7 41 04       	movzwl 0x4(%r9),%eax
    50aa:	66 0f ef d2          	pxor   %xmm2,%xmm2
    50ae:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    50b3:	f2 0f 10 44 24 60    	movsd  0x60(%rsp),%xmm0
    50b9:	f2 0f 10 6c 24 68    	movsd  0x68(%rsp),%xmm5
    50bf:	66 0f ef db          	pxor   %xmm3,%xmm3
    50c3:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    50c8:	f2 44 0f 10 ac 24 08 	movsd  0x108(%rsp),%xmm13
    50cf:	01 00 00 
    50d2:	01 d8                	add    %ebx,%eax
    50d4:	48 8b 9c 24 00 01 00 	mov    0x100(%rsp),%rbx
    50db:	00 
    50dc:	f2 0f 10 a4 24 20 01 	movsd  0x120(%rsp),%xmm4
    50e3:	00 00 
    50e5:	8d 04 40             	lea    (%rax,%rax,2),%eax
    50e8:	66 44 0f 28 bc 24 30 	movapd 0x130(%rsp),%xmm15
    50ef:	01 00 00 
    50f2:	8d 04 c5 00 00 00 00 	lea    0x0(,%rax,8),%eax
    50f9:	66 44 0f 28 8c 24 10 	movapd 0x110(%rsp),%xmm9
    5100:	01 00 00 
    5103:	48 01 d8             	add    %rbx,%rax
    5106:	48 8b 9c 24 b8 00 00 	mov    0xb8(%rsp),%rbx
    510d:	00 
    510e:	48 01 d8             	add    %rbx,%rax
    5111:	f3 0f 5a 50 14       	cvtss2sd 0x14(%rax),%xmm2
    5116:	f2 0f 59 ea          	mulsd  %xmm2,%xmm5
    511a:	f3 44 0f 5a 20       	cvtss2sd (%rax),%xmm12
    511f:	f3 0f 5a 58 04       	cvtss2sd 0x4(%rax),%xmm3
    5124:	f2 0f 59 c2          	mulsd  %xmm2,%xmm0
    5128:	f3 44 0f 5a 58 08    	cvtss2sd 0x8(%rax),%xmm11
    512e:	f3 44 0f 7e 40 0c    	movq   0xc(%rax),%xmm8
    5134:	f2 0f 59 54 24 70    	mulsd  0x70(%rsp),%xmm2
    513a:	f2 45 0f 59 ec       	mulsd  %xmm12,%xmm13
    513f:	45 0f 5a c0          	cvtps2pd %xmm8,%xmm8
    5143:	f2 0f 59 e3          	mulsd  %xmm3,%xmm4
    5147:	66 45 0f 59 f8       	mulpd  %xmm8,%xmm15
    514c:	66 45 0f 59 c8       	mulpd  %xmm8,%xmm9
    5151:	66 44 0f 59 84 24 f0 	mulpd  0xf0(%rsp),%xmm8
    5158:	00 00 00 
    515b:	f2 0f 11 14 24       	movsd  %xmm2,(%rsp)
    5160:	f2 0f 10 54 24 60    	movsd  0x60(%rsp),%xmm2
    5166:	f2 41 0f 59 d3       	mulsd  %xmm11,%xmm2
    516b:	f2 41 0f 58 e5       	addsd  %xmm13,%xmm4
    5170:	66 45 0f ef ed       	pxor   %xmm13,%xmm13
    5175:	f3 45 0f 5a 6f 34    	cvtss2sd 0x34(%r15),%xmm13
    517b:	66 44 0f 17 7c 24 38 	movhpd %xmm15,0x38(%rsp)
    5182:	66 44 0f 17 4c 24 30 	movhpd %xmm9,0x30(%rsp)
    5189:	66 41 0f 28 c9       	movapd %xmm9,%xmm1
    518e:	66 41 0f 28 f8       	movapd %xmm8,%xmm7
    5193:	66 0f 15 ff          	unpckhpd %xmm7,%xmm7
    5197:	f2 0f 58 e2          	addsd  %xmm2,%xmm4
    519b:	f2 0f 10 54 24 68    	movsd  0x68(%rsp),%xmm2
    51a1:	66 0f 28 f7          	movapd %xmm7,%xmm6
    51a5:	f2 0f 58 a4 24 58 01 	addsd  0x158(%rsp),%xmm4
    51ac:	00 00 
    51ae:	66 41 0f 28 f8       	movapd %xmm8,%xmm7
    51b3:	f2 41 0f 59 d3       	mulsd  %xmm11,%xmm2
    51b8:	f2 41 0f 5c e5       	subsd  %xmm13,%xmm4
    51bd:	f2 44 0f 10 ac 24 28 	movsd  0x128(%rsp),%xmm13
    51c4:	01 00 00 
    51c7:	f2 45 0f 59 ec       	mulsd  %xmm12,%xmm13
    51cc:	f2 44 0f 59 a4 24 48 	mulsd  0x148(%rsp),%xmm12
    51d3:	01 00 00 
    51d6:	f2 0f 11 64 24 48    	movsd  %xmm4,0x48(%rsp)
    51dc:	f2 0f 10 a4 24 40 01 	movsd  0x140(%rsp),%xmm4
    51e3:	00 00 
    51e5:	f2 0f 59 e3          	mulsd  %xmm3,%xmm4
    51e9:	f2 0f 59 9c 24 50 01 	mulsd  0x150(%rsp),%xmm3
    51f0:	00 00 
    51f2:	f2 41 0f 58 e5       	addsd  %xmm13,%xmm4
    51f7:	66 45 0f ef ed       	pxor   %xmm13,%xmm13
    51fc:	f3 45 0f 5a 6f 38    	cvtss2sd 0x38(%r15),%xmm13
    5202:	f2 41 0f 58 dc       	addsd  %xmm12,%xmm3
    5207:	f2 0f 58 e2          	addsd  %xmm2,%xmm4
    520b:	f2 0f 58 a4 24 60 01 	addsd  0x160(%rsp),%xmm4
    5212:	00 00 
    5214:	f2 41 0f 5c e5       	subsd  %xmm13,%xmm4
    5219:	f2 0f 11 64 24 50    	movsd  %xmm4,0x50(%rsp)
    521f:	f2 44 0f 59 5c 24 70 	mulsd  0x70(%rsp),%xmm11
    5226:	66 0f ef e4          	pxor   %xmm4,%xmm4
    522a:	f2 44 0f 10 6c 24 30 	movsd  0x30(%rsp),%xmm13
    5231:	f3 41 0f 5a 67 3c    	cvtss2sd 0x3c(%r15),%xmm4
    5237:	f2 0f 10 14 24       	movsd  (%rsp),%xmm2
    523c:	f2 44 0f 11 7c 24 40 	movsd  %xmm15,0x40(%rsp)
    5243:	f2 41 0f 58 db       	addsd  %xmm11,%xmm3
    5248:	f2 0f 58 9c 24 68 01 	addsd  0x168(%rsp),%xmm3
    524f:	00 00 
    5251:	f2 44 0f 10 1d 00 00 	movsd  0x0(%rip),%xmm11        # 525a <ayatsuri_model_instance_evaluate+0x165a>
    5258:	00 00 
			5256: R_X86_64_PC32	.LC22-0x4
    525a:	f2 0f 5c dc          	subsd  %xmm4,%xmm3
    525e:	66 41 0f 28 e5       	movapd %xmm13,%xmm4
    5263:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    5267:	f2 41 0f 59 d1       	mulsd  %xmm9,%xmm2
    526c:	f2 0f 11 5c 24 58    	movsd  %xmm3,0x58(%rsp)
    5272:	f2 0f 10 5c 24 38    	movsd  0x38(%rsp),%xmm3
    5278:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    527c:	66 44 0f 28 e4       	movapd %xmm4,%xmm12
    5281:	f2 0f 10 64 24 38    	movsd  0x38(%rsp),%xmm4
    5287:	f2 0f 11 94 24 98 00 	movsd  %xmm2,0x98(%rsp)
    528e:	00 00 
    5290:	f2 41 0f 59 e1       	mulsd  %xmm9,%xmm4
    5295:	f2 44 0f 5c e3       	subsd  %xmm3,%xmm12
    529a:	66 41 0f 28 dd       	movapd %xmm13,%xmm3
    529f:	f2 41 0f 59 df       	mulsd  %xmm15,%xmm3
    52a4:	f2 44 0f 11 a4 24 90 	movsd  %xmm12,0x90(%rsp)
    52ab:	00 00 00 
    52ae:	66 45 0f 28 e7       	movapd %xmm15,%xmm12
    52b3:	66 44 0f 28 ec       	movapd %xmm4,%xmm13
    52b8:	f2 44 0f 59 e5       	mulsd  %xmm5,%xmm12
    52bd:	f2 44 0f 5c eb       	subsd  %xmm3,%xmm13
    52c2:	f2 0f 10 9c 24 90 00 	movsd  0x90(%rsp),%xmm3
    52c9:	00 00 
    52cb:	f2 41 0f 59 d8       	mulsd  %xmm8,%xmm3
    52d0:	f2 44 0f 11 ac 24 a8 	movsd  %xmm13,0xa8(%rsp)
    52d7:	00 00 00 
    52da:	f2 41 0f 5c d4       	subsd  %xmm12,%xmm2
    52df:	f2 44 0f 59 e8       	mulsd  %xmm0,%xmm13
    52e4:	f2 44 0f 11 a4 24 a0 	movsd  %xmm12,0xa0(%rsp)
    52eb:	00 00 00 
    52ee:	66 0f 28 e2          	movapd %xmm2,%xmm4
    52f2:	f2 0f 59 e6          	mulsd  %xmm6,%xmm4
    52f6:	f2 0f 5c dc          	subsd  %xmm4,%xmm3
    52fa:	f2 41 0f 58 dd       	addsd  %xmm13,%xmm3
    52ff:	66 44 0f 28 eb       	movapd %xmm3,%xmm13
    5304:	66 0f 54 1d 00 00 00 	andpd  0x0(%rip),%xmm3        # 530c <ayatsuri_model_instance_evaluate+0x170c>
    530b:	00 
			5308: R_X86_64_PC32	.LC8-0x4
    530c:	66 44 0f 2e db       	ucomisd %xmm3,%xmm11
    5311:	0f 82 c9 04 00 00    	jb     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    5317:	f2 44 0f 10 1d 00 00 	movsd  0x0(%rip),%xmm11        # 5320 <ayatsuri_model_instance_evaluate+0x1720>
    531e:	00 00 
			531c: R_X86_64_PC32	.LC40-0x4
    5320:	66 44 0f 2f db       	comisd %xmm3,%xmm11
    5325:	0f 87 b5 04 00 00    	ja     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    532b:	66 0f ef d2          	pxor   %xmm2,%xmm2
    532f:	66 0f ef e4          	pxor   %xmm4,%xmm4
    5333:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    5338:	4c 89 e8             	mov    %r13,%rax
    533b:	f3 0f 5a 94 24 e4 01 	cvtss2sd 0x1e4(%rsp),%xmm2
    5342:	00 00 
    5344:	66 0f 28 da          	movapd %xmm2,%xmm3
    5348:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    534d:	f3 0f 5a a4 24 e8 01 	cvtss2sd 0x1e8(%rsp),%xmm4
    5354:	00 00 
    5356:	66 0f 14 db          	unpcklpd %xmm3,%xmm3
    535a:	b9 f8 ff ff ff       	mov    $0xfffffff8,%ecx
    535f:	f3 44 0f 5a a4 24 ec 	cvtss2sd 0x1ec(%rsp),%xmm12
    5366:	01 00 00 
    5369:	f2 0f 11 94 24 b0 00 	movsd  %xmm2,0xb0(%rsp)
    5370:	00 00 
    5372:	f3 44 0f 5a 9c 24 d8 	cvtss2sd 0x1d8(%rsp),%xmm11
    5379:	01 00 00 
    537c:	66 44 0f 59 c3       	mulpd  %xmm3,%xmm8
    5381:	66 0f 28 dc          	movapd %xmm4,%xmm3
    5385:	66 0f 14 db          	unpcklpd %xmm3,%xmm3
    5389:	66 41 0f 59 d9       	mulpd  %xmm9,%xmm3
    538e:	66 44 0f 28 cd       	movapd %xmm5,%xmm9
    5393:	f2 44 0f 59 cc       	mulsd  %xmm4,%xmm9
    5398:	f2 0f 59 64 24 50    	mulsd  0x50(%rsp),%xmm4
    539e:	66 41 0f 58 d8       	addpd  %xmm8,%xmm3
    53a3:	66 45 0f 28 c4       	movapd %xmm12,%xmm8
    53a8:	66 45 0f 14 c0       	unpcklpd %xmm8,%xmm8
    53ad:	66 45 0f 59 c7       	mulpd  %xmm15,%xmm8
    53b2:	f2 44 0f 10 7c 24 48 	movsd  0x48(%rsp),%xmm15
    53b9:	f2 45 0f 59 fb       	mulsd  %xmm11,%xmm15
    53be:	66 41 0f 58 d8       	addpd  %xmm8,%xmm3
    53c3:	66 44 0f 28 c2       	movapd %xmm2,%xmm8
    53c8:	f2 0f 10 54 24 20    	movsd  0x20(%rsp),%xmm2
    53ce:	66 0f 59 9c 24 c0 00 	mulpd  0xc0(%rsp),%xmm3
    53d5:	00 00 
    53d7:	f2 44 0f 59 c0       	mulsd  %xmm0,%xmm8
    53dc:	0f 29 9c 24 90 03 00 	movaps %xmm3,0x390(%rsp)
    53e3:	00 
    53e4:	66 41 0f 28 d9       	movapd %xmm9,%xmm3
    53e9:	66 45 0f ef c9       	pxor   %xmm9,%xmm9
    53ee:	f3 44 0f 5a 8c 24 e0 	cvtss2sd 0x1e0(%rsp),%xmm9
    53f5:	01 00 00 
    53f8:	f2 41 0f 58 d8       	addsd  %xmm8,%xmm3
    53fd:	f2 44 0f 10 04 24    	movsd  (%rsp),%xmm8
    5403:	f2 45 0f 59 c4       	mulsd  %xmm12,%xmm8
    5408:	f2 44 0f 59 64 24 58 	mulsd  0x58(%rsp),%xmm12
    540f:	f2 41 0f 58 d8       	addsd  %xmm8,%xmm3
    5414:	f2 44 0f 10 44 24 50 	movsd  0x50(%rsp),%xmm8
    541b:	f2 0f 59 da          	mulsd  %xmm2,%xmm3
    541f:	f2 0f 11 9c 24 a0 03 	movsd  %xmm3,0x3a0(%rsp)
    5426:	00 00 
    5428:	66 0f ef db          	pxor   %xmm3,%xmm3
    542c:	f3 0f 5a 9c 24 dc 01 	cvtss2sd 0x1dc(%rsp),%xmm3
    5433:	00 00 
    5435:	f2 44 0f 59 c3       	mulsd  %xmm3,%xmm8
    543a:	f2 45 0f 58 c7       	addsd  %xmm15,%xmm8
    543f:	f2 44 0f 10 7c 24 58 	movsd  0x58(%rsp),%xmm15
    5446:	f2 45 0f 59 f9       	mulsd  %xmm9,%xmm15
    544b:	f2 45 0f 58 c7       	addsd  %xmm15,%xmm8
    5450:	66 45 0f ef ff       	pxor   %xmm15,%xmm15
    5455:	f3 45 0f 5a 7f 48    	cvtss2sd 0x48(%r15),%xmm15
    545b:	f2 44 0f 59 c2       	mulsd  %xmm2,%xmm8
    5460:	f2 45 0f 58 c7       	addsd  %xmm15,%xmm8
    5465:	f2 44 0f 10 bc 24 90 	movsd  0x90(%rsp),%xmm15
    546c:	00 00 00 
    546f:	f2 45 0f 5e fd       	divsd  %xmm13,%xmm15
    5474:	66 41 0f 28 d0       	movapd %xmm8,%xmm2
    5479:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    547e:	f3 44 0f 5a 84 24 cc 	cvtss2sd 0x1cc(%rsp),%xmm8
    5485:	01 00 00 
    5488:	f2 44 0f 11 84 24 90 	movsd  %xmm8,0x90(%rsp)
    548f:	00 00 00 
    5492:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    5497:	f3 44 0f 5a 84 24 d0 	cvtss2sd 0x1d0(%rsp),%xmm8
    549e:	01 00 00 
    54a1:	f2 44 0f 11 84 24 d8 	movsd  %xmm8,0xd8(%rsp)
    54a8:	00 00 00 
    54ab:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    54b0:	f3 45 0f 5a 47 44    	cvtss2sd 0x44(%r15),%xmm8
    54b6:	66 41 0f 14 d7       	unpcklpd %xmm15,%xmm2
    54bb:	66 45 0f ef ff       	pxor   %xmm15,%xmm15
    54c0:	0f 29 94 24 e0 00 00 	movaps %xmm2,0xe0(%rsp)
    54c7:	00 
    54c8:	f2 0f 10 94 24 b0 00 	movsd  0xb0(%rsp),%xmm2
    54cf:	00 00 
    54d1:	f2 0f 59 54 24 48    	mulsd  0x48(%rsp),%xmm2
    54d7:	f3 44 0f 5a bc 24 c8 	cvtss2sd 0x1c8(%rsp),%xmm15
    54de:	01 00 00 
    54e1:	f2 0f 58 e2          	addsd  %xmm2,%xmm4
    54e5:	f2 0f 10 54 24 20    	movsd  0x20(%rsp),%xmm2
    54eb:	f2 41 0f 58 e4       	addsd  %xmm12,%xmm4
    54f0:	66 44 0f 28 e7       	movapd %xmm7,%xmm12
    54f5:	f2 45 0f 59 e3       	mulsd  %xmm11,%xmm12
    54fa:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    54fe:	f2 44 0f 58 c4       	addsd  %xmm4,%xmm8
    5503:	66 0f 28 e3          	movapd %xmm3,%xmm4
    5507:	f2 0f 59 e1          	mulsd  %xmm1,%xmm4
    550b:	f2 41 0f 58 e4       	addsd  %xmm12,%xmm4
    5510:	f2 44 0f 10 64 24 40 	movsd  0x40(%rsp),%xmm12
    5517:	f2 45 0f 59 e1       	mulsd  %xmm9,%xmm12
    551c:	f2 41 0f 58 e4       	addsd  %xmm12,%xmm4
    5521:	f2 44 0f 10 64 24 30 	movsd  0x30(%rsp),%xmm12
    5528:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    552c:	66 44 0f 14 c4       	unpcklpd %xmm4,%xmm8
    5531:	66 0f 28 e6          	movapd %xmm6,%xmm4
    5535:	44 0f 11 84 24 a8 03 	movups %xmm8,0x3a8(%rsp)
    553c:	00 00 
    553e:	f2 41 0f 59 e3       	mulsd  %xmm11,%xmm4
    5543:	f2 44 0f 59 d8       	mulsd  %xmm0,%xmm11
    5548:	66 44 0f 28 c4       	movapd %xmm4,%xmm8
    554d:	66 41 0f 28 e4       	movapd %xmm12,%xmm4
    5552:	f2 0f 59 e3          	mulsd  %xmm3,%xmm4
    5556:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    555a:	f2 41 0f 58 e0       	addsd  %xmm8,%xmm4
    555f:	f2 44 0f 10 44 24 38 	movsd  0x38(%rsp),%xmm8
    5566:	48 8b 9c 24 d0 00 00 	mov    0xd0(%rsp),%rbx
    556d:	00 
    556e:	f2 41 0f 58 db       	addsd  %xmm11,%xmm3
    5573:	f2 44 0f 10 5c 24 38 	movsd  0x38(%rsp),%xmm11
    557a:	f2 45 0f 59 c1       	mulsd  %xmm9,%xmm8
    557f:	48 8d 5c 9d 00       	lea    0x0(%rbp,%rbx,4),%rbx
    5584:	f2 41 0f 58 e0       	addsd  %xmm8,%xmm4
    5589:	66 44 0f 28 c2       	movapd %xmm2,%xmm8
    558e:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    5592:	f2 0f 10 14 24       	movsd  (%rsp),%xmm2
    5597:	f2 44 0f 59 ca       	mulsd  %xmm2,%xmm9
    559c:	f2 41 0f 58 d9       	addsd  %xmm9,%xmm3
    55a1:	f2 44 0f 10 4c 24 40 	movsd  0x40(%rsp),%xmm9
    55a8:	f2 41 0f 59 d8       	mulsd  %xmm8,%xmm3
    55ad:	66 0f 14 e3          	unpcklpd %xmm3,%xmm4
    55b1:	f2 0f 10 9c 24 a0 00 	movsd  0xa0(%rsp),%xmm3
    55b8:	00 00 
    55ba:	f2 0f 5c 9c 24 98 00 	subsd  0x98(%rsp),%xmm3
    55c1:	00 00 
    55c3:	0f 11 a4 24 b8 03 00 	movups %xmm4,0x3b8(%rsp)
    55ca:	00 
    55cb:	66 0f 28 a4 24 e0 00 	movapd 0xe0(%rsp),%xmm4
    55d2:	00 00 
    55d4:	0f 11 a4 24 c8 03 00 	movups %xmm4,0x3c8(%rsp)
    55db:	00 
    55dc:	f2 41 0f 5e dd       	divsd  %xmm13,%xmm3
    55e1:	f2 0f 10 a4 24 a8 00 	movsd  0xa8(%rsp),%xmm4
    55e8:	00 00 
    55ea:	f2 41 0f 5e e5       	divsd  %xmm13,%xmm4
    55ef:	66 0f 14 dc          	unpcklpd %xmm4,%xmm3
    55f3:	66 0f 28 e6          	movapd %xmm6,%xmm4
    55f7:	0f 11 9c 24 d8 03 00 	movups %xmm3,0x3d8(%rsp)
    55fe:	00 
    55ff:	66 41 0f 28 db       	movapd %xmm11,%xmm3
    5604:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    5608:	f2 0f 59 d8          	mulsd  %xmm0,%xmm3
    560c:	f2 0f 5c dc          	subsd  %xmm4,%xmm3
    5610:	66 0f 28 e7          	movapd %xmm7,%xmm4
    5614:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    5618:	f2 0f 10 94 24 90 00 	movsd  0x90(%rsp),%xmm2
    561f:	00 00 
    5621:	f2 41 0f 5e dd       	divsd  %xmm13,%xmm3
    5626:	66 44 0f 28 c4       	movapd %xmm4,%xmm8
    562b:	66 41 0f 28 e1       	movapd %xmm9,%xmm4
    5630:	f2 0f 59 e0          	mulsd  %xmm0,%xmm4
    5634:	f2 44 0f 5c c4       	subsd  %xmm4,%xmm8
    5639:	66 41 0f 28 e3       	movapd %xmm11,%xmm4
    563e:	f2 0f 59 e7          	mulsd  %xmm7,%xmm4
    5642:	f2 45 0f 5e c5       	divsd  %xmm13,%xmm8
    5647:	66 41 0f 14 d8       	unpcklpd %xmm8,%xmm3
    564c:	0f 11 9c 24 e8 03 00 	movups %xmm3,0x3e8(%rsp)
    5653:	00 
    5654:	66 41 0f 28 d9       	movapd %xmm9,%xmm3
    5659:	f2 0f 59 de          	mulsd  %xmm6,%xmm3
    565d:	f2 0f 5c dc          	subsd  %xmm4,%xmm3
    5661:	66 0f 28 e6          	movapd %xmm6,%xmm4
    5665:	f2 0f 59 e5          	mulsd  %xmm5,%xmm4
    5669:	f2 41 0f 5e dd       	divsd  %xmm13,%xmm3
    566e:	66 44 0f 28 c4       	movapd %xmm4,%xmm8
    5673:	66 41 0f 28 e4       	movapd %xmm12,%xmm4
    5678:	f2 0f 59 e0          	mulsd  %xmm0,%xmm4
    567c:	f2 44 0f 5c c4       	subsd  %xmm4,%xmm8
    5681:	66 0f 28 e0          	movapd %xmm0,%xmm4
    5685:	f2 0f 59 e1          	mulsd  %xmm1,%xmm4
    5689:	f2 41 0f 59 c7       	mulsd  %xmm15,%xmm0
    568e:	f2 45 0f 5e c5       	divsd  %xmm13,%xmm8
    5693:	66 41 0f 14 d8       	unpcklpd %xmm8,%xmm3
    5698:	66 44 0f 28 c4       	movapd %xmm4,%xmm8
    569d:	66 41 0f 28 e4       	movapd %xmm12,%xmm4
    56a2:	0f 11 9c 24 f8 03 00 	movups %xmm3,0x3f8(%rsp)
    56a9:	00 
    56aa:	f2 0f 59 e7          	mulsd  %xmm7,%xmm4
    56ae:	66 0f 28 df          	movapd %xmm7,%xmm3
    56b2:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    56b6:	f2 41 0f 59 ff       	mulsd  %xmm15,%xmm7
    56bb:	f2 44 0f 59 e2       	mulsd  %xmm2,%xmm12
    56c0:	f2 0f 59 ea          	mulsd  %xmm2,%xmm5
    56c4:	f2 44 0f 5c c3       	subsd  %xmm3,%xmm8
    56c9:	66 0f 28 de          	movapd %xmm6,%xmm3
    56cd:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
    56d1:	f2 0f 59 ca          	mulsd  %xmm2,%xmm1
    56d5:	f2 45 0f 5e c5       	divsd  %xmm13,%xmm8
    56da:	f2 0f 58 c5          	addsd  %xmm5,%xmm0
    56de:	f2 41 0f 59 f7       	mulsd  %xmm15,%xmm6
    56e3:	f2 0f 5c e3          	subsd  %xmm3,%xmm4
    56e7:	f2 0f 58 cf          	addsd  %xmm7,%xmm1
    56eb:	66 0f 28 fa          	movapd %xmm2,%xmm7
    56ef:	f2 0f 10 14 24       	movsd  (%rsp),%xmm2
    56f4:	48 89 14 24          	mov    %rdx,(%rsp)
    56f8:	f2 41 0f 5e e5       	divsd  %xmm13,%xmm4
    56fd:	66 41 0f 28 d8       	movapd %xmm8,%xmm3
    5702:	66 0f 14 dc          	unpcklpd %xmm4,%xmm3
    5706:	66 41 0f 28 e3       	movapd %xmm11,%xmm4
    570b:	0f 11 9c 24 08 04 00 	movups %xmm3,0x408(%rsp)
    5712:	00 
    5713:	66 41 0f 28 d9       	movapd %xmm9,%xmm3
    5718:	f2 44 0f 10 8c 24 d8 	movsd  0xd8(%rsp),%xmm9
    571f:	00 00 00 
    5722:	f2 41 0f 59 d9       	mulsd  %xmm9,%xmm3
    5727:	f2 41 0f 59 e1       	mulsd  %xmm9,%xmm4
    572c:	f2 41 0f 59 d1       	mulsd  %xmm9,%xmm2
    5731:	f2 0f 58 cb          	addsd  %xmm3,%xmm1
    5735:	66 41 0f 28 dc       	movapd %xmm12,%xmm3
    573a:	f2 0f 58 de          	addsd  %xmm6,%xmm3
    573e:	f2 0f 58 c2          	addsd  %xmm2,%xmm0
    5742:	f2 0f 58 dc          	addsd  %xmm4,%xmm3
    5746:	f2 0f 11 84 24 28 04 	movsd  %xmm0,0x428(%rsp)
    574d:	00 00 
    574f:	f2 0f 10 44 24 48    	movsd  0x48(%rsp),%xmm0
    5755:	f2 41 0f 59 c7       	mulsd  %xmm15,%xmm0
    575a:	66 0f 14 cb          	unpcklpd %xmm3,%xmm1
    575e:	0f 11 8c 24 18 04 00 	movups %xmm1,0x418(%rsp)
    5765:	00 
    5766:	f2 0f 10 4c 24 50    	movsd  0x50(%rsp),%xmm1
    576c:	f2 0f 59 cf          	mulsd  %xmm7,%xmm1
    5770:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    5774:	f2 0f 10 4c 24 58    	movsd  0x58(%rsp),%xmm1
    577a:	f2 41 0f 59 c9       	mulsd  %xmm9,%xmm1
    577f:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    5783:	f2 0f 11 84 24 30 04 	movsd  %xmm0,0x430(%rsp)
    578a:	00 00 
    578c:	f2 0f 10 08          	movsd  (%rax),%xmm1
    5790:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 5798 <ayatsuri_model_instance_evaluate+0x1b98>
    5797:	00 
			5794: R_X86_64_PC32	.LC22-0x4
    5798:	66 0f 28 c1          	movapd %xmm1,%xmm0
    579c:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 57a4 <ayatsuri_model_instance_evaluate+0x1ba4>
    57a3:	00 
			57a0: R_X86_64_PC32	.LC8-0x4
    57a4:	66 0f 2e e8          	ucomisd %xmm0,%xmm5
    57a8:	72 36                	jb     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    57aa:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 57b2 <ayatsuri_model_instance_evaluate+0x1bb2>
    57b1:	00 
			57ae: R_X86_64_PC32	.LC38-0x4
    57b2:	73 2c                	jae    57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    57b4:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 57bc <ayatsuri_model_instance_evaluate+0x1bbc>
    57bb:	00 
			57b8: R_X86_64_PC32	.LC39-0x4
    57bc:	0f 86 de 00 00 00    	jbe    58a0 <ayatsuri_model_instance_evaluate+0x1ca0>
    57c2:	66 0f ef d2          	pxor   %xmm2,%xmm2
    57c6:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 57ce <ayatsuri_model_instance_evaluate+0x1bce>
    57cd:	00 
			57ca: R_X86_64_PC32	.LC33-0x4
    57ce:	66 0f 2f d1          	comisd %xmm1,%xmm2
    57d2:	77 04                	ja     57d8 <ayatsuri_model_instance_evaluate+0x1bd8>
    57d4:	41 0f 28 c6          	movaps %xmm14,%xmm0
    57d8:	f3 0f 11 03          	movss  %xmm0,(%rbx)
    57dc:	0f 1f 40 00          	nopl   0x0(%rax)
    57e0:	41 c6 87 a5 00 00 00 	movb   $0x0,0xa5(%r15)
    57e7:	00 
    57e8:	b8 02 00 00 00       	mov    $0x2,%eax
    57ed:	e9 5d e5 ff ff       	jmp    3d4f <ayatsuri_model_instance_evaluate+0x14f>
    57f2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    57f8:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    57fd:	0f 29 ac 24 90 03 00 	movaps %xmm5,0x390(%rsp)
    5804:	00 
    5805:	4c 8d ac 24 90 03 00 	lea    0x390(%rsp),%r13
    580c:	00 
    580d:	f3 44 0f 5a 9c 24 6c 	cvtss2sd 0x26c(%rsp),%xmm11
    5814:	02 00 00 
    5817:	f2 41 0f 59 f4       	mulsd  %xmm12,%xmm6
    581c:	f2 0f 11 9c 24 a0 03 	movsd  %xmm3,0x3a0(%rsp)
    5823:	00 00 
    5825:	f2 44 0f 11 8c 24 e8 	movsd  %xmm9,0x3e8(%rsp)
    582c:	03 00 00 
    582f:	f2 45 0f 59 eb       	mulsd  %xmm11,%xmm13
    5834:	f2 44 0f 59 e4       	mulsd  %xmm4,%xmm12
    5839:	f2 44 0f 59 d8       	mulsd  %xmm0,%xmm11
    583e:	66 0f 14 fe          	unpcklpd %xmm6,%xmm7
    5842:	66 44 0f 14 e9       	unpcklpd %xmm1,%xmm13
    5847:	0f 11 bc 24 a8 03 00 	movups %xmm7,0x3a8(%rsp)
    584e:	00 
    584f:	44 0f 11 ac 24 b8 03 	movups %xmm13,0x3b8(%rsp)
    5856:	00 00 
    5858:	66 45 0f 14 c4       	unpcklpd %xmm12,%xmm8
    585d:	44 0f 11 84 24 c8 03 	movups %xmm8,0x3c8(%rsp)
    5864:	00 00 
    5866:	66 44 0f 14 da       	unpcklpd %xmm2,%xmm11
    586b:	44 0f 11 9c 24 d8 03 	movups %xmm11,0x3d8(%rsp)
    5872:	00 00 
    5874:	e9 45 ec ff ff       	jmp    44be <ayatsuri_model_instance_evaluate+0x8be>
    5879:	41 c6 87 a5 00 00 00 	movb   $0x0,0xa5(%r15)
    5880:	00 
    5881:	e9 c4 e4 ff ff       	jmp    3d4a <ayatsuri_model_instance_evaluate+0x14a>
    5886:	41 c6 87 a5 00 00 00 	movb   $0x0,0xa5(%r15)
    588d:	00 
    588e:	31 c0                	xor    %eax,%eax
    5890:	e9 ba e4 ff ff       	jmp    3d4f <ayatsuri_model_instance_evaluate+0x14f>
    5895:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    589b:	e9 55 ed ff ff       	jmp    45f5 <ayatsuri_model_instance_evaluate+0x9f5>
    58a0:	f2 0f 5a c9          	cvtsd2ss %xmm1,%xmm1
    58a4:	f3 0f 11 0b          	movss  %xmm1,(%rbx)
    58a8:	41 0f 54 ca          	andps  %xmm10,%xmm1
    58ac:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
    58b0:	83 f9 08             	cmp    $0x8,%ecx
    58b3:	0f 86 8b 08 00 00    	jbe    6144 <ayatsuri_model_instance_evaluate+0x2544>
    58b9:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 58c1 <ayatsuri_model_instance_evaluate+0x1cc1>
    58c0:	00 
			58bd: R_X86_64_PC32	.LC35-0x4
    58c1:	66 0f 2f c8          	comisd %xmm0,%xmm1
    58c5:	0f 87 15 ff ff ff    	ja     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    58cb:	48 8b 94 24 70 01 00 	mov    0x170(%rsp),%rdx
    58d2:	00 
    58d3:	48 83 c0 08          	add    $0x8,%rax
    58d7:	48 83 c3 04          	add    $0x4,%rbx
    58db:	83 c1 01             	add    $0x1,%ecx
    58de:	48 39 d0             	cmp    %rdx,%rax
    58e1:	0f 85 a5 fe ff ff    	jne    578c <ayatsuri_model_instance_evaluate+0x1b8c>
    58e7:	83 84 24 88 01 00 00 	addl   $0x1,0x188(%rsp)
    58ee:	01 
    58ef:	8b 84 24 88 01 00 00 	mov    0x188(%rsp),%eax
    58f6:	48 83 84 24 d0 00 00 	addq   $0x15,0xd0(%rsp)
    58fd:	00 15 
    58ff:	48 8b 14 24          	mov    (%rsp),%rdx
    5903:	39 c7                	cmp    %eax,%edi
    5905:	0f 85 93 f7 ff ff    	jne    509e <ayatsuri_model_instance_evaluate+0x149e>
    590b:	48 8b 8c 24 98 01 00 	mov    0x198(%rsp),%rcx
    5912:	00 
    5913:	0f b7 c6             	movzwl %si,%eax
    5916:	8b b4 24 8c 01 00 00 	mov    0x18c(%rsp),%esi
    591d:	4c 89 5c 24 40       	mov    %r11,0x40(%rsp)
    5922:	48 6b c0 48          	imul   $0x48,%rax,%rax
    5926:	48 8b 9c 24 b8 00 00 	mov    0xb8(%rsp),%rbx
    592d:	00 
    592e:	4c 89 54 24 38       	mov    %r10,0x38(%rsp)
    5933:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
    5938:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
    593d:	48 01 f0             	add    %rsi,%rax
    5940:	48 01 c3             	add    %rax,%rbx
    5943:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
    594a:	00 
    594b:	8b 78 0c             	mov    0xc(%rax),%edi
    594e:	e8 0d a8 ff ff       	call   160 <pack_rgb>
    5953:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 595b <ayatsuri_model_instance_evaluate+0x1d5b>
    595a:	00 
			5957: R_X86_64_PC32	.LC5-0x4
    595b:	66 89 85 fc 00 00 00 	mov    %ax,0xfc(%rbp)
    5962:	49 8b 47 08          	mov    0x8(%r15),%rax
    5966:	f2 42 0f 59 04 c0    	mulsd  (%rax,%r8,8),%xmm0
    596c:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 5974 <ayatsuri_model_instance_evaluate+0x1d74>
    5973:	00 
			5970: R_X86_64_PC32	.LC6-0x4
    5974:	e8 00 00 00 00       	call   5979 <ayatsuri_model_instance_evaluate+0x1d79>
			5975: R_X86_64_PLT32	floor-0x4
    5979:	48 8d 7b 30          	lea    0x30(%rbx),%rdi
    597d:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    5981:	66 89 85 fe 00 00 00 	mov    %ax,0xfe(%rbp)
    5988:	e8 73 a6 ff ff       	call   0 <md>
    598d:	f2 0f 10 4c 24 68    	movsd  0x68(%rsp),%xmm1
    5993:	f2 0f 11 04 24       	movsd  %xmm0,(%rsp)
    5998:	f2 0f 10 44 24 60    	movsd  0x60(%rsp),%xmm0
    599e:	e8 00 00 00 00       	call   59a3 <ayatsuri_model_instance_evaluate+0x1da3>
			599f: R_X86_64_PLT32	hypot-0x4
    59a3:	f2 0f 10 4c 24 70    	movsd  0x70(%rsp),%xmm1
    59a9:	e8 00 00 00 00       	call   59ae <ayatsuri_model_instance_evaluate+0x1dae>
			59aa: R_X86_64_PLT32	hypot-0x4
    59ae:	f2 0f 59 04 24       	mulsd  (%rsp),%xmm0
    59b3:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 59bb <ayatsuri_model_instance_evaluate+0x1dbb>
    59ba:	00 
			59b7: R_X86_64_PC32	.LC9-0x4
    59bb:	e8 00 00 00 00       	call   59c0 <ayatsuri_model_instance_evaluate+0x1dc0>
			59bc: R_X86_64_PLT32	fmin-0x4
    59c0:	f2 0f 59 05 00 00 00 	mulsd  0x0(%rip),%xmm0        # 59c8 <ayatsuri_model_instance_evaluate+0x1dc8>
    59c7:	00 
			59c4: R_X86_64_PC32	.LC5-0x4
    59c8:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 59d0 <ayatsuri_model_instance_evaluate+0x1dd0>
    59cf:	00 
			59cc: R_X86_64_PC32	.LC6-0x4
    59d0:	e8 00 00 00 00       	call   59d5 <ayatsuri_model_instance_evaluate+0x1dd5>
			59d1: R_X86_64_PLT32	floor-0x4
    59d5:	48 8d 7b 40          	lea    0x40(%rbx),%rdi
    59d9:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    59dd:	66 89 85 00 01 00 00 	mov    %ax,0x100(%rbp)
    59e4:	e8 17 a6 ff ff       	call   0 <md>
    59e9:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 59f1 <ayatsuri_model_instance_evaluate+0x1df1>
    59f0:	00 
			59ed: R_X86_64_PC32	.LC22-0x4
    59f1:	66 0f 28 c8          	movapd %xmm0,%xmm1
    59f5:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 59fd <ayatsuri_model_instance_evaluate+0x1dfd>
    59fc:	00 
			59f9: R_X86_64_PC32	.LC8-0x4
    59fd:	66 0f 2e f1          	ucomisd %xmm1,%xmm6
    5a01:	0f 82 d9 fd ff ff    	jb     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    5a07:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 5a0f <ayatsuri_model_instance_evaluate+0x1e0f>
    5a0e:	00 
			5a0b: R_X86_64_PC32	.LC38-0x4
    5a0f:	0f 83 cb fd ff ff    	jae    57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    5a15:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 5a1d <ayatsuri_model_instance_evaluate+0x1e1d>
    5a1c:	00 
			5a19: R_X86_64_PC32	.LC39-0x4
    5a1d:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    5a22:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 5a2b <ayatsuri_model_instance_evaluate+0x1e2b>
    5a29:	00 00 
			5a27: R_X86_64_PC32	.LC0-0x4
    5a2b:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
    5a30:	4c 8b 54 24 38       	mov    0x38(%rsp),%r10
    5a35:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 5a3e <ayatsuri_model_instance_evaluate+0x1e3e>
    5a3c:	00 00 
			5a3a: R_X86_64_PC32	.LC1-0x4
    5a3e:	4c 8b 5c 24 40       	mov    0x40(%rsp),%r11
    5a43:	0f 86 86 03 00 00    	jbe    5dcf <ayatsuri_model_instance_evaluate+0x21cf>
    5a49:	66 0f ef c9          	pxor   %xmm1,%xmm1
    5a4d:	66 0f 2f c8          	comisd %xmm0,%xmm1
    5a51:	0f 87 fa 06 00 00    	ja     6151 <ayatsuri_model_instance_evaluate+0x2551>
    5a57:	41 0f 28 c6          	movaps %xmm14,%xmm0
    5a5b:	45 8b 46 50          	mov    0x50(%r14),%r8d
    5a5f:	4d 8b 0e             	mov    (%r14),%r9
    5a62:	f3 0f 11 85 38 01 00 	movss  %xmm0,0x138(%rbp)
    5a69:	00 
    5a6a:	41 8b 7e 4c          	mov    0x4c(%r14),%edi
    5a6e:	45 85 c0             	test   %r8d,%r8d
    5a71:	0f 84 61 03 00 00    	je     5dd8 <ayatsuri_model_instance_evaluate+0x21d8>
    5a77:	31 f6                	xor    %esi,%esi
    5a79:	eb 0c                	jmp    5a87 <ayatsuri_model_instance_evaluate+0x1e87>
    5a7b:	83 c6 01             	add    $0x1,%esi
    5a7e:	41 39 f0             	cmp    %esi,%r8d
    5a81:	0f 84 51 03 00 00    	je     5dd8 <ayatsuri_model_instance_evaluate+0x21d8>
    5a87:	89 f0                	mov    %esi,%eax
    5a89:	44 8b 74 24 18       	mov    0x18(%rsp),%r14d
    5a8e:	c1 e0 05             	shl    $0x5,%eax
    5a91:	48 01 f8             	add    %rdi,%rax
    5a94:	4c 01 c8             	add    %r9,%rax
    5a97:	0f b7 18             	movzwl (%rax),%ebx
    5a9a:	44 39 f3             	cmp    %r14d,%ebx
    5a9d:	75 dc                	jne    5a7b <ayatsuri_model_instance_evaluate+0x1e7b>
    5a9f:	49 8b 77 08          	mov    0x8(%r15),%rsi
    5aa3:	66 0f ef ed          	pxor   %xmm5,%xmm5
    5aa7:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5aab:	66 0f ef e4          	pxor   %xmm4,%xmm4
    5aaf:	f3 41 0f 5a 47 34    	cvtss2sd 0x34(%r15),%xmm0
    5ab5:	66 0f ef db          	pxor   %xmm3,%xmm3
    5ab9:	66 0f 6f b4 24 a0 01 	movdqa 0x1a0(%rsp),%xmm6
    5ac0:	00 00 
    5ac2:	4c 8d 8c 24 10 02 00 	lea    0x210(%rsp),%r9
    5ac9:	00 
    5aca:	8b 54 16 08          	mov    0x8(%rsi,%rdx,1),%edx
    5ace:	48 8d ac 24 f0 01 00 	lea    0x1f0(%rsp),%rbp
    5ad5:	00 
    5ad6:	0f 29 b4 24 10 02 00 	movaps %xmm6,0x210(%rsp)
    5add:	00 
    5ade:	48 01 d6             	add    %rdx,%rsi
    5ae1:	48 8d 94 24 c8 01 00 	lea    0x1c8(%rsp),%rdx
    5ae8:	00 
    5ae9:	f3 0f 5a 6e 0c       	cvtss2sd 0xc(%rsi),%xmm5
    5aee:	f2 0f 5c e8          	subsd  %xmm0,%xmm5
    5af2:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5af6:	f3 0f 5a 66 1c       	cvtss2sd 0x1c(%rsi),%xmm4
    5afb:	f3 41 0f 5a 47 38    	cvtss2sd 0x38(%r15),%xmm0
    5b01:	f2 0f 5c e0          	subsd  %xmm0,%xmm4
    5b05:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5b09:	4c 8d 76 0c          	lea    0xc(%rsi),%r14
    5b0d:	f3 0f 5a 5e 2c       	cvtss2sd 0x2c(%rsi),%xmm3
    5b12:	f3 41 0f 5a 47 3c    	cvtss2sd 0x3c(%r15),%xmm0
    5b18:	f2 0f 5c d8          	subsd  %xmm0,%xmm3
    5b1c:	48 89 94 24 20 02 00 	mov    %rdx,0x220(%rsp)
    5b23:	00 
    5b24:	31 d2                	xor    %edx,%edx
    5b26:	41 89 d0             	mov    %edx,%r8d
    5b29:	48 83 fa 02          	cmp    $0x2,%rdx
    5b2d:	0f 84 96 06 00 00    	je     61c9 <ayatsuri_model_instance_evaluate+0x25c9>
    5b33:	66 0f ef f6          	pxor   %xmm6,%xmm6
    5b37:	f3 41 0f 5a 77 40    	cvtss2sd 0x40(%r15),%xmm6
    5b3d:	49 8b 3c d1          	mov    (%r9,%rdx,8),%rdi
    5b41:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5b45:	66 0f ef ff          	pxor   %xmm7,%xmm7
    5b49:	66 0f ef d2          	pxor   %xmm2,%xmm2
    5b4d:	47 8d 04 40          	lea    (%r8,%r8,2),%r8d
    5b51:	f3 0f 5a 07          	cvtss2sd (%rdi),%xmm0
    5b55:	f3 0f 5a 7f 04       	cvtss2sd 0x4(%rdi),%xmm7
    5b5a:	f3 0f 5a 57 08       	cvtss2sd 0x8(%rdi),%xmm2
    5b5f:	48 89 f7             	mov    %rsi,%rdi
    5b62:	66 0f ef c9          	pxor   %xmm1,%xmm1
    5b66:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    5b6b:	44 89 c3             	mov    %r8d,%ebx
    5b6e:	48 83 c7 04          	add    $0x4,%rdi
    5b72:	f3 0f 5a 4f fc       	cvtss2sd -0x4(%rdi),%xmm1
    5b77:	f3 44 0f 5a 47 0c    	cvtss2sd 0xc(%rdi),%xmm8
    5b7d:	f2 0f 59 c8          	mulsd  %xmm0,%xmm1
    5b81:	41 83 c0 01          	add    $0x1,%r8d
    5b85:	f2 44 0f 59 c7       	mulsd  %xmm7,%xmm8
    5b8a:	f2 41 0f 58 c8       	addsd  %xmm8,%xmm1
    5b8f:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    5b94:	f3 44 0f 5a 47 1c    	cvtss2sd 0x1c(%rdi),%xmm8
    5b9a:	f2 44 0f 59 c2       	mulsd  %xmm2,%xmm8
    5b9f:	f2 41 0f 58 c8       	addsd  %xmm8,%xmm1
    5ba4:	f2 0f 59 ce          	mulsd  %xmm6,%xmm1
    5ba8:	f2 0f 11 8c dc e0 02 	movsd  %xmm1,0x2e0(%rsp,%rbx,8)
    5baf:	00 00 
    5bb1:	4c 39 f7             	cmp    %r14,%rdi
    5bb4:	75 ac                	jne    5b62 <ayatsuri_model_instance_evaluate+0x1f62>
    5bb6:	f2 0f 59 c5          	mulsd  %xmm5,%xmm0
    5bba:	f2 0f 59 fc          	mulsd  %xmm4,%xmm7
    5bbe:	f2 0f 59 d3          	mulsd  %xmm3,%xmm2
    5bc2:	f2 0f 58 c7          	addsd  %xmm7,%xmm0
    5bc6:	f2 0f 58 c2          	addsd  %xmm2,%xmm0
    5bca:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
    5bce:	f2 0f 11 44 d5 00    	movsd  %xmm0,0x0(%rbp,%rdx,8)
    5bd4:	48 83 fa 02          	cmp    $0x2,%rdx
    5bd8:	0f 84 05 02 00 00    	je     5de3 <ayatsuri_model_instance_evaluate+0x21e3>
    5bde:	66 0f ef c9          	pxor   %xmm1,%xmm1
    5be2:	f3 41 0f 5a 4c 97 44 	cvtss2sd 0x44(%r15,%rdx,4),%xmm1
    5be9:	f2 0f 58 c8          	addsd  %xmm0,%xmm1
    5bed:	f2 0f 11 4c d5 00    	movsd  %xmm1,0x0(%rbp,%rdx,8)
    5bf3:	48 83 c2 01          	add    $0x1,%rdx
    5bf7:	e9 2a ff ff ff       	jmp    5b26 <ayatsuri_model_instance_evaluate+0x1f26>
    5bfc:	0f 1f 40 00          	nopl   0x0(%rax)
    5c00:	48 8b 41 10          	mov    0x10(%rcx),%rax
    5c04:	48 8b 51 18          	mov    0x18(%rcx),%rdx
    5c08:	48 33 46 10          	xor    0x10(%rsi),%rax
    5c0c:	48 33 56 18          	xor    0x18(%rsi),%rdx
    5c10:	48 09 d0             	or     %rdx,%rax
    5c13:	0f 85 cc e1 ff ff    	jne    3de5 <ayatsuri_model_instance_evaluate+0x1e5>
    5c19:	8b 46 20             	mov    0x20(%rsi),%eax
    5c1c:	39 41 20             	cmp    %eax,0x20(%rcx)
    5c1f:	0f 85 c0 e1 ff ff    	jne    3de5 <ayatsuri_model_instance_evaluate+0x1e5>
    5c25:	49 39 cf             	cmp    %rcx,%r15
    5c28:	0f 82 0a 01 00 00    	jb     5d38 <ayatsuri_model_instance_evaluate+0x2138>
    5c2e:	4c 89 f8             	mov    %r15,%rax
    5c31:	48 29 c8             	sub    %rcx,%rax
    5c34:	48 83 f8 23          	cmp    $0x23,%rax
    5c38:	0f 86 a7 e1 ff ff    	jbe    3de5 <ayatsuri_model_instance_evaluate+0x1e5>
    5c3e:	4d 39 c7             	cmp    %r8,%r15
    5c41:	0f 82 49 01 00 00    	jb     5d90 <ayatsuri_model_instance_evaluate+0x2190>
    5c47:	4c 89 f8             	mov    %r15,%rax
    5c4a:	4c 29 c0             	sub    %r8,%rax
    5c4d:	48 83 f8 17          	cmp    $0x17,%rax
    5c51:	0f 86 8e e1 ff ff    	jbe    3de5 <ayatsuri_model_instance_evaluate+0x1e5>
    5c57:	41 c6 87 a6 00 00 00 	movb   $0x0,0xa6(%r15)
    5c5e:	00 
    5c5f:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
    5c64:	31 db                	xor    %ebx,%ebx
    5c66:	49 8b 17             	mov    (%r15),%rdx
    5c69:	41 0f 11 47 4c       	movups %xmm0,0x4c(%r15)
    5c6e:	49 8b 40 10          	mov    0x10(%r8),%rax
    5c72:	49 89 47 5c          	mov    %rax,0x5c(%r15)
    5c76:	f3 41 0f 10 00       	movss  (%r8),%xmm0
    5c7b:	66 83 7a 0c 00       	cmpw   $0x0,0xc(%rdx)
    5c80:	f3 41 0f 11 47 64    	movss  %xmm0,0x64(%r15)
    5c86:	f3 41 0f 10 40 0c    	movss  0xc(%r8),%xmm0
    5c8c:	f3 41 0f 11 47 7c    	movss  %xmm0,0x7c(%r15)
    5c92:	f3 41 0f 10 40 04    	movss  0x4(%r8),%xmm0
    5c98:	f3 41 0f 11 47 68    	movss  %xmm0,0x68(%r15)
    5c9e:	f3 41 0f 10 40 10    	movss  0x10(%r8),%xmm0
    5ca4:	f3 41 0f 11 87 80 00 	movss  %xmm0,0x80(%r15)
    5cab:	00 00 
    5cad:	f3 41 0f 10 40 08    	movss  0x8(%r8),%xmm0
    5cb3:	f3 41 0f 11 47 6c    	movss  %xmm0,0x6c(%r15)
    5cb9:	f3 41 0f 10 40 14    	movss  0x14(%r8),%xmm0
    5cbf:	f3 41 0f 11 87 84 00 	movss  %xmm0,0x84(%r15)
    5cc6:	00 00 
    5cc8:	75 16                	jne    5ce0 <ayatsuri_model_instance_evaluate+0x20e0>
    5cca:	e9 83 e9 ff ff       	jmp    4652 <ayatsuri_model_instance_evaluate+0xa52>
    5ccf:	90                   	nop
    5cd0:	0f b7 42 0c          	movzwl 0xc(%rdx),%eax
    5cd4:	48 83 c3 01          	add    $0x1,%rbx
    5cd8:	39 c3                	cmp    %eax,%ebx
    5cda:	0f 83 72 e9 ff ff    	jae    4652 <ayatsuri_model_instance_evaluate+0xa52>
    5ce0:	8b 4a 14             	mov    0x14(%rdx),%ecx
    5ce3:	48 89 d8             	mov    %rbx,%rax
    5ce6:	48 c1 e0 04          	shl    $0x4,%rax
    5cea:	48 03 02             	add    (%rdx),%rax
    5ced:	0f b6 44 01 02       	movzbl 0x2(%rcx,%rax,1),%eax
    5cf2:	3c 03                	cmp    $0x3,%al
    5cf4:	74 1e                	je     5d14 <ayatsuri_model_instance_evaluate+0x2114>
    5cf6:	84 c0                	test   %al,%al
    5cf8:	74 d6                	je     5cd0 <ayatsuri_model_instance_evaluate+0x20d0>
    5cfa:	41 8b 87 94 00 00 00 	mov    0x94(%r15),%eax
    5d01:	31 c9                	xor    %ecx,%ecx
    5d03:	83 f8 ff             	cmp    $0xffffffff,%eax
    5d06:	0f 95 c1             	setne  %cl
    5d09:	01 c8                	add    %ecx,%eax
    5d0b:	41 89 87 94 00 00 00 	mov    %eax,0x94(%r15)
    5d12:	eb bc                	jmp    5cd0 <ayatsuri_model_instance_evaluate+0x20d0>
    5d14:	45 31 c0             	xor    %r8d,%r8d
    5d17:	31 c9                	xor    %ecx,%ecx
    5d19:	31 d2                	xor    %edx,%edx
    5d1b:	41 b9 01 00 00 00    	mov    $0x1,%r9d
    5d21:	89 de                	mov    %ebx,%esi
    5d23:	4c 89 ff             	mov    %r15,%rdi
    5d26:	e8 d5 aa ff ff       	call   800 <mesh_packet>
    5d2b:	84 c0                	test   %al,%al
    5d2d:	0f 84 ad fa ff ff    	je     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    5d33:	49 8b 17             	mov    (%r15),%rdx
    5d36:	eb c2                	jmp    5cfa <ayatsuri_model_instance_evaluate+0x20fa>
    5d38:	48 89 c8             	mov    %rcx,%rax
    5d3b:	4c 29 f8             	sub    %r15,%rax
    5d3e:	48 3d a7 00 00 00    	cmp    $0xa7,%rax
    5d44:	0f 86 9b e0 ff ff    	jbe    3de5 <ayatsuri_model_instance_evaluate+0x1e5>
    5d4a:	e9 ef fe ff ff       	jmp    5c3e <ayatsuri_model_instance_evaluate+0x203e>
    5d4f:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 5d57 <ayatsuri_model_instance_evaluate+0x2157>
    5d56:	00 
			5d53: R_X86_64_PC32	.LC15-0x4
    5d57:	66 44 0f 28 c3       	movapd %xmm3,%xmm8
    5d5c:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5d60:	f3 44 0f 7e 0d 00 00 	movq   0x0(%rip),%xmm9        # 5d69 <ayatsuri_model_instance_evaluate+0x2169>
    5d67:	00 00 
			5d65: R_X86_64_PC32	.LC26-0x4
    5d69:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 5d71 <ayatsuri_model_instance_evaluate+0x2171>
    5d70:	00 
			5d6d: R_X86_64_PC32	.LC9-0x4
    5d71:	66 0f ef ff          	pxor   %xmm7,%xmm7
    5d75:	44 0f 29 8c 24 80 00 	movaps %xmm9,0x80(%rsp)
    5d7c:	00 00 
    5d7e:	e9 cb e1 ff ff       	jmp    3f4e <ayatsuri_model_instance_evaluate+0x34e>
    5d83:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5d87:	f2 0f 5a c1          	cvtsd2ss %xmm1,%xmm0
    5d8b:	e9 14 ec ff ff       	jmp    49a4 <ayatsuri_model_instance_evaluate+0xda4>
    5d90:	4c 89 c0             	mov    %r8,%rax
    5d93:	4c 29 f8             	sub    %r15,%rax
    5d96:	48 3d a7 00 00 00    	cmp    $0xa7,%rax
    5d9c:	0f 87 b5 fe ff ff    	ja     5c57 <ayatsuri_model_instance_evaluate+0x2057>
    5da2:	e9 3e e0 ff ff       	jmp    3de5 <ayatsuri_model_instance_evaluate+0x1e5>
    5da7:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    5dab:	e9 cf ec ff ff       	jmp    4a7f <ayatsuri_model_instance_evaluate+0xe7f>
    5db0:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 5db8 <ayatsuri_model_instance_evaluate+0x21b8>
    5db7:	00 
			5db4: R_X86_64_PC32	.LC33-0x4
    5db8:	e9 c2 ec ff ff       	jmp    4a7f <ayatsuri_model_instance_evaluate+0xe7f>
    5dbd:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    5dc1:	e9 4e ed ff ff       	jmp    4b14 <ayatsuri_model_instance_evaluate+0xf14>
    5dc6:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    5dca:	e9 40 ee ff ff       	jmp    4c0f <ayatsuri_model_instance_evaluate+0x100f>
    5dcf:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    5dd3:	e9 83 fc ff ff       	jmp    5a5b <ayatsuri_model_instance_evaluate+0x1e5b>
    5dd8:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    5dde:	e9 1c e8 ff ff       	jmp    45ff <ayatsuri_model_instance_evaluate+0x9ff>
    5de3:	f2 44 0f 10 9c 24 00 	movsd  0x300(%rsp),%xmm11
    5dea:	03 00 00 
    5ded:	f2 44 0f 10 84 24 08 	movsd  0x308(%rsp),%xmm8
    5df4:	03 00 00 
    5df7:	f2 0f 10 bc 24 18 03 	movsd  0x318(%rsp),%xmm7
    5dfe:	00 00 
    5e00:	f2 0f 10 84 24 20 03 	movsd  0x320(%rsp),%xmm0
    5e07:	00 00 
    5e09:	66 41 0f 28 eb       	movapd %xmm11,%xmm5
    5e0e:	66 41 0f 28 d8       	movapd %xmm8,%xmm3
    5e13:	f2 44 0f 10 8c 24 f8 	movsd  0x2f8(%rsp),%xmm9
    5e1a:	02 00 00 
    5e1d:	f2 0f 10 a4 24 10 03 	movsd  0x310(%rsp),%xmm4
    5e24:	00 00 
    5e26:	f2 0f 59 df          	mulsd  %xmm7,%xmm3
    5e2a:	66 45 0f 28 e8       	movapd %xmm8,%xmm13
    5e2f:	f2 0f 10 8c 24 e0 02 	movsd  0x2e0(%rsp),%xmm1
    5e36:	00 00 
    5e38:	f2 0f 10 b4 24 e8 02 	movsd  0x2e8(%rsp),%xmm6
    5e3f:	00 00 
    5e41:	f2 0f 59 e8          	mulsd  %xmm0,%xmm5
    5e45:	66 45 0f 28 e1       	movapd %xmm9,%xmm12
    5e4a:	66 45 0f 28 f9       	movapd %xmm9,%xmm15
    5e4f:	f2 0f 10 94 24 f0 02 	movsd  0x2f0(%rsp),%xmm2
    5e56:	00 00 
    5e58:	f2 44 0f 59 e7       	mulsd  %xmm7,%xmm12
    5e5d:	f2 44 0f 59 f8       	mulsd  %xmm0,%xmm15
    5e62:	f2 44 0f 59 ec       	mulsd  %xmm4,%xmm13
    5e67:	f2 0f 5c eb          	subsd  %xmm3,%xmm5
    5e6b:	66 41 0f 28 db       	movapd %xmm11,%xmm3
    5e70:	f2 0f 59 dc          	mulsd  %xmm4,%xmm3
    5e74:	f2 44 0f 11 7c 24 20 	movsd  %xmm15,0x20(%rsp)
    5e7b:	f2 0f 11 2c 24       	movsd  %xmm5,(%rsp)
    5e80:	f2 44 0f 5c e3       	subsd  %xmm3,%xmm12
    5e85:	f2 0f 10 1c 24       	movsd  (%rsp),%xmm3
    5e8a:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
    5e8e:	66 41 0f 28 ec       	movapd %xmm12,%xmm5
    5e93:	f2 44 0f 11 64 24 30 	movsd  %xmm12,0x30(%rsp)
    5e9a:	66 45 0f 28 e7       	movapd %xmm15,%xmm12
    5e9f:	f2 45 0f 5c e5       	subsd  %xmm13,%xmm12
    5ea4:	f2 44 0f 59 e6       	mulsd  %xmm6,%xmm12
    5ea9:	f2 41 0f 5c dc       	subsd  %xmm12,%xmm3
    5eae:	66 44 0f 28 e5       	movapd %xmm5,%xmm12
    5eb3:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 5ebb <ayatsuri_model_instance_evaluate+0x22bb>
    5eba:	00 
			5eb7: R_X86_64_PC32	.LC22-0x4
    5ebb:	f2 44 0f 59 e2       	mulsd  %xmm2,%xmm12
    5ec0:	f2 41 0f 58 dc       	addsd  %xmm12,%xmm3
    5ec5:	66 44 0f 28 e3       	movapd %xmm3,%xmm12
    5eca:	66 44 0f 54 25 00 00 	andpd  0x0(%rip),%xmm12        # 5ed3 <ayatsuri_model_instance_evaluate+0x22d3>
    5ed1:	00 00 
			5ecf: R_X86_64_PC32	.LC8-0x4
    5ed3:	66 41 0f 2e ec       	ucomisd %xmm12,%xmm5
    5ed8:	0f 82 02 f9 ff ff    	jb     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    5ede:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    5ee3:	66 41 0f 2e dc       	ucomisd %xmm12,%xmm3
    5ee8:	7a 06                	jp     5ef0 <ayatsuri_model_instance_evaluate+0x22f0>
    5eea:	0f 84 f0 f8 ff ff    	je     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    5ef0:	66 44 0f 28 fa       	movapd %xmm2,%xmm15
    5ef5:	66 44 0f 28 e3       	movapd %xmm3,%xmm12
    5efa:	f2 44 0f 5c 6c 24 20 	subsd  0x20(%rsp),%xmm13
    5f01:	31 ff                	xor    %edi,%edi
    5f03:	f2 44 0f 59 ff       	mulsd  %xmm7,%xmm15
    5f08:	66 45 0f 14 e4       	unpcklpd %xmm12,%xmm12
    5f0d:	f2 0f 59 f9          	mulsd  %xmm1,%xmm7
    5f11:	66 4c 0f 7e fa       	movq   %xmm15,%rdx
    5f16:	66 44 0f 28 fe       	movapd %xmm6,%xmm15
    5f1b:	f2 44 0f 59 f8       	mulsd  %xmm0,%xmm15
    5f20:	66 48 0f 6e ea       	movq   %rdx,%xmm5
    5f25:	48 8d 94 24 30 02 00 	lea    0x230(%rsp),%rdx
    5f2c:	00 
    5f2d:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    5f31:	f2 41 0f 5c ef       	subsd  %xmm15,%xmm5
    5f36:	f2 44 0f 10 3c 24    	movsd  (%rsp),%xmm15
    5f3c:	66 44 0f 14 fd       	unpcklpd %xmm5,%xmm15
    5f41:	66 41 0f 28 ef       	movapd %xmm15,%xmm5
    5f46:	66 44 0f 28 fe       	movapd %xmm6,%xmm15
    5f4b:	66 41 0f 5e ec       	divpd  %xmm12,%xmm5
    5f50:	f2 45 0f 59 f8       	mulsd  %xmm8,%xmm15
    5f55:	f2 44 0f 59 c1       	mulsd  %xmm1,%xmm8
    5f5a:	f2 41 0f 59 cb       	mulsd  %xmm11,%xmm1
    5f5f:	0f 29 ac 24 90 03 00 	movaps %xmm5,0x390(%rsp)
    5f66:	00 
    5f67:	66 0f 28 ea          	movapd %xmm2,%xmm5
    5f6b:	f2 41 0f 59 eb       	mulsd  %xmm11,%xmm5
    5f70:	f2 44 0f 5c fd       	subsd  %xmm5,%xmm15
    5f75:	66 41 0f 28 ef       	movapd %xmm15,%xmm5
    5f7a:	66 41 0f 14 ed       	unpcklpd %xmm13,%xmm5
    5f7f:	66 41 0f 5e ec       	divpd  %xmm12,%xmm5
    5f84:	0f 29 ac 24 a0 03 00 	movaps %xmm5,0x3a0(%rsp)
    5f8b:	00 
    5f8c:	66 0f 28 ea          	movapd %xmm2,%xmm5
    5f90:	f2 0f 59 ec          	mulsd  %xmm4,%xmm5
    5f94:	f2 41 0f 59 d1       	mulsd  %xmm9,%xmm2
    5f99:	f2 0f 59 e6          	mulsd  %xmm6,%xmm4
    5f9d:	f2 41 0f 59 f1       	mulsd  %xmm9,%xmm6
    5fa2:	f2 0f 5c c5          	subsd  %xmm5,%xmm0
    5fa6:	f2 41 0f 5c d0       	subsd  %xmm8,%xmm2
    5fab:	f2 0f 5c e7          	subsd  %xmm7,%xmm4
    5faf:	66 0f 14 c2          	unpcklpd %xmm2,%xmm0
    5fb3:	66 0f ef d2          	pxor   %xmm2,%xmm2
    5fb7:	66 41 0f 5e c4       	divpd  %xmm12,%xmm0
    5fbc:	f3 0f 5a 50 08       	cvtss2sd 0x8(%rax),%xmm2
    5fc1:	0f 29 84 24 b0 03 00 	movaps %xmm0,0x3b0(%rsp)
    5fc8:	00 
    5fc9:	f2 0f 10 44 24 30    	movsd  0x30(%rsp),%xmm0
    5fcf:	66 0f 14 c4          	unpcklpd %xmm4,%xmm0
    5fd3:	66 41 0f 5e c4       	divpd  %xmm12,%xmm0
    5fd8:	0f 29 84 24 c0 03 00 	movaps %xmm0,0x3c0(%rsp)
    5fdf:	00 
    5fe0:	66 0f 28 c1          	movapd %xmm1,%xmm0
    5fe4:	66 0f ef c9          	pxor   %xmm1,%xmm1
    5fe8:	f2 0f 5c c6          	subsd  %xmm6,%xmm0
    5fec:	f3 0f 5a 48 0c       	cvtss2sd 0xc(%rax),%xmm1
    5ff1:	f2 0f 5e c3          	divsd  %xmm3,%xmm0
    5ff5:	66 0f ef db          	pxor   %xmm3,%xmm3
    5ff9:	f3 0f 5a 58 04       	cvtss2sd 0x4(%rax),%xmm3
    5ffe:	f2 0f 11 84 24 d0 03 	movsd  %xmm0,0x3d0(%rsp)
    6005:	00 00 
    6007:	f2 41 0f 10 45 00    	movsd  0x0(%r13),%xmm0
    600d:	f2 41 0f 10 65 18    	movsd  0x18(%r13),%xmm4
    6013:	49 83 c5 08          	add    $0x8,%r13
    6017:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    601b:	f2 0f 59 c3          	mulsd  %xmm3,%xmm0
    601f:	f2 0f 58 c4          	addsd  %xmm4,%xmm0
    6023:	f2 41 0f 10 65 28    	movsd  0x28(%r13),%xmm4
    6029:	f2 0f 59 e1          	mulsd  %xmm1,%xmm4
    602d:	f2 0f 58 c4          	addsd  %xmm4,%xmm0
    6031:	f2 0f 11 04 3a       	movsd  %xmm0,(%rdx,%rdi,1)
    6036:	48 83 c7 08          	add    $0x8,%rdi
    603a:	48 83 ff 18          	cmp    $0x18,%rdi
    603e:	75 c7                	jne    6007 <ayatsuri_model_instance_evaluate+0x2407>
    6040:	f2 0f 10 84 24 30 02 	movsd  0x230(%rsp),%xmm0
    6047:	00 00 
    6049:	4d 8b 07             	mov    (%r15),%r8
    604c:	66 0f 57 84 24 80 00 	xorpd  0x80(%rsp),%xmm0
    6053:	00 00 
    6055:	f2 0f 10 8c 24 38 02 	movsd  0x238(%rsp),%xmm1
    605c:	00 00 
    605e:	f2 0f 59 84 24 f0 01 	mulsd  0x1f0(%rsp),%xmm0
    6065:	00 00 
    6067:	41 8b 78 14          	mov    0x14(%r8),%edi
    606b:	f2 0f 59 8c 24 f8 01 	mulsd  0x1f8(%rsp),%xmm1
    6072:	00 00 
    6074:	48 01 f9             	add    %rdi,%rcx
    6077:	49 03 08             	add    (%r8),%rcx
    607a:	0f b6 79 02          	movzbl 0x2(%rcx),%edi
    607e:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    6082:	f2 0f 10 8c 24 40 02 	movsd  0x240(%rsp),%xmm1
    6089:	00 00 
    608b:	f2 0f 59 8c 24 00 02 	mulsd  0x200(%rsp),%xmm1
    6092:	00 00 
    6094:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    6098:	66 0f ef c9          	pxor   %xmm1,%xmm1
    609c:	f3 0f 5a 48 10       	cvtss2sd 0x10(%rax),%xmm1
    60a1:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    60a5:	f2 0f 11 84 24 48 02 	movsd  %xmm0,0x248(%rsp)
    60ac:	00 00 
    60ae:	40 84 ff             	test   %dil,%dil
    60b1:	0f 84 d3 01 00 00    	je     628a <ayatsuri_model_instance_evaluate+0x268a>
    60b7:	40 80 ef 01          	sub    $0x1,%dil
    60bb:	0f 84 bf 01 00 00    	je     6280 <ayatsuri_model_instance_evaluate+0x2680>
    60c1:	0f b7 49 06          	movzwl 0x6(%rcx),%ecx
    60c5:	6b c9 6c             	imul   $0x6c,%ecx,%ecx
    60c8:	81 c1 3c 01 00 00    	add    $0x13c,%ecx
    60ce:	89 cf                	mov    %ecx,%edi
    60d0:	45 31 c0             	xor    %r8d,%r8d
    60d3:	c1 ef 02             	shr    $0x2,%edi
    60d6:	48 8d 3c be          	lea    (%rsi,%rdi,4),%rdi
    60da:	f2 42 0f 10 04 42    	movsd  (%rdx,%r8,2),%xmm0
    60e0:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 60e8 <ayatsuri_model_instance_evaluate+0x24e8>
    60e7:	00 
			60e4: R_X86_64_PC32	.LC22-0x4
    60e8:	66 0f 28 c8          	movapd %xmm0,%xmm1
    60ec:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 60f4 <ayatsuri_model_instance_evaluate+0x24f4>
    60f3:	00 
			60f0: R_X86_64_PC32	.LC8-0x4
    60f4:	66 0f 2e f9          	ucomisd %xmm1,%xmm7
    60f8:	0f 82 e2 f6 ff ff    	jb     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    60fe:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 6106 <ayatsuri_model_instance_evaluate+0x2506>
    6105:	00 
			6102: R_X86_64_PC32	.LC38-0x4
    6106:	0f 83 d4 f6 ff ff    	jae    57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    610c:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 6114 <ayatsuri_model_instance_evaluate+0x2514>
    6113:	00 
			6110: R_X86_64_PC32	.LC39-0x4
    6114:	0f 86 ec 00 00 00    	jbe    6206 <ayatsuri_model_instance_evaluate+0x2606>
    611a:	66 0f ef c9          	pxor   %xmm1,%xmm1
    611e:	66 0f 2f c8          	comisd %xmm0,%xmm1
    6122:	0f 87 d1 00 00 00    	ja     61f9 <ayatsuri_model_instance_evaluate+0x25f9>
    6128:	41 0f 28 c6          	movaps %xmm14,%xmm0
    612c:	f3 42 0f 11 04 07    	movss  %xmm0,(%rdi,%r8,1)
    6132:	e9 a9 f6 ff ff       	jmp    57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    6137:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 613f <ayatsuri_model_instance_evaluate+0x253f>
    613e:	00 
			613b: R_X86_64_PC32	.LC33-0x4
    613f:	e9 cb ea ff ff       	jmp    4c0f <ayatsuri_model_instance_evaluate+0x100f>
    6144:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 614c <ayatsuri_model_instance_evaluate+0x254c>
    614b:	00 
			6148: R_X86_64_PC32	.LC34-0x4
    614c:	e9 70 f7 ff ff       	jmp    58c1 <ayatsuri_model_instance_evaluate+0x1cc1>
    6151:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 6159 <ayatsuri_model_instance_evaluate+0x2559>
    6158:	00 
			6155: R_X86_64_PC32	.LC33-0x4
    6159:	e9 fd f8 ff ff       	jmp    5a5b <ayatsuri_model_instance_evaluate+0x1e5b>
    615e:	8b 7e 18             	mov    0x18(%rsi),%edi
    6161:	48 89 14 24          	mov    %rdx,(%rsp)
    6165:	e8 f6 9f ff ff       	call   160 <pack_rgb>
    616a:	48 8b 14 24          	mov    (%rsp),%rdx
    616e:	66 c7 85 f0 00 00 00 	movw   $0x4,0xf0(%rbp)
    6175:	04 00 
    6177:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 6180 <ayatsuri_model_instance_evaluate+0x2580>
    617e:	00 00 
			617c: R_X86_64_PC32	.LC0-0x4
    6180:	66 89 85 ea 00 00 00 	mov    %ax,0xea(%rbp)
    6187:	31 c0                	xor    %eax,%eax
    6189:	8b 7c 06 04          	mov    0x4(%rsi,%rax,1),%edi
    618d:	89 bc 05 c4 00 00 00 	mov    %edi,0xc4(%rbp,%rax,1)
    6194:	48 83 c0 04          	add    $0x4,%rax
    6198:	48 83 f8 14          	cmp    $0x14,%rax
    619c:	75 eb                	jne    6189 <ayatsuri_model_instance_evaluate+0x2589>
    619e:	c7 85 d8 00 00 00 00 	movl   $0x0,0xd8(%rbp)
    61a5:	00 00 00 
    61a8:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    61ae:	e9 42 e4 ff ff       	jmp    45f5 <ayatsuri_model_instance_evaluate+0x9f5>
    61b3:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 61bb <ayatsuri_model_instance_evaluate+0x25bb>
    61ba:	00 
			61b7: R_X86_64_PC32	.LC33-0x4
    61bb:	e9 89 ec ff ff       	jmp    4e49 <ayatsuri_model_instance_evaluate+0x1249>
    61c0:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    61c4:	e9 80 ec ff ff       	jmp    4e49 <ayatsuri_model_instance_evaluate+0x1249>
    61c9:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 61d1 <ayatsuri_model_instance_evaluate+0x25d1>
    61d0:	00 
			61cd: R_X86_64_PC32	.LC9-0x4
    61d1:	e9 67 f9 ff ff       	jmp    5b3d <ayatsuri_model_instance_evaluate+0x1f3d>
    61d6:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 61de <ayatsuri_model_instance_evaluate+0x25de>
    61dd:	00 
			61da: R_X86_64_PC32	.LC33-0x4
    61de:	e9 31 e9 ff ff       	jmp    4b14 <ayatsuri_model_instance_evaluate+0xf14>
    61e3:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 61eb <ayatsuri_model_instance_evaluate+0x25eb>
    61ea:	00 
			61e7: R_X86_64_PC32	.LC33-0x4
    61eb:	e9 bd ea ff ff       	jmp    4cad <ayatsuri_model_instance_evaluate+0x10ad>
    61f0:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    61f4:	e9 b4 ea ff ff       	jmp    4cad <ayatsuri_model_instance_evaluate+0x10ad>
    61f9:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 6201 <ayatsuri_model_instance_evaluate+0x2601>
    6200:	00 
			61fd: R_X86_64_PC32	.LC33-0x4
    6201:	e9 26 ff ff ff       	jmp    612c <ayatsuri_model_instance_evaluate+0x252c>
    6206:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    620a:	f3 42 0f 11 04 07    	movss  %xmm0,(%rdi,%r8,1)
    6210:	41 0f 54 c2          	andps  %xmm10,%xmm0
    6214:	0f 2f 05 00 00 00 00 	comiss 0x0(%rip),%xmm0        # 621b <ayatsuri_model_instance_evaluate+0x261b>
			6217: R_X86_64_PC32	.LC43-0x4
    621b:	0f 87 bf f5 ff ff    	ja     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    6221:	49 83 c0 04          	add    $0x4,%r8
    6225:	49 83 f8 10          	cmp    $0x10,%r8
    6229:	0f 85 ab fe ff ff    	jne    60da <ayatsuri_model_instance_evaluate+0x24da>
    622f:	66 0f ef c0          	pxor   %xmm0,%xmm0
    6233:	0f 2e 07             	ucomiss (%rdi),%xmm0
    6236:	7a 16                	jp     624e <ayatsuri_model_instance_evaluate+0x264e>
    6238:	75 14                	jne    624e <ayatsuri_model_instance_evaluate+0x264e>
    623a:	0f 2e 47 04          	ucomiss 0x4(%rdi),%xmm0
    623e:	7a 0e                	jp     624e <ayatsuri_model_instance_evaluate+0x264e>
    6240:	75 0c                	jne    624e <ayatsuri_model_instance_evaluate+0x264e>
    6242:	0f 2e 47 08          	ucomiss 0x8(%rdi),%xmm0
    6246:	7a 06                	jp     624e <ayatsuri_model_instance_evaluate+0x264e>
    6248:	0f 84 92 f5 ff ff    	je     57e0 <ayatsuri_model_instance_evaluate+0x1be0>
    624e:	8b 50 14             	mov    0x14(%rax),%edx
    6251:	89 57 10             	mov    %edx,0x10(%rdi)
    6254:	8b 78 18             	mov    0x18(%rax),%edi
    6257:	e8 04 9f ff ff       	call   160 <pack_rgb>
    625c:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 6265 <ayatsuri_model_instance_evaluate+0x2665>
    6263:	00 00 
			6261: R_X86_64_PC32	.LC0-0x4
    6265:	89 c2                	mov    %eax,%edx
    6267:	8d 41 14             	lea    0x14(%rcx),%eax
    626a:	66 89 14 06          	mov    %dx,(%rsi,%rax,1)
    626e:	66 c7 44 06 02 00 00 	movw   $0x0,0x2(%rsi,%rax,1)
    6275:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    627b:	e9 7f e3 ff ff       	jmp    45ff <ayatsuri_model_instance_evaluate+0x9ff>
    6280:	b9 08 01 00 00       	mov    $0x108,%ecx
    6285:	e9 44 fe ff ff       	jmp    60ce <ayatsuri_model_instance_evaluate+0x24ce>
    628a:	b9 54 00 00 00       	mov    $0x54,%ecx
    628f:	e9 3a fe ff ff       	jmp    60ce <ayatsuri_model_instance_evaluate+0x24ce>
    6294:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    629b:	00 00 00 00 
    629f:	90                   	nop

00000000000062a0 <ayatsuri_model_instance_next>:
    62a0:	48 85 ff             	test   %rdi,%rdi
    62a3:	0f 84 7e 00 00 00    	je     6327 <ayatsuri_model_instance_next+0x87>
    62a9:	80 bf a4 00 00 00 01 	cmpb   $0x1,0xa4(%rdi)
    62b0:	49 89 fa             	mov    %rdi,%r10
    62b3:	75 72                	jne    6327 <ayatsuri_model_instance_next+0x87>
    62b5:	48 85 f6             	test   %rsi,%rsi
    62b8:	74 6d                	je     6327 <ayatsuri_model_instance_next+0x87>
    62ba:	48 3b 77 10          	cmp    0x10(%rdi),%rsi
    62be:	75 67                	jne    6327 <ayatsuri_model_instance_next+0x87>
    62c0:	3b 57 20             	cmp    0x20(%rdi),%edx
    62c3:	75 62                	jne    6327 <ayatsuri_model_instance_next+0x87>
    62c5:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    62cc:	b8 04 00 00 00       	mov    $0x4,%eax
    62d1:	75 4a                	jne    631d <ayatsuri_model_instance_next+0x7d>
    62d3:	80 bf a6 00 00 00 00 	cmpb   $0x0,0xa6(%rdi)
    62da:	c6 87 a5 00 00 00 01 	movb   $0x1,0xa5(%rdi)
    62e1:	74 3d                	je     6320 <ayatsuri_model_instance_next+0x80>
    62e3:	48 85 c9             	test   %rcx,%rcx
    62e6:	74 28                	je     6310 <ayatsuri_model_instance_next+0x70>
    62e8:	4d 85 c0             	test   %r8,%r8
    62eb:	74 23                	je     6310 <ayatsuri_model_instance_next+0x70>
    62ed:	49 39 c8             	cmp    %rcx,%r8
    62f0:	73 3e                	jae    6330 <ayatsuri_model_instance_next+0x90>
    62f2:	48 89 c8             	mov    %rcx,%rax
    62f5:	4c 29 c0             	sub    %r8,%rax
    62f8:	48 83 f8 17          	cmp    $0x17,%rax
    62fc:	76 12                	jbe    6310 <ayatsuri_model_instance_next+0x70>
    62fe:	49 39 ca             	cmp    %rcx,%r10
    6301:	72 3d                	jb     6340 <ayatsuri_model_instance_next+0xa0>
    6303:	4c 89 d0             	mov    %r10,%rax
    6306:	48 29 c8             	sub    %rcx,%rax
    6309:	48 83 f8 03          	cmp    $0x3,%rax
    630d:	77 3f                	ja     634e <ayatsuri_model_instance_next+0xae>
    630f:	90                   	nop
    6310:	41 c6 82 a5 00 00 00 	movb   $0x0,0xa5(%r10)
    6317:	00 
    6318:	b8 01 00 00 00       	mov    $0x1,%eax
    631d:	c3                   	ret
    631e:	66 90                	xchg   %ax,%ax
    6320:	c6 87 a5 00 00 00 00 	movb   $0x0,0xa5(%rdi)
    6327:	b8 03 00 00 00       	mov    $0x3,%eax
    632c:	c3                   	ret
    632d:	0f 1f 00             	nopl   (%rax)
    6330:	4c 89 c0             	mov    %r8,%rax
    6333:	48 29 c8             	sub    %rcx,%rax
    6336:	48 83 f8 03          	cmp    $0x3,%rax
    633a:	76 d4                	jbe    6310 <ayatsuri_model_instance_next+0x70>
    633c:	eb c0                	jmp    62fe <ayatsuri_model_instance_next+0x5e>
    633e:	66 90                	xchg   %ax,%ax
    6340:	48 89 c8             	mov    %rcx,%rax
    6343:	4c 29 d0             	sub    %r10,%rax
    6346:	48 3d a7 00 00 00    	cmp    $0xa7,%rax
    634c:	76 c2                	jbe    6310 <ayatsuri_model_instance_next+0x70>
    634e:	49 8b 3a             	mov    (%r10),%rdi
    6351:	48 39 cf             	cmp    %rcx,%rdi
    6354:	0f 83 e6 01 00 00    	jae    6540 <ayatsuri_model_instance_next+0x2a0>
    635a:	48 89 c8             	mov    %rcx,%rax
    635d:	48 29 f8             	sub    %rdi,%rax
    6360:	48 83 f8 7f          	cmp    $0x7f,%rax
    6364:	76 aa                	jbe    6310 <ayatsuri_model_instance_next+0x70>
    6366:	49 8b 42 18          	mov    0x18(%r10),%rax
    636a:	49 8b 52 08          	mov    0x8(%r10),%rdx
    636e:	48 85 c0             	test   %rax,%rax
    6371:	74 1d                	je     6390 <ayatsuri_model_instance_next+0xf0>
    6373:	48 39 ca             	cmp    %rcx,%rdx
    6376:	0f 82 34 02 00 00    	jb     65b0 <ayatsuri_model_instance_next+0x310>
    637c:	48 89 d6             	mov    %rdx,%rsi
    637f:	48 29 ce             	sub    %rcx,%rsi
    6382:	48 83 fe 03          	cmp    $0x3,%rsi
    6386:	76 88                	jbe    6310 <ayatsuri_model_instance_next+0x70>
    6388:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    638f:	00 
    6390:	41 56                	push   %r14
    6392:	41 55                	push   %r13
    6394:	41 54                	push   %r12
    6396:	55                   	push   %rbp
    6397:	53                   	push   %rbx
    6398:	48 83 ec 18          	sub    $0x18,%rsp
    639c:	44 8b 4f 08          	mov    0x8(%rdi),%r9d
    63a0:	48 8b 1f             	mov    (%rdi),%rbx
    63a3:	4d 85 c9             	test   %r9,%r9
    63a6:	74 28                	je     63d0 <ayatsuri_model_instance_next+0x130>
    63a8:	48 39 cb             	cmp    %rcx,%rbx
    63ab:	0f 82 13 02 00 00    	jb     65c4 <ayatsuri_model_instance_next+0x324>
    63b1:	48 89 de             	mov    %rbx,%rsi
    63b4:	48 29 ce             	sub    %rcx,%rsi
    63b7:	48 83 fe 03          	cmp    $0x3,%rsi
    63bb:	0f 86 aa 01 00 00    	jbe    656b <ayatsuri_model_instance_next+0x2cb>
    63c1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    63c8:	00 00 00 00 
    63cc:	0f 1f 40 00          	nopl   0x0(%rax)
    63d0:	4d 39 c2             	cmp    %r8,%r10
    63d3:	0f 82 7f 01 00 00    	jb     6558 <ayatsuri_model_instance_next+0x2b8>
    63d9:	4c 89 d6             	mov    %r10,%rsi
    63dc:	4c 29 c6             	sub    %r8,%rsi
    63df:	48 83 fe 17          	cmp    $0x17,%rsi
    63e3:	0f 86 82 01 00 00    	jbe    656b <ayatsuri_model_instance_next+0x2cb>
    63e9:	4c 39 c7             	cmp    %r8,%rdi
    63ec:	0f 82 e2 01 00 00    	jb     65d4 <ayatsuri_model_instance_next+0x334>
    63f2:	48 89 fe             	mov    %rdi,%rsi
    63f5:	4c 29 c6             	sub    %r8,%rsi
    63f8:	48 83 fe 17          	cmp    $0x17,%rsi
    63fc:	0f 86 69 01 00 00    	jbe    656b <ayatsuri_model_instance_next+0x2cb>
    6402:	48 85 c0             	test   %rax,%rax
    6405:	74 19                	je     6420 <ayatsuri_model_instance_next+0x180>
    6407:	4c 39 c2             	cmp    %r8,%rdx
    640a:	0f 82 d5 01 00 00    	jb     65e5 <ayatsuri_model_instance_next+0x345>
    6410:	48 89 d0             	mov    %rdx,%rax
    6413:	4c 29 c0             	sub    %r8,%rax
    6416:	48 83 f8 17          	cmp    $0x17,%rax
    641a:	0f 86 4b 01 00 00    	jbe    656b <ayatsuri_model_instance_next+0x2cb>
    6420:	4d 85 c9             	test   %r9,%r9
    6423:	74 19                	je     643e <ayatsuri_model_instance_next+0x19e>
    6425:	4c 39 c3             	cmp    %r8,%rbx
    6428:	0f 82 cb 01 00 00    	jb     65f9 <ayatsuri_model_instance_next+0x359>
    642e:	48 89 d8             	mov    %rbx,%rax
    6431:	4c 29 c0             	sub    %r8,%rax
    6434:	48 83 f8 17          	cmp    $0x17,%rax
    6438:	0f 86 2d 01 00 00    	jbe    656b <ayatsuri_model_instance_next+0x2cb>
    643e:	8b 29                	mov    (%rcx),%ebp
    6440:	0f b7 77 0c          	movzwl 0xc(%rdi),%esi
    6444:	39 ee                	cmp    %ebp,%esi
    6446:	0f 82 1f 01 00 00    	jb     656b <ayatsuri_model_instance_next+0x2cb>
    644c:	39 f5                	cmp    %esi,%ebp
    644e:	0f 83 47 01 00 00    	jae    659b <ayatsuri_model_instance_next+0x2fb>
    6454:	44 8b 67 14          	mov    0x14(%rdi),%r12d
    6458:	89 e8                	mov    %ebp,%eax
    645a:	c1 e0 04             	shl    $0x4,%eax
    645d:	49 01 dc             	add    %rbx,%r12
    6460:	49 01 c4             	add    %rax,%r12
    6463:	89 e8                	mov    %ebp,%eax
    6465:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
    6469:	48 8d 44 c2 08       	lea    0x8(%rdx,%rax,8),%rax
    646e:	66 90                	xchg   %ax,%ax
    6470:	45 0f b6 6c 24 02    	movzbl 0x2(%r12),%r13d
    6476:	45 84 ed             	test   %r13b,%r13b
    6479:	0f 84 09 01 00 00    	je     6588 <ayatsuri_model_instance_next+0x2e8>
    647f:	80 78 09 00          	cmpb   $0x0,0x9(%rax)
    6483:	0f 84 ff 00 00 00    	je     6588 <ayatsuri_model_instance_next+0x2e8>
    6489:	44 8b 30             	mov    (%rax),%r14d
    648c:	49 01 d6             	add    %rdx,%r14
    648f:	41 80 fd 03          	cmp    $0x3,%r13b
    6493:	0f 85 74 01 00 00    	jne    660d <ayatsuri_model_instance_next+0x36d>
    6499:	41 80 7e 55 00       	cmpb   $0x0,0x55(%r14)
    649e:	0f 84 e4 00 00 00    	je     6588 <ayatsuri_model_instance_next+0x2e8>
    64a4:	89 ee                	mov    %ebp,%esi
    64a6:	4c 89 e2             	mov    %r12,%rdx
    64a9:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
    64ae:	41 bd 04 00 00 00    	mov    $0x4,%r13d
    64b4:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    64b9:	48 89 3c 24          	mov    %rdi,(%rsp)
    64bd:	e8 7e a2 ff ff       	call   740 <node_slot_bytes>
    64c2:	48 8b 3c 24          	mov    (%rsp),%rdi
    64c6:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
    64cb:	89 ee                	mov    %ebp,%esi
    64cd:	41 89 c3             	mov    %eax,%r11d
    64d0:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
    64d5:	4d 8d 4a 64          	lea    0x64(%r10),%r9
    64d9:	8b 47 78             	mov    0x78(%rdi),%eax
    64dc:	85 c0                	test   %eax,%eax
    64de:	74 1b                	je     64fb <ayatsuri_model_instance_next+0x25b>
    64e0:	41 0f b7 44 24 08    	movzwl 0x8(%r12),%eax
    64e6:	8b 57 74             	mov    0x74(%rdi),%edx
    64e9:	c1 e0 02             	shl    $0x2,%eax
    64ec:	48 01 c3             	add    %rax,%rbx
    64ef:	80 3c 13 01          	cmpb   $0x1,(%rbx,%rdx,1)
    64f3:	41 0f 94 c5          	sete   %r13b
    64f7:	41 83 c5 04          	add    $0x4,%r13d
    64fb:	41 0f b7 44 24 06    	movzwl 0x6(%r12),%eax
    6501:	83 c5 01             	add    $0x1,%ebp
    6504:	4d 89 30             	mov    %r14,(%r8)
    6507:	4d 89 48 08          	mov    %r9,0x8(%r8)
    650b:	41 88 40 15          	mov    %al,0x15(%r8)
    650f:	31 c0                	xor    %eax,%eax
    6511:	66 41 89 70 10       	mov    %si,0x10(%r8)
    6516:	66 45 89 58 12       	mov    %r11w,0x12(%r8)
    651b:	45 88 68 14          	mov    %r13b,0x14(%r8)
    651f:	89 29                	mov    %ebp,(%rcx)
    6521:	41 c6 82 a5 00 00 00 	movb   $0x0,0xa5(%r10)
    6528:	00 
    6529:	48 83 c4 18          	add    $0x18,%rsp
    652d:	5b                   	pop    %rbx
    652e:	5d                   	pop    %rbp
    652f:	41 5c                	pop    %r12
    6531:	41 5d                	pop    %r13
    6533:	41 5e                	pop    %r14
    6535:	c3                   	ret
    6536:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    653d:	00 00 00 
    6540:	48 89 f8             	mov    %rdi,%rax
    6543:	48 29 c8             	sub    %rcx,%rax
    6546:	48 83 f8 03          	cmp    $0x3,%rax
    654a:	0f 86 c0 fd ff ff    	jbe    6310 <ayatsuri_model_instance_next+0x70>
    6550:	e9 11 fe ff ff       	jmp    6366 <ayatsuri_model_instance_next+0xc6>
    6555:	0f 1f 00             	nopl   (%rax)
    6558:	4c 89 c6             	mov    %r8,%rsi
    655b:	4c 29 d6             	sub    %r10,%rsi
    655e:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    6565:	0f 87 7e fe ff ff    	ja     63e9 <ayatsuri_model_instance_next+0x149>
    656b:	41 c6 82 a5 00 00 00 	movb   $0x0,0xa5(%r10)
    6572:	00 
    6573:	48 83 c4 18          	add    $0x18,%rsp
    6577:	b8 01 00 00 00       	mov    $0x1,%eax
    657c:	5b                   	pop    %rbx
    657d:	5d                   	pop    %rbp
    657e:	41 5c                	pop    %r12
    6580:	41 5d                	pop    %r13
    6582:	41 5e                	pop    %r14
    6584:	c3                   	ret
    6585:	0f 1f 00             	nopl   (%rax)
    6588:	83 c5 01             	add    $0x1,%ebp
    658b:	49 83 c4 10          	add    $0x10,%r12
    658f:	48 83 c0 18          	add    $0x18,%rax
    6593:	39 ee                	cmp    %ebp,%esi
    6595:	0f 85 d5 fe ff ff    	jne    6470 <ayatsuri_model_instance_next+0x1d0>
    659b:	89 31                	mov    %esi,(%rcx)
    659d:	b8 05 00 00 00       	mov    $0x5,%eax
    65a2:	41 c6 82 a5 00 00 00 	movb   $0x0,0xa5(%r10)
    65a9:	00 
    65aa:	e9 7a ff ff ff       	jmp    6529 <ayatsuri_model_instance_next+0x289>
    65af:	90                   	nop
    65b0:	48 89 ce             	mov    %rcx,%rsi
    65b3:	48 29 d6             	sub    %rdx,%rsi
    65b6:	48 39 c6             	cmp    %rax,%rsi
    65b9:	0f 82 51 fd ff ff    	jb     6310 <ayatsuri_model_instance_next+0x70>
    65bf:	e9 cc fd ff ff       	jmp    6390 <ayatsuri_model_instance_next+0xf0>
    65c4:	48 89 ce             	mov    %rcx,%rsi
    65c7:	48 29 de             	sub    %rbx,%rsi
    65ca:	4c 39 ce             	cmp    %r9,%rsi
    65cd:	72 9c                	jb     656b <ayatsuri_model_instance_next+0x2cb>
    65cf:	e9 fc fd ff ff       	jmp    63d0 <ayatsuri_model_instance_next+0x130>
    65d4:	4c 89 c6             	mov    %r8,%rsi
    65d7:	48 29 fe             	sub    %rdi,%rsi
    65da:	48 83 fe 7f          	cmp    $0x7f,%rsi
    65de:	76 8b                	jbe    656b <ayatsuri_model_instance_next+0x2cb>
    65e0:	e9 1d fe ff ff       	jmp    6402 <ayatsuri_model_instance_next+0x162>
    65e5:	4c 89 c6             	mov    %r8,%rsi
    65e8:	48 29 d6             	sub    %rdx,%rsi
    65eb:	48 39 c6             	cmp    %rax,%rsi
    65ee:	0f 82 77 ff ff ff    	jb     656b <ayatsuri_model_instance_next+0x2cb>
    65f4:	e9 27 fe ff ff       	jmp    6420 <ayatsuri_model_instance_next+0x180>
    65f9:	4c 89 c0             	mov    %r8,%rax
    65fc:	48 29 d8             	sub    %rbx,%rax
    65ff:	4c 39 c8             	cmp    %r9,%rax
    6602:	0f 82 63 ff ff ff    	jb     656b <ayatsuri_model_instance_next+0x2cb>
    6608:	e9 31 fe ff ff       	jmp    643e <ayatsuri_model_instance_next+0x19e>
    660d:	89 ee                	mov    %ebp,%esi
    660f:	4c 89 e2             	mov    %r12,%rdx
    6612:	4c 89 44 24 08       	mov    %r8,0x8(%rsp)
    6617:	48 89 0c 24          	mov    %rcx,(%rsp)
    661b:	e8 20 a1 ff ff       	call   740 <node_slot_bytes>
    6620:	41 80 fd 02          	cmp    $0x2,%r13b
    6624:	48 8b 0c 24          	mov    (%rsp),%rcx
    6628:	89 ee                	mov    %ebp,%esi
    662a:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
    662f:	89 c3                	mov    %eax,%ebx
    6631:	4d 8d 4a 64          	lea    0x64(%r10),%r9
    6635:	41 89 c3             	mov    %eax,%r11d
    6638:	0f 85 bd fe ff ff    	jne    64fb <ayatsuri_model_instance_next+0x25b>
    663e:	4c 89 e7             	mov    %r12,%rdi
    6641:	e8 8a 9c ff ff       	call   2d0 <slot_bytes>
    6646:	39 d8                	cmp    %ebx,%eax
    6648:	0f 83 ad fe ff ff    	jae    64fb <ayatsuri_model_instance_next+0x25b>
    664e:	41 bd 03 00 00 00    	mov    $0x3,%r13d
    6654:	e9 a2 fe ff ff       	jmp    64fb <ayatsuri_model_instance_next+0x25b>
    6659:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000006660 <ayatsuri_model_instance_mesh_view>:
    6660:	48 89 f8             	mov    %rdi,%rax
    6663:	48 85 ff             	test   %rdi,%rdi
    6666:	0f 84 84 00 00 00    	je     66f0 <ayatsuri_model_instance_mesh_view+0x90>
    666c:	80 bf a4 00 00 00 01 	cmpb   $0x1,0xa4(%rdi)
    6673:	75 7b                	jne    66f0 <ayatsuri_model_instance_mesh_view+0x90>
    6675:	48 85 f6             	test   %rsi,%rsi
    6678:	74 76                	je     66f0 <ayatsuri_model_instance_mesh_view+0x90>
    667a:	48 3b 77 10          	cmp    0x10(%rdi),%rsi
    667e:	75 70                	jne    66f0 <ayatsuri_model_instance_mesh_view+0x90>
    6680:	3b 57 20             	cmp    0x20(%rdi),%edx
    6683:	75 6b                	jne    66f0 <ayatsuri_model_instance_mesh_view+0x90>
    6685:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    668c:	ba 04 00 00 00       	mov    $0x4,%edx
    6691:	75 62                	jne    66f5 <ayatsuri_model_instance_mesh_view+0x95>
    6693:	80 bf a6 00 00 00 00 	cmpb   $0x0,0xa6(%rdi)
    669a:	c6 87 a5 00 00 00 01 	movb   $0x1,0xa5(%rdi)
    66a1:	74 45                	je     66e8 <ayatsuri_model_instance_mesh_view+0x88>
    66a3:	4d 85 c0             	test   %r8,%r8
    66a6:	74 2e                	je     66d6 <ayatsuri_model_instance_mesh_view+0x76>
    66a8:	48 8b 17             	mov    (%rdi),%rdx
    66ab:	66 3b 4a 0c          	cmp    0xc(%rdx),%cx
    66af:	73 25                	jae    66d6 <ayatsuri_model_instance_mesh_view+0x76>
    66b1:	4c 39 c7             	cmp    %r8,%rdi
    66b4:	73 4a                	jae    6700 <ayatsuri_model_instance_mesh_view+0xa0>
    66b6:	4c 89 c6             	mov    %r8,%rsi
    66b9:	48 29 fe             	sub    %rdi,%rsi
    66bc:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    66c3:	76 11                	jbe    66d6 <ayatsuri_model_instance_mesh_view+0x76>
    66c5:	4c 39 c2             	cmp    %r8,%rdx
    66c8:	72 46                	jb     6710 <ayatsuri_model_instance_mesh_view+0xb0>
    66ca:	48 89 d6             	mov    %rdx,%rsi
    66cd:	4c 29 c6             	sub    %r8,%rsi
    66d0:	48 83 fe 17          	cmp    $0x17,%rsi
    66d4:	77 46                	ja     671c <ayatsuri_model_instance_mesh_view+0xbc>
    66d6:	ba 01 00 00 00       	mov    $0x1,%edx
    66db:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    66e2:	89 d0                	mov    %edx,%eax
    66e4:	c3                   	ret
    66e5:	0f 1f 00             	nopl   (%rax)
    66e8:	c6 87 a5 00 00 00 00 	movb   $0x0,0xa5(%rdi)
    66ef:	90                   	nop
    66f0:	ba 03 00 00 00       	mov    $0x3,%edx
    66f5:	89 d0                	mov    %edx,%eax
    66f7:	c3                   	ret
    66f8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    66ff:	00 
    6700:	48 89 fe             	mov    %rdi,%rsi
    6703:	4c 29 c6             	sub    %r8,%rsi
    6706:	48 83 fe 17          	cmp    $0x17,%rsi
    670a:	76 ca                	jbe    66d6 <ayatsuri_model_instance_mesh_view+0x76>
    670c:	eb b7                	jmp    66c5 <ayatsuri_model_instance_mesh_view+0x65>
    670e:	66 90                	xchg   %ax,%ax
    6710:	4c 89 c6             	mov    %r8,%rsi
    6713:	48 29 d6             	sub    %rdx,%rsi
    6716:	48 83 fe 7f          	cmp    $0x7f,%rsi
    671a:	76 ba                	jbe    66d6 <ayatsuri_model_instance_mesh_view+0x76>
    671c:	48 8b 70 18          	mov    0x18(%rax),%rsi
    6720:	48 8b 78 08          	mov    0x8(%rax),%rdi
    6724:	48 85 f6             	test   %rsi,%rsi
    6727:	74 17                	je     6740 <ayatsuri_model_instance_mesh_view+0xe0>
    6729:	4c 39 c7             	cmp    %r8,%rdi
    672c:	0f 82 de 00 00 00    	jb     6810 <ayatsuri_model_instance_mesh_view+0x1b0>
    6732:	48 89 fe             	mov    %rdi,%rsi
    6735:	4c 29 c6             	sub    %r8,%rsi
    6738:	48 83 fe 17          	cmp    $0x17,%rsi
    673c:	76 98                	jbe    66d6 <ayatsuri_model_instance_mesh_view+0x76>
    673e:	66 90                	xchg   %ax,%ax
    6740:	8b 72 08             	mov    0x8(%rdx),%esi
    6743:	4c 8b 12             	mov    (%rdx),%r10
    6746:	48 85 f6             	test   %rsi,%rsi
    6749:	0f 85 a1 00 00 00    	jne    67f0 <ayatsuri_model_instance_mesh_view+0x190>
    674f:	49 89 c9             	mov    %rcx,%r9
    6752:	8b 72 14             	mov    0x14(%rdx),%esi
    6755:	49 c1 e1 04          	shl    $0x4,%r9
    6759:	41 81 e1 f0 ff 0f 00 	and    $0xffff0,%r9d
    6760:	4c 01 ce             	add    %r9,%rsi
    6763:	4c 01 d6             	add    %r10,%rsi
    6766:	80 7e 02 03          	cmpb   $0x3,0x2(%rsi)
    676a:	0f 85 66 ff ff ff    	jne    66d6 <ayatsuri_model_instance_mesh_view+0x76>
    6770:	44 8b 4a 78          	mov    0x78(%rdx),%r9d
    6774:	45 85 c9             	test   %r9d,%r9d
    6777:	74 18                	je     6791 <ayatsuri_model_instance_mesh_view+0x131>
    6779:	0f b7 76 08          	movzwl 0x8(%rsi),%esi
    677d:	8b 52 74             	mov    0x74(%rdx),%edx
    6780:	c1 e6 02             	shl    $0x2,%esi
    6783:	49 01 f2             	add    %rsi,%r10
    6786:	41 80 3c 12 01       	cmpb   $0x1,(%r10,%rdx,1)
    678b:	0f 84 45 ff ff ff    	je     66d6 <ayatsuri_model_instance_mesh_view+0x76>
    6791:	0f b7 d1             	movzwl %cx,%edx
    6794:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
    6798:	48 8d 14 d7          	lea    (%rdi,%rdx,8),%rdx
    679c:	80 7a 11 00          	cmpb   $0x0,0x11(%rdx)
    67a0:	0f 84 30 ff ff ff    	je     66d6 <ayatsuri_model_instance_mesh_view+0x76>
    67a6:	8b 52 08             	mov    0x8(%rdx),%edx
    67a9:	48 01 d7             	add    %rdx,%rdi
    67ac:	0f b6 77 54          	movzbl 0x54(%rdi),%esi
    67b0:	48 8d 57 54          	lea    0x54(%rdi),%rdx
    67b4:	66 41 89 48 10       	mov    %cx,0x10(%r8)
    67b9:	49 89 10             	mov    %rdx,(%r8)
    67bc:	48 8d 14 f5 00 00 00 	lea    0x0(,%rsi,8),%rdx
    67c3:	00 
    67c4:	41 88 70 12          	mov    %sil,0x12(%r8)
    67c8:	81 e2 f8 07 00 00    	and    $0x7f8,%edx
    67ce:	48 8d 94 17 64 04 00 	lea    0x464(%rdi,%rdx,1),%rdx
    67d5:	00 
    67d6:	49 89 50 08          	mov    %rdx,0x8(%r8)
    67da:	31 d2                	xor    %edx,%edx
    67dc:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    67e3:	e9 0d ff ff ff       	jmp    66f5 <ayatsuri_model_instance_mesh_view+0x95>
    67e8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    67ef:	00 
    67f0:	4d 39 c2             	cmp    %r8,%r10
    67f3:	72 33                	jb     6828 <ayatsuri_model_instance_mesh_view+0x1c8>
    67f5:	4c 89 d6             	mov    %r10,%rsi
    67f8:	4c 29 c6             	sub    %r8,%rsi
    67fb:	48 83 fe 17          	cmp    $0x17,%rsi
    67ff:	0f 86 d1 fe ff ff    	jbe    66d6 <ayatsuri_model_instance_mesh_view+0x76>
    6805:	e9 45 ff ff ff       	jmp    674f <ayatsuri_model_instance_mesh_view+0xef>
    680a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    6810:	4d 89 c1             	mov    %r8,%r9
    6813:	49 29 f9             	sub    %rdi,%r9
    6816:	49 39 f1             	cmp    %rsi,%r9
    6819:	0f 82 b7 fe ff ff    	jb     66d6 <ayatsuri_model_instance_mesh_view+0x76>
    681f:	e9 1c ff ff ff       	jmp    6740 <ayatsuri_model_instance_mesh_view+0xe0>
    6824:	0f 1f 40 00          	nopl   0x0(%rax)
    6828:	4d 89 c1             	mov    %r8,%r9
    682b:	4d 29 d1             	sub    %r10,%r9
    682e:	49 39 f1             	cmp    %rsi,%r9
    6831:	0f 83 18 ff ff ff    	jae    674f <ayatsuri_model_instance_mesh_view+0xef>
    6837:	e9 9a fe ff ff       	jmp    66d6 <ayatsuri_model_instance_mesh_view+0x76>
    683c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000006840 <ayatsuri_model_instance_sided_mesh_view>:
    6840:	48 89 f8             	mov    %rdi,%rax
    6843:	48 85 ff             	test   %rdi,%rdi
    6846:	0f 84 84 00 00 00    	je     68d0 <ayatsuri_model_instance_sided_mesh_view+0x90>
    684c:	80 bf a4 00 00 00 01 	cmpb   $0x1,0xa4(%rdi)
    6853:	75 7b                	jne    68d0 <ayatsuri_model_instance_sided_mesh_view+0x90>
    6855:	48 85 f6             	test   %rsi,%rsi
    6858:	74 76                	je     68d0 <ayatsuri_model_instance_sided_mesh_view+0x90>
    685a:	48 3b 77 10          	cmp    0x10(%rdi),%rsi
    685e:	75 70                	jne    68d0 <ayatsuri_model_instance_sided_mesh_view+0x90>
    6860:	3b 57 20             	cmp    0x20(%rdi),%edx
    6863:	75 6b                	jne    68d0 <ayatsuri_model_instance_sided_mesh_view+0x90>
    6865:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    686c:	ba 04 00 00 00       	mov    $0x4,%edx
    6871:	75 62                	jne    68d5 <ayatsuri_model_instance_sided_mesh_view+0x95>
    6873:	80 bf a6 00 00 00 00 	cmpb   $0x0,0xa6(%rdi)
    687a:	c6 87 a5 00 00 00 01 	movb   $0x1,0xa5(%rdi)
    6881:	74 45                	je     68c8 <ayatsuri_model_instance_sided_mesh_view+0x88>
    6883:	4d 85 c0             	test   %r8,%r8
    6886:	74 2e                	je     68b6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6888:	48 8b 17             	mov    (%rdi),%rdx
    688b:	66 3b 4a 0c          	cmp    0xc(%rdx),%cx
    688f:	73 25                	jae    68b6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6891:	4c 39 c7             	cmp    %r8,%rdi
    6894:	73 4a                	jae    68e0 <ayatsuri_model_instance_sided_mesh_view+0xa0>
    6896:	4c 89 c6             	mov    %r8,%rsi
    6899:	48 29 fe             	sub    %rdi,%rsi
    689c:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    68a3:	76 11                	jbe    68b6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    68a5:	4c 39 c2             	cmp    %r8,%rdx
    68a8:	72 46                	jb     68f0 <ayatsuri_model_instance_sided_mesh_view+0xb0>
    68aa:	48 89 d6             	mov    %rdx,%rsi
    68ad:	4c 29 c6             	sub    %r8,%rsi
    68b0:	48 83 fe 27          	cmp    $0x27,%rsi
    68b4:	77 46                	ja     68fc <ayatsuri_model_instance_sided_mesh_view+0xbc>
    68b6:	ba 01 00 00 00       	mov    $0x1,%edx
    68bb:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    68c2:	89 d0                	mov    %edx,%eax
    68c4:	c3                   	ret
    68c5:	0f 1f 00             	nopl   (%rax)
    68c8:	c6 87 a5 00 00 00 00 	movb   $0x0,0xa5(%rdi)
    68cf:	90                   	nop
    68d0:	ba 03 00 00 00       	mov    $0x3,%edx
    68d5:	89 d0                	mov    %edx,%eax
    68d7:	c3                   	ret
    68d8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    68df:	00 
    68e0:	48 89 fe             	mov    %rdi,%rsi
    68e3:	4c 29 c6             	sub    %r8,%rsi
    68e6:	48 83 fe 27          	cmp    $0x27,%rsi
    68ea:	76 ca                	jbe    68b6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    68ec:	eb b7                	jmp    68a5 <ayatsuri_model_instance_sided_mesh_view+0x65>
    68ee:	66 90                	xchg   %ax,%ax
    68f0:	4c 89 c6             	mov    %r8,%rsi
    68f3:	48 29 d6             	sub    %rdx,%rsi
    68f6:	48 83 fe 7f          	cmp    $0x7f,%rsi
    68fa:	76 ba                	jbe    68b6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    68fc:	48 8b 78 18          	mov    0x18(%rax),%rdi
    6900:	48 8b 70 08          	mov    0x8(%rax),%rsi
    6904:	48 85 ff             	test   %rdi,%rdi
    6907:	74 17                	je     6920 <ayatsuri_model_instance_sided_mesh_view+0xe0>
    6909:	4c 39 c6             	cmp    %r8,%rsi
    690c:	0f 82 fe 00 00 00    	jb     6a10 <ayatsuri_model_instance_sided_mesh_view+0x1d0>
    6912:	48 89 f7             	mov    %rsi,%rdi
    6915:	4c 29 c7             	sub    %r8,%rdi
    6918:	48 83 ff 27          	cmp    $0x27,%rdi
    691c:	76 98                	jbe    68b6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    691e:	66 90                	xchg   %ax,%ax
    6920:	8b 7a 08             	mov    0x8(%rdx),%edi
    6923:	4c 8b 0a             	mov    (%rdx),%r9
    6926:	48 85 ff             	test   %rdi,%rdi
    6929:	0f 85 c1 00 00 00    	jne    69f0 <ayatsuri_model_instance_sided_mesh_view+0x1b0>
    692f:	49 89 ca             	mov    %rcx,%r10
    6932:	8b 7a 14             	mov    0x14(%rdx),%edi
    6935:	49 c1 e2 04          	shl    $0x4,%r10
    6939:	41 81 e2 f0 ff 0f 00 	and    $0xffff0,%r10d
    6940:	4c 01 d7             	add    %r10,%rdi
    6943:	4c 01 cf             	add    %r9,%rdi
    6946:	80 7f 02 03          	cmpb   $0x3,0x2(%rdi)
    694a:	0f 85 66 ff ff ff    	jne    68b6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6950:	44 8b 52 78          	mov    0x78(%rdx),%r10d
    6954:	45 85 d2             	test   %r10d,%r10d
    6957:	0f 84 59 ff ff ff    	je     68b6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    695d:	0f b7 7f 08          	movzwl 0x8(%rdi),%edi
    6961:	8b 52 74             	mov    0x74(%rdx),%edx
    6964:	c1 e7 02             	shl    $0x2,%edi
    6967:	49 01 f9             	add    %rdi,%r9
    696a:	41 80 3c 11 01       	cmpb   $0x1,(%r9,%rdx,1)
    696f:	0f 85 41 ff ff ff    	jne    68b6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6975:	0f b7 d1             	movzwl %cx,%edx
    6978:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
    697c:	48 8d 14 d6          	lea    (%rsi,%rdx,8),%rdx
    6980:	80 7a 11 00          	cmpb   $0x0,0x11(%rdx)
    6984:	0f 84 2c ff ff ff    	je     68b6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    698a:	44 8b 5a 08          	mov    0x8(%rdx),%r11d
    698e:	4e 8d 0c 1e          	lea    (%rsi,%r11,1),%r9
    6992:	41 0f b6 79 54       	movzbl 0x54(%r9),%edi
    6997:	66 41 89 48 20       	mov    %cx,0x20(%r8)
    699c:	8d 14 3f             	lea    (%rdi,%rdi,1),%edx
    699f:	41 89 fa             	mov    %edi,%r10d
    69a2:	01 d7                	add    %edx,%edi
    69a4:	48 63 d2             	movslq %edx,%rdx
    69a7:	45 88 50 22          	mov    %r10b,0x22(%r8)
    69ab:	8d 3c bd 6b 04 00 00 	lea    0x46b(,%rdi,4),%edi
    69b2:	81 e7 f8 1f 00 00    	and    $0x1ff8,%edi
    69b8:	4c 01 df             	add    %r11,%rdi
    69bb:	48 01 fe             	add    %rdi,%rsi
    69be:	49 8d 79 54          	lea    0x54(%r9),%rdi
    69c2:	49 89 38             	mov    %rdi,(%r8)
    69c5:	49 8d bc 91 64 04 00 	lea    0x464(%r9,%rdx,4),%rdi
    69cc:	00 
    69cd:	48 8d 14 56          	lea    (%rsi,%rdx,2),%rdx
    69d1:	49 89 50 18          	mov    %rdx,0x18(%r8)
    69d5:	31 d2                	xor    %edx,%edx
    69d7:	49 89 78 08          	mov    %rdi,0x8(%r8)
    69db:	49 89 70 10          	mov    %rsi,0x10(%r8)
    69df:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    69e6:	e9 ea fe ff ff       	jmp    68d5 <ayatsuri_model_instance_sided_mesh_view+0x95>
    69eb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    69f0:	4d 39 c1             	cmp    %r8,%r9
    69f3:	72 33                	jb     6a28 <ayatsuri_model_instance_sided_mesh_view+0x1e8>
    69f5:	4c 89 cf             	mov    %r9,%rdi
    69f8:	4c 29 c7             	sub    %r8,%rdi
    69fb:	48 83 ff 27          	cmp    $0x27,%rdi
    69ff:	0f 86 b1 fe ff ff    	jbe    68b6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6a05:	e9 25 ff ff ff       	jmp    692f <ayatsuri_model_instance_sided_mesh_view+0xef>
    6a0a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    6a10:	4d 89 c1             	mov    %r8,%r9
    6a13:	49 29 f1             	sub    %rsi,%r9
    6a16:	49 39 f9             	cmp    %rdi,%r9
    6a19:	0f 82 97 fe ff ff    	jb     68b6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6a1f:	e9 fc fe ff ff       	jmp    6920 <ayatsuri_model_instance_sided_mesh_view+0xe0>
    6a24:	0f 1f 40 00          	nopl   0x0(%rax)
    6a28:	4d 89 c2             	mov    %r8,%r10
    6a2b:	4d 29 ca             	sub    %r9,%r10
    6a2e:	49 39 fa             	cmp    %rdi,%r10
    6a31:	0f 83 f8 fe ff ff    	jae    692f <ayatsuri_model_instance_sided_mesh_view+0xef>
    6a37:	e9 7a fe ff ff       	jmp    68b6 <ayatsuri_model_instance_sided_mesh_view+0x76>
