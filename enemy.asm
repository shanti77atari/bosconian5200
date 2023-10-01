			
fazaTab		dta b(6,8,8,8,8,8,8,8)
			dta b(4,6,7,7,7,7,8,7)
			dta b(4,6,6,7,7,7,8,7)
			dta b(4,6,6,6,7,7,8,7)
			dta b(4,5,5,6,6,7,7,7)
			dta b(4,5,5,5,5,5,6,7)
			dta b(4,6,5,5,5,5,5,6)
			
fazaTab1	dta b(14,2,10,6)

P2=1414
P5=2613	;P5=2236		
P6=1082
enemyTab2
.local speed0
d0=59
d1=d0*110/100	;+10%
d2=d0*105/100	
w1=d1*1000/P2
w2=d2*1000/P5
w3=d2*1000/P6
			dta b(0,w2,w1,w3,d0,w3,w1,w2,0,-w2,-w1,-w3,-d0,-w3,-w1,-w2)
			dta b(-d0,-w3,-w1,-w2,0,w2,w1,w3,d0,w3,w1,w2,0,-w2,-w1,-w3)
.endl			
.local speed1
d0=63
d1=d0*112/100	;+12%
d2=d0*106/100
w1=d1*1000/P2
w2=d2*1000/P5
w3=d2*1000/P6
			dta b(0,w2,w1,w3,d0,w3,w1,w2,0,-w2,-w1,-w3,-d0,-w3,-w1,-w2)
			dta b(-d0,-w3,-w1,-w2,0,w2,w1,w3,d0,w3,w1,w2,0,-w2,-w1,-w3)
.endl					
.local speed2
d0=68
d1=d0*115/100	;+15%
d2=d0*107/100
w1=d1*1000/P2
w2=d2*1000/P5
w3=d2*1000/P6
			dta b(0,w2,w1,w3,d0,w3,w1,w2,0,-w2,-w1,-w3,-d0,-w3,-w1,-w2)
			dta b(-d0,-w3,-w1,-w2,0,w2,w1,w3,d0,w3,w1,w2,0,-w2,-w1,-w3)
.endl	
.local speed3
d0=72
d1=d0*120/100	;+20%
d2=d0*110/100
w1=d1*1000/P2
w2=d2*1000/P5
w3=d2*1000/P6
			dta b(0,w2,w1,w3,d0,w3,w1,w2,0,-w2,-w1,-w3,-d0,-w3,-w1,-w2)
			dta b(-d0,-w3,-w1,-w2,0,w2,w1,w3,d0,w3,w1,w2,0,-w2,-w1,-w3)
.endl	
.local speed4
d0=78
d1=d0*125/100	;+25%
d2=d0*112/100
w1=d1*1000/P2
w2=d2*1000/P5
w3=d2*1000/P6
			dta b(0,w2,w1,w3,d0,w3,w1,w2,0,-w2,-w1,-w3,-d0,-w3,-w1,-w2)
			dta b(-d0,-w3,-w1,-w2,0,w2,w1,w3,d0,w3,w1,w2,0,-w2,-w1,-w3)
.endl	
.local speed5
d0=84
d1=d0*130/100	;+30%
d2=d0*115/100
w1=d1*1000/P2
w2=d2*1000/P5
w3=d2*1000/P6
			dta b(0,w2,w1,w3,d0,w3,w1,w2,0,-w2,-w1,-w3,-d0,-w3,-w1,-w2)
			dta b(-d0,-w3,-w1,-w2,0,w2,w1,w3,d0,w3,w1,w2,0,-w2,-w1,-w3)
.endl			
.local speed6
d0=88
d1=d0*135/100	;+35%
d2=d0*115/100
w1=d1*1000/P2
w2=d2*1000/P5
w3=d2*1000/P6
			dta b(0,w2,w1,w3,d0,w3,w1,w2,0,-w2,-w1,-w3,-d0,-w3,-w1,-w2)
			dta b(-d0,-w3,-w1,-w2,0,w2,w1,w3,d0,w3,w1,w2,0,-w2,-w1,-w3)
.endl	
.local speed7
d0=94
d1=d0*140/100	;+40%
d2=d0*117/100
w1=d1*1000/P2
w2=d2*1000/P5
w3=d2*1000/P6
			dta b(0,w2,w1,w3,d0,w3,w1,w2,0,-w2,-w1,-w3,-d0,-w3,-w1,-w2)
			dta b(-d0,-w3,-w1,-w2,0,w2,w1,w3,d0,w3,w1,w2,0,-w2,-w1,-w3)
.endl	

					
			
