//bank3, 15 bank pamięci
			org $4000
			dta b($dc)		;numer banku ($4000) $bfdc
				
hsdlist_code
		dta b(112,$10)
		dta b(64+4),a(hscr)
		dta b(64+4),a(hscr+48)
		dta b(64+2),a(hscr+2*48)
		dta b(64+4),a(hscr+3*48)
		dta b($30)
		dta b(64+2),a(hscr+4*48)
		dta b(64+4),a(hscr+5*48)
		dta b(64+2),a(hscr+6*48)
		dta b(64+4),a(hscr+7*48)
		dta b(64+4),a(hscr+8*48)
		dta b($20)
		dta b(64+2),a(hscr+9*48)
		dta b(64+4),a(hscr+10*48)
		dta b(64+2),a(hscr+11*48)
		dta b(64+4),a(hscr+12*48)
		dta b(64+2),a(hscr+13*48)
		dta b(64+4),a(hscr+14*48)
		dta b(64+2),a(hscr+15*48)
		dta b(64+4),a(hscr+16*48)
		dta b(64+2),a(hscr+17*48)
		dta b(64+4),a(hscr+18*48)
		dta b(64+2),a(hscr+19*48)
		dta b(64+4),a(hscr+20*48)
		dta b(64+2),a(hscr+21*48)
		dta b(64+4),a(hscr+22*48)
		dta b(64+4),a(hscr+23*48)
		dta b(64+4),a(hscr+24*48)
		dta b(64+4),a(hscr+25*48)
		dta b(64+4),a(hscr+26*48)
		dta b(65),a(hsdlist)
		
		dta b(112,$10)
		dta b(64+4),a(hscr)
		dta b(64+4),a(hscr+48)
		dta b(64+2),a(hscr+48*2)		;CONGRATULATIONS !!
		dta b(64+4),a(hscr+48*3)
		dta b($40)
		dta b(64+2),a(hscr+48*4)		;THE HIGH SCORE
		dta b(64+4),a(hscr+48*5)
		dta b($40)
		dta b(64+2),a(hscr+48*6)		;OF THE DAY
		dta b(64+4),a(hscr+48*7)
		dta b(64+4),a(hscr+48*8)
		
		dta b(64+4),a(hscr+48*9)		;WYNIK
		dta b(64+4),a(hscr+48*10)
		dta b(64+4),a(hscr+48*11)
		dta b(64+4),a(hscr+48*12)
		dta b(64+4),a(hscr+48*13)
		dta b(64+4),a(hscr+48*14)
		dta b(64+4),a(hscr+48*15)
		dta b($30)		
		dta b(64+4),a(hscr+48*16)
		dta b(64+4),a(hscr+48*17)
		dta b($40)
		dta b(64+2),a(hscr+48*18)		;GO FOR THE
		dta b(64+4),a(hscr+48*19)
		dta b($40)
		dta b(64+2),a(hscr+48*20)		;SPACE RECORD NOW
		dta b(64+4),a(hscr+48*21)
		dta b(64+4),a(hscr+48*22)
		dta b(65),a(hsdlist1)

	
	
	
		icl 'znaki.asm'	
pokey_obx		
		ins 'pokey.obx'

;przerwanie vblk
vblk_code		equ *
			sta vblA

			inc zegar
			
			lda stan_gry
			beq vblk1
			cmp #1
			bne @+
			
			lda #pozWyniki
			sta HPOSP0    ;hiscore
			lda #pozWyniki+8
			sta HPOSP1
			lda #pozWyniki+16
			sta HPOSP2
			lda #pozWyniki+24
			sta HPOSM2
			lda #pozWyniki+26
			sta HPOSM1
			lda #pozWyniki+28
			sta HPOSM0
			lda #0
			sta SIZEM
			sta SIZEP0
			sta SIZEP1
			sta SIZEP2
			
			lda #kolorHiscore
			sta COLPM0
			sta COLPM1
			sta COLPM2
			
vblk1			
			lda vblA
			rti


@			equ *
			lda pauza
			bne @+			;podczas pauzy nie odgrywaj dzwiekow

_vbsnd1a		equ *+1			
			lda #$00		;zamiast SETPOKEY
			sta audf1
_vbsnd2a		equ *+1			
			lda #$00
			sta audc1
_vbsnd3a		equ *+1			
			lda #$00
			sta audf2
_vbsnd4a		equ *+1			
			lda #$00
			sta audc2
_vbsnd5a		equ *+1			
			lda #$00
			sta audf3
_vbsnd6a		equ *+1			
			lda #$00
			sta audc3
			
_vbsnd7a		equ *+1			
			lda #$00
			;sta audctl		
			
@			lda vblFlaga
			bne @+
			
			lda vblA
			rti
			
vblk2			
			pha					;jeślśli vblk przerwie irq to pomin strzal
			lda vb_ad+1
			pha
			lda znacznik
			pha
			lda vblA
			dec vblFlaga
			rti
	
@			lda trafienie		
			ora startMapy
			bne vblk1
			
			pla
			sta znacznik
			pla
			sta vb_ad+1		;adres powrotu
			pla
			sta vb_ad+2
			beq vblk2
			
				
			lda #>vb_strzal
			pha
			lda #<vb_strzal		;adres pod ktory skoczymy po zakonczeniu przerwania
			pha	
			lda znacznik
			pha	
			
			lda $4000
			sta vb_end+1
			lda BANK2
			rti
