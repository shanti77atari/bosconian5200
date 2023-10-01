/***************************************/
/*  Use MADS http://mads.atari8.info/  */
/*  Mode: DLI (char mode)              */
/***************************************/

	icl "logoNTSC.h"

	org $f0

fcnt	.ds 2
fadr	.ds 2
fhlp	.ds 2
cloc	.ds 1
regA	.ds 1
regX	.ds 1
regY	.ds 1

WIDTH	= 40
HEIGHT	= 30

; ---	BASIC switch OFF
	org $2000\ mva #$ff portb\ rts\ ini $2000

; ---	MAIN PROGRAM
	org $2000
ant	dta $F0
	dta $44,a(scr),$84,$04,$84,$84,$04,$04,$04,$04,$04,$84,$84,$04,$84,$04,$04
	dta $84,$84,$04,$84,$04,$04,$04,$84,$04,$04,$04,$84,$70
	dta $41,a(ant)

scr	ins "logoNTSC.scr"

	.ALIGN $0400
fnt	ins "logoNTSC.fnt"

	ift USESPRITES
	.ALIGN $0800
pmg	.ds $0300
	ift FADECHR = 0
	SPRITES
	els
	.ds $500
	eif
	eif

main
; ---	init PMG

	ift USESPRITES
	mva >pmg pmbase		;missiles and players data address
	mva #$03 pmcntl		;enable players and missiles
	eif

	lda:cmp:req $14		;wait 1 frame

	sei			;stop IRQ interrupts
	mva #$00 nmien		;stop NMI interrupts
	sta dmactl
	mva #$fe portb		;switch off ROM to get 16k more ram

	mwa #NMI $fffa		;new NMI handler

	mva #$c0 nmien		;switch on NMI+DLI again

	ift CHANGES		;if label CHANGES defined

_lp	lda trig0		; FIRE #0
	beq stop

	lda trig1		; FIRE #1
	beq stop

	lda consol		; START
	and #1
	beq stop

	lda skctl
	and #$04
	bne _lp			;wait to press any key; here you can put any own routine

	els

null	jmp DLI.dli1		;CPU is busy here, so no more routines allowed

	eif


stop
	mva #$00 pmcntl		;PMG disabled
	tax
	sta:rne hposp0,x+

	mva #$ff portb		;ROM switch on
	mva #$40 nmien		;only NMI interrupts, DLI disabled
	cli			;IRQ enabled

	rts			;return to ... DOS

; ---	DLI PROGRAM

.local	DLI

	?old_dli = *

	ift !CHANGES

dli1	lda trig0		; FIRE #0
	beq stop

	lda trig1		; FIRE #1
	beq stop

	lda consol		; START
	and #1
	beq stop

	lda skctl
	and #$04
	beq stop

	lda vcount
	cmp #$02
	bne dli1

	:3 sta wsync

	DLINEW dli9

	eif

dli_start

dli9
	sta regA

	sta wsync		;line=8
	sta wsync		;line=9
	sta wsync		;line=10
	sta wsync		;line=11
	sta wsync		;line=12
	sta wsync		;line=13
	sta wsync		;line=14
c6	lda #$62
	sta wsync		;line=15
	sta color3
	sta wsync		;line=16
	sta wsync		;line=17
	sta wsync		;line=18
c7	lda #$42
	sta wsync		;line=19
	sta color1
	DLINEW dli10 1 0 0

dli10
	sta regA
	stx regX
	sty regY

c8	lda #$90
	sta wsync		;line=24
	sta color3
	sta wsync		;line=25
	sta wsync		;line=26
c9	lda #$0C
	sta wsync		;line=27
	sta color0
	sta wsync		;line=28
	sta wsync		;line=29
	sta wsync		;line=30
c10	lda #$D6
	sta wsync		;line=31
	sta colpm0
	sta wsync		;line=32
s1	lda #$01
x8	ldx #$79
x9	ldy #$81
	sta wsync		;line=33
	sta sizep3
	stx hposp0
	sty hposp1
x10	lda #$92
	sta hposp3
c11	lda #$D6
	sta colpm1
c12	lda #$90
	sta colpm3
	sta wsync		;line=34
	sta wsync		;line=35
