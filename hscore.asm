hscr	equ obraz2
		
		
tx1a	dta b(0,0),c'THE',b(0,0),c'LIST',b(0,0),c'OF',b(0)
tx2a	dta b(0),c'SPACE',b(0,0),'FIGHTERS'		
tx1		dta c'ENTER',b(0),c'YOUR',b(0),c'INITIALS',b(0)
tx2		dta b(0,0),c'SCORE',b(0,0,0,0,0,0,0),c'NAME',b(0,0)
tx3		dta c'BEST',b(0)
tx4		dta b(94),c'ST',b(95),c'ND',b(96),c'RD',b(97),c'TH',b(98),c'TH'

;Przepisuje litery i cyfry do zestawu znaku
przepiszZnaki	equ *
		ldx #0
@		lda znakiBosc,x
		sta znaki1+65*8,x
		sta znaki2+65*8,x
		dex
		bne @-
		
		ldx #47
@		lda znakiBosc+$100,x
		sta znaki1+$100+65*8,x
		sta znaki2+$100+65*8,x
		dex
		bpl @-
		
		rts
		
tabhs1cls	equ *
		ldx #6
@		lda #0
		sta sprites+$600+35,x
		sta sprites+$700+35,x
		sta sprites+$300+35,x
		sta sprites+$600+55,x
		sta sprites+$700+55,x
		sta sprites+$300+55,x
		sta sprites+$400+98,x
		sta sprites+$500+98,x
		sta sprites+$400+114,x
		sta sprites+$500+114,x
		sta sprites+$500+130,x
		sta sprites+$500+146,x
		sta sprites+$500+162,x
		sta sprites+$500+178,x
		sta sprites+$500+194,x
		sta sprites+$400+130,x
		sta sprites+$400+146,x
		sta sprites+$400+162,x
		sta sprites+$400+178,x
		sta sprites+$400+194,x
		dex
		bpl @-
		
		rts
		
		
;tylko tabela		
tabhs2	equ *
		lda #%00001110
		:7 sta sprites+$600+35+#
		lda #%01111001
		:7 sta sprites+$700+35+#
		lda #%10000000
		:7 sta sprites+$300+35+#
		lda #%00011111
		:7 sta sprites+$600+55+#
		lda #%00111111
		:7 sta sprites+$700+55+#
		lda #%11000000
		:7 sta sprites+$300+55+#


		
		ldx #15
@		lda tx1a,x
		sta hscr+2*48+6+2,x
		lda tx2a,x
		sta hscr+4*48+6+2,x
		dex
		bpl @-
		
		
		jmp tabhs

hsctab	dta b(%11111110,%01111110,%00111110)
		
;dodawanie swojego wyniku		
tabhs1	equ *
		lda #0
		ldx #95-2					;wyczyść duszka 4
@		sta sprites+$700,x
		dex
		bpl @-

		mva #KOLOR1 COLPF1
		
		ldx #6
@		lda #%11111011
		sta sprites+$600+35,x
		lda #%11011111
		sta sprites+$700+35,x
		lda #%11100000
		sta sprites+$300+35,x
		lda #%00111110
		sta sprites+$600+55,x
		lda #%00000011
		sta sprites+$700+55,x
		lda #%11000000
		sta sprites+$300+55,x
		lda #%10000000
		sta sprites+$700+71,x
		
		dex
		bpl @-
		
		ldx #19
@		lda tx1,x			;enter your initials,score name
		sta hscr+2*48+6,x
		lda tx2,x
		sta hscr+4*48+6,x
		lda #128
		dex
		bpl @-
		
		
		
		
tabhs	equ *		
		lda #%01111000
		:7 sta sprites+$400+98+#
		lda #%10000000
		:7 sta sprites+$500+98+#
		lda #%11111000
		:7 sta sprites+$400+114+#
		lda #%00111100
		:7 sta sprites+$500+114+#
		
		lda #0
		:7 sta sprites+$400+122+#
		:7 sta sprites+$500+122+#
		
		lda #%11100000
		:7 sta sprites+$500+130+#
		:7 sta sprites+$500+146+#
		:7 sta sprites+$500+162+#
		:7 sta sprites+$500+178+#
		:7 sta sprites+$500+194+#
		
		ldy hscScore1+3
		lda hsctab,y
		:7 sta sprites+$400+130+#
		ldy hscScore2+3
		lda hsctab,y
		:7 sta sprites+$400+146+#
		ldy hscScore3+3
		lda hsctab,y
		:7 sta sprites+$400+162+#
		ldy hscScore4+3
		lda hsctab,y
		:7 sta sprites+$400+178+#
		ldy hscScore5+3
		lda hsctab,y
		:7 sta sprites+$400+194+#
		
		lda #0
		sta sprites+$400+129
		sta sprites+$500+129 
		
		rts
	
