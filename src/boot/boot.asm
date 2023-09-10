;
;  _____ _______         _                      _
; |_   _|__   __|       | |                    | |
;   | |    | |_ __   ___| |___      _____  _ __| | __  ___ ____
;   | |    | | '_ \ / _ \ __\ \ /\ / / _ \| '__| |/ / / __|_  /
;  _| |_   | | | | |  __/ |_ \ V  V / (_) | |  |   < | (__ / /
; |_____|  |_|_| |_|\___|\__| \_/\_/ \___/|_|  |_|\_(_)___/___|
;                   ___
;                  |  _|___ ___ ___
;                  |  _|  _| -_| -_|  LICENCE
;                  |_| |_| |___|___|
;
;    REKVALIFIKAČNÍ KURZY  <>  PROGRAMOVÁNÍ  <>  IT KARIÉRA
;
; Tento zdrojový kód pochází z IT kurzů na WWW.ITNETWORK.CZ
;
; Můžete ho upravovat a používat jak chcete, musíte však zmínit
; odkaz na http://www.itnetwork.cz
;

[org 0x7c00]	; timto rekneme assembleru, ze kod je nacten na adrese 0x7c00
 
[bits 16]		; timto assembleru rekneme, ze vysledny kod chceme pro 16-bitove procesory

_main:
	cli		; vypne preruseni
	hlt		; vypne procesor
	
times 510 - ($-$$) db 0		; tato operace odsadi magicke cislo
							; tak, at je vzdycky 2 byty pred koncem sektoru

dw 0xAA55	; posledni dva byty musi byt "magicke cislo"
			; aby bios precetl disk jako spustitelny

