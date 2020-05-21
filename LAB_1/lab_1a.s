#----------------------------------------------------------------
# Program lab_1a.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#  To compile: as -o lab_1a.o lab_1a.s
#  To link:    ld -o lab_1a lab_1a.o
#  To run:     ./lab_1a
#
#----------------------------------------------------------------

	.equ	kernel,0x80	#Linux system functions entry
	.equ	write_32,0x04	#write data to file function
	.equ	exit_32,0x01	#exit program function

	.equ	write_64,0x01	#write data to file function
	.equ	exit_64,0x3C	#exit program function //  3 razy 48 plus 12 

	.equ	stdout, 0x01	#handle to stdout
	.data
	
txt_A:
	.ascii	"A\n"		#first message, 2 znaki - literka właściwa
txt_B:
	.ascii	"B\n"		#second message
txt_C:
	.ascii	"C\n"		#third message

	.text
	.global _start
	
	.macro disp_str_32 file_id, address, length      #bardziej intelegienty "hasz define" , do wypisania czegosc na ekranie 
	mov $write_32, %eax				
	mov \file_id, %ebx
	mov \address, %ecx
	mov \length, %edx
	int $kernel
	.endm

	.macro exit_prog_32 exit_code       #użycie funkcji exit , możliwość przekazania 1 parametru, gdzie podaje dalej do systemu operacyjnego 
	mov $exit_32, %eax			# rejstry od literki e 32-bitowe
	mov \exit_code, %ebx
	int $kernel
	.endm

	.macro disp_str_64 file_id, address, length 
	mov $write_64, %rax 			#rejstry 64 bitowe od literki r
	mov \file_id, %rdi
	mov \address, %rsi
	mov \length, %rdx
	syscall
	.endm

	.macro exit_prog_64 exit_code
	mov $exit_64, %rax
	mov \exit_code, %rdie
	syscall 		#do komunikacji z systemem operacyjnym
	.endm

_start:
	JMP showC
	
	

showA:
	disp_str_64 $stdout, $txt_A, $2 #wywołanie macro
	JMP theend

showB:
	disp_str_64 $stdout, $txt_B, $2
	JMP showA

showC:
	disp_str_64 $stdout, $txt_C, $2
	JMP showB


theend:
	exit_prog_32 $5		#exit program #echo $? w terminalu daje 5 
 

#program wypisuje 3 wartości A, B, C -> mozna mieszać 32 z 63 bo mamy rejestry 64 bitowe w procesorze 

