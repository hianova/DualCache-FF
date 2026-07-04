	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN100_$LT$proc_macro..bridge..client..TokenStream$u20$as$u20$proc_macro..bridge..rpc..Decode$LT$S$GT$$GT$6decode17hb4ba7616641e16f0E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN99_$LT$core..num..nonzero..NonZero$LT$u32$GT$$u20$as$u20$proc_macro..bridge..rpc..Decode$LT$S$GT$$GT$6decode17h6ee6bf7871053fffE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN100_$LT$proc_macro..bridge..client..TokenStream$u20$as$u20$proc_macro..bridge..rpc..Encode$LT$S$GT$$GT$6encode17h796ee05f22ee177dE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	mov	x0, x1
	sub	x1, x29, #4
	stur	w8, [x29, #-4]
	bl	__ZN10proc_macro6bridge6buffer6Buffer17extend_from_array17hf09ae001b4b50e9eE
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN102_$LT$core..iter..adapters..map..Map$LT$I$C$F$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4fold17hd847641e9f0f225bE:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	ldr	q0, [x8]
	mov	x0, sp
	str	q0, [sp]
	ldr	q0, [x8, #16]
	str	q0, [sp, #16]
	bl	__ZN103_$LT$alloc..vec..into_iter..IntoIter$LT$T$C$A$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4fold17h3cd9aca7ceb9cadaE
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN102_$LT$core..iter..adapters..map..Map$LT$I$C$F$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h8a604b69993da85eE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN103_$LT$alloc..vec..into_iter..IntoIter$LT$T$C$A$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h454f66b504005706E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN103_$LT$alloc..vec..into_iter..IntoIter$LT$T$C$A$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4fold17h3cd9aca7ceb9cadaE:
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
	str	x0, [sp, #16]
	str	x1, [sp, #24]
	mov	w8, #1
	strb	w8, [sp, #39]
	strb	w8, [sp, #38]
	b	LBB4_1
LBB4_1:
	ldr	x8, [sp, #16]
	ldr	x9, [x8, #24]
	ldr	x8, [x8, #8]
	subs	x8, x8, x9
	b.ne	LBB4_3
	b	LBB4_2
LBB4_2:
	b	LBB4_4
LBB4_3:
	ldr	x9, [sp, #16]
	ldr	x8, [x9, #8]
	ldrb	w1, [x8]
	ldr	x8, [x9, #8]
	add	x8, x8, #1
	str	x8, [x9, #8]
	strb	wzr, [sp, #38]
Ltmp2:
	add	x0, sp, #24
	bl	__ZN4core4iter8adapters3map8map_fold28_$u7b$$u7b$closure$u7d$$u7d$17h0ad59799988b88cfE
Ltmp3:
	b	LBB4_11
LBB4_4:
	ldr	x8, [sp, #16]
	strb	wzr, [sp, #39]
	ldr	x9, [x8]
	str	x9, [sp]
	ldr	x8, [x8, #16]
	str	x8, [sp, #8]
	b	LBB4_5
LBB4_5:
	ldr	x8, [sp, #8]
	stur	x8, [x29, #-24]
	b	LBB4_6
LBB4_6:
	ldr	x8, [sp]
	ldur	x9, [x29, #-24]
	add	x0, sp, #40
	str	x9, [sp, #40]
	str	x8, [sp, #48]
Ltmp0:
	bl	__ZN4core3ptr53drop_in_place$LT$alloc..raw_vec..RawVec$LT$u8$GT$$GT$17h5f45389c4a49b664E
Ltmp1:
	b	LBB4_9
LBB4_7:
	b	LBB4_12
LBB4_8:
Ltmp4:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB4_7
LBB4_9:
	strb	wzr, [sp, #38]
	b	LBB4_10
LBB4_10:
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB4_11:
	.cfi_restore_state
	mov	w8, #1
	strb	w8, [sp, #38]
	b	LBB4_1
LBB4_12:
	ldrb	w8, [sp, #38]
	tbnz	w8, #0, LBB4_14
	b	LBB4_13
LBB4_13:
	ldrb	w8, [sp, #39]
	tbnz	w8, #0, LBB4_16
	b	LBB4_15
LBB4_14:
	b	LBB4_13
LBB4_15:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB4_16:
Ltmp5:
	ldr	x0, [sp, #16]
	bl	__ZN4core3ptr62drop_in_place$LT$alloc..vec..into_iter..IntoIter$LT$u8$GT$$GT$17h8c77e5da70aeae8dE
Ltmp6:
	b	LBB4_15
LBB4_17:
Ltmp7:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table4:
Lexception0:
	.byte	255
	.byte	155
	.uleb128 Lttbase0-Lttbaseref0
Lttbaseref0:
	.byte	1
	.uleb128 Lcst_end0-Lcst_begin0
Lcst_begin0:
	.uleb128 Ltmp2-Lfunc_begin0
	.uleb128 Ltmp1-Ltmp2
	.uleb128 Ltmp4-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp1-Lfunc_begin0
	.uleb128 Ltmp5-Ltmp1
	.byte	0
	.byte	0
	.uleb128 Ltmp5-Lfunc_begin0
	.uleb128 Ltmp6-Ltmp5
	.uleb128 Ltmp7-Lfunc_begin0
	.byte	1
Lcst_end0:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase0:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN103_$LT$alloc..vec..into_iter..IntoIter$LT$T$C$A$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h454f66b504005706E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	str	x8, [sp, #24]
	str	x0, [sp, #32]
	b	LBB5_1
LBB5_1:
	ldr	x8, [sp, #32]
	ldr	x9, [x8, #24]
	str	x9, [sp, #8]
	ldr	x8, [x8, #8]
	str	x8, [sp, #16]
	b	LBB5_2
LBB5_2:
	b	LBB5_3
LBB5_3:
	b	LBB5_4
LBB5_4:
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #16]
	subs	x8, x8, x9
	mov	w9, #1
	udiv	x8, x8, x9
	str	x8, [sp, #40]
	b	LBB5_5
LBB5_5:
	ldr	x9, [sp, #24]
	ldr	x10, [sp, #40]
	ldr	x8, [sp, #40]
	str	x10, [x9]
	mov	w10, #1
	str	x10, [x9, #8]
	str	x8, [x9, #16]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN104_$LT$core..iter..adapters..cloned..Cloned$LT$I$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4fold17h3d668a37bd2853a1E:
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception1
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x2, [sp]
	mov	w8, #1
	sturb	w8, [x29, #-17]
	sturb	w8, [x29, #-18]
Ltmp9:
	bl	__ZN4core4iter6traits8iterator8Iterator3map17h827a6eb9faef4655E
	str	x0, [sp, #8]
	str	x1, [sp, #16]
Ltmp10:
	b	LBB6_3
LBB6_1:
	ldurb	w8, [x29, #-18]
	tbnz	w8, #0, LBB6_6
	b	LBB6_5
LBB6_2:
Ltmp13:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB6_1
LBB6_3:
	ldr	x2, [sp]
	ldr	x1, [sp, #16]
	ldr	x0, [sp, #8]
	sturb	wzr, [x29, #-17]
	sturb	wzr, [x29, #-18]
Ltmp11:
	bl	__ZN91_$LT$core..slice..iter..Iter$LT$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4fold17h2291fdc9d893304bE
Ltmp12:
	b	LBB6_4
LBB6_4:
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB6_5:
	.cfi_restore_state
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB6_8
	b	LBB6_7
LBB6_6:
	b	LBB6_5
LBB6_7:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB6_8:
	b	LBB6_7
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table6:
Lexception1:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Ltmp9-Lfunc_begin1
	.uleb128 Ltmp12-Ltmp9
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
__ZN104_$LT$core..iter..adapters..cloned..Cloned$LT$I$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h2122470db3102a0bE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN91_$LT$core..slice..iter..Iter$LT$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h87677ec77a00cf16E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN104_$LT$proc_macro..bridge..ExpnGlobals$LT$Span$GT$$u20$as$u20$proc_macro..bridge..rpc..Decode$LT$S$GT$$GT$6decode17hab237885ced5cbd4E:
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
	str	x8, [sp, #16]
	str	x0, [sp, #32]
	str	x1, [sp, #24]
	bl	__ZN93_$LT$proc_macro..bridge..client..Span$u20$as$u20$proc_macro..bridge..rpc..Decode$LT$S$GT$$GT$6decode17hb5f51c845caf2461E
	ldr	x1, [sp, #24]
	mov	x8, x0
	ldr	x0, [sp, #32]
	stur	w8, [x29, #-24]
Ltmp14:
	bl	__ZN93_$LT$proc_macro..bridge..client..Span$u20$as$u20$proc_macro..bridge..rpc..Decode$LT$S$GT$$GT$6decode17hb5f51c845caf2461E
	stur	w0, [x29, #-20]
Ltmp15:
	b	LBB8_3
LBB8_1:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB8_2:
Ltmp16:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB8_1
LBB8_3:
Ltmp17:
	ldr	x1, [sp, #24]
	ldr	x0, [sp, #32]
	bl	__ZN93_$LT$proc_macro..bridge..client..Span$u20$as$u20$proc_macro..bridge..rpc..Decode$LT$S$GT$$GT$6decode17hb5f51c845caf2461E
	str	w0, [sp, #12]
Ltmp18:
	b	LBB8_6
LBB8_4:
	b	LBB8_1
LBB8_5:
Ltmp19:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB8_4
LBB8_6:
	ldr	w8, [sp, #12]
	ldr	x9, [sp, #16]
	ldur	w10, [x29, #-20]
	ldur	w11, [x29, #-24]
	str	w11, [x9]
	str	w10, [x9, #4]
	str	w8, [x9, #8]
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table8:
Lexception2:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Lfunc_begin2-Lfunc_begin2
	.uleb128 Ltmp14-Lfunc_begin2
	.byte	0
	.byte	0
	.uleb128 Ltmp14-Lfunc_begin2
	.uleb128 Ltmp15-Ltmp14
	.uleb128 Ltmp16-Lfunc_begin2
	.byte	0
	.uleb128 Ltmp15-Lfunc_begin2
	.uleb128 Ltmp17-Ltmp15
	.byte	0
	.byte	0
	.uleb128 Ltmp17-Lfunc_begin2
	.uleb128 Ltmp18-Ltmp17
	.uleb128 Ltmp19-Lfunc_begin2
	.byte	0
Lcst_end2:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN106_$LT$core..iter..adapters..chain..Chain$LT$A$C$B$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4fold17hd338b4e99b440b88E:
Lfunc_begin3:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception3
	sub	sp, sp, #112
	.cfi_def_cfa_offset 112
	stp	x29, x30, [sp, #96]
	add	x29, sp, #96
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp]
	str	x1, [sp, #8]
	mov	w8, #1
	sturb	w8, [x29, #-17]
	sturb	w8, [x29, #-18]
	ldrb	w8, [x0, #16]
	subs	w8, w8, #8
	cset	x8, ne
	tbz	w8, #0, LBB9_2
	b	LBB9_1
LBB9_1:
	ldr	x8, [sp]
	ldr	q0, [x8]
	add	x0, sp, #16
	str	q0, [sp, #16]
	ldr	w8, [x8, #16]
	str	w8, [sp, #32]
Ltmp20:
	add	x1, sp, #8
	bl	__ZN4core4iter6traits8iterator8Iterator4fold17h46e25aaf07c21ac0E
Ltmp21:
	b	LBB9_5
LBB9_2:
	ldr	x8, [sp]
	ldrb	w8, [x8, #36]
	subs	w8, w8, #8
	cset	x8, ne
	tbnz	w8, #0, LBB9_6
	b	LBB9_7
LBB9_3:
	ldurb	w8, [x29, #-18]
	tbnz	w8, #0, LBB9_11
	b	LBB9_10
LBB9_4:
Ltmp24:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB9_3
LBB9_5:
	b	LBB9_2
LBB9_6:
	ldr	x8, [sp]
	sturb	wzr, [x29, #-17]
	ldur	q0, [x8, #20]
	add	x0, sp, #48
	str	q0, [sp, #48]
	ldr	w8, [x8, #36]
	str	w8, [sp, #64]
	sturb	wzr, [x29, #-18]
	ldr	x1, [sp, #8]
Ltmp22:
	bl	__ZN4core4iter6traits8iterator8Iterator4fold17h0b479b74f9348112E
Ltmp23:
	b	LBB9_8
LBB9_7:
	b	LBB9_9
LBB9_8:
	b	LBB9_9
LBB9_9:
	.cfi_def_cfa wsp, 112
	ldp	x29, x30, [sp, #96]
	add	sp, sp, #112
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB9_10:
	.cfi_restore_state
	ldr	x8, [sp]
	ldrb	w8, [x8, #36]
	subs	w8, w8, #8
	cset	x8, ne
	subs	x8, x8, #1
	b.eq	LBB9_12
	b	LBB9_13
LBB9_11:
	b	LBB9_10
LBB9_12:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB9_14
	b	LBB9_13
LBB9_13:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB9_14:
	ldr	x8, [sp]
	add	x0, x8, #20
Ltmp25:
	bl	__ZN4core3ptr81drop_in_place$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$17hfb9b61ff9a9e03c9E
Ltmp26:
	b	LBB9_13
LBB9_15:
Ltmp27:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table9:
Lexception3:
	.byte	255
	.byte	155
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Ltmp20-Lfunc_begin3
	.uleb128 Ltmp23-Ltmp20
	.uleb128 Ltmp24-Lfunc_begin3
	.byte	0
	.uleb128 Ltmp23-Lfunc_begin3
	.uleb128 Ltmp25-Ltmp23
	.byte	0
	.byte	0
	.uleb128 Ltmp25-Lfunc_begin3
	.uleb128 Ltmp26-Ltmp25
	.uleb128 Ltmp27-Lfunc_begin3
	.byte	1
Lcst_end3:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase1:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN106_$LT$core..iter..adapters..chain..Chain$LT$A$C$B$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h232cd6a3faf0f7e0E:
	.cfi_startproc
	sub	sp, sp, #176
	.cfi_def_cfa_offset 176
	stp	x29, x30, [sp, #160]
	add	x29, sp, #160
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x8, [sp, #40]
	str	x0, [sp, #48]
	ldrb	w8, [x0, #16]
	subs	w8, w8, #8
	cset	x8, ne
	tbz	w8, #0, LBB10_2
	b	LBB10_1
LBB10_1:
	ldr	x8, [sp, #48]
	ldrb	w8, [x8, #36]
	subs	w8, w8, #8
	cset	x8, ne
	tbnz	w8, #0, LBB10_6
	b	LBB10_7
LBB10_2:
	ldr	x8, [sp, #48]
	ldrb	w8, [x8, #36]
	subs	w8, w8, #8
	cset	x8, ne
	tbz	w8, #0, LBB10_4
	b	LBB10_3
LBB10_3:
	ldr	x8, [sp, #40]
	ldr	x9, [sp, #48]
	add	x0, x9, #20
	bl	__ZN99_$LT$core..iter..sources..once..Once$LT$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h88c04323c843ceabE
	b	LBB10_5
LBB10_4:
	ldr	x9, [sp, #40]
	str	xzr, [x9]
	adrp	x10, l_anon.06e111bfef83652125d85ade023d82af.3@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.3@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.3@PAGEOFF
	ldr	x10, [x10, l_anon.06e111bfef83652125d85ade023d82af.3@PAGEOFF]
	ldr	x8, [x8, #8]
	str	x10, [x9, #8]
	str	x8, [x9, #16]
	b	LBB10_5
LBB10_5:
	.cfi_def_cfa wsp, 176
	ldp	x29, x30, [sp, #160]
	add	sp, sp, #176
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB10_6:
	.cfi_restore_state
	ldr	x0, [sp, #48]
	add	x8, x0, #20
	str	x8, [sp, #16]
	add	x8, sp, #72
	bl	__ZN99_$LT$core..iter..sources..once..Once$LT$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h88c04323c843ceabE
	ldr	x0, [sp, #16]
	ldr	x8, [sp, #72]
	str	x8, [sp, #24]
	ldr	x9, [sp, #80]
	ldr	x8, [sp, #88]
	str	x9, [sp, #56]
	str	x8, [sp, #64]
	sub	x8, x29, #48
	bl	__ZN99_$LT$core..iter..sources..once..Once$LT$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h88c04323c843ceabE
	ldr	x8, [sp, #24]
	ldur	x9, [x29, #-48]
	ldur	x11, [x29, #-40]
	ldur	x10, [x29, #-32]
	stur	x11, [x29, #-64]
	stur	x10, [x29, #-56]
	adds	x8, x8, x9
	cset	w9, hs
	ands	w9, w9, #0x1
	csinv	x8, x8, xzr, eq
	stur	x8, [x29, #-8]
	ldur	x8, [x29, #-8]
	str	x8, [sp, #32]
	ldr	x8, [sp, #56]
	tbnz	w8, #0, LBB10_8
	b	LBB10_9
LBB10_7:
	ldr	x0, [sp, #48]
	ldr	x8, [sp, #40]
	bl	__ZN99_$LT$core..iter..sources..once..Once$LT$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h88c04323c843ceabE
	b	LBB10_5
LBB10_8:
	ldur	x8, [x29, #-64]
	tbnz	w8, #0, LBB10_10
	b	LBB10_9
LBB10_9:
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x9, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x8, [x8, #8]
	stur	x9, [x29, #-24]
	stur	x8, [x29, #-16]
	b	LBB10_14
LBB10_10:
	ldr	x9, [sp, #64]
	str	x9, [sp]
	ldur	x8, [x29, #-56]
	str	x8, [sp, #8]
	add	x8, x9, x8
	subs	x8, x8, x9
	b.lo	LBB10_12
	b	LBB10_11
LBB10_11:
	ldr	x8, [sp]
	ldr	x9, [sp, #8]
	add	x8, x8, x9
	stur	x8, [x29, #-16]
	mov	w8, #1
	stur	x8, [x29, #-24]
	b	LBB10_13
LBB10_12:
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x9, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x8, [x8, #8]
	stur	x9, [x29, #-24]
	stur	x8, [x29, #-16]
	b	LBB10_13
LBB10_13:
	b	LBB10_14
LBB10_14:
	ldr	x9, [sp, #40]
	ldr	x8, [sp, #32]
	str	x8, [x9]
	ldur	x10, [x29, #-24]
	ldur	x8, [x29, #-16]
	str	x10, [x9, #8]
	str	x8, [x9, #16]
	b	LBB10_5
	.cfi_endproc

	.p2align	2
__ZN10proc_macro6bridge14selfless_reify31reify_to_extern_c_fn_hrt_bridge7wrapper17h65b93c569d4f8f1cE:
Lfunc_begin4:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception4
	sub	sp, sp, #224
	.cfi_def_cfa_offset 224
	stp	x29, x30, [sp, #208]
	add	x29, sp, #208
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	sub	x9, x29, #16
	str	x9, [sp, #24]
	str	x8, [sp, #32]
	str	x0, [sp, #40]
	mov	w8, #1
	sturb	w8, [x29, #-17]
Ltmp28:
	bl	__ZN4core3mem11conjure_zst17h0bba8e99caab4d49E
Ltmp29:
	b	LBB11_3
LBB11_1:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB11_6
	b	LBB11_5
LBB11_2:
Ltmp32:
	ldr	x9, [sp, #24]
	str	x0, [x9]
	mov	x8, x1
	str	w8, [x9, #8]
	b	LBB11_1
LBB11_3:
	ldr	x1, [sp, #40]
	sturb	wzr, [x29, #-17]
	sub	x0, x29, #88
	str	x0, [sp]
	mov	w8, #64
	mov	x2, x8
	str	x2, [sp, #8]
	bl	_memcpy
	ldr	x1, [sp]
	ldr	x2, [sp, #8]
	add	x0, sp, #56
	str	x0, [sp, #16]
	bl	_memcpy
	ldr	x8, [sp, #32]
	ldr	x1, [sp, #16]
Ltmp30:
	add	x0, sp, #55
	bl	__ZN10proc_macro6bridge6client63Client$LT$proc_macro..TokenStream$C$proc_macro..TokenStream$GT$7expand128_$u7b$$u7b$closure$u7d$$u7d$17hd69b0972b6f27494E
Ltmp31:
	b	LBB11_4
LBB11_4:
	.cfi_def_cfa wsp, 224
	ldp	x29, x30, [sp, #208]
	add	sp, sp, #224
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB11_5:
	.cfi_restore_state
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking19panic_cannot_unwind
LBB11_6:
Ltmp33:
	ldr	x0, [sp, #40]
	bl	__ZN4core3ptr53drop_in_place$LT$proc_macro..bridge..BridgeConfig$GT$17hd6b59ce4f6e1f1beE
Ltmp34:
	b	LBB11_5
LBB11_7:
Ltmp35:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table11:
Lexception4:
	.byte	255
	.byte	155
	.uleb128 Lttbase2-Lttbaseref2
Lttbaseref2:
	.byte	1
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Ltmp28-Lfunc_begin4
	.uleb128 Ltmp29-Ltmp28
	.uleb128 Ltmp32-Lfunc_begin4
	.byte	0
	.uleb128 Ltmp29-Lfunc_begin4
	.uleb128 Ltmp30-Ltmp29
	.byte	0
	.byte	0
	.uleb128 Ltmp30-Lfunc_begin4
	.uleb128 Ltmp31-Ltmp30
	.uleb128 Ltmp32-Lfunc_begin4
	.byte	0
	.uleb128 Ltmp33-Lfunc_begin4
	.uleb128 Ltmp34-Ltmp33
	.uleb128 Ltmp35-Lfunc_begin4
	.byte	1
Lcst_end4:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase2:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN10proc_macro6bridge1_100_$LT$impl$u20$proc_macro..bridge..rpc..Encode$LT$S$GT$$u20$for$u20$core..option..Option$LT$T$GT$$GT$6encode17h1a731864c068252bE:
Lfunc_begin5:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception5
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x1, [sp]
	str	x2, [sp, #8]
	str	w0, [sp, #20]
	ldr	w8, [sp, #20]
	subs	w8, w8, #0
	cset	x8, ne
	tbz	w8, #0, LBB12_2
	b	LBB12_1
LBB12_1:
	ldr	x0, [sp]
	mov	w8, #1
	sturb	w8, [x29, #-17]
	ldr	w8, [sp, #20]
	str	w8, [sp, #24]
Ltmp36:
	mov	w1, #0
	bl	__ZN10proc_macro6bridge6buffer6Buffer4push17h4a2472d9ab798a08E
Ltmp37:
	b	LBB12_6
LBB12_2:
	ldr	x0, [sp]
	mov	w1, #1
	bl	__ZN10proc_macro6bridge6buffer6Buffer4push17h4a2472d9ab798a08E
	b	LBB12_3
LBB12_3:
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB12_4:
	.cfi_restore_state
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB12_9
	b	LBB12_8
LBB12_5:
Ltmp40:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB12_4
LBB12_6:
	ldr	x2, [sp, #8]
	ldr	x1, [sp]
	sturb	wzr, [x29, #-17]
	ldr	w0, [sp, #24]
Ltmp38:
	bl	__ZN100_$LT$proc_macro..bridge..client..TokenStream$u20$as$u20$proc_macro..bridge..rpc..Encode$LT$S$GT$$GT$6encode17h796ee05f22ee177dE
Ltmp39:
	b	LBB12_7
LBB12_7:
	b	LBB12_3
LBB12_8:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB12_9:
Ltmp41:
	add	x0, sp, #24
	bl	__ZN4core3ptr60drop_in_place$LT$proc_macro..bridge..client..TokenStream$GT$17h8d3af34d91a55fb5E
Ltmp42:
	b	LBB12_8
LBB12_10:
Ltmp43:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
Lfunc_end5:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table12:
Lexception5:
	.byte	255
	.byte	155
	.uleb128 Lttbase3-Lttbaseref3
Lttbaseref3:
	.byte	1
	.uleb128 Lcst_end5-Lcst_begin5
Lcst_begin5:
	.uleb128 Ltmp36-Lfunc_begin5
	.uleb128 Ltmp37-Ltmp36
	.uleb128 Ltmp40-Lfunc_begin5
	.byte	0
	.uleb128 Ltmp37-Lfunc_begin5
	.uleb128 Ltmp38-Ltmp37
	.byte	0
	.byte	0
	.uleb128 Ltmp38-Lfunc_begin5
	.uleb128 Ltmp39-Ltmp38
	.uleb128 Ltmp40-Lfunc_begin5
	.byte	0
	.uleb128 Ltmp39-Lfunc_begin5
	.uleb128 Ltmp41-Ltmp39
	.byte	0
	.byte	0
	.uleb128 Ltmp41-Lfunc_begin5
	.uleb128 Ltmp42-Ltmp41
	.uleb128 Ltmp43-Lfunc_begin5
	.byte	1
Lcst_end5:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase3:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN10proc_macro6bridge1_100_$LT$impl$u20$proc_macro..bridge..rpc..Encode$LT$S$GT$$u20$for$u20$core..option..Option$LT$T$GT$$GT$6encode17h8e29e583bf7c5e08E:
Lfunc_begin6:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception6
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
	str	x0, [sp, #40]
	str	x1, [sp, #48]
	ldr	x8, [sp, #40]
	subs	x8, x8, #0
	cset	x8, ne
	tbz	w8, #0, LBB13_2
	b	LBB13_1
LBB13_1:
	ldr	x0, [sp, #24]
	mov	w8, #1
	sturb	w8, [x29, #-17]
	ldr	x8, [sp, #40]
	str	x8, [sp, #8]
	ldr	x8, [sp, #48]
	str	x8, [sp, #16]
Ltmp44:
	mov	w1, #0
	bl	__ZN10proc_macro6bridge6buffer6Buffer4push17h4a2472d9ab798a08E
Ltmp45:
	b	LBB13_6
LBB13_2:
	ldr	x0, [sp, #24]
	mov	w1, #1
	bl	__ZN10proc_macro6bridge6buffer6Buffer4push17h4a2472d9ab798a08E
	b	LBB13_3
LBB13_3:
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB13_4:
	.cfi_restore_state
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB13_9
	b	LBB13_8
LBB13_5:
Ltmp48:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB13_4
LBB13_6:
	ldr	x3, [sp, #32]
	ldr	x2, [sp, #24]
	ldr	x1, [sp, #16]
	ldr	x0, [sp, #8]
	sturb	wzr, [x29, #-17]
Ltmp46:
	bl	__ZN68_$LT$$RF$str$u20$as$u20$proc_macro..bridge..rpc..Encode$LT$S$GT$$GT$6encode17h449d61ce031fc279E
Ltmp47:
	b	LBB13_7
LBB13_7:
	b	LBB13_3
LBB13_8:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB13_9:
	b	LBB13_8
Lfunc_end6:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table13:
Lexception6:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end6-Lcst_begin6
Lcst_begin6:
	.uleb128 Ltmp44-Lfunc_begin6
	.uleb128 Ltmp45-Ltmp44
	.uleb128 Ltmp48-Lfunc_begin6
	.byte	0
	.uleb128 Ltmp45-Lfunc_begin6
	.uleb128 Ltmp46-Ltmp45
	.byte	0
	.byte	0
	.uleb128 Ltmp46-Lfunc_begin6
	.uleb128 Ltmp47-Ltmp46
	.uleb128 Ltmp48-Lfunc_begin6
	.byte	0
	.uleb128 Ltmp47-Lfunc_begin6
	.uleb128 Lfunc_end6-Ltmp47
	.byte	0
	.byte	0
Lcst_end6:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN10proc_macro6bridge1_104_$LT$impl$u20$proc_macro..bridge..rpc..Encode$LT$S$GT$$u20$for$u20$core..result..Result$LT$T$C$E$GT$$GT$6encode17hcde74dc2e74c6053E:
Lfunc_begin7:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception7
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x2, [sp]
	str	x3, [sp, #8]
	str	w0, [sp, #16]
	str	w1, [sp, #20]
	ldr	w8, [sp, #16]
	mov	x0, x8
	mov	x8, x0
	tbz	w8, #0, LBB14_2
	b	LBB14_1
LBB14_1:
	ldr	x0, [sp]
	mov	w8, #1
	sturb	w8, [x29, #-18]
Ltmp57:
	mov	w1, #1
	bl	__ZN10proc_macro6bridge6buffer6Buffer4push17h4a2472d9ab798a08E
Ltmp58:
	b	LBB14_13
LBB14_2:
	ldr	x0, [sp]
	mov	w8, #1
	sturb	w8, [x29, #-17]
	ldr	w8, [sp, #20]
	str	w8, [sp, #24]
Ltmp49:
	mov	w1, #0
	bl	__ZN10proc_macro6bridge6buffer6Buffer4push17h4a2472d9ab798a08E
Ltmp50:
	b	LBB14_5
LBB14_3:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB14_9
	b	LBB14_8
LBB14_4:
Ltmp53:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB14_3
LBB14_5:
	ldr	x2, [sp, #8]
	ldr	x1, [sp]
	sturb	wzr, [x29, #-17]
	ldr	w0, [sp, #24]
Ltmp51:
	bl	__ZN10proc_macro6bridge1_100_$LT$impl$u20$proc_macro..bridge..rpc..Encode$LT$S$GT$$u20$for$u20$core..option..Option$LT$T$GT$$GT$6encode17h1a731864c068252bE
Ltmp52:
	b	LBB14_6
LBB14_6:
	b	LBB14_7
LBB14_7:
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB14_8:
	.cfi_restore_state
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB14_9:
Ltmp54:
	add	x0, sp, #24
	bl	__ZN4core3ptr88drop_in_place$LT$core..option..Option$LT$proc_macro..bridge..client..TokenStream$GT$$GT$17h893a38e436fedee0E
Ltmp55:
	b	LBB14_8
LBB14_10:
Ltmp56:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB14_11:
	ldurb	w8, [x29, #-18]
	tbnz	w8, #0, LBB14_15
	b	LBB14_8
LBB14_12:
Ltmp61:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB14_11
LBB14_13:
	ldr	x1, [sp, #8]
	ldr	x0, [sp]
	sturb	wzr, [x29, #-18]
Ltmp59:
	bl	__ZN69_$LT$$LP$$RP$$u20$as$u20$proc_macro..bridge..rpc..Encode$LT$S$GT$$GT$6encode17hdfd673e96d623addE
Ltmp60:
	b	LBB14_14
LBB14_14:
	b	LBB14_7
LBB14_15:
	b	LBB14_8
Lfunc_end7:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table14:
Lexception7:
	.byte	255
	.byte	155
	.uleb128 Lttbase4-Lttbaseref4
Lttbaseref4:
	.byte	1
	.uleb128 Lcst_end7-Lcst_begin7
Lcst_begin7:
	.uleb128 Ltmp57-Lfunc_begin7
	.uleb128 Ltmp58-Ltmp57
	.uleb128 Ltmp61-Lfunc_begin7
	.byte	0
	.uleb128 Ltmp49-Lfunc_begin7
	.uleb128 Ltmp52-Ltmp49
	.uleb128 Ltmp53-Lfunc_begin7
	.byte	0
	.uleb128 Ltmp52-Lfunc_begin7
	.uleb128 Ltmp54-Ltmp52
	.byte	0
	.byte	0
	.uleb128 Ltmp54-Lfunc_begin7
	.uleb128 Ltmp55-Ltmp54
	.uleb128 Ltmp56-Lfunc_begin7
	.byte	1
	.uleb128 Ltmp59-Lfunc_begin7
	.uleb128 Ltmp60-Ltmp59
	.uleb128 Ltmp61-Lfunc_begin7
	.byte	0
Lcst_end7:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase4:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN10proc_macro6bridge1_104_$LT$impl$u20$proc_macro..bridge..rpc..Encode$LT$S$GT$$u20$for$u20$core..result..Result$LT$T$C$E$GT$$GT$6encode17hf845f529ac121720E:
Lfunc_begin8:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception8
	sub	sp, sp, #128
	.cfi_def_cfa_offset 128
	stp	x29, x30, [sp, #112]
	add	x29, sp, #112
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	str	x1, [sp, #16]
	str	x2, [sp, #24]
	ldr	x8, [x0]
	mov	x9, #-9223372036854775805
	subs	x8, x8, x9
	cset	x8, ne
	tbz	w8, #0, LBB15_2
	b	LBB15_1
LBB15_1:
	ldr	x0, [sp, #16]
	ldr	x8, [sp, #8]
	mov	w9, #1
	sturb	w9, [x29, #-18]
	ldr	q0, [x8]
	str	q0, [sp, #32]
	ldr	x8, [x8, #16]
	str	x8, [sp, #48]
Ltmp67:
	mov	w1, #1
	bl	__ZN10proc_macro6bridge6buffer6Buffer4push17h4a2472d9ab798a08E
Ltmp68:
	b	LBB15_12
LBB15_2:
	ldr	x0, [sp, #16]
	mov	w8, #1
	sturb	w8, [x29, #-17]
Ltmp62:
	mov	w1, #0
	bl	__ZN10proc_macro6bridge6buffer6Buffer4push17h4a2472d9ab798a08E
Ltmp63:
	b	LBB15_5
LBB15_3:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB15_9
	b	LBB15_8
LBB15_4:
Ltmp66:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB15_3
LBB15_5:
	ldr	x1, [sp, #24]
	ldr	x0, [sp, #16]
	sturb	wzr, [x29, #-17]
Ltmp64:
	bl	__ZN69_$LT$$LP$$RP$$u20$as$u20$proc_macro..bridge..rpc..Encode$LT$S$GT$$GT$6encode17hdfd673e96d623addE
Ltmp65:
	b	LBB15_6
LBB15_6:
	b	LBB15_7
LBB15_7:
	.cfi_def_cfa wsp, 128
	ldp	x29, x30, [sp, #112]
	add	sp, sp, #128
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB15_8:
	.cfi_restore_state
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB15_9:
	b	LBB15_8
LBB15_10:
	ldurb	w8, [x29, #-18]
	tbnz	w8, #0, LBB15_14
	b	LBB15_8
LBB15_11:
Ltmp71:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB15_10
LBB15_12:
	ldr	x2, [sp, #24]
	ldr	x1, [sp, #16]
	sturb	wzr, [x29, #-18]
	ldr	q0, [sp, #32]
	sub	x0, x29, #48
	stur	q0, [x29, #-48]
	ldr	x8, [sp, #48]
	stur	x8, [x29, #-32]
Ltmp69:
	bl	__ZN98_$LT$proc_macro..bridge..rpc..PanicMessage$u20$as$u20$proc_macro..bridge..rpc..Encode$LT$S$GT$$GT$6encode17hf51ef868ebc1a1dbE
Ltmp70:
	b	LBB15_13
LBB15_13:
	b	LBB15_7
LBB15_14:
Ltmp72:
	add	x0, sp, #32
	bl	__ZN4core3ptr58drop_in_place$LT$proc_macro..bridge..rpc..PanicMessage$GT$17h25717a361552132cE
Ltmp73:
	b	LBB15_8
LBB15_15:
Ltmp74:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
Lfunc_end8:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table15:
Lexception8:
	.byte	255
	.byte	155
	.uleb128 Lttbase5-Lttbaseref5
Lttbaseref5:
	.byte	1
	.uleb128 Lcst_end8-Lcst_begin8
Lcst_begin8:
	.uleb128 Ltmp67-Lfunc_begin8
	.uleb128 Ltmp68-Ltmp67
	.uleb128 Ltmp71-Lfunc_begin8
	.byte	0
	.uleb128 Ltmp62-Lfunc_begin8
	.uleb128 Ltmp65-Ltmp62
	.uleb128 Ltmp66-Lfunc_begin8
	.byte	0
	.uleb128 Ltmp65-Lfunc_begin8
	.uleb128 Ltmp69-Ltmp65
	.byte	0
	.byte	0
	.uleb128 Ltmp69-Lfunc_begin8
	.uleb128 Ltmp70-Ltmp69
	.uleb128 Ltmp71-Lfunc_begin8
	.byte	0
	.uleb128 Ltmp72-Lfunc_begin8
	.uleb128 Ltmp73-Ltmp72
	.uleb128 Ltmp74-Lfunc_begin8
	.byte	1
Lcst_end8:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase5:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN10proc_macro6bridge6buffer6Buffer17extend_from_array17had3c6f4a2e2ad10eE:
Lfunc_begin9:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception9
	sub	sp, sp, #192
	.cfi_def_cfa_offset 192
	stp	x29, x30, [sp, #176]
	add	x29, sp, #176
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #24]
	str	x1, [sp, #32]
	ldr	x8, [x0, #16]
	ldr	x9, [x0, #8]
	subs	x9, x8, x9
	mov	w8, #8
	subs	x8, x8, x9
	b.hi	LBB16_2
	b	LBB16_1
LBB16_1:
	b	LBB16_3
LBB16_2:
	ldr	x1, [sp, #24]
	sub	x8, x29, #56
	str	x8, [sp]
	mov	w8, #1
	stur	x8, [x29, #-56]
	stur	xzr, [x29, #-48]
	stur	xzr, [x29, #-40]
	adrp	x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from7reserve@GOTPAGE
	ldr	x8, [x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from7reserve@GOTPAGEOFF]
	stur	x8, [x29, #-32]
	adrp	x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from4drop@GOTPAGE
	ldr	x8, [x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from4drop@GOTPAGEOFF]
	stur	x8, [x29, #-24]
	add	x0, sp, #40
	str	x0, [sp, #16]
	mov	w8, #40
	mov	x2, x8
	str	x2, [sp, #8]
	bl	_memcpy
	ldr	x0, [sp, #24]
	ldr	x1, [sp]
	ldr	x2, [sp, #8]
	bl	_memcpy
	ldr	x0, [sp, #16]
	ldr	x9, [sp, #64]
	add	x8, sp, #80
	mov	w10, #8
	mov	x1, x10
	blr	x9
	ldr	x0, [sp, #24]
Ltmp75:
	bl	__ZN4core3ptr55drop_in_place$LT$proc_macro..bridge..buffer..Buffer$GT$17h34058bc54716feb8E
Ltmp76:
	b	LBB16_6
LBB16_3:
	ldr	x9, [sp, #24]
	ldr	x8, [sp, #32]
	ldr	x10, [x9]
	ldr	x11, [x9, #8]
	ldr	x8, [x8]
	str	x8, [x10, x11]
	ldr	x8, [x9, #8]
	add	x8, x8, #8
	str	x8, [x9, #8]
	.cfi_def_cfa wsp, 192
	ldp	x29, x30, [sp, #176]
	add	sp, sp, #192
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB16_4:
	.cfi_restore_state
	ldr	x0, [sp, #24]
	add	x1, sp, #80
	mov	w8, #40
	mov	x2, x8
	bl	_memcpy
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB16_5:
Ltmp77:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB16_4
LBB16_6:
	ldr	x0, [sp, #24]
	add	x1, sp, #80
	mov	w8, #40
	mov	x2, x8
	bl	_memcpy
	b	LBB16_3
Lfunc_end9:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table16:
Lexception9:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end9-Lcst_begin9
Lcst_begin9:
	.uleb128 Lfunc_begin9-Lfunc_begin9
	.uleb128 Ltmp75-Lfunc_begin9
	.byte	0
	.byte	0
	.uleb128 Ltmp75-Lfunc_begin9
	.uleb128 Ltmp76-Ltmp75
	.uleb128 Ltmp77-Lfunc_begin9
	.byte	0
	.uleb128 Ltmp76-Lfunc_begin9
	.uleb128 Lfunc_end9-Ltmp76
	.byte	0
	.byte	0
Lcst_end9:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN10proc_macro6bridge6buffer6Buffer17extend_from_array17hf09ae001b4b50e9eE:
Lfunc_begin10:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception10
	sub	sp, sp, #192
	.cfi_def_cfa_offset 192
	stp	x29, x30, [sp, #176]
	add	x29, sp, #176
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #24]
	str	x1, [sp, #32]
	ldr	x8, [x0, #16]
	ldr	x9, [x0, #8]
	subs	x9, x8, x9
	mov	w8, #4
	subs	x8, x8, x9
	b.hi	LBB17_2
	b	LBB17_1
LBB17_1:
	b	LBB17_3
LBB17_2:
	ldr	x1, [sp, #24]
	sub	x8, x29, #56
	str	x8, [sp]
	mov	w8, #1
	stur	x8, [x29, #-56]
	stur	xzr, [x29, #-48]
	stur	xzr, [x29, #-40]
	adrp	x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from7reserve@GOTPAGE
	ldr	x8, [x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from7reserve@GOTPAGEOFF]
	stur	x8, [x29, #-32]
	adrp	x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from4drop@GOTPAGE
	ldr	x8, [x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from4drop@GOTPAGEOFF]
	stur	x8, [x29, #-24]
	add	x0, sp, #40
	str	x0, [sp, #16]
	mov	w8, #40
	mov	x2, x8
	str	x2, [sp, #8]
	bl	_memcpy
	ldr	x0, [sp, #24]
	ldr	x1, [sp]
	ldr	x2, [sp, #8]
	bl	_memcpy
	ldr	x0, [sp, #16]
	ldr	x9, [sp, #64]
	add	x8, sp, #80
	mov	w10, #4
	mov	x1, x10
	blr	x9
	ldr	x0, [sp, #24]
Ltmp78:
	bl	__ZN4core3ptr55drop_in_place$LT$proc_macro..bridge..buffer..Buffer$GT$17h34058bc54716feb8E
Ltmp79:
	b	LBB17_6
LBB17_3:
	ldr	x9, [sp, #24]
	ldr	x8, [sp, #32]
	ldr	x10, [x9]
	ldr	x11, [x9, #8]
	ldr	w8, [x8]
	str	w8, [x10, x11]
	ldr	x8, [x9, #8]
	add	x8, x8, #4
	str	x8, [x9, #8]
	.cfi_def_cfa wsp, 192
	ldp	x29, x30, [sp, #176]
	add	sp, sp, #192
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB17_4:
	.cfi_restore_state
	ldr	x0, [sp, #24]
	add	x1, sp, #80
	mov	w8, #40
	mov	x2, x8
	bl	_memcpy
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB17_5:
Ltmp80:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB17_4
LBB17_6:
	ldr	x0, [sp, #24]
	add	x1, sp, #80
	mov	w8, #40
	mov	x2, x8
	bl	_memcpy
	b	LBB17_3
Lfunc_end10:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table17:
Lexception10:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end10-Lcst_begin10
Lcst_begin10:
	.uleb128 Lfunc_begin10-Lfunc_begin10
	.uleb128 Ltmp78-Lfunc_begin10
	.byte	0
	.byte	0
	.uleb128 Ltmp78-Lfunc_begin10
	.uleb128 Ltmp79-Ltmp78
	.uleb128 Ltmp80-Lfunc_begin10
	.byte	0
	.uleb128 Ltmp79-Lfunc_begin10
	.uleb128 Lfunc_end10-Ltmp79
	.byte	0
	.byte	0
Lcst_end10:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN10proc_macro6bridge6buffer6Buffer17extend_from_slice17h7647dd530951f358E:
Lfunc_begin11:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception11
	sub	sp, sp, #208
	.cfi_def_cfa_offset 208
	stp	x29, x30, [sp, #192]
	add	x29, sp, #192
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #32]
	str	x1, [sp, #40]
	str	x2, [sp, #48]
	ldr	x8, [x0, #16]
	ldr	x9, [x0, #8]
	subs	x8, x8, x9
	subs	x8, x2, x8
	b.hi	LBB18_2
	b	LBB18_1
LBB18_1:
	b	LBB18_3
LBB18_2:
	ldr	x1, [sp, #32]
	sub	x8, x29, #56
	str	x8, [sp, #8]
	mov	w8, #1
	stur	x8, [x29, #-56]
	stur	xzr, [x29, #-48]
	stur	xzr, [x29, #-40]
	adrp	x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from7reserve@GOTPAGE
	ldr	x8, [x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from7reserve@GOTPAGEOFF]
	stur	x8, [x29, #-32]
	adrp	x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from4drop@GOTPAGE
	ldr	x8, [x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from4drop@GOTPAGEOFF]
	stur	x8, [x29, #-24]
	add	x0, sp, #56
	str	x0, [sp, #24]
	mov	w8, #40
	mov	x2, x8
	str	x2, [sp, #16]
	bl	_memcpy
	ldr	x0, [sp, #32]
	ldr	x1, [sp, #8]
	ldr	x2, [sp, #16]
	bl	_memcpy
	ldr	x0, [sp, #24]
	ldr	x1, [sp, #48]
	ldr	x9, [sp, #80]
	add	x8, sp, #96
	blr	x9
	ldr	x0, [sp, #32]
Ltmp81:
	bl	__ZN4core3ptr55drop_in_place$LT$proc_macro..bridge..buffer..Buffer$GT$17h34058bc54716feb8E
Ltmp82:
	b	LBB18_6
LBB18_3:
	ldr	x10, [sp, #32]
	ldr	x8, [sp, #48]
	ldr	x1, [sp, #40]
	ldr	x9, [x10]
	ldr	x10, [x10, #8]
	add	x0, x9, x10
	lsr	x2, x8, #0
	bl	_memcpy
	ldr	x10, [sp, #48]
	ldr	x9, [sp, #32]
	ldr	x8, [x9, #8]
	add	x8, x8, x10
	str	x8, [x9, #8]
	.cfi_def_cfa wsp, 208
	ldp	x29, x30, [sp, #192]
	add	sp, sp, #208
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB18_4:
	.cfi_restore_state
	ldr	x0, [sp, #32]
	add	x1, sp, #96
	mov	w8, #40
	mov	x2, x8
	bl	_memcpy
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB18_5:
Ltmp83:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB18_4
LBB18_6:
	ldr	x0, [sp, #32]
	add	x1, sp, #96
	mov	w8, #40
	mov	x2, x8
	bl	_memcpy
	b	LBB18_3
Lfunc_end11:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table18:
Lexception11:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end11-Lcst_begin11
Lcst_begin11:
	.uleb128 Lfunc_begin11-Lfunc_begin11
	.uleb128 Ltmp81-Lfunc_begin11
	.byte	0
	.byte	0
	.uleb128 Ltmp81-Lfunc_begin11
	.uleb128 Ltmp82-Ltmp81
	.uleb128 Ltmp83-Lfunc_begin11
	.byte	0
	.uleb128 Ltmp82-Lfunc_begin11
	.uleb128 Lfunc_end11-Ltmp82
	.byte	0
	.byte	0
Lcst_end11:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN10proc_macro6bridge6buffer6Buffer4push17h4a2472d9ab798a08E:
Lfunc_begin12:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception12
	sub	sp, sp, #208
	.cfi_def_cfa_offset 208
	stp	x29, x30, [sp, #192]
	add	x29, sp, #192
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #40]
	str	w1, [sp, #52]
	ldr	x8, [x0, #8]
	ldr	x9, [x0, #16]
	subs	x8, x8, x9
	b.eq	LBB19_2
	b	LBB19_1
LBB19_1:
	b	LBB19_3
LBB19_2:
	ldr	x1, [sp, #40]
	sub	x8, x29, #56
	str	x8, [sp, #8]
	mov	w8, #1
	str	x8, [sp, #32]
	stur	x8, [x29, #-56]
	stur	xzr, [x29, #-48]
	stur	xzr, [x29, #-40]
	adrp	x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from7reserve@GOTPAGE
	ldr	x8, [x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from7reserve@GOTPAGEOFF]
	stur	x8, [x29, #-32]
	adrp	x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from4drop@GOTPAGE
	ldr	x8, [x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from4drop@GOTPAGEOFF]
	stur	x8, [x29, #-24]
	add	x0, sp, #56
	str	x0, [sp, #24]
	mov	w8, #40
	mov	x2, x8
	str	x2, [sp, #16]
	bl	_memcpy
	ldr	x0, [sp, #40]
	ldr	x1, [sp, #8]
	ldr	x2, [sp, #16]
	bl	_memcpy
	ldr	x0, [sp, #24]
	ldr	x1, [sp, #32]
	ldr	x9, [sp, #80]
	add	x8, sp, #96
	blr	x9
	ldr	x0, [sp, #40]
Ltmp84:
	bl	__ZN4core3ptr55drop_in_place$LT$proc_macro..bridge..buffer..Buffer$GT$17h34058bc54716feb8E
Ltmp85:
	b	LBB19_6
LBB19_3:
	ldr	x9, [sp, #40]
	ldr	w8, [sp, #52]
	ldr	x10, [x9]
	ldr	x11, [x9, #8]
	strb	w8, [x10, x11]
	ldr	x8, [x9, #8]
	add	x8, x8, #1
	str	x8, [x9, #8]
	.cfi_def_cfa wsp, 208
	ldp	x29, x30, [sp, #192]
	add	sp, sp, #208
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB19_4:
	.cfi_restore_state
	ldr	x0, [sp, #40]
	add	x1, sp, #96
	mov	w8, #40
	mov	x2, x8
	bl	_memcpy
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB19_5:
Ltmp86:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB19_4
LBB19_6:
	ldr	x0, [sp, #40]
	add	x1, sp, #96
	mov	w8, #40
	mov	x2, x8
	bl	_memcpy
	b	LBB19_3
Lfunc_end12:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table19:
Lexception12:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end12-Lcst_begin12
Lcst_begin12:
	.uleb128 Lfunc_begin12-Lfunc_begin12
	.uleb128 Ltmp84-Lfunc_begin12
	.byte	0
	.byte	0
	.uleb128 Ltmp84-Lfunc_begin12
	.uleb128 Ltmp85-Ltmp84
	.uleb128 Ltmp86-Lfunc_begin12
	.byte	0
	.uleb128 Ltmp85-Lfunc_begin12
	.uleb128 Lfunc_end12-Ltmp85
	.byte	0
	.byte	0
Lcst_end12:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN10proc_macro6bridge6client10run_client17h1f16ac7d9ecc60daE:
Lfunc_begin13:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception13
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
	sub	sp, sp, #512
	str	x8, [sp, #8]
	str	x0, [sp, #16]
	mov	x0, x1
	ldr	x1, [sp, #16]
	str	x0, [sp, #32]
	add	x0, sp, #80
	str	x0, [sp, #24]
	mov	w8, #40
	mov	x2, x8
	str	x2, [sp, #64]
	bl	_memcpy
	ldr	x0, [sp, #16]
	ldr	x11, [sp, #24]
	ldr	x8, [sp, #32]
	ldr	x2, [sp, #64]
	ldr	x10, [x0, #40]
	ldr	x9, [x0, #48]
	ldrb	w12, [x0, #56]
	and	w13, w12, #0x1
	add	x12, sp, #127
	strb	w13, [sp, #127]
	add	x1, sp, #208
	str	x12, [sp, #208]
	str	x11, [sp, #216]
	str	x10, [sp, #224]
	str	x9, [sp, #232]
	str	x8, [sp, #240]
	add	x0, sp, #168
	str	x0, [sp, #40]
	bl	_memcpy
	ldr	x1, [sp, #40]
	ldr	x2, [sp, #64]
	sub	x0, x29, #176
	str	x0, [sp, #48]
	bl	_memcpy
	ldr	x1, [sp, #48]
	ldr	x2, [sp, #64]
	sub	x0, x29, #232
	str	x0, [sp, #56]
	bl	_memcpy
	ldr	x1, [sp, #56]
	ldr	x2, [sp, #64]
	add	x0, sp, #256
	str	x0, [sp, #72]
	bl	_memcpy
	ldr	x1, [sp, #72]
	adrp	x0, __ZN3std9panicking12catch_unwind7do_call17h94d12ae2e30ec88dE@PAGE
	add	x0, x0, __ZN3std9panicking12catch_unwind7do_call17h94d12ae2e30ec88dE@PAGEOFF
	adrp	x2, __ZN3std9panicking12catch_unwind8do_catch17h2bbf33dba1acca0eE@PAGE
	add	x2, x2, __ZN3std9panicking12catch_unwind8do_catch17h2bbf33dba1acca0eE@PAGEOFF
	bl	___rust_try
	stur	w0, [x29, #-36]
	ldur	w8, [x29, #-36]
	cbnz	w8, LBB20_2
	b	LBB20_1
LBB20_1:
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x9, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x8, [x8, #8]
	str	x9, [sp, #152]
	str	x8, [sp, #160]
	mov	x8, #-9223372036854775805
	str	x8, [sp, #128]
	add	x8, sp, #80
	str	x8, [sp, #248]
	ldr	x8, [sp, #248]
	stur	x8, [x29, #-48]
	b	LBB20_3
LBB20_2:
	ldr	x9, [sp, #256]
	ldr	x8, [sp, #264]
	stur	x9, [x29, #-192]
	stur	x8, [x29, #-184]
	ldur	x9, [x29, #-192]
	ldur	x8, [x29, #-184]
	str	x9, [sp, #152]
	str	x8, [sp, #160]
	ldr	x0, [sp, #152]
	ldr	x1, [sp, #160]
Ltmp87:
	sub	x8, x29, #136
	bl	__RNvXse_NtNtCs7B2A3P5pSWO_10proc_macro6bridge3rpcNtB5_12PanicMessageINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc5boxed3BoxDNtNtB18_3any3AnyNtNtB18_6marker4SendEL_EE4from
Ltmp88:
	b	LBB20_6
LBB20_3:
Ltmp91:
	bl	__RNvMs0_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6symbolNtB5_6Symbol14invalidate_all
Ltmp92:
	b	LBB20_8
LBB20_4:
Ltmp94:
	add	x0, sp, #80
	bl	__ZN4core3ptr55drop_in_place$LT$proc_macro..bridge..buffer..Buffer$GT$17h34058bc54716feb8E
Ltmp95:
	b	LBB20_10
LBB20_5:
Ltmp93:
	stur	x0, [x29, #-32]
	mov	x8, x1
	stur	w8, [x29, #-24]
	b	LBB20_4
LBB20_6:
	ldur	q0, [x29, #-136]
	str	q0, [sp, #128]
	ldur	x8, [x29, #-120]
	str	x8, [sp, #144]
	add	x8, sp, #80
	str	x8, [sp, #248]
	ldr	x8, [sp, #248]
	stur	x8, [x29, #-48]
	ldr	q0, [sp, #128]
	stur	q0, [x29, #-112]
	ldr	x8, [sp, #144]
	stur	x8, [x29, #-96]
	ldr	x8, [sp, #248]
	str	xzr, [x8, #8]
	ldur	q0, [x29, #-112]
	sub	x0, x29, #80
	stur	q0, [x29, #-80]
	ldur	x8, [x29, #-96]
	stur	x8, [x29, #-64]
	ldr	x1, [sp, #248]
Ltmp89:
	sub	x2, x29, #49
	bl	__ZN10proc_macro6bridge1_104_$LT$impl$u20$proc_macro..bridge..rpc..Encode$LT$S$GT$$u20$for$u20$core..result..Result$LT$T$C$E$GT$$GT$6encode17hf845f529ac121720E
Ltmp90:
	b	LBB20_7
LBB20_7:
	b	LBB20_3
LBB20_8:
	ldr	x0, [sp, #8]
	add	x1, sp, #80
	mov	w8, #40
	mov	x2, x8
	bl	_memcpy
	add	sp, sp, #512
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	ldp	x28, x27, [sp], #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w27
	.cfi_restore w28
	ret
LBB20_9:
	.cfi_restore_state
Ltmp96:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB20_10:
	ldur	x0, [x29, #-32]
	bl	__Unwind_Resume
Lfunc_end13:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table20:
Lexception13:
	.byte	255
	.byte	155
	.uleb128 Lttbase6-Lttbaseref6
Lttbaseref6:
	.byte	1
	.uleb128 Lcst_end13-Lcst_begin13
Lcst_begin13:
	.uleb128 Lfunc_begin13-Lfunc_begin13
	.uleb128 Ltmp87-Lfunc_begin13
	.byte	0
	.byte	0
	.uleb128 Ltmp87-Lfunc_begin13
	.uleb128 Ltmp92-Ltmp87
	.uleb128 Ltmp93-Lfunc_begin13
	.byte	0
	.uleb128 Ltmp94-Lfunc_begin13
	.uleb128 Ltmp95-Ltmp94
	.uleb128 Ltmp96-Lfunc_begin13
	.byte	1
	.uleb128 Ltmp89-Lfunc_begin13
	.uleb128 Ltmp90-Ltmp89
	.uleb128 Ltmp93-Lfunc_begin13
	.byte	0
	.uleb128 Ltmp90-Lfunc_begin13
	.uleb128 Lfunc_end13-Ltmp90
	.byte	0
	.byte	0
Lcst_end13:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase6:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN10proc_macro6bridge6client10run_client28_$u7b$$u7b$closure$u7d$$u7d$17h43bc46426bcbac7fE:
Lfunc_begin14:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception14
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
	sub	sp, sp, #512
	str	x0, [sp, #88]
	mov	w8, #1
	sturb	w8, [x29, #-185]
	ldr	x8, [x0]
	ldrb	w8, [x8]
Ltmp97:
	and	w0, w8, #0x1
	bl	__RNvNtNtCs7B2A3P5pSWO_10proc_macro6bridge6client24maybe_install_panic_hook
Ltmp98:
	b	LBB21_3
LBB21_1:
	ldurb	w8, [x29, #-185]
	tbnz	w8, #0, LBB21_19
	b	LBB21_18
LBB21_2:
Ltmp103:
	stur	x0, [x29, #-32]
	mov	x8, x1
	stur	w8, [x29, #-24]
	b	LBB21_1
LBB21_3:
Ltmp99:
	bl	__RNvMs0_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6symbolNtB5_6Symbol14invalidate_all
Ltmp100:
	b	LBB21_4
LBB21_4:
	ldr	x8, [sp, #88]
	ldr	x8, [x8, #8]
	ldr	x9, [x8]
	ldr	x8, [x8, #8]
	add	x0, sp, #96
	str	x9, [sp, #96]
	str	x8, [sp, #104]
Ltmp101:
	add	x8, sp, #124
	add	x1, sp, #143
	bl	__ZN74_$LT$$LP$A$C$B$RP$$u20$as$u20$proc_macro..bridge..rpc..Decode$LT$S$GT$$GT$6decode17hebc1a0371e05e1cbE
Ltmp102:
	b	LBB21_5
LBB21_5:
	ldr	x8, [sp, #88]
	ldur	x9, [sp, #124]
	str	x9, [sp, #112]
	ldr	w9, [sp, #132]
	str	w9, [sp, #120]
	ldr	w9, [sp, #136]
	str	w9, [sp, #80]
	ldr	x1, [x8, #8]
	str	x1, [sp]
	sub	x8, x29, #184
	str	x8, [sp, #8]
	mov	w8, #1
	stur	x8, [x29, #-184]
	stur	xzr, [x29, #-176]
	stur	xzr, [x29, #-168]
	adrp	x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from7reserve@GOTPAGE
	ldr	x8, [x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from7reserve@GOTPAGEOFF]
	stur	x8, [x29, #-160]
	adrp	x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from4drop@GOTPAGE
	ldr	x8, [x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from4drop@GOTPAGEOFF]
	stur	x8, [x29, #-152]
	sub	x0, x29, #232
	str	x0, [sp, #16]
	mov	w8, #40
	mov	x2, x8
	str	x2, [sp, #24]
	bl	_memcpy
	ldr	x0, [sp]
	ldr	x1, [sp, #8]
	ldr	x2, [sp, #24]
	bl	_memcpy
	ldr	x1, [sp, #16]
	ldr	x2, [sp, #24]
	ldr	x8, [sp, #88]
	ldr	x9, [x8, #16]
	str	x9, [sp, #32]
	ldr	x8, [x8, #24]
	str	x8, [sp, #40]
	add	x8, sp, #224
	str	x8, [sp, #48]
	add	x0, x8, #16
	bl	_memcpy
	ldr	x9, [sp, #32]
	ldr	x8, [sp, #40]
	ldr	x1, [sp, #48]
	str	x9, [sp, #224]
	str	x8, [sp, #232]
	ldr	x8, [sp, #112]
	str	x8, [sp, #280]
	ldr	w8, [sp, #120]
	str	w8, [sp, #288]
	sub	x0, x29, #144
	str	x0, [sp, #56]
	mov	w8, #72
	mov	x2, x8
	str	x2, [sp, #64]
	bl	_memcpy
	ldr	x1, [sp, #56]
	ldr	x2, [sp, #64]
	add	x8, sp, #144
	str	x8, [sp, #72]
	str	xzr, [sp, #144]
	add	x0, x8, #8
	bl	_memcpy
	ldr	x0, [sp, #72]
	ldr	x8, [sp, #88]
	ldr	w2, [sp, #80]
	mov	w9, #1
	sturb	w9, [x29, #-186]
	sturb	wzr, [x29, #-185]
	ldr	x1, [x8, #32]
Ltmp104:
	bl	__ZN10proc_macro6bridge6client5state3set17hb0a3977f41a01567E
	str	w0, [sp, #84]
Ltmp105:
	b	LBB21_8
LBB21_6:
	ldurb	w8, [x29, #-186]
	tbnz	w8, #0, LBB21_17
	b	LBB21_1
LBB21_7:
Ltmp106:
	stur	x0, [x29, #-32]
	mov	x8, x1
	stur	w8, [x29, #-24]
	b	LBB21_6
LBB21_8:
	ldr	w8, [sp, #84]
	stur	w8, [x29, #-192]
	mov	w8, #1
	sturb	w8, [x29, #-187]
	sturb	wzr, [x29, #-186]
	add	x8, sp, #144
	add	x1, x8, #24
	sub	x0, x29, #72
	mov	w8, #40
	mov	x2, x8
	bl	_memcpy
	ldr	x8, [sp, #88]
	ldr	x0, [x8, #8]
Ltmp107:
	bl	__ZN4core3ptr55drop_in_place$LT$proc_macro..bridge..buffer..Buffer$GT$17h34058bc54716feb8E
Ltmp108:
	b	LBB21_11
LBB21_9:
	ldr	x8, [sp, #88]
	ldr	x0, [x8, #8]
	sub	x1, x29, #72
	mov	w8, #40
	mov	x2, x8
	bl	_memcpy
	b	LBB21_12
LBB21_10:
Ltmp109:
	stur	x0, [x29, #-32]
	mov	x8, x1
	stur	w8, [x29, #-24]
	b	LBB21_9
LBB21_11:
	ldr	x8, [sp, #88]
	ldr	x0, [x8, #8]
	sub	x1, x29, #72
	mov	w8, #40
	mov	x2, x8
	bl	_memcpy
	ldr	x8, [sp, #88]
	ldr	x9, [x8, #8]
	str	xzr, [x9, #8]
	sturb	wzr, [x29, #-187]
	ldur	w1, [x29, #-192]
	ldr	x2, [x8, #8]
Ltmp110:
	mov	w0, #0
	sub	x3, x29, #188
	bl	__ZN10proc_macro6bridge1_104_$LT$impl$u20$proc_macro..bridge..rpc..Encode$LT$S$GT$$u20$for$u20$core..result..Result$LT$T$C$E$GT$$GT$6encode17hcde74dc2e74c6053E
Ltmp111:
	b	LBB21_14
LBB21_12:
	ldurb	w8, [x29, #-187]
	tbnz	w8, #0, LBB21_15
	b	LBB21_6
LBB21_13:
Ltmp112:
	stur	x0, [x29, #-32]
	mov	x8, x1
	stur	w8, [x29, #-24]
	b	LBB21_12
LBB21_14:
	add	sp, sp, #512
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	ldp	x28, x27, [sp], #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w27
	.cfi_restore w28
	ret
LBB21_15:
	.cfi_restore_state
Ltmp113:
	sub	x0, x29, #192
	bl	__ZN4core3ptr88drop_in_place$LT$core..option..Option$LT$proc_macro..bridge..client..TokenStream$GT$$GT$17h893a38e436fedee0E
Ltmp114:
	b	LBB21_6
LBB21_16:
Ltmp117:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB21_17:
Ltmp115:
	add	x0, sp, #144
	bl	__ZN4core3ptr82drop_in_place$LT$core..cell..RefCell$LT$proc_macro..bridge..client..Bridge$GT$$GT$17he593bddf492e9d7cE
Ltmp116:
	b	LBB21_1
LBB21_18:
	ldur	x0, [x29, #-32]
	bl	__Unwind_Resume
LBB21_19:
	b	LBB21_18
Lfunc_end14:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table21:
Lexception14:
	.byte	255
	.byte	155
	.uleb128 Lttbase7-Lttbaseref7
Lttbaseref7:
	.byte	1
	.uleb128 Lcst_end14-Lcst_begin14
Lcst_begin14:
	.uleb128 Ltmp97-Lfunc_begin14
	.uleb128 Ltmp102-Ltmp97
	.uleb128 Ltmp103-Lfunc_begin14
	.byte	0
	.uleb128 Ltmp102-Lfunc_begin14
	.uleb128 Ltmp104-Ltmp102
	.byte	0
	.byte	0
	.uleb128 Ltmp104-Lfunc_begin14
	.uleb128 Ltmp105-Ltmp104
	.uleb128 Ltmp106-Lfunc_begin14
	.byte	0
	.uleb128 Ltmp105-Lfunc_begin14
	.uleb128 Ltmp107-Ltmp105
	.byte	0
	.byte	0
	.uleb128 Ltmp107-Lfunc_begin14
	.uleb128 Ltmp108-Ltmp107
	.uleb128 Ltmp109-Lfunc_begin14
	.byte	0
	.uleb128 Ltmp108-Lfunc_begin14
	.uleb128 Ltmp110-Ltmp108
	.byte	0
	.byte	0
	.uleb128 Ltmp110-Lfunc_begin14
	.uleb128 Ltmp111-Ltmp110
	.uleb128 Ltmp112-Lfunc_begin14
	.byte	0
	.uleb128 Ltmp113-Lfunc_begin14
	.uleb128 Ltmp116-Ltmp113
	.uleb128 Ltmp117-Lfunc_begin14
	.byte	1
	.uleb128 Ltmp116-Lfunc_begin14
	.uleb128 Lfunc_end14-Ltmp116
	.byte	0
	.byte	0
Lcst_end14:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase7:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN10proc_macro6bridge6client10run_client28_$u7b$$u7b$closure$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$17h3545f713b779c198E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN10proc_macro6bridge6client63Client$LT$proc_macro..TokenStream$C$proc_macro..TokenStream$GT$7expand128_$u7b$$u7b$closure$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$17h3dba49356eb7023fE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN10proc_macro6bridge6client5state12BRIDGE_STATE29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$17hae68c7c3f20f4b63E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	adrp	x0, __RNvNCNKNvNtNtNtCs7B2A3P5pSWO_10proc_macro6bridge6client5state12BRIDGE_STATE0s_023___RUST_STD_INTERNAL_VAL@TLVPPAGE
	ldr	x0, [x0, __RNvNCNKNvNtNtNtCs7B2A3P5pSWO_10proc_macro6bridge6client5state12BRIDGE_STATE0s_023___RUST_STD_INTERNAL_VAL@TLVPPAGEOFF]
	ldr	x8, [x0]
	blr	x8
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN10proc_macro6bridge6client5state3set17hb0a3977f41a01567E:
Lfunc_begin15:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception15
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	stp	x29, x30, [sp, #80]
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #16]
	mov	x8, x1
	ldr	x1, [sp, #16]
	str	x8, [sp, #32]
	str	w2, [sp, #40]
	mov	w8, #1
	sturb	w8, [x29, #-17]
Ltmp118:
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.5@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.5@PAGEOFF
	bl	__ZN3std6thread5local17LocalKey$LT$T$GT$4with17h7e2646c56cc9a777E
	str	x0, [sp, #24]
Ltmp119:
	b	LBB24_3
LBB24_1:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB24_10
	b	LBB24_9
LBB24_2:
Ltmp127:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB24_1
LBB24_3:
	ldr	x8, [sp, #24]
	stur	x8, [x29, #-32]
	sturb	wzr, [x29, #-17]
	ldr	x0, [sp, #32]
	ldr	w1, [sp, #40]
Ltmp120:
	bl	__ZN10proc_macro6bridge6client10run_client28_$u7b$$u7b$closure$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$17h3545f713b779c198E
	str	w0, [sp, #12]
Ltmp121:
	b	LBB24_6
LBB24_4:
Ltmp123:
	sub	x0, x29, #32
	bl	__ZN4core3ptr74drop_in_place$LT$proc_macro..bridge..client..state..set..RestoreOnDrop$GT$17hd4169d69cfe4f5e0E
Ltmp124:
	b	LBB24_1
LBB24_5:
Ltmp122:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB24_4
LBB24_6:
Ltmp125:
	sub	x0, x29, #32
	bl	__ZN4core3ptr74drop_in_place$LT$proc_macro..bridge..client..state..set..RestoreOnDrop$GT$17hd4169d69cfe4f5e0E
Ltmp126:
	b	LBB24_7
LBB24_7:
	ldr	w0, [sp, #12]
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB24_8:
	.cfi_restore_state
Ltmp130:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB24_9:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB24_10:
Ltmp128:
	add	x0, sp, #32
	bl	__ZN4core3ptr435drop_in_place$LT$proc_macro..bridge..client..run_client$LT$proc_macro..bridge..client..TokenStream$C$core..option..Option$LT$proc_macro..bridge..client..TokenStream$GT$$C$proc_macro..bridge..client..Client$LT$proc_macro..TokenStream$C$proc_macro..TokenStream$GT$..expand1$LT$const_random_macro..const_random$GT$..$u7b$$u7b$closure$u7d$$u7d$..$u7b$$u7b$closure$u7d$$u7d$$GT$..$u7b$$u7b$closure$u7d$$u7d$..$u7b$$u7b$closure$u7d$$u7d$$GT$17hc72aaedc0b1a8e00E
Ltmp129:
	b	LBB24_9
Lfunc_end15:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table24:
Lexception15:
	.byte	255
	.byte	155
	.uleb128 Lttbase8-Lttbaseref8
Lttbaseref8:
	.byte	1
	.uleb128 Lcst_end15-Lcst_begin15
Lcst_begin15:
	.uleb128 Ltmp118-Lfunc_begin15
	.uleb128 Ltmp119-Ltmp118
	.uleb128 Ltmp127-Lfunc_begin15
	.byte	0
	.uleb128 Ltmp120-Lfunc_begin15
	.uleb128 Ltmp121-Ltmp120
	.uleb128 Ltmp122-Lfunc_begin15
	.byte	0
	.uleb128 Ltmp123-Lfunc_begin15
	.uleb128 Ltmp124-Ltmp123
	.uleb128 Ltmp130-Lfunc_begin15
	.byte	1
	.uleb128 Ltmp125-Lfunc_begin15
	.uleb128 Ltmp126-Ltmp125
	.uleb128 Ltmp127-Lfunc_begin15
	.byte	0
	.uleb128 Ltmp126-Lfunc_begin15
	.uleb128 Ltmp128-Ltmp126
	.byte	0
	.byte	0
	.uleb128 Ltmp128-Lfunc_begin15
	.uleb128 Ltmp129-Ltmp128
	.uleb128 Ltmp130-Lfunc_begin15
	.byte	1
Lcst_end15:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase8:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN10proc_macro6bridge6client63Client$LT$proc_macro..TokenStream$C$proc_macro..TokenStream$GT$7expand128_$u7b$$u7b$closure$u7d$$u7d$17hd69b0972b6f27494E:
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
	bl	__ZN10proc_macro6bridge6client10run_client17h1f16ac7d9ecc60daE
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN10proc_macro6bridge6client63Client$LT$proc_macro..TokenStream$C$proc_macro..TokenStream$GT$7expand128_$u7b$$u7b$closure$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$17h3dba49356eb7023fE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ops8function2Fn4call17h0713067d4e5929b1E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN114_$LT$core..iter..adapters..flatten..FlatMap$LT$I$C$U$C$F$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4fold17h4f4ac4b2af5edf01E:
	.cfi_startproc
	sub	sp, sp, #160
	.cfi_def_cfa_offset 160
	stp	x29, x30, [sp, #144]
	add	x29, sp, #144
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	mov	x0, x1
	ldr	x1, [sp, #8]
	str	x0, [sp, #24]
	add	x0, sp, #32
	str	x0, [sp, #16]
	mov	w8, #112
	mov	x2, x8
	bl	_memcpy
	ldr	x0, [sp, #16]
	ldr	x1, [sp, #24]
	bl	__ZN116_$LT$core..iter..adapters..flatten..FlattenCompat$LT$I$C$U$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4fold17hd505cf2677cea0f4E
	.cfi_def_cfa wsp, 160
	ldp	x29, x30, [sp, #144]
	add	sp, sp, #160
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN114_$LT$core..iter..adapters..flatten..FlatMap$LT$I$C$U$C$F$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17hf4f77ae3ff44e098E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN116_$LT$core..iter..adapters..flatten..FlattenCompat$LT$I$C$U$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h890c077781a179a6E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN114_$LT$proc_macro..TokenStream$u20$as$u20$core..iter..traits..collect..FromIterator$LT$proc_macro..TokenTree$GT$$GT$9from_iter17h03cfed66d760bf14E:
Lfunc_begin16:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception16
	sub	sp, sp, #384
	.cfi_def_cfa_offset 384
	stp	x28, x27, [sp, #352]
	stp	x29, x30, [sp, #368]
	add	x29, sp, #368
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w27, -24
	.cfi_offset w28, -32
	.cfi_remember_state
	add	x8, sp, #32
	str	x8, [sp, #24]
	bl	__ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h6bc589d4dc7ad736E
	ldr	x0, [sp, #24]
	mov	w8, #1
	sturb	w8, [x29, #-33]
Ltmp131:
	add	x8, sp, #168
	bl	__ZN114_$LT$core..iter..adapters..flatten..FlatMap$LT$I$C$U$C$F$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17hf4f77ae3ff44e098E
Ltmp132:
	b	LBB29_3
LBB29_1:
	ldurb	w8, [x29, #-33]
	tbnz	w8, #0, LBB29_12
	b	LBB29_11
LBB29_2:
Ltmp135:
	stur	x0, [x29, #-32]
	mov	x8, x1
	stur	w8, [x29, #-24]
	b	LBB29_1
LBB29_3:
	ldr	x0, [sp, #168]
Ltmp133:
	add	x8, sp, #144
	bl	__RNvMse_Cs7B2A3P5pSWO_10proc_macroNtB5_17ConcatTreesHelper3new
Ltmp134:
	b	LBB29_4
LBB29_4:
	mov	w8, #1
	sturb	w8, [x29, #-34]
	sturb	wzr, [x29, #-33]
	add	x1, sp, #32
	sub	x0, x29, #176
	str	x0, [sp, #16]
	mov	w8, #112
	mov	x2, x8
	bl	_memcpy
	ldr	x0, [sp, #16]
Ltmp136:
	add	x1, sp, #144
	bl	__ZN4core4iter6traits8iterator8Iterator8for_each17haff20418b154010cE
Ltmp137:
	b	LBB29_7
LBB29_5:
	ldurb	w8, [x29, #-34]
	tbnz	w8, #0, LBB29_9
	b	LBB29_1
LBB29_6:
Ltmp140:
	stur	x0, [x29, #-32]
	mov	x8, x1
	stur	w8, [x29, #-24]
	b	LBB29_5
LBB29_7:
	sturb	wzr, [x29, #-34]
	ldr	q0, [sp, #144]
	sub	x0, x29, #64
	stur	q0, [x29, #-64]
	ldr	x8, [sp, #160]
	stur	x8, [x29, #-48]
Ltmp138:
	bl	__RNvMse_Cs7B2A3P5pSWO_10proc_macroNtB5_17ConcatTreesHelper5build
	str	w0, [sp, #12]
Ltmp139:
	b	LBB29_8
LBB29_8:
	ldr	w0, [sp, #12]
	.cfi_def_cfa wsp, 384
	ldp	x29, x30, [sp, #368]
	ldp	x28, x27, [sp, #352]
	add	sp, sp, #384
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w27
	.cfi_restore w28
	ret
LBB29_9:
	.cfi_restore_state
Ltmp141:
	add	x0, sp, #144
	bl	__ZN4core3ptr50drop_in_place$LT$proc_macro..ConcatTreesHelper$GT$17he62cdc061752675aE
Ltmp142:
	b	LBB29_1
LBB29_10:
Ltmp145:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB29_11:
	ldur	x0, [x29, #-32]
	bl	__Unwind_Resume
LBB29_12:
Ltmp143:
	add	x0, sp, #32
	bl	__ZN4core3ptr340drop_in_place$LT$core..iter..adapters..flatten..FlatMap$LT$alloc..vec..into_iter..IntoIter$LT$u8$GT$$C$core..iter..adapters..chain..Chain$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$C$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$$C$const_random_macro..const_random..$u7b$$u7b$closure$u7d$$u7d$$GT$$GT$17hf231409c60f89aa3E
Ltmp144:
	b	LBB29_11
Lfunc_end16:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table29:
Lexception16:
	.byte	255
	.byte	155
	.uleb128 Lttbase9-Lttbaseref9
Lttbaseref9:
	.byte	1
	.uleb128 Lcst_end16-Lcst_begin16
Lcst_begin16:
	.uleb128 Lfunc_begin16-Lfunc_begin16
	.uleb128 Ltmp131-Lfunc_begin16
	.byte	0
	.byte	0
	.uleb128 Ltmp131-Lfunc_begin16
	.uleb128 Ltmp134-Ltmp131
	.uleb128 Ltmp135-Lfunc_begin16
	.byte	0
	.uleb128 Ltmp134-Lfunc_begin16
	.uleb128 Ltmp136-Ltmp134
	.byte	0
	.byte	0
	.uleb128 Ltmp136-Lfunc_begin16
	.uleb128 Ltmp139-Ltmp136
	.uleb128 Ltmp140-Lfunc_begin16
	.byte	0
	.uleb128 Ltmp141-Lfunc_begin16
	.uleb128 Ltmp142-Ltmp141
	.uleb128 Ltmp145-Lfunc_begin16
	.byte	1
	.uleb128 Ltmp142-Lfunc_begin16
	.uleb128 Ltmp143-Ltmp142
	.byte	0
	.byte	0
	.uleb128 Ltmp143-Lfunc_begin16
	.uleb128 Ltmp144-Ltmp143
	.uleb128 Ltmp145-Lfunc_begin16
	.byte	1
Lcst_end16:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase9:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN114_$LT$proc_macro..TokenStream$u20$as$u20$core..iter..traits..collect..FromIterator$LT$proc_macro..TokenTree$GT$$GT$9from_iter28_$u7b$$u7b$closure$u7d$$u7d$17ha49a1b5fd2ccfc0cE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x0, [x0]
	bl	__RNvMse_Cs7B2A3P5pSWO_10proc_macroNtB5_17ConcatTreesHelper4push
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN115_$LT$core..panic..unwind_safe..AssertUnwindSafe$LT$F$GT$$u20$as$u20$core..ops..function..FnOnce$LT$$LP$$RP$$GT$$GT$9call_once17h0315fb49a66c4b3eE:
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x1, x0
	add	x0, sp, #24
	str	x0, [sp, #8]
	mov	w8, #40
	mov	x2, x8
	bl	_memcpy
	ldr	x0, [sp, #8]
	bl	__ZN10proc_macro6bridge6client10run_client28_$u7b$$u7b$closure$u7d$$u7d$17h43bc46426bcbac7fE
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN116_$LT$core..iter..adapters..flatten..FlattenCompat$LT$I$C$U$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4fold17hd505cf2677cea0f4E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core4iter8adapters7flatten26FlattenCompat$LT$I$C$U$GT$9iter_fold17hebf532c40ef9598dE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN116_$LT$core..iter..adapters..flatten..FlattenCompat$LT$I$C$U$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4fold7flatten28_$u7b$$u7b$closure$u7d$$u7d$17h94235c34ca7e623fE:
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
	bl	__ZN106_$LT$core..iter..adapters..chain..Chain$LT$A$C$B$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4fold17hd338b4e99b440b88E
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN116_$LT$core..iter..adapters..flatten..FlattenCompat$LT$I$C$U$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h890c077781a179a6E:
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
	sub	sp, sp, #576
	str	x8, [sp, #96]
	str	x0, [sp, #104]
	ldrb	w8, [x0, #68]
	subs	w8, w8, #9
	cset	x8, ne
	tbz	w8, #0, LBB34_2
	b	LBB34_1
LBB34_1:
	ldr	x8, [sp, #104]
	add	x8, x8, #32
	str	x8, [sp, #152]
	b	LBB34_3
LBB34_2:
	str	xzr, [sp, #152]
	b	LBB34_3
LBB34_3:
	str	xzr, [sp, #160]
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.3@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.3@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.3@PAGEOFF
	ldr	x9, [x9, l_anon.06e111bfef83652125d85ade023d82af.3@PAGEOFF]
	ldr	x8, [x8, #8]
	str	x9, [sp, #168]
	str	x8, [sp, #176]
	ldr	x0, [sp, #152]
	ldr	q0, [sp, #160]
	sub	x1, x29, #64
	stur	q0, [x29, #-64]
	ldr	x8, [sp, #176]
	stur	x8, [x29, #-48]
	add	x8, sp, #128
	bl	__ZN4core6option15Option$LT$T$GT$6map_or17h480d6d36d498b6c4E
	ldr	x8, [sp, #104]
	ldr	x9, [sp, #128]
	str	x9, [sp, #88]
	ldr	x10, [sp, #136]
	ldr	x9, [sp, #144]
	str	x10, [sp, #112]
	str	x9, [sp, #120]
	ldrb	w8, [x8, #108]
	subs	w8, w8, #9
	cset	x8, ne
	tbz	w8, #0, LBB34_5
	b	LBB34_4
LBB34_4:
	ldr	x8, [sp, #104]
	add	x8, x8, #72
	str	x8, [sp, #224]
	b	LBB34_6
LBB34_5:
	str	xzr, [sp, #224]
	b	LBB34_6
LBB34_6:
	ldr	x0, [sp, #224]
	add	x8, sp, #200
	add	x1, sp, #160
	bl	__ZN4core6option15Option$LT$T$GT$6map_or17h480d6d36d498b6c4E
	ldr	x8, [sp, #88]
	ldr	x9, [sp, #200]
	ldr	x11, [sp, #208]
	ldr	x10, [sp, #216]
	str	x11, [sp, #184]
	str	x10, [sp, #192]
	adds	x8, x8, x9
	cset	w9, hs
	ands	w9, w9, #0x1
	csinv	x8, x8, xzr, eq
	stur	x8, [x29, #-32]
	ldur	x8, [x29, #-32]
	str	x8, [sp, #80]
	bl	__ZN74_$LT$T$u20$as$u20$core..iter..adapters..flatten..ConstSizeIntoIterator$GT$4size17h0c63e9a1b15ecc2fE
	str	x0, [sp, #232]
	str	x1, [sp, #240]
	ldr	x8, [sp, #232]
	tbz	w8, #0, LBB34_8
	b	LBB34_7
LBB34_7:
	ldr	x8, [sp, #104]
	ldr	x9, [sp, #240]
	str	x9, [sp, #72]
	ldr	x8, [x8]
	subs	x8, x8, #0
	cset	x8, ne
	tbnz	w8, #0, LBB34_9
	b	LBB34_10
LBB34_8:
	ldr	x8, [sp, #104]
	ldr	x8, [x8]
	subs	x8, x8, #0
	cset	x8, ne
	tbnz	w8, #0, LBB34_34
	b	LBB34_35
LBB34_9:
	ldr	x0, [sp, #104]
	add	x8, sp, #264
	bl	__ZN102_$LT$core..iter..adapters..map..Map$LT$I$C$F$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h8a604b69993da85eE
	b	LBB34_11
LBB34_10:
	str	xzr, [sp, #264]
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.3@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.3@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.3@PAGEOFF
	ldr	x9, [x9, l_anon.06e111bfef83652125d85ade023d82af.3@PAGEOFF]
	ldr	x8, [x8, #8]
	str	x9, [sp, #272]
	str	x8, [sp, #280]
	b	LBB34_11
LBB34_11:
	ldr	x10, [sp, #72]
	ldr	x9, [sp, #264]
	ldr	x11, [sp, #272]
	ldr	x8, [sp, #280]
	str	x11, [sp, #248]
	str	x8, [sp, #256]
	umulh	x8, x9, x10
	mul	x9, x9, x10
	stur	x9, [x29, #-88]
	cbnz	x8, LBB34_13
	b	LBB34_12
LBB34_12:
	b	LBB34_14
LBB34_13:
	mov	x8, #-1
	stur	x8, [x29, #-88]
	b	LBB34_14
LBB34_14:
	ldr	x9, [sp, #80]
	ldur	x8, [x29, #-88]
	adds	x8, x8, x9
	cset	w9, hs
	ands	w9, w9, #0x1
	csinv	x8, x8, xzr, eq
	stur	x8, [x29, #-24]
	ldur	x8, [x29, #-24]
	str	x8, [sp, #64]
	ldr	x8, [sp, #112]
	tbz	w8, #0, LBB34_16
	b	LBB34_15
LBB34_15:
	ldr	x8, [sp, #120]
	stur	x8, [x29, #-216]
	stur	xzr, [x29, #-224]
	ldur	x8, [x29, #-216]
	str	x8, [sp, #56]
	ldr	x8, [sp, #184]
	tbnz	w8, #0, LBB34_18
	b	LBB34_19
LBB34_16:
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x9, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x8, [x8, #8]
	str	x9, [sp, #288]
	str	x8, [sp, #296]
	b	LBB34_17
LBB34_17:
	b	LBB34_30
LBB34_18:
	ldr	x9, [sp, #56]
	ldr	x8, [sp, #192]
	stur	x8, [x29, #-200]
	stur	xzr, [x29, #-208]
	ldur	x8, [x29, #-200]
	str	x8, [sp, #48]
	add	x8, x9, x8
	subs	x8, x8, x9
	b.lo	LBB34_22
	b	LBB34_21
LBB34_19:
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x9, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x8, [x8, #8]
	str	x9, [sp, #288]
	str	x8, [sp, #296]
	b	LBB34_20
LBB34_20:
	b	LBB34_32
LBB34_21:
	ldr	x8, [sp, #56]
	ldr	x9, [sp, #48]
	add	x8, x8, x9
	stur	x8, [x29, #-232]
	mov	w8, #1
	stur	x8, [x29, #-240]
	ldur	x8, [x29, #-232]
	stur	x8, [x29, #-248]
	stur	xzr, [x29, #-256]
	ldur	x8, [x29, #-248]
	str	x8, [sp, #40]
	ldr	x8, [sp, #248]
	tbnz	w8, #0, LBB34_23
	b	LBB34_24
LBB34_22:
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x11, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x10, [x8, #8]
	stur	x11, [x29, #-240]
	stur	x10, [x29, #-232]
	ldr	x9, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x8, [x8, #8]
	str	x9, [sp, #288]
	str	x8, [sp, #296]
	b	LBB34_20
LBB34_23:
	ldr	x9, [sp, #72]
	ldr	x8, [sp, #256]
	stur	x8, [x29, #-152]
	stur	xzr, [x29, #-160]
	ldur	x10, [x29, #-152]
	umulh	x8, x9, x10
	mul	x9, x9, x10
	str	x9, [sp, #32]
	cbnz	x8, LBB34_27
	b	LBB34_26
LBB34_24:
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x9, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x8, [x8, #8]
	str	x9, [sp, #288]
	str	x8, [sp, #296]
	b	LBB34_25
LBB34_25:
	b	LBB34_31
LBB34_26:
	ldr	x9, [sp, #40]
	ldr	x8, [sp, #32]
	stur	x8, [x29, #-168]
	mov	w8, #1
	stur	x8, [x29, #-176]
	ldur	x8, [x29, #-168]
	stur	x8, [x29, #-184]
	stur	xzr, [x29, #-192]
	ldur	x8, [x29, #-184]
	str	x8, [sp, #24]
	add	x8, x9, x8
	subs	x8, x8, x9
	b.lo	LBB34_29
	b	LBB34_28
LBB34_27:
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x11, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x10, [x8, #8]
	stur	x11, [x29, #-176]
	stur	x10, [x29, #-168]
	ldr	x9, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x8, [x8, #8]
	str	x9, [sp, #288]
	str	x8, [sp, #296]
	b	LBB34_25
LBB34_28:
	ldr	x8, [sp, #40]
	ldr	x9, [sp, #24]
	add	x8, x8, x9
	str	x8, [sp, #328]
	mov	w8, #1
	str	x8, [sp, #320]
	ldr	x9, [sp, #328]
	str	x9, [sp, #312]
	str	xzr, [sp, #304]
	ldr	x9, [sp, #312]
	str	x9, [sp, #296]
	str	x8, [sp, #288]
	b	LBB34_30
LBB34_29:
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x11, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x10, [x8, #8]
	str	x11, [sp, #320]
	str	x10, [sp, #328]
	ldr	x9, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x8, [x8, #8]
	str	x9, [sp, #288]
	str	x8, [sp, #296]
	b	LBB34_31
LBB34_30:
	ldr	x9, [sp, #96]
	ldr	x8, [sp, #64]
	str	x8, [x9]
	ldr	x10, [sp, #288]
	ldr	x8, [sp, #296]
	str	x10, [x9, #8]
	str	x8, [x9, #16]
	b	LBB34_33
LBB34_31:
	b	LBB34_32
LBB34_32:
	b	LBB34_17
LBB34_33:
	add	sp, sp, #576
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	ldp	x28, x27, [sp], #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w27
	.cfi_restore w28
	ret
LBB34_34:
	.cfi_restore_state
	ldr	x0, [sp, #104]
	sub	x8, x29, #144
	bl	__ZN102_$LT$core..iter..adapters..map..Map$LT$I$C$F$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h8a604b69993da85eE
	ldur	x8, [x29, #-144]
	ldur	x10, [x29, #-136]
	ldur	x9, [x29, #-128]
	stur	x10, [x29, #-80]
	stur	x9, [x29, #-72]
	cbz	x8, LBB34_39
	b	LBB34_37
LBB34_35:
	ldr	x8, [sp, #112]
	stur	x8, [x29, #-112]
	ldur	x8, [x29, #-112]
	tbz	w8, #0, LBB34_37
	b	LBB34_36
LBB34_36:
	ldr	x8, [sp, #184]
	stur	x8, [x29, #-120]
	ldur	x8, [x29, #-120]
	tbnz	w8, #0, LBB34_38
	b	LBB34_37
LBB34_37:
	ldr	x9, [sp, #96]
	ldr	x8, [sp, #80]
	str	x8, [x9]
	adrp	x10, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x10, [x10, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x8, [x8, #8]
	str	x10, [x9, #8]
	str	x8, [x9, #16]
	b	LBB34_46
LBB34_38:
	ldr	x9, [sp, #120]
	str	x9, [sp, #8]
	ldr	x8, [sp, #192]
	str	x8, [sp, #16]
	add	x8, x9, x8
	subs	x8, x8, x9
	b.lo	LBB34_44
	b	LBB34_43
LBB34_39:
	ldur	x8, [x29, #-80]
	tbz	w8, #0, LBB34_37
	b	LBB34_40
LBB34_40:
	ldr	x8, [sp, #112]
	stur	x8, [x29, #-112]
	ldur	x8, [x29, #-112]
	tbz	w8, #0, LBB34_37
	b	LBB34_41
LBB34_41:
	ldr	x8, [sp, #184]
	stur	x8, [x29, #-120]
	ldur	x8, [x29, #-120]
	tbz	w8, #0, LBB34_37
	b	LBB34_42
LBB34_42:
	ldur	x8, [x29, #-72]
	cbz	x8, LBB34_38
	b	LBB34_37
LBB34_43:
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #16]
	add	x8, x8, x9
	stur	x8, [x29, #-96]
	mov	w8, #1
	stur	x8, [x29, #-104]
	b	LBB34_45
LBB34_44:
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x9, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x8, [x8, #8]
	stur	x9, [x29, #-104]
	stur	x8, [x29, #-96]
	b	LBB34_45
LBB34_45:
	ldr	x9, [sp, #96]
	ldr	x8, [sp, #80]
	str	x8, [x9]
	ldur	x10, [x29, #-104]
	ldur	x8, [x29, #-96]
	str	x10, [x9, #8]
	str	x8, [x9, #16]
	b	LBB34_46
LBB34_46:
	b	LBB34_33
	.cfi_endproc

	.p2align	2
__ZN116_$LT$proc_macro..TokenStream$u20$as$u20$core..iter..traits..collect..FromIterator$LT$proc_macro..TokenStream$GT$$GT$9from_iter17h1c06a2033e1d662dE:
Lfunc_begin17:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception17
	sub	sp, sp, #144
	.cfi_def_cfa_offset 144
	stp	x29, x30, [sp, #128]
	add	x29, sp, #128
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	bl	__ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17ha12260cd5ae5105bE
	mov	x8, x0
	add	x0, sp, #16
	str	x8, [sp, #16]
	str	x1, [sp, #24]
	mov	w8, #1
	sturb	w8, [x29, #-17]
Ltmp146:
	add	x8, sp, #56
	bl	__ZN104_$LT$core..iter..adapters..cloned..Cloned$LT$I$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h2122470db3102a0bE
Ltmp147:
	b	LBB35_3
LBB35_1:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB35_12
	b	LBB35_11
LBB35_2:
Ltmp150:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB35_1
LBB35_3:
	ldr	x0, [sp, #56]
Ltmp148:
	add	x8, sp, #32
	bl	__RNvMsf_Cs7B2A3P5pSWO_10proc_macroNtB5_19ConcatStreamsHelper3new
Ltmp149:
	b	LBB35_4
LBB35_4:
	mov	w8, #1
	sturb	w8, [x29, #-18]
	sturb	wzr, [x29, #-17]
	ldr	x0, [sp, #16]
	ldr	x1, [sp, #24]
Ltmp151:
	add	x2, sp, #32
	bl	__ZN4core4iter6traits8iterator8Iterator8for_each17h7662e2bc614d6b17E
Ltmp152:
	b	LBB35_7
LBB35_5:
	ldurb	w8, [x29, #-18]
	tbnz	w8, #0, LBB35_9
	b	LBB35_1
LBB35_6:
Ltmp155:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB35_5
LBB35_7:
	sturb	wzr, [x29, #-18]
	ldr	q0, [sp, #32]
	sub	x0, x29, #48
	stur	q0, [x29, #-48]
	ldr	x8, [sp, #48]
	stur	x8, [x29, #-32]
Ltmp153:
	bl	__RNvMsf_Cs7B2A3P5pSWO_10proc_macroNtB5_19ConcatStreamsHelper5build
	str	w0, [sp, #12]
Ltmp154:
	b	LBB35_8
LBB35_8:
	ldr	w0, [sp, #12]
	.cfi_def_cfa wsp, 144
	ldp	x29, x30, [sp, #128]
	add	sp, sp, #144
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB35_9:
	.cfi_restore_state
Ltmp156:
	add	x0, sp, #32
	bl	__ZN4core3ptr52drop_in_place$LT$proc_macro..ConcatStreamsHelper$GT$17h6e516cabcfebb7daE
Ltmp157:
	b	LBB35_1
LBB35_10:
Ltmp158:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB35_11:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB35_12:
	b	LBB35_11
Lfunc_end17:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table35:
Lexception17:
	.byte	255
	.byte	155
	.uleb128 Lttbase10-Lttbaseref10
Lttbaseref10:
	.byte	1
	.uleb128 Lcst_end17-Lcst_begin17
Lcst_begin17:
	.uleb128 Lfunc_begin17-Lfunc_begin17
	.uleb128 Ltmp146-Lfunc_begin17
	.byte	0
	.byte	0
	.uleb128 Ltmp146-Lfunc_begin17
	.uleb128 Ltmp149-Ltmp146
	.uleb128 Ltmp150-Lfunc_begin17
	.byte	0
	.uleb128 Ltmp151-Lfunc_begin17
	.uleb128 Ltmp154-Ltmp151
	.uleb128 Ltmp155-Lfunc_begin17
	.byte	0
	.uleb128 Ltmp156-Lfunc_begin17
	.uleb128 Ltmp157-Ltmp156
	.uleb128 Ltmp158-Lfunc_begin17
	.byte	1
	.uleb128 Ltmp157-Lfunc_begin17
	.uleb128 Lfunc_end17-Ltmp157
	.byte	0
	.byte	0
Lcst_end17:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase10:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN116_$LT$proc_macro..TokenStream$u20$as$u20$core..iter..traits..collect..FromIterator$LT$proc_macro..TokenStream$GT$$GT$9from_iter28_$u7b$$u7b$closure$u7d$$u7d$17h627a2b6ae081ff0dE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x0, [x0]
	bl	__RNvMsf_Cs7B2A3P5pSWO_10proc_macroNtB5_19ConcatStreamsHelper4push
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN153_$LT$core..result..Result$LT$T$C$F$GT$$u20$as$u20$core..ops..try_trait..FromResidual$LT$core..result..Result$LT$core..convert..Infallible$C$E$GT$$GT$$GT$13from_residual17h4f6827c52a97bf8eE:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	brk	#0x1
	.cfi_endproc

	.p2align	2
__ZN153_$LT$core..result..Result$LT$T$C$F$GT$$u20$as$u20$core..ops..try_trait..FromResidual$LT$core..result..Result$LT$core..convert..Infallible$C$E$GT$$GT$$GT$13from_residual17h9ed7761eac753b6dE:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN153_$LT$core..result..Result$LT$T$C$F$GT$$u20$as$u20$core..ops..try_trait..FromResidual$LT$core..result..Result$LT$core..convert..Infallible$C$E$GT$$GT$$GT$13from_residual17hb328f6e95c9b99a2E:
	.cfi_startproc
	str	w0, [x8, #8]
	str	xzr, [x8]
	ret
	.cfi_endproc

	.p2align	2
__ZN157_$LT$$LT$alloc..vec..into_iter..IntoIter$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$..drop..DropGuard$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17he1d5e7b9fb93f404E:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x8, [x0]
	ldr	x9, [x8]
	str	x9, [sp, #8]
	ldr	x8, [x8, #16]
	str	x8, [sp, #16]
	b	LBB40_1
LBB40_1:
	ldr	x8, [sp, #16]
	stur	x8, [x29, #-8]
	b	LBB40_2
LBB40_2:
	ldr	x8, [sp, #8]
	ldur	x9, [x29, #-8]
	add	x0, sp, #24
	str	x9, [sp, #24]
	str	x8, [sp, #32]
	bl	__ZN4core3ptr53drop_in_place$LT$alloc..raw_vec..RawVec$LT$u8$GT$$GT$17h5f45389c4a49b664E
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN18const_random_macro12const_random17hed569f3c63c5ee75E:
Lfunc_begin18:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception18
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
	sub	sp, sp, #1328
	str	xzr, [sp]
	mov	x8, x0
	add	x0, sp, #424
	str	w8, [sp, #424]
	sturb	wzr, [x29, #-57]
	sturb	wzr, [x29, #-58]
	sturb	wzr, [x29, #-59]
Ltmp160:
	add	x8, sp, #448
	bl	__ZN45_$LT$T$u20$as$u20$alloc..string..ToString$GT$9to_string17hfcad322ed6d0360fE
Ltmp161:
	b	LBB41_3
LBB41_1:
Ltmp386:
	add	x0, sp, #424
	bl	__ZN4core3ptr44drop_in_place$LT$proc_macro..TokenStream$GT$17h125cfb6c70942766E
Ltmp387:
	b	LBB41_157
LBB41_2:
Ltmp385:
	stur	x0, [x29, #-56]
	mov	x8, x1
	stur	w8, [x29, #-48]
	b	LBB41_1
LBB41_3:
Ltmp162:
	add	x0, sp, #448
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.7@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.7@PAGEOFF
	bl	__ZN74_$LT$alloc..string..String$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17hc9406cecbd0821f2E
	str	x0, [sp, #408]
	str	x1, [sp, #416]
Ltmp163:
	b	LBB41_7
LBB41_4:
Ltmp381:
	add	x0, sp, #448
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17ha9d9ccced2dc1daeE
Ltmp382:
	b	LBB41_1
LBB41_5:
Ltmp380:
	mov	x8, x1
	str	x0, [sp, #392]
	str	w8, [sp, #404]
	b	LBB41_6
LBB41_6:
	ldr	x9, [sp, #392]
	ldr	w8, [sp, #404]
	stur	x9, [x29, #-56]
	stur	w8, [x29, #-48]
	b	LBB41_4
LBB41_7:
	ldr	x8, [sp, #416]
	ldr	x9, [sp, #408]
	str	x9, [sp, #432]
	str	x8, [sp, #440]
	ldr	x0, [sp, #432]
	ldr	x1, [sp, #440]
Ltmp164:
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.8@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.8@PAGEOFF
	mov	w8, #2
	mov	x3, x8
	bl	__ZN4core3str6traits54_$LT$impl$u20$core..cmp..PartialEq$u20$for$u20$str$GT$2eq17ha8f8586c4cffa0c6E
	str	w0, [sp, #388]
Ltmp165:
	b	LBB41_8
LBB41_8:
	ldr	w8, [sp, #388]
	tbnz	w8, #0, LBB41_10
	b	LBB41_9
LBB41_9:
	ldr	x0, [sp, #432]
	ldr	x1, [sp, #440]
Ltmp166:
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.9@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.9@PAGEOFF
	mov	w8, #3
	mov	x3, x8
	bl	__ZN4core3str6traits54_$LT$impl$u20$core..cmp..PartialEq$u20$for$u20$str$GT$2eq17ha8f8586c4cffa0c6E
	str	w0, [sp, #384]
Ltmp167:
	b	LBB41_11
LBB41_10:
Ltmp372:
	bl	__ZN18const_random_macro4span10gen_random17h2c504a1c5adb7015E
	str	w0, [sp, #380]
Ltmp373:
	b	LBB41_152
LBB41_11:
	ldr	w8, [sp, #384]
	tbnz	w8, #0, LBB41_13
	b	LBB41_12
LBB41_12:
	ldr	x0, [sp, #432]
	ldr	x1, [sp, #440]
Ltmp168:
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.10@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.10@PAGEOFF
	mov	w8, #3
	mov	x3, x8
	bl	__ZN4core3str6traits54_$LT$impl$u20$core..cmp..PartialEq$u20$for$u20$str$GT$2eq17ha8f8586c4cffa0c6E
	str	w0, [sp, #376]
Ltmp169:
	b	LBB41_14
LBB41_13:
Ltmp364:
	bl	__ZN18const_random_macro4span10gen_random17h1524926fcd3cf93aE
	str	w0, [sp, #372]
Ltmp365:
	b	LBB41_148
LBB41_14:
	ldr	w8, [sp, #376]
	tbnz	w8, #0, LBB41_16
	b	LBB41_15
LBB41_15:
	ldr	x0, [sp, #432]
	ldr	x1, [sp, #440]
Ltmp170:
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.11@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.11@PAGEOFF
	mov	w8, #3
	mov	x3, x8
	bl	__ZN4core3str6traits54_$LT$impl$u20$core..cmp..PartialEq$u20$for$u20$str$GT$2eq17ha8f8586c4cffa0c6E
	str	w0, [sp, #368]
Ltmp171:
	b	LBB41_17
LBB41_16:
Ltmp356:
	bl	__ZN18const_random_macro4span10gen_random17h43c9fdad22a7f346E
	str	w0, [sp, #364]
Ltmp357:
	b	LBB41_144
LBB41_17:
	ldr	w8, [sp, #368]
	tbnz	w8, #0, LBB41_19
	b	LBB41_18
LBB41_18:
	ldr	x0, [sp, #432]
	ldr	x1, [sp, #440]
Ltmp172:
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.12@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.12@PAGEOFF
	mov	w8, #4
	mov	x3, x8
	bl	__ZN4core3str6traits54_$LT$impl$u20$core..cmp..PartialEq$u20$for$u20$str$GT$2eq17ha8f8586c4cffa0c6E
	str	w0, [sp, #360]
Ltmp173:
	b	LBB41_20
LBB41_19:
Ltmp348:
	bl	__ZN18const_random_macro4span10gen_random17hd3bd3f4db4428d03E
	str	x0, [sp, #352]
Ltmp349:
	b	LBB41_140
LBB41_20:
	ldr	w8, [sp, #360]
	tbnz	w8, #0, LBB41_22
	b	LBB41_21
LBB41_21:
	ldr	x0, [sp, #432]
	ldr	x1, [sp, #440]
Ltmp174:
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.13@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.13@PAGEOFF
	mov	w8, #2
	mov	x3, x8
	bl	__ZN4core3str6traits54_$LT$impl$u20$core..cmp..PartialEq$u20$for$u20$str$GT$2eq17ha8f8586c4cffa0c6E
	str	w0, [sp, #348]
Ltmp175:
	b	LBB41_23
LBB41_22:
Ltmp340:
	bl	__ZN18const_random_macro4span10gen_random17h1c1de6b81bbd8f0eE
	str	x0, [sp, #328]
	str	x1, [sp, #336]
Ltmp341:
	b	LBB41_136
LBB41_23:
	ldr	w8, [sp, #348]
	tbnz	w8, #0, LBB41_25
	b	LBB41_24
LBB41_24:
	ldr	x0, [sp, #432]
	ldr	x1, [sp, #440]
Ltmp176:
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.14@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.14@PAGEOFF
	mov	w8, #3
	mov	x3, x8
	bl	__ZN4core3str6traits54_$LT$impl$u20$core..cmp..PartialEq$u20$for$u20$str$GT$2eq17ha8f8586c4cffa0c6E
	str	w0, [sp, #324]
Ltmp177:
	b	LBB41_26
LBB41_25:
Ltmp332:
	bl	__ZN18const_random_macro4span10gen_random17hebd05bf50dcc13c6E
	str	w0, [sp, #320]
Ltmp333:
	b	LBB41_132
LBB41_26:
	ldr	w8, [sp, #324]
	tbnz	w8, #0, LBB41_28
	b	LBB41_27
LBB41_27:
	ldr	x0, [sp, #432]
	ldr	x1, [sp, #440]
Ltmp178:
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.15@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.15@PAGEOFF
	mov	w8, #3
	mov	x3, x8
	bl	__ZN4core3str6traits54_$LT$impl$u20$core..cmp..PartialEq$u20$for$u20$str$GT$2eq17ha8f8586c4cffa0c6E
	str	w0, [sp, #316]
Ltmp179:
	b	LBB41_29
LBB41_28:
Ltmp324:
	bl	__ZN18const_random_macro4span10gen_random17h0cae054c074a3ff3E
	str	w0, [sp, #312]
Ltmp325:
	b	LBB41_128
LBB41_29:
	ldr	w8, [sp, #316]
	tbnz	w8, #0, LBB41_31
	b	LBB41_30
LBB41_30:
	ldr	x0, [sp, #432]
	ldr	x1, [sp, #440]
Ltmp180:
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.16@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.16@PAGEOFF
	mov	w8, #3
	mov	x3, x8
	bl	__ZN4core3str6traits54_$LT$impl$u20$core..cmp..PartialEq$u20$for$u20$str$GT$2eq17ha8f8586c4cffa0c6E
	str	w0, [sp, #308]
Ltmp181:
	b	LBB41_32
LBB41_31:
Ltmp316:
	bl	__ZN18const_random_macro4span10gen_random17h150d0b6f564bfb38E
	str	w0, [sp, #304]
Ltmp317:
	b	LBB41_124
LBB41_32:
	ldr	w8, [sp, #308]
	tbnz	w8, #0, LBB41_34
	b	LBB41_33
LBB41_33:
	ldr	x0, [sp, #432]
	ldr	x1, [sp, #440]
Ltmp182:
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.17@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.17@PAGEOFF
	mov	w8, #4
	mov	x3, x8
	bl	__ZN4core3str6traits54_$LT$impl$u20$core..cmp..PartialEq$u20$for$u20$str$GT$2eq17ha8f8586c4cffa0c6E
	str	w0, [sp, #300]
Ltmp183:
	b	LBB41_35
LBB41_34:
Ltmp308:
	bl	__ZN18const_random_macro4span10gen_random17had5ee0c4e4f5adbdE
	str	x0, [sp, #288]
Ltmp309:
	b	LBB41_120
LBB41_35:
	ldr	w8, [sp, #300]
	tbnz	w8, #0, LBB41_37
	b	LBB41_36
LBB41_36:
	ldr	x0, [sp, #432]
	ldr	x1, [sp, #440]
Ltmp184:
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.18@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.18@PAGEOFF
	mov	w8, #5
	mov	x3, x8
	bl	__ZN4core3str6traits54_$LT$impl$u20$core..cmp..PartialEq$u20$for$u20$str$GT$2eq17ha8f8586c4cffa0c6E
	str	w0, [sp, #284]
Ltmp185:
	b	LBB41_38
LBB41_37:
Ltmp300:
	bl	__ZN18const_random_macro4span10gen_random17h218587e517d588d0E
	str	x0, [sp, #264]
	str	x1, [sp, #272]
Ltmp301:
	b	LBB41_116
LBB41_38:
	ldr	w8, [sp, #284]
	tbnz	w8, #0, LBB41_40
	b	LBB41_39
LBB41_39:
	ldr	x0, [sp, #432]
	ldr	x1, [sp, #440]
Ltmp186:
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.19@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.19@PAGEOFF
	mov	w8, #5
	mov	x3, x8
	bl	__ZN4core3str6traits54_$LT$impl$u20$core..cmp..PartialEq$u20$for$u20$str$GT$2eq17ha8f8586c4cffa0c6E
	str	w0, [sp, #260]
Ltmp187:
	b	LBB41_41
LBB41_40:
Ltmp262:
	bl	__ZN18const_random_macro4span10gen_random17h1c1de6b81bbd8f0eE
	str	x0, [sp, #240]
	str	x1, [sp, #248]
Ltmp263:
	b	LBB41_94
LBB41_41:
	ldr	w8, [sp, #260]
	tbnz	w8, #0, LBB41_43
	b	LBB41_42
LBB41_42:
	ldr	x0, [sp, #432]
	ldr	x1, [sp, #440]
Ltmp188:
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.20@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.20@PAGEOFF
	mov	w8, #6
	mov	x3, x8
	bl	__ZN4core3str21_$LT$impl$u20$str$GT$11starts_with17hd01ec385fb552c31E
	str	w0, [sp, #236]
Ltmp189:
	b	LBB41_44
LBB41_43:
Ltmp224:
	bl	__ZN18const_random_macro4span10gen_random17h218587e517d588d0E
	str	x0, [sp, #216]
	str	x1, [sp, #224]
Ltmp225:
	b	LBB41_72
LBB41_44:
	ldr	w8, [sp, #236]
	tbnz	w8, #0, LBB41_46
	b	LBB41_45
LBB41_45:
Ltmp192:
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.21@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.21@PAGEOFF
	mov	w8, #12
	mov	x1, x8
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.22@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.22@PAGEOFF
	bl	__RINvNtCsaLOjE9VYtxK_3std9panicking11begin_panicReEB4_
Ltmp193:
	b	LBB41_49
LBB41_46:
	ldr	x0, [sp, #432]
	ldr	x1, [sp, #440]
Ltmp190:
	mov	w2, #93
	bl	__ZN4core3str21_$LT$impl$u20$str$GT$9ends_with17h71ce4646b64925e0E
	str	w0, [sp, #212]
Ltmp191:
	b	LBB41_47
LBB41_47:
	ldr	w8, [sp, #212]
	tbz	w8, #0, LBB41_45
	b	LBB41_48
LBB41_48:
	ldr	x0, [sp, #432]
	ldr	x1, [sp, #440]
Ltmp194:
	bl	__ZN4core3str21_$LT$impl$u20$str$GT$3len17hdb37fd8006602fe7E
	str	x0, [sp, #200]
Ltmp195:
	b	LBB41_50
LBB41_49:
	brk	#0x1
LBB41_50:
	ldr	x8, [sp, #200]
	subs	x3, x8, #1
	ldr	x0, [sp, #432]
	ldr	x1, [sp, #440]
Ltmp196:
	mov	w8, #6
	mov	x2, x8
	adrp	x4, l_anon.06e111bfef83652125d85ade023d82af.23@PAGE
	add	x4, x4, l_anon.06e111bfef83652125d85ade023d82af.23@PAGEOFF
	bl	__ZN4core3str6traits66_$LT$impl$u20$core..ops..index..Index$LT$I$GT$$u20$for$u20$str$GT$5index17hea957e09c6f26f25E
	str	x0, [sp, #184]
	str	x1, [sp, #192]
Ltmp197:
	b	LBB41_51
LBB41_51:
Ltmp198:
	ldr	x1, [sp, #192]
	ldr	x0, [sp, #184]
	add	x8, sp, #1032
	bl	__ZN4core3str21_$LT$impl$u20$str$GT$5parse17ha478563f57f82201E
Ltmp199:
	b	LBB41_52
LBB41_52:
	ldrb	w8, [sp, #1032]
	tbz	w8, #0, LBB41_56
	b	LBB41_53
LBB41_53:
	ldrb	w8, [sp, #1033]
	sub	x2, x29, #33
	sturb	w8, [x29, #-33]
Ltmp221:
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.82@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.82@PAGEOFF
	mov	w8, #43
	mov	x1, x8
	adrp	x3, l_anon.06e111bfef83652125d85ade023d82af.83@PAGE
	add	x3, x3, l_anon.06e111bfef83652125d85ade023d82af.83@PAGEOFF
	adrp	x4, l_anon.06e111bfef83652125d85ade023d82af.24@PAGE
	add	x4, x4, l_anon.06e111bfef83652125d85ade023d82af.24@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core6result13unwrap_failed
Ltmp222:
	b	LBB41_55
LBB41_54:
Ltmp223:
	stur	x0, [x29, #-32]
	mov	x8, x1
	stur	w8, [x29, #-24]
	ldur	x9, [x29, #-32]
	ldur	w8, [x29, #-24]
	str	x9, [sp, #392]
	str	w8, [sp, #404]
	b	LBB41_6
LBB41_55:
	brk	#0x1
LBB41_56:
	ldr	x8, [sp, #1040]
	str	x8, [sp, #176]
	b	LBB41_57
LBB41_57:
Ltmp200:
	ldr	x1, [sp, #176]
	add	x8, sp, #1048
	mov	w0, #0
	bl	__ZN5alloc3vec9from_elem17heee2863500f34816E
Ltmp201:
	b	LBB41_58
LBB41_58:
	mov	w8, #1
	sturb	w8, [x29, #-59]
Ltmp202:
	add	x0, sp, #1048
	bl	__ZN75_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..deref..DerefMut$GT$9deref_mut17hc1481fc12fb042caE
	str	x0, [sp, #160]
	str	x1, [sp, #168]
Ltmp203:
	b	LBB41_61
LBB41_59:
	ldurb	w8, [x29, #-59]
	tbnz	w8, #0, LBB41_70
	b	LBB41_4
LBB41_60:
Ltmp218:
	stur	x0, [x29, #-56]
	mov	x8, x1
	stur	w8, [x29, #-48]
	b	LBB41_59
LBB41_61:
Ltmp204:
	ldr	x1, [sp, #168]
	ldr	x0, [sp, #160]
	bl	__ZN18const_random_macro4span16gen_random_bytes17h12b5086f33a0b307E
Ltmp205:
	b	LBB41_62
LBB41_62:
	sturb	wzr, [x29, #-59]
	add	x8, sp, #793
	ldur	q0, [x8, #255]
	sub	x0, x29, #128
	stur	q0, [x29, #-128]
	ldr	x8, [sp, #1064]
	stur	x8, [x29, #-112]
Ltmp206:
	sub	x8, x29, #160
	bl	__ZN90_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17hb373e9f63ca0e427E
Ltmp207:
	b	LBB41_63
LBB41_63:
Ltmp208:
	add	x8, sp, #1072
	sub	x0, x29, #160
	bl	__ZN4core4iter6traits8iterator8Iterator8flat_map17h3bd303bbb043848dE
Ltmp209:
	b	LBB41_64
LBB41_64:
Ltmp210:
	add	x0, sp, #1072
	bl	__ZN4core4iter6traits8iterator8Iterator7collect17h178ff8388afd9ce4E
	str	w0, [sp, #156]
Ltmp211:
	b	LBB41_65
LBB41_65:
Ltmp212:
	ldr	w1, [sp, #156]
	sub	x8, x29, #80
	mov	w0, #2
	bl	__RNvMsz_Cs7B2A3P5pSWO_10proc_macroNtB5_5Group3new
Ltmp213:
	b	LBB41_66
LBB41_66:
Ltmp214:
	sub	x8, x29, #100
	sub	x0, x29, #80
	bl	__ZN86_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Group$GT$$GT$4from17h2679b878fbe3513bE
Ltmp215:
	b	LBB41_67
LBB41_67:
Ltmp216:
	sub	x0, x29, #100
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.25@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.25@PAGEOFF
	bl	__ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h1edeed61ada33503E
	str	w0, [sp, #152]
Ltmp217:
	b	LBB41_68
LBB41_68:
	ldr	w8, [sp, #152]
	str	w8, [sp, #428]
	sturb	wzr, [x29, #-59]
	b	LBB41_69
LBB41_69:
Ltmp383:
	add	x0, sp, #448
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17ha9d9ccced2dc1daeE
Ltmp384:
	b	LBB41_156
LBB41_70:
Ltmp219:
	add	x0, sp, #1048
	bl	__ZN4core3ptr46drop_in_place$LT$alloc..vec..Vec$LT$u8$GT$$GT$17h2f7b2d448e5199ebE
Ltmp220:
	b	LBB41_4
LBB41_71:
Ltmp388:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB41_72:
Ltmp226:
	ldr	x1, [sp, #224]
	ldr	x0, [sp, #216]
	add	x8, sp, #952
	bl	__RNvMsM_Cs7B2A3P5pSWO_10proc_macroNtB5_7Literal13i128_suffixed
Ltmp227:
	b	LBB41_73
LBB41_73:
Ltmp228:
	add	x8, sp, #932
	add	x0, sp, #952
	bl	__ZN88_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Literal$GT$$GT$4from17hd488e0f50b18ea9aE
Ltmp229:
	b	LBB41_74
LBB41_74:
Ltmp230:
	add	x0, sp, #932
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.26@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.26@PAGEOFF
	bl	__ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h1edeed61ada33503E
	str	w0, [sp, #148]
Ltmp231:
	b	LBB41_75
LBB41_75:
	ldr	w8, [sp, #148]
	str	w8, [sp, #984]
Ltmp232:
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.27@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.27@PAGEOFF
	mov	w8, #2
	mov	x1, x8
	bl	__ZN18const_random_macro5ident17h523ccc2407baed6dE
	str	w0, [sp, #144]
Ltmp233:
	b	LBB41_78
LBB41_76:
Ltmp240:
	add	x0, sp, #984
	bl	__ZN4core3ptr44drop_in_place$LT$proc_macro..TokenStream$GT$17h125cfb6c70942766E
Ltmp241:
	b	LBB41_4
LBB41_77:
Ltmp234:
	stur	x0, [x29, #-56]
	mov	x8, x1
	stur	w8, [x29, #-48]
	b	LBB41_76
LBB41_78:
	ldr	w8, [sp, #144]
	str	w8, [sp, #988]
Ltmp235:
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.19@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.19@PAGEOFF
	mov	w8, #5
	mov	x1, x8
	bl	__ZN18const_random_macro5ident17h523ccc2407baed6dE
	str	w0, [sp, #140]
Ltmp236:
	b	LBB41_81
LBB41_79:
Ltmp238:
	add	x0, sp, #988
	bl	__ZN4core3ptr44drop_in_place$LT$proc_macro..TokenStream$GT$17h125cfb6c70942766E
Ltmp239:
	b	LBB41_76
LBB41_80:
Ltmp237:
	stur	x0, [x29, #-56]
	mov	x8, x1
	stur	w8, [x29, #-48]
	b	LBB41_79
LBB41_81:
	ldr	w8, [sp, #140]
	ldr	w9, [sp, #984]
	add	x0, sp, #972
	str	w9, [sp, #972]
	ldr	w9, [sp, #988]
	str	w9, [sp, #976]
	str	w8, [sp, #980]
Ltmp242:
	mov	w8, #3
	mov	x1, x8
	bl	__ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4iter17h5030a3cb3195ee5fE
	str	x0, [sp, #120]
	str	x1, [sp, #128]
Ltmp243:
	b	LBB41_84
LBB41_82:
Ltmp249:
	add	x0, sp, #972
	bl	__ZN4core3ptr65drop_in_place$LT$$u5b$proc_macro..TokenStream$u3b$$u20$3$u5d$$GT$17haab9bdcebd5db8faE
Ltmp250:
	b	LBB41_4
LBB41_83:
Ltmp248:
	stur	x0, [x29, #-56]
	mov	x8, x1
	stur	w8, [x29, #-48]
	b	LBB41_82
LBB41_84:
Ltmp244:
	ldr	x1, [sp, #128]
	ldr	x0, [sp, #120]
	bl	__ZN4core4iter6traits8iterator8Iterator6cloned17hc8e2f1f2c81e11d7E
	str	x0, [sp, #104]
	str	x1, [sp, #112]
Ltmp245:
	b	LBB41_85
LBB41_85:
Ltmp246:
	ldr	x1, [sp, #112]
	ldr	x0, [sp, #104]
	bl	__ZN4core4iter6traits8iterator8Iterator7collect17h775ad43be0eafc62E
	str	w0, [sp, #100]
Ltmp247:
	b	LBB41_86
LBB41_86:
	ldr	w8, [sp, #100]
	str	w8, [sp, #968]
	mov	w8, #1
	sturb	w8, [x29, #-58]
Ltmp251:
	add	x0, sp, #972
	bl	__ZN4core3ptr65drop_in_place$LT$$u5b$proc_macro..TokenStream$u3b$$u20$3$u5d$$GT$17haab9bdcebd5db8faE
Ltmp252:
	b	LBB41_89
LBB41_87:
	ldurb	w8, [x29, #-58]
	tbnz	w8, #0, LBB41_93
	b	LBB41_4
LBB41_88:
Ltmp259:
	stur	x0, [x29, #-56]
	mov	x8, x1
	stur	w8, [x29, #-48]
	b	LBB41_87
LBB41_89:
	sturb	wzr, [x29, #-58]
	ldr	w1, [sp, #968]
Ltmp253:
	add	x8, sp, #1012
	mov	w0, #0
	bl	__RNvMsz_Cs7B2A3P5pSWO_10proc_macroNtB5_5Group3new
Ltmp254:
	b	LBB41_90
LBB41_90:
Ltmp255:
	add	x8, sp, #992
	add	x0, sp, #1012
	bl	__ZN86_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Group$GT$$GT$4from17h2679b878fbe3513bE
Ltmp256:
	b	LBB41_91
LBB41_91:
Ltmp257:
	add	x0, sp, #992
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.28@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.28@PAGEOFF
	bl	__ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h1edeed61ada33503E
	str	w0, [sp, #96]
Ltmp258:
	b	LBB41_92
LBB41_92:
	ldr	w8, [sp, #96]
	str	w8, [sp, #428]
	sturb	wzr, [x29, #-58]
	b	LBB41_69
LBB41_93:
Ltmp260:
	add	x0, sp, #968
	bl	__ZN4core3ptr44drop_in_place$LT$proc_macro..TokenStream$GT$17h125cfb6c70942766E
Ltmp261:
	b	LBB41_4
LBB41_94:
Ltmp264:
	ldr	x1, [sp, #248]
	ldr	x0, [sp, #240]
	add	x8, sp, #852
	bl	__RNvMsM_Cs7B2A3P5pSWO_10proc_macroNtB5_7Literal13u128_suffixed
Ltmp265:
	b	LBB41_95
LBB41_95:
Ltmp266:
	add	x8, sp, #832
	add	x0, sp, #852
	bl	__ZN88_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Literal$GT$$GT$4from17hd488e0f50b18ea9aE
Ltmp267:
	b	LBB41_96
LBB41_96:
Ltmp268:
	add	x0, sp, #832
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.29@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.29@PAGEOFF
	bl	__ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h1edeed61ada33503E
	str	w0, [sp, #92]
Ltmp269:
	b	LBB41_97
LBB41_97:
	ldr	w8, [sp, #92]
	str	w8, [sp, #884]
Ltmp270:
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.27@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.27@PAGEOFF
	mov	w8, #2
	mov	x1, x8
	bl	__ZN18const_random_macro5ident17h523ccc2407baed6dE
	str	w0, [sp, #88]
Ltmp271:
	b	LBB41_100
LBB41_98:
Ltmp278:
	add	x0, sp, #884
	bl	__ZN4core3ptr44drop_in_place$LT$proc_macro..TokenStream$GT$17h125cfb6c70942766E
Ltmp279:
	b	LBB41_4
LBB41_99:
Ltmp272:
	stur	x0, [x29, #-56]
	mov	x8, x1
	stur	w8, [x29, #-48]
	b	LBB41_98
LBB41_100:
	ldr	w8, [sp, #88]
	str	w8, [sp, #888]
Ltmp273:
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.18@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.18@PAGEOFF
	mov	w8, #5
	mov	x1, x8
	bl	__ZN18const_random_macro5ident17h523ccc2407baed6dE
	str	w0, [sp, #84]
Ltmp274:
	b	LBB41_103
LBB41_101:
Ltmp276:
	add	x0, sp, #888
	bl	__ZN4core3ptr44drop_in_place$LT$proc_macro..TokenStream$GT$17h125cfb6c70942766E
Ltmp277:
	b	LBB41_98
LBB41_102:
Ltmp275:
	stur	x0, [x29, #-56]
	mov	x8, x1
	stur	w8, [x29, #-48]
	b	LBB41_101
LBB41_103:
	ldr	w8, [sp, #84]
	ldr	w9, [sp, #884]
	add	x0, sp, #872
	str	w9, [sp, #872]
	ldr	w9, [sp, #888]
	str	w9, [sp, #876]
	str	w8, [sp, #880]
Ltmp280:
	mov	w8, #3
	mov	x1, x8
	bl	__ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4iter17h5030a3cb3195ee5fE
	str	x0, [sp, #64]
	str	x1, [sp, #72]
Ltmp281:
	b	LBB41_106
LBB41_104:
Ltmp287:
	add	x0, sp, #872
	bl	__ZN4core3ptr65drop_in_place$LT$$u5b$proc_macro..TokenStream$u3b$$u20$3$u5d$$GT$17haab9bdcebd5db8faE
Ltmp288:
	b	LBB41_4
LBB41_105:
Ltmp286:
	stur	x0, [x29, #-56]
	mov	x8, x1
	stur	w8, [x29, #-48]
	b	LBB41_104
LBB41_106:
Ltmp282:
	ldr	x1, [sp, #72]
	ldr	x0, [sp, #64]
	bl	__ZN4core4iter6traits8iterator8Iterator6cloned17hc8e2f1f2c81e11d7E
	str	x0, [sp, #48]
	str	x1, [sp, #56]
Ltmp283:
	b	LBB41_107
LBB41_107:
Ltmp284:
	ldr	x1, [sp, #56]
	ldr	x0, [sp, #48]
	bl	__ZN4core4iter6traits8iterator8Iterator7collect17h775ad43be0eafc62E
	str	w0, [sp, #44]
Ltmp285:
	b	LBB41_108
LBB41_108:
	ldr	w8, [sp, #44]
	str	w8, [sp, #868]
	mov	w8, #1
	sturb	w8, [x29, #-57]
Ltmp289:
	add	x0, sp, #872
	bl	__ZN4core3ptr65drop_in_place$LT$$u5b$proc_macro..TokenStream$u3b$$u20$3$u5d$$GT$17haab9bdcebd5db8faE
Ltmp290:
	b	LBB41_111
LBB41_109:
	ldurb	w8, [x29, #-57]
	tbnz	w8, #0, LBB41_115
	b	LBB41_4
LBB41_110:
Ltmp297:
	stur	x0, [x29, #-56]
	mov	x8, x1
	stur	w8, [x29, #-48]
	b	LBB41_109
LBB41_111:
	sturb	wzr, [x29, #-57]
	ldr	w1, [sp, #868]
Ltmp291:
	add	x8, sp, #912
	mov	w0, #0
	bl	__RNvMsz_Cs7B2A3P5pSWO_10proc_macroNtB5_5Group3new
Ltmp292:
	b	LBB41_112
LBB41_112:
Ltmp293:
	add	x8, sp, #892
	add	x0, sp, #912
	bl	__ZN86_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Group$GT$$GT$4from17h2679b878fbe3513bE
Ltmp294:
	b	LBB41_113
LBB41_113:
Ltmp295:
	add	x0, sp, #892
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.30@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.30@PAGEOFF
	bl	__ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h1edeed61ada33503E
	str	w0, [sp, #40]
Ltmp296:
	b	LBB41_114
LBB41_114:
	ldr	w8, [sp, #40]
	str	w8, [sp, #428]
	sturb	wzr, [x29, #-57]
	b	LBB41_69
LBB41_115:
Ltmp298:
	add	x0, sp, #868
	bl	__ZN4core3ptr44drop_in_place$LT$proc_macro..TokenStream$GT$17h125cfb6c70942766E
Ltmp299:
	b	LBB41_4
LBB41_116:
Ltmp302:
	ldr	x1, [sp, #272]
	ldr	x0, [sp, #264]
	add	x8, sp, #816
	bl	__RNvMsM_Cs7B2A3P5pSWO_10proc_macroNtB5_7Literal13i128_suffixed
Ltmp303:
	b	LBB41_117
LBB41_117:
Ltmp304:
	add	x8, sp, #796
	add	x0, sp, #816
	bl	__ZN88_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Literal$GT$$GT$4from17hd488e0f50b18ea9aE
Ltmp305:
	b	LBB41_118
LBB41_118:
Ltmp306:
	add	x0, sp, #796
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.31@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.31@PAGEOFF
	bl	__ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h1edeed61ada33503E
	str	w0, [sp, #36]
Ltmp307:
	b	LBB41_119
LBB41_119:
	ldr	w8, [sp, #36]
	str	w8, [sp, #428]
	b	LBB41_69
LBB41_120:
Ltmp310:
	ldr	x0, [sp, #288]
	add	x8, sp, #780
	bl	__RNvMsM_Cs7B2A3P5pSWO_10proc_macroNtB5_7Literal12i64_suffixed
Ltmp311:
	b	LBB41_121
LBB41_121:
Ltmp312:
	add	x8, sp, #760
	add	x0, sp, #780
	bl	__ZN88_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Literal$GT$$GT$4from17hd488e0f50b18ea9aE
Ltmp313:
	b	LBB41_122
LBB41_122:
Ltmp314:
	add	x0, sp, #760
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.32@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.32@PAGEOFF
	bl	__ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h1edeed61ada33503E
	str	w0, [sp, #32]
Ltmp315:
	b	LBB41_123
LBB41_123:
	ldr	w8, [sp, #32]
	str	w8, [sp, #428]
	b	LBB41_69
LBB41_124:
Ltmp318:
	ldr	w0, [sp, #304]
	add	x8, sp, #744
	bl	__RNvMsM_Cs7B2A3P5pSWO_10proc_macroNtB5_7Literal12i32_suffixed
Ltmp319:
	b	LBB41_125
LBB41_125:
Ltmp320:
	add	x8, sp, #724
	add	x0, sp, #744
	bl	__ZN88_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Literal$GT$$GT$4from17hd488e0f50b18ea9aE
Ltmp321:
	b	LBB41_126
LBB41_126:
Ltmp322:
	add	x0, sp, #724
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.33@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.33@PAGEOFF
	bl	__ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h1edeed61ada33503E
	str	w0, [sp, #28]
Ltmp323:
	b	LBB41_127
LBB41_127:
	ldr	w8, [sp, #28]
	str	w8, [sp, #428]
	b	LBB41_69
LBB41_128:
Ltmp326:
	ldr	w0, [sp, #312]
	add	x8, sp, #708
	bl	__RNvMsM_Cs7B2A3P5pSWO_10proc_macroNtB5_7Literal12i16_suffixed
Ltmp327:
	b	LBB41_129
LBB41_129:
Ltmp328:
	add	x8, sp, #688
	add	x0, sp, #708
	bl	__ZN88_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Literal$GT$$GT$4from17hd488e0f50b18ea9aE
Ltmp329:
	b	LBB41_130
LBB41_130:
Ltmp330:
	add	x0, sp, #688
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.34@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.34@PAGEOFF
	bl	__ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h1edeed61ada33503E
	str	w0, [sp, #24]
Ltmp331:
	b	LBB41_131
LBB41_131:
	ldr	w8, [sp, #24]
	str	w8, [sp, #428]
	b	LBB41_69
LBB41_132:
Ltmp334:
	ldr	w0, [sp, #320]
	add	x8, sp, #672
	bl	__RNvMsM_Cs7B2A3P5pSWO_10proc_macroNtB5_7Literal11i8_suffixed
Ltmp335:
	b	LBB41_133
LBB41_133:
Ltmp336:
	add	x8, sp, #652
	add	x0, sp, #672
	bl	__ZN88_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Literal$GT$$GT$4from17hd488e0f50b18ea9aE
Ltmp337:
	b	LBB41_134
LBB41_134:
Ltmp338:
	add	x0, sp, #652
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.35@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.35@PAGEOFF
	bl	__ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h1edeed61ada33503E
	str	w0, [sp, #20]
Ltmp339:
	b	LBB41_135
LBB41_135:
	ldr	w8, [sp, #20]
	str	w8, [sp, #428]
	b	LBB41_69
LBB41_136:
Ltmp342:
	ldr	x1, [sp, #336]
	ldr	x0, [sp, #328]
	add	x8, sp, #636
	bl	__RNvMsM_Cs7B2A3P5pSWO_10proc_macroNtB5_7Literal13u128_suffixed
Ltmp343:
	b	LBB41_137
LBB41_137:
Ltmp344:
	add	x8, sp, #616
	add	x0, sp, #636
	bl	__ZN88_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Literal$GT$$GT$4from17hd488e0f50b18ea9aE
Ltmp345:
	b	LBB41_138
LBB41_138:
Ltmp346:
	add	x0, sp, #616
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.36@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.36@PAGEOFF
	bl	__ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h1edeed61ada33503E
	str	w0, [sp, #16]
Ltmp347:
	b	LBB41_139
LBB41_139:
	ldr	w8, [sp, #16]
	str	w8, [sp, #428]
	b	LBB41_69
LBB41_140:
Ltmp350:
	ldr	x0, [sp, #352]
	add	x8, sp, #600
	bl	__RNvMsM_Cs7B2A3P5pSWO_10proc_macroNtB5_7Literal12u64_suffixed
Ltmp351:
	b	LBB41_141
LBB41_141:
Ltmp352:
	add	x8, sp, #580
	add	x0, sp, #600
	bl	__ZN88_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Literal$GT$$GT$4from17hd488e0f50b18ea9aE
Ltmp353:
	b	LBB41_142
LBB41_142:
Ltmp354:
	add	x0, sp, #580
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.37@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.37@PAGEOFF
	bl	__ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h1edeed61ada33503E
	str	w0, [sp, #12]
Ltmp355:
	b	LBB41_143
LBB41_143:
	ldr	w8, [sp, #12]
	str	w8, [sp, #428]
	b	LBB41_69
LBB41_144:
Ltmp358:
	ldr	w0, [sp, #364]
	add	x8, sp, #564
	bl	__RNvMsM_Cs7B2A3P5pSWO_10proc_macroNtB5_7Literal12u32_suffixed
Ltmp359:
	b	LBB41_145
LBB41_145:
Ltmp360:
	add	x8, sp, #544
	add	x0, sp, #564
	bl	__ZN88_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Literal$GT$$GT$4from17hd488e0f50b18ea9aE
Ltmp361:
	b	LBB41_146
LBB41_146:
Ltmp362:
	add	x0, sp, #544
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.38@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.38@PAGEOFF
	bl	__ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h1edeed61ada33503E
	str	w0, [sp, #8]
Ltmp363:
	b	LBB41_147
LBB41_147:
	ldr	w8, [sp, #8]
	str	w8, [sp, #428]
	b	LBB41_69
LBB41_148:
Ltmp366:
	ldr	w0, [sp, #372]
	add	x8, sp, #528
	bl	__RNvMsM_Cs7B2A3P5pSWO_10proc_macroNtB5_7Literal12u16_suffixed
Ltmp367:
	b	LBB41_149
LBB41_149:
Ltmp368:
	add	x8, sp, #508
	add	x0, sp, #528
	bl	__ZN88_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Literal$GT$$GT$4from17hd488e0f50b18ea9aE
Ltmp369:
	b	LBB41_150
LBB41_150:
Ltmp370:
	add	x0, sp, #508
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.39@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.39@PAGEOFF
	bl	__ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h1edeed61ada33503E
	str	w0, [sp, #4]
Ltmp371:
	b	LBB41_151
LBB41_151:
	ldr	w8, [sp, #4]
	str	w8, [sp, #428]
	b	LBB41_69
LBB41_152:
Ltmp374:
	ldr	w0, [sp, #380]
	add	x8, sp, #492
	bl	__RNvMsM_Cs7B2A3P5pSWO_10proc_macroNtB5_7Literal11u8_suffixed
Ltmp375:
	b	LBB41_153
LBB41_153:
Ltmp376:
	add	x8, sp, #472
	add	x0, sp, #492
	bl	__ZN88_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Literal$GT$$GT$4from17hd488e0f50b18ea9aE
Ltmp377:
	b	LBB41_154
LBB41_154:
Ltmp378:
	add	x0, sp, #472
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.40@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.40@PAGEOFF
	bl	__ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h1edeed61ada33503E
	str	w0, [sp]
Ltmp379:
	b	LBB41_155
LBB41_155:
	ldr	w8, [sp]
	str	w8, [sp, #428]
	b	LBB41_69
LBB41_156:
	add	x0, sp, #424
	bl	__ZN4core3ptr44drop_in_place$LT$proc_macro..TokenStream$GT$17h125cfb6c70942766E
	ldr	w0, [sp, #428]
	add	sp, sp, #1328
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	ldp	x28, x27, [sp], #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w27
	.cfi_restore w28
	ret
LBB41_157:
	.cfi_restore_state
	ldur	x0, [x29, #-56]
	bl	__Unwind_Resume
Lfunc_end18:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table41:
Lexception18:
	.byte	255
	.byte	155
	.uleb128 Lttbase11-Lttbaseref11
Lttbaseref11:
	.byte	1
	.uleb128 Lcst_end18-Lcst_begin18
Lcst_begin18:
	.uleb128 Ltmp160-Lfunc_begin18
	.uleb128 Ltmp161-Ltmp160
	.uleb128 Ltmp385-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp386-Lfunc_begin18
	.uleb128 Ltmp387-Ltmp386
	.uleb128 Ltmp388-Lfunc_begin18
	.byte	1
	.uleb128 Ltmp162-Lfunc_begin18
	.uleb128 Ltmp163-Ltmp162
	.uleb128 Ltmp380-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp381-Lfunc_begin18
	.uleb128 Ltmp382-Ltmp381
	.uleb128 Ltmp388-Lfunc_begin18
	.byte	1
	.uleb128 Ltmp164-Lfunc_begin18
	.uleb128 Ltmp199-Ltmp164
	.uleb128 Ltmp380-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp221-Lfunc_begin18
	.uleb128 Ltmp222-Ltmp221
	.uleb128 Ltmp223-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp200-Lfunc_begin18
	.uleb128 Ltmp201-Ltmp200
	.uleb128 Ltmp380-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp202-Lfunc_begin18
	.uleb128 Ltmp217-Ltmp202
	.uleb128 Ltmp218-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp383-Lfunc_begin18
	.uleb128 Ltmp384-Ltmp383
	.uleb128 Ltmp385-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp219-Lfunc_begin18
	.uleb128 Ltmp220-Ltmp219
	.uleb128 Ltmp388-Lfunc_begin18
	.byte	1
	.uleb128 Ltmp226-Lfunc_begin18
	.uleb128 Ltmp231-Ltmp226
	.uleb128 Ltmp380-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp232-Lfunc_begin18
	.uleb128 Ltmp233-Ltmp232
	.uleb128 Ltmp234-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp240-Lfunc_begin18
	.uleb128 Ltmp241-Ltmp240
	.uleb128 Ltmp388-Lfunc_begin18
	.byte	1
	.uleb128 Ltmp235-Lfunc_begin18
	.uleb128 Ltmp236-Ltmp235
	.uleb128 Ltmp237-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp238-Lfunc_begin18
	.uleb128 Ltmp239-Ltmp238
	.uleb128 Ltmp388-Lfunc_begin18
	.byte	1
	.uleb128 Ltmp242-Lfunc_begin18
	.uleb128 Ltmp243-Ltmp242
	.uleb128 Ltmp248-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp249-Lfunc_begin18
	.uleb128 Ltmp250-Ltmp249
	.uleb128 Ltmp388-Lfunc_begin18
	.byte	1
	.uleb128 Ltmp244-Lfunc_begin18
	.uleb128 Ltmp247-Ltmp244
	.uleb128 Ltmp248-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp251-Lfunc_begin18
	.uleb128 Ltmp258-Ltmp251
	.uleb128 Ltmp259-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp260-Lfunc_begin18
	.uleb128 Ltmp261-Ltmp260
	.uleb128 Ltmp388-Lfunc_begin18
	.byte	1
	.uleb128 Ltmp264-Lfunc_begin18
	.uleb128 Ltmp269-Ltmp264
	.uleb128 Ltmp380-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp270-Lfunc_begin18
	.uleb128 Ltmp271-Ltmp270
	.uleb128 Ltmp272-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp278-Lfunc_begin18
	.uleb128 Ltmp279-Ltmp278
	.uleb128 Ltmp388-Lfunc_begin18
	.byte	1
	.uleb128 Ltmp273-Lfunc_begin18
	.uleb128 Ltmp274-Ltmp273
	.uleb128 Ltmp275-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp276-Lfunc_begin18
	.uleb128 Ltmp277-Ltmp276
	.uleb128 Ltmp388-Lfunc_begin18
	.byte	1
	.uleb128 Ltmp280-Lfunc_begin18
	.uleb128 Ltmp281-Ltmp280
	.uleb128 Ltmp286-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp287-Lfunc_begin18
	.uleb128 Ltmp288-Ltmp287
	.uleb128 Ltmp388-Lfunc_begin18
	.byte	1
	.uleb128 Ltmp282-Lfunc_begin18
	.uleb128 Ltmp285-Ltmp282
	.uleb128 Ltmp286-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp289-Lfunc_begin18
	.uleb128 Ltmp296-Ltmp289
	.uleb128 Ltmp297-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp298-Lfunc_begin18
	.uleb128 Ltmp299-Ltmp298
	.uleb128 Ltmp388-Lfunc_begin18
	.byte	1
	.uleb128 Ltmp302-Lfunc_begin18
	.uleb128 Ltmp379-Ltmp302
	.uleb128 Ltmp380-Lfunc_begin18
	.byte	0
	.uleb128 Ltmp379-Lfunc_begin18
	.uleb128 Lfunc_end18-Ltmp379
	.byte	0
	.byte	0
Lcst_end18:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase11:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN18const_random_macro12const_random28_$u7b$$u7b$closure$u7d$$u7d$17hb5c96b6069c3090dE:
Lfunc_begin19:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception19
	sub	sp, sp, #240
	.cfi_def_cfa_offset 240
	stp	x29, x30, [sp, #224]
	add	x29, sp, #224
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x8, [sp]
	mov	x0, x1
	sturb	wzr, [x29, #-33]
	sturb	wzr, [x29, #-34]
	sturb	wzr, [x29, #-35]
	add	x8, sp, #44
	str	x8, [sp, #8]
	bl	__RNvMsM_Cs7B2A3P5pSWO_10proc_macroNtB5_7Literal11u8_suffixed
	ldr	x0, [sp, #8]
	mov	w8, #1
	sturb	w8, [x29, #-33]
	add	x8, sp, #24
	bl	__ZN88_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Literal$GT$$GT$4from17hd488e0f50b18ea9aE
Ltmp389:
	mov	w0, #44
	mov	w8, #1
	and	w1, w8, #0x1
	bl	__RNvMsE_Cs7B2A3P5pSWO_10proc_macroNtB5_5Punct3new
	str	x0, [sp, #16]
Ltmp390:
	b	LBB42_3
LBB42_1:
	ldurb	w8, [x29, #-33]
	tbnz	w8, #0, LBB42_16
	b	LBB42_15
LBB42_2:
Ltmp393:
	stur	x0, [x29, #-32]
	mov	x8, x1
	stur	w8, [x29, #-24]
	b	LBB42_1
LBB42_3:
	ldr	x8, [sp, #16]
	stur	x8, [x29, #-16]
	ldur	x8, [x29, #-16]
	str	x8, [sp, #80]
	ldr	x8, [sp, #80]
	stur	x8, [x29, #-8]
	ldur	x0, [x29, #-8]
Ltmp391:
	add	x8, sp, #60
	bl	__ZN86_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Punct$GT$$GT$4from17hff58e75d8bda0968E
Ltmp392:
	b	LBB42_4
LBB42_4:
	mov	w8, #1
	sturb	w8, [x29, #-34]
	sturb	wzr, [x29, #-33]
	ldur	q0, [sp, #24]
	add	x0, sp, #112
	str	q0, [sp, #112]
	ldr	w8, [sp, #40]
	str	w8, [sp, #128]
Ltmp394:
	add	x8, sp, #92
	bl	__ZN4core4iter7sources4once4once17hde8b07058073a421E
Ltmp395:
	b	LBB42_7
LBB42_5:
	ldurb	w8, [x29, #-34]
	tbnz	w8, #0, LBB42_14
	b	LBB42_1
LBB42_6:
Ltmp396:
	stur	x0, [x29, #-32]
	mov	x8, x1
	stur	w8, [x29, #-24]
	b	LBB42_5
LBB42_7:
	mov	w8, #1
	sturb	w8, [x29, #-35]
	sturb	wzr, [x29, #-34]
	ldur	q0, [sp, #60]
	sub	x0, x29, #64
	stur	q0, [x29, #-64]
	ldr	w8, [sp, #76]
	stur	w8, [x29, #-48]
Ltmp397:
	sub	x8, x29, #84
	bl	__ZN4core4iter7sources4once4once17hde8b07058073a421E
Ltmp398:
	b	LBB42_10
LBB42_8:
	ldurb	w8, [x29, #-35]
	tbnz	w8, #0, LBB42_12
	b	LBB42_5
LBB42_9:
Ltmp401:
	stur	x0, [x29, #-32]
	mov	x8, x1
	stur	w8, [x29, #-24]
	b	LBB42_8
LBB42_10:
	ldr	x8, [sp]
	sturb	wzr, [x29, #-35]
Ltmp399:
	add	x0, sp, #92
	sub	x1, x29, #84
	bl	__ZN4core4iter6traits8iterator8Iterator5chain17he59ecf2e9d29238cE
Ltmp400:
	b	LBB42_11
LBB42_11:
	sturb	wzr, [x29, #-35]
	sturb	wzr, [x29, #-34]
	sturb	wzr, [x29, #-33]
	.cfi_def_cfa wsp, 240
	ldp	x29, x30, [sp, #224]
	add	sp, sp, #240
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB42_12:
	.cfi_restore_state
Ltmp402:
	add	x0, sp, #92
	bl	__ZN4core3ptr81drop_in_place$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$17hfb9b61ff9a9e03c9E
Ltmp403:
	b	LBB42_5
LBB42_13:
Ltmp408:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB42_14:
Ltmp404:
	add	x0, sp, #60
	bl	__ZN4core3ptr42drop_in_place$LT$proc_macro..TokenTree$GT$17hd11f125074dcf256E
Ltmp405:
	b	LBB42_1
LBB42_15:
	ldur	x0, [x29, #-32]
	bl	__Unwind_Resume
LBB42_16:
Ltmp406:
	add	x0, sp, #24
	bl	__ZN4core3ptr42drop_in_place$LT$proc_macro..TokenTree$GT$17hd11f125074dcf256E
Ltmp407:
	b	LBB42_15
Lfunc_end19:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table42:
Lexception19:
	.byte	255
	.byte	155
	.uleb128 Lttbase12-Lttbaseref12
Lttbaseref12:
	.byte	1
	.uleb128 Lcst_end19-Lcst_begin19
Lcst_begin19:
	.uleb128 Lfunc_begin19-Lfunc_begin19
	.uleb128 Ltmp389-Lfunc_begin19
	.byte	0
	.byte	0
	.uleb128 Ltmp389-Lfunc_begin19
	.uleb128 Ltmp392-Ltmp389
	.uleb128 Ltmp393-Lfunc_begin19
	.byte	0
	.uleb128 Ltmp394-Lfunc_begin19
	.uleb128 Ltmp395-Ltmp394
	.uleb128 Ltmp396-Lfunc_begin19
	.byte	0
	.uleb128 Ltmp397-Lfunc_begin19
	.uleb128 Ltmp400-Ltmp397
	.uleb128 Ltmp401-Lfunc_begin19
	.byte	0
	.uleb128 Ltmp402-Lfunc_begin19
	.uleb128 Ltmp405-Ltmp402
	.uleb128 Ltmp408-Lfunc_begin19
	.byte	1
	.uleb128 Ltmp405-Lfunc_begin19
	.uleb128 Ltmp406-Ltmp405
	.byte	0
	.byte	0
	.uleb128 Ltmp406-Lfunc_begin19
	.uleb128 Ltmp407-Ltmp406
	.uleb128 Ltmp408-Lfunc_begin19
	.byte	1
Lcst_end19:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase12:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN18const_random_macro4span10gen_random17h0cae054c074a3ff3E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN56_$LT$i16$u20$as$u20$const_random_macro..span..Random$GT$6random17h56244c89dc8b70abE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN18const_random_macro4span10gen_random17h150d0b6f564bfb38E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN56_$LT$i32$u20$as$u20$const_random_macro..span..Random$GT$6random17h52fc3bb778283068E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN18const_random_macro4span10gen_random17h1524926fcd3cf93aE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN56_$LT$u16$u20$as$u20$const_random_macro..span..Random$GT$6random17hc607b1150a1817c8E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN18const_random_macro4span10gen_random17h1c1de6b81bbd8f0eE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN57_$LT$u128$u20$as$u20$const_random_macro..span..Random$GT$6random17h50e753be5fcfaa33E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN18const_random_macro4span10gen_random17h218587e517d588d0E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN57_$LT$i128$u20$as$u20$const_random_macro..span..Random$GT$6random17hffccc85ae2963e77E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN18const_random_macro4span10gen_random17h2c504a1c5adb7015E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN55_$LT$u8$u20$as$u20$const_random_macro..span..Random$GT$6random17h915be92576e98222E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN18const_random_macro4span10gen_random17h43c9fdad22a7f346E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN56_$LT$u32$u20$as$u20$const_random_macro..span..Random$GT$6random17h110dc89208355614E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN18const_random_macro4span10gen_random17had5ee0c4e4f5adbdE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN56_$LT$i64$u20$as$u20$const_random_macro..span..Random$GT$6random17ha1cde2f74f5c263fE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN18const_random_macro4span10gen_random17hd3bd3f4db4428d03E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN56_$LT$u64$u20$as$u20$const_random_macro..span..Random$GT$6random17hd0db724fab496ea9E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN18const_random_macro4span10gen_random17hebd05bf50dcc13c6E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN55_$LT$i8$u20$as$u20$const_random_macro..span..Random$GT$6random17hf8aceec44dad40eaE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN18const_random_macro4span10hash_stuff17h513da2c5f7147a32E:
Lfunc_begin20:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception20
	sub	sp, sp, #432
	.cfi_def_cfa_offset 432
	stp	x28, x27, [sp, #400]
	stp	x29, x30, [sp, #416]
	add	x29, sp, #416
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w27, -24
	.cfi_offset w28, -32
	.cfi_remember_state
	sub	x9, x29, #128
	str	x9, [sp, #32]
	str	x8, [sp]
	bl	__RNvMsm_Cs7B2A3P5pSWO_10proc_macroNtB5_4Span9call_site
	add	x8, sp, #60
	str	x8, [sp, #24]
	str	w0, [sp, #60]
	add	x8, sp, #64
	str	x8, [sp, #8]
	bl	__ZN11tiny_keccak5shake5Shake4v25617h938829213332dfe6E
	bl	__ZN18const_random_macro4span8get_seed17h1e4ff88c2c64d12fE
	mov	x2, x0
	ldr	x0, [sp, #8]
	str	x2, [sp, #16]
	mov	x2, x1
	ldr	x1, [sp, #16]
	bl	__ZN65_$LT$tiny_keccak..shake..Shake$u20$as$u20$tiny_keccak..Hasher$GT$6update17h04b64b26c3235267E
	ldr	x0, [sp, #24]
	sub	x8, x29, #48
	bl	__ZN4core3fmt2rt8Argument9new_debug17hfa2ea55701e3de88E
	ldr	x8, [sp, #32]
	ldr	q0, [x8, #80]
	sub	x1, x29, #64
	str	q0, [x8, #64]
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.41@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.41@PAGEOFF
	bl	__ZN4core3fmt9Arguments3new17h0fc7f33f3eacd0baE
	sub	x8, x29, #88
	bl	__ZN5alloc3fmt6format17h40a0db9405895018E
	ldr	x9, [sp, #32]
	ldur	q0, [x9, #40]
	sub	x0, x29, #112
	str	q0, [x9, #16]
	ldr	x8, [x9, #56]
	str	x8, [x9, #32]
Ltmp409:
	bl	__ZN5alloc6string6String8as_bytes17h7343b1a88b0582c5E
	str	x0, [sp, #40]
	str	x1, [sp, #48]
Ltmp410:
	b	LBB53_3
LBB53_1:
Ltmp414:
	sub	x0, x29, #112
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17ha9d9ccced2dc1daeE
Ltmp415:
	b	LBB53_6
LBB53_2:
Ltmp413:
	ldr	x8, [sp, #32]
	str	x0, [x8, #96]
	mov	x8, x1
	stur	w8, [x29, #-24]
	b	LBB53_1
LBB53_3:
	ldr	x8, [sp, #32]
	ldr	x9, [sp, #48]
	ldr	x10, [sp, #40]
	str	x10, [x8]
	str	x9, [x8, #8]
	ldr	x1, [x8]
	ldr	x2, [x8, #8]
Ltmp411:
	add	x0, sp, #64
	bl	__ZN65_$LT$tiny_keccak..shake..Shake$u20$as$u20$tiny_keccak..Hasher$GT$6update17h04b64b26c3235267E
Ltmp412:
	b	LBB53_4
LBB53_4:
	sub	x0, x29, #112
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17ha9d9ccced2dc1daeE
	ldr	x0, [sp]
	add	x1, sp, #64
	mov	w8, #224
	mov	x2, x8
	bl	_memcpy
	.cfi_def_cfa wsp, 432
	ldp	x29, x30, [sp, #416]
	ldp	x28, x27, [sp, #400]
	add	sp, sp, #432
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w27
	.cfi_restore w28
	ret
LBB53_5:
	.cfi_restore_state
Ltmp416:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB53_6:
	ldr	x8, [sp, #32]
	ldr	x0, [x8, #96]
	bl	__Unwind_Resume
Lfunc_end20:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table53:
Lexception20:
	.byte	255
	.byte	155
	.uleb128 Lttbase13-Lttbaseref13
Lttbaseref13:
	.byte	1
	.uleb128 Lcst_end20-Lcst_begin20
Lcst_begin20:
	.uleb128 Lfunc_begin20-Lfunc_begin20
	.uleb128 Ltmp409-Lfunc_begin20
	.byte	0
	.byte	0
	.uleb128 Ltmp409-Lfunc_begin20
	.uleb128 Ltmp410-Ltmp409
	.uleb128 Ltmp413-Lfunc_begin20
	.byte	0
	.uleb128 Ltmp414-Lfunc_begin20
	.uleb128 Ltmp415-Ltmp414
	.uleb128 Ltmp416-Lfunc_begin20
	.byte	1
	.uleb128 Ltmp411-Lfunc_begin20
	.uleb128 Ltmp412-Ltmp411
	.uleb128 Ltmp413-Lfunc_begin20
	.byte	0
	.uleb128 Ltmp412-Lfunc_begin20
	.uleb128 Lfunc_end20-Ltmp412
	.byte	0
	.byte	0
Lcst_end20:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase13:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN18const_random_macro4span16gen_random_bytes17h12b5086f33a0b307E:
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
	str	x0, [sp, #16]
	str	x1, [sp, #24]
	add	x8, sp, #32
	str	x8, [sp, #8]
	bl	__ZN18const_random_macro4span10hash_stuff17h513da2c5f7147a32E
	ldr	x0, [sp, #8]
	ldr	x1, [sp, #16]
	ldr	x2, [sp, #24]
	bl	__ZN62_$LT$tiny_keccak..shake..Shake$u20$as$u20$tiny_keccak..Xof$GT$7squeeze17h3ab19e1c776c538eE
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

	.p2align	2
__ZN18const_random_macro4span8get_seed17h1e4ff88c2c64d12fE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	adrp	x0, __ZN18const_random_macro4span4SEED17h567103d596ff29faE@PAGE
	add	x0, x0, __ZN18const_random_macro4span4SEED17h567103d596ff29faE@PAGEOFF
	bl	__ZN9once_cell4race8once_box16OnceBox$LT$T$GT$11get_or_init17hcddf37578a96ef37E
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.43@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.43@PAGEOFF
	bl	__ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h14e233d4ab3e0c98E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN18const_random_macro4span8get_seed28_$u7b$$u7b$closure$u7d$$u7d$17hb802de73426ca3b0E:
Lfunc_begin21:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception21
	sub	sp, sp, #208
	.cfi_def_cfa_offset 208
	stp	x29, x30, [sp, #192]
	add	x29, sp, #192
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	xzr, [sp, #40]
	ldr	x8, [sp, #40]
	subs	x8, x8, #0
	cset	x8, ne
	tbz	w8, #0, LBB56_6
	b	LBB56_1
LBB56_1:
	ldr	x0, [sp, #40]
	ldr	x1, [sp, #48]
	add	x8, sp, #56
	bl	__ZN5alloc5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$6to_vec17h0982013d5bb3354fE
Ltmp426:
	mov	w8, #8
	mov	x0, x8
	mov	w8, #24
	mov	x1, x8
	bl	__ZN5alloc5boxed14box_new_uninit17h5f1a5509780f8a7eE
	str	x0, [sp, #24]
Ltmp427:
	b	LBB56_5
LBB56_2:
Ltmp428:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
Ltmp429:
	add	x0, sp, #56
	bl	__ZN4core3ptr46drop_in_place$LT$alloc..vec..Vec$LT$u8$GT$$GT$17h2f7b2d448e5199ebE
Ltmp430:
	b	LBB56_4
LBB56_3:
Ltmp431:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB56_4:
	ldur	x8, [x29, #-16]
	str	x8, [sp, #16]
	b	LBB56_16
LBB56_5:
	ldr	x8, [sp, #24]
	ldur	q0, [sp, #56]
	str	q0, [x8]
	ldr	x9, [sp, #72]
	str	x9, [x8, #16]
	str	x8, [sp, #32]
	b	LBB56_15
LBB56_6:
	movi.2d	v0, #0000000000000000
	add	x0, sp, #80
	str	q0, [sp, #80]
	str	q0, [sp, #96]
	mov	w8, #32
	mov	x1, x8
	bl	__ZN9getrandom9getrandom17habe30d2120572968E
	stur	w0, [x29, #-56]
	ldur	w8, [x29, #-56]
	subs	w8, w8, #0
	cset	x8, ne
	tbz	w8, #0, LBB56_10
	b	LBB56_7
LBB56_7:
	ldur	w8, [x29, #-56]
	sub	x2, x29, #52
	stur	w8, [x29, #-52]
Ltmp423:
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.82@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.82@PAGEOFF
	mov	w8, #43
	mov	x1, x8
	adrp	x3, l_anon.06e111bfef83652125d85ade023d82af.81@PAGE
	add	x3, x3, l_anon.06e111bfef83652125d85ade023d82af.81@PAGEOFF
	adrp	x4, l_anon.06e111bfef83652125d85ade023d82af.44@PAGE
	add	x4, x4, l_anon.06e111bfef83652125d85ade023d82af.44@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core6result13unwrap_failed
Ltmp424:
	b	LBB56_9
LBB56_8:
Ltmp425:
	stur	x0, [x29, #-48]
	mov	x8, x1
	stur	w8, [x29, #-40]
	ldur	x8, [x29, #-48]
	str	x8, [sp, #16]
	b	LBB56_16
LBB56_9:
	brk	#0x1
LBB56_10:
	sub	x8, x29, #80
	add	x0, sp, #80
	mov	w9, #32
	mov	x1, x9
	bl	__ZN5alloc5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$6to_vec17h0982013d5bb3354fE
Ltmp417:
	mov	w8, #8
	mov	x0, x8
	mov	w8, #24
	mov	x1, x8
	bl	__ZN5alloc5boxed14box_new_uninit17h5f1a5509780f8a7eE
	str	x0, [sp, #8]
Ltmp418:
	b	LBB56_14
LBB56_11:
Ltmp419:
	stur	x0, [x29, #-32]
	mov	x8, x1
	stur	w8, [x29, #-24]
Ltmp420:
	sub	x0, x29, #80
	bl	__ZN4core3ptr46drop_in_place$LT$alloc..vec..Vec$LT$u8$GT$$GT$17h2f7b2d448e5199ebE
Ltmp421:
	b	LBB56_13
LBB56_12:
Ltmp422:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB56_13:
	ldur	x8, [x29, #-32]
	str	x8, [sp, #16]
	b	LBB56_16
LBB56_14:
	ldr	x8, [sp, #8]
	ldur	q0, [x29, #-80]
	str	q0, [x8]
	ldur	x9, [x29, #-64]
	str	x9, [x8, #16]
	str	x8, [sp, #32]
	b	LBB56_15
LBB56_15:
	ldr	x0, [sp, #32]
	.cfi_def_cfa wsp, 208
	ldp	x29, x30, [sp, #192]
	add	sp, sp, #208
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB56_16:
	.cfi_restore_state
	ldr	x0, [sp, #16]
	bl	__Unwind_Resume
Lfunc_end21:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table56:
Lexception21:
	.byte	255
	.byte	155
	.uleb128 Lttbase14-Lttbaseref14
Lttbaseref14:
	.byte	1
	.uleb128 Lcst_end21-Lcst_begin21
Lcst_begin21:
	.uleb128 Lfunc_begin21-Lfunc_begin21
	.uleb128 Ltmp426-Lfunc_begin21
	.byte	0
	.byte	0
	.uleb128 Ltmp426-Lfunc_begin21
	.uleb128 Ltmp427-Ltmp426
	.uleb128 Ltmp428-Lfunc_begin21
	.byte	0
	.uleb128 Ltmp429-Lfunc_begin21
	.uleb128 Ltmp430-Ltmp429
	.uleb128 Ltmp431-Lfunc_begin21
	.byte	1
	.uleb128 Ltmp430-Lfunc_begin21
	.uleb128 Ltmp423-Ltmp430
	.byte	0
	.byte	0
	.uleb128 Ltmp423-Lfunc_begin21
	.uleb128 Ltmp424-Ltmp423
	.uleb128 Ltmp425-Lfunc_begin21
	.byte	0
	.uleb128 Ltmp424-Lfunc_begin21
	.uleb128 Ltmp417-Ltmp424
	.byte	0
	.byte	0
	.uleb128 Ltmp417-Lfunc_begin21
	.uleb128 Ltmp418-Ltmp417
	.uleb128 Ltmp419-Lfunc_begin21
	.byte	0
	.uleb128 Ltmp420-Lfunc_begin21
	.uleb128 Ltmp421-Ltmp420
	.uleb128 Ltmp422-Lfunc_begin21
	.byte	1
	.uleb128 Ltmp421-Lfunc_begin21
	.uleb128 Lfunc_end21-Ltmp421
	.byte	0
	.byte	0
Lcst_end21:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase14:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN18const_random_macro5ident17h523ccc2407baed6dE:
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	str	x1, [sp]
	bl	__RNvMsm_Cs7B2A3P5pSWO_10proc_macroNtB5_4Span9call_site
	ldr	x1, [sp]
	mov	x2, x0
	ldr	x0, [sp, #8]
	sub	x8, x29, #12
	str	x8, [sp, #16]
	bl	__RNvMsJ_Cs7B2A3P5pSWO_10proc_macroNtB5_5Ident3new
	ldr	x0, [sp, #16]
	add	x8, sp, #32
	str	x8, [sp, #24]
	bl	__ZN86_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Ident$GT$$GT$4from17h6ee5e1744a207996E
	ldr	x0, [sp, #24]
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.45@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.45@PAGEOFF
	bl	__ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h1edeed61ada33503E
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN3std2io5error14repr_bitpacked11decode_repr17hf3cb7002e7cb91d9E:
Lfunc_begin22:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception22
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	stp	x29, x30, [sp, #80]
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x8, [sp, #24]
	str	x0, [sp, #32]
	mov	w8, #1
	sturb	w8, [x29, #-25]
	and	x8, x0, #0x3
	str	x8, [sp, #40]
	cbz	x8, LBB58_7
	b	LBB58_1
LBB58_1:
	ldr	x8, [sp, #40]
	subs	x8, x8, #1
	b.eq	LBB58_8
	b	LBB58_2
LBB58_2:
	ldr	x8, [sp, #40]
	subs	x8, x8, #2
	b.eq	LBB58_5
	b	LBB58_3
LBB58_3:
	ldr	x8, [sp, #40]
	subs	x8, x8, #3
	b.eq	LBB58_6
	b	LBB58_4
LBB58_4:
Ltmp436:
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.48@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.48@PAGEOFF
	mov	w8, #40
	mov	x1, x8
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.49@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.49@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking5panic
Ltmp437:
	b	LBB58_18
LBB58_5:
	ldr	x8, [sp, #24]
	ldr	x9, [sp, #32]
	asr	x9, x9, #32
	str	w9, [x8, #4]
	strb	wzr, [x8]
	b	LBB58_9
LBB58_6:
	ldr	x8, [sp, #32]
	lsr	x8, x8, #32
	mov	x0, x8
Ltmp434:
	bl	__ZN3std2io5error14repr_bitpacked14kind_from_prim17h918b19bf0b54ffbbE
	str	w0, [sp, #20]
Ltmp435:
	b	LBB58_12
LBB58_7:
	ldr	x9, [sp, #24]
	ldr	x8, [sp, #32]
	str	x8, [x9, #8]
	mov	w8, #2
	strb	w8, [x9]
	b	LBB58_9
LBB58_8:
	ldr	x8, [sp, #32]
	subs	x8, x8, #1
	stur	x8, [x29, #-8]
	ldur	x0, [x29, #-8]
	sturb	wzr, [x29, #-25]
Ltmp432:
	bl	__ZN78_$LT$std..io..error..repr_bitpacked..Repr$u20$as$u20$core..ops..drop..Drop$GT$4drop28_$u7b$$u7b$closure$u7d$$u7d$17hf7f08577e63244eaE
	str	x0, [sp, #8]
Ltmp433:
	b	LBB58_17
LBB58_9:
	b	LBB58_16
LBB58_10:
	ldurb	w8, [x29, #-25]
	tbnz	w8, #0, LBB58_20
	b	LBB58_19
LBB58_11:
Ltmp438:
	stur	x0, [x29, #-24]
	mov	x8, x1
	stur	w8, [x29, #-16]
	b	LBB58_10
LBB58_12:
	ldr	w8, [sp, #20]
	sturb	w8, [x29, #-26]
	ldurb	w8, [x29, #-26]
	subs	w8, w8, #42
	cset	x8, ne
	tbz	w8, #0, LBB58_14
	b	LBB58_13
LBB58_13:
	ldr	x9, [sp, #24]
	ldurb	w8, [x29, #-26]
	strb	w8, [x9, #1]
	mov	w8, #1
	strb	w8, [x9]
	b	LBB58_9
LBB58_14:
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.47@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.47@PAGEOFF
	bl	__ZN4core4hint21unreachable_unchecked18precondition_check17h868ec29e1862bf2aE
	b	LBB58_15
LBB58_15:
	brk	#0x1
LBB58_16:
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB58_17:
	.cfi_restore_state
	ldr	x9, [sp, #24]
	ldr	x8, [sp, #8]
	str	x8, [x9, #8]
	mov	w8, #3
	strb	w8, [x9]
	b	LBB58_16
LBB58_18:
	brk	#0x1
LBB58_19:
	ldur	x0, [x29, #-24]
	bl	__Unwind_Resume
LBB58_20:
	b	LBB58_19
Lfunc_end22:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table58:
Lexception22:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end22-Lcst_begin22
Lcst_begin22:
	.uleb128 Ltmp436-Lfunc_begin22
	.uleb128 Ltmp433-Ltmp436
	.uleb128 Ltmp438-Lfunc_begin22
	.byte	0
	.uleb128 Ltmp433-Lfunc_begin22
	.uleb128 Lfunc_end22-Ltmp433
	.byte	0
	.byte	0
Lcst_end22:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN3std2io5error14repr_bitpacked14kind_from_prim17h918b19bf0b54ffbbE:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	.cfi_remember_state
	str	w0, [sp, #8]
	cbnz	w0, LBB59_2
	b	LBB59_1
LBB59_1:
	strb	wzr, [sp, #15]
	b	LBB59_3
LBB59_2:
	ldr	w8, [sp, #8]
	subs	w8, w8, #1
	b.eq	LBB59_4
	b	LBB59_5
LBB59_3:
	ldrb	w0, [sp, #15]
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
LBB59_4:
	.cfi_restore_state
	mov	w8, #1
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_5:
	ldr	w8, [sp, #8]
	subs	w8, w8, #2
	b.ne	LBB59_7
	b	LBB59_6
LBB59_6:
	mov	w8, #2
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_7:
	ldr	w8, [sp, #8]
	subs	w8, w8, #3
	b.ne	LBB59_9
	b	LBB59_8
LBB59_8:
	mov	w8, #3
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_9:
	ldr	w8, [sp, #8]
	subs	w8, w8, #4
	b.ne	LBB59_11
	b	LBB59_10
LBB59_10:
	mov	w8, #4
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_11:
	ldr	w8, [sp, #8]
	subs	w8, w8, #5
	b.ne	LBB59_13
	b	LBB59_12
LBB59_12:
	mov	w8, #5
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_13:
	ldr	w8, [sp, #8]
	subs	w8, w8, #6
	b.ne	LBB59_15
	b	LBB59_14
LBB59_14:
	mov	w8, #6
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_15:
	ldr	w8, [sp, #8]
	subs	w8, w8, #7
	b.ne	LBB59_17
	b	LBB59_16
LBB59_16:
	mov	w8, #7
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_17:
	ldr	w8, [sp, #8]
	subs	w8, w8, #8
	b.ne	LBB59_19
	b	LBB59_18
LBB59_18:
	mov	w8, #8
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_19:
	ldr	w8, [sp, #8]
	subs	w8, w8, #9
	b.ne	LBB59_21
	b	LBB59_20
LBB59_20:
	mov	w8, #9
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_21:
	ldr	w8, [sp, #8]
	subs	w8, w8, #10
	b.ne	LBB59_23
	b	LBB59_22
LBB59_22:
	mov	w8, #10
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_23:
	ldr	w8, [sp, #8]
	subs	w8, w8, #11
	b.ne	LBB59_25
	b	LBB59_24
LBB59_24:
	mov	w8, #11
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_25:
	ldr	w8, [sp, #8]
	subs	w8, w8, #12
	b.ne	LBB59_27
	b	LBB59_26
LBB59_26:
	mov	w8, #12
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_27:
	ldr	w8, [sp, #8]
	subs	w8, w8, #13
	b.ne	LBB59_29
	b	LBB59_28
LBB59_28:
	mov	w8, #13
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_29:
	ldr	w8, [sp, #8]
	subs	w8, w8, #14
	b.ne	LBB59_31
	b	LBB59_30
LBB59_30:
	mov	w8, #14
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_31:
	ldr	w8, [sp, #8]
	subs	w8, w8, #15
	b.ne	LBB59_33
	b	LBB59_32
LBB59_32:
	mov	w8, #15
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_33:
	ldr	w8, [sp, #8]
	subs	w8, w8, #16
	b.ne	LBB59_35
	b	LBB59_34
LBB59_34:
	mov	w8, #16
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_35:
	ldr	w8, [sp, #8]
	subs	w8, w8, #17
	b.ne	LBB59_37
	b	LBB59_36
LBB59_36:
	mov	w8, #17
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_37:
	ldr	w8, [sp, #8]
	subs	w8, w8, #18
	b.ne	LBB59_39
	b	LBB59_38
LBB59_38:
	mov	w8, #18
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_39:
	ldr	w8, [sp, #8]
	subs	w8, w8, #19
	b.ne	LBB59_41
	b	LBB59_40
LBB59_40:
	mov	w8, #19
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_41:
	ldr	w8, [sp, #8]
	subs	w8, w8, #20
	b.ne	LBB59_43
	b	LBB59_42
LBB59_42:
	mov	w8, #20
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_43:
	ldr	w8, [sp, #8]
	subs	w8, w8, #21
	b.ne	LBB59_45
	b	LBB59_44
LBB59_44:
	mov	w8, #21
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_45:
	ldr	w8, [sp, #8]
	subs	w8, w8, #22
	b.ne	LBB59_47
	b	LBB59_46
LBB59_46:
	mov	w8, #22
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_47:
	ldr	w8, [sp, #8]
	subs	w8, w8, #23
	b.ne	LBB59_49
	b	LBB59_48
LBB59_48:
	mov	w8, #23
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_49:
	ldr	w8, [sp, #8]
	subs	w8, w8, #24
	b.ne	LBB59_51
	b	LBB59_50
LBB59_50:
	mov	w8, #24
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_51:
	ldr	w8, [sp, #8]
	subs	w8, w8, #25
	b.ne	LBB59_53
	b	LBB59_52
LBB59_52:
	mov	w8, #25
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_53:
	ldr	w8, [sp, #8]
	subs	w8, w8, #26
	b.ne	LBB59_55
	b	LBB59_54
LBB59_54:
	mov	w8, #26
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_55:
	ldr	w8, [sp, #8]
	subs	w8, w8, #27
	b.ne	LBB59_57
	b	LBB59_56
LBB59_56:
	mov	w8, #27
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_57:
	ldr	w8, [sp, #8]
	subs	w8, w8, #28
	b.ne	LBB59_59
	b	LBB59_58
LBB59_58:
	mov	w8, #28
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_59:
	ldr	w8, [sp, #8]
	subs	w8, w8, #29
	b.ne	LBB59_61
	b	LBB59_60
LBB59_60:
	mov	w8, #29
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_61:
	ldr	w8, [sp, #8]
	subs	w8, w8, #30
	b.ne	LBB59_63
	b	LBB59_62
LBB59_62:
	mov	w8, #30
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_63:
	ldr	w8, [sp, #8]
	subs	w8, w8, #31
	b.ne	LBB59_65
	b	LBB59_64
LBB59_64:
	mov	w8, #31
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_65:
	ldr	w8, [sp, #8]
	subs	w8, w8, #32
	b.ne	LBB59_67
	b	LBB59_66
LBB59_66:
	mov	w8, #32
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_67:
	ldr	w8, [sp, #8]
	subs	w8, w8, #33
	b.ne	LBB59_69
	b	LBB59_68
LBB59_68:
	mov	w8, #33
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_69:
	ldr	w8, [sp, #8]
	subs	w8, w8, #34
	b.ne	LBB59_71
	b	LBB59_70
LBB59_70:
	mov	w8, #34
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_71:
	ldr	w8, [sp, #8]
	subs	w8, w8, #35
	b.ne	LBB59_73
	b	LBB59_72
LBB59_72:
	mov	w8, #35
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_73:
	ldr	w8, [sp, #8]
	subs	w8, w8, #40
	b.ne	LBB59_75
	b	LBB59_74
LBB59_74:
	mov	w8, #40
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_75:
	ldr	w8, [sp, #8]
	subs	w8, w8, #37
	b.ne	LBB59_77
	b	LBB59_76
LBB59_76:
	mov	w8, #37
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_77:
	ldr	w8, [sp, #8]
	subs	w8, w8, #36
	b.ne	LBB59_79
	b	LBB59_78
LBB59_78:
	mov	w8, #36
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_79:
	ldr	w8, [sp, #8]
	subs	w8, w8, #38
	b.ne	LBB59_81
	b	LBB59_80
LBB59_80:
	mov	w8, #38
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_81:
	ldr	w8, [sp, #8]
	subs	w8, w8, #39
	b.ne	LBB59_83
	b	LBB59_82
LBB59_82:
	mov	w8, #39
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_83:
	ldr	w8, [sp, #8]
	subs	w8, w8, #41
	b.ne	LBB59_85
	b	LBB59_84
LBB59_84:
	mov	w8, #41
	strb	w8, [sp, #15]
	b	LBB59_3
LBB59_85:
	mov	w8, #42
	strb	w8, [sp, #15]
	b	LBB59_3
	.cfi_endproc

	.p2align	2
__ZN3std6thread5local17LocalKey$LT$T$GT$4with17h7e2646c56cc9a777E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN3std6thread5local17LocalKey$LT$T$GT$8try_with17h61a17e8ad1d987b3E
	str	x0, [sp]
	str	x1, [sp, #8]
	ldr	x8, [sp]
	tbz	w8, #0, LBB60_2
	b	LBB60_1
LBB60_1:
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.51@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.51@PAGEOFF
	bl	__RNvNtNtCsaLOjE9VYtxK_3std6thread5local18panic_access_error
LBB60_2:
	ldr	x0, [sp, #8]
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN3std6thread5local17LocalKey$LT$T$GT$8try_with17h61a17e8ad1d987b3E:
Lfunc_begin23:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception23
	sub	sp, sp, #112
	.cfi_def_cfa_offset 112
	stp	x29, x30, [sp, #96]
	add	x29, sp, #96
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x1, [sp, #16]
	mov	w8, #1
	sturb	w8, [x29, #-17]
	ldr	x8, [x0]
Ltmp440:
	mov	x0, #0
	blr	x8
	str	x0, [sp, #24]
Ltmp441:
	b	LBB61_3
LBB61_1:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB61_9
	b	LBB61_8
LBB61_2:
Ltmp444:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB61_1
LBB61_3:
	ldr	x8, [sp, #24]
	cbnz	x8, LBB61_5
	b	LBB61_4
LBB61_4:
	stur	xzr, [x29, #-32]
	stur	xzr, [x29, #-40]
	mov	w8, #1
	str	x8, [sp, #32]
	b	LBB61_6
LBB61_5:
	ldr	x0, [sp, #16]
	ldr	x8, [sp, #24]
	stur	x8, [x29, #-32]
	ldur	x8, [x29, #-32]
	stur	x8, [x29, #-40]
	ldur	x8, [x29, #-40]
	str	x8, [sp, #48]
	ldr	x1, [sp, #48]
	sturb	wzr, [x29, #-17]
Ltmp442:
	bl	__ZN3std6thread5local41LocalKey$LT$core..cell..Cell$LT$T$GT$$GT$7replace28_$u7b$$u7b$closure$u7d$$u7d$17h1c76b28e414e96ccE
	str	x0, [sp, #8]
Ltmp443:
	b	LBB61_7
LBB61_6:
	ldr	x0, [sp, #32]
	ldr	x1, [sp, #40]
	.cfi_def_cfa wsp, 112
	ldp	x29, x30, [sp, #96]
	add	sp, sp, #112
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB61_7:
	.cfi_restore_state
	ldr	x8, [sp, #8]
	str	x8, [sp, #40]
	str	xzr, [sp, #32]
	b	LBB61_6
LBB61_8:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB61_9:
	b	LBB61_8
Lfunc_end23:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table61:
Lexception23:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end23-Lcst_begin23
Lcst_begin23:
	.uleb128 Ltmp440-Lfunc_begin23
	.uleb128 Ltmp443-Ltmp440
	.uleb128 Ltmp444-Lfunc_begin23
	.byte	0
	.uleb128 Ltmp443-Lfunc_begin23
	.uleb128 Lfunc_end23-Ltmp443
	.byte	0
	.byte	0
Lcst_end23:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN3std6thread5local41LocalKey$LT$core..cell..Cell$LT$T$GT$$GT$7replace28_$u7b$$u7b$closure$u7d$$u7d$17h1c76b28e414e96ccE:
	.cfi_startproc
	mov	x8, x0
	ldr	x0, [x1]
	str	x8, [x1]
	ret
	.cfi_endproc

	.p2align	2
__ZN3std9panicking12catch_unwind7do_call17h94d12ae2e30ec88dE:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x1, x0
	add	x0, sp, #8
	str	x0, [sp]
	mov	w8, #40
	mov	x2, x8
	bl	_memcpy
	ldr	x0, [sp]
	bl	__ZN115_$LT$core..panic..unwind_safe..AssertUnwindSafe$LT$F$GT$$u20$as$u20$core..ops..function..FnOnce$LT$$LP$$RP$$GT$$GT$9call_once17h0315fb49a66c4b3eE
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN3std9panicking12catch_unwind8do_catch17h2bbf33dba1acca0eE:
Lfunc_begin24:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception24
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	mov	x0, x1
Ltmp445:
	bl	__RNvNvNtCsaLOjE9VYtxK_3std9panicking12catch_unwind7cleanup
	str	x0, [sp, #16]
	stur	x1, [x29, #-8]
Ltmp446:
	b	LBB64_2
LBB64_1:
Ltmp447:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking19panic_cannot_unwind
LBB64_2:
	ldr	x9, [sp, #8]
	ldur	x8, [x29, #-8]
	ldr	x10, [sp, #16]
	str	x10, [x9]
	str	x8, [x9, #8]
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
Lfunc_end24:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table64:
Lexception24:
	.byte	255
	.byte	155
	.uleb128 Lttbase15-Lttbaseref15
Lttbaseref15:
	.byte	1
	.uleb128 Lcst_end24-Lcst_begin24
Lcst_begin24:
	.uleb128 Ltmp445-Lfunc_begin24
	.uleb128 Ltmp446-Ltmp445
	.uleb128 Ltmp447-Lfunc_begin24
	.byte	1
Lcst_end24:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase15:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN45_$LT$T$u20$as$u20$alloc..string..ToString$GT$9to_string17hfcad322ed6d0360fE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN49_$LT$T$u20$as$u20$alloc..string..SpecToString$GT$14spec_to_string17h9c0b00e6bea21da5E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN49_$LT$T$u20$as$u20$alloc..string..SpecToString$GT$14spec_to_string17h9c0b00e6bea21da5E:
Lfunc_begin25:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception25
	sub	sp, sp, #128
	.cfi_def_cfa_offset 128
	stp	x29, x30, [sp, #112]
	add	x29, sp, #112
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x8, [sp]
	stur	xzr, [x29, #-40]
	mov	w8, #1
	stur	x8, [x29, #-32]
	stur	xzr, [x29, #-24]
	ldur	q0, [x29, #-40]
	add	x8, sp, #16
	str	q0, [sp, #16]
	ldur	x9, [x29, #-24]
	str	x9, [sp, #32]
	mov	w9, #32
	movk	w9, #24576, lsl #16
	stur	w9, [x29, #-48]
	sturh	wzr, [x29, #-44]
	sturh	wzr, [x29, #-42]
	ldur	x9, [x29, #-48]
	add	x1, sp, #40
	str	x9, [sp, #56]
	str	x8, [sp, #40]
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.52@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.52@PAGEOFF
	str	x8, [sp, #48]
Ltmp448:
	bl	__RNvXsa_Cs7B2A3P5pSWO_10proc_macroNtB5_11TokenStreamNtNtCs6sq8b9ugfBC_4core3fmt7Display3fmt
	str	w0, [sp, #12]
Ltmp449:
	b	LBB66_3
LBB66_1:
Ltmp453:
	add	x0, sp, #16
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17ha9d9ccced2dc1daeE
Ltmp454:
	b	LBB66_6
LBB66_2:
Ltmp452:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB66_1
LBB66_3:
Ltmp450:
	ldr	w0, [sp, #12]
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.53@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.53@PAGEOFF
	mov	w8, #55
	mov	x2, x8
	adrp	x3, l_anon.06e111bfef83652125d85ade023d82af.55@PAGE
	add	x3, x3, l_anon.06e111bfef83652125d85ade023d82af.55@PAGEOFF
	bl	__ZN4core6result19Result$LT$T$C$E$GT$6expect17hd93e4f52ec0d4851E
Ltmp451:
	b	LBB66_4
LBB66_4:
	ldr	x9, [sp]
	ldr	q0, [sp, #16]
	str	q0, [x9]
	ldr	x8, [sp, #32]
	str	x8, [x9, #16]
	.cfi_def_cfa wsp, 128
	ldp	x29, x30, [sp, #112]
	add	sp, sp, #128
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB66_5:
	.cfi_restore_state
Ltmp455:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB66_6:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
Lfunc_end25:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table66:
Lexception25:
	.byte	255
	.byte	155
	.uleb128 Lttbase16-Lttbaseref16
Lttbaseref16:
	.byte	1
	.uleb128 Lcst_end25-Lcst_begin25
Lcst_begin25:
	.uleb128 Ltmp448-Lfunc_begin25
	.uleb128 Ltmp449-Ltmp448
	.uleb128 Ltmp452-Lfunc_begin25
	.byte	0
	.uleb128 Ltmp453-Lfunc_begin25
	.uleb128 Ltmp454-Ltmp453
	.uleb128 Ltmp455-Lfunc_begin25
	.byte	1
	.uleb128 Ltmp450-Lfunc_begin25
	.uleb128 Ltmp451-Ltmp450
	.uleb128 Ltmp452-Lfunc_begin25
	.byte	0
	.uleb128 Ltmp451-Lfunc_begin25
	.uleb128 Lfunc_end25-Ltmp451
	.byte	0
	.byte	0
Lcst_end25:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase16:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core10intrinsics9cold_path17ha4eeb97e0167f544E:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3fmt2rt8Argument9new_debug17hfa2ea55701e3de88E:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp]
	adrp	x9, __RNvXsn_Cs7B2A3P5pSWO_10proc_macroNtB5_4SpanNtNtCs6sq8b9ugfBC_4core3fmt5Debug3fmt@GOTPAGE
	ldr	x9, [x9, __RNvXsn_Cs7B2A3P5pSWO_10proc_macroNtB5_4SpanNtNtCs6sq8b9ugfBC_4core3fmt5Debug3fmt@GOTPAGEOFF]
	str	x9, [sp, #8]
	ldr	q0, [sp]
	str	q0, [x8]
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3fmt5Write9write_fmt17h374e6e1540f4fdd7E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN75_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write..write_fmt..SpecWriteFmt$GT$14spec_write_fmt17h571d0069a1522e0fE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3fmt9Arguments23as_statically_known_str17hbf39d6960e186619E:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	str	x0, [sp, #24]
	ldr	x8, [x0, #8]
	str	x8, [sp, #32]
	and	x8, x8, #0x1
	subs	x8, x8, #1
	b.ne	LBB70_2
	b	LBB70_1
LBB70_1:
	ldr	x8, [sp, #32]
	ldr	x9, [sp, #24]
	ldr	x9, [x9]
	str	x9, [sp, #8]
	lsr	x8, x8, #1
	str	x8, [sp, #16]
	b	LBB70_3
LBB70_2:
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x9, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x8, [x8, #8]
	str	x9, [sp, #40]
	str	x8, [sp, #48]
	b	LBB70_4
LBB70_3:
	ldr	x8, [sp, #16]
	ldr	x9, [sp, #8]
	str	x9, [sp, #40]
	str	x8, [sp, #48]
	b	LBB70_4
LBB70_4:
	strb	wzr, [sp, #63]
	ldrb	w8, [sp, #63]
	tbnz	w8, #0, LBB70_6
	b	LBB70_5
LBB70_5:
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x9, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x8, [x8, #8]
	str	x9, [sp, #40]
	str	x8, [sp, #48]
	b	LBB70_7
LBB70_6:
	b	LBB70_7
LBB70_7:
	ldr	x0, [sp, #40]
	ldr	x1, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3fmt9Arguments3new17h0fc7f33f3eacd0baE:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3mem11conjure_zst17h0bba8e99caab4d49E:
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	b	LBB72_1
LBB72_1:
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3mem4drop17h2c6487e39c62f51aE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	add	x0, sp, #8
	str	x8, [sp, #8]
	bl	__ZN4core3ptr71drop_in_place$LT$alloc..boxed..Box$LT$alloc..vec..Vec$LT$u8$GT$$GT$$GT$17he5f2df7f14c16a1bE
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3num21_$LT$impl$u20$u64$GT$13from_ne_bytes17h73b719828a3d6017E:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	ldr	x8, [sp, #8]
	str	x8, [sp]
	ldr	x0, [sp]
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3num22_$LT$impl$u20$u128$GT$13from_ne_bytes17h2f52cfabd88b8e5cE:
	.cfi_startproc
	ldr	q0, [x0]
	mov.16b	v1, v0
	mov	d0, v0[1]
	fmov	x0, d1
	fmov	x1, d0
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3num23_$LT$impl$u20$usize$GT$16from_ascii_radix17hff4f44995668bd3eE:
	.cfi_startproc
	sub	sp, sp, #224
	.cfi_def_cfa_offset 224
	stp	x29, x30, [sp, #208]
	add	x29, sp, #208
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x8, [sp, #80]
	str	w2, [sp, #92]
	str	x0, [sp, #96]
	str	x1, [sp, #104]
	mov	w8, #2
	subs	w8, w8, w2
	b.hi	LBB76_2
	b	LBB76_1
LBB76_1:
	ldr	w8, [sp, #92]
	subs	w8, w8, #36
	b.ls	LBB76_3
	b	LBB76_2
LBB76_2:
	ldr	w0, [sp, #92]
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.61@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.61@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core3num22from_ascii_radix_panic
LBB76_3:
	ldr	x8, [sp, #104]
	str	x8, [sp, #72]
	cbnz	x8, LBB76_5
	b	LBB76_4
LBB76_4:
	ldr	x9, [sp, #80]
	strb	wzr, [x9, #1]
	mov	w8, #1
	strb	w8, [x9]
	b	LBB76_6
LBB76_5:
	ldr	x8, [sp, #72]
	subs	x8, x8, #1
	b.eq	LBB76_7
	b	LBB76_9
LBB76_6:
	.cfi_def_cfa wsp, 224
	ldp	x29, x30, [sp, #208]
	add	sp, sp, #224
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB76_7:
	.cfi_restore_state
	ldr	x8, [sp, #96]
	ldrb	w8, [x8]
	str	w8, [sp, #68]
	subs	w8, w8, #43
	b.eq	LBB76_10
	b	LBB76_8
LBB76_8:
	ldr	w8, [sp, #68]
	subs	w8, w8, #45
	b.eq	LBB76_10
	b	LBB76_9
LBB76_9:
	ldr	x8, [sp, #72]
	subs	x8, x8, #1
	b.hs	LBB76_12
	b	LBB76_11
LBB76_10:
	ldr	x9, [sp, #80]
	mov	w8, #1
	strb	w8, [x9, #1]
	strb	w8, [x9]
	b	LBB76_6
LBB76_11:
	mov	w8, #1
	sturb	w8, [x29, #-1]
	b	LBB76_16
LBB76_12:
	ldr	x8, [sp, #96]
	ldrb	w8, [x8]
	str	w8, [sp, #64]
	subs	w8, w8, #43
	b.eq	LBB76_14
	b	LBB76_13
LBB76_13:
	ldr	w8, [sp, #64]
	subs	w8, w8, #45
	b.eq	LBB76_15
	b	LBB76_11
LBB76_14:
	ldr	x9, [sp, #96]
	ldr	x8, [sp, #104]
	add	x9, x9, #1
	subs	x8, x8, #1
	mov	w10, #1
	sturb	w10, [x29, #-1]
	str	x9, [sp, #96]
	str	x8, [sp, #104]
	b	LBB76_16
LBB76_15:
	b	LBB76_11
LBB76_16:
	ldr	w8, [sp, #92]
	stur	xzr, [x29, #-32]
	ldr	x9, [sp, #104]
	str	x9, [sp, #56]
	subs	w8, w8, #16
	b.ls	LBB76_18
	b	LBB76_17
LBB76_17:
	b	LBB76_19
LBB76_18:
	ldr	x8, [sp, #56]
	subs	x8, x8, #16
	b.ls	LBB76_20
	b	LBB76_19
LBB76_19:
	b	LBB76_21
LBB76_20:
	b	LBB76_33
LBB76_21:
	ldr	x8, [sp, #104]
	subs	x8, x8, #1
	b.hs	LBB76_23
	b	LBB76_22
LBB76_22:
	ldr	x8, [sp, #80]
	ldur	x9, [x29, #-32]
	str	x9, [x8, #8]
	strb	wzr, [x8]
	b	LBB76_6
LBB76_23:
	ldr	w8, [sp, #92]
	ldr	x9, [sp, #96]
	str	x9, [sp, #24]
	ldr	x10, [sp, #96]
	ldr	x9, [sp, #104]
	add	x10, x10, #1
	str	x10, [sp, #32]
	subs	x9, x9, #1
	str	x9, [sp, #40]
	mov	w8, w8
	mov	x10, x8
	ldur	x9, [x29, #-32]
	umulh	x8, x9, x10
	mul	x9, x9, x10
	str	x9, [sp, #48]
	cbnz	x8, LBB76_25
	b	LBB76_24
LBB76_24:
	ldr	w1, [sp, #92]
	ldr	x8, [sp, #24]
	ldr	x9, [sp, #48]
	stur	x9, [x29, #-80]
	mov	w9, #1
	stur	x9, [x29, #-88]
	ldrb	w8, [x8]
	sturb	w8, [x29, #-49]
	ldurb	w8, [x29, #-49]
	stur	w8, [x29, #-56]
	ldur	w0, [x29, #-56]
	bl	__ZN4core4char7methods22_$LT$impl$u20$char$GT$8to_digit17h9959f642128c2244E
	stur	w0, [x29, #-64]
	stur	w1, [x29, #-60]
	ldur	w8, [x29, #-64]
	stur	x8, [x29, #-48]
	ldur	x8, [x29, #-48]
	tbnz	w8, #0, LBB76_26
	b	LBB76_27
LBB76_25:
	ldr	w1, [sp, #92]
	ldr	x8, [sp, #24]
	adrp	x10, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x9, x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x10, [x10, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x9, [x9, #8]
	stur	x10, [x29, #-88]
	stur	x9, [x29, #-80]
	ldrb	w8, [x8]
	sturb	w8, [x29, #-49]
	ldurb	w8, [x29, #-49]
	stur	w8, [x29, #-56]
	ldur	w0, [x29, #-56]
	bl	__ZN4core4char7methods22_$LT$impl$u20$char$GT$8to_digit17h9959f642128c2244E
	stur	w0, [x29, #-64]
	stur	w1, [x29, #-60]
	ldur	w8, [x29, #-64]
	stur	x8, [x29, #-48]
	ldur	x8, [x29, #-48]
	tbnz	w8, #0, LBB76_31
	b	LBB76_27
LBB76_26:
	ldur	w8, [x29, #-60]
	stur	w8, [x29, #-36]
	ldur	w8, [x29, #-36]
	stur	x8, [x29, #-72]
	ldur	x8, [x29, #-80]
	stur	x8, [x29, #-32]
	ldur	x9, [x29, #-32]
	ldur	x8, [x29, #-72]
	add	x8, x9, x8
	subs	x8, x8, x9
	b.lo	LBB76_29
	b	LBB76_28
LBB76_27:
	ldr	x9, [sp, #80]
	mov	w8, #1
	strb	w8, [x9, #1]
	strb	w8, [x9]
	b	LBB76_30
LBB76_28:
	ldr	x8, [sp, #40]
	ldr	x9, [sp, #32]
	ldur	x10, [x29, #-32]
	ldur	x11, [x29, #-72]
	add	x10, x10, x11
	stur	x10, [x29, #-16]
	mov	w10, #1
	stur	x10, [x29, #-24]
	ldur	x10, [x29, #-16]
	stur	x10, [x29, #-32]
	str	x9, [sp, #96]
	str	x8, [sp, #104]
	b	LBB76_21
LBB76_29:
	ldr	x9, [sp, #80]
	mov	w8, #2
	strb	w8, [x9, #1]
	mov	w8, #1
	strb	w8, [x9]
	b	LBB76_30
LBB76_30:
	b	LBB76_32
LBB76_31:
	ldr	x9, [sp, #80]
	ldur	w8, [x29, #-60]
	stur	w8, [x29, #-36]
	ldur	w8, [x29, #-36]
	stur	x8, [x29, #-72]
	mov	w8, #2
	strb	w8, [x9, #1]
	mov	w8, #1
	strb	w8, [x9]
	b	LBB76_30
LBB76_32:
	b	LBB76_6
LBB76_33:
	ldr	x8, [sp, #104]
	subs	x8, x8, #1
	b.lo	LBB76_22
	b	LBB76_34
LBB76_34:
	ldr	w1, [sp, #92]
	ldr	x8, [sp, #96]
	ldr	x10, [sp, #96]
	ldr	x9, [sp, #104]
	add	x10, x10, #1
	str	x10, [sp, #8]
	subs	x9, x9, #1
	str	x9, [sp, #16]
	ldur	x9, [x29, #-32]
	mov	w10, w1
	mul	x9, x9, x10
	stur	x9, [x29, #-32]
	ldrb	w0, [x8]
	bl	__ZN4core4char7methods22_$LT$impl$u20$char$GT$8to_digit17h9959f642128c2244E
	stur	w0, [x29, #-96]
	stur	w1, [x29, #-92]
	ldur	w8, [x29, #-96]
	mov	x0, x8
	mov	x8, x0
	tbz	w8, #0, LBB76_36
	b	LBB76_35
LBB76_35:
	ldr	x8, [sp, #16]
	ldr	x9, [sp, #8]
	ldur	w10, [x29, #-92]
	mov	x11, x10
	ldur	x10, [x29, #-32]
	add	x10, x10, x11
	stur	x10, [x29, #-32]
	str	x9, [sp, #96]
	str	x8, [sp, #104]
	b	LBB76_33
LBB76_36:
	ldr	x9, [sp, #80]
	mov	w8, #1
	strb	w8, [x9, #1]
	strb	w8, [x9]
	b	LBB76_32
	.cfi_endproc

	.p2align	2
__ZN4core3num62_$LT$impl$u20$core..str..traits..FromStr$u20$for$u20$usize$GT$8from_str17h7e65c21c838e800dE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	w2, #10
	bl	__ZN4core3num23_$LT$impl$u20$usize$GT$16from_ascii_radix17hff4f44995668bd3eE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ops8function2Fn4call17h0713067d4e5929b1E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	w1, [x29, #-4]
	ldur	w0, [x29, #-4]
	bl	__ZN18const_random_macro12const_random17hed569f3c63c5ee75E
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ops8function5FnMut8call_mut17h3fe903e800f22662E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x1, [sp, #8]
	ldr	x0, [sp, #8]
	bl	__ZN62_$LT$proc_macro..TokenStream$u20$as$u20$core..clone..Clone$GT$5clone17h791f2e4680cecc0eE
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ops8function5impls79_$LT$impl$u20$core..ops..function..FnMut$LT$A$GT$$u20$for$u20$$RF$mut$u20$F$GT$8call_mut17h3c020253d6e4a8edE:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x1
	ldr	q0, [x8]
	mov	x1, sp
	str	q0, [sp]
	ldr	w8, [x8, #16]
	str	w8, [sp, #16]
	ldr	x0, [x0]
	bl	__ZN4core3ops8function5impls79_$LT$impl$u20$core..ops..function..FnMut$LT$A$GT$$u20$for$u20$$RF$mut$u20$F$GT$8call_mut17hcc7cd73f3e612967E
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ops8function5impls79_$LT$impl$u20$core..ops..function..FnMut$LT$A$GT$$u20$for$u20$$RF$mut$u20$F$GT$8call_mut17hcc7cd73f3e612967E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x1
	ldr	q0, [x8]
	mov	x1, sp
	str	q0, [sp]
	ldr	w8, [x8, #16]
	str	w8, [sp, #16]
	ldr	x0, [x0]
	bl	__ZN4core4iter6traits8iterator8Iterator8for_each4call28_$u7b$$u7b$closure$u7d$$u7d$17h1954e792d57e7178E
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ops8function6FnOnce9call_once17h98f3ede170e6f4cdE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp]
	str	x1, [sp, #8]
	ldr	x0, [sp]
	ldr	x1, [sp, #8]
	bl	__ZN5alloc3str56_$LT$impl$u20$alloc..borrow..ToOwned$u20$for$u20$str$GT$8to_owned17he0b18896824ffd95E
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ops8function6FnOnce9call_once17h9a2cf04c9b79e06eE:
Lfunc_begin26:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception26
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #24]
	ldr	x1, [sp, #24]
Ltmp460:
	add	x0, sp, #23
	bl	__ZN10proc_macro6bridge6client5state12BRIDGE_STATE29_$u7b$$u7b$constant$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$17hae68c7c3f20f4b63E
	str	x0, [sp, #8]
Ltmp461:
	b	LBB83_3
LBB83_1:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB83_2:
Ltmp462:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB83_1
LBB83_3:
	ldr	x0, [sp, #8]
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
Lfunc_end26:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table83:
Lexception26:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end26-Lcst_begin26
Lcst_begin26:
	.uleb128 Ltmp460-Lfunc_begin26
	.uleb128 Ltmp461-Ltmp460
	.uleb128 Ltmp462-Lfunc_begin26
	.byte	0
	.uleb128 Ltmp461-Lfunc_begin26
	.uleb128 Lfunc_end26-Ltmp461
	.byte	0
	.byte	0
Lcst_end26:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core3ops8function6FnOnce9call_once17hc850d19569b8f48aE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	ldr	x0, [sp, #8]
	bl	__ZN106_$LT$core..iter..adapters..chain..Chain$LT$A$C$B$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h232cd6a3faf0f7e0E
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr101drop_in_place$LT$std..io..error..ErrorData$LT$alloc..boxed..Box$LT$std..io..error..Custom$GT$$GT$$GT$17hc906c2cf77c5178aE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	ldrb	w8, [x0]
	add	x8, x8, #0
	subs	x8, x8, #2
	b.ls	LBB85_2
	b	LBB85_1
LBB85_1:
	ldr	x8, [sp, #8]
	add	x0, x8, #8
	bl	__ZN4core3ptr68drop_in_place$LT$alloc..boxed..Box$LT$std..io..error..Custom$GT$$GT$17hebe8838dfcb3c49fE
	b	LBB85_2
LBB85_2:
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr109drop_in_place$LT$core..option..Option$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$$GT$17ha878785b626741a0E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	ldrb	w8, [x0, #16]
	subs	w8, w8, #8
	cset	x8, ne
	cbnz	x8, LBB86_2
	b	LBB86_1
LBB86_1:
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB86_2:
	.cfi_restore_state
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr81drop_in_place$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$17hfb9b61ff9a9e03c9E
	b	LBB86_1
	.cfi_endproc

	.p2align	2
__ZN4core3ptr118drop_in_place$LT$alloc..boxed..Box$LT$dyn$u20$core..error..Error$u2b$core..marker..Sync$u2b$core..marker..Send$GT$$GT$17hded7057b82b1ddd8E:
Lfunc_begin27:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception27
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	ldr	x8, [x0]
	str	x8, [sp, #16]
	ldr	x8, [x0, #8]
	ldr	x8, [x8]
	str	x8, [sp, #24]
	cbz	x8, LBB87_2
	b	LBB87_1
LBB87_1:
Ltmp463:
	ldr	x8, [sp, #24]
	ldr	x0, [sp, #16]
	blr	x8
Ltmp464:
	b	LBB87_2
LBB87_2:
	ldr	x0, [sp, #8]
	bl	__ZN72_$LT$alloc..boxed..Box$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h956a1555026ee3dcE
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB87_3:
	.cfi_restore_state
Ltmp466:
	ldr	x0, [sp, #8]
	bl	__ZN72_$LT$alloc..boxed..Box$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h956a1555026ee3dcE
Ltmp467:
	b	LBB87_6
LBB87_4:
Ltmp465:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB87_3
LBB87_5:
Ltmp468:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB87_6:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
Lfunc_end27:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table87:
Lexception27:
	.byte	255
	.byte	155
	.uleb128 Lttbase17-Lttbaseref17
Lttbaseref17:
	.byte	1
	.uleb128 Lcst_end27-Lcst_begin27
Lcst_begin27:
	.uleb128 Ltmp463-Lfunc_begin27
	.uleb128 Ltmp464-Ltmp463
	.uleb128 Ltmp465-Lfunc_begin27
	.byte	0
	.uleb128 Ltmp464-Lfunc_begin27
	.uleb128 Ltmp466-Ltmp464
	.byte	0
	.byte	0
	.uleb128 Ltmp466-Lfunc_begin27
	.uleb128 Ltmp467-Ltmp466
	.uleb128 Ltmp468-Lfunc_begin27
	.byte	1
	.uleb128 Ltmp467-Lfunc_begin27
	.uleb128 Lfunc_end27-Ltmp467
	.byte	0
	.byte	0
Lcst_end27:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase17:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core3ptr128drop_in_place$LT$proc_macro..bridge..Group$LT$proc_macro..bridge..client..TokenStream$C$proc_macro..bridge..client..Span$GT$$GT$17he28510c8f4edc6fdE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	add	x0, x0, #12
	bl	__ZN4core3ptr88drop_in_place$LT$core..option..Option$LT$proc_macro..bridge..client..TokenStream$GT$$GT$17h893a38e436fedee0E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr156drop_in_place$LT$$LT$alloc..vec..into_iter..IntoIter$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$..drop..DropGuard$LT$u8$C$alloc..alloc..Global$GT$$GT$17h70575a127833dedcE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN157_$LT$$LT$alloc..vec..into_iter..IntoIter$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$..drop..DropGuard$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17he1d5e7b9fb93f404E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr164drop_in_place$LT$core..iter..adapters..map..Map$LT$alloc..vec..into_iter..IntoIter$LT$u8$GT$$C$const_random_macro..const_random..$u7b$$u7b$closure$u7d$$u7d$$GT$$GT$17h78c8a951f46e96c2E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr62drop_in_place$LT$alloc..vec..into_iter..IntoIter$LT$u8$GT$$GT$17h8c77e5da70aeae8dE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr169drop_in_place$LT$proc_macro..bridge..TokenTree$LT$proc_macro..bridge..client..TokenStream$C$proc_macro..bridge..client..Span$C$proc_macro..bridge..symbol..Symbol$GT$$GT$17h44f9606b540f7206E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	ldrb	w10, [x0, #16]
	mov	w8, #-4
	add	w9, w8, w10, uxtb
	mov	x8, x9
	and	x9, x8, #0xff
	mov	x8, #0
	subs	w10, w10, #4
	csinc	x8, x8, x9, lo
	cbnz	x8, LBB91_2
	b	LBB91_1
LBB91_1:
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr128drop_in_place$LT$proc_macro..bridge..Group$LT$proc_macro..bridge..client..TokenStream$C$proc_macro..bridge..client..Span$GT$$GT$17he28510c8f4edc6fdE
	b	LBB91_2
LBB91_2:
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr179drop_in_place$LT$$u5b$proc_macro..bridge..TokenTree$LT$proc_macro..bridge..client..TokenStream$C$proc_macro..bridge..client..Span$C$proc_macro..bridge..symbol..Symbol$GT$$u5d$$GT$17h4643010496cca31dE:
Lfunc_begin28:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception28
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	str	x1, [sp, #16]
	str	xzr, [sp, #24]
	b	LBB92_1
LBB92_1:
	ldr	x9, [sp, #16]
	ldr	x8, [sp, #24]
	subs	x8, x8, x9
	b.eq	LBB92_3
	b	LBB92_2
LBB92_2:
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #24]
	mov	w10, #20
	mul	x9, x9, x10
	add	x0, x8, x9
	ldr	x8, [sp, #24]
	add	x8, x8, #1
	str	x8, [sp, #24]
Ltmp469:
	bl	__ZN4core3ptr169drop_in_place$LT$proc_macro..bridge..TokenTree$LT$proc_macro..bridge..client..TokenStream$C$proc_macro..bridge..client..Span$C$proc_macro..bridge..symbol..Symbol$GT$$GT$17h44f9606b540f7206E
Ltmp470:
	b	LBB92_1
LBB92_3:
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB92_4:
	.cfi_restore_state
	ldr	x9, [sp, #16]
	ldr	x8, [sp, #24]
	subs	x8, x8, x9
	b.eq	LBB92_7
	b	LBB92_6
LBB92_5:
Ltmp471:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB92_4
LBB92_6:
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #24]
	mov	w10, #20
	mul	x9, x9, x10
	add	x0, x8, x9
	ldr	x8, [sp, #24]
	add	x8, x8, #1
	str	x8, [sp, #24]
Ltmp472:
	bl	__ZN4core3ptr169drop_in_place$LT$proc_macro..bridge..TokenTree$LT$proc_macro..bridge..client..TokenStream$C$proc_macro..bridge..client..Span$C$proc_macro..bridge..symbol..Symbol$GT$$GT$17h44f9606b540f7206E
Ltmp473:
	b	LBB92_4
LBB92_7:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB92_8:
Ltmp474:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
Lfunc_end28:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table92:
Lexception28:
	.byte	255
	.byte	155
	.uleb128 Lttbase18-Lttbaseref18
Lttbaseref18:
	.byte	1
	.uleb128 Lcst_end28-Lcst_begin28
Lcst_begin28:
	.uleb128 Ltmp469-Lfunc_begin28
	.uleb128 Ltmp470-Ltmp469
	.uleb128 Ltmp471-Lfunc_begin28
	.byte	0
	.uleb128 Ltmp472-Lfunc_begin28
	.uleb128 Ltmp473-Ltmp472
	.uleb128 Ltmp474-Lfunc_begin28
	.byte	1
	.uleb128 Ltmp473-Lfunc_begin28
	.uleb128 Lfunc_end28-Ltmp473
	.byte	0
	.byte	0
Lcst_end28:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase18:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core3ptr186drop_in_place$LT$core..iter..adapters..chain..Chain$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$C$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$$GT$17h65b6123a2200c75dE:
Lfunc_begin29:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception29
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
Ltmp475:
	bl	__ZN4core3ptr109drop_in_place$LT$core..option..Option$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$$GT$17ha878785b626741a0E
Ltmp476:
	b	LBB93_3
LBB93_1:
	ldr	x8, [sp, #8]
	add	x0, x8, #20
Ltmp478:
	bl	__ZN4core3ptr109drop_in_place$LT$core..option..Option$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$$GT$17ha878785b626741a0E
Ltmp479:
	b	LBB93_5
LBB93_2:
Ltmp477:
	str	x0, [sp, #16]
	mov	x8, x1
	str	w8, [sp, #24]
	b	LBB93_1
LBB93_3:
	ldr	x8, [sp, #8]
	add	x0, x8, #20
	bl	__ZN4core3ptr109drop_in_place$LT$core..option..Option$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$$GT$17ha878785b626741a0E
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB93_4:
	.cfi_restore_state
Ltmp480:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB93_5:
	ldr	x0, [sp, #16]
	bl	__Unwind_Resume
Lfunc_end29:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table93:
Lexception29:
	.byte	255
	.byte	155
	.uleb128 Lttbase19-Lttbaseref19
Lttbaseref19:
	.byte	1
	.uleb128 Lcst_end29-Lcst_begin29
Lcst_begin29:
	.uleb128 Ltmp475-Lfunc_begin29
	.uleb128 Ltmp476-Ltmp475
	.uleb128 Ltmp477-Lfunc_begin29
	.byte	0
	.uleb128 Ltmp478-Lfunc_begin29
	.uleb128 Ltmp479-Ltmp478
	.uleb128 Ltmp480-Lfunc_begin29
	.byte	1
	.uleb128 Ltmp479-Lfunc_begin29
	.uleb128 Lfunc_end29-Ltmp479
	.byte	0
	.byte	0
Lcst_end29:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase19:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core3ptr192drop_in_place$LT$alloc..vec..Vec$LT$proc_macro..bridge..TokenTree$LT$proc_macro..bridge..client..TokenStream$C$proc_macro..bridge..client..Span$C$proc_macro..bridge..symbol..Symbol$GT$$GT$$GT$17h0ae8dffb72c8e578E:
Lfunc_begin30:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception30
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
Ltmp481:
	bl	__ZN70_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h29ecb704495273afE
Ltmp482:
	b	LBB94_3
LBB94_1:
Ltmp484:
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr199drop_in_place$LT$alloc..raw_vec..RawVec$LT$proc_macro..bridge..TokenTree$LT$proc_macro..bridge..client..TokenStream$C$proc_macro..bridge..client..Span$C$proc_macro..bridge..symbol..Symbol$GT$$GT$$GT$17hc362280b72d91be0E
Ltmp485:
	b	LBB94_5
LBB94_2:
Ltmp483:
	str	x0, [sp, #16]
	mov	x8, x1
	str	w8, [sp, #24]
	b	LBB94_1
LBB94_3:
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr199drop_in_place$LT$alloc..raw_vec..RawVec$LT$proc_macro..bridge..TokenTree$LT$proc_macro..bridge..client..TokenStream$C$proc_macro..bridge..client..Span$C$proc_macro..bridge..symbol..Symbol$GT$$GT$$GT$17hc362280b72d91be0E
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB94_4:
	.cfi_restore_state
Ltmp486:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB94_5:
	ldr	x0, [sp, #16]
	bl	__Unwind_Resume
Lfunc_end30:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table94:
Lexception30:
	.byte	255
	.byte	155
	.uleb128 Lttbase20-Lttbaseref20
Lttbaseref20:
	.byte	1
	.uleb128 Lcst_end30-Lcst_begin30
Lcst_begin30:
	.uleb128 Ltmp481-Lfunc_begin30
	.uleb128 Ltmp482-Ltmp481
	.uleb128 Ltmp483-Lfunc_begin30
	.byte	0
	.uleb128 Ltmp484-Lfunc_begin30
	.uleb128 Ltmp485-Ltmp484
	.uleb128 Ltmp486-Lfunc_begin30
	.byte	1
	.uleb128 Ltmp485-Lfunc_begin30
	.uleb128 Lfunc_end30-Ltmp485
	.byte	0
	.byte	0
Lcst_end30:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase20:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core3ptr192drop_in_place$LT$core..option..Option$LT$core..iter..adapters..map..Map$LT$alloc..vec..into_iter..IntoIter$LT$u8$GT$$C$const_random_macro..const_random..$u7b$$u7b$closure$u7d$$u7d$$GT$$GT$$GT$17ha9bd805d6e3f4a18E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	ldr	x8, [x0]
	subs	x8, x8, #0
	cset	x8, ne
	cbnz	x8, LBB95_2
	b	LBB95_1
LBB95_1:
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB95_2:
	.cfi_restore_state
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr164drop_in_place$LT$core..iter..adapters..map..Map$LT$alloc..vec..into_iter..IntoIter$LT$u8$GT$$C$const_random_macro..const_random..$u7b$$u7b$closure$u7d$$u7d$$GT$$GT$17h78c8a951f46e96c2E
	b	LBB95_1
	.cfi_endproc

	.p2align	2
__ZN4core3ptr199drop_in_place$LT$alloc..raw_vec..RawVec$LT$proc_macro..bridge..TokenTree$LT$proc_macro..bridge..client..TokenStream$C$proc_macro..bridge..client..Span$C$proc_macro..bridge..symbol..Symbol$GT$$GT$$GT$17hc362280b72d91be0E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN77_$LT$alloc..raw_vec..RawVec$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h0531f8ee3197b342E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr204drop_in_place$LT$core..iter..adapters..fuse..Fuse$LT$core..iter..adapters..map..Map$LT$alloc..vec..into_iter..IntoIter$LT$u8$GT$$C$const_random_macro..const_random..$u7b$$u7b$closure$u7d$$u7d$$GT$$GT$$GT$17hac644255e63f835dE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr192drop_in_place$LT$core..option..Option$LT$core..iter..adapters..map..Map$LT$alloc..vec..into_iter..IntoIter$LT$u8$GT$$C$const_random_macro..const_random..$u7b$$u7b$closure$u7d$$u7d$$GT$$GT$$GT$17ha9bd805d6e3f4a18E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr214drop_in_place$LT$core..option..Option$LT$core..iter..adapters..chain..Chain$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$C$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$$GT$$GT$17h10b2cc43609e91c3E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	ldrb	w8, [x0, #36]
	subs	w8, w8, #9
	cset	x8, ne
	cbnz	x8, LBB98_2
	b	LBB98_1
LBB98_1:
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB98_2:
	.cfi_restore_state
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr186drop_in_place$LT$core..iter..adapters..chain..Chain$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$C$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$$GT$17h65b6123a2200c75dE
	b	LBB98_1
	.cfi_endproc

	.p2align	2
__ZN4core3ptr340drop_in_place$LT$core..iter..adapters..flatten..FlatMap$LT$alloc..vec..into_iter..IntoIter$LT$u8$GT$$C$core..iter..adapters..chain..Chain$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$C$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$$C$const_random_macro..const_random..$u7b$$u7b$closure$u7d$$u7d$$GT$$GT$17hf231409c60f89aa3E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr384drop_in_place$LT$core..iter..adapters..flatten..FlattenCompat$LT$core..iter..adapters..map..Map$LT$alloc..vec..into_iter..IntoIter$LT$u8$GT$$C$const_random_macro..const_random..$u7b$$u7b$closure$u7d$$u7d$$GT$$C$core..iter..adapters..chain..Chain$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$C$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$$GT$$GT$17h80460a33d5c6ffeaE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr384drop_in_place$LT$core..iter..adapters..flatten..FlattenCompat$LT$core..iter..adapters..map..Map$LT$alloc..vec..into_iter..IntoIter$LT$u8$GT$$C$const_random_macro..const_random..$u7b$$u7b$closure$u7d$$u7d$$GT$$C$core..iter..adapters..chain..Chain$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$C$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$$GT$$GT$17h80460a33d5c6ffeaE:
Lfunc_begin31:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception31
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
Ltmp487:
	bl	__ZN4core3ptr204drop_in_place$LT$core..iter..adapters..fuse..Fuse$LT$core..iter..adapters..map..Map$LT$alloc..vec..into_iter..IntoIter$LT$u8$GT$$C$const_random_macro..const_random..$u7b$$u7b$closure$u7d$$u7d$$GT$$GT$$GT$17hac644255e63f835dE
Ltmp488:
	b	LBB100_3
LBB100_1:
	ldr	x8, [sp, #8]
	add	x0, x8, #32
Ltmp490:
	bl	__ZN4core3ptr214drop_in_place$LT$core..option..Option$LT$core..iter..adapters..chain..Chain$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$C$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$$GT$$GT$17h10b2cc43609e91c3E
Ltmp491:
	b	LBB100_4
LBB100_2:
Ltmp489:
	str	x0, [sp, #16]
	mov	x8, x1
	str	w8, [sp, #24]
	b	LBB100_1
LBB100_3:
	ldr	x8, [sp, #8]
	add	x0, x8, #32
Ltmp492:
	bl	__ZN4core3ptr214drop_in_place$LT$core..option..Option$LT$core..iter..adapters..chain..Chain$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$C$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$$GT$$GT$17h10b2cc43609e91c3E
Ltmp493:
	b	LBB100_6
LBB100_4:
	ldr	x8, [sp, #8]
	add	x0, x8, #72
Ltmp495:
	bl	__ZN4core3ptr214drop_in_place$LT$core..option..Option$LT$core..iter..adapters..chain..Chain$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$C$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$$GT$$GT$17h10b2cc43609e91c3E
Ltmp496:
	b	LBB100_8
LBB100_5:
Ltmp494:
	str	x0, [sp, #16]
	mov	x8, x1
	str	w8, [sp, #24]
	b	LBB100_4
LBB100_6:
	ldr	x8, [sp, #8]
	add	x0, x8, #72
	bl	__ZN4core3ptr214drop_in_place$LT$core..option..Option$LT$core..iter..adapters..chain..Chain$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$C$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$$GT$$GT$17h10b2cc43609e91c3E
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB100_7:
	.cfi_restore_state
Ltmp497:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB100_8:
	ldr	x0, [sp, #16]
	bl	__Unwind_Resume
Lfunc_end31:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table100:
Lexception31:
	.byte	255
	.byte	155
	.uleb128 Lttbase21-Lttbaseref21
Lttbaseref21:
	.byte	1
	.uleb128 Lcst_end31-Lcst_begin31
Lcst_begin31:
	.uleb128 Ltmp487-Lfunc_begin31
	.uleb128 Ltmp488-Ltmp487
	.uleb128 Ltmp489-Lfunc_begin31
	.byte	0
	.uleb128 Ltmp490-Lfunc_begin31
	.uleb128 Ltmp491-Ltmp490
	.uleb128 Ltmp497-Lfunc_begin31
	.byte	1
	.uleb128 Ltmp492-Lfunc_begin31
	.uleb128 Ltmp493-Ltmp492
	.uleb128 Ltmp494-Lfunc_begin31
	.byte	0
	.uleb128 Ltmp495-Lfunc_begin31
	.uleb128 Ltmp496-Ltmp495
	.uleb128 Ltmp497-Lfunc_begin31
	.byte	1
	.uleb128 Ltmp496-Lfunc_begin31
	.uleb128 Lfunc_end31-Ltmp496
	.byte	0
	.byte	0
Lcst_end31:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase21:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core3ptr38drop_in_place$LT$proc_macro..Group$GT$17h2ad16be25810d4dbE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr128drop_in_place$LT$proc_macro..bridge..Group$LT$proc_macro..bridge..client..TokenStream$C$proc_macro..bridge..client..Span$GT$$GT$17he28510c8f4edc6fdE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17ha9d9ccced2dc1daeE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr46drop_in_place$LT$alloc..vec..Vec$LT$u8$GT$$GT$17h2f7b2d448e5199ebE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr42drop_in_place$LT$proc_macro..TokenTree$GT$17hd11f125074dcf256E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	ldrb	w10, [x0, #16]
	mov	w8, #-4
	add	w9, w8, w10, uxtb
	mov	x8, x9
	and	x9, x8, #0xff
	mov	x8, #0
	subs	w10, w10, #4
	csinc	x8, x8, x9, lo
	cbnz	x8, LBB103_2
	b	LBB103_1
LBB103_1:
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr38drop_in_place$LT$proc_macro..Group$GT$17h2ad16be25810d4dbE
	b	LBB103_2
LBB103_2:
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr42drop_in_place$LT$std..io..error..Error$GT$17h0afc3805cbdcff76E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr57drop_in_place$LT$std..io..error..repr_bitpacked..Repr$GT$17h251e113774230ae3E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr435drop_in_place$LT$proc_macro..bridge..client..run_client$LT$proc_macro..bridge..client..TokenStream$C$core..option..Option$LT$proc_macro..bridge..client..TokenStream$GT$$C$proc_macro..bridge..client..Client$LT$proc_macro..TokenStream$C$proc_macro..TokenStream$GT$..expand1$LT$const_random_macro..const_random$GT$..$u7b$$u7b$closure$u7d$$u7d$..$u7b$$u7b$closure$u7d$$u7d$$GT$..$u7b$$u7b$closure$u7d$$u7d$..$u7b$$u7b$closure$u7d$$u7d$$GT$17hc72aaedc0b1a8e00E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	add	x0, x0, #8
	bl	__ZN4core3ptr60drop_in_place$LT$proc_macro..bridge..client..TokenStream$GT$17h8d3af34d91a55fb5E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr43drop_in_place$LT$std..io..error..Custom$GT$17h9093af5f557b5909E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr118drop_in_place$LT$alloc..boxed..Box$LT$dyn$u20$core..error..Error$u2b$core..marker..Sync$u2b$core..marker..Send$GT$$GT$17hded7057b82b1ddd8E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr44drop_in_place$LT$proc_macro..TokenStream$GT$17h125cfb6c70942766E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr88drop_in_place$LT$core..option..Option$LT$proc_macro..bridge..client..TokenStream$GT$$GT$17h893a38e436fedee0E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr46drop_in_place$LT$alloc..vec..Vec$LT$u8$GT$$GT$17h2f7b2d448e5199ebE:
Lfunc_begin32:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception32
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
Ltmp498:
	bl	__RNvXso_NtCs8dnTdrJsiec_5alloc3vecINtB5_3VechENtNtNtCs6sq8b9ugfBC_4core3ops4drop4Drop4dropCsixjwb4TfRM4_5gimli
Ltmp499:
	b	LBB108_3
LBB108_1:
Ltmp501:
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr53drop_in_place$LT$alloc..raw_vec..RawVec$LT$u8$GT$$GT$17h5f45389c4a49b664E
Ltmp502:
	b	LBB108_5
LBB108_2:
Ltmp500:
	str	x0, [sp, #16]
	mov	x8, x1
	str	w8, [sp, #24]
	b	LBB108_1
LBB108_3:
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr53drop_in_place$LT$alloc..raw_vec..RawVec$LT$u8$GT$$GT$17h5f45389c4a49b664E
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB108_4:
	.cfi_restore_state
Ltmp503:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB108_5:
	ldr	x0, [sp, #16]
	bl	__Unwind_Resume
Lfunc_end32:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table108:
Lexception32:
	.byte	255
	.byte	155
	.uleb128 Lttbase22-Lttbaseref22
Lttbaseref22:
	.byte	1
	.uleb128 Lcst_end32-Lcst_begin32
Lcst_begin32:
	.uleb128 Ltmp498-Lfunc_begin32
	.uleb128 Ltmp499-Ltmp498
	.uleb128 Ltmp500-Lfunc_begin32
	.byte	0
	.uleb128 Ltmp501-Lfunc_begin32
	.uleb128 Ltmp502-Ltmp501
	.uleb128 Ltmp503-Lfunc_begin32
	.byte	1
	.uleb128 Ltmp502-Lfunc_begin32
	.uleb128 Lfunc_end32-Ltmp502
	.byte	0
	.byte	0
Lcst_end32:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase22:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core3ptr50drop_in_place$LT$proc_macro..ConcatTreesHelper$GT$17he62cdc061752675aE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr192drop_in_place$LT$alloc..vec..Vec$LT$proc_macro..bridge..TokenTree$LT$proc_macro..bridge..client..TokenStream$C$proc_macro..bridge..client..Span$C$proc_macro..bridge..symbol..Symbol$GT$$GT$$GT$17h0ae8dffb72c8e578E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr52drop_in_place$LT$proc_macro..ConcatStreamsHelper$GT$17h6e516cabcfebb7daE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr83drop_in_place$LT$alloc..vec..Vec$LT$proc_macro..bridge..client..TokenStream$GT$$GT$17h0b133cc3b4b68275E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr53drop_in_place$LT$alloc..raw_vec..RawVec$LT$u8$GT$$GT$17h5f45389c4a49b664E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__RNvXs1_NtCs8dnTdrJsiec_5alloc7raw_vecINtB5_6RawVechENtNtNtCs6sq8b9ugfBC_4core3ops4drop4Drop4dropCsixjwb4TfRM4_5gimli
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr53drop_in_place$LT$proc_macro..bridge..BridgeConfig$GT$17hd6b59ce4f6e1f1beE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr55drop_in_place$LT$proc_macro..bridge..buffer..Buffer$GT$17h34058bc54716feb8E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr55drop_in_place$LT$proc_macro..bridge..buffer..Buffer$GT$17h34058bc54716feb8E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN76_$LT$proc_macro..bridge..buffer..Buffer$u20$as$u20$core..ops..drop..Drop$GT$4drop17h2efde6d4d19a13c5E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr55drop_in_place$LT$proc_macro..bridge..client..Bridge$GT$17h0757b771374b046dE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	add	x0, x0, #16
	bl	__ZN4core3ptr55drop_in_place$LT$proc_macro..bridge..buffer..Buffer$GT$17h34058bc54716feb8E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr57drop_in_place$LT$std..io..error..repr_bitpacked..Repr$GT$17h251e113774230ae3E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN78_$LT$std..io..error..repr_bitpacked..Repr$u20$as$u20$core..ops..drop..Drop$GT$4drop17hed49dd561b05d467E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr58drop_in_place$LT$proc_macro..bridge..rpc..PanicMessage$GT$17h25717a361552132cE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	ldr	x9, [x0]
	mov	x8, #-9223372036854775808
	add	x8, x9, x8
	mov	x10, #-9223372036854775808
	subs	x9, x9, x10
	csinc	x8, x8, xzr, hs
	subs	x8, x8, #1
	b.ne	LBB116_2
	b	LBB116_1
LBB116_1:
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17ha9d9ccced2dc1daeE
	b	LBB116_2
LBB116_2:
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr60drop_in_place$LT$proc_macro..bridge..client..TokenStream$GT$17h8d3af34d91a55fb5E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__RNvXs0_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6clientNtB5_11TokenStreamNtNtNtCs6sq8b9ugfBC_4core3ops4drop4Drop4drop
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr62drop_in_place$LT$alloc..vec..into_iter..IntoIter$LT$u8$GT$$GT$17h8c77e5da70aeae8dE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN86_$LT$alloc..vec..into_iter..IntoIter$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h97a038f010e8f4e3E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr65drop_in_place$LT$$u5b$proc_macro..TokenStream$u3b$$u20$3$u5d$$GT$17haab9bdcebd5db8faE:
Lfunc_begin33:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception33
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp]
	str	xzr, [sp, #8]
	b	LBB119_1
LBB119_1:
	ldr	x8, [sp, #8]
	subs	x8, x8, #3
	b.eq	LBB119_3
	b	LBB119_2
LBB119_2:
	ldr	x8, [sp]
	ldr	x9, [sp, #8]
	add	x0, x8, x9, lsl #2
	ldr	x8, [sp, #8]
	add	x8, x8, #1
	str	x8, [sp, #8]
Ltmp504:
	bl	__ZN4core3ptr44drop_in_place$LT$proc_macro..TokenStream$GT$17h125cfb6c70942766E
Ltmp505:
	b	LBB119_1
LBB119_3:
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB119_4:
	.cfi_restore_state
	ldr	x8, [sp, #8]
	subs	x8, x8, #3
	b.eq	LBB119_7
	b	LBB119_6
LBB119_5:
Ltmp506:
	str	x0, [sp, #16]
	mov	x8, x1
	str	w8, [sp, #24]
	b	LBB119_4
LBB119_6:
	ldr	x8, [sp]
	ldr	x9, [sp, #8]
	add	x0, x8, x9, lsl #2
	ldr	x8, [sp, #8]
	add	x8, x8, #1
	str	x8, [sp, #8]
Ltmp507:
	bl	__ZN4core3ptr44drop_in_place$LT$proc_macro..TokenStream$GT$17h125cfb6c70942766E
Ltmp508:
	b	LBB119_4
LBB119_7:
	ldr	x0, [sp, #16]
	bl	__Unwind_Resume
LBB119_8:
Ltmp509:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
Lfunc_end33:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table119:
Lexception33:
	.byte	255
	.byte	155
	.uleb128 Lttbase23-Lttbaseref23
Lttbaseref23:
	.byte	1
	.uleb128 Lcst_end33-Lcst_begin33
Lcst_begin33:
	.uleb128 Ltmp504-Lfunc_begin33
	.uleb128 Ltmp505-Ltmp504
	.uleb128 Ltmp506-Lfunc_begin33
	.byte	0
	.uleb128 Ltmp507-Lfunc_begin33
	.uleb128 Ltmp508-Ltmp507
	.uleb128 Ltmp509-Lfunc_begin33
	.byte	1
	.uleb128 Ltmp508-Lfunc_begin33
	.uleb128 Lfunc_end33-Ltmp508
	.byte	0
	.byte	0
Lcst_end33:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase23:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core3ptr68drop_in_place$LT$alloc..boxed..Box$LT$std..io..error..Custom$GT$$GT$17hebe8838dfcb3c49fE:
Lfunc_begin34:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception34
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	ldr	x0, [x0]
Ltmp510:
	bl	__ZN4core3ptr43drop_in_place$LT$std..io..error..Custom$GT$17h9093af5f557b5909E
Ltmp511:
	b	LBB120_3
LBB120_1:
Ltmp513:
	ldr	x0, [sp, #8]
	bl	__ZN72_$LT$alloc..boxed..Box$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17hf9c7aeca1564b72dE
Ltmp514:
	b	LBB120_5
LBB120_2:
Ltmp512:
	str	x0, [sp, #16]
	mov	x8, x1
	str	w8, [sp, #24]
	b	LBB120_1
LBB120_3:
	ldr	x0, [sp, #8]
	bl	__ZN72_$LT$alloc..boxed..Box$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17hf9c7aeca1564b72dE
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB120_4:
	.cfi_restore_state
Ltmp515:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB120_5:
	ldr	x0, [sp, #16]
	bl	__Unwind_Resume
Lfunc_end34:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table120:
Lexception34:
	.byte	255
	.byte	155
	.uleb128 Lttbase24-Lttbaseref24
Lttbaseref24:
	.byte	1
	.uleb128 Lcst_end34-Lcst_begin34
Lcst_begin34:
	.uleb128 Ltmp510-Lfunc_begin34
	.uleb128 Ltmp511-Ltmp510
	.uleb128 Ltmp512-Lfunc_begin34
	.byte	0
	.uleb128 Ltmp513-Lfunc_begin34
	.uleb128 Ltmp514-Ltmp513
	.uleb128 Ltmp515-Lfunc_begin34
	.byte	1
	.uleb128 Ltmp514-Lfunc_begin34
	.uleb128 Lfunc_end34-Ltmp514
	.byte	0
	.byte	0
Lcst_end34:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase24:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core3ptr68drop_in_place$LT$core..option..Item$LT$proc_macro..TokenTree$GT$$GT$17h9e2842637cc9c635E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr70drop_in_place$LT$core..option..Option$LT$proc_macro..TokenTree$GT$$GT$17h191223b294984d94E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr70drop_in_place$LT$$u5b$proc_macro..bridge..client..TokenStream$u5d$$GT$17hfb030babc04bc1c2E:
Lfunc_begin35:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception35
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	str	x1, [sp, #16]
	str	xzr, [sp, #24]
	b	LBB122_1
LBB122_1:
	ldr	x9, [sp, #16]
	ldr	x8, [sp, #24]
	subs	x8, x8, x9
	b.eq	LBB122_3
	b	LBB122_2
LBB122_2:
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #24]
	add	x0, x8, x9, lsl #2
	ldr	x8, [sp, #24]
	add	x8, x8, #1
	str	x8, [sp, #24]
Ltmp516:
	bl	__ZN4core3ptr60drop_in_place$LT$proc_macro..bridge..client..TokenStream$GT$17h8d3af34d91a55fb5E
Ltmp517:
	b	LBB122_1
LBB122_3:
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB122_4:
	.cfi_restore_state
	ldr	x9, [sp, #16]
	ldr	x8, [sp, #24]
	subs	x8, x8, x9
	b.eq	LBB122_7
	b	LBB122_6
LBB122_5:
Ltmp518:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB122_4
LBB122_6:
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #24]
	add	x0, x8, x9, lsl #2
	ldr	x8, [sp, #24]
	add	x8, x8, #1
	str	x8, [sp, #24]
Ltmp519:
	bl	__ZN4core3ptr60drop_in_place$LT$proc_macro..bridge..client..TokenStream$GT$17h8d3af34d91a55fb5E
Ltmp520:
	b	LBB122_4
LBB122_7:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB122_8:
Ltmp521:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
Lfunc_end35:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table122:
Lexception35:
	.byte	255
	.byte	155
	.uleb128 Lttbase25-Lttbaseref25
Lttbaseref25:
	.byte	1
	.uleb128 Lcst_end35-Lcst_begin35
Lcst_begin35:
	.uleb128 Ltmp516-Lfunc_begin35
	.uleb128 Ltmp517-Ltmp516
	.uleb128 Ltmp518-Lfunc_begin35
	.byte	0
	.uleb128 Ltmp519-Lfunc_begin35
	.uleb128 Ltmp520-Ltmp519
	.uleb128 Ltmp521-Lfunc_begin35
	.byte	1
	.uleb128 Ltmp520-Lfunc_begin35
	.uleb128 Lfunc_end35-Ltmp520
	.byte	0
	.byte	0
Lcst_end35:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase25:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core3ptr70drop_in_place$LT$core..option..Option$LT$proc_macro..TokenTree$GT$$GT$17h191223b294984d94E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	ldrb	w8, [x0, #16]
	subs	w8, w8, #7
	cset	x8, ne
	cbnz	x8, LBB123_2
	b	LBB123_1
LBB123_1:
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB123_2:
	.cfi_restore_state
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr42drop_in_place$LT$proc_macro..TokenTree$GT$17hd11f125074dcf256E
	b	LBB123_1
	.cfi_endproc

	.p2align	2
__ZN4core3ptr71drop_in_place$LT$alloc..boxed..Box$LT$alloc..vec..Vec$LT$u8$GT$$GT$$GT$17he5f2df7f14c16a1bE:
Lfunc_begin36:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception36
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	ldr	x0, [x0]
Ltmp522:
	bl	__ZN4core3ptr46drop_in_place$LT$alloc..vec..Vec$LT$u8$GT$$GT$17h2f7b2d448e5199ebE
Ltmp523:
	b	LBB124_3
LBB124_1:
Ltmp525:
	ldr	x0, [sp, #8]
	bl	__ZN72_$LT$alloc..boxed..Box$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h14ec8648543f5c08E
Ltmp526:
	b	LBB124_5
LBB124_2:
Ltmp524:
	str	x0, [sp, #16]
	mov	x8, x1
	str	w8, [sp, #24]
	b	LBB124_1
LBB124_3:
	ldr	x0, [sp, #8]
	bl	__ZN72_$LT$alloc..boxed..Box$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h14ec8648543f5c08E
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB124_4:
	.cfi_restore_state
Ltmp527:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB124_5:
	ldr	x0, [sp, #16]
	bl	__Unwind_Resume
Lfunc_end36:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table124:
Lexception36:
	.byte	255
	.byte	155
	.uleb128 Lttbase26-Lttbaseref26
Lttbaseref26:
	.byte	1
	.uleb128 Lcst_end36-Lcst_begin36
Lcst_begin36:
	.uleb128 Ltmp522-Lfunc_begin36
	.uleb128 Ltmp523-Ltmp522
	.uleb128 Ltmp524-Lfunc_begin36
	.byte	0
	.uleb128 Ltmp525-Lfunc_begin36
	.uleb128 Ltmp526-Ltmp525
	.uleb128 Ltmp527-Lfunc_begin36
	.byte	1
	.uleb128 Ltmp526-Lfunc_begin36
	.uleb128 Lfunc_end36-Ltmp526
	.byte	0
	.byte	0
Lcst_end36:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase26:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core3ptr72drop_in_place$LT$core..option..IntoIter$LT$proc_macro..TokenTree$GT$$GT$17h39cd88c8d7247594E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr68drop_in_place$LT$core..option..Item$LT$proc_macro..TokenTree$GT$$GT$17h9e2842637cc9c635E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr74drop_in_place$LT$proc_macro..bridge..client..state..set..RestoreOnDrop$GT$17hd4169d69cfe4f5e0E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__RNvXNvNtNtNtCs7B2A3P5pSWO_10proc_macro6bridge6client5state3setNtB2_13RestoreOnDropNtNtNtCs6sq8b9ugfBC_4core3ops4drop4Drop4drop
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr7mut_ptr31_$LT$impl$u20$$BP$mut$u20$T$GT$7is_null17h3227f650dca8f8a8E:
	.cfi_startproc
	subs	x8, x0, #0
	cset	w0, eq
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr81drop_in_place$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$17hfb9b61ff9a9e03c9E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr72drop_in_place$LT$core..option..IntoIter$LT$proc_macro..TokenTree$GT$$GT$17h39cd88c8d7247594E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr82drop_in_place$LT$core..cell..RefCell$LT$proc_macro..bridge..client..Bridge$GT$$GT$17he593bddf492e9d7cE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	add	x0, x0, #8
	bl	__ZN4core3ptr85drop_in_place$LT$core..cell..UnsafeCell$LT$proc_macro..bridge..client..Bridge$GT$$GT$17hf02dc760f0f490bcE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr83drop_in_place$LT$alloc..vec..Vec$LT$proc_macro..bridge..client..TokenStream$GT$$GT$17h0b133cc3b4b68275E:
Lfunc_begin37:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception37
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
Ltmp528:
	bl	__ZN70_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h91322b7b504faf15E
Ltmp529:
	b	LBB130_3
LBB130_1:
Ltmp531:
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr90drop_in_place$LT$alloc..raw_vec..RawVec$LT$proc_macro..bridge..client..TokenStream$GT$$GT$17h7851a272a3218807E
Ltmp532:
	b	LBB130_5
LBB130_2:
Ltmp530:
	str	x0, [sp, #16]
	mov	x8, x1
	str	w8, [sp, #24]
	b	LBB130_1
LBB130_3:
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr90drop_in_place$LT$alloc..raw_vec..RawVec$LT$proc_macro..bridge..client..TokenStream$GT$$GT$17h7851a272a3218807E
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB130_4:
	.cfi_restore_state
Ltmp533:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB130_5:
	ldr	x0, [sp, #16]
	bl	__Unwind_Resume
Lfunc_end37:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table130:
Lexception37:
	.byte	255
	.byte	155
	.uleb128 Lttbase27-Lttbaseref27
Lttbaseref27:
	.byte	1
	.uleb128 Lcst_end37-Lcst_begin37
Lcst_begin37:
	.uleb128 Ltmp528-Lfunc_begin37
	.uleb128 Ltmp529-Ltmp528
	.uleb128 Ltmp530-Lfunc_begin37
	.byte	0
	.uleb128 Ltmp531-Lfunc_begin37
	.uleb128 Ltmp532-Ltmp531
	.uleb128 Ltmp533-Lfunc_begin37
	.byte	1
	.uleb128 Ltmp532-Lfunc_begin37
	.uleb128 Lfunc_end37-Ltmp532
	.byte	0
	.byte	0
Lcst_end37:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase27:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core3ptr85drop_in_place$LT$core..cell..UnsafeCell$LT$proc_macro..bridge..client..Bridge$GT$$GT$17hf02dc760f0f490bcE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr55drop_in_place$LT$proc_macro..bridge..client..Bridge$GT$17h0757b771374b046dE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr88drop_in_place$LT$core..option..Option$LT$proc_macro..bridge..client..TokenStream$GT$$GT$17h893a38e436fedee0E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	ldr	w8, [x0]
	subs	w8, w8, #0
	cset	x8, ne
	cbnz	x8, LBB132_2
	b	LBB132_1
LBB132_1:
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB132_2:
	.cfi_restore_state
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr60drop_in_place$LT$proc_macro..bridge..client..TokenStream$GT$17h8d3af34d91a55fb5E
	b	LBB132_1
	.cfi_endproc

	.p2align	2
__ZN4core3ptr88drop_in_place$LT$once_cell..race..once_box..OnceBox$LT$alloc..vec..Vec$LT$u8$GT$$GT$$GT$17hc7d1e95bde677308E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN85_$LT$once_cell..race..once_box..OnceBox$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17haf04d5ffa9c89b96E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr90drop_in_place$LT$alloc..raw_vec..RawVec$LT$proc_macro..bridge..client..TokenStream$GT$$GT$17h7851a272a3218807E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN77_$LT$alloc..raw_vec..RawVec$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h1c55d22b397266c0E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr93drop_in_place$LT$dyn$u20$core..error..Error$u2b$core..marker..Sync$u2b$core..marker..Send$GT$17hcaa4291662874569E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp]
	ldr	x8, [x1]
	str	x8, [sp, #8]
	cbz	x8, LBB135_2
	b	LBB135_1
LBB135_1:
	ldr	x8, [sp, #8]
	ldr	x0, [sp]
	blr	x8
	b	LBB135_2
LBB135_2:
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3str21_$LT$impl$u20$str$GT$11starts_with17hd01ec385fb552c31E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp]
	str	x1, [sp, #8]
	mov	x0, x2
	ldr	x2, [sp]
	mov	x1, x3
	ldr	x3, [sp, #8]
	bl	__ZN55_$LT$$RF$str$u20$as$u20$core..str..pattern..Pattern$GT$12is_prefix_of17h50d2faf60bd928bdE
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3str21_$LT$impl$u20$str$GT$3len17hdb37fd8006602fe7E:
	.cfi_startproc
	mov	x0, x1
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3str21_$LT$impl$u20$str$GT$5parse17ha478563f57f82201E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3num62_$LT$impl$u20$core..str..traits..FromStr$u20$for$u20$usize$GT$8from_str17h7e65c21c838e800dE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3str21_$LT$impl$u20$str$GT$9ends_with17h71ce4646b64925e0E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp]
	mov	x0, x1
	ldr	x1, [sp]
	str	x0, [sp, #8]
	mov	x0, x2
	ldr	x2, [sp, #8]
	bl	__ZN52_$LT$char$u20$as$u20$core..str..pattern..Pattern$GT$12is_suffix_of17h7f3ea908676d8ed0E
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3str6traits108_$LT$impl$u20$core..slice..index..SliceIndex$LT$str$GT$$u20$for$u20$core..ops..range..Range$LT$usize$GT$$GT$3get17h1b7df27483241a36E:
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
	subs	x8, x0, x1
	b.ls	LBB140_2
	b	LBB140_1
LBB140_1:
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x9, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x8, [x8, #8]
	stur	x9, [x29, #-24]
	stur	x8, [x29, #-16]
	b	LBB140_21
LBB140_2:
	ldr	x8, [sp, #8]
	cbnz	x8, LBB140_4
	b	LBB140_3
LBB140_3:
	b	LBB140_5
LBB140_4:
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #32]
	subs	x8, x8, x9
	b.hs	LBB140_7
	b	LBB140_6
LBB140_5:
	ldr	x8, [sp, #16]
	cbz	x8, LBB140_12
	b	LBB140_13
LBB140_6:
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #32]
	subs	x8, x8, x9
	b.lo	LBB140_8
	b	LBB140_9
LBB140_7:
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #32]
	subs	x8, x8, x9
	cset	w8, eq
	sturb	w8, [x29, #-2]
	b	LBB140_10
LBB140_8:
	ldr	x8, [sp, #24]
	ldr	x9, [sp, #8]
	add	x8, x8, x9
	ldrb	w8, [x8]
	sxtb	w8, w8
	adds	w8, w8, #64
	cset	w8, ge
	sturb	w8, [x29, #-2]
	b	LBB140_10
LBB140_9:
	ldr	x1, [sp, #32]
	ldr	x0, [sp, #8]
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.63@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.63@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB140_10:
	ldurb	w8, [x29, #-2]
	tbnz	w8, #0, LBB140_5
	b	LBB140_11
LBB140_11:
	b	LBB140_1
LBB140_12:
	b	LBB140_14
LBB140_13:
	ldr	x8, [sp, #16]
	ldr	x9, [sp, #32]
	subs	x8, x8, x9
	b.hs	LBB140_16
	b	LBB140_15
LBB140_14:
	b	LBB140_22
LBB140_15:
	ldr	x8, [sp, #16]
	ldr	x9, [sp, #32]
	subs	x8, x8, x9
	b.lo	LBB140_17
	b	LBB140_18
LBB140_16:
	ldr	x8, [sp, #16]
	ldr	x9, [sp, #32]
	subs	x8, x8, x9
	cset	w8, eq
	sturb	w8, [x29, #-1]
	b	LBB140_19
LBB140_17:
	ldr	x8, [sp, #24]
	ldr	x9, [sp, #16]
	add	x8, x8, x9
	ldrb	w8, [x8]
	sxtb	w8, w8
	adds	w8, w8, #64
	cset	w8, ge
	sturb	w8, [x29, #-1]
	b	LBB140_19
LBB140_18:
	ldr	x1, [sp, #32]
	ldr	x0, [sp, #16]
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.63@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.63@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_bounds_check
LBB140_19:
	ldurb	w8, [x29, #-1]
	tbnz	w8, #0, LBB140_14
	b	LBB140_20
LBB140_20:
	b	LBB140_1
LBB140_21:
	ldur	x0, [x29, #-24]
	ldur	x1, [x29, #-16]
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB140_22:
	.cfi_restore_state
	ldr	x9, [sp, #24]
	ldr	x10, [sp, #8]
	ldr	x8, [sp, #16]
	subs	x8, x8, x10
	add	x9, x9, x10
	stur	x9, [x29, #-24]
	stur	x8, [x29, #-16]
	b	LBB140_21
	.cfi_endproc

	.p2align	2
__ZN4core3str6traits108_$LT$impl$u20$core..slice..index..SliceIndex$LT$str$GT$$u20$for$u20$core..ops..range..Range$LT$usize$GT$$GT$5index17ha961c6f0898344d7E:
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
	bl	__ZN4core3str6traits108_$LT$impl$u20$core..slice..index..SliceIndex$LT$str$GT$$u20$for$u20$core..ops..range..Range$LT$usize$GT$$GT$3get17h1b7df27483241a36E
	stur	x0, [x29, #-16]
	stur	x1, [x29, #-8]
	ldur	x8, [x29, #-16]
	subs	x8, x8, #0
	cset	x8, ne
	tbz	w8, #0, LBB141_2
	b	LBB141_1
LBB141_1:
	ldur	x0, [x29, #-16]
	ldur	x1, [x29, #-8]
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB141_2:
	.cfi_restore_state
	ldur	x4, [x29, #-24]
	ldr	x3, [sp, #16]
	ldr	x2, [sp, #8]
	ldr	x1, [sp, #32]
	ldr	x0, [sp, #24]
	bl	__RNvNtCs6sq8b9ugfBC_4core3str16slice_error_fail
	.cfi_endproc

	.p2align	2
__ZN4core3str6traits54_$LT$impl$u20$core..cmp..PartialEq$u20$for$u20$str$GT$2eq17ha8f8586c4cffa0c6E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp]
	str	x1, [sp, #8]
	str	x2, [sp, #16]
	subs	x8, x1, x3
	b.eq	LBB142_2
	b	LBB142_1
LBB142_1:
	sturb	wzr, [x29, #-5]
	b	LBB142_3
LBB142_2:
	ldr	x2, [sp, #8]
	ldr	x1, [sp, #16]
	ldr	x0, [sp]
	bl	_memcmp
	stur	w0, [x29, #-4]
	ldur	w8, [x29, #-4]
	subs	w8, w8, #0
	cset	w8, eq
	sturb	w8, [x29, #-5]
	b	LBB142_3
LBB142_3:
	ldurb	w8, [x29, #-5]
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
__ZN4core3str6traits66_$LT$impl$u20$core..ops..index..Index$LT$I$GT$$u20$for$u20$str$GT$5index17hea957e09c6f26f25E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp]
	str	x1, [sp, #8]
	mov	x0, x2
	ldr	x2, [sp]
	mov	x1, x3
	ldr	x3, [sp, #8]
	bl	__ZN4core3str6traits108_$LT$impl$u20$core..slice..index..SliceIndex$LT$str$GT$$u20$for$u20$core..ops..range..Range$LT$usize$GT$$GT$5index17ha961c6f0898344d7E
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3str6traits99_$LT$impl$u20$core..slice..index..SliceIndex$LT$str$GT$$u20$for$u20$core..ops..range..RangeFull$GT$5index17hc7148db3acd1c8bcE:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4char7methods15encode_utf8_raw17hc8a1d7bd480bea95E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	w0, [sp, #4]
	str	x1, [sp, #8]
	str	x2, [sp, #16]
	subs	w8, w0, #128
	b.lo	LBB145_2
	b	LBB145_1
LBB145_1:
	ldr	w8, [sp, #4]
	subs	w8, w8, #2048
	b.lo	LBB145_4
	b	LBB145_3
LBB145_2:
	mov	w8, #1
	stur	x8, [x29, #-8]
	b	LBB145_7
LBB145_3:
	ldr	w8, [sp, #4]
	subs	w8, w8, #16, lsl #12
	b.lo	LBB145_6
	b	LBB145_5
LBB145_4:
	mov	w8, #2
	stur	x8, [x29, #-8]
	b	LBB145_7
LBB145_5:
	mov	w8, #4
	stur	x8, [x29, #-8]
	b	LBB145_7
LBB145_6:
	mov	w8, #3
	stur	x8, [x29, #-8]
	b	LBB145_7
LBB145_7:
	ldr	x8, [sp, #16]
	ldur	x9, [x29, #-8]
	subs	x8, x8, x9
	b.lo	LBB145_9
	b	LBB145_8
LBB145_8:
	ldr	x1, [sp, #8]
	ldr	w0, [sp, #4]
	bl	__ZN4core4char7methods25encode_utf8_raw_unchecked17haed202e84a7a293fE
	b	LBB145_10
LBB145_9:
	ldr	x2, [sp, #16]
	ldr	w0, [sp, #4]
	ldur	x1, [x29, #-8]
	adrp	x3, l_anon.06e111bfef83652125d85ade023d82af.65@PAGE
	add	x3, x3, l_anon.06e111bfef83652125d85ade023d82af.65@PAGEOFF
	bl	__ZN4core4char7methods15encode_utf8_raw8do_panic7runtime17haba089cc0f6e9e89E
LBB145_10:
	ldr	x0, [sp, #8]
	ldur	x1, [x29, #-8]
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4char7methods15encode_utf8_raw8do_panic7runtime17haba089cc0f6e9e89E:
	.cfi_startproc
	sub	sp, sp, #192
	.cfi_def_cfa_offset 192
	stp	x29, x30, [sp, #176]
	add	x29, sp, #176
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	sub	x8, x29, #32
	mov	x12, x2
	mov	x2, x3
	add	x11, sp, #12
	str	w0, [sp, #12]
	add	x9, sp, #16
	str	x1, [sp, #16]
	add	x10, sp, #24
	str	x12, [sp, #24]
	stur	x9, [x29, #-48]
	adrp	x9, __RNvXsi_NtNtNtCs6sq8b9ugfBC_4core3fmt3num3impjNtB9_7Display3fmt@GOTPAGE
	ldr	x9, [x9, __RNvXsi_NtNtNtCs6sq8b9ugfBC_4core3fmt3num3impjNtB9_7Display3fmt@GOTPAGEOFF]
	mov	x12, x9
	stur	x12, [x29, #-40]
	ldur	q0, [x29, #-48]
	str	q0, [sp, #80]
	str	x11, [x8]
	adrp	x11, __RNvXsw_NtNtCs6sq8b9ugfBC_4core3fmt3nummNtB7_8UpperHex3fmt@GOTPAGE
	ldr	x11, [x11, __RNvXsw_NtNtCs6sq8b9ugfBC_4core3fmt3nummNtB7_8UpperHex3fmt@GOTPAGEOFF]
	str	x11, [x8, #8]
	ldr	q0, [x8]
	stur	q0, [x29, #-80]
	str	x10, [x8, #16]
	str	x9, [x8, #24]
	ldr	q0, [x8, #16]
	stur	q0, [x29, #-64]
	ldr	q0, [sp, #80]
	add	x1, sp, #32
	str	q0, [sp, #32]
	ldur	q0, [x29, #-80]
	str	q0, [sp, #48]
	ldur	q0, [x29, #-64]
	str	q0, [sp, #64]
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.66@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.66@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking9panic_fmt
	.cfi_endproc

	.p2align	2
__ZN4core4char7methods22_$LT$impl$u20$char$GT$8to_digit17h9959f642128c2244E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	w0, [sp, #12]
	str	w1, [sp, #16]
	subs	w8, w1, #2
	b.hs	LBB147_2
	b	LBB147_1
LBB147_1:
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.67@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.67@PAGEOFF
	mov	w8, #143
	mov	x1, x8
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.68@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.68@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking9panic_fmt
LBB147_2:
	ldr	w8, [sp, #16]
	subs	w8, w8, #36
	b.hi	LBB147_1
	b	LBB147_3
LBB147_3:
	ldr	w8, [sp, #12]
	subs	w8, w8, #57
	b.hi	LBB147_5
	b	LBB147_4
LBB147_4:
	ldr	w8, [sp, #12]
	subs	w8, w8, #48
	stur	w8, [x29, #-4]
	b	LBB147_7
LBB147_5:
	ldr	w8, [sp, #16]
	subs	w8, w8, #10
	b.ls	LBB147_4
	b	LBB147_6
LBB147_6:
	ldr	w8, [sp, #12]
	subs	w8, w8, #65
	and	w8, w8, #0xffffffdf
	add	w8, w8, #10
	stur	w8, [x29, #-4]
	b	LBB147_7
LBB147_7:
	ldr	w9, [sp, #16]
	ldur	w8, [x29, #-4]
	subs	w8, w8, w9
	b.lo	LBB147_9
	b	LBB147_8
LBB147_8:
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.69@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.69@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.69@PAGEOFF
	ldr	w9, [x9, l_anon.06e111bfef83652125d85ade023d82af.69@PAGEOFF]
	ldr	w8, [x8, #4]
	stur	w9, [x29, #-12]
	stur	w8, [x29, #-8]
	b	LBB147_10
LBB147_9:
	ldur	w8, [x29, #-4]
	stur	w8, [x29, #-8]
	mov	w8, #1
	stur	w8, [x29, #-12]
	b	LBB147_10
LBB147_10:
	ldur	w0, [x29, #-12]
	ldur	w1, [x29, #-8]
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4char7methods25encode_utf8_raw_unchecked17haed202e84a7a293fE:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	str	w0, [sp, #28]
	str	x1, [sp, #32]
	subs	w8, w0, #128
	b.lo	LBB148_2
	b	LBB148_1
LBB148_1:
	ldr	w8, [sp, #28]
	subs	w8, w8, #2048
	b.lo	LBB148_4
	b	LBB148_3
LBB148_2:
	ldr	w8, [sp, #28]
	ldr	x9, [sp, #32]
	mov	w10, #1
	str	x10, [sp, #40]
	strb	w8, [x9]
	b	LBB148_10
LBB148_3:
	ldr	w8, [sp, #28]
	subs	w8, w8, #16, lsl #12
	b.lo	LBB148_6
	b	LBB148_5
LBB148_4:
	mov	w8, #2
	str	x8, [sp, #40]
	b	LBB148_7
LBB148_5:
	mov	w8, #4
	str	x8, [sp, #40]
	b	LBB148_7
LBB148_6:
	mov	w8, #3
	str	x8, [sp, #40]
	b	LBB148_7
LBB148_7:
	ldr	w8, [sp, #28]
	and	w9, w8, #0x3f
	mov	w10, #-128
	orr	w9, w9, #0xffffff80
	str	w9, [sp, #12]
	lsr	w9, w8, #6
	and	w9, w9, #0x3f
	orr	w9, w9, w10
	str	w9, [sp, #16]
	lsr	w9, w8, #12
	and	w9, w9, #0x3f
	orr	w9, w9, w10
	str	w9, [sp, #20]
	lsr	w8, w8, #18
	and	w8, w8, #0x3f
	orr	w8, w8, #0xfffffff0
	str	w8, [sp, #24]
	ldr	x8, [sp, #40]
	subs	x8, x8, #2
	b.ne	LBB148_9
	b	LBB148_8
LBB148_8:
	ldr	w8, [sp, #12]
	ldr	x9, [sp, #32]
	ldr	w10, [sp, #16]
	orr	w10, w10, #0xffffffc0
	strb	w10, [x9]
	strb	w8, [x9, #1]
	b	LBB148_10
LBB148_9:
	ldr	x8, [sp, #40]
	subs	x8, x8, #3
	b.eq	LBB148_11
	b	LBB148_12
LBB148_10:
	b	LBB148_13
LBB148_11:
	ldr	w8, [sp, #12]
	ldr	x9, [sp, #32]
	ldr	w10, [sp, #16]
	ldr	w11, [sp, #20]
	orr	w11, w11, #0xffffffe0
	strb	w11, [x9]
	strb	w10, [x9, #1]
	strb	w8, [x9, #2]
	b	LBB148_10
LBB148_12:
	ldr	w8, [sp, #12]
	ldr	x9, [sp, #32]
	ldr	w10, [sp, #16]
	ldr	w11, [sp, #20]
	ldr	w12, [sp, #24]
	strb	w12, [x9]
	strb	w11, [x9, #1]
	strb	w10, [x9, #2]
	strb	w8, [x9, #3]
	b	LBB148_13
LBB148_13:
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4hint21unreachable_unchecked18precondition_check17h868ec29e1862bf2aE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x3, x0
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.70@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.70@PAGEOFF
	mov	w8, #399
	mov	x1, x8
	mov	w8, #0
	and	w2, w8, #0x1
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_nounwind_fmt
	.cfi_endproc

	.p2align	2
__ZN4core4iter6traits8iterator8Iterator3map17h827a6eb9faef4655E:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4iter6traits8iterator8Iterator3map17hf042701bf172d191E:
	.cfi_startproc
	ldr	q0, [x0]
	str	q0, [x8]
	ldr	q0, [x0, #16]
	str	q0, [x8, #16]
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4iter6traits8iterator8Iterator4fold17h0b479b74f9348112E:
Lfunc_begin38:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception38
	sub	sp, sp, #144
	.cfi_def_cfa_offset 144
	stp	x29, x30, [sp, #128]
	add	x29, sp, #128
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	str	x1, [sp, #16]
	mov	w8, #1
	sturb	w8, [x29, #-17]
	b	LBB152_1
LBB152_1:
Ltmp535:
	ldr	x0, [sp, #8]
	add	x8, sp, #28
	bl	__ZN99_$LT$core..iter..sources..once..Once$LT$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h3280b2ce72e2e66dE
Ltmp536:
	b	LBB152_4
LBB152_2:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB152_10
	b	LBB152_9
LBB152_3:
Ltmp539:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB152_2
LBB152_4:
	ldrb	w8, [sp, #44]
	subs	w8, w8, #7
	cset	x8, ne
	tbz	w8, #0, LBB152_6
	b	LBB152_5
LBB152_5:
	ldur	q0, [sp, #28]
	str	q0, [sp, #48]
	ldr	w8, [sp, #44]
	str	w8, [sp, #64]
	sturb	wzr, [x29, #-17]
	ldr	q0, [sp, #48]
	sub	x1, x29, #48
	stur	q0, [x29, #-48]
	ldr	w8, [sp, #64]
	stur	w8, [x29, #-32]
Ltmp537:
	add	x0, sp, #16
	bl	__ZN4core3ops8function5impls79_$LT$impl$u20$core..ops..function..FnMut$LT$A$GT$$u20$for$u20$$RF$mut$u20$F$GT$8call_mut17hcc7cd73f3e612967E
Ltmp538:
	b	LBB152_7
LBB152_6:
	b	LBB152_8
LBB152_7:
	mov	w8, #1
	sturb	w8, [x29, #-17]
	b	LBB152_1
LBB152_8:
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr81drop_in_place$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$17hfb9b61ff9a9e03c9E
	.cfi_def_cfa wsp, 144
	ldp	x29, x30, [sp, #128]
	add	sp, sp, #144
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB152_9:
	.cfi_restore_state
	b	LBB152_11
LBB152_10:
	b	LBB152_9
LBB152_11:
Ltmp540:
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr81drop_in_place$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$17hfb9b61ff9a9e03c9E
Ltmp541:
	b	LBB152_13
LBB152_12:
Ltmp542:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB152_13:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
Lfunc_end38:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table152:
Lexception38:
	.byte	255
	.byte	155
	.uleb128 Lttbase28-Lttbaseref28
Lttbaseref28:
	.byte	1
	.uleb128 Lcst_end38-Lcst_begin38
Lcst_begin38:
	.uleb128 Ltmp535-Lfunc_begin38
	.uleb128 Ltmp538-Ltmp535
	.uleb128 Ltmp539-Lfunc_begin38
	.byte	0
	.uleb128 Ltmp538-Lfunc_begin38
	.uleb128 Ltmp540-Ltmp538
	.byte	0
	.byte	0
	.uleb128 Ltmp540-Lfunc_begin38
	.uleb128 Ltmp541-Ltmp540
	.uleb128 Ltmp542-Lfunc_begin38
	.byte	1
	.uleb128 Ltmp541-Lfunc_begin38
	.uleb128 Lfunc_end38-Ltmp541
	.byte	0
	.byte	0
Lcst_end38:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase28:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core4iter6traits8iterator8Iterator4fold17h46e25aaf07c21ac0E:
Lfunc_begin39:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception39
	sub	sp, sp, #144
	.cfi_def_cfa_offset 144
	stp	x29, x30, [sp, #128]
	add	x29, sp, #128
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	str	x1, [sp, #16]
	mov	w8, #1
	sturb	w8, [x29, #-17]
	b	LBB153_1
LBB153_1:
Ltmp543:
	ldr	x0, [sp, #8]
	add	x8, sp, #28
	bl	__ZN99_$LT$core..iter..sources..once..Once$LT$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h3280b2ce72e2e66dE
Ltmp544:
	b	LBB153_4
LBB153_2:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB153_10
	b	LBB153_9
LBB153_3:
Ltmp547:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB153_2
LBB153_4:
	ldrb	w8, [sp, #44]
	subs	w8, w8, #7
	cset	x8, ne
	tbz	w8, #0, LBB153_6
	b	LBB153_5
LBB153_5:
	ldur	q0, [sp, #28]
	str	q0, [sp, #48]
	ldr	w8, [sp, #44]
	str	w8, [sp, #64]
	sturb	wzr, [x29, #-17]
	ldr	q0, [sp, #48]
	sub	x1, x29, #48
	stur	q0, [x29, #-48]
	ldr	w8, [sp, #64]
	stur	w8, [x29, #-32]
Ltmp545:
	add	x0, sp, #16
	bl	__ZN4core3ops8function5impls79_$LT$impl$u20$core..ops..function..FnMut$LT$A$GT$$u20$for$u20$$RF$mut$u20$F$GT$8call_mut17h3c020253d6e4a8edE
Ltmp546:
	b	LBB153_7
LBB153_6:
	b	LBB153_8
LBB153_7:
	mov	w8, #1
	sturb	w8, [x29, #-17]
	b	LBB153_1
LBB153_8:
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr81drop_in_place$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$17hfb9b61ff9a9e03c9E
	.cfi_def_cfa wsp, 144
	ldp	x29, x30, [sp, #128]
	add	sp, sp, #144
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB153_9:
	.cfi_restore_state
	b	LBB153_11
LBB153_10:
	b	LBB153_9
LBB153_11:
Ltmp548:
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr81drop_in_place$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$17hfb9b61ff9a9e03c9E
Ltmp549:
	b	LBB153_13
LBB153_12:
Ltmp550:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB153_13:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
Lfunc_end39:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table153:
Lexception39:
	.byte	255
	.byte	155
	.uleb128 Lttbase29-Lttbaseref29
Lttbaseref29:
	.byte	1
	.uleb128 Lcst_end39-Lcst_begin39
Lcst_begin39:
	.uleb128 Ltmp543-Lfunc_begin39
	.uleb128 Ltmp546-Ltmp543
	.uleb128 Ltmp547-Lfunc_begin39
	.byte	0
	.uleb128 Ltmp546-Lfunc_begin39
	.uleb128 Ltmp548-Ltmp546
	.byte	0
	.byte	0
	.uleb128 Ltmp548-Lfunc_begin39
	.uleb128 Ltmp549-Ltmp548
	.uleb128 Ltmp550-Lfunc_begin39
	.byte	1
	.uleb128 Ltmp549-Lfunc_begin39
	.uleb128 Lfunc_end39-Ltmp549
	.byte	0
	.byte	0
Lcst_end39:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase29:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core4iter6traits8iterator8Iterator5chain17he59ecf2e9d29238cE:
Lfunc_begin40:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception40
	sub	sp, sp, #160
	.cfi_def_cfa_offset 160
	stp	x29, x30, [sp, #144]
	add	x29, sp, #144
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x8, [sp, #8]
	mov	x8, x0
	mov	x0, x1
	ldr	q0, [x8]
	str	q0, [sp, #16]
	ldr	w8, [x8, #16]
	str	w8, [sp, #32]
Ltmp551:
	add	x8, sp, #44
	bl	__ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h2a560d0dbc42822dE
Ltmp552:
	b	LBB154_3
LBB154_1:
Ltmp554:
	add	x0, sp, #16
	bl	__ZN4core3ptr81drop_in_place$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$17hfb9b61ff9a9e03c9E
Ltmp555:
	b	LBB154_5
LBB154_2:
Ltmp553:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB154_1
LBB154_3:
	ldr	x9, [sp, #8]
	ldr	q0, [sp, #16]
	str	q0, [sp, #64]
	ldr	w8, [sp, #32]
	str	w8, [sp, #80]
	ldur	q0, [sp, #44]
	stur	q0, [x29, #-48]
	ldr	w8, [sp, #60]
	stur	w8, [x29, #-32]
	ldr	q0, [sp, #64]
	str	q0, [x9]
	ldr	w8, [sp, #80]
	str	w8, [x9, #16]
	ldur	q0, [x29, #-48]
	stur	q0, [x9, #20]
	ldur	w8, [x29, #-32]
	str	w8, [x9, #36]
	.cfi_def_cfa wsp, 160
	ldp	x29, x30, [sp, #144]
	add	sp, sp, #160
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB154_4:
	.cfi_restore_state
Ltmp556:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB154_5:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
Lfunc_end40:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table154:
Lexception40:
	.byte	255
	.byte	155
	.uleb128 Lttbase30-Lttbaseref30
Lttbaseref30:
	.byte	1
	.uleb128 Lcst_end40-Lcst_begin40
Lcst_begin40:
	.uleb128 Ltmp551-Lfunc_begin40
	.uleb128 Ltmp552-Ltmp551
	.uleb128 Ltmp553-Lfunc_begin40
	.byte	0
	.uleb128 Ltmp554-Lfunc_begin40
	.uleb128 Ltmp555-Ltmp554
	.uleb128 Ltmp556-Lfunc_begin40
	.byte	1
	.uleb128 Ltmp555-Lfunc_begin40
	.uleb128 Lfunc_end40-Ltmp555
	.byte	0
	.byte	0
Lcst_end40:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase30:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core4iter6traits8iterator8Iterator6cloned17hc8e2f1f2c81e11d7E:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4iter6traits8iterator8Iterator7collect17h178ff8388afd9ce4E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN114_$LT$proc_macro..TokenStream$u20$as$u20$core..iter..traits..collect..FromIterator$LT$proc_macro..TokenTree$GT$$GT$9from_iter17h03cfed66d760bf14E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4iter6traits8iterator8Iterator7collect17h775ad43be0eafc62E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN116_$LT$proc_macro..TokenStream$u20$as$u20$core..iter..traits..collect..FromIterator$LT$proc_macro..TokenStream$GT$$GT$9from_iter17h1c06a2033e1d662dE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4iter6traits8iterator8Iterator8flat_map17h3bd303bbb043848dE:
	.cfi_startproc
	sub	sp, sp, #320
	.cfi_def_cfa_offset 320
	stp	x28, x27, [sp, #288]
	stp	x29, x30, [sp, #304]
	add	x29, sp, #304
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w27, -24
	.cfi_offset w28, -32
	str	x8, [sp, #16]
	add	x8, sp, #144
	bl	__ZN4core4iter6traits8iterator8Iterator3map17hf042701bf172d191E
	ldr	q0, [sp, #144]
	stur	q0, [x29, #-48]
	ldr	q0, [sp, #160]
	stur	q0, [x29, #-32]
	ldur	q0, [x29, #-48]
	stur	q0, [x29, #-128]
	ldur	q0, [x29, #-32]
	stur	q0, [x29, #-112]
	sub	x1, x29, #88
	str	x1, [sp]
	mov	w8, #9
	sturb	w8, [x29, #-52]
	ldur	q0, [x29, #-128]
	add	x8, sp, #32
	str	x8, [sp, #24]
	str	q0, [sp, #32]
	ldur	q0, [x29, #-112]
	str	q0, [sp, #48]
	add	x0, x8, #32
	mov	w8, #40
	mov	x2, x8
	str	x2, [sp, #8]
	bl	_memcpy
	ldr	x1, [sp]
	ldr	x2, [sp, #8]
	ldr	x8, [sp, #24]
	add	x0, x8, #72
	bl	_memcpy
	ldr	x0, [sp, #16]
	ldr	x1, [sp, #24]
	mov	w8, #112
	mov	x2, x8
	bl	_memcpy
	.cfi_def_cfa wsp, 320
	ldp	x29, x30, [sp, #304]
	ldp	x28, x27, [sp, #288]
	add	sp, sp, #320
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w27
	.cfi_restore w28
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4iter6traits8iterator8Iterator8for_each17h7662e2bc614d6b17E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN104_$LT$core..iter..adapters..cloned..Cloned$LT$I$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4fold17h3d668a37bd2853a1E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4iter6traits8iterator8Iterator8for_each17haff20418b154010cE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN114_$LT$core..iter..adapters..flatten..FlatMap$LT$I$C$U$C$F$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4fold17h4f4ac4b2af5edf01E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4iter6traits8iterator8Iterator8for_each4call28_$u7b$$u7b$closure$u7d$$u7d$17h1954e792d57e7178E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x1
	ldr	q0, [x8]
	mov	x1, sp
	str	q0, [sp]
	ldr	w8, [x8, #16]
	str	w8, [sp, #16]
	bl	__ZN114_$LT$proc_macro..TokenStream$u20$as$u20$core..iter..traits..collect..FromIterator$LT$proc_macro..TokenTree$GT$$GT$9from_iter28_$u7b$$u7b$closure$u7d$$u7d$17ha49a1b5fd2ccfc0cE
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4iter6traits8iterator8Iterator8for_each4call28_$u7b$$u7b$closure$u7d$$u7d$17hceb4de5a59581ca7E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN116_$LT$proc_macro..TokenStream$u20$as$u20$core..iter..traits..collect..FromIterator$LT$proc_macro..TokenStream$GT$$GT$9from_iter28_$u7b$$u7b$closure$u7d$$u7d$17h627a2b6ae081ff0dE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4iter7sources4once4once17hde8b07058073a421E:
	.cfi_startproc
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	mov	x9, x8
	ldr	q0, [x0]
	str	q0, [sp, #32]
	ldr	w8, [x0, #16]
	str	w8, [sp, #48]
	ldr	q0, [sp, #32]
	str	q0, [sp, #64]
	ldr	w8, [sp, #48]
	str	w8, [sp, #80]
	ldr	q0, [sp, #64]
	str	q0, [sp]
	ldr	w8, [sp, #80]
	str	w8, [sp, #16]
	ldr	q0, [sp]
	str	q0, [x9]
	ldr	w8, [sp, #16]
	str	w8, [x9, #16]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4iter8adapters3map8map_fold28_$u7b$$u7b$closure$u7d$$u7d$17h0ad59799988b88cfE:
Lfunc_begin41:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception41
	sub	sp, sp, #144
	.cfi_def_cfa_offset 144
	stp	x29, x30, [sp, #128]
	add	x29, sp, #128
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #16]
	mov	w8, #1
	sturb	w8, [x29, #-17]
Ltmp558:
	sub	x8, x29, #60
	add	x0, x0, #8
	bl	__ZN18const_random_macro12const_random28_$u7b$$u7b$closure$u7d$$u7d$17hb5c96b6069c3090dE
Ltmp559:
	b	LBB164_3
LBB164_1:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB164_6
	b	LBB164_5
LBB164_2:
Ltmp562:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB164_1
LBB164_3:
	sturb	wzr, [x29, #-17]
	add	x0, sp, #28
	str	x0, [sp, #8]
	sub	x1, x29, #60
	mov	w8, #40
	mov	x2, x8
	bl	_memcpy
	ldr	x0, [sp, #16]
	ldr	x1, [sp, #8]
Ltmp560:
	bl	__ZN4core4iter8adapters7flatten26FlattenCompat$LT$I$C$U$GT$9iter_fold7flatten28_$u7b$$u7b$closure$u7d$$u7d$17h8d5d6d9913fea62fE
Ltmp561:
	b	LBB164_4
LBB164_4:
	.cfi_def_cfa wsp, 144
	ldp	x29, x30, [sp, #128]
	add	sp, sp, #144
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB164_5:
	.cfi_restore_state
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB164_6:
	b	LBB164_5
Lfunc_end41:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table164:
Lexception41:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end41-Lcst_begin41
Lcst_begin41:
	.uleb128 Ltmp558-Lfunc_begin41
	.uleb128 Ltmp559-Ltmp558
	.uleb128 Ltmp562-Lfunc_begin41
	.byte	0
	.uleb128 Ltmp559-Lfunc_begin41
	.uleb128 Ltmp560-Ltmp559
	.byte	0
	.byte	0
	.uleb128 Ltmp560-Lfunc_begin41
	.uleb128 Ltmp561-Ltmp560
	.uleb128 Ltmp562-Lfunc_begin41
	.byte	0
	.uleb128 Ltmp561-Lfunc_begin41
	.uleb128 Lfunc_end41-Ltmp561
	.byte	0
	.byte	0
Lcst_end41:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core4iter8adapters3map8map_fold28_$u7b$$u7b$closure$u7d$$u7d$17h89d49231f3496dd3E:
Lfunc_begin42:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception42
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp]
	mov	w8, #1
	strb	w8, [sp, #15]
Ltmp563:
	add	x0, x0, #8
	bl	__ZN4core3ops8function5FnMut8call_mut17h3fe903e800f22662E
	str	w0, [sp, #8]
Ltmp564:
	b	LBB165_3
LBB165_1:
	ldrb	w8, [sp, #15]
	tbnz	w8, #0, LBB165_6
	b	LBB165_5
LBB165_2:
Ltmp567:
	str	x0, [sp, #16]
	mov	x8, x1
	str	w8, [sp, #24]
	b	LBB165_1
LBB165_3:
	ldr	w1, [sp, #8]
	ldr	x0, [sp]
	strb	wzr, [sp, #15]
Ltmp565:
	bl	__ZN4core4iter6traits8iterator8Iterator8for_each4call28_$u7b$$u7b$closure$u7d$$u7d$17hceb4de5a59581ca7E
Ltmp566:
	b	LBB165_4
LBB165_4:
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB165_5:
	.cfi_restore_state
	ldr	x0, [sp, #16]
	bl	__Unwind_Resume
LBB165_6:
	b	LBB165_5
Lfunc_end42:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table165:
Lexception42:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end42-Lcst_begin42
Lcst_begin42:
	.uleb128 Ltmp563-Lfunc_begin42
	.uleb128 Ltmp566-Ltmp563
	.uleb128 Ltmp567-Lfunc_begin42
	.byte	0
	.uleb128 Ltmp566-Lfunc_begin42
	.uleb128 Lfunc_end42-Ltmp566
	.byte	0
	.byte	0
Lcst_end42:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core4iter8adapters7flatten26FlattenCompat$LT$I$C$U$GT$9iter_fold17hebf532c40ef9598dE:
Lfunc_begin43:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception43
	sub	sp, sp, #368
	.cfi_def_cfa_offset 368
	stp	x28, x27, [sp, #336]
	stp	x29, x30, [sp, #352]
	add	x29, sp, #352
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w27, -24
	.cfi_offset w28, -32
	.cfi_remember_state
	sub	x8, x29, #64
	str	x8, [sp, #56]
	str	x0, [sp, #64]
	str	x1, [sp, #72]
	mov	w8, #1
	sturb	w8, [x29, #-66]
	sturb	w8, [x29, #-65]
	ldrb	w8, [x0, #68]
	subs	w8, w8, #9
	cset	x8, ne
	tbz	w8, #0, LBB166_2
	b	LBB166_1
LBB166_1:
	ldr	x8, [sp, #64]
	add	x1, x8, #32
	add	x0, sp, #80
	str	x0, [sp, #32]
	mov	w8, #40
	mov	x2, x8
	str	x2, [sp, #40]
	bl	_memcpy
	ldr	x1, [sp, #32]
	ldr	x2, [sp, #40]
	add	x0, sp, #120
	str	x0, [sp, #48]
	bl	_memcpy
	ldr	x1, [sp, #48]
Ltmp568:
	add	x0, sp, #72
	bl	__ZN116_$LT$core..iter..adapters..flatten..FlattenCompat$LT$I$C$U$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4fold7flatten28_$u7b$$u7b$closure$u7d$$u7d$17h94235c34ca7e623fE
Ltmp569:
	b	LBB166_5
LBB166_2:
	ldr	x8, [sp, #64]
	sturb	wzr, [x29, #-65]
	ldr	q0, [x8]
	str	q0, [sp, #160]
	ldr	q0, [x8, #16]
	str	q0, [sp, #176]
	ldr	x8, [sp, #160]
	subs	x8, x8, #0
	cset	x8, ne
	tbnz	w8, #0, LBB166_6
	b	LBB166_7
LBB166_3:
	b	LBB166_13
LBB166_4:
Ltmp574:
	stur	x0, [x29, #-32]
	mov	x8, x1
	stur	w8, [x29, #-24]
	b	LBB166_3
LBB166_5:
	b	LBB166_2
LBB166_6:
	ldr	x8, [sp, #56]
	ldr	q0, [sp, #160]
	sub	x0, x29, #64
	str	q0, [x8]
	ldr	q0, [sp, #176]
	str	q0, [x8, #16]
Ltmp570:
	add	x1, sp, #72
	bl	__ZN102_$LT$core..iter..adapters..map..Map$LT$I$C$F$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4fold17hd847641e9f0f225bE
Ltmp571:
	b	LBB166_8
LBB166_7:
	b	LBB166_9
LBB166_8:
	b	LBB166_9
LBB166_9:
	ldr	x8, [sp, #64]
	ldrb	w8, [x8, #108]
	subs	w8, w8, #9
	cset	x8, ne
	tbz	w8, #0, LBB166_11
	b	LBB166_10
LBB166_10:
	ldr	x8, [sp, #64]
	sturb	wzr, [x29, #-66]
	add	x1, x8, #72
	sub	x0, x29, #148
	str	x0, [sp, #8]
	mov	w8, #40
	mov	x2, x8
	str	x2, [sp, #16]
	bl	_memcpy
	ldr	x1, [sp, #8]
	ldr	x2, [sp, #16]
	sub	x0, x29, #108
	str	x0, [sp, #24]
	bl	_memcpy
	ldr	x1, [sp, #24]
Ltmp572:
	add	x0, sp, #72
	bl	__ZN116_$LT$core..iter..adapters..flatten..FlattenCompat$LT$I$C$U$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4fold7flatten28_$u7b$$u7b$closure$u7d$$u7d$17h94235c34ca7e623fE
Ltmp573:
	b	LBB166_12
LBB166_11:
	b	LBB166_14
LBB166_12:
	b	LBB166_11
LBB166_13:
	ldurb	w8, [x29, #-65]
	tbnz	w8, #0, LBB166_16
	b	LBB166_15
LBB166_14:
	.cfi_def_cfa wsp, 368
	ldp	x29, x30, [sp, #352]
	ldp	x28, x27, [sp, #336]
	add	sp, sp, #368
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w27
	.cfi_restore w28
	ret
LBB166_15:
	.cfi_restore_state
	ldr	x8, [sp, #64]
	ldrb	w8, [x8, #108]
	subs	w8, w8, #9
	cset	x8, ne
	subs	x8, x8, #1
	b.eq	LBB166_18
	b	LBB166_19
LBB166_16:
Ltmp575:
	ldr	x0, [sp, #64]
	bl	__ZN4core3ptr204drop_in_place$LT$core..iter..adapters..fuse..Fuse$LT$core..iter..adapters..map..Map$LT$alloc..vec..into_iter..IntoIter$LT$u8$GT$$C$const_random_macro..const_random..$u7b$$u7b$closure$u7d$$u7d$$GT$$GT$$GT$17hac644255e63f835dE
Ltmp576:
	b	LBB166_15
LBB166_17:
Ltmp579:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB166_18:
	ldurb	w8, [x29, #-66]
	tbnz	w8, #0, LBB166_20
	b	LBB166_19
LBB166_19:
	ldur	x0, [x29, #-32]
	bl	__Unwind_Resume
LBB166_20:
	ldr	x8, [sp, #64]
	add	x0, x8, #72
Ltmp577:
	bl	__ZN4core3ptr186drop_in_place$LT$core..iter..adapters..chain..Chain$LT$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$C$core..iter..sources..once..Once$LT$proc_macro..TokenTree$GT$$GT$$GT$17h65b6123a2200c75dE
Ltmp578:
	b	LBB166_19
Lfunc_end43:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table166:
Lexception43:
	.byte	255
	.byte	155
	.uleb128 Lttbase31-Lttbaseref31
Lttbaseref31:
	.byte	1
	.uleb128 Lcst_end43-Lcst_begin43
Lcst_begin43:
	.uleb128 Lfunc_begin43-Lfunc_begin43
	.uleb128 Ltmp568-Lfunc_begin43
	.byte	0
	.byte	0
	.uleb128 Ltmp568-Lfunc_begin43
	.uleb128 Ltmp571-Ltmp568
	.uleb128 Ltmp574-Lfunc_begin43
	.byte	0
	.uleb128 Ltmp571-Lfunc_begin43
	.uleb128 Ltmp572-Ltmp571
	.byte	0
	.byte	0
	.uleb128 Ltmp572-Lfunc_begin43
	.uleb128 Ltmp573-Ltmp572
	.uleb128 Ltmp574-Lfunc_begin43
	.byte	0
	.uleb128 Ltmp575-Lfunc_begin43
	.uleb128 Ltmp576-Ltmp575
	.uleb128 Ltmp579-Lfunc_begin43
	.byte	1
	.uleb128 Ltmp576-Lfunc_begin43
	.uleb128 Ltmp577-Ltmp576
	.byte	0
	.byte	0
	.uleb128 Ltmp577-Lfunc_begin43
	.uleb128 Ltmp578-Ltmp577
	.uleb128 Ltmp579-Lfunc_begin43
	.byte	1
Lcst_end43:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase31:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core4iter8adapters7flatten26FlattenCompat$LT$I$C$U$GT$9iter_fold7flatten28_$u7b$$u7b$closure$u7d$$u7d$17h8d5d6d9913fea62fE:
Lfunc_begin44:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception44
	sub	sp, sp, #144
	.cfi_def_cfa_offset 144
	stp	x29, x30, [sp, #128]
	add	x29, sp, #128
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	mov	x8, x0
	mov	x0, x1
	ldr	x8, [x8]
	str	x8, [sp, #16]
	mov	w8, #1
	sturb	w8, [x29, #-17]
Ltmp580:
	sub	x8, x29, #60
	bl	__ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h26990086c6e6d992E
Ltmp581:
	b	LBB167_3
LBB167_1:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB167_6
	b	LBB167_5
LBB167_2:
Ltmp584:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB167_1
LBB167_3:
	sturb	wzr, [x29, #-17]
	add	x0, sp, #28
	str	x0, [sp, #8]
	sub	x1, x29, #60
	mov	w8, #40
	mov	x2, x8
	bl	_memcpy
	ldr	x0, [sp, #16]
	ldr	x1, [sp, #8]
Ltmp582:
	bl	__ZN116_$LT$core..iter..adapters..flatten..FlattenCompat$LT$I$C$U$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4fold7flatten28_$u7b$$u7b$closure$u7d$$u7d$17h94235c34ca7e623fE
Ltmp583:
	b	LBB167_4
LBB167_4:
	.cfi_def_cfa wsp, 144
	ldp	x29, x30, [sp, #128]
	add	sp, sp, #144
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB167_5:
	.cfi_restore_state
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB167_6:
	b	LBB167_5
Lfunc_end44:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table167:
Lexception44:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end44-Lcst_begin44
Lcst_begin44:
	.uleb128 Ltmp580-Lfunc_begin44
	.uleb128 Ltmp581-Ltmp580
	.uleb128 Ltmp584-Lfunc_begin44
	.byte	0
	.uleb128 Ltmp581-Lfunc_begin44
	.uleb128 Ltmp582-Ltmp581
	.byte	0
	.byte	0
	.uleb128 Ltmp582-Lfunc_begin44
	.uleb128 Ltmp583-Ltmp582
	.uleb128 Ltmp584-Lfunc_begin44
	.byte	0
	.uleb128 Ltmp583-Lfunc_begin44
	.uleb128 Lfunc_end44-Ltmp583
	.byte	0
	.byte	0
Lcst_end44:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core4sync6atomic11atomic_load17h120f679d9743a856E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	mov	x8, x1
	and	x8, x8, #0xff
	str	x8, [sp, #16]
	cbz	x8, LBB168_6
	b	LBB168_1
LBB168_1:
	ldr	x8, [sp, #16]
	subs	x8, x8, #1
	b.eq	LBB168_7
	b	LBB168_2
LBB168_2:
	ldr	x8, [sp, #16]
	subs	x8, x8, #2
	b.eq	LBB168_8
	b	LBB168_3
LBB168_3:
	ldr	x8, [sp, #16]
	subs	x8, x8, #3
	b.eq	LBB168_9
	b	LBB168_4
LBB168_4:
	b	LBB168_10
LBB168_6:
	.cfi_restore_state
	ldr	x8, [sp, #8]
	ldr	x8, [x8]
	stur	x8, [x29, #-8]
	b	LBB168_11
LBB168_7:
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.71@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.71@PAGEOFF
	mov	w8, #81
	mov	x1, x8
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.73@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.73@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking9panic_fmt
LBB168_8:
	ldr	x8, [sp, #8]
	ldapr	x8, [x8]
	stur	x8, [x29, #-8]
	b	LBB168_11
LBB168_9:
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.74@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.74@PAGEOFF
	mov	w8, #99
	mov	x1, x8
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.75@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.75@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking9panic_fmt
LBB168_10:
	ldr	x8, [sp, #8]
	ldar	x8, [x8]
	stur	x8, [x29, #-8]
	b	LBB168_11
LBB168_11:
	ldur	x0, [x29, #-8]
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4sync6atomic23atomic_compare_exchange17h6f1b4d6613253870E:
	.cfi_startproc
	sub	sp, sp, #144
	.cfi_def_cfa_offset 144
	stp	x29, x30, [sp, #128]
	add	x29, sp, #128
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #56]
	str	x1, [sp, #64]
	stur	x2, [x29, #-56]
	stur	w4, [x29, #-44]
	mov	x8, x3
	and	x8, x8, #0xff
	stur	x8, [x29, #-40]
	cbz	x8, LBB169_6
	b	LBB169_1
LBB169_1:
	ldur	x8, [x29, #-40]
	subs	x8, x8, #1
	b.eq	LBB169_9
	b	LBB169_2
LBB169_2:
	ldur	x8, [x29, #-40]
	subs	x8, x8, #2
	b.eq	LBB169_12
	b	LBB169_3
LBB169_3:
	ldur	x8, [x29, #-40]
	subs	x8, x8, #3
	b.eq	LBB169_15
	b	LBB169_4
LBB169_4:
	b	LBB169_18
LBB169_6:
	.cfi_restore_state
	.cfi_remember_state
	ldur	w9, [x29, #-44]
	mov	x8, x9
	and	x8, x8, #0xff
	str	x8, [sp, #48]
	cbz	x8, LBB169_22
	b	LBB169_7
LBB169_7:
	ldr	x8, [sp, #48]
	subs	x8, x8, #2
	b.eq	LBB169_23
	b	LBB169_8
LBB169_8:
	ldr	x8, [sp, #48]
	subs	x8, x8, #4
	b.eq	LBB169_24
	b	LBB169_21
LBB169_9:
	ldur	w9, [x29, #-44]
	mov	x8, x9
	and	x8, x8, #0xff
	str	x8, [sp, #40]
	cbz	x8, LBB169_26
	b	LBB169_10
LBB169_10:
	ldr	x8, [sp, #40]
	subs	x8, x8, #2
	b.eq	LBB169_27
	b	LBB169_11
LBB169_11:
	ldr	x8, [sp, #40]
	subs	x8, x8, #4
	b.eq	LBB169_28
	b	LBB169_21
LBB169_12:
	ldur	w9, [x29, #-44]
	mov	x8, x9
	and	x8, x8, #0xff
	str	x8, [sp, #32]
	cbz	x8, LBB169_29
	b	LBB169_13
LBB169_13:
	ldr	x8, [sp, #32]
	subs	x8, x8, #2
	b.eq	LBB169_30
	b	LBB169_14
LBB169_14:
	ldr	x8, [sp, #32]
	subs	x8, x8, #4
	b.eq	LBB169_31
	b	LBB169_21
LBB169_15:
	ldur	w9, [x29, #-44]
	mov	x8, x9
	and	x8, x8, #0xff
	str	x8, [sp, #24]
	cbz	x8, LBB169_32
	b	LBB169_16
LBB169_16:
	ldr	x8, [sp, #24]
	subs	x8, x8, #2
	b.eq	LBB169_33
	b	LBB169_17
LBB169_17:
	ldr	x8, [sp, #24]
	subs	x8, x8, #4
	b.eq	LBB169_34
	b	LBB169_21
LBB169_18:
	ldur	w9, [x29, #-44]
	mov	x8, x9
	and	x8, x8, #0xff
	str	x8, [sp, #16]
	cbz	x8, LBB169_35
	b	LBB169_19
LBB169_19:
	ldr	x8, [sp, #16]
	subs	x8, x8, #2
	b.eq	LBB169_36
	b	LBB169_20
LBB169_20:
	ldr	x8, [sp, #16]
	subs	x8, x8, #4
	b.eq	LBB169_37
	b	LBB169_21
LBB169_21:
	ldur	w9, [x29, #-44]
	mov	x8, x9
	and	x8, x8, #0xff
	subs	x8, x8, #1
	b.eq	LBB169_41
	b	LBB169_42
LBB169_22:
	ldr	x8, [sp, #64]
	ldur	x10, [x29, #-56]
	ldr	x11, [sp, #56]
	mov	x9, x8
	cas	x9, x10, [x11]
	subs	x8, x9, x8
	cset	w8, eq
	stur	x9, [x29, #-16]
	sturb	w8, [x29, #-8]
	b	LBB169_25
LBB169_23:
	ldr	x8, [sp, #64]
	ldur	x10, [x29, #-56]
	ldr	x11, [sp, #56]
	mov	x9, x8
	casa	x9, x10, [x11]
	subs	x8, x9, x8
	cset	w8, eq
	stur	x9, [x29, #-16]
	sturb	w8, [x29, #-8]
	b	LBB169_25
LBB169_24:
	ldr	x8, [sp, #64]
	ldur	x10, [x29, #-56]
	ldr	x11, [sp, #56]
	mov	x9, x8
	casal	x9, x10, [x11]
	subs	x8, x9, x8
	cset	w8, eq
	stur	x9, [x29, #-16]
	sturb	w8, [x29, #-8]
	b	LBB169_25
LBB169_25:
	ldur	x8, [x29, #-16]
	str	x8, [sp, #8]
	ldurb	w8, [x29, #-8]
	tbnz	w8, #0, LBB169_39
	b	LBB169_38
LBB169_26:
	ldr	x8, [sp, #64]
	ldur	x10, [x29, #-56]
	ldr	x11, [sp, #56]
	mov	x9, x8
	casl	x9, x10, [x11]
	subs	x8, x9, x8
	cset	w8, eq
	stur	x9, [x29, #-16]
	sturb	w8, [x29, #-8]
	b	LBB169_25
LBB169_27:
	ldr	x8, [sp, #64]
	ldur	x10, [x29, #-56]
	ldr	x11, [sp, #56]
	mov	x9, x8
	casal	x9, x10, [x11]
	subs	x8, x9, x8
	cset	w8, eq
	stur	x9, [x29, #-16]
	sturb	w8, [x29, #-8]
	b	LBB169_25
LBB169_28:
	ldr	x8, [sp, #64]
	ldur	x10, [x29, #-56]
	ldr	x11, [sp, #56]
	mov	x9, x8
	casal	x9, x10, [x11]
	subs	x8, x9, x8
	cset	w8, eq
	stur	x9, [x29, #-16]
	sturb	w8, [x29, #-8]
	b	LBB169_25
LBB169_29:
	ldr	x8, [sp, #64]
	ldur	x10, [x29, #-56]
	ldr	x11, [sp, #56]
	mov	x9, x8
	casa	x9, x10, [x11]
	subs	x8, x9, x8
	cset	w8, eq
	stur	x9, [x29, #-16]
	sturb	w8, [x29, #-8]
	b	LBB169_25
LBB169_30:
	ldr	x8, [sp, #64]
	ldur	x10, [x29, #-56]
	ldr	x11, [sp, #56]
	mov	x9, x8
	casa	x9, x10, [x11]
	subs	x8, x9, x8
	cset	w8, eq
	stur	x9, [x29, #-16]
	sturb	w8, [x29, #-8]
	b	LBB169_25
LBB169_31:
	ldr	x8, [sp, #64]
	ldur	x10, [x29, #-56]
	ldr	x11, [sp, #56]
	mov	x9, x8
	casal	x9, x10, [x11]
	subs	x8, x9, x8
	cset	w8, eq
	stur	x9, [x29, #-16]
	sturb	w8, [x29, #-8]
	b	LBB169_25
LBB169_32:
	ldr	x8, [sp, #64]
	ldur	x10, [x29, #-56]
	ldr	x11, [sp, #56]
	mov	x9, x8
	casal	x9, x10, [x11]
	subs	x8, x9, x8
	cset	w8, eq
	stur	x9, [x29, #-16]
	sturb	w8, [x29, #-8]
	b	LBB169_25
LBB169_33:
	ldr	x8, [sp, #64]
	ldur	x10, [x29, #-56]
	ldr	x11, [sp, #56]
	mov	x9, x8
	casal	x9, x10, [x11]
	subs	x8, x9, x8
	cset	w8, eq
	stur	x9, [x29, #-16]
	sturb	w8, [x29, #-8]
	b	LBB169_25
LBB169_34:
	ldr	x8, [sp, #64]
	ldur	x10, [x29, #-56]
	ldr	x11, [sp, #56]
	mov	x9, x8
	casal	x9, x10, [x11]
	subs	x8, x9, x8
	cset	w8, eq
	stur	x9, [x29, #-16]
	sturb	w8, [x29, #-8]
	b	LBB169_25
LBB169_35:
	ldr	x8, [sp, #64]
	ldur	x10, [x29, #-56]
	ldr	x11, [sp, #56]
	mov	x9, x8
	casal	x9, x10, [x11]
	subs	x8, x9, x8
	cset	w8, eq
	stur	x9, [x29, #-16]
	sturb	w8, [x29, #-8]
	b	LBB169_25
LBB169_36:
	ldr	x8, [sp, #64]
	ldur	x10, [x29, #-56]
	ldr	x11, [sp, #56]
	mov	x9, x8
	casal	x9, x10, [x11]
	subs	x8, x9, x8
	cset	w8, eq
	stur	x9, [x29, #-16]
	sturb	w8, [x29, #-8]
	b	LBB169_25
LBB169_37:
	ldr	x8, [sp, #64]
	ldur	x10, [x29, #-56]
	ldr	x11, [sp, #56]
	mov	x9, x8
	casal	x9, x10, [x11]
	subs	x8, x9, x8
	cset	w8, eq
	stur	x9, [x29, #-16]
	sturb	w8, [x29, #-8]
	b	LBB169_25
LBB169_38:
	ldr	x8, [sp, #8]
	stur	x8, [x29, #-24]
	mov	w8, #1
	stur	x8, [x29, #-32]
	b	LBB169_40
LBB169_39:
	ldr	x8, [sp, #8]
	stur	x8, [x29, #-24]
	stur	xzr, [x29, #-32]
	b	LBB169_40
LBB169_40:
	ldur	x0, [x29, #-32]
	ldur	x1, [x29, #-24]
	.cfi_def_cfa wsp, 144
	ldp	x29, x30, [sp, #128]
	add	sp, sp, #144
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB169_41:
	.cfi_restore_state
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.76@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.76@PAGEOFF
	mov	w8, #105
	mov	x1, x8
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.77@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.77@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking9panic_fmt
LBB169_42:
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.78@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.78@PAGEOFF
	mov	w8, #123
	mov	x1, x8
	adrp	x2, l_anon.06e111bfef83652125d85ade023d82af.79@PAGE
	add	x2, x2, l_anon.06e111bfef83652125d85ade023d82af.79@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking9panic_fmt
	.cfi_endproc

	.p2align	2
__ZN4core4sync6atomic27Atomic$LT$$BP$mut$u20$T$GT$16compare_exchange17h9a4def0110a46c86E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core4sync6atomic23atomic_compare_exchange17h6f1b4d6613253870E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4sync6atomic27Atomic$LT$$BP$mut$u20$T$GT$4load17h18e13fdcd3086d45E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core4sync6atomic11atomic_load17h120f679d9743a856E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4sync6atomic27Atomic$LT$$BP$mut$u20$T$GT$7get_mut17h25736bdbef8dc2b6E:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4iter17h5030a3cb3195ee5fE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core5slice4iter13Iter$LT$T$GT$3new17ha77ec5a199f44b42E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$8is_empty17h21c1aba677263436E:
	.cfi_startproc
	subs	x8, x1, #0
	cset	w0, eq
	ret
	.cfi_endproc

	.p2align	2
__ZN4core5slice4iter13Iter$LT$T$GT$3new17ha77ec5a199f44b42E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	x0, [sp, #8]
	str	x1, [sp, #16]
	b	LBB175_1
LBB175_1:
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #16]
	add	x8, x8, x9, lsl #2
	str	x8, [sp, #24]
	b	LBB175_2
LBB175_2:
	ldr	x0, [sp, #8]
	ldr	x1, [sp, #24]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN4core6option15Option$LT$T$GT$11map_or_else17hc408839badecf0e8E:
Lfunc_begin45:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception45
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x8, [sp, #8]
	str	x2, [sp, #16]
	str	x0, [sp, #24]
	str	x1, [sp, #32]
	mov	w8, #1
	sturb	w8, [x29, #-17]
	sturb	w8, [x29, #-18]
	ldr	x8, [sp, #24]
	subs	x8, x8, #0
	cset	x8, ne
	tbz	w8, #0, LBB176_2
	b	LBB176_1
LBB176_1:
	ldr	x8, [sp, #8]
	ldr	x0, [sp, #24]
	ldr	x1, [sp, #32]
	sturb	wzr, [x29, #-18]
Ltmp588:
	bl	__ZN4core3ops8function6FnOnce9call_once17h98f3ede170e6f4cdE
Ltmp589:
	b	LBB176_7
LBB176_2:
	ldr	x0, [sp, #16]
	ldr	x8, [sp, #8]
	sturb	wzr, [x29, #-17]
Ltmp586:
	bl	__ZN5alloc3fmt6format28_$u7b$$u7b$closure$u7d$$u7d$17h6e2995a989b5b4e8E
Ltmp587:
	b	LBB176_5
LBB176_3:
	ldurb	w8, [x29, #-18]
	tbnz	w8, #0, LBB176_9
	b	LBB176_8
LBB176_4:
Ltmp590:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB176_3
LBB176_5:
	b	LBB176_6
LBB176_6:
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB176_7:
	.cfi_restore_state
	b	LBB176_6
LBB176_8:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB176_11
	b	LBB176_10
LBB176_9:
	b	LBB176_8
LBB176_10:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB176_11:
	b	LBB176_10
Lfunc_end45:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table176:
Lexception45:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end45-Lcst_begin45
Lcst_begin45:
	.uleb128 Ltmp588-Lfunc_begin45
	.uleb128 Ltmp587-Ltmp588
	.uleb128 Ltmp590-Lfunc_begin45
	.byte	0
	.uleb128 Ltmp587-Lfunc_begin45
	.uleb128 Lfunc_end45-Ltmp587
	.byte	0
	.byte	0
Lcst_end45:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core6option15Option$LT$T$GT$6map_or17h480d6d36d498b6c4E:
Lfunc_begin46:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception46
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x8, [sp]
	str	x1, [sp, #8]
	str	x0, [sp, #16]
	mov	w8, #1
	sturb	w8, [x29, #-17]
	ldr	x8, [sp, #16]
	subs	x8, x8, #0
	cset	x8, ne
	tbz	w8, #0, LBB177_2
	b	LBB177_1
LBB177_1:
	ldr	x8, [sp]
	ldr	x0, [sp, #16]
Ltmp591:
	bl	__ZN4core3ops8function6FnOnce9call_once17hc850d19569b8f48aE
Ltmp592:
	b	LBB177_6
LBB177_2:
	ldr	x9, [sp]
	ldr	x8, [sp, #8]
	sturb	wzr, [x29, #-17]
	ldr	q0, [x8]
	str	q0, [x9]
	ldr	x8, [x8, #16]
	str	x8, [x9, #16]
	b	LBB177_3
LBB177_3:
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB177_4:
	.cfi_restore_state
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB177_8
	b	LBB177_7
LBB177_5:
Ltmp593:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB177_4
LBB177_6:
	b	LBB177_3
LBB177_7:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB177_8:
	b	LBB177_7
Lfunc_end46:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table177:
Lexception46:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end46-Lcst_begin46
Lcst_begin46:
	.uleb128 Ltmp591-Lfunc_begin46
	.uleb128 Ltmp592-Ltmp591
	.uleb128 Ltmp593-Lfunc_begin46
	.byte	0
	.uleb128 Ltmp592-Lfunc_begin46
	.uleb128 Lfunc_end46-Ltmp592
	.byte	0
	.byte	0
Lcst_end46:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core6result19Result$LT$T$C$E$GT$6expect17hd93e4f52ec0d4851E:
Lfunc_begin47:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception47
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x1, [sp]
	str	x2, [sp, #8]
	str	x3, [sp, #16]
	sturb	w0, [x29, #-18]
	ldurb	w8, [x29, #-18]
	tbz	w8, #0, LBB178_2
	b	LBB178_1
LBB178_1:
Ltmp594:
	ldr	x4, [sp, #16]
	ldr	x1, [sp, #8]
	ldr	x0, [sp]
	sub	x2, x29, #17
	adrp	x3, l_anon.06e111bfef83652125d85ade023d82af.80@PAGE
	add	x3, x3, l_anon.06e111bfef83652125d85ade023d82af.80@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core6result13unwrap_failed
Ltmp595:
	b	LBB178_5
LBB178_2:
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB178_3:
	.cfi_restore_state
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB178_4:
Ltmp596:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB178_3
LBB178_5:
	brk	#0x1
Lfunc_end47:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table178:
Lexception47:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end47-Lcst_begin47
Lcst_begin47:
	.uleb128 Ltmp594-Lfunc_begin47
	.uleb128 Ltmp595-Ltmp594
	.uleb128 Ltmp596-Lfunc_begin47
	.byte	0
	.uleb128 Ltmp595-Lfunc_begin47
	.uleb128 Lfunc_end47-Ltmp595
	.byte	0
	.byte	0
Lcst_end47:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h1edeed61ada33503E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__RNvXsd_Cs7B2A3P5pSWO_10proc_macroNtB5_11TokenStreamINtNtCs6sq8b9ugfBC_4core7convert4FromNtB5_9TokenTreeE4from
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN52_$LT$char$u20$as$u20$core..str..pattern..Pattern$GT$12is_suffix_of17h7f3ea908676d8ed0E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x1, [sp, #8]
	str	x2, [sp, #16]
	sub	x1, x29, #4
	stur	wzr, [x29, #-4]
	mov	w8, #4
	mov	x2, x8
	bl	__ZN4core4char7methods15encode_utf8_raw17hc8a1d7bd480bea95E
	mov	x2, x0
	ldr	x0, [sp, #8]
	mov	x3, x1
	ldr	x1, [sp, #16]
	bl	__RNvMNtCs6sq8b9ugfBC_4core5sliceSh9ends_withCs3S5NQbda6bJ_9addr2line
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN53_$LT$core..fmt..Error$u20$as$u20$core..fmt..Debug$GT$3fmt17h14956214b7a8fd4bE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x0, x1
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.85@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.85@PAGEOFF
	mov	w8, #5
	mov	x2, x8
	bl	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter9write_str
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN55_$LT$$RF$str$u20$as$u20$core..str..pattern..Pattern$GT$12is_prefix_of17h50d2faf60bd928bdE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp]
	str	x1, [sp, #8]
	mov	x0, x2
	ldr	x2, [sp]
	mov	x1, x3
	ldr	x3, [sp, #8]
	bl	__RNvMNtCs6sq8b9ugfBC_4core5sliceSh11starts_withCs3S5NQbda6bJ_9addr2line
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN55_$LT$i8$u20$as$u20$const_random_macro..span..Random$GT$6random17hf8aceec44dad40eaE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN56_$LT$i64$u20$as$u20$const_random_macro..span..Random$GT$6random17ha1cde2f74f5c263fE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN55_$LT$u8$u20$as$u20$const_random_macro..span..Random$GT$6random17h915be92576e98222E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN56_$LT$u64$u20$as$u20$const_random_macro..span..Random$GT$6random17hd0db724fab496ea9E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN56_$LT$i16$u20$as$u20$const_random_macro..span..Random$GT$6random17h56244c89dc8b70abE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN56_$LT$i64$u20$as$u20$const_random_macro..span..Random$GT$6random17ha1cde2f74f5c263fE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN56_$LT$i32$u20$as$u20$const_random_macro..span..Random$GT$6random17h52fc3bb778283068E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN56_$LT$i64$u20$as$u20$const_random_macro..span..Random$GT$6random17ha1cde2f74f5c263fE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN56_$LT$i64$u20$as$u20$const_random_macro..span..Random$GT$6random17ha1cde2f74f5c263fE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN56_$LT$u64$u20$as$u20$const_random_macro..span..Random$GT$6random17hd0db724fab496ea9E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN56_$LT$u16$u20$as$u20$const_random_macro..span..Random$GT$6random17hc607b1150a1817c8E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN56_$LT$u64$u20$as$u20$const_random_macro..span..Random$GT$6random17hd0db724fab496ea9E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN56_$LT$u32$u20$as$u20$const_random_macro..span..Random$GT$6random17h110dc89208355614E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN56_$LT$u64$u20$as$u20$const_random_macro..span..Random$GT$6random17hd0db724fab496ea9E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN56_$LT$u64$u20$as$u20$const_random_macro..span..Random$GT$6random17hd0db724fab496ea9E:
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
	add	x8, sp, #24
	str	x8, [sp, #16]
	str	xzr, [sp, #24]
	add	x8, sp, #32
	str	x8, [sp, #8]
	bl	__ZN18const_random_macro4span10hash_stuff17h513da2c5f7147a32E
	ldr	x0, [sp, #8]
	ldr	x1, [sp, #16]
	mov	w8, #8
	mov	x2, x8
	bl	__ZN62_$LT$tiny_keccak..shake..Shake$u20$as$u20$tiny_keccak..Xof$GT$7squeeze17h3ab19e1c776c538eE
	ldr	x8, [sp, #24]
	stur	x8, [x29, #-32]
	ldur	x8, [x29, #-32]
	stur	x8, [x29, #-24]
	ldur	x0, [x29, #-24]
	bl	__ZN4core3num21_$LT$impl$u20$u64$GT$13from_ne_bytes17h73b719828a3d6017E
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
	.cfi_endproc

	.p2align	2
__ZN57_$LT$i128$u20$as$u20$const_random_macro..span..Random$GT$6random17hffccc85ae2963e77E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN57_$LT$u128$u20$as$u20$const_random_macro..span..Random$GT$6random17h50e753be5fcfaa33E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN57_$LT$u128$u20$as$u20$const_random_macro..span..Random$GT$6random17h50e753be5fcfaa33E:
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
	add	x8, sp, #16
	str	x8, [sp, #8]
	str	xzr, [sp, #16]
	str	xzr, [sp, #24]
	add	x8, sp, #32
	str	x8, [sp]
	bl	__ZN18const_random_macro4span10hash_stuff17h513da2c5f7147a32E
	ldr	x0, [sp]
	ldr	x1, [sp, #8]
	mov	w8, #16
	mov	x2, x8
	bl	__ZN62_$LT$tiny_keccak..shake..Shake$u20$as$u20$tiny_keccak..Xof$GT$7squeeze17h3ab19e1c776c538eE
	ldr	q0, [sp, #16]
	sub	x0, x29, #32
	stur	q0, [x29, #-32]
	bl	__ZN4core3num22_$LT$impl$u20$u128$GT$13from_ne_bytes17h2f52cfabd88b8e5cE
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
	.cfi_endproc

	.p2align	2
__ZN58_$LT$alloc..string..String$u20$as$u20$core..fmt..Write$GT$10write_char17h0a77be4d640bccc8E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN5alloc6string6String4push17h34f71ae3b48f9545E
	mov	w8, #0
	and	w0, w8, #0x1
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN58_$LT$alloc..string..String$u20$as$u20$core..fmt..Write$GT$9write_str17h754780582331f473E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN5alloc6string6String8push_str17h524a6c9265875f49E
	mov	w8, #0
	and	w0, w8, #0x1
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN5alloc3fmt6format17h40a0db9405895018E:
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x8, [sp, #16]
	str	x0, [sp, #32]
	str	x1, [sp, #40]
	ldr	x8, [sp, #40]
	str	x8, [sp, #24]
	and	x8, x8, #0x1
	subs	x8, x8, #1
	b.ne	LBB195_2
	b	LBB195_1
LBB195_1:
	ldr	x8, [sp, #24]
	ldr	x9, [sp, #32]
	str	x9, [sp]
	lsr	x8, x8, #1
	str	x8, [sp, #8]
	b	LBB195_3
LBB195_2:
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x9, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x8, [x8, #8]
	stur	x9, [x29, #-16]
	stur	x8, [x29, #-8]
	b	LBB195_4
LBB195_3:
	ldr	x8, [sp, #8]
	ldr	x9, [sp]
	stur	x9, [x29, #-16]
	stur	x8, [x29, #-8]
	b	LBB195_4
LBB195_4:
	ldr	x8, [sp, #16]
	ldur	x0, [x29, #-16]
	ldur	x1, [x29, #-8]
	add	x2, sp, #32
	bl	__ZN4core6option15Option$LT$T$GT$11map_or_else17hc408839badecf0e8E
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN5alloc3fmt6format28_$u7b$$u7b$closure$u7d$$u7d$17h6e2995a989b5b4e8E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x9, x0
	ldr	x0, [x9]
	ldr	x1, [x9, #8]
	bl	__RNvNvNtCs8dnTdrJsiec_5alloc3fmt6format12format_inner
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN5alloc3str56_$LT$impl$u20$alloc..borrow..ToOwned$u20$for$u20$str$GT$8to_owned17he0b18896824ffd95E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x8, [sp]
	add	x8, sp, #8
	bl	__ZN87_$LT$T$u20$as$u20$alloc..slice..$LT$impl$u20$$u5b$T$u5d$$GT$..to_vec_in..ConvertVec$GT$6to_vec17h49156347d466dfa7E
	ldr	x9, [sp]
	ldur	q0, [sp, #8]
	str	q0, [x9]
	ldr	x8, [sp, #24]
	str	x8, [x9, #16]
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN5alloc3vec16Vec$LT$T$C$A$GT$15append_elements17h2093f5345cecf7a6E:
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
	str	x1, [sp, #16]
	mov	x1, x2
	stur	x1, [x29, #-16]
	bl	__RNvMs_NtCs8dnTdrJsiec_5alloc3vecINtB4_3VechE7reserveCs3S5NQbda6bJ_9addr2line
	ldr	x0, [sp, #24]
	ldur	x2, [x29, #-16]
	ldr	x8, [x0, #16]
	stur	x8, [x29, #-8]
	subs	x8, x2, #0
	b.hi	LBB198_2
	b	LBB198_1
LBB198_1:
	ldr	x9, [sp, #24]
	ldur	x10, [x29, #-16]
	ldr	x8, [x9, #16]
	add	x8, x8, x10
	str	x8, [x9, #16]
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB198_2:
	.cfi_restore_state
	ldur	x9, [x29, #-8]
	ldr	x8, [sp, #24]
	ldr	x8, [x8, #8]
	add	x8, x8, x9
	str	x8, [sp, #8]
	b	LBB198_3
LBB198_3:
	ldr	x1, [sp, #16]
	ldr	x0, [sp, #8]
	ldur	x8, [x29, #-16]
	lsr	x2, x8, #0
	bl	_memcpy
	b	LBB198_1
	.cfi_endproc

	.p2align	2
__ZN5alloc3vec9from_elem17heee2863500f34816E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN63_$LT$u8$u20$as$u20$alloc..vec..spec_from_elem..SpecFromElem$GT$9from_elem17h38da004f84afa37eE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN5alloc3vec9into_iter21IntoIter$LT$T$C$A$GT$16as_raw_mut_slice17h7758ea869369f783E:
	.cfi_startproc
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	stp	x29, x30, [sp, #80]
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x8, [x0, #8]
	str	x8, [sp, #8]
	add	x8, sp, #40
	bl	__ZN103_$LT$alloc..vec..into_iter..IntoIter$LT$T$C$A$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h454f66b504005706E
	ldr	x8, [sp, #40]
	str	x8, [sp, #16]
	ldr	x10, [sp, #48]
	ldr	x9, [sp, #56]
	str	x10, [sp, #24]
	str	x9, [sp, #32]
	stur	x8, [x29, #-8]
	mov	w8, #1
	stur	x8, [x29, #-16]
	ldr	x8, [sp, #24]
	tbz	w8, #0, LBB200_2
	b	LBB200_1
LBB200_1:
	ldr	x9, [sp, #16]
	ldr	x8, [sp, #32]
	subs	x8, x8, x9
	b.eq	LBB200_4
	b	LBB200_3
LBB200_2:
	b	LBB200_3
LBB200_3:
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x3, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x4, [x8, #8]
	mov	w0, #0
	add	x1, sp, #24
	sub	x2, x29, #16
	adrp	x5, l_anon.06e111bfef83652125d85ade023d82af.87@PAGE
	add	x5, x5, l_anon.06e111bfef83652125d85ade023d82af.87@PAGEOFF
	bl	__RINvNtCs6sq8b9ugfBC_4core9panicking13assert_failedINtNtB4_6option6OptionjEBM_EB4_
LBB200_4:
	ldr	x1, [sp, #16]
	ldr	x0, [sp, #8]
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN5alloc5alloc6Global18alloc_impl_runtime17heb4804fa961c7ad9E:
	.cfi_startproc
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	stp	x29, x30, [sp, #80]
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	str	x1, [sp, #16]
	str	w2, [sp, #28]
	cbnz	x1, LBB201_2
	b	LBB201_1
LBB201_1:
	b	LBB201_3
LBB201_2:
	ldr	w8, [sp, #28]
	tbnz	w8, #0, LBB201_6
	b	LBB201_5
LBB201_3:
	ldr	x8, [sp, #8]
	str	x8, [sp, #32]
	str	xzr, [sp, #40]
	b	LBB201_4
LBB201_4:
	ldr	x0, [sp, #32]
	ldr	x1, [sp, #40]
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB201_5:
	.cfi_restore_state
	bl	__RNvCsGIExRX8pES_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	ldr	x0, [sp, #16]
	ldr	x1, [sp, #8]
	bl	__RNvCsGIExRX8pES_7___rustc12___rust_alloc
	stur	x0, [x29, #-32]
	b	LBB201_7
LBB201_6:
	bl	__RNvCsGIExRX8pES_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	ldr	x0, [sp, #16]
	ldr	x1, [sp, #8]
	bl	__RNvCsGIExRX8pES_7___rustc19___rust_alloc_zeroed
	stur	x0, [x29, #-32]
	b	LBB201_7
LBB201_7:
	ldur	x8, [x29, #-32]
	cbnz	x8, LBB201_9
	b	LBB201_8
LBB201_8:
	stur	xzr, [x29, #-8]
	stur	xzr, [x29, #-16]
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x9, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x8, [x8, #8]
	str	x9, [sp, #32]
	str	x8, [sp, #40]
	b	LBB201_4
LBB201_9:
	b	LBB201_10
LBB201_10:
	ldur	x8, [x29, #-32]
	stur	x8, [x29, #-8]
	ldur	x8, [x29, #-8]
	stur	x8, [x29, #-16]
	ldur	x8, [x29, #-16]
	stur	x8, [x29, #-24]
	ldur	x8, [x29, #-24]
	str	x8, [sp]
	b	LBB201_11
LBB201_11:
	ldr	x8, [sp, #16]
	ldr	x9, [sp]
	str	x9, [sp, #32]
	str	x8, [sp, #40]
	b	LBB201_4
	.cfi_endproc

	.p2align	2
__ZN5alloc5boxed12Box$LT$T$GT$8from_raw17h9bf83e94cd775eafE:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	b	LBB202_1
LBB202_1:
	ldr	x0, [sp, #8]
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN5alloc5boxed12Box$LT$T$GT$8into_raw17hf6a55e6c64f27777E:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN5alloc5boxed14box_new_uninit17h5f1a5509780f8a7eE:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp]
	str	x1, [sp, #8]
	mov	w8, #0
	and	w2, w8, #0x1
	bl	__ZN5alloc5alloc6Global18alloc_impl_runtime17heb4804fa961c7ad9E
	str	x0, [sp, #16]
	str	x1, [sp, #24]
	ldr	x9, [sp, #16]
	mov	x8, #0
	subs	x9, x9, #0
	csinc	x8, x8, xzr, ne
	tbz	w8, #0, LBB204_2
	b	LBB204_1
LBB204_1:
	ldr	x1, [sp, #8]
	ldr	x0, [sp]
	bl	__RNvNtCs8dnTdrJsiec_5alloc5alloc18handle_alloc_error
LBB204_2:
	ldr	x0, [sp, #16]
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN5alloc5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$6to_vec17h0982013d5bb3354fE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN87_$LT$T$u20$as$u20$alloc..slice..$LT$impl$u20$$u5b$T$u5d$$GT$..to_vec_in..ConvertVec$GT$6to_vec17h49156347d466dfa7E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN5alloc6string6String4push17h34f71ae3b48f9545E:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #16]
	stur	w1, [x29, #-20]
	ldr	x8, [x0, #16]
	stur	x8, [x29, #-16]
	subs	w8, w1, #128
	b.lo	LBB206_2
	b	LBB206_1
LBB206_1:
	ldur	w8, [x29, #-20]
	subs	w8, w8, #2048
	b.lo	LBB206_4
	b	LBB206_3
LBB206_2:
	mov	w8, #1
	stur	x8, [x29, #-8]
	b	LBB206_7
LBB206_3:
	ldur	w8, [x29, #-20]
	subs	w8, w8, #16, lsl #12
	b.lo	LBB206_6
	b	LBB206_5
LBB206_4:
	mov	w8, #2
	stur	x8, [x29, #-8]
	b	LBB206_7
LBB206_5:
	mov	w8, #4
	stur	x8, [x29, #-8]
	b	LBB206_7
LBB206_6:
	mov	w8, #3
	stur	x8, [x29, #-8]
	b	LBB206_7
LBB206_7:
	ldr	x0, [sp, #16]
	ldur	x1, [x29, #-8]
	bl	__RNvMs_NtCs8dnTdrJsiec_5alloc3vecINtB4_3VechE7reserveCs3S5NQbda6bJ_9addr2line
	ldr	x9, [sp, #16]
	ldur	w0, [x29, #-20]
	ldr	x8, [x9, #8]
	ldr	x9, [x9, #16]
	add	x1, x8, x9
	bl	__ZN4core4char7methods25encode_utf8_raw_unchecked17haed202e84a7a293fE
	ldur	x8, [x29, #-16]
	ldur	x9, [x29, #-8]
	add	x8, x8, x9
	str	x8, [sp, #8]
	b	LBB206_8
LBB206_8:
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #16]
	str	x8, [x9, #16]
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN5alloc6string6String8as_bytes17h7343b1a88b0582c5E:
	.cfi_startproc
	mov	x8, x0
	ldr	x0, [x8, #8]
	ldr	x1, [x8, #16]
	ret
	.cfi_endproc

	.p2align	2
__ZN5alloc6string6String8push_str17h524a6c9265875f49E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x1, [sp, #8]
	add	x8, x1, x2
	str	x8, [sp, #16]
	ldr	x1, [sp, #8]
	ldr	x8, [sp, #16]
	subs	x8, x8, x1
	stur	x8, [x29, #-8]
	ldur	x2, [x29, #-8]
	bl	__ZN5alloc3vec16Vec$LT$T$C$A$GT$15append_elements17h2093f5345cecf7a6E
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN5alloc7raw_vec20RawVecInner$LT$A$GT$16with_capacity_in17hd1d1b4f9a864b169E:
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x1, [sp, #16]
	mov	x3, x2
	ldr	x2, [sp, #16]
	str	x3, [sp, #24]
	add	x8, sp, #32
	mov	w9, #0
	and	w1, w9, #0x1
	bl	__RNvMs4_NtCs8dnTdrJsiec_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCsixjwb4TfRM4_5gimli
	ldr	x8, [sp, #32]
	tbz	w8, #0, LBB209_2
	b	LBB209_1
LBB209_1:
	ldr	x0, [sp, #40]
	ldr	x1, [sp, #48]
	bl	__RNvNtCs8dnTdrJsiec_5alloc7raw_vec12handle_error
LBB209_2:
	ldr	x8, [sp, #24]
	ldr	x9, [sp, #40]
	str	x9, [sp]
	ldr	x9, [sp, #48]
	str	x9, [sp, #8]
	cbnz	x8, LBB209_4
	b	LBB209_3
LBB209_3:
	mov	x8, #-1
	stur	x8, [x29, #-8]
	b	LBB209_5
LBB209_4:
	ldr	x8, [sp]
	stur	x8, [x29, #-8]
	b	LBB209_5
LBB209_5:
	b	LBB209_6
LBB209_6:
	ldr	x1, [sp, #8]
	ldr	x0, [sp]
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN62_$LT$proc_macro..TokenStream$u20$as$u20$core..clone..Clone$GT$5clone17h791f2e4680cecc0eE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp]
	ldr	w8, [x0]
	subs	w8, w8, #0
	cset	x8, ne
	tbz	w8, #0, LBB210_2
	b	LBB210_1
LBB210_1:
	ldr	x0, [sp]
	bl	__RNvXs8_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6clientNtB5_11TokenStreamNtNtCs6sq8b9ugfBC_4core5clone5Clone5clone
	stur	w0, [x29, #-4]
	b	LBB210_3
LBB210_2:
	stur	wzr, [x29, #-4]
	b	LBB210_3
LBB210_3:
	ldur	w0, [x29, #-4]
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h26990086c6e6d992E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x8, [sp, #8]
	mov	x1, x0
	ldr	x0, [sp, #8]
	mov	w8, #40
	mov	x2, x8
	bl	_memcpy
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h2a560d0dbc42822dE:
	.cfi_startproc
	mov	x9, x8
	ldr	q0, [x0]
	str	q0, [x9]
	ldr	w8, [x0, #16]
	str	w8, [x9, #16]
	ret
	.cfi_endproc

	.p2align	2
__ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h6bc589d4dc7ad736E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x8, [sp, #8]
	mov	x1, x0
	ldr	x0, [sp, #8]
	mov	w8, #112
	mov	x2, x8
	bl	_memcpy
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17ha12260cd5ae5105bE:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN63_$LT$alloc..alloc..Global$u20$as$u20$core..alloc..Allocator$GT$10deallocate17h9fa3d81b591343b3E:
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
	stur	x3, [x29, #-8]
	cbnz	x3, LBB215_2
	b	LBB215_1
LBB215_1:
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB215_2:
	.cfi_restore_state
	ldr	x2, [sp, #16]
	ldur	x1, [x29, #-8]
	ldr	x0, [sp, #8]
	bl	__RNvCsGIExRX8pES_7___rustc14___rust_dealloc
	b	LBB215_1
	.cfi_endproc

	.p2align	2
__ZN63_$LT$u8$u20$as$u20$alloc..vec..spec_from_elem..SpecFromElem$GT$9from_elem17h38da004f84afa37eE:
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x8, [sp, #16]
	str	w0, [sp, #28]
	str	x1, [sp, #32]
	and	w8, w0, #0xff
	cbnz	w8, LBB216_2
	b	LBB216_1
LBB216_1:
	ldr	x0, [sp, #32]
	sub	x8, x29, #24
	mov	w9, #1
	and	w1, w9, #0x1
	mov	w9, #1
	mov	x3, x9
	mov	x2, x3
	bl	__RNvMs4_NtCs8dnTdrJsiec_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCsixjwb4TfRM4_5gimli
	ldur	x8, [x29, #-24]
	tbnz	w8, #0, LBB216_3
	b	LBB216_4
LBB216_2:
	ldr	x0, [sp, #32]
	mov	w8, #1
	mov	x2, x8
	mov	x1, x2
	bl	__ZN5alloc7raw_vec20RawVecInner$LT$A$GT$16with_capacity_in17hd1d1b4f9a864b169E
	ldr	x8, [sp, #16]
	str	x0, [x8]
	str	x1, [x8, #8]
	str	xzr, [x8, #16]
	ldr	x8, [x8, #8]
	str	x8, [sp, #8]
	b	LBB216_6
LBB216_3:
	ldur	x0, [x29, #-16]
	ldur	x1, [x29, #-8]
	bl	__RNvNtCs8dnTdrJsiec_5alloc7raw_vec12handle_error
LBB216_4:
	ldr	x8, [sp, #32]
	ldr	x9, [sp, #16]
	ldur	x11, [x29, #-16]
	ldur	x10, [x29, #-8]
	str	x11, [x9]
	str	x10, [x9, #8]
	str	x8, [x9, #16]
	b	LBB216_5
LBB216_5:
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB216_6:
	.cfi_restore_state
	ldr	w1, [sp, #28]
	ldr	x0, [sp, #8]
	ldr	x9, [sp, #32]
	mov	w8, #1
	mul	x2, x8, x9
	bl	_memset
	b	LBB216_7
LBB216_7:
	ldr	x8, [sp, #32]
	ldr	x9, [sp, #16]
	str	x8, [x9, #16]
	b	LBB216_5
	.cfi_endproc

	.p2align	2
__ZN64_$LT$u32$u20$as$u20$proc_macro..bridge..rpc..Decode$LT$S$GT$$GT$6decode17ha8c3399d255b7efaE:
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #32]
	stur	wzr, [x29, #-8]
	ldr	x8, [x0]
	stur	x8, [x29, #-24]
	ldr	x9, [x0, #8]
	stur	x9, [x29, #-16]
	mov	w8, #4
	subs	x8, x8, x9
	b.ls	LBB217_2
	b	LBB217_1
LBB217_1:
	ldur	x2, [x29, #-16]
	mov	x0, #0
	mov	w8, #4
	mov	x1, x8
	adrp	x3, l_anon.06e111bfef83652125d85ade023d82af.89@PAGE
	add	x3, x3, l_anon.06e111bfef83652125d85ade023d82af.89@PAGEOFF
	bl	__RNvNtNtCs6sq8b9ugfBC_4core5slice5index16slice_index_fail
LBB217_2:
	ldur	x2, [x29, #-24]
	sub	x0, x29, #8
	mov	w8, #4
	mov	x3, x8
	str	x3, [sp, #8]
	mov	x1, x3
	adrp	x4, l_anon.06e111bfef83652125d85ade023d82af.89@PAGE
	add	x4, x4, l_anon.06e111bfef83652125d85ade023d82af.89@PAGEOFF
	bl	__ZN4core5slice20copy_from_slice_impl17h5b006b0ada326236E
	ldr	x9, [sp, #32]
	ldr	x8, [sp, #8]
	ldr	x10, [x9]
	str	x10, [sp, #16]
	ldr	x9, [x9, #8]
	str	x9, [sp, #24]
	subs	x8, x8, x9
	b.hi	LBB217_4
	b	LBB217_3
LBB217_3:
	ldr	x9, [sp, #32]
	ldr	x10, [sp, #16]
	ldr	x8, [sp, #24]
	subs	x8, x8, #4
	add	x10, x10, #4
	str	x10, [x9]
	str	x8, [x9, #8]
	ldur	w8, [x29, #-8]
	stur	w8, [x29, #-4]
	ldur	w0, [x29, #-4]
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB217_4:
	.cfi_restore_state
	ldr	x2, [sp, #24]
	mov	w8, #4
	mov	x0, x8
	mov	x1, x2
	adrp	x3, l_anon.06e111bfef83652125d85ade023d82af.89@PAGE
	add	x3, x3, l_anon.06e111bfef83652125d85ade023d82af.89@PAGEOFF
	bl	__RNvNtNtCs6sq8b9ugfBC_4core5slice5index16slice_index_fail
	.cfi_endproc

	.p2align	2
__ZN68_$LT$$RF$str$u20$as$u20$proc_macro..bridge..rpc..Encode$LT$S$GT$$GT$6encode17h449d61ce031fc279E:
Lfunc_begin48:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception48
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	mov	x8, x1
	str	x8, [sp, #16]
	mov	x0, x2
	str	x0, [sp]
	add	x1, sp, #24
	str	x8, [sp, #24]
	bl	__ZN10proc_macro6bridge6buffer6Buffer17extend_from_array17had3c6f4a2e2ad10eE
	ldr	x0, [sp]
	ldr	x1, [sp, #8]
	ldr	x2, [sp, #16]
	bl	__ZN10proc_macro6bridge6buffer6Buffer17extend_from_slice17h7647dd530951f358E
	str	xzr, [sp, #32]
	ldr	x8, [sp, #32]
	subs	x8, x8, #0
	cset	x8, ne
	tbz	w8, #0, LBB218_6
	b	LBB218_1
LBB218_1:
	ldr	x8, [sp, #32]
	sub	x2, x29, #24
	stur	x8, [x29, #-24]
Ltmp598:
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.82@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.82@PAGEOFF
	mov	w8, #43
	mov	x1, x8
	adrp	x3, l_anon.06e111bfef83652125d85ade023d82af.84@PAGE
	add	x3, x3, l_anon.06e111bfef83652125d85ade023d82af.84@PAGEOFF
	adrp	x4, l_anon.06e111bfef83652125d85ade023d82af.90@PAGE
	add	x4, x4, l_anon.06e111bfef83652125d85ade023d82af.90@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core6result13unwrap_failed
Ltmp599:
	b	LBB218_3
LBB218_2:
Ltmp600:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
Ltmp601:
	sub	x0, x29, #24
	bl	__ZN4core3ptr42drop_in_place$LT$std..io..error..Error$GT$17h0afc3805cbdcff76E
Ltmp602:
	b	LBB218_5
LBB218_3:
	brk	#0x1
LBB218_4:
Ltmp603:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB218_5:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB218_6:
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
Lfunc_end48:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table218:
Lexception48:
	.byte	255
	.byte	155
	.uleb128 Lttbase32-Lttbaseref32
Lttbaseref32:
	.byte	1
	.uleb128 Lcst_end48-Lcst_begin48
Lcst_begin48:
	.uleb128 Lfunc_begin48-Lfunc_begin48
	.uleb128 Ltmp598-Lfunc_begin48
	.byte	0
	.byte	0
	.uleb128 Ltmp598-Lfunc_begin48
	.uleb128 Ltmp599-Ltmp598
	.uleb128 Ltmp600-Lfunc_begin48
	.byte	0
	.uleb128 Ltmp601-Lfunc_begin48
	.uleb128 Ltmp602-Ltmp601
	.uleb128 Ltmp603-Lfunc_begin48
	.byte	1
	.uleb128 Ltmp602-Lfunc_begin48
	.uleb128 Lfunc_end48-Ltmp602
	.byte	0
	.byte	0
Lcst_end48:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase32:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN68_$LT$core..num..error..ParseIntError$u20$as$u20$core..fmt..Debug$GT$3fmt17he5923bd3b27e2c7bE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	mov	x0, x1
	add	x5, sp, #8
	str	x8, [sp, #8]
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.92@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.92@PAGEOFF
	mov	w8, #13
	mov	x2, x8
	adrp	x3, l_anon.06e111bfef83652125d85ade023d82af.93@PAGE
	add	x3, x3, l_anon.06e111bfef83652125d85ade023d82af.93@PAGEOFF
	mov	w8, #4
	mov	x4, x8
	adrp	x6, l_anon.06e111bfef83652125d85ade023d82af.91@PAGE
	add	x6, x6, l_anon.06e111bfef83652125d85ade023d82af.91@PAGEOFF
	bl	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter26debug_struct_field1_finish
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN69_$LT$$LP$$RP$$u20$as$u20$proc_macro..bridge..rpc..Encode$LT$S$GT$$GT$6encode17hdfd673e96d623addE:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN70_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h29ecb704495273afE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	ldr	x0, [x8, #8]
	ldr	x1, [x8, #16]
	bl	__ZN4core3ptr179drop_in_place$LT$$u5b$proc_macro..bridge..TokenTree$LT$proc_macro..bridge..client..TokenStream$C$proc_macro..bridge..client..Span$C$proc_macro..bridge..symbol..Symbol$GT$$u5d$$GT$17h4643010496cca31dE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN70_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h91322b7b504faf15E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	ldr	x0, [x8, #8]
	ldr	x1, [x8, #16]
	bl	__ZN4core3ptr70drop_in_place$LT$$u5b$proc_macro..bridge..client..TokenStream$u5d$$GT$17hfb030babc04bc1c2E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN72_$LT$alloc..boxed..Box$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h14ec8648543f5c08E:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp]
	ldr	x8, [x0]
	str	x8, [sp, #8]
	mov	w8, #24
	stur	x8, [x29, #-16]
	ldur	x8, [x29, #-16]
	str	x8, [sp, #16]
	mov	w8, #8
	stur	x8, [x29, #-8]
	ldur	x8, [x29, #-8]
	str	x8, [sp, #24]
	b	LBB223_1
LBB223_1:
	b	LBB223_2
LBB223_2:
	ldr	x8, [sp, #16]
	cbnz	x8, LBB223_4
	b	LBB223_3
LBB223_3:
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB223_4:
	.cfi_restore_state
	ldr	x3, [sp, #16]
	ldr	x2, [sp, #24]
	ldr	x1, [sp, #8]
	ldr	x8, [sp]
	add	x0, x8, #8
	bl	__ZN63_$LT$alloc..alloc..Global$u20$as$u20$core..alloc..Allocator$GT$10deallocate17h9fa3d81b591343b3E
	b	LBB223_3
	.cfi_endproc

	.p2align	2
__ZN72_$LT$alloc..boxed..Box$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h956a1555026ee3dcE:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp]
	ldr	x8, [x0]
	str	x8, [sp, #8]
	ldr	x8, [x0, #8]
	ldr	x9, [x8, #8]
	stur	x9, [x29, #-16]
	ldur	x9, [x29, #-16]
	str	x9, [sp, #16]
	ldr	x8, [x8, #16]
	stur	x8, [x29, #-8]
	ldur	x8, [x29, #-8]
	str	x8, [sp, #24]
	b	LBB224_1
LBB224_1:
	b	LBB224_2
LBB224_2:
	ldr	x8, [sp, #16]
	cbnz	x8, LBB224_4
	b	LBB224_3
LBB224_3:
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB224_4:
	.cfi_restore_state
	ldr	x3, [sp, #16]
	ldr	x2, [sp, #24]
	ldr	x1, [sp, #8]
	ldr	x8, [sp]
	add	x0, x8, #16
	bl	__ZN63_$LT$alloc..alloc..Global$u20$as$u20$core..alloc..Allocator$GT$10deallocate17h9fa3d81b591343b3E
	b	LBB224_3
	.cfi_endproc

	.p2align	2
__ZN72_$LT$alloc..boxed..Box$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17hf9c7aeca1564b72dE:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp]
	ldr	x8, [x0]
	str	x8, [sp, #8]
	mov	w8, #24
	stur	x8, [x29, #-16]
	ldur	x8, [x29, #-16]
	str	x8, [sp, #16]
	mov	w8, #8
	stur	x8, [x29, #-8]
	ldur	x8, [x29, #-8]
	str	x8, [sp, #24]
	b	LBB225_1
LBB225_1:
	b	LBB225_2
LBB225_2:
	ldr	x8, [sp, #16]
	cbnz	x8, LBB225_4
	b	LBB225_3
LBB225_3:
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB225_4:
	.cfi_restore_state
	ldr	x3, [sp, #16]
	ldr	x2, [sp, #24]
	ldr	x1, [sp, #8]
	ldr	x8, [sp]
	add	x0, x8, #8
	bl	__ZN63_$LT$alloc..alloc..Global$u20$as$u20$core..alloc..Allocator$GT$10deallocate17h9fa3d81b591343b3E
	b	LBB225_3
	.cfi_endproc

	.p2align	2
__ZN74_$LT$$LP$A$C$B$RP$$u20$as$u20$proc_macro..bridge..rpc..Decode$LT$S$GT$$GT$6decode17hebc1a0371e05e1cbE:
Lfunc_begin49:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception49
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x8, [sp, #8]
	str	x0, [sp, #16]
	str	x1, [sp, #24]
	sub	x8, x29, #28
	bl	__ZN104_$LT$proc_macro..bridge..ExpnGlobals$LT$Span$GT$$u20$as$u20$proc_macro..bridge..rpc..Decode$LT$S$GT$$GT$6decode17hab237885ced5cbd4E
	ldr	x0, [sp, #16]
	ldr	x1, [sp, #24]
Ltmp604:
	bl	__ZN100_$LT$proc_macro..bridge..client..TokenStream$u20$as$u20$proc_macro..bridge..rpc..Decode$LT$S$GT$$GT$6decode17hb4ba7616641e16f0E
	str	w0, [sp, #32]
Ltmp605:
	b	LBB226_3
LBB226_1:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB226_2:
Ltmp606:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB226_1
LBB226_3:
	ldr	w8, [sp, #32]
	ldr	x9, [sp, #8]
	ldur	x10, [x29, #-28]
	str	x10, [x9]
	ldur	w10, [x29, #-20]
	str	w10, [x9, #8]
	str	w8, [x9, #12]
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
Lfunc_end49:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table226:
Lexception49:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end49-Lcst_begin49
Lcst_begin49:
	.uleb128 Lfunc_begin49-Lfunc_begin49
	.uleb128 Ltmp604-Lfunc_begin49
	.byte	0
	.byte	0
	.uleb128 Ltmp604-Lfunc_begin49
	.uleb128 Ltmp605-Ltmp604
	.uleb128 Ltmp606-Lfunc_begin49
	.byte	0
	.uleb128 Ltmp605-Lfunc_begin49
	.uleb128 Lfunc_end49-Ltmp605
	.byte	0
	.byte	0
Lcst_end49:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN74_$LT$T$u20$as$u20$core..iter..adapters..flatten..ConstSizeIntoIterator$GT$4size17h0c63e9a1b15ecc2fE:
	.cfi_startproc
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x0, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x1, [x8, #8]
	ret
	.cfi_endproc

	.p2align	2
__ZN74_$LT$alloc..string..String$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17hc9406cecbd0821f2E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	mov	x2, x1
	ldr	x0, [x8, #8]
	ldr	x1, [x8, #16]
	bl	__ZN4core3str6traits99_$LT$impl$u20$core..slice..index..SliceIndex$LT$str$GT$$u20$for$u20$core..ops..range..RangeFull$GT$5index17hc7148db3acd1c8bcE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN75_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write..write_fmt..SpecWriteFmt$GT$14spec_write_fmt17h571d0069a1522e0fE:
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
	bl	__ZN4core3fmt9Arguments23as_statically_known_str17hbf39d6960e186619E
	stur	x0, [x29, #-16]
	stur	x1, [x29, #-8]
	ldur	x8, [x29, #-16]
	subs	x8, x8, #0
	cset	x8, ne
	tbz	w8, #0, LBB229_2
	b	LBB229_1
LBB229_1:
	ldr	x0, [sp]
	ldur	x1, [x29, #-16]
	ldur	x2, [x29, #-8]
	bl	__ZN58_$LT$alloc..string..String$u20$as$u20$core..fmt..Write$GT$9write_str17h754780582331f473E
	sturb	w0, [x29, #-17]
	b	LBB229_3
LBB229_2:
	ldr	x0, [sp]
	ldr	x2, [sp, #8]
	ldr	x3, [sp, #16]
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.52@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.52@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core3fmt5write
	sturb	w0, [x29, #-17]
	b	LBB229_3
LBB229_3:
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

	.p2align	2
__ZN75_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..deref..DerefMut$GT$9deref_mut17hc1481fc12fb042caE:
	.cfi_startproc
	mov	x8, x0
	ldr	x0, [x8, #8]
	ldr	x1, [x8, #16]
	ret
	.cfi_endproc

	.p2align	2
__ZN76_$LT$proc_macro..bridge..buffer..Buffer$u20$as$u20$core..ops..drop..Drop$GT$4drop17h2efde6d4d19a13c5E:
	.cfi_startproc
	sub	sp, sp, #128
	.cfi_def_cfa_offset 128
	stp	x29, x30, [sp, #112]
	add	x29, sp, #112
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x1, x0
	str	x1, [sp]
	sub	x8, x29, #40
	str	x8, [sp, #8]
	mov	w8, #1
	stur	x8, [x29, #-40]
	stur	xzr, [x29, #-32]
	stur	xzr, [x29, #-24]
	adrp	x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from7reserve@GOTPAGE
	ldr	x8, [x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from7reserve@GOTPAGEOFF]
	stur	x8, [x29, #-16]
	adrp	x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from4drop@GOTPAGE
	ldr	x8, [x8, __RNvNvXs6_NtNtCs7B2A3P5pSWO_10proc_macro6bridge6bufferNtB7_6BufferINtNtCs6sq8b9ugfBC_4core7convert4FromINtNtCs8dnTdrJsiec_5alloc3vec3VechEE4from4drop@GOTPAGEOFF]
	stur	x8, [x29, #-8]
	add	x0, sp, #32
	str	x0, [sp, #24]
	mov	w8, #40
	mov	x2, x8
	str	x2, [sp, #16]
	bl	_memcpy
	ldr	x0, [sp]
	ldr	x1, [sp, #8]
	ldr	x2, [sp, #16]
	bl	_memcpy
	ldr	x0, [sp, #24]
	ldr	x8, [sp, #64]
	blr	x8
	.cfi_def_cfa wsp, 128
	ldp	x29, x30, [sp, #112]
	add	sp, sp, #128
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN77_$LT$alloc..raw_vec..RawVec$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h0531f8ee3197b342E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	w8, #4
	mov	x1, x8
	mov	w8, #20
	mov	x2, x8
	bl	__RNvMs2_NtCs8dnTdrJsiec_5alloc7raw_vecNtB5_11RawVecInner10deallocateCsixjwb4TfRM4_5gimli
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN77_$LT$alloc..raw_vec..RawVec$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h1c55d22b397266c0E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	w8, #4
	mov	x2, x8
	mov	x1, x2
	bl	__RNvMs2_NtCs8dnTdrJsiec_5alloc7raw_vecNtB5_11RawVecInner10deallocateCsixjwb4TfRM4_5gimli
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN78_$LT$std..io..error..repr_bitpacked..Repr$u20$as$u20$core..ops..drop..Drop$GT$4drop17hed49dd561b05d467E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x0, [x0]
	add	x8, sp, #16
	str	x8, [sp, #8]
	bl	__ZN3std2io5error14repr_bitpacked11decode_repr17hf3cb7002e7cb91d9E
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr101drop_in_place$LT$std..io..error..ErrorData$LT$alloc..boxed..Box$LT$std..io..error..Custom$GT$$GT$$GT$17hc906c2cf77c5178aE
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN78_$LT$std..io..error..repr_bitpacked..Repr$u20$as$u20$core..ops..drop..Drop$GT$4drop28_$u7b$$u7b$closure$u7d$$u7d$17hf7f08577e63244eaE:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	b	LBB235_1
LBB235_1:
	ldr	x0, [sp, #8]
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN79_$LT$core..result..Result$LT$T$C$E$GT$$u20$as$u20$core..ops..try_trait..Try$GT$6branch17h6a5e58c8ded24a9bE:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp]
	b	LBB236_1
LBB236_1:
	ldr	x8, [sp]
	str	x8, [sp, #8]
	b	LBB236_2
LBB236_2:
	ldr	x0, [sp, #8]
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN79_$LT$core..result..Result$LT$T$C$E$GT$$u20$as$u20$core..ops..try_trait..Try$GT$6branch17h8369456b82d4fcb3E:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	w0, [sp, #8]
	ldr	w8, [sp, #8]
	subs	w8, w8, #0
	cset	x8, ne
	tbz	w8, #0, LBB237_2
	b	LBB237_1
LBB237_1:
	ldr	w8, [sp, #8]
	str	w8, [sp, #12]
	b	LBB237_3
LBB237_2:
	str	wzr, [sp, #12]
	b	LBB237_3
LBB237_3:
	ldr	w0, [sp, #12]
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN79_$LT$core..result..Result$LT$T$C$E$GT$$u20$as$u20$core..ops..try_trait..Try$GT$6branch17hc1e3cc4371a6ebe4E:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x8, [sp]
	str	x0, [sp, #8]
	ldr	x9, [x0]
	mov	x8, #0
	subs	x9, x9, #0
	csinc	x8, x8, xzr, ne
	tbz	w8, #0, LBB238_2
	b	LBB238_1
LBB238_1:
	ldr	x8, [sp]
	ldr	x9, [sp, #8]
	ldr	w9, [x9, #8]
	str	w9, [x8, #8]
	str	xzr, [x8]
	b	LBB238_3
LBB238_2:
	ldr	x9, [sp]
	ldr	x8, [sp, #8]
	ldr	x10, [x8]
	ldr	x8, [x8, #8]
	str	x10, [x9]
	str	x8, [x9, #8]
	b	LBB238_3
LBB238_3:
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h14e233d4ab3e0c98E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	mov	x2, x1
	ldr	x0, [x8, #8]
	ldr	x1, [x8, #16]
	bl	__ZN97_$LT$core..ops..range..RangeFull$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$5index17h5d71e72ec6b30750E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN85_$LT$once_cell..race..once_box..OnceBox$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17haf04d5ffa9c89b96E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core4sync6atomic27Atomic$LT$$BP$mut$u20$T$GT$7get_mut17h25736bdbef8dc2b6E
	ldr	x0, [x0]
	str	x0, [sp, #8]
	bl	__ZN4core3ptr7mut_ptr31_$LT$impl$u20$$BP$mut$u20$T$GT$7is_null17h3227f650dca8f8a8E
	tbnz	w0, #0, LBB240_2
	b	LBB240_1
LBB240_1:
	ldr	x0, [sp, #8]
	bl	__ZN5alloc5boxed12Box$LT$T$GT$8from_raw17h9bf83e94cd775eafE
	bl	__ZN4core3mem4drop17h2c6487e39c62f51aE
	b	LBB240_2
LBB240_2:
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN86_$LT$alloc..vec..into_iter..IntoIter$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h97a038f010e8f4e3E:
Lfunc_begin50:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception50
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	ldr	x0, [sp, #8]
Ltmp611:
	bl	__ZN5alloc3vec9into_iter21IntoIter$LT$T$C$A$GT$16as_raw_mut_slice17h7758ea869369f783E
Ltmp612:
	b	LBB241_3
LBB241_1:
Ltmp614:
	add	x0, sp, #8
	bl	__ZN4core3ptr156drop_in_place$LT$$LT$alloc..vec..into_iter..IntoIter$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$..drop..DropGuard$LT$u8$C$alloc..alloc..Global$GT$$GT$17h70575a127833dedcE
Ltmp615:
	b	LBB241_6
LBB241_2:
Ltmp613:
	str	x0, [sp, #16]
	mov	x8, x1
	str	w8, [sp, #24]
	b	LBB241_1
LBB241_3:
	b	LBB241_4
LBB241_4:
	add	x0, sp, #8
	bl	__ZN4core3ptr156drop_in_place$LT$$LT$alloc..vec..into_iter..IntoIter$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$..drop..DropGuard$LT$u8$C$alloc..alloc..Global$GT$$GT$17h70575a127833dedcE
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB241_5:
	.cfi_restore_state
Ltmp616:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB241_6:
	ldr	x0, [sp, #16]
	bl	__Unwind_Resume
Lfunc_end50:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table241:
Lexception50:
	.byte	255
	.byte	155
	.uleb128 Lttbase33-Lttbaseref33
Lttbaseref33:
	.byte	1
	.uleb128 Lcst_end50-Lcst_begin50
Lcst_begin50:
	.uleb128 Ltmp611-Lfunc_begin50
	.uleb128 Ltmp612-Ltmp611
	.uleb128 Ltmp613-Lfunc_begin50
	.byte	0
	.uleb128 Ltmp614-Lfunc_begin50
	.uleb128 Ltmp615-Ltmp614
	.uleb128 Ltmp616-Lfunc_begin50
	.byte	1
	.uleb128 Ltmp615-Lfunc_begin50
	.uleb128 Lfunc_end50-Ltmp615
	.byte	0
	.byte	0
Lcst_end50:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase33:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN86_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Group$GT$$GT$4from17h2679b878fbe3513bE:
	.cfi_startproc
	mov	x9, x8
	ldr	q0, [x0]
	str	q0, [x9]
	ldr	w8, [x0, #16]
	str	w8, [x9, #16]
	ret
	.cfi_endproc

	.p2align	2
__ZN86_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Ident$GT$$GT$4from17h6ee5e1744a207996E:
	.cfi_startproc
	mov	x9, x8
	ldr	x8, [x0]
	str	x8, [x9]
	ldr	w8, [x0, #8]
	str	w8, [x9, #8]
	mov	w8, #4
	strb	w8, [x9, #16]
	ret
	.cfi_endproc

	.p2align	2
__ZN86_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Punct$GT$$GT$4from17hff58e75d8bda0968E:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	mov	x9, x8
	str	x0, [sp, #8]
	ldr	x8, [sp, #8]
	str	x8, [sp]
	ldr	x8, [sp]
	str	x8, [x9]
	mov	w8, #5
	strb	w8, [x9, #16]
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN87_$LT$T$u20$as$u20$alloc..slice..$LT$impl$u20$$u5b$T$u5d$$GT$..to_vec_in..ConvertVec$GT$6to_vec17h49156347d466dfa7E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x8, [sp, #16]
	str	x0, [sp, #8]
	mov	x0, x1
	stur	x0, [x29, #-8]
	mov	w8, #1
	mov	x2, x8
	mov	x1, x2
	bl	__ZN5alloc7raw_vec20RawVecInner$LT$A$GT$16with_capacity_in17hd1d1b4f9a864b169E
	ldr	x8, [sp, #16]
	mov	x9, x1
	ldur	x1, [x29, #-8]
	str	x0, [x8]
	str	x9, [x8, #8]
	str	xzr, [x8, #16]
	subs	x8, x1, #0
	b.hi	LBB245_2
	b	LBB245_1
LBB245_1:
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB245_2:
	.cfi_restore_state
	ldr	x8, [sp, #16]
	ldr	x8, [x8, #8]
	str	x8, [sp]
	b	LBB245_3
LBB245_3:
	ldr	x1, [sp, #8]
	ldr	x0, [sp]
	ldur	x8, [x29, #-8]
	lsr	x2, x8, #0
	bl	_memcpy
	b	LBB245_4
LBB245_4:
	ldur	x8, [x29, #-8]
	ldr	x9, [sp, #16]
	str	x8, [x9, #16]
	b	LBB245_1
	.cfi_endproc

	.p2align	2
__ZN88_$LT$proc_macro..TokenTree$u20$as$u20$core..convert..From$LT$proc_macro..Literal$GT$$GT$4from17hd488e0f50b18ea9aE:
	.cfi_startproc
	mov	x9, x8
	ldr	q0, [x0]
	str	q0, [x9]
	mov	w8, #6
	strb	w8, [x9, #16]
	ret
	.cfi_endproc

	.p2align	2
__ZN90_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17hb373e9f63ca0e427E:
	.cfi_startproc
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	str	x8, [sp]
	ldr	q0, [x0]
	str	q0, [sp, #64]
	ldr	x8, [x0, #16]
	str	x8, [sp, #80]
	ldr	q0, [sp, #64]
	str	q0, [sp, #16]
	ldr	x8, [sp, #80]
	str	x8, [sp, #32]
	ldr	x8, [sp, #24]
	str	x8, [sp, #8]
	b	LBB247_1
LBB247_1:
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #32]
	add	x8, x8, x9
	str	x8, [sp, #48]
	b	LBB247_2
LBB247_2:
	b	LBB247_3
LBB247_3:
	ldr	x8, [sp, #16]
	str	x8, [sp, #56]
	b	LBB247_4
LBB247_4:
	ldr	x9, [sp]
	ldr	x8, [sp, #8]
	str	x8, [x9]
	ldr	x10, [sp, #56]
	str	x10, [x9, #16]
	str	x8, [x9, #8]
	ldr	x8, [sp, #48]
	str	x8, [x9, #24]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN91_$LT$core..slice..iter..Iter$LT$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4fold17h2291fdc9d893304bE:
Lfunc_begin51:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception51
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	stp	x29, x30, [sp, #80]
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	str	x1, [sp, #16]
	str	x2, [sp, #24]
	b	LBB248_1
LBB248_1:
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #16]
	subs	x8, x8, x9
	cset	w8, eq
	strb	w8, [sp, #39]
	b	LBB248_2
LBB248_2:
	ldrb	w8, [sp, #39]
	tbnz	w8, #0, LBB248_4
	b	LBB248_3
LBB248_3:
	sturb	wzr, [x29, #-17]
	mov	w8, #1
	sturb	w8, [x29, #-18]
	str	xzr, [sp, #40]
	b	LBB248_5
LBB248_4:
	sturb	wzr, [x29, #-17]
	b	LBB248_16
LBB248_5:
	b	LBB248_6
LBB248_6:
	b	LBB248_7
LBB248_7:
	b	LBB248_8
LBB248_8:
	ldr	x8, [sp, #16]
	ldr	x9, [sp, #8]
	subs	x8, x8, x9
	mov	w9, #4
	udiv	x8, x8, x9
	stur	x8, [x29, #-32]
	b	LBB248_11
LBB248_9:
	ldurb	w8, [x29, #-18]
	tbnz	w8, #0, LBB248_18
	b	LBB248_17
LBB248_10:
Ltmp621:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB248_9
LBB248_11:
	ldr	x8, [sp, #8]
	sturb	wzr, [x29, #-18]
	ldr	x9, [sp, #40]
	add	x1, x8, x9, lsl #2
Ltmp619:
	add	x0, sp, #24
	bl	__ZN4core4iter8adapters3map8map_fold28_$u7b$$u7b$closure$u7d$$u7d$17h89d49231f3496dd3E
Ltmp620:
	b	LBB248_12
LBB248_12:
	b	LBB248_13
LBB248_13:
	ldr	x8, [sp, #40]
	add	x8, x8, #1
	str	x8, [sp, #40]
	ldr	x8, [sp, #40]
	ldur	x9, [x29, #-32]
	subs	x8, x8, x9
	b.eq	LBB248_15
	b	LBB248_14
LBB248_14:
	b	LBB248_11
LBB248_15:
	b	LBB248_16
LBB248_16:
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB248_17:
	.cfi_restore_state
	b	LBB248_19
LBB248_18:
	b	LBB248_17
LBB248_19:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB248_21
	b	LBB248_20
LBB248_20:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB248_21:
	b	LBB248_20
Lfunc_end51:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table248:
Lexception51:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end51-Lcst_begin51
Lcst_begin51:
	.uleb128 Ltmp619-Lfunc_begin51
	.uleb128 Ltmp620-Ltmp619
	.uleb128 Ltmp621-Lfunc_begin51
	.byte	0
	.uleb128 Ltmp620-Lfunc_begin51
	.uleb128 Lfunc_end51-Ltmp620
	.byte	0
	.byte	0
Lcst_end51:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN91_$LT$core..slice..iter..Iter$LT$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h87677ec77a00cf16E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	str	x8, [sp, #24]
	str	x0, [sp, #32]
	b	LBB249_1
LBB249_1:
	ldr	x8, [sp, #32]
	ldr	x9, [x8, #8]
	str	x9, [sp, #8]
	ldr	x8, [x8]
	str	x8, [sp, #16]
	b	LBB249_2
LBB249_2:
	b	LBB249_3
LBB249_3:
	b	LBB249_4
LBB249_4:
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #16]
	subs	x8, x8, x9
	mov	w9, #4
	udiv	x8, x8, x9
	str	x8, [sp, #40]
	b	LBB249_5
LBB249_5:
	ldr	x9, [sp, #24]
	ldr	x10, [sp, #40]
	ldr	x8, [sp, #40]
	str	x10, [x9]
	mov	w10, #1
	str	x10, [x9, #8]
	str	x8, [x9, #16]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN93_$LT$proc_macro..bridge..client..Span$u20$as$u20$proc_macro..bridge..rpc..Decode$LT$S$GT$$GT$6decode17hb5f51c845caf2461E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN99_$LT$core..num..nonzero..NonZero$LT$u32$GT$$u20$as$u20$proc_macro..bridge..rpc..Decode$LT$S$GT$$GT$6decode17h6ee6bf7871053fffE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN97_$LT$core..ops..range..RangeFull$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$5index17h5d71e72ec6b30750E:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN98_$LT$proc_macro..bridge..rpc..PanicMessage$u20$as$u20$proc_macro..bridge..rpc..Encode$LT$S$GT$$GT$6encode17hf51ef868ebc1a1dbE:
Lfunc_begin52:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception52
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp]
	str	x1, [sp, #8]
	str	x2, [sp, #16]
	ldr	x9, [x0]
	mov	x8, #-9223372036854775808
	add	x8, x9, x8
	mov	x10, #-9223372036854775808
	subs	x9, x9, x10
	csinc	x8, x8, xzr, hs
	str	x8, [sp, #24]
	cbz	x8, LBB252_4
	b	LBB252_1
LBB252_1:
	ldr	x8, [sp, #24]
	subs	x8, x8, #1
	b.eq	LBB252_5
	b	LBB252_2
LBB252_2:
	b	LBB252_6
LBB252_4:
	.cfi_restore_state
	.cfi_remember_state
	ldr	x8, [sp]
	ldr	x9, [x8, #8]
	ldr	x8, [x8, #16]
	str	x9, [sp, #32]
	str	x8, [sp, #40]
	b	LBB252_7
LBB252_5:
	ldr	x8, [sp]
	ldr	x9, [x8, #8]
	ldr	x8, [x8, #16]
	str	x9, [sp, #32]
	str	x8, [sp, #40]
	b	LBB252_7
LBB252_6:
	adrp	x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	adrp	x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGE
	add	x8, x8, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF
	ldr	x9, [x9, l_anon.06e111bfef83652125d85ade023d82af.4@PAGEOFF]
	ldr	x8, [x8, #8]
	str	x9, [sp, #32]
	str	x8, [sp, #40]
	b	LBB252_7
LBB252_7:
	ldr	x3, [sp, #16]
	ldr	x2, [sp, #8]
	ldr	x0, [sp, #32]
	ldr	x1, [sp, #40]
Ltmp623:
	bl	__ZN10proc_macro6bridge1_100_$LT$impl$u20$proc_macro..bridge..rpc..Encode$LT$S$GT$$u20$for$u20$core..option..Option$LT$T$GT$$GT$6encode17h8e29e583bf7c5e08E
Ltmp624:
	b	LBB252_10
LBB252_8:
Ltmp626:
	ldr	x0, [sp]
	bl	__ZN4core3ptr58drop_in_place$LT$proc_macro..bridge..rpc..PanicMessage$GT$17h25717a361552132cE
Ltmp627:
	b	LBB252_12
LBB252_9:
Ltmp625:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB252_8
LBB252_10:
	ldr	x0, [sp]
	bl	__ZN4core3ptr58drop_in_place$LT$proc_macro..bridge..rpc..PanicMessage$GT$17h25717a361552132cE
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB252_11:
	.cfi_restore_state
Ltmp628:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB252_12:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
Lfunc_end52:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table252:
Lexception52:
	.byte	255
	.byte	155
	.uleb128 Lttbase34-Lttbaseref34
Lttbaseref34:
	.byte	1
	.uleb128 Lcst_end52-Lcst_begin52
Lcst_begin52:
	.uleb128 Ltmp623-Lfunc_begin52
	.uleb128 Ltmp624-Ltmp623
	.uleb128 Ltmp625-Lfunc_begin52
	.byte	0
	.uleb128 Ltmp626-Lfunc_begin52
	.uleb128 Ltmp627-Ltmp626
	.uleb128 Ltmp628-Lfunc_begin52
	.byte	1
	.uleb128 Ltmp627-Lfunc_begin52
	.uleb128 Lfunc_end52-Ltmp627
	.byte	0
	.byte	0
Lcst_end52:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase34:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN99_$LT$core..iter..sources..once..Once$LT$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h3280b2ce72e2e66dE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	mov	x9, x8
	mov	w8, #7
	strb	w8, [sp, #28]
	ldr	q0, [x0]
	str	q0, [x9]
	ldr	w8, [x0, #16]
	str	w8, [x9, #16]
	ldur	q0, [sp, #12]
	str	q0, [x0]
	ldr	w8, [sp, #28]
	str	w8, [x0, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN99_$LT$core..iter..sources..once..Once$LT$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$9size_hint17h88c04323c843ceabE:
	.cfi_startproc
	mov	x9, x8
	ldrb	w8, [x0, #16]
	mov	w10, #1
	subs	w8, w8, #7
	cset	x8, ne
	str	x8, [x9]
	str	x10, [x9, #8]
	str	x8, [x9, #16]
	ret
	.cfi_endproc

	.p2align	2
__ZN99_$LT$core..num..nonzero..NonZero$LT$u32$GT$$u20$as$u20$proc_macro..bridge..rpc..Decode$LT$S$GT$$GT$6decode17h6ee6bf7871053fffE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	bl	__ZN64_$LT$u32$u20$as$u20$proc_macro..bridge..rpc..Decode$LT$S$GT$$GT$6decode17ha8c3399d255b7efaE
	stur	w0, [x29, #-4]
	ldur	w8, [x29, #-4]
	subs	w8, w8, #0
	cset	x8, ne
	tbz	w8, #0, LBB255_2
	b	LBB255_1
LBB255_1:
	ldur	w0, [x29, #-4]
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB255_2:
	.cfi_restore_state
	adrp	x0, l_anon.06e111bfef83652125d85ade023d82af.94@PAGE
	add	x0, x0, l_anon.06e111bfef83652125d85ade023d82af.94@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core6option13unwrap_failed
	.cfi_endproc

	.p2align	2
__ZN9getrandom16getrandom_uninit17h3ede955bdf29454dE:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x8, [sp]
	str	x0, [sp, #8]
	str	x1, [sp, #16]
	bl	__ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$8is_empty17h21c1aba677263436E
	tbnz	w0, #0, LBB256_2
	b	LBB256_1
LBB256_1:
	ldr	x1, [sp, #16]
	ldr	x0, [sp, #8]
	bl	__ZN9getrandom3imp15getrandom_inner17hb6effd3c82ab532aE
	bl	__ZN79_$LT$core..result..Result$LT$T$C$E$GT$$u20$as$u20$core..ops..try_trait..Try$GT$6branch17h8369456b82d4fcb3E
	stur	w0, [x29, #-4]
	ldur	w8, [x29, #-4]
	subs	w8, w8, #0
	cset	x8, ne
	tbnz	w8, #0, LBB256_3
	b	LBB256_2
LBB256_2:
	ldr	x8, [sp, #16]
	ldr	x9, [sp]
	ldr	x10, [sp, #8]
	str	x10, [x9]
	str	x8, [x9, #8]
	b	LBB256_4
LBB256_3:
	ldr	x8, [sp]
	ldur	w0, [x29, #-4]
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.96@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.96@PAGEOFF
	bl	__ZN153_$LT$core..result..Result$LT$T$C$F$GT$$u20$as$u20$core..ops..try_trait..FromResidual$LT$core..result..Result$LT$core..convert..Infallible$C$E$GT$$GT$$GT$13from_residual17hb328f6e95c9b99a2E
	b	LBB256_4
LBB256_4:
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN9getrandom9getrandom17habe30d2120572968E:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	sub	x8, x29, #16
	str	x8, [sp]
	bl	__ZN9getrandom16getrandom_uninit17h3ede955bdf29454dE
	ldr	x0, [sp]
	add	x8, sp, #16
	bl	__ZN79_$LT$core..result..Result$LT$T$C$E$GT$$u20$as$u20$core..ops..try_trait..Try$GT$6branch17hc1e3cc4371a6ebe4E
	ldr	x9, [sp, #16]
	mov	x8, #0
	subs	x9, x9, #0
	csinc	x8, x8, xzr, ne
	tbz	w8, #0, LBB257_2
	b	LBB257_1
LBB257_1:
	ldr	w0, [sp, #24]
	adrp	x1, l_anon.06e111bfef83652125d85ade023d82af.97@PAGE
	add	x1, x1, l_anon.06e111bfef83652125d85ade023d82af.97@PAGEOFF
	bl	__ZN153_$LT$core..result..Result$LT$T$C$F$GT$$u20$as$u20$core..ops..try_trait..FromResidual$LT$core..result..Result$LT$core..convert..Infallible$C$E$GT$$GT$$GT$13from_residual17h9ed7761eac753b6dE
	str	w0, [sp, #12]
	b	LBB257_3
LBB257_2:
	str	wzr, [sp, #12]
	b	LBB257_3
LBB257_3:
	ldr	w0, [sp, #12]
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN9once_cell4race8once_box16OnceBox$LT$T$GT$11get_or_init17hcddf37578a96ef37E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN9once_cell4race8once_box16OnceBox$LT$T$GT$15get_or_try_init17h60bbaa0096df820eE
	str	x0, [sp, #8]
	b	LBB258_1
LBB258_1:
	ldr	x0, [sp, #8]
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN9once_cell4race8once_box16OnceBox$LT$T$GT$11get_or_init28_$u7b$$u7b$closure$u7d$$u7d$17ha2f6c10f6ce19163E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN18const_random_macro4span8get_seed28_$u7b$$u7b$closure$u7d$$u7d$17hb802de73426ca3b0E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN9once_cell4race8once_box16OnceBox$LT$T$GT$15get_or_try_init17h60bbaa0096df820eE:
Lfunc_begin53:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception53
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
	sturb	wzr, [x29, #-17]
	mov	w8, #1
	sturb	w8, [x29, #-17]
Ltmp630:
	bl	__ZN9once_cell4race8once_box16OnceBox$LT$T$GT$3get17ha643ecb3a3717195E
	str	x0, [sp, #16]
Ltmp631:
	b	LBB260_3
LBB260_1:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB260_11
	b	LBB260_10
LBB260_2:
Ltmp634:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB260_1
LBB260_3:
	ldr	x8, [sp, #16]
	str	x8, [sp, #32]
	ldr	x8, [sp, #32]
	subs	x8, x8, #0
	cset	x8, ne
	tbz	w8, #0, LBB260_5
	b	LBB260_4
LBB260_4:
	ldr	x8, [sp, #32]
	str	x8, [sp, #24]
	b	LBB260_7
LBB260_5:
	ldr	x0, [sp, #8]
	sturb	wzr, [x29, #-17]
Ltmp632:
	bl	__ZN9once_cell4race8once_box16OnceBox$LT$T$GT$4init17h6ef0392d828cb0b3E
	str	x0, [sp]
Ltmp633:
	b	LBB260_6
LBB260_6:
	ldr	x8, [sp]
	str	x8, [sp, #24]
	b	LBB260_7
LBB260_7:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB260_9
	b	LBB260_8
LBB260_8:
	ldr	x0, [sp, #24]
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB260_9:
	.cfi_restore_state
	b	LBB260_8
LBB260_10:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB260_11:
	b	LBB260_10
Lfunc_end53:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table260:
Lexception53:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end53-Lcst_begin53
Lcst_begin53:
	.uleb128 Ltmp630-Lfunc_begin53
	.uleb128 Ltmp633-Ltmp630
	.uleb128 Ltmp634-Lfunc_begin53
	.byte	0
	.uleb128 Ltmp633-Lfunc_begin53
	.uleb128 Lfunc_end53-Ltmp633
	.byte	0
	.byte	0
Lcst_end53:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN9once_cell4race8once_box16OnceBox$LT$T$GT$3get17ha643ecb3a3717195E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	w1, #2
	bl	__ZN4core4sync6atomic27Atomic$LT$$BP$mut$u20$T$GT$4load17h18e13fdcd3086d45E
	str	x0, [sp]
	bl	__ZN4core3ptr7mut_ptr31_$LT$impl$u20$$BP$mut$u20$T$GT$7is_null17h3227f650dca8f8a8E
	tbnz	w0, #0, LBB261_2
	b	LBB261_1
LBB261_1:
	ldr	x8, [sp]
	str	x8, [sp, #8]
	b	LBB261_3
LBB261_2:
	str	xzr, [sp, #8]
	b	LBB261_3
LBB261_3:
	ldr	x0, [sp, #8]
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN9once_cell4race8once_box16OnceBox$LT$T$GT$4init17h6ef0392d828cb0b3E:
Lfunc_begin54:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception54
	sub	sp, sp, #144
	.cfi_def_cfa_offset 144
	stp	x29, x30, [sp, #128]
	add	x29, sp, #128
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #48]
	sturb	wzr, [x29, #-17]
	bl	__ZN9once_cell4race8once_box16OnceBox$LT$T$GT$11get_or_init28_$u7b$$u7b$closure$u7d$$u7d$17ha2f6c10f6ce19163E
	bl	__ZN79_$LT$core..result..Result$LT$T$C$E$GT$$u20$as$u20$core..ops..try_trait..Try$GT$6branch17h6a5e58c8ded24a9bE
	stur	x0, [x29, #-56]
	b	LBB262_1
LBB262_1:
	ldur	x8, [x29, #-56]
	mov	w9, #1
	sturb	w9, [x29, #-17]
	str	x8, [sp, #64]
	sturb	wzr, [x29, #-17]
	ldr	x0, [sp, #64]
Ltmp635:
	bl	__ZN5alloc5boxed12Box$LT$T$GT$8into_raw17hf6a55e6c64f27777E
	str	x0, [sp, #40]
Ltmp636:
	b	LBB262_4
LBB262_2:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB262_13
	b	LBB262_12
LBB262_3:
Ltmp643:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB262_2
LBB262_4:
	ldr	x8, [sp, #40]
	stur	x8, [x29, #-48]
	b	LBB262_5
LBB262_5:
	ldr	x0, [sp, #48]
	ldur	x2, [x29, #-48]
Ltmp637:
	mov	x1, #0
	mov	w3, #1
	mov	w4, #2
	bl	__ZN4core4sync6atomic27Atomic$LT$$BP$mut$u20$T$GT$16compare_exchange17h9a4def0110a46c86E
	str	x0, [sp, #24]
	str	x1, [sp, #32]
Ltmp638:
	b	LBB262_6
LBB262_6:
	ldr	x8, [sp, #32]
	ldr	x9, [sp, #24]
	stur	x9, [x29, #-40]
	stur	x8, [x29, #-32]
	ldur	x8, [x29, #-40]
	tbz	w8, #0, LBB262_8
	b	LBB262_7
LBB262_7:
	ldur	x8, [x29, #-32]
	str	x8, [sp, #8]
	ldur	x0, [x29, #-48]
Ltmp639:
	bl	__ZN5alloc5boxed12Box$LT$T$GT$8from_raw17h9bf83e94cd775eafE
	str	x0, [sp, #16]
Ltmp640:
	b	LBB262_9
LBB262_8:
	ldur	x8, [x29, #-48]
	str	x8, [sp, #56]
	sturb	wzr, [x29, #-17]
	b	LBB262_11
LBB262_9:
Ltmp641:
	ldr	x0, [sp, #16]
	bl	__ZN4core3mem4drop17h2c6487e39c62f51aE
Ltmp642:
	b	LBB262_10
LBB262_10:
	ldr	x8, [sp, #8]
	stur	x8, [x29, #-48]
	b	LBB262_8
LBB262_11:
	ldr	x0, [sp, #56]
	.cfi_def_cfa wsp, 144
	ldp	x29, x30, [sp, #128]
	add	sp, sp, #144
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB262_12:
	.cfi_restore_state
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB262_13:
Ltmp644:
	add	x0, sp, #64
	bl	__ZN4core3ptr71drop_in_place$LT$alloc..boxed..Box$LT$alloc..vec..Vec$LT$u8$GT$$GT$$GT$17he5f2df7f14c16a1bE
Ltmp645:
	b	LBB262_12
LBB262_14:
Ltmp646:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
Lfunc_end54:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table262:
Lexception54:
	.byte	255
	.byte	155
	.uleb128 Lttbase35-Lttbaseref35
Lttbaseref35:
	.byte	1
	.uleb128 Lcst_end54-Lcst_begin54
Lcst_begin54:
	.uleb128 Lfunc_begin54-Lfunc_begin54
	.uleb128 Ltmp635-Lfunc_begin54
	.byte	0
	.byte	0
	.uleb128 Ltmp635-Lfunc_begin54
	.uleb128 Ltmp642-Ltmp635
	.uleb128 Ltmp643-Lfunc_begin54
	.byte	0
	.uleb128 Ltmp642-Lfunc_begin54
	.uleb128 Ltmp644-Ltmp642
	.byte	0
	.byte	0
	.uleb128 Ltmp644-Lfunc_begin54
	.uleb128 Ltmp645-Ltmp644
	.uleb128 Ltmp646-Lfunc_begin54
	.byte	1
Lcst_end54:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase35:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
___rust_try:
Lfunc_begin55:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception55
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	mov	x0, x1
	str	x0, [sp]
	str	x2, [sp, #8]
Ltmp647:
	blr	x8
Ltmp648:
	b	LBB263_1
LBB263_1:
	mov	w0, #0
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	ret
LBB263_2:
Ltmp649:
	ldr	x8, [sp, #8]
	mov	x1, x0
	ldr	x0, [sp]
	blr	x8
	mov	w0, #1
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	ret
Lfunc_end55:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table263:
Lexception55:
	.byte	255
	.byte	155
	.uleb128 Lttbase36-Lttbaseref36
Lttbaseref36:
	.byte	1
	.uleb128 Lcst_end55-Lcst_begin55
Lcst_begin55:
	.uleb128 Ltmp647-Lfunc_begin55
	.uleb128 Ltmp648-Ltmp647
	.uleb128 Ltmp649-Lfunc_begin55
	.byte	1
	.uleb128 Ltmp648-Lfunc_begin55
	.uleb128 Lfunc_end55-Ltmp648
	.byte	0
	.byte	0
Lcst_end55:
	.byte	1
	.byte	0
	.p2align	2, 0x0
	.long	0
Lttbase36:
	.p2align	2, 0x0

	.section	__TEXT,__const
l_anon.06e111bfef83652125d85ade023d82af.0:
	.ascii	"assertion failed: 0 < pointee_size && pointee_size <= isize::MAX as usize"

	.section	__TEXT,__cstring,cstring_literals
l_anon.06e111bfef83652125d85ade023d82af.1:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/non_null.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.2:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.1
	.asciz	"v\000\000\000\000\000\000\000\271\003\000\000 \000\000"

	.section	__TEXT,__literal16,16byte_literals
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.3:
	.asciz	"\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.4:
	.space	8
	.space	8

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.5:
	.quad	__ZN4core3ops8function6FnOnce9call_once17h9a2cf04c9b79e06eE

	.section	__TEXT,__cstring,cstring_literals
l_anon.06e111bfef83652125d85ade023d82af.6:
	.asciz	"/Users/kuangtalin/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/const-random-macro-0.1.16/src/lib.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.7:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\000\021\000\000\000\035\000\000"

	.section	__TEXT,__const
l_anon.06e111bfef83652125d85ade023d82af.8:
	.ascii	"u8"

l_anon.06e111bfef83652125d85ade023d82af.9:
	.ascii	"u16"

l_anon.06e111bfef83652125d85ade023d82af.10:
	.ascii	"u32"

l_anon.06e111bfef83652125d85ade023d82af.11:
	.ascii	"u64"

	.section	__TEXT,__literal4,4byte_literals
l_anon.06e111bfef83652125d85ade023d82af.12:
	.ascii	"u128"

	.section	__TEXT,__const
l_anon.06e111bfef83652125d85ade023d82af.13:
	.ascii	"i8"

l_anon.06e111bfef83652125d85ade023d82af.14:
	.ascii	"i16"

l_anon.06e111bfef83652125d85ade023d82af.15:
	.ascii	"i32"

l_anon.06e111bfef83652125d85ade023d82af.16:
	.ascii	"i64"

	.section	__TEXT,__literal4,4byte_literals
l_anon.06e111bfef83652125d85ade023d82af.17:
	.ascii	"i128"

	.section	__TEXT,__const
l_anon.06e111bfef83652125d85ade023d82af.18:
	.ascii	"usize"

l_anon.06e111bfef83652125d85ade023d82af.19:
	.ascii	"isize"

l_anon.06e111bfef83652125d85ade023d82af.20:
	.ascii	"[u8 ; "

l_anon.06e111bfef83652125d85ade023d82af.21:
	.ascii	"Invalid type"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.22:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\0007\000\000\000\016\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.23:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\000-\000\000\000!\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.24:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\000-\000\000\000A\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.25:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\0005\000\000\000J\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.26:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\000%\000\000\000\\\000\000"

	.section	__TEXT,__const
l_anon.06e111bfef83652125d85ade023d82af.27:
	.ascii	"as"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.28:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\000*\000\000\000L\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.29:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\000\035\000\000\000\\\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.30:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\000\"\000\000\000L\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.31:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\000\033\000\000\000I\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.32:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\000\032\000\000\000G\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.33:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\000\031\000\000\000G\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.34:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\000\030\000\000\000G\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.35:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\000\027\000\000\000E\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.36:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\000\026\000\000\000I\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.37:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\000\025\000\000\000G\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.38:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\000\024\000\000\000G\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.39:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\000\023\000\000\000G\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.40:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\000\022\000\000\000E\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.06e111bfef83652125d85ade023d82af.41:
	.asciz	"\300"

.zerofill __DATA,__bss,__ZN18const_random_macro4span4SEED17h567103d596ff29faE,8,3
l_anon.06e111bfef83652125d85ade023d82af.42:
	.asciz	"/Users/kuangtalin/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/const-random-macro-0.1.16/src/span.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.43:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.42
	.asciz	"l\000\000\000\000\000\000\000\023\000\000\000\007\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.44:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.42
	.asciz	"l\000\000\000\000\000\000\000\020\000\000\000.\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.45:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.6
	.asciz	"k\000\000\000\000\000\000\000\f\000\000\000;\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.06e111bfef83652125d85ade023d82af.46:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/io/error/repr_bitpacked.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.47:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.46
	.asciz	"\200\000\000\000\000\000\000\000\b\001\000\000\032\000\000"

	.section	__TEXT,__const
l_anon.06e111bfef83652125d85ade023d82af.48:
	.ascii	"internal error: entered unreachable code"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.49:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.46
	.asciz	"\200\000\000\000\000\000\000\000\031\001\000\000\r\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.06e111bfef83652125d85ade023d82af.50:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/thread/local.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.51:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.50
	.asciz	"u\000\000\000\000\000\000\000\254\001\000\000\031\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.52:
	.quad	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17ha9d9ccced2dc1daeE
	.asciz	"\030\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	__ZN58_$LT$alloc..string..String$u20$as$u20$core..fmt..Write$GT$9write_str17h754780582331f473E
	.quad	__ZN58_$LT$alloc..string..String$u20$as$u20$core..fmt..Write$GT$10write_char17h0a77be4d640bccc8E
	.quad	__ZN4core3fmt5Write9write_fmt17h374e6e1540f4fdd7E

	.section	__TEXT,__const
l_anon.06e111bfef83652125d85ade023d82af.53:
	.ascii	"a Display implementation returned an error unexpectedly"

	.section	__TEXT,__cstring,cstring_literals
l_anon.06e111bfef83652125d85ade023d82af.54:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/string.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.55:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.54
	.asciz	"q\000\000\000\000\000\000\000d\013\000\000\016\000\000"

	.section	__TEXT,__const
l_anon.06e111bfef83652125d85ade023d82af.56:
	.ascii	"proc_macro::bridge::client::Client<proc_macro::TokenStream, proc_macro::TokenStream>::expand1<const_random_macro::const_random>::{{closure}}"

	.section	__TEXT,__cstring,cstring_literals
l_anon.06e111bfef83652125d85ade023d82af.57:
	.asciz	"!mem::conjure_zst invoked on type \300\031, which is not zero-sized"

l_anon.06e111bfef83652125d85ade023d82af.58:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/mem/mod.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.59:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.58
	.asciz	"q\000\000\000\000\000\000\000\361\005\000\000\005\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.06e111bfef83652125d85ade023d82af.60:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num/mod.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.61:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.60
	.asciz	"q\000\000\000\000\000\000\000\006\007\000\000\001\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.06e111bfef83652125d85ade023d82af.62:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/str/mod.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.63:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.62
	.asciz	"q\000\000\000\000\000\000\000\212\001\000\000\r\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.06e111bfef83652125d85ade023d82af.64:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/char/methods.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.65:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.64
	.asciz	"v\000\000\000\000\000\000\000\032\b\000\000\t\000\000"

	.section	__TEXT,__const
l_anon.06e111bfef83652125d85ade023d82af.66:
	.asciz	"\022encode_utf8: need \300\023 bytes to encode U+\303 \000\000i\004\000\025 but buffer has just \300"

l_anon.06e111bfef83652125d85ade023d82af.67:
	.ascii	"to_digit: invalid radix -- radix must be in the range 2 to 36 inclusive"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.68:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.64
	.asciz	"v\000\000\000\000\000\000\000\223\001\000\000\t\000\000"

	.section	__TEXT,__literal8,8byte_literals
	.p2align	2, 0x0
l_anon.06e111bfef83652125d85ade023d82af.69:
	.space	4
	.space	4

	.section	__TEXT,__const
l_anon.06e111bfef83652125d85ade023d82af.70:
	.ascii	"unsafe precondition(s) violated: hint::unreachable_unchecked must never be reached\n\nThis indicates a bug in the program. This Undefined Behavior check is optional, and cannot be relied on for safety."

l_anon.06e111bfef83652125d85ade023d82af.71:
	.ascii	"there is no such thing as a release load"

	.section	__TEXT,__cstring,cstring_literals
l_anon.06e111bfef83652125d85ade023d82af.72:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/sync/atomic.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.73:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.72
	.asciz	"u\000\000\000\000\000\000\000C\017\000\000\030\000\000"

	.section	__TEXT,__const
l_anon.06e111bfef83652125d85ade023d82af.74:
	.ascii	"there is no such thing as an acquire-release load"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.75:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.72
	.asciz	"u\000\000\000\000\000\000\000D\017\000\000\027\000\000"

	.section	__TEXT,__const
l_anon.06e111bfef83652125d85ade023d82af.76:
	.ascii	"there is no such thing as a release failure ordering"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.77:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.72
	.asciz	"u\000\000\000\000\000\000\000\271\017\000\000\035\000\000"

	.section	__TEXT,__const
l_anon.06e111bfef83652125d85ade023d82af.78:
	.ascii	"there is no such thing as an acquire-release failure ordering"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.79:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.72
	.asciz	"u\000\000\000\000\000\000\000\270\017\000\000\034\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.80:
	.asciz	"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\000"
	.quad	__ZN53_$LT$core..fmt..Error$u20$as$u20$core..fmt..Debug$GT$3fmt17h14956214b7a8fd4bE

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.81:
	.asciz	"\000\000\000\000\000\000\000\000\004\000\000\000\000\000\000\000\004\000\000\000\000\000\000"
	.quad	__ZN60_$LT$getrandom..error..Error$u20$as$u20$core..fmt..Debug$GT$3fmt17h3b37fe14201a171aE

	.section	__TEXT,__const
l_anon.06e111bfef83652125d85ade023d82af.82:
	.ascii	"called `Result::unwrap()` on an `Err` value"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.83:
	.asciz	"\000\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\001\000\000\000\000\000\000"
	.quad	__ZN68_$LT$core..num..error..ParseIntError$u20$as$u20$core..fmt..Debug$GT$3fmt17he5923bd3b27e2c7bE

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.84:
	.quad	__ZN4core3ptr42drop_in_place$LT$std..io..error..Error$GT$17h0afc3805cbdcff76E
	.asciz	"\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	__RNvXNtNtCsaLOjE9VYtxK_3std2io5errorNtB2_5ErrorNtNtCs6sq8b9ugfBC_4core3fmt5Debug3fmt

	.section	__TEXT,__const
l_anon.06e111bfef83652125d85ade023d82af.85:
	.ascii	"Error"

	.section	__TEXT,__cstring,cstring_literals
l_anon.06e111bfef83652125d85ade023d82af.86:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/traits/exact_size.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.87:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.86
	.asciz	"\200\000\000\000\000\000\000\000z\000\000\000\t\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.06e111bfef83652125d85ade023d82af.88:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/proc_macro/src/bridge/rpc.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.89:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.88
	.asciz	"z\000\000\000\000\000\000\000o\000\000\000\001\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.90:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.88
	.asciz	"z\000\000\000\000\000\000\000\241\000\000\000\034\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.91:
	.asciz	"\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	__RNvXs1g_NtCs6sq8b9ugfBC_4core3fmtRNtNtNtB8_3num5error12IntErrorKindNtB6_5Debug3fmtCsiuEZD9hAKHK_14rustc_demangle

	.section	__TEXT,__const
l_anon.06e111bfef83652125d85ade023d82af.92:
	.ascii	"ParseIntError"

	.section	__TEXT,__literal4,4byte_literals
l_anon.06e111bfef83652125d85ade023d82af.93:
	.ascii	"kind"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.94:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.88
	.asciz	"z\000\000\000\000\000\000\000\212\000\000\000&\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.06e111bfef83652125d85ade023d82af.95:
	.asciz	"/Users/kuangtalin/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/getrandom-0.2.17/src/lib.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.96:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.95
	.asciz	"b\000\000\000\000\000\000\000\222\001\000\000\t\000\000"

	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.97:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.95
	.asciz	"b\000\000\000\000\000\000\000v\001\000\000\005\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.06e111bfef83652125d85ade023d82af.98:
	.asciz	"/Users/kuangtalin/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/once_cell-1.21.4/src/race.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.99:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.98
	.asciz	"c\000\000\000\000\000\000\000\317\001\000\000\027\000\000"

	.section	__TEXT,__const
l_anon.06e111bfef83652125d85ade023d82af.100:
	.ascii	"const_random"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.06e111bfef83652125d85ade023d82af.101:
	.asciz	"\002\000\000"
	.space	4
	.quad	l_anon.06e111bfef83652125d85ade023d82af.100
	.asciz	"\f\000\000\000\000\000\000"
	.quad	__RNvNtNtCs7B2A3P5pSWO_10proc_macro6bridge6client8COUNTERS
	.quad	__ZN10proc_macro6bridge14selfless_reify31reify_to_extern_c_fn_hrt_bridge7wrapper17h65b93c569d4f8f1cE
	.space	16

	.globl	___rustc_proc_macro_decls_baeb9b74640486f9__
	.p2align	3, 0x0
___rustc_proc_macro_decls_baeb9b74640486f9__:
	.quad	l_anon.06e111bfef83652125d85ade023d82af.101
	.asciz	"\001\000\000\000\000\000\000"

	.no_dead_strip	___rustc_proc_macro_decls_baeb9b74640486f9__
.subsections_via_symbols
