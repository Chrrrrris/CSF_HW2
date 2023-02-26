/* Hexdump main function, assembly language version */

	.section .rodata
colonSpace: .string ": "
oneSpace: .string: " "
threeSpaces: .string "   "
newLine: .string "\n"

	.section .bss
location: .space (1 * 9) 
data_buf: .space (1 * 17) 
sbuf: .space (1 * 3) 

	.section .text

	.globl main
main:
	subq $8, %rsp // stack alignment
	movq $0, %r12 // unsigned count = 0, count stored in r12
	movq $data_buf, %r13 // use %r13 as pointer to element of databuf
	movq $location, %r15 // use r15 as pointer to element of location
	movq $sbuf, %rbx // use rbx as pointer to element of sbuf
	movq %r13, %rdi // move the pointer to the first element in databuf to the first argument of hex_read
	call hex_read
	movq %rax, %r12 // r12 store the count of bytes read
	movb $0, (%r13, %r12) // data_buf[count] = '\0'
	movq $0, %r14 // index = 0, store index to r14
	jmp .LloopCond

.LloopTop:
	// write the location
	movq %r14, %rdi // move index to the first argument
	movq %r15, %rsi // move pointer to location[] to the second argument
	call hex_format_offset
	movq %rsi, %rdi // move formatted location[] to the first argument so that it can be output
	call hex_write_string
	movq $colonSpace, %rdi // write ": "
	call hex_write_string
	movq $0, %rbp // i = 0, store i to rbp
	jmp .LloopCondWriteHex

/* write hex digits*/
.LloopTopWriteHex:
	movb (%r13, %rbp), %dil //move data_buf[i] to the first argument
	movq %rbx, %rsi // move pointer to sbuf[] to the second argument
	call hex_format_byte_as_hex // convert character from data_buf to hex digit stored in sbuf
	movq %rsi, %rdi //write the hex digits to standard output
	call hex_write_string
	movq $oneSpace, %rdi // write space to standard output
	call hex_write_string
	incq %rbp // counter++

.LloopCondWriteHex:
	cmpq %r12, %rbp // continue the loop until counter == count
	jl .LloopTopWriteHex
	
	movq %r12, %rbp // counter = count
	jmp .LloopCondPadWriteHex

/*pad the output of hex digits with spaces*/
.LloopTopPadWriteHex:
	movq $threeSpaces, %rdi // output three spaces
	call hex_write_string
	incq %rbp // counter++

.LloopCondPadWriteHex:
	cmpq $16, %rbp // continue the loop until counter == 16
	jl .LloopTopPadWriteHex

	movq $oneSpace, %rdi // write a space before outputing printables
	call hex_write_string

	movq $0, %rbp // counter = 0
	jmp .LloopCondWritePrintable

/* write printables*/
.LloopTopWritePrintable:
	movb (%r13, %rbp), %dil //the first argument = data_buf[i]
	call hex_to_printable // convert data_buf[i] to a printable
	movb %al, (%r13, %rbp) // data_buf[i] = hex_to_printable(data_buf[i])
	incq %rbp // counter++

.LloopCondWritePrintable:
	cmpq $16, %rbp // continue the loop until counter == 16
	jl .LloopTopWritePrintable

	movq %r13, %rdi // print data_buf, which now stores printables
	call hex_write_string
	movq $newLine, %rdi // print a new line
	call hex_write_string

	addq $16, %r14 // counter += 16
	movq %r13, %rdi // hex_read(data_buf)
	call hex_read
	movq %rax, %r12 // update count of characters read
	movb $0, (%r13, %r12) // data_buf[count] = '\0' 

.LloopCond:
	cmpq $0, %r12 // continue the loop until count == 0
	jne .LloopTop
	
	addq $8, %rsp // stack alignment
	ret

/* vim:ft=gas:
 */
