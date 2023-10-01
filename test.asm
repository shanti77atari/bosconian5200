		opt h-
		
kbcode1	equ $f0		

		icl 'atari5200.hea'

		.rept 15, #
			.SEGDEF fbank:1 $4000 $8000 R :1

			.SEGMENT fbank:1		
				ins 'empty.dat'
			.ENDSEG
		.endr
		
		org $4000
start_program
		mva #0 skctl
		mva #2 skctl
		mva #4 consol	;wlacz joystick
		sta potg0
		sei
		
		lda kbcode
		sta kbcode1
		
		
@		
		jsr test
		
@		lda vcount
		cmp #120
		bne @-
		jmp @-1
		
		
test
		lda kbcode
		tax
		eor kbcode1
		cmp #$20
		bne endt  ;żaden klawisz nie jest wciśniety
		txa
		ora kbcode1
		cmp #$39
		bne endt	;to nie START
		mva random colbak		;wcisnieto start
endt	stx kbcode1		
		rts


		lda kbcode
		cmp kbcode1
		bne @+
		rts
@		sta kbcode1
		cmp #$19
		beq @+
		cmp #$09
		beq @+
		rts
@		lda random
		sta colbak
		rts
		
e3		equ *
		:$c000-e3-3 dta b(00)
		dta b($ff),a(start_program)		