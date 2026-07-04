	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN4libc4unix3bsd5apple14mach_task_self17h13cd9db8df8a1ca1E
	.p2align	2
__ZN4libc4unix3bsd5apple14mach_task_self17h13cd9db8df8a1ca1E:
	.cfi_startproc
	adrp	x8, _mach_task_self_@GOTPAGE
	ldr	x8, [x8, _mach_task_self_@GOTPAGEOFF]
	ldr	w0, [x8]
	ret
	.cfi_endproc

	.globl	__ZN4libc4unix3bsd5apple16__DARWIN_ALIGN3217hb29af8e26bbc884dE
	.p2align	2
__ZN4libc4unix3bsd5apple16__DARWIN_ALIGN3217hb29af8e26bbc884dE:
	.cfi_startproc
	add	x8, x0, #3
	and	x0, x8, #0xfffffffffffffffc
	ret
	.cfi_endproc

	.globl	__ZN4libc4unix3bsd5apple9siginfo_t6si_pid17h04f1a864cc015a59E
	.p2align	2
__ZN4libc4unix3bsd5apple9siginfo_t6si_pid17h04f1a864cc015a59E:
	.cfi_startproc
	ldr	w0, [x0, #12]
	ret
	.cfi_endproc

	.globl	__ZN4libc4unix3bsd5apple9siginfo_t6si_uid17h23ee5c2b4689fb5eE
	.p2align	2
__ZN4libc4unix3bsd5apple9siginfo_t6si_uid17h23ee5c2b4689fb5eE:
	.cfi_startproc
	ldr	w0, [x0, #16]
	ret
	.cfi_endproc

	.globl	__ZN4libc4unix3bsd5apple9siginfo_t7si_addr17hd94dc77af6465190E
	.p2align	2
__ZN4libc4unix3bsd5apple9siginfo_t7si_addr17hd94dc77af6465190E:
	.cfi_startproc
	ldr	x0, [x0, #24]
	ret
	.cfi_endproc

	.globl	__ZN4libc4unix3bsd5apple9siginfo_t8si_value17h1a58a93f25b624bfE
	.p2align	2
__ZN4libc4unix3bsd5apple9siginfo_t8si_value17h1a58a93f25b624bfE:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldr	x8, [x0, #32]
	str	x8, [sp, #8]
	ldr	x0, [sp, #8]
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.globl	__ZN4libc4unix3bsd5apple9siginfo_t9si_status17hf72b47eacf2fab17E
	.p2align	2
__ZN4libc4unix3bsd5apple9siginfo_t9si_status17hf72b47eacf2fab17E:
	.cfi_startproc
	ldr	w0, [x0, #20]
	ret
	.cfi_endproc

	.globl	__ZN66_$LT$libc..unix..bsd..apple..semun$u20$as$u20$core..fmt..Debug$GT$3fmt17hd62cd1c174285fcdE
	.p2align	2
__ZN66_$LT$libc..unix..bsd..apple..semun$u20$as$u20$core..fmt..Debug$GT$3fmt17hd62cd1c174285fcdE:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x0, x1
	add	x8, sp, #16
	str	x8, [sp, #8]
	adrp	x1, l_anon.b643b7746134e60ecf6ecd95d9ebd8d6.0@PAGE
	add	x1, x1, l_anon.b643b7746134e60ecf6ecd95d9ebd8d6.0@PAGEOFF
	mov	w9, #5
	mov	x2, x9
	bl	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter12debug_struct
	ldr	x0, [sp, #8]
	bl	__RNvMs1_NtNtCs6sq8b9ugfBC_4core3fmt8buildersNtB5_11DebugStruct21finish_non_exhaustive
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN83_$LT$libc..unix..bsd..apple..__c_anonymous_ifc_ifcu$u20$as$u20$core..fmt..Debug$GT$3fmt17h9216933a22f45121E
	.p2align	2
__ZN83_$LT$libc..unix..bsd..apple..__c_anonymous_ifc_ifcu$u20$as$u20$core..fmt..Debug$GT$3fmt17h9216933a22f45121E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x0, x1
	add	x8, sp, #16
	str	x8, [sp, #8]
	adrp	x1, l_anon.b643b7746134e60ecf6ecd95d9ebd8d6.1@PAGE
	add	x1, x1, l_anon.b643b7746134e60ecf6ecd95d9ebd8d6.1@PAGEOFF
	mov	w9, #22
	mov	x2, x9
	bl	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter12debug_struct
	ldr	x0, [sp, #8]
	bl	__RNvMs1_NtNtCs6sq8b9ugfBC_4core3fmt8buildersNtB5_11DebugStruct21finish_non_exhaustive
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN83_$LT$libc..unix..bsd..apple..__c_anonymous_ifk_data$u20$as$u20$core..fmt..Debug$GT$3fmt17h59dad8887c980ba3E
	.p2align	2
__ZN83_$LT$libc..unix..bsd..apple..__c_anonymous_ifk_data$u20$as$u20$core..fmt..Debug$GT$3fmt17h59dad8887c980ba3E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x0, x1
	add	x8, sp, #16
	str	x8, [sp, #8]
	adrp	x1, l_anon.b643b7746134e60ecf6ecd95d9ebd8d6.2@PAGE
	add	x1, x1, l_anon.b643b7746134e60ecf6ecd95d9ebd8d6.2@PAGEOFF
	mov	w9, #22
	mov	x2, x9
	bl	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter12debug_struct
	ldr	x0, [sp, #8]
	bl	__RNvMs1_NtNtCs6sq8b9ugfBC_4core3fmt8buildersNtB5_11DebugStruct21finish_non_exhaustive
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN83_$LT$libc..unix..bsd..apple..__c_anonymous_ifr_ifru$u20$as$u20$core..fmt..Debug$GT$3fmt17hae8fd13acc2e3cc2E
	.p2align	2
__ZN83_$LT$libc..unix..bsd..apple..__c_anonymous_ifr_ifru$u20$as$u20$core..fmt..Debug$GT$3fmt17hae8fd13acc2e3cc2E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x0, x1
	add	x8, sp, #16
	str	x8, [sp, #8]
	adrp	x1, l_anon.b643b7746134e60ecf6ecd95d9ebd8d6.3@PAGE
	add	x1, x1, l_anon.b643b7746134e60ecf6ecd95d9ebd8d6.3@PAGEOFF
	mov	w9, #22
	mov	x2, x9
	bl	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter12debug_struct
	ldr	x0, [sp, #8]
	bl	__RNvMs1_NtNtCs6sq8b9ugfBC_4core3fmt8buildersNtB5_11DebugStruct21finish_non_exhaustive
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN84_$LT$libc..unix..bsd..apple..__c_anonymous_ifr_ifru6$u20$as$u20$core..fmt..Debug$GT$3fmt17haa518c8258195533E
	.p2align	2
__ZN84_$LT$libc..unix..bsd..apple..__c_anonymous_ifr_ifru6$u20$as$u20$core..fmt..Debug$GT$3fmt17haa518c8258195533E:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x0, x1
	add	x8, sp, #16
	str	x8, [sp, #8]
	adrp	x1, l_anon.b643b7746134e60ecf6ecd95d9ebd8d6.4@PAGE
	add	x1, x1, l_anon.b643b7746134e60ecf6ecd95d9ebd8d6.4@PAGEOFF
	mov	w9, #23
	mov	x2, x9
	bl	__RNvMsa_NtCs6sq8b9ugfBC_4core3fmtNtB5_9Formatter12debug_struct
	ldr	x0, [sp, #8]
	bl	__RNvMs1_NtNtCs6sq8b9ugfBC_4core3fmt8buildersNtB5_11DebugStruct21finish_non_exhaustive
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	__ZN90_$LT$libc..new..apple..libpthread..sys..qos..qos_class_t$u20$as$u20$core..clone..Clone$GT$5clone17hf13effe5146994d4E
	.p2align	2
__ZN90_$LT$libc..new..apple..libpthread..sys..qos..qos_class_t$u20$as$u20$core..clone..Clone$GT$5clone17hf13effe5146994d4E:
	.cfi_startproc
	ldr	w0, [x0]
	ret
	.cfi_endproc

	.globl	__ZN93_$LT$libc..unix..bsd..apple..sysdir_search_path_directory_t$u20$as$u20$core..clone..Clone$GT$5clone17haeb2d6170ccebf98E
	.p2align	2
__ZN93_$LT$libc..unix..bsd..apple..sysdir_search_path_directory_t$u20$as$u20$core..clone..Clone$GT$5clone17haeb2d6170ccebf98E:
	.cfi_startproc
	ldr	w0, [x0]
	ret
	.cfi_endproc

	.globl	__ZN95_$LT$libc..unix..bsd..apple..sysdir_search_path_domain_mask_t$u20$as$u20$core..clone..Clone$GT$5clone17hc212769f21214087E
	.p2align	2
__ZN95_$LT$libc..unix..bsd..apple..sysdir_search_path_domain_mask_t$u20$as$u20$core..clone..Clone$GT$5clone17hc212769f21214087E:
	.cfi_startproc
	ldr	w0, [x0]
	ret
	.cfi_endproc

	.section	__TEXT,__const
l_anon.b643b7746134e60ecf6ecd95d9ebd8d6.0:
	.ascii	"semun"

l_anon.b643b7746134e60ecf6ecd95d9ebd8d6.1:
	.ascii	"__c_anonymous_ifc_ifcu"

l_anon.b643b7746134e60ecf6ecd95d9ebd8d6.2:
	.ascii	"__c_anonymous_ifk_data"

l_anon.b643b7746134e60ecf6ecd95d9ebd8d6.3:
	.ascii	"__c_anonymous_ifr_ifru"

l_anon.b643b7746134e60ecf6ecd95d9ebd8d6.4:
	.ascii	"__c_anonymous_ifr_ifru6"

.subsections_via_symbols