;Ucieczka przeciwnikow, korekcja ich lotu
Ucieczka	equ *
		ldy #0
		lda enemyY0,x
		bmi @+		;jesli wartosc ujemna to przyjmij 0
		cmp #14
		bcc @+
		ldy #2

@		lda enemyX0,x
		bmi @+
		cmp #16
		bcc @+
		iny
@		lda fazaTab1,y		
				
		sec
		sbc enemyFaza,x

		and #%1111
		bne @+
		rts			;nie zmieniaj fazy , sa równe
		
@		cmp #8
		bcs @+
		;clc
		lda enemyFaza,x
		adc #1
		and #%1111
		sta enemyFaza,x
		rts
@		lda enemyFaza,x
		;sec
		sbc #1
		and #%1111
		sta enemyFaza,x
		rts				
	
;korekcja kątu lotu
korekcjaLotu	equ *
		ldy #0
		lda enemyY0,x
		clc
		adc #1
		
		bpl @+		;jesli wartosc ujemna to przyjmij 0
		lda #0
@		lsr
		cmp #7
		bcc @+
		ldy #2
		eor #255
		adc #13		;c=1 +1
		bpl @+
		lda #0
@		asl 
		asl
		asl
		sta pom0

		lda enemyX0,x
		clc
		adc #1
		bpl @+
		lda #0
@		lsr
		cmp #8
		bcc @+
		iny
		eor #255		;II lub III cwiartka
		adc #15		;c=1 +1 zmiana znaku
		bpl @+
		lda #0		;poza ekranem
@		ora pom0
		sty pom4
		tay
		lda fazaTab,y

		ldy pom4
		
		cpy #1
		beq @+
		cpy #2
		bne @+1
		
@		eor #255
		sec
		adc #8
		
@		cpy #0
		beq @+
		cpy #2
		beq @+
		
		clc
		adc #8
				
@		sec
		sbc enemyFaza,x

		and #%1111
		bne @+
		rts			;nie zmieniaj fazy , sa równe
		
@		cmp #8
		bcs @+
		;clc
		lda enemyFaza,x
		adc #1
		and #%1111
		sta enemyFaza,x
		rts
@		lda enemyFaza,x
		;sec
		sbc #1
		and #%1111
		sta enemyFaza,x
		rts		
		
dodaj_przeciwnika	equ *	
		dec dlicz1
		beq @+
		rts
@		mva opoz_denemy dlicz1
		
		lda formacja_stan
		beq *+3
		rts		;jesli wlaczona formacja to nie dodawaj nowych statkow
		
		lda ile_enemy		;ilu przeciwnikow jest na ekranie
		cmp max_enemy		;czy jest maksymalna ilosc?
		bcc @+
		rts			;wystarczy;)
		
@		lda random		;czy ma sie pojawić?losuj
		and #%111
		cmp #%100
		bne @+
		rts			;nie
		
@		ldx #4		;szukaj nieuzywanego przeciwnika
@		lda enemy,x
		beq @+
		dex
		bpl @-
		rts		;zabezpieczenie jak beda wszystki zajete (nie powinno sie zdazyc!)

dod_en1	equ *		;miejsce dodania enemy X
		lda ile_enemy		;czy dodajemy enemy podczas formacji?
		cmp #5
		bcc *+3
		rts
		lda enemy
		beq *+3
		rts
		
		dec dlicz1		;dodajmy opoznienie
		beq *+3
		rts
		mva opoz_denemy dlicz1 
		
@		lda #1
		sta enemyEkran,x		;1 na starcie
		lda random		;wylosuj pozyccje startowa
		and #%1111
		tay
		clc
		lda enemyTab1,y
		adc posX
		and #127
		sta enemyX,x
		lda random
		and #%11100000
		sta enemyDX,x
		clc
		lda enemyTab1+16,y
		adc posY
		sta enemyY,x
		lda random
		and #%11100000
		sta enemyDY,x
		lda #EKOLOR0
		sta enemyNegatyw,x
		lda enemyTab1+32,y
		sta enemyFaza,x

		lda random		;losuj kolor i ksztalt
		and #3
		clc
		adc #>enemy1shapetab 
		sta enemyShapeH,x

			
		
		inc ile_enemy		;zwieksz liczbe obecnych przeciwnikow
		mva #1 enemy,x
		mva #0 enemyWybuch,x
		mva #20 enRotate,x
		mva #115+5 enLicznik,x
		
		rts
				
		
		
enemyTab1	dta b(-2,4,27,33,33,27,4,-2)
			dta b(13,18,33,33,18,13,-2,-2)
			
			dta b(4,-2,-2,4,24,30,30,24)
			dta b(-2,-2,12,17,30,30,12,17)
			
			dta b(5,7,9,11,13,14,2,1)
			dta b(8,8,12,12,0,0,4,4)	

