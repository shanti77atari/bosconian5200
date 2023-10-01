;Obrona przeciwlotnicza
;opoznieniePocisku	equ 13

pociskiOra 		dta b(%01000000,%01010000,%00010000,%00010100,%00000100,%00000101,%00000101,%00000001)
bit1	equ 4

tabcan3cor_ad	dta b(0,9,18,27)
tabcan3corB		dta b(%00110001,%00000001,%00100000,0-28+16,-18-32+17,-17-28+16,7-32+17,-17-28+16,-5-32+17)
				dta b(%00000111,%00000001,%00000100,0-28+16,-18-32+17,16-28+16,-5-32+17,16-28+16,7-32+17)
				dta b(%00111000,%00001000,%00100000,0-28+16,19-32+17,-17-28+16,7-32+17,-17-28+16,-5-32+17)
				dta b(%00001110,%00001000,%00000100,0-28+16,19-32+17,16-28+16,-5-32+17,16-28+16,7-32+17)
				
tabcan3cor		dta b(%00100011,%00100000,%00000010,-18-32+17,0-28+16,-5-32+17,-17-28+16,8-32+17,-17-28+16)
				dta b(%00000111,%00000100,%00000010,19-32+17,0-28+16,-5-32+17,-17-28+16,8-32+17,-17-28+16)
				dta b(%00111000,%00100000,%00010000,-18-32+17,0-28+16,8-32+17,16-28+16,-5-32+17,16-28+16)
				dta b(%00011100,%00000100,%00010000,19-32+17,0-28+16,8-32+17,16-28+16,-5-32+17,16-28+16)
				
tabcankier		dta b($aa,$7d,$5e,$4e,$3f,$2f,$2f,$2f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,0)	
				dta b($d6,$aa,$8c,$6d,$6e,$5e,$4e,$3e,$3e,$3e,$2e,$2e,$2f,$2f,$2f,0)
				dta b($e4,$c8,$aa,$9c,$7c,$6d,$6d,$5e,$4e,$4e,$4e,$3e,$3e,$3e,$3e,0)
				dta b($e3,$d6,$c9,$aa,$9b,$8c,$7d,$6d,$6d,$5e,$5e,$4e,$4e,$4e,$4e,0)
				dta b($e3,$d5,$c7,$b9,$aa,$9b,$8c,$8c,$7d,$6d,$6d,$5d,$5e,$5e,$4e,0)
				dta b($e2,$e4,$d6,$c8,$b9,$aa,$9b,$9c,$8c,$7c,$7d,$6d,$6d,$6d,$5e,0)
				dta b($e2,$e4,$d6,$d7,$c8,$b9,$aa,$9b,$9b,$8c,$8c,$7d,$7d,$6d,$6d,0)
				dta b($e2,$e3,$e5,$d6,$c8,$c9,$b9,$aa,$ab,$9b,$8c,$8c,$7c,$7d,$7d,0)
				dta b($e1,$e3,$e4,$d6,$d7,$c8,$b9,$b9,$aa,$ab,$9b,$9c,$8c,$8c,$7c,0)
				dta b($e1,$e3,$e4,$e5,$d6,$c7,$c8,$b9,$ba,$aa,$ab,$9b,$9b,$8c,$8c,0)
				dta b($f1,$e2,$e4,$e5,$d6,$d7,$c8,$c8,$b9,$ba,$aa,$ab,$9b,$9b,$8c,0)
				dta b($f1,$e2,$e3,$e4,$d5,$d6,$d7,$c8,$c9,$b9,$ba,$aa,$ab,$9b,$9b,0)
				dta b($f1,$f2,$e3,$e4,$e5,$d6,$d7,$c7,$c8,$b9,$b9,$ba,$aa,$ab,$9b,0)
				dta b($f1,$f2,$e3,$e4,$e5,$d6,$d6,$d7,$c8,$c8,$b9,$b9,$ba,$aa,$ab,0)

			
antyair1	equ *
		lda startMapy
		beq *+3
		rts

		dec antyairOpoznienie
		beq *+3
		rts
		mva #1 antyairOpoznienie
		lda liczbaPociskow
		cmp maxPociskow1
		bcc *+3
		rts
		ldx licznikBazyEkran
		bne *+3
		rts

		jsr wylosujbaze
		
		ldy bazyEkran,x
		dey
		lda bazyRodzaj,y
		beq @+		;baza typu A
		jmp antB1
		
