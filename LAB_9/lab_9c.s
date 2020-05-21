#----------------------------------------------------------------
# Program lab_9c.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
# To compile:	as -o lab_9c.o lab_9c.s
# To link:	ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -o lab_9c lab_9c.o
# To run:	./lab_9c
#
#----------------------------------------------------------------

	.data
argc_s:
	.asciz "Argc = %d\n"
args_s:
	.asciz "Argv[%d] = %s\n"
envs_s:
	.asciz "Env[%d] = %s\n"
sep_s:
	.asciz "----------------------------\n"
argc:
	.quad 0
argv:
	.quad 0
env:
	.quad 0
argc_tmp:
	.quad 0

	.text
	.global main

#_start:							// przy użyciu "as" do komiplacji odkomentować
main: # i wtedy można gcc -no-pie -o lab_9c lab_9c.s
#	mov (%rsp), %rax	# argc is here 			//przy start odkomentować

	mov %rdi, %rax						#dodatek przy main
	mov %rsi, argv						#dodatek przy main
	mov %rdx, env						#dodatek przy main


	mov %rax, argc		# store value of argc
	mov %rax, argc_tmp

	mov $argc_s,%rdi
	mov argc, %rsi
	mov $0, %al
	call printf		# display value of argc

#	mov %rsp, %rbx		# use rbx as a pointer		//przy start odkomentować
#	add $8, %rbx		# argv[] is here		//przy start odkomentować
#	mov %rbx, argv		# store address of argv[]	//przy start odkomentować

	mov argv, %rbx 						#dodatek przy main

next_argv:

	mov $args_s, %rdi	# address of format string
	mov argc, %rsi
	sub argc_tmp, %rsi	# i
	mov (%rbx), %rdx	# argv[i]
	mov $0, %al		# printf - number of vector regs
	call printf		# display value of argv[i]

	add $8,%rbx		# address of argv[i+1]

	decq argc_tmp		# loop counter--
	jnz next_argv

	mov $sep_s, %rdi
	mov $0, %al
	call printf		# display separator

#	add $8, %rbx		# env[] is here - skip zero/NULL	//przy start odkomentować
#	mov %rbx, env		# store address of env[]		//przy start odkomentować

	mov env, %rbx							#dodatek przy main

next_env:
	cmp $0,(%rbx)		# is env[i] == NULL
	je finish		# yes

	mov $envs_s, %rdi	# address of format string
	mov argc_tmp, %rsi	# i
	mov (%rbx), %rdx	# env[i]
	mov $0, %al
	call printf		# displays value of env[i]

	add $8,%rbx		# address of env[i+1]
	incq argc_tmp		# i++
	jmp next_env

finish:
	mov $0,%rdi		# this is the end...
	call exit

