

;formation
formacja	equ *
		lda formacja_stan	;stan musi byc =0, >0 formacja jest juz wlaczona
		bne *+3
		rts
		
		cmp #1
		jne frm0a
			
		lda speech		; jesli stan =1 to odgrywany jest sampel
		beq *+3
		rts
		
		lda ile_enemy
		beq @+
		rts
		
@		mva #0 formacja_zbite
		inc formacja_stan
		rts
		
frm0a	cmp #2
		jne frm0
		
		lda #0
		jsr cisza
		

	;obliczamy pozycje startowa formacji
		lda RANDOM
		and #%10001111
		ora #%00010000
		clc
		adc posX
		clc
		adc #17
		and #127
		sta enemyX+5		;pozycja X formacji,duszek 0 dowodca
		
		lda RANDOM		;rand(192)
		and #%10001111
		ora #%00100000
		clc
		adc posY
		clc
		adc #14
		sta enemyY+5
		
		ldx formacja_typ
		cpx #1
		bne @+
		sec
		sbc posY
		sec
		sbc #14
		bmi @+
		dec formacja_typ		;=4 w dol
				
@		mva #0 enemyDX+5
		sta enemyDX+1
		sta enemyDX+2
		sta enemyDX+3
		sta enemyDX+4
		sta enemyDY+5
		sta enemyDY+1
		sta enemyDY+2
		sta enemyDY+3
		sta enemyDY+4
		lda #EKOLOR0
		sta enemyNegatyw+5
		sta enemyNegatyw+1
		sta enemyNegatyw+2
		sta enemyNegatyw+3
		sta enemyNegatyw+4
		
		lda random
		and #2
		clc
		adc #>enemy1shapetab 
		sta enemyShapeH+1
		sta enemyShapeH+2
		sta enemyShapeH+3
		sta enemyShapeH+4
		sta enemyShapeH+5
		
		mva #1 enemy+5
		:4 sta enemy+1+#


		clc
		lda ile_enemy
		adc #5
		sta ile_enemy
		jsr ksztaltFormacji
		
		inc formacja_stan		;uciekli juz wszyscy ustaw 3
		inc formacja_radar		;rysuj na radarze formacje
		lda random
		and #%11111
		sta formacjaX
					
		rts
		
; formacja goni ekran z naszym statkiem	
frm0	cmp #3
		jne frm2
		
		lda enemyEkran+1
		and enemyEkran+2
		and enemyEkran+3
		and enemyEkran+4
		and enemyEkran+5
		bne @+
		
		inc formacja_stan
		mva #6 forLicznik
		jmp frm2a	;przejdz od razu do nastepnej fazy
		
@		clc
		ldx #0
		lda formacjaX
		adc posX
		and #127
		sec
		sbc enemyX+5
		beq frmY	;ta sama pozycja X
		bpl @+1		;enemy po lewo od statku
		and #127
		cmp #64
		bcc @+
		lda enemyX+5
		sbc #1
		and #127
		sta enemyX+5
		ldx #2	;lewo
		bne frmY	;jmp
@		lda enemyX+5
		adc #1
		and #127
		sta enemyX+5
		ldx #1	;prawo
		bne frmY	;jmp
@		cmp #64
		bcs @+
		lda enemyX+5
		adc #1
		and #127
		sta enemyX+5
		ldx #1 	;prawo
		bne frmY	;jmp
@		lda enemyX+5
		sbc #1
		and #127
		sta enemyX+5
		ldx #2	;lewo
		
frmY	equ *	; zmiana pozycji Y
		clc
		lda posY
		adc #14
		sec
		sbc enemyY+5
		beq frm1	;pozycja docelowa
		bmi @+
		inc enemyY+5
		txa
		ora #4		;dol
		tax		
		jmp frm1
@		dec enemyY+5
		txa
		ora #8		;gora
		tax

frm1	equ *	

		lda frm1tab,x
		sta enemyFaza+5
		
		jsr ksztaltFormacji
		
		lda enemy		;dodatkowy enemy podczas formacji
		beq @+
		rts
		
@		ldx #0
		jmp dod_en1		;dodaj przeciwnika jeśli można
		

