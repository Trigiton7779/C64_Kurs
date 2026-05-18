; ============================================================
; C64 Mastery — stufe_12_demo_entwicklung_workflow
; Abschnitt: 6.2 PAL/NTSC-Detektion im Code
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; PAL/NTSC-Erkennung durch Zählen der Rasterzeilen
; PAL hat 312 Zeilen, NTSC hat 263 Zeilen pro Frame
; Methode: Warte auf Rasterzeile 0, zähle bis Rasterzeile 0 wieder erscheint

is_ntsc:        !byte 0    ; 0 = PAL, 1 = NTSC

detect_standard:
        ; Warte auf Rasterzeile 0 (Anfang eines Frames)
.wait_non_zero:
        lda $D012
        bne .wait_non_zero   ; Warte bis Zeile ≠ 0
.wait_zero:
        lda $D012
        bne .wait_zero       ; Warte bis Zeile = 0 (neuer Frame)

        ; Jetzt zählen wir die Rasterzeilen bis zum nächsten Frame-Start
        ; Wenn in 300 Zeilen noch kein neuer Rahmen-Beginn: PAL (312 Zeilen)
        ldx #$18             ; = 24 × 256 = 6144 Schleifendurchläufe
        ldy #0
.count:
        lda $D012
        cmp #263-20         ; NTSC: Rasterzeile 243 vor Frame-Ende
        bcc .not_ntsc_line   ; Noch nicht dort
        lda #1
        sta is_ntsc          ; NTSC erkannt!
        rts
.not_ntsc_line:
        iny
        bne .count
        dex
        bne .count
        ; Schleife abgelaufen ohne NTSC-Erkennung → PAL
        lda #0
        sta is_ntsc
        rts

; ── Raster-IRQ-Anpassung je nach Standard ───────────────────
setup_raster_irq:
        lda is_ntsc
        beq .pal_irq
        ; NTSC: Rasterzeile 240 (kurz vor Frame-Ende bei 263 Zeilen)
        lda #240
        sta $D012
        rts
.pal_irq:
        ; PAL: Rasterzeile 300 (kurz vor Frame-Ende bei 312 Zeilen)
        lda #300-256         ; = 44 (Bit 8 wird via $D011 gesetzt)
        sta $D012
        rts
