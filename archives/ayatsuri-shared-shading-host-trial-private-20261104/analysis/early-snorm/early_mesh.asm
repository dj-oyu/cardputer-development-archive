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

