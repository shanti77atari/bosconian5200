
;poziom trudności
spy_from_level			equ 3		;od którego poziomu pojawia się spy
formation_from_level	equ 4		;od którego poziomu pojawia się formacja
formation_speedUp_level1	equ 6		;od którego poziomu przyspiesza formacja
formation_speedUp_level2	equ 12		;max speed formacji
formation_speedUp_level3	equ 18
formation_speedUp_level4	equ 24

enemy_show_speed2		equ 2		;od którego poziomu szybciej pojawiają sie przeciwnicy
enemy_show_speed3		equ 9		;od którego poziomu szybciej pojawiają sie przeciwnicy
enemy_show_speed4		equ 17		;od którego poziomu szybciej pojawiają sie przeciwnicy
enemy_show_speed5		equ 25		;od którego poziomu szybciej pojawiają sie przeciwnicy
enemy_show_speed6		equ 35

formSpy_show_speed2		equ 6		;od którego poziomu szybciej pojawia się formacja i spy
formSpy_show_speed3		equ 11		;od którego poziomu szybciej pojawia sie formacja i spy
formSpy_show_speed4		equ 37
show_6enemy				equ 25		;od którego poziomu pojawia sie dodatkowy przeciwnik podczas formacji

timeLevel1_up			equ 8
timeLevel2_up			equ 16		;od którego poziomu zmieniają się czasy condition
timeLevel3_up			equ 39
timeLevel4_up			equ 60

//może tylko 2 poziomy szybkosci obrotu?
fast_rotate1			equ 19		;od którego leveu przyspiesza rotacja
fast_rotate2			equ 21
fast_rotate3			equ 35
fast_rotate4			equ 54

ilePociskow4			equ 12		;od którego poziomu bedą 4 pociski
ilePociskow5			equ 24		;od którego poziomu bedzie 5 pocisków
cannonAngle1			equ 7		;od którego levelu zwieksza się kąt strzalu dzialek
cannonAngle2			equ 18
cannonMaxAngle			equ 32		;maksymalny kat

//może tylko 2 poziomy predkosci?
enemy_speedUp_level1	equ 6		;kiedy przeciwnicy przyspieszają
enemy_speedUp_level2	equ 17
enemy_speedUp_level3	equ 28
enemy_speedUp_level4	equ 42		;max speed

spy_speedUp1			equ 15
spy_speedUp2			equ 31
spy_speedUp3			equ 52



levelAdr		dta a(level1)	;adresy zapisanych leveli
			dta a(level2)
			dta a(level3)
			dta a(level4)
			dta a(level5)
			dta a(level6)
			dta a(level7)
			dta a(level8)
			dta a(level9)
			dta a(level10)
			dta a(level11)
			dta a(level12)
			dta a(level13)
			dta a(level14)
			dta a(level15)
			dta a(level16)
			dta a(level17)
			dta a(level18)
			dta a(level19)
			dta a(level20)
			dta a(level21)
			dta a(level22) 	
			dta a(level23)
			dta a(level24)
			dta a(level25)
			dta a(level26)
			dta a(level27)
			dta a(level28)
			dta a(level29)
			dta a(level30)
			dta a(level31)
			dta a(level32)

openTab	dta b(255,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170)
closeTab dta b(30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180)

radarBazy1	dta b(128,64,32,16,8,4,2,1,0,0,0,0)   ;pozycja X bazy na radarze sprit3
radarBazy2	dta b(0,0,0,0,0,0,0,0,32,16,8,4)		;pociski 3 i 2	

spyScoreTab	dta b($20,$30,$40)

tablives		dta b(179,189,199)
			//dta b(170,191,201)		;chyba nieuzywane
			


;tabela kolorow
conditionC	equ *
			dta b(kolorGreen,kolorYellow,kolorRed)

;1 duszek
condition1	equ * ;24b
		dta b(%11110010)		;green
		:3 dta b(%11101110)
		:2 dta b(%11101010)
		dta b(%11100010)
		dta b(0)

		   dta b(%10101000)		;yellow
		:2 dta b(%10101011)
		   dta b(%10001001)
		:2 dta b(%11011011)
		   dta b(%11011000)
		dta b(0)
		
		dta b(%11001100)		;red
		:2 dta b(%11010101)
		dta b(%11001100)
		:2 dta b(%11010101)
		dta b(%11010100)
		dta b(0)

;2 duszek
condition2	equ *
		dta b(%01100010)	;green
		:2 dta b(%10101110)
		dta b(%01100110)
		:2 dta b(%10101110)
		dta b(%10100010)
		dta b(0)
		
		:6 dta b(%10111011)	;yellow
		   dta b(%10001000)
		dta b(0)
	
		dta b(%01001111)		;red
		:5 dta b(%11010111)
		dta b(%01001111)
		dta b(0)
		
;3duszek
condition3	equ *
		dta b(%00100111)		;green
		:2 dta b(%11101011)
		dta b(%01101011)
		:2 dta b(%11101011)
		dta b(%00101011)
		dta b(0)
		
		   dta b(%11001010)		;yellow
		:3 dta b(%10101010)
		:2 dta b(%10101000)
		   dta b(%10011010)
		dta b(0)
		
		:3 dta b(%11001100)			;red
		dta b(%11011101)
		dta b(255)
		:2 dta b(%11011101)
		dta b(0)
		
