; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 9.3 Horizontaler Open Border ($D016 38-Spalten)
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Horizontalen Border öffnen — für JEDE betroffene Rasterzeile
; Aufruf aus einem stabilen Raster-IRQ (mit Double-IRQ-Stabilisierung)
; $D016 Bit 3 = 0 → 38-Spalten = Side Borders offen
; Soft-Scroll-Bits (0-2) müssen erhalten bleiben!

; Aktuellen Soft-Scroll-Wert merken:
HBorderOpen:
          LDA $D016
          AND #$F7           ; Bit 3 löschen → 38 Spalten, Border offen
          STA $D016
          ; ... hier hat man ~17 Zyklen HBlank ...
          ; (Sprites, Farb-Wechsel, etc. für Border-Bereich)
          LDA $D016
          ORA #$08           ; Bit 3 setzen → 40 Spalten zurück
          STA $D016
          RTS
