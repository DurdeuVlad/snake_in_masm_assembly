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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "SNAKE by Vlad Durdeu",0
area_width EQU 640
area_height EQU 480
area DD 0

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

draw_square MACRO x:REQ, y:REQ
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
	mov ecx, 40
	add eax, 4*area_width
	LOOP_BIG:
	push edx
	mov dword ptr[eax], 0FF0000h
	
	mov edx, 1
	mov ecx, 40
	LOOP_START:        
    ; body of the loop goes here
	mov ebx, edx
	shl ebx, 2	
	add eax, ebx
	mov dword ptr[eax], 0FF0000h
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
	
	mov ecx, 40
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
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	jmp afisare_litere
	
evt_click:
	draw_square [ebp+arg2], [ebp+arg3]

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
	make_text_macro 'P', area, 110, 100
	make_text_macro 'R', area, 120, 100
	make_text_macro 'O', area, 130, 100
	make_text_macro 'I', area, 140, 100
	make_text_macro 'E', area, 150, 100
	make_text_macro 'C', area, 160, 100
	make_text_macro 'T', area, 170, 100
	
	make_text_macro 'L', area, 130, 120
	make_text_macro 'A', area, 140, 120
	
	make_text_macro 'A', area, 100, 140
	make_text_macro 'S', area, 110, 140
	make_text_macro 'A', area, 120, 140
	make_text_macro 'M', area, 130, 140
	make_text_macro 'B', area, 140, 140
	make_text_macro 'L', area, 150, 140
	make_text_macro 'A', area, 160, 140
	make_text_macro 'R', area, 170, 140
	make_text_macro 'E', area, 180, 140

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
