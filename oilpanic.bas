dim frame,lastframe,tics,score as uinteger
dim i,f,lastkey,dropcol,dropcount,temp,missup,missdown as ubyte
dim inc as byte
dim nn as integer
dim down(4,1) as ubyte => {{1,0},{7,53},{8,18},{9,18},{10,53}}
dim up(7,1) as ubyte => {{3,0},{0,9},{1,9},{2,9},{3,9},{4,9},{5,9},{6,9}}
dim gota(5,1) as ubyte => {{1,0},{11,22},{12,22},{13,22},{14,22},{15,22}}
#include "oil_sprites.bas"
#include "oil_sounds.bas"


'70908 t-states per frame'


border 0
score=0

newgame:

tics=0
dropcol=int(rnd*3)
dropcount=0
missup=0
missdown=0
inc=1
for n=0 to 14
	copy(n,0)=0
next n
screen()

tile(19,$40)
tile(22,$40)
tileFast(7,13,29,$40)
print7seg(score)

dim z as ubyte
z=0
do
	nn=nn+inc
	if nn=7 then
		inc = -1
		nn=5
	end if
	if nn=-1 then 
		inc=1
		nn=1
	end if
	tile(nn+9,$40)	

	do
	z=z+1
	wait(1)
	readkeyboard()
	loop until lastkey>0 or z>20
	z=0
loop until lastkey>0

tileDelete(12,$40)
score=0
print7seg(score)
tile(down(1,0)-5,$40)

do 

i=down(0,0)
down(0,1)=down(0,1)+1
if down(0,1)>=correction(down(bucle(i),1))
	down(0,1)=0
	i=i+1
	if i=7 then i=1
	down(0,0)=i
	tile(down(bucle(i),0)-5,$40)
end if


'DROP Sprite -------------------------------------------------
	i=gota(0,0):'Estoy en el sprite i'
	gota(0,1)=gota(0,1)+1
	if gota(0,1)>=correction(gota(i,1))
		
		i=i+1
		if i=ubound(gota,1)+1 then i=0
		gota(0,0)=i
		gota(0,1)=0
		
		if i>1 then 
			if i=2 then temp=0 else temp=1
			sound(dropcount)
			tileFast(dropcol*7+7,i-2,temp,$40)	
		end if
		

		if i=0 then
			tileDelete(0,$40)
			if up(0,0)-3=dropcol
				sound(3)
				dropcount=dropcount+1
				if dropcount=4 then 
					fuego(dropcol*7+5)
				else
					if score<999 then incscore()

				end if
			else
				fuego(dropcol*7+5)
			end if	
			dropcol=int(rnd*3)
		end if
	end if




'UP Sprite -------------------------------------------------
	up(0,1)=up(0,1)+1:if up(0,1)>up(1,1) then up(0,1)=up(1,1)	
	if lastkey>0 and up(0,1)>=correction(up(1,1))
		i=up(0,0):'Estoy en el sprite i'
		if lastkey=code("o")
			i=i-1: if i=0 then i=1
		else if lastkey=code("p")
			i=i+1: if i=ubound(up,1)+1 then i=ubound(up,1)		
		end if
		lastkey=0
		up(0,0)=i
		up(0,1)=0
		if i=2 or i=6
			tileDelete(4,$40)
		end if
	end if

	dim t,x as ubyte 
	t=up(up(0,0),0)+9
	tile(t,$40)		

	if dropcount>0 and t>10 and t<14
		x=spritexy(t,0)
		if dropcount=1  	
			tileFast(x,5,18,$40)
		else if dropcount=2 
			tileFast(x,5,17,$40)
		else if dropcount=3
			tileFast(x,5,16,$40)
		end if
	end if



	if dropcount>0
		if up(0,0)=1
			if down(0,0)=1
				tileFast(0,13,26,$40)
				if dropcount=3 then dropcount=4				
				for n=1 to dropcount
					if score<999 then incscore()
					sound(3)
					wait(10)
				next n
				if dropcount=3 then incscore():sound(3):wait(10)
				tileDelete (8,$40)
			else
				sr()
			end if
			dropcount=0
		end if
		
		if up(0,0)=7
			if down(0,0)=4
				tileFast(28,13,26,$40)
				if dropcount=3 then dropcount=4
				for n=1 to dropcount
					if score<999 then incscore()
					sound(3)
					wait(10)
				next n
				tileDelete (8,$40)
			else
				srta()
			end if
			dropcount=0
			

		end if
	end if

	do
	readkeyboard()
	frame=256*peek 23673+peek 23672
	loop until (frame-lastframe)>0 
		
	lastframe=256*peek 23673+peek 23672
	tics=tics+1
	
loop

sub readkeyboard()
	lastkey=code(inkey$())
end sub


sub tile(sp as ubyte, mem as ubyte)
	tileFast(spritexy(sp,0),spritexy(sp,1), sp, mem)
end sub 

