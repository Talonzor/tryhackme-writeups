
./teaParty:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <_init>:
    1000:	48 83 ec 08          	sub    $0x8,%rsp
    1004:	48 8b 05 dd 2f 00 00 	mov    0x2fdd(%rip),%rax        # 3fe8 <__gmon_start__>
    100b:	48 85 c0             	test   %rax,%rax
    100e:	74 02                	je     1012 <_init+0x12>
    1010:	ff d0                	call   *%rax
    1012:	48 83 c4 08          	add    $0x8,%rsp
    1016:	c3                   	ret    

Disassembly of section .plt:

0000000000001020 <.plt>:
    1020:	ff 35 e2 2f 00 00    	push   0x2fe2(%rip)        # 4008 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	ff 25 e4 2f 00 00    	jmp    *0x2fe4(%rip)        # 4010 <_GLOBAL_OFFSET_TABLE_+0x10>
    102c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000001030 <puts@plt>:
    1030:	ff 25 e2 2f 00 00    	jmp    *0x2fe2(%rip)        # 4018 <puts@GLIBC_2.2.5>
    1036:	68 00 00 00 00       	push   $0x0
    103b:	e9 e0 ff ff ff       	jmp    1020 <.plt>

0000000000001040 <system@plt>:
    1040:	ff 25 da 2f 00 00    	jmp    *0x2fda(%rip)        # 4020 <system@GLIBC_2.2.5>
    1046:	68 01 00 00 00       	push   $0x1
    104b:	e9 d0 ff ff ff       	jmp    1020 <.plt>

0000000000001050 <getchar@plt>:
    1050:	ff 25 d2 2f 00 00    	jmp    *0x2fd2(%rip)        # 4028 <getchar@GLIBC_2.2.5>
    1056:	68 02 00 00 00       	push   $0x2
    105b:	e9 c0 ff ff ff       	jmp    1020 <.plt>

0000000000001060 <setgid@plt>:
    1060:	ff 25 ca 2f 00 00    	jmp    *0x2fca(%rip)        # 4030 <setgid@GLIBC_2.2.5>
    1066:	68 03 00 00 00       	push   $0x3
    106b:	e9 b0 ff ff ff       	jmp    1020 <.plt>

0000000000001070 <setuid@plt>:
    1070:	ff 25 c2 2f 00 00    	jmp    *0x2fc2(%rip)        # 4038 <setuid@GLIBC_2.2.5>
    1076:	68 04 00 00 00       	push   $0x4
    107b:	e9 a0 ff ff ff       	jmp    1020 <.plt>

Disassembly of section .plt.got:

0000000000001080 <__cxa_finalize@plt>:
    1080:	ff 25 72 2f 00 00    	jmp    *0x2f72(%rip)        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    1086:	66 90                	xchg   %ax,%ax

Disassembly of section .text:

0000000000001090 <_start>:
    1090:	31 ed                	xor    %ebp,%ebp
    1092:	49 89 d1             	mov    %rdx,%r9
    1095:	5e                   	pop    %rsi
    1096:	48 89 e2             	mov    %rsp,%rdx
    1099:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
    109d:	50                   	push   %rax
    109e:	54                   	push   %rsp
    109f:	4c 8d 05 8a 01 00 00 	lea    0x18a(%rip),%r8        # 1230 <__libc_csu_fini>
    10a6:	48 8d 0d 23 01 00 00 	lea    0x123(%rip),%rcx        # 11d0 <__libc_csu_init>
    10ad:	48 8d 3d c1 00 00 00 	lea    0xc1(%rip),%rdi        # 1175 <main>
    10b4:	ff 15 26 2f 00 00    	call   *0x2f26(%rip)        # 3fe0 <__libc_start_main@GLIBC_2.2.5>
    10ba:	f4                   	hlt    
    10bb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000000010c0 <deregister_tm_clones>:
    10c0:	48 8d 3d 89 2f 00 00 	lea    0x2f89(%rip),%rdi        # 4050 <__TMC_END__>
    10c7:	48 8d 05 82 2f 00 00 	lea    0x2f82(%rip),%rax        # 4050 <__TMC_END__>
    10ce:	48 39 f8             	cmp    %rdi,%rax
    10d1:	74 15                	je     10e8 <deregister_tm_clones+0x28>
    10d3:	48 8b 05 fe 2e 00 00 	mov    0x2efe(%rip),%rax        # 3fd8 <_ITM_deregisterTMCloneTable>
    10da:	48 85 c0             	test   %rax,%rax
    10dd:	74 09                	je     10e8 <deregister_tm_clones+0x28>
    10df:	ff e0                	jmp    *%rax
    10e1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    10e8:	c3                   	ret    
    10e9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

