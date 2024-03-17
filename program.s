SYSCALL = 0x80
SYS_EXIT = 1
SYS_WRTIE = 4
SYS_READ = 3
STDOUT = 1
STDIN = 0

.bss
    character: .byte 0
    binary: .zero 8
.text 
.global _start
_start:

    mov $SYS_READ, %eax 
    mov $STDIN, %ebx
    mov $character, %ecx
    mov $1, %edx
    int $SYSCALL

    cmp $0x00, %eax
    jbe end

    cmpb $0x30, character
    jb wrongCharacter

    cmpb $0x39, character
    jbe number

    cmpb $0x46, character
    jbe letter

    cmpb $0x46, character
    ja wrongCharacter

letter:
    subb $0x37, character
    mov character, %al
    mov $0x08, %ecx
    jmp push

number:
    subb $0x30, character
    mov character, %al
    mov $0x08, %ecx
    jmp push 

push:
    shl %al 
    jc putOne
    jnc putZero
here:
    LOOP push
    jmp  displayCorrect

putOne: 
    mov $0x08, %ebx
    mov %ecx, %edx 
    sub %edx, %ebx  
    movb $0x31, binary(%ebx) 
    jmp here

putZero:
    mov  $0x08, %ebx
    mov %ecx, %edx 
    sub %edx, %ebx  
    movb $0x30, binary(%ebx) 
    jmp here

wrongCharacter:
    movb $'., binary 
    jmp dipslayWrong

dipslayWrong:
    mov $SYS_WRTIE, %eax 
    mov $STDOUT, %ebx
    mov $binary, %ecx 
    mov $0x01, %edx
    int $SYSCALL
    jmp _start

displayCorrect:
    mov $SYS_WRTIE, %eax 
    mov $STDOUT, %ebx
    mov $binary, %ecx 
    mov $0x08, %edx
    int $SYSCALL
    jmp _start

end:
    mov $SYS_EXIT, %eax
    int $SYSCALL 
