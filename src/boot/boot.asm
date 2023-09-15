[bits 16]		; timto assembleru rekneme, ze vysledny kod chceme pro 16-bitove procesory
[org 0x7c00]	; timto rekneme assembleru, ze kod je nacten na adrese 0x7c00

start:
	jmp _main

;;;
; OEM blok parametru
;;;

times 0Bh-$+start	db 0

OEM:				db "ITNET OS"

BytyNaSektor:		dw 512
SektoryNaCluster:	db 1
RezervovaneSektory:	dw 1
PocetFATu:			db 2
KorenoveVstupy:		dw 224
CelkemSektoru:		dw 2880
Media:				db 0xF0
SektoryNaFAT:		dw 9
SektoryNaTrack:		dw 18
HlavyNaValec:		dw 2
SkryteSektory:		dd 0
CelkemVelkychSektoru:	dd 0
CisloDisku:			db 0
Nepouzivano:		db 0
ExtZavadeciPodpis:	db 0x29
SerioveCislo:		dd 0xa0a1a2a3
NazevDisku:			db "ITNETWORKOS"
SouborovySystem:	db "FAT12   "

zprava_hello_bootloader		db "Ahoj svete!", 0

%include "inc/boot/print.asm"

_main:
	xor ax, ax
	mov ds, ax
	mov es, ax

	mov si, zprava_hello_bootloader		; ulozi adresu retezce do registru SI
	call vypis							; vypise retezec "Hello Bootloader!"

	cli		; vypne preruseni
	hlt		; vypne procesor
	
times 510 - ($-$$) db 0		; tato operace odsadi magicke cislo
							; tak, at je vzdycky 2 byty pred koncem sektoru

dw 0xAA55	; posledni dva byty musi byt "magicke cislo"
			; aby bios precetl disk jako spustitelny