_vb_end			
			lda $bfff		;przywroc bank
			ldx vblX		;przywroc rejestry i znaczniki
			ldy vblY
			lda vblA
			plp
_vb_ad	jmp $ffff 		
			
vblk_codeEnd		


dli_code	equ *
dlia		equ *
		pha

		mwa #pokey irqv
			
		lda #pozWyniki
		sta HPOSP0    ;hiscore
		lda #pozWyniki+8
		sta HPOSP1
		lda #pozWyniki+16
		sta HPOSP2
		lda #pozWyniki+24
		sta HPOSM2
		lda #pozWyniki+26
		sta HPOSM1
		lda #pozWyniki+28
		sta HPOSM0
		lda #0
		sta SIZEM
			
		lda #kolorHiscore
		sta COLPM0
		sta COLPM1
		sta COLPM2
		
		mva #36-1 AUDF4
		sta WSYNC

		;dta 2		
		//mva #0 IRQEN

		mva #4 IRQEN
		sta sirq
	
		pla
		rti 
		
pokeya	equ *
		sta rejA
		
		mva #35 AUDF4
		lda #kolorLiczby		;pod Hiscore
		sta COLPM0
		sta COLPM1
		sta COLPM2
		mva #pozWyniki+2 HPOSP0
		mva #pozWyniki+10 HPOSP1
		mva #pozWyniki+18 HPOSP2
		
		mwa #pokey1 irqv
		
		

		mva #0 irqen
		mva #4 irqen

		
		lda rejA
		rti
		
pokey1a	equ *
		sta rejA
		
		
		mva #pozWyniki HPOSP0		;1up
		mva #pozWyniki+8 HPOSP1
kolor1upa	equ *+1
		mva #kolor1ups COLPM0
		sta COLPM1
		
		mwa #pokey2 irqv
		mva #35 AUDF4
		
		
		mva #0 irqen
		mva #4 irqen

		
		lda rejA
		rti

pokey2a	equ *
		sta rejA
			
		mva #pozWyniki+2 HPOSP0		;score
		mva #pozWyniki+10 HPOSP1
		mva #kolorLiczby COLPM0
		sta COLPM1
		
		mwa #pokey3 irqv
		
		lda #100
		sta AUDF4
		
	
		mva #0 irqen
		mva #4 irqen

		
		lda rejA
		rti		
	

pokey3a	equ *
		sta rejA
			
		
formacja_stana equ *+1
		lda #$00
		beq @+
		cmp #5
		bne pk3aa
		
@		mva #pozWyniki HPOSM2
	
		mwa #pokey4 irqv
		
		lda #82-1
		sta AUDF4
		
	
		mva #0 irqen
		mva #4 irqen

		
		lda rejA
		rti		

pk3aa	mva #pozWyniki-1 HPOSM2	
		lda conditionColor	;w czasie formacji mryga czerwonym napisem
		sta COLPM0
		sta COLPM1
		sta COLPM2
		
		mwa #pokey4 irqv
		
		lda #81
		sta AUDF4
		
	
		mva #0 irqen
		mva #4 irqen
		
		lda rejA
		rti		
		
pokey4a	equ *
		sta rejA
		lda #255			;condition napis
		sta AUDF4
conditionColora	equ *+1		
		lda #$00		;conditionColor
		sta COLPM1
		sta COLPM2
conditionColor1a	equ *+1
		lda #$00
		sta COLPM0
		
		mwa #pokey_5 irqv
		
	
		mva #0 irqen
		mva #4 irqen

			
		lda rejA
		rti
		
pokey_5a	equ *
		sta rejA

		mva #kolorMapa	COLPM3
		;mva #pozWyniki-1 HPOSP3

		
			
		mva #kolorLiczby COLPM0
		
		lda #16+4
		sta SIZEM
		mva #kolorCzerwony COLPM1
		
		sta COLPM2
		mva #pozWyniki+19 HPOSM2
		mva #pozWyniki+23 HPOSM1
		
radarX1a	equ *+1
		mva #$00 HPOSM0  ;pozycja statku na radarze
		mva #1 SIZEP2		;przeciwnicy na radarze
		mva #pozWyniki+3 HPOSP2
		
		
		lda #185
		sta AUDF4
		
		mwa #pokey5a irqv
	
		mva #0 irqen
		mva #4 irqen

		
		lda startMapy
		cmp #10
		bcs @+		
		
		lda #108 	;pozWyniki-1-68		;statek srodek 108
		sta HPOSP0
		sta HPOSP1	
		
		lda rejA
		rti
		
@		mva #0 HPOSP0
		sta HPOSP1
		
		lda rejA
		rti
		
pokey5aa	equ *
		sta rejA
		
		lda #110-18
		sta AUDF4
		mwa #pokey6 irqv
		
	
		mva #0 irqen
		mva #4 irqen

		
		lda rejA
		rti
		
pokey6a	equ *
		sta rejA

		
		mva #$0d COLPM0	
		sta COLPM1

		sta COLPM2
				
		lda #0
		sta SIZEP2

		mva #1+4+16+64 SIZEM
				;zakonczenie mapy
		mva #0 COLPM3		;koniec mapy zapasowe statki		
		
poz2livesa equ *+1
		mva #$00 HPOSP2		
		mva #$00 HPOSP1
		mva #$00 HPOSP0
