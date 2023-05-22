.686
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern printf: proc
extern fscanf: proc
extern fopen: proc
extern fclose: proc
extern memset: proc
extern realloc: proc

includelib canvas.lib
extern BeginDrawing: proc


; BIBLIOGRAFIE search
; Procedures:
; BeginDrawing
; fill_matrix
; make_text
; draw

; Macros
; move_head
; spawnFood
; print_debug
; fill_matrix_macro
; push_all_registers
; pop_all_registers
; set_position_macro
; get_position_macro
; turn_screen_code_color
; fill_a_screen
; set_screen_to_level
; draw_square
; reset_area
; reset_screen
; make_text_macro



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date


window_title DB "SNAKE by Vlad Durdeu",0
area_width EQU 800
area_height EQU 800
area DD 0
SCREEN_SIZE EQU 20 ; dimensiunea matricei in ambele directii
screen dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
;screen Dd 0
square_size EQU 20
MAX equ 20 ; same thing with screen_size 

red EQU 0FF0000h
black EQU 0000000h
white EQU 0FFFFFFh
green EQU 000FF00h
blue EQU 00000FFh
error_color EQU 0A020F0h
current_color dd 0
current_read_matrix_number dd 6

zero dd 0
one dd 1
two dd 2
three dd 3
four dd 4
five dd 5
up dd 'w'
down dd 's'
left dd 'a'
right dd 'd'

counter DD 0 ; numara evenimentele de tip timer

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

symbol_width EQU 10
symbol_height EQU 20

;file mode and format strings
read_mode db "r", 0
fscanf_int_format db "%d", 0


;debug messages

turn_screen_code_color_debug db "[turn_screen_code_color]: The code value is: %d", 10, 0
get_position_debug db "[get_position_debug]: The code value is: %d", 10, 0
fill_a_screen_debug_i db "[fill_a_screen_debug]: i= %d", 10, 0
fill_a_screen_debug_j db "[fill_a_screen_debug]: j= %d", 10, 0
move_head_x db "[move_head_debug]: x = %d", 10, 0
move_head_y db "[move_head_debug]: y = %d", 10, 0
tasta_apasata db "[tasta_apasata]: tasta_apasata = %d", 10, 0
space db "space %d", 10, 0

; Define a new variable to represent the initial position of the snake

; Define a vector of numbers between 0 and MAX
food_positions dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

; Define a variable to keep track of the current position in the vector
food_position_index dd 0


; snake
current_pos_x DD 5
current_pos_y DD 10
current_direction DB 'a'
current_score DD 0
max_score DD 5
lost_game DD 0
current_level DD 0

Point STRUCT
    x DWORD ?
    y DWORD ?
Point ENDS





nivel0 dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0


nivel1 dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1

nivel2 dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
       dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
       dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
       dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
       dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
       dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1

nivel3 dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1

nivel4 dd 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
       dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1
       dd 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1

nivel5 dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
       dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1
       dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
       dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1
       dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	   dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1
       dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1	 	   
	   
include digits.inc
include letters.inc

.code


get_random_position MACRO
    LOCAL randomize_loop
    push edx
    push ecx
	mov eax, MAX
    randomize_loop:
        ; generate random x and y positions
        RDTSC
		MOV EAX, EDX   
		MOV ECX, max 
		dec ecx
		XOR EDX, EDX   
		DIV ECX         
		INC EDX           
		push edx

        RDTSC
		MOV EAX, EDX   
		MOV ECX, max
		dec ecx
		XOR EDX, EDX   
		DIV ECX         
		INC EDX           
        mov ebx, edx ; y position
		pop ecx
        ; check value at screen[eax][ebx]
        get_screen_position ecx, ebx
        cmp eax, 1
        je randomize_loop ; if value is 1, choose another set of numbers
		mov eax, ecx 
    pop ecx
    pop edx
ENDM


change_screen_level MACRO nivel
	local loopi, loopj
    pusha
	mov current_pos_x, 3
	mov current_pos_y, 6
	mov current_direction, 'w'
    mov ecx, MAX; number of elements in the matrix
	mov edx, 0
	loopi:
	mov ebx, 0
		loopj:
		pusha
		get_level_position edx, ebx, nivel 
		set_screen_position edx, ebx, eax
		popa
		inc ebx
		cmp ebx, ecx
		jl loopj
	inc edx
	cmp edx, ecx
	jl loopi
	popa
