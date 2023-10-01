			
			;GLOWNY PROGRAM

czarp1	equ *
		:4 dta b(%10110101)
		:2 dta b(255)
		dta b(%10100101)
		dta b(255)
		:2 dta b(%10110101)
		
livesRed	equ *
			ldx #9
@			lda czarp1,x
			sta sprites+startWyniki+$7c6,x
			dex
			bpl @-
			rts
			
livesRedOff	equ *
			ldx #9
			lda #255
@			sta sprites+startWyniki+$7c6,x
			dex
			bpl @-
			rts
		
czarnyPanel	equ	*
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
			lda #255	;#126
			sta sprites1+$700+10
			sta sprites1+$700+244
			lda #255	;#60
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
		
waitvbl
		lda zegar
		cmp zegar
		beq *-2
		rts
		
;inicjuje efekty dzwiekowe
init_fx	equ *
		ldx #<MODUL					;low byte of RMT module to X reg
		ldy #>MODUL					;hi byte of RMT module to Y reg
		lda #2						;starting song line 0-255 to A reg 	
		jmp init_rmt	

cisza	equ *
		bne @+
		ldx #1*2
		ldy #2*14
		jmp add_fx
	
@		lda #0
		sta kanal2
		sta _vbsnd4
		rts

		;ldy #14*2		;wycisz alarm formacji A=128 i wlacz A=0
		;ldx #1
		;jmp sfx_rmt	

wait	equ *	;czas w Y
		tya
		clc
		adc zegar
@		cmp zegar
		bne @-
		rts


;wywołanie procedury podczas przerwania vblk			
vb_strzal	equ *	
			php
			cld		
			
			stx vblX
			sty vblY
			dec ramka
			lda ramka4
			eor #4
			sta ramka4
			
			jsr printStrzal		
			
			inc ramka
			lda ramka4
			eor #4
			sta ramka4
			
			dec vblFlaga
			jmp vb_end
			

zmaz_radar	equ *
		ldy rads		;wymaz pozycje statku/formacji na radarze
		lda sprites+$300+startWyniki+84,y
		and #%11111100
		sta sprites+$300+startWyniki+84,y
		lda sprites+$300+startWyniki+84+1,y
		and #%11111100
		sta sprites+$300+startWyniki+84+1,y
		lda sprites+$300+startWyniki+84+2,y		;dodatkowe 2 punkty zmazujemy po formacji
		and #%11111100
		sta sprites+$300+startWyniki+84+2,y
		rts		

panelTab	dta b(0,$e2,$32,$b2,$00,$82)		
playerNapis2	dta b(116,121,117,123,0,0,125,118,123,124)		

game_over	equ *
		mva #0 AUDC1		;nie graj dzwiekow
		sta AUDC2
		sta AUDC3
		
		jsr sumaPunkty		;dodaj i wyświetl punkty jeśli gra nie zdążyła dodać
		lda scoreZmiana
		bne @+
		jsr piszScore1		
		jsr czyHscore
@		equ *
		
		jsr livesRedOff
		
		mva #0 sfxlicznik1

@		ldx #104		;12znakow
@		lda player1chars-1,x
		sta znaki1-1+115*8,x
		sta znaki2-1+115*8,x
		dex
		bne @-
		
		ldx #9
@		lda playerNapis2,x
		beq @+
		ora #128
		sta obraz1+11+14*48,x
		sta obraz2+11+14*48,x
@		dex
		bpl @-1
;sampel	
		jsr waitvbl

		
		ldy #20
		jsr wait
		
	
		mva #<gameover_wav sam
		sta sam2
		mva #>gameover_wav sam+1
		sta sam2s
		
		mva #%01000000 NMIEN
		mva #1 powtorz		;wlaczony sampel
		mva #4 rodzajSpeech
		
		jsr schowaj_duszki
		
		mwa #pok0 irqv		;nowy wektor przerwania
		
		mva #15 AUDF4		;jak czesto wywolujemy przerwanie, 64khz/16 = 4khz
		
		mva #0 IRQEN
		mva #4 sirq
		sta IRQEN
		
		ldy zegar
