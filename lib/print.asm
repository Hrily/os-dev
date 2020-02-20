;
; A library which provides printing functions
;

; function print
;   prints given string on screen
;   @param bx address of string
print:
	pusha                 ; push all registers to stack
	mov ah, 0x0e          ; int 10/ah = 0eh -> scrolling teletype BIOS routine
print__loop_0:
	mov al, [bx]          ; move char at address bx to al
	cmp al, 0x0
	je print__return    ; if (al == 0x0) jump to label print__return
	int 0x10              ; print interrupt
	inc bx                ; bx = bx + 1
	jmp print__loop_0   ; jump to begining of the loop
print__return:
	popa
	ret

; function print_ln
;   prints given string on screen in one line
;   @param bx address of string
print_ln:
	pusha
	call print
	mov ah, 0x0e          ; int 10/ah = 0eh -> scrolling teletype BIOS routine
	mov al, 0x0a          ; print \n
	int 0x10
	mov al, 0x0d          ; print \r
	int 0x10
	popa                  ; pop all registers saved in stack
	ret

; function map_num_to_hex_ascii
;   maps int number to equivalent ascii hex representation
;   @param  ax the number
;   @return ax the ascii representation
map_num_to_hex_ascii:
	cmp ax, 0x09
	jg  map_num_to_hex_ascii__letter
	add ax, 0x30          ; if ax <= 9 -> ax = ax + '0'
	ret
map_num_to_hex_ascii__letter:
	add ax, 0x57          ; if ax > 9  -> ax = ax + 'a' - 0xa
	ret

; function print_hex
;   prints given number as a hex string
;   @param dx the number to print
print_hex:
	pusha
	xor ax, ax            ; ax = 0
	mov bx, PRINT_HEX_TEMPLATE
	add bx, 0x05          ; point to end of string
; 0th index
	mov al, dl
	and al, 0x0f
	call map_num_to_hex_ascii
	mov [bx], al
	dec bx
; 1st index
	mov al, dl
	shr al, 4             ; shift al by 4 bits to right
	call map_num_to_hex_ascii
	mov [bx], al
	dec bx
; 2nd index
	mov al, dh
	and al, 0x0f
	call map_num_to_hex_ascii
	mov [bx], al
	dec bx
; 3rd index
	mov al, dh
	shr al, 4             ; shift al by 4 bits to right
	call map_num_to_hex_ascii
	mov [bx], al
	sub bx, 0x02          ; to start of PRINT_HEX_TEMPLATE
	call print_ln
	popa
	ret

;
; Data
;

; PRINT_HEX_TEMPLATE is the output template of print_hex function
PRINT_HEX_TEMPLATE:
	db '0x0000', 0
