joy			equ 0


maxBombyEkran	equ 32
ileGwiazd 	equ 18

gwiazdyPixel	dta b(%11,%1100,%110000,%11000000)

znakUp1		dta b(28)
			:29 dta b(#)
			dta b(0)
			
znakDown1	equ znakUp1+2

znakMinus1	dta b(32)
			:33 dta b(#)
			dta b(0)
			
znakPlus1 	equ znakMinus1+2
			
;rysuje obiekty na ekranie (bazy,meteory,bomby)
printEkran	equ *
		mva #0 licznikBazyEkran		;zerujemy licznik widocznych baz
		sta licznikBombyEkran
		ldy posY
		ldx tabBazy1,y	;poczatek
		bmi pre1a	;brak baz na ekranie
		lda tabBazy2,y
		sta _pre0a		;end
pre0	lda bazyRodzaj-1,x	
		bmi pre0a		;negatyw to nie ma bazy
		bne @+
		jmp printBazaA1
@		jmp printBazaB1
pre0a	cpx _pre0a
		beq pre1a		;jesli juz narysowany to koniec
		inx
		cpx bazyIle
		bcc pre0
		beq pre0
		ldx #1			;gdy X>bazyIle
		jmp pre0		;jmp
		
		
pre1a	ldy posY	
		ldx tabBomb1,y
		cpx #255
		bne pre2a		;nie ma zadnej bomby na ekranie
pre2b	jmp pre3
pre2a	lda tabBomb2,y
		sta _pre2
		mva bombIle pre2_b
pre1	lda bombRodzaj-1,x
		bpl @+
pre2	cpx _pre2
		beq pre2b	;narysowano juz wszystkie
		inx
pre2_	cpx pre2_b
		bcc pre1
		beq pre1
		ldx #1
		jmp pre1	
		
@		sec
		lda bombX-1,x
		sbc posX
		tay
		lda tabX,y
		clc
		adc #1
		cmp #34
		bcs pre2
		
		ldy licznikBombyEkran
		sta bombX0,y		;pozycja x+1 na ekranie
		
		adc #7
		sta pom0
		
		sec
		lda bombY-1,x
		sbc posY
		clc
		adc #1
		cmp #lenDlist+1
		
		sta bombY0,y		;pozycja y+1 na ekranie
		sta pom1
			
		txa
		sta bombyEkran,y	;nr+1
		inc licznikBombyEkran
		
		ldy pom1
		
		lda ramka
		bne @+
		
		clc
		lda obraz1La+7,y
		adc pom0
		sta pom
		lda obraz1Ha+7,y
		adc #0
		sta pom+1
		jmp @+1	;skok bezwarunkowy
@		clc
		lda obraz2La+7,y
		adc pom0
		sta pom
		lda obraz2Ha+7,y
		adc #0
		sta pom+1

@		lda bombRodzaj-1,x
		bne @+
		
		
		ldy #0
		lda #firstBombaChar
		sta (pom),y
		
		iny
		lda #firstBombaChar+2
		sta (pom),y
		
		ldy #48
		lda #firstBombaChar+1
		sta (pom),y
		
		iny
		lda #firstBombaChar+3
		sta (pom),y
		jmp pre2
		
@		ldy #0
		lda #firstMeteorChar+128		
		sta (pom),y
		
		iny
		lda #firstMeteorChar+128+2
		sta (pom),y
		
		ldy #48
		lda #firstMeteorChar+128+1
		sta (pom),y
		
		iny
		lda #firstMeteorChar+128+3
		sta (pom),y
		jmp pre2
		
		
pre3	lda startMapy
		bne *+3
		rts

		cmp #145
		beq @+
		
		cmp #60
		beq @+
		
		cmp #12
		bne @+2
		
@		ldx #104		;12znakow
@		lda player1chars-1,x
		sta znaki1-1+115*8,x
		sta znaki2-1+115*8,x
		dex
		bne @-
		
@		dec startMapy
		
		lda startMapy
		cmp #10
		bne @+
		
		jsr graj_sampla
		mva #1 licznikStrzal
		
@		lda startMapy
		cmp #11
		bcs *+3
		rts
		
		lda ramka
		bne @+2
		
		ldx #9
@		lda playerNapis1,x
		ora #128
		sta obraz1+11+13*48,x
		dex
		bpl @-
		
		ldx #4
@		lda playerNapis1+10,x
		ora #128
		sta obraz1+13+15*48,x
		dex
		bpl @-
		
		rts
		
@		ldx #9
@		lda playerNapis1,x
		ora #128
		sta obraz2+11+13*48,x
		dex
		bpl @-
		
		ldx #4
@		lda playerNapis1+10,x
		ora #128
		sta obraz2+13+15*48,x
		dex
		bpl @-
		
		rts
		
playerNapis1	dta b(119,120,121,122,123,124,0,125,126,123,124,123,121,115,122)

				
player1chars	dta b(%01010000)		;115 D
				dta b(%01110100)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%01011100)
				dta b(%11110000)	
				
				dta b(%00010100)		;116 G
				dta b(%01111100)
				dta b(%01000000)
				dta b(%01000000)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%01010100)
				dta b(%11111100)

				dta b(%01000100)		;117 M
				dta b(%01010100)
				dta b(%01110100)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%11001100)
				
				dta b(%01000100)		;118 V
				dta b(%01000100)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%11011100)
				dta b(%00110000)
				
				dta b(%01010100)		;119 P
				dta b(%01110100)
				dta b(%01000100)
				dta b(%01010100)
				dta b(%01111100)
				dta b(%01000000)
				dta b(%01000000)
				dta b(%11000000)
				
				dta b(%01000000)		;120 L
				dta b(%01000000)
				dta b(%01000000)
				dta b(%01000000)
				dta b(%01000000)
				dta b(%01000000)
				dta b(%01010100)
				dta b(%11111100)
				
				dta b(%00010000)		;121 A
				dta b(%01110100)
				dta b(%01000100)
				dta b(%01010100)
				dta b(%01110100)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%11001100)
				
				dta b(%01000100)		;122 Y
				dta b(%01000100)
				dta b(%01000100)
				dta b(%11011100)
				dta b(%00010000)
				dta b(%00010000)
				dta b(%00010000)
				dta b(%00110000)
				
				dta b(%01010100)		;123 E
				dta b(%01111100)
				dta b(%01000000)
				dta b(%01010000)
				dta b(%01110000)
				dta b(%01000000)
				dta b(%01010100)
				dta b(%11111100)
				
				dta b(%01010000)		;124 R
				dta b(%01110100)
				dta b(%01000100)
				dta b(%01010000)
				dta b(%01110100)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%11001100)
				
				dta b(%00010100)		;125 O
				dta b(%01110100)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%01011100)
				dta b(%11110000)
				
				dta b(%01010000)		;126 N
				dta b(%01110100)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%01000100)
				dta b(%11001100)
				
				