frm2	equ *	;formacja jest na ekranie, ściga gracza
		cmp #4
		jne frm3
		
		lda enemyWybuch+5		;jesli zbity dowodca to nastepna faza
		beq frm2a
		
		lda #$5			;5 punktów extra za dowodcę
		jsr dodajPunkty
		
		inc formacja_stan
		lda #128
		jsr cisza

		mva #0 sfxlicznik1
		sta formacja_radar
		jsr piszCondition
		ldy kondycja_stan		;poprzednia kondycja
		jsr setCondition

		lda #0		
		sta enLicznik+1		;można usuwać jeśli poza ekranem
		sta enLicznik+2
		sta enLicznik+3
		sta enLicznik+4
		lda #1
		sta enRotate+1		;od razu można obracać
		sta enRotate+2
		sta enRotate+3
		sta enRotate+4
		;sprawdzmy ile statkow z formacji zostalo zestrzelonych		
		jmp frm3
		
frm2a	dec forLicznik
		bne @+
		jsr korekcjaFormacji
		mva #4 forLicznik
		
@		lda enemyFaza+5			;przesun duszka
		ora formacja_speed		;0 normalna predkosc , 32 podwojna predkosc, 64 - srednia, 96 - pomiedzy srednia a podwojna
		tay
		clc
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
		
@		lda enemy
		bne @+
		
		ldx #0		;jeśli można dodaj przeciwnika
		jsr dod_en1	
		
@		jmp ksztaltFormacji
		
	
frm3	equ *
		lda ile_enemy		;czekamy na opuszczenie ekranu przez reszte wrogów
		beq frm4			;formacja_stan=5
		cmp #1
		bne @+				;jesli zostal 1 enemy to tylko enemy nr 0
		cmp enemy
		beq frm4
		
@		lda enemy
		beq @+
		rts
@		tax				;jesli mozna dodaj enemy
		jmp dod_en1
		
;posprzątaj po formacji
frm4	equ *
		lda formacja_zbite
		cmp #6
		bne @+
		
		lda #$80
		jsr dodajPunkty
		mva #1 spyScoreRysuj	;narysuj wylosowane punkty
		mva #25 licznikSpyScore
		mva #3 spyscore	;800
		

@		mva #0 formacja_stan
		mva speedEnemy0 speedEnemy
		rts
		
frm1tab	dta b(0,4,12,0,8,6,10,0,0,2,14)		;kierunki (max 10)	
frm2tab	dta b(0,>enemy2Shapetab,>enemy1ShapeTab,>enemy4ShapeTab,>enemy3shapeTab)

ksztaltFormacji	equ *
		lda enemyFaza+5
		:4 sta enemyFaza+1+#
		
		
		dec dowodca
		bne @+
		mva #2 dowodca
		lda enemyShapeH+5		;migotanie dowodcy
		and #%111
		tay
		lda frm2tab,y
		sta enemyShapeH+5

		
@		lda formacja_typ
		bne @+1
	
		clc					;strzala w gore ^  =0
		lda enemyDY+5
		adc #%01000000
		sta enemyDY+1
		sta enemyDY+2
		lda enemyY+5
		adc #2
		sta enemyY+1
		sta enemyY+2
		
		clc
		lda enemyDY+1
		adc #%01000000
		sta enemyDY+3
		sta enemyDY+4
		lda enemyY+1
		adc #2
		sta enemyY+3
		sta enemyY+4
		
@		sec
		lda enemyDX+5
		sbc #%01000000
		sta enemyDX+1
		lda enemyX+5
		sbc #2
		and #127
		sta enemyX+1
		
		sec
		lda enemyDX+1
		sbc #%01000000
		sta enemyDX+3
		lda enemyX+1
		sbc #2
		and #127
		sta enemyX+3
		
		clc
		lda enemyDX+5
		adc #%01000000
		sta enemyDX+2
		lda enemyX+5
		adc #2
		and #127
		sta enemyX+2
		
		clc
		lda enemyDX+2
		adc #%01000000
		sta enemyDX+4
		lda enemyX+2
		adc #2
		and #127
		sta enemyX+4
		
		rts
		
@		cmp #1		;\/
		bne @+
		
		sec					;strzala w dol
		lda enemyDY+5
		sbc #%01000000
		sta enemyDY+1
		sta enemyDY+2
		lda enemyY+5
		sbc #2
		sta enemyY+1
		sta enemyY+2
		
		sec
		lda enemyDY+1
		sbc #%01000000
		sta enemyDY+3
		sta enemyDY+4
		lda enemyY+1
		sbc #2
		sta enemyY+3
		sta enemyY+4	

		jmp @-1
		
		

