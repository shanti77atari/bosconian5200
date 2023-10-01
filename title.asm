shp5200	.he ee,82,ee,28,ee,ee,aa,aa,aa,ee
kol0	equ sam
poz0	equ sam+1

waitvbl1
		lda zegar
		cmp zegar
		beq *-2
		rts
		
czarnyPanel1	equ	*
			lda #255  
			ldx #0
@			sta sprites+$700,x  ;wypelniamy 4 duszka
			dex
			bne @-
			
			ldx #240
@			sta sprites1+$700,x
			dex
			bne @-
			
			
			
			sta sprites1+$700+12
			sta sprites1+$700+242
			lda #126
			sta sprites1+$700+10
			sta sprites1+$700+244
			lda #60
			sta sprites1+$700+8
			sta sprites1+$700+246
			
			lda #0
			sta sprites1+$700+13
			sta sprites1+$700+11
			sta sprites1+$700+9
			sta sprites1+$700+241
			sta sprites1+$700+243
			sta sprites1+$700+245
			sta sprites1+$700+247
			
			rts		

;strona tytułowa
Title		equ *
		ldx #<MODUL					;low byte of RMT module to X reg
		ldy #>MODUL					;hi byte of RMT module to Y reg
		lda #$06						;starting song line 0-255 to A reg 	
		jsr init_rmt

		mva #6 kolpom0			;ntsc

		mva #1 stan_gry		;nie wlaczamy muzyki w przerwaniu

		mva #0 poz0
		jsr prepare_title
		jsr waitvbl1
Title2	equ *
		jsr title_init

		mva #0 atariX1

		lda #>znaki1
		sta CHBASE

		
		

		mwa #dlist	DLPTR
		mva #0 zegar
		mva #%01000000 NMIEN		;wylacz przerwania DLI i IRQ
		mva #58 DMACTL
		
		mva #1 strz1
		
		jsr ppanel

@		jsr printNapis
		jsr ppanel		;bez irq
		
		lda FIRE
		bne *+5
		jmp waitvbl1
		
		;jsr waitvbl1
		
		lda pozNapis
		cmp #29
		bcc @-
		mva #0 strz1
		
@		jsr ppanel

		lda FIRE
		bne *+5	
		jmp waitvbl1
	
		;jsr waitvbl1
		jsr ppanel

		jsr efektNapis1
		
		lda napisX
		bpl @-	
		
		
		.rept 5,#
		lda shp5200+:1
		sta sprites+$48c+:1*2
		sta sprites+$48d+:1*2
		lda shp5200+5+:1
		sta sprites+$58c+:1*2
		sta sprites+$58d+:1*2
		.endr
			
		mva #160-2 poz0
		

@		jsr ppanel
		ldy #32
		jsr efnap1

		lda #$84
		sta COLPF0
		
		ldy #7
		lda #0