printBazaA1	equ *
		sec
		lda bazyX-1,x
		sbc posX
		tay
		lda tabX,y
		sta bazyX0-1,x
		clc
		adc #8
		
		cmp #41
		bcc @+
		jmp pre0a

@		sta pom0
		
		sec
		lda bazyY-1,x
		sbc posY
		sta bazyY0-1,x
		clc
		adc #7	
		
@		sta pom0a
		
		
		lda czyRakiety		;czy na mapie sa rakiety?
		beq @+
		lda startMapy
		ora trafienie
		bne @+
		lda bazyRakieta-1,x
		bpl @+
		DODAJRAKIETAA
@		txa
		ldy licznikBazyEkran
		sta BazyEkran,y
		inc licznikBazyEkran
		
@		ldy pom0a
		lda ramka
		bne @+
		
		clc
		lda obraz1La+1,y
		adc pom0
		sta pom
		sta pom1
		lda obraz1Ha+1,y
		adc #0
		sta pom+1
		adc #1
		sta pom1+1
		jmp @+1	;skok bezwarunkowy
@		clc
		lda obraz2La+1,y
		adc pom0
		sta pom
		sta pom1
		lda obraz2Ha+1,y
		adc #0
		sta pom+1
		adc #1
		sta pom1+1

@		lda bazystan-1,x
		sta pom0b

		cpy #29
		bcc @+
		
		lda #1
		sta tabLineA-29,y
		sty pom0
		jmp _rysBazA
		
		
		
@		cpy #7
		bcs _rysBazA
		
		lda tab_prbaz1,y
		sta pom4
		lda tab_prbaz1+7,y
		sta pom4+1
		jmp (pom4)

tab_prbaz1	dta b(<lin7a,<lin6a,<lin5a,<lin4a,<lin3a,<lin2a,<lin1a)		
			dta b(>lin7a,>lin6a,>lin5a,>lin4a,>lin3a,>lin2a,>lin1a)		

prb1a		
		ldy pom0
		lda #0
		sta tabLineA-29,y
		jmp pre0a
			
_rysBazA	equ *			
@		lda bazyCannon0a-1,x
		beq @+
		ldy #2
		sta (pom),y
@		ldy #3
		lda bazyCannon0b-1,x
		sta (pom),y
		ldy #5
		lda bazyCannon1a-1,x
		sta (pom),y
		
		lda bazyCannon1b-1,x
		beq @+	;lin1a
		ldy #6
		sta (pom),y
		
@		lda tabLineA+6
		bne prb1a
		
lin1a	ldy #50
		lda bazyCannon0c-1,x
		sta (pom),y
		iny
		lda bazyCannon0d-1,x
		sta (pom),y
		ldy #53
		lda bazyCannon1c-1,x
		sta (pom),y
		iny
		lda bazyCannon1d-1,x
		sta (pom),y
		
		lda tabLineA+5
		bne prb1a
		
lin2a	ldy #97
		lda #b+9
		sta (pom),y

		lda pom0b		;jesli zbite dzialko 0
		and #%1
		beq @+
		
		ldy #98
		lda #b+8
		sta (pom),y
@		ldy #99
		lda #b+10
		sta (pom),y
		ldy #101
		lda #b+11
		sta (pom),y

		lda pom0b		;jesli zbite dzialko 1
		and #%10
		beq @+
		
		ldy #102
		lda #b+6
		sta (pom),y
		
@		ldy #103
		lda #b+7
		sta (pom),y
		
		lda tabLineA+4
		beq lin3a
		dec tabLineA+4
		jmp pre0a
		
lin3a	lda bazyCannon5a-1,x
		beq @+
		ldy #144
		sta (pom),y
@		ldy #145
		lda bazyCannon5b-1,x
		sta (pom),y
		iny
		lda #b+4
		sta (pom),y
		iny
		lda #b
		sta (pom),y
		iny
		lda _bazaAJadro0
		sta (pom),y
		iny
		lda #b+2
		sta (pom),y
		iny
		lda #b+4
		sta (pom),y
		iny
		lda bazyCannon2a-1,x
		sta (pom),y
		
		lda bazyCannon2b-1,x
		beq @+	;lin4a
		ldy #152
		sta (pom),y
		
@		lda tabLineA+3
		beq lin4a
		dec tabLineA+3
		jmp pre0a
		
lin4a	lda bazyCannon5c-1,x
		beq @+
		ldy #192
		sta (pom),y
@		ldy #193
		lda bazyCannon5d-1,x
		sta (pom),y
		iny
		lda #b+5
		sta (pom),y
		iny
		lda #b+1
		sta (pom),y
		iny
		lda _bazaAJadro1	;#b+17+128
		sta (pom),y
		iny
		lda #b+3
		sta (pom),y
		iny
		lda #b+5
		sta (pom),y
		iny
		lda bazyCannon2c-1,x
		sta (pom),y
		
		lda bazyCannon2d-1,x
		beq @+		;lin5a
		ldy #200
		sta (pom),y
		
@		lda tabLineA+2
		bne prb2a
		
lin5a	ldy #241
		lda #b+6
		sta (pom),y

		lda pom0b		;jesli zbite dzialko 4
		and #%10000
		beq @+
		
		ldy #242
		lda #b+7
		sta (pom),y
@		ldy #243
		lda #b+11
		sta (pom),y
		ldy #245
		lda #b+10
		sta (pom),y

		lda pom0b	;jesli zbite dzialko 3
		and #%1000
		beq @+
		
		ldy #246
		lda #b+9
		sta (pom),y
@		ldy #247
		lda #b+8
		sta (pom),y
		
		lda tabLineA+1
		bne prb2a
		
