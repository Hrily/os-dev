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