@		sta obraz1+19+29+7*48+33,y
		sta obraz1+19+29+25*48+33,y
		sta obraz1+19+29+20*48+33,y
		sta obraz1+19+29+22*48+33,y
		sta obraz1+19+29+18*48+33,y
		sta obraz1+19+29+19*48+33,y
		sta obraz1+19+29+21*48+33,y
		sta obraz1+19+29+23*48+33,y
		dey
		bpl @-
		
		
		lda #%11110111
		:7 sta sprites+$4a0-1+#
		lda #%01110000
		:7 sta sprites+$5a0-1+#	

		.rept 12, #
		lda codet+:1
		sta obraz1+19+7+28+18*48+:1
		.endr
		
		.rept 16, #
		lda codet1+:1
		sta obraz1+19+7+28+19*48+:1
		mva #$32 dlist+21
		sta dlist+22
		.endr
		jsr ppanel
		
		lda #%01111101			;music and sfx
		:7 sta sprites+$4b0-1+#
		lda #%11011100
		:7 sta sprites+$5b0-1+#
		lda #%11111000				;pictures
		:7 sta sprites+$4c0-1+#
		lda #%11111100
		:7 sta sprites+$5c0-1+#
		
		.rept 14, #
		lda sfxt+:1
		sta obraz1+19+8+28+20*48+:1
		lda theStarDestroyer+:1
		sta obraz1+19+12+28+7*48+:1
		.endr
		
		.rept 17, #
		lda sfxt1+:1
		sta obraz1+19+8+28+21*48+:1
		lda pict1+:1
		sta obraz1+19+8+28+23*48+1+:1
		.endr

		.rept 12, #
		lda pict+:1
		sta obraz1+19+8+28+22*48+1+:1
		.endr
		
		mva #$32 dlist+23
		sta dlist+24
		sta dlist+25
		sta dlist+26
		sta dlist+10
		
		mva #kolorLogo duszek4kolor
		mva #43 duszek4pos
		
		lda #5
		:8 sta sprites+$700+startWyniki+54+#
		
		lda #0
		sta sprites+$4df
		sta sprites+$5df
		
		jsr ppanel
		
		lda #%11001100 				;last line
		:7 sta sprites+$4d8-1+#
		lda #%00110000
		:7 sta sprites+$5d8-1+#
		
		lda #$80
		:40 sta obraz1+19+29+25*48+#
		
		.rept 18, #
		lda atariversion+:1
		sta obraz1+19+11+28+25*48+:1
		.endr
		
		

		
		mva #$32 dlist+28
		
		jsr ppanel

		mva #67 atariX1
		
		lda #2
		sta obraz1+19+25+28
		sta obraz1+19+25+9+3*48		;gwiazdy
		sta obraz1+19+25+14+6*48
		sta obraz1+19+25+30+10*48
		sta obraz1+19+25+13+14*48
		sta obraz1+19+25+24+17*48
		sta obraz1+19+25+19+26*48
		sta obraz1+19+25+29+27*48
		sta obraz1+19+25+8+24*48
		
		lda #129
		sta obraz1+19+25+2*48+22
		sta obraz1+19+25+4*48+31
		sta obraz1+19+25+22+9*48

		sta obraz1+19+25+27+24*48
		sta obraz1+19+25+12+27*48
		
		mva #3 posx
		mva #0 posY
		mva #36 enemyX+4
		mva #14 enemyY+4
		mva #0 enemyDX+4
		mva #0 enemyDY+4
		mva #12 enemyFaza+4
		mva #EKOLOR1 enemyNegatyw+4
		mva >enemy2shapetab enemyShapeH+4
		mva #0 ramka
		sta ramka4
		mva #37 pom0f
		sta pom0g
		mva #0 pom0e	;kierunek 
		

	
@		jsr ppanel

bbs		lda fire
		sta strz2
		jeq @+1

	
		lda pom0e
		bne bb0

		ldx pom0f
		cpx #37
		beq bb1
		:3 mva bufore3+# obraz1-3+#+14*48,x	;odtwórz ekran po duszku
		:3 mva bufore3+3+# obraz1-3+#+15*48,x
		jmp bb1
		
		
bb0		ldx pom0f
		:3 mva bufore3+# obraz1-3+#+5*48,x	;odtwórz ekran po duszku
		:3 mva bufore3+3+# obraz1-3+#+6*48,x
		jmp bb2	
		
bb1		equ *		
		sec
		lda enemyDX+4		;ruch w lewo
		sbc #%01000000
		sta enemyDX+4
		lda enemyX+4
		sbc #0
		and #127
		sta enemyX+4
		
		bne bb1_	;sprawdz czy juz poza ekranem
		inc pom0e	;zmien kierunek
		mva #0 enemyX+4
		sta enemyDX+4
		mva #4 enemyFaza+4
		mva #5 enemyY+4
		mva >enemy4shapetab enemyShapeH+4
		jmp bb2
		
bb1_	tax
		stx pom0f
		:3 mva obraz1-3+#+14*48,x bufore3+#	;zapamietaj obszar pod nową pozycją duszka
		:3 mva obraz1-3+#+15*48,x bufore3+3+#
		
		ldx #4
		jsr duszkiPrint
		jmp bb3
		
bb2		equ *		
		clc
		lda enemyDX+4		;ruch w prawo
		adc #%01000000
		sta enemyDX+4
		lda enemyX+4
		adc #0
		and #127
		sta enemyX+4
		
		cmp #38
		bne bb2_ 
		mva #254 zegar
		jmp @+1
		
bb2_	tax
		stx pom0f
		:3 mva obraz1-3+#+5*48,x bufore3+#	;zapamietaj obszar pod nową pozycją duszka
		:3 mva obraz1-3+#+6*48,x bufore3+3+#
		
		ldx #4
		jsr duszkiPrint
		