;poruszaj przeciwnikami
moveEnemy	equ *
		lda jestSpy
		beq @+
		lda enemyWybuch+5
		beq @+
		ldx #5
		bne @+1		;jmp, jesli spy jest w trakcie wybuchu

@		lda formacja_stan
		cmp #3
		bcc @+
		cmp #5
		beq @+
		ldx #0		;obsluguj tylko zerowego enemy
		beq @+1
		

@		ldx #4		;maks 4 przeciwnikow
@		equ *
		lda enemy,x
		bne @+
mven1	dex
		bpl @-
		rts
		
@		equ *		;animuj przeciwnika
		
		lda enemyEkran,x
		beq @+
		
		
		ldy enLicznik,x		;jak długo przeciwnik jest na ekranie
		cpy #104
		bcs @+				;jeśli >11 to nie usuwaj go jeszcze
		
		mva #0 enemy,x		;poza ekranem
		sta enemyWybuch,x
		dec ile_enemy
		stx lastEnemy		;zaoamietaj ostatnio usunietego przeciwnika
		jmp mven1
		
		
@		lda enemyWybuch,x
		beq @+ 			
		lda enemyLastFaza,x		;wybuch nie podlega korekcji lotu
		jmp mvruch1
		
@		lda enLicznik,x		;czas zycia enemy
		beq @+
		cmp #104
		bcc enzm1
		lda enemyEkran,x
		bne @+
enzm1	equ *
		dec enLicznik,x
		
@		dec enRotate,x		;czas do korekcji ruchu
		bne mvruch
		
		lda rotate_speed1		;normalny obrot
		ldy enemyShapeH,x
		cpy #>enemy3ShapeTab
		bcc @+
		lda rotate_speed2		;2 ksztalt,szybciej sie obraca
@		sta enRotate,x

		lda enLicznik,x
		bne @+
		jsr Ucieczka
		jmp mvruch
@		jsr korekcjaLotu
		
mvruch	lda enemyFaza,x			;przesun duszka
		ldy enLicznik,x
		cpy #104+5			;jesli >240 to podwojna predkosc
		bcc mvruch1
		ora #$e0
		jmp @+1		
		
mvruch1	ldy formacja_stan	
		cpy #2		;jesli 1 to formacja czeka
		bcc @+				;jeśli brak formacji to nie zmieniaj predkosci
		cpx #0
		beq @+				;jesli jest formacja to enemy 0 porusza się z normalna predkoscia
		ldy enemyWybuch,x	; nie przyspieszaj poruszania się wybuchu podczas formacji
		bne @+
		ora formacja_speed	;formacja ma swoją predkość
		jmp @+1
@		ora speedEnemy
@		tay
		clc
		lda enemyDX,x
		adc enemyTab2,y
		sta enemyDX,x
		bcc @+			
		lda enemyTab2,y
		bmi @+1		;przepełnienie było spowodowane odejmowaniem
		inc enemyX,x
		bpl @+1
		mva #0 enemyX,x
		jmp @+1	;jmp
@		lda enemyTab2,y
		bpl @+
		dec enemyX,x
		bpl @+
		mva #127 enemyX,x
@		clc
		lda enemyDY,x
		adc enemyTab2+16,y
		sta enemyDY,x
		bcc @+
		lda enemyTab2+16,y
		bmi @+1
		inc enemyY,x
		jmp mven1
@		lda enemyTab2+16,y
		bpl @+
		dec enemyY,x

@		jmp mven1		;next
		
		
		
;Narysuj wszystkich przeciwnikow, lub ewentualne wybuchy
rysujEnemy	equ *
		ldx #5		;maksymalna ilosc przeciwnikow	
@		lda enemy,x
		beq ren1
		lda enemyWybuch,x
		bne @+
		jsr duszkiPrint		;rysujemy przeciwnika nr X
ren1		dex
		bpl @-
		rts
			
@		ldy formacja_stan
		beq @+1
		cpx #0
		beq @+1
		cmp #8
		bne @+
		inc formacja_zbite		;zwieksz liczbe zbitych przeciwnikow z formacji
@		cmp #1
		bne @+
		mvy enemyX,x spyScoreX
		mvy enemyY,x spyScoreY
		
@		sec			;rysujemy wybuch
		sbc #1
		lsr 
		sta enemyFaza,x
		jsr duszkiPrint
		bne @+
		dec enemyWybuch,x
		bne ren1
@		mva #0 enemyWybuch,x
		sta enemy,x
		mva #1 enemyEkran,x
		stx lastEnemy
		
		cpx #5
		bne @+
		lda formacja_stan
		beq ren1		;jesli 5=spy to pomin
@		dec ile_enemy
		jmp ren1
		
	