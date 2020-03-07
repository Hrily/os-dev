;
; A boot sector that enters 32- bit protected mode and boots a kernel
;
[org 0x7c00]
	mov [BOOT_DRIVE], dl      ; BIOS stores our boot drive in DL, so it's
                            ; best to remember this for later.
	mov bp, 0x9000            ; Set-up the stack.
	mov sp, bp
	mov bx, MSG_REAL_MODE     ; Announce that we are starting
	call print_ln             ; booting from 16-bit real mode
	call load_kernel          ; Load our kernel
	call switch_to_pm         ; Switch to protected mode, from which
                            ; we will not return
	jmp $

%include "lib/print.asm"
%include "lib/disk.asm"
%include "lib32/gdt.asm"
%include "lib32/print.asm"
%include "lib32/switch.asm"

[ bits 16]
; load_kernel
load_kernel :
	mov bx, MSG_LOAD_KERNEL   ; Print a message to say we are loading the kernel
	call print_ln
	mov bx, KERNEL_OFFSET     ; Set-up parameters for our disk_load routine, so
	mov dh, KERNEL_SECTORS    ; that we load the first KERNEL_SECTORS sectors (excluding
	mov dl, [BOOT_DRIVE]      ; the boot sector) from the boot disk (i.e. our
	call disk_load            ; kernel code) to address KERNEL_OFFSET
	ret

[bits 32]

; This is where we arrive after switching to and initialising protected mode.
BEGIN_PM:
	mov  ebx, MSG_PROT_MODE
	call print_string_pm      ; Use our 32-bit print routine.
	call 0x1000               ; Now jump to the address of our loaded
                            ; kernel code , assume the brace position ,
                            ; and cross your fingers. Here we go!
	jmp  $                    ; Hang.

; Global variables
KERNEL_OFFSET   equ 0x1000  ; This is the memory offset to which we will load our kernel
KERNEL_SECTORS  equ 0x01    ; This is the number of sectors in kernel
BOOT_DRIVE      db 0
MSG_REAL_MODE   db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE   db "Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory.", 0

; Bootsector padding
times 510 - ($-$$) db 0
dw 0xaa55