@		equ *	;Baza typu A
		ldx #0	;nr cwiartki

		clc
		lda bazyY0,y
		adc #7
		:2 asl
		sta pom0d
		sec
		sbc movy0
		sec
		sbc #67
		bpl @+
		ldx #2
		eor #255

@		cmp #68		;czy spelnia zakres
		bcc @+
		rts
		
@		sta pom0f
		clc
		lda bazyX0,y
		adc #8
		:2 asl
		sta pom0c
		sec
		sbc movx0
		sec
		sbc #79
		bpl @+
		inx
		eor #255
		
@		cmp #78		;czy spełnia zakres
		bcc @+
		rts
		
@		sta pom0e
		lda tabcan3cor_ad,x		;pobieramy adres tablicy z korekcjami 3 działek dla danej cwiartki
		tax
		lda bazyStan,y
		and tabcan3cor,x		;porownaj z maską tych działek, sprawdzamy czy nie są wszystkie zestrzelone
		bne @+
		rts			;brak tych działek
		
@		cmp tabcan3cor+1,x
		beq _bokA
		and tabcan3cor+1,x		;czy jest pion i poziom?
		beq _goradolA
		
		lda pom0f
		cmp #17
		bcc _bokA
		lda pom0e
		cmp #19
		bcc _goradolA
		
		lda random		;są oba losujemy które mogą strzelac
		and #bit1
		beq _goradolA
		
_bokA	equ *		;strzela boczne dzialko
		lda pom0e
		cmp #19
		bcs @+
		rts
@		clc
		lda pom0c
		adc tabcan3cor+3,x
		sta pom0a		;pozycja X pocisku
		clc
		lda pom0d
		adc tabcan3cor+4,x
		sta pom0b		;pozycja Y pocisku
		mva #$ff pom
		mva kat2 pom1
		jmp dodajPocisk

_goradolA	equ *		;strzelaja dzialka gorne lub dolne zaleznie od polozenia		
		lda pom0f
		cmp #17
		bcs @+
		rts
@		lda tabcan3cor,x
		eor tabcan3cor+1,x
		and bazyStan,y
		cmp tabcan3cor+2,x
		bcc _pierwszeA
		beq _drugieA
			
;są oba
@		lda liczbaPociskow
		cmp maxPociskow
		bcs @+				;za malo dostepnych pociskow , strzela tylko 1 dzialko
		
		lda pom0e
		cmp #17
		bcs @+			;jeśli statek jest daleko to strzela tylko 1 dzialko
		
		lda random			;czy maja strzelic oba naraz?
		and #bit1
		beq @+		
		stx pom0
		jsr _pierwszeA		;strzelają oba
		ldx pom0
		jmp _drugieA
		
@		lda random 
		and #bit1
		beq _drugieA
		
_pierwszeA	equ *		;strzela pierwsze
		clc
		lda pom0c
		adc tabcan3cor+5,x
		sta pom0a
		clc
		lda pom0d
		adc tabcan3cor+6,x
		sta pom0b
		mva kat1 pom		;typ działka 
		mva #$ff pom1
		jmp dodajPocisk
_drugieA	equ *		;strzela drugie
		clc
		lda pom0c
		adc tabcan3cor+7,x
		sta pom0a
		clc
		lda pom0d
		adc tabcan3cor+8,x
		sta pom0b
		mva kat1 pom
		mva #$ff pom1
		jmp dodajPocisk
		
		
antB1	equ *	
		ldx #0	;nr cwiartki

		clc
		lda bazyY0,y
		adc #8
		:2 asl
		sta pom0d
		sec
		sbc movy0
		sec
		sbc #70
		bpl @+
		ldx #2
		eor #255

@		cmp #68		;czy spelnia zakres
		bcc @+
		rts
		
@		sta pom0f
		clc
		lda bazyX0,y
		adc #7
		:2 asl
		sta pom0c
		sec
		sbc movx0
		sec
		sbc #76
		bpl @+
		inx
		eor #255
		
@		cmp #78		;czy spełnia zakres
		bcc @+
		rts
		
