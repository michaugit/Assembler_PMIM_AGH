#----------------------------------------------------------------
# Funkcja do programu lab_8b - Asemblery Laboratorium IS II rok
#          fiba( k ) = fiba( k-2 ) + fiba( k-1 )
#----------------------------------------------------------------

	.type fiba, @function
	.globl fiba

fiba:	push %rbp		# function prolog
	mov %rsp,%rbp

	sub $8,%rsp		# local variable

	cmp $0, %edi		# parameter (k) == 0 ?
	jz f_0			# yes, so jump

	cmp $1, %rdi		# k == 1 ?
	jz f_1			# yes, so jump

	push %rdi		# store k

	sub $2,%rdi		# new parameter k-2
	call fiba
	mov %rax,-8(%rbp)	# store result in local variable

	pop %rdi		# restore k

	dec %rdi		# new parameter k-1
	call fiba
	add -8(%rbp),%eax	# %rax += local variable

f_e:	mov %rbp, %rsp		# function epilog
	pop %rbp
	ret

f_0:
	mov $0, %eax		# special case k == 0
	jmp f_e

f_1:
	mov $1, %eax		# special case k == 1
	jmp f_e