lin6a	ldy #34
		lda bazyCannon4a-1,x
		sta (pom1),y
		iny
		lda bazyCannon4b-1,x
		sta (pom1),y
		ldy #37
		lda bazyCannon3a-1,x
		sta (pom1),y
		iny
		lda bazyCannon3b-1,x
		sta (pom1),y
		
		lda tabLineA
		bne prb2a
		
lin7a	lda bazyCannon4c-1,x
		beq @+
		ldy #82
		sta (pom1),y
@		ldy #83
		lda bazyCannon4d-1,x
		sta (pom1),y
		ldy #85
		lda bazyCannon3c-1,x
		sta (pom1),y
		
		lda bazyCannon3d-1,x
		beq @+
		ldy #86
		sta (pom1),y
		
@		jmp pre0a

prb2a		
		ldy pom0
		lda #0
		sta tabLineA-29,y
		jmp pre0a

printBazaB1	equ *
		sec
		lda bazyX-1,x
		sbc posX
		tay
		lda tabX,y
		sta bazyX0-1,x
		clc
		adc #7
		
		cmp #40
		bcc @+
		jmp pre0a
		
@		adc #1
		sta pom0
		
		sec
		lda bazyY-1,x
		sbc posY
		sta bazyY0-1,x
		clc
		adc #8		

@		sta pom0a
		
		lda czyRakiety
		beq @+
		lda startMapy
		ora trafienie
		bne @+
		lda bazyRakieta-1,x
		bpl @+
		DODAJRAKIETAB
@		txa
		ldy licznikBazyEkran
		sta BazyEkran,y
		inc licznikBazyEkran
		
		ldy pom0a
		lda ramka
		bne @+
		
		clc
		lda obraz1La,y
		adc pom0
		sta pom
		sta pom1
		lda obraz1Ha,y
		adc #0
		sta pom+1
		adc #1
		sta pom1+1
		jmp @+1	;skok bezwarunkowy
@		clc
		lda obraz2La,y
		adc pom0
		sta pom
		sta pom1
		lda obraz2Ha,y
		adc #0
		sta pom+1
		adc #1
		sta pom1+1

@		lda bazyStan-1,x
		sta pom0b
		
		cpy #29
		bcc @+
		
		lda #1
		sta tabLineB-29,y
		sty pom0
		jmp _rysBazB		
		
@		cpy #8
		bcs _rysBazB
		
		lda tab_prbaz2,y
		sta pom4
		lda tab_prbaz2+8,y
		sta pom4+1
		jmp (pom4)

tab_prbaz2	dta b(<lin8b,<lin7b,<lin6b,<lin5b,<lin4b,<lin3b,<lin2b,<lin1b)		
			dta b(>lin8b,>lin7b,>lin6b,>lin5b,>lin4b,>lin3b,>lin2b,>lin1b)
			
prb1b		
		ldy pom0
		lda #0
		sta tabLineB-29,y
		jmp pre0a			

_rysBazB	equ *			
@		ldy #3
		lda bazyCannon0a-1,x
		sta (pom),y
		iny
		lda bazyCannon0b-1,x
		sta (pom),y
		
		lda tabLineB+7
		bne prb1b
		
lin1b	ldy #50
		lda #b+25
		sta (pom),y
		iny
		lda bazyCannon0c-1,x
		beq @+
		ldy #51
		sta (pom),y
@		lda bazyCannon0d-1,x
		beq @+
		ldy #52
		sta (pom),y
@		ldy #53
		lda #b+27
		sta (pom),y
		
		lda tabLineB+6
		bne prb1b
		
lin2b	lda bazyCannon5a-1,x
		beq @+
		ldy #96
		sta (pom),y
@		ldy #97
		lda bazyCannon5b-1,x
		sta (pom),y

		lda pom0b		;jesli zbite dzialko 5
		and #%100000
		beq @+
		
		ldy #98
		lda #b+24
		sta (pom),y
@		ldy #99
		lda #b+12
		sta (pom),y
		iny
		lda #b+13
		sta (pom),y

		lda pom0b		;jesli zbite dzialko 1
		and #%10
		beq @+
		
		ldy #101
		lda #b+26
		sta (pom),y
@		ldy #102
		lda bazyCannon1a-1,x
		sta (pom),y
		
		lda bazyCannon1b-1,x
		beq @+	;lin3b
		ldy #103
		sta (pom),y
		
@		lda tabLineB+5
		beq lin3b
		dec tabLineB+5
		jmp pre0a
		
lin3b	ldy #144
		lda bazyCannon5c-1,x
		sta (pom),y
		iny
		lda bazyCannon5d-1,x
		sta (pom),y
		iny
		lda #b+14
		sta (pom),y
		iny
		lda #b
		sta (pom),y
		iny
		lda #b+2
		sta (pom),y
		iny
		lda #b+15
		sta (pom),y
		iny
		lda bazyCannon1c-1,x
		sta (pom),y
		iny
		lda bazyCannon1d-1,x
		sta (pom),y
		
		lda tabLineB+4
		beq lin4b
		dec tabLineB+4
		jmp pre0a
		
lin4b	ldy #195
		lda _bazaBJadro0	;#b+18+128
		sta (pom),y
		iny
		lda _bazaBJadro1	;#b+19+128
		sta (pom),y
		
		lda tabLineB+3
		beq lin5b
		dec tabLineB+3
		jmp pre0a
		
lin5b	ldy #240
		lda bazyCannon4a-1,x
		sta (pom),y
		iny
		lda bazyCannon4b-1,x
		sta (pom),y
		iny
		lda #b+15
		sta (pom),y
		iny
		lda #b+1
		sta (pom),y
		iny
		lda #b+3
		sta (pom),y
		iny
		lda #b+14
		sta (pom),y
		iny
		lda bazyCannon2a-1,x
		sta (pom),y
		iny
		lda bazyCannon2b-1,x
		sta (pom),y
		
		lda tabLineB+2
		bne prb2b
		
lin6b	lda bazyCannon4c-1,x
		beq @+
		ldy #32
		sta (pom1),y
@		ldy #33
		lda bazyCannon4d-1,x
		sta (pom1),y

		lda pom0b		;jesli zbite dzialko 4
		and #%10000
		beq @+
		
		ldy #34
		lda #b+27
		sta (pom1),y