nap_form2	equ *
	:3 dta b(0)		; strzala w gore
	:2 dta b(%00010000)
	:2 dta b(0)
	:2 dta b(%00101000)
	:2 dta b(0)
	:2 dta b(%01000100)
	:3 dta b(0)

	dta b(0)				;linia
	:2 dta b(%00010000)
	dta b(0)
	:2 dta b(%00010000)
	dta b(0)
	:2 dta b(%00010000)
	dta b(0)
	:2 dta b(%00010000)
	dta b(0)
	:2 dta b(%00010000)
	dta b(0)

	:3 dta b(0)
	dta b(%01000100)		;celownik ,kostka 5
	dta b(%01000100)
	:2 dta b(0)
	dta b(%00010000)
	dta b(%00010000)
	:2 dta b(0)
	dta b(%01000100)
	dta b(%01000100)
	:3 dta b(0)
	
	:3 dta b(0)		;krzyzyk
	dta b(%00010000)
	dta b(%00010000)
	:2 dta b(0)
	dta b(%10010010)
	dta b(%10010010)
	:2 dta b(0)
	dta b(%00010000)
	dta b(%00010000)
	:3 dta b(0)
	
statek_zapas	equ *	
	dta b(%00000000)
	dta b(%00010000)
	dta b(%00010000)
	dta b(%00010000)
	dta b(%00010000)
	dta b(%00111000)
	dta b(%00101000)
	dta b(%00101000)
	dta b(%10101010)
	dta b(%10101010)
	dta b(%11111110)
	dta b(%11111110)
	dta b(%11010110)
	dta b(%10010010)
	dta b(%00101000)
	dta b(%00101000)	
	
nap_1up	equ *
	dta b(%00100101)  ;player1
	dta b(%01100101)
	dta b(%00100101)
	dta b(%00100101)
	dta b(%00100101)
	dta b(%00100101)
	dta b(%01110110)
	
	dta b(%01110000)    ;player 2
	dta b(%01010000)
	dta b(%01010000)
	dta b(%01110000)
	dta b(%01000000)
	dta b(%01000000)
	dta b(%01000000)	

	
	
	
nap_form1	equ *
	dta b(%00110110)	;pociski
	dta b(%00100101)
	dta b(%00110101)
	:2 dta b(%00100101)
	dta b(0,0)
	:2 dta b(%00000101)
	dta b(%00000110)
	:2 dta b(%00000101)
	
	dta b(%01001100)	;1duszek
	dta b(%10101010)
	dta b(%10101100)
	dta b(%10101010)
	dta b(%01001010)
	dta b(0,0,0,0,0,0,0)
	
	dta b(%10100100)	;2duszek
	dta b(%11101010)
	dta b(%10101110)
	:2 dta b(%10101010)
	dta b(0,0)
	dta b(%01001101)
	dta b(%10100100)
	dta b(%11100100)
	:2 dta b(%10100100)
	
	dta b(%11010010)	;3duszek
	:3 dta b(%01010101)
	dta b(%01010010)
	dta b(0,0)
	dta b(%10010011)
	dta b(%10101010)
	dta b(%10111010)
	dta b(%10101010)
	dta b(%10101011)

	
nap_condition	equ *
	   dta b(%00110110)	;pociski
	:5 dta b(%00100101)
	   dta b(%00110101)
	
	   dta b(%00110110)	;1duszek
	:5 dta b(%01010101)
	   dta b(%01100101)
	
	   dta b(%01100101)	;3duszek
	:5 dta b(%01010100)
	   dta b(%01100100)	
	
	   dta b(%11010011)	;3duszek
	:5 dta b(%10010101)
	   dta b(%10010110)
	   
nap_hiscore	equ *
	dta b(%11100111)    ;pociski
	dta b(%11010100)
	dta b(%11010100)
	dta b(%11100110)
	dta b(%11010100)
	dta b(%11010100)
	dta b(%11010111)
	
	dta b(%01010111)   ;player1
	dta b(%01010010)
	dta b(%01010010)
	dta b(%01110010)
	dta b(%01010010)
	dta b(%01010010)
	dta b(%01010111)
	
	dta b(%00001100)   ;player2
	dta b(%00010001)
	dta b(%00010001)
	dta b(%11011101)
	dta b(%00000101)
	dta b(%00000101)
	dta b(%00011000)
	
	dta b(%11001101)   ;player3
	dta b(%00010101)
	dta b(%00010101)
	dta b(%00010101)
	dta b(%00010101)
	dta b(%00010101)
	dta b(%11011001)


statekm_zapas	equ *
	:4 dta b(%00101010)
	:2 dta b(0)
	dta b(%00111111)
	dta b(0)
	:2 dta b(%00101010)
	
nap_round	equ *
	dta b(%00000110)	;pociski
	dta b(%00000101)
	dta b(%00000101)
	dta b(%00000101)
	dta b(%00000101)
	dta b(%00000101)
	dta b(%00000110)	
	
	dta b(%01100011)   ;1 duszek
	dta b(%01010101)
	dta b(%01010101)
	dta b(%01100101)
	dta b(%01010101)
	dta b(%01010101)
	dta b(%01010110)
	
	dta b(%01010110)  ;2 duszek
	dta b(%01010101)
	dta b(%01010101)
	dta b(%01010101)
	dta b(%01010101)
	dta b(%01010101)
	dta b(%01100101)
	

nap_0	equ *
	dta b(%00000111)   ;0 w pociskach
	dta b(%00000101)
	dta b(%00000101)
	dta b(%00000101)
	dta b(%00000101)
	dta b(%00000101)
	dta b(%00000111)	

	
