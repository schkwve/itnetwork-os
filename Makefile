.PHONY: floppy
floppy: build/floppy.img

build/boot.bin: src/boot/boot.asm
	mkdir -p build
	nasm -fbin src/boot/boot.asm -o build/boot.bin

build/floppy.img: build/boot.bin
	cp build/boot.bin build/floppy.img
	truncate -s 1440k build/floppy.img

.PHONY: spust
spust: floppy
	qemu-system-i386 -fda build/floppy.img

.PHONY: vycisti
vycisti:
	rm -r build
