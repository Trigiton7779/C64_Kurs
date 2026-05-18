; ============================================================
; C64 Mastery — stufe_07_interrupts_timing
; Abschnitt: 2.2 Tastatur scannen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Vollständiger Tastatur-Scan
; Ergebnis in $D4: Matrix-Code (0-63) oder $FF (keine Taste)

ScanKeyboard:
        lda #$ff
        sta $d4         ; Keine Taste gefunden

        lda #%11111110  ; Spalte 0 aktivieren
        ldx #0          ; Spalten-Zähler

@scan_col:
        sta $dc00       ; Spalte setzen
        nop : nop       ; Kurz warten (Stabilisierung)

        lda $dc01       ; Zeilen lesen
        eor #$ff        ; Invertieren (1 = gedrückt)
        beq @next_col   ; Keine Taste in dieser Spalte

        ; Zeile bestimmen (welches Bit gesetzt?)
        ldy #0
@find_row:
        lsr
        bcs @found
        iny
        cpy #8
        bne @find_row
        bne @next_col

@found:
        ; Matrix-Code = Spalte*8 + Zeile
        txa
        asl : asl : asl ; Spalte * 8
        sty $d5
        clc
        adc $d5
        sta $d4         ; Ergebnis speichern

@next_col:
        inx
        cpx #8
        beq @done
        lda ColMasks,x
        jmp @scan_col

@done:
        lda #$ff
        sta $dc00       ; Port A zurücksetzen
        rts

ColMasks: !byte $fe,$fd,$fb,$f7,$ef,$df,$bf,$7f