@		sta pom0e
		lda tabcan3cor_ad,x		;pobieramy adres tablicy z korekcjami 3 działek dla danej cwiartki
		tax
		lda bazyStan,y
		and tabcan3corB,x		;porownaj z maską tych działek, sprawdzamy czy nie są wszystkie zestrzelone
		bne @+
		rts			;brak tych działek
		
@		cmp tabcan3corB+1,x
		beq _bokB
		and tabcan3corB+1,x		;czy jest pion i poziom?
		beq _goradolB
		
		lda pom0e
		cmp #17
		bcc _bokB
		
		lda pom0f
		cmp #19
		bcc _goradolB
		
		lda random		;są oba losujemy które mogą strzelac
		and #bit1
		bne _goradolB
		
_bokB	equ *		;strzela pojedyncze dzialko
		lda pom0f
		cmp #19
		bcs @+
		rts
@		clc
		lda pom0c
		adc tabcan3corB+3,x
		sta pom0a		;pozycja X pocisku
		clc
		lda pom0d
		adc tabcan3corB+4,x
		sta pom0b		;pozycja Y pocisku
		mva kat1 pom
		mva #$ff pom1
		jmp dodajPocisk

_goradolB	equ *		;strzelaja dzialka podwojne 		
		lda pom0e
		cmp #17
		bcs @+
		rts
@		lda tabcan3corB,x
		eor tabcan3corB+1,x
		and bazyStan,y
		cmp tabcan3corB+2,x
		bcc _pierwszeB
		beq _drugieB
			
;są oba
@		lda liczbaPociskow
		cmp maxPociskow
		bcs @+				;za malo dostepnych pociskow , strzela tylko 1 dzialko
		
		lda pom0f
		cmp #19
		bcs @+			;jeśli statek jest daleko to strzela tylko 1 dzialko
		
		lda random			;czy maja strzelic oba naraz?
		and #bit1
		beq @+		
		stx pom0
		jsr _pierwszeB		;strzelają oba
		ldx pom0
		jmp _drugieB
		
@		lda random 
		and #bit1
		beq _drugieB
		
_pierwszeB	equ *		;strzela pierwsze
		clc
		lda pom0c
		adc tabcan3corB+5,x
		sta pom0a
		clc
		lda pom0d
		adc tabcan3corB+6,x
		sta pom0b
		mva #$ff pom		;typ działka 
		mva kat2 pom1
		jmp dodajPocisk
_drugieB	equ *		;strzela drugie
		clc
		lda pom0c
		adc tabcan3corB+7,x
		sta pom0a
		clc
		lda pom0d
		adc tabcan3corB+8,x
		sta pom0b
		mva #$ff pom
		mva kat2 pom1
		jmp dodajPocisk
		
		
		
		
		
dodajPocisk	equ *
		ldy maxPociskow	;wybierz wolny pocisk
@		lda pociski,y
		bmi @+
		dey
		bpl @-
		
					
@		lda pom0a
		clc
		sbc movx0
		sec
		sbc #63
		sta pociskiZnakX,y		;kierunek ruchu, <0 prawo, >0 lewo
		clc
		bpl @+
		eor #255
		sec				;przy zmianie znaku +1
@		adc #1			;zaokrąglenie
		cmp #64
		bcc @+
		rts
@		:2 lsr
		and #%1111
		sta pom0g
		
		lda pom0b
		sec
		sbc movy0
		sec
		sbc #55
		sta pociskiZnakY,y
		clc
		bpl @+
		eor #255
		sec
@		adc #1
		and #%00111100
		cmp #13*4
		bcc @+
		rts		;za daleko
@		:2 asl
		ora pom0g
		
		tax						;odczyt prędkości poruszanie się pocisku w osi X i Y
		lda tabcankier,x
		bne @+					;jeśli zero to obiekt poza zasięgiem
		rts
@		and #%1111
		cmp pom
		bcc @+
		rts				;za duzy kat
@		:2 asl					;dodajemy 2 zera na koncu
		sta pociskiPlusX,y
		
		lda tabcankier,x
		and #%11110000
		cmp pom1
		bcc @+
		rts
