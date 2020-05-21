#----------------------------------------------------------------
# Program LAB_3.S - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#  To compile: as -o lab_3.o lab_3.s
#  To link:    ld -o lab_3 lab_3.o
#  To run:     ./lab_3
#
#----------------------------------------------------------------

	.equ	write_64,	1
	.equ	exit_64,	60
	.equ	stdout,		1

#----------------------------------------------------------------

	.data

vector:					# vector of items
	.long	10,70,50,90,60,80,40,20,0,30,6969,69,69
count:					# count of items
	.quad	( . - vector ) >> 2	#przesunięcie o 2 miejsca tzn dzielenie przez 4
item:
	.ascii	"Item "
line_no:
	.ascii	"   "
itemval:
	.ascii	" = "
number:
	.ascii	"     \n"
FL_text:
	.ascii	"\nFrom first to last:\n"
LF_text:
	.ascii	"\nFrom last to first:\n"
dataend:

	.equ	item_len, FL_text - item
	.equ	FL_len, LF_text - FL_text
	.equ	LF_len, dataend - LF_text

#----------------------------------------------------------------

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

#----------------------------------------------------------------

_start:
	disp_str_64 $stdout, $FL_text, $FL_len	# display message

	CALL	disp_vector_FL			# display content of vector

	disp_str_64 $stdout, $LF_text, $LF_len	# display message

	CALL	disp_vector_LF			# display content of vector

	exit_prog_64 $0				# exit program

#----------------------------------------------------------------
#
#	Function:	disp_vector_FL
#	Parameters:	none
#
	.type disp_vector_FL,@function
disp_vector_FL:
	MOV	count,%rcx		# data count
	XOR	%rsi,%rsi		# data index
next_item:
	MOV	vector(,%rsi,4),%ebx	# get data
	CALL	make_string		# convert to string

	PUSH	%rcx
	PUSH	%rsi
	disp_str_64 $stdout, $item, $item_len	# display prepared string
	POP	%rsi
	POP	%rcx

	INC	%rsi			# next element
	LOOP	next_item		# { rcx--; if( rcx ) goto next_item }

	RET				# return to main program
#----------------------------------------------------------------
#
#	Function:	disp_vector_LF
#	Parameters:	none
#
	.type disp_vector_LF,@function
disp_vector_LF:
	MOV	count,%rcx		# data count
	MOV	%rcx,%rsi		# data index
	DEC	%rsi			# data index--
prev_item:
	MOV	vector(,%rsi,4),%ebx	# get data
	CALL	make_string		# convert to string

	PUSH	%rcx
	PUSH	%rsi
	disp_str_64 $stdout, $item, $item_len	# display prepared string
	POP	%rsi
	POP	%rcx

	DEC	%rsi			# previous element
	LOOP	prev_item		# { rcx--; if( rcx ) goto prev_item }

	RET				# return to main program
#----------------------------------------------------------------
#
#	Function:	make_string
#	Parameters:	%esi - index of element
#			%ebx - value of element
#
	.type make_string,@function
make_string:

	MOVL	$0x20202020, number	#modyfikacja -> czysczenie
	MOVW	$0x2020, line_no	#modyfikacja -> czysczenie

	MOV	%esi,%eax		# convert index of vector element to string
	MOV	$line_no + 2,%rdi
	CALL	num2dec
	MOV	%ebx,%eax		# convert value of vector element to string
	MOV	$number + 4,%rdi
	CALL	num2dec

	RET				# return to disp_vector function
#----------------------------------------------------------------
#
#	Function:	num2dec
#	Parameters:	%eax - value
#			%rdi - address of last character
#
	.type num2dec,@function
num2dec:
	PUSH	%rbx		# save register on stack
	PUSH	%rdx		# save register on stack
	MOV	$10,%ebx	# divisor in EBX, dividend in EAX
nextdig:
	XOR	%edx,%edx	# EDX = 0
	DIV	%ebx		# EDX:EAX div EBX
	ADD	$'0',%dl	# convert remainder (in EDX) to character
	MOV	%dl,(%rdi)	# *(RDI) = character (decimal digit)
	CMP	$0,%eax		# quotient in EAX
	JZ	empty
	DEC	%rdi		# RDI--
	JMP	nextdig
empty:
	POP	%rdx		# restore register from stack
	POP	%rbx		# restore register from stack

	RET			# return to make_string function
#----------------------------------------------------------------
