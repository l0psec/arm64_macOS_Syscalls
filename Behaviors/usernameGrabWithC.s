//this uses the c functions getenv and printf to grab the username and print to stdout. 
//compiled using gcc -o <filename> <sourceAssembly>.s

.global _main
.align 4

_main:

env:
	adrp	x0, envU@PAGE
	add	x0, x0, envU@PAGEOFF			//load USER string to x0
	bl	_getenv					//call getenv("USER")
	mov	x8, x0					//save username return to x8 (not needed)

print:
	adrp	x0, format@PAGE
	add	x0, x0, format@PAGEOFF			//load format string to x0
	mov	x1, x8					//move username value in x8 to x1
	str	x1, [sp]				//str username value on stack
	bl	_printf					//call printf to print the username to stdout

exit:
	mov	x0, 0x0
	mov	x16, 0x1
	svc	0xFFFF


.data
envU:
.asciz "USER"
.align 2
format:
.asciz "%s\n"