@		:2 lsr					;2 bity dx/dy, 4 bity po przecinku, 2 puste bity
		sta pociskiPlusY,y
		
		
		lda pom0a	;ustalenie pozycji startowej pocisku
		and #%11
		lsr			;2 najmlodsze bity ustawiamy jako 2 najstasze
		:2 ror
		sta pociskidx,y
		lda pom0a
		:2 lsr
		clc
		adc posX
		and #127
		sta pociskiX,y
		
		lda pom0b
		and #%11
		lsr
		:2 ror
		sta pociskidy,y
		lda pom0b
		:2 lsr
		clc
		adc posY
		sta pociskiY,y
		
		mva #0 pociski,y			;zajęcie pocisku
		inc liczbaPociskow	
		mva opoznieniePocisku antyairOpoznienie
		mva #12*2 sfx_antyair
		
		rts
		
wylosujBaze	equ *
		cpx #1
		bne @+
		dex
		rts		;dla 1=0
@		cpx #2
		bne @+
		lda random
		and #4
		:2 lsr
		tax
		rts
@		cpx #4
		bne @+
		lda random
		and #%110
		lsr
		tax
		rts
@		cpx #8
		bne @+
		lda random
		and #%1110
		lsr
		tax
		rts
		
		
@		lda tabwyl1-3,x
		sta pom0
		
		ldx #255
		lda random
		
		sec
@		inx
		sbc pom0
		bcs @-
		rts
		
tabwyl1	dta b(85,0,51,42,36)	

		
movePociski1	equ *
		ldx maxPociskow
@		lda pociski,x
		bpl @+
movepnext1	equ *
		dex
		bpl @-
		rts
		
@		lda pociskiZnakX,x
		bpl @+
		clc
		lda pociskiDX,x
		adc pociskiPlusX,x
		sta pociskiDX,x
		lda pociskiX,x
		adc #0
		and #127
		sta pociskiX,x
		jmp @+1

		
@		sec
		lda pociskiDX,x
		sbc pociskiPlusX,x
		sta pociskiDX,x
		lda pociskiX,x
		sbc #0
		and #127
		sta pociskiX,x
	
@		lda pociskiZnakY,x
		bpl @+1
		clc
		lda pociskiDY,x
		adc pociskiPlusY,x
		sta pociskiDY,x
		bcc movepnext1
		inc pociskiY,x
@		jmp movepnext1
		
@		sec
		lda pociskiDY,x
		sbc pociskiPlusY,x
		sta pociskiDY,x
		bcs movepnext1
		dec pociskiY,x
		
@		jmp movepnext1
		
