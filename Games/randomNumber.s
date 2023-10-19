//
//  randomNumber.s
//  
//random number game written in arm64

.global _start
.align 2

_start:
//getentropy(void *buf, size_t buflen)
//gameCounter:
    mov     x25, #5 //start a game counter for 3 chances

entropyLoop:
    adrp    x0, random@PAGE
    add     x0, x0, random@PAGEOFF
    mov     x1, #8
    mov     x16, #500                           //getentropy syscall
    svc     0xFFFF
    adrp    x8, random@PAGE
    add     x8, x8, random@PAGEOFF
    ldrb    w8, [x8]                            //loading random value into x8
    cmp     x8, #0x39                           //0x39 = 9 ascii
    b.gt    entropyLoop                         //we branch if random value is more than the value of 9 in hex
    cmp     x8, #0x30                           //0x30 = 0 azcii
    b.lt    entropyLoop                         //we branch if random value is less than the value of 0 in hex

//Print the Welcome Screen
greeting:
    mov     x0, #1                              //stdOUT for write syscall
    adrp    x1, welcome@PAGE                    //welcome message
    add     x1, x1, welcome@PAGEOFF
    mov     x2, #61
    mov     x16, #4
    svc     0xFFFF
    
//need to obtain input from the user
userInput:
    mov     x0, #0                  //stdIN
    adrp    x1, userBuf@PAGE        //store input in a buffer
    add     x1, x1, userBuf@PAGEOFF
    mov     x2, #1                  //1 byte stored
    mov     x16, #3
    svc     0xFFFF
    
    adrp    x9, userBuf@PAGE       //loading x22 with a pointer to the user input
    add     x9, x9, userBuf@PAGEOFF
    ldrb    w9, [x9]               //loading a byte
    
//compare input value with stored random number
loop:
    cmp     x8, x9               //comparing input
    b.eq    winprompt
    sub     x25, x25, #1        //decrement the counter
    cmp     x25, #0            //if the player runs out of chances we branch to the sorry message
    b.eq    noMore
    cmp     x8, x9
    b.ne    userInput


//remove tryAgain if it has issues


winprompt:
    mov     x0, #1
    adrp    x1, win@PAGE
    add     x1, x1, win@PAGEOFF
    mov     x2, #29
    mov     x16, #4
    svc     0xFFFF
    b       exit

//try:
//    mov     x0, #1
//    adrp    x1, tryAgain@PAGE
//    add     x1, x1, tryAgain@PAGEOFF
//    mov     x2, #11
//    mov     x16, #4
//    svc     0xFFFF
//    b       userInput

noMore:
    mov     x0, #1
    adrp    x1, done@PAGE
    add     x1, x1, done@PAGEOFF
    mov     x2, #26
    mov     x16, #4
    svc     0xFFFF

exit:
    mov     X0, #0        // Use 0 return code
    mov     X16, #1        // System call number 1 terminates this program
    svc     0xFFFF       // Call kernel to terminate the program


.data
welcome:
.asciz "Number Guessing Game!\nPlease enter a number between 0 and 9:\n"
.align 2

done:
.asciz "Sorry, no more chances :(\n"
.align 2

tryAgain:
.asciz "Try Again!\n"
.align 2

win:
.asciz "You got the matching number!\n"

userBuf:
.byte 0

random:
.byte 0