poz2mlivesa	equ *+1		
		mva #$00 HPOSM2
		mva #$00 HPOSM1
		mva #$00 HPOSM0
		mva #1+16 GTIACTL
		
		mwa #pokey7 irqv
		
		lda #26
		sta AUDF4
		
	
		mva #0 irqen
		mva #4 irqen

		
		lda rejA
		rti
			

	
pokey7a	equ *
		sta rejA
		
		
		lda #$00
		sta AUDF4
		sta SIZEM
		sta irqen
		sta sirq
		
		mva #1 GTIACTL
		mva #pozWyniki HPOSP0
		mva #pozWyniki+8 HPOSP1
		mva #pozWyniki+16 HPOSM1		;Round
		mva #pozWyniki+18 HPOSM0
		mva #pozWyniki+22 HPOSP2
		mva #kolorLevel COLPM2
		mva #kolorRound COLPM0
		sta COLPM1
		
		lda rejA
		rti
pokey_codeend	equ *

init_rmt_code
		pha
		lda $4000
		sta init_rmt+15
		lda BANK1	;bank1
		pla
		jsr rmt_init
		lda $bfff	;poprzedni bank
		rts

play_rmt_code
		lda $4000
		sta play_rmt+13
		lda BANK1	;bank1
		jsr rmt_play
		lda $bfff	;poprzedni bank
		rts
		
sfx_rmt_code
		pha
		lda $4000
		sta sfx_rmt+15
		lda BANK1	;bank1
		pla
		jsr rmt_sfx
		lda $bfff	;poprzedni bank
		rts 

getSongLine_rmt_code
		pha
		lda $4000
		sta getSongLine_rmt+15
		lda BANK1	;bank1
		pla
		jsr GetSongLine
		lda $bfff	;poprzedni bank
		rts 
		
skok_title_code
		lda BANK3 
		jsr title
		lda BANK2
		rts		
		
	

go_bank_code
		sta go_bank+16
		stx go_bank+19
		sty go_bank+20
		lda $4000
		sta go_bank+22 
		lda BANK3
		jsr czyscObraz1
		lda $bfdc
		rts
		
jmp_bank_code
		sta jmp_bank+10
		stx jmp_bank+13
		sty jmp_bank+14
		lda $bfff
		jmp $ffff
		
mute_rmt_code	equ *	

		lda $4000
		sta mute_rmt+21
		ldx #<(rmt_goto+$02*4)		
		ldy #>(rmt_goto+$02*4)
		stx p_song
		sty p_song+1
		lda BANK1
		jsr GetSongLine				
		lda $bfff
		rts		
	
;rysuje duszki przy przesunięciu DX=0 i DY=0 , 4znaki
drawDX4_
			ldy #7
@			equ *
			.rept 4, #
sznakX4:1_	equ *
			lda $ffff,y
maskX4:1_	and $ffff,y
ksztX4:1_	ora $ffff,y

nznakX4:1_	equ *
			sta $ffff,y
			.endr
			dey
			bpl @-
			
			ldx zapX
			lda #0
			sta enemyEkran,x
			rts

;rysuje duszki przy przesunięciu DX>0 i DY=0
drawDX6_
			ldy #7
@			equ *
			.rept 6, #
sznakX6:1_	equ *
			lda $ffff,y
maskX6:1_	and $ffff,y
ksztX6:1_	ora $ffff,y

nznakX6:1_	equ *
			sta $ffff,y
			.endr
			dey
			bpl @-
			
			ldx zapX
			lda #0
			sta enemyEkran,x
			rts
			
;rysuje duszki przy DX=0 i DY>0 , 6 znaków
drawDY6_
			ldy #7
@			equ *

sznakY60_	equ *
			lda $ffff,y
maskY60_	and $ffff,y
ksztY60_	ora $ffff,y
nznakY60_	equ *
			sta $ffff,y
			
sznakY61_	equ *
			lda $ffff,y
maskY61_	and $ffff,y
ksztY61_	ora $ffff,y
nznakY61_	equ *
			sta $ffff,y
			
sznakY62_	equ *
			lda $ffff,y
nznakY62_	equ *
			sta $ffff,y		

sznakY63_	equ *
			lda $ffff,y
maskY63_	and $ffff,y
ksztY63_	ora $ffff,y

nznakY63_	equ *
			sta $ffff,y
			
sznakY64_	equ *
			lda $ffff,y
maskY64_	and $ffff,y
ksztY64_	ora $ffff,y

nznakY64_	equ *
			sta $ffff,y
			
sznakY65_	equ *
			lda $ffff,y
nznakY65_	equ *
			sta $ffff,y				
			
			dey
petlaY6_	equ *
			cpy #$ff
			bne @-
			
@			equ *
sznakY60b_	equ *
			lda $ffff,y
nznakY60b_	equ *
			sta $ffff,y
			
sznakY61b_	equ *
			lda $ffff,y
maskY61b_	and $ffff,y
ksztY61b_	ora $ffff,y

nznakY61b_	equ *
			sta $ffff,y	
			
sznakY62b_	equ *
			lda $ffff,y
maskY62b_	and $ffff,y
ksztY62b_	ora $ffff,y

nznakY62b_	equ *
			sta $ffff,y			
			
sznakY63b_	equ *
			lda $ffff,y
nznakY63b_	equ *
			sta $ffff,y
			
sznakY64b_	equ *
			lda $ffff,y
maskY64b_	and $ffff,y
ksztY64b_	ora $ffff,y
nznakY64b_	equ *
			sta $ffff,y	
			
sznakY65b_	equ *
			lda $ffff,y
