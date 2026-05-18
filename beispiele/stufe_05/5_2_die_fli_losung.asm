; ============================================================
; C64 Mastery — stufe_05_bitmap_grafik
; Abschnitt: 5.2 Die FLI-Lösung
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; FLI-IRQ: wird auf jeder Rasterzeile ausgelöst
; Ändert Screen-RAM-Block per Zeile für mehr Farben

fli_line: !byte 0   ; Aktuelle Rasterzeile (0-199)

FLI_IRQ:
        lda $d012           ; Aktuelle Rasterzeile
        sec
        sbc #51             ; Rasterzeile 51 = erste Bildzeile
        and #$07            ; Welche Zeile in der aktuellen 8er-Gruppe? (0-7)

        ; Screen-RAM-Block für diese Zeile wählen
        ; Block 0 bei $4000, Block 1 bei $4400, ..., Block 7 bei $5C00 (in Bank 1)
        ; $D018 Bits 7-4: Offset / $0400
        ; $4000 in Bank 1: Offset $0000 → Wert 0
        ; $4400 in Bank 1: Offset $0400 → Wert 1
        asl
        asl
        asl
        asl             ; * 16 (= Shift für $D018 Bits 7-4)
        ora #%00001000  ; Bitmap bei $2000 in Bank 1: Bit 3 = 1
        sta $d018       ; Screen-RAM-Block wechseln!

        ; IRQ auf nächste Rasterzeile setzen
        inc $d012

        ; IRQ quittieren
        lda #$01
        sta $d019
        rti