;dodaje punkty
dodajPunkty	equ *
		cmp #$ff		;trafiony spy punkty od 200 do 400
		bne dpun1
		lda random
		and #%11
		sty pom0g
		tay
		beq @+
		dey
@		lda spyScoreTab,y
		sty spyScore
		ldy pom0g	

dpun1	sed
		clc
		adc plusScore
		sta plusScore
		lda plusScore+1
		adc #0
		sta plusScore+1
		cld
		rts	

		
initPoziom	equ *
		mva #12 movX
		mva #0 movY
		sta licznikSpyScore
		mva #1 sJoy		;zeruj flage trafienia statku
		jsr rstatekUp			;BRAK PROCEDURY
		lda #255
		:5 sta pociski+#
		
		sta sfx_extra
		sta sfx_rakieta
		sta sfx_effect
		sta sfx_dzialko
		sta sfx_asteroid
		sta sfx_bomba
		sta sfx_wybuch
		sta sfx_dead
		sta sfx_antyair
		sta sfx_enemyHit
		
		mva #0 liczbaPociskow
		sta movY
		sta trafienie
		sta sfxlicznik1
		sta extraLicznik
		:4 sta strzal+#
		sta rodzajSpeech
		sta mwybuchystop
		sta mwybuchystart
		sta wybuchystart
		sta wybuchystop
		sta plusScore
		sta plusScore+1
		sta nobanner
	
		
	
		sta max_Enemy
		sta ile_enemy
		sta jestSpy
		sta spyScoreRysuj
		sta formacja_stan
		sta formacja_radar
		
		ldy #5
@		lda #0
		sta enemy,y
		sta enemyWybuch,y
		lda #1
		sta enemyEkran,y
		dey
		bpl @-
		
		ldy #7					;wyczysc rakiety
		lda #0
@		sta rakietyStan,y
		sta rakietyMove,y
		dey
		bpl @-
		
		mva #12 startMapy
		mva #opoznienieCondition punkty3
		mva #kondycja_start kondycja
		ldy #0
		jsr setCondition
		jsr piszCondition
		
		mva #4 opozCoreA
		sta opozCoreB
		mva #2 liczCoreA
		sta opozCoreB
		
		
;poziom trudności
;kąt strzału działek
		ldx #$0c
		lda poziom
		cmp #cannonAngle1
		bcc @+
		ldx #$0e
		cmp #cannonAngle2
		bcc @+
		ldx #$0f
@		stx kat1
		txa
		:4 asl
		sta kat2
		
		lda poziom				;maksymalny kat
		cmp #cannonMaxAngle
		bcc @+
		lda #255
		sta kat1
		sta kat2
@		equ *		
		
;predkosc przeciwników
		ldx #0*32
		lda poziom
		cmp #enemy_speedUp_level1
		bcc @+
		ldx #1*32
		cmp #enemy_speedUp_level2
		bcc @+
		ldx #2*32
		cmp #enemy_speedUp_level3
		bcc @+
		ldx #3*32
		cmp #enemy_speedUp_level4
		bcc @+
		ldx #4*32
@		stx speedEnemy0		;poczatkowa predkośc enemy	

;predkosc spy
		ldx #3*32
		lda poziom
		cmp #spy_speedUp1
		bcc @+
		ldx #4*32
		cmp #spy_speedUp2
		ldx #5*32
		cmp #spy_speedUp3
		ldx #6*32
@		stx spySpeed

;szybkosć pojawiania sie enemy zaleznie od poziomu
		ldx #40				
		lda poziom
		cmp #enemy_show_speed2
		bcc @+
		ldx #30
		cmp #enemy_show_speed3
		bcc @+
		ldx #28
		cmp #enemy_show_speed4
		bcc @+
		ldx #26
		cmp #enemy_show_speed5
		bcc @+
		ldx #24
		cmp #enemy_show_speed6
		bcc @+
		ldx #22
@		stx opoz_denemy
		stx opoz_denemy1
		stx dlicz1
		
		ldx #30			;jak często pojawiają sie spy i formacja
		lda poziom
		cmp #formspy_show_speed2
		bcc @+
		ldx #23
		cmp #formspy_show_speed3
		bcc @+
		ldx #17
		cmp #formspy_show_speed4
		bcc @+
		ldx #12
@		stx opoz_dlosuj
		stx losuj1
		
		ldx #0			;typu formacji tylko 0, 0 i 1 lub wszystkie
		lda poziom
		cmp #formation_from_level+3
		bcc @+
		ldx #%1
		cmp #formation_from_level+7
		bcc @+
		ldx #%11
@		stx formacja_maska

		ldx #3*32	;#64		;prędkośc formacji
		lda poziom
		cmp #formation_speedUp_level1
		bcc @+
		ldx #4*32
		cmp #formation_speedUp_level2
		bcc @+
		ldx #5*32		;szybko	
		cmp #formation_speedUp_level3
		bcc @+
		ldx #6*32
		cmp #formation_speedUp_level4
		bcc @+
		ldx #7*32
@		stx formacja_speed

		ldx #0			;czy podczas formacji maja pojawic sie dodatkowi przeciwnicy
		lda poziom
		cmp #show_6enemy
		bcc @+
		ldx #1
@		stx czy_6enemy

		ldx #0
		lda poziom
		cmp #timeLevel1_up
		bcc @+
		inx
		cmp #timeLevel2_up
		bcc @+
		inx
		cmp #timeLevel3_up
		bcc @+
		inx
		cmp #timeLevel4_up
		bcc @+
		inx
