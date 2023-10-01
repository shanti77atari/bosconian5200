;pozycja statku x=60px y=102:2=51px


;kolizje strzaly z rakietami
kolStrzalyRakiety	equ *
			lda czyRakiety
			bne *+3
			rts
			
			ldx #7
@			lda rakietyMove,x
			bne @+
kolsr2		dex
			bpl @-
			rts	;jmp kolsr1		;next strzal
			
@			ldy #3
@			lda strzal,y
			beq kolsr1
			lda strzalTlo,y
			and #127
			cmp #firstRakietaChar		;pomijamy znaki gwiazd,bazy,meteory i bomby
			bcs @+
kolsr1		dey
			bpl @-
			jmp kolsr2
			
@			lda rakietyTyp,x
			and #%10
			beq kolsr3		;pion
			
;poziome rakiety <>	
			lda rakietyY0,x		
			asl
			asl
			eor #255
			sec		;+1
			adc strzalY3,y
			cmp #4
			bcs kolsr1		;next strzal
		
			lda rakietyX0,x	
			asl
			asl
			eor #255
			sec	;+1
			adc strzalX3,y
			cmp #8
			bcs kolsr1		;next strzal	

			jmp kolsr4
;pionowe rakiety ^			
kolsr3		lda rakietyX0,x	
			asl
			asl
			eor #255
			sec	;+1
			adc strzalX3,y
			cmp #3
			bcs kolsr1		;next strzal	
			
			lda rakietyY0,x		
			asl
			asl
			eor #255
			sec		;+1
			adc strzalY3,y
			cmp #8
			bcs kolsr1		;next strzal			
			
kolsr4		lda #0
			sta strzal,y		;wylacz strzal
			ldy rakietyStan,x
			sta rakietyStan,x
			sta rakietyMove,x

			mva #255 bazyRakieta-1,y

			jsr dodajMalyWybuch
			lda #$7
			jsr dodajPunkty
			
			jmp kolsr2		;next rakieta
			
;kolizje enemy z obiektami
kolObiektyEnemy	equ *
			ldy licznikBombyEkran
			bne @+
			rts
			
@			lda bombyEkran-1,y
			cmp #255
			bne @+
obe2		equ *
			dey
			bne @-
			rts
			
@			ldx #5
@			lda enemyEkran,x
			ora enemyWybuch,x
			beq @+
obe3		dex
			bpl @-
			jmp obe2		
			
@			lda bombX0-1,y		;od 0 do 33 (+1)
			asl @
			asl @
			adc #2+1	;c=0, pozycja bomby jest powiekszona o 1 , po dzialaniu c=0, dodajemy wiec +1 i sec przy odejmowaniu jest niepotrzebne
			;sec		;zbedne
			sbc enemyPosX,x
			cmp #13
			bcs obe3
			
			
			lda bombY0-1,y	;jak powyzej
			asl @
			asl @
			adc #2+1
			
			;sec
			sbc enemyPosY,x
			cmp #13
			bcs obe3
			
			mva enemyFaza,x enemyLastFaza,x
			mva #8 enemyWybuch,x
			mva #EKOLOR1 enemyNegatyw,x

			mva #>explo_shapetab enemyShapeH,x	


@			cpx #5
			bne @+
			lda jestSpy	;czySpy?
			beq @+
			mva #$ff spyScore
						
@			mva #5*2 sfx_enemyHit
			lda #$2					;20 pkt jak enemy wpadnie na obiekt
			jsr dodajPunkty

		
			ldx bombyEkran-1,y
			lda bombRodzaj-1,x
			beq @+
			mva #255 bombRodzaj-1,x
			sta bombyEkran-1,y
			mva #5*2 sfx_enemyHit
			
			lda bombX-1,x
			sty pom0
			ldy bombY-1,x
			jsr dodajWybuch
			ldy pom0
			jmp obe2
			
@			mva #255 bombRodzaj-1,x
			sta bombyEkran-1,y
			lda bombX-1,x
			sec
			sbc #1
			sty pom0
			ldy bombY-1,x
			dey
			jsr bombExplo
			ldy pom0
			jmp obe2
			
;oblicz pozycje xi y enemy
obliczEnemyXY	equ *
			.rept 6, #
			lda enemyEkran+:1
			ora enemyWybuch+:1
			bne obe1:1
			
			lda enemyX0+:1
			asl
			asl
			ora enemyDX0+:1
			sta enemyPosx+:1
			
			lda enemyY0+:1
			asl
			asl
			ora enemyDY0+:1
			sta enemyPosY+:1
			
obe1:1		equ *
			.endr
			rts


;kolizje pociskow z przeciwnikami
kolPociskiEnemy	equ *
			ldx maxPociskow
@			lda pociski,x
			
			bmi kolpe1
			lda pociskiTlo,x			;szukaj kolizji jesli znak pod pociskiem to znak jakiegos duszka >73
			cmp #74
			bcs @+
			
kolpe1		dex
			bpl @-
			rts

@			ldy #5
@			lda enemyEkran,Y
			ora enemyWybuch,y
			beq @+
