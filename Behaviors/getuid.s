.global _start
.align 2


_start:
//getuid syscall
	
	mov	x16, #24
	svc	0xFFFF
	
	mov	x8, x0
	cmp	x0, #0			//compare the return value with 0 for root
	b.ne	printnotRoot		//branch to label to print string if not root

printifRoot:
	mov	x0, #1
	adr	x1, rootString
	mov	x2, #16
	mov	x16, #4
	svc	0xFFFF
	b	exit			//branch to exit to avoid continuing to next write syscall

printnotRoot:
	 mov     x0, #1
         adr     x1, NotrootString
         mov     x2, #9
         mov     x16, #4
         svc     0xFFFF

exit:
	mov	x0, #0
	mov	x16, #1
	svc	0xFFFF


rootString:
.asciz "running as root\n"
.align 2

NotrootString:
.asciz "not root\n"	
	



