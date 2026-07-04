	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN5ahash12random_state11RandomState9from_keys17h06350b0dec3cec0aE
	.p2align	2
__ZN5ahash12random_state11RandomState9from_keys17h06350b0dec3cec0aE:
	.cfi_startproc
	ldp	x9, x10, [x0]
	eor	x11, x10, x2
	mov	x10, #32557
	movk	x10, #19605, lsl #16
	movk	x10, #62509, lsl #32
	movk	x10, #22609, lsl #48
	mul	x12, x11, x10
	umulh	x11, x11, x10
	eor	x12, x11, x12
	ldp	x11, x13, [x1]
	eor	x14, x11, x12
	mul	x15, x14, x10
	umulh	x14, x14, x10
	eor	x14, x14, x15
	ldp	x15, x16, [x1, #16]
	eor	x14, x15, x14
	mul	x17, x14, x10
	umulh	x14, x14, x10
	eor	x14, x14, x17
	mul	x17, x14, x9
	umulh	x0, x14, x9
	eor	x17, x0, x17
	neg	w14, w14
	ror	x14, x17, x14
	eor	x17, x13, x12
	mul	x0, x17, x10
	umulh	x17, x17, x10
	eor	x17, x17, x0
	eor	x17, x16, x17
	mul	x0, x17, x10
	umulh	x17, x17, x10
	eor	x17, x17, x0
	mul	x0, x17, x9
	umulh	x1, x17, x9
	eor	x0, x1, x0
	neg	w17, w17
	ror	x17, x0, x17
	eor	x15, x15, x12
	mul	x0, x15, x10
	umulh	x15, x15, x10
	eor	x15, x15, x0
	eor	x13, x13, x15
	mul	x15, x13, x10
	umulh	x13, x13, x10
	eor	x13, x13, x15
	mul	x15, x13, x9
	umulh	x0, x13, x9
	eor	x15, x0, x15
	neg	w13, w13
	ror	x13, x15, x13
	eor	x12, x16, x12
	mul	x15, x12, x10
	umulh	x12, x12, x10
	eor	x12, x12, x15
	eor	x11, x11, x12
	mul	x12, x11, x10
	umulh	x10, x11, x10
	eor	x10, x10, x12
	mul	x11, x10, x9
	umulh	x9, x10, x9
	eor	x9, x9, x11
	neg	w10, w10
	stp	x14, x17, [x8]
	ror	x9, x9, x10
	stp	x13, x9, [x8, #16]
	ret
	.cfi_endproc

	.globl	__ZN69_$LT$ahash..random_state..RandomState$u20$as$u20$core..fmt..Debug$GT$3fmt17he58cc230e075f765E
	.p2align	2
__ZN69_$LT$ahash..random_state..RandomState$u20$as$u20$core..fmt..Debug$GT$3fmt17he58cc230e075f765E:
	.cfi_startproc
	mov	x0, x1
Lloh0:
	adrp	x1, l_anon.817ec601f1ebf076782f0efd4227853f.0@PAGE
Lloh1:
	add	x1, x1, l_anon.817ec601f1ebf076782f0efd4227853f.0@PAGEOFF
	mov	w2, #18
	b	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter3pad
	.loh AdrpAdd	Lloh0, Lloh1
	.cfi_endproc

	.globl	__ZN5ahash12random_state11RAND_SOURCE17hab0a26bbacca1ce3E
.zerofill __DATA,__common,__ZN5ahash12random_state11RAND_SOURCE17hab0a26bbacca1ce3E,8,3
	.section	__TEXT,__const
l_anon.817ec601f1ebf076782f0efd4227853f.0:
	.ascii	"RandomState { .. }"

.subsections_via_symbols