@		stx timeLevel

;predkość rotacji enemy
		ldx poziom
		mva #11 rotate_speed1
		mva #9 rotate_speed2
		cpx #fast_rotate1
		bcc @+
		dec rotate_speed1
		cpx #fast_rotate2
		bcc @+
		dec rotate_speed2
		cpx #fast_rotate3
		bcc @+
		dec rotate_speed1	
		cpx #fast_rotate4
		bcc @+
		dec rotate_speed2		
@		mva rotate_speed1 rotate_speed1d
		mva rotate_speed2 rotate_speed2d
		
;maksymalna liczba pociskow		
		ldx #2
		lda poziom
		cmp #ilePociskow4
		bcc @+
		inx
		cmp #ilePociskow5
		bcc @+
		inx
@		stx maxPociskow
		inx
		stx maxPociskow1
		
;szybkosc strzelania dzialka
		ldx #20
		lda poziom
		cmp #12
		bcc @+
		ldx #15
		cmp #15
		bcc @+
		ldx #13
		
@		stx opoznieniePocisku
		
		rts
		
			
wczytajLevel	equ *
			mva #0 zbiteBazy
			sta pom0	;liczba baz
			lda poziom
			sec
			sbc #1
			and #31		;zapętlamy levele		
					
			asl @
			tax
			lda levelAdr,x
			sta pom
			lda levelAdr+1,x
			sta pom+1
			
			ldy #0
			lda (pom),y		;reset pozycji startowych
			and #%01111111
			
			ldx poziom		
			cpx #33
			bcc obrpoz3
			eor #255			;po zapetleniu obroc pozycje x startowa
			adc #97
obrpoz3		equ *			
			
			sta startX
			sta posX
			lda (pom),y
			and #128
			ldx poziom
			cpx #maxPoziomow+1
			bcc *+4
			lda #128			; zawsze bedą rakiety, jesli poziom>32
			sta czyRakiety
			iny
			lda (pom),y
			sta startY
			sta posY
			iny
			lda (pom),y
			:4 lsr
			tax
			lda openTab,x
			sta czasOtwarcia
			lda (pom),y
			and #%00001111
			tax
			lda closeTab,x
			sta czasZamkniecia
			iny
			lda (pom),y
			and #%11110000
			ora #$0f
			
			sta COLPF0
			lda (pom),y
			:4 asl
			ora #$06
			sta COLPF2
			
			iny
			lda (pom),y
			sta bazyIle
			
			lda poziom				;jeśli zapętlenie poziomów to zwiększ poziom trudności
			cmp #33
			bcc @+1
			lda czasZamkniecia
			adc #4  ;c=1 -> +1
			sta czasZamkniecia
			lda czasOtwarcia
			cmp #255
			bne @+
			lda #50
@			sec
			sbc #5
			sta czasOtwarcia
@			equ *			
			
			jsr initPoziom
			
			jsr mute_rmt


			jsr initJadra
		
			lda #60+85		;wydlużenie dla pierwszego poziomu
			sta startMapy
			mva #1 muzyka	;wlacz muzyke startowa
			
			clc
			lda pom
			adc #5
			sta pom
			bcc @+
			inc pom+1
			
@			ldx #0
wcl2		ldy #0
			lda (pom),y
			and #128
			asl
			rol
			sta bazyRodzaj,x		;rodzaj obiektu, 255=koniec
			
			lda #%00111111		;stan bazy
			sta bazyStan,x
			lda #255
			sta bazyRakieta,x		;wyzeruj rakiety	
			lda (pom),y		;pozycja X
			and #127
			
			pha
			lda poziom 
			cmp #33
			bcc obrpoz1
			pla					;obracamy pozycje X bazy
			eor #255
			adc #120
			pha
obrpoz1		pla
			
			sta bazyX,x
			iny
			lda (pom),y		;pozycja Y
			sta bazyY,x
			clc
			lda pom
			adc #2
			sta pom
			bcc @+
			inc pom+1
			
@			lda #b
			sta bazyCannon0a,x
			sta bazyCannon1a,x
			sta bazyCannon2a,x
			sta bazyCannon3a,x
			sta bazyCannon4a,x
			sta bazyCannon5a,x
			lda #b+2
			sta bazyCannon0b,x
			sta bazyCannon1b,x
			sta bazyCannon2b,x
			sta bazyCannon3b,x
			sta bazyCannon4b,x
			sta bazyCannon5b,x
			lda #b+1
			sta bazyCannon0c,x
			sta bazyCannon1c,x
			sta bazyCannon2c,x
			sta bazyCannon3c,x
			sta bazyCannon4c,x
			sta bazyCannon5c,x
			lda #b+3
			sta bazyCannon0d,x
			sta bazyCannon1d,x
			sta bazyCannon2d,x
			sta bazyCannon3d,x
			sta bazyCannon4d,x
			sta bazyCannon5d,x
			
@			inx
			cpx bazyIle
			jcc wcl2	
			
//losowe obiekty ;)			
			ldx poziom			
			;mva #128 bombile
			lda #64
			cpx #10
			bcc @+
			lda #96
			cpx #20
			bcc @+
			lda #128
@			sta bombile

			ldx #0
			
@			lda random
			and #1
			sta bombRodzaj,x
			
