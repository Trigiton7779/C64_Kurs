; ============================================================
; C64 Mastery — stufe_04_sprites_animation
; Abschnitt: 7.1 Sprite-Sprite-Kollision
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
CheckAllCollisions:
        lda $d01e       ; Kollisions-Register lesen (und löschen!)
        beq @no_sprite_coll

        ; Bits 0 und 1 gesetzt = Sprite 0 und Sprite 1 kollidiert
        and #%00000011
        cmp #%00000011
        bne @no_sprite_coll
        jsr HandlePlayerEnemyCollision

@no_sprite_coll:
        lda $d01f       ; Sprite-Hintergrund-Kollision lesen (und löschen!)
        beq @done
        ; Bit 0 gesetzt = Sprite 0 hat Hintergrund berührt
        and #%00000001
        beq @done
        jsr HandleGroundCollision

@done:  rts
