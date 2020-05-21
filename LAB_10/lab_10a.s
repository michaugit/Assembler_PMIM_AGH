#----------------------------------------------------------------
# Program lab_10a.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#   to compile & link:  gcc -no-pie -lm -o lab_10a lab_10a.s
#   to run: 		./lab_10a
#
#----------------------------------------------------------------

	.data
i:				# loop counter
	.long		1
x:				# function argument
	.double		0.0
y:				# function result
	.double		0.0
sqr_a:				# function result (x87)
	.double		0.0
sqr_b:				# function result (SSE)
	.double		0.0
sqr_c:				# function result (x87 software approximation)
	.double		0.0
two:				# constant
	.long		2

cntr:							#poprawka
	.long		0				#poprawka
cnt_fmt:						#poprawka
	.string		"Iterations =%d\n"		#poprawka

fmt_str:
	.asciz		"Square root of %lf = %.20lf\n"


	.text
	.global main

main:
#	sub $8, %rsp

	FINIT			# FPU initialization
next:
	FILDL	i		# i -> ST(0)
	FSTPL	x		# ST(0) -> x & pop from stack

	FLDL	x		# function argument -> ST(0)
	FSQRT			# sqrt( ST(0) ) -> ST(0)
	FSTPL	sqr_a		# ST(0) -> sqr_a  & pop from stack

	FLDL	sqr_a		# load & display first result
	FSTPL	y

	call	disp		# display x, y

	MOVSD	x, %xmm1	# function argument -> xmm1
	SQRTSD	%xmm1, %xmm0	# sqrt( xmm1 ) -> xmm0
	MOVSD	%xmm0, sqr_b	# xmm0 -> sqr_b

	MOVSD	%xmm0, y	# load & display second result

	call	disp		# display x, y


	FLDL	x		# first approximation (a0) -> ST(0)

	movl	$0, cntr	#poprawka

iter:
	incl 	cntr		#poprawka

	FLDL	x		# function argument -> ST(0), ak in ST(1)
	FDIV	%ST(1), %ST(0)	# ST(0)/ST(1) -> ST(0)    x/ak
	FADD	%ST(1), %ST(0)	# ST(0)+ST(1) -> ST(0)    ak+x/ak
	FIDIVL	two		# ST(0)/two -> ST(0)      (ak+x/ak)/2
	FCOMI	%ST(1)		# ST(1) ? ST(0)           ak ? ak+1
	FSTP	%ST(1)		# ST(0) -> ST(1) & pop from stack

	jnz	iter		# test of convergence

	FSTPL	sqr_c		# ST(0) -> sqr_b & pop from stack

	FLDL	sqr_c		# load & display second result
	FSTPL	y

	call	disp		# display x, y

	mov 	cntr, 		%rsi	#poprawka
	mov	$cnt_fmt, 	%rdi	#poprawka
	mov	$0, 		%al	#poprawka
	call	printf			#poprawka

	incl	i		# next argument
	cmpl	$10, i		# enough ?
	jbe	next
				#------------------------------
	mov $0, %rdi		# the end
	call	exit

#	add $8, %rsp
	ret

	.type	disp, @function	# printf( fmt_str, x, y );
disp:
	movq	x, %xmm0	# 1st double arg for printf
	movq	y, %xmm1	# 2nd double arg for printf
	mov	$fmt_str, %rdi	# 1st integer arg for printf
	mov 	$2, %al		# two vector regs
	call	printf
	ret

