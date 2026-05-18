; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 6. Plasma-Effekt
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Plasma-Effekt über Color-RAM
; 40×25 = 1000 Pixel, jede Iteration: 2 Sinus-Lookups + Addition

PlasmaT1: !byte 0    ; Zeit-Variable 1 (globale Phase)
PlasmaT2: !byte 0    ; Zeit-Variable 2

UpdatePlasma:
          LDA #$20 : JSR FillScreen  ; Bildschirm mit Space füllen

          LDY #0               ; Y = Zeile × Spalte (linearer Index)
          LDA #0 : STA RowPhase
          LDA PlasmaT1 : STA RowSin

.nextrow: LDA #0 : STA ColPhase
          LDA PlasmaT2 : STA ColSin

.nextcol: ; Farbe = (sin(col+t1) + sin(row+t2)) / 2 → Nibble 0-15
          LDX RowSin
          LDA SinTable,X       ; Sin(row+t1) → 0-255
          LSR : LSR : LSR      ; /8 → 0-31
          STA Tmp1

          LDX ColSin
          LDA SinTable,X       ; Sin(col+t2)
          LSR : LSR : LSR
          CLC : ADC Tmp1
          LSR                  ; /2 → 0-15 (genau 16 Farben!)
          AND #$0F
          STA $D800,Y          ; Farbe ins Color-RAM

          INC ColSin           ; Nächste Spalte
          INY
          CPY #40 : BNE .nextcol

          INC RowSin
          LDA RowPhase
          CLC : ADC #40
          STA RowPhase
          TAY
          CMP #250             ; 25 Zeilen × 40?
          BNE .nextrow

          ; Zeitvariablen für nächsten Frame
          INC PlasmaT1
          LDA PlasmaT1
          CLC : ADC #3
          STA PlasmaT2         ; T2 läuft schneller → komplexeres Muster
          RTS

; Optimierung: Plasma zu langsam? → Nur jeden 2. Frame aktualisieren
; Oder: Nur die sichtbaren Änderungen schreiben (Dirty-Flagging)
