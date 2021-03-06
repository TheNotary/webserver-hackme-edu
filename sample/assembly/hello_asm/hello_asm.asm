; exploit notes:  https://www.owasp.org/index.php/Buffer_Overflow_via_Environment_Variables

; https://www.onlinedisassembler.com/odaweb/WcfZvyeK

; http://asm.sourceforge.net/intro/hello.html
; Build notes...
; You may need to change elf64 to a different format depending on the type of OS you're running
; use `nasm -hf` to see a list of them
; $ nasm -f elf64 hello_asm.asm
; $ ld -e _start -o hello_asm hello_asm.o

section     .text
global      _start                              ;must be declared for linker (ld)

_start:                                         ;tell linker entry point

    ; Print Content-type header, and final newline
    mov     edx,contentType_len                 ;message length
    mov     ecx,contentType                     ;message to write
    mov     ebx,1                               ;file descriptor (stdout)
    mov     eax,4                               ;system call number (sys_write)
    int     0x80                                ;call kernel


    ; Print Body
    mov     edx,len                             ;message length
    mov     ecx,msg                             ;message to write
    mov     ebx,1                               ;file descriptor (stdout)
    mov     eax,4                               ;system call number (sys_write)
    int     0x80                                ;call kernel

    mov     ebx,0                               ;specify an exit code of zero
    mov     eax,1                               ;system call number (sys_exit)
    int     0x80                                ;call kernel

section     .data

contentType         db 'Content-type: text/plain', 0xa, 0xa
contentType_len     equ $ - contentType
msg                 db  'Hello, world!',0xa                 ;our dear string
len                 equ $ - msg                             ;length of our dear string
