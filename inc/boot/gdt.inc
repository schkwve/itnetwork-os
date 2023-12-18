gdt:
	; NULL popisovac
	dq 0

	; 16-bitovy code segment
	dw 0xFFFF		; limit (velikost)
	dw 0			; base (zacatek) - bity 0-15
	db 0			; base (zacatek) - bity 16-23
	db 10011010b	; access (present, ring 0, code segment, executable, direction 0, readable)
	db 00001111b	; granularity (1b pages, 16-bit protected mode) + limit (bity 16-19)
	db 0			; base (zacatek) - bity 23-32
	
	; 16-bitovy data segment
	dw 0xFFFF		; limit (velikost)
	dw 0			; base (zacatek) - bity 0-15
	db 0			; base (zacatek) - bity 16-23
	db 10010010b	; access (present, ring 0, data segment, executable, direction 0, readable)
	db 00001111b	; granularity (1b pages, 16-bit protected mode) + limit (bity 16-19)
	db 0			; base (zacatek) - bity 23-32

	; 32-bitovy code segment
	dw 0xFFFF		; limit (velikost)
	dw 0			; base (zacatek) - bity 0-15
	db 0			; base (zacatek) - bity 16-23
	db 10011010b	; access (present, ring 0, code segment, executable, direction 0, readable)
	db 11001111b	; granularity (4k pages, 32-bit protected mode) + limit (bity 16-19)
	db 0			; base (zacatek) - bity 23-32
	
	; 32-bitovy data segment
	dw 0xFFFF		; limit (velikost)
	dw 0			; base (zacatek) - bity 0-15
	db 0			; base (zacatek) - bity 16-23
	db 10010010b	; access (present, ring 0, data segment, executable, direction 0, readable)
	db 11001111b	; granularity (4k pages, 32-bit protected mode) + limit (bity 16-19)
	db 0			; base (zacatek) - bity 23-32

gdtr:
	dw gdtr - gdt - 1
	dd gdt