@		ldy #35
		lda #b+12
		sta (pom1),y
		iny
		lda #b+13
		sta (pom1),y

		lda pom0b		;jesli zbite dzialko 2
		and #%100
		beq @+
		
		ldy #37
		lda #b+25
		sta (pom1),y
@		ldy #38
		lda bazyCannon2c-1,x
		sta (pom1),y
		
		lda bazyCannon2d-1,x
		beq @+	;lin7b
		ldy #39
		sta (pom1),y
		
@		lda tabLineB+1
		bne prb2b
		
lin7b	ldy #82
		lda #b+26
		sta (pom1),y
		iny
		lda bazyCannon3a-1,x
		sta (pom1),y
		iny
		lda bazyCannon3b-1,x
		sta (pom1),y
		iny
		lda #b+24
		sta (pom1),y
		
		lda tabLineB
		bne prb2b		
		
lin8b	lda bazyCannon3c-1,x
		beq @+
		ldy #131
		sta (pom1),y
		
@		lda bazyCannon3d-1,x
		beq @+
		ldy #132
		sta (pom1),y
		
@		jmp pre0a

prb2b		
		ldy pom0
		lda #0
		sta tabLineB-29,y
		jmp pre0a
		

gwiazdyRysuj2	equ *
		lda #0
		ldy _gwzmaz1
		sta znaki2,y
		ldy _gwzmaz1+1
		sta znaki2,y
		lda znakDY
		ora #%1000
		sta _gwzmaz1
		eor #%11000
		sta _gwzmaz1+1

		ldx znakDX
		lda gwiazdyPixel,x 	;narysuj gwiazde w nowej pozycji
		ldy znakDY
		sta znaki2+8,y
		and #%01010101
		sta znaki2+16,y

		bne gwiazdyPrint		;skok bezwarunkowy
		
gwiazdyRysuj1 equ *  ;narysuj gwiazdy na pustych polach
		lda #0
		ldy _gwzmaz
		sta znaki1,y
		ldy _gwzmaz+1
		sta znaki1,y
		lda znakDY
		ora #%1000
		sta _gwzmaz
		eor #%11000
		sta _gwzmaz+1

		ldx znakDX
		lda gwiazdyPixel,x 	;narysuj gwiazde w nowej pozycji
		ldy znakDY
		sta znaki1+8,y
		and #%01010101
		sta znaki1+16,y
	
gwiazdyPrint equ *
		ldx gwiazdyLicznik
		cpx #2
		beq gpr1
		
		
		ldy #1
		ldx #5
		lda #255
		jsr gpr0

		 
		
gpr1	ldx gwiazdyLicznik
		cpx #1
		beq gpr2
		
		ldy #1+128
		ldx #11
		lda #5
		jsr gpr0

		
gpr2	ldx gwiazdyLicznik
		bne *+3
		rts
		
		ldy #2+128
		ldx #17
		lda #11
		jmp gpr0
		
		
gpr0
			sty pom0
			sta pom0g
@			lda znakY,x
			clc
			adc znakY1
			cmp #29
			bcc @+
			sbc #29	
			clc
@			tay
			lda znakX,x
			adc znakX1
			cmp #33		;poza ekranem
			bcc @+
			sbc #33
			clc
@			adc (screenL),y
			sta pom
			lda (screenH),y
			adc #0
			sta pom+1
			ldy #0
			lda pom0
			sta (pom),y
			dex
			cpx pom0g
			bne @-2
			rts		
		
movLeft	equ *
		lda movX ;przesun gwiazde co 2 przesuniecie
		and #%1
		beq ml11
		
		ldx znakDX ; czy zmienic pozycje X gwiazdy
		cpx #3
		bne ml12
		
		
		ldy znakX1
		lda znakMinus1,y
		sta znakX1
		
		ldx #255
ml12	inx
		stx znakDX	

ml11	ldx movX
		cpx #15
		beq ml1   ;gdy 4 skocz
		inx
		stx movX
		jmp l02
ml1		lda #12	;zeruj  przesuniecie
		sta movX
		dec posX
		bpl ml2
		mva #127 posX
			
ml2		ldy znakX1
		lda znakPlus1,y
		sta znakX1	
		
		jmp l02

movRight equ *		;statek w prawo tlo w lewo
		lda movX
		and #%1  ;sprawdzamy mit 0
		beq mr11  ;jesli zero nic nie rob
		
		ldx znakDX		;czy zmienic pozycje X gwiazd
		bne mr12
		
		ldy znakX1
		lda znakPlus1,y
		sta znakX1
		
		ldx #4
mr12	dex
		stx znakDX	
		
mr11	ldx movX			;przesow tla
		cpx #12
		beq mr1
		dex
		stx movX
		jmp l02
mr1		lda #15
		sta movX
		
		inc posX
		bpl mr2
		mva #0 posX
		
mr2		ldy znakX1
		lda znakMinus1,y
		sta znakX1
		
		jmp l02
		

movUp	equ *
		ldy znakDY ; czy zmienic pozycje Y gwiazdy
		bne mu12
		
		cpy movY
		bne @+
		mvx #7 znakDY
		dex
		stx movY
		dec posY
		jmp l04
		
@		ldy znakY1
		lda znakUp1,y
		sta znakY1
		
		ldy #8
mu12	dey
		sty znakDY
	
mu11	ldx movY
		beq mu1
		dex
		dex
		stx movY
		jmp l04
mu1		ldy znakY1
		lda znakDown1,y
		sta znakY1	
		
		lda #6
		sta movY
		dec posY
		jmp l04
		

movDown	equ *
		ldx movY
		ldy znakDY ; czy zmienic pozycje Y gwiazdy
		cpy #7
		bne md12
		
		cpx #6
		bne @+
		
		lda #0
		sta movY
		sta znakDY
		inc posY
		jmp l04
		
@		ldy znakY1
		lda znakDown1,y
		sta znakY1
		
		ldy #255
md12	iny
		sty znakDY

md11	ldx movY
		cpx #6
		beq md1
		inx
		inx
		stx movY
		jmp l04
md1		lda #0
		sta movY
		inc posY
		
		ldy znakY1
		lda znakUp1,y
		sta znakY1
		jmp l04
		