bb3		equ *
		
		lda atariX1
		clc
		adc #2
		cmp #144
		bcc @+
		lda #67
@		sta atariX1
		
		inc kol0
		jmp @-1	
		
@		
		jsr ppanel
		
		
		lda #$34				;zmiana trybu w 2 liniach
		sta dlist+10
		
		sta dlist+21
		sta dlist+22
		sta dlist+23
		sta dlist+24
		sta dlist+25
		sta dlist+26
		sta dlist+28
		
		lda #0
		:7 sta sprites1+$4d8-1+#
		:7 sta sprites1+$5d8-1+#
		:7 sta sprites+$4b0-1+#
		:7 sta sprites+$5b0-1+#
		:7 sta sprites+$4c0-1+#
		:7 sta sprites+$5c0-1+#
		:7 sta sprites+$4a0-1+#
		:7 sta sprites+$5a0-1+#	

		sta poz0
		.rept 10,#
		sta sprites+$48c+:1
		sta sprites+$58c+:1
		.endr 
			

			
		mva #$00 duszek4kolor
		mva #pozWyniki-1 duszek4pos
		
		lda #255							
		:8 sta sprites+$700+startWyniki+54+#		;przywróc duszka
	
		
		mva #$0a COLPF1
		
		lda strz2
		bne @+		;nie wcisnieto fire
		
		rts 
		
@				;wyswietl tabele wynikow
		
		jsr tabhscore1
		
		mva #36 enemyX+4
		mva #23 enemyY+4
		mva #12 enemyFaza+4
		mva #EKOLOR1 enemyNegatyw+4
		mva >enemy5shapetab enemyShapeH+4
		mva #1 ramka
		mva #4 ramka4
		mva #37 pom0f
		mva #0 pom0e	;kierunek 

		
;przygotowanie obrazu1
		jsr ppanel1

		;mwa #obraz1+19 pom
		ldx #0
		lda #$7d
@		sta obraz1+19,x
		inx
		bne @-
		;jsr zakryjObraz
		jsr ppanel1
		
		;jsr zakryjObraz
		ldx #0
		lda #$7d
@		sta obraz1+$100+19,x
		inx
		bne @-
		jsr ppanel1
		
		;jsr zakryjObraz
		ldx #0
		lda #$7d
@		sta obraz1+$200+19,x
		inx
		bne @-
		jsr ppanel1
		
		;jsr zakryjObraz
		ldx #0
		lda #$7d
@		sta obraz1+$300+19,x
		inx
		bne @-		
		jsr ppanel1
		
		;jsr zakryjObraz
		ldx #0
		lda #$7d
@		sta obraz1+$400+19,x
		inx
		bne @-		
		jsr ppanel1
		
		;jsr zakryjObraz
		ldx #0
		lda #$7d
@		sta obraz1+$500+19,x
		inx
		bne @-		
		jsr ppanel1
		
		lda #0
		:64 sta obraz1+19+28*48+#
		
		
;---		
@		jsr ppanel1
		
		lda pom0e
		bne bbb0

		ldx pom0f
		cpx #37
		beq bbb1
		:3 mva bufore3+# obraz2-3+#+23*48,x	;odtwórz ekran po duszku
		:3 mva bufore3+3+# obraz2-3+#+24*48,x
		jmp bbb1
		
		
bbb0	ldx pom0f
		:3 mva bufore3+# obraz2-3+#+7*48,x	;odtwórz ekran po duszku
		:3 mva bufore3+3+# obraz2-3+#+8*48,x
		jmp bbb2	
		
bbb1		equ *		
		sec
		lda enemyDX+4		;ruch w lewo
		sbc #%01000000
		sta enemyDX+4
		lda enemyX+4
		sbc #0
		and #127
		sta enemyX+4
		
		bne bbb1_	;sprawdz czy juz poza ekranem
		inc pom0e	;zmien kierunek
		mva #0 enemyX+4
		sta enemyDX+4
		mva #4 enemyFaza+4
		mva #7 enemyY+4
		mva >enemy2shapetab enemyShapeH+4
		jmp bbb2
		
bbb1_	tax
		stx pom0f
		:3 mva obraz2-3+#+23*48,x bufore3+#	;zapamietaj obszar pod nową pozycją duszka
		:3 mva obraz2-3+#+24*48,x bufore3+3+#
		
		ldx #4
		jsr duszkiPrint
		jmp bbb3
		