@		cpy zegar
		beq @+
		ldy zegar
		
		lda kolorPanel
		adc #1
		and #%1111
		sta kolorPanel
		ldx rodzajSpeech
		ora panelTab,x
		sta COLPM2 
		
@		lda sirq
		bne @-1
		
		jsr waitvbl
		mva #0 DMACTL
		
		ldx #15
		lda #0
@		sta sprites1+$660,x
		dex
		bpl @-
		
			
@		sta formacja_stan		;A=0
		jsr pokaz_duszki
			
@		pla		;usuwamy adres powrotu po jsr PrintShip
		pla
		
		ldx #<gameover1
		ldy #>gameover1
		lda #bank3m
		jmp jmp_bank
		//jmp gameover1	;w bank3
		
		
sounds		equ *			
@			lda extraLicznik
			beq @+
			dec extraLicznik
			jmp @+3				;pomin dzwiek silnika i strzaly
			
@			lda sfx_extra
			bmi @+
			mva #30 extraLicznik		;czas trwania
			ldx #0*2
			ldy #13*2
			jsr add_fx
			mva #255 sfx_extra
			sta sfx_effect
			jmp @+2

@			lda licznikStrzal
			beq @+
			dec licznikStrzal
			bne @+
			ldy #16*2			;dzwiek silnika statku
			ldx #0*2	
			jsr add_fx

@			ldy sfx_effect
			bmi @+
											;dzwiek strzalu statku

			ldx #0*2
			jsr add_fx

			lda #$ff
			sta sfx_effect				

@			lda sfxlicznik1
			beq @+
			dec sfxlicznik1
			
@			lda formacja_stan
			cmp #3
			beq @+
			cmp #4			;formacja gdy goni ma wartosc 3 lub 4
			bne @+1
@			lda sfxlicznik1
			cmp #40
			bne @+
			ldy #14*2			;dzwiek alarmu, wlacz po wybuchu
			ldx #1*2		
			jsr add_fx
			
@			ldy sfx_wybuch
			bmi @+
			
			mva #70 sfxLicznik1
			ldy sfx_wybuch
			ldx #1*2
			jsr add_fx
			
			lda #$ff
			sta sfx_wybuch

@			lda formacja_stan			;czy aby nie ma dzwieku formacji?
			cmp #3
			beq @+1
			cmp #4
			beq @+1
			
			ldy sfx_rakieta			
			bmi @+
			lda sfxlicznik1			;jesli licznik <40 to dodaj dzwiek rakiety
			cmp #40
			bcs @+
			
			mva #39 sfxlicznik1
			ldx #1*2
			jsr add_fx
			jmp @+1
			
			
@			ldy sfx_antyair
			bmi @+1 
			
			lda sfxlicznik1
			bne @+
			
			ldx #1*2						;jesli nie ma zadnych innych dzwiekow to dodaj dzwiek strzalu dzialka
			jsr add_fx
			
@			lda #$ff
			sta sfx_antyair
			sta sfx_rakieta
			
			
			
@			ldy sfx_dzialko		;wybuch dzialka bazy
			bmi @+
			
			ldx #2*2
			jsr add_fx
			jmp eChannel2
			
@			ldy sfx_bomba
			bmi @+
			
			ldx #2*2
			jsr add_fx
			jmp eChannel2			
			
@			ldy sfx_enemyHit
			bmi @+
			
			ldx #2*2
			jsr add_fx
			jmp eChannel2
			
@			ldy sfx_asteroid
			bmi @+
			
			ldx #2*2
			jsr add_fx		


eChannel2	equ *
			lda #$ff
			sta sfx_asteroid
			sta sfx_enemyHit
			sta sfx_bomba
			sta sfx_dzialko

			


@			ldy sfx_dead
			bmi @+
			
			
			ldx #0*2
			jsr add_fx
			
			lda #$ff
			sta sfx_dead
			
			
@			lda muzyka
			beq graj
			cmp #1
			bne @+
			
			ldx <(rmt_goto+$0*4)		
			ldy >(rmt_goto+$0*4)
			stx p_song
			sty p_song+1
			jsr GetSongLine_rmt
			mva #0 sfx
			jmp graj
			