kolpe2		dey
			bpl @-
			jmp kolpe1
			
@			lda pociskiDX0,x
			sec	
			sbc enemyPosX,y
			cmp #8	
			bcs kolpe2
			
			lda pociskiDY0,x
			sec	
			sbc enemyPosY,y
			cmp #8
			bcs kolpe2
			
			
			mva #129 pociski,x
			dec liczbaPociskow
			
			mva enemyFaza,y enemyLastFaza,y
			mva #8 enemyWybuch,y
			mva #EKOLOR1 enemyNegatyw,y
			mva #>explo_shapetab enemyShapeH,y	
			
			cpy #5
			bne @+
			lda jestSpy	;czySpy?
			beq @+

			mva #$ff spyScore
			mva #2*2 sfx_enemyHit
			jmp kolpe1

			
@			lda #$5
			jsr dodajPunkty
			mva #5*2 sfx_enemyHit
			
			jmp kolpe1


;kolizje strzalow z przeciwnikami
kolStrzalyEnemy	equ *
			ldx #3
@			lda strzal,x
			
			beq kolse1
			lda strzalTlo,x
			and #127
			cmp #74		;sprawdzaj tylko jeśli pod strzałem jest znak duszka
			bcs @+
			
kolse1		dex
			bpl @-
			rts
			
@			ldy #0
@			lda enemyEkran,y
			ora enemyWybuch,y
			beq @+
kolse2		iny
			cpy #6				
			bcc @-
			jmp kolse1
			
@			lda strzalX3,x
			sec	
			sbc enemyPosX,y
			cmp #8
			bcs kolse2
			
			lda strzalY3,x
			sec	
			sbc enemyPosY,y
			cmp #8 
			bcs kolse2
			
			mva #0 strzal,x
			mva enemyFaza,y enemyLastFaza,y
			mva #8 enemyWybuch,y
			mva #EKOLOR1 enemyNegatyw,y
			mva #>explo_shapetab enemyShapeH,y
			
			cpy #0
			beq @+
			lda formacja_zbite
			cmp #4
			bne @+
			inc formacja_zbite		;jesli ostatni z formacji		
			
@			lda formacja_stan		;zapamietaj pozycje ostatnio zbitego statku formacji
			cmp #5
			bne @+
			cpy #0
			beq @+
			lda enemyX,y
			sta spyscoreX
			lda enemyY,y
			sta spyscoreY
			
			
@			cpy #5
			bne @+
			lda jestSpy	;czySpy?
			beq @+
			lda #$ff
			jsr dodajPunkty
			mva #2*2 sfx_enemyHit
			jmp kolse1

			
@			lda #$5
			jsr dodajPunkty
			mva #5*2 sfx_enemyHit
			
			jmp kolse1
				
;kolizje strzalow z przeciwnikami
kolStrzalyEnemy1	equ *
			ldx #3
@			lda strzal,x
			
			beq kolse1_
			lda strzalTlo1,x
			and #127
			cmp #74		;sprawdzaj tylko jeśli pod strzałem jest znak duszka
			bcs @+
			
kolse1_		dex
			bpl @-
			rts
			
@			ldy #5
@			lda enemyEkran,y
			ora enemyWybuch,y
			beq @+
kolse2_		dey
			bpl @-
			jmp kolse1_
			
@			lda strzalX3,x
			sec	
			sbc enemyPosX,y
			cmp #8
			bcs kolse2_
			
			lda strzalY3,x
			sec	
			sbc enemyPosY,y
			cmp #8 
			bcs kolse2_
			
			mva #0 strzal,x
			mva enemyFaza,y enemyLastFaza,y
			mva #8 enemyWybuch,y
			mva #EKOLOR1 enemyNegatyw,y
			mva #>explo_shapetab enemyShapeH,y
			
			cpy #0
			beq @+
			lda formacja_zbite
			cmp #4
			bne @+
			inc formacja_zbite		;jesli ostatni z formacji		
			
@			lda formacja_stan		;zapamietaj pozycje ostatnio zbitego statku formacji
			cmp #5
			bne @+
			cpy #0
			beq @+
			lda enemyX,y
			sta spyscoreX
			lda enemyY,y
			sta spyscoreY
			
			
@			cpy #5
			bne @+
			lda jestSpy	;czySpy?
			beq @+
			lda #$ff
			jsr dodajPunkty
			mva #2*2 sfx_enemyHit
			jmp kolse1_

			
@			lda #$5
			jsr dodajPunkty
			mva #5*2 sfx_enemyHit
			
			jmp kolse1_


				
;kolizja statku z wrogiem
kolStatekEnemy	equ *
			ldx #5
@			lda enemyEkran,x
			ora enemyWybuch,x
			beq @+
kolen1		dex
			bpl @-
			rts		
			
