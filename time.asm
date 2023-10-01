
timeBonus	dta b(22),b(21),(20),b(20),b(19)

conYellow		dta b(16),b(14),b(12),b(10),b(10)
con1enemy		dta b(18),b(17),b(16),b(15),b(13)
con2enemy		dta b(33),b(30),b(28),b(27),b(26)
con3enemy		dta b(75),b(60),b(45),b(34),b(27)
spyend			dta b(137),b(127),b(120),b(117),b(112)
conred			dta b(150),b(140),b(134),b(128),b(124)
con45enemy		dta b(154),b(144),b(138),b(132),b(128)
conUpSpeed		dta b(240),b(240),b(240),b(230),b(230)

;zdarzenia czasowe
timeEvents	equ *
		dec punkty		;mryganie "1UP"
		bne @+
		mva #5 punkty
		lda kolor1up
		eor #kolor1ups
		sta kolor1up

		
@		equ *
		dec punkty1		;mryganie gwiazd
		bne @+
		mva #10 punkty1
		dec gwiazdyLicznik
		bpl @+
		mva #2 gwiazdyLicznik		
@		equ *	
		
		lda trafienie
		ora startMapy
		ora formacja_stan		;formacja_stan musi byc =0
		beq *+3
		rts
		
	
		ldx timeLevel		;poziom trudnosci
		dec punkty3
		jne kmryg
		mva #opoznienieCondition punkty3
		lda kondycja		;ustawiamy kondycje
		jeq kmryg1
		inc kondycja
		cmp #1
		bne @+
		mva #0 max_Enemy
		tay		;0
		mva speedEnemy0 speedEnemy
		jsr setCondition
		rts
		
@		cmp conYellow,x
		bne @+
		
		mva #1 nobanner
		sta rodzajSpeech
		sta speech
		mva #2 powtorz
		mva #<alive_wav sam
		sta sam2
		mva #>alive_wav sam+1
		sta sam2s
		
		rts
		
@		cmp con1enemy,x
		bne @+
		mvy #1 max_Enemy
		jmp setCondition
		
@		cmp con2enemy,x
		bne @+
		mva #2 max_Enemy
		rts
		
@		cmp con3enemy,x
		bne @+
		mva #3 max_Enemy
		rts
		
@		cmp conred,x
		bne @+	
		
		
		mva #1 nobanner
		sta speech
		lda #2
		sta powtorz
		sta rodzajSpeech
		mva #<conred_wav sam
		sta sam2
		mva #>conred_wav sam+1
		sta sam2s
	
		rts
		
@		cmp con45enemy,x
		bne @+
		ldy #2
		jsr setCondition
		mva #9 rotate_speed1
		mva #6 rotate_speed2
		mva #5 max_Enemy
		mva #8 opoz_denemy
		sta dlicz1
		rts
		
@		cmp conUpSpeed,x
		bne kmryg
		mva #7*32 speedEnemy
		mva #0 kondycja
		jmp kmryg1
		

kmryg		equ *
		
		lda kondycja				;mryganie
		beq kmryg1
		cmp con45enemy,x
		bcc @+	
kmryg1	lda formacja_stan
		bne @+
		dec punkty2
		bne @+
		mva #opoznienieRed punkty2
		lda conditionColor
		eor conditionC+2
		sta conditionColor
		sta conditionColor1
@		equ *

		rts
		
schowaj_duszki	equ *	
		lda #>SPRITES1
		sta PMBASE
		mva #$02 COLPM3		;szare tlo panelu
		
		mva #0 HPOSM0			;schowaj pociski
		:3 sta HPOSM1+#
		
		lda #pozWyniki+7		;kolor i pozycja duszka na panelu
		sta HPOSP2
		mva #1 SIZEP2
		
		lda #pozWyniki-1-68		;statek srodek 108
		sta HPOSP0
		sta HPOSP1
		mva #kolorLiczby COLPM0
		mva #kolorCzerwony COLPM1
		
		lda rodzajSpeech
		
@		cmp #3		;alarm!alarm!
		bcs sdu1
		
		jsr picAlarm
		jsr picEnemy

		
sdu1	cmp #4		;gameover
		bne sdu2
		
		jsr clrAlarm

		jmp picSkull
	
sdu2	cmp #3	;spy!
		bne sdu3
		
		jmp picSpy

				
sdu3	jmp picFormation

clrAlarm	equ *
		lda #0
		:27 sta sprites1+$630+#
		rts
		
picFormation	equ *
		.rept 79, #
		lda formationShape+:1
		sta sprites1+$670+:1
		.endr
		rts
picAlarm	equ *
		.rept 27, #
		lda alarmShape+:1
		sta sprites1+$630+:1
		.endr
		rts
		
picEnemy	equ *
		.rept 13, #
			lda enemyShape+:1
			sta sprites1+$670+:1*4
			sta sprites1+$670+:1*4+1
			sta sprites1+$670+:1*4+2
		.endr
		rts
		
picSkull	equ *
		.rept 71, #
		lda skullShape+:1
		sta sprites1+$660+:1
		.endr
		rts
		
picSpy		equ *
		.rept 51, #
		lda spyShape+:1
		sta sprites1+$680+:1
		.endr
		rts


