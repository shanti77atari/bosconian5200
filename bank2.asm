//bank2, 14 bank pamięci

		org $4000
		
		dta b($d8)		;nr banku $bfd8
		dta b(0,0,0)		;wyrownanie czworki

kCannon		dta b(b+23,b+21,b+22,0)
			dta b(b+23,b+21,0,b+20)
			dta b(0,b+21,0,b+20)
			dta b(0,b+21,b+22,b+20)
			dta b(b+23,0,b+22,b+20)
			dta b(b+23,0,b+22,0)
			
			dta b(b+23,b+21,0,0)
			dta b(b+23,b+21,0,b+20)
			dta b(0,b+21,b+22,b+20)
			dta b(0,0,b+22,b+20)
			dta b(b+23,0,b+22,b+20)
			dta b(b+23,b+21,b+22,0)

ad_Jadra	:7 dta b(#*16)	
ksztaltJadroA0	dta b(%00000000)
				dta b(%00000000)
				dta b(%01111101)
				dta b(%01111101)
				dta b(%01111101)
				dta b(%01111101)
				dta b(%01111101)
				dta b(%01111101)
				
				dta b(%01111101)
				dta b(%01111101)
				dta b(%01111101)
				dta b(%01111101)
				dta b(%01111101)
				dta b(%01111101)
				dta b(%00000000)
				dta b(%00000000)
		
ksztaltJadroA1	dta b(%00000000)
				dta b(%00000000)
				dta b(%00111101)
				dta b(%00111101)
				dta b(%00111101)
				dta b(%00111101)
				dta b(%00111101)
				dta b(%00111101)
				
				dta b(%00111101)
				dta b(%00111101)
				dta b(%00111101)
				dta b(%00111101)
				dta b(%00111101)
				dta b(%00111101)
				dta b(%00000000)
				dta b(%00000000)
				
ksztaltJadroA2	dta b(%00000000)
				dta b(%00000000)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00000000)
				dta b(%00000000)
				
ksztaltJadroA3	dta b(%00000000)
				dta b(%00000000)
				dta b(%00000001)
				dta b(%00000001)
				dta b(%00000001)
				dta b(%00000001)
				dta b(%00000001)
				dta b(%00000001)

				dta b(%00000001)
				dta b(%00000001)
				dta b(%00000001)
				dta b(%00000001)
				dta b(%00000001)
				dta b(%00000001)
				dta b(%00000000)
				dta b(%00000000)
				
ksztaltJadroA4	dta b(%00000000)		
				dta b(%00110000)
				dta b(%00110000)
				dta b(%00111100)
				dta b(%00111100)
				dta b(%11111111)
				dta b(%11111011)
				dta b(%11101011)
	
				dta b(%11101011)		
				dta b(%11101111)
				dta b(%11111111)
				dta b(%00111100)
				dta b(%00111100)
				dta b(%00001100)
				dta b(%00001100)
				dta b(%00000000)	

ksztaltJadroA5	dta b(%00000000)
				dta b(%00000000)
				dta b(%00101101)
				dta b(%00101101)
				dta b(%00101101)
				dta b(%10101101)
				dta b(%10101101)
				dta b(%10101101)
				
				dta b(%10101101)
				dta b(%10101101)
				dta b(%10101101)
				dta b(%00101101)
				dta b(%00101101)
				dta b(%00101101)
				dta b(%00000000)
				dta b(%00000000)

ksztaltJadroA6	dta b(%00000000)
				dta b(%00000000)
				dta b(%00111101)
				dta b(%00111101)
				dta b(%00111101)
				dta b(%10111101)
				dta b(%10111101)
				dta b(%10111101)
				
				dta b(%10111101)
				dta b(%10111101)
				dta b(%10111101)
				dta b(%00111101)
				dta b(%00111101)
				dta b(%00111101)
				dta b(%00000000)
				dta b(%00000000)
				
ksztaltJadroB0	dta b(%00000000)
				dta b(%00111111)
				dta b(%00111111)
				dta b(%00111111)
				dta b(%00111111)
				dta b(%00111111)
				dta b(%00111111)
				dta b(%00000000)
				
				dta b(%00000000)
				dta b(%11011100)
				dta b(%11011100)
				dta b(%11011100)
				dta b(%11011100)
				dta b(%11011100)
				dta b(%11011100)
				dta b(%00000000)
			
ksztaltJadroB1	dta b(%00000000)
				dta b(%00111111)
				dta b(%00111111)
				dta b(%00111111)
				dta b(%00111111)
				dta b(%00000000)
				dta b(%00000000)
				dta b(%00000000)
				
				dta b(%00000000)
				dta b(%11011100)
				dta b(%11011100)
				dta b(%11011100)
				dta b(%11011100)
				dta b(%00000000)
				dta b(%00000000)
				dta b(%00000000)
				