tabhscore1	equ *		
		lda #0
		:45 sta sprites+$700+33+#		;wyczyść duszka 4

		mva #0 kolor0
		mva #pozWyniki-1 nick0
		
		jsr tabhs2
		mwa #hsdlist	DLPTR
		mva #>znaki2 CHBASE
		rts
		
tabhscore2	equ *
		lda #0
		ldx #0
@		sta obraz2,x
		sta obraz2+$100,x
		sta obraz2+$200,x
		sta obraz2+$300,x
		sta obraz2+$400,x
		dex
		bne @-
		
		ldx #15
@		sta obraz2+$500,x
		dex
		bpl @-
		
@		lda #>znaki2
		jsr przepiszZnaki

		ldx #4
@		lda tx3,x				;BEST
		sta hscr+48*9+6+7,x
		lda tx2+2,x				;SCORE
		sta hscr+48*11+6+6,x
		lda	tx2+14,x			;NAME
		sta hscr+48*11+6+16,x
		dex
		bpl @-
		
		lda #98			;best ->5
		sta hscr+48*9+6+14
		
		ldx #2
@		lda tx4,x				;miejsca
		sta hscr+13*48+6,x
		lda tx4+3,x
		sta hscr+15*48+6,x
		lda tx4+6,x
		sta hscr+17*48+6,x
		lda tx4+9,x
		sta hscr+19*48+6,x
		lda tx4+12,x
		sta hscr+21*48+6,x	
		
		lda hscNick1,x			;nicki
		sta hscr+13*48+6+17,x
		lda hscNick2,x
		sta hscr+15*48+6+17,x
		lda hscNick3,x
		sta hscr+17*48+6+17,x
		lda hscNick4,x
		sta hscr+19*48+6+17,x
		lda hscNick5,x
		sta hscr+21*48+6+17,x
		
		dex
		bpl @-
		
		ldx #0
		jsr hscToBuf
		ldy hscScore1+3
		lda <(hscr+13*48+10)
		ldx >(hscr+13*48+10)
		jsr prhsc
		
		ldx #4
		jsr hscToBuf
		ldy hscScore2+3
		lda <(hscr+15*48+10)
		ldx >(hscr+15*48+10)
		jsr prhsc
		
		ldx #8
		jsr hscToBuf
		ldy hscScore3+3
		lda <(hscr+17*48+10)
		ldx >(hscr+17*48+10)
		jsr prhsc
		
		ldx #12
		jsr hscToBuf
		ldy hscScore4+3
		lda <(hscr+19*48+10)
		ldx >(hscr+19*48+10)
		jsr prhsc
		
		ldx #16
		jsr hscToBuf
		ldy hscScore5+3
		lda <(hscr+21*48+10)
		ldx >(hscr+21*48+10)
		jsr prhsc
	
		
		lda #2
		sta hscr+28			;gwiazdy
		sta hscr+8+3*48
		sta hscr+17+7*48
		sta hscr+30+10*48
		sta hscr+10+14*48
		sta hscr+21+16*48
		sta hscr+18+22*48
		sta hscr+3+26*48
		
		
		lda #129
		sta hscr+1*48+20
		sta hscr+5*48+1
		sta hscr+23+8*48
		sta hscr+7+10*48
		sta hscr+9+20*48
		sta hscr+27+24*48
		sta hscr+16+26*48
		
		rts

prhsc	equ *
		sta pom
		stx pom+1
@		lda hscbuf,y
		clc
		adc #93
		sta (pom),y
		iny
		cpy #6
		bcc @-
		lda #93
		sta (pom),y
		rts

hscToBuf	equ *		
		ldy #0
@		lda hscScore1,x
		and #$f0
		:4 lsr
		sta hscbuf,y
		iny
		lda hscScore1,x
		and #$0f
		sta hscbuf,y
		iny
		inx
		cpy #6
		bne @-
		rts
/*				
hsctab1	dta b(6,5,4)

*/

;prawy panel podczas wyświetlania hscore
ppanel1	equ *
		jsr ppan_1
		
		lda #16
@		cmp VCOUNT
		bne @-
		
		mva #72 HPOSP2
		mva #72+32 HPOSP3
		mva #72+64 HPOSM3
		mva #72+64+8 HPOSM2
		mva #3 SIZEP2
		sta SIZEP3
		mva #%11110000 SIZEM
		
		jsr ppan_2b
		
		lda #$30					;Enter your initials | THE LIST OF
		sta COLPM2
		sta COLPM3
		
		lda #20
