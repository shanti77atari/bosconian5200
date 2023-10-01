
spyTab1	dta b(3,33,19,-2)
		dta b(-2,22,29,9)
		dta b(6,12,0,4)
spyTab3		dta b(1,-1)	


przepisz5duszka	equ *
		ldx #0
@		lda enemy,x		;poszukaj pustego duszka
		beq @+
		inx
		bne @-
		
@		lda enemyEkran+5			;kopiuj obecnego przeciwnika na pozycję 0
		sta enemyEkran,x
		lda enemyWybuch+5
		sta enemyWybuch,x
		mva #1 enemy,x
		sta enemyEkran+5
		mva #0 enemy+5
		sta enemyWybuch+5
		lda enemyNegatyw+5
		sta enemyNegatyw,x
		lda enemyBank+5
		sta enemyBank,x
		lda enemyShapeH+5
		sta enemyShapeH,x
		lda enemyFaza+5
		sta enemyFaza,x
		lda enemyDX+5
		sta enemyDX,x
		lda enemyDY+5
		sta enemyDY,x
		lda enemyX+5
		sta enemyX,x
		lda enemyY+5
		sta enemyY,x
		lda enLicznik+5
		sta enLicznik,x
		lda enRotate+5
		sta enRotate,x
		
		rts

losuj	equ *
		lda poziom
		cmp #spy_from_level			;spy od 2 poziomu
		bcs *+3
		rts
@		dec losuj1
		beq @+
		rts
@		mva opoz_dlosuj losuj1
		lda ile_enemy
		cmp #4			;jeśli na ekranie jest więcej niż 3 przeciwnikow to wyjdz
		bcc @+
		rts
@		lda jestSpy		;nie może być szpiega
		ora speech		;jesli sampel, to wyjdz
		ora enemyWybuch+5 ;brak wybuchu szpiega
		ora spyScoreRysuj	;brak punktów po szpiegu
		ora formacja_stan	;brak formacji
		beq *+3
		rts
		ldx timeLevel
		lda kondycja
		cmp con1enemy,x
		bcs *+3
		rts
		cmp spyEnd,x
		bcc *+3
		rts
		
		lda random
		and #%00011111
		cmp #%011
		beq @+
		cmp #%101
		bne @+1
		
@		mva #1 nobanner		;spy ship sighted
		sta jestSpy
		sta speech
		sta powtorz
		mva #3 rodzajSpeech
		mva #<spy_wav sam
		sta sam2
		mva #>spy_wav sam+1
		sta sam2s
	
		rts
		
@		cmp #%1011
		beq @+
		cmp #%1001
		beq @+
		
		rts
		
@		lda poziom
		cmp #formation_from_level			;formacja od 4 poziomu
		bcs *+3
		rts
@		inc formacja_stan
		ldx #5
@		lda enemy,x
		beq @+
		mva #0 enLicznik,x	;przyspiesz opuszczenie ekranu przez wrogów
		mva #1 enRotate,x
@		dex
		bpl @-1
		
		lda random		;losujemy typ formacji
		and formacja_maska		;0,1 lub 3
		clc
		adc #1
		sta formacja_typ

		mva #1 nobanner		;battle station
		sta speech
		lda #1
		sta powtorz
		mva #5 rodzajSpeech
		
		mva #<formation_wav sam
		sta sam2
		mva #>formation_wav sam+1
		sta sam2s
		
		mva #$26 conditionColor1
		mva #$34 conditionColor
		rts
		

spy		equ *
		lda jestSpy
		bne @+
		rts
		
@		cmp #1
		bne @+
		cmp speech
		bne dodajSpy
		rts		;jeszcze jest odgrywany sampel
@		cmp #2		;zabezpieczenie , inna procedura moze przerwac sampla i dodac odrazu spy
		bne moveSpy

		
		
dodajSpy	equ *
		lda nobanner
		beq *+3
		rts
		
		mva #3 jestSpy
		lda enemy+5		;czy czasami nie jest zajety?
		beq @+
		
		jsr przepisz5duszka
		
