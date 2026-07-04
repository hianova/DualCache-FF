	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN105_$LT$std..ffi..os_str..OsString$u20$as$u20$core..ops..index..Index$LT$core..ops..range..RangeFull$GT$$GT$5index17h1dec72028b824705E:
	.cfi_startproc
	mov	x8, x0
	ldr	x0, [x8, #8]
	ldr	x1, [x8, #16]
	ret
	.cfi_endproc

	.private_extern	__ZN18build_script_build4main17hfbafbc7f444bf7e2E
	.globl	__ZN18build_script_build4main17hfbafbc7f444bf7e2E
	.p2align	2
__ZN18build_script_build4main17hfbafbc7f444bf7e2E:
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception0
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
	sub	sp, sp, #1472
	str	xzr, [sp]
	add	x8, sp, #608
	str	x8, [sp, #416]
	mov	w8, #128
	str	x8, [sp, #424]
	add	x8, sp, #464
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.0@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.0@PAGEOFF
	mov	w9, #7
	mov	x1, x9
	bl	__ZN3std3env3var17h4523c37eaf4fb264E
	ldr	x8, [sp, #464]
	tbz	w8, #0, LBB1_6
	b	LBB1_1
LBB1_1:
	ldr	x8, [sp, #416]
	add	x9, sp, #464
	ldur	q0, [x9, #8]
	sub	x2, x29, #64
	str	q0, [x8, #816]
	ldr	x8, [sp, #488]
	stur	x8, [x29, #-48]
Ltmp181:
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.31@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.31@PAGEOFF
	mov	w8, #43
	mov	x1, x8
	adrp	x3, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.32@PAGE
	add	x3, x3, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.32@PAGEOFF
	adrp	x4, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.2@PAGE
	add	x4, x4, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.2@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core6result13unwrap_failed
Ltmp182:
	b	LBB1_3
LBB1_2:
Ltmp183:
	stur	x0, [x29, #-32]
	mov	x8, x1
	stur	w8, [x29, #-24]
Ltmp184:
	sub	x0, x29, #64
	bl	__ZN4core3ptr39drop_in_place$LT$std..env..VarError$GT$17hba116970859ad9c9E
Ltmp185:
	b	LBB1_5
LBB1_3:
	brk	#0x1
LBB1_4:
Ltmp186:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB1_5:
	ldur	x8, [x29, #-32]
	str	x8, [sp, #408]
	b	LBB1_133
LBB1_6:
	add	x8, sp, #464
	ldur	q0, [x8, #8]
	add	x0, sp, #432
	str	q0, [sp, #432]
	ldr	x8, [sp, #488]
	str	x8, [sp, #448]
Ltmp0:
	bl	__ZN3std4path4Path3new17hf1746d9674677df3E
	str	x0, [sp, #392]
	str	x1, [sp, #400]
Ltmp1:
	b	LBB1_9
LBB1_7:
Ltmp178:
	add	x0, sp, #432
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp179:
	b	LBB1_132
LBB1_8:
Ltmp49:
	stur	x0, [x29, #-136]
	mov	x8, x1
	stur	w8, [x29, #-128]
	b	LBB1_7
LBB1_9:
Ltmp2:
	ldr	x1, [sp, #400]
	ldr	x0, [sp, #392]
	add	x8, sp, #496
	adrp	x2, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.3@PAGE
	add	x2, x2, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.3@PAGEOFF
	mov	w9, #6
	mov	x3, x9
	bl	__ZN3std4path4Path4join17h2bbc62d95d702e4fE
Ltmp3:
	b	LBB1_10
LBB1_10:
Ltmp4:
	add	x8, sp, #528
	add	x0, sp, #496
	bl	__ZN3std2fs4File6create17h62fae46325f3043aE
Ltmp5:
	b	LBB1_14
LBB1_11:
Ltmp176:
	add	x0, sp, #496
	bl	__ZN4core3ptr39drop_in_place$LT$std..path..PathBuf$GT$17hae9b7a203522e090E
Ltmp177:
	b	LBB1_7
LBB1_12:
Ltmp46:
	mov	x8, x1
	str	x0, [sp, #376]
	str	w8, [sp, #388]
	b	LBB1_13
LBB1_13:
	ldr	x9, [sp, #376]
	ldr	w8, [sp, #388]
	stur	x9, [x29, #-136]
	stur	w8, [x29, #-128]
	b	LBB1_11
LBB1_14:
	ldr	w8, [sp, #528]
	mov	x0, x8
	mov	x8, x0
	tbz	w8, #0, LBB1_20
	b	LBB1_15
LBB1_15:
	ldr	x8, [sp, #536]
	sub	x2, x29, #88
	stur	x8, [x29, #-88]
Ltmp170:
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.31@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.31@PAGEOFF
	mov	w8, #43
	mov	x1, x8
	adrp	x3, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.30@PAGE
	add	x3, x3, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.30@PAGEOFF
	adrp	x4, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.4@PAGE
	add	x4, x4, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.4@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core6result13unwrap_failed
Ltmp171:
	b	LBB1_17
LBB1_16:
Ltmp172:
	stur	x0, [x29, #-80]
	mov	x8, x1
	stur	w8, [x29, #-72]
Ltmp173:
	sub	x0, x29, #88
	bl	__ZN4core3ptr42drop_in_place$LT$std..io..error..Error$GT$17h33aedbd423127ae0E
Ltmp174:
	b	LBB1_19
LBB1_17:
	brk	#0x1
LBB1_18:
Ltmp175:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB1_19:
	ldur	x9, [x29, #-80]
	ldur	w8, [x29, #-72]
	str	x9, [sp, #376]
	str	w8, [sp, #388]
	b	LBB1_13
LBB1_20:
	ldr	w8, [sp, #532]
	str	w8, [sp, #372]
	b	LBB1_21
LBB1_21:
	ldr	w8, [sp, #372]
	str	w8, [sp, #524]
Ltmp6:
	add	x8, sp, #544
	bl	__ZN5alloc6string6String3new17h618dc60ffeaa7886E
Ltmp7:
	b	LBB1_24
LBB1_22:
Ltmp168:
	add	x0, sp, #524
	bl	__ZN4core3ptr34drop_in_place$LT$std..fs..File$GT$17heeba5f855ca527c8E
Ltmp169:
	b	LBB1_11
LBB1_23:
Ltmp43:
	stur	x0, [x29, #-136]
	mov	x8, x1
	stur	w8, [x29, #-128]
	b	LBB1_22
LBB1_24:
Ltmp8:
	add	x0, sp, #544
	adrp	x1, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.5@PAGE
	add	x1, x1, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.5@PAGEOFF
	mov	w8, #2255
	mov	x2, x8
	bl	__ZN5alloc6string6String8push_str17h4165badcca99a1bcE
Ltmp9:
	b	LBB1_28
LBB1_25:
Ltmp166:
	add	x0, sp, #544
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp167:
	b	LBB1_22
LBB1_26:
Ltmp165:
	mov	x8, x1
	str	x0, [sp, #360]
	str	w8, [sp, #368]
	b	LBB1_27
LBB1_27:
	ldr	x9, [sp, #360]
	ldr	w8, [sp, #368]
	stur	x9, [x29, #-136]
	stur	w8, [x29, #-128]
	b	LBB1_25
LBB1_28:
	ldr	x8, [sp, #424]
	add	x1, x8, #1
Ltmp10:
	mov	x0, #0
	bl	__ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17hecaf27c5c8cea0d8E
	str	x0, [sp, #344]
	str	x1, [sp, #352]
Ltmp11:
	b	LBB1_29
LBB1_29:
	ldr	x8, [sp, #352]
	ldr	x9, [sp, #344]
	str	x9, [sp, #568]
	str	x8, [sp, #576]
	b	LBB1_30
LBB1_30:
Ltmp12:
	add	x0, sp, #568
	bl	__ZN4core4iter5range101_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..Range$LT$A$GT$$GT$4next17h2c2ef1c40a3758c6E
	str	x0, [sp, #328]
	str	x1, [sp, #336]
Ltmp13:
	b	LBB1_31
LBB1_31:
	ldr	x8, [sp, #336]
	ldr	x9, [sp, #328]
	str	x9, [sp, #584]
	str	x8, [sp, #592]
	ldr	x8, [sp, #584]
	tbz	w8, #0, LBB1_33
	b	LBB1_32
LBB1_32:
	ldr	x8, [sp, #592]
	add	x0, sp, #600
	str	x8, [sp, #600]
Ltmp56:
	add	x8, sp, #672
	bl	__ZN4core3fmt2rt8Argument11new_display17hfd3b574cfa14ea57E
Ltmp57:
	b	LBB1_60
LBB1_33:
Ltmp14:
	add	x0, sp, #544
	adrp	x1, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.6@PAGE
	add	x1, x1, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.6@PAGEOFF
	mov	w8, #3
	mov	x2, x8
	bl	__ZN5alloc6string6String8push_str17h4165badcca99a1bcE
Ltmp15:
	b	LBB1_34
LBB1_34:
Ltmp16:
	sub	x8, x29, #192
	add	x0, sp, #424
	bl	__ZN4core3fmt2rt8Argument11new_display17hfd3b574cfa14ea57E
Ltmp17:
	b	LBB1_35
LBB1_35:
	ldr	x8, [sp, #416]
	ldr	q0, [x8, #688]
	sub	x1, x29, #208
	str	q0, [x8, #672]
Ltmp18:
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.7@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.7@PAGEOFF
	bl	__ZN4core3fmt9Arguments3new17haf466a730ae0ca26E
	str	x0, [sp, #312]
	str	x1, [sp, #320]
Ltmp19:
	b	LBB1_36
LBB1_36:
Ltmp20:
	ldr	x1, [sp, #320]
	ldr	x0, [sp, #312]
	sub	x8, x29, #232
	bl	__ZN5alloc3fmt6format17h2d5974586d515262E
Ltmp21:
	b	LBB1_37
LBB1_37:
	ldr	x8, [sp, #416]
	ldur	q0, [x29, #-232]
	str	q0, [x8, #624]
	ldur	x8, [x29, #-216]
	stur	x8, [x29, #-240]
	b	LBB1_38
LBB1_38:
Ltmp22:
	sub	x0, x29, #256
	bl	__ZN5alloc6string6String6as_str17h0cf478f5b5116b09E
	str	x0, [sp, #296]
	str	x1, [sp, #304]
Ltmp23:
	b	LBB1_41
LBB1_39:
Ltmp27:
	sub	x0, x29, #256
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp28:
	b	LBB1_25
LBB1_40:
Ltmp26:
	stur	x0, [x29, #-136]
	mov	x8, x1
	stur	w8, [x29, #-128]
	b	LBB1_39
LBB1_41:
Ltmp24:
	ldr	x2, [sp, #304]
	ldr	x1, [sp, #296]
	add	x0, sp, #544
	bl	__ZN5alloc6string6String8push_str17h4165badcca99a1bcE
Ltmp25:
	b	LBB1_42
LBB1_42:
Ltmp29:
	sub	x0, x29, #256
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp30:
	b	LBB1_43
LBB1_43:
Ltmp31:
	add	x0, sp, #544
	bl	__ZN5alloc6string6String8as_bytes17ha05cc3ee3af7c996E
	str	x0, [sp, #280]
	str	x1, [sp, #288]
Ltmp32:
	b	LBB1_44
LBB1_44:
Ltmp33:
	ldr	x2, [sp, #288]
	ldr	x1, [sp, #280]
	add	x0, sp, #524
	bl	__ZN3std2io5Write9write_all17he2af938b88c9d5c0E
	str	x0, [sp, #272]
Ltmp34:
	b	LBB1_45
LBB1_45:
	ldr	x8, [sp, #272]
	stur	x8, [x29, #-120]
	ldur	x8, [x29, #-120]
	subs	x8, x8, #0
	cset	x8, ne
	tbz	w8, #0, LBB1_51
	b	LBB1_46
LBB1_46:
	ldur	x8, [x29, #-120]
	sub	x2, x29, #112
	stur	x8, [x29, #-112]
Ltmp50:
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.31@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.31@PAGEOFF
	mov	w8, #43
	mov	x1, x8
	adrp	x3, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.30@PAGE
	add	x3, x3, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.30@PAGEOFF
	adrp	x4, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.8@PAGE
	add	x4, x4, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.8@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core6result13unwrap_failed
Ltmp51:
	b	LBB1_48
LBB1_47:
Ltmp52:
	stur	x0, [x29, #-104]
	mov	x8, x1
	stur	w8, [x29, #-96]
Ltmp53:
	sub	x0, x29, #112
	bl	__ZN4core3ptr42drop_in_place$LT$std..io..error..Error$GT$17h33aedbd423127ae0E
Ltmp54:
	b	LBB1_50
LBB1_48:
	brk	#0x1
LBB1_49:
Ltmp55:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB1_50:
	ldur	x9, [x29, #-104]
	ldur	w8, [x29, #-96]
	str	x9, [sp, #360]
	str	w8, [sp, #368]
	b	LBB1_27
LBB1_51:
	b	LBB1_52
LBB1_52:
Ltmp35:
	sub	x8, x29, #152
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.9@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.9@PAGEOFF
	bl	__ZN4core3fmt2rt8Argument11new_display17h56f40c4b7916910fE
Ltmp36:
	b	LBB1_53
LBB1_53:
	ldr	x8, [sp, #416]
	ldur	q0, [x29, #-152]
	sub	x1, x29, #176
	str	q0, [x8, #704]
Ltmp37:
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.10@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.10@PAGEOFF
	bl	__ZN4core3fmt9Arguments3new17h41657b20bcb6b6c1E
	str	x0, [sp, #256]
	str	x1, [sp, #264]
Ltmp38:
	b	LBB1_54
LBB1_54:
Ltmp39:
	ldr	x1, [sp, #264]
	ldr	x0, [sp, #256]
	bl	__RNvNtNtCsaLOjE9VYtxK_3std2io5stdio6__print
Ltmp40:
	b	LBB1_55
LBB1_55:
Ltmp41:
	add	x0, sp, #544
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp42:
	b	LBB1_56
LBB1_56:
Ltmp44:
	add	x0, sp, #524
	bl	__ZN4core3ptr34drop_in_place$LT$std..fs..File$GT$17heeba5f855ca527c8E
Ltmp45:
	b	LBB1_57
LBB1_57:
Ltmp47:
	add	x0, sp, #496
	bl	__ZN4core3ptr39drop_in_place$LT$std..path..PathBuf$GT$17hae9b7a203522e090E
Ltmp48:
	b	LBB1_58
LBB1_58:
	add	x0, sp, #432
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
	add	sp, sp, #1472
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	ldp	x28, x27, [sp], #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w27
	.cfi_restore w28
	ret
LBB1_59:
	.cfi_restore_state
Ltmp180:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB1_60:
	ldr	x8, [sp, #416]
	ldr	q0, [x8, #64]
	add	x1, sp, #656
	str	q0, [x8, #48]
Ltmp58:
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.11@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.11@PAGEOFF
	bl	__ZN4core3fmt9Arguments3new17h41657b20bcb6b6c1E
	str	x0, [sp, #240]
	str	x1, [sp, #248]
Ltmp59:
	b	LBB1_61
LBB1_61:
Ltmp60:
	ldr	x1, [sp, #248]
	ldr	x0, [sp, #240]
	add	x8, sp, #632
	bl	__ZN5alloc3fmt6format17h2d5974586d515262E
Ltmp61:
	b	LBB1_62
LBB1_62:
	ldr	x8, [sp, #416]
	add	x9, sp, #377
	ldur	q0, [x9, #255]
	str	q0, [x8]
	ldr	x8, [sp, #648]
	str	x8, [sp, #624]
	b	LBB1_63
LBB1_63:
Ltmp62:
	add	x0, sp, #608
	bl	__ZN5alloc6string6String6as_str17h0cf478f5b5116b09E
	str	x0, [sp, #224]
	str	x1, [sp, #232]
Ltmp63:
	b	LBB1_66
LBB1_64:
Ltmp67:
	add	x0, sp, #608
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp68:
	b	LBB1_25
LBB1_65:
Ltmp66:
	stur	x0, [x29, #-136]
	mov	x8, x1
	stur	w8, [x29, #-128]
	b	LBB1_64
LBB1_66:
Ltmp64:
	ldr	x2, [sp, #232]
	ldr	x1, [sp, #224]
	add	x0, sp, #544
	bl	__ZN5alloc6string6String8push_str17h4165badcca99a1bcE
Ltmp65:
	b	LBB1_67
LBB1_67:
Ltmp69:
	add	x0, sp, #608
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp70:
	b	LBB1_68
LBB1_68:
	ldr	x8, [sp, #600]
	subs	x8, x8, #16
	b.ls	LBB1_70
	b	LBB1_69
LBB1_69:
	b	LBB1_71
LBB1_70:
Ltmp131:
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.15@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.15@PAGEOFF
	mov	w8, #37
	mov	x1, x8
	bl	__ZN4core3fmt9Arguments8from_str17h56a71a49753358d3E
	str	x0, [sp, #208]
	str	x1, [sp, #216]
Ltmp132:
	b	LBB1_111
LBB1_71:
	ldr	x8, [sp, #600]
	mov	w9, #2
	udiv	x8, x8, x9
	str	x8, [sp, #872]
	b	LBB1_72
LBB1_72:
	ldr	x8, [sp, #600]
	mov	w9, #2
	mov	x10, x9
	udiv	x9, x8, x10
	mul	x9, x9, x10
	subs	x8, x8, x9
	cbz	x8, LBB1_74
	b	LBB1_73
LBB1_73:
	ldr	x8, [sp, #872]
	subs	x8, x8, #1
	b.hi	LBB1_76
	b	LBB1_75
LBB1_74:
Ltmp101:
	add	x8, sp, #944
	add	x0, sp, #872
	bl	__ZN4core3fmt2rt8Argument11new_display17hfd3b574cfa14ea57E
Ltmp102:
	b	LBB1_94
LBB1_75:
	ldr	x8, [sp, #600]
	subs	x8, x8, #1
	add	x0, sp, #1192
	str	x8, [sp, #1192]
Ltmp86:
	add	x8, sp, #1216
	bl	__ZN4core3fmt2rt8Argument11new_display17hfd3b574cfa14ea57E
Ltmp87:
	b	LBB1_85
LBB1_76:
	ldr	x8, [sp, #600]
	subs	x8, x8, #1
	add	x0, sp, #1096
	str	x8, [sp, #1096]
Ltmp71:
	add	x8, sp, #1120
	bl	__ZN4core3fmt2rt8Argument11new_display17hfd3b574cfa14ea57E
Ltmp72:
	b	LBB1_77
LBB1_77:
	ldr	x8, [sp, #416]
	ldr	q0, [x8, #512]
	add	x1, sp, #1104
	str	q0, [x8, #496]
Ltmp73:
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.12@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.12@PAGEOFF
	bl	__ZN4core3fmt9Arguments3new17h4cf8688980ecc875E
	str	x0, [sp, #192]
	str	x1, [sp, #200]
Ltmp74:
	b	LBB1_78
LBB1_78:
Ltmp75:
	ldr	x1, [sp, #200]
	ldr	x0, [sp, #192]
	add	x8, sp, #1072
	bl	__ZN5alloc3fmt6format17h2d5974586d515262E
Ltmp76:
	b	LBB1_79
LBB1_79:
	ldr	x8, [sp, #416]
	ldr	q0, [x8, #464]
	str	q0, [x8, #432]
	ldr	x8, [sp, #1088]
	str	x8, [sp, #1056]
	b	LBB1_80
LBB1_80:
Ltmp77:
	add	x0, sp, #1040
	bl	__ZN5alloc6string6String6as_str17h0cf478f5b5116b09E
	str	x0, [sp, #176]
	str	x1, [sp, #184]
Ltmp78:
	b	LBB1_83
LBB1_81:
Ltmp82:
	add	x0, sp, #1040
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp83:
	b	LBB1_25
LBB1_82:
Ltmp81:
	stur	x0, [x29, #-136]
	mov	x8, x1
	stur	w8, [x29, #-128]
	b	LBB1_81
LBB1_83:
Ltmp79:
	ldr	x2, [sp, #184]
	ldr	x1, [sp, #176]
	add	x0, sp, #544
	bl	__ZN5alloc6string6String8push_str17h4165badcca99a1bcE
Ltmp80:
	b	LBB1_84
LBB1_84:
Ltmp84:
	add	x0, sp, #1040
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp85:
	b	LBB1_75
LBB1_85:
	ldr	x8, [sp, #416]
	ldr	q0, [x8, #608]
	add	x1, sp, #1200
	str	q0, [x8, #592]
Ltmp88:
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.13@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.13@PAGEOFF
	bl	__ZN4core3fmt9Arguments3new17h58460f2d671fc7daE
	str	x0, [sp, #160]
	str	x1, [sp, #168]
Ltmp89:
	b	LBB1_86
LBB1_86:
Ltmp90:
	ldr	x1, [sp, #168]
	ldr	x0, [sp, #160]
	add	x8, sp, #1168
	bl	__ZN5alloc3fmt6format17h2d5974586d515262E
Ltmp91:
	b	LBB1_87
LBB1_87:
	ldr	x8, [sp, #416]
	ldr	q0, [x8, #560]
	str	q0, [x8, #528]
	ldr	x8, [sp, #1184]
	str	x8, [sp, #1152]
	b	LBB1_88
LBB1_88:
Ltmp92:
	add	x0, sp, #1136
	bl	__ZN5alloc6string6String6as_str17h0cf478f5b5116b09E
	str	x0, [sp, #144]
	str	x1, [sp, #152]
Ltmp93:
	b	LBB1_91
LBB1_89:
Ltmp97:
	add	x0, sp, #1136
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp98:
	b	LBB1_25
LBB1_90:
Ltmp96:
	stur	x0, [x29, #-136]
	mov	x8, x1
	stur	w8, [x29, #-128]
	b	LBB1_89
LBB1_91:
Ltmp94:
	ldr	x2, [sp, #152]
	ldr	x1, [sp, #144]
	add	x0, sp, #544
	bl	__ZN5alloc6string6String8push_str17h4165badcca99a1bcE
Ltmp95:
	b	LBB1_92
LBB1_92:
Ltmp99:
	add	x0, sp, #1136
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp100:
	b	LBB1_93
LBB1_93:
Ltmp148:
	add	x0, sp, #544
	adrp	x1, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.16@PAGE
	add	x1, x1, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.16@PAGEOFF
	mov	w8, #8
	mov	x2, x8
	bl	__ZN5alloc6string6String8push_str17h4165badcca99a1bcE
Ltmp149:
	b	LBB1_123
LBB1_94:
	ldr	x8, [sp, #416]
	ldr	q0, [x8, #336]
	add	x1, sp, #928
	str	q0, [x8, #320]
Ltmp103:
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.12@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.12@PAGEOFF
	bl	__ZN4core3fmt9Arguments3new17h4cf8688980ecc875E
	str	x0, [sp, #128]
	str	x1, [sp, #136]
Ltmp104:
	b	LBB1_95
LBB1_95:
Ltmp105:
	ldr	x1, [sp, #136]
	ldr	x0, [sp, #128]
	add	x8, sp, #904
	bl	__ZN5alloc3fmt6format17h2d5974586d515262E
Ltmp106:
	b	LBB1_96
LBB1_96:
	ldr	x8, [sp, #416]
	add	x9, sp, #649
	ldur	q0, [x9, #255]
	str	q0, [x8, #272]
	ldr	x8, [sp, #920]
	str	x8, [sp, #896]
	b	LBB1_97
LBB1_97:
Ltmp107:
	add	x0, sp, #880
	bl	__ZN5alloc6string6String6as_str17h0cf478f5b5116b09E
	str	x0, [sp, #112]
	str	x1, [sp, #120]
Ltmp108:
	b	LBB1_100
LBB1_98:
Ltmp112:
	add	x0, sp, #880
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp113:
	b	LBB1_25
LBB1_99:
Ltmp111:
	stur	x0, [x29, #-136]
	mov	x8, x1
	stur	w8, [x29, #-128]
	b	LBB1_98
LBB1_100:
Ltmp109:
	ldr	x2, [sp, #120]
	ldr	x1, [sp, #112]
	add	x0, sp, #544
	bl	__ZN5alloc6string6String8push_str17h4165badcca99a1bcE
Ltmp110:
	b	LBB1_101
LBB1_101:
Ltmp114:
	add	x0, sp, #880
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp115:
	b	LBB1_102
LBB1_102:
Ltmp116:
	add	x8, sp, #1024
	add	x0, sp, #872
	bl	__ZN4core3fmt2rt8Argument11new_display17hfd3b574cfa14ea57E
Ltmp117:
	b	LBB1_103
LBB1_103:
	ldr	x8, [sp, #416]
	ldr	q0, [x8, #416]
	add	x1, sp, #1008
	str	q0, [x8, #400]
Ltmp118:
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.14@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.14@PAGEOFF
	bl	__ZN4core3fmt9Arguments3new17hfef86bc8b893a5afE
	str	x0, [sp, #96]
	str	x1, [sp, #104]
Ltmp119:
	b	LBB1_104
LBB1_104:
Ltmp120:
	ldr	x1, [sp, #104]
	ldr	x0, [sp, #96]
	add	x8, sp, #984
	bl	__ZN5alloc3fmt6format17h2d5974586d515262E
Ltmp121:
	b	LBB1_105
LBB1_105:
	ldr	x8, [sp, #416]
	add	x9, sp, #729
	ldur	q0, [x9, #255]
	str	q0, [x8, #352]
	ldr	x8, [sp, #1000]
	str	x8, [sp, #976]
	b	LBB1_106
LBB1_106:
Ltmp122:
	add	x0, sp, #960
	bl	__ZN5alloc6string6String6as_str17h0cf478f5b5116b09E
	str	x0, [sp, #80]
	str	x1, [sp, #88]
Ltmp123:
	b	LBB1_109
LBB1_107:
Ltmp127:
	add	x0, sp, #960
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp128:
	b	LBB1_25
LBB1_108:
Ltmp126:
	stur	x0, [x29, #-136]
	mov	x8, x1
	stur	w8, [x29, #-128]
	b	LBB1_107
LBB1_109:
Ltmp124:
	ldr	x2, [sp, #88]
	ldr	x1, [sp, #80]
	add	x0, sp, #544
	bl	__ZN5alloc6string6String8push_str17h4165badcca99a1bcE
Ltmp125:
	b	LBB1_110
LBB1_110:
Ltmp129:
	add	x0, sp, #960
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp130:
	b	LBB1_93
LBB1_111:
Ltmp133:
	ldr	x1, [sp, #216]
	ldr	x0, [sp, #208]
	add	x8, sp, #720
	bl	__ZN5alloc3fmt6format17h2d5974586d515262E
Ltmp134:
	b	LBB1_112
LBB1_112:
	ldr	x8, [sp, #416]
	ldr	q0, [x8, #112]
	str	q0, [x8, #80]
	ldr	x8, [sp, #736]
	str	x8, [sp, #704]
	b	LBB1_113
LBB1_113:
Ltmp135:
	add	x0, sp, #688
	bl	__ZN5alloc6string6String6as_str17h0cf478f5b5116b09E
	str	x0, [sp, #64]
	str	x1, [sp, #72]
Ltmp136:
	b	LBB1_116
LBB1_114:
Ltmp140:
	add	x0, sp, #688
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp141:
	b	LBB1_25
LBB1_115:
Ltmp139:
	stur	x0, [x29, #-136]
	mov	x8, x1
	stur	w8, [x29, #-128]
	b	LBB1_114
LBB1_116:
Ltmp137:
	ldr	x2, [sp, #72]
	ldr	x1, [sp, #64]
	add	x0, sp, #544
	bl	__ZN5alloc6string6String8push_str17h4165badcca99a1bcE
Ltmp138:
	b	LBB1_117
LBB1_117:
Ltmp142:
	add	x0, sp, #688
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp143:
	b	LBB1_118
LBB1_118:
	ldr	x1, [sp, #600]
Ltmp144:
	mov	w8, #1
	mov	x0, x8
	bl	__ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17hecaf27c5c8cea0d8E
	str	x0, [sp, #48]
	str	x1, [sp, #56]
Ltmp145:
	b	LBB1_119
LBB1_119:
	ldr	x8, [sp, #56]
	ldr	x9, [sp, #48]
	str	x9, [sp, #744]
	str	x8, [sp, #752]
	b	LBB1_120
LBB1_120:
Ltmp146:
	add	x0, sp, #744
	bl	__ZN4core4iter5range101_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..Range$LT$A$GT$$GT$4next17h2c2ef1c40a3758c6E
	str	x0, [sp, #32]
	str	x1, [sp, #40]
Ltmp147:
	b	LBB1_121
LBB1_121:
	ldr	x8, [sp, #40]
	ldr	x9, [sp, #32]
	str	x9, [sp, #760]
	str	x8, [sp, #768]
	ldr	x8, [sp, #760]
	tbz	w8, #0, LBB1_93
	b	LBB1_122
LBB1_122:
	ldr	x8, [sp, #768]
	add	x0, sp, #776
	str	x8, [sp, #776]
Ltmp150:
	add	x8, sp, #856
	bl	__ZN4core3fmt2rt8Argument11new_display17hfd3b574cfa14ea57E
Ltmp151:
	b	LBB1_124
LBB1_123:
	b	LBB1_30
LBB1_124:
	ldr	x8, [sp, #416]
	add	x9, sp, #601
	ldur	q0, [x9, #255]
	add	x1, sp, #832
	str	q0, [x8, #224]
Ltmp152:
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.13@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.13@PAGEOFF
	bl	__ZN4core3fmt9Arguments3new17h58460f2d671fc7daE
	str	x0, [sp, #16]
	str	x1, [sp, #24]
Ltmp153:
	b	LBB1_125
LBB1_125:
Ltmp154:
	ldr	x1, [sp, #24]
	ldr	x0, [sp, #16]
	add	x8, sp, #808
	bl	__ZN5alloc3fmt6format17h2d5974586d515262E
Ltmp155:
	b	LBB1_126
LBB1_126:
	ldr	x8, [sp, #416]
	add	x9, sp, #553
	ldur	q0, [x9, #255]
	str	q0, [x8, #176]
	ldr	x8, [sp, #824]
	str	x8, [sp, #800]
	b	LBB1_127
LBB1_127:
Ltmp156:
	add	x0, sp, #784
	bl	__ZN5alloc6string6String6as_str17h0cf478f5b5116b09E
	str	x0, [sp]
	str	x1, [sp, #8]
Ltmp157:
	b	LBB1_130
LBB1_128:
Ltmp161:
	add	x0, sp, #784
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp162:
	b	LBB1_25
LBB1_129:
Ltmp160:
	stur	x0, [x29, #-136]
	mov	x8, x1
	stur	w8, [x29, #-128]
	b	LBB1_128
LBB1_130:
Ltmp158:
	ldr	x2, [sp, #8]
	ldr	x1, [sp]
	add	x0, sp, #544
	bl	__ZN5alloc6string6String8push_str17h4165badcca99a1bcE
Ltmp159:
	b	LBB1_131
LBB1_131:
Ltmp163:
	add	x0, sp, #784
	bl	__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E
Ltmp164:
	b	LBB1_120
LBB1_132:
	ldur	x8, [x29, #-136]
	str	x8, [sp, #408]
	b	LBB1_133
LBB1_133:
	ldr	x0, [sp, #408]
	bl	__Unwind_Resume
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table1:
Lexception0:
	.byte	255
	.byte	155
	.uleb128 Lttbase0-Lttbaseref0
Lttbaseref0:
	.byte	1
	.uleb128 Lcst_end0-Lcst_begin0
Lcst_begin0:
	.uleb128 Lfunc_begin0-Lfunc_begin0
	.uleb128 Ltmp181-Lfunc_begin0
	.byte	0
	.byte	0
	.uleb128 Ltmp181-Lfunc_begin0
	.uleb128 Ltmp182-Ltmp181
	.uleb128 Ltmp183-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp184-Lfunc_begin0
	.uleb128 Ltmp185-Ltmp184
	.uleb128 Ltmp186-Lfunc_begin0
	.byte	1
	.uleb128 Ltmp0-Lfunc_begin0
	.uleb128 Ltmp1-Ltmp0
	.uleb128 Ltmp49-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp178-Lfunc_begin0
	.uleb128 Ltmp179-Ltmp178
	.uleb128 Ltmp180-Lfunc_begin0
	.byte	1
	.uleb128 Ltmp2-Lfunc_begin0
	.uleb128 Ltmp3-Ltmp2
	.uleb128 Ltmp49-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp4-Lfunc_begin0
	.uleb128 Ltmp5-Ltmp4
	.uleb128 Ltmp46-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp176-Lfunc_begin0
	.uleb128 Ltmp177-Ltmp176
	.uleb128 Ltmp180-Lfunc_begin0
	.byte	1
	.uleb128 Ltmp170-Lfunc_begin0
	.uleb128 Ltmp171-Ltmp170
	.uleb128 Ltmp172-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp173-Lfunc_begin0
	.uleb128 Ltmp174-Ltmp173
	.uleb128 Ltmp175-Lfunc_begin0
	.byte	5
	.uleb128 Ltmp6-Lfunc_begin0
	.uleb128 Ltmp7-Ltmp6
	.uleb128 Ltmp43-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp168-Lfunc_begin0
	.uleb128 Ltmp169-Ltmp168
	.uleb128 Ltmp180-Lfunc_begin0
	.byte	1
	.uleb128 Ltmp8-Lfunc_begin0
	.uleb128 Ltmp9-Ltmp8
	.uleb128 Ltmp165-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp166-Lfunc_begin0
	.uleb128 Ltmp167-Ltmp166
	.uleb128 Ltmp180-Lfunc_begin0
	.byte	1
	.uleb128 Ltmp10-Lfunc_begin0
	.uleb128 Ltmp21-Ltmp10
	.uleb128 Ltmp165-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp22-Lfunc_begin0
	.uleb128 Ltmp23-Ltmp22
	.uleb128 Ltmp26-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp27-Lfunc_begin0
	.uleb128 Ltmp28-Ltmp27
	.uleb128 Ltmp180-Lfunc_begin0
	.byte	1
	.uleb128 Ltmp24-Lfunc_begin0
	.uleb128 Ltmp25-Ltmp24
	.uleb128 Ltmp26-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp29-Lfunc_begin0
	.uleb128 Ltmp34-Ltmp29
	.uleb128 Ltmp165-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp50-Lfunc_begin0
	.uleb128 Ltmp51-Ltmp50
	.uleb128 Ltmp52-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp53-Lfunc_begin0
	.uleb128 Ltmp54-Ltmp53
	.uleb128 Ltmp55-Lfunc_begin0
	.byte	5
	.uleb128 Ltmp35-Lfunc_begin0
	.uleb128 Ltmp40-Ltmp35
	.uleb128 Ltmp165-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp41-Lfunc_begin0
	.uleb128 Ltmp42-Ltmp41
	.uleb128 Ltmp43-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp44-Lfunc_begin0
	.uleb128 Ltmp45-Ltmp44
	.uleb128 Ltmp46-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp47-Lfunc_begin0
	.uleb128 Ltmp48-Ltmp47
	.uleb128 Ltmp49-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp48-Lfunc_begin0
	.uleb128 Ltmp58-Ltmp48
	.byte	0
	.byte	0
	.uleb128 Ltmp58-Lfunc_begin0
	.uleb128 Ltmp61-Ltmp58
	.uleb128 Ltmp165-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp62-Lfunc_begin0
	.uleb128 Ltmp63-Ltmp62
	.uleb128 Ltmp66-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp67-Lfunc_begin0
	.uleb128 Ltmp68-Ltmp67
	.uleb128 Ltmp180-Lfunc_begin0
	.byte	1
	.uleb128 Ltmp64-Lfunc_begin0
	.uleb128 Ltmp65-Ltmp64
	.uleb128 Ltmp66-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp69-Lfunc_begin0
	.uleb128 Ltmp76-Ltmp69
	.uleb128 Ltmp165-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp77-Lfunc_begin0
	.uleb128 Ltmp78-Ltmp77
	.uleb128 Ltmp81-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp82-Lfunc_begin0
	.uleb128 Ltmp83-Ltmp82
	.uleb128 Ltmp180-Lfunc_begin0
	.byte	1
	.uleb128 Ltmp79-Lfunc_begin0
	.uleb128 Ltmp80-Ltmp79
	.uleb128 Ltmp81-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp84-Lfunc_begin0
	.uleb128 Ltmp91-Ltmp84
	.uleb128 Ltmp165-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp92-Lfunc_begin0
	.uleb128 Ltmp93-Ltmp92
	.uleb128 Ltmp96-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp97-Lfunc_begin0
	.uleb128 Ltmp98-Ltmp97
	.uleb128 Ltmp180-Lfunc_begin0
	.byte	1
	.uleb128 Ltmp94-Lfunc_begin0
	.uleb128 Ltmp95-Ltmp94
	.uleb128 Ltmp96-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp99-Lfunc_begin0
	.uleb128 Ltmp106-Ltmp99
	.uleb128 Ltmp165-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp107-Lfunc_begin0
	.uleb128 Ltmp108-Ltmp107
	.uleb128 Ltmp111-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp112-Lfunc_begin0
	.uleb128 Ltmp113-Ltmp112
	.uleb128 Ltmp180-Lfunc_begin0
	.byte	1
	.uleb128 Ltmp109-Lfunc_begin0
	.uleb128 Ltmp110-Ltmp109
	.uleb128 Ltmp111-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp114-Lfunc_begin0
	.uleb128 Ltmp121-Ltmp114
	.uleb128 Ltmp165-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp122-Lfunc_begin0
	.uleb128 Ltmp123-Ltmp122
	.uleb128 Ltmp126-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp127-Lfunc_begin0
	.uleb128 Ltmp128-Ltmp127
	.uleb128 Ltmp180-Lfunc_begin0
	.byte	1
	.uleb128 Ltmp124-Lfunc_begin0
	.uleb128 Ltmp125-Ltmp124
	.uleb128 Ltmp126-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp129-Lfunc_begin0
	.uleb128 Ltmp134-Ltmp129
	.uleb128 Ltmp165-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp135-Lfunc_begin0
	.uleb128 Ltmp136-Ltmp135
	.uleb128 Ltmp139-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp140-Lfunc_begin0
	.uleb128 Ltmp141-Ltmp140
	.uleb128 Ltmp180-Lfunc_begin0
	.byte	1
	.uleb128 Ltmp137-Lfunc_begin0
	.uleb128 Ltmp138-Ltmp137
	.uleb128 Ltmp139-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp142-Lfunc_begin0
	.uleb128 Ltmp155-Ltmp142
	.uleb128 Ltmp165-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp156-Lfunc_begin0
	.uleb128 Ltmp157-Ltmp156
	.uleb128 Ltmp160-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp161-Lfunc_begin0
	.uleb128 Ltmp162-Ltmp161
	.uleb128 Ltmp180-Lfunc_begin0
	.byte	1
	.uleb128 Ltmp158-Lfunc_begin0
	.uleb128 Ltmp159-Ltmp158
	.uleb128 Ltmp160-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp163-Lfunc_begin0
	.uleb128 Ltmp164-Ltmp163
	.uleb128 Ltmp165-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp164-Lfunc_begin0
	.uleb128 Lfunc_end0-Ltmp164
	.byte	0
	.byte	0
Lcst_end0:
	.byte	127
	.byte	0
	.byte	0
	.byte	0
	.byte	127
	.byte	125
	.p2align	2, 0x0
Lttbase0:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN3std2fs11OpenOptions4open17h2c03b6ee5c6bac57E:
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception1
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x8, [sp]
	str	x0, [sp, #8]
	add	x0, sp, #32
	str	x1, [sp, #32]
	str	x2, [sp, #40]
Ltmp187:
	bl	__ZN55_$LT$$RF$T$u20$as$u20$core..convert..AsRef$LT$U$GT$$GT$6as_ref17h95e7d33ff2ae0a4aE
	str	x0, [sp, #16]
	str	x1, [sp, #24]
Ltmp188:
	b	LBB2_3
LBB2_1:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB2_2:
Ltmp191:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB2_1
LBB2_3:
Ltmp189:
	ldr	x2, [sp, #24]
	ldr	x1, [sp, #16]
	ldr	x0, [sp, #8]
	ldr	x8, [sp]
	bl	__RNvMsl_NtCsaLOjE9VYtxK_3std2fsNtB5_11OpenOptions5__open
Ltmp190:
	b	LBB2_4
LBB2_4:
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table2:
Lexception1:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Ltmp187-Lfunc_begin1
	.uleb128 Ltmp188-Ltmp187
	.uleb128 Ltmp191-Lfunc_begin1
	.byte	0
	.uleb128 Ltmp188-Lfunc_begin1
	.uleb128 Ltmp189-Ltmp188
	.byte	0
	.byte	0
	.uleb128 Ltmp189-Lfunc_begin1
	.uleb128 Ltmp190-Ltmp189
	.uleb128 Ltmp191-Lfunc_begin1
	.byte	0
Lcst_end1:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN3std2fs4File6create17h62fae46325f3043aE:
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception2
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	stp	x29, x30, [sp, #80]
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x8, [sp, #8]
	mov	x8, x0
	add	x0, sp, #32
	str	x8, [sp, #32]
	sturb	wzr, [x29, #-22]
	sturb	wzr, [x29, #-21]
	sturb	wzr, [x29, #-20]
	sturb	wzr, [x29, #-19]
	sturb	wzr, [x29, #-18]
	sturb	wzr, [x29, #-17]
	stur	wzr, [x29, #-28]
	mov	w8, #438
	sturh	w8, [x29, #-24]
	ldur	x8, [x29, #-28]
	str	x8, [sp, #40]
	ldur	w8, [x29, #-20]
	str	w8, [sp, #48]
	mov	w8, #1
	strb	w8, [sp, #47]
	strb	w8, [sp, #50]
	strb	w8, [sp, #49]
Ltmp192:
	bl	__ZN55_$LT$$RF$T$u20$as$u20$core..convert..AsRef$LT$U$GT$$GT$6as_ref17h04a4781749bf881bE
	str	x0, [sp, #16]
	str	x1, [sp, #24]
Ltmp193:
	b	LBB3_3
LBB3_1:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB3_2:
Ltmp196:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB3_1
LBB3_3:
Ltmp194:
	ldr	x2, [sp, #24]
	ldr	x1, [sp, #16]
	ldr	x8, [sp, #8]
	add	x0, sp, #40
	bl	__ZN3std2fs11OpenOptions4open17h2c03b6ee5c6bac57E
Ltmp195:
	b	LBB3_4
LBB3_4:
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table3:
Lexception2:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Ltmp192-Lfunc_begin2
	.uleb128 Ltmp193-Ltmp192
	.uleb128 Ltmp196-Lfunc_begin2
	.byte	0
	.uleb128 Ltmp193-Lfunc_begin2
	.uleb128 Ltmp194-Ltmp193
	.byte	0
	.byte	0
	.uleb128 Ltmp194-Lfunc_begin2
	.uleb128 Ltmp195-Ltmp194
	.uleb128 Ltmp196-Lfunc_begin2
	.byte	0
Lcst_end2:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN3std2io5Write9write_all17he2af938b88c9d5c0E:
Lfunc_begin3:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception3
	sub	sp, sp, #128
	.cfi_def_cfa_offset 128
	stp	x29, x30, [sp, #112]
	add	x29, sp, #112
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #24]
	str	x1, [sp, #32]
	str	x2, [sp, #40]
	b	LBB4_1
LBB4_1:
	ldr	x8, [sp, #40]
	cbnz	x8, LBB4_3
	b	LBB4_2
LBB4_2:
	str	xzr, [sp, #48]
	b	LBB4_4
LBB4_3:
	ldr	x0, [sp, #24]
	ldr	x1, [sp, #32]
	ldr	x2, [sp, #40]
	bl	__RNvXsb_NtCsaLOjE9VYtxK_3std2fsNtB5_4FileNtNtB7_2io5Write5write
	str	x0, [sp, #56]
	str	x1, [sp, #64]
	ldr	x8, [sp, #56]
	tbnz	w8, #0, LBB4_5
	b	LBB4_6
LBB4_4:
	ldr	x0, [sp, #48]
	.cfi_def_cfa wsp, 128
	ldp	x29, x30, [sp, #112]
	add	sp, sp, #128
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB4_5:
	.cfi_restore_state
	.cfi_remember_state
	ldr	x0, [sp, #64]
Ltmp199:
	sub	x8, x29, #32
	bl	__ZN3std2io5error14repr_bitpacked11decode_repr17h4b697781965f1e6fE
Ltmp200:
	b	LBB4_16
LBB4_6:
	ldr	x8, [sp, #64]
	cbnz	x8, LBB4_8
	b	LBB4_7
LBB4_7:
	adrp	x8, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.18@PAGE
	add	x8, x8, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.18@PAGEOFF
	str	x8, [sp, #48]
	b	LBB4_9
LBB4_8:
	ldr	x8, [sp, #64]
	str	x8, [sp, #8]
	ldr	x9, [sp, #40]
	str	x9, [sp, #16]
	subs	x8, x8, x9
	b.hi	LBB4_11
	b	LBB4_10
LBB4_9:
	b	LBB4_4
LBB4_10:
	ldr	x10, [sp, #8]
	ldr	x8, [sp, #16]
	subs	x8, x8, x10
	ldr	x9, [sp, #32]
	add	x9, x9, x10
	str	x9, [sp, #32]
	str	x8, [sp, #40]
	b	LBB4_12
LBB4_11:
Ltmp197:
	ldr	x2, [sp, #16]
	ldr	x0, [sp, #8]
	mov	x1, x2
	adrp	x3, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.20@PAGE
	add	x3, x3, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.20@PAGEOFF
	bl	__RNvNtNtCs6sq8b9ugfBC_4core5slice5index16slice_index_fail
Ltmp198:
	b	LBB4_15
LBB4_12:
	ldr	x8, [sp, #56]
	tbnz	w8, #0, LBB4_28
	b	LBB4_29
LBB4_13:
	ldr	x8, [sp, #56]
	subs	x8, x8, #1
	b.eq	LBB4_30
	b	LBB4_31
LBB4_14:
Ltmp201:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB4_13
LBB4_15:
	brk	#0x1
LBB4_16:
	ldurb	w8, [x29, #-32]
	str	x8, [sp]
	cbz	x8, LBB4_21
	b	LBB4_17
LBB4_17:
	ldr	x8, [sp]
	subs	x8, x8, #1
	b.eq	LBB4_22
	b	LBB4_18
LBB4_18:
	ldr	x8, [sp]
	subs	x8, x8, #2
	b.eq	LBB4_23
	b	LBB4_19
LBB4_19:
	b	LBB4_24
LBB4_21:
	.cfi_restore_state
	ldur	w8, [x29, #-28]
	subs	w8, w8, #4
	cset	w8, eq
	sturb	w8, [x29, #-33]
	b	LBB4_25
LBB4_22:
	ldurb	w8, [x29, #-31]
	subs	x8, x8, #35
	cset	w8, eq
	sturb	w8, [x29, #-33]
	b	LBB4_25
LBB4_23:
	ldur	x8, [x29, #-24]
	ldrb	w8, [x8, #16]
	subs	x8, x8, #35
	cset	w8, eq
	sturb	w8, [x29, #-33]
	b	LBB4_25
LBB4_24:
	ldur	x8, [x29, #-24]
	ldrb	w8, [x8, #16]
	subs	x8, x8, #35
	cset	w8, eq
	sturb	w8, [x29, #-33]
	b	LBB4_25
LBB4_25:
	ldurb	w8, [x29, #-33]
	tbnz	w8, #0, LBB4_27
	b	LBB4_26
LBB4_26:
	ldr	x8, [sp, #64]
	str	x8, [sp, #48]
	b	LBB4_9
LBB4_27:
	b	LBB4_12
LBB4_28:
	add	x8, sp, #56
	add	x0, x8, #8
	bl	__ZN4core3ptr42drop_in_place$LT$std..io..error..Error$GT$17h33aedbd423127ae0E
	b	LBB4_29
LBB4_29:
	b	LBB4_1
LBB4_30:
	add	x8, sp, #56
	add	x0, x8, #8
Ltmp202:
	bl	__ZN4core3ptr42drop_in_place$LT$std..io..error..Error$GT$17h33aedbd423127ae0E
Ltmp203:
	b	LBB4_31
LBB4_31:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB4_32:
Ltmp204:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table4:
Lexception3:
	.byte	255
	.byte	155
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Lfunc_begin3-Lfunc_begin3
	.uleb128 Ltmp199-Lfunc_begin3
	.byte	0
	.byte	0
	.uleb128 Ltmp199-Lfunc_begin3
	.uleb128 Ltmp198-Ltmp199
	.uleb128 Ltmp201-Lfunc_begin3
	.byte	0
	.uleb128 Ltmp198-Lfunc_begin3
	.uleb128 Ltmp202-Ltmp198
	.byte	0
	.byte	0
	.uleb128 Ltmp202-Lfunc_begin3
	.uleb128 Ltmp203-Ltmp202
	.uleb128 Ltmp204-Lfunc_begin3
	.byte	1
	.uleb128 Ltmp203-Lfunc_begin3
	.uleb128 Lfunc_end3-Ltmp203
	.byte	0
	.byte	0
Lcst_end3:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase1:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN3std2io5error14repr_bitpacked11decode_repr17h4b697781965f1e6fE:
Lfunc_begin4:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception4
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
	cbz	x8, LBB5_7
	b	LBB5_1
LBB5_1:
	ldr	x8, [sp, #40]
	subs	x8, x8, #1
	b.eq	LBB5_8
	b	LBB5_2
LBB5_2:
	ldr	x8, [sp, #40]
	subs	x8, x8, #2
	b.eq	LBB5_5
	b	LBB5_3
LBB5_3:
	ldr	x8, [sp, #40]
	subs	x8, x8, #3
	b.eq	LBB5_6
	b	LBB5_4
LBB5_4:
Ltmp209:
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.23@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.23@PAGEOFF
	mov	w8, #40
	mov	x1, x8
	adrp	x2, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.24@PAGE
	add	x2, x2, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.24@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking5panic
Ltmp210:
	b	LBB5_18
LBB5_5:
	ldr	x8, [sp, #24]
	ldr	x9, [sp, #32]
	asr	x9, x9, #32
	str	w9, [x8, #4]
	strb	wzr, [x8]
	b	LBB5_9
LBB5_6:
	ldr	x8, [sp, #32]
	lsr	x8, x8, #32
	mov	x0, x8
Ltmp207:
	bl	__ZN3std2io5error14repr_bitpacked14kind_from_prim17hcca292bc86f3ae96E
	str	w0, [sp, #20]
Ltmp208:
	b	LBB5_12
LBB5_7:
	ldr	x9, [sp, #24]
	ldr	x8, [sp, #32]
	str	x8, [x9, #8]
	mov	w8, #2
	strb	w8, [x9]
	b	LBB5_9
LBB5_8:
	ldr	x8, [sp, #32]
	subs	x8, x8, #1
	stur	x8, [x29, #-8]
	ldur	x0, [x29, #-8]
	sturb	wzr, [x29, #-25]
Ltmp205:
	bl	__ZN3std2io5error14repr_bitpacked4Repr4data28_$u7b$$u7b$closure$u7d$$u7d$17h88e092d1c475fc13E
	str	x0, [sp, #8]
Ltmp206:
	b	LBB5_17
LBB5_9:
	b	LBB5_16
LBB5_10:
	ldurb	w8, [x29, #-25]
	tbnz	w8, #0, LBB5_20
	b	LBB5_19
LBB5_11:
Ltmp211:
	stur	x0, [x29, #-24]
	mov	x8, x1
	stur	w8, [x29, #-16]
	b	LBB5_10
LBB5_12:
	ldr	w8, [sp, #20]
	sturb	w8, [x29, #-26]
	ldurb	w8, [x29, #-26]
	subs	w8, w8, #42
	cset	x8, ne
	tbz	w8, #0, LBB5_14
	b	LBB5_13
LBB5_13:
	ldr	x9, [sp, #24]
	ldurb	w8, [x29, #-26]
	strb	w8, [x9, #1]
	mov	w8, #1
	strb	w8, [x9]
	b	LBB5_9
LBB5_14:
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.22@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.22@PAGEOFF
	bl	__ZN4core4hint21unreachable_unchecked18precondition_check17h8aaa22d7416d6641E
	b	LBB5_15
LBB5_15:
	brk	#0x1
LBB5_16:
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB5_17:
	.cfi_restore_state
	ldr	x9, [sp, #24]
	ldr	x8, [sp, #8]
	str	x8, [x9, #8]
	mov	w8, #3
	strb	w8, [x9]
	b	LBB5_16
LBB5_18:
	brk	#0x1
LBB5_19:
	ldur	x0, [x29, #-24]
	bl	__Unwind_Resume
LBB5_20:
	b	LBB5_19
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table5:
Lexception4:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Ltmp209-Lfunc_begin4
	.uleb128 Ltmp206-Ltmp209
	.uleb128 Ltmp211-Lfunc_begin4
	.byte	0
	.uleb128 Ltmp206-Lfunc_begin4
	.uleb128 Lfunc_end4-Ltmp206
	.byte	0
	.byte	0
Lcst_end4:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN3std2io5error14repr_bitpacked11decode_repr17h57f3049c2bcf1141E:
Lfunc_begin5:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception5
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
	cbz	x8, LBB6_7
	b	LBB6_1
LBB6_1:
	ldr	x8, [sp, #40]
	subs	x8, x8, #1
	b.eq	LBB6_8
	b	LBB6_2
LBB6_2:
	ldr	x8, [sp, #40]
	subs	x8, x8, #2
	b.eq	LBB6_5
	b	LBB6_3
LBB6_3:
	ldr	x8, [sp, #40]
	subs	x8, x8, #3
	b.eq	LBB6_6
	b	LBB6_4
LBB6_4:
Ltmp216:
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.23@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.23@PAGEOFF
	mov	w8, #40
	mov	x1, x8
	adrp	x2, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.24@PAGE
	add	x2, x2, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.24@PAGEOFF
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking5panic
Ltmp217:
	b	LBB6_18
LBB6_5:
	ldr	x8, [sp, #24]
	ldr	x9, [sp, #32]
	asr	x9, x9, #32
	str	w9, [x8, #4]
	strb	wzr, [x8]
	b	LBB6_9
LBB6_6:
	ldr	x8, [sp, #32]
	lsr	x8, x8, #32
	mov	x0, x8
Ltmp214:
	bl	__ZN3std2io5error14repr_bitpacked14kind_from_prim17hcca292bc86f3ae96E
	str	w0, [sp, #20]
Ltmp215:
	b	LBB6_12
LBB6_7:
	ldr	x9, [sp, #24]
	ldr	x8, [sp, #32]
	str	x8, [x9, #8]
	mov	w8, #2
	strb	w8, [x9]
	b	LBB6_9
LBB6_8:
	ldr	x8, [sp, #32]
	subs	x8, x8, #1
	stur	x8, [x29, #-8]
	ldur	x0, [x29, #-8]
	sturb	wzr, [x29, #-25]
Ltmp212:
	bl	__ZN78_$LT$std..io..error..repr_bitpacked..Repr$u20$as$u20$core..ops..drop..Drop$GT$4drop28_$u7b$$u7b$closure$u7d$$u7d$17hd2fdf1e1cdc51692E
	str	x0, [sp, #8]
Ltmp213:
	b	LBB6_17
LBB6_9:
	b	LBB6_16
LBB6_10:
	ldurb	w8, [x29, #-25]
	tbnz	w8, #0, LBB6_20
	b	LBB6_19
LBB6_11:
Ltmp218:
	stur	x0, [x29, #-24]
	mov	x8, x1
	stur	w8, [x29, #-16]
	b	LBB6_10
LBB6_12:
	ldr	w8, [sp, #20]
	sturb	w8, [x29, #-26]
	ldurb	w8, [x29, #-26]
	subs	w8, w8, #42
	cset	x8, ne
	tbz	w8, #0, LBB6_14
	b	LBB6_13
LBB6_13:
	ldr	x9, [sp, #24]
	ldurb	w8, [x29, #-26]
	strb	w8, [x9, #1]
	mov	w8, #1
	strb	w8, [x9]
	b	LBB6_9
LBB6_14:
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.22@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.22@PAGEOFF
	bl	__ZN4core4hint21unreachable_unchecked18precondition_check17h8aaa22d7416d6641E
	b	LBB6_15
LBB6_15:
	brk	#0x1
LBB6_16:
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB6_17:
	.cfi_restore_state
	ldr	x9, [sp, #24]
	ldr	x8, [sp, #8]
	str	x8, [x9, #8]
	mov	w8, #3
	strb	w8, [x9]
	b	LBB6_16
LBB6_18:
	brk	#0x1
LBB6_19:
	ldur	x0, [x29, #-24]
	bl	__Unwind_Resume
LBB6_20:
	b	LBB6_19
Lfunc_end5:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table6:
Lexception5:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end5-Lcst_begin5
Lcst_begin5:
	.uleb128 Ltmp216-Lfunc_begin5
	.uleb128 Ltmp213-Ltmp216
	.uleb128 Ltmp218-Lfunc_begin5
	.byte	0
	.uleb128 Ltmp213-Lfunc_begin5
	.uleb128 Lfunc_end5-Ltmp213
	.byte	0
	.byte	0
Lcst_end5:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN3std2io5error14repr_bitpacked14kind_from_prim17hcca292bc86f3ae96E:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	.cfi_remember_state
	str	w0, [sp, #8]
	cbnz	w0, LBB7_2
	b	LBB7_1
LBB7_1:
	strb	wzr, [sp, #15]
	b	LBB7_3
LBB7_2:
	ldr	w8, [sp, #8]
	subs	w8, w8, #1
	b.eq	LBB7_4
	b	LBB7_5
LBB7_3:
	ldrb	w0, [sp, #15]
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
LBB7_4:
	.cfi_restore_state
	mov	w8, #1
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_5:
	ldr	w8, [sp, #8]
	subs	w8, w8, #2
	b.ne	LBB7_7
	b	LBB7_6
LBB7_6:
	mov	w8, #2
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_7:
	ldr	w8, [sp, #8]
	subs	w8, w8, #3
	b.ne	LBB7_9
	b	LBB7_8
LBB7_8:
	mov	w8, #3
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_9:
	ldr	w8, [sp, #8]
	subs	w8, w8, #4
	b.ne	LBB7_11
	b	LBB7_10
LBB7_10:
	mov	w8, #4
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_11:
	ldr	w8, [sp, #8]
	subs	w8, w8, #5
	b.ne	LBB7_13
	b	LBB7_12
LBB7_12:
	mov	w8, #5
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_13:
	ldr	w8, [sp, #8]
	subs	w8, w8, #6
	b.ne	LBB7_15
	b	LBB7_14
LBB7_14:
	mov	w8, #6
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_15:
	ldr	w8, [sp, #8]
	subs	w8, w8, #7
	b.ne	LBB7_17
	b	LBB7_16
LBB7_16:
	mov	w8, #7
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_17:
	ldr	w8, [sp, #8]
	subs	w8, w8, #8
	b.ne	LBB7_19
	b	LBB7_18
LBB7_18:
	mov	w8, #8
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_19:
	ldr	w8, [sp, #8]
	subs	w8, w8, #9
	b.ne	LBB7_21
	b	LBB7_20
LBB7_20:
	mov	w8, #9
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_21:
	ldr	w8, [sp, #8]
	subs	w8, w8, #10
	b.ne	LBB7_23
	b	LBB7_22
LBB7_22:
	mov	w8, #10
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_23:
	ldr	w8, [sp, #8]
	subs	w8, w8, #11
	b.ne	LBB7_25
	b	LBB7_24
LBB7_24:
	mov	w8, #11
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_25:
	ldr	w8, [sp, #8]
	subs	w8, w8, #12
	b.ne	LBB7_27
	b	LBB7_26
LBB7_26:
	mov	w8, #12
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_27:
	ldr	w8, [sp, #8]
	subs	w8, w8, #13
	b.ne	LBB7_29
	b	LBB7_28
LBB7_28:
	mov	w8, #13
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_29:
	ldr	w8, [sp, #8]
	subs	w8, w8, #14
	b.ne	LBB7_31
	b	LBB7_30
LBB7_30:
	mov	w8, #14
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_31:
	ldr	w8, [sp, #8]
	subs	w8, w8, #15
	b.ne	LBB7_33
	b	LBB7_32
LBB7_32:
	mov	w8, #15
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_33:
	ldr	w8, [sp, #8]
	subs	w8, w8, #16
	b.ne	LBB7_35
	b	LBB7_34
LBB7_34:
	mov	w8, #16
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_35:
	ldr	w8, [sp, #8]
	subs	w8, w8, #17
	b.ne	LBB7_37
	b	LBB7_36
LBB7_36:
	mov	w8, #17
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_37:
	ldr	w8, [sp, #8]
	subs	w8, w8, #18
	b.ne	LBB7_39
	b	LBB7_38
LBB7_38:
	mov	w8, #18
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_39:
	ldr	w8, [sp, #8]
	subs	w8, w8, #19
	b.ne	LBB7_41
	b	LBB7_40
LBB7_40:
	mov	w8, #19
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_41:
	ldr	w8, [sp, #8]
	subs	w8, w8, #20
	b.ne	LBB7_43
	b	LBB7_42
LBB7_42:
	mov	w8, #20
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_43:
	ldr	w8, [sp, #8]
	subs	w8, w8, #21
	b.ne	LBB7_45
	b	LBB7_44
LBB7_44:
	mov	w8, #21
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_45:
	ldr	w8, [sp, #8]
	subs	w8, w8, #22
	b.ne	LBB7_47
	b	LBB7_46
LBB7_46:
	mov	w8, #22
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_47:
	ldr	w8, [sp, #8]
	subs	w8, w8, #23
	b.ne	LBB7_49
	b	LBB7_48
LBB7_48:
	mov	w8, #23
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_49:
	ldr	w8, [sp, #8]
	subs	w8, w8, #24
	b.ne	LBB7_51
	b	LBB7_50
LBB7_50:
	mov	w8, #24
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_51:
	ldr	w8, [sp, #8]
	subs	w8, w8, #25
	b.ne	LBB7_53
	b	LBB7_52
LBB7_52:
	mov	w8, #25
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_53:
	ldr	w8, [sp, #8]
	subs	w8, w8, #26
	b.ne	LBB7_55
	b	LBB7_54
LBB7_54:
	mov	w8, #26
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_55:
	ldr	w8, [sp, #8]
	subs	w8, w8, #27
	b.ne	LBB7_57
	b	LBB7_56
LBB7_56:
	mov	w8, #27
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_57:
	ldr	w8, [sp, #8]
	subs	w8, w8, #28
	b.ne	LBB7_59
	b	LBB7_58
LBB7_58:
	mov	w8, #28
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_59:
	ldr	w8, [sp, #8]
	subs	w8, w8, #29
	b.ne	LBB7_61
	b	LBB7_60
LBB7_60:
	mov	w8, #29
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_61:
	ldr	w8, [sp, #8]
	subs	w8, w8, #30
	b.ne	LBB7_63
	b	LBB7_62
LBB7_62:
	mov	w8, #30
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_63:
	ldr	w8, [sp, #8]
	subs	w8, w8, #31
	b.ne	LBB7_65
	b	LBB7_64
LBB7_64:
	mov	w8, #31
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_65:
	ldr	w8, [sp, #8]
	subs	w8, w8, #32
	b.ne	LBB7_67
	b	LBB7_66
LBB7_66:
	mov	w8, #32
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_67:
	ldr	w8, [sp, #8]
	subs	w8, w8, #33
	b.ne	LBB7_69
	b	LBB7_68
LBB7_68:
	mov	w8, #33
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_69:
	ldr	w8, [sp, #8]
	subs	w8, w8, #34
	b.ne	LBB7_71
	b	LBB7_70
LBB7_70:
	mov	w8, #34
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_71:
	ldr	w8, [sp, #8]
	subs	w8, w8, #35
	b.ne	LBB7_73
	b	LBB7_72
LBB7_72:
	mov	w8, #35
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_73:
	ldr	w8, [sp, #8]
	subs	w8, w8, #40
	b.ne	LBB7_75
	b	LBB7_74
LBB7_74:
	mov	w8, #40
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_75:
	ldr	w8, [sp, #8]
	subs	w8, w8, #37
	b.ne	LBB7_77
	b	LBB7_76
LBB7_76:
	mov	w8, #37
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_77:
	ldr	w8, [sp, #8]
	subs	w8, w8, #36
	b.ne	LBB7_79
	b	LBB7_78
LBB7_78:
	mov	w8, #36
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_79:
	ldr	w8, [sp, #8]
	subs	w8, w8, #38
	b.ne	LBB7_81
	b	LBB7_80
LBB7_80:
	mov	w8, #38
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_81:
	ldr	w8, [sp, #8]
	subs	w8, w8, #39
	b.ne	LBB7_83
	b	LBB7_82
LBB7_82:
	mov	w8, #39
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_83:
	ldr	w8, [sp, #8]
	subs	w8, w8, #41
	b.ne	LBB7_85
	b	LBB7_84
LBB7_84:
	mov	w8, #41
	strb	w8, [sp, #15]
	b	LBB7_3
LBB7_85:
	mov	w8, #42
	strb	w8, [sp, #15]
	b	LBB7_3
	.cfi_endproc

	.p2align	2
__ZN3std2io5error14repr_bitpacked4Repr4data28_$u7b$$u7b$closure$u7d$$u7d$17h88e092d1c475fc13E:
	.cfi_startproc
	ret
	.cfi_endproc

	.private_extern	__ZN3std2rt10lang_start17h092b65f5e5368486E
	.globl	__ZN3std2rt10lang_start17h092b65f5e5368486E
	.p2align	2
__ZN3std2rt10lang_start17h092b65f5e5368486E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	str	x1, [sp, #8]
	mov	x0, x2
	ldr	x2, [sp, #8]
	str	x0, [sp, #16]
	mov	x4, x3
	ldr	x3, [sp, #16]
	sub	x0, x29, #8
	stur	x8, [x29, #-8]
	adrp	x1, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.25@PAGE
	add	x1, x1, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.25@PAGEOFF
	bl	__RNvNtCsaLOjE9VYtxK_3std2rt19lang_start_internal
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h8bf8379636839148E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x0, [x0]
	bl	__ZN3std3sys9backtrace28__rust_begin_short_backtrace17h96d72c2c743de313E
	bl	__ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17hd4245bcdb202dcb2E
	and	w0, w0, #0xff
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN3std3env3var17h4523c37eaf4fb264E:
Lfunc_begin6:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception6
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x8, [sp, #8]
	mov	x8, x0
	add	x0, sp, #32
	str	x8, [sp, #32]
	str	x1, [sp, #40]
Ltmp220:
	bl	__ZN55_$LT$$RF$T$u20$as$u20$core..convert..AsRef$LT$U$GT$$GT$6as_ref17h14123edc38601370E
	str	x0, [sp, #16]
	str	x1, [sp, #24]
Ltmp221:
	b	LBB11_3
LBB11_1:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB11_2:
Ltmp224:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB11_1
LBB11_3:
Ltmp222:
	ldr	x1, [sp, #24]
	ldr	x0, [sp, #16]
	ldr	x8, [sp, #8]
	bl	__RNvNtCsaLOjE9VYtxK_3std3env4__var
Ltmp223:
	b	LBB11_4
LBB11_4:
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
Lfunc_end6:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table11:
Lexception6:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end6-Lcst_begin6
Lcst_begin6:
	.uleb128 Ltmp220-Lfunc_begin6
	.uleb128 Ltmp221-Ltmp220
	.uleb128 Ltmp224-Lfunc_begin6
	.byte	0
	.uleb128 Ltmp221-Lfunc_begin6
	.uleb128 Ltmp222-Ltmp221
	.byte	0
	.byte	0
	.uleb128 Ltmp222-Lfunc_begin6
	.uleb128 Ltmp223-Ltmp222
	.uleb128 Ltmp224-Lfunc_begin6
	.byte	0
Lcst_end6:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN3std3ffi6os_str103_$LT$impl$u20$core..convert..AsRef$LT$std..ffi..os_str..OsStr$GT$$u20$for$u20$alloc..string..String$GT$6as_ref17h2e5961d222464f9dE:
	.cfi_startproc
	mov	x8, x0
	ldr	x0, [x8, #8]
	ldr	x1, [x8, #16]
	ret
	.cfi_endproc

	.p2align	2
__ZN3std3ffi6os_str85_$LT$impl$u20$core..convert..AsRef$LT$std..ffi..os_str..OsStr$GT$$u20$for$u20$str$GT$6as_ref17hc8caf54c8aa21a4dE:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN3std3sys2fs4unix23debug_assert_fd_is_open17h0b6fcd595b5fb918E:
	.cfi_startproc
	b	LBB14_1
LBB14_1:
	ret
	.cfi_endproc

	.p2align	2
__ZN3std3sys9backtrace28__rust_begin_short_backtrace17h96d72c2c743de313E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ops8function6FnOnce9call_once17ha0327ec493aa892fE
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
__ZN3std4path4Path3new17hf1746d9674677df3E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN3std3ffi6os_str103_$LT$impl$u20$core..convert..AsRef$LT$std..ffi..os_str..OsStr$GT$$u20$for$u20$alloc..string..String$GT$6as_ref17h2e5961d222464f9dE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN3std4path4Path4join17h2bbc62d95d702e4fE:
Lfunc_begin7:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception7
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	stp	x29, x30, [sp, #80]
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x8, [sp, #8]
	str	x0, [sp, #16]
	str	x1, [sp, #24]
	sub	x0, x29, #32
	stur	x2, [x29, #-32]
	stur	x3, [x29, #-24]
Ltmp225:
	bl	__ZN55_$LT$$RF$T$u20$as$u20$core..convert..AsRef$LT$U$GT$$GT$6as_ref17h236457b569782dafE
	str	x0, [sp, #32]
	str	x1, [sp, #40]
Ltmp226:
	b	LBB17_3
LBB17_1:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB17_2:
Ltmp229:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB17_1
LBB17_3:
Ltmp227:
	ldr	x3, [sp, #40]
	ldr	x2, [sp, #32]
	ldr	x1, [sp, #24]
	ldr	x0, [sp, #16]
	ldr	x8, [sp, #8]
	bl	__RNvMs16_NtCsaLOjE9VYtxK_3std4pathNtB6_4Path5__join
Ltmp228:
	b	LBB17_4
LBB17_4:
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
Lfunc_end7:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table17:
Lexception7:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end7-Lcst_begin7
Lcst_begin7:
	.uleb128 Ltmp225-Lfunc_begin7
	.uleb128 Ltmp226-Ltmp225
	.uleb128 Ltmp229-Lfunc_begin7
	.byte	0
	.uleb128 Ltmp226-Lfunc_begin7
	.uleb128 Ltmp227-Ltmp226
	.byte	0
	.byte	0
	.uleb128 Ltmp227-Lfunc_begin7
	.uleb128 Ltmp228-Ltmp227
	.uleb128 Ltmp229-Lfunc_begin7
	.byte	0
Lcst_end7:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN3std4path77_$LT$impl$u20$core..convert..AsRef$LT$std..path..Path$GT$$u20$for$u20$str$GT$6as_ref17hc12626665e47f859E:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h97167d2701c96bcdE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x0, [x0]
	bl	__RNvXs9_NtNtCsaLOjE9VYtxK_3std3ffi6os_strNtB5_8OsStringNtNtCs6sq8b9ugfBC_4core3fmt5Debug3fmt
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN49_$LT$usize$u20$as$u20$core..iter..range..Step$GT$17forward_unchecked17hfc2198376e3e33daE:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp]
	str	x1, [sp, #8]
	b	LBB20_1
LBB20_1:
	ldr	x8, [sp]
	ldr	x9, [sp, #8]
	add	x0, x8, x9
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3fmt2rt8Argument11new_display17h56f40c4b7916910fE:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp]
	adrp	x9, __RNvXsk_NtCs6sq8b9ugfBC_4core3fmtcNtB5_7Display3fmt@GOTPAGE
	ldr	x9, [x9, __RNvXsk_NtCs6sq8b9ugfBC_4core3fmtcNtB5_7Display3fmt@GOTPAGEOFF]
	str	x9, [sp, #8]
	ldr	q0, [sp]
	str	q0, [x8]
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3fmt2rt8Argument11new_display17hfd3b574cfa14ea57E:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp]
	adrp	x9, __RNvXsi_NtNtNtCs6sq8b9ugfBC_4core3fmt3num3impjNtB9_7Display3fmt@GOTPAGE
	ldr	x9, [x9, __RNvXsi_NtNtNtCs6sq8b9ugfBC_4core3fmt3num3impjNtB9_7Display3fmt@GOTPAGEOFF]
	str	x9, [sp, #8]
	ldr	q0, [sp]
	str	q0, [x8]
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3fmt9Arguments3new17h41657b20bcb6b6c1E:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3fmt9Arguments3new17h4cf8688980ecc875E:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3fmt9Arguments3new17h58460f2d671fc7daE:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3fmt9Arguments3new17haf466a730ae0ca26E:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3fmt9Arguments3new17hfef86bc8b893a5afE:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3fmt9Arguments8from_str17h56a71a49753358d3E:
	.cfi_startproc
	lsl	x8, x1, #1
	orr	x1, x8, #0x1
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h632ea207a50dad95E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x0, [x0]
	bl	__ZN4core3ops8function6FnOnce9call_once17h34b71f22169953f4E
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ops8function6FnOnce9call_once17h34b71f22169953f4E:
Lfunc_begin8:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception8
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	add	x0, sp, #16
	str	x8, [sp, #16]
Ltmp233:
	bl	__ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h8bf8379636839148E
	str	w0, [sp, #12]
Ltmp234:
	b	LBB30_3
LBB30_1:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB30_2:
Ltmp235:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB30_1
LBB30_3:
	ldr	w0, [sp, #12]
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
Lfunc_end8:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table30:
Lexception8:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end8-Lcst_begin8
Lcst_begin8:
	.uleb128 Ltmp233-Lfunc_begin8
	.uleb128 Ltmp234-Ltmp233
	.uleb128 Ltmp235-Lfunc_begin8
	.byte	0
	.uleb128 Ltmp234-Lfunc_begin8
	.uleb128 Lfunc_end8-Ltmp234
	.byte	0
	.byte	0
Lcst_end8:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core3ops8function6FnOnce9call_once17h41efaa3fcaaca11fE:
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
	bl	__ZN5alloc3str56_$LT$impl$u20$alloc..borrow..ToOwned$u20$for$u20$str$GT$8to_owned17ha55e49ef44706bd1E
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ops8function6FnOnce9call_once17ha0327ec493aa892fE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	blr	x0
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr101drop_in_place$LT$std..io..error..ErrorData$LT$alloc..boxed..Box$LT$std..io..error..Custom$GT$$GT$$GT$17h388fe8ddc3471f56E:
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
	b.ls	LBB33_2
	b	LBB33_1
LBB33_1:
	ldr	x8, [sp, #8]
	add	x0, x8, #8
	bl	__ZN4core3ptr68drop_in_place$LT$alloc..boxed..Box$LT$std..io..error..Custom$GT$$GT$17hc9857660b84cf3e1E
	b	LBB33_2
LBB33_2:
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr118drop_in_place$LT$alloc..boxed..Box$LT$dyn$u20$core..error..Error$u2b$core..marker..Sync$u2b$core..marker..Send$GT$$GT$17h13470057d1ec9e78E:
Lfunc_begin9:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception9
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
	cbz	x8, LBB34_2
	b	LBB34_1
LBB34_1:
Ltmp236:
	ldr	x8, [sp, #24]
	ldr	x0, [sp, #16]
	blr	x8
Ltmp237:
	b	LBB34_2
LBB34_2:
	ldr	x0, [sp, #8]
	bl	__ZN72_$LT$alloc..boxed..Box$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h06b71860a060007aE
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB34_3:
	.cfi_restore_state
Ltmp239:
	ldr	x0, [sp, #8]
	bl	__ZN72_$LT$alloc..boxed..Box$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h06b71860a060007aE
Ltmp240:
	b	LBB34_6
LBB34_4:
Ltmp238:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB34_3
LBB34_5:
Ltmp241:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB34_6:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
Lfunc_end9:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table34:
Lexception9:
	.byte	255
	.byte	155
	.uleb128 Lttbase2-Lttbaseref2
Lttbaseref2:
	.byte	1
	.uleb128 Lcst_end9-Lcst_begin9
Lcst_begin9:
	.uleb128 Ltmp236-Lfunc_begin9
	.uleb128 Ltmp237-Ltmp236
	.uleb128 Ltmp238-Lfunc_begin9
	.byte	0
	.uleb128 Ltmp237-Lfunc_begin9
	.uleb128 Ltmp239-Ltmp237
	.byte	0
	.byte	0
	.uleb128 Ltmp239-Lfunc_begin9
	.uleb128 Ltmp240-Ltmp239
	.uleb128 Ltmp241-Lfunc_begin9
	.byte	1
	.uleb128 Ltmp240-Lfunc_begin9
	.uleb128 Lfunc_end9-Ltmp240
	.byte	0
	.byte	0
Lcst_end9:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase2:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core3ptr34drop_in_place$LT$std..fs..File$GT$17heeba5f855ca527c8E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr45drop_in_place$LT$std..sys..fs..unix..File$GT$17h928845a26658e4e4E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr39drop_in_place$LT$std..env..VarError$GT$17hba116970859ad9c9E:
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
	mov	x9, #-9223372036854775808
	subs	x8, x8, x9
	cset	x8, ne
	cbnz	x8, LBB36_2
	b	LBB36_1
LBB36_1:
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB36_2:
	.cfi_restore_state
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr47drop_in_place$LT$std..ffi..os_str..OsString$GT$17h7ed955e7fe4adfafE
	b	LBB36_1
	.cfi_endproc

	.p2align	2
__ZN4core3ptr39drop_in_place$LT$std..path..PathBuf$GT$17hae9b7a203522e090E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr47drop_in_place$LT$std..ffi..os_str..OsString$GT$17h7ed955e7fe4adfafE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h60f2a59acaf75832E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr46drop_in_place$LT$alloc..vec..Vec$LT$u8$GT$$GT$17hef9bfe12cc3458c8E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr42drop_in_place$LT$std..io..error..Error$GT$17h33aedbd423127ae0E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr57drop_in_place$LT$std..io..error..repr_bitpacked..Repr$GT$17hc39fd388b2808184E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr43drop_in_place$LT$std..io..error..Custom$GT$17h8379472309d66307E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr118drop_in_place$LT$alloc..boxed..Box$LT$dyn$u20$core..error..Error$u2b$core..marker..Sync$u2b$core..marker..Send$GT$$GT$17h13470057d1ec9e78E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr45drop_in_place$LT$std..sys..fs..unix..File$GT$17h928845a26658e4e4E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr49drop_in_place$LT$std..sys..fd..unix..FileDesc$GT$17h0d7becae378a4956E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr46drop_in_place$LT$alloc..vec..Vec$LT$u8$GT$$GT$17hef9bfe12cc3458c8E:
Lfunc_begin10:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception10
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	x0, [sp, #8]
Ltmp242:
	bl	__RNvXso_NtCs8dnTdrJsiec_5alloc3vecINtB5_3VechENtNtNtCs6sq8b9ugfBC_4core3ops4drop4Drop4dropCsixjwb4TfRM4_5gimli
Ltmp243:
	b	LBB42_3
LBB42_1:
Ltmp245:
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr53drop_in_place$LT$alloc..raw_vec..RawVec$LT$u8$GT$$GT$17hde330e67cb124fb9E
Ltmp246:
	b	LBB42_5
LBB42_2:
Ltmp244:
	str	x0, [sp, #16]
	mov	x8, x1
	str	w8, [sp, #24]
	b	LBB42_1
LBB42_3:
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr53drop_in_place$LT$alloc..raw_vec..RawVec$LT$u8$GT$$GT$17hde330e67cb124fb9E
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB42_4:
	.cfi_restore_state
Ltmp247:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB42_5:
	ldr	x0, [sp, #16]
	bl	__Unwind_Resume
Lfunc_end10:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table42:
Lexception10:
	.byte	255
	.byte	155
	.uleb128 Lttbase3-Lttbaseref3
Lttbaseref3:
	.byte	1
	.uleb128 Lcst_end10-Lcst_begin10
Lcst_begin10:
	.uleb128 Ltmp242-Lfunc_begin10
	.uleb128 Ltmp243-Ltmp242
	.uleb128 Ltmp244-Lfunc_begin10
	.byte	0
	.uleb128 Ltmp245-Lfunc_begin10
	.uleb128 Ltmp246-Ltmp245
	.uleb128 Ltmp247-Lfunc_begin10
	.byte	1
	.uleb128 Ltmp246-Lfunc_begin10
	.uleb128 Lfunc_end10-Ltmp246
	.byte	0
	.byte	0
Lcst_end10:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase3:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core3ptr47drop_in_place$LT$std..ffi..os_str..OsString$GT$17h7ed955e7fe4adfafE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr49drop_in_place$LT$std..sys..os_str..bytes..Buf$GT$17h79eb54f799e1e639E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr48drop_in_place$LT$std..os..fd..owned..OwnedFd$GT$17he13af2796ba93d6fE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN69_$LT$std..os..fd..owned..OwnedFd$u20$as$u20$core..ops..drop..Drop$GT$4drop17h797f0218dc1a33abE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr49drop_in_place$LT$std..sys..fd..unix..FileDesc$GT$17h0d7becae378a4956E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr48drop_in_place$LT$std..os..fd..owned..OwnedFd$GT$17he13af2796ba93d6fE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr49drop_in_place$LT$std..sys..os_str..bytes..Buf$GT$17h79eb54f799e1e639E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN4core3ptr46drop_in_place$LT$alloc..vec..Vec$LT$u8$GT$$GT$17hef9bfe12cc3458c8E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr53drop_in_place$LT$alloc..raw_vec..RawVec$LT$u8$GT$$GT$17hde330e67cb124fb9E:
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
__ZN4core3ptr57drop_in_place$LT$std..io..error..repr_bitpacked..Repr$GT$17hc39fd388b2808184E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN78_$LT$std..io..error..repr_bitpacked..Repr$u20$as$u20$core..ops..drop..Drop$GT$4drop17h57d86b2ff7430891E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core3ptr68drop_in_place$LT$alloc..boxed..Box$LT$std..io..error..Custom$GT$$GT$17hc9857660b84cf3e1E:
Lfunc_begin11:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception11
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
Ltmp248:
	bl	__ZN4core3ptr43drop_in_place$LT$std..io..error..Custom$GT$17h8379472309d66307E
Ltmp249:
	b	LBB49_3
LBB49_1:
Ltmp251:
	ldr	x0, [sp, #8]
	bl	__ZN72_$LT$alloc..boxed..Box$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h443e32336f9cb326E
Ltmp252:
	b	LBB49_5
LBB49_2:
Ltmp250:
	str	x0, [sp, #16]
	mov	x8, x1
	str	w8, [sp, #24]
	b	LBB49_1
LBB49_3:
	ldr	x0, [sp, #8]
	bl	__ZN72_$LT$alloc..boxed..Box$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h443e32336f9cb326E
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB49_4:
	.cfi_restore_state
Ltmp253:
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking16panic_in_cleanup
LBB49_5:
	ldr	x0, [sp, #16]
	bl	__Unwind_Resume
Lfunc_end11:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table49:
Lexception11:
	.byte	255
	.byte	155
	.uleb128 Lttbase4-Lttbaseref4
Lttbaseref4:
	.byte	1
	.uleb128 Lcst_end11-Lcst_begin11
Lcst_begin11:
	.uleb128 Ltmp248-Lfunc_begin11
	.uleb128 Ltmp249-Ltmp248
	.uleb128 Ltmp250-Lfunc_begin11
	.byte	0
	.uleb128 Ltmp251-Lfunc_begin11
	.uleb128 Ltmp252-Ltmp251
	.uleb128 Ltmp253-Lfunc_begin11
	.byte	1
	.uleb128 Ltmp252-Lfunc_begin11
	.uleb128 Lfunc_end11-Ltmp252
	.byte	0
	.byte	0
Lcst_end11:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase4:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN4core3ptr93drop_in_place$LT$dyn$u20$core..error..Error$u2b$core..marker..Sync$u2b$core..marker..Send$GT$17h9aa155a27e483062E:
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
	cbz	x8, LBB50_2
	b	LBB50_1
LBB50_1:
	ldr	x8, [sp, #8]
	ldr	x0, [sp]
	blr	x8
	b	LBB50_2
LBB50_2:
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core4hint21unreachable_unchecked18precondition_check17h8aaa22d7416d6641E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x3, x0
	adrp	x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.26@PAGE
	add	x0, x0, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.26@PAGEOFF
	mov	w8, #399
	mov	x1, x8
	mov	w8, #0
	and	w2, w8, #0x1
	bl	__RNvNtCs6sq8b9ugfBC_4core9panicking18panic_nounwind_fmt
	.cfi_endproc

	.p2align	2
__ZN4core4iter5range101_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..Range$LT$A$GT$$GT$4next17h2c2ef1c40a3758c6E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZN89_$LT$core..ops..range..Range$LT$T$GT$$u20$as$u20$core..iter..range..RangeIteratorImpl$GT$9spec_next17h00c7265f59214bf0E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN4core6option15Option$LT$T$GT$11map_or_else17h31e8deef302bd5e3E:
Lfunc_begin12:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception12
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
	tbz	w8, #0, LBB53_2
	b	LBB53_1
LBB53_1:
	ldr	x8, [sp, #8]
	ldr	x0, [sp, #24]
	ldr	x1, [sp, #32]
	sturb	wzr, [x29, #-18]
Ltmp256:
	bl	__ZN4core3ops8function6FnOnce9call_once17h41efaa3fcaaca11fE
Ltmp257:
	b	LBB53_7
LBB53_2:
	ldr	x0, [sp, #16]
	ldr	x8, [sp, #8]
	sturb	wzr, [x29, #-17]
Ltmp254:
	bl	__ZN5alloc3fmt6format28_$u7b$$u7b$closure$u7d$$u7d$17hb5144934aeeb69baE
Ltmp255:
	b	LBB53_5
LBB53_3:
	ldurb	w8, [x29, #-18]
	tbnz	w8, #0, LBB53_9
	b	LBB53_8
LBB53_4:
Ltmp258:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB53_3
LBB53_5:
	b	LBB53_6
LBB53_6:
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB53_7:
	.cfi_restore_state
	b	LBB53_6
LBB53_8:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB53_11
	b	LBB53_10
LBB53_9:
	b	LBB53_8
LBB53_10:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB53_11:
	b	LBB53_10
Lfunc_end12:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table53:
Lexception12:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end12-Lcst_begin12
Lcst_begin12:
	.uleb128 Ltmp256-Lfunc_begin12
	.uleb128 Ltmp255-Ltmp256
	.uleb128 Ltmp258-Lfunc_begin12
	.byte	0
	.uleb128 Ltmp255-Lfunc_begin12
	.uleb128 Lfunc_end12-Ltmp255
	.byte	0
	.byte	0
Lcst_end12:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17hd4245bcdb202dcb2E:
	.cfi_startproc
	mov	w0, #0
	ret
	.cfi_endproc

	.p2align	2
__ZN55_$LT$$RF$T$u20$as$u20$core..convert..AsRef$LT$U$GT$$GT$6as_ref17h04a4781749bf881bE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x0, [x0]
	bl	__ZN82_$LT$std..path..PathBuf$u20$as$u20$core..convert..AsRef$LT$std..path..Path$GT$$GT$6as_ref17h100c3fa95df9718bE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN55_$LT$$RF$T$u20$as$u20$core..convert..AsRef$LT$U$GT$$GT$6as_ref17h14123edc38601370E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	ldr	x0, [x8]
	ldr	x1, [x8, #8]
	bl	__ZN3std3ffi6os_str85_$LT$impl$u20$core..convert..AsRef$LT$std..ffi..os_str..OsStr$GT$$u20$for$u20$str$GT$6as_ref17hc8caf54c8aa21a4dE
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN55_$LT$$RF$T$u20$as$u20$core..convert..AsRef$LT$U$GT$$GT$6as_ref17h236457b569782dafE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	ldr	x0, [x8]
	ldr	x1, [x8, #8]
	bl	__ZN3std4path77_$LT$impl$u20$core..convert..AsRef$LT$std..path..Path$GT$$u20$for$u20$str$GT$6as_ref17hc12626665e47f859E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN55_$LT$$RF$T$u20$as$u20$core..convert..AsRef$LT$U$GT$$GT$6as_ref17h95e7d33ff2ae0a4aE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	ldr	x0, [x8]
	ldr	x1, [x8, #8]
	bl	__ZN79_$LT$std..path..Path$u20$as$u20$core..convert..AsRef$LT$std..path..Path$GT$$GT$6as_ref17h952e60a5282c7cd4E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN55_$LT$std..env..VarError$u20$as$u20$core..fmt..Debug$GT$3fmt17h89463dfd02c0cd6cE:
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
	ldr	x8, [x0]
	mov	x9, #-9223372036854775808
	subs	x8, x8, x9
	cset	x8, ne
	tbz	w8, #0, LBB59_2
	b	LBB59_1
LBB59_1:
	ldr	x0, [sp, #8]
	ldr	x8, [sp]
	sub	x3, x29, #8
	stur	x8, [x29, #-8]
	adrp	x1, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.35@PAGE
	add	x1, x1, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.35@PAGEOFF
	mov	w8, #10
	mov	x2, x8
	adrp	x4, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.34@PAGE
	add	x4, x4, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.34@PAGEOFF
	bl	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter25debug_tuple_field1_finish
	sturb	w0, [x29, #-9]
	b	LBB59_3
LBB59_2:
	ldr	x0, [sp, #8]
	adrp	x1, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.33@PAGE
	add	x1, x1, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.33@PAGEOFF
	mov	w8, #10
	mov	x2, x8
	bl	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter9write_str
	sturb	w0, [x29, #-9]
	b	LBB59_3
LBB59_3:
	ldurb	w8, [x29, #-9]
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
__ZN5alloc3fmt6format17h2d5974586d515262E:
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
	b.ne	LBB60_2
	b	LBB60_1
LBB60_1:
	ldr	x8, [sp, #24]
	ldr	x9, [sp, #32]
	str	x9, [sp]
	lsr	x8, x8, #1
	str	x8, [sp, #8]
	b	LBB60_3
LBB60_2:
	adrp	x9, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.36@PAGE
	adrp	x8, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.36@PAGE
	add	x8, x8, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.36@PAGEOFF
	ldr	x9, [x9, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.36@PAGEOFF]
	ldr	x8, [x8, #8]
	stur	x9, [x29, #-16]
	stur	x8, [x29, #-8]
	b	LBB60_4
LBB60_3:
	ldr	x8, [sp, #8]
	ldr	x9, [sp]
	stur	x9, [x29, #-16]
	stur	x8, [x29, #-8]
	b	LBB60_4
LBB60_4:
	ldr	x8, [sp, #16]
	ldur	x0, [x29, #-16]
	ldur	x1, [x29, #-8]
	add	x2, sp, #32
	bl	__ZN4core6option15Option$LT$T$GT$11map_or_else17h31e8deef302bd5e3E
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN5alloc3fmt6format28_$u7b$$u7b$closure$u7d$$u7d$17hb5144934aeeb69baE:
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
__ZN5alloc3str56_$LT$impl$u20$alloc..borrow..ToOwned$u20$for$u20$str$GT$8to_owned17ha55e49ef44706bd1E:
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
	bl	__ZN87_$LT$T$u20$as$u20$alloc..slice..$LT$impl$u20$$u5b$T$u5d$$GT$..to_vec_in..ConvertVec$GT$6to_vec17h6f0a9d6aa1c9c869E
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
__ZN5alloc3vec16Vec$LT$T$C$A$GT$15append_elements17h6c37a40255d6e65eE:
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
	b.hi	LBB63_2
	b	LBB63_1
LBB63_1:
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
LBB63_2:
	.cfi_restore_state
	ldur	x9, [x29, #-8]
	ldr	x8, [sp, #24]
	ldr	x8, [x8, #8]
	add	x8, x8, x9
	str	x8, [sp, #8]
	b	LBB63_3
LBB63_3:
	ldr	x1, [sp, #16]
	ldr	x0, [sp, #8]
	ldur	x8, [x29, #-16]
	lsr	x2, x8, #0
	bl	_memcpy
	b	LBB63_1
	.cfi_endproc

	.p2align	2
__ZN5alloc6string6String3new17h618dc60ffeaa7886E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	mov	x9, x8
	str	xzr, [sp, #8]
	mov	w8, #1
	str	x8, [sp, #16]
	str	xzr, [sp, #24]
	ldur	q0, [sp, #8]
	str	q0, [x9]
	ldr	x8, [sp, #24]
	str	x8, [x9, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN5alloc6string6String6as_str17h0cf478f5b5116b09E:
	.cfi_startproc
	mov	x8, x0
	ldr	x0, [x8, #8]
	ldr	x1, [x8, #16]
	ret
	.cfi_endproc

	.p2align	2
__ZN5alloc6string6String8as_bytes17ha05cc3ee3af7c996E:
	.cfi_startproc
	mov	x8, x0
	ldr	x0, [x8, #8]
	ldr	x1, [x8, #16]
	ret
	.cfi_endproc

	.p2align	2
__ZN5alloc6string6String8push_str17h4165badcca99a1bcE:
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
	bl	__ZN5alloc3vec16Vec$LT$T$C$A$GT$15append_elements17h6c37a40255d6e65eE
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN5alloc7raw_vec20RawVecInner$LT$A$GT$16with_capacity_in17h8aef98f8ca2a01c5E:
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
	tbz	w8, #0, LBB68_2
	b	LBB68_1
LBB68_1:
	ldr	x0, [sp, #40]
	ldr	x1, [sp, #48]
	bl	__RNvNtCs8dnTdrJsiec_5alloc7raw_vec12handle_error
LBB68_2:
	ldr	x8, [sp, #24]
	ldr	x9, [sp, #40]
	str	x9, [sp]
	ldr	x9, [sp, #48]
	str	x9, [sp, #8]
	cbnz	x8, LBB68_4
	b	LBB68_3
LBB68_3:
	mov	x8, #-1
	stur	x8, [x29, #-8]
	b	LBB68_5
LBB68_4:
	ldr	x8, [sp]
	stur	x8, [x29, #-8]
	b	LBB68_5
LBB68_5:
	b	LBB68_6
LBB68_6:
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
__ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17hecaf27c5c8cea0d8E:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN63_$LT$alloc..alloc..Global$u20$as$u20$core..alloc..Allocator$GT$10deallocate17hbd58308ee63969d8E:
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
	cbnz	x3, LBB70_2
	b	LBB70_1
LBB70_1:
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB70_2:
	.cfi_restore_state
	ldr	x2, [sp, #16]
	ldur	x1, [x29, #-8]
	ldr	x0, [sp, #8]
	bl	__RNvCsGIExRX8pES_7___rustc14___rust_dealloc
	b	LBB70_1
	.cfi_endproc

	.p2align	2
__ZN69_$LT$std..os..fd..owned..OwnedFd$u20$as$u20$core..ops..drop..Drop$GT$4drop17h797f0218dc1a33abE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	ldr	w0, [x0]
	bl	__ZN3std3sys2fs4unix23debug_assert_fd_is_open17h0b6fcd595b5fb918E
	ldr	x0, [sp, #8]
	ldr	w0, [x0]
	bl	_close
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN72_$LT$alloc..boxed..Box$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h06b71860a060007aE:
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
	b	LBB72_1
LBB72_1:
	b	LBB72_2
LBB72_2:
	ldr	x8, [sp, #16]
	cbnz	x8, LBB72_4
	b	LBB72_3
LBB72_3:
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB72_4:
	.cfi_restore_state
	ldr	x3, [sp, #16]
	ldr	x2, [sp, #24]
	ldr	x1, [sp, #8]
	ldr	x8, [sp]
	add	x0, x8, #16
	bl	__ZN63_$LT$alloc..alloc..Global$u20$as$u20$core..alloc..Allocator$GT$10deallocate17hbd58308ee63969d8E
	b	LBB72_3
	.cfi_endproc

	.p2align	2
__ZN72_$LT$alloc..boxed..Box$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h443e32336f9cb326E:
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
	b	LBB73_1
LBB73_1:
	b	LBB73_2
LBB73_2:
	ldr	x8, [sp, #16]
	cbnz	x8, LBB73_4
	b	LBB73_3
LBB73_3:
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB73_4:
	.cfi_restore_state
	ldr	x3, [sp, #16]
	ldr	x2, [sp, #24]
	ldr	x1, [sp, #8]
	ldr	x8, [sp]
	add	x0, x8, #8
	bl	__ZN63_$LT$alloc..alloc..Global$u20$as$u20$core..alloc..Allocator$GT$10deallocate17hbd58308ee63969d8E
	b	LBB73_3
	.cfi_endproc

	.p2align	2
__ZN78_$LT$std..io..error..repr_bitpacked..Repr$u20$as$u20$core..ops..drop..Drop$GT$4drop17h57d86b2ff7430891E:
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
	bl	__ZN3std2io5error14repr_bitpacked11decode_repr17h57f3049c2bcf1141E
	ldr	x0, [sp, #8]
	bl	__ZN4core3ptr101drop_in_place$LT$std..io..error..ErrorData$LT$alloc..boxed..Box$LT$std..io..error..Custom$GT$$GT$$GT$17h388fe8ddc3471f56E
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN78_$LT$std..io..error..repr_bitpacked..Repr$u20$as$u20$core..ops..drop..Drop$GT$4drop28_$u7b$$u7b$closure$u7d$$u7d$17hd2fdf1e1cdc51692E:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	b	LBB75_1
LBB75_1:
	ldr	x0, [sp, #8]
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__ZN79_$LT$std..path..Path$u20$as$u20$core..convert..AsRef$LT$std..path..Path$GT$$GT$6as_ref17h952e60a5282c7cd4E:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__ZN82_$LT$std..path..PathBuf$u20$as$u20$core..convert..AsRef$LT$std..path..Path$GT$$GT$6as_ref17h100c3fa95df9718bE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	adrp	x1, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.38@PAGE
	add	x1, x1, l_anon.18ad36a50f13f88baf05d571fe7ce6aa.38@PAGEOFF
	bl	__ZN105_$LT$std..ffi..os_str..OsString$u20$as$u20$core..ops..index..Index$LT$core..ops..range..RangeFull$GT$$GT$5index17h1dec72028b824705E
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN87_$LT$T$u20$as$u20$alloc..slice..$LT$impl$u20$$u5b$T$u5d$$GT$..to_vec_in..ConvertVec$GT$6to_vec17h6f0a9d6aa1c9c869E:
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
	bl	__ZN5alloc7raw_vec20RawVecInner$LT$A$GT$16with_capacity_in17h8aef98f8ca2a01c5E
	ldr	x8, [sp, #16]
	mov	x9, x1
	ldur	x1, [x29, #-8]
	str	x0, [x8]
	str	x9, [x8, #8]
	str	xzr, [x8, #16]
	subs	x8, x1, #0
	b.hi	LBB78_2
	b	LBB78_1
LBB78_1:
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB78_2:
	.cfi_restore_state
	ldr	x8, [sp, #16]
	ldr	x8, [x8, #8]
	str	x8, [sp]
	b	LBB78_3
LBB78_3:
	ldr	x1, [sp, #8]
	ldr	x0, [sp]
	ldur	x8, [x29, #-8]
	lsr	x2, x8, #0
	bl	_memcpy
	b	LBB78_4
LBB78_4:
	ldur	x8, [x29, #-8]
	ldr	x9, [sp, #16]
	str	x8, [x9, #16]
	b	LBB78_1
	.cfi_endproc

	.p2align	2
__ZN89_$LT$core..ops..range..Range$LT$T$GT$$u20$as$u20$core..iter..range..RangeIteratorImpl$GT$9spec_next17h00c7265f59214bf0E:
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
	b.lo	LBB79_2
	b	LBB79_1
LBB79_1:
	stur	xzr, [x29, #-16]
	b	LBB79_3
LBB79_2:
	ldr	x8, [sp, #24]
	ldr	x0, [x8]
	str	x0, [sp, #8]
	mov	w8, #1
	mov	x1, x8
	str	x1, [sp, #16]
	bl	__ZN49_$LT$usize$u20$as$u20$core..iter..range..Step$GT$17forward_unchecked17hfc2198376e3e33daE
	ldr	x10, [sp, #24]
	ldr	x9, [sp, #8]
	ldr	x8, [sp, #16]
	str	x0, [x10]
	stur	x9, [x29, #-8]
	stur	x8, [x29, #-16]
	b	LBB79_3
LBB79_3:
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

	.globl	_main
	.p2align	2
_main:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x2, x1
	mov	x8, x0
	sxtw	x1, w8
	adrp	x0, __ZN18build_script_build4main17hfbafbc7f444bf7e2E@PAGE
	add	x0, x0, __ZN18build_script_build4main17hfbafbc7f444bf7e2E@PAGEOFF
	mov	w3, #0
	bl	__ZN3std2rt10lang_start17h092b65f5e5368486E
	ldp	x29, x30, [sp], #16
	ret
	.cfi_endproc

	.section	__TEXT,__const
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.0:
	.ascii	"OUT_DIR"

	.section	__TEXT,__cstring,cstring_literals
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.1:
	.asciz	"/Users/kuangtalin/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/crunchy-0.2.4/build.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.2:
	.quad	l_anon.18ad36a50f13f88baf05d571fe7ce6aa.1
	.asciz	"]\000\000\000\000\000\000\000\027\000\000\000'\000\000"

	.section	__TEXT,__const
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.3:
	.ascii	"lib.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.4:
	.quad	l_anon.18ad36a50f13f88baf05d571fe7ce6aa.1
	.asciz	"]\000\000\000\000\000\000\000\031\000\000\000*\000\000"

	.section	__TEXT,__const
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.5:
	.ascii	"\n/// Unroll the given for loop\n///\n/// Example:\n///\n/// ```ignore\n/// unroll! {\n///   for i in 0..5 {\n///     println!(\"Iteration {}\", i);\n///   }\n/// }\n/// ```\n///\n/// will expand into:\n///\n/// ```ignore\n/// { println!(\"Iteration {}\", 0); }\n/// { println!(\"Iteration {}\", 1); }\n/// { println!(\"Iteration {}\", 2); }\n/// { println!(\"Iteration {}\", 3); }\n/// { println!(\"Iteration {}\", 4); }\n/// ```\n#[macro_export]\nmacro_rules! unroll {\n    (for $v:ident in 0..0 $c:block) => {};\n\n    (for $v:ident < $max:tt in ($start:tt..$end:tt).step_by($val:expr) {$($c:tt)*}) => {\n        {\n            let step = $val;\n            let start = $start;\n            let end = start + ($end - start) / step;\n            unroll! {\n                for val < $max in start..end {\n                    let $v: usize = ((val - start) * step) + start;\n\n                    $($c)*\n                }\n            }\n        }\n    };\n\n    (for $v:ident in ($start:tt..$end:tt).step_by($val:expr) {$($c:tt)*}) => {\n        unroll! {\n            for $v < $end in ($start..$end).step_by($val) {$($c)*}\n        }\n    };\n\n    (for $v:ident in ($start:tt..$end:tt) {$($c:tt)*}) => {\n        unroll!{\n            for $v in $start..$end {$($c)*}\n        }\n    };\n\n    (for $v:ident in $start:tt..$end:tt {$($c:tt)*}) => {\n        #[allow(non_upper_case_globals)]\n        #[allow(unused_comparisons)]\n        {\n            unroll!(@$v, 0, $end, {\n                    if $v >= $start {$($c)*}\n                }\n            );\n        }\n    };\n\n    (for $v:ident < $max:tt in $start:tt..$end:tt $c:block) => {\n        #[allow(non_upper_case_globals)]\n        {\n            let range = $start..$end;\n            assert!(\n                $max >= range.end,\n                \"`{}` out of range `{:?}`\",\n                stringify!($max),\n                range,\n            );\n            unroll!(\n                @$v,\n                0,\n                $max,\n                {\n                    if $v >= range.start && $v < range.end {\n                        $c\n                    }\n                }\n            );\n        }\n    };\n\n    (for $v:ident in 0..$end:tt {$($statement:tt)*}) => {\n        #[allow(non_upper_case_globals)]\n        { unroll!(@$v, 0, $end, {$($statement)*}); }\n    };\n\n"

l_anon.18ad36a50f13f88baf05d571fe7ce6aa.6:
	.ascii	"}\n\n"

l_anon.18ad36a50f13f88baf05d571fe7ce6aa.7:
	.asciz	"\200b\005\n#[cfg(all(test, feature = \"std\"))]\nmod tests {\n    #[test]\n    fn invalid_range() {\n        let mut a: Vec<usize> = vec![];\n        unroll! {\n                for i in (5..4) {\n                    a.push(i);\n                }\n            }\n        assert_eq!(a, vec![]);\n    }\n\n    #[test]\n    fn start_at_one_with_step() {\n        let mut a: Vec<usize> = vec![];\n        unroll! {\n                for i in (2..4).step_by(1) {\n                    a.push(i);\n                }\n            }\n        assert_eq!(a, vec![2, 3]);\n    }\n\n    #[test]\n    fn start_at_one() {\n        let mut a: Vec<usize> = vec![];\n        unroll! {\n                for i in 1..4 {\n                    a.push(i);\n                }\n            }\n        assert_eq!(a, vec![1, 2, 3]);\n    }\n\n    #[test]\n    fn test_all() {\n        {\n            let a: Vec<usize> = vec![];\n            unroll! {\n                for i in 0..0 {\n                    a.push(i);\n                }\n            }\n            assert_eq!(a, (0..0).collect::<Vec<usize>>());\n        }\n        {\n            let mut a: Vec<usize> = vec![];\n            unroll! {\n                for i in 0..1 {\n                    a.push(i);\n                }\n            }\n            assert_eq!(a, (0..1).collect::<Vec<usize>>());\n        }\n        {\n            let mut a: Vec<usize> = vec![];\n            unroll! {\n                for i in 0..\300` {\n                    a.push(i);\n                }\n            }\n            assert_eq!(a, (0..\310\000\000t).collect::<Vec<usize>>());\n        }\n        {\n            let mut a: Vec<usize> = vec![];\n            let start = \310\000\000U / 4;\n            let end = start * 3;\n            unroll! {\n                for i < \310\000\000\200\004\001 in start..end {\n                    a.push(i);\n                }\n            }\n            assert_eq!(a, (start..end).collect::<Vec<usize>>());\n        }\n        {\n            let mut a: Vec<usize> = vec![];\n            unroll! {\n                for i in (0..\310\000\000l).step_by(2) {\n                    a.push(i);\n                }\n            }\n            assert_eq!(a, (0..\310\000\000\200\207\000 / 2).map(|x| x * 2).collect::<Vec<usize>>());\n        }\n        {\n            let mut a: Vec<usize> = vec![];\n            let start = \310\000\000U / 4;\n            let end = start * 3;\n            unroll! {\n                for i < \310\000\000\200\307\000 in (start..end).step_by(2) {\n                    a.push(i);\n                }\n            }\n            assert_eq!(a, (start..end).filter(|x| x % 2 == 0).collect::<Vec<usize>>());\n        }\n    }\n}\n"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.8:
	.quad	l_anon.18ad36a50f13f88baf05d571fe7ce6aa.1
	.asciz	"]\000\000\000\000\000\000\000\374\000\000\000$\000\000"

	.section	__TEXT,__literal4,4byte_literals
	.p2align	2, 0x0
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.9:
	.asciz	"/\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.10:
	.asciz	"#cargo:rustc-env=CRUNCHY_LIB_SUFFIX=\300\007lib.rs\n"

l_anon.18ad36a50f13f88baf05d571fe7ce6aa.11:
	.asciz	"\031    (@$v:ident, $a:expr, \300\021, $c:block) => {\n"

l_anon.18ad36a50f13f88baf05d571fe7ce6aa.12:
	.asciz	"\031        unroll!(@$v, $a, \300\007, $c);\n"

l_anon.18ad36a50f13f88baf05d571fe7ce6aa.13:
	.asciz	"!        { const $v: usize = $a + \300\007; $c }\n"

	.section	__TEXT,__const
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.14:
	.asciz	"\032        unroll!(@$v, $a + \300\002, \310\000\000\007, $c);\n"

l_anon.18ad36a50f13f88baf05d571fe7ce6aa.15:
	.ascii	"        { const $v: usize = $a; $c }\n"

	.section	__TEXT,__literal8,8byte_literals
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.16:
	.ascii	"    };\n\n"

	.section	__TEXT,__const
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.17:
	.ascii	"failed to write whole buffer"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.18:
	.quad	l_anon.18ad36a50f13f88baf05d571fe7ce6aa.17
	.ascii	"\034\000\000\000\000\000\000\000\027"
	.space	7

	.section	__TEXT,__cstring,cstring_literals
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.19:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/io/mod.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.20:
	.quad	l_anon.18ad36a50f13f88baf05d571fe7ce6aa.19
	.asciz	"o\000\000\000\000\000\000\000G\007\000\000$\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.21:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/io/error/repr_bitpacked.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.22:
	.quad	l_anon.18ad36a50f13f88baf05d571fe7ce6aa.21
	.asciz	"\200\000\000\000\000\000\000\000\b\001\000\000\032\000\000"

	.section	__TEXT,__const
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.23:
	.ascii	"internal error: entered unreachable code"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.24:
	.quad	l_anon.18ad36a50f13f88baf05d571fe7ce6aa.21
	.asciz	"\200\000\000\000\000\000\000\000\031\001\000\000\r\000\000"

	.p2align	3, 0x0
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.25:
	.asciz	"\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	__ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h632ea207a50dad95E
	.quad	__ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h8bf8379636839148E
	.quad	__ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h8bf8379636839148E

	.section	__TEXT,__const
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.26:
	.ascii	"unsafe precondition(s) violated: hint::unreachable_unchecked must never be reached\n\nThis indicates a bug in the program. This Undefined Behavior check is optional, and cannot be relied on for safety."

l_anon.18ad36a50f13f88baf05d571fe7ce6aa.27:
	.ascii	"assertion failed: 0 < pointee_size && pointee_size <= isize::MAX as usize"

	.section	__TEXT,__cstring,cstring_literals
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.28:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/non_null.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.29:
	.quad	l_anon.18ad36a50f13f88baf05d571fe7ce6aa.28
	.asciz	"v\000\000\000\000\000\000\000\271\003\000\000 \000\000"

	.p2align	3, 0x0
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.30:
	.quad	__ZN4core3ptr42drop_in_place$LT$std..io..error..Error$GT$17h33aedbd423127ae0E
	.asciz	"\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	__RNvXNtNtCsaLOjE9VYtxK_3std2io5errorNtB2_5ErrorNtNtCs6sq8b9ugfBC_4core3fmt5Debug3fmt

	.section	__TEXT,__const
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.31:
	.ascii	"called `Result::unwrap()` on an `Err` value"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.32:
	.quad	__ZN4core3ptr39drop_in_place$LT$std..env..VarError$GT$17hba116970859ad9c9E
	.asciz	"\030\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	__ZN55_$LT$std..env..VarError$u20$as$u20$core..fmt..Debug$GT$3fmt17h89463dfd02c0cd6cE

	.section	__TEXT,__const
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.33:
	.ascii	"NotPresent"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.34:
	.asciz	"\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	__ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h97167d2701c96bcdE

	.section	__TEXT,__const
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.35:
	.ascii	"NotUnicode"

	.section	__TEXT,__literal16,16byte_literals
	.p2align	3, 0x0
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.36:
	.space	8
	.space	8

	.section	__TEXT,__cstring,cstring_literals
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.37:
	.asciz	"/Users/kuangtalin/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/ffi/os_str.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.18ad36a50f13f88baf05d571fe7ce6aa.38:
	.quad	l_anon.18ad36a50f13f88baf05d571fe7ce6aa.37
	.asciz	"s\000\000\000\000\000\000\000\251\002\000\000\016\000\000"

.subsections_via_symbols
