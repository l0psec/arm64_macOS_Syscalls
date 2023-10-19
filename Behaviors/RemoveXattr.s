// This uses the removexattr syscall to remove an extended attribute of a target file.  

.global _start
.align 2
_start:
        adr     x0, path    // loading the ascii string in path label as path parameter for syscall
        adr     x1, att     // loading the ascii string in att label as name parameter for syscall
        mov     x2, #0      // moving 0 value for int option parameter
        mov     x16, #0xee  // moving syscall value in hex for removexattr into x16
        svc     0x80        // supervisor call

exit:
        mov     x0, #0      // error code parameter for exit syscall
        mov     x16, #1     // exit syscall value
        svc     0x80        // supervisor call


path:
.ascii "/private/tmp/targetFile"         // replace <target file> with the intended target

att:
.ascii "com.apple.quarantine\0"         // This is for the extended attribute we want to remove. We added a null terminator and can be changed to another attribute. 
