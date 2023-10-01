//bank1, 13 bank pamięci

		org $4000	
		dta b($d4)		;$bfd4
		
//tablice rmt player		
INSTRPAR	equ 12
tabbeganddistor
 dta frqtabpure-frqtab,$00
 dta frqtabpure-frqtab,$20
 dta frqtabpure-frqtab,$40
 dta frqtabbass1-frqtab,$c0
 dta frqtabpure-frqtab,$80
 dta frqtabpure-frqtab,$a0
 dta frqtabbass1-frqtab,$c0
 dta frqtabbass2-frqtab,$c0

vibtabbeg dta 0,vib1-vib0,vib2-vib0,vib3-vib0
vib0	dta 0
vib1	dta 1,-1,-1,1
vib2	dta 1,0,-1,-1,0,1
vib3	dta 1,1,0,-1,-1,-1,-1,0,1,1
vibtabnext
		dta vib0-vib0+0
		dta vib1-vib0+1,vib1-vib0+2,vib1-vib0+3,vib1-vib0+0
		dta vib2-vib0+1,vib2-vib0+2,vib2-vib0+3,vib2-vib0+4,vib2-vib0+5,vib2-vib0+0
		dta vib3-vib0+1,vib3-vib0+2,vib3-vib0+3,vib3-vib0+4,vib3-vib0+5,vib3-vib0+6,vib3-vib0+7,vib3-vib0+8,vib3-vib0+9,vib3-vib0+0
	
		:193 dta b(0)	;wyrównanie do strony !!
		
volumetab
	dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	dta $00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$01
	dta $00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02
	dta $00,$00,$00,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02,$03,$03,$03
	dta $00,$00,$01,$01,$01,$01,$02,$02,$02,$02,$03,$03,$03,$03,$04,$04
	dta $00,$00,$01,$01,$01,$02,$02,$02,$03,$03,$03,$04,$04,$04,$05,$05
	dta $00,$00,$01,$01,$02,$02,$02,$03,$03,$04,$04,$04,$05,$05,$06,$06
	dta $00,$00,$01,$01,$02,$02,$03,$03,$04,$04,$05,$05,$06,$06,$07,$07
	dta $00,$01,$01,$02,$02,$03,$03,$04,$04,$05,$05,$06,$06,$07,$07,$08
	dta $00,$01,$01,$02,$02,$03,$04,$04,$05,$05,$06,$07,$07,$08,$08,$09
	dta $00,$01,$01,$02,$03,$03,$04,$05,$05,$06,$07,$07,$08,$09,$09,$0A
	dta $00,$01,$01,$02,$03,$04,$04,$05,$06,$07,$07,$08,$09,$0A,$0A,$0B
	dta $00,$01,$02,$02,$03,$04,$05,$06,$06,$07,$08,$09,$0A,$0A,$0B,$0C
	dta $00,$01,$02,$03,$03,$04,$05,$06,$07,$08,$09,$0A,$0A,$0B,$0C,$0D
	dta $00,$01,$02,$03,$04,$05,$06,$07,$07,$08,$09,$0A,$0B,$0C,$0D,$0E
	dta $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F	
	
frqtab
	ERT [<frqtab]!=0	;* frqtab must begin at the memory page bound! (i.e. $..00 address)
frqtabbass1
	dta $BF,$B6,$AA,$A1,$98,$8F,$89,$80,$F2,$E6,$DA,$CE,$BF,$B6,$AA,$A1
	dta $98,$8F,$89,$80,$7A,$71,$6B,$65,$5F,$5C,$56,$50,$4D,$47,$44,$3E
	dta $3C,$38,$35,$32,$2F,$2D,$2A,$28,$25,$23,$21,$1F,$1D,$1C,$1A,$18
	dta $17,$16,$14,$13,$12,$11,$10,$0F,$0E,$0D,$0C,$0B,$0A,$09,$08,$07
frqtabbass2
	dta $FF,$F1,$E4,$D8,$CA,$C0,$B5,$AB,$A2,$99,$8E,$87,$7F,$79,$73,$70
	dta $66,$61,$5A,$55,$52,$4B,$48,$43,$3F,$3C,$39,$37,$33,$30,$2D,$2A
	dta $28,$25,$24,$21,$1F,$1E,$1C,$1B,$19,$17,$16,$15,$13,$12,$11,$10
	dta $0F,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04,$03,$02,$01,$00
frqtabpure
	dta $F3,$E6,$D9,$CC,$C1,$B5,$AD,$A2,$99,$90,$88,$80,$79,$72,$6C,$66
	dta $60,$5B,$55,$51,$4C,$48,$44,$40,$3C,$39,$35,$32,$2F,$2D,$2A,$28
	dta $25,$23,$21,$1F,$1D,$1C,$1A,$18,$17,$16,$14,$13,$12,$11,$10,$0F
	dta $0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04,$03,$02,$01,$00,$00	
	
playFX
	jsr RMT_P2
	jmp RMT_Copy
		
MODUL	equ *		
		ins 'b0.rmt'
MODUL_end	equ *

	:46 dta b(0)
	
	icl 'rmtplayr.asm'

alive_wav	
	ins 'samples/alive1.wav'
	dta b(0)
blastoff_wav
	ins 'samples/blastoff.wav'
	dta b(0)
conred_wav
	ins 'samples/conred.wav'
	dta b(0)
formation_wav
	ins 'samples/formation.wav'
	dta b(0)
gameover_wav	
	ins 'samples/gameover.wav'
	dta b(0)
spy_wav
	ins 'samples/spy.wav'
	dta b(0)
		
e1		equ *
		:$c000-e1 dta b(0)
		