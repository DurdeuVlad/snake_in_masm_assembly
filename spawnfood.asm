.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date

.code
; to be tested
reactToScreenPositionAndDrawSnake MACRO
    LOCAL L1, L2, L3, L4, ENDIF1
	pusha
    mov ecx, [snake]
    mov eax, [ecx+4]
    dec eax
    mov ebx, [ecx+eax*8+12]
    mov edx, [ecx+eax*8+16]
    cmp word ptr [screen+edx*MAX*2+ebx*2], 5
    jne L1
    eatFood
    eatFood
    spawnFood
L1:
    mov ecx, [snake]
    mov eax, [ecx+4]
    dec eax
    mov ebx, [ecx+eax*8+12]
    mov edx, [ecx+eax*8+16]
    cmp word ptr [screen+edx*MAX*2+ebx*2], 1
    je ENDIF1
    cmp word ptr [screen+edx*MAX*2+ebx*2], 2
    jne L2
L3:
    push OFFSET GameOverMsg ; print "Game Over"
    call printf
    add esp, 4
    mov eax, 1 ; return 1;
L4:
    ret

L2:
    mov ecx, [snake]
    mov ebx, [ecx+eax*8+12]
    mov edx, [ecx+eax*8+16]
    mov esi, eax ; i = snake->length-1;
L5:
	cmp esi, 1 ; i > 1;
	jle ENDIF1

	push ecx ; comparePoints(snake->body[i], snake->body[0])
	push OFFSET [ecx+esi*8] ; snake->body[i]
	push OFFSET [ecx] ; snake->body[0]
	call comparePoints ; returns ZF=0 if points are equal.
	add esp, 12

	jnz L6 ; overlaps--;
	dec dword ptr overlaps

	mov ebx,[ecx+esi*8+12] ; screen[snake->body[i].x][snake->body[i].y]
	mov edx,[ecx+esi*8+16]

	cmp word ptr [screen+edx*MAX*2+ebx*2], 2 ; screen[snake->body[i].x][snake->body[i].y] != 2 ?
	jne L7 ; if not jump to L7

	mov word ptr [screen+edx*MAX*2+ebx*2], 3 ; screen[snake->body[i].x][snake->body[i].y] = 3;

L7:
	dec esi ; i--;
	jmp L5

L6:
	cmp dword ptr overlaps,0 ; if(overlaps>=0)
	jl L3 ; else jump to L3

	mov ebx,[ecx+esi*8+12] ; screen[snake->body[i].x][snake->body[i].y]
	mov edx,[ecx+esi*8+16]

	mov word ptr [screen+edx*MAX*2+ebx*2], 3 ; screen[snake->body[i].x][snake->body[i].y] = 3;

ENDIF1:
	xor eax,eax ; return 0;
	popa
ENDM


; to be tested
eatFood MACRO
    LOCAL L1, L2, L3, L4, ENDIF1
	pusha
    mov ecx, [snake]
    mov eax, [ecx+4]
    dec eax
    mov ebx, [ecx+eax*8+12]
    mov edx, [ecx+eax*8+16]
    cmp byte ptr [ecx+eax*8+20], 'd'
    jne L1
    mov edx, [ecx+eax*8+16]
    dec edx
    jmp L2
    L1:
    cmp byte ptr [ecx+eax*8+20], 'a'
    jne L3
    mov edx, [ecx+eax*8+16]
    inc edx
    jmp L2
    L3:
    cmp byte ptr [ecx+eax*8+20], 's'
    jne L4
    mov edx, [ecx+eax*8+12]
    dec edx
    jmp L2
    L4:
    cmp byte ptr [ecx+eax*8+20], 'w'
    jne ENDIF1
    mov edx, [ecx+eax*8+12]
    inc edx
L2:
	mov eax, [ecx+4]
	inc eax
	mov [ecx+4], eax
	push eax
	push 8
	call realloc
	add esp, 8
	mov ebx, [ecx+4]
	dec ebx
	mov eax, [ecx]
	lea edx, [eax+ebx*8]
	mov [edx], edx
	popa
ENDIF1:
ENDM


; to be tested
moveSnake MACRO new_pos
	Local L1, L2
	pusha
    mov ecx, [snake]
    mov edx, [new_pos]
    mov eax, [ecx+4]
    dec eax
    L1:
        cmp eax, 0
        jle L2
        mov ebx, [ecx+eax*8+12]
        mov [ecx+eax*8+20], ebx
        dec eax
        jmp L1
    L2:
    mov [ecx+12], edx
	popa
ENDM
; to be tested
clearScreenOfSnake MACRO
	local L1, L2
	pusha
    mov ecx, zero
    mov ebx, MAX
    mov edx, MAX
    mov esi, snake
    mov eax, [esi]
    mov edi, screen
    L1:
        cmp ecx, [eax+4]
        jge L2
        mov ebx, [eax+ecx*8]
        mov edx, [eax+ecx*8+4]
		push eax
		mov eax, ebx
		mul MAX
		mov ebx, eax
		pop eax
        mov [edi+ebx+edx], zero
        inc ecx
        jmp L1
    L2:
	popa
ENDM
; to be tested
comparePoints MACRO p1, p2
    LOCAL L1, L2, ENDIF1
    pusha
    mov ecx, [p1]
    mov edx, [p2]
    cmp dword ptr [ecx], [edx]
    jne ENDIF1
    cmp dword ptr [ecx+4], [edx+4]
    jne ENDIF1
    mov eax, 1
    popa
    ret
; to be tested
modifyCurrentPosition MACRO direction
    LOCAL L1, L2, L3, L4, ENDIF1
    mov ecx, [current_pos]
    mov ebx, [direction]
    cmp bl, 'd'
    jne L1
    mov eax, [ecx+8]
    cmp eax, MAX-1
    jl L2
    mov [ecx+8], 0
    jmp ENDIF1

L1:
    cmp bl, 'a'
    jne L3
    mov eax, [ecx+8]
    cmp eax, 0
    jg L4
    mov [ecx+8], MAX-1
    jmp ENDIF1

L3:
    cmp bl, 's'
    jne L4
    mov eax, [ecx+4]
    cmp eax, MAX-1
    jl L2
    mov [ecx+4], 0
    jmp ENDIF1

L4:
    cmp bl, 'w'
    jne ENDIF1
    mov eax, [ecx+4]
    cmp eax, 0
    jg L3
    mov [ecx+4], MAX-1


ENDIF1:
    xor eax,eax ; return 0;
    popa
    ret

ENDM

ret

ENDM

start:
	;aici se scrie codul
	
	;terminarea programului
	push 0
	call exit
end start

