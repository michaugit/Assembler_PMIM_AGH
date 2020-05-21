#----------------------------------------------------------------
# Program lab_4.s - Architektury Komputerów
#----------------------------------------------------------------
#
#  To compile: as --defsym FUNC_V1=1 -o lab_4.o lab_4.s
#  To link:    ld -o lab_4 lab_4.o
#  To run:     ./lab_4
#
#----------------------------------------------------------------

	.equ	write_64, 0x01	# write data to file function
	.equ	exit_64, 0x3C	# exit program function
	.equ	stdout, 0x01	# handle to stdout

	.data

hex_str:
	.ascii	"00 "			# hex code string
big_hex_str:
	.ascii	"0x0000000000000000"	# big hex code string
new_line:
	.ascii	"\n"			# new line
tmp:
	.byte	0			# tmp variable

	.ifdef FUNC_V2
hex_digit:
	.byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
	.endif

	.ifdef FUNC_V3
hex_digits:
	.ascii "00","01","02","03","04","05","06","07"
	.ascii "08","09","0A","0B","0C","0D","0E","0F"
	.ascii "10","11","12","13","14","15","16","17"
	.ascii "18","19","1A","1B","1C","1D","1E","1F"
	.ascii "20","21","22","23","24","25","26","27"
	.ascii "28","29","2A","2B","2C","2D","2E","2F"
	.ascii "30","31","32","33","34","35","36","37"
	.ascii "38","39","3A","3B","3C","3D","3E","3F"
	.ascii "40","41","42","43","44","45","46","47"
	.ascii "48","49","4A","4B","4C","4D","4E","4F"
	.ascii "50","51","52","53","54","55","56","57"
	.ascii "58","59","5A","5B","5C","5D","5E","5F"
	.ascii "60","61","62","63","64","65","66","67"
	.ascii "68","69","6A","6B","6C","6D","6E","6F"
	.ascii "70","71","72","73","74","75","76","77"
	.ascii "78","79","7A","7B","7C","7D","7E","7F"
	.ascii "80","81","82","83","84","85","86","87"
	.ascii "88","89","8A","8B","8C","8D","8E","8F"
	.ascii "90","91","92","93","94","95","96","97"
	.ascii "98","99","9A","9B","9C","9D","9E","9F"
	.ascii "A0","A1","A2","A3","A4","A5","A6","A7"
	.ascii "A8","A9","AA","AB","AC","AD","AE","AF"
	.ascii "B0","B1","B2","B3","B4","B5","B6","B7"
	.ascii "B8","B9","BA","BB","BC","BD","BE","BF"
	.ascii "C0","C1","C2","C3","C4","C5","C6","C7"
	.ascii "C8","C9","CA","CB","CC","CD","CE","CF"
	.ascii "D0","D1","D2","D3","D4","D5","D6","D7"
	.ascii "D8","D9","DA","DB","DC","DD","DE","DF"
	.ascii "E0","E1","E2","E3","E4","E5","E6","E7"
	.ascii "E8","E9","EA","EB","EC","ED","EE","EF"
	.ascii "F0","F1","F2","F3","F4","F5","F6","F7"
	.ascii "F8","F9","FA","FB","FC","FD","FE","FF"
	.endif

varb:	.byte	190			# byte value (2 chars)
varw:	.word	51966			# word value (4 chars)
varl:	.long	3735927486		# long value (8 chars)
varq:	.quad	18369548392556473261	# quad value (16 chars)

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
	mov $256, %r15		# loop counter = 256;
	xor %r14, %r14		# number = 0;

