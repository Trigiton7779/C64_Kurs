; ============================================================
; C64 Mastery — stufe_10_meisterschaft
; Abschnitt: 7.4 Score-Anzeige
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Score als 5-stellige Dezimalzahl im Screen-RAM anzeigen
; Score: 24-Bit BCD (3 Bytes) für bis zu 999999

Score: !byte $00, $00, $00  ; BCD: 00-00-00 bis 99-99-99

; Score um Punkte erhöhen (BCD-Addition)
AddScore:
          ; Eingabe: X = Punkte (1-99)
          SED              ; Dezimal-Modus!
          TXA
          CLC : ADC Score+2
          STA Score+2
          LDA Score+1 : ADC #0 : STA Score+1
          LDA Score   : ADC #0 : STA Score
          CLD              ; Dezimal-Modus aus!
          RTS

; Score als Zeichen auf Screen-RAM ausgeben (Zeile 0, Spalten 0-5)
DrawScore:
          LDA Score
          JSR BCD2Screen    ; High-Byte → 2 Ziffern
          LDA Score+1
          JSR BCD2Screen
          LDA Score+2
          JSR BCD2Screen
          RTS

BCD2Screen:
          ; BCD-Byte → 2 Screen-Codes, schreibt nach $0400,Y (Y = Ausgabepos)
          PHA
          LSR : LSR : LSR : LSR  ; High-Nibble
          CLC : ADC #$30         ; → PETSCII '0' = $30
          STA $0400,Y : INY

          PLA : AND #$0F
          CLC : ADC #$30
          STA $0400,Y : INY
          RTS
