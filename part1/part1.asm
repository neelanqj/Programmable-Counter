keyboard	equ	$00 ;PORTA
DDRA		equ	$02 ;DDRA
PORTB		equ	$01 ;PORTB
DDRB		equ	$03 ;DDRB

		org 	$0800
get_char	ldaa	#$F0		; configure pins PA7..PA4 for output to keypad
		staa	DDRA		; configure pins PA3..PA0 for input from keypad

put_char	ldaa	#$FF
		staa	DDRB		; configure pins PB7..PB0 for output only to bcd decoder 
;out:1111 
;in: 0000
	ldaa #$FF;
	staa keyboard;
scan_r0			bset	keyboard,$E0	; select the row containing keys 123
			bclr	keyboard,$10	; and porta (keyboard) with 0001 0000	 
scan_k1	brclr	keyboard,$01,key1 ; is key 1 pressed?
scan_k2	brclr	keyboard,$02,key2 ; is key 2 pressed?
scan_k3	brclr	keyboard,$04,key3 ; is key 3 pressed?
		;ldab	#$30
		;jsr 	print_char 
		bra	scan_r1	  ; continue to scan row1
key1		jmp	db_key1
key2		jmp	db_key2
key3		jmp	db_key3

scan_r1			bset	keyboard,$D0	; select the row containing keys 456
			bclr	keyboard,$20	; and porta (keyboard) with 0010 0000	 
scan_k4	brclr	keyboard,$01,key4 ; is key 4 pressed?
scan_k5	brclr	keyboard,$02,key5 ; is key 5 pressed?
scan_k6	brclr	keyboard,$04,key6 ; is key 6 pressed?
		;	ldab	#$31
		;	jsr 	print_char 
		bra	scan_r2	  ; continue to scan row2
key4		jmp	db_key4
key5		jmp	db_key5
key6		jmp	db_key6

scan_r2			bset	keyboard,$B0	; select the row containing keys 789
			bclr	keyboard,$40	; and porta (keyboard) with 0100 0000
scan_k7	brclr	keyboard,$01,key7 ; is key 7 pressed?
scan_k8	brclr	keyboard,$02,key8 ; is key 8 pressed?
scan_k9	brclr	keyboard,$04,key9 ; is key 9 pressed?
		;ldab	#$32
		;jsr 	print_char 
		bra	scan_r3	  ; continue to scan row3
key7		jmp	db_key7
key8		jmp	db_key8
key9		jmp	db_key9

;out: 0111
;in:  0000
scan_r3			bset	keyboard,$70		; select the row containing keys #0*
			bclr	keyboard,$80		; and porta (keyboard) with 1000 0000
scan_kStar	brclr	keyboard,$01,keyStar 	; is key * pressed?
scan_k0		brclr	keyboard,$02,key0 		; is key 0 pressed?
scan_kNum	brclr	keyboard,$04,keyNum 	; is key # pressed?
		;ldab	#$33
		;jsr 	print_char 
		bra	scan_r0 		; continue to scan row0
keyStar		jmp	db_keyStar
key0		jmp	db_key0
keyNum		jmp	db_keyNum
; debounce key 1
db_key1	
	ldab	#$31	
	jsr	debounce_500ms
		brclr	keyboard,$01,getc1
		ldx #killed
		jsr putstr
		jmp scan_k2

getc1		;ldab	#$0E	; get the binary code of 1 invert
		ldab	#$01
		stab	PORTB
		jmp scan_k2
db_key2	
	ldab	#$32
	jsr	debounce_500ms
		brclr	keyboard,$02,getc2
		ldx #killed	; killed is printed if the number is not the same
		jsr putstr
		jmp scan_k3
getc2		;ldab	#$0D	; get the binary code of 2 invert
		ldab	#$02
		stab	PORTB
		jmp scan_k3
db_key3	
	ldab	#$33
	jsr	debounce_500ms
		brclr	keyboard,$04,getc3
		ldx #killed
		jsr putstr
		jmp scan_r1
