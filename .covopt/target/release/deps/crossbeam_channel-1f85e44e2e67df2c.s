	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__RNvXNvNtNtCsaLOjE9VYtxK_3std3sys12thread_local20abort_on_dtor_unwindNtB2_15DtorUnwindGuardNtNtNtCs6sq8b9ugfBC_4core3ops4drop4Drop4drop:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	sub	x0, x29, #1
	bl	__ZN3std2io5Write9write_fmt17h28650d57bb0859feE
	bl	__ZN4core3ptr81drop_in_place$LT$core..result..Result$LT$$LP$$RP$$C$std..io..error..Error$GT$$GT$17h0c60abd63fbbdbcaE
	bl	__RNvNtCsaLOjE9VYtxK_3std7process5abort
	.cfi_endproc

	.globl	__ZN17crossbeam_channel5utils11sleep_until17ha7e3391d34a6dcc7E
	.p2align	2
__ZN17crossbeam_channel5utils11sleep_until17ha7e3391d34a6dcc7E:
	.cfi_startproc
	stp	x20, x19, [sp, #-32]!
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	w8, #51712
	movk	w8, #15258, lsl #16
	cmp	w1, w8
	b.ne	LBB1_2
LBB1_1:
	mov	w0, #1000
	mov	w1, #0
	bl	__RNvNtNtCsaLOjE9VYtxK_3std6thread9functions5sleep
	b	LBB1_1
LBB1_2:
	mov	x19, x1
	mov	x20, x0
	bl	__RNvMNtCsaLOjE9VYtxK_3std4timeNtB2_7Instant3now
	cmp	w1, w19
	cset	w8, hs
	cmp	x0, x20
	cset	w9, ge
	csel	w8, w8, w9, eq
	tbnz	w8, #0, LBB1_5
	mov	x2, x0
	mov	x3, x1
LBB1_4:
	mov	x0, x20
	mov	x1, x19
	bl	__RNvXs3_NtCsaLOjE9VYtxK_3std4timeNtB5_7InstantNtNtNtCs6sq8b9ugfBC_4core3ops5arith3Sub3sub
	bl	__RNvNtNtCsaLOjE9VYtxK_3std6thread9functions5sleep
	bl	__RNvMNtCsaLOjE9VYtxK_3std4timeNtB2_7Instant3now
	mov	x2, x0
	mov	x3, x1
	cmp	w1, w19
	cset	w8, hs
	cmp	x0, x20
	cset	w9, ge
	csel	w8, w8, w9, eq
	cmp	w8, #1
	b.ne	LBB1_4
LBB1_5:
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	ldp	x20, x19, [sp], #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	ret
	.cfi_endproc

	.globl	__ZN17crossbeam_channel6select10run_select17hea8c5bce3fe6efd5E
	.p2align	2
__ZN17crossbeam_channel6select10run_select17hea8c5bce3fe6efd5E:
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception0
	sub	sp, sp, #400
	.cfi_def_cfa_offset 400
	stp	x28, x27, [sp, #304]
	stp	x26, x25, [sp, #320]
	stp	x24, x23, [sp, #336]
	stp	x22, x21, [sp, #352]
	stp	x20, x19, [sp, #368]
	stp	x29, x30, [sp, #384]
	add	x29, sp, #384
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	.cfi_remember_state
	mov	x19, x8
	str	x2, [sp, #16]
	str	w3, [sp, #24]
	cbz	x1, LBB2_33
	mov	x20, x1
	mov	x27, x0
	cmp	x1, #1
	b.eq	LBB2_7
	tbnz	w4, #0, LBB2_7
Lloh0:
	adrp	x0, __ZN17crossbeam_channel5utils7shuffle3RNG29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17h453156475df5204bE@TLVPPAGE
Lloh1:
	ldr	x0, [x0, __ZN17crossbeam_channel5utils7shuffle3RNG29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17h453156475df5204bE@TLVPPAGEOFF]
	ldr	x8, [x0]
	blr	x8
	ldr	w9, [x0]
	add	x10, x27, #32
	mov	w11, #1
LBB2_4:
	add	x11, x11, #1
	eor	w8, w9, w9, lsl #13
	eor	w8, w8, w8, lsr #17
	eor	w9, w8, w8, lsl #5
	mul	x8, x11, x9
	lsr	x8, x8, #32
	cmp	x8, x20
	b.hs	LBB2_46
	add	x8, x27, x8, lsl #5
	ldp	q1, q0, [x10]
	ldp	q3, q2, [x8]
	stp	q3, q2, [x10], #32
	stp	q1, q0, [x8]
	cmp	x20, x11
	b.ne	LBB2_4
	str	w9, [x0]
LBB2_7:
	mov	w8, #51712
	movk	w8, #15258, lsl #16
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [sp, #32]
	str	w8, [sp, #80]
	str	w8, [sp, #96]
	str	xzr, [sp, #64]
	add	x25, x27, x20, lsl #5
	mov	x21, x27
LBB2_8:
	ldp	x0, x8, [x21]
	ldp	x22, x23, [x21, #16]
	ldr	x8, [x8, #24]
	add	x1, sp, #32
	blr	x8
	cbnz	w0, LBB2_40
	add	x21, x21, #32
	cmp	x21, x25
	b.ne	LBB2_8
	add	x21, sp, #160
Lloh2:
	adrp	x0, __ZN17crossbeam_channel7context7Context4with7CONTEXT29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17hee7fab048a4b49b6E@TLVPPAGE
Lloh3:
	ldr	x0, [x0, __ZN17crossbeam_channel7context7Context4with7CONTEXT29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17hee7fab048a4b49b6E@TLVPPAGEOFF]
	ldr	x8, [x0]
	blr	x8
	mov	x22, x0
	add	x9, sp, #16
	add	x8, sp, #32
	mov	w10, #51712
	movk	w10, #15258, lsl #16
	sub	w10, w10, #1
	str	w10, [sp, #12]
LBB2_11:
	add	x24, sp, #16
	stp	x9, x27, [sp, #160]
	stp	x20, x8, [sp, #176]
	add	x28, sp, #32
	ldrb	w8, [x22, #8]
	mov	x23, x22
	cmp	w8, #1
	b.ne	LBB2_28
LBB2_12:
	ldr	x26, [x23]
	str	xzr, [x23]
	cbz	x26, LBB2_30
	stur	x26, [x29, #-160]
	stlur	xzr, [x26, #32]
	stlur	xzr, [x26, #40]
	str	xzr, [sp, #160]
	stur	x24, [x29, #-128]
	ldur	q0, [x21, #8]
	sub	x9, x29, #128
	stur	q0, [x9, #8]
	ldur	x8, [x21, #24]
	stur	x8, [x9, #24]
Ltmp0:
	sub	x0, x29, #152
	sub	x1, x29, #128
	sub	x2, x29, #160
	bl	__ZN17crossbeam_channel6select10run_select28_$u7b$$u7b$closure$u7d$$u7d$17h8002dd84c8992a81E
Ltmp1:
	ldr	x8, [x23]
	stur	x8, [x29, #-128]
	str	x26, [x23]
	cbz	x8, LBB2_17
	mov	x9, #-1
	ldaddl	x9, x8, [x8]
	cmp	x8, #1
	b.ne	LBB2_17
	dmb	ishld
	sub	x0, x29, #128
	bl	__ZN5alloc4sync16Arc$LT$T$C$A$GT$9drop_slow17ha5b06fadef84789bE
LBB2_17:
	ldur	q0, [x29, #-152]
	str	q0, [sp, #192]
	ldur	x8, [x29, #-136]
	str	x8, [sp, #208]
LBB2_18:
	ldr	x8, [sp, #192]
	add	x9, sp, #192
	ldur	q0, [x9, #8]
	stur	q0, [x29, #-128]
	cmp	x8, #2
	b.eq	LBB2_29
	str	x8, [sp, #104]
	ldur	q0, [x29, #-128]
	add	x9, sp, #104
	stur	q0, [x9, #8]
	mov	x21, x27
	tbnz	w8, #0, LBB2_43
LBB2_20:
	ldp	x0, x8, [x21]
	ldp	x23, x26, [x21, #16]
	ldr	x8, [x8, #24]
	add	x1, sp, #32
	blr	x8
	tbnz	w0, #0, LBB2_41
	add	x21, x21, #32
	cmp	x21, x25
	b.ne	LBB2_20
	ldr	w21, [sp, #24]
	mov	w8, #13824
	movk	w8, #50277, lsl #16
	add	w8, w21, w8
	ldr	w9, [sp, #12]
	cmp	w21, w9
	mov	w9, #2
	csel	w8, w8, w9, hi
	cmp	w8, #1
	add	x9, sp, #16
	b.eq	LBB2_27
	cmp	w8, #2
	b.ne	LBB2_44
	ldr	x23, [sp, #16]
	bl	__RNvMNtCsaLOjE9VYtxK_3std4timeNtB2_7Instant3now
	cmp	x0, x23
	b.ne	LBB2_26
	cmp	w1, w21
	add	x9, sp, #16
	b.lo	LBB2_27
	b	LBB2_44
LBB2_26:
	add	x9, sp, #16
	b.ge	LBB2_44
LBB2_27:
	add	x21, sp, #160
	add	x8, sp, #32
	b	LBB2_11
LBB2_28:
	mov	x0, x22
	mov	x1, #0
	bl	__ZN3std3sys12thread_local6native4lazy20Storage$LT$T$C$D$GT$16get_or_init_slow17ha91bac1a167e65e7E
	mov	x23, x0
	cbnz	x0, LBB2_12
LBB2_29:
	add	x0, sp, #104
	add	x1, sp, #160
	bl	__ZN17crossbeam_channel7context7Context4with28_$u7b$$u7b$closure$u7d$$u7d$17h2e24cead4f2f7c4dE
	ldr	x8, [sp, #104]
	mov	x21, x27
	tbz	w8, #0, LBB2_20
	b	LBB2_43
LBB2_30:
	bl	__ZN17crossbeam_channel7context7Context3new17hb6c2eee222ec953aE
	mov	x23, x0
	stur	x0, [x29, #-152]
	str	xzr, [sp, #160]
	stp	x24, x27, [x29, #-128]
	stp	x20, x28, [x29, #-112]
Ltmp5:
	add	x0, sp, #192
	sub	x1, x29, #128
	sub	x2, x29, #152
	bl	__ZN17crossbeam_channel6select10run_select28_$u7b$$u7b$closure$u7d$$u7d$17h8002dd84c8992a81E
Ltmp6:
	mov	x8, #-1
	ldaddl	x8, x8, [x23]
	cmp	x8, #1
	b.ne	LBB2_18
	dmb	ishld
	sub	x0, x29, #152
	bl	__ZN5alloc4sync16Arc$LT$T$C$A$GT$9drop_slow17ha5b06fadef84789bE
	b	LBB2_18
LBB2_33:
	mov	x22, x3
	mov	w20, #51712
	movk	w20, #15258, lsl #16
	mov	w8, #13824
	movk	w8, #50277, lsl #16
	add	w8, w3, w8
	sub	w9, w20, #1
	mov	w10, #2
	cmp	w3, w9
	csel	w8, w8, w10, hi
	cbz	w8, LBB2_38
	cmp	w8, #2
	b.ne	LBB2_45
	mov	x23, x2
	bl	__RNvMNtCsaLOjE9VYtxK_3std4timeNtB2_7Instant3now
	cmp	w1, w22
	cset	w8, hs
	cmp	x0, x23
	cset	w9, ge
	csel	w8, w8, w9, eq
	tbnz	w8, #0, LBB2_38
	mov	x2, x0
	mov	x3, x1
LBB2_37:
	mov	x0, x23
	mov	x1, x22
	bl	__RNvXs3_NtCsaLOjE9VYtxK_3std4timeNtB5_7InstantNtNtNtCs6sq8b9ugfBC_4core3ops5arith3Sub3sub
	bl	__RNvNtNtCsaLOjE9VYtxK_3std6thread9functions5sleep
	bl	__RNvMNtCsaLOjE9VYtxK_3std4timeNtB2_7Instant3now
	mov	x2, x0
	mov	x3, x1
	cmp	w1, w22
	cset	w8, hs
	cmp	x0, x23
	cset	w9, ge
	csel	w8, w8, w9, eq
	cmp	w8, #1
	b.ne	LBB2_37
LBB2_38:
	add	w8, w20, #1
LBB2_39:
	str	w8, [x19, #64]
	b	LBB2_42
LBB2_40:
	ldp	q0, q1, [sp, #64]
	stp	q0, q1, [x19, #32]
	ldr	x8, [sp, #96]
	ldp	q1, q0, [sp, #32]
	stp	q1, q0, [x19]
	stp	x8, x22, [x19, #64]
	str	x23, [x19, #80]
	b	LBB2_42
LBB2_41:
	ldp	q0, q1, [sp, #64]
	stp	q0, q1, [x19, #32]
	ldr	x8, [sp, #96]
	ldp	q1, q0, [sp, #32]
	stp	q1, q0, [x19]
	stp	x8, x23, [x19, #64]
	str	x26, [x19, #80]
LBB2_42:
	.cfi_def_cfa wsp, 400
	ldp	x29, x30, [sp, #384]
	ldp	x20, x19, [sp, #368]
	ldp	x22, x21, [sp, #352]
	ldp	x24, x23, [sp, #336]
	ldp	x26, x25, [sp, #320]
	ldp	x28, x27, [sp, #304]
	add	sp, sp, #400
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	.cfi_restore w23
	.cfi_restore w24
	.cfi_restore w25
	.cfi_restore w26
	.cfi_restore w27
	.cfi_restore w28
	ret
LBB2_43:
	.cfi_restore_state
	ldp	x8, x9, [sp, #112]
	ldp	q0, q1, [sp, #64]
	stp	q0, q1, [x19, #32]
	ldr	x10, [sp, #96]
	ldp	q1, q0, [sp, #32]
	stp	q1, q0, [x19]
	stp	x10, x8, [x19, #64]
	str	x9, [x19, #80]
	b	LBB2_42
LBB2_44:
	mov	w8, #51712
	movk	w8, #15258, lsl #16
	add	w8, w8, #1
	b	LBB2_39
LBB2_45:
	mov	w1, #51712
	movk	w1, #15258, lsl #16
	bl	__ZN17crossbeam_channel5utils11sleep_until17ha7e3391d34a6dcc7E
Lloh4:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.3@PAGE
Lloh5:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.3@PAGEOFF
Lloh6:
	adrp	x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.5@PAGE
Lloh7:
	add	x2, x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.5@PAGEOFF
	mov	w1, #40
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking5panic
LBB2_46:
	str	w9, [x0]
Lloh8:
	adrp	x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.2@PAGE
Lloh9:
	add	x2, x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.2@PAGEOFF
	mov	x0, x8
	mov	x1, x20
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB2_47:
Ltmp7:
	mov	x19, x0
	mov	x8, #-1
	ldaddl	x8, x8, [x23]
	cmp	x8, #1
	b.ne	LBB2_51
	dmb	ishld
Ltmp8:
	sub	x0, x29, #152
	bl	__ZN5alloc4sync16Arc$LT$T$C$A$GT$9drop_slow17ha5b06fadef84789bE
Ltmp9:
	b	LBB2_51
LBB2_49:
Ltmp2:
	mov	x19, x0
	mov	x8, #-1
	ldaddl	x8, x8, [x26]
	cmp	x8, #1
	b.ne	LBB2_51
	dmb	ishld
Ltmp3:
	sub	x0, x29, #160
	bl	__ZN5alloc4sync16Arc$LT$T$C$A$GT$9drop_slow17ha5b06fadef84789bE
Ltmp4:
LBB2_51:
	mov	x0, x19
	bl	__Unwind_Resume
LBB2_52:
Ltmp10:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
	.loh AdrpLdr	Lloh0, Lloh1
	.loh AdrpLdr	Lloh2, Lloh3
	.loh AdrpAdd	Lloh6, Lloh7
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpAdd	Lloh8, Lloh9
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table2:
Lexception0:
	.byte	255
	.byte	155
	.uleb128 Lttbase0-Lttbaseref0
Lttbaseref0:
	.byte	1
	.uleb128 Lcst_end0-Lcst_begin0
Lcst_begin0:
	.uleb128 Lfunc_begin0-Lfunc_begin0
	.uleb128 Ltmp0-Lfunc_begin0
	.byte	0
	.byte	0
	.uleb128 Ltmp0-Lfunc_begin0
	.uleb128 Ltmp1-Ltmp0
	.uleb128 Ltmp2-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp1-Lfunc_begin0
	.uleb128 Ltmp5-Ltmp1
	.byte	0
	.byte	0
	.uleb128 Ltmp5-Lfunc_begin0
	.uleb128 Ltmp6-Ltmp5
	.uleb128 Ltmp7-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp6-Lfunc_begin0
	.uleb128 Ltmp8-Ltmp6
	.byte	0
	.byte	0
	.uleb128 Ltmp8-Lfunc_begin0
	.uleb128 Ltmp4-Ltmp8
	.uleb128 Ltmp10-Lfunc_begin0
	.byte	1
	.uleb128 Ltmp4-Lfunc_begin0
	.uleb128 Lfunc_end0-Ltmp4
	.byte	0
	.byte	0
Lcst_end0:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase0:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN17crossbeam_channel6select10run_select28_$u7b$$u7b$closure$u7d$$u7d$17h8002dd84c8992a81E:
	.cfi_startproc
	sub	sp, sp, #160
	.cfi_def_cfa_offset 160
	stp	x28, x27, [sp, #64]
	stp	x26, x25, [sp, #80]
	stp	x24, x23, [sp, #96]
	stp	x22, x21, [sp, #112]
	stp	x20, x19, [sp, #128]
	stp	x29, x30, [sp, #144]
	add	x29, sp, #144
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	.cfi_remember_state
	mov	w10, #51712
	movk	w10, #15258, lsl #16
	ldr	x12, [x1]
	ldr	w8, [x12, #8]
	mov	w9, #13824
	movk	w9, #50277, lsl #16
	add	w9, w8, w9
	sub	w10, w10, #1
	mov	w11, #2
	cmp	w8, w10
	csel	w26, w9, w11, hi
	cbnz	w26, LBB3_2
	mov	x8, #0
	ldr	x9, [x2]
	add	x9, x9, #32
	mov	w10, #1
	casal	x8, x10, [x9]
	cmp	x8, #0
	b.ne	LBB3_56
LBB3_2:
	stp	x12, x1, [sp, #8]
	ldp	x20, x8, [x1, #8]
	stp	x8, x0, [sp, #24]
	lsl	x21, x8, #5
	add	x19, x20, #16
	str	x2, [sp, #40]
	ldr	x27, [x2]
	mov	w8, #1
	mov	x24, x21
	mov	x22, x20
	mov	x25, x20
LBB3_3:
	cbz	x24, LBB3_28
	cmp	x20, #2
	b.ls	LBB3_55
	mov	x28, x8
	ldp	x0, x8, [x25], #32
	ldr	x8, [x8, #40]
	mov	x1, x22
	ldr	x2, [sp, #40]
	blr	x8
	tbnz	w0, #0, LBB3_38
	ldapur	x23, [x27, #32]
	add	x19, x19, #32
	add	x22, x22, #32
	sub	x24, x24, #32
	add	x8, x28, #1
	cbz	x23, LBB3_3
	sub	x8, x23, #1
	mov	w9, #1
	mov	w10, #3
	cmp	x8, #2
	csel	x26, x23, x10, lo
	csinc	w24, w9, wzr, hs
LBB3_8:
LBB3_9:
	cbz	x28, LBB3_14
	mov	x19, x21
	mov	x22, x20
	mov	x25, x20
LBB3_11:
	cbz	x19, LBB3_14
	cmp	x20, #2
	b.ls	LBB3_55
	sub	x28, x28, #1
	ldp	x0, x8, [x25], #32
	ldr	x8, [x8, #48]
	mov	x1, x22
	blr	x8
	add	x22, x22, #32
	sub	x19, x19, #32
	cbnz	x28, LBB3_11
LBB3_14:
	cmp	x26, #1
	b.le	LBB3_23
	cmp	x26, #2
	b.eq	LBB3_25
	ldr	x24, [sp, #40]
	ldr	x8, [sp, #24]
	cbz	x8, LBB3_25
	ldr	x8, [sp, #16]
	ldr	x19, [x8, #24]
	add	x22, x20, #16
	sub	x23, x23, x20
	b	LBB3_19
LBB3_18:
	add	x22, x22, #32
	sub	x23, x23, #32
	subs	x21, x21, #32
	b.eq	LBB3_25
LBB3_19:
	cmp	x20, #2
	b.ls	LBB3_55
	cbnz	x23, LBB3_18
	ldp	x0, x8, [x22, #-16]
	ldr	x8, [x8, #56]
	mov	x1, x19
	mov	x2, x24
	blr	x8
	cbz	w0, LBB3_18
	ldp	x27, x22, [x22]
	ldr	x23, [sp, #32]
	b	LBB3_44
LBB3_23:
	b.ne	LBB3_57
	ldr	x8, [sp, #24]
	cmp	x8, #0
	csinc	w8, w24, wzr, ne
	tbz	w8, #0, LBB3_40
LBB3_25:
	mov	x26, #0
LBB3_26:
	ldr	x23, [sp, #32]
LBB3_27:
	str	x26, [x23]
	.cfi_def_cfa wsp, 160
	ldp	x29, x30, [sp, #144]
	ldp	x20, x19, [sp, #128]
	ldp	x22, x21, [sp, #112]
	ldp	x24, x23, [sp, #96]
	ldp	x26, x25, [sp, #80]
	ldp	x28, x27, [sp, #64]
	add	sp, sp, #160
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	.cfi_restore w23
	.cfi_restore w24
	.cfi_restore w25
	.cfi_restore w26
	.cfi_restore w27
	.cfi_restore w28
	ret
LBB3_28:
	.cfi_restore_state
	cbz	w26, LBB3_26
	mov	w23, #51712
	movk	w23, #15258, lsl #16
	cmp	w26, #1
	b.eq	LBB3_31
	ldr	x8, [sp, #8]
	ldr	x22, [x8]
	ldr	w23, [x8, #8]
LBB3_31:
	ldr	x24, [sp, #40]
	ldr	x8, [sp, #24]
	mov	w25, #51712
	movk	w25, #15258, lsl #16
	add	x26, x20, x21
	cbz	x8, LBB3_45
	mov	x19, x20
	b	LBB3_35
LBB3_33:
	cmp	w23, w1
	cset	w8, lo
	cmp	x22, x0
	cset	w9, lt
	csel	w8, w8, w9, eq
	cmp	w8, #0
	csel	w23, w23, w1, ne
	csel	x22, x22, x0, ne
LBB3_34:
	add	x19, x19, #32
	cmp	x19, x26
	b.eq	LBB3_45
LBB3_35:
	ldp	x0, x8, [x19]
	ldr	x8, [x8, #32]
	blr	x8
	cmp	w1, w25
	b.eq	LBB3_34
	cmp	w23, w25
	b.ne	LBB3_33
	mov	x23, x1
	mov	x22, x0
	b	LBB3_34
LBB3_38:
	mov	x23, #0
	ldr	x8, [sp, #40]
	ldr	x8, [x8]
	add	x8, x8, #32
	mov	w9, #1
	casal	x23, x9, [x8]
	cmp	x23, #0
	b.ne	LBB3_52
	mov	w24, #0
	ldr	x27, [x19]
	mov	w26, #1
	b	LBB3_9
LBB3_40:
	ldr	x8, [sp, #16]
	ldr	x19, [x8, #24]
	add	x20, x20, #16
	ldr	x23, [sp, #32]
	b	LBB3_42
LBB3_41:
	add	x20, x20, #32
	subs	x21, x21, #32
	b.eq	LBB3_53
LBB3_42:
	ldr	x8, [x20]
	cmp	x8, x27
	b.ne	LBB3_41
	ldr	x22, [x20, #8]
	ldp	x0, x8, [x20, #-16]
	ldr	x8, [x8, #24]
	mov	x1, x19
	blr	x8
	tbz	w0, #0, LBB3_41
LBB3_44:
	stp	x27, x22, [x23, #8]
	mov	w26, #1
	b	LBB3_27
LBB3_45:
	ldr	x19, [x24]
	cmp	w23, w25
	b.ne	LBB3_49
	ldapur	x8, [x19, #32]
	cbnz	x8, LBB3_48
LBB3_47:
	bl	__RNvNtNtCsaLOjE9VYtxK_3std6thread9functions4park
	ldapur	x8, [x19, #32]
	cbz	x8, LBB3_47
LBB3_48:
	sub	x9, x8, #1
	mov	w10, #1
	mov	w11, #3
	cmp	x9, #2
	csel	x23, x8, x8, lo
	csel	x26, x8, x11, lo
	csinc	w24, w10, wzr, hs
	ldr	x28, [sp, #24]
	b	LBB3_9
LBB3_49:
	ldapur	x8, [x19, #32]
	cbnz	x8, LBB3_48
	bl	__RNvMNtCsaLOjE9VYtxK_3std4timeNtB2_7Instant3now
	cmp	w1, w23
	cset	w8, lo
	cmp	x0, x22
	cset	w9, lt
	csel	w8, w8, w9, eq
	tbz	w8, #0, LBB3_54
	mov	x2, x0
	mov	x3, x1
	mov	x0, x22
	mov	x1, x23
	bl	__RNvXs3_NtCsaLOjE9VYtxK_3std4timeNtB5_7InstantNtNtNtCs6sq8b9ugfBC_4core3ops5arith3Sub3sub
	bl	__RNvNtNtCsaLOjE9VYtxK_3std6thread9functions12park_timeout
	b	LBB3_49
LBB3_52:
	mov	w8, #3
	cmp	x23, #3
	csel	x26, x23, x8, lo
	mov	w24, #1
	b	LBB3_8
LBB3_53:
	mov	x26, #0
	b	LBB3_27
LBB3_54:
	mov	x23, #0
	add	x8, x19, #32
	mov	w24, #1
	casal	x23, x24, [x8]
	mov	w8, #3
	cmp	x23, #3
	csel	x8, x23, x8, lo
	cmp	x23, #0
	csinc	x26, x8, xzr, ne
	ldr	x28, [sp, #24]
	b	LBB3_9
LBB3_55:
Lloh10:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.7@PAGE
Lloh11:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.7@PAGEOFF
Lloh12:
	adrp	x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.8@PAGE
Lloh13:
	add	x2, x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.8@PAGEOFF
	mov	w1, #25
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking5panic
LBB3_56:
	mov	w9, #3
	cmp	x8, #3
	csel	x9, x8, x9, lo
	stp	x9, x8, [sp, #48]
Lloh14:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.31@PAGE
Lloh15:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.31@PAGEOFF
Lloh16:
	adrp	x3, l_anon.e689df370d6d8a85d4ce0ab270d18fef.30@PAGE
Lloh17:
	add	x3, x3, l_anon.e689df370d6d8a85d4ce0ab270d18fef.30@PAGEOFF
Lloh18:
	adrp	x4, l_anon.e689df370d6d8a85d4ce0ab270d18fef.6@PAGE
Lloh19:
	add	x4, x4, l_anon.e689df370d6d8a85d4ce0ab270d18fef.6@PAGEOFF
	add	x2, sp, #48
	mov	w1, #43
	bl	__RNvNtCs6sq8b9ugfBC_4core6result13unwrap_failed
LBB3_57:
Lloh20:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.3@PAGE
Lloh21:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.3@PAGEOFF
Lloh22:
	adrp	x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.9@PAGE
Lloh23:
	add	x2, x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.9@PAGEOFF
	mov	w1, #40
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking5panic
	.loh AdrpAdd	Lloh12, Lloh13
	.loh AdrpAdd	Lloh10, Lloh11
	.loh AdrpAdd	Lloh18, Lloh19
	.loh AdrpAdd	Lloh16, Lloh17
	.loh AdrpAdd	Lloh14, Lloh15
	.loh AdrpAdd	Lloh22, Lloh23
	.loh AdrpAdd	Lloh20, Lloh21
	.cfi_endproc

	.globl	__ZN17crossbeam_channel6select6Select10new_biased17hf0800ad743671326E
	.p2align	2
__ZN17crossbeam_channel6select6Select10new_biased17hf0800ad743671326E:
	.cfi_startproc
	stp	x20, x19, [sp, #-32]!
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_remember_state
	mov	x19, x8
	bl	__RNvCsGIExRX8pES_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w0, #128
	mov	w1, #8
	bl	__RNvCsGIExRX8pES_7___rustc12___rust_alloc
	cbz	x0, LBB4_2
	mov	w8, #4
	stp	x8, x0, [x19]
	stp	xzr, xzr, [x19, #16]
	mov	w8, #1
	strb	w8, [x19, #32]
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	ldp	x20, x19, [sp], #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	ret
LBB4_2:
	.cfi_restore_state
	mov	w0, #8
	mov	w1, #128
	bl	__RNvNtCs8dnTdrJsiec_5alloc7raw_vec12handle_error
	.cfi_endproc

	.globl	__ZN17crossbeam_channel6select6Select10try_select17h45886237e9fff7d7E
	.p2align	2
__ZN17crossbeam_channel6select6Select10try_select17h45886237e9fff7d7E:
	.cfi_startproc
	sub	sp, sp, #128
	.cfi_def_cfa_offset 128
	stp	x20, x19, [sp, #96]
	stp	x29, x30, [sp, #112]
	add	x29, sp, #112
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x8
	mov	w20, #51713
	movk	w20, #15258, lsl #16
	ldp	x9, x1, [x0, #8]
	ldrb	w4, [x0, #32]
	add	x8, sp, #8
	sub	w3, w20, #1
	mov	x0, x9
	bl	__ZN17crossbeam_channel6select10run_select17hea8c5bce3fe6efd5E
	ldr	w8, [sp, #72]
	cmp	w8, w20
	b.ne	LBB5_2
	str	w20, [x19, #80]
	b	LBB5_3
LBB5_2:
	ldur	q0, [sp, #40]
	ldur	q1, [sp, #56]
	stp	q0, q1, [x19, #48]
	ldp	x8, x9, [sp, #72]
	str	x8, [x19, #80]
	ldur	q0, [sp, #24]
	ldur	q1, [sp, #8]
	stp	q1, q0, [x19, #16]
	ldr	x8, [sp, #88]
	stp	x9, x8, [x19]
LBB5_3:
	.cfi_def_cfa wsp, 128
	ldp	x29, x30, [sp, #112]
	ldp	x20, x19, [sp, #96]
	add	sp, sp, #128
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	ret
	.cfi_endproc

	.globl	__ZN17crossbeam_channel6select6Select13ready_timeout17h79a7b71ca1997197E
	.p2align	2
__ZN17crossbeam_channel6select6Select13ready_timeout17h79a7b71ca1997197E:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x22, x21, [sp, #16]
	stp	x20, x19, [sp, #32]
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_remember_state
	mov	x20, x2
	mov	x21, x1
	mov	x19, x0
	mov	w22, #51712
	movk	w22, #15258, lsl #16
	bl	__RNvMNtCsaLOjE9VYtxK_3std4timeNtB2_7Instant3now
	str	x0, [sp]
	str	w1, [sp, #8]
	mov	x0, sp
	mov	x1, x21
	mov	x2, x20
	bl	__RNvMNtCsaLOjE9VYtxK_3std4timeNtB2_7Instant11checked_add
	cmp	w1, w22
	b.ne	LBB6_4
	ldr	x1, [x19, #16]
	cbz	x1, LBB6_6
	ldr	x0, [x19, #8]
	ldrb	w4, [x19, #32]
	add	w3, w22, #1
	bl	__ZN17crossbeam_channel6select9run_ready17h3d27acfe940b1d88E
	tbz	w0, #0, LBB6_7
	mov	x0, #0
	b	LBB6_5
LBB6_4:
	mov	x2, x0
	mov	x3, x1
	ldp	x0, x1, [x19, #8]
	ldrb	w4, [x19, #32]
	bl	__ZN17crossbeam_channel6select9run_ready17h3d27acfe940b1d88E
	mvn	w8, w0
	and	x0, x8, #0x1
LBB6_5:
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	ldp	x20, x19, [sp, #32]
	ldp	x22, x21, [sp, #16]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	ret
LBB6_6:
	.cfi_restore_state
Lloh24:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.10@PAGE
Lloh25:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.10@PAGEOFF
Lloh26:
	adrp	x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.11@PAGE
Lloh27:
	add	x2, x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.11@PAGEOFF
	mov	w1, #83
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking9panic_fmt
LBB6_7:
Lloh28:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.12@PAGE
Lloh29:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.12@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core6option13unwrap_failed
	.loh AdrpAdd	Lloh26, Lloh27
	.loh AdrpAdd	Lloh24, Lloh25
	.loh AdrpAdd	Lloh28, Lloh29
	.cfi_endproc

	.globl	__ZN17crossbeam_channel6select6Select14ready_deadline17he78ef1ddaf99f53fE
	.p2align	2
__ZN17crossbeam_channel6select6Select14ready_deadline17he78ef1ddaf99f53fE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x3, x2
	mov	x2, x1
	ldp	x8, x1, [x0, #8]
	ldrb	w4, [x0, #32]
	mov	x0, x8
	bl	__ZN17crossbeam_channel6select9run_ready17h3d27acfe940b1d88E
	mvn	w8, w0
	and	x0, x8, #0x1
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN17crossbeam_channel6select6Select14select_timeout17h0be668dc4e7a0da5E
	.p2align	2
__ZN17crossbeam_channel6select6Select14select_timeout17h0be668dc4e7a0da5E:
	.cfi_startproc
	sub	sp, sp, #192
	.cfi_def_cfa_offset 192
	stp	x26, x25, [sp, #112]
	stp	x24, x23, [sp, #128]
	stp	x22, x21, [sp, #144]
	stp	x20, x19, [sp, #160]
	stp	x29, x30, [sp, #176]
	add	x29, sp, #176
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_remember_state
	mov	x23, x2
	mov	x24, x1
	mov	x19, x8
	mov	w25, #51713
	movk	w25, #15258, lsl #16
	ldp	x21, x22, [x0, #8]
	ldrb	w20, [x0, #32]
	bl	__RNvMNtCsaLOjE9VYtxK_3std4timeNtB2_7Instant3now
	str	x0, [sp, #8]
	str	w1, [sp, #16]
	add	x0, sp, #8
	mov	x1, x24
	mov	x2, x23
	bl	__RNvMNtCsaLOjE9VYtxK_3std4timeNtB2_7Instant11checked_add
	sub	w8, w25, #1
	cmp	w1, w8
	b.ne	LBB8_4
	cbz	x22, LBB8_8
	add	x8, sp, #24
	mov	x0, x21
	mov	x1, x22
	mov	w3, #51713
	movk	w3, #15258, lsl #16
	mov	x4, x20
	bl	__ZN17crossbeam_channel6select10run_select17hea8c5bce3fe6efd5E
	ldr	w8, [sp, #88]
	cmp	w8, w25
	b.ne	LBB8_6
Lloh30:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.18@PAGE
Lloh31:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.18@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core6option13unwrap_failed
LBB8_4:
	mov	x2, x0
	mov	x3, x1
	add	x8, sp, #24
	mov	x0, x21
	mov	x1, x22
	mov	x4, x20
	bl	__ZN17crossbeam_channel6select10run_select17hea8c5bce3fe6efd5E
	ldr	w8, [sp, #88]
	cmp	w8, w25
	b.ne	LBB8_6
	str	w25, [x19, #80]
	b	LBB8_7
LBB8_6:
	ldur	q0, [sp, #56]
	ldur	q1, [sp, #72]
	stp	q0, q1, [x19, #48]
	ldp	x8, x9, [sp, #88]
	str	x8, [x19, #80]
	ldur	q0, [sp, #40]
	ldur	q1, [sp, #24]
	stp	q1, q0, [x19, #16]
	ldr	x8, [sp, #104]
	stp	x9, x8, [x19]
LBB8_7:
	.cfi_def_cfa wsp, 192
	ldp	x29, x30, [sp, #176]
	ldp	x20, x19, [sp, #160]
	ldp	x22, x21, [sp, #144]
	ldp	x24, x23, [sp, #128]
	ldp	x26, x25, [sp, #112]
	add	sp, sp, #192
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	.cfi_restore w23
	.cfi_restore w24
	.cfi_restore w25
	.cfi_restore w26
	ret
LBB8_8:
	.cfi_restore_state
Lloh32:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.10@PAGE
Lloh33:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.10@PAGEOFF
Lloh34:
	adrp	x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.17@PAGE
Lloh35:
	add	x2, x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.17@PAGEOFF
	mov	w1, #83
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking9panic_fmt
	.loh AdrpAdd	Lloh30, Lloh31
	.loh AdrpAdd	Lloh34, Lloh35
	.loh AdrpAdd	Lloh32, Lloh33
	.cfi_endproc

	.globl	__ZN17crossbeam_channel6select6Select15select_deadline17h9805560be2624107E
	.p2align	2
__ZN17crossbeam_channel6select6Select15select_deadline17h9805560be2624107E:
	.cfi_startproc
	sub	sp, sp, #128
	.cfi_def_cfa_offset 128
	stp	x20, x19, [sp, #96]
	stp	x29, x30, [sp, #112]
	add	x29, sp, #112
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x3, x2
	mov	x2, x1
	mov	x19, x8
	mov	w20, #51713
	movk	w20, #15258, lsl #16
	ldp	x9, x1, [x0, #8]
	ldrb	w4, [x0, #32]
	add	x8, sp, #8
	mov	x0, x9
	bl	__ZN17crossbeam_channel6select10run_select17hea8c5bce3fe6efd5E
	ldr	w8, [sp, #72]
	cmp	w8, w20
	b.ne	LBB9_2
	str	w20, [x19, #80]
	b	LBB9_3
LBB9_2:
	ldur	q0, [sp, #40]
	ldur	q1, [sp, #56]
	stp	q0, q1, [x19, #48]
	ldp	x8, x9, [sp, #72]
	str	x8, [x19, #80]
	ldur	q0, [sp, #24]
	ldur	q1, [sp, #8]
	stp	q1, q0, [x19, #16]
	ldr	x8, [sp, #88]
	stp	x9, x8, [x19]
LBB9_3:
	.cfi_def_cfa wsp, 128
	ldp	x29, x30, [sp, #112]
	ldp	x20, x19, [sp, #96]
	add	sp, sp, #128
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	ret
	.cfi_endproc

	.globl	__ZN17crossbeam_channel6select6Select3new17h469445bf560878bcE
	.p2align	2
__ZN17crossbeam_channel6select6Select3new17h469445bf560878bcE:
	.cfi_startproc
	stp	x20, x19, [sp, #-32]!
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_remember_state
	mov	x19, x8
	bl	__RNvCsGIExRX8pES_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w0, #128
	mov	w1, #8
	bl	__RNvCsGIExRX8pES_7___rustc12___rust_alloc
	cbz	x0, LBB10_2
	mov	w8, #4
	stp	x8, x0, [x19]
	stp	xzr, xzr, [x19, #16]
	strb	wzr, [x19, #32]
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	ldp	x20, x19, [sp], #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	ret
LBB10_2:
	.cfi_restore_state
	mov	w0, #8
	mov	w1, #128
	bl	__RNvNtCs8dnTdrJsiec_5alloc7raw_vec12handle_error
	.cfi_endproc

	.globl	__ZN17crossbeam_channel6select6Select5ready17h6069fa06d4ffc79fE
	.p2align	2
__ZN17crossbeam_channel6select6Select5ready17h6069fa06d4ffc79fE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	ldr	x1, [x0, #16]
	cbz	x1, LBB11_3
	ldr	x8, [x0, #8]
	ldrb	w4, [x0, #32]
	mov	x0, x8
	mov	w3, #51713
	movk	w3, #15258, lsl #16
	bl	__ZN17crossbeam_channel6select9run_ready17h3d27acfe940b1d88E
	cmp	x0, #1
	b.ne	LBB11_4
	mov	x0, x1
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB11_3:
	.cfi_restore_state
Lloh36:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.10@PAGE
Lloh37:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.10@PAGEOFF
Lloh38:
	adrp	x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.11@PAGE
Lloh39:
	add	x2, x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.11@PAGEOFF
	mov	w1, #83
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking9panic_fmt
LBB11_4:
Lloh40:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.12@PAGE
Lloh41:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.12@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core6option13unwrap_failed
	.loh AdrpAdd	Lloh38, Lloh39
	.loh AdrpAdd	Lloh36, Lloh37
	.loh AdrpAdd	Lloh40, Lloh41
	.cfi_endproc

	.globl	__ZN17crossbeam_channel6select6Select6remove17h83e457af003f8ad1E
	.p2align	2
__ZN17crossbeam_channel6select6Select6remove17h83e457af003f8ad1E:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x1, [sp, #8]
	mov	x8, x0
	ldr	x9, [x8, #24]!
	cmp	x1, x9
	b.hs	LBB12_6
	ldp	x10, x8, [x0, #8]
	sub	x11, x10, #32
	lsl	x12, x8, #5
	mov	x9, #-1
	mov	x13, x10
LBB12_2:
	cbz	x12, LBB12_8
	ldr	x14, [x13, #16]
	add	x13, x13, #32
	add	x11, x11, #32
	add	x9, x9, #1
	sub	x12, x12, #32
	cmp	x14, x1
	b.ne	LBB12_2
	cmp	x9, x8
	b.hs	LBB12_7
	sub	x8, x8, #1
	add	x9, x10, x8, lsl #5
	ldp	q0, q1, [x9]
	stp	q0, q1, [x11]
	str	x8, [x0, #16]
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB12_6:
	.cfi_restore_state
Lloh42:
	adrp	x9, __RNvXsi_NtNtNtCs6sq8b9ugfBC_4core3fmt3num3impjNtB9_7Display3fmt@GOTPAGE
Lloh43:
	ldr	x9, [x9, __RNvXsi_NtNtNtCs6sq8b9ugfBC_4core3fmt3num3impjNtB9_7Display3fmt@GOTPAGEOFF]
	add	x10, sp, #8
	stp	x10, x9, [sp, #16]
	stp	x8, x9, [sp, #32]
Lloh44:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.13@PAGE
Lloh45:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.13@PAGEOFF
Lloh46:
	adrp	x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.14@PAGE
Lloh47:
	add	x2, x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.14@PAGEOFF
	add	x1, sp, #16
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking9panic_fmt
LBB12_7:
	mov	x0, x9
	mov	x1, x8
	bl	__RNvNvMs_NtCs8dnTdrJsiec_5alloc3vecINtB6_3VecppE11swap_remove13assert_failed
LBB12_8:
Lloh48:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.15@PAGE
Lloh49:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.15@PAGEOFF
Lloh50:
	adrp	x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.16@PAGE
Lloh51:
	add	x2, x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.16@PAGEOFF
	mov	w1, #28
	bl	__RNvNtCs6sq8b9ugfBC_4core6option13expect_failed
	.loh AdrpAdd	Lloh46, Lloh47
	.loh AdrpAdd	Lloh44, Lloh45
	.loh AdrpLdrGot	Lloh42, Lloh43
	.loh AdrpAdd	Lloh50, Lloh51
	.loh AdrpAdd	Lloh48, Lloh49
	.cfi_endproc

	.globl	__ZN17crossbeam_channel6select6Select6select17h916e1bd41b02c7f6E
	.p2align	2
__ZN17crossbeam_channel6select6Select6select17h916e1bd41b02c7f6E:
	.cfi_startproc
	sub	sp, sp, #128
	.cfi_def_cfa_offset 128
	stp	x20, x19, [sp, #96]
	stp	x29, x30, [sp, #112]
	add	x29, sp, #112
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_remember_state
	ldr	x1, [x0, #16]
	cbz	x1, LBB13_3
	mov	x19, x8
	ldr	x9, [x0, #8]
	ldrb	w4, [x0, #32]
	mov	w20, #51713
	movk	w20, #15258, lsl #16
	add	x8, sp, #8
	mov	x0, x9
	mov	w3, #51713
	movk	w3, #15258, lsl #16
	bl	__ZN17crossbeam_channel6select10run_select17hea8c5bce3fe6efd5E
	ldr	w8, [sp, #72]
	cmp	w8, w20
	b.eq	LBB13_4
	ldur	q0, [sp, #40]
	ldur	q1, [sp, #56]
	stp	q0, q1, [x19, #48]
	ldp	x8, x9, [sp, #72]
	str	x8, [x19, #80]
	ldur	q0, [sp, #24]
	ldur	q1, [sp, #8]
	stp	q1, q0, [x19, #16]
	ldr	x8, [sp, #88]
	stp	x9, x8, [x19]
	.cfi_def_cfa wsp, 128
	ldp	x29, x30, [sp, #112]
	ldp	x20, x19, [sp, #96]
	add	sp, sp, #128
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	ret
LBB13_3:
	.cfi_restore_state
Lloh52:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.10@PAGE
Lloh53:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.10@PAGEOFF
Lloh54:
	adrp	x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.17@PAGE
Lloh55:
	add	x2, x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.17@PAGEOFF
	mov	w1, #83
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking9panic_fmt
LBB13_4:
Lloh56:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.18@PAGE
Lloh57:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.18@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core6option13unwrap_failed
	.loh AdrpAdd	Lloh54, Lloh55
	.loh AdrpAdd	Lloh52, Lloh53
	.loh AdrpAdd	Lloh56, Lloh57
	.cfi_endproc

	.globl	__ZN17crossbeam_channel6select6Select9try_ready17h57a065eebdafcf95E
	.p2align	2
__ZN17crossbeam_channel6select6Select9try_ready17h57a065eebdafcf95E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldp	x8, x1, [x0, #8]
	ldrb	w4, [x0, #32]
	mov	x0, x8
	mov	w3, #51712
	movk	w3, #15258, lsl #16
	bl	__ZN17crossbeam_channel6select9run_ready17h3d27acfe940b1d88E
	mvn	w8, w0
	and	x0, x8, #0x1
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN17crossbeam_channel6select9run_ready17h3d27acfe940b1d88E:
	.cfi_startproc
	sub	sp, sp, #176
	.cfi_def_cfa_offset 176
	stp	x28, x27, [sp, #80]
	stp	x26, x25, [sp, #96]
	stp	x24, x23, [sp, #112]
	stp	x22, x21, [sp, #128]
	stp	x20, x19, [sp, #144]
	stp	x29, x30, [sp, #160]
	add	x29, sp, #160
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	.cfi_remember_state
	str	x2, [sp, #8]
	str	w3, [sp, #16]
	cbz	x1, LBB15_51
	mov	x20, x0
	tbnz	w4, #0, LBB15_7
	cmp	x1, #1
	b.eq	LBB15_7
Lloh58:
	adrp	x0, __ZN17crossbeam_channel5utils7shuffle3RNG29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17h453156475df5204bE@TLVPPAGE
Lloh59:
	ldr	x0, [x0, __ZN17crossbeam_channel5utils7shuffle3RNG29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17h453156475df5204bE@TLVPPAGEOFF]
	ldr	x8, [x0]
	blr	x8
	ldr	w9, [x0]
	add	x10, x20, #32
	mov	w11, #1
LBB15_4:
	add	x11, x11, #1
	eor	w8, w9, w9, lsl #13
	eor	w8, w8, w8, lsr #17
	eor	w9, w8, w8, lsl #5
	mul	x8, x11, x9
	lsr	x8, x8, #32
	cmp	x8, x1
	b.hs	LBB15_60
	add	x8, x20, x8, lsl #5
	ldp	q1, q0, [x10]
	ldp	q3, q2, [x8]
	stp	q3, q2, [x10], #32
	stp	q1, q0, [x8]
	cmp	x1, x11
	b.ne	LBB15_4
	str	w9, [x0]
LBB15_7:
	mov	w19, #1
	mov	w8, #51712
	movk	w8, #15258, lsl #16
	sub	w23, w8, #1
	mov	w24, #2
	add	x25, sp, #8
	mov	x28, x20
	mov	x26, x1
	add	x27, x20, x1, lsl #5
LBB15_8:
	ldp	x0, x8, [x28]
	ldr	x22, [x28, #16]
	ldr	x8, [x8, #64]
	blr	x8
	tbnz	w0, #0, LBB15_58
	add	x28, x28, #32
	cmp	x28, x27
	b.ne	LBB15_8
	isb
	mov	x28, x20
LBB15_11:
	ldp	x0, x8, [x28]
	ldr	x21, [x28, #16]
	ldr	x8, [x8, #64]
	blr	x8
	tbnz	w0, #0, LBB15_50
	add	x28, x28, #32
	cmp	x28, x27
	b.ne	LBB15_11
	isb
	isb
	mov	x28, x20
LBB15_14:
	ldp	x0, x8, [x28]
	ldr	x21, [x28, #16]
	ldr	x8, [x8, #64]
	blr	x8
	tbnz	w0, #0, LBB15_50
	add	x28, x28, #32
	cmp	x28, x27
	b.ne	LBB15_14
	isb
	isb
	isb
	isb
	mov	x28, x20
LBB15_17:
	ldp	x0, x8, [x28]
	ldr	x21, [x28, #16]
	ldr	x8, [x8, #64]
	blr	x8
	tbnz	w0, #0, LBB15_50
	add	x28, x28, #32
	cmp	x28, x27
	b.ne	LBB15_17
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	mov	x28, x20
LBB15_20:
	ldp	x0, x8, [x28]
	ldr	x21, [x28, #16]
	ldr	x8, [x8, #64]
	blr	x8
	tbnz	w0, #0, LBB15_50
	add	x28, x28, #32
	cmp	x28, x27
	b.ne	LBB15_20
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	mov	x28, x20
LBB15_23:
	ldp	x0, x8, [x28]
	ldr	x21, [x28, #16]
	ldr	x8, [x8, #64]
	blr	x8
	tbnz	w0, #0, LBB15_50
	add	x28, x28, #32
	cmp	x28, x27
	b.ne	LBB15_23
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	mov	x28, x20
LBB15_26:
	ldp	x0, x8, [x28]
	ldr	x21, [x28, #16]
	ldr	x8, [x8, #64]
	blr	x8
	tbnz	w0, #0, LBB15_50
	add	x28, x28, #32
	cmp	x28, x27
	b.ne	LBB15_26
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	isb
	mov	x28, x20
LBB15_29:
	ldp	x0, x8, [x28]
	ldr	x21, [x28, #16]
	ldr	x8, [x8, #64]
	blr	x8
	tbnz	w0, #0, LBB15_50
	add	x28, x28, #32
	cmp	x28, x27
	b.ne	LBB15_29
	bl	__RNvNtNtCsaLOjE9VYtxK_3std6thread9functions9yield_now
	mov	x28, x20
LBB15_32:
	ldp	x0, x8, [x28]
	ldr	x21, [x28, #16]
	ldr	x8, [x8, #64]
	blr	x8
	tbnz	w0, #0, LBB15_50
	add	x28, x28, #32
	cmp	x28, x27
	b.ne	LBB15_32
	bl	__RNvNtNtCsaLOjE9VYtxK_3std6thread9functions9yield_now
	mov	x28, x20
LBB15_35:
	ldp	x0, x8, [x28]
	ldr	x21, [x28, #16]
	ldr	x8, [x8, #64]
	blr	x8
	tbnz	w0, #0, LBB15_50
	add	x28, x28, #32
	cmp	x28, x27
	b.ne	LBB15_35
	bl	__RNvNtNtCsaLOjE9VYtxK_3std6thread9functions9yield_now
	mov	x28, x20
LBB15_38:
	ldp	x0, x8, [x28]
	ldr	x21, [x28, #16]
	ldr	x8, [x8, #64]
	blr	x8
	tbnz	w0, #0, LBB15_50
	add	x28, x28, #32
	cmp	x28, x27
	b.ne	LBB15_38
	bl	__RNvNtNtCsaLOjE9VYtxK_3std6thread9functions9yield_now
	mov	x28, x20
LBB15_41:
	ldp	x0, x8, [x28]
	ldr	x21, [x28, #16]
	ldr	x8, [x8, #64]
	blr	x8
	tbnz	w0, #0, LBB15_50
	add	x28, x28, #32
	cmp	x28, x27
	b.ne	LBB15_41
	ldr	w28, [sp, #16]
	mov	w8, #13824
	movk	w8, #50277, lsl #16
	add	w8, w28, w8
	cmp	w28, w23
	csel	w8, w8, w24, hi
	cmp	w8, #1
	b.eq	LBB15_48
	cmp	w8, #2
	b.ne	LBB15_61
	ldr	x21, [sp, #8]
	bl	__RNvMNtCsaLOjE9VYtxK_3std4timeNtB2_7Instant3now
	cmp	x0, x21
	b.ne	LBB15_47
	cmp	w1, w28
	b.lo	LBB15_48
	b	LBB15_62
LBB15_47:
	b.ge	LBB15_62
LBB15_48:
	stp	x20, x26, [sp, #24]
	str	x25, [sp, #40]
	add	x0, sp, #24
	bl	__ZN17crossbeam_channel7context7Context4with17h945cf1592ec571eeE
	mov	x28, x20
	cmp	x0, #1
	b.ne	LBB15_8
	mov	x22, x1
	mov	w19, #1
	b	LBB15_58
LBB15_50:
	mov	x22, x21
	b	LBB15_58
LBB15_51:
	mov	x21, x3
	mov	w8, #51712
	movk	w8, #15258, lsl #16
	mov	w9, #13824
	movk	w9, #50277, lsl #16
	add	w9, w3, w9
	sub	w8, w8, #1
	mov	w10, #2
	cmp	w3, w8
	csel	w19, w9, w10, hi
	cbz	w19, LBB15_57
	cmp	w19, #2
	b.ne	LBB15_59
	mov	x22, x2
	bl	__RNvMNtCsaLOjE9VYtxK_3std4timeNtB2_7Instant3now
	cmp	w1, w21
	cset	w8, hs
	cmp	x0, x22
	cset	w9, ge
	csel	w8, w8, w9, eq
	tbnz	w8, #0, LBB15_56
	mov	x2, x0
	mov	x3, x1
LBB15_55:
	mov	x0, x22
	mov	x1, x21
	bl	__RNvXs3_NtCsaLOjE9VYtxK_3std4timeNtB5_7InstantNtNtNtCs6sq8b9ugfBC_4core3ops5arith3Sub3sub
	bl	__RNvNtNtCsaLOjE9VYtxK_3std6thread9functions5sleep
	bl	__RNvMNtCsaLOjE9VYtxK_3std4timeNtB2_7Instant3now
	mov	x2, x0
	mov	x3, x1
	cmp	w1, w21
	cset	w8, hs
	cmp	x0, x22
	cset	w9, ge
	csel	w8, w8, w9, eq
	tbz	w8, #0, LBB15_55
LBB15_56:
	mov	x19, #0
LBB15_57:
LBB15_58:
	mov	x0, x19
	mov	x1, x22
	.cfi_def_cfa wsp, 176
	ldp	x29, x30, [sp, #160]
	ldp	x20, x19, [sp, #144]
	ldp	x22, x21, [sp, #128]
	ldp	x24, x23, [sp, #112]
	ldp	x26, x25, [sp, #96]
	ldp	x28, x27, [sp, #80]
	add	sp, sp, #176
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	.cfi_restore w23
	.cfi_restore w24
	.cfi_restore w25
	.cfi_restore w26
	.cfi_restore w27
	.cfi_restore w28
	ret
LBB15_59:
	.cfi_restore_state
	mov	w1, #51712
	movk	w1, #15258, lsl #16
	bl	__ZN17crossbeam_channel5utils11sleep_until17ha7e3391d34a6dcc7E
Lloh60:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.3@PAGE
Lloh61:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.3@PAGEOFF
Lloh62:
	adrp	x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.19@PAGE
Lloh63:
	add	x2, x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.19@PAGEOFF
	mov	w1, #40
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking5panic
LBB15_60:
	str	w9, [x0]
Lloh64:
	adrp	x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.2@PAGE
Lloh65:
	add	x2, x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.2@PAGEOFF
	mov	x0, x8
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB15_61:
	mov	x19, x8
	b	LBB15_58
LBB15_62:
	mov	x19, #0
	b	LBB15_58
	.loh AdrpLdr	Lloh58, Lloh59
	.loh AdrpAdd	Lloh62, Lloh63
	.loh AdrpAdd	Lloh60, Lloh61
	.loh AdrpAdd	Lloh64, Lloh65
	.cfi_endproc

	.p2align	2
__ZN17crossbeam_channel6select9run_ready28_$u7b$$u7b$closure$u7d$$u7d$17h7a9d02fc5072c368E:
	.cfi_startproc
	sub	sp, sp, #112
	.cfi_def_cfa_offset 112
	stp	x28, x27, [sp, #16]
	stp	x26, x25, [sp, #32]
	stp	x24, x23, [sp, #48]
	stp	x22, x21, [sp, #64]
	stp	x20, x19, [sp, #80]
	stp	x29, x30, [sp, #96]
	add	x29, sp, #96
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	.cfi_remember_state
	mov	x19, x1
	ldp	x21, x8, [x0]
	stp	x0, x8, [sp]
	mov	x22, x21
	lsl	x26, x8, #5
	ldr	x25, [x1]
	mov	w8, #1
	mov	x23, x26
	mov	x20, x21
	mov	x24, x21
LBB16_1:
	cbz	x23, LBB16_6
	cmp	x21, #2
	b.ls	LBB16_38
	mov	x27, x8
	ldp	x0, x8, [x24], #32
	ldr	x8, [x8, #72]
	mov	x1, x20
	mov	x2, x19
	blr	x8
	tbnz	w0, #0, LBB16_9
	ldapur	x28, [x25, #32]
	add	x20, x20, #32
	sub	x23, x23, #32
	add	x8, x27, #1
	cbz	x28, LBB16_1
	sub	x8, x28, #1
	mov	w9, #3
	cmp	x8, #2
	csel	x20, x28, x9, lo
	cbnz	x27, LBB16_21
	b	LBB16_25
LBB16_6:
	mov	w27, #51712
	movk	w27, #15258, lsl #16
	ldr	x8, [sp]
	ldr	x8, [x8, #16]
	ldr	w20, [x8, #8]
	mov	w9, #13824
	movk	w9, #50277, lsl #16
	add	w9, w20, w9
	sub	w10, w27, #1
	mov	w11, #2
	cmp	w20, w10
	csel	w9, w9, w11, hi
	cmp	w9, #1
	b.eq	LBB16_10
	cmp	w9, #2
	ldr	x24, [sp, #8]
	add	x25, x21, x26
	b.ne	LBB16_40
	ldr	x23, [x8]
	cbnz	x24, LBB16_11
	b	LBB16_17
LBB16_9:
	mov	x8, #0
	ldr	x9, [x19]
	add	x9, x9, #32
	casal	x8, x20, [x9]
	cmp	x8, #0
	cset	w9, eq
	mov	w10, #3
	mov	w11, #3
	cmp	x8, #3
	csel	x11, x8, x11, lo
	tst	w9, #0x1
	csel	x28, x20, x8, ne
	csel	x20, x10, x11, ne
	cbnz	x27, LBB16_21
	b	LBB16_25
LBB16_10:
	mov	w20, #51712
	movk	w20, #15258, lsl #16
	ldr	x24, [sp, #8]
	add	x25, x21, x26
	cbz	x24, LBB16_17
LBB16_11:
	mov	x28, x22
	b	LBB16_14
LBB16_12:
	cmp	w20, w1
	cset	w8, lo
	cmp	x23, x0
	cset	w9, lt
	csel	w8, w8, w9, eq
	cmp	w8, #0
	csel	w20, w20, w1, ne
	csel	x23, x23, x0, ne
LBB16_13:
	add	x28, x28, #32
	cmp	x28, x25
	b.eq	LBB16_17
LBB16_14:
	ldp	x0, x8, [x28]
	ldr	x8, [x8, #32]
	blr	x8
	cmp	w1, w27
	b.eq	LBB16_13
	cmp	w20, w27
	b.ne	LBB16_12
	mov	x20, x1
	mov	x23, x0
	b	LBB16_13
LBB16_17:
	ldr	x19, [x19]
	cmp	w20, w27
	b.ne	LBB16_28
	ldapur	x8, [x19, #32]
	cbnz	x8, LBB16_20
LBB16_19:
	bl	__RNvNtNtCsaLOjE9VYtxK_3std6thread9functions4park
	ldapur	x8, [x19, #32]
	cbz	x8, LBB16_19
LBB16_20:
	sub	x9, x8, #1
	mov	w10, #3
	cmp	x9, #2
	csel	x28, x8, x8, lo
	csel	x20, x8, x10, lo
	mov	x27, x24
	cbz	x24, LBB16_25
LBB16_21:
	mov	x23, x26
	mov	x19, x21
LBB16_22:
	cbz	x23, LBB16_25
	cmp	x21, #2
	b.ls	LBB16_38
	sub	x27, x27, #1
	ldp	x0, x8, [x22], #32
	ldr	x8, [x8, #80]
	mov	x1, x19
	blr	x8
	add	x19, x19, #32
	sub	x23, x23, #32
	cbnz	x27, LBB16_22
LBB16_25:
	sub	x8, x20, #1
	cmp	x8, #2
	b.hs	LBB16_31
LBB16_26:
	mov	x0, #0
LBB16_27:
	.cfi_def_cfa wsp, 112
	ldp	x29, x30, [sp, #96]
	ldp	x20, x19, [sp, #80]
	ldp	x22, x21, [sp, #64]
	ldp	x24, x23, [sp, #48]
	ldp	x26, x25, [sp, #32]
	ldp	x28, x27, [sp, #16]
	add	sp, sp, #112
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	.cfi_restore w23
	.cfi_restore w24
	.cfi_restore w25
	.cfi_restore w26
	.cfi_restore w27
	.cfi_restore w28
	ret
LBB16_28:
	.cfi_restore_state
	ldapur	x8, [x19, #32]
	cbnz	x8, LBB16_20
	bl	__RNvMNtCsaLOjE9VYtxK_3std4timeNtB2_7Instant3now
	cmp	w1, w20
	cset	w8, lo
	cmp	x0, x23
	cset	w9, lt
	csel	w8, w8, w9, eq
	tbz	w8, #0, LBB16_37
	mov	x2, x0
	mov	x3, x1
	mov	x0, x23
	mov	x1, x20
	bl	__RNvXs3_NtCsaLOjE9VYtxK_3std4timeNtB5_7InstantNtNtNtCs6sq8b9ugfBC_4core3ops5arith3Sub3sub
	bl	__RNvNtNtCsaLOjE9VYtxK_3std6thread9functions12park_timeout
	b	LBB16_28
LBB16_31:
	cmp	x20, #3
	b.ne	LBB16_39
	sub	x8, x21, #16
	sub	x9, x28, x21
	add	x9, x9, #32
LBB16_33:
	cbz	x26, LBB16_26
	cmp	x21, #2
	b.ls	LBB16_38
	add	x8, x8, #32
	sub	x26, x26, #32
	sub	x9, x9, #32
	cbnz	x9, LBB16_33
	ldr	x1, [x8]
	mov	w0, #1
	b	LBB16_27
LBB16_37:
	mov	x28, #0
	add	x8, x19, #32
	mov	w9, #1
	casal	x28, x9, [x8]
	mov	w8, #3
	cmp	x28, #3
	csel	x8, x28, x8, lo
	cmp	x28, #0
	csinc	x20, x8, xzr, ne
	mov	x27, x24
	cbnz	x24, LBB16_21
	b	LBB16_25
LBB16_38:
Lloh66:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.7@PAGE
Lloh67:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.7@PAGEOFF
Lloh68:
	adrp	x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.8@PAGE
Lloh69:
	add	x2, x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.8@PAGEOFF
	mov	w1, #25
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking5panic
LBB16_39:
Lloh70:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.3@PAGE
Lloh71:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.3@PAGEOFF
Lloh72:
	adrp	x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.21@PAGE
Lloh73:
	add	x2, x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.21@PAGEOFF
	mov	w1, #40
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking5panic
LBB16_40:
Lloh74:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.3@PAGE
Lloh75:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.3@PAGEOFF
Lloh76:
	adrp	x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.20@PAGE
Lloh77:
	add	x2, x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.20@PAGEOFF
	mov	w1, #40
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking5panic
	.loh AdrpAdd	Lloh68, Lloh69
	.loh AdrpAdd	Lloh66, Lloh67
	.loh AdrpAdd	Lloh72, Lloh73
	.loh AdrpAdd	Lloh70, Lloh71
	.loh AdrpAdd	Lloh76, Lloh77
	.loh AdrpAdd	Lloh74, Lloh75
	.cfi_endproc

	.globl	__ZN17crossbeam_channel7channel2at17hc4d0e3026898aeafE
	.p2align	2
__ZN17crossbeam_channel7channel2at17hc4d0e3026898aeafE:
	.cfi_startproc
	stp	x20, x19, [sp, #-32]!
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_remember_state
	mov	x19, x1
	mov	x20, x0
	bl	__RNvCsGIExRX8pES_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w0, #40
	mov	w1, #8
	bl	__RNvCsGIExRX8pES_7___rustc12___rust_alloc
	cbz	x0, LBB17_2
	mov	x1, x0
	mov	w8, #1
	dup.2d	v0, x8
	str	q0, [x0]
	str	x20, [x0, #16]
	str	w19, [x0, #24]
	strb	wzr, [x0, #32]
	mov	w0, #3
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	ldp	x20, x19, [sp], #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	ret
LBB17_2:
	.cfi_restore_state
	mov	w0, #8
	mov	w1, #40
	bl	__RNvNtCs8dnTdrJsiec_5alloc5alloc18handle_alloc_error
	.cfi_endproc

	.globl	__ZN17crossbeam_channel7channel4tick17ha662d808e102de39E
	.p2align	2
__ZN17crossbeam_channel7channel4tick17ha662d808e102de39E:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x22, x21, [sp, #16]
	stp	x20, x19, [sp, #32]
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_remember_state
	mov	x19, x1
	mov	x20, x0
	bl	__RNvMNtCsaLOjE9VYtxK_3std4timeNtB2_7Instant3now
	str	x0, [sp]
	str	w1, [sp, #8]
	mov	x0, sp
	mov	x1, x20
	mov	x2, x19
	bl	__RNvMNtCsaLOjE9VYtxK_3std4timeNtB2_7Instant11checked_add
	mov	w8, #51712
	movk	w8, #15258, lsl #16
	cmp	w1, w8
	b.ne	LBB18_2
	mov	w0, #5
	b	LBB18_4
LBB18_2:
	mov	x21, x0
	mov	x22, x1
	bl	__RNvCsGIExRX8pES_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w0, #48
	mov	w1, #8
	bl	__RNvCsGIExRX8pES_7___rustc12___rust_alloc
	cbz	x0, LBB18_5
	mov	x1, x0
	mov	w8, #1
	dup.2d	v0, x8
	str	q0, [x0]
	str	x21, [x0, #16]
	str	w22, [x0, #24]
	str	x20, [x0, #32]
	str	w19, [x0, #40]
	mov	w0, #4
LBB18_4:
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	ldp	x20, x19, [sp, #32]
	ldp	x22, x21, [sp, #16]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	ret
LBB18_5:
	.cfi_restore_state
	mov	w0, #8
	mov	w1, #48
	bl	__RNvNtCs8dnTdrJsiec_5alloc5alloc18handle_alloc_error
	.cfi_endproc

	.globl	__ZN17crossbeam_channel7channel5after17h8dad157eb6b56dfbE
	.p2align	2
__ZN17crossbeam_channel7channel5after17h8dad157eb6b56dfbE:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x20, x19, [sp, #16]
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_remember_state
	mov	x19, x1
	mov	x20, x0
	bl	__RNvMNtCsaLOjE9VYtxK_3std4timeNtB2_7Instant3now
	str	x0, [sp]
	str	w1, [sp, #8]
	mov	x0, sp
	mov	x1, x20
	mov	x2, x19
	bl	__RNvMNtCsaLOjE9VYtxK_3std4timeNtB2_7Instant11checked_add
	mov	w8, #51712
	movk	w8, #15258, lsl #16
	cmp	w1, w8
	b.ne	LBB19_2
	mov	w0, #5
	b	LBB19_4
LBB19_2:
	mov	x19, x0
	mov	x20, x1
	bl	__RNvCsGIExRX8pES_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w0, #40
	mov	w1, #8
	bl	__RNvCsGIExRX8pES_7___rustc12___rust_alloc
	cbz	x0, LBB19_5
	mov	x1, x0
	mov	w8, #1
	dup.2d	v0, x8
	str	q0, [x0]
	str	x19, [x0, #16]
	str	w20, [x0, #24]
	strb	wzr, [x0, #32]
	mov	w0, #3
LBB19_4:
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	ldp	x20, x19, [sp, #16]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	ret
LBB19_5:
	.cfi_restore_state
	mov	w0, #8
	mov	w1, #40
	bl	__RNvNtCs8dnTdrJsiec_5alloc5alloc18handle_alloc_error
	.cfi_endproc

	.globl	__ZN17crossbeam_channel7context7Context3new17hb6c2eee222ec953aE
	.p2align	2
__ZN17crossbeam_channel7context7Context3new17hb6c2eee222ec953aE:
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception1
	sub	sp, sp, #112
	.cfi_def_cfa_offset 112
	stp	x22, x21, [sp, #64]
	stp	x20, x19, [sp, #80]
	stp	x29, x30, [sp, #96]
	add	x29, sp, #96
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_remember_state
	bl	__RNvNtNtCsaLOjE9VYtxK_3std6thread7current7current
	mov	x19, x0
	str	x0, [sp, #16]
Ltmp11:
	bl	__RNvNtNtCsaLOjE9VYtxK_3std6thread7current7current
Ltmp12:
	mov	x20, x0
	str	x0, [sp, #8]
	mov	w8, #1
	dup.2d	v0, x8
	ldr	x8, [x0, #16]
	str	q0, [sp, #16]
	stp	x19, x8, [sp, #32]
	stp	xzr, xzr, [sp, #48]
	bl	__RNvCsGIExRX8pES_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w0, #48
	mov	w1, #8
	bl	__RNvCsGIExRX8pES_7___rustc12___rust_alloc
	cbz	x0, LBB20_5
	ldp	q0, q1, [sp, #16]
	stp	q0, q1, [x0]
	ldr	q0, [sp, #48]
	str	q0, [x0, #32]
	mov	x8, #-1
	ldaddl	x8, x8, [x20]
	cmp	x8, #1
	b.ne	LBB20_4
	dmb	ishld
	mov	x19, x0
	add	x0, sp, #8
	bl	__RNvMsn_NtCs8dnTdrJsiec_5alloc4syncINtB5_3ArcNtNtNtCsaLOjE9VYtxK_3std6thread6thread5InnerNtNtBM_5alloc6SystemE9drop_slowBM_
	mov	x0, x19
LBB20_4:
	.cfi_def_cfa wsp, 112
	ldp	x29, x30, [sp, #96]
	ldp	x20, x19, [sp, #80]
	ldp	x22, x21, [sp, #64]
	add	sp, sp, #112
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	ret
LBB20_5:
	.cfi_restore_state
Ltmp16:
	add	x21, sp, #16
	mov	w0, #8
	mov	w1, #48
	bl	__RNvNtCs8dnTdrJsiec_5alloc5alloc18handle_alloc_error
Ltmp17:
	brk	#0x1
LBB20_7:
Ltmp13:
	mov	x20, x0
	mov	x8, #-1
	ldaddl	x8, x8, [x19]
	cmp	x8, #1
	b.ne	LBB20_13
	dmb	ishld
Ltmp14:
	add	x0, sp, #16
	bl	__RNvMsn_NtCs8dnTdrJsiec_5alloc4syncINtB5_3ArcNtNtNtCsaLOjE9VYtxK_3std6thread6thread5InnerNtNtBM_5alloc6SystemE9drop_slowBM_
Ltmp15:
	b	LBB20_13
LBB20_9:
Ltmp18:
	mov	x20, x0
	mov	x22, #-1
	ldaddl	x22, x8, [x19]
	cmp	x8, #1
	b.ne	LBB20_11
	dmb	ishld
Ltmp19:
	add	x0, x21, #16
	bl	__RNvMsn_NtCs8dnTdrJsiec_5alloc4syncINtB5_3ArcNtNtNtCsaLOjE9VYtxK_3std6thread6thread5InnerNtNtBM_5alloc6SystemE9drop_slowBM_
Ltmp20:
LBB20_11:
	ldr	x8, [sp, #8]
	ldaddl	x22, x8, [x8]
	cmp	x8, #1
	b.ne	LBB20_13
	dmb	ishld
Ltmp22:
	add	x0, sp, #8
	bl	__RNvMsn_NtCs8dnTdrJsiec_5alloc4syncINtB5_3ArcNtNtNtCsaLOjE9VYtxK_3std6thread6thread5InnerNtNtBM_5alloc6SystemE9drop_slowBM_
Ltmp23:
LBB20_13:
	mov	x0, x20
	bl	__Unwind_Resume
LBB20_14:
Ltmp24:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB20_15:
Ltmp21:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table20:
Lexception1:
	.byte	255
	.byte	155
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Lfunc_begin1-Lfunc_begin1
	.uleb128 Ltmp11-Lfunc_begin1
	.byte	0
	.byte	0
	.uleb128 Ltmp11-Lfunc_begin1
	.uleb128 Ltmp12-Ltmp11
	.uleb128 Ltmp13-Lfunc_begin1
	.byte	0
	.uleb128 Ltmp12-Lfunc_begin1
	.uleb128 Ltmp16-Ltmp12
	.byte	0
	.byte	0
	.uleb128 Ltmp16-Lfunc_begin1
	.uleb128 Ltmp17-Ltmp16
	.uleb128 Ltmp18-Lfunc_begin1
	.byte	0
	.uleb128 Ltmp14-Lfunc_begin1
	.uleb128 Ltmp15-Ltmp14
	.uleb128 Ltmp24-Lfunc_begin1
	.byte	1
	.uleb128 Ltmp19-Lfunc_begin1
	.uleb128 Ltmp20-Ltmp19
	.uleb128 Ltmp21-Lfunc_begin1
	.byte	1
	.uleb128 Ltmp22-Lfunc_begin1
	.uleb128 Ltmp23-Ltmp22
	.uleb128 Ltmp24-Lfunc_begin1
	.byte	1
	.uleb128 Ltmp23-Lfunc_begin1
	.uleb128 Lfunc_end1-Ltmp23
	.byte	0
	.byte	0
Lcst_end1:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase1:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN17crossbeam_channel7context7Context4with17h945cf1592ec571eeE:
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception2
	sub	sp, sp, #112
	.cfi_def_cfa_offset 112
	stp	x22, x21, [sp, #64]
	stp	x20, x19, [sp, #80]
	stp	x29, x30, [sp, #96]
	add	x29, sp, #96
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_remember_state
	mov	x20, x0
	ldr	q0, [x0]
	str	q0, [sp]
	ldr	x8, [x0, #16]
	str	x8, [sp, #16]
Lloh78:
	adrp	x0, __ZN17crossbeam_channel7context7Context4with7CONTEXT29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17hee7fab048a4b49b6E@TLVPPAGE
Lloh79:
	ldr	x0, [x0, __ZN17crossbeam_channel7context7Context4with7CONTEXT29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17hee7fab048a4b49b6E@TLVPPAGEOFF]
	ldr	x8, [x0]
	blr	x8
	mov	x19, x0
	ldrb	w8, [x0, #8]
	cmp	w8, #1
	b.ne	LBB21_10
LBB21_1:
	ldr	x21, [x19]
	str	xzr, [x19]
	cbz	x21, LBB21_12
	str	x21, [sp, #32]
	stlur	xzr, [x21, #32]
	stlur	xzr, [x21, #40]
	ldr	x8, [sp]
	str	xzr, [sp]
	cbz	x8, LBB21_16
	str	x8, [sp, #40]
	ldur	q0, [sp, #8]
	stur	q0, [sp, #48]
Ltmp25:
	add	x0, sp, #40
	add	x1, sp, #32
	bl	__ZN17crossbeam_channel6select9run_ready28_$u7b$$u7b$closure$u7d$$u7d$17h7a9d02fc5072c368E
Ltmp26:
	ldr	x8, [x19]
	str	x8, [sp, #40]
	str	x21, [x19]
	cbz	x8, LBB21_8
	mov	x9, #-1
	ldaddl	x9, x8, [x8]
	cmp	x8, #1
	b.ne	LBB21_8
	dmb	ishld
	mov	x19, x0
	add	x0, sp, #40
LBB21_7:
	mov	x20, x1
	bl	__ZN5alloc4sync16Arc$LT$T$C$A$GT$9drop_slow17ha5b06fadef84789bE
	mov	x1, x20
	mov	x0, x19
LBB21_8:
	cmp	x0, #2
	b.eq	LBB21_11
LBB21_9:
	.cfi_def_cfa wsp, 112
	ldp	x29, x30, [sp, #96]
	ldp	x20, x19, [sp, #80]
	ldp	x22, x21, [sp, #64]
	add	sp, sp, #112
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	ret
LBB21_10:
	.cfi_restore_state
	mov	x0, x19
	mov	x1, #0
	bl	__ZN3std3sys12thread_local6native4lazy20Storage$LT$T$C$D$GT$16get_or_init_slow17ha91bac1a167e65e7E
	mov	x19, x0
	cbnz	x0, LBB21_1
LBB21_11:
	mov	x0, sp
	bl	__ZN17crossbeam_channel7context7Context4with28_$u7b$$u7b$closure$u7d$$u7d$17h709951dce743bf44E
	b	LBB21_9
LBB21_12:
	bl	__ZN17crossbeam_channel7context7Context3new17hb6c2eee222ec953aE
	mov	x19, x0
	str	x0, [sp, #32]
	ldr	x8, [sp]
	str	xzr, [sp]
	cbz	x8, LBB21_17
	str	x8, [sp, #40]
	ldur	q0, [x20, #8]
	stur	q0, [sp, #48]
Ltmp32:
	add	x0, sp, #40
	add	x1, sp, #32
	bl	__ZN17crossbeam_channel6select9run_ready28_$u7b$$u7b$closure$u7d$$u7d$17h7a9d02fc5072c368E
Ltmp33:
	mov	x8, #-1
	ldaddl	x8, x8, [x19]
	cmp	x8, #1
	b.ne	LBB21_8
	dmb	ishld
	mov	x19, x0
	add	x0, sp, #32
	b	LBB21_7
LBB21_16:
Ltmp27:
Lloh80:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.23@PAGE
Lloh81:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.23@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core6option13unwrap_failed
Ltmp28:
	b	LBB21_18
LBB21_17:
Ltmp34:
Lloh82:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.23@PAGE
Lloh83:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.23@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core6option13unwrap_failed
Ltmp35:
LBB21_18:
	brk	#0x1
LBB21_19:
Ltmp36:
	mov	x20, x0
	mov	x8, #-1
	ldaddl	x8, x8, [x19]
	cmp	x8, #1
	b.ne	LBB21_21
	dmb	ishld
Ltmp37:
	add	x0, sp, #32
	bl	__ZN5alloc4sync16Arc$LT$T$C$A$GT$9drop_slow17ha5b06fadef84789bE
Ltmp38:
	mov	x0, x20
	b	LBB21_24
LBB21_21:
	mov	x0, x20
	bl	__Unwind_Resume
LBB21_22:
Ltmp29:
	mov	x8, #-1
	ldaddl	x8, x8, [x21]
	cmp	x8, #1
	b.ne	LBB21_24
	dmb	ishld
Ltmp30:
	mov	x19, x0
	add	x0, sp, #32
	bl	__ZN5alloc4sync16Arc$LT$T$C$A$GT$9drop_slow17ha5b06fadef84789bE
	mov	x0, x19
Ltmp31:
LBB21_24:
	bl	__Unwind_Resume
LBB21_25:
Ltmp39:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
	.loh AdrpLdr	Lloh78, Lloh79
	.loh AdrpAdd	Lloh80, Lloh81
	.loh AdrpAdd	Lloh82, Lloh83
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table21:
Lexception2:
	.byte	255
	.byte	155
	.uleb128 Lttbase2-Lttbaseref2
Lttbaseref2:
	.byte	1
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Lfunc_begin2-Lfunc_begin2
	.uleb128 Ltmp25-Lfunc_begin2
	.byte	0
	.byte	0
	.uleb128 Ltmp25-Lfunc_begin2
	.uleb128 Ltmp26-Ltmp25
	.uleb128 Ltmp29-Lfunc_begin2
	.byte	0
	.uleb128 Ltmp26-Lfunc_begin2
	.uleb128 Ltmp32-Ltmp26
	.byte	0
	.byte	0
	.uleb128 Ltmp32-Lfunc_begin2
	.uleb128 Ltmp33-Ltmp32
	.uleb128 Ltmp36-Lfunc_begin2
	.byte	0
	.uleb128 Ltmp27-Lfunc_begin2
	.uleb128 Ltmp28-Ltmp27
	.uleb128 Ltmp29-Lfunc_begin2
	.byte	0
	.uleb128 Ltmp34-Lfunc_begin2
	.uleb128 Ltmp35-Ltmp34
	.uleb128 Ltmp36-Lfunc_begin2
	.byte	0
	.uleb128 Ltmp37-Lfunc_begin2
	.uleb128 Ltmp38-Ltmp37
	.uleb128 Ltmp39-Lfunc_begin2
	.byte	1
	.uleb128 Ltmp38-Lfunc_begin2
	.uleb128 Ltmp30-Ltmp38
	.byte	0
	.byte	0
	.uleb128 Ltmp30-Lfunc_begin2
	.uleb128 Ltmp31-Ltmp30
	.uleb128 Ltmp39-Lfunc_begin2
	.byte	1
	.uleb128 Ltmp31-Lfunc_begin2
	.uleb128 Lfunc_end2-Ltmp31
	.byte	0
	.byte	0
Lcst_end2:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase2:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN17crossbeam_channel7context7Context4with28_$u7b$$u7b$closure$u7d$$u7d$17h2e24cead4f2f7c4dE:
Lfunc_begin3:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception3
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	stp	x22, x21, [sp, #48]
	stp	x20, x19, [sp, #64]
	stp	x29, x30, [sp, #80]
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_remember_state
	mov	x21, x1
	mov	x20, x0
	bl	__ZN17crossbeam_channel7context7Context3new17hb6c2eee222ec953aE
	mov	x19, x0
	str	x0, [sp, #8]
	ldr	x8, [x21]
	str	xzr, [x21]
	cbz	x8, LBB22_5
	str	x8, [sp, #16]
	ldur	q0, [x21, #8]
	stur	q0, [sp, #24]
	ldr	x8, [x21, #24]
	str	x8, [sp, #40]
Ltmp40:
	add	x1, sp, #16
	add	x2, sp, #8
	mov	x0, x20
	bl	__ZN17crossbeam_channel6select10run_select28_$u7b$$u7b$closure$u7d$$u7d$17h8002dd84c8992a81E
Ltmp41:
	mov	x8, #-1
	ldaddl	x8, x8, [x19]
	cmp	x8, #1
	b.ne	LBB22_4
	dmb	ishld
	add	x0, sp, #8
	bl	__ZN5alloc4sync16Arc$LT$T$C$A$GT$9drop_slow17ha5b06fadef84789bE
LBB22_4:
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	ldp	x20, x19, [sp, #64]
	ldp	x22, x21, [sp, #48]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	ret
LBB22_5:
	.cfi_restore_state
Ltmp42:
Lloh84:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.23@PAGE
Lloh85:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.23@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core6option13unwrap_failed
Ltmp43:
	brk	#0x1
LBB22_7:
Ltmp44:
	mov	x8, #-1
	ldaddl	x8, x8, [x19]
	cmp	x8, #1
	b.ne	LBB22_9
	dmb	ishld
Ltmp45:
	mov	x19, x0
	add	x0, sp, #8
	bl	__ZN5alloc4sync16Arc$LT$T$C$A$GT$9drop_slow17ha5b06fadef84789bE
	mov	x0, x19
Ltmp46:
LBB22_9:
	bl	__Unwind_Resume
LBB22_10:
Ltmp47:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
	.loh AdrpAdd	Lloh84, Lloh85
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table22:
Lexception3:
	.byte	255
	.byte	155
	.uleb128 Lttbase3-Lttbaseref3
Lttbaseref3:
	.byte	1
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Lfunc_begin3-Lfunc_begin3
	.uleb128 Ltmp40-Lfunc_begin3
	.byte	0
	.byte	0
	.uleb128 Ltmp40-Lfunc_begin3
	.uleb128 Ltmp41-Ltmp40
	.uleb128 Ltmp44-Lfunc_begin3
	.byte	0
	.uleb128 Ltmp41-Lfunc_begin3
	.uleb128 Ltmp42-Ltmp41
	.byte	0
	.byte	0
	.uleb128 Ltmp42-Lfunc_begin3
	.uleb128 Ltmp43-Ltmp42
	.uleb128 Ltmp44-Lfunc_begin3
	.byte	0
	.uleb128 Ltmp45-Lfunc_begin3
	.uleb128 Ltmp46-Ltmp45
	.uleb128 Ltmp47-Lfunc_begin3
	.byte	1
	.uleb128 Ltmp46-Lfunc_begin3
	.uleb128 Lfunc_end3-Ltmp46
	.byte	0
	.byte	0
Lcst_end3:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase3:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN17crossbeam_channel7context7Context4with28_$u7b$$u7b$closure$u7d$$u7d$17h709951dce743bf44E:
Lfunc_begin4:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception4
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x20, x19, [sp, #32]
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_remember_state
	mov	x20, x0
	bl	__ZN17crossbeam_channel7context7Context3new17hb6c2eee222ec953aE
	mov	x19, x0
	str	x0, [sp]
	ldr	x8, [x20]
	str	xzr, [x20]
	cbz	x8, LBB23_5
	str	x8, [sp, #8]
	ldur	q0, [x20, #8]
	stur	q0, [sp, #16]
Ltmp48:
	add	x0, sp, #8
	mov	x1, sp
	bl	__ZN17crossbeam_channel6select9run_ready28_$u7b$$u7b$closure$u7d$$u7d$17h7a9d02fc5072c368E
Ltmp49:
	mov	x8, #-1
	ldaddl	x8, x8, [x19]
	cmp	x8, #1
	b.ne	LBB23_4
	dmb	ishld
	mov	x19, x0
	mov	x0, sp
	mov	x20, x1
	bl	__ZN5alloc4sync16Arc$LT$T$C$A$GT$9drop_slow17ha5b06fadef84789bE
	mov	x1, x20
	mov	x0, x19
LBB23_4:
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	ldp	x20, x19, [sp, #32]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	ret
LBB23_5:
	.cfi_restore_state
Ltmp50:
Lloh86:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.23@PAGE
Lloh87:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.23@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core6option13unwrap_failed
Ltmp51:
	brk	#0x1
LBB23_7:
Ltmp52:
	mov	x8, #-1
	ldaddl	x8, x8, [x19]
	cmp	x8, #1
	b.ne	LBB23_9
	dmb	ishld
Ltmp53:
	mov	x19, x0
	mov	x0, sp
	bl	__ZN5alloc4sync16Arc$LT$T$C$A$GT$9drop_slow17ha5b06fadef84789bE
	mov	x0, x19
Ltmp54:
LBB23_9:
	bl	__Unwind_Resume
LBB23_10:
Ltmp55:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
	.loh AdrpAdd	Lloh86, Lloh87
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table23:
Lexception4:
	.byte	255
	.byte	155
	.uleb128 Lttbase4-Lttbaseref4
Lttbaseref4:
	.byte	1
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Lfunc_begin4-Lfunc_begin4
	.uleb128 Ltmp48-Lfunc_begin4
	.byte	0
	.byte	0
	.uleb128 Ltmp48-Lfunc_begin4
	.uleb128 Ltmp49-Ltmp48
	.uleb128 Ltmp52-Lfunc_begin4
	.byte	0
	.uleb128 Ltmp49-Lfunc_begin4
	.uleb128 Ltmp50-Ltmp49
	.byte	0
	.byte	0
	.uleb128 Ltmp50-Lfunc_begin4
	.uleb128 Ltmp51-Ltmp50
	.uleb128 Ltmp52-Lfunc_begin4
	.byte	0
	.uleb128 Ltmp53-Lfunc_begin4
	.uleb128 Ltmp54-Ltmp53
	.uleb128 Ltmp55-Lfunc_begin4
	.byte	1
	.uleb128 Ltmp54-Lfunc_begin4
	.uleb128 Lfunc_end4-Ltmp54
	.byte	0
	.byte	0
Lcst_end4:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase4:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN3std2io5Write9write_all17ha2f70c89c35d67daE:
	.cfi_startproc
	stp	x22, x21, [sp, #-48]!
	.cfi_def_cfa_offset 48
	stp	x20, x19, [sp, #16]
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_remember_state
	cbz	x2, LBB24_14
	mov	x19, x2
	mov	x20, x1
	mov	x21, x0
Lloh88:
	adrp	x22, l_anon.e689df370d6d8a85d4ce0ab270d18fef.26@PAGE
Lloh89:
	add	x22, x22, l_anon.e689df370d6d8a85d4ce0ab270d18fef.26@PAGEOFF
	b	LBB24_4
LBB24_2:
	cmp	x9, #35
	b.ne	LBB24_15
LBB24_3:
	mov	x0, x1
	bl	__ZN4core3ptr42drop_in_place$LT$std..io..error..Error$GT$17hf7487ff9e531341bE
	cbz	x19, LBB24_14
LBB24_4:
	mov	x0, x21
	mov	x1, x20
	mov	x2, x19
	bl	__RNvXs3_NtNtNtCsaLOjE9VYtxK_3std3sys5stdio4unixNtB5_6StderrNtNtBb_2io5Write5write
	tbz	w0, #0, LBB24_8
	and	x8, x1, #0x3
	cmp	x8, #1
	b.gt	LBB24_11
	cbnz	x8, LBB24_13
	ldrb	w8, [x1, #16]
	cmp	w8, #35
	b.eq	LBB24_3
	b	LBB24_15
LBB24_8:
	cbz	x1, LBB24_16
	subs	x8, x19, x1
	b.lo	LBB24_17
	add	x20, x20, x1
	mov	x19, x8
	cbnz	x8, LBB24_4
	b	LBB24_14
LBB24_11:
	lsr	x9, x1, #32
	cmp	x8, #2
	b.ne	LBB24_2
	cmp	x9, #4
	b.eq	LBB24_3
	b	LBB24_15
LBB24_13:
	ldrb	w8, [x1, #15]
	cmp	w8, #35
	b.eq	LBB24_3
	b	LBB24_15
LBB24_14:
	mov	x1, #0
LBB24_15:
	mov	x0, x1
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	ldp	x20, x19, [sp, #16]
	ldp	x22, x21, [sp], #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	ret
LBB24_16:
	.cfi_restore_state
	mov	x1, x22
	b	LBB24_15
LBB24_17:
Lloh90:
	adrp	x3, l_anon.e689df370d6d8a85d4ce0ab270d18fef.27@PAGE
Lloh91:
	add	x3, x3, l_anon.e689df370d6d8a85d4ce0ab270d18fef.27@PAGEOFF
	mov	x0, x1
	mov	x1, x19
	mov	x2, x19
	bl	__RNvNtNtCs6sq8b9ugfBC_4core5slice5index16slice_index_fail
	.loh AdrpAdd	Lloh88, Lloh89
	.loh AdrpAdd	Lloh90, Lloh91
	.cfi_endproc

	.p2align	2
__ZN3std2io5Write9write_fmt17h28650d57bb0859feE:
	.cfi_startproc
Lloh92:
	adrp	x1, l_anon.e689df370d6d8a85d4ce0ab270d18fef.0@PAGE
Lloh93:
	add	x1, x1, l_anon.e689df370d6d8a85d4ce0ab270d18fef.0@PAGEOFF
	mov	w2, #61
	b	__ZN3std2io5Write9write_all17ha2f70c89c35d67daE
	.loh AdrpAdd	Lloh92, Lloh93
	.cfi_endproc

	.p2align	2
__ZN3std3sys12thread_local6native4lazy20Storage$LT$T$C$D$GT$16get_or_init_slow17ha91bac1a167e65e7E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x20, x19, [sp, #16]
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_remember_state
	ldrb	w8, [x0, #8]
	cbz	w8, LBB26_2
	cmp	w8, #1
	csel	x0, x0, xzr, eq
	b	LBB26_7
LBB26_2:
	cbz	x1, LBB26_8
	ldp	x9, x8, [x1]
	str	xzr, [x1]
	cmp	x9, #1
	b.ne	LBB26_8
	str	x8, [x0]
	mov	w8, #1
	strb	w8, [x0, #8]
LBB26_5:
Lloh94:
	adrp	x1, __ZN3std3sys12thread_local6native4lazy7destroy17hf2834a24d29516c7E@PAGE
Lloh95:
	add	x1, x1, __ZN3std3sys12thread_local6native4lazy7destroy17hf2834a24d29516c7E@PAGEOFF
	mov	x19, x0
	bl	__RNvNtNtNtNtCsaLOjE9VYtxK_3std3sys12thread_local11destructors4list8register
LBB26_6:
	mov	x0, x19
LBB26_7:
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	ldp	x20, x19, [sp, #16]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	ret
LBB26_8:
	.cfi_restore_state
	mov	x19, x0
	bl	__ZN17crossbeam_channel7context7Context3new17hb6c2eee222ec953aE
	ldrb	w10, [x19, #8]
	ldr	x9, [x19]
	str	x9, [sp, #8]
	str	x0, [x19]
	mov	w8, #1
	strb	w8, [x19, #8]
	cmp	w10, #1
	b.ne	LBB26_12
	mov	x0, x19
	cbz	x9, LBB26_7
	mov	x8, #-1
	ldaddl	x8, x8, [x9]
	cmp	x8, #1
	b.ne	LBB26_7
	dmb	ishld
	add	x0, sp, #8
	bl	__ZN5alloc4sync16Arc$LT$T$C$A$GT$9drop_slow17ha5b06fadef84789bE
	b	LBB26_6
LBB26_12:
	cmp	w10, #2
	b.ne	LBB26_14
Lloh96:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.3@PAGE
Lloh97:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.3@PAGEOFF
Lloh98:
	adrp	x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.29@PAGE
Lloh99:
	add	x2, x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.29@PAGEOFF
	mov	w1, #40
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking5panic
LBB26_14:
	mov	x0, x19
	b	LBB26_5
	.loh AdrpAdd	Lloh94, Lloh95
	.loh AdrpAdd	Lloh98, Lloh99
	.loh AdrpAdd	Lloh96, Lloh97
	.cfi_endproc

	.p2align	2
__ZN3std3sys12thread_local6native4lazy7destroy17hf2834a24d29516c7E:
Lfunc_begin5:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception5
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	ldrb	w8, [x0, #8]
	mov	w9, #2
	strb	w9, [x0, #8]
	cmp	w8, #1
	b.ne	LBB27_4
	ldr	x8, [x0]
	cbz	x8, LBB27_4
	mov	x9, #-1
	ldaddl	x9, x8, [x8]
	cmp	x8, #1
	b.ne	LBB27_4
	dmb	ishld
Ltmp56:
	bl	__ZN5alloc4sync16Arc$LT$T$C$A$GT$9drop_slow17ha5b06fadef84789bE
Ltmp57:
LBB27_4:
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB27_5:
	.cfi_restore_state
Ltmp58:
Ltmp59:
	bl	__RNvXNvNtNtCsaLOjE9VYtxK_3std3sys12thread_local20abort_on_dtor_unwindNtB2_15DtorUnwindGuardNtNtNtCs6sq8b9ugfBC_4core3ops4drop4Drop4drop
Ltmp60:
	brk	#0x1
LBB27_7:
Ltmp61:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
Lfunc_end5:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table27:
Lexception5:
	.byte	255
	.byte	155
	.uleb128 Lttbase5-Lttbaseref5
Lttbaseref5:
	.byte	1
	.uleb128 Lcst_end5-Lcst_begin5
Lcst_begin5:
	.uleb128 Ltmp56-Lfunc_begin5
	.uleb128 Ltmp57-Ltmp56
	.uleb128 Ltmp58-Lfunc_begin5
	.byte	1
	.uleb128 Ltmp59-Lfunc_begin5
	.uleb128 Ltmp60-Ltmp59
	.uleb128 Ltmp61-Lfunc_begin5
	.byte	1
Lcst_end5:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase5:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17hadad7b3385d0f196E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x1
	ldr	x9, [x0]
	str	x9, [sp, #8]
Lloh100:
	adrp	x1, l_anon.e689df370d6d8a85d4ce0ab270d18fef.38@PAGE
Lloh101:
	add	x1, x1, l_anon.e689df370d6d8a85d4ce0ab270d18fef.38@PAGEOFF
Lloh102:
	adrp	x4, l_anon.e689df370d6d8a85d4ce0ab270d18fef.39@PAGE
Lloh103:
	add	x4, x4, l_anon.e689df370d6d8a85d4ce0ab270d18fef.39@PAGEOFF
	add	x3, sp, #8
	mov	x0, x8
	mov	w2, #9
	bl	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter25debug_tuple_field1_finish
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.loh AdrpAdd	Lloh102, Lloh103
	.loh AdrpAdd	Lloh100, Lloh101
	.cfi_endproc

	.p2align	2
__ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17hcdf600548441f423E:
	.cfi_startproc
	ldr	x0, [x0]
	ldr	w8, [x1, #16]
	tbnz	w8, #25, LBB29_3
	tbnz	w8, #26, LBB29_4
	b	__RNvXsi_NtNtNtCs6sq8b9ugfBC_4core3fmt3num3impjNtB9_7Display3fmt
LBB29_3:
	b	__RNvXs6_NtNtCs6sq8b9ugfBC_4core3fmt3numjNtB7_8LowerHex3fmt
LBB29_4:
	b	__RNvXs8_NtNtCs6sq8b9ugfBC_4core3fmt3numjNtB7_8UpperHex3fmt
	.cfi_endproc

	.p2align	2
__ZN4core3ptr42drop_in_place$LT$std..io..error..Error$GT$17hf7487ff9e531341bE:
Lfunc_begin6:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception6
	stp	x22, x21, [sp, #-48]!
	.cfi_def_cfa_offset 48
	stp	x20, x19, [sp, #16]
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_remember_state
	and	x8, x0, #0x3
	sub	x9, x8, #2
	cmp	x9, #2
	ccmp	x8, #0, #4, hs
	b.ne	LBB30_2
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	ldp	x20, x19, [sp, #16]
	ldp	x22, x21, [sp], #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	ret
LBB30_2:
	.cfi_restore_state
	.cfi_remember_state
	mov	x19, x0
	ldr	x20, [x19, #-1]!
	ldr	x21, [x19, #8]
	ldr	x8, [x21]
	cbz	x8, LBB30_4
Ltmp62:
	mov	x0, x20
	blr	x8
Ltmp63:
LBB30_4:
	ldr	x1, [x21, #8]
	cbz	x1, LBB30_6
	ldr	x2, [x21, #16]
	mov	x0, x20
	bl	__RNvCsGIExRX8pES_7___rustc14___rust_dealloc
LBB30_6:
	mov	x0, x19
	mov	w1, #24
	mov	w2, #8
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	ldp	x20, x19, [sp, #16]
	ldp	x22, x21, [sp], #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	b	__RNvCsGIExRX8pES_7___rustc14___rust_dealloc
LBB30_7:
	.cfi_restore_state
Ltmp64:
	mov	x9, x21
	mov	x21, x0
	ldr	x1, [x9, #8]
	cbz	x1, LBB30_9
	ldr	x2, [x9, #16]
	mov	x0, x20
	bl	__RNvCsGIExRX8pES_7___rustc14___rust_dealloc
LBB30_9:
	mov	x0, x19
	mov	w1, #24
	mov	w2, #8
	bl	__RNvCsGIExRX8pES_7___rustc14___rust_dealloc
	mov	x0, x21
	bl	__Unwind_Resume
Lfunc_end6:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table30:
Lexception6:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end6-Lcst_begin6
Lcst_begin6:
	.uleb128 Ltmp62-Lfunc_begin6
	.uleb128 Ltmp63-Ltmp62
	.uleb128 Ltmp64-Lfunc_begin6
	.byte	0
	.uleb128 Ltmp63-Lfunc_begin6
	.uleb128 Lfunc_end6-Ltmp63
	.byte	0
	.byte	0
Lcst_end6:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core3ptr81drop_in_place$LT$core..result..Result$LT$$LP$$RP$$C$std..io..error..Error$GT$$GT$17h0c60abd63fbbdbcaE:
	.cfi_startproc
	cbz	x0, LBB31_2
	b	__ZN4core3ptr42drop_in_place$LT$std..io..error..Error$GT$17hf7487ff9e531341bE
LBB31_2:
	ret
	.cfi_endproc

	.globl	__ZN5alloc4sync16Arc$LT$T$C$A$GT$9drop_slow17ha5b06fadef84789bE
	.p2align	2
__ZN5alloc4sync16Arc$LT$T$C$A$GT$9drop_slow17ha5b06fadef84789bE:
Lfunc_begin7:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception7
	stp	x20, x19, [sp, #-32]!
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_remember_state
	ldr	x19, [x0]
	mov	x0, x19
	ldr	x8, [x0, #16]!
	mov	x9, #-1
	ldaddl	x9, x8, [x8]
	cmp	x8, #1
	b.ne	LBB32_2
	dmb	ishld
Ltmp65:
	bl	__RNvMsn_NtCs8dnTdrJsiec_5alloc4syncINtB5_3ArcNtNtNtCsaLOjE9VYtxK_3std6thread6thread5InnerNtNtBM_5alloc6SystemE9drop_slowBM_
Ltmp66:
LBB32_2:
	cmn	x19, #1
	b.eq	LBB32_5
	add	x8, x19, #8
	mov	x9, #-1
	ldaddl	x9, x8, [x8]
	cmp	x8, #1
	b.ne	LBB32_5
	dmb	ishld
	mov	x0, x19
	mov	w1, #48
	mov	w2, #8
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	ldp	x20, x19, [sp], #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	b	__RNvCsGIExRX8pES_7___rustc14___rust_dealloc
LBB32_5:
	.cfi_restore_state
	.cfi_remember_state
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	ldp	x20, x19, [sp], #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	ret
LBB32_6:
	.cfi_restore_state
Ltmp67:
	mov	x20, x0
	cmn	x19, #1
	b.eq	LBB32_9
	add	x8, x19, #8
	mov	x9, #-1
	ldaddl	x9, x8, [x8]
	cmp	x8, #1
	b.ne	LBB32_9
	dmb	ishld
	mov	x0, x19
	mov	w1, #48
	mov	w2, #8
	bl	__RNvCsGIExRX8pES_7___rustc14___rust_dealloc
LBB32_9:
	mov	x0, x20
	bl	__Unwind_Resume
Lfunc_end7:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table32:
Lexception7:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end7-Lcst_begin7
Lcst_begin7:
	.uleb128 Ltmp65-Lfunc_begin7
	.uleb128 Ltmp66-Ltmp65
	.uleb128 Ltmp67-Lfunc_begin7
	.byte	0
	.uleb128 Ltmp66-Lfunc_begin7
	.uleb128 Lfunc_end7-Ltmp66
	.byte	0
	.byte	0
Lcst_end7:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN70_$LT$crossbeam_channel..select..Select$u20$as$u20$core..fmt..Debug$GT$3fmt17hcbe01586c642a7b6E
	.p2align	2
__ZN70_$LT$crossbeam_channel..select..Select$u20$as$u20$core..fmt..Debug$GT$3fmt17hcbe01586c642a7b6E:
	.cfi_startproc
	mov	x0, x1
Lloh104:
	adrp	x1, l_anon.e689df370d6d8a85d4ce0ab270d18fef.32@PAGE
Lloh105:
	add	x1, x1, l_anon.e689df370d6d8a85d4ce0ab270d18fef.32@PAGEOFF
	mov	w2, #13
	b	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter3pad
	.loh AdrpAdd	Lloh104, Lloh105
	.cfi_endproc

	.globl	__ZN72_$LT$crossbeam_channel..err..RecvError$u20$as$u20$core..fmt..Display$GT$3fmt17h039460101dee43c6E
	.p2align	2
__ZN72_$LT$crossbeam_channel..err..RecvError$u20$as$u20$core..fmt..Display$GT$3fmt17h039460101dee43c6E:
	.cfi_startproc
	mov	x2, x1
Lloh106:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.33@PAGE
Lloh107:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.33@PAGEOFF
	mov	w1, #46
	b	__RNvXsi_NtCs6sq8b9ugfBC_4core3fmteNtB5_7Display3fmt
	.loh AdrpAdd	Lloh106, Lloh107
	.cfi_endproc

	.globl	__ZN72_$LT$crossbeam_channel..select..Select$u20$as$u20$core..clone..Clone$GT$5clone17h258861625440557aE
	.p2align	2
__ZN72_$LT$crossbeam_channel..select..Select$u20$as$u20$core..clone..Clone$GT$5clone17h258861625440557aE:
	.cfi_startproc
	stp	x24, x23, [sp, #-64]!
	.cfi_def_cfa_offset 64
	stp	x22, x21, [sp, #16]
	stp	x20, x19, [sp, #32]
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_remember_state
	mov	x20, x0
	mov	x19, x8
	ldr	x24, [x0, #16]
	cbz	x24, LBB35_3
	ldr	x23, [x20, #8]
	lsl	x21, x24, #5
	bl	__RNvCsGIExRX8pES_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	x0, x21
	mov	w1, #8
	bl	__RNvCsGIExRX8pES_7___rustc12___rust_alloc
	cbz	x0, LBB35_5
	mov	x22, x0
	mov	x1, x23
	mov	x2, x21
	bl	_memcpy
	b	LBB35_4
LBB35_3:
	mov	w22, #8
LBB35_4:
	ldr	x8, [x20, #24]
	ldrb	w9, [x20, #32]
	stp	x24, x22, [x19]
	stp	x24, x8, [x19, #16]
	strb	w9, [x19, #32]
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	ldp	x20, x19, [sp, #32]
	ldp	x22, x21, [sp, #16]
	ldp	x24, x23, [sp], #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	.cfi_restore w23
	.cfi_restore w24
	ret
LBB35_5:
	.cfi_restore_state
	mov	w0, #8
	mov	x1, x21
	bl	__RNvNtCs8dnTdrJsiec_5alloc7raw_vec12handle_error
	.cfi_endproc

	.p2align	2
__ZN72_$LT$crossbeam_channel..select..Selected$u20$as$u20$core..fmt..Debug$GT$3fmt17h66d7c128513b85ddE:
	.cfi_startproc
	mov	x8, x1
	ldr	x9, [x0]
	cmp	x9, #1
	b.gt	LBB36_3
	cbnz	x9, LBB36_5
Lloh108:
	adrp	x1, l_anon.e689df370d6d8a85d4ce0ab270d18fef.34@PAGE
Lloh109:
	add	x1, x1, l_anon.e689df370d6d8a85d4ce0ab270d18fef.34@PAGEOFF
	mov	x0, x8
	mov	w2, #7
	b	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter9write_str
LBB36_3:
	cmp	x9, #2
	b.ne	LBB36_6
Lloh110:
	adrp	x1, l_anon.e689df370d6d8a85d4ce0ab270d18fef.36@PAGE
Lloh111:
	add	x1, x1, l_anon.e689df370d6d8a85d4ce0ab270d18fef.36@PAGEOFF
	mov	x0, x8
	mov	w2, #12
	b	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter9write_str
LBB36_5:
Lloh112:
	adrp	x1, l_anon.e689df370d6d8a85d4ce0ab270d18fef.35@PAGE
Lloh113:
	add	x1, x1, l_anon.e689df370d6d8a85d4ce0ab270d18fef.35@PAGEOFF
	mov	x0, x8
	mov	w2, #7
	b	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter9write_str
LBB36_6:
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	add	x9, x0, #8
	str	x9, [sp, #8]
Lloh114:
	adrp	x1, l_anon.e689df370d6d8a85d4ce0ab270d18fef.38@PAGE
Lloh115:
	add	x1, x1, l_anon.e689df370d6d8a85d4ce0ab270d18fef.38@PAGEOFF
Lloh116:
	adrp	x4, l_anon.e689df370d6d8a85d4ce0ab270d18fef.37@PAGE
Lloh117:
	add	x4, x4, l_anon.e689df370d6d8a85d4ce0ab270d18fef.37@PAGEOFF
	add	x3, sp, #8
	mov	x0, x8
	mov	w2, #9
	bl	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter25debug_tuple_field1_finish
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.loh AdrpAdd	Lloh108, Lloh109
	.loh AdrpAdd	Lloh110, Lloh111
	.loh AdrpAdd	Lloh112, Lloh113
	.loh AdrpAdd	Lloh116, Lloh117
	.loh AdrpAdd	Lloh114, Lloh115
	.cfi_endproc

	.globl	__ZN75_$LT$crossbeam_channel..err..TryRecvError$u20$as$u20$core..fmt..Display$GT$3fmt17hdd0671242eabec39E
	.p2align	2
__ZN75_$LT$crossbeam_channel..err..TryRecvError$u20$as$u20$core..fmt..Display$GT$3fmt17hdd0671242eabec39E:
	.cfi_startproc
	mov	x2, x1
	ldrb	w8, [x0]
	cmp	w8, #1
	b.ne	LBB37_2
Lloh118:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.33@PAGE
Lloh119:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.33@PAGEOFF
	mov	w1, #46
	b	__RNvXsi_NtCs6sq8b9ugfBC_4core3fmteNtB5_7Display3fmt
LBB37_2:
Lloh120:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.40@PAGE
Lloh121:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.40@PAGEOFF
	mov	w1, #29
	b	__RNvXsi_NtCs6sq8b9ugfBC_4core3fmteNtB5_7Display3fmt
	.loh AdrpAdd	Lloh118, Lloh119
	.loh AdrpAdd	Lloh120, Lloh121
	.cfi_endproc

	.globl	__ZN76_$LT$crossbeam_channel..select..Select$u20$as$u20$core..default..Default$GT$7default17h0a0308042cf34a7bE
	.p2align	2
__ZN76_$LT$crossbeam_channel..select..Select$u20$as$u20$core..default..Default$GT$7default17h0a0308042cf34a7bE:
	.cfi_startproc
	stp	x20, x19, [sp, #-32]!
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_remember_state
	mov	x19, x8
	bl	__RNvCsGIExRX8pES_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w0, #128
	mov	w1, #8
	bl	__RNvCsGIExRX8pES_7___rustc12___rust_alloc
	cbz	x0, LBB38_2
	mov	w8, #4
	stp	x8, x0, [x19]
	stp	xzr, xzr, [x19, #16]
	strb	wzr, [x19, #32]
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	ldp	x20, x19, [sp], #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	ret
LBB38_2:
	.cfi_restore_state
	mov	w0, #8
	mov	w1, #128
	bl	__RNvNtCs8dnTdrJsiec_5alloc7raw_vec12handle_error
	.cfi_endproc

	.globl	__ZN77_$LT$crossbeam_channel..err..TrySelectError$u20$as$u20$core..fmt..Display$GT$3fmt17hb0a26c47f4d782d9E
	.p2align	2
__ZN77_$LT$crossbeam_channel..err..TrySelectError$u20$as$u20$core..fmt..Display$GT$3fmt17hb0a26c47f4d782d9E:
	.cfi_startproc
	mov	x2, x1
Lloh122:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.41@PAGE
Lloh123:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.41@PAGEOFF
	mov	w1, #36
	b	__RNvXsi_NtCs6sq8b9ugfBC_4core3fmteNtB5_7Display3fmt
	.loh AdrpAdd	Lloh122, Lloh123
	.cfi_endproc

	.globl	__ZN79_$LT$crossbeam_channel..err..RecvTimeoutError$u20$as$u20$core..fmt..Display$GT$3fmt17hec6776fe4087dfa2E
	.p2align	2
__ZN79_$LT$crossbeam_channel..err..RecvTimeoutError$u20$as$u20$core..fmt..Display$GT$3fmt17hec6776fe4087dfa2E:
	.cfi_startproc
	mov	x2, x1
	ldrb	w8, [x0]
	cmp	w8, #1
	b.ne	LBB40_2
Lloh124:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.43@PAGE
Lloh125:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.43@PAGEOFF
	mov	w1, #33
	b	__RNvXsi_NtCs6sq8b9ugfBC_4core3fmteNtB5_7Display3fmt
LBB40_2:
Lloh126:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.42@PAGE
Lloh127:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.42@PAGEOFF
	mov	w1, #38
	b	__RNvXsi_NtCs6sq8b9ugfBC_4core3fmteNtB5_7Display3fmt
	.loh AdrpAdd	Lloh124, Lloh125
	.loh AdrpAdd	Lloh126, Lloh127
	.cfi_endproc

	.globl	__ZN80_$LT$crossbeam_channel..flavors..zero..ZeroToken$u20$as$u20$core..fmt..Debug$GT$3fmt17h4780cff18c1ea5beE
	.p2align	2
__ZN80_$LT$crossbeam_channel..flavors..zero..ZeroToken$u20$as$u20$core..fmt..Debug$GT$3fmt17h4780cff18c1ea5beE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x8, [x0]
	str	x8, [sp, #8]
	ldr	w8, [x1, #16]
	tbnz	w8, #25, LBB41_3
	add	x0, sp, #8
	tbnz	w8, #26, LBB41_4
	bl	__RNvXsi_NtNtNtCs6sq8b9ugfBC_4core3fmt3num3impjNtB9_7Display3fmt
	b	LBB41_5
LBB41_3:
	add	x0, sp, #8
	bl	__RNvXs6_NtNtCs6sq8b9ugfBC_4core3fmt3numjNtB7_8LowerHex3fmt
	b	LBB41_5
LBB41_4:
	bl	__RNvXs8_NtNtCs6sq8b9ugfBC_4core3fmt3numjNtB7_8UpperHex3fmt
LBB41_5:
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN81_$LT$crossbeam_channel..err..SelectTimeoutError$u20$as$u20$core..fmt..Display$GT$3fmt17hc99eb6f998736fb4E
	.p2align	2
__ZN81_$LT$crossbeam_channel..err..SelectTimeoutError$u20$as$u20$core..fmt..Display$GT$3fmt17hc99eb6f998736fb4E:
	.cfi_startproc
	mov	x2, x1
Lloh128:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.44@PAGE
Lloh129:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.44@PAGEOFF
	mov	w1, #27
	b	__RNvXsi_NtCs6sq8b9ugfBC_4core3fmteNtB5_7Display3fmt
	.loh AdrpAdd	Lloh128, Lloh129
	.cfi_endproc

	.globl	__ZN81_$LT$crossbeam_channel..select..SelectedOperation$u20$as$u20$core..fmt..Debug$GT$3fmt17h065b32ef859acc29E
	.p2align	2
__ZN81_$LT$crossbeam_channel..select..SelectedOperation$u20$as$u20$core..fmt..Debug$GT$3fmt17h065b32ef859acc29E:
	.cfi_startproc
	mov	x0, x1
Lloh130:
	adrp	x1, l_anon.e689df370d6d8a85d4ce0ab270d18fef.45@PAGE
Lloh131:
	add	x1, x1, l_anon.e689df370d6d8a85d4ce0ab270d18fef.45@PAGEOFF
	mov	w2, #24
	b	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter3pad
	.loh AdrpAdd	Lloh130, Lloh131
	.cfi_endproc

	.globl	__ZN86_$LT$crossbeam_channel..select..SelectedOperation$u20$as$u20$core..ops..drop..Drop$GT$4drop17hb8fef155862e962aE
	.p2align	2
__ZN86_$LT$crossbeam_channel..select..SelectedOperation$u20$as$u20$core..ops..drop..Drop$GT$4drop17hb8fef155862e962aE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh132:
	adrp	x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.46@PAGE
Lloh133:
	add	x0, x0, l_anon.e689df370d6d8a85d4ce0ab270d18fef.46@PAGEOFF
Lloh134:
	adrp	x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.47@PAGE
Lloh135:
	add	x2, x2, l_anon.e689df370d6d8a85d4ce0ab270d18fef.47@PAGEOFF
	mov	w1, #121
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking9panic_fmt
	.loh AdrpAdd	Lloh134, Lloh135
	.loh AdrpAdd	Lloh132, Lloh133
	.cfi_endproc

	.section	__TEXT,__const
l_anon.e689df370d6d8a85d4ce0ab270d18fef.0:
	.ascii	"fatal runtime error: thread local panicked on drop, aborting\n"

	.section	__TEXT,__cstring,cstring_literals
l_anon.e689df370d6d8a85d4ce0ab270d18fef.1:
	.asciz	"/Users/kuangtalin/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/crossbeam-channel-0.5.15/src/utils.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.2:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.1
	.asciz	"l\000\000\000\000\000\000\000'\000\000\000\017\000\000"

	.section	__DATA,__thread_data,thread_local_regular
	.p2align	2, 0x0
__ZN17crossbeam_channel5utils7shuffle3RNG29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17h453156475df5204bE$tlv$init:
	.ascii	"\247\034\333S"

	.section	__DATA,__thread_vars,thread_local_variables
__ZN17crossbeam_channel5utils7shuffle3RNG29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17h453156475df5204bE:
	.quad	__tlv_bootstrap
	.quad	0
	.quad	__ZN17crossbeam_channel5utils7shuffle3RNG29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17h453156475df5204bE$tlv$init

.tbss __ZN17crossbeam_channel5waker17current_thread_id9THREAD_ID29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17h947e4dc207c110ffE$tlv$init, 16, 3

	.globl	__ZN17crossbeam_channel5waker17current_thread_id9THREAD_ID29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17h947e4dc207c110ffE
__ZN17crossbeam_channel5waker17current_thread_id9THREAD_ID29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17h947e4dc207c110ffE:
	.quad	__tlv_bootstrap
	.quad	0
	.quad	__ZN17crossbeam_channel5waker17current_thread_id9THREAD_ID29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17h947e4dc207c110ffE$tlv$init

	.section	__TEXT,__const
l_anon.e689df370d6d8a85d4ce0ab270d18fef.3:
	.ascii	"internal error: entered unreachable code"

	.section	__TEXT,__cstring,cstring_literals
l_anon.e689df370d6d8a85d4ce0ab270d18fef.4:
	.asciz	"/Users/kuangtalin/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/crossbeam-channel-0.5.15/src/select.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.5:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.4
	.asciz	"m\000\000\000\000\000\000\000\274\000\000\000\021\000\000"

	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.6:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.4
	.asciz	"m\000\000\000\000\000\000\000\336\000\000\0002\000\000"

	.section	__TEXT,__const
l_anon.e689df370d6d8a85d4ce0ab270d18fef.7:
	.ascii	"assertion failed: val > 2"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.8:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.4
	.asciz	"m\000\000\000\000\000\000\0002\000\000\000\t\000\000"

	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.9:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.4
	.asciz	"m\000\000\000\000\000\000\000\021\001\000\000&\000\000"

	.section	__TEXT,__const
l_anon.e689df370d6d8a85d4ce0ab270d18fef.10:
	.ascii	"no operations have been added to `Select`"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.11:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.4
	.asciz	"m\000\000\000\000\000\000\000\020\004\000\000\r\000\000"

	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.12:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.4
	.asciz	"m\000\000\000\000\000\000\000\023\004\000\000C\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.e689df370d6d8a85d4ce0ab270d18fef.13:
	.asciz	"\025index out of bounds; \300\004 >= \300"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.14:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.4
	.asciz	"m\000\000\000\000\000\000\000\351\002\000\000\t\000\000"

	.section	__TEXT,__const
l_anon.e689df370d6d8a85d4ce0ab270d18fef.15:
	.ascii	"no operation with this index"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.16:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.4
	.asciz	"m\000\000\000\000\000\000\000\365\002\000\000\016\000\000"

	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.17:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.4
	.asciz	"m\000\000\000\000\000\000\000\340\001\000\000\t\000\000"

	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.18:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.4
	.asciz	"m\000\000\000\000\000\000\000\343\001\000\000N\000\000"

	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.19:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.4
	.asciz	"m\000\000\000\000\000\000\000S\001\000\000\021\000\000"

	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.20:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.4
	.asciz	"m\000\000\000\000\000\000\000\233\001\000\000%\000\000"

	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.21:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.4
	.asciz	"m\000\000\000\000\000\000\000\257\001\000\000&\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.e689df370d6d8a85d4ce0ab270d18fef.22:
	.asciz	"/Users/kuangtalin/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/crossbeam-channel-0.5.15/src/context.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.23:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.22
	.asciz	"n\000\000\000\000\000\000\0003\000\000\000\036\000\000"

.tbss __ZN17crossbeam_channel7context7Context4with7CONTEXT29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17hee7fab048a4b49b6E$tlv$init, 16, 3

	.section	__DATA,__thread_vars,thread_local_variables
	.globl	__ZN17crossbeam_channel7context7Context4with7CONTEXT29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17hee7fab048a4b49b6E
__ZN17crossbeam_channel7context7Context4with7CONTEXT29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17hee7fab048a4b49b6E:
	.quad	__tlv_bootstrap
	.quad	0
	.quad	__ZN17crossbeam_channel7context7Context4with7CONTEXT29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$23__RUST_STD_INTERNAL_VAL17hee7fab048a4b49b6E$tlv$init

	.section	__TEXT,__cstring,cstring_literals
l_anon.e689df370d6d8a85d4ce0ab270d18fef.24:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/io/mod.rs"

	.section	__TEXT,__const
l_anon.e689df370d6d8a85d4ce0ab270d18fef.25:
	.ascii	"failed to write whole buffer"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.26:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.25
	.ascii	"\034\000\000\000\000\000\000\000\027"
	.space	7

	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.27:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.24
	.asciz	"o\000\000\000\000\000\000\000G\007\000\000$\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.e689df370d6d8a85d4ce0ab270d18fef.28:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/sys/thread_local/native/lazy.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.29:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.28
	.asciz	"\205\000\000\000\000\000\000\000b\000\000\000$\000\000"

	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.30:
	.asciz	"\000\000\000\000\000\000\000\000\020\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	__ZN72_$LT$crossbeam_channel..select..Selected$u20$as$u20$core..fmt..Debug$GT$3fmt17h66d7c128513b85ddE

	.section	__TEXT,__const
l_anon.e689df370d6d8a85d4ce0ab270d18fef.31:
	.ascii	"called `Result::unwrap()` on an `Err` value"

l_anon.e689df370d6d8a85d4ce0ab270d18fef.32:
	.ascii	"Select { .. }"

l_anon.e689df370d6d8a85d4ce0ab270d18fef.33:
	.ascii	"receiving on an empty and disconnected channel"

l_anon.e689df370d6d8a85d4ce0ab270d18fef.34:
	.ascii	"Waiting"

l_anon.e689df370d6d8a85d4ce0ab270d18fef.35:
	.ascii	"Aborted"

l_anon.e689df370d6d8a85d4ce0ab270d18fef.36:
	.ascii	"Disconnected"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.37:
	.asciz	"\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	__ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17hadad7b3385d0f196E

	.section	__TEXT,__const
l_anon.e689df370d6d8a85d4ce0ab270d18fef.38:
	.ascii	"Operation"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.39:
	.asciz	"\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	__ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17hcdf600548441f423E

	.section	__TEXT,__const
l_anon.e689df370d6d8a85d4ce0ab270d18fef.40:
	.ascii	"receiving on an empty channel"

l_anon.e689df370d6d8a85d4ce0ab270d18fef.41:
	.ascii	"all operations in select would block"

l_anon.e689df370d6d8a85d4ce0ab270d18fef.42:
	.ascii	"timed out waiting on receive operation"

l_anon.e689df370d6d8a85d4ce0ab270d18fef.43:
	.ascii	"channel is empty and disconnected"

l_anon.e689df370d6d8a85d4ce0ab270d18fef.44:
	.ascii	"timed out waiting on select"

l_anon.e689df370d6d8a85d4ce0ab270d18fef.45:
	.ascii	"SelectedOperation { .. }"

l_anon.e689df370d6d8a85d4ce0ab270d18fef.46:
	.ascii	"dropped `SelectedOperation` without completing the operation"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.e689df370d6d8a85d4ce0ab270d18fef.47:
	.quad	l_anon.e689df370d6d8a85d4ce0ab270d18fef.4
	.asciz	"m\000\000\000\000\000\000\000\021\005\000\000\t\000\000"

.subsections_via_symbols
