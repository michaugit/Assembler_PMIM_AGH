#----------------------------------------------------------------
# Funkcja do programu lab_9a - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------

	.text
	.type facta, @function
	.globl facta

facta:	mov $1, %rax	# result or multiplicand

next:	cmp $1, %rdi	# k <= 1 ?
	jbe f_e		# yes, so jump
	mul %rdi	# result * k
	dec %rdi	# k--
	jmp next

f_e:	ret

