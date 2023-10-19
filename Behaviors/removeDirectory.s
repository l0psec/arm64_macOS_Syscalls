//This removes a directory with the rmdir syscall
//int rmdir(char *path)


.global _start
.align 2

_start:
	adr	x0, path
	mov	x16, #137
	svc	0xFFFF	

exit:
	mov	x0, #0
	mov	x16, #1
	svc	0xFFFF


path:
.asciz "/tmp/targetDirectory"	       //replace <target directory>