ENDM


set_screen_position MACRO xPOS, yPOS, value
	pusha
	mov ecx, xPOS
	mov ebx, yPOS
	imul ebx, 4
	IMUL ebx, MAX
	IMUL ecx, 4
	MOV screen [ecx] [ebx], value
	popa
ENDM

get_screen_position MACRO xPOS, yPOS
	push ecx
	push ebx
	mov ecx, xPOS
	mov ebx, yPOS
	imul ebx, 4
	IMUL ebx, MAX
	IMUL ecx, 4
	MOV eax, screen [ecx] [ebx]
	pop ebx
	pop ecx
ENDM

get_level_position MACRO xPOS, yPOS, nivel
	push ecx
	push ebx
	mov ecx, xPOS
	mov ebx, yPOS
	imul ebx, 4
	IMUL ebx, MAX
	IMUL ecx, 4
	MOV eax, nivel [ecx] [ebx]
	pop ebx
	pop ecx
ENDM

randomize_food_positions MACRO
    LOCAL randomize_loop
    pusha
    mov ecx, MAX ; number of elements in the food_positions array
	add ecx, 6
    xor edi, edi ; index for food_positions
    randomize_loop:
        ; generate random x and y positions
        RDTSC
        xor edx, edx
        div ecx
        mov ebx, edx ; x position

        RDTSC
        xor edx, edx
        div ecx
        mov ecx, edx ; y position

        ; check value at screen[ebx][ecx]
        get_screen_position ebx, edx
        cmp eax, 1
        je randomize_loop ; if value is 1, choose another set of numbers

        ; store x and y positions in food_positions array
        mov food_positions[edi], ebx
        inc edi
        mov food_positions[edi], edx
        inc edi

        dec ecx
        jnz randomize_loop
    popa
ENDM




; Define a constant for the size of the screen
; WORKING HERE
; move_head macro
move_head MACRO
    local L1, PIERDERE_JOC, FINAL, L2, FINAL_MACRO, EAT_FOOD
	pusha
    	
; Get the current position of the snake
	mov ecx, current_pos_x
	mov ebx, current_pos_y

; Update the screen to remove the tail of the snake
	set_screen_position ecx, ebx, 0
	


; Move the current position of the snake based on its direction
	mov al, current_direction
	cmp al, 'w'
	je move_up
	cmp al, 's'
	je move_down
	cmp al, 'a'
	je move_left
	cmp al, 'd'
	je move_right
	jmp Final

	move_up:
	dec ebx
	cmp ebx, 0
	jge L2
	mov ebx, MAX-1
	jmp L2

	move_down:
	inc ebx
	cmp ebx, MAX
	jl L2
	xor ebx, ebx
	jmp L2

	move_left:
	dec ecx
	cmp ecx, 0
	jge L1
	mov ecx, MAX-1
	jmp L1

	move_right:
	inc ecx
	cmp ecx, MAX
	jl L1
	xor ecx, ecx

; Update the current position of the snake

	L1:
	mov current_pos_x, ecx
	jmp Final

	L2:
	mov current_pos_y, ebx

Final:
; Update the screen to add the head of the snake
xor eax, eax
get_screen_position ecx, ebx
cmp eax, one
je PIERDERE_JOC 
cmp eax, five
je EAT_FOOD
jmp FINAL_MACRO
	PIERDERE_JOC:
	lose_game
	jmp FINAL_MACRO
	EAT_FOOD:
	eatFOOD
	FINAL_MACRO:
	set_screen_position current_pos_x, current_pos_y, 3
	popa
ENDM

next_level MACRO
	local level1, level2, level3, level4, level5, macro_end
	
	pusha
	inc current_level
	cmp current_level, 1
	je level1
	cmp current_level, 2
	je level2
	cmp current_level, 3
	je level3
	cmp current_level, 4
	je level4
	cmp current_level, 5
	je level5
	; level0
	change_screen_level nivel0
	JMP macro_end
	
	level1:
	change_screen_level nivel1
	JMP macro_end
	
	level2:
	change_screen_level nivel2
	JMP macro_end
	
	level3:
	change_screen_level nivel3
	JMP macro_end
	level4:
	change_screen_level nivel4
	JMP macro_end
	level5:
	change_screen_level nivel5
	JMP macro_end
	macro_end:
	mov current_score, 0
	;randomize_food_positions
	popa