again:
	mov %r14b, %al
	call byte2hex		# ax = hex_code( al );
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

	disp_str_64 $stdout, $new_line, $1

	movb varb, %al			# convert byte to hex string
	movb $1, %cl			# it's byte, so size = 1
	mov $big_hex_str+2, %rdi	# address of most significant digit of least significant byte
	call num2hex
	disp_str_64 $stdout, $big_hex_str, $4	# 0x + 2 digits
	disp_str_64 $stdout, $new_line, $1

	movw varw, %ax			# convert word to hex string
	movb $2, %cl			# it's word, so size = 2
	mov $big_hex_str+4, %rdi	# address of most significant digit of least significant byte
	call num2hex
	disp_str_64 $stdout, $big_hex_str, $6	# 0x + 4 digits
	disp_str_64 $stdout, $new_line, $1

	movl varl, %eax			# convert long to hex string
	movb $4, %cl			# it's long, so size = 4
	mov $big_hex_str+8, %rdi	# address of most significant digit of least significant byte
	call num2hex
	disp_str_64 $stdout, $big_hex_str, $10	# 0x + 8 digits
	disp_str_64 $stdout, $new_line, $1

	movq varq, %rax			# convert quad to hex string
	movb $8, %cl			# it's quad, so size = 8
	mov $big_hex_str+16, %rdi	# address of most significant digit of least significant byte
	call num2hex
	disp_str_64 $stdout, $big_hex_str, $18	# 0x + 16 digits
	disp_str_64 $stdout, $new_line, $1

theend:
	exit_prog_64 $0		# exit program


#----------------------------------------------------------------
# num2hex - converts number to hexadecimal string
#	Arguments:	%rax - number (%al, %ax, %eax)
#			%cl - size of number (1,2,4,8)
#			%rdi - address (where to put hex digits)
#----------------------------------------------------------------

	.type num2hex, @function

num2hex:
	mov %rax, %rdx		# store original value in %rdx
next_byte:
	call byte2hex		# convert byte in %al to two hexdigits (in %ax)
	movw %ax, (%rdi)	# store digits in memory (string)
	sub $2, %rdi		# move two chars to the left
	sub $1, %rdx
	#shr $8, %rdx		# shift original value right
	mov %rdx, %rax		# copy value to %rax
	dec %cl			# size--;
	jnz next_byte		# more bytes to convert

	ret

#----------------------------------------------------------------
# byte2hex - converts byte to hexadecimal number (third version)
#		Argument:	%al - byte to convert
#		Returns:	%ax - two hex digits
#----------------------------------------------------------------

	.ifdef FUNC_V3

	.type byte2hex,@function

byte2hex:
	MOVZX	%al, %rbx			# rbx = al; zeros in empty space
	MOVW	hex_digits(,%rbx,2), %ax	# ah = hex_digit[ rbx ]
	RET

	.endif

#----------------------------------------------------------------
# byte2hex - converts byte to hexadecimal number (first version)
#		Argument:	%al - byte to convert
#		Returns:	%ax - two hex digits
#----------------------------------------------------------------

	.ifdef FUNC_V1

	.type byte2hex,@function

byte2hex:
	MOVB	%al, tmp

	MOVB	tmp,%al		# first nibble
	ANDB	$0x0F,%al
	CMPB	$10,%al
	JB	digit1
	ADDB	$('A'-10),%al
	JMP	insert1
digit1:
	ADDB	$'0',%al
insert1:
	MOVB	%al,%ah

	MOVB	tmp,%al		# second nibble
	SHR	$4,%al
	CMPB	$10,%al
	JB	digit2
	ADDB	$('A'-10),%al
	JMP	insert2
digit2:
	ADDB	$'0',%al
insert2:
	RET

	.endif

#----------------------------------------------------------------
# byte2hex - converts byte to hexadecimal number (second version)
#		Argument:	%al - byte to convert
#		Returns:	%ax - two hex digits
#----------------------------------------------------------------

	.ifdef FUNC_V2

	.type byte2hex,@function

byte2hex:
	MOVB	%al, tmp

	MOVB	tmp, %al		# first nibble
	ANDB	$0x0F, %al
	MOVZX	%al, %rbx		# rbx = al; zeros in empty space
	MOVB	hex_digit(%rbx), %ah	# ah = hex_digit[ rbx ]

	MOVB	tmp, %al		# second nibble
	SHR	$4, %al
	MOVZX	%al, %rbx		# rbx = al; zeros in empty space
	MOVB	hex_digit(%rbx), %al	# al = hex_digit[ rbx ]
	RET

	.endif



