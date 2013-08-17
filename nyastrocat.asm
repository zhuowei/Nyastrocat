	INCLUDE "HVGLIB.H"
DSPLY	equ	$ff		;Bally Check debug port

	org FIRSTC		;this is a cart
BOOTCA:
	jp START		;Signal the Astrocade to boot into the cart instead of showing the menu
START:
	ld a, $0
	out ($16), a
	; we need to run the startup routine that we bypassed
	SYSTEM  INTPC           ; UPI INTerPret with Context create

        DO      SETOUT          ; UPI SET some OUTput ports
        DB      $BF    ; ... VERBL*2 = 191 ($BF)
        DB      $29             ; ... HORCB/4 = 41
        DB      $08             ; ... INMOD = 8
        ;
        DO      ACTINT          ; UPI ACTivate sub timer INTerrupts
        ;
        DO      EMUSIC          ; UPI End playing MUSIC
        DO      BMUSIC          ; UPI Begin MUSIC "STREETS OF LOREDO"
        DW      MSTACK          ; ... Music Stack
        DB      $C0             ; ... Voices = 11000000B (ON VOICE A)
        DW      NYANNOTES            ; ... Score Address (HOME on the range)
        DONT    XINTC           ; UPI eXit INTerpreter with Context
TIGHT:
	jp TIGHT

MSET:
        MASTER  $11
        VOLUME  $09, $00
        RET
        
NYANNOTES:
        CALL    MSET
        INCLUDE "notes.asm"
	DB	$C3		;jump to
	DW	NYANNOTES	;beginning of song

MSTACK  EQU     $4F12           ; (12 bytes) Music STACK
