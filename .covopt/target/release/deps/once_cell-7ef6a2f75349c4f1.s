	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN4core3num7nonzero16NonZero$LT$T$GT$13new_unchecked17h40266ea853a0a0fdE
	.p2align	2
__ZN4core3num7nonzero16NonZero$LT$T$GT$13new_unchecked17h40266ea853a0a0fdE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x1, [sp]
	str	x0, [sp, #8]
	ldr	x8, [sp, #8]
	subs	x8, x8, #0
	cset	x8, ne
	tbz	w8, #0, LBB0_2
	b	LBB0_1
LBB0_1:
	ldr	x0, [sp, #8]
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB0_2:
	.cfi_restore_state
	ldr	x0, [sp]
	bl	__ZN4core3num7nonzero16NonZero$LT$T$GT$13new_unchecked18precondition_check17h10e4ce29c03cfbfeE
	b	LBB0_3
LBB0_3:
	brk	#0x1
	.cfi_endproc

	.p2align	2
__ZN4core3num7nonzero16NonZero$LT$T$GT$13new_unchecked18precondition_check17h10e4ce29c03cfbfeE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x3, x0
	adrp	x0, l_anon.254bb980ebc8cc9eddc3f7e01e40be13.0@PAGE
	add	x0, x0, l_anon.254bb980ebc8cc9eddc3f7e01e40be13.0@PAGEOFF
	mov	w8, #419
	mov	x1, x8
	mov	w8, #0
	and	w2, w8, #0x1
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_nounwind_fmt
	.cfi_endproc

	.globl	__ZN4core3ptr9const_ptr33_$LT$impl$u20$$BP$const$u20$T$GT$4read17h5baa49c8e22fa3caE
	.p2align	2
__ZN4core3ptr9const_ptr33_$LT$impl$u20$$BP$const$u20$T$GT$4read17h5baa49c8e22fa3caE:
	.cfi_startproc
	ldr	x0, [x0]
	ret
	.cfi_endproc

	.globl	__ZN9once_cell4race16OnceNonZeroUsize13get_unchecked17h079aade7158f8067E
	.p2align	2
__ZN9once_cell4race16OnceNonZeroUsize13get_unchecked17h079aade7158f8067E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	adrp	x1, l_anon.254bb980ebc8cc9eddc3f7e01e40be13.2@PAGE
	add	x1, x1, l_anon.254bb980ebc8cc9eddc3f7e01e40be13.2@PAGEOFF
	bl	__ZN4core3ptr9const_ptr33_$LT$impl$u20$$BP$const$u20$T$GT$4read17h5baa49c8e22fa3caE
	adrp	x1, l_anon.254bb980ebc8cc9eddc3f7e01e40be13.3@PAGE
	add	x1, x1, l_anon.254bb980ebc8cc9eddc3f7e01e40be13.3@PAGEOFF
	bl	__ZN4core3num7nonzero16NonZero$LT$T$GT$13new_unchecked17h40266ea853a0a0fdE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.section	__TEXT,__const
l_anon.254bb980ebc8cc9eddc3f7e01e40be13.0:
	.ascii	"unsafe precondition(s) violated: NonZero::new_unchecked requires the argument to be non-zero\n\nThis indicates a bug in the program. This Undefined Behavior check is optional, and cannot be relied on for safety."

	.section	__TEXT,__cstring,cstring_literals
l_anon.254bb980ebc8cc9eddc3f7e01e40be13.1:
	.asciz	"/Users/kuangtalin/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/once_cell-1.21.4/src/race.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.254bb980ebc8cc9eddc3f7e01e40be13.2:
	.quad	l_anon.254bb980ebc8cc9eddc3f7e01e40be13.1
	.asciz	"c\000\000\000\000\000\000\000_\000\000\000\036\000\000"

	.p2align	3, 0x0
l_anon.254bb980ebc8cc9eddc3f7e01e40be13.3:
	.quad	l_anon.254bb980ebc8cc9eddc3f7e01e40be13.1
	.asciz	"c\000\000\000\000\000\000\000c\000\000\000\022\000\000"

.subsections_via_symbols
