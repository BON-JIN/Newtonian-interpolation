.NOLIST
.386
INCLUDE float.h

EXTRN interpolate:Near32

.CODE


interpolate_header	MACRO	x_cordinate , degree , points

	lea ebx , points

	fld x_cordinate ; use fld otherwise using push makes value changed
	push degree
	push ebx
	
	call interpolate

ENDM

.NOLISTMACRO
.LIST