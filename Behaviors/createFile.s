//this binary uses the open syscall to create a new file. 
//int open(user_addr_t path, int flags, int mode)

.global _start
.align 2

_start:
	adr	x0, path
	mov	x1, 0x200
	mov	x2, #0744
	mov	x16, #5
	svc	0x80

exit:
	mov	x0, #0
	mov	x16, #1
	svc	0x80

path:
.asciz "/private/tmp/createASMopen"	