@		cmp VCOUNT
		bne @-
		sta WSYNC
		:18 nop 
		
		mva #kolorLiczby COLPM0
		sta COLPM1
		sta COLPM2
		mva #0 SIZEM
		sta SIZEP2
		mva #pozWyniki+2 HPOSP0		;score
		mva #pozWyniki+10 HPOSP1
		mva #pozWyniki+18 HPOSP2
		mva #pozWyniki+24 HPOSM2
		
		
		lda #26
@		cmp VCOUNT
		bne @-
		
		mva #72 HPOSP2
		mva #72+64+8 HPOSM2
		mva #3 SIZEP2
		sta SIZEP3
		mva #%11110000 SIZEM
		
		lda #$30					;SCORE NAME | SPACE FIGHTERS
		sta COLPM2
		
		jsr ppan_3
		mva #0 SIZEP2
		mva #0 SIZEM
		mva #kolorliczby COLPM2
		
		mva nick0 HPOSP3
		mva kolor0 COLPM3
		mva #14 COLPF1
		
		jsr ppan_4
		
		lda #47
@		cmp VCOUNT
		bne @-
		
		
		mva #0 COLPM3
		mva #pozWyniki-1 HPOSP3
		mva #3 SIZEP3
		
		
		
		mva #kolorLiczby COLPM0
		lda #16+4
		sta SIZEM
		mva #kolorCzerwony COLPM1
		sta COLPM2
		mva #pozWyniki+19 HPOSM2
		mva #pozWyniki+23 HPOSM1
		
		mva #0 HPOSM0
		mva #1 SIZEP2		;przeciwnicy na radarze
		mva #pozWyniki+3 HPOSP2
		
		sta WSYNC
		mva #kolorMapa	COLPM3
		
		mva #96 HPOSP0			
		mva #96+32 HPOSP1
		mva #3 SIZEP0
		sta SIZEP1
		
		
		:3 sta WSYNC
		
		mva #$A0 COLPM0
		ldx #6
		
@		mva #$A0 COLPM1
		:14 nop
		mva #kolorCzerwony COLPM1
		sta WSYNC
		dex
		bpl @-
		
		
		lda #56
@		cmp VCOUNT
		bne @-
		
		:2 sta WSYNC
		mva #$D0 COLPM0
		ldx #6
		
		
@		mva #$D0 COLPM1
		:14 nop
		mva #kolorCzerwony COLPM1
		sta WSYNC
		dex
		bpl @-
		
		
		lda #64
@		cmp VCOUNT
		bne @-
		
		ldx #$80
		
		stx COLPM0
		mva #96-8 HPOSP0
		
		jsr ppan1_a

		ldx #$70
		jsr ppan1_a
		
		ldx #$60
		jsr ppan1_a

		ldx #$50
		jsr ppan1_a
		
		ldx #$40
		jsr ppan1_a

		mva #Kolor1 COLPF1
		
		lda #102
@		cmp VCOUNT
		bne @-
		
		mva #0 COLPM3		;koniec mapy zapasowe statki
		
		sta SIZEM
		sta SIZEP2			;zakonczenie mapy
		sta HPOSP0
		sta HPOSP1
		sta HPOSP2
		sta HPOSM0
		sta HPOSM1
		sta HPOSM2
		
		jmp ppan_end

ppan1_a	equ *
		sta WSYNC

		ldy #7
@		sta WSYNC
		nop
		stx COLPM1
		mva #72 HPOSP1
		stx COLPM0
		:5 nop
		mva #140 HPOSP1
		:4 nop
		mva #kolorCzerwony COLPM1
		dey 
		bne @-
		
		cpx #$40
		beq @+
		:8 sta WSYNC
@		rts
		

texc1	dta c'CONGRATULATIONS',b(0,0,0,92,92)
texc2	dta c'THE',b(0,0),c'HIGH',b(0,0),c'SCORE'
texc3	dta c'OF',b(0),c'THE',b(0),c'DAY'
texc4	dta c'GO',b(0),c'FOR',b(0),c'THE'
texc5	dta c'SPACE',b(0),c'RECORD',b(0),c'NOW'		
		
//najlepszy wynik		
congrat	equ *
		mwa #hsdlist1 DLPTR
		mva #10 COLPF1
		mva #0 COLPF2
		
		tax
@		sta hscr,x			;czyścimy obraz
		sta hscr+$100,x
		sta hscr+$200,x
		sta hscr+$300,x
		dex
		bne @-

		ldx #79
