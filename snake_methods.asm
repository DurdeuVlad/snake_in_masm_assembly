.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern printf: proc
extern fopen: proc
extern fscanf: proc
extern fclose: proc
extern malloc: proc
extern free: proc
extern exit: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
MAX EQU 10

Point STRUCT
    x DWORD ?
    y DWORD ?
Point ENDS

Snake STRUCT
    body DWORD ?
    current_length DWORD ?
    direction BYTE ?
Snake ENDS
.code
start:

; function: comparePoints
; description: compares two Point structures for equality
; input: p1 - the first Point structure
;        p2 - the second Point structure
; output: returns 1 if the two structures are equal, otherwise 0
comparePoints proc p1:DWORD, p2:DWORD
    push ebp
    mov ebp, esp

    ; compare x values
    mov eax, DWORD PTR [p1]
    cmp eax, DWORD PTR [p2]
    jne comparePoints_not_equal

    ; compare y values
    mov eax, DWORD PTR [p1 + 4]
    cmp eax, DWORD PTR [p2 + 4]
    jne comparePoints_not_equal

    ; structures are equal
    mov eax, 1
    jmp comparePoints_done

comparePoints_not_equal:
    ; structures are not equal
    xor eax, eax

comparePoints_done:
    pop ebp
    ret
comparePoints endp



restart PROC
    ; initializam variabilele locale
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    ; declaram parametrii functiei
    mov eax, [ebp + 8]
    mov ebx, [ebp + 12]
    mov ecx, [ebp + 16]

    ; resetam screen
    xor esi, esi ; variabila pentru iterarea prin linii
    for_i:
        cmp esi, MAX
        jge end_for_i
        xor edi, edi ; variabila pentru iterarea prin coloane
        for_j:
            cmp edi, MAX
            jge end_for_j
            mov dword ptr [ebx + esi*4 + edi*4], 0
            inc edi
            jmp for_j
        end_for_j:
            inc esi
            jmp for_i
    end_for_i:

    ; setam variabilele snake
    lea ecx, [eax + Snake.body]
    push ecx
    push MAX
    push MAX
    call malloc
    add esp, 12
    mov dword ptr [eax], ecx
    mov dword ptr [eax + Snake.current_length], 1
    mov byte ptr [eax + Snake.direction], 's'

    ; citim screen din fisier
    push ecx ; salvam pointerul la screen pe stiva
    push MAX
    push MAX
    push ebx ; punem adresa lui screen pe stiva
    push ecx ; punem parametrul level pe stiva
    call readScreenFromFile
    add esp, 20

    ; generam pozitia initiala a sarpelui
    mov ecx, MAX
    shr ecx, 1
    dec ecx
    mov edx, ecx
    lea ebx, [eax + Snake.body]
    mov dword ptr [ebx], ecx
    mov dword ptr [ebx + 4], edx

    ; setam directia initiala a sarpelui
    mov byte ptr [eax + Snake.direction], 's'

    ; eliberam memoria ocupata de pointerul la screen
    pop ecx ; scoatem pointerul la screen de pe stiva
    push ecx ; salvam pointerul la screen pe stiva pentru a-l returna
    call free
    add esp, 4

    ; afisam mesajul de incarcare
    push dword ptr [ebp + 16]
    push offset levelMsg
    call printf
    add esp, 8
	; deschidem fisierul
	push offset fileName
	push 0
	call fopen
	add esp, 8
	mov [ebp - 4], eax ; salvam pointerul la fisier in stack frame

	; citim matricea din fisier
	xor ecx, ecx ; ecx va fi contorul de linii
	readLoop:
	cmp ecx, MAX
	jge endReadLoop
	xor edx, edx ; edx va fi contorul de coloane
	colLoop:
	cmp edx, MAX
	jge endColLoop
	push eax ; salvam pointerul la fisier pe stiva pentru fscanf
	push dword ptr [ebp + 12] ; salvam pointerul la matrice pe stiva pentru fscanf
	push offset readFmt ; salvam formatul pe stiva pentru fscanf
	call fscanf
	add esp, 12 ; stergem argumentele de pe stiva
	inc edx ; incrementam contorul de coloane
	jmp colLoop
	endColLoop:
	inc ecx ; incrementam contorul de linii
	jmp readLoop
	endReadLoop:
	; inchidem fisierul
	push [ebp - 4] ; punem pointerul la fisier pe stiva
	call fclose
	add esp, 4

	; spawn food
	push dword ptr [ebp + 12] ; punem pointerul la matrice pe stiva pentru spawnFood
	call spawnFood
	add esp, 4

	; cleanup
	leave
	ret
restart ENDP
	
	;terminarea programului
	push 0
	call exit
end start