joyTableL 	dta b(0),b(<rstatekUp),b(<rstatekDown),b(0),b(<rstatekLeft),b(<rstatekUpLeft)	;1,2,4,5
			dta b(<rstatekDownLeft),b(0),b(<rstatekRight),b(<rstatekUpRight),b(<rstatekDownRight) ;6,8,9,10

joyTableH 	dta b(0),b(>rstatekUp),b(>rstatekDown),b(0),b(>rstatekLeft),b(>rstatekUpLeft)	;1,2,4,5
			dta b(>rstatekDownLeft),b(0),b(>rstatekRight),b(>rstatekUpRight),b(>rstatekDownRight) ;6,8,9,10
										;13,14
			
wybuch0		equ *
			:16*4 dta b(0)			
			
			;3
			:2 dta b(0)
			:3 dta b(%00010000)
			dta b(%00101000)
			:3 dta b(%01000100)
			dta b(%00101000)
			:3 dta b(%00010000)
			:3 dta b(0)
			
			;2
			:3 dta b(0)
			:3 dta b(%00010000)
			dta b(%00111000)
			dta b(%01101100)
			dta b(%00111000)
			:3 dta b(%00010000)
			:4 dta b(0)
			
			;1
			:4 dta b(0)
			:2 dta b(%00010000)
			dta b(%00111000)
			dta b(%01111100)
			dta b(%00111000)
			:2 dta b(%00010000)
			:5 dta b(0)
			
			;0
			:6 dta b(0)
			dta b(%00010000)
			dta b(%00111000)
			dta b(%00010000)
			:7 dta b(0)
			
			
wybuch1		equ *
			:16 dta b(0)				
	
			;6
			dta b(%00010000)
			:2 dta b(0)
			dta b(%00101000)
			dta b(0)
			dta b(%01000100)
			dta b(0)
			dta b(%10000010)
			dta b(0)
			dta b(%01000100)
			dta b(0)
			dta b(%00101000)
			:2 dta b(0)
			dta b(%00010000)
			dta b(0)
			
			;5
			dta b(%00010000)
			dta b(0)
			:3 dta b(%00101000)
			dta b(%01000100)
			dta b(0)
			dta b(%10000010)
			dta b(0)
			dta b(%01000100)
			:3 dta b(%00101000)
			dta b(0)
			dta b(%00010000)
			dta b(0)
			
			;4
			:2 dta b(%00010000)
			:2 dta b(%00111000)
			dta b(%00101000)
			dta b(%01101100)
			dta b(%01000100)
			dta b(%11000110)
			dta b(%01000100)
			dta b(%01101100)
			dta b(%00101000)
			:2 dta b(%00111000)
			:2 dta b(%00010000)
			dta b(0)
			
			;3
			:2 dta b(%00010000)
			dta b(0)
			:2 dta b(%00101000)
			dta b(%01000100)
			dta b(%00101000)
			dta b(%10000010)
			dta b(%00101000)
			dta b(%01000100)
			:2 dta b(%00101000)
			dta b(0)
			:2 dta b(%00010000)
			dta b(0)
			
			;2
			dta b(0)
			:2 dta b(%00010000)
			dta b(0)
			:2 dta b(%00101000)
			dta b(%01000100)
			dta b(%10010010)
			dta b(%01000100)
			:2 dta b(%00101000)
			dta b(0)
			:2 dta b(%00010000)
			:2 dta b(0)
			
			;1
			:3 dta b(0)
			dta b(%00010000)
			:2 dta b(%00101000)
			dta b(%01000100)
			dta b(0)
			dta b(%01000100)
			:2 dta b(%00101000)
			dta b(%00010000)
			:4 dta b(0)
			
			;0
			:4 dta b(0)
			dta b(%00010000)
			dta b(0)
			dta b(%00101000)
			dta b(%01000100)
			dta b(%00101000)
			dta b(0)
			dta b(%00010000)
			:5 dta b(0) 

			
printShip	equ * ;przemieszczaj statek		
		lda startMapy
		beq *+3
		rts
		
		lda trafienie
		jne @+
		jsr prsp1
		lda nobanner
		cmp #2
		beq *+3
		rts
;przepisz statek do sprites1 podczas wyswietlania panelu
			.rept 16,#
			lda sprites+$400+118+:1
			sta sprites1+$400+118+:1
			lda sprites+$500+118+:1
			sta sprites1+$500+118+:1
			.endr
		rts
			
@		lda nobanner

		cmp #2
		bcc @+
		
		lda #0		;wylacz przerwanie i sampla
		sta IRQEN
		sta sirq
		sta AUDF4 

@		lda fazaWybuch
		bmi @+3
		cmp #62
		bne @+1

		jsr exploAllEnemy
		mva #0 licznikStrzal
		lda conditionColor		;jeśli 0 to jest red condition , trzeba narysować
		bne prs_1
		lda conditionC+2
		sta conditionColor
		sta conditionColor1
prs_1	mva #15 opoz_potrafieniu
		lda sfxlicznik1
		cmp #40
		bcs @+			;jeśli wybuch to nie wyciszaj
		
		lda #128
		jsr cisza
		
@		mva #0 formacja_stan
		sta formacja_radar
		jsr piszCondition
		ldy kondycja_stan		;poprzednia kondycja
		jsr setCondition
		

		lda fazaWybuch		
@		asl
		and #%11110000		;rysuje nastepna faze wybuchu statku	
		tay
		ldx #0
		stx licznikStrzal		;nie wlaczaj dzwięku silnika
@		lda wybuch0,y
		sta sprites+$400+118,x
		lda wybuch1,y
		sta sprites+$500+118,x
		iny
		inx
		cpx #16
		bne @-
		;sec	c=1
		lda fazaWybuch
		sbc #3
		sta fazaWybuch
		rts
		
@		equ *		;koniec gry
		dec opoz_potrafieniu
		beq @+
		rts
		
		
@		dec lives
		bpl @+
		lda #0
		.rept 16,#					;wymaz statek z ekranu podczas napisu game over
			sta sprites1+$400+118+:1
			sta sprites1+$500+118+:1
		.endr
		
		jmp game_over
		
