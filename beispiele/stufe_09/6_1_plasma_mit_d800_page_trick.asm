; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 6.1 Plasma mit $D800 Page-Trick
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Schnellerer Plasma: Color-RAM direkt beschreiben via ZP-Pointer
; Nutze (ZP),Y Adressierung für indirekten Zugriff

FastPlasma:
          LDA #<$D800 : STA PlasPtr
          LDA #>$D800 : STA PlasPtr+1

          LDX #0               ; Zeilen-Zähler
          LDA PlasmaT1 : STA RowAng

.row:     LDA PlasmaT2 : STA ColAng
          LDY #0               ; Spalten-Index

.col:     LDA RowAng : TAX
          LDA SinTable,X       ; Row-Sinus
          STA Tmp1
          LDA ColAng : TAX
          LDA SinTable,X       ; Col-Sinus
          CLC : ADC Tmp1
          LSR : LSR : LSR : LSR  ; /16 → 0-15
          AND #$0F
          STA (PlasPtr),Y      ; Color-RAM schreiben
          INC ColAng
          INY
          CPY #40 : BNE .col

          ; Pointer um 40 vorwärts (nächste Zeile im Color-RAM)
          LDA PlasPtr : CLC : ADC #40 : STA PlasPtr
          LDA PlasPtr+1 : ADC #0 : STA PlasPtr+1

          INC RowAng
          INX
          CPX #25 : BNE .row

          INC PlasmaT1
          INC PlasmaT1         ; 2× pro Frame = schnellere Animation
          LDA PlasmaT1
          CLC : ADC #5
          STA PlasmaT2
          RTS