sub tileFast(x as ubyte, y as ubyte, sp as ubyte, mem as ubyte)
	dim tipo as ubyte
	tipo= sprite(sp,3)
	if (x<>copy(tipo,1) or y<>copy(tipo,2) or sp<>copy(tipo,3) or copy(tipo,0)=0)
		if copy(tipo,0)=1
			tilexy(copy(tipo,1), copy(tipo,2), sprite(copy(tipo,3),0),sprite(copy(tipo,3),1),@sprites+sprite(copy(tipo,3),2),mem)
		end if
		tilexy(x,y,sprite(sp,0),sprite(sp,1),@sprites+sprite(sp,2),mem)
		copy(tipo,0)=1 
		copy(tipo,1)=x
		copy(tipo,2)=y
		copy(tipo,3)=sp
	end if
end sub 

sub tileFastSin(x as ubyte, y as ubyte, sp as ubyte, mem as ubyte)
	tilexy(x,y,sprite(sp,0),sprite(sp,1),@sprites+sprite(sp,2),mem)
end sub 

sub tileDelete(tipo as ubyte,mem as ubyte)
		if copy(tipo,0)=1
			tilexy(copy(tipo,1), copy(tipo,2), sprite(copy(tipo,3),0),sprite(copy(tipo,3),1),@sprites+sprite(copy(tipo,3),2),mem)
			copy(tipo,0)=0
			copy(tipo,1)=0
			copy(tipo,2)=0
			copy(tipo,3)=0	
		end if
end sub

sub tilexy(x as ubyte, y as ubyte,lx as ubyte, ly as ubyte, addr as uinteger,mem as ubyte)
poke 60000,x:'c
poke 60001,y:'b
poke 60002,lx
poke 60003,ly
poke uinteger 60004,addr
poke 60006,mem
asm
			di
			push ix
			ld ix,60000
			ld b,(ix+1);y
			ld c,(ix+0);x
			ld e,(ix+4)
			ld d,(ix+5)

			sigline:
			push bc
			call dfloc
			ld b,8
			sigscan:
				push bc
				ld b,(ix+2)
				push hl
				scanline:
					ld a,(de)
					xor (hl)
					ld (hl),a
					inc hl
					inc de
				djnz scanline
				pop hl
				inc h
				pop bc
			djnz sigscan
			pop bc
			inc b	
			ld a,(ix+3)
			add a,(ix+1)
			cp b
			jr nz, sigline
			pop ix
			ei
	jr fin

dfloc:
	ld a,b
	and $f8
	ld hl,60006
	add a,(hl);$e5 o $40
	ld h,a
	ld a,b
	and 7
	rrca
	rrca
	rrca
	add a,c
	ld l,a
	ret
fin:
end asm
end sub

sub wait(fr as ubyte)
	dim n as ubyte
	for n=0 to fr
		asm 
			halt
		end asm
	next n
end sub

sub fuego (x as ubyte)
	dim n as ubyte
	tileDelete(0,$40)
	for n=1 to 3
		if n<3 then sound(4)
		tileFast(x,9,6,$40)
		wait(54)
		if n=1 then sound(4)
		tileFast(x,8,7,$40)
		wait(27)
		if n=1 then sound(4)
		tileFast(x-1,7,8,$40)
		wait(27)
		tileDelete(9,$40)
		tileDelete(10,$40)
		tileDelete(11,$40)
	next n	
	dropcount=0
	tileDelete(4,$40)
	missup=missup+1
	tileFastSin(24+missup*2,0,28,$40)
	
	if missup=3
	 	goto newgame
	end if	
	

end sub

sub srta()
	dim n as ubyte
	tileFast(28,17,26,$40)
	sound(4)
	wait(54)
	tileFast(28,23,25,$40)
	wait(27)
	tileDelete(8,$40)
	for n=1 to 3
		sound(4)
		tile(20,$40)
		wait(27)
		tile(21,$40)
		wait(27)
	next n
	tile(19,$40)
	tileDelete (7,$40)
	missdown=missdown+1
	gota(0,0)=0
	tileDelete(0,$40)
	tileFastSin(24+missdown*2,2,27,$40)
	if missdown=3
	 	goto newgame
	end if	
end sub

sub sr()
	dim n as ubyte
	tileFast(0,17,26,$40)
	sound(4)
	wait(54)
	tileFast(0,23,25,$40)
	wait(27)
	tileDelete(8,$40)
	for n=1 to 3
		sound(4)
		tile(23,$40)
		wait(27)
		tile(24,$40)
		wait(27)
	next n
	tile(22,$40)
	tileDelete (7,$40)
	missdown=missdown+1
	gota(0,0)=0
	tileDelete(0,$40)
	tileFastSin(24+missdown*2,2,27,$40)
	if missdown=3
	 	goto newgame
	end if	
	
end sub

sub print7seg(s as uinteger)
	dim ss as string
	dim s1 as ubyte
	poke uinteger 23675,@sprites+4344
	ss=str(s)
	ss="000"+ss
	s1=code(ss(len(ss)-1))-48

	print at 1,3;ink 7;paper 0; chr(144+s1*2)
	print at 2,3;ink 7;paper 0; chr(145+s1*2)
	s1=code(ss(len(ss)-2))-48
	print at 1,2;ink 7;paper 0; chr(144+s1*2)
	print at 2,2;ink 7;paper 0; chr(145+s1*2)
	s1=code(ss(len(ss)-3))-48
	print at 1,1;ink 7;paper 0; chr(144+s1*2)
	print at 2,1;ink 7;paper 0; chr(145+s1*2)
end sub




