#----------------------------------------------------------------
# Funkcja do programu lab_9b - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------

	.type fiba, @function
	.global fiba

fiba:	push %rbx	# store on stack | rbx odkladamy na stos, a rcx już nie bo ecx to jeden z argumentów funkcji i nie trzeba go odtwarzać

	mov $0, %rbx	# old
	mov $1, %rcx	# new

	cmp %rbx, %rdi	# k == 0 ?
	jz	f_0	# yes, so jump
	cmp %rcx, %rdi	# k == 1 ?
	jz	f_1	# yes, so jump

next:
	mov %rbx, %rax	# sum = old
	add %rcx, %rax	# sum += new
	mov %rcx, %rbx	# old = new
	mov %rax, %rcx	# new = sum
	dec %edi	# k--
	cmp $1, %edi	# k > 1 ?
	ja next		# yes, so jump

f_e:	pop %rbx	# restore original
	ret

f_0:
	mov %rbx, %rax	# return 0
	jmp f_e

f_1:
	mov %rcx, %rax	# return 1
	jmp f_e

