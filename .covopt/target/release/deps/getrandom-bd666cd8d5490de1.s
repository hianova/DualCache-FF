	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN109_$LT$getrandom..error..Error$u20$as$u20$core..convert..From$LT$core..num..nonzero..NonZero$LT$u32$GT$$GT$$GT$4from17h5d6c8df9beda9d18E
	.p2align	2
__ZN109_$LT$getrandom..error..Error$u20$as$u20$core..convert..From$LT$core..num..nonzero..NonZero$LT$u32$GT$$GT$$GT$4from17h5d6c8df9beda9d18E:
	.cfi_startproc
	ret
	.cfi_endproc

	.globl	__ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17hcd30fb13fc3c8067E
	.p2align	2
__ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17hcd30fb13fc3c8067E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	mov	x2, x1
	ldr	x0, [x8]
	ldr	x1, [x8, #8]
	bl	__RNvXsh_NtCs6sq8b9ugfBC_4core3fmteNtB5_5Debug3fmt
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN4core10intrinsics23is_val_statically_known17h9c09ee9cc07495efE
	.p2align	2
__ZN4core10intrinsics23is_val_statically_known17h9c09ee9cc07495efE:
	.cfi_startproc
	mov	w8, #0
	and	w0, w8, #0x1
	ret
	.cfi_endproc

	.globl	__ZN4core3cmp3Ord3min17h985483d87f7f461bE
	.p2align	2
__ZN4core3cmp3Ord3min17h985483d87f7f461bE:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	str	x0, [sp, #16]
	str	x1, [sp, #24]
	mov	w8, #1
	strb	w8, [sp, #47]
	ldr	x8, [sp, #24]
	str	x8, [sp]
	ldr	x8, [sp, #16]
	str	x8, [sp, #8]
	b	LBB3_1
LBB3_1:
	ldr	x8, [sp]
	ldr	x9, [sp, #8]
	subs	x8, x8, x9
	b.lo	LBB3_3
	b	LBB3_2
LBB3_2:
	strb	wzr, [sp, #47]
	ldr	x8, [sp, #16]
	str	x8, [sp, #32]
	b	LBB3_4
LBB3_3:
	ldr	x8, [sp, #24]
	str	x8, [sp, #32]
	b	LBB3_4
LBB3_4:
	ldr	x0, [sp, #32]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.globl	__ZN4core3fmt2rt8Argument11new_display17h05ed16bf00e5446eE
	.p2align	2
__ZN4core3fmt2rt8Argument11new_display17h05ed16bf00e5446eE:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp]
	adrp	x9, __RNvXs9_NtNtNtCs6sq8b9ugfBC_4core3fmt3num3implNtB9_7Display3fmt@GOTPAGE
	ldr	x9, [x9, __RNvXs9_NtNtNtCs6sq8b9ugfBC_4core3fmt3num3implNtB9_7Display3fmt@GOTPAGEOFF]
	str	x9, [sp, #8]
	ldr	q0, [sp]
	str	q0, [x8]
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.globl	__ZN4core3fmt2rt8Argument11new_display17h6f42cbf0ac4457c6E
	.p2align	2
__ZN4core3fmt2rt8Argument11new_display17h6f42cbf0ac4457c6E:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp]
	adrp	x9, __RNvXs8_NtNtNtCs6sq8b9ugfBC_4core3fmt3num3impmNtB9_7Display3fmt@GOTPAGE
	ldr	x9, [x9, __RNvXs8_NtNtNtCs6sq8b9ugfBC_4core3fmt3num3impmNtB9_7Display3fmt@GOTPAGEOFF]
	str	x9, [sp, #8]
	ldr	q0, [sp]
	str	q0, [x8]
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3fmt3num50_$LT$impl$u20$core..fmt..Debug$u20$for$u20$i32$GT$3fmt17he5443c78a2fb1dd0E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	str	x1, [sp, #16]
	ldr	w8, [x1, #16]
	tbnz	w8, #25, LBB6_2
	b	LBB6_1
LBB6_1:
	ldr	x8, [sp, #16]
	ldr	w8, [x8, #16]
	tbz	w8, #26, LBB6_3
	b	LBB6_4
LBB6_2:
	ldr	x1, [sp, #16]
	ldr	x0, [sp, #8]
	bl	__RNvXsv_NtNtCs6sq8b9ugfBC_4core3fmt3numlNtB7_8LowerHex3fmt
	sturb	w0, [x29, #-1]
	b	LBB6_6
LBB6_3:
	ldr	x1, [sp, #16]
	ldr	x0, [sp, #8]
	bl	__RNvXs9_NtNtNtCs6sq8b9ugfBC_4core3fmt3num3implNtB9_7Display3fmt
	sturb	w0, [x29, #-1]
	b	LBB6_5
LBB6_4:
	ldr	x1, [sp, #16]
	ldr	x0, [sp, #8]
	bl	__RNvXsx_NtNtCs6sq8b9ugfBC_4core3fmt3numlNtB7_8UpperHex3fmt
	sturb	w0, [x29, #-1]
	b	LBB6_5
LBB6_5:
	b	LBB6_6
LBB6_6:
	ldurb	w8, [x29, #-1]
	and	w0, w8, #0x1
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3fmt3num50_$LT$impl$u20$core..fmt..Debug$u20$for$u20$u32$GT$3fmt17h1e9149f777ef7437E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	str	x1, [sp, #16]
	ldr	w8, [x1, #16]
	tbnz	w8, #25, LBB7_2
	b	LBB7_1
LBB7_1:
	ldr	x8, [sp, #16]
	ldr	w8, [x8, #16]
	tbz	w8, #26, LBB7_3
	b	LBB7_4
LBB7_2:
	ldr	x1, [sp, #16]
	ldr	x0, [sp, #8]
	bl	__RNvXsu_NtNtCs6sq8b9ugfBC_4core3fmt3nummNtB7_8LowerHex3fmt
	sturb	w0, [x29, #-1]
	b	LBB7_6
LBB7_3:
	ldr	x1, [sp, #16]
	ldr	x0, [sp, #8]
	bl	__RNvXs8_NtNtNtCs6sq8b9ugfBC_4core3fmt3num3impmNtB9_7Display3fmt
	sturb	w0, [x29, #-1]
	b	LBB7_5
LBB7_4:
	ldr	x1, [sp, #16]
	ldr	x0, [sp, #8]
	bl	__RNvXsw_NtNtCs6sq8b9ugfBC_4core3fmt3nummNtB7_8UpperHex3fmt
	sturb	w0, [x29, #-1]
	b	LBB7_5
LBB7_5:
	b	LBB7_6
LBB7_6:
	ldurb	w8, [x29, #-1]
	and	w0, w8, #0x1
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3fmt9Arguments23as_statically_known_str17h0b8c2151ed2ccaafE:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	str	x0, [sp, #24]
	ldr	x8, [x0, #8]
	str	x8, [sp, #32]
	and	x8, x8, #0x1
	subs	x8, x8, #1
	b.ne	LBB8_2
	b	LBB8_1
LBB8_1:
	ldr	x8, [sp, #32]
	ldr	x9, [sp, #24]
	ldr	x9, [x9]
	str	x9, [sp, #8]
	lsr	x8, x8, #1
	str	x8, [sp, #16]
	b	LBB8_3
LBB8_2:
	adrp	x9, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.0@PAGE
	adrp	x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.0@PAGE
	add	x8, x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.0@PAGEOFF
	ldr	x9, [x9, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.0@PAGEOFF]
	ldr	x8, [x8, #8]
	str	x9, [sp, #40]
	str	x8, [sp, #48]
	b	LBB8_4
LBB8_3:
	ldr	x8, [sp, #16]
	ldr	x9, [sp, #8]
	str	x9, [sp, #40]
	str	x8, [sp, #48]
	b	LBB8_4
LBB8_4:
	strb	wzr, [sp, #63]
	ldrb	w8, [sp, #63]
	tbnz	w8, #0, LBB8_6
	b	LBB8_5
LBB8_5:
	adrp	x9, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.0@PAGE
	adrp	x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.0@PAGE
	add	x8, x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.0@PAGEOFF
	ldr	x9, [x9, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.0@PAGEOFF]
	ldr	x8, [x8, #8]
	str	x9, [sp, #40]
	str	x8, [sp, #48]
	b	LBB8_7
LBB8_6:
	b	LBB8_7
LBB8_7:
	ldr	x0, [sp, #40]
	ldr	x1, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.globl	__ZN4core3fmt9Arguments3new17h033fb29829fb7498E
	.p2align	2
__ZN4core3fmt9Arguments3new17h033fb29829fb7498E:
	.cfi_startproc
	ret
	.cfi_endproc

	.globl	__ZN4core3fmt9Arguments3new17ha40b39cd3aadd79eE
	.p2align	2
__ZN4core3fmt9Arguments3new17ha40b39cd3aadd79eE:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3fmt9Formatter9write_fmt17h3de0793c2baaadf7E:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp]
	add	x0, sp, #8
	str	x1, [sp, #8]
	str	x2, [sp, #16]
	bl	__ZN4core3fmt9Arguments23as_statically_known_str17h0b8c2151ed2ccaafE
	stur	x0, [x29, #-16]
	stur	x1, [x29, #-8]
	ldur	x8, [x29, #-16]
	subs	x8, x8, #0
	cset	x8, ne
	tbz	w8, #0, LBB11_2
	b	LBB11_1
LBB11_1:
	ldr	x8, [sp]
	ldur	x1, [x29, #-16]
	ldur	x2, [x29, #-8]
	ldr	x0, [x8]
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #24]
	blr	x8
	sturb	w0, [x29, #-17]
	b	LBB11_3
LBB11_2:
	ldr	x8, [sp]
	ldr	x0, [x8]
	ldr	x1, [x8, #8]
	ldr	x2, [sp, #8]
	ldr	x3, [sp, #16]
	bl	__RNvNtCs6sq8b9ugfBC_4core3fmt5write
	sturb	w0, [x29, #-17]
	b	LBB11_3
LBB11_3:
	ldurb	w8, [x29, #-17]
	and	w0, w8, #0x1
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN4core3num7nonzero16NonZero$LT$T$GT$13new_unchecked17h07728404e167c490E
	.p2align	2
__ZN4core3num7nonzero16NonZero$LT$T$GT$13new_unchecked17h07728404e167c490E:
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
	stur	w0, [x29, #-4]
	ldur	w8, [x29, #-4]
	subs	w8, w8, #0
	cset	x8, ne
	tbz	w8, #0, LBB12_2
	b	LBB12_1
LBB12_1:
	ldur	w0, [x29, #-4]
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB12_2:
	.cfi_restore_state
	ldr	x0, [sp]
	bl	__ZN4core3num7nonzero16NonZero$LT$T$GT$13new_unchecked18precondition_check17ha51e9a6a2f6f5979E
	b	LBB12_3
LBB12_3:
	brk	#0x1
	.cfi_endproc

	.p2align	2
__ZN4core3num7nonzero16NonZero$LT$T$GT$13new_unchecked18precondition_check17ha51e9a6a2f6f5979E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x3, x0
	adrp	x0, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.1@PAGE
	add	x0, x0, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.1@PAGEOFF
	mov	w8, #419
	mov	x1, x8
	mov	w8, #0
	and	w2, w8, #0x1
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_nounwind_fmt
	.cfi_endproc

	.globl	__ZN4core3num7nonzero16NonZero$LT$T$GT$3get17ha9c96147a39e970bE
	.p2align	2
__ZN4core3num7nonzero16NonZero$LT$T$GT$3get17ha9c96147a39e970bE:
	.cfi_startproc
	ret
	.cfi_endproc

	.globl	__ZN4core3num7nonzero16NonZero$LT$T$GT$3new17h1500f894c633f6fcE
	.p2align	2
__ZN4core3num7nonzero16NonZero$LT$T$GT$3new17h1500f894c633f6fcE:
	.cfi_startproc
	ret
	.cfi_endproc

	.globl	__ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$10chunks_mut17h98000c88dceb2856E
	.p2align	2
__ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$10chunks_mut17h98000c88dceb2856E:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x8, [sp, #8]
	str	x0, [sp, #16]
	str	x1, [sp, #24]
	stur	x2, [x29, #-16]
	stur	x3, [x29, #-8]
	cbnz	x2, LBB16_2
	b	LBB16_1
LBB16_1:
	ldur	x2, [x29, #-8]
	adrp	x0, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.2@PAGE
	add	x0, x0, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.2@PAGEOFF
	mov	w8, #55
	mov	x1, x8
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking9panic_fmt
LBB16_2:
	ldur	x8, [x29, #-16]
	ldr	x9, [sp, #8]
	ldr	x10, [sp, #24]
	ldr	x11, [sp, #16]
	str	x11, [x9]
	str	x10, [x9, #8]
	str	x8, [x9, #16]
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4iter17h91194ac3e95e98d0E
	.p2align	2
__ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4iter17h91194ac3e95e98d0E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core5slice4iter13Iter$LT$T$GT$3new17hde3787bfa2eeffe2E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN4core5slice4iter13Iter$LT$T$GT$3new17hde3787bfa2eeffe2E
	.p2align	2
__ZN4core5slice4iter13Iter$LT$T$GT$3new17hde3787bfa2eeffe2E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	x0, [sp, #8]
	str	x1, [sp, #16]
	b	LBB18_1
LBB18_1:
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #16]
	add	x8, x8, x9
	str	x8, [sp, #24]
	b	LBB18_2
LBB18_2:
	ldr	x0, [sp, #8]
	ldr	x1, [sp, #24]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.globl	__ZN4core6option15Option$LT$T$GT$9unwrap_or17h7f813a81b0f5d3b0E
	.p2align	2
__ZN4core6option15Option$LT$T$GT$9unwrap_or17h7f813a81b0f5d3b0E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	x2, [sp]
	str	x0, [sp, #8]
	str	x1, [sp, #16]
	ldr	x8, [sp, #8]
	tbz	w8, #0, LBB19_2
	b	LBB19_1
LBB19_1:
	ldr	x8, [sp, #16]
	str	x8, [sp, #24]
	b	LBB19_3
LBB19_2:
	ldr	x8, [sp]
	str	x8, [sp, #24]
	b	LBB19_3
LBB19_3:
	ldr	x0, [sp, #24]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.globl	__ZN4core6result19Result$LT$T$C$E$GT$2ok17h6d75fe67fe2254ecE
	.p2align	2
__ZN4core6result19Result$LT$T$C$E$GT$2ok17h6d75fe67fe2254ecE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	x0, [sp, #8]
	ldr	x8, [x0]
	tbz	w8, #0, LBB20_2
	b	LBB20_1
LBB20_1:
	str	xzr, [sp, #16]
	b	LBB20_3
LBB20_2:
	ldr	x8, [sp, #8]
	ldr	x9, [x8, #8]
	ldr	x8, [x8, #16]
	str	x9, [sp, #16]
	str	x8, [sp, #24]
	b	LBB20_3
LBB20_3:
	ldr	x8, [sp, #8]
	ldr	x8, [x8]
	tbz	w8, #0, LBB20_5
	b	LBB20_4
LBB20_4:
	b	LBB20_5
LBB20_5:
	ldr	x0, [sp, #16]
	ldr	x1, [sp, #24]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.globl	__ZN60_$LT$getrandom..error..Error$u20$as$u20$core..fmt..Debug$GT$3fmt17h3b37fe14201a171aE
	.p2align	2
__ZN60_$LT$getrandom..error..Error$u20$as$u20$core..fmt..Debug$GT$3fmt17h3b37fe14201a171aE:
	.cfi_startproc
	sub	sp, sp, #304
	.cfi_def_cfa_offset 304
	stp	x28, x27, [sp, #272]
	stp	x29, x30, [sp, #288]
	add	x29, sp, #288
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w27, -24
	.cfi_offset w28, -32
	.cfi_remember_state
	str	x0, [sp, #32]
	mov	x0, x1
	add	x8, sp, #40
	adrp	x1, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.3@PAGE
	add	x1, x1, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.3@PAGEOFF
	mov	w9, #5
	mov	x2, x9
	bl	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter12debug_struct
	ldr	x0, [sp, #32]
	ldr	w0, [x0]
	bl	__ZN9getrandom5error5Error12raw_os_error17he3bf6924cf915f9dE
	str	w0, [sp, #60]
	str	w1, [sp, #64]
	ldr	w8, [sp, #60]
	mov	x0, x8
	mov	x8, x0
	tbz	w8, #0, LBB21_2
	b	LBB21_1
LBB21_1:
	ldr	w8, [sp, #64]
	add	x3, sp, #68
	str	w8, [sp, #68]
	add	x0, sp, #40
	adrp	x1, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.4@PAGE
	add	x1, x1, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.4@PAGEOFF
	mov	w8, #8
	mov	x2, x8
	adrp	x4, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.5@PAGE
	add	x4, x4, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.5@PAGEOFF
	bl	__RNvMs1_NtNtCs6sq8b9ugfBC_4core3fmt8buildersNtB5_11DebugStruct5field
	add	x0, sp, #72
	str	x0, [sp, #16]
	mov	w8, #128
	mov	x2, x8
	str	x2, [sp, #24]
	mov	w1, #0
	bl	_memset
	ldr	x1, [sp, #16]
	ldr	x2, [sp, #24]
	ldr	w0, [sp, #68]
	bl	__ZN9getrandom5error6os_err17h62fc9d38c8a77f88E
	stur	x0, [x29, #-88]
	stur	x1, [x29, #-80]
	ldur	x8, [x29, #-88]
	subs	x8, x8, #0
	cset	x8, ne
	tbnz	w8, #0, LBB21_3
	b	LBB21_4
LBB21_2:
	ldr	x8, [sp, #32]
	ldr	w0, [x8]
	bl	__ZN9getrandom5error13internal_desc17hdc6ede7f4eac8eecE
	stur	x0, [x29, #-56]
	stur	x1, [x29, #-48]
	ldur	x8, [x29, #-56]
	subs	x8, x8, #0
	cset	x8, ne
	tbnz	w8, #0, LBB21_5
	b	LBB21_6
LBB21_3:
	ldur	x9, [x29, #-88]
	ldur	x8, [x29, #-80]
	sub	x3, x29, #72
	stur	x9, [x29, #-72]
	stur	x8, [x29, #-64]
	add	x0, sp, #40
	adrp	x1, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.6@PAGE
	add	x1, x1, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.6@PAGEOFF
	mov	w8, #11
	mov	x2, x8
	adrp	x4, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.7@PAGE
	add	x4, x4, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.7@PAGEOFF
	bl	__RNvMs1_NtNtCs6sq8b9ugfBC_4core3fmt8buildersNtB5_11DebugStruct5field
	b	LBB21_4
LBB21_4:
	add	x0, sp, #40
	bl	__RNvMs1_NtNtCs6sq8b9ugfBC_4core3fmt8buildersNtB5_11DebugStruct6finish
	.cfi_def_cfa wsp, 304
	ldp	x29, x30, [sp, #288]
	ldp	x28, x27, [sp, #272]
	add	sp, sp, #304
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w27
	.cfi_restore w28
	ret
LBB21_5:
	.cfi_restore_state
	ldr	x8, [sp, #32]
	ldur	x10, [x29, #-56]
	ldur	x9, [x29, #-48]
	sub	x11, x29, #40
	str	x11, [sp]
	stur	x10, [x29, #-40]
	stur	x9, [x29, #-32]
	ldr	w0, [x8]
	bl	__ZN4core3num7nonzero16NonZero$LT$T$GT$3get17ha9c96147a39e970bE
	sub	x3, x29, #24
	stur	w0, [x29, #-24]
	add	x0, sp, #40
	str	x0, [sp, #8]
	adrp	x1, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.8@PAGE
	add	x1, x1, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.8@PAGEOFF
	mov	w8, #13
	mov	x2, x8
	adrp	x4, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.9@PAGE
	add	x4, x4, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.9@PAGEOFF
	bl	__RNvMs1_NtNtCs6sq8b9ugfBC_4core3fmt8buildersNtB5_11DebugStruct5field
	ldr	x3, [sp]
	ldr	x0, [sp, #8]
	adrp	x1, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.6@PAGE
	add	x1, x1, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.6@PAGEOFF
	mov	w8, #11
	mov	x2, x8
	adrp	x4, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.7@PAGE
	add	x4, x4, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.7@PAGEOFF
	bl	__RNvMs1_NtNtCs6sq8b9ugfBC_4core3fmt8buildersNtB5_11DebugStruct5field
	b	LBB21_4
LBB21_6:
	ldr	x8, [sp, #32]
	ldr	w0, [x8]
	bl	__ZN4core3num7nonzero16NonZero$LT$T$GT$3get17ha9c96147a39e970bE
	sub	x3, x29, #20
	stur	w0, [x29, #-20]
	add	x0, sp, #40
	adrp	x1, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.10@PAGE
	add	x1, x1, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.10@PAGEOFF
	mov	w8, #12
	mov	x2, x8
	adrp	x4, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.9@PAGE
	add	x4, x4, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.9@PAGEOFF
	bl	__RNvMs1_NtNtCs6sq8b9ugfBC_4core3fmt8buildersNtB5_11DebugStruct5field
	b	LBB21_4
	.cfi_endproc

	.globl	__ZN62_$LT$getrandom..error..Error$u20$as$u20$core..fmt..Display$GT$3fmt17h1c04521a3082ecc1E
	.p2align	2
__ZN62_$LT$getrandom..error..Error$u20$as$u20$core..fmt..Display$GT$3fmt17h1c04521a3082ecc1E:
	.cfi_startproc
	sub	sp, sp, #352
	.cfi_def_cfa_offset 352
	stp	x28, x27, [sp, #320]
	stp	x29, x30, [sp, #336]
	add	x29, sp, #336
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w27, -24
	.cfi_offset w28, -32
	.cfi_remember_state
	sub	x8, x29, #128
	str	x8, [sp, #40]
	str	x0, [sp, #48]
	str	x1, [sp, #56]
	ldr	w0, [x0]
	bl	__ZN9getrandom5error5Error12raw_os_error17he3bf6924cf915f9dE
	str	w0, [sp, #68]
	str	w1, [sp, #72]
	ldr	w8, [sp, #68]
	mov	x0, x8
	mov	x8, x0
	tbz	w8, #0, LBB22_2
	b	LBB22_1
LBB22_1:
	ldr	w8, [sp, #72]
	str	w8, [sp, #76]
	add	x0, sp, #80
	str	x0, [sp, #24]
	mov	w8, #128
	mov	x2, x8
	str	x2, [sp, #32]
	mov	w1, #0
	bl	_memset
	ldr	x1, [sp, #24]
	ldr	x2, [sp, #32]
	ldr	w0, [sp, #76]
	bl	__ZN9getrandom5error6os_err17h62fc9d38c8a77f88E
	ldr	x8, [sp, #40]
	str	x0, [x8]
	str	x1, [x8, #8]
	ldr	x8, [x8]
	subs	x8, x8, #0
	cset	x8, ne
	tbnz	w8, #0, LBB22_3
	b	LBB22_4
LBB22_2:
	ldr	x8, [sp, #48]
	ldr	w0, [x8]
	bl	__ZN9getrandom5error13internal_desc17hdc6ede7f4eac8eecE
	ldr	x8, [sp, #40]
	str	x0, [x8, #56]
	str	x1, [x8, #64]
	ldr	x8, [x8, #56]
	subs	x8, x8, #0
	cset	x8, ne
	tbnz	w8, #0, LBB22_6
	b	LBB22_7
LBB22_3:
	ldr	x2, [sp, #56]
	ldr	x8, [sp, #40]
	ldr	x0, [x8]
	ldr	x1, [x8, #8]
	bl	__RNvXsi_NtCs6sq8b9ugfBC_4core3fmteNtB5_7Display3fmt
	strb	w0, [sp, #67]
	b	LBB22_5
LBB22_4:
	sub	x8, x29, #88
	add	x0, sp, #76
	bl	__ZN4core3fmt2rt8Argument11new_display17h05ed16bf00e5446eE
	ldr	x8, [sp, #40]
	ldur	q0, [x8, #40]
	sub	x1, x29, #112
	str	q0, [x8, #16]
	adrp	x0, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.11@PAGE
	add	x0, x0, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.11@PAGEOFF
	bl	__ZN4core3fmt9Arguments3new17ha40b39cd3aadd79eE
	mov	x2, x0
	ldr	x0, [sp, #56]
	str	x2, [sp, #16]
	mov	x2, x1
	ldr	x1, [sp, #16]
	bl	__ZN4core3fmt9Formatter9write_fmt17h3de0793c2baaadf7E
	strb	w0, [sp, #67]
	b	LBB22_5
LBB22_5:
	ldrb	w8, [sp, #67]
	and	w0, w8, #0x1
	.cfi_def_cfa wsp, 352
	ldp	x29, x30, [sp, #336]
	ldp	x28, x27, [sp, #320]
	add	sp, sp, #352
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w27
	.cfi_restore w28
	ret
LBB22_6:
	.cfi_restore_state
	ldr	x0, [sp, #56]
	ldr	x8, [sp, #40]
	ldr	x1, [x8, #56]
	ldr	x2, [x8, #64]
	bl	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter9write_str
	strb	w0, [sp, #67]
	b	LBB22_5
LBB22_7:
	ldr	x8, [sp, #48]
	ldr	w0, [x8]
	bl	__ZN4core3num7nonzero16NonZero$LT$T$GT$3get17ha9c96147a39e970bE
	ldr	x9, [sp, #40]
	mov	x8, x0
	sub	x0, x29, #52
	str	w8, [x9, #76]
	sub	x8, x29, #32
	bl	__ZN4core3fmt2rt8Argument11new_display17h6f42cbf0ac4457c6E
	ldr	x8, [sp, #40]
	ldr	q0, [x8, #96]
	sub	x1, x29, #48
	str	q0, [x8, #80]
	adrp	x0, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.12@PAGE
	add	x0, x0, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.12@PAGEOFF
	bl	__ZN4core3fmt9Arguments3new17h033fb29829fb7498E
	mov	x2, x0
	ldr	x0, [sp, #56]
	str	x2, [sp, #8]
	mov	x2, x1
	ldr	x1, [sp, #8]
	bl	__ZN4core3fmt9Formatter9write_fmt17h3de0793c2baaadf7E
	strb	w0, [sp, #67]
	b	LBB22_5
	.cfi_endproc

	.globl	__ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h76ed2adddcb1a124E
	.p2align	2
__ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h76ed2adddcb1a124E:
	.cfi_startproc
	mov	x9, x8
	ldr	q0, [x0]
	str	q0, [x9]
	ldr	x8, [x0, #16]
	str	x8, [x9, #16]
	ret
	.cfi_endproc

	.globl	__ZN91_$LT$core..slice..iter..Iter$LT$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$8position17ha4d2f7bcdca4a23eE
	.p2align	2
__ZN91_$LT$core..slice..iter..Iter$LT$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$8position17ha4d2f7bcdca4a23eE:
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception0
	sub	sp, sp, #128
	.cfi_def_cfa_offset 128
	stp	x29, x30, [sp, #112]
	add	x29, sp, #112
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #40]
	b	LBB24_1
LBB24_1:
	ldr	x8, [sp, #40]
	ldr	x9, [x8, #8]
	str	x9, [sp, #24]
	ldr	x8, [x8]
	str	x8, [sp, #32]
	b	LBB24_2
LBB24_2:
	b	LBB24_3
LBB24_3:
	b	LBB24_4
LBB24_4:
	ldr	x8, [sp, #24]
	ldr	x9, [sp, #32]
	subs	x8, x8, x9
	mov	w9, #1
	udiv	x8, x8, x9
	stur	x8, [x29, #-40]
	b	LBB24_7
LBB24_5:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB24_6:
Ltmp9:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB24_5
LBB24_7:
	stur	xzr, [x29, #-32]
	b	LBB24_8
LBB24_8:
	ldr	x8, [sp, #40]
	ldr	x9, [x8]
	str	x9, [sp, #8]
	ldr	x8, [x8, #8]
	str	x8, [sp, #16]
	b	LBB24_9
LBB24_9:
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #16]
	subs	x8, x8, x9
	b.eq	LBB24_11
	b	LBB24_10
LBB24_10:
	ldr	x9, [sp, #40]
	ldr	x8, [sp, #8]
	add	x8, x8, #1
	str	x8, [x9]
	b	LBB24_12
LBB24_11:
	b	LBB24_18
LBB24_12:
	ldr	x8, [sp, #8]
	stur	x8, [x29, #-24]
	ldur	x1, [x29, #-24]
Ltmp7:
	add	x0, sp, #55
	bl	__ZN9getrandom5error6os_err28_$u7b$$u7b$closure$u7d$$u7d$17he60d2f29def6b315E
	str	w0, [sp, #4]
Ltmp8:
	b	LBB24_13
LBB24_13:
	ldr	w8, [sp, #4]
	tbnz	w8, #0, LBB24_15
	b	LBB24_14
LBB24_14:
	ldur	x8, [x29, #-32]
	add	x8, x8, #1
	stur	x8, [x29, #-32]
	b	LBB24_8
LBB24_15:
	b	LBB24_16
LBB24_16:
	ldur	x8, [x29, #-32]
	str	x8, [sp, #64]
	mov	w8, #1
	str	x8, [sp, #56]
	b	LBB24_17
LBB24_17:
	ldr	x0, [sp, #56]
	ldr	x1, [sp, #64]
	.cfi_def_cfa wsp, 128
	ldp	x29, x30, [sp, #112]
	add	sp, sp, #128
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB24_18:
	.cfi_restore_state
	adrp	x9, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.0@PAGE
	adrp	x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.0@PAGE
	add	x8, x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.0@PAGEOFF
	ldr	x9, [x9, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.0@PAGEOFF]
	ldr	x8, [x8, #8]
	str	x9, [sp, #56]
	str	x8, [sp, #64]
	b	LBB24_17
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table24:
Lexception0:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end0-Lcst_begin0
Lcst_begin0:
	.uleb128 Lfunc_begin0-Lfunc_begin0
	.uleb128 Ltmp7-Lfunc_begin0
	.byte	0
	.byte	0
	.uleb128 Ltmp7-Lfunc_begin0
	.uleb128 Ltmp8-Ltmp7
	.uleb128 Ltmp9-Lfunc_begin0
	.byte	0
Lcst_end0:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN96_$LT$core..slice..iter..ChunksMut$LT$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17he9845b059453bf26E
	.p2align	2
__ZN96_$LT$core..slice..iter..ChunksMut$LT$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17he9845b059453bf26E:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #24]
	ldr	x8, [x0, #8]
	cbnz	x8, LBB25_2
	b	LBB25_1
LBB25_1:
	adrp	x9, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.0@PAGE
	adrp	x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.0@PAGE
	add	x8, x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.0@PAGEOFF
	ldr	x9, [x9, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.0@PAGEOFF]
	ldr	x8, [x8, #8]
	stur	x9, [x29, #-16]
	stur	x8, [x29, #-8]
	b	LBB25_3
LBB25_2:
	ldr	x8, [sp, #24]
	ldr	x0, [x8, #8]
	ldr	x1, [x8, #16]
	bl	__ZN4core3cmp3Ord3min17h985483d87f7f461bE
	ldr	x8, [sp, #24]
	str	x0, [sp]
	ldr	x9, [x8]
	str	x9, [sp, #8]
	ldr	x8, [x8, #8]
	str	x8, [sp, #16]
	subs	x8, x0, x8
	b.ls	LBB25_5
	b	LBB25_4
LBB25_3:
	ldur	x0, [x29, #-16]
	ldur	x1, [x29, #-8]
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB25_4:
	.cfi_restore_state
	adrp	x0, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.16@PAGE
	add	x0, x0, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.16@PAGEOFF
	mov	w8, #35
	mov	x1, x8
	adrp	x2, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.18@PAGE
	add	x2, x2, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.18@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking5panic
LBB25_5:
	ldr	x8, [sp]
	ldr	x9, [sp, #8]
	ldr	x11, [sp, #24]
	ldr	x10, [sp, #16]
	add	x12, x9, x8
	subs	x10, x10, x8
	str	x12, [x11]
	str	x10, [x11, #8]
	stur	x9, [x29, #-16]
	stur	x8, [x29, #-8]
	b	LBB25_3
	.cfi_endproc

	.globl	__ZN9getrandom3imp15getrandom_inner17hb6effd3c82ab532aE
	.p2align	2
__ZN9getrandom3imp15getrandom_inner17hb6effd3c82ab532aE:
	.cfi_startproc
	sub	sp, sp, #128
	.cfi_def_cfa_offset 128
	stp	x29, x30, [sp, #112]
	add	x29, sp, #112
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	add	x8, sp, #40
	str	x8, [sp]
	mov	w9, #256
	mov	x2, x9
	adrp	x3, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.20@PAGE
	add	x3, x3, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.20@PAGEOFF
	bl	__ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$10chunks_mut17h98000c88dceb2856E
	ldr	x0, [sp]
	add	x8, sp, #16
	bl	__ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h76ed2adddcb1a124E
	ldr	q0, [sp, #16]
	stur	q0, [x29, #-48]
	ldr	x8, [sp, #32]
	stur	x8, [x29, #-32]
	b	LBB26_1
LBB26_1:
	sub	x0, x29, #48
	bl	__ZN96_$LT$core..slice..iter..ChunksMut$LT$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17he9845b059453bf26E
	stur	x0, [x29, #-16]
	stur	x1, [x29, #-8]
	ldur	x8, [x29, #-16]
	subs	x8, x8, #0
	cset	x8, ne
	tbz	w8, #0, LBB26_3
	b	LBB26_2
LBB26_2:
	ldur	x0, [x29, #-16]
	ldur	x1, [x29, #-8]
	bl	_getentropy
	cbnz	w0, LBB26_5
	b	LBB26_1
LBB26_3:
	str	wzr, [sp, #12]
	b	LBB26_4
LBB26_4:
	ldr	w0, [sp, #12]
	.cfi_def_cfa wsp, 128
	ldp	x29, x30, [sp, #112]
	add	sp, sp, #128
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB26_5:
	.cfi_restore_state
	bl	__ZN9getrandom9util_libc13last_os_error17h02d8e9e25762a6c9E
	str	w0, [sp, #12]
	b	LBB26_4
	.cfi_endproc

	.p2align	2
__ZN9getrandom5error13internal_desc17hdc6ede7f4eac8eecE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	w0, [sp, #12]
	mov	w8, #-2147483648
	subs	w8, w8, w0
	b.eq	LBB27_2
	b	LBB27_1
LBB27_1:
	ldr	w9, [sp, #12]
	mov	w8, #-2147483647
	subs	w8, w8, w9
	b.eq	LBB27_4
	b	LBB27_3
LBB27_2:
	adrp	x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.33@PAGE
	add	x8, x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.33@PAGEOFF
	str	x8, [sp, #16]
	mov	w8, #39
	str	x8, [sp, #24]
	b	LBB27_27
LBB27_3:
	ldr	w9, [sp, #12]
	mov	w8, #2
	movk	w8, #32768, lsl #16
	subs	w8, w8, w9
	b.eq	LBB27_6
	b	LBB27_5
LBB27_4:
	adrp	x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.32@PAGE
	add	x8, x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.32@PAGEOFF
	str	x8, [sp, #16]
	mov	w8, #38
	str	x8, [sp, #24]
	b	LBB27_27
LBB27_5:
	ldr	w9, [sp, #12]
	mov	w8, #-2147483645
	subs	w8, w8, w9
	b.eq	LBB27_8
	b	LBB27_7
LBB27_6:
	adrp	x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.31@PAGE
	add	x8, x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.31@PAGEOFF
	str	x8, [sp, #16]
	mov	w8, #20
	str	x8, [sp, #24]
	b	LBB27_27
LBB27_7:
	ldr	w9, [sp, #12]
	mov	w8, #4
	movk	w8, #32768, lsl #16
	subs	w8, w8, w9
	b.eq	LBB27_10
	b	LBB27_9
LBB27_8:
	adrp	x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.30@PAGE
	add	x8, x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.30@PAGEOFF
	str	x8, [sp, #16]
	mov	w8, #50
	str	x8, [sp, #24]
	b	LBB27_27
LBB27_9:
	ldr	w9, [sp, #12]
	mov	w8, #5
	movk	w8, #32768, lsl #16
	subs	w8, w8, w9
	b.eq	LBB27_12
	b	LBB27_11
LBB27_10:
	adrp	x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.29@PAGE
	add	x8, x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.29@PAGEOFF
	str	x8, [sp, #16]
	mov	w8, #45
	str	x8, [sp, #24]
	b	LBB27_27
LBB27_11:
	ldr	w9, [sp, #12]
	mov	w8, #6
	movk	w8, #32768, lsl #16
	subs	w8, w8, w9
	b.eq	LBB27_14
	b	LBB27_13
LBB27_12:
	adrp	x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.28@PAGE
	add	x8, x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.28@PAGEOFF
	str	x8, [sp, #16]
	mov	w8, #47
	str	x8, [sp, #24]
	b	LBB27_27
LBB27_13:
	ldr	w9, [sp, #12]
	mov	w8, #-2147483641
	subs	w8, w8, w9
	b.eq	LBB27_16
	b	LBB27_15
LBB27_14:
	adrp	x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.27@PAGE
	add	x8, x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.27@PAGEOFF
	str	x8, [sp, #16]
	mov	w8, #33
	str	x8, [sp, #24]
	b	LBB27_27
LBB27_15:
	ldr	w9, [sp, #12]
	mov	w8, #8
	movk	w8, #32768, lsl #16
	subs	w8, w8, w9
	b.eq	LBB27_18
	b	LBB27_17
LBB27_16:
	adrp	x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.26@PAGE
	add	x8, x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.26@PAGEOFF
	str	x8, [sp, #16]
	mov	w8, #29
	str	x8, [sp, #24]
	b	LBB27_27
LBB27_17:
	ldr	w9, [sp, #12]
	mov	w8, #11
	movk	w8, #32768, lsl #16
	subs	w8, w8, w9
	b.eq	LBB27_20
	b	LBB27_19
LBB27_18:
	adrp	x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.25@PAGE
	add	x8, x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.25@PAGEOFF
	str	x8, [sp, #16]
	mov	w8, #45
	str	x8, [sp, #24]
	b	LBB27_27
LBB27_19:
	ldr	w9, [sp, #12]
	mov	w8, #12
	movk	w8, #32768, lsl #16
	subs	w8, w8, w9
	b.eq	LBB27_22
	b	LBB27_21
LBB27_20:
	adrp	x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.24@PAGE
	add	x8, x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.24@PAGEOFF
	str	x8, [sp, #16]
	mov	w8, #49
	str	x8, [sp, #24]
	b	LBB27_27
LBB27_21:
	ldr	w9, [sp, #12]
	mov	w8, #13
	movk	w8, #32768, lsl #16
	subs	w8, w8, w9
	b.eq	LBB27_24
	b	LBB27_23
LBB27_22:
	adrp	x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.23@PAGE
	add	x8, x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.23@PAGEOFF
	str	x8, [sp, #16]
	mov	w8, #45
	str	x8, [sp, #24]
	b	LBB27_27
LBB27_23:
	ldr	w9, [sp, #12]
	mov	w8, #14
	movk	w8, #32768, lsl #16
	subs	w8, w8, w9
	b.eq	LBB27_26
	b	LBB27_25
LBB27_24:
	adrp	x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.22@PAGE
	add	x8, x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.22@PAGEOFF
	str	x8, [sp, #16]
	mov	w8, #48
	str	x8, [sp, #24]
	b	LBB27_27
LBB27_25:
	str	xzr, [sp, #16]
	b	LBB27_27
LBB27_26:
	adrp	x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.21@PAGE
	add	x8, x8, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.21@PAGEOFF
	str	x8, [sp, #16]
	mov	w8, #101
	str	x8, [sp, #24]
	b	LBB27_27
LBB27_27:
	ldr	x0, [sp, #16]
	ldr	x1, [sp, #24]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.globl	__ZN9getrandom5error14internal_error17hce22f033b90b6200E
	.p2align	2
__ZN9getrandom5error14internal_error17hce22f033b90b6200E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	w8, #-2147483648
	add	w0, w8, w0, uxth
	adrp	x1, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.35@PAGE
	add	x1, x1, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.35@PAGEOFF
	bl	__ZN4core3num7nonzero16NonZero$LT$T$GT$13new_unchecked17h07728404e167c490E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN9getrandom5error5Error12raw_os_error17he3bf6924cf915f9dE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	w0, [sp, #4]
	bl	__ZN4core3num7nonzero16NonZero$LT$T$GT$3get17ha9c96147a39e970bE
	mov	w8, #-2147483648
	subs	w8, w0, w8
	b.lo	LBB29_2
	b	LBB29_1
LBB29_1:
	str	wzr, [sp, #8]
	b	LBB29_3
LBB29_2:
	ldr	w0, [sp, #4]
	bl	__ZN4core3num7nonzero16NonZero$LT$T$GT$3get17ha9c96147a39e970bE
	str	w0, [sp, #12]
	mov	w8, #1
	str	w8, [sp, #8]
	b	LBB29_3
LBB29_3:
	ldr	w0, [sp, #8]
	ldr	w1, [sp, #12]
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN9getrandom5error6os_err17h62fc9d38c8a77f88E:
	.cfi_startproc
	sub	sp, sp, #128
	.cfi_def_cfa_offset 128
	stp	x29, x30, [sp, #112]
	add	x29, sp, #112
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x1, [sp, #24]
	str	x2, [sp, #32]
	bl	_strerror_r
	cbnz	w0, LBB30_4
	b	LBB30_1
LBB30_1:
	ldr	x1, [sp, #32]
	ldr	x0, [sp, #24]
	bl	__ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4iter17h91194ac3e95e98d0E
	mov	x8, x0
	add	x0, sp, #56
	str	x8, [sp, #56]
	str	x1, [sp, #64]
	bl	__ZN91_$LT$core..slice..iter..Iter$LT$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$8position17ha4d2f7bcdca4a23eE
	ldr	x2, [sp, #32]
	bl	__ZN4core6option15Option$LT$T$GT$9unwrap_or17h7f813a81b0f5d3b0E
	ldr	x8, [sp, #32]
	str	x0, [sp, #8]
	stur	x0, [x29, #-8]
	mov	w9, #1
	stur	x9, [x29, #-16]
	ldur	x9, [x29, #-8]
	str	x9, [sp, #16]
	subs	x8, x0, x8
	b.ls	LBB30_3
	b	LBB30_2
LBB30_2:
	ldr	x2, [sp, #32]
	ldr	x1, [sp, #8]
	mov	x0, #0
	adrp	x3, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.36@PAGE
	add	x3, x3, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.36@PAGEOFF
	bl	__RNvNtNtCs6sq8b9ugfBC_4core5slice5index16slice_index_fail
LBB30_3:
	ldr	x1, [sp, #16]
	ldr	x0, [sp, #24]
	sub	x8, x29, #40
	str	x8, [sp]
	bl	__RNvNtNtCs6sq8b9ugfBC_4core3str8converts9from_utf8
	ldr	x0, [sp]
	bl	__ZN4core6result19Result$LT$T$C$E$GT$2ok17h6d75fe67fe2254ecE
	str	x0, [sp, #40]
	str	x1, [sp, #48]
	b	LBB30_5
LBB30_4:
	str	xzr, [sp, #40]
	b	LBB30_5
LBB30_5:
	ldr	x0, [sp, #40]
	ldr	x1, [sp, #48]
	.cfi_def_cfa wsp, 128
	ldp	x29, x30, [sp, #112]
	add	sp, sp, #128
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN9getrandom5error6os_err28_$u7b$$u7b$closure$u7d$$u7d$17he60d2f29def6b315E:
	.cfi_startproc
	ldrb	w8, [x1]
	subs	w8, w8, #0
	cset	w0, eq
	ret
	.cfi_endproc

	.p2align	2
__ZN9getrandom9util_libc13last_os_error17h02d8e9e25762a6c9E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN9getrandom9util_libc9get_errno17hc16983288b501cc8E
	str	w0, [sp, #4]
	subs	w8, w0, #0
	b.gt	LBB32_2
	b	LBB32_1
LBB32_1:
	mov	w8, #-2147483647
	str	w8, [sp, #8]
	b	LBB32_5
LBB32_2:
	ldr	w0, [sp, #4]
	bl	__ZN4core3num7nonzero16NonZero$LT$T$GT$3new17h1500f894c633f6fcE
	stur	w0, [x29, #-4]
	ldur	w8, [x29, #-4]
	subs	w8, w8, #0
	cset	x8, ne
	tbnz	w8, #0, LBB32_4
	b	LBB32_3
LBB32_3:
	adrp	x0, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.38@PAGE
	add	x0, x0, l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.38@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core6option13unwrap_failed
LBB32_4:
	ldur	w0, [x29, #-4]
	bl	__ZN109_$LT$getrandom..error..Error$u20$as$u20$core..convert..From$LT$core..num..nonzero..NonZero$LT$u32$GT$$GT$$GT$4from17h5d6c8df9beda9d18E
	str	w0, [sp, #8]
	b	LBB32_5
LBB32_5:
	ldr	w0, [sp, #8]
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN9getrandom9util_libc9get_errno17hc16983288b501cc8E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	___error
	ldr	w0, [x0]
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.section	__TEXT,__literal16,16byte_literals
	.p2align	3, 0x0
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.0:
	.space	8
	.space	8

	.section	__TEXT,__const
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.1:
	.ascii	"unsafe precondition(s) violated: NonZero::new_unchecked requires the argument to be non-zero\n\nThis indicates a bug in the program. This Undefined Behavior check is optional, and cannot be relied on for safety."

l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.2:
	.ascii	"chunk size must be non-zero"

l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.3:
	.ascii	"Error"

	.section	__TEXT,__literal8,8byte_literals
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.4:
	.ascii	"os_error"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.5:
	.asciz	"\000\000\000\000\000\000\000\000\004\000\000\000\000\000\000\000\004\000\000\000\000\000\000"
	.quad	__ZN4core3fmt3num50_$LT$impl$u20$core..fmt..Debug$u20$for$u20$i32$GT$3fmt17he5443c78a2fb1dd0E

	.section	__TEXT,__const
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.6:
	.ascii	"description"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.7:
	.asciz	"\000\000\000\000\000\000\000\000\020\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	__ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17hcd30fb13fc3c8067E

	.section	__TEXT,__const
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.8:
	.ascii	"internal_code"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.9:
	.asciz	"\000\000\000\000\000\000\000\000\004\000\000\000\000\000\000\000\004\000\000\000\000\000\000"
	.quad	__ZN4core3fmt3num50_$LT$impl$u20$core..fmt..Debug$u20$for$u20$u32$GT$3fmt17h1e9149f777ef7437E

	.section	__TEXT,__const
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.10:
	.ascii	"unknown_code"

	.section	__TEXT,__cstring,cstring_literals
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.11:
	.asciz	"\nOS Error: \300"

l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.12:
	.asciz	"\017Unknown Error: \300"

	.section	__TEXT,__const
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.13:
	.ascii	"assertion failed: 0 < pointee_size && pointee_size <= isize::MAX as usize"

	.section	__TEXT,__cstring,cstring_literals
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.14:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/non_null.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.15:
	.quad	l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.14
	.asciz	"v\000\000\000\000\000\000\000\271\003\000\000 \000\000"

	.section	__TEXT,__const
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.16:
	.ascii	"assertion failed: mid <= self.len()"

	.section	__TEXT,__cstring,cstring_literals
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.17:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/iter.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.18:
	.quad	l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.17
	.asciz	"t\000\000\000\000\000\000\000\226\006\000\0000\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.19:
	.asciz	"/Users/kuangtalin/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/getrandom-0.2.17/src/getentropy.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.20:
	.quad	l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.19
	.asciz	"i\000\000\000\000\000\000\000\016\000\000\000\027\000\000"

	.section	__TEXT,__const
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.21:
	.ascii	"Node.js ES modules are not directly supported, see https://docs.rs/getrandom#nodejs-es-module-support"

l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.22:
	.ascii	"Calling Node.js API crypto.randomFillSync failed"

l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.23:
	.ascii	"Node.js crypto CommonJS module is unavailable"

l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.24:
	.ascii	"randSecure: VxWorks RNG module is not initialized"

l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.25:
	.ascii	"Calling Web API crypto.getRandomValues failed"

l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.26:
	.ascii	"Web Crypto API is unavailable"

l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.27:
	.ascii	"RDRAND: instruction not supported"

l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.28:
	.ascii	"RDRAND: failed multiple times: CPU issue likely"

l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.29:
	.ascii	"RtlGenRandom: Windows system function failure"

l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.30:
	.ascii	"SecRandomCopyBytes: iOS Security framework failure"

l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.31:
	.ascii	"unexpected situation"

l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.32:
	.ascii	"errno: did not return a positive value"

l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.33:
	.ascii	"getrandom: this target is not supported"

	.section	__TEXT,__cstring,cstring_literals
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.34:
	.asciz	"/Users/kuangtalin/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/getrandom-0.2.17/src/error.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.35:
	.quad	l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.34
	.asciz	"d\000\000\000\000\000\000\000\027\000\000\000\024\000\000"

	.p2align	3, 0x0
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.36:
	.quad	l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.34
	.asciz	"d\000\000\000\000\000\000\000n\000\000\000&\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.37:
	.asciz	"/Users/kuangtalin/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/getrandom-0.2.17/src/util_libc.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.38:
	.quad	l_anon.f9dad3cc9f9135a00d83f7f1aa4d768c.37
	.asciz	"h\000\000\000\000\000\000\000.\000\000\0003\000\000"

.subsections_via_symbols