@		jsr printlives
		lda zbiteBazy		;czy zbito juz wszystkie bazy
		cmp bazyIle
		bne @+
		inc poziom			;to nastepny poziom
		
		lda poziom		;jeśli poziom = 161 to ustaw 129 , zapetlamy
		cmp #161
		bcc skpoz1
		lda #129
		sta poziom
skpoz1	equ *
		
		jsr wczytajLevel		;ztaranowana ostatnia baza
		mva #2 muzyka
		mva #60 startMapy
		mva #54 licznikStrzal	;opoznienie dzwieku silnika
		jsr pokazBazyRadar
		jsr waitvbl
		mva movy vscrol
		mva movx hscrol		
		
		mva #0 zegar
		rts
		
@		lda sfxlicznik1
		cmp #20
		bcs @+			;jeśli wybuch to nie wyciszaj
		
		lda #128
		jsr cisza
		

@		equ *
		mva #0 formacja_stan
		lda startX		
		sta posX
		lda startY
		sta posY
		
		ldy bazyIle			;wyczysc rakiety w bazach
		lda #255
@		sta bazyRakieta-1,y
		dey
		bne @-
		
		jmp initPoziom
	
		
tabjoy	dta b(0,1,2,0,4,5,6,0,8,9,10,0,0,0,0,0)
		
prsp1	ldx pot0
		cpx #114+50
		rol 
		cpx #114-50
		rol 
		ldx pot1
		stx potg0
		cpx #114+50
		rol 
		cpx #114-50
		rol 
		eor #1+4
		and #$0f
		tax
		lda tabjoy,x
		beq mryganieStatek
@		tay
		cmp sJoy
		beq mryganieStatek
@		sta sJoy
		lda licznikStrzal
		bne printShip1
		inc licznikStrzal	;zmaina kierunku= dzwiek silnikow od poczatku
printShip1	equ *
		lda joyTableH,y
		beq rrts
		sta pom+1
		lda joyTableL,y
		sta pom
		jmp (pom)
		
mryganieStatek	equ *
		ldy sJoy
		bne @+
rrts	rts
@		lda statekTab+11,y
		beq rrts
		sta pom+1
		lda statekTab,y
		sta pom
		jmp (pom)
	
statekTab	dta b(0),b(<mstatekUp),b(<mstatekDown),b(0),b(<mstatekLeft),b(<mstatekUpLeft)	;1,2,4,5
			dta b(<mstatekDownLeft),b(0),b(<mstatekRight),b(<mstatekUpRight),b(<mstatekDownRight) ;6,8,9,10
			dta b(0),b(>mstatekUp),b(>mstatekDown),b(0),b(>mstatekLeft),b(>mstatekUpLeft)	;1,2,4,5
			dta b(>mstatekDownLeft),b(0),b(>mstatekRight),b(>mstatekUpRight),b(>mstatekDownRight) ;6,8,9,10
			
mstatekUp	equ *
		lda sprites+$500+118+15
		eor #%10000010
		sta sprites+$500+118+15
		lda sprites+$500+118+14
		eor #%10000010
		sta sprites+$500+118+14
		rts
		
mstatekDown	equ *
		lda sprites+$500+118+1
		eor #%10000010
		sta sprites+$500+118+1
		lda sprites+$500+118+0
		eor #%10000010
		sta sprites+$500+118+0
		rts
		
mstatekLeft	equ *
		lda sprites+$500+118+1
		eor #%00000010
		sta sprites+$500+118+1
		lda sprites+$500+118+2
		eor #%00000010
		sta sprites+$500+118+2
		lda sprites+$500+118+13
		eor #%00000010
		sta sprites+$500+118+13
		lda sprites+$500+118+14
		eor #%00000010
		sta sprites+$500+118+14
		rts		

mstatekRight	equ *
		lda sprites+$500+118+1
		eor #%01000000
		sta sprites+$500+118+1
		lda sprites+$500+118+2
		eor #%01000000
		sta sprites+$500+118+2
		lda sprites+$500+118+13
		eor #%01000000
		sta sprites+$500+118+13
		lda sprites+$500+118+14
		eor #%01000000
		sta sprites+$500+118+14
		rts	
		
mstatekUpLeft	equ *
		lda sprites+$500+118+5
		eor #%00000001
		sta sprites+$500+118+5
		lda sprites+$500+118+6
		eor #%00000001
		sta sprites+$500+118+6
		lda sprites+$500+118+14
		eor #%00100000
		sta sprites+$500+118+14
		lda sprites+$500+118+15
		eor #%00100000
		sta sprites+$500+118+15
		rts

mstatekUpRight	equ *
		lda sprites+$500+118+5
		eor #%10000000
		sta sprites+$500+118+5
		lda sprites+$500+118+6
		eor #%10000000
		sta sprites+$500+118+6
		lda sprites+$500+118+14
		eor #%00000100
		sta sprites+$500+118+14
		lda sprites+$500+118+15
		eor #%00000100
		sta sprites+$500+118+15
		rts

mstatekDownRight	equ *
		lda sprites+$500+118+0
		eor #%00000100
		sta sprites+$500+118+0
		lda sprites+$500+118+1
		eor #%00000100
		sta sprites+$500+118+1
		lda sprites+$500+118+9
		eor #%10000000
		sta sprites+$500+118+9
		lda sprites+$500+118+10
		eor #%10000000
		sta sprites+$500+118+10
		rts		

mstatekDownLeft	equ *
		lda sprites+$500+118+0
		eor #%00100000
		sta sprites+$500+118+0
		lda sprites+$500+118+1
		eor #%00100000
		sta sprites+$500+118+1
		lda sprites+$500+118+9
		eor #%00000001
		sta sprites+$500+118+9
		lda sprites+$500+118+10
		eor #%00000001
		sta sprites+$500+118+10
		rts

rstatekUp	equ *	;0001,1
		.rept 16, #
		lda statek+:1
		sta sprites+$400+118+:1
		lda statek+16+:1
		sta sprites+$500+118+:1
		.endr
		rts
		
rstatekDown	equ *	;0010,2
		.rept 16, #
		lda statek+32+:1
		sta sprites+$400+118+:1
		lda statek+16+32+:1
		sta sprites+$500+118+:1
		.endr
		rts		
		
