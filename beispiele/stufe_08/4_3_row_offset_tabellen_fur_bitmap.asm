; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 4.3 Row-Offset-Tabellen für Bitmap
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Für schnellen Bitmap-Zugriff: Zeilen-Offset vorberechnen
; Y-Pos → Adresse in der Bitmap
; Bitmap bei $2000, 320 Bytes pro 8-Pixel-Block-Zeile
; Für Y: Zeilen-Block = Y/8, Offset = Block*320 + (Y AND 7)

RowLoTable: ; Low-Byte der Zeilen-Startadresse
!for row, 0, 199 {
    !byte <($2000 + (row/8)*320 + (row & 7))
}

RowHiTable: ; High-Byte der Zeilen-Startadresse
!for row, 0, 199 {
    !byte >($2000 + (row/8)*320 + (row & 7))
}

; Verwendung: Pixel bei (X, Y) setzen
SetPixelFast:
          LDY PixelY        ; Y-Koordinate
          LDA RowLoTable,Y
          STA DstPtr
          LDA RowHiTable,Y
          STA DstPtr+1      ; Zeilen-Startadresse → DstPtr

          LDA PixelX
          LSR               ; /8 → Byte-Spalte (Quotient)
          LSR
          LSR
          TAY               ; Y = Byte-Offset in der Zeile

          LDA PixelX
          AND #$07          ; Bit-Position in Byte
          TAX
          LDA BitMask,X     ; Vorberechnete Bitmasken
          ORA (DstPtr),Y
          STA (DstPtr),Y
          RTS

BitMask: !byte $80,$40,$20,$10,$08,$04,$02,$01
