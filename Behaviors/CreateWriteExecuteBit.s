//This example focuses on the usage of different syscalls and branches to create a directory, create a file in that directory, and set the execute permission flag. 
//Each behavior also prints to stdout which can be useful for debugging. 

.global _start
.align 2

_start:
//lets print what we are doing. 

	mov	x0, #1
	adr	x1, welMessage
	mov	x2, #31
	mov	x16, #4
	svc	0xFFFF

//branch to create the directory
	bl	makeDir

//print 2nd message
	mov     x0, #1
        adr     x1, twoMessage
        mov     x2, #17
        mov     x16, #4
        svc     0xFFFF

//branch to create file	
	bl	fileCreate

//print 3rd message
	mov     x0, #1
        adr     x1, threeMessage
        mov     x2, #32
        mov     x16, #4
        svc     0xFFFF

//branch to set execute permissions
	bl	executeBit

//print done
	mov     x0, #1
        adr     x1, doneMessage
        mov     x2, #6
        mov     x16, #4
        svc     0xFFFF
	b	exit
makeDir:
	adr     x0, dirPath
        mov     x1, #0761
        mov     x16, 0x88
        svc     0xFFFF
	ret

fileCreate:
	adr     x0, filePath
        mov     x1, 0x200
        mov     x2, #0744
        mov     x16, #5
        svc     0xFFFF
	ret

executeBit:
	adr     x0, filePath
        mov     x1, #0755
        mov     x16, 0xf
        svc     0xFFFF
	ret


exit:
	mov	x0, #0
	mov	x16, #1
	svc	0xFFFF

welMessage:
.asciz "Creating directory in temp...\n"
.align 2

twoMessage:
.asciz "Creating file...\n"
.align 2

threeMessage:
.asciz "Setting execute permissions...\n"
.align 2

doneMessage:
.asciz "Done!\n"
.align 2

dirPath:
.asciz "/private/tmp/newDirectory"
.align 2

filePath:
.asciz "/private/tmp/newDirectory/newFile"
