//bosconian for atari 5200
;atarimax = 1



		opt h-

		icl 'atari5200.hea'

//stałe
maxBaz	equ 16		;maksymalna liczba baz
maxObiektow	equ 128	;maksymalna liczba reszty obiektow, meteory i bomby
maxPoziomow	equ 32
opoznienieCondition	equ 7
opoznienieRed		equ 3
kondycja_start	equ 1

fire		equ trig0

//banki
bank0m		equ $d0
bank1m		equ $d4
bank2m		equ $d8
bank3m		equ $dc
BANK0		equ $bfd0
BANK1		equ $bfd4
BANK2		equ $bfd8
BANK3		equ $bfdc


//muzyka
rmt_goto		equ MODUL_end-4*$1D 	;$1C+1


//kolory
kolorCzerwony	equ $46	;$36		;NTSC
kolorHiscore		equ $46	;$36  ;czerwony
kolorMapa			equ $62  ;fioletowy	
kolorRound		equ $5a
kolor1ups			equ $98 
kolorLevel		equ $ca
kolorLogo			equ $44	;$34	
kolorYellow		equ $fc
kolorGreen		equ $c8
kolorRed			equ $46
kolorLiczby		equ $0c

KOLOR1			equ	$38
KOLOR3			equ $44	;$34

EKOLOR0			equ 0	;duszek przyjmuje kolor tła
EKOLOR1			equ 128	;duszek zawsze w negatywie

pozWyniki	equ 177	;pozycja prawego panelu
startWyniki	equ 16

b					equ 3	;11		;nr pierwszego zanku bazy
firstBombaChar		equ b+28		;pierwszy znak bomby
firstMeteorChar		equ firstBombaChar+4		;meteoru
firstRakietaChar	equ firstMeteorChar+4
firstWybuchChar		equ firstRakietaChar+8	;47
firstMalyWybuchChar	equ firstWybuchChar+16	;+20	;63
firstStrzalChar		equ firstMalyWybuchChar+2 ;63+2=65	
firstPociskChar		equ firstStrzalChar+4	;65+4=69
											;69+5=74 duszki	
		
//zmienne
;0 page
pok0				equ $19
sam				equ $31
sam2				equ $5b
sam2s				equ $5f

					org 109	;tyle bajtow zajmuja przerwania irq
sirq				org *+1
powtorz			org *+1

zegar				org *+1
stan_gry			org *+1
muzyka			org *+1
znakDX			org *+1
znakDY			org *+1
znakX1			org *+1
znakY1			org *+1
znakX				org *+18	;18b
znakY				org *+18	;18b

kolpom0			org *+1
pom				org *+2
pom1				org *+2
pom2				org *+2
pom3				org *+2
pom4				org *+2
pom0				org *+1
pom0a				org *+1
pom0b				org *+1
pom0c				org *+1
pom0d				org *+1
pom0e				org *+1
pom0f				org *+1
pom0g				org *+1
strz0				org *+1
strz0a			org *+1
strz0b			org *+1
strz0c			org *+1
strz0d			org *+1
strz0e			org *+1
strz0f			org *+1
strz				org *+2
strz1				org *+2
strz2				org *+2
posx				org *+1
posy				org *+1
ramka				org *+1
ramka4				org *+1
vblA					org *+1
vblX					org *+1
vblY					org *+1
vblFlaga				org *+1
trafienie				org *+1
startMapy				org *+1
znacznik				org *+1
rejA					org *+1
movx					org *+1
movy					org *+1
movx0					org *+1
movy0					org *+1


maxPociskow1			org *+1
czyRakiety				org *+1
bazyILE					org *+1
_bazaAJadro0			org *+1
_bazaAJadro1			org *+1
_bazaBJadro0			org *+1
_bazaBJadro1			org *+1
bombIle					org *+1
rads					org *+1
screenL					org *+2
screenH					org *+2
kolorPanel				org *+1
_gwzmaz					org *+2
_gwzmaz1				org *+2
_pre0a					org *+1
_pre2					org *+1
pre2_b					org *+1
lastEnemy					org *+1
movYs						org *+1

