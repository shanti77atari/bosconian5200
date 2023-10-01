

;obsluga rakiet
rakiety		equ *
			ldx #7
rak0		equ *
@			lda rakietyStan,x
			bne @+
rak1		dex
			bpl @-
			rts			
				
@			lda rakietyTyp,x
			lsr 
			jne rakPoziom
			
rakPion		equ *
			sec
			lda rakietyY,x
			sbc posY
			sta rakietyY0,x
			clc
			adc #1
			cmp #30
			bcs @+
			
			sec
			lda rakietyX,x
			sbc posX		;c=1
			tay
			lda tabX,y
			sta rakietyX0,x
			cmp #33
			bcc @+1
@			lda rakietyMove,x
			beq rak1
			ldy rakietyStan,x
			mva #255 bazyRakieta-1,y
			lda #0
			sta rakietyStan,x
			sta rakietyMove,x
			jmp rak1

@			adc #8
			sta pom0f
			ldy rakietyY0,x
			iny
			
			lda ramka
			bne @+
			
			clc
			lda obraz1La+7,y
			adc pom0f
			sta pom
			lda obraz1Ha+7,y
			adc #0
			sta pom+1
			
			lda rakietyTyp,x
			asl 
			adc #firstRakietaChar+128
			
			ldy #0
			sta (pom),y
			ldy #48
			adc #1
			sta (pom),y
			jmp rak1
			
@			clc
			lda obraz2La+7,y
			adc pom0f
			sta pom
			lda obraz2Ha+7,y
			adc #0
			sta pom+1

			lda rakietyTyp,x
			asl @
			adc #firstRakietaChar+128
			
			ldy #0
			sta (pom),y
			ldy #48
			adc #1
			sta (pom),y
			jmp rak1


rakPoziom	equ *
			sec
			lda rakietyY,x
			sbc posY
			sta rakietyY0,x
			cmp #29
			bcs @+
			
			sec
			lda rakietyX,x
			sbc posX		;c=1
			tay
			lda tabX,y
			sta rakietyX0,x
			clc
			adc #1
			cmp #34
			bcc @+1
@			lda rakietyMove,x
			jeq rak1
			ldy rakietyStan,x
			mva #255 bazyRakieta-1,y
			lda #0
			sta rakietyStan,x
			sta rakietyMove,x
			jmp rak1

@			adc #7
			sta pom0f
			ldy rakietyY0,x
			
			lda ramka
			bne @+
			
			clc
			lda obraz1La+8,y
			adc pom0f
			sta pom
			lda obraz1Ha+8,y
			adc #0
			sta pom+1
			
			lda rakietyTyp,x
			asl @
			adc #firstRakietaChar+128
			
			ldy #0
			sta (pom),y
			iny
			adc #1
			sta (pom),y

			jmp rak1
			
@			clc
			lda obraz2La+8,y
			adc pom0f
			sta pom
			lda obraz2Ha+8,y
			adc #0
			sta pom+1

			lda rakietyTyp,x
			asl @
			adc #firstRakietaChar+128
			
			ldy #0
			sta (pom),y
			iny
			adc #1
			sta (pom),y

			jmp rak1
			
;poruszaj rakietami
moveRakiety	equ *
			ldx #7
mra2		lda rakietyMove,x
			bne mra1
			dex
			bpl mra2
			rts
						
mra1		lda rakietyTyp,x
			bne @+
			dec rakietyY,x
			dex
			bpl mra2
			rts
@			cmp #1
			bne @+
			inc rakietyY,x
			dex
			bpl mra2
			rts
@			cmp #3
			bcs @+		
			lda rakietyX,x
			sbc #0	;c=0 czyli odejmij 1
			and #127
			sta rakietyX,x
			dex
			bpl mra2
			rts
@			lda rakietyX,x
			adc #0		;c=1 czyli dodaj 1
			and #127
			sta rakietyX,x
			dex
			bpl mra2
			rts

rak_flag	dta b(0)
			
;uruchom rakiety przy bazach typu A	pionowe, typ 0 i 1
odpalRakietyA	.macro	;equ *

			ldy #7
			mva #0 rak_flag
odpraka0	ldx rakietyStan,y
			beq odpraka1
			
			lda rakietyTyp,y
			and #%10
			bne odpraka1
			sta bazyRakieta-1,x			;wyczysc numer rakiety przypisanej do bazy,A=0
			mva #1 rakietyMove,y		;uwolnienie rakiety
			sta rak_flag
odpraka1	dey
			bpl odpraka0
			lda rak_flag
			beq odpraka2
			lda #15*2
			sta SFX_RAKIETA
odpraka2	equ *	;lda licznikJadroA
			
			.endm
			
			
			
			
odpalRakietyB	.macro	;equ *		;poziome typ 2 i 3

			ldy #7
			mva #0 rak_flag
odprakb0	ldx rakietyStan,y
			beq odprakb1
			
			lda rakietyTyp,y
			and #%10
			beq odprakb1
			sta rakietyMove,y	;mva #1 rakietyMove,y		;uwolnienie rakiety
			sta rak_flag
			mva #0 bazyRakieta-1,x		;wyczysc numer rakiety przypisanej do bazy
odprakb1	dey
			bpl odprakb0
			lda rak_flag
			beq odprakb2
			lda #15*2
			sta SFX_RAKIETA
odprakb2	equ *	;lda licznikJadroB
			
			.endm
			
	
;rakiety bazy A
DODAJRAKIETAA	.macro	
			lda licznikJadroA
			cmp #5
			bcc dra1
			cmp #16
			bcs dra1
			
			szukajRakieta		;MACRO
			sta bazyRakieta-1,x		;wpisz numer przypisanej rakiety
			
			txa
			sta rakietyStan,y
			lda bazyX-1,x
			clc
			adc #4
			sta rakietyX,y
			
			lda bazyY0-1,x		;nad czy pod statkiem ?
			clc
			adc #8
			cmp #10+8
			bcc dra2
			
			mva #0 rakietyTyp,y		;w gore
			lda bazyY-1,x
			clc
			adc #2
			sta rakietyY,y
			jmp dra1
			
dra2		mva #1 rakietyTyp,y		;w dol
			lda bazyY-1,x
			clc
			adc #4
			sta rakietyY,y
						
dra1		equ *
			.endm

;poszukaj nieaktywna rakiete
szukajRakieta	.macro	;equ *

			ldy #7
szrak0		lda rakietyStan,y
			beq szrak1
			dey
			bpl szrak0
szrak1		tya
			
			.endm
			

;rakiety bazy B
DODAJRAKIETAB	.macro
			lda licznikJadroB
			cmp #5
			bcc drb1
			cmp #16
			bcs drb1
			
			szukajRakieta		;MACRO
			sta bazyRakieta-1,x		;wpisz numer przypisanej rakiety
			
			txa
			sta rakietyStan,y
			lda bazyY-1,x
			clc
			adc #4
			sta rakietyY,y
			
			lda bazyX0-1,x		;po lewo czy po prawo od statku?
			clc
			adc #8
			cmp #12+8
			bcc drb2
			
			mva #2 rakietyTyp,y		;w lewo
			lda bazyX-1,x
			clc
			adc #2
			sta rakietyX,y
			jmp drb1
			
drb2		mva #3 rakietyTyp,y		;w prawo
			lda bazyX-1,x
			clc
			adc #4
			sta rakietyX,y
					
drb1		equ *			
			.endm
			
			
			
			

			