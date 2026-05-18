; ============================================================
; C64 Mastery — stufe_11_spielentwicklung_workflow
; Abschnitt: 7.5 Woche 3: Score, HUD, Game Over, Musik
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Score um 10 erhöhen (BCD-Modus)
add_score:
        sed                  ; Dezimal-Modus an
        clc
        lda ZP_SCORE_LO
        adc #$10             ; +10 im BCD-Format
        sta ZP_SCORE_LO
        lda ZP_SCORE_HI
        adc #0
        sta ZP_SCORE_HI
        cld                  ; Dezimal-Modus aus
        rts

; Score auf Bildschirm ausgeben (Position: Zeile 0, Spalte 32)
display_score:
        lda ZP_SCORE_HI
        lsr a
        lsr a
        lsr a
        lsr a               ; High-Nibble
        ora #$30             ; → PETSCII Zifferzeichen
        sta SCREEN_RAM + 32 ; Bildschirmposition
        ; ... (weitere Nibbles analog)
        rts
