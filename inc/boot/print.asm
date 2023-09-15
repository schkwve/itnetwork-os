vypis:
	lodsb			; nacte byte z adresy ulozene v DS:SI do registru AX
	or al, al		; vsechny retezce jsou ukonceny bytem '\0',
	jz vypisHotovo	; pokud tedy se objevi tento znak, jsme hotovi.
	mov ah, 0eh		; preruseni 0x10 ma vice funkci - funkce 0x0e vypisuje text na obrazovku
	int 10h
	jmp vypis		; vypiseme dalsi znak na rade

vypisHotovo:
	ret