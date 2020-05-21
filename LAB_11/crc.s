#----------------------------------------------------------------------------------
# Function void crc32_a( unsigned char *buf, long count, unsigned long *crc_val );
#
#	rdi - function arg: unsigned char *buf
#	rsi - function arg: long count
#	rdx - function arg: unsigned long *crc_val
#
#----------------------------------------------------------------------------------
	.text
	.globl crc32_a
		
crc32_a:	
	push %rbx
	mov (%rdx),%eax			# crc_val in EAX
	xor %rbx,%rbx
next1:
	movzbl (%rdi),%ebx		# get byte from *buf
	xor %eax,%ebx			
	movzb %bl,%ebx			# index to crc_tab
	sar $8,%rax			# arithmetic shift!!!
	xor crc_tab(,%rbx,4),%eax	# computed new crc_val
	inc  %rdi			# pointer to next byte
	dec  %rsi			# decrement counter
	jnz next1			
	mov %eax,(%rdx)			# crc_val updated
	pop  %rbx
	ret

#----------------------------------------------------------------------------------
# Function void crc32_b( unsigned char *buf, long count, unsigned long *crc_val );
#
#	rdi - function arg: unsigned char *buf
#	rsi - function arg: long count
#	rdx - function arg: unsigned long *crc_val
#
#----------------------------------------------------------------------------------
	.globl crc32_b
		
crc32_b:	
	push %rbx
	mov (%rdx),%eax			# crc_val in EAX
next2:
	mov (%rdi),%bl			# get byte from *buf
	crc32 %bl,%eax			# compute crc32c
	inc  %rdi			# pointer to next byte
	dec  %rsi			# decrement counter
	jnz next2			
	mov %eax,(%rdx)			# crc_val updated
	pop %rbx
	ret

