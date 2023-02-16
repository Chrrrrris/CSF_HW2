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
		movb %dil, %al // else, the char is printable; just return the argument
		addq $8, %rsp // stack alignment
		ret
		
	.Lpdot:
		movb $46, %al // set '.' as the return value
		addq $8, %rsp // stack alignment
		ret

		.globl hex_format_byte_as_hex
	hex_format_byte_as_hex:
	/* TODO: implement */
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
