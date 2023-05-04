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

;declaram constantele

;declaram variabilele globale
.DATA
	SCREEN_SIZE EQU 10 ; dimensiunea matricei in ambele directii
    screen DW SCREEN_SIZE DUP (SCREEN_SIZE DUP (?)) ; declararea matricei

.CODE
start:
    ;scriem codul
	push 0
    call fill_matrix ; umplem matricea cu valoarea 0
	add esp, 4
	push 1
	push 4
	push 3
	push offset screen
    call set_position ; setam valoarea 1 la pozitia (3, 4)
	add esp, 16
    mov eax, OFFSET screen
    mov ebx, 3
    mov ecx, 4
    call get_position ; salvam valoarea de la pozitia (3, 4) in eax

	;terminarea programului
	push 0
	call exit

;functia fill_matrix umple matricea cu o valoare data
public fill_matrix PROC matrix:PTR WORD, value:dWORD
    push esi
    push edi
    mov esi, matrix ; incarcam adresa matricei in registru
    mov ecx, SCREEN_SIZE*SCREEN_SIZE ; numarul total de elemente din matrice
    mov edi, value ; incarcam valoarea de umplere in registru
public fill_loop:
    mul cx ; inmultim i cu dimensiunea matricei
    add di, bx ; adaugam j * 2 la di (dimensiunea unui element din matrice)
    mov WORD PTR [esi], di ; umplem elementul de la adresa [esi] cu valoarea [edi]
    add esi, 2 ; trecem la urmatorul element din matrice (de 2 bytes)
    loop fill_loop ; repetam pasii pentru urmatorul element din matrice
    pop edi
    pop esi
    ret
fill_matrix ENDP

;functia set_position seteaza valoarea unui element de la pozitia (i, j) in matrice
public set_position PROC matrix:PTR WORD, i:DWORD, j:DWORD, value:Dword
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


;functia get_position returneaza valoarea unui element de la pozitia (i, j) in matrice
public get_position PROC matrix:PTR WORD, i:dWORD, j:dWORD
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

END start