@		sta hscr+$400,x
		dex
		bpl @-
		
		
		lda #2
		sta hscr+28			;gwiazdy
		
		sta hscr+17+7*48
		sta hscr+30+10*48
		sta hscr+10+14*48
		sta hscr+21+16*48
		sta hscr+24+22*48
		sta hscr+16+19*48
		
		
		
		lda #129
		sta hscr+1*48+20
		sta hscr+5*48+1
		sta hscr+23+7*48
		sta hscr+7+10*48
		sta hscr+5+3*48
		sta hscr+6+21*48
		sta hscr+8+3*48
		sta hscr+10+17*48
		
		lda #>znaki2
		sta CHBASE
		jsr przepiszZnaki		
		
		ldx #19
@		lda texc1,x
		sta hscr+2*48+6,x
		dex
		bpl @-
		
		ldx #15
@		lda texc2,x
		sta hscr+4*48+8,x
		lda texc5,x
		sta hscr+20*48+8,x
		dex
		bpl @-

		ldx #9
@		lda texc3,x
		sta hscr+6*48+11,x
		lda texc4,x
		sta hscr+18*48+11,x
		dex
		bpl @-
		
		ldx #7
@		lda #0
		sta znaki2+103*8,x
		lda #%00001010
		sta znaki2+104*8,x
		lda #%10100000
		sta znaki2+105*8,x
		lda #%10101010
		sta znaki2+106*8,x
		dex
		bpl @-
		
		jsr score2buf
		jsr scoreLen
		
		tax
		clc
		lda #<(hscr+9*48)		;ustalamy początek pamieci gdzie wpisujemy wynik + poprawka długości
		adc congTab,x
		sta pom
		lda #>(hscr+9*48)
		adc #0
		sta pom+1
		
@		lda hscbuf,x	;wczytaj cyfre
		jsr printCyfra	;wyświetl cyfrę
		inx
		cpx #6
		bcc @-
		lda #0
		jsr printCyfra

		ldx #6
@		lda #%11111110
		sta sprites+$600+35,x
		lda #%11000000
		sta sprites+$300+35,x
		lda #%11100111
		sta sprites+$700+56,x
		lda #%10011111
		sta sprites+$600+56,x
		lda #255
		sta sprites+$300+77,x
		lda #%11011101
		sta sprites+$700+77,x
		lda #%11011101
		sta sprites+$400+182,x
		lda sprites+$300+182,x
		ora #%00000011
		sta sprites+$300+182,x
		lda #%11111011
		sta sprites+$400+203,x
		lda #%11110111
		sta sprites+$500+203,x
		dex
		bpl @-
		
		
		
		ldx #<MODUL					;low byte of RMT module to X reg
		ldy #>MODUL					;hi byte of RMT module to Y reg
		lda #$16 					;starting song line 0-255 to A reg 	
		jsr init_rmt

		mva #6 kolpom0

		mva #1 stan_gry
		
		mva #29 opoz_congrat
		
		jsr waitvbl1
		mva #58 DMACTL
		mva #15 conLIcz
		mva #0 zegar
		mva #$0c kolor0
		
		
		
		
@		jsr ppanel2
		;jsr waitvbl1
		dec conLicz
		bne @-

		lda #12

		sta conLicz
		lda kolor0
		eor #$0c
		sta kolor0
		dec opoz_congrat
		bpl @-
		
		
		
		mva #0 DMACTL
		mva #0 stan_gry
		
		ldx #6
@		lda #0
		sta sprites+$600+35,x
		sta sprites+$300+35,x			;czyścimy duszki
		sta sprites+$600+56,x
		sta sprites+$400+182,x
		sta sprites+$400+203,x
		sta sprites+$500+203,x
		lda #255
		sta sprites+$700+56,x
		sta sprites+$700+77,x
		lda #%00111111
		sta sprites+$300+77,x
		lda sprites+$300+182,x
		and #%11111100
		sta sprites+$300+182,x
		dex
		bpl @-
		
		
		rts
		
		

		
ppan_1	equ *	
		dec kolpom0
		bne @+
		mva #6 kolpom0
		jmp @+1 
@		jsr play_rmt		
@		equ *
	
		lda #12
@		cmp VCOUNT
		bne @-
		
		lda #kolorLiczby		;pod Hiscore
		sta COLPM0
		sta COLPM1
		sta COLPM2
		mva #pozWyniki+2 HPOSP0
		mva #pozWyniki+10 HPOSP1
		mva #pozWyniki+18 HPOSP2
		
		rts
		
ppan_2	equ *
		lda #16
@		cmp VCOUNT
		bne @-
		
ppan_2b	equ *		
		mva #pozWyniki HPOSP0		;1up
		mva #pozWyniki+8 HPOSP1
		mva #kolor1ups COLPM0
		sta COLPM1
		
		rts
		
ppan_3	equ *
		lda #31
@		cmp VCOUNT
		bne @-
		
		mva #pozWyniki+2 HPOSP0		;condition
		mva #pozWyniki+8+2 HPOSP1
		mva #pozWyniki+16+2 HPOSP2
		mva #pozWyniki+24+2 HPOSM1
		mva #pozWyniki+26+2 HPOSM0
		mva #pozWyniki HPOSM2
		
		rts
		