maskY65b_	and $ffff,y
ksztY65b_	ora $ffff,y

nznakY65b_	equ *
			sta $ffff,y	
			
			dey
			bpl @-
			
			ldx zapX
			lda #0
			sta enemyEkran,x
			rts			
			
;rysuje duszki przy DX>0 i DY>0 , 9 znaków
drawDY9_
			ldy #7
@			equ *

sznakY90_	equ *
			lda $ffff,y
maskY90_	and $ffff,y
ksztY90_	ora $ffff,y

nznakY90_	equ *
			sta $ffff,y
			
sznakY91_	equ *
			lda $ffff,y

maskY91_	and $ffff,y
ksztY91_	ora $ffff,y

nznakY91_	equ *
			sta $ffff,y
			
sznakY92_	equ *
			lda $ffff,y
nznakY92_	equ *
			sta $ffff,y		

sznakY93_	equ *
			lda $ffff,y
maskY93_	and $ffff,y
ksztY93_	ora $ffff,y

nznakY93_	equ *
			sta $ffff,y
			
sznakY94_	equ *
			lda $ffff,y

maskY94_		and $ffff,y
ksztY94_		ora $ffff,y

nznakY94_	equ *
			sta $ffff,y
			
sznakY95_	equ *
			lda $ffff,y
nznakY95_	equ *
			sta $ffff,y				
			
sznakY96_	equ *
			lda $ffff,y

maskY96_	and $ffff,y
ksztY96_	ora $ffff,y

nznakY96_	equ *
			sta $ffff,y
			
sznakY97_	equ *
			lda $ffff,y

maskY97_	and $ffff,y
ksztY97_	ora $ffff,y

nznakY97_	equ *
			sta $ffff,y
			
sznakY98_	equ *
			lda $ffff,y
nznakY98_	equ *
			sta $ffff,y	
			
			dey
petlaY9_	equ *
			cpy #$ff
			bne @-
			
@			equ *
sznakY90b_	equ *
			lda $ffff,y
nznakY90b_	equ *
			sta $ffff,y
			
sznakY91b_	equ *
			lda $ffff,y

maskY91b_	and $ffff,y
ksztY91b_	ora $ffff,y

nznakY91b_	equ *
			sta $ffff,y	
			
sznakY92b_	equ *
			lda $ffff,y

maskY92b_	and $ffff,y
ksztY92b_	ora $ffff,y

nznakY92b_	equ *
			sta $ffff,y			
			
sznakY93b_	equ *
			lda $ffff,y
nznakY93b_	equ *
			sta $ffff,y
			
sznakY94b_	equ *
			lda $ffff,y

maskY94b_	and $ffff,y
ksztY94b_	ora $ffff,y

nznakY94b_	equ *
			sta $ffff,y	
			
sznakY95b_	equ *
			lda $ffff,y

maskY95b_	and $ffff,y
ksztY95b_	ora $ffff,y

nznakY95b_	equ *
			sta $ffff,y		
			
sznakY96b_	equ *
			lda $ffff,y
nznakY96b_	equ *
			sta $ffff,y
			
sznakY97b_	equ *
			lda $ffff,y

maskY97b_	and $ffff,y
ksztY97b_	ora $ffff,y

nznakY97b_	equ *
			sta $ffff,y	
			
sznakY98b_	equ *
			lda $ffff,y
maskY98b_	and $ffff,y
ksztY98b_	ora $ffff,y

nznakY98b_	equ *
			sta $ffff,y	
			
			dey
			bpl @-
			
			ldx zapX
			lda #0
			sta enemyEkran,x
			rts	
			
duszkiPrint_code
			lda $4000
			sta duszkiPrint+13
			lda BANK0
			jsr _duszkiPrint
			lda $bf00
			tay
			rts			
			
draw_end	equ *	

czyscObraz1	equ *
		lda #128
	.rept 29, #	
		:33 sta obraz1+:1*48+#
	.endr
/*		lda #128
		ldx #32
@		:29 sta obraz1+#*48,x
		dex
		bpl @-*/
		
		rts	

czyscObraz2	equ *
		lda #128
	.rept 29, #	
		:33 sta obraz2+:1*48+#
	.endr
		rts		
					
// S T A R T		
		
start_program	
		jsr play_logo

		mva #0 dmactl
		sta stan_gry
		sta audctl
		sta v_audctl
		sta hposm3
		sta nmien
		sta irqen
		sta muzyka
		sta znakX1
		sta znakY1
		sta znakDX
		sta znakDY
		sta hscore+2
		sta potg0
		sta punkty
		mva #1 sFire
		mva #3 forLicznik
		sta dowodca
		
		mva #10 punkty1
		mva #opoznienieRed punkty2
		mva #opoznienieCondition punkty3
		
		mva #2 skctl
		mva #2 chrctl	;znaki w inwersie
		mva #4 consol	;wlacz joystick
		
		mva #8 _gwzmaz
		sta _gwzmaz1
		mva #16 _gwzmaz+1
		sta _gwzmaz1+1
		
		
		mwa #$2000 hscore	;ustaw hscore na 20000
		
		lda #pozWyniki-1
		sta hposp3
		
		mwa #vblk vbiv
		mwa #dli dliv
		mwa #pokey irqv
		mwa #interrupt keyv
		mwa #interrupt padv
		
;tabX w RAM
		ldy #80
		ldx #208
