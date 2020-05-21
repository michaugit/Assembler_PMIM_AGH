#----------------------------------------------------------------
# Program lab_2.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#  To compile: as -o lab_2.o lab_2.s
#  To link:    ld -o lab_2 lab_2.o
#  To run:     ./lab_2
#
#----------------------------------------------------------------

	.equ	write_64, 0x01	# write data to file function
	.equ	exit_64, 0x3C	# exit program function
	.equ	stdout, 0x01	# handle to stdout


	.data

hex_str:
	.ascii	"00 "		# hex code string
new_line:
	.ascii	"\n"		# new line
tmp:
	.byte	0		# tmp variable


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
	mov $256, %r15		# loop counter = 256;
	xor %r14, %r14		# number = 0;

again:
	mov %r14b, %al
	call num2hex		# ax = hex_code( al );
	movw %ax, hex_str

	disp_str_64 $stdout, $hex_str, $3
	inc %r14		# number++;
	mov %r14, %rax		# if( !(number % 16) ) newline();
	and $15, %rax
	jnz skip
	disp_str_64 $stdout, $new_line, $1

skip:
	dec %r15		# counter--;
	jnz again

theend:
	exit_prog_64 $0		# exit program


#----------------------------------------------------------------
# num2hex - converts byte to hexadecimal number
#----------------------------------------------------------------

	.type num2hex,@function

num2hex:
	MOVB	%al, tmp
	#MOVB	tmp, %al		# first nibble

	ANDB	$0x0F,%al
	CMPB	$10, %al
	JB	digit1
	ADDB	$('A'-0x0A),%al
	JMP	insert1
digit1:
	ADDB	$'0',%al


insert1:
	MOVB	%al, %ah
	MOVB	tmp, %al		# second nibble

	SHR	$4,%al
	CMPB	$10,%al
	JB	digit2
	ADDB	$('A'- 0x0A),%al
	JMP	insert2
digit2:
	ADDB	$'0',%al


insert2:
	RET