@			lda muzyka
			cmp #2
			bne @+
			
			ldx <(rmt_goto+$4*4)		;$1e=30,
			ldy >(rmt_goto+$4*4)
			stx p_song
			sty p_song+1
			jsr GetSongLine_rmt
			mva #0 sfx
@			equ *
						
graj		mva #0 muzyka
			rts				
		
		
run		equ *	
		mva #%01000000 NMIEN ;zezwolenia na przerwania dli _+ VBLK
		cli

		mva #10 punkty
		sta antyairOpoznienie
		
		mva #<audf_table kanal_audf1
		sta kanal_audf2
		sta kanal_audf3
		mva #>audf_table kanal_audf1+1
		sta kanal_audf2+1
		sta kanal_audf3+1
		mva #<audc_table kanal_audc1
		sta kanal_audc2
		sta kanal_audc3
		mva #>audc_table kanal_audc1+1
		sta kanal_audc2+1
		sta kanal_audc3+1
		
		ldx #<czyscObraz2
		ldy #>czyscObraz2
		lda #bank3m
		jsr go_bank		
		
		mwa #dlist dlptr
		mva #>znaki1 chbase
		
		jsr waitvbl
			
		mva #0 COLBAK
		sta flagHscore
		
		lda #0
		tax
@		sta sprites+$300,x
		sta sprites+$400,x
		sta sprites+$500,x
		sta sprites+$600,x
		sta sprites1+$300,x
		sta sprites1+$400,x
		sta sprites1+$500,x
		sta sprites1+$600,x
		dex
		bne @-
		
		jsr piszCondition
		jsr pisz_zycia
		jsr pisz_panel
			
		jsr czarnyPanel
		
		mva #3 pmcntl   ;wlaczenie spritow
		mva #>sprites pmbase	;adres obrazu duszkow
		mva #1 gtiactl
		mva #3 sizep3
		mva #0 colpm3

		
		ldy #0
		jsr setCondition
		mva #1 poziom		
		jsr piszPoziom
		jsr piszHscore1
		
		
Title_s	
		jsr waitvbl
		mva #0 DMACTL
		sta GRAFM
		
	
		jsr init_fx

		jsr livesRedOff
				
		mva #0 sfxlicznik1
		sta pauza
		sta formacja_stan
		sta formacja_radar
		jsr piszCondition
		ldy kondycja_stan		;poprzednia kondycja
		jsr setCondition
		mva #0 stan_gry
	

		jsr skok_Title
		sta potg0

@		lda VCOUNT
		cmp #124
		bcc @-
		
		mva #0 DMACTL
		sta audctl
		sta score
		sta score+1
		sta score+2
		mwa #dlist	DLPTR
		mva #>SPRITES PMBASE
		
		mva #0 stan_gry
		
		jsr init_fx
	
		jsr czarnyPanel
		jsr pisz_zycia
		
		mwa #obraz1 dlist+2

		ldx #<czyscObraz1
		ldy #>czyscObraz1
		lda #bank3m
		jsr go_bank
		
		
		lda pot1
		cmp #114-50
		bcc @+
		mva #1 poziom		;poziom startowy
@		equ *
	
	
		jsr wczytajLevel
			
		jsr pokazBazyRadar
	    	
		ldy #0
		jsr setCondition
		jsr czyscScore
		jsr piszScore1
			
		mva #3	lives
		jsr printLives
		mva #1 scoreZmiana	;nie ma nowych punktów
			
	
		jsr livesRed			

		
		mva #1 zegar
		
		mva #KOLOR1 COLPF1
		mva #KOLOR3 COLPF3
		
		mva #0 flagHscore
		
		jsr waitvbl
		mva kbcode kbcode1
		mva #0 zegar
		sta klatki
		
		mva #58 dmactl
		
		mva #%11000000 NMIEN
		
		mva #2 stan_gry
		
		jmp poczatek		;nie pokazuj ekranu przed narysowaniem
		
