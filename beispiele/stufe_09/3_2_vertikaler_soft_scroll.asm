; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 3.2 Vertikaler Soft-Scroll
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; $D011 Bits 0-2: YSCROLL (0-7)
; Bild scrollt nach oben wenn YSCROLL abnimmt

ScrollY: !byte 3      ; Standardwert (Mitte)

UpdateVScroll:
          DEC ScrollY
          LDA ScrollY
          AND #$07
          STA ScrollY

          TAX
          LDA $D011
          AND #$F8
          ORA ScrollY
          STA $D011

          CPX #3             ; Zurück am Anfang? → Zeile shiften
          BNE .done
          JSR ShiftScreenUp  ; Zeilen nach oben verschieben
          JSR FillBottomRow  ; Neue Zeile unten einfügen
.done:    RTS
