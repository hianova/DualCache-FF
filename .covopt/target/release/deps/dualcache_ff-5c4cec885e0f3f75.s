	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN12dualcache_ff4core4qsbr13get_min_epoch17hb91b024aab4e4869E
	.p2align	2
__ZN12dualcache_ff4core4qsbr13get_min_epoch17hb91b024aab4e4869E:
	.cfi_startproc
Lloh0:
	adrp	x8, __ZN12dualcache_ff4core4qsbr12GLOBAL_EPOCH17h5e65f850368032f2E@PAGE
Lloh1:
	add	x8, x8, __ZN12dualcache_ff4core4qsbr12GLOBAL_EPOCH17h5e65f850368032f2E@PAGEOFF
	ldapr	x0, [x8]
Lloh2:
	adrp	x8, __ZN12dualcache_ff4core4qsbr13THREAD_STATES17had6adb32f16af365E@PAGE
Lloh3:
	add	x8, x8, __ZN12dualcache_ff4core4qsbr13THREAD_STATES17had6adb32f16af365E@PAGEOFF
	ldapr	x8, [x8]
	cbnz	x8, LBB0_3
LBB0_1:
	ret
LBB0_2:
	ldr	x8, [x8, #24]
	cbz	x8, LBB0_1
LBB0_3:
	add	x8, x8, #64, lsl #12
	add	x9, x8, #1064
	ldaprb	w9, [x9]
	cbz	w9, LBB0_2
	ldapur	x9, [x8, #16]
	cmp	x9, x0
	csel	x0, x9, x0, lo
	b	LBB0_2
	.loh AdrpAdd	Lloh2, Lloh3
	.loh AdrpAdd	Lloh0, Lloh1
	.cfi_endproc

	.globl	__ZN12dualcache_ff4core4qsbr13register_node17h3ac9901331921d80E
	.p2align	2
__ZN12dualcache_ff4core4qsbr13register_node17h3ac9901331921d80E:
	.cfi_startproc
Lloh4:
	adrp	x8, __ZN12dualcache_ff4core4qsbr13THREAD_STATES17had6adb32f16af365E@PAGE
Lloh5:
	add	x8, x8, __ZN12dualcache_ff4core4qsbr13THREAD_STATES17had6adb32f16af365E@PAGEOFF
	ldapr	x11, [x8]
	mov	w9, #24
	movk	w9, #4, lsl #16
	str	x11, [x0, x9]
	mov	x10, x11
	casl	x10, x0, [x8]
	cmp	x10, x11
	b.eq	LBB1_3
	mov	x11, x10
LBB1_2:
	isb
	str	x10, [x0, x9]
	casl	x11, x0, [x8]
	cmp	x11, x10
	mov	x10, x11
	b.ne	LBB1_2
LBB1_3:
	ret
	.loh AdrpAdd	Lloh4, Lloh5
	.cfi_endproc

	.globl	__ZN12dualcache_ff4core4qsbr3pin17h817175ff5d4f8509E
	.p2align	2
__ZN12dualcache_ff4core4qsbr3pin17h817175ff5d4f8509E:
	.cfi_startproc
	add	x8, x0, #64, lsl #12
Lloh6:
	adrp	x9, __ZN12dualcache_ff4core4qsbr12GLOBAL_EPOCH17h5e65f850368032f2E@PAGE
Lloh7:
	add	x9, x9, __ZN12dualcache_ff4core4qsbr12GLOBAL_EPOCH17h5e65f850368032f2E@PAGEOFF
	ldapr	x9, [x9]
	stlur	x9, [x8, #16]
	add	x8, x8, #1064
	mov	w9, #1
	stlrb	w9, [x8]
	ret
	.loh AdrpAdd	Lloh6, Lloh7
	.cfi_endproc

	.globl	__ZN12dualcache_ff4core4qsbr5reset17hbecc72c95757abacE
	.p2align	2
__ZN12dualcache_ff4core4qsbr5reset17hbecc72c95757abacE:
	.cfi_startproc
Lloh8:
	adrp	x8, __ZN12dualcache_ff4core4qsbr12GLOBAL_EPOCH17h5e65f850368032f2E@PAGE
Lloh9:
	add	x8, x8, __ZN12dualcache_ff4core4qsbr12GLOBAL_EPOCH17h5e65f850368032f2E@PAGEOFF
	mov	w9, #1
	stlr	x9, [x8]
Lloh10:
	adrp	x8, __ZN12dualcache_ff4core4qsbr13THREAD_STATES17had6adb32f16af365E@PAGE
Lloh11:
	add	x8, x8, __ZN12dualcache_ff4core4qsbr13THREAD_STATES17had6adb32f16af365E@PAGEOFF
	stlr	xzr, [x8]
	ret
	.loh AdrpAdd	Lloh10, Lloh11
	.loh AdrpAdd	Lloh8, Lloh9
	.cfi_endproc

	.globl	__ZN12dualcache_ff4core4qsbr6retire17h5ec046be56f79f53E
	.p2align	2
__ZN12dualcache_ff4core4qsbr6retire17h5ec046be56f79f53E:
	.cfi_startproc
Lloh12:
	adrp	x8, __ZN12dualcache_ff4core4qsbr12GLOBAL_EPOCH17h5e65f850368032f2E@PAGE
Lloh13:
	add	x8, x8, __ZN12dualcache_ff4core4qsbr12GLOBAL_EPOCH17h5e65f850368032f2E@PAGEOFF
	ldapr	x8, [x8]
	mov	w9, #262144
	ldr	x10, [x1, x9]
	and	x11, x10, #0x3fff
	add	x11, x1, x11, lsl #4
	str	x8, [x11]
	str	w0, [x11, #8]
	add	x8, x10, #1
	str	x8, [x1, x9]
	ret
	.loh AdrpAdd	Lloh12, Lloh13
	.cfi_endproc

	.globl	__ZN73_$LT$dualcache_ff..core..qsbr..Guard$u20$as$u20$core..ops..drop..Drop$GT$4drop17h250bf38a75b19479E
	.p2align	2
__ZN73_$LT$dualcache_ff..core..qsbr..Guard$u20$as$u20$core..ops..drop..Drop$GT$4drop17h250bf38a75b19479E:
	.cfi_startproc
	ldr	x8, [x0]
	add	x8, x8, #64, lsl #12
	add	x8, x8, #1064
	stlrb	wzr, [x8]
	ret
	.cfi_endproc

	.section	__DATA,__data
	.globl	__ZN12dualcache_ff4core4qsbr12GLOBAL_EPOCH17h5e65f850368032f2E
	.p2align	3, 0x0
__ZN12dualcache_ff4core4qsbr12GLOBAL_EPOCH17h5e65f850368032f2E:
	.asciz	"\001\000\000\000\000\000\000"

.zerofill __DATA,__bss,__ZN12dualcache_ff4core4qsbr13THREAD_STATES17had6adb32f16af365E,8,3
	.globl	__ZN12dualcache_ff4core4qsbr5Guard3new17he22996a84c8a7fffE
__ZN12dualcache_ff4core4qsbr5Guard3new17he22996a84c8a7fffE = __ZN12dualcache_ff4core4qsbr3pin17h817175ff5d4f8509E
.subsections_via_symbols
