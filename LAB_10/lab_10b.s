#----------------------------------------------------------------
# Funkcje do programu lab_10b.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------

	.data
x:				# function argument
	.double		0.0
y:
	.double		0.0
two:				# constant
	.long		2

#----------------------------------------------------------------
	.text

	.type	sqrtA, @function	# double sqrtA( double x );
	.global sqrtA
sqrtA:
	movsd	%xmm0, x		# movq is also OK
	fldl	x
	fsqrt
	fstpl	y
	movq	y, %xmm0		# movsd is also OK
	ret
#----------------------------------------------------------------
	.text

	.type	sqrtB, @function	# double sqrtB( double x );
	.global sqrtB
sqrtB:
	sqrtsd	%xmm0, %xmm0
	ret
#----------------------------------------------------------------
	.text

	.type	sqrtC, @function	# double sqrtC( double x );
	.global sqrtC
sqrtC:
	movq	%xmm0, x	# movsd is also OK

	fldl	x		# first approximation (a0) -> ST(0)

iter:	fldl	x		# function argument -> ST(0), ak in ST(1)
	fdiv	%ST(1), %ST(0)	# ST(0)/ST(1) -> ST(0)    x/ak
	fadd	%ST(1), %ST(0)	# ST(0)+ST(1) -> ST(0)    ak+x/ak
	fidivl	two		# ST(0)/two -> ST(0)      (ak+x/ak)/2
	fcomi	%ST(1)		# ST(1) ? ST(0)           ak ? ak+1
	fstp	%ST(1)		# ST(0) -> ST(1) & pop from stack
	jnz	iter		# test of convergence

	fstpl	y		# ST(0) -> sqr_b & pop from stack

	movq	y, %xmm0	# movsd is also OK
	ret
#----------------------------------------------------------------