ppan_4	equ *
		lda #37
@		cmp VCOUNT
		bne @-
		
		mva #10 COLPF1
		lda conditionColor		;conditionColor
		sta COLPM1
		sta COLPM2
		lda conditionColor1
		sta COLPM0
		
		rts
		
ppan_end	equ *
		lda #113-1
@		cmp VCOUNT
		bne @-
	
		mva #0 SIZEP0
		sta SIZEP1
		mva #pozWyniki HPOSP0
		mva #pozWyniki+8 HPOSP1
		mva #pozWyniki+16 HPOSM1		;Round
		mva #pozWyniki+18 HPOSM0
		mva #pozWyniki+22 HPOSP2
		mva #kolorLevel COLPM2
		mva #kolorRound COLPM0
		sta COLPM1
		
		lda strz1
		bne @+
		rts
		
@		lda VCOUNT			;CZEKAJ NA KONIEC EKRANU
		cmp #120
		bcc @-
		
		rts
		
;prawy panel podczas wyświetlania hscore
ppanel2	equ *
		jsr ppan_1
		jsr ppan_2
		
		sta WSYNC
		sta WSYNC
		sta WSYNC
		mva #72 HPOSP3
		mva #$30 COLPM3
		sta COLPM2
		mva #104 HPOSP2
		mva #3 SIZEP2
		mva #144 HPOSM3
		lda #%11000000
		sta SIZEM
		
		lda #20
@		cmp VCOUNT
		bne @-
		sta WSYNC
		:16 nop 
		
		
		mva #kolorLiczby COLPM0	
		sta COLPM1
		sta COLPM2
		mva #0 COLPM3
		sta SIZEM
		sta SIZEP2
		mva #pozWyniki+2 HPOSP0		;score
		mva #pozWyniki+10 HPOSP1
		mva #pozWyniki+18 HPOSP2
		mva #pozWyniki+24 HPOSM2
		
		lda #27
@		cmp VCOUNT
		bne @-
		
		:2 sta WSYNC
		stx HPOSP2
		mva #$20 COLPM3
		sta COLPM2
		mva #80 HPOSP3
		mva #112 HPOSP2
		mva #3 SIZEP2
	
		
		lda #31
@		cmp VCOUNT
		bne @-
		
		
		mva #pozWyniki+2 HPOSP0		;condition
		mva #pozWyniki+8+2 HPOSP1
		
		mva #pozWyniki+24+2 HPOSM1
		mva #pozWyniki+26+2 HPOSM0
		mva #pozWyniki HPOSM2	
		mva #0 COLPM3
		mva #0 SIZEP2
		mva #0 SIZEM
		mva #kolorliczby COLPM2
		mva #pozWyniki+16+2 HPOSP2
		
		lda #37
@		cmp VCOUNT
		bne @-
		
		
		jsr ppan_4
		
		:3 sta WSYNC
		
		mva #$20 COLPM3
		mva #92 HPOSP3
		mva #124 HPOSM3
		mva #%11000000 SIZEM	
		
		lda #42
@		cmp VCOUNT
		bne @-
		
		mva #0 COLPM3
		sta WSYNC
		mva kolor0 COLPF1
		
		
		lda #47
@		cmp VCOUNT
		bne @-
		
		
		
		mva #pozWyniki-1 HPOSP3
		mva #3 SIZEP3
			
		mva #kolorLiczby COLPM0
		lda #16+4
		sta SIZEM
		mva #kolorCzerwony COLPM1
		sta COLPM2
		mva #pozWyniki+19 HPOSM2
		mva #pozWyniki+23 HPOSM1
		
		mva #0 HPOSM0
		mva #1 SIZEP2		;przeciwnicy na radarze
		mva #pozWyniki+3 HPOSP2
		
		mva #kolorMapa	COLPM3
		
		lda #88
@		cmp VCOUNT
		bne @-
		
		mva #8 COLPF1
		
		mva #$a0 COLPM0		;GO FOR THE
		mva #92 HPOSP0
		mva #124 HPOSM0
		mva #3 SIZEP0
		sta SIZEP1
		mva #%10010111 SIZEM
		
		lda #95
@		cmp VCOUNT
		bne @-
		
		mva #0 HPOSM0		
				
		mva #80 HPOSP0
		
		
		
		lda #101
@		cmp VCOUNT
		bne @-
		
		sta WSYNC
		
		mva #$a0 COLPM1		;SPACE RECORD NOW
		mva #112 HPOSP1
		
		
		lda #102