c13	lda #$44
	sta wsync		;line=36
	sta color3
	DLINEW dli11 1 1 1

dli11
	sta regA
	stx regX
	sty regY

	sta wsync		;line=40
c14	lda #$44
x11	ldx #$6A
c15	ldy #$90
	sta wsync		;line=41
	sta color1
	stx hposp2
	sty colpm2
s2	lda #$00
x12	ldx #$52
	sta wsync		;line=42
	sta sizep3
	stx hposp3
	sta wsync		;line=43
	sta wsync		;line=44
c16	lda #$90
	sta wsync		;line=45
	sta color3
c17	lda #$0A
	sta wsync		;line=46
	sta color0
	DLINEW DLI.dli2 1 1 1

dli2
	sta regA
	stx regX
	sty regY
	lda >fnt+$400*$01
c18	ldx #$34
x13	ldy #$5F
	sta wsync		;line=48
	sta chbase
	stx color1
	sty hposm3
	sta wsync		;line=49
x14	lda #$9F
	sta wsync		;line=50
	sta hposp3
c19	lda #$34
	sta wsync		;line=51
	sta color3
	sta wsync		;line=52
	sta wsync		;line=53
c20	lda #$36
	sta wsync		;line=54
	sta color1
x15	lda #$54
	sta wsync		;line=55
	sta hposm2
	sta wsync		;line=56
c21	lda #$90
s3	ldx #$01
x16	ldy #$92
	sta wsync		;line=57
	sta color3
	stx sizep3
	sty hposp3
	sta wsync		;line=58
x17	lda #$B8
	sta wsync		;line=59
	sta hposp2
c22	lda #$36
	sta wsync		;line=60
	sta color3
c23	lda #$28
x18	ldx #$CE
	sta wsync		;line=61
	sta color1
	stx hposm3
x19	lda #$A8
	sta wsync		;line=62
	sta hposp2
	sta wsync		;line=63
	sta wsync		;line=64
c24	lda #$08
c25	ldx #$90
x20	ldy #$92
	sta wsync		;line=65
	sta color0
	stx color3
	sty hposm3
x21	lda #$CC
	sta wsync		;line=66
	sta hposm2
c26	lda #$28
s4	ldx #$00
x22	ldy #$9F
	sta wsync		;line=67
	sta color3
	stx sizep3
	sty hposp3
c27	lda #$2A
x23	ldx #$A8
	sta wsync		;line=68
	sta color1
	stx hposp0
x24	lda #$B0
	sta wsync		;line=69
	sta hposp1
c28	lda #$08
	sta wsync		;line=70
	sta colpm1
x25	lda #$5C
c29	ldx #$08
	sta wsync		;line=71
	sta hposp3
	stx colpm0
	lda >fnt+$400*$00
c30	ldx #$90
	sta wsync		;line=72
	sta chbase
	stx color3
	sta wsync		;line=73
c31	lda #$2A
	sta wsync		;line=74
	sta color3
c32	lda #$1C
x26	ldx #$56
x27	ldy #$CE
	sta wsync		;line=75
	sta color1
	stx hposp3
	sty hposm3
x28	lda #$B8
c33	ldx #$08
	sta wsync		;line=76
	sta hposp2
	stx colpm2
	sta wsync		;line=77
c34	lda #$90
	sta wsync		;line=78
	sta color3
x29	lda #$C0
c35	ldx #$08
	sta wsync		;line=79
	sta hposp3
	stx colpm3
	lda >fnt+$400*$01
	sta wsync		;line=80
	sta chbase
	sta wsync		;line=81
c36	lda #$04
c37	ldx #$2E
c38	ldy #$1C
	sta wsync		;line=82
	sta color0
	stx color1
	sty color3
x30	lda #$B3
	sta hposp0
c39	lda #$08
x31	ldx #$A8
	sta wsync		;line=83
	sta color0
	stx hposp0
	sta wsync		;line=84
	sta wsync		;line=85
	sta wsync		;line=86
c40	lda #$EC
	sta wsync		;line=87
	sta color3
	lda >fnt+$400*$02
	sta wsync		;line=88
	sta chbase