pociskiCharTab	:5 dta b(firstPociskChar+#)
pociskiAdTab	:5 dta b(<(znaki1+(firstPociskChar+#)*8))
				:5 dta b(>(znaki1+(firstPociskChar+#)*8))

;rysuj pociski
printPociski	equ *
		ldx maxPociskow
proc_next1	equ *
		lda pociski,x
		bpl @+
poc_next	equ *
		dex
		bpl proc_next1
		rts
		
@		sec
		lda pociskiY,x
		sbc posY
		cmp #29
		bcc @+
		dec pociski,x		;0-1 = 255
		dec liczbaPociskow
		dex
		bpl proc_next1
		rts
		
@		sta pociskiY0,x	
		tay
		:2 asl
		sta pom0c
		
		lda (screenL),y
		sta pom1
		lda (screenH),y
		sta pom1+1	
			
		lda pociskiX,x
		sec
		sbc posX
		tay
		lda tabX,y
		cmp #33
		bcc @+
		dec pociski,x
		dec liczbaPociskow
		dex
		bpl proc_next1
		rts
		
@		sta pociskiX0,x
		tay
		:2 asl
		sta pom0b
		
		lda (pom1),y
		sta pom0
		and #128
		ora pociskiCharTab,x
		sta (pom1),y
		
		lda pociskiAdTab,x		;adres znaku pocisku
		sta pom
		lda pociskiAdTab+5,x
		ora ramka4
		sta pom+1
		
		lda pom0
		and #127
		sta pociskiTlo,x
		
		cmp #3
		bcs @+
		
		lda pociskiDY,x
		and #%11000000
		asl
		:2 rol
 
		tay
		ora pom0c
		sta pociskiDY0,x
		lda pociskiSkokL+4,y		;skok do procedury rysowania
		sta pom4
		lda pociskiSkokH+4,y
		sta pom4+1
		jmp @+1			

@		tay
		lda adresZnakL,y			;adres znaku pod pociskiem,tlo
		sta pom1
		lda adresZnakH,y
		ora ramka4
		sta pom1+1
				
		lda pociskiDY,x
		and #%11000000
		asl
		:2 rol

		tay
		ora pom0c
		sta pociskiDY0,x
		lda pociskiSkokL,y		;skok do procedury rysowania
		sta pom4
		lda pociskiSkokH,y
		sta pom4+1
		
@		lda pociskiDX,x
		:5 lsr
		
		tay
		lsr
		ora pom0b
		sta pociskiDX0,x
		
		lda pociskiOra,y
		sta pom0a	;ora dla ksztaltu pocisku

		ldy #0

		jmp (pom4)			;w procedurach rysowania należy wpisać-> jmp poc_next, wtedy tutaj moze byc jmp zamiast jsr (+6cykli)


pociskiSkokL	dta b(<pociskiDY00),b(<pociskiDY2),b(<pociskiDY4),b(<pociskiDY6)
				dta b(<pociskiDY00b),b(<pociskiDY2b),b(<pociskiDY4b),b(<pociskiDY6b)
pociskiSkokH	dta b(>pociskiDY00),b(>pociskiDY2),b(>pociskiDY4),b(>pociskiDY6)
				dta b(>pociskiDY00b),b(>pociskiDY2b),b(>pociskiDY4b),b(>pociskiDY6b)
				
pociskiDY00	equ *
		.rept 3
		lda (pom1),y
		eor pom0a
		sta (pom),y
		iny
		.endr
		.rept 4
		lda (pom1),y
		sta (pom),y
		iny
		.endr
		lda (pom1),y
		sta (pom),y
		jmp poc_next	
		
pociskiDY2	equ *
		lda (pom1),y
		sta (pom),y
		iny
		lda (pom1),y
		sta (pom),y
		iny
		.rept 2
		lda (pom1),y
		eor pom0a
		sta (pom),y
		iny
		.endr
		.rept 3
		lda (pom1),y
		sta (pom),y
		iny
		.endr
		lda (pom1),y
		sta (pom),y
		jmp poc_next
	
pociskiDY4	equ *
		.rept 3
		lda (pom1),y
		sta (pom),y
		iny
		.endr
		.rept 3
		lda (pom1),y
		eor pom0a
		sta (pom),y
		iny
		.endr
		lda (pom1),y
		sta (pom),y
		iny
		lda (pom1),y
		sta (pom),y
		jmp poc_next
		
pociskiDY6	equ *
		.rept 6
		lda (pom1),y
		sta (pom),y
		iny
		.endr
		lda (pom1),y
		eor pom0a
		sta (pom),y
		iny
		lda (pom1),y
		eor pom0a
		sta (pom),y
		jmp poc_next	

;rysujemy na pustym znaku
pociskiDY00b	equ *

		lda pom0a
		sta (pom),y
		iny
		lda pom0a
		sta (pom),y
		iny
		lda pom0a
		sta (pom),y
		iny
		lda #0
		sta (pom),y
		iny
		sta (pom),y
		iny
		sta (pom),y
		iny
		sta (pom),y
		iny
		sta (pom),y

		jmp poc_next	
		
pociskiDY2b	equ *
		tya
		sta (pom),y
		iny
		sta (pom),y
		ldy #4
		sta (pom),y
		iny
		sta (pom),y
		iny
		sta (pom),y
		iny
		sta (pom),y
		ldy #2
		lda pom0a
		sta (pom),y
		iny
		sta (pom),y

		jmp poc_next
	
pociskiDY4b	equ *
		tya
		sta (pom),y
		iny
		sta (pom),y
		iny
		sta (pom),y
		ldy #6
		sta (pom),y
		iny
		sta (pom),y
		ldy #3
		lda pom0a
		sta (pom),y
		iny
		sta (pom),y
		iny
		sta (pom),y

		jmp poc_next
		
pociskiDY6b	equ *
		tya
		sta (pom),y
		iny
		sta (pom),y
		iny
		sta (pom),y
		iny
		sta (pom),y
		iny
		sta (pom),y
		iny
		sta (pom),y
		iny
		lda pom0a
		sta (pom),y
		iny
		sta (pom),y
		
		jmp poc_next