@		txa
		sta tabx,x		;od 208 do 79 -> (208-79)
		sta tabX,y		;od 80 do 207 -> (208-79)
		iny
		inx
		cpx #80
		bne @-	
		
;kopiuj zestaw znaków
			ldx #0
@			lda znaki_ad,x
			sta znaki1,x
			sta znaki2,x
			lda znaki_ad+$100,x
			sta znaki1+$100,x
			sta znaki2+$100,x
			lda znaki_ad+$200,x
			sta znaki1+$200,x
			sta znaki2+$200,x
			dex
			bne @-
			
			ldx #31
@			lda bomba1,x
			sta znaki2+firstBombaChar*8,x
			dex
			bpl @-
		
			ldx #7
@			lda rakieta1,x
			sta znaki2+firstRakietaChar*8,x
			lda rakieta1+8,x
			sta znaki2+(firstRakietaChar+3)*8,x
			lda rakieta1+16,x
			sta znaki2+(firstRakietaChar+4)*8,x
			lda rakieta1+24,x
			sta znaki2+(firstRakietaChar+7)*8,x
			lda mwybuch2,x
			sta znaki2+firstMalyWybuchChar*8,x
			lda mwybuch2+8,x
			sta znaki2+firstMalyWybuchChar*8+8,x
			lda mwybuch2-8,x
			sta znaki1+firstMalyWybuchChar*8+8,x
			dex
			bpl @-	

;dlist
		mva #$d0 dlist
		mva #$74 dlist+1
		mwa #obraz2 dlist+2
		ldy #26
		lda #$34
@		sta dlist+4,y
		dey
		bpl @-
		mva #$14 dlist+31
		mva #$41 dlist+32
		mwa #dlist dlist+33	

;gwiazdyInit
		ldx #17
@		lda znakXa,x
		sta znakX,x
		lda znakYa,x
		sta znakY,x
		dex
		bpl @- 
		
		ldx #108
@		lda pokey_obx,x
		sta 0,x
		dex
		bpl @-
		
		ldx #19
@		lda hscnick_init,x
		sta hscNick1,x
		dex
		bpl @-

//przygotuj najlepsze wyniki		
		ldx #18
		lda #0
@		sta hscScore1,x
		dex
		dex
		bpl @-
		
		ldx #19
@		lda #2
		sta hscScore1,x
		dex
		dex
		lda #$20
		sta hscScore1,x
		dex
		dex
		bpl @-
		
		ldx #254
@		lda efnap1_code-1,x
		sta efnap1-1,x
		dex
		bne @-
		
;kopiujemy przerwanie vbl do ram
		ldx #vblk_codeend-vblk_code+1
@		lda vblk_code-1,x
		sta vblk-1,x
		dex
		bne @-	

;kopiujemy przerwania dli i pokey do ram
		ldx #0
@		lda dli_code,x
		sta dli,x
		lda dli_code+$100,x
		sta dli+$100,x
		lda drawDX4_,x
		sta drawDX4,x
		dex
		bne @-
		
		ldx #pokey_codeend-dli_code-$200
@		lda dli_code+$200-1,x
		sta dli+$200-1,x
		dex
		bne @-
		
//kopiujemy hsdlist i hsdlist1 do ram
		ldx #88+79
@		lda hsdlist_code-1,x
		sta hsdlist-1,x
		dex
		bne @-		
		
//init rmt
		ldx #17
@		lda init_rmt_code,x
		sta init_rmt,x
		lda sfx_rmt_code,x
		sta sfx_rmt,x
		lda getSongLine_rmt_code,x
		sta getSongLine_rmt,x
		dex
		bpl @-
		
//play rmt
		ldx #17
@		lda play_rmt_code,x
		sta play_rmt,x
		dex
		bpl @-	

//skok do title
		ldx #9
@		lda skok_title_code,x
		sta skok_title,x
		dex
		bpl @-
		
//jmp do innego banku
		ldx #14
@		lda jmp_bank_code,x
		sta jmp_bank,x
		dex
		bpl @-
		
		
//skok do do adresu X,Y
		ldx #24
@		lda go_bank_code,x
		sta go_bank,x
		dex
		bpl @-
		
		ldx #23
@		lda mute_rmt_code,x
		sta mute_rmt,x
		dex
		bpl @-
		
//duszki drawDX,DY
		ldx #draw_end-drawDX4_-$100
@		lda drawDX4_+$100-1,x
		sta drawDX4+$100-1,x
		dex
		bne @-
		
//tablica adresów znaków		
		mwa #znaki1	pom
		ldy #0
@		lda pom
		sta adresZnakL,y
		sta adresZnakL+128,y
		lda pom+1
		sta adresZnakH,y
		sta adresZnakH+128,y
		clc
		lda pom
		adc #8
		sta pom
		bcc *+4
		inc pom+1
		iny
		bpl @-
	
//adresy linii obrazu	
		mwa #obraz1a pom
		mwa #obraz2a pom1
		ldy #0
@		lda pom
		sta obraz1La,y
		lda pom+1
		sta obraz1Ha,y
		lda pom1
		sta obraz2La,y
		lda pom1+1
		sta obraz2Ha,y
		clc
		lda pom
		adc #48
		sta pom
		bcc @+
		inc pom+1
@		clc
		lda pom1
		adc #48
		sta pom1
		bcc @+
		inc pom1+1
@		iny
		cpy #37
		bne @-2		
		
		;adresy linii obraz1LH
		mwa #obraz1 pom
		mwa #obraz2 pom1
		ldy #0