@		cmp VCOUNT
		bne @-
		
		mva #0 COLPM3		;koniec mapy zapasowe statki
		sta COLPM2
		sta HPOSM0
		sta HPOSM1
		sta HPOSM2

		lda #105
@		cmp VCOUNT
		bne @-

		mva #0 COLPM0
		sta COLPM1
		sta COLPM2
		mva #0 SIZEP2
		sta HPOSP2
		sta SIZEM
		
		jmp ppan_end

congTab	dta b(2,4,6)


printCyfra	equ *
		stx pom0
		
		:3 asl
		ora #1
		tax
		
@		jsr prcyf1		;rysuje jedną linię znaku
		clc
		lda pom		;następna linia
		adc #48
		sta pom
		bcc @+
		inc pom+1
@		inx
		txa
		and #%111
		bne @-1
		
		sec
		lda pom			;ustaw się na następną literę
		sbc #<332		;7*48-4
		sta pom
		lda pom+1
		sbc #>332
		sta pom+1
		
		ldx pom0
		rts
		
prcyf1	equ *
		ldy #0
@		lda cyfryBosc,x
		and prcyfTab,y
		
		cpy #3
		beq @+1
		sty pom0a
@		:2 lsr
		iny
		cpy #3
		bcc @-
		ldy pom0a
@		clc
		adc #103
		sta (pom),y
		iny
		cpy #4
		bcc @-2
		
		rts

prcyfTab	dta b(%11000000,%00110000,%00001100,%00000011)
		
score2buf	equ *		
		ldy #0
		ldx #2
@		lda Score,x
		and #$f0
		:4 lsr
		sta hscbuf,y
		iny
		lda Score,x
		and #$0f
		sta hscbuf,y
		iny
		dex
		cpy #6
		bne @-
		rts		

	
		:8 dta b(0)
	
znakiBosc	equ *	
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
		dta b(%00111100)		;c
		dta b(%01100110)
		:3 dta b(%11000000)
		dta b(%01100110)
		dta b(%00111100)
		
		dta b(0)
		dta b(%11111000)
		dta b(%11001100)
		dta b(%11000110)		;d
		dta b(%11000110)
		dta b(%11000110)
		dta b(%11001100)
		dta b(%11111000)
		
		dta b(0)
		dta b(%01111110)
		dta b(%01100000)		;e
		dta b(%01100000)
		dta b(%01111100)
		dta b(%01100000)
		dta b(%01100000)
		dta b(%01111110)
		
		dta b(0)
		dta b(%11111110)		;f
		:2 dta b(%11000000)
		dta b(%11111100)
		:3 dta b(%11000000)

		
		dta b(0)
		dta b(%00111110)		;g
		dta b(%01100000)
		dta b(%11000000)
		dta b(%11001110)
		dta b(%11000110)
		dta b(%01100110)
		dta b(%00111110)
		
		dta b(0)
		:3 dta b(%11000110)	;h
		dta b(%11111110)
		:3 dta b(%11000110)
		
		dta b(0)
		dta b(%01111110)		;i
		:5 dta b(%00011000)
		dta b(%01111110)
		dta b(0)
		
		:5 dta b(%00000110)	;j
		dta b(%11000110)
		dta b(%01111100)
		
		dta b(0)
		dta b(%11000110)		;k
		dta b(%11001100)
		dta b(%11011000)
		dta b(%11110000)
		dta b(%11111000)
		dta b(%11011100)
		dta b(%11001110)
		
		dta b(0)
		:6 dta b(%11000000)	;l
		dta b(%11111100)
		
		dta b(0)
		dta b(%11000110)		;m
		dta b(%11101110)
		:2 dta b(%11111110)
		dta b(%11010110)
		:2 dta b(%11000110)
		
		dta b(0)
		dta b(%11000110)
		dta b(%11100110)		;n
		dta b(%11110110)
		dta b(%11111110)
		dta b(%11011110)
		dta b(%11001110)
		dta b(%11000110)
		
		dta b(0)	
		dta b(%01111100)
		:5 dta b(%11000110)		;o
		dta b(%01111100)
		
		dta b(0)
		dta b(%11111100)		;p
		:3 dta b(%11000110)
		dta b(%11111100)
		:2 dta b(%11000000)
		
		dta b(0)
		dta b(%01111100)		;q
		:3 dta b(%11000110)
		dta b(%11011110)
		dta b(%11001100)
		dta b(%01111010)
		
		dta b(0)
		dta b(%11111100)
		dta b(%11000110)
		dta b(%11000110)		;r
		dta b(%11001110)
		dta b(%11111000)
		dta b(%11001100)
		dta b(%11000110)
		
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
		
		dta b(0)
		:6 dta b(%11000110)	;u
		dta b(%01111100)
		
		dta b(0)
		dta b(%11000110)
		dta b(%11000110)		;v
		dta b(%11000110)
		dta b(%11101110)
		dta b(%01111100)
		dta b(%00111000)
		dta b(%00010000)
		
		dta b(0)
		:2 dta b(%11000110)		;w
		dta b(%11010110)
		:2 dta b(%11111110)
		dta b(%11101110)
		dta b(%11000110)
		
		dta b(0)
		dta b(%11000110)		;x
		dta b(%11101110)
		dta b(%01111100)
		dta b(%00111000)
		dta b(%01111100)
		dta b(%11101110)
		dta b(%11000110)
		
		dta b(0)
		dta b(%01100110)			;y
		dta b(%01100110)
		dta b(%01100110)
		dta b(%00111100)
		dta b(%00011000)
		dta b(%00011000)
		dta b(%00011000)
		
		dta b(0)
		dta b(%11111110)		;z
		dta b(%00001110)
		dta b(%00011100)
		dta b(%00111000)
		dta b(%01110000)
		dta b(%11100000)
		dta b(%11111110)
		
		dta b(0)
		:5 dta b(0)			;.65+26=91
		:2 dta b(%00110000)
		
		dta b(0)
		dta b(%00001000)		;!	92
		:2 dta b(%00111000)
		dta b(%00110000)
		dta b(0)
		:2 dta b(%00110000)

