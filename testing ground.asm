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
    

    push 0
    call exit
end start
