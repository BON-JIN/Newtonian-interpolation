.NOLIST
.386

EXTRN compute_b:Near32


; result in st(0)

.CODE
compute_b_proc		MACRO	n , m , points

	; backwords for parameters

	push eax
	push ebx
	push ecx
	push edx
	pushf

	push m
	push n
	push points

	call compute_b


	popf
	pop edx
	pop ecx
	pop ebx
	pop eax
ENDM

.NOLISTMACRO
.LIST