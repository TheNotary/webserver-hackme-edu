; asm_c_call.asm    print a string using printf and getenv
; Assemble:   nasm -f elf64 -l asm_c_call.lst  asm_c_call.asm
; Link:     gcc -m64 -o asm_c_call  asm_c_call.o
; Run:      ./asm_c_call

; Equivalent C code
; // hello.c
; #include <stdio.h>
; int main()
; {
;   char envKey[] = "PATH";
;   //char envVal[5]; // this is a pointer though...
;
;   envVal = getenv(envKey);
;
;   // printf("%s\n", envVal);
;   printf("%s\n", getenv(envKey));
;   return 0;
; }

; Declare needed C  functions
        extern printf        ; the C function, to be called
        extern getenv
        extern strsep
        extern str_copy

; Define data and variables
        section .data        ; Data section, initialized variables

msg:     db "Hello world", 0 ; C string needs 0
fmt:     db "%s", 0      ; The printf format, "\n",'0'

header:  db "Content-type: text/plain", 10, 10, 0
envKey:  db "QUERY_STRING", 0
envVal:  db 5
queryStringPointer: dq 1     ; Pointer to response from getenv("querystring")

        section .text     ; Code section.

        global main       ; the standard gcc entry point

main:                     ; the program label for the entry point
        push    rbp       ; set up stack frame, must be alligned


        ; >>> Print the header
        mov rdi,fmt
        mov rsi,header
        mov rax,0
        call    printf


        ; >>> get env var
        mov rdi, envKey
        mov rax,0
        call     getenv   ; this will set rax to point to a null terminated string in memory
        ; rax now points to the position in of the ENV var sting where QUERY_STRING was, null terminated...
        mov [queryStringPointer], rax  ; store response in variable


        ; while ((token = strsep(&str_copy, "="))) my_fn(token);

        ; >>> Print string value of ENV['QUERY_STRING']
        mov rdi,fmt
        mov rsi, [queryStringPointer]
        mov rax,0         ; or can be  xor  rax,rax
        call    printf    ; Call C function



        ; >>> End program
        pop rbp           ; restore stack
        mov rax,0         ; normal, no error, return value
        ret               ; return
