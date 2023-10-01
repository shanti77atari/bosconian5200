;odgrywamy sample na przerwaniu Pokey'a, procedura na stronie zerowej	
		opt h-
		
powtorz	equ sirq+1		
		
		icl 'atari5200.hea'
		
		org 0
pok1	equ *		;gorna polowka
		sta pok1a+1
probka1	equ *
		lda #$ff
		sta AUDC4

		mva #0 irqen
		mva #4 irqen
		
		lda #<pok0		;adres procedury pok0
		sta irqv
		
pok1a	lda #$ff
		rti					;18bajtów


pok0	equ *
		sta pok0a+1
		lda $4000			;zapamietaj bank pamieci
		sta pok0b+1
probka	equ *		
		lda #$ff
		sta AUDC4
		lda #<pok1				;adres przerwania pok1
		sta irqv	
		sta irqen
		lda $bfd4			;wlacz bank z samplami bank1 (13)
sam		equ *+1
@		lda $ffff
		beq @+
		
		sta _probkaw
		ora #%10000
		sta probka+1
_probkaw	equ *+1		
		lda #$ff
		:4 lsr
		ora #%10000
		sta probka1+1
		
		inc sam			;next byte
		bne *+4
		inc sam+1

		mva #4 irqen

pok0b	lda $BFD0	;przywroc bank
pok0a	lda #$ff	;odtworz rejestr A
		rti
		
@		dec powtorz
		beq @+			;koniec
sam2	equ *+1		
		lda #$ff
		sta sam
sam2s	equ *+1		
		lda #$ff
		sta sam+1
		jmp @-1		;powtorz
		
@		sta sirq		;A=0 ,wylacz przerwanie
		sta IRQEN
			
		jmp pok0b		
sirq	equ *		
		

		
;		