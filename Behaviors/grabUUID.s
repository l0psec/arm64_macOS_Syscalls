//this uses the sysctl syscall to obtain the uuid from the endpoint
.global _start
.align 2

_start:
//using parameters for the gethostUUID function call [gethostuuid(uuid_t id, const struct timespec *wait)]
	adrp	x0, buf@PAGE                	 //16 byte buffer used for the return value from the syscall
	add	x0, x0, buf@PAGEOFF
	adrp	x1, timespec@PAGE           	 //timespec struct used as 2nd parameter to the syscall
	add	x1, x1, timespec@PAGEOFF
    	mov	x16, #142                   	 //gethostuuid syscall = 142
	svc	0xFFFF

    	adrp    x0, buf@PAGE
	add	x0,x0, buf@PAGEOFF
    	mov     x19, x0                     	//save the pointer to the uuid syscall result
    	adrp    x1, uuid_buf@PAGE
    	add     x1, x1, uuid_buf@PAGEOFF    	// x1 now holds the pointer to the new buffer we will use to convert the uuid return
    	mov     x20, x1                     	//save pointer to x20
    	
unparse:                            		//this starts our unparse function
    	mov	x8, #0x0                     	//this will be used as a counter to compare against from 0-15 for 16 bytes
    	mov    	w9, #0x1                     	//moving 1 into w9
    	mov    	w10, #0x550                  	//moving 0x550 into w10
    	adrp   	x12, cha123@PAGE             	//address of a ascii string we use for the conversion
    	add    	x12, x12, cha123@PAGEOFF     	//"0123456789ABCDEF" pointer is loaded into x12
    	
branch:                             		//branch label
    	cmp    	w8, #0xa                     	//compare a (10 d) with w8  to set flags
    	b.hi   	loadloop                     	//hi condition is c==1 and z == 0 for cpsr
    	lsl    	w13, w9, w8                  	// left shift by 0 and 1 and store in to w13,
    	tst    	w13, w10                     	// performs a bitwise and calculation between the value 0x1 and 0x550 and sets flags
    	b.eq   	loadloop                     	//If the last bitwise and resulted in the zero flag = 1, then branch to this location
    	strb   	w11, [x1], #0x1              	//store byte in x11 into x1 with an offset of x1
    	
loadloop:
    	ldrb   	w13, [x0, x8]			// load byte of address = x0 + x8 (at this point, x8 = 0 so this adds the first byte of the uuid value stored in x0)
    	lsr    	x13, x13, #4			// here we perform a logical shift right for the value in x1 which is set to 1c. the result will be 1 and stored into x13, 1c >> 4 = 1
    	ldrb   	w13, [x12, x13]			// load byte from the calculated address of x12 "123456789ABCDEF" + x13. x12 points to 0x1836af034 and x13 = 1 so we load the first byte of 0x1836af034 + 1
    	strb   	w13, [x1]			// x13 now contains the first byte of the pointer in x12 which in this case is the value 0x31 which corresponds to the ascii value for 1. this is stored.
    	ldrb   	w13, [x0, x8]			// a byte is loaded from the calculated address of x0 and x8 (0x16fdff578 + 0) = the uuid buffer.
    	and    	x13, x13, #0xf			//1c stored in x13 is then and'd with f and for the first case results in C (12 d) into x13
    	ldrb   	w13, [x12, x13]			//0x1836af034 + c = 0x1836af040 = "CDEF" so the C ascii character gets loaded into x13
    	strb   	w13, [x1, #0x1]			//stores the C ascii value (0x43) into the memory location calculation of x1 (0x16fdff553) and 0x1 = 0x16fdff554: "C"
    	add    	x1, x1, #0x2			//adds the hex value 0x2 to x1 and stores the result back into x1. so x1 will now point to 0x16fdff555 which will be used to add additional values.
    	add    	x8, x8, #0x1			//0x1 is added to our counter to loop through all 16 bytes
    	cmp    	w8, #0x10			//compares the value in w8 (which for the first loop will be 0x1) against 0x10 (16 d) and branches to 0x18363e280 to continue looping through bytes.
    	b.ne   	branch
    	strb   	wzr, [x1]

//TODO add dashes


print:
//using the write function(int fildes, const void *buf, size_t nbyte) to print the contents of the uuid to stdout
    	mov     x0, #1
    	adrp    x1, uuid_buf@PAGE
    	add     x1, x1, uuid_buf@PAGEOFF
   	mov	x2, #36
	mov	x16, #4
	svc	0xFFFF
exit:
	mov	x0, #0
	mov	x16, #1
	svc	0xFFFF

.data
buf: 
.space 16
.align 2

timespec:
.dword 0
.align 2

uuid_buf:
.space 37
.align 2

cha123:
.ascii "0123456789ABCDEF"