bbb2		equ *		
		clc
		lda enemyDX+4		;ruch w prawo
		adc #%01000000
		sta enemyDX+4
		lda enemyX+4
		adc #0
		and #127
		sta enemyX+4
		
		cmp #37
		bne bbb2_ 
		mva #254 zegar
		jmp @+
		
bbb2_	tax
		stx pom0f
		:3 mva obraz2-3+#+7*48,x bufore3+#	;zapamietaj obszar pod nową pozycją duszka
		:3 mva obraz2-3+#+8*48,x bufore3+3+#
		
		ldx #4
		jsr duszkiPrint
		
bbb3		equ *
		
		
bbbs	lda FIRE
		sta strz2
		jne @-

@		equ *
		jsr ppanel1
		jsr tabhs1cls
		
			
		mva #0 HPOSM3
		
		lda strz2
		bne @+
	
		rts

@		
		jmp Title2

/*
zakryjObraz	equ *
		ldy #0
		lda #$7d		
@		sta (pom),y
		dey
		bne @-
		inc pom+1
		rts */
		
;tworzy prawy panel bez przerwan
ppanel	equ *
		jsr ppan_1		
		jsr ppan_2
		
		lda #21
@		cmp VCOUNT
		bne @-
		
		mva #pozWyniki+2 HPOSP0		;score
		mva #pozWyniki+10 HPOSP1
		mva #kolorLiczby COLPM0
		sta COLPM1
		
		jsr ppan_3
		mva #$0f COLPF1
		
		lda #34
@		cmp VCOUNT
		bne @-
		
		:2 sta WSYNC
		
		mva duszek4pos	HPOSP3		
		mva duszek4kolor COLPM3		;poczatek litery B
		
		jsr ppan_4
		
		lda #38
@		cmp VCOUNT
		bne @-
		:2 sta WSYNC
		
		mva #pozWyniki-1 HPOSP3			;koniec litery B
		mva #0	COLPM3
		
		lda #47
@		cmp VCOUNT
		bne @-
		
		sta WSYNC
		mva #kolorMapa	COLPM3
			
		mva #kolorLiczby COLPM0
		lda #16+4
		sta SIZEM
		mva #kolorCzerwony COLPM1
		sta COLPM2
		mva #pozWyniki+19 HPOSM2
		mva #pozWyniki+23 HPOSM1
		
		mva #0 HPOSM0
		mva #1 SIZEP2		;przeciwnicy na radarze
		mva #pozWyniki+3 HPOSP2
		
		
		lda #70
@		cmp vcount
		bne @-
		

		lda poz0
		sta HPOSP0
		clc
		adc #8
		sta hposp1
		lda kol0
		sta colpm0
		sta colpm1
		
		lda #78
@		cmp VCOUNT
		bne @-
		
		mva #3 SIZEP0
		sta SIZEP1
		mva #71 HPOSP0
		mva #$30 COLPM0
		mva #71+32 HPOSP1
		
		sta WSYNC
		sta WSYNC
		
		ldy #7
@		sta WSYNC
		mva #$30 COLPM1
		:6 dec strz0
		mva #kolorCzerwony COLPM1
		dey 
		bne @-
		
		mva #$0e COLPF1
		
		
		lda #86
@		cmp VCOUNT
		bne @-
		mva #$0a COLPF1
		
		mva #3 SIZEP0
		sta SIZEP1
		mva #%00010111 SIZEM
		mva #71+32 HPOSP1
		mva #71+56+16 HPOSM0
		ldx #$50 ;COLPM
		
		:2 sta WSYNC
		stx COLPM0
		
		ldy #7
@		sta WSYNC
		mva #$50 COLPM1
		:6 dec strz0
		mva #kolorCzerwony COLPM1
		dey 
		bne @-
		
		mva #$0e COLPF1
		sta WSYNC
		
		lda #94
@		cmp VCOUNT
		bne @-
		
		mva #$0a COLPF1
		mva #75+4 HPOSP0
		mva #$b0 COLPM0
		:2 sta WSYNC
		
		ldy #7
@		sta WSYNC
		mva #$b0 COLPM1
		:6 dec strz0
		mva #kolorCzerwony COLPM1
		dey 
		bne @-
		
		
		lda #99
