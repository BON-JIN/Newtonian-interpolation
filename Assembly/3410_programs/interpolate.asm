.386
.MODEL FLAT

;x_cordinate EQU [ebp + 16]
degree 		EQU [ebp + 12]
points_addr EQU [ebp + 8]

PUBLIC interpolate

INCLUDE debug.h
INCLUDE io.h
INCLUDE float.h
INCLUDE sort_points.h
INCLUDE compute_b_proc.h

.DATA

float 		REAL4  ? ; used temporaryly
x_cordinate REAL4  ? ; never changed
first REAL4  1.000	; never changed 
m WORD 0	; never changed in here

.CODE

interpolate PROC NEAR32

	fstp REAL4 PTR x_cordinate

	push ebp
	mov ebp , esp

	; initialize all registers here
	mov eax , 0
	mov ebx , 0 
	mov ecx , 0
	mov edx , 0

	mov ebx , points_addr
	mov cx , 0
	mov cx , 0
	mov dx , 0  	 ; m


for_b_0:
	; get b_0
	compute_b_proc cx , m , points_addr
	inc cx
	;ｆ(x)＝ｃ0 ＋ ｃ1(x - x_0) ＋ ｃ2(x - x_0)(x - x_1)＋ ・・・ ＋ ｃn(x - x_0)(x - x_1)・・・(x - x_n-1）

get_next_b_n: ; where n > 0
	mov ebx , points_addr
	mov dx , 0

	compute_b_proc cx , m , points_addr 
	fld  first ; always 1 for first multiply
	
for_independent:
	; (x - x_0)
	mov eax , [ebx]
	mov float , eax

	fld REAL4 PTR x_cordinate
	fld float

	fsub
	fmul

	add ebx , 8
	inc dx

	cmp dx , cx
	je finish

	jmp for_independent
finish:

	fmul
	fadd
	inc cx
	cmp cx , degree
	jle get_next_b_n

DONE:

	mov esp , ebp
	pop ebp
	ret	4
interpolate ENDP

END 