@			lda enemyPosX,x
			clc 	;-1
			sbc movX0
			;sec				;można pominąć, jeśli poprzedni wynik jest ujemny to i tak poza zakresem
			sbc #61-7	;#54	;+2
			cmp #14		;13
			bcs kolen1
			
			lda enemyPosY,x
			sec
			sbc movY0
			;sec				; jak wyżej
			sbc #53-7	;#46	;+1
			cmp #14		;13		
			bcs kolen1
			
			mva #62 fazaWybuch
			mva #1 trafienie
			mva #9*2 sfx_dead
			
			rts
		
;kolizje statku z bazami
kolStatekBazy	equ *
			ldx licznikBazyEkran
			bne *+3
			rts

kolst1		lda bazyEkran-1,x
			bmi kolst2
			tay
			lda bazyRodzaj-1,y
			bmi kolst2
			
			bne @+		;baza b

	;baza A
			lda bazyX0-1,y
			;bmi kolst2
			asl @
			asl @
			clc
			sbc movX0
			sbc #60-35
			cmp #43
			bcs kolst2
			sta pom4
		
			;eor #255
			;sec
			;adc movX0
			;adc #60+7+1		;68
			;cmp #43
			;bcs kolst2
			;sta pom4
			
			lda bazyY0-1,y
			;bmi kolst2
			asl @
			asl @
			sec
			sbc movY0
			sbc #52-31
			cmp #39
			bcs kolst2
			sta pom4+1
			
			;eor #255
			;clc
			;adc movY0
			;adc #52+7+1
			;cmp #39
			;bcs kolst2
			;sta pom4+1
			
			;tutaj dokladne sprawdzenie bazy A
			jmp sprawdzBazaA		;skok bezwarunkowy
			
	;baza B
@			lda bazyX0-1,y
			;bmi kolst2
			asl @
			asl @
			clc
			sbc movX0
			sbc #60-31
			cmp #39
			bcs kolst2
			sta pom4
			
			;eor #255
			;sec
			;adc movX0
			;adc #68
			;cmp #40
			;bcs kolst2
			;sta pom4
			
			lda bazyY0-1,y
			;bmi kolst2
			asl @
			asl @
			sec
			sbc movY0
			sbc #52-35
			cmp #43
			bcs kolst2
			sta pom4+1
			
			;eor #255
			;clc
			;adc movY0
			;adc #58+1
			;cmp #44
			;bcs kolst2
			;sta pom4+1
			
			jmp sprawdzBazaB
			
kolst2		;ldx pom0f
			dex
			bne kolst1
			rts

;sprawdz czy statek jest na bazie A
sprawdzBazaA	equ *
			sty pom0a		;zapamietaj numer bazy
			
			ldx sJoy
			lda kolTab1,x
			tax				;znajdz dane dla danego wygladu statku

			mva #3 pom0e		;licznik petli
			
sprba2		sec
			
			lda pom4
			sbc kolTab2,x	;pozycja X punktu testowego
			cmp #36			;9*4
			bcs sprba1		;nastepny punkt, poza zakresem lub ujemna
			asl @
			and #%11111000	;X bylo *4 wiec wystarczy *2 i obciecie najmlodszych bitow
			sta pom0c
			
			sec

			lda pom4+1
			sbc kolTab2+24,x	;pozycja Y punktu testowego
			cmp #32			;8*4
			bcs sprba1
			lsr @
			lsr @
					
			ora pom0c
			tay
			lda bazaA2,y
			beq sprba1	
			
@			cmp #128
			bcc @+
			
			and #127			;czy zbity element dzialka
			tay
			lda tabKol0,y
			ldy pom0a
			and bazyStan-1,y
			beq sprba1
			
@			ldy pom0a

			jsr usunBazeA			
			mva #62 fazaWybuch
			mva #1 trafienie
			mva #9*2 sfx_dead
			rts
			
sprba1		inx
			dec pom0e
			bne sprba2
			
			rts
			
sprawdzBazaB	equ *
			sty pom0a		;zapamietaj numer bazy
			
			ldx sJoy
			lda kolTab1,x
			tax				;znajdz dane dla danego wygladu statku
			
			mva #3 pom0e		;licznik petli
			
sprba4		sec				
			lda pom4
			sbc kolTab2,x	;pozycja X punktu testowego
			cmp #32		;8*4
			bcs sprba3
			lsr @
			lsr @
			sta pom0c
			
			
			sec

			lda pom4+1
			sbc kolTab2+24,x	;pozycja Y punktu testowego
			cmp #36		;9*4
			bcs sprba3
			asl @
			and #%11111000
			
			ora pom0c
			tay
			lda bazaB2,y
			beq sprba3
			
@			cmp #128
			bcc @+
			
			and #127			;czy zbity element dzialka
			tay
			lda tabKol0,y
			ldy pom0a
			and bazyStan-1,y
			beq sprba3
			
@			ldy pom0a
			jsr usunBazeB			
			mva #62 fazaWybuch
			mva #1 trafienie
			mva #9*2 sfx_dead
			rts
			
sprba3		inx
			dec pom0e
			bne sprba4

			rts

kolTab1		dta b(0,12,0,0,6,9,3,0,18,15,21)
kolTab2		dta b(4,7,0,0,6,1,0,4,4,6,1,0,6,0,3,7,6,1,7,3,3,7,6,1)
			dta b(7,2,2,7,6,1,4,7,0,1,6,0,5,5,0,0,6,1,4,7,0,7,1,6)
