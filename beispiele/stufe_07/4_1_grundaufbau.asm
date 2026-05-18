; ============================================================
; C64 Mastery — stufe_07_interrupts_timing
; Abschnitt: 4.1 Grundaufbau
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; =====================================================
; Raster-IRQ Setup — vollständige Routine
; Farb-Split: Oberer Bildschirmbereich rot, unterer blau
; =====================================================

IRQ_LINE_1 = 100    ; Wechsel zu Blau
IRQ_LINE_2 = 200    ; Wechsel zurück zu Rot

SetupRasterIRQ:
        SEI
        ; CIA-IRQs deaktivieren
        LDA #$7F : STA $DC0D : STA $DD0D
        LDA $DC0D : LDA $DD0D   ; Pending löschen

        ; IRQ-Vektor auf IRQ1
        LDA #<IRQ1 : STA $0314
        LDA #>IRQ1 : STA $0315

        ; Raster-Zeile für IRQ1 setzen
        LDA #IRQ_LINE_1
        STA $D012
        LDA $D011
        AND #$7F        ; Bit 7 = 0 (Zeile < 256)
        STA $D011

        ; Raster-IRQ aktivieren
        LDA #$01
        STA $D01A

        CLI
        RTS

IRQ1:
        ; Farbe wechseln: Blau
        LDA #6 : STA $D020 : STA $D021

        ; IRQ2 auf Zeile 200 setzen
        LDA #IRQ_LINE_2 : STA $D012
        LDA #<IRQ2 : STA $0314
        LDA #>IRQ2 : STA $0315

        ; IRQ quittieren
        LDA #$01 : STA $D019
        JMP $EA31

IRQ2:
        ; Farbe wechseln: Rot
        LDA #2 : STA $D020 : STA $D021

        ; IRQ1 zurücksetzen
        LDA #IRQ_LINE_1 : STA $D012
        LDA #<IRQ1 : STA $0314
        LDA #>IRQ1 : STA $0315

        LDA #$01 : STA $D019
        JMP $EA31