rstatekLeft	equ *	;0100,4
		.rept 16, #
		lda statek+64+:1
		sta sprites+$400+118+:1
		lda statek+16+64+:1
		sta sprites+$500+118+:1
		.endr
		rts
		
rstatekRight	equ *	;1000,8
		.rept 16, #
		lda statek+96+:1
		sta sprites+$400+118+:1
		lda statek+16+96+:1
		sta sprites+$500+118+:1
		.endr
		rts
		
rstatekUpLeft	equ *	;0101,5
		.rept 16, #
		lda statek+128+:1
		sta sprites+$400+118+:1
		lda statek+16+128+:1
		sta sprites+$500+118+:1
		.endr
		rts
		
rstatekUpRight	equ *	;1001,9
		.rept 16, #
		lda statek+160+:1
		sta sprites+$400+118+:1
		lda statek+16+160+:1
		sta sprites+$500+118+:1
		.endr
		rts
		
rstatekDownRight	equ *	;1010,10
		.rept 16, #
		lda statek+192+:1
		sta sprites+$400+118+:1
		lda statek+16+192+:1
		sta sprites+$500+118+:1
		.endr
		rts
		
rstatekDownLeft	equ *	;0110,6
		.rept 16, #
		lda statek+224+:1
		sta sprites+$400+118+:1
		lda statek+16+224+:1
		sta sprites+$500+118+:1
		.endr
		rts
	
moveShip	equ *	;przesun ekran	
		lda startMapy		;czy opoznienie po wlaczeniu nowej mapy
		cmp #10
		bcc @+
		sta potg0
		rts
		
@		lda sJOY
		and #%0100
		beq l01
		jmp movLeft

l01		lda sJOY
		and #%1000
		beq l02
		jmp movRight
	
l02		lda sJOY
		and #%0001
		beq l03
		jmp movUp

l03		lda sJOY
		and #%0010
		beq l04
		jmp movDOWN
		
l04		sec
		lda #15
		sbc movX
		sta movX0		;15-movX
		
		lda movY
		lsr @
		sta movY0		;movy/2

		rts

ksztaltJadroAL	dta b(<ksztaltJadroA0),b(<ksztaltJadroA1),b(<ksztaltJadroA2),b(<ksztaltJadroA3)
				dta b(<ksztaltJadroA4),b(<ksztaltJadroA5),b(<ksztaltJadroA6)
ksztaltJadroAH	dta b(>ksztaltJadroA0),b(>ksztaltJadroA1),b(>ksztaltJadroA2),b(>ksztaltJadroA3)
				dta b(>ksztaltJadroA4),b(>ksztaltJadroA5),b(>ksztaltJadroA6)
ksztaltJadroBL	dta b(<ksztaltJadroB0),b(<ksztaltJadroB1),b(<ksztaltJadroB2),b(<ksztaltJadroB3)
				dta b(<ksztaltJadroB4),b(<ksztaltJadroB5),b(<ksztaltJadroB6)
ksztaltJadroBH	dta b(>ksztaltJadroB0),b(>ksztaltJadroB1),b(>ksztaltJadroB2),b(>ksztaltJadroB3)
				dta b(>ksztaltJadroB4),b(>ksztaltJadroB5),b(>ksztaltJadroB6)





;przygotuj liczniki i wyglad jadra
initJadra	equ *
		ldy #15
@		lda ksztaltJadroA4,y
		sta znaki1+(b+16)*8,y
		sta znaki2+(b+16)*8,y
		lda ksztaltJadroB4,y
		sta znaki1+(b+18)*8,y
		sta znaki2+(b+18)*8,y
		dey
		bpl @-
			
		lda czasOtwarcia
		cmp #255
		bne @+
		
		sta openA		;jesli wartosc ujemna to zablokuj jadra
		sta openB
		mva #1 czyJadroA
		sta czyJadroB
		
		mva #b+16+128 _bazaAJadro0		;jeśli jadra caly czas otwarte
		mva #b+17+128 _bazaAJadro1
		mva #b+18+128 _bazaBJadro0
		mva #b+19+128 _bazaBJadro1
		
		rts
		
@		mva #0 openA
		sta openB
		sta czyJadroA
		sta czyJadroB
		
		mva #4 licznikJadroA
		mva #20 licznikJadroB
		rts

;Animacja Jadra A
animacjaJadraA	equ *
		lda openA
		beq @+1
		cmp #255
		beq @+			;jesli ujemna wartosc to nie zmieniaj stanu
		dec openA
@		rts
	
@		mva #0 czyJadroA
		inc licznikJadroA
		lda licznikJadroA
		cmp #3
		bne @+
		mvx czasZamkniecia openA
@		cmp #19
		bne @+
		mvx czasOtwarcia openA
		odpalRakietyA		;MACRO
		mva #4 opozCoreA
		mva #1 liczCoreA
		sta czyJadroA
		rts

@		lsr @				;spowolnienie
		lsr @
		cmp #7
		bcc @+
		
		mva #0 licznikJadroA		;reset licznika
	
@		tax
		cpx #4
		bne @+
		mva #1 czyJadroA
		
@		ldy ad_jadra,x
		lda ramka
		bne @+
		.rept 16, #
			lda ksztaltJadroA0+:1,y
			sta znaki1+(b+16)*8+:1
		.endr
		jmp @+1
@		equ *
		.rept 16, #
			lda ksztaltJadroA0+:1,y
			sta znaki2+(b+16)*8+:1
		.endr	
		
@		cpx #4		
		bne @+
		mva #b+16+128 _bazaAJadro0
		mva #b+17+128 _bazaAJadro1
		rts
		
@		cpx #5
		beq @+
		rts
		
@		mva #b+16 _bazaAJadro0
		mva #b+17 _bazaAJadro1
		rts



ksztaltCoreA	equ *
		dta b(0)
		:2 dta b(%00110000)
		:2 dta b(%00111100)
		dta b(%11111011)
		dta b(%11100111)
		:2 dta b(%11010111)
		dta b(%11011011)
		dta b(%11101111)
		:2 dta b(%00111100)
		:2 dta b(%00001100)
		dta b(0)
;1
		dta b(0,0)
		:2 dta b(%00110000)
		:2 dta b(%00111100)
		dta b(%11111011)
		dta b(%11100111)
		dta b(%11011011)
		dta b(%11101111)
		:2 dta b(%00111100)
		:2 dta b(%00001100)
		dta b(0,0)