sfx						org *+1


kanal_audf1			org *+2
kanal_audf2			org *+2
kanal_audf3			org *+2
kanal_audc1			org *+2
kanal_audc2			org *+2
kanal_audc3			org *+2


;rmt player
p_tis
p_instrstable			org *+2
p_trackslbstable		org *+2
p_trackshbstable		org *+2
p_song					org *+2
ns						org *+2
nr						org *+2
nt						org *+2
reg1					org *+1
reg2					org *+1
reg3					org *+1
tmp						org *+1



//0 page dla duszków
_nznak		equ pom1
_kszt		equ pom2
_mask		equ pom3
nchar		equ pom0
zapX		equ duchx
duchX		equ pom0a

//tablice w RAM
tabLineA	equ $100
tabLineB	equ $107		;8 bajtow

dlist		equ $220	;34 bajty (mogą być później zmiany)

;jeszcze pare bajtow

rakietyY	equ $278	;8b
rakietyY0	equ $280	;8b
rakietyMove	equ $288	;8b
bazyRodzaj	equ $290	;rodzaj (pozioma czy pionowa)
bazyStan	equ $2a0	;stan zniszczenia
bazyRakieta	equ $2b0	;numer rakiety przypisanej do bazy 255=brak
bazyX		equ $2c0	;pozycja x
bazyX0		equ $2d0	;pozycja X na ekranie
bazyY		equ $2e0	;pozycja Y
bazyY0		equ $2f0	;pozycja Y na ekranie

sprites		equ $0	;czyli od $300 do $7ff
sprites1 	equ $800	;czyli od $b00 do $fff
tabX		equ $800	;cała strona

bazyCannon0a	equ $900	;:(maxBaz*4) dta b(0)
bazyCannon0b	equ bazyCannon0a+maxBaz
bazyCannon0c	equ bazyCannon0b+maxBaz
bazyCannon0d	equ bazyCannon0c+maxBaz

bazyCannon1a	equ $940	;:(maxBaz*4) dta b(0)
bazyCannon1b	equ bazyCannon1a+maxBaz
bazyCannon1c	equ bazyCannon1b+maxBaz
bazyCannon1d	equ bazyCannon1c+maxBaz

bazyCannon2a	equ $980	;:(maxBaz*4) dta b(0)
bazyCannon2b	equ bazyCannon2a+maxBaz
bazyCannon2c	equ bazyCannon2b+maxBaz
bazyCannon2d	equ bazyCannon2c+maxBaz

bazyCannon3a	equ $9c0	;:(maxBaz*4) dta b(0)
bazyCannon3b	equ bazyCannon3a+maxBaz
bazyCannon3c	equ bazyCannon3b+maxBaz
bazyCannon3d	equ bazyCannon3c+maxBaz

bazyCannon4a	equ $a00	;:(maxBaz*4) dta b(0)
bazyCannon4b	equ bazyCannon4a+maxBaz
bazyCannon4c	equ bazyCannon4b+maxBaz
bazyCannon4d	equ bazyCannon4c+maxBaz

bazyCannon5a	equ $a40	;:(maxBaz*4) dta b(0)
bazyCannon5b	equ bazyCannon5a+maxBaz
bazyCannon5c	equ bazyCannon5b+maxBaz
bazyCannon5d	equ bazyCannon5c+maxBaz

bombRodzaj		equ $a80	;0 bomba, 1 meteor	


znaki1	equ $1000
znaki2	equ $1400


obraz1a	equ $1800
obraz1	equ obraz1a+8+8*48	;+$188
obraz2a	equ obraz1+28*48+48	;+$570 , 29 linii obrazu *48
obraz2	equ obraz2a+8+8*48	;+$188, calosc zabiera $F78

bombX			equ $2780	;pozycje X obiektow	,128b
bombY			equ $2800	;pozycje Y obiektow	,128b

BombyEkran		equ $2880	;max 32 na ekranie
bombX0			equ $28a0	;32b
bombY0			equ $28c0	;32b
rakietyStan		equ $28e0	;8b
rakietyTyp		equ $28e8	;8b
rakietyX		equ $28f0	;8b
rakietyX0		equ $28f8	;8b


