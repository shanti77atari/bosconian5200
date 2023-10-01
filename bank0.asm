//bank0, 12 bank pamięci

		org $4000	
		dta b($d0)		;nr banku $bfd0	
		
		:255 dta b(0)	//wyrównanie do strony
		
enemy1shapetab	
		ins '/sprites/enemy1shapetab.dat'
enemy2shapetab
		ins '/sprites/enemy2shapetab.dat'
enemy3shapetab
		ins '/sprites/enemy3shapetab.dat'
enemy4shapetab
		ins '/sprites/enemy4shapetab.dat'		
enemy5shapetab
		ins '/sprites/enemy5shapetab.dat'
explo_shapeTab
		ins '/sprites/explo_shapetab.dat'
				
		ins '/sprites/enemy1shape.dat'		
		ins '/sprites/enemy2shape.dat'		
		ins '/sprites/enemy3shape.dat'		
		ins '/sprites/enemy4shape.dat'		
		ins '/sprites/enemy5shape.dat'		
		ins '/sprites/enemy12mask.dat'		
		ins '/sprites/enemy34mask.dat'		
		ins '/sprites/enemy5mask.dat'		
		ins '/sprites/exploShape.dat'	
		ins '/sprites/exploMask.dat'
bonusShapeTab		
		ins '/sprites/bonusShapeTab.dat'
		ins '/sprites/bonusShape.dat'
		ins '/sprites/bonusMask.dat'
		
		icl 'duszki3.asm'
		
		
		
		
e0		equ *
		:$c000-e0 dta b(0)
		