ENDM


lose_game MACRO
	mov lost_game, 1

	
ENDM

eatFOOD MACRO
	local END_MACRO
	pusha
	add current_score, 1
	; if current_score == max_score, next level
	mov eax, current_score
	mov ebx, max_score
	cmp eax, ebx
	jl END_MACRO
	next_level
	END_MACRO:
	spawnFood
	popa
ENDM


; it works, but might block the game if there are not valid positions to place the food.
spawnFood MACRO
    ;local L1, food_position_next, food_position_next2
    pusha
    ;mov eax, [screen]
    ;mov ecx, MAX*MAX
    ;mov edx, 0
    ;L1:
    ;    ; Get the next food position from the vector
    ;    mov eax, [food_position_index]
    ;    inc eax
    ;    cmp eax, MAX
    ;    jl food_position_next
    ;    xor eax, eax
    ;food_position_next:
    ;    mov [food_position_index], eax

     ;   mov ebx, [food_positions + eax*4]
    ;    imul ebx, MAX

        ; Get another food position from the vector
    ;    inc eax
    ;    cmp eax, MAX
    ;    jl food_position_next2
    ;    xor eax, eax
    ;food_position_next2:
    ;    mov [food_position_index], eax

     ;   lea esi, [eax+ebx]
     ;   shl esi, 2
    ;    mov esi, [screen+esi]
    ;    cmp esi, 0
    ;    jne L1

    ;    lea esi, [eax+ebx]
    ;    shl esi, 2
    ;    mov [screen+esi], 5
	get_random_position 
	set_screen_position eax, ebx, 5
    popa
ENDM




print_debug MACRO message:REQ, value:REQ
    pusha
	push value
    push offset message
    call printf
    add esp, 8
    popa
ENDM

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
	pusha
ENDM

pop_all_registers MACRO
	popa
ENDM
	
set_position_macro MACRO i, j, value
LOCAL set_position_end
	pusha
    mov eax, i
    mov ebx, j
    mov ecx, SCREEN_SIZE
    cmp eax, ecx
    jae set_position_end
    cmp ebx, ecx
    jae set_position_end
    shl eax, 2
    add eax, ebx
    shl eax, 2
    lea ebx, screen
    add ebx, eax
	xor eax, eax
    mov eax, value ; Move 16-bit value to AX
    mov [ebx], eax  ; Store in memory as a word
	jmp set_position_end
set_position_end:
    popa
ENDM



get_position_macro MACRO i, j, matrix
    LOCAL error_label, get_position_end
	pusha
	; luam i coloana, j rand, screen+i*4+screenmax*j*4
    mov eax, i
    mov ebx, j
    mov ecx, SCREEN_SIZE
    cmp eax, ecx
    jae error_label
    cmp ebx, ecx
    jae error_label
    shl eax, 2
	shl ebx, 2
	push eax
	mov eax, ebx
	mul ecx
	mov ebx, eax
	pop eax
    add eax, ebx
    lea ebx, matrix
    add ebx, eax
    mov eax, [ebx]
    mov current_read_matrix_number, eax


    jmp get_position_end
error_label:
    mov eax, 0
    mov current_read_matrix_number, eax
get_position_end:
    popa
ENDM