@			lda random
			and #%01111110	
			sta bombX,x
			lda random
			and #%11111110
			sta bombY,x

			jsr sprawdz_bazy
			bne @-		;pozycja pod bazą, jeszcze raz
			jsr sprawdz_obiekty
			bne @-
			jsr sprawdz_start
			bne @-
			
			inx
			cpx bombile
			bcc @-1

			;mva #BANK0 PORTB	;wlacz podstawowy bank
			
			
//segregowanie obiektów			
@			ldx #0
			stx pom0
			inx
			
@			lda bombY-1,x
			cmp bombY,x
			bcc segr_next
			beq segr_rowne
			bcs segr_zamien
			//gdy rowne
segr_rowne			
			lda bombX-1,x
			cmp bombX,x
			bcc segr_next
			beq segr_next
			//zamiana
segr_zamien
			lda bombX-1,x
			ldy bombX,x
			sta bombX,x
			tya
			sta bombX-1,x
			lda bombY-1,x
			ldy bombY,x
			sta bombY,x
			tya
			sta bombY-1,x
			inc pom0
segr_next	
			inx
			cpx bombIle
			bcc @-
			lda pom0
			bne @-1			
			
			ldy bazyIle			;wyczysc rakiety w bazach
			lda #255
@			sta bazyRakieta-1,y
			dey
			bne @-
			
			
			jsr tabBazy
			jsr piszPoziom
			jmp tabBomby
			
sprawdz_bazy	
			ldy bazyIle
@			sec
			lda bazyX-1,y
			sbc bombX,x
			bcs *+6
			eor #255
			adc #1
			cmp #9
			bcs @+
			
			sec
			lda bazyY-1,y
			sbc bombY,x
			bcs *+6
			eor #255
			adc #1
			cmp #9
			bcs @+
			
			lda #1		;na bazie
			rts
			
@			dey
			bne @-1
			
			lda #0		;ok
			rts
			
sprawdz_obiekty
			txa
			bne *+3
			rts
			tay
			dey
			
@			lda bombY,x
			sec
			sbc bombY,y
			bcs *+6
			eor #255
			adc #1
			cmp #3
			bcs @+
			
			lda bombX,x
			sec
			sbc bombX,y
			bcs *+6
			eor #255
			adc #1
			cmp #3
			bcs @+
			
			lda #1		;pokrywa się z inną bombą
			rts
			
@			dey
			bpl @-1
spr_ok			
			lda #0		;ok
			rts
			
sprawdz_start	
			clc
			lda startx
			adc #15
			sec
			sbc bombX,x
			bcs @+
			eor #255
			adc #1
@			cmp #8
			bcs spr_ok
			
@			clc
			lda startY
			adc #14
			sec
			sbc bombY,x
			bcs @+
			eor #255
			adc #1
@			cmp #8
			bcs spr_ok
			
			lda #1		;za blisko startu
			rts			



tabBomby	equ *
			ldx bombIle
			bne @+
			rts
			
@			lda bombY-1,x
			clc
			adc #1
			tay
			stx pom0			;nr bomby w pom0
			
			cpx bombIle
			bne *+4
			sty pom0b			;koncowy indeks, ustalany na poczatku
			
			ldx #28+2		;licznik 28+wysokoscBomby	
			
			lda pom0				;wypelniaj pola wartoscia danej bazy
@			sta tabBomb1,y
			dey
			cpy pom0b
			beq @+
			dex
			bne @-
			
@			tax
			dex
			bne @-2			;next bomba

;ostatnia bomba
			ldx #1
			
@			lda bombY-1,x		;pozycja startowa Ybomby-28
			sec
			sbc #28
			tay
			
			cpx #1
			bne *+4
			sty pom0b			;koncowy indeks
			
			stx pom0			;nr bomby
			
			ldx #28+2				;licznik 28+wysokość bomby
			
			lda pom0
@			sta tabBomb2,y
			iny
			cpy pom0b
			beq @+			;next
			dex
			bne @-
			
@			tax
			inx
			cpx bombIle
			bcc @-2
			beq @-2

			rts
	
tabBazy		lda #255
			ldx #0
@			sta tabBazy1,x
			sta tabBazy2,x
			sta tabBomb1,x
			sta tabBomb2,x
			dex
			bne @-
			
			
			ldx bazyIle
			
@			lda bazyRodzaj-1,x		;pozycja startowa= pozycja bazy +wysokoscBazy-1
			sta pom0a
			clc
			adc #7
			adc bazyY-1,x
			tay
			stx pom0			;nr bazy w pom0
			
			cpx bazyIle
			bne *+4
			sty pom0b			;koncowy indeks
			
			lda #28+8		;licznik 28+wysokoscBazy
			clc
			adc pom0a
			tax
			
			
			lda pom0				;wypelniaj pola wartoscia danej bazy
@			sta tabBazy1,y
			dey
			cpy pom0b
			beq @+
			dex
			bne @-
			
@			tax
			dex
			bne @-2			;next baza
			
			
;ostatnia baza
			ldx #1
			
@			lda bazyY-1,x		;pozycja startowa Ybazy-28
			sec
			sbc #28
			tay
			
			cpx #1
			bne *+4
			sty pom0b			;koncowy indeks
			
			stx pom0			;nr bazy
			
			
			lda bazyRodzaj-1,x		;licznik 28+wysokoscbazy
			clc
			adc #8+28
			tax
			
			lda pom0
@			sta tabBazy2,y
			iny
			cpy pom0b
			beq @+			;next
			dex
			bne @-
			
@			tax
			inx
			cpx bazyIle
			bcc @-2
			beq @-2
			
			rts

			
			