;glowna petla		
loop	equ *
;
;Czekamy na ramke 2
;		

		mwa #obraz1 dlist+2
		mva #>znaki1 CHBASE
		mva movX HSCROL
		mva movY VSCROL
		mva #0 zegar
		
		mva #58 DMACTL		
		
		lda speech		;jesli sampel to mrygaj 2 duszkiem
		beq @+
		lda kolorPanel
		adc #2
		and #%1111
		sta kolorPanel
		ldx rodzajSpeech
		ora panelTab,x
		sta COLPM2 
@		equ *		
;obsluga sampli		
		lda nobanner
		jeq glos1
		cmp #1
		bne @+
		
		
		mva #%01000000 NMIEN
		sei
		mwa #pok0 irqv
		
		lda #15
		sta AUDF4
		mvy #0 IRQEN
		cli
		
		jsr schowaj_duszki
		lda formacja_stan
		beq *+5
		jsr pisz_formation		;tylko jesli wlaczona formacja
		
		inc nobanner
		
		
		mva #4 sirq
		sta IRQEN
		jmp glos1
		
@		lda sirq
		bne glos1		;jeszcze sie nie skonczyl		
		
		
		mva #0 AUDF4
		sta speech
		sta nobanner
		

		
		mva #%11000000 NMIEN
		
		jsr pokaz_duszki

		
glos1		equ *
poczatek	equ *

		jsr play_fx
		
		mwa #obraz2L screenL
		mwa #obraz2H screenH
		
		jsr printShip
		
		lda nobanner
		cmp #2
		bcs *+5
		jsr radar
		
		

		ldx #<czyscObraz2
		ldy #>czyscObraz2
		lda #bank3m
		jsr go_bank
		
		jsr timeEvents

;rysujemy na obrazie 2
		mva #1 ramka
		sta vblFlaga
		mva #4 ramka4		;ramka*4	

		jsr moveShip			;przesun i narysuj statek			
		jsr gwiazdyRysuj2

		jsr animacjaJadraA
		jsr animacjaJadraB
	
		jsr coreWaveA
		jsr coreWaveB
	
		lda trafienie
		ora startMapy
		bne @+
		lda czyRakiety
		beq @+
		jsr moveRakiety		;rakiety
		jsr rakiety
@		equ *
		
		jsr printEkran	

		
		jsr rysujWybuchy		;animuj wybuchy
		jsr rysujmWybuchy
							
		lda trafienie
		ora startMapy
		bne @+
		
		jsr kolStatekWybuch	
		jsr movePociski1	
		
		
		jsr kolStatekObiekty
		jsr kolStatekBazy
		
		
		jsr kolRakietyStatek		
		jsr kolRakietyObiekty 
@		
		jsr spy
		jsr formacja 
		
		
		lda trafienie
		ora startMapy
		bne @+
		jsr printSpyScore
		
@		jsr moveEnemy
		
		lda trafienie
		ora startMapy
		bne @+
		
		jsr dodaj_przeciwnika
		
		
@		equ *		

		jsr rysujEnemy
		
		lda trafienie
		ora startMapy
		bne @+
		
		jsr obliczEnemyXY
		jsr kolStatekEnemy
		
		jsr printPociski
		jsr kolPociskiEnemy
		;jsr kolObiektyEnemy			;nie było w oryginale
		
		
		jsr kolPociskiStatek
		jsr kolPociskiObiekty
		
@		equ *	

	
		lda nobanner
		cmp #2
		bcs @+
		jsr poprawlives2
@		equ *
		
		lda #0
@		cmp zegar
		beq @-
		
		lda trafienie
		ora startMapy
		bne @+
		
		jsr moveStrzal
		
		jsr pushFire			;czy wcisnieto fire?

		jsr obliczStrzalXY2		;kolizje strzlow statku
		jsr printStrzal
  
		
		jsr kolStrzalyEnemy
		jsr kolStrzalyRakiety
		jsr kolStrzalyObiekty
		jsr kolStrzalyBazy
				
		jsr moveStrzal
				
		jsr obliczStrzalXY2
		
		
		jsr locateStrzal2
		jsr kolStrzalyEnemy1
		jsr kolStrzalyObiekty1		;do poprawki
		jsr kolStrzalyBazy

		
					
