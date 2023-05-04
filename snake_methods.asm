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




	
	;terminarea programului
	push 0
	call exit
end start
