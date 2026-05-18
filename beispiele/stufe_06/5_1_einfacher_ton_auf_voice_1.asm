; ============================================================
; C64 Mastery — stufe_06_sid_sound
; Abschnitt: 5.1 Einfacher Ton auf Voice 1
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; =====================================================
; Ton spielen: Note C4 (261 Hz) mit Sawtooth-Welle
; ADSR: Piano-ähnlich (kurzer Attack, langer Decay)
; =====================================================

PlayNote_C4:
        ; Master-Lautstärke auf 15 (falls noch nicht gesetzt)
        lda #$0f
        sta $d418

        ; ADSR: Attack=0, Decay=9, Sustain=0, Release=9
        lda #$09        ; Attack=0 (Hi-Nibble), Decay=9 (Lo-Nibble)
        sta $d405
        lda #$09        ; Sustain=0, Release=9
        sta $d406

        ; Frequenz: C4 ≈ $1164 (PAL)
        lda #$64        ; Frequenz Low
        sta $d400
        lda #$11        ; Frequenz High
        sta $d401

        ; Sawtooth-Welle + Gate AN
        lda #%00100001  ; SAW (Bit 5) + GATE (Bit 0)
        sta $d404
        rts

; Note beenden (Gate aus → Release-Phase):
StopNote_V1:
        lda $d404
        and #%11111110  ; Gate-Bit löschen
        sta $d404
        rts