@		lda pom
		sta obraz1L,y
		lda pom+1
		sta obraz1H,y
		lda pom1
		sta obraz2L,y
		lda pom1+1
		sta obraz2H,y
		clc
		lda pom
		adc #48
		sta pom
		bcc @+
		inc pom+1
@		clc
		lda pom1
		adc #48
		sta pom1
		bcc @+
		inc pom1+1
@		iny
		cpy #29
		bne @-2		
		
;wyczysc tablice dla baz
		ldx #14
		lda #0
@		sta tabLineA,x
		dex
		bpl @-
		
;przerwania tymczasowo w ram
		mva #$40 interrupt	;rti
		
;procedura skoku
		

		mva #$ad  run1		;lda $ffff
		mwa #$bfd8 run1+1	;bank14
		mva #$4c run1+3			;jmp $ffff
		mwa #run	run1+4
		
		jmp run1

		icl 'title.asm'
		icl 'hscore.asm'

	
		
hscNick_init	dta c'A',b(91,98,0),c'T',b(91,95,0),c'A',b(91,93,0),c'R',b(91),b(93,0),c'I',b(91,92),b(0)	

efnap1_code		equ *
			.rept 28, #
				ldx obraz1+19+#*48+29,y
				lda eftab1,x
				sta obraz1+19+#*48+29,y
			.endr
			rts
			dta b(0)
			

fcnt	equ pom
fadr	equ pom1
fhlp	equ pom2
cloc	equ pom0
regA	equ pom0a
regX	equ pom0b
regY	equ pom0c
			

do9000	:$9000-do9000 dta b(0)
fnt		ins "logoNTSC.fnt"				;wczytaj fonty
pmg		
ant	dta $F0
	dta $44,a(scr),$84,$04,$84,$84,$04,$04,$04,$04,$04,$84,$84,$04,$84,$04,$04
	dta $84,$84,$04,$84,$04,$04,$04,$84,$04,$04,$04,$84,$70
	dta $41,a(ant)
	:$300-35 dta b(0)	;wyrówannie do strony
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 40 40 40 40 40 40 50
	.he 50 50 50 50 00 00 00 00 00 00 00 80 00 80 00 80
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 08 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player0
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 40 00 00 04 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 03 07 05 06 07 0E
	.he 13 60 F3 A3 D3 EC D3 63 07 04 02 04 07 63 F3 AC
	.he F3 E3 D3 60 13 0F 05 06 07 06 03 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 54 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 0E 19 74 68 B0 68 B0 60 A0 50
	.he A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 10 08 0C 04 06 03 02 01 01 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player1
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 04 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 80 00 80 00 C0
	.he 20 18 3C 28 34 F8 34 18 80 80 00 80 80 18 3C E8
	.he 34 38 34 18 20 C0 00 80 00 80 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 10 00 00 00 00 00 00 00 00 04 08 04 18 14 28
	.he 16 08 50 50 20 20 40 40 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 01 00 00 00 00 00 80 00 40 80 A2 53
	.he 48 29 04 14 02 09 05 00 02 00 01 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player2
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 20 00 20 00 20 40 20 00 00 00 60 60 60 20 20
	.he 20 00 00 00 00 00 00 00 00 00 00 20 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 30 20
	.he 00 40 40 40 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 80 C0 40 20 30 18 00 08 0A 04
	.he 01 82 40 80 20 50 A0 C8 50 6C 26 A7 1B 53 0B 23
	.he 85 53 41 28 34 10 0A 09 04 06 02 01 01 00 00 00
	.he 01 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player3
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 10 00 10 00 10 00 00 00 00 41 41 01 41
	.he 00 00 00 00 00 00 00 00 00 00 00 40 00 40 00 C1
	.he 00 00 00 00 40 40 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 20 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 80 80 80 00 00 00 00 00 00 00 00 00 80 80 80
	.he 80 C0 C0 E0 E0 20 08 0C 88 88 08 08 08 88 C8 44
	.he 40 50 B0 70 30 58 18 20 18 00 0C 04 02 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	
scr	ins "logoNTSC.scr"	


play_logo
	mva >pmg pmbase		;missiles and players data address
	mva #$03 pmcntl		;enable players and missiles
	sei			;stop IRQ interrupts
	mva #$00 nmien		;stop NMI interrupts
	sta dmactl
	mva #1 zegar
	mwa #NMI vbiv		;new NMI handler

	mva #$c0 nmien		;switch on NMI+DLI again
	
@	lda zegar
	;beq @+


	lda trig0		; FIRE #1
	bne @-
	
	sta dmactl
	sta nmien
	sta pmg
	
@	lda trig0
	beq @-
	
	rts

	
.proc	NMI	
VBL
	sta regA
	stx regX
	sty regY

	sta nmist		;reset NMI flag

	mwa #ant dlptr		;ANTIC address program

	mva #scr40 dmactl	;set new screen width

	inc zegar		;little timer

; Initial values

	lda >fnt+$400*$00
	sta chbase
c0	lda #$00
	sta colbak
	lda #$02
	sta chrctl
	lda #$04
	sta gtictl
c1	lda #$0E
	sta color0
c2	lda #$62
	sta color1
c3	lda #$90
	sta color2
c4	lda #$EC
	sta color3
s0	lda #$00
	sta sizep0
	sta sizep1
	sta sizep2
	sta sizep3
	sta sizem
x0	lda #$A8
	sta hposp0
x1	lda #$B0
	sta hposp1
