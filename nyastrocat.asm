	INCLUDE "HVGLIB.H"
DSPLY	equ	$ff		;Bally Check debug port
PALETTEPOINTER	equ	$4f00	; stores current palette pointer
LINEINTNUM 	equ 	$4f02	; scanline to trigger interrupt

	org FIRSTC		;this is a cart
BOOTCA:
	jp START		;Signal the Astrocade to boot into the cart instead of showing the menu
START:
	; we need to run the startup routine that we bypassed
	; The following is copied off of BIOS3164.asm
        LD      SP,BEGRAM

	SYSTEM  INTPC           ; UPI INTerPret with Context create

        DO      SETOUT          ; UPI SET some OUTput ports
        DB      $BF    ; ... VERBL*2 = 191 ($BF)
        DB      $29             ; ... HORCB/4 = 41
        DB      $08             ; ... INMOD = 8
        ;
        DO      EMUSIC          ; UPI End playing MUSIC
	;
        DO      ACTINT          ; UPI ACTivate sub timer INTerrupts
        ;
        DO      BMUSIC          ; UPI Begin MUSIC for nyancat
        DW      MSTACK          ; ... Music Stack
        DB      $C0             ; ... Voices = 11000000B (ON VOICE A)
        DW      NYANNOTES            ; ... Score Address (Nyancat song)
	;
	DO	MOVE		; push the first frame up
	DW	NORMEM		; to screen memory
	DW	3200		; 80 lines
	DW	IMAGEFRAME0	; from first frame

        DONT    XINTC           ; UPI eXit INTerpreter with Context

	; Again, a routine taken from the BIOS.
	; FIRE UP INTERRUPTS (BALLY standard IM 2 is already DONE IN MENU)
	LD      A,INTTBL SHR 8	; top bytes of the interrupt vector
	LD      I,A		; set the interrupt
	LD      A,LFRVEC AND 0FFH ;bottom byte of the interrupt
	OUT     (INFBK),A	; set the interrupt bottom byte

	ld a, $d8
	out (COL0L), a

	ld a, 0
	out (INLIN), a
	ld (LINEINTNUM), a

TIGHT:
	hlt
	jr TIGHT		; we don't do anything here

LINEHANDLER:
	; This routine is called by the line handling interrupt.
	DI
	PUSH    AF		; save registers
	PUSH    BC
	PUSH    DE
	PUSH    HL
	PUSH    IX
	; get the current line
	ld a, (LINEINTNUM)
	;ld a, 0
	;ld b, a
	;ld de, PALETTEFRAME0
	;add hl, bc
	;add hl, bc
	;add hl, bc
	;add hl, bc
	;ld a, (hl)
	out (COL0L), a
	;inc hl
	;ld a, (hl)
	;out (COL1R), a
	;inc hl
	;ld a, (hl)
	;out (COL2R), a
	;inc hl
	;ld a, (hl)
	;out (COL3R), a
	ld a, (LINEINTNUM)
	; put it to next line
	add a, 4
	cp $d0		;bottom of screen?
	jr z, RESETSCR
LINEHANDLERNEXTLINE:
	out (INLIN), a
	ld (LINEINTNUM), a
	POP     IX
	POP     HL
	POP     DE
	POP     BC
	POP     AF
	EI
	RET

RESETSCR:
	CALL    STIMER		; call regular system timer
	ld a, $0
	jr LINEHANDLERNEXTLINE

INTTBL:         ; INTerrupt TaBLe
LFRVEC: DW      LINEHANDLER           ; Low Foreground Routine VECtor

MSET:
        MASTER  $11
        VOLUME  $09, $00
        RET
        
NYANNOTES:
        CALL    MSET
        INCLUDE "notes.asm"
	DB	$C3		;jump to
	DW	NYANNOTES	;beginning of song

	INCLUDE "frame0.asm"

MSTACK  EQU     $4F12           ; (12 bytes) Music STACK
