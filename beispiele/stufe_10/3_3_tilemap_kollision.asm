; ============================================================
; C64 Mastery — stufe_10_meisterschaft
; Abschnitt: 3.3 Tilemap-Kollision
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Spieler-Position gegen Tilemap-Kacheln prüfen
; Jede Kachel hat ein "Solid"-Flag

TileSolid: !byte 0,0,0,0,1,1,1,0,1,0,0,0,0,0,0,0
; Index 0-15: 0=begehbar, 1=Wand

; Prüfe ob Position (X-Pixel, Y-Pixel) auf einem Solid-Tile liegt
; Eingabe: A=X-Pixel, X=Y-Pixel
; Ausgabe: Carry = 1 wenn Solid, 0 wenn frei
IsSolid:
          STA PixX : STX PixY

          ; Tile-X = PixX / 8 (→ Spalte 0-39)
          LDA PixX : LSR : LSR : LSR : STA TileX

          ; Tile-Y = PixY / 8 (→ Zeile 0-24)
          LDA PixY : LSR : LSR : LSR : STA TileY

          ; Map-Index = TileY * 40 + TileX
          LDA TileY
          ASL : ASL : ASL : ASL : ASL  ; × 32
          STA MapIdx
          LDA TileY
          ASL : ASL : ASL              ; × 8
          CLC : ADC MapIdx
          CLC : ADC TileX
          TAY

          LDA MapPtr : STA TmpPtr
          LDA MapPtr+1 : STA TmpPtr+1
          LDA (TmpPtr),Y               ; Tile-ID holen
          TAX
          LDA TileSolid,X              ; Solid-Flag prüfen
          LSR                          ; → Carry
          RTS