@		cmp VCOUNT
		bne @-
		
		
		sta WSYNC
		mva #$0f COLPF1
		mva #0 HPOSP0
		sta HPOSP1
		
		
		lda #102
@		cmp VCOUNT
		bne @-	
		
		mva #$0a COLPF1
		
		mva #0 COLPM3		;koniec mapy zapasowe statki
		
		sta SIZEM
		sta SIZEP2			;zakonczenie mapy
		sta HPOSP2
		sta HPOSM0
		sta HPOSM1
		sta HPOSM2
		
		lda #105
@		cmp VCOUNT
		bne @-
		
		mva #3 SIZEP0
		sta SIZEP1
		mva #$0f COLPM0
		mva #$08 COLPM1

		sta WSYNC
		
		lda #0
		ldx #$0a
		ldy atariX1
		:3 sta WSYNC

		sta COLPF1
		stx COLPF2
		sty HPOSP0
		sty HPOSP1

		
		ldx #$3a
		ldy #0
		:7 sta WSYNC
		
		stx COLPF1
		sty COLPF2
		sty HPOSP0
		sty HPOSP1

		
		jmp ppan_end

theStarDestroyer	dta c'STAR',b(0),c'DESTROYER'
atariversion		dta b(128),c'ULTIMATE'*,b(128),c'VERSION'*,b(128)	;dta b(0,0),c'FINAL',b(0),c'VER',b(91),b(0),b(94),b(91),b(96),b(0,0)
codet				dta c'CODE',b(0),'AND',b(0),'GFX'
codet1				dta c'JANUSZ',b(0),c'CHABOWSKI'
sfxt				dta c'MUSIC',b(0),c'AND',b(0),c'SFX',b(0)
sfxt1				dta c'MICHAL',b(0),c'SZPILOWSKI'
pict				dta c'TITLE',b(0),'SCREEN'
pict1				dta c'KRZYSZTOF',b(0),c'ZIEMBIK'				


prepare_title	equ *
			mva #0 lives
			mva #0 RadarX
			;jsr printLives
	
;1
			ldx #55
@			lda titleChars1,x
			sta znaki1+121*8,x
			dex
			bpl @-
			
			jsr przepiszZnaki
			
			mva #0 kolor1up
			
			ldx #0
			lda #$7d
@			sta obraz1+19,x
			sta obraz1+$100+19,x
			sta obraz1+$200+19,x
			sta obraz1+$300+19,x
			sta obraz1+$400+19,x
			sta obraz1+$500+19,x
			dex
			bne @-
			
			lda #0
			ldx #63
@			sta obraz1+19+28*48,x
			dex
			bpl @-
			
			.rept 16, #
			sta sprites+$476+:1
			sta sprites+$576+:1
			.endr
			
			jsr czarnyPanel1
;2		
			jmp tabhscore2
		
;Inicjalizacja strony tytułowej
title_init	equ *
			lda #$0A		
			sta COLPF0
			lda #$3a		
			sta COLPF1
			lda #$00		
			sta COLPF2
			lda #kolorLogo
			sta COLPF3
			
			lda #255
			ldx #44
@			sta sprites+$700+33,x
			dex
			bpl @-
		
					
			mwa #obraz1+19 dlist+2
			mva #0 VSCROL
			mva #>znaki1 CHBASE
			
			mva #0 lives
			mva #0 RadarX
			;jsr printLives
			
			
			mva #pozWyniki-1 duszek4pos
			mva #0 duszek4kolor
			
			mva #0 pozNapis	;34 pozNapis
			
			mva #14 napisY
			mva #15 napisX
			mva #1 napisDX
			
			mva #12 pom0e
			sta HSCROL
			
			mwa #obraz1+19+668 pom1		;pozycja poczatkowa dla efektu
			
			lda #<(obraz1+19+668) 
			sta pom
			lda #>(obraz1+19+668) 
			sta pom+1
			
			lda #<(obraz1+19+668+48) 
			sta pom1
			lda #>(obraz1+19+668+48) 
			sta pom1+1
			
			rts

pozNapis	equ pom0f
			
printNapis	equ *	
			
			lda pom0e
			sta HSCROL		
			lda pom0e
			sec
			sbc #1
			ora #%1100
			sta pom0e
			cmp #14
			beq @+
			rts
			
@			ldy pozNapis
			cpy #27
			bcs @+
			.rept 11, #
				lda titleNapis+#*27,y
				sta obraz1+19+$120+33+#*48,y
			.endr
			jmp @+1
			
