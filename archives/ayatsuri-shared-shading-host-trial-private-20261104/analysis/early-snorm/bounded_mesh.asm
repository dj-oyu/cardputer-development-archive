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