cyfryBosc	equ *		
		dta b(0)
		dta b(%00111000)		;0	93
		dta b(%01001100)
		:3 dta b(%11000110)
		dta b(%01100100)
		dta b(%00111000)
		
		dta b(0)
		dta b(%00011000)		;1
		dta b(%00111000)
		:4 dta b(%00011000)
		dta b(%01111110)
		
		dta b(0)
		dta b(%01111100)		;2
		dta b(%11000110)
		dta b(%00001110)
		dta b(%00111100)
		dta b(%01111000)
		dta b(%11100000)
		dta b(%11111110)
		
		dta b(0)
		dta b(%01111110)		;3
		dta b(%00001100)
		dta b(%00011000)
		dta b(%00111100)
		dta b(%00000110)
		dta b(%11000110)
		dta b(%01111100)
		
		dta b(0)
		dta b(%00011100)		;4
		dta b(%00111100)
		dta b(%01101100)
		dta b(%11001100)
		dta b(%11111110)
		:2 dta b(%00001100)
		
		dta b(0)
		dta b(%11111100)		;5
		dta b(%11000000)
		dta b(%11111100)
		:2 dta b(%00000110)
		dta b(%11000110)
		dta b(%01111100)
		
		dta b(0)
		dta b(%00111100)		;6
		dta b(%01100000)
		dta b(%11000000)
		dta b(%11111100)
		:2 dta b(%11000110)
		dta b(%01111100)
		
		dta b(0)
		dta b(%11111110)		;7
		dta b(%11000110)
		dta b(%00001100)
		dta b(%00011000)
		:3 dta b(%00110000)
		
		dta b(0)
		dta b(%01111000)		;8
		dta b(%11000100)
		dta b(%11100100)
		dta b(%01111000)
		dta b(%10011110)
		dta b(%10000110)
		dta b(%01111100)
		
		dta b(0)
		dta b(%01111100)		;9		;102
		:2 dta b(%11000110)
		dta b(%01111110)
		dta b(%00000110)
		dta b(%00001100)
		dta b(%01111000)

;Dodajemy nowy wynik		
gameover1	equ *
		ldx #<zmaz_radar
		ldy #>zmaz_radar
		lda #bank2m
		jsr go_bank
		;jsr zmaz_radar
		
		sta potg0
		lda score+1
		ora score+2
		beq @+2
		
		lda flaghscore
		beq @+
		
		mva score hscore		;przepisz score do high score
		mva score+1 hscore+1
		mva score+2	hscore+2
		
		jsr congrat		;najlepszy wynik
		
@		ldx #0
@		jsr porownaj
		bne @+1			;>1 skocz do obslugi hscore
		inx
		cpx #5
		bne @-
		
@		ldx #<Title_s
		ldy #>Title_s
		lda #bank2m
		jmp jmp_bank

@		cpx #4			
		beq @+1
		
		lda porBuf,x			;przepisz wszystkie hscore 1 poziom nizej
		sta pom4
		
		ldy #15
@		lda hscScore1,y
		sta hscScore1+4,y
		lda hscNick1,y
		sta hscNick1+4,y
		dey

		cpy pom4
		bne @-
		