c41	lda #$FC
c42	ldx #$2E
	sta wsync		;line=89
	sta color1
	stx color3
	sta wsync		;line=90
	sta wsync		;line=91
	sta wsync		;line=92
	sta wsync		;line=93
c43	lda #$EC
	sta wsync		;line=94
	sta color3
	DLINEW dli3 1 1 1

dli3
	sta regA
	stx regX
	sty regY
	lda >fnt+$400*$01
c44	ldx #$FE
	sta wsync		;line=96
	sta chbase
	stx color1
	sta wsync		;line=97
	sta wsync		;line=98
	sta wsync		;line=99
c45	lda #$D8
c46	ldx #$0C
c47	ldy #$E4
	sta wsync		;line=100
	sta color0
	stx color1
	sty color2
c48	lda #$82
	sta color3
x32	lda #$98
	sta hposp0
x33	lda #$A0
	sta hposp1
x34	lda #$A8
	sta hposp2
x35	lda #$B0
	sta hposp3
x36	lda #$B8
	sta hposm0
x37	lda #$BA
	sta hposm1
x38	lda #$BC
	sta hposm2
x39	lda #$BE
	sta hposm3
	DLINEW dli4 1 1 1

dli4
	sta regA
	stx regX
	sty regY
	lda >fnt+$400*$02
x40	ldx #$77
c49	ldy #$90
	sta wsync		;line=104
	sta chbase
	stx hposm3
	sty colpm3
	sta wsync		;line=105
	sta wsync		;line=106
	sta wsync		;line=107
	sta wsync		;line=108
x41	lda #$BE
c50	ldx #$08
	sta wsync		;line=109
	sta hposm3
	stx colpm3
	DLINEW dli12 1 1 1

dli12
	sta regA
	stx regX
	sty regY

	sta wsync		;line=120
	sta wsync		;line=121
	sta wsync		;line=122
x42	lda #$5B
c51	ldx #$90
	sta wsync		;line=123
	sta hposm3
	stx colpm3
	sta wsync		;line=124
	sta wsync		;line=125
x43	lda #$69
x44	ldx #$BE
c52	ldy #$34
	sta wsync		;line=126
	sta hposp0
	stx hposm3
	sty colpm0
c53	lda #$08
	sta colpm3
	sta wsync		;line=127
	sta wsync		;line=128
x45	lda #$67
	sta wsync		;line=129
	sta hposm0
x46	lda #$65
c54	ldx #$28
	sta wsync		;line=130
	sta hposp1
	stx colpm1
	sta wsync		;line=131
	sta wsync		;line=132
	sta wsync		;line=133
x47	lda #$65
c55	ldx #$34
	sta wsync		;line=134
	sta hposp2
	stx colpm2
	sta wsync		;line=135
	sta wsync		;line=136
	sta wsync		;line=137
x48	lda #$98
	sta wsync		;line=138
	sta hposp0
	DLINEW dli13 1 1 1

dli13
	sta regA
	stx regX
	sty regY

x49	lda #$B8
c56	ldx #$08
	sta wsync		;line=144
	sta hposm0
	stx colpm0
	sta wsync		;line=145
	sta wsync		;line=146
x50	lda #$A0
x51	ldx #$A8
c57	ldy #$08
	sta wsync		;line=147
	sta hposp1
	stx hposp2
	sty colpm1
	sty colpm2
	DLINEW dli14 1 1 1

dli14
	sta regA
	stx regX

x52	lda #$80
c58	ldx #$90
	sta wsync		;line=152
	sta hposm3
	stx colpm3
	sta wsync		;line=153
	sta wsync		;line=154
x53	lda #$BE
c59	ldx #$08
	sta wsync		;line=155
	sta hposm3
	stx colpm3
	DLINEW dli5 1 1 0

dli5
	sta regA
	lda >fnt+$400*$03
	sta wsync		;line=168
	sta chbase
	sta wsync		;line=169
	sta wsync		;line=170
c60	lda #$04
	sta wsync		;line=171
	sta color3
	DLINEW dli15 1 0 0

dli15
	sta regA
	stx regX

	sta wsync		;line=200
	sta wsync		;line=201
	sta wsync		;line=202
	sta wsync		;line=203
	sta wsync		;line=204
	sta wsync		;line=205
	sta wsync		;line=206
