//Mitre - T1222.002
//This adds the execute permission to a target file. Similar to executing chmod +x, but without launching the chmod process. 

//int chmod(user_addr_t path, int mode)

.global _start
.align 2

_start:
        adr     x0, path        //path to the target file
        mov     x1, #0755       //mode value
        mov     x16, 0xf        //Syscall value 15 for chmod
        svc     0xFFFF

exit:                           
        mov     x0, #0
        mov     x16, #1
        svc     0xFFFF


path:
.asciz "/private/tmp/testfile.sh" 