tabRak1		dta b(45,50)		;granice Y
			dta b(59,54)		;granice X
			
			
;kolizje rakiety ze statkiem
kolRakietyStatek	equ *
			lda czyRakiety
			bne *+3
			rts

			ldx #7
@			lda rakietyMove,x
			bne @+1
			
@			dex
			bpl @-1
			
			rts
			
@			lda rakietyTyp,x
			lsr @
			tay
			
			lda rakietyY0,x
			asl @
			asl @
			sec
			sbc movY0
			cmp tabRak1,y
			bcc @-1
			cmp #60
			bcs @-1
			
			lda rakietyX0,x
			asl @
			asl @
			clc
			sbc movX0
			cmp tabRak1+2,y
			bcc @-1
			cmp #68
			bcs @-1
			
			mva #62 fazaWybuch
			mva #1 trafienie
			mva #9*2 sfx_dead
			rts
			
;kolizja rakiety z obiektami
kolRakietyObiekty	equ *
			lda czyRakiety
			bne *+3
			rts
			
			ldy licznikBombyEkran		;czy sa jakies bomby na ekranie
			bne *+3
			rts
			
			ldx #7
@			lda rakietyMove,x
			bne @+
kolrak3		dex
			bpl @-
			rts
			
@			ldy licznikBombyEkran
			lda rakietyTyp,x
			and #%10
			bne kolrak2b
			
kolrak2		lda bombyEkran-1,y
			sty pom0
			tay
			lda bombRodzaj-1,y
			bmi kolrak1
			
			sta pom0a
			ldy pom0
			
			lda bombX0-1,y
			sec
			sbc rakietyX0,x
			cmp #2
			bcs kolrak1b
			
			lda bombY0-1,y
			sec
			sbc rakietyY0,x
			cmp #3
			bcc @+
			
			
			
kolrak1b	dey
			bne kolrak2
			jmp kolrak3
			
kolrak1		equ *
			ldy pom0
			dey
			bne kolrak2
			jmp kolrak3			


kolrak2b	lda bombyEkran-1,y
			sty pom0
			tay
			lda bombRodzaj-1,y
			bmi kolrak1z
			
			sta pom0a
			ldy pom0
			
			lda bombX0-1,y
			sec
			sbc rakietyX0,x
			cmp #3
			bcs kolrak1c
			
			lda bombY0-1,y
			sec
			sbc rakietyY0,x
			cmp #2
			bcc @+
			
kolrak1c	dey
			bne kolrak2b
			jmp kolrak3
			
kolrak1z	equ *
			ldy pom0
			dey
			bne kolrak2
			jmp kolrak3					
			
@			lda bombyEkran-1,y
			tay
			lda bombRodzaj-1,y
			pha
			mva #255 bombRodzaj-1,y
			
			pla
			beq @+
			lda bombX-1,y
			pha
			lda bombY-1,y
			tay
			pla
			jsr dodajWybuch
			mva #0 sfx_asteroid
			
			
			ldy rakietyStan,x
			mva #255 bazyRakieta-1,y
			ldy pom0
			lda #0
			sta rakietyStan,x
			sta rakietyMove,x
			jmp kolrak3
			
@			lda bombX-1,y
			sec
			sbc #1
			sta kolpom0
			lda bombY-1,y
			tay
			dey
			lda kolpom0
			jsr bombExplo
			
			ldy rakietyStan,x
			mva #255 bazyRakieta-1,y
			ldy pom0
			lda #0
			sta rakietyStan,x
			sta rakietyMove,x
			
			jmp kolrak3 
			
		
tabkolsx	:15 dta b(255)
			dta b(60-57,64-57,68-57,72-57)
			:15 dta b(255)
			
tabkolsy	:13 dta b(255)
			dta b(52-49,56-49,60-49,64-49)
			:13 dta b(255)
			
;kolizje statku z obiektami (miny,meteory)
kolStatekObiekty	equ *
			ldx licznikBombyEkran
			bne @+
			rts
			
@			lda bombyEkran-1,x
			tay
			lda bombRodzaj-1,y
			bpl @+1
@			dex
			bne @-1
			
			rts
			
@			ldy bombX0-1,x
			lda tabkolsx,y
			bmi @-1
			
			clc
			sbc movX0
			cmp #15
			bcs @-1
			
			ldy bombY0-1,x
			lda tabkolsy,y
			bmi @-1
			
			sec
			sbc movY0
			cmp #15
			bcs @-1
			
			;wystapila kolizja
			ldy bombyEkran-1,x
			lda bombRodzaj-1,y
			beq @+
			mva #255 bombRodzaj-1,y
			
			mva #62 fazaWybuch
			mva #1 trafienie
			mva #9*2 sfx_dead
			
			lda bombX-1,y
			sta pom0
			lda bombY-1,y
			tay
			lda pom0
			jmp dodajWybuch
			