;pokazuje/ukrywa baze na radarze  , nr bazy w Y
eorBazaRadar	equ *
			lda bazyX-1,y
			lsr @
			lsr @
			lsr @
			sec
			sbc #2
			bpl *+4
			lda #0
			tax
			lda radarBazy1,x
			sta pom
			lda radarBazy2,x
			sta pom+1
			ldx bazyY-1,y
			lda tabDiv100,x
			tax
			lda sprites+$600+startWyniki+84,x
			eor pom
			sta sprites+$600+startWyniki+84,x
			lda sprites+$600+startWyniki+84+1,x
			eor pom
			sta sprites+$600+startWyniki+84+1,x
			lda sprites+$600+startWyniki+84+2,x
			eor pom
			sta sprites+$600+startWyniki+84+2,x
			lda sprites+$300+startWyniki+84,x
			eor pom+1
			sta sprites+$300+startWyniki+84,x
			lda sprites+$300+startWyniki+84+1,x
			eor pom+1
			sta sprites+$300+startWyniki+84+1,x
			lda sprites+$300+startWyniki+84+2,x
			eor pom+1
			sta sprites+$300+startWyniki+84+2,x
			rts
			
;pokazuje bazy na radarze	(wszystkie)		
pokazBazyRadar	equ	*
			lda #0
			ldy #100		;czyszczenie baz na radarze
@			sta sprites+$600+startWyniki+84,y
			sta sprites+$300+startWyniki+84,y
			dey
			bne @-
			
			ldy bazyIle
			
@			jsr eorBazaRadar
			
			dey
			bne @-
			
			rts			

;rysyje polozenie statku na radarze
radar	equ *		
		lda rads1	
		bmi @+		;<0 nic nie trzeba zmazywac
		
		ldy rads		;wymaz w poprzedniej pozycji
		lda sprites+$300+startWyniki+84,y
		and #%11111100
		sta sprites+$300+startWyniki+84,y
		lda sprites+$300+startWyniki+84+1,y
		and #%11111100
		sta sprites+$300+startWyniki+84+1,y
		
		lda rads1
		beq @+		;wszystko juz zmazane
		lda sprites+$300+startWyniki+84+2,y		;dodatkowe 2 punkty zmazujemy po formacji
		and #%11111100
		sta sprites+$300+startWyniki+84+2,y

@		equ *		
		inc mryganieRadarX
		lda mryganieRadarX
		and #%100
		beq @+		;puste lub formacja
		
		lda posY			;narysuj w nowej
		clc
		adc #13
		tax
		ldy tabDiv100,x
		
		sty rads
		lda sprites+$300+startWyniki+84,y
		ora #2 
		sta sprites+$300+startWyniki+84,y
		lda sprites+$300+startWyniki+84+1,y
		ora #2
		sta sprites+$300+startWyniki+84+1,y
		
		lda posX  ;pozycja X dzielimy przez 4
		clc
		adc #15
		and #127
		lsr @
		lsr @
		clc
		adc #pozWyniki-1
		sta RadarX1
		mva #0 rads1		;do zmazania bedzie statek
		
		rts	
		
@		equ *
		ldy formacja_radar
		bne @+
		sty RadarX1		;y=0 poza ekranem
		dey
		sty rads1		;y=-1 nic nie będzie do zmazania
		rts
		
@		lda mryganieRadarX
		and #%10
		bne @+
		rts
@		ldx enemyY+5
		ldy tabDiv100,x
		
		sty rads
		lda sprites+$300+startWyniki+84+2,y
		ora #3 
		sta sprites+$300+startWyniki+84+2,y
		lda sprites+$300+startWyniki+84,y
		ora #3
		sta sprites+$300+startWyniki+84,y
		lda sprites+$300+startWyniki+84+1,y
		ora #3 
		sta sprites+$300+startWyniki+84+1,y
		
		lda enemyX+5
		lsr
		lsr
		adc #pozWyniki-1
		sta RadarX1
		mva #1 rads1		;do zmazania formacja
		
		rts



;condition w y 0=green,1=yellow,2=red
setCondition	equ *
		sty kondycja_stan
	
		lda formacja_stan
		beq @+
		cmp #5
		beq @+
		rts
	
@		lda conditionC,y
		sta conditionColor
		sta conditionColor1
		tya
		asl @
		asl @
		asl @
		tay
		
		lda #255
		.rept 4, #
		sta sprites+$400+startWyniki+60+:1
		sta sprites+$400+startWyniki+60+11+:1
		sta sprites+$500+startWyniki+60+:1
		sta sprites+$500+startWyniki+60+11+:1
		sta sprites+$600+startWyniki+60+:1
		sta sprites+$600+startWyniki+60+11+:1
		.endr
		lda #63
		.rept 4, #
		sta sprites+$300+startWyniki+60+:1
		sta sprites+$300+startWyniki+60+11+:1
		.endr
		
		
		:7 sta sprites+$300+startWyniki+64+#
		
		
		.rept 7, #
		lda condition1+:1,y
		sta sprites+$400+startWyniki+64+:1
		lda condition2+:1,y
		sta sprites+$500+startWyniki+64+:1
		lda condition3+:1,y
		sta sprites+$600+startWyniki+64+:1
		.endr
		
		
		mva #0 sprites+$400+startWyniki+75
		sta sprites+$400+startWyniki+76

		rts	

tab5	dta b(10,5,0)		

;Wyswietlamy liczbe zyc
printLives	equ *
		lda lives
		cmp #4
		bcc @+
		lda #3		;maksymalnie wyswietlamy 3 statki