@		txa
		asl
		asl					;wpisz nowy wynik na odpowiedniej pozycji
		tay	
		sta pom0f
		lda score+2
		sta hscScore1,y
		lda score+1
		sta hscScore1+1,y
		lda score
		sta hscScore1+2,y
		lda #0
		sta hscNick1,y		;wyczysć nick na danej pozycji
		sta hscNick1+1,y
		sta hscNick1+2,y
		
		jsr scoreLen		
		sta hscScore1+3,y	

		pha		;zapamietaj dlugosc score
		
		mva #0 COLPF2
		mva #10 COLPF1
		
		ldx #<MODUL					;low byte of RMT module to X reg
		ldy #>MODUL					;hi byte of RMT module to Y reg
		lda #$1B						;starting song line 0-255 to A reg 	
		jsr init_rmt

		mva #6 kolpom0

		mva #1 stan_gry
		
		jsr tabhscore2
		jsr tabhs1
	
		mwa #hsdlist	DLPTR
		
		mwa #obraz2 dlist+2
		mva #>znaki2 CHBASE
		
		ldx pom0f
		jsr hscToBuf
		pla					;wypisz obecne score na ekranie
		tay
		lda <(hscr+6*48+6)
		ldx >(hscr+6*48+6)
		jsr prhsc
		
		lda #65
		sta hscr+6*48+21
		sta hscr+6*48+22
		sta hscr+6*48+23
		
		mva #65 litera	
		mva #0 pozLitera
		sta zegar
		
		mva #kolor1ups kolor1up
		jsr waitvbl1
		mva #58 DMACTL
		
@		jsr ppanel1
		lda zegar
		cmp #1
		bne @+
		lda random
		and #$f0
		sta kolor0
@		jsr changeletter
		
		ldx pozLitera
		cpx #3
		beq @+
		lda literaTab,x
		sta nick0		;pozycja mrygajacego znaku
		
		jmp @-1
		
@		mva #0 zegar
		sta kolor0

@		jsr ppanel1
		lda zegar 
		cmp #200
		bcc @-
		
		lda FIRE
		bne @+
		mva #190 zegar
		jmp @-
			
@		mva #0 DMACTL
		
		jsr tabhs1cls
		mva #0 stan_gry
		
		mwa #dlist	DLPTR
		mva #>sprites PMBASE
		mva #>znaki1 CHBASE
		
		
		mva #0 HPOSM3
		
		ldx #<Title_s
		ldy #>Title_s
		lda #bank2m
		jmp jmp_bank

scoreLen	equ *
		lda score+2
		bne @+					;wpisz odpowiednią długość hscScore
		lda #2
		bne @+2
@		cmp #$10
		bcs @+
		lda #1
		bne @+1
@		lda #0
@		rts
		
changeLetter	equ *
		lda zegar
		cmp #7		;opoznienie 
		beq @+
		rts
@		mva #0 zegar
		ldx pot0
		stx potg0
		cpx #114+50
		rol 
		cpx #114-50
		rol 
		eor #1
		and #3
		//cmp #15
		beq cl1		;sprawdz fire
		cmp #2
		bne @+1
		lda litera
		clc
		adc #1
		cmp #103
		bcc @+
		lda #65
@		sta litera
		ldx pozLitera
		sta hscr+6*48+21,x
		rts
@		cmp #1
		beq @+
		rts
@		sec
		lda litera
		sbc #1
		cmp #65
		bcs @+
		lda #102
@		sta litera
		ldx pozLitera
		sta hscr+6*48+21,x
		rts
cl1		equ *
		lda FIRE
		beq @+
		rts
@		lda pom0f
		ora pozLitera
		tax
		lda litera
		sta hscNick1,x		;wpisz wybraną literę w tabeli
		
		lda <(hscr+13*48+23)
		sta pom
		lda >(hscr+13*48+23)
		sta pom+1
		lda pom0f
		beq @+2
		lsr
		lsr				;wpisz wybraną literę w tabeli na ekranie
		tax
@		clc
		lda pom
		adc #96
		sta pom
		bcc @+
		inc pom+1
		
@		dex
		bne @-1
		
@		ldy pozLitera
		
		lda litera
		sta (pom),y
		
		inc pozLitera
		mva #65 litera
		mva #-25 zegar
		rts
		
	
literaTab	dta b(132,136,140)	
porBuf	dta b(255,3,7,11)

porownaj	equ *
		txa
		asl
		asl
		tay
		lda score+2
		cmp hscScore1,y
		bcc por1
		beq @+
		lda #1		;score>hscore
		rts
@		lda score+1
		cmp hscScore1+1,y
		bcc por1
		beq @+
		lda #1		;score>hscore
		rts
@		lda score
		cmp hscScore1+2,y
		bcc por1
		beq por1
		lda #1		;score>hscore
		rts
por1	lda #0
		rts		

				
				
				
				
				
				
				
				
				