tabBazy1	equ $2900	;256b
tabBazy2	equ $2a00	;256b
tabBomb1	equ $2b00	;256b
tabBomb2	equ $2c00	;256b

adresZnakL	equ $2d00
adresZnakH	equ $2e00

			org $2f00
wybuchyX0		org *+32	;equ $2f00	;32b
wybuchyY0		org *+32	;equ $2f20	;32b
wybuchyX		org *+32	;equ $2f40	;32b
wybuchyY		org *+32	;equ $2f60	;32b
wybuchyLicznik	org *+32	;equ $2f80	;32b


mwybuchyX		org *+8		;equ $2fa0	;8b
mwybuchyY		org *+8		;equ $2fa8	;8b
mwybuchyLicznik	org *+8		;equ $2fb0	;8b
mwybuchyTyp		org *+8		;equ $2fb8	;8b

;rmtplayer
track_variables
trackn_db		org *+4
trackn_hb		org *+4
trackn_idx		org *+4
trackn_pause	org *+4
trackn_note		org *+4
trackn_volume	org *+4
trackn_distor 	org *+4
trackn_shiftfrq	org *+4

trackn_instrx2	org *+4
trackn_instrdb	org *+4
trackn_instrhb	org *+4
trackn_instridx	org *+4
trackn_instrlen	org *+4
trackn_instrlop	org *+4
trackn_instrreachend	org *+4
trackn_volumeslidedepth org *+4
trackn_volumeslidevalue org *+4

trackn_effdelay			org *+4
trackn_effvibratoa		org *+4
trackn_effshift			org *+4
trackn_tabletypespeed 	org *+4

trackn_tablenote	org *+4
trackn_tablea		org *+4
trackn_tableend		org *+4
trackn_tablespeeda	org *+4

trackn_audf			org *+4
trackn_audc			org *+4

trackn_audctl		org *+4
v_aspeed			org *+4
track_endvariables	

v_abeat				org *+1
v_maxtracklen		org *+1
v_bspeed			org *+1
v_instrspeed		org *+1
v_speed				org *+1
v_audctl			org *+1
v_audctl2			org *+1
v_ainstrspeed		org *+1

hsdlist				org *+88
hsdlist1			org *+79

					
hscNick1			org *+4	;dta c'A',b(91),b(94,0)
hscNick2			org *+4	;dta c'T',b(91),b(96,0)
hscNick3			org *+4	;dta c'A',b(91),b(93,0)
hscNick4			org *+4	;dta c'R',b(91),c'X',b(0)
hscNick5			org *+4	;dta c'I',b(91),c'E',b(0)	
hscScore1			org *+4	;dta b($00,$20,$00),(2)	
hscScore2			org *+4	;dta b($00,$20,$00),(2)
hscScore3			org *+4	;dta b($00,$20,$00),(2)
hscScore4			org *+4	;dta b($00,$20,$00),(2)
hscScore5			org *+4	;dta b($00,$20,$00),(2)	
				
hscbuf				org *+6	
bufore3				equ hscbuf				
punkty				org *+1
punkty1				org *+1	;=10
punkty2				org *+1	;=opoznienieRed
antyairopoznienie	org *+1
flaghscore			org *+1
poziom				org *+1
sfxlicznik1			org *+1
formacja_radar		org *+1
kondycja_stan		org *+1
lives					org *+1
RadarX				org *+1
atariX1				org *+1
conLicz				org *+1		
opoz_congrat			org *+1
nick0					org *+1	;dta b(132)
kolor0				org *+1	;dta b($A0)

efnap1				org *+254
enemy				org *+6
enemyWybuch			org *+6
enemyEkran			org *+6
enemyX				org *+6
enemyX0				org *+6
enemyY				org *+6
enemyY0				org *+6
enemyDX				org *+6
enemyDX0			org *+6
enemyDY				org *+6
enemyDY0			org *+6
enemyFaza			org *+6
enemyNegatyw		org *+6
enemyBank			org *+6
enemyShapeH			org *+6
enemyLastFaza		org *+6