@		sta pom0
		
		ldx #2
@		ldy tab5,x
		lda tablives,x
		cpx pom0
		bcc @+
		lda #0
@		sta poz2lives,y
		beq @+
		clc
		adc #2
@		sta poz2mlives,y
		dex
		bpl @-2
				
		rts


		
;czy ukonczono level
czyNowyLevel	equ *
		lda trafienie
		beq *+3
		rts
		
		lda zbiteBazy		;czy zbito juz wszystkie bazy
		cmp bazyIle
		beq @+ 
		rts
@		lda nobanner
		cmp #2
		bcc @+
		
		lda #0		;wylacz przerwanie
		sta IRQEN
		sta sirq
		sta AUDF4 

@		lda formacja_stan
		beq @+
		mva #0 formacja_stan
		sta formacja_radar
		jsr piszCondition
		ldy kondycja_stan		;poprzednia kondycja
		jsr setCondition
		
@		mva #9 startMapy	
@		lda waitWybuch
		bmi @+1
		cmp #14
		bne @+
		
		
		jsr exploAllEnemy
		ldy sJoy
		mva #0 sJoy
		sta licznikStrzal
		jsr printShip1
		lda conditionColor		;jeśli 0 to jest red condition , trzeba narysować
		bne @+
		lda conditionC+2
		sta conditionColor
		sta conditionColor1	 
		
@		dec waitWybuch
		rts

@		inc poziom			;to nastepny poziom

		mva #0  _vbsnd4
		
		lda poziom		;jeśli poziom = 161 to ustaw 129 , zapetlamy
		cmp #161
		bcc skpoz2
		lda #129
		sta poziom
skpoz2	equ *

		jsr wczytajLevel
		
		mva #2 muzyka
		mva #60 startMapy
		mva #54 licznikStrzal	;opoznienie dzwieku silnika
		jsr pokazBazyRadar
		mva #1 zegar
		pla			;zdejmij po jsr
		pla
		jsr waitvbl
		mva movy vscrol
		mva movx hscrol		
		jmp poczatek

graj_sampla		equ *
		lda zegar
@		cmp zegar
		beq @-
		
		lda #0
		sta COLPM0
		sta COLPM1
		sta COLPM2
		sta COLPM3
		
		sta kanal1
		sta _vbsnd2
		sta kanal2
		sta _vbsnd4
		sta kanal3
		sta _vbsnd6
		mva #1 sfx
		
		mwa #blastoff_wav sam		;poczatek sampla
		
		jsr waitvbl
		mva #%01000000 NMIEN
		mva #1 speech		;wlaczony sampel
		sta powtorz			;odtwarzaj 1x
		
		jsr schowaj_duszki
		lda #$3a
		sta COLPM0
		lda #$8a
		sta COLPM1
		lda #pozWyniki-1
		sta HPOSP0
		lda #pozWyniki-1+24
		sta HPOSP1
		lda #0
		sta AUDC1
		sta AUDC2
		sta AUDC3
		
		mva #0 HPOSP2
		mva #$d0 COLPM3
		
;przygotuj napis
		ldy #0
		ldx #0
		
		
@		stx pom0
		lda t_blastoff,x
		:3 asl
		tax
		
		
@		lda znakiBosc1,x
		sta sprites1+$430,y
		sta sprites1+$531,y
		iny
		lda #0
		sta sprites1+$430,y
		sta sprites1+$531,y
		iny
		inx
		txa
		and #7
		bne @-
		
		ldx pom0
		inx
		cpx #9
		bcc @-1
		
		
		lda #0
		ldx #14
@		sta sprites1+$400+119,x
		sta sprites1+$500+119+1,x
		dex
		dex
		bpl @-
		
		mwa #pok0 irqv		;nowy wektor przerwania
		
		mva #15 AUDF4		;jak czesto wywolujemy przerwanie, 64khz/16 = 4khz
		
		mva #0 IRQEN
		sta rodzajSpeech
		mva #4 sirq
		sta IRQEN
		mva #>znaki2 pom0
		
		ldx #12
@		lda zegar
		cmp zegar
		beq *-2
		
		txa
		eor #255
		clc
		adc #pozWyniki+12
		sta HPOSP0
		txa
		clc
		adc #pozWyniki+11
		sta HPOSP1
		dex
		bpl @-
		
		mva #$24 zegar
		tay
		asl
		
		
@		cpy zegar
		beq @+
		jsr mryg_bomb
		ldy zegar
		tya
		asl
		
@		sta COLPM0
		sta COLPM1
		clc
		adc #3
		
@		ldx sirq
		bne @-2
		
		mva #0 speech
		sta AUDF4
		
		lda zegar
@		cmp zegar
		beq @-
		
		mva #%11000000 NMIEN
		
		mva #0 COLPM3
		
		jsr pokaz_duszki
		lda #0
		tax
		tay
@		sta sprites1+$430,y
		sta sprites1+$531,y
		iny
		iny
		inx
		cpx #72
		bne @-
		
		mva #0 zegar
		
		rts 

mryg_bomb
		pha
		lda zegar
		and #1
		bne @+
		pla
		rts
@		equ *
.rept 32, #		
		lda znaki1+firstBombaChar*8+:1
		sta strz0
		lda znaki2+firstBombaChar*8+:1
		sta znaki1+firstBombaChar*8+:1
		lda strz0
		sta znaki2+firstBombaChar*8+:1
.endr		
		
mr_b1	equ *
		pla
		rts		

