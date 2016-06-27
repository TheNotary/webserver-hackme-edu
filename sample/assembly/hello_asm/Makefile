BASE_NAME = hello_asm

build:
	nasm -f elf64 ${BASE_NAME}.asm
	ld -e _start -o ${BASE_NAME} ${BASE_NAME}.o

.PHONY: build
