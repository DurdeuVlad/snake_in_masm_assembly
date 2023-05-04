.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc

includelib canvas.lib
extern BeginDrawing: proc



;include snake_methods.asm
;EXTERN comparePoints:PROC
;EXTERN modifyCurrentPosition:PROC
;EXTERN spawnFood:PROC
;EXTERN checkIfFoodExistsAndSpawn:PROC
;EXTERN moveSnake:PROC
;EXTERN eatFood:PROC
;EXTERN restart:PROC
;EXTERN reactToScreenPositionAndDrawSnake:PROC


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date


window_title DB "SNAKE by Vlad Durdeu",0
area_width EQU 700
area_height EQU 700
area DD 0
screen_size EQU 10 ; dimensiunea matricei in ambele directii
screen Dd screen_size DUP (screen_size DUP (?)) ; declararea matricei
square_size EQU 30

red EQU 0FF0000h
black EQU 0000000h
white EQU 0FFFFFFh
green EQU 000FF00h
blue EQU 00000FFh
error_color EQU 0A020F0h
current_color dd 0

one dd 1
two dd 2
three dd 3
four dd 4

counter DD 0 ; numara evenimentele de tip timer

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

symbol_width EQU 10
symbol_height EQU 20


include digits.inc
include letters.inc

.code

;functia fill_matrix umple matricea cu o valoare data
fill_matrix PROC matrix:PTR WORD, value:dWORD
    push esi
    push edi
    mov esi, matrix ; incarcam adresa matricei in registru
    mov ecx, SCREEN_SIZE*SCREEN_SIZE ; numarul total de elemente din matrice
    mov edi, value ; incarcam valoarea de umplere in registru
    fill_loop:
    mul cx ; inmultim i cu dimensiunea matricei
    add di, bx ; adaugam j * 2 la di (dimensiunea unui element din matrice)
    mov WORD PTR [esi], di ; umplem elementul de la adresa [esi] cu valoarea [edi]
    add esi, 2 ; trecem la urmatorul element din matrice (de 2 bytes)
    loop fill_loop ; repetam pasii pentru urmatorul element din matrice
    pop edi
    pop esi
    ret
fill_matrix ENDP

fill_matrix_macro MACRO value
	push_all_registers
	push value
	push screen
	call fill_matrix
	add esp, 8
	pop_all_registers
ENDM

push_all_registers MACRO
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
ENDM

pop_all_registers MACRO
	pop eax
	pop ebx
	pop ecx
	pop edx
	pop esi
	pop edi
ENDM
	
set_position_macro MACRO matrix, i, j, value
	push_all_registers
	push value
	push j
	push i
	push matrix
	call set_position
	add esp, 16
	pop_all_registers
ENDM

;functia set_position seteaza valoarea unui element de la pozitia (i, j) in matrice
set_position PROC matrix:PTR WORD, i:DWORD, j:DWORD, value:Dword
    push eax
    push ebx
    push ecx
    push edx
    mov eax, i ; incarcam valoarea i in eax
    mov ebx, j ; incarcam valoarea j in ebx
    mov ecx, SCREEN_SIZE ; incarcam dimensiunea matricei in ecx
    mul ecx ; inmultim i cu dimensiunea matricei
    add eax, ebx ; adunam j la rezultatul inmultirii
    shl eax, 1 ; inmultim rezultatul cu 2 pentru ca fiecare element din matrice ocupa 2 bytes
    ;add matrix, eax ; adaugam offset-ul calculat la adresa de inceput a matricei
	mov ebx, value
    mov [eax], ebx ; setam valoarea la adresa calculata
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
set_position ENDP

get_position_macro MACRO matrix, i, j
	push_all_registers
	push value
	push j
	push i
	push matrix
	call get_position
	add esp, 16
	push matrix
	pop_all_registers
ENDM
;functia get_position returneaza valoarea unui element de la pozitia (i, j) in matrice
get_position PROC matrix:PTR WORD, i:dWORD, j:dWORD
    push eax
    push ebx
    push ecx
    mov eax, i ; incarcam valoarea i in eax
    mov ebx, j ; incarcam valoarea j in ebx
    mov ecx, SCREEN_SIZE ; incarcam dimensiunea matricei in ecx
    mul ecx ; inmultim i cu dimensiunea matricei
    add eax, ebx ; adunam j la rezultatul inmultirii
    shl eax, 1 ; inmultim rezultatul cu 2 pentru ca fiecare element din matrice ocupa 2 bytes
    add matrix, eax ; adaugam offset-ul calculat la adresa de inceput a matricei
    movzx eax, WORD PTR [matrix] ; incarcam valoarea de la adresa calculata in eax, folosind movzx pentru a extinde zero semnificativi
    pop ecx
    pop ebx
    pop eax
    ret
