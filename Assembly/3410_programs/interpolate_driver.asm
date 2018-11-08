.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE debug.h
INCLUDE io.h
INCLUDE float.h
INCLUDE sort_points.h
INCLUDE interpolate_header.h
INCLUDE compute_b_proc.h

MAX         EQU    20

.STACK 4096

MAX_CONTAINER EQU 150
BUFFER_SIZE	EQU	30

.DATA
points_array	REAL4  2*MAX DUP (?) 


float		REAL4  ?
x_cordinate REAL4  ?
result 		REAL4  ?
tol			REAL4  0.0001

sz 	   WORD ?  
value  WORD ?
degree WORD ?

prompt_Newton 		BYTE "<<<	Newtons interpolating polynomials	>>>", CR , LF, 0
prompt_dashes 		BYTE "   --------------------------------------------", CR , LF, 0
prompt_x_cordinate  BYTE "Enter the x-coordinate of the desired interpolated y.", CR, LF, 0
prompt_degree 		BYTE "Enter the degree of the interpolating polynomial.", CR, LF, 0
prompt_instrunction BYTE "You may enter up to 20 points, one at a time.", CR, LF, "Input q to quit.", CR, LF, 0
prompt_sorted 		BYTE "The cordinates are sorted as bellow.", CR, LF, 0

val         BYTE     10 DUP(?), 0
new_line    BYTE     CR, LF, 0
txt         BYTE     10 DUP(?), 0

.CODE
print_float MACRO float
	ftoa float, WORD PTR 3, WORD PTR 6, txt
	output txt
	output new_line
	output new_line
ENDM

print_result MACRO float
	ftoa float, WORD PTR 10, WORD PTR 10, txt
	output txt
	output new_line
	output new_line
ENDM


input_proess MACRO
	local input_while_loop, DONE

	output 	prompt_x_cordinate
	input 	val, 8
	output 	val
	output 	new_line

	atof val, float
	mov eax , float
	mov x_cordinate , eax

	output 	prompt_degree
	input 	val, 8
	atoi 	val
	mov 	degree , ax
	output 	val
	output 	new_line

	output 	prompt_instrunction

	lea 	ebx , points_array
	mov 	sz , 0 ; make sure size initialized to be 0
input_while_loop:
	input 	val, 8
	output 	val
	cmp 	val , 'q'
	je 	DONE

	output 	new_line
	atof 	val, float
	mov 	eax , float
	mov    	DWORD PTR [ebx], eax
	inc 	sz
	add 	ebx , 4
	loop 	input_while_loop
DONE:
	output new_line
	output new_line

	; because x and y is paired sz needs to be the half size of inputs
	mov ax , sz
	mov dx , 0
	mov bx , 2
	div bx
	mov sz , ax
ENDM


_start:
	output new_line
	output prompt_dashes
	output prompt_Newton
	output prompt_dashes
	output new_line

	input_proess

	sort_points points_array, x_cordinate ,tol, sz

	output prompt_sorted

	output new_line
	print_points points_array, sz
	

	output new_line

	interpolate_header x_cordinate , degree , points_array
	fstp result
	print_result result
	output new_line

	INVOKE ExitProcess, 0
PUBLIC _start
	END 