@		cmp #2
		bne @+

		lda enemyDX+5		;linia
		:4 sta enemyDX+1+#
		
		lda enemyX+5
		:4 sta enemyX+1+#

		sec
		lda enemyDY+5
		sbc #%01000000
		sta enemyDY+2
		lda enemyY+5
		sbc #2
		sta enemyY+2
		
		sec
		lda enemyDY+2
		sbc #%01000000
		sta enemyDY+1
		lda enemyY+2
		sbc #2
		sta enemyY+1
		
		clc
		lda enemyDY+5
		adc #%01000000
		sta enemyDY+3
		lda enemyY+5
		adc #2
		sta enemyY+3
		
		clc
		lda enemyDY+3
		adc #%01000000
		sta enemyDY+4
		lda enemyY+3
		adc #2
		sta enemyY+4
		
		rts


		;wybor ksztaltu
@		cmp #3			;czy x
		bne @+
		
		sec
		lda enemyDX+5
		sbc #%01000000
		sta enemyDX+1
		sta enemyDX+3
		lda enemyX+5
		sbc #2
		and #127
		sta enemyX+1
		sta enemyX+3
		
		clc
		lda enemyDX+5
		adc #%01000000
		sta enemyDX+2
		sta enemyDX+4
		lda enemyX+5
		adc #2
		and #127
		sta enemyX+2
		sta enemyX+4
		
		sec
		lda enemyDY+5
		sbc #%01000000
		sta enemyDY+1
		sta enemyDY+2
		lda enemyY+5
		sbc #2
		sta enemyY+1
		sta enemyY+2
		
		clc
		lda enemyDY+5
		adc #%01000000
		sta enemyDY+3
		sta enemyDY+4
		lda enemyY+5
		adc #2
		sta enemyY+3
		sta enemyY+4
		
		rts
		
@		lda enemyDX+5		;czy +
		sta enemyDX+1
		sta enemyDX+3
		lda enemyX+5
		sta enemyX+1
		sta enemyX+3
		
		sec
		lda enemyDY+5
		sbc #%01000000
		sta enemyDY+1
		lda enemyY+5
		sbc #2
		sta enemyY+1
		
		clc
		lda enemyDY+5
		adc #%01000000
		sta enemyDY+3
		lda enemyY+5
		adc #2
		sta enemyY+3
		
		lda enemyDY+5
		sta enemyDY+2
		sta enemyDY+4
		lda enemyY+5
		sta enemyY+2
		sta enemyY+4
		
		clc
		lda enemyDX+5
		adc #%01000000
		sta enemyDX+2
		lda enemyX+5
		adc #2
		and #127
		sta enemyX+2
		
		sec
		lda enemyDX+5
		sbc #%01000000
		sta enemyDX+4
		lda enemyX+5
		sbc #2
		and #127
		sta enemyX+4
		
		rts
		

		
;korekcja kątu lotu
korekcjaFormacji	equ *
		ldy #0
		lda enemyY0+5
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

		lda enemyX0+5
		bpl @+
		lda #0
@		lsr
		cmp #8
		bcc @+
		iny
		eor #255		;II lub III cwiartka
		adc #15		;c=1 +1 zmiana znaku
		bpl @+
		lda #0
@		ora pom0
		sty pom4
		tay
		lda formacjaTab,y
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
		sbc enemyFaza+5

		and #%1111
		bne @+
		rts			;nie zmieniaj fazy , sa równe
		
@		cmp #8
		bcs @+
		;clc
		lda enemyFaza+5
		adc #1
		and #%1111
		sta enemyFaza+5
		rts
@		lda enemyFaza+5
		;sec
		sbc #1
		and #%1111
		sta enemyFaza+5
		rts		
	
formacjaTab	dta b(5,5,6,6,6,6,8,9)
			dta b(6,5,6,7,7,6,8,9)
			dta b(5,6,7,4,6,6,8,9)
			dta b(6,6,6,7,4,6,8,9)
			dta b(7,6,6,7,7,5,6,9)
			dta b(4,4,4,4,4,5,6,8)
			dta b(3,3,3,3,3,3,4,6)
		