@			lda #$7d			;jesli juz caly tekst na ekranie
			.rept 11, #
				sta obraz1+19+$120+33+#*48,y
			.endr
			
@			lda #$7d
			.rept 6, #
				sta obraz1+19+33+#*48,y
				sta obraz1+19+33+(#+17)*48,y
			.endr
			:5 sta obraz1+19+33+(#+23)*48,y
			
			inc pozNapis
			inc dlist+2
			
			rts
			
napisX		equ pom0a
napisY		equ pom0b
napisDX		equ pom0c	

eftab1		equ *-125
			dta b($79,$fc,$fb,$fa)
eftab2		dta b(28*9+1)
			:13 dta b([28-#-1]*9)
			
eftab3		:14 dta b(<(efnap1+#*9))
			:14 dta b(>(efnap1+#*9))
			
efn_skok	jmp (pom2)
			
efektNapis1	equ *
			ldy napisY
			cpy #14			;dla 15 nie rysuj pionowych linii
			bcs @+
	
			lda eftab3,y
			sta pom2
			lda eftab3+14,y
			sta pom2+1
			ldx eftab2,y
			lda #96 		;rts
			sta efnap1,x
			stx pom0
			
			clc
			lda napisX
			adc napisDX
			tay
			jsr efn_skok	;$ffff
			ldy napisX
			jsr efn_skok	;$ffff
			
			ldx pom0
			lda #190		;ldx  ,y
			sta efnap1,x



@			ldy napisDX
			cpy #29
			bcs @+1

efn1		equ *			
			lda (pom),y
			tax
			lda eftab1,x
			sta (pom),y
			lda (pom1),y
			tax
			lda eftab1,x
			sta (pom1),y
			dey
			bpl efn1
			
			sec
			lda pom	
			sbc #49
			sta pom		
			bcs @+
			dec pom+1	
		
@			clc
			lda pom1	
			adc #47
			sta pom1		
			bcc @+
			inc pom1+1		

			
@			dec napisX
			inc napisDX
			inc napisDX
			lda napisY
			beq @+
			dec napisY

@			rts
			
titleChars1	equ *
			:8 dta b(0)				;79
			:8 dta b(%11111111)		;7a
			:8 dta b(%11110000)		;7b
			:8 dta b(%00001111)		;7c
			:8 dta b(%01010101)		;7d
			:8 dta b(%01010000)		;7e
			:8 dta b(%00000101)		;7f
			
titleNapis	equ *
			dta b($80,$80,$7f,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d)
			dta b($80,$7d,$80,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d)
			dta b($80,$7d,$7e,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d)
			dta b($80,$7d,$80,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d)
			dta b($80,$80,$7f,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d)
			dta b($80,$7d,$80,$7d,$7e,$80,$7d,$7e,$80,$7d,$7e,$80,$7f,$7e,$80,$7d,$7f,$7d,$7f,$7f,$7e,$80,$7d,$7f,$7d,$7f,$7d)
			dta b($80,$7d,$7e,$7f,$80,$7e,$7f,$80,$7d,$7d,$80,$7d,$7f,$80,$7e,$7f,$80,$7d,$7f,$7f,$80,$7e,$7f,$80,$7d,$7f,$7d)
			dta b($80,$7d,$7e,$7f,$7f,$7d,$7f,$80,$80,$7d,$7f,$7d,$7d,$7f,$7d,$7f,$80,$7f,$7f,$7f,$7f,$7d,$7f,$80,$7f,$7f,$7d)
			dta b($80,$7d,$7e,$7f,$7f,$7d,$7f,$7d,$7e,$7f,$7f,$7d,$7d,$7f,$7d,$7f,$7f,$80,$7f,$7f,$80,$80,$7f,$7f,$80,$7f,$7d)
			dta b($80,$80,$80,$7f,$80,$7e,$7f,$7f,$7e,$7f,$80,$7d,$7f,$80,$7e,$7f,$7f,$7e,$7f,$7f,$7f,$7d,$7f,$7f,$7e,$7f,$7d)
			dta b($80,$80,$80,$7d,$7e,$80,$7d,$80,$80,$7d,$7e,$80,$7f,$7e,$80,$7d,$7f,$7d,$7f,$7f,$7f,$7d,$7f,$7f,$7d,$7f,$7d)
			