; asm_c_call.asm    print a string using printf and getenv
; Assemble:   nasm -f elf64 -l asm_c_call.lst  asm_c_call.asm
; Link:     gcc -m64 -o asm_c_call  asm_c_call.o
; Run:      ./asm_c_call

; Equivalent C code
; // hello.c
; #include <stdio.h>
; int main()
; {
;   char msg[] = "Hello world\n";
;   char envKey[] = "PATH";
;   // printf("%s\n", msg);
;   printf("%s\n", getenv(envKey));
;   return 0;
; }
 
; Declare needed C  functions
        extern printf        ; the C function, to be called
        extern getenv

; Define data and variables
        section .data        ; Data section, initialized variables

msg:     db "Hello world", 0 ; C string needs 0
fmt:     db "%s", 10, 0      ; The printf format, "\n",'0'
envKey:  db "PATH", 0
envVal:  db 5 

        section .text     ; Code section.

        global main       ; the standard gcc entry point

main:                     ; the program label for the entry point
        push    rbp       ; set up stack frame, must be alligned

        mov rdi, envKey
        mov rax,0
        call     getenv   ; this will set rax to point to a null terminated string in memory
 
        mov rdi,fmt
        ;mov rsi,msg
        mov rsi, rax      ; Tells printf we want to print the result of getenv (which rax points to)
        mov rax,0         ; or can be  xor  rax,rax
        call    printf    ; Call C function


        pop rbp           ; restore stack
        mov rax,0         ; normal, no error, return value
        ret               ; return

