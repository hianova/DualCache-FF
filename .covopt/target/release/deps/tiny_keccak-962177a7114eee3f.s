	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN106_$LT$core..ops..range..Range$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17hf2bc80b2a403e67dE
	.p2align	2
__ZN106_$LT$core..ops..range..Range$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17hf2bc80b2a403e67dE:
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	str	x1, [sp, #16]
	str	x2, [sp, #24]
	str	x3, [sp, #32]
	stur	x4, [x29, #-24]
	subs	x8, x1, x0
	b.lo	LBB0_2
	b	LBB0_1
LBB0_1:
	ldr	x8, [sp, #16]
	ldr	x9, [sp, #32]
	ldr	x10, [sp, #8]
	subs	x10, x8, x10
	stur	x10, [x29, #-8]
	mov	w10, #1
	stur	x10, [x29, #-16]
	ldur	x10, [x29, #-8]
	str	x10, [sp]
	subs	x8, x8, x9
	b.ls	LBB0_4
	b	LBB0_3
LBB0_2:
	b	LBB0_5
LBB0_3:
	b	LBB0_5
LBB0_4:
	ldr	x1, [sp]
	ldr	x8, [sp, #24]
	ldr	x9, [sp, #8]
	add	x0, x8, x9
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB0_5:
	.cfi_restore_state
	ldur	x3, [x29, #-24]
	ldr	x2, [sp, #32]
	ldr	x1, [sp, #16]
	ldr	x0, [sp, #8]
	bl	__RNvNtNtCs6sq8b9ugfBC_4core5slice5index16slice_index_fail
	.cfi_endproc

	.globl	__ZN108_$LT$core..ops..range..RangeTo$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17hb9c9bcfa22263df0E
	.p2align	2
__ZN108_$LT$core..ops..range..RangeTo$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17hb9c9bcfa22263df0E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	mov	x0, x1
	ldr	x1, [sp, #8]
	str	x0, [sp, #16]
	mov	x0, x2
	ldr	x2, [sp, #16]
	stur	x0, [x29, #-8]
	mov	x4, x3
	ldur	x3, [x29, #-8]
	mov	x0, #0
	bl	__ZN106_$LT$core..ops..range..Range$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17hf2bc80b2a403e67dE
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN110_$LT$core..ops..range..RangeFrom$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$5index17h52500f0dd05c569fE
	.p2align	2
__ZN110_$LT$core..ops..range..RangeFrom$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$5index17h52500f0dd05c569fE:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp]
	str	x1, [sp, #8]
	str	x2, [sp, #16]
	stur	x3, [x29, #-8]
	subs	x8, x0, x2
	b.hi	LBB2_2
	b	LBB2_1
LBB2_1:
	ldr	x8, [sp, #8]
	ldr	x9, [sp]
	ldr	x10, [sp, #16]
	subs	x1, x10, x9
	add	x0, x8, x9
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB2_2:
	.cfi_restore_state
	ldur	x3, [x29, #-8]
	ldr	x2, [sp, #16]
	ldr	x0, [sp]
	mov	x1, x2
	bl	__RNvNtNtCs6sq8b9ugfBC_4core5slice5index16slice_index_fail
	.cfi_endproc

	.globl	__ZN110_$LT$core..ops..range..RangeFrom$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17hf8910bea0f9121b5E
	.p2align	2
__ZN110_$LT$core..ops..range..RangeFrom$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17hf8910bea0f9121b5E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp]
	str	x1, [sp, #8]
	str	x2, [sp, #16]
	stur	x3, [x29, #-8]
	subs	x8, x0, x2
	b.hi	LBB3_2
	b	LBB3_1
LBB3_1:
	ldr	x8, [sp, #8]
	ldr	x9, [sp]
	ldr	x10, [sp, #16]
	subs	x1, x10, x9
	add	x0, x8, x9
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB3_2:
	.cfi_restore_state
	ldur	x3, [x29, #-8]
	ldr	x2, [sp, #16]
	ldr	x0, [sp]
	mov	x1, x2
	bl	__RNvNtNtCs6sq8b9ugfBC_4core5slice5index16slice_index_fail
	.cfi_endproc

	.p2align	2
__ZN11tiny_keccak12bits_to_rate17hfebae997d04af94dE:
	.cfi_startproc
	mov	w8, #4
	udiv	x9, x0, x8
	mov	w8, #200
	subs	x0, x8, x9
	ret
	.cfi_endproc

	.p2align	2
__ZN11tiny_keccak20KeccakState$LT$P$GT$10fill_block17h724e365af13007b6E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	bl	__ZN11tiny_keccak20KeccakState$LT$P$GT$6keccak17hd7b8a775e80b838dE
	ldr	x0, [sp, #8]
	str	xzr, [x0, #200]
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN11tiny_keccak20KeccakState$LT$P$GT$3new17hb55ed6df916f8b04E:
	.cfi_startproc
	sub	sp, sp, #272
	.cfi_def_cfa_offset 272
	stp	x28, x27, [sp, #240]
	stp	x29, x30, [sp, #256]
	add	x29, sp, #256
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w27, -24
	.cfi_offset w28, -32
	str	x8, [sp, #16]
	str	x0, [sp, #24]
	str	w1, [sp, #36]
	cbnz	x0, LBB6_2
	b	LBB6_1
LBB6_1:
	adrp	x0, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.0@PAGE
	add	x0, x0, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.0@PAGEOFF
	mov	w8, #22
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.2@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.2@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking5panic
LBB6_2:
	add	x8, sp, #40
	str	x8, [sp, #8]
	bl	__ZN62_$LT$tiny_keccak..Buffer$u20$as$u20$core..default..Default$GT$7default17h0ed2acd921513c1bE
	ldr	x1, [sp, #8]
	ldr	x0, [sp, #16]
	mov	w8, #200
	mov	x2, x8
	bl	_memcpy
	ldr	x10, [sp, #24]
	ldr	w9, [sp, #36]
	ldr	x8, [sp, #16]
	str	xzr, [x8, #200]
	str	x10, [x8, #208]
	strb	w9, [x8, #216]
	strb	wzr, [x8, #217]
	.cfi_def_cfa wsp, 272
	ldp	x29, x30, [sp, #256]
	ldp	x28, x27, [sp, #240]
	add	sp, sp, #272
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w27
	.cfi_restore w28
	ret
	.cfi_endproc

	.p2align	2
__ZN11tiny_keccak20KeccakState$LT$P$GT$3pad17h8f3d6893a126d273E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x1, [x0, #200]
	ldrb	w2, [x0, #216]
	ldr	x3, [x0, #208]
	bl	__ZN11tiny_keccak6Buffer3pad17h1e0b040214440855E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN11tiny_keccak20KeccakState$LT$P$GT$6keccak17hd7b8a775e80b838dE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN74_$LT$tiny_keccak..keccakf..KeccakF$u20$as$u20$tiny_keccak..Permutation$GT$7execute17haf6c9fde0f2d0721E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN11tiny_keccak20KeccakState$LT$P$GT$6update17h6cf0f67317b78fd0E:
	.cfi_startproc
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	stp	x29, x30, [sp, #80]
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #24]
	str	x1, [sp, #32]
	str	x2, [sp, #40]
	ldrb	w8, [x0, #217]
	tbz	w8, #0, LBB9_2
	b	LBB9_1
LBB9_1:
	ldr	x0, [sp, #24]
	strb	wzr, [x0, #217]
	bl	__ZN11tiny_keccak20KeccakState$LT$P$GT$10fill_block17h724e365af13007b6E
	b	LBB9_2
LBB9_2:
	ldr	x8, [sp, #24]
	ldr	x9, [sp, #40]
	stur	xzr, [x29, #-32]
	stur	x9, [x29, #-24]
	ldr	x9, [x8, #208]
	ldr	x10, [x8, #200]
	subs	x9, x9, x10
	stur	x9, [x29, #-16]
	ldr	x8, [x8, #200]
	stur	x8, [x29, #-8]
	b	LBB9_3
LBB9_3:
	ldur	x8, [x29, #-24]
	ldur	x9, [x29, #-16]
	subs	x8, x8, x9
	b.hs	LBB9_5
	b	LBB9_4
LBB9_4:
	ldr	x2, [sp, #40]
	ldr	x1, [sp, #32]
	ldur	x0, [x29, #-32]
	adrp	x3, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.3@PAGE
	add	x3, x3, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.3@PAGEOFF
	bl	__ZN110_$LT$core..ops..range..RangeFrom$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$5index17h52500f0dd05c569fE
	mov	x2, x0
	ldr	x0, [sp, #24]
	str	x2, [sp, #16]
	mov	x2, x1
	ldr	x1, [sp, #16]
	ldur	x3, [x29, #-8]
	ldur	x4, [x29, #-24]
	bl	__ZN11tiny_keccak6Buffer5xorin17h6156e38e0fa1f8beE
	ldr	x9, [sp, #24]
	ldur	x8, [x29, #-8]
	ldur	x10, [x29, #-24]
	add	x8, x8, x10
	str	x8, [x9, #200]
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB9_5:
	.cfi_restore_state
	ldr	x2, [sp, #40]
	ldr	x1, [sp, #32]
	ldur	x0, [x29, #-32]
	adrp	x3, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.4@PAGE
	add	x3, x3, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.4@PAGEOFF
	bl	__ZN110_$LT$core..ops..range..RangeFrom$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$5index17h52500f0dd05c569fE
	mov	x2, x0
	ldr	x0, [sp, #24]
	str	x2, [sp, #8]
	mov	x2, x1
	ldr	x1, [sp, #8]
	ldur	x3, [x29, #-8]
	ldur	x4, [x29, #-16]
	bl	__ZN11tiny_keccak6Buffer5xorin17h6156e38e0fa1f8beE
	ldr	x0, [sp, #24]
	bl	__ZN11tiny_keccak20KeccakState$LT$P$GT$6keccak17hd7b8a775e80b838dE
	ldr	x8, [sp, #24]
	ldur	x10, [x29, #-16]
	ldur	x9, [x29, #-32]
	add	x9, x9, x10
	stur	x9, [x29, #-32]
	ldur	x10, [x29, #-16]
	ldur	x9, [x29, #-24]
	subs	x9, x9, x10
	stur	x9, [x29, #-24]
	ldr	x8, [x8, #208]
	stur	x8, [x29, #-16]
	stur	xzr, [x29, #-8]
	b	LBB9_3
	.cfi_endproc

	.p2align	2
__ZN11tiny_keccak20KeccakState$LT$P$GT$7squeeze17ha717945d197ef533E:
	.cfi_startproc
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	stp	x29, x30, [sp, #80]
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #24]
	str	x1, [sp, #32]
	str	x2, [sp, #40]
	ldrb	w8, [x0, #217]
	tbz	w8, #0, LBB10_2
	b	LBB10_1
LBB10_1:
	ldr	x8, [sp, #24]
	ldr	x9, [sp, #40]
	stur	xzr, [x29, #-32]
	stur	x9, [x29, #-24]
	ldr	x9, [x8, #208]
	ldr	x10, [x8, #200]
	subs	x9, x9, x10
	stur	x9, [x29, #-16]
	ldr	x8, [x8, #200]
	stur	x8, [x29, #-8]
	b	LBB10_3
LBB10_2:
	ldr	x0, [sp, #24]
	mov	w8, #1
	strb	w8, [x0, #217]
	bl	__ZN11tiny_keccak20KeccakState$LT$P$GT$3pad17h8f3d6893a126d273E
	ldr	x0, [sp, #24]
	bl	__ZN11tiny_keccak20KeccakState$LT$P$GT$10fill_block17h724e365af13007b6E
	b	LBB10_1
LBB10_3:
	ldur	x8, [x29, #-24]
	ldur	x9, [x29, #-16]
	subs	x8, x8, x9
	b.hs	LBB10_5
	b	LBB10_4
LBB10_4:
	ldr	x2, [sp, #40]
	ldr	x1, [sp, #32]
	ldur	x0, [x29, #-32]
	adrp	x3, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.5@PAGE
	add	x3, x3, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.5@PAGEOFF
	bl	__ZN110_$LT$core..ops..range..RangeFrom$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17hf8910bea0f9121b5E
	mov	x2, x0
	ldr	x0, [sp, #24]
	str	x2, [sp, #16]
	mov	x2, x1
	ldr	x1, [sp, #16]
	ldur	x3, [x29, #-8]
	ldur	x4, [x29, #-24]
	bl	__ZN11tiny_keccak6Buffer6setout17h50d9622941817d3bE
	ldr	x9, [sp, #24]
	ldur	x8, [x29, #-8]
	ldur	x10, [x29, #-24]
	add	x8, x8, x10
	str	x8, [x9, #200]
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB10_5:
	.cfi_restore_state
	ldr	x2, [sp, #40]
	ldr	x1, [sp, #32]
	ldur	x0, [x29, #-32]
	adrp	x3, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.6@PAGE
	add	x3, x3, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.6@PAGEOFF
	bl	__ZN110_$LT$core..ops..range..RangeFrom$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17hf8910bea0f9121b5E
	mov	x2, x0
	ldr	x0, [sp, #24]
	str	x2, [sp, #8]
	mov	x2, x1
	ldr	x1, [sp, #8]
	ldur	x3, [x29, #-8]
	ldur	x4, [x29, #-16]
	bl	__ZN11tiny_keccak6Buffer6setout17h50d9622941817d3bE
	ldr	x0, [sp, #24]
	bl	__ZN11tiny_keccak20KeccakState$LT$P$GT$6keccak17hd7b8a775e80b838dE
	ldr	x8, [sp, #24]
	ldur	x10, [x29, #-16]
	ldur	x9, [x29, #-32]
	add	x9, x9, x10
	stur	x9, [x29, #-32]
	ldur	x10, [x29, #-16]
	ldur	x9, [x29, #-24]
	subs	x9, x9, x10
	stur	x9, [x29, #-24]
	ldr	x8, [x8, #208]
	stur	x8, [x29, #-16]
	stur	xzr, [x29, #-8]
	b	LBB10_3
	.cfi_endproc

	.p2align	2
__ZN11tiny_keccak20KeccakState$LT$P$GT$8finalize17haa4d4d7977a7dc2dE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN11tiny_keccak20KeccakState$LT$P$GT$7squeeze17ha717945d197ef533E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN11tiny_keccak5shake5Shake3new17h3ac8f52dac3fb69cE:
	.cfi_startproc
	sub	sp, sp, #272
	.cfi_def_cfa_offset 272
	stp	x28, x27, [sp, #240]
	stp	x29, x30, [sp, #256]
	add	x29, sp, #256
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w27, -24
	.cfi_offset w28, -32
	str	x8, [sp]
	bl	__ZN11tiny_keccak12bits_to_rate17hfebae997d04af94dE
	add	x8, sp, #16
	str	x8, [sp, #8]
	mov	w1, #31
	bl	__ZN11tiny_keccak20KeccakState$LT$P$GT$3new17hb55ed6df916f8b04E
	ldr	x0, [sp]
	ldr	x1, [sp, #8]
	mov	w8, #224
	mov	x2, x8
	bl	_memcpy
	.cfi_def_cfa wsp, 272
	ldp	x29, x30, [sp, #256]
	ldp	x28, x27, [sp, #240]
	add	sp, sp, #272
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w27
	.cfi_restore w28
	ret
	.cfi_endproc

	.globl	__ZN11tiny_keccak5shake5Shake4v12817h8b8c1ffa8d3a81b0E
	.p2align	2
__ZN11tiny_keccak5shake5Shake4v12817h8b8c1ffa8d3a81b0E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	w9, #128
	mov	x0, x9
	bl	__ZN11tiny_keccak5shake5Shake3new17h3ac8f52dac3fb69cE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN11tiny_keccak5shake5Shake4v25617h938829213332dfe6E
	.p2align	2
__ZN11tiny_keccak5shake5Shake4v25617h938829213332dfe6E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	w9, #256
	mov	x0, x9
	bl	__ZN11tiny_keccak5shake5Shake3new17h3ac8f52dac3fb69cE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN11tiny_keccak6Buffer3pad17h1e0b040214440855E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	str	x3, [sp]
	sub	x3, x29, #1
	sturb	w2, [x29, #-1]
	mov	w8, #1
	mov	x2, x8
	str	x2, [sp, #16]
	bl	__ZN11tiny_keccak6Buffer7execute17h97f2526f2fee9f56E
	ldr	x3, [sp]
	ldr	x0, [sp, #8]
	ldr	x2, [sp, #16]
	subs	x1, x3, #1
	bl	__ZN11tiny_keccak6Buffer7execute17hd45f99bdff05fb56E
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN11tiny_keccak6Buffer3pad28_$u7b$$u7b$closure$u7d$$u7d$17h623b81e13e6370acE:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x1, [sp, #8]
	str	x2, [sp, #16]
	ldrb	w8, [x0]
	stur	w8, [x29, #-4]
	mov	x8, #0
	subs	x8, x8, x2
	b.hs	LBB16_2
	b	LBB16_1
LBB16_1:
	ldr	x9, [sp, #8]
	ldur	w10, [x29, #-4]
	ldrb	w8, [x9]
	eor	w8, w8, w10
	strb	w8, [x9]
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB16_2:
	.cfi_restore_state
	ldr	x1, [sp, #16]
	mov	x0, #0
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.7@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.7@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
	.cfi_endproc

	.p2align	2
__ZN11tiny_keccak6Buffer3pad28_$u7b$$u7b$closure$u7d$$u7d$17h7db49f561da161fcE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp]
	str	x1, [sp, #8]
	mov	x8, #0
	subs	x8, x8, x1
	b.hs	LBB17_2
	b	LBB17_1
LBB17_1:
	ldr	x9, [sp]
	ldrb	w8, [x9]
	eor	w8, w8, #0xffffff80
	strb	w8, [x9]
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB17_2:
	.cfi_restore_state
	ldr	x1, [sp, #8]
	mov	x0, #0
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.8@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.8@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
	.cfi_endproc

	.p2align	2
__ZN11tiny_keccak6Buffer5words17h2abc719feefb2ca9E:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN11tiny_keccak6Buffer5xorin17h6156e38e0fa1f8beE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x9, x1
	mov	x8, x2
	mov	x1, x3
	mov	x2, x4
	mov	x3, sp
	str	x9, [sp]
	str	x8, [sp, #8]
	bl	__ZN11tiny_keccak6Buffer7execute17h3d5f1baede4cbcf7E
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN11tiny_keccak6Buffer5xorin28_$u7b$$u7b$closure$u7d$$u7d$17h40d0b873f7388ca2E:
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	str	x1, [sp, #16]
	str	x2, [sp, #24]
	ldr	x8, [x0, #8]
	subs	x8, x2, x8
	b.ls	LBB20_2
	b	LBB20_1
LBB20_1:
	adrp	x0, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.9@PAGE
	add	x0, x0, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.9@PAGEOFF
	mov	w8, #40
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.10@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.10@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking5panic
LBB20_2:
	ldr	x1, [sp, #24]
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #16]
	str	x9, [sp, #32]
	ldr	x8, [x8]
	stur	x8, [x29, #-24]
	mov	x0, #0
	bl	__ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h3a4397634a7a4b48E
	stur	x0, [x29, #-16]
	stur	x1, [x29, #-8]
	b	LBB20_3
LBB20_3:
	sub	x0, x29, #16
	bl	__ZN4core4iter5range101_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..Range$LT$A$GT$$GT$4next17h487307dbfd89e982E
	mov	x8, x0
	tbz	w8, #0, LBB20_5
	b	LBB20_4
LBB20_4:
	ldur	x8, [x29, #-24]
	ldrb	w10, [x8]
	ldr	x9, [sp, #32]
	ldr	x8, [sp, #32]
	ldrb	w8, [x8]
	eor	w8, w8, w10
	strb	w8, [x9]
	ldur	x8, [x29, #-24]
	add	x8, x8, #1
	stur	x8, [x29, #-24]
	ldr	x8, [sp, #32]
	add	x8, x8, #1
	str	x8, [sp, #32]
	b	LBB20_3
LBB20_5:
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN11tiny_keccak6Buffer6setout17h50d9622941817d3bE:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x9, x1
	mov	x1, x3
	mov	x8, x4
	add	x3, sp, #8
	str	x9, [sp, #8]
	str	x2, [sp, #16]
	sub	x4, x29, #8
	stur	x8, [x29, #-8]
	ldur	x2, [x29, #-8]
	bl	__ZN11tiny_keccak6Buffer7execute17hdee01bce52b1c87eE
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN11tiny_keccak6Buffer6setout28_$u7b$$u7b$closure$u7d$$u7d$17ha804c8068bd26e68E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x1
	str	x2, [sp]
	str	x3, [sp, #8]
	ldr	x1, [x0]
	ldr	x2, [x0, #8]
	ldr	x0, [x8]
	adrp	x3, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.13@PAGE
	add	x3, x3, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.13@PAGEOFF
	bl	__ZN108_$LT$core..ops..range..RangeTo$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17hb9c9bcfa22263df0E
	ldr	x2, [sp]
	ldr	x3, [sp, #8]
	adrp	x4, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.14@PAGE
	add	x4, x4, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.14@PAGEOFF
	bl	__ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$15copy_from_slice17h90565d7266541361E
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN11tiny_keccak6Buffer7execute17h3d5f1baede4cbcf7E:
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception0
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	stp	x29, x30, [sp, #80]
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x2, [sp, #24]
	str	x3, [sp, #32]
	sturb	wzr, [x29, #-17]
	sturb	wzr, [x29, #-18]
	mov	w8, #1
	sturb	w8, [x29, #-17]
	sturb	wzr, [x29, #-17]
	sturb	w8, [x29, #-18]
Ltmp0:
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.15@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.15@PAGEOFF
	bl	__ZN4core5array88_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u3b$$u20$N$u5d$$GT$9index_mut17h6413c554d30ef1a2E
	str	x0, [sp, #40]
	stur	x1, [x29, #-32]
Ltmp1:
	b	LBB23_3
LBB23_1:
	ldurb	w8, [x29, #-18]
	tbnz	w8, #0, LBB23_8
	b	LBB23_7
LBB23_2:
Ltmp6:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB23_1
LBB23_3:
Ltmp2:
	ldur	x2, [x29, #-32]
	ldr	x1, [sp, #40]
	ldr	x0, [sp, #24]
	adrp	x3, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.16@PAGE
	add	x3, x3, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.16@PAGEOFF
	bl	__ZN108_$LT$core..ops..range..RangeTo$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17hb9c9bcfa22263df0E
	str	x0, [sp, #8]
	str	x1, [sp, #16]
Ltmp3:
	b	LBB23_4
LBB23_4:
	b	LBB23_5
LBB23_5:
	ldr	x2, [sp, #16]
	ldr	x1, [sp, #8]
	ldr	x0, [sp, #32]
	sturb	wzr, [x29, #-18]
Ltmp4:
	bl	__ZN11tiny_keccak6Buffer5xorin28_$u7b$$u7b$closure$u7d$$u7d$17h40d0b873f7388ca2E
Ltmp5:
	b	LBB23_6
LBB23_6:
	sturb	wzr, [x29, #-18]
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB23_7:
	.cfi_restore_state
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB23_10
	b	LBB23_9
LBB23_8:
	b	LBB23_7
LBB23_9:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB23_10:
	b	LBB23_9
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table23:
Lexception0:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end0-Lcst_begin0
Lcst_begin0:
	.uleb128 Ltmp0-Lfunc_begin0
	.uleb128 Ltmp5-Ltmp0
	.uleb128 Ltmp6-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp5-Lfunc_begin0
	.uleb128 Lfunc_end0-Ltmp5
	.byte	0
	.byte	0
Lcst_end0:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN11tiny_keccak6Buffer7execute17h97f2526f2fee9f56E:
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception1
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	stp	x29, x30, [sp, #80]
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x2, [sp, #24]
	str	x3, [sp, #32]
	sturb	wzr, [x29, #-17]
	sturb	wzr, [x29, #-18]
	mov	w8, #1
	sturb	w8, [x29, #-17]
	sturb	wzr, [x29, #-17]
	sturb	w8, [x29, #-18]
Ltmp7:
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.15@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.15@PAGEOFF
	bl	__ZN4core5array88_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u3b$$u20$N$u5d$$GT$9index_mut17h6413c554d30ef1a2E
	str	x0, [sp, #40]
	stur	x1, [x29, #-32]
Ltmp8:
	b	LBB24_3
LBB24_1:
	ldurb	w8, [x29, #-18]
	tbnz	w8, #0, LBB24_8
	b	LBB24_7
LBB24_2:
Ltmp13:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB24_1
LBB24_3:
Ltmp9:
	ldur	x2, [x29, #-32]
	ldr	x1, [sp, #40]
	ldr	x0, [sp, #24]
	adrp	x3, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.16@PAGE
	add	x3, x3, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.16@PAGEOFF
	bl	__ZN108_$LT$core..ops..range..RangeTo$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17hb9c9bcfa22263df0E
	str	x0, [sp, #8]
	str	x1, [sp, #16]
Ltmp10:
	b	LBB24_4
LBB24_4:
	b	LBB24_5
LBB24_5:
	ldr	x2, [sp, #16]
	ldr	x1, [sp, #8]
	ldr	x0, [sp, #32]
	sturb	wzr, [x29, #-18]
Ltmp11:
	bl	__ZN11tiny_keccak6Buffer3pad28_$u7b$$u7b$closure$u7d$$u7d$17h623b81e13e6370acE
Ltmp12:
	b	LBB24_6
LBB24_6:
	sturb	wzr, [x29, #-18]
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB24_7:
	.cfi_restore_state
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB24_10
	b	LBB24_9
LBB24_8:
	b	LBB24_7
LBB24_9:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB24_10:
	b	LBB24_9
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table24:
Lexception1:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Ltmp7-Lfunc_begin1
	.uleb128 Ltmp12-Ltmp7
	.uleb128 Ltmp13-Lfunc_begin1
	.byte	0
	.uleb128 Ltmp12-Lfunc_begin1
	.uleb128 Lfunc_end1-Ltmp12
	.byte	0
	.byte	0
Lcst_end1:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN11tiny_keccak6Buffer7execute17hd45f99bdff05fb56E:
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception2
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x2, [sp, #16]
	sturb	wzr, [x29, #-17]
	sturb	wzr, [x29, #-18]
	mov	w8, #1
	sturb	w8, [x29, #-17]
	sturb	wzr, [x29, #-17]
	sturb	w8, [x29, #-18]
Ltmp14:
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.15@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.15@PAGEOFF
	bl	__ZN4core5array88_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u3b$$u20$N$u5d$$GT$9index_mut17h6413c554d30ef1a2E
	str	x0, [sp, #24]
	str	x1, [sp, #32]
Ltmp15:
	b	LBB25_3
LBB25_1:
	ldurb	w8, [x29, #-18]
	tbnz	w8, #0, LBB25_8
	b	LBB25_7
LBB25_2:
Ltmp20:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB25_1
LBB25_3:
Ltmp16:
	ldr	x2, [sp, #32]
	ldr	x1, [sp, #24]
	ldr	x0, [sp, #16]
	adrp	x3, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.16@PAGE
	add	x3, x3, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.16@PAGEOFF
	bl	__ZN108_$LT$core..ops..range..RangeTo$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17hb9c9bcfa22263df0E
	str	x0, [sp]
	str	x1, [sp, #8]
Ltmp17:
	b	LBB25_4
LBB25_4:
	b	LBB25_5
LBB25_5:
	ldr	x1, [sp, #8]
	ldr	x0, [sp]
	sturb	wzr, [x29, #-18]
Ltmp18:
	bl	__ZN11tiny_keccak6Buffer3pad28_$u7b$$u7b$closure$u7d$$u7d$17h7db49f561da161fcE
Ltmp19:
	b	LBB25_6
LBB25_6:
	sturb	wzr, [x29, #-18]
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB25_7:
	.cfi_restore_state
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB25_10
	b	LBB25_9
LBB25_8:
	b	LBB25_7
LBB25_9:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB25_10:
	b	LBB25_9
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table25:
Lexception2:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Ltmp14-Lfunc_begin2
	.uleb128 Ltmp19-Ltmp14
	.uleb128 Ltmp20-Lfunc_begin2
	.byte	0
	.uleb128 Ltmp19-Lfunc_begin2
	.uleb128 Lfunc_end2-Ltmp19
	.byte	0
	.byte	0
Lcst_end2:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN11tiny_keccak6Buffer7execute17hdee01bce52b1c87eE:
Lfunc_begin3:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception3
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	stp	x29, x30, [sp, #80]
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x2, [sp, #16]
	str	x3, [sp, #24]
	str	x4, [sp, #32]
	sturb	wzr, [x29, #-17]
	sturb	wzr, [x29, #-18]
	mov	w8, #1
	sturb	w8, [x29, #-17]
	sturb	wzr, [x29, #-17]
	sturb	w8, [x29, #-18]
Ltmp21:
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.15@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.15@PAGEOFF
	bl	__ZN4core5array88_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u3b$$u20$N$u5d$$GT$9index_mut17h6413c554d30ef1a2E
	str	x0, [sp, #40]
	stur	x1, [x29, #-32]
Ltmp22:
	b	LBB26_3
LBB26_1:
	ldurb	w8, [x29, #-18]
	tbnz	w8, #0, LBB26_8
	b	LBB26_7
LBB26_2:
Ltmp27:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB26_1
LBB26_3:
Ltmp23:
	ldur	x2, [x29, #-32]
	ldr	x1, [sp, #40]
	ldr	x0, [sp, #16]
	adrp	x3, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.16@PAGE
	add	x3, x3, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.16@PAGEOFF
	bl	__ZN108_$LT$core..ops..range..RangeTo$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17hb9c9bcfa22263df0E
	str	x0, [sp]
	str	x1, [sp, #8]
Ltmp24:
	b	LBB26_4
LBB26_4:
	b	LBB26_5
LBB26_5:
	ldr	x3, [sp, #8]
	ldr	x2, [sp]
	ldr	x1, [sp, #32]
	ldr	x0, [sp, #24]
	sturb	wzr, [x29, #-18]
Ltmp25:
	bl	__ZN11tiny_keccak6Buffer6setout28_$u7b$$u7b$closure$u7d$$u7d$17ha804c8068bd26e68E
Ltmp26:
	b	LBB26_6
LBB26_6:
	sturb	wzr, [x29, #-18]
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB26_7:
	.cfi_restore_state
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB26_10
	b	LBB26_9
LBB26_8:
	b	LBB26_7
LBB26_9:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB26_10:
	b	LBB26_9
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table26:
Lexception3:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Ltmp21-Lfunc_begin3
	.uleb128 Ltmp26-Ltmp21
	.uleb128 Ltmp27-Lfunc_begin3
	.byte	0
	.uleb128 Ltmp26-Lfunc_begin3
	.uleb128 Lfunc_end3-Ltmp26
	.byte	0
	.byte	0
Lcst_end3:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN11tiny_keccak7keccakf7keccakf17h722adf9b456eb8fdE
	.p2align	2
__ZN11tiny_keccak7keccakf7keccakf17h722adf9b456eb8fdE:
	.cfi_startproc
	stp	x28, x27, [sp, #-32]!
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w27, -24
	.cfi_offset w28, -32
	.cfi_remember_state
	sub	sp, sp, #1, lsl #12
	str	xzr, [sp]
	sub	sp, sp, #1, lsl #12
	str	xzr, [sp]
	sub	sp, sp, #1, lsl #12
	str	xzr, [sp]
	sub	sp, sp, #496
	str	x0, [sp, #984]
	mov	x0, #0
	mov	w8, #24
	mov	x1, x8
	bl	__ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h3a4397634a7a4b48E
	str	x0, [sp, #992]
	str	x1, [sp, #1000]
	b	LBB27_1
LBB27_1:
	add	x0, sp, #992
	bl	__ZN4core4iter5range101_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..Range$LT$A$GT$$GT$4next17h487307dbfd89e982E
	str	x0, [sp, #1008]
	str	x1, [sp, #1016]
	ldr	x8, [sp, #1008]
	tbz	w8, #0, LBB27_3
	b	LBB27_2
LBB27_2:
	ldr	x8, [sp, #1016]
	str	x8, [sp, #976]
	add	x0, sp, #1024
	mov	w8, #40
	mov	x2, x8
	mov	w1, #0
	bl	_memset
	b	LBB27_4
LBB27_3:
	add	sp, sp, #3, lsl #12
	add	sp, sp, #496
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	ldp	x28, x27, [sp], #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w27
	.cfi_restore w28
	ret
LBB27_4:
	.cfi_restore_state
	b	LBB27_5
LBB27_5:
	ldr	x8, [sp, #984]
	ldr	x9, [x8]
	ldr	x8, [sp, #1024]
	eor	x8, x8, x9
	str	x8, [sp, #1024]
	b	LBB27_6
LBB27_6:
	b	LBB27_7
LBB27_7:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #40]
	ldr	x8, [sp, #1024]
	eor	x8, x8, x9
	str	x8, [sp, #1024]
	b	LBB27_8
LBB27_8:
	b	LBB27_9
LBB27_9:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #80]
	ldr	x8, [sp, #1024]
	eor	x8, x8, x9
	str	x8, [sp, #1024]
	b	LBB27_10
LBB27_10:
	b	LBB27_11
LBB27_11:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #120]
	ldr	x8, [sp, #1024]
	eor	x8, x8, x9
	str	x8, [sp, #1024]
	b	LBB27_12
LBB27_12:
	b	LBB27_13
LBB27_13:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #160]
	ldr	x8, [sp, #1024]
	eor	x8, x8, x9
	str	x8, [sp, #1024]
	b	LBB27_14
LBB27_14:
	b	LBB27_15
LBB27_15:
	b	LBB27_16
LBB27_16:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #8]
	ldr	x8, [sp, #1032]
	eor	x8, x8, x9
	str	x8, [sp, #1032]
	b	LBB27_17
LBB27_17:
	b	LBB27_18
LBB27_18:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #48]
	ldr	x8, [sp, #1032]
	eor	x8, x8, x9
	str	x8, [sp, #1032]
	b	LBB27_19
LBB27_19:
	b	LBB27_20
LBB27_20:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #88]
	ldr	x8, [sp, #1032]
	eor	x8, x8, x9
	str	x8, [sp, #1032]
	b	LBB27_21
LBB27_21:
	b	LBB27_22
LBB27_22:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #128]
	ldr	x8, [sp, #1032]
	eor	x8, x8, x9
	str	x8, [sp, #1032]
	b	LBB27_23
LBB27_23:
	b	LBB27_24
LBB27_24:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #168]
	ldr	x8, [sp, #1032]
	eor	x8, x8, x9
	str	x8, [sp, #1032]
	b	LBB27_25
LBB27_25:
	b	LBB27_26
LBB27_26:
	b	LBB27_27
LBB27_27:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #16]
	ldr	x8, [sp, #1040]
	eor	x8, x8, x9
	str	x8, [sp, #1040]
	b	LBB27_28
LBB27_28:
	b	LBB27_29
LBB27_29:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #56]
	ldr	x8, [sp, #1040]
	eor	x8, x8, x9
	str	x8, [sp, #1040]
	b	LBB27_30
LBB27_30:
	b	LBB27_31
LBB27_31:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #96]
	ldr	x8, [sp, #1040]
	eor	x8, x8, x9
	str	x8, [sp, #1040]
	b	LBB27_32
LBB27_32:
	b	LBB27_33
LBB27_33:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #136]
	ldr	x8, [sp, #1040]
	eor	x8, x8, x9
	str	x8, [sp, #1040]
	b	LBB27_34
LBB27_34:
	b	LBB27_35
LBB27_35:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #176]
	ldr	x8, [sp, #1040]
	eor	x8, x8, x9
	str	x8, [sp, #1040]
	b	LBB27_36
LBB27_36:
	b	LBB27_37
LBB27_37:
	b	LBB27_38
LBB27_38:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #24]
	ldr	x8, [sp, #1048]
	eor	x8, x8, x9
	str	x8, [sp, #1048]
	b	LBB27_39
LBB27_39:
	b	LBB27_40
LBB27_40:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #64]
	ldr	x8, [sp, #1048]
	eor	x8, x8, x9
	str	x8, [sp, #1048]
	b	LBB27_41
LBB27_41:
	b	LBB27_42
LBB27_42:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #104]
	ldr	x8, [sp, #1048]
	eor	x8, x8, x9
	str	x8, [sp, #1048]
	b	LBB27_43
LBB27_43:
	b	LBB27_44
LBB27_44:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #144]
	ldr	x8, [sp, #1048]
	eor	x8, x8, x9
	str	x8, [sp, #1048]
	b	LBB27_45
LBB27_45:
	b	LBB27_46
LBB27_46:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #184]
	ldr	x8, [sp, #1048]
	eor	x8, x8, x9
	str	x8, [sp, #1048]
	b	LBB27_47
LBB27_47:
	b	LBB27_48
LBB27_48:
	b	LBB27_49
LBB27_49:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #32]
	ldr	x8, [sp, #1056]
	eor	x8, x8, x9
	str	x8, [sp, #1056]
	b	LBB27_50
LBB27_50:
	b	LBB27_51
LBB27_51:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #72]
	ldr	x8, [sp, #1056]
	eor	x8, x8, x9
	str	x8, [sp, #1056]
	b	LBB27_52
LBB27_52:
	b	LBB27_53
LBB27_53:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #112]
	ldr	x8, [sp, #1056]
	eor	x8, x8, x9
	str	x8, [sp, #1056]
	b	LBB27_54
LBB27_54:
	b	LBB27_55
LBB27_55:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #152]
	ldr	x8, [sp, #1056]
	eor	x8, x8, x9
	str	x8, [sp, #1056]
	b	LBB27_56
LBB27_56:
	b	LBB27_57
LBB27_57:
	ldr	x8, [sp, #984]
	ldr	x9, [x8, #192]
	ldr	x8, [sp, #1056]
	eor	x8, x8, x9
	str	x8, [sp, #1056]
	b	LBB27_58
LBB27_58:
	b	LBB27_59
LBB27_59:
	b	LBB27_60
LBB27_60:
	ldr	x8, [sp, #1056]
	str	x8, [sp, #968]
	ldr	x0, [sp, #1032]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #968]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9]
	eor	x8, x8, x10
	str	x8, [x9]
	b	LBB27_61
LBB27_61:
	b	LBB27_62
LBB27_62:
	ldr	x8, [sp, #1056]
	str	x8, [sp, #960]
	ldr	x0, [sp, #1032]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #960]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #40]
	eor	x8, x8, x10
	str	x8, [x9, #40]
	b	LBB27_63
LBB27_63:
	b	LBB27_64
LBB27_64:
	ldr	x8, [sp, #1056]
	str	x8, [sp, #952]
	ldr	x0, [sp, #1032]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #952]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #80]
	eor	x8, x8, x10
	str	x8, [x9, #80]
	b	LBB27_65
LBB27_65:
	b	LBB27_66
LBB27_66:
	ldr	x8, [sp, #1056]
	str	x8, [sp, #944]
	ldr	x0, [sp, #1032]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #944]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #120]
	eor	x8, x8, x10
	str	x8, [x9, #120]
	b	LBB27_67
LBB27_67:
	b	LBB27_68
LBB27_68:
	ldr	x8, [sp, #1056]
	str	x8, [sp, #936]
	ldr	x0, [sp, #1032]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #936]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #160]
	eor	x8, x8, x10
	str	x8, [x9, #160]
	b	LBB27_69
LBB27_69:
	b	LBB27_70
LBB27_70:
	b	LBB27_71
LBB27_71:
	ldr	x8, [sp, #1024]
	str	x8, [sp, #928]
	ldr	x0, [sp, #1040]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #928]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #8]
	eor	x8, x8, x10
	str	x8, [x9, #8]
	b	LBB27_72
LBB27_72:
	b	LBB27_73
LBB27_73:
	ldr	x8, [sp, #1024]
	str	x8, [sp, #920]
	ldr	x0, [sp, #1040]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #920]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #48]
	eor	x8, x8, x10
	str	x8, [x9, #48]
	b	LBB27_74
LBB27_74:
	b	LBB27_75
LBB27_75:
	ldr	x8, [sp, #1024]
	str	x8, [sp, #912]
	ldr	x0, [sp, #1040]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #912]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #88]
	eor	x8, x8, x10
	str	x8, [x9, #88]
	b	LBB27_76
LBB27_76:
	b	LBB27_77
LBB27_77:
	ldr	x8, [sp, #1024]
	str	x8, [sp, #904]
	ldr	x0, [sp, #1040]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #904]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #128]
	eor	x8, x8, x10
	str	x8, [x9, #128]
	b	LBB27_78
LBB27_78:
	b	LBB27_79
LBB27_79:
	ldr	x8, [sp, #1024]
	str	x8, [sp, #896]
	ldr	x0, [sp, #1040]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #896]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #168]
	eor	x8, x8, x10
	str	x8, [x9, #168]
	b	LBB27_80
LBB27_80:
	b	LBB27_81
LBB27_81:
	b	LBB27_82
LBB27_82:
	ldr	x8, [sp, #1032]
	str	x8, [sp, #888]
	ldr	x0, [sp, #1048]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #888]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #16]
	eor	x8, x8, x10
	str	x8, [x9, #16]
	b	LBB27_83
LBB27_83:
	b	LBB27_84
LBB27_84:
	ldr	x8, [sp, #1032]
	str	x8, [sp, #880]
	ldr	x0, [sp, #1048]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #880]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #56]
	eor	x8, x8, x10
	str	x8, [x9, #56]
	b	LBB27_85
LBB27_85:
	b	LBB27_86
LBB27_86:
	ldr	x8, [sp, #1032]
	str	x8, [sp, #872]
	ldr	x0, [sp, #1048]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #872]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #96]
	eor	x8, x8, x10
	str	x8, [x9, #96]
	b	LBB27_87
LBB27_87:
	b	LBB27_88
LBB27_88:
	ldr	x8, [sp, #1032]
	str	x8, [sp, #864]
	ldr	x0, [sp, #1048]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #864]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #136]
	eor	x8, x8, x10
	str	x8, [x9, #136]
	b	LBB27_89
LBB27_89:
	b	LBB27_90
LBB27_90:
	ldr	x8, [sp, #1032]
	str	x8, [sp, #856]
	ldr	x0, [sp, #1048]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #856]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #176]
	eor	x8, x8, x10
	str	x8, [x9, #176]
	b	LBB27_91
LBB27_91:
	b	LBB27_92
LBB27_92:
	b	LBB27_93
LBB27_93:
	ldr	x8, [sp, #1040]
	str	x8, [sp, #848]
	ldr	x0, [sp, #1056]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #848]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #24]
	eor	x8, x8, x10
	str	x8, [x9, #24]
	b	LBB27_94
LBB27_94:
	b	LBB27_95
LBB27_95:
	ldr	x8, [sp, #1040]
	str	x8, [sp, #840]
	ldr	x0, [sp, #1056]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #840]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #64]
	eor	x8, x8, x10
	str	x8, [x9, #64]
	b	LBB27_96
LBB27_96:
	b	LBB27_97
LBB27_97:
	ldr	x8, [sp, #1040]
	str	x8, [sp, #832]
	ldr	x0, [sp, #1056]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #832]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #104]
	eor	x8, x8, x10
	str	x8, [x9, #104]
	b	LBB27_98
LBB27_98:
	b	LBB27_99
LBB27_99:
	ldr	x8, [sp, #1040]
	str	x8, [sp, #824]
	ldr	x0, [sp, #1056]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #824]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #144]
	eor	x8, x8, x10
	str	x8, [x9, #144]
	b	LBB27_100
LBB27_100:
	b	LBB27_101
LBB27_101:
	ldr	x8, [sp, #1040]
	str	x8, [sp, #816]
	ldr	x0, [sp, #1056]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #816]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #184]
	eor	x8, x8, x10
	str	x8, [x9, #184]
	b	LBB27_102
LBB27_102:
	b	LBB27_103
LBB27_103:
	b	LBB27_104
LBB27_104:
	ldr	x8, [sp, #1048]
	str	x8, [sp, #808]
	ldr	x0, [sp, #1024]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #808]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #32]
	eor	x8, x8, x10
	str	x8, [x9, #32]
	b	LBB27_105
LBB27_105:
	b	LBB27_106
LBB27_106:
	ldr	x8, [sp, #1048]
	str	x8, [sp, #800]
	ldr	x0, [sp, #1024]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #800]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #72]
	eor	x8, x8, x10
	str	x8, [x9, #72]
	b	LBB27_107
LBB27_107:
	b	LBB27_108
LBB27_108:
	ldr	x8, [sp, #1048]
	str	x8, [sp, #792]
	ldr	x0, [sp, #1024]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #792]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #112]
	eor	x8, x8, x10
	str	x8, [x9, #112]
	b	LBB27_109
LBB27_109:
	b	LBB27_110
LBB27_110:
	ldr	x8, [sp, #1048]
	str	x8, [sp, #784]
	ldr	x0, [sp, #1024]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #784]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #152]
	eor	x8, x8, x10
	str	x8, [x9, #152]
	b	LBB27_111
LBB27_111:
	b	LBB27_112
LBB27_112:
	ldr	x8, [sp, #1048]
	str	x8, [sp, #776]
	ldr	x0, [sp, #1024]
	mov	w1, #1
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	ldr	x8, [sp, #776]
	ldr	x9, [sp, #984]
	eor	x10, x8, x0
	ldr	x8, [x9, #192]
	eor	x8, x8, x10
	str	x8, [x9, #192]
	b	LBB27_113
LBB27_113:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #8]
	str	x8, [sp, #1064]
	b	LBB27_114
LBB27_114:
	add	x0, sp, #1072
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #1072]
	str	x8, [sp, #768]
	subs	x8, x8, #25
	b.hs	LBB27_116
	b	LBB27_115
LBB27_115:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #768]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #744]
	add	x0, sp, #1264
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #744]
	ldr	w1, [sp, #1264]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #752]
	add	x0, sp, #1360
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #1360]
	str	x8, [sp, #760]
	subs	x8, x8, #25
	b.lo	LBB27_117
	b	LBB27_118
LBB27_116:
	ldr	x0, [sp, #768]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_117:
	ldr	x8, [sp, #752]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #760]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_119
LBB27_118:
	ldr	x0, [sp, #760]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_119:
	b	LBB27_120
LBB27_120:
	add	x0, sp, #1552
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #1560]
	str	x8, [sp, #736]
	subs	x8, x8, #25
	b.hs	LBB27_122
	b	LBB27_121
LBB27_121:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #736]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #712]
	add	x0, sp, #1744
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #712]
	ldr	w1, [sp, #1748]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #720]
	add	x0, sp, #1840
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #1848]
	str	x8, [sp, #728]
	subs	x8, x8, #25
	b.lo	LBB27_123
	b	LBB27_124
LBB27_122:
	ldr	x0, [sp, #736]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_123:
	ldr	x8, [sp, #720]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #728]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_125
LBB27_124:
	ldr	x0, [sp, #728]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_125:
	b	LBB27_126
LBB27_126:
	add	x0, sp, #2032
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #2048]
	str	x8, [sp, #704]
	subs	x8, x8, #25
	b.hs	LBB27_128
	b	LBB27_127
LBB27_127:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #704]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #680]
	add	x0, sp, #2224
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #680]
	ldr	w1, [sp, #2232]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #688]
	add	x0, sp, #2320
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #2336]
	str	x8, [sp, #696]
	subs	x8, x8, #25
	b.lo	LBB27_129
	b	LBB27_130
LBB27_128:
	ldr	x0, [sp, #704]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_129:
	ldr	x8, [sp, #688]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #696]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_131
LBB27_130:
	ldr	x0, [sp, #696]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_131:
	b	LBB27_132
LBB27_132:
	add	x0, sp, #2512
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #2536]
	str	x8, [sp, #672]
	subs	x8, x8, #25
	b.hs	LBB27_134
	b	LBB27_133
LBB27_133:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #672]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #648]
	add	x0, sp, #2704
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #648]
	ldr	w1, [sp, #2716]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #656]
	add	x0, sp, #2800
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #2824]
	str	x8, [sp, #664]
	subs	x8, x8, #25
	b.lo	LBB27_135
	b	LBB27_136
LBB27_134:
	ldr	x0, [sp, #672]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_135:
	ldr	x8, [sp, #656]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #664]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_137
LBB27_136:
	ldr	x0, [sp, #664]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_137:
	b	LBB27_138
LBB27_138:
	add	x0, sp, #2992
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #3024]
	str	x8, [sp, #640]
	subs	x8, x8, #25
	b.hs	LBB27_140
	b	LBB27_139
LBB27_139:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #640]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #616]
	add	x0, sp, #3184
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #616]
	ldr	w1, [sp, #3200]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #624]
	add	x0, sp, #3280
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #3312]
	str	x8, [sp, #632]
	subs	x8, x8, #25
	b.lo	LBB27_141
	b	LBB27_142
LBB27_140:
	ldr	x0, [sp, #640]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_141:
	ldr	x8, [sp, #624]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #632]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_143
LBB27_142:
	ldr	x0, [sp, #632]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_143:
	b	LBB27_144
LBB27_144:
	add	x0, sp, #3472
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #3512]
	str	x8, [sp, #608]
	subs	x8, x8, #25
	b.hs	LBB27_146
	b	LBB27_145
LBB27_145:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #608]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #584]
	add	x0, sp, #3664
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #584]
	ldr	w1, [sp, #3684]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #592]
	add	x0, sp, #3760
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #3800]
	str	x8, [sp, #600]
	subs	x8, x8, #25
	b.lo	LBB27_147
	b	LBB27_148
LBB27_146:
	ldr	x0, [sp, #608]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_147:
	ldr	x8, [sp, #592]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #600]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_149
LBB27_148:
	ldr	x0, [sp, #600]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_149:
	b	LBB27_150
LBB27_150:
	add	x0, sp, #3952
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #4000]
	str	x8, [sp, #576]
	subs	x8, x8, #25
	b.hs	LBB27_152
	b	LBB27_151
LBB27_151:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #576]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #552]
	add	x0, sp, #1, lsl #12
	add	x0, x0, #48
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #552]
	ldr	w1, [sp, #4168]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #560]
	add	x0, sp, #1, lsl #12
	add	x0, x0, #144
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #4288]
	str	x8, [sp, #568]
	subs	x8, x8, #25
	b.lo	LBB27_153
	b	LBB27_154
LBB27_152:
	ldr	x0, [sp, #576]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_153:
	ldr	x8, [sp, #560]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #568]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_155
LBB27_154:
	ldr	x0, [sp, #568]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_155:
	b	LBB27_156
LBB27_156:
	add	x0, sp, #1, lsl #12
	add	x0, x0, #336
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #4488]
	str	x8, [sp, #544]
	subs	x8, x8, #25
	b.hs	LBB27_158
	b	LBB27_157
LBB27_157:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #544]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #520]
	add	x0, sp, #1, lsl #12
	add	x0, x0, #528
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #520]
	ldr	w1, [sp, #4652]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #528]
	add	x0, sp, #1, lsl #12
	add	x0, x0, #624
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #4776]
	str	x8, [sp, #536]
	subs	x8, x8, #25
	b.lo	LBB27_159
	b	LBB27_160
LBB27_158:
	ldr	x0, [sp, #544]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_159:
	ldr	x8, [sp, #528]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #536]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_161
LBB27_160:
	ldr	x0, [sp, #536]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_161:
	b	LBB27_162
LBB27_162:
	add	x0, sp, #1, lsl #12
	add	x0, x0, #816
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #4976]
	str	x8, [sp, #512]
	subs	x8, x8, #25
	b.hs	LBB27_164
	b	LBB27_163
LBB27_163:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #512]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #488]
	add	x0, sp, #1, lsl #12
	add	x0, x0, #1008
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #488]
	ldr	w1, [sp, #5136]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #496]
	add	x0, sp, #1, lsl #12
	add	x0, x0, #1104
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #5264]
	str	x8, [sp, #504]
	subs	x8, x8, #25
	b.lo	LBB27_165
	b	LBB27_166
LBB27_164:
	ldr	x0, [sp, #512]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_165:
	ldr	x8, [sp, #496]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #504]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_167
LBB27_166:
	ldr	x0, [sp, #504]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_167:
	b	LBB27_168
LBB27_168:
	add	x0, sp, #1, lsl #12
	add	x0, x0, #1296
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #5464]
	str	x8, [sp, #480]
	subs	x8, x8, #25
	b.hs	LBB27_170
	b	LBB27_169
LBB27_169:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #480]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #456]
	add	x0, sp, #1, lsl #12
	add	x0, x0, #1488
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #456]
	ldr	w1, [sp, #5620]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #464]
	add	x0, sp, #1, lsl #12
	add	x0, x0, #1584
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #5752]
	str	x8, [sp, #472]
	subs	x8, x8, #25
	b.lo	LBB27_171
	b	LBB27_172
LBB27_170:
	ldr	x0, [sp, #480]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_171:
	ldr	x8, [sp, #464]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #472]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_173
LBB27_172:
	ldr	x0, [sp, #472]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_173:
	b	LBB27_174
LBB27_174:
	add	x0, sp, #1, lsl #12
	add	x0, x0, #1776
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #5952]
	str	x8, [sp, #448]
	subs	x8, x8, #25
	b.hs	LBB27_176
	b	LBB27_175
LBB27_175:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #448]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #424]
	add	x0, sp, #1, lsl #12
	add	x0, x0, #1968
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #424]
	ldr	w1, [sp, #6104]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #432]
	add	x0, sp, #1, lsl #12
	add	x0, x0, #2064
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #6240]
	str	x8, [sp, #440]
	subs	x8, x8, #25
	b.lo	LBB27_177
	b	LBB27_178
LBB27_176:
	ldr	x0, [sp, #448]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_177:
	ldr	x8, [sp, #432]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #440]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_179
LBB27_178:
	ldr	x0, [sp, #440]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_179:
	b	LBB27_180
LBB27_180:
	add	x0, sp, #1, lsl #12
	add	x0, x0, #2256
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #6440]
	str	x8, [sp, #416]
	subs	x8, x8, #25
	b.hs	LBB27_182
	b	LBB27_181
LBB27_181:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #416]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #392]
	add	x0, sp, #1, lsl #12
	add	x0, x0, #2448
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #392]
	ldr	w1, [sp, #6588]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #400]
	add	x0, sp, #1, lsl #12
	add	x0, x0, #2544
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #6728]
	str	x8, [sp, #408]
	subs	x8, x8, #25
	b.lo	LBB27_183
	b	LBB27_184
LBB27_182:
	ldr	x0, [sp, #416]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_183:
	ldr	x8, [sp, #400]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #408]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_185
LBB27_184:
	ldr	x0, [sp, #408]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_185:
	b	LBB27_186
LBB27_186:
	add	x0, sp, #1, lsl #12
	add	x0, x0, #2736
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #6928]
	str	x8, [sp, #384]
	subs	x8, x8, #25
	b.hs	LBB27_188
	b	LBB27_187
LBB27_187:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #384]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #360]
	add	x0, sp, #1, lsl #12
	add	x0, x0, #2928
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #360]
	ldr	w1, [sp, #7072]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #368]
	add	x0, sp, #1, lsl #12
	add	x0, x0, #3024
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #7216]
	str	x8, [sp, #376]
	subs	x8, x8, #25
	b.lo	LBB27_189
	b	LBB27_190
LBB27_188:
	ldr	x0, [sp, #384]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_189:
	ldr	x8, [sp, #368]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #376]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_191
LBB27_190:
	ldr	x0, [sp, #376]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_191:
	b	LBB27_192
LBB27_192:
	add	x0, sp, #1, lsl #12
	add	x0, x0, #3216
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #7416]
	str	x8, [sp, #352]
	subs	x8, x8, #25
	b.hs	LBB27_194
	b	LBB27_193
LBB27_193:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #352]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #328]
	add	x0, sp, #1, lsl #12
	add	x0, x0, #3408
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #328]
	ldr	w1, [sp, #7556]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #336]
	add	x0, sp, #1, lsl #12
	add	x0, x0, #3504
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #7704]
	str	x8, [sp, #344]
	subs	x8, x8, #25
	b.lo	LBB27_195
	b	LBB27_196
LBB27_194:
	ldr	x0, [sp, #352]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_195:
	ldr	x8, [sp, #336]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #344]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_197
LBB27_196:
	ldr	x0, [sp, #344]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_197:
	b	LBB27_198
LBB27_198:
	add	x0, sp, #1, lsl #12
	add	x0, x0, #3696
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #7904]
	str	x8, [sp, #320]
	subs	x8, x8, #25
	b.hs	LBB27_200
	b	LBB27_199
LBB27_199:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #320]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #296]
	add	x0, sp, #1, lsl #12
	add	x0, x0, #3888
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #296]
	ldr	w1, [sp, #8040]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #304]
	add	x0, sp, #1, lsl #12
	add	x0, x0, #3984
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #8192]
	str	x8, [sp, #312]
	subs	x8, x8, #25
	b.lo	LBB27_201
	b	LBB27_202
LBB27_200:
	ldr	x0, [sp, #320]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_201:
	ldr	x8, [sp, #304]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #312]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_203
LBB27_202:
	ldr	x0, [sp, #312]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_203:
	b	LBB27_204
LBB27_204:
	add	x0, sp, #2, lsl #12
	add	x0, x0, #80
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #8392]
	str	x8, [sp, #288]
	subs	x8, x8, #25
	b.hs	LBB27_206
	b	LBB27_205
LBB27_205:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #288]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #264]
	add	x0, sp, #2, lsl #12
	add	x0, x0, #272
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #264]
	ldr	w1, [sp, #8524]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #272]
	add	x0, sp, #2, lsl #12
	add	x0, x0, #368
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #8680]
	str	x8, [sp, #280]
	subs	x8, x8, #25
	b.lo	LBB27_207
	b	LBB27_208
LBB27_206:
	ldr	x0, [sp, #288]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_207:
	ldr	x8, [sp, #272]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #280]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_209
LBB27_208:
	ldr	x0, [sp, #280]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_209:
	b	LBB27_210
LBB27_210:
	add	x0, sp, #2, lsl #12
	add	x0, x0, #560
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #8880]
	str	x8, [sp, #256]
	subs	x8, x8, #25
	b.hs	LBB27_212
	b	LBB27_211
LBB27_211:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #256]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #232]
	add	x0, sp, #2, lsl #12
	add	x0, x0, #752
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #232]
	ldr	w1, [sp, #9008]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #240]
	add	x0, sp, #2, lsl #12
	add	x0, x0, #848
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #9168]
	str	x8, [sp, #248]
	subs	x8, x8, #25
	b.lo	LBB27_213
	b	LBB27_214
LBB27_212:
	ldr	x0, [sp, #256]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_213:
	ldr	x8, [sp, #240]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #248]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_215
LBB27_214:
	ldr	x0, [sp, #248]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_215:
	b	LBB27_216
LBB27_216:
	add	x0, sp, #2, lsl #12
	add	x0, x0, #1040
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #9368]
	str	x8, [sp, #224]
	subs	x8, x8, #25
	b.hs	LBB27_218
	b	LBB27_217
LBB27_217:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #224]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #200]
	add	x0, sp, #2, lsl #12
	add	x0, x0, #1232
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #200]
	ldr	w1, [sp, #9492]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #208]
	add	x0, sp, #2, lsl #12
	add	x0, x0, #1328
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #9656]
	str	x8, [sp, #216]
	subs	x8, x8, #25
	b.lo	LBB27_219
	b	LBB27_220
LBB27_218:
	ldr	x0, [sp, #224]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_219:
	ldr	x8, [sp, #208]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #216]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_221
LBB27_220:
	ldr	x0, [sp, #216]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_221:
	b	LBB27_222
LBB27_222:
	add	x0, sp, #2, lsl #12
	add	x0, x0, #1520
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #9856]
	str	x8, [sp, #192]
	subs	x8, x8, #25
	b.hs	LBB27_224
	b	LBB27_223
LBB27_223:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #192]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #168]
	add	x0, sp, #2, lsl #12
	add	x0, x0, #1712
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #168]
	ldr	w1, [sp, #9976]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #176]
	add	x0, sp, #2, lsl #12
	add	x0, x0, #1808
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #10144]
	str	x8, [sp, #184]
	subs	x8, x8, #25
	b.lo	LBB27_225
	b	LBB27_226
LBB27_224:
	ldr	x0, [sp, #192]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_225:
	ldr	x8, [sp, #176]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #184]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_227
LBB27_226:
	ldr	x0, [sp, #184]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_227:
	b	LBB27_228
LBB27_228:
	add	x0, sp, #2, lsl #12
	add	x0, x0, #2000
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #10344]
	str	x8, [sp, #160]
	subs	x8, x8, #25
	b.hs	LBB27_230
	b	LBB27_229
LBB27_229:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #160]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #136]
	add	x0, sp, #2, lsl #12
	add	x0, x0, #2192
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #136]
	ldr	w1, [sp, #10460]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #144]
	add	x0, sp, #2, lsl #12
	add	x0, x0, #2288
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #10632]
	str	x8, [sp, #152]
	subs	x8, x8, #25
	b.lo	LBB27_231
	b	LBB27_232
LBB27_230:
	ldr	x0, [sp, #160]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_231:
	ldr	x8, [sp, #144]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #152]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_233
LBB27_232:
	ldr	x0, [sp, #152]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_233:
	b	LBB27_234
LBB27_234:
	add	x0, sp, #2, lsl #12
	add	x0, x0, #2480
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #10832]
	str	x8, [sp, #128]
	subs	x8, x8, #25
	b.hs	LBB27_236
	b	LBB27_235
LBB27_235:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #128]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #104]
	add	x0, sp, #2, lsl #12
	add	x0, x0, #2672
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #104]
	ldr	w1, [sp, #10944]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #112]
	add	x0, sp, #2, lsl #12
	add	x0, x0, #2768
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #11120]
	str	x8, [sp, #120]
	subs	x8, x8, #25
	b.lo	LBB27_237
	b	LBB27_238
LBB27_236:
	ldr	x0, [sp, #128]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_237:
	ldr	x8, [sp, #112]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #120]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_239
LBB27_238:
	ldr	x0, [sp, #120]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_239:
	b	LBB27_240
LBB27_240:
	add	x0, sp, #2, lsl #12
	add	x0, x0, #2960
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #11320]
	str	x8, [sp, #96]
	subs	x8, x8, #25
	b.hs	LBB27_242
	b	LBB27_241
LBB27_241:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #96]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #72]
	add	x0, sp, #2, lsl #12
	add	x0, x0, #3152
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #72]
	ldr	w1, [sp, #11428]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #80]
	add	x0, sp, #2, lsl #12
	add	x0, x0, #3248
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #11608]
	str	x8, [sp, #88]
	subs	x8, x8, #25
	b.lo	LBB27_243
	b	LBB27_244
LBB27_242:
	ldr	x0, [sp, #96]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_243:
	ldr	x8, [sp, #80]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #88]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_245
LBB27_244:
	ldr	x0, [sp, #88]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_245:
	b	LBB27_246
LBB27_246:
	add	x0, sp, #2, lsl #12
	add	x0, x0, #3440
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #11808]
	str	x8, [sp, #64]
	subs	x8, x8, #25
	b.hs	LBB27_248
	b	LBB27_247
LBB27_247:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #64]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #40]
	add	x0, sp, #2, lsl #12
	add	x0, x0, #3632
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #40]
	ldr	w1, [sp, #11912]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #48]
	add	x0, sp, #2, lsl #12
	add	x0, x0, #3728
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #12096]
	str	x8, [sp, #56]
	subs	x8, x8, #25
	b.lo	LBB27_249
	b	LBB27_250
LBB27_248:
	ldr	x0, [sp, #64]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_249:
	ldr	x8, [sp, #48]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #56]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_251
LBB27_250:
	ldr	x0, [sp, #56]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_251:
	b	LBB27_252
LBB27_252:
	add	x0, sp, #2, lsl #12
	add	x0, x0, #3920
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #12296]
	str	x8, [sp, #32]
	subs	x8, x8, #25
	b.hs	LBB27_254
	b	LBB27_253
LBB27_253:
	ldr	x8, [sp, #984]
	ldr	x9, [sp, #32]
	ldr	x8, [x8, x9, lsl #3]
	str	x8, [sp, #1024]
	ldr	x8, [sp, #1064]
	str	x8, [sp, #8]
	add	x0, sp, #3, lsl #12
	add	x0, x0, #16
	mov	w8, #96
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20@PAGEOFF
	bl	_memcpy
	ldr	x0, [sp, #8]
	ldr	w1, [sp, #12396]
	bl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	str	x0, [sp, #16]
	add	x0, sp, #3, lsl #12
	add	x0, x0, #112
	mov	w8, #192
	mov	x2, x8
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17@PAGEOFF
	bl	_memcpy
	ldr	x8, [sp, #12584]
	str	x8, [sp, #24]
	subs	x8, x8, #25
	b.lo	LBB27_255
	b	LBB27_256
LBB27_254:
	ldr	x0, [sp, #32]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_255:
	ldr	x8, [sp, #16]
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #24]
	str	x8, [x9, x10, lsl #3]
	ldr	x8, [sp, #1024]
	str	x8, [sp, #1064]
	b	LBB27_257
LBB27_256:
	ldr	x0, [sp, #24]
	mov	w8, #25
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB27_257:
	b	LBB27_258
LBB27_258:
	b	LBB27_259
LBB27_259:
	ldr	x8, [sp, #984]
	ldr	x8, [x8]
	str	x8, [sp, #1024]
	b	LBB27_260
LBB27_260:
	b	LBB27_261
LBB27_261:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #8]
	str	x8, [sp, #1032]
	b	LBB27_262
LBB27_262:
	b	LBB27_263
LBB27_263:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #16]
	str	x8, [sp, #1040]
	b	LBB27_264
LBB27_264:
	b	LBB27_265
LBB27_265:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #24]
	str	x8, [sp, #1048]
	b	LBB27_266
LBB27_266:
	b	LBB27_267
LBB27_267:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #32]
	str	x8, [sp, #1056]
	b	LBB27_268
LBB27_268:
	b	LBB27_269
LBB27_269:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1024]
	ldr	x11, [sp, #1032]
	ldr	x10, [sp, #1040]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9]
	b	LBB27_270
LBB27_270:
	b	LBB27_271
LBB27_271:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1032]
	ldr	x11, [sp, #1040]
	ldr	x10, [sp, #1048]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #8]
	b	LBB27_272
LBB27_272:
	b	LBB27_273
LBB27_273:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1040]
	ldr	x11, [sp, #1048]
	ldr	x10, [sp, #1056]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #16]
	b	LBB27_274
LBB27_274:
	b	LBB27_275
LBB27_275:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1048]
	ldr	x11, [sp, #1056]
	ldr	x10, [sp, #1024]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #24]
	b	LBB27_276
LBB27_276:
	b	LBB27_277
LBB27_277:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1056]
	ldr	x11, [sp, #1024]
	ldr	x10, [sp, #1032]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #32]
	b	LBB27_278
LBB27_278:
	b	LBB27_279
LBB27_279:
	b	LBB27_280
LBB27_280:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #40]
	str	x8, [sp, #1024]
	b	LBB27_281
LBB27_281:
	b	LBB27_282
LBB27_282:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #48]
	str	x8, [sp, #1032]
	b	LBB27_283
LBB27_283:
	b	LBB27_284
LBB27_284:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #56]
	str	x8, [sp, #1040]
	b	LBB27_285
LBB27_285:
	b	LBB27_286
LBB27_286:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #64]
	str	x8, [sp, #1048]
	b	LBB27_287
LBB27_287:
	b	LBB27_288
LBB27_288:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #72]
	str	x8, [sp, #1056]
	b	LBB27_289
LBB27_289:
	b	LBB27_290
LBB27_290:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1024]
	ldr	x11, [sp, #1032]
	ldr	x10, [sp, #1040]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #40]
	b	LBB27_291
LBB27_291:
	b	LBB27_292
LBB27_292:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1032]
	ldr	x11, [sp, #1040]
	ldr	x10, [sp, #1048]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #48]
	b	LBB27_293
LBB27_293:
	b	LBB27_294
LBB27_294:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1040]
	ldr	x11, [sp, #1048]
	ldr	x10, [sp, #1056]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #56]
	b	LBB27_295
LBB27_295:
	b	LBB27_296
LBB27_296:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1048]
	ldr	x11, [sp, #1056]
	ldr	x10, [sp, #1024]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #64]
	b	LBB27_297
LBB27_297:
	b	LBB27_298
LBB27_298:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1056]
	ldr	x11, [sp, #1024]
	ldr	x10, [sp, #1032]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #72]
	b	LBB27_299
LBB27_299:
	b	LBB27_300
LBB27_300:
	b	LBB27_301
LBB27_301:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #80]
	str	x8, [sp, #1024]
	b	LBB27_302
LBB27_302:
	b	LBB27_303
LBB27_303:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #88]
	str	x8, [sp, #1032]
	b	LBB27_304
LBB27_304:
	b	LBB27_305
LBB27_305:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #96]
	str	x8, [sp, #1040]
	b	LBB27_306
LBB27_306:
	b	LBB27_307
LBB27_307:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #104]
	str	x8, [sp, #1048]
	b	LBB27_308
LBB27_308:
	b	LBB27_309
LBB27_309:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #112]
	str	x8, [sp, #1056]
	b	LBB27_310
LBB27_310:
	b	LBB27_311
LBB27_311:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1024]
	ldr	x11, [sp, #1032]
	ldr	x10, [sp, #1040]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #80]
	b	LBB27_312
LBB27_312:
	b	LBB27_313
LBB27_313:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1032]
	ldr	x11, [sp, #1040]
	ldr	x10, [sp, #1048]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #88]
	b	LBB27_314
LBB27_314:
	b	LBB27_315
LBB27_315:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1040]
	ldr	x11, [sp, #1048]
	ldr	x10, [sp, #1056]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #96]
	b	LBB27_316
LBB27_316:
	b	LBB27_317
LBB27_317:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1048]
	ldr	x11, [sp, #1056]
	ldr	x10, [sp, #1024]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #104]
	b	LBB27_318
LBB27_318:
	b	LBB27_319
LBB27_319:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1056]
	ldr	x11, [sp, #1024]
	ldr	x10, [sp, #1032]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #112]
	b	LBB27_320
LBB27_320:
	b	LBB27_321
LBB27_321:
	b	LBB27_322
LBB27_322:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #120]
	str	x8, [sp, #1024]
	b	LBB27_323
LBB27_323:
	b	LBB27_324
LBB27_324:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #128]
	str	x8, [sp, #1032]
	b	LBB27_325
LBB27_325:
	b	LBB27_326
LBB27_326:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #136]
	str	x8, [sp, #1040]
	b	LBB27_327
LBB27_327:
	b	LBB27_328
LBB27_328:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #144]
	str	x8, [sp, #1048]
	b	LBB27_329
LBB27_329:
	b	LBB27_330
LBB27_330:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #152]
	str	x8, [sp, #1056]
	b	LBB27_331
LBB27_331:
	b	LBB27_332
LBB27_332:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1024]
	ldr	x11, [sp, #1032]
	ldr	x10, [sp, #1040]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #120]
	b	LBB27_333
LBB27_333:
	b	LBB27_334
LBB27_334:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1032]
	ldr	x11, [sp, #1040]
	ldr	x10, [sp, #1048]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #128]
	b	LBB27_335
LBB27_335:
	b	LBB27_336
LBB27_336:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1040]
	ldr	x11, [sp, #1048]
	ldr	x10, [sp, #1056]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #136]
	b	LBB27_337
LBB27_337:
	b	LBB27_338
LBB27_338:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1048]
	ldr	x11, [sp, #1056]
	ldr	x10, [sp, #1024]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #144]
	b	LBB27_339
LBB27_339:
	b	LBB27_340
LBB27_340:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1056]
	ldr	x11, [sp, #1024]
	ldr	x10, [sp, #1032]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #152]
	b	LBB27_341
LBB27_341:
	b	LBB27_342
LBB27_342:
	b	LBB27_343
LBB27_343:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #160]
	str	x8, [sp, #1024]
	b	LBB27_344
LBB27_344:
	b	LBB27_345
LBB27_345:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #168]
	str	x8, [sp, #1032]
	b	LBB27_346
LBB27_346:
	b	LBB27_347
LBB27_347:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #176]
	str	x8, [sp, #1040]
	b	LBB27_348
LBB27_348:
	b	LBB27_349
LBB27_349:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #184]
	str	x8, [sp, #1048]
	b	LBB27_350
LBB27_350:
	b	LBB27_351
LBB27_351:
	ldr	x8, [sp, #984]
	ldr	x8, [x8, #192]
	str	x8, [sp, #1056]
	b	LBB27_352
LBB27_352:
	b	LBB27_353
LBB27_353:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1024]
	ldr	x11, [sp, #1032]
	ldr	x10, [sp, #1040]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #160]
	b	LBB27_354
LBB27_354:
	b	LBB27_355
LBB27_355:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1032]
	ldr	x11, [sp, #1040]
	ldr	x10, [sp, #1048]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #168]
	b	LBB27_356
LBB27_356:
	b	LBB27_357
LBB27_357:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1040]
	ldr	x11, [sp, #1048]
	ldr	x10, [sp, #1056]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #176]
	b	LBB27_358
LBB27_358:
	b	LBB27_359
LBB27_359:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1048]
	ldr	x11, [sp, #1056]
	ldr	x10, [sp, #1024]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #184]
	b	LBB27_360
LBB27_360:
	b	LBB27_361
LBB27_361:
	ldr	x9, [sp, #984]
	ldr	x8, [sp, #1056]
	ldr	x11, [sp, #1024]
	ldr	x10, [sp, #1032]
	bic	x10, x10, x11
	eor	x8, x8, x10
	str	x8, [x9, #192]
	b	LBB27_362
LBB27_362:
	sub	x0, x29, #208
	adrp	x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.21@PAGE
	add	x1, x1, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.21@PAGEOFF
	mov	w8, #192
	mov	x2, x8
	bl	_memcpy
	ldr	x8, [sp, #976]
	subs	x8, x8, #24
	b.hs	LBB27_364
	b	LBB27_363
LBB27_363:
	ldr	x9, [sp, #984]
	ldr	x10, [sp, #976]
	sub	x8, x29, #208
	ldr	x10, [x8, x10, lsl #3]
	ldr	x8, [x9]
	eor	x8, x8, x10
	str	x8, [x9]
	b	LBB27_1
LBB27_364:
	ldr	x0, [sp, #976]
	mov	w8, #24
	mov	x1, x8
	adrp	x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGE
	add	x2, x2, l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
	.cfi_endproc

	.p2align	2
__ZN49_$LT$usize$u20$as$u20$core..iter..range..Step$GT$17forward_unchecked17h4e3a6d4f9ee35e51E:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp]
	str	x1, [sp, #8]
	b	LBB28_1
LBB28_1:
	ldr	x8, [sp]
	ldr	x9, [sp, #8]
	add	x0, x8, x9
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.globl	__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E
	.p2align	2
__ZN4core10intrinsics11rotate_left17h7d39ba1bb53a7f03E:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	mov	w9, #64
	udiv	w8, w1, w9
	mul	w8, w8, w9
	subs	w8, w1, w8
	mov	w8, w8
	mov	x10, x8
	mov	w8, #63
	mov	x9, x8
	and	x8, x10, #0x3f
	bic	x10, x9, x10
	lsl	x8, x0, x8
	lsr	x9, x0, #1
	lsr	x9, x9, x10
	orr	x8, x8, x9
	str	x8, [sp, #8]
	ldr	x0, [sp, #8]
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.globl	__ZN4core4iter5range101_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..Range$LT$A$GT$$GT$4next17h487307dbfd89e982E
	.p2align	2
__ZN4core4iter5range101_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..Range$LT$A$GT$$GT$4next17h487307dbfd89e982E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN89_$LT$core..ops..range..Range$LT$T$GT$$u20$as$u20$core..iter..range..RangeIteratorImpl$GT$9spec_next17he59ae403090f4d34E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN4core5array76_$LT$impl$u20$core..default..Default$u20$for$u20$$u5b$T$u3b$$u20$25$u5d$$GT$7default17hf004c3f6d3fa0678E
	.p2align	2
__ZN4core5array76_$LT$impl$u20$core..default..Default$u20$for$u20$$u5b$T$u3b$$u20$25$u5d$$GT$7default17hf004c3f6d3fa0678E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	x8, [sp, #8]
	b	LBB31_1
LBB31_1:
	b	LBB31_2
LBB31_2:
	b	LBB31_3
LBB31_3:
	b	LBB31_4
LBB31_4:
	b	LBB31_5
LBB31_5:
	b	LBB31_6
LBB31_6:
	b	LBB31_7
LBB31_7:
	b	LBB31_8
LBB31_8:
	b	LBB31_9
LBB31_9:
	b	LBB31_10
LBB31_10:
	b	LBB31_11
LBB31_11:
	b	LBB31_12
LBB31_12:
	b	LBB31_13
LBB31_13:
	b	LBB31_14
LBB31_14:
	b	LBB31_15
LBB31_15:
	b	LBB31_16
LBB31_16:
	b	LBB31_17
LBB31_17:
	b	LBB31_18
LBB31_18:
	b	LBB31_19
LBB31_19:
	b	LBB31_20
LBB31_20:
	b	LBB31_21
LBB31_21:
	b	LBB31_22
LBB31_22:
	b	LBB31_23
LBB31_23:
	b	LBB31_24
LBB31_24:
	ldr	x8, [sp, #8]
	str	xzr, [x8]
	str	xzr, [x8, #8]
	str	xzr, [x8, #16]
	str	xzr, [x8, #24]
	str	xzr, [x8, #32]
	str	xzr, [x8, #40]
	str	xzr, [x8, #48]
	str	xzr, [x8, #56]
	str	xzr, [x8, #64]
	str	xzr, [x8, #72]
	str	xzr, [x8, #80]
	str	xzr, [x8, #88]
	str	xzr, [x8, #96]
	str	xzr, [x8, #104]
	str	xzr, [x8, #112]
	str	xzr, [x8, #120]
	str	xzr, [x8, #128]
	str	xzr, [x8, #136]
	str	xzr, [x8, #144]
	str	xzr, [x8, #152]
	str	xzr, [x8, #160]
	str	xzr, [x8, #168]
	str	xzr, [x8, #176]
	str	xzr, [x8, #184]
	str	xzr, [x8, #192]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.globl	__ZN4core5array88_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u3b$$u20$N$u5d$$GT$9index_mut17h6413c554d30ef1a2E
	.p2align	2
__ZN4core5array88_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u3b$$u20$N$u5d$$GT$9index_mut17h6413c554d30ef1a2E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	mov	x0, x1
	ldr	x1, [sp, #8]
	mov	x3, x2
	mov	w8, #200
	mov	x2, x8
	bl	__ZN110_$LT$core..ops..range..RangeFrom$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17hf8910bea0f9121b5E
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN4core5slice20copy_from_slice_impl17h5b006b0ada326236E
	.p2align	2
__ZN4core5slice20copy_from_slice_impl17h5b006b0ada326236E:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	str	x1, [sp, #16]
	str	x2, [sp, #24]
	stur	x3, [x29, #-16]
	stur	x4, [x29, #-8]
	subs	x8, x1, x3
	b.ne	LBB33_2
	b	LBB33_1
LBB33_1:
	b	LBB33_3
LBB33_2:
	ldur	x2, [x29, #-8]
	ldur	x1, [x29, #-16]
	ldr	x0, [sp, #16]
	bl	__RNvNvNtCs6sq8b9ugfBC_4core5slice20copy_from_slice_impl17len_mismatch_fail
LBB33_3:
	ldr	x1, [sp, #24]
	ldr	x0, [sp, #8]
	ldr	x8, [sp, #16]
	lsr	x2, x8, #0
	bl	_memcpy
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$15copy_from_slice17h90565d7266541361E
	.p2align	2
__ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$15copy_from_slice17h90565d7266541361E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core5slice20copy_from_slice_impl17h5b006b0ada326236E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN62_$LT$tiny_keccak..Buffer$u20$as$u20$core..default..Default$GT$7default17h0ed2acd921513c1bE:
	.cfi_startproc
	sub	sp, sp, #240
	.cfi_def_cfa_offset 240
	stp	x29, x30, [sp, #224]
	add	x29, sp, #224
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x8, [sp, #8]
	add	x8, sp, #24
	str	x8, [sp, #16]
	bl	__ZN4core5array76_$LT$impl$u20$core..default..Default$u20$for$u20$$u5b$T$u3b$$u20$25$u5d$$GT$7default17hf004c3f6d3fa0678E
	ldr	x0, [sp, #8]
	ldr	x1, [sp, #16]
	mov	w8, #200
	mov	x2, x8
	bl	_memcpy
	.cfi_def_cfa wsp, 240
	ldp	x29, x30, [sp, #224]
	add	sp, sp, #240
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN62_$LT$tiny_keccak..shake..Shake$u20$as$u20$tiny_keccak..Xof$GT$7squeeze17h3ab19e1c776c538eE
	.p2align	2
__ZN62_$LT$tiny_keccak..shake..Shake$u20$as$u20$tiny_keccak..Xof$GT$7squeeze17h3ab19e1c776c538eE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN11tiny_keccak20KeccakState$LT$P$GT$7squeeze17ha717945d197ef533E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h3a4397634a7a4b48E
	.p2align	2
__ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h3a4397634a7a4b48E:
	.cfi_startproc
	ret
	.cfi_endproc

	.globl	__ZN65_$LT$tiny_keccak..shake..Shake$u20$as$u20$tiny_keccak..Hasher$GT$6update17h04b64b26c3235267E
	.p2align	2
__ZN65_$LT$tiny_keccak..shake..Shake$u20$as$u20$tiny_keccak..Hasher$GT$6update17h04b64b26c3235267E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN11tiny_keccak20KeccakState$LT$P$GT$6update17h6cf0f67317b78fd0E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN65_$LT$tiny_keccak..shake..Shake$u20$as$u20$tiny_keccak..Hasher$GT$8finalize17h9d3003b4579a6c66E
	.p2align	2
__ZN65_$LT$tiny_keccak..shake..Shake$u20$as$u20$tiny_keccak..Hasher$GT$8finalize17h9d3003b4579a6c66E:
	.cfi_startproc
	sub	sp, sp, #288
	.cfi_def_cfa_offset 288
	stp	x28, x27, [sp, #256]
	stp	x29, x30, [sp, #272]
	add	x29, sp, #272
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w27, -24
	.cfi_offset w28, -32
	str	x0, [sp]
	mov	x0, x1
	ldr	x1, [sp]
	str	x0, [sp, #16]
	str	x2, [sp, #24]
	add	x0, sp, #32
	str	x0, [sp, #8]
	mov	w8, #224
	mov	x2, x8
	bl	_memcpy
	ldr	x0, [sp, #8]
	ldr	x1, [sp, #16]
	ldr	x2, [sp, #24]
	bl	__ZN11tiny_keccak20KeccakState$LT$P$GT$8finalize17haa4d4d7977a7dc2dE
	.cfi_def_cfa wsp, 288
	ldp	x29, x30, [sp, #272]
	ldp	x28, x27, [sp, #256]
	add	sp, sp, #288
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w27
	.cfi_restore w28
	ret
	.cfi_endproc

	.globl	__ZN74_$LT$tiny_keccak..keccakf..KeccakF$u20$as$u20$tiny_keccak..Permutation$GT$7execute17haf6c9fde0f2d0721E
	.p2align	2
__ZN74_$LT$tiny_keccak..keccakf..KeccakF$u20$as$u20$tiny_keccak..Permutation$GT$7execute17haf6c9fde0f2d0721E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN11tiny_keccak6Buffer5words17h2abc719feefb2ca9E
	bl	__ZN11tiny_keccak7keccakf7keccakf17h722adf9b456eb8fdE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN89_$LT$core..ops..range..Range$LT$T$GT$$u20$as$u20$core..iter..range..RangeIteratorImpl$GT$9spec_next17he59ae403090f4d34E
	.p2align	2
__ZN89_$LT$core..ops..range..Range$LT$T$GT$$u20$as$u20$core..iter..range..RangeIteratorImpl$GT$9spec_next17he59ae403090f4d34E:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #24]
	ldr	x8, [x0]
	ldr	x9, [x0, #8]
	subs	x8, x8, x9
	b.lo	LBB41_2
	b	LBB41_1
LBB41_1:
	stur	xzr, [x29, #-16]
	b	LBB41_3
LBB41_2:
	ldr	x8, [sp, #24]
	ldr	x0, [x8]
	str	x0, [sp, #8]
	mov	w8, #1
	mov	x1, x8
	str	x1, [sp, #16]
	bl	__ZN49_$LT$usize$u20$as$u20$core..iter..range..Step$GT$17forward_unchecked17h4e3a6d4f9ee35e51E
	ldr	x10, [sp, #24]
	ldr	x9, [sp, #8]
	ldr	x8, [sp, #16]
	str	x0, [x10]
	stur	x9, [x29, #-8]
	stur	x8, [x29, #-16]
	b	LBB41_3
LBB41_3:
	ldur	x0, [x29, #-16]
	ldur	x1, [x29, #-8]
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.section	__TEXT,__const
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.0:
	.ascii	"rate cannot be equal 0"

	.section	__TEXT,__cstring,cstring_literals
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.1:
	.asciz	"/Users/kuangtalin/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/tiny-keccak-2.0.2/src/lib.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.2:
	.quad	l_anon.f2f66d2ae1aebd625494b85a32f55bc5.1
	.asciz	"c\000\000\000\000\000\000\000\210\001\000\000\t\000\000"

	.p2align	3, 0x0
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.3:
	.quad	l_anon.f2f66d2ae1aebd625494b85a32f55bc5.1
	.asciz	"c\000\000\000\000\000\000\000\253\001\000\000!\000\000"

	.p2align	3, 0x0
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.4:
	.quad	l_anon.f2f66d2ae1aebd625494b85a32f55bc5.1
	.asciz	"c\000\000\000\000\000\000\000\243\001\000\000%\000\000"

	.p2align	3, 0x0
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.5:
	.quad	l_anon.f2f66d2ae1aebd625494b85a32f55bc5.1
	.asciz	"c\000\000\000\000\000\000\000\310\001\000\000'\000\000"

	.p2align	3, 0x0
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.6:
	.quad	l_anon.f2f66d2ae1aebd625494b85a32f55bc5.1
	.asciz	"c\000\000\000\000\000\000\000\300\001\000\000+\000\000"

	.p2align	3, 0x0
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.7:
	.quad	l_anon.f2f66d2ae1aebd625494b85a32f55bc5.1
	.asciz	"c\000\000\000\000\000\000\000a\001\000\000(\000\000"

	.p2align	3, 0x0
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.8:
	.quad	l_anon.f2f66d2ae1aebd625494b85a32f55bc5.1
	.asciz	"c\000\000\000\000\000\000\000b\001\000\000*\000\000"

	.section	__TEXT,__const
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.9:
	.ascii	"assertion failed: dst.len() <= src.len()"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.10:
	.quad	l_anon.f2f66d2ae1aebd625494b85a32f55bc5.1
	.asciz	"c\000\000\000\000\000\000\000R\001\000\000\r\000\000"

	.p2align	3, 0x0
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.11:
	.quad	l_anon.f2f66d2ae1aebd625494b85a32f55bc5.1
	.asciz	"c\000\000\000\000\000\000\000Y\001\000\000'\000\000"

	.p2align	3, 0x0
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.12:
	.quad	l_anon.f2f66d2ae1aebd625494b85a32f55bc5.1
	.asciz	"c\000\000\000\000\000\000\000Z\001\000\000'\000\000"

	.p2align	3, 0x0
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.13:
	.quad	l_anon.f2f66d2ae1aebd625494b85a32f55bc5.1
	.asciz	"c\000\000\000\000\000\000\000M\001\000\000/\000\000"

	.p2align	3, 0x0
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.14:
	.quad	l_anon.f2f66d2ae1aebd625494b85a32f55bc5.1
	.asciz	"c\000\000\000\000\000\000\000M\001\000\0007\000\000"

	.p2align	3, 0x0
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.15:
	.quad	l_anon.f2f66d2ae1aebd625494b85a32f55bc5.1
	.asciz	"c\000\000\000\000\000\000\0008\001\000\000\026\000\000"

	.p2align	3, 0x0
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.16:
	.quad	l_anon.f2f66d2ae1aebd625494b85a32f55bc5.1
	.asciz	"c\000\000\000\000\000\000\0008\001\000\000 \000\000"

	.section	__TEXT,__const
	.p2align	3, 0x0
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.17:
	.asciz	"\n\000\000\000\000\000\000\000\007\000\000\000\000\000\000\000\013\000\000\000\000\000\000\000\021\000\000\000\000\000\000\000\022\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\005\000\000\000\000\000\000\000\020\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\025\000\000\000\000\000\000\000\030\000\000\000\000\000\000\000\004\000\000\000\000\000\000\000\017\000\000\000\000\000\000\000\027\000\000\000\000\000\000\000\023\000\000\000\000\000\000\000\r\000\000\000\000\000\000\000\f\000\000\000\000\000\000\000\002\000\000\000\000\000\000\000\024\000\000\000\000\000\000\000\016\000\000\000\000\000\000\000\026\000\000\000\000\000\000\000\t\000\000\000\000\000\000\000\006\000\000\000\000\000\000\000\001\000\000\000\000\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.18:
	.asciz	"/Users/kuangtalin/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/tiny-keccak-2.0.2/src/keccakf.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.19:
	.quad	l_anon.f2f66d2ae1aebd625494b85a32f55bc5.18
	.asciz	"g\000\000\000\000\000\000\000 \000\000\000\001\000\000"

	.section	__TEXT,__const
	.p2align	2, 0x0
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.20:
	.asciz	"\001\000\000\000\003\000\000\000\006\000\000\000\n\000\000\000\017\000\000\000\025\000\000\000\034\000\000\000$\000\000\000-\000\000\0007\000\000\000\002\000\000\000\016\000\000\000\033\000\000\000)\000\000\0008\000\000\000\b\000\000\000\031\000\000\000+\000\000\000>\000\000\000\022\000\000\000'\000\000\000=\000\000\000\024\000\000\000,\000\000"

	.p2align	3, 0x0
l_anon.f2f66d2ae1aebd625494b85a32f55bc5.21:
	.ascii	"\001\000\000\000\000\000\000\000\202\200\000\000\000\000\000\000\212\200\000\000\000\000\000\200\000\200\000\200\000\000\000\200\213\200\000\000\000\000\000\000\001\000\000\200\000\000\000\000\201\200\000\200\000\000\000\200\t\200\000\000\000\000\000\200\212\000\000\000\000\000\000\000\210\000\000\000\000\000\000\000\t\200\000\200\000\000\000\000\n\000\000\200\000\000\000\000\213\200\000\200\000\000\000\000\213\000\000\000\000\000\000\200\211\200\000\000\000\000\000\200\003\200\000\000\000\000\000\200\002\200\000\000\000\000\000\200\200\000\000\000\000\000\000\200\n\200\000\000\000\000\000\000\n\000\000\200\000\000\000\200\201\200\000\200\000\000\000\200\200\200\000\000\000\000\000\200\001\000\000\200\000\000\000\000\b\200\000\200\000\000\000\200"

.subsections_via_symbols
