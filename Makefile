#
#  _____ _______         _                      _
# |_   _|__   __|       | |                    | |
#   | |    | |_ __   ___| |___      _____  _ __| | __  ___ ____
#   | |    | | '_ \ / _ \ __\ \ /\ / / _ \| '__| |/ / / __|_  /
#  _| |_   | | | | |  __/ |_ \ V  V / (_) | |  |   < | (__ / /
# |_____|  |_|_| |_|\___|\__| \_/\_/ \___/|_|  |_|\_(_)___/___|
#                   ___
#                  |  _|___ ___ ___
#                  |  _|  _| -_| -_|  LICENCE
#                  |_| |_| |___|___|
#
#    REKVALIFIKAČNÍ KURZY  <>  PROGRAMOVÁNÍ  <>  IT KARIÉRA
#
# Tento zdrojový kód pochází z IT kurzů na WWW.ITNETWORK.CZ
#
# Můžete ho upravovat a používat jak chcete, musíte však zmínit
# odkaz na http://www.itnetwork.cz
#

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
