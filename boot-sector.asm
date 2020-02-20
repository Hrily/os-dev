;
; A boot sector that prints a string using print function.
;
[org 0x7c00]               ; Tell the assembler where this code will be loaded

mov bx, HELLO_MSG
call print_ln

mov bx, GOODBYE_MSG
call print_ln

mov dx, [HEX_TEST]
call print_hex

jmp $                      ; Jump to the current address ( i.e. forever ).

%include "lib/print.asm"

; Data
HELLO_MSG:
db 'Hello, World!', 0       ; The zero on the end tells our routine
                            ; when to stop printing characters.
GOODBYE_MSG:
db 'Goodbye!', 0

HEX_TEST:
dw 0xdead

;
; Padding and magic BIOS number.
;
times 510 -( $ - $$ ) db 0  ; When compiled , our program must fit into 512 bytes ,
                            ; with the last two bytes being the magic number ,
                            ; so here , tell our assembly compiler to pad out our
                            ; program with enough zero bytes (db 0) to bring us to the
                            ; 510 th byte.

dw 0xaa55                   ; Last two bytes ( one word ) form the magic number ,
                            ; so BIOS knows we are a boot sector.