getc3		;ldab	#$0C	; get the binary code of 3 invert
		ldab	#$03
		stab	PORTB
		jmp scan_r1
db_key4
	ldab	#$34
	jsr	debounce_500ms
		brclr	keyboard,$01,getc4
		ldx #killed
		jsr putstr
		jmp scan_k5
getc4		;ldab	#$0B	; get the binary code of 4 invert
		ldab	#$04
		stab	PORTB
		jmp scan_k5
db_key5	
	ldab	#$35
	jsr	debounce_500ms
		brclr	keyboard,$02,getc5
		ldx #killed
		jsr putstr
		jmp scan_k6
getc5		;ldab	#$0A	; get the binary code of 5 invert
		ldab	#$05
		stab	PORTB
		jmp scan_k6
db_key6	
	ldab	#$36
	jsr	debounce_500ms
		brclr	keyboard,$04,getc6
		ldx #killed
		jsr putstr
		jmp scan_r2
getc6		;ldab	#$09	; get the binary code of 6 invert
		ldab	#$06
		stab	PORTB
		jmp scan_r2
db_key7	
	ldab	#$37
	jsr	debounce_500ms
		brclr	keyboard,$01,getc7
		ldx #killed
		jsr putstr
		jmp scan_k8
getc7		;ldab	#$08	; get the binary code of 7 invert
		ldab	#$07
		stab	PORTB
		jmp scan_k8
db_key8	
	ldab	#$38
	jsr	debounce_500ms
		brclr	keyboard,$02,getc8
		ldx #killed
		jsr putstr
		jmp scan_k9
getc8		;ldab	#$07	; get the binary code of 8 invert
		ldab	#$08
		stab	PORTB
		jmp scan_k9

db_key9	
	ldab	#$39
	jsr	debounce_500ms
		brclr	keyboard,$04,getc9
		ldx #killed
		jsr putstr
		jmp scan_r3
getc9		;ldab	#06	; get the binary code of 9 invert
		ldab	#$09
		stab	PORTB
		jmp	scan_r3
db_keyStar	
	ldab	#$30
	jsr	debounce_500ms	; debounce key *
		brclr	keyboard,$01,getcStar
		ldx #killed
		jsr putstr
		jmp scan_k0
getcStar	
		;ldab	#01	; get the binary code of * invert
		ldab	#$0F
		stab	PORTB
		jmp scan_k0

db_key0	
	ldab	#$30
	jsr	debounce_500ms	; debounce key 0
		brclr	keyboard,$02,getc0
		ldx #killed
		jsr putstr
		jmp scan_kNum
getc0
		;ldab	#$0F	; get the binary code of 0 invert
		ldab	#$00
		stab	PORTB
		jmp scan_kNum
db_keyNum	
	ldab	#$30
	jsr	debounce_500ms	; debounce key #
		brclr	keyboard,$04,getcNum
		ldx #killed
		jsr putstr
		jmp scan_r0
getcNum
		;ldab	#02	; get the binary code of # invert
		ldab	#$0F
		stab	PORTB
		jmp scan_r0

; the following subroutine creates a delay of 0.5s
debounce_500ms	ldx	#200		
		bset	keyboard, $FF
again		psha			; 2 E CYCLES
		pula			; 3 E CYCLES
		dbne	x,again		; 3 E CYCLES


	jsr 	print_char
	ldx #debounce
	jsr putstr
		rts



print_char	ldx	$F684
		jsr	0,x
		rts

nl	equ	$0a		; newline
cr	equ	$0d		; carriage return
debounce	fcb "debouncer",nl,cr, $00
killed		fcb "killed",nl,cr, $00
saved		fcb "saved",nl,cr, $00

; Subroutine; putstr (putstring)
; puts string with terminating \0 to the screen 
; using DBug12 putchar subroutine
; index register X should contain address of string (modified) 
putstr	ldb 1,x+	; get char
	beq leave	; all done leave
	jsr [$F684,PCr] ; ouput to screen
	bra putstr	; do next one
leave	rts
