; ============================================================
; C64 Mastery — stufe_10_meisterschaft
; Abschnitt: 5. Datenkompression — RLE
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; RLE-Format: Byte 0 = Wert, Byte 1 = Anzahl (1-255)
; Sonderfall: Anzahl = 0 → Ende der Level-Daten
; Ausnahme: Wert = $FE (Escape) → nächstes Byte als Literal

RLE_ESCAPE = $FE
RLE_END    = $FF

; Dekomprimieren: SrcPtr → dekomprimierte Daten → DstPtr
RLEDecompress:
          LDY #0             ; Schreibindex
.loop:
          LDA (SrcPtr),Y     ; Nächstes RLE-Byte
          INY

          CMP #RLE_END : BEQ .done

          CMP #RLE_ESCAPE
          BEQ .literal

          ; RLE-Paar: Wert in Akku, nächstes Byte = Anzahl
          STA RLEValue
          LDA (SrcPtr),Y     ; Anzahl
          INY
          TAX                ; X = Anzahl
          LDA RLEValue

.repeat:  STA (DstPtr),DstY  ; DstY ist separater Schreibzähler
          INC DstY
          BNE .no_page
          INC DstPtr+1
.no_page: DEX : BNE .repeat
          JMP .loop

.literal: LDA (SrcPtr),Y     ; Nächstes Byte direkt
          INY
          STA (DstPtr),DstY
          INC DstY
          BNE .loop
          INC DstPtr+1
          JMP .loop

.done:    RTS

; Beispiel komprimierter Level:
; Original: 40× Tile 5, dann 3× Tile 2, dann 5× Tile 7
; Original: 48 Bytes
; RLE:      $05,$28, $02,$03, $07,$05, $FF → 7 Bytes!
Level1_RLE:
          !byte 5, 40   ; 40× Tile 5
          !byte 2,  3   ; 3× Tile 2
          !byte 7,  5   ; 5× Tile 7
          !byte $FF     ; Ende