@		jsr sumaPunkty		;sumuj punkty
		
		jsr play_fx

		jsr sounds			;dodaj wszystkie efekty
		jsr czyNowyLevel	;sprawdz czy ukonczono poziom		

		
;
;Czekamy na ramke		1
;		
@		lda zegar
@		cmp zegar
		beq @-	
		cmp #1
		beq loop2
		inc klatki

loop2	equ *
	
		mwa #obraz2 dlist+2
		mva #>znaki2 CHBASE
		mva movX HSCROL	
		mva movY VSCROL
		
		mva #0 zegar
		mva #58 DMACTL		
		
		lda speech		;jesli sampel to mrygaj 2 duszkiem
		beq @+
		lda kolorPanel
		adc #2
		and #%1111
		sta kolorPanel
		ldx rodzajSpeech
		ora panelTab,x
		sta COLPM2 
		
@		lda formacja_stan
		beq @+
		cmp #5
		beq @+
		
		lda conditionColor
		eor #$34
		sta conditionColor
@		equ *
	
		jsr play_fx
		
		mwa #obraz1L screenL
		mwa #obraz1H screenH
		
		jsr printShip
		
		lda nobanner
		cmp #2
		bcs @+
		jsr radar
@		equ *
	

		ldx #<czyscObraz1
		ldy #>czyscObraz1
		lda #bank3m
		jsr go_bank	

;rysujemy na obrazie1
		mva #0 ramka
		sta ramka4
		mva #1 vblFlaga
		
		jsr moveShip			;przesun i narysuj statek

		jsr gwiazdyRysuj1
		jsr animacjaJadraA
		jsr animacjaJadraB
			
		jsr coreWaveA
		jsr coreWaveB
	
		
		lda trafienie
		ora startMapy
		bne @+
		ora czyRakiety
		beq @+
		jsr moveRakiety		;rakiety
		jsr rakiety
@		equ *
		
		jsr printEkran
		
		jsr rysujWybuchy
		jsr rysujmWybuchy
		
		
		lda trafienie		
		ora startMapy
		bne @+
		
		
		jsr kolStatekWybuch
		jsr movePociski1
		jsr antyair1
		
		jsr kolStatekObiekty
		jsr kolStatekBazy
		jsr kolRakietyStatek

		
		;jsr kolRakietyObiekty
				
		jsr losuj		;losuj spy,formacja
		
@		equ *		
		jsr spy
		jsr formacja
		
		lda trafienie		
		ora startMapy
		bne @+
		
		jsr printSpyScore
		
@		equ *		
		jsr moveEnemy

		jsr rysujEnemy
		
		lda trafienie		
		ora startMapy
		bne @+
		
		jsr obliczEnemyXY
		jsr kolStatekEnemy	
		jsr kolObiektyEnemy	

		jsr printPociski
		jsr kolPociskiEnemy	
		jsr kolPociskiStatek
		jsr kolPociskiObiekty		;kolizje Pociskow z Bomami i meteorami
		
		
@		equ *		
				
		lda nobanner		;jesli sampel to nie poprawiaj lives
		cmp #2
		bcs @+
		jsr poprawlives1
@		equ *

		
		lda #0
@		cmp zegar
		beq @-
		
		lda trafienie
		ora startMapy
		bne @+
		
		jsr moveStrzal
		
		jsr pushFire
		jsr obliczStrzalXY2
		jsr printStrzal
		
		jsr kolStrzalyEnemy
		jsr kolStrzalyRakiety
		jsr kolStrzalyObiekty
		jsr kolStrzalyBazy

		jsr moveStrzal
		
		jsr obliczStrzalXY2		
		
		
		jsr locateStrzal1
		jsr kolStrzalyEnemy1
		jsr kolStrzalyObiekty1		;do poprawki
		jsr kolStrzalyBazy
  
			
		
@		lda nobanner
		beq @+
		jmp loop1
		
@		lda kbcode
		tax
		eor kbcode1
		cmp #$20
		bne @+1		;nic nie wciśnięto
		txa
		ora kbcode1
		cmp #$31		;czy wciśnięto PAUSE?
		bne @+1		;nie
		stx kbcode1
		mva #1 pauza
		mva #0 AUDC1
		sta AUDC2
		sta AUDC3
		
