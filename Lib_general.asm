;--------------------------------------------

delay2
    push bc
    ld b, a
    ld c, $ff
delay_loop
    dec bc
    ld a, b
    or c
    jr nz, delay_loop
    pop bc
    ret

;---------------------------------------
