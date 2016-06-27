BASE_NAME = correct_asm

build:
	nasm -f elf64 -l ${BASE_NAME}.lst  ${BASE_NAME}.asm
	gcc -m64 -o ${BASE_NAME} ${BASE_NAME}.o

.PHONY: build
