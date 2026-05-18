; ============================================================
; C64 Mastery — stufe_06_sid_sound
; Abschnitt: 5.2 Percussion-Sounds
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; =====================================================
; Schlagzeug-Sounds auf Voice 3
; Bassdrum: Rauschen + fallende Frequenz
; =====================================================

PlayBassDrum:
        ; Voice 3: Noise, kurze ADSR
        lda #$00        ; Attack=0, Decay=0
        sta $d413
        lda #$00        ; Sustain=0, Release=0
        sta $d414

        ; Hohe Anfangsfrequenz für "Knall"-Charakter
        lda #$ff
        sta $d40e       ; Freq Lo
        lda #$08
        sta $d40f       ; Freq Hi

        ; Triangle + Gate (Triangle klingt für Bassdrum warm)
        lda #%00010001  ; TRI + GATE
        sta $d412

        ; Frequenz wird per Hauptschleife auf 0 heruntergezogen
        rts

PlaySnare:
        ; Noise mit mittlerer Frequenz und kurzem ADSR
        lda #$04        ; Attack=0, Decay=4
        sta $d413
        lda #$02        ; Sustain=0, Release=2
        sta $d414
        lda #$80        ; Mittlere Frequenz
        sta $d40e
        lda #$1a
        sta $d40f
        lda #%10000001  ; NOI + GATE
        sta $d412
        rts

PlayHiHat:
        lda #$02        ; Attack=0, Decay=2
        sta $d413
        lda #$01        ; Sustain=0, Release=1
        sta $d414
        lda #$ff
        sta $d40e       ; Hohe Frequenz = helles Rauschen
        lda #$7f
        sta $d40f
        lda #%10000001  ; NOI + GATE
        sta $d412
        rts
