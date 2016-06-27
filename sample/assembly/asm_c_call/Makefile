BASE_NAME = asm_c_call

build:
	nasm -f elf64 -l ${BASE_NAME}.lst  ${BASE_NAME}.asm
	gcc -m64 -o ${BASE_NAME} ${BASE_NAME}.o

.PHONY: build