@		lda kbcode
		tax
		eor kbcode1
		cmp #$20
		bne key_none			;nic nie wcisnieto
		txa
		ora kbcode1
		cmp #$39
		beq key_start
		cmp #$29
		beq key_reset
key_none		
		stx kbcode1
		jmp @-
		

		
key_reset		
		mva #50 startMapy
		
		jsr zmaz_radar
		
		jmp title_s-3		;resetuj + nie zaliczaj hscore , wypisz stare
	

		
key_start		
		mva #0 pauza
@		equ *	
		stx kbcode1		;zapamiętaj ostatnio wciśniety przycisk
		
		
		lda nobanner
		bne loop1
		lda scoreZmiana
		bne @+
		jsr piszScore1		;wyswietlaj zmienione hscore tylko jesli nie ma sampla
		jsr czyHscore
@		equ *	

loop1	equ *

		jsr play_fx
		jsr sounds		;dodaj efekty
		
	
		

@		lda zegar
@		cmp zegar
		beq @-	
		cmp #1
		beq @+
		inc klatki
		
@		jmp loop
		
START		equ 1
OPTION	equ 2
		
add_fx
		lda audf_table,y
		sta kanal_audf1,x
		lda audf_table+1,y
		sta kanal_audf1+1,x
		
		lda audc_table,y
		sta kanal_audc1,x
		lda audc_table+1,y
		sta kanal_audc1+1,x
		
		lda len_table,y
		sta kanal1,x				;dlugosc
		sta kanal1s,x
		lda len_table+1,y
		sta petla1,x			;petla
		rts
		

play_fx
		lda sfx
		bne @+				;=1 graj moje fxy
		ldx #<playFX
		ldy #>playFX
		lda #bank1m
		jmp go_bank

@		equ *
		ldy kanal1
		beq pfx2
		lda (kanal_audf1),y
		sta _vbsnd1
		lda (kanal_audc1),y
		sta _vbsnd2
		dey
		bne @+					;jeszcze nie koniec
		lda petla1			;czy zapetlony 0=nie
		beq @+
		ldy kanal1s
@		sty kanal1

pfx2   ldy kanal2
		beq pfx3
		lda (kanal_audf2),y
		sta _vbsnd3
		lda (kanal_audc2),y
		sta _vbsnd4
		dey
		bne @+					;jeszcze nie koniec
		lda petla2			;czy zapetlony 0=nie
		beq @+
		ldy kanal2s
@		sty kanal2
		
pfx3	ldy kanal3
		beq pfx0
		lda (kanal_audf3),y
		sta _vbsnd5
		lda (kanal_audc3),y
		sta _vbsnd6
		dey
		bne @+					;jeszcze nie koniec
		lda petla3			;czy zapetlony 0=nie
		beq @+
		ldy kanal3s
@		sty kanal3		

pfx0	rts		
		
	
audf_table
		dta a(asteroid_dat),a(bomba_dat),a(spyHit_dat),a(0),a(0)
		dta a(enemyHit_dat),a(strzal_dat),a(dzialko_dat),a(wybuch_dat),a(dead_dat)
		dta a(0),a(0),a(antyair_dat),a(extraLife_dat),a(alarm_dat)
		dta a(rakieta_dat),a(silnik_dat)

audc_table
		dta a(asteroid1_dat),a(bomba1_dat),a(spyHit1_dat),a(0),a(0)
		dta a(enemyHit1_dat),a(strzal1_dat),a(dzialko1_dat),a(wybuch1_dat),a(dead1_dat)
		dta a(0),a(0),a(antyair1_dat),a(extraLife1_dat),a(alarm1_dat)
		dta a(rakieta1_dat),a(silnik1_dat)
		
len_table
		dta b(9+1,0),b(56+1,0),b(34+1,0),a(0),a(0)					;+1 bo dodajemy ciszę
		dta b(27+1,0),b(19+1,0),b(20+1,0),b(62+1,0),b(70+1,0)
		dta a(0),a(0),b(13+1,0),b(49+1,0),b(60,1)
		dta b(46+1,0),b(144,1)		
		
		
	
	



		