@			mva #255 bombRodzaj-1,y

			mva #62 fazaWybuch
			mva #1 trafienie
			mva #9*2 sfx_dead

			lda bombX-1,y
			sec
			sbc #1
			sta kolpom0
			lda bombY-1,y
			tay
			dey
			lda kolpom0
			jmp bombExplo
			
;kolizje statku z wybuchem
kolStatekWybuch	equ *
			lda wybuchyStart
			and #%11111
			tax
			cpx wybuchyStop
			bne *+3
			rts		;brak wybuchow
			
@			lda wybuchyX0,x
			asl @
			asl	@
			sbc movX0		
			cmp #53
			bcc @+
			cmp #68
			bcs @+
			
			lda wybuchyY0,x
			asl @
			asl @
			sbc movY0
			cmp #45-1		;zmniejszone o 1 brak sec
			bcc @+
			cmp #60-1
			bcs @+
			
			mva #62 fazaWybuch
			mva #1 trafienie
			mva #9*2 sfx_dead
			rts
			
@			inx
			txa
			and #%11111
			tax
			cpx wybuchyStop
			bne @-1

			rts
			
;kolizje pociskow ze statkiem
kolPociskiStatek	equ *
			ldx maxPociskow
@			lda pociski,x
			bpl @+
kolps1		dex
			bpl @-
			rts
			
@			lda pociskiDX0,x
			clc
			sbc movX0
			cmp #60
			bcc kolps1		;za malo
			cmp #68
			bcs kolps1		;za duzo
			
			lda pociskiDY0,x
			sec
			sbc movY0
			cmp #52
			bcc kolps1		;za malo
			cmp #60
			bcs kolps1		;za duzo
			
			mva #62 fazaWybuch
			mva #1 trafienie
			mva #9*2 sfx_dead
			rts
		
;kolizje pociskow z obiektami
kolPociskiObiekty	equ *
			ldx maxPociskow
@			lda pociski,x
			
			bmi kolpo1
			lda pociskiTlo,x		;jesli pod pociskiem jest meteor lub bomba to poszukaj kolizji
			cmp #firstBombaChar
			bcc kolpo1
			cmp #firstMeteorChar+4
			bcc @+
kolpo1		dex
			bpl @-
			rts

@			ldy licznikBombyEkran
			bne kolpo3
			rts
			
kolpo3		sty pom0
			lda bombyEkran-1,y		;jesli <0 to nie ma juz tego obiekt
			tay
			lda bombRodzaj-1,y
			bmi kolpo2
			lda pociskiY,x
			sec
			sbc bombY-1,y
			cmp #2
			bcs kolpo2
			lda pociskiX,x
			sec
			sbc bombX-1,y
			cmp #2
			bcc @+	
			
kolpo2		ldy pom0
			dey
			bne kolpo3
			jmp kolpo1		;skok bezwarunkowy			
			
@			lda bombRodzaj-1,y
			pha
			mva #255 bombRodzaj-1,y
			mva #129 pociski,x
			dec liczbaPociskow
			
			pla
			beq @+
			lda bombX-1,y
			pha
			lda bombY-1,y
			tay
			mva #0 sfx_asteroid
			pla
			jsr dodajWybuch
			jmp kolpo1
			
@			lda bombX-1,y
			sec
			sbc #1
			sta kolpom0
			lda bombY-1,y
			tay
			dey
			lda kolpom0
			
			jsr bombExplo
			jmp kolpo1
			


;Animacja wybuchu bomby 5xwybuch
bombExplo	equ *
			stx kolpom0
			tax
			jsr dodajWybuch
			inx
			inx
			txa
			jsr dodajWybuch
			iny
			iny
			txa
			jsr dodajWybuch
			dex
			dex
			txa
			jsr dodajWybuch
			mva #1*2 sfx_bomba
			dey
			inx
			txa
			jsr dodajWybuch
			dey			;zachowujemy wartosc Y
			ldx kolpom0
			rts 
	
;kolizje strzalow statku z obiektami (bomba,meteor)
kolStrzalyObiekty	equ *	
			ldx #3
@			lda strzal,x
			beq kolso1
			lda strzalTlo,x		;jeśli cos jest pod strzalem to sprawdz kolizje
			and #127
			cmp #firstBombaChar
			bcc kolso1
			cmp #firstMeteorChar+4
			bcc @+
kolso1		dex
			bpl @-
			rts

			
@			ldy licznikBombyEkran
			bne kolso3
			rts
			
kolso3		sty pom0
			lda bombyEkran-1,y
			tay
			lda bombRodzaj-1,y
			bmi kolso2		;nastepny obiekt
			sta pom0f
			sty pom0a
			ldy pom0
			lda bombY0-1,y	;pozycja Y bomby na ekranie +1
			sec
			sbc strzalY2,x
			cmp #2
			bcs kolso2a		;nastepny obiekt
			
			lda bombX0-1,y	;pozycja X bomby na ekranie +1
			sec
			sbc strzalX2,x
			cmp #2
			bcc @+
			
kolso2a		dey
			bne kolso3
			jmp kolso1		;skok bezwarunkowy	

