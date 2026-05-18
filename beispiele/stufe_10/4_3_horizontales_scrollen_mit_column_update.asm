; ============================================================
; C64 Mastery — stufe_10_meisterschaft
; Abschnitt: 4.3 Horizontales Scrollen mit Column-Update
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Scrollen: 1 Pixel nach rechts pro Frame
ScrollWorldRight:
          INC MapScrollX
          LDA MapScrollX
          CMP #8
          BNE .applyscroll

          ; 8 Pixel → nächste Kachelspalte
          LDA #0 : STA MapScrollX
          INC MapOffsetX
          LDA MapOffsetX
          CMP #(MAP_WIDTH - SCREEN_W)
          BNE .newcol
          LDA #0 : STA MapOffsetX   ; Wrap
.newcol:
          ; Neue rechte Spalte in Screen-RAM eintragen
          JSR DrawRightmostColumn

.applyscroll:
          ; Hardware-Scroll anwenden
          LDA #8
          SEC : SBC MapScrollX      ; Invertiert: mehr Offset = mehr Scroll
          STA ScrollHW

          LDA $D016
          AND #$F8
          ORA ScrollHW
          STA $D016
          RTS

DrawRightmostColumn:
          ; Neue Spalte rechts = MapOffsetX + SCREEN_W - 1
          LDA MapOffsetX
          CLC : ADC #(SCREEN_W - 1)
          STA NewColX
          LDA MapOffsetY : STA RowIdx

          LDX #0               ; Zeilen-Zähler
.loop:    LDA RowIdx
          ASL : ASL : ASL : ASL : ASL : ASL : ASL  ; × 128
          CLC : ADC NewColX
          TAY
          LDA MapData,Y        ; Tile-ID der neuen Spalte

          ; Schreibe auf rechte Screen-RAM-Spalte (Spalte 39)
          LDA RowStartAddrLo,X  ; Zeile X, Spalte 39
          STA TmpPtr
          LDA RowStartAddrHi,X
          STA TmpPtr+1
          LDY #39
          LDA MapData,Y
          STA (TmpPtr),Y

          INC RowIdx
          INX : CPX #SCREEN_H : BNE .loop
          RTS