spyShape	equ *
		:2 dta b(%00001000)
		dta b(0)
		dta b(%00001000)
		:2 dta b(%00011100)
		dta b(0)
		:3 dta b(%00111110)
		dta b(0)
		dta b(%00101010)
		:2 dta b(%01101011)
		dta b(0)
		:3 dta b(%01101011)
		dta b(0)
		:3 dta b(%01111111)
		dta b(0)
		:3 dta b(%01111111)
		dta b(0)
		:2 dta b(%01011101)
		dta b(%01001001)
		dta b(0)
		:3 dta b(%01001001)
		dta b(0)
		:3 dta b(%01001001)
		dta b(0)
		:3 dta b(%01001001)
		dta b(0)
		:3 dta b(%00001000)
		:5 dta b(0)
		
skullShape	equ *
		:2 dta b(%00011000)
		:2 dta b(%00111100)
		dta b(0)
		:3 dta b(%01111110)
		dta b(0)
		:3 dta b(%11111111)
		dta b(0)
		:3 dta b(%10011001)
		dta b(0)
		:2 dta b(%10011001)
		dta b(%11011011)
		dta b(0)
		:3 dta b(%11111111)
		dta b(0)
		:3 dta b(%11111111)
		dta b(0)
		:3 dta b(%01111110)
		dta b(0)
		dta b(%01111110)
		dta b(%00111100)
		dta b(%00100100)
		dta b(0)
		:3 dta b(%00100100)
		dta b(0)
		dta b(%00100100)
		dta b(%00111100)
		dta b(%00011000)
		dta b(0)
		:3 dta b(%00011000)
		dta b(0)
		:3 dta b(%01000010)
		dta b(0)
		:3 dta b(%11000011)
		dta b(0)
		:2 dta b(%00100100)
		:2 dta b(%00011000)
		:2 dta b(%00100100)
		dta b(0)
		:3 dta b(%11000011)
		dta b(0)
		:3 dta b(%01000010)
		
alarmShape	equ *
		:3 dta b(%00001000)
		:3 dta b(0)
		dta b(%01000001)
		:2 dta b(%01001001)
		dta b(0)
		:2 dta b(%00011100)
		dta b(0)
		:2 dta b(%00111110)
		dta b(0)
		:2 dta b(%00111110)
		dta b(0)
		:2 dta b(%00111110)
		dta b(%01000001)
		:5 dta b(%01111111)
		
enemyShape	equ *
		dta b(%00001000)
		dta b(%00011100)
		dta b(%00010100)
		dta b(%00110110)
		:2 dta b(%00111110)
		dta b(%01110111)
		:2 dta b(%01100011)
		:4 dta b(%01000001)
	
formationShape	equ	*
		:2 dta b(%00010000)
		:2 dta b(%00111000)
		:2 dta b(%00101000)
		:2 dta b(%01101100)
		:3 dta b(%01111100)
		:2 dta b(%11101110)
		:4 dta b(%11000110)
		:8 dta b(%10000010)
		dta b(0,0)
		:2 dta b(%00001000)
		:2 dta b(%00011100)
		:2 dta b(%00010100)
		:2 dta b(%00110110)
		:3 dta b(%00111110)
		:2 dta b(%01110111)
		:4 dta b(%01100011)
		:8 dta b(%01000001)
		dta b(0,0)
		:2 dta b(%00010000)
		:2 dta b(%00111000)
		:2 dta b(%00101000)
		:2 dta b(%01101100)
		:3 dta b(%01111100)
		:2 dta b(%11101110)
		:4 dta b(%11000110)
		:8 dta b(%10000010)
		
pokaz_duszki	equ *
		lda #>SPRITES
		sta PMBASE
		
		mva #0 SIZEP2
		mva #$0 COLPM3
		lda #pozWyniki
		sta HPOSP0 
		lda #pozWyniki+8
		sta HPOSP1

		lda #0		
		:105 sta sprites1+$660+#
		
		
		rts
		
;po zbiciu bazy zmniejsz kondycję o ustalona wartośc i ustaw odpowiedni stan kondycji (green,yellow,red)
zmniejszKondycja	equ *
		ldx timeLevel
		lda kondycja
		cmp conRed,x
		bcc zmKondycja1
		
		lda con2enemy,x
		sta kondycja
		mva speedEnemy0 speedEnemy	;=yellow po red
		mva opoz_denemy1 opoz_denemy
		mva rotate_speed1d rotate_speed1
		mva rotate_speed2d rotate_speed2
		mva opoz_dlosuj losuj1
		ldy #1
		jmp setCondition		;ustaw yellow

zmKondycja1	equ *	
		sec
		lda kondycja
		bne @+
		lda #255
@		ldx timeLevel
		sbc timeBonus,x
		beq @+	;jesli zero, lub <0 to ustaw kondycja_start
		bcs @+1	
@		lda #kondycja_start+1	
		sta kondycja
		rts

@		sta kondycja
		cmp conYellow,x
		bne zm1
		inc kondycja	;nie wlaczaj sampla
		rts				;=yellow
zm1		bcs @+
		
		mvy #0 max_Enemy		;<yellow, czyli green
		jmp setCondition		;ustaw green
		
@		cmp con1enemy,x
		bne *+3
		rts 
		bcs @+
		
		rts		;<con1enemy
		
@		cmp con2enemy,x
		bne *+3
		rts		;=con2enemy
		bcs @+
		
		mva #1 max_Enemy
		rts		;<con2enemy czyli = con1enemy
		
@		cmp con3enemy,x
		bne *+3
		rts
		bcs @+
		
		ldy #2
		sty max_Enemy	;<con3enemy, czyli con2enemy
		rts
		
@		rts
		