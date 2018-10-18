	.file	"loop.c"
.global __floatdidf
	.section	.rodata, "a"
	.align 8
.LC0:
	.string	"Average time to run 1000 loops= %lf microseconds\n"
.global __divdf3
	.text
	.align 8
.global main
	.type	main, @function
main:
.LFB0:
	st	sp, lr
.LCFI0:
	move	r29, r52
.LCFI1:
	move	r52, sp
.LCFI2:
	addi	r28, sp, -104
	addi	sp, sp, -112
.LCFI3:
	st	r28, r52
	addi	r27, r52, -8
	st	r27, r29
.LCFI4:
	addi	r26, r52, -16
	st	r26, r30
.LCFI5:
	addi	r2, r52, -96
	st	r2, r1
	addxi	r1, r0, 0
	addi	r0, r52, -84
	st4	r0, r1
	addi	r0, r52, -96
	ld	r0, r0
	addi	r0, r0, 8
	ld	r0, r0
	jal	atoi
	move	r1, r0
	addi	r0, r52, -56
	st4	r0, r1
	addi	r0, r52, -52
	moveli	r1, 1000
	st4	r0, r1
	addi	r0, r52, -24
	st	r0, zero
	addi	r0, r52, -48
	st4	r0, zero
	j	.L2
.L5:
	addi	r1, r52, -72
	movei	r0, 3
	jal	clock_gettime
	addi	r0, r52, -72
	ld	r0, r0
	jal	__floatdidf
	moveli	r1, 16845
	shl16insli	r1, r1, -12955
	shli	r3, r1, 32
	fdouble_unpack_max	r1, r0, zero
	fdouble_unpack_max	r2, r3, zero
	fdouble_mul_flags	r3, r0, r3
	mul_lu_lu	r5, r1, r2
	mul_hu_lu	r0, r1, r2
	mula_hu_lu	r0, r2, r1
	mul_hu_hu	r1, r1, r2
	shli	r2, r0, 32
	shrui	r0, r0, 32
	add	r4, r1, r0
	add	r1, r5, r2
	cmpltu	r0, r1, r2
	add	r0, r4, r0
	fdouble_pack1	r30, r0, r3
	fdouble_pack2	r30, r0, r1
	addi	r0, r52, -72
	addi	r0, r0, 8
	ld	r0, r0
	jal	__floatdidf
	move	r1, r0
	addi	r2, r52, -40
	fdouble_unpack_min	r3, r30, r1
	fdouble_unpack_max	r0, r30, r1
	fdouble_add_flags	r1, r30, r1
	fdouble_addsub	r0, r3, r1
	fdouble_pack1	r1, r0, r1
	fdouble_pack2	r1, r0, zero
	st	r2, r1
	addi	r0, r52, -44
	st4	r0, zero
	j	.L3
.L4:
	addi	r0, r52, -44
	addi	r1, r52, -44
	ld4s	r1, r1
	addxi	r1, r1, 1
	st4	r0, r1
.L3:
	addi	r0, r52, -44
	ld4s	r0, r0
	moveli	r1, 999
	cmples	r0, r0, r1
	bnez	r0, .L4
	addi	r1, r52, -72
	movei	r0, 3
	jal	clock_gettime
	addi	r0, r52, -72
	ld	r0, r0
	jal	__floatdidf
	moveli	r1, 16845
	shl16insli	r1, r1, -12955
	shli	r3, r1, 32
	fdouble_unpack_max	r1, r0, zero
	fdouble_unpack_max	r2, r3, zero
	fdouble_mul_flags	r3, r0, r3
	mul_lu_lu	r5, r1, r2
	mul_hu_lu	r0, r1, r2
	mula_hu_lu	r0, r2, r1
	mul_hu_hu	r1, r1, r2
	shli	r2, r0, 32
	shrui	r0, r0, 32
	add	r4, r1, r0
	add	r1, r5, r2
	cmpltu	r0, r1, r2
	add	r0, r4, r0
	fdouble_pack1	r30, r0, r3
	fdouble_pack2	r30, r0, r1
	addi	r0, r52, -72
	addi	r0, r0, 8
	ld	r0, r0
	jal	__floatdidf
	move	r1, r0
	addi	r2, r52, -32
	fdouble_unpack_min	r3, r30, r1
	fdouble_unpack_max	r0, r30, r1
	fdouble_add_flags	r1, r30, r1
	fdouble_addsub	r0, r3, r1
	fdouble_pack1	r1, r0, r1
	fdouble_pack2	r1, r0, zero
	st	r2, r1
	addi	r3, r52, -24
	addi	r1, r52, -32
	addi	r0, r52, -40
	ld	r1, r1
	ld	r2, r0
	fdouble_unpack_min	r4, r1, r2
	fdouble_unpack_max	r0, r1, r2
	fdouble_sub_flags	r1, r1, r2
	fdouble_addsub	r0, r4, r1
	fdouble_pack1	r1, r0, r1
	fdouble_pack2	r1, r0, zero
	st	r3, r1
	moveli	r0, hw2_last(.LC0)
	shl16insli	r0, r0, hw1(.LC0)
	shl16insli	r30, r0, hw0(.LC0)
	addi	r0, r52, -24
	movei	r1, 1
	shl16insli	r1, r1, 573
	ld	r0, r0
	shli	r1, r1, 46
	jal	__divdf3
	move	r1, r0
	move	r0, r30
	jal	printf
	addi	r0, r52, -48
	addi	r1, r52, -48
	ld4s	r1, r1
	addxi	r1, r1, 1
	st4	r0, r1
.L2:
	addi	r1, r52, -48
	addi	r0, r52, -56
	ld4s	r1, r1
	ld4s	r0, r0
	cmplts	r0, r1, r0
	bnez	r0, .L5
	ld	lr, r52
	addi	r28, r52, -8
	ld	r29, r28
	addi	r27, r52, -16
	ld	r30, r27
	move	sp, r52
.LCFI6:
	move	r52, r29
	jrp	lr
.LFE0:
	.size	main, .-main
	.section	.eh_frame,"a",@progbits
.Lframe1:
	.4byte	.LECIE1-.LSCIE1
.LSCIE1:
	.4byte	0x0
	.byte	0x1
	.string	"zR"
	.uleb128 0x1
	.sleb128 -8
	.byte	0x37
	.uleb128 0x1
	.byte	0x1c
	.byte	0xc
	.uleb128 0x36
	.uleb128 0x0
	.align 8
.LECIE1:
.LSFDE1:
	.4byte	.LEFDE1-.LASFDE1
.LASFDE1:
	.4byte	.LASFDE1-.Lframe1
	.8byte	.LFB0-.
	.8byte	.LFE0-.LFB0
	.uleb128 0x0
	.byte	0x4
	.4byte	.LCFI1-.LFB0
	.byte	0x9
	.uleb128 0x34
	.uleb128 0x1d
	.byte	0xb7
	.uleb128 0x0
	.byte	0x4
	.4byte	.LCFI2-.LCFI1
	.byte	0xd
	.uleb128 0x34
	.byte	0x4
	.4byte	.LCFI5-.LCFI2
	.byte	0x11
	.uleb128 0x1e
	.sleb128 2
	.byte	0x11
	.uleb128 0x34
	.sleb128 1
	.byte	0x4
	.4byte	.LCFI6-.LCFI5
	.byte	0xd
	.uleb128 0x36
	.align 8
.LEFDE1:
	.ident	"GCC: (GNU) 4.4.7 20131017 (Tilera 4.4.7-3)"
	.section	.note.GNU-stack,"",@progbits