;2
		dta b(0,0,0)
		:2 dta b(%00110000)
		dta b(%00111100)
		dta b(%11111100)
		:2 dta b(%11101011)
		dta b(%00111111)
		dta b(%00111100)
		:2 dta b(%00001100)
		dta b(0,0,0)
;3	
		dta b(0,0,0,0,0)
		dta b(%00110000)
		dta b(%00111100)
		dta b(%11101111)
		dta b(%11111011)
		dta b(%00111100)
		dta b(%00001100)
		dta b(0,0,0,0,0)
		
ksztaltCoreB	equ *
		dta b(0)
		dta b(%00000011)
		dta b(%00001101)
		dta b(%11110101)
		dta b(%00111001)
		dta b(%00001101)
		dta b(%00000011)
		dta b(0,0)
		dta b(%11000000)
		dta b(%01110000)
		dta b(%01101100)
		dta b(%01011111)
		dta b(%01110000)
		dta b(%11000000)
		dta b(0)
;1
		dta b(0)
		dta b(%00000011)
		dta b(%00001101)
		dta b(%00110101)
		dta b(%00111101)
		dta b(%00001111)
		dta b(0,0,0)
		dta b(%11000000)
		dta b(%10110000)
		dta b(%01111100)
		dta b(%01011100)
		dta b(%01110000)
		dta b(%11000000)
		dta b(0)
;2
		dta b(0)
		dta b(%00000011)
		dta b(%00001011)
		dta b(%00001101)
		dta b(%00001001)
		dta b(%00001111)
		dta b(0,0,0,0)
		dta b(%11110000)
		dta b(%01100000)
		dta b(%01110000)
		dta b(%11100000)
		dta b(%11000000)
		dta b(0)
;3		
		dta b(0,0)
		dta b(%00000011)
		dta b(%00001101)
		dta b(%00000010)
		dta b(%00000011)
		dta b(0,0,0,0)
		dta b(%11000000)
		dta b(%10000000)
		dta b(%01110000)
		dta b(%11000000)
		dta b(0,0)
		
		
tabCoreA	dta b(0,16,32,48,48,32,16,0)
		
coreWaveA	equ *
		lda licznikJadroA		;jeśli otwarte jądro
		cmp #19
		beq @+
		lda openA
		cmp #255
		beq @+
		rts
@		dec opozCoreA		;opoznienie animacji
		bne @+ 
		mva #4 opozCoreA
		
		dec liczCoreA		;numer fazy animacji
		bpl @+
		mva #7 liczCoreA
		
@		ldx liczCoreA
		ldy tabCoreA,x
	
		lda ramka
		bne @+
		
		.rept 16, #
			lda ksztaltCoreA+:1,y
			sta znaki1+(b+16)*8+:1
		.endr
		rts
@		equ *
		.rept 16, #
			lda ksztaltCoreA+:1,y
			sta znaki2+(b+16)*8+:1
		.endr
		
		rts
		
;Animacja Jadra B
animacjaJadraB	equ *
		lda openB
		beq @+1
		cmp #255
		beq @+			;jesli ujemna wartosc to nie zmieniaj stanu
		dec openB
@		rts
	
@		mva #0 czyJadroB
		inc licznikJadroB
		lda licznikJadroB
		
		cmp #3
		bne @+
		mvx czasZamkniecia openB
@		cmp #19
		bne @+
		mvx czasOtwarcia openB
		odpalRakietyB		;MACRO
		mva #4 opozCoreB
		mva #1 liczCoreB
		sta czyJadroB
		rts
		
@		lsr @				;spowolnienie
		lsr @
		cmp #7
		bcc @+
		mva #0 licznikJadroB		;reset licznika
		
@		tax
		cpx #4
		bne @+
		lda licznikJadroB
		and #1
		beq @+
		mva #1 czyJadroB
		
@		ldy ad_jadra,x
		lda ramka
		bne @+
		.rept 16, #
			lda ksztaltJadroB0+:1,y
			sta znaki1+(b+18)*8+:1
		.endr
		jmp @+1
@		equ *
		.rept 16, #
			lda ksztaltJadroB0+:1,y
			sta znaki2+(b+18)*8+:1
		.endr
		
@		cpx #4		
		bne @+
		mva #b+18+128 _bazaBJadro0
		mva #b+19+128 _bazaBJadro1
		rts
		
@		cpx #5
		beq @+
		rts
		
@		mva #b+18 _bazaBJadro0
		mva #b+19 _bazaBJadro1
		rts
		
coreWaveB	equ *
		lda licznikJadroB		;jeśli otwarte jądro
		cmp #19
		beq @+
		lda openB
		cmp #255
		beq @+
		rts
@		dec opozCoreB		;opoznienie animacji
		bne @+ 
		mva #4 opozCoreB
		
		dec liczCoreB		;numer fazy animacji
		bpl @+
		mva #7 liczCoreB
		
@		ldx liczCoreB
		ldy tabCoreA,x
	
		lda ramka
		bne @+
		
		.rept 16, #
			lda ksztaltCoreB+:1,y
			sta znaki1+(b+18)*8+:1
		.endr
		rts
@		equ *
		.rept 16, #
			lda ksztaltCoreB+:1,y
			sta znaki2+(b+18)*8+:1
		.endr
		
		rts
		
exploAllEnemy	equ *
		ldx #5
@		lda enemy,x			;w momencie trafienia wszystkie statki wybuchaja
		beq @+
		lda enemyWybuch,x
		bne @+
		
		mva enemyFaza,x enemyLastFaza,x
		mva #8 enemyWybuch,x
		mva #EKOLOR1 enemyNegatyw,x	
		mva >explo_shapetab enemyShapeH,x
		mva #5*2 sfx_enemyHit

@		dex
		bpl @-1
		
		ldx #7
@		lda rakietyMove,x
		beq @+	
		lda #0	
		sta rakietyStan,x
		sta rakietyMove,x
		jsr dodajMalyWybuch		;dodaj male wybuchy
		
@		dex
		bpl @-1
		
		lda jestSpy
		beq eal
		cmp #3
		bcs eal
		mva #0 jestSpy		;zabezpieczenie przed pojawieniem się spy
eal		rts		
		
		