score					org *+3
hscore				org *+3
scorezmiana			org *+1


vblk					org *+vblk_codeend-vblk_code

_vbsnd1				equ vblk+_vbsnd1a-vblk_code
_vbsnd2				equ vblk+_vbsnd2a-vblk_code
_vbsnd3				equ vblk+_vbsnd3a-vblk_code
_vbsnd4				equ vblk+_vbsnd4a-vblk_code
_vbsnd5				equ vblk+_vbsnd5a-vblk_code
_vbsnd6				equ vblk+_vbsnd6a-vblk_code
_vbsnd7				equ vblk+_vbsnd7a-vblk_code

vb_ad					equ dli-3
vb_end				equ dli-13


dli					org *+pokey_codeend-dli_code
pokey					equ dli+pokeya-dli_code
pokey1				equ dli+pokey1a-dli_code
kolor1up				equ dli+kolor1upa-dli_code
pokey2				equ dli+pokey2a-dli_code
pokey3				equ dli+pokey3a-dli_code
;duszek4pos			equ dli+duszek4posa-dli_code
formacja_stan		equ dli+formacja_stana-dli_code
;duszek4kolor			equ dli+duszek4kolora-dli_code
pk3a					equ dli+pk3aa-dli_code
pokey4				equ dli+pokey4a-dli_code
conditionColor		equ dli+conditionColora-dli_code
conditionColor1		equ dli+conditionColor1a-dli_code
pokey_5				equ dli+pokey_5a-dli_code
radarX1				equ dli+radarX1a-dli_code
pokey5a				equ dli+pokey5aa-dli_code
pokey6				equ dli+pokey6a-dli_code
poz2lives				equ dli+poz2livesa-dli_code
poz2mlives			equ dli+poz2mlivesa-dli_code
pokey7				equ dli+pokey7a-dli_code

waitwybuch			org *+1
plusscore			org *+2
spyScore			org *+1
spyscoreX			org *+1
spyscoreY			org *+1
rads1				org *+1		;co zmazac 0->statek, 1->formacje <0 nic nie zmazuj
spyspeed			org *+1
licznikspyscore		org *+1
pociski				org *+5
pociskiTlo			org *+5
pociskiX			org *+5
pociskiX0			org *+5
pociskiY			org *+5
pociskiY0			org *+5
pociskiY1			org *+5
pociskiDX			org *+5
pociskiDX0			org *+5
pociskiDY			org *+5
pociskiDY0			org *+5
pociskiPlusX		org *+5
pociskiPlusY		org *+5
pociskiZnakX		org *+5
pociskiZnakY		org *+5

