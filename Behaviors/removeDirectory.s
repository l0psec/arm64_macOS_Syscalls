//This removes a directory with the rmdir syscall
//int rmdir(char *path)

//Mitre - T1070.004 - Indicator Removal: File Deletion

.global _start
.align 2

_start:
	adr	x0, path
	mov	x16, #137
	svc	0xFFFF	

exit:
	mov     x0, #0      // error code parameter for exit syscall
    	mov     x16, #1     // exit syscall value
    	svc     0xFFFF        // supervisor call


path:
.asciz "/tmp/targetDirectory"	       //replace <target directory>
