[org 0x0]
[bits 16]

jmp main

%include "inc/boot/gdt.inc"

NactiGDT:
	lgdt [gdtr]
	ret

ZapniA20:
	in al, 0x92		; Ziskej aktualni hodnotu z portu 0x92
	or al, 2		; Tato hodnota OR 2 = druhy bit musi byt 1
	out 0x92, al	; Novou hodnotu posleme zpatky do portu 0x92
	ret

main:
	push cs
	pop ds

	call ZapniA20
	call NactiGDT
	call PrepniDoPM
	jmp .halt
.halt:
	hlt

PrepniDoPM:
	mov eax, cr0				; Ziskej aktualni hodnotu CR0
	or al, 1					; Tato hodnota OR 1 = prvni bit musi byt 1
	mov cr0, eax				; Novou hodnotu nastavime zpet do registru CR0
	jmp dword 0x08:.pmode_main	; Far Jump

[bits 32]

.pmode_main:
	mov ax, 0x10
	mov ds, ax
	mov ss, ax
	mov esi, zprava
	mov edi, obrazovka
	cld
	mov [edi], byte 'A'
	inc edi
	mov [edi], byte 0x2A
	inc edi
	jmp .hlt
.hlt:
	hlt

%include "inc/boot/printpm.inc"

obrazovka equ 0xB8000