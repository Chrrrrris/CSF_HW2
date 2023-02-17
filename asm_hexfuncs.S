/* Assembly language implementation of hexdump functions */

	.section .rodata

	/* TODO: add read-only data such as strings here */

	.section .text
		.globl hex_format_offset
	hex_format_offset:
	/* TODO: implement */
		ret

		.globl hex_to_printable
	hex_to_printable:
		subq $8, %rsp // stack alignment, move stack pointer
		cmpb $31, %dil // compare the char argument with 31
		jbe .Lpdot // if below 31, the char is not printable
		cmpb $127, %dil // compare the char argument with 127
		je .Lpdot // if it is 127, the char is not printable
		movb %dil, %al // else, the char is printable, just return the argument
		addq $8, %rsp // stack alignment
		ret
		
	.Lpdot:
		movb $46, %al // set '.' as the return value
		addq $8, %rsp // stack alignment
		ret

		.globl hex_format_byte_as_hex
	hex_format_byte_as_hex:
		subq $8, %rsp // stack alignment, move stack pointer
		movb $1, %r10b // index = 1, from least significant digit
		movq $16, %r11 // divisor = 16
	.Ltop:
		cmpb $0, %dil // compare byteval with 0
		je .Ldone // if = 0, jump to Ldone
		/*Loop body*/
		movq $0, %rdx // set rdx to 0 for 64 bit diviend
		movq %rdi, %rax // set rax to diviend byteval
		divq %r11 // divide byteval by 16, remainder in rdx
		
		cmpb $10, %dl // compare remainder with 10
		jl .Lelse // if remainder < 10, jump to Lelse
		addb $87, %dl // add 87 to remainder if remainder >= 10
		jmp .Lout // jump to rest of code
		
		.Lelse:
			addb $48, %dl // add 48 to remainder
		
		.Lout:
			leaq (%rsi, %r10), %r8
			movb %dl, (%r8) // set sbuf[index] = remainder 
			decq %r10 // decrement index 
			movb %al, %dil // set quotient from dividion by 16 in al to byteval
		
		jmp .Ltop // continue for loop

	.Ldone:
		movb $0, %cl // cl is loop counter
		jmp .LtestCond

	.LloopTop:
		leaq (%rsi, %rcx), %r8
		movb $48, (%r8) // sbuf[counter] = '0' /*!!!!*/
		incb %cl // increment counter

	.LtestCond:
		cmpb %cl, %r10b // compare index with counter
		jge .LloopTop // jump into loop

	movq $0, 2(%rsi) // sbuf[2] = '\0'

	addq $8, %rsp // stack alignment, move stack pointer
	ret

		.globl hex_read
	hex_read:
	/* TODO: implement */
		ret

		.globl hex_write_string
	hex_write_string:
	/* TODO: implement */
		ret


/* vim:ft=gas:
 */
