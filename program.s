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
    subb $0x31, character
    mov character, %al
    mov $0x08, %ecx
    jmp push

number:
    subb $0x30, character
    mov character, %al
    mov $0x08, %ecx
    jmp push 

push:
    shr %al 
    jc putOne
    jnc putZero
    LOOP push
    jmp  displayCorrect

putOne: 
    mov %ecx, %edx 
    sub $0x01, %edx  
    movb $0x01, binary(%edx) 
    ret

putZero:
    mov %ecx, %edx 
    sub $0x01, %edx  
    movb $0x00, binary(%edx) 
    ret

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
