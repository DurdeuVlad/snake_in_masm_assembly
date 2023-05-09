.386
.model flat, stdcall

includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern printf: proc
extern fscanf: proc
extern fopen: proc
extern fclose: proc
extern memset: proc

public start

.data
window_title DB "SNAKE by Vlad Durdeu",0
area_width EQU 800
area_height EQU 800
area DD 0
SCREEN_SIZE EQU 10
screen Dw SCREEN_SIZE DUP (SCREEN_SIZE DUP (6))
square_size EQU 30
MAX equ 10 

red EQU 0FF0000h
black EQU 0000000h
white EQU 0FFFFFFh
green EQU 000FF00h
blue EQU 00000FFh
error_color EQU 0A020F0h
current_color dd 0
current_read_matrix_number dd 6

level db "nivel1.txt", 0
read_mode db "r", 0
fscanf_int_format db "%d", 0

DONE_debug db "step %d", 10, 0

open_file dd ?

.code
print_debug MACRO value:REQ
    pusha
    push value
    push offset DONE_debug
    call printf
    add esp, 8
    popa
ENDM

start:
    pusha
	print_debug 0
    mov ebx, 0
    mov bl, level
	push OFFSET read_mode
    push offset level
    call fopen
	mov open_file, eax
    add esp, 8
	cmp eax, 0  ; check if fopen returned null pointer
    je file_open_failed  ; jump to file_open_failed if file is not opened successfully
    
	
	print_debug 1
    mov ebx, eax
    mov ecx, SCREEN_SIZE
    sub ecx, 0
    mov esi, 0
    read_level_outer_loop:
		print_debug esi
        mov edi, 0
		
        read_level_inner_loop:
			print_debug edi
            pusha
			push open_file
            push offset fscanf_int_format
            mov edx, OFFSET screen
            mov eax, esi
            mov ecx, SCREEN_SIZE
            mul ecx
            shl eax, 2
            shl edi, 2
            add edx, eax
            add edx, edi
            push edx
            print_debug 9
            call fscanf
            add esp, 12
            print_debug 10
            popa
            inc edi
            cmp edi, ecx
            jl read_level_inner_loop
        inc esi
        cmp esi, ecx
        jl read_level_outer_loop

    push ebx
    call fclose
    add esp, 4

    print_debug 2
	file_open_failed:
	print_debug 3
	popa
    push 0
    call exit
end start