kolso2		ldy pom0
			dey
			bne kolso3
			jmp kolso1		;skok bezwarunkowy				
			
@			lda pom0f
			eor #1
			clc
			adc #1
			jsr dodajPunkty
			ldy pom0a
			mva #255 bombRodzaj-1,y
			mva #0 strzal,x
			
			
			lda pom0f
			beq @+
			
			lda bombX-1,y
			pha
			lda bombY-1,y
			tay
			mva #0 sfx_asteroid
			pla
			jsr dodajWybuch
			
			jmp kolso1		;bezwarunkowy , sprawdz nastepny strzal
			
@			lda bombX-1,y
			sec
			sbc #1
			sta kolpom0
			pha
			lda bombY-1,y
			tay
			dey
			pla
			
			jsr bombExplo
			jmp kolso1

;kolizje strzalow statku z obiektami (bomba,meteor)
kolStrzalyObiekty1	equ *	
			ldx #3
@			lda strzal,x
			beq kolso1_
			lda strzalTlo1,x		;jeśli cos jest pod strzalem to sprawdz kolizje
			and #127
			cmp #firstBombaChar
			bcc kolso1_
			cmp #firstMeteorChar+4
			bcc @+
kolso1_		dex
			bpl @-
			rts

			
@			ldy licznikBombyEkran
			bne kolso3_
			rts
			
kolso3_		sty pom0
			lda bombyEkran-1,y
			tay
			lda bombRodzaj-1,y
			bmi kolso2_		;nastepny obiekt
			sta pom0f
			sty pom0a
			ldy pom0
			lda bombY0-1,y	;pozycja Y bomby na ekranie +1
			sec
			sbc strzalY2,x
			cmp #2
			bcs kolso2a_		;nastepny obiekt
			lda bombX0-1,y	;pozycja X bomby na ekranie +1
			sec
			sbc strzalX2,x
			cmp #2
			bcc @+
			
kolso2a_	dey
			bne kolso3_
			jmp kolso1_		;skok bezwarunkowy	

kolso2_		ldy pom0
			dey
			bne kolso3_
			jmp kolso1_		;skok bezwarunkowy				
			
@			lda pom0f
			eor #1
			clc
			adc #1
			jsr dodajPunkty
			ldy pom0a
			mva #255 bombRodzaj-1,y
			mva #0 strzal,x
			
			
			lda pom0f
			beq @+
			
			lda bombX-1,y
			pha
			lda bombY-1,y
			tay
			mva #0 sfx_asteroid
			pla
			jsr dodajWybuch
			
			jmp kolso1_		;bezwarunkowy , sprawdz nastepny strzal
			
@			lda bombX-1,y
			sec
			sbc #1
			sta kolpom0
			pha
			lda bombY-1,y
			tay
			dey
			pla
			
			jsr bombExplo
			jmp kolso1_

			
;kolizje strzalow z bazami
kolStrzalyBazy	equ *
			lda licznikBazyEkran
			bne @+
			rts

@			ldx #3
@			lda strzal,x
			bne @+
kolsb1		dex
			bpl @-
			rts

@			ldy licznikBazyEkran

kolsb3		sty pom0
			lda bazyEkran-1,y
			tay
			lda bazyRodzaj-1,y
			beq @+
			bpl @+1		;baza b
			
kolsb2		ldy pom0
			dey
			bne kolsb3
			jmp kolsb1		;sok bezwarunkowy
			
@			lda strzalY2,x
			sec
			sbc bazyY0-1,y
			cmp #8
			bcs kolsb2
			sta pom0b
			lda strzalX2,x
			sec
			sbc bazyX0-1,y
			cmp #9
			bcs kolsb2
			sty pom0a		;indeks trafionej bazy
			stx pom0f
			jsr kolBazaA
			ldx pom0f
			jmp kolsb1

@			lda strzalX2,x
			sec
			sbc bazyX0-1,y
			cmp #8
			bcs kolsb2
			sta pom0b
			lda strzalY2,x
			sec
			sbc bazyY0-1,y
			cmp #9
			bcs kolsb2
			sty pom0a		;indeks trafionej bazy
			stx pom0f
			jsr kolBazaB
			ldx pom0f
			jmp kolsb1

			
bazaA1		dta b(0,0,0,128+5,128+5,0,0,0)
			dta b(0,0,2,8+5,8+5,2,0,0)
			dta b(128+0,8+0,7,7,7,7,8+4,128+4)
			dta b(8+0,8+0,7,7,7,7,8+4,8+4)
			dta b(0,0,0,6,6,0,0,0)
			dta b(8+1,8+1,7,7,7,7,8+3,8+3)
			dta b(128+1,8+1,7,7,7,7,8+3,128+3)
			dta b(0,0,3,8+2,8+2,3,0,0)
			dta b(0,0,0,128+2,128+2,0,0,0)
			