ksztaltJadroB2	dta b(%00000000)
				dta b(%00111111)
				dta b(%00111111)
				dta b(%00000000)
				dta b(%00000000)
				dta b(%00000000)
				dta b(%00000000)
				dta b(%00000000)
				
				dta b(%00000000)
				dta b(%11011100)
				dta b(%11011100)
				dta b(%00000000)
				dta b(%00000000)
				dta b(%00000000)
				dta b(%00000000)
				dta b(%00000000)
				
ksztaltJadroB3	dta b(%00000000)
				dta b(%00111111)
				dta b(%00000000)
				dta b(%00000000)
				dta b(%00000000)
				dta b(%00000000)
				dta b(%00000000)
				dta b(%00000000)
				
				dta b(%00000000)
				dta b(%11011100)
				dta b(%00000000)
				dta b(%00000000)
				dta b(%00000000)
				dta b(%00000000)
				dta b(%00000000)
				dta b(%00000000)
				
ksztaltJadroB4	dta b(%00000000)		
				dta b(%00000011)
				dta b(%00001111)
				dta b(%11111010)
				dta b(%00111110)
				dta b(%00001111)
				dta b(%00000011)
				dta b(%00000000)
	
				dta b(%00000000)			
				dta b(%11000000)
				dta b(%11110000)
				dta b(%10111100)
				dta b(%10101111)
				dta b(%11110000)
				dta b(%11000000)
				dta b(%00000000)
				
ksztaltJadroB5	dta b(%00000000)
				dta b(%00111111)
				dta b(%00111111)
				dta b(%00111111)
				dta b(%00001010)
				dta b(%00001010)
				dta b(%00000010)
				dta b(%00000000)
				
				dta b(%00000000)
				dta b(%11011100)
				dta b(%11011100)
				dta b(%11011100)
				dta b(%10100000)
				dta b(%10100000)
				dta b(%10000000)
				dta b(%00000000)

ksztaltJadroB6	dta b(%00000000)
				dta b(%00111111)
				dta b(%00111111)
				dta b(%00111111)
				dta b(%00111111)
				dta b(%00001010)
				dta b(%00001010)
				dta b(%00000000)
				
				dta b(%00000000)
				dta b(%11011100)
				dta b(%11011100)
				dta b(%11011100)
				dta b(%11011100)
				dta b(%10100000)
				dta b(%10100000)
				dta b(%00000000)		
		
		:512-231-1-51 dta b(0)		;zostało 16 bajtow
		