x2	lda #$B8
	sta hposp2
x3	lda #$C0
	sta hposp3
x4	lda #$C8
	sta hposm0
x5	lda #$CA
	sta hposm1
x6	lda #$CC
	sta hposm2
x7	lda #$CE
	sta hposm3
c5	lda #$08
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3

	mwa #DLI0.dli_start dliv	;set the first address of DLI interrupt

	lda regA
	ldx regX
	ldy regY
	rti	
.endp

.local	DLI0	
dli_start

dli9
	sta regA

	sta wsync		;line=8
	sta wsync		;line=9
	sta wsync		;line=10
	sta wsync		;line=11
	sta wsync		;line=12
	sta wsync		;line=13
	sta wsync		;line=14
c6	lda #$62
	sta wsync		;line=15
	sta color3
	sta wsync		;line=16
	sta wsync		;line=17
	sta wsync		;line=18
c7	lda #$42
	sta wsync		;line=19
	sta color1
	DLINEW dli10 1 0 0

dli10
	sta regA
	stx regX
	sty regY

c8	lda #$90
	sta wsync		;line=24
	sta color3
	sta wsync		;line=25
	sta wsync		;line=26
c9	lda #$0C
	sta wsync		;line=27
	sta color0
	sta wsync		;line=28
	sta wsync		;line=29
	sta wsync		;line=30
c10	lda #$D6
	sta wsync		;line=31
	sta colpm0
	sta wsync		;line=32
s1	lda #$01
x8	ldx #$79
x9	ldy #$81
	sta wsync		;line=33
	sta sizep3
	stx hposp0
	sty hposp1
x10	lda #$92
	sta hposp3
c11	lda #$D6
	sta colpm1
c12	lda #$90
	sta colpm3
	sta wsync		;line=34
	sta wsync		;line=35
c13	lda #$44
	sta wsync		;line=36
	sta color3
	DLINEW dli11 1 1 1

dli11
	sta regA
	stx regX
	sty regY

	sta wsync		;line=40
c14	lda #$44
x11	ldx #$6A
c15	ldy #$90
	sta wsync		;line=41
	sta color1
	stx hposp2
	sty colpm2
s2	lda #$00
x12	ldx #$52
	sta wsync		;line=42
	sta sizep3
	stx hposp3
	sta wsync		;line=43
	sta wsync		;line=44
c16	lda #$90
	sta wsync		;line=45
	sta color3
c17	lda #$0A
	sta wsync		;line=46
	sta color0
	DLINEW DLI0.dli2 1 1 1

dli2
	sta regA
	stx regX
	sty regY
	lda >fnt+$400*$01
c18	ldx #$34
x13	ldy #$5F
	sta wsync		;line=48
	sta chbase
	stx color1
	sty hposm3
	sta wsync		;line=49
x14	lda #$9F
	sta wsync		;line=50
	sta hposp3
c19	lda #$34
	sta wsync		;line=51
	sta color3
	sta wsync		;line=52
	sta wsync		;line=53
c20	lda #$36
	sta wsync		;line=54
	sta color1
x15	lda #$54
	sta wsync		;line=55
	sta hposm2
	sta wsync		;line=56
c21	lda #$90
s3	ldx #$01
x16	ldy #$92
	sta wsync		;line=57
	sta color3
	stx sizep3
	sty hposp3
	sta wsync		;line=58
x17	lda #$B8
	sta wsync		;line=59
	sta hposp2
c22	lda #$36
	sta wsync		;line=60
	sta color3
c23	lda #$28
x18	ldx #$CE
	sta wsync		;line=61
	sta color1
	stx hposm3
x19	lda #$A8
	sta wsync		;line=62
	sta hposp2
	sta wsync		;line=63
	sta wsync		;line=64
c24	lda #$08
c25	ldx #$90
x20	ldy #$92
	sta wsync		;line=65
	sta color0
	stx color3
	sty hposm3
x21	lda #$CC
	sta wsync		;line=66
	sta hposm2
c26	lda #$28
s4	ldx #$00
x22	ldy #$9F
	sta wsync		;line=67
	sta color3
	stx sizep3
	sty hposp3
c27	lda #$2A
x23	ldx #$A8
	sta wsync		;line=68
	sta color1
	stx hposp0
x24	lda #$B0
	sta wsync		;line=69
	sta hposp1
c28	lda #$08
	sta wsync		;line=70
	sta colpm1
x25	lda #$5C
c29	ldx #$08
	sta wsync		;line=71
	sta hposp3
	stx colpm0
	lda >fnt+$400*$00
c30	ldx #$90
	sta wsync		;line=72
	sta chbase
	stx color3
	sta wsync		;line=73
c31	lda #$2A
	sta wsync		;line=74
	sta color3
c32	lda #$1C
x26	ldx #$56
x27	ldy #$CE
	sta wsync		;line=75
	sta color1
	stx hposp3
	sty hposm3
x28	lda #$B8
c33	ldx #$08
	sta wsync		;line=76
	sta hposp2
	stx colpm2
	sta wsync		;line=77
c34	lda #$90
	sta wsync		;line=78
	sta color3
x29	lda #$C0
c35	ldx #$08
	sta wsync		;line=79
	sta hposp3
	stx colpm3
	lda >fnt+$400*$01
	sta wsync		;line=80
	sta chbase
	sta wsync		;line=81
c36	lda #$04
c37	ldx #$2E
c38	ldy #$1C
	sta wsync		;line=82
	sta color0
	stx color1
	sty color3
