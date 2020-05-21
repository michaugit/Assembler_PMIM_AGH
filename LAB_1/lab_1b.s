#----------------------------------------------------------------
# Program lab_1b.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#  To compile: as -o lab_1b.o lab_1b.s
#  To link:    ld -o lab_1b lab_1b.o
#  To run:     ./lab_1b
#
#----------------------------------------------------------------

	.equ	write_64,0x01	#write data to file function
	.equ	exit_64,0x3C	#exit program function

	.equ	stdout, 0x01	#handle to stdout
	.data
	
txt_A:
	.ascii	"A\n"		#first message

	.text
	.global _start
	
	.macro disp_str_64 file_id, address, length
	mov $write_64, %rax
	mov \file_id, %rdi
	mov \address, %rsi
	mov \length, %rdx
	syscall
	.endm

	.macro exit_prog_64 exit_code
	mov $exit_64, %rax
	mov \exit_code, %rdi
	syscall
	.endm

_start:
	mov $5, %r15   #licznik $5 ile razy 

again:
	disp_str_64 $stdout, $txt_A, $2

	dec %r15 #zmiejszenie licznika pętli 
	jnz again  # skok, jeśli nie zero

theend:
	exit_prog_64 $0		#exit program

