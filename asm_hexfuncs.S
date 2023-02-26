/* Assembly language implementation of hexdump functions */

	.section .rodata

	.section .text
		.globl hex_format_offset
	hex_format_offset:
		subq $8, %rsp // stack alignment, move stack pointer
		movq $7, %r10 // index = 7, from least significant digit
		movq $16, %r11 // divisor = 16
	.LoffsetWhileLoopTop:
		cmpl $0, %edi // compare offset with 0
		je .LoffsetExitWhile // if = 0, jump to LexitWhile
		/*Loop body*/
		movq $0, %rdx // set rdx to 0 for 64 bit diviend
		movq %rdi, %rax // set rax to diviend offset
		divq %r11 // divide offset by 16, remainder in rdx
		
		cmpq $10, %rdx // compare remainder with 10
		jl .LoffsetRemainderLessThanTen // if remainder < 10, jump to LremainderLessThanTen
		addq $87, %rdx // add 87 to remainder if remainder >= 10
		jmp .LoffsetOut // jump to rest of code
	
	.LoffsetRemainderLessThanTen:
		addq $48, %rdx // add 48 to remainder
	
	.LoffsetOut:
		leaq (%rsi, %r10), %r8 // r8 has address of sbuf[index]
		movb %dl, (%r8) // set sbuf[index] = remainder 
		decq %r10 // decrement index 
		movl %eax, %edi // set quotient from division by 16 in eax to edi
		
		jmp .LoffsetWhileLoopTop // continue for loop

	.LoffsetExitWhile:
		movq $0, %rcx // rcx is loop counter
		jmp .LoffsetTestCond

	.LoffsetLoopTop:
		leaq (%rsi, %rcx), %r8 // r8 carries address of sbuf[counter]
		movb $48, (%r8) // sbuf[counter] = '0'
		incq %rcx // increment counter

	.LoffsetTestCond:
		cmpq %rcx, %r10 // compare index with counter
		jge .LoffsetLoopTop // jump into loop

		movb $0, 8(%rsi) // sbuf[8] = '\0'

		addq $8, %rsp // stack alignment, move stack pointer
		ret


		.globl hex_to_printable
	hex_to_printable:
		subq $8, %rsp // stack alignment, move stack pointer
		cmpb $31, %dil // compare the char argument with 31
		jbe .LprintDot // if below 31, the char is not printable
		cmpb $127, %dil // compare the char argument with 127
		jae .LprintDot // if it is equal to or greater than 127, the char is not printable
		movb %dil, %al // else, the char is printable, just return the argument
		addq $8, %rsp // stack alignment
		ret
		
	.LprintDot:
		movb $46, %al // set '.' as the return value
		addq $8, %rsp // stack alignment
		ret

		.globl hex_format_byte_as_hex
	hex_format_byte_as_hex:
		subq $8, %rsp // stack alignment, move stack pointer
		movq $1, %r10 // index = 1, from least significant digit
		movq $16, %r11 // divisor = 16
	.LwhileLoopTop:
		cmpb $0, %dil // compare byteval with 0
		je .LexitWhile // if = 0, jump to LexitWhile
		/*Loop body*/
		movq $0, %rdx // set rdx to 0 for 64 bit diviend
		movq %rdi, %rax // set rax to diviend byteval
		divq %r11 // divide byteval by 16, remainder in rdx
		
		cmpq $10, %rdx // compare remainder with 10
		jl .LremainderLessThanTen // if remainder < 10, jump to LremainderLessThanTen
		addq $87, %rdx // add 87 to remainder if remainder >= 10
		jmp .Lout // jump to rest of code
	
	.LremainderLessThanTen:
		addq $48, %rdx // add 48 to remainder
	
	.Lout:
		leaq (%rsi, %r10), %r8 // r8 has address of sbuf[index]
		movb %dl, (%r8) // set sbuf[index] = remainder 
		decq %r10 // decrement index 
		movb %al, %dil // set quotient from division by 16 in al to byteval
		
		jmp .LwhileLoopTop // continue for loop

	.LexitWhile:
		movq $0, %rcx // rcx is loop counter
		jmp .LtestCond

	.LloopTop:
		leaq (%rsi, %rcx), %r8 // r8 carries address of sbuf[counter]
		movb $48, (%r8) // sbuf[counter] = '0'
		incq %rcx // increment counter

	.LtestCond:
		cmpq %rcx, %r10 // compare index with counter
		jge .LloopTop // jump into loop

		movb $0, 2(%rsi) // sbuf[2] = '\0'

		addq $8, %rsp // stack alignment, move stack pointer
		ret

		.globl hex_read
	hex_read:
		subq $8, %rsp // stack alignment, move stack pointer
		movq %rdi, %rsi // move databuf to the second argument of read
		movq $0, %rdi // move 0 to the first argument of read
		movq $16, %rdx // move 16 to the third argument of read
		call read // call read, values in memory represented by %rdi is changed to user input
		movq %rsi, %rdi // move pointer to buffered databuf back to rsi
		addq $8, %rsp // stack alignment, move stack pointer
		ret

		.globl hex_write_string
	hex_write_string:
		subq $8, %rsp // stack alignment, move stack pointer
		movq $0, %r10 // r10 is the counter --> counter = 0
		movb $0, %r11b // store the null terminator to r11b
		jmp .LloopCond
	
	.LloopBody:
		incq %r10 // increment counter

	.LloopCond:
		cmpb (%rdi, %r10), %r11b // compare '\0' and s[counter]
		jne .LloopBody // continue the loop in s[counter] != '\0'

		movq %rdi, %rsi // move s to the second argument
		movq $1, %rdi // move 1 to the first argument
		movq %r10, %rdx // move counter (length of s) to the third argument
		call write // write s to the standard output

		addq $8, %rsp // stack alignment, move stack pointer
		ret


/* vim:ft=gas:
 */
