; ============================================================
; C64 Mastery — stufe_06_sid_sound
; Abschnitt: 6. Voice 3 als LFO — Vibrato-Effekt
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; =====================================================
; Voice 3 als LFO für Vibrato auf Voice 1
; Voice 3: sehr langsam (~5 Hz), Triangle, kein Gate
; =====================================================

InitLFO:
        ; Voice 3: LFO-Frequenz (~5 Hz PAL)
        ; Reg = 5 × 16777216 / 985248 ≈ 85 = $55
        lda #$55        ; LFO-Frequenz Lo
        sta $d40e
        lda #$00        ; Hi = 0
        sta $d40f
        ; Control: Triangle OHNE Gate (kein Ton, nur Wellenform)
        lda #%00010000  ; TRI, kein GATE
        sta $d412
        ; Voice 3 stumm schalten (nicht im Audio-Mix)
        lda $d418
        ora #%10000000  ; Bit 7 setzen
        sta $d418
        rts

; Im Haupt-IRQ (50 Hz): Vibrato auf Voice 1 anwenden
ApplyVibrato:
        ; LFO-Wert lesen (0-255, repräsentiert Sinuswelle)
        lda $d41b       ; Voice-3-Waveform-Ausgang

        ; Auf ±16 Frequenzschritte skalieren
        lsr             ; / 2
        lsr             ; / 4  (0-63)
        lsr             ; / 8  (0-31)
        sec
        sbc #16         ; -16 bis +15 (signed)

        ; Zu Basis-Frequenz addieren (16-Bit-Addition)
        clc
        adc BaseFreqLo
        sta $d400       ; Voice 1 Freq Lo

        lda BaseFreqHi
        adc #0          ; Carry übertragen
        sta $d401       ; Voice 1 Freq Hi
        rts

BaseFreqLo: !byte $64   ; C4 Lo
BaseFreqHi: !byte $11   ; C4 Hi
