[bits 16]		; timto assembleru rekneme, ze vysledny kod chceme pro 16-bitove procesory
[org 0]	; timto rekneme assembleru, ze kod je nacten na adrese 0x7c00

start:
	jmp _main

;;;
; OEM blok parametru
;;;

OEM:				db "ITNET OS"

BytyNaSektor:		dw 512
SektoryNaCluster:	db 1
RezervovaneSektory:	dw 1
PocetFATu:			db 2
KorenoveAdresare:		dw 224
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

%include "inc/boot/print.inc"

precti_sektory:
	.vstup:
		mov di, 0x0005	; maximalni pocet chyb
	.smycka:
		push ax
		push bx
		push cx
		call lba_na_chs				; preloz LBA na CHS
		mov ah, 0x02					; funkce 0x02 - precti sektor(y)
		mov al, 0x01					; chceme pouze jeden sektor
		mov ch, byte [track]
		mov cl, byte [sektor]
		mov dh, byte [hlava]
		mov dl, byte [CisloDisku]
		int 0x13
		jnc .hotovo					; skonci pokud nenastala chyba
		xor ax, ax					; Floppy Reset
		int 0x13
		dec di						; pocet_pokusu -= 1
		pop cx
		pop bx
		pop ax
		jnz .smycka	; zkusime to znovu
		int 0x18
	.hotovo:
		pop cx
		pop bx
		pop ax
		add bx, word [BytyNaSektor]
		inc ax
		loop .vstup
		ret

chs_na_lba:
	sub ax, 0x0002
	xor cx, cx
	mov cl, byte [SektoryNaCluster]
	mul cx
	add ax, word [datasektor]
	ret

lba_na_chs:
	xor dx, dx
	div word [SektoryNaTrack]
	inc dl
	mov byte [sektor], dl
	xor dx, dx
	div word [HlavyNaValec]
	mov byte [hlava], dl
	mov byte [track], al
	ret

_main:
	cli
	mov ax, 0x07c0
	mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

	mov ax, 0x0000
	mov ss, ax
	mov sp, 0xFFFF
	sti

	mov si, ZpravaNacitani
	call vypis

	xor cx, cx
	xor dx, dx
	mov ax, 0x0020
	mul word [KorenoveAdresare]
	div word [BytyNaSektor]
	xchg ax, cx

	mov al, byte [PocetFATu]			; pocet FATu
	mul word [SektoryNaFAT]				; pocet sektoru na jeden FAT
	add ax, word [RezervovaneSektory]
	mov word [datasektor], ax			; zaklad korenoveho adresare
	add word [datasektor], cx

	mov bx, 0x0200						; korenovy adresar chceme zkopirovat nad zavadec
	call precti_sektory

	mov cx, word [KorenoveAdresare]
	mov di, 0x0200						; disketa je nahrana na 0x07c0:200
    .smycka_hledani:
		push cx
		mov cx, 0x000b
		mov si, NazevBootStage2
		push di
		rep cmpsb
		pop di
		je .nacti_fat
		pop cx
		add di, 0x0020
		loop .smycka_hledani
		jmp chyba
	
	.nacti_fat:
		; ulozime pocatecni cluster zavadeciho obrazu
		mov si, NovyRadek
		call vypis
		mov dx, word [di + 0x001a]
		mov word [cluster], dx
		xor ax, ax
		mov al, byte [PocetFATu]
		mul word [SektoryNaFAT]
		mov cx, ax
		mov ax, word [RezervovaneSektory]
		mov bx, 0x0200
		call precti_sektory

		mov si, NovyRadek
		call vypis
		mov ax, 0x0050
		mov es, ax
		mov bx, 0x0000
		push bx
	
	.nacti_obraz:
		mov ax, word [cluster]
		pop bx
		call chs_na_lba
		xor cx, cx
		mov cl, byte [SektoryNaCluster]
		call precti_sektory
		push bx
     
		mov ax, word [cluster]
		mov cx, ax
		mov dx, ax
		shr dx, 0x0001
		add cx, dx
		mov bx, 0x0200
		add bx, cx
		mov dx, word [bx]
		test ax, 0x0001
		jnz .lichy_cluster

     .sudy_cluster:
		and dx, 0000111111111111b
		jmp .hotovo

     .lichy_cluster:
		shr dx, 0x0004
          
     .hotovo:
		mov word [cluster], dx
		cmp dx, 0x0FF0			; jsme na konci souboru?
		jb .nacti_obraz

     hotovo:
		mov si, NovyRadek
		call vypis
		push word 0x0050
		push word 0x0000
		retf
		
	chyba:
		mov si, ZpravaChyba
		call vypis
		mov ah, 0x00
		int 0x16		; cekame na klavesnici
		int 0x19		; restart

	cli
	hlt

sektor db 0x00
hlava db 0x00
track db 0x00
datasektor dw 0x0000
cluster dw 0x0000

NazevBootStage2 db "BOOTLDR SYS"
NovyRadek db 0x0d, 0x0a, 0x00
ZpravaNacitani db 0x0d, 0x0a, "Nacitam druhou fazi ", 0x0d, 0x0a, 0x00
ZpravaChyba db 0x0d, 0x0a, "CHYBA: Stisknete jakekoliv tlacitko pro restart", 0x0a, 0x0d, 0x00
	
times 510 - ($-$$) db 0		; tato operace odsadi magicke cislo
							; tak, at je vzdycky 2 byty pred koncem sektoru

dw 0xAA55	; posledni dva byty musi byt "magicke cislo"
			; aby bios precetl disk jako spustitelny