x30	lda #$B3
	sta hposp0
c39	lda #$08
x31	ldx #$A8
	sta wsync		;line=83
	sta color0
	stx hposp0
	sta wsync		;line=84
	sta wsync		;line=85
	sta wsync		;line=86
c40	lda #$EC
	sta wsync		;line=87
	sta color3
	lda >fnt+$400*$02
	sta wsync		;line=88
	sta chbase
c41	lda #$FC
c42	ldx #$2E
	sta wsync		;line=89
	sta color1
	stx color3
	sta wsync		;line=90
	sta wsync		;line=91
	sta wsync		;line=92
	sta wsync		;line=93
c43	lda #$EC
	sta wsync		;line=94
	sta color3
	DLINEW dli3 1 1 1

dli3
	sta regA
	stx regX
	sty regY
	lda >fnt+$400*$01
c44	ldx #$FE
	sta wsync		;line=96
	sta chbase
	stx color1
	sta wsync		;line=97
	sta wsync		;line=98
	sta wsync		;line=99
c45	lda #$D8
c46	ldx #$0C
c47	ldy #$E4
	sta wsync		;line=100
	sta color0
	stx color1
	sty color2
c48	lda #$82
	sta color3
x32	lda #$98
	sta hposp0
x33	lda #$A0
	sta hposp1
x34	lda #$A8
	sta hposp2
x35	lda #$B0
	sta hposp3
x36	lda #$B8
	sta hposm0
x37	lda #$BA
	sta hposm1
x38	lda #$BC
	sta hposm2
x39	lda #$BE
	sta hposm3
	DLINEW dli4 1 1 1

dli4
	sta regA
	stx regX
	sty regY
	lda >fnt+$400*$02
x40	ldx #$77
c49	ldy #$90
	sta wsync		;line=104
	sta chbase
	stx hposm3
	sty colpm3
	sta wsync		;line=105
	sta wsync		;line=106
	sta wsync		;line=107
	sta wsync		;line=108
x41	lda #$BE
c50	ldx #$08
	sta wsync		;line=109
	sta hposm3
	stx colpm3
	DLINEW dli12 1 1 1

dli12
	sta regA
	stx regX
	sty regY

	sta wsync		;line=120
	sta wsync		;line=121
	sta wsync		;line=122
x42	lda #$5B
c51	ldx #$90
	sta wsync		;line=123
	sta hposm3
	stx colpm3
	sta wsync		;line=124
	sta wsync		;line=125
x43	lda #$69
x44	ldx #$BE
c52	ldy #$34
	sta wsync		;line=126
	sta hposp0
	stx hposm3
	sty colpm0
c53	lda #$08
	sta colpm3
	sta wsync		;line=127
	sta wsync		;line=128
x45	lda #$67
	sta wsync		;line=129
	sta hposm0
x46	lda #$65
c54	ldx #$28
	sta wsync		;line=130
	sta hposp1
	stx colpm1
	sta wsync		;line=131
	sta wsync		;line=132
	sta wsync		;line=133
x47	lda #$65
c55	ldx #$34
	sta wsync		;line=134
	sta hposp2
	stx colpm2
	sta wsync		;line=135
	sta wsync		;line=136
	sta wsync		;line=137
x48	lda #$98
	sta wsync		;line=138
	sta hposp0
	DLINEW dli13 1 1 1

dli13
	sta regA
	stx regX
	sty regY

x49	lda #$B8
c56	ldx #$08
	sta wsync		;line=144
	sta hposm0
	stx colpm0
	sta wsync		;line=145
	sta wsync		;line=146
x50	lda #$A0
x51	ldx #$A8
c57	ldy #$08
	sta wsync		;line=147
	sta hposp1
	stx hposp2
	sty colpm1
	sty colpm2
	DLINEW dli14 1 1 1

dli14
	sta regA
	stx regX

x52	lda #$80
c58	ldx #$90
	sta wsync		;line=152
	sta hposm3
	stx colpm3
	sta wsync		;line=153
	sta wsync		;line=154
x53	lda #$BE
c59	ldx #$08
	sta wsync		;line=155
	sta hposm3
	stx colpm3
	DLINEW dli5 1 1 0

dli5
	sta regA
	lda >fnt+$400*$03
	sta wsync		;line=168
	sta chbase
	sta wsync		;line=169
	sta wsync		;line=170
c60	lda #$04
	sta wsync		;line=171
	sta color3
	DLINEW dli15 1 0 0

dli15
	sta regA
	stx regX

	sta wsync		;line=200
	sta wsync		;line=201
	sta wsync		;line=202
	sta wsync		;line=203
	sta wsync		;line=204
	sta wsync		;line=205
	sta wsync		;line=206
c61	lda #$86
c62	ldx #$80
	sta wsync		;line=207
	sta color0
	stx color2
	DLINEW dli6 1 1 0

dli6
	sta regA
	lda >fnt+$400*$00
	sta wsync		;line=232
	sta chbase

	lda regA
	rti	
.endl

.MACRO	DLINEW
	mva <:1 dliv
	ift [>?old_dli]<>[>:1]
	mva >:1 dliv+1
	eif

	ift :2
	lda regA
	eif

	ift :3
	ldx regX
	eif

	ift :4
	ldy regY
	eif

	rti

	.def ?old_dli = *
.ENDM
		
e3		equ *
		:$c000-e3-3 dta b(00)
		dta b($ff),a(start_program)