liczbaPociskow		org *+1
extraLicznik		org *+1
strzal				org *+4
strzalX				org *+4
strzalX1			org *+4
strzalX2			org *+4
strzalX3			org *+4
strzalX4			org *+4
stzralXbit			org *+4
strzalY				org *+4
strzalY1			org *+4
strzalY2			org *+4
strzalY3			org *+4
strzalYbit			org *+4
strzalKierunek		org *+4
strzalTlo			org *+4
strzalTlo1			org *+4
mwybuchyStart		org *+1
mwybuchyStop		org *+1
wybuchyStart		org *+1
wybuchyStop			org *+1
nobanner			org *+1
max_enemy			org *+1
ile_enemy			org *+1
jestSpy				org *+1
spyScoreRysuj		org *+1
punkty3				org *+1		;=opoznienieCondition
kondycja			org *+1
opozCoreA			org *+1
opozCoreB			org *+1
liczCoreA			org *+1
liczCoreB			org *+1
kat1				org *+1
kat2				org *+1
speedEnemy0			org *+1
opoz_denemy			org *+1
opoz_denemy1		org *+1
dlicz1				org *+1
opoz_dlosuj			org *+1
losuj1				org *+1
formacja_maska		org *+1
formacja_speed		org *+1
czy_6enemy			org *+1
timelevel			org *+1
rotate_speed1		org *+1
rotate_speed2		org *+1
rotate_speed1d		org *+1
rotate_speed2d		org *+1
maxPociskow			org *+1
zbiteBazy			org *+1
startX				org *+1
startY				org *+1
czasOtwarcia		org *+1
czasZamkniecia		org *+1
licznikBazyEkran	org *+1
licznikBombyEkran	org *+1
bazyEkran			org *+12		;12 baz na ekranie max
gwiazdyLicznik		org *+1
openA				org *+1
openB				org *+1
licznikJadroA		org *+1
licznikJadroB		org *+1
czyJadroA			org *+1
czyJadroB			org *+1
mryganieRadarX		org *+1
fazaWybuch			org *+1
licznikStrzal		org *+1
opoz_potrafieniu	org *+1
speedEnemy			org *+1
speech				org *+1
formacja_typ		org *+1
enrotate			org *+6
enlicznik			org *+6
formacja_zbite	org *+1
opoznieniefire	org *+1
sfire				org *+1
zmazTab			org *+8
strzalXbit			org *+4
spylicznik			org *+1
spylicznik1			org *+1
formacjaX				org *+1
forLicznik			org *+1
dowodca				org *+1
enemyPosX				org *+6
enemyPosY				org *+6
litera				org *+1
pozLitera			org *+1
duszek4kolor		org *+1
duszek4pos			org *+1
kbcode1					org *+1
pauza				org *+1
sfx_extra				org *+1
sfx_rakieta				org *+1
sfx_effect				org *+1
sfx_dzialko				org *+1
sfx_asteroid			org *+1
sfx_bomba				org *+1
sfx_wybuch				org *+1
sfx_dead				org *+1
sfx_antyair				org *+1
sfx_enemyhit			org *+1
klatki					org *+1
sjoy					org *+1
rodzajSpeech			org *+1
opoznieniePocisku		org *+1


kanal1				org *+1
petla1				org *+1
kanal2				org *+1
petla2				org *+1
kanal3				org *+1
petla3				org *+1

kanal1s				org *+2		;2 bajty , uzywamy tylko 1
kanal2s				org *+2
kanal3s				org *+2




obraz1L				org *+29
obraz1H				org *+29
obraz2L				org *+29
obraz2H				org *+29

obraz1La			org *+37
obraz1Ha			org *+37
obraz2La			org *+37
obraz2Ha			org *+37


mute_rmt			org *+24
sfx_rmt				org *+18
getSongLine_rmt		org *+18
init_rmt			org *+18
play_rmt			org *+16
skok_title			org *+10
interrupt			org *+1
run1				org *+6
run_ad	equ run1+4
run_bank	equ run1+1
go_bank				org *+25
jmp_bank			org *+15

drawDX4				org *+drawDX6_-drawDX4_
.rept	4,#
sznakX4:1			equ drawDX4+2+:1*12
maskX4:1			equ drawDX4+5+:1*12
ksztX4:1			equ drawDX4+8+:1*12
nznakX4:1			equ drawDX4+11+:1*12
.endr

drawDX6				org *+drawDY6_-drawDX6_
.rept	6,#
sznakX6:1			equ drawDX6+2+:1*12
maskX6:1			equ drawDX6+5+:1*12
ksztX6:1			equ drawDX6+8+:1*12
nznakX6:1			equ drawDX6+11+:1*12
.endr

drawDY6				org *+drawDY9_-drawDY6_
sznakY60			equ drawDY6+2
maskY60				equ drawDY6+5 
ksztY60				equ drawDY6+8
nznakY60			equ drawDY6+11

sznakY61			equ drawDY6+14
maskY61				equ drawDY6+17 
ksztY61				equ drawDY6+20
nznakY61			equ drawDY6+23

sznakY62			equ drawDY6+26
nznakY62			equ drawDY6+29

sznakY63			equ drawDY6+32
maskY63				equ drawDY6+35
ksztY63				equ drawDY6+38
nznakY63			equ drawDY6+41

sznakY64			equ drawDY6+44
maskY64				equ drawDY6+47 
ksztY64				equ drawDY6+50
nznakY64			equ drawDY6+53

