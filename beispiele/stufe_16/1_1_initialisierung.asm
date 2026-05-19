; ============================================================
; C64 Mastery — stufe_16_tastatur_joystick
; Abschnitt: 1.1 Initialisierung
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; CIA1 für Tastatur-Scan + Joystick initialisieren
; Dies ist der C64-Standardzustand nach dem Reset
init_input:
    lda #$FF
    sta $DC02           ; DDRA: Port A = Output (Zeilen-Select)
    lda #$00
    sta $DC03           ; DDRB: Port B = Input  (Spalten-Read + Joy1)
    lda #$FF
    sta $DC00           ; Alle Zeilen abwählen (High = nicht selektiert)
    rts
