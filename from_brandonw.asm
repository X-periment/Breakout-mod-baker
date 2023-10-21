; from or modified from https://wikiti.brandonw.net/index.php?title=Z80_Routines

;Display a 16- or 8-bit number in hex.

DispHLinHex
    push bc
    push de
    push af
    push hl

    ld bc, 10
    ld de, (DF_CC)
    ex de, hl
    add hl, bc
    ex de, hl

    call DispHLhex

    pop hl
    pop af
    pop de
    pop bc

    ret

DispHLhex
; Input: HL
    ld  c,h
    call  OutHex8
    ld  c,l

OutHex8
; Input: C
    ld  a,c
    rra
    rra
    rra
    rra
    call  Conv
    ld  a,c
Conv
    and  $0F
    ; for zx81 we need to check it greater than the char for 9, and then translate to abcdef codes - actually it is simpeler as on zx81 abc follows 123.
    add a, $1c
    ;add  a,$90
    ;daa   ;  This won't work on zx81!! different char set!!
    ;adc  a,$40
    ;daa
    call PUTCHAR  ;replace by bcall(_PutC) or similar
    ret

;Number in hl to decimal ASCII
;Thanks to z80 Bits
;inputs:	hl = number to ASCII
;example: hl=300 outputs '00300'
;destroys: af, bc, hl, de used

DispHL3
    ld bc, 20
    ld de, (DF_CC)
    ex de, hl
    add hl, bc
    ex de, hl
    call DispHL

    ret

DispDE2
    ex de, hl
    call DispHL2
    ex de, hl
    ret

DispHL2
    push bc
    push de
    push af
    push hl

    ld bc, 10
    ld de, (DF_CC)
    ex de, hl
    add hl, bc
    ex de, hl
    call DispHL

    pop hl
    pop af
    pop de
    pop bc

    ret

DispHL
  	ld	bc,-10000
  	call	Num1
  	ld	bc,-1000
  	call	Num1
  	ld	bc,-100
  	call	Num1
  	ld	c,-10
  	call	Num1
  	ld	c,-1
Num1:	ld	a,_0-1
Num2:	inc	a
  	add	hl,bc
  	jr	c,Num2
  	sbc	hl,bc
  	call PUTCHAR
  	ret

PUTCHAR
    push af
    inc de
    ld (de), a
    pop af
    ret

;-----> Generate a random number
; output a=answer 0<=a<=255
; all registers are preserved except: af
randData
    DEFW 0
random
    push    hl
    push    de
    ld      hl,(randData)
    ld      a,r
    ld      d,a
    ld      e,(hl)
    add     hl,de
    add     a,l
    xor     h
    ld      (randData),hl
    pop     de
    pop     hl
    ret


;------------------
; 8*8 The following routine multiplies h by e and places the result in hl

mult_h_e
   ld	d, 0	; Combining the overhead and
   sla	h	; optimised first iteration
   sbc	a, a
   and	e
   ld	l, a

   ld	b, 7
mult_loop
   add	hl, hl
   jr	nc, $+3
   add	hl, de

   djnz	mult_loop

   ret
