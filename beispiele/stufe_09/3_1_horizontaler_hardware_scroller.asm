; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 3.1 Horizontaler Hardware-Scroller
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; $D016 Bits 0-2: XSCROLL (0-7)
; Bild scrollt nach links wenn XSCROLL abnimmt
; Bei XSCROLL=0 → nächste Spalte via Screen-RAM-Shift einfahren

ScrollX:    !byte 7      ; Start bei Maximum (kein Scroll)
ScrollText: !text "HALLO WELT   "  ; Scrolltext
ScrollPos:  !byte 0      ; Position im ScrollText

UpdateScroll:
          DEC ScrollX
          LDA ScrollX
          AND #$07           ; Sicher im 0-7 Bereich
          STA ScrollX

          TAX
          LDA $D016
          AND #$F8           ; Scroll-Bits löschen
          ORA ScrollX
          STA $D016          ; Neuen Scroll-Wert setzen

          CPX #7             ; Haben wir voll durchgescrollt?
          BNE .done          ; Nein: fertig

          ; Ja: Screen-RAM eine Spalte nach links verschieben
          JSR ShiftScreenLeft
          ; Rechte Spalte mit nächstem Zeichen füllen
          LDX ScrollPos
          LDA ScrollText,X
          JSR WriteRightColumn
          INC ScrollPos
          LDA ScrollPos
          CMP #(ScrollTextEnd - ScrollText)
          BNE .done
          LDA #0 : STA ScrollPos  ; Wrap around
.done:    RTS

; Screen-RAM ($0400) eine Spalte nach links schieben
; 25 Zeilen × 40 Zeichen = 1000 Bytes
ShiftScreenLeft:
          LDX #0
.row:     TXA
          ASL : ASL : ASL : ASL : ASL  ; × 32... besser: LUT nutzen
          ; Einfacher: Direkte Adressberechnung per Zeile
          ; Wir nutzen hier eine einfache, lesbare Variante:

          LDY #0
.nextrow: LDA #0             ; Zeilen-Offset (vereinfacht)

          ; Zeile Y shiften: Bytes 1-39 → 0-38
          LDX #0
.shift:   LDA $0401,X        ; Byte 1-39 holen
          STA $0400,X        ; → Byte 0-38
          INX
          CPX #39
          BNE .shift
          ; [Hier würde man jede der 25 Zeilen separat shiften]
          ; Für echten Code: Row-Offset-LUT + unrolled
          RTS

; Rechte Spalte (Spalte 39) mit einem Zeichen füllen
WriteRightColumn:
          LDY #0
.loop:    STA RowStart39,Y   ; Vorberechnete Adress-LUT
          INY
          CPY #25
          BNE .loop
          RTS

; Optionale Farb-RAM Synchronisation (für farbige Scroller)
          ; Gleiche Logik für $D800–$DBE7