bazaA2		dta b(0,0,0,128+2,128+2,0,0,0)
			dta b(0,0,3,8+2,8+2,3,0,0)
			dta b(128+3,8+3,7,7,7,7,8+1,128+1)
			dta b(8+3,8+3,7,7,7,7,8+1,8+1)
			dta b(0,0,0,6,6,0,0,0)
			dta b(8+4,8+4,7,7,7,7,8+0,8+0)
			dta b(128+4,8+4,7,7,7,7,8+0,128+0)
			dta b(0,0,2,8+5,8+5,2,0,0)
			dta b(0,0,0,128+5,128+5,0,0,0)			

dzialkoAX	dta b(2,5,7,5,2,0,2,5)
dzialkoAY	dta b(0,0,3,6,6,3,3,3)
bazaAbit		dta b(0,1)
			
kolBazaA	equ *
			asl @
			asl @
			asl @
			adc pom0b
			tay
			lda bazaA1,y
			bne @+
			rts			;puste pole
			
@			cmp #7
			bne @+
			
			mva #0 strzal,x		;trafiono tylko w baze
			rts
			
@			cmp #6
			bcs @+2
			
			ldy strzalKierunek,x
			cpy #1
			bne @+		;strzal poziomy i po skosie to zablokuj
			
			tay
			lda strzalXbit,x		;gorny lewy rog
			lsr
			cmp bazaAbit-2,y
			beq @+1
			
@			mva #0 strzal,x
@			rts
			
@			cmp #6
			bne @+
			
			mva #0 strzal,x			;jadro
			lda czyJadroA
			beq @-1
			ldy pom0a
			mva #255 bazyRodzaj-1,y
			jmp usunBazeA
			
@			sta pom0c
			and #%111
			tay
			sty pom0e		;numer dzialka
			lda tabKol0,y
			sta pom0d		;bit dzialka
			ldy pom0a	;indeks bazy
			and bazyStan-1,y		;czy dzialo jest zestrzelone
			beq @+2
			
			;trafiono dzialko
			mva #0 strzal,x
			lda bazyStan-1,y
			eor pom0d
			sta bazyStan-1,y
			bne @+
			
			lda #$20
			jsr dodajPunkty
			jmp usunBazeA1
			
@			ldx pom0e		;nr dzialka
			lda tabKol1,x		;adres ksztaltu po trafieniu
			ora #3
			sta pom4
			lda tabKol1+6,x
			sta pom4+1
			
			lda tabKol2,x		;cannonX
			sta pom
			lda tabKol2+6,x
			sta pom+1
			
			lda bazyX-1,y
			clc
			adc dzialkoAX,x
			pha
			lda bazyY-1,y
			adc dzialkoAY,x
			tay
			pla
			jsr dodajWybuch
			
			ldy pom0a
			dey
			ldx #0
			mva #3 pom0f
			clc
@			equ *
			lda (pom4,x)
			sta (pom),y
			;clc
			lda pom
			adc #maxBaz
			sta pom
			dec pom4
	
			dec pom0f
			bpl @-
			
			lda #$20
			jsr dodajPunkty
			
			mva #7*2 sfx_dzialko
			
			rts
		
@			lda pom0c
			bpl @+
			rts

@			mva #0 strzal,x
			rts				;narazie nic nie rob
			
;usuwa baze numer w Y i dodaje wybuchy (powiekszonuy o 1)
usunBazeA	equ *
			lda #$50			;bonus za trafienie w jądro bazy
			jsr dodajPunkty
			
usunBazeA1	jsr eorBazaRadar		;bez bonus
			lda #$75
			jsr dodajPunkty
			lda #$75
			jsr dodajPunkty
			
			mva #255 bazyRodzaj-1,y
			inc zbiteBazy
			
			ldx bazyRakieta-1,y
			bmi @+
			
			mva #255 bazyRakieta-1,y
			mva #0 rakietyStan,x
			sta rakietyMove,x
			
@			lda bazyX-1,y
			sta pom4+1
			lda bazyY-1,y
			sta pom4
			
			ldx #7
@			clc
_usb2		lda pom4
			adc dzialkoAY,x
			tay
_usb1		lda pom4+1
			adc dzialkoAX,x
			jsr dodajWybuch
			dex
			bpl @-
					
			jsr zmniejszKondycja

			mva #8*2 sfx_wybuch
			mva #14 waitWybuch
			
			rts
			
tabKol0		dta b(%1,%10,%100,%1000,%10000,%100000)
tabKol1		dta b(<kCannon,<(kCannon+4),<(kCannon+8),<(kCannon+12),<(kCannon+16),<(kCannon+20))
			dta b(>kCannon,>(kCannon+4),>(kCannon+8),>(kCannon+12),>(kCannon+16),>(kCannon+20))
			dta b(<(kCannon+24),<(kCannon+28),<(kCannon+32),<(kCannon+36),<(kCannon+40),<(kCannon+44))
			dta b(>(kCannon+24),>(kCannon+28),>(kCannon+32),>(kCannon+36),>(kCannon+40),>(kCannon+44))
tabKol2		dta b(<(bazyCannon0a),<(bazyCannon1a),<(bazyCannon2a),<(bazyCannon3a),<(bazyCannon4a),<(bazyCannon5a))			
			dta b(>(bazyCannon0a),>(bazyCannon1a),>(bazyCannon2a),>(bazyCannon3a),>(bazyCannon4a),>(bazyCannon5a))
			

			
