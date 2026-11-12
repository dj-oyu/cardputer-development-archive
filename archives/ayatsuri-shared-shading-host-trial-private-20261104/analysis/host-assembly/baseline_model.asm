
analysis/host-assembly/baseline_model.o:     file format elf64-x86-64


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

0000000000000300 <ayatsuri_shade_sample.isra.0>:
     300:	41 57                	push   %r15
     302:	41 56                	push   %r14
     304:	45 89 ce             	mov    %r9d,%r14d
     307:	41 55                	push   %r13
     309:	41 89 d5             	mov    %edx,%r13d
     30c:	41 54                	push   %r12
     30e:	49 89 cc             	mov    %rcx,%r12
     311:	55                   	push   %rbp
     312:	89 f5                	mov    %esi,%ebp
     314:	53                   	push   %rbx
     315:	4c 89 c3             	mov    %r8,%rbx
     318:	48 83 ec 38          	sub    $0x38,%rsp
     31c:	0f bf 17             	movswl (%rdi),%edx
     31f:	0f bf 47 04          	movswl 0x4(%rdi),%eax
     323:	f3 0f 11 4c 24 1c    	movss  %xmm1,0x1c(%rsp)
     329:	66 0f ef c9          	pxor   %xmm1,%xmm1
     32d:	f3 0f 2a ca          	cvtsi2ss %edx,%xmm1
     331:	f3 0f 11 44 24 20    	movss  %xmm0,0x20(%rsp)
     337:	0f bf 57 02          	movswl 0x2(%rdi),%edx
     33b:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 343 <ayatsuri_shade_sample.isra.0+0x43>
     342:	00 
			33f: R_X86_64_PC32	.LC14-0x4
     343:	f3 0f 11 6c 24 2c    	movss  %xmm5,0x2c(%rsp)
     349:	f3 0f 11 5c 24 24    	movss  %xmm3,0x24(%rsp)
     34f:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 357 <ayatsuri_shade_sample.isra.0+0x57>
     356:	00 
			353: R_X86_64_PC32	.LC0-0x4
     357:	f3 0f 11 54 24 18    	movss  %xmm2,0x18(%rsp)
     35d:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     361:	f3 0f 11 64 24 28    	movss  %xmm4,0x28(%rsp)
     367:	f3 0f 11 4c 24 0c    	movss  %xmm1,0xc(%rsp)
     36d:	66 0f ef c9          	pxor   %xmm1,%xmm1
     371:	f3 0f 2a ca          	cvtsi2ss %edx,%xmm1
     375:	0f 28 e9             	movaps %xmm1,%xmm5
     378:	66 0f ef c9          	pxor   %xmm1,%xmm1
     37c:	f3 0f 2a c8          	cvtsi2ss %eax,%xmm1
     380:	f3 0f 59 e8          	mulss  %xmm0,%xmm5
     384:	0f 28 f1             	movaps %xmm1,%xmm6
     387:	f3 0f 59 f0          	mulss  %xmm0,%xmm6
     38b:	0f 28 fd             	movaps %xmm5,%xmm7
     38e:	f3 0f 11 6c 24 10    	movss  %xmm5,0x10(%rsp)
     394:	0f 54 fb             	andps  %xmm3,%xmm7
     397:	0f 28 cf             	movaps %xmm7,%xmm1
     39a:	0f 28 c6             	movaps %xmm6,%xmm0
     39d:	f3 0f 11 74 24 14    	movss  %xmm6,0x14(%rsp)
     3a3:	0f 54 c3             	andps  %xmm3,%xmm0
     3a6:	e8 00 00 00 00       	call   3ab <ayatsuri_shade_sample.isra.0+0xab>
			3a7: R_X86_64_PLT32	fmaxf-0x4
     3ab:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
     3b1:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 3b9 <ayatsuri_shade_sample.isra.0+0xb9>
     3b8:	00 
			3b5: R_X86_64_PC32	.LC0-0x4
     3b9:	0f 54 cb             	andps  %xmm3,%xmm1
     3bc:	e8 00 00 00 00       	call   3c1 <ayatsuri_shade_sample.isra.0+0xc1>
			3bd: R_X86_64_PLT32	fmaxf-0x4
     3c1:	66 0f ef c9          	pxor   %xmm1,%xmm1
     3c5:	f3 0f 10 54 24 18    	movss  0x18(%rsp),%xmm2
     3cb:	f3 0f 10 7c 24 1c    	movss  0x1c(%rsp),%xmm7
     3d1:	0f 2f c1             	comiss %xmm1,%xmm0
     3d4:	f3 0f 10 74 24 20    	movss  0x20(%rsp),%xmm6
     3da:	76 11                	jbe    3ed <ayatsuri_shade_sample.isra.0+0xed>
     3dc:	f3 0f 10 0d 00 00 00 	movss  0x0(%rip),%xmm1        # 3e4 <ayatsuri_shade_sample.isra.0+0xe4>
     3e3:	00 
			3e0: R_X86_64_PC32	.LC1-0x4
     3e4:	0f 2e c8             	ucomiss %xmm0,%xmm1
     3e7:	0f 83 c3 02 00 00    	jae    6b0 <ayatsuri_shade_sample.isra.0+0x3b0>
     3ed:	f3 0f 59 7c 24 10    	mulss  0x10(%rsp),%xmm7
     3f3:	66 0f ef c9          	pxor   %xmm1,%xmm1
     3f7:	f3 0f 59 74 24 0c    	mulss  0xc(%rsp),%xmm6
     3fd:	f3 0f 59 54 24 14    	mulss  0x14(%rsp),%xmm2
     403:	f3 0f 58 f7          	addss  %xmm7,%xmm6
     407:	f3 0f 58 d6          	addss  %xmm6,%xmm2
     40b:	0f 28 c2             	movaps %xmm2,%xmm0
     40e:	f3 0f 11 54 24 18    	movss  %xmm2,0x18(%rsp)
     414:	e8 00 00 00 00       	call   419 <ayatsuri_shade_sample.isra.0+0x119>
			415: R_X86_64_PLT32	fmaxf-0x4
     419:	f3 0f 10 54 24 18    	movss  0x18(%rsp),%xmm2
     41f:	66 0f ef c9          	pxor   %xmm1,%xmm1
     423:	0f 57 15 00 00 00 00 	xorps  0x0(%rip),%xmm2        # 42a <ayatsuri_shade_sample.isra.0+0x12a>
			426: R_X86_64_PC32	.LC15-0x4
     42a:	66 41 0f 7e c7       	movd   %xmm0,%r15d
     42f:	0f 28 c2             	movaps %xmm2,%xmm0
     432:	e8 00 00 00 00       	call   437 <ayatsuri_shade_sample.isra.0+0x137>
			433: R_X86_64_PLT32	fmaxf-0x4
     437:	66 0f ef db          	pxor   %xmm3,%xmm3
     43b:	0f 28 d0             	movaps %xmm0,%xmm2
     43e:	45 84 f6             	test   %r14b,%r14b
     441:	74 72                	je     4b5 <ayatsuri_shade_sample.isra.0+0x1b5>
     443:	66 41 0f 6e f7       	movd   %r15d,%xmm6
     448:	0f 2f f3             	comiss %xmm3,%xmm6
     44b:	76 68                	jbe    4b5 <ayatsuri_shade_sample.isra.0+0x1b5>
     44d:	f3 0f 11 44 24 18    	movss  %xmm0,0x18(%rsp)
     453:	f3 0f 10 4c 24 28    	movss  0x28(%rsp),%xmm1
     459:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
     45f:	f3 0f 59 4c 24 10    	mulss  0x10(%rsp),%xmm1
     465:	f3 0f 11 5c 24 1c    	movss  %xmm3,0x1c(%rsp)
     46b:	f3 0f 59 44 24 0c    	mulss  0xc(%rsp),%xmm0
     471:	f3 0f 58 c1          	addss  %xmm1,%xmm0
     475:	f3 0f 10 4c 24 2c    	movss  0x2c(%rsp),%xmm1
     47b:	f3 0f 59 4c 24 14    	mulss  0x14(%rsp),%xmm1
     481:	f3 0f 58 c1          	addss  %xmm1,%xmm0
     485:	0f 28 cb             	movaps %xmm3,%xmm1
     488:	e8 00 00 00 00       	call   48d <ayatsuri_shade_sample.isra.0+0x18d>
			489: R_X86_64_PLT32	fmaxf-0x4
     48d:	66 0f ef db          	pxor   %xmm3,%xmm3
     491:	f3 0f 10 54 24 18    	movss  0x18(%rsp),%xmm2
     497:	0f 2f c3             	comiss %xmm3,%xmm0
     49a:	76 19                	jbe    4b5 <ayatsuri_shade_sample.isra.0+0x1b5>
     49c:	f3 0f 10 4b 0c       	movss  0xc(%rbx),%xmm1
     4a1:	f3 0f 11 54 24 0c    	movss  %xmm2,0xc(%rsp)
     4a7:	e8 00 00 00 00       	call   4ac <ayatsuri_shade_sample.isra.0+0x1ac>
			4a8: R_X86_64_PLT32	powf-0x4
     4ac:	f3 0f 10 54 24 0c    	movss  0xc(%rsp),%xmm2
     4b2:	0f 28 d8             	movaps %xmm0,%xmm3
     4b5:	45 0f b6 ed          	movzbl %r13b,%r13d
     4b9:	66 0f ef c0          	pxor   %xmm0,%xmm0
     4bd:	66 41 0f 6e ff       	movd   %r15d,%xmm7
     4c2:	89 e8                	mov    %ebp,%eax
     4c4:	f3 41 0f 2a c5       	cvtsi2ss %r13d,%xmm0
     4c9:	f3 0f 59 7b 04       	mulss  0x4(%rbx),%xmm7
     4ce:	f3 0f 10 0d 00 00 00 	movss  0x0(%rip),%xmm1        # 4d6 <ayatsuri_shade_sample.isra.0+0x1d6>
     4d5:	00 
			4d2: R_X86_64_PC32	.LC17-0x4
     4d6:	66 c1 e8 0b          	shr    $0xb,%ax
     4da:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 4e2 <ayatsuri_shade_sample.isra.0+0x1e2>
     4e1:	00 
			4de: R_X86_64_PC32	.LC16-0x4
     4e2:	f3 41 0f 10 64 24 18 	movss  0x18(%r12),%xmm4
     4e9:	0f b7 c0             	movzwl %ax,%eax
     4ec:	f3 0f 10 33          	movss  (%rbx),%xmm6
     4f0:	f3 0f 10 6b 08       	movss  0x8(%rbx),%xmm5
     4f5:	f3 0f 59 eb          	mulss  %xmm3,%xmm5
     4f9:	f3 0f 11 74 24 0c    	movss  %xmm6,0xc(%rsp)
     4ff:	f3 0f 11 7c 24 10    	movss  %xmm7,0x10(%rsp)
     505:	f3 0f 59 fc          	mulss  %xmm4,%xmm7
     509:	f3 0f 5c c8          	subss  %xmm0,%xmm1
     50d:	f3 0f 59 4b 10       	mulss  0x10(%rbx),%xmm1
     512:	f3 0f 11 6c 24 14    	movss  %xmm5,0x14(%rsp)
     518:	0f 28 c7             	movaps %xmm7,%xmm0
     51b:	f3 0f 59 ca          	mulss  %xmm2,%xmm1
     51f:	66 0f ef d2          	pxor   %xmm2,%xmm2
     523:	f3 0f 58 c6          	addss  %xmm6,%xmm0
     527:	f3 0f 2a d0          	cvtsi2ss %eax,%xmm2
     52b:	f3 0f 59 15 00 00 00 	mulss  0x0(%rip),%xmm2        # 533 <ayatsuri_shade_sample.isra.0+0x233>
     532:	00 
			52f: R_X86_64_PC32	.LC18-0x4
     533:	f3 0f 59 d0          	mulss  %xmm0,%xmm2
     537:	f3 0f 10 43 14       	movss  0x14(%rbx),%xmm0
     53c:	f3 0f 59 c1          	mulss  %xmm1,%xmm0
     540:	f3 0f 58 c5          	addss  %xmm5,%xmm0
     544:	f3 0f 59 c4          	mulss  %xmm4,%xmm0
     548:	f3 0f 58 d0          	addss  %xmm0,%xmm2
     54c:	66 0f ef c0          	pxor   %xmm0,%xmm0
     550:	0f 2f c2             	comiss %xmm2,%xmm0
     553:	77 26                	ja     57b <ayatsuri_shade_sample.isra.0+0x27b>
     555:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 55d <ayatsuri_shade_sample.isra.0+0x25d>
     55c:	00 
			559: R_X86_64_PC32	.LC17-0x4
     55d:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 565 <ayatsuri_shade_sample.isra.0+0x265>
     564:	00 
			561: R_X86_64_PC32	.LC17-0x4
     565:	f3 0f c2 c2 01       	cmpltss %xmm2,%xmm0
     56a:	0f 54 d8             	andps  %xmm0,%xmm3
     56d:	0f 55 c2             	andnps %xmm2,%xmm0
     570:	0f 56 c3             	orps   %xmm3,%xmm0
     573:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 57b <ayatsuri_shade_sample.isra.0+0x27b>
     57a:	00 
			577: R_X86_64_PC32	.LC19-0x4
     57b:	f3 0f 11 4c 24 18    	movss  %xmm1,0x18(%rsp)
     581:	e8 00 00 00 00       	call   586 <ayatsuri_shade_sample.isra.0+0x286>
			582: R_X86_64_PLT32	lroundf-0x4
     586:	f3 41 0f 10 5c 24 1c 	movss  0x1c(%r12),%xmm3
     58d:	66 0f ef d2          	pxor   %xmm2,%xmm2
     591:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
     597:	49 89 c5             	mov    %rax,%r13
     59a:	89 e8                	mov    %ebp,%eax
     59c:	f3 0f 10 4c 24 18    	movss  0x18(%rsp),%xmm1
     5a2:	f3 0f 59 c3          	mulss  %xmm3,%xmm0
     5a6:	66 c1 e8 05          	shr    $0x5,%ax
     5aa:	83 e0 3f             	and    $0x3f,%eax
     5ad:	f3 0f 58 44 24 0c    	addss  0xc(%rsp),%xmm0
     5b3:	f3 0f 2a d0          	cvtsi2ss %eax,%xmm2
     5b7:	f3 0f 59 15 00 00 00 	mulss  0x0(%rip),%xmm2        # 5bf <ayatsuri_shade_sample.isra.0+0x2bf>
     5be:	00 
			5bb: R_X86_64_PC32	.LC20-0x4
     5bf:	f3 0f 59 d0          	mulss  %xmm0,%xmm2
     5c3:	f3 0f 10 43 18       	movss  0x18(%rbx),%xmm0
     5c8:	f3 0f 59 c1          	mulss  %xmm1,%xmm0
     5cc:	f3 0f 58 44 24 14    	addss  0x14(%rsp),%xmm0
     5d2:	f3 0f 59 c3          	mulss  %xmm3,%xmm0
     5d6:	f3 0f 58 d0          	addss  %xmm0,%xmm2
     5da:	66 0f ef c0          	pxor   %xmm0,%xmm0
     5de:	0f 2f c2             	comiss %xmm2,%xmm0
     5e1:	77 26                	ja     609 <ayatsuri_shade_sample.isra.0+0x309>
     5e3:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 5eb <ayatsuri_shade_sample.isra.0+0x2eb>
     5ea:	00 
			5e7: R_X86_64_PC32	.LC17-0x4
     5eb:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 5f3 <ayatsuri_shade_sample.isra.0+0x2f3>
     5f2:	00 
			5ef: R_X86_64_PC32	.LC17-0x4
     5f3:	f3 0f c2 c2 01       	cmpltss %xmm2,%xmm0
     5f8:	0f 54 d8             	andps  %xmm0,%xmm3
     5fb:	0f 55 c2             	andnps %xmm2,%xmm0
     5fe:	0f 56 c3             	orps   %xmm3,%xmm0
     601:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 609 <ayatsuri_shade_sample.isra.0+0x309>
     608:	00 
			605: R_X86_64_PC32	.LC21-0x4
     609:	f3 0f 11 4c 24 18    	movss  %xmm1,0x18(%rsp)
     60f:	83 e5 1f             	and    $0x1f,%ebp
     612:	e8 00 00 00 00       	call   617 <ayatsuri_shade_sample.isra.0+0x317>
			613: R_X86_64_PLT32	lroundf-0x4
     617:	f3 41 0f 10 5c 24 20 	movss  0x20(%r12),%xmm3
     61e:	66 0f ef c0          	pxor   %xmm0,%xmm0
     622:	f3 0f 10 54 24 10    	movss  0x10(%rsp),%xmm2
     628:	f3 0f 2a c5          	cvtsi2ss %ebp,%xmm0
     62c:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 634 <ayatsuri_shade_sample.isra.0+0x334>
     633:	00 
			630: R_X86_64_PC32	.LC18-0x4
     634:	f3 0f 10 4c 24 18    	movss  0x18(%rsp),%xmm1
     63a:	49 89 c6             	mov    %rax,%r14
     63d:	f3 0f 59 d3          	mulss  %xmm3,%xmm2
     641:	f3 0f 59 4b 1c       	mulss  0x1c(%rbx),%xmm1
     646:	f3 0f 58 54 24 0c    	addss  0xc(%rsp),%xmm2
     64c:	f3 0f 58 4c 24 14    	addss  0x14(%rsp),%xmm1
     652:	f3 0f 59 c2          	mulss  %xmm2,%xmm0
     656:	f3 0f 59 cb          	mulss  %xmm3,%xmm1
     65a:	f3 0f 58 c8          	addss  %xmm0,%xmm1
     65e:	66 0f ef c0          	pxor   %xmm0,%xmm0
     662:	0f 2f c1             	comiss %xmm1,%xmm0
     665:	77 26                	ja     68d <ayatsuri_shade_sample.isra.0+0x38d>
     667:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 66f <ayatsuri_shade_sample.isra.0+0x36f>
     66e:	00 
			66b: R_X86_64_PC32	.LC17-0x4
     66f:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 677 <ayatsuri_shade_sample.isra.0+0x377>
     676:	00 
			673: R_X86_64_PC32	.LC17-0x4
     677:	f3 0f c2 c1 01       	cmpltss %xmm1,%xmm0
     67c:	0f 54 d0             	andps  %xmm0,%xmm2
     67f:	0f 55 c1             	andnps %xmm1,%xmm0
     682:	0f 56 c2             	orps   %xmm2,%xmm0
     685:	f3 0f 59 05 00 00 00 	mulss  0x0(%rip),%xmm0        # 68d <ayatsuri_shade_sample.isra.0+0x38d>
     68c:	00 
			689: R_X86_64_PC32	.LC19-0x4
     68d:	e8 00 00 00 00       	call   692 <ayatsuri_shade_sample.isra.0+0x392>
			68e: R_X86_64_PLT32	lroundf-0x4
     692:	41 c1 e6 05          	shl    $0x5,%r14d
     696:	41 c1 e5 0b          	shl    $0xb,%r13d
     69a:	48 83 c4 38          	add    $0x38,%rsp
     69e:	45 09 f5             	or     %r14d,%r13d
     6a1:	5b                   	pop    %rbx
     6a2:	5d                   	pop    %rbp
     6a3:	44 09 e8             	or     %r13d,%eax
     6a6:	41 5c                	pop    %r12
     6a8:	41 5d                	pop    %r13
     6aa:	41 5e                	pop    %r14
     6ac:	41 5f                	pop    %r15
     6ae:	c3                   	ret
     6af:	90                   	nop
     6b0:	f3 0f 10 64 24 0c    	movss  0xc(%rsp),%xmm4
     6b6:	f3 0f 10 5c 24 10    	movss  0x10(%rsp),%xmm3
     6bc:	f3 0f 10 4c 24 14    	movss  0x14(%rsp),%xmm1
     6c2:	f3 0f 5e d8          	divss  %xmm0,%xmm3
     6c6:	f3 0f 5e e0          	divss  %xmm0,%xmm4
     6ca:	0f 28 eb             	movaps %xmm3,%xmm5
     6cd:	f3 0f 59 eb          	mulss  %xmm3,%xmm5
     6d1:	f3 0f 5e c8          	divss  %xmm0,%xmm1
     6d5:	0f 28 c4             	movaps %xmm4,%xmm0
     6d8:	f3 0f 59 c4          	mulss  %xmm4,%xmm0
     6dc:	f3 0f 58 c5          	addss  %xmm5,%xmm0
     6e0:	0f 28 e9             	movaps %xmm1,%xmm5
     6e3:	f3 0f 59 e9          	mulss  %xmm1,%xmm5
     6e7:	f3 0f 58 c5          	addss  %xmm5,%xmm0
     6eb:	f3 0f 51 c0          	sqrtss %xmm0,%xmm0
     6ef:	f3 0f 5e e0          	divss  %xmm0,%xmm4
     6f3:	f3 0f 5e d8          	divss  %xmm0,%xmm3
     6f7:	f3 0f 11 64 24 0c    	movss  %xmm4,0xc(%rsp)
     6fd:	f3 0f 5e c8          	divss  %xmm0,%xmm1
     701:	f3 0f 11 5c 24 10    	movss  %xmm3,0x10(%rsp)
     707:	f3 0f 11 4c 24 14    	movss  %xmm1,0x14(%rsp)
     70d:	e9 db fc ff ff       	jmp    3ed <ayatsuri_shade_sample.isra.0+0xed>
     712:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     719:	00 00 00 00 
     71d:	0f 1f 00             	nopl   (%rax)

0000000000000720 <node_slot_bytes>:
     720:	0f b6 42 02          	movzbl 0x2(%rdx),%eax
     724:	89 f1                	mov    %esi,%ecx
     726:	3c 03                	cmp    $0x3,%al
     728:	74 2e                	je     758 <node_slot_bytes+0x38>
     72a:	be 54 00 00 00       	mov    $0x54,%esi
     72f:	84 c0                	test   %al,%al
     731:	74 1d                	je     750 <node_slot_bytes+0x30>
     733:	be 08 01 00 00       	mov    $0x108,%esi
     738:	3c 01                	cmp    $0x1,%al
     73a:	74 14                	je     750 <node_slot_bytes+0x30>
     73c:	44 0f b7 42 06       	movzwl 0x6(%rdx),%r8d
     741:	45 6b c0 6c          	imul   $0x6c,%r8d,%r8d
     745:	41 8d b0 3c 01 00 00 	lea    0x13c(%r8),%esi
     74c:	3c 02                	cmp    $0x2,%al
     74e:	74 58                	je     7a8 <node_slot_bytes+0x88>
     750:	89 f0                	mov    %esi,%eax
     752:	c3                   	ret
     753:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
     758:	0f b7 42 04          	movzwl 0x4(%rdx),%eax
     75c:	48 8b 0f             	mov    (%rdi),%rcx
     75f:	8b 77 54             	mov    0x54(%rdi),%esi
     762:	44 8b 47 78          	mov    0x78(%rdi),%r8d
     766:	c1 e0 05             	shl    $0x5,%eax
     769:	48 01 c8             	add    %rcx,%rax
     76c:	0f b7 44 06 02       	movzwl 0x2(%rsi,%rax,1),%eax
     771:	8d 34 40             	lea    (%rax,%rax,2),%esi
     774:	8d 34 b5 6b 04 00 00 	lea    0x46b(,%rsi,4),%esi
     77b:	83 e6 f8             	and    $0xfffffff8,%esi
     77e:	45 85 c0             	test   %r8d,%r8d
     781:	74 cd                	je     750 <node_slot_bytes+0x30>
     783:	0f b7 52 08          	movzwl 0x8(%rdx),%edx
     787:	8b 7f 74             	mov    0x74(%rdi),%edi
     78a:	c1 e2 02             	shl    $0x2,%edx
     78d:	48 01 d1             	add    %rdx,%rcx
     790:	80 3c 39 01          	cmpb   $0x1,(%rcx,%rdi,1)
     794:	75 ba                	jne    750 <node_slot_bytes+0x30>
     796:	8d 04 85 0f 00 00 00 	lea    0xf(,%rax,4),%eax
     79d:	83 e0 f8             	and    $0xfffffff8,%eax
     7a0:	01 c6                	add    %eax,%esi
     7a2:	89 f0                	mov    %esi,%eax
     7a4:	c3                   	ret
     7a5:	0f 1f 00             	nopl   (%rax)
     7a8:	4c 8b 0f             	mov    (%rdi),%r9
     7ab:	8b 47 4c             	mov    0x4c(%rdi),%eax
     7ae:	8b 7f 50             	mov    0x50(%rdi),%edi
     7b1:	85 ff                	test   %edi,%edi
     7b3:	74 9b                	je     750 <node_slot_bytes+0x30>
     7b5:	31 d2                	xor    %edx,%edx
     7b7:	49 01 c1             	add    %rax,%r9
     7ba:	eb 0b                	jmp    7c7 <node_slot_bytes+0xa7>
     7bc:	0f 1f 40 00          	nopl   0x0(%rax)
     7c0:	83 c2 01             	add    $0x1,%edx
     7c3:	39 d7                	cmp    %edx,%edi
     7c5:	74 89                	je     750 <node_slot_bytes+0x30>
     7c7:	89 d0                	mov    %edx,%eax
     7c9:	c1 e0 05             	shl    $0x5,%eax
     7cc:	41 0f b7 04 01       	movzwl (%r9,%rax,1),%eax
     7d1:	39 c1                	cmp    %eax,%ecx
     7d3:	75 eb                	jne    7c0 <node_slot_bytes+0xa0>
     7d5:	41 8d b0 54 01 00 00 	lea    0x154(%r8),%esi
     7dc:	89 f0                	mov    %esi,%eax
     7de:	c3                   	ret
     7df:	90                   	nop

00000000000007e0 <mesh_packet>:
     7e0:	41 57                	push   %r15
     7e2:	49 89 fa             	mov    %rdi,%r10
     7e5:	41 56                	push   %r14
     7e7:	45 89 ce             	mov    %r9d,%r14d
     7ea:	41 55                	push   %r13
     7ec:	41 54                	push   %r12
     7ee:	55                   	push   %rbp
     7ef:	53                   	push   %rbx
     7f0:	48 81 ec 78 05 00 00 	sub    $0x578,%rsp
     7f7:	4c 8b 3f             	mov    (%rdi),%r15
     7fa:	89 f7                	mov    %esi,%edi
     7fc:	44 88 8c 24 fb 00 00 	mov    %r9b,0xfb(%rsp)
     803:	00 
     804:	c1 e7 04             	shl    $0x4,%edi
     807:	45 8b 4f 14          	mov    0x14(%r15),%r9d
     80b:	49 8b 07             	mov    (%r15),%rax
     80e:	c7 44 24 64 00 00 00 	movl   $0x0,0x64(%rsp)
     815:	00 
     816:	49 01 f9             	add    %rdi,%r9
     819:	49 01 c1             	add    %rax,%r9
     81c:	41 80 79 02 03       	cmpb   $0x3,0x2(%r9)
     821:	41 0f b7 79 08       	movzwl 0x8(%r9),%edi
     826:	0f 84 1c 04 00 00    	je     c48 <mesh_packet+0x468>
     82c:	49 8b 6a 08          	mov    0x8(%r10),%rbp
     830:	89 f6                	mov    %esi,%esi
     832:	66 0f ef ed          	pxor   %xmm5,%xmm5
     836:	66 45 0f ef c9       	pxor   %xmm9,%xmm9
     83b:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
     83f:	66 0f ef ff          	pxor   %xmm7,%xmm7
     843:	66 45 0f ef d2       	pxor   %xmm10,%xmm10
     848:	48 8d 1c f5 00 00 00 	lea    0x0(,%rsi,8),%rbx
     84f:	00 
     850:	8b 74 f5 08          	mov    0x8(%rbp,%rsi,8),%esi
     854:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
     859:	66 0f ef f6          	pxor   %xmm6,%xmm6
     85d:	66 45 0f ef f6       	pxor   %xmm14,%xmm14
     862:	66 0f ef db          	pxor   %xmm3,%xmm3
     866:	66 45 0f ef ff       	pxor   %xmm15,%xmm15
     86b:	48 89 9c 24 c8 00 00 	mov    %rbx,0xc8(%rsp)
     872:	00 
     873:	48 01 f5             	add    %rsi,%rbp
     876:	f3 0f 5a 6d 14       	cvtss2sd 0x14(%rbp),%xmm5
     87b:	66 0f 28 cd          	movapd %xmm5,%xmm1
     87f:	f3 44 0f 5a 4d 18    	cvtss2sd 0x18(%rbp),%xmm9
     885:	f3 0f 5a 7d 28       	cvtss2sd 0x28(%rbp),%xmm7
     88a:	66 41 0f 28 c1       	movapd %xmm9,%xmm0
     88f:	f3 0f 5a 75 20       	cvtss2sd 0x20(%rbp),%xmm6
     894:	66 45 0f 28 e9       	movapd %xmm9,%xmm13
     899:	f3 44 0f 5a 55 24    	cvtss2sd 0x24(%rbp),%xmm10
     89f:	f2 0f 59 cf          	mulsd  %xmm7,%xmm1
     8a3:	f3 44 0f 5a 45 10    	cvtss2sd 0x10(%rbp),%xmm8
     8a9:	66 41 0f 28 e0       	movapd %xmm8,%xmm4
     8ae:	f3 44 0f 5a 75 00    	cvtss2sd 0x0(%rbp),%xmm14
     8b4:	f2 41 0f 59 c2       	mulsd  %xmm10,%xmm0
     8b9:	f3 0f 5a 5d 04       	cvtss2sd 0x4(%rbp),%xmm3
     8be:	f3 44 0f 5a 7d 08    	cvtss2sd 0x8(%rbp),%xmm15
     8c4:	f2 0f 59 e7          	mulsd  %xmm7,%xmm4
     8c8:	f2 44 0f 59 ee       	mulsd  %xmm6,%xmm13
     8cd:	66 0f 28 d1          	movapd %xmm1,%xmm2
     8d1:	66 41 0f 28 c8       	movapd %xmm8,%xmm1
     8d6:	f2 0f 5c d0          	subsd  %xmm0,%xmm2
     8da:	f2 41 0f 59 ca       	mulsd  %xmm10,%xmm1
     8df:	66 0f 28 c5          	movapd %xmm5,%xmm0
     8e3:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
     8e7:	f2 44 0f 11 6c 24 08 	movsd  %xmm13,0x8(%rsp)
     8ee:	f2 0f 11 14 24       	movsd  %xmm2,(%rsp)
     8f3:	f2 41 0f 59 d6       	mulsd  %xmm14,%xmm2
     8f8:	f2 0f 5c c8          	subsd  %xmm0,%xmm1
     8fc:	66 0f 28 c4          	movapd %xmm4,%xmm0
     900:	f2 41 0f 5c c5       	subsd  %xmm13,%xmm0
     905:	f2 0f 11 4c 24 40    	movsd  %xmm1,0x40(%rsp)
     90b:	f2 41 0f 59 cf       	mulsd  %xmm15,%xmm1
     910:	f2 0f 59 c3          	mulsd  %xmm3,%xmm0
     914:	f2 0f 5c d0          	subsd  %xmm0,%xmm2
     918:	f2 0f 58 d1          	addsd  %xmm1,%xmm2
     91c:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 924 <mesh_packet+0x144>
     923:	00 
			920: R_X86_64_PC32	.LC22-0x4
     924:	f2 0f 11 94 24 d8 00 	movsd  %xmm2,0xd8(%rsp)
     92b:	00 00 
     92d:	66 0f 28 c2          	movapd %xmm2,%xmm0
     931:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 939 <mesh_packet+0x159>
     938:	00 
			935: R_X86_64_PC32	.LC8-0x4
     939:	66 0f 2e c8          	ucomisd %xmm0,%xmm1
     93d:	0f 82 ed 02 00 00    	jb     c30 <mesh_packet+0x450>
     943:	66 0f ef c0          	pxor   %xmm0,%xmm0
     947:	66 0f 2e d0          	ucomisd %xmm0,%xmm2
     94b:	7a 06                	jp     953 <mesh_packet+0x173>
     94d:	0f 84 dd 02 00 00    	je     c30 <mesh_packet+0x450>
     953:	41 0f b7 59 04       	movzwl 0x4(%r9),%ebx
     958:	41 8b 77 54          	mov    0x54(%r15),%esi
     95c:	f3 44 0f 10 1d 00 00 	movss  0x0(%rip),%xmm11        # 965 <mesh_packet+0x185>
     963:	00 00 
			961: R_X86_64_PC32	.LC0-0x4
     965:	45 8b 67 34          	mov    0x34(%r15),%r12d
     969:	c1 e3 05             	shl    $0x5,%ebx
     96c:	48 01 f3             	add    %rsi,%rbx
     96f:	48 01 c3             	add    %rax,%rbx
     972:	0f b7 73 02          	movzwl 0x2(%rbx),%esi
     976:	66 89 b4 24 fc 00 00 	mov    %si,0xfc(%rsp)
     97d:	00 
     97e:	0f b7 73 06          	movzwl 0x6(%rbx),%esi
     982:	66 89 b4 24 fe 00 00 	mov    %si,0xfe(%rsp)
     989:	00 
     98a:	45 84 f6             	test   %r14b,%r14b
     98d:	0f 85 a7 01 00 00    	jne    b3a <mesh_packet+0x35a>
     993:	f3 0f 10 45 0c       	movss  0xc(%rbp),%xmm0
     998:	f3 41 0f 5c 42 34    	subss  0x34(%r10),%xmm0
     99e:	31 f6                	xor    %esi,%esi
     9a0:	4c 8d 8c 24 40 01 00 	lea    0x140(%rsp),%r9
     9a7:	00 
     9a8:	44 89 64 24 20       	mov    %r12d,0x20(%rsp)
     9ad:	f3 44 0f 10 6d 1c    	movss  0x1c(%rbp),%xmm13
     9b3:	4c 8d 5d 0c          	lea    0xc(%rbp),%r11
     9b7:	41 89 f4             	mov    %esi,%r12d
     9ba:	48 89 8c 24 78 03 00 	mov    %rcx,0x378(%rsp)
     9c1:	00 
     9c2:	f3 44 0f 10 65 2c    	movss  0x2c(%rbp),%xmm12
     9c8:	4c 89 c9             	mov    %r9,%rcx
     9cb:	4c 8d ac 24 70 03 00 	lea    0x370(%rsp),%r13
     9d2:	00 
     9d3:	4c 89 84 24 80 03 00 	mov    %r8,0x380(%rsp)
     9da:	00 
     9db:	f3 45 0f 5c 6a 38    	subss  0x38(%r10),%xmm13
     9e1:	4d 89 c8             	mov    %r9,%r8
     9e4:	48 89 94 24 70 03 00 	mov    %rdx,0x370(%rsp)
     9eb:	00 
     9ec:	f3 45 0f 5c 62 3c    	subss  0x3c(%r10),%xmm12
     9f2:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
     9f7:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
     9fd:	f2 0f 11 64 24 18    	movsd  %xmm4,0x18(%rsp)
     a03:	f2 44 0f 11 74 24 30 	movsd  %xmm14,0x30(%rsp)
     a0a:	48 83 fe 02          	cmp    $0x2,%rsi
     a0e:	0f 84 b1 00 00 00    	je     ac5 <mesh_packet+0x2e5>
     a14:	f3 45 0f 10 5a 40    	movss  0x40(%r10),%xmm11
     a1a:	49 8b 54 f5 00       	mov    0x0(%r13,%rsi,8),%rdx
     a1f:	41 c1 e4 02          	shl    $0x2,%r12d
     a23:	f3 0f 10 22          	movss  (%rdx),%xmm4
     a27:	f3 0f 10 4a 04       	movss  0x4(%rdx),%xmm1
     a2c:	f3 0f 10 52 08       	movss  0x8(%rdx),%xmm2
     a31:	48 89 ea             	mov    %rbp,%rdx
     a34:	f3 44 0f 10 32       	movss  (%rdx),%xmm14
     a39:	f3 0f 10 42 10       	movss  0x10(%rdx),%xmm0
     a3e:	44 89 e0             	mov    %r12d,%eax
     a41:	48 83 c2 04          	add    $0x4,%rdx
     a45:	41 83 c4 01          	add    $0x1,%r12d
     a49:	f3 44 0f 59 f4       	mulss  %xmm4,%xmm14
     a4e:	f3 0f 59 c1          	mulss  %xmm1,%xmm0
     a52:	f3 41 0f 58 c6       	addss  %xmm14,%xmm0
     a57:	f3 44 0f 10 72 1c    	movss  0x1c(%rdx),%xmm14
     a5d:	f3 44 0f 59 f2       	mulss  %xmm2,%xmm14
     a62:	f3 41 0f 58 c6       	addss  %xmm14,%xmm0
     a67:	f3 41 0f 59 c3       	mulss  %xmm11,%xmm0
     a6c:	f3 0f 11 84 84 40 01 	movss  %xmm0,0x140(%rsp,%rax,4)
     a73:	00 00 
     a75:	49 39 d3             	cmp    %rdx,%r11
     a78:	75 ba                	jne    a34 <mesh_packet+0x254>
     a7a:	f3 0f 59 64 24 10    	mulss  0x10(%rsp),%xmm4
     a80:	48 83 c6 01          	add    $0x1,%rsi
     a84:	49 83 c0 10          	add    $0x10,%r8
     a88:	f3 41 0f 59 cd       	mulss  %xmm13,%xmm1
     a8d:	f3 41 0f 59 d4       	mulss  %xmm12,%xmm2
     a92:	f3 0f 58 cc          	addss  %xmm4,%xmm1
     a96:	f3 0f 58 ca          	addss  %xmm2,%xmm1
     a9a:	f3 41 0f 59 cb       	mulss  %xmm11,%xmm1
     a9f:	f3 41 0f 11 48 fc    	movss  %xmm1,-0x4(%r8)
     aa5:	48 83 fe 03          	cmp    $0x3,%rsi
     aa9:	74 2d                	je     ad8 <mesh_packet+0x2f8>
     aab:	f3 41 0f 58 4c b2 40 	addss  0x40(%r10,%rsi,4),%xmm1
     ab2:	41 89 f4             	mov    %esi,%r12d
     ab5:	f3 41 0f 11 48 fc    	movss  %xmm1,-0x4(%r8)
     abb:	48 83 fe 02          	cmp    $0x2,%rsi
     abf:	0f 85 4f ff ff ff    	jne    a14 <mesh_packet+0x234>
     ac5:	f3 44 0f 10 1d 00 00 	movss  0x0(%rip),%xmm11        # ace <mesh_packet+0x2ee>
     acc:	00 00 
			aca: R_X86_64_PC32	.LC17-0x4
     ace:	e9 47 ff ff ff       	jmp    a1a <mesh_packet+0x23a>
     ad3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
     ad8:	f2 0f 10 64 24 18    	movsd  0x18(%rsp),%xmm4
     ade:	f2 44 0f 10 74 24 30 	movsd  0x30(%rsp),%xmm14
     ae5:	49 83 c1 30          	add    $0x30,%r9
     ae9:	f3 44 0f 10 1d 00 00 	movss  0x0(%rip),%xmm11        # af2 <mesh_packet+0x312>
     af0:	00 00 
			aee: R_X86_64_PC32	.LC0-0x4
     af2:	44 8b 64 24 20       	mov    0x20(%rsp),%r12d
     af7:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
     afc:	f3 0f 10 0d 00 00 00 	movss  0x0(%rip),%xmm1        # b04 <mesh_packet+0x324>
     b03:	00 
			b00: R_X86_64_PC32	.LC1-0x4
     b04:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     b0b:	00 00 00 00 
     b0f:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     b16:	00 00 00 00 
     b1a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
     b20:	f3 0f 10 01          	movss  (%rcx),%xmm0
     b24:	41 0f 54 c3          	andps  %xmm11,%xmm0
     b28:	0f 2e c8             	ucomiss %xmm0,%xmm1
     b2b:	0f 82 ff 00 00 00    	jb     c30 <mesh_packet+0x450>
     b31:	48 83 c1 04          	add    $0x4,%rcx
     b35:	49 39 c9             	cmp    %rcx,%r9
     b38:	75 e6                	jne    b20 <mesh_packet+0x340>
     b3a:	48 8d 14 ff          	lea    (%rdi,%rdi,8),%rdx
     b3e:	f3 41 0f 10 4a 64    	movss  0x64(%r10),%xmm1
     b44:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
     b49:	49 8d 14 d4          	lea    (%r12,%rdx,8),%rdx
     b4d:	f2 0f 11 5c 24 78    	movsd  %xmm3,0x78(%rsp)
     b53:	48 01 c2             	add    %rax,%rdx
     b56:	f3 0f 11 4c 24 10    	movss  %xmm1,0x10(%rsp)
     b5c:	f3 0f 6f 02          	movdqu (%rdx),%xmm0
     b60:	4c 89 54 24 38       	mov    %r10,0x38(%rsp)
     b65:	f2 0f 11 ac 24 90 00 	movsd  %xmm5,0x90(%rsp)
     b6c:	00 00 
     b6e:	f3 41 0f 10 6a 68    	movss  0x68(%r10),%xmm5
     b74:	f2 0f 11 b4 24 b0 00 	movsd  %xmm6,0xb0(%rsp)
     b7b:	00 00 
     b7d:	f3 41 0f 10 72 6c    	movss  0x6c(%r10),%xmm6
     b83:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
     b8a:	00 
     b8b:	f3 0f 6f 42 10       	movdqu 0x10(%rdx),%xmm0
     b90:	0f 28 dd             	movaps %xmm5,%xmm3
     b93:	41 0f 54 db          	andps  %xmm11,%xmm3
     b97:	f2 0f 11 64 24 68    	movsd  %xmm4,0x68(%rsp)
     b9d:	0f 29 84 24 30 01 00 	movaps %xmm0,0x130(%rsp)
     ba4:	00 
     ba5:	0f 28 c6             	movaps %xmm6,%xmm0
     ba8:	0f 28 cb             	movaps %xmm3,%xmm1
     bab:	41 0f 54 c3          	andps  %xmm11,%xmm0
     baf:	f3 0f 11 6c 24 18    	movss  %xmm5,0x18(%rsp)
     bb5:	f2 0f 11 bc 24 d0 00 	movsd  %xmm7,0xd0(%rsp)
     bbc:	00 00 
     bbe:	f2 44 0f 11 94 24 c0 	movsd  %xmm10,0xc0(%rsp)
     bc5:	00 00 00 
     bc8:	f2 44 0f 11 8c 24 a0 	movsd  %xmm9,0xa0(%rsp)
     bcf:	00 00 00 
     bd2:	f2 44 0f 11 84 24 88 	movsd  %xmm8,0x88(%rsp)
     bd9:	00 00 00 
     bdc:	f2 44 0f 11 bc 24 80 	movsd  %xmm15,0x80(%rsp)
     be3:	00 00 00 
     be6:	f2 44 0f 11 74 24 70 	movsd  %xmm14,0x70(%rsp)
     bed:	f3 0f 11 74 24 30    	movss  %xmm6,0x30(%rsp)
     bf3:	44 0f 29 5c 24 20    	movaps %xmm11,0x20(%rsp)
     bf9:	e8 00 00 00 00       	call   bfe <mesh_packet+0x41e>
			bfa: R_X86_64_PLT32	fmaxf-0x4
     bfe:	44 0f 28 5c 24 20    	movaps 0x20(%rsp),%xmm11
     c04:	f3 0f 10 4c 24 10    	movss  0x10(%rsp),%xmm1
     c0a:	41 0f 54 cb          	andps  %xmm11,%xmm1
     c0e:	e8 00 00 00 00       	call   c13 <mesh_packet+0x433>
			c0f: R_X86_64_PLT32	fmaxf-0x4
     c13:	66 0f ef ff          	pxor   %xmm7,%xmm7
     c17:	0f 2f c7             	comiss %xmm7,%xmm0
     c1a:	76 14                	jbe    c30 <mesh_packet+0x450>
     c1c:	f3 0f 10 3d 00 00 00 	movss  0x0(%rip),%xmm7        # c24 <mesh_packet+0x444>
     c23:	00 
			c20: R_X86_64_PC32	.LC1-0x4
     c24:	f3 0f 11 44 24 50    	movss  %xmm0,0x50(%rsp)
     c2a:	0f 2e f8             	ucomiss %xmm0,%xmm7
     c2d:	73 51                	jae    c80 <mesh_packet+0x4a0>
     c2f:	90                   	nop
     c30:	31 c0                	xor    %eax,%eax
     c32:	48 81 c4 78 05 00 00 	add    $0x578,%rsp
     c39:	5b                   	pop    %rbx
     c3a:	5d                   	pop    %rbp
     c3b:	41 5c                	pop    %r12
     c3d:	41 5d                	pop    %r13
     c3f:	41 5e                	pop    %r14
     c41:	41 5f                	pop    %r15
     c43:	c3                   	ret
     c44:	0f 1f 40 00          	nopl   0x0(%rax)
     c48:	45 8b 5f 78          	mov    0x78(%r15),%r11d
     c4c:	45 85 db             	test   %r11d,%r11d
     c4f:	0f 84 d7 fb ff ff    	je     82c <mesh_packet+0x4c>
     c55:	41 8b 5f 74          	mov    0x74(%r15),%ebx
     c59:	4c 8d 1c bd 00 00 00 	lea    0x0(,%rdi,4),%r11
     c60:	00 
     c61:	41 81 e3 fc ff 03 00 	and    $0x3fffc,%r11d
     c68:	48 01 c3             	add    %rax,%rbx
     c6b:	42 80 3c 1b 01       	cmpb   $0x1,(%rbx,%r11,1)
     c70:	0f 94 c3             	sete   %bl
     c73:	0f b6 db             	movzbl %bl,%ebx
     c76:	89 5c 24 64          	mov    %ebx,0x64(%rsp)
     c7a:	e9 ad fb ff ff       	jmp    82c <mesh_packet+0x4c>
     c7f:	90                   	nop
     c80:	4c 8b 54 24 38       	mov    0x38(%rsp),%r10
     c85:	44 0f 28 5c 24 20    	movaps 0x20(%rsp),%xmm11
     c8b:	45 8b 62 74          	mov    0x74(%r10),%r12d
     c8f:	45 8b 6a 78          	mov    0x78(%r10),%r13d
     c93:	4c 89 94 24 e8 00 00 	mov    %r10,0xe8(%rsp)
     c9a:	00 
     c9b:	f3 41 0f 10 7a 70    	movss  0x70(%r10),%xmm7
     ca1:	66 41 0f 6e e4       	movd   %r12d,%xmm4
     ca6:	f3 0f 11 bc 24 e0 00 	movss  %xmm7,0xe0(%rsp)
     cad:	00 00 
     caf:	41 0f 54 e3          	andps  %xmm11,%xmm4
     cb3:	0f 28 cc             	movaps %xmm4,%xmm1
     cb6:	66 41 0f 6e e5       	movd   %r13d,%xmm4
     cbb:	41 0f 54 e3          	andps  %xmm11,%xmm4
     cbf:	0f 28 c4             	movaps %xmm4,%xmm0
     cc2:	e8 00 00 00 00       	call   cc7 <mesh_packet+0x4e7>
			cc3: R_X86_64_PLT32	fmaxf-0x4
     cc7:	44 0f 28 5c 24 20    	movaps 0x20(%rsp),%xmm11
     ccd:	f3 0f 10 bc 24 e0 00 	movss  0xe0(%rsp),%xmm7
     cd4:	00 00 
     cd6:	41 0f 54 fb          	andps  %xmm11,%xmm7
     cda:	0f 28 cf             	movaps %xmm7,%xmm1
     cdd:	e8 00 00 00 00       	call   ce2 <mesh_packet+0x502>
			cde: R_X86_64_PLT32	fmaxf-0x4
     ce2:	66 0f ef e4          	pxor   %xmm4,%xmm4
     ce6:	0f 2f c4             	comiss %xmm4,%xmm0
     ce9:	44 0f 28 e8          	movaps %xmm0,%xmm13
     ced:	0f 86 3d ff ff ff    	jbe    c30 <mesh_packet+0x450>
     cf3:	f3 0f 10 25 00 00 00 	movss  0x0(%rip),%xmm4        # cfb <mesh_packet+0x51b>
     cfa:	00 
			cf7: R_X86_64_PC32	.LC1-0x4
     cfb:	0f 2e e0             	ucomiss %xmm0,%xmm4
     cfe:	0f 82 2c ff ff ff    	jb     c30 <mesh_packet+0x450>
     d04:	f3 44 0f 10 64 24 50 	movss  0x50(%rsp),%xmm12
     d0b:	f3 0f 10 4c 24 10    	movss  0x10(%rsp),%xmm1
     d11:	f3 0f 10 74 24 30    	movss  0x30(%rsp),%xmm6
     d17:	44 0f 28 5c 24 20    	movaps 0x20(%rsp),%xmm11
     d1d:	f3 41 0f 5e cc       	divss  %xmm12,%xmm1
     d22:	f3 41 0f 5e f4       	divss  %xmm12,%xmm6
     d27:	0f 28 c1             	movaps %xmm1,%xmm0
     d2a:	f3 0f 10 4c 24 18    	movss  0x18(%rsp),%xmm1
     d30:	0f 28 d0             	movaps %xmm0,%xmm2
     d33:	f3 0f 59 d0          	mulss  %xmm0,%xmm2
     d37:	f3 41 0f 5e cc       	divss  %xmm12,%xmm1
     d3c:	0f 28 e9             	movaps %xmm1,%xmm5
     d3f:	0f 28 d9             	movaps %xmm1,%xmm3
     d42:	f3 0f 59 e9          	mulss  %xmm1,%xmm5
     d46:	66 41 0f 6e cd       	movd   %r13d,%xmm1
     d4b:	f3 41 0f 5e cd       	divss  %xmm13,%xmm1
     d50:	44 0f 28 e5          	movaps %xmm5,%xmm12
     d54:	0f 28 e8             	movaps %xmm0,%xmm5
     d57:	f3 44 0f 58 e2       	addss  %xmm2,%xmm12
     d5c:	0f 28 d6             	movaps %xmm6,%xmm2
     d5f:	f3 0f 59 d6          	mulss  %xmm6,%xmm2
     d63:	f3 44 0f 58 e2       	addss  %xmm2,%xmm12
     d68:	66 41 0f 6e d4       	movd   %r12d,%xmm2
     d6d:	f3 41 0f 5e d5       	divss  %xmm13,%xmm2
     d72:	f3 45 0f 51 e4       	sqrtss %xmm12,%xmm12
     d77:	f3 41 0f 5e dc       	divss  %xmm12,%xmm3
     d7c:	0f 28 c2             	movaps %xmm2,%xmm0
     d7f:	f3 0f 59 c2          	mulss  %xmm2,%xmm0
     d83:	f3 41 0f 5e ec       	divss  %xmm12,%xmm5
     d88:	f3 0f 11 5c 24 50    	movss  %xmm3,0x50(%rsp)
     d8e:	f3 41 0f 5e f4       	divss  %xmm12,%xmm6
     d93:	f3 44 0f 10 a4 24 e0 	movss  0xe0(%rsp),%xmm12
     d9a:	00 00 00 
     d9d:	f3 0f 11 6c 24 38    	movss  %xmm5,0x38(%rsp)
     da3:	f3 45 0f 5e e5       	divss  %xmm13,%xmm12
     da8:	f3 0f 11 74 24 54    	movss  %xmm6,0x54(%rsp)
     dae:	45 0f 28 ec          	movaps %xmm12,%xmm13
     db2:	f3 45 0f 59 ec       	mulss  %xmm12,%xmm13
     db7:	f3 41 0f 58 c5       	addss  %xmm13,%xmm0
     dbc:	44 0f 28 e9          	movaps %xmm1,%xmm13
     dc0:	f3 44 0f 59 e9       	mulss  %xmm1,%xmm13
     dc5:	f3 41 0f 58 c5       	addss  %xmm13,%xmm0
     dca:	f3 0f 51 c0          	sqrtss %xmm0,%xmm0
     dce:	f3 0f 5e d0          	divss  %xmm0,%xmm2
     dd2:	f3 44 0f 5e e0       	divss  %xmm0,%xmm12
     dd7:	f3 0f 5e c8          	divss  %xmm0,%xmm1
     ddb:	f3 44 0f 58 e5       	addss  %xmm5,%xmm12
     de0:	0f 28 ea             	movaps %xmm2,%xmm5
     de3:	f3 0f 58 eb          	addss  %xmm3,%xmm5
     de7:	f3 44 0f 11 64 24 10 	movss  %xmm12,0x10(%rsp)
     dee:	f3 0f 11 6c 24 18    	movss  %xmm5,0x18(%rsp)
     df4:	f3 0f 58 ce          	addss  %xmm6,%xmm1
     df8:	0f 28 f1             	movaps %xmm1,%xmm6
     dfb:	0f 28 cd             	movaps %xmm5,%xmm1
     dfe:	0f 28 c6             	movaps %xmm6,%xmm0
     e01:	41 0f 54 cb          	andps  %xmm11,%xmm1
     e05:	f3 0f 11 74 24 30    	movss  %xmm6,0x30(%rsp)
     e0b:	41 0f 54 c3          	andps  %xmm11,%xmm0
     e0f:	e8 00 00 00 00       	call   e14 <mesh_packet+0x634>
			e10: R_X86_64_PLT32	fmaxf-0x4
     e14:	44 0f 28 5c 24 20    	movaps 0x20(%rsp),%xmm11
     e1a:	f3 0f 10 4c 24 10    	movss  0x10(%rsp),%xmm1
     e20:	41 0f 54 cb          	andps  %xmm11,%xmm1
     e24:	e8 00 00 00 00       	call   e29 <mesh_packet+0x649>
			e25: R_X86_64_PLT32	fmaxf-0x4
     e29:	66 0f ef db          	pxor   %xmm3,%xmm3
     e2d:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
     e32:	4c 8b 94 24 e8 00 00 	mov    0xe8(%rsp),%r10
     e39:	00 
     e3a:	0f 2f c3             	comiss %xmm3,%xmm0
     e3d:	f2 0f 10 64 24 68    	movsd  0x68(%rsp),%xmm4
     e43:	f2 44 0f 10 74 24 70 	movsd  0x70(%rsp),%xmm14
     e4a:	f2 44 0f 10 bc 24 80 	movsd  0x80(%rsp),%xmm15
     e51:	00 00 00 
     e54:	f2 0f 10 5c 24 78    	movsd  0x78(%rsp),%xmm3
     e5a:	f2 44 0f 10 84 24 88 	movsd  0x88(%rsp),%xmm8
     e61:	00 00 00 
     e64:	f2 0f 10 ac 24 90 00 	movsd  0x90(%rsp),%xmm5
     e6b:	00 00 
     e6d:	f2 44 0f 10 8c 24 a0 	movsd  0xa0(%rsp),%xmm9
     e74:	00 00 00 
     e77:	f2 0f 10 b4 24 b0 00 	movsd  0xb0(%rsp),%xmm6
     e7e:	00 00 
     e80:	f2 44 0f 10 94 24 c0 	movsd  0xc0(%rsp),%xmm10
     e87:	00 00 00 
     e8a:	f2 0f 10 bc 24 d0 00 	movsd  0xd0(%rsp),%xmm7
     e91:	00 00 
     e93:	0f 86 2c 0b 00 00    	jbe    19c5 <mesh_packet+0x11e5>
     e99:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # ea1 <mesh_packet+0x6c1>
     ea0:	00 
			e9d: R_X86_64_PC32	.LC1-0x4
     ea1:	c6 44 24 20 00       	movb   $0x0,0x20(%rsp)
     ea6:	0f 2e d0             	ucomiss %xmm0,%xmm2
     ea9:	0f 83 72 09 00 00    	jae    1821 <mesh_packet+0x1041>
     eaf:	44 0f b7 84 24 fc 00 	movzwl 0xfc(%rsp),%r8d
     eb6:	00 00 
     eb8:	4c 8d 9d 64 04 00 00 	lea    0x464(%rbp),%r11
     ebf:	43 8d 0c 00          	lea    (%r8,%r8,1),%ecx
     ec3:	48 89 8c 24 18 01 00 	mov    %rcx,0x118(%rsp)
     eca:	00 
     ecb:	48 89 ca             	mov    %rcx,%rdx
     ece:	49 8d 0c 8b          	lea    (%r11,%rcx,4),%rcx
     ed2:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
     ed9:	00 
     eda:	45 84 f6             	test   %r14b,%r14b
     edd:	0f 84 eb 08 00 00    	je     17ce <mesh_packet+0xfee>
     ee3:	48 8d 75 5c          	lea    0x5c(%rbp),%rsi
     ee7:	45 85 c0             	test   %r8d,%r8d
     eea:	0f 84 cb 0a 00 00    	je     19bb <mesh_packet+0x11db>
     ef0:	66 41 0f 28 c7       	movapd %xmm15,%xmm0
     ef5:	66 0f 28 cb          	movapd %xmm3,%xmm1
     ef9:	49 8d 4a 64          	lea    0x64(%r10),%rcx
     efd:	49 89 f4             	mov    %rsi,%r12
     f00:	f2 0f 59 cf          	mulsd  %xmm7,%xmm1
     f04:	4c 89 bc 24 00 01 00 	mov    %r15,0x100(%rsp)
     f0b:	00 
     f0c:	f2 0f 10 94 24 d8 00 	movsd  0xd8(%rsp),%xmm2
     f13:	00 00 
     f15:	45 31 ed             	xor    %r13d,%r13d
     f18:	f2 41 0f 59 c2       	mulsd  %xmm10,%xmm0
     f1d:	44 89 84 24 c0 00 00 	mov    %r8d,0xc0(%rsp)
     f24:	00 
     f25:	f2 41 0f 59 fe       	mulsd  %xmm14,%xmm7
     f2a:	4c 89 9c 24 d0 00 00 	mov    %r11,0xd0(%rsp)
     f31:	00 
     f32:	f2 45 0f 59 d6       	mulsd  %xmm14,%xmm10
     f37:	48 89 ac 24 08 01 00 	mov    %rbp,0x108(%rsp)
     f3e:	00 
     f3f:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
     f44:	4c 89 94 24 e0 00 00 	mov    %r10,0xe0(%rsp)
     f4b:	00 
     f4c:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
     f50:	f2 0f 10 0c 24       	movsd  (%rsp),%xmm1
     f55:	44 89 b4 24 10 01 00 	mov    %r14d,0x110(%rsp)
     f5c:	00 
     f5d:	89 94 24 14 01 00 00 	mov    %edx,0x114(%rsp)
     f64:	66 0f 14 c8          	unpcklpd %xmm0,%xmm1
     f68:	66 0f 28 c2          	movapd %xmm2,%xmm0
     f6c:	66 0f 14 c0          	unpcklpd %xmm0,%xmm0
     f70:	66 0f 5e c8          	divpd  %xmm0,%xmm1
     f74:	0f 29 8c 24 90 00 00 	movaps %xmm1,0x90(%rsp)
     f7b:	00 
     f7c:	f2 0f 10 4c 24 08    	movsd  0x8(%rsp),%xmm1
     f82:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
     f87:	42 8d 0c 02          	lea    (%rdx,%r8,1),%ecx
     f8b:	f2 0f 5c cc          	subsd  %xmm4,%xmm1
     f8f:	66 41 0f 28 e7       	movapd %xmm15,%xmm4
     f94:	8d 0c 8d 6b 04 00 00 	lea    0x46b(,%rcx,4),%ecx
     f9b:	f2 0f 59 e6          	mulsd  %xmm6,%xmm4
     f9f:	89 cf                	mov    %ecx,%edi
     fa1:	41 8b 4f 5c          	mov    0x5c(%r15),%ecx
     fa5:	f2 0f 59 f3          	mulsd  %xmm3,%xmm6
     fa9:	81 e7 f8 ff 1f 00    	and    $0x1ffff8,%edi
     faf:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
     fb4:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
     fbb:	00 
     fbc:	48 89 bc 24 e8 00 00 	mov    %rdi,0xe8(%rsp)
     fc3:	00 
     fc4:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
     fc9:	f2 0f 5c fc          	subsd  %xmm4,%xmm7
     fcd:	f2 41 0f 5c f2       	subsd  %xmm10,%xmm6
     fd2:	66 0f 14 cf          	unpcklpd %xmm7,%xmm1
     fd6:	66 0f 5e c8          	divpd  %xmm0,%xmm1
     fda:	0f 29 8c 24 a0 00 00 	movaps %xmm1,0xa0(%rsp)
     fe1:	00 
     fe2:	f2 0f 10 4c 24 40    	movsd  0x40(%rsp),%xmm1
     fe8:	66 0f 14 ce          	unpcklpd %xmm6,%xmm1
     fec:	66 0f 5e c8          	divpd  %xmm0,%xmm1
     ff0:	66 0f 28 c3          	movapd %xmm3,%xmm0
     ff4:	f2 41 0f 59 c1       	mulsd  %xmm9,%xmm0
     ff9:	f2 45 0f 59 ce       	mulsd  %xmm14,%xmm9
     ffe:	0f 29 8c 24 b0 00 00 	movaps %xmm1,0xb0(%rsp)
    1005:	00 
    1006:	66 41 0f 28 cf       	movapd %xmm15,%xmm1
    100b:	f2 0f 59 cd          	mulsd  %xmm5,%xmm1
    100f:	f2 41 0f 59 ee       	mulsd  %xmm14,%xmm5
    1014:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    1018:	f2 0f 5e c2          	divsd  %xmm2,%xmm0
    101c:	f2 0f 11 44 24 78    	movsd  %xmm0,0x78(%rsp)
    1022:	66 41 0f 28 c7       	movapd %xmm15,%xmm0
    1027:	f2 41 0f 59 c0       	mulsd  %xmm8,%xmm0
    102c:	f2 44 0f 59 c3       	mulsd  %xmm3,%xmm8
    1031:	f2 41 0f 5c c1       	subsd  %xmm9,%xmm0
    1036:	f2 41 0f 5c e8       	subsd  %xmm8,%xmm5
    103b:	f2 0f 5e c2          	divsd  %xmm2,%xmm0
    103f:	f2 0f 5e ea          	divsd  %xmm2,%xmm5
    1043:	f2 0f 11 84 24 80 00 	movsd  %xmm0,0x80(%rsp)
    104a:	00 00 
    104c:	f2 0f 11 ac 24 88 00 	movsd  %xmm5,0x88(%rsp)
    1053:	00 00 
    1055:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    105c:	00 00 00 00 
    1060:	0f b7 33             	movzwl (%rbx),%esi
    1063:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
    1068:	44 01 ee             	add    %r13d,%esi
    106b:	6b f6 1c             	imul   $0x1c,%esi,%esi
    106e:	48 01 c6             	add    %rax,%rsi
    1071:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
    1076:	48 01 c6             	add    %rax,%rsi
    1079:	80 bc 24 fb 00 00 00 	cmpb   $0x0,0xfb(%rsp)
    1080:	00 
    1081:	75 51                	jne    10d4 <mesh_packet+0x8f4>
    1083:	48 8b bc 24 d0 00 00 	mov    0xd0(%rsp),%rdi
    108a:	00 
    108b:	43 8d 44 2d 01       	lea    0x1(%r13,%r13,1),%eax
    1090:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
    1095:	48 c1 e0 02          	shl    $0x2,%rax
    1099:	48 8d 0c 07          	lea    (%rdi,%rax,1),%rcx
    109d:	48 8d 54 07 fc       	lea    -0x4(%rdi,%rax,1),%rdx
    10a2:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
    10a9:	00 
    10aa:	e8 e1 ef ff ff       	call   90 <mesh_project>
    10af:	84 c0                	test   %al,%al
    10b1:	0f 84 79 fb ff ff    	je     c30 <mesh_packet+0x450>
    10b7:	f3 0f 10 02          	movss  (%rdx),%xmm0
    10bb:	f3 41 0f 11 04 24    	movss  %xmm0,(%r12)
    10c1:	f3 0f 10 01          	movss  (%rcx),%xmm0
    10c5:	f3 41 0f 11 44 24 04 	movss  %xmm0,0x4(%r12)
    10cc:	8b 46 18             	mov    0x18(%rsi),%eax
    10cf:	41 89 44 24 08       	mov    %eax,0x8(%r12)
    10d4:	66 0f ef c0          	pxor   %xmm0,%xmm0
    10d8:	66 0f ef db          	pxor   %xmm3,%xmm3
    10dc:	66 0f ef c9          	pxor   %xmm1,%xmm1
    10e0:	f3 0f 5a 46 0c       	cvtss2sd 0xc(%rsi),%xmm0
    10e5:	f3 0f 5a 5e 10       	cvtss2sd 0x10(%rsi),%xmm3
    10ea:	66 0f 28 d0          	movapd %xmm0,%xmm2
    10ee:	66 0f 28 e3          	movapd %xmm3,%xmm4
    10f2:	66 0f 14 d2          	unpcklpd %xmm2,%xmm2
    10f6:	66 0f 14 e4          	unpcklpd %xmm4,%xmm4
    10fa:	f3 0f 5a 4e 14       	cvtss2sd 0x14(%rsi),%xmm1
    10ff:	66 0f 59 a4 24 a0 00 	mulpd  0xa0(%rsp),%xmm4
    1106:	00 00 
    1108:	66 0f 59 94 24 90 00 	mulpd  0x90(%rsp),%xmm2
    110f:	00 00 
    1111:	f2 0f 59 9c 24 80 00 	mulsd  0x80(%rsp),%xmm3
    1118:	00 00 
    111a:	f2 0f 59 44 24 78    	mulsd  0x78(%rsp),%xmm0
    1120:	66 0f 58 d4          	addpd  %xmm4,%xmm2
    1124:	66 0f 28 e1          	movapd %xmm1,%xmm4
    1128:	f2 0f 59 8c 24 88 00 	mulsd  0x88(%rsp),%xmm1
    112f:	00 00 
    1131:	66 0f 14 e4          	unpcklpd %xmm4,%xmm4
    1135:	66 0f 59 a4 24 b0 00 	mulpd  0xb0(%rsp),%xmm4
    113c:	00 00 
    113e:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    1142:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    1146:	66 0f 58 d4          	addpd  %xmm4,%xmm2
    114a:	66 48 0f 7e c5       	movq   %xmm0,%rbp
    114f:	66 0f 28 ea          	movapd %xmm2,%xmm5
    1153:	66 0f 28 c2          	movapd %xmm2,%xmm0
    1157:	0f 29 54 24 40       	movaps %xmm2,0x40(%rsp)
    115c:	66 0f 15 ed          	unpckhpd %xmm5,%xmm5
    1160:	66 0f 28 cd          	movapd %xmm5,%xmm1
    1164:	e8 00 00 00 00       	call   1169 <mesh_packet+0x989>
			1165: R_X86_64_PLT32	hypot-0x4
    1169:	66 48 0f 6e cd       	movq   %rbp,%xmm1
    116e:	e8 00 00 00 00       	call   1173 <mesh_packet+0x993>
			116f: R_X86_64_PLT32	hypot-0x4
    1173:	66 0f 28 f8          	movapd %xmm0,%xmm7
    1177:	f2 0f 11 04 24       	movsd  %xmm0,(%rsp)
    117c:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1180:	66 0f 2f f8          	comisd %xmm0,%xmm7
    1184:	0f 86 a6 fa ff ff    	jbe    c30 <mesh_packet+0x450>
    118a:	f2 0f 10 1d 00 00 00 	movsd  0x0(%rip),%xmm3        # 1192 <mesh_packet+0x9b2>
    1191:	00 
			118e: R_X86_64_PC32	.LC22-0x4
    1192:	66 0f 2e df          	ucomisd %xmm7,%xmm3
    1196:	0f 82 94 fa ff ff    	jb     c30 <mesh_packet+0x450>
    119c:	66 0f 28 54 24 40    	movapd 0x40(%rsp),%xmm2
    11a2:	48 89 ac 24 80 03 00 	mov    %rbp,0x380(%rsp)
    11a9:	00 
    11aa:	45 31 ff             	xor    %r15d,%r15d
    11ad:	4c 8d b4 24 70 03 00 	lea    0x370(%rsp),%r14
    11b4:	00 
    11b5:	48 8d ac 24 f0 01 00 	lea    0x1f0(%rsp),%rbp
    11bc:	00 
    11bd:	0f 29 94 24 70 03 00 	movaps %xmm2,0x370(%rsp)
    11c4:	00 
    11c5:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 11cd <mesh_packet+0x9ed>
    11cc:	00 
			11c9: R_X86_64_PC32	.LC24-0x4
    11cd:	f2 43 0f 59 04 fe    	mulsd  (%r14,%r15,8),%xmm0
    11d3:	f2 0f 5e 04 24       	divsd  (%rsp),%xmm0
    11d8:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 11e0 <mesh_packet+0xa00>
    11df:	00 
			11dc: R_X86_64_PC32	.LC6-0x4
    11e0:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 11e8 <mesh_packet+0xa08>
    11e7:	00 
			11e4: R_X86_64_PC32	.LC13-0x4
    11e8:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 11f0 <mesh_packet+0xa10>
    11ef:	00 
			11ec: R_X86_64_PC32	.LC7-0x4
    11f0:	66 0f 54 c8          	andpd  %xmm0,%xmm1
    11f4:	66 0f 2e f1          	ucomisd %xmm1,%xmm6
    11f8:	76 3b                	jbe    1235 <mesh_packet+0xa55>
    11fa:	f2 48 0f 2c c0       	cvttsd2si %xmm0,%rax
    11ff:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1203:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 120b <mesh_packet+0xa2b>
    120a:	00 
			1207: R_X86_64_PC32	.LC9-0x4
    120b:	f2 48 0f 2a c8       	cvtsi2sd %rax,%xmm1
    1210:	66 0f 28 d1          	movapd %xmm1,%xmm2
    1214:	f2 0f c2 d0 06       	cmpnlesd %xmm0,%xmm2
    1219:	66 0f 54 d6          	andpd  %xmm6,%xmm2
    121d:	f2 0f 5c ca          	subsd  %xmm2,%xmm1
    1221:	f2 0f 10 15 00 00 00 	movsd  0x0(%rip),%xmm2        # 1229 <mesh_packet+0xa49>
    1228:	00 
			1225: R_X86_64_PC32	.LC13-0x4
    1229:	66 0f 55 d0          	andnpd %xmm0,%xmm2
    122d:	66 0f 56 ca          	orpd   %xmm2,%xmm1
    1231:	66 0f 28 c1          	movapd %xmm1,%xmm0
    1235:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 123d <mesh_packet+0xa5d>
    123c:	00 
			1239: R_X86_64_PC32	.LC24-0x4
    123d:	e8 00 00 00 00       	call   1242 <mesh_packet+0xa62>
			123e: R_X86_64_PLT32	fmin-0x4
    1242:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 124a <mesh_packet+0xa6a>
    1249:	00 
			1246: R_X86_64_PC32	.LC25-0x4
    124a:	e8 00 00 00 00       	call   124f <mesh_packet+0xa6f>
			124b: R_X86_64_PLT32	fmax-0x4
    124f:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    1253:	66 42 89 44 7d 00    	mov    %ax,0x0(%rbp,%r15,2)
    1259:	49 83 c7 01          	add    $0x1,%r15
    125d:	49 83 ff 03          	cmp    $0x3,%r15
    1261:	0f 85 5e ff ff ff    	jne    11c5 <mesh_packet+0x9e5>
    1267:	0f b7 84 24 f0 01 00 	movzwl 0x1f0(%rsp),%eax
    126e:	00 
    126f:	66 0b 84 24 f2 01 00 	or     0x1f2(%rsp),%ax
    1276:	00 
    1277:	66 0b 84 24 f4 01 00 	or     0x1f4(%rsp),%ax
    127e:	00 
    127f:	0f 84 ab f9 ff ff    	je     c30 <mesh_packet+0x450>
    1285:	0f b6 53 12          	movzbl 0x12(%rbx),%edx
    1289:	0f b7 73 0e          	movzwl 0xe(%rbx),%esi
    128d:	48 89 ef             	mov    %rbp,%rdi
    1290:	4c 8d bc 24 20 01 00 	lea    0x120(%rsp),%r15
    1297:	00 
    1298:	44 0f b6 4c 24 20    	movzbl 0x20(%rsp),%r9d
    129e:	f3 0f 10 6c 24 30    	movss  0x30(%rsp),%xmm5
    12a4:	4d 89 f8             	mov    %r15,%r8
    12a7:	f3 0f 10 64 24 18    	movss  0x18(%rsp),%xmm4
    12ad:	f3 0f 10 5c 24 10    	movss  0x10(%rsp),%xmm3
    12b3:	f3 0f 10 54 24 54    	movss  0x54(%rsp),%xmm2
    12b9:	f3 0f 10 4c 24 50    	movss  0x50(%rsp),%xmm1
    12bf:	f3 0f 10 44 24 38    	movss  0x38(%rsp),%xmm0
    12c5:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
    12ca:	e8 31 f0 ff ff       	call   300 <ayatsuri_shade_sample.isra.0>
    12cf:	44 0f b6 4c 24 20    	movzbl 0x20(%rsp),%r9d
    12d5:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
    12da:	4d 89 f8             	mov    %r15,%r8
    12dd:	66 41 89 44 24 0c    	mov    %ax,0xc(%r12)
    12e3:	f3 0f 10 6c 24 30    	movss  0x30(%rsp),%xmm5
    12e9:	48 89 ef             	mov    %rbp,%rdi
    12ec:	0f b7 73 10          	movzwl 0x10(%rbx),%esi
    12f0:	0f b6 53 12          	movzbl 0x12(%rbx),%edx
    12f4:	f3 0f 10 64 24 18    	movss  0x18(%rsp),%xmm4
    12fa:	f3 0f 10 5c 24 10    	movss  0x10(%rsp),%xmm3
    1300:	f3 0f 10 54 24 54    	movss  0x54(%rsp),%xmm2
    1306:	f3 0f 10 4c 24 50    	movss  0x50(%rsp),%xmm1
    130c:	f3 0f 10 44 24 38    	movss  0x38(%rsp),%xmm0
    1312:	e8 e9 ef ff ff       	call   300 <ayatsuri_shade_sample.isra.0>
    1317:	8b 74 24 64          	mov    0x64(%rsp),%esi
    131b:	66 41 89 44 24 0e    	mov    %ax,0xe(%r12)
    1321:	85 f6                	test   %esi,%esi
    1323:	0f 85 27 03 00 00    	jne    1650 <mesh_packet+0xe70>
    1329:	8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%eax
    1330:	41 83 c5 01          	add    $0x1,%r13d
    1334:	48 83 44 24 58 04    	addq   $0x4,0x58(%rsp)
    133a:	49 83 c4 10          	add    $0x10,%r12
    133e:	41 39 c5             	cmp    %eax,%r13d
    1341:	0f 82 19 fd ff ff    	jb     1060 <mesh_packet+0x880>
    1347:	44 8b b4 24 10 01 00 	mov    0x110(%rsp),%r14d
    134e:	00 
    134f:	4c 8b bc 24 00 01 00 	mov    0x100(%rsp),%r15
    1356:	00 
    1357:	44 8b 84 24 c0 00 00 	mov    0xc0(%rsp),%r8d
    135e:	00 
    135f:	4c 8b 9c 24 d0 00 00 	mov    0xd0(%rsp),%r11
    1366:	00 
    1367:	48 8b ac 24 08 01 00 	mov    0x108(%rsp),%rbp
    136e:	00 
    136f:	4c 8b 94 24 e0 00 00 	mov    0xe0(%rsp),%r10
    1376:	00 
    1377:	8b 94 24 14 01 00 00 	mov    0x114(%rsp),%edx
    137e:	45 84 f6             	test   %r14b,%r14b
    1381:	0f 85 34 06 00 00    	jne    19bb <mesh_packet+0x11db>
    1387:	0f b7 bc 24 fe 00 00 	movzwl 0xfe(%rsp),%edi
    138e:	00 
    138f:	85 ff                	test   %edi,%edi
    1391:	74 4d                	je     13e0 <mesh_packet+0xc00>
    1393:	4d 8b 27             	mov    (%r15),%r12
    1396:	45 8b 4f 64          	mov    0x64(%r15),%r9d
    139a:	31 f6                	xor    %esi,%esi
    139c:	0f 1f 40 00          	nopl   0x0(%rax)
    13a0:	44 8d 2c 76          	lea    (%rsi,%rsi,2),%r13d
    13a4:	31 c9                	xor    %ecx,%ecx
    13a6:	0f b7 43 04          	movzwl 0x4(%rbx),%eax
    13aa:	01 f0                	add    %esi,%eax
    13ac:	8d 04 40             	lea    (%rax,%rax,2),%eax
    13af:	44 8d 34 00          	lea    (%rax,%rax,1),%r14d
    13b3:	49 8d 04 0c          	lea    (%r12,%rcx,1),%rax
    13b7:	48 83 c1 02          	add    $0x2,%rcx
    13bb:	4c 01 c8             	add    %r9,%rax
    13be:	46 0f b7 34 30       	movzwl (%rax,%r14,1),%r14d
    13c3:	44 89 e8             	mov    %r13d,%eax
    13c6:	41 83 c5 01          	add    $0x1,%r13d
    13ca:	66 44 89 b4 44 f0 01 	mov    %r14w,0x1f0(%rsp,%rax,2)
    13d1:	00 00 
    13d3:	48 83 f9 06          	cmp    $0x6,%rcx
    13d7:	75 cd                	jne    13a6 <mesh_packet+0xbc6>
    13d9:	83 c6 01             	add    $0x1,%esi
    13dc:	39 f7                	cmp    %esi,%edi
    13de:	75 c0                	jne    13a0 <mesh_packet+0xbc0>
    13e0:	8b 4c 24 64          	mov    0x64(%rsp),%ecx
    13e4:	44 0f b6 6b 0b       	movzbl 0xb(%rbx),%r13d
    13e9:	85 c9                	test   %ecx,%ecx
    13eb:	0f 84 de 05 00 00    	je     19cf <mesh_packet+0x11ef>
    13f1:	49 8b 4a 08          	mov    0x8(%r10),%rcx
    13f5:	44 01 c2             	add    %r8d,%edx
    13f8:	66 0f ef c0          	pxor   %xmm0,%xmm0
    13fc:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
    1403:	00 
    1404:	48 8b b4 24 18 01 00 	mov    0x118(%rsp),%rsi
    140b:	00 
    140c:	8d 14 95 6b 04 00 00 	lea    0x46b(,%rdx,4),%edx
    1413:	8b 44 01 08          	mov    0x8(%rcx,%rax,1),%eax
    1417:	81 e2 f8 ff 1f 00    	and    $0x1ffff8,%edx
    141d:	48 8d 04 70          	lea    (%rax,%rsi,2),%rax
    1421:	48 01 d0             	add    %rdx,%rax
    1424:	66 0f 2f 84 24 d8 00 	comisd 0xd8(%rsp),%xmm0
    142b:	00 00 
    142d:	4c 8d 04 01          	lea    (%rcx,%rax,1),%r8
    1431:	49 c7 00 00 00 00 00 	movq   $0x0,(%r8)
    1438:	0f 97 04 24          	seta   (%rsp)
    143c:	44 0f b6 34 24       	movzbl (%rsp),%r14d
    1441:	85 ff                	test   %edi,%edi
    1443:	0f 84 f6 06 00 00    	je     1b3f <mesh_packet+0x135f>
    1449:	4c 89 44 24 08       	mov    %r8,0x8(%rsp)
    144e:	31 f6                	xor    %esi,%esi
    1450:	31 c0                	xor    %eax,%eax
    1452:	66 0f 28 e0          	movapd %xmm0,%xmm4
    1456:	4c 8d 8c 24 f0 01 00 	lea    0x1f0(%rsp),%r9
    145d:	00 
    145e:	48 89 6c 24 10       	mov    %rbp,0x10(%rsp)
    1463:	f2 0f 10 1d 00 00 00 	movsd  0x0(%rip),%xmm3        # 146b <mesh_packet+0xc8b>
    146a:	00 
			1467: R_X86_64_PC32	.LC27-0x4
    146b:	48 89 5c 24 18       	mov    %rbx,0x18(%rsp)
    1470:	4c 8b 94 24 f0 00 00 	mov    0xf0(%rsp),%r10
    1477:	00 
    1478:	4c 89 c9             	mov    %r9,%rcx
    147b:	4c 89 4c 24 30       	mov    %r9,0x30(%rsp)
    1480:	4c 89 3c 24          	mov    %r15,(%rsp)
    1484:	45 89 ef             	mov    %r13d,%r15d
    1487:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    148e:	00 00 
    1490:	0f b7 29             	movzwl (%rcx),%ebp
    1493:	0f b7 59 02          	movzwl 0x2(%rcx),%ebx
    1497:	66 0f ef ed          	pxor   %xmm5,%xmm5
    149b:	66 0f ef d2          	pxor   %xmm2,%xmm2
    149f:	44 0f b7 49 04       	movzwl 0x4(%rcx),%r9d
    14a4:	66 0f ef c0          	pxor   %xmm0,%xmm0
    14a8:	66 0f ef c9          	pxor   %xmm1,%xmm1
    14ac:	48 8d 54 2d 00       	lea    0x0(%rbp,%rbp,1),%rdx
    14b1:	81 e2 fe ff 01 00    	and    $0x1fffe,%edx
    14b7:	4f 8d 04 09          	lea    (%r9,%r9,1),%r8
    14bb:	f3 41 0f 5a 54 93 04 	cvtss2sd 0x4(%r11,%rdx,4),%xmm2
    14c2:	f3 41 0f 5a 2c 93    	cvtss2sd (%r11,%rdx,4),%xmm5
    14c8:	48 8d 14 1b          	lea    (%rbx,%rbx,1),%rdx
    14cc:	41 81 e0 fe ff 01 00 	and    $0x1fffe,%r8d
    14d3:	81 e2 fe ff 01 00    	and    $0x1fffe,%edx
    14d9:	f3 43 0f 5a 44 83 04 	cvtss2sd 0x4(%r11,%r8,4),%xmm0
    14e0:	f2 0f 5c c2          	subsd  %xmm2,%xmm0
    14e4:	f3 41 0f 5a 0c 93    	cvtss2sd (%r11,%rdx,4),%xmm1
    14ea:	f2 0f 5c cd          	subsd  %xmm5,%xmm1
    14ee:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    14f2:	66 0f ef c9          	pxor   %xmm1,%xmm1
    14f6:	f3 41 0f 5a 4c 93 04 	cvtss2sd 0x4(%r11,%rdx,4),%xmm1
    14fd:	f2 0f 5c ca          	subsd  %xmm2,%xmm1
    1501:	66 0f ef d2          	pxor   %xmm2,%xmm2
    1505:	f3 43 0f 5a 14 83    	cvtss2sd (%r11,%r8,4),%xmm2
    150b:	f2 0f 5c d5          	subsd  %xmm5,%xmm2
    150f:	f2 0f 59 ca          	mulsd  %xmm2,%xmm1
    1513:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    1517:	66 0f 28 c8          	movapd %xmm0,%xmm1
    151b:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 1523 <mesh_packet+0xd43>
    1522:	00 
			151f: R_X86_64_PC32	.LC8-0x4
    1523:	66 0f 2f d9          	comisd %xmm1,%xmm3
    1527:	73 60                	jae    1589 <mesh_packet+0xda9>
    1529:	66 0f 2f e0          	comisd %xmm0,%xmm4
    152d:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1531:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1535:	44 89 f2             	mov    %r14d,%edx
    1538:	f3 41 0f 5a 0c 9a    	cvtss2sd (%r10,%rbx,4),%xmm1
    153e:	f3 41 0f 5a 04 aa    	cvtss2sd (%r10,%rbp,4),%xmm0
    1544:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    1548:	66 0f ef c9          	pxor   %xmm1,%xmm1
    154c:	f3 43 0f 5a 0c 8a    	cvtss2sd (%r10,%r9,4),%xmm1
    1552:	8d 58 01             	lea    0x1(%rax),%ebx
    1555:	41 0f 97 c0          	seta   %r8b
    1559:	44 31 c2             	xor    %r8d,%edx
    155c:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    1560:	01 d2                	add    %edx,%edx
    1562:	44 09 c2             	or     %r8d,%edx
    1565:	88 94 34 b0 01 00 00 	mov    %dl,0x1b0(%rsp,%rsi,1)
    156c:	41 80 ff 01          	cmp    $0x1,%r15b
    1570:	0f 84 44 05 00 00    	je     1aba <mesh_packet+0x12da>
    1576:	40 88 b4 04 70 01 00 	mov    %sil,0x170(%rsp,%rax,1)
    157d:	00 
    157e:	f2 0f 11 84 c4 70 03 	movsd  %xmm0,0x370(%rsp,%rax,8)
    1585:	00 00 
    1587:	89 d8                	mov    %ebx,%eax
    1589:	48 83 c6 01          	add    $0x1,%rsi
    158d:	48 83 c1 06          	add    $0x6,%rcx
    1591:	39 fe                	cmp    %edi,%esi
    1593:	0f 82 f7 fe ff ff    	jb     1490 <mesh_packet+0xcb0>
    1599:	4c 8b 3c 24          	mov    (%rsp),%r15
    159d:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
    15a2:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
    15a7:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
    15ac:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
    15b1:	85 c0                	test   %eax,%eax
    15b3:	0f 84 97 05 00 00    	je     1b50 <mesh_packet+0x1370>
    15b9:	48 8d b5 5c 02 00 00 	lea    0x25c(%rbp),%rsi
    15c0:	41 89 c3             	mov    %eax,%r11d
    15c3:	31 ff                	xor    %edi,%edi
    15c5:	41 bc 01 00 00 00    	mov    $0x1,%r12d
    15cb:	4c 8d 94 24 70 01 00 	lea    0x170(%rsp),%r10
    15d2:	00 
    15d3:	eb 43                	jmp    1618 <mesh_packet+0xe38>
    15d5:	44 0f b7 71 02       	movzwl 0x2(%rcx),%r14d
    15da:	41 bd 04 00 00 00    	mov    $0x4,%r13d
    15e0:	66 44 89 76 02       	mov    %r14w,0x2(%rsi)
    15e5:	42 0f b7 0c 29       	movzwl (%rcx,%r13,1),%ecx
    15ea:	83 e2 02             	and    $0x2,%edx
    15ed:	66 89 4e 04          	mov    %cx,0x4(%rsi)
    15f1:	74 14                	je     1607 <mesh_packet+0xe27>
    15f3:	89 fa                	mov    %edi,%edx
    15f5:	89 f9                	mov    %edi,%ecx
    15f7:	45 89 e6             	mov    %r12d,%r14d
    15fa:	c1 ea 03             	shr    $0x3,%edx
    15fd:	83 e1 07             	and    $0x7,%ecx
    1600:	41 d3 e6             	shl    %cl,%r14d
    1603:	45 08 34 10          	or     %r14b,(%r8,%rdx,1)
    1607:	48 83 c7 01          	add    $0x1,%rdi
    160b:	48 83 c6 06          	add    $0x6,%rsi
    160f:	4c 39 df             	cmp    %r11,%rdi
    1612:	0f 84 38 05 00 00    	je     1b50 <mesh_packet+0x1370>
    1618:	41 0f b6 14 3a       	movzbl (%r10,%rdi,1),%edx
    161d:	8d 0c 52             	lea    (%rdx,%rdx,2),%ecx
    1620:	0f b6 94 14 b0 01 00 	movzbl 0x1b0(%rsp,%rdx,1),%edx
    1627:	00 
    1628:	49 8d 0c 49          	lea    (%r9,%rcx,2),%rcx
    162c:	44 0f b7 29          	movzwl (%rcx),%r13d
    1630:	66 44 89 2e          	mov    %r13w,(%rsi)
    1634:	f6 c2 01             	test   $0x1,%dl
    1637:	74 9c                	je     15d5 <mesh_packet+0xdf5>
    1639:	44 0f b7 71 04       	movzwl 0x4(%rcx),%r14d
    163e:	41 bd 02 00 00 00    	mov    $0x2,%r13d
    1644:	eb 9a                	jmp    15e0 <mesh_packet+0xe00>
    1646:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    164d:	00 00 00 
    1650:	31 c0                	xor    %eax,%eax
    1652:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
    1657:	4c 89 f3             	mov    %r14,%rbx
    165a:	49 89 c6             	mov    %rax,%r14
    165d:	f2 42 0f 10 04 f3    	movsd  (%rbx,%r14,8),%xmm0
    1663:	66 0f 57 05 00 00 00 	xorpd  0x0(%rip),%xmm0        # 166b <mesh_packet+0xe8b>
    166a:	00 
			1667: R_X86_64_PC32	.LC26-0x4
    166b:	f2 0f 59 05 00 00 00 	mulsd  0x0(%rip),%xmm0        # 1673 <mesh_packet+0xe93>
    1672:	00 
			166f: R_X86_64_PC32	.LC24-0x4
    1673:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 167b <mesh_packet+0xe9b>
    167a:	00 
			1677: R_X86_64_PC32	.LC13-0x4
    167b:	f2 0f 5e 04 24       	divsd  (%rsp),%xmm0
    1680:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 1688 <mesh_packet+0xea8>
    1687:	00 
			1684: R_X86_64_PC32	.LC6-0x4
    1688:	f2 0f 10 1d 00 00 00 	movsd  0x0(%rip),%xmm3        # 1690 <mesh_packet+0xeb0>
    168f:	00 
			168c: R_X86_64_PC32	.LC7-0x4
    1690:	66 0f 54 c8          	andpd  %xmm0,%xmm1
    1694:	66 0f 2e d9          	ucomisd %xmm1,%xmm3
    1698:	76 3b                	jbe    16d5 <mesh_packet+0xef5>
    169a:	f2 48 0f 2c c0       	cvttsd2si %xmm0,%rax
    169f:	66 0f ef c9          	pxor   %xmm1,%xmm1
    16a3:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 16ab <mesh_packet+0xecb>
    16aa:	00 
			16a7: R_X86_64_PC32	.LC9-0x4
    16ab:	f2 48 0f 2a c8       	cvtsi2sd %rax,%xmm1
    16b0:	66 0f 28 d1          	movapd %xmm1,%xmm2
    16b4:	f2 0f c2 d0 06       	cmpnlesd %xmm0,%xmm2
    16b9:	66 0f 54 d5          	andpd  %xmm5,%xmm2
    16bd:	f2 0f 5c ca          	subsd  %xmm2,%xmm1
    16c1:	f2 0f 10 15 00 00 00 	movsd  0x0(%rip),%xmm2        # 16c9 <mesh_packet+0xee9>
    16c8:	00 
			16c5: R_X86_64_PC32	.LC13-0x4
    16c9:	66 0f 55 d0          	andnpd %xmm0,%xmm2
    16cd:	66 0f 56 ca          	orpd   %xmm2,%xmm1
    16d1:	66 0f 28 c1          	movapd %xmm1,%xmm0
    16d5:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 16dd <mesh_packet+0xefd>
    16dc:	00 
			16d9: R_X86_64_PC32	.LC24-0x4
    16dd:	e8 00 00 00 00       	call   16e2 <mesh_packet+0xf02>
			16de: R_X86_64_PLT32	fmin-0x4
    16e2:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 16ea <mesh_packet+0xf0a>
    16e9:	00 
			16e6: R_X86_64_PC32	.LC25-0x4
    16ea:	e8 00 00 00 00       	call   16ef <mesh_packet+0xf0f>
			16eb: R_X86_64_PLT32	fmax-0x4
    16ef:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    16f3:	66 42 89 44 75 00    	mov    %ax,0x0(%rbp,%r14,2)
    16f9:	49 83 c6 01          	add    $0x1,%r14
    16fd:	49 83 fe 03          	cmp    $0x3,%r14
    1701:	0f 85 56 ff ff ff    	jne    165d <mesh_packet+0xe7d>
    1707:	48 8b 84 24 e0 00 00 	mov    0xe0(%rsp),%rax
    170e:	00 
    170f:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
    1714:	4d 89 f8             	mov    %r15,%r8
    1717:	48 89 ef             	mov    %rbp,%rdi
    171a:	48 8b 8c 24 e8 00 00 	mov    0xe8(%rsp),%rcx
    1721:	00 
    1722:	43 8d 54 2d 00       	lea    0x0(%r13,%r13,1),%edx
    1727:	44 0f b6 4c 24 20    	movzbl 0x20(%rsp),%r9d
    172d:	4c 8b 70 08          	mov    0x8(%rax),%r14
    1731:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
    1738:	00 
    1739:	0f b7 73 0e          	movzwl 0xe(%rbx),%esi
    173d:	f3 0f 10 6c 24 30    	movss  0x30(%rsp),%xmm5
    1743:	41 8b 44 06 08       	mov    0x8(%r14,%rax,1),%eax
    1748:	f3 0f 10 64 24 18    	movss  0x18(%rsp),%xmm4
    174e:	f3 0f 10 5c 24 10    	movss  0x10(%rsp),%xmm3
    1754:	f3 0f 10 54 24 54    	movss  0x54(%rsp),%xmm2
    175a:	48 01 c8             	add    %rcx,%rax
    175d:	f3 0f 10 4c 24 50    	movss  0x50(%rsp),%xmm1
    1763:	f3 0f 10 44 24 38    	movss  0x38(%rsp),%xmm0
    1769:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
    176d:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
    1772:	0f b6 53 12          	movzbl 0x12(%rbx),%edx
    1776:	49 01 c6             	add    %rax,%r14
    1779:	e8 82 eb ff ff       	call   300 <ayatsuri_shade_sample.isra.0>
    177e:	44 0f b6 4c 24 20    	movzbl 0x20(%rsp),%r9d
    1784:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
    1789:	4d 89 f8             	mov    %r15,%r8
    178c:	66 41 89 06          	mov    %ax,(%r14)
    1790:	f3 0f 10 6c 24 30    	movss  0x30(%rsp),%xmm5
    1796:	48 89 ef             	mov    %rbp,%rdi
    1799:	0f b6 53 12          	movzbl 0x12(%rbx),%edx
    179d:	0f b7 73 10          	movzwl 0x10(%rbx),%esi
    17a1:	f3 0f 10 64 24 18    	movss  0x18(%rsp),%xmm4
    17a7:	f3 0f 10 5c 24 10    	movss  0x10(%rsp),%xmm3
    17ad:	f3 0f 10 54 24 54    	movss  0x54(%rsp),%xmm2
    17b3:	f3 0f 10 4c 24 50    	movss  0x50(%rsp),%xmm1
    17b9:	f3 0f 10 44 24 38    	movss  0x38(%rsp),%xmm0
    17bf:	e8 3c eb ff ff       	call   300 <ayatsuri_shade_sample.isra.0>
    17c4:	66 41 89 46 02       	mov    %ax,0x2(%r14)
    17c9:	e9 5b fb ff ff       	jmp    1329 <mesh_packet+0xb49>
    17ce:	48 8d 75 5c          	lea    0x5c(%rbp),%rsi
    17d2:	89 e8                	mov    %ebp,%eax
    17d4:	48 c7 45 54 00 00 00 	movq   $0x0,0x54(%rbp)
    17db:	00 
    17dc:	48 c7 85 5c 04 00 00 	movq   $0x0,0x45c(%rbp)
    17e3:	00 00 00 00 
    17e7:	48 89 f7             	mov    %rsi,%rdi
    17ea:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
    17ee:	29 f8                	sub    %edi,%eax
    17f0:	8d 88 64 04 00 00    	lea    0x464(%rax),%ecx
    17f6:	31 c0                	xor    %eax,%eax
    17f8:	c1 e9 03             	shr    $0x3,%ecx
    17fb:	f3 48 ab             	rep stos %rax,%es:(%rdi)
    17fe:	0f b6 84 24 fc 00 00 	movzbl 0xfc(%rsp),%eax
    1805:	00 
    1806:	88 45 54             	mov    %al,0x54(%rbp)
    1809:	0f b6 43 0a          	movzbl 0xa(%rbx),%eax
    180d:	88 45 56             	mov    %al,0x56(%rbp)
    1810:	45 85 c0             	test   %r8d,%r8d
    1813:	0f 84 6e fb ff ff    	je     1387 <mesh_packet+0xba7>
    1819:	49 8b 07             	mov    (%r15),%rax
    181c:	e9 cf f6 ff ff       	jmp    ef0 <mesh_packet+0x710>
    1821:	f3 44 0f 10 5c 24 10 	movss  0x10(%rsp),%xmm11
    1828:	f3 0f 10 54 24 18    	movss  0x18(%rsp),%xmm2
    182e:	c6 44 24 20 01       	movb   $0x1,0x20(%rsp)
    1833:	f3 0f 10 4c 24 30    	movss  0x30(%rsp),%xmm1
    1839:	f3 44 0f 5e d8       	divss  %xmm0,%xmm11
    183e:	f3 0f 5e d0          	divss  %xmm0,%xmm2
    1842:	45 0f 28 e3          	movaps %xmm11,%xmm12
    1846:	f3 45 0f 59 e3       	mulss  %xmm11,%xmm12
    184b:	f3 0f 5e c8          	divss  %xmm0,%xmm1
    184f:	0f 28 c2             	movaps %xmm2,%xmm0
    1852:	f3 0f 59 c2          	mulss  %xmm2,%xmm0
    1856:	f3 41 0f 58 c4       	addss  %xmm12,%xmm0
    185b:	44 0f 28 e1          	movaps %xmm1,%xmm12
    185f:	f3 44 0f 59 e1       	mulss  %xmm1,%xmm12
    1864:	f3 41 0f 58 c4       	addss  %xmm12,%xmm0
    1869:	f3 0f 51 c0          	sqrtss %xmm0,%xmm0
    186d:	f3 44 0f 5e d8       	divss  %xmm0,%xmm11
    1872:	f3 0f 5e d0          	divss  %xmm0,%xmm2
    1876:	f3 44 0f 11 5c 24 10 	movss  %xmm11,0x10(%rsp)
    187d:	f3 0f 5e c8          	divss  %xmm0,%xmm1
    1881:	f3 0f 11 54 24 18    	movss  %xmm2,0x18(%rsp)
    1887:	f3 0f 11 4c 24 30    	movss  %xmm1,0x30(%rsp)
    188d:	e9 1d f6 ff ff       	jmp    eaf <mesh_packet+0x6cf>
    1892:	8b 84 24 70 03 00 00 	mov    0x370(%rsp),%eax
    1899:	85 c0                	test   %eax,%eax
    189b:	0f 84 05 01 00 00    	je     19a6 <mesh_packet+0x11c6>
    18a1:	85 f6                	test   %esi,%esi
    18a3:	0f 84 fd 00 00 00    	je     19a6 <mesh_packet+0x11c6>
    18a9:	45 31 e4             	xor    %r12d,%r12d
    18ac:	45 31 c0             	xor    %r8d,%r8d
    18af:	66 0f ef d2          	pxor   %xmm2,%xmm2
    18b3:	31 d2                	xor    %edx,%edx
    18b5:	41 8d 44 24 01       	lea    0x1(%r12),%eax
    18ba:	66 0f ef ed          	pxor   %xmm5,%xmm5
    18be:	44 89 e7             	mov    %r12d,%edi
    18c1:	66 0f ef db          	pxor   %xmm3,%xmm3
    18c5:	f3 42 0f 5a 6c e5 04 	cvtss2sd 0x4(%rbp,%r12,8),%xmm5
    18cc:	66 0f ef e4          	pxor   %xmm4,%xmm4
    18d0:	66 0f ef f6          	pxor   %xmm6,%xmm6
    18d4:	f7 f6                	div    %esi
    18d6:	f3 42 0f 5a 74 e5 08 	cvtss2sd 0x8(%rbp,%r12,8),%xmm6
    18dd:	44 8d 14 12          	lea    (%rdx,%rdx,1),%r10d
    18e1:	f3 42 0f 5a 5c 95 04 	cvtss2sd 0x4(%rbp,%r10,4),%xmm3
    18e8:	f2 0f 5c dd          	subsd  %xmm5,%xmm3
    18ec:	4c 89 d0             	mov    %r10,%rax
    18ef:	41 ba 00 00 00 00    	mov    $0x0,%r10d
    18f5:	83 c0 01             	add    $0x1,%eax
    18f8:	f3 0f 5a 64 85 04    	cvtss2sd 0x4(%rbp,%rax,4),%xmm4
    18fe:	f2 0f 5c e6          	subsd  %xmm6,%xmm4
    1902:	66 0f 2e da          	ucomisd %xmm2,%xmm3
    1906:	0f 9b c0             	setnp  %al
    1909:	41 0f 45 c2          	cmovne %r10d,%eax
    190d:	84 c0                	test   %al,%al
    190f:	74 13                	je     1924 <mesh_packet+0x1144>
    1911:	66 0f 2e e2          	ucomisd %xmm2,%xmm4
    1915:	0f 9b c0             	setnp  %al
    1918:	41 0f 45 c2          	cmovne %r10d,%eax
    191c:	84 c0                	test   %al,%al
    191e:	0f 85 0c f3 ff ff    	jne    c30 <mesh_packet+0x450>
    1924:	31 c0                	xor    %eax,%eax
    1926:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    192d:	00 00 00 
    1930:	39 c7                	cmp    %eax,%edi
    1932:	74 5c                	je     1990 <mesh_packet+0x11b0>
    1934:	39 c2                	cmp    %eax,%edx
    1936:	74 58                	je     1990 <mesh_packet+0x11b0>
    1938:	66 0f ef c0          	pxor   %xmm0,%xmm0
    193c:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1940:	45 31 d2             	xor    %r10d,%r10d
    1943:	f3 0f 5a 44 c5 08    	cvtss2sd 0x8(%rbp,%rax,8),%xmm0
    1949:	f3 0f 5a 4c c5 04    	cvtss2sd 0x4(%rbp,%rax,8),%xmm1
    194f:	f2 0f 5c c6          	subsd  %xmm6,%xmm0
    1953:	f2 0f 5c cd          	subsd  %xmm5,%xmm1
    1957:	f2 0f 59 c3          	mulsd  %xmm3,%xmm0
    195b:	f2 0f 59 cc          	mulsd  %xmm4,%xmm1
    195f:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    1963:	66 0f 2f c2          	comisd %xmm2,%xmm0
    1967:	41 0f 97 c2          	seta   %r10b
    196b:	45 31 ed             	xor    %r13d,%r13d
    196e:	66 0f 2f d0          	comisd %xmm0,%xmm2
    1972:	41 0f 97 c5          	seta   %r13b
    1976:	45 29 ea             	sub    %r13d,%r10d
    1979:	0f 84 b1 f2 ff ff    	je     c30 <mesh_packet+0x450>
    197f:	45 85 c0             	test   %r8d,%r8d
    1982:	74 09                	je     198d <mesh_packet+0x11ad>
    1984:	45 39 d0             	cmp    %r10d,%r8d
    1987:	0f 85 a3 f2 ff ff    	jne    c30 <mesh_packet+0x450>
    198d:	45 89 d0             	mov    %r10d,%r8d
    1990:	48 83 c0 01          	add    $0x1,%rax
    1994:	48 39 c8             	cmp    %rcx,%rax
    1997:	75 97                	jne    1930 <mesh_packet+0x1150>
    1999:	49 83 c4 01          	add    $0x1,%r12
    199d:	4c 39 e1             	cmp    %r12,%rcx
    19a0:	0f 85 0d ff ff ff    	jne    18b3 <mesh_packet+0x10d3>
    19a6:	0f b6 43 0a          	movzbl 0xa(%rbx),%eax
    19aa:	49 83 c6 01          	add    $0x1,%r14
    19ae:	48 83 c5 44          	add    $0x44,%rbp
    19b2:	41 39 c6             	cmp    %eax,%r14d
    19b5:	0f 82 8d 00 00 00    	jb     1a48 <mesh_packet+0x1268>
    19bb:	b8 01 00 00 00       	mov    $0x1,%eax
    19c0:	e9 6d f2 ff ff       	jmp    c32 <mesh_packet+0x452>
    19c5:	c6 44 24 20 00       	movb   $0x0,0x20(%rsp)
    19ca:	e9 e0 f4 ff ff       	jmp    eaf <mesh_packet+0x6cf>
    19cf:	0f b7 94 24 fc 00 00 	movzwl 0xfc(%rsp),%edx
    19d6:	00 
    19d7:	48 8d 8c 24 f0 01 00 	lea    0x1f0(%rsp),%rcx
    19de:	00 
    19df:	48 83 ec 08          	sub    $0x8,%rsp
    19e3:	45 0f b6 cd          	movzbl %r13b,%r9d
    19e7:	48 8d 84 24 78 03 00 	lea    0x378(%rsp),%rax
    19ee:	00 
    19ef:	50                   	push   %rax
    19f0:	8d 04 7f             	lea    (%rdi,%rdi,2),%eax
    19f3:	4c 89 df             	mov    %r11,%rdi
    19f6:	50                   	push   %rax
    19f7:	48 8d 85 5c 02 00 00 	lea    0x25c(%rbp),%rax
    19fe:	50                   	push   %rax
    19ff:	48 8b b4 24 10 01 00 	mov    0x110(%rsp),%rsi
    1a06:	00 
    1a07:	44 0f b7 84 24 1e 01 	movzwl 0x11e(%rsp),%r8d
    1a0e:	00 00 
    1a10:	e8 00 00 00 00       	call   1a15 <mesh_packet+0x1235>
			1a11: R_X86_64_PLT32	ayatsuri_visibility_select-0x4
    1a15:	48 83 c4 20          	add    $0x20,%rsp
    1a19:	85 c0                	test   %eax,%eax
    1a1b:	0f 85 0f f2 ff ff    	jne    c30 <mesh_packet+0x450>
    1a21:	8b 84 24 70 03 00 00 	mov    0x370(%rsp),%eax
    1a28:	88 45 55             	mov    %al,0x55(%rbp)
    1a2b:	80 7b 0a 00          	cmpb   $0x0,0xa(%rbx)
    1a2f:	44 0f b7 4b 08       	movzwl 0x8(%rbx),%r9d
    1a34:	74 85                	je     19bb <mesh_packet+0x11db>
    1a36:	48 81 c5 dc 03 00 00 	add    $0x3dc,%rbp
    1a3d:	45 31 f6             	xor    %r14d,%r14d
    1a40:	4c 8d 9c 24 40 01 00 	lea    0x140(%rsp),%r11
    1a47:	00 
    1a48:	42 0f b6 44 33 0c    	movzbl 0xc(%rbx,%r14,1),%eax
    1a4e:	88 45 00             	mov    %al,0x0(%rbp)
    1a51:	84 c0                	test   %al,%al
    1a53:	0f 84 4d ff ff ff    	je     19a6 <mesh_packet+0x11c6>
    1a59:	4d 8b 2f             	mov    (%r15),%r13
    1a5c:	45 8b 67 6c          	mov    0x6c(%r15),%r12d
    1a60:	48 8d 55 04          	lea    0x4(%rbp),%rdx
    1a64:	45 31 d2             	xor    %r10d,%r10d
    1a67:	4c 8d 84 24 b0 01 00 	lea    0x1b0(%rsp),%r8
    1a6e:	00 
    1a6f:	eb 1f                	jmp    1a90 <mesh_packet+0x12b0>
    1a71:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    1a78:	0f b6 75 00          	movzbl 0x0(%rbp),%esi
    1a7c:	41 83 c2 01          	add    $0x1,%r10d
    1a80:	48 83 c2 08          	add    $0x8,%rdx
    1a84:	48 89 f1             	mov    %rsi,%rcx
    1a87:	41 39 f2             	cmp    %esi,%r10d
    1a8a:	0f 83 02 fe ff ff    	jae    1892 <mesh_packet+0x10b2>
    1a90:	41 83 c1 01          	add    $0x1,%r9d
    1a94:	48 8d 4a 04          	lea    0x4(%rdx),%rcx
    1a98:	4c 89 df             	mov    %r11,%rdi
    1a9b:	43 8d 04 49          	lea    (%r9,%r9,2),%eax
    1a9f:	8d 34 85 f4 ff ff ff 	lea    -0xc(,%rax,4),%esi
    1aa6:	4c 01 e6             	add    %r12,%rsi
    1aa9:	4c 01 ee             	add    %r13,%rsi
    1aac:	e8 df e5 ff ff       	call   90 <mesh_project>
    1ab1:	84 c0                	test   %al,%al
    1ab3:	75 c3                	jne    1a78 <mesh_packet+0x1298>
    1ab5:	e9 76 f1 ff ff       	jmp    c30 <mesh_packet+0x450>
    1aba:	85 c0                	test   %eax,%eax
    1abc:	74 7a                	je     1b38 <mesh_packet+0x1358>
    1abe:	44 8d 68 ff          	lea    -0x1(%rax),%r13d
    1ac2:	89 c5                	mov    %eax,%ebp
    1ac4:	4d 89 ec             	mov    %r13,%r12
    1ac7:	4c 8d 84 ec 70 03 00 	lea    0x370(%rsp,%rbp,8),%r8
    1ace:	00 
    1acf:	4c 8d 8c 2c 70 01 00 	lea    0x170(%rsp,%rbp,1),%r9
    1ad6:	00 
    1ad7:	49 29 ec             	sub    %rbp,%r12
    1ada:	eb 44                	jmp    1b20 <mesh_packet+0x1340>
    1adc:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    1ae3:	00 00 00 00 
    1ae7:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    1aee:	00 00 00 00 
    1af2:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    1af9:	00 00 00 00 
    1afd:	0f 1f 00             	nopl   (%rax)
    1b00:	4c 89 ca             	mov    %r9,%rdx
    1b03:	f2 41 0f 11 08       	movsd  %xmm1,(%r8)
    1b08:	49 83 e9 01          	sub    $0x1,%r9
    1b0c:	49 83 e8 08          	sub    $0x8,%r8
    1b10:	48 29 ea             	sub    %rbp,%rdx
    1b13:	42 0f b6 14 2a       	movzbl (%rdx,%r13,1),%edx
    1b18:	41 88 51 01          	mov    %dl,0x1(%r9)
    1b1c:	85 c0                	test   %eax,%eax
    1b1e:	74 18                	je     1b38 <mesh_packet+0x1358>
    1b20:	f2 43 0f 10 0c e0    	movsd  (%r8,%r12,8),%xmm1
    1b26:	89 c2                	mov    %eax,%edx
    1b28:	83 e8 01             	sub    $0x1,%eax
    1b2b:	66 0f 2f c8          	comisd %xmm0,%xmm1
    1b2f:	77 cf                	ja     1b00 <mesh_packet+0x1320>
    1b31:	89 d0                	mov    %edx,%eax
    1b33:	e9 3e fa ff ff       	jmp    1576 <mesh_packet+0xd96>
    1b38:	31 c0                	xor    %eax,%eax
    1b3a:	e9 37 fa ff ff       	jmp    1576 <mesh_packet+0xd96>
    1b3f:	31 d2                	xor    %edx,%edx
    1b41:	88 55 55             	mov    %dl,0x55(%rbp)
    1b44:	89 bc 24 70 03 00 00 	mov    %edi,0x370(%rsp)
    1b4b:	e9 db fe ff ff       	jmp    1a2b <mesh_packet+0x124b>
    1b50:	89 c2                	mov    %eax,%edx
    1b52:	89 c7                	mov    %eax,%edi
    1b54:	eb eb                	jmp    1b41 <mesh_packet+0x1361>
    1b56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    1b5d:	00 00 00 

0000000000001b60 <ayatsuri_model_open>:
    1b60:	41 57                	push   %r15
    1b62:	41 56                	push   %r14
    1b64:	41 55                	push   %r13
    1b66:	41 54                	push   %r12
    1b68:	55                   	push   %rbp
    1b69:	53                   	push   %rbx
    1b6a:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
    1b71:	48 85 ff             	test   %rdi,%rdi
    1b74:	74 2a                	je     1ba0 <ayatsuri_model_open+0x40>
    1b76:	48 89 d5             	mov    %rdx,%rbp
    1b79:	48 85 d2             	test   %rdx,%rdx
    1b7c:	74 22                	je     1ba0 <ayatsuri_model_open+0x40>
    1b7e:	48 8d 46 e0          	lea    -0x20(%rsi),%rax
    1b82:	48 3d e0 ff 0f 00    	cmp    $0xfffe0,%rax
    1b88:	77 16                	ja     1ba0 <ayatsuri_model_open+0x40>
    1b8a:	48 89 fb             	mov    %rdi,%rbx
    1b8d:	48 39 d7             	cmp    %rdx,%rdi
    1b90:	72 2e                	jb     1bc0 <ayatsuri_model_open+0x60>
    1b92:	48 89 fa             	mov    %rdi,%rdx
    1b95:	48 29 ea             	sub    %rbp,%rdx
    1b98:	48 83 fa 7f          	cmp    $0x7f,%rdx
    1b9c:	77 2a                	ja     1bc8 <ayatsuri_model_open+0x68>
    1b9e:	66 90                	xchg   %ax,%ax
    1ba0:	41 bc 01 00 00 00    	mov    $0x1,%r12d
    1ba6:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
    1bad:	44 89 e0             	mov    %r12d,%eax
    1bb0:	5b                   	pop    %rbx
    1bb1:	5d                   	pop    %rbp
    1bb2:	41 5c                	pop    %r12
    1bb4:	41 5d                	pop    %r13
    1bb6:	41 5e                	pop    %r14
    1bb8:	41 5f                	pop    %r15
    1bba:	c3                   	ret
    1bbb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    1bc0:	48 29 fa             	sub    %rdi,%rdx
    1bc3:	48 39 f2             	cmp    %rsi,%rdx
    1bc6:	72 d8                	jb     1ba0 <ayatsuri_model_open+0x40>
    1bc8:	81 3b 41 59 4e 4d    	cmpl   $0x4d4e5941,(%rbx)
    1bce:	75 d0                	jne    1ba0 <ayatsuri_model_open+0x40>
    1bd0:	66 83 7b 04 01       	cmpw   $0x1,0x4(%rbx)
    1bd5:	75 c9                	jne    1ba0 <ayatsuri_model_open+0x40>
    1bd7:	66 83 7b 06 20       	cmpw   $0x20,0x6(%rbx)
    1bdc:	75 c2                	jne    1ba0 <ayatsuri_model_open+0x40>
    1bde:	8b 53 08             	mov    0x8(%rbx),%edx
    1be1:	48 39 f2             	cmp    %rsi,%rdx
    1be4:	75 ba                	jne    1ba0 <ayatsuri_model_open+0x40>
    1be6:	44 8b 43 0c          	mov    0xc(%rbx),%r8d
    1bea:	41 8d 50 f9          	lea    -0x7(%r8),%edx
    1bee:	83 fa 39             	cmp    $0x39,%edx
    1bf1:	77 ad                	ja     1ba0 <ayatsuri_model_open+0x40>
    1bf3:	83 7b 10 20          	cmpl   $0x20,0x10(%rbx)
    1bf7:	75 a7                	jne    1ba0 <ayatsuri_model_open+0x40>
    1bf9:	83 7b 14 14          	cmpl   $0x14,0x14(%rbx)
    1bfd:	75 a1                	jne    1ba0 <ayatsuri_model_open+0x40>
    1bff:	8b 53 18             	mov    0x18(%rbx),%edx
    1c02:	85 d2                	test   %edx,%edx
    1c04:	75 9a                	jne    1ba0 <ayatsuri_model_open+0x40>
    1c06:	44 8b 63 1c          	mov    0x1c(%rbx),%r12d
    1c0a:	45 85 e4             	test   %r12d,%r12d
    1c0d:	75 91                	jne    1ba0 <ayatsuri_model_open+0x40>
    1c0f:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
    1c16:	cc cc cc 
    1c19:	44 89 c1             	mov    %r8d,%ecx
    1c1c:	48 f7 e2             	mul    %rdx
    1c1f:	48 89 d0             	mov    %rdx,%rax
    1c22:	48 c1 e8 04          	shr    $0x4,%rax
    1c26:	48 39 c8             	cmp    %rcx,%rax
    1c29:	0f 82 71 ff ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    1c2f:	41 6b c0 14          	imul   $0x14,%r8d,%eax
    1c33:	b9 1d 00 00 00       	mov    $0x1d,%ecx
    1c38:	31 d2                	xor    %edx,%edx
    1c3a:	45 31 ff             	xor    %r15d,%r15d
    1c3d:	48 8d bc 24 9c 00 00 	lea    0x9c(%rsp),%rdi
    1c44:	00 
    1c45:	48 89 9c 24 90 00 00 	mov    %rbx,0x90(%rsp)
    1c4c:	00 
    1c4d:	89 b4 24 98 00 00 00 	mov    %esi,0x98(%rsp)
    1c54:	83 c0 20             	add    $0x20,%eax
    1c57:	89 54 24 08          	mov    %edx,0x8(%rsp)
    1c5b:	44 89 e2             	mov    %r12d,%edx
    1c5e:	89 44 24 0c          	mov    %eax,0xc(%rsp)
    1c62:	31 c0                	xor    %eax,%eax
    1c64:	f3 ab                	rep stos %eax,%es:(%rdi)
    1c66:	48 8d 43 24          	lea    0x24(%rbx),%rax
    1c6a:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
    1c6f:	49 89 c5             	mov    %rax,%r13
    1c72:	41 0f b7 7d fe       	movzwl -0x2(%r13),%edi
    1c77:	45 8b 4d 00          	mov    0x0(%r13),%r9d
    1c7b:	45 8b 55 04          	mov    0x4(%r13),%r10d
    1c7f:	66 83 ff 01          	cmp    $0x1,%di
    1c83:	0f 87 17 ff ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    1c89:	41 f6 c1 07          	test   $0x7,%r9b
    1c8d:	0f 85 0d ff ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    1c93:	8b 44 24 0c          	mov    0xc(%rsp),%eax
    1c97:	41 39 c1             	cmp    %eax,%r9d
    1c9a:	0f 82 00 ff ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    1ca0:	45 89 cc             	mov    %r9d,%r12d
    1ca3:	4c 39 e6             	cmp    %r12,%rsi
    1ca6:	0f 82 f4 fe ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    1cac:	48 89 f0             	mov    %rsi,%rax
    1caf:	4c 29 e0             	sub    %r12,%rax
    1cb2:	4c 39 d0             	cmp    %r10,%rax
    1cb5:	0f 82 e5 fe ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    1cbb:	8b 44 24 08          	mov    0x8(%rsp),%eax
    1cbf:	85 c0                	test   %eax,%eax
    1cc1:	74 65                	je     1d28 <ayatsuri_model_open+0x1c8>
    1cc3:	4d 85 d2             	test   %r10,%r10
    1cc6:	44 89 7c 24 38       	mov    %r15d,0x38(%rsp)
    1ccb:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    1cd0:	4e 8d 34 23          	lea    (%rbx,%r12,1),%r14
    1cd4:	44 89 44 24 18       	mov    %r8d,0x18(%rsp)
    1cd9:	41 0f 95 c3          	setne  %r11b
    1cdd:	eb 15                	jmp    1cf4 <ayatsuri_model_open+0x194>
    1cdf:	4d 29 e0             	sub    %r12,%r8
    1ce2:	4d 39 d0             	cmp    %r10,%r8
    1ce5:	0f 82 b5 fe ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    1ceb:	48 83 c0 14          	add    $0x14,%rax
    1cef:	4c 39 e8             	cmp    %r13,%rax
    1cf2:	74 2a                	je     1d1e <ayatsuri_model_open+0x1be>
    1cf4:	8b 48 04             	mov    0x4(%rax),%ecx
    1cf7:	48 85 c9             	test   %rcx,%rcx
    1cfa:	74 ef                	je     1ceb <ayatsuri_model_open+0x18b>
    1cfc:	45 84 db             	test   %r11b,%r11b
    1cff:	74 ea                	je     1ceb <ayatsuri_model_open+0x18b>
    1d01:	44 8b 00             	mov    (%rax),%r8d
    1d04:	4e 8d 3c 03          	lea    (%rbx,%r8,1),%r15
    1d08:	4d 39 f7             	cmp    %r14,%r15
    1d0b:	73 d2                	jae    1cdf <ayatsuri_model_open+0x17f>
    1d0d:	4d 89 e7             	mov    %r12,%r15
    1d10:	4d 29 c7             	sub    %r8,%r15
    1d13:	49 39 cf             	cmp    %rcx,%r15
    1d16:	0f 82 84 fe ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    1d1c:	eb cd                	jmp    1ceb <ayatsuri_model_open+0x18b>
    1d1e:	44 8b 7c 24 38       	mov    0x38(%rsp),%r15d
    1d23:	44 8b 44 24 18       	mov    0x18(%rsp),%r8d
    1d28:	41 0f b7 4d fc       	movzwl -0x4(%r13),%ecx
    1d2d:	66 41 0f 6e 45 08    	movd   0x8(%r13),%xmm0
    1d33:	41 8b 45 0c          	mov    0xc(%r13),%eax
    1d37:	44 8d 59 ff          	lea    -0x1(%rcx),%r11d
    1d3b:	66 41 83 fb 0c       	cmp    $0xc,%r11w
    1d40:	0f 87 f5 01 00 00    	ja     1f3b <ayatsuri_model_open+0x3db>
    1d46:	83 e9 01             	sub    $0x1,%ecx
    1d49:	41 bb 01 00 00 00    	mov    $0x1,%r11d
    1d4f:	41 d3 e3             	shl    %cl,%r11d
    1d52:	66 83 ef 01          	sub    $0x1,%di
    1d56:	0f 85 44 fe ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    1d5c:	45 85 fb             	test   %r15d,%r11d
    1d5f:	0f 85 3b fe ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    1d65:	48 63 c9             	movslq %ecx,%rcx
    1d68:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 1d6f <ayatsuri_model_open+0x20f>
			1d6b: R_X86_64_PC32	.rodata-0x4
    1d6f:	39 04 8f             	cmp    %eax,(%rdi,%rcx,4)
    1d72:	0f 85 28 fe ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    1d78:	66 0f 7e c7          	movd   %xmm0,%edi
    1d7c:	48 0f af c7          	imul   %rdi,%rax
    1d80:	49 39 c2             	cmp    %rax,%r10
    1d83:	0f 85 17 fe ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    1d89:	66 41 0f 6e c9       	movd   %r9d,%xmm1
    1d8e:	45 09 df             	or     %r11d,%r15d
    1d91:	66 0f 62 c8          	punpckldq %xmm0,%xmm1
    1d95:	66 0f d6 8c cc a4 00 	movq   %xmm1,0xa4(%rsp,%rcx,8)
    1d9c:	00 00 
    1d9e:	83 44 24 08 01       	addl   $0x1,0x8(%rsp)
    1da3:	8b 44 24 08          	mov    0x8(%rsp),%eax
    1da7:	49 83 c5 14          	add    $0x14,%r13
    1dab:	41 39 c0             	cmp    %eax,%r8d
    1dae:	0f 85 be fe ff ff    	jne    1c72 <ayatsuri_model_open+0x112>
    1db4:	44 89 f8             	mov    %r15d,%eax
    1db7:	41 89 d4             	mov    %edx,%r12d
    1dba:	f7 d0                	not    %eax
    1dbc:	a8 7f                	test   $0x7f,%al
    1dbe:	0f 85 dc fd ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    1dc4:	44 89 f8             	mov    %r15d,%eax
    1dc7:	25 00 0f 00 00       	and    $0xf00,%eax
    1dcc:	89 44 24 38          	mov    %eax,0x38(%rsp)
    1dd0:	74 0b                	je     1ddd <ayatsuri_model_open+0x27d>
    1dd2:	3d 00 0f 00 00       	cmp    $0xf00,%eax
    1dd7:	0f 85 c3 fd ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    1ddd:	44 8b ac 24 a8 00 00 	mov    0xa8(%rsp),%r13d
    1de4:	00 
    1de5:	41 8d 45 ff          	lea    -0x1(%r13),%eax
    1de9:	3d ff 00 00 00       	cmp    $0xff,%eax
    1dee:	0f 87 ac fd ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    1df4:	44 39 ac 24 b0 00 00 	cmp    %r13d,0xb0(%rsp)
    1dfb:	00 
    1dfc:	0f 85 9e fd ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    1e02:	44 39 ac 24 d0 00 00 	cmp    %r13d,0xd0(%rsp)
    1e09:	00 
    1e0a:	0f 85 90 fd ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    1e10:	8b 84 24 b8 00 00 00 	mov    0xb8(%rsp),%eax
    1e17:	89 44 24 0c          	mov    %eax,0xc(%rsp)
    1e1b:	41 39 c5             	cmp    %eax,%r13d
    1e1e:	0f 82 7c fd ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    1e24:	8b 8c 24 c0 00 00 00 	mov    0xc0(%rsp),%ecx
    1e2b:	42 8d 04 ed 00 00 00 	lea    0x0(,%r13,8),%eax
    1e32:	00 
    1e33:	89 4c 24 10          	mov    %ecx,0x10(%rsp)
    1e37:	39 c8                	cmp    %ecx,%eax
    1e39:	0f 82 61 fd ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    1e3f:	8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%eax
    1e46:	89 44 24 08          	mov    %eax,0x8(%rsp)
    1e4a:	41 39 c5             	cmp    %eax,%r13d
    1e4d:	0f 82 4d fd ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    1e53:	41 6b c5 7f          	imul   $0x7f,%r13d,%eax
    1e57:	44 8b b4 24 d8 00 00 	mov    0xd8(%rsp),%r14d
    1e5e:	00 
    1e5f:	44 39 f0             	cmp    %r14d,%eax
    1e62:	0f 82 38 fd ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    1e68:	41 f6 c7 80          	test   $0x80,%r15b
    1e6c:	74 13                	je     1e81 <ayatsuri_model_open+0x321>
    1e6e:	8b 84 24 e0 00 00 00 	mov    0xe0(%rsp),%eax
    1e75:	83 e8 01             	sub    $0x1,%eax
    1e78:	44 39 e8             	cmp    %r13d,%eax
    1e7b:	0f 83 1f fd ff ff    	jae    1ba0 <ayatsuri_model_open+0x40>
    1e81:	83 7c 24 38 00       	cmpl   $0x0,0x38(%rsp)
    1e86:	74 4c                	je     1ed4 <ayatsuri_model_open+0x374>
    1e88:	8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%eax
    1e8f:	83 e8 01             	sub    $0x1,%eax
    1e92:	44 39 e8             	cmp    %r13d,%eax
    1e95:	0f 83 05 fd ff ff    	jae    1ba0 <ayatsuri_model_open+0x40>
    1e9b:	44 89 e8             	mov    %r13d,%eax
    1e9e:	c1 e0 05             	shl    $0x5,%eax
    1ea1:	3b 84 24 f0 00 00 00 	cmp    0xf0(%rsp),%eax
    1ea8:	0f 82 f2 fc ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    1eae:	44 89 e8             	mov    %r13d,%eax
    1eb1:	c1 e0 06             	shl    $0x6,%eax
    1eb4:	3b 84 24 f8 00 00 00 	cmp    0xf8(%rsp),%eax
    1ebb:	0f 82 df fc ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    1ec1:	44 89 e8             	mov    %r13d,%eax
    1ec4:	c1 e0 04             	shl    $0x4,%eax
    1ec7:	3b 84 24 00 01 00 00 	cmp    0x100(%rsp),%eax
    1ece:	0f 82 cc fc ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    1ed4:	41 81 e7 00 10 00 00 	and    $0x1000,%r15d
    1edb:	0f 84 81 00 00 00    	je     1f62 <ayatsuri_model_open+0x402>
    1ee1:	8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%ecx
    1ee8:	85 c9                	test   %ecx,%ecx
    1eea:	0f 84 b0 fc ff ff    	je     1ba0 <ayatsuri_model_open+0x40>
    1ef0:	39 4c 24 08          	cmp    %ecx,0x8(%rsp)
    1ef4:	0f 85 a6 fc ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    1efa:	8b 84 24 04 01 00 00 	mov    0x104(%rsp),%eax
    1f01:	31 d2                	xor    %edx,%edx
    1f03:	48 01 d8             	add    %rbx,%rax
    1f06:	eb 29                	jmp    1f31 <ayatsuri_model_open+0x3d1>
    1f08:	80 78 01 00          	cmpb   $0x0,0x1(%rax)
    1f0c:	0f 85 8e fc ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    1f12:	80 78 02 00          	cmpb   $0x0,0x2(%rax)
    1f16:	0f 85 84 fc ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    1f1c:	80 78 03 00          	cmpb   $0x0,0x3(%rax)
    1f20:	0f 85 7a fc ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    1f26:	83 c2 01             	add    $0x1,%edx
    1f29:	48 83 c0 04          	add    $0x4,%rax
    1f2d:	39 ca                	cmp    %ecx,%edx
    1f2f:	73 31                	jae    1f62 <ayatsuri_model_open+0x402>
    1f31:	80 38 01             	cmpb   $0x1,(%rax)
    1f34:	76 d2                	jbe    1f08 <ayatsuri_model_open+0x3a8>
    1f36:	e9 65 fc ff ff       	jmp    1ba0 <ayatsuri_model_open+0x40>
    1f3b:	66 85 ff             	test   %di,%di
    1f3e:	0f 85 5c fc ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    1f44:	85 c0                	test   %eax,%eax
    1f46:	0f 84 52 fe ff ff    	je     1d9e <ayatsuri_model_open+0x23e>
    1f4c:	66 0f 7e c1          	movd   %xmm0,%ecx
    1f50:	48 0f af c1          	imul   %rcx,%rax
    1f54:	49 39 c2             	cmp    %rax,%r10
    1f57:	0f 83 41 fe ff ff    	jae    1d9e <ayatsuri_model_open+0x23e>
    1f5d:	e9 3e fc ff ff       	jmp    1ba0 <ayatsuri_model_open+0x40>
    1f62:	8b 84 24 f0 00 00 00 	mov    0xf0(%rsp),%eax
    1f69:	44 8b 84 24 ec 00 00 	mov    0xec(%rsp),%r8d
    1f70:	00 
    1f71:	31 d2                	xor    %edx,%edx
    1f73:	66 44 89 ac 24 9c 00 	mov    %r13w,0x9c(%rsp)
    1f7a:	00 00 
    1f7c:	f3 0f 10 25 00 00 00 	movss  0x0(%rip),%xmm4        # 1f84 <ayatsuri_model_open+0x424>
    1f83:	00 
			1f80: R_X86_64_PC32	.LC1-0x4
    1f84:	f3 0f 7e 1d 00 00 00 	movq   0x0(%rip),%xmm3        # 1f8c <ayatsuri_model_open+0x42c>
    1f8b:	00 
			1f88: R_X86_64_PC32	.LC8-0x4
    1f8c:	f3 0f 10 2d 00 00 00 	movss  0x0(%rip),%xmm5        # 1f94 <ayatsuri_model_open+0x434>
    1f93:	00 
			1f90: R_X86_64_PC32	.LC0-0x4
    1f94:	89 44 24 18          	mov    %eax,0x18(%rsp)
    1f98:	8b 44 24 18          	mov    0x18(%rsp),%eax
    1f9c:	39 c2                	cmp    %eax,%edx
    1f9e:	74 61                	je     2001 <ayatsuri_model_open+0x4a1>
    1fa0:	6b ca 1c             	imul   $0x1c,%edx,%ecx
    1fa3:	31 c0                	xor    %eax,%eax
    1fa5:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1fa9:	4c 01 c1             	add    %r8,%rcx
    1fac:	48 01 d9             	add    %rbx,%rcx
    1faf:	f3 0f 10 0c 81       	movss  (%rcx,%rax,4),%xmm1
    1fb4:	0f 28 d1             	movaps %xmm1,%xmm2
    1fb7:	0f 54 d5             	andps  %xmm5,%xmm2
    1fba:	0f 2e e2             	ucomiss %xmm2,%xmm4
    1fbd:	0f 82 dd fb ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    1fc3:	0f 2f 15 00 00 00 00 	comiss 0x0(%rip),%xmm2        # 1fca <ayatsuri_model_open+0x46a>
			1fc6: R_X86_64_PC32	.LC3-0x4
    1fca:	0f 87 d0 fb ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    1fd0:	8d 70 fd             	lea    -0x3(%rax),%esi
    1fd3:	83 fe 02             	cmp    $0x2,%esi
    1fd6:	76 7d                	jbe    2055 <ayatsuri_model_open+0x4f5>
    1fd8:	48 83 c0 01          	add    $0x1,%rax
    1fdc:	48 83 f8 07          	cmp    $0x7,%rax
    1fe0:	75 cd                	jne    1faf <ayatsuri_model_open+0x44f>
    1fe2:	f2 0f 5c 05 00 00 00 	subsd  0x0(%rip),%xmm0        # 1fea <ayatsuri_model_open+0x48a>
    1fe9:	00 
			1fe6: R_X86_64_PC32	.LC9-0x4
    1fea:	66 0f 54 c3          	andpd  %xmm3,%xmm0
    1fee:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 1ff6 <ayatsuri_model_open+0x496>
    1ff5:	00 
			1ff2: R_X86_64_PC32	.LC29-0x4
    1ff6:	0f 87 a4 fb ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    1ffc:	83 c2 01             	add    $0x1,%edx
    1fff:	eb 97                	jmp    1f98 <ayatsuri_model_open+0x438>
    2001:	8b 84 24 f8 00 00 00 	mov    0xf8(%rsp),%eax
    2008:	31 d2                	xor    %edx,%edx
    200a:	89 44 24 28          	mov    %eax,0x28(%rsp)
    200e:	8b 84 24 f4 00 00 00 	mov    0xf4(%rsp),%eax
    2015:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
    201a:	8b 44 24 28          	mov    0x28(%rsp),%eax
    201e:	39 c2                	cmp    %eax,%edx
    2020:	74 48                	je     206a <ayatsuri_model_open+0x50a>
    2022:	6b c2 06             	imul   $0x6,%edx,%eax
    2025:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    202a:	48 01 c8             	add    %rcx,%rax
    202d:	66 83 3c 03 1f       	cmpw   $0x1f,(%rbx,%rax,1)
    2032:	0f 87 68 fb ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    2038:	66 83 7c 03 02 1f    	cmpw   $0x1f,0x2(%rbx,%rax,1)
    203e:	0f 87 5c fb ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    2044:	66 83 7c 03 04 1f    	cmpw   $0x1f,0x4(%rbx,%rax,1)
    204a:	0f 87 50 fb ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    2050:	83 c2 01             	add    $0x1,%edx
    2053:	eb c5                	jmp    201a <ayatsuri_model_open+0x4ba>
    2055:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
    2059:	f2 0f 59 c9          	mulsd  %xmm1,%xmm1
    205d:	48 83 c0 01          	add    $0x1,%rax
    2061:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    2065:	e9 45 ff ff ff       	jmp    1faf <ayatsuri_model_open+0x44f>
    206a:	8b 84 24 00 01 00 00 	mov    0x100(%rsp),%eax
    2071:	8b b4 24 fc 00 00 00 	mov    0xfc(%rsp),%esi
    2078:	31 d2                	xor    %edx,%edx
    207a:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 2082 <ayatsuri_model_open+0x522>
    2081:	00 
			207e: R_X86_64_PC32	.LC0-0x4
    2082:	f3 0f 10 0d 00 00 00 	movss  0x0(%rip),%xmm1        # 208a <ayatsuri_model_open+0x52a>
    2089:	00 
			2086: R_X86_64_PC32	.LC1-0x4
    208a:	89 44 24 30          	mov    %eax,0x30(%rsp)
    208e:	8b 44 24 30          	mov    0x30(%rsp),%eax
    2092:	39 c2                	cmp    %eax,%edx
    2094:	74 38                	je     20ce <ayatsuri_model_open+0x56e>
    2096:	6b c2 0c             	imul   $0xc,%edx,%eax
    2099:	31 c9                	xor    %ecx,%ecx
    209b:	48 01 f0             	add    %rsi,%rax
    209e:	48 01 d8             	add    %rbx,%rax
    20a1:	f3 0f 10 04 88       	movss  (%rax,%rcx,4),%xmm0
    20a6:	0f 54 c2             	andps  %xmm2,%xmm0
    20a9:	0f 2e c8             	ucomiss %xmm0,%xmm1
    20ac:	0f 82 ee fa ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    20b2:	0f 2f 05 00 00 00 00 	comiss 0x0(%rip),%xmm0        # 20b9 <ayatsuri_model_open+0x559>
			20b5: R_X86_64_PC32	.LC3-0x4
    20b9:	0f 87 e1 fa ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    20bf:	48 83 c1 01          	add    $0x1,%rcx
    20c3:	48 83 f9 03          	cmp    $0x3,%rcx
    20c7:	75 d8                	jne    20a1 <ayatsuri_model_open+0x541>
    20c9:	83 c2 01             	add    $0x1,%edx
    20cc:	eb c0                	jmp    208e <ayatsuri_model_open+0x52e>
    20ce:	8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%eax
    20d5:	48 89 6c 24 48       	mov    %rbp,0x48(%rsp)
    20da:	31 d2                	xor    %edx,%edx
    20dc:	66 0f ef f6          	pxor   %xmm6,%xmm6
    20e0:	89 44 24 3c          	mov    %eax,0x3c(%rsp)
    20e4:	8b 84 24 e4 00 00 00 	mov    0xe4(%rsp),%eax
    20eb:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
    20f0:	8b 44 24 3c          	mov    0x3c(%rsp),%eax
    20f4:	39 c2                	cmp    %eax,%edx
    20f6:	0f 84 5c 02 00 00    	je     2358 <ayatsuri_model_open+0x7f8>
    20fc:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
    2101:	89 d0                	mov    %edx,%eax
    2103:	c1 e0 05             	shl    $0x5,%eax
    2106:	48 01 c8             	add    %rcx,%rax
    2109:	48 01 d8             	add    %rbx,%rax
    210c:	44 0f b7 50 02       	movzwl 0x2(%rax),%r10d
    2111:	44 0f b7 08          	movzwl (%rax),%r9d
    2115:	0f b7 48 04          	movzwl 0x4(%rax),%ecx
    2119:	44 0f b7 58 06       	movzwl 0x6(%rax),%r11d
    211e:	41 8d 72 fd          	lea    -0x3(%r10),%esi
    2122:	0f b7 68 08          	movzwl 0x8(%rax),%ebp
    2126:	83 fe 1d             	cmp    $0x1d,%esi
    2129:	0f 87 71 fa ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    212f:	41 8d 73 ff          	lea    -0x1(%r11),%esi
    2133:	83 fe 3f             	cmp    $0x3f,%esi
    2136:	0f 87 64 fa ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    213c:	0f b6 78 0a          	movzbl 0xa(%rax),%edi
    2140:	40 80 ff 02          	cmp    $0x2,%dil
    2144:	0f 87 56 fa ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    214a:	80 78 0b 01          	cmpb   $0x1,0xb(%rax)
    214e:	0f 87 4c fa ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    2154:	8b 74 24 18          	mov    0x18(%rsp),%esi
    2158:	44 39 ce             	cmp    %r9d,%esi
    215b:	0f 82 3f fa ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    2161:	44 29 ce             	sub    %r9d,%esi
    2164:	44 39 d6             	cmp    %r10d,%esi
    2167:	0f 82 33 fa ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    216d:	8b 74 24 28          	mov    0x28(%rsp),%esi
    2171:	39 ce                	cmp    %ecx,%esi
    2173:	0f 82 27 fa ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    2179:	29 ce                	sub    %ecx,%esi
    217b:	44 39 de             	cmp    %r11d,%esi
    217e:	0f 82 1c fa ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    2184:	0f b6 70 0c          	movzbl 0xc(%rax),%esi
    2188:	40 84 ff             	test   %dil,%dil
    218b:	0f 85 94 01 00 00    	jne    2325 <ayatsuri_model_open+0x7c5>
    2191:	40 84 f6             	test   %sil,%sil
    2194:	0f 85 06 fa ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    219a:	31 f6                	xor    %esi,%esi
    219c:	80 78 0d 00          	cmpb   $0x0,0xd(%rax)
    21a0:	0f 85 fa f9 ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    21a6:	8b 7c 24 30          	mov    0x30(%rsp),%edi
    21aa:	39 ef                	cmp    %ebp,%edi
    21ac:	0f 82 ee f9 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    21b2:	29 ef                	sub    %ebp,%edi
    21b4:	39 f7                	cmp    %esi,%edi
    21b6:	0f 82 e4 f9 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    21bc:	be 13 00 00 00       	mov    $0x13,%esi
    21c1:	80 3c 30 00          	cmpb   $0x0,(%rax,%rsi,1)
    21c5:	0f 85 d5 f9 ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    21cb:	48 83 c6 01          	add    $0x1,%rsi
    21cf:	48 83 fe 20          	cmp    $0x20,%rsi
    21d3:	75 ec                	jne    21c1 <ayatsuri_model_open+0x661>
    21d5:	6b f9 06             	imul   $0x6,%ecx,%edi
    21d8:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
    21dd:	31 ed                	xor    %ebp,%ebp
    21df:	48 01 c7             	add    %rax,%rdi
    21e2:	48 01 df             	add    %rbx,%rdi
    21e5:	0f b7 0f             	movzwl (%rdi),%ecx
    21e8:	0f b7 47 02          	movzwl 0x2(%rdi),%eax
    21ec:	0f b7 77 04          	movzwl 0x4(%rdi),%esi
    21f0:	39 c1                	cmp    %eax,%ecx
    21f2:	41 89 c7             	mov    %eax,%r15d
    21f5:	44 0f 43 f9          	cmovae %ecx,%r15d
    21f9:	45 39 d7             	cmp    %r10d,%r15d
    21fc:	0f 83 9e f9 ff ff    	jae    1ba0 <ayatsuri_model_open+0x40>
    2202:	44 39 d6             	cmp    %r10d,%esi
    2205:	0f 83 95 f9 ff ff    	jae    1ba0 <ayatsuri_model_open+0x40>
    220b:	39 c1                	cmp    %eax,%ecx
    220d:	0f 84 8d f9 ff ff    	je     1ba0 <ayatsuri_model_open+0x40>
    2213:	39 f1                	cmp    %esi,%ecx
    2215:	0f 84 85 f9 ff ff    	je     1ba0 <ayatsuri_model_open+0x40>
    221b:	39 f0                	cmp    %esi,%eax
    221d:	41 0f 94 c7          	sete   %r15b
    2221:	0f 84 79 f9 ff ff    	je     1ba0 <ayatsuri_model_open+0x40>
    2227:	44 01 c9             	add    %r9d,%ecx
    222a:	44 01 c8             	add    %r9d,%eax
    222d:	66 0f ef ed          	pxor   %xmm5,%xmm5
    2231:	44 01 ce             	add    %r9d,%esi
    2234:	6b c9 1c             	imul   $0x1c,%ecx,%ecx
    2237:	66 0f ef c0          	pxor   %xmm0,%xmm0
    223b:	66 0f ef e4          	pxor   %xmm4,%xmm4
    223f:	6b c0 1c             	imul   $0x1c,%eax,%eax
    2242:	66 0f ef db          	pxor   %xmm3,%xmm3
    2246:	66 0f ef d2          	pxor   %xmm2,%xmm2
    224a:	6b f6 1c             	imul   $0x1c,%esi,%esi
    224d:	66 0f ef ff          	pxor   %xmm7,%xmm7
    2251:	66 0f ef c9          	pxor   %xmm1,%xmm1
    2255:	4c 01 c1             	add    %r8,%rcx
    2258:	4c 01 c0             	add    %r8,%rax
    225b:	48 01 d9             	add    %rbx,%rcx
    225e:	4c 01 c6             	add    %r8,%rsi
    2261:	48 01 d8             	add    %rbx,%rax
    2264:	f3 0f 5a 29          	cvtss2sd (%rcx),%xmm5
    2268:	f3 0f 5a 59 04       	cvtss2sd 0x4(%rcx),%xmm3
    226d:	48 01 de             	add    %rbx,%rsi
    2270:	f3 0f 5a 00          	cvtss2sd (%rax),%xmm0
    2274:	f2 0f 5c c5          	subsd  %xmm5,%xmm0
    2278:	f3 0f 5a 79 08       	cvtss2sd 0x8(%rcx),%xmm7
    227d:	f3 0f 5a 26          	cvtss2sd (%rsi),%xmm4
    2281:	f2 0f 5c e5          	subsd  %xmm5,%xmm4
    2285:	66 0f ef ed          	pxor   %xmm5,%xmm5
    2289:	f3 0f 5a 50 04       	cvtss2sd 0x4(%rax),%xmm2
    228e:	f3 0f 5a 48 08       	cvtss2sd 0x8(%rax),%xmm1
    2293:	f2 0f 5c d3          	subsd  %xmm3,%xmm2
    2297:	f2 0f 5c cf          	subsd  %xmm7,%xmm1
    229b:	f3 0f 5a 6e 04       	cvtss2sd 0x4(%rsi),%xmm5
    22a0:	f2 0f 5c eb          	subsd  %xmm3,%xmm5
    22a4:	66 0f ef db          	pxor   %xmm3,%xmm3
    22a8:	f3 0f 5a 5e 08       	cvtss2sd 0x8(%rsi),%xmm3
    22ad:	f2 0f 5c df          	subsd  %xmm7,%xmm3
    22b1:	66 44 0f 28 c1       	movapd %xmm1,%xmm8
    22b6:	66 0f 28 fa          	movapd %xmm2,%xmm7
    22ba:	f2 44 0f 59 c5       	mulsd  %xmm5,%xmm8
    22bf:	f2 0f 59 fb          	mulsd  %xmm3,%xmm7
    22c3:	f2 0f 59 cc          	mulsd  %xmm4,%xmm1
    22c7:	f2 0f 59 d8          	mulsd  %xmm0,%xmm3
    22cb:	f2 41 0f 5c f8       	subsd  %xmm8,%xmm7
    22d0:	f2 0f 5c cb          	subsd  %xmm3,%xmm1
    22d4:	66 0f 2e fe          	ucomisd %xmm6,%xmm7
    22d8:	0f 9b c0             	setnp  %al
    22db:	41 0f 45 c7          	cmovne %r15d,%eax
    22df:	66 0f 2e ce          	ucomisd %xmm6,%xmm1
    22e3:	0f 9b c1             	setnp  %cl
    22e6:	41 0f 45 cf          	cmovne %r15d,%ecx
    22ea:	84 c8                	test   %cl,%al
    22ec:	74 1f                	je     230d <ayatsuri_model_open+0x7ad>
    22ee:	f2 0f 59 c5          	mulsd  %xmm5,%xmm0
    22f2:	f2 0f 59 d4          	mulsd  %xmm4,%xmm2
    22f6:	f2 0f 5c c2          	subsd  %xmm2,%xmm0
    22fa:	66 0f 2e c6          	ucomisd %xmm6,%xmm0
    22fe:	0f 9b c0             	setnp  %al
    2301:	41 0f 45 c7          	cmovne %r15d,%eax
    2305:	84 c0                	test   %al,%al
    2307:	0f 85 93 f8 ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    230d:	83 c5 01             	add    $0x1,%ebp
    2310:	48 83 c7 06          	add    $0x6,%rdi
    2314:	44 39 dd             	cmp    %r11d,%ebp
    2317:	0f 82 c8 fe ff ff    	jb     21e5 <ayatsuri_model_open+0x685>
    231d:	83 c2 01             	add    $0x1,%edx
    2320:	e9 cb fd ff ff       	jmp    20f0 <ayatsuri_model_open+0x590>
    2325:	44 8d 7e fd          	lea    -0x3(%rsi),%r15d
    2329:	41 80 ff 05          	cmp    $0x5,%r15b
    232d:	0f 87 6d f8 ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    2333:	44 0f b6 78 0d       	movzbl 0xd(%rax),%r15d
    2338:	40 80 ff 02          	cmp    $0x2,%dil
    233c:	0f 85 5a fe ff ff    	jne    219c <ayatsuri_model_open+0x63c>
    2342:	41 8d 7f fd          	lea    -0x3(%r15),%edi
    2346:	40 80 ff 05          	cmp    $0x5,%dil
    234a:	0f 87 50 f8 ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    2350:	44 01 fe             	add    %r15d,%esi
    2353:	e9 4e fe ff ff       	jmp    21a6 <ayatsuri_model_open+0x646>
    2358:	8b 84 24 d4 00 00 00 	mov    0xd4(%rsp),%eax
    235f:	48 8b 6c 24 48       	mov    0x48(%rsp),%rbp
    2364:	48 89 c1             	mov    %rax,%rcx
    2367:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
    236c:	31 c0                	xor    %eax,%eax
    236e:	48 01 d9             	add    %rbx,%rcx
    2371:	eb 21                	jmp    2394 <ayatsuri_model_open+0x834>
    2373:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    237a:	00 00 00 00 
    237e:	66 90                	xchg   %ax,%ax
    2380:	0f b6 3c 01          	movzbl (%rcx,%rax,1),%edi
    2384:	48 83 c0 01          	add    $0x1,%rax
    2388:	8d 57 e0             	lea    -0x20(%rdi),%edx
    238b:	80 fa 5e             	cmp    $0x5e,%dl
    238e:	0f 87 0c f8 ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    2394:	44 39 f0             	cmp    %r14d,%eax
    2397:	72 e7                	jb     2380 <ayatsuri_model_open+0x820>
    2399:	8b 84 24 ac 00 00 00 	mov    0xac(%rsp),%eax
    23a0:	b9 09 00 00 00       	mov    $0x9,%ecx
    23a5:	ba 09 00 00 00       	mov    $0x9,%edx
    23aa:	44 89 ee             	mov    %r13d,%esi
    23ad:	48 01 d8             	add    %rbx,%rax
    23b0:	48 89 c7             	mov    %rax,%rdi
    23b3:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
    23b8:	e8 53 dc ff ff       	call   10 <float_rows_valid>
    23bd:	84 c0                	test   %al,%al
    23bf:	0f 84 db f7 ff ff    	je     1ba0 <ayatsuri_model_open+0x40>
    23c5:	8b bc 24 b4 00 00 00 	mov    0xb4(%rsp),%edi
    23cc:	8b 74 24 0c          	mov    0xc(%rsp),%esi
    23d0:	31 c9                	xor    %ecx,%ecx
    23d2:	ba 03 00 00 00       	mov    $0x3,%edx
    23d7:	48 01 df             	add    %rbx,%rdi
    23da:	e8 31 dc ff ff       	call   10 <float_rows_valid>
    23df:	84 c0                	test   %al,%al
    23e1:	0f 84 b9 f7 ff ff    	je     1ba0 <ayatsuri_model_open+0x40>
    23e7:	8b bc 24 bc 00 00 00 	mov    0xbc(%rsp),%edi
    23ee:	8b 74 24 10          	mov    0x10(%rsp),%esi
    23f2:	b9 03 00 00 00       	mov    $0x3,%ecx
    23f7:	ba 06 00 00 00       	mov    $0x6,%edx
    23fc:	48 01 df             	add    %rbx,%rdi
    23ff:	e8 0c dc ff ff       	call   10 <float_rows_valid>
    2404:	84 c0                	test   %al,%al
    2406:	0f 84 94 f7 ff ff    	je     1ba0 <ayatsuri_model_open+0x40>
    240c:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
    2410:	8b bc 24 c4 00 00 00 	mov    0xc4(%rsp),%edi
    2417:	f3 0f 7e 15 00 00 00 	movq   0x0(%rip),%xmm2        # 241f <ayatsuri_model_open+0x8bf>
    241e:	00 
			241b: R_X86_64_PC32	.LC8-0x4
    241f:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 2427 <ayatsuri_model_open+0x8c7>
    2426:	00 
			2423: R_X86_64_PC32	.LC22-0x4
    2427:	48 6b c9 48          	imul   $0x48,%rcx,%rcx
    242b:	48 89 7c 24 48       	mov    %rdi,0x48(%rsp)
    2430:	48 8d 14 3b          	lea    (%rbx,%rdi,1),%rdx
    2434:	48 01 f9             	add    %rdi,%rcx
    2437:	48 01 d9             	add    %rbx,%rcx
    243a:	48 39 ca             	cmp    %rcx,%rdx
    243d:	0f 84 02 01 00 00    	je     2545 <ayatsuri_model_open+0x9e5>
    2443:	31 f6                	xor    %esi,%esi
    2445:	f3 0f 10 04 b2       	movss  (%rdx,%rsi,4),%xmm0
    244a:	48 83 fe 03          	cmp    $0x3,%rsi
    244e:	0f 84 bd 02 00 00    	je     2711 <ayatsuri_model_open+0xbb1>
    2454:	66 0f ef db          	pxor   %xmm3,%xmm3
    2458:	f3 0f 5a d8          	cvtss2sd %xmm0,%xmm3
    245c:	66 0f 54 da          	andpd  %xmm2,%xmm3
    2460:	66 0f 2e cb          	ucomisd %xmm3,%xmm1
    2464:	0f 82 36 f7 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    246a:	66 0f ef db          	pxor   %xmm3,%xmm3
    246e:	0f 2f c3             	comiss %xmm3,%xmm0
    2471:	0f 82 29 f7 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    2477:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 247f <ayatsuri_model_open+0x91f>
    247e:	00 
			247b: R_X86_64_PC32	.LC17-0x4
    247f:	0f 2f d8             	comiss %xmm0,%xmm3
    2482:	0f 82 18 f7 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    2488:	48 83 c6 01          	add    $0x1,%rsi
    248c:	48 83 fe 0b          	cmp    $0xb,%rsi
    2490:	75 b3                	jne    2445 <ayatsuri_model_open+0x8e5>
    2492:	81 7a 2c ff ff ff 00 	cmpl   $0xffffff,0x2c(%rdx)
    2499:	0f 87 01 f7 ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    249f:	48 8d 7a 30          	lea    0x30(%rdx),%rdi
    24a3:	e8 58 db ff ff       	call   0 <md>
    24a8:	66 0f 28 d8          	movapd %xmm0,%xmm3
    24ac:	66 0f 54 da          	andpd  %xmm2,%xmm3
    24b0:	66 0f 2e cb          	ucomisd %xmm3,%xmm1
    24b4:	0f 82 e6 f6 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    24ba:	66 0f ef db          	pxor   %xmm3,%xmm3
    24be:	66 0f 2f c3          	comisd %xmm3,%xmm0
    24c2:	0f 82 d8 f6 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    24c8:	f2 0f 10 1d 00 00 00 	movsd  0x0(%rip),%xmm3        # 24d0 <ayatsuri_model_open+0x970>
    24cf:	00 
			24cc: R_X86_64_PC32	.LC9-0x4
    24d0:	66 0f 2f d8          	comisd %xmm0,%xmm3
    24d4:	0f 82 c6 f6 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    24da:	48 8d 7a 38          	lea    0x38(%rdx),%rdi
    24de:	e8 1d db ff ff       	call   0 <md>
    24e3:	66 0f 28 e0          	movapd %xmm0,%xmm4
    24e7:	66 0f 54 e2          	andpd  %xmm2,%xmm4
    24eb:	66 0f 2e cc          	ucomisd %xmm4,%xmm1
    24ef:	0f 82 ab f6 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    24f5:	66 0f ef e4          	pxor   %xmm4,%xmm4
    24f9:	66 0f 2f c4          	comisd %xmm4,%xmm0
    24fd:	0f 82 9d f6 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    2503:	66 0f 2f d8          	comisd %xmm0,%xmm3
    2507:	0f 82 93 f6 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    250d:	48 8d 7a 40          	lea    0x40(%rdx),%rdi
    2511:	e8 ea da ff ff       	call   0 <md>
    2516:	66 0f 28 e8          	movapd %xmm0,%xmm5
    251a:	66 0f 54 ea          	andpd  %xmm2,%xmm5
    251e:	66 0f 2e cd          	ucomisd %xmm5,%xmm1
    2522:	0f 82 78 f6 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    2528:	66 0f 2f c4          	comisd %xmm4,%xmm0
    252c:	0f 82 6e f6 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    2532:	48 83 c2 48          	add    $0x48,%rdx
    2536:	66 0f 2f d8          	comisd %xmm0,%xmm3
    253a:	0f 82 60 f6 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    2540:	e9 f5 fe ff ff       	jmp    243a <ayatsuri_model_open+0x8da>
    2545:	8b bc 24 08 01 00 00 	mov    0x108(%rsp),%edi
    254c:	8b 8c 24 a4 00 00 00 	mov    0xa4(%rsp),%ecx
    2553:	88 44 24 63          	mov    %al,0x63(%rsp)
    2557:	45 31 d2             	xor    %r10d,%r10d
    255a:	8b 94 24 04 01 00 00 	mov    0x104(%rsp),%edx
    2561:	4c 8b 5c 24 28       	mov    0x28(%rsp),%r11
    2566:	48 01 d9             	add    %rbx,%rcx
    2569:	89 7c 24 40          	mov    %edi,0x40(%rsp)
    256d:	8b bc 24 cc 00 00 00 	mov    0xcc(%rsp),%edi
    2574:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
    2579:	49 89 cf             	mov    %rcx,%r15
    257c:	48 8d 0c 13          	lea    (%rbx,%rdx,1),%rcx
    2580:	4c 87 dd             	xchg   %r11,%rbp
    2583:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
    2588:	48 8d 8c 24 90 00 00 	lea    0x90(%rsp),%rcx
    258f:	00 
    2590:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
    2595:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
    259a:	48 89 d9             	mov    %rbx,%rcx
    259d:	44 89 d3             	mov    %r10d,%ebx
    25a0:	45 89 e2             	mov    %r12d,%r10d
    25a3:	49 89 cc             	mov    %rcx,%r12
    25a6:	41 0f b7 17          	movzwl (%r15),%edx
    25aa:	89 d0                	mov    %edx,%eax
    25ac:	0d 00 00 ff ff       	or     $0xffff0000,%eax
    25b1:	66 85 d2             	test   %dx,%dx
    25b4:	78 03                	js     25b9 <ayatsuri_model_open+0xa59>
    25b6:	0f b7 c2             	movzwl %dx,%eax
    25b9:	41 0f b7 77 04       	movzwl 0x4(%r15),%esi
    25be:	41 0f b7 7f 06       	movzwl 0x6(%r15),%edi
    25c3:	41 0f b7 57 08       	movzwl 0x8(%r15),%edx
    25c8:	45 0f b7 47 0a       	movzwl 0xa(%r15),%r8d
    25cd:	f3 41 0f 10 47 0c    	movss  0xc(%r15),%xmm0
    25d3:	83 f8 ff             	cmp    $0xffffffff,%eax
    25d6:	0f 8c c4 f5 ff ff    	jl     1ba0 <ayatsuri_model_open+0x40>
    25dc:	39 c3                	cmp    %eax,%ebx
    25de:	0f 8e bc f5 ff ff    	jle    1ba0 <ayatsuri_model_open+0x40>
    25e4:	41 0f b6 47 02       	movzbl 0x2(%r15),%eax
    25e9:	3c 03                	cmp    $0x3,%al
    25eb:	0f 87 af f5 ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    25f1:	41 80 7f 03 01       	cmpb   $0x1,0x3(%r15)
    25f6:	0f 87 a4 f5 ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    25fc:	45 39 e8             	cmp    %r13d,%r8d
    25ff:	0f 83 9b f5 ff ff    	jae    1ba0 <ayatsuri_model_open+0x40>
    2605:	f3 0f 10 35 00 00 00 	movss  0x0(%rip),%xmm6        # 260d <ayatsuri_model_open+0xaad>
    260c:	00 
			2609: R_X86_64_PC32	.LC1-0x4
    260d:	0f 28 c8             	movaps %xmm0,%xmm1
    2610:	0f 54 0d 00 00 00 00 	andps  0x0(%rip),%xmm1        # 2617 <ayatsuri_model_open+0xab7>
			2613: R_X86_64_PC32	.LC0-0x4
    2617:	0f 2e f1             	ucomiss %xmm1,%xmm6
    261a:	0f 82 80 f5 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    2620:	f3 0f 10 4d 18       	movss  0x18(%rbp),%xmm1
    2625:	66 0f ef f6          	pxor   %xmm6,%xmm6
    2629:	0f 2e ce             	ucomiss %xmm6,%xmm1
    262c:	7a 06                	jp     2634 <ayatsuri_model_open+0xad4>
    262e:	0f 84 6c f5 ff ff    	je     1ba0 <ayatsuri_model_open+0x40>
    2634:	f3 0f 10 4d 1c       	movss  0x1c(%rbp),%xmm1
    2639:	66 0f ef f6          	pxor   %xmm6,%xmm6
    263d:	0f 2e ce             	ucomiss %xmm6,%xmm1
    2640:	7a 06                	jp     2648 <ayatsuri_model_open+0xae8>
    2642:	0f 84 58 f5 ff ff    	je     1ba0 <ayatsuri_model_open+0x40>
    2648:	f3 0f 10 4d 20       	movss  0x20(%rbp),%xmm1
    264d:	66 0f ef f6          	pxor   %xmm6,%xmm6
    2651:	0f 2e ce             	ucomiss %xmm6,%xmm1
    2654:	7a 06                	jp     265c <ayatsuri_model_open+0xafc>
    2656:	0f 84 44 f5 ff ff    	je     1ba0 <ayatsuri_model_open+0x40>
    265c:	84 c0                	test   %al,%al
    265e:	0f 85 3e 01 00 00    	jne    27a2 <ayatsuri_model_open+0xc42>
    2664:	66 0f ef ff          	pxor   %xmm7,%xmm7
    2668:	b9 01 00 00 00       	mov    $0x1,%ecx
    266d:	0f 2e c7             	ucomiss %xmm7,%xmm0
    2670:	41 0f 9a c1          	setp   %r9b
    2674:	44 0f 45 c9          	cmovne %ecx,%r9d
    2678:	66 85 ff             	test   %di,%di
    267b:	40 0f 95 c7          	setne  %dil
    267f:	44 08 cf             	or     %r9b,%dil
    2682:	0f 85 18 f5 ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    2688:	21 f2                	and    %esi,%edx
    268a:	66 83 c2 01          	add    $0x1,%dx
    268e:	0f 85 0c f5 ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    2694:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    2699:	42 8d 14 c5 00 00 00 	lea    0x0(,%r8,8),%edx
    26a0:	00 
    26a1:	48 01 ca             	add    %rcx,%rdx
    26a4:	4c 01 e2             	add    %r12,%rdx
    26a7:	44 0f b7 42 02       	movzwl 0x2(%rdx),%r8d
    26ac:	8b 7a 04             	mov    0x4(%rdx),%edi
    26af:	0f b7 12             	movzwl (%rdx),%edx
    26b2:	39 da                	cmp    %ebx,%edx
    26b4:	0f 85 e6 f4 ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    26ba:	41 8d 50 ff          	lea    -0x1(%r8),%edx
    26be:	66 83 fa 7e          	cmp    $0x7e,%dx
    26c2:	40 0f 97 c6          	seta   %sil
    26c6:	41 39 fe             	cmp    %edi,%r14d
    26c9:	0f 92 c2             	setb   %dl
    26cc:	40 08 d6             	or     %dl,%sil
    26cf:	40 88 74 24 28       	mov    %sil,0x28(%rsp)
    26d4:	0f 85 c6 f4 ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    26da:	44 89 f6             	mov    %r14d,%esi
    26dd:	41 0f b7 d0          	movzwl %r8w,%edx
    26e1:	29 fe                	sub    %edi,%esi
    26e3:	39 d6                	cmp    %edx,%esi
    26e5:	0f 82 b5 f4 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    26eb:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
    26f0:	31 f6                	xor    %esi,%esi
    26f2:	48 01 cf             	add    %rcx,%rdi
    26f5:	4c 01 e7             	add    %r12,%rdi
    26f8:	39 d6                	cmp    %edx,%esi
    26fa:	73 58                	jae    2754 <ayatsuri_model_open+0xbf4>
    26fc:	0f b6 0c 37          	movzbl (%rdi,%rsi,1),%ecx
    2700:	48 83 c6 01          	add    $0x1,%rsi
    2704:	83 e9 20             	sub    $0x20,%ecx
    2707:	80 f9 5e             	cmp    $0x5e,%cl
    270a:	76 ec                	jbe    26f8 <ayatsuri_model_open+0xb98>
    270c:	e9 8f f4 ff ff       	jmp    1ba0 <ayatsuri_model_open+0x40>
    2711:	f3 0f 10 25 00 00 00 	movss  0x0(%rip),%xmm4        # 2719 <ayatsuri_model_open+0xbb9>
    2718:	00 
			2715: R_X86_64_PC32	.LC1-0x4
    2719:	0f 28 d8             	movaps %xmm0,%xmm3
    271c:	0f 54 1d 00 00 00 00 	andps  0x0(%rip),%xmm3        # 2723 <ayatsuri_model_open+0xbc3>
			271f: R_X86_64_PC32	.LC0-0x4
    2723:	0f 2e e3             	ucomiss %xmm3,%xmm4
    2726:	0f 82 74 f4 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    272c:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 2734 <ayatsuri_model_open+0xbd4>
    2733:	00 
			2730: R_X86_64_PC32	.LC17-0x4
    2734:	0f 2f d8             	comiss %xmm0,%xmm3
    2737:	0f 87 63 f4 ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    273d:	0f 2f 05 00 00 00 00 	comiss 0x0(%rip),%xmm0        # 2744 <ayatsuri_model_open+0xbe4>
			2740: R_X86_64_PC32	.LC30-0x4
    2744:	0f 87 56 f4 ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    274a:	be 04 00 00 00       	mov    $0x4,%esi
    274f:	e9 f1 fc ff ff       	jmp    2445 <ayatsuri_model_open+0x8e5>
    2754:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
    2759:	44 89 6c 24 64       	mov    %r13d,0x64(%rsp)
    275e:	41 0f b7 d0          	movzwl %r8w,%edx
    2762:	41 89 c5             	mov    %eax,%r13d
    2765:	89 9c 24 80 00 00 00 	mov    %ebx,0x80(%rsp)
    276c:	48 89 6c 24 68       	mov    %rbp,0x68(%rsp)
    2771:	4c 89 cb             	mov    %r9,%rbx
    2774:	44 89 c5             	mov    %r8d,%ebp
    2777:	49 39 df             	cmp    %rbx,%r15
    277a:	0f 84 cc 01 00 00    	je     294c <ayatsuri_model_open+0xdec>
    2780:	0f b7 43 0a          	movzwl 0xa(%rbx),%eax
    2784:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    2789:	c1 e0 03             	shl    $0x3,%eax
    278c:	48 01 c8             	add    %rcx,%rax
    278f:	4c 01 e0             	add    %r12,%rax
    2792:	66 39 68 02          	cmp    %bp,0x2(%rax)
    2796:	0f 84 5c 01 00 00    	je     28f8 <ayatsuri_model_open+0xd98>
    279c:	48 83 c3 10          	add    $0x10,%rbx
    27a0:	eb d5                	jmp    2777 <ayatsuri_model_open+0xc17>
    27a2:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
    27a6:	39 ca                	cmp    %ecx,%edx
    27a8:	0f 83 f2 f3 ff ff    	jae    1ba0 <ayatsuri_model_open+0x40>
    27ae:	3c 03                	cmp    $0x3,%al
    27b0:	74 6c                	je     281e <ayatsuri_model_open+0xcbe>
    27b2:	83 7c 24 40 00       	cmpl   $0x0,0x40(%rsp)
    27b7:	74 12                	je     27cb <ayatsuri_model_open+0xc6b>
    27b9:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
    27be:	c1 e2 02             	shl    $0x2,%edx
    27c1:	80 3c 11 00          	cmpb   $0x0,(%rcx,%rdx,1)
    27c5:	0f 85 d5 f3 ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    27cb:	3c 01                	cmp    $0x1,%al
    27cd:	0f 84 f7 00 00 00    	je     28ca <ayatsuri_model_open+0xd6a>
    27d3:	8d 57 ff             	lea    -0x1(%rdi),%edx
    27d6:	66 83 fa 07          	cmp    $0x7,%dx
    27da:	0f 87 c0 f3 ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    27e0:	8b 4c 24 10          	mov    0x10(%rsp),%ecx
    27e4:	39 f1                	cmp    %esi,%ecx
    27e6:	0f 82 b4 f3 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    27ec:	29 f1                	sub    %esi,%ecx
    27ee:	39 f9                	cmp    %edi,%ecx
    27f0:	0f 82 aa f3 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    27f6:	66 0f ef ff          	pxor   %xmm7,%xmm7
    27fa:	0f 2f f8             	comiss %xmm0,%xmm7
    27fd:	0f 87 9d f3 ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    2803:	0f 2f 05 00 00 00 00 	comiss 0x0(%rip),%xmm0        # 280a <ayatsuri_model_open+0xcaa>
			2806: R_X86_64_PC32	.LC30-0x4
    280a:	0f 87 90 f3 ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    2810:	66 83 84 24 9e 00 00 	addw   $0x1,0x9e(%rsp)
    2817:	00 01 
    2819:	e9 76 fe ff ff       	jmp    2694 <ayatsuri_model_open+0xb34>
    281e:	83 7c 24 38 00       	cmpl   $0x0,0x38(%rsp)
    2823:	0f 84 77 f3 ff ff    	je     1ba0 <ayatsuri_model_open+0x40>
    2829:	8b 4c 24 3c          	mov    0x3c(%rsp),%ecx
    282d:	39 ce                	cmp    %ecx,%esi
    282f:	40 0f 93 c6          	setae  %sil
    2833:	66 85 ff             	test   %di,%di
    2836:	40 0f 95 c7          	setne  %dil
    283a:	40 08 fe             	or     %dil,%sil
    283d:	0f 85 5d f3 ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    2843:	66 0f ef f6          	pxor   %xmm6,%xmm6
    2847:	b9 01 00 00 00       	mov    $0x1,%ecx
    284c:	0f 2e c6             	ucomiss %xmm6,%xmm0
    284f:	40 0f 9a c6          	setp   %sil
    2853:	0f 45 f1             	cmovne %ecx,%esi
    2856:	40 84 f6             	test   %sil,%sil
    2859:	0f 85 41 f3 ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    285f:	6b d2 48             	imul   $0x48,%edx,%edx
    2862:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
    2867:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
    286b:	4c 01 e6             	add    %r12,%rsi
    286e:	48 8d 7e 30          	lea    0x30(%rsi),%rdi
    2872:	e8 89 d7 ff ff       	call   0 <md>
    2877:	66 0f 2e 05 00 00 00 	ucomisd 0x0(%rip),%xmm0        # 287f <ayatsuri_model_open+0xd1f>
    287e:	00 
			287b: R_X86_64_PC32	.LC9-0x4
    287f:	0f 8a 1b f3 ff ff    	jp     1ba0 <ayatsuri_model_open+0x40>
    2885:	0f 85 15 f3 ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    288b:	48 8d 7e 38          	lea    0x38(%rsi),%rdi
    288f:	e8 6c d7 ff ff       	call   0 <md>
    2894:	66 0f 2e 05 00 00 00 	ucomisd 0x0(%rip),%xmm0        # 289c <ayatsuri_model_open+0xd3c>
    289b:	00 
			2898: R_X86_64_PC32	.LC9-0x4
    289c:	0f 8a fe f2 ff ff    	jp     1ba0 <ayatsuri_model_open+0x40>
    28a2:	0f 85 f8 f2 ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    28a8:	48 8d 7e 40          	lea    0x40(%rsi),%rdi
    28ac:	66 0f ef ff          	pxor   %xmm7,%xmm7
    28b0:	e8 4b d7 ff ff       	call   0 <md>
    28b5:	66 0f 2e c7          	ucomisd %xmm7,%xmm0
    28b9:	0f 8a e1 f2 ff ff    	jp     1ba0 <ayatsuri_model_open+0x40>
    28bf:	0f 84 4b ff ff ff    	je     2810 <ayatsuri_model_open+0xcb0>
    28c5:	e9 d6 f2 ff ff       	jmp    1ba0 <ayatsuri_model_open+0x40>
    28ca:	66 0f ef f6          	pxor   %xmm6,%xmm6
    28ce:	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
    28d2:	0f 2e c6             	ucomiss %xmm6,%xmm0
    28d5:	0f 9a c2             	setp   %dl
    28d8:	0f 45 d0             	cmovne %eax,%edx
    28db:	39 ce                	cmp    %ecx,%esi
    28dd:	40 0f 93 c6          	setae  %sil
    28e1:	40 08 d6             	or     %dl,%sil
    28e4:	0f 85 b6 f2 ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    28ea:	66 85 ff             	test   %di,%di
    28ed:	0f 84 1d ff ff ff    	je     2810 <ayatsuri_model_open+0xcb0>
    28f3:	e9 a8 f2 ff ff       	jmp    1ba0 <ayatsuri_model_open+0x40>
    28f8:	8b 70 04             	mov    0x4(%rax),%esi
    28fb:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    2900:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
    2905:	4c 89 9c 24 88 00 00 	mov    %r11,0x88(%rsp)
    290c:	00 
    290d:	48 01 c6             	add    %rax,%rsi
    2910:	44 89 94 24 84 00 00 	mov    %r10d,0x84(%rsp)
    2917:	00 
    2918:	4c 01 e6             	add    %r12,%rsi
    291b:	48 89 7c 24 70       	mov    %rdi,0x70(%rsp)
    2920:	e8 00 00 00 00       	call   2925 <ayatsuri_model_open+0xdc5>
			2921: R_X86_64_PLT32	memcmp-0x4
    2925:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
    292a:	48 8b 54 24 78       	mov    0x78(%rsp),%rdx
    292f:	85 c0                	test   %eax,%eax
    2931:	44 8b 94 24 84 00 00 	mov    0x84(%rsp),%r10d
    2938:	00 
    2939:	4c 8b 9c 24 88 00 00 	mov    0x88(%rsp),%r11
    2940:	00 
    2941:	0f 85 55 fe ff ff    	jne    279c <ayatsuri_model_open+0xc3c>
    2947:	e9 54 f2 ff ff       	jmp    1ba0 <ayatsuri_model_open+0x40>
    294c:	44 89 e8             	mov    %r13d,%eax
    294f:	8b 9c 24 80 00 00 00 	mov    0x80(%rsp),%ebx
    2956:	44 8b 6c 24 64       	mov    0x64(%rsp),%r13d
    295b:	48 8b 6c 24 68       	mov    0x68(%rsp),%rbp
    2960:	3c 03                	cmp    $0x3,%al
    2962:	0f 84 17 02 00 00    	je     2b7f <ayatsuri_model_open+0x101f>
    2968:	4c 89 ff             	mov    %r15,%rdi
    296b:	e8 60 d9 ff ff       	call   2d0 <slot_bytes>
    2970:	03 84 24 a0 00 00 00 	add    0xa0(%rsp),%eax
    2977:	83 c3 01             	add    $0x1,%ebx
    297a:	49 83 c7 10          	add    $0x10,%r15
    297e:	48 83 c5 24          	add    $0x24,%rbp
    2982:	89 84 24 a0 00 00 00 	mov    %eax,0xa0(%rsp)
    2989:	89 c2                	mov    %eax,%edx
    298b:	44 39 eb             	cmp    %r13d,%ebx
    298e:	0f 82 12 fc ff ff    	jb     25a6 <ayatsuri_model_open+0xa46>
    2994:	44 8b 8c 24 dc 00 00 	mov    0xdc(%rsp),%r9d
    299b:	00 
    299c:	4c 89 e3             	mov    %r12,%rbx
    299f:	4c 89 dd             	mov    %r11,%rbp
    29a2:	31 f6                	xor    %esi,%esi
    29a4:	0f b6 44 24 63       	movzbl 0x63(%rsp),%eax
    29a9:	44 8b b4 24 e0 00 00 	mov    0xe0(%rsp),%r14d
    29b0:	00 
    29b1:	45 89 d4             	mov    %r10d,%r12d
    29b4:	f3 44 0f 10 0d 00 00 	movss  0x0(%rip),%xmm9        # 29bd <ayatsuri_model_open+0xe5d>
    29bb:	00 00 
			29b9: R_X86_64_PC32	.LC15-0x4
    29bd:	f3 0f 7e 1d 00 00 00 	movq   0x0(%rip),%xmm3        # 29c5 <ayatsuri_model_open+0xe65>
    29c4:	00 
			29c1: R_X86_64_PC32	.LC8-0x4
    29c5:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 29cd <ayatsuri_model_open+0xe6d>
    29cc:	00 
			29c9: R_X86_64_PC32	.LC22-0x4
    29cd:	4e 8d 1c 0b          	lea    (%rbx,%r9,1),%r11
    29d1:	f3 44 0f 10 05 00 00 	movss  0x0(%rip),%xmm8        # 29da <ayatsuri_model_open+0xe7a>
    29d8:	00 00 
			29d6: R_X86_64_PC32	.LC31-0x4
    29da:	41 39 f6             	cmp    %esi,%r14d
    29dd:	0f 84 b0 01 00 00    	je     2b93 <ayatsuri_model_open+0x1033>
    29e3:	66 0f ef c0          	pxor   %xmm0,%xmm0
    29e7:	66 0f ef c9          	pxor   %xmm1,%xmm1
    29eb:	66 0f ef d2          	pxor   %xmm2,%xmm2
    29ef:	89 f1                	mov    %esi,%ecx
    29f1:	c1 e1 05             	shl    $0x5,%ecx
    29f4:	4c 01 c9             	add    %r9,%rcx
    29f7:	48 01 d9             	add    %rbx,%rcx
    29fa:	0f b7 39             	movzwl (%rcx),%edi
    29fd:	f3 0f 10 79 10       	movss  0x10(%rcx),%xmm7
    2a02:	f3 0f 5a 41 04       	cvtss2sd 0x4(%rcx),%xmm0
    2a07:	f3 0f 5a 49 08       	cvtss2sd 0x8(%rcx),%xmm1
    2a0c:	f3 0f 10 61 14       	movss  0x14(%rcx),%xmm4
    2a11:	f3 0f 5a 51 0c       	cvtss2sd 0xc(%rcx),%xmm2
    2a16:	41 89 fa             	mov    %edi,%r10d
    2a19:	44 39 ef             	cmp    %r13d,%edi
    2a1c:	0f 83 7e f1 ff ff    	jae    1ba0 <ayatsuri_model_open+0x40>
    2a22:	4c 8b 7c 24 30       	mov    0x30(%rsp),%r15
    2a27:	44 0f b6 41 02       	movzbl 0x2(%rcx),%r8d
    2a2c:	c1 e7 04             	shl    $0x4,%edi
    2a2f:	42 0f b6 7c 3f 02    	movzbl 0x2(%rdi,%r15,1),%edi
    2a35:	41 80 f8 05          	cmp    $0x5,%r8b
    2a39:	0f 84 29 01 00 00    	je     2b68 <ayatsuri_model_open+0x1008>
    2a3f:	40 80 ef 01          	sub    $0x1,%dil
    2a43:	0f 85 57 f1 ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    2a49:	41 80 f8 04          	cmp    $0x4,%r8b
    2a4d:	0f 85 4d f1 ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    2a53:	f3 0f 10 2d 00 00 00 	movss  0x0(%rip),%xmm5        # 2a5b <ayatsuri_model_open+0xefb>
    2a5a:	00 
			2a57: R_X86_64_PC32	.LC28-0x4
    2a5b:	80 79 03 00          	cmpb   $0x0,0x3(%rcx)
    2a5f:	0f 85 3b f1 ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    2a65:	8b 79 1c             	mov    0x1c(%rcx),%edi
    2a68:	85 ff                	test   %edi,%edi
    2a6a:	0f 85 30 f1 ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    2a70:	66 44 0f 28 d0       	movapd %xmm0,%xmm10
    2a75:	66 44 0f 54 d3       	andpd  %xmm3,%xmm10
    2a7a:	66 41 0f 2e f2       	ucomisd %xmm10,%xmm6
    2a7f:	0f 82 1b f1 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    2a85:	66 44 0f 28 d1       	movapd %xmm1,%xmm10
    2a8a:	66 44 0f 54 d3       	andpd  %xmm3,%xmm10
    2a8f:	66 41 0f 2e f2       	ucomisd %xmm10,%xmm6
    2a94:	0f 82 06 f1 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    2a9a:	66 44 0f 28 d2       	movapd %xmm2,%xmm10
    2a9f:	66 44 0f 54 d3       	andpd  %xmm3,%xmm10
    2aa4:	66 41 0f 2e f2       	ucomisd %xmm10,%xmm6
    2aa9:	0f 82 f1 f0 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    2aaf:	f2 0f 59 c0          	mulsd  %xmm0,%xmm0
    2ab3:	f2 0f 59 c9          	mulsd  %xmm1,%xmm1
    2ab7:	f2 0f 59 d2          	mulsd  %xmm2,%xmm2
    2abb:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    2abf:	f2 0f 58 c2          	addsd  %xmm2,%xmm0
    2ac3:	f2 0f 5c 05 00 00 00 	subsd  0x0(%rip),%xmm0        # 2acb <ayatsuri_model_open+0xf6b>
    2aca:	00 
			2ac7: R_X86_64_PC32	.LC9-0x4
    2acb:	66 0f 54 c3          	andpd  %xmm3,%xmm0
    2acf:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 2ad7 <ayatsuri_model_open+0xf77>
    2ad6:	00 
			2ad3: R_X86_64_PC32	.LC29-0x4
    2ad7:	0f 87 c3 f0 ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    2add:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 2ae5 <ayatsuri_model_open+0xf85>
    2ae4:	00 
			2ae1: R_X86_64_PC32	.LC1-0x4
    2ae5:	0f 28 c7             	movaps %xmm7,%xmm0
    2ae8:	0f 54 05 00 00 00 00 	andps  0x0(%rip),%xmm0        # 2aef <ayatsuri_model_open+0xf8f>
			2aeb: R_X86_64_PC32	.LC0-0x4
    2aef:	0f 2e d0             	ucomiss %xmm0,%xmm2
    2af2:	0f 82 a8 f0 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    2af8:	0f 28 c5             	movaps %xmm5,%xmm0
    2afb:	41 0f 57 c1          	xorps  %xmm9,%xmm0
    2aff:	0f 2f c7             	comiss %xmm7,%xmm0
    2b02:	0f 87 98 f0 ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    2b08:	0f 2f fd             	comiss %xmm5,%xmm7
    2b0b:	0f 87 8f f0 ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    2b11:	0f 28 c4             	movaps %xmm4,%xmm0
    2b14:	0f 54 05 00 00 00 00 	andps  0x0(%rip),%xmm0        # 2b1b <ayatsuri_model_open+0xfbb>
			2b17: R_X86_64_PC32	.LC0-0x4
    2b1b:	0f 2e d0             	ucomiss %xmm0,%xmm2
    2b1e:	0f 82 7c f0 ff ff    	jb     1ba0 <ayatsuri_model_open+0x40>
    2b24:	66 0f ef c0          	pxor   %xmm0,%xmm0
    2b28:	0f 2e e0             	ucomiss %xmm0,%xmm4
    2b2b:	7a 02                	jp     2b2f <ayatsuri_model_open+0xfcf>
    2b2d:	74 13                	je     2b42 <ayatsuri_model_open+0xfe2>
    2b2f:	44 0f 2f c4          	comiss %xmm4,%xmm8
    2b33:	0f 87 67 f0 ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    2b39:	0f 2f e5             	comiss %xmm5,%xmm4
    2b3c:	0f 87 5e f0 ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    2b42:	81 79 18 ff ff ff 00 	cmpl   $0xffffff,0x18(%rcx)
    2b49:	0f 87 51 f0 ff ff    	ja     1ba0 <ayatsuri_model_open+0x40>
    2b4f:	39 fe                	cmp    %edi,%esi
    2b51:	74 65                	je     2bb8 <ayatsuri_model_open+0x1058>
    2b53:	89 f9                	mov    %edi,%ecx
    2b55:	c1 e1 05             	shl    $0x5,%ecx
    2b58:	66 45 39 14 0b       	cmp    %r10w,(%r11,%rcx,1)
    2b5d:	0f 84 3d f0 ff ff    	je     1ba0 <ayatsuri_model_open+0x40>
    2b63:	83 c7 01             	add    $0x1,%edi
    2b66:	eb e7                	jmp    2b4f <ayatsuri_model_open+0xfef>
    2b68:	40 80 ff 02          	cmp    $0x2,%dil
    2b6c:	0f 85 2e f0 ff ff    	jne    1ba0 <ayatsuri_model_open+0x40>
    2b72:	f3 0f 10 2d 00 00 00 	movss  0x0(%rip),%xmm5        # 2b7a <ayatsuri_model_open+0x101a>
    2b79:	00 
			2b76: R_X86_64_PC32	.LC3-0x4
    2b7a:	e9 dc fe ff ff       	jmp    2a5b <ayatsuri_model_open+0xefb>
    2b7f:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
    2b84:	4c 89 fa             	mov    %r15,%rdx
    2b87:	89 de                	mov    %ebx,%esi
    2b89:	e8 92 db ff ff       	call   720 <node_slot_bytes>
    2b8e:	e9 dd fd ff ff       	jmp    2970 <ayatsuri_model_open+0xe10>
    2b93:	80 7c 24 28 00       	cmpb   $0x0,0x28(%rsp)
    2b98:	74 07                	je     2ba1 <ayatsuri_model_open+0x1041>
    2b9a:	89 94 24 a0 00 00 00 	mov    %edx,0xa0(%rsp)
    2ba1:	48 8d b4 24 90 00 00 	lea    0x90(%rsp),%rsi
    2ba8:	00 
    2ba9:	b9 20 00 00 00       	mov    $0x20,%ecx
    2bae:	48 89 ef             	mov    %rbp,%rdi
    2bb1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
    2bb3:	e9 ee ef ff ff       	jmp    1ba6 <ayatsuri_model_open+0x46>
    2bb8:	41 80 f8 05          	cmp    $0x5,%r8b
    2bbc:	75 07                	jne    2bc5 <ayatsuri_model_open+0x1065>
    2bbe:	88 44 24 28          	mov    %al,0x28(%rsp)
    2bc2:	83 c2 18             	add    $0x18,%edx
    2bc5:	83 c6 01             	add    $0x1,%esi
    2bc8:	e9 0d fe ff ff       	jmp    29da <ayatsuri_model_open+0xe7a>
    2bcd:	0f 1f 00             	nopl   (%rax)

0000000000002bd0 <ayatsuri_model_find_node>:
    2bd0:	48 85 ff             	test   %rdi,%rdi
    2bd3:	0f 84 1f 01 00 00    	je     2cf8 <ayatsuri_model_find_node+0x128>
    2bd9:	41 57                	push   %r15
    2bdb:	41 56                	push   %r14
    2bdd:	41 55                	push   %r13
    2bdf:	41 54                	push   %r12
    2be1:	55                   	push   %rbp
    2be2:	48 89 fd             	mov    %rdi,%rbp
    2be5:	53                   	push   %rbx
    2be6:	48 83 ec 18          	sub    $0x18,%rsp
    2bea:	4c 8b 3f             	mov    (%rdi),%r15
    2bed:	4d 85 ff             	test   %r15,%r15
    2bf0:	0f 84 d2 00 00 00    	je     2cc8 <ayatsuri_model_find_node+0xf8>
    2bf6:	49 89 f6             	mov    %rsi,%r14
    2bf9:	48 85 f6             	test   %rsi,%rsi
    2bfc:	0f 84 c6 00 00 00    	je     2cc8 <ayatsuri_model_find_node+0xf8>
    2c02:	49 89 cd             	mov    %rcx,%r13
    2c05:	48 85 c9             	test   %rcx,%rcx
    2c08:	0f 84 ba 00 00 00    	je     2cc8 <ayatsuri_model_find_node+0xf8>
    2c0e:	49 89 d4             	mov    %rdx,%r12
    2c11:	48 8d 52 ff          	lea    -0x1(%rdx),%rdx
    2c15:	b8 01 00 00 00       	mov    $0x1,%eax
    2c1a:	48 83 fa 7e          	cmp    $0x7e,%rdx
    2c1e:	0f 87 a9 00 00 00    	ja     2ccd <ayatsuri_model_find_node+0xfd>
    2c24:	48 39 cf             	cmp    %rcx,%rdi
    2c27:	0f 83 b3 00 00 00    	jae    2ce0 <ayatsuri_model_find_node+0x110>
    2c2d:	48 89 ca             	mov    %rcx,%rdx
    2c30:	48 29 fa             	sub    %rdi,%rdx
    2c33:	48 83 fa 7f          	cmp    $0x7f,%rdx
    2c37:	0f 86 90 00 00 00    	jbe    2ccd <ayatsuri_model_find_node+0xfd>
    2c3d:	8b 55 08             	mov    0x8(%rbp),%edx
    2c40:	48 85 d2             	test   %rdx,%rdx
    2c43:	74 1b                	je     2c60 <ayatsuri_model_find_node+0x90>
    2c45:	4d 39 ef             	cmp    %r13,%r15
    2c48:	0f 82 c2 00 00 00    	jb     2d10 <ayatsuri_model_find_node+0x140>
    2c4e:	4c 89 fa             	mov    %r15,%rdx
    2c51:	b8 01 00 00 00       	mov    $0x1,%eax
    2c56:	4c 29 ea             	sub    %r13,%rdx
    2c59:	48 83 fa 01          	cmp    $0x1,%rdx
    2c5d:	76 6e                	jbe    2ccd <ayatsuri_model_find_node+0xfd>
    2c5f:	90                   	nop
    2c60:	0f b7 45 0c          	movzwl 0xc(%rbp),%eax
    2c64:	85 c0                	test   %eax,%eax
    2c66:	0f 84 94 00 00 00    	je     2d00 <ayatsuri_model_find_node+0x130>
    2c6c:	8b 5d 3c             	mov    0x3c(%rbp),%ebx
    2c6f:	83 e8 01             	sub    $0x1,%eax
    2c72:	4c 01 fb             	add    %r15,%rbx
    2c75:	48 8d 4c c3 08       	lea    0x8(%rbx,%rax,8),%rcx
    2c7a:	eb 0d                	jmp    2c89 <ayatsuri_model_find_node+0xb9>
    2c7c:	0f 1f 40 00          	nopl   0x0(%rax)
    2c80:	48 83 c3 08          	add    $0x8,%rbx
    2c84:	48 39 d9             	cmp    %rbx,%rcx
    2c87:	74 77                	je     2d00 <ayatsuri_model_find_node+0x130>
    2c89:	0f b7 43 02          	movzwl 0x2(%rbx),%eax
    2c8d:	4c 39 e0             	cmp    %r12,%rax
    2c90:	75 ee                	jne    2c80 <ayatsuri_model_find_node+0xb0>
    2c92:	8b 43 04             	mov    0x4(%rbx),%eax
    2c95:	8b 7d 44             	mov    0x44(%rbp),%edi
    2c98:	4c 89 e2             	mov    %r12,%rdx
    2c9b:	4c 89 f6             	mov    %r14,%rsi
    2c9e:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    2ca3:	48 01 c7             	add    %rax,%rdi
    2ca6:	4c 01 ff             	add    %r15,%rdi
    2ca9:	e8 00 00 00 00       	call   2cae <ayatsuri_model_find_node+0xde>
			2caa: R_X86_64_PLT32	memcmp-0x4
    2cae:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
    2cb3:	85 c0                	test   %eax,%eax
    2cb5:	75 c9                	jne    2c80 <ayatsuri_model_find_node+0xb0>
    2cb7:	0f b7 03             	movzwl (%rbx),%eax
    2cba:	66 41 89 45 00       	mov    %ax,0x0(%r13)
    2cbf:	31 c0                	xor    %eax,%eax
    2cc1:	eb 0a                	jmp    2ccd <ayatsuri_model_find_node+0xfd>
    2cc3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    2cc8:	b8 01 00 00 00       	mov    $0x1,%eax
    2ccd:	48 83 c4 18          	add    $0x18,%rsp
    2cd1:	5b                   	pop    %rbx
    2cd2:	5d                   	pop    %rbp
    2cd3:	41 5c                	pop    %r12
    2cd5:	41 5d                	pop    %r13
    2cd7:	41 5e                	pop    %r14
    2cd9:	41 5f                	pop    %r15
    2cdb:	c3                   	ret
    2cdc:	0f 1f 40 00          	nopl   0x0(%rax)
    2ce0:	48 89 fa             	mov    %rdi,%rdx
    2ce3:	48 29 ca             	sub    %rcx,%rdx
    2ce6:	48 83 fa 01          	cmp    $0x1,%rdx
    2cea:	76 e1                	jbe    2ccd <ayatsuri_model_find_node+0xfd>
    2cec:	e9 4c ff ff ff       	jmp    2c3d <ayatsuri_model_find_node+0x6d>
    2cf1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    2cf8:	b8 01 00 00 00       	mov    $0x1,%eax
    2cfd:	c3                   	ret
    2cfe:	66 90                	xchg   %ax,%ax
    2d00:	b8 05 00 00 00       	mov    $0x5,%eax
    2d05:	eb c6                	jmp    2ccd <ayatsuri_model_find_node+0xfd>
    2d07:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    2d0e:	00 00 
    2d10:	4c 89 e9             	mov    %r13,%rcx
    2d13:	b8 01 00 00 00       	mov    $0x1,%eax
    2d18:	4c 29 f9             	sub    %r15,%rcx
    2d1b:	48 39 d1             	cmp    %rdx,%rcx
    2d1e:	72 ad                	jb     2ccd <ayatsuri_model_find_node+0xfd>
    2d20:	e9 3b ff ff ff       	jmp    2c60 <ayatsuri_model_find_node+0x90>
    2d25:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    2d2c:	00 00 00 00 

0000000000002d30 <ayatsuri_model_instance_bytes>:
    2d30:	31 c0                	xor    %eax,%eax
    2d32:	48 85 ff             	test   %rdi,%rdi
    2d35:	74 15                	je     2d4c <ayatsuri_model_instance_bytes+0x1c>
    2d37:	48 83 3f 00          	cmpq   $0x0,(%rdi)
    2d3b:	74 0f                	je     2d4c <ayatsuri_model_instance_bytes+0x1c>
    2d3d:	0f b7 47 0c          	movzwl 0xc(%rdi),%eax
    2d41:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
    2d45:	8b 47 10             	mov    0x10(%rdi),%eax
    2d48:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
    2d4c:	c3                   	ret
    2d4d:	0f 1f 00             	nopl   (%rax)

0000000000002d50 <ayatsuri_model_instance_init>:
    2d50:	b8 01 00 00 00       	mov    $0x1,%eax
    2d55:	48 85 ff             	test   %rdi,%rdi
    2d58:	0f 84 a2 00 00 00    	je     2e00 <ayatsuri_model_instance_init+0xb0>
    2d5e:	41 57                	push   %r15
    2d60:	41 56                	push   %r14
    2d62:	41 55                	push   %r13
    2d64:	41 54                	push   %r12
    2d66:	55                   	push   %rbp
    2d67:	48 89 cd             	mov    %rcx,%rbp
    2d6a:	53                   	push   %rbx
    2d6b:	48 89 fb             	mov    %rdi,%rbx
    2d6e:	48 81 ec c8 00 00 00 	sub    $0xc8,%rsp
    2d75:	48 8b 0f             	mov    (%rdi),%rcx
    2d78:	48 85 c9             	test   %rcx,%rcx
    2d7b:	74 5e                	je     2ddb <ayatsuri_model_instance_init+0x8b>
    2d7d:	0f b7 47 0c          	movzwl 0xc(%rdi),%eax
    2d81:	49 89 f2             	mov    %rsi,%r10
    2d84:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
    2d88:	8b 47 10             	mov    0x10(%rdi),%eax
    2d8b:	4c 8d 24 f0          	lea    (%rax,%rsi,8),%r12
    2d8f:	4d 85 e4             	test   %r12,%r12
    2d92:	74 5c                	je     2df0 <ayatsuri_model_instance_init+0xa0>
    2d94:	4d 85 d2             	test   %r10,%r10
    2d97:	74 57                	je     2df0 <ayatsuri_model_instance_init+0xa0>
    2d99:	48 85 ed             	test   %rbp,%rbp
    2d9c:	0f 94 c0             	sete   %al
    2d9f:	4d 85 c9             	test   %r9,%r9
    2da2:	40 0f 94 c6          	sete   %sil
    2da6:	40 08 f0             	or     %sil,%al
    2da9:	75 45                	jne    2df0 <ayatsuri_model_instance_init+0xa0>
    2dab:	45 85 c0             	test   %r8d,%r8d
    2dae:	74 40                	je     2df0 <ayatsuri_model_instance_init+0xa0>
    2db0:	4d 89 d5             	mov    %r10,%r13
    2db3:	41 f6 c2 07          	test   $0x7,%r10b
    2db7:	75 37                	jne    2df0 <ayatsuri_model_instance_init+0xa0>
    2db9:	4c 39 e2             	cmp    %r12,%rdx
    2dbc:	72 32                	jb     2df0 <ayatsuri_model_instance_init+0xa0>
    2dbe:	8b 57 08             	mov    0x8(%rdi),%edx
    2dc1:	48 85 d2             	test   %rdx,%rdx
    2dc4:	74 5a                	je     2e20 <ayatsuri_model_instance_init+0xd0>
    2dc6:	4c 39 d1             	cmp    %r10,%rcx
    2dc9:	72 3d                	jb     2e08 <ayatsuri_model_instance_init+0xb8>
    2dcb:	48 89 ce             	mov    %rcx,%rsi
    2dce:	b8 01 00 00 00       	mov    $0x1,%eax
    2dd3:	4c 29 d6             	sub    %r10,%rsi
    2dd6:	4c 39 e6             	cmp    %r12,%rsi
    2dd9:	73 45                	jae    2e20 <ayatsuri_model_instance_init+0xd0>
    2ddb:	48 81 c4 c8 00 00 00 	add    $0xc8,%rsp
    2de2:	5b                   	pop    %rbx
    2de3:	5d                   	pop    %rbp
    2de4:	41 5c                	pop    %r12
    2de6:	41 5d                	pop    %r13
    2de8:	41 5e                	pop    %r14
    2dea:	41 5f                	pop    %r15
    2dec:	c3                   	ret
    2ded:	0f 1f 00             	nopl   (%rax)
    2df0:	b8 01 00 00 00       	mov    $0x1,%eax
    2df5:	eb e4                	jmp    2ddb <ayatsuri_model_instance_init+0x8b>
    2df7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    2dfe:	00 00 
    2e00:	c3                   	ret
    2e01:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    2e08:	4c 89 d6             	mov    %r10,%rsi
    2e0b:	b8 01 00 00 00       	mov    $0x1,%eax
    2e10:	48 29 ce             	sub    %rcx,%rsi
    2e13:	48 39 d6             	cmp    %rdx,%rsi
    2e16:	72 c3                	jb     2ddb <ayatsuri_model_instance_init+0x8b>
    2e18:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    2e1f:	00 
    2e20:	4c 39 d3             	cmp    %r10,%rbx
    2e23:	0f 83 27 02 00 00    	jae    3050 <ayatsuri_model_instance_init+0x300>
    2e29:	4c 89 d6             	mov    %r10,%rsi
    2e2c:	b8 01 00 00 00       	mov    $0x1,%eax
    2e31:	48 29 de             	sub    %rbx,%rsi
    2e34:	48 83 fe 7f          	cmp    $0x7f,%rsi
    2e38:	76 a1                	jbe    2ddb <ayatsuri_model_instance_init+0x8b>
    2e3a:	4d 39 d1             	cmp    %r10,%r9
    2e3d:	0f 82 2d 02 00 00    	jb     3070 <ayatsuri_model_instance_init+0x320>
    2e43:	4c 89 ce             	mov    %r9,%rsi
    2e46:	b8 01 00 00 00       	mov    $0x1,%eax
    2e4b:	4c 29 d6             	sub    %r10,%rsi
    2e4e:	4c 39 e6             	cmp    %r12,%rsi
    2e51:	72 88                	jb     2ddb <ayatsuri_model_instance_init+0x8b>
    2e53:	4c 39 cb             	cmp    %r9,%rbx
    2e56:	0f 82 34 02 00 00    	jb     3090 <ayatsuri_model_instance_init+0x340>
    2e5c:	48 89 de             	mov    %rbx,%rsi
    2e5f:	b8 01 00 00 00       	mov    $0x1,%eax
    2e64:	4c 29 ce             	sub    %r9,%rsi
    2e67:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    2e6e:	0f 86 67 ff ff ff    	jbe    2ddb <ayatsuri_model_instance_init+0x8b>
    2e74:	48 85 d2             	test   %rdx,%rdx
    2e77:	74 1e                	je     2e97 <ayatsuri_model_instance_init+0x147>
    2e79:	4c 39 c9             	cmp    %r9,%rcx
    2e7c:	0f 82 ed 02 00 00    	jb     316f <ayatsuri_model_instance_init+0x41f>
    2e82:	4c 29 c9             	sub    %r9,%rcx
    2e85:	b8 01 00 00 00       	mov    $0x1,%eax
    2e8a:	48 81 f9 a7 00 00 00 	cmp    $0xa7,%rcx
    2e91:	0f 86 44 ff ff ff    	jbe    2ddb <ayatsuri_model_instance_init+0x8b>
    2e97:	4c 89 d7             	mov    %r10,%rdi
    2e9a:	4c 89 e2             	mov    %r12,%rdx
    2e9d:	31 f6                	xor    %esi,%esi
    2e9f:	4c 89 4c 24 08       	mov    %r9,0x8(%rsp)
    2ea4:	44 89 44 24 04       	mov    %r8d,0x4(%rsp)
    2ea9:	e8 00 00 00 00       	call   2eae <ayatsuri_model_instance_init+0x15e>
			2eaa: R_X86_64_PLT32	memset-0x4
    2eae:	0f b7 53 0c          	movzwl 0xc(%rbx),%edx
    2eb2:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
    2eb7:	b9 15 00 00 00       	mov    $0x15,%ecx
    2ebc:	49 89 c2             	mov    %rax,%r10
    2ebf:	31 c0                	xor    %eax,%eax
    2ec1:	44 8b 44 24 04       	mov    0x4(%rsp),%r8d
    2ec6:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
    2ecb:	f3 48 ab             	rep stos %rax,%es:(%rdi)
    2ece:	89 d0                	mov    %edx,%eax
    2ed0:	8d 14 52             	lea    (%rdx,%rdx,2),%edx
    2ed3:	66 85 c0             	test   %ax,%ax
    2ed6:	44 8d 34 d5 00 00 00 	lea    0x0(,%rdx,8),%r14d
    2edd:	00 
    2ede:	0f 84 a4 02 00 00    	je     3188 <ayatsuri_model_instance_init+0x438>
    2ee4:	f3 0f 7e 0d 00 00 00 	movq   0x0(%rip),%xmm1        # 2eec <ayatsuri_model_instance_init+0x19c>
    2eeb:	00 
			2ee8: R_X86_64_PC32	.LC32-0x4
    2eec:	45 31 db             	xor    %r11d,%r11d
    2eef:	45 31 ff             	xor    %r15d,%r15d
    2ef2:	eb 3f                	jmp    2f33 <ayatsuri_model_instance_init+0x1e3>
    2ef4:	0f 1f 40 00          	nopl   0x0(%rax)
    2ef8:	b9 d3 ff ff ff       	mov    $0xffffffd3,%ecx
    2efd:	41 39 cf             	cmp    %ecx,%r15d
    2f00:	41 0f 46 cf          	cmovbe %r15d,%ecx
    2f04:	44 8d 79 2c          	lea    0x2c(%rcx),%r15d
    2f08:	8b 4a 0c             	mov    0xc(%rdx),%ecx
    2f0b:	89 8e 34 01 00 00    	mov    %ecx,0x134(%rsi)
    2f11:	89 c6                	mov    %eax,%esi
    2f13:	48 89 df             	mov    %rbx,%rdi
    2f16:	49 83 c3 01          	add    $0x1,%r11
    2f1a:	49 83 c5 18          	add    $0x18,%r13
    2f1e:	e8 fd d7 ff ff       	call   720 <node_slot_bytes>
    2f23:	41 01 c6             	add    %eax,%r14d
    2f26:	0f b7 43 0c          	movzwl 0xc(%rbx),%eax
    2f2a:	41 39 c3             	cmp    %eax,%r11d
    2f2d:	0f 83 77 01 00 00    	jae    30aa <ayatsuri_model_instance_init+0x35a>
    2f33:	8b 53 14             	mov    0x14(%rbx),%edx
    2f36:	4c 89 de             	mov    %r11,%rsi
    2f39:	48 8b 0b             	mov    (%rbx),%rcx
    2f3c:	45 89 75 08          	mov    %r14d,0x8(%r13)
    2f40:	48 c1 e6 04          	shl    $0x4,%rsi
    2f44:	4f 8d 04 db          	lea    (%r11,%r11,8),%r8
    2f48:	44 89 d8             	mov    %r11d,%eax
    2f4b:	48 01 f2             	add    %rsi,%rdx
    2f4e:	48 01 ca             	add    %rcx,%rdx
    2f51:	0f b6 72 03          	movzbl 0x3(%rdx),%esi
    2f55:	41 88 75 10          	mov    %sil,0x10(%r13)
    2f59:	8b 7b 1c             	mov    0x1c(%rbx),%edi
    2f5c:	44 89 f6             	mov    %r14d,%esi
    2f5f:	49 8d 74 32 30       	lea    0x30(%r10,%rsi,1),%rsi
    2f64:	4a 8d 3c 87          	lea    (%rdi,%r8,4),%rdi
    2f68:	48 01 f9             	add    %rdi,%rcx
    2f6b:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
    2f6f:	0f 11 06             	movups %xmm0,(%rsi)
    2f72:	f3 0f 6f 41 10       	movdqu 0x10(%rcx),%xmm0
    2f77:	0f 11 46 10          	movups %xmm0,0x10(%rsi)
    2f7b:	8b 49 20             	mov    0x20(%rcx),%ecx
    2f7e:	89 4e 20             	mov    %ecx,0x20(%rsi)
    2f81:	b9 db ff ff ff       	mov    $0xffffffdb,%ecx
    2f86:	41 39 cf             	cmp    %ecx,%r15d
    2f89:	41 0f 46 cf          	cmovbe %r15d,%ecx
    2f8d:	44 8d 79 24          	lea    0x24(%rcx),%r15d
    2f91:	0f b6 4a 02          	movzbl 0x2(%rdx),%ecx
    2f95:	84 c9                	test   %cl,%cl
    2f97:	0f 84 74 ff ff ff    	je     2f11 <ayatsuri_model_instance_init+0x1c1>
    2f9d:	80 f9 03             	cmp    $0x3,%cl
    2fa0:	0f 84 6b ff ff ff    	je     2f11 <ayatsuri_model_instance_init+0x1c1>
    2fa6:	0f b7 4a 08          	movzwl 0x8(%rdx),%ecx
    2faa:	41 b8 08 01 00 00    	mov    $0x108,%r8d
    2fb0:	8d 34 c9             	lea    (%rcx,%rcx,8),%esi
    2fb3:	8b 4b 34             	mov    0x34(%rbx),%ecx
    2fb6:	c1 e6 03             	shl    $0x3,%esi
    2fb9:	48 01 ce             	add    %rcx,%rsi
    2fbc:	48 03 33             	add    (%rbx),%rsi
    2fbf:	8b 4e 2c             	mov    0x2c(%rsi),%ecx
    2fc2:	48 8d 7e 38          	lea    0x38(%rsi),%rdi
    2fc6:	41 89 4d 0c          	mov    %ecx,0xc(%r13)
    2fca:	b9 2c 00 00 00       	mov    $0x2c,%ecx
    2fcf:	e8 2c d0 ff ff       	call   0 <md>
    2fd4:	41 8b 7d 08          	mov    0x8(%r13),%edi
    2fd8:	f2 41 0f 11 45 00    	movsd  %xmm0,0x0(%r13)
    2fde:	80 7a 02 01          	cmpb   $0x1,0x2(%rdx)
    2fe2:	75 0b                	jne    2fef <ayatsuri_model_instance_init+0x29f>
    2fe4:	b9 20 00 00 00       	mov    $0x20,%ecx
    2fe9:	41 b8 a4 00 00 00    	mov    $0xa4,%r8d
    2fef:	49 01 f8             	add    %rdi,%r8
    2ff2:	48 8b 3e             	mov    (%rsi),%rdi
    2ff5:	4d 01 d0             	add    %r10,%r8
    2ff8:	49 89 38             	mov    %rdi,(%r8)
    2ffb:	48 8b 7c 0e f8       	mov    -0x8(%rsi,%rcx,1),%rdi
    3000:	4a 89 7c 01 f8       	mov    %rdi,-0x8(%rcx,%r8,1)
    3005:	49 8d 78 08          	lea    0x8(%r8),%rdi
    3009:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
    300d:	49 29 f8             	sub    %rdi,%r8
    3010:	44 01 c1             	add    %r8d,%ecx
    3013:	4c 29 c6             	sub    %r8,%rsi
    3016:	c1 e9 03             	shr    $0x3,%ecx
    3019:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    301c:	41 8b 4d 08          	mov    0x8(%r13),%ecx
    3020:	80 7a 02 01          	cmpb   $0x1,0x2(%rdx)
    3024:	49 8d 34 0a          	lea    (%r10,%rcx,1),%rsi
    3028:	0f 85 ca fe ff ff    	jne    2ef8 <ayatsuri_model_instance_init+0x1a8>
    302e:	b9 df ff ff ff       	mov    $0xffffffdf,%ecx
    3033:	0f 13 8e fc 00 00 00 	movlps %xmm1,0xfc(%rsi)
    303a:	41 39 cf             	cmp    %ecx,%r15d
    303d:	41 0f 46 cf          	cmovbe %r15d,%ecx
    3041:	44 8d 79 20          	lea    0x20(%rcx),%r15d
    3045:	e9 c7 fe ff ff       	jmp    2f11 <ayatsuri_model_instance_init+0x1c1>
    304a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3050:	48 89 de             	mov    %rbx,%rsi
    3053:	b8 01 00 00 00       	mov    $0x1,%eax
    3058:	4c 29 d6             	sub    %r10,%rsi
    305b:	4c 39 e6             	cmp    %r12,%rsi
    305e:	0f 82 77 fd ff ff    	jb     2ddb <ayatsuri_model_instance_init+0x8b>
    3064:	e9 d1 fd ff ff       	jmp    2e3a <ayatsuri_model_instance_init+0xea>
    3069:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3070:	4c 89 d6             	mov    %r10,%rsi
    3073:	b8 01 00 00 00       	mov    $0x1,%eax
    3078:	4c 29 ce             	sub    %r9,%rsi
    307b:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    3082:	0f 86 53 fd ff ff    	jbe    2ddb <ayatsuri_model_instance_init+0x8b>
    3088:	e9 c6 fd ff ff       	jmp    2e53 <ayatsuri_model_instance_init+0x103>
    308d:	0f 1f 00             	nopl   (%rax)
    3090:	4c 89 ce             	mov    %r9,%rsi
    3093:	b8 01 00 00 00       	mov    $0x1,%eax
    3098:	48 29 de             	sub    %rbx,%rsi
    309b:	48 83 fe 7f          	cmp    $0x7f,%rsi
    309f:	0f 86 36 fd ff ff    	jbe    2ddb <ayatsuri_model_instance_init+0x8b>
    30a5:	e9 ca fd ff ff       	jmp    2e74 <ayatsuri_model_instance_init+0x124>
    30aa:	44 8b 44 24 04       	mov    0x4(%rsp),%r8d
    30af:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
    30b4:	48 89 5c 24 10       	mov    %rbx,0x10(%rsp)
    30b9:	4c 89 54 24 18       	mov    %r10,0x18(%rsp)
    30be:	66 0f 6f 44 24 10    	movdqa 0x10(%rsp),%xmm0
    30c4:	48 89 6c 24 20       	mov    %rbp,0x20(%rsp)
    30c9:	4c 89 64 24 28       	mov    %r12,0x28(%rsp)
    30ce:	41 0f 11 01          	movups %xmm0,(%r9)
    30d2:	66 0f 6f 44 24 20    	movdqa 0x20(%rsp),%xmm0
    30d8:	44 89 44 24 30       	mov    %r8d,0x30(%rsp)
    30dd:	41 0f 11 41 10       	movups %xmm0,0x10(%r9)
    30e2:	66 0f 6f 44 24 30    	movdqa 0x30(%rsp),%xmm0
    30e8:	44 89 bc 24 ac 00 00 	mov    %r15d,0xac(%rsp)
    30ef:	00 
    30f0:	41 0f 11 41 20       	movups %xmm0,0x20(%r9)
    30f5:	66 0f 6f 44 24 40    	movdqa 0x40(%rsp),%xmm0
    30fb:	c6 84 24 b4 00 00 00 	movb   $0x1,0xb4(%rsp)
    3102:	01 
    3103:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
    310a:	00 
    310b:	41 0f 11 41 30       	movups %xmm0,0x30(%r9)
    3110:	66 0f 6f 44 24 50    	movdqa 0x50(%rsp),%xmm0
    3116:	49 89 81 a0 00 00 00 	mov    %rax,0xa0(%r9)
    311d:	31 c0                	xor    %eax,%eax
    311f:	41 0f 11 41 40       	movups %xmm0,0x40(%r9)
    3124:	66 0f 6f 44 24 60    	movdqa 0x60(%rsp),%xmm0
    312a:	41 0f 11 41 50       	movups %xmm0,0x50(%r9)
    312f:	66 0f 6f 44 24 70    	movdqa 0x70(%rsp),%xmm0
    3135:	41 0f 11 41 60       	movups %xmm0,0x60(%r9)
    313a:	66 0f 6f 84 24 80 00 	movdqa 0x80(%rsp),%xmm0
    3141:	00 00 
    3143:	41 0f 11 41 70       	movups %xmm0,0x70(%r9)
    3148:	66 0f 6f 84 24 90 00 	movdqa 0x90(%rsp),%xmm0
    314f:	00 00 
    3151:	41 0f 11 81 80 00 00 	movups %xmm0,0x80(%r9)
    3158:	00 
    3159:	66 0f 6f 84 24 a0 00 	movdqa 0xa0(%rsp),%xmm0
    3160:	00 00 
    3162:	41 0f 11 81 90 00 00 	movups %xmm0,0x90(%r9)
    3169:	00 
    316a:	e9 6c fc ff ff       	jmp    2ddb <ayatsuri_model_instance_init+0x8b>
    316f:	4c 89 ce             	mov    %r9,%rsi
    3172:	b8 01 00 00 00       	mov    $0x1,%eax
    3177:	48 29 ce             	sub    %rcx,%rsi
    317a:	48 39 d6             	cmp    %rdx,%rsi
    317d:	0f 82 58 fc ff ff    	jb     2ddb <ayatsuri_model_instance_init+0x8b>
    3183:	e9 0f fd ff ff       	jmp    2e97 <ayatsuri_model_instance_init+0x147>
    3188:	45 31 ff             	xor    %r15d,%r15d
    318b:	e9 24 ff ff ff       	jmp    30b4 <ayatsuri_model_instance_init+0x364>

0000000000003190 <ayatsuri_model_instance_dispose>:
    3190:	b8 03 00 00 00       	mov    $0x3,%eax
    3195:	48 85 ff             	test   %rdi,%rdi
    3198:	74 46                	je     31e0 <ayatsuri_model_instance_dispose+0x50>
    319a:	48 85 f6             	test   %rsi,%rsi
    319d:	74 41                	je     31e0 <ayatsuri_model_instance_dispose+0x50>
    319f:	48 39 77 10          	cmp    %rsi,0x10(%rdi)
    31a3:	75 3b                	jne    31e0 <ayatsuri_model_instance_dispose+0x50>
    31a5:	39 57 20             	cmp    %edx,0x20(%rdi)
    31a8:	75 36                	jne    31e0 <ayatsuri_model_instance_dispose+0x50>
    31aa:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    31b1:	b8 04 00 00 00       	mov    $0x4,%eax
    31b6:	75 28                	jne    31e0 <ayatsuri_model_instance_dispose+0x50>
    31b8:	c6 87 a4 00 00 00 00 	movb   $0x0,0xa4(%rdi)
    31bf:	31 c0                	xor    %eax,%eax
    31c1:	c6 87 a6 00 00 00 00 	movb   $0x0,0xa6(%rdi)
    31c8:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
    31cf:	00 
    31d0:	48 c7 47 18 00 00 00 	movq   $0x0,0x18(%rdi)
    31d7:	00 
    31d8:	c3                   	ret
    31d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    31e0:	c3                   	ret
    31e1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    31e8:	00 00 00 00 
    31ec:	0f 1f 40 00          	nopl   0x0(%rax)

00000000000031f0 <ayatsuri_model_instance_targets>:
    31f0:	48 85 ff             	test   %rdi,%rdi
    31f3:	0f 84 d7 00 00 00    	je     32d0 <ayatsuri_model_instance_targets+0xe0>
    31f9:	48 89 f8             	mov    %rdi,%rax
    31fc:	bf 03 00 00 00       	mov    $0x3,%edi
    3201:	80 b8 a4 00 00 00 01 	cmpb   $0x1,0xa4(%rax)
    3208:	0f 85 c7 00 00 00    	jne    32d5 <ayatsuri_model_instance_targets+0xe5>
    320e:	48 85 f6             	test   %rsi,%rsi
    3211:	0f 84 be 00 00 00    	je     32d5 <ayatsuri_model_instance_targets+0xe5>
    3217:	48 3b 70 10          	cmp    0x10(%rax),%rsi
    321b:	0f 85 b4 00 00 00    	jne    32d5 <ayatsuri_model_instance_targets+0xe5>
    3221:	3b 50 20             	cmp    0x20(%rax),%edx
    3224:	0f 85 ab 00 00 00    	jne    32d5 <ayatsuri_model_instance_targets+0xe5>
    322a:	80 b8 a5 00 00 00 00 	cmpb   $0x0,0xa5(%rax)
    3231:	bf 04 00 00 00       	mov    $0x4,%edi
    3236:	0f 85 99 00 00 00    	jne    32d5 <ayatsuri_model_instance_targets+0xe5>
    323c:	41 57                	push   %r15
    323e:	41 56                	push   %r14
    3240:	41 55                	push   %r13
    3242:	41 54                	push   %r12
    3244:	55                   	push   %rbp
    3245:	53                   	push   %rbx
    3246:	48 83 ec 18          	sub    $0x18,%rsp
    324a:	48 8b 38             	mov    (%rax),%rdi
    324d:	c6 80 a5 00 00 00 01 	movb   $0x1,0xa5(%rax)
    3254:	0f b7 57 0c          	movzwl 0xc(%rdi),%edx
    3258:	48 89 d3             	mov    %rdx,%rbx
    325b:	48 85 c9             	test   %rcx,%rcx
    325e:	0f 84 8c 00 00 00    	je     32f0 <ayatsuri_model_instance_targets+0x100>
    3264:	48 39 51 20          	cmp    %rdx,0x20(%rcx)
    3268:	0f 85 82 00 00 00    	jne    32f0 <ayatsuri_model_instance_targets+0x100>
    326e:	48 8b 31             	mov    (%rcx),%rsi
    3271:	48 85 f6             	test   %rsi,%rsi
    3274:	74 7a                	je     32f0 <ayatsuri_model_instance_targets+0x100>
    3276:	4c 8b 41 08          	mov    0x8(%rcx),%r8
    327a:	4d 85 c0             	test   %r8,%r8
    327d:	74 71                	je     32f0 <ayatsuri_model_instance_targets+0x100>
    327f:	4c 8b 51 10          	mov    0x10(%rcx),%r10
    3283:	4d 85 d2             	test   %r10,%r10
    3286:	74 68                	je     32f0 <ayatsuri_model_instance_targets+0x100>
    3288:	4c 8b 59 18          	mov    0x18(%rcx),%r11
    328c:	4d 85 db             	test   %r11,%r11
    328f:	74 5f                	je     32f0 <ayatsuri_model_instance_targets+0x100>
    3291:	48 8b 68 18          	mov    0x18(%rax),%rbp
    3295:	4c 8b 48 08          	mov    0x8(%rax),%r9
    3299:	48 85 ed             	test   %rbp,%rbp
    329c:	4c 89 c9             	mov    %r9,%rcx
    329f:	41 0f 95 c4          	setne  %r12b
    32a3:	48 85 d2             	test   %rdx,%rdx
    32a6:	74 68                	je     3310 <ayatsuri_model_instance_targets+0x120>
    32a8:	45 84 e4             	test   %r12b,%r12b
    32ab:	74 63                	je     3310 <ayatsuri_model_instance_targets+0x120>
    32ad:	49 39 f1             	cmp    %rsi,%r9
    32b0:	73 2e                	jae    32e0 <ayatsuri_model_instance_targets+0xf0>
    32b2:	49 89 f5             	mov    %rsi,%r13
    32b5:	4d 29 cd             	sub    %r9,%r13
    32b8:	49 39 ed             	cmp    %rbp,%r13
    32bb:	72 33                	jb     32f0 <ayatsuri_model_instance_targets+0x100>
    32bd:	4c 8d 2c d5 00 00 00 	lea    0x0(,%rdx,8),%r13
    32c4:	00 
    32c5:	4d 8d 7c 15 00       	lea    0x0(%r13,%rdx,1),%r15
    32ca:	49 c1 e7 02          	shl    $0x2,%r15
    32ce:	eb 60                	jmp    3330 <ayatsuri_model_instance_targets+0x140>
    32d0:	bf 03 00 00 00       	mov    $0x3,%edi
    32d5:	89 f8                	mov    %edi,%eax
    32d7:	c3                   	ret
    32d8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    32df:	00 
    32e0:	4d 89 cd             	mov    %r9,%r13
    32e3:	49 29 f5             	sub    %rsi,%r13
    32e6:	49 39 d5             	cmp    %rdx,%r13
    32e9:	73 d2                	jae    32bd <ayatsuri_model_instance_targets+0xcd>
    32eb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    32f0:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    32f7:	bf 01 00 00 00       	mov    $0x1,%edi
    32fc:	48 83 c4 18          	add    $0x18,%rsp
    3300:	89 f8                	mov    %edi,%eax
    3302:	5b                   	pop    %rbx
    3303:	5d                   	pop    %rbp
    3304:	41 5c                	pop    %r12
    3306:	41 5d                	pop    %r13
    3308:	41 5e                	pop    %r14
    330a:	41 5f                	pop    %r15
    330c:	c3                   	ret
    330d:	0f 1f 00             	nopl   (%rax)
    3310:	4c 8d 2c d5 00 00 00 	lea    0x0(,%rdx,8),%r13
    3317:	00 
    3318:	4d 8d 74 15 00       	lea    0x0(%r13,%rdx,1),%r14
    331d:	4e 8d 3c b5 00 00 00 	lea    0x0(,%r14,4),%r15
    3324:	00 
    3325:	4d 85 f6             	test   %r14,%r14
    3328:	74 26                	je     3350 <ayatsuri_model_instance_targets+0x160>
    332a:	45 84 e4             	test   %r12b,%r12b
    332d:	74 21                	je     3350 <ayatsuri_model_instance_targets+0x160>
    332f:	90                   	nop
    3330:	4d 39 c1             	cmp    %r8,%r9
    3333:	0f 82 67 03 00 00    	jb     36a0 <ayatsuri_model_instance_targets+0x4b0>
    3339:	4d 89 ce             	mov    %r9,%r14
    333c:	4d 29 c6             	sub    %r8,%r14
    333f:	4d 39 fe             	cmp    %r15,%r14
    3342:	72 ac                	jb     32f0 <ayatsuri_model_instance_targets+0x100>
    3344:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    334b:	00 00 00 00 
    334f:	90                   	nop
    3350:	4c 8d 34 95 00 00 00 	lea    0x0(,%rdx,4),%r14
    3357:	00 
    3358:	48 85 d2             	test   %rdx,%rdx
    335b:	74 23                	je     3380 <ayatsuri_model_instance_targets+0x190>
    335d:	45 84 e4             	test   %r12b,%r12b
    3360:	74 1e                	je     3380 <ayatsuri_model_instance_targets+0x190>
    3362:	4d 39 d1             	cmp    %r10,%r9
    3365:	0f 82 65 03 00 00    	jb     36d0 <ayatsuri_model_instance_targets+0x4e0>
    336b:	4c 89 ca             	mov    %r9,%rdx
    336e:	4c 29 d2             	sub    %r10,%rdx
    3371:	4c 39 f2             	cmp    %r14,%rdx
    3374:	0f 82 76 ff ff ff    	jb     32f0 <ayatsuri_model_instance_targets+0x100>
    337a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3380:	4d 85 ed             	test   %r13,%r13
    3383:	74 2b                	je     33b0 <ayatsuri_model_instance_targets+0x1c0>
    3385:	45 84 e4             	test   %r12b,%r12b
    3388:	74 26                	je     33b0 <ayatsuri_model_instance_targets+0x1c0>
    338a:	4d 39 d9             	cmp    %r11,%r9
    338d:	0f 82 51 03 00 00    	jb     36e4 <ayatsuri_model_instance_targets+0x4f4>
    3393:	4c 89 ca             	mov    %r9,%rdx
    3396:	4c 29 da             	sub    %r11,%rdx
    3399:	4c 39 ea             	cmp    %r13,%rdx
    339c:	0f 82 4e ff ff ff    	jb     32f0 <ayatsuri_model_instance_targets+0x100>
    33a2:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    33a9:	00 00 00 00 
    33ad:	0f 1f 00             	nopl   (%rax)
    33b0:	44 0f b7 fb          	movzwl %bx,%r15d
    33b4:	45 85 ff             	test   %r15d,%r15d
    33b7:	0f 84 d3 02 00 00    	je     3690 <ayatsuri_model_instance_targets+0x4a0>
    33bd:	8b 57 14             	mov    0x14(%rdi),%edx
    33c0:	4c 89 1c 24          	mov    %r11,(%rsp)
    33c4:	31 ed                	xor    %ebp,%ebp
    33c6:	bb ab aa aa aa       	mov    $0xaaaaaaab,%ebx
    33cb:	48 8b 3f             	mov    (%rdi),%rdi
    33ce:	4c 89 4c 24 08       	mov    %r9,0x8(%rsp)
    33d3:	66 0f ef e4          	pxor   %xmm4,%xmm4
    33d7:	45 31 f6             	xor    %r14d,%r14d
    33da:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
    33df:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 33e7 <ayatsuri_model_instance_targets+0x1f7>
    33e6:	00 
			33e3: R_X86_64_PC32	.LC1-0x4
    33e7:	f3 0f 10 1d 00 00 00 	movss  0x0(%rip),%xmm3        # 33ef <ayatsuri_model_instance_targets+0x1ff>
    33ee:	00 
			33eb: R_X86_64_PC32	.LC0-0x4
    33ef:	48 8d 54 17 02       	lea    0x2(%rdi,%rdx,1),%rdx
    33f4:	44 0f b6 0c 2e       	movzbl (%rsi,%rbp,1),%r9d
    33f9:	45 89 cc             	mov    %r9d,%r12d
    33fc:	45 84 c9             	test   %r9b,%r9b
    33ff:	0f 88 eb fe ff ff    	js     32f0 <ayatsuri_model_instance_targets+0x100>
    3405:	44 89 c9             	mov    %r9d,%ecx
    3408:	f7 d1                	not    %ecx
    340a:	83 e1 18             	and    $0x18,%ecx
    340d:	0f 84 dd fe ff ff    	je     32f0 <ayatsuri_model_instance_targets+0x100>
    3413:	0f b6 0a             	movzbl (%rdx),%ecx
    3416:	84 c9                	test   %cl,%cl
    3418:	0f 84 9a 02 00 00    	je     36b8 <ayatsuri_model_instance_targets+0x4c8>
    341e:	80 f9 03             	cmp    $0x3,%cl
    3421:	0f 84 91 02 00 00    	je     36b8 <ayatsuri_model_instance_targets+0x4c8>
    3427:	41 89 eb             	mov    %ebp,%r11d
    342a:	44 8d 6c ed 00       	lea    0x0(%rbp,%rbp,8),%r13d
    342f:	31 ff                	xor    %edi,%edi
    3431:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    3438:	00 00 00 00 
    343c:	0f 1f 40 00          	nopl   0x0(%rax)
    3440:	89 f9                	mov    %edi,%ecx
    3442:	48 0f af cb          	imul   %rbx,%rcx
    3446:	48 c1 e9 21          	shr    $0x21,%rcx
    344a:	41 0f a3 c9          	bt     %ecx,%r9d
    344e:	73 31                	jae    3481 <ayatsuri_model_instance_targets+0x291>
    3450:	41 8d 4c 3d 00       	lea    0x0(%r13,%rdi,1),%ecx
    3455:	f3 41 0f 10 04 88    	movss  (%r8,%rcx,4),%xmm0
    345b:	0f 28 c8             	movaps %xmm0,%xmm1
    345e:	0f 54 cb             	andps  %xmm3,%xmm1
    3461:	0f 2e d1             	ucomiss %xmm1,%xmm2
    3464:	0f 82 86 fe ff ff    	jb     32f0 <ayatsuri_model_instance_targets+0x100>
    346a:	83 ff 05             	cmp    $0x5,%edi
    346d:	76 12                	jbe    3481 <ayatsuri_model_instance_targets+0x291>
    346f:	0f 2e c4             	ucomiss %xmm4,%xmm0
    3472:	0f 9b c1             	setnp  %cl
    3475:	41 0f 45 ce          	cmovne %r14d,%ecx
    3479:	84 c9                	test   %cl,%cl
    347b:	0f 85 6f fe ff ff    	jne    32f0 <ayatsuri_model_instance_targets+0x100>
    3481:	83 c7 01             	add    $0x1,%edi
    3484:	83 ff 09             	cmp    $0x9,%edi
    3487:	75 b7                	jne    3440 <ayatsuri_model_instance_targets+0x250>
    3489:	41 f6 c4 20          	test   $0x20,%r12b
    348d:	74 0e                	je     349d <ayatsuri_model_instance_targets+0x2ad>
    348f:	41 81 3c aa ff ff ff 	cmpl   $0xffffff,(%r10,%rbp,4)
    3496:	00 
    3497:	0f 87 53 fe ff ff    	ja     32f0 <ayatsuri_model_instance_targets+0x100>
    349d:	41 83 e4 40          	and    $0x40,%r12d
    34a1:	74 5d                	je     3500 <ayatsuri_model_instance_targets+0x310>
    34a3:	48 8b 0c 24          	mov    (%rsp),%rcx
    34a7:	42 8d 3c dd 00 00 00 	lea    0x0(,%r11,8),%edi
    34ae:	00 
    34af:	48 01 cf             	add    %rcx,%rdi
    34b2:	e8 49 cb ff ff       	call   0 <md>
    34b7:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 34bf <ayatsuri_model_instance_targets+0x2cf>
    34be:	00 
			34bb: R_X86_64_PC32	.LC22-0x4
    34bf:	66 0f 28 c8          	movapd %xmm0,%xmm1
    34c3:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 34cb <ayatsuri_model_instance_targets+0x2db>
    34ca:	00 
			34c7: R_X86_64_PC32	.LC8-0x4
    34cb:	66 0f 2e e9          	ucomisd %xmm1,%xmm5
    34cf:	0f 82 1b fe ff ff    	jb     32f0 <ayatsuri_model_instance_targets+0x100>
    34d5:	66 0f ef c9          	pxor   %xmm1,%xmm1
    34d9:	66 0f 2f c1          	comisd %xmm1,%xmm0
    34dd:	0f 82 0d fe ff ff    	jb     32f0 <ayatsuri_model_instance_targets+0x100>
    34e3:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 34eb <ayatsuri_model_instance_targets+0x2fb>
    34ea:	00 
			34e7: R_X86_64_PC32	.LC9-0x4
    34eb:	66 0f 2f c8          	comisd %xmm0,%xmm1
    34ef:	0f 82 fb fd ff ff    	jb     32f0 <ayatsuri_model_instance_targets+0x100>
    34f5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    34fc:	00 00 00 00 
    3500:	48 83 c5 01          	add    $0x1,%rbp
    3504:	48 83 c2 10          	add    $0x10,%rdx
    3508:	44 39 fd             	cmp    %r15d,%ebp
    350b:	0f 82 e3 fe ff ff    	jb     33f4 <ayatsuri_model_instance_targets+0x204>
    3511:	43 8d 1c ff          	lea    (%r15,%r15,8),%ebx
    3515:	4c 8b 1c 24          	mov    (%rsp),%r11
    3519:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
    351e:	45 31 ed             	xor    %r13d,%r13d
    3521:	89 1c 24             	mov    %ebx,(%rsp)
    3524:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
    3529:	41 bc ab aa aa aa    	mov    $0xaaaaaaab,%r12d
    352f:	c6 44 24 08 00       	movb   $0x0,0x8(%rsp)
    3534:	0f b6 1e             	movzbl (%rsi),%ebx
    3537:	8b 69 08             	mov    0x8(%rcx),%ebp
    353a:	45 31 ff             	xor    %r15d,%r15d
    353d:	31 ff                	xor    %edi,%edi
    353f:	41 89 de             	mov    %ebx,%r14d
    3542:	4c 01 cd             	add    %r9,%rbp
    3545:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    354c:	00 00 00 00 
    3550:	89 fa                	mov    %edi,%edx
    3552:	49 0f af d4          	imul   %r12,%rdx
    3556:	48 c1 ea 21          	shr    $0x21,%rdx
    355a:	0f a3 d3             	bt     %edx,%ebx
    355d:	73 3c                	jae    359b <ayatsuri_model_instance_targets+0x3ab>
    355f:	41 8d 54 3d 00       	lea    0x0(%r13,%rdi,1),%edx
    3564:	f3 41 0f 10 04 90    	movss  (%r8,%rdx,4),%xmm0
    356a:	0f 2e 44 bd 30       	ucomiss 0x30(%rbp,%rdi,4),%xmm0
    356f:	7a 02                	jp     3573 <ayatsuri_model_instance_targets+0x383>
    3571:	74 28                	je     359b <ayatsuri_model_instance_targets+0x3ab>
    3573:	8b 90 a0 00 00 00    	mov    0xa0(%rax),%edx
    3579:	41 bf fb ff ff ff    	mov    $0xfffffffb,%r15d
    357f:	f3 0f 11 44 bd 30    	movss  %xmm0,0x30(%rbp,%rdi,4)
    3585:	44 39 fa             	cmp    %r15d,%edx
    3588:	41 0f 47 d7          	cmova  %r15d,%edx
    358c:	41 bf 01 00 00 00    	mov    $0x1,%r15d
    3592:	83 c2 04             	add    $0x4,%edx
    3595:	89 90 a0 00 00 00    	mov    %edx,0xa0(%rax)
    359b:	48 83 c7 01          	add    $0x1,%rdi
    359f:	48 83 ff 09          	cmp    $0x9,%rdi
    35a3:	75 ab                	jne    3550 <ayatsuri_model_instance_targets+0x360>
    35a5:	41 f6 c6 18          	test   $0x18,%r14b
    35a9:	0f 84 49 01 00 00    	je     36f8 <ayatsuri_model_instance_targets+0x508>
    35af:	44 89 f2             	mov    %r14d,%edx
    35b2:	c0 ea 03             	shr    $0x3,%dl
    35b5:	83 e2 01             	and    $0x1,%edx
    35b8:	38 51 10             	cmp    %dl,0x10(%rcx)
    35bb:	0f 84 37 01 00 00    	je     36f8 <ayatsuri_model_instance_targets+0x508>
    35c1:	88 51 10             	mov    %dl,0x10(%rcx)
    35c4:	8b 90 a0 00 00 00    	mov    0xa0(%rax),%edx
    35ca:	31 ff                	xor    %edi,%edi
    35cc:	83 fa ff             	cmp    $0xffffffff,%edx
    35cf:	40 0f 95 c7          	setne  %dil
    35d3:	01 fa                	add    %edi,%edx
    35d5:	89 90 a0 00 00 00    	mov    %edx,0xa0(%rax)
    35db:	41 f6 c6 20          	test   $0x20,%r14b
    35df:	74 24                	je     3605 <ayatsuri_model_instance_targets+0x415>
    35e1:	41 8b 12             	mov    (%r10),%edx
    35e4:	39 51 0c             	cmp    %edx,0xc(%rcx)
    35e7:	74 1c                	je     3605 <ayatsuri_model_instance_targets+0x415>
    35e9:	89 51 0c             	mov    %edx,0xc(%rcx)
    35ec:	8b 90 a0 00 00 00    	mov    0xa0(%rax),%edx
    35f2:	bf fb ff ff ff       	mov    $0xfffffffb,%edi
    35f7:	39 fa                	cmp    %edi,%edx
    35f9:	0f 47 d7             	cmova  %edi,%edx
    35fc:	83 c2 04             	add    $0x4,%edx
    35ff:	89 90 a0 00 00 00    	mov    %edx,0xa0(%rax)
    3605:	41 83 e6 40          	and    $0x40,%r14d
    3609:	74 2d                	je     3638 <ayatsuri_model_instance_targets+0x448>
    360b:	4c 89 df             	mov    %r11,%rdi
    360e:	e8 ed c9 ff ff       	call   0 <md>
    3613:	66 0f 2e 01          	ucomisd (%rcx),%xmm0
    3617:	7a 02                	jp     361b <ayatsuri_model_instance_targets+0x42b>
    3619:	74 1d                	je     3638 <ayatsuri_model_instance_targets+0x448>
    361b:	8b 90 a0 00 00 00    	mov    0xa0(%rax),%edx
    3621:	bf f7 ff ff ff       	mov    $0xfffffff7,%edi
    3626:	f2 0f 11 01          	movsd  %xmm0,(%rcx)
    362a:	39 fa                	cmp    %edi,%edx
    362c:	0f 47 d7             	cmova  %edi,%edx
    362f:	83 c2 08             	add    $0x8,%edx
    3632:	89 90 a0 00 00 00    	mov    %edx,0xa0(%rax)
    3638:	8b 90 98 00 00 00    	mov    0x98(%rax),%edx
    363e:	31 ff                	xor    %edi,%edi
    3640:	c6 44 24 08 01       	movb   $0x1,0x8(%rsp)
    3645:	83 fa ff             	cmp    $0xffffffff,%edx
    3648:	40 0f 95 c7          	setne  %dil
    364c:	01 fa                	add    %edi,%edx
    364e:	89 90 98 00 00 00    	mov    %edx,0x98(%rax)
    3654:	8b 1c 24             	mov    (%rsp),%ebx
    3657:	41 83 c5 09          	add    $0x9,%r13d
    365b:	48 83 c6 01          	add    $0x1,%rsi
    365f:	48 83 c1 18          	add    $0x18,%rcx
    3663:	49 83 c3 08          	add    $0x8,%r11
    3667:	49 83 c2 04          	add    $0x4,%r10
    366b:	41 39 dd             	cmp    %ebx,%r13d
    366e:	0f 85 c0 fe ff ff    	jne    3534 <ayatsuri_model_instance_targets+0x344>
    3674:	80 7c 24 08 00       	cmpb   $0x0,0x8(%rsp)
    3679:	74 15                	je     3690 <ayatsuri_model_instance_targets+0x4a0>
    367b:	8b 50 24             	mov    0x24(%rax),%edx
    367e:	83 fa ff             	cmp    $0xffffffff,%edx
    3681:	74 03                	je     3686 <ayatsuri_model_instance_targets+0x496>
    3683:	83 c2 01             	add    $0x1,%edx
    3686:	89 50 24             	mov    %edx,0x24(%rax)
    3689:	c6 80 a6 00 00 00 00 	movb   $0x0,0xa6(%rax)
    3690:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    3697:	31 ff                	xor    %edi,%edi
    3699:	e9 5e fc ff ff       	jmp    32fc <ayatsuri_model_instance_targets+0x10c>
    369e:	66 90                	xchg   %ax,%ax
    36a0:	4d 89 c6             	mov    %r8,%r14
    36a3:	4d 29 ce             	sub    %r9,%r14
    36a6:	49 39 ee             	cmp    %rbp,%r14
    36a9:	0f 82 41 fc ff ff    	jb     32f0 <ayatsuri_model_instance_targets+0x100>
    36af:	e9 9c fc ff ff       	jmp    3350 <ayatsuri_model_instance_targets+0x160>
    36b4:	0f 1f 40 00          	nopl   0x0(%rax)
    36b8:	41 f6 c4 60          	test   $0x60,%r12b
    36bc:	0f 84 65 fd ff ff    	je     3427 <ayatsuri_model_instance_targets+0x237>
    36c2:	e9 29 fc ff ff       	jmp    32f0 <ayatsuri_model_instance_targets+0x100>
    36c7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    36ce:	00 00 
    36d0:	4c 89 d2             	mov    %r10,%rdx
    36d3:	4c 29 ca             	sub    %r9,%rdx
    36d6:	48 39 ea             	cmp    %rbp,%rdx
    36d9:	0f 82 11 fc ff ff    	jb     32f0 <ayatsuri_model_instance_targets+0x100>
    36df:	e9 9c fc ff ff       	jmp    3380 <ayatsuri_model_instance_targets+0x190>
    36e4:	4c 89 da             	mov    %r11,%rdx
    36e7:	4c 29 ca             	sub    %r9,%rdx
    36ea:	48 39 ea             	cmp    %rbp,%rdx
    36ed:	0f 83 bd fc ff ff    	jae    33b0 <ayatsuri_model_instance_targets+0x1c0>
    36f3:	e9 f8 fb ff ff       	jmp    32f0 <ayatsuri_model_instance_targets+0x100>
    36f8:	41 f6 c6 20          	test   $0x20,%r14b
    36fc:	74 0c                	je     370a <ayatsuri_model_instance_targets+0x51a>
    36fe:	41 8b 12             	mov    (%r10),%edx
    3701:	39 51 0c             	cmp    %edx,0xc(%rcx)
    3704:	0f 85 df fe ff ff    	jne    35e9 <ayatsuri_model_instance_targets+0x3f9>
    370a:	41 83 e6 40          	and    $0x40,%r14d
    370e:	74 18                	je     3728 <ayatsuri_model_instance_targets+0x538>
    3710:	4c 89 df             	mov    %r11,%rdi
    3713:	e8 e8 c8 ff ff       	call   0 <md>
    3718:	66 0f 2e 01          	ucomisd (%rcx),%xmm0
    371c:	0f 8a f9 fe ff ff    	jp     361b <ayatsuri_model_instance_targets+0x42b>
    3722:	0f 85 f3 fe ff ff    	jne    361b <ayatsuri_model_instance_targets+0x42b>
    3728:	45 84 ff             	test   %r15b,%r15b
    372b:	0f 84 23 ff ff ff    	je     3654 <ayatsuri_model_instance_targets+0x464>
    3731:	e9 02 ff ff ff       	jmp    3638 <ayatsuri_model_instance_targets+0x448>
    3736:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    373d:	00 00 00 

0000000000003740 <ayatsuri_model_instance_node_kind>:
    3740:	48 89 f8             	mov    %rdi,%rax
    3743:	89 cf                	mov    %ecx,%edi
    3745:	b9 03 00 00 00       	mov    $0x3,%ecx
    374a:	48 85 c0             	test   %rax,%rax
    374d:	74 6d                	je     37bc <ayatsuri_model_instance_node_kind+0x7c>
    374f:	80 b8 a4 00 00 00 01 	cmpb   $0x1,0xa4(%rax)
    3756:	75 64                	jne    37bc <ayatsuri_model_instance_node_kind+0x7c>
    3758:	48 85 f6             	test   %rsi,%rsi
    375b:	74 5f                	je     37bc <ayatsuri_model_instance_node_kind+0x7c>
    375d:	48 3b 70 10          	cmp    0x10(%rax),%rsi
    3761:	75 59                	jne    37bc <ayatsuri_model_instance_node_kind+0x7c>
    3763:	3b 50 20             	cmp    0x20(%rax),%edx
    3766:	75 54                	jne    37bc <ayatsuri_model_instance_node_kind+0x7c>
    3768:	80 b8 a5 00 00 00 00 	cmpb   $0x0,0xa5(%rax)
    376f:	b9 04 00 00 00       	mov    $0x4,%ecx
    3774:	75 46                	jne    37bc <ayatsuri_model_instance_node_kind+0x7c>
    3776:	c6 80 a5 00 00 00 01 	movb   $0x1,0xa5(%rax)
    377d:	4d 85 c0             	test   %r8,%r8
    3780:	74 2e                	je     37b0 <ayatsuri_model_instance_node_kind+0x70>
    3782:	48 8b 10             	mov    (%rax),%rdx
    3785:	66 3b 7a 0c          	cmp    0xc(%rdx),%di
    3789:	73 25                	jae    37b0 <ayatsuri_model_instance_node_kind+0x70>
    378b:	4c 39 c0             	cmp    %r8,%rax
    378e:	73 30                	jae    37c0 <ayatsuri_model_instance_node_kind+0x80>
    3790:	4c 89 c1             	mov    %r8,%rcx
    3793:	48 29 c1             	sub    %rax,%rcx
    3796:	48 81 f9 a7 00 00 00 	cmp    $0xa7,%rcx
    379d:	76 11                	jbe    37b0 <ayatsuri_model_instance_node_kind+0x70>
    379f:	4c 39 c2             	cmp    %r8,%rdx
    37a2:	72 24                	jb     37c8 <ayatsuri_model_instance_node_kind+0x88>
    37a4:	49 39 d0             	cmp    %rdx,%r8
    37a7:	75 2b                	jne    37d4 <ayatsuri_model_instance_node_kind+0x94>
    37a9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    37b0:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    37b7:	b9 01 00 00 00       	mov    $0x1,%ecx
    37bc:	89 c8                	mov    %ecx,%eax
    37be:	c3                   	ret
    37bf:	90                   	nop
    37c0:	74 ee                	je     37b0 <ayatsuri_model_instance_node_kind+0x70>
    37c2:	eb db                	jmp    379f <ayatsuri_model_instance_node_kind+0x5f>
    37c4:	0f 1f 40 00          	nopl   0x0(%rax)
    37c8:	4c 89 c1             	mov    %r8,%rcx
    37cb:	48 29 d1             	sub    %rdx,%rcx
    37ce:	48 83 f9 7f          	cmp    $0x7f,%rcx
    37d2:	76 dc                	jbe    37b0 <ayatsuri_model_instance_node_kind+0x70>
    37d4:	48 8b 48 18          	mov    0x18(%rax),%rcx
    37d8:	48 85 c9             	test   %rcx,%rcx
    37db:	74 13                	je     37f0 <ayatsuri_model_instance_node_kind+0xb0>
    37dd:	48 8b 70 08          	mov    0x8(%rax),%rsi
    37e1:	4c 39 c6             	cmp    %r8,%rsi
    37e4:	72 5a                	jb     3840 <ayatsuri_model_instance_node_kind+0x100>
    37e6:	49 39 f0             	cmp    %rsi,%r8
    37e9:	74 c5                	je     37b0 <ayatsuri_model_instance_node_kind+0x70>
    37eb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    37f0:	8b 4a 08             	mov    0x8(%rdx),%ecx
    37f3:	48 8b 32             	mov    (%rdx),%rsi
    37f6:	48 85 c9             	test   %rcx,%rcx
    37f9:	74 15                	je     3810 <ayatsuri_model_instance_node_kind+0xd0>
    37fb:	4c 39 c6             	cmp    %r8,%rsi
    37fe:	72 58                	jb     3858 <ayatsuri_model_instance_node_kind+0x118>
    3800:	49 39 f0             	cmp    %rsi,%r8
    3803:	74 ab                	je     37b0 <ayatsuri_model_instance_node_kind+0x70>
    3805:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    380c:	00 00 00 00 
    3810:	8b 52 14             	mov    0x14(%rdx),%edx
    3813:	48 89 f9             	mov    %rdi,%rcx
    3816:	48 c1 e1 04          	shl    $0x4,%rcx
    381a:	81 e1 f0 ff 0f 00    	and    $0xffff0,%ecx
    3820:	48 01 d6             	add    %rdx,%rsi
    3823:	0f b6 54 31 02       	movzbl 0x2(%rcx,%rsi,1),%edx
    3828:	31 c9                	xor    %ecx,%ecx
    382a:	41 88 10             	mov    %dl,(%r8)
    382d:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    3834:	eb 86                	jmp    37bc <ayatsuri_model_instance_node_kind+0x7c>
    3836:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    383d:	00 00 00 
    3840:	4d 89 c1             	mov    %r8,%r9
    3843:	49 29 f1             	sub    %rsi,%r9
    3846:	49 39 c9             	cmp    %rcx,%r9
    3849:	0f 82 61 ff ff ff    	jb     37b0 <ayatsuri_model_instance_node_kind+0x70>
    384f:	eb 9f                	jmp    37f0 <ayatsuri_model_instance_node_kind+0xb0>
    3851:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3858:	4d 89 c1             	mov    %r8,%r9
    385b:	49 29 f1             	sub    %rsi,%r9
    385e:	49 39 c9             	cmp    %rcx,%r9
    3861:	73 ad                	jae    3810 <ayatsuri_model_instance_node_kind+0xd0>
    3863:	e9 48 ff ff ff       	jmp    37b0 <ayatsuri_model_instance_node_kind+0x70>
    3868:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    386f:	00 

0000000000003870 <ayatsuri_model_instance_read_pose>:
    3870:	48 89 f8             	mov    %rdi,%rax
    3873:	89 cf                	mov    %ecx,%edi
    3875:	b9 03 00 00 00       	mov    $0x3,%ecx
    387a:	48 85 c0             	test   %rax,%rax
    387d:	74 6d                	je     38ec <ayatsuri_model_instance_read_pose+0x7c>
    387f:	80 b8 a4 00 00 00 01 	cmpb   $0x1,0xa4(%rax)
    3886:	75 64                	jne    38ec <ayatsuri_model_instance_read_pose+0x7c>
    3888:	48 85 f6             	test   %rsi,%rsi
    388b:	74 5f                	je     38ec <ayatsuri_model_instance_read_pose+0x7c>
    388d:	48 3b 70 10          	cmp    0x10(%rax),%rsi
    3891:	75 59                	jne    38ec <ayatsuri_model_instance_read_pose+0x7c>
    3893:	3b 50 20             	cmp    0x20(%rax),%edx
    3896:	75 54                	jne    38ec <ayatsuri_model_instance_read_pose+0x7c>
    3898:	80 b8 a5 00 00 00 00 	cmpb   $0x0,0xa5(%rax)
    389f:	b9 04 00 00 00       	mov    $0x4,%ecx
    38a4:	75 46                	jne    38ec <ayatsuri_model_instance_read_pose+0x7c>
    38a6:	c6 80 a5 00 00 00 01 	movb   $0x1,0xa5(%rax)
    38ad:	4d 85 c0             	test   %r8,%r8
    38b0:	74 2e                	je     38e0 <ayatsuri_model_instance_read_pose+0x70>
    38b2:	48 8b 10             	mov    (%rax),%rdx
    38b5:	66 3b 7a 0c          	cmp    0xc(%rdx),%di
    38b9:	73 25                	jae    38e0 <ayatsuri_model_instance_read_pose+0x70>
    38bb:	4c 39 c0             	cmp    %r8,%rax
    38be:	73 30                	jae    38f0 <ayatsuri_model_instance_read_pose+0x80>
    38c0:	4c 89 c1             	mov    %r8,%rcx
    38c3:	48 29 c1             	sub    %rax,%rcx
    38c6:	48 81 f9 a7 00 00 00 	cmp    $0xa7,%rcx
    38cd:	76 11                	jbe    38e0 <ayatsuri_model_instance_read_pose+0x70>
    38cf:	4c 39 c2             	cmp    %r8,%rdx
    38d2:	72 2c                	jb     3900 <ayatsuri_model_instance_read_pose+0x90>
    38d4:	48 89 d1             	mov    %rdx,%rcx
    38d7:	4c 29 c1             	sub    %r8,%rcx
    38da:	48 83 f9 23          	cmp    $0x23,%rcx
    38de:	77 2c                	ja     390c <ayatsuri_model_instance_read_pose+0x9c>
    38e0:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    38e7:	b9 01 00 00 00       	mov    $0x1,%ecx
    38ec:	89 c8                	mov    %ecx,%eax
    38ee:	c3                   	ret
    38ef:	90                   	nop
    38f0:	48 89 c1             	mov    %rax,%rcx
    38f3:	4c 29 c1             	sub    %r8,%rcx
    38f6:	48 83 f9 23          	cmp    $0x23,%rcx
    38fa:	76 e4                	jbe    38e0 <ayatsuri_model_instance_read_pose+0x70>
    38fc:	eb d1                	jmp    38cf <ayatsuri_model_instance_read_pose+0x5f>
    38fe:	66 90                	xchg   %ax,%ax
    3900:	4c 89 c1             	mov    %r8,%rcx
    3903:	48 29 d1             	sub    %rdx,%rcx
    3906:	48 83 f9 7f          	cmp    $0x7f,%rcx
    390a:	76 d4                	jbe    38e0 <ayatsuri_model_instance_read_pose+0x70>
    390c:	48 8b 48 18          	mov    0x18(%rax),%rcx
    3910:	48 8b 70 08          	mov    0x8(%rax),%rsi
    3914:	48 85 c9             	test   %rcx,%rcx
    3917:	74 17                	je     3930 <ayatsuri_model_instance_read_pose+0xc0>
    3919:	4c 39 c6             	cmp    %r8,%rsi
    391c:	72 72                	jb     3990 <ayatsuri_model_instance_read_pose+0x120>
    391e:	48 89 f1             	mov    %rsi,%rcx
    3921:	4c 29 c1             	sub    %r8,%rcx
    3924:	48 83 f9 23          	cmp    $0x23,%rcx
    3928:	76 b6                	jbe    38e0 <ayatsuri_model_instance_read_pose+0x70>
    392a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3930:	8b 4a 08             	mov    0x8(%rdx),%ecx
    3933:	48 85 c9             	test   %rcx,%rcx
    3936:	74 18                	je     3950 <ayatsuri_model_instance_read_pose+0xe0>
    3938:	48 8b 12             	mov    (%rdx),%rdx
    393b:	4c 39 c2             	cmp    %r8,%rdx
    393e:	72 68                	jb     39a8 <ayatsuri_model_instance_read_pose+0x138>
    3940:	4c 29 c2             	sub    %r8,%rdx
    3943:	48 83 fa 23          	cmp    $0x23,%rdx
    3947:	76 97                	jbe    38e0 <ayatsuri_model_instance_read_pose+0x70>
    3949:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3950:	0f b7 cf             	movzwl %di,%ecx
    3953:	48 8d 14 49          	lea    (%rcx,%rcx,2),%rdx
    3957:	31 c9                	xor    %ecx,%ecx
    3959:	8b 54 d6 08          	mov    0x8(%rsi,%rdx,8),%edx
    395d:	48 8d 54 16 30       	lea    0x30(%rsi,%rdx,1),%rdx
    3962:	f3 0f 6f 02          	movdqu (%rdx),%xmm0
    3966:	41 0f 11 00          	movups %xmm0,(%r8)
    396a:	f3 0f 6f 42 10       	movdqu 0x10(%rdx),%xmm0
    396f:	41 0f 11 40 10       	movups %xmm0,0x10(%r8)
    3974:	8b 52 20             	mov    0x20(%rdx),%edx
    3977:	41 89 50 20          	mov    %edx,0x20(%r8)
    397b:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    3982:	e9 65 ff ff ff       	jmp    38ec <ayatsuri_model_instance_read_pose+0x7c>
    3987:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    398e:	00 00 
    3990:	4d 89 c1             	mov    %r8,%r9
    3993:	49 29 f1             	sub    %rsi,%r9
    3996:	49 39 c9             	cmp    %rcx,%r9
    3999:	0f 82 41 ff ff ff    	jb     38e0 <ayatsuri_model_instance_read_pose+0x70>
    399f:	eb 8f                	jmp    3930 <ayatsuri_model_instance_read_pose+0xc0>
    39a1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    39a8:	4d 89 c1             	mov    %r8,%r9
    39ab:	49 29 d1             	sub    %rdx,%r9
    39ae:	49 39 c9             	cmp    %rcx,%r9
    39b1:	73 9d                	jae    3950 <ayatsuri_model_instance_read_pose+0xe0>
    39b3:	e9 28 ff ff ff       	jmp    38e0 <ayatsuri_model_instance_read_pose+0x70>
    39b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    39bf:	00 

00000000000039c0 <ayatsuri_model_instance_stats>:
    39c0:	48 89 f8             	mov    %rdi,%rax
    39c3:	bf 03 00 00 00       	mov    $0x3,%edi
    39c8:	48 85 c0             	test   %rax,%rax
    39cb:	74 46                	je     3a13 <ayatsuri_model_instance_stats+0x53>
    39cd:	80 b8 a4 00 00 00 01 	cmpb   $0x1,0xa4(%rax)
    39d4:	75 3d                	jne    3a13 <ayatsuri_model_instance_stats+0x53>
    39d6:	48 85 f6             	test   %rsi,%rsi
    39d9:	74 38                	je     3a13 <ayatsuri_model_instance_stats+0x53>
    39db:	48 3b 70 10          	cmp    0x10(%rax),%rsi
    39df:	75 32                	jne    3a13 <ayatsuri_model_instance_stats+0x53>
    39e1:	3b 50 20             	cmp    0x20(%rax),%edx
    39e4:	75 2d                	jne    3a13 <ayatsuri_model_instance_stats+0x53>
    39e6:	80 b8 a5 00 00 00 00 	cmpb   $0x0,0xa5(%rax)
    39ed:	bf 04 00 00 00       	mov    $0x4,%edi
    39f2:	75 1f                	jne    3a13 <ayatsuri_model_instance_stats+0x53>
    39f4:	48 85 c9             	test   %rcx,%rcx
    39f7:	0f 84 fb 00 00 00    	je     3af8 <ayatsuri_model_instance_stats+0x138>
    39fd:	48 39 c8             	cmp    %rcx,%rax
    3a00:	72 1e                	jb     3a20 <ayatsuri_model_instance_stats+0x60>
    3a02:	48 89 c2             	mov    %rax,%rdx
    3a05:	bf 01 00 00 00       	mov    $0x1,%edi
    3a0a:	48 29 ca             	sub    %rcx,%rdx
    3a0d:	48 83 fa 1b          	cmp    $0x1b,%rdx
    3a11:	77 21                	ja     3a34 <ayatsuri_model_instance_stats+0x74>
    3a13:	89 f8                	mov    %edi,%eax
    3a15:	c3                   	ret
    3a16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    3a1d:	00 00 00 
    3a20:	48 89 ca             	mov    %rcx,%rdx
    3a23:	bf 01 00 00 00       	mov    $0x1,%edi
    3a28:	48 29 c2             	sub    %rax,%rdx
    3a2b:	48 81 fa a7 00 00 00 	cmp    $0xa7,%rdx
    3a32:	76 df                	jbe    3a13 <ayatsuri_model_instance_stats+0x53>
    3a34:	48 8b 10             	mov    (%rax),%rdx
    3a37:	48 39 ca             	cmp    %rcx,%rdx
    3a3a:	0f 83 98 00 00 00    	jae    3ad8 <ayatsuri_model_instance_stats+0x118>
    3a40:	48 89 ce             	mov    %rcx,%rsi
    3a43:	bf 01 00 00 00       	mov    $0x1,%edi
    3a48:	48 29 d6             	sub    %rdx,%rsi
    3a4b:	48 83 fe 7f          	cmp    $0x7f,%rsi
    3a4f:	76 c2                	jbe    3a13 <ayatsuri_model_instance_stats+0x53>
    3a51:	48 8b 70 18          	mov    0x18(%rax),%rsi
    3a55:	48 85 f6             	test   %rsi,%rsi
    3a58:	74 26                	je     3a80 <ayatsuri_model_instance_stats+0xc0>
    3a5a:	48 8b 78 08          	mov    0x8(%rax),%rdi
    3a5e:	48 39 cf             	cmp    %rcx,%rdi
    3a61:	0f 82 99 00 00 00    	jb     3b00 <ayatsuri_model_instance_stats+0x140>
    3a67:	48 29 cf             	sub    %rcx,%rdi
    3a6a:	48 89 fe             	mov    %rdi,%rsi
    3a6d:	bf 01 00 00 00       	mov    $0x1,%edi
    3a72:	48 83 fe 1b          	cmp    $0x1b,%rsi
    3a76:	76 9b                	jbe    3a13 <ayatsuri_model_instance_stats+0x53>
    3a78:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    3a7f:	00 
    3a80:	8b 72 08             	mov    0x8(%rdx),%esi
    3a83:	48 85 f6             	test   %rsi,%rsi
    3a86:	74 28                	je     3ab0 <ayatsuri_model_instance_stats+0xf0>
    3a88:	48 8b 12             	mov    (%rdx),%rdx
    3a8b:	48 39 ca             	cmp    %rcx,%rdx
    3a8e:	0f 82 8c 00 00 00    	jb     3b20 <ayatsuri_model_instance_stats+0x160>
    3a94:	48 29 ca             	sub    %rcx,%rdx
    3a97:	bf 01 00 00 00       	mov    $0x1,%edi
    3a9c:	48 83 fa 1b          	cmp    $0x1b,%rdx
    3aa0:	0f 86 6d ff ff ff    	jbe    3a13 <ayatsuri_model_instance_stats+0x53>
    3aa6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    3aad:	00 00 00 
    3ab0:	f3 0f 6f 80 88 00 00 	movdqu 0x88(%rax),%xmm0
    3ab7:	00 
    3ab8:	31 ff                	xor    %edi,%edi
    3aba:	0f 11 01             	movups %xmm0,(%rcx)
    3abd:	f3 0f 6f 80 94 00 00 	movdqu 0x94(%rax),%xmm0
    3ac4:	00 
    3ac5:	0f 11 41 0c          	movups %xmm0,0xc(%rcx)
    3ac9:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    3ad0:	e9 3e ff ff ff       	jmp    3a13 <ayatsuri_model_instance_stats+0x53>
    3ad5:	0f 1f 00             	nopl   (%rax)
    3ad8:	48 89 d6             	mov    %rdx,%rsi
    3adb:	bf 01 00 00 00       	mov    $0x1,%edi
    3ae0:	48 29 ce             	sub    %rcx,%rsi
    3ae3:	48 83 fe 1b          	cmp    $0x1b,%rsi
    3ae7:	0f 86 26 ff ff ff    	jbe    3a13 <ayatsuri_model_instance_stats+0x53>
    3aed:	e9 5f ff ff ff       	jmp    3a51 <ayatsuri_model_instance_stats+0x91>
    3af2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3af8:	bf 01 00 00 00       	mov    $0x1,%edi
    3afd:	89 f8                	mov    %edi,%eax
    3aff:	c3                   	ret
    3b00:	49 89 c8             	mov    %rcx,%r8
    3b03:	49 29 f8             	sub    %rdi,%r8
    3b06:	bf 01 00 00 00       	mov    $0x1,%edi
    3b0b:	49 39 f0             	cmp    %rsi,%r8
    3b0e:	0f 82 ff fe ff ff    	jb     3a13 <ayatsuri_model_instance_stats+0x53>
    3b14:	e9 67 ff ff ff       	jmp    3a80 <ayatsuri_model_instance_stats+0xc0>
    3b19:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3b20:	49 89 c8             	mov    %rcx,%r8
    3b23:	bf 01 00 00 00       	mov    $0x1,%edi
    3b28:	49 29 d0             	sub    %rdx,%r8
    3b2b:	49 39 f0             	cmp    %rsi,%r8
    3b2e:	0f 82 df fe ff ff    	jb     3a13 <ayatsuri_model_instance_stats+0x53>
    3b34:	e9 77 ff ff ff       	jmp    3ab0 <ayatsuri_model_instance_stats+0xf0>
    3b39:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000003b40 <ayatsuri_model_instance_evaluate>:
    3b40:	48 85 ff             	test   %rdi,%rdi
    3b43:	0f 84 7f 01 00 00    	je     3cc8 <ayatsuri_model_instance_evaluate+0x188>
    3b49:	41 57                	push   %r15
    3b4b:	b8 03 00 00 00       	mov    $0x3,%eax
    3b50:	49 89 ff             	mov    %rdi,%r15
    3b53:	41 56                	push   %r14
    3b55:	41 55                	push   %r13
    3b57:	41 54                	push   %r12
    3b59:	55                   	push   %rbp
    3b5a:	53                   	push   %rbx
    3b5b:	48 81 ec 48 04 00 00 	sub    $0x448,%rsp
    3b62:	80 bf a4 00 00 00 01 	cmpb   $0x1,0xa4(%rdi)
    3b69:	0f 85 20 01 00 00    	jne    3c8f <ayatsuri_model_instance_evaluate+0x14f>
    3b6f:	48 85 f6             	test   %rsi,%rsi
    3b72:	0f 84 17 01 00 00    	je     3c8f <ayatsuri_model_instance_evaluate+0x14f>
    3b78:	48 3b 77 10          	cmp    0x10(%rdi),%rsi
    3b7c:	0f 85 0d 01 00 00    	jne    3c8f <ayatsuri_model_instance_evaluate+0x14f>
    3b82:	3b 57 20             	cmp    0x20(%rdi),%edx
    3b85:	0f 85 04 01 00 00    	jne    3c8f <ayatsuri_model_instance_evaluate+0x14f>
    3b8b:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    3b92:	b8 04 00 00 00       	mov    $0x4,%eax
    3b97:	0f 85 f2 00 00 00    	jne    3c8f <ayatsuri_model_instance_evaluate+0x14f>
    3b9d:	8b 87 88 00 00 00    	mov    0x88(%rdi),%eax
    3ba3:	31 d2                	xor    %edx,%edx
    3ba5:	c6 87 a5 00 00 00 01 	movb   $0x1,0xa5(%rdi)
    3bac:	83 f8 ff             	cmp    $0xffffffff,%eax
    3baf:	0f 95 c2             	setne  %dl
    3bb2:	01 d0                	add    %edx,%eax
    3bb4:	89 87 88 00 00 00    	mov    %eax,0x88(%rdi)
    3bba:	48 85 c9             	test   %rcx,%rcx
    3bbd:	0f 84 bd 00 00 00    	je     3c80 <ayatsuri_model_instance_evaluate+0x140>
    3bc3:	4d 85 c0             	test   %r8,%r8
    3bc6:	0f 84 b4 00 00 00    	je     3c80 <ayatsuri_model_instance_evaluate+0x140>
    3bcc:	44 0f b6 8f a6 00 00 	movzbl 0xa6(%rdi),%r9d
    3bd3:	00 
    3bd4:	31 c0                	xor    %eax,%eax
    3bd6:	31 ff                	xor    %edi,%edi
    3bd8:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 3be1 <ayatsuri_model_instance_evaluate+0xa1>
    3bdf:	00 00 
			3bdd: R_X86_64_PC32	.LC1-0x4
    3be1:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 3bea <ayatsuri_model_instance_evaluate+0xaa>
    3be8:	00 00 
			3be6: R_X86_64_PC32	.LC0-0x4
    3bea:	44 89 ce             	mov    %r9d,%esi
    3bed:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    3bf4:	00 00 00 00 
    3bf8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    3bff:	00 
    3c00:	f3 0f 10 04 01       	movss  (%rcx,%rax,1),%xmm0
    3c05:	0f 28 c8             	movaps %xmm0,%xmm1
    3c08:	41 0f 54 ca          	andps  %xmm10,%xmm1
    3c0c:	44 0f 2e f1          	ucomiss %xmm1,%xmm14
    3c10:	72 6e                	jb     3c80 <ayatsuri_model_instance_evaluate+0x140>
    3c12:	41 0f 2e 44 07 28    	ucomiss 0x28(%r15,%rax,1),%xmm0
    3c18:	0f 9b c2             	setnp  %dl
    3c1b:	0f 45 d7             	cmovne %edi,%edx
    3c1e:	48 83 c0 04          	add    $0x4,%rax
    3c22:	21 d6                	and    %edx,%esi
    3c24:	48 83 f8 24          	cmp    $0x24,%rax
    3c28:	75 d6                	jne    3c00 <ayatsuri_model_instance_evaluate+0xc0>
    3c2a:	31 c0                	xor    %eax,%eax
    3c2c:	f3 41 0f 10 0c 80    	movss  (%r8,%rax,4),%xmm1
    3c32:	0f 28 c1             	movaps %xmm1,%xmm0
    3c35:	41 0f 54 c2          	andps  %xmm10,%xmm0
    3c39:	44 0f 2e f0          	ucomiss %xmm0,%xmm14
    3c3d:	72 41                	jb     3c80 <ayatsuri_model_instance_evaluate+0x140>
    3c3f:	48 83 f8 02          	cmp    $0x2,%rax
    3c43:	76 63                	jbe    3ca8 <ayatsuri_model_instance_evaluate+0x168>
    3c45:	66 0f ef c0          	pxor   %xmm0,%xmm0
    3c49:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 3c51 <ayatsuri_model_instance_evaluate+0x111>
    3c50:	00 
			3c4d: R_X86_64_PC32	.LC22-0x4
    3c51:	f3 0f 5a c1          	cvtss2sd %xmm1,%xmm0
    3c55:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 3c5d <ayatsuri_model_instance_evaluate+0x11d>
    3c5c:	00 
			3c59: R_X86_64_PC32	.LC8-0x4
    3c5d:	66 0f 2e f8          	ucomisd %xmm0,%xmm7
    3c61:	72 1d                	jb     3c80 <ayatsuri_model_instance_evaluate+0x140>
    3c63:	66 0f ef c0          	pxor   %xmm0,%xmm0
    3c67:	0f 2f c8             	comiss %xmm0,%xmm1
    3c6a:	72 14                	jb     3c80 <ayatsuri_model_instance_evaluate+0x140>
    3c6c:	f3 0f 10 3d 00 00 00 	movss  0x0(%rip),%xmm7        # 3c74 <ayatsuri_model_instance_evaluate+0x134>
    3c73:	00 
			3c70: R_X86_64_PC32	.LC17-0x4
    3c74:	0f 2f f9             	comiss %xmm1,%xmm7
    3c77:	73 57                	jae    3cd0 <ayatsuri_model_instance_evaluate+0x190>
    3c79:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3c80:	31 d2                	xor    %edx,%edx
    3c82:	66 41 89 97 a5 00 00 	mov    %dx,0xa5(%r15)
    3c89:	00 
    3c8a:	b8 01 00 00 00       	mov    $0x1,%eax
    3c8f:	48 81 c4 48 04 00 00 	add    $0x448,%rsp
    3c96:	5b                   	pop    %rbx
    3c97:	5d                   	pop    %rbp
    3c98:	41 5c                	pop    %r12
    3c9a:	41 5d                	pop    %r13
    3c9c:	41 5e                	pop    %r14
    3c9e:	41 5f                	pop    %r15
    3ca0:	c3                   	ret
    3ca1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3ca8:	41 0f 2e 4c 87 4c    	ucomiss 0x4c(%r15,%rax,4),%xmm1
    3cae:	bf 00 00 00 00       	mov    $0x0,%edi
    3cb3:	0f 9b c2             	setnp  %dl
    3cb6:	0f 45 d7             	cmovne %edi,%edx
    3cb9:	48 83 c0 01          	add    $0x1,%rax
    3cbd:	21 d6                	and    %edx,%esi
    3cbf:	e9 68 ff ff ff       	jmp    3c2c <ayatsuri_model_instance_evaluate+0xec>
    3cc4:	0f 1f 40 00          	nopl   0x0(%rax)
    3cc8:	b8 03 00 00 00       	mov    $0x3,%eax
    3ccd:	c3                   	ret
    3cce:	66 90                	xchg   %ax,%ax
    3cd0:	41 0f 2e 4c 87 4c    	ucomiss 0x4c(%r15,%rax,4),%xmm1
    3cd6:	bf 00 00 00 00       	mov    $0x0,%edi
    3cdb:	0f 9b c2             	setnp  %dl
    3cde:	0f 45 d7             	cmovne %edi,%edx
    3ce1:	48 83 c0 01          	add    $0x1,%rax
    3ce5:	21 d6                	and    %edx,%esi
    3ce7:	48 83 f8 06          	cmp    $0x6,%rax
    3ceb:	0f 85 3b ff ff ff    	jne    3c2c <ayatsuri_model_instance_evaluate+0xec>
    3cf1:	f3 0f 10 49 18       	movss  0x18(%rcx),%xmm1
    3cf6:	0f 2f c8             	comiss %xmm0,%xmm1
    3cf9:	76 85                	jbe    3c80 <ayatsuri_model_instance_evaluate+0x140>
    3cfb:	40 84 f6             	test   %sil,%sil
    3cfe:	0f 85 c2 1a 00 00    	jne    57c6 <ayatsuri_model_instance_evaluate+0x1c86>
    3d04:	49 8d 77 28          	lea    0x28(%r15),%rsi
    3d08:	45 84 c9             	test   %r9b,%r9b
    3d0b:	74 18                	je     3d25 <ayatsuri_model_instance_evaluate+0x1e5>
    3d0d:	48 8b 01             	mov    (%rcx),%rax
    3d10:	48 8b 51 08          	mov    0x8(%rcx),%rdx
    3d14:	49 33 47 28          	xor    0x28(%r15),%rax
    3d18:	49 33 57 30          	xor    0x30(%r15),%rdx
    3d1c:	48 09 d0             	or     %rdx,%rax
    3d1f:	0f 84 1b 1e 00 00    	je     5b40 <ayatsuri_model_instance_evaluate+0x2000>
    3d25:	41 c6 87 a6 00 00 00 	movb   $0x0,0xa6(%r15)
    3d2c:	00 
    3d2d:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
    3d31:	66 0f ef c9          	pxor   %xmm1,%xmm1
    3d35:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
    3d3a:	41 0f 11 47 28       	movups %xmm0,0x28(%r15)
    3d3f:	f3 0f 6f 41 10       	movdqu 0x10(%rcx),%xmm0
    3d44:	0f 11 46 10          	movups %xmm0,0x10(%rsi)
    3d48:	8b 41 20             	mov    0x20(%rcx),%eax
    3d4b:	89 46 20             	mov    %eax,0x20(%rsi)
    3d4e:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
    3d53:	41 0f 11 47 4c       	movups %xmm0,0x4c(%r15)
    3d58:	49 8b 40 10          	mov    0x10(%r8),%rax
    3d5c:	49 89 47 5c          	mov    %rax,0x5c(%r15)
    3d60:	0f 5a 41 0c          	cvtps2pd 0xc(%rcx),%xmm0
    3d64:	0f 5a 11             	cvtps2pd (%rcx),%xmm2
    3d67:	66 0f 5c d0          	subpd  %xmm0,%xmm2
    3d6b:	66 0f ef c0          	pxor   %xmm0,%xmm0
    3d6f:	f3 0f 5a 41 14       	cvtss2sd 0x14(%rcx),%xmm0
    3d74:	f3 0f 5a 49 08       	cvtss2sd 0x8(%rcx),%xmm1
    3d79:	f2 0f 5c c8          	subsd  %xmm0,%xmm1
    3d7d:	66 0f 28 fa          	movapd %xmm2,%xmm7
    3d81:	66 0f 15 ff          	unpckhpd %xmm7,%xmm7
    3d85:	66 0f 28 c2          	movapd %xmm2,%xmm0
    3d89:	0f 29 14 24          	movaps %xmm2,(%rsp)
    3d8d:	66 48 0f 7e cb       	movq   %xmm1,%rbx
    3d92:	66 0f 28 cf          	movapd %xmm7,%xmm1
    3d96:	e8 00 00 00 00       	call   3d9b <ayatsuri_model_instance_evaluate+0x25b>
			3d97: R_X86_64_PLT32	hypot-0x4
    3d9b:	66 48 0f 6e cb       	movq   %rbx,%xmm1
    3da0:	e8 00 00 00 00       	call   3da5 <ayatsuri_model_instance_evaluate+0x265>
			3da1: R_X86_64_PLT32	hypot-0x4
    3da5:	66 0f ef c9          	pxor   %xmm1,%xmm1
    3da9:	66 0f 28 14 24       	movapd (%rsp),%xmm2
    3dae:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
    3db3:	66 0f 2f c1          	comisd %xmm1,%xmm0
    3db7:	0f 86 fc 19 00 00    	jbe    57b9 <ayatsuri_model_instance_evaluate+0x1c79>
    3dbd:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 3dc5 <ayatsuri_model_instance_evaluate+0x285>
    3dc4:	00 
			3dc1: R_X86_64_PC32	.LC22-0x4
    3dc5:	66 0f 2e f0          	ucomisd %xmm0,%xmm6
    3dc9:	0f 82 ea 19 00 00    	jb     57b9 <ayatsuri_model_instance_evaluate+0x1c79>
    3dcf:	66 0f 28 c8          	movapd %xmm0,%xmm1
    3dd3:	66 48 0f 6e db       	movq   %rbx,%xmm3
    3dd8:	4c 89 44 24 38       	mov    %r8,0x38(%rsp)
    3ddd:	f2 0f 5e d8          	divsd  %xmm0,%xmm3
    3de1:	66 0f 14 c9          	unpcklpd %xmm1,%xmm1
    3de5:	66 0f 5e d1          	divpd  %xmm1,%xmm2
    3de9:	66 0f 28 c3          	movapd %xmm3,%xmm0
    3ded:	f2 0f 11 1c 24       	movsd  %xmm3,(%rsp)
    3df2:	66 0f 28 ea          	movapd %xmm2,%xmm5
    3df6:	66 0f 28 ca          	movapd %xmm2,%xmm1
    3dfa:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
    3dff:	66 0f 15 ed          	unpckhpd %xmm5,%xmm5
    3e03:	f2 0f 11 54 24 18    	movsd  %xmm2,0x18(%rsp)
    3e09:	f2 0f 11 6c 24 30    	movsd  %xmm5,0x30(%rsp)
    3e0f:	e8 00 00 00 00       	call   3e14 <ayatsuri_model_instance_evaluate+0x2d4>
			3e10: R_X86_64_PLT32	hypot-0x4
    3e14:	f2 0f 10 1c 24       	movsd  (%rsp),%xmm3
    3e19:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
    3e1e:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 3e27 <ayatsuri_model_instance_evaluate+0x2e7>
    3e25:	00 00 
			3e23: R_X86_64_PC32	.LC0-0x4
    3e27:	f2 0f 10 15 00 00 00 	movsd  0x0(%rip),%xmm2        # 3e2f <ayatsuri_model_instance_evaluate+0x2ef>
    3e2e:	00 
			3e2b: R_X86_64_PC32	.LC37-0x4
    3e2f:	f2 0f 10 4c 24 18    	movsd  0x18(%rsp),%xmm1
    3e35:	66 0f 28 64 24 20    	movapd 0x20(%rsp),%xmm4
    3e3b:	f2 0f 10 6c 24 30    	movsd  0x30(%rsp),%xmm5
    3e41:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 3e4a <ayatsuri_model_instance_evaluate+0x30a>
    3e48:	00 00 
			3e46: R_X86_64_PC32	.LC1-0x4
    3e4a:	66 0f 2f d0          	comisd %xmm0,%xmm2
    3e4e:	0f 87 3b 1e 00 00    	ja     5c8f <ayatsuri_model_instance_evaluate+0x214f>
    3e54:	66 0f 28 f3          	movapd %xmm3,%xmm6
    3e58:	f3 0f 7e 3d 00 00 00 	movq   0x0(%rip),%xmm7        # 3e60 <ayatsuri_model_instance_evaluate+0x320>
    3e5f:	00 
			3e5c: R_X86_64_PC32	.LC26-0x4
    3e60:	66 44 0f 28 c3       	movapd %xmm3,%xmm8
    3e65:	66 0f ef d2          	pxor   %xmm2,%xmm2
    3e69:	f2 0f 5e f0          	divsd  %xmm0,%xmm6
    3e6d:	0f 29 bc 24 80 00 00 	movaps %xmm7,0x80(%rsp)
    3e74:	00 
    3e75:	66 0f 57 f9          	xorpd  %xmm1,%xmm7
    3e79:	f2 0f 5e f8          	divsd  %xmm0,%xmm7
    3e7d:	66 0f ef c0          	pxor   %xmm0,%xmm0
    3e81:	f2 44 0f 59 c6       	mulsd  %xmm6,%xmm8
    3e86:	f2 0f 5a d6          	cvtsd2ss %xmm6,%xmm2
    3e8a:	f2 0f 5a c7          	cvtsd2ss %xmm7,%xmm0
    3e8e:	f2 0f 59 cf          	mulsd  %xmm7,%xmm1
    3e92:	66 0f 5a e4          	cvtpd2ps %xmm4,%xmm4
    3e96:	49 8b 07             	mov    (%r15),%rax
    3e99:	f2 0f 5a db          	cvtsd2ss %xmm3,%xmm3
    3e9d:	f3 0f 11 84 24 ec 01 	movss  %xmm0,0x1ec(%rsp)
    3ea4:	00 00 
    3ea6:	66 0f 28 c5          	movapd %xmm5,%xmm0
    3eaa:	66 0f 57 ac 24 80 00 	xorpd  0x80(%rsp),%xmm5
    3eb1:	00 00 
    3eb3:	f2 0f 59 c7          	mulsd  %xmm7,%xmm0
    3eb7:	66 83 78 0c 00       	cmpw   $0x0,0xc(%rax)
    3ebc:	0f 13 a4 24 c8 01 00 	movlps %xmm4,0x1c8(%rsp)
    3ec3:	00 
    3ec4:	c7 84 24 e8 01 00 00 	movl   $0x0,0x1e8(%rsp)
    3ecb:	00 00 00 00 
    3ecf:	f3 0f 11 9c 24 d0 01 	movss  %xmm3,0x1d0(%rsp)
    3ed6:	00 00 
    3ed8:	f3 0f 11 94 24 e4 01 	movss  %xmm2,0x1e4(%rsp)
    3edf:	00 00 
    3ee1:	f2 44 0f 5c c1       	subsd  %xmm1,%xmm8
    3ee6:	66 41 0f 14 c0       	unpcklpd %xmm8,%xmm0
    3eeb:	66 0f 5a c0          	cvtpd2ps %xmm0,%xmm0
    3eef:	0f 13 84 24 d8 01 00 	movlps %xmm0,0x1d8(%rsp)
    3ef6:	00 
    3ef7:	66 0f 28 c5          	movapd %xmm5,%xmm0
    3efb:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
    3eff:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    3f03:	f3 0f 11 84 24 e0 01 	movss  %xmm0,0x1e0(%rsp)
    3f0a:	00 00 
    3f0c:	f3 41 0f 10 00       	movss  (%r8),%xmm0
    3f11:	f3 41 0f 11 67 70    	movss  %xmm4,0x70(%r15)
    3f17:	0f c6 e4 e5          	shufps $0xe5,%xmm4,%xmm4
    3f1b:	f3 41 0f 11 47 64    	movss  %xmm0,0x64(%r15)
    3f21:	f3 41 0f 10 40 0c    	movss  0xc(%r8),%xmm0
    3f27:	f3 41 0f 11 47 7c    	movss  %xmm0,0x7c(%r15)
    3f2d:	f3 41 0f 10 40 04    	movss  0x4(%r8),%xmm0
    3f33:	f3 41 0f 11 67 74    	movss  %xmm4,0x74(%r15)
    3f39:	f3 41 0f 11 47 68    	movss  %xmm0,0x68(%r15)
    3f3f:	f3 41 0f 10 40 10    	movss  0x10(%r8),%xmm0
    3f45:	f3 41 0f 11 87 80 00 	movss  %xmm0,0x80(%r15)
    3f4c:	00 00 
    3f4e:	f3 41 0f 10 40 08    	movss  0x8(%r8),%xmm0
    3f54:	f3 41 0f 11 5f 78    	movss  %xmm3,0x78(%r15)
    3f5a:	f3 41 0f 11 47 6c    	movss  %xmm0,0x6c(%r15)
    3f60:	f3 41 0f 10 40 14    	movss  0x14(%r8),%xmm0
    3f66:	f3 41 0f 11 87 84 00 	movss  %xmm0,0x84(%r15)
    3f6d:	00 00 
    3f6f:	0f 84 1d 06 00 00    	je     4592 <ayatsuri_model_instance_evaluate+0xa52>
    3f75:	48 8d 8c 24 d8 01 00 	lea    0x1d8(%rsp),%rcx
    3f7c:	00 
    3f7d:	48 8d 9c 24 e4 01 00 	lea    0x1e4(%rsp),%rbx
    3f84:	00 
    3f85:	45 31 ed             	xor    %r13d,%r13d
    3f88:	48 89 8c 24 78 01 00 	mov    %rcx,0x178(%rsp)
    3f8f:	00 
    3f90:	66 48 0f 6e fb       	movq   %rbx,%xmm7
    3f95:	4d 89 ea             	mov    %r13,%r10
    3f98:	4c 8d b4 24 50 02 00 	lea    0x250(%rsp),%r14
    3f9f:	00 
    3fa0:	48 89 9c 24 80 01 00 	mov    %rbx,0x180(%rsp)
    3fa7:	00 
    3fa8:	48 8d 9c 24 5c 02 00 	lea    0x25c(%rsp),%rbx
    3faf:	00 
    3fb0:	4d 89 f3             	mov    %r14,%r11
    3fb3:	48 89 5c 24 78       	mov    %rbx,0x78(%rsp)
    3fb8:	0f 16 bc 24 78 01 00 	movhps 0x178(%rsp),%xmm7
    3fbf:	00 
    3fc0:	0f 29 bc 24 a0 01 00 	movaps %xmm7,0x1a0(%rsp)
    3fc7:	00 
    3fc8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    3fcf:	00 
    3fd0:	44 8b 60 14          	mov    0x14(%rax),%r12d
    3fd4:	49 8b 6f 08          	mov    0x8(%r15),%rbp
    3fd8:	4c 89 d1             	mov    %r10,%rcx
    3fdb:	4f 8d 04 52          	lea    (%r10,%r10,2),%r8
    3fdf:	48 c1 e1 04          	shl    $0x4,%rcx
    3fe3:	4a 8d 14 c5 00 00 00 	lea    0x0(,%r8,8),%rdx
    3fea:	00 
    3feb:	44 89 54 24 18       	mov    %r10d,0x18(%rsp)
    3ff0:	49 01 cc             	add    %rcx,%r12
    3ff3:	4c 03 20             	add    (%rax),%r12
    3ff6:	48 8d 44 15 00       	lea    0x0(%rbp,%rdx,1),%rax
    3ffb:	8b 78 08             	mov    0x8(%rax),%edi
    3ffe:	41 0f b7 34 24       	movzwl (%r12),%esi
    4003:	48 8d 7c 3d 30       	lea    0x30(%rbp,%rdi,1),%rdi
    4008:	66 85 f6             	test   %si,%si
    400b:	0f 88 9f 05 00 00    	js     45b0 <ayatsuri_model_instance_evaluate+0xa70>
    4011:	f3 0f 6f 07          	movdqu (%rdi),%xmm0
    4015:	44 0f b7 ce          	movzwl %si,%r9d
    4019:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
    401d:	48 8d 9c 24 80 02 00 	lea    0x280(%rsp),%rbx
    4024:	00 
    4025:	8b 74 f5 08          	mov    0x8(%rbp,%rsi,8),%esi
    4029:	41 0f 29 03          	movaps %xmm0,(%r11)
    402d:	f3 0f 6f 47 10       	movdqu 0x10(%rdi),%xmm0
    4032:	48 01 ee             	add    %rbp,%rsi
    4035:	41 0f 29 43 10       	movaps %xmm0,0x10(%r11)
    403a:	f3 0f 6f 06          	movdqu (%rsi),%xmm0
    403e:	8b 7f 20             	mov    0x20(%rdi),%edi
    4041:	0f 29 84 24 80 02 00 	movaps %xmm0,0x280(%rsp)
    4048:	00 
    4049:	f3 0f 6f 46 10       	movdqu 0x10(%rsi),%xmm0
    404e:	41 89 7b 20          	mov    %edi,0x20(%r11)
    4052:	0f 29 84 24 90 02 00 	movaps %xmm0,0x290(%rsp)
    4059:	00 
    405a:	f3 0f 6f 46 20       	movdqu 0x20(%rsi),%xmm0
    405f:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
    4066:	00 
    4067:	48 8b 7c 24 78       	mov    0x78(%rsp),%rdi
    406c:	4c 89 de             	mov    %r11,%rsi
    406f:	66 0f ef d2          	pxor   %xmm2,%xmm2
    4073:	f3 0f 10 06          	movss  (%rsi),%xmm0
    4077:	41 0f 54 c2          	andps  %xmm10,%xmm0
    407b:	44 0f 2e f0          	ucomiss %xmm0,%xmm14
    407f:	0f 82 9b 16 00 00    	jb     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    4085:	f3 0f 10 46 0c       	movss  0xc(%rsi),%xmm0
    408a:	41 0f 54 c2          	andps  %xmm10,%xmm0
    408e:	44 0f 2e f0          	ucomiss %xmm0,%xmm14
    4092:	0f 82 88 16 00 00    	jb     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    4098:	f3 0f 10 46 18       	movss  0x18(%rsi),%xmm0
    409d:	0f 28 c8             	movaps %xmm0,%xmm1
    40a0:	41 0f 54 ca          	andps  %xmm10,%xmm1
    40a4:	44 0f 2e f1          	ucomiss %xmm1,%xmm14
    40a8:	0f 82 72 16 00 00    	jb     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    40ae:	0f 2e c2             	ucomiss %xmm2,%xmm0
    40b1:	7a 06                	jp     40b9 <ayatsuri_model_instance_evaluate+0x579>
    40b3:	0f 84 67 16 00 00    	je     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    40b9:	48 83 c6 04          	add    $0x4,%rsi
    40bd:	48 39 f7             	cmp    %rsi,%rdi
    40c0:	75 b1                	jne    4073 <ayatsuri_model_instance_evaluate+0x533>
    40c2:	48 85 db             	test   %rbx,%rbx
    40c5:	74 34                	je     40fb <ayatsuri_model_instance_evaluate+0x5bb>
    40c7:	48 89 de             	mov    %rbx,%rsi
    40ca:	48 8d 7b 30          	lea    0x30(%rbx),%rdi
    40ce:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    40d5:	00 00 00 00 
    40d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    40e0:	f3 0f 10 06          	movss  (%rsi),%xmm0
    40e4:	41 0f 54 c2          	andps  %xmm10,%xmm0
    40e8:	44 0f 2e f0          	ucomiss %xmm0,%xmm14
    40ec:	0f 82 2e 16 00 00    	jb     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    40f2:	48 83 c6 04          	add    $0x4,%rsi
    40f6:	48 39 f7             	cmp    %rsi,%rdi
    40f9:	75 e5                	jne    40e0 <ayatsuri_model_instance_evaluate+0x5a0>
    40fb:	4c 8d ac 24 b8 01 00 	lea    0x1b8(%rsp),%r13
    4102:	00 
    4103:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4107:	4c 89 5c 24 70       	mov    %r11,0x70(%rsp)
    410c:	4c 8d b4 24 b0 01 00 	lea    0x1b0(%rsp),%r14
    4113:	00 
    4114:	4c 89 f6             	mov    %r14,%rsi
    4117:	4c 89 ef             	mov    %r13,%rdi
    411a:	4c 89 54 24 68       	mov    %r10,0x68(%rsp)
    411f:	f3 0f 5a 84 24 5c 02 	cvtss2sd 0x25c(%rsp),%xmm0
    4126:	00 00 
    4128:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
    412d:	4c 89 44 24 58       	mov    %r8,0x58(%rsp)
    4132:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
    4137:	44 89 4c 24 48       	mov    %r9d,0x48(%rsp)
    413c:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
    4141:	e8 00 00 00 00       	call   4146 <ayatsuri_model_instance_evaluate+0x606>
			4142: R_X86_64_PLT32	sincos-0x4
    4146:	4c 89 f6             	mov    %r14,%rsi
    4149:	4c 89 ef             	mov    %r13,%rdi
    414c:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4150:	f2 0f 10 94 24 b0 01 	movsd  0x1b0(%rsp),%xmm2
    4157:	00 00 
    4159:	f2 44 0f 10 8c 24 b8 	movsd  0x1b8(%rsp),%xmm9
    4160:	01 00 00 
    4163:	f3 0f 5a 84 24 60 02 	cvtss2sd 0x260(%rsp),%xmm0
    416a:	00 00 
    416c:	f2 0f 11 54 24 38    	movsd  %xmm2,0x38(%rsp)
    4172:	f2 44 0f 11 4c 24 30 	movsd  %xmm9,0x30(%rsp)
    4179:	e8 00 00 00 00       	call   417e <ayatsuri_model_instance_evaluate+0x63e>
			417a: R_X86_64_PLT32	sincos-0x4
    417e:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4182:	4c 89 f6             	mov    %r14,%rsi
    4185:	4c 89 ef             	mov    %r13,%rdi
    4188:	f2 0f 10 bc 24 b0 01 	movsd  0x1b0(%rsp),%xmm7
    418f:	00 00 
    4191:	f2 0f 10 a4 24 b8 01 	movsd  0x1b8(%rsp),%xmm4
    4198:	00 00 
    419a:	f3 0f 5a 84 24 64 02 	cvtss2sd 0x264(%rsp),%xmm0
    41a1:	00 00 
    41a3:	f2 0f 11 7c 24 20    	movsd  %xmm7,0x20(%rsp)
    41a9:	f2 0f 11 24 24       	movsd  %xmm4,(%rsp)
    41ae:	e8 00 00 00 00       	call   41b3 <ayatsuri_model_instance_evaluate+0x673>
			41af: R_X86_64_PLT32	sincos-0x4
    41b3:	f2 0f 10 24 24       	movsd  (%rsp),%xmm4
    41b8:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    41bd:	f2 0f 10 84 24 b0 01 	movsd  0x1b0(%rsp),%xmm0
    41c4:	00 00 
    41c6:	f2 44 0f 10 4c 24 30 	movsd  0x30(%rsp),%xmm9
    41cd:	f2 0f 10 54 24 38    	movsd  0x38(%rsp),%xmm2
    41d3:	48 85 db             	test   %rbx,%rbx
    41d6:	44 0f 5a 9c 24 68 02 	cvtps2pd 0x268(%rsp),%xmm11
    41dd:	00 00 
    41df:	66 0f 28 dc          	movapd %xmm4,%xmm3
    41e3:	f2 0f 10 7c 24 20    	movsd  0x20(%rsp),%xmm7
    41e9:	f2 0f 10 8c 24 b8 01 	movsd  0x1b8(%rsp),%xmm1
    41f0:	00 00 
    41f2:	f3 44 0f 5a a4 24 68 	cvtss2sd 0x268(%rsp),%xmm12
    41f9:	02 00 00 
    41fc:	f2 0f 59 d8          	mulsd  %xmm0,%xmm3
    4200:	66 41 0f 28 f1       	movapd %xmm9,%xmm6
    4205:	66 44 0f 28 c2       	movapd %xmm2,%xmm8
    420a:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
    420f:	f2 44 0f 59 c1       	mulsd  %xmm1,%xmm8
    4214:	66 0f 28 ef          	movapd %xmm7,%xmm5
    4218:	66 45 0f 28 e9       	movapd %xmm9,%xmm13
    421d:	4c 63 4c 24 48       	movslq 0x48(%rsp),%r9
    4222:	f2 0f 59 e8          	mulsd  %xmm0,%xmm5
    4226:	66 44 0f 28 fa       	movapd %xmm2,%xmm15
    422b:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
    4230:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
    4235:	f2 44 0f 59 f8       	mulsd  %xmm0,%xmm15
    423a:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
    423f:	4c 8b 54 24 68       	mov    0x68(%rsp),%r10
    4244:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 424d <ayatsuri_model_instance_evaluate+0x70d>
    424b:	00 00 
			4249: R_X86_64_PC32	.LC0-0x4
    424d:	f2 41 0f 59 c1       	mulsd  %xmm9,%xmm0
    4252:	4c 8b 5c 24 70       	mov    0x70(%rsp),%r11
    4257:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 4260 <ayatsuri_model_instance_evaluate+0x720>
    425e:	00 00 
			425c: R_X86_64_PC32	.LC1-0x4
    4260:	f2 0f 59 f3          	mulsd  %xmm3,%xmm6
    4264:	f2 0f 59 da          	mulsd  %xmm2,%xmm3
    4268:	f2 41 0f 59 ec       	mulsd  %xmm12,%xmm5
    426d:	f2 41 0f 5c f0       	subsd  %xmm8,%xmm6
    4272:	66 45 0f 28 c3       	movapd %xmm11,%xmm8
    4277:	66 45 0f 15 c0       	unpckhpd %xmm8,%xmm8
    427c:	f2 41 0f 59 f0       	mulsd  %xmm8,%xmm6
    4281:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    4286:	f3 44 0f 5a 84 24 70 	cvtss2sd 0x270(%rsp),%xmm8
    428d:	02 00 00 
    4290:	66 0f 14 ee          	unpcklpd %xmm6,%xmm5
    4294:	66 41 0f 28 f1       	movapd %xmm9,%xmm6
    4299:	f2 0f 59 f1          	mulsd  %xmm1,%xmm6
    429d:	f2 0f 58 de          	addsd  %xmm6,%xmm3
    42a1:	66 0f 28 f7          	movapd %xmm7,%xmm6
    42a5:	f2 0f 59 f1          	mulsd  %xmm1,%xmm6
    42a9:	f2 0f 59 cc          	mulsd  %xmm4,%xmm1
    42ad:	66 0f 57 a4 24 80 00 	xorpd  0x80(%rsp),%xmm4
    42b4:	00 00 
    42b6:	f2 41 0f 59 d8       	mulsd  %xmm8,%xmm3
    42bb:	f2 44 0f 59 e9       	mulsd  %xmm1,%xmm13
    42c0:	f2 0f 59 ca          	mulsd  %xmm2,%xmm1
    42c4:	f2 0f 59 d7          	mulsd  %xmm7,%xmm2
    42c8:	f2 45 0f 58 ef       	addsd  %xmm15,%xmm13
    42cd:	f2 0f 5c c8          	subsd  %xmm0,%xmm1
    42d1:	66 41 0f 28 c1       	movapd %xmm9,%xmm0
    42d6:	66 45 0f ef c9       	pxor   %xmm9,%xmm9
    42db:	f3 44 0f 5a 8c 24 58 	cvtss2sd 0x258(%rsp),%xmm9
    42e2:	02 00 00 
    42e5:	f2 0f 59 c7          	mulsd  %xmm7,%xmm0
    42e9:	66 0f ef ff          	pxor   %xmm7,%xmm7
    42ed:	f3 0f 5a bc 24 50 02 	cvtss2sd 0x250(%rsp),%xmm7
    42f4:	00 00 
    42f6:	f2 41 0f 59 d0       	mulsd  %xmm8,%xmm2
    42fb:	f2 41 0f 59 c8       	mulsd  %xmm8,%xmm1
    4300:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    4305:	f3 44 0f 5a 84 24 54 	cvtss2sd 0x254(%rsp),%xmm8
    430c:	02 00 00 
    430f:	0f 84 23 14 00 00    	je     5738 <ayatsuri_model_instance_evaluate+0x1bf8>
    4315:	66 41 0f 14 f5       	unpcklpd %xmm13,%xmm6
    431a:	66 0f 14 e0          	unpcklpd %xmm0,%xmm4
    431e:	4c 8d ac 24 90 03 00 	lea    0x390(%rsp),%r13
    4325:	00 
    4326:	66 41 0f 59 f3       	mulpd  %xmm11,%xmm6
    432b:	4c 89 ee             	mov    %r13,%rsi
    432e:	48 8d 7b 30          	lea    0x30(%rbx),%rdi
    4332:	66 41 0f 59 e3       	mulpd  %xmm11,%xmm4
    4337:	66 0f ef c0          	pxor   %xmm0,%xmm0
    433b:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    4340:	48 83 c3 10          	add    $0x10,%rbx
    4344:	48 83 c6 20          	add    $0x20,%rsi
    4348:	f3 0f 5a 43 f0       	cvtss2sd -0x10(%rbx),%xmm0
    434d:	f3 44 0f 5a 63 f4    	cvtss2sd -0xc(%rbx),%xmm12
    4353:	66 44 0f 28 e8       	movapd %xmm0,%xmm13
    4358:	66 45 0f 28 fc       	movapd %xmm12,%xmm15
    435d:	66 45 0f 14 ed       	unpcklpd %xmm13,%xmm13
    4362:	66 45 0f 14 ff       	unpcklpd %xmm15,%xmm15
    4367:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    436c:	66 44 0f 59 fe       	mulpd  %xmm6,%xmm15
    4371:	f3 44 0f 5a 5b f8    	cvtss2sd -0x8(%rbx),%xmm11
    4377:	66 44 0f 59 ed       	mulpd  %xmm5,%xmm13
    437c:	66 45 0f 58 ef       	addpd  %xmm15,%xmm13
    4381:	66 45 0f 28 fb       	movapd %xmm11,%xmm15
    4386:	66 45 0f 14 ff       	unpcklpd %xmm15,%xmm15
    438b:	66 44 0f 59 fc       	mulpd  %xmm4,%xmm15
    4390:	66 45 0f 58 ef       	addpd  %xmm15,%xmm13
    4395:	66 44 0f 28 f9       	movapd %xmm1,%xmm15
    439a:	f2 45 0f 59 fc       	mulsd  %xmm12,%xmm15
    439f:	f2 45 0f 59 e0       	mulsd  %xmm8,%xmm12
    43a4:	44 0f 29 6e e0       	movaps %xmm13,-0x20(%rsi)
    43a9:	66 44 0f 28 eb       	movapd %xmm3,%xmm13
    43ae:	f2 44 0f 59 e8       	mulsd  %xmm0,%xmm13
    43b3:	f2 0f 59 c7          	mulsd  %xmm7,%xmm0
    43b7:	f2 45 0f 58 ef       	addsd  %xmm15,%xmm13
    43bc:	66 44 0f 28 fa       	movapd %xmm2,%xmm15
    43c1:	f2 45 0f 59 fb       	mulsd  %xmm11,%xmm15
    43c6:	f2 41 0f 58 c4       	addsd  %xmm12,%xmm0
    43cb:	f2 45 0f 59 d9       	mulsd  %xmm9,%xmm11
    43d0:	f2 45 0f 58 ef       	addsd  %xmm15,%xmm13
    43d5:	f2 41 0f 58 c3       	addsd  %xmm11,%xmm0
    43da:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    43df:	f3 44 0f 5a 5b fc    	cvtss2sd -0x4(%rbx),%xmm11
    43e5:	f2 44 0f 11 6e f0    	movsd  %xmm13,-0x10(%rsi)
    43eb:	f2 41 0f 58 c3       	addsd  %xmm11,%xmm0
    43f0:	f2 0f 11 46 f8       	movsd  %xmm0,-0x8(%rsi)
    43f5:	48 39 df             	cmp    %rbx,%rdi
    43f8:	0f 85 39 ff ff ff    	jne    4337 <ayatsuri_model_instance_evaluate+0x7f7>
    43fe:	31 f6                	xor    %esi,%esi
    4400:	66 0f ef d2          	pxor   %xmm2,%xmm2
    4404:	eb 33                	jmp    4439 <ayatsuri_model_instance_evaluate+0x8f9>
    4406:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    440d:	00 00 00 
    4410:	66 0f 2f d1          	comisd %xmm1,%xmm2
    4414:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 441c <ayatsuri_model_instance_evaluate+0x8dc>
    441b:	00 
			4418: R_X86_64_PC32	.LC33-0x4
    441c:	77 04                	ja     4422 <ayatsuri_model_instance_evaluate+0x8e2>
    441e:	41 0f 28 c6          	movaps %xmm14,%xmm0
    4422:	48 8d 9c 24 30 03 00 	lea    0x330(%rsp),%rbx
    4429:	00 
    442a:	f3 0f 11 04 b3       	movss  %xmm0,(%rbx,%rsi,4)
    442f:	48 83 c6 01          	add    $0x1,%rsi
    4433:	48 83 fe 0c          	cmp    $0xc,%rsi
    4437:	74 47                	je     4480 <ayatsuri_model_instance_evaluate+0x940>
    4439:	f2 41 0f 10 4c f5 00 	movsd  0x0(%r13,%rsi,8),%xmm1
    4440:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 4448 <ayatsuri_model_instance_evaluate+0x908>
    4447:	00 
			4444: R_X86_64_PC32	.LC22-0x4
    4448:	66 0f 28 c1          	movapd %xmm1,%xmm0
    444c:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 4454 <ayatsuri_model_instance_evaluate+0x914>
    4453:	00 
			4450: R_X86_64_PC32	.LC8-0x4
    4454:	66 0f 2e e8          	ucomisd %xmm0,%xmm5
    4458:	0f 82 c2 12 00 00    	jb     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    445e:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 4466 <ayatsuri_model_instance_evaluate+0x926>
    4465:	00 
			4462: R_X86_64_PC32	.LC38-0x4
    4466:	0f 83 b4 12 00 00    	jae    5720 <ayatsuri_model_instance_evaluate+0x1be0>
    446c:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 4474 <ayatsuri_model_instance_evaluate+0x934>
    4473:	00 
			4470: R_X86_64_PC32	.LC39-0x4
    4474:	77 9a                	ja     4410 <ayatsuri_model_instance_evaluate+0x8d0>
    4476:	66 0f ef c0          	pxor   %xmm0,%xmm0
    447a:	f2 0f 5a c1          	cvtsd2ss %xmm1,%xmm0
    447e:	eb a2                	jmp    4422 <ayatsuri_model_instance_evaluate+0x8e2>
    4480:	66 0f 6f 84 24 30 03 	movdqa 0x330(%rsp),%xmm0
    4487:	00 00 
    4489:	41 8b b7 8c 00 00 00 	mov    0x8c(%r15),%esi
    4490:	31 ff                	xor    %edi,%edi
    4492:	0f 29 84 24 b0 02 00 	movaps %xmm0,0x2b0(%rsp)
    4499:	00 
    449a:	83 fe ff             	cmp    $0xffffffff,%esi
    449d:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
    44a4:	00 00 
    44a6:	40 0f 95 c7          	setne  %dil
    44aa:	0f 29 84 24 c0 02 00 	movaps %xmm0,0x2c0(%rsp)
    44b1:	00 
    44b2:	01 fe                	add    %edi,%esi
    44b4:	66 0f 6f 84 24 50 03 	movdqa 0x350(%rsp),%xmm0
    44bb:	00 00 
    44bd:	41 89 b7 8c 00 00 00 	mov    %esi,0x8c(%r15)
    44c4:	0f 29 84 24 d0 02 00 	movaps %xmm0,0x2d0(%rsp)
    44cb:	00 
    44cc:	8b 40 08             	mov    0x8(%rax),%eax
    44cf:	66 0f 6f 84 24 b0 02 	movdqa 0x2b0(%rsp),%xmm0
    44d6:	00 00 
    44d8:	48 01 c5             	add    %rax,%rbp
    44db:	0f 11 45 00          	movups %xmm0,0x0(%rbp)
    44df:	66 0f 6f 84 24 c0 02 	movdqa 0x2c0(%rsp),%xmm0
    44e6:	00 00 
    44e8:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
    44ec:	66 0f 6f 84 24 d0 02 	movdqa 0x2d0(%rsp),%xmm0
    44f3:	00 00 
    44f5:	0f 11 45 20          	movups %xmm0,0x20(%rbp)
    44f9:	49 8b 47 08          	mov    0x8(%r15),%rax
    44fd:	48 8d 34 10          	lea    (%rax,%rdx,1),%rsi
    4501:	0f b6 7e 10          	movzbl 0x10(%rsi),%edi
    4505:	40 84 ff             	test   %dil,%dil
    4508:	74 17                	je     4521 <ayatsuri_model_instance_evaluate+0x9e1>
    450a:	bf 01 00 00 00       	mov    $0x1,%edi
    450f:	45 85 c9             	test   %r9d,%r9d
    4512:	78 0d                	js     4521 <ayatsuri_model_instance_evaluate+0x9e1>
    4514:	4b 8d 3c 49          	lea    (%r9,%r9,2),%rdi
    4518:	80 7c f8 11 00       	cmpb   $0x0,0x11(%rax,%rdi,8)
    451d:	40 0f 95 c7          	setne  %dil
    4521:	40 88 7e 11          	mov    %dil,0x11(%rsi)
    4525:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    452b:	40 80 ff 01          	cmp    $0x1,%dil
    452f:	0f 84 ab 00 00 00    	je     45e0 <ayatsuri_model_instance_evaluate+0xaa0>
    4535:	40 80 ff 02          	cmp    $0x2,%dil
    4539:	0f 84 01 09 00 00    	je     4e40 <ayatsuri_model_instance_evaluate+0x1300>
    453f:	40 80 ff 03          	cmp    $0x3,%dil
    4543:	0f 84 97 08 00 00    	je     4de0 <ayatsuri_model_instance_evaluate+0x12a0>
    4549:	40 84 ff             	test   %dil,%dil
    454c:	74 30                	je     457e <ayatsuri_model_instance_evaluate+0xa3e>
    454e:	41 8b 87 90 00 00 00 	mov    0x90(%r15),%eax
    4555:	31 d2                	xor    %edx,%edx
    4557:	83 f8 ff             	cmp    $0xffffffff,%eax
    455a:	0f 95 c2             	setne  %dl
    455d:	01 d0                	add    %edx,%eax
    455f:	31 d2                	xor    %edx,%edx
    4561:	41 89 87 90 00 00 00 	mov    %eax,0x90(%r15)
    4568:	41 8b 87 94 00 00 00 	mov    0x94(%r15),%eax
    456f:	83 f8 ff             	cmp    $0xffffffff,%eax
    4572:	0f 95 c2             	setne  %dl
    4575:	01 d0                	add    %edx,%eax
    4577:	41 89 87 94 00 00 00 	mov    %eax,0x94(%r15)
    457e:	49 8b 07             	mov    (%r15),%rax
    4581:	49 83 c2 01          	add    $0x1,%r10
    4585:	0f b7 50 0c          	movzwl 0xc(%rax),%edx
    4589:	41 39 d2             	cmp    %edx,%r10d
    458c:	0f 82 3e fa ff ff    	jb     3fd0 <ayatsuri_model_instance_evaluate+0x490>
    4592:	b8 00 01 00 00       	mov    $0x100,%eax
    4597:	66 41 89 87 a5 00 00 	mov    %ax,0xa5(%r15)
    459e:	00 
    459f:	31 c0                	xor    %eax,%eax
    45a1:	e9 e9 f6 ff ff       	jmp    3c8f <ayatsuri_model_instance_evaluate+0x14f>
    45a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    45ad:	00 00 00 
    45b0:	f3 0f 6f 07          	movdqu (%rdi),%xmm0
    45b4:	41 89 f1             	mov    %esi,%r9d
    45b7:	31 db                	xor    %ebx,%ebx
    45b9:	41 81 c9 00 00 ff ff 	or     $0xffff0000,%r9d
    45c0:	41 0f 29 03          	movaps %xmm0,(%r11)
    45c4:	f3 0f 6f 47 10       	movdqu 0x10(%rdi),%xmm0
    45c9:	41 0f 29 43 10       	movaps %xmm0,0x10(%r11)
    45ce:	8b 77 20             	mov    0x20(%rdi),%esi
    45d1:	41 89 73 20          	mov    %esi,0x20(%r11)
    45d5:	e9 8d fa ff ff       	jmp    4067 <ayatsuri_model_instance_evaluate+0x527>
    45da:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    45e0:	4d 8b 37             	mov    (%r15),%r14
    45e3:	45 8b 4e 14          	mov    0x14(%r14),%r9d
    45e7:	49 8b 3e             	mov    (%r14),%rdi
    45ea:	41 8b 6e 24          	mov    0x24(%r14),%ebp
    45ee:	49 01 c9             	add    %rcx,%r9
    45f1:	48 89 3c 24          	mov    %rdi,(%rsp)
    45f5:	49 01 f9             	add    %rdi,%r9
    45f8:	41 0f b7 79 04       	movzwl 0x4(%r9),%edi
    45fd:	45 0f b7 49 08       	movzwl 0x8(%r9),%r9d
    4602:	8d 3c 7f             	lea    (%rdi,%rdi,2),%edi
    4605:	c1 e7 02             	shl    $0x2,%edi
    4608:	48 01 ef             	add    %rbp,%rdi
    460b:	48 8b 2c 24          	mov    (%rsp),%rbp
    460f:	48 01 ef             	add    %rbp,%rdi
    4612:	41 8b 6e 34          	mov    0x34(%r14),%ebp
    4616:	89 6c 24 30          	mov    %ebp,0x30(%rsp)
    461a:	8b 6e 08             	mov    0x8(%rsi),%ebp
    461d:	48 01 c5             	add    %rax,%rbp
    4620:	31 c0                	xor    %eax,%eax
    4622:	0f 10 4c 05 00       	movups 0x0(%rbp,%rax,1),%xmm1
    4627:	0f 5a c1             	cvtps2pd %xmm1,%xmm0
    462a:	41 0f 29 44 45 00    	movaps %xmm0,0x0(%r13,%rax,2)
    4630:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4634:	0f 12 c1             	movhlps %xmm1,%xmm0
    4637:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
    463a:	41 0f 29 44 45 10    	movaps %xmm0,0x10(%r13,%rax,2)
    4640:	48 83 c0 10          	add    $0x10,%rax
    4644:	48 83 f8 30          	cmp    $0x30,%rax
    4648:	75 d8                	jne    4622 <ayatsuri_model_instance_evaluate+0xae2>
    464a:	f2 44 0f 10 bc 24 98 	movsd  0x398(%rsp),%xmm15
    4651:	03 00 00 
    4654:	f3 0f 7e 07          	movq   (%rdi),%xmm0
    4658:	f2 0f 10 ac 24 c0 03 	movsd  0x3c0(%rsp),%xmm5
    465f:	00 00 
    4661:	f2 44 0f 10 8c 24 b8 	movsd  0x3b8(%rsp),%xmm9
    4668:	03 00 00 
    466b:	f2 44 0f 10 84 24 b0 	movsd  0x3b0(%rsp),%xmm8
    4672:	03 00 00 
    4675:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
    4678:	66 0f 28 f8          	movapd %xmm0,%xmm7
    467c:	66 0f 28 c8          	movapd %xmm0,%xmm1
    4680:	66 0f 15 ff          	unpckhpd %xmm7,%xmm7
    4684:	f2 0f 11 6c 24 40    	movsd  %xmm5,0x40(%rsp)
    468a:	f2 44 0f 10 ac 24 90 	movsd  0x390(%rsp),%xmm13
    4691:	03 00 00 
    4694:	66 0f 28 d7          	movapd %xmm7,%xmm2
    4698:	0f 29 84 24 e0 02 00 	movaps %xmm0,0x2e0(%rsp)
    469f:	00 
    46a0:	66 0f ef c0          	pxor   %xmm0,%xmm0
    46a4:	f2 44 0f 59 ff       	mulsd  %xmm7,%xmm15
    46a9:	f3 0f 5a 47 08       	cvtss2sd 0x8(%rdi),%xmm0
    46ae:	f2 0f 10 bc 24 a0 03 	movsd  0x3a0(%rsp),%xmm7
    46b5:	00 00 
    46b7:	f2 0f 11 84 24 f0 02 	movsd  %xmm0,0x2f0(%rsp)
    46be:	00 00 
    46c0:	f2 44 0f 59 ca       	mulsd  %xmm2,%xmm9
    46c5:	f2 0f 11 7c 24 38    	movsd  %xmm7,0x38(%rsp)
    46cb:	f2 44 0f 59 c1       	mulsd  %xmm1,%xmm8
    46d0:	66 0f 28 f7          	movapd %xmm7,%xmm6
    46d4:	66 0f 28 fd          	movapd %xmm5,%xmm7
    46d8:	f2 0f 10 ac 24 e0 03 	movsd  0x3e0(%rsp),%xmm5
    46df:	00 00 
    46e1:	f2 0f 59 f8          	mulsd  %xmm0,%xmm7
    46e5:	f2 0f 59 f0          	mulsd  %xmm0,%xmm6
    46e9:	f2 0f 59 94 24 d8 03 	mulsd  0x3d8(%rsp),%xmm2
    46f0:	00 00 
    46f2:	f2 0f 11 6c 24 48    	movsd  %xmm5,0x48(%rsp)
    46f8:	f2 0f 59 c5          	mulsd  %xmm5,%xmm0
    46fc:	66 41 0f 28 e9       	movapd %xmm9,%xmm5
    4701:	f2 44 0f 59 e9       	mulsd  %xmm1,%xmm13
    4706:	66 45 0f 28 e0       	movapd %xmm8,%xmm12
    470b:	66 41 0f 28 e0       	movapd %xmm8,%xmm4
    4710:	f2 0f 59 8c 24 d0 03 	mulsd  0x3d0(%rsp),%xmm1
    4717:	00 00 
    4719:	66 0f 28 df          	movapd %xmm7,%xmm3
    471d:	66 44 0f 28 df       	movapd %xmm7,%xmm11
    4722:	f2 0f 59 da          	mulsd  %xmm2,%xmm3
    4726:	f2 0f 59 e8          	mulsd  %xmm0,%xmm5
    472a:	f2 44 0f 59 e0       	mulsd  %xmm0,%xmm12
    472f:	f2 44 0f 59 d9       	mulsd  %xmm1,%xmm11
    4734:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    4738:	f2 0f 5c eb          	subsd  %xmm3,%xmm5
    473c:	66 41 0f 28 d9       	movapd %xmm9,%xmm3
    4741:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
    4745:	f2 44 0f 11 64 24 20 	movsd  %xmm12,0x20(%rsp)
    474c:	f2 45 0f 5c e3       	subsd  %xmm11,%xmm12
    4751:	66 44 0f 28 d4       	movapd %xmm4,%xmm10
    4756:	f2 0f 10 25 00 00 00 	movsd  0x0(%rip),%xmm4        # 475e <ayatsuri_model_instance_evaluate+0xc1e>
    475d:	00 
			475a: R_X86_64_PC32	.LC22-0x4
    475e:	f2 45 0f 59 e7       	mulsd  %xmm15,%xmm12
    4763:	f2 44 0f 5c d3       	subsd  %xmm3,%xmm10
    4768:	66 41 0f 28 dd       	movapd %xmm13,%xmm3
    476d:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    4771:	f2 41 0f 5c dc       	subsd  %xmm12,%xmm3
    4776:	66 44 0f 28 e6       	movapd %xmm6,%xmm12
    477b:	f2 45 0f 59 e2       	mulsd  %xmm10,%xmm12
    4780:	f2 41 0f 58 dc       	addsd  %xmm12,%xmm3
    4785:	66 44 0f 28 e3       	movapd %xmm3,%xmm12
    478a:	66 44 0f 54 25 00 00 	andpd  0x0(%rip),%xmm12        # 4793 <ayatsuri_model_instance_evaluate+0xc53>
    4791:	00 00 
			478f: R_X86_64_PC32	.LC8-0x4
    4793:	66 41 0f 2e e4       	ucomisd %xmm12,%xmm4
    4798:	0f 82 82 0f 00 00    	jb     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    479e:	f2 0f 10 25 00 00 00 	movsd  0x0(%rip),%xmm4        # 47a6 <ayatsuri_model_instance_evaluate+0xc66>
    47a5:	00 
			47a2: R_X86_64_PC32	.LC40-0x4
    47a6:	66 41 0f 2f e4       	comisd %xmm12,%xmm4
    47ab:	0f 87 6f 0f 00 00    	ja     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    47b1:	f2 44 0f 5c 5c 24 20 	subsd  0x20(%rsp),%xmm11
    47b8:	66 44 0f 28 e3       	movapd %xmm3,%xmm12
    47bd:	66 41 0f 28 e2       	movapd %xmm10,%xmm4
    47c2:	31 c0                	xor    %eax,%eax
    47c4:	66 45 0f 14 e4       	unpcklpd %xmm12,%xmm12
    47c9:	66 41 0f 14 eb       	unpcklpd %xmm11,%xmm5
    47ce:	66 44 0f 28 de       	movapd %xmm6,%xmm11
    47d3:	66 41 0f 5e ec       	divpd  %xmm12,%xmm5
    47d8:	f2 44 0f 59 da       	mulsd  %xmm2,%xmm11
    47dd:	f2 41 0f 59 d5       	mulsd  %xmm13,%xmm2
    47e2:	0f 29 ac 24 30 03 00 	movaps %xmm5,0x330(%rsp)
    47e9:	00 
    47ea:	66 41 0f 28 ef       	movapd %xmm15,%xmm5
    47ef:	f2 0f 59 e8          	mulsd  %xmm0,%xmm5
    47f3:	f2 41 0f 59 c5       	mulsd  %xmm13,%xmm0
    47f8:	f2 44 0f 5c dd       	subsd  %xmm5,%xmm11
    47fd:	66 41 0f 14 e3       	unpcklpd %xmm11,%xmm4
    4802:	66 41 0f 5e e4       	divpd  %xmm12,%xmm4
    4807:	0f 29 a4 24 40 03 00 	movaps %xmm4,0x340(%rsp)
    480e:	00 
    480f:	66 0f 28 e6          	movapd %xmm6,%xmm4
    4813:	f2 0f 59 e1          	mulsd  %xmm1,%xmm4
    4817:	f2 41 0f 59 cf       	mulsd  %xmm15,%xmm1
    481c:	f2 0f 5c c4          	subsd  %xmm4,%xmm0
    4820:	f2 0f 5c ca          	subsd  %xmm2,%xmm1
    4824:	66 0f 14 c1          	unpcklpd %xmm1,%xmm0
    4828:	66 0f 28 ce          	movapd %xmm6,%xmm1
    482c:	66 41 0f 5e c4       	divpd  %xmm12,%xmm0
    4831:	f2 41 0f 59 c9       	mulsd  %xmm9,%xmm1
    4836:	f2 41 0f 59 f0       	mulsd  %xmm8,%xmm6
    483b:	0f 29 84 24 50 03 00 	movaps %xmm0,0x350(%rsp)
    4842:	00 
    4843:	66 41 0f 28 c7       	movapd %xmm15,%xmm0
    4848:	f2 0f 59 c7          	mulsd  %xmm7,%xmm0
    484c:	f2 41 0f 59 fd       	mulsd  %xmm13,%xmm7
    4851:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    4855:	66 41 0f 28 cf       	movapd %xmm15,%xmm1
    485a:	f2 0f 5c f7          	subsd  %xmm7,%xmm6
    485e:	f2 41 0f 59 c8       	mulsd  %xmm8,%xmm1
    4863:	66 0f 14 c6          	unpcklpd %xmm6,%xmm0
    4867:	66 41 0f 5e c4       	divpd  %xmm12,%xmm0
    486c:	0f 29 84 24 60 03 00 	movaps %xmm0,0x360(%rsp)
    4873:	00 
    4874:	66 41 0f 28 c5       	movapd %xmm13,%xmm0
    4879:	f2 41 0f 59 c1       	mulsd  %xmm9,%xmm0
    487e:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    4882:	f2 0f 5e c3          	divsd  %xmm3,%xmm0
    4886:	f2 0f 11 84 24 70 03 	movsd  %xmm0,0x370(%rsp)
    488d:	00 00 
    488f:	f2 0f 10 0c 43       	movsd  (%rbx,%rax,2),%xmm1
    4894:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 489c <ayatsuri_model_instance_evaluate+0xd5c>
    489b:	00 
			4898: R_X86_64_PC32	.LC22-0x4
    489c:	66 0f 28 c1          	movapd %xmm1,%xmm0
    48a0:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 48a8 <ayatsuri_model_instance_evaluate+0xd68>
    48a7:	00 
			48a4: R_X86_64_PC32	.LC8-0x4
    48a8:	66 0f 2e f8          	ucomisd %xmm0,%xmm7
    48ac:	0f 82 6e 0e 00 00    	jb     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    48b2:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 48ba <ayatsuri_model_instance_evaluate+0xd7a>
    48b9:	00 
			48b6: R_X86_64_PC32	.LC38-0x4
    48ba:	0f 83 60 0e 00 00    	jae    5720 <ayatsuri_model_instance_evaluate+0x1be0>
    48c0:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 48c8 <ayatsuri_model_instance_evaluate+0xd88>
    48c7:	00 
			48c4: R_X86_64_PC32	.LC39-0x4
    48c8:	0f 86 f5 13 00 00    	jbe    5cc3 <ayatsuri_model_instance_evaluate+0x2183>
    48ce:	66 0f ef d2          	pxor   %xmm2,%xmm2
    48d2:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 48da <ayatsuri_model_instance_evaluate+0xd9a>
    48d9:	00 
			48d6: R_X86_64_PC32	.LC33-0x4
    48da:	66 0f 2f d1          	comisd %xmm1,%xmm2
    48de:	77 04                	ja     48e4 <ayatsuri_model_instance_evaluate+0xda4>
    48e0:	41 0f 28 c6          	movaps %xmm14,%xmm0
    48e4:	f3 0f 11 84 05 80 00 	movss  %xmm0,0x80(%rbp,%rax,1)
    48eb:	00 00 
    48ed:	48 83 c0 04          	add    $0x4,%rax
    48f1:	48 83 f8 24          	cmp    $0x24,%rax
    48f5:	75 98                	jne    488f <ayatsuri_model_instance_evaluate+0xd4f>
    48f7:	48 89 54 24 50       	mov    %rdx,0x50(%rsp)
    48fc:	48 8d 84 24 e0 02 00 	lea    0x2e0(%rsp),%rax
    4903:	00 
    4904:	66 0f ef c9          	pxor   %xmm1,%xmm1
    4908:	31 ff                	xor    %edi,%edi
    490a:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
    490f:	4c 89 e8             	mov    %r13,%rax
    4912:	f3 41 0f 5a 4f 40    	cvtss2sd 0x40(%r15),%xmm1
    4918:	f2 0f 10 30          	movsd  (%rax),%xmm6
    491c:	f2 0f 10 68 20       	movsd  0x20(%rax),%xmm5
    4921:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4925:	66 0f ef db          	pxor   %xmm3,%xmm3
    4929:	f3 0f 5a 84 24 e4 01 	cvtss2sd 0x1e4(%rsp),%xmm0
    4930:	00 00 
    4932:	f2 0f 10 60 40       	movsd  0x40(%rax),%xmm4
    4937:	f3 0f 5a 9c 24 e8 01 	cvtss2sd 0x1e8(%rsp),%xmm3
    493e:	00 00 
    4940:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
    4945:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    4949:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 4951 <ayatsuri_model_instance_evaluate+0xe11>
    4950:	00 
			494d: R_X86_64_PC32	.LC22-0x4
    4951:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
    4955:	f2 0f 10 14 7a       	movsd  (%rdx,%rdi,2),%xmm2
    495a:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    495e:	66 0f ef db          	pxor   %xmm3,%xmm3
    4962:	f3 0f 5a 9c 24 ec 01 	cvtss2sd 0x1ec(%rsp),%xmm3
    4969:	00 00 
    496b:	f2 0f 59 dc          	mulsd  %xmm4,%xmm3
    496f:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    4973:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    4977:	f2 0f 59 c2          	mulsd  %xmm2,%xmm0
    497b:	66 0f 28 d8          	movapd %xmm0,%xmm3
    497f:	66 0f 54 1d 00 00 00 	andpd  0x0(%rip),%xmm3        # 4987 <ayatsuri_model_instance_evaluate+0xe47>
    4986:	00 
			4983: R_X86_64_PC32	.LC8-0x4
    4987:	66 0f 2e fb          	ucomisd %xmm3,%xmm7
    498b:	0f 82 8f 0d 00 00    	jb     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    4991:	66 0f 2f 1d 00 00 00 	comisd 0x0(%rip),%xmm3        # 4999 <ayatsuri_model_instance_evaluate+0xe59>
    4998:	00 
			4995: R_X86_64_PC32	.LC38-0x4
    4999:	0f 83 81 0d 00 00    	jae    5720 <ayatsuri_model_instance_evaluate+0x1be0>
    499f:	66 0f 2f 1d 00 00 00 	comisd 0x0(%rip),%xmm3        # 49a7 <ayatsuri_model_instance_evaluate+0xe67>
    49a6:	00 
			49a3: R_X86_64_PC32	.LC39-0x4
    49a7:	0f 86 3a 13 00 00    	jbe    5ce7 <ayatsuri_model_instance_evaluate+0x21a7>
    49ad:	66 0f ef db          	pxor   %xmm3,%xmm3
    49b1:	66 0f 2f d8          	comisd %xmm0,%xmm3
    49b5:	0f 87 35 13 00 00    	ja     5cf0 <ayatsuri_model_instance_evaluate+0x21b0>
    49bb:	41 0f 28 c6          	movaps %xmm14,%xmm0
    49bf:	f3 0f 11 44 3d 60    	movss  %xmm0,0x60(%rbp,%rdi,1)
    49c5:	66 0f ef db          	pxor   %xmm3,%xmm3
    49c9:	66 0f ef c0          	pxor   %xmm0,%xmm0
    49cd:	f3 0f 5a 84 24 d8 01 	cvtss2sd 0x1d8(%rsp),%xmm0
    49d4:	00 00 
    49d6:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
    49da:	f3 0f 5a 9c 24 dc 01 	cvtss2sd 0x1dc(%rsp),%xmm3
    49e1:	00 00 
    49e3:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 49eb <ayatsuri_model_instance_evaluate+0xeab>
    49ea:	00 
			49e7: R_X86_64_PC32	.LC22-0x4
    49eb:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    49ef:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    49f3:	66 0f ef db          	pxor   %xmm3,%xmm3
    49f7:	f3 0f 5a 9c 24 e0 01 	cvtss2sd 0x1e0(%rsp),%xmm3
    49fe:	00 00 
    4a00:	f2 0f 59 dc          	mulsd  %xmm4,%xmm3
    4a04:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    4a08:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    4a0c:	f2 0f 59 c2          	mulsd  %xmm2,%xmm0
    4a10:	66 0f 28 d0          	movapd %xmm0,%xmm2
    4a14:	66 0f 54 15 00 00 00 	andpd  0x0(%rip),%xmm2        # 4a1c <ayatsuri_model_instance_evaluate+0xedc>
    4a1b:	00 
			4a18: R_X86_64_PC32	.LC8-0x4
    4a1c:	66 0f 2e f2          	ucomisd %xmm2,%xmm6
    4a20:	0f 82 fa 0c 00 00    	jb     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    4a26:	66 0f 2f 15 00 00 00 	comisd 0x0(%rip),%xmm2        # 4a2e <ayatsuri_model_instance_evaluate+0xeee>
    4a2d:	00 
			4a2a: R_X86_64_PC32	.LC38-0x4
    4a2e:	0f 83 ec 0c 00 00    	jae    5720 <ayatsuri_model_instance_evaluate+0x1be0>
    4a34:	66 0f 2f 15 00 00 00 	comisd 0x0(%rip),%xmm2        # 4a3c <ayatsuri_model_instance_evaluate+0xefc>
    4a3b:	00 
			4a38: R_X86_64_PC32	.LC39-0x4
    4a3c:	0f 86 bb 12 00 00    	jbe    5cfd <ayatsuri_model_instance_evaluate+0x21bd>
    4a42:	66 0f ef d2          	pxor   %xmm2,%xmm2
    4a46:	66 0f 2f d0          	comisd %xmm0,%xmm2
    4a4a:	0f 87 c6 16 00 00    	ja     6116 <ayatsuri_model_instance_evaluate+0x25d6>
    4a50:	41 0f 28 c6          	movaps %xmm14,%xmm0
    4a54:	f3 0f 11 44 3d 70    	movss  %xmm0,0x70(%rbp,%rdi,1)
    4a5a:	48 83 c7 04          	add    $0x4,%rdi
    4a5e:	48 83 c0 08          	add    $0x8,%rax
    4a62:	48 83 ff 0c          	cmp    $0xc,%rdi
    4a66:	0f 85 ac fe ff ff    	jne    4918 <ayatsuri_model_instance_evaluate+0xdd8>
    4a6c:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4a70:	66 0f ef ed          	pxor   %xmm5,%xmm5
    4a74:	f2 0f 10 a4 24 a8 03 	movsd  0x3a8(%rsp),%xmm4
    4a7b:	00 00 
    4a7d:	f2 0f 10 9c 24 c8 03 	movsd  0x3c8(%rsp),%xmm3
    4a84:	00 00 
    4a86:	f3 41 0f 5a 47 34    	cvtss2sd 0x34(%r15),%xmm0
    4a8c:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 4a94 <ayatsuri_model_instance_evaluate+0xf54>
    4a93:	00 
			4a90: R_X86_64_PC32	.LC22-0x4
    4a94:	f2 0f 10 94 24 e8 03 	movsd  0x3e8(%rsp),%xmm2
    4a9b:	00 00 
    4a9d:	f3 0f 5a ac 24 e8 01 	cvtss2sd 0x1e8(%rsp),%xmm5
    4aa4:	00 00 
    4aa6:	f2 0f 5c e0          	subsd  %xmm0,%xmm4
    4aaa:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4aae:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
    4ab3:	f3 41 0f 5a 47 38    	cvtss2sd 0x38(%r15),%xmm0
    4ab9:	f2 0f 5c d8          	subsd  %xmm0,%xmm3
    4abd:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4ac1:	f3 41 0f 5a 47 3c    	cvtss2sd 0x3c(%r15),%xmm0
    4ac7:	f2 0f 5c d0          	subsd  %xmm0,%xmm2
    4acb:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4acf:	f3 0f 5a 84 24 e4 01 	cvtss2sd 0x1e4(%rsp),%xmm0
    4ad6:	00 00 
    4ad8:	f2 0f 59 c4          	mulsd  %xmm4,%xmm0
    4adc:	f2 0f 59 eb          	mulsd  %xmm3,%xmm5
    4ae0:	f2 0f 58 c5          	addsd  %xmm5,%xmm0
    4ae4:	66 0f ef ed          	pxor   %xmm5,%xmm5
    4ae8:	f3 0f 5a ac 24 ec 01 	cvtss2sd 0x1ec(%rsp),%xmm5
    4aef:	00 00 
    4af1:	f2 0f 59 ea          	mulsd  %xmm2,%xmm5
    4af5:	f2 0f 58 c5          	addsd  %xmm5,%xmm0
    4af9:	66 0f ef ed          	pxor   %xmm5,%xmm5
    4afd:	f3 41 0f 5a 6f 44    	cvtss2sd 0x44(%r15),%xmm5
    4b03:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    4b07:	f2 0f 58 c5          	addsd  %xmm5,%xmm0
    4b0b:	66 0f 28 e8          	movapd %xmm0,%xmm5
    4b0f:	66 0f 54 2d 00 00 00 	andpd  0x0(%rip),%xmm5        # 4b17 <ayatsuri_model_instance_evaluate+0xfd7>
    4b16:	00 
			4b13: R_X86_64_PC32	.LC8-0x4
    4b17:	66 0f 2e f5          	ucomisd %xmm5,%xmm6
    4b1b:	0f 82 ff 0b 00 00    	jb     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    4b21:	66 0f 2f 2d 00 00 00 	comisd 0x0(%rip),%xmm5        # 4b29 <ayatsuri_model_instance_evaluate+0xfe9>
    4b28:	00 
			4b25: R_X86_64_PC32	.LC38-0x4
    4b29:	0f 83 f1 0b 00 00    	jae    5720 <ayatsuri_model_instance_evaluate+0x1be0>
    4b2f:	66 0f 2f 2d 00 00 00 	comisd 0x0(%rip),%xmm5        # 4b37 <ayatsuri_model_instance_evaluate+0xff7>
    4b36:	00 
			4b33: R_X86_64_PC32	.LC39-0x4
    4b37:	0f 86 c9 11 00 00    	jbe    5d06 <ayatsuri_model_instance_evaluate+0x21c6>
    4b3d:	66 0f ef ed          	pxor   %xmm5,%xmm5
    4b41:	66 0f 2f e8          	comisd %xmm0,%xmm5
    4b45:	0f 87 2c 15 00 00    	ja     6077 <ayatsuri_model_instance_evaluate+0x2537>
    4b4b:	41 0f 28 c6          	movaps %xmm14,%xmm0
    4b4f:	f3 0f 11 45 6c       	movss  %xmm0,0x6c(%rbp)
    4b54:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4b58:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 4b60 <ayatsuri_model_instance_evaluate+0x1020>
    4b5f:	00 
			4b5c: R_X86_64_PC32	.LC22-0x4
    4b60:	f3 0f 5a 84 24 d8 01 	cvtss2sd 0x1d8(%rsp),%xmm0
    4b67:	00 00 
    4b69:	f2 0f 59 c4          	mulsd  %xmm4,%xmm0
    4b6d:	66 0f ef e4          	pxor   %xmm4,%xmm4
    4b71:	f3 0f 5a a4 24 dc 01 	cvtss2sd 0x1dc(%rsp),%xmm4
    4b78:	00 00 
    4b7a:	f2 0f 59 dc          	mulsd  %xmm4,%xmm3
    4b7e:	f2 0f 58 c3          	addsd  %xmm3,%xmm0
    4b82:	66 0f ef db          	pxor   %xmm3,%xmm3
    4b86:	f3 0f 5a 9c 24 e0 01 	cvtss2sd 0x1e0(%rsp),%xmm3
    4b8d:	00 00 
    4b8f:	f2 0f 59 d3          	mulsd  %xmm3,%xmm2
    4b93:	f2 0f 58 c2          	addsd  %xmm2,%xmm0
    4b97:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    4b9b:	66 0f ef c9          	pxor   %xmm1,%xmm1
    4b9f:	f3 41 0f 5a 4f 48    	cvtss2sd 0x48(%r15),%xmm1
    4ba5:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    4ba9:	66 0f 28 c8          	movapd %xmm0,%xmm1
    4bad:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 4bb5 <ayatsuri_model_instance_evaluate+0x1075>
    4bb4:	00 
			4bb1: R_X86_64_PC32	.LC8-0x4
    4bb5:	66 0f 2e f1          	ucomisd %xmm1,%xmm6
    4bb9:	0f 82 61 0b 00 00    	jb     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    4bbf:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 4bc7 <ayatsuri_model_instance_evaluate+0x1087>
    4bc6:	00 
			4bc3: R_X86_64_PC32	.LC38-0x4
    4bc7:	0f 83 53 0b 00 00    	jae    5720 <ayatsuri_model_instance_evaluate+0x1be0>
    4bcd:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 4bd5 <ayatsuri_model_instance_evaluate+0x1095>
    4bd4:	00 
			4bd1: R_X86_64_PC32	.LC39-0x4
    4bd5:	0f 86 55 15 00 00    	jbe    6130 <ayatsuri_model_instance_evaluate+0x25f0>
    4bdb:	66 0f ef c9          	pxor   %xmm1,%xmm1
    4bdf:	66 0f 2f c8          	comisd %xmm0,%xmm1
    4be3:	0f 87 3a 15 00 00    	ja     6123 <ayatsuri_model_instance_evaluate+0x25e3>
    4be9:	41 0f 28 c6          	movaps %xmm14,%xmm0
    4bed:	41 0f b7 f9          	movzwl %r9w,%edi
    4bf1:	8b 44 24 30          	mov    0x30(%rsp),%eax
    4bf5:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
    4bfa:	48 6b ff 48          	imul   $0x48,%rdi,%rdi
    4bfe:	48 8b 0c 24          	mov    (%rsp),%rcx
    4c02:	f3 0f 11 45 7c       	movss  %xmm0,0x7c(%rbp)
    4c07:	4c 89 9c 24 90 00 00 	mov    %r11,0x90(%rsp)
    4c0e:	00 
    4c0f:	4c 89 54 24 70       	mov    %r10,0x70(%rsp)
    4c14:	48 01 f8             	add    %rdi,%rax
    4c17:	8b 7e 0c             	mov    0xc(%rsi),%edi
    4c1a:	48 89 54 24 68       	mov    %rdx,0x68(%rsp)
    4c1f:	48 01 c1             	add    %rax,%rcx
    4c22:	4c 89 44 24 60       	mov    %r8,0x60(%rsp)
    4c27:	48 89 0c 24          	mov    %rcx,(%rsp)
    4c2b:	e8 30 b5 ff ff       	call   160 <pack_rgb>
    4c30:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 4c38 <ayatsuri_model_instance_evaluate+0x10f8>
    4c37:	00 
			4c34: R_X86_64_PC32	.LC5-0x4
    4c38:	f2 0f 59 06          	mulsd  (%rsi),%xmm0
    4c3c:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 4c44 <ayatsuri_model_instance_evaluate+0x1104>
    4c43:	00 
			4c40: R_X86_64_PC32	.LC6-0x4
    4c44:	66 89 44 24 20       	mov    %ax,0x20(%rsp)
    4c49:	e8 00 00 00 00       	call   4c4e <ayatsuri_model_instance_evaluate+0x110e>
			4c4a: R_X86_64_PLT32	floor-0x4
    4c4e:	48 8b 0c 24          	mov    (%rsp),%rcx
    4c52:	f2 0f 11 44 24 50    	movsd  %xmm0,0x50(%rsp)
    4c58:	48 8d 79 30          	lea    0x30(%rcx),%rdi
    4c5c:	e8 9f b3 ff ff       	call   0 <md>
    4c61:	f2 0f 10 4c 24 40    	movsd  0x40(%rsp),%xmm1
    4c67:	f2 0f 11 44 24 30    	movsd  %xmm0,0x30(%rsp)
    4c6d:	f2 0f 10 44 24 38    	movsd  0x38(%rsp),%xmm0
    4c73:	e8 00 00 00 00       	call   4c78 <ayatsuri_model_instance_evaluate+0x1138>
			4c74: R_X86_64_PLT32	hypot-0x4
    4c78:	f2 0f 10 4c 24 48    	movsd  0x48(%rsp),%xmm1
    4c7e:	e8 00 00 00 00       	call   4c83 <ayatsuri_model_instance_evaluate+0x1143>
			4c7f: R_X86_64_PLT32	hypot-0x4
    4c83:	f2 0f 59 44 24 30    	mulsd  0x30(%rsp),%xmm0
    4c89:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 4c91 <ayatsuri_model_instance_evaluate+0x1151>
    4c90:	00 
			4c8d: R_X86_64_PC32	.LC9-0x4
    4c91:	e8 00 00 00 00       	call   4c96 <ayatsuri_model_instance_evaluate+0x1156>
			4c92: R_X86_64_PLT32	fmin-0x4
    4c96:	f2 0f 59 05 00 00 00 	mulsd  0x0(%rip),%xmm0        # 4c9e <ayatsuri_model_instance_evaluate+0x115e>
    4c9d:	00 
			4c9a: R_X86_64_PC32	.LC5-0x4
    4c9e:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 4ca6 <ayatsuri_model_instance_evaluate+0x1166>
    4ca5:	00 
			4ca2: R_X86_64_PC32	.LC6-0x4
    4ca6:	e8 00 00 00 00       	call   4cab <ayatsuri_model_instance_evaluate+0x116b>
			4ca7: R_X86_64_PLT32	floor-0x4
    4cab:	f2 0f 10 54 24 50    	movsd  0x50(%rsp),%xmm2
    4cb1:	48 8b 0c 24          	mov    (%rsp),%rcx
    4cb5:	66 c7 85 f0 00 00 00 	movw   $0x0,0xf0(%rbp)
    4cbc:	00 00 
    4cbe:	48 c7 85 d4 00 00 00 	movq   $0x3f800000,0xd4(%rbp)
    4cc5:	00 00 80 3f 
    4cc9:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    4ccd:	0f 28 05 00 00 00 00 	movaps 0x0(%rip),%xmm0        # 4cd4 <ayatsuri_model_instance_evaluate+0x1194>
			4cd0: R_X86_64_PC32	.LC41-0x4
    4cd4:	f2 0f 2c f2          	cvttsd2si %xmm2,%esi
    4cd8:	48 8d 79 40          	lea    0x40(%rcx),%rdi
    4cdc:	0f 11 85 c4 00 00 00 	movups %xmm0,0xc4(%rbp)
    4ce3:	0f b7 c0             	movzwl %ax,%eax
    4ce6:	0f b7 f6             	movzwl %si,%esi
    4ce9:	48 c1 e0 10          	shl    $0x10,%rax
    4ced:	48 09 f0             	or     %rsi,%rax
    4cf0:	0f b7 74 24 20       	movzwl 0x20(%rsp),%esi
    4cf5:	48 c1 e0 10          	shl    $0x10,%rax
    4cf9:	48 09 f0             	or     %rsi,%rax
    4cfc:	48 c1 e0 10          	shl    $0x10,%rax
    4d00:	48 09 f0             	or     %rsi,%rax
    4d03:	48 89 85 e8 00 00 00 	mov    %rax,0xe8(%rbp)
    4d0a:	e8 f1 b2 ff ff       	call   0 <md>
    4d0f:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 4d17 <ayatsuri_model_instance_evaluate+0x11d7>
    4d16:	00 
			4d13: R_X86_64_PC32	.LC22-0x4
    4d17:	66 0f 28 c8          	movapd %xmm0,%xmm1
    4d1b:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 4d23 <ayatsuri_model_instance_evaluate+0x11e3>
    4d22:	00 
			4d1f: R_X86_64_PC32	.LC8-0x4
    4d23:	66 0f 2e f1          	ucomisd %xmm1,%xmm6
    4d27:	0f 82 f3 09 00 00    	jb     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    4d2d:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 4d35 <ayatsuri_model_instance_evaluate+0x11f5>
    4d34:	00 
			4d31: R_X86_64_PC32	.LC38-0x4
    4d35:	0f 83 e5 09 00 00    	jae    5720 <ayatsuri_model_instance_evaluate+0x1be0>
    4d3b:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 4d43 <ayatsuri_model_instance_evaluate+0x1203>
    4d42:	00 
			4d3f: R_X86_64_PC32	.LC39-0x4
    4d43:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
    4d48:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 4d51 <ayatsuri_model_instance_evaluate+0x1211>
    4d4f:	00 00 
			4d4d: R_X86_64_PC32	.LC0-0x4
    4d51:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
    4d56:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
    4d5b:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 4d64 <ayatsuri_model_instance_evaluate+0x1224>
    4d62:	00 00 
			4d60: R_X86_64_PC32	.LC1-0x4
    4d64:	4c 8b 54 24 70       	mov    0x70(%rsp),%r10
    4d69:	4c 8b 9c 24 90 00 00 	mov    0x90(%rsp),%r11
    4d70:	00 
    4d71:	0f 86 89 13 00 00    	jbe    6100 <ayatsuri_model_instance_evaluate+0x25c0>
    4d77:	66 0f ef c9          	pxor   %xmm1,%xmm1
    4d7b:	66 0f 2f c8          	comisd %xmm0,%xmm1
    4d7f:	0f 87 6e 13 00 00    	ja     60f3 <ayatsuri_model_instance_evaluate+0x25b3>
    4d85:	41 0f 28 c6          	movaps %xmm14,%xmm0
    4d89:	45 8b 4e 50          	mov    0x50(%r14),%r9d
    4d8d:	b8 7f 00 00 00       	mov    $0x7f,%eax
    4d92:	f3 0f 11 85 dc 00 00 	movss  %xmm0,0xdc(%rbp)
    4d99:	00 
    4d9a:	31 ff                	xor    %edi,%edi
    4d9c:	48 c1 e0 37          	shl    $0x37,%rax
    4da0:	48 89 85 e0 00 00 00 	mov    %rax,0xe0(%rbp)
    4da7:	44 89 0c 24          	mov    %r9d,(%rsp)
    4dab:	8b 04 24             	mov    (%rsp),%eax
    4dae:	39 c7                	cmp    %eax,%edi
    4db0:	0f 84 1f 0a 00 00    	je     57d5 <ayatsuri_model_instance_evaluate+0x1c95>
    4db6:	41 8b 76 4c          	mov    0x4c(%r14),%esi
    4dba:	89 f8                	mov    %edi,%eax
    4dbc:	44 8b 4c 24 18       	mov    0x18(%rsp),%r9d
    4dc1:	c1 e0 05             	shl    $0x5,%eax
    4dc4:	48 01 c6             	add    %rax,%rsi
    4dc7:	49 03 36             	add    (%r14),%rsi
    4dca:	0f b7 06             	movzwl (%rsi),%eax
    4dcd:	44 39 c8             	cmp    %r9d,%eax
    4dd0:	0f 84 c8 12 00 00    	je     609e <ayatsuri_model_instance_evaluate+0x255e>
    4dd6:	83 c7 01             	add    $0x1,%edi
    4dd9:	eb d0                	jmp    4dab <ayatsuri_model_instance_evaluate+0x126b>
    4ddb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    4de0:	8b 74 24 18          	mov    0x18(%rsp),%esi
    4de4:	45 31 c9             	xor    %r9d,%r9d
    4de7:	4c 89 ff             	mov    %r15,%rdi
    4dea:	4c 89 5c 24 20       	mov    %r11,0x20(%rsp)
    4def:	48 8b 8c 24 78 01 00 	mov    0x178(%rsp),%rcx
    4df6:	00 
    4df7:	48 8b 94 24 80 01 00 	mov    0x180(%rsp),%rdx
    4dfe:	00 
    4dff:	4c 8d 84 24 c8 01 00 	lea    0x1c8(%rsp),%r8
    4e06:	00 
    4e07:	4c 89 14 24          	mov    %r10,(%rsp)
    4e0b:	e8 d0 b9 ff ff       	call   7e0 <mesh_packet>
    4e10:	84 c0                	test   %al,%al
    4e12:	0f 84 08 09 00 00    	je     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    4e18:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    4e1e:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
    4e23:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 4e2c <ayatsuri_model_instance_evaluate+0x12ec>
    4e2a:	00 00 
			4e28: R_X86_64_PC32	.LC0-0x4
    4e2c:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 4e35 <ayatsuri_model_instance_evaluate+0x12f5>
    4e33:	00 00 
			4e31: R_X86_64_PC32	.LC1-0x4
    4e35:	4c 8b 14 24          	mov    (%rsp),%r10
    4e39:	e9 0b f7 ff ff       	jmp    4549 <ayatsuri_model_instance_evaluate+0xa09>
    4e3e:	66 90                	xchg   %ax,%ax
    4e40:	4d 8b 37             	mov    (%r15),%r14
    4e43:	49 8b 6f 08          	mov    0x8(%r15),%rbp
    4e47:	41 8b 46 14          	mov    0x14(%r14),%eax
    4e4b:	49 8b 3e             	mov    (%r14),%rdi
    4e4e:	48 01 c8             	add    %rcx,%rax
    4e51:	48 89 bc 24 b8 00 00 	mov    %rdi,0xb8(%rsp)
    4e58:	00 
    4e59:	4c 8d 0c 07          	lea    (%rdi,%rax,1),%r9
    4e5d:	41 8b 46 34          	mov    0x34(%r14),%eax
    4e61:	41 0f b7 79 06       	movzwl 0x6(%r9),%edi
    4e66:	41 0f b7 71 08       	movzwl 0x8(%r9),%esi
    4e6b:	89 84 24 8c 01 00 00 	mov    %eax,0x18c(%rsp)
    4e72:	48 8d 44 15 00       	lea    0x0(%rbp,%rdx,1),%rax
    4e77:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
    4e7e:	00 
    4e7f:	8b 40 08             	mov    0x8(%rax),%eax
    4e82:	48 01 c5             	add    %rax,%rbp
    4e85:	8d 04 7f             	lea    (%rdi,%rdi,2),%eax
    4e88:	8d 44 00 4f          	lea    0x4f(%rax,%rax,1),%eax
    4e8c:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
    4e93:	00 
    4e94:	31 c0                	xor    %eax,%eax
    4e96:	0f 10 4c 05 00       	movups 0x0(%rbp,%rax,1),%xmm1
    4e9b:	0f 5a c1             	cvtps2pd %xmm1,%xmm0
    4e9e:	0f 29 04 43          	movaps %xmm0,(%rbx,%rax,2)
    4ea2:	66 0f ef c0          	pxor   %xmm0,%xmm0
    4ea6:	0f 12 c1             	movhlps %xmm1,%xmm0
    4ea9:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
    4eac:	0f 29 44 43 10       	movaps %xmm0,0x10(%rbx,%rax,2)
    4eb1:	48 83 c0 10          	add    $0x10,%rax
    4eb5:	48 83 f8 30          	cmp    $0x30,%rax
    4eb9:	75 db                	jne    4e96 <ayatsuri_model_instance_evaluate+0x1356>
    4ebb:	66 0f ef f6          	pxor   %xmm6,%xmm6
    4ebf:	f3 41 0f 5a 77 40    	cvtss2sd 0x40(%r15),%xmm6
    4ec5:	66 0f 28 fe          	movapd %xmm6,%xmm7
    4ec9:	f2 0f 11 74 24 20    	movsd  %xmm6,0x20(%rsp)
    4ecf:	f2 0f 10 b4 24 80 03 	movsd  0x380(%rsp),%xmm6
    4ed6:	00 00 
    4ed8:	66 0f 14 ff          	unpcklpd %xmm7,%xmm7
    4edc:	0f 29 bc 24 c0 00 00 	movaps %xmm7,0xc0(%rsp)
    4ee3:	00 
    4ee4:	f2 0f 10 bc 24 40 03 	movsd  0x340(%rsp),%xmm7
    4eeb:	00 00 
    4eed:	f2 0f 11 74 24 70    	movsd  %xmm6,0x70(%rsp)
    4ef3:	f2 0f 11 7c 24 60    	movsd  %xmm7,0x60(%rsp)
    4ef9:	f2 0f 10 bc 24 60 03 	movsd  0x360(%rsp),%xmm7
    4f00:	00 00 
    4f02:	f2 0f 11 7c 24 68    	movsd  %xmm7,0x68(%rsp)
    4f08:	85 ff                	test   %edi,%edi
    4f0a:	0f 84 43 09 00 00    	je     5853 <ayatsuri_model_instance_evaluate+0x1d13>
    4f10:	66 0f 28 b4 24 70 03 	movapd 0x370(%rsp),%xmm6
    4f17:	00 00 
    4f19:	41 8b 46 2c          	mov    0x2c(%r14),%eax
    4f1d:	c7 84 24 88 01 00 00 	movl   $0x0,0x188(%rsp)
    4f24:	00 00 00 00 
    4f28:	66 0f 28 bc 24 50 03 	movapd 0x350(%rsp),%xmm7
    4f2f:	00 00 
    4f31:	48 89 8c 24 98 01 00 	mov    %rcx,0x198(%rsp)
    4f38:	00 
    4f39:	0f 29 b4 24 30 01 00 	movaps %xmm6,0x130(%rsp)
    4f40:	00 
    4f41:	66 0f 28 ac 24 30 03 	movapd 0x330(%rsp),%xmm5
    4f48:	00 00 
    4f4a:	66 0f 17 b4 24 50 01 	movhpd %xmm6,0x150(%rsp)
    4f51:	00 00 
    4f53:	66 0f 13 b4 24 48 01 	movlpd %xmm6,0x148(%rsp)
    4f5a:	00 00 
    4f5c:	f2 0f 10 b4 24 48 03 	movsd  0x348(%rsp),%xmm6
    4f63:	00 00 
    4f65:	48 89 84 24 00 01 00 	mov    %rax,0x100(%rsp)
    4f6c:	00 
    4f6d:	48 8d 84 24 38 04 00 	lea    0x438(%rsp),%rax
    4f74:	00 
    4f75:	0f 29 bc 24 10 01 00 	movaps %xmm7,0x110(%rsp)
    4f7c:	00 
    4f7d:	66 0f 17 bc 24 40 01 	movhpd %xmm7,0x140(%rsp)
    4f84:	00 00 
    4f86:	66 0f 13 bc 24 28 01 	movlpd %xmm7,0x128(%rsp)
    4f8d:	00 00 
    4f8f:	f2 0f 10 bc 24 68 03 	movsd  0x368(%rsp),%xmm7
    4f96:	00 00 
    4f98:	f2 0f 11 b4 24 58 01 	movsd  %xmm6,0x158(%rsp)
    4f9f:	00 00 
    4fa1:	f2 0f 10 b4 24 88 03 	movsd  0x388(%rsp),%xmm6
    4fa8:	00 00 
    4faa:	48 89 84 24 70 01 00 	mov    %rax,0x170(%rsp)
    4fb1:	00 
    4fb2:	0f 29 ac 24 f0 00 00 	movaps %xmm5,0xf0(%rsp)
    4fb9:	00 
    4fba:	66 0f 17 ac 24 20 01 	movhpd %xmm5,0x120(%rsp)
    4fc1:	00 00 
    4fc3:	66 0f 13 ac 24 08 01 	movlpd %xmm5,0x108(%rsp)
    4fca:	00 00 
    4fcc:	f2 0f 11 bc 24 60 01 	movsd  %xmm7,0x160(%rsp)
    4fd3:	00 00 
    4fd5:	f2 0f 11 b4 24 68 01 	movsd  %xmm6,0x168(%rsp)
    4fdc:	00 00 
    4fde:	8b 9c 24 88 01 00 00 	mov    0x188(%rsp),%ebx
    4fe5:	41 0f b7 41 04       	movzwl 0x4(%r9),%eax
    4fea:	66 0f ef d2          	pxor   %xmm2,%xmm2
    4fee:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    4ff3:	f2 0f 10 44 24 60    	movsd  0x60(%rsp),%xmm0
    4ff9:	f2 0f 10 6c 24 68    	movsd  0x68(%rsp),%xmm5
    4fff:	66 0f ef db          	pxor   %xmm3,%xmm3
    5003:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    5008:	f2 44 0f 10 ac 24 08 	movsd  0x108(%rsp),%xmm13
    500f:	01 00 00 
    5012:	01 d8                	add    %ebx,%eax
    5014:	48 8b 9c 24 00 01 00 	mov    0x100(%rsp),%rbx
    501b:	00 
    501c:	f2 0f 10 a4 24 20 01 	movsd  0x120(%rsp),%xmm4
    5023:	00 00 
    5025:	8d 04 40             	lea    (%rax,%rax,2),%eax
    5028:	66 44 0f 28 bc 24 30 	movapd 0x130(%rsp),%xmm15
    502f:	01 00 00 
    5032:	8d 04 c5 00 00 00 00 	lea    0x0(,%rax,8),%eax
    5039:	66 44 0f 28 8c 24 10 	movapd 0x110(%rsp),%xmm9
    5040:	01 00 00 
    5043:	48 01 d8             	add    %rbx,%rax
    5046:	48 8b 9c 24 b8 00 00 	mov    0xb8(%rsp),%rbx
    504d:	00 
    504e:	48 01 d8             	add    %rbx,%rax
    5051:	f3 0f 5a 50 14       	cvtss2sd 0x14(%rax),%xmm2
    5056:	f2 0f 59 ea          	mulsd  %xmm2,%xmm5
    505a:	f3 44 0f 5a 20       	cvtss2sd (%rax),%xmm12
    505f:	f3 0f 5a 58 04       	cvtss2sd 0x4(%rax),%xmm3
    5064:	f2 0f 59 c2          	mulsd  %xmm2,%xmm0
    5068:	f3 44 0f 5a 58 08    	cvtss2sd 0x8(%rax),%xmm11
    506e:	f3 44 0f 7e 40 0c    	movq   0xc(%rax),%xmm8
    5074:	f2 0f 59 54 24 70    	mulsd  0x70(%rsp),%xmm2
    507a:	f2 45 0f 59 ec       	mulsd  %xmm12,%xmm13
    507f:	45 0f 5a c0          	cvtps2pd %xmm8,%xmm8
    5083:	f2 0f 59 e3          	mulsd  %xmm3,%xmm4
    5087:	66 45 0f 59 f8       	mulpd  %xmm8,%xmm15
    508c:	66 45 0f 59 c8       	mulpd  %xmm8,%xmm9
    5091:	66 44 0f 59 84 24 f0 	mulpd  0xf0(%rsp),%xmm8
    5098:	00 00 00 
    509b:	f2 0f 11 14 24       	movsd  %xmm2,(%rsp)
    50a0:	f2 0f 10 54 24 60    	movsd  0x60(%rsp),%xmm2
    50a6:	f2 41 0f 59 d3       	mulsd  %xmm11,%xmm2
    50ab:	f2 41 0f 58 e5       	addsd  %xmm13,%xmm4
    50b0:	66 45 0f ef ed       	pxor   %xmm13,%xmm13
    50b5:	f3 45 0f 5a 6f 34    	cvtss2sd 0x34(%r15),%xmm13
    50bb:	66 44 0f 17 7c 24 38 	movhpd %xmm15,0x38(%rsp)
    50c2:	66 44 0f 17 4c 24 30 	movhpd %xmm9,0x30(%rsp)
    50c9:	66 41 0f 28 c9       	movapd %xmm9,%xmm1
    50ce:	66 41 0f 28 f8       	movapd %xmm8,%xmm7
    50d3:	66 0f 15 ff          	unpckhpd %xmm7,%xmm7
    50d7:	f2 0f 58 e2          	addsd  %xmm2,%xmm4
    50db:	f2 0f 10 54 24 68    	movsd  0x68(%rsp),%xmm2
    50e1:	66 0f 28 f7          	movapd %xmm7,%xmm6
    50e5:	f2 0f 58 a4 24 58 01 	addsd  0x158(%rsp),%xmm4
    50ec:	00 00 
    50ee:	66 41 0f 28 f8       	movapd %xmm8,%xmm7
    50f3:	f2 41 0f 59 d3       	mulsd  %xmm11,%xmm2
    50f8:	f2 41 0f 5c e5       	subsd  %xmm13,%xmm4
    50fd:	f2 44 0f 10 ac 24 28 	movsd  0x128(%rsp),%xmm13
    5104:	01 00 00 
    5107:	f2 45 0f 59 ec       	mulsd  %xmm12,%xmm13
    510c:	f2 44 0f 59 a4 24 48 	mulsd  0x148(%rsp),%xmm12
    5113:	01 00 00 
    5116:	f2 0f 11 64 24 48    	movsd  %xmm4,0x48(%rsp)
    511c:	f2 0f 10 a4 24 40 01 	movsd  0x140(%rsp),%xmm4
    5123:	00 00 
    5125:	f2 0f 59 e3          	mulsd  %xmm3,%xmm4
    5129:	f2 0f 59 9c 24 50 01 	mulsd  0x150(%rsp),%xmm3
    5130:	00 00 
    5132:	f2 41 0f 58 e5       	addsd  %xmm13,%xmm4
    5137:	66 45 0f ef ed       	pxor   %xmm13,%xmm13
    513c:	f3 45 0f 5a 6f 38    	cvtss2sd 0x38(%r15),%xmm13
    5142:	f2 41 0f 58 dc       	addsd  %xmm12,%xmm3
    5147:	f2 0f 58 e2          	addsd  %xmm2,%xmm4
    514b:	f2 0f 58 a4 24 60 01 	addsd  0x160(%rsp),%xmm4
    5152:	00 00 
    5154:	f2 41 0f 5c e5       	subsd  %xmm13,%xmm4
    5159:	f2 0f 11 64 24 50    	movsd  %xmm4,0x50(%rsp)
    515f:	f2 44 0f 59 5c 24 70 	mulsd  0x70(%rsp),%xmm11
    5166:	66 0f ef e4          	pxor   %xmm4,%xmm4
    516a:	f2 44 0f 10 6c 24 30 	movsd  0x30(%rsp),%xmm13
    5171:	f3 41 0f 5a 67 3c    	cvtss2sd 0x3c(%r15),%xmm4
    5177:	f2 0f 10 14 24       	movsd  (%rsp),%xmm2
    517c:	f2 44 0f 11 7c 24 40 	movsd  %xmm15,0x40(%rsp)
    5183:	f2 41 0f 58 db       	addsd  %xmm11,%xmm3
    5188:	f2 0f 58 9c 24 68 01 	addsd  0x168(%rsp),%xmm3
    518f:	00 00 
    5191:	f2 44 0f 10 1d 00 00 	movsd  0x0(%rip),%xmm11        # 519a <ayatsuri_model_instance_evaluate+0x165a>
    5198:	00 00 
			5196: R_X86_64_PC32	.LC22-0x4
    519a:	f2 0f 5c dc          	subsd  %xmm4,%xmm3
    519e:	66 41 0f 28 e5       	movapd %xmm13,%xmm4
    51a3:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    51a7:	f2 41 0f 59 d1       	mulsd  %xmm9,%xmm2
    51ac:	f2 0f 11 5c 24 58    	movsd  %xmm3,0x58(%rsp)
    51b2:	f2 0f 10 5c 24 38    	movsd  0x38(%rsp),%xmm3
    51b8:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    51bc:	66 44 0f 28 e4       	movapd %xmm4,%xmm12
    51c1:	f2 0f 10 64 24 38    	movsd  0x38(%rsp),%xmm4
    51c7:	f2 0f 11 94 24 98 00 	movsd  %xmm2,0x98(%rsp)
    51ce:	00 00 
    51d0:	f2 41 0f 59 e1       	mulsd  %xmm9,%xmm4
    51d5:	f2 44 0f 5c e3       	subsd  %xmm3,%xmm12
    51da:	66 41 0f 28 dd       	movapd %xmm13,%xmm3
    51df:	f2 41 0f 59 df       	mulsd  %xmm15,%xmm3
    51e4:	f2 44 0f 11 a4 24 90 	movsd  %xmm12,0x90(%rsp)
    51eb:	00 00 00 
    51ee:	66 45 0f 28 e7       	movapd %xmm15,%xmm12
    51f3:	66 44 0f 28 ec       	movapd %xmm4,%xmm13
    51f8:	f2 44 0f 59 e5       	mulsd  %xmm5,%xmm12
    51fd:	f2 44 0f 5c eb       	subsd  %xmm3,%xmm13
    5202:	f2 0f 10 9c 24 90 00 	movsd  0x90(%rsp),%xmm3
    5209:	00 00 
    520b:	f2 41 0f 59 d8       	mulsd  %xmm8,%xmm3
    5210:	f2 44 0f 11 ac 24 a8 	movsd  %xmm13,0xa8(%rsp)
    5217:	00 00 00 
    521a:	f2 41 0f 5c d4       	subsd  %xmm12,%xmm2
    521f:	f2 44 0f 59 e8       	mulsd  %xmm0,%xmm13
    5224:	f2 44 0f 11 a4 24 a0 	movsd  %xmm12,0xa0(%rsp)
    522b:	00 00 00 
    522e:	66 0f 28 e2          	movapd %xmm2,%xmm4
    5232:	f2 0f 59 e6          	mulsd  %xmm6,%xmm4
    5236:	f2 0f 5c dc          	subsd  %xmm4,%xmm3
    523a:	f2 41 0f 58 dd       	addsd  %xmm13,%xmm3
    523f:	66 44 0f 28 eb       	movapd %xmm3,%xmm13
    5244:	66 0f 54 1d 00 00 00 	andpd  0x0(%rip),%xmm3        # 524c <ayatsuri_model_instance_evaluate+0x170c>
    524b:	00 
			5248: R_X86_64_PC32	.LC8-0x4
    524c:	66 44 0f 2e db       	ucomisd %xmm3,%xmm11
    5251:	0f 82 c9 04 00 00    	jb     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    5257:	f2 44 0f 10 1d 00 00 	movsd  0x0(%rip),%xmm11        # 5260 <ayatsuri_model_instance_evaluate+0x1720>
    525e:	00 00 
			525c: R_X86_64_PC32	.LC40-0x4
    5260:	66 44 0f 2f db       	comisd %xmm3,%xmm11
    5265:	0f 87 b5 04 00 00    	ja     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    526b:	66 0f ef d2          	pxor   %xmm2,%xmm2
    526f:	66 0f ef e4          	pxor   %xmm4,%xmm4
    5273:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    5278:	4c 89 e8             	mov    %r13,%rax
    527b:	f3 0f 5a 94 24 e4 01 	cvtss2sd 0x1e4(%rsp),%xmm2
    5282:	00 00 
    5284:	66 0f 28 da          	movapd %xmm2,%xmm3
    5288:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    528d:	f3 0f 5a a4 24 e8 01 	cvtss2sd 0x1e8(%rsp),%xmm4
    5294:	00 00 
    5296:	66 0f 14 db          	unpcklpd %xmm3,%xmm3
    529a:	b9 f8 ff ff ff       	mov    $0xfffffff8,%ecx
    529f:	f3 44 0f 5a a4 24 ec 	cvtss2sd 0x1ec(%rsp),%xmm12
    52a6:	01 00 00 
    52a9:	f2 0f 11 94 24 b0 00 	movsd  %xmm2,0xb0(%rsp)
    52b0:	00 00 
    52b2:	f3 44 0f 5a 9c 24 d8 	cvtss2sd 0x1d8(%rsp),%xmm11
    52b9:	01 00 00 
    52bc:	66 44 0f 59 c3       	mulpd  %xmm3,%xmm8
    52c1:	66 0f 28 dc          	movapd %xmm4,%xmm3
    52c5:	66 0f 14 db          	unpcklpd %xmm3,%xmm3
    52c9:	66 41 0f 59 d9       	mulpd  %xmm9,%xmm3
    52ce:	66 44 0f 28 cd       	movapd %xmm5,%xmm9
    52d3:	f2 44 0f 59 cc       	mulsd  %xmm4,%xmm9
    52d8:	f2 0f 59 64 24 50    	mulsd  0x50(%rsp),%xmm4
    52de:	66 41 0f 58 d8       	addpd  %xmm8,%xmm3
    52e3:	66 45 0f 28 c4       	movapd %xmm12,%xmm8
    52e8:	66 45 0f 14 c0       	unpcklpd %xmm8,%xmm8
    52ed:	66 45 0f 59 c7       	mulpd  %xmm15,%xmm8
    52f2:	f2 44 0f 10 7c 24 48 	movsd  0x48(%rsp),%xmm15
    52f9:	f2 45 0f 59 fb       	mulsd  %xmm11,%xmm15
    52fe:	66 41 0f 58 d8       	addpd  %xmm8,%xmm3
    5303:	66 44 0f 28 c2       	movapd %xmm2,%xmm8
    5308:	f2 0f 10 54 24 20    	movsd  0x20(%rsp),%xmm2
    530e:	66 0f 59 9c 24 c0 00 	mulpd  0xc0(%rsp),%xmm3
    5315:	00 00 
    5317:	f2 44 0f 59 c0       	mulsd  %xmm0,%xmm8
    531c:	0f 29 9c 24 90 03 00 	movaps %xmm3,0x390(%rsp)
    5323:	00 
    5324:	66 41 0f 28 d9       	movapd %xmm9,%xmm3
    5329:	66 45 0f ef c9       	pxor   %xmm9,%xmm9
    532e:	f3 44 0f 5a 8c 24 e0 	cvtss2sd 0x1e0(%rsp),%xmm9
    5335:	01 00 00 
    5338:	f2 41 0f 58 d8       	addsd  %xmm8,%xmm3
    533d:	f2 44 0f 10 04 24    	movsd  (%rsp),%xmm8
    5343:	f2 45 0f 59 c4       	mulsd  %xmm12,%xmm8
    5348:	f2 44 0f 59 64 24 58 	mulsd  0x58(%rsp),%xmm12
    534f:	f2 41 0f 58 d8       	addsd  %xmm8,%xmm3
    5354:	f2 44 0f 10 44 24 50 	movsd  0x50(%rsp),%xmm8
    535b:	f2 0f 59 da          	mulsd  %xmm2,%xmm3
    535f:	f2 0f 11 9c 24 a0 03 	movsd  %xmm3,0x3a0(%rsp)
    5366:	00 00 
    5368:	66 0f ef db          	pxor   %xmm3,%xmm3
    536c:	f3 0f 5a 9c 24 dc 01 	cvtss2sd 0x1dc(%rsp),%xmm3
    5373:	00 00 
    5375:	f2 44 0f 59 c3       	mulsd  %xmm3,%xmm8
    537a:	f2 45 0f 58 c7       	addsd  %xmm15,%xmm8
    537f:	f2 44 0f 10 7c 24 58 	movsd  0x58(%rsp),%xmm15
    5386:	f2 45 0f 59 f9       	mulsd  %xmm9,%xmm15
    538b:	f2 45 0f 58 c7       	addsd  %xmm15,%xmm8
    5390:	66 45 0f ef ff       	pxor   %xmm15,%xmm15
    5395:	f3 45 0f 5a 7f 48    	cvtss2sd 0x48(%r15),%xmm15
    539b:	f2 44 0f 59 c2       	mulsd  %xmm2,%xmm8
    53a0:	f2 45 0f 58 c7       	addsd  %xmm15,%xmm8
    53a5:	f2 44 0f 10 bc 24 90 	movsd  0x90(%rsp),%xmm15
    53ac:	00 00 00 
    53af:	f2 45 0f 5e fd       	divsd  %xmm13,%xmm15
    53b4:	66 41 0f 28 d0       	movapd %xmm8,%xmm2
    53b9:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    53be:	f3 44 0f 5a 84 24 cc 	cvtss2sd 0x1cc(%rsp),%xmm8
    53c5:	01 00 00 
    53c8:	f2 44 0f 11 84 24 90 	movsd  %xmm8,0x90(%rsp)
    53cf:	00 00 00 
    53d2:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    53d7:	f3 44 0f 5a 84 24 d0 	cvtss2sd 0x1d0(%rsp),%xmm8
    53de:	01 00 00 
    53e1:	f2 44 0f 11 84 24 d8 	movsd  %xmm8,0xd8(%rsp)
    53e8:	00 00 00 
    53eb:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    53f0:	f3 45 0f 5a 47 44    	cvtss2sd 0x44(%r15),%xmm8
    53f6:	66 41 0f 14 d7       	unpcklpd %xmm15,%xmm2
    53fb:	66 45 0f ef ff       	pxor   %xmm15,%xmm15
    5400:	0f 29 94 24 e0 00 00 	movaps %xmm2,0xe0(%rsp)
    5407:	00 
    5408:	f2 0f 10 94 24 b0 00 	movsd  0xb0(%rsp),%xmm2
    540f:	00 00 
    5411:	f2 0f 59 54 24 48    	mulsd  0x48(%rsp),%xmm2
    5417:	f3 44 0f 5a bc 24 c8 	cvtss2sd 0x1c8(%rsp),%xmm15
    541e:	01 00 00 
    5421:	f2 0f 58 e2          	addsd  %xmm2,%xmm4
    5425:	f2 0f 10 54 24 20    	movsd  0x20(%rsp),%xmm2
    542b:	f2 41 0f 58 e4       	addsd  %xmm12,%xmm4
    5430:	66 44 0f 28 e7       	movapd %xmm7,%xmm12
    5435:	f2 45 0f 59 e3       	mulsd  %xmm11,%xmm12
    543a:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    543e:	f2 44 0f 58 c4       	addsd  %xmm4,%xmm8
    5443:	66 0f 28 e3          	movapd %xmm3,%xmm4
    5447:	f2 0f 59 e1          	mulsd  %xmm1,%xmm4
    544b:	f2 41 0f 58 e4       	addsd  %xmm12,%xmm4
    5450:	f2 44 0f 10 64 24 40 	movsd  0x40(%rsp),%xmm12
    5457:	f2 45 0f 59 e1       	mulsd  %xmm9,%xmm12
    545c:	f2 41 0f 58 e4       	addsd  %xmm12,%xmm4
    5461:	f2 44 0f 10 64 24 30 	movsd  0x30(%rsp),%xmm12
    5468:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    546c:	66 44 0f 14 c4       	unpcklpd %xmm4,%xmm8
    5471:	66 0f 28 e6          	movapd %xmm6,%xmm4
    5475:	44 0f 11 84 24 a8 03 	movups %xmm8,0x3a8(%rsp)
    547c:	00 00 
    547e:	f2 41 0f 59 e3       	mulsd  %xmm11,%xmm4
    5483:	f2 44 0f 59 d8       	mulsd  %xmm0,%xmm11
    5488:	66 44 0f 28 c4       	movapd %xmm4,%xmm8
    548d:	66 41 0f 28 e4       	movapd %xmm12,%xmm4
    5492:	f2 0f 59 e3          	mulsd  %xmm3,%xmm4
    5496:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    549a:	f2 41 0f 58 e0       	addsd  %xmm8,%xmm4
    549f:	f2 44 0f 10 44 24 38 	movsd  0x38(%rsp),%xmm8
    54a6:	48 8b 9c 24 d0 00 00 	mov    0xd0(%rsp),%rbx
    54ad:	00 
    54ae:	f2 41 0f 58 db       	addsd  %xmm11,%xmm3
    54b3:	f2 44 0f 10 5c 24 38 	movsd  0x38(%rsp),%xmm11
    54ba:	f2 45 0f 59 c1       	mulsd  %xmm9,%xmm8
    54bf:	48 8d 5c 9d 00       	lea    0x0(%rbp,%rbx,4),%rbx
    54c4:	f2 41 0f 58 e0       	addsd  %xmm8,%xmm4
    54c9:	66 44 0f 28 c2       	movapd %xmm2,%xmm8
    54ce:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    54d2:	f2 0f 10 14 24       	movsd  (%rsp),%xmm2
    54d7:	f2 44 0f 59 ca       	mulsd  %xmm2,%xmm9
    54dc:	f2 41 0f 58 d9       	addsd  %xmm9,%xmm3
    54e1:	f2 44 0f 10 4c 24 40 	movsd  0x40(%rsp),%xmm9
    54e8:	f2 41 0f 59 d8       	mulsd  %xmm8,%xmm3
    54ed:	66 0f 14 e3          	unpcklpd %xmm3,%xmm4
    54f1:	f2 0f 10 9c 24 a0 00 	movsd  0xa0(%rsp),%xmm3
    54f8:	00 00 
    54fa:	f2 0f 5c 9c 24 98 00 	subsd  0x98(%rsp),%xmm3
    5501:	00 00 
    5503:	0f 11 a4 24 b8 03 00 	movups %xmm4,0x3b8(%rsp)
    550a:	00 
    550b:	66 0f 28 a4 24 e0 00 	movapd 0xe0(%rsp),%xmm4
    5512:	00 00 
    5514:	0f 11 a4 24 c8 03 00 	movups %xmm4,0x3c8(%rsp)
    551b:	00 
    551c:	f2 41 0f 5e dd       	divsd  %xmm13,%xmm3
    5521:	f2 0f 10 a4 24 a8 00 	movsd  0xa8(%rsp),%xmm4
    5528:	00 00 
    552a:	f2 41 0f 5e e5       	divsd  %xmm13,%xmm4
    552f:	66 0f 14 dc          	unpcklpd %xmm4,%xmm3
    5533:	66 0f 28 e6          	movapd %xmm6,%xmm4
    5537:	0f 11 9c 24 d8 03 00 	movups %xmm3,0x3d8(%rsp)
    553e:	00 
    553f:	66 41 0f 28 db       	movapd %xmm11,%xmm3
    5544:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    5548:	f2 0f 59 d8          	mulsd  %xmm0,%xmm3
    554c:	f2 0f 5c dc          	subsd  %xmm4,%xmm3
    5550:	66 0f 28 e7          	movapd %xmm7,%xmm4
    5554:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    5558:	f2 0f 10 94 24 90 00 	movsd  0x90(%rsp),%xmm2
    555f:	00 00 
    5561:	f2 41 0f 5e dd       	divsd  %xmm13,%xmm3
    5566:	66 44 0f 28 c4       	movapd %xmm4,%xmm8
    556b:	66 41 0f 28 e1       	movapd %xmm9,%xmm4
    5570:	f2 0f 59 e0          	mulsd  %xmm0,%xmm4
    5574:	f2 44 0f 5c c4       	subsd  %xmm4,%xmm8
    5579:	66 41 0f 28 e3       	movapd %xmm11,%xmm4
    557e:	f2 0f 59 e7          	mulsd  %xmm7,%xmm4
    5582:	f2 45 0f 5e c5       	divsd  %xmm13,%xmm8
    5587:	66 41 0f 14 d8       	unpcklpd %xmm8,%xmm3
    558c:	0f 11 9c 24 e8 03 00 	movups %xmm3,0x3e8(%rsp)
    5593:	00 
    5594:	66 41 0f 28 d9       	movapd %xmm9,%xmm3
    5599:	f2 0f 59 de          	mulsd  %xmm6,%xmm3
    559d:	f2 0f 5c dc          	subsd  %xmm4,%xmm3
    55a1:	66 0f 28 e6          	movapd %xmm6,%xmm4
    55a5:	f2 0f 59 e5          	mulsd  %xmm5,%xmm4
    55a9:	f2 41 0f 5e dd       	divsd  %xmm13,%xmm3
    55ae:	66 44 0f 28 c4       	movapd %xmm4,%xmm8
    55b3:	66 41 0f 28 e4       	movapd %xmm12,%xmm4
    55b8:	f2 0f 59 e0          	mulsd  %xmm0,%xmm4
    55bc:	f2 44 0f 5c c4       	subsd  %xmm4,%xmm8
    55c1:	66 0f 28 e0          	movapd %xmm0,%xmm4
    55c5:	f2 0f 59 e1          	mulsd  %xmm1,%xmm4
    55c9:	f2 41 0f 59 c7       	mulsd  %xmm15,%xmm0
    55ce:	f2 45 0f 5e c5       	divsd  %xmm13,%xmm8
    55d3:	66 41 0f 14 d8       	unpcklpd %xmm8,%xmm3
    55d8:	66 44 0f 28 c4       	movapd %xmm4,%xmm8
    55dd:	66 41 0f 28 e4       	movapd %xmm12,%xmm4
    55e2:	0f 11 9c 24 f8 03 00 	movups %xmm3,0x3f8(%rsp)
    55e9:	00 
    55ea:	f2 0f 59 e7          	mulsd  %xmm7,%xmm4
    55ee:	66 0f 28 df          	movapd %xmm7,%xmm3
    55f2:	f2 0f 59 dd          	mulsd  %xmm5,%xmm3
    55f6:	f2 41 0f 59 ff       	mulsd  %xmm15,%xmm7
    55fb:	f2 44 0f 59 e2       	mulsd  %xmm2,%xmm12
    5600:	f2 0f 59 ea          	mulsd  %xmm2,%xmm5
    5604:	f2 44 0f 5c c3       	subsd  %xmm3,%xmm8
    5609:	66 0f 28 de          	movapd %xmm6,%xmm3
    560d:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
    5611:	f2 0f 59 ca          	mulsd  %xmm2,%xmm1
    5615:	f2 45 0f 5e c5       	divsd  %xmm13,%xmm8
    561a:	f2 0f 58 c5          	addsd  %xmm5,%xmm0
    561e:	f2 41 0f 59 f7       	mulsd  %xmm15,%xmm6
    5623:	f2 0f 5c e3          	subsd  %xmm3,%xmm4
    5627:	f2 0f 58 cf          	addsd  %xmm7,%xmm1
    562b:	66 0f 28 fa          	movapd %xmm2,%xmm7
    562f:	f2 0f 10 14 24       	movsd  (%rsp),%xmm2
    5634:	48 89 14 24          	mov    %rdx,(%rsp)
    5638:	f2 41 0f 5e e5       	divsd  %xmm13,%xmm4
    563d:	66 41 0f 28 d8       	movapd %xmm8,%xmm3
    5642:	66 0f 14 dc          	unpcklpd %xmm4,%xmm3
    5646:	66 41 0f 28 e3       	movapd %xmm11,%xmm4
    564b:	0f 11 9c 24 08 04 00 	movups %xmm3,0x408(%rsp)
    5652:	00 
    5653:	66 41 0f 28 d9       	movapd %xmm9,%xmm3
    5658:	f2 44 0f 10 8c 24 d8 	movsd  0xd8(%rsp),%xmm9
    565f:	00 00 00 
    5662:	f2 41 0f 59 d9       	mulsd  %xmm9,%xmm3
    5667:	f2 41 0f 59 e1       	mulsd  %xmm9,%xmm4
    566c:	f2 41 0f 59 d1       	mulsd  %xmm9,%xmm2
    5671:	f2 0f 58 cb          	addsd  %xmm3,%xmm1
    5675:	66 41 0f 28 dc       	movapd %xmm12,%xmm3
    567a:	f2 0f 58 de          	addsd  %xmm6,%xmm3
    567e:	f2 0f 58 c2          	addsd  %xmm2,%xmm0
    5682:	f2 0f 58 dc          	addsd  %xmm4,%xmm3
    5686:	f2 0f 11 84 24 28 04 	movsd  %xmm0,0x428(%rsp)
    568d:	00 00 
    568f:	f2 0f 10 44 24 48    	movsd  0x48(%rsp),%xmm0
    5695:	f2 41 0f 59 c7       	mulsd  %xmm15,%xmm0
    569a:	66 0f 14 cb          	unpcklpd %xmm3,%xmm1
    569e:	0f 11 8c 24 18 04 00 	movups %xmm1,0x418(%rsp)
    56a5:	00 
    56a6:	f2 0f 10 4c 24 50    	movsd  0x50(%rsp),%xmm1
    56ac:	f2 0f 59 cf          	mulsd  %xmm7,%xmm1
    56b0:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    56b4:	f2 0f 10 4c 24 58    	movsd  0x58(%rsp),%xmm1
    56ba:	f2 41 0f 59 c9       	mulsd  %xmm9,%xmm1
    56bf:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
    56c3:	f2 0f 11 84 24 30 04 	movsd  %xmm0,0x430(%rsp)
    56ca:	00 00 
    56cc:	f2 0f 10 08          	movsd  (%rax),%xmm1
    56d0:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 56d8 <ayatsuri_model_instance_evaluate+0x1b98>
    56d7:	00 
			56d4: R_X86_64_PC32	.LC22-0x4
    56d8:	66 0f 28 c1          	movapd %xmm1,%xmm0
    56dc:	66 0f 54 05 00 00 00 	andpd  0x0(%rip),%xmm0        # 56e4 <ayatsuri_model_instance_evaluate+0x1ba4>
    56e3:	00 
			56e0: R_X86_64_PC32	.LC8-0x4
    56e4:	66 0f 2e e8          	ucomisd %xmm0,%xmm5
    56e8:	72 36                	jb     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    56ea:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 56f2 <ayatsuri_model_instance_evaluate+0x1bb2>
    56f1:	00 
			56ee: R_X86_64_PC32	.LC38-0x4
    56f2:	73 2c                	jae    5720 <ayatsuri_model_instance_evaluate+0x1be0>
    56f4:	66 0f 2f 05 00 00 00 	comisd 0x0(%rip),%xmm0        # 56fc <ayatsuri_model_instance_evaluate+0x1bbc>
    56fb:	00 
			56f8: R_X86_64_PC32	.LC39-0x4
    56fc:	0f 86 de 00 00 00    	jbe    57e0 <ayatsuri_model_instance_evaluate+0x1ca0>
    5702:	66 0f ef d2          	pxor   %xmm2,%xmm2
    5706:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 570e <ayatsuri_model_instance_evaluate+0x1bce>
    570d:	00 
			570a: R_X86_64_PC32	.LC33-0x4
    570e:	66 0f 2f d1          	comisd %xmm1,%xmm2
    5712:	77 04                	ja     5718 <ayatsuri_model_instance_evaluate+0x1bd8>
    5714:	41 0f 28 c6          	movaps %xmm14,%xmm0
    5718:	f3 0f 11 03          	movss  %xmm0,(%rbx)
    571c:	0f 1f 40 00          	nopl   0x0(%rax)
    5720:	41 c6 87 a5 00 00 00 	movb   $0x0,0xa5(%r15)
    5727:	00 
    5728:	b8 02 00 00 00       	mov    $0x2,%eax
    572d:	e9 5d e5 ff ff       	jmp    3c8f <ayatsuri_model_instance_evaluate+0x14f>
    5732:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    5738:	66 45 0f ef db       	pxor   %xmm11,%xmm11
    573d:	0f 29 ac 24 90 03 00 	movaps %xmm5,0x390(%rsp)
    5744:	00 
    5745:	4c 8d ac 24 90 03 00 	lea    0x390(%rsp),%r13
    574c:	00 
    574d:	f3 44 0f 5a 9c 24 6c 	cvtss2sd 0x26c(%rsp),%xmm11
    5754:	02 00 00 
    5757:	f2 41 0f 59 f4       	mulsd  %xmm12,%xmm6
    575c:	f2 0f 11 9c 24 a0 03 	movsd  %xmm3,0x3a0(%rsp)
    5763:	00 00 
    5765:	f2 44 0f 11 8c 24 e8 	movsd  %xmm9,0x3e8(%rsp)
    576c:	03 00 00 
    576f:	f2 45 0f 59 eb       	mulsd  %xmm11,%xmm13
    5774:	f2 44 0f 59 e4       	mulsd  %xmm4,%xmm12
    5779:	f2 44 0f 59 d8       	mulsd  %xmm0,%xmm11
    577e:	66 0f 14 fe          	unpcklpd %xmm6,%xmm7
    5782:	66 44 0f 14 e9       	unpcklpd %xmm1,%xmm13
    5787:	0f 11 bc 24 a8 03 00 	movups %xmm7,0x3a8(%rsp)
    578e:	00 
    578f:	44 0f 11 ac 24 b8 03 	movups %xmm13,0x3b8(%rsp)
    5796:	00 00 
    5798:	66 45 0f 14 c4       	unpcklpd %xmm12,%xmm8
    579d:	44 0f 11 84 24 c8 03 	movups %xmm8,0x3c8(%rsp)
    57a4:	00 00 
    57a6:	66 44 0f 14 da       	unpcklpd %xmm2,%xmm11
    57ab:	44 0f 11 9c 24 d8 03 	movups %xmm11,0x3d8(%rsp)
    57b2:	00 00 
    57b4:	e9 45 ec ff ff       	jmp    43fe <ayatsuri_model_instance_evaluate+0x8be>
    57b9:	41 c6 87 a5 00 00 00 	movb   $0x0,0xa5(%r15)
    57c0:	00 
    57c1:	e9 c4 e4 ff ff       	jmp    3c8a <ayatsuri_model_instance_evaluate+0x14a>
    57c6:	41 c6 87 a5 00 00 00 	movb   $0x0,0xa5(%r15)
    57cd:	00 
    57ce:	31 c0                	xor    %eax,%eax
    57d0:	e9 ba e4 ff ff       	jmp    3c8f <ayatsuri_model_instance_evaluate+0x14f>
    57d5:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    57db:	e9 55 ed ff ff       	jmp    4535 <ayatsuri_model_instance_evaluate+0x9f5>
    57e0:	f2 0f 5a c9          	cvtsd2ss %xmm1,%xmm1
    57e4:	f3 0f 11 0b          	movss  %xmm1,(%rbx)
    57e8:	41 0f 54 ca          	andps  %xmm10,%xmm1
    57ec:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
    57f0:	83 f9 08             	cmp    $0x8,%ecx
    57f3:	0f 86 8b 08 00 00    	jbe    6084 <ayatsuri_model_instance_evaluate+0x2544>
    57f9:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 5801 <ayatsuri_model_instance_evaluate+0x1cc1>
    5800:	00 
			57fd: R_X86_64_PC32	.LC35-0x4
    5801:	66 0f 2f c8          	comisd %xmm0,%xmm1
    5805:	0f 87 15 ff ff ff    	ja     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    580b:	48 8b 94 24 70 01 00 	mov    0x170(%rsp),%rdx
    5812:	00 
    5813:	48 83 c0 08          	add    $0x8,%rax
    5817:	48 83 c3 04          	add    $0x4,%rbx
    581b:	83 c1 01             	add    $0x1,%ecx
    581e:	48 39 d0             	cmp    %rdx,%rax
    5821:	0f 85 a5 fe ff ff    	jne    56cc <ayatsuri_model_instance_evaluate+0x1b8c>
    5827:	83 84 24 88 01 00 00 	addl   $0x1,0x188(%rsp)
    582e:	01 
    582f:	8b 84 24 88 01 00 00 	mov    0x188(%rsp),%eax
    5836:	48 83 84 24 d0 00 00 	addq   $0x15,0xd0(%rsp)
    583d:	00 15 
    583f:	48 8b 14 24          	mov    (%rsp),%rdx
    5843:	39 c7                	cmp    %eax,%edi
    5845:	0f 85 93 f7 ff ff    	jne    4fde <ayatsuri_model_instance_evaluate+0x149e>
    584b:	48 8b 8c 24 98 01 00 	mov    0x198(%rsp),%rcx
    5852:	00 
    5853:	0f b7 c6             	movzwl %si,%eax
    5856:	8b b4 24 8c 01 00 00 	mov    0x18c(%rsp),%esi
    585d:	4c 89 5c 24 40       	mov    %r11,0x40(%rsp)
    5862:	48 6b c0 48          	imul   $0x48,%rax,%rax
    5866:	48 8b 9c 24 b8 00 00 	mov    0xb8(%rsp),%rbx
    586d:	00 
    586e:	4c 89 54 24 38       	mov    %r10,0x38(%rsp)
    5873:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
    5878:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
    587d:	48 01 f0             	add    %rsi,%rax
    5880:	48 01 c3             	add    %rax,%rbx
    5883:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
    588a:	00 
    588b:	8b 78 0c             	mov    0xc(%rax),%edi
    588e:	e8 cd a8 ff ff       	call   160 <pack_rgb>
    5893:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 589b <ayatsuri_model_instance_evaluate+0x1d5b>
    589a:	00 
			5897: R_X86_64_PC32	.LC5-0x4
    589b:	66 89 85 fc 00 00 00 	mov    %ax,0xfc(%rbp)
    58a2:	49 8b 47 08          	mov    0x8(%r15),%rax
    58a6:	f2 42 0f 59 04 c0    	mulsd  (%rax,%r8,8),%xmm0
    58ac:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 58b4 <ayatsuri_model_instance_evaluate+0x1d74>
    58b3:	00 
			58b0: R_X86_64_PC32	.LC6-0x4
    58b4:	e8 00 00 00 00       	call   58b9 <ayatsuri_model_instance_evaluate+0x1d79>
			58b5: R_X86_64_PLT32	floor-0x4
    58b9:	48 8d 7b 30          	lea    0x30(%rbx),%rdi
    58bd:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    58c1:	66 89 85 fe 00 00 00 	mov    %ax,0xfe(%rbp)
    58c8:	e8 33 a7 ff ff       	call   0 <md>
    58cd:	f2 0f 10 4c 24 68    	movsd  0x68(%rsp),%xmm1
    58d3:	f2 0f 11 04 24       	movsd  %xmm0,(%rsp)
    58d8:	f2 0f 10 44 24 60    	movsd  0x60(%rsp),%xmm0
    58de:	e8 00 00 00 00       	call   58e3 <ayatsuri_model_instance_evaluate+0x1da3>
			58df: R_X86_64_PLT32	hypot-0x4
    58e3:	f2 0f 10 4c 24 70    	movsd  0x70(%rsp),%xmm1
    58e9:	e8 00 00 00 00       	call   58ee <ayatsuri_model_instance_evaluate+0x1dae>
			58ea: R_X86_64_PLT32	hypot-0x4
    58ee:	f2 0f 59 04 24       	mulsd  (%rsp),%xmm0
    58f3:	f2 0f 10 0d 00 00 00 	movsd  0x0(%rip),%xmm1        # 58fb <ayatsuri_model_instance_evaluate+0x1dbb>
    58fa:	00 
			58f7: R_X86_64_PC32	.LC9-0x4
    58fb:	e8 00 00 00 00       	call   5900 <ayatsuri_model_instance_evaluate+0x1dc0>
			58fc: R_X86_64_PLT32	fmin-0x4
    5900:	f2 0f 59 05 00 00 00 	mulsd  0x0(%rip),%xmm0        # 5908 <ayatsuri_model_instance_evaluate+0x1dc8>
    5907:	00 
			5904: R_X86_64_PC32	.LC5-0x4
    5908:	f2 0f 58 05 00 00 00 	addsd  0x0(%rip),%xmm0        # 5910 <ayatsuri_model_instance_evaluate+0x1dd0>
    590f:	00 
			590c: R_X86_64_PC32	.LC6-0x4
    5910:	e8 00 00 00 00       	call   5915 <ayatsuri_model_instance_evaluate+0x1dd5>
			5911: R_X86_64_PLT32	floor-0x4
    5915:	48 8d 7b 40          	lea    0x40(%rbx),%rdi
    5919:	f2 0f 2c c0          	cvttsd2si %xmm0,%eax
    591d:	66 89 85 00 01 00 00 	mov    %ax,0x100(%rbp)
    5924:	e8 d7 a6 ff ff       	call   0 <md>
    5929:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 5931 <ayatsuri_model_instance_evaluate+0x1df1>
    5930:	00 
			592d: R_X86_64_PC32	.LC22-0x4
    5931:	66 0f 28 c8          	movapd %xmm0,%xmm1
    5935:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 593d <ayatsuri_model_instance_evaluate+0x1dfd>
    593c:	00 
			5939: R_X86_64_PC32	.LC8-0x4
    593d:	66 0f 2e f1          	ucomisd %xmm1,%xmm6
    5941:	0f 82 d9 fd ff ff    	jb     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    5947:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 594f <ayatsuri_model_instance_evaluate+0x1e0f>
    594e:	00 
			594b: R_X86_64_PC32	.LC38-0x4
    594f:	0f 83 cb fd ff ff    	jae    5720 <ayatsuri_model_instance_evaluate+0x1be0>
    5955:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 595d <ayatsuri_model_instance_evaluate+0x1e1d>
    595c:	00 
			5959: R_X86_64_PC32	.LC39-0x4
    595d:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    5962:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 596b <ayatsuri_model_instance_evaluate+0x1e2b>
    5969:	00 00 
			5967: R_X86_64_PC32	.LC0-0x4
    596b:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
    5970:	4c 8b 54 24 38       	mov    0x38(%rsp),%r10
    5975:	f3 44 0f 10 35 00 00 	movss  0x0(%rip),%xmm14        # 597e <ayatsuri_model_instance_evaluate+0x1e3e>
    597c:	00 00 
			597a: R_X86_64_PC32	.LC1-0x4
    597e:	4c 8b 5c 24 40       	mov    0x40(%rsp),%r11
    5983:	0f 86 86 03 00 00    	jbe    5d0f <ayatsuri_model_instance_evaluate+0x21cf>
    5989:	66 0f ef c9          	pxor   %xmm1,%xmm1
    598d:	66 0f 2f c8          	comisd %xmm0,%xmm1
    5991:	0f 87 fa 06 00 00    	ja     6091 <ayatsuri_model_instance_evaluate+0x2551>
    5997:	41 0f 28 c6          	movaps %xmm14,%xmm0
    599b:	45 8b 46 50          	mov    0x50(%r14),%r8d
    599f:	4d 8b 0e             	mov    (%r14),%r9
    59a2:	f3 0f 11 85 38 01 00 	movss  %xmm0,0x138(%rbp)
    59a9:	00 
    59aa:	41 8b 7e 4c          	mov    0x4c(%r14),%edi
    59ae:	45 85 c0             	test   %r8d,%r8d
    59b1:	0f 84 61 03 00 00    	je     5d18 <ayatsuri_model_instance_evaluate+0x21d8>
    59b7:	31 f6                	xor    %esi,%esi
    59b9:	eb 0c                	jmp    59c7 <ayatsuri_model_instance_evaluate+0x1e87>
    59bb:	83 c6 01             	add    $0x1,%esi
    59be:	41 39 f0             	cmp    %esi,%r8d
    59c1:	0f 84 51 03 00 00    	je     5d18 <ayatsuri_model_instance_evaluate+0x21d8>
    59c7:	89 f0                	mov    %esi,%eax
    59c9:	44 8b 74 24 18       	mov    0x18(%rsp),%r14d
    59ce:	c1 e0 05             	shl    $0x5,%eax
    59d1:	48 01 f8             	add    %rdi,%rax
    59d4:	4c 01 c8             	add    %r9,%rax
    59d7:	0f b7 18             	movzwl (%rax),%ebx
    59da:	44 39 f3             	cmp    %r14d,%ebx
    59dd:	75 dc                	jne    59bb <ayatsuri_model_instance_evaluate+0x1e7b>
    59df:	49 8b 77 08          	mov    0x8(%r15),%rsi
    59e3:	66 0f ef ed          	pxor   %xmm5,%xmm5
    59e7:	66 0f ef c0          	pxor   %xmm0,%xmm0
    59eb:	66 0f ef e4          	pxor   %xmm4,%xmm4
    59ef:	f3 41 0f 5a 47 34    	cvtss2sd 0x34(%r15),%xmm0
    59f5:	66 0f ef db          	pxor   %xmm3,%xmm3
    59f9:	66 0f 6f b4 24 a0 01 	movdqa 0x1a0(%rsp),%xmm6
    5a00:	00 00 
    5a02:	4c 8d 8c 24 10 02 00 	lea    0x210(%rsp),%r9
    5a09:	00 
    5a0a:	8b 54 16 08          	mov    0x8(%rsi,%rdx,1),%edx
    5a0e:	48 8d ac 24 f0 01 00 	lea    0x1f0(%rsp),%rbp
    5a15:	00 
    5a16:	0f 29 b4 24 10 02 00 	movaps %xmm6,0x210(%rsp)
    5a1d:	00 
    5a1e:	48 01 d6             	add    %rdx,%rsi
    5a21:	48 8d 94 24 c8 01 00 	lea    0x1c8(%rsp),%rdx
    5a28:	00 
    5a29:	f3 0f 5a 6e 0c       	cvtss2sd 0xc(%rsi),%xmm5
    5a2e:	f2 0f 5c e8          	subsd  %xmm0,%xmm5
    5a32:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5a36:	f3 0f 5a 66 1c       	cvtss2sd 0x1c(%rsi),%xmm4
    5a3b:	f3 41 0f 5a 47 38    	cvtss2sd 0x38(%r15),%xmm0
    5a41:	f2 0f 5c e0          	subsd  %xmm0,%xmm4
    5a45:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5a49:	4c 8d 76 0c          	lea    0xc(%rsi),%r14
    5a4d:	f3 0f 5a 5e 2c       	cvtss2sd 0x2c(%rsi),%xmm3
    5a52:	f3 41 0f 5a 47 3c    	cvtss2sd 0x3c(%r15),%xmm0
    5a58:	f2 0f 5c d8          	subsd  %xmm0,%xmm3
    5a5c:	48 89 94 24 20 02 00 	mov    %rdx,0x220(%rsp)
    5a63:	00 
    5a64:	31 d2                	xor    %edx,%edx
    5a66:	41 89 d0             	mov    %edx,%r8d
    5a69:	48 83 fa 02          	cmp    $0x2,%rdx
    5a6d:	0f 84 96 06 00 00    	je     6109 <ayatsuri_model_instance_evaluate+0x25c9>
    5a73:	66 0f ef f6          	pxor   %xmm6,%xmm6
    5a77:	f3 41 0f 5a 77 40    	cvtss2sd 0x40(%r15),%xmm6
    5a7d:	49 8b 3c d1          	mov    (%r9,%rdx,8),%rdi
    5a81:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5a85:	66 0f ef ff          	pxor   %xmm7,%xmm7
    5a89:	66 0f ef d2          	pxor   %xmm2,%xmm2
    5a8d:	47 8d 04 40          	lea    (%r8,%r8,2),%r8d
    5a91:	f3 0f 5a 07          	cvtss2sd (%rdi),%xmm0
    5a95:	f3 0f 5a 7f 04       	cvtss2sd 0x4(%rdi),%xmm7
    5a9a:	f3 0f 5a 57 08       	cvtss2sd 0x8(%rdi),%xmm2
    5a9f:	48 89 f7             	mov    %rsi,%rdi
    5aa2:	66 0f ef c9          	pxor   %xmm1,%xmm1
    5aa6:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    5aab:	44 89 c3             	mov    %r8d,%ebx
    5aae:	48 83 c7 04          	add    $0x4,%rdi
    5ab2:	f3 0f 5a 4f fc       	cvtss2sd -0x4(%rdi),%xmm1
    5ab7:	f3 44 0f 5a 47 0c    	cvtss2sd 0xc(%rdi),%xmm8
    5abd:	f2 0f 59 c8          	mulsd  %xmm0,%xmm1
    5ac1:	41 83 c0 01          	add    $0x1,%r8d
    5ac5:	f2 44 0f 59 c7       	mulsd  %xmm7,%xmm8
    5aca:	f2 41 0f 58 c8       	addsd  %xmm8,%xmm1
    5acf:	66 45 0f ef c0       	pxor   %xmm8,%xmm8
    5ad4:	f3 44 0f 5a 47 1c    	cvtss2sd 0x1c(%rdi),%xmm8
    5ada:	f2 44 0f 59 c2       	mulsd  %xmm2,%xmm8
    5adf:	f2 41 0f 58 c8       	addsd  %xmm8,%xmm1
    5ae4:	f2 0f 59 ce          	mulsd  %xmm6,%xmm1
    5ae8:	f2 0f 11 8c dc e0 02 	movsd  %xmm1,0x2e0(%rsp,%rbx,8)
    5aef:	00 00 
    5af1:	4c 39 f7             	cmp    %r14,%rdi
    5af4:	75 ac                	jne    5aa2 <ayatsuri_model_instance_evaluate+0x1f62>
    5af6:	f2 0f 59 c5          	mulsd  %xmm5,%xmm0
    5afa:	f2 0f 59 fc          	mulsd  %xmm4,%xmm7
    5afe:	f2 0f 59 d3          	mulsd  %xmm3,%xmm2
    5b02:	f2 0f 58 c7          	addsd  %xmm7,%xmm0
    5b06:	f2 0f 58 c2          	addsd  %xmm2,%xmm0
    5b0a:	f2 0f 59 c6          	mulsd  %xmm6,%xmm0
    5b0e:	f2 0f 11 44 d5 00    	movsd  %xmm0,0x0(%rbp,%rdx,8)
    5b14:	48 83 fa 02          	cmp    $0x2,%rdx
    5b18:	0f 84 05 02 00 00    	je     5d23 <ayatsuri_model_instance_evaluate+0x21e3>
    5b1e:	66 0f ef c9          	pxor   %xmm1,%xmm1
    5b22:	f3 41 0f 5a 4c 97 44 	cvtss2sd 0x44(%r15,%rdx,4),%xmm1
    5b29:	f2 0f 58 c8          	addsd  %xmm0,%xmm1
    5b2d:	f2 0f 11 4c d5 00    	movsd  %xmm1,0x0(%rbp,%rdx,8)
    5b33:	48 83 c2 01          	add    $0x1,%rdx
    5b37:	e9 2a ff ff ff       	jmp    5a66 <ayatsuri_model_instance_evaluate+0x1f26>
    5b3c:	0f 1f 40 00          	nopl   0x0(%rax)
    5b40:	48 8b 41 10          	mov    0x10(%rcx),%rax
    5b44:	48 8b 51 18          	mov    0x18(%rcx),%rdx
    5b48:	48 33 46 10          	xor    0x10(%rsi),%rax
    5b4c:	48 33 56 18          	xor    0x18(%rsi),%rdx
    5b50:	48 09 d0             	or     %rdx,%rax
    5b53:	0f 85 cc e1 ff ff    	jne    3d25 <ayatsuri_model_instance_evaluate+0x1e5>
    5b59:	8b 46 20             	mov    0x20(%rsi),%eax
    5b5c:	39 41 20             	cmp    %eax,0x20(%rcx)
    5b5f:	0f 85 c0 e1 ff ff    	jne    3d25 <ayatsuri_model_instance_evaluate+0x1e5>
    5b65:	49 39 cf             	cmp    %rcx,%r15
    5b68:	0f 82 0a 01 00 00    	jb     5c78 <ayatsuri_model_instance_evaluate+0x2138>
    5b6e:	4c 89 f8             	mov    %r15,%rax
    5b71:	48 29 c8             	sub    %rcx,%rax
    5b74:	48 83 f8 23          	cmp    $0x23,%rax
    5b78:	0f 86 a7 e1 ff ff    	jbe    3d25 <ayatsuri_model_instance_evaluate+0x1e5>
    5b7e:	4d 39 c7             	cmp    %r8,%r15
    5b81:	0f 82 49 01 00 00    	jb     5cd0 <ayatsuri_model_instance_evaluate+0x2190>
    5b87:	4c 89 f8             	mov    %r15,%rax
    5b8a:	4c 29 c0             	sub    %r8,%rax
    5b8d:	48 83 f8 17          	cmp    $0x17,%rax
    5b91:	0f 86 8e e1 ff ff    	jbe    3d25 <ayatsuri_model_instance_evaluate+0x1e5>
    5b97:	41 c6 87 a6 00 00 00 	movb   $0x0,0xa6(%r15)
    5b9e:	00 
    5b9f:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
    5ba4:	31 db                	xor    %ebx,%ebx
    5ba6:	49 8b 17             	mov    (%r15),%rdx
    5ba9:	41 0f 11 47 4c       	movups %xmm0,0x4c(%r15)
    5bae:	49 8b 40 10          	mov    0x10(%r8),%rax
    5bb2:	49 89 47 5c          	mov    %rax,0x5c(%r15)
    5bb6:	f3 41 0f 10 00       	movss  (%r8),%xmm0
    5bbb:	66 83 7a 0c 00       	cmpw   $0x0,0xc(%rdx)
    5bc0:	f3 41 0f 11 47 64    	movss  %xmm0,0x64(%r15)
    5bc6:	f3 41 0f 10 40 0c    	movss  0xc(%r8),%xmm0
    5bcc:	f3 41 0f 11 47 7c    	movss  %xmm0,0x7c(%r15)
    5bd2:	f3 41 0f 10 40 04    	movss  0x4(%r8),%xmm0
    5bd8:	f3 41 0f 11 47 68    	movss  %xmm0,0x68(%r15)
    5bde:	f3 41 0f 10 40 10    	movss  0x10(%r8),%xmm0
    5be4:	f3 41 0f 11 87 80 00 	movss  %xmm0,0x80(%r15)
    5beb:	00 00 
    5bed:	f3 41 0f 10 40 08    	movss  0x8(%r8),%xmm0
    5bf3:	f3 41 0f 11 47 6c    	movss  %xmm0,0x6c(%r15)
    5bf9:	f3 41 0f 10 40 14    	movss  0x14(%r8),%xmm0
    5bff:	f3 41 0f 11 87 84 00 	movss  %xmm0,0x84(%r15)
    5c06:	00 00 
    5c08:	75 16                	jne    5c20 <ayatsuri_model_instance_evaluate+0x20e0>
    5c0a:	e9 83 e9 ff ff       	jmp    4592 <ayatsuri_model_instance_evaluate+0xa52>
    5c0f:	90                   	nop
    5c10:	0f b7 42 0c          	movzwl 0xc(%rdx),%eax
    5c14:	48 83 c3 01          	add    $0x1,%rbx
    5c18:	39 c3                	cmp    %eax,%ebx
    5c1a:	0f 83 72 e9 ff ff    	jae    4592 <ayatsuri_model_instance_evaluate+0xa52>
    5c20:	8b 4a 14             	mov    0x14(%rdx),%ecx
    5c23:	48 89 d8             	mov    %rbx,%rax
    5c26:	48 c1 e0 04          	shl    $0x4,%rax
    5c2a:	48 03 02             	add    (%rdx),%rax
    5c2d:	0f b6 44 01 02       	movzbl 0x2(%rcx,%rax,1),%eax
    5c32:	3c 03                	cmp    $0x3,%al
    5c34:	74 1e                	je     5c54 <ayatsuri_model_instance_evaluate+0x2114>
    5c36:	84 c0                	test   %al,%al
    5c38:	74 d6                	je     5c10 <ayatsuri_model_instance_evaluate+0x20d0>
    5c3a:	41 8b 87 94 00 00 00 	mov    0x94(%r15),%eax
    5c41:	31 c9                	xor    %ecx,%ecx
    5c43:	83 f8 ff             	cmp    $0xffffffff,%eax
    5c46:	0f 95 c1             	setne  %cl
    5c49:	01 c8                	add    %ecx,%eax
    5c4b:	41 89 87 94 00 00 00 	mov    %eax,0x94(%r15)
    5c52:	eb bc                	jmp    5c10 <ayatsuri_model_instance_evaluate+0x20d0>
    5c54:	45 31 c0             	xor    %r8d,%r8d
    5c57:	31 c9                	xor    %ecx,%ecx
    5c59:	31 d2                	xor    %edx,%edx
    5c5b:	41 b9 01 00 00 00    	mov    $0x1,%r9d
    5c61:	89 de                	mov    %ebx,%esi
    5c63:	4c 89 ff             	mov    %r15,%rdi
    5c66:	e8 75 ab ff ff       	call   7e0 <mesh_packet>
    5c6b:	84 c0                	test   %al,%al
    5c6d:	0f 84 ad fa ff ff    	je     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    5c73:	49 8b 17             	mov    (%r15),%rdx
    5c76:	eb c2                	jmp    5c3a <ayatsuri_model_instance_evaluate+0x20fa>
    5c78:	48 89 c8             	mov    %rcx,%rax
    5c7b:	4c 29 f8             	sub    %r15,%rax
    5c7e:	48 3d a7 00 00 00    	cmp    $0xa7,%rax
    5c84:	0f 86 9b e0 ff ff    	jbe    3d25 <ayatsuri_model_instance_evaluate+0x1e5>
    5c8a:	e9 ef fe ff ff       	jmp    5b7e <ayatsuri_model_instance_evaluate+0x203e>
    5c8f:	f3 0f 10 15 00 00 00 	movss  0x0(%rip),%xmm2        # 5c97 <ayatsuri_model_instance_evaluate+0x2157>
    5c96:	00 
			5c93: R_X86_64_PC32	.LC17-0x4
    5c97:	66 44 0f 28 c3       	movapd %xmm3,%xmm8
    5c9c:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5ca0:	f3 44 0f 7e 0d 00 00 	movq   0x0(%rip),%xmm9        # 5ca9 <ayatsuri_model_instance_evaluate+0x2169>
    5ca7:	00 00 
			5ca5: R_X86_64_PC32	.LC26-0x4
    5ca9:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 5cb1 <ayatsuri_model_instance_evaluate+0x2171>
    5cb0:	00 
			5cad: R_X86_64_PC32	.LC9-0x4
    5cb1:	66 0f ef ff          	pxor   %xmm7,%xmm7
    5cb5:	44 0f 29 8c 24 80 00 	movaps %xmm9,0x80(%rsp)
    5cbc:	00 00 
    5cbe:	e9 cb e1 ff ff       	jmp    3e8e <ayatsuri_model_instance_evaluate+0x34e>
    5cc3:	66 0f ef c0          	pxor   %xmm0,%xmm0
    5cc7:	f2 0f 5a c1          	cvtsd2ss %xmm1,%xmm0
    5ccb:	e9 14 ec ff ff       	jmp    48e4 <ayatsuri_model_instance_evaluate+0xda4>
    5cd0:	4c 89 c0             	mov    %r8,%rax
    5cd3:	4c 29 f8             	sub    %r15,%rax
    5cd6:	48 3d a7 00 00 00    	cmp    $0xa7,%rax
    5cdc:	0f 87 b5 fe ff ff    	ja     5b97 <ayatsuri_model_instance_evaluate+0x2057>
    5ce2:	e9 3e e0 ff ff       	jmp    3d25 <ayatsuri_model_instance_evaluate+0x1e5>
    5ce7:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    5ceb:	e9 cf ec ff ff       	jmp    49bf <ayatsuri_model_instance_evaluate+0xe7f>
    5cf0:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 5cf8 <ayatsuri_model_instance_evaluate+0x21b8>
    5cf7:	00 
			5cf4: R_X86_64_PC32	.LC33-0x4
    5cf8:	e9 c2 ec ff ff       	jmp    49bf <ayatsuri_model_instance_evaluate+0xe7f>
    5cfd:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    5d01:	e9 4e ed ff ff       	jmp    4a54 <ayatsuri_model_instance_evaluate+0xf14>
    5d06:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    5d0a:	e9 40 ee ff ff       	jmp    4b4f <ayatsuri_model_instance_evaluate+0x100f>
    5d0f:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    5d13:	e9 83 fc ff ff       	jmp    599b <ayatsuri_model_instance_evaluate+0x1e5b>
    5d18:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    5d1e:	e9 1c e8 ff ff       	jmp    453f <ayatsuri_model_instance_evaluate+0x9ff>
    5d23:	f2 44 0f 10 9c 24 00 	movsd  0x300(%rsp),%xmm11
    5d2a:	03 00 00 
    5d2d:	f2 44 0f 10 84 24 08 	movsd  0x308(%rsp),%xmm8
    5d34:	03 00 00 
    5d37:	f2 0f 10 bc 24 18 03 	movsd  0x318(%rsp),%xmm7
    5d3e:	00 00 
    5d40:	f2 0f 10 84 24 20 03 	movsd  0x320(%rsp),%xmm0
    5d47:	00 00 
    5d49:	66 41 0f 28 eb       	movapd %xmm11,%xmm5
    5d4e:	66 41 0f 28 d8       	movapd %xmm8,%xmm3
    5d53:	f2 44 0f 10 8c 24 f8 	movsd  0x2f8(%rsp),%xmm9
    5d5a:	02 00 00 
    5d5d:	f2 0f 10 a4 24 10 03 	movsd  0x310(%rsp),%xmm4
    5d64:	00 00 
    5d66:	f2 0f 59 df          	mulsd  %xmm7,%xmm3
    5d6a:	66 45 0f 28 e8       	movapd %xmm8,%xmm13
    5d6f:	f2 0f 10 8c 24 e0 02 	movsd  0x2e0(%rsp),%xmm1
    5d76:	00 00 
    5d78:	f2 0f 10 b4 24 e8 02 	movsd  0x2e8(%rsp),%xmm6
    5d7f:	00 00 
    5d81:	f2 0f 59 e8          	mulsd  %xmm0,%xmm5
    5d85:	66 45 0f 28 e1       	movapd %xmm9,%xmm12
    5d8a:	66 45 0f 28 f9       	movapd %xmm9,%xmm15
    5d8f:	f2 0f 10 94 24 f0 02 	movsd  0x2f0(%rsp),%xmm2
    5d96:	00 00 
    5d98:	f2 44 0f 59 e7       	mulsd  %xmm7,%xmm12
    5d9d:	f2 44 0f 59 f8       	mulsd  %xmm0,%xmm15
    5da2:	f2 44 0f 59 ec       	mulsd  %xmm4,%xmm13
    5da7:	f2 0f 5c eb          	subsd  %xmm3,%xmm5
    5dab:	66 41 0f 28 db       	movapd %xmm11,%xmm3
    5db0:	f2 0f 59 dc          	mulsd  %xmm4,%xmm3
    5db4:	f2 44 0f 11 7c 24 20 	movsd  %xmm15,0x20(%rsp)
    5dbb:	f2 0f 11 2c 24       	movsd  %xmm5,(%rsp)
    5dc0:	f2 44 0f 5c e3       	subsd  %xmm3,%xmm12
    5dc5:	f2 0f 10 1c 24       	movsd  (%rsp),%xmm3
    5dca:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
    5dce:	66 41 0f 28 ec       	movapd %xmm12,%xmm5
    5dd3:	f2 44 0f 11 64 24 30 	movsd  %xmm12,0x30(%rsp)
    5dda:	66 45 0f 28 e7       	movapd %xmm15,%xmm12
    5ddf:	f2 45 0f 5c e5       	subsd  %xmm13,%xmm12
    5de4:	f2 44 0f 59 e6       	mulsd  %xmm6,%xmm12
    5de9:	f2 41 0f 5c dc       	subsd  %xmm12,%xmm3
    5dee:	66 44 0f 28 e5       	movapd %xmm5,%xmm12
    5df3:	f2 0f 10 2d 00 00 00 	movsd  0x0(%rip),%xmm5        # 5dfb <ayatsuri_model_instance_evaluate+0x22bb>
    5dfa:	00 
			5df7: R_X86_64_PC32	.LC22-0x4
    5dfb:	f2 44 0f 59 e2       	mulsd  %xmm2,%xmm12
    5e00:	f2 41 0f 58 dc       	addsd  %xmm12,%xmm3
    5e05:	66 44 0f 28 e3       	movapd %xmm3,%xmm12
    5e0a:	66 44 0f 54 25 00 00 	andpd  0x0(%rip),%xmm12        # 5e13 <ayatsuri_model_instance_evaluate+0x22d3>
    5e11:	00 00 
			5e0f: R_X86_64_PC32	.LC8-0x4
    5e13:	66 41 0f 2e ec       	ucomisd %xmm12,%xmm5
    5e18:	0f 82 02 f9 ff ff    	jb     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    5e1e:	66 45 0f ef e4       	pxor   %xmm12,%xmm12
    5e23:	66 41 0f 2e dc       	ucomisd %xmm12,%xmm3
    5e28:	7a 06                	jp     5e30 <ayatsuri_model_instance_evaluate+0x22f0>
    5e2a:	0f 84 f0 f8 ff ff    	je     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    5e30:	66 44 0f 28 fa       	movapd %xmm2,%xmm15
    5e35:	66 44 0f 28 e3       	movapd %xmm3,%xmm12
    5e3a:	f2 44 0f 5c 6c 24 20 	subsd  0x20(%rsp),%xmm13
    5e41:	31 ff                	xor    %edi,%edi
    5e43:	f2 44 0f 59 ff       	mulsd  %xmm7,%xmm15
    5e48:	66 45 0f 14 e4       	unpcklpd %xmm12,%xmm12
    5e4d:	f2 0f 59 f9          	mulsd  %xmm1,%xmm7
    5e51:	66 4c 0f 7e fa       	movq   %xmm15,%rdx
    5e56:	66 44 0f 28 fe       	movapd %xmm6,%xmm15
    5e5b:	f2 44 0f 59 f8       	mulsd  %xmm0,%xmm15
    5e60:	66 48 0f 6e ea       	movq   %rdx,%xmm5
    5e65:	48 8d 94 24 30 02 00 	lea    0x230(%rsp),%rdx
    5e6c:	00 
    5e6d:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    5e71:	f2 41 0f 5c ef       	subsd  %xmm15,%xmm5
    5e76:	f2 44 0f 10 3c 24    	movsd  (%rsp),%xmm15
    5e7c:	66 44 0f 14 fd       	unpcklpd %xmm5,%xmm15
    5e81:	66 41 0f 28 ef       	movapd %xmm15,%xmm5
    5e86:	66 44 0f 28 fe       	movapd %xmm6,%xmm15
    5e8b:	66 41 0f 5e ec       	divpd  %xmm12,%xmm5
    5e90:	f2 45 0f 59 f8       	mulsd  %xmm8,%xmm15
    5e95:	f2 44 0f 59 c1       	mulsd  %xmm1,%xmm8
    5e9a:	f2 41 0f 59 cb       	mulsd  %xmm11,%xmm1
    5e9f:	0f 29 ac 24 90 03 00 	movaps %xmm5,0x390(%rsp)
    5ea6:	00 
    5ea7:	66 0f 28 ea          	movapd %xmm2,%xmm5
    5eab:	f2 41 0f 59 eb       	mulsd  %xmm11,%xmm5
    5eb0:	f2 44 0f 5c fd       	subsd  %xmm5,%xmm15
    5eb5:	66 41 0f 28 ef       	movapd %xmm15,%xmm5
    5eba:	66 41 0f 14 ed       	unpcklpd %xmm13,%xmm5
    5ebf:	66 41 0f 5e ec       	divpd  %xmm12,%xmm5
    5ec4:	0f 29 ac 24 a0 03 00 	movaps %xmm5,0x3a0(%rsp)
    5ecb:	00 
    5ecc:	66 0f 28 ea          	movapd %xmm2,%xmm5
    5ed0:	f2 0f 59 ec          	mulsd  %xmm4,%xmm5
    5ed4:	f2 41 0f 59 d1       	mulsd  %xmm9,%xmm2
    5ed9:	f2 0f 59 e6          	mulsd  %xmm6,%xmm4
    5edd:	f2 41 0f 59 f1       	mulsd  %xmm9,%xmm6
    5ee2:	f2 0f 5c c5          	subsd  %xmm5,%xmm0
    5ee6:	f2 41 0f 5c d0       	subsd  %xmm8,%xmm2
    5eeb:	f2 0f 5c e7          	subsd  %xmm7,%xmm4
    5eef:	66 0f 14 c2          	unpcklpd %xmm2,%xmm0
    5ef3:	66 0f ef d2          	pxor   %xmm2,%xmm2
    5ef7:	66 41 0f 5e c4       	divpd  %xmm12,%xmm0
    5efc:	f3 0f 5a 50 08       	cvtss2sd 0x8(%rax),%xmm2
    5f01:	0f 29 84 24 b0 03 00 	movaps %xmm0,0x3b0(%rsp)
    5f08:	00 
    5f09:	f2 0f 10 44 24 30    	movsd  0x30(%rsp),%xmm0
    5f0f:	66 0f 14 c4          	unpcklpd %xmm4,%xmm0
    5f13:	66 41 0f 5e c4       	divpd  %xmm12,%xmm0
    5f18:	0f 29 84 24 c0 03 00 	movaps %xmm0,0x3c0(%rsp)
    5f1f:	00 
    5f20:	66 0f 28 c1          	movapd %xmm1,%xmm0
    5f24:	66 0f ef c9          	pxor   %xmm1,%xmm1
    5f28:	f2 0f 5c c6          	subsd  %xmm6,%xmm0
    5f2c:	f3 0f 5a 48 0c       	cvtss2sd 0xc(%rax),%xmm1
    5f31:	f2 0f 5e c3          	divsd  %xmm3,%xmm0
    5f35:	66 0f ef db          	pxor   %xmm3,%xmm3
    5f39:	f3 0f 5a 58 04       	cvtss2sd 0x4(%rax),%xmm3
    5f3e:	f2 0f 11 84 24 d0 03 	movsd  %xmm0,0x3d0(%rsp)
    5f45:	00 00 
    5f47:	f2 41 0f 10 45 00    	movsd  0x0(%r13),%xmm0
    5f4d:	f2 41 0f 10 65 18    	movsd  0x18(%r13),%xmm4
    5f53:	49 83 c5 08          	add    $0x8,%r13
    5f57:	f2 0f 59 e2          	mulsd  %xmm2,%xmm4
    5f5b:	f2 0f 59 c3          	mulsd  %xmm3,%xmm0
    5f5f:	f2 0f 58 c4          	addsd  %xmm4,%xmm0
    5f63:	f2 41 0f 10 65 28    	movsd  0x28(%r13),%xmm4
    5f69:	f2 0f 59 e1          	mulsd  %xmm1,%xmm4
    5f6d:	f2 0f 58 c4          	addsd  %xmm4,%xmm0
    5f71:	f2 0f 11 04 3a       	movsd  %xmm0,(%rdx,%rdi,1)
    5f76:	48 83 c7 08          	add    $0x8,%rdi
    5f7a:	48 83 ff 18          	cmp    $0x18,%rdi
    5f7e:	75 c7                	jne    5f47 <ayatsuri_model_instance_evaluate+0x2407>
    5f80:	f2 0f 10 84 24 30 02 	movsd  0x230(%rsp),%xmm0
    5f87:	00 00 
    5f89:	4d 8b 07             	mov    (%r15),%r8
    5f8c:	66 0f 57 84 24 80 00 	xorpd  0x80(%rsp),%xmm0
    5f93:	00 00 
    5f95:	f2 0f 10 8c 24 38 02 	movsd  0x238(%rsp),%xmm1
    5f9c:	00 00 
    5f9e:	f2 0f 59 84 24 f0 01 	mulsd  0x1f0(%rsp),%xmm0
    5fa5:	00 00 
    5fa7:	41 8b 78 14          	mov    0x14(%r8),%edi
    5fab:	f2 0f 59 8c 24 f8 01 	mulsd  0x1f8(%rsp),%xmm1
    5fb2:	00 00 
    5fb4:	48 01 f9             	add    %rdi,%rcx
    5fb7:	49 03 08             	add    (%r8),%rcx
    5fba:	0f b6 79 02          	movzbl 0x2(%rcx),%edi
    5fbe:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    5fc2:	f2 0f 10 8c 24 40 02 	movsd  0x240(%rsp),%xmm1
    5fc9:	00 00 
    5fcb:	f2 0f 59 8c 24 00 02 	mulsd  0x200(%rsp),%xmm1
    5fd2:	00 00 
    5fd4:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    5fd8:	66 0f ef c9          	pxor   %xmm1,%xmm1
    5fdc:	f3 0f 5a 48 10       	cvtss2sd 0x10(%rax),%xmm1
    5fe1:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    5fe5:	f2 0f 11 84 24 48 02 	movsd  %xmm0,0x248(%rsp)
    5fec:	00 00 
    5fee:	40 84 ff             	test   %dil,%dil
    5ff1:	0f 84 d3 01 00 00    	je     61ca <ayatsuri_model_instance_evaluate+0x268a>
    5ff7:	40 80 ef 01          	sub    $0x1,%dil
    5ffb:	0f 84 bf 01 00 00    	je     61c0 <ayatsuri_model_instance_evaluate+0x2680>
    6001:	0f b7 49 06          	movzwl 0x6(%rcx),%ecx
    6005:	6b c9 6c             	imul   $0x6c,%ecx,%ecx
    6008:	81 c1 3c 01 00 00    	add    $0x13c,%ecx
    600e:	89 cf                	mov    %ecx,%edi
    6010:	45 31 c0             	xor    %r8d,%r8d
    6013:	c1 ef 02             	shr    $0x2,%edi
    6016:	48 8d 3c be          	lea    (%rsi,%rdi,4),%rdi
    601a:	f2 42 0f 10 04 42    	movsd  (%rdx,%r8,2),%xmm0
    6020:	f2 0f 10 3d 00 00 00 	movsd  0x0(%rip),%xmm7        # 6028 <ayatsuri_model_instance_evaluate+0x24e8>
    6027:	00 
			6024: R_X86_64_PC32	.LC22-0x4
    6028:	66 0f 28 c8          	movapd %xmm0,%xmm1
    602c:	66 0f 54 0d 00 00 00 	andpd  0x0(%rip),%xmm1        # 6034 <ayatsuri_model_instance_evaluate+0x24f4>
    6033:	00 
			6030: R_X86_64_PC32	.LC8-0x4
    6034:	66 0f 2e f9          	ucomisd %xmm1,%xmm7
    6038:	0f 82 e2 f6 ff ff    	jb     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    603e:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 6046 <ayatsuri_model_instance_evaluate+0x2506>
    6045:	00 
			6042: R_X86_64_PC32	.LC38-0x4
    6046:	0f 83 d4 f6 ff ff    	jae    5720 <ayatsuri_model_instance_evaluate+0x1be0>
    604c:	66 0f 2f 0d 00 00 00 	comisd 0x0(%rip),%xmm1        # 6054 <ayatsuri_model_instance_evaluate+0x2514>
    6053:	00 
			6050: R_X86_64_PC32	.LC39-0x4
    6054:	0f 86 ec 00 00 00    	jbe    6146 <ayatsuri_model_instance_evaluate+0x2606>
    605a:	66 0f ef c9          	pxor   %xmm1,%xmm1
    605e:	66 0f 2f c8          	comisd %xmm0,%xmm1
    6062:	0f 87 d1 00 00 00    	ja     6139 <ayatsuri_model_instance_evaluate+0x25f9>
    6068:	41 0f 28 c6          	movaps %xmm14,%xmm0
    606c:	f3 42 0f 11 04 07    	movss  %xmm0,(%rdi,%r8,1)
    6072:	e9 a9 f6 ff ff       	jmp    5720 <ayatsuri_model_instance_evaluate+0x1be0>
    6077:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 607f <ayatsuri_model_instance_evaluate+0x253f>
    607e:	00 
			607b: R_X86_64_PC32	.LC33-0x4
    607f:	e9 cb ea ff ff       	jmp    4b4f <ayatsuri_model_instance_evaluate+0x100f>
    6084:	f2 0f 10 05 00 00 00 	movsd  0x0(%rip),%xmm0        # 608c <ayatsuri_model_instance_evaluate+0x254c>
    608b:	00 
			6088: R_X86_64_PC32	.LC34-0x4
    608c:	e9 70 f7 ff ff       	jmp    5801 <ayatsuri_model_instance_evaluate+0x1cc1>
    6091:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 6099 <ayatsuri_model_instance_evaluate+0x2559>
    6098:	00 
			6095: R_X86_64_PC32	.LC33-0x4
    6099:	e9 fd f8 ff ff       	jmp    599b <ayatsuri_model_instance_evaluate+0x1e5b>
    609e:	8b 7e 18             	mov    0x18(%rsi),%edi
    60a1:	48 89 14 24          	mov    %rdx,(%rsp)
    60a5:	e8 b6 a0 ff ff       	call   160 <pack_rgb>
    60aa:	48 8b 14 24          	mov    (%rsp),%rdx
    60ae:	66 c7 85 f0 00 00 00 	movw   $0x4,0xf0(%rbp)
    60b5:	04 00 
    60b7:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 60c0 <ayatsuri_model_instance_evaluate+0x2580>
    60be:	00 00 
			60bc: R_X86_64_PC32	.LC0-0x4
    60c0:	66 89 85 ea 00 00 00 	mov    %ax,0xea(%rbp)
    60c7:	31 c0                	xor    %eax,%eax
    60c9:	8b 7c 06 04          	mov    0x4(%rsi,%rax,1),%edi
    60cd:	89 bc 05 c4 00 00 00 	mov    %edi,0xc4(%rbp,%rax,1)
    60d4:	48 83 c0 04          	add    $0x4,%rax
    60d8:	48 83 f8 14          	cmp    $0x14,%rax
    60dc:	75 eb                	jne    60c9 <ayatsuri_model_instance_evaluate+0x2589>
    60de:	c7 85 d8 00 00 00 00 	movl   $0x0,0xd8(%rbp)
    60e5:	00 00 00 
    60e8:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    60ee:	e9 42 e4 ff ff       	jmp    4535 <ayatsuri_model_instance_evaluate+0x9f5>
    60f3:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 60fb <ayatsuri_model_instance_evaluate+0x25bb>
    60fa:	00 
			60f7: R_X86_64_PC32	.LC33-0x4
    60fb:	e9 89 ec ff ff       	jmp    4d89 <ayatsuri_model_instance_evaluate+0x1249>
    6100:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    6104:	e9 80 ec ff ff       	jmp    4d89 <ayatsuri_model_instance_evaluate+0x1249>
    6109:	f2 0f 10 35 00 00 00 	movsd  0x0(%rip),%xmm6        # 6111 <ayatsuri_model_instance_evaluate+0x25d1>
    6110:	00 
			610d: R_X86_64_PC32	.LC9-0x4
    6111:	e9 67 f9 ff ff       	jmp    5a7d <ayatsuri_model_instance_evaluate+0x1f3d>
    6116:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 611e <ayatsuri_model_instance_evaluate+0x25de>
    611d:	00 
			611a: R_X86_64_PC32	.LC33-0x4
    611e:	e9 31 e9 ff ff       	jmp    4a54 <ayatsuri_model_instance_evaluate+0xf14>
    6123:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 612b <ayatsuri_model_instance_evaluate+0x25eb>
    612a:	00 
			6127: R_X86_64_PC32	.LC33-0x4
    612b:	e9 bd ea ff ff       	jmp    4bed <ayatsuri_model_instance_evaluate+0x10ad>
    6130:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    6134:	e9 b4 ea ff ff       	jmp    4bed <ayatsuri_model_instance_evaluate+0x10ad>
    6139:	f3 0f 10 05 00 00 00 	movss  0x0(%rip),%xmm0        # 6141 <ayatsuri_model_instance_evaluate+0x2601>
    6140:	00 
			613d: R_X86_64_PC32	.LC33-0x4
    6141:	e9 26 ff ff ff       	jmp    606c <ayatsuri_model_instance_evaluate+0x252c>
    6146:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
    614a:	f3 42 0f 11 04 07    	movss  %xmm0,(%rdi,%r8,1)
    6150:	41 0f 54 c2          	andps  %xmm10,%xmm0
    6154:	0f 2f 05 00 00 00 00 	comiss 0x0(%rip),%xmm0        # 615b <ayatsuri_model_instance_evaluate+0x261b>
			6157: R_X86_64_PC32	.LC43-0x4
    615b:	0f 87 bf f5 ff ff    	ja     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    6161:	49 83 c0 04          	add    $0x4,%r8
    6165:	49 83 f8 10          	cmp    $0x10,%r8
    6169:	0f 85 ab fe ff ff    	jne    601a <ayatsuri_model_instance_evaluate+0x24da>
    616f:	66 0f ef c0          	pxor   %xmm0,%xmm0
    6173:	0f 2e 07             	ucomiss (%rdi),%xmm0
    6176:	7a 16                	jp     618e <ayatsuri_model_instance_evaluate+0x264e>
    6178:	75 14                	jne    618e <ayatsuri_model_instance_evaluate+0x264e>
    617a:	0f 2e 47 04          	ucomiss 0x4(%rdi),%xmm0
    617e:	7a 0e                	jp     618e <ayatsuri_model_instance_evaluate+0x264e>
    6180:	75 0c                	jne    618e <ayatsuri_model_instance_evaluate+0x264e>
    6182:	0f 2e 47 08          	ucomiss 0x8(%rdi),%xmm0
    6186:	7a 06                	jp     618e <ayatsuri_model_instance_evaluate+0x264e>
    6188:	0f 84 92 f5 ff ff    	je     5720 <ayatsuri_model_instance_evaluate+0x1be0>
    618e:	8b 50 14             	mov    0x14(%rax),%edx
    6191:	89 57 10             	mov    %edx,0x10(%rdi)
    6194:	8b 78 18             	mov    0x18(%rax),%edi
    6197:	e8 c4 9f ff ff       	call   160 <pack_rgb>
    619c:	f3 44 0f 10 15 00 00 	movss  0x0(%rip),%xmm10        # 61a5 <ayatsuri_model_instance_evaluate+0x2665>
    61a3:	00 00 
			61a1: R_X86_64_PC32	.LC0-0x4
    61a5:	89 c2                	mov    %eax,%edx
    61a7:	8d 41 14             	lea    0x14(%rcx),%eax
    61aa:	66 89 14 06          	mov    %dx,(%rsi,%rax,1)
    61ae:	66 c7 44 06 02 00 00 	movw   $0x0,0x2(%rsi,%rax,1)
    61b5:	41 0f b6 7c 24 02    	movzbl 0x2(%r12),%edi
    61bb:	e9 7f e3 ff ff       	jmp    453f <ayatsuri_model_instance_evaluate+0x9ff>
    61c0:	b9 08 01 00 00       	mov    $0x108,%ecx
    61c5:	e9 44 fe ff ff       	jmp    600e <ayatsuri_model_instance_evaluate+0x24ce>
    61ca:	b9 54 00 00 00       	mov    $0x54,%ecx
    61cf:	e9 3a fe ff ff       	jmp    600e <ayatsuri_model_instance_evaluate+0x24ce>
    61d4:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    61db:	00 00 00 00 
    61df:	90                   	nop

00000000000061e0 <ayatsuri_model_instance_next>:
    61e0:	48 85 ff             	test   %rdi,%rdi
    61e3:	0f 84 7e 00 00 00    	je     6267 <ayatsuri_model_instance_next+0x87>
    61e9:	80 bf a4 00 00 00 01 	cmpb   $0x1,0xa4(%rdi)
    61f0:	49 89 fa             	mov    %rdi,%r10
    61f3:	75 72                	jne    6267 <ayatsuri_model_instance_next+0x87>
    61f5:	48 85 f6             	test   %rsi,%rsi
    61f8:	74 6d                	je     6267 <ayatsuri_model_instance_next+0x87>
    61fa:	48 3b 77 10          	cmp    0x10(%rdi),%rsi
    61fe:	75 67                	jne    6267 <ayatsuri_model_instance_next+0x87>
    6200:	3b 57 20             	cmp    0x20(%rdi),%edx
    6203:	75 62                	jne    6267 <ayatsuri_model_instance_next+0x87>
    6205:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    620c:	b8 04 00 00 00       	mov    $0x4,%eax
    6211:	75 4a                	jne    625d <ayatsuri_model_instance_next+0x7d>
    6213:	80 bf a6 00 00 00 00 	cmpb   $0x0,0xa6(%rdi)
    621a:	c6 87 a5 00 00 00 01 	movb   $0x1,0xa5(%rdi)
    6221:	74 3d                	je     6260 <ayatsuri_model_instance_next+0x80>
    6223:	48 85 c9             	test   %rcx,%rcx
    6226:	74 28                	je     6250 <ayatsuri_model_instance_next+0x70>
    6228:	4d 85 c0             	test   %r8,%r8
    622b:	74 23                	je     6250 <ayatsuri_model_instance_next+0x70>
    622d:	49 39 c8             	cmp    %rcx,%r8
    6230:	73 3e                	jae    6270 <ayatsuri_model_instance_next+0x90>
    6232:	48 89 c8             	mov    %rcx,%rax
    6235:	4c 29 c0             	sub    %r8,%rax
    6238:	48 83 f8 17          	cmp    $0x17,%rax
    623c:	76 12                	jbe    6250 <ayatsuri_model_instance_next+0x70>
    623e:	49 39 ca             	cmp    %rcx,%r10
    6241:	72 3d                	jb     6280 <ayatsuri_model_instance_next+0xa0>
    6243:	4c 89 d0             	mov    %r10,%rax
    6246:	48 29 c8             	sub    %rcx,%rax
    6249:	48 83 f8 03          	cmp    $0x3,%rax
    624d:	77 3f                	ja     628e <ayatsuri_model_instance_next+0xae>
    624f:	90                   	nop
    6250:	41 c6 82 a5 00 00 00 	movb   $0x0,0xa5(%r10)
    6257:	00 
    6258:	b8 01 00 00 00       	mov    $0x1,%eax
    625d:	c3                   	ret
    625e:	66 90                	xchg   %ax,%ax
    6260:	c6 87 a5 00 00 00 00 	movb   $0x0,0xa5(%rdi)
    6267:	b8 03 00 00 00       	mov    $0x3,%eax
    626c:	c3                   	ret
    626d:	0f 1f 00             	nopl   (%rax)
    6270:	4c 89 c0             	mov    %r8,%rax
    6273:	48 29 c8             	sub    %rcx,%rax
    6276:	48 83 f8 03          	cmp    $0x3,%rax
    627a:	76 d4                	jbe    6250 <ayatsuri_model_instance_next+0x70>
    627c:	eb c0                	jmp    623e <ayatsuri_model_instance_next+0x5e>
    627e:	66 90                	xchg   %ax,%ax
    6280:	48 89 c8             	mov    %rcx,%rax
    6283:	4c 29 d0             	sub    %r10,%rax
    6286:	48 3d a7 00 00 00    	cmp    $0xa7,%rax
    628c:	76 c2                	jbe    6250 <ayatsuri_model_instance_next+0x70>
    628e:	49 8b 3a             	mov    (%r10),%rdi
    6291:	48 39 cf             	cmp    %rcx,%rdi
    6294:	0f 83 e6 01 00 00    	jae    6480 <ayatsuri_model_instance_next+0x2a0>
    629a:	48 89 c8             	mov    %rcx,%rax
    629d:	48 29 f8             	sub    %rdi,%rax
    62a0:	48 83 f8 7f          	cmp    $0x7f,%rax
    62a4:	76 aa                	jbe    6250 <ayatsuri_model_instance_next+0x70>
    62a6:	49 8b 42 18          	mov    0x18(%r10),%rax
    62aa:	49 8b 52 08          	mov    0x8(%r10),%rdx
    62ae:	48 85 c0             	test   %rax,%rax
    62b1:	74 1d                	je     62d0 <ayatsuri_model_instance_next+0xf0>
    62b3:	48 39 ca             	cmp    %rcx,%rdx
    62b6:	0f 82 34 02 00 00    	jb     64f0 <ayatsuri_model_instance_next+0x310>
    62bc:	48 89 d6             	mov    %rdx,%rsi
    62bf:	48 29 ce             	sub    %rcx,%rsi
    62c2:	48 83 fe 03          	cmp    $0x3,%rsi
    62c6:	76 88                	jbe    6250 <ayatsuri_model_instance_next+0x70>
    62c8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    62cf:	00 
    62d0:	41 56                	push   %r14
    62d2:	41 55                	push   %r13
    62d4:	41 54                	push   %r12
    62d6:	55                   	push   %rbp
    62d7:	53                   	push   %rbx
    62d8:	48 83 ec 18          	sub    $0x18,%rsp
    62dc:	44 8b 4f 08          	mov    0x8(%rdi),%r9d
    62e0:	48 8b 1f             	mov    (%rdi),%rbx
    62e3:	4d 85 c9             	test   %r9,%r9
    62e6:	74 28                	je     6310 <ayatsuri_model_instance_next+0x130>
    62e8:	48 39 cb             	cmp    %rcx,%rbx
    62eb:	0f 82 13 02 00 00    	jb     6504 <ayatsuri_model_instance_next+0x324>
    62f1:	48 89 de             	mov    %rbx,%rsi
    62f4:	48 29 ce             	sub    %rcx,%rsi
    62f7:	48 83 fe 03          	cmp    $0x3,%rsi
    62fb:	0f 86 aa 01 00 00    	jbe    64ab <ayatsuri_model_instance_next+0x2cb>
    6301:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    6308:	00 00 00 00 
    630c:	0f 1f 40 00          	nopl   0x0(%rax)
    6310:	4d 39 c2             	cmp    %r8,%r10
    6313:	0f 82 7f 01 00 00    	jb     6498 <ayatsuri_model_instance_next+0x2b8>
    6319:	4c 89 d6             	mov    %r10,%rsi
    631c:	4c 29 c6             	sub    %r8,%rsi
    631f:	48 83 fe 17          	cmp    $0x17,%rsi
    6323:	0f 86 82 01 00 00    	jbe    64ab <ayatsuri_model_instance_next+0x2cb>
    6329:	4c 39 c7             	cmp    %r8,%rdi
    632c:	0f 82 e2 01 00 00    	jb     6514 <ayatsuri_model_instance_next+0x334>
    6332:	48 89 fe             	mov    %rdi,%rsi
    6335:	4c 29 c6             	sub    %r8,%rsi
    6338:	48 83 fe 17          	cmp    $0x17,%rsi
    633c:	0f 86 69 01 00 00    	jbe    64ab <ayatsuri_model_instance_next+0x2cb>
    6342:	48 85 c0             	test   %rax,%rax
    6345:	74 19                	je     6360 <ayatsuri_model_instance_next+0x180>
    6347:	4c 39 c2             	cmp    %r8,%rdx
    634a:	0f 82 d5 01 00 00    	jb     6525 <ayatsuri_model_instance_next+0x345>
    6350:	48 89 d0             	mov    %rdx,%rax
    6353:	4c 29 c0             	sub    %r8,%rax
    6356:	48 83 f8 17          	cmp    $0x17,%rax
    635a:	0f 86 4b 01 00 00    	jbe    64ab <ayatsuri_model_instance_next+0x2cb>
    6360:	4d 85 c9             	test   %r9,%r9
    6363:	74 19                	je     637e <ayatsuri_model_instance_next+0x19e>
    6365:	4c 39 c3             	cmp    %r8,%rbx
    6368:	0f 82 cb 01 00 00    	jb     6539 <ayatsuri_model_instance_next+0x359>
    636e:	48 89 d8             	mov    %rbx,%rax
    6371:	4c 29 c0             	sub    %r8,%rax
    6374:	48 83 f8 17          	cmp    $0x17,%rax
    6378:	0f 86 2d 01 00 00    	jbe    64ab <ayatsuri_model_instance_next+0x2cb>
    637e:	8b 29                	mov    (%rcx),%ebp
    6380:	0f b7 77 0c          	movzwl 0xc(%rdi),%esi
    6384:	39 ee                	cmp    %ebp,%esi
    6386:	0f 82 1f 01 00 00    	jb     64ab <ayatsuri_model_instance_next+0x2cb>
    638c:	39 f5                	cmp    %esi,%ebp
    638e:	0f 83 47 01 00 00    	jae    64db <ayatsuri_model_instance_next+0x2fb>
    6394:	44 8b 67 14          	mov    0x14(%rdi),%r12d
    6398:	89 e8                	mov    %ebp,%eax
    639a:	c1 e0 04             	shl    $0x4,%eax
    639d:	49 01 dc             	add    %rbx,%r12
    63a0:	49 01 c4             	add    %rax,%r12
    63a3:	89 e8                	mov    %ebp,%eax
    63a5:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
    63a9:	48 8d 44 c2 08       	lea    0x8(%rdx,%rax,8),%rax
    63ae:	66 90                	xchg   %ax,%ax
    63b0:	45 0f b6 6c 24 02    	movzbl 0x2(%r12),%r13d
    63b6:	45 84 ed             	test   %r13b,%r13b
    63b9:	0f 84 09 01 00 00    	je     64c8 <ayatsuri_model_instance_next+0x2e8>
    63bf:	80 78 09 00          	cmpb   $0x0,0x9(%rax)
    63c3:	0f 84 ff 00 00 00    	je     64c8 <ayatsuri_model_instance_next+0x2e8>
    63c9:	44 8b 30             	mov    (%rax),%r14d
    63cc:	49 01 d6             	add    %rdx,%r14
    63cf:	41 80 fd 03          	cmp    $0x3,%r13b
    63d3:	0f 85 74 01 00 00    	jne    654d <ayatsuri_model_instance_next+0x36d>
    63d9:	41 80 7e 55 00       	cmpb   $0x0,0x55(%r14)
    63de:	0f 84 e4 00 00 00    	je     64c8 <ayatsuri_model_instance_next+0x2e8>
    63e4:	89 ee                	mov    %ebp,%esi
    63e6:	4c 89 e2             	mov    %r12,%rdx
    63e9:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
    63ee:	41 bd 04 00 00 00    	mov    $0x4,%r13d
    63f4:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    63f9:	48 89 3c 24          	mov    %rdi,(%rsp)
    63fd:	e8 1e a3 ff ff       	call   720 <node_slot_bytes>
    6402:	48 8b 3c 24          	mov    (%rsp),%rdi
    6406:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
    640b:	89 ee                	mov    %ebp,%esi
    640d:	41 89 c3             	mov    %eax,%r11d
    6410:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
    6415:	4d 8d 4a 64          	lea    0x64(%r10),%r9
    6419:	8b 47 78             	mov    0x78(%rdi),%eax
    641c:	85 c0                	test   %eax,%eax
    641e:	74 1b                	je     643b <ayatsuri_model_instance_next+0x25b>
    6420:	41 0f b7 44 24 08    	movzwl 0x8(%r12),%eax
    6426:	8b 57 74             	mov    0x74(%rdi),%edx
    6429:	c1 e0 02             	shl    $0x2,%eax
    642c:	48 01 c3             	add    %rax,%rbx
    642f:	80 3c 13 01          	cmpb   $0x1,(%rbx,%rdx,1)
    6433:	41 0f 94 c5          	sete   %r13b
    6437:	41 83 c5 04          	add    $0x4,%r13d
    643b:	41 0f b7 44 24 06    	movzwl 0x6(%r12),%eax
    6441:	83 c5 01             	add    $0x1,%ebp
    6444:	4d 89 30             	mov    %r14,(%r8)
    6447:	4d 89 48 08          	mov    %r9,0x8(%r8)
    644b:	41 88 40 15          	mov    %al,0x15(%r8)
    644f:	31 c0                	xor    %eax,%eax
    6451:	66 41 89 70 10       	mov    %si,0x10(%r8)
    6456:	66 45 89 58 12       	mov    %r11w,0x12(%r8)
    645b:	45 88 68 14          	mov    %r13b,0x14(%r8)
    645f:	89 29                	mov    %ebp,(%rcx)
    6461:	41 c6 82 a5 00 00 00 	movb   $0x0,0xa5(%r10)
    6468:	00 
    6469:	48 83 c4 18          	add    $0x18,%rsp
    646d:	5b                   	pop    %rbx
    646e:	5d                   	pop    %rbp
    646f:	41 5c                	pop    %r12
    6471:	41 5d                	pop    %r13
    6473:	41 5e                	pop    %r14
    6475:	c3                   	ret
    6476:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    647d:	00 00 00 
    6480:	48 89 f8             	mov    %rdi,%rax
    6483:	48 29 c8             	sub    %rcx,%rax
    6486:	48 83 f8 03          	cmp    $0x3,%rax
    648a:	0f 86 c0 fd ff ff    	jbe    6250 <ayatsuri_model_instance_next+0x70>
    6490:	e9 11 fe ff ff       	jmp    62a6 <ayatsuri_model_instance_next+0xc6>
    6495:	0f 1f 00             	nopl   (%rax)
    6498:	4c 89 c6             	mov    %r8,%rsi
    649b:	4c 29 d6             	sub    %r10,%rsi
    649e:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    64a5:	0f 87 7e fe ff ff    	ja     6329 <ayatsuri_model_instance_next+0x149>
    64ab:	41 c6 82 a5 00 00 00 	movb   $0x0,0xa5(%r10)
    64b2:	00 
    64b3:	48 83 c4 18          	add    $0x18,%rsp
    64b7:	b8 01 00 00 00       	mov    $0x1,%eax
    64bc:	5b                   	pop    %rbx
    64bd:	5d                   	pop    %rbp
    64be:	41 5c                	pop    %r12
    64c0:	41 5d                	pop    %r13
    64c2:	41 5e                	pop    %r14
    64c4:	c3                   	ret
    64c5:	0f 1f 00             	nopl   (%rax)
    64c8:	83 c5 01             	add    $0x1,%ebp
    64cb:	49 83 c4 10          	add    $0x10,%r12
    64cf:	48 83 c0 18          	add    $0x18,%rax
    64d3:	39 ee                	cmp    %ebp,%esi
    64d5:	0f 85 d5 fe ff ff    	jne    63b0 <ayatsuri_model_instance_next+0x1d0>
    64db:	89 31                	mov    %esi,(%rcx)
    64dd:	b8 05 00 00 00       	mov    $0x5,%eax
    64e2:	41 c6 82 a5 00 00 00 	movb   $0x0,0xa5(%r10)
    64e9:	00 
    64ea:	e9 7a ff ff ff       	jmp    6469 <ayatsuri_model_instance_next+0x289>
    64ef:	90                   	nop
    64f0:	48 89 ce             	mov    %rcx,%rsi
    64f3:	48 29 d6             	sub    %rdx,%rsi
    64f6:	48 39 c6             	cmp    %rax,%rsi
    64f9:	0f 82 51 fd ff ff    	jb     6250 <ayatsuri_model_instance_next+0x70>
    64ff:	e9 cc fd ff ff       	jmp    62d0 <ayatsuri_model_instance_next+0xf0>
    6504:	48 89 ce             	mov    %rcx,%rsi
    6507:	48 29 de             	sub    %rbx,%rsi
    650a:	4c 39 ce             	cmp    %r9,%rsi
    650d:	72 9c                	jb     64ab <ayatsuri_model_instance_next+0x2cb>
    650f:	e9 fc fd ff ff       	jmp    6310 <ayatsuri_model_instance_next+0x130>
    6514:	4c 89 c6             	mov    %r8,%rsi
    6517:	48 29 fe             	sub    %rdi,%rsi
    651a:	48 83 fe 7f          	cmp    $0x7f,%rsi
    651e:	76 8b                	jbe    64ab <ayatsuri_model_instance_next+0x2cb>
    6520:	e9 1d fe ff ff       	jmp    6342 <ayatsuri_model_instance_next+0x162>
    6525:	4c 89 c6             	mov    %r8,%rsi
    6528:	48 29 d6             	sub    %rdx,%rsi
    652b:	48 39 c6             	cmp    %rax,%rsi
    652e:	0f 82 77 ff ff ff    	jb     64ab <ayatsuri_model_instance_next+0x2cb>
    6534:	e9 27 fe ff ff       	jmp    6360 <ayatsuri_model_instance_next+0x180>
    6539:	4c 89 c0             	mov    %r8,%rax
    653c:	48 29 d8             	sub    %rbx,%rax
    653f:	4c 39 c8             	cmp    %r9,%rax
    6542:	0f 82 63 ff ff ff    	jb     64ab <ayatsuri_model_instance_next+0x2cb>
    6548:	e9 31 fe ff ff       	jmp    637e <ayatsuri_model_instance_next+0x19e>
    654d:	89 ee                	mov    %ebp,%esi
    654f:	4c 89 e2             	mov    %r12,%rdx
    6552:	4c 89 44 24 08       	mov    %r8,0x8(%rsp)
    6557:	48 89 0c 24          	mov    %rcx,(%rsp)
    655b:	e8 c0 a1 ff ff       	call   720 <node_slot_bytes>
    6560:	41 80 fd 02          	cmp    $0x2,%r13b
    6564:	48 8b 0c 24          	mov    (%rsp),%rcx
    6568:	89 ee                	mov    %ebp,%esi
    656a:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
    656f:	89 c3                	mov    %eax,%ebx
    6571:	4d 8d 4a 64          	lea    0x64(%r10),%r9
    6575:	41 89 c3             	mov    %eax,%r11d
    6578:	0f 85 bd fe ff ff    	jne    643b <ayatsuri_model_instance_next+0x25b>
    657e:	4c 89 e7             	mov    %r12,%rdi
    6581:	e8 4a 9d ff ff       	call   2d0 <slot_bytes>
    6586:	39 d8                	cmp    %ebx,%eax
    6588:	0f 83 ad fe ff ff    	jae    643b <ayatsuri_model_instance_next+0x25b>
    658e:	41 bd 03 00 00 00    	mov    $0x3,%r13d
    6594:	e9 a2 fe ff ff       	jmp    643b <ayatsuri_model_instance_next+0x25b>
    6599:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

00000000000065a0 <ayatsuri_model_instance_mesh_view>:
    65a0:	48 89 f8             	mov    %rdi,%rax
    65a3:	48 85 ff             	test   %rdi,%rdi
    65a6:	0f 84 84 00 00 00    	je     6630 <ayatsuri_model_instance_mesh_view+0x90>
    65ac:	80 bf a4 00 00 00 01 	cmpb   $0x1,0xa4(%rdi)
    65b3:	75 7b                	jne    6630 <ayatsuri_model_instance_mesh_view+0x90>
    65b5:	48 85 f6             	test   %rsi,%rsi
    65b8:	74 76                	je     6630 <ayatsuri_model_instance_mesh_view+0x90>
    65ba:	48 3b 77 10          	cmp    0x10(%rdi),%rsi
    65be:	75 70                	jne    6630 <ayatsuri_model_instance_mesh_view+0x90>
    65c0:	3b 57 20             	cmp    0x20(%rdi),%edx
    65c3:	75 6b                	jne    6630 <ayatsuri_model_instance_mesh_view+0x90>
    65c5:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    65cc:	ba 04 00 00 00       	mov    $0x4,%edx
    65d1:	75 62                	jne    6635 <ayatsuri_model_instance_mesh_view+0x95>
    65d3:	80 bf a6 00 00 00 00 	cmpb   $0x0,0xa6(%rdi)
    65da:	c6 87 a5 00 00 00 01 	movb   $0x1,0xa5(%rdi)
    65e1:	74 45                	je     6628 <ayatsuri_model_instance_mesh_view+0x88>
    65e3:	4d 85 c0             	test   %r8,%r8
    65e6:	74 2e                	je     6616 <ayatsuri_model_instance_mesh_view+0x76>
    65e8:	48 8b 17             	mov    (%rdi),%rdx
    65eb:	66 3b 4a 0c          	cmp    0xc(%rdx),%cx
    65ef:	73 25                	jae    6616 <ayatsuri_model_instance_mesh_view+0x76>
    65f1:	4c 39 c7             	cmp    %r8,%rdi
    65f4:	73 4a                	jae    6640 <ayatsuri_model_instance_mesh_view+0xa0>
    65f6:	4c 89 c6             	mov    %r8,%rsi
    65f9:	48 29 fe             	sub    %rdi,%rsi
    65fc:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    6603:	76 11                	jbe    6616 <ayatsuri_model_instance_mesh_view+0x76>
    6605:	4c 39 c2             	cmp    %r8,%rdx
    6608:	72 46                	jb     6650 <ayatsuri_model_instance_mesh_view+0xb0>
    660a:	48 89 d6             	mov    %rdx,%rsi
    660d:	4c 29 c6             	sub    %r8,%rsi
    6610:	48 83 fe 17          	cmp    $0x17,%rsi
    6614:	77 46                	ja     665c <ayatsuri_model_instance_mesh_view+0xbc>
    6616:	ba 01 00 00 00       	mov    $0x1,%edx
    661b:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    6622:	89 d0                	mov    %edx,%eax
    6624:	c3                   	ret
    6625:	0f 1f 00             	nopl   (%rax)
    6628:	c6 87 a5 00 00 00 00 	movb   $0x0,0xa5(%rdi)
    662f:	90                   	nop
    6630:	ba 03 00 00 00       	mov    $0x3,%edx
    6635:	89 d0                	mov    %edx,%eax
    6637:	c3                   	ret
    6638:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    663f:	00 
    6640:	48 89 fe             	mov    %rdi,%rsi
    6643:	4c 29 c6             	sub    %r8,%rsi
    6646:	48 83 fe 17          	cmp    $0x17,%rsi
    664a:	76 ca                	jbe    6616 <ayatsuri_model_instance_mesh_view+0x76>
    664c:	eb b7                	jmp    6605 <ayatsuri_model_instance_mesh_view+0x65>
    664e:	66 90                	xchg   %ax,%ax
    6650:	4c 89 c6             	mov    %r8,%rsi
    6653:	48 29 d6             	sub    %rdx,%rsi
    6656:	48 83 fe 7f          	cmp    $0x7f,%rsi
    665a:	76 ba                	jbe    6616 <ayatsuri_model_instance_mesh_view+0x76>
    665c:	48 8b 70 18          	mov    0x18(%rax),%rsi
    6660:	48 8b 78 08          	mov    0x8(%rax),%rdi
    6664:	48 85 f6             	test   %rsi,%rsi
    6667:	74 17                	je     6680 <ayatsuri_model_instance_mesh_view+0xe0>
    6669:	4c 39 c7             	cmp    %r8,%rdi
    666c:	0f 82 de 00 00 00    	jb     6750 <ayatsuri_model_instance_mesh_view+0x1b0>
    6672:	48 89 fe             	mov    %rdi,%rsi
    6675:	4c 29 c6             	sub    %r8,%rsi
    6678:	48 83 fe 17          	cmp    $0x17,%rsi
    667c:	76 98                	jbe    6616 <ayatsuri_model_instance_mesh_view+0x76>
    667e:	66 90                	xchg   %ax,%ax
    6680:	8b 72 08             	mov    0x8(%rdx),%esi
    6683:	4c 8b 12             	mov    (%rdx),%r10
    6686:	48 85 f6             	test   %rsi,%rsi
    6689:	0f 85 a1 00 00 00    	jne    6730 <ayatsuri_model_instance_mesh_view+0x190>
    668f:	49 89 c9             	mov    %rcx,%r9
    6692:	8b 72 14             	mov    0x14(%rdx),%esi
    6695:	49 c1 e1 04          	shl    $0x4,%r9
    6699:	41 81 e1 f0 ff 0f 00 	and    $0xffff0,%r9d
    66a0:	4c 01 ce             	add    %r9,%rsi
    66a3:	4c 01 d6             	add    %r10,%rsi
    66a6:	80 7e 02 03          	cmpb   $0x3,0x2(%rsi)
    66aa:	0f 85 66 ff ff ff    	jne    6616 <ayatsuri_model_instance_mesh_view+0x76>
    66b0:	44 8b 4a 78          	mov    0x78(%rdx),%r9d
    66b4:	45 85 c9             	test   %r9d,%r9d
    66b7:	74 18                	je     66d1 <ayatsuri_model_instance_mesh_view+0x131>
    66b9:	0f b7 76 08          	movzwl 0x8(%rsi),%esi
    66bd:	8b 52 74             	mov    0x74(%rdx),%edx
    66c0:	c1 e6 02             	shl    $0x2,%esi
    66c3:	49 01 f2             	add    %rsi,%r10
    66c6:	41 80 3c 12 01       	cmpb   $0x1,(%r10,%rdx,1)
    66cb:	0f 84 45 ff ff ff    	je     6616 <ayatsuri_model_instance_mesh_view+0x76>
    66d1:	0f b7 d1             	movzwl %cx,%edx
    66d4:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
    66d8:	48 8d 14 d7          	lea    (%rdi,%rdx,8),%rdx
    66dc:	80 7a 11 00          	cmpb   $0x0,0x11(%rdx)
    66e0:	0f 84 30 ff ff ff    	je     6616 <ayatsuri_model_instance_mesh_view+0x76>
    66e6:	8b 52 08             	mov    0x8(%rdx),%edx
    66e9:	48 01 d7             	add    %rdx,%rdi
    66ec:	0f b6 77 54          	movzbl 0x54(%rdi),%esi
    66f0:	48 8d 57 54          	lea    0x54(%rdi),%rdx
    66f4:	66 41 89 48 10       	mov    %cx,0x10(%r8)
    66f9:	49 89 10             	mov    %rdx,(%r8)
    66fc:	48 8d 14 f5 00 00 00 	lea    0x0(,%rsi,8),%rdx
    6703:	00 
    6704:	41 88 70 12          	mov    %sil,0x12(%r8)
    6708:	81 e2 f8 07 00 00    	and    $0x7f8,%edx
    670e:	48 8d 94 17 64 04 00 	lea    0x464(%rdi,%rdx,1),%rdx
    6715:	00 
    6716:	49 89 50 08          	mov    %rdx,0x8(%r8)
    671a:	31 d2                	xor    %edx,%edx
    671c:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    6723:	e9 0d ff ff ff       	jmp    6635 <ayatsuri_model_instance_mesh_view+0x95>
    6728:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    672f:	00 
    6730:	4d 39 c2             	cmp    %r8,%r10
    6733:	72 33                	jb     6768 <ayatsuri_model_instance_mesh_view+0x1c8>
    6735:	4c 89 d6             	mov    %r10,%rsi
    6738:	4c 29 c6             	sub    %r8,%rsi
    673b:	48 83 fe 17          	cmp    $0x17,%rsi
    673f:	0f 86 d1 fe ff ff    	jbe    6616 <ayatsuri_model_instance_mesh_view+0x76>
    6745:	e9 45 ff ff ff       	jmp    668f <ayatsuri_model_instance_mesh_view+0xef>
    674a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    6750:	4d 89 c1             	mov    %r8,%r9
    6753:	49 29 f9             	sub    %rdi,%r9
    6756:	49 39 f1             	cmp    %rsi,%r9
    6759:	0f 82 b7 fe ff ff    	jb     6616 <ayatsuri_model_instance_mesh_view+0x76>
    675f:	e9 1c ff ff ff       	jmp    6680 <ayatsuri_model_instance_mesh_view+0xe0>
    6764:	0f 1f 40 00          	nopl   0x0(%rax)
    6768:	4d 89 c1             	mov    %r8,%r9
    676b:	4d 29 d1             	sub    %r10,%r9
    676e:	49 39 f1             	cmp    %rsi,%r9
    6771:	0f 83 18 ff ff ff    	jae    668f <ayatsuri_model_instance_mesh_view+0xef>
    6777:	e9 9a fe ff ff       	jmp    6616 <ayatsuri_model_instance_mesh_view+0x76>
    677c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000006780 <ayatsuri_model_instance_sided_mesh_view>:
    6780:	48 89 f8             	mov    %rdi,%rax
    6783:	48 85 ff             	test   %rdi,%rdi
    6786:	0f 84 84 00 00 00    	je     6810 <ayatsuri_model_instance_sided_mesh_view+0x90>
    678c:	80 bf a4 00 00 00 01 	cmpb   $0x1,0xa4(%rdi)
    6793:	75 7b                	jne    6810 <ayatsuri_model_instance_sided_mesh_view+0x90>
    6795:	48 85 f6             	test   %rsi,%rsi
    6798:	74 76                	je     6810 <ayatsuri_model_instance_sided_mesh_view+0x90>
    679a:	48 3b 77 10          	cmp    0x10(%rdi),%rsi
    679e:	75 70                	jne    6810 <ayatsuri_model_instance_sided_mesh_view+0x90>
    67a0:	3b 57 20             	cmp    0x20(%rdi),%edx
    67a3:	75 6b                	jne    6810 <ayatsuri_model_instance_sided_mesh_view+0x90>
    67a5:	80 bf a5 00 00 00 00 	cmpb   $0x0,0xa5(%rdi)
    67ac:	ba 04 00 00 00       	mov    $0x4,%edx
    67b1:	75 62                	jne    6815 <ayatsuri_model_instance_sided_mesh_view+0x95>
    67b3:	80 bf a6 00 00 00 00 	cmpb   $0x0,0xa6(%rdi)
    67ba:	c6 87 a5 00 00 00 01 	movb   $0x1,0xa5(%rdi)
    67c1:	74 45                	je     6808 <ayatsuri_model_instance_sided_mesh_view+0x88>
    67c3:	4d 85 c0             	test   %r8,%r8
    67c6:	74 2e                	je     67f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    67c8:	48 8b 17             	mov    (%rdi),%rdx
    67cb:	66 3b 4a 0c          	cmp    0xc(%rdx),%cx
    67cf:	73 25                	jae    67f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    67d1:	4c 39 c7             	cmp    %r8,%rdi
    67d4:	73 4a                	jae    6820 <ayatsuri_model_instance_sided_mesh_view+0xa0>
    67d6:	4c 89 c6             	mov    %r8,%rsi
    67d9:	48 29 fe             	sub    %rdi,%rsi
    67dc:	48 81 fe a7 00 00 00 	cmp    $0xa7,%rsi
    67e3:	76 11                	jbe    67f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    67e5:	4c 39 c2             	cmp    %r8,%rdx
    67e8:	72 46                	jb     6830 <ayatsuri_model_instance_sided_mesh_view+0xb0>
    67ea:	48 89 d6             	mov    %rdx,%rsi
    67ed:	4c 29 c6             	sub    %r8,%rsi
    67f0:	48 83 fe 27          	cmp    $0x27,%rsi
    67f4:	77 46                	ja     683c <ayatsuri_model_instance_sided_mesh_view+0xbc>
    67f6:	ba 01 00 00 00       	mov    $0x1,%edx
    67fb:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    6802:	89 d0                	mov    %edx,%eax
    6804:	c3                   	ret
    6805:	0f 1f 00             	nopl   (%rax)
    6808:	c6 87 a5 00 00 00 00 	movb   $0x0,0xa5(%rdi)
    680f:	90                   	nop
    6810:	ba 03 00 00 00       	mov    $0x3,%edx
    6815:	89 d0                	mov    %edx,%eax
    6817:	c3                   	ret
    6818:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    681f:	00 
    6820:	48 89 fe             	mov    %rdi,%rsi
    6823:	4c 29 c6             	sub    %r8,%rsi
    6826:	48 83 fe 27          	cmp    $0x27,%rsi
    682a:	76 ca                	jbe    67f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    682c:	eb b7                	jmp    67e5 <ayatsuri_model_instance_sided_mesh_view+0x65>
    682e:	66 90                	xchg   %ax,%ax
    6830:	4c 89 c6             	mov    %r8,%rsi
    6833:	48 29 d6             	sub    %rdx,%rsi
    6836:	48 83 fe 7f          	cmp    $0x7f,%rsi
    683a:	76 ba                	jbe    67f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    683c:	48 8b 78 18          	mov    0x18(%rax),%rdi
    6840:	48 8b 70 08          	mov    0x8(%rax),%rsi
    6844:	48 85 ff             	test   %rdi,%rdi
    6847:	74 17                	je     6860 <ayatsuri_model_instance_sided_mesh_view+0xe0>
    6849:	4c 39 c6             	cmp    %r8,%rsi
    684c:	0f 82 fe 00 00 00    	jb     6950 <ayatsuri_model_instance_sided_mesh_view+0x1d0>
    6852:	48 89 f7             	mov    %rsi,%rdi
    6855:	4c 29 c7             	sub    %r8,%rdi
    6858:	48 83 ff 27          	cmp    $0x27,%rdi
    685c:	76 98                	jbe    67f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    685e:	66 90                	xchg   %ax,%ax
    6860:	8b 7a 08             	mov    0x8(%rdx),%edi
    6863:	4c 8b 0a             	mov    (%rdx),%r9
    6866:	48 85 ff             	test   %rdi,%rdi
    6869:	0f 85 c1 00 00 00    	jne    6930 <ayatsuri_model_instance_sided_mesh_view+0x1b0>
    686f:	49 89 ca             	mov    %rcx,%r10
    6872:	8b 7a 14             	mov    0x14(%rdx),%edi
    6875:	49 c1 e2 04          	shl    $0x4,%r10
    6879:	41 81 e2 f0 ff 0f 00 	and    $0xffff0,%r10d
    6880:	4c 01 d7             	add    %r10,%rdi
    6883:	4c 01 cf             	add    %r9,%rdi
    6886:	80 7f 02 03          	cmpb   $0x3,0x2(%rdi)
    688a:	0f 85 66 ff ff ff    	jne    67f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6890:	44 8b 52 78          	mov    0x78(%rdx),%r10d
    6894:	45 85 d2             	test   %r10d,%r10d
    6897:	0f 84 59 ff ff ff    	je     67f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    689d:	0f b7 7f 08          	movzwl 0x8(%rdi),%edi
    68a1:	8b 52 74             	mov    0x74(%rdx),%edx
    68a4:	c1 e7 02             	shl    $0x2,%edi
    68a7:	49 01 f9             	add    %rdi,%r9
    68aa:	41 80 3c 11 01       	cmpb   $0x1,(%r9,%rdx,1)
    68af:	0f 85 41 ff ff ff    	jne    67f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    68b5:	0f b7 d1             	movzwl %cx,%edx
    68b8:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
    68bc:	48 8d 14 d6          	lea    (%rsi,%rdx,8),%rdx
    68c0:	80 7a 11 00          	cmpb   $0x0,0x11(%rdx)
    68c4:	0f 84 2c ff ff ff    	je     67f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    68ca:	44 8b 5a 08          	mov    0x8(%rdx),%r11d
    68ce:	4e 8d 0c 1e          	lea    (%rsi,%r11,1),%r9
    68d2:	41 0f b6 79 54       	movzbl 0x54(%r9),%edi
    68d7:	66 41 89 48 20       	mov    %cx,0x20(%r8)
    68dc:	8d 14 3f             	lea    (%rdi,%rdi,1),%edx
    68df:	41 89 fa             	mov    %edi,%r10d
    68e2:	01 d7                	add    %edx,%edi
    68e4:	48 63 d2             	movslq %edx,%rdx
    68e7:	45 88 50 22          	mov    %r10b,0x22(%r8)
    68eb:	8d 3c bd 6b 04 00 00 	lea    0x46b(,%rdi,4),%edi
    68f2:	81 e7 f8 1f 00 00    	and    $0x1ff8,%edi
    68f8:	4c 01 df             	add    %r11,%rdi
    68fb:	48 01 fe             	add    %rdi,%rsi
    68fe:	49 8d 79 54          	lea    0x54(%r9),%rdi
    6902:	49 89 38             	mov    %rdi,(%r8)
    6905:	49 8d bc 91 64 04 00 	lea    0x464(%r9,%rdx,4),%rdi
    690c:	00 
    690d:	48 8d 14 56          	lea    (%rsi,%rdx,2),%rdx
    6911:	49 89 50 18          	mov    %rdx,0x18(%r8)
    6915:	31 d2                	xor    %edx,%edx
    6917:	49 89 78 08          	mov    %rdi,0x8(%r8)
    691b:	49 89 70 10          	mov    %rsi,0x10(%r8)
    691f:	c6 80 a5 00 00 00 00 	movb   $0x0,0xa5(%rax)
    6926:	e9 ea fe ff ff       	jmp    6815 <ayatsuri_model_instance_sided_mesh_view+0x95>
    692b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    6930:	4d 39 c1             	cmp    %r8,%r9
    6933:	72 33                	jb     6968 <ayatsuri_model_instance_sided_mesh_view+0x1e8>
    6935:	4c 89 cf             	mov    %r9,%rdi
    6938:	4c 29 c7             	sub    %r8,%rdi
    693b:	48 83 ff 27          	cmp    $0x27,%rdi
    693f:	0f 86 b1 fe ff ff    	jbe    67f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    6945:	e9 25 ff ff ff       	jmp    686f <ayatsuri_model_instance_sided_mesh_view+0xef>
    694a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    6950:	4d 89 c1             	mov    %r8,%r9
    6953:	49 29 f1             	sub    %rsi,%r9
    6956:	49 39 f9             	cmp    %rdi,%r9
    6959:	0f 82 97 fe ff ff    	jb     67f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
    695f:	e9 fc fe ff ff       	jmp    6860 <ayatsuri_model_instance_sided_mesh_view+0xe0>
    6964:	0f 1f 40 00          	nopl   0x0(%rax)
    6968:	4d 89 c2             	mov    %r8,%r10
    696b:	4d 29 ca             	sub    %r9,%r10
    696e:	49 39 fa             	cmp    %rdi,%r10
    6971:	0f 83 f8 fe ff ff    	jae    686f <ayatsuri_model_instance_sided_mesh_view+0xef>
    6977:	e9 7a fe ff ff       	jmp    67f6 <ayatsuri_model_instance_sided_mesh_view+0x76>
