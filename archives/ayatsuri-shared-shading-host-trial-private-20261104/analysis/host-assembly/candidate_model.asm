
analysis/host-assembly/candidate_model.o:     file format elf64-x86-64


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

0000000000000300 <ayatsuri_shade_terms_prepare.isra.0>:
     300:	41 56                	push   %r14
     302:	41 54                	push   %r12
     304:	49 89 d4             	mov    %rdx,%r12
     307:	55                   	push   %rbp
     308:	89 cd                	mov    %ecx,%ebp
     30a:	53                   	push   %rbx
     30b:	89 f3                	mov    %esi,%ebx
     30d:	48 83 ec 38          	sub    $0x38,%rsp
     311:	0f bf 17             	movswl (%rdi),%edx
     314:	0f bf 47 04          	movswl 0x4(%rdi),%eax
     318:	f3 0f 11 4c 24 1c    	movss  %xmm1,0x1c(%rsp)
     31e:	66 0f ef c9          	pxor   %xmm1,%xmm1
     322:	f3 0f 2a ca          	cvtsi2ss %edx,%xmm1
     326:	f3 0f 11 44 24 20    	movss  %xmm0,0x20(%rsp)
     32c:	0f bf 57 02          	movswl 0x2(%rdi),%edx
     330:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 338 <ayatsuri_shade_terms_prepare.isra.0+0x38>
     337:	00 
			334: R_X86_64_PC32	.LC14-0x4
     338:	f3 0f 11 6c 24 2c    	movss  %xmm5,0x2c(%rsp)
     33e:	f3 0f 11 5c 24 24    	movss  %xmm3,0x24(%rsp)
     344:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 34c <ayatsuri_shade_terms_prepare.isra.0+0x4c>
     34b:	00 
			348: R_X86_64_PC32	.LC0-0x4
     34c:	f3 0f 11 54 24 18    	movss  %xmm2,0x18(%rsp)
     352:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     356:	f3 0f 11 64 24 28    	movss  %xmm4,0x28(%rsp)
     35c:	f3 0f 11 4c 24 0c    	movss  %xmm1,0xc(%rsp)
     362:	66 0f ef c9          	pxor   %xmm1,%xmm1
     366:	f3 0f 2a ca          	cvtsi2ss %edx,%xmm1
     36a:	0f 28 e9             	movaps %xmm1,%xmm5
     36d:	66 0f ef c9          	pxor   %xmm1,%xmm1
     371:	f3 0f 2a c8          	cvtsi2ss %eax,%xmm1
     375:	f3 0f 59 e8          	mulss  %xmm0,%xmm5
     379:	0f 28 f1             	movaps %xmm1,%xmm6
     37c:	f3 0f 59 f0          	mulss  %xmm0,%xmm6
     380:	0f 28 fd             	movaps %xmm5,%xmm7
     383:	f3 0f 11 6c 24 10    	movss  %xmm5,0x10(%rsp)
     389:	0f 54 fb             	andps  %xmm3,%xmm7
     38c:	0f 28 cf             	movaps %xmm7,%xmm1
     38f:	0f 28 c6             	movaps %xmm6,%xmm0
     392:	f3 0f 11 74 24 14    	movss  %xmm6,0x14(%rsp)
     398:	0f 54 c3             	andps  %xmm3,%xmm0
     39b:	e8 00 00 00 00       	call   3a0 <ayatsuri_shade_terms_prepare.isra.0+0xa0>
			39c: R_X86_64_PLT32	fmaxf-0x4
     3a0:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
     3a6:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 3ae <ayatsuri_shade_terms_prepare.isra.0+0xae>
     3ad:	00 
			3aa: R_X86_64_PC32	.LC0-0x4
     3ae:	0f 54 cb             	andps  %xmm3,%xmm1
     3b1:	e8 00 00 00 00       	call   3b6 <ayatsuri_shade_terms_prepare.isra.0+0xb6>
			3b2: R_X86_64_PLT32	fmaxf-0x4
     3b6:	66 0f ef c9          	pxor   %xmm1,%xmm1
     3ba:	f3 0f 10 54 24 18    	movss  0x18(%rsp),%xmm2
     3c0:	f3 0f 10 7c 24 1c    	movss  0x1c(%rsp),%xmm7
     3c6:	0f 2f c1             	comiss %xmm1,%xmm0
     3c9:	f3 0f 10 74 24 20    	movss  0x20(%rsp),%xmm6
     3cf:	76 11                	jbe    3e2 <ayatsuri_shade_terms_prepare.isra.0+0xe2>
     3d1:	f3 0f 10 0d 00 00 00 	movss  0x0(%rip),%xmm1        # 3d9 <ayatsuri_shade_terms_prepare.isra.0+0xd9>
     3d8:	00 
			3d5: R_X86_64_PC32	.LC1-0x4
     3d9:	0f 2e c8             	ucomiss %xmm0,%xmm1
     3dc:	0f 83 0e 01 00 00    	jae    4f0 <ayatsuri_shade_terms_prepare.isra.0+0x1f0>
     3e2:	f3 0f 59 7c 24 10    	mulss  0x10(%rsp),%xmm7
     3e8:	66 0f ef c9          	pxor   %xmm1,%xmm1
     3ec:	f3 0f 59 74 24 0c    	mulss  0xc(%rsp),%xmm6
     3f2:	f3 0f 59 54 24 14    	mulss  0x14(%rsp),%xmm2
     3f8:	f3 0f 58 f7          	addss  %xmm7,%xmm6
     3fc:	f3 0f 58 d6          	addss  %xmm6,%xmm2
     400:	0f 28 c2             	movaps %xmm2,%xmm0
     403:	f3 0f 11 54 24 18    	movss  %xmm2,0x18(%rsp)
     409:	e8 00 00 00 00       	call   40e <ayatsuri_shade_terms_prepare.isra.0+0x10e>
			40a: R_X86_64_PLT32	fmaxf-0x4
     40e:	f3 0f 10 54 24 18    	movss  0x18(%rsp),%xmm2
     414:	66 0f ef c9          	pxor   %xmm1,%xmm1
     418:	0f 57 15 00 00 00 00 	xorps  0x0(%rip),%xmm2        # 41f <ayatsuri_shade_terms_prepare.isra.0+0x11f>
			41b: R_X86_64_PC32	.LC15-0x4
     41f:	66 41 0f 7e c6       	movd   %xmm0,%r14d
     424:	0f 28 c2             	movaps %xmm2,%xmm0
     427:	e8 00 00 00 00       	call   42c <ayatsuri_shade_terms_prepare.isra.0+0x12c>
			428: R_X86_64_PLT32	fmaxf-0x4
     42c:	66 0f ef e4          	pxor   %xmm4,%xmm4
     430:	0f 28 d8             	movaps %xmm0,%xmm3
     433:	40 84 ed             	test   %bpl,%bpl
     436:	74 74                	je     4ac <ayatsuri_shade_terms_prepare.isra.0+0x1ac>
     438:	66 41 0f 6e f6       	movd   %r14d,%xmm6
     43d:	0f 2f f4             	comiss %xmm4,%xmm6
     440:	76 6a                	jbe    4ac <ayatsuri_shade_terms_prepare.isra.0+0x1ac>
     442:	f3 0f 11 44 24 18    	movss  %xmm0,0x18(%rsp)
     448:	f3 0f 10 4c 24 28    	movss  0x28(%rsp),%xmm1
     44e:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
     454:	f3 0f 59 4c 24 10    	mulss  0x10(%rsp),%xmm1
     45a:	f3 0f 11 64 24 1c    	movss  %xmm4,0x1c(%rsp)
     460:	f3 0f 59 44 24 0c    	mulss  0xc(%rsp),%xmm0
     466:	f3 0f 58 c1          	addss  %xmm1,%xmm0
     46a:	f3 0f 10 4c 24 2c    	movss  0x2c(%rsp),%xmm1
     470:	f3 0f 59 4c 24 14    	mulss  0x14(%rsp),%xmm1
     476:	f3 0f 58 c1          	addss  %xmm1,%xmm0
     47a:	0f 28 cc             	movaps %xmm4,%xmm1
     47d:	e8 00 00 00 00       	call   482 <ayatsuri_shade_terms_prepare.isra.0+0x182>
			47e: R_X86_64_PLT32	fmaxf-0x4
     482:	66 0f ef e4          	pxor   %xmm4,%xmm4
     486:	f3 0f 10 5c 24 18    	movss  0x18(%rsp),%xmm3
     48c:	0f 2f c4             	comiss %xmm4,%xmm0
     48f:	76 1b                	jbe    4ac <ayatsuri_shade_terms_prepare.isra.0+0x1ac>
     491:	f3 41 0f 10 4c 24 0c 	movss  0xc(%r12),%xmm1
     498:	f3 0f 11 5c 24 0c    	movss  %xmm3,0xc(%rsp)
     49e:	e8 00 00 00 00       	call   4a3 <ayatsuri_shade_terms_prepare.isra.0+0x1a3>
			49f: R_X86_64_PLT32	powf-0x4
     4a3:	f3 0f 10 5c 24 0c    	movss  0xc(%rsp),%xmm3
     4a9:	0f 28 e0             	movaps %xmm0,%xmm4
     4ac:	66 0f ef c0          	pxor   %xmm0,%xmm0
     4b0:	66 41 0f 6e fe       	movd   %r14d,%xmm7
     4b5:	0f 28 cc             	movaps %xmm4,%xmm1
     4b8:	0f b6 db             	movzbl %bl,%ebx
     4bb:	f3 0f 2a c3          	cvtsi2ss %ebx,%xmm0
     4bf:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 4c7 <ayatsuri_shade_terms_prepare.isra.0+0x1c7>
     4c6:	00 
			4c3: R_X86_64_PC32	.LC16-0x4
     4c7:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 4cf <ayatsuri_shade_terms_prepare.isra.0+0x1cf>
     4ce:	00 
			4cb: R_X86_64_PC32	.LC17-0x4
     4cf:	0f 14 fb             	unpcklps %xmm3,%xmm7
     4d2:	48 83 c4 38          	add    $0x38,%rsp
     4d6:	5b                   	pop    %rbx
     4d7:	5d                   	pop    %rbp
     4d8:	41 5c                	pop    %r12
     4da:	41 5e                	pop    %r14
     4dc:	f3 0f 5c d0          	subss  %xmm0,%xmm2
     4e0:	0f 28 c7             	movaps %xmm7,%xmm0
     4e3:	0f 14 ca             	unpcklps %xmm2,%xmm1
     4e6:	c3                   	ret
     4e7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
     4ee:	00 00 
     4f0:	f3 0f 10 64 24 0c    	movss  0xc(%rsp),%xmm4
     4f6:	f3 0f 10 5c 24 10    	movss  0x10(%rsp),%xmm3
     4fc:	f3 0f 10 4c 24 14    	movss  0x14(%rsp),%xmm1
     502:	f3 0f 5e d8          	divss  %xmm0,%xmm3
     506:	f3 0f 5e e0          	divss  %xmm0,%xmm4
     50a:	0f 28 eb             	movaps %xmm3,%xmm5
     50d:	f3 0f 59 eb          	mulss  %xmm3,%xmm5
     511:	f3 0f 5e c8          	divss  %xmm0,%xmm1
     515:	0f 28 c4             	movaps %xmm4,%xmm0
     518:	f3 0f 59 c4          	mulss  %xmm4,%xmm0
     51c:	f3 0f 58 c5          	addss  %xmm5,%xmm0
     520:	0f 28 e9             	movaps %xmm1,%xmm5
     523:	f3 0f 59 e9          	mulss  %xmm1,%xmm5
     527:	f3 0f 58 c5          	addss  %xmm5,%xmm0
     52b:	f3 0f 51 c0          	sqrtss %xmm0,%xmm0
     52f:	f3 0f 5e e0          	divss  %xmm0,%xmm4
     533:	f3 0f 5e d8          	divss  %xmm0,%xmm3
     537:	f3 0f 11 64 24 0c    	movss  %xmm4,0xc(%rsp)
     53d:	f3 0f 5e c8          	divss  %xmm0,%xmm1
     541:	f3 0f 11 5c 24 10    	movss  %xmm3,0x10(%rsp)
     547:	f3 0f 11 4c 24 14    	movss  %xmm1,0x14(%rsp)
     54d:	e9 90 fe ff ff       	jmp    3e2 <ayatsuri_shade_terms_prepare.isra.0+0xe2>
     552:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     559:	00 00 00 00 
     55d:	0f 1f 00             	nopl   (%rax)

0000000000000560 <node_slot_bytes>:
     560:	0f b6 42 02          	movzbl 0x2(%rdx),%eax
     564:	89 f1                	mov    %esi,%ecx
     566:	3c 03                	cmp    $0x3,%al
     568:	74 2e                	je     598 <node_slot_bytes+0x38>
     56a:	be 54 00 00 00       	mov    $0x54,%esi
     56f:	84 c0                	test   %al,%al
     571:	74 1d                	je     590 <node_slot_bytes+0x30>
     573:	be 08 01 00 00       	mov    $0x108,%esi
     578:	3c 01                	cmp    $0x1,%al
     57a:	74 14                	je     590 <node_slot_bytes+0x30>
     57c:	44 0f b7 42 06       	movzwl 0x6(%rdx),%r8d
     581:	45 6b c0 6c          	imul   $0x6c,%r8d,%r8d
     585:	41 8d b0 3c 01 00 00 	lea    0x13c(%r8),%esi
     58c:	3c 02                	cmp    $0x2,%al
     58e:	74 58                	je     5e8 <node_slot_bytes+0x88>
     590:	89 f0                	mov    %esi,%eax
     592:	c3                   	ret
     593:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
     598:	0f b7 42 04          	movzwl 0x4(%rdx),%eax
     59c:	48 8b 0f             	mov    (%rdi),%rcx
     59f:	8b 77 54             	mov    0x54(%rdi),%esi
     5a2:	44 8b 47 78          	mov    0x78(%rdi),%r8d
     5a6:	c1 e0 05             	shl    $0x5,%eax
     5a9:	48 01 c8             	add    %rcx,%rax
     5ac:	0f b7 44 06 02       	movzwl 0x2(%rsi,%rax,1),%eax
     5b1:	8d 34 40             	lea    (%rax,%rax,2),%esi
     5b4:	8d 34 b5 6b 04 00 00 	lea    0x46b(,%rsi,4),%esi
     5bb:	83 e6 f8             	and    $0xfffffff8,%esi
     5be:	45 85 c0             	test   %r8d,%r8d
     5c1:	74 cd                	je     590 <node_slot_bytes+0x30>
     5c3:	0f b7 52 08          	movzwl 0x8(%rdx),%edx
     5c7:	8b 7f 74             	mov    0x74(%rdi),%edi
     5ca:	c1 e2 02             	shl    $0x2,%edx
     5cd:	48 01 d1             	add    %rdx,%rcx
     5d0:	80 3c 39 01          	cmpb   $0x1,(%rcx,%rdi,1)
     5d4:	75 ba                	jne    590 <node_slot_bytes+0x30>
     5d6:	8d 04 85 0f 00 00 00 	lea    0xf(,%rax,4),%eax
     5dd:	83 e0 f8             	and    $0xfffffff8,%eax
     5e0:	01 c6                	add    %eax,%esi
     5e2:	89 f0                	mov    %esi,%eax
     5e4:	c3                   	ret
     5e5:	0f 1f 00             	nopl   (%rax)
     5e8:	4c 8b 0f             	mov    (%rdi),%r9
     5eb:	8b 47 4c             	mov    0x4c(%rdi),%eax
     5ee:	8b 7f 50             	mov    0x50(%rdi),%edi
     5f1:	85 ff                	test   %edi,%edi
     5f3:	74 9b                	je     590 <node_slot_bytes+0x30>
     5f5:	31 d2                	xor    %edx,%edx
     5f7:	49 01 c1             	add    %rax,%r9
     5fa:	eb 0b                	jmp    607 <node_slot_bytes+0xa7>
     5fc:	0f 1f 40 00          	nopl   0x0(%rax)
     600:	83 c2 01             	add    $0x1,%edx
     603:	39 d7                	cmp    %edx,%edi
     605:	74 89                	je     590 <node_slot_bytes+0x30>
     607:	89 d0                	mov    %edx,%eax
     609:	c1 e0 05             	shl    $0x5,%eax
     60c:	41 0f b7 04 01       	movzwl (%r9,%rax,1),%eax
     611:	39 c1                	cmp    %eax,%ecx
     613:	75 eb                	jne    600 <node_slot_bytes+0xa0>
     615:	41 8d b0 54 01 00 00 	lea    0x154(%r8),%esi
     61c:	89 f0                	mov    %esi,%eax
     61e:	c3                   	ret
     61f:	90                   	nop

0000000000000620 <mesh_packet>:
     620:	41 57                	push   %r15
     622:	89 f0                	mov    %esi,%eax
     624:	41 56                	push   %r14
     626:	41 55                	push   %r13
     628:	45 89 cd             	mov    %r9d,%r13d
     62b:	41 54                	push   %r12
     62d:	49 89 fc             	mov    %rdi,%r12
     630:	55                   	push   %rbp
     631:	53                   	push   %rbx
     632:	48 81 ec f8 05 00 00 	sub    $0x5f8,%rsp
     639:	48 8b 37             	mov    (%rdi),%rsi
     63c:	44 88 8c 24 a7 00 00 	mov    %r9b,0xa7(%rsp)
     643:	00 
     644:	48 8b 1e             	mov    (%rsi),%rbx
     647:	8b 7e 14             	mov    0x14(%rsi),%edi
     64a:	48 89 74 24 70       	mov    %rsi,0x70(%rsp)
     64f:	89 c6                	mov    %eax,%esi
     651:	c7 84 24 a0 00 00 00 	movl   $0x0,0xa0(%rsp)
     658:	00 00 00 00 
     65c:	c1 e6 04             	shl    $0x4,%esi
     65f:	48 01 f7             	add    %rsi,%rdi
     662:	48 01 df             	add    %rbx,%rdi
     665:	80 7f 02 03          	cmpb   $0x3,0x2(%rdi)
     669:	0f b7 77 08          	movzwl 0x8(%rdi),%esi
     66d:	0f 84 45 04 00 00    	je     ab8 <mesh_packet+0x498>
     673:	4d 8b 4c 24 08       	mov    0x8(%r12),%r9
     678:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
     67c:	66 0f ef e4          	pxor   %xmm4,%xmm4
     680:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
     685:	4c 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%r10
     68c:	00 
     68d:	66 0f ef f6          	pxor   %xmm6,%xmm6
     691:	66 45 0f ef c9       	pxor   %xmm9,%xmm9
     696:	41 8b 44 c1 08       	mov    0x8(%r9,%rax,8),%eax
     69b:	66 0f ef ff          	pxor   %xmm7,%xmm7
     69f:	66 0f ef ed          	pxor   %xmm5,%xmm5
     6a3:	66 0f ef d2          	pxor   %xmm2,%xmm2
     6a7:	66 45 0f ef ff       	pxor   %xmm15,%xmm15
     6ac:	66 45 0f ef d2       	pxor   %xmm10,%xmm10
     6b1:	4c 89 94 24 60 01 00 	mov    %r10,0x160(%rsp)
     6b8:	00 
     6b9:	4c 01 c8             	add    %r9,%rax
     6bc:	f3 0f 5a 60 14       	cvtss2sd 0x14(%rax),%xmm4
     6c1:	66 0f 28 cc          	movapd %xmm4,%xmm1
     6c5:	f3 0f 5a 10          	cvtss2sd (%rax),%xmm2
     6c9:	f3 44 0f 5a 40 18    	cvtss2sd 0x18(%rax),%xmm8
     6cf:	f3 0f 5a 70 28       	cvtss2sd 0x28(%rax),%xmm6
     6d4:	66 41 0f 28 c0       	movapd %xmm8,%xmm0
     6d9:	f3 44 0f 5a 48 24    	cvtss2sd 0x24(%rax),%xmm9
     6df:	f3 0f 5a 78 10       	cvtss2sd 0x10(%rax),%xmm7
     6e4:	f2 0f 59 ce          	mulsd  %xmm6,%xmm1
     6e8:	f3 0f 5a 68 20       	cvtss2sd 0x20(%rax),%xmm5
     6ed:	66 44 0f 28 e7       	movapd %xmm7,%xmm12
     6f2:	66 45 0f 28 d8       	movapd %xmm8,%xmm11
     6f7:	f2 41 0f 59 c1       	mulsd  %xmm9,%xmm0
     6fc:	f3 44 0f 5a 78 04    	cvtss2sd 0x4(%rax),%xmm15
     702:	f3 44 0f 5a 50 08    	cvtss2sd 0x8(%rax),%xmm10
     708:	48 89 84 24 58 01 00 	mov    %rax,0x158(%rsp)
     70f:	00 
     710:	f2 44 0f 59 e6       	mulsd  %xmm6,%xmm12
     715:	f2 44 0f 59 dd       	mulsd  %xmm5,%xmm11
     71a:	66 0f 28 d9          	movapd %xmm1,%xmm3
     71e:	66 0f 28 cf          	movapd %xmm7,%xmm1
     722:	f2 0f 5c d8          	subsd  %xmm0,%xmm3
     726:	f2 41 0f 59 c9       	mulsd  %xmm9,%xmm1
     72b:	66 0f 28 c4          	movapd %xmm4,%xmm0
     72f:	f2 0f 59 c5          	mulsd  %xmm5,%xmm0
     733:	f2 44 0f 11 64 24 10 	movsd  %xmm12,0x10(%rsp)
     73a:	f2 44 0f 11 5c 24 20 	movsd  %xmm11,0x20(%rsp)
     741:	f2 0f 11 5c 24 08    	movsd  %xmm3,0x8(%rsp)
     747:	f2 0f 59 da          	mulsd  %xmm2,%xmm3
     74b:	f2 0f 5c c8          	subsd  %xmm0,%xmm1
     74f:	66 0f 28 c3          	movapd %xmm3,%xmm0
     753:	f2 0f 10 1d 00 00 00 	movsd  0x0(%rip),%xmm3        # 75b <mesh_packet+0x13b>
     75a:	00 
			757: R_X86_64_PC32	.LC18-0x4
     75b:	66 44 0f 28 f1       	movapd %xmm1,%xmm14
     760:	f2 0f 11 4c 24 50    	movsd  %xmm1,0x50(%rsp)
     766:	66 41 0f 28 cc       	movapd %xmm12,%xmm1
     76b:	f2 41 0f 5c cb       	subsd  %xmm11,%xmm1
     770:	f2 41 0f 59 cf       	mulsd  %xmm15,%xmm1
     775:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
     779:	66 41 0f 28 ce       	movapd %xmm14,%xmm1
     77e:	f2 41 0f 59 ca       	mulsd  %xmm10,%xmm1
     783:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
     787:	66 44 0f 28 f0       	movapd %xmm0,%xmm14
     78c:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 794 <mesh_packet+0x174>
     793:	00 
			790: R_X86_64_PC32	.LC8-0x4
     794:	66 0f 2e d8          	ucomisd %xmm0,%xmm3
     798:	0f 82 02 03 00 00    	jb     aa0 <mesh_packet+0x480>
     79e:	66 0f ef c0          	pxor   %xmm0,%xmm0
     7a2:	66 44 0f 2e f0       	ucomisd %xmm0,%xmm14
     7a7:	7a 06                	jp     7af <mesh_packet+0x18f>
     7a9:	0f 84 f1 02 00 00    	je     aa0 <mesh_packet+0x480>
     7af:	f3 44 0f 10 1d 00 00 	movss  0x0(%rip),%xmm11        # 7b8 <mesh_packet+0x198>
     7b6:	00 00 
			7b4: R_X86_64_PC32	.LC0-0x4
     7b8:	44 0f b7 5f 04       	movzwl 0x4(%rdi),%r11d
     7bd:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
     7c2:	8b 47 54             	mov    0x54(%rdi),%eax
     7c5:	41 c1 e3 05          	shl    $0x5,%r11d
     7c9:	44 8b 57 34          	mov    0x34(%rdi),%r10d
     7cd:	49 01 c3             	add    %rax,%r11
     7d0:	4a 8d 04 1b          	lea    (%rbx,%r11,1),%rax
     7d4:	0f b7 78 02          	movzwl 0x2(%rax),%edi
     7d8:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
     7dd:	0f b7 40 06          	movzwl 0x6(%rax),%eax
     7e1:	66 89 bc 24 7c 01 00 	mov    %di,0x17c(%rsp)
     7e8:	00 
     7e9:	66 89 84 24 7e 01 00 	mov    %ax,0x17e(%rsp)
     7f0:	00 
     7f1:	45 84 ed             	test   %r13b,%r13b
     7f4:	0f 85 a0 01 00 00    	jne    99a <mesh_packet+0x37a>
     7fa:	4c 8b b4 24 58 01 00 	mov    0x158(%rsp),%r14
     801:	00 
     802:	48 89 8c 24 f8 03 00 	mov    %rcx,0x3f8(%rsp)
     809:	00 
     80a:	31 c9                	xor    %ecx,%ecx
     80c:	4c 8d 9c 24 f0 03 00 	lea    0x3f0(%rsp),%r11
     813:	00 
     814:	4c 89 84 24 00 04 00 	mov    %r8,0x400(%rsp)
     81b:	00 
     81c:	4c 8d 84 24 c0 01 00 	lea    0x1c0(%rsp),%r8
     823:	00 
     824:	89 cd                	mov    %ecx,%ebp
     826:	f3 41 0f 10 46 0c    	movss  0xc(%r14),%xmm0
     82c:	f3 45 0f 10 6e 1c    	movss  0x1c(%r14),%xmm13
     832:	f2 44 0f 11 7c 24 58 	movsd  %xmm15,0x58(%rsp)
     839:	4c 89 c7             	mov    %r8,%rdi
     83c:	f3 41 0f 5c 44 24 34 	subss  0x34(%r12),%xmm0
     843:	f3 45 0f 5c 6c 24 38 	subss  0x38(%r12),%xmm13
     84a:	48 89 94 24 f0 03 00 	mov    %rdx,0x3f0(%rsp)
     851:	00 
     852:	66 44 0f 28 fa       	movapd %xmm2,%xmm15
     857:	f3 45 0f 10 66 2c    	movss  0x2c(%r14),%xmm12
     85d:	4c 89 44 24 60       	mov    %r8,0x60(%rsp)
     862:	4d 8d 4e 0c          	lea    0xc(%r14),%r9
     866:	f3 45 0f 5c 64 24 3c 	subss  0x3c(%r12),%xmm12
     86d:	f3 0f 11 44 24 30    	movss  %xmm0,0x30(%rsp)
     873:	f3 44 0f 11 6c 24 40 	movss  %xmm13,0x40(%rsp)
     87a:	48 83 f9 02          	cmp    $0x2,%rcx
     87e:	0f 84 ac 00 00 00    	je     930 <mesh_packet+0x310>
     884:	f3 45 0f 10 5c 24 40 	movss  0x40(%r12),%xmm11
     88b:	49 8b 14 cb          	mov    (%r11,%rcx,8),%rdx
     88f:	c1 e5 02             	shl    $0x2,%ebp
     892:	f3 0f 10 1a          	movss  (%rdx),%xmm3
     896:	f3 0f 10 4a 04       	movss  0x4(%rdx),%xmm1
     89b:	f3 0f 10 52 08       	movss  0x8(%rdx),%xmm2
     8a0:	4c 89 f2             	mov    %r14,%rdx
     8a3:	f3 44 0f 10 2a       	movss  (%rdx),%xmm13
     8a8:	f3 0f 10 42 10       	movss  0x10(%rdx),%xmm0
     8ad:	89 e8                	mov    %ebp,%eax
     8af:	48 83 c2 04          	add    $0x4,%rdx
     8b3:	83 c5 01             	add    $0x1,%ebp
     8b6:	f3 44 0f 59 eb       	mulss  %xmm3,%xmm13
     8bb:	f3 0f 59 c1          	mulss  %xmm1,%xmm0
     8bf:	f3 41 0f 58 c5       	addss  %xmm13,%xmm0
     8c4:	f3 44 0f 10 6a 1c    	movss  0x1c(%rdx),%xmm13
     8ca:	f3 44 0f 59 ea       	mulss  %xmm2,%xmm13
     8cf:	f3 41 0f 58 c5       	addss  %xmm13,%xmm0
     8d4:	f3 41 0f 59 c3       	mulss  %xmm11,%xmm0
     8d9:	f3 0f 11 84 84 c0 01 	movss  %xmm0,0x1c0(%rsp,%rax,4)
     8e0:	00 00 
     8e2:	49 39 d1             	cmp    %rdx,%r9
     8e5:	75 bc                	jne    8a3 <mesh_packet+0x283>
     8e7:	f3 0f 59 5c 24 30    	mulss  0x30(%rsp),%xmm3
     8ed:	48 83 c1 01          	add    $0x1,%rcx
     8f1:	48 83 c7 10          	add    $0x10,%rdi
     8f5:	f3 0f 59 4c 24 40    	mulss  0x40(%rsp),%xmm1
     8fb:	f3 41 0f 59 d4       	mulss  %xmm12,%xmm2
     900:	f3 0f 58 cb          	addss  %xmm3,%xmm1
     904:	f3 0f 58 ca          	addss  %xmm2,%xmm1
     908:	f3 41 0f 59 cb       	mulss  %xmm11,%xmm1
     90d:	f3 0f 11 4f fc       	movss  %xmm1,-0x4(%rdi)
     912:	48 83 f9 03          	cmp    $0x3,%rcx
     916:	74 28                	je     940 <mesh_packet+0x320>
     918:	f3 41 0f 58 4c 8c 40 	addss  0x40(%r12,%rcx,4),%xmm1
     91f:	89 cd                	mov    %ecx,%ebp
     921:	f3 0f 11 4f fc       	movss  %xmm1,-0x4(%rdi)
     926:	48 83 f9 02          	cmp    $0x2,%rcx
     92a:	0f 85 54 ff ff ff    	jne    884 <mesh_packet+0x264>
     930:	f3 44 0f 10 1d 00 00 	movss  0x0(%rip),%xmm11        # 939 <mesh_packet+0x319>
     937:	00 00 
			935: R_X86_64_PC32	.LC17-0x4
     939:	e9 4d ff ff ff       	jmp    88b <mesh_packet+0x26b>
     93e:	66 90                	xchg   %ax,%ax
     940:	66 41 0f 28 d7       	movapd %xmm15,%xmm2
     945:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
     94a:	f2 44 0f 10 7c 24 58 	movsd  0x58(%rsp),%xmm15
     951:	49 83 c0 30          	add    $0x30,%r8
     955:	f3 0f 10 0d 00 00 00 	movss  0x0(%rip),%xmm1        # 95d <mesh_packet+0x33d>
     95c:	00 
			959: R_X86_64_PC32	.LC1-0x4
     95d:	f3 44 0f 10 1d 00 00 	movss  0x0(%rip),%xmm11        # 966 <mesh_packet+0x346>
     964:	00 00 
			962: R_X86_64_PC32	.LC0-0x4
     966:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     96d:	00 00 00 00 
     971:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     978:	00 00 00 00 
     97c:	0f 1f 40 00          	nopl   0x0(%rax)
     980:	f3 0f 10 00          	movss  (%rax),%xmm0
     984:	41 0f 54 c3          	andps  %xmm11,%xmm0
     988:	0f 2e c8             	ucomiss %xmm0,%xmm1
     98b:	0f 82 0f 01 00 00    	jb     aa0 <mesh_packet+0x480>
     991:	48 83 c0 04          	add    $0x4,%rax
     995:	49 39 c0             	cmp    %rax,%r8
     998:	75 e6                	jne    980 <mesh_packet+0x360>
     99a:	48 8d 04 f6          	lea    (%rsi,%rsi,8),%rax
     99e:	44 89 d2             	mov    %r10d,%edx
     9a1:	f2 0f 11 ac 24 c8 00 	movsd  %xmm5,0xc8(%rsp)
     9a8:	00 00 
     9aa:	41 8b 6c 24 64       	mov    0x64(%r12),%ebp
     9af:	48 8d 04 c2          	lea    (%rdx,%rax,8),%rax
     9b3:	f2 0f 11 54 24 78    	movsd  %xmm2,0x78(%rsp)
     9b9:	48 01 d8             	add    %rbx,%rax
     9bc:	44 0f 29 5c 24 60    	movaps %xmm11,0x60(%rsp)
     9c2:	f2 0f 11 a4 24 98 00 	movsd  %xmm4,0x98(%rsp)
     9c9:	00 00 
     9cb:	f3 0f 6f 28          	movdqu (%rax),%xmm5
     9cf:	f3 41 0f 10 64 24 68 	movss  0x68(%r12),%xmm4
     9d6:	f2 0f 11 bc 24 90 00 	movsd  %xmm7,0x90(%rsp)
     9dd:	00 00 
     9df:	f3 0f 6f 78 10       	movdqu 0x10(%rax),%xmm7
     9e4:	0f 29 ac 24 40 01 00 	movaps %xmm5,0x140(%rsp)
     9eb:	00 
     9ec:	0f 28 cc             	movaps %xmm4,%xmm1
     9ef:	0f 29 ac 24 a0 01 00 	movaps %xmm5,0x1a0(%rsp)
     9f6:	00 
     9f7:	f3 41 0f 10 6c 24 6c 	movss  0x6c(%r12),%xmm5
     9fe:	41 0f 54 cb          	andps  %xmm11,%xmm1
     a02:	f2 44 0f 11 b4 24 e0 	movsd  %xmm14,0xe0(%rsp)
     a09:	00 00 00 
     a0c:	0f 28 c5             	movaps %xmm5,%xmm0
     a0f:	0f 29 7c 24 30       	movaps %xmm7,0x30(%rsp)
     a14:	41 0f 54 c3          	andps  %xmm11,%xmm0
     a18:	f3 0f 11 64 24 40    	movss  %xmm4,0x40(%rsp)
     a1e:	f2 0f 11 b4 24 d8 00 	movsd  %xmm6,0xd8(%rsp)
     a25:	00 00 
     a27:	f2 44 0f 11 8c 24 d0 	movsd  %xmm9,0xd0(%rsp)
     a2e:	00 00 00 
     a31:	f2 44 0f 11 84 24 b0 	movsd  %xmm8,0xb0(%rsp)
     a38:	00 00 00 
     a3b:	f2 44 0f 11 94 24 88 	movsd  %xmm10,0x88(%rsp)
     a42:	00 00 00 
     a45:	f2 44 0f 11 bc 24 80 	movsd  %xmm15,0x80(%rsp)
     a4c:	00 00 00 
     a4f:	0f 29 bc 24 b0 01 00 	movaps %xmm7,0x1b0(%rsp)
     a56:	00 
     a57:	f3 0f 11 6c 24 58    	movss  %xmm5,0x58(%rsp)
     a5d:	e8 00 00 00 00       	call   a62 <mesh_packet+0x442>
			a5e: R_X86_64_PLT32	fmaxf-0x4
     a62:	44 0f 28 5c 24 60    	movaps 0x60(%rsp),%xmm11
     a68:	66 0f 6e f5          	movd   %ebp,%xmm6
     a6c:	41 0f 54 f3          	andps  %xmm11,%xmm6
     a70:	0f 28 ce             	movaps %xmm6,%xmm1
     a73:	e8 00 00 00 00       	call   a78 <mesh_packet+0x458>
			a74: R_X86_64_PLT32	fmaxf-0x4
     a78:	66 0f ef f6          	pxor   %xmm6,%xmm6
     a7c:	0f 2f c6             	comiss %xmm6,%xmm0
     a7f:	76 1f                	jbe    aa0 <mesh_packet+0x480>
     a81:	f3 0f 10 3d 00 00 00 	movss  0x0(%rip),%xmm7        # a89 <mesh_packet+0x469>
     a88:	00 
			a85: R_X86_64_PC32	.LC1-0x4
     a89:	f3 0f 11 84 24 ac 00 	movss  %xmm0,0xac(%rsp)
     a90:	00 00 
     a92:	0f 2e f8             	ucomiss %xmm0,%xmm7
     a95:	73 69                	jae    b00 <mesh_packet+0x4e0>
     a97:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
     a9e:	00 00 
     aa0:	31 c0                	xor    %eax,%eax
     aa2:	48 81 c4 f8 05 00 00 	add    $0x5f8,%rsp
     aa9:	5b                   	pop    %rbx
     aaa:	5d                   	pop    %rbp
     aab:	41 5c                	pop    %r12
     aad:	41 5d                	pop    %r13
     aaf:	41 5e                	pop    %r14
     ab1:	41 5f                	pop    %r15
     ab3:	c3                   	ret
     ab4:	0f 1f 40 00          	nopl   0x0(%rax)
     ab8:	4c 8b 54 24 70       	mov    0x70(%rsp),%r10
     abd:	45 8b 4a 78          	mov    0x78(%r10),%r9d
     ac1:	45 85 c9             	test   %r9d,%r9d
     ac4:	0f 84 a9 fb ff ff    	je     673 <mesh_packet+0x53>
     aca:	45 8b 5a 74          	mov    0x74(%r10),%r11d
     ace:	4c 8d 0c b5 00 00 00 	lea    0x0(,%rsi,4),%r9
     ad5:	00 
     ad6:	41 81 e1 fc ff 03 00 	and    $0x3fffc,%r9d
     add:	49 01 db             	add    %rbx,%r11
     ae0:	43 80 3c 0b 01       	cmpb   $0x1,(%r11,%r9,1)
     ae5:	41 0f 94 c3          	sete   %r11b
     ae9:	45 0f b6 db          	movzbl %r11b,%r11d
     aed:	44 89 9c 24 a0 00 00 	mov    %r11d,0xa0(%rsp)
     af4:	00 
     af5:	e9 79 fb ff ff       	jmp    673 <mesh_packet+0x53>
     afa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
     b00:	45 8b 74 24 74       	mov    0x74(%r12),%r14d
     b05:	44 0f 28 5c 24 60    	movaps 0x60(%rsp),%xmm11
     b0b:	f3 41 0f 10 5c 24 78 	movss  0x78(%r12),%xmm3
     b12:	f3 41 0f 10 74 24 70 	movss  0x70(%r12),%xmm6
     b19:	66 41 0f 6e fe       	movd   %r14d,%xmm7
     b1e:	f3 0f 11 b4 24 a8 00 	movss  %xmm6,0xa8(%rsp)
     b25:	00 00 
     b27:	41 0f 54 fb          	andps  %xmm11,%xmm7
     b2b:	f3 0f 11 9c 24 b8 00 	movss  %xmm3,0xb8(%rsp)
     b32:	00 00 
     b34:	0f 28 cf             	movaps %xmm7,%xmm1
     b37:	0f 28 fb             	movaps %xmm3,%xmm7
     b3a:	41 0f 54 fb          	andps  %xmm11,%xmm7
     b3e:	0f 28 c7             	movaps %xmm7,%xmm0
     b41:	e8 00 00 00 00       	call   b46 <mesh_packet+0x526>
			b42: R_X86_64_PLT32	fmaxf-0x4
     b46:	44 0f 28 5c 24 60    	movaps 0x60(%rsp),%xmm11
     b4c:	f3 0f 10 b4 24 a8 00 	movss  0xa8(%rsp),%xmm6
     b53:	00 00 
     b55:	41 0f 54 f3          	andps  %xmm11,%xmm6
     b59:	0f 28 ce             	movaps %xmm6,%xmm1
     b5c:	e8 00 00 00 00       	call   b61 <mesh_packet+0x541>
			b5d: R_X86_64_PLT32	fmaxf-0x4
     b61:	66 0f ef ff          	pxor   %xmm7,%xmm7
     b65:	0f 2f c7             	comiss %xmm7,%xmm0
     b68:	44 0f 28 e8          	movaps %xmm0,%xmm13
     b6c:	0f 86 2e ff ff ff    	jbe    aa0 <mesh_packet+0x480>
     b72:	f3 0f 10 3d 00 00 00 	movss  0x0(%rip),%xmm7        # b7a <mesh_packet+0x55a>
     b79:	00 
			b76: R_X86_64_PC32	.LC1-0x4
     b7a:	0f 2e f8             	ucomiss %xmm0,%xmm7
     b7d:	0f 82 1d ff ff ff    	jb     aa0 <mesh_packet+0x480>
     b83:	f3 0f 10 4c 24 40    	movss  0x40(%rsp),%xmm1
     b89:	66 0f 6e fd          	movd   %ebp,%xmm7
     b8d:	f3 44 0f 10 a4 24 ac 	movss  0xac(%rsp),%xmm12
     b94:	00 00 00 
     b97:	f3 0f 10 6c 24 58    	movss  0x58(%rsp),%xmm5
     b9d:	44 0f 28 5c 24 60    	movaps 0x60(%rsp),%xmm11
     ba3:	f3 0f 10 9c 24 b8 00 	movss  0xb8(%rsp),%xmm3
     baa:	00 00 
     bac:	f3 41 0f 5e fc       	divss  %xmm12,%xmm7
     bb1:	44 0f 29 5c 24 40    	movaps %xmm11,0x40(%rsp)
     bb7:	f3 41 0f 5e cc       	divss  %xmm12,%xmm1
     bbc:	0f 28 e7             	movaps %xmm7,%xmm4
     bbf:	0f 28 c7             	movaps %xmm7,%xmm0
     bc2:	f3 0f 59 e7          	mulss  %xmm7,%xmm4
     bc6:	f3 41 0f 5e ec       	divss  %xmm12,%xmm5
     bcb:	0f 28 f9             	movaps %xmm1,%xmm7
     bce:	0f 28 d1             	movaps %xmm1,%xmm2
     bd1:	f3 0f 59 f9          	mulss  %xmm1,%xmm7
     bd5:	44 0f 28 e7          	movaps %xmm7,%xmm12
     bd9:	f3 44 0f 58 e4       	addss  %xmm4,%xmm12
     bde:	66 41 0f 6e e6       	movd   %r14d,%xmm4
     be3:	f3 41 0f 5e e5       	divss  %xmm13,%xmm4
     be8:	0f 28 fd             	movaps %xmm5,%xmm7
     beb:	f3 0f 59 fd          	mulss  %xmm5,%xmm7
     bef:	f3 44 0f 58 e7       	addss  %xmm7,%xmm12
     bf4:	0f 28 f8             	movaps %xmm0,%xmm7
     bf7:	f3 45 0f 51 e4       	sqrtss %xmm12,%xmm12
     bfc:	f3 41 0f 5e dd       	divss  %xmm13,%xmm3
     c01:	0f 28 c4             	movaps %xmm4,%xmm0
     c04:	f3 0f 59 c4          	mulss  %xmm4,%xmm0
     c08:	f3 41 0f 5e fc       	divss  %xmm12,%xmm7
     c0d:	0f 28 cb             	movaps %xmm3,%xmm1
     c10:	f3 41 0f 5e d4       	divss  %xmm12,%xmm2
     c15:	f3 0f 11 bc 24 bc 00 	movss  %xmm7,0xbc(%rsp)
     c1c:	00 00 
     c1e:	f3 41 0f 5e ec       	divss  %xmm12,%xmm5
     c23:	f3 44 0f 10 a4 24 a8 	movss  0xa8(%rsp),%xmm12
     c2a:	00 00 00 
     c2d:	f3 0f 11 94 24 c0 00 	movss  %xmm2,0xc0(%rsp)
     c34:	00 00 
     c36:	f3 45 0f 5e e5       	divss  %xmm13,%xmm12
     c3b:	f3 0f 11 ac 24 c4 00 	movss  %xmm5,0xc4(%rsp)
     c42:	00 00 
     c44:	45 0f 28 ec          	movaps %xmm12,%xmm13
     c48:	f3 45 0f 59 ec       	mulss  %xmm12,%xmm13
     c4d:	f3 41 0f 58 c5       	addss  %xmm13,%xmm0
     c52:	44 0f 28 eb          	movaps %xmm3,%xmm13
     c56:	f3 44 0f 59 eb       	mulss  %xmm3,%xmm13
     c5b:	f3 41 0f 58 c5       	addss  %xmm13,%xmm0
     c60:	f3 0f 51 c0          	sqrtss %xmm0,%xmm0
     c64:	f3 0f 5e c8          	divss  %xmm0,%xmm1
     c68:	f3 0f 5e e0          	divss  %xmm0,%xmm4
     c6c:	f3 0f 58 cd          	addss  %xmm5,%xmm1
     c70:	0f 28 e9             	movaps %xmm1,%xmm5
     c73:	f3 0f 11 ac 24 b8 00 	movss  %xmm5,0xb8(%rsp)
     c7a:	00 00 
     c7c:	f3 44 0f 5e e0       	divss  %xmm0,%xmm12
     c81:	0f 28 c5             	movaps %xmm5,%xmm0
     c84:	41 0f 54 c3          	andps  %xmm11,%xmm0
     c88:	f3 0f 58 e2          	addss  %xmm2,%xmm4
     c8c:	f3 0f 11 a4 24 ac 00 	movss  %xmm4,0xac(%rsp)
     c93:	00 00 
     c95:	0f 28 cc             	movaps %xmm4,%xmm1
     c98:	41 0f 54 cb          	andps  %xmm11,%xmm1
     c9c:	f3 44 0f 58 e7       	addss  %xmm7,%xmm12
     ca1:	f3 44 0f 11 a4 24 a8 	movss  %xmm12,0xa8(%rsp)
     ca8:	00 00 00 
     cab:	e8 00 00 00 00       	call   cb0 <mesh_packet+0x690>
			cac: R_X86_64_PLT32	fmaxf-0x4
     cb0:	44 0f 28 5c 24 40    	movaps 0x40(%rsp),%xmm11
     cb6:	f3 0f 10 8c 24 a8 00 	movss  0xa8(%rsp),%xmm1
     cbd:	00 00 
     cbf:	41 0f 54 cb          	andps  %xmm11,%xmm1
     cc3:	e8 00 00 00 00       	call   cc8 <mesh_packet+0x6a8>
			cc4: R_X86_64_PLT32	fmaxf-0x4
     cc8:	66 0f ef f6          	pxor   %xmm6,%xmm6
     ccc:	f2 0f 10 54 24 78    	movsd  0x78(%rsp),%xmm2
     cd2:	f2 44 0f 10 bc 24 80 	movsd  0x80(%rsp),%xmm15
     cd9:	00 00 00 
     cdc:	f2 44 0f 10 94 24 88 	movsd  0x88(%rsp),%xmm10
     ce3:	00 00 00 
     ce6:	0f 2f c6             	comiss %xmm6,%xmm0
     ce9:	f2 0f 10 bc 24 90 00 	movsd  0x90(%rsp),%xmm7
     cf0:	00 00 
     cf2:	f2 0f 10 a4 24 98 00 	movsd  0x98(%rsp),%xmm4
     cf9:	00 00 
     cfb:	f2 44 0f 10 84 24 b0 	movsd  0xb0(%rsp),%xmm8
     d02:	00 00 00 
     d05:	f2 0f 10 ac 24 c8 00 	movsd  0xc8(%rsp),%xmm5
     d0c:	00 00 
     d0e:	f2 44 0f 10 8c 24 d0 	movsd  0xd0(%rsp),%xmm9
     d15:	00 00 00 
     d18:	f2 0f 10 b4 24 d8 00 	movsd  0xd8(%rsp),%xmm6
     d1f:	00 00 
     d21:	f2 44 0f 10 b4 24 e0 	movsd  0xe0(%rsp),%xmm14
     d28:	00 00 00 
     d2b:	0f 86 24 11 00 00    	jbe    1e55 <mesh_packet+0x1835>
     d31:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # d39 <mesh_packet+0x719>
     d38:	00 
			d35: R_X86_64_PC32	.LC1-0x4
     d39:	c6 84 24 b0 00 00 00 	movb   $0x0,0xb0(%rsp)
     d40:	00 
     d41:	0f 2e d8             	ucomiss %xmm0,%xmm3
     d44:	0f 83 65 10 00 00    	jae    1daf <mesh_packet+0x178f>
     d4a:	48 8b 84 24 58 01 00 	mov    0x158(%rsp),%rax
     d51:	00 
     d52:	44 0f b7 94 24 7c 01 	movzwl 0x17c(%rsp),%r10d
     d59:	00 00 
     d5b:	4c 8d 98 64 04 00 00 	lea    0x464(%rax),%r11
     d62:	47 8d 34 12          	lea    (%r10,%r10,1),%r14d
     d66:	4b 8d 04 b3          	lea    (%r11,%r14,4),%rax
     d6a:	4c 89 f2             	mov    %r14,%rdx
     d6d:	48 89 84 24 98 01 00 	mov    %rax,0x198(%rsp)
     d74:	00 
     d75:	45 84 ed             	test   %r13b,%r13b
     d78:	0f 84 f0 0c 00 00    	je     1a6e <mesh_packet+0x144e>
     d7e:	48 8b 84 24 58 01 00 	mov    0x158(%rsp),%rax
     d85:	00 
     d86:	4c 8d 40 5c          	lea    0x5c(%rax),%r8
     d8a:	45 85 d2             	test   %r10d,%r10d
     d8d:	0f 84 b8 10 00 00    	je     1e4b <mesh_packet+0x182b>
     d93:	66 41 0f 28 c2       	movapd %xmm10,%xmm0
     d98:	66 41 0f 28 cf       	movapd %xmm15,%xmm1
     d9d:	42 8d 04 12          	lea    (%rdx,%r10,1),%eax
     da1:	31 ed                	xor    %ebp,%ebp
     da3:	f2 0f 59 ce          	mulsd  %xmm6,%xmm1
     da7:	66 41 0f 28 da       	movapd %xmm10,%xmm3
     dac:	8d 04 85 6b 04 00 00 	lea    0x46b(,%rax,4),%eax
     db3:	4c 89 44 24 60       	mov    %r8,0x60(%rsp)
     db8:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
     dbc:	89 c1                	mov    %eax,%ecx
     dbe:	4b 8d 04 b3          	lea    (%r11,%r14,4),%rax
     dc2:	48 89 de             	mov    %rbx,%rsi
     dc5:	f2 41 0f 59 c1       	mulsd  %xmm9,%xmm0
     dca:	81 e1 f8 ff 1f 00    	and    $0x1ffff8,%ecx
     dd0:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
     dd7:	00 
     dd8:	f2 0f 59 f2          	mulsd  %xmm2,%xmm6
     ddc:	48 89 8c 24 70 01 00 	mov    %rcx,0x170(%rsp)
     de3:	00 
     de4:	f2 41 0f 59 ef       	mulsd  %xmm15,%xmm5
     de9:	44 89 94 24 54 01 00 	mov    %r10d,0x154(%rsp)
     df0:	00 
     df1:	f2 44 0f 59 ca       	mulsd  %xmm2,%xmm9
     df6:	4c 89 9c 24 68 01 00 	mov    %r11,0x168(%rsp)
     dfd:	00 
     dfe:	44 89 ac 24 90 01 00 	mov    %r13d,0x190(%rsp)
     e05:	00 
     e06:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
     e0a:	f2 0f 10 4c 24 08    	movsd  0x8(%rsp),%xmm1
     e10:	89 94 24 94 01 00 00 	mov    %edx,0x194(%rsp)
     e17:	f2 0f 5c f3          	subsd  %xmm3,%xmm6
     e1b:	4c 89 b4 24 80 01 00 	mov    %r14,0x180(%rsp)
     e22:	00 
     e23:	45 89 fe             	mov    %r15d,%r14d
     e26:	f2 44 0f 11 b4 24 88 	movsd  %xmm14,0x188(%rsp)
     e2d:	01 00 00 
     e30:	66 0f 14 c8          	unpcklpd %xmm0,%xmm1
     e34:	66 41 0f 28 c6       	movapd %xmm14,%xmm0
     e39:	f2 41 0f 5c e9       	subsd  %xmm9,%xmm5
     e3e:	66 0f 14 c0          	unpcklpd %xmm0,%xmm0
     e42:	66 0f 5e c8          	divpd  %xmm0,%xmm1
     e46:	0f 29 8c 24 30 01 00 	movaps %xmm1,0x130(%rsp)
     e4d:	00 
     e4e:	f2 0f 10 4c 24 20    	movsd  0x20(%rsp),%xmm1
     e54:	f2 0f 5c 4c 24 10    	subsd  0x10(%rsp),%xmm1
     e5a:	89 6c 24 10          	mov    %ebp,0x10(%rsp)
     e5e:	66 0f 14 ce          	unpcklpd %xmm6,%xmm1
     e62:	66 0f 5e c8          	divpd  %xmm0,%xmm1
     e66:	0f 29 8c 24 10 01 00 	movaps %xmm1,0x110(%rsp)
     e6d:	00 
     e6e:	f2 0f 10 4c 24 50    	movsd  0x50(%rsp),%xmm1
     e74:	66 0f 14 cd          	unpcklpd %xmm5,%xmm1
     e78:	66 0f 5e c8          	divpd  %xmm0,%xmm1
     e7c:	66 41 0f 28 c7       	movapd %xmm15,%xmm0
     e81:	f2 41 0f 59 c0       	mulsd  %xmm8,%xmm0
     e86:	f2 44 0f 59 c2       	mulsd  %xmm2,%xmm8
     e8b:	0f 29 8c 24 20 01 00 	movaps %xmm1,0x120(%rsp)
     e92:	00 
     e93:	66 41 0f 28 ca       	movapd %xmm10,%xmm1
     e98:	f2 0f 59 cc          	mulsd  %xmm4,%xmm1
     e9c:	f2 44 0f 59 d7       	mulsd  %xmm7,%xmm10
     ea1:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
     ea5:	f2 41 0f 59 ff       	mulsd  %xmm15,%xmm7
     eaa:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
     eae:	f2 45 0f 5c d0       	subsd  %xmm8,%xmm10
     eb3:	f2 0f 5c e7          	subsd  %xmm7,%xmm4
     eb7:	f2 41 0f 5e c6       	divsd  %xmm14,%xmm0
     ebc:	f2 45 0f 5e d6       	divsd  %xmm14,%xmm10
     ec1:	f2 0f 11 84 24 f8 00 	movsd  %xmm0,0xf8(%rsp)
     ec8:	00 00 
     eca:	f2 41 0f 5e e6       	divsd  %xmm14,%xmm4
     ecf:	f2 44 0f 11 94 24 00 	movsd  %xmm10,0x100(%rsp)
     ed6:	01 00 00 
     ed9:	f2 0f 11 a4 24 08 01 	movsd  %xmm4,0x108(%rsp)
     ee0:	00 00 
     ee2:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     ee9:	00 00 00 00 
     eed:	0f 1f 00             	nopl   (%rax)
     ef0:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
     ef5:	8b 4c 24 10          	mov    0x10(%rsp),%ecx
     ef9:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
     efe:	0f b7 00             	movzwl (%rax),%eax
     f01:	8b 57 5c             	mov    0x5c(%rdi),%edx
     f04:	01 c8                	add    %ecx,%eax
     f06:	6b c0 1c             	imul   $0x1c,%eax,%eax
     f09:	48 01 d0             	add    %rdx,%rax
     f0c:	48 01 c6             	add    %rax,%rsi
     f0f:	80 bc 24 a7 00 00 00 	cmpb   $0x0,0xa7(%rsp)
     f16:	00 
     f17:	75 52                	jne    f6b <mesh_packet+0x94b>
     f19:	48 8b bc 24 68 01 00 	mov    0x168(%rsp),%rdi
     f20:	00 
     f21:	8d 44 09 01          	lea    0x1(%rcx,%rcx,1),%eax
     f25:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
     f2c:	00 
     f2d:	48 c1 e0 02          	shl    $0x2,%rax
     f31:	48 8d 0c 07          	lea    (%rdi,%rax,1),%rcx
     f35:	48 8d 54 07 fc       	lea    -0x4(%rdi,%rax,1),%rdx
     f3a:	48 8d bc 24 c0 01 00 	lea    0x1c0(%rsp),%rdi
     f41:	00 
     f42:	e8 49 f1 ff ff       	call   90 <mesh_project>
     f47:	84 c0                	test   %al,%al
     f49:	0f 84 51 fb ff ff    	je     aa0 <mesh_packet+0x480>
     f4f:	f3 0f 10 02          	movss  (%rdx),%xmm0
     f53:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
     f58:	f3 0f 11 07          	movss  %xmm0,(%rdi)
     f5c:	f3 0f 10 01          	movss  (%rcx),%xmm0
     f60:	f3 0f 11 47 04       	movss  %xmm0,0x4(%rdi)
     f65:	8b 46 18             	mov    0x18(%rsi),%eax
     f68:	89 47 08             	mov    %eax,0x8(%rdi)
     f6b:	66 0f ef c0          	pxor   %xmm0,%xmm0
     f6f:	66 0f ef db          	pxor   %xmm3,%xmm3
     f73:	66 0f ef c9          	pxor   %xmm1,%xmm1
     f77:	f3 0f 5a 46 0c       	cvtss2sd 0xc(%rsi),%xmm0
     f7c:	f3 0f 5a 5e 10       	cvtss2sd 0x10(%rsi),%xmm3
     f81:	66 0f 28 d0          	movapd %xmm0,%xmm2
     f85:	66 0f 28 e3          	movapd %xmm3,%xmm4
     f89:	66 0f 14 d2          	unpcklpd %xmm2,%xmm2
     f8d:	66 0f 14 e4          	unpcklpd %xmm4,%xmm4
     f91:	f3 0f 5a 4e 14       	cvtss2sd 0x14(%rsi),%xmm1
     f96:	66 0f 59 a4 24 10 01 	mulpd  0x110(%rsp),%xmm4
     f9d:	00 00 
     f9f:	66 0f 59 94 24 30 01 	mulpd  0x130(%rsp),%xmm2
     fa6:	00 00 
     fa8:	f2 0f 59 9c 24 00 01 	mulsd  0x100(%rsp),%xmm3
     faf:	00 00 
     fb1:	f2 0f 59 84 24 f8 00 	mulsd  0xf8(%rsp),%xmm0
     fb8:	00 00 
     fba:	66 0f 58 d4          	addpd  %xmm4,%xmm2
     fbe:	66 0f 28 e1          	movapd %xmm1,%xmm4
     fc2:	f2 0f 59 8c 24 08 01 	mulsd  0x108(%rsp),%xmm1
     fc9:	00 00 
     fcb:	66 0f 14 e4          	unpcklpd %xmm4,%xmm4
     fcf:	66 0f 59 a4 24 20 01 	mulpd  0x120(%rsp),%xmm4
     fd6:	00 00 
     fd8:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
     fdc:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
     fe0:	66 0f 58 d4          	addpd  %xmm4,%xmm2
     fe4:	66 48 0f 7e c3       	movq   %xmm0,%rbx
     fe9:	66 0f 28 f2          	movapd %xmm2,%xmm6
     fed:	66 0f 28 c2          	movapd %xmm2,%xmm0
     ff1:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
     ff6:	66 0f 15 f6          	unpckhpd %xmm6,%xmm6
     ffa:	66 0f 28 ce          	movapd %xmm6,%xmm1
     ffe:	e8 00 00 00 00       	call   1003 <mesh_packet+0x9e3>
			fff: R_X86_64_PLT32	hypot-0x4
    1003:	66 48 0f 6e cb       	movq   %rbx,%xmm1
    1008:	e8 00 00 00 00       	call   100d <mesh_packet+0x9ed>
			1009: R_X86_64_PLT32	hypot-0x4
    100d:	66 0f 28 d8          	movapd %xmm0,%xmm3
    1011:	f2 0f 11 44 24 08    	movsd  %xmm0,0x8(%rsp)
    1017:	66 0f ef c0          	pxor   %xmm0,%xmm0
    101b:	66 0f 2f d8          	comisd %xmm0,%xmm3
    101f:	0f 86 7b fa ff ff    	jbe    aa0 <mesh_packet+0x480>
    1025:	f2 0f 10 25 00 00 00 	movsd  0x0(%rip),%xmm4        # 102d <mesh_packet+0xa0d>
    102c:	00 
			1029: R_X86_64_PC32	.LC18-0x4
    102d:	66 0f 2e e3          	ucomisd %xmm3,%xmm4
    1031:	0f 82 69 fa ff ff    	jb     aa0 <mesh_packet+0x480>
    1037:	4c 8d bc 24 f0 03 00 	lea    0x3f0(%rsp),%r15
    103e:	00 
    103f:	66 0f 28 54 24 20    	movapd 0x20(%rsp),%xmm2
    1045:	45 31 ed             	xor    %r13d,%r13d
    1048:	48 89 9c 24 00 04 00 	mov    %rbx,0x400(%rsp)
    104f:	00 
    1050:	4c 89 bc 24 c8 00 00 	mov    %r15,0xc8(%rsp)
    1057:	00 
    1058:	48 8b 1d 00 00 00 00 	mov    0x0(%rip),%rbx        # 105f <mesh_packet+0xa3f>
			105b: R_X86_64_PC32	.LC8-0x4
    105f:	48 8d ac 24 70 02 00 	lea    0x270(%rsp),%rbp
    1066:	00 
    1067:	0f 29 94 24 f0 03 00 	movaps %xmm2,0x3f0(%rsp)
    106e:	00 
    106f:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 1077 <mesh_packet+0xa57>
    1076:	00 
			1073: R_X86_64_PC32	.LC20-0x4
    1077:	f2 43 0f 59 04 ef    	mulsd  (%r15,%r13,8),%xmm0
    107d:	66 48 0f 6e cb       	movq   %rbx,%xmm1
    1082:	f2 0f 5e 44 24 08    	divsd  0x8(%rsp),%xmm0
    1088:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 1090 <mesh_packet+0xa70>
    108f:	00 
			108c: R_X86_64_PC32	.LC6-0x4
    1090:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 1098 <mesh_packet+0xa78>
    1097:	00 
			1094: R_X86_64_PC32	.LC7-0x4
    1098:	66 0f 54 c8          	andpd  %xmm0,%xmm1
    109c:	66 0f 2e f1          	ucomisd %xmm1,%xmm6
    10a0:	76 38                	jbe    10da <mesh_packet+0xaba>
    10a2:	f2 48 0f 2c c0       	cvttsd2si %xmm0,%rax
    10a7:	66 0f ef c9          	pxor   %xmm1,%xmm1
    10ab:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 10b3 <mesh_packet+0xa93>
    10b2:	00 
			10af: R_X86_64_PC32	.LC9-0x4
    10b3:	f2 48 0f 2a c8       	cvtsi2sd %rax,%xmm1
    10b8:	66 0f 28 d1          	movapd %xmm1,%xmm2
    10bc:	f2 0f c2 d0 06       	cmpnlesd %xmm0,%xmm2
    10c1:	66 0f 54 d7          	andpd  %xmm7,%xmm2
    10c5:	f2 0f 5c ca          	subsd  %xmm2,%xmm1
    10c9:	66 48 0f 6e d3       	movq   %rbx,%xmm2
    10ce:	66 0f 55 d0          	andnpd %xmm0,%xmm2
    10d2:	66 0f 56 ca          	orpd   %xmm2,%xmm1
    10d6:	66 0f 28 c1          	movapd %xmm1,%xmm0
    10da:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 10e2 <mesh_packet+0xac2>
    10e1:	00 
			10de: R_X86_64_PC32	.LC20-0x4
    10e2:	e8 00 00 00 00       	call   10e7 <mesh_packet+0xac7>
			10e3: R_X86_64_PLT32	fmin-0x4
    10e7:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 10ef <mesh_packet+0xacf>
    10ee:	00 
			10eb: R_X86_64_PC32	.LC21-0x4
    10ef:	e8 00 00 00 00       	call   10f4 <mesh_packet+0xad4>
			10f0: R_X86_64_PLT32	fmax-0x4
    10f4:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    10f8:	66 42 89 44 6d 00    	mov    %ax,0x0(%rbp,%r13,2)
    10fe:	49 83 c5 01          	add    $0x1,%r13
    1102:	49 83 fd 03          	cmp    $0x3,%r13
    1106:	0f 85 63 ff ff ff    	jne    106f <mesh_packet+0xa4f>
    110c:	0f b7 84 24 70 02 00 	movzwl 0x270(%rsp),%eax
    1113:	00 
    1114:	66 0b 84 24 72 02 00 	or     0x272(%rsp),%ax
    111b:	00 
    111c:	66 0b 84 24 74 02 00 	or     0x274(%rsp),%ax
    1123:	00 
    1124:	0f 84 76 f9 ff ff    	je     aa0 <mesh_packet+0x480>
    112a:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
    112f:	48 89 ef             	mov    %rbp,%rdi
    1132:	f3 0f 10 8c 24 c0 00 	movss  0xc0(%rsp),%xmm1
    1139:	00 00 
    113b:	48 8d 94 24 a0 01 00 	lea    0x1a0(%rsp),%rdx
    1142:	00 
    1143:	f3 0f 10 84 24 bc 00 	movss  0xbc(%rsp),%xmm0
    114a:	00 00 
    114c:	f3 0f 10 ac 24 b8 00 	movss  0xb8(%rsp),%xmm5
    1153:	00 00 
    1155:	48 89 94 24 f0 00 00 	mov    %rdx,0xf0(%rsp)
    115c:	00 
    115d:	41 0f b6 77 12       	movzbl 0x12(%r15),%esi
    1162:	0f b6 8c 24 b0 00 00 	movzbl 0xb0(%rsp),%ecx
    1169:	00 
    116a:	f3 0f 10 a4 24 ac 00 	movss  0xac(%rsp),%xmm4
    1171:	00 00 
    1173:	f3 0f 10 9c 24 a8 00 	movss  0xa8(%rsp),%xmm3
    117a:	00 00 
    117c:	f3 0f 10 94 24 c4 00 	movss  0xc4(%rsp),%xmm2
    1183:	00 00 
    1185:	e8 76 f1 ff ff       	call   300 <ayatsuri_shade_terms_prepare.isra.0>
    118a:	66 0f 6f 64 24 30    	movdqa 0x30(%rsp),%xmm4
    1190:	45 0f b7 7f 0e       	movzwl 0xe(%r15),%r15d
    1195:	66 0f 6f ac 24 40 01 	movdqa 0x140(%rsp),%xmm5
    119c:	00 00 
    119e:	66 48 0f 7e c2       	movq   %xmm0,%rdx
    11a3:	66 48 0f 7e c8       	movq   %xmm1,%rax
    11a8:	f3 41 0f 10 4c 24 7c 	movss  0x7c(%r12),%xmm1
    11af:	f3 0f 11 a4 24 e8 00 	movss  %xmm4,0xe8(%rsp)
    11b6:	00 00 
    11b8:	0f 28 c4             	movaps %xmm4,%xmm0
    11bb:	0f c6 c4 55          	shufps $0x55,%xmm4,%xmm0
    11bf:	0f 28 d8             	movaps %xmm0,%xmm3
    11c2:	f3 0f 11 6c 24 20    	movss  %xmm5,0x20(%rsp)
    11c8:	f3 0f 11 84 24 50 01 	movss  %xmm0,0x150(%rsp)
    11cf:	00 00 
    11d1:	0f 28 c5             	movaps %xmm5,%xmm0
    11d4:	0f c6 c5 55          	shufps $0x55,%xmm5,%xmm0
    11d8:	0f 28 f0             	movaps %xmm0,%xmm6
    11db:	f3 0f 11 84 24 d0 00 	movss  %xmm0,0xd0(%rsp)
    11e2:	00 00 
    11e4:	66 0f 6e c2          	movd   %edx,%xmm0
    11e8:	0f 28 f8             	movaps %xmm0,%xmm7
    11eb:	48 c1 ea 20          	shr    $0x20,%rdx
    11ef:	f3 0f 59 fe          	mulss  %xmm6,%xmm7
    11f3:	0f 28 c7             	movaps %xmm7,%xmm0
    11f6:	f3 0f 11 7c 24 50    	movss  %xmm7,0x50(%rsp)
    11fc:	f3 0f 59 c1          	mulss  %xmm1,%xmm0
    1200:	0f 28 f0             	movaps %xmm0,%xmm6
    1203:	0f 28 c5             	movaps %xmm5,%xmm0
    1206:	0f 15 c5             	unpckhps %xmm5,%xmm0
    1209:	f3 0f 58 f5          	addss  %xmm5,%xmm6
    120d:	f3 0f 11 84 24 d8 00 	movss  %xmm0,0xd8(%rsp)
    1214:	00 00 
    1216:	0f 28 e8             	movaps %xmm0,%xmm5
    1219:	66 0f 6e c0          	movd   %eax,%xmm0
    121d:	48 c1 e8 20          	shr    $0x20,%rax
    1221:	0f 28 f8             	movaps %xmm0,%xmm7
    1224:	66 0f 6e c0          	movd   %eax,%xmm0
    1228:	44 89 f8             	mov    %r15d,%eax
    122b:	f3 0f 59 c4          	mulss  %xmm4,%xmm0
    122f:	66 c1 e8 0b          	shr    $0xb,%ax
    1233:	f3 0f 11 b4 24 88 00 	movss  %xmm6,0x88(%rsp)
    123a:	00 00 
    123c:	f3 0f 59 fd          	mulss  %xmm5,%xmm7
    1240:	66 0f 6e ea          	movd   %edx,%xmm5
    1244:	0f b7 c0             	movzwl %ax,%eax
    1247:	f3 0f 59 e8          	mulss  %xmm0,%xmm5
    124b:	f3 0f 11 7c 24 40    	movss  %xmm7,0x40(%rsp)
    1251:	f3 0f 59 dd          	mulss  %xmm5,%xmm3
    1255:	f3 0f 11 6c 24 58    	movss  %xmm5,0x58(%rsp)
    125b:	0f 28 c3             	movaps %xmm3,%xmm0
    125e:	f3 0f 58 c7          	addss  %xmm7,%xmm0
    1262:	0f 28 f8             	movaps %xmm0,%xmm7
    1265:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1269:	f3 0f 59 f9          	mulss  %xmm1,%xmm7
    126d:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1271:	f3 0f 2a c8          	cvtsi2ss %eax,%xmm1
    1275:	f3 0f 59 0d 00 00 00 	mulss  0x0(%rip),%xmm1        # 127d <mesh_packet+0xc5d>
    127c:	00 
			1279: R_X86_64_PC32	.LC22-0x4
    127d:	f3 0f 11 bc 24 90 00 	movss  %xmm7,0x90(%rsp)
    1284:	00 00 
    1286:	f3 0f 59 ce          	mulss  %xmm6,%xmm1
    128a:	f3 0f 58 cf          	addss  %xmm7,%xmm1
    128e:	0f 2f c1             	comiss %xmm1,%xmm0
    1291:	77 21                	ja     12b4 <mesh_packet+0xc94>
    1293:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 129b <mesh_packet+0xc7b>
    129a:	00 
			1297: R_X86_64_PC32	.LC17-0x4
    129b:	0f 28 c2             	movaps %xmm2,%xmm0
    129e:	f3 0f c2 c1 01       	cmpltss %xmm1,%xmm0
    12a3:	0f 54 d0             	andps  %xmm0,%xmm2
    12a6:	0f 55 c1             	andnps %xmm1,%xmm0
    12a9:	0f 56 c2             	orps   %xmm2,%xmm0
    12ac:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 12b4 <mesh_packet+0xc94>
    12b3:	00 
			12b0: R_X86_64_PC32	.LC23-0x4
    12b4:	e8 00 00 00 00       	call   12b9 <mesh_packet+0xc99>
			12b5: R_X86_64_PLT32	lroundf-0x4
    12b9:	66 0f 6f 5c 24 30    	movdqa 0x30(%rsp),%xmm3
    12bf:	f3 41 0f 10 8c 24 80 	movss  0x80(%r12),%xmm1
    12c6:	00 00 00 
    12c9:	f3 0f 10 74 24 20    	movss  0x20(%rsp),%xmm6
    12cf:	48 89 c3             	mov    %rax,%rbx
    12d2:	44 89 f8             	mov    %r15d,%eax
    12d5:	0f 28 c3             	movaps %xmm3,%xmm0
    12d8:	66 c1 e8 05          	shr    $0x5,%ax
    12dc:	0f 15 c3             	unpckhps %xmm3,%xmm0
    12df:	83 e0 3f             	and    $0x3f,%eax
    12e2:	f3 0f 11 84 24 e0 00 	movss  %xmm0,0xe0(%rsp)
    12e9:	00 00 
    12eb:	0f 28 e0             	movaps %xmm0,%xmm4
    12ee:	f3 0f 10 44 24 50    	movss  0x50(%rsp),%xmm0
    12f4:	f3 0f 59 64 24 58    	mulss  0x58(%rsp),%xmm4
    12fa:	f3 0f 59 c1          	mulss  %xmm1,%xmm0
    12fe:	f3 0f 58 f0          	addss  %xmm0,%xmm6
    1302:	f3 0f 10 44 24 40    	movss  0x40(%rsp),%xmm0
    1308:	f3 0f 58 c4          	addss  %xmm4,%xmm0
    130c:	f3 0f 11 74 24 78    	movss  %xmm6,0x78(%rsp)
    1312:	0f 28 e8             	movaps %xmm0,%xmm5
    1315:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1319:	f3 0f 59 e9          	mulss  %xmm1,%xmm5
    131d:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1321:	f3 0f 2a c8          	cvtsi2ss %eax,%xmm1
    1325:	f3 0f 59 0d 00 00 00 	mulss  0x0(%rip),%xmm1        # 132d <mesh_packet+0xd0d>
    132c:	00 
			1329: R_X86_64_PC32	.LC24-0x4
    132d:	f3 0f 11 ac 24 80 00 	movss  %xmm5,0x80(%rsp)
    1334:	00 00 
    1336:	f3 0f 59 ce          	mulss  %xmm6,%xmm1
    133a:	f3 0f 58 cd          	addss  %xmm5,%xmm1
    133e:	0f 2f c1             	comiss %xmm1,%xmm0
    1341:	77 21                	ja     1364 <mesh_packet+0xd44>
    1343:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 134b <mesh_packet+0xd2b>
    134a:	00 
			1347: R_X86_64_PC32	.LC17-0x4
    134b:	0f 28 c2             	movaps %xmm2,%xmm0
    134e:	f3 0f c2 c1 01       	cmpltss %xmm1,%xmm0
    1353:	0f 54 d0             	andps  %xmm0,%xmm2
    1356:	0f 55 c1             	andnps %xmm1,%xmm0
    1359:	0f 56 c2             	orps   %xmm2,%xmm0
    135c:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 1364 <mesh_packet+0xd44>
    1363:	00 
			1360: R_X86_64_PC32	.LC25-0x4
    1364:	e8 00 00 00 00       	call   1369 <mesh_packet+0xd49>
			1365: R_X86_64_PLT32	lroundf-0x4
    1369:	66 0f 6f 6c 24 30    	movdqa 0x30(%rsp),%xmm5
    136f:	f3 0f 10 5c 24 20    	movss  0x20(%rsp),%xmm3
    1375:	41 83 e7 1f          	and    $0x1f,%r15d
    1379:	f3 41 0f 10 8c 24 84 	movss  0x84(%r12),%xmm1
    1380:	00 00 00 
    1383:	49 89 c5             	mov    %rax,%r13
    1386:	0f 28 c5             	movaps %xmm5,%xmm0
    1389:	0f c6 c5 ff          	shufps $0xff,%xmm5,%xmm0
    138d:	0f 28 f8             	movaps %xmm0,%xmm7
    1390:	f3 0f 11 84 24 ec 00 	movss  %xmm0,0xec(%rsp)
    1397:	00 00 
    1399:	f3 0f 10 44 24 50    	movss  0x50(%rsp),%xmm0
    139f:	f3 0f 59 c1          	mulss  %xmm1,%xmm0
    13a3:	f3 0f 58 d8          	addss  %xmm0,%xmm3
    13a7:	f3 0f 10 44 24 58    	movss  0x58(%rsp),%xmm0
    13ad:	f3 0f 59 c7          	mulss  %xmm7,%xmm0
    13b1:	f3 0f 58 44 24 40    	addss  0x40(%rsp),%xmm0
    13b7:	f3 0f 11 5c 24 50    	movss  %xmm3,0x50(%rsp)
    13bd:	0f 28 f0             	movaps %xmm0,%xmm6
    13c0:	66 0f ef c0          	pxor   %xmm0,%xmm0
    13c4:	f3 0f 59 f1          	mulss  %xmm1,%xmm6
    13c8:	66 0f ef c9          	pxor   %xmm1,%xmm1
    13cc:	f3 41 0f 2a cf       	cvtsi2ss %r15d,%xmm1
    13d1:	f3 0f 59 0d 00 00 00 	mulss  0x0(%rip),%xmm1        # 13d9 <mesh_packet+0xdb9>
    13d8:	00 
			13d5: R_X86_64_PC32	.LC22-0x4
    13d9:	f3 0f 11 74 24 40    	movss  %xmm6,0x40(%rsp)
    13df:	f3 0f 59 cb          	mulss  %xmm3,%xmm1
    13e3:	f3 0f 58 ce          	addss  %xmm6,%xmm1
    13e7:	0f 2f c1             	comiss %xmm1,%xmm0
    13ea:	77 21                	ja     140d <mesh_packet+0xded>
    13ec:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 13f4 <mesh_packet+0xdd4>
    13f3:	00 
			13f0: R_X86_64_PC32	.LC17-0x4
    13f4:	0f 28 c2             	movaps %xmm2,%xmm0
    13f7:	f3 0f c2 c1 01       	cmpltss %xmm1,%xmm0
    13fc:	0f 54 d0             	andps  %xmm0,%xmm2
    13ff:	0f 55 c1             	andnps %xmm1,%xmm0
    1402:	0f 56 c2             	orps   %xmm2,%xmm0
    1405:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 140d <mesh_packet+0xded>
    140c:	00 
			1409: R_X86_64_PC32	.LC23-0x4
    140d:	e8 00 00 00 00       	call   1412 <mesh_packet+0xdf2>
			140e: R_X86_64_PLT32	lroundf-0x4
    1412:	c1 e3 0b             	shl    $0xb,%ebx
    1415:	41 c1 e5 05          	shl    $0x5,%r13d
    1419:	66 0f ef c9          	pxor   %xmm1,%xmm1
    141d:	44 09 eb             	or     %r13d,%ebx
    1420:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1424:	66 41 89 de          	mov    %bx,%r14w
    1428:	66 41 09 c6          	or     %ax,%r14w
    142c:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    1431:	44 0f b7 78 10       	movzwl 0x10(%rax),%r15d
    1436:	44 89 f8             	mov    %r15d,%eax
    1439:	66 c1 e8 0b          	shr    $0xb,%ax
    143d:	0f b7 c0             	movzwl %ax,%eax
    1440:	f3 0f 2a c8          	cvtsi2ss %eax,%xmm1
    1444:	f3 0f 59 0d 00 00 00 	mulss  0x0(%rip),%xmm1        # 144c <mesh_packet+0xe2c>
    144b:	00 
			1448: R_X86_64_PC32	.LC22-0x4
    144c:	f3 0f 59 8c 24 88 00 	mulss  0x88(%rsp),%xmm1
    1453:	00 00 
    1455:	f3 0f 58 8c 24 90 00 	addss  0x90(%rsp),%xmm1
    145c:	00 00 
    145e:	0f 2f c1             	comiss %xmm1,%xmm0
    1461:	77 21                	ja     1484 <mesh_packet+0xe64>
    1463:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 146b <mesh_packet+0xe4b>
    146a:	00 
			1467: R_X86_64_PC32	.LC17-0x4
    146b:	0f 28 c2             	movaps %xmm2,%xmm0
    146e:	f3 0f c2 c1 01       	cmpltss %xmm1,%xmm0
    1473:	0f 54 d0             	andps  %xmm0,%xmm2
    1476:	0f 55 c1             	andnps %xmm1,%xmm0
    1479:	0f 56 c2             	orps   %xmm2,%xmm0
    147c:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 1484 <mesh_packet+0xe64>
    1483:	00 
			1480: R_X86_64_PC32	.LC23-0x4
    1484:	e8 00 00 00 00       	call   1489 <mesh_packet+0xe69>
			1485: R_X86_64_PLT32	lroundf-0x4
    1489:	66 0f ef c9          	pxor   %xmm1,%xmm1
    148d:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1491:	48 89 c3             	mov    %rax,%rbx
    1494:	44 89 f8             	mov    %r15d,%eax
    1497:	66 c1 e8 05          	shr    $0x5,%ax
    149b:	83 e0 3f             	and    $0x3f,%eax
    149e:	f3 0f 2a c8          	cvtsi2ss %eax,%xmm1
    14a2:	f3 0f 59 0d 00 00 00 	mulss  0x0(%rip),%xmm1        # 14aa <mesh_packet+0xe8a>
    14a9:	00 
			14a6: R_X86_64_PC32	.LC24-0x4
    14aa:	f3 0f 59 4c 24 78    	mulss  0x78(%rsp),%xmm1
    14b0:	f3 0f 58 8c 24 80 00 	addss  0x80(%rsp),%xmm1
    14b7:	00 00 
    14b9:	0f 2f c1             	comiss %xmm1,%xmm0
    14bc:	77 21                	ja     14df <mesh_packet+0xebf>
    14be:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 14c6 <mesh_packet+0xea6>
    14c5:	00 
			14c2: R_X86_64_PC32	.LC17-0x4
    14c6:	0f 28 c2             	movaps %xmm2,%xmm0
    14c9:	f3 0f c2 c1 01       	cmpltss %xmm1,%xmm0
    14ce:	0f 54 d0             	andps  %xmm0,%xmm2
    14d1:	0f 55 c1             	andnps %xmm1,%xmm0
    14d4:	0f 56 c2             	orps   %xmm2,%xmm0
    14d7:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 14df <mesh_packet+0xebf>
    14de:	00 
			14db: R_X86_64_PC32	.LC25-0x4
    14df:	e8 00 00 00 00       	call   14e4 <mesh_packet+0xec4>
			14e0: R_X86_64_PLT32	lroundf-0x4
    14e4:	41 83 e7 1f          	and    $0x1f,%r15d
    14e8:	66 0f ef c9          	pxor   %xmm1,%xmm1
    14ec:	66 0f ef c0          	pxor   %xmm0,%xmm0
    14f0:	f3 41 0f 2a cf       	cvtsi2ss %r15d,%xmm1
    14f5:	f3 0f 59 0d 00 00 00 	mulss  0x0(%rip),%xmm1        # 14fd <mesh_packet+0xedd>
    14fc:	00 
			14f9: R_X86_64_PC32	.LC22-0x4
    14fd:	49 89 c5             	mov    %rax,%r13
    1500:	f3 0f 59 4c 24 50    	mulss  0x50(%rsp),%xmm1
    1506:	f3 0f 58 4c 24 40    	addss  0x40(%rsp),%xmm1
    150c:	0f 2f c1             	comiss %xmm1,%xmm0
    150f:	77 21                	ja     1532 <mesh_packet+0xf12>
    1511:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 1519 <mesh_packet+0xef9>
    1518:	00 
			1515: R_X86_64_PC32	.LC17-0x4
    1519:	0f 28 c2             	movaps %xmm2,%xmm0
    151c:	f3 0f c2 c1 01       	cmpltss %xmm1,%xmm0
    1521:	0f 54 d0             	andps  %xmm0,%xmm2
    1524:	0f 55 c1             	andnps %xmm1,%xmm0
    1527:	0f 56 c2             	orps   %xmm2,%xmm0
    152a:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 1532 <mesh_packet+0xf12>
    1531:	00 
			152e: R_X86_64_PC32	.LC23-0x4
    1532:	e8 00 00 00 00       	call   1537 <mesh_packet+0xf17>
			1533: R_X86_64_PLT32	lroundf-0x4
    1537:	c1 e3 0b             	shl    $0xb,%ebx
    153a:	41 c1 e5 05          	shl    $0x5,%r13d
    153e:	8b b4 24 a0 00 00 00 	mov    0xa0(%rsp),%esi
    1545:	44 09 eb             	or     %r13d,%ebx
    1548:	09 c3                	or     %eax,%ebx
    154a:	41 0f b7 c6          	movzwl %r14w,%eax
    154e:	c1 e3 10             	shl    $0x10,%ebx
    1551:	09 d8                	or     %ebx,%eax
    1553:	41 89 c6             	mov    %eax,%r14d
    1556:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
    155b:	44 89 70 0c          	mov    %r14d,0xc(%rax)
    155f:	85 f6                	test   %esi,%esi
    1561:	75 3d                	jne    15a0 <mesh_packet+0xf80>
    1563:	83 44 24 10 01       	addl   $0x1,0x10(%rsp)
    1568:	8b 8c 24 54 01 00 00 	mov    0x154(%rsp),%ecx
    156f:	8b 44 24 10          	mov    0x10(%rsp),%eax
    1573:	48 83 44 24 60 10    	addq   $0x10,0x60(%rsp)
    1579:	48 83 84 24 98 00 00 	addq   $0x4,0x98(%rsp)
    1580:	00 04 
    1582:	39 c8                	cmp    %ecx,%eax
    1584:	0f 83 45 05 00 00    	jae    1acf <mesh_packet+0x14af>
    158a:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
    158f:	48 8b 30             	mov    (%rax),%rsi
    1592:	e9 59 f9 ff ff       	jmp    ef0 <mesh_packet+0x8d0>
    1597:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    159e:	00 00 
    15a0:	48 8b 1d 00 00 00 00 	mov    0x0(%rip),%rbx        # 15a7 <mesh_packet+0xf87>
			15a3: R_X86_64_PC32	.LC8-0x4
    15a7:	4c 8b bc 24 c8 00 00 	mov    0xc8(%rsp),%r15
    15ae:	00 
    15af:	45 31 ed             	xor    %r13d,%r13d
    15b2:	f2 43 0f 10 04 ef    	movsd  (%r15,%r13,8),%xmm0
    15b8:	66 0f 57 05 00 00 00 	xorpd  0x0(%rip),%xmm0        # 15c0 <mesh_packet+0xfa0>
    15bf:	00 
			15bc: R_X86_64_PC32	.LC26-0x4
    15c0:	66 48 0f 6e cb       	movq   %rbx,%xmm1
    15c5:	f2 0f 59 05 00 00 00 	mulsd  0x0(%rip),%xmm0        # 15cd <mesh_packet+0xfad>
    15cc:	00 
			15c9: R_X86_64_PC32	.LC20-0x4
    15cd:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 15d5 <mesh_packet+0xfb5>
    15d4:	00 
			15d1: R_X86_64_PC32	.LC7-0x4
    15d5:	f2 0f 5e 44 24 08    	divsd  0x8(%rsp),%xmm0
    15db:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 15e3 <mesh_packet+0xfc3>
    15e2:	00 
			15df: R_X86_64_PC32	.LC6-0x4
    15e3:	66 0f 54 c8          	andpd  %xmm0,%xmm1
    15e7:	66 0f 2e f1          	ucomisd %xmm1,%xmm6
    15eb:	76 38                	jbe    1625 <mesh_packet+0x1005>
    15ed:	f2 48 0f 2c c0       	cvttsd2si %xmm0,%rax
    15f2:	66 0f ef c9          	pxor   %xmm1,%xmm1
    15f6:	f2 0f 10 1d 00 00 00 	movsd  0x0(%rip),%xmm3        # 15fe <mesh_packet+0xfde>
    15fd:	00 
			15fa: R_X86_64_PC32	.LC9-0x4
    15fe:	f2 48 0f 2a c8       	cvtsi2sd %rax,%xmm1
    1603:	66 0f 28 d1          	movapd %xmm1,%xmm2
    1607:	f2 0f c2 d0 06       	cmpnlesd %xmm0,%xmm2
    160c:	66 0f 54 d3          	andpd  %xmm3,%xmm2
    1610:	f2 0f 5c ca          	subsd  %xmm2,%xmm1
    1614:	66 48 0f 6e d3       	movq   %rbx,%xmm2
    1619:	66 0f 55 d0          	andnpd %xmm0,%xmm2
    161d:	66 0f 56 ca          	orpd   %xmm2,%xmm1
    1621:	66 0f 28 c1          	movapd %xmm1,%xmm0
    1625:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 162d <mesh_packet+0x100d>
    162c:	00 
			1629: R_X86_64_PC32	.LC20-0x4
    162d:	e8 00 00 00 00       	call   1632 <mesh_packet+0x1012>
			162e: R_X86_64_PLT32	fmin-0x4
    1632:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 163a <mesh_packet+0x101a>
    1639:	00 
			1636: R_X86_64_PC32	.LC21-0x4
    163a:	e8 00 00 00 00       	call   163f <mesh_packet+0x101f>
			163b: R_X86_64_PLT32	fmax-0x4
    163f:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    1643:	66 42 89 44 6d 00    	mov    %ax,0x0(%rbp,%r13,2)
    1649:	49 83 c5 01          	add    $0x1,%r13
    164d:	49 83 fd 03          	cmp    $0x3,%r13
    1651:	0f 85 5b ff ff ff    	jne    15b2 <mesh_packet+0xf92>
    1657:	49 8b 54 24 08       	mov    0x8(%r12),%rdx
    165c:	48 8b 84 24 60 01 00 	mov    0x160(%rsp),%rax
    1663:	00 
    1664:	48 89 ef             	mov    %rbp,%rdi
    1667:	48 8b 8c 24 70 01 00 	mov    0x170(%rsp),%rcx
    166e:	00 
    166f:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
    1674:	f3 0f 10 84 24 bc 00 	movss  0xbc(%rsp),%xmm0
    167b:	00 00 
    167d:	8b 44 02 08          	mov    0x8(%rdx,%rax,1),%eax
    1681:	f3 0f 10 8c 24 c0 00 	movss  0xc0(%rsp),%xmm1
    1688:	00 00 
    168a:	41 0f b6 75 12       	movzbl 0x12(%r13),%esi
    168f:	f3 0f 10 ac 24 b8 00 	movss  0xb8(%rsp),%xmm5
    1696:	00 00 
    1698:	48 01 c8             	add    %rcx,%rax
    169b:	8b 4c 24 10          	mov    0x10(%rsp),%ecx
    169f:	f3 0f 10 a4 24 ac 00 	movss  0xac(%rsp),%xmm4
    16a6:	00 00 
    16a8:	f3 0f 10 9c 24 a8 00 	movss  0xa8(%rsp),%xmm3
    16af:	00 00 
    16b1:	f3 0f 10 94 24 c4 00 	movss  0xc4(%rsp),%xmm2
    16b8:	00 00 
    16ba:	01 c9                	add    %ecx,%ecx
    16bc:	89 c9                	mov    %ecx,%ecx
    16be:	48 8d 04 48          	lea    (%rax,%rcx,2),%rax
    16c2:	0f b6 8c 24 b0 00 00 	movzbl 0xb0(%rsp),%ecx
    16c9:	00 
    16ca:	4c 8d 3c 02          	lea    (%rdx,%rax,1),%r15
    16ce:	48 8b 94 24 f0 00 00 	mov    0xf0(%rsp),%rdx
    16d5:	00 
    16d6:	e8 25 ec ff ff       	call   300 <ayatsuri_shade_terms_prepare.isra.0>
    16db:	f3 0f 10 6c 24 20    	movss  0x20(%rsp),%xmm5
    16e1:	41 0f b7 6d 0e       	movzwl 0xe(%r13),%ebp
    16e6:	f3 0f 10 a4 24 d0 00 	movss  0xd0(%rsp),%xmm4
    16ed:	00 00 
    16ef:	66 48 0f 7e ca       	movq   %xmm1,%rdx
    16f4:	f3 41 0f 10 4c 24 7c 	movss  0x7c(%r12),%xmm1
    16fb:	66 48 0f 7e c0       	movq   %xmm0,%rax
    1700:	f3 0f 10 bc 24 d8 00 	movss  0xd8(%rsp),%xmm7
    1707:	00 00 
    1709:	48 c1 e8 20          	shr    $0x20,%rax
    170d:	f3 0f 59 e0          	mulss  %xmm0,%xmm4
    1711:	66 0f 6e f0          	movd   %eax,%xmm6
    1715:	89 e8                	mov    %ebp,%eax
    1717:	66 c1 e8 0b          	shr    $0xb,%ax
    171b:	0f b7 c0             	movzwl %ax,%eax
    171e:	0f 28 c4             	movaps %xmm4,%xmm0
    1721:	f3 0f 11 64 24 08    	movss  %xmm4,0x8(%rsp)
    1727:	f3 0f 59 c1          	mulss  %xmm1,%xmm0
    172b:	f3 0f 58 e8          	addss  %xmm0,%xmm5
    172f:	66 0f 6e c2          	movd   %edx,%xmm0
    1733:	48 c1 ea 20          	shr    $0x20,%rdx
    1737:	f3 0f 59 f8          	mulss  %xmm0,%xmm7
    173b:	66 0f 6e c2          	movd   %edx,%xmm0
    173f:	f3 0f 59 84 24 e8 00 	mulss  0xe8(%rsp),%xmm0
    1746:	00 00 
    1748:	f3 0f 11 ac 24 80 00 	movss  %xmm5,0x80(%rsp)
    174f:	00 00 
    1751:	f3 0f 11 7c 24 50    	movss  %xmm7,0x50(%rsp)
    1757:	f3 0f 59 f0          	mulss  %xmm0,%xmm6
    175b:	f3 0f 10 84 24 50 01 	movss  0x150(%rsp),%xmm0
    1762:	00 00 
    1764:	f3 0f 59 c6          	mulss  %xmm6,%xmm0
    1768:	f3 0f 11 74 24 40    	movss  %xmm6,0x40(%rsp)
    176e:	f3 0f 58 c7          	addss  %xmm7,%xmm0
    1772:	0f 28 e0             	movaps %xmm0,%xmm4
    1775:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1779:	f3 0f 59 e1          	mulss  %xmm1,%xmm4
    177d:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1781:	f3 0f 2a c8          	cvtsi2ss %eax,%xmm1
    1785:	f3 0f 59 0d 00 00 00 	mulss  0x0(%rip),%xmm1        # 178d <mesh_packet+0x116d>
    178c:	00 
			1789: R_X86_64_PC32	.LC22-0x4
    178d:	f3 0f 11 a4 24 88 00 	movss  %xmm4,0x88(%rsp)
    1794:	00 00 
    1796:	f3 0f 59 cd          	mulss  %xmm5,%xmm1
    179a:	f3 0f 58 cc          	addss  %xmm4,%xmm1
    179e:	0f 2f c1             	comiss %xmm1,%xmm0
    17a1:	77 27                	ja     17ca <mesh_packet+0x11aa>
    17a3:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 17ab <mesh_packet+0x118b>
    17aa:	00 
			17a7: R_X86_64_PC32	.LC17-0x4
    17ab:	0f 28 d0             	movaps %xmm0,%xmm2
    17ae:	0f 28 d8             	movaps %xmm0,%xmm3
    17b1:	f3 0f c2 d1 01       	cmpltss %xmm1,%xmm2
    17b6:	0f 54 da             	andps  %xmm2,%xmm3
    17b9:	0f 55 d1             	andnps %xmm1,%xmm2
    17bc:	0f 28 c2             	movaps %xmm2,%xmm0
    17bf:	0f 56 c3             	orps   %xmm3,%xmm0
    17c2:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 17ca <mesh_packet+0x11aa>
    17c9:	00 
			17c6: R_X86_64_PC32	.LC23-0x4
    17ca:	e8 00 00 00 00       	call   17cf <mesh_packet+0x11af>
			17cb: R_X86_64_PLT32	lroundf-0x4
    17cf:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
    17d5:	f3 41 0f 10 8c 24 80 	movss  0x80(%r12),%xmm1
    17dc:	00 00 00 
    17df:	f3 0f 10 6c 24 20    	movss  0x20(%rsp),%xmm5
    17e5:	49 89 c5             	mov    %rax,%r13
    17e8:	89 e8                	mov    %ebp,%eax
    17ea:	f3 0f 59 c1          	mulss  %xmm1,%xmm0
    17ee:	66 c1 e8 05          	shr    $0x5,%ax
    17f2:	83 e0 3f             	and    $0x3f,%eax
    17f5:	f3 0f 58 e8          	addss  %xmm0,%xmm5
    17f9:	f3 0f 10 84 24 e0 00 	movss  0xe0(%rsp),%xmm0
    1800:	00 00 
    1802:	f3 0f 59 44 24 40    	mulss  0x40(%rsp),%xmm0
    1808:	f3 0f 58 44 24 50    	addss  0x50(%rsp),%xmm0
    180e:	f3 0f 11 6c 24 58    	movss  %xmm5,0x58(%rsp)
    1814:	0f 28 f8             	movaps %xmm0,%xmm7
    1817:	66 0f ef c0          	pxor   %xmm0,%xmm0
    181b:	f3 0f 59 f9          	mulss  %xmm1,%xmm7
    181f:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1823:	f3 0f 2a c8          	cvtsi2ss %eax,%xmm1
    1827:	f3 0f 59 0d 00 00 00 	mulss  0x0(%rip),%xmm1        # 182f <mesh_packet+0x120f>
    182e:	00 
			182b: R_X86_64_PC32	.LC24-0x4
    182f:	f3 0f 11 7c 24 78    	movss  %xmm7,0x78(%rsp)
    1835:	f3 0f 59 cd          	mulss  %xmm5,%xmm1
    1839:	f3 0f 58 cf          	addss  %xmm7,%xmm1
    183d:	0f 2f c1             	comiss %xmm1,%xmm0
    1840:	77 27                	ja     1869 <mesh_packet+0x1249>
    1842:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 184a <mesh_packet+0x122a>
    1849:	00 
			1846: R_X86_64_PC32	.LC17-0x4
    184a:	0f 28 d0             	movaps %xmm0,%xmm2
    184d:	0f 28 d8             	movaps %xmm0,%xmm3
    1850:	f3 0f c2 d1 01       	cmpltss %xmm1,%xmm2
    1855:	0f 54 da             	andps  %xmm2,%xmm3
    1858:	0f 55 d1             	andnps %xmm1,%xmm2
    185b:	0f 28 c2             	movaps %xmm2,%xmm0
    185e:	0f 56 c3             	orps   %xmm3,%xmm0
    1861:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 1869 <mesh_packet+0x1249>
    1868:	00 
			1865: R_X86_64_PC32	.LC25-0x4
    1869:	e8 00 00 00 00       	call   186e <mesh_packet+0x124e>
			186a: R_X86_64_PLT32	lroundf-0x4
    186e:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
    1874:	f3 0f 10 74 24 20    	movss  0x20(%rsp),%xmm6
    187a:	83 e5 1f             	and    $0x1f,%ebp
    187d:	f3 41 0f 10 8c 24 84 	movss  0x84(%r12),%xmm1
    1884:	00 00 00 
    1887:	48 89 c3             	mov    %rax,%rbx
    188a:	f3 0f 59 c1          	mulss  %xmm1,%xmm0
    188e:	f3 0f 58 f0          	addss  %xmm0,%xmm6
    1892:	f3 0f 10 84 24 ec 00 	movss  0xec(%rsp),%xmm0
    1899:	00 00 
    189b:	f3 0f 59 44 24 40    	mulss  0x40(%rsp),%xmm0
    18a1:	f3 0f 58 44 24 50    	addss  0x50(%rsp),%xmm0
    18a7:	f3 0f 11 74 24 08    	movss  %xmm6,0x8(%rsp)
    18ad:	0f 28 e0             	movaps %xmm0,%xmm4
    18b0:	66 0f ef c0          	pxor   %xmm0,%xmm0
    18b4:	f3 0f 59 e1          	mulss  %xmm1,%xmm4
    18b8:	66 0f ef c9          	pxor   %xmm1,%xmm1
    18bc:	f3 0f 2a cd          	cvtsi2ss %ebp,%xmm1
    18c0:	f3 0f 59 0d 00 00 00 	mulss  0x0(%rip),%xmm1        # 18c8 <mesh_packet+0x12a8>
    18c7:	00 
			18c4: R_X86_64_PC32	.LC22-0x4
    18c8:	f3 0f 11 64 24 20    	movss  %xmm4,0x20(%rsp)
    18ce:	f3 0f 59 ce          	mulss  %xmm6,%xmm1
    18d2:	f3 0f 58 cc          	addss  %xmm4,%xmm1
    18d6:	0f 2f c1             	comiss %xmm1,%xmm0
    18d9:	77 27                	ja     1902 <mesh_packet+0x12e2>
    18db:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 18e3 <mesh_packet+0x12c3>
    18e2:	00 
			18df: R_X86_64_PC32	.LC17-0x4
    18e3:	0f 28 d0             	movaps %xmm0,%xmm2
    18e6:	0f 28 d8             	movaps %xmm0,%xmm3
    18e9:	f3 0f c2 d1 01       	cmpltss %xmm1,%xmm2
    18ee:	0f 54 da             	andps  %xmm2,%xmm3
    18f1:	0f 55 d1             	andnps %xmm1,%xmm2
    18f4:	0f 28 c2             	movaps %xmm2,%xmm0
    18f7:	0f 56 c3             	orps   %xmm3,%xmm0
    18fa:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 1902 <mesh_packet+0x12e2>
    1901:	00 
			18fe: R_X86_64_PC32	.LC23-0x4
    1902:	e8 00 00 00 00       	call   1907 <mesh_packet+0x12e7>
			1903: R_X86_64_PLT32	lroundf-0x4
    1907:	41 c1 e5 0b          	shl    $0xb,%r13d
    190b:	c1 e3 05             	shl    $0x5,%ebx
    190e:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1912:	8b 8c 24 78 01 00 00 	mov    0x178(%rsp),%ecx
    1919:	41 09 dd             	or     %ebx,%r13d
    191c:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1920:	66 44 89 e9          	mov    %r13w,%cx
    1924:	66 09 c1             	or     %ax,%cx
    1927:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    192c:	89 8c 24 78 01 00 00 	mov    %ecx,0x178(%rsp)
    1933:	44 0f b7 68 10       	movzwl 0x10(%rax),%r13d
    1938:	44 89 e8             	mov    %r13d,%eax
    193b:	66 c1 e8 0b          	shr    $0xb,%ax
    193f:	0f b7 c0             	movzwl %ax,%eax
    1942:	f3 0f 2a c8          	cvtsi2ss %eax,%xmm1
    1946:	f3 0f 59 0d 00 00 00 	mulss  0x0(%rip),%xmm1        # 194e <mesh_packet+0x132e>
    194d:	00 
			194a: R_X86_64_PC32	.LC22-0x4
    194e:	f3 0f 59 8c 24 80 00 	mulss  0x80(%rsp),%xmm1
    1955:	00 00 
    1957:	f3 0f 58 8c 24 88 00 	addss  0x88(%rsp),%xmm1
    195e:	00 00 
    1960:	0f 2f c1             	comiss %xmm1,%xmm0
    1963:	77 27                	ja     198c <mesh_packet+0x136c>
    1965:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 196d <mesh_packet+0x134d>
    196c:	00 
			1969: R_X86_64_PC32	.LC17-0x4
    196d:	0f 28 d0             	movaps %xmm0,%xmm2
    1970:	0f 28 d8             	movaps %xmm0,%xmm3
    1973:	f3 0f c2 d1 01       	cmpltss %xmm1,%xmm2
    1978:	0f 54 da             	andps  %xmm2,%xmm3
    197b:	0f 55 d1             	andnps %xmm1,%xmm2
    197e:	0f 28 c2             	movaps %xmm2,%xmm0
    1981:	0f 56 c3             	orps   %xmm3,%xmm0
    1984:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 198c <mesh_packet+0x136c>
    198b:	00 
			1988: R_X86_64_PC32	.LC23-0x4
    198c:	e8 00 00 00 00       	call   1991 <mesh_packet+0x1371>
			198d: R_X86_64_PLT32	lroundf-0x4
    1991:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1995:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1999:	48 89 c3             	mov    %rax,%rbx
    199c:	44 89 e8             	mov    %r13d,%eax
    199f:	66 c1 e8 05          	shr    $0x5,%ax
    19a3:	83 e0 3f             	and    $0x3f,%eax
    19a6:	f3 0f 2a c8          	cvtsi2ss %eax,%xmm1
    19aa:	f3 0f 59 0d 00 00 00 	mulss  0x0(%rip),%xmm1        # 19b2 <mesh_packet+0x1392>
    19b1:	00 
			19ae: R_X86_64_PC32	.LC24-0x4
    19b2:	f3 0f 59 4c 24 58    	mulss  0x58(%rsp),%xmm1
    19b8:	f3 0f 58 4c 24 78    	addss  0x78(%rsp),%xmm1
    19be:	0f 2f c1             	comiss %xmm1,%xmm0
    19c1:	77 27                	ja     19ea <mesh_packet+0x13ca>
    19c3:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 19cb <mesh_packet+0x13ab>
    19ca:	00 
			19c7: R_X86_64_PC32	.LC17-0x4
    19cb:	0f 28 d0             	movaps %xmm0,%xmm2
    19ce:	0f 28 d8             	movaps %xmm0,%xmm3
    19d1:	f3 0f c2 d1 01       	cmpltss %xmm1,%xmm2
    19d6:	0f 54 da             	andps  %xmm2,%xmm3
    19d9:	0f 55 d1             	andnps %xmm1,%xmm2
    19dc:	0f 28 c2             	movaps %xmm2,%xmm0
    19df:	0f 56 c3             	orps   %xmm3,%xmm0
    19e2:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 19ea <mesh_packet+0x13ca>
    19e9:	00 
			19e6: R_X86_64_PC32	.LC25-0x4
    19ea:	e8 00 00 00 00       	call   19ef <mesh_packet+0x13cf>
			19eb: R_X86_64_PLT32	lroundf-0x4
    19ef:	41 83 e5 1f          	and    $0x1f,%r13d
    19f3:	66 0f ef c9          	pxor   %xmm1,%xmm1
    19f7:	66 0f ef c0          	pxor   %xmm0,%xmm0
    19fb:	f3 41 0f 2a cd       	cvtsi2ss %r13d,%xmm1
    1a00:	f3 0f 59 0d 00 00 00 	mulss  0x0(%rip),%xmm1        # 1a08 <mesh_packet+0x13e8>
    1a07:	00 
			1a04: R_X86_64_PC32	.LC22-0x4
    1a08:	48 89 c5             	mov    %rax,%rbp
    1a0b:	f3 0f 59 4c 24 08    	mulss  0x8(%rsp),%xmm1
    1a11:	f3 0f 58 4c 24 20    	addss  0x20(%rsp),%xmm1
    1a17:	0f 2f c1             	comiss %xmm1,%xmm0
    1a1a:	77 27                	ja     1a43 <mesh_packet+0x1423>
    1a1c:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 1a24 <mesh_packet+0x1404>
    1a23:	00 
			1a20: R_X86_64_PC32	.LC17-0x4
    1a24:	0f 28 d0             	movaps %xmm0,%xmm2
    1a27:	0f 28 d8             	movaps %xmm0,%xmm3
    1a2a:	f3 0f c2 d1 01       	cmpltss %xmm1,%xmm2
    1a2f:	0f 54 da             	andps  %xmm2,%xmm3
    1a32:	0f 55 d1             	andnps %xmm1,%xmm2
    1a35:	0f 28 c2             	movaps %xmm2,%xmm0
    1a38:	0f 56 c3             	orps   %xmm3,%xmm0
    1a3b:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 1a43 <mesh_packet+0x1423>
    1a42:	00 
			1a3f: R_X86_64_PC32	.LC23-0x4
    1a43:	e8 00 00 00 00       	call   1a48 <mesh_packet+0x1428>
			1a44: R_X86_64_PLT32	lroundf-0x4
    1a48:	c1 e3 0b             	shl    $0xb,%ebx
    1a4b:	c1 e5 05             	shl    $0x5,%ebp
    1a4e:	09 eb                	or     %ebp,%ebx
    1a50:	09 c3                	or     %eax,%ebx
    1a52:	0f b7 84 24 78 01 00 	movzwl 0x178(%rsp),%eax
    1a59:	00 
    1a5a:	c1 e3 10             	shl    $0x10,%ebx
    1a5d:	09 d8                	or     %ebx,%eax
    1a5f:	89 84 24 78 01 00 00 	mov    %eax,0x178(%rsp)
    1a66:	41 89 07             	mov    %eax,(%r15)
    1a69:	e9 f5 fa ff ff       	jmp    1563 <mesh_packet+0xf43>
    1a6e:	48 8b b4 24 58 01 00 	mov    0x158(%rsp),%rsi
    1a75:	00 
    1a76:	4c 8d 46 5c          	lea    0x5c(%rsi),%r8
    1a7a:	89 f0                	mov    %esi,%eax
    1a7c:	48 c7 46 54 00 00 00 	movq   $0x0,0x54(%rsi)
    1a83:	00 
    1a84:	48 c7 86 5c 04 00 00 	movq   $0x0,0x45c(%rsi)
    1a8b:	00 00 00 00 
    1a8f:	4c 89 c7             	mov    %r8,%rdi
    1a92:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
    1a96:	29 f8                	sub    %edi,%eax
    1a98:	8d 88 64 04 00 00    	lea    0x464(%rax),%ecx
    1a9e:	31 c0                	xor    %eax,%eax
    1aa0:	c1 e9 03             	shr    $0x3,%ecx
    1aa3:	f3 48 ab             	rep stos %rax,%es:(%rdi)
    1aa6:	0f b6 84 24 7c 01 00 	movzbl 0x17c(%rsp),%eax
    1aad:	00 
    1aae:	88 46 54             	mov    %al,0x54(%rsi)
    1ab1:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    1ab6:	0f b6 40 0a          	movzbl 0xa(%rax),%eax
    1aba:	88 46 56             	mov    %al,0x56(%rsi)
    1abd:	45 85 d2             	test   %r10d,%r10d
    1ac0:	74 47                	je     1b09 <mesh_packet+0x14e9>
    1ac2:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
    1ac7:	48 8b 18             	mov    (%rax),%rbx
    1aca:	e9 c4 f2 ff ff       	jmp    d93 <mesh_packet+0x773>
    1acf:	44 8b ac 24 90 01 00 	mov    0x190(%rsp),%r13d
    1ad6:	00 
    1ad7:	4c 8b b4 24 80 01 00 	mov    0x180(%rsp),%r14
    1ade:	00 
    1adf:	44 8b 94 24 54 01 00 	mov    0x154(%rsp),%r10d
    1ae6:	00 
    1ae7:	4c 8b 9c 24 68 01 00 	mov    0x168(%rsp),%r11
    1aee:	00 
    1aef:	f2 44 0f 10 b4 24 88 	movsd  0x188(%rsp),%xmm14
    1af6:	01 00 00 
    1af9:	8b 94 24 94 01 00 00 	mov    0x194(%rsp),%edx
    1b00:	45 84 ed             	test   %r13b,%r13b
    1b03:	0f 85 42 03 00 00    	jne    1e4b <mesh_packet+0x182b>
    1b09:	44 0f b7 84 24 7e 01 	movzwl 0x17e(%rsp),%r8d
    1b10:	00 00 
    1b12:	45 85 c0             	test   %r8d,%r8d
    1b15:	74 52                	je     1b69 <mesh_packet+0x1549>
    1b17:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
    1b1c:	48 8b 6c 24 18       	mov    0x18(%rsp),%rbp
    1b21:	31 c9                	xor    %ecx,%ecx
    1b23:	44 8b 48 64          	mov    0x64(%rax),%r9d
    1b27:	4c 03 08             	add    (%rax),%r9
    1b2a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    1b30:	8d 3c 49             	lea    (%rcx,%rcx,2),%edi
    1b33:	31 f6                	xor    %esi,%esi
    1b35:	0f b7 45 04          	movzwl 0x4(%rbp),%eax
    1b39:	49 8d 1c 31          	lea    (%r9,%rsi,1),%rbx
    1b3d:	48 83 c6 02          	add    $0x2,%rsi
    1b41:	01 c8                	add    %ecx,%eax
    1b43:	8d 04 40             	lea    (%rax,%rax,2),%eax
    1b46:	01 c0                	add    %eax,%eax
    1b48:	89 c0                	mov    %eax,%eax
    1b4a:	0f b7 1c 03          	movzwl (%rbx,%rax,1),%ebx
    1b4e:	89 f8                	mov    %edi,%eax
    1b50:	83 c7 01             	add    $0x1,%edi
    1b53:	66 89 9c 44 70 02 00 	mov    %bx,0x270(%rsp,%rax,2)
    1b5a:	00 
    1b5b:	48 83 fe 06          	cmp    $0x6,%rsi
    1b5f:	75 d4                	jne    1b35 <mesh_packet+0x1515>
    1b61:	83 c1 01             	add    $0x1,%ecx
    1b64:	41 39 c8             	cmp    %ecx,%r8d
    1b67:	75 c7                	jne    1b30 <mesh_packet+0x1510>
    1b69:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    1b6e:	8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%ecx
    1b75:	44 0f b6 68 0b       	movzbl 0xb(%rax),%r13d
    1b7a:	85 c9                	test   %ecx,%ecx
    1b7c:	0f 84 e0 02 00 00    	je     1e62 <mesh_packet+0x1842>
    1b82:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
    1b87:	48 8b 84 24 60 01 00 	mov    0x160(%rsp),%rax
    1b8e:	00 
    1b8f:	44 01 d2             	add    %r10d,%edx
    1b92:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1b96:	8d 14 95 6b 04 00 00 	lea    0x46b(,%rdx,4),%edx
    1b9d:	8b 44 01 08          	mov    0x8(%rcx,%rax,1),%eax
    1ba1:	81 e2 f8 ff 1f 00    	and    $0x1ffff8,%edx
    1ba7:	4a 8d 04 70          	lea    (%rax,%r14,2),%rax
    1bab:	48 01 d0             	add    %rdx,%rax
    1bae:	66 41 0f 2f c6       	comisd %xmm14,%xmm0
    1bb3:	48 8d 3c 01          	lea    (%rcx,%rax,1),%rdi
    1bb7:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
    1bbe:	41 0f 97 c6          	seta   %r14b
    1bc2:	45 85 c0             	test   %r8d,%r8d
    1bc5:	0f 84 33 05 00 00    	je     20fe <mesh_packet+0x1ade>
    1bcb:	4c 8d 8c 24 70 02 00 	lea    0x270(%rsp),%r9
    1bd2:	00 
    1bd3:	31 f6                	xor    %esi,%esi
    1bd5:	66 0f 28 e0          	movapd %xmm0,%xmm4
    1bd9:	31 c0                	xor    %eax,%eax
    1bdb:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
    1be0:	f2 0f 10 1d 00 00 00 	movsd  0x0(%rip),%xmm3        # 1be8 <mesh_packet+0x15c8>
    1be7:	00 
			1be4: R_X86_64_PC32	.LC27-0x4
    1be8:	4c 89 c9             	mov    %r9,%rcx
    1beb:	4c 89 4c 24 10       	mov    %r9,0x10(%rsp)
    1bf0:	4c 8b 94 24 98 01 00 	mov    0x198(%rsp),%r10
    1bf7:	00 
    1bf8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    1bff:	00 
    1c00:	0f b7 29             	movzwl (%rcx),%ebp
    1c03:	0f b7 59 02          	movzwl 0x2(%rcx),%ebx
    1c07:	66 0f ef ed          	pxor   %xmm5,%xmm5
    1c0b:	66 0f ef d2          	pxor   %xmm2,%xmm2
    1c0f:	44 0f b7 49 04       	movzwl 0x4(%rcx),%r9d
    1c14:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1c18:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1c1c:	48 8d 54 2d 00       	lea    0x0(%rbp,%rbp,1),%rdx
    1c21:	81 e2 fe ff 01 00    	and    $0x1fffe,%edx
    1c27:	4b 8d 3c 09          	lea    (%r9,%r9,1),%rdi
    1c2b:	f3 41 0f 5a 54 93 04 	cvtss2sd 0x4(%r11,%rdx,4),%xmm2
    1c32:	f3 41 0f 5a 2c 93    	cvtss2sd (%r11,%rdx,4),%xmm5
    1c38:	48 8d 14 1b          	lea    (%rbx,%rbx,1),%rdx
    1c3c:	81 e7 fe ff 01 00    	and    $0x1fffe,%edi
    1c42:	81 e2 fe ff 01 00    	and    $0x1fffe,%edx
    1c48:	f3 41 0f 5a 44 bb 04 	cvtss2sd 0x4(%r11,%rdi,4),%xmm0
    1c4f:	f2 0f 5c c2          	subsd  %xmm2,%xmm0
    1c53:	f3 41 0f 5a 0c 93    	cvtss2sd (%r11,%rdx,4),%xmm1
    1c59:	f2 0f 5c cd          	subsd  %xmm5,%xmm1
    1c5d:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    1c61:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1c65:	f3 41 0f 5a 4c 93 04 	cvtss2sd 0x4(%r11,%rdx,4),%xmm1
    1c6c:	f2 0f 5c ca          	subsd  %xmm2,%xmm1
    1c70:	66 0f ef d2          	pxor   %xmm2,%xmm2
    1c74:	f3 41 0f 5a 14 bb    	cvtss2sd (%r11,%rdi,4),%xmm2
    1c7a:	f2 0f 5c d5          	subsd  %xmm5,%xmm2
    1c7e:	f2 0f 59 ca          	mulsd  %xmm2,%xmm1
    1c82:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    1c86:	66 0f 28 c8          	movapd %xmm0,%xmm1
    1c8a:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 1c92 <mesh_packet+0x1672>
    1c91:	00 
			1c8e: R_X86_64_PC32	.LC8-0x4
    1c92:	66 0f 2f d9          	comisd %xmm1,%xmm3
    1c96:	73 5e                	jae    1cf6 <mesh_packet+0x16d6>
    1c98:	66 0f 2f e0          	comisd %xmm0,%xmm4
    1c9c:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1ca0:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1ca4:	44 89 f2             	mov    %r14d,%edx
    1ca7:	f3 41 0f 5a 0c 9a    	cvtss2sd (%r10,%rbx,4),%xmm1
    1cad:	f3 41 0f 5a 04 aa    	cvtss2sd (%r10,%rbp,4),%xmm0
    1cb3:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    1cb7:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1cbb:	f3 43 0f 5a 0c 8a    	cvtss2sd (%r10,%r9,4),%xmm1
    1cc1:	8d 58 01             	lea    0x1(%rax),%ebx
    1cc4:	40 0f 97 c7          	seta   %dil
    1cc8:	31 fa                	xor    %edi,%edx
    1cca:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    1cce:	01 d2                	add    %edx,%edx
    1cd0:	09 fa                	or     %edi,%edx
    1cd2:	88 94 34 30 02 00 00 	mov    %dl,0x230(%rsp,%rsi,1)
    1cd9:	41 80 fd 01          	cmp    $0x1,%r13b
    1cdd:	0f 84 a1 03 00 00    	je     2084 <mesh_packet+0x1a64>
    1ce3:	40 88 b4 04 f0 01 00 	mov    %sil,0x1f0(%rsp,%rax,1)
    1cea:	00 
    1ceb:	f2 0f 11 84 c4 f0 03 	movsd  %xmm0,0x3f0(%rsp,%rax,8)
    1cf2:	00 00 
    1cf4:	89 d8                	mov    %ebx,%eax
    1cf6:	48 83 c6 01          	add    $0x1,%rsi
    1cfa:	48 83 c1 06          	add    $0x6,%rcx
    1cfe:	44 39 c6             	cmp    %r8d,%esi
    1d01:	0f 82 f9 fe ff ff    	jb     1c00 <mesh_packet+0x15e0>
    1d07:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
    1d0c:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
    1d11:	85 c0                	test   %eax,%eax
    1d13:	0f 84 ff 03 00 00    	je     2118 <mesh_packet+0x1af8>
    1d19:	48 8b 8c 24 58 01 00 	mov    0x158(%rsp),%rcx
    1d20:	00 
    1d21:	89 c3                	mov    %eax,%ebx
    1d23:	45 31 c0             	xor    %r8d,%r8d
    1d26:	4c 8d 94 24 f0 01 00 	lea    0x1f0(%rsp),%r10
    1d2d:	00 
    1d2e:	bd 01 00 00 00       	mov    $0x1,%ebp
    1d33:	48 8d b1 5c 02 00 00 	lea    0x25c(%rcx),%rsi
    1d3a:	eb 45                	jmp    1d81 <mesh_packet+0x1761>
    1d3c:	44 0f b7 61 02       	movzwl 0x2(%rcx),%r12d
    1d41:	41 bb 04 00 00 00    	mov    $0x4,%r11d
    1d47:	66 44 89 66 02       	mov    %r12w,0x2(%rsi)
    1d4c:	42 0f b7 0c 19       	movzwl (%rcx,%r11,1),%ecx
    1d51:	83 e2 02             	and    $0x2,%edx
    1d54:	66 89 4e 04          	mov    %cx,0x4(%rsi)
    1d58:	74 16                	je     1d70 <mesh_packet+0x1750>
    1d5a:	44 89 c2             	mov    %r8d,%edx
    1d5d:	44 89 c1             	mov    %r8d,%ecx
    1d60:	41 89 eb             	mov    %ebp,%r11d
    1d63:	c1 ea 03             	shr    $0x3,%edx
    1d66:	83 e1 07             	and    $0x7,%ecx
    1d69:	41 d3 e3             	shl    %cl,%r11d
    1d6c:	44 08 1c 17          	or     %r11b,(%rdi,%rdx,1)
    1d70:	49 83 c0 01          	add    $0x1,%r8
    1d74:	48 83 c6 06          	add    $0x6,%rsi
    1d78:	49 39 d8             	cmp    %rbx,%r8
    1d7b:	0f 84 97 03 00 00    	je     2118 <mesh_packet+0x1af8>
    1d81:	43 0f b6 14 02       	movzbl (%r10,%r8,1),%edx
    1d86:	8d 0c 52             	lea    (%rdx,%rdx,2),%ecx
    1d89:	0f b6 94 14 30 02 00 	movzbl 0x230(%rsp,%rdx,1),%edx
    1d90:	00 
    1d91:	49 8d 0c 49          	lea    (%r9,%rcx,2),%rcx
    1d95:	44 0f b7 19          	movzwl (%rcx),%r11d
    1d99:	66 44 89 1e          	mov    %r11w,(%rsi)
    1d9d:	f6 c2 01             	test   $0x1,%dl
    1da0:	74 9a                	je     1d3c <mesh_packet+0x171c>
    1da2:	44 0f b7 61 04       	movzwl 0x4(%rcx),%r12d
    1da7:	41 bb 02 00 00 00    	mov    $0x2,%r11d
    1dad:	eb 98                	jmp    1d47 <mesh_packet+0x1727>
    1daf:	f3 44 0f 10 9c 24 a8 	movss  0xa8(%rsp),%xmm11
    1db6:	00 00 00 
    1db9:	c6 84 24 b0 00 00 00 	movb   $0x1,0xb0(%rsp)
    1dc0:	01 
    1dc1:	f3 0f 10 9c 24 ac 00 	movss  0xac(%rsp),%xmm3
    1dc8:	00 00 
    1dca:	f3 0f 10 8c 24 b8 00 	movss  0xb8(%rsp),%xmm1
    1dd1:	00 00 
    1dd3:	f3 44 0f 5e d8       	divss  %xmm0,%xmm11
    1dd8:	f3 0f 5e d8          	divss  %xmm0,%xmm3
    1ddc:	45 0f 28 e3          	movaps %xmm11,%xmm12
    1de0:	f3 45 0f 59 e3       	mulss  %xmm11,%xmm12
    1de5:	f3 0f 5e c8          	divss  %xmm0,%xmm1
    1de9:	0f 28 c3             	movaps %xmm3,%xmm0
    1dec:	f3 0f 59 c3          	mulss  %xmm3,%xmm0
    1df0:	f3 41 0f 58 c4       	addss  %xmm12,%xmm0
    1df5:	44 0f 28 e1          	movaps %xmm1,%xmm12
    1df9:	f3 44 0f 59 e1       	mulss  %xmm1,%xmm12
    1dfe:	f3 41 0f 58 c4       	addss  %xmm12,%xmm0
    1e03:	f3 0f 51 c0          	sqrtss %xmm0,%xmm0
    1e07:	f3 44 0f 5e d8       	divss  %xmm0,%xmm11
    1e0c:	f3 0f 5e d8          	divss  %xmm0,%xmm3
    1e10:	f3 44 0f 11 9c 24 a8 	movss  %xmm11,0xa8(%rsp)
    1e17:	00 00 00 
    1e1a:	f3 0f 5e c8          	divss  %xmm0,%xmm1
    1e1e:	f3 0f 11 9c 24 ac 00 	movss  %xmm3,0xac(%rsp)
    1e25:	00 00 
    1e27:	f3 0f 11 8c 24 b8 00 	movss  %xmm1,0xb8(%rsp)
    1e2e:	00 00 
    1e30:	e9 15 ef ff ff       	jmp    d4a <mesh_packet+0x72a>
    1e35:	41 0f b6 47 0a       	movzbl 0xa(%r15),%eax
    1e3a:	49 83 c6 01          	add    $0x1,%r14
    1e3e:	48 83 c3 44          	add    $0x44,%rbx
    1e42:	41 39 c6             	cmp    %eax,%r14d
    1e45:	0f 82 b0 00 00 00    	jb     1efb <mesh_packet+0x18db>
    1e4b:	b8 01 00 00 00       	mov    $0x1,%eax
    1e50:	e9 4d ec ff ff       	jmp    aa2 <mesh_packet+0x482>
    1e55:	c6 84 24 b0 00 00 00 	movb   $0x0,0xb0(%rsp)
    1e5c:	00 
    1e5d:	e9 e8 ee ff ff       	jmp    d4a <mesh_packet+0x72a>
    1e62:	0f b7 94 24 7c 01 00 	movzwl 0x17c(%rsp),%edx
    1e69:	00 
    1e6a:	48 8d 8c 24 70 02 00 	lea    0x270(%rsp),%rcx
    1e71:	00 
    1e72:	48 83 ec 08          	sub    $0x8,%rsp
    1e76:	45 0f b6 cd          	movzbl %r13b,%r9d
    1e7a:	48 8d 84 24 f8 03 00 	lea    0x3f8(%rsp),%rax
    1e81:	00 
    1e82:	4c 89 df             	mov    %r11,%rdi
    1e85:	50                   	push   %rax
    1e86:	43 8d 04 40          	lea    (%r8,%r8,2),%eax
    1e8a:	50                   	push   %rax
    1e8b:	48 8b 9c 24 70 01 00 	mov    0x170(%rsp),%rbx
    1e92:	00 
    1e93:	48 8d 83 5c 02 00 00 	lea    0x25c(%rbx),%rax
    1e9a:	50                   	push   %rax
    1e9b:	48 8b b4 24 b8 01 00 	mov    0x1b8(%rsp),%rsi
    1ea2:	00 
    1ea3:	44 0f b7 84 24 9e 01 	movzwl 0x19e(%rsp),%r8d
    1eaa:	00 00 
    1eac:	e8 00 00 00 00       	call   1eb1 <mesh_packet+0x1891>
			1ead: R_X86_64_PLT32	ayatsuri_visibility_select-0x4
    1eb1:	48 83 c4 20          	add    $0x20,%rsp
    1eb5:	85 c0                	test   %eax,%eax
    1eb7:	0f 85 e3 eb ff ff    	jne    aa0 <mesh_packet+0x480>
    1ebd:	8b 84 24 f0 03 00 00 	mov    0x3f0(%rsp),%eax
    1ec4:	88 43 55             	mov    %al,0x55(%rbx)
    1ec7:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
    1ecc:	41 80 7f 0a 00       	cmpb   $0x0,0xa(%r15)
    1ed1:	45 0f b7 4f 08       	movzwl 0x8(%r15),%r9d
    1ed6:	0f 84 6f ff ff ff    	je     1e4b <mesh_packet+0x182b>
    1edc:	48 8b 9c 24 58 01 00 	mov    0x158(%rsp),%rbx
    1ee3:	00 
    1ee4:	4c 8b 5c 24 70       	mov    0x70(%rsp),%r11
    1ee9:	45 31 f6             	xor    %r14d,%r14d
    1eec:	48 8d ac 24 c0 01 00 	lea    0x1c0(%rsp),%rbp
    1ef3:	00 
    1ef4:	48 81 c3 dc 03 00 00 	add    $0x3dc,%rbx
    1efb:	43 0f b6 44 37 0c    	movzbl 0xc(%r15,%r14,1),%eax
    1f01:	88 03                	mov    %al,(%rbx)
    1f03:	84 c0                	test   %al,%al
    1f05:	0f 84 2a ff ff ff    	je     1e35 <mesh_packet+0x1815>
    1f0b:	4d 8b 2b             	mov    (%r11),%r13
    1f0e:	45 8b 63 6c          	mov    0x6c(%r11),%r12d
    1f12:	48 8d 53 04          	lea    0x4(%rbx),%rdx
    1f16:	45 31 d2             	xor    %r10d,%r10d
    1f19:	4c 8d 84 24 30 02 00 	lea    0x230(%rsp),%r8
    1f20:	00 
    1f21:	eb 18                	jmp    1f3b <mesh_packet+0x191b>
    1f23:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    1f28:	0f b6 33             	movzbl (%rbx),%esi
    1f2b:	41 83 c2 01          	add    $0x1,%r10d
    1f2f:	48 83 c2 08          	add    $0x8,%rdx
    1f33:	48 89 f1             	mov    %rsi,%rcx
    1f36:	41 39 f2             	cmp    %esi,%r10d
    1f39:	73 2a                	jae    1f65 <mesh_packet+0x1945>
    1f3b:	41 83 c1 01          	add    $0x1,%r9d
    1f3f:	48 8d 4a 04          	lea    0x4(%rdx),%rcx
    1f43:	48 89 ef             	mov    %rbp,%rdi
    1f46:	43 8d 04 49          	lea    (%r9,%r9,2),%eax
    1f4a:	8d 34 85 f4 ff ff ff 	lea    -0xc(,%rax,4),%esi
    1f51:	4c 01 e6             	add    %r12,%rsi
    1f54:	4c 01 ee             	add    %r13,%rsi
    1f57:	e8 34 e1 ff ff       	call   90 <mesh_project>
    1f5c:	84 c0                	test   %al,%al
    1f5e:	75 c8                	jne    1f28 <mesh_packet+0x1908>
    1f60:	e9 3b eb ff ff       	jmp    aa0 <mesh_packet+0x480>
    1f65:	8b 84 24 f0 03 00 00 	mov    0x3f0(%rsp),%eax
    1f6c:	85 c0                	test   %eax,%eax
    1f6e:	0f 84 c1 fe ff ff    	je     1e35 <mesh_packet+0x1815>
    1f74:	85 f6                	test   %esi,%esi
    1f76:	0f 84 b9 fe ff ff    	je     1e35 <mesh_packet+0x1815>
    1f7c:	45 31 e4             	xor    %r12d,%r12d
    1f7f:	45 31 c0             	xor    %r8d,%r8d
    1f82:	66 0f ef d2          	pxor   %xmm2,%xmm2
    1f86:	45 31 ed             	xor    %r13d,%r13d
    1f89:	31 d2                	xor    %edx,%edx
    1f8b:	41 8d 44 24 01       	lea    0x1(%r12),%eax
    1f90:	66 0f ef ed          	pxor   %xmm5,%xmm5
    1f94:	45 89 e2             	mov    %r12d,%r10d
    1f97:	66 0f ef db          	pxor   %xmm3,%xmm3
    1f9b:	f3 42 0f 5a 6c e3 04 	cvtss2sd 0x4(%rbx,%r12,8),%xmm5
    1fa2:	66 0f ef e4          	pxor   %xmm4,%xmm4
    1fa6:	66 0f ef f6          	pxor   %xmm6,%xmm6
    1faa:	f7 f6                	div    %esi
    1fac:	f3 42 0f 5a 74 e3 08 	cvtss2sd 0x8(%rbx,%r12,8),%xmm6
    1fb3:	8d 3c 12             	lea    (%rdx,%rdx,1),%edi
    1fb6:	f3 0f 5a 5c bb 04    	cvtss2sd 0x4(%rbx,%rdi,4),%xmm3
    1fbc:	f2 0f 5c dd          	subsd  %xmm5,%xmm3
    1fc0:	48 89 f8             	mov    %rdi,%rax
    1fc3:	83 c0 01             	add    $0x1,%eax
    1fc6:	f3 0f 5a 64 83 04    	cvtss2sd 0x4(%rbx,%rax,4),%xmm4
    1fcc:	f2 0f 5c e6          	subsd  %xmm6,%xmm4
    1fd0:	66 0f 2e da          	ucomisd %xmm2,%xmm3
    1fd4:	0f 9b c0             	setnp  %al
    1fd7:	41 0f 45 c5          	cmovne %r13d,%eax
    1fdb:	84 c0                	test   %al,%al
    1fdd:	74 13                	je     1ff2 <mesh_packet+0x19d2>
    1fdf:	66 0f 2e e2          	ucomisd %xmm2,%xmm4
    1fe3:	0f 9b c0             	setnp  %al
    1fe6:	41 0f 45 c5          	cmovne %r13d,%eax
    1fea:	84 c0                	test   %al,%al
    1fec:	0f 85 ae ea ff ff    	jne    aa0 <mesh_packet+0x480>
    1ff2:	89 74 24 08          	mov    %esi,0x8(%rsp)
    1ff6:	31 c0                	xor    %eax,%eax
    1ff8:	eb 09                	jmp    2003 <mesh_packet+0x19e3>
    1ffa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    2000:	48 89 f0             	mov    %rsi,%rax
    2003:	41 39 c2             	cmp    %eax,%r10d
    2006:	74 59                	je     2061 <mesh_packet+0x1a41>
    2008:	39 c2                	cmp    %eax,%edx
    200a:	74 55                	je     2061 <mesh_packet+0x1a41>
    200c:	66 0f ef c0          	pxor   %xmm0,%xmm0
    2010:	66 0f ef c9          	pxor   %xmm1,%xmm1
    2014:	31 f6                	xor    %esi,%esi
    2016:	f3 0f 5a 44 c3 08    	cvtss2sd 0x8(%rbx,%rax,8),%xmm0
    201c:	f3 0f 5a 4c c3 04    	cvtss2sd 0x4(%rbx,%rax,8),%xmm1
    2022:	f2 0f 5c c6          	subsd  %xmm6,%xmm0
    2026:	f2 0f 5c cd          	subsd  %xmm5,%xmm1
    202a:	f2 0f 59 c3          	mulsd  %xmm3,%xmm0
    202e:	f2 0f 59 cc          	mulsd  %xmm4,%xmm1
    2032:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    2036:	66 0f 2f c2          	comisd %xmm2,%xmm0
    203a:	40 0f 97 c6          	seta   %sil
    203e:	31 ff                	xor    %edi,%edi
    2040:	66 0f 2f d0          	comisd %xmm0,%xmm2
    2044:	40 0f 97 c7          	seta   %dil
    2048:	29 fe                	sub    %edi,%esi
    204a:	0f 84 50 ea ff ff    	je     aa0 <mesh_packet+0x480>
    2050:	45 85 c0             	test   %r8d,%r8d
    2053:	74 09                	je     205e <mesh_packet+0x1a3e>
    2055:	41 39 f0             	cmp    %esi,%r8d
    2058:	0f 85 42 ea ff ff    	jne    aa0 <mesh_packet+0x480>
    205e:	41 89 f0             	mov    %esi,%r8d
    2061:	48 8d 70 01          	lea    0x1(%rax),%rsi
    2065:	48 39 f1             	cmp    %rsi,%rcx
    2068:	75 96                	jne    2000 <mesh_packet+0x19e0>
    206a:	8b 74 24 08          	mov    0x8(%rsp),%esi
    206e:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
    2073:	4c 39 e0             	cmp    %r12,%rax
    2076:	0f 84 b9 fd ff ff    	je     1e35 <mesh_packet+0x1815>
    207c:	49 89 d4             	mov    %rdx,%r12
    207f:	e9 05 ff ff ff       	jmp    1f89 <mesh_packet+0x1969>
    2084:	85 c0                	test   %eax,%eax
    2086:	74 6f                	je     20f7 <mesh_packet+0x1ad7>
    2088:	44 8d 78 ff          	lea    -0x1(%rax),%r15d
    208c:	89 c5                	mov    %eax,%ebp
    208e:	4d 89 fc             	mov    %r15,%r12
    2091:	48 8d bc ec f0 03 00 	lea    0x3f0(%rsp,%rbp,8),%rdi
    2098:	00 
    2099:	4c 8d 8c 2c f0 01 00 	lea    0x1f0(%rsp,%rbp,1),%r9
    20a0:	00 
    20a1:	49 29 ec             	sub    %rbp,%r12
    20a4:	eb 39                	jmp    20df <mesh_packet+0x1abf>
    20a6:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    20ad:	00 00 00 00 
    20b1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    20b8:	00 00 00 00 
    20bc:	0f 1f 40 00          	nopl   0x0(%rax)
    20c0:	4c 89 ca             	mov    %r9,%rdx
    20c3:	f2 0f 11 0f          	movsd  %xmm1,(%rdi)
    20c7:	49 83 e9 01          	sub    $0x1,%r9
    20cb:	48 83 ef 08          	sub    $0x8,%rdi
    20cf:	48 29 ea             	sub    %rbp,%rdx
    20d2:	42 0f b6 14 3a       	movzbl (%rdx,%r15,1),%edx
    20d7:	41 88 51 01          	mov    %dl,0x1(%r9)
    20db:	85 c0                	test   %eax,%eax
    20dd:	74 18                	je     20f7 <mesh_packet+0x1ad7>
    20df:	f2 42 0f 10 0c e7    	movsd  (%rdi,%r12,8),%xmm1
    20e5:	89 c2                	mov    %eax,%edx
    20e7:	83 e8 01             	sub    $0x1,%eax
    20ea:	66 0f 2f c8          	comisd %xmm0,%xmm1
    20ee:	77 d0                	ja     20c0 <mesh_packet+0x1aa0>
    20f0:	89 d0                	mov    %edx,%eax
    20f2:	e9 ec fb ff ff       	jmp    1ce3 <mesh_packet+0x16c3>
    20f7:	31 c0                	xor    %eax,%eax
    20f9:	e9 e5 fb ff ff       	jmp    1ce3 <mesh_packet+0x16c3>
    20fe:	31 d2                	xor    %edx,%edx
    2100:	48 8b 84 24 58 01 00 	mov    0x158(%rsp),%rax
    2107:	00 
    2108:	88 50 55             	mov    %dl,0x55(%rax)
    210b:	44 89 84 24 f0 03 00 	mov    %r8d,0x3f0(%rsp)
    2112:	00 
    2113:	e9 af fd ff ff       	jmp    1ec7 <mesh_packet+0x18a7>
    2118:	89 c2                	mov    %eax,%edx
    211a:	41 89 c0             	mov    %eax,%r8d
    211d:	eb e1                	jmp    2100 <mesh_packet+0x1ae0>
    211f:	90                   	nop

0000000000002120 <ayatsuri_model_open>:
    2120:	41 57                	push   %r15
    2122:	41 56                	push   %r14
    2124:	41 55                	push   %r13
    2126:	41 54                	push   %r12
    2128:	55                   	push   %rbp
    2129:	53                   	push   %rbx
    212a:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
    2131:	48 85 ff             	test   %rdi,%rdi
    2134:	74 2a                	je     2160 <ayatsuri_model_open+0x40>
    2136:	48 89 d5             	mov    %rdx,%rbp
    2139:	48 85 d2             	test   %rdx,%rdx
    213c:	74 22                	je     2160 <ayatsuri_model_open+0x40>
    213e:	48 8d 46 e0          	lea    -0x20(%rsi),%rax
    2142:	48 3d e0 ff 0f 00    	cmp    $0xfffe0,%rax
    2148:	77 16                	ja     2160 <ayatsuri_model_open+0x40>
    214a:	48 89 fb             	mov    %rdi,%rbx
    214d:	48 39 d7             	cmp    %rdx,%rdi
    2150:	72 2e                	jb     2180 <ayatsuri_model_open+0x60>
    2152:	48 89 fa             	mov    %rdi,%rdx
    2155:	48 29 ea             	sub    %rbp,%rdx
    2158:	48 83 fa 7f          	cmp    $0x7f,%rdx
    215c:	77 2a                	ja     2188 <ayatsuri_model_open+0x68>
    215e:	66 90                	xchg   %ax,%ax
    2160:	41 bc 01 00 00 00    	mov    $0x1,%r12d
    2166:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
    216d:	44 89 e0             	mov    %r12d,%eax
    2170:	5b                   	pop    %rbx
    2171:	5d                   	pop    %rbp
    2172:	41 5c                	pop    %r12
    2174:	41 5d                	pop    %r13
    2176:	41 5e                	pop    %r14
    2178:	41 5f                	pop    %r15
    217a:	c3                   	ret
    217b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    2180:	48 29 fa             	sub    %rdi,%rdx
    2183:	48 39 f2             	cmp    %rsi,%rdx
    2186:	72 d8                	jb     2160 <ayatsuri_model_open+0x40>
    2188:	81 3b 41 59 4e 4d    	cmpl   $0x4d4e5941,(%rbx)
    218e:	75 d0                	jne    2160 <ayatsuri_model_open+0x40>
    2190:	66 83 7b 04 01       	cmpw   $0x1,0x4(%rbx)
    2195:	75 c9                	jne    2160 <ayatsuri_model_open+0x40>
    2197:	66 83 7b 06 20       	cmpw   $0x20,0x6(%rbx)
    219c:	75 c2                	jne    2160 <ayatsuri_model_open+0x40>
    219e:	8b 53 08             	mov    0x8(%rbx),%edx
    21a1:	48 39 f2             	cmp    %rsi,%rdx
    21a4:	75 ba                	jne    2160 <ayatsuri_model_open+0x40>
    21a6:	44 8b 43 0c          	mov    0xc(%rbx),%r8d
    21aa:	41 8d 50 f9          	lea    -0x7(%r8),%edx
    21ae:	83 fa 39             	cmp    $0x39,%edx
    21b1:	77 ad                	ja     2160 <ayatsuri_model_open+0x40>
    21b3:	83 7b 10 20          	cmpl   $0x20,0x10(%rbx)
    21b7:	75 a7                	jne    2160 <ayatsuri_model_open+0x40>
    21b9:	83 7b 14 14          	cmpl   $0x14,0x14(%rbx)
    21bd:	75 a1                	jne    2160 <ayatsuri_model_open+0x40>
    21bf:	8b 53 18             	mov    0x18(%rbx),%edx
    21c2:	85 d2                	test   %edx,%edx
    21c4:	75 9a                	jne    2160 <ayatsuri_model_open+0x40>
    21c6:	44 8b 63 1c          	mov    0x1c(%rbx),%r12d
    21ca:	45 85 e4             	test   %r12d,%r12d
    21cd:	75 91                	jne    2160 <ayatsuri_model_open+0x40>
    21cf:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
    21d6:	cc cc cc 
    21d9:	44 89 c1             	mov    %r8d,%ecx
    21dc:	48 f7 e2             	mul    %rdx
    21df:	48 89 d0             	mov    %rdx,%rax
    21e2:	48 c1 e8 04          	shr    $0x4,%rax
    21e6:	48 39 c8             	cmp    %rcx,%rax
    21e9:	0f 82 71 ff ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    21ef:	41 6b c0 14          	imul   $0x14,%r8d,%eax
    21f3:	b9 1d 00 00 00       	mov    $0x1d,%ecx
    21f8:	31 d2                	xor    %edx,%edx
    21fa:	45 31 ff             	xor    %r15d,%r15d
    21fd:	48 8d bc 24 9c 00 00 	lea    0x9c(%rsp),%rdi
    2204:	00 
    2205:	48 89 9c 24 90 00 00 	mov    %rbx,0x90(%rsp)
    220c:	00 
    220d:	89 b4 24 98 00 00 00 	mov    %esi,0x98(%rsp)
    2214:	83 c0 20             	add    $0x20,%eax
    2217:	89 54 24 08          	mov    %edx,0x8(%rsp)
    221b:	44 89 e2             	mov    %r12d,%edx
    221e:	89 44 24 0c          	mov    %eax,0xc(%rsp)
    2222:	31 c0                	xor    %eax,%eax
    2224:	f3 ab                	rep stos %eax,%es:(%rdi)
    2226:	48 8d 43 24          	lea    0x24(%rbx),%rax
    222a:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
    222f:	49 89 c5             	mov    %rax,%r13
    2232:	41 0f b7 7d fe       	movzwl -0x2(%r13),%edi
    2237:	45 8b 4d 00          	mov    0x0(%r13),%r9d
    223b:	45 8b 55 04          	mov    0x4(%r13),%r10d
    223f:	66 83 ff 01          	cmp    $0x1,%di
    2243:	0f 87 17 ff ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    2249:	41 f6 c1 07          	test   $0x7,%r9b
    224d:	0f 85 0d ff ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    2253:	8b 44 24 0c          	mov    0xc(%rsp),%eax
    2257:	41 39 c1             	cmp    %eax,%r9d
    225a:	0f 82 00 ff ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2260:	45 89 cc             	mov    %r9d,%r12d
    2263:	4c 39 e6             	cmp    %r12,%rsi
    2266:	0f 82 f4 fe ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    226c:	48 89 f0             	mov    %rsi,%rax
    226f:	4c 29 e0             	sub    %r12,%rax
    2272:	4c 39 d0             	cmp    %r10,%rax
    2275:	0f 82 e5 fe ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    227b:	8b 44 24 08          	mov    0x8(%rsp),%eax
    227f:	85 c0                	test   %eax,%eax
    2281:	74 65                	je     22e8 <ayatsuri_model_open+0x1c8>
    2283:	4d 85 d2             	test   %r10,%r10
    2286:	44 89 7c 24 38       	mov    %r15d,0x38(%rsp)
    228b:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    2290:	4e 8d 34 23          	lea    (%rbx,%r12,1),%r14
    2294:	44 89 44 24 18       	mov    %r8d,0x18(%rsp)
    2299:	41 0f 95 c3          	setne  %r11b
    229d:	eb 15                	jmp    22b4 <ayatsuri_model_open+0x194>
    229f:	4d 29 e0             	sub    %r12,%r8
    22a2:	4d 39 d0             	cmp    %r10,%r8
    22a5:	0f 82 b5 fe ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    22ab:	48 83 c0 14          	add    $0x14,%rax
    22af:	4c 39 e8             	cmp    %r13,%rax
    22b2:	74 2a                	je     22de <ayatsuri_model_open+0x1be>
    22b4:	8b 48 04             	mov    0x4(%rax),%ecx
    22b7:	48 85 c9             	test   %rcx,%rcx
    22ba:	74 ef                	je     22ab <ayatsuri_model_open+0x18b>
    22bc:	45 84 db             	test   %r11b,%r11b
    22bf:	74 ea                	je     22ab <ayatsuri_model_open+0x18b>
    22c1:	44 8b 00             	mov    (%rax),%r8d
    22c4:	4e 8d 3c 03          	lea    (%rbx,%r8,1),%r15
    22c8:	4d 39 f7             	cmp    %r14,%r15
    22cb:	73 d2                	jae    229f <ayatsuri_model_open+0x17f>
    22cd:	4d 89 e7             	mov    %r12,%r15
    22d0:	4d 29 c7             	sub    %r8,%r15
    22d3:	49 39 cf             	cmp    %rcx,%r15
    22d6:	0f 82 84 fe ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    22dc:	eb cd                	jmp    22ab <ayatsuri_model_open+0x18b>
    22de:	44 8b 7c 24 38       	mov    0x38(%rsp),%r15d
    22e3:	44 8b 44 24 18       	mov    0x18(%rsp),%r8d
    22e8:	41 0f b7 4d fc       	movzwl -0x4(%r13),%ecx
    22ed:	66 41 0f 6e 45 08    	movd   0x8(%r13),%xmm0
    22f3:	41 8b 45 0c          	mov    0xc(%r13),%eax
    22f7:	44 8d 59 ff          	lea    -0x1(%rcx),%r11d
    22fb:	66 41 83 fb 0c       	cmp    $0xc,%r11w
    2300:	0f 87 f5 01 00 00    	ja     24fb <ayatsuri_model_open+0x3db>
    2306:	83 e9 01             	sub    $0x1,%ecx
    2309:	41 bb 01 00 00 00    	mov    $0x1,%r11d
    230f:	41 d3 e3             	shl    %cl,%r11d
    2312:	66 83 ef 01          	sub    $0x1,%di
    2316:	0f 85 44 fe ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    231c:	45 85 fb             	test   %r15d,%r11d
    231f:	0f 85 3b fe ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    2325:	48 63 c9             	movslq %ecx,%rcx
    2328:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 232f <ayatsuri_model_open+0x20f>
			232b: R_X86_64_PC32	.rodata-0x4
    232f:	39 04 8f             	cmp    %eax,(%rdi,%rcx,4)
    2332:	0f 85 28 fe ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    2338:	66 0f 7e c7          	movd   %xmm0,%edi
    233c:	48 0f af c7          	imul   %rdi,%rax
    2340:	49 39 c2             	cmp    %rax,%r10
    2343:	0f 85 17 fe ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    2349:	66 41 0f 6e c9       	movd   %r9d,%xmm1
    234e:	45 09 df             	or     %r11d,%r15d
    2351:	66 0f 62 c8          	punpckldq %xmm0,%xmm1
    2355:	66 0f d6 8c cc a4 00 	movq   %xmm1,0xa4(%rsp,%rcx,8)
    235c:	00 00 
    235e:	83 44 24 08 01       	addl   $0x1,0x8(%rsp)
    2363:	8b 44 24 08          	mov    0x8(%rsp),%eax
    2367:	49 83 c5 14          	add    $0x14,%r13
    236b:	41 39 c0             	cmp    %eax,%r8d
    236e:	0f 85 be fe ff ff    	jne    2232 <ayatsuri_model_open+0x112>
    2374:	44 89 f8             	mov    %r15d,%eax
    2377:	41 89 d4             	mov    %edx,%r12d
    237a:	f7 d0                	not    %eax
    237c:	a8 7f                	test   $0x7f,%al
    237e:	0f 85 dc fd ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    2384:	44 89 f8             	mov    %r15d,%eax
    2387:	25 00 0f 00 00       	and    $0xf00,%eax
    238c:	89 44 24 38          	mov    %eax,0x38(%rsp)
    2390:	74 0b                	je     239d <ayatsuri_model_open+0x27d>
    2392:	3d 00 0f 00 00       	cmp    $0xf00,%eax
    2397:	0f 85 c3 fd ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    239d:	44 8b ac 24 a8 00 00 	mov    0xa8(%rsp),%r13d
    23a4:	00 
    23a5:	41 8d 45 ff          	lea    -0x1(%r13),%eax
    23a9:	3d ff 00 00 00       	cmp    $0xff,%eax
    23ae:	0f 87 ac fd ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    23b4:	44 39 ac 24 b0 00 00 	cmp    %r13d,0xb0(%rsp)
    23bb:	00 
    23bc:	0f 85 9e fd ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    23c2:	44 39 ac 24 d0 00 00 	cmp    %r13d,0xd0(%rsp)
    23c9:	00 
    23ca:	0f 85 90 fd ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    23d0:	8b 84 24 b8 00 00 00 	mov    0xb8(%rsp),%eax
    23d7:	89 44 24 0c          	mov    %eax,0xc(%rsp)
    23db:	41 39 c5             	cmp    %eax,%r13d
    23de:	0f 82 7c fd ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    23e4:	8b 8c 24 c0 00 00 00 	mov    0xc0(%rsp),%ecx
    23eb:	42 8d 04 ed 00 00 00 	lea    0x0(,%r13,8),%eax
    23f2:	00 
    23f3:	89 4c 24 10          	mov    %ecx,0x10(%rsp)
    23f7:	39 c8                	cmp    %ecx,%eax
    23f9:	0f 82 61 fd ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    23ff:	8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%eax
    2406:	89 44 24 08          	mov    %eax,0x8(%rsp)
    240a:	41 39 c5             	cmp    %eax,%r13d
    240d:	0f 82 4d fd ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2413:	41 6b c5 7f          	imul   $0x7f,%r13d,%eax
    2417:	44 8b b4 24 d8 00 00 	mov    0xd8(%rsp),%r14d
    241e:	00 
    241f:	44 39 f0             	cmp    %r14d,%eax
    2422:	0f 82 38 fd ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2428:	41 f6 c7 80          	test   $0x80,%r15b
    242c:	74 13                	je     2441 <ayatsuri_model_open+0x321>
    242e:	8b 84 24 e0 00 00 00 	mov    0xe0(%rsp),%eax
    2435:	83 e8 01             	sub    $0x1,%eax
    2438:	44 39 e8             	cmp    %r13d,%eax
    243b:	0f 83 1f fd ff ff    	jae    2160 <ayatsuri_model_open+0x40>
    2441:	83 7c 24 38 00       	cmpl   $0x0,0x38(%rsp)
    2446:	74 4c                	je     2494 <ayatsuri_model_open+0x374>
    2448:	8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%eax
    244f:	83 e8 01             	sub    $0x1,%eax
    2452:	44 39 e8             	cmp    %r13d,%eax
    2455:	0f 83 05 fd ff ff    	jae    2160 <ayatsuri_model_open+0x40>
    245b:	44 89 e8             	mov    %r13d,%eax
    245e:	c1 e0 05             	shl    $0x5,%eax
    2461:	3b 84 24 f0 00 00 00 	cmp    0xf0(%rsp),%eax
    2468:	0f 82 f2 fc ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    246e:	44 89 e8             	mov    %r13d,%eax
    2471:	c1 e0 06             	shl    $0x6,%eax
    2474:	3b 84 24 f8 00 00 00 	cmp    0xf8(%rsp),%eax
    247b:	0f 82 df fc ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2481:	44 89 e8             	mov    %r13d,%eax
    2484:	c1 e0 04             	shl    $0x4,%eax
    2487:	3b 84 24 00 01 00 00 	cmp    0x100(%rsp),%eax
    248e:	0f 82 cc fc ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2494:	41 81 e7 00 10 00 00 	and    $0x1000,%r15d
    249b:	0f 84 81 00 00 00    	je     2522 <ayatsuri_model_open+0x402>
    24a1:	8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%ecx
    24a8:	85 c9                	test   %ecx,%ecx
    24aa:	0f 84 b0 fc ff ff    	je     2160 <ayatsuri_model_open+0x40>
    24b0:	39 4c 24 08          	cmp    %ecx,0x8(%rsp)
    24b4:	0f 85 a6 fc ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    24ba:	8b 84 24 04 01 00 00 	mov    0x104(%rsp),%eax
    24c1:	31 d2                	xor    %edx,%edx
    24c3:	48 01 d8             	add    %rbx,%rax
    24c6:	eb 29                	jmp    24f1 <ayatsuri_model_open+0x3d1>
    24c8:	80 78 01 00          	cmpb   $0x0,0x1(%rax)
    24cc:	0f 85 8e fc ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    24d2:	80 78 02 00          	cmpb   $0x0,0x2(%rax)
    24d6:	0f 85 84 fc ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    24dc:	80 78 03 00          	cmpb   $0x0,0x3(%rax)
    24e0:	0f 85 7a fc ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    24e6:	83 c2 01             	add    $0x1,%edx
    24e9:	48 83 c0 04          	add    $0x4,%rax
    24ed:	39 ca                	cmp    %ecx,%edx
    24ef:	73 31                	jae    2522 <ayatsuri_model_open+0x402>
    24f1:	80 38 01             	cmpb   $0x1,(%rax)
    24f4:	76 d2                	jbe    24c8 <ayatsuri_model_open+0x3a8>
    24f6:	e9 65 fc ff ff       	jmp    2160 <ayatsuri_model_open+0x40>
    24fb:	66 85 ff             	test   %di,%di
    24fe:	0f 85 5c fc ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    2504:	85 c0                	test   %eax,%eax
    2506:	0f 84 52 fe ff ff    	je     235e <ayatsuri_model_open+0x23e>
    250c:	66 0f 7e c1          	movd   %xmm0,%ecx
    2510:	48 0f af c1          	imul   %rcx,%rax
    2514:	49 39 c2             	cmp    %rax,%r10
    2517:	0f 83 41 fe ff ff    	jae    235e <ayatsuri_model_open+0x23e>
    251d:	e9 3e fc ff ff       	jmp    2160 <ayatsuri_model_open+0x40>
    2522:	8b 84 24 f0 00 00 00 	mov    0xf0(%rsp),%eax
    2529:	44 8b 84 24 ec 00 00 	mov    0xec(%rsp),%r8d
    2530:	00 
    2531:	31 d2                	xor    %edx,%edx
    2533:	66 44 89 ac 24 9c 00 	mov    %r13w,0x9c(%rsp)
    253a:	00 00 
    253c:	f3 0f 10 25 00 00 00 	movss  0x0(%rip),%xmm4        # 2544 <ayatsuri_model_open+0x424>
    2543:	00 
			2540: R_X86_64_PC32	.LC1-0x4
    2544:	f3 0f 7e 1d 00 00 00 	movq   0x0(%rip),%xmm3        # 254c <ayatsuri_model_open+0x42c>
    254b:	00 
			2548: R_X86_64_PC32	.LC8-0x4
    254c:	f3 0f 10 2d 00 00 00 	movss  0x0(%rip),%xmm5        # 2554 <ayatsuri_model_open+0x434>
    2553:	00 
			2550: R_X86_64_PC32	.LC0-0x4
    2554:	89 44 24 18          	mov    %eax,0x18(%rsp)
    2558:	8b 44 24 18          	mov    0x18(%rsp),%eax
    255c:	39 c2                	cmp    %eax,%edx
    255e:	74 61                	je     25c1 <ayatsuri_model_open+0x4a1>
    2560:	6b ca 1c             	imul   $0x1c,%edx,%ecx
    2563:	31 c0                	xor    %eax,%eax
    2565:	66 0f ef c0          	pxor   %xmm0,%xmm0
    2569:	4c 01 c1             	add    %r8,%rcx
    256c:	48 01 d9             	add    %rbx,%rcx
    256f:	f3 0f 10 0c 81       	movss  (%rcx,%rax,4),%xmm1
    2574:	0f 28 d1             	movaps %xmm1,%xmm2
    2577:	0f 54 d5             	andps  %xmm5,%xmm2
    257a:	0f 2e e2             	ucomiss %xmm2,%xmm4
    257d:	0f 82 dd fb ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2583:	0f 2f 15 00 00 00 00 	comiss 0x0(%rip),%xmm2        # 258a <ayatsuri_model_open+0x46a>
			2586: R_X86_64_PC32	.LC3-0x4
    258a:	0f 87 d0 fb ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    2590:	8d 70 fd             	lea    -0x3(%rax),%esi
    2593:	83 fe 02             	cmp    $0x2,%esi
    2596:	76 7d                	jbe    2615 <ayatsuri_model_open+0x4f5>
    2598:	48 83 c0 01          	add    $0x1,%rax
    259c:	48 83 f8 07          	cmp    $0x7,%rax
    25a0:	75 cd                	jne    256f <ayatsuri_model_open+0x44f>
    25a2:	f2 0f 5c 05 00 00 00 	subsd  0x0(%rip),%xmm0        # 25aa <ayatsuri_model_open+0x48a>
    25a9:	00 
			25a6: R_X86_64_PC32	.LC9-0x4
    25aa:	66 0f 54 c3          	andpd  %xmm3,%xmm0
    25ae:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 25b6 <ayatsuri_model_open+0x496>
    25b5:	00 
			25b2: R_X86_64_PC32	.LC29-0x4
    25b6:	0f 87 a4 fb ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    25bc:	83 c2 01             	add    $0x1,%edx
    25bf:	eb 97                	jmp    2558 <ayatsuri_model_open+0x438>
    25c1:	8b 84 24 f8 00 00 00 	mov    0xf8(%rsp),%eax
    25c8:	31 d2                	xor    %edx,%edx
    25ca:	89 44 24 28          	mov    %eax,0x28(%rsp)
    25ce:	8b 84 24 f4 00 00 00 	mov    0xf4(%rsp),%eax
    25d5:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
    25da:	8b 44 24 28          	mov    0x28(%rsp),%eax
    25de:	39 c2                	cmp    %eax,%edx
    25e0:	74 48                	je     262a <ayatsuri_model_open+0x50a>
    25e2:	6b c2 06             	imul   $0x6,%edx,%eax
    25e5:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    25ea:	48 01 c8             	add    %rcx,%rax
    25ed:	66 83 3c 03 1f       	cmpw   $0x1f,(%rbx,%rax,1)
    25f2:	0f 87 68 fb ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    25f8:	66 83 7c 03 02 1f    	cmpw   $0x1f,0x2(%rbx,%rax,1)
    25fe:	0f 87 5c fb ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    2604:	66 83 7c 03 04 1f    	cmpw   $0x1f,0x4(%rbx,%rax,1)
    260a:	0f 87 50 fb ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    2610:	83 c2 01             	add    $0x1,%edx
    2613:	eb c5                	jmp    25da <ayatsuri_model_open+0x4ba>
    2615:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
    2619:	f2 0f 59 c9          	mulsd  %xmm1,%xmm1
    261d:	48 83 c0 01          	add    $0x1,%rax
    2621:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    2625:	e9 45 ff ff ff       	jmp    256f <ayatsuri_model_open+0x44f>
    262a:	8b 84 24 00 01 00 00 	mov    0x100(%rsp),%eax
    2631:	8b b4 24 fc 00 00 00 	mov    0xfc(%rsp),%esi
    2638:	31 d2                	xor    %edx,%edx
    263a:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 2642 <ayatsuri_model_open+0x522>
    2641:	00 
			263e: R_X86_64_PC32	.LC0-0x4
    2642:	f3 0f 10 0d 00 00 00 	movss  0x0(%rip),%xmm1        # 264a <ayatsuri_model_open+0x52a>
    2649:	00 
			2646: R_X86_64_PC32	.LC1-0x4
    264a:	89 44 24 30          	mov    %eax,0x30(%rsp)
    264e:	8b 44 24 30          	mov    0x30(%rsp),%eax
    2652:	39 c2                	cmp    %eax,%edx
    2654:	74 38                	je     268e <ayatsuri_model_open+0x56e>
    2656:	6b c2 0c             	imul   $0xc,%edx,%eax
    2659:	31 c9                	xor    %ecx,%ecx
    265b:	48 01 f0             	add    %rsi,%rax
    265e:	48 01 d8             	add    %rbx,%rax
    2661:	f3 0f 10 04 88       	movss  (%rax,%rcx,4),%xmm0
    2666:	0f 54 c2             	andps  %xmm2,%xmm0
    2669:	0f 2e c8             	ucomiss %xmm0,%xmm1
    266c:	0f 82 ee fa ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2672:	0f 2f 05 00 00 00 00 	comiss 0x0(%rip),%xmm0        # 2679 <ayatsuri_model_open+0x559>
			2675: R_X86_64_PC32	.LC3-0x4
    2679:	0f 87 e1 fa ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    267f:	48 83 c1 01          	add    $0x1,%rcx
    2683:	48 83 f9 03          	cmp    $0x3,%rcx
    2687:	75 d8                	jne    2661 <ayatsuri_model_open+0x541>
    2689:	83 c2 01             	add    $0x1,%edx
    268c:	eb c0                	jmp    264e <ayatsuri_model_open+0x52e>
    268e:	8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%eax
    2695:	48 89 6c 24 48       	mov    %rbp,0x48(%rsp)
    269a:	31 d2                	xor    %edx,%edx
    269c:	66 0f ef f6          	pxor   %xmm6,%xmm6
    26a0:	89 44 24 3c          	mov    %eax,0x3c(%rsp)
    26a4:	8b 84 24 e4 00 00 00 	mov    0xe4(%rsp),%eax
    26ab:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
    26b0:	8b 44 24 3c          	mov    0x3c(%rsp),%eax
    26b4:	39 c2                	cmp    %eax,%edx
    26b6:	0f 84 5c 02 00 00    	je     2918 <ayatsuri_model_open+0x7f8>
    26bc:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
    26c1:	89 d0                	mov    %edx,%eax
    26c3:	c1 e0 05             	shl    $0x5,%eax
    26c6:	48 01 c8             	add    %rcx,%rax
    26c9:	48 01 d8             	add    %rbx,%rax
    26cc:	44 0f b7 50 02       	movzwl 0x2(%rax),%r10d
    26d1:	44 0f b7 08          	movzwl (%rax),%r9d
    26d5:	0f b7 48 04          	movzwl 0x4(%rax),%ecx
    26d9:	44 0f b7 58 06       	movzwl 0x6(%rax),%r11d
    26de:	41 8d 72 fd          	lea    -0x3(%r10),%esi
    26e2:	0f b7 68 08          	movzwl 0x8(%rax),%ebp
    26e6:	83 fe 1d             	cmp    $0x1d,%esi
    26e9:	0f 87 71 fa ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    26ef:	41 8d 73 ff          	lea    -0x1(%r11),%esi
    26f3:	83 fe 3f             	cmp    $0x3f,%esi
    26f6:	0f 87 64 fa ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    26fc:	0f b6 78 0a          	movzbl 0xa(%rax),%edi
    2700:	40 80 ff 02          	cmp    $0x2,%dil
    2704:	0f 87 56 fa ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    270a:	80 78 0b 01          	cmpb   $0x1,0xb(%rax)
    270e:	0f 87 4c fa ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    2714:	8b 74 24 18          	mov    0x18(%rsp),%esi
    2718:	44 39 ce             	cmp    %r9d,%esi
    271b:	0f 82 3f fa ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2721:	44 29 ce             	sub    %r9d,%esi
    2724:	44 39 d6             	cmp    %r10d,%esi
    2727:	0f 82 33 fa ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    272d:	8b 74 24 28          	mov    0x28(%rsp),%esi
    2731:	39 ce                	cmp    %ecx,%esi
    2733:	0f 82 27 fa ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2739:	29 ce                	sub    %ecx,%esi
    273b:	44 39 de             	cmp    %r11d,%esi
    273e:	0f 82 1c fa ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2744:	0f b6 70 0c          	movzbl 0xc(%rax),%esi
    2748:	40 84 ff             	test   %dil,%dil
    274b:	0f 85 94 01 00 00    	jne    28e5 <ayatsuri_model_open+0x7c5>
    2751:	40 84 f6             	test   %sil,%sil
    2754:	0f 85 06 fa ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    275a:	31 f6                	xor    %esi,%esi
    275c:	80 78 0d 00          	cmpb   $0x0,0xd(%rax)
    2760:	0f 85 fa f9 ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    2766:	8b 7c 24 30          	mov    0x30(%rsp),%edi
    276a:	39 ef                	cmp    %ebp,%edi
    276c:	0f 82 ee f9 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2772:	29 ef                	sub    %ebp,%edi
    2774:	39 f7                	cmp    %esi,%edi
    2776:	0f 82 e4 f9 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    277c:	be 13 00 00 00       	mov    $0x13,%esi
    2781:	80 3c 30 00          	cmpb   $0x0,(%rax,%rsi,1)
    2785:	0f 85 d5 f9 ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    278b:	48 83 c6 01          	add    $0x1,%rsi
    278f:	48 83 fe 20          	cmp    $0x20,%rsi
    2793:	75 ec                	jne    2781 <ayatsuri_model_open+0x661>
    2795:	6b f9 06             	imul   $0x6,%ecx,%edi
    2798:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
    279d:	31 ed                	xor    %ebp,%ebp
    279f:	48 01 c7             	add    %rax,%rdi
    27a2:	48 01 df             	add    %rbx,%rdi
    27a5:	0f b7 0f             	movzwl (%rdi),%ecx
    27a8:	0f b7 47 02          	movzwl 0x2(%rdi),%eax
    27ac:	0f b7 77 04          	movzwl 0x4(%rdi),%esi
    27b0:	39 c1                	cmp    %eax,%ecx
    27b2:	41 89 c7             	mov    %eax,%r15d
    27b5:	44 0f 43 f9          	cmovae %ecx,%r15d
    27b9:	45 39 d7             	cmp    %r10d,%r15d
    27bc:	0f 83 9e f9 ff ff    	jae    2160 <ayatsuri_model_open+0x40>
    27c2:	44 39 d6             	cmp    %r10d,%esi
    27c5:	0f 83 95 f9 ff ff    	jae    2160 <ayatsuri_model_open+0x40>
    27cb:	39 c1                	cmp    %eax,%ecx
    27cd:	0f 84 8d f9 ff ff    	je     2160 <ayatsuri_model_open+0x40>
    27d3:	39 f1                	cmp    %esi,%ecx
    27d5:	0f 84 85 f9 ff ff    	je     2160 <ayatsuri_model_open+0x40>
    27db:	39 f0                	cmp    %esi,%eax
    27dd:	41 0f 94 c7          	sete   %r15b
    27e1:	0f 84 79 f9 ff ff    	je     2160 <ayatsuri_model_open+0x40>
    27e7:	44 01 c9             	add    %r9d,%ecx
    27ea:	44 01 c8             	add    %r9d,%eax
    27ed:	66 0f ef ed          	pxor   %xmm5,%xmm5
    27f1:	44 01 ce             	add    %r9d,%esi
    27f4:	6b c9 1c             	imul   $0x1c,%ecx,%ecx
    27f7:	66 0f ef c0          	pxor   %xmm0,%xmm0
    27fb:	66 0f ef e4          	pxor   %xmm4,%xmm4
    27ff:	6b c0 1c             	imul   $0x1c,%eax,%eax
    2802:	66 0f ef db          	pxor   %xmm3,%xmm3
    2806:	66 0f ef d2          	pxor   %xmm2,%xmm2
    280a:	6b f6 1c             	imul   $0x1c,%esi,%esi
    280d:	66 0f ef ff          	pxor   %xmm7,%xmm7
    2811:	66 0f ef c9          	pxor   %xmm1,%xmm1
    2815:	4c 01 c1             	add    %r8,%rcx
    2818:	4c 01 c0             	add    %r8,%rax
    281b:	48 01 d9             	add    %rbx,%rcx
    281e:	4c 01 c6             	add    %r8,%rsi
    2821:	48 01 d8             	add    %rbx,%rax
    2824:	f3 0f 5a 29          	cvtss2sd (%rcx),%xmm5
    2828:	f3 0f 5a 59 04       	cvtss2sd 0x4(%rcx),%xmm3
    282d:	48 01 de             	add    %rbx,%rsi
    2830:	f3 0f 5a 00          	cvtss2sd (%rax),%xmm0
    2834:	f2 0f 5c c5          	subsd  %xmm5,%xmm0
    2838:	f3 0f 5a 79 08       	cvtss2sd 0x8(%rcx),%xmm7
    283d:	f3 0f 5a 26          	cvtss2sd (%rsi),%xmm4
    2841:	f2 0f 5c e5          	subsd  %xmm5,%xmm4
    2845:	66 0f ef ed          	pxor   %xmm5,%xmm5
    2849:	f3 0f 5a 50 04       	cvtss2sd 0x4(%rax),%xmm2
    284e:	f3 0f 5a 48 08       	cvtss2sd 0x8(%rax),%xmm1
    2853:	f2 0f 5c d3          	subsd  %xmm3,%xmm2
    2857:	f2 0f 5c cf          	subsd  %xmm7,%xmm1
    285b:	f3 0f 5a 6e 04       	cvtss2sd 0x4(%rsi),%xmm5
    2860:	f2 0f 5c eb          	subsd  %xmm3,%xmm5
    2864:	66 0f ef db          	pxor   %xmm3,%xmm3
    2868:	f3 0f 5a 5e 08       	cvtss2sd 0x8(%rsi),%xmm3
    286d:	f2 0f 5c df          	subsd  %xmm7,%xmm3
    2871:	66 44 0f 28 c1       	movapd %xmm1,%xmm8
    2876:	66 0f 28 fa          	movapd %xmm2,%xmm7
    287a:	f2 44 0f 59 c5       	mulsd  %xmm5,%xmm8
    287f:	f2 0f 59 fb          	mulsd  %xmm3,%xmm7
    2883:	f2 0f 59 cc          	mulsd  %xmm4,%xmm1
    2887:	f2 0f 59 d8          	mulsd  %xmm0,%xmm3
    288b:	f2 41 0f 5c f8       	subsd  %xmm8,%xmm7
    2890:	f2 0f 5c cb          	subsd  %xmm3,%xmm1
    2894:	66 0f 2e fe          	ucomisd %xmm6,%xmm7
    2898:	0f 9b c0             	setnp  %al
    289b:	41 0f 45 c7          	cmovne %r15d,%eax
    289f:	66 0f 2e ce          	ucomisd %xmm6,%xmm1
    28a3:	0f 9b c1             	setnp  %cl
    28a6:	41 0f 45 cf          	cmovne %r15d,%ecx
    28aa:	84 c8                	test   %cl,%al
    28ac:	74 1f                	je     28cd <ayatsuri_model_open+0x7ad>
    28ae:	f2 0f 59 c5          	mulsd  %xmm5,%xmm0
    28b2:	f2 0f 59 d4          	mulsd  %xmm4,%xmm2
    28b6:	f2 0f 5c c2          	subsd  %xmm2,%xmm0
    28ba:	66 0f 2e c6          	ucomisd %xmm6,%xmm0
    28be:	0f 9b c0             	setnp  %al
    28c1:	41 0f 45 c7          	cmovne %r15d,%eax
    28c5:	84 c0                	test   %al,%al
    28c7:	0f 85 93 f8 ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    28cd:	83 c5 01             	add    $0x1,%ebp
    28d0:	48 83 c7 06          	add    $0x6,%rdi
    28d4:	44 39 dd             	cmp    %r11d,%ebp
    28d7:	0f 82 c8 fe ff ff    	jb     27a5 <ayatsuri_model_open+0x685>
    28dd:	83 c2 01             	add    $0x1,%edx
    28e0:	e9 cb fd ff ff       	jmp    26b0 <ayatsuri_model_open+0x590>
    28e5:	44 8d 7e fd          	lea    -0x3(%rsi),%r15d
    28e9:	41 80 ff 05          	cmp    $0x5,%r15b
    28ed:	0f 87 6d f8 ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    28f3:	44 0f b6 78 0d       	movzbl 0xd(%rax),%r15d
    28f8:	40 80 ff 02          	cmp    $0x2,%dil
    28fc:	0f 85 5a fe ff ff    	jne    275c <ayatsuri_model_open+0x63c>
    2902:	41 8d 7f fd          	lea    -0x3(%r15),%edi
    2906:	40 80 ff 05          	cmp    $0x5,%dil
    290a:	0f 87 50 f8 ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    2910:	44 01 fe             	add    %r15d,%esi
    2913:	e9 4e fe ff ff       	jmp    2766 <ayatsuri_model_open+0x646>
    2918:	8b 84 24 d4 00 00 00 	mov    0xd4(%rsp),%eax
    291f:	48 8b 6c 24 48       	mov    0x48(%rsp),%rbp
    2924:	48 89 c1             	mov    %rax,%rcx
    2927:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
    292c:	31 c0                	xor    %eax,%eax
    292e:	48 01 d9             	add    %rbx,%rcx
    2931:	eb 21                	jmp    2954 <ayatsuri_model_open+0x834>
    2933:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    293a:	00 00 00 00 
    293e:	66 90                	xchg   %ax,%ax
    2940:	0f b6 3c 01          	movzbl (%rcx,%rax,1),%edi
    2944:	48 83 c0 01          	add    $0x1,%rax
    2948:	8d 57 e0             	lea    -0x20(%rdi),%edx
    294b:	80 fa 5e             	cmp    $0x5e,%dl
    294e:	0f 87 0c f8 ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    2954:	44 39 f0             	cmp    %r14d,%eax
    2957:	72 e7                	jb     2940 <ayatsuri_model_open+0x820>
    2959:	8b 84 24 ac 00 00 00 	mov    0xac(%rsp),%eax
    2960:	b9 09 00 00 00       	mov    $0x9,%ecx
    2965:	ba 09 00 00 00       	mov    $0x9,%edx
    296a:	44 89 ee             	mov    %r13d,%esi
    296d:	48 01 d8             	add    %rbx,%rax
    2970:	48 89 c7             	mov    %rax,%rdi
    2973:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
    2978:	e8 93 d6 ff ff       	call   10 <float_rows_valid>
    297d:	84 c0                	test   %al,%al
    297f:	0f 84 db f7 ff ff    	je     2160 <ayatsuri_model_open+0x40>
    2985:	8b bc 24 b4 00 00 00 	mov    0xb4(%rsp),%edi
    298c:	8b 74 24 0c          	mov    0xc(%rsp),%esi
    2990:	31 c9                	xor    %ecx,%ecx
    2992:	ba 03 00 00 00       	mov    $0x3,%edx
    2997:	48 01 df             	add    %rbx,%rdi
    299a:	e8 71 d6 ff ff       	call   10 <float_rows_valid>
    299f:	84 c0                	test   %al,%al
    29a1:	0f 84 b9 f7 ff ff    	je     2160 <ayatsuri_model_open+0x40>
    29a7:	8b bc 24 bc 00 00 00 	mov    0xbc(%rsp),%edi
    29ae:	8b 74 24 10          	mov    0x10(%rsp),%esi
    29b2:	b9 03 00 00 00       	mov    $0x3,%ecx
    29b7:	ba 06 00 00 00       	mov    $0x6,%edx
    29bc:	48 01 df             	add    %rbx,%rdi
    29bf:	e8 4c d6 ff ff       	call   10 <float_rows_valid>
    29c4:	84 c0                	test   %al,%al
    29c6:	0f 84 94 f7 ff ff    	je     2160 <ayatsuri_model_open+0x40>
    29cc:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
    29d0:	8b bc 24 c4 00 00 00 	mov    0xc4(%rsp),%edi
    29d7:	f3 0f 7e 15 00 00 00 	movq   0x0(%rip),%xmm2        # 29df <ayatsuri_model_open+0x8bf>
    29de:	00 
			29db: R_X86_64_PC32	.LC8-0x4
    29df:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 29e7 <ayatsuri_model_open+0x8c7>
    29e6:	00 
			29e3: R_X86_64_PC32	.LC18-0x4
    29e7:	48 6b c9 48          	imul   $0x48,%rcx,%rcx
    29eb:	48 89 7c 24 48       	mov    %rdi,0x48(%rsp)
    29f0:	48 8d 14 3b          	lea    (%rbx,%rdi,1),%rdx
    29f4:	48 01 f9             	add    %rdi,%rcx
    29f7:	48 01 d9             	add    %rbx,%rcx
    29fa:	48 39 ca             	cmp    %rcx,%rdx
    29fd:	0f 84 02 01 00 00    	je     2b05 <ayatsuri_model_open+0x9e5>
    2a03:	31 f6                	xor    %esi,%esi
    2a05:	f3 0f 10 04 b2       	movss  (%rdx,%rsi,4),%xmm0
    2a0a:	48 83 fe 03          	cmp    $0x3,%rsi
    2a0e:	0f 84 bd 02 00 00    	je     2cd1 <ayatsuri_model_open+0xbb1>
    2a14:	66 0f ef db          	pxor   %xmm3,%xmm3
    2a18:	f3 0f 5a d8          	cvtss2sd %xmm0,%xmm3
    2a1c:	66 0f 54 da          	andpd  %xmm2,%xmm3
    2a20:	66 0f 2e cb          	ucomisd %xmm3,%xmm1
    2a24:	0f 82 36 f7 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2a2a:	66 0f ef db          	pxor   %xmm3,%xmm3
    2a2e:	0f 2f c3             	comiss %xmm3,%xmm0
    2a31:	0f 82 29 f7 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2a37:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 2a3f <ayatsuri_model_open+0x91f>
    2a3e:	00 
			2a3b: R_X86_64_PC32	.LC17-0x4
    2a3f:	0f 2f d8             	comiss %xmm0,%xmm3
    2a42:	0f 82 18 f7 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2a48:	48 83 c6 01          	add    $0x1,%rsi
    2a4c:	48 83 fe 0b          	cmp    $0xb,%rsi
    2a50:	75 b3                	jne    2a05 <ayatsuri_model_open+0x8e5>
    2a52:	81 7a 2c ff ff ff 00 	cmpl   $0xffffff,0x2c(%rdx)
    2a59:	0f 87 01 f7 ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    2a5f:	48 8d 7a 30          	lea    0x30(%rdx),%rdi
    2a63:	e8 98 d5 ff ff       	call   0 <md>
    2a68:	66 0f 28 d8          	movapd %xmm0,%xmm3
    2a6c:	66 0f 54 da          	andpd  %xmm2,%xmm3
    2a70:	66 0f 2e cb          	ucomisd %xmm3,%xmm1
    2a74:	0f 82 e6 f6 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2a7a:	66 0f ef db          	pxor   %xmm3,%xmm3
    2a7e:	66 0f 2f c3          	comisd %xmm3,%xmm0
    2a82:	0f 82 d8 f6 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2a88:	f2 0f 10 1d 00 00 00 	movsd  0x0(%rip),%xmm3        # 2a90 <ayatsuri_model_open+0x970>
    2a8f:	00 
			2a8c: R_X86_64_PC32	.LC9-0x4
    2a90:	66 0f 2f d8          	comisd %xmm0,%xmm3
    2a94:	0f 82 c6 f6 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2a9a:	48 8d 7a 38          	lea    0x38(%rdx),%rdi
    2a9e:	e8 5d d5 ff ff       	call   0 <md>
    2aa3:	66 0f 28 e0          	movapd %xmm0,%xmm4
    2aa7:	66 0f 54 e2          	andpd  %xmm2,%xmm4
    2aab:	66 0f 2e cc          	ucomisd %xmm4,%xmm1
    2aaf:	0f 82 ab f6 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2ab5:	66 0f ef e4          	pxor   %xmm4,%xmm4
    2ab9:	66 0f 2f c4          	comisd %xmm4,%xmm0
    2abd:	0f 82 9d f6 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2ac3:	66 0f 2f d8          	comisd %xmm0,%xmm3
    2ac7:	0f 82 93 f6 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2acd:	48 8d 7a 40          	lea    0x40(%rdx),%rdi
    2ad1:	e8 2a d5 ff ff       	call   0 <md>
    2ad6:	66 0f 28 e8          	movapd %xmm0,%xmm5
    2ada:	66 0f 54 ea          	andpd  %xmm2,%xmm5
    2ade:	66 0f 2e cd          	ucomisd %xmm5,%xmm1
    2ae2:	0f 82 78 f6 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2ae8:	66 0f 2f c4          	comisd %xmm4,%xmm0
    2aec:	0f 82 6e f6 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2af2:	48 83 c2 48          	add    $0x48,%rdx
    2af6:	66 0f 2f d8          	comisd %xmm0,%xmm3
    2afa:	0f 82 60 f6 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2b00:	e9 f5 fe ff ff       	jmp    29fa <ayatsuri_model_open+0x8da>
    2b05:	8b bc 24 08 01 00 00 	mov    0x108(%rsp),%edi
    2b0c:	8b 8c 24 a4 00 00 00 	mov    0xa4(%rsp),%ecx
    2b13:	88 44 24 63          	mov    %al,0x63(%rsp)
    2b17:	45 31 d2             	xor    %r10d,%r10d
    2b1a:	8b 94 24 04 01 00 00 	mov    0x104(%rsp),%edx
    2b21:	4c 8b 5c 24 28       	mov    0x28(%rsp),%r11
    2b26:	48 01 d9             	add    %rbx,%rcx
    2b29:	89 7c 24 40          	mov    %edi,0x40(%rsp)
    2b2d:	8b bc 24 cc 00 00 00 	mov    0xcc(%rsp),%edi
    2b34:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
    2b39:	49 89 cf             	mov    %rcx,%r15
    2b3c:	48 8d 0c 13          	lea    (%rbx,%rdx,1),%rcx
    2b40:	4c 87 dd             	xchg   %r11,%rbp
    2b43:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
    2b48:	48 8d 8c 24 90 00 00 	lea    0x90(%rsp),%rcx
    2b4f:	00 
    2b50:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
    2b55:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
    2b5a:	48 89 d9             	mov    %rbx,%rcx
    2b5d:	44 89 d3             	mov    %r10d,%ebx
    2b60:	45 89 e2             	mov    %r12d,%r10d
    2b63:	49 89 cc             	mov    %rcx,%r12
    2b66:	41 0f b7 17          	movzwl (%r15),%edx
    2b6a:	89 d0                	mov    %edx,%eax
    2b6c:	0d 00 00 ff ff       	or     $0xffff0000,%eax
    2b71:	66 85 d2             	test   %dx,%dx
    2b74:	78 03                	js     2b79 <ayatsuri_model_open+0xa59>
    2b76:	0f b7 c2             	movzwl %dx,%eax
    2b79:	41 0f b7 77 04       	movzwl 0x4(%r15),%esi
    2b7e:	41 0f b7 7f 06       	movzwl 0x6(%r15),%edi
    2b83:	41 0f b7 57 08       	movzwl 0x8(%r15),%edx
    2b88:	45 0f b7 47 0a       	movzwl 0xa(%r15),%r8d
    2b8d:	f3 41 0f 10 47 0c    	movss  0xc(%r15),%xmm0
    2b93:	83 f8 ff             	cmp    $0xffffffff,%eax
    2b96:	0f 8c c4 f5 ff ff    	jl     2160 <ayatsuri_model_open+0x40>
    2b9c:	39 c3                	cmp    %eax,%ebx
    2b9e:	0f 8e bc f5 ff ff    	jle    2160 <ayatsuri_model_open+0x40>
    2ba4:	41 0f b6 47 02       	movzbl 0x2(%r15),%eax
    2ba9:	3c 03                	cmp    $0x3,%al
    2bab:	0f 87 af f5 ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    2bb1:	41 80 7f 03 01       	cmpb   $0x1,0x3(%r15)
    2bb6:	0f 87 a4 f5 ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    2bbc:	45 39 e8             	cmp    %r13d,%r8d
    2bbf:	0f 83 9b f5 ff ff    	jae    2160 <ayatsuri_model_open+0x40>
    2bc5:	f3 0f 10 35 00 00 00 	movss  0x0(%rip),%xmm6        # 2bcd <ayatsuri_model_open+0xaad>
    2bcc:	00 
			2bc9: R_X86_64_PC32	.LC1-0x4
    2bcd:	0f 28 c8             	movaps %xmm0,%xmm1
    2bd0:	0f 54 0d 00 00 00 00 	andps  0x0(%rip),%xmm1        # 2bd7 <ayatsuri_model_open+0xab7>
			2bd3: R_X86_64_PC32	.LC0-0x4
    2bd7:	0f 2e f1             	ucomiss %xmm1,%xmm6
    2bda:	0f 82 80 f5 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2be0:	f3 0f 10 4d 18       	movss  0x18(%rbp),%xmm1
    2be5:	66 0f ef f6          	pxor   %xmm6,%xmm6
    2be9:	0f 2e ce             	ucomiss %xmm6,%xmm1
    2bec:	7a 06                	jp     2bf4 <ayatsuri_model_open+0xad4>
    2bee:	0f 84 6c f5 ff ff    	je     2160 <ayatsuri_model_open+0x40>
    2bf4:	f3 0f 10 4d 1c       	movss  0x1c(%rbp),%xmm1
    2bf9:	66 0f ef f6          	pxor   %xmm6,%xmm6
    2bfd:	0f 2e ce             	ucomiss %xmm6,%xmm1
    2c00:	7a 06                	jp     2c08 <ayatsuri_model_open+0xae8>
    2c02:	0f 84 58 f5 ff ff    	je     2160 <ayatsuri_model_open+0x40>
    2c08:	f3 0f 10 4d 20       	movss  0x20(%rbp),%xmm1
    2c0d:	66 0f ef f6          	pxor   %xmm6,%xmm6
    2c11:	0f 2e ce             	ucomiss %xmm6,%xmm1
    2c14:	7a 06                	jp     2c1c <ayatsuri_model_open+0xafc>
    2c16:	0f 84 44 f5 ff ff    	je     2160 <ayatsuri_model_open+0x40>
    2c1c:	84 c0                	test   %al,%al
    2c1e:	0f 85 3e 01 00 00    	jne    2d62 <ayatsuri_model_open+0xc42>
    2c24:	66 0f ef ff          	pxor   %xmm7,%xmm7
    2c28:	b9 01 00 00 00       	mov    $0x1,%ecx
    2c2d:	0f 2e c7             	ucomiss %xmm7,%xmm0
    2c30:	41 0f 9a c1          	setp   %r9b
    2c34:	44 0f 45 c9          	cmovne %ecx,%r9d
    2c38:	66 85 ff             	test   %di,%di
    2c3b:	40 0f 95 c7          	setne  %dil
    2c3f:	44 08 cf             	or     %r9b,%dil
    2c42:	0f 85 18 f5 ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    2c48:	21 f2                	and    %esi,%edx
    2c4a:	66 83 c2 01          	add    $0x1,%dx
    2c4e:	0f 85 0c f5 ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    2c54:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    2c59:	42 8d 14 c5 00 00 00 	lea    0x0(,%r8,8),%edx
    2c60:	00 
    2c61:	48 01 ca             	add    %rcx,%rdx
    2c64:	4c 01 e2             	add    %r12,%rdx
    2c67:	44 0f b7 42 02       	movzwl 0x2(%rdx),%r8d
    2c6c:	8b 7a 04             	mov    0x4(%rdx),%edi
    2c6f:	0f b7 12             	movzwl (%rdx),%edx
    2c72:	39 da                	cmp    %ebx,%edx
    2c74:	0f 85 e6 f4 ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    2c7a:	41 8d 50 ff          	lea    -0x1(%r8),%edx
    2c7e:	66 83 fa 7e          	cmp    $0x7e,%dx
    2c82:	40 0f 97 c6          	seta   %sil
    2c86:	41 39 fe             	cmp    %edi,%r14d
    2c89:	0f 92 c2             	setb   %dl
    2c8c:	40 08 d6             	or     %dl,%sil
    2c8f:	40 88 74 24 28       	mov    %sil,0x28(%rsp)
    2c94:	0f 85 c6 f4 ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    2c9a:	44 89 f6             	mov    %r14d,%esi
    2c9d:	41 0f b7 d0          	movzwl %r8w,%edx
    2ca1:	29 fe                	sub    %edi,%esi
    2ca3:	39 d6                	cmp    %edx,%esi
    2ca5:	0f 82 b5 f4 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2cab:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
    2cb0:	31 f6                	xor    %esi,%esi
    2cb2:	48 01 cf             	add    %rcx,%rdi
    2cb5:	4c 01 e7             	add    %r12,%rdi
    2cb8:	39 d6                	cmp    %edx,%esi
    2cba:	73 58                	jae    2d14 <ayatsuri_model_open+0xbf4>
    2cbc:	0f b6 0c 37          	movzbl (%rdi,%rsi,1),%ecx
    2cc0:	48 83 c6 01          	add    $0x1,%rsi
    2cc4:	83 e9 20             	sub    $0x20,%ecx
    2cc7:	80 f9 5e             	cmp    $0x5e,%cl
    2cca:	76 ec                	jbe    2cb8 <ayatsuri_model_open+0xb98>
    2ccc:	e9 8f f4 ff ff       	jmp    2160 <ayatsuri_model_open+0x40>
    2cd1:	f3 0f 10 25 00 00 00 	movss  0x0(%rip),%xmm4        # 2cd9 <ayatsuri_model_open+0xbb9>
    2cd8:	00 
			2cd5: R_X86_64_PC32	.LC1-0x4
    2cd9:	0f 28 d8             	movaps %xmm0,%xmm3
    2cdc:	0f 54 1d 00 00 00 00 	andps  0x0(%rip),%xmm3        # 2ce3 <ayatsuri_model_open+0xbc3>
			2cdf: R_X86_64_PC32	.LC0-0x4
    2ce3:	0f 2e e3             	ucomiss %xmm3,%xmm4
    2ce6:	0f 82 74 f4 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2cec:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 2cf4 <ayatsuri_model_open+0xbd4>
    2cf3:	00 
			2cf0: R_X86_64_PC32	.LC17-0x4
    2cf4:	0f 2f d8             	comiss %xmm0,%xmm3
    2cf7:	0f 87 63 f4 ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    2cfd:	0f 2f 05 00 00 00 00 	comiss 0x0(%rip),%xmm0        # 2d04 <ayatsuri_model_open+0xbe4>
			2d00: R_X86_64_PC32	.LC30-0x4
    2d04:	0f 87 56 f4 ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    2d0a:	be 04 00 00 00       	mov    $0x4,%esi
    2d0f:	e9 f1 fc ff ff       	jmp    2a05 <ayatsuri_model_open+0x8e5>
    2d14:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
    2d19:	44 89 6c 24 64       	mov    %r13d,0x64(%rsp)
    2d1e:	41 0f b7 d0          	movzwl %r8w,%edx
    2d22:	41 89 c5             	mov    %eax,%r13d
    2d25:	89 9c 24 80 00 00 00 	mov    %ebx,0x80(%rsp)
    2d2c:	48 89 6c 24 68       	mov    %rbp,0x68(%rsp)
    2d31:	4c 89 cb             	mov    %r9,%rbx
    2d34:	44 89 c5             	mov    %r8d,%ebp
    2d37:	49 39 df             	cmp    %rbx,%r15
    2d3a:	0f 84 cc 01 00 00    	je     2f0c <ayatsuri_model_open+0xdec>
    2d40:	0f b7 43 0a          	movzwl 0xa(%rbx),%eax
    2d44:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    2d49:	c1 e0 03             	shl    $0x3,%eax
    2d4c:	48 01 c8             	add    %rcx,%rax
    2d4f:	4c 01 e0             	add    %r12,%rax
    2d52:	66 39 68 02          	cmp    %bp,0x2(%rax)
    2d56:	0f 84 5c 01 00 00    	je     2eb8 <ayatsuri_model_open+0xd98>
    2d5c:	48 83 c3 10          	add    $0x10,%rbx
    2d60:	eb d5                	jmp    2d37 <ayatsuri_model_open+0xc17>
    2d62:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
    2d66:	39 ca                	cmp    %ecx,%edx
    2d68:	0f 83 f2 f3 ff ff    	jae    2160 <ayatsuri_model_open+0x40>
    2d6e:	3c 03                	cmp    $0x3,%al
    2d70:	74 6c                	je     2dde <ayatsuri_model_open+0xcbe>
    2d72:	83 7c 24 40 00       	cmpl   $0x0,0x40(%rsp)
    2d77:	74 12                	je     2d8b <ayatsuri_model_open+0xc6b>
    2d79:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
    2d7e:	c1 e2 02             	shl    $0x2,%edx
    2d81:	80 3c 11 00          	cmpb   $0x0,(%rcx,%rdx,1)
    2d85:	0f 85 d5 f3 ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    2d8b:	3c 01                	cmp    $0x1,%al
    2d8d:	0f 84 f7 00 00 00    	je     2e8a <ayatsuri_model_open+0xd6a>
    2d93:	8d 57 ff             	lea    -0x1(%rdi),%edx
    2d96:	66 83 fa 07          	cmp    $0x7,%dx
    2d9a:	0f 87 c0 f3 ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    2da0:	8b 4c 24 10          	mov    0x10(%rsp),%ecx
    2da4:	39 f1                	cmp    %esi,%ecx
    2da6:	0f 82 b4 f3 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2dac:	29 f1                	sub    %esi,%ecx
    2dae:	39 f9                	cmp    %edi,%ecx
    2db0:	0f 82 aa f3 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    2db6:	66 0f ef ff          	pxor   %xmm7,%xmm7
    2dba:	0f 2f f8             	comiss %xmm0,%xmm7
    2dbd:	0f 87 9d f3 ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    2dc3:	0f 2f 05 00 00 00 00 	comiss 0x0(%rip),%xmm0        # 2dca <ayatsuri_model_open+0xcaa>
			2dc6: R_X86_64_PC32	.LC30-0x4
    2dca:	0f 87 90 f3 ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    2dd0:	66 83 84 24 9e 00 00 	addw   $0x1,0x9e(%rsp)
    2dd7:	00 01 
    2dd9:	e9 76 fe ff ff       	jmp    2c54 <ayatsuri_model_open+0xb34>
    2dde:	83 7c 24 38 00       	cmpl   $0x0,0x38(%rsp)
    2de3:	0f 84 77 f3 ff ff    	je     2160 <ayatsuri_model_open+0x40>
    2de9:	8b 4c 24 3c          	mov    0x3c(%rsp),%ecx
    2ded:	39 ce                	cmp    %ecx,%esi
    2def:	40 0f 93 c6          	setae  %sil
    2df3:	66 85 ff             	test   %di,%di
    2df6:	40 0f 95 c7          	setne  %dil
    2dfa:	40 08 fe             	or     %dil,%sil
    2dfd:	0f 85 5d f3 ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    2e03:	66 0f ef f6          	pxor   %xmm6,%xmm6
    2e07:	b9 01 00 00 00       	mov    $0x1,%ecx
    2e0c:	0f 2e c6             	ucomiss %xmm6,%xmm0
    2e0f:	40 0f 9a c6          	setp   %sil
    2e13:	0f 45 f1             	cmovne %ecx,%esi
    2e16:	40 84 f6             	test   %sil,%sil
    2e19:	0f 85 41 f3 ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    2e1f:	6b d2 48             	imul   $0x48,%edx,%edx
    2e22:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
    2e27:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
    2e2b:	4c 01 e6             	add    %r12,%rsi
    2e2e:	48 8d 7e 30          	lea    0x30(%rsi),%rdi
    2e32:	e8 c9 d1 ff ff       	call   0 <md>
    2e37:	66 0f 2e 05 00 00 00 	ucomisd 0x0(%rip),%xmm0        # 2e3f <ayatsuri_model_open+0xd1f>
    2e3e:	00 
			2e3b: R_X86_64_PC32	.LC9-0x4
    2e3f:	0f 8a 1b f3 ff ff    	jp     2160 <ayatsuri_model_open+0x40>
    2e45:	0f 85 15 f3 ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    2e4b:	48 8d 7e 38          	lea    0x38(%rsi),%rdi
    2e4f:	e8 ac d1 ff ff       	call   0 <md>
    2e54:	66 0f 2e 05 00 00 00 	ucomisd 0x0(%rip),%xmm0        # 2e5c <ayatsuri_model_open+0xd3c>
    2e5b:	00 
			2e58: R_X86_64_PC32	.LC9-0x4
    2e5c:	0f 8a fe f2 ff ff    	jp     2160 <ayatsuri_model_open+0x40>
    2e62:	0f 85 f8 f2 ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    2e68:	48 8d 7e 40          	lea    0x40(%rsi),%rdi
    2e6c:	66 0f ef ff          	pxor   %xmm7,%xmm7
    2e70:	e8 8b d1 ff ff       	call   0 <md>
    2e75:	66 0f 2e c7          	ucomisd %xmm7,%xmm0
    2e79:	0f 8a e1 f2 ff ff    	jp     2160 <ayatsuri_model_open+0x40>
    2e7f:	0f 84 4b ff ff ff    	je     2dd0 <ayatsuri_model_open+0xcb0>
    2e85:	e9 d6 f2 ff ff       	jmp    2160 <ayatsuri_model_open+0x40>
    2e8a:	66 0f ef f6          	pxor   %xmm6,%xmm6
    2e8e:	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
    2e92:	0f 2e c6             	ucomiss %xmm6,%xmm0
    2e95:	0f 9a c2             	setp   %dl
    2e98:	0f 45 d0             	cmovne %eax,%edx
    2e9b:	39 ce                	cmp    %ecx,%esi
    2e9d:	40 0f 93 c6          	setae  %sil
    2ea1:	40 08 d6             	or     %dl,%sil
    2ea4:	0f 85 b6 f2 ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    2eaa:	66 85 ff             	test   %di,%di
    2ead:	0f 84 1d ff ff ff    	je     2dd0 <ayatsuri_model_open+0xcb0>
    2eb3:	e9 a8 f2 ff ff       	jmp    2160 <ayatsuri_model_open+0x40>
    2eb8:	8b 70 04             	mov    0x4(%rax),%esi
    2ebb:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    2ec0:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
    2ec5:	4c 89 9c 24 88 00 00 	mov    %r11,0x88(%rsp)
    2ecc:	00 
    2ecd:	48 01 c6             	add    %rax,%rsi
    2ed0:	44 89 94 24 84 00 00 	mov    %r10d,0x84(%rsp)
    2ed7:	00 
    2ed8:	4c 01 e6             	add    %r12,%rsi
    2edb:	48 89 7c 24 70       	mov    %rdi,0x70(%rsp)
    2ee0:	e8 00 00 00 00       	call   2ee5 <ayatsuri_model_open+0xdc5>
			2ee1: R_X86_64_PLT32	memcmp-0x4
    2ee5:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
    2eea:	48 8b 54 24 78       	mov    0x78(%rsp),%rdx
    2eef:	85 c0                	test   %eax,%eax
    2ef1:	44 8b 94 24 84 00 00 	mov    0x84(%rsp),%r10d
    2ef8:	00 
    2ef9:	4c 8b 9c 24 88 00 00 	mov    0x88(%rsp),%r11
    2f00:	00 
    2f01:	0f 85 55 fe ff ff    	jne    2d5c <ayatsuri_model_open+0xc3c>
    2f07:	e9 54 f2 ff ff       	jmp    2160 <ayatsuri_model_open+0x40>
    2f0c:	44 89 e8             	mov    %r13d,%eax
    2f0f:	8b 9c 24 80 00 00 00 	mov    0x80(%rsp),%ebx
    2f16:	44 8b 6c 24 64       	mov    0x64(%rsp),%r13d
    2f1b:	48 8b 6c 24 68       	mov    0x68(%rsp),%rbp
    2f20:	3c 03                	cmp    $0x3,%al
    2f22:	0f 84 17 02 00 00    	je     313f <ayatsuri_model_open+0x101f>
    2f28:	4c 89 ff             	mov    %r15,%rdi
    2f2b:	e8 a0 d3 ff ff       	call   2d0 <slot_bytes>
    2f30:	03 84 24 a0 00 00 00 	add    0xa0(%rsp),%eax
    2f37:	83 c3 01             	add    $0x1,%ebx
    2f3a:	49 83 c7 10          	add    $0x10,%r15
    2f3e:	48 83 c5 24          	add    $0x24,%rbp
    2f42:	89 84 24 a0 00 00 00 	mov    %eax,0xa0(%rsp)
    2f49:	89 c2                	mov    %eax,%edx
    2f4b:	44 39 eb             	cmp    %r13d,%ebx
    2f4e:	0f 82 12 fc ff ff    	jb     2b66 <ayatsuri_model_open+0xa46>
    2f54:	44 8b 8c 24 dc 00 00 	mov    0xdc(%rsp),%r9d
    2f5b:	00 
    2f5c:	4c 89 e3             	mov    %r12,%rbx
    2f5f:	4c 89 dd             	mov    %r11,%rbp
    2f62:	31 f6                	xor    %esi,%esi
    2f64:	0f b6 44 24 63       	movzbl 0x63(%rsp),%eax
    2f69:	44 8b b4 24 e0 00 00 	mov    0xe0(%rsp),%r14d
    2f70:	00 
    2f71:	45 89 d4             	mov    %r10d,%r12d
    2f74:	f3 44 0f 10 0d 00 00 	movss  0x0(%rip),%xmm9        # 2f7d <ayatsuri_model_open+0xe5d>
    2f7b:	00 00 
			2f79: R_X86_64_PC32	.LC15-0x4
    2f7d:	f3 0f 7e 1d 00 00 00 	movq   0x0(%rip),%xmm3        # 2f85 <ayatsuri_model_open+0xe65>
    2f84:	00 
			2f81: R_X86_64_PC32	.LC8-0x4
    2f85:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 2f8d <ayatsuri_model_open+0xe6d>
    2f8c:	00 
			2f89: R_X86_64_PC32	.LC18-0x4
    2f8d:	4e 8d 1c 0b          	lea    (%rbx,%r9,1),%r11
    2f91:	f3 44 0f 10 05 00 00 	movss  0x0(%rip),%xmm8        # 2f9a <ayatsuri_model_open+0xe7a>
    2f98:	00 00 
			2f96: R_X86_64_PC32	.LC31-0x4
    2f9a:	41 39 f6             	cmp    %esi,%r14d
    2f9d:	0f 84 b0 01 00 00    	je     3153 <ayatsuri_model_open+0x1033>
    2fa3:	66 0f ef c0          	pxor   %xmm0,%xmm0
    2fa7:	66 0f ef c9          	pxor   %xmm1,%xmm1
    2fab:	66 0f ef d2          	pxor   %xmm2,%xmm2
    2faf:	89 f1                	mov    %esi,%ecx
    2fb1:	c1 e1 05             	shl    $0x5,%ecx
    2fb4:	4c 01 c9             	add    %r9,%rcx
    2fb7:	48 01 d9             	add    %rbx,%rcx
    2fba:	0f b7 39             	movzwl (%rcx),%edi
    2fbd:	f3 0f 10 79 10       	movss  0x10(%rcx),%xmm7
    2fc2:	f3 0f 5a 41 04       	cvtss2sd 0x4(%rcx),%xmm0
    2fc7:	f3 0f 5a 49 08       	cvtss2sd 0x8(%rcx),%xmm1
    2fcc:	f3 0f 10 61 14       	movss  0x14(%rcx),%xmm4
    2fd1:	f3 0f 5a 51 0c       	cvtss2sd 0xc(%rcx),%xmm2
    2fd6:	41 89 fa             	mov    %edi,%r10d
    2fd9:	44 39 ef             	cmp    %r13d,%edi
    2fdc:	0f 83 7e f1 ff ff    	jae    2160 <ayatsuri_model_open+0x40>
    2fe2:	4c 8b 7c 24 30       	mov    0x30(%rsp),%r15
    2fe7:	44 0f b6 41 02       	movzbl 0x2(%rcx),%r8d
    2fec:	c1 e7 04             	shl    $0x4,%edi
    2fef:	42 0f b6 7c 3f 02    	movzbl 0x2(%rdi,%r15,1),%edi
    2ff5:	41 80 f8 05          	cmp    $0x5,%r8b
    2ff9:	0f 84 29 01 00 00    	je     3128 <ayatsuri_model_open+0x1008>
    2fff:	40 80 ef 01          	sub    $0x1,%dil
    3003:	0f 85 57 f1 ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    3009:	41 80 f8 04          	cmp    $0x4,%r8b
    300d:	0f 85 4d f1 ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    3013:	f3 0f 10 2d 00 00 00 	movss  0x0(%rip),%xmm5        # 301b <ayatsuri_model_open+0xefb>
    301a:	00 
			3017: R_X86_64_PC32	.LC28-0x4
    301b:	80 79 03 00          	cmpb   $0x0,0x3(%rcx)
    301f:	0f 85 3b f1 ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    3025:	8b 79 1c             	mov    0x1c(%rcx),%edi
    3028:	85 ff                	test   %edi,%edi
    302a:	0f 85 30 f1 ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    3030:	66 44 0f 28 d0       	movapd %xmm0,%xmm10
    3035:	66 44 0f 54 d3       	andpd  %xmm3,%xmm10
    303a:	66 41 0f 2e f2       	ucomisd %xmm10,%xmm6
    303f:	0f 82 1b f1 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    3045:	66 44 0f 28 d1       	movapd %xmm1,%xmm10
    304a:	66 44 0f 54 d3       	andpd  %xmm3,%xmm10
    304f:	66 41 0f 2e f2       	ucomisd %xmm10,%xmm6
    3054:	0f 82 06 f1 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    305a:	66 44 0f 28 d2       	movapd %xmm2,%xmm10
    305f:	66 44 0f 54 d3       	andpd  %xmm3,%xmm10
    3064:	66 41 0f 2e f2       	ucomisd %xmm10,%xmm6
    3069:	0f 82 f1 f0 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    306f:	f2 0f 59 c0          	mulsd  %xmm0,%xmm0
    3073:	f2 0f 59 c9          	mulsd  %xmm1,%xmm1
    3077:	f2 0f 59 d2          	mulsd  %xmm2,%xmm2
    307b:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    307f:	f2 0f 58 c2          	addsd  %xmm2,%xmm0
    3083:	f2 0f 5c 05 00 00 00 	subsd  0x0(%rip),%xmm0        # 308b <ayatsuri_model_open+0xf6b>
    308a:	00 
			3087: R_X86_64_PC32	.LC9-0x4
    308b:	66 0f 54 c3          	andpd  %xmm3,%xmm0
    308f:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 3097 <ayatsuri_model_open+0xf77>
    3096:	00 
			3093: R_X86_64_PC32	.LC29-0x4
    3097:	0f 87 c3 f0 ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    309d:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 30a5 <ayatsuri_model_open+0xf85>
    30a4:	00 
			30a1: R_X86_64_PC32	.LC1-0x4
    30a5:	0f 28 c7             	movaps %xmm7,%xmm0
    30a8:	0f 54 05 00 00 00 00 	andps  0x0(%rip),%xmm0        # 30af <ayatsuri_model_open+0xf8f>
			30ab: R_X86_64_PC32	.LC0-0x4
    30af:	0f 2e d0             	ucomiss %xmm0,%xmm2
    30b2:	0f 82 a8 f0 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    30b8:	0f 28 c5             	movaps %xmm5,%xmm0
    30bb:	41 0f 57 c1          	xorps  %xmm9,%xmm0
    30bf:	0f 2f c7             	comiss %xmm7,%xmm0
    30c2:	0f 87 98 f0 ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    30c8:	0f 2f fd             	comiss %xmm5,%xmm7
    30cb:	0f 87 8f f0 ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    30d1:	0f 28 c4             	movaps %xmm4,%xmm0
    30d4:	0f 54 05 00 00 00 00 	andps  0x0(%rip),%xmm0        # 30db <ayatsuri_model_open+0xfbb>
			30d7: R_X86_64_PC32	.LC0-0x4
    30db:	0f 2e d0             	ucomiss %xmm0,%xmm2
    30de:	0f 82 7c f0 ff ff    	jb     2160 <ayatsuri_model_open+0x40>
    30e4:	66 0f ef c0          	pxor   %xmm0,%xmm0
    30e8:	0f 2e e0             	ucomiss %xmm0,%xmm4
    30eb:	7a 02                	jp     30ef <ayatsuri_model_open+0xfcf>
    30ed:	74 13                	je     3102 <ayatsuri_model_open+0xfe2>
    30ef:	44 0f 2f c4          	comiss %xmm4,%xmm8
    30f3:	0f 87 67 f0 ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    30f9:	0f 2f e5             	comiss %xmm5,%xmm4
    30fc:	0f 87 5e f0 ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    3102:	81 79 18 ff ff ff 00 	cmpl   $0xffffff,0x18(%rcx)
    3109:	0f 87 51 f0 ff ff    	ja     2160 <ayatsuri_model_open+0x40>
    310f:	39 fe                	cmp    %edi,%esi
    3111:	74 65                	je     3178 <ayatsuri_model_open+0x1058>
    3113:	89 f9                	mov    %edi,%ecx
    3115:	c1 e1 05             	shl    $0x5,%ecx
    3118:	66 45 39 14 0b       	cmp    %r10w,(%r11,%rcx,1)
    311d:	0f 84 3d f0 ff ff    	je     2160 <ayatsuri_model_open+0x40>
    3123:	83 c7 01             	add    $0x1,%edi
    3126:	eb e7                	jmp    310f <ayatsuri_model_open+0xfef>
    3128:	40 80 ff 02          	cmp    $0x2,%dil
    312c:	0f 85 2e f0 ff ff    	jne    2160 <ayatsuri_model_open+0x40>
    3132:	f3 0f 10 2d 00 00 00 	movss  0x0(%rip),%xmm5        # 313a <ayatsuri_model_open+0x101a>
    3139:	00 
			3136: R_X86_64_PC32	.LC3-0x4
    313a:	e9 dc fe ff ff       	jmp    301b <ayatsuri_model_open+0xefb>
    313f:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
    3144:	4c 89 fa             	mov    %r15,%rdx
    3147:	89 de                	mov    %ebx,%esi
    3149:	e8 12 d4 ff ff       	call   560 <node_slot_bytes>
    314e:	e9 dd fd ff ff       	jmp    2f30 <ayatsuri_model_open+0xe10>
    3153:	80 7c 24 28 00       	cmpb   $0x0,0x28(%rsp)
    3158:	74 07                	je     3161 <ayatsuri_model_open+0x1041>
    315a:	89 94 24 a0 00 00 00 	mov    %edx,0xa0(%rsp)
    3161:	48 8d b4 24 90 00 00 	lea    0x90(%rsp),%rsi
    3168:	00 
    3169:	b9 20 00 00 00       	mov    $0x20,%ecx
    316e:	48 89 ef             	mov    %rbp,%rdi
    3171:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
    3173:	e9 ee ef ff ff       	jmp    2166 <ayatsuri_model_open+0x46>
    3178:	41 80 f8 05          	cmp    $0x5,%r8b
    317c:	75 07                	jne    3185 <ayatsuri_model_open+0x1065>
    317e:	88 44 24 28          	mov    %al,0x28(%rsp)
    3182:	83 c2 18             	add    $0x18,%edx
    3185:	83 c6 01             	add    $0x1,%esi
    3188:	e9 0d fe ff ff       	jmp    2f9a <ayatsuri_model_open+0xe7a>
    318d:	0f 1f 00             	nopl   (%rax)

0000000000003190 <ayatsuri_model_find_node>:
    3190:	48 85 ff             	test   %rdi,%rdi
    3193:	0f 84 1f 01 00 00    	je     32b8 <ayatsuri_model_find_node+0x128>
    3199:	41 57                	push   %r15
    319b:	41 56                	push   %r14
    319d:	41 55                	push   %r13
    319f:	41 54                	push   %r12
    31a1:	55                   	push   %rbp
    31a2:	48 89 fd             	mov    %rdi,%rbp
    31a5:	53                   	push   %rbx
    31a6:	48 83 ec 18          	sub    $0x18,%rsp
    31aa:	4c 8b 3f             	mov    (%rdi),%r15
    31ad:	4d 85 ff             	test   %r15,%r15
    31b0:	0f 84 d2 00 00 00    	je     3288 <ayatsuri_model_find_node+0xf8>
    31b6:	49 89 f6             	mov    %rsi,%r14
    31b9:	48 85 f6             	test   %rsi,%rsi
    31bc:	0f 84 c6 00 00 00    	je     3288 <ayatsuri_model_find_node+0xf8>
    31c2:	49 89 cd             	mov    %rcx,%r13
    31c5:	48 85 c9             	test   %rcx,%rcx
    31c8:	0f 84 ba 00 00 00    	je     3288 <ayatsuri_model_find_node+0xf8>
    31ce:	49 89 d4             	mov    %rdx,%r12
    31d1:	48 8d 52 ff          	lea    -0x1(%rdx),%rdx
    31d5:	b8 01 00 00 00       	mov    $0x1,%eax
    31da:	48 83 fa 7e          	cmp    $0x7e,%rdx
    31de:	0f 87 a9 00 00 00    	ja     328d <ayatsuri_model_find_node+0xfd>
    31e4:	48 39 cf             	cmp    %rcx,%rdi
    31e7:	0f 83 b3 00 00 00    	jae    32a0 <ayatsuri_model_find_node+0x110>
    31ed:	48 89 ca             	mov    %rcx,%rdx
    31f0:	48 29 fa             	sub    %rdi,%rdx
    31f3:	48 83 fa 7f          	cmp    $0x7f,%rdx
    31f7:	0f 86 90 00 00 00    	jbe    328d <ayatsuri_model_find_node+0xfd>
    31fd:	8b 55 08             	mov    0x8(%rbp),%edx
    3200:	48 85 d2             	test   %rdx,%rdx
    3203:	74 1b                	je     3220 <ayatsuri_model_find_node+0x90>
    3205:	4d 39 ef             	cmp    %r13,%r15
    3208:	0f 82 c2 00 00 00    	jb     32d0 <ayatsuri_model_find_node+0x140>
    320e:	4c 89 fa             	mov    %r15,%rdx
    3211:	b8 01 00 00 00       	mov    $0x1,%eax
    3216:	4c 29 ea             	sub    %r13,%rdx
    3219:	48 83 fa 01          	cmp    $0x1,%rdx
    321d:	76 6e                	jbe    328d <ayatsuri_model_find_node+0xfd>
    321f:	90                   	nop
    3220:	0f b7 45 0c          	movzwl 0xc(%rbp),%eax
    3224:	85 c0                	test   %eax,%eax
    3226:	0f 84 94 00 00 00    	je     32c0 <ayatsuri_model_find_node+0x130>
    322c:	8b 5d 3c             	mov    0x3c(%rbp),%ebx
    322f:	83 e8 01             	sub    $0x1,%eax
    3232:	4c 01 fb             	add    %r15,%rbx
    3235:	48 8d 4c c3 08       	lea    0x8(%rbx,%rax,8),%rcx
    323a:	eb 0d                	jmp    3249 <ayatsuri_model_find_node+0xb9>
    323c:	0f 1f 40 00          	nopl   0x0(%rax)
    3240:	48 83 c3 08          	add    $0x8,%rbx
    3244:	48 39 d9             	cmp    %rbx,%rcx
    3247:	74 77                	je     32c0 <ayatsuri_model_find_node+0x130>
    3249:	0f b7 43 02          	movzwl 0x2(%rbx),%eax
    324d:	4c 39 e0             	cmp    %r12,%rax
    3250:	75 ee                	jne    3240 <ayatsuri_model_find_node+0xb0>
    3252:	8b 43 04             	mov    0x4(%rbx),%eax
    3255:	8b 7d 44             	mov    0x44(%rbp),%edi
    3258:	4c 89 e2             	mov    %r12,%rdx
    325b:	4c 89 f6             	mov    %r14,%rsi
    325e:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    3263:	48 01 c7             	add    %rax,%rdi
    3266:	4c 01 ff             	add    %r15,%rdi
    3269:	e8 00 00 00 00       	call   326e <ayatsuri_model_find_node+0xde>
			326a: R_X86_64_PLT32	memcmp-0x4
    326e:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
    3273:	85 c0                	test   %eax,%eax
    3275:	75 c9                	jne    3240 <ayatsuri_model_find_node+0xb0>
    3277:	0f b7 03             	movzwl (%rbx),%eax
    327a:	66 41 89 45 00       	mov    %ax,0x0(%r13)
    327f:	31 c0                	xor    %eax,%eax
    3281:	eb 0a                	jmp    328d <ayatsuri_model_find_node+0xfd>
    3283:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    3288:	b8 01 00 00 00       	mov    $0x1,%eax
    328d:	48 83 c4 18          	add    $0x18,%rsp
    3291:	5b                   	pop    %rbx
    3292:	5d                   	pop    %rbp
    3293:	41 5c                	pop    %r12
    3295:	41 5d                	pop    %r13
    3297:	41 5e                	pop    %r14
    3299:	41 5f                	pop    %r15
    329b:	c3                   	ret
    329c:	0f 1f 40 00          	nopl   0x0(%rax)
    32a0:	48 89 fa             	mov    %rdi,%rdx
    32a3:	48 29 ca             	sub    %rcx,%rdx
    32a6:	48 83 fa 01          	cmp    $0x1,%rdx
    32aa:	76 e1                	jbe    328d <ayatsuri_model_find_node+0xfd>
    32ac:	e9 4c ff ff ff       	jmp    31fd <ayatsuri_model_find_node+0x6d>
    32b1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    32b8:	b8 01 00 00 00       	mov    $0x1,%eax
    32bd:	c3                   	ret
    32be:	66 90                	xchg   %ax,%ax
    32c0:	b8 05 00 00 00       	mov    $0x5,%eax
    32c5:	eb c6                	jmp    328d <ayatsuri_model_find_node+0xfd>
    32c7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    32ce:	00 00 
    32d0:	4c 89 e9             	mov    %r13,%rcx
    32d3:	b8 01 00 00 00       	mov    $0x1,%eax
    32d8:	4c 29 f9             	sub    %r15,%rcx
    32db:	48 39 d1             	cmp    %rdx,%rcx
    32de:	72 ad                	jb     328d <ayatsuri_model_find_node+0xfd>
    32e0:	e9 3b ff ff ff       	jmp    3220 <ayatsuri_model_find_node+0x90>
    32e5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    32ec:	00 00 00 00 

00000000000032f0 <ayatsuri_model_instance_bytes>:
    32f0:	31 c0                	xor    %eax,%eax
    32f2:	48 85 ff             	test   %rdi,%rdi
    32f5:	74 15                	je     330c <ayatsuri_model_instance_bytes+0x1c>
    32f7:	48 83 3f 00          	cmpq   $0x0,(%rdi)
    32fb:	74 0f                	je     330c <ayatsuri_model_instance_bytes+0x1c>
    32fd:	0f b7 47 0c          	movzwl 0xc(%rdi),%eax
    3301:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
    3305:	8b 47 10             	mov    0x10(%rdi),%eax
    3308:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
    330c:	c3                   	ret
    330d:	0f 1f 00             	nopl   (%rax)

0000000000003310 <ayatsuri_model_instance_init>:
    3310:	b8 01 00 00 00       	mov    $0x1,%eax
    3315:	48 85 ff             	test   %rdi,%rdi
    3318:	0f 84 a2 00 00 00    	je     33c0 <ayatsuri_model_instance_init+0xb0>
    331e:	41 57                	push   %r15
    3320:	41 56                	push   %r14
    3322:	41 55                	push   %r13
    3324:	41 54                	push   %r12
    3326:	55                   	push   %rbp
    3327:	48 89 cd             	mov    %rcx,%rbp
    332a:	53                   	push   %rbx
    332b:	48 89 fb             	mov    %rdi,%rbx
    332e:	48 81 ec c8 00 00 00 	sub    $0xc8,%rsp
    3335:	48 8b 0f             	mov    (%rdi),%rcx
    3338:	48 85 c9             	test   %rcx,%rcx
    333b:	74 5e                	je     339b <ayatsuri_model_instance_init+0x8b>
    333d:	0f b7 47 0c          	movzwl 0xc(%rdi),%eax
    3341:	49 89 f2             	mov    %rsi,%r10
    3344:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
    3348:	8b 47 10             	mov    0x10(%rdi),%eax
    334b:	4c 8d 24 f0          	lea    (%rax,%rsi,8),%r12
    334f:	4d 85 e4             	test   %r12,%r12
    3352:	74 5c                	je     33b0 <ayatsuri_model_instance_init+0xa0>
    3354:	4d 85 d2             	test   %r10,%r10
    3357:	74 57                	je     33b0 <ayatsuri_model_instance_init+0xa0>
    3359:	48 85 ed             	test   %rbp,%rbp
    335c:	0f 94 c0             	sete   %al
    335f:	4d 85 c9             	test   %r9,%r9
    3362:	40 0f 94 c6          	sete   %sil
    3366:	40 08 f0             	or     %sil,%al
    3369:	75 45                	jne    33b0 <ayatsuri_model_instance_init+0xa0>
    336b:	45 85 c0             	test   %r8d,%r8d
    336e:	74 40                	je     33b0 <ayatsuri_model_instance_init+0xa0>
    3370:	4d 89 d5             	mov    %r10,%r13
    3373:	41 f6 c2 07          	test   $0x7,%r10b
    3377:	75 37                	jne    33b0 <ayatsuri_model_instance_init+0xa0>
    3379:	4c 39 e2             	cmp    %r12,%rdx
    337c:	72 32                	jb     33b0 <ayatsuri_model_instance_init+0xa0>
    337e:	8b 57 08             	mov    0x8(%rdi),%edx
    3381:	48 85 d2             	test   %rdx,%rdx
    3384:	74 5a                	je     33e0 <ayatsuri_model_instance_init+0xd0>
    3386:	4c 39 d1             	cmp    %r10,%rcx
    3389:	72 3d                	jb     33c8 <ayatsuri_model_instance_init+0xb8>
    338b:	48 89 ce             	mov    %rcx,%rsi
    338e:	b8 01 00 00 00       	mov    $0x1,%eax
    3393:	4c 29 d6             	sub    %r10,%rsi
    3396:	4c 39 e6             	cmp    %r12,%rsi
    3399:	73 45                	jae    33e0 <ayatsuri_model_instance_init+0xd0>
    339b:	48 81 c4 c8 00 00 00 	add    $0xc8,%rsp
    33a2:	5b                   	pop    %rbx
    33a3:	5d                   	pop    %rbp
    33a4:	41 5c                	pop    %r12
    33a6:	41 5d                	pop    %r13
    33a8:	41 5e                	pop    %r14
    33aa:	41 5f                	pop    %r15
    33ac:	c3                   	ret
    33ad:	0f 1f 00             	nopl   (%rax)
    33b0:	b8 01 00 00 00       	mov    $0x1,%eax
    33b5:	eb e4                	jmp    339b <ayatsuri_model_instance_init+0x8b>
    33b7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    33be:	00 00 
    33c0:	c3                   	ret
    33c1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    33c8:	4c 89 d6             	mov    %r10,%rsi
    33cb:	b8 01 00 00 00       	mov    $0x1,%eax
    33d0:	48 29 ce             	sub    %rcx,%rsi
    33d3:	48 39 d6             	cmp    %rdx,%rsi
    33d6:	72 c3                	jb     339b <ayatsuri_model_instance_init+0x8b>
    33d8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    33df:	00 
    33e0:	4c 39 d3             	cmp    %r10,%rbx
    33e3:	0f 83 27 02 00 00    	jae    3610 <ayatsuri_model_instance_init+0x300>
    33e9:	4c 89 d6             	mov    %r10,%rsi
    33ec:	b8 01 00 00 00       	mov    $0x1,%eax
    33f1:	48 29 de             	sub    %rbx,%rsi
    33f4:	48 83 fe 7f          	cmp    $0x7f,%rsi
    33f8:	76 a1                	jbe    339b <ayatsuri_model_instance_init+0x8b>
    33fa:	4d 39 d1             	cmp    %r10,%r9
    33fd:	0f 82 2d 02 00 00    	jb     3630 <ayatsuri_model_instance_init+0x320>
    3403:	4c 89 ce             	mov    %r9,%rsi
    3406:	b8 01 00 00 00       	mov    $0x1,%eax
    340b:	4c 29 d6             	sub    %r10,%rsi
    340e:	4c 39 e6             	cmp    %r12,%rsi
    3411:	72 88                	jb     339b <ayatsuri_model_instance_init+0x8b>
    3413:	4c 39 cb             	cmp    %r9,%rbx
    3416:	0f 82 34 02 00 00    	jb     3650 <ayatsuri_model_instance_init+0x340>
    341c:	48 89 de             	mov    %rbx,%rsi
    341f:	b8 01 00 00 00       	mov    $0x1,%eax
    3424:	4c 29 ce             	sub    %r9,%rsi
    3427:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    342e:	0f 86 67 ff ff ff    	jbe    339b <ayatsuri_model_instance_init+0x8b>
    3434:	48 85 d2             	test   %rdx,%rdx
    3437:	74 1e                	je     3457 <ayatsuri_model_instance_init+0x147>
    3439:	4c 39 c9             	cmp    %r9,%rcx
    343c:	0f 82 ed 02 00 00    	jb     372f <ayatsuri_model_instance_init+0x41f>
    3442:	4c 29 c9             	sub    %r9,%rcx
    3445:	b8 01 00 00 00       	mov    $0x1,%eax
    344a:	48 81 f9 a7 00 00 00 	cmp    $0xa7,%rcx
    3451:	0f 86 44 ff ff ff    	jbe    339b <ayatsuri_model_instance_init+0x8b>
    3457:	4c 89 d7             	mov    %r10,%rdi
    345a:	4c 89 e2             	mov    %r12,%rdx
    345d:	31 f6                	xor    %esi,%esi
    345f:	4c 89 4c 24 08       	mov    %r9,0x8(%rsp)
    3464:	44 89 44 24 04       	mov    %r8d,0x4(%rsp)
    3469:	e8 00 00 00 00       	call   346e <ayatsuri_model_instance_init+0x15e>
			346a: R_X86_64_PLT32	memset-0x4
    346e:	0f b7 53 0c          	movzwl 0xc(%rbx),%edx
    3472:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
    3477:	b9 15 00 00 00       	mov    $0x15,%ecx
    347c:	49 89 c2             	mov    %rax,%r10
    347f:	31 c0                	xor    %eax,%eax
    3481:	44 8b 44 24 04       	mov    0x4(%rsp),%r8d
    3486:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
    348b:	f3 48 ab             	rep stos %rax,%es:(%rdi)
    348e:	89 d0                	mov    %edx,%eax
    3490:	8d 14 52             	lea    (%rdx,%rdx,2),%edx
    3493:	66 85 c0             	test   %ax,%ax
    3496:	44 8d 34 d5 00 00 00 	lea    0x0(,%rdx,8),%r14d
    349d:	00 
    349e:	0f 84 a4 02 00 00    	je     3748 <ayatsuri_model_instance_init+0x438>
    34a4:	f3 0f 7e 0d 00 00 00 	movq   0x0(%rip),%xmm1        # 34ac <ayatsuri_model_instance_init+0x19c>
    34ab:	00 
			34a8: R_X86_64_PC32	.LC32-0x4
    34ac:	45 31 db             	xor    %r11d,%r11d
    34af:	45 31 ff             	xor    %r15d,%r15d
    34b2:	eb 3f                	jmp    34f3 <ayatsuri_model_instance_init+0x1e3>
    34b4:	0f 1f 40 00          	nopl   0x0(%rax)
    34b8:	b9 d3 ff ff ff       	mov    $0xffffffd3,%ecx
    34bd:	41 39 cf             	cmp    %ecx,%r15d
    34c0:	41 0f 46 cf          	cmovbe %r15d,%ecx
    34c4:	44 8d 79 2c          	lea    0x2c(%rcx),%r15d
    34c8:	8b 4a 0c             	mov    0xc(%rdx),%ecx
    34cb:	89 8e 34 01 00 00    	mov    %ecx,0x134(%rsi)
    34d1:	89 c6                	mov    %eax,%esi
    34d3:	48 89 df             	mov    %rbx,%rdi
    34d6:	49 83 c3 01          	add    $0x1,%r11
    34da:	49 83 c5 18          	add    $0x18,%r13
    34de:	e8 7d d0 ff ff       	call   560 <node_slot_bytes>
    34e3:	41 01 c6             	add    %eax,%r14d
    34e6:	0f b7 43 0c          	movzwl 0xc(%rbx),%eax
    34ea:	41 39 c3             	cmp    %eax,%r11d
    34ed:	0f 83 77 01 00 00    	jae    366a <ayatsuri_model_instance_init+0x35a>
    34f3:	8b 53 14             	mov    0x14(%rbx),%edx
    34f6:	4c 89 de             	mov    %r11,%rsi
    34f9:	48 8b 0b             	mov    (%rbx),%rcx
    34fc:	45 89 75 08          	mov    %r14d,0x8(%r13)
    3500:	48 c1 e6 04          	shl    $0x4,%rsi
    3504:	4f 8d 04 db          	lea    (%r11,%r11,8),%r8
    3508:	44 89 d8             	mov    %r11d,%eax
    350b:	48 01 f2             	add    %rsi,%rdx
    350e:	48 01 ca             	add    %rcx,%rdx
    3511:	0f b6 72 03          	movzbl 0x3(%rdx),%esi
    3515:	41 88 75 10          	mov    %sil,0x10(%r13)
    3519:	8b 7b 1c             	mov    0x1c(%rbx),%edi
    351c:	44 89 f6             	mov    %r14d,%esi
    351f:	49 8d 74 32 30       	lea    0x30(%r10,%rsi,1),%rsi
    3524:	4a 8d 3c 87          	lea    (%rdi,%r8,4),%rdi
    3528:	48 01 f9             	add    %rdi,%rcx
    352b:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
    352f:	0f 11 06             	movups %xmm0,(%rsi)
    3532:	f3 0f 6f 41 10       	movdqu 0x10(%rcx),%xmm0
    3537:	0f 11 46 10          	movups %xmm0,0x10(%rsi)
    353b:	8b 49 20             	mov    0x20(%rcx),%ecx
    353e:	89 4e 20             	mov    %ecx,0x20(%rsi)
    3541:	b9 db ff ff ff       	mov    $0xffffffdb,%ecx
    3546:	41 39 cf             	cmp    %ecx,%r15d
    3549:	41 0f 46 cf          	cmovbe %r15d,%ecx
    354d:	44 8d 79 24          	lea    0x24(%rcx),%r15d
    3551:	0f b6 4a 02          	movzbl 0x2(%rdx),%ecx
    3555:	84 c9                	test   %cl,%cl
    3557:	0f 84 74 ff ff ff    	je     34d1 <ayatsuri_model_instance_init+0x1c1>
    355d:	80 f9 03             	cmp    $0x3,%cl
    3560:	0f 84 6b ff ff ff    	je     34d1 <ayatsuri_model_instance_init+0x1c1>
    3566:	0f b7 4a 08          	movzwl 0x8(%rdx),%ecx
    356a:	41 b8 08 01 00 00    	mov    $0x108,%r8d
    3570:	8d 34 c9             	lea    (%rcx,%rcx,8),%esi
    3573:	8b 4b 34             	mov    0x34(%rbx),%ecx
    3576:	c1 e6 03             	shl    $0x3,%esi
    3579:	48 01 ce             	add    %rcx,%rsi
    357c:	48 03 33             	add    (%rbx),%rsi
    357f:	8b 4e 2c             	mov    0x2c(%rsi),%ecx
    3582:	48 8d 7e 38          	lea    0x38(%rsi),%rdi
    3586:	41 89 4d 0c          	mov    %ecx,0xc(%r13)
    358a:	b9 2c 00 00 00       	mov    $0x2c,%ecx
    358f:	e8 6c ca ff ff       	call   0 <md>
    3594:	41 8b 7d 08          	mov    0x8(%r13),%edi
    3598:	f2 41 0f 11 45 00    	movsd  %xmm0,0x0(%r13)
    359e:	80 7a 02 01          	cmpb   $0x1,0x2(%rdx)
    35a2:	75 0b                	jne    35af <ayatsuri_model_instance_init+0x29f>
    35a4:	b9 20 00 00 00       	mov    $0x20,%ecx
    35a9:	41 b8 a4 00 00 00    	mov    $0xa4,%r8d
    35af:	49 01 f8             	add    %rdi,%r8
    35b2:	48 8b 3e             	mov    (%rsi),%rdi
    35b5:	4d 01 d0             	add    %r10,%r8
    35b8:	49 89 38             	mov    %rdi,(%r8)
    35bb:	48 8b 7c 0e f8       	mov    -0x8(%rsi,%rcx,1),%rdi
    35c0:	4a 89 7c 01 f8       	mov    %rdi,-0x8(%rcx,%r8,1)
    35c5:	49 8d 78 08          	lea    0x8(%r8),%rdi
    35c9:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
    35cd:	49 29 f8             	sub    %rdi,%r8
    35d0:	44 01 c1             	add    %r8d,%ecx
    35d3:	4c 29 c6             	sub    %r8,%rsi
    35d6:	c1 e9 03             	shr    $0x3,%ecx
    35d9:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    35dc:	41 8b 4d 08          	mov    0x8(%r13),%ecx
    35e0:	80 7a 02 01          	cmpb   $0x1,0x2(%rdx)
    35e4:	49 8d 34 0a          	lea    (%r10,%rcx,1),%rsi
    35e8:	0f 85 ca fe ff ff    	jne    34b8 <ayatsuri_model_instance_init+0x1a8>
    35ee:	b9 df ff ff ff       	mov    $0xffffffdf,%ecx
    35f3:	0f 13 8e fc 00 00 00 	movlps %xmm1,0xfc(%rsi)
    35fa:	41 39 cf             	cmp    %ecx,%r15d
    35fd:	41 0f 46 cf          	cmovbe %r15d,%ecx
    3601:	44 8d 79 20          	lea    0x20(%rcx),%r15d
    3605:	e9 c7 fe ff ff       	jmp    34d1 <ayatsuri_model_instance_init+0x1c1>
    360a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3610:	48 89 de             	mov    %rbx,%rsi
    3613:	b8 01 00 00 00       	mov    $0x1,%eax
    3618:	4c 29 d6             	sub    %r10,%rsi
    361b:	4c 39 e6             	cmp    %r12,%rsi
    361e:	0f 82 77 fd ff ff    	jb     339b <ayatsuri_model_instance_init+0x8b>
    3624:	e9 d1 fd ff ff       	jmp    33fa <ayatsuri_model_instance_init+0xea>
    3629:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3630:	4c 89 d6             	mov    %r10,%rsi
    3633:	b8 01 00 00 00       	mov    $0x1,%eax
    3638:	4c 29 ce             	sub    %r9,%rsi
    363b:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    3642:	0f 86 53 fd ff ff    	jbe    339b <ayatsuri_model_instance_init+0x8b>
    3648:	e9 c6 fd ff ff       	jmp    3413 <ayatsuri_model_instance_init+0x103>
    364d:	0f 1f 00             	nopl   (%rax)
    3650:	4c 89 ce             	mov    %r9,%rsi
    3653:	b8 01 00 00 00       	mov    $0x1,%eax
    3658:	48 29 de             	sub    %rbx,%rsi
    365b:	48 83 fe 7f          	cmp    $0x7f,%rsi
    365f:	0f 86 36 fd ff ff    	jbe    339b <ayatsuri_model_instance_init+0x8b>
    3665:	e9 ca fd ff ff       	jmp    3434 <ayatsuri_model_instance_init+0x124>
    366a:	44 8b 44 24 04       	mov    0x4(%rsp),%r8d
    366f:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
    3674:	48 89 5c 24 10       	mov    %rbx,0x10(%rsp)
    3679:	4c 89 54 24 18       	mov    %r10,0x18(%rsp)
    367e:	66 0f 6f 44 24 10    	movdqa 0x10(%rsp),%xmm0
    3684:	48 89 6c 24 20       	mov    %rbp,0x20(%rsp)
    3689:	4c 89 64 24 28       	mov    %r12,0x28(%rsp)
    368e:	41 0f 11 01          	movups %xmm0,(%r9)
    3692:	66 0f 6f 44 24 20    	movdqa 0x20(%rsp),%xmm0
    3698:	44 89 44 24 30       	mov    %r8d,0x30(%rsp)
    369d:	41 0f 11 41 10       	movups %xmm0,0x10(%r9)
    36a2:	66 0f 6f 44 24 30    	movdqa 0x30(%rsp),%xmm0
    36a8:	44 89 bc 24 ac 00 00 	mov    %r15d,0xac(%rsp)
    36af:	00 
    36b0:	41 0f 11 41 20       	movups %xmm0,0x20(%r9)
    36b5:	66 0f 6f 44 24 40    	movdqa 0x40(%rsp),%xmm0
    36bb:	c6 84 24 b4 00 00 00 	movb   $0x1,0xb4(%rsp)
    36c2:	01 
    36c3:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
    36ca:	00 
    36cb:	41 0f 11 41 30       	movups %xmm0,0x30(%r9)
    36d0:	66 0f 6f 44 24 50    	movdqa 0x50(%rsp),%xmm0
    36d6:	49 89 81 a0 00 00 00 	mov    %rax,0xa0(%r9)
    36dd:	31 c0                	xor    %eax,%eax
    36df:	41 0f 11 41 40       	movups %xmm0,0x40(%r9)
    36e4:	66 0f 6f 44 24 60    	movdqa 0x60(%rsp),%xmm0
    36ea:	41 0f 11 41 50       	movups %xmm0,0x50(%r9)
    36ef:	66 0f 6f 44 24 70    	movdqa 0x70(%rsp),%xmm0
    36f5:	41 0f 11 41 60       	movups %xmm0,0x60(%r9)
    36fa:	66 0f 6f 84 24 80 00 	movdqa 0x80(%rsp),%xmm0
    3701:	00 00 
    3703:	41 0f 11 41 70       	movups %xmm0,0x70(%r9)
    3708:	66 0f 6f 84 24 90 00 	movdqa 0x90(%rsp),%xmm0
    370f:	00 00 
    3711:	41 0f 11 81 80 00 00 	movups %xmm0,0x80(%r9)
    3718:	00 
    3719:	66 0f 6f 84 24 a0 00 	movdqa 0xa0(%rsp),%xmm0
    3720:	00 00 
    3722:	41 0f 11 81 90 00 00 	movups %xmm0,0x90(%r9)
    3729:	00 
    372a:	e9 6c fc ff ff       	jmp    339b <ayatsuri_model_instance_init+0x8b>
    372f:	4c 89 ce             	mov    %r9,%rsi
    3732:	b8 01 00 00 00       	mov    $0x1,%eax
    3737:	48 29 ce             	sub    %rcx,%rsi
    373a:	48 39 d6             	cmp    %rdx,%rsi
    373d:	0f 82 58 fc ff ff    	jb     339b <ayatsuri_model_instance_init+0x8b>
    3743:	e9 0f fd ff ff       	jmp    3457 <ayatsuri_model_instance_init+0x147>
    3748:	45 31 ff             	xor    %r15d,%r15d
    374b:	e9 24 ff ff ff       	jmp    3674 <ayatsuri_model_instance_init+0x364>

0000000000003750 <ayatsuri_model_instance_dispose>:
    3750:	b8 03 00 00 00       	mov    $0x3,%eax
    3755:	48 85 ff             	test   %rdi,%rdi
    3758:	74 46                	je     37a0 <ayatsuri_model_instance_dispose+0x50>
    375a:	48 85 f6             	test   %rsi,%rsi
    375d:	74 41                	je     37a0 <ayatsuri_model_instance_dispose+0x50>
    375f:	48 39 77 10          	cmp    %rsi,0x10(%rdi)
    3763:	75 3b                	jne    37a0 <ayatsuri_model_instance_dispose+0x50>
    3765:	39 57 20             	cmp    %edx,0x20(%rdi)
    3768:	75 36                	jne    37a0 <ayatsuri_model_instance_dispose+0x50>
    376a:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    3771:	b8 04 00 00 00       	mov    $0x4,%eax
    3776:	75 28                	jne    37a0 <ayatsuri_model_instance_dispose+0x50>
    3778:	c6 87 a4 00 00 00 00 	movb   $0x0,0xa4(%rdi)
    377f:	31 c0                	xor    %eax,%eax
    3781:	c6 87 a6 00 00 00 00 	movb   $0x0,0xa6(%rdi)
    3788:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
    378f:	00 
    3790:	48 c7 47 18 00 00 00 	movq   $0x0,0x18(%rdi)
    3797:	00 
    3798:	c3                   	ret
    3799:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    37a0:	c3                   	ret
    37a1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    37a8:	00 00 00 00 
    37ac:	0f 1f 40 00          	nopl   0x0(%rax)

00000000000037b0 <ayatsuri_model_instance_targets>:
    37b0:	48 85 ff             	test   %rdi,%rdi
    37b3:	0f 84 d7 00 00 00    	je     3890 <ayatsuri_model_instance_targets+0xe0>
    37b9:	48 89 f8             	mov    %rdi,%rax
    37bc:	bf 03 00 00 00       	mov    $0x3,%edi
    37c1:	80 b8 a4 00 00 00 01 	cmpb   $0x1,0xa4(%rax)
    37c8:	0f 85 c7 00 00 00    	jne    3895 <ayatsuri_model_instance_targets+0xe5>
    37ce:	48 85 f6             	test   %rsi,%rsi
    37d1:	0f 84 be 00 00 00    	je     3895 <ayatsuri_model_instance_targets+0xe5>
    37d7:	48 3b 70 10          	cmp    0x10(%rax),%rsi
    37db:	0f 85 b4 00 00 00    	jne    3895 <ayatsuri_model_instance_targets+0xe5>
    37e1:	3b 50 20             	cmp    0x20(%rax),%edx
    37e4:	0f 85 ab 00 00 00    	jne    3895 <ayatsuri_model_instance_targets+0xe5>
    37ea:	80 b8 a5 00 00 00 00 	cmpb   $0x0,0xa5(%rax)
    37f1:	bf 04 00 00 00       	mov    $0x4,%edi
    37f6:	0f 85 99 00 00 00    	jne    3895 <ayatsuri_model_instance_targets+0xe5>
    37fc:	41 57                	push   %r15
    37fe:	41 56                	push   %r14
    3800:	41 55                	push   %r13
    3802:	41 54                	push   %r12
    3804:	55                   	push   %rbp
    3805:	53                   	push   %rbx
    3806:	48 83 ec 18          	sub    $0x18,%rsp
    380a:	48 8b 38             	mov    (%rax),%rdi
    380d:	c6 80 a5 00 00 00 01 	movb   $0x1,0xa5(%rax)
    3814:	0f b7 57 0c          	movzwl 0xc(%rdi),%edx
    3818:	48 89 d3             	mov    %rdx,%rbx
    381b:	48 85 c9             	test   %rcx,%rcx
    381e:	0f 84 8c 00 00 00    	je     38b0 <ayatsuri_model_instance_targets+0x100>
    3824:	48 39 51 20          	cmp    %rdx,0x20(%rcx)
    3828:	0f 85 82 00 00 00    	jne    38b0 <ayatsuri_model_instance_targets+0x100>
    382e:	48 8b 31             	mov    (%rcx),%rsi
    3831:	48 85 f6             	test   %rsi,%rsi
    3834:	74 7a                	je     38b0 <ayatsuri_model_instance_targets+0x100>
    3836:	4c 8b 41 08          	mov    0x8(%rcx),%r8
    383a:	4d 85 c0             	test   %r8,%r8
    383d:	74 71                	je     38b0 <ayatsuri_model_instance_targets+0x100>
    383f:	4c 8b 51 10          	mov    0x10(%rcx),%r10
    3843:	4d 85 d2             	test   %r10,%r10
    3846:	74 68                	je     38b0 <ayatsuri_model_instance_targets+0x100>
    3848:	4c 8b 59 18          	mov    0x18(%rcx),%r11
    384c:	4d 85 db             	test   %r11,%r11
    384f:	74 5f                	je     38b0 <ayatsuri_model_instance_targets+0x100>
    3851:	48 8b 68 18          	mov    0x18(%rax),%rbp
    3855:	4c 8b 48 08          	mov    0x8(%rax),%r9
    3859:	48 85 ed             	test   %rbp,%rbp
    385c:	4c 89 c9             	mov    %r9,%rcx
    385f:	41 0f 95 c4          	setne  %r12b
    3863:	48 85 d2             	test   %rdx,%rdx
    3866:	74 68                	je     38d0 <ayatsuri_model_instance_targets+0x120>
    3868:	45 84 e4             	test   %r12b,%r12b
    386b:	74 63                	je     38d0 <ayatsuri_model_instance_targets+0x120>
    386d:	49 39 f1             	cmp    %rsi,%r9
    3870:	73 2e                	jae    38a0 <ayatsuri_model_instance_targets+0xf0>
    3872:	49 89 f5             	mov    %rsi,%r13
    3875:	4d 29 cd             	sub    %r9,%r13
    3878:	49 39 ed             	cmp    %rbp,%r13
    387b:	72 33                	jb     38b0 <ayatsuri_model_instance_targets+0x100>
    387d:	4c 8d 2c d5 00 00 00 	lea    0x0(,%rdx,8),%r13
    3884:	00 
    3885:	4d 8d 7c 15 00       	lea    0x0(%r13,%rdx,1),%r15
    388a:	49 c1 e7 02          	shl    $0x2,%r15
    388e:	eb 60                	jmp    38f0 <ayatsuri_model_instance_targets+0x140>
    3890:	bf 03 00 00 00       	mov    $0x3,%edi
    3895:	89 f8                	mov    %edi,%eax
    3897:	c3                   	ret
    3898:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    389f:	00 
    38a0:	4d 89 cd             	mov    %r9,%r13
    38a3:	49 29 f5             	sub    %rsi,%r13
    38a6:	49 39 d5             	cmp    %rdx,%r13
    38a9:	73 d2                	jae    387d <ayatsuri_model_instance_targets+0xcd>
    38ab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    38b0:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    38b7:	bf 01 00 00 00       	mov    $0x1,%edi
    38bc:	48 83 c4 18          	add    $0x18,%rsp
    38c0:	89 f8                	mov    %edi,%eax
    38c2:	5b                   	pop    %rbx
    38c3:	5d                   	pop    %rbp
    38c4:	41 5c                	pop    %r12
    38c6:	41 5d                	pop    %r13
    38c8:	41 5e                	pop    %r14
    38ca:	41 5f                	pop    %r15
    38cc:	c3                   	ret
    38cd:	0f 1f 00             	nopl   (%rax)
    38d0:	4c 8d 2c d5 00 00 00 	lea    0x0(,%rdx,8),%r13
    38d7:	00 
    38d8:	4d 8d 74 15 00       	lea    0x0(%r13,%rdx,1),%r14
    38dd:	4e 8d 3c b5 00 00 00 	lea    0x0(,%r14,4),%r15
    38e4:	00 
    38e5:	4d 85 f6             	test   %r14,%r14
    38e8:	74 26                	je     3910 <ayatsuri_model_instance_targets+0x160>
    38ea:	45 84 e4             	test   %r12b,%r12b
    38ed:	74 21                	je     3910 <ayatsuri_model_instance_targets+0x160>
    38ef:	90                   	nop
    38f0:	4d 39 c1             	cmp    %r8,%r9
    38f3:	0f 82 67 03 00 00    	jb     3c60 <ayatsuri_model_instance_targets+0x4b0>
    38f9:	4d 89 ce             	mov    %r9,%r14
    38fc:	4d 29 c6             	sub    %r8,%r14
    38ff:	4d 39 fe             	cmp    %r15,%r14
    3902:	72 ac                	jb     38b0 <ayatsuri_model_instance_targets+0x100>
    3904:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    390b:	00 00 00 00 
    390f:	90                   	nop
    3910:	4c 8d 34 95 00 00 00 	lea    0x0(,%rdx,4),%r14
    3917:	00 
    3918:	48 85 d2             	test   %rdx,%rdx
    391b:	74 23                	je     3940 <ayatsuri_model_instance_targets+0x190>
    391d:	45 84 e4             	test   %r12b,%r12b
    3920:	74 1e                	je     3940 <ayatsuri_model_instance_targets+0x190>
    3922:	4d 39 d1             	cmp    %r10,%r9
    3925:	0f 82 65 03 00 00    	jb     3c90 <ayatsuri_model_instance_targets+0x4e0>
    392b:	4c 89 ca             	mov    %r9,%rdx
    392e:	4c 29 d2             	sub    %r10,%rdx
    3931:	4c 39 f2             	cmp    %r14,%rdx
    3934:	0f 82 76 ff ff ff    	jb     38b0 <ayatsuri_model_instance_targets+0x100>
    393a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3940:	4d 85 ed             	test   %r13,%r13
    3943:	74 2b                	je     3970 <ayatsuri_model_instance_targets+0x1c0>
    3945:	45 84 e4             	test   %r12b,%r12b
    3948:	74 26                	je     3970 <ayatsuri_model_instance_targets+0x1c0>
    394a:	4d 39 d9             	cmp    %r11,%r9
    394d:	0f 82 51 03 00 00    	jb     3ca4 <ayatsuri_model_instance_targets+0x4f4>
    3953:	4c 89 ca             	mov    %r9,%rdx
    3956:	4c 29 da             	sub    %r11,%rdx
    3959:	4c 39 ea             	cmp    %r13,%rdx
    395c:	0f 82 4e ff ff ff    	jb     38b0 <ayatsuri_model_instance_targets+0x100>
    3962:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    3969:	00 00 00 00 
    396d:	0f 1f 00             	nopl   (%rax)
    3970:	44 0f b7 fb          	movzwl %bx,%r15d
    3974:	45 85 ff             	test   %r15d,%r15d
    3977:	0f 84 d3 02 00 00    	je     3c50 <ayatsuri_model_instance_targets+0x4a0>
    397d:	8b 57 14             	mov    0x14(%rdi),%edx
    3980:	4c 89 1c 24          	mov    %r11,(%rsp)
    3984:	31 ed                	xor    %ebp,%ebp
    3986:	bb ab aa aa aa       	mov    $0xaaaaaaab,%ebx
    398b:	48 8b 3f             	mov    (%rdi),%rdi
    398e:	4c 89 4c 24 08       	mov    %r9,0x8(%rsp)
    3993:	66 0f ef e4          	pxor   %xmm4,%xmm4
    3997:	45 31 f6             	xor    %r14d,%r14d
    399a:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
    399f:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 39a7 <ayatsuri_model_instance_targets+0x1f7>
    39a6:	00 
			39a3: R_X86_64_PC32	.LC1-0x4
    39a7:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 39af <ayatsuri_model_instance_targets+0x1ff>
    39ae:	00 
			39ab: R_X86_64_PC32	.LC0-0x4
    39af:	48 8d 54 17 02       	lea    0x2(%rdi,%rdx,1),%rdx
    39b4:	44 0f b6 0c 2e       	movzbl (%rsi,%rbp,1),%r9d
    39b9:	45 89 cc             	mov    %r9d,%r12d
    39bc:	45 84 c9             	test   %r9b,%r9b
    39bf:	0f 88 eb fe ff ff    	js     38b0 <ayatsuri_model_instance_targets+0x100>
    39c5:	44 89 c9             	mov    %r9d,%ecx
    39c8:	f7 d1                	not    %ecx
    39ca:	83 e1 18             	and    $0x18,%ecx
    39cd:	0f 84 dd fe ff ff    	je     38b0 <ayatsuri_model_instance_targets+0x100>
    39d3:	0f b6 0a             	movzbl (%rdx),%ecx
    39d6:	84 c9                	test   %cl,%cl
    39d8:	0f 84 9a 02 00 00    	je     3c78 <ayatsuri_model_instance_targets+0x4c8>
    39de:	80 f9 03             	cmp    $0x3,%cl
    39e1:	0f 84 91 02 00 00    	je     3c78 <ayatsuri_model_instance_targets+0x4c8>
    39e7:	41 89 eb             	mov    %ebp,%r11d
    39ea:	44 8d 6c ed 00       	lea    0x0(%rbp,%rbp,8),%r13d
    39ef:	31 ff                	xor    %edi,%edi
    39f1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    39f8:	00 00 00 00 
    39fc:	0f 1f 40 00          	nopl   0x0(%rax)
    3a00:	89 f9                	mov    %edi,%ecx
    3a02:	48 0f af cb          	imul   %rbx,%rcx
    3a06:	48 c1 e9 21          	shr    $0x21,%rcx
    3a0a:	41 0f a3 c9          	bt     %ecx,%r9d
    3a0e:	73 31                	jae    3a41 <ayatsuri_model_instance_targets+0x291>
    3a10:	41 8d 4c 3d 00       	lea    0x0(%r13,%rdi,1),%ecx
    3a15:	f3 41 0f 10 04 88    	movss  (%r8,%rcx,4),%xmm0
    3a1b:	0f 28 c8             	movaps %xmm0,%xmm1
    3a1e:	0f 54 cb             	andps  %xmm3,%xmm1
    3a21:	0f 2e d1             	ucomiss %xmm1,%xmm2
    3a24:	0f 82 86 fe ff ff    	jb     38b0 <ayatsuri_model_instance_targets+0x100>
    3a2a:	83 ff 05             	cmp    $0x5,%edi
    3a2d:	76 12                	jbe    3a41 <ayatsuri_model_instance_targets+0x291>
    3a2f:	0f 2e c4             	ucomiss %xmm4,%xmm0
    3a32:	0f 9b c1             	setnp  %cl
    3a35:	41 0f 45 ce          	cmovne %r14d,%ecx
    3a39:	84 c9                	test   %cl,%cl
    3a3b:	0f 85 6f fe ff ff    	jne    38b0 <ayatsuri_model_instance_targets+0x100>
    3a41:	83 c7 01             	add    $0x1,%edi
    3a44:	83 ff 09             	cmp    $0x9,%edi
    3a47:	75 b7                	jne    3a00 <ayatsuri_model_instance_targets+0x250>
    3a49:	41 f6 c4 20          	test   $0x20,%r12b
    3a4d:	74 0e                	je     3a5d <ayatsuri_model_instance_targets+0x2ad>
    3a4f:	41 81 3c aa ff ff ff 	cmpl   $0xffffff,(%r10,%rbp,4)
    3a56:	00 
    3a57:	0f 87 53 fe ff ff    	ja     38b0 <ayatsuri_model_instance_targets+0x100>
    3a5d:	41 83 e4 40          	and    $0x40,%r12d
    3a61:	74 5d                	je     3ac0 <ayatsuri_model_instance_targets+0x310>
    3a63:	48 8b 0c 24          	mov    (%rsp),%rcx
    3a67:	42 8d 3c dd 00 00 00 	lea    0x0(,%r11,8),%edi
    3a6e:	00 
    3a6f:	48 01 cf             	add    %rcx,%rdi
    3a72:	e8 89 c5 ff ff       	call   0 <md>
    3a77:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 3a7f <ayatsuri_model_instance_targets+0x2cf>
    3a7e:	00 
			3a7b: R_X86_64_PC32	.LC18-0x4
    3a7f:	66 0f 28 c8          	movapd %xmm0,%xmm1
    3a83:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 3a8b <ayatsuri_model_instance_targets+0x2db>
    3a8a:	00 
			3a87: R_X86_64_PC32	.LC8-0x4
    3a8b:	66 0f 2e e9          	ucomisd %xmm1,%xmm5
    3a8f:	0f 82 1b fe ff ff    	jb     38b0 <ayatsuri_model_instance_targets+0x100>
    3a95:	66 0f ef c9          	pxor   %xmm1,%xmm1
    3a99:	66 0f 2f c1          	comisd %xmm1,%xmm0
    3a9d:	0f 82 0d fe ff ff    	jb     38b0 <ayatsuri_model_instance_targets+0x100>
    3aa3:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 3aab <ayatsuri_model_instance_targets+0x2fb>
    3aaa:	00 
			3aa7: R_X86_64_PC32	.LC9-0x4
    3aab:	66 0f 2f c8          	comisd %xmm0,%xmm1
    3aaf:	0f 82 fb fd ff ff    	jb     38b0 <ayatsuri_model_instance_targets+0x100>
    3ab5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    3abc:	00 00 00 00 
    3ac0:	48 83 c5 01          	add    $0x1,%rbp
    3ac4:	48 83 c2 10          	add    $0x10,%rdx
    3ac8:	44 39 fd             	cmp    %r15d,%ebp
    3acb:	0f 82 e3 fe ff ff    	jb     39b4 <ayatsuri_model_instance_targets+0x204>
    3ad1:	43 8d 1c ff          	lea    (%r15,%r15,8),%ebx
    3ad5:	4c 8b 1c 24          	mov    (%rsp),%r11
    3ad9:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
    3ade:	45 31 ed             	xor    %r13d,%r13d
    3ae1:	89 1c 24             	mov    %ebx,(%rsp)
    3ae4:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
    3ae9:	41 bc ab aa aa aa    	mov    $0xaaaaaaab,%r12d
    3aef:	c6 44 24 08 00       	movb   $0x0,0x8(%rsp)
    3af4:	0f b6 1e             	movzbl (%rsi),%ebx
    3af7:	8b 69 08             	mov    0x8(%rcx),%ebp
    3afa:	45 31 ff             	xor    %r15d,%r15d
    3afd:	31 ff                	xor    %edi,%edi
    3aff:	41 89 de             	mov    %ebx,%r14d
    3b02:	4c 01 cd             	add    %r9,%rbp
    3b05:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    3b0c:	00 00 00 00 
    3b10:	89 fa                	mov    %edi,%edx
    3b12:	49 0f af d4          	imul   %r12,%rdx
    3b16:	48 c1 ea 21          	shr    $0x21,%rdx
    3b1a:	0f a3 d3             	bt     %edx,%ebx
    3b1d:	73 3c                	jae    3b5b <ayatsuri_model_instance_targets+0x3ab>
    3b1f:	41 8d 54 3d 00       	lea    0x0(%r13,%rdi,1),%edx
    3b24:	f3 41 0f 10 04 90    	movss  (%r8,%rdx,4),%xmm0
    3b2a:	0f 2e 44 bd 30       	ucomiss 0x30(%rbp,%rdi,4),%xmm0
    3b2f:	7a 02                	jp     3b33 <ayatsuri_model_instance_targets+0x383>
    3b31:	74 28                	je     3b5b <ayatsuri_model_instance_targets+0x3ab>
    3b33:	8b 90 a0 00 00 00    	mov    0xa0(%rax),%edx
    3b39:	41 bf fb ff ff ff    	mov    $0xfffffffb,%r15d
    3b3f:	f3 0f 11 44 bd 30    	movss  %xmm0,0x30(%rbp,%rdi,4)
    3b45:	44 39 fa             	cmp    %r15d,%edx
    3b48:	41 0f 47 d7          	cmova  %r15d,%edx
    3b4c:	41 bf 01 00 00 00    	mov    $0x1,%r15d
    3b52:	83 c2 04             	add    $0x4,%edx
    3b55:	89 90 a0 00 00 00    	mov    %edx,0xa0(%rax)
    3b5b:	48 83 c7 01          	add    $0x1,%rdi
    3b5f:	48 83 ff 09          	cmp    $0x9,%rdi
    3b63:	75 ab                	jne    3b10 <ayatsuri_model_instance_targets+0x360>
    3b65:	41 f6 c6 18          	test   $0x18,%r14b
    3b69:	0f 84 49 01 00 00    	je     3cb8 <ayatsuri_model_instance_targets+0x508>
    3b6f:	44 89 f2             	mov    %r14d,%edx
    3b72:	c0 ea 03             	shr    $0x3,%dl
    3b75:	83 e2 01             	and    $0x1,%edx
    3b78:	38 51 10             	cmp    %dl,0x10(%rcx)
    3b7b:	0f 84 37 01 00 00    	je     3cb8 <ayatsuri_model_instance_targets+0x508>
    3b81:	88 51 10             	mov    %dl,0x10(%rcx)
    3b84:	8b 90 a0 00 00 00    	mov    0xa0(%rax),%edx
    3b8a:	31 ff                	xor    %edi,%edi
    3b8c:	83 fa ff             	cmp    $0xffffffff,%edx
    3b8f:	40 0f 95 c7          	setne  %dil
    3b93:	01 fa                	add    %edi,%edx
    3b95:	89 90 a0 00 00 00    	mov    %edx,0xa0(%rax)
    3b9b:	41 f6 c6 20          	test   $0x20,%r14b
    3b9f:	74 24                	je     3bc5 <ayatsuri_model_instance_targets+0x415>
    3ba1:	41 8b 12             	mov    (%r10),%edx
    3ba4:	39 51 0c             	cmp    %edx,0xc(%rcx)
    3ba7:	74 1c                	je     3bc5 <ayatsuri_model_instance_targets+0x415>
    3ba9:	89 51 0c             	mov    %edx,0xc(%rcx)
    3bac:	8b 90 a0 00 00 00    	mov    0xa0(%rax),%edx
    3bb2:	bf fb ff ff ff       	mov    $0xfffffffb,%edi
    3bb7:	39 fa                	cmp    %edi,%edx
    3bb9:	0f 47 d7             	cmova  %edi,%edx
    3bbc:	83 c2 04             	add    $0x4,%edx
    3bbf:	89 90 a0 00 00 00    	mov    %edx,0xa0(%rax)
    3bc5:	41 83 e6 40          	and    $0x40,%r14d
    3bc9:	74 2d                	je     3bf8 <ayatsuri_model_instance_targets+0x448>
    3bcb:	4c 89 df             	mov    %r11,%rdi
    3bce:	e8 2d c4 ff ff       	call   0 <md>
    3bd3:	66 0f 2e 01          	ucomisd (%rcx),%xmm0
    3bd7:	7a 02                	jp     3bdb <ayatsuri_model_instance_targets+0x42b>
    3bd9:	74 1d                	je     3bf8 <ayatsuri_model_instance_targets+0x448>
    3bdb:	8b 90 a0 00 00 00    	mov    0xa0(%rax),%edx
    3be1:	bf f7 ff ff ff       	mov    $0xfffffff7,%edi
    3be6:	f2 0f 11 01          	movsd  %xmm0,(%rcx)
    3bea:	39 fa                	cmp    %edi,%edx
    3bec:	0f 47 d7             	cmova  %edi,%edx
    3bef:	83 c2 08             	add    $0x8,%edx
    3bf2:	89 90 a0 00 00 00    	mov    %edx,0xa0(%rax)
    3bf8:	8b 90 98 00 00 00    	mov    0x98(%rax),%edx
    3bfe:	31 ff                	xor    %edi,%edi
    3c00:	c6 44 24 08 01       	movb   $0x1,0x8(%rsp)
    3c05:	83 fa ff             	cmp    $0xffffffff,%edx
    3c08:	40 0f 95 c7          	setne  %dil
    3c0c:	01 fa                	add    %edi,%edx
    3c0e:	89 90 98 00 00 00    	mov    %edx,0x98(%rax)
    3c14:	8b 1c 24             	mov    (%rsp),%ebx
    3c17:	41 83 c5 09          	add    $0x9,%r13d
    3c1b:	48 83 c6 01          	add    $0x1,%rsi
    3c1f:	48 83 c1 18          	add    $0x18,%rcx
    3c23:	49 83 c3 08          	add    $0x8,%r11
    3c27:	49 83 c2 04          	add    $0x4,%r10
    3c2b:	41 39 dd             	cmp    %ebx,%r13d
    3c2e:	0f 85 c0 fe ff ff    	jne    3af4 <ayatsuri_model_instance_targets+0x344>
    3c34:	80 7c 24 08 00       	cmpb   $0x0,0x8(%rsp)
    3c39:	74 15                	je     3c50 <ayatsuri_model_instance_targets+0x4a0>
    3c3b:	8b 50 24             	mov    0x24(%rax),%edx
    3c3e:	83 fa ff             	cmp    $0xffffffff,%edx
    3c41:	74 03                	je     3c46 <ayatsuri_model_instance_targets+0x496>
    3c43:	83 c2 01             	add    $0x1,%edx
    3c46:	89 50 24             	mov    %edx,0x24(%rax)
    3c49:	c6 80 a6 00 00 00 00 	movb   $0x0,0xa6(%rax)
    3c50:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    3c57:	31 ff                	xor    %edi,%edi
    3c59:	e9 5e fc ff ff       	jmp    38bc <ayatsuri_model_instance_targets+0x10c>
    3c5e:	66 90                	xchg   %ax,%ax
    3c60:	4d 89 c6             	mov    %r8,%r14
    3c63:	4d 29 ce             	sub    %r9,%r14
    3c66:	49 39 ee             	cmp    %rbp,%r14
    3c69:	0f 82 41 fc ff ff    	jb     38b0 <ayatsuri_model_instance_targets+0x100>
    3c6f:	e9 9c fc ff ff       	jmp    3910 <ayatsuri_model_instance_targets+0x160>
    3c74:	0f 1f 40 00          	nopl   0x0(%rax)
    3c78:	41 f6 c4 60          	test   $0x60,%r12b
    3c7c:	0f 84 65 fd ff ff    	je     39e7 <ayatsuri_model_instance_targets+0x237>
    3c82:	e9 29 fc ff ff       	jmp    38b0 <ayatsuri_model_instance_targets+0x100>
    3c87:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    3c8e:	00 00 
    3c90:	4c 89 d2             	mov    %r10,%rdx
    3c93:	4c 29 ca             	sub    %r9,%rdx
    3c96:	48 39 ea             	cmp    %rbp,%rdx
    3c99:	0f 82 11 fc ff ff    	jb     38b0 <ayatsuri_model_instance_targets+0x100>
    3c9f:	e9 9c fc ff ff       	jmp    3940 <ayatsuri_model_instance_targets+0x190>
    3ca4:	4c 89 da             	mov    %r11,%rdx
    3ca7:	4c 29 ca             	sub    %r9,%rdx
    3caa:	48 39 ea             	cmp    %rbp,%rdx
    3cad:	0f 83 bd fc ff ff    	jae    3970 <ayatsuri_model_instance_targets+0x1c0>
    3cb3:	e9 f8 fb ff ff       	jmp    38b0 <ayatsuri_model_instance_targets+0x100>
    3cb8:	41 f6 c6 20          	test   $0x20,%r14b
    3cbc:	74 0c                	je     3cca <ayatsuri_model_instance_targets+0x51a>
    3cbe:	41 8b 12             	mov    (%r10),%edx
    3cc1:	39 51 0c             	cmp    %edx,0xc(%rcx)
    3cc4:	0f 85 df fe ff ff    	jne    3ba9 <ayatsuri_model_instance_targets+0x3f9>
    3cca:	41 83 e6 40          	and    $0x40,%r14d
    3cce:	74 18                	je     3ce8 <ayatsuri_model_instance_targets+0x538>
    3cd0:	4c 89 df             	mov    %r11,%rdi
    3cd3:	e8 28 c3 ff ff       	call   0 <md>
    3cd8:	66 0f 2e 01          	ucomisd (%rcx),%xmm0
    3cdc:	0f 8a f9 fe ff ff    	jp     3bdb <ayatsuri_model_instance_targets+0x42b>
    3ce2:	0f 85 f3 fe ff ff    	jne    3bdb <ayatsuri_model_instance_targets+0x42b>
    3ce8:	45 84 ff             	test   %r15b,%r15b
    3ceb:	0f 84 23 ff ff ff    	je     3c14 <ayatsuri_model_instance_targets+0x464>
    3cf1:	e9 02 ff ff ff       	jmp    3bf8 <ayatsuri_model_instance_targets+0x448>
    3cf6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    3cfd:	00 00 00 

0000000000003d00 <ayatsuri_model_instance_node_kind>:
    3d00:	48 89 f8             	mov    %rdi,%rax
    3d03:	89 cf                	mov    %ecx,%edi
    3d05:	b9 03 00 00 00       	mov    $0x3,%ecx
    3d0a:	48 85 c0             	test   %rax,%rax
    3d0d:	74 6d                	je     3d7c <ayatsuri_model_instance_node_kind+0x7c>
    3d0f:	80 b8 a4 00 00 00 01 	cmpb   $0x1,0xa4(%rax)
    3d16:	75 64                	jne    3d7c <ayatsuri_model_instance_node_kind+0x7c>
    3d18:	48 85 f6             	test   %rsi,%rsi
    3d1b:	74 5f                	je     3d7c <ayatsuri_model_instance_node_kind+0x7c>
    3d1d:	48 3b 70 10          	cmp    0x10(%rax),%rsi
    3d21:	75 59                	jne    3d7c <ayatsuri_model_instance_node_kind+0x7c>
    3d23:	3b 50 20             	cmp    0x20(%rax),%edx
    3d26:	75 54                	jne    3d7c <ayatsuri_model_instance_node_kind+0x7c>
    3d28:	80 b8 a5 00 00 00 00 	cmpb   $0x0,0xa5(%rax)
    3d2f:	b9 04 00 00 00       	mov    $0x4,%ecx
    3d34:	75 46                	jne    3d7c <ayatsuri_model_instance_node_kind+0x7c>
    3d36:	c6 80 a5 00 00 00 01 	movb   $0x1,0xa5(%rax)
    3d3d:	4d 85 c0             	test   %r8,%r8
    3d40:	74 2e                	je     3d70 <ayatsuri_model_instance_node_kind+0x70>
    3d42:	48 8b 10             	mov    (%rax),%rdx
    3d45:	66 3b 7a 0c          	cmp    0xc(%rdx),%di
    3d49:	73 25                	jae    3d70 <ayatsuri_model_instance_node_kind+0x70>
    3d4b:	4c 39 c0             	cmp    %r8,%rax
    3d4e:	73 30                	jae    3d80 <ayatsuri_model_instance_node_kind+0x80>
    3d50:	4c 89 c1             	mov    %r8,%rcx
    3d53:	48 29 c1             	sub    %rax,%rcx
    3d56:	48 81 f9 a7 00 00 00 	cmp    $0xa7,%rcx
    3d5d:	76 11                	jbe    3d70 <ayatsuri_model_instance_node_kind+0x70>
    3d5f:	4c 39 c2             	cmp    %r8,%rdx
    3d62:	72 24                	jb     3d88 <ayatsuri_model_instance_node_kind+0x88>
    3d64:	49 39 d0             	cmp    %rdx,%r8
    3d67:	75 2b                	jne    3d94 <ayatsuri_model_instance_node_kind+0x94>
    3d69:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3d70:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    3d77:	b9 01 00 00 00       	mov    $0x1,%ecx
    3d7c:	89 c8                	mov    %ecx,%eax
    3d7e:	c3                   	ret
    3d7f:	90                   	nop
    3d80:	74 ee                	je     3d70 <ayatsuri_model_instance_node_kind+0x70>
    3d82:	eb db                	jmp    3d5f <ayatsuri_model_instance_node_kind+0x5f>
    3d84:	0f 1f 40 00          	nopl   0x0(%rax)
    3d88:	4c 89 c1             	mov    %r8,%rcx
    3d8b:	48 29 d1             	sub    %rdx,%rcx
    3d8e:	48 83 f9 7f          	cmp    $0x7f,%rcx
    3d92:	76 dc                	jbe    3d70 <ayatsuri_model_instance_node_kind+0x70>
    3d94:	48 8b 48 18          	mov    0x18(%rax),%rcx
    3d98:	48 85 c9             	test   %rcx,%rcx
    3d9b:	74 13                	je     3db0 <ayatsuri_model_instance_node_kind+0xb0>
    3d9d:	48 8b 70 08          	mov    0x8(%rax),%rsi
    3da1:	4c 39 c6             	cmp    %r8,%rsi
    3da4:	72 5a                	jb     3e00 <ayatsuri_model_instance_node_kind+0x100>
    3da6:	49 39 f0             	cmp    %rsi,%r8
    3da9:	74 c5                	je     3d70 <ayatsuri_model_instance_node_kind+0x70>
    3dab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    3db0:	8b 4a 08             	mov    0x8(%rdx),%ecx
    3db3:	48 8b 32             	mov    (%rdx),%rsi
    3db6:	48 85 c9             	test   %rcx,%rcx
    3db9:	74 15                	je     3dd0 <ayatsuri_model_instance_node_kind+0xd0>
    3dbb:	4c 39 c6             	cmp    %r8,%rsi
    3dbe:	72 58                	jb     3e18 <ayatsuri_model_instance_node_kind+0x118>
    3dc0:	49 39 f0             	cmp    %rsi,%r8
    3dc3:	74 ab                	je     3d70 <ayatsuri_model_instance_node_kind+0x70>
    3dc5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    3dcc:	00 00 00 00 
    3dd0:	8b 52 14             	mov    0x14(%rdx),%edx
    3dd3:	48 89 f9             	mov    %rdi,%rcx
    3dd6:	48 c1 e1 04          	shl    $0x4,%rcx
    3dda:	81 e1 f0 ff 0f 00    	and    $0xffff0,%ecx
    3de0:	48 01 d6             	add    %rdx,%rsi
    3de3:	0f b6 54 31 02       	movzbl 0x2(%rcx,%rsi,1),%edx
    3de8:	31 c9                	xor    %ecx,%ecx
    3dea:	41 88 10             	mov    %dl,(%r8)
    3ded:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    3df4:	eb 86                	jmp    3d7c <ayatsuri_model_instance_node_kind+0x7c>
    3df6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    3dfd:	00 00 00 
    3e00:	4d 89 c1             	mov    %r8,%r9
    3e03:	49 29 f1             	sub    %rsi,%r9
    3e06:	49 39 c9             	cmp    %rcx,%r9
    3e09:	0f 82 61 ff ff ff    	jb     3d70 <ayatsuri_model_instance_node_kind+0x70>
    3e0f:	eb 9f                	jmp    3db0 <ayatsuri_model_instance_node_kind+0xb0>
    3e11:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3e18:	4d 89 c1             	mov    %r8,%r9
    3e1b:	49 29 f1             	sub    %rsi,%r9
    3e1e:	49 39 c9             	cmp    %rcx,%r9
    3e21:	73 ad                	jae    3dd0 <ayatsuri_model_instance_node_kind+0xd0>
    3e23:	e9 48 ff ff ff       	jmp    3d70 <ayatsuri_model_instance_node_kind+0x70>
    3e28:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    3e2f:	00 

0000000000003e30 <ayatsuri_model_instance_read_pose>:
    3e30:	48 89 f8             	mov    %rdi,%rax
    3e33:	89 cf                	mov    %ecx,%edi
    3e35:	b9 03 00 00 00       	mov    $0x3,%ecx
    3e3a:	48 85 c0             	test   %rax,%rax
    3e3d:	74 6d                	je     3eac <ayatsuri_model_instance_read_pose+0x7c>
    3e3f:	80 b8 a4 00 00 00 01 	cmpb   $0x1,0xa4(%rax)
    3e46:	75 64                	jne    3eac <ayatsuri_model_instance_read_pose+0x7c>
    3e48:	48 85 f6             	test   %rsi,%rsi
    3e4b:	74 5f                	je     3eac <ayatsuri_model_instance_read_pose+0x7c>
    3e4d:	48 3b 70 10          	cmp    0x10(%rax),%rsi
    3e51:	75 59                	jne    3eac <ayatsuri_model_instance_read_pose+0x7c>
    3e53:	3b 50 20             	cmp    0x20(%rax),%edx
    3e56:	75 54                	jne    3eac <ayatsuri_model_instance_read_pose+0x7c>
    3e58:	80 b8 a5 00 00 00 00 	cmpb   $0x0,0xa5(%rax)
    3e5f:	b9 04 00 00 00       	mov    $0x4,%ecx
    3e64:	75 46                	jne    3eac <ayatsuri_model_instance_read_pose+0x7c>
    3e66:	c6 80 a5 00 00 00 01 	movb   $0x1,0xa5(%rax)
    3e6d:	4d 85 c0             	test   %r8,%r8
    3e70:	74 2e                	je     3ea0 <ayatsuri_model_instance_read_pose+0x70>
    3e72:	48 8b 10             	mov    (%rax),%rdx
    3e75:	66 3b 7a 0c          	cmp    0xc(%rdx),%di
    3e79:	73 25                	jae    3ea0 <ayatsuri_model_instance_read_pose+0x70>
    3e7b:	4c 39 c0             	cmp    %r8,%rax
    3e7e:	73 30                	jae    3eb0 <ayatsuri_model_instance_read_pose+0x80>
    3e80:	4c 89 c1             	mov    %r8,%rcx
    3e83:	48 29 c1             	sub    %rax,%rcx
    3e86:	48 81 f9 a7 00 00 00 	cmp    $0xa7,%rcx
    3e8d:	76 11                	jbe    3ea0 <ayatsuri_model_instance_read_pose+0x70>
    3e8f:	4c 39 c2             	cmp    %r8,%rdx
    3e92:	72 2c                	jb     3ec0 <ayatsuri_model_instance_read_pose+0x90>
    3e94:	48 89 d1             	mov    %rdx,%rcx
    3e97:	4c 29 c1             	sub    %r8,%rcx
    3e9a:	48 83 f9 23          	cmp    $0x23,%rcx
    3e9e:	77 2c                	ja     3ecc <ayatsuri_model_instance_read_pose+0x9c>
    3ea0:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    3ea7:	b9 01 00 00 00       	mov    $0x1,%ecx
    3eac:	89 c8                	mov    %ecx,%eax
    3eae:	c3                   	ret
    3eaf:	90                   	nop
    3eb0:	48 89 c1             	mov    %rax,%rcx
    3eb3:	4c 29 c1             	sub    %r8,%rcx
    3eb6:	48 83 f9 23          	cmp    $0x23,%rcx
    3eba:	76 e4                	jbe    3ea0 <ayatsuri_model_instance_read_pose+0x70>
    3ebc:	eb d1                	jmp    3e8f <ayatsuri_model_instance_read_pose+0x5f>
    3ebe:	66 90                	xchg   %ax,%ax
    3ec0:	4c 89 c1             	mov    %r8,%rcx
    3ec3:	48 29 d1             	sub    %rdx,%rcx
    3ec6:	48 83 f9 7f          	cmp    $0x7f,%rcx
    3eca:	76 d4                	jbe    3ea0 <ayatsuri_model_instance_read_pose+0x70>
    3ecc:	48 8b 48 18          	mov    0x18(%rax),%rcx
    3ed0:	48 8b 70 08          	mov    0x8(%rax),%rsi
    3ed4:	48 85 c9             	test   %rcx,%rcx
    3ed7:	74 17                	je     3ef0 <ayatsuri_model_instance_read_pose+0xc0>
    3ed9:	4c 39 c6             	cmp    %r8,%rsi
    3edc:	72 72                	jb     3f50 <ayatsuri_model_instance_read_pose+0x120>
    3ede:	48 89 f1             	mov    %rsi,%rcx
    3ee1:	4c 29 c1             	sub    %r8,%rcx
    3ee4:	48 83 f9 23          	cmp    $0x23,%rcx
    3ee8:	76 b6                	jbe    3ea0 <ayatsuri_model_instance_read_pose+0x70>
    3eea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3ef0:	8b 4a 08             	mov    0x8(%rdx),%ecx
    3ef3:	48 85 c9             	test   %rcx,%rcx
    3ef6:	74 18                	je     3f10 <ayatsuri_model_instance_read_pose+0xe0>
    3ef8:	48 8b 12             	mov    (%rdx),%rdx
    3efb:	4c 39 c2             	cmp    %r8,%rdx
    3efe:	72 68                	jb     3f68 <ayatsuri_model_instance_read_pose+0x138>
    3f00:	4c 29 c2             	sub    %r8,%rdx
    3f03:	48 83 fa 23          	cmp    $0x23,%rdx
    3f07:	76 97                	jbe    3ea0 <ayatsuri_model_instance_read_pose+0x70>
    3f09:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3f10:	0f b7 cf             	movzwl %di,%ecx
    3f13:	48 8d 14 49          	lea    (%rcx,%rcx,2),%rdx
    3f17:	31 c9                	xor    %ecx,%ecx
    3f19:	8b 54 d6 08          	mov    0x8(%rsi,%rdx,8),%edx
    3f1d:	48 8d 54 16 30       	lea    0x30(%rsi,%rdx,1),%rdx
    3f22:	f3 0f 6f 02          	movdqu (%rdx),%xmm0
    3f26:	41 0f 11 00          	movups %xmm0,(%r8)
    3f2a:	f3 0f 6f 42 10       	movdqu 0x10(%rdx),%xmm0
    3f2f:	41 0f 11 40 10       	movups %xmm0,0x10(%r8)
    3f34:	8b 52 20             	mov    0x20(%rdx),%edx
    3f37:	41 89 50 20          	mov    %edx,0x20(%r8)
    3f3b:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    3f42:	e9 65 ff ff ff       	jmp    3eac <ayatsuri_model_instance_read_pose+0x7c>
    3f47:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    3f4e:	00 00 
    3f50:	4d 89 c1             	mov    %r8,%r9
    3f53:	49 29 f1             	sub    %rsi,%r9
    3f56:	49 39 c9             	cmp    %rcx,%r9
    3f59:	0f 82 41 ff ff ff    	jb     3ea0 <ayatsuri_model_instance_read_pose+0x70>
    3f5f:	eb 8f                	jmp    3ef0 <ayatsuri_model_instance_read_pose+0xc0>
    3f61:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3f68:	4d 89 c1             	mov    %r8,%r9
    3f6b:	49 29 d1             	sub    %rdx,%r9
    3f6e:	49 39 c9             	cmp    %rcx,%r9
    3f71:	73 9d                	jae    3f10 <ayatsuri_model_instance_read_pose+0xe0>
    3f73:	e9 28 ff ff ff       	jmp    3ea0 <ayatsuri_model_instance_read_pose+0x70>
    3f78:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    3f7f:	00 

0000000000003f80 <ayatsuri_model_instance_stats>:
    3f80:	48 89 f8             	mov    %rdi,%rax
    3f83:	bf 03 00 00 00       	mov    $0x3,%edi
    3f88:	48 85 c0             	test   %rax,%rax
    3f8b:	74 46                	je     3fd3 <ayatsuri_model_instance_stats+0x53>
    3f8d:	80 b8 a4 00 00 00 01 	cmpb   $0x1,0xa4(%rax)
    3f94:	75 3d                	jne    3fd3 <ayatsuri_model_instance_stats+0x53>
    3f96:	48 85 f6             	test   %rsi,%rsi
    3f99:	74 38                	je     3fd3 <ayatsuri_model_instance_stats+0x53>
    3f9b:	48 3b 70 10          	cmp    0x10(%rax),%rsi
    3f9f:	75 32                	jne    3fd3 <ayatsuri_model_instance_stats+0x53>
    3fa1:	3b 50 20             	cmp    0x20(%rax),%edx
    3fa4:	75 2d                	jne    3fd3 <ayatsuri_model_instance_stats+0x53>
    3fa6:	80 b8 a5 00 00 00 00 	cmpb   $0x0,0xa5(%rax)
    3fad:	bf 04 00 00 00       	mov    $0x4,%edi
    3fb2:	75 1f                	jne    3fd3 <ayatsuri_model_instance_stats+0x53>
    3fb4:	48 85 c9             	test   %rcx,%rcx
    3fb7:	0f 84 fb 00 00 00    	je     40b8 <ayatsuri_model_instance_stats+0x138>
    3fbd:	48 39 c8             	cmp    %rcx,%rax
    3fc0:	72 1e                	jb     3fe0 <ayatsuri_model_instance_stats+0x60>
    3fc2:	48 89 c2             	mov    %rax,%rdx
    3fc5:	bf 01 00 00 00       	mov    $0x1,%edi
    3fca:	48 29 ca             	sub    %rcx,%rdx
    3fcd:	48 83 fa 1b          	cmp    $0x1b,%rdx
    3fd1:	77 21                	ja     3ff4 <ayatsuri_model_instance_stats+0x74>
    3fd3:	89 f8                	mov    %edi,%eax
    3fd5:	c3                   	ret
    3fd6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    3fdd:	00 00 00 
    3fe0:	48 89 ca             	mov    %rcx,%rdx
    3fe3:	bf 01 00 00 00       	mov    $0x1,%edi
    3fe8:	48 29 c2             	sub    %rax,%rdx
    3feb:	48 81 fa a7 00 00 00 	cmp    $0xa7,%rdx
    3ff2:	76 df                	jbe    3fd3 <ayatsuri_model_instance_stats+0x53>
    3ff4:	48 8b 10             	mov    (%rax),%rdx
    3ff7:	48 39 ca             	cmp    %rcx,%rdx
    3ffa:	0f 83 98 00 00 00    	jae    4098 <ayatsuri_model_instance_stats+0x118>
    4000:	48 89 ce             	mov    %rcx,%rsi
    4003:	bf 01 00 00 00       	mov    $0x1,%edi
    4008:	48 29 d6             	sub    %rdx,%rsi
    400b:	48 83 fe 7f          	cmp    $0x7f,%rsi
    400f:	76 c2                	jbe    3fd3 <ayatsuri_model_instance_stats+0x53>
    4011:	48 8b 70 18          	mov    0x18(%rax),%rsi
    4015:	48 85 f6             	test   %rsi,%rsi
    4018:	74 26                	je     4040 <ayatsuri_model_instance_stats+0xc0>
    401a:	48 8b 78 08          	mov    0x8(%rax),%rdi
    401e:	48 39 cf             	cmp    %rcx,%rdi
    4021:	0f 82 99 00 00 00    	jb     40c0 <ayatsuri_model_instance_stats+0x140>
    4027:	48 29 cf             	sub    %rcx,%rdi
    402a:	48 89 fe             	mov    %rdi,%rsi
    402d:	bf 01 00 00 00       	mov    $0x1,%edi
    4032:	48 83 fe 1b          	cmp    $0x1b,%rsi
    4036:	76 9b                	jbe    3fd3 <ayatsuri_model_instance_stats+0x53>
    4038:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    403f:	00 
    4040:	8b 72 08             	mov    0x8(%rdx),%esi
    4043:	48 85 f6             	test   %rsi,%rsi
    4046:	74 28                	je     4070 <ayatsuri_model_instance_stats+0xf0>
    4048:	48 8b 12             	mov    (%rdx),%rdx
    404b:	48 39 ca             	cmp    %rcx,%rdx
    404e:	0f 82 8c 00 00 00    	jb     40e0 <ayatsuri_model_instance_stats+0x160>
    4054:	48 29 ca             	sub    %rcx,%rdx
    4057:	bf 01 00 00 00       	mov    $0x1,%edi
    405c:	48 83 fa 1b          	cmp    $0x1b,%rdx
    4060:	0f 86 6d ff ff ff    	jbe    3fd3 <ayatsuri_model_instance_stats+0x53>
    4066:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    406d:	00 00 00 
    4070:	f3 0f 6f 80 88 00 00 	movdqu 0x88(%rax),%xmm0
    4077:	00 
    4078:	31 ff                	xor    %edi,%edi
    407a:	0f 11 01             	movups %xmm0,(%rcx)
    407d:	f3 0f 6f 80 94 00 00 	movdqu 0x94(%rax),%xmm0
    4084:	00 
    4085:	0f 11 41 0c          	movups %xmm0,0xc(%rcx)
    4089:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    4090:	e9 3e ff ff ff       	jmp    3fd3 <ayatsuri_model_instance_stats+0x53>
    4095:	0f 1f 00             	nopl   (%rax)
    4098:	48 89 d6             	mov    %rdx,%rsi
    409b:	bf 01 00 00 00       	mov    $0x1,%edi
    40a0:	48 29 ce             	sub    %rcx,%rsi
    40a3:	48 83 fe 1b          	cmp    $0x1b,%rsi
    40a7:	0f 86 26 ff ff ff    	jbe    3fd3 <ayatsuri_model_instance_stats+0x53>
    40ad:	e9 5f ff ff ff       	jmp    4011 <ayatsuri_model_instance_stats+0x91>
    40b2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    40b8:	bf 01 00 00 00       	mov    $0x1,%edi
    40bd:	89 f8                	mov    %edi,%eax
    40bf:	c3                   	ret
    40c0:	49 89 c8             	mov    %rcx,%r8
    40c3:	49 29 f8             	sub    %rdi,%r8
    40c6:	bf 01 00 00 00       	mov    $0x1,%edi
    40cb:	49 39 f0             	cmp    %rsi,%r8
    40ce:	0f 82 ff fe ff ff    	jb     3fd3 <ayatsuri_model_instance_stats+0x53>
    40d4:	e9 67 ff ff ff       	jmp    4040 <ayatsuri_model_instance_stats+0xc0>
    40d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    40e0:	49 89 c8             	mov    %rcx,%r8
    40e3:	bf 01 00 00 00       	mov    $0x1,%edi
    40e8:	49 29 d0             	sub    %rdx,%r8
    40eb:	49 39 f0             	cmp    %rsi,%r8
    40ee:	0f 82 df fe ff ff    	jb     3fd3 <ayatsuri_model_instance_stats+0x53>
    40f4:	e9 77 ff ff ff       	jmp    4070 <ayatsuri_model_instance_stats+0xf0>
    40f9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000004100 <ayatsuri_model_instance_evaluate>:
    4100:	48 85 ff             	test   %rdi,%rdi
    4103:	0f 84 7f 01 00 00    	je     4288 <ayatsuri_model_instance_evaluate+0x188>
    4109:	41 57                	push   %r15
    410b:	b8 03 00 00 00       	mov    $0x3,%eax
    4110:	49 89 ff             	mov    %rdi,%r15
    4113:	41 56                	push   %r14
    4115:	41 55                	push   %r13
    4117:	41 54                	push   %r12
    4119:	55                   	push   %rbp
    411a:	53                   	push   %rbx
    411b:	48 81 ec 48 04 00 00 	sub    $0x448,%rsp
    4122:	80 bf a4 00 00 00 01 	cmpb   $0x1,0xa4(%rdi)
    4129:	0f 85 20 01 00 00    	jne    424f <ayatsuri_model_instance_evaluate+0x14f>
    412f:	48 85 f6             	test   %rsi,%rsi
    4132:	0f 84 17 01 00 00    	je     424f <ayatsuri_model_instance_evaluate+0x14f>
    4138:	48 3b 77 10          	cmp    0x10(%rdi),%rsi
    413c:	0f 85 0d 01 00 00    	jne    424f <ayatsuri_model_instance_evaluate+0x14f>
    4142:	3b 57 20             	cmp    0x20(%rdi),%edx
    4145:	0f 85 04 01 00 00    	jne    424f <ayatsuri_model_instance_evaluate+0x14f>
    414b:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    4152:	b8 04 00 00 00       	mov    $0x4,%eax
    4157:	0f 85 f2 00 00 00    	jne    424f <ayatsuri_model_instance_evaluate+0x14f>
    415d:	8b 87 88 00 00 00    	mov    0x88(%rdi),%eax
    4163:	31 d2                	xor    %edx,%edx
    4165:	c6 87 a5 00 00 00 01 	movb   $0x1,0xa5(%rdi)
    416c:	83 f8 ff             	cmp    $0xffffffff,%eax
    416f:	0f 95 c2             	setne  %dl
    4172:	01 d0                	add    %edx,%eax
    4174:	89 87 88 00 00 00    	mov    %eax,0x88(%rdi)
    417a:	48 85 c9             	test   %rcx,%rcx
    417d:	0f 84 bd 00 00 00    	je     4240 <ayatsuri_model_instance_evaluate+0x140>
    4183:	4d 85 c0             	test   %r8,%r8
    4186:	0f 84 b4 00 00 00    	je     4240 <ayatsuri_model_instance_evaluate+0x140>
    418c:	44 0f b6 8f a6 00 00 	movzbl 0xa6(%rdi),%r9d
    4193:	00 
    4194:	31 c0                	xor    %eax,%eax
    4196:	31 ff                	xor    %edi,%edi
    4198:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 41a1 <ayatsuri_model_instance_evaluate+0xa1>
    419f:	00 00 
			419d: R_X86_64_PC32	.LC1-0x4
    41a1:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 41aa <ayatsuri_model_instance_evaluate+0xaa>
    41a8:	00 00 
			41a6: R_X86_64_PC32	.LC0-0x4
    41aa:	44 89 ce             	mov    %r9d,%esi
    41ad:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    41b4:	00 00 00 00 
    41b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    41bf:	00 
    41c0:	f3 0f 10 04 01       	movss  (%rcx,%rax,1),%xmm0
    41c5:	0f 28 c8             	movaps %xmm0,%xmm1
    41c8:	41 0f 54 ca          	andps  %xmm10,%xmm1
    41cc:	44 0f 2e f1          	ucomiss %xmm1,%xmm14
    41d0:	72 6e                	jb     4240 <ayatsuri_model_instance_evaluate+0x140>
    41d2:	41 0f 2e 44 07 28    	ucomiss 0x28(%r15,%rax,1),%xmm0
    41d8:	0f 9b c2             	setnp  %dl
    41db:	0f 45 d7             	cmovne %edi,%edx
    41de:	48 83 c0 04          	add    $0x4,%rax
    41e2:	21 d6                	and    %edx,%esi
    41e4:	48 83 f8 24          	cmp    $0x24,%rax
    41e8:	75 d6                	jne    41c0 <ayatsuri_model_instance_evaluate+0xc0>
    41ea:	31 c0                	xor    %eax,%eax
    41ec:	f3 41 0f 10 0c 80    	movss  (%r8,%rax,4),%xmm1
    41f2:	0f 28 c1             	movaps %xmm1,%xmm0
    41f5:	41 0f 54 c2          	andps  %xmm10,%xmm0
    41f9:	44 0f 2e f0          	ucomiss %xmm0,%xmm14
    41fd:	72 41                	jb     4240 <ayatsuri_model_instance_evaluate+0x140>
    41ff:	48 83 f8 02          	cmp    $0x2,%rax
    4203:	76 63                	jbe    4268 <ayatsuri_model_instance_evaluate+0x168>
    4205:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4209:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 4211 <ayatsuri_model_instance_evaluate+0x111>
    4210:	00 
			420d: R_X86_64_PC32	.LC18-0x4
    4211:	f3 0f 5a c1          	cvtss2sd %xmm1,%xmm0
    4215:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 421d <ayatsuri_model_instance_evaluate+0x11d>
    421c:	00 
			4219: R_X86_64_PC32	.LC8-0x4
    421d:	66 0f 2e f8          	ucomisd %xmm0,%xmm7
    4221:	72 1d                	jb     4240 <ayatsuri_model_instance_evaluate+0x140>
    4223:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4227:	0f 2f c8             	comiss %xmm0,%xmm1
    422a:	72 14                	jb     4240 <ayatsuri_model_instance_evaluate+0x140>
    422c:	f3 0f 10 3d 00 00 00 	movss  0x0(%rip),%xmm7        # 4234 <ayatsuri_model_instance_evaluate+0x134>
    4233:	00 
			4230: R_X86_64_PC32	.LC17-0x4
    4234:	0f 2f f9             	comiss %xmm1,%xmm7
    4237:	73 57                	jae    4290 <ayatsuri_model_instance_evaluate+0x190>
    4239:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    4240:	31 d2                	xor    %edx,%edx
    4242:	66 41 89 97 a5 00 00 	mov    %dx,0xa5(%r15)
    4249:	00 
    424a:	b8 01 00 00 00       	mov    $0x1,%eax
    424f:	48 81 c4 48 04 00 00 	add    $0x448,%rsp
    4256:	5b                   	pop    %rbx
    4257:	5d                   	pop    %rbp
    4258:	41 5c                	pop    %r12
    425a:	41 5d                	pop    %r13
    425c:	41 5e                	pop    %r14
    425e:	41 5f                	pop    %r15
    4260:	c3                   	ret
    4261:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    4268:	41 0f 2e 4c 87 4c    	ucomiss 0x4c(%r15,%rax,4),%xmm1
    426e:	bf 00 00 00 00       	mov    $0x0,%edi
    4273:	0f 9b c2             	setnp  %dl
    4276:	0f 45 d7             	cmovne %edi,%edx
    4279:	48 83 c0 01          	add    $0x1,%rax
    427d:	21 d6                	and    %edx,%esi
    427f:	e9 68 ff ff ff       	jmp    41ec <ayatsuri_model_instance_evaluate+0xec>
    4284:	0f 1f 40 00          	nopl   0x0(%rax)
    4288:	b8 03 00 00 00       	mov    $0x3,%eax
    428d:	c3                   	ret
    428e:	66 90                	xchg   %ax,%ax
    4290:	41 0f 2e 4c 87 4c    	ucomiss 0x4c(%r15,%rax,4),%xmm1
    4296:	bf 00 00 00 00       	mov    $0x0,%edi
    429b:	0f 9b c2             	setnp  %dl
    429e:	0f 45 d7             	cmovne %edi,%edx
    42a1:	48 83 c0 01          	add    $0x1,%rax
    42a5:	21 d6                	and    %edx,%esi
    42a7:	48 83 f8 06          	cmp    $0x6,%rax
    42ab:	0f 85 3b ff ff ff    	jne    41ec <ayatsuri_model_instance_evaluate+0xec>
    42b1:	f3 0f 10 49 18       	movss  0x18(%rcx),%xmm1
    42b6:	0f 2f c8             	comiss %xmm0,%xmm1
    42b9:	76 85                	jbe    4240 <ayatsuri_model_instance_evaluate+0x140>
    42bb:	40 84 f6             	test   %sil,%sil
    42be:	0f 85 c2 1a 00 00    	jne    5d86 <ayatsuri_model_instance_evaluate+0x1c86>
    42c4:	49 8d 77 28          	lea    0x28(%r15),%rsi
    42c8:	45 84 c9             	test   %r9b,%r9b
    42cb:	74 18                	je     42e5 <ayatsuri_model_instance_evaluate+0x1e5>
    42cd:	48 8b 01             	mov    (%rcx),%rax
    42d0:	48 8b 51 08          	mov    0x8(%rcx),%rdx
    42d4:	49 33 47 28          	xor    0x28(%r15),%rax
    42d8:	49 33 57 30          	xor    0x30(%r15),%rdx
    42dc:	48 09 d0             	or     %rdx,%rax
    42df:	0f 84 1b 1e 00 00    	je     6100 <ayatsuri_model_instance_evaluate+0x2000>
    42e5:	41 c6 87 a6 00 00 00 	movb   $0x0,0xa6(%r15)
    42ec:	00 
    42ed:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
    42f1:	66 0f ef c9          	pxor   %xmm1,%xmm1
    42f5:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
    42fa:	41 0f 11 47 28       	movups %xmm0,0x28(%r15)
    42ff:	f3 0f 6f 41 10       	movdqu 0x10(%rcx),%xmm0
    4304:	0f 11 46 10          	movups %xmm0,0x10(%rsi)
    4308:	8b 41 20             	mov    0x20(%rcx),%eax
    430b:	89 46 20             	mov    %eax,0x20(%rsi)
    430e:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
    4313:	41 0f 11 47 4c       	movups %xmm0,0x4c(%r15)
    4318:	49 8b 40 10          	mov    0x10(%r8),%rax
    431c:	49 89 47 5c          	mov    %rax,0x5c(%r15)
    4320:	0f 5a 41 0c          	cvtps2pd 0xc(%rcx),%xmm0
    4324:	0f 5a 11             	cvtps2pd (%rcx),%xmm2
    4327:	66 0f 5c d0          	subpd  %xmm0,%xmm2
    432b:	66 0f ef c0          	pxor   %xmm0,%xmm0
    432f:	f3 0f 5a 41 14       	cvtss2sd 0x14(%rcx),%xmm0
    4334:	f3 0f 5a 49 08       	cvtss2sd 0x8(%rcx),%xmm1
    4339:	f2 0f 5c c8          	subsd  %xmm0,%xmm1
    433d:	66 0f 28 fa          	movapd %xmm2,%xmm7
    4341:	66 0f 15 ff          	unpckhpd %xmm7,%xmm7
    4345:	66 0f 28 c2          	movapd %xmm2,%xmm0
    4349:	0f 29 14 24          	movaps %xmm2,(%rsp)
    434d:	66 48 0f 7e cb       	movq   %xmm1,%rbx
    4352:	66 0f 28 cf          	movapd %xmm7,%xmm1
    4356:	e8 00 00 00 00       	call   435b <ayatsuri_model_instance_evaluate+0x25b>
			4357: R_X86_64_PLT32	hypot-0x4
    435b:	66 48 0f 6e cb       	movq   %rbx,%xmm1
    4360:	e8 00 00 00 00       	call   4365 <ayatsuri_model_instance_evaluate+0x265>
			4361: R_X86_64_PLT32	hypot-0x4
    4365:	66 0f ef c9          	pxor   %xmm1,%xmm1
    4369:	66 0f 28 14 24       	movapd (%rsp),%xmm2
    436e:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
    4373:	66 0f 2f c1          	comisd %xmm1,%xmm0
    4377:	0f 86 fc 19 00 00    	jbe    5d79 <ayatsuri_model_instance_evaluate+0x1c79>
    437d:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 4385 <ayatsuri_model_instance_evaluate+0x285>
    4384:	00 
			4381: R_X86_64_PC32	.LC18-0x4
    4385:	66 0f 2e f0          	ucomisd %xmm0,%xmm6
    4389:	0f 82 ea 19 00 00    	jb     5d79 <ayatsuri_model_instance_evaluate+0x1c79>
    438f:	66 0f 28 c8          	movapd %xmm0,%xmm1
    4393:	66 48 0f 6e db       	movq   %rbx,%xmm3
    4398:	4c 89 44 24 38       	mov    %r8,0x38(%rsp)
    439d:	f2 0f 5e d8          	divsd  %xmm0,%xmm3
    43a1:	66 0f 14 c9          	unpcklpd %xmm1,%xmm1
    43a5:	66 0f 5e d1          	divpd  %xmm1,%xmm2
    43a9:	66 0f 28 c3          	movapd %xmm3,%xmm0
    43ad:	f2 0f 11 1c 24       	movsd  %xmm3,(%rsp)
    43b2:	66 0f 28 ea          	movapd %xmm2,%xmm5
    43b6:	66 0f 28 ca          	movapd %xmm2,%xmm1
    43ba:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
    43bf:	66 0f 15 ed          	unpckhpd %xmm5,%xmm5
    43c3:	f2 0f 11 54 24 18    	movsd  %xmm2,0x18(%rsp)
    43c9:	f2 0f 11 6c 24 30    	movsd  %xmm5,0x30(%rsp)
    43cf:	e8 00 00 00 00       	call   43d4 <ayatsuri_model_instance_evaluate+0x2d4>
			43d0: R_X86_64_PLT32	hypot-0x4
    43d4:	f2 0f 10 1c 24       	movsd  (%rsp),%xmm3
    43d9:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
    43de:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 43e7 <ayatsuri_model_instance_evaluate+0x2e7>
    43e5:	00 00 
			43e3: R_X86_64_PC32	.LC0-0x4
    43e7:	f2 0f 10 15 00 00 00 	movsd  0x0(%rip),%xmm2        # 43ef <ayatsuri_model_instance_evaluate+0x2ef>
    43ee:	00 
			43eb: R_X86_64_PC32	.LC37-0x4
    43ef:	f2 0f 10 4c 24 18    	movsd  0x18(%rsp),%xmm1
    43f5:	66 0f 28 64 24 20    	movapd 0x20(%rsp),%xmm4
    43fb:	f2 0f 10 6c 24 30    	movsd  0x30(%rsp),%xmm5
    4401:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 440a <ayatsuri_model_instance_evaluate+0x30a>
    4408:	00 00 
			4406: R_X86_64_PC32	.LC1-0x4
    440a:	66 0f 2f d0          	comisd %xmm0,%xmm2
    440e:	0f 87 3b 1e 00 00    	ja     624f <ayatsuri_model_instance_evaluate+0x214f>
    4414:	66 0f 28 f3          	movapd %xmm3,%xmm6
    4418:	f3 0f 7e 3d 00 00 00 	movq   0x0(%rip),%xmm7        # 4420 <ayatsuri_model_instance_evaluate+0x320>
    441f:	00 
			441c: R_X86_64_PC32	.LC26-0x4
    4420:	66 44 0f 28 c3       	movapd %xmm3,%xmm8
    4425:	66 0f ef d2          	pxor   %xmm2,%xmm2
    4429:	f2 0f 5e f0          	divsd  %xmm0,%xmm6
    442d:	0f 29 bc 24 80 00 00 	movaps %xmm7,0x80(%rsp)
    4434:	00 
    4435:	66 0f 57 f9          	xorpd  %xmm1,%xmm7
    4439:	f2 0f 5e f8          	divsd  %xmm0,%xmm7
    443d:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4441:	f2 44 0f 59 c6       	mulsd  %xmm6,%xmm8
    4446:	f2 0f 5a d6          	cvtsd2ss %xmm6,%xmm2
    444a:	f2 0f 5a c7          	cvtsd2ss %xmm7,%xmm0
    444e:	f2 0f 59 cf          	mulsd  %xmm7,%xmm1
    4452:	66 0f 5a e4          	cvtpd2ps %xmm4,%xmm4
    4456:	49 8b 07             	mov    (%r15),%rax
    4459:	f2 0f 5a db          	cvtsd2ss %xmm3,%xmm3
    445d:	f3 0f 11 84 24 ec 01 	movss  %xmm0,0x1ec(%rsp)
    4464:	00 00 
    4466:	66 0f 28 c5          	movapd %xmm5,%xmm0
    446a:	66 0f 57 ac 24 80 00 	xorpd  0x80(%rsp),%xmm5
    4471:	00 00 
    4473:	f2 0f 59 c7          	mulsd  %xmm7,%xmm0
    4477:	66 83 78 0c 00       	cmpw   $0x0,0xc(%rax)
    447c:	0f 13 a4 24 c8 01 00 	movlps %xmm4,0x1c8(%rsp)
    4483:	00 
    4484:	c7 84 24 e8 01 00 00 	movl   $0x0,0x1e8(%rsp)
    448b:	00 00 00 00 
    448f:	f3 0f 11 9c 24 d0 01 	movss  %xmm3,0x1d0(%rsp)
    4496:	00 00 
    4498:	f3 0f 11 94 24 e4 01 	movss  %xmm2,0x1e4(%rsp)
    449f:	00 00 
    44a1:	f2 44 0f 5c c1       	subsd  %xmm1,%xmm8
    44a6:	66 41 0f 14 c0       	unpcklpd %xmm8,%xmm0
    44ab:	66 0f 5a c0          	cvtpd2ps %xmm0,%xmm0
    44af:	0f 13 84 24 d8 01 00 	movlps %xmm0,0x1d8(%rsp)
    44b6:	00 
    44b7:	66 0f 28 c5          	movapd %xmm5,%xmm0
    44bb:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
    44bf:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    44c3:	f3 0f 11 84 24 e0 01 	movss  %xmm0,0x1e0(%rsp)
    44ca:	00 00 
    44cc:	f3 41 0f 10 00       	movss  (%r8),%xmm0
    44d1:	f3 41 0f 11 67 70    	movss  %xmm4,0x70(%r15)
    44d7:	0f c6 e4 e5          	shufps $0xe5,%xmm4,%xmm4
    44db:	f3 41 0f 11 47 64    	movss  %xmm0,0x64(%r15)
    44e1:	f3 41 0f 10 40 0c    	movss  0xc(%r8),%xmm0
    44e7:	f3 41 0f 11 47 7c    	movss  %xmm0,0x7c(%r15)
    44ed:	f3 41 0f 10 40 04    	movss  0x4(%r8),%xmm0
    44f3:	f3 41 0f 11 67 74    	movss  %xmm4,0x74(%r15)
    44f9:	f3 41 0f 11 47 68    	movss  %xmm0,0x68(%r15)
    44ff:	f3 41 0f 10 40 10    	movss  0x10(%r8),%xmm0
    4505:	f3 41 0f 11 87 80 00 	movss  %xmm0,0x80(%r15)
    450c:	00 00 
    450e:	f3 41 0f 10 40 08    	movss  0x8(%r8),%xmm0
    4514:	f3 41 0f 11 5f 78    	movss  %xmm3,0x78(%r15)
    451a:	f3 41 0f 11 47 6c    	movss  %xmm0,0x6c(%r15)
    4520:	f3 41 0f 10 40 14    	movss  0x14(%r8),%xmm0
    4526:	f3 41 0f 11 87 84 00 	movss  %xmm0,0x84(%r15)
    452d:	00 00 
    452f:	0f 84 1d 06 00 00    	je     4b52 <ayatsuri_model_instance_evaluate+0xa52>
    4535:	48 8d 8c 24 d8 01 00 	lea    0x1d8(%rsp),%rcx
    453c:	00 
    453d:	48 8d 9c 24 e4 01 00 	lea    0x1e4(%rsp),%rbx
    4544:	00 
    4545:	45 31 ed             	xor    %r13d,%r13d
    4548:	48 89 8c 24 78 01 00 	mov    %rcx,0x178(%rsp)
    454f:	00 
    4550:	66 48 0f 6e fb       	movq   %rbx,%xmm7
    4555:	4d 89 ea             	mov    %r13,%r10
    4558:	4c 8d b4 24 50 02 00 	lea    0x250(%rsp),%r14
    455f:	00 
    4560:	48 89 9c 24 80 01 00 	mov    %rbx,0x180(%rsp)
    4567:	00 
    4568:	48 8d 9c 24 5c 02 00 	lea    0x25c(%rsp),%rbx
    456f:	00 
    4570:	4d 89 f3             	mov    %r14,%r11
    4573:	48 89 5c 24 78       	mov    %rbx,0x78(%rsp)
    4578:	0f 16 bc 24 78 01 00 	movhps 0x178(%rsp),%xmm7
    457f:	00 
    4580:	0f 29 bc 24 a0 01 00 	movaps %xmm7,0x1a0(%rsp)
    4587:	00 
    4588:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    458f:	00 
    4590:	44 8b 60 14          	mov    0x14(%rax),%r12d
    4594:	49 8b 6f 08          	mov    0x8(%r15),%rbp
    4598:	4c 89 d1             	mov    %r10,%rcx
    459b:	4f 8d 04 52          	lea    (%r10,%r10,2),%r8
    459f:	48 c1 e1 04          	shl    $0x4,%rcx
    45a3:	4a 8d 14 c5 00 00 00 	lea    0x0(,%r8,8),%rdx
    45aa:	00 
    45ab:	44 89 54 24 18       	mov    %r10d,0x18(%rsp)
    45b0:	49 01 cc             	add    %rcx,%r12
    45b3:	4c 03 20             	add    (%rax),%r12
    45b6:	48 8d 44 15 00       	lea    0x0(%rbp,%rdx,1),%rax
    45bb:	8b 78 08             	mov    0x8(%rax),%edi
    45be:	41 0f b7 34 24       	movzwl (%r12),%esi
    45c3:	48 8d 7c 3d 30       	lea    0x30(%rbp,%rdi,1),%rdi
    45c8:	66 85 f6             	test   %si,%si
    45cb:	0f 88 9f 05 00 00    	js     4b70 <ayatsuri_model_instance_evaluate+0xa70>
    45d1:	f3 0f 6f 07          	movdqu (%rdi),%xmm0
    45d5:	44 0f b7 ce          	movzwl %si,%r9d
    45d9:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
    45dd:	48 8d 9c 24 80 02 00 	lea    0x280(%rsp),%rbx
    45e4:	00 
    45e5:	8b 74 f5 08          	mov    0x8(%rbp,%rsi,8),%esi
    45e9:	41 0f 29 03          	movaps %xmm0,(%r11)
    45ed:	f3 0f 6f 47 10       	movdqu 0x10(%rdi),%xmm0
    45f2:	48 01 ee             	add    %rbp,%rsi
    45f5:	41 0f 29 43 10       	movaps %xmm0,0x10(%r11)
    45fa:	f3 0f 6f 06          	movdqu (%rsi),%xmm0
    45fe:	8b 7f 20             	mov    0x20(%rdi),%edi
    4601:	0f 29 84 24 80 02 00 	movaps %xmm0,0x280(%rsp)
    4608:	00 
    4609:	f3 0f 6f 46 10       	movdqu 0x10(%rsi),%xmm0
    460e:	41 89 7b 20          	mov    %edi,0x20(%r11)
    4612:	0f 29 84 24 90 02 00 	movaps %xmm0,0x290(%rsp)
    4619:	00 
    461a:	f3 0f 6f 46 20       	movdqu 0x20(%rsi),%xmm0
    461f:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
    4626:	00 
    4627:	48 8b 7c 24 78       	mov    0x78(%rsp),%rdi
    462c:	4c 89 de             	mov    %r11,%rsi
    462f:	66 0f ef d2          	pxor   %xmm2,%xmm2
    4633:	f3 0f 10 06          	movss  (%rsi),%xmm0
    4637:	41 0f 54 c2          	andps  %xmm10,%xmm0
    463b:	44 0f 2e f0          	ucomiss %xmm0,%xmm14
    463f:	0f 82 9b 16 00 00    	jb     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    4645:	f3 0f 10 46 0c       	movss  0xc(%rsi),%xmm0
    464a:	41 0f 54 c2          	andps  %xmm10,%xmm0
    464e:	44 0f 2e f0          	ucomiss %xmm0,%xmm14
    4652:	0f 82 88 16 00 00    	jb     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    4658:	f3 0f 10 46 18       	movss  0x18(%rsi),%xmm0
    465d:	0f 28 c8             	movaps %xmm0,%xmm1
    4660:	41 0f 54 ca          	andps  %xmm10,%xmm1
    4664:	44 0f 2e f1          	ucomiss %xmm1,%xmm14
    4668:	0f 82 72 16 00 00    	jb     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    466e:	0f 2e c2             	ucomiss %xmm2,%xmm0
    4671:	7a 06                	jp     4679 <ayatsuri_model_instance_evaluate+0x579>
    4673:	0f 84 67 16 00 00    	je     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    4679:	48 83 c6 04          	add    $0x4,%rsi
    467d:	48 39 f7             	cmp    %rsi,%rdi
    4680:	75 b1                	jne    4633 <ayatsuri_model_instance_evaluate+0x533>
    4682:	48 85 db             	test   %rbx,%rbx
    4685:	74 34                	je     46bb <ayatsuri_model_instance_evaluate+0x5bb>
    4687:	48 89 de             	mov    %rbx,%rsi
    468a:	48 8d 7b 30          	lea    0x30(%rbx),%rdi
    468e:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    4695:	00 00 00 00 
    4699:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    46a0:	f3 0f 10 06          	movss  (%rsi),%xmm0
    46a4:	41 0f 54 c2          	andps  %xmm10,%xmm0
    46a8:	44 0f 2e f0          	ucomiss %xmm0,%xmm14
    46ac:	0f 82 2e 16 00 00    	jb     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    46b2:	48 83 c6 04          	add    $0x4,%rsi
    46b6:	48 39 f7             	cmp    %rsi,%rdi
    46b9:	75 e5                	jne    46a0 <ayatsuri_model_instance_evaluate+0x5a0>
    46bb:	4c 8d ac 24 b8 01 00 	lea    0x1b8(%rsp),%r13
    46c2:	00 
    46c3:	66 0f ef c0          	pxor   %xmm0,%xmm0
    46c7:	4c 89 5c 24 70       	mov    %r11,0x70(%rsp)
    46cc:	4c 8d b4 24 b0 01 00 	lea    0x1b0(%rsp),%r14
    46d3:	00 
    46d4:	4c 89 f6             	mov    %r14,%rsi
    46d7:	4c 89 ef             	mov    %r13,%rdi
    46da:	4c 89 54 24 68       	mov    %r10,0x68(%rsp)
    46df:	f3 0f 5a 84 24 5c 02 	cvtss2sd 0x25c(%rsp),%xmm0
    46e6:	00 00 
    46e8:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
    46ed:	4c 89 44 24 58       	mov    %r8,0x58(%rsp)
    46f2:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
    46f7:	44 89 4c 24 48       	mov    %r9d,0x48(%rsp)
    46fc:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
    4701:	e8 00 00 00 00       	call   4706 <ayatsuri_model_instance_evaluate+0x606>
			4702: R_X86_64_PLT32	sincos-0x4
    4706:	4c 89 f6             	mov    %r14,%rsi
    4709:	4c 89 ef             	mov    %r13,%rdi
    470c:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4710:	f2 0f 10 94 24 b0 01 	movsd  0x1b0(%rsp),%xmm2
    4717:	00 00 
    4719:	f2 44 0f 10 8c 24 b8 	movsd  0x1b8(%rsp),%xmm9
    4720:	01 00 00 
    4723:	f3 0f 5a 84 24 60 02 	cvtss2sd 0x260(%rsp),%xmm0
    472a:	00 00 
    472c:	f2 0f 11 54 24 38    	movsd  %xmm2,0x38(%rsp)
    4732:	f2 44 0f 11 4c 24 30 	movsd  %xmm9,0x30(%rsp)
    4739:	e8 00 00 00 00       	call   473e <ayatsuri_model_instance_evaluate+0x63e>
			473a: R_X86_64_PLT32	sincos-0x4
    473e:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4742:	4c 89 f6             	mov    %r14,%rsi
    4745:	4c 89 ef             	mov    %r13,%rdi
    4748:	f2 0f 10 bc 24 b0 01 	movsd  0x1b0(%rsp),%xmm7
    474f:	00 00 
    4751:	f2 0f 10 a4 24 b8 01 	movsd  0x1b8(%rsp),%xmm4
    4758:	00 00 
    475a:	f3 0f 5a 84 24 64 02 	cvtss2sd 0x264(%rsp),%xmm0
    4761:	00 00 
    4763:	f2 0f 11 7c 24 20    	movsd  %xmm7,0x20(%rsp)
    4769:	f2 0f 11 24 24       	movsd  %xmm4,(%rsp)
    476e:	e8 00 00 00 00       	call   4773 <ayatsuri_model_instance_evaluate+0x673>
			476f: R_X86_64_PLT32	sincos-0x4
    4773:	f2 0f 10 24 24       	movsd  (%rsp),%xmm4
    4778:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    477d:	f2 0f 10 84 24 b0 01 	movsd  0x1b0(%rsp),%xmm0
    4784:	00 00 
    4786:	f2 44 0f 10 4c 24 30 	movsd  0x30(%rsp),%xmm9
    478d:	f2 0f 10 54 24 38    	movsd  0x38(%rsp),%xmm2
    4793:	48 85 db             	test   %rbx,%rbx
    4796:	44 0f 5a 9c 24 68 02 	cvtps2pd 0x268(%rsp),%xmm11
    479d:	00 00 
    479f:	66 0f 28 dc          	movapd %xmm4,%xmm3
    47a3:	f2 0f 10 7c 24 20    	movsd  0x20(%rsp),%xmm7
    47a9:	f2 0f 10 8c 24 b8 01 	movsd  0x1b8(%rsp),%xmm1
    47b0:	00 00 
    47b2:	f3 44 0f 5a a4 24 68 	cvtss2sd 0x268(%rsp),%xmm12
    47b9:	02 00 00 
    47bc:	f2 0f 59 d8          	mulsd  %xmm0,%xmm3
    47c0:	66 41 0f 28 f1       	movapd %xmm9,%xmm6
    47c5:	66 44 0f 28 c2       	movapd %xmm2,%xmm8
    47ca:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
    47cf:	f2 44 0f 59 c1       	mulsd  %xmm1,%xmm8
    47d4:	66 0f 28 ef          	movapd %xmm7,%xmm5
    47d8:	66 45 0f 28 e9       	movapd %xmm9,%xmm13
    47dd:	4c 63 4c 24 48       	movslq 0x48(%rsp),%r9
    47e2:	f2 0f 59 e8          	mulsd  %xmm0,%xmm5
    47e6:	66 44 0f 28 fa       	movapd %xmm2,%xmm15
    47eb:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
    47f0:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
    47f5:	f2 44 0f 59 f8       	mulsd  %xmm0,%xmm15
    47fa:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
    47ff:	4c 8b 54 24 68       	mov    0x68(%rsp),%r10
    4804:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 480d <ayatsuri_model_instance_evaluate+0x70d>
    480b:	00 00 
			4809: R_X86_64_PC32	.LC0-0x4
    480d:	f2 41 0f 59 c1       	mulsd  %xmm9,%xmm0
    4812:	4c 8b 5c 24 70       	mov    0x70(%rsp),%r11
    4817:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 4820 <ayatsuri_model_instance_evaluate+0x720>
    481e:	00 00 
			481c: R_X86_64_PC32	.LC1-0x4
    4820:	f2 0f 59 f3          	mulsd  %xmm3,%xmm6
    4824:	f2 0f 59 da          	mulsd  %xmm2,%xmm3
    4828:	f2 41 0f 59 ec       	mulsd  %xmm12,%xmm5
    482d:	f2 41 0f 5c f0       	subsd  %xmm8,%xmm6
    4832:	66 45 0f 28 c3       	movapd %xmm11,%xmm8
    4837:	66 45 0f 15 c0       	unpckhpd %xmm8,%xmm8
    483c:	f2 41 0f 59 f0       	mulsd  %xmm8,%xmm6
    4841:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    4846:	f3 44 0f 5a 84 24 70 	cvtss2sd 0x270(%rsp),%xmm8
    484d:	02 00 00 
    4850:	66 0f 14 ee          	unpcklpd %xmm6,%xmm5
    4854:	66 41 0f 28 f1       	movapd %xmm9,%xmm6
    4859:	f2 0f 59 f1          	mulsd  %xmm1,%xmm6
    485d:	f2 0f 58 de          	addsd  %xmm6,%xmm3
    4861:	66 0f 28 f7          	movapd %xmm7,%xmm6
    4865:	f2 0f 59 f1          	mulsd  %xmm1,%xmm6
    4869:	f2 0f 59 cc          	mulsd  %xmm4,%xmm1
    486d:	66 0f 57 a4 24 80 00 	xorpd  0x80(%rsp),%xmm4
    4874:	00 00 
    4876:	f2 41 0f 59 d8       	mulsd  %xmm8,%xmm3
    487b:	f2 44 0f 59 e9       	mulsd  %xmm1,%xmm13
    4880:	f2 0f 59 ca          	mulsd  %xmm2,%xmm1
    4884:	f2 0f 59 d7          	mulsd  %xmm7,%xmm2
    4888:	f2 45 0f 58 ef       	addsd  %xmm15,%xmm13
    488d:	f2 0f 5c c8          	subsd  %xmm0,%xmm1
    4891:	66 41 0f 28 c1       	movapd %xmm9,%xmm0
    4896:	66 45 0f ef c9       	pxor   %xmm9,%xmm9
    489b:	f3 44 0f 5a 8c 24 58 	cvtss2sd 0x258(%rsp),%xmm9
    48a2:	02 00 00 
    48a5:	f2 0f 59 c7          	mulsd  %xmm7,%xmm0
    48a9:	66 0f ef ff          	pxor   %xmm7,%xmm7
    48ad:	f3 0f 5a bc 24 50 02 	cvtss2sd 0x250(%rsp),%xmm7
    48b4:	00 00 
    48b6:	f2 41 0f 59 d0       	mulsd  %xmm8,%xmm2
    48bb:	f2 41 0f 59 c8       	mulsd  %xmm8,%xmm1
    48c0:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    48c5:	f3 44 0f 5a 84 24 54 	cvtss2sd 0x254(%rsp),%xmm8
    48cc:	02 00 00 
    48cf:	0f 84 23 14 00 00    	je     5cf8 <ayatsuri_model_instance_evaluate+0x1bf8>
    48d5:	66 41 0f 14 f5       	unpcklpd %xmm13,%xmm6
    48da:	66 0f 14 e0          	unpcklpd %xmm0,%xmm4
    48de:	4c 8d ac 24 90 03 00 	lea    0x390(%rsp),%r13
    48e5:	00 
    48e6:	66 41 0f 59 f3       	mulpd  %xmm11,%xmm6
    48eb:	4c 89 ee             	mov    %r13,%rsi
    48ee:	48 8d 7b 30          	lea    0x30(%rbx),%rdi
    48f2:	66 41 0f 59 e3       	mulpd  %xmm11,%xmm4
    48f7:	66 0f ef c0          	pxor   %xmm0,%xmm0
    48fb:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    4900:	48 83 c3 10          	add    $0x10,%rbx
    4904:	48 83 c6 20          	add    $0x20,%rsi
    4908:	f3 0f 5a 43 f0       	cvtss2sd -0x10(%rbx),%xmm0
    490d:	f3 44 0f 5a 63 f4    	cvtss2sd -0xc(%rbx),%xmm12
    4913:	66 44 0f 28 e8       	movapd %xmm0,%xmm13
    4918:	66 45 0f 28 fc       	movapd %xmm12,%xmm15
    491d:	66 45 0f 14 ed       	unpcklpd %xmm13,%xmm13
    4922:	66 45 0f 14 ff       	unpcklpd %xmm15,%xmm15
    4927:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    492c:	66 44 0f 59 fe       	mulpd  %xmm6,%xmm15
    4931:	f3 44 0f 5a 5b f8    	cvtss2sd -0x8(%rbx),%xmm11
    4937:	66 44 0f 59 ed       	mulpd  %xmm5,%xmm13
    493c:	66 45 0f 58 ef       	addpd  %xmm15,%xmm13
    4941:	66 45 0f 28 fb       	movapd %xmm11,%xmm15
    4946:	66 45 0f 14 ff       	unpcklpd %xmm15,%xmm15
    494b:	66 44 0f 59 fc       	mulpd  %xmm4,%xmm15
    4950:	66 45 0f 58 ef       	addpd  %xmm15,%xmm13
    4955:	66 44 0f 28 f9       	movapd %xmm1,%xmm15
    495a:	f2 45 0f 59 fc       	mulsd  %xmm12,%xmm15
    495f:	f2 45 0f 59 e0       	mulsd  %xmm8,%xmm12
    4964:	44 0f 29 6e e0       	movaps %xmm13,-0x20(%rsi)
    4969:	66 44 0f 28 eb       	movapd %xmm3,%xmm13
    496e:	f2 44 0f 59 e8       	mulsd  %xmm0,%xmm13
    4973:	f2 0f 59 c7          	mulsd  %xmm7,%xmm0
    4977:	f2 45 0f 58 ef       	addsd  %xmm15,%xmm13
    497c:	66 44 0f 28 fa       	movapd %xmm2,%xmm15
    4981:	f2 45 0f 59 fb       	mulsd  %xmm11,%xmm15
    4986:	f2 41 0f 58 c4       	addsd  %xmm12,%xmm0
    498b:	f2 45 0f 59 d9       	mulsd  %xmm9,%xmm11
    4990:	f2 45 0f 58 ef       	addsd  %xmm15,%xmm13
    4995:	f2 41 0f 58 c3       	addsd  %xmm11,%xmm0
    499a:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    499f:	f3 44 0f 5a 5b fc    	cvtss2sd -0x4(%rbx),%xmm11
    49a5:	f2 44 0f 11 6e f0    	movsd  %xmm13,-0x10(%rsi)
    49ab:	f2 41 0f 58 c3       	addsd  %xmm11,%xmm0
    49b0:	f2 0f 11 46 f8       	movsd  %xmm0,-0x8(%rsi)
    49b5:	48 39 df             	cmp    %rbx,%rdi
    49b8:	0f 85 39 ff ff ff    	jne    48f7 <ayatsuri_model_instance_evaluate+0x7f7>
    49be:	31 f6                	xor    %esi,%esi
    49c0:	66 0f ef d2          	pxor   %xmm2,%xmm2
    49c4:	eb 33                	jmp    49f9 <ayatsuri_model_instance_evaluate+0x8f9>
    49c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    49cd:	00 00 00 
    49d0:	66 0f 2f d1          	comisd %xmm1,%xmm2
    49d4:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 49dc <ayatsuri_model_instance_evaluate+0x8dc>
    49db:	00 
			49d8: R_X86_64_PC32	.LC33-0x4
    49dc:	77 04                	ja     49e2 <ayatsuri_model_instance_evaluate+0x8e2>
    49de:	41 0f 28 c6          	movaps %xmm14,%xmm0
    49e2:	48 8d 9c 24 30 03 00 	lea    0x330(%rsp),%rbx
    49e9:	00 
    49ea:	f3 0f 11 04 b3       	movss  %xmm0,(%rbx,%rsi,4)
    49ef:	48 83 c6 01          	add    $0x1,%rsi
    49f3:	48 83 fe 0c          	cmp    $0xc,%rsi
    49f7:	74 47                	je     4a40 <ayatsuri_model_instance_evaluate+0x940>
    49f9:	f2 41 0f 10 4c f5 00 	movsd  0x0(%r13,%rsi,8),%xmm1
    4a00:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 4a08 <ayatsuri_model_instance_evaluate+0x908>
    4a07:	00 
			4a04: R_X86_64_PC32	.LC18-0x4
    4a08:	66 0f 28 c1          	movapd %xmm1,%xmm0
    4a0c:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 4a14 <ayatsuri_model_instance_evaluate+0x914>
    4a13:	00 
			4a10: R_X86_64_PC32	.LC8-0x4
    4a14:	66 0f 2e e8          	ucomisd %xmm0,%xmm5
    4a18:	0f 82 c2 12 00 00    	jb     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    4a1e:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 4a26 <ayatsuri_model_instance_evaluate+0x926>
    4a25:	00 
			4a22: R_X86_64_PC32	.LC38-0x4
    4a26:	0f 83 b4 12 00 00    	jae    5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    4a2c:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 4a34 <ayatsuri_model_instance_evaluate+0x934>
    4a33:	00 
			4a30: R_X86_64_PC32	.LC39-0x4
    4a34:	77 9a                	ja     49d0 <ayatsuri_model_instance_evaluate+0x8d0>
    4a36:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4a3a:	f2 0f 5a c1          	cvtsd2ss %xmm1,%xmm0
    4a3e:	eb a2                	jmp    49e2 <ayatsuri_model_instance_evaluate+0x8e2>
    4a40:	66 0f 6f 84 24 30 03 	movdqa 0x330(%rsp),%xmm0
    4a47:	00 00 
    4a49:	41 8b b7 8c 00 00 00 	mov    0x8c(%r15),%esi
    4a50:	31 ff                	xor    %edi,%edi
    4a52:	0f 29 84 24 b0 02 00 	movaps %xmm0,0x2b0(%rsp)
    4a59:	00 
    4a5a:	83 fe ff             	cmp    $0xffffffff,%esi
    4a5d:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
    4a64:	00 00 
    4a66:	40 0f 95 c7          	setne  %dil
    4a6a:	0f 29 84 24 c0 02 00 	movaps %xmm0,0x2c0(%rsp)
    4a71:	00 
    4a72:	01 fe                	add    %edi,%esi
    4a74:	66 0f 6f 84 24 50 03 	movdqa 0x350(%rsp),%xmm0
    4a7b:	00 00 
    4a7d:	41 89 b7 8c 00 00 00 	mov    %esi,0x8c(%r15)
    4a84:	0f 29 84 24 d0 02 00 	movaps %xmm0,0x2d0(%rsp)
    4a8b:	00 
    4a8c:	8b 40 08             	mov    0x8(%rax),%eax
    4a8f:	66 0f 6f 84 24 b0 02 	movdqa 0x2b0(%rsp),%xmm0
    4a96:	00 00 
    4a98:	48 01 c5             	add    %rax,%rbp
    4a9b:	0f 11 45 00          	movups %xmm0,0x0(%rbp)
    4a9f:	66 0f 6f 84 24 c0 02 	movdqa 0x2c0(%rsp),%xmm0
    4aa6:	00 00 
    4aa8:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
    4aac:	66 0f 6f 84 24 d0 02 	movdqa 0x2d0(%rsp),%xmm0
    4ab3:	00 00 
    4ab5:	0f 11 45 20          	movups %xmm0,0x20(%rbp)
    4ab9:	49 8b 47 08          	mov    0x8(%r15),%rax
    4abd:	48 8d 34 10          	lea    (%rax,%rdx,1),%rsi
    4ac1:	0f b6 7e 10          	movzbl 0x10(%rsi),%edi
    4ac5:	40 84 ff             	test   %dil,%dil
    4ac8:	74 17                	je     4ae1 <ayatsuri_model_instance_evaluate+0x9e1>
    4aca:	bf 01 00 00 00       	mov    $0x1,%edi
    4acf:	45 85 c9             	test   %r9d,%r9d
    4ad2:	78 0d                	js     4ae1 <ayatsuri_model_instance_evaluate+0x9e1>
    4ad4:	4b 8d 3c 49          	lea    (%r9,%r9,2),%rdi
    4ad8:	80 7c f8 11 00       	cmpb   $0x0,0x11(%rax,%rdi,8)
    4add:	40 0f 95 c7          	setne  %dil
    4ae1:	40 88 7e 11          	mov    %dil,0x11(%rsi)
    4ae5:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    4aeb:	40 80 ff 01          	cmp    $0x1,%dil
    4aef:	0f 84 ab 00 00 00    	je     4ba0 <ayatsuri_model_instance_evaluate+0xaa0>
    4af5:	40 80 ff 02          	cmp    $0x2,%dil
    4af9:	0f 84 01 09 00 00    	je     5400 <ayatsuri_model_instance_evaluate+0x1300>
    4aff:	40 80 ff 03          	cmp    $0x3,%dil
    4b03:	0f 84 97 08 00 00    	je     53a0 <ayatsuri_model_instance_evaluate+0x12a0>
    4b09:	40 84 ff             	test   %dil,%dil
    4b0c:	74 30                	je     4b3e <ayatsuri_model_instance_evaluate+0xa3e>
    4b0e:	41 8b 87 90 00 00 00 	mov    0x90(%r15),%eax
    4b15:	31 d2                	xor    %edx,%edx
    4b17:	83 f8 ff             	cmp    $0xffffffff,%eax
    4b1a:	0f 95 c2             	setne  %dl
    4b1d:	01 d0                	add    %edx,%eax
    4b1f:	31 d2                	xor    %edx,%edx
    4b21:	41 89 87 90 00 00 00 	mov    %eax,0x90(%r15)
    4b28:	41 8b 87 94 00 00 00 	mov    0x94(%r15),%eax
    4b2f:	83 f8 ff             	cmp    $0xffffffff,%eax
    4b32:	0f 95 c2             	setne  %dl
    4b35:	01 d0                	add    %edx,%eax
    4b37:	41 89 87 94 00 00 00 	mov    %eax,0x94(%r15)
    4b3e:	49 8b 07             	mov    (%r15),%rax
    4b41:	49 83 c2 01          	add    $0x1,%r10
    4b45:	0f b7 50 0c          	movzwl 0xc(%rax),%edx
    4b49:	41 39 d2             	cmp    %edx,%r10d
    4b4c:	0f 82 3e fa ff ff    	jb     4590 <ayatsuri_model_instance_evaluate+0x490>
    4b52:	b8 00 01 00 00       	mov    $0x100,%eax
    4b57:	66 41 89 87 a5 00 00 	mov    %ax,0xa5(%r15)
    4b5e:	00 
    4b5f:	31 c0                	xor    %eax,%eax
    4b61:	e9 e9 f6 ff ff       	jmp    424f <ayatsuri_model_instance_evaluate+0x14f>
    4b66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    4b6d:	00 00 00 
    4b70:	f3 0f 6f 07          	movdqu (%rdi),%xmm0
    4b74:	41 89 f1             	mov    %esi,%r9d
    4b77:	31 db                	xor    %ebx,%ebx
    4b79:	41 81 c9 00 00 ff ff 	or     $0xffff0000,%r9d
    4b80:	41 0f 29 03          	movaps %xmm0,(%r11)
    4b84:	f3 0f 6f 47 10       	movdqu 0x10(%rdi),%xmm0
    4b89:	41 0f 29 43 10       	movaps %xmm0,0x10(%r11)
    4b8e:	8b 77 20             	mov    0x20(%rdi),%esi
    4b91:	41 89 73 20          	mov    %esi,0x20(%r11)
    4b95:	e9 8d fa ff ff       	jmp    4627 <ayatsuri_model_instance_evaluate+0x527>
    4b9a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    4ba0:	4d 8b 37             	mov    (%r15),%r14
    4ba3:	45 8b 4e 14          	mov    0x14(%r14),%r9d
    4ba7:	49 8b 3e             	mov    (%r14),%rdi
    4baa:	41 8b 6e 24          	mov    0x24(%r14),%ebp
    4bae:	49 01 c9             	add    %rcx,%r9
    4bb1:	48 89 3c 24          	mov    %rdi,(%rsp)
    4bb5:	49 01 f9             	add    %rdi,%r9
    4bb8:	41 0f b7 79 04       	movzwl 0x4(%r9),%edi
    4bbd:	45 0f b7 49 08       	movzwl 0x8(%r9),%r9d
    4bc2:	8d 3c 7f             	lea    (%rdi,%rdi,2),%edi
    4bc5:	c1 e7 02             	shl    $0x2,%edi
    4bc8:	48 01 ef             	add    %rbp,%rdi
    4bcb:	48 8b 2c 24          	mov    (%rsp),%rbp
    4bcf:	48 01 ef             	add    %rbp,%rdi
    4bd2:	41 8b 6e 34          	mov    0x34(%r14),%ebp
    4bd6:	89 6c 24 30          	mov    %ebp,0x30(%rsp)
    4bda:	8b 6e 08             	mov    0x8(%rsi),%ebp
    4bdd:	48 01 c5             	add    %rax,%rbp
    4be0:	31 c0                	xor    %eax,%eax
    4be2:	0f 10 4c 05 00       	movups 0x0(%rbp,%rax,1),%xmm1
    4be7:	0f 5a c1             	cvtps2pd %xmm1,%xmm0
    4bea:	41 0f 29 44 45 00    	movaps %xmm0,0x0(%r13,%rax,2)
    4bf0:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4bf4:	0f 12 c1             	movhlps %xmm1,%xmm0
    4bf7:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
    4bfa:	41 0f 29 44 45 10    	movaps %xmm0,0x10(%r13,%rax,2)
    4c00:	48 83 c0 10          	add    $0x10,%rax
    4c04:	48 83 f8 30          	cmp    $0x30,%rax
    4c08:	75 d8                	jne    4be2 <ayatsuri_model_instance_evaluate+0xae2>
    4c0a:	f2 44 0f 10 bc 24 98 	movsd  0x398(%rsp),%xmm15
    4c11:	03 00 00 
    4c14:	f3 0f 7e 07          	movq   (%rdi),%xmm0
    4c18:	f2 0f 10 ac 24 c0 03 	movsd  0x3c0(%rsp),%xmm5
    4c1f:	00 00 
    4c21:	f2 44 0f 10 8c 24 b8 	movsd  0x3b8(%rsp),%xmm9
    4c28:	03 00 00 
    4c2b:	f2 44 0f 10 84 24 b0 	movsd  0x3b0(%rsp),%xmm8
    4c32:	03 00 00 
    4c35:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
    4c38:	66 0f 28 f8          	movapd %xmm0,%xmm7
    4c3c:	66 0f 28 c8          	movapd %xmm0,%xmm1
    4c40:	66 0f 15 ff          	unpckhpd %xmm7,%xmm7
    4c44:	f2 0f 11 6c 24 40    	movsd  %xmm5,0x40(%rsp)
    4c4a:	f2 44 0f 10 ac 24 90 	movsd  0x390(%rsp),%xmm13
    4c51:	03 00 00 
    4c54:	66 0f 28 d7          	movapd %xmm7,%xmm2
    4c58:	0f 29 84 24 e0 02 00 	movaps %xmm0,0x2e0(%rsp)
    4c5f:	00 
    4c60:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4c64:	f2 44 0f 59 ff       	mulsd  %xmm7,%xmm15
    4c69:	f3 0f 5a 47 08       	cvtss2sd 0x8(%rdi),%xmm0
    4c6e:	f2 0f 10 bc 24 a0 03 	movsd  0x3a0(%rsp),%xmm7
    4c75:	00 00 
    4c77:	f2 0f 11 84 24 f0 02 	movsd  %xmm0,0x2f0(%rsp)
    4c7e:	00 00 
    4c80:	f2 44 0f 59 ca       	mulsd  %xmm2,%xmm9
    4c85:	f2 0f 11 7c 24 38    	movsd  %xmm7,0x38(%rsp)
    4c8b:	f2 44 0f 59 c1       	mulsd  %xmm1,%xmm8
    4c90:	66 0f 28 f7          	movapd %xmm7,%xmm6
    4c94:	66 0f 28 fd          	movapd %xmm5,%xmm7
    4c98:	f2 0f 10 ac 24 e0 03 	movsd  0x3e0(%rsp),%xmm5
    4c9f:	00 00 
    4ca1:	f2 0f 59 f8          	mulsd  %xmm0,%xmm7
    4ca5:	f2 0f 59 f0          	mulsd  %xmm0,%xmm6
    4ca9:	f2 0f 59 94 24 d8 03 	mulsd  0x3d8(%rsp),%xmm2
    4cb0:	00 00 
    4cb2:	f2 0f 11 6c 24 48    	movsd  %xmm5,0x48(%rsp)
    4cb8:	f2 0f 59 c5          	mulsd  %xmm5,%xmm0
    4cbc:	66 41 0f 28 e9       	movapd %xmm9,%xmm5
    4cc1:	f2 44 0f 59 e9       	mulsd  %xmm1,%xmm13
    4cc6:	66 45 0f 28 e0       	movapd %xmm8,%xmm12
    4ccb:	66 41 0f 28 e0       	movapd %xmm8,%xmm4
    4cd0:	f2 0f 59 8c 24 d0 03 	mulsd  0x3d0(%rsp),%xmm1
    4cd7:	00 00 
    4cd9:	66 0f 28 df          	movapd %xmm7,%xmm3
    4cdd:	66 44 0f 28 df       	movapd %xmm7,%xmm11
    4ce2:	f2 0f 59 da          	mulsd  %xmm2,%xmm3
    4ce6:	f2 0f 59 e8          	mulsd  %xmm0,%xmm5
    4cea:	f2 44 0f 59 e0       	mulsd  %xmm0,%xmm12
    4cef:	f2 44 0f 59 d9       	mulsd  %xmm1,%xmm11
    4cf4:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    4cf8:	f2 0f 5c eb          	subsd  %xmm3,%xmm5
    4cfc:	66 41 0f 28 d9       	movapd %xmm9,%xmm3
    4d01:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
    4d05:	f2 44 0f 11 64 24 20 	movsd  %xmm12,0x20(%rsp)
    4d0c:	f2 45 0f 5c e3       	subsd  %xmm11,%xmm12
    4d11:	66 44 0f 28 d4       	movapd %xmm4,%xmm10
    4d16:	f2 0f 10 25 00 00 00 	movsd  0x0(%rip),%xmm4        # 4d1e <ayatsuri_model_instance_evaluate+0xc1e>
    4d1d:	00 
			4d1a: R_X86_64_PC32	.LC18-0x4
    4d1e:	f2 45 0f 59 e7       	mulsd  %xmm15,%xmm12
    4d23:	f2 44 0f 5c d3       	subsd  %xmm3,%xmm10
    4d28:	66 41 0f 28 dd       	movapd %xmm13,%xmm3
    4d2d:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    4d31:	f2 41 0f 5c dc       	subsd  %xmm12,%xmm3
    4d36:	66 44 0f 28 e6       	movapd %xmm6,%xmm12
    4d3b:	f2 45 0f 59 e2       	mulsd  %xmm10,%xmm12
    4d40:	f2 41 0f 58 dc       	addsd  %xmm12,%xmm3
    4d45:	66 44 0f 28 e3       	movapd %xmm3,%xmm12
    4d4a:	66 44 0f 54 25 00 00 	andpd  0x0(%rip),%xmm12        # 4d53 <ayatsuri_model_instance_evaluate+0xc53>
    4d51:	00 00 
			4d4f: R_X86_64_PC32	.LC8-0x4
    4d53:	66 41 0f 2e e4       	ucomisd %xmm12,%xmm4
    4d58:	0f 82 82 0f 00 00    	jb     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    4d5e:	f2 0f 10 25 00 00 00 	movsd  0x0(%rip),%xmm4        # 4d66 <ayatsuri_model_instance_evaluate+0xc66>
    4d65:	00 
			4d62: R_X86_64_PC32	.LC40-0x4
    4d66:	66 41 0f 2f e4       	comisd %xmm12,%xmm4
    4d6b:	0f 87 6f 0f 00 00    	ja     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    4d71:	f2 44 0f 5c 5c 24 20 	subsd  0x20(%rsp),%xmm11
    4d78:	66 44 0f 28 e3       	movapd %xmm3,%xmm12
    4d7d:	66 41 0f 28 e2       	movapd %xmm10,%xmm4
    4d82:	31 c0                	xor    %eax,%eax
    4d84:	66 45 0f 14 e4       	unpcklpd %xmm12,%xmm12
    4d89:	66 41 0f 14 eb       	unpcklpd %xmm11,%xmm5
    4d8e:	66 44 0f 28 de       	movapd %xmm6,%xmm11
    4d93:	66 41 0f 5e ec       	divpd  %xmm12,%xmm5
    4d98:	f2 44 0f 59 da       	mulsd  %xmm2,%xmm11
    4d9d:	f2 41 0f 59 d5       	mulsd  %xmm13,%xmm2
    4da2:	0f 29 ac 24 30 03 00 	movaps %xmm5,0x330(%rsp)
    4da9:	00 
    4daa:	66 41 0f 28 ef       	movapd %xmm15,%xmm5
    4daf:	f2 0f 59 e8          	mulsd  %xmm0,%xmm5
    4db3:	f2 41 0f 59 c5       	mulsd  %xmm13,%xmm0
    4db8:	f2 44 0f 5c dd       	subsd  %xmm5,%xmm11
    4dbd:	66 41 0f 14 e3       	unpcklpd %xmm11,%xmm4
    4dc2:	66 41 0f 5e e4       	divpd  %xmm12,%xmm4
    4dc7:	0f 29 a4 24 40 03 00 	movaps %xmm4,0x340(%rsp)
    4dce:	00 
    4dcf:	66 0f 28 e6          	movapd %xmm6,%xmm4
    4dd3:	f2 0f 59 e1          	mulsd  %xmm1,%xmm4
    4dd7:	f2 41 0f 59 cf       	mulsd  %xmm15,%xmm1
    4ddc:	f2 0f 5c c4          	subsd  %xmm4,%xmm0
    4de0:	f2 0f 5c ca          	subsd  %xmm2,%xmm1
    4de4:	66 0f 14 c1          	unpcklpd %xmm1,%xmm0
    4de8:	66 0f 28 ce          	movapd %xmm6,%xmm1
    4dec:	66 41 0f 5e c4       	divpd  %xmm12,%xmm0
    4df1:	f2 41 0f 59 c9       	mulsd  %xmm9,%xmm1
    4df6:	f2 41 0f 59 f0       	mulsd  %xmm8,%xmm6
    4dfb:	0f 29 84 24 50 03 00 	movaps %xmm0,0x350(%rsp)
    4e02:	00 
    4e03:	66 41 0f 28 c7       	movapd %xmm15,%xmm0
    4e08:	f2 0f 59 c7          	mulsd  %xmm7,%xmm0
    4e0c:	f2 41 0f 59 fd       	mulsd  %xmm13,%xmm7
    4e11:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    4e15:	66 41 0f 28 cf       	movapd %xmm15,%xmm1
    4e1a:	f2 0f 5c f7          	subsd  %xmm7,%xmm6
    4e1e:	f2 41 0f 59 c8       	mulsd  %xmm8,%xmm1
    4e23:	66 0f 14 c6          	unpcklpd %xmm6,%xmm0
    4e27:	66 41 0f 5e c4       	divpd  %xmm12,%xmm0
    4e2c:	0f 29 84 24 60 03 00 	movaps %xmm0,0x360(%rsp)
    4e33:	00 
    4e34:	66 41 0f 28 c5       	movapd %xmm13,%xmm0
    4e39:	f2 41 0f 59 c1       	mulsd  %xmm9,%xmm0
    4e3e:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    4e42:	f2 0f 5e c3          	divsd  %xmm3,%xmm0
    4e46:	f2 0f 11 84 24 70 03 	movsd  %xmm0,0x370(%rsp)
    4e4d:	00 00 
    4e4f:	f2 0f 10 0c 43       	movsd  (%rbx,%rax,2),%xmm1
    4e54:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 4e5c <ayatsuri_model_instance_evaluate+0xd5c>
    4e5b:	00 
			4e58: R_X86_64_PC32	.LC18-0x4
    4e5c:	66 0f 28 c1          	movapd %xmm1,%xmm0
    4e60:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 4e68 <ayatsuri_model_instance_evaluate+0xd68>
    4e67:	00 
			4e64: R_X86_64_PC32	.LC8-0x4
    4e68:	66 0f 2e f8          	ucomisd %xmm0,%xmm7
    4e6c:	0f 82 6e 0e 00 00    	jb     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    4e72:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 4e7a <ayatsuri_model_instance_evaluate+0xd7a>
    4e79:	00 
			4e76: R_X86_64_PC32	.LC38-0x4
    4e7a:	0f 83 60 0e 00 00    	jae    5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    4e80:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 4e88 <ayatsuri_model_instance_evaluate+0xd88>
    4e87:	00 
			4e84: R_X86_64_PC32	.LC39-0x4
    4e88:	0f 86 f5 13 00 00    	jbe    6283 <ayatsuri_model_instance_evaluate+0x2183>
    4e8e:	66 0f ef d2          	pxor   %xmm2,%xmm2
    4e92:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 4e9a <ayatsuri_model_instance_evaluate+0xd9a>
    4e99:	00 
			4e96: R_X86_64_PC32	.LC33-0x4
    4e9a:	66 0f 2f d1          	comisd %xmm1,%xmm2
    4e9e:	77 04                	ja     4ea4 <ayatsuri_model_instance_evaluate+0xda4>
    4ea0:	41 0f 28 c6          	movaps %xmm14,%xmm0
    4ea4:	f3 0f 11 84 05 80 00 	movss  %xmm0,0x80(%rbp,%rax,1)
    4eab:	00 00 
    4ead:	48 83 c0 04          	add    $0x4,%rax
    4eb1:	48 83 f8 24          	cmp    $0x24,%rax
    4eb5:	75 98                	jne    4e4f <ayatsuri_model_instance_evaluate+0xd4f>
    4eb7:	48 89 54 24 50       	mov    %rdx,0x50(%rsp)
    4ebc:	48 8d 84 24 e0 02 00 	lea    0x2e0(%rsp),%rax
    4ec3:	00 
    4ec4:	66 0f ef c9          	pxor   %xmm1,%xmm1
    4ec8:	31 ff                	xor    %edi,%edi
    4eca:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
    4ecf:	4c 89 e8             	mov    %r13,%rax
    4ed2:	f3 41 0f 5a 4f 40    	cvtss2sd 0x40(%r15),%xmm1
    4ed8:	f2 0f 10 30          	movsd  (%rax),%xmm6
    4edc:	f2 0f 10 68 20       	movsd  0x20(%rax),%xmm5
    4ee1:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4ee5:	66 0f ef db          	pxor   %xmm3,%xmm3
    4ee9:	f3 0f 5a 84 24 e4 01 	cvtss2sd 0x1e4(%rsp),%xmm0
    4ef0:	00 00 
    4ef2:	f2 0f 10 60 40       	movsd  0x40(%rax),%xmm4
    4ef7:	f3 0f 5a 9c 24 e8 01 	cvtss2sd 0x1e8(%rsp),%xmm3
    4efe:	00 00 
    4f00:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
    4f05:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    4f09:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 4f11 <ayatsuri_model_instance_evaluate+0xe11>
    4f10:	00 
			4f0d: R_X86_64_PC32	.LC18-0x4
    4f11:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
    4f15:	f2 0f 10 14 7a       	movsd  (%rdx,%rdi,2),%xmm2
    4f1a:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    4f1e:	66 0f ef db          	pxor   %xmm3,%xmm3
    4f22:	f3 0f 5a 9c 24 ec 01 	cvtss2sd 0x1ec(%rsp),%xmm3
    4f29:	00 00 
    4f2b:	f2 0f 59 dc          	mulsd  %xmm4,%xmm3
    4f2f:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    4f33:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    4f37:	f2 0f 59 c2          	mulsd  %xmm2,%xmm0
    4f3b:	66 0f 28 d8          	movapd %xmm0,%xmm3
    4f3f:	66 0f 54 1d 00 00 00 	andpd  0x0(%rip),%xmm3        # 4f47 <ayatsuri_model_instance_evaluate+0xe47>
    4f46:	00 
			4f43: R_X86_64_PC32	.LC8-0x4
    4f47:	66 0f 2e fb          	ucomisd %xmm3,%xmm7
    4f4b:	0f 82 8f 0d 00 00    	jb     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    4f51:	66 0f 2f 1d 00 00 00 	comisd 0x0(%rip),%xmm3        # 4f59 <ayatsuri_model_instance_evaluate+0xe59>
    4f58:	00 
			4f55: R_X86_64_PC32	.LC38-0x4
    4f59:	0f 83 81 0d 00 00    	jae    5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    4f5f:	66 0f 2f 1d 00 00 00 	comisd 0x0(%rip),%xmm3        # 4f67 <ayatsuri_model_instance_evaluate+0xe67>
    4f66:	00 
			4f63: R_X86_64_PC32	.LC39-0x4
    4f67:	0f 86 3a 13 00 00    	jbe    62a7 <ayatsuri_model_instance_evaluate+0x21a7>
    4f6d:	66 0f ef db          	pxor   %xmm3,%xmm3
    4f71:	66 0f 2f d8          	comisd %xmm0,%xmm3
    4f75:	0f 87 35 13 00 00    	ja     62b0 <ayatsuri_model_instance_evaluate+0x21b0>
    4f7b:	41 0f 28 c6          	movaps %xmm14,%xmm0
    4f7f:	f3 0f 11 44 3d 60    	movss  %xmm0,0x60(%rbp,%rdi,1)
    4f85:	66 0f ef db          	pxor   %xmm3,%xmm3
    4f89:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4f8d:	f3 0f 5a 84 24 d8 01 	cvtss2sd 0x1d8(%rsp),%xmm0
    4f94:	00 00 
    4f96:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
    4f9a:	f3 0f 5a 9c 24 dc 01 	cvtss2sd 0x1dc(%rsp),%xmm3
    4fa1:	00 00 
    4fa3:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 4fab <ayatsuri_model_instance_evaluate+0xeab>
    4faa:	00 
			4fa7: R_X86_64_PC32	.LC18-0x4
    4fab:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    4faf:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    4fb3:	66 0f ef db          	pxor   %xmm3,%xmm3
    4fb7:	f3 0f 5a 9c 24 e0 01 	cvtss2sd 0x1e0(%rsp),%xmm3
    4fbe:	00 00 
    4fc0:	f2 0f 59 dc          	mulsd  %xmm4,%xmm3
    4fc4:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    4fc8:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    4fcc:	f2 0f 59 c2          	mulsd  %xmm2,%xmm0
    4fd0:	66 0f 28 d0          	movapd %xmm0,%xmm2
    4fd4:	66 0f 54 15 00 00 00 	andpd  0x0(%rip),%xmm2        # 4fdc <ayatsuri_model_instance_evaluate+0xedc>
    4fdb:	00 
			4fd8: R_X86_64_PC32	.LC8-0x4
    4fdc:	66 0f 2e f2          	ucomisd %xmm2,%xmm6
    4fe0:	0f 82 fa 0c 00 00    	jb     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    4fe6:	66 0f 2f 15 00 00 00 	comisd 0x0(%rip),%xmm2        # 4fee <ayatsuri_model_instance_evaluate+0xeee>
    4fed:	00 
			4fea: R_X86_64_PC32	.LC38-0x4
    4fee:	0f 83 ec 0c 00 00    	jae    5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    4ff4:	66 0f 2f 15 00 00 00 	comisd 0x0(%rip),%xmm2        # 4ffc <ayatsuri_model_instance_evaluate+0xefc>
    4ffb:	00 
			4ff8: R_X86_64_PC32	.LC39-0x4
    4ffc:	0f 86 bb 12 00 00    	jbe    62bd <ayatsuri_model_instance_evaluate+0x21bd>
    5002:	66 0f ef d2          	pxor   %xmm2,%xmm2
    5006:	66 0f 2f d0          	comisd %xmm0,%xmm2
    500a:	0f 87 c6 16 00 00    	ja     66d6 <ayatsuri_model_instance_evaluate+0x25d6>
    5010:	41 0f 28 c6          	movaps %xmm14,%xmm0
    5014:	f3 0f 11 44 3d 70    	movss  %xmm0,0x70(%rbp,%rdi,1)
    501a:	48 83 c7 04          	add    $0x4,%rdi
    501e:	48 83 c0 08          	add    $0x8,%rax
    5022:	48 83 ff 0c          	cmp    $0xc,%rdi
    5026:	0f 85 ac fe ff ff    	jne    4ed8 <ayatsuri_model_instance_evaluate+0xdd8>
    502c:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5030:	66 0f ef ed          	pxor   %xmm5,%xmm5
    5034:	f2 0f 10 a4 24 a8 03 	movsd  0x3a8(%rsp),%xmm4
    503b:	00 00 
    503d:	f2 0f 10 9c 24 c8 03 	movsd  0x3c8(%rsp),%xmm3
    5044:	00 00 
    5046:	f3 41 0f 5a 47 34    	cvtss2sd 0x34(%r15),%xmm0
    504c:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 5054 <ayatsuri_model_instance_evaluate+0xf54>
    5053:	00 
			5050: R_X86_64_PC32	.LC18-0x4
    5054:	f2 0f 10 94 24 e8 03 	movsd  0x3e8(%rsp),%xmm2
    505b:	00 00 
    505d:	f3 0f 5a ac 24 e8 01 	cvtss2sd 0x1e8(%rsp),%xmm5
    5064:	00 00 
    5066:	f2 0f 5c e0          	subsd  %xmm0,%xmm4
    506a:	66 0f ef c0          	pxor   %xmm0,%xmm0
    506e:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
    5073:	f3 41 0f 5a 47 38    	cvtss2sd 0x38(%r15),%xmm0
    5079:	f2 0f 5c d8          	subsd  %xmm0,%xmm3
    507d:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5081:	f3 41 0f 5a 47 3c    	cvtss2sd 0x3c(%r15),%xmm0
    5087:	f2 0f 5c d0          	subsd  %xmm0,%xmm2
    508b:	66 0f ef c0          	pxor   %xmm0,%xmm0
    508f:	f3 0f 5a 84 24 e4 01 	cvtss2sd 0x1e4(%rsp),%xmm0
    5096:	00 00 
    5098:	f2 0f 59 c4          	mulsd  %xmm4,%xmm0
    509c:	f2 0f 59 eb          	mulsd  %xmm3,%xmm5
    50a0:	f2 0f 58 c5          	addsd  %xmm5,%xmm0
    50a4:	66 0f ef ed          	pxor   %xmm5,%xmm5
    50a8:	f3 0f 5a ac 24 ec 01 	cvtss2sd 0x1ec(%rsp),%xmm5
    50af:	00 00 
    50b1:	f2 0f 59 ea          	mulsd  %xmm2,%xmm5
    50b5:	f2 0f 58 c5          	addsd  %xmm5,%xmm0
    50b9:	66 0f ef ed          	pxor   %xmm5,%xmm5
    50bd:	f3 41 0f 5a 6f 44    	cvtss2sd 0x44(%r15),%xmm5
    50c3:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    50c7:	f2 0f 58 c5          	addsd  %xmm5,%xmm0
    50cb:	66 0f 28 e8          	movapd %xmm0,%xmm5
    50cf:	66 0f 54 2d 00 00 00 	andpd  0x0(%rip),%xmm5        # 50d7 <ayatsuri_model_instance_evaluate+0xfd7>
    50d6:	00 
			50d3: R_X86_64_PC32	.LC8-0x4
    50d7:	66 0f 2e f5          	ucomisd %xmm5,%xmm6
    50db:	0f 82 ff 0b 00 00    	jb     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    50e1:	66 0f 2f 2d 00 00 00 	comisd 0x0(%rip),%xmm5        # 50e9 <ayatsuri_model_instance_evaluate+0xfe9>
    50e8:	00 
			50e5: R_X86_64_PC32	.LC38-0x4
    50e9:	0f 83 f1 0b 00 00    	jae    5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    50ef:	66 0f 2f 2d 00 00 00 	comisd 0x0(%rip),%xmm5        # 50f7 <ayatsuri_model_instance_evaluate+0xff7>
    50f6:	00 
			50f3: R_X86_64_PC32	.LC39-0x4
    50f7:	0f 86 c9 11 00 00    	jbe    62c6 <ayatsuri_model_instance_evaluate+0x21c6>
    50fd:	66 0f ef ed          	pxor   %xmm5,%xmm5
    5101:	66 0f 2f e8          	comisd %xmm0,%xmm5
    5105:	0f 87 2c 15 00 00    	ja     6637 <ayatsuri_model_instance_evaluate+0x2537>
    510b:	41 0f 28 c6          	movaps %xmm14,%xmm0
    510f:	f3 0f 11 45 6c       	movss  %xmm0,0x6c(%rbp)
    5114:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5118:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 5120 <ayatsuri_model_instance_evaluate+0x1020>
    511f:	00 
			511c: R_X86_64_PC32	.LC18-0x4
    5120:	f3 0f 5a 84 24 d8 01 	cvtss2sd 0x1d8(%rsp),%xmm0
    5127:	00 00 
    5129:	f2 0f 59 c4          	mulsd  %xmm4,%xmm0
    512d:	66 0f ef e4          	pxor   %xmm4,%xmm4
    5131:	f3 0f 5a a4 24 dc 01 	cvtss2sd 0x1dc(%rsp),%xmm4
    5138:	00 00 
    513a:	f2 0f 59 dc          	mulsd  %xmm4,%xmm3
    513e:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    5142:	66 0f ef db          	pxor   %xmm3,%xmm3
    5146:	f3 0f 5a 9c 24 e0 01 	cvtss2sd 0x1e0(%rsp),%xmm3
    514d:	00 00 
    514f:	f2 0f 59 d3          	mulsd  %xmm3,%xmm2
    5153:	f2 0f 58 c2          	addsd  %xmm2,%xmm0
    5157:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    515b:	66 0f ef c9          	pxor   %xmm1,%xmm1
    515f:	f3 41 0f 5a 4f 48    	cvtss2sd 0x48(%r15),%xmm1
    5165:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    5169:	66 0f 28 c8          	movapd %xmm0,%xmm1
    516d:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 5175 <ayatsuri_model_instance_evaluate+0x1075>
    5174:	00 
			5171: R_X86_64_PC32	.LC8-0x4
    5175:	66 0f 2e f1          	ucomisd %xmm1,%xmm6
    5179:	0f 82 61 0b 00 00    	jb     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    517f:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 5187 <ayatsuri_model_instance_evaluate+0x1087>
    5186:	00 
			5183: R_X86_64_PC32	.LC38-0x4
    5187:	0f 83 53 0b 00 00    	jae    5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    518d:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 5195 <ayatsuri_model_instance_evaluate+0x1095>
    5194:	00 
			5191: R_X86_64_PC32	.LC39-0x4
    5195:	0f 86 55 15 00 00    	jbe    66f0 <ayatsuri_model_instance_evaluate+0x25f0>
    519b:	66 0f ef c9          	pxor   %xmm1,%xmm1
    519f:	66 0f 2f c8          	comisd %xmm0,%xmm1
    51a3:	0f 87 3a 15 00 00    	ja     66e3 <ayatsuri_model_instance_evaluate+0x25e3>
    51a9:	41 0f 28 c6          	movaps %xmm14,%xmm0
    51ad:	41 0f b7 f9          	movzwl %r9w,%edi
    51b1:	8b 44 24 30          	mov    0x30(%rsp),%eax
    51b5:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
    51ba:	48 6b ff 48          	imul   $0x48,%rdi,%rdi
    51be:	48 8b 0c 24          	mov    (%rsp),%rcx
    51c2:	f3 0f 11 45 7c       	movss  %xmm0,0x7c(%rbp)
    51c7:	4c 89 9c 24 90 00 00 	mov    %r11,0x90(%rsp)
    51ce:	00 
    51cf:	4c 89 54 24 70       	mov    %r10,0x70(%rsp)
    51d4:	48 01 f8             	add    %rdi,%rax
    51d7:	8b 7e 0c             	mov    0xc(%rsi),%edi
    51da:	48 89 54 24 68       	mov    %rdx,0x68(%rsp)
    51df:	48 01 c1             	add    %rax,%rcx
    51e2:	4c 89 44 24 60       	mov    %r8,0x60(%rsp)
    51e7:	48 89 0c 24          	mov    %rcx,(%rsp)
    51eb:	e8 70 af ff ff       	call   160 <pack_rgb>
    51f0:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 51f8 <ayatsuri_model_instance_evaluate+0x10f8>
    51f7:	00 
			51f4: R_X86_64_PC32	.LC5-0x4
    51f8:	f2 0f 59 06          	mulsd  (%rsi),%xmm0
    51fc:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 5204 <ayatsuri_model_instance_evaluate+0x1104>
    5203:	00 
			5200: R_X86_64_PC32	.LC6-0x4
    5204:	66 89 44 24 20       	mov    %ax,0x20(%rsp)
    5209:	e8 00 00 00 00       	call   520e <ayatsuri_model_instance_evaluate+0x110e>
			520a: R_X86_64_PLT32	floor-0x4
    520e:	48 8b 0c 24          	mov    (%rsp),%rcx
    5212:	f2 0f 11 44 24 50    	movsd  %xmm0,0x50(%rsp)
    5218:	48 8d 79 30          	lea    0x30(%rcx),%rdi
    521c:	e8 df ad ff ff       	call   0 <md>
    5221:	f2 0f 10 4c 24 40    	movsd  0x40(%rsp),%xmm1
    5227:	f2 0f 11 44 24 30    	movsd  %xmm0,0x30(%rsp)
    522d:	f2 0f 10 44 24 38    	movsd  0x38(%rsp),%xmm0
    5233:	e8 00 00 00 00       	call   5238 <ayatsuri_model_instance_evaluate+0x1138>
			5234: R_X86_64_PLT32	hypot-0x4
    5238:	f2 0f 10 4c 24 48    	movsd  0x48(%rsp),%xmm1
    523e:	e8 00 00 00 00       	call   5243 <ayatsuri_model_instance_evaluate+0x1143>
			523f: R_X86_64_PLT32	hypot-0x4
    5243:	f2 0f 59 44 24 30    	mulsd  0x30(%rsp),%xmm0
    5249:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 5251 <ayatsuri_model_instance_evaluate+0x1151>
    5250:	00 
			524d: R_X86_64_PC32	.LC9-0x4
    5251:	e8 00 00 00 00       	call   5256 <ayatsuri_model_instance_evaluate+0x1156>
			5252: R_X86_64_PLT32	fmin-0x4
    5256:	f2 0f 59 05 00 00 00 	mulsd  0x0(%rip),%xmm0        # 525e <ayatsuri_model_instance_evaluate+0x115e>
    525d:	00 
			525a: R_X86_64_PC32	.LC5-0x4
    525e:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 5266 <ayatsuri_model_instance_evaluate+0x1166>
    5265:	00 
			5262: R_X86_64_PC32	.LC6-0x4
    5266:	e8 00 00 00 00       	call   526b <ayatsuri_model_instance_evaluate+0x116b>
			5267: R_X86_64_PLT32	floor-0x4
    526b:	f2 0f 10 54 24 50    	movsd  0x50(%rsp),%xmm2
    5271:	48 8b 0c 24          	mov    (%rsp),%rcx
    5275:	66 c7 85 f0 00 00 00 	movw   $0x0,0xf0(%rbp)
    527c:	00 00 
    527e:	48 c7 85 d4 00 00 00 	movq   $0x3f800000,0xd4(%rbp)
    5285:	00 00 80 3f 
    5289:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    528d:	0f 28 05 00 00 00 00 	movaps 0x0(%rip),%xmm0        # 5294 <ayatsuri_model_instance_evaluate+0x1194>
			5290: R_X86_64_PC32	.LC41-0x4
    5294:	f2 0f 2c f2          	cvttsd2si %xmm2,%esi
    5298:	48 8d 79 40          	lea    0x40(%rcx),%rdi
    529c:	0f 11 85 c4 00 00 00 	movups %xmm0,0xc4(%rbp)
    52a3:	0f b7 c0             	movzwl %ax,%eax
    52a6:	0f b7 f6             	movzwl %si,%esi
    52a9:	48 c1 e0 10          	shl    $0x10,%rax
    52ad:	48 09 f0             	or     %rsi,%rax
    52b0:	0f b7 74 24 20       	movzwl 0x20(%rsp),%esi
    52b5:	48 c1 e0 10          	shl    $0x10,%rax
    52b9:	48 09 f0             	or     %rsi,%rax
    52bc:	48 c1 e0 10          	shl    $0x10,%rax
    52c0:	48 09 f0             	or     %rsi,%rax
    52c3:	48 89 85 e8 00 00 00 	mov    %rax,0xe8(%rbp)
    52ca:	e8 31 ad ff ff       	call   0 <md>
    52cf:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 52d7 <ayatsuri_model_instance_evaluate+0x11d7>
    52d6:	00 
			52d3: R_X86_64_PC32	.LC18-0x4
    52d7:	66 0f 28 c8          	movapd %xmm0,%xmm1
    52db:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 52e3 <ayatsuri_model_instance_evaluate+0x11e3>
    52e2:	00 
			52df: R_X86_64_PC32	.LC8-0x4
    52e3:	66 0f 2e f1          	ucomisd %xmm1,%xmm6
    52e7:	0f 82 f3 09 00 00    	jb     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    52ed:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 52f5 <ayatsuri_model_instance_evaluate+0x11f5>
    52f4:	00 
			52f1: R_X86_64_PC32	.LC38-0x4
    52f5:	0f 83 e5 09 00 00    	jae    5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    52fb:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 5303 <ayatsuri_model_instance_evaluate+0x1203>
    5302:	00 
			52ff: R_X86_64_PC32	.LC39-0x4
    5303:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
    5308:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 5311 <ayatsuri_model_instance_evaluate+0x1211>
    530f:	00 00 
			530d: R_X86_64_PC32	.LC0-0x4
    5311:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
    5316:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
    531b:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 5324 <ayatsuri_model_instance_evaluate+0x1224>
    5322:	00 00 
			5320: R_X86_64_PC32	.LC1-0x4
    5324:	4c 8b 54 24 70       	mov    0x70(%rsp),%r10
    5329:	4c 8b 9c 24 90 00 00 	mov    0x90(%rsp),%r11
    5330:	00 
    5331:	0f 86 89 13 00 00    	jbe    66c0 <ayatsuri_model_instance_evaluate+0x25c0>
    5337:	66 0f ef c9          	pxor   %xmm1,%xmm1
    533b:	66 0f 2f c8          	comisd %xmm0,%xmm1
    533f:	0f 87 6e 13 00 00    	ja     66b3 <ayatsuri_model_instance_evaluate+0x25b3>
    5345:	41 0f 28 c6          	movaps %xmm14,%xmm0
    5349:	45 8b 4e 50          	mov    0x50(%r14),%r9d
    534d:	b8 7f 00 00 00       	mov    $0x7f,%eax
    5352:	f3 0f 11 85 dc 00 00 	movss  %xmm0,0xdc(%rbp)
    5359:	00 
    535a:	31 ff                	xor    %edi,%edi
    535c:	48 c1 e0 37          	shl    $0x37,%rax
    5360:	48 89 85 e0 00 00 00 	mov    %rax,0xe0(%rbp)
    5367:	44 89 0c 24          	mov    %r9d,(%rsp)
    536b:	8b 04 24             	mov    (%rsp),%eax
    536e:	39 c7                	cmp    %eax,%edi
    5370:	0f 84 1f 0a 00 00    	je     5d95 <ayatsuri_model_instance_evaluate+0x1c95>
    5376:	41 8b 76 4c          	mov    0x4c(%r14),%esi
    537a:	89 f8                	mov    %edi,%eax
    537c:	44 8b 4c 24 18       	mov    0x18(%rsp),%r9d
    5381:	c1 e0 05             	shl    $0x5,%eax
    5384:	48 01 c6             	add    %rax,%rsi
    5387:	49 03 36             	add    (%r14),%rsi
    538a:	0f b7 06             	movzwl (%rsi),%eax
    538d:	44 39 c8             	cmp    %r9d,%eax
    5390:	0f 84 c8 12 00 00    	je     665e <ayatsuri_model_instance_evaluate+0x255e>
    5396:	83 c7 01             	add    $0x1,%edi
    5399:	eb d0                	jmp    536b <ayatsuri_model_instance_evaluate+0x126b>
    539b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    53a0:	8b 74 24 18          	mov    0x18(%rsp),%esi
    53a4:	45 31 c9             	xor    %r9d,%r9d
    53a7:	4c 89 ff             	mov    %r15,%rdi
    53aa:	4c 89 5c 24 20       	mov    %r11,0x20(%rsp)
    53af:	48 8b 8c 24 78 01 00 	mov    0x178(%rsp),%rcx
    53b6:	00 
    53b7:	48 8b 94 24 80 01 00 	mov    0x180(%rsp),%rdx
    53be:	00 
    53bf:	4c 8d 84 24 c8 01 00 	lea    0x1c8(%rsp),%r8
    53c6:	00 
    53c7:	4c 89 14 24          	mov    %r10,(%rsp)
    53cb:	e8 50 b2 ff ff       	call   620 <mesh_packet>
    53d0:	84 c0                	test   %al,%al
    53d2:	0f 84 08 09 00 00    	je     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    53d8:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    53de:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
    53e3:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 53ec <ayatsuri_model_instance_evaluate+0x12ec>
    53ea:	00 00 
			53e8: R_X86_64_PC32	.LC0-0x4
    53ec:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 53f5 <ayatsuri_model_instance_evaluate+0x12f5>
    53f3:	00 00 
			53f1: R_X86_64_PC32	.LC1-0x4
    53f5:	4c 8b 14 24          	mov    (%rsp),%r10
    53f9:	e9 0b f7 ff ff       	jmp    4b09 <ayatsuri_model_instance_evaluate+0xa09>
    53fe:	66 90                	xchg   %ax,%ax
    5400:	4d 8b 37             	mov    (%r15),%r14
    5403:	49 8b 6f 08          	mov    0x8(%r15),%rbp
    5407:	41 8b 46 14          	mov    0x14(%r14),%eax
    540b:	49 8b 3e             	mov    (%r14),%rdi
    540e:	48 01 c8             	add    %rcx,%rax
    5411:	48 89 bc 24 b8 00 00 	mov    %rdi,0xb8(%rsp)
    5418:	00 
    5419:	4c 8d 0c 07          	lea    (%rdi,%rax,1),%r9
    541d:	41 8b 46 34          	mov    0x34(%r14),%eax
    5421:	41 0f b7 79 06       	movzwl 0x6(%r9),%edi
    5426:	41 0f b7 71 08       	movzwl 0x8(%r9),%esi
    542b:	89 84 24 8c 01 00 00 	mov    %eax,0x18c(%rsp)
    5432:	48 8d 44 15 00       	lea    0x0(%rbp,%rdx,1),%rax
    5437:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
    543e:	00 
    543f:	8b 40 08             	mov    0x8(%rax),%eax
    5442:	48 01 c5             	add    %rax,%rbp
    5445:	8d 04 7f             	lea    (%rdi,%rdi,2),%eax
    5448:	8d 44 00 4f          	lea    0x4f(%rax,%rax,1),%eax
    544c:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
    5453:	00 
    5454:	31 c0                	xor    %eax,%eax
    5456:	0f 10 4c 05 00       	movups 0x0(%rbp,%rax,1),%xmm1
    545b:	0f 5a c1             	cvtps2pd %xmm1,%xmm0
    545e:	0f 29 04 43          	movaps %xmm0,(%rbx,%rax,2)
    5462:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5466:	0f 12 c1             	movhlps %xmm1,%xmm0
    5469:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
    546c:	0f 29 44 43 10       	movaps %xmm0,0x10(%rbx,%rax,2)
    5471:	48 83 c0 10          	add    $0x10,%rax
    5475:	48 83 f8 30          	cmp    $0x30,%rax
    5479:	75 db                	jne    5456 <ayatsuri_model_instance_evaluate+0x1356>
    547b:	66 0f ef f6          	pxor   %xmm6,%xmm6
    547f:	f3 41 0f 5a 77 40    	cvtss2sd 0x40(%r15),%xmm6
    5485:	66 0f 28 fe          	movapd %xmm6,%xmm7
    5489:	f2 0f 11 74 24 20    	movsd  %xmm6,0x20(%rsp)
    548f:	f2 0f 10 b4 24 80 03 	movsd  0x380(%rsp),%xmm6
    5496:	00 00 
    5498:	66 0f 14 ff          	unpcklpd %xmm7,%xmm7
    549c:	0f 29 bc 24 c0 00 00 	movaps %xmm7,0xc0(%rsp)
    54a3:	00 
    54a4:	f2 0f 10 bc 24 40 03 	movsd  0x340(%rsp),%xmm7
    54ab:	00 00 
    54ad:	f2 0f 11 74 24 70    	movsd  %xmm6,0x70(%rsp)
    54b3:	f2 0f 11 7c 24 60    	movsd  %xmm7,0x60(%rsp)
    54b9:	f2 0f 10 bc 24 60 03 	movsd  0x360(%rsp),%xmm7
    54c0:	00 00 
    54c2:	f2 0f 11 7c 24 68    	movsd  %xmm7,0x68(%rsp)
    54c8:	85 ff                	test   %edi,%edi
    54ca:	0f 84 43 09 00 00    	je     5e13 <ayatsuri_model_instance_evaluate+0x1d13>
    54d0:	66 0f 28 b4 24 70 03 	movapd 0x370(%rsp),%xmm6
    54d7:	00 00 
    54d9:	41 8b 46 2c          	mov    0x2c(%r14),%eax
    54dd:	c7 84 24 88 01 00 00 	movl   $0x0,0x188(%rsp)
    54e4:	00 00 00 00 
    54e8:	66 0f 28 bc 24 50 03 	movapd 0x350(%rsp),%xmm7
    54ef:	00 00 
    54f1:	48 89 8c 24 98 01 00 	mov    %rcx,0x198(%rsp)
    54f8:	00 
    54f9:	0f 29 b4 24 30 01 00 	movaps %xmm6,0x130(%rsp)
    5500:	00 
    5501:	66 0f 28 ac 24 30 03 	movapd 0x330(%rsp),%xmm5
    5508:	00 00 
    550a:	66 0f 17 b4 24 50 01 	movhpd %xmm6,0x150(%rsp)
    5511:	00 00 
    5513:	66 0f 13 b4 24 48 01 	movlpd %xmm6,0x148(%rsp)
    551a:	00 00 
    551c:	f2 0f 10 b4 24 48 03 	movsd  0x348(%rsp),%xmm6
    5523:	00 00 
    5525:	48 89 84 24 00 01 00 	mov    %rax,0x100(%rsp)
    552c:	00 
    552d:	48 8d 84 24 38 04 00 	lea    0x438(%rsp),%rax
    5534:	00 
    5535:	0f 29 bc 24 10 01 00 	movaps %xmm7,0x110(%rsp)
    553c:	00 
    553d:	66 0f 17 bc 24 40 01 	movhpd %xmm7,0x140(%rsp)
    5544:	00 00 
    5546:	66 0f 13 bc 24 28 01 	movlpd %xmm7,0x128(%rsp)
    554d:	00 00 
    554f:	f2 0f 10 bc 24 68 03 	movsd  0x368(%rsp),%xmm7
    5556:	00 00 
    5558:	f2 0f 11 b4 24 58 01 	movsd  %xmm6,0x158(%rsp)
    555f:	00 00 
    5561:	f2 0f 10 b4 24 88 03 	movsd  0x388(%rsp),%xmm6
    5568:	00 00 
    556a:	48 89 84 24 70 01 00 	mov    %rax,0x170(%rsp)
    5571:	00 
    5572:	0f 29 ac 24 f0 00 00 	movaps %xmm5,0xf0(%rsp)
    5579:	00 
    557a:	66 0f 17 ac 24 20 01 	movhpd %xmm5,0x120(%rsp)
    5581:	00 00 
    5583:	66 0f 13 ac 24 08 01 	movlpd %xmm5,0x108(%rsp)
    558a:	00 00 
    558c:	f2 0f 11 bc 24 60 01 	movsd  %xmm7,0x160(%rsp)
    5593:	00 00 
    5595:	f2 0f 11 b4 24 68 01 	movsd  %xmm6,0x168(%rsp)
    559c:	00 00 
    559e:	8b 9c 24 88 01 00 00 	mov    0x188(%rsp),%ebx
    55a5:	41 0f b7 41 04       	movzwl 0x4(%r9),%eax
    55aa:	66 0f ef d2          	pxor   %xmm2,%xmm2
    55ae:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    55b3:	f2 0f 10 44 24 60    	movsd  0x60(%rsp),%xmm0
    55b9:	f2 0f 10 6c 24 68    	movsd  0x68(%rsp),%xmm5
    55bf:	66 0f ef db          	pxor   %xmm3,%xmm3
    55c3:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    55c8:	f2 44 0f 10 ac 24 08 	movsd  0x108(%rsp),%xmm13
    55cf:	01 00 00 
    55d2:	01 d8                	add    %ebx,%eax
    55d4:	48 8b 9c 24 00 01 00 	mov    0x100(%rsp),%rbx
    55db:	00 
    55dc:	f2 0f 10 a4 24 20 01 	movsd  0x120(%rsp),%xmm4
    55e3:	00 00 
    55e5:	8d 04 40             	lea    (%rax,%rax,2),%eax
    55e8:	66 44 0f 28 bc 24 30 	movapd 0x130(%rsp),%xmm15
    55ef:	01 00 00 
    55f2:	8d 04 c5 00 00 00 00 	lea    0x0(,%rax,8),%eax
    55f9:	66 44 0f 28 8c 24 10 	movapd 0x110(%rsp),%xmm9
    5600:	01 00 00 
    5603:	48 01 d8             	add    %rbx,%rax
    5606:	48 8b 9c 24 b8 00 00 	mov    0xb8(%rsp),%rbx
    560d:	00 
    560e:	48 01 d8             	add    %rbx,%rax
    5611:	f3 0f 5a 50 14       	cvtss2sd 0x14(%rax),%xmm2
    5616:	f2 0f 59 ea          	mulsd  %xmm2,%xmm5
    561a:	f3 44 0f 5a 20       	cvtss2sd (%rax),%xmm12
    561f:	f3 0f 5a 58 04       	cvtss2sd 0x4(%rax),%xmm3
    5624:	f2 0f 59 c2          	mulsd  %xmm2,%xmm0
    5628:	f3 44 0f 5a 58 08    	cvtss2sd 0x8(%rax),%xmm11
    562e:	f3 44 0f 7e 40 0c    	movq   0xc(%rax),%xmm8
    5634:	f2 0f 59 54 24 70    	mulsd  0x70(%rsp),%xmm2
    563a:	f2 45 0f 59 ec       	mulsd  %xmm12,%xmm13
    563f:	45 0f 5a c0          	cvtps2pd %xmm8,%xmm8
    5643:	f2 0f 59 e3          	mulsd  %xmm3,%xmm4
    5647:	66 45 0f 59 f8       	mulpd  %xmm8,%xmm15
    564c:	66 45 0f 59 c8       	mulpd  %xmm8,%xmm9
    5651:	66 44 0f 59 84 24 f0 	mulpd  0xf0(%rsp),%xmm8
    5658:	00 00 00 
    565b:	f2 0f 11 14 24       	movsd  %xmm2,(%rsp)
    5660:	f2 0f 10 54 24 60    	movsd  0x60(%rsp),%xmm2
    5666:	f2 41 0f 59 d3       	mulsd  %xmm11,%xmm2
    566b:	f2 41 0f 58 e5       	addsd  %xmm13,%xmm4
    5670:	66 45 0f ef ed       	pxor   %xmm13,%xmm13
    5675:	f3 45 0f 5a 6f 34    	cvtss2sd 0x34(%r15),%xmm13
    567b:	66 44 0f 17 7c 24 38 	movhpd %xmm15,0x38(%rsp)
    5682:	66 44 0f 17 4c 24 30 	movhpd %xmm9,0x30(%rsp)
    5689:	66 41 0f 28 c9       	movapd %xmm9,%xmm1
    568e:	66 41 0f 28 f8       	movapd %xmm8,%xmm7
    5693:	66 0f 15 ff          	unpckhpd %xmm7,%xmm7
    5697:	f2 0f 58 e2          	addsd  %xmm2,%xmm4
    569b:	f2 0f 10 54 24 68    	movsd  0x68(%rsp),%xmm2
    56a1:	66 0f 28 f7          	movapd %xmm7,%xmm6
    56a5:	f2 0f 58 a4 24 58 01 	addsd  0x158(%rsp),%xmm4
    56ac:	00 00 
    56ae:	66 41 0f 28 f8       	movapd %xmm8,%xmm7
    56b3:	f2 41 0f 59 d3       	mulsd  %xmm11,%xmm2
    56b8:	f2 41 0f 5c e5       	subsd  %xmm13,%xmm4
    56bd:	f2 44 0f 10 ac 24 28 	movsd  0x128(%rsp),%xmm13
    56c4:	01 00 00 
    56c7:	f2 45 0f 59 ec       	mulsd  %xmm12,%xmm13
    56cc:	f2 44 0f 59 a4 24 48 	mulsd  0x148(%rsp),%xmm12
    56d3:	01 00 00 
    56d6:	f2 0f 11 64 24 48    	movsd  %xmm4,0x48(%rsp)
    56dc:	f2 0f 10 a4 24 40 01 	movsd  0x140(%rsp),%xmm4
    56e3:	00 00 
    56e5:	f2 0f 59 e3          	mulsd  %xmm3,%xmm4
    56e9:	f2 0f 59 9c 24 50 01 	mulsd  0x150(%rsp),%xmm3
    56f0:	00 00 
    56f2:	f2 41 0f 58 e5       	addsd  %xmm13,%xmm4
    56f7:	66 45 0f ef ed       	pxor   %xmm13,%xmm13
    56fc:	f3 45 0f 5a 6f 38    	cvtss2sd 0x38(%r15),%xmm13
    5702:	f2 41 0f 58 dc       	addsd  %xmm12,%xmm3
    5707:	f2 0f 58 e2          	addsd  %xmm2,%xmm4
    570b:	f2 0f 58 a4 24 60 01 	addsd  0x160(%rsp),%xmm4
    5712:	00 00 
    5714:	f2 41 0f 5c e5       	subsd  %xmm13,%xmm4
    5719:	f2 0f 11 64 24 50    	movsd  %xmm4,0x50(%rsp)
    571f:	f2 44 0f 59 5c 24 70 	mulsd  0x70(%rsp),%xmm11
    5726:	66 0f ef e4          	pxor   %xmm4,%xmm4
    572a:	f2 44 0f 10 6c 24 30 	movsd  0x30(%rsp),%xmm13
    5731:	f3 41 0f 5a 67 3c    	cvtss2sd 0x3c(%r15),%xmm4
    5737:	f2 0f 10 14 24       	movsd  (%rsp),%xmm2
    573c:	f2 44 0f 11 7c 24 40 	movsd  %xmm15,0x40(%rsp)
    5743:	f2 41 0f 58 db       	addsd  %xmm11,%xmm3
    5748:	f2 0f 58 9c 24 68 01 	addsd  0x168(%rsp),%xmm3
    574f:	00 00 
    5751:	f2 44 0f 10 1d 00 00 	movsd  0x0(%rip),%xmm11        # 575a <ayatsuri_model_instance_evaluate+0x165a>
    5758:	00 00 
			5756: R_X86_64_PC32	.LC18-0x4
    575a:	f2 0f 5c dc          	subsd  %xmm4,%xmm3
    575e:	66 41 0f 28 e5       	movapd %xmm13,%xmm4
    5763:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    5767:	f2 41 0f 59 d1       	mulsd  %xmm9,%xmm2
    576c:	f2 0f 11 5c 24 58    	movsd  %xmm3,0x58(%rsp)
    5772:	f2 0f 10 5c 24 38    	movsd  0x38(%rsp),%xmm3
    5778:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    577c:	66 44 0f 28 e4       	movapd %xmm4,%xmm12
    5781:	f2 0f 10 64 24 38    	movsd  0x38(%rsp),%xmm4
    5787:	f2 0f 11 94 24 98 00 	movsd  %xmm2,0x98(%rsp)
    578e:	00 00 
    5790:	f2 41 0f 59 e1       	mulsd  %xmm9,%xmm4
    5795:	f2 44 0f 5c e3       	subsd  %xmm3,%xmm12
    579a:	66 41 0f 28 dd       	movapd %xmm13,%xmm3
    579f:	f2 41 0f 59 df       	mulsd  %xmm15,%xmm3
    57a4:	f2 44 0f 11 a4 24 90 	movsd  %xmm12,0x90(%rsp)
    57ab:	00 00 00 
    57ae:	66 45 0f 28 e7       	movapd %xmm15,%xmm12
    57b3:	66 44 0f 28 ec       	movapd %xmm4,%xmm13
    57b8:	f2 44 0f 59 e5       	mulsd  %xmm5,%xmm12
    57bd:	f2 44 0f 5c eb       	subsd  %xmm3,%xmm13
    57c2:	f2 0f 10 9c 24 90 00 	movsd  0x90(%rsp),%xmm3
    57c9:	00 00 
    57cb:	f2 41 0f 59 d8       	mulsd  %xmm8,%xmm3
    57d0:	f2 44 0f 11 ac 24 a8 	movsd  %xmm13,0xa8(%rsp)
    57d7:	00 00 00 
    57da:	f2 41 0f 5c d4       	subsd  %xmm12,%xmm2
    57df:	f2 44 0f 59 e8       	mulsd  %xmm0,%xmm13
    57e4:	f2 44 0f 11 a4 24 a0 	movsd  %xmm12,0xa0(%rsp)
    57eb:	00 00 00 
    57ee:	66 0f 28 e2          	movapd %xmm2,%xmm4
    57f2:	f2 0f 59 e6          	mulsd  %xmm6,%xmm4
    57f6:	f2 0f 5c dc          	subsd  %xmm4,%xmm3
    57fa:	f2 41 0f 58 dd       	addsd  %xmm13,%xmm3
    57ff:	66 44 0f 28 eb       	movapd %xmm3,%xmm13
    5804:	66 0f 54 1d 00 00 00 	andpd  0x0(%rip),%xmm3        # 580c <ayatsuri_model_instance_evaluate+0x170c>
    580b:	00 
			5808: R_X86_64_PC32	.LC8-0x4
    580c:	66 44 0f 2e db       	ucomisd %xmm3,%xmm11
    5811:	0f 82 c9 04 00 00    	jb     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    5817:	f2 44 0f 10 1d 00 00 	movsd  0x0(%rip),%xmm11        # 5820 <ayatsuri_model_instance_evaluate+0x1720>
    581e:	00 00 
			581c: R_X86_64_PC32	.LC40-0x4
    5820:	66 44 0f 2f db       	comisd %xmm3,%xmm11
    5825:	0f 87 b5 04 00 00    	ja     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    582b:	66 0f ef d2          	pxor   %xmm2,%xmm2
    582f:	66 0f ef e4          	pxor   %xmm4,%xmm4
    5833:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    5838:	4c 89 e8             	mov    %r13,%rax
    583b:	f3 0f 5a 94 24 e4 01 	cvtss2sd 0x1e4(%rsp),%xmm2
    5842:	00 00 
    5844:	66 0f 28 da          	movapd %xmm2,%xmm3
    5848:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    584d:	f3 0f 5a a4 24 e8 01 	cvtss2sd 0x1e8(%rsp),%xmm4
    5854:	00 00 
    5856:	66 0f 14 db          	unpcklpd %xmm3,%xmm3
    585a:	b9 f8 ff ff ff       	mov    $0xfffffff8,%ecx
    585f:	f3 44 0f 5a a4 24 ec 	cvtss2sd 0x1ec(%rsp),%xmm12
    5866:	01 00 00 
    5869:	f2 0f 11 94 24 b0 00 	movsd  %xmm2,0xb0(%rsp)
    5870:	00 00 
    5872:	f3 44 0f 5a 9c 24 d8 	cvtss2sd 0x1d8(%rsp),%xmm11
    5879:	01 00 00 
    587c:	66 44 0f 59 c3       	mulpd  %xmm3,%xmm8
    5881:	66 0f 28 dc          	movapd %xmm4,%xmm3
    5885:	66 0f 14 db          	unpcklpd %xmm3,%xmm3
    5889:	66 41 0f 59 d9       	mulpd  %xmm9,%xmm3
    588e:	66 44 0f 28 cd       	movapd %xmm5,%xmm9
    5893:	f2 44 0f 59 cc       	mulsd  %xmm4,%xmm9
    5898:	f2 0f 59 64 24 50    	mulsd  0x50(%rsp),%xmm4
    589e:	66 41 0f 58 d8       	addpd  %xmm8,%xmm3
    58a3:	66 45 0f 28 c4       	movapd %xmm12,%xmm8
    58a8:	66 45 0f 14 c0       	unpcklpd %xmm8,%xmm8
    58ad:	66 45 0f 59 c7       	mulpd  %xmm15,%xmm8
    58b2:	f2 44 0f 10 7c 24 48 	movsd  0x48(%rsp),%xmm15
    58b9:	f2 45 0f 59 fb       	mulsd  %xmm11,%xmm15
    58be:	66 41 0f 58 d8       	addpd  %xmm8,%xmm3
    58c3:	66 44 0f 28 c2       	movapd %xmm2,%xmm8
    58c8:	f2 0f 10 54 24 20    	movsd  0x20(%rsp),%xmm2
    58ce:	66 0f 59 9c 24 c0 00 	mulpd  0xc0(%rsp),%xmm3
    58d5:	00 00 
    58d7:	f2 44 0f 59 c0       	mulsd  %xmm0,%xmm8
    58dc:	0f 29 9c 24 90 03 00 	movaps %xmm3,0x390(%rsp)
    58e3:	00 
    58e4:	66 41 0f 28 d9       	movapd %xmm9,%xmm3
    58e9:	66 45 0f ef c9       	pxor   %xmm9,%xmm9
    58ee:	f3 44 0f 5a 8c 24 e0 	cvtss2sd 0x1e0(%rsp),%xmm9
    58f5:	01 00 00 
    58f8:	f2 41 0f 58 d8       	addsd  %xmm8,%xmm3
    58fd:	f2 44 0f 10 04 24    	movsd  (%rsp),%xmm8
    5903:	f2 45 0f 59 c4       	mulsd  %xmm12,%xmm8
    5908:	f2 44 0f 59 64 24 58 	mulsd  0x58(%rsp),%xmm12
    590f:	f2 41 0f 58 d8       	addsd  %xmm8,%xmm3
    5914:	f2 44 0f 10 44 24 50 	movsd  0x50(%rsp),%xmm8
    591b:	f2 0f 59 da          	mulsd  %xmm2,%xmm3
    591f:	f2 0f 11 9c 24 a0 03 	movsd  %xmm3,0x3a0(%rsp)
    5926:	00 00 
    5928:	66 0f ef db          	pxor   %xmm3,%xmm3
    592c:	f3 0f 5a 9c 24 dc 01 	cvtss2sd 0x1dc(%rsp),%xmm3
    5933:	00 00 
    5935:	f2 44 0f 59 c3       	mulsd  %xmm3,%xmm8
    593a:	f2 45 0f 58 c7       	addsd  %xmm15,%xmm8
    593f:	f2 44 0f 10 7c 24 58 	movsd  0x58(%rsp),%xmm15
    5946:	f2 45 0f 59 f9       	mulsd  %xmm9,%xmm15
    594b:	f2 45 0f 58 c7       	addsd  %xmm15,%xmm8
    5950:	66 45 0f ef ff       	pxor   %xmm15,%xmm15
    5955:	f3 45 0f 5a 7f 48    	cvtss2sd 0x48(%r15),%xmm15
    595b:	f2 44 0f 59 c2       	mulsd  %xmm2,%xmm8
    5960:	f2 45 0f 58 c7       	addsd  %xmm15,%xmm8
    5965:	f2 44 0f 10 bc 24 90 	movsd  0x90(%rsp),%xmm15
    596c:	00 00 00 
    596f:	f2 45 0f 5e fd       	divsd  %xmm13,%xmm15
    5974:	66 41 0f 28 d0       	movapd %xmm8,%xmm2
    5979:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    597e:	f3 44 0f 5a 84 24 cc 	cvtss2sd 0x1cc(%rsp),%xmm8
    5985:	01 00 00 
    5988:	f2 44 0f 11 84 24 90 	movsd  %xmm8,0x90(%rsp)
    598f:	00 00 00 
    5992:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    5997:	f3 44 0f 5a 84 24 d0 	cvtss2sd 0x1d0(%rsp),%xmm8
    599e:	01 00 00 
    59a1:	f2 44 0f 11 84 24 d8 	movsd  %xmm8,0xd8(%rsp)
    59a8:	00 00 00 
    59ab:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    59b0:	f3 45 0f 5a 47 44    	cvtss2sd 0x44(%r15),%xmm8
    59b6:	66 41 0f 14 d7       	unpcklpd %xmm15,%xmm2
    59bb:	66 45 0f ef ff       	pxor   %xmm15,%xmm15
    59c0:	0f 29 94 24 e0 00 00 	movaps %xmm2,0xe0(%rsp)
    59c7:	00 
    59c8:	f2 0f 10 94 24 b0 00 	movsd  0xb0(%rsp),%xmm2
    59cf:	00 00 
    59d1:	f2 0f 59 54 24 48    	mulsd  0x48(%rsp),%xmm2
    59d7:	f3 44 0f 5a bc 24 c8 	cvtss2sd 0x1c8(%rsp),%xmm15
    59de:	01 00 00 
    59e1:	f2 0f 58 e2          	addsd  %xmm2,%xmm4
    59e5:	f2 0f 10 54 24 20    	movsd  0x20(%rsp),%xmm2
    59eb:	f2 41 0f 58 e4       	addsd  %xmm12,%xmm4
    59f0:	66 44 0f 28 e7       	movapd %xmm7,%xmm12
    59f5:	f2 45 0f 59 e3       	mulsd  %xmm11,%xmm12
    59fa:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    59fe:	f2 44 0f 58 c4       	addsd  %xmm4,%xmm8
    5a03:	66 0f 28 e3          	movapd %xmm3,%xmm4
    5a07:	f2 0f 59 e1          	mulsd  %xmm1,%xmm4
    5a0b:	f2 41 0f 58 e4       	addsd  %xmm12,%xmm4
    5a10:	f2 44 0f 10 64 24 40 	movsd  0x40(%rsp),%xmm12
    5a17:	f2 45 0f 59 e1       	mulsd  %xmm9,%xmm12
    5a1c:	f2 41 0f 58 e4       	addsd  %xmm12,%xmm4
    5a21:	f2 44 0f 10 64 24 30 	movsd  0x30(%rsp),%xmm12
    5a28:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    5a2c:	66 44 0f 14 c4       	unpcklpd %xmm4,%xmm8
    5a31:	66 0f 28 e6          	movapd %xmm6,%xmm4
    5a35:	44 0f 11 84 24 a8 03 	movups %xmm8,0x3a8(%rsp)
    5a3c:	00 00 
    5a3e:	f2 41 0f 59 e3       	mulsd  %xmm11,%xmm4
    5a43:	f2 44 0f 59 d8       	mulsd  %xmm0,%xmm11
    5a48:	66 44 0f 28 c4       	movapd %xmm4,%xmm8
    5a4d:	66 41 0f 28 e4       	movapd %xmm12,%xmm4
    5a52:	f2 0f 59 e3          	mulsd  %xmm3,%xmm4
    5a56:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    5a5a:	f2 41 0f 58 e0       	addsd  %xmm8,%xmm4
    5a5f:	f2 44 0f 10 44 24 38 	movsd  0x38(%rsp),%xmm8
    5a66:	48 8b 9c 24 d0 00 00 	mov    0xd0(%rsp),%rbx
    5a6d:	00 
    5a6e:	f2 41 0f 58 db       	addsd  %xmm11,%xmm3
    5a73:	f2 44 0f 10 5c 24 38 	movsd  0x38(%rsp),%xmm11
    5a7a:	f2 45 0f 59 c1       	mulsd  %xmm9,%xmm8
    5a7f:	48 8d 5c 9d 00       	lea    0x0(%rbp,%rbx,4),%rbx
    5a84:	f2 41 0f 58 e0       	addsd  %xmm8,%xmm4
    5a89:	66 44 0f 28 c2       	movapd %xmm2,%xmm8
    5a8e:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    5a92:	f2 0f 10 14 24       	movsd  (%rsp),%xmm2
    5a97:	f2 44 0f 59 ca       	mulsd  %xmm2,%xmm9
    5a9c:	f2 41 0f 58 d9       	addsd  %xmm9,%xmm3
    5aa1:	f2 44 0f 10 4c 24 40 	movsd  0x40(%rsp),%xmm9
    5aa8:	f2 41 0f 59 d8       	mulsd  %xmm8,%xmm3
    5aad:	66 0f 14 e3          	unpcklpd %xmm3,%xmm4
    5ab1:	f2 0f 10 9c 24 a0 00 	movsd  0xa0(%rsp),%xmm3
    5ab8:	00 00 
    5aba:	f2 0f 5c 9c 24 98 00 	subsd  0x98(%rsp),%xmm3
    5ac1:	00 00 
    5ac3:	0f 11 a4 24 b8 03 00 	movups %xmm4,0x3b8(%rsp)
    5aca:	00 
    5acb:	66 0f 28 a4 24 e0 00 	movapd 0xe0(%rsp),%xmm4
    5ad2:	00 00 
    5ad4:	0f 11 a4 24 c8 03 00 	movups %xmm4,0x3c8(%rsp)
    5adb:	00 
    5adc:	f2 41 0f 5e dd       	divsd  %xmm13,%xmm3
    5ae1:	f2 0f 10 a4 24 a8 00 	movsd  0xa8(%rsp),%xmm4
    5ae8:	00 00 
    5aea:	f2 41 0f 5e e5       	divsd  %xmm13,%xmm4
    5aef:	66 0f 14 dc          	unpcklpd %xmm4,%xmm3
    5af3:	66 0f 28 e6          	movapd %xmm6,%xmm4
    5af7:	0f 11 9c 24 d8 03 00 	movups %xmm3,0x3d8(%rsp)
    5afe:	00 
    5aff:	66 41 0f 28 db       	movapd %xmm11,%xmm3
    5b04:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    5b08:	f2 0f 59 d8          	mulsd  %xmm0,%xmm3
    5b0c:	f2 0f 5c dc          	subsd  %xmm4,%xmm3
    5b10:	66 0f 28 e7          	movapd %xmm7,%xmm4
    5b14:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    5b18:	f2 0f 10 94 24 90 00 	movsd  0x90(%rsp),%xmm2
    5b1f:	00 00 
    5b21:	f2 41 0f 5e dd       	divsd  %xmm13,%xmm3
    5b26:	66 44 0f 28 c4       	movapd %xmm4,%xmm8
    5b2b:	66 41 0f 28 e1       	movapd %xmm9,%xmm4
    5b30:	f2 0f 59 e0          	mulsd  %xmm0,%xmm4
    5b34:	f2 44 0f 5c c4       	subsd  %xmm4,%xmm8
    5b39:	66 41 0f 28 e3       	movapd %xmm11,%xmm4
    5b3e:	f2 0f 59 e7          	mulsd  %xmm7,%xmm4
    5b42:	f2 45 0f 5e c5       	divsd  %xmm13,%xmm8
    5b47:	66 41 0f 14 d8       	unpcklpd %xmm8,%xmm3
    5b4c:	0f 11 9c 24 e8 03 00 	movups %xmm3,0x3e8(%rsp)
    5b53:	00 
    5b54:	66 41 0f 28 d9       	movapd %xmm9,%xmm3
    5b59:	f2 0f 59 de          	mulsd  %xmm6,%xmm3
    5b5d:	f2 0f 5c dc          	subsd  %xmm4,%xmm3
    5b61:	66 0f 28 e6          	movapd %xmm6,%xmm4
    5b65:	f2 0f 59 e5          	mulsd  %xmm5,%xmm4
    5b69:	f2 41 0f 5e dd       	divsd  %xmm13,%xmm3
    5b6e:	66 44 0f 28 c4       	movapd %xmm4,%xmm8
    5b73:	66 41 0f 28 e4       	movapd %xmm12,%xmm4
    5b78:	f2 0f 59 e0          	mulsd  %xmm0,%xmm4
    5b7c:	f2 44 0f 5c c4       	subsd  %xmm4,%xmm8
    5b81:	66 0f 28 e0          	movapd %xmm0,%xmm4
    5b85:	f2 0f 59 e1          	mulsd  %xmm1,%xmm4
    5b89:	f2 41 0f 59 c7       	mulsd  %xmm15,%xmm0
    5b8e:	f2 45 0f 5e c5       	divsd  %xmm13,%xmm8
    5b93:	66 41 0f 14 d8       	unpcklpd %xmm8,%xmm3
    5b98:	66 44 0f 28 c4       	movapd %xmm4,%xmm8
    5b9d:	66 41 0f 28 e4       	movapd %xmm12,%xmm4
    5ba2:	0f 11 9c 24 f8 03 00 	movups %xmm3,0x3f8(%rsp)
    5ba9:	00 
    5baa:	f2 0f 59 e7          	mulsd  %xmm7,%xmm4
    5bae:	66 0f 28 df          	movapd %xmm7,%xmm3
    5bb2:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    5bb6:	f2 41 0f 59 ff       	mulsd  %xmm15,%xmm7
    5bbb:	f2 44 0f 59 e2       	mulsd  %xmm2,%xmm12
    5bc0:	f2 0f 59 ea          	mulsd  %xmm2,%xmm5
    5bc4:	f2 44 0f 5c c3       	subsd  %xmm3,%xmm8
    5bc9:	66 0f 28 de          	movapd %xmm6,%xmm3
    5bcd:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
    5bd1:	f2 0f 59 ca          	mulsd  %xmm2,%xmm1
    5bd5:	f2 45 0f 5e c5       	divsd  %xmm13,%xmm8
    5bda:	f2 0f 58 c5          	addsd  %xmm5,%xmm0
    5bde:	f2 41 0f 59 f7       	mulsd  %xmm15,%xmm6
    5be3:	f2 0f 5c e3          	subsd  %xmm3,%xmm4
    5be7:	f2 0f 58 cf          	addsd  %xmm7,%xmm1
    5beb:	66 0f 28 fa          	movapd %xmm2,%xmm7
    5bef:	f2 0f 10 14 24       	movsd  (%rsp),%xmm2
    5bf4:	48 89 14 24          	mov    %rdx,(%rsp)
    5bf8:	f2 41 0f 5e e5       	divsd  %xmm13,%xmm4
    5bfd:	66 41 0f 28 d8       	movapd %xmm8,%xmm3
    5c02:	66 0f 14 dc          	unpcklpd %xmm4,%xmm3
    5c06:	66 41 0f 28 e3       	movapd %xmm11,%xmm4
    5c0b:	0f 11 9c 24 08 04 00 	movups %xmm3,0x408(%rsp)
    5c12:	00 
    5c13:	66 41 0f 28 d9       	movapd %xmm9,%xmm3
    5c18:	f2 44 0f 10 8c 24 d8 	movsd  0xd8(%rsp),%xmm9
    5c1f:	00 00 00 
    5c22:	f2 41 0f 59 d9       	mulsd  %xmm9,%xmm3
    5c27:	f2 41 0f 59 e1       	mulsd  %xmm9,%xmm4
    5c2c:	f2 41 0f 59 d1       	mulsd  %xmm9,%xmm2
    5c31:	f2 0f 58 cb          	addsd  %xmm3,%xmm1
    5c35:	66 41 0f 28 dc       	movapd %xmm12,%xmm3
    5c3a:	f2 0f 58 de          	addsd  %xmm6,%xmm3
    5c3e:	f2 0f 58 c2          	addsd  %xmm2,%xmm0
    5c42:	f2 0f 58 dc          	addsd  %xmm4,%xmm3
    5c46:	f2 0f 11 84 24 28 04 	movsd  %xmm0,0x428(%rsp)
    5c4d:	00 00 
    5c4f:	f2 0f 10 44 24 48    	movsd  0x48(%rsp),%xmm0
    5c55:	f2 41 0f 59 c7       	mulsd  %xmm15,%xmm0
    5c5a:	66 0f 14 cb          	unpcklpd %xmm3,%xmm1
    5c5e:	0f 11 8c 24 18 04 00 	movups %xmm1,0x418(%rsp)
    5c65:	00 
    5c66:	f2 0f 10 4c 24 50    	movsd  0x50(%rsp),%xmm1
    5c6c:	f2 0f 59 cf          	mulsd  %xmm7,%xmm1
    5c70:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    5c74:	f2 0f 10 4c 24 58    	movsd  0x58(%rsp),%xmm1
    5c7a:	f2 41 0f 59 c9       	mulsd  %xmm9,%xmm1
    5c7f:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    5c83:	f2 0f 11 84 24 30 04 	movsd  %xmm0,0x430(%rsp)
    5c8a:	00 00 
    5c8c:	f2 0f 10 08          	movsd  (%rax),%xmm1
    5c90:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 5c98 <ayatsuri_model_instance_evaluate+0x1b98>
    5c97:	00 
			5c94: R_X86_64_PC32	.LC18-0x4
    5c98:	66 0f 28 c1          	movapd %xmm1,%xmm0
    5c9c:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 5ca4 <ayatsuri_model_instance_evaluate+0x1ba4>
    5ca3:	00 
			5ca0: R_X86_64_PC32	.LC8-0x4
    5ca4:	66 0f 2e e8          	ucomisd %xmm0,%xmm5
    5ca8:	72 36                	jb     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    5caa:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 5cb2 <ayatsuri_model_instance_evaluate+0x1bb2>
    5cb1:	00 
			5cae: R_X86_64_PC32	.LC38-0x4
    5cb2:	73 2c                	jae    5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    5cb4:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 5cbc <ayatsuri_model_instance_evaluate+0x1bbc>
    5cbb:	00 
			5cb8: R_X86_64_PC32	.LC39-0x4
    5cbc:	0f 86 de 00 00 00    	jbe    5da0 <ayatsuri_model_instance_evaluate+0x1ca0>
    5cc2:	66 0f ef d2          	pxor   %xmm2,%xmm2
    5cc6:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 5cce <ayatsuri_model_instance_evaluate+0x1bce>
    5ccd:	00 
			5cca: R_X86_64_PC32	.LC33-0x4
    5cce:	66 0f 2f d1          	comisd %xmm1,%xmm2
    5cd2:	77 04                	ja     5cd8 <ayatsuri_model_instance_evaluate+0x1bd8>
    5cd4:	41 0f 28 c6          	movaps %xmm14,%xmm0
    5cd8:	f3 0f 11 03          	movss  %xmm0,(%rbx)
    5cdc:	0f 1f 40 00          	nopl   0x0(%rax)
    5ce0:	41 c6 87 a5 00 00 00 	movb   $0x0,0xa5(%r15)
    5ce7:	00 
    5ce8:	b8 02 00 00 00       	mov    $0x2,%eax
    5ced:	e9 5d e5 ff ff       	jmp    424f <ayatsuri_model_instance_evaluate+0x14f>
    5cf2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    5cf8:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    5cfd:	0f 29 ac 24 90 03 00 	movaps %xmm5,0x390(%rsp)
    5d04:	00 
    5d05:	4c 8d ac 24 90 03 00 	lea    0x390(%rsp),%r13
    5d0c:	00 
    5d0d:	f3 44 0f 5a 9c 24 6c 	cvtss2sd 0x26c(%rsp),%xmm11
    5d14:	02 00 00 
    5d17:	f2 41 0f 59 f4       	mulsd  %xmm12,%xmm6
    5d1c:	f2 0f 11 9c 24 a0 03 	movsd  %xmm3,0x3a0(%rsp)
    5d23:	00 00 
    5d25:	f2 44 0f 11 8c 24 e8 	movsd  %xmm9,0x3e8(%rsp)
    5d2c:	03 00 00 
    5d2f:	f2 45 0f 59 eb       	mulsd  %xmm11,%xmm13
    5d34:	f2 44 0f 59 e4       	mulsd  %xmm4,%xmm12
    5d39:	f2 44 0f 59 d8       	mulsd  %xmm0,%xmm11
    5d3e:	66 0f 14 fe          	unpcklpd %xmm6,%xmm7
    5d42:	66 44 0f 14 e9       	unpcklpd %xmm1,%xmm13
    5d47:	0f 11 bc 24 a8 03 00 	movups %xmm7,0x3a8(%rsp)
    5d4e:	00 
    5d4f:	44 0f 11 ac 24 b8 03 	movups %xmm13,0x3b8(%rsp)
    5d56:	00 00 
    5d58:	66 45 0f 14 c4       	unpcklpd %xmm12,%xmm8
    5d5d:	44 0f 11 84 24 c8 03 	movups %xmm8,0x3c8(%rsp)
    5d64:	00 00 
    5d66:	66 44 0f 14 da       	unpcklpd %xmm2,%xmm11
    5d6b:	44 0f 11 9c 24 d8 03 	movups %xmm11,0x3d8(%rsp)
    5d72:	00 00 
    5d74:	e9 45 ec ff ff       	jmp    49be <ayatsuri_model_instance_evaluate+0x8be>
    5d79:	41 c6 87 a5 00 00 00 	movb   $0x0,0xa5(%r15)
    5d80:	00 
    5d81:	e9 c4 e4 ff ff       	jmp    424a <ayatsuri_model_instance_evaluate+0x14a>
    5d86:	41 c6 87 a5 00 00 00 	movb   $0x0,0xa5(%r15)
    5d8d:	00 
    5d8e:	31 c0                	xor    %eax,%eax
    5d90:	e9 ba e4 ff ff       	jmp    424f <ayatsuri_model_instance_evaluate+0x14f>
    5d95:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    5d9b:	e9 55 ed ff ff       	jmp    4af5 <ayatsuri_model_instance_evaluate+0x9f5>
    5da0:	f2 0f 5a c9          	cvtsd2ss %xmm1,%xmm1
    5da4:	f3 0f 11 0b          	movss  %xmm1,(%rbx)
    5da8:	41 0f 54 ca          	andps  %xmm10,%xmm1
    5dac:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
    5db0:	83 f9 08             	cmp    $0x8,%ecx
    5db3:	0f 86 8b 08 00 00    	jbe    6644 <ayatsuri_model_instance_evaluate+0x2544>
    5db9:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 5dc1 <ayatsuri_model_instance_evaluate+0x1cc1>
    5dc0:	00 
			5dbd: R_X86_64_PC32	.LC35-0x4
    5dc1:	66 0f 2f c8          	comisd %xmm0,%xmm1
    5dc5:	0f 87 15 ff ff ff    	ja     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    5dcb:	48 8b 94 24 70 01 00 	mov    0x170(%rsp),%rdx
    5dd2:	00 
    5dd3:	48 83 c0 08          	add    $0x8,%rax
    5dd7:	48 83 c3 04          	add    $0x4,%rbx
    5ddb:	83 c1 01             	add    $0x1,%ecx
    5dde:	48 39 d0             	cmp    %rdx,%rax
    5de1:	0f 85 a5 fe ff ff    	jne    5c8c <ayatsuri_model_instance_evaluate+0x1b8c>
    5de7:	83 84 24 88 01 00 00 	addl   $0x1,0x188(%rsp)
    5dee:	01 
    5def:	8b 84 24 88 01 00 00 	mov    0x188(%rsp),%eax
    5df6:	48 83 84 24 d0 00 00 	addq   $0x15,0xd0(%rsp)
    5dfd:	00 15 
    5dff:	48 8b 14 24          	mov    (%rsp),%rdx
    5e03:	39 c7                	cmp    %eax,%edi
    5e05:	0f 85 93 f7 ff ff    	jne    559e <ayatsuri_model_instance_evaluate+0x149e>
    5e0b:	48 8b 8c 24 98 01 00 	mov    0x198(%rsp),%rcx
    5e12:	00 
    5e13:	0f b7 c6             	movzwl %si,%eax
    5e16:	8b b4 24 8c 01 00 00 	mov    0x18c(%rsp),%esi
    5e1d:	4c 89 5c 24 40       	mov    %r11,0x40(%rsp)
    5e22:	48 6b c0 48          	imul   $0x48,%rax,%rax
    5e26:	48 8b 9c 24 b8 00 00 	mov    0xb8(%rsp),%rbx
    5e2d:	00 
    5e2e:	4c 89 54 24 38       	mov    %r10,0x38(%rsp)
    5e33:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
    5e38:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
    5e3d:	48 01 f0             	add    %rsi,%rax
    5e40:	48 01 c3             	add    %rax,%rbx
    5e43:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
    5e4a:	00 
    5e4b:	8b 78 0c             	mov    0xc(%rax),%edi
    5e4e:	e8 0d a3 ff ff       	call   160 <pack_rgb>
    5e53:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 5e5b <ayatsuri_model_instance_evaluate+0x1d5b>
    5e5a:	00 
			5e57: R_X86_64_PC32	.LC5-0x4
    5e5b:	66 89 85 fc 00 00 00 	mov    %ax,0xfc(%rbp)
    5e62:	49 8b 47 08          	mov    0x8(%r15),%rax
    5e66:	f2 42 0f 59 04 c0    	mulsd  (%rax,%r8,8),%xmm0
    5e6c:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 5e74 <ayatsuri_model_instance_evaluate+0x1d74>
    5e73:	00 
			5e70: R_X86_64_PC32	.LC6-0x4
    5e74:	e8 00 00 00 00       	call   5e79 <ayatsuri_model_instance_evaluate+0x1d79>
			5e75: R_X86_64_PLT32	floor-0x4
    5e79:	48 8d 7b 30          	lea    0x30(%rbx),%rdi
    5e7d:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    5e81:	66 89 85 fe 00 00 00 	mov    %ax,0xfe(%rbp)
    5e88:	e8 73 a1 ff ff       	call   0 <md>
    5e8d:	f2 0f 10 4c 24 68    	movsd  0x68(%rsp),%xmm1
    5e93:	f2 0f 11 04 24       	movsd  %xmm0,(%rsp)
    5e98:	f2 0f 10 44 24 60    	movsd  0x60(%rsp),%xmm0
    5e9e:	e8 00 00 00 00       	call   5ea3 <ayatsuri_model_instance_evaluate+0x1da3>
			5e9f: R_X86_64_PLT32	hypot-0x4
    5ea3:	f2 0f 10 4c 24 70    	movsd  0x70(%rsp),%xmm1
    5ea9:	e8 00 00 00 00       	call   5eae <ayatsuri_model_instance_evaluate+0x1dae>
			5eaa: R_X86_64_PLT32	hypot-0x4
    5eae:	f2 0f 59 04 24       	mulsd  (%rsp),%xmm0
    5eb3:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 5ebb <ayatsuri_model_instance_evaluate+0x1dbb>
    5eba:	00 
			5eb7: R_X86_64_PC32	.LC9-0x4
    5ebb:	e8 00 00 00 00       	call   5ec0 <ayatsuri_model_instance_evaluate+0x1dc0>
			5ebc: R_X86_64_PLT32	fmin-0x4
    5ec0:	f2 0f 59 05 00 00 00 	mulsd  0x0(%rip),%xmm0        # 5ec8 <ayatsuri_model_instance_evaluate+0x1dc8>
    5ec7:	00 
			5ec4: R_X86_64_PC32	.LC5-0x4
    5ec8:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 5ed0 <ayatsuri_model_instance_evaluate+0x1dd0>
    5ecf:	00 
			5ecc: R_X86_64_PC32	.LC6-0x4
    5ed0:	e8 00 00 00 00       	call   5ed5 <ayatsuri_model_instance_evaluate+0x1dd5>
			5ed1: R_X86_64_PLT32	floor-0x4
    5ed5:	48 8d 7b 40          	lea    0x40(%rbx),%rdi
    5ed9:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    5edd:	66 89 85 00 01 00 00 	mov    %ax,0x100(%rbp)
    5ee4:	e8 17 a1 ff ff       	call   0 <md>
    5ee9:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 5ef1 <ayatsuri_model_instance_evaluate+0x1df1>
    5ef0:	00 
			5eed: R_X86_64_PC32	.LC18-0x4
    5ef1:	66 0f 28 c8          	movapd %xmm0,%xmm1
    5ef5:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 5efd <ayatsuri_model_instance_evaluate+0x1dfd>
    5efc:	00 
			5ef9: R_X86_64_PC32	.LC8-0x4
    5efd:	66 0f 2e f1          	ucomisd %xmm1,%xmm6
    5f01:	0f 82 d9 fd ff ff    	jb     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    5f07:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 5f0f <ayatsuri_model_instance_evaluate+0x1e0f>
    5f0e:	00 
			5f0b: R_X86_64_PC32	.LC38-0x4
    5f0f:	0f 83 cb fd ff ff    	jae    5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    5f15:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 5f1d <ayatsuri_model_instance_evaluate+0x1e1d>
    5f1c:	00 
			5f19: R_X86_64_PC32	.LC39-0x4
    5f1d:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    5f22:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 5f2b <ayatsuri_model_instance_evaluate+0x1e2b>
    5f29:	00 00 
			5f27: R_X86_64_PC32	.LC0-0x4
    5f2b:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
    5f30:	4c 8b 54 24 38       	mov    0x38(%rsp),%r10
    5f35:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 5f3e <ayatsuri_model_instance_evaluate+0x1e3e>
    5f3c:	00 00 
			5f3a: R_X86_64_PC32	.LC1-0x4
    5f3e:	4c 8b 5c 24 40       	mov    0x40(%rsp),%r11
    5f43:	0f 86 86 03 00 00    	jbe    62cf <ayatsuri_model_instance_evaluate+0x21cf>
    5f49:	66 0f ef c9          	pxor   %xmm1,%xmm1
    5f4d:	66 0f 2f c8          	comisd %xmm0,%xmm1
    5f51:	0f 87 fa 06 00 00    	ja     6651 <ayatsuri_model_instance_evaluate+0x2551>
    5f57:	41 0f 28 c6          	movaps %xmm14,%xmm0
    5f5b:	45 8b 46 50          	mov    0x50(%r14),%r8d
    5f5f:	4d 8b 0e             	mov    (%r14),%r9
    5f62:	f3 0f 11 85 38 01 00 	movss  %xmm0,0x138(%rbp)
    5f69:	00 
    5f6a:	41 8b 7e 4c          	mov    0x4c(%r14),%edi
    5f6e:	45 85 c0             	test   %r8d,%r8d
    5f71:	0f 84 61 03 00 00    	je     62d8 <ayatsuri_model_instance_evaluate+0x21d8>
    5f77:	31 f6                	xor    %esi,%esi
    5f79:	eb 0c                	jmp    5f87 <ayatsuri_model_instance_evaluate+0x1e87>
    5f7b:	83 c6 01             	add    $0x1,%esi
    5f7e:	41 39 f0             	cmp    %esi,%r8d
    5f81:	0f 84 51 03 00 00    	je     62d8 <ayatsuri_model_instance_evaluate+0x21d8>
    5f87:	89 f0                	mov    %esi,%eax
    5f89:	44 8b 74 24 18       	mov    0x18(%rsp),%r14d
    5f8e:	c1 e0 05             	shl    $0x5,%eax
    5f91:	48 01 f8             	add    %rdi,%rax
    5f94:	4c 01 c8             	add    %r9,%rax
    5f97:	0f b7 18             	movzwl (%rax),%ebx
    5f9a:	44 39 f3             	cmp    %r14d,%ebx
    5f9d:	75 dc                	jne    5f7b <ayatsuri_model_instance_evaluate+0x1e7b>
    5f9f:	49 8b 77 08          	mov    0x8(%r15),%rsi
    5fa3:	66 0f ef ed          	pxor   %xmm5,%xmm5
    5fa7:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5fab:	66 0f ef e4          	pxor   %xmm4,%xmm4
    5faf:	f3 41 0f 5a 47 34    	cvtss2sd 0x34(%r15),%xmm0
    5fb5:	66 0f ef db          	pxor   %xmm3,%xmm3
    5fb9:	66 0f 6f b4 24 a0 01 	movdqa 0x1a0(%rsp),%xmm6
    5fc0:	00 00 
    5fc2:	4c 8d 8c 24 10 02 00 	lea    0x210(%rsp),%r9
    5fc9:	00 
    5fca:	8b 54 16 08          	mov    0x8(%rsi,%rdx,1),%edx
    5fce:	48 8d ac 24 f0 01 00 	lea    0x1f0(%rsp),%rbp
    5fd5:	00 
    5fd6:	0f 29 b4 24 10 02 00 	movaps %xmm6,0x210(%rsp)
    5fdd:	00 
    5fde:	48 01 d6             	add    %rdx,%rsi
    5fe1:	48 8d 94 24 c8 01 00 	lea    0x1c8(%rsp),%rdx
    5fe8:	00 
    5fe9:	f3 0f 5a 6e 0c       	cvtss2sd 0xc(%rsi),%xmm5
    5fee:	f2 0f 5c e8          	subsd  %xmm0,%xmm5
    5ff2:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5ff6:	f3 0f 5a 66 1c       	cvtss2sd 0x1c(%rsi),%xmm4
    5ffb:	f3 41 0f 5a 47 38    	cvtss2sd 0x38(%r15),%xmm0
    6001:	f2 0f 5c e0          	subsd  %xmm0,%xmm4
    6005:	66 0f ef c0          	pxor   %xmm0,%xmm0
    6009:	4c 8d 76 0c          	lea    0xc(%rsi),%r14
    600d:	f3 0f 5a 5e 2c       	cvtss2sd 0x2c(%rsi),%xmm3
    6012:	f3 41 0f 5a 47 3c    	cvtss2sd 0x3c(%r15),%xmm0
    6018:	f2 0f 5c d8          	subsd  %xmm0,%xmm3
    601c:	48 89 94 24 20 02 00 	mov    %rdx,0x220(%rsp)
    6023:	00 
    6024:	31 d2                	xor    %edx,%edx
    6026:	41 89 d0             	mov    %edx,%r8d
    6029:	48 83 fa 02          	cmp    $0x2,%rdx
    602d:	0f 84 96 06 00 00    	je     66c9 <ayatsuri_model_instance_evaluate+0x25c9>
    6033:	66 0f ef f6          	pxor   %xmm6,%xmm6
    6037:	f3 41 0f 5a 77 40    	cvtss2sd 0x40(%r15),%xmm6
    603d:	49 8b 3c d1          	mov    (%r9,%rdx,8),%rdi
    6041:	66 0f ef c0          	pxor   %xmm0,%xmm0
    6045:	66 0f ef ff          	pxor   %xmm7,%xmm7
    6049:	66 0f ef d2          	pxor   %xmm2,%xmm2
    604d:	47 8d 04 40          	lea    (%r8,%r8,2),%r8d
    6051:	f3 0f 5a 07          	cvtss2sd (%rdi),%xmm0
    6055:	f3 0f 5a 7f 04       	cvtss2sd 0x4(%rdi),%xmm7
    605a:	f3 0f 5a 57 08       	cvtss2sd 0x8(%rdi),%xmm2
    605f:	48 89 f7             	mov    %rsi,%rdi
    6062:	66 0f ef c9          	pxor   %xmm1,%xmm1
    6066:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    606b:	44 89 c3             	mov    %r8d,%ebx
    606e:	48 83 c7 04          	add    $0x4,%rdi
    6072:	f3 0f 5a 4f fc       	cvtss2sd -0x4(%rdi),%xmm1
    6077:	f3 44 0f 5a 47 0c    	cvtss2sd 0xc(%rdi),%xmm8
    607d:	f2 0f 59 c8          	mulsd  %xmm0,%xmm1
    6081:	41 83 c0 01          	add    $0x1,%r8d
    6085:	f2 44 0f 59 c7       	mulsd  %xmm7,%xmm8
    608a:	f2 41 0f 58 c8       	addsd  %xmm8,%xmm1
    608f:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    6094:	f3 44 0f 5a 47 1c    	cvtss2sd 0x1c(%rdi),%xmm8
    609a:	f2 44 0f 59 c2       	mulsd  %xmm2,%xmm8
    609f:	f2 41 0f 58 c8       	addsd  %xmm8,%xmm1
    60a4:	f2 0f 59 ce          	mulsd  %xmm6,%xmm1
    60a8:	f2 0f 11 8c dc e0 02 	movsd  %xmm1,0x2e0(%rsp,%rbx,8)
    60af:	00 00 
    60b1:	4c 39 f7             	cmp    %r14,%rdi
    60b4:	75 ac                	jne    6062 <ayatsuri_model_instance_evaluate+0x1f62>
    60b6:	f2 0f 59 c5          	mulsd  %xmm5,%xmm0
    60ba:	f2 0f 59 fc          	mulsd  %xmm4,%xmm7
    60be:	f2 0f 59 d3          	mulsd  %xmm3,%xmm2
    60c2:	f2 0f 58 c7          	addsd  %xmm7,%xmm0
    60c6:	f2 0f 58 c2          	addsd  %xmm2,%xmm0
    60ca:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
    60ce:	f2 0f 11 44 d5 00    	movsd  %xmm0,0x0(%rbp,%rdx,8)
    60d4:	48 83 fa 02          	cmp    $0x2,%rdx
    60d8:	0f 84 05 02 00 00    	je     62e3 <ayatsuri_model_instance_evaluate+0x21e3>
    60de:	66 0f ef c9          	pxor   %xmm1,%xmm1
    60e2:	f3 41 0f 5a 4c 97 44 	cvtss2sd 0x44(%r15,%rdx,4),%xmm1
    60e9:	f2 0f 58 c8          	addsd  %xmm0,%xmm1
    60ed:	f2 0f 11 4c d5 00    	movsd  %xmm1,0x0(%rbp,%rdx,8)
    60f3:	48 83 c2 01          	add    $0x1,%rdx
    60f7:	e9 2a ff ff ff       	jmp    6026 <ayatsuri_model_instance_evaluate+0x1f26>
    60fc:	0f 1f 40 00          	nopl   0x0(%rax)
    6100:	48 8b 41 10          	mov    0x10(%rcx),%rax
    6104:	48 8b 51 18          	mov    0x18(%rcx),%rdx
    6108:	48 33 46 10          	xor    0x10(%rsi),%rax
    610c:	48 33 56 18          	xor    0x18(%rsi),%rdx
    6110:	48 09 d0             	or     %rdx,%rax
    6113:	0f 85 cc e1 ff ff    	jne    42e5 <ayatsuri_model_instance_evaluate+0x1e5>
    6119:	8b 46 20             	mov    0x20(%rsi),%eax
    611c:	39 41 20             	cmp    %eax,0x20(%rcx)
    611f:	0f 85 c0 e1 ff ff    	jne    42e5 <ayatsuri_model_instance_evaluate+0x1e5>
    6125:	49 39 cf             	cmp    %rcx,%r15
    6128:	0f 82 0a 01 00 00    	jb     6238 <ayatsuri_model_instance_evaluate+0x2138>
    612e:	4c 89 f8             	mov    %r15,%rax
    6131:	48 29 c8             	sub    %rcx,%rax
    6134:	48 83 f8 23          	cmp    $0x23,%rax
    6138:	0f 86 a7 e1 ff ff    	jbe    42e5 <ayatsuri_model_instance_evaluate+0x1e5>
    613e:	4d 39 c7             	cmp    %r8,%r15
    6141:	0f 82 49 01 00 00    	jb     6290 <ayatsuri_model_instance_evaluate+0x2190>
    6147:	4c 89 f8             	mov    %r15,%rax
    614a:	4c 29 c0             	sub    %r8,%rax
    614d:	48 83 f8 17          	cmp    $0x17,%rax
    6151:	0f 86 8e e1 ff ff    	jbe    42e5 <ayatsuri_model_instance_evaluate+0x1e5>
    6157:	41 c6 87 a6 00 00 00 	movb   $0x0,0xa6(%r15)
    615e:	00 
    615f:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
    6164:	31 db                	xor    %ebx,%ebx
    6166:	49 8b 17             	mov    (%r15),%rdx
    6169:	41 0f 11 47 4c       	movups %xmm0,0x4c(%r15)
    616e:	49 8b 40 10          	mov    0x10(%r8),%rax
    6172:	49 89 47 5c          	mov    %rax,0x5c(%r15)
    6176:	f3 41 0f 10 00       	movss  (%r8),%xmm0
    617b:	66 83 7a 0c 00       	cmpw   $0x0,0xc(%rdx)
    6180:	f3 41 0f 11 47 64    	movss  %xmm0,0x64(%r15)
    6186:	f3 41 0f 10 40 0c    	movss  0xc(%r8),%xmm0
    618c:	f3 41 0f 11 47 7c    	movss  %xmm0,0x7c(%r15)
    6192:	f3 41 0f 10 40 04    	movss  0x4(%r8),%xmm0
    6198:	f3 41 0f 11 47 68    	movss  %xmm0,0x68(%r15)
    619e:	f3 41 0f 10 40 10    	movss  0x10(%r8),%xmm0
    61a4:	f3 41 0f 11 87 80 00 	movss  %xmm0,0x80(%r15)
    61ab:	00 00 
    61ad:	f3 41 0f 10 40 08    	movss  0x8(%r8),%xmm0
    61b3:	f3 41 0f 11 47 6c    	movss  %xmm0,0x6c(%r15)
    61b9:	f3 41 0f 10 40 14    	movss  0x14(%r8),%xmm0
    61bf:	f3 41 0f 11 87 84 00 	movss  %xmm0,0x84(%r15)
    61c6:	00 00 
    61c8:	75 16                	jne    61e0 <ayatsuri_model_instance_evaluate+0x20e0>
    61ca:	e9 83 e9 ff ff       	jmp    4b52 <ayatsuri_model_instance_evaluate+0xa52>
    61cf:	90                   	nop
    61d0:	0f b7 42 0c          	movzwl 0xc(%rdx),%eax
    61d4:	48 83 c3 01          	add    $0x1,%rbx
    61d8:	39 c3                	cmp    %eax,%ebx
    61da:	0f 83 72 e9 ff ff    	jae    4b52 <ayatsuri_model_instance_evaluate+0xa52>
    61e0:	8b 4a 14             	mov    0x14(%rdx),%ecx
    61e3:	48 89 d8             	mov    %rbx,%rax
    61e6:	48 c1 e0 04          	shl    $0x4,%rax
    61ea:	48 03 02             	add    (%rdx),%rax
    61ed:	0f b6 44 01 02       	movzbl 0x2(%rcx,%rax,1),%eax
    61f2:	3c 03                	cmp    $0x3,%al
    61f4:	74 1e                	je     6214 <ayatsuri_model_instance_evaluate+0x2114>
    61f6:	84 c0                	test   %al,%al
    61f8:	74 d6                	je     61d0 <ayatsuri_model_instance_evaluate+0x20d0>
    61fa:	41 8b 87 94 00 00 00 	mov    0x94(%r15),%eax
    6201:	31 c9                	xor    %ecx,%ecx
    6203:	83 f8 ff             	cmp    $0xffffffff,%eax
    6206:	0f 95 c1             	setne  %cl
    6209:	01 c8                	add    %ecx,%eax
    620b:	41 89 87 94 00 00 00 	mov    %eax,0x94(%r15)
    6212:	eb bc                	jmp    61d0 <ayatsuri_model_instance_evaluate+0x20d0>
    6214:	45 31 c0             	xor    %r8d,%r8d
    6217:	31 c9                	xor    %ecx,%ecx
    6219:	31 d2                	xor    %edx,%edx
    621b:	41 b9 01 00 00 00    	mov    $0x1,%r9d
    6221:	89 de                	mov    %ebx,%esi
    6223:	4c 89 ff             	mov    %r15,%rdi
    6226:	e8 f5 a3 ff ff       	call   620 <mesh_packet>
    622b:	84 c0                	test   %al,%al
    622d:	0f 84 ad fa ff ff    	je     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    6233:	49 8b 17             	mov    (%r15),%rdx
    6236:	eb c2                	jmp    61fa <ayatsuri_model_instance_evaluate+0x20fa>
    6238:	48 89 c8             	mov    %rcx,%rax
    623b:	4c 29 f8             	sub    %r15,%rax
    623e:	48 3d a7 00 00 00    	cmp    $0xa7,%rax
    6244:	0f 86 9b e0 ff ff    	jbe    42e5 <ayatsuri_model_instance_evaluate+0x1e5>
    624a:	e9 ef fe ff ff       	jmp    613e <ayatsuri_model_instance_evaluate+0x203e>
    624f:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 6257 <ayatsuri_model_instance_evaluate+0x2157>
    6256:	00 
			6253: R_X86_64_PC32	.LC17-0x4
    6257:	66 44 0f 28 c3       	movapd %xmm3,%xmm8
    625c:	66 0f ef c0          	pxor   %xmm0,%xmm0
    6260:	f3 44 0f 7e 0d 00 00 	movq   0x0(%rip),%xmm9        # 6269 <ayatsuri_model_instance_evaluate+0x2169>
    6267:	00 00 
			6265: R_X86_64_PC32	.LC26-0x4
    6269:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 6271 <ayatsuri_model_instance_evaluate+0x2171>
    6270:	00 
			626d: R_X86_64_PC32	.LC9-0x4
    6271:	66 0f ef ff          	pxor   %xmm7,%xmm7
    6275:	44 0f 29 8c 24 80 00 	movaps %xmm9,0x80(%rsp)
    627c:	00 00 
    627e:	e9 cb e1 ff ff       	jmp    444e <ayatsuri_model_instance_evaluate+0x34e>
    6283:	66 0f ef c0          	pxor   %xmm0,%xmm0
    6287:	f2 0f 5a c1          	cvtsd2ss %xmm1,%xmm0
    628b:	e9 14 ec ff ff       	jmp    4ea4 <ayatsuri_model_instance_evaluate+0xda4>
    6290:	4c 89 c0             	mov    %r8,%rax
    6293:	4c 29 f8             	sub    %r15,%rax
    6296:	48 3d a7 00 00 00    	cmp    $0xa7,%rax
    629c:	0f 87 b5 fe ff ff    	ja     6157 <ayatsuri_model_instance_evaluate+0x2057>
    62a2:	e9 3e e0 ff ff       	jmp    42e5 <ayatsuri_model_instance_evaluate+0x1e5>
    62a7:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    62ab:	e9 cf ec ff ff       	jmp    4f7f <ayatsuri_model_instance_evaluate+0xe7f>
    62b0:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 62b8 <ayatsuri_model_instance_evaluate+0x21b8>
    62b7:	00 
			62b4: R_X86_64_PC32	.LC33-0x4
    62b8:	e9 c2 ec ff ff       	jmp    4f7f <ayatsuri_model_instance_evaluate+0xe7f>
    62bd:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    62c1:	e9 4e ed ff ff       	jmp    5014 <ayatsuri_model_instance_evaluate+0xf14>
    62c6:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    62ca:	e9 40 ee ff ff       	jmp    510f <ayatsuri_model_instance_evaluate+0x100f>
    62cf:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    62d3:	e9 83 fc ff ff       	jmp    5f5b <ayatsuri_model_instance_evaluate+0x1e5b>
    62d8:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    62de:	e9 1c e8 ff ff       	jmp    4aff <ayatsuri_model_instance_evaluate+0x9ff>
    62e3:	f2 44 0f 10 9c 24 00 	movsd  0x300(%rsp),%xmm11
    62ea:	03 00 00 
    62ed:	f2 44 0f 10 84 24 08 	movsd  0x308(%rsp),%xmm8
    62f4:	03 00 00 
    62f7:	f2 0f 10 bc 24 18 03 	movsd  0x318(%rsp),%xmm7
    62fe:	00 00 
    6300:	f2 0f 10 84 24 20 03 	movsd  0x320(%rsp),%xmm0
    6307:	00 00 
    6309:	66 41 0f 28 eb       	movapd %xmm11,%xmm5
    630e:	66 41 0f 28 d8       	movapd %xmm8,%xmm3
    6313:	f2 44 0f 10 8c 24 f8 	movsd  0x2f8(%rsp),%xmm9
    631a:	02 00 00 
    631d:	f2 0f 10 a4 24 10 03 	movsd  0x310(%rsp),%xmm4
    6324:	00 00 
    6326:	f2 0f 59 df          	mulsd  %xmm7,%xmm3
    632a:	66 45 0f 28 e8       	movapd %xmm8,%xmm13
    632f:	f2 0f 10 8c 24 e0 02 	movsd  0x2e0(%rsp),%xmm1
    6336:	00 00 
    6338:	f2 0f 10 b4 24 e8 02 	movsd  0x2e8(%rsp),%xmm6
    633f:	00 00 
    6341:	f2 0f 59 e8          	mulsd  %xmm0,%xmm5
    6345:	66 45 0f 28 e1       	movapd %xmm9,%xmm12
    634a:	66 45 0f 28 f9       	movapd %xmm9,%xmm15
    634f:	f2 0f 10 94 24 f0 02 	movsd  0x2f0(%rsp),%xmm2
    6356:	00 00 
    6358:	f2 44 0f 59 e7       	mulsd  %xmm7,%xmm12
    635d:	f2 44 0f 59 f8       	mulsd  %xmm0,%xmm15
    6362:	f2 44 0f 59 ec       	mulsd  %xmm4,%xmm13
    6367:	f2 0f 5c eb          	subsd  %xmm3,%xmm5
    636b:	66 41 0f 28 db       	movapd %xmm11,%xmm3
    6370:	f2 0f 59 dc          	mulsd  %xmm4,%xmm3
    6374:	f2 44 0f 11 7c 24 20 	movsd  %xmm15,0x20(%rsp)
    637b:	f2 0f 11 2c 24       	movsd  %xmm5,(%rsp)
    6380:	f2 44 0f 5c e3       	subsd  %xmm3,%xmm12
    6385:	f2 0f 10 1c 24       	movsd  (%rsp),%xmm3
    638a:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
    638e:	66 41 0f 28 ec       	movapd %xmm12,%xmm5
    6393:	f2 44 0f 11 64 24 30 	movsd  %xmm12,0x30(%rsp)
    639a:	66 45 0f 28 e7       	movapd %xmm15,%xmm12
    639f:	f2 45 0f 5c e5       	subsd  %xmm13,%xmm12
    63a4:	f2 44 0f 59 e6       	mulsd  %xmm6,%xmm12
    63a9:	f2 41 0f 5c dc       	subsd  %xmm12,%xmm3
    63ae:	66 44 0f 28 e5       	movapd %xmm5,%xmm12
    63b3:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 63bb <ayatsuri_model_instance_evaluate+0x22bb>
    63ba:	00 
			63b7: R_X86_64_PC32	.LC18-0x4
    63bb:	f2 44 0f 59 e2       	mulsd  %xmm2,%xmm12
    63c0:	f2 41 0f 58 dc       	addsd  %xmm12,%xmm3
    63c5:	66 44 0f 28 e3       	movapd %xmm3,%xmm12
    63ca:	66 44 0f 54 25 00 00 	andpd  0x0(%rip),%xmm12        # 63d3 <ayatsuri_model_instance_evaluate+0x22d3>
    63d1:	00 00 
			63cf: R_X86_64_PC32	.LC8-0x4
    63d3:	66 41 0f 2e ec       	ucomisd %xmm12,%xmm5
    63d8:	0f 82 02 f9 ff ff    	jb     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    63de:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    63e3:	66 41 0f 2e dc       	ucomisd %xmm12,%xmm3
    63e8:	7a 06                	jp     63f0 <ayatsuri_model_instance_evaluate+0x22f0>
    63ea:	0f 84 f0 f8 ff ff    	je     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    63f0:	66 44 0f 28 fa       	movapd %xmm2,%xmm15
    63f5:	66 44 0f 28 e3       	movapd %xmm3,%xmm12
    63fa:	f2 44 0f 5c 6c 24 20 	subsd  0x20(%rsp),%xmm13
    6401:	31 ff                	xor    %edi,%edi
    6403:	f2 44 0f 59 ff       	mulsd  %xmm7,%xmm15
    6408:	66 45 0f 14 e4       	unpcklpd %xmm12,%xmm12
    640d:	f2 0f 59 f9          	mulsd  %xmm1,%xmm7
    6411:	66 4c 0f 7e fa       	movq   %xmm15,%rdx
    6416:	66 44 0f 28 fe       	movapd %xmm6,%xmm15
    641b:	f2 44 0f 59 f8       	mulsd  %xmm0,%xmm15
    6420:	66 48 0f 6e ea       	movq   %rdx,%xmm5
    6425:	48 8d 94 24 30 02 00 	lea    0x230(%rsp),%rdx
    642c:	00 
    642d:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    6431:	f2 41 0f 5c ef       	subsd  %xmm15,%xmm5
    6436:	f2 44 0f 10 3c 24    	movsd  (%rsp),%xmm15
    643c:	66 44 0f 14 fd       	unpcklpd %xmm5,%xmm15
    6441:	66 41 0f 28 ef       	movapd %xmm15,%xmm5
    6446:	66 44 0f 28 fe       	movapd %xmm6,%xmm15
    644b:	66 41 0f 5e ec       	divpd  %xmm12,%xmm5
    6450:	f2 45 0f 59 f8       	mulsd  %xmm8,%xmm15
    6455:	f2 44 0f 59 c1       	mulsd  %xmm1,%xmm8
    645a:	f2 41 0f 59 cb       	mulsd  %xmm11,%xmm1
    645f:	0f 29 ac 24 90 03 00 	movaps %xmm5,0x390(%rsp)
    6466:	00 
    6467:	66 0f 28 ea          	movapd %xmm2,%xmm5
    646b:	f2 41 0f 59 eb       	mulsd  %xmm11,%xmm5
    6470:	f2 44 0f 5c fd       	subsd  %xmm5,%xmm15
    6475:	66 41 0f 28 ef       	movapd %xmm15,%xmm5
    647a:	66 41 0f 14 ed       	unpcklpd %xmm13,%xmm5
    647f:	66 41 0f 5e ec       	divpd  %xmm12,%xmm5
    6484:	0f 29 ac 24 a0 03 00 	movaps %xmm5,0x3a0(%rsp)
    648b:	00 
    648c:	66 0f 28 ea          	movapd %xmm2,%xmm5
    6490:	f2 0f 59 ec          	mulsd  %xmm4,%xmm5
    6494:	f2 41 0f 59 d1       	mulsd  %xmm9,%xmm2
    6499:	f2 0f 59 e6          	mulsd  %xmm6,%xmm4
    649d:	f2 41 0f 59 f1       	mulsd  %xmm9,%xmm6
    64a2:	f2 0f 5c c5          	subsd  %xmm5,%xmm0
    64a6:	f2 41 0f 5c d0       	subsd  %xmm8,%xmm2
    64ab:	f2 0f 5c e7          	subsd  %xmm7,%xmm4
    64af:	66 0f 14 c2          	unpcklpd %xmm2,%xmm0
    64b3:	66 0f ef d2          	pxor   %xmm2,%xmm2
    64b7:	66 41 0f 5e c4       	divpd  %xmm12,%xmm0
    64bc:	f3 0f 5a 50 08       	cvtss2sd 0x8(%rax),%xmm2
    64c1:	0f 29 84 24 b0 03 00 	movaps %xmm0,0x3b0(%rsp)
    64c8:	00 
    64c9:	f2 0f 10 44 24 30    	movsd  0x30(%rsp),%xmm0
    64cf:	66 0f 14 c4          	unpcklpd %xmm4,%xmm0
    64d3:	66 41 0f 5e c4       	divpd  %xmm12,%xmm0
    64d8:	0f 29 84 24 c0 03 00 	movaps %xmm0,0x3c0(%rsp)
    64df:	00 
    64e0:	66 0f 28 c1          	movapd %xmm1,%xmm0
    64e4:	66 0f ef c9          	pxor   %xmm1,%xmm1
    64e8:	f2 0f 5c c6          	subsd  %xmm6,%xmm0
    64ec:	f3 0f 5a 48 0c       	cvtss2sd 0xc(%rax),%xmm1
    64f1:	f2 0f 5e c3          	divsd  %xmm3,%xmm0
    64f5:	66 0f ef db          	pxor   %xmm3,%xmm3
    64f9:	f3 0f 5a 58 04       	cvtss2sd 0x4(%rax),%xmm3
    64fe:	f2 0f 11 84 24 d0 03 	movsd  %xmm0,0x3d0(%rsp)
    6505:	00 00 
    6507:	f2 41 0f 10 45 00    	movsd  0x0(%r13),%xmm0
    650d:	f2 41 0f 10 65 18    	movsd  0x18(%r13),%xmm4
    6513:	49 83 c5 08          	add    $0x8,%r13
    6517:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    651b:	f2 0f 59 c3          	mulsd  %xmm3,%xmm0
    651f:	f2 0f 58 c4          	addsd  %xmm4,%xmm0
    6523:	f2 41 0f 10 65 28    	movsd  0x28(%r13),%xmm4
    6529:	f2 0f 59 e1          	mulsd  %xmm1,%xmm4
    652d:	f2 0f 58 c4          	addsd  %xmm4,%xmm0
    6531:	f2 0f 11 04 3a       	movsd  %xmm0,(%rdx,%rdi,1)
    6536:	48 83 c7 08          	add    $0x8,%rdi
    653a:	48 83 ff 18          	cmp    $0x18,%rdi
    653e:	75 c7                	jne    6507 <ayatsuri_model_instance_evaluate+0x2407>
    6540:	f2 0f 10 84 24 30 02 	movsd  0x230(%rsp),%xmm0
    6547:	00 00 
    6549:	4d 8b 07             	mov    (%r15),%r8
    654c:	66 0f 57 84 24 80 00 	xorpd  0x80(%rsp),%xmm0
    6553:	00 00 
    6555:	f2 0f 10 8c 24 38 02 	movsd  0x238(%rsp),%xmm1
    655c:	00 00 
    655e:	f2 0f 59 84 24 f0 01 	mulsd  0x1f0(%rsp),%xmm0
    6565:	00 00 
    6567:	41 8b 78 14          	mov    0x14(%r8),%edi
    656b:	f2 0f 59 8c 24 f8 01 	mulsd  0x1f8(%rsp),%xmm1
    6572:	00 00 
    6574:	48 01 f9             	add    %rdi,%rcx
    6577:	49 03 08             	add    (%r8),%rcx
    657a:	0f b6 79 02          	movzbl 0x2(%rcx),%edi
    657e:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    6582:	f2 0f 10 8c 24 40 02 	movsd  0x240(%rsp),%xmm1
    6589:	00 00 
    658b:	f2 0f 59 8c 24 00 02 	mulsd  0x200(%rsp),%xmm1
    6592:	00 00 
    6594:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    6598:	66 0f ef c9          	pxor   %xmm1,%xmm1
    659c:	f3 0f 5a 48 10       	cvtss2sd 0x10(%rax),%xmm1
    65a1:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    65a5:	f2 0f 11 84 24 48 02 	movsd  %xmm0,0x248(%rsp)
    65ac:	00 00 
    65ae:	40 84 ff             	test   %dil,%dil
    65b1:	0f 84 d3 01 00 00    	je     678a <ayatsuri_model_instance_evaluate+0x268a>
    65b7:	40 80 ef 01          	sub    $0x1,%dil
    65bb:	0f 84 bf 01 00 00    	je     6780 <ayatsuri_model_instance_evaluate+0x2680>
    65c1:	0f b7 49 06          	movzwl 0x6(%rcx),%ecx
    65c5:	6b c9 6c             	imul   $0x6c,%ecx,%ecx
    65c8:	81 c1 3c 01 00 00    	add    $0x13c,%ecx
    65ce:	89 cf                	mov    %ecx,%edi
    65d0:	45 31 c0             	xor    %r8d,%r8d
    65d3:	c1 ef 02             	shr    $0x2,%edi
    65d6:	48 8d 3c be          	lea    (%rsi,%rdi,4),%rdi
    65da:	f2 42 0f 10 04 42    	movsd  (%rdx,%r8,2),%xmm0
    65e0:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 65e8 <ayatsuri_model_instance_evaluate+0x24e8>
    65e7:	00 
			65e4: R_X86_64_PC32	.LC18-0x4
    65e8:	66 0f 28 c8          	movapd %xmm0,%xmm1
    65ec:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 65f4 <ayatsuri_model_instance_evaluate+0x24f4>
    65f3:	00 
			65f0: R_X86_64_PC32	.LC8-0x4
    65f4:	66 0f 2e f9          	ucomisd %xmm1,%xmm7
    65f8:	0f 82 e2 f6 ff ff    	jb     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    65fe:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 6606 <ayatsuri_model_instance_evaluate+0x2506>
    6605:	00 
			6602: R_X86_64_PC32	.LC38-0x4
    6606:	0f 83 d4 f6 ff ff    	jae    5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    660c:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 6614 <ayatsuri_model_instance_evaluate+0x2514>
    6613:	00 
			6610: R_X86_64_PC32	.LC39-0x4
    6614:	0f 86 ec 00 00 00    	jbe    6706 <ayatsuri_model_instance_evaluate+0x2606>
    661a:	66 0f ef c9          	pxor   %xmm1,%xmm1
    661e:	66 0f 2f c8          	comisd %xmm0,%xmm1
    6622:	0f 87 d1 00 00 00    	ja     66f9 <ayatsuri_model_instance_evaluate+0x25f9>
    6628:	41 0f 28 c6          	movaps %xmm14,%xmm0
    662c:	f3 42 0f 11 04 07    	movss  %xmm0,(%rdi,%r8,1)
    6632:	e9 a9 f6 ff ff       	jmp    5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    6637:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 663f <ayatsuri_model_instance_evaluate+0x253f>
    663e:	00 
			663b: R_X86_64_PC32	.LC33-0x4
    663f:	e9 cb ea ff ff       	jmp    510f <ayatsuri_model_instance_evaluate+0x100f>
    6644:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 664c <ayatsuri_model_instance_evaluate+0x254c>
    664b:	00 
			6648: R_X86_64_PC32	.LC34-0x4
    664c:	e9 70 f7 ff ff       	jmp    5dc1 <ayatsuri_model_instance_evaluate+0x1cc1>
    6651:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 6659 <ayatsuri_model_instance_evaluate+0x2559>
    6658:	00 
			6655: R_X86_64_PC32	.LC33-0x4
    6659:	e9 fd f8 ff ff       	jmp    5f5b <ayatsuri_model_instance_evaluate+0x1e5b>
    665e:	8b 7e 18             	mov    0x18(%rsi),%edi
    6661:	48 89 14 24          	mov    %rdx,(%rsp)
    6665:	e8 f6 9a ff ff       	call   160 <pack_rgb>
    666a:	48 8b 14 24          	mov    (%rsp),%rdx
    666e:	66 c7 85 f0 00 00 00 	movw   $0x4,0xf0(%rbp)
    6675:	04 00 
    6677:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 6680 <ayatsuri_model_instance_evaluate+0x2580>
    667e:	00 00 
			667c: R_X86_64_PC32	.LC0-0x4
    6680:	66 89 85 ea 00 00 00 	mov    %ax,0xea(%rbp)
    6687:	31 c0                	xor    %eax,%eax
    6689:	8b 7c 06 04          	mov    0x4(%rsi,%rax,1),%edi
    668d:	89 bc 05 c4 00 00 00 	mov    %edi,0xc4(%rbp,%rax,1)
    6694:	48 83 c0 04          	add    $0x4,%rax
    6698:	48 83 f8 14          	cmp    $0x14,%rax
    669c:	75 eb                	jne    6689 <ayatsuri_model_instance_evaluate+0x2589>
    669e:	c7 85 d8 00 00 00 00 	movl   $0x0,0xd8(%rbp)
    66a5:	00 00 00 
    66a8:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    66ae:	e9 42 e4 ff ff       	jmp    4af5 <ayatsuri_model_instance_evaluate+0x9f5>
    66b3:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 66bb <ayatsuri_model_instance_evaluate+0x25bb>
    66ba:	00 
			66b7: R_X86_64_PC32	.LC33-0x4
    66bb:	e9 89 ec ff ff       	jmp    5349 <ayatsuri_model_instance_evaluate+0x1249>
    66c0:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    66c4:	e9 80 ec ff ff       	jmp    5349 <ayatsuri_model_instance_evaluate+0x1249>
    66c9:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 66d1 <ayatsuri_model_instance_evaluate+0x25d1>
    66d0:	00 
			66cd: R_X86_64_PC32	.LC9-0x4
    66d1:	e9 67 f9 ff ff       	jmp    603d <ayatsuri_model_instance_evaluate+0x1f3d>
    66d6:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 66de <ayatsuri_model_instance_evaluate+0x25de>
    66dd:	00 
			66da: R_X86_64_PC32	.LC33-0x4
    66de:	e9 31 e9 ff ff       	jmp    5014 <ayatsuri_model_instance_evaluate+0xf14>
    66e3:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 66eb <ayatsuri_model_instance_evaluate+0x25eb>
    66ea:	00 
			66e7: R_X86_64_PC32	.LC33-0x4
    66eb:	e9 bd ea ff ff       	jmp    51ad <ayatsuri_model_instance_evaluate+0x10ad>
    66f0:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    66f4:	e9 b4 ea ff ff       	jmp    51ad <ayatsuri_model_instance_evaluate+0x10ad>
    66f9:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 6701 <ayatsuri_model_instance_evaluate+0x2601>
    6700:	00 
			66fd: R_X86_64_PC32	.LC33-0x4
    6701:	e9 26 ff ff ff       	jmp    662c <ayatsuri_model_instance_evaluate+0x252c>
    6706:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    670a:	f3 42 0f 11 04 07    	movss  %xmm0,(%rdi,%r8,1)
    6710:	41 0f 54 c2          	andps  %xmm10,%xmm0
    6714:	0f 2f 05 00 00 00 00 	comiss 0x0(%rip),%xmm0        # 671b <ayatsuri_model_instance_evaluate+0x261b>
			6717: R_X86_64_PC32	.LC43-0x4
    671b:	0f 87 bf f5 ff ff    	ja     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    6721:	49 83 c0 04          	add    $0x4,%r8
    6725:	49 83 f8 10          	cmp    $0x10,%r8
    6729:	0f 85 ab fe ff ff    	jne    65da <ayatsuri_model_instance_evaluate+0x24da>
    672f:	66 0f ef c0          	pxor   %xmm0,%xmm0
    6733:	0f 2e 07             	ucomiss (%rdi),%xmm0
    6736:	7a 16                	jp     674e <ayatsuri_model_instance_evaluate+0x264e>
    6738:	75 14                	jne    674e <ayatsuri_model_instance_evaluate+0x264e>
    673a:	0f 2e 47 04          	ucomiss 0x4(%rdi),%xmm0
    673e:	7a 0e                	jp     674e <ayatsuri_model_instance_evaluate+0x264e>
    6740:	75 0c                	jne    674e <ayatsuri_model_instance_evaluate+0x264e>
    6742:	0f 2e 47 08          	ucomiss 0x8(%rdi),%xmm0
    6746:	7a 06                	jp     674e <ayatsuri_model_instance_evaluate+0x264e>
    6748:	0f 84 92 f5 ff ff    	je     5ce0 <ayatsuri_model_instance_evaluate+0x1be0>
    674e:	8b 50 14             	mov    0x14(%rax),%edx
    6751:	89 57 10             	mov    %edx,0x10(%rdi)
    6754:	8b 78 18             	mov    0x18(%rax),%edi
    6757:	e8 04 9a ff ff       	call   160 <pack_rgb>
    675c:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 6765 <ayatsuri_model_instance_evaluate+0x2665>
    6763:	00 00 
			6761: R_X86_64_PC32	.LC0-0x4
    6765:	89 c2                	mov    %eax,%edx
    6767:	8d 41 14             	lea    0x14(%rcx),%eax
    676a:	66 89 14 06          	mov    %dx,(%rsi,%rax,1)
    676e:	66 c7 44 06 02 00 00 	movw   $0x0,0x2(%rsi,%rax,1)
    6775:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    677b:	e9 7f e3 ff ff       	jmp    4aff <ayatsuri_model_instance_evaluate+0x9ff>
    6780:	b9 08 01 00 00       	mov    $0x108,%ecx
    6785:	e9 44 fe ff ff       	jmp    65ce <ayatsuri_model_instance_evaluate+0x24ce>
    678a:	b9 54 00 00 00       	mov    $0x54,%ecx
    678f:	e9 3a fe ff ff       	jmp    65ce <ayatsuri_model_instance_evaluate+0x24ce>
    6794:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    679b:	00 00 00 00 
    679f:	90                   	nop

00000000000067a0 <ayatsuri_model_instance_next>:
    67a0:	48 85 ff             	test   %rdi,%rdi
    67a3:	0f 84 7e 00 00 00    	je     6827 <ayatsuri_model_instance_next+0x87>
    67a9:	80 bf a4 00 00 00 01 	cmpb   $0x1,0xa4(%rdi)
    67b0:	49 89 fa             	mov    %rdi,%r10
    67b3:	75 72                	jne    6827 <ayatsuri_model_instance_next+0x87>
    67b5:	48 85 f6             	test   %rsi,%rsi
    67b8:	74 6d                	je     6827 <ayatsuri_model_instance_next+0x87>
    67ba:	48 3b 77 10          	cmp    0x10(%rdi),%rsi
    67be:	75 67                	jne    6827 <ayatsuri_model_instance_next+0x87>
    67c0:	3b 57 20             	cmp    0x20(%rdi),%edx
    67c3:	75 62                	jne    6827 <ayatsuri_model_instance_next+0x87>
    67c5:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    67cc:	b8 04 00 00 00       	mov    $0x4,%eax
    67d1:	75 4a                	jne    681d <ayatsuri_model_instance_next+0x7d>
    67d3:	80 bf a6 00 00 00 00 	cmpb   $0x0,0xa6(%rdi)
    67da:	c6 87 a5 00 00 00 01 	movb   $0x1,0xa5(%rdi)
    67e1:	74 3d                	je     6820 <ayatsuri_model_instance_next+0x80>
    67e3:	48 85 c9             	test   %rcx,%rcx
    67e6:	74 28                	je     6810 <ayatsuri_model_instance_next+0x70>
    67e8:	4d 85 c0             	test   %r8,%r8
    67eb:	74 23                	je     6810 <ayatsuri_model_instance_next+0x70>
    67ed:	49 39 c8             	cmp    %rcx,%r8
    67f0:	73 3e                	jae    6830 <ayatsuri_model_instance_next+0x90>
    67f2:	48 89 c8             	mov    %rcx,%rax
    67f5:	4c 29 c0             	sub    %r8,%rax
    67f8:	48 83 f8 17          	cmp    $0x17,%rax
    67fc:	76 12                	jbe    6810 <ayatsuri_model_instance_next+0x70>
    67fe:	49 39 ca             	cmp    %rcx,%r10
    6801:	72 3d                	jb     6840 <ayatsuri_model_instance_next+0xa0>
    6803:	4c 89 d0             	mov    %r10,%rax
    6806:	48 29 c8             	sub    %rcx,%rax
    6809:	48 83 f8 03          	cmp    $0x3,%rax
    680d:	77 3f                	ja     684e <ayatsuri_model_instance_next+0xae>
    680f:	90                   	nop
    6810:	41 c6 82 a5 00 00 00 	movb   $0x0,0xa5(%r10)
    6817:	00 
    6818:	b8 01 00 00 00       	mov    $0x1,%eax
    681d:	c3                   	ret
    681e:	66 90                	xchg   %ax,%ax
    6820:	c6 87 a5 00 00 00 00 	movb   $0x0,0xa5(%rdi)
    6827:	b8 03 00 00 00       	mov    $0x3,%eax
    682c:	c3                   	ret
    682d:	0f 1f 00             	nopl   (%rax)
    6830:	4c 89 c0             	mov    %r8,%rax
    6833:	48 29 c8             	sub    %rcx,%rax
    6836:	48 83 f8 03          	cmp    $0x3,%rax
    683a:	76 d4                	jbe    6810 <ayatsuri_model_instance_next+0x70>
    683c:	eb c0                	jmp    67fe <ayatsuri_model_instance_next+0x5e>
    683e:	66 90                	xchg   %ax,%ax
    6840:	48 89 c8             	mov    %rcx,%rax
    6843:	4c 29 d0             	sub    %r10,%rax
    6846:	48 3d a7 00 00 00    	cmp    $0xa7,%rax
    684c:	76 c2                	jbe    6810 <ayatsuri_model_instance_next+0x70>
    684e:	49 8b 3a             	mov    (%r10),%rdi
    6851:	48 39 cf             	cmp    %rcx,%rdi
    6854:	0f 83 e6 01 00 00    	jae    6a40 <ayatsuri_model_instance_next+0x2a0>
    685a:	48 89 c8             	mov    %rcx,%rax
    685d:	48 29 f8             	sub    %rdi,%rax
    6860:	48 83 f8 7f          	cmp    $0x7f,%rax
    6864:	76 aa                	jbe    6810 <ayatsuri_model_instance_next+0x70>
    6866:	49 8b 42 18          	mov    0x18(%r10),%rax
    686a:	49 8b 52 08          	mov    0x8(%r10),%rdx
    686e:	48 85 c0             	test   %rax,%rax
    6871:	74 1d                	je     6890 <ayatsuri_model_instance_next+0xf0>
    6873:	48 39 ca             	cmp    %rcx,%rdx
    6876:	0f 82 34 02 00 00    	jb     6ab0 <ayatsuri_model_instance_next+0x310>
    687c:	48 89 d6             	mov    %rdx,%rsi
    687f:	48 29 ce             	sub    %rcx,%rsi
    6882:	48 83 fe 03          	cmp    $0x3,%rsi
    6886:	76 88                	jbe    6810 <ayatsuri_model_instance_next+0x70>
    6888:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    688f:	00 
    6890:	41 56                	push   %r14
    6892:	41 55                	push   %r13
    6894:	41 54                	push   %r12
    6896:	55                   	push   %rbp
    6897:	53                   	push   %rbx
    6898:	48 83 ec 18          	sub    $0x18,%rsp
    689c:	44 8b 4f 08          	mov    0x8(%rdi),%r9d
    68a0:	48 8b 1f             	mov    (%rdi),%rbx
    68a3:	4d 85 c9             	test   %r9,%r9
    68a6:	74 28                	je     68d0 <ayatsuri_model_instance_next+0x130>
    68a8:	48 39 cb             	cmp    %rcx,%rbx
    68ab:	0f 82 13 02 00 00    	jb     6ac4 <ayatsuri_model_instance_next+0x324>
    68b1:	48 89 de             	mov    %rbx,%rsi
    68b4:	48 29 ce             	sub    %rcx,%rsi
    68b7:	48 83 fe 03          	cmp    $0x3,%rsi
    68bb:	0f 86 aa 01 00 00    	jbe    6a6b <ayatsuri_model_instance_next+0x2cb>
    68c1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    68c8:	00 00 00 00 
    68cc:	0f 1f 40 00          	nopl   0x0(%rax)
    68d0:	4d 39 c2             	cmp    %r8,%r10
    68d3:	0f 82 7f 01 00 00    	jb     6a58 <ayatsuri_model_instance_next+0x2b8>
    68d9:	4c 89 d6             	mov    %r10,%rsi
    68dc:	4c 29 c6             	sub    %r8,%rsi
    68df:	48 83 fe 17          	cmp    $0x17,%rsi
    68e3:	0f 86 82 01 00 00    	jbe    6a6b <ayatsuri_model_instance_next+0x2cb>
    68e9:	4c 39 c7             	cmp    %r8,%rdi
    68ec:	0f 82 e2 01 00 00    	jb     6ad4 <ayatsuri_model_instance_next+0x334>
    68f2:	48 89 fe             	mov    %rdi,%rsi
    68f5:	4c 29 c6             	sub    %r8,%rsi
    68f8:	48 83 fe 17          	cmp    $0x17,%rsi
    68fc:	0f 86 69 01 00 00    	jbe    6a6b <ayatsuri_model_instance_next+0x2cb>
    6902:	48 85 c0             	test   %rax,%rax
    6905:	74 19                	je     6920 <ayatsuri_model_instance_next+0x180>
    6907:	4c 39 c2             	cmp    %r8,%rdx
    690a:	0f 82 d5 01 00 00    	jb     6ae5 <ayatsuri_model_instance_next+0x345>
    6910:	48 89 d0             	mov    %rdx,%rax
    6913:	4c 29 c0             	sub    %r8,%rax
    6916:	48 83 f8 17          	cmp    $0x17,%rax
    691a:	0f 86 4b 01 00 00    	jbe    6a6b <ayatsuri_model_instance_next+0x2cb>
    6920:	4d 85 c9             	test   %r9,%r9
    6923:	74 19                	je     693e <ayatsuri_model_instance_next+0x19e>
    6925:	4c 39 c3             	cmp    %r8,%rbx
    6928:	0f 82 cb 01 00 00    	jb     6af9 <ayatsuri_model_instance_next+0x359>
    692e:	48 89 d8             	mov    %rbx,%rax
    6931:	4c 29 c0             	sub    %r8,%rax
    6934:	48 83 f8 17          	cmp    $0x17,%rax
    6938:	0f 86 2d 01 00 00    	jbe    6a6b <ayatsuri_model_instance_next+0x2cb>
    693e:	8b 29                	mov    (%rcx),%ebp
    6940:	0f b7 77 0c          	movzwl 0xc(%rdi),%esi
    6944:	39 ee                	cmp    %ebp,%esi
    6946:	0f 82 1f 01 00 00    	jb     6a6b <ayatsuri_model_instance_next+0x2cb>
    694c:	39 f5                	cmp    %esi,%ebp
    694e:	0f 83 47 01 00 00    	jae    6a9b <ayatsuri_model_instance_next+0x2fb>
    6954:	44 8b 67 14          	mov    0x14(%rdi),%r12d
    6958:	89 e8                	mov    %ebp,%eax
    695a:	c1 e0 04             	shl    $0x4,%eax
    695d:	49 01 dc             	add    %rbx,%r12
    6960:	49 01 c4             	add    %rax,%r12
    6963:	89 e8                	mov    %ebp,%eax
    6965:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
    6969:	48 8d 44 c2 08       	lea    0x8(%rdx,%rax,8),%rax
    696e:	66 90                	xchg   %ax,%ax
    6970:	45 0f b6 6c 24 02    	movzbl 0x2(%r12),%r13d
    6976:	45 84 ed             	test   %r13b,%r13b
    6979:	0f 84 09 01 00 00    	je     6a88 <ayatsuri_model_instance_next+0x2e8>
    697f:	80 78 09 00          	cmpb   $0x0,0x9(%rax)
    6983:	0f 84 ff 00 00 00    	je     6a88 <ayatsuri_model_instance_next+0x2e8>
    6989:	44 8b 30             	mov    (%rax),%r14d
    698c:	49 01 d6             	add    %rdx,%r14
    698f:	41 80 fd 03          	cmp    $0x3,%r13b
    6993:	0f 85 74 01 00 00    	jne    6b0d <ayatsuri_model_instance_next+0x36d>
    6999:	41 80 7e 55 00       	cmpb   $0x0,0x55(%r14)
    699e:	0f 84 e4 00 00 00    	je     6a88 <ayatsuri_model_instance_next+0x2e8>
    69a4:	89 ee                	mov    %ebp,%esi
    69a6:	4c 89 e2             	mov    %r12,%rdx
    69a9:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
    69ae:	41 bd 04 00 00 00    	mov    $0x4,%r13d
    69b4:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    69b9:	48 89 3c 24          	mov    %rdi,(%rsp)
    69bd:	e8 9e 9b ff ff       	call   560 <node_slot_bytes>
    69c2:	48 8b 3c 24          	mov    (%rsp),%rdi
    69c6:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
    69cb:	89 ee                	mov    %ebp,%esi
    69cd:	41 89 c3             	mov    %eax,%r11d
    69d0:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
    69d5:	4d 8d 4a 64          	lea    0x64(%r10),%r9
    69d9:	8b 47 78             	mov    0x78(%rdi),%eax
    69dc:	85 c0                	test   %eax,%eax
    69de:	74 1b                	je     69fb <ayatsuri_model_instance_next+0x25b>
    69e0:	41 0f b7 44 24 08    	movzwl 0x8(%r12),%eax
    69e6:	8b 57 74             	mov    0x74(%rdi),%edx
    69e9:	c1 e0 02             	shl    $0x2,%eax
    69ec:	48 01 c3             	add    %rax,%rbx
    69ef:	80 3c 13 01          	cmpb   $0x1,(%rbx,%rdx,1)
    69f3:	41 0f 94 c5          	sete   %r13b
    69f7:	41 83 c5 04          	add    $0x4,%r13d
    69fb:	41 0f b7 44 24 06    	movzwl 0x6(%r12),%eax
    6a01:	83 c5 01             	add    $0x1,%ebp
    6a04:	4d 89 30             	mov    %r14,(%r8)
    6a07:	4d 89 48 08          	mov    %r9,0x8(%r8)
    6a0b:	41 88 40 15          	mov    %al,0x15(%r8)
    6a0f:	31 c0                	xor    %eax,%eax
    6a11:	66 41 89 70 10       	mov    %si,0x10(%r8)
    6a16:	66 45 89 58 12       	mov    %r11w,0x12(%r8)
    6a1b:	45 88 68 14          	mov    %r13b,0x14(%r8)
    6a1f:	89 29                	mov    %ebp,(%rcx)
    6a21:	41 c6 82 a5 00 00 00 	movb   $0x0,0xa5(%r10)
    6a28:	00 
    6a29:	48 83 c4 18          	add    $0x18,%rsp
    6a2d:	5b                   	pop    %rbx
    6a2e:	5d                   	pop    %rbp
    6a2f:	41 5c                	pop    %r12
    6a31:	41 5d                	pop    %r13
    6a33:	41 5e                	pop    %r14
    6a35:	c3                   	ret
    6a36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    6a3d:	00 00 00 
    6a40:	48 89 f8             	mov    %rdi,%rax
    6a43:	48 29 c8             	sub    %rcx,%rax
    6a46:	48 83 f8 03          	cmp    $0x3,%rax
    6a4a:	0f 86 c0 fd ff ff    	jbe    6810 <ayatsuri_model_instance_next+0x70>
    6a50:	e9 11 fe ff ff       	jmp    6866 <ayatsuri_model_instance_next+0xc6>
    6a55:	0f 1f 00             	nopl   (%rax)
    6a58:	4c 89 c6             	mov    %r8,%rsi
    6a5b:	4c 29 d6             	sub    %r10,%rsi
    6a5e:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    6a65:	0f 87 7e fe ff ff    	ja     68e9 <ayatsuri_model_instance_next+0x149>
    6a6b:	41 c6 82 a5 00 00 00 	movb   $0x0,0xa5(%r10)
    6a72:	00 
    6a73:	48 83 c4 18          	add    $0x18,%rsp
    6a77:	b8 01 00 00 00       	mov    $0x1,%eax
    6a7c:	5b                   	pop    %rbx
    6a7d:	5d                   	pop    %rbp
    6a7e:	41 5c                	pop    %r12
    6a80:	41 5d                	pop    %r13
    6a82:	41 5e                	pop    %r14
    6a84:	c3                   	ret
    6a85:	0f 1f 00             	nopl   (%rax)
    6a88:	83 c5 01             	add    $0x1,%ebp
    6a8b:	49 83 c4 10          	add    $0x10,%r12
    6a8f:	48 83 c0 18          	add    $0x18,%rax
    6a93:	39 ee                	cmp    %ebp,%esi
    6a95:	0f 85 d5 fe ff ff    	jne    6970 <ayatsuri_model_instance_next+0x1d0>
    6a9b:	89 31                	mov    %esi,(%rcx)
    6a9d:	b8 05 00 00 00       	mov    $0x5,%eax
    6aa2:	41 c6 82 a5 00 00 00 	movb   $0x0,0xa5(%r10)
    6aa9:	00 
    6aaa:	e9 7a ff ff ff       	jmp    6a29 <ayatsuri_model_instance_next+0x289>
    6aaf:	90                   	nop
    6ab0:	48 89 ce             	mov    %rcx,%rsi
    6ab3:	48 29 d6             	sub    %rdx,%rsi
    6ab6:	48 39 c6             	cmp    %rax,%rsi
    6ab9:	0f 82 51 fd ff ff    	jb     6810 <ayatsuri_model_instance_next+0x70>
    6abf:	e9 cc fd ff ff       	jmp    6890 <ayatsuri_model_instance_next+0xf0>
    6ac4:	48 89 ce             	mov    %rcx,%rsi
    6ac7:	48 29 de             	sub    %rbx,%rsi
    6aca:	4c 39 ce             	cmp    %r9,%rsi
    6acd:	72 9c                	jb     6a6b <ayatsuri_model_instance_next+0x2cb>
    6acf:	e9 fc fd ff ff       	jmp    68d0 <ayatsuri_model_instance_next+0x130>
    6ad4:	4c 89 c6             	mov    %r8,%rsi
    6ad7:	48 29 fe             	sub    %rdi,%rsi
    6ada:	48 83 fe 7f          	cmp    $0x7f,%rsi
    6ade:	76 8b                	jbe    6a6b <ayatsuri_model_instance_next+0x2cb>
    6ae0:	e9 1d fe ff ff       	jmp    6902 <ayatsuri_model_instance_next+0x162>
    6ae5:	4c 89 c6             	mov    %r8,%rsi
    6ae8:	48 29 d6             	sub    %rdx,%rsi
    6aeb:	48 39 c6             	cmp    %rax,%rsi
    6aee:	0f 82 77 ff ff ff    	jb     6a6b <ayatsuri_model_instance_next+0x2cb>
    6af4:	e9 27 fe ff ff       	jmp    6920 <ayatsuri_model_instance_next+0x180>
    6af9:	4c 89 c0             	mov    %r8,%rax
    6afc:	48 29 d8             	sub    %rbx,%rax
    6aff:	4c 39 c8             	cmp    %r9,%rax
    6b02:	0f 82 63 ff ff ff    	jb     6a6b <ayatsuri_model_instance_next+0x2cb>
    6b08:	e9 31 fe ff ff       	jmp    693e <ayatsuri_model_instance_next+0x19e>
    6b0d:	89 ee                	mov    %ebp,%esi
    6b0f:	4c 89 e2             	mov    %r12,%rdx
    6b12:	4c 89 44 24 08       	mov    %r8,0x8(%rsp)
    6b17:	48 89 0c 24          	mov    %rcx,(%rsp)
    6b1b:	e8 40 9a ff ff       	call   560 <node_slot_bytes>
    6b20:	41 80 fd 02          	cmp    $0x2,%r13b
    6b24:	48 8b 0c 24          	mov    (%rsp),%rcx
    6b28:	89 ee                	mov    %ebp,%esi
    6b2a:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
    6b2f:	89 c3                	mov    %eax,%ebx
    6b31:	4d 8d 4a 64          	lea    0x64(%r10),%r9
    6b35:	41 89 c3             	mov    %eax,%r11d
    6b38:	0f 85 bd fe ff ff    	jne    69fb <ayatsuri_model_instance_next+0x25b>
    6b3e:	4c 89 e7             	mov    %r12,%rdi
    6b41:	e8 8a 97 ff ff       	call   2d0 <slot_bytes>
    6b46:	39 d8                	cmp    %ebx,%eax
    6b48:	0f 83 ad fe ff ff    	jae    69fb <ayatsuri_model_instance_next+0x25b>
    6b4e:	41 bd 03 00 00 00    	mov    $0x3,%r13d
    6b54:	e9 a2 fe ff ff       	jmp    69fb <ayatsuri_model_instance_next+0x25b>
    6b59:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000006b60 <ayatsuri_model_instance_mesh_view>:
    6b60:	48 89 f8             	mov    %rdi,%rax
    6b63:	48 85 ff             	test   %rdi,%rdi
    6b66:	0f 84 84 00 00 00    	je     6bf0 <ayatsuri_model_instance_mesh_view+0x90>
    6b6c:	80 bf a4 00 00 00 01 	cmpb   $0x1,0xa4(%rdi)
    6b73:	75 7b                	jne    6bf0 <ayatsuri_model_instance_mesh_view+0x90>
    6b75:	48 85 f6             	test   %rsi,%rsi
    6b78:	74 76                	je     6bf0 <ayatsuri_model_instance_mesh_view+0x90>
    6b7a:	48 3b 77 10          	cmp    0x10(%rdi),%rsi
    6b7e:	75 70                	jne    6bf0 <ayatsuri_model_instance_mesh_view+0x90>
    6b80:	3b 57 20             	cmp    0x20(%rdi),%edx
    6b83:	75 6b                	jne    6bf0 <ayatsuri_model_instance_mesh_view+0x90>
    6b85:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    6b8c:	ba 04 00 00 00       	mov    $0x4,%edx
    6b91:	75 62                	jne    6bf5 <ayatsuri_model_instance_mesh_view+0x95>
    6b93:	80 bf a6 00 00 00 00 	cmpb   $0x0,0xa6(%rdi)
    6b9a:	c6 87 a5 00 00 00 01 	movb   $0x1,0xa5(%rdi)
    6ba1:	74 45                	je     6be8 <ayatsuri_model_instance_mesh_view+0x88>
    6ba3:	4d 85 c0             	test   %r8,%r8
    6ba6:	74 2e                	je     6bd6 <ayatsuri_model_instance_mesh_view+0x76>
    6ba8:	48 8b 17             	mov    (%rdi),%rdx
    6bab:	66 3b 4a 0c          	cmp    0xc(%rdx),%cx
    6baf:	73 25                	jae    6bd6 <ayatsuri_model_instance_mesh_view+0x76>
    6bb1:	4c 39 c7             	cmp    %r8,%rdi
    6bb4:	73 4a                	jae    6c00 <ayatsuri_model_instance_mesh_view+0xa0>
    6bb6:	4c 89 c6             	mov    %r8,%rsi
    6bb9:	48 29 fe             	sub    %rdi,%rsi
    6bbc:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    6bc3:	76 11                	jbe    6bd6 <ayatsuri_model_instance_mesh_view+0x76>
    6bc5:	4c 39 c2             	cmp    %r8,%rdx
    6bc8:	72 46                	jb     6c10 <ayatsuri_model_instance_mesh_view+0xb0>
    6bca:	48 89 d6             	mov    %rdx,%rsi
    6bcd:	4c 29 c6             	sub    %r8,%rsi
    6bd0:	48 83 fe 17          	cmp    $0x17,%rsi
    6bd4:	77 46                	ja     6c1c <ayatsuri_model_instance_mesh_view+0xbc>
    6bd6:	ba 01 00 00 00       	mov    $0x1,%edx
    6bdb:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    6be2:	89 d0                	mov    %edx,%eax
    6be4:	c3                   	ret
    6be5:	0f 1f 00             	nopl   (%rax)
    6be8:	c6 87 a5 00 00 00 00 	movb   $0x0,0xa5(%rdi)
    6bef:	90                   	nop
    6bf0:	ba 03 00 00 00       	mov    $0x3,%edx
    6bf5:	89 d0                	mov    %edx,%eax
    6bf7:	c3                   	ret
    6bf8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    6bff:	00 
    6c00:	48 89 fe             	mov    %rdi,%rsi
    6c03:	4c 29 c6             	sub    %r8,%rsi
    6c06:	48 83 fe 17          	cmp    $0x17,%rsi
    6c0a:	76 ca                	jbe    6bd6 <ayatsuri_model_instance_mesh_view+0x76>
    6c0c:	eb b7                	jmp    6bc5 <ayatsuri_model_instance_mesh_view+0x65>
    6c0e:	66 90                	xchg   %ax,%ax
    6c10:	4c 89 c6             	mov    %r8,%rsi
    6c13:	48 29 d6             	sub    %rdx,%rsi
    6c16:	48 83 fe 7f          	cmp    $0x7f,%rsi
    6c1a:	76 ba                	jbe    6bd6 <ayatsuri_model_instance_mesh_view+0x76>
    6c1c:	48 8b 70 18          	mov    0x18(%rax),%rsi
    6c20:	48 8b 78 08          	mov    0x8(%rax),%rdi
    6c24:	48 85 f6             	test   %rsi,%rsi
    6c27:	74 17                	je     6c40 <ayatsuri_model_instance_mesh_view+0xe0>
    6c29:	4c 39 c7             	cmp    %r8,%rdi
    6c2c:	0f 82 de 00 00 00    	jb     6d10 <ayatsuri_model_instance_mesh_view+0x1b0>
    6c32:	48 89 fe             	mov    %rdi,%rsi
    6c35:	4c 29 c6             	sub    %r8,%rsi
    6c38:	48 83 fe 17          	cmp    $0x17,%rsi
    6c3c:	76 98                	jbe    6bd6 <ayatsuri_model_instance_mesh_view+0x76>
    6c3e:	66 90                	xchg   %ax,%ax
    6c40:	8b 72 08             	mov    0x8(%rdx),%esi
    6c43:	4c 8b 12             	mov    (%rdx),%r10
    6c46:	48 85 f6             	test   %rsi,%rsi
    6c49:	0f 85 a1 00 00 00    	jne    6cf0 <ayatsuri_model_instance_mesh_view+0x190>
    6c4f:	49 89 c9             	mov    %rcx,%r9
    6c52:	8b 72 14             	mov    0x14(%rdx),%esi
    6c55:	49 c1 e1 04          	shl    $0x4,%r9
    6c59:	41 81 e1 f0 ff 0f 00 	and    $0xffff0,%r9d
    6c60:	4c 01 ce             	add    %r9,%rsi
    6c63:	4c 01 d6             	add    %r10,%rsi
    6c66:	80 7e 02 03          	cmpb   $0x3,0x2(%rsi)
    6c6a:	0f 85 66 ff ff ff    	jne    6bd6 <ayatsuri_model_instance_mesh_view+0x76>
    6c70:	44 8b 4a 78          	mov    0x78(%rdx),%r9d
    6c74:	45 85 c9             	test   %r9d,%r9d
    6c77:	74 18                	je     6c91 <ayatsuri_model_instance_mesh_view+0x131>
    6c79:	0f b7 76 08          	movzwl 0x8(%rsi),%esi
    6c7d:	8b 52 74             	mov    0x74(%rdx),%edx
    6c80:	c1 e6 02             	shl    $0x2,%esi
    6c83:	49 01 f2             	add    %rsi,%r10
    6c86:	41 80 3c 12 01       	cmpb   $0x1,(%r10,%rdx,1)
    6c8b:	0f 84 45 ff ff ff    	je     6bd6 <ayatsuri_model_instance_mesh_view+0x76>
    6c91:	0f b7 d1             	movzwl %cx,%edx
    6c94:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
    6c98:	48 8d 14 d7          	lea    (%rdi,%rdx,8),%rdx
    6c9c:	80 7a 11 00          	cmpb   $0x0,0x11(%rdx)
    6ca0:	0f 84 30 ff ff ff    	je     6bd6 <ayatsuri_model_instance_mesh_view+0x76>
    6ca6:	8b 52 08             	mov    0x8(%rdx),%edx
    6ca9:	48 01 d7             	add    %rdx,%rdi
    6cac:	0f b6 77 54          	movzbl 0x54(%rdi),%esi
    6cb0:	48 8d 57 54          	lea    0x54(%rdi),%rdx
    6cb4:	66 41 89 48 10       	mov    %cx,0x10(%r8)
    6cb9:	49 89 10             	mov    %rdx,(%r8)
    6cbc:	48 8d 14 f5 00 00 00 	lea    0x0(,%rsi,8),%rdx
    6cc3:	00 
    6cc4:	41 88 70 12          	mov    %sil,0x12(%r8)
    6cc8:	81 e2 f8 07 00 00    	and    $0x7f8,%edx
    6cce:	48 8d 94 17 64 04 00 	lea    0x464(%rdi,%rdx,1),%rdx
    6cd5:	00 
    6cd6:	49 89 50 08          	mov    %rdx,0x8(%r8)
    6cda:	31 d2                	xor    %edx,%edx
    6cdc:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    6ce3:	e9 0d ff ff ff       	jmp    6bf5 <ayatsuri_model_instance_mesh_view+0x95>
    6ce8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    6cef:	00 
    6cf0:	4d 39 c2             	cmp    %r8,%r10
    6cf3:	72 33                	jb     6d28 <ayatsuri_model_instance_mesh_view+0x1c8>
    6cf5:	4c 89 d6             	mov    %r10,%rsi
    6cf8:	4c 29 c6             	sub    %r8,%rsi
    6cfb:	48 83 fe 17          	cmp    $0x17,%rsi
    6cff:	0f 86 d1 fe ff ff    	jbe    6bd6 <ayatsuri_model_instance_mesh_view+0x76>
    6d05:	e9 45 ff ff ff       	jmp    6c4f <ayatsuri_model_instance_mesh_view+0xef>
    6d0a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    6d10:	4d 89 c1             	mov    %r8,%r9
    6d13:	49 29 f9             	sub    %rdi,%r9
    6d16:	49 39 f1             	cmp    %rsi,%r9
    6d19:	0f 82 b7 fe ff ff    	jb     6bd6 <ayatsuri_model_instance_mesh_view+0x76>
    6d1f:	e9 1c ff ff ff       	jmp    6c40 <ayatsuri_model_instance_mesh_view+0xe0>
    6d24:	0f 1f 40 00          	nopl   0x0(%rax)
    6d28:	4d 89 c1             	mov    %r8,%r9
    6d2b:	4d 29 d1             	sub    %r10,%r9
    6d2e:	49 39 f1             	cmp    %rsi,%r9
    6d31:	0f 83 18 ff ff ff    	jae    6c4f <ayatsuri_model_instance_mesh_view+0xef>
    6d37:	e9 9a fe ff ff       	jmp    6bd6 <ayatsuri_model_instance_mesh_view+0x76>
    6d3c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000006d40 <ayatsuri_model_instance_sided_mesh_view>:
    6d40:	48 89 f8             	mov    %rdi,%rax
    6d43:	48 85 ff             	test   %rdi,%rdi
    6d46:	0f 84 84 00 00 00    	je     6dd0 <ayatsuri_model_instance_sided_mesh_view+0x90>
    6d4c:	80 bf a4 00 00 00 01 	cmpb   $0x1,0xa4(%rdi)
    6d53:	75 7b                	jne    6dd0 <ayatsuri_model_instance_sided_mesh_view+0x90>
    6d55:	48 85 f6             	test   %rsi,%rsi
    6d58:	74 76                	je     6dd0 <ayatsuri_model_instance_sided_mesh_view+0x90>
    6d5a:	48 3b 77 10          	cmp    0x10(%rdi),%rsi
    6d5e:	75 70                	jne    6dd0 <ayatsuri_model_instance_sided_mesh_view+0x90>
    6d60:	3b 57 20             	cmp    0x20(%rdi),%edx
    6d63:	75 6b                	jne    6dd0 <ayatsuri_model_instance_sided_mesh_view+0x90>
    6d65:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    6d6c:	ba 04 00 00 00       	mov    $0x4,%edx
    6d71:	75 62                	jne    6dd5 <ayatsuri_model_instance_sided_mesh_view+0x95>
    6d73:	80 bf a6 00 00 00 00 	cmpb   $0x0,0xa6(%rdi)
    6d7a:	c6 87 a5 00 00 00 01 	movb   $0x1,0xa5(%rdi)
    6d81:	74 45                	je     6dc8 <ayatsuri_model_instance_sided_mesh_view+0x88>
    6d83:	4d 85 c0             	test   %r8,%r8
    6d86:	74 2e                	je     6db6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6d88:	48 8b 17             	mov    (%rdi),%rdx
    6d8b:	66 3b 4a 0c          	cmp    0xc(%rdx),%cx
    6d8f:	73 25                	jae    6db6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6d91:	4c 39 c7             	cmp    %r8,%rdi
    6d94:	73 4a                	jae    6de0 <ayatsuri_model_instance_sided_mesh_view+0xa0>
    6d96:	4c 89 c6             	mov    %r8,%rsi
    6d99:	48 29 fe             	sub    %rdi,%rsi
    6d9c:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    6da3:	76 11                	jbe    6db6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6da5:	4c 39 c2             	cmp    %r8,%rdx
    6da8:	72 46                	jb     6df0 <ayatsuri_model_instance_sided_mesh_view+0xb0>
    6daa:	48 89 d6             	mov    %rdx,%rsi
    6dad:	4c 29 c6             	sub    %r8,%rsi
    6db0:	48 83 fe 27          	cmp    $0x27,%rsi
    6db4:	77 46                	ja     6dfc <ayatsuri_model_instance_sided_mesh_view+0xbc>
    6db6:	ba 01 00 00 00       	mov    $0x1,%edx
    6dbb:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    6dc2:	89 d0                	mov    %edx,%eax
    6dc4:	c3                   	ret
    6dc5:	0f 1f 00             	nopl   (%rax)
    6dc8:	c6 87 a5 00 00 00 00 	movb   $0x0,0xa5(%rdi)
    6dcf:	90                   	nop
    6dd0:	ba 03 00 00 00       	mov    $0x3,%edx
    6dd5:	89 d0                	mov    %edx,%eax
    6dd7:	c3                   	ret
    6dd8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    6ddf:	00 
    6de0:	48 89 fe             	mov    %rdi,%rsi
    6de3:	4c 29 c6             	sub    %r8,%rsi
    6de6:	48 83 fe 27          	cmp    $0x27,%rsi
    6dea:	76 ca                	jbe    6db6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6dec:	eb b7                	jmp    6da5 <ayatsuri_model_instance_sided_mesh_view+0x65>
    6dee:	66 90                	xchg   %ax,%ax
    6df0:	4c 89 c6             	mov    %r8,%rsi
    6df3:	48 29 d6             	sub    %rdx,%rsi
    6df6:	48 83 fe 7f          	cmp    $0x7f,%rsi
    6dfa:	76 ba                	jbe    6db6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6dfc:	48 8b 78 18          	mov    0x18(%rax),%rdi
    6e00:	48 8b 70 08          	mov    0x8(%rax),%rsi
    6e04:	48 85 ff             	test   %rdi,%rdi
    6e07:	74 17                	je     6e20 <ayatsuri_model_instance_sided_mesh_view+0xe0>
    6e09:	4c 39 c6             	cmp    %r8,%rsi
    6e0c:	0f 82 fe 00 00 00    	jb     6f10 <ayatsuri_model_instance_sided_mesh_view+0x1d0>
    6e12:	48 89 f7             	mov    %rsi,%rdi
    6e15:	4c 29 c7             	sub    %r8,%rdi
    6e18:	48 83 ff 27          	cmp    $0x27,%rdi
    6e1c:	76 98                	jbe    6db6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6e1e:	66 90                	xchg   %ax,%ax
    6e20:	8b 7a 08             	mov    0x8(%rdx),%edi
    6e23:	4c 8b 0a             	mov    (%rdx),%r9
    6e26:	48 85 ff             	test   %rdi,%rdi
    6e29:	0f 85 c1 00 00 00    	jne    6ef0 <ayatsuri_model_instance_sided_mesh_view+0x1b0>
    6e2f:	49 89 ca             	mov    %rcx,%r10
    6e32:	8b 7a 14             	mov    0x14(%rdx),%edi
    6e35:	49 c1 e2 04          	shl    $0x4,%r10
    6e39:	41 81 e2 f0 ff 0f 00 	and    $0xffff0,%r10d
    6e40:	4c 01 d7             	add    %r10,%rdi
    6e43:	4c 01 cf             	add    %r9,%rdi
    6e46:	80 7f 02 03          	cmpb   $0x3,0x2(%rdi)
    6e4a:	0f 85 66 ff ff ff    	jne    6db6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6e50:	44 8b 52 78          	mov    0x78(%rdx),%r10d
    6e54:	45 85 d2             	test   %r10d,%r10d
    6e57:	0f 84 59 ff ff ff    	je     6db6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6e5d:	0f b7 7f 08          	movzwl 0x8(%rdi),%edi
    6e61:	8b 52 74             	mov    0x74(%rdx),%edx
    6e64:	c1 e7 02             	shl    $0x2,%edi
    6e67:	49 01 f9             	add    %rdi,%r9
    6e6a:	41 80 3c 11 01       	cmpb   $0x1,(%r9,%rdx,1)
    6e6f:	0f 85 41 ff ff ff    	jne    6db6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6e75:	0f b7 d1             	movzwl %cx,%edx
    6e78:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
    6e7c:	48 8d 14 d6          	lea    (%rsi,%rdx,8),%rdx
    6e80:	80 7a 11 00          	cmpb   $0x0,0x11(%rdx)
    6e84:	0f 84 2c ff ff ff    	je     6db6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6e8a:	44 8b 5a 08          	mov    0x8(%rdx),%r11d
    6e8e:	4e 8d 0c 1e          	lea    (%rsi,%r11,1),%r9
    6e92:	41 0f b6 79 54       	movzbl 0x54(%r9),%edi
    6e97:	66 41 89 48 20       	mov    %cx,0x20(%r8)
    6e9c:	8d 14 3f             	lea    (%rdi,%rdi,1),%edx
    6e9f:	41 89 fa             	mov    %edi,%r10d
    6ea2:	01 d7                	add    %edx,%edi
    6ea4:	48 63 d2             	movslq %edx,%rdx
    6ea7:	45 88 50 22          	mov    %r10b,0x22(%r8)
    6eab:	8d 3c bd 6b 04 00 00 	lea    0x46b(,%rdi,4),%edi
    6eb2:	81 e7 f8 1f 00 00    	and    $0x1ff8,%edi
    6eb8:	4c 01 df             	add    %r11,%rdi
    6ebb:	48 01 fe             	add    %rdi,%rsi
    6ebe:	49 8d 79 54          	lea    0x54(%r9),%rdi
    6ec2:	49 89 38             	mov    %rdi,(%r8)
    6ec5:	49 8d bc 91 64 04 00 	lea    0x464(%r9,%rdx,4),%rdi
    6ecc:	00 
    6ecd:	48 8d 14 56          	lea    (%rsi,%rdx,2),%rdx
    6ed1:	49 89 50 18          	mov    %rdx,0x18(%r8)
    6ed5:	31 d2                	xor    %edx,%edx
    6ed7:	49 89 78 08          	mov    %rdi,0x8(%r8)
    6edb:	49 89 70 10          	mov    %rsi,0x10(%r8)
    6edf:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    6ee6:	e9 ea fe ff ff       	jmp    6dd5 <ayatsuri_model_instance_sided_mesh_view+0x95>
    6eeb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    6ef0:	4d 39 c1             	cmp    %r8,%r9
    6ef3:	72 33                	jb     6f28 <ayatsuri_model_instance_sided_mesh_view+0x1e8>
    6ef5:	4c 89 cf             	mov    %r9,%rdi
    6ef8:	4c 29 c7             	sub    %r8,%rdi
    6efb:	48 83 ff 27          	cmp    $0x27,%rdi
    6eff:	0f 86 b1 fe ff ff    	jbe    6db6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6f05:	e9 25 ff ff ff       	jmp    6e2f <ayatsuri_model_instance_sided_mesh_view+0xef>
    6f0a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    6f10:	4d 89 c1             	mov    %r8,%r9
    6f13:	49 29 f1             	sub    %rsi,%r9
    6f16:	49 39 f9             	cmp    %rdi,%r9
    6f19:	0f 82 97 fe ff ff    	jb     6db6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6f1f:	e9 fc fe ff ff       	jmp    6e20 <ayatsuri_model_instance_sided_mesh_view+0xe0>
    6f24:	0f 1f 40 00          	nopl   0x0(%rax)
    6f28:	4d 89 c2             	mov    %r8,%r10
    6f2b:	4d 29 ca             	sub    %r9,%r10
    6f2e:	49 39 fa             	cmp    %rdi,%r10
    6f31:	0f 83 f8 fe ff ff    	jae    6e2f <ayatsuri_model_instance_sided_mesh_view+0xef>
    6f37:	e9 7a fe ff ff       	jmp    6db6 <ayatsuri_model_instance_sided_mesh_view+0x76>
