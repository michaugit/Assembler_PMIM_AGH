#----------------------------------------------------------------
# Funkcja do programu lab_7b - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------

	.text
	.type sum3a, @function
	.globl sum3a

sum3a:
	mov %rdi, %rax		# 1st parameter to %rax
	add %rsi, %rax		# add 2nd parameter
	add %rdx, %rax		# add 3rd parameter
#	add $1,	  %rax		# śmieszki

	ret			# return sum
