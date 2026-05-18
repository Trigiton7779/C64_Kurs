; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 3.3 FLD-Scroller (Flexible Line Distance)
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; FLD: In jedem Raster-IRQ YSCROLL ändern → Zeilen "auseinander ziehen"
; Effekt: Wellenförmig verzerrtes Bild (Sinus-Warp)

FLDAngle: !byte 0

FLD_IRQ:
          PHA
          LDA #$01 : STA $D019

          ; Pro Rasterzeile neuen YSCROLL setzen
          LDA $D012          ; Aktuelle Zeile
          SEC : SBC #50      ; Offset zum Bildanfang
          CLC
          ADC FLDAngle       ; Sinus-Phase
          TAX
          LDA SinTable,X     ; Sinuswert 0-255
          LSR : LSR : LSR : LSR : LSR  ; /32 → 0-7
          STA $FB

          LDA $D011
          AND #$F8
          ORA $FB
          STA $D011          ; YSCROLL setzen

          ; Nächsten IRQ für die nächste Zeile setzen
          LDA $D012
          CLC : ADC #1
          CMP #251           ; Ende des sichtbaren Bereichs?
          BNE .setnext
          LDA #50            ; Zurück zum Anfang
          INC FLDAngle       ; Wellen-Phase vorwärts
.setnext: STA $D012

          PLA : RTI
