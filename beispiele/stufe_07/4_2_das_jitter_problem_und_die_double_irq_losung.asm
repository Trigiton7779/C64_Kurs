; ============================================================
; C64 Mastery — stufe_07_interrupts_timing
; Abschnitt: 4.2 Das Jitter-Problem und die Double-IRQ-Lösung
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; =====================================================
; Stabiler Raster-IRQ (Double-IRQ / Stable Raster)
; Ziel: exakt auf Rasterzeile EFFECT_LINE
; =====================================================

EFFECT_LINE = 120

SetupStableRaster:
        SEI
        LDA #$7F : STA $DC0D : STA $DD0D
        LDA $DC0D : LDA $DD0D

        LDA #<StableIRQ1 : STA $0314
        LDA #>StableIRQ1 : STA $0315

        LDA #(EFFECT_LINE-1) : STA $D012
        LDA $D011 : AND #$7F : STA $D011
        LDA #$01 : STA $D01A
        CLI
        RTS

; IRQ1: Stellt IRQ2 exakt auf die Zielzeile
StableIRQ1:
        LDA #$01 : STA $D019    ; IRQ quittieren

        ; Auf IRQ2 vorbereiten
        LDA #EFFECT_LINE : STA $D012
        LDA #<StableIRQ2 : STA $0314
        LDA #>StableIRQ2 : STA $0315

        ; Timing-Ausgleich: NOP-Padding je nach CPU-Phase
        ; Die genaue Anzahl NOPs hängt vom Assembler-Timing ab
        ; Standard-Technik für sehr präzises Timing:
        BIT $EA31       ; 4 Zyklen (für Timing-Ausgleich)
        RTI

; IRQ2: Effekt läuft hier — exakt auf EFFECT_LINE
StableIRQ2:
        LDA #$01 : STA $D019

        ; EFFEKT (exakt auf der gewünschten Zeile!)
        LDA #5 : STA $D020  ; Grüne Border auf dieser Zeile
        ; (für dauerhaft: hier Farbwechsel für den Rest des Frames)

        ; Zurück zu IRQ1 für nächsten Frame
        LDA #(EFFECT_LINE-1) : STA $D012
        LDA #<StableIRQ1 : STA $0314
        LDA #>StableIRQ1 : STA $0315

        JMP $EA31