c61	lda #$86
c62	ldx #$80
	sta wsync		;line=207
	sta color0
	stx color2
	DLINEW dli6 1 1 0

dli6
	sta regA
	lda >fnt+$400*$00
	sta wsync		;line=232
	sta chbase

	lda regA
	rti

.endl

; ---

CHANGES = 1
FADECHR	= 0

; ---

.proc	NMI


VBL
	sta regA
	stx regX
	sty regY

	sta nmist		;reset NMI flag

	mwa #ant dlptr		;ANTIC address program

	mva #scr40 dmactl	;set new screen width

	inc cloc		;little timer

; Initial values

	lda >fnt+$400*$00
	sta chbase
c0	lda #$00
	sta colbak
	lda #$02
	sta chrctl
	lda #$04
	sta gtictl
c1	lda #$0E
	sta color0
c2	lda #$62
	sta color1
c3	lda #$90
	sta color2
c4	lda #$EC
	sta color3
s0	lda #$00
	sta sizep0
	sta sizep1
	sta sizep2
	sta sizep3
	sta sizem
x0	lda #$A8
	sta hposp0
x1	lda #$B0
	sta hposp1
x2	lda #$B8
	sta hposp2
x3	lda #$C0
	sta hposp3
x4	lda #$C8
	sta hposm0
x5	lda #$CA
	sta hposm1
x6	lda #$CC
	sta hposm2
x7	lda #$CE
	sta hposm3
c5	lda #$08
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3

	mwa #DLI.dli_start dliv	;set the first address of DLI interrupt

;this area is for yours routines

quit
	lda regA
	ldx regX
	ldy regY
	rti

.endp

; ---
	ini main
; ---

	opt l-

.MACRO	SPRITES
missiles
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 40 40 40 40 40 40 50
	.he 50 50 50 50 00 00 00 00 00 00 00 80 00 80 00 80
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 08 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player0
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 40 00 00 04 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 03 07 05 06 07 0E
	.he 13 60 F3 A3 D3 EC D3 63 07 04 02 04 07 63 F3 AC
	.he F3 E3 D3 60 13 0F 05 06 07 06 03 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 54 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 0E 19 74 68 B0 68 B0 60 A0 50
	.he A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 10 08 0C 04 06 03 02 01 01 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player1
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 04 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 80 00 80 00 C0
	.he 20 18 3C 28 34 F8 34 18 80 80 00 80 80 18 3C E8
	.he 34 38 34 18 20 C0 00 80 00 80 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 10 00 00 00 00 00 00 00 00 04 08 04 18 14 28
	.he 16 08 50 50 20 20 40 40 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 01 00 00 00 00 00 80 00 40 80 A2 53
	.he 48 29 04 14 02 09 05 00 02 00 01 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player2
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 20 00 20 00 20 40 20 00 00 00 60 60 60 20 20
	.he 20 00 00 00 00 00 00 00 00 00 00 20 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 30 20
	.he 00 40 40 40 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 80 C0 40 20 30 18 00 08 0A 04
	.he 01 82 40 80 20 50 A0 C8 50 6C 26 A7 1B 53 0B 23
	.he 85 53 41 28 34 10 0A 09 04 06 02 01 01 00 00 00
	.he 01 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player3
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 10 00 10 00 10 00 00 00 00 41 41 01 41
	.he 00 00 00 00 00 00 00 00 00 00 00 40 00 40 00 C1
	.he 00 00 00 00 40 40 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 20 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 80 80 80 00 00 00 00 00 00 00 00 00 80 80 80
	.he 80 C0 C0 E0 E0 20 08 0C 88 88 08 08 08 88 C8 44
	.he 40 50 B0 70 30 58 18 20 18 00 0C 04 02 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
.ENDM

USESPRITES = 1

.MACRO	DLINEW
	mva <:1 dliv
	ift [>?old_dli]<>[>:1]
	mva >:1 dliv+1
	eif

	ift :2
	lda regA
	eif

	ift :3
	ldx regX
	eif

	ift :4
	ldy regY
	eif

	rti

	.def ?old_dli = *
.ENDM

