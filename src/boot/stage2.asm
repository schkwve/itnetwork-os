[org 0x0]
[bits 16]

jmp main

%include "inc/boot/print.asm"

main:
	push cs
	pop ds

	mov si, Msg
	call vypis

	cli
	hlt

Msg	db	"Ahoj svete!",13,10,0