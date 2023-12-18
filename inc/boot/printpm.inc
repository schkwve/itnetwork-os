[bits 32]
vypisPM:
	lodsb			; nacte byte z adresy ulozene v ESI do registru AX
	or al, al		; vsechny retezce jsou ukonceny bytem '\0',
	jz vypisHotovoPM	; pokud tedy se objevi tento znak, jsme hotovi.
	mov [edi], al	; na adrese v EDI zapiseme nacteny znak
	inc edi
	mov [edi], byte 0x2A ; bila na cernem
	inc edi
	jmp vypisPM		; vypiseme dalsi znak na rade
	vypisHotovoPM:	
		ret