bazaB1		dta b(0,0,0,128+0,128+0,0,0,0)
			dta b(0,0,2,8+0,8+0,2,0,0)
			dta b(128+5,8+5,7,7,7,7,8+1,128+1)
			dta b(8+5,8+5,7,7,7,7,8+1,8+1)
			dta b(0,0,0,6,6,0,0,0)
			dta b(8+4,8+4,7,7,7,7,8+2,8+2)
			dta b(128+4,8+4,7,7,7,7,8+2,128+2)
			dta b(0,0,3,8+3,8+3,3,0,0)
			dta b(0,0,0,128+3,128+3,0,0,0)
			
bazaB2		dta b(0,0,0,128+3,128+3,0,0,0)
			dta b(0,0,3,8+3,8+3,3,0,0)
			dta b(128+2,8+2,7,7,7,7,8+4,128+4)
			dta b(8+2,8+2,7,7,7,7,8+4,8+4)
			dta b(0,0,0,6,6,0,0,0)
			dta b(8+1,8+1,7,7,7,7,8+5,8+5)
			dta b(128+1,8+1,7,7,7,7,8+5,128+5)
			dta b(0,0,2,8+2,8+2,2,0,0)
			dta b(0,0,0,128+0,128+0,0,0,0)	

dzialkoBX	dta b(3,6,6,3,0,0,3,3)
dzialkoBY	dta b(0,2,5,7,5,2,2,5)
			
kolBazaB	equ *
			asl @
			asl @
			asl @
			adc pom0b
			tay
			lda bazaB1,y
			bne @+
			rts
			
@			cmp #7
			bne @+
			
			mva #0 strzal,x		;trafiono tylko w baze
			rts
			
@			cmp #6
			bcs @+2
			
			ldy strzalKierunek,x
			beq klbb1
			jmp @+		;blokuj strzal pionowy i po skosie

klbb1		tay
			lda strzalYbit,x		;gorny lewy rog
			lsr
			cmp bazaAbit-2,y
			beq @+1
			
@			mva #0 strzal,x
@			rts
			
@			cmp #6
			bne @+
				
			mva #0 strzal,x
			lda czyJadroB
			beq @-1
			ldy pom0a
			mva #255 bazyRodzaj-1,y
			jmp usunBazeB
			
@			sta pom0c
			and #%111
			tay
			sty pom0e		;numer dzialka
			lda tabKol0,y
			sta pom0d		;bit dzialka
			ldy pom0a	;indeks bazy
			and bazyStan-1,y		;czy dzialo jest zestrzelone
			beq @+2
			
			;trafiono dzialko
			mva #0 strzal,x
			lda bazyStan-1,y
			eor pom0d
			sta bazyStan-1,y
			bne @+
			
			lda #$20
			jsr dodajPunkty
			jmp usunBazeB1
			
@			ldx pom0e		;nr dzialka
			lda tabKol1+12,x		;adres ksztaltu po trafieniu
			ora #3
			sta pom4
			lda tabKol1+18,x
			sta pom4+1
			
			lda tabKol2,x		;cannonX
			sta pom
			lda tabKol2+6,x
			sta pom+1
			
			lda bazyX-1,y
			clc
			adc dzialkoBX,x
			pha
			lda bazyY-1,y
			adc dzialkoBY,x
			tay
			pla
			jsr dodajWybuch
			
	
			ldy pom0a
			dey
			mva #3 pom0f
			ldx #0
			clc
@			equ *
			lda (pom4,x)
			sta (pom),y
			;clc
			lda pom
			adc #maxBaz
			sta pom
			dec pom4
	
			dec pom0f
			bpl @-
			
			lda #$20
			jsr dodajPunkty
			
			mva #7*2 sfx_dzialko
			
			rts
		
@			lda pom0c
			bpl @+
			rts

@			mva #0 strzal,x	

			rts
			
;usuwa baze numer w Y i dodaje wybuchy (powiekszonuy o 1)
usunBazeB	equ *
			lda #$50			;bonus za trafienie w jądro bazy
			jsr dodajPunkty

usunBazeB1	jsr eorBazaRadar		;bez bonus
			lda #$75
			jsr dodajPunkty
			lda #$75
			jsr dodajPunkty
		
			mva #255 bazyRodzaj-1,y
			inc zbiteBazy
			
			ldx bazyRakieta-1,y
			bmi @+
			
			mva #255 bazyRakieta-1,y
			mva #0 rakietyStan,x
			sta rakietyMove,x
			
@			lda bazyY-1,y
			sta pom4
			lda bazyX-1,y
			sta pom4+1
			
			ldx #7
@			clc
			lda pom4
			adc dzialkoBY,x
			tay
			lda pom4+1
			adc dzialkoBX,x
			jsr dodajWybuch
			dex
			bpl @-
			
			jsr zmniejszKondycja
			
			mva #8*2 sfx_wybuch
			mva #14 waitWybuch
			rts
		
			