turn_screen_code_color MACRO code
	LOCAL fill_a_screen_error, fill_a_screen_white, fill_a_screen_black, fill_a_screen_green, fill_a_screen_blue, fill_a_screen_red
	pusha
	;print_debug turn_screen_code_color_debug, code
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
		;make_text_macro 'E', area, 500, 100
		;make_text_macro 'R', area, 510, 100
		;make_text_macro 'R', area, 520, 100
		;make_text_macro 'O', area, 530, 100
		;make_text_macro 'R', area, 540, 100
		jmp fill_a_screen_end
	fill_a_screen_white:
		mov current_color, [white]
		;make_text_macro 'W', area, 500, 100
		;make_text_macro 'H', area, 510, 100
		;make_text_macro 'I', area, 520, 100
		;make_text_macro 'T', area, 530, 100
		;make_text_macro 'E', area, 540, 100
		jmp fill_a_screen_end
	fill_a_screen_black:
		mov current_color, [black]
		;make_text_macro 'B', area, 500, 100
		;make_text_macro 'L', area, 510, 100
		;make_text_macro 'A', area, 520, 100
		;make_text_macro 'C', area, 530, 100
		;make_text_macro 'K', area, 540, 100
		jmp fill_a_screen_end
	fill_a_screen_green:
		mov current_color, [green]
		jmp fill_a_screen_end
		;make_text_macro 'G', area, 500, 100
		;make_text_macro 'R', area, 510, 100
		;make_text_macro 'E', area, 520, 100
		;make_text_macro 'E', area, 530, 100
		;make_text_macro 'N', area, 540, 100
	fill_a_screen_red:
		mov current_color, [red]
		;make_text_macro 'R', area, 500, 100
		;make_text_macro 'E', area, 510, 100
		;make_text_macro 'D', area, 520, 100
		jmp fill_a_screen_end
	fill_a_screen_blue:
		mov current_color, [blue]
		;make_text_macro 'B', area, 500, 100
		;make_text_macro 'L', area, 510, 100
		;make_text_macro 'U', area, 520, 100
		;make_text_macro 'E', area, 530, 100
		jmp fill_a_screen_end
	
	fill_a_screen_end:
	popa
endm


fill_a_screen MACRO
local fill_a_screen_outer_loop, fill_a_screen_inner_loop
	pusha

	mov ecx, screen_size	; Load screen_size into ECX for outer loop
	;sub ecx, 0
	mov edx, square_size
	mov esi, 0                ; Initialize i to 0
	
	fill_a_screen_outer_loop:
	;print_debug fill_a_screen_debug_i, esi

    mov edi, 0             ; Initialize j to 0
	;print_debug fill_a_screen_debug_j, edi
	
    fill_a_screen_inner_loop:
        ; inner loop body
		pusha
		
		mov ebx, square_size
		mov eax, esi
		MUL ebx
		sub eax, esi
		mov ecx, eax
		
		mov eax, edi
		mov ebx, square_size
		mul ebx
		mov ebx, eax
		get_position_macro esi, edi, screen
		mov eax, current_read_matrix_number
		
		turn_screen_code_color current_read_matrix_number
		;mov current_color, [blue]
		draw_square ecx, ebx, current_color
		
		popa
		
        inc edi           ; Increment j
        cmp edi, ecx      ; Compare j with screen_size
        jle fill_a_screen_inner_loop     ; Jump to inner_loop if j < screen_size

    inc esi               ; Increment i
    cmp esi, ecx          ; Compare i with screen_size
    jle fill_a_screen_outer_loop         ; Jump to outer_loop if i < screen_size
	
	
	popa
ENDM

set_screen_to_level MACRO nivel
local outer_loop, inner_loop
	pusha

	mov ecx, screen_size	; Load screen_size into ECX for outer loop
	;sub ecx, 0
	mov edx, square_size
	mov esi, 0                ; Initialize i to 0
	
	outer_loop:
	;print_debug fill_a_screen_debug_i, esi

    mov edi, 0             ; Initialize j to 0
	;print_debug fill_a_screen_debug_j, edi
	
    inner_loop:
        ; inner loop body
		pusha
		
		get_position_macro esi, edi, nivel
		mov eax, current_read_matrix_number
		set_position_macro esi, edi, eax
		
		popa
		
        inc edi           ; Increment j
        cmp edi, ecx      ; Compare j with screen_size
        jle inner_loop     ; Jump to inner_loop if j < screen_size

    inc esi               ; Increment i
    cmp esi, ecx          ; Compare i with screen_size
    jle outer_loop         ; Jump to outer_loop if i < screen_size
	
	
	popa
ENDM

