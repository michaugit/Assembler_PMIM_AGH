#----------------------------------------------------------------
# Program lab_7a.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#  To compile&link: gcc -no-pie -o lab_7a lab_7a.s
#  To run:     ./lab_7a
#
#----------------------------------------------------------------


	.data

fmt_1:
	.asciz	"Value = %d\n"		# format string (asciz=string)
val_1:
	.long	6			# long number
fmt_prompt:
	.string	"Number: "		# format string for prompt
fmt_scanf:
	.string	"%d"			# format string for scanf
fmt_lf:
	.string "\n"			# just "\n"
ok_num:
	.long	0			# scanf result
argc:
	.long	0			# number of arguments
argc_tmp:
	.long	0			# number of arguments
argv:
	.quad	0			# address of argv[]
env:
	.quad	0			# address of env[]
fmt_argc:
	.string	"Argc=%d\n"		# format for argc
fmt_argv:
	.string "Argv[%d]=%s\n"		# format for argv
fmt_env:
	.string "Env[%d]=%s\n"		# format for env

#----------------------------------------------------------------

	.text
	.global main

#----------------------------------------------------------------

main:
	push %rbp		# umieszczenie na stosie rejestru rbp w celu go wyrównania 8b + 8b

	mov %edi, argc		#odczyt parametrów z main(argv...)
	mov %edi, argc_tmp
	mov %rsi, argv
	mov %rdx, env

	mov $fmt_prompt, %rdi	# printf( fmt ) - 1st argument to %rdi;
	xor %rax, %rax		# printf - number of vector registers to %al
	call printf

	mov $fmt_scanf, %rdi
	mov $val_1, %rsi
	mov $0, %al		# zmienna ilość argumetów, tam wcześniej był xor
	call scanf
	mov %eax, ok_num

	mov $fmt_lf, %rdi	# printf( fmt ) - 1st argument to %rdi;
	xor %rax, %rax		# printf - number of vector registers to %al
	call printf

	cmp $1, ok_num
	jnz no_more_numbers

	mov val_1, %rsi		# printf( char *fmt, long num ) - 2nd argument to %rsi;
	mov $fmt_1, %rdi	# printf( char *fmt, long num ) - 1st argument to %rdi;
	xor %rax, %rax		# printf - number of vector registers to %al
	call printf

no_more_numbers:

	mov argc, %rsi		# printf( fmt, num ) - 2nd argument to %rsi;
	mov $fmt_argc, %rdi	# printf( fmt, num ) - 1st argument to %rdi;
	xor %rax, %rax		# printf - number of vector registers to %al
	call printf


	mov argv, %rbp		# %rbp = argv;

next_argv:
	mov (%rbp), %rdx	# printf( fmt, num, str ) - 3rd argument to %rdx; () wyłuskanie wskaźnika
	mov argc, %esi
	sub argc_tmp, %esi	# printf( fmt, num, str ) - 2nd argument to %rsi; numer argumentu uzyskujemy poprzez odjecię od argc iteratora argc_tmp
	mov $fmt_argv, %rdi	# printf( fmt, num, str ) - 1st argument to %rdi;
	xor %rax, %rax		# printf - number of vector registers to %al
	call printf

	add $8, %rbp		# next argv
	decl argc_tmp		# argc_tmp--;
	jnz next_argv		#


	mov env, %rbp		# %rbp = env;

next_env:
	cmp $0,(%rbp)		# while( env[i] != NULL )
	jz no_more_env
	mov (%rbp), %rdx	# printf( fmt, num, str ) - 3rd argument to %rdx;
	mov argc_tmp, %esi	# printf( fmt, num, str ) - 2nd argument to %rsi;
	mov $fmt_env, %rdi	# printf( fmt, num, str ) - 1st argument to %rdi;
	xor %rax, %rax		# printf - number of vector registers to %al
	call printf

	add $8, %rbp		# next env
	incl argc_tmp		# argc_tmp++;
	jmp next_env

no_more_env:

	xor %rdi, %rdi		# exit( code ) - 1st argument to %rdi
	call exit

	pop %rbp

	ret