00000000000010f0 <register_tm_clones>:
    10f0:	48 8d 3d 59 2f 00 00 	lea    0x2f59(%rip),%rdi        # 4050 <__TMC_END__>
    10f7:	48 8d 35 52 2f 00 00 	lea    0x2f52(%rip),%rsi        # 4050 <__TMC_END__>
    10fe:	48 29 fe             	sub    %rdi,%rsi
    1101:	48 c1 fe 03          	sar    $0x3,%rsi
    1105:	48 89 f0             	mov    %rsi,%rax
    1108:	48 c1 e8 3f          	shr    $0x3f,%rax
    110c:	48 01 c6             	add    %rax,%rsi
    110f:	48 d1 fe             	sar    %rsi
    1112:	74 14                	je     1128 <register_tm_clones+0x38>
    1114:	48 8b 05 d5 2e 00 00 	mov    0x2ed5(%rip),%rax        # 3ff0 <_ITM_registerTMCloneTable>
    111b:	48 85 c0             	test   %rax,%rax
    111e:	74 08                	je     1128 <register_tm_clones+0x38>
    1120:	ff e0                	jmp    *%rax
    1122:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    1128:	c3                   	ret    
    1129:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001130 <__do_global_dtors_aux>:
    1130:	80 3d 19 2f 00 00 00 	cmpb   $0x0,0x2f19(%rip)        # 4050 <__TMC_END__>
    1137:	75 2f                	jne    1168 <__do_global_dtors_aux+0x38>
    1139:	55                   	push   %rbp
    113a:	48 83 3d b6 2e 00 00 	cmpq   $0x0,0x2eb6(%rip)        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    1141:	00 
    1142:	48 89 e5             	mov    %rsp,%rbp
    1145:	74 0c                	je     1153 <__do_global_dtors_aux+0x23>
    1147:	48 8b 3d fa 2e 00 00 	mov    0x2efa(%rip),%rdi        # 4048 <__dso_handle>
    114e:	e8 2d ff ff ff       	call   1080 <__cxa_finalize@plt>
    1153:	e8 68 ff ff ff       	call   10c0 <deregister_tm_clones>
    1158:	c6 05 f1 2e 00 00 01 	movb   $0x1,0x2ef1(%rip)        # 4050 <__TMC_END__>
    115f:	5d                   	pop    %rbp
    1160:	c3                   	ret    
    1161:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    1168:	c3                   	ret    
    1169:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001170 <frame_dummy>:
    1170:	e9 7b ff ff ff       	jmp    10f0 <register_tm_clones>

0000000000001175 <main>:
    1175:	55                   	push   %rbp
    1176:	48 89 e5             	mov    %rsp,%rbp
    1179:	bf eb 03 00 00       	mov    $0x3eb,%edi
    117e:	e8 ed fe ff ff       	call   1070 <setuid@plt>
    1183:	bf eb 03 00 00       	mov    $0x3eb,%edi
    1188:	e8 d3 fe ff ff       	call   1060 <setgid@plt>
    118d:	48 8d 3d 74 0e 00 00 	lea    0xe74(%rip),%rdi        # 2008 <_IO_stdin_used+0x8>
    1194:	e8 97 fe ff ff       	call   1030 <puts@plt>
    1199:	48 8d 3d a8 0e 00 00 	lea    0xea8(%rip),%rdi        # 2048 <_IO_stdin_used+0x48>
    11a0:	e8 9b fe ff ff       	call   1040 <system@plt>
    11a5:	48 8d 3d dc 0e 00 00 	lea    0xedc(%rip),%rdi        # 2088 <_IO_stdin_used+0x88>
    11ac:	e8 7f fe ff ff       	call   1030 <puts@plt>
    11b1:	e8 9a fe ff ff       	call   1050 <getchar@plt>
    11b6:	48 8d 3d 13 0f 00 00 	lea    0xf13(%rip),%rdi        # 20d0 <_IO_stdin_used+0xd0>
    11bd:	e8 6e fe ff ff       	call   1030 <puts@plt>
    11c2:	90                   	nop
    11c3:	5d                   	pop    %rbp
    11c4:	c3                   	ret    
    11c5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    11cc:	00 00 00 
    11cf:	90                   	nop

00000000000011d0 <__libc_csu_init>:
    11d0:	41 57                	push   %r15
    11d2:	49 89 d7             	mov    %rdx,%r15
    11d5:	41 56                	push   %r14
    11d7:	49 89 f6             	mov    %rsi,%r14
    11da:	41 55                	push   %r13
    11dc:	41 89 fd             	mov    %edi,%r13d
    11df:	41 54                	push   %r12
    11e1:	4c 8d 25 00 2c 00 00 	lea    0x2c00(%rip),%r12        # 3de8 <__frame_dummy_init_array_entry>
    11e8:	55                   	push   %rbp
    11e9:	48 8d 2d 00 2c 00 00 	lea    0x2c00(%rip),%rbp        # 3df0 <__do_global_dtors_aux_fini_array_entry>
    11f0:	53                   	push   %rbx
    11f1:	4c 29 e5             	sub    %r12,%rbp
    11f4:	48 83 ec 08          	sub    $0x8,%rsp
    11f8:	e8 03 fe ff ff       	call   1000 <_init>
    11fd:	48 c1 fd 03          	sar    $0x3,%rbp
    1201:	74 1b                	je     121e <__libc_csu_init+0x4e>
    1203:	31 db                	xor    %ebx,%ebx
    1205:	0f 1f 00             	nopl   (%rax)
    1208:	4c 89 fa             	mov    %r15,%rdx
    120b:	4c 89 f6             	mov    %r14,%rsi
    120e:	44 89 ef             	mov    %r13d,%edi
    1211:	41 ff 14 dc          	call   *(%r12,%rbx,8)
    1215:	48 83 c3 01          	add    $0x1,%rbx
    1219:	48 39 dd             	cmp    %rbx,%rbp
    121c:	75 ea                	jne    1208 <__libc_csu_init+0x38>
    121e:	48 83 c4 08          	add    $0x8,%rsp
    1222:	5b                   	pop    %rbx
    1223:	5d                   	pop    %rbp
    1224:	41 5c                	pop    %r12
    1226:	41 5d                	pop    %r13
    1228:	41 5e                	pop    %r14
    122a:	41 5f                	pop    %r15
    122c:	c3                   	ret    
    122d:	0f 1f 00             	nopl   (%rax)

0000000000001230 <__libc_csu_fini>:
    1230:	c3                   	ret    

Disassembly of section .fini:

0000000000001234 <_fini>:
    1234:	48 83 ec 08          	sub    $0x8,%rsp
    1238:	48 83 c4 08          	add    $0x8,%rsp
    123c:	c3                   	ret    