; functia asta functioneaza cum trebuie
draw_square MACRO x:REQ, y:REQ, color:REQ
LOCAL LOOP_BIG, LOOP_START
    pusha
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
	
	mov ecx, square_size
	add eax, 4*area_width
	pop edx
	INC edx         
    CMP edx, ecx    
    JLE LOOP_BIG
    popa
ENDM

read_direction MACRO letter
	local move_up_DRAW, move_down_DRAW, move_left_DRAW, move_right_DRAW, restart_game
	pusha
	print_debug tasta_apasata, letter	
	mov al, letter
	cmp al, 'W'
	je move_up_DRAW
	cmp al, 'S'
	je move_down_DRAW
	cmp al, 'A'
	je move_left_DRAW
	cmp al, 'D'
	je move_right_DRAW
	cmp al, 'R'
	je restart_game
	jmp DRAW_CONTINUE_1

	restart_game:
	mov current_score, 0
	mov lost_game, 0
	change_screen_level nivel0 
	spawnFood
	jmp DRAW_CONTINUE_1
	
	move_up_DRAW:
	mov current_direction, 'w'
	jmp DRAW_CONTINUE_1

	move_down_DRAW:
	mov current_direction, 's'
	jmp DRAW_CONTINUE_1

	move_left_DRAW:
	mov current_direction, 'a'
	jmp DRAW_CONTINUE_1

	move_right_DRAW:
	mov current_direction, 'd'
	
	
	
	DRAW_CONTINUE_1:
	popa

ENDM


reset_area MACRO
	pusha
	
	
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	
	
	popa
ENDM

; this doesnt work
reset_screen MACRO value:REQ
	pusha
	
	mov eax, screen_size
	mov ebx, screen_size
	mul ebx
	shl eax, 2
	push eax
	push value
	push screen
	call memset
	add esp, 12
	
	popa
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
	pusha
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
	popa
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
	cmp eax, 0
	jz evt_init
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	cmp eax, 3
	jz evt_tasta; s-a apasat o tasta
	
evt_init:
	change_screen_level nivel0
	spawnFood
	jmp afisare_litere
	
evt_click:
	spawnFood
	jmp afisare_litere

evt_tasta:
	read_direction [ebp+arg2]
	jmp afisare_litere
	
evt_timer:
	inc counter
	cmp LOST_GAME, 1
	JE CONTINUE_DRAW_FILLSCREEN
	move_head
	JMP CONTINUE_DRAW_FILLSCREEN 
	CONTINUE_DRAW_FILLSCREEN:
	reset_area
;	read_level_macro offset level
	fill_a_screen

	
afisare_litere:

	;YOU LOST TEXT
	cmp LOST_GAME, 1
	JNE LOST_GAME_draw
	pusha
	make_text_macro 'Y', area, 500, 200
	make_text_macro 'O', area, 510, 200
	make_text_macro 'U', area, 520, 200
	make_text_macro 'L', area, 540, 200 
	make_text_macro 'O', area, 550, 200
	make_text_macro 'S', area, 560, 200
	make_text_macro 'T', area, 570, 200
	popa
	LOST_GAME_draw:
	
	; SHOW LEVEL
	make_text_macro 'L', area, 100, 450
	make_text_macro 'E', area, 110, 450
	make_text_macro 'V', area, 120, 450
	make_text_macro 'E', area, 130, 450 
	make_text_macro 'L', area, 140, 450
	push eax
	mov eax, CURRENT_LEVEL
	add eax, '0'
	make_text_macro eax, area, 160, 450
	POP EAX
	
	; SHOW SCORE
	push eax
	mov eax, current_score
	add eax, '0'
	make_text_macro eax, area, 100, 420
	mov eax, max_score
	add eax, '0'
	make_text_macro 'T', area, 120, 420
	make_text_macro 'O', area, 130, 420
	make_text_macro eax, area, 150, 420
	pop eax
	;afisam valoarea counter-ului curent (sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 520, 10
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 510, 10
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 500, 10
	
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
	
	mov current_color, [error_color]
	
	
	;mov eax, screen_size
	;mov ebx, screen_size
	;mul ebx
	;shl eax, 2
	;push eax
	;call malloc
	;add esp, 4
	;mov screen, eax	
	;fill_matrix_macro 2
	
	
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
