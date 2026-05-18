; ============================================================
; C64 Mastery — stufe_03_bildschirm_zeichen
; Abschnitt: 7. Animierte Zeichensätze
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Flammen-Animation durch Zeichensatz-Modifikation
; Zeichencode 1 ($01) wird als Flamme animiert
; 4 Frames, jeder Frame ist 8 Bytes

FlameFrames:
        ; Frame 0: kleine Flamme
        !byte $00,$18,$3c,$3c,$18,$18,$00,$00
        ; Frame 1: mittlere Flamme
        !byte $18,$3c,$7e,$7e,$3c,$18,$18,$00
        ; Frame 2: große Flamme
        !byte $3c,$7e,$ff,$ff,$7e,$3c,$3c,$18
        ; Frame 3: sehr große Flamme
        !byte $7e,$ff,$ff,$ff,$ff,$7e,$3c,$18

flame_frame: !byte 0
flame_timer: !byte 0

UpdateFlame:
        dec flame_timer
        bne @done
        lda #8          ; Alle 8 Frames wechseln
        sta flame_timer

        inc flame_frame
        lda flame_frame
        cmp #4
        bne @update
        lda #0
        sta flame_frame

@update:
        ; Frame-Daten kopieren: flame_frame * 8 + Basis
        lda flame_frame
        asl             ; * 2
        asl             ; * 4
        asl             ; * 8
        tax
        ldy #0
@copy:  lda FlameFrames,x
        ; Zeichensatz liegt bei $3800, Zeichen 1 = Offset $08
        sta $3808,y
        inx
        iny
        cpy #8
        bne @copy
@done:
        rts