t_blastoff .he 02,04,01,06,07,00,05,03,03

;pisze napis CONDITION
piszCondition	equ *
@		ldx #6
@		lda nap_condition,x
		sta sprites+startWyniki+$300+48,x
		lda nap_condition+7,x
		sta sprites+startWyniki+$400+48,x
		lda nap_condition+14,x
		sta sprites+startWyniki+$500+48,x
		lda nap_condition+21,x
		sta sprites+startWyniki+$600+48,x
		dex
		bpl @-
		
		lda #0
		sta sprites+startWyniki+$300+47
		sta sprites+startWyniki+$400+47
		sta sprites+startWyniki+$500+47
		sta sprites+startWyniki+$600+47
		
		ldx #3
@		sta sprites+startWyniki+$300+55,x
		sta sprites+startWyniki+$500+55,x
		sta sprites+startWyniki+$600+55,x
		dex
		bpl @-
			
		rts
		
		
;formation Attack
pisz_formation	equ *		
		.rept 12, #
		lda nap_form1+:1
		sta sprites+startWyniki+$300+48-1+:1
		lda nap_form1+12+:1
		sta sprites+startWyniki+$400+48-1+:1
		lda nap_form1+24+:1
		sta sprites+startWyniki+$500+48-1+:1
		lda nap_form1+36+:1
		sta sprites+startWyniki+$600+48-1+:1
		.endr

		
		lda formacja_typ
		asl
		asl
		asl
		asl
		tay
		ldx #0
		stx sprites+startWyniki+$400+60
		stx sprites+startWyniki+$400+61
		stx sprites+startWyniki+$300+60
		stx sprites+startWyniki+$300+61
		stx sprites+startWyniki+$300+69
		stx sprites+startWyniki+$300+70
		stx sprites+startWyniki+$300+71
		stx sprites+startWyniki+$300+72
		stx sprites+startWyniki+$300+73
		stx sprites+startWyniki+$300+74
		stx sprites+startWyniki+$300+75
		
		.rept 16, #
		lda nap_form2-16+:1,y
		sta sprites+startWyniki+$400+62+:1
		.endr
		
		txa
		.rept 16, #
		sta sprites+startWyniki+$300+62+:1
		sta sprites+startWyniki+$500+60+:1
		sta sprites+startWyniki+$600+60+:1
		.endr
		
		rts

poprawlives1	equ *
	lda #0
	:7 sta obraz1+33+24*48+#
	:7 sta obraz1+33+25*48+#
	:7 sta obraz1+33+26*48+#
	
	rts
	
poprawlives2	equ *
	lda #0
	:7 sta obraz2+33+24*48+#
	:7 sta obraz2+33+25*48+#
	:7 sta obraz2+33+26*48+#
	
	rts	
	   
pisz_zycia	equ *
	ldx #15
@	lda statek_zapas,x
	sta sprites+startWyniki+$4c0,x
	sta sprites+startWyniki+$5c0,x
	sta sprites+startWyniki+$6c0,x
	dex
	bpl @-
	
	ldx #9
@	lda statekm_zapas,x
	sta sprites+startWyniki+$3c6,x
	dex
	bpl @-
	
	rts

czysc_duszki	equ *
	lda #0
	tax
@	sta sprites+$300,x
	sta sprites+$400,x
	sta sprites+$500,x
	sta sprites+$600,x
	sta sprites1+$300,x
	sta sprites1+$400,x
	sta sprites1+$500,x
	sta sprites1+$600,x
	dex
	bne @-
	rts	

pisz_panel	equ *
	ldx #6
@	lda nap_hiscore,x
	sta sprites+startWyniki+$300,x
	lda nap_hiscore+7,x
	sta sprites+startWyniki+$400,x
	lda nap_hiscore+14,x
	sta sprites+startWyniki+$500,x
	lda nap_hiscore+21,x
	sta sprites+startWyniki+$600,x
	lda nap_1up,x
	sta sprites+$421+1,x
	lda nap_1up+7,x
	sta sprites+$521+1,x
	lda nap_0,x
	sta sprites+$319,x
	sta sprites+$32A,x
	lda nap_round,x
	sta sprites+$3e9-3,x
	lda nap_round+7,x
	sta sprites+$4e9-3,x
	lda nap_round+14,x
	sta sprites+$5e9-3,x
	dex
	bpl @-

	rts

znakibosc1	
		:8 dta b(0)

		dta b(0)
		dta b(%00111000)
		dta b(%01101100)		;a
		dta b(%11000110)
		dta b(%11000110)
		dta b(%11111110)
		dta b(%11000110)
		dta b(%11000110)

		dta b(0)
		dta b(%11111100)		;b
		:2 dta b(%11000110)
		dta b(%11111100)
		:2 dta b(%11000110)
		dta b(%11111110)	

		dta b(0)
		dta b(%11111110)		;f
		:2 dta b(%11000000)
		dta b(%11111100)
		:3 dta b(%11000000)		
		
		dta b(0)
		:6 dta b(%11000000)	;l
		dta b(%11111100)
		
		dta b(0)	
		dta b(%01111100)
		:5 dta b(%11000110)		;o
		dta b(%01111100)

		dta b(0)
		dta b(%01111000)
		dta b(%11001100)
		dta b(%11000000)		;s
		dta b(%01111100)
		dta b(%00000110)
		dta b(%11000110)
		dta b(%01111100)
		
		dta b(0)
		dta b(%01111110)
		:6 dta b(%00011000)	;t