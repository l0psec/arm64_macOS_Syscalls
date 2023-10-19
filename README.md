# arm64_macOS_Syscalls

# arm64 Syscall Examples
### This project includes examples of code written in arm64 using syscalls to replicate known malicious behavior. 

**Behaviors Mapped:**
- Execute script
- Add permission flag
- Create a file
- Create a directory
- Remove a directory
- Print machine uuid
- Remove extended attribute
- Reverse shell

# Instructions to build the example arm code

**STEP ONE:**
Download the .s file of choice.

**Step Two:**
Terminal - Use the assembler:
```shell
as <arm64Code.s> -o <arm64Output.o>
```

**STEP Three:***
Terminal - Use the linker:
```shell
ld -o <outputBinaryName> <sourceFileName>.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64
```
**Special Thanks to:**
- https://github.com/below/HelloSilicon
- HackVlix