tabDiv100	
		:256 dta b([#*100]/256)
znakiL
		:128 dta b(<[znaki1+#*8])
		:128 dta b(<[znaki1+#*8])
znakiH
		:128 dta b(>[znaki1+#*8])	
		:128 dta b(>[znaki1+#*8])
		
cyfra1	dta b(%00000111)
		dta b(%00000101)
		dta b(%00000101)
		dta b(%00000101)
		dta b(%00000101)
		dta b(%00000101)
		dta b(%00000111)
		dta b(0)
		
		dta b(%00000010)
		dta b(%00000110)
		dta b(%00000010)
		dta b(%00000010)
		dta b(%00000010)
		dta b(%00000010)
		dta b(%00000111)
		dta b(0)
		
		dta b(%00000111)
		dta b(%00000001)
		dta b(%00000001)
		dta b(%00000111)
		dta b(%00000100)
		dta b(%00000100)
		dta b(%00000111)
		dta b(0)
		
		dta b(%00000111)
		dta b(%00000001)
		dta b(%00000001)
		dta b(%00000011)
		dta b(%00000001)
		dta b(%00000001)
		dta b(%00000111)
		dta b(0)
		
		dta b(%00000101)
		dta b(%00000101)
		dta b(%00000101)
		dta b(%00000111)
		dta b(%00000001)
		dta b(%00000001)
		dta b(%00000001)
		dta b(0)
		
		dta b(%00000111)
		dta b(%00000100)
		dta b(%00000100)
		dta b(%00000111)
		dta b(%00000001)
		dta b(%00000001)
		dta b(%00000111)
		dta b(0)
		
		dta b(%00000111)
		dta b(%00000100)
		dta b(%00000100)
		dta b(%00000111)
		dta b(%00000101)
		dta b(%00000101)
		dta b(%00000111)
		dta b(0)
		
		dta b(%00000111)
		dta b(%00000001)
		dta b(%00000001)
		dta b(%00000001)
		dta b(%00000001)
		dta b(%00000001)
		dta b(%00000001)
		dta b(0)
		
		dta b(%00000111)
		dta b(%00000101)
		dta b(%00000101)
		dta b(%00000111)
		dta b(%00000101)
		dta b(%00000101)
		dta b(%00000111)
		dta b(0)
		
		dta b(%00000111)
		dta b(%00000101)
		dta b(%00000101)
		dta b(%00000111)
		dta b(%00000001)
		dta b(%00000001)
		dta b(%00000001)
		dta b(0)
		
		dta b(0,0,0,0,0,0,0,0)
		
		:256-88 dta b(0)		;wyrownanie do strony
cyfra2	dta b(%01110000)
		dta b(%01010000)
		dta b(%01010000)
		dta b(%01010000)
		dta b(%01010000)
		dta b(%01010000)
		dta b(%01110000)
		dta b(0)
		
		dta b(%00100000)
		dta b(%01100000)
		dta b(%00100000)
		dta b(%00100000)
		dta b(%00100000)
		dta b(%00100000)
		dta b(%01110000)
		dta b(0)
		
		dta b(%01110000)
		dta b(%00010000)
		dta b(%00010000)
		dta b(%01110000)
		dta b(%01000000)
		dta b(%01000000)
		dta b(%01110000)
		dta b(0)
		
		dta b(%01110000)
		dta b(%00010000)
		dta b(%00010000)
		dta b(%00110000)
		dta b(%00010000)
		dta b(%00010000)
		dta b(%01110000)
		dta b(0)
		
		dta b(%01010000)
		dta b(%01010000)
		dta b(%01010000)
		dta b(%01110000)
		dta b(%00010000)
		dta b(%00010000)
		dta b(%00010000)
		dta b(0)
		
		dta b(%01110000)
		dta b(%01000000)
		dta b(%01000000)
		dta b(%01110000)
		dta b(%00010000)
		dta b(%00010000)
		dta b(%01110000)
		dta b(0)
		
		dta b(%01110000)
		dta b(%01000000)
		dta b(%01000000)
		dta b(%01110000)
		dta b(%01010000)
		dta b(%01010000)
		dta b(%01110000)
		dta b(0)
		
		dta b(%01110000)
		dta b(%00010000)
		dta b(%00010000)
		dta b(%00010000)
		dta b(%00010000)
		dta b(%00010000)
		dta b(%00010000)
		dta b(0)
		
		dta b(%01110000)
		dta b(%01010000)
		dta b(%01010000)
		dta b(%01110000)
		dta b(%01010000)
		dta b(%01010000)
		dta b(%01110000)
		dta b(0)
		
		dta b(%01110000)
		dta b(%01010000)
		dta b(%01010000)
		dta b(%01110000)
		dta b(%00010000)
		dta b(%00010000)
		dta b(%00010000)
		dta b(0)
		
		dta b(0,0,0,0,0,0,0,0)

asteroid_dat	dta a(0)
				ins '/sfx/asteroid_audf'
bomba_dat		dta a(0)
				ins '/sfx/bomba_audf'
spyHit_dat	dta b(0)
				ins '/sfx/spyHit_audf'
enemyHit_dat dta a(0)
				ins '/sfx/enemyHit_audf'
strzal_dat	dta a(0)
				ins '/sfx/strzal_audf'	
dzialko_dat	dta a(0)
				ins '/sfx/dzialko_audf'
wybuch_dat	dta a(0)
				ins '/sfx/wybuch_audf'	
dead_dat		dta a(0)
				ins '/sfx/dead_audf'		
antyair_dat	dta a(0)
				ins '/sfx/antyair_audf'		
extraLife_dat dta a(0)
				ins '/sfx/extraLife_audf'
alarm_dat		dta b(0)
				ins '/sfx/alarm_audf'	
rakieta_dat	dta a(0)
				ins '/sfx/rakieta_audf'	
silnik_dat	dta b(0)
				ins '/sfx/silnik_audf'					

	
asteroid1_dat	dta a(0)
				ins '/sfx/asteroid_audc'
bomba1_dat		dta a(0)
				ins '/sfx/bomba_audc'
spyHit1_dat	dta a(0)
				ins '/sfx/spyHit_audc'
enemyHit1_dat dta a(0)
				ins '/sfx/enemyHit_audc'
strzal1_dat	dta a(0)
				ins '/sfx/strzal_audc'	
dzialko1_dat	dta a(0)
				ins '/sfx/dzialko_audc'
wybuch1_dat	dta a(0)
				ins '/sfx/wybuch_audc'	
dead1_dat		dta a(0)
				ins '/sfx/dead_audc'		
antyair1_dat	dta a(0)
				ins '/sfx/antyair_audc'		
extraLife1_dat dta a(0)
				ins '/sfx/extraLife_audc'
alarm1_dat		dta b(0)
				ins '/sfx/alarm_audc'	
rakieta1_dat	dta a(0)
				ins '/sfx/rakieta_audc'	
silnik1_dat	dta b(0)
				ins '/sfx/silnik_audc'			
		
	  	
			icl 'b.asm'
			icl 'blevele.asm'
			icl 'bliczby.asm'
			icl 'poziomy.asm'
			icl 'bmove.asm'
			icl 'bgrafika.asm'
			icl 'wybuch.asm'
			icl 'time.asm'
			icl 'rakiety.asm'
			icl 'enemy.asm'
			icl 'bantyair.asm'
			icl 'bstrzaly.asm'
			icl 'spy.asm'
			icl 'formation.asm'
			icl 'kolizje.asm'

		
e2		equ *
		:$c000-e2 dta b(0)
		