sznakY65			equ drawDY6+56
nznakY65			equ drawDY6+59

petlaY6				equ drawDY6+63

sznakY60b			equ drawDY6+67
nznakY60b			equ drawDY6+70

sznakY61b			equ drawDY6+73
maskY61b			equ drawDY6+76
ksztY61b			equ drawDY6+79
nznakY61b			equ drawDY6+82

sznakY62b			equ drawDY6+85
maskY62b			equ drawDY6+88
ksztY62b			equ drawDY6+91
nznakY62b			equ drawDY6+94

sznakY63b			equ drawDY6+97
nznakY63b			equ drawDY6+100

sznakY64b			equ drawDY6+103
maskY64b			equ drawDY6+106
ksztY64b			equ drawDY6+109
nznakY64b			equ drawDY6+112

sznakY65b			equ drawDY6+115
maskY65b			equ drawDY6+118
ksztY65b			equ drawDY6+121
nznakY65b			equ drawDY6+124

drawDY9				org *+duszkiPrint_code-drawDY9_
sznakY90			equ drawDY9+2
maskY90				equ drawDY9+5
ksztY90				equ drawDY9+8
nznakY90			equ drawDY9+11

sznakY91			equ drawDY9+14
maskY91				equ drawDY9+17
ksztY91				equ drawDY9+20
nznakY91			equ drawDY9+23

sznakY92			equ drawDY9+26
nznakY92			equ drawDY9+29

sznakY93			equ drawDY9+32
maskY93				equ drawDY9+35
ksztY93				equ drawDY9+38
nznakY93			equ drawDY9+41

sznakY94			equ drawDY9+44
maskY94				equ drawDY9+47
ksztY94				equ drawDY9+50
nznakY94			equ drawDY9+53

sznakY95			equ drawDY9+56
nznakY95			equ drawDY9+59

sznakY96			equ drawDY9+62
maskY96				equ drawDY9+65
ksztY96				equ drawDY9+68
nznakY96			equ drawDY9+71

sznakY97			equ drawDY9+74
maskY97				equ drawDY9+77
ksztY97				equ drawDY9+80
nznakY97			equ drawDY9+83

sznakY98			equ drawDY9+86
nznakY98			equ drawDY9+89

petlaY9				equ drawDY9+93

sznakY90b			equ drawDY9+97
nznakY90b			equ drawDY9+100

sznakY91b			equ drawDY9+103
maskY91b			equ drawDY9+106
ksztY91b			equ drawDY9+109
nznakY91b			equ drawDY9+112

sznakY92b			equ drawDY9+115
maskY92b			equ drawDY9+118
ksztY92b			equ drawDY9+121
nznakY92b			equ drawDY9+124
		
sznakY93b			equ drawDY9+127
nznakY93b			equ drawDY9+130

sznakY94b			equ drawDY9+133
maskY94b			equ drawDY9+136
ksztY94b			equ drawDY9+139
nznakY94b			equ drawDY9+142

sznakY95b			equ drawDY9+145
maskY95b			equ drawDY9+148
ksztY95b			equ drawDY9+151
nznakY95b			equ drawDY9+154

sznakY96b			equ drawDY9+157
nznakY96b			equ drawDY9+160

sznakY97b			equ drawDY9+163
maskY97b			equ drawDY9+166
ksztY97b			equ drawDY9+169
nznakY97b			equ drawDY9+172

sznakY98b			equ drawDY9+175
maskY98b			equ drawDY9+178
ksztY98b			equ drawDY9+181
nznakY98b			equ drawDY9+184

duszkiPrint			org *+17

.IF .NOT .DEF ATARIMAX		
		.rept 12, #
			.SEGDEF fbank:1 $4000 $8000 R :1

			.SEGMENT fbank:1		
				ins 'empty.dat'
			.ENDSEG
		.endr
.ENDIF
		
		
		icl 'bank0.asm'
		icl 'bank1.asm'
		icl 'bank2.asm'
		
		icl 'bank3.asm'
		
		
		