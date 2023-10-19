//this binary uses the open syscall to create a new file. 
//int open(user_addr_t path, int flags, int mode)

.global _start
.align 2

_start:
	adr	x0, path			//path of the file
	mov	x1, 0x200			//flags
	mov	x2, #0744			//mode
	mov	x16, #5				//syscall for open
	svc	0xFFFF

exit:
	mov     x0, #0      // error code parameter for exit syscall
    	mov     x16, #1     // exit syscall value
    	svc     0xFFFF        // supervisor call

path:
.asciz "/private/tmp/newFile"			//change the value for the target file
