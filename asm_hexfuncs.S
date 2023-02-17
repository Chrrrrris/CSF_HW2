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
		movb $16, %r11b // divisor = 16
	.Ltop:
		cmpb $0, %dil // compare byteval with 0
		je .Ldone // if = 0, jump to Ldone
		/*Loop body*/
		movb $0, %dl // set dl to 0 for 64 bit diviend
		movb %dil, %al // set al to diviend byteval
		divb %r11b // divide byteval by 16, remainder in rdx
		cmpb $10, %dl // compare remainder with 10
		jl .Lelse // if remainder < 10, jump to Lelse
		addb $87, %dl // add 87 to remainder if remainder >= 10
		jmp .Lout // jump to rest of code
		.Lelse:
			addb $48, %dl // add 48 to remainder
		.Lout:
			movq %rdx, (%rsi, %r10) // set sbuf[index] = remainder
			decb %r10b // decrement index 
			movb %al, %dil // set quotient from dividion by 16 in al to byteval
		jmp .Ltop // continue for loop

	.Ldone:
		movb $0, %cl // cl is loop counter

		jmp .LtestCond

		.LloopTop:
			movq $48, (%rsi, %rcx) // sbuf[counter] = '0'
			incb %cl // increment counter

		.LtestCond:
			cmpb %cl, %r10b // compare index with counter
			jge .LloopTop // jump into loop

		movq $0, 2(%rsi) // sbuf[2] = '\0'
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