get_position ENDP
; do not forget to save eax
turn_screen_code_color MACRO code
	push ebx
	push ecx
	
	MOV ebx, code
	mov ecx, 0
	CMP ebx, ecx    
	JLE fill_a_screen_white 
    inc ecx	
	CMP ebx, ecx    
	JLE fill_a_screen_black  
	inc ecx
	CMP ebx, ecx    
	JLE fill_a_screen_green  
	inc ecx
	CMP ebx, ecx    
	JLE fill_a_screen_blue
	inc ecx
	inc ecx
	CMP ebx, ecx    
	JLE fill_a_screen_red  	
	
	fill_a_screen_error:
		mov current_color, [error_color]
		make_text_macro 'E', area, 500, 100
		make_text_macro 'R', area, 510, 100
		make_text_macro 'R', area, 520, 100
		make_text_macro 'O', area, 530, 100
		make_text_macro 'R', area, 540, 100
		jmp fill_a_screen_end
	fill_a_screen_white:
		mov current_color, [white]
		make_text_macro 'W', area, 500, 100
		make_text_macro 'H', area, 510, 100
		make_text_macro 'I', area, 520, 100
		make_text_macro 'T', area, 530, 100
		make_text_macro 'E', area, 540, 100
		jmp fill_a_screen_end
	fill_a_screen_black:
		mov current_color, [black]
		make_text_macro 'B', area, 500, 100
		make_text_macro 'L', area, 510, 100
		make_text_macro 'A', area, 520, 100
		make_text_macro 'C', area, 530, 100
		make_text_macro 'K', area, 540, 100
		jmp fill_a_screen_end
	fill_a_screen_green:
		mov current_color, [green]
		jmp fill_a_screen_end
		make_text_macro 'G', area, 500, 100
		make_text_macro 'R', area, 510, 100
		make_text_macro 'E', area, 520, 100
		make_text_macro 'E', area, 530, 100
		make_text_macro 'N', area, 540, 100
	fill_a_screen_red:
		mov current_color, [red]
		make_text_macro 'R', area, 500, 100
		make_text_macro 'E', area, 510, 100
		make_text_macro 'D', area, 520, 100
		jmp fill_a_screen_end
	fill_a_screen_blue:
		mov current_color, [blue]
		make_text_macro 'B', area, 500, 100
		make_text_macro 'L', area, 510, 100
		make_text_macro 'U', area, 520, 100
		make_text_macro 'E', area, 530, 100
		jmp fill_a_screen_end
	
	fill_a_screen_end:
	pop ecx
	pop ebx
endm


fill_a_screen MACRO
	push eax
    push ebx
	push ecx
	push edx
	push esi
	push edi

	mov ecx, screen_size	; Load screen_size into ECX for outer loop
	mov edx, square_size
	mov esi, 0                 ; Initialize i to 0

	fill_a_screen_outer_loop:
    mov edi, 0             ; Initialize j to 0

    fill_a_screen_inner_loop:
        ; inner loop body
		push eax
		push ebx
		push edx
		push ecx
		
		mov ebx, square_size
		mov eax, esi
		MUL ebx
		sub eax, esi
		mov ecx, eax
		
		mov eax, edi
		mov ebx, square_size
		mul ebx
		mov ebx, eax

		mov eax, edi
		mul esi
		shl eax, 2
		add eax, screen
		turn_screen_code_color [EAX]
		;mov eax, [blue]
		
		draw_square ecx, ebx, current_color
		
		pop ecx
		pop edx
		pop ebx
		pop eax
		
        inc edi           ; Increment j
        cmp edi, ecx      ; Compare j with screen_size
        jl fill_a_screen_inner_loop     ; Jump to inner_loop if j < screen_size

    inc esi               ; Increment i
    cmp esi, ecx          ; Compare i with screen_size
    jl fill_a_screen_outer_loop         ; Jump to outer_loop if i < screen_size
	
	
	pop edi
	pop esi
	pop edx
    pop ecx
    pop ebx
    pop eax
ENDM

