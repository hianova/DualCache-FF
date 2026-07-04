	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZN12covopt_tests4main17h8bafcd137244b278E
	.globl	__ZN12covopt_tests4main17h8bafcd137244b278E
	.p2align	2
__ZN12covopt_tests4main17h8bafcd137244b278E:
	.cfi_startproc
	mov	w0, #8
	mov	x1, #0
	b	__RNvCshoVrKSUFjcq_4test16test_main_static
	.cfi_endproc

	.private_extern	__ZN3std2rt10lang_start17h3fa0b6d9d9c11c1eE
	.globl	__ZN3std2rt10lang_start17h3fa0b6d9d9c11c1eE
	.p2align	2
__ZN3std2rt10lang_start17h3fa0b6d9d9c11c1eE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x4, x3
	mov	x3, x2
	mov	x2, x1
	str	x0, [sp, #8]
Lloh0:
	adrp	x1, l_anon.812ff991aa62a8ff8ad3a0fa7e0d62ba.0@PAGE
Lloh1:
	add	x1, x1, l_anon.812ff991aa62a8ff8ad3a0fa7e0d62ba.0@PAGEOFF
	add	x0, sp, #8
	bl	__RNvNtCsaLOjE9VYtxK_3std2rt19lang_start_internal
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.loh AdrpAdd	Lloh0, Lloh1
	.cfi_endproc

	.p2align	2
__ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h5d0f918ac338d57eE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x0, [x0]
	bl	__ZN3std3sys9backtrace28__rust_begin_short_backtrace17h012b63f6581062d7E
	mov	w0, #0
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN3std3sys9backtrace28__rust_begin_short_backtrace17h012b63f6581062d7E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	blr	x0
	; InlineAsm Start
	; InlineAsm End
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h0fde69fdcca77e64E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x0, [x0]
	bl	__ZN3std3sys9backtrace28__rust_begin_short_backtrace17h012b63f6581062d7E
	mov	w0, #0
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	_main
	.p2align	2
_main:
	.cfi_startproc
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x3, x1
	sxtw	x2, w0
Lloh2:
	adrp	x8, __ZN12covopt_tests4main17h8bafcd137244b278E@PAGE
Lloh3:
	add	x8, x8, __ZN12covopt_tests4main17h8bafcd137244b278E@PAGEOFF
	str	x8, [sp, #8]
Lloh4:
	adrp	x1, l_anon.812ff991aa62a8ff8ad3a0fa7e0d62ba.0@PAGE
Lloh5:
	add	x1, x1, l_anon.812ff991aa62a8ff8ad3a0fa7e0d62ba.0@PAGEOFF
	add	x0, sp, #8
	mov	w4, #0
	bl	__RNvNtCsaLOjE9VYtxK_3std2rt19lang_start_internal
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	ret
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpAdd	Lloh2, Lloh3
	.cfi_endproc

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.812ff991aa62a8ff8ad3a0fa7e0d62ba.0:
	.asciz	"\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	__ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h0fde69fdcca77e64E
	.quad	__ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h5d0f918ac338d57eE
	.quad	__ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h5d0f918ac338d57eE

.subsections_via_symbols
