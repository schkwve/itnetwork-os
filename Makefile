.PHONY: floppy
floppy: build/floppy.img

build/boot.bin: src/boot/boot.asm
	mkdir -p build
	nasm -fbin src/boot/boot.asm -o build/boot.bin

build/bootldr.sys: src/boot/stage2.asm
	mkdir -p build
	nasm -fbin src/boot/stage2.asm -o build/bootldr.sys

build/floppy.img: build/boot.bin build/bootldr.sys
	dd if=/dev/zero of=$@ bs=512 count=2880
	mkfs.fat -F12 -n "ITOS" $@
	dd if=build/boot.bin of=$@ conv=notrunc	
	mcopy -i $@ build/bootldr.sys ::

.PHONY: spust
spust: floppy
	qemu-system-i386 -fda build/floppy.img

.PHONY: vycisti
vycisti:
	rm -r build