; functia asta poate are probleme
fill_a_matrix MACRO matrix, MAX, value
	push eax
    push ebx
	push ecx
	push edx
	push edi
	push esi
	mov eax, matrix
	mov edx, 1
	mov ecx, MAX
      

	mov esi, 0 ; init i to 0
	mov ecx, MAX
	fill_a_matrix_outer_loop:
	mov edi, 0             ; Initialize j to 0

    fill_a_matrix_inner_loop:
        ; inner loop body
		push eax
		push ebx
		push edx
		push ecx
		
		;put the code here
		
		mov eax, esi
		add eax, edi
		shl eax, 2
		add eax, matrix
		mov [eax], value
		
		
		pop ecx
		pop edx
		pop ebx
		pop eax
		
        inc edi           ; Increment j
        cmp edi, ecx      ; Compare j with screen_size
        jl fill_a_matrix_inner_loop     ; Jump to inner_loop if j < screen_size

    inc esi               ; Increment i
    cmp esi, ecx          ; Compare i with screen_size
    jl fill_a_matrix_outer_loop         ; Jump to outer_loop if i < screen_size
	
	
	pop esi
	pop edi
	pop edx
    pop ecx
    pop ebx
    pop eax
ENDM



; functia asta functioneaza cum trebuie
draw_square MACRO x:REQ, y:REQ, color:REQ
    push eax
    push ebx
	push ecx
	push edx
    mov eax, y
	mov ebx, area_width
	mul ebx ; EAX = y * area_width
	add eax, x ; EAX = y * area_width + x
	shl eax, 2 ; EAX = (y * area_width + x)*4
	add eax, area
	
	mov edx, 1
	mov ecx, square_size
	add eax, 4*area_width
	LOOP_BIG:
	push edx
	
	push ebx
	mov ebx, [color]
	mov [eax], ebx
	pop ebx
	
	mov edx, 1
	mov ecx, square_size
	LOOP_START:        
    ; body of the loop goes here
	mov ebx, edx
	shl ebx, 2	
	add eax, ebx
	push ebx
	mov ebx, [color]
	mov dword ptr[eax], ebx
	pop ebx
	sub eax, ebx
    INC edx         
    CMP edx, ecx    
    JLE LOOP_START  
	
	;mov edx, 1
	;LOOP_START2:        
    ; body of the loop goes here
	;mov ebx, edx
	;shl ebx, 2	
	;sub eax, ebx	
	;mov dword ptr[eax], 0FF0000h
	;add eax, ebx
    ;INC edx         
    ;CMP edx, ecx    
    ;JLE LOOP_START2
	
	mov ecx, square_size
	add eax, 4*area_width
	pop edx
	INC edx         
    CMP edx, ecx    
    JLE LOOP_BIG
    pop edx
    pop ecx
    pop ebx
    pop eax
ENDM

reset_area MACRO
	push eax
    push ebx
	push ecx
	push edx
	
	
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	
	
	pop edx
    pop ecx
    pop ebx
    pop eax
ENDM

; this doesnt work
reset_screen MACRO value:REQ
	push eax
    push ebx
	push ecx
	push edx
	
	mov eax, screen_size
	mov ebx, screen_size
	mul ebx
	shl eax, 2
	push eax
	push value
	push screen
	call memset
	add esp, 12
	
	pop edx
    pop ecx
    pop ebx
    pop eax
ENDM
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0FFFFFFh
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp

; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm

; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	reset_area
	jmp afisare_litere
	
evt_click:
    reset_area
	;fill_a_matrix screen screen_size one
	fill_a_screen
	;turn_screen_code_color 5
	;draw_square [ebp+arg2], [ebp+arg3], current_color
	;mov eax, [ebp+arg3] ; EAX = y
	;mov ebx, area_width
	;mul ebx ; EAX = y * area_width
	;add eax, [ebp+arg2] ; EAX = y * area_width + x
	;shl eax, 2 ; EAX = (y * area_width + x)*4
	;add eax, area
	jmp afisare_litere
	
evt_timer:
	inc counter
	
	
afisare_litere:
	;afisam valoarea counter-ului curent (sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 30, 10
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 20, 10
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 10, 10
	
	;scriem un mesaj

final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp





start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	
	
	mov eax, screen_size
	mov ebx, screen_size
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov screen, eax	
	fill_matrix_macro 2
	
	
	;reset_screen two
	;fill_a_matrix screen, screen_size, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start
