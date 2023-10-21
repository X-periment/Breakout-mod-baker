; Code by Xperiment January 2023
; initially just copied from Toni Baker book
; first 5 (and last 3) includes came from  https://www.sinclairzxworld.com/viewtopic.php?t=2186&start=40 via ByteForever
#include "zx81defs.asm"
#include "zx81rom.asm"
#include "charcodes.asm"
#include "zx81sys.asm"
#include "line1.asm"

    jp breakout

#include "Lib_general.asm"

ballinit
    DEFW $0000
ballpos
    DEFW $0000
speed
    DEFW $0000
direction
    DEFW $0000
batpos
    DEFW $0000
seed
    DEFW $041e

tablestart
    DEFW $0020, $0022
    DEFW $ffe0, $ffde

breakout
    ld hl, (D_FILE)
    ld de, $0085   ; note toni has $8085 here
    add hl, de
    ld bc, $8080

nxbrk
    inc hl
    ld a, (hl)
    cp $76
    jr z, nxbrk
    ld (hl), $08
    djnz nxbrk

    ld hl, (D_FILE)
    ld b, $1e

nxbl
    inc hl
    ld (hl), c
    djnz nxbl
    inc hl
    ld (hl), $9c
    inc hl
    ld (hl), c
    inc hl
    inc hl
    ld de, $001f
    ld b, $15

    ;
sides
    ld (hl), c
    add hl, de

    ld (hl), c
    inc hl
    inc hl
    djnz sides

base
    ld (hl), $1b
    inc hl
    djnz base

    ld de, $fee5
    add hl, de
    ld (ballinit), hl
    ld hl, $0900
    ld (speed), hl

restart
    ld hl, (ballinit)
    inc hl
    ld (ballinit), hl
    ld (ballpos), hl
    ld (hl), $34
    ld hl, $ffe0
    ld (direction), hl
    ld a, (speed)
    dec a
    ret z

    ld (speed), a
    ld hl, (D_FILE)
    ld de, $02b7
    add hl, de
    ld (hl), $00
    ld a, $03
    inc hl
    ld (hl), a
    inc hl
    ld (hl), a
    inc hl
    ld (hl), a
    ld (batpos), hl
    inc hl
    ld (hl), a
    inc hl
    ld (hl), a
    ld b, $18
erase
    inc hl
    ld (hl), $00
    djnz erase
    ld hl, $0000
    jr delay

loop
    ld hl, (speed)
delay
    dec hl
    ld a, h
    or l
    jr nz, delay
    inc b
    bit 0, b
    jr nz, movebat

moveball
    ld hl, (ballpos)
    ld (hl), $00
    ld de, (direction)

    ex de, hl
    call DispHLinHex
    ex de, hl

    add hl, de
    ld a, (hl)
    cp $1b
    ;ret z
    jr z, restart
    ld c,a
    and $f7
    jr nz, dontmove
    ld (hl), $34  ; 34
    ld (ballpos), hl

dontmove
    or c
    jr z, movebat
    push hl
    ld hl, (seed)
    ld d, h
    ld e, l
    add hl, hl
    add hl, hl
    add hl, de
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de
    ld (seed), hl
    ld a, h
    ld (seed), hl
    ld a, h
    ld (seed), hl
    ld a,h
    and $06
    ld hl, tablestart
    add a, l
    ld l, a

    ld e, (hl)
    inc hl
    ld d, (hl)
    ld (direction), de
    pop hl
    ld a,c
    cp $08
    jr nz, moveball
    ld hl, (D_FILE)
    ld de, $001f
    add hl, de

carry
    ld a, (hl)
    cp $80


    jr nz, digit
    ld a, $9c
digit
    inc a
    cp $a6
    jr nz, increased
    ld (hl), $9c
    dec hl
    jr carry
increased
    ld (hl), a

movebat
    push bc
    call $02bb ;call kscan
    pop bc
    ld a,l
    cpl
    push af
    and $0f
    jr z, notleft
    ld hl, (batpos)
    dec hl
    dec hl
    dec hl
    ld a, (hl)
    cp $80
    jr z, cycle1
    ld (hl), $03
    inc hl
    inc hl
    ld (batpos), hl
    inc hl
    inc hl
    inc hl
    ld (hl),$00
notleft
    pop af
    and $f0
    jr z, cycle2
    ld hl, (batpos)
    inc hl
    inc hl
    inc hl
    ld a, (hl)
    cp $80
    jr z, cycle2
    ld (hl), $03
    dec hl
    dec hl
    ld (batpos), hl
    dec hl
    dec hl
    dec hl
    ld (hl), $00
    push hl
cycle1
    pop hl
cycle2
    jp loop


endLoop
    ; ld bc, $fefe
    ; in a, (c)
    ; xor $ff
    ; ld (de), a
    ;
    ;
    ; ld bc, $ffef
    ; in a, (c)
    ;
    ; ld l, a
    ; ld a, 0
    ; ld h, a
    ; call DispHL2
    ;
    ; ld a, $d5
    ; call delay2
    jr endLoop






#include "from_brandonw.asm"

#include "line2.asm"
#include "screen16K.asm"      			; definition of the screen memory, in colapsed version for 1K
#include "endbasic.asm"
