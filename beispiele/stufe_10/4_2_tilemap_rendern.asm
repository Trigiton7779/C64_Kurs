; ============================================================
; C64 Mastery — stufe_10_meisterschaft
; Abschnitt: 4.2 Tilemap rendern
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Sichtbaren Ausschnitt der Tilemap auf Screen-RAM rendern
; Nutzt vorberechnete Charset-Tiles

RenderTilemap:
          LDY #0             ; Screen-RAM Index
          LDA MapOffsetY : STA RowIdx

.nextrow: LDA MapOffsetX : STA ColIdx
          LDA #0 : STA ColCount

.nextcol: ; Tile-Index aus Map holen
          ; map_idx = RowIdx * MAP_WIDTH + ColIdx
          LDA RowIdx
          STA Tmp16+1        ; High... vereinfacht:
          ASL : ASL : ASL : ASL : ASL : ASL : ASL  ; × 128
          CLC : ADC ColIdx
          TAX
          LDA MapData,X      ; Tile-ID
          STA $0400,Y        ; Auf Screen-RAM schreiben

          INC ColIdx
          INY
          INC ColCount
          LDA ColCount : CMP #SCREEN_W : BNE .nextcol

          INC RowIdx
          LDA RowIdx
          SEC : SBC MapOffsetY
          CMP #SCREEN_H : BNE .nextrow

          RTS
