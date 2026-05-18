; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 5. FLD — Flexible Line Distance
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; FLD-Grundprinzip:
; Normalerweise: YSCROLL = konstant (z.B. 3)
; → Bad Lines alle 8 Rasterzeilen
;
; Mit FLD: YSCROLL ändert sich mit jedem Raster-IRQ
; → VIC-II erkennt keine Bad Line → keine Zeichensatz-Daten
; → Zeile wird mit Hintergrundfarbe gefüllt ("Open Border")

; FLD nutzen um eine "wellige Linie" zwischen Textbereichen zu erzeugen

FLD_YScroll: !byte 3    ; Basis-YSCROLL
FLD_Phase:   !byte 0    ; Sinus-Phase

; Raster-IRQ der jede Zeile aufgerufen wird (zwischen Zeile 100-150)
FLD_LinIRQ:
          PHA
          LDA #$01 : STA $D019

          LDA $D012             ; Aktuelle Rasterzeile
          SEC : SBC #100        ; Offset
          CLC : ADC FLD_Phase   ; Phase addieren
          TAX
          LDA SinTable,X        ; Sinuswert
          LSR : LSR : LSR : LSR : LSR  ; /32 → 0-7
          PHA

          LDA $D011
          AND #$F8
          PLA : ORA
          STA $D011             ; YSCROLL setzen

          ; Nächste Zeile
          LDA $D012
          CLC : ADC #1
          CMP #150 : BNE .cont
          LDA $D011             ; YSCROLL zurücksetzen
          AND #$F8
          ORA #3
          STA $D011
          LDA #100
          INC FLD_Phase
.cont:    STA $D012
          PLA : RTI
