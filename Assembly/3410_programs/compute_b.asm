.386
.MODEL FLAT

m 				EQU [ebp + 14]
n 				EQU [ebp + 12]
points  		EQU [ebp + 8]

denominator 	 EQU 	 [ebp - 4]
left_hand_value  EQU     [ebp - 8]
right_hand_value EQU     [ebp - 12]

PUBLIC compute_b

INCLUDE debug.h
INCLUDE io.h
INCLUDE float.h

.DATA
float 			 REAL4 ? ; used temporaryly

.CODE
compute_b_rec PROC NEAR32
setup:
	; f[xn...xm] = (f[xn...xm + 1] - f[xn - 1...xm])/(xn - xm)
	push ebp
	mov	 ebp, esp
	mov ebx , points

comp_for_base_case:
	mov ax , n
	cmp ax , m
	jne for_denominator

base_case:
	mov eax , 0 ; initialize 
	mov ax , n

	mov dx , 8
	mul dx

	cbw

	add ebx , eax
	add ebx , 4
	mov eax , [ebx]
	mov float , eax

	fld float ; noneed


	jmp DONE

for_denominator:
	mov ecx , ebx
	mov eax , 0
	mov ax , n
	mov dx , 8
	mul dx
	cbw
	add ecx , eax
	mov eax , [ecx]
	mov float , eax
	fld float
	
	mov ecx , ebx
	mov eax , 0
	mov ax , m
	mov dx , 8
	mul dx
	cbw
	add ecx , eax
	mov eax , [ecx]
	mov float , eax
	fld float
		

	fsub

	fstp REAL4 PTR denominator

	push denominator

rec: 
	; f[xn...xm] = (f[xn...xm + 1] - f[xn - 1...xm])/(xn - xm)
	; setup for f[xn...xm + 1]
	mov ax , m
	inc ax
	mov dx , n

	push	ax 		; m
	push	dx 		; n
	push	points	; points array

	call 	compute_b_rec 	; call recursive function
	fstp 	REAL4 PTR left_hand_value ; store the value in left_hand_value

	; set up for f[xn - 1...xm]
	mov ax , n
	dec ax
	mov dx , m

	push dx		; m
	push ax		; n
	push points ; points array

	call 	compute_b_rec
	fstp 	REAL4 PTR right_hand_value ; store the value in right_hand_value

	; (f[xn...xm + 1] - f[xn - 1...xm])
	fld REAL4 PTR left_hand_value
	fld REAL4 PTR right_hand_value
	fsub ; ST(1) - ST, the numerator for next calculation will be remained in the stuck
	
	fld REAL4 PTR denominator
	fdiv ; ST(1) / ST

DONE:

	mov     esp, ebp         
	pop		ebp

	ret 
compute_b_rec ENDP



compute_b	PROC	NEAR32
; entry code
	push ebp
	mov ebp , esp

	pushd  0         
	pushd  0
	pushd  0
	
; process

	push m
	push n
	push points

	call compute_b_rec ;  n , m , points
	
	; result in st(0)

; exit code

	mov esp , ebp	
	pop ebp
	ret 8
	
compute_b ENDP

END 