@		mva #1 enemy+5
		lda Random
		and #%11
		tax
		
		clc
		lda posX
		adc spyTab1,x
		and #127
		sta enemyX+5
		clc
		lda posY
		adc spyTab1+4,x
		sta enemyY+5
		lda spyTab1+8,x
		sta enemyFaza+5
		lda random
		and #%11110000
		sta enemyDX+5
		lda random
		and #%11110000
		sta enemyDY+5
		mva #EKOLOR1 enemyNegatyw+5
		lda #0
		sta enemyWybuch+5
		mva #>enemy5shapetab enemyShapeH+5 
		mva #20-10 spylicznik	;opoznienie zmiany kierunku
		mva #240 spylicznik1	;jak dlugo duszek musi byc na ekranie
		rts

moveSpy	lda enemyWybuch+5
		ora enemy+5
		bne @+1
		sta jestSpy			;po zakończeniu wybuchu, A=0
		lda spyScore
		bpl @+
		mva opoz_dlosuj losuj1
		rts
		
@		mva #1 spyScoreRysuj	;narysuj wylosowane punkty	
		mva #25 licznikSpyScore
		mva enemyX+5 spyscoreX
		mva enemyY+5 spyscoreY
		rts
		
@		lda enemyWybuch+5
		beq @+
		rts
			
@		lda enemyFaza+5			;przesun duszka
		ora spySpeed		;predkosc szpiega
		ldy spylicznik1
		cpy #232
		bcc @+
		and #%00011111
		ora #224
@		tay
		lda enemyDX+5
		adc enemyTab2,y
		
		sta enemyDX+5
		bcc @+			
		lda enemyTab2,y
		bmi @+1		;przepełnienie było spowodowane odejmowaniem
		inc enemyX+5
		bpl @+1
		mva #0 enemyX+5
		beq @+1	;jmp
@		lda enemyTab2,y
		bpl @+
		dec enemyX+5
		bpl @+
		mva #127 enemyX+5
		
@		clc
		lda enemyDY+5
		adc enemyTab2+16,y
		sta enemyDY+5
		bcc @+
		lda enemyTab2+16,y
		bmi @+1
		inc enemyY+5
		jmp @+1
@		lda enemyTab2+16,y
		bpl @+
		dec enemyY+5		
				
@		lda ramka		;zmniejszaj licznik tylko przy parzystej ramce
		bne @+1
		lda spylicznik1
		beq @+
		dec spylicznik1
		bne @+1
@		lda enemyEkran+5
		beq @+
		mva #0 enemy+5		;wyłącz spy
		sta jestSpy
msp1	ldx timeLevel	;poziom trudnosci
		lda kondycja
		cmp conYellow,x	;jesli con=green to daruj ucieczke szpiega
		bcs *+3
		rts
		lda conred,x
		;sec
		sbc #2
		sta kondycja		;przejdź natychmiast do condition red
		rts		

		
@		dec spylicznik
		beq @+
		rts	
						
@		mva #8 spylicznik
		lda enemyEkran+5
		bne @+

		lda random
		and #1
		tax
		clc
		lda enemyFaza+5
		adc spyTab3,x
		and #15
		sta enemyFaza+5	
		
		rts	

;korekcja lotu szpiega poza ekranem		
@		ldx #5
		jmp korekcjaLotu
			
		
;print spy score
printSpyScore	equ *
		lda spyScoreRysuj
		bne *+3
		rts
		dec licznikSpyScore
		bne @+
prss1	mva #0 spyScoreRysuj		;nie rysuj już punktow
		rts

@		lda licznikSpyScore
		cmp #24
		bcc @+

		lda spyscoreY
		sta enemyY+5
		mva #64 enemyDX+5
		mva spyScore enemyFaza+5
		mva #0 enemyDY+5
		mva #>bonusShapeTab enemyShapeH+5
		mva #EKOLOR0 enemyNegatyw+5
		
@		lda spyscoreX
		sta enemyX+5
		ldx #5
		jsr duszkiPrint
		mvx #0 enemyX+5
		inx
		stx enemyEkran+5		;nie sprawdzaj kolizji z napisem
		rts
		

