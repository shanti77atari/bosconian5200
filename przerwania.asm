	

formacja_typ	dta b(0)
formacja_radar	dta b(0)
formacja_maska	dta b(0)
formacja_speed	dta b(0)
czy_6enemy		dta b(0)
opoz_denemy		dta b(0) ;jak często pojawia się nowy enemy
opoz_dlosuj		dta b(0)	 ;jak czesto pojawiaja sie spy i formacja
circle			dta b(0)		;czy zaliczono wszystkie levele
kat1			dta b(0)
kat2			dta b(0)
	
mryganieRadarX	dta b(0)

sfx_effect	dta b(255)
sfx_dzialko dta b(255)
sfx_asteroid	dta b(255)
sfx_bomba		dta b(255)
sfx_wybuch	dta b(255)
sfx_dead	dta b(255)
sfx_antyair	dta b(255)
sfx_enemyHit	dta b(255)
sfx_rakieta		dta b(0)
sfx_extra		dta b(0)
extraLicznik	dta b(0)
sfxlicznik1	dta b(0)
licznikStrzal	dta b(0)
RadarX			dta b(0)		;pozycja statku na mapie
bufore3			equ sfx_effect


speech	dta b(0)
;rmt_goto	equ MODUL+$65F
licznikMrygFormacja	dta b(25)

sounds		equ *

			mva #BANK4 PORTB
			lda extraLicznik
			beq @+
			dec extraLicznik
			jmp @+3				;pomin dzwiek silnika i strzaly
			
@			lda sfx_extra
			bmi @+
			mva #30 extraLicznik		;czas trwania
			lda #0
			tax
			ldy #13*2
			jsr RASTERMUSICTRACKER+15
			mva #255 sfx_extra
			sta sfx_effect
			jmp @+2

@			lda licznikStrzal
			beq @+
			dec licznikStrzal
			bne @+
			ldy #16*2			;dzwiek silnika statku
			ldx #0		
			lda #0
			jsr RASTERMUSICTRACKER+15

@			ldy sfx_effect
			bmi @+
											;dzwiek strzalu statku
									;Y = 2,4,..,16	instrument number * 2 (0,2,4,..,126)
			ldx #0						;X = 3			channel (0..3 or 0..7 for stereo module)
			lda #0						;A = 12			note (0..60)
			jsr RASTERMUSICTRACKER+15	;RMT_SFX start tone (It works only if FEAT_SFX is enabled !!!)

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
			ldx #1		
			lda #0
			jsr RASTERMUSICTRACKER+15
			
@			ldy sfx_wybuch
			bmi @+
			
			mva #70 sfxLicznik1
			ldy sfx_wybuch
			ldx #1
			lda #0
			jsr RASTERMUSICTRACKER+15
			
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
			ldx #1
			lda #0
			jsr RASTERMUSICTRACKER+15
			jmp @+1
			
			
@			ldy sfx_antyair
			bmi @+1 
			
			lda sfxlicznik1
			bne @+
			
			ldx #1						;jesli nie ma zadnych innych dzwiekow to dodaj dzwiek strzalu dzialka
			lda #0
			jsr RASTERMUSICTRACKER+15
			
@			lda #$ff
			sta sfx_antyair
			sta sfx_rakieta
			
			
			
@			ldy sfx_dzialko		;wybuch dzialka bazy
			bmi @+
			
			ldx #2
			lda #0
			jsr RASTERMUSICTRACKER+15
			jmp eChannel2
			
@			ldy sfx_bomba
			bmi @+
			
			ldx #2
			lda #0
			jsr RASTERMUSICTRACKER+15
			jmp eChannel2			
			
@			ldy sfx_enemyHit
			bmi @+
			
			ldx #2
			lda #0
			jsr RASTERMUSICTRACKER+15
			jmp eChannel2
			
@			ldy sfx_asteroid
			bmi @+
			
			ldx #2
			lda #0
			jsr RASTERMUSICTRACKER+15		


eChannel2	equ *
			lda #$ff
			sta sfx_asteroid
			sta sfx_enemyHit
			sta sfx_bomba
			sta sfx_dzialko

			


@			ldy sfx_dead
			bmi @+
		
			
			ldx #0
			lda #0
			ldy sfx_dead
			jsr RASTERMUSICTRACKER+15
			
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
			jsr GetSongLine
			jmp graj
			

@			lda muzyka
			cmp #2
			bne @+
			
			ldx <(rmt_goto+$4*4)		;$1e=30,
			ldy >(rmt_goto+$4*4)
			stx p_song
			sty p_song+1
			jsr GetSongLine
			
@			equ *
						
graj		mva #0 muzyka
			mva #BANK0 PORTB
			rts		
			


			
			
			






		







		

		


		

		

		

		

		
		
		