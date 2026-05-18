; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 4.3 IRQ-gestützter Sprite-Multiplexer
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; MuxIRQ: Wird aufgerufen wenn der VIC-II die Y-Position des nächsten
; Sprite-Batches erreicht. Konfiguriert 8 Hardware-Sprites neu.

MuxIRQBase = 50   ; Oberster Bereich des sichtbaren Bildschirms
MuxPtr:   !byte 0    ; Index in SortedIdx

InitMux:
          LDA #0 : STA MuxPtr
          ; Ersten Batch verarbeiten (ab Zeile 50)
          JSR LoadNextBatch
          LDA #<MuxIRQ : STA $0314
          LDA #>MuxIRQ : STA $0315
          RTS

MuxIRQ:
          PHA : TXA : PHA : TYA : PHA

          LDA #$01 : STA $D019   ; IRQ quittieren

          JSR WriteSpriteHW      ; Aktuellen Batch in HW schreiben
          JSR LoadNextBatch      ; Nächsten Batch vorbereiten

          PLA : TAY : PLA : TAX : PLA
          RTI

; Hardware-Sprites mit dem aktuellen Batch beschreiben
WriteSpriteHW:
          LDX #0
.loop:    LDA IRQSlotIdx,X
          CMP #$FF : BEQ .disable

          TAY
          LDA SprLogX,Y
          STA $D000,X            ; X-Position (Low Byte)
          LDA SprLogY,Y
          STA $D001,X            ; Y-Position
          LDA SprLogFrame,Y
          STA $07F8,X            ; Sprite-Pointer
          LDA SprLogColor,Y
          STA $D027,X            ; Farbe
          JMP .next

.disable: ; Sprite ausblenden: Y-Position unter Bildschirm
          LDA #$FF : STA $D001,X

.next:    INX : INX              ; Nächster Sprite (X,Y-Paare = 2 Bytes)
          CPX #16 : BNE .loop
          ; Sprites aktivieren
          LDA #$FF : STA $D015   ; Alle 8 an
          RTS

; Nächsten 8er-Batch aus SortedIdx laden und IRQ-Zeit setzen
LoadNextBatch:
          LDX MuxPtr
          LDY #0
.load:    CPY #8 : BEQ .done
          LDA SortedIdx,X
          CMP #$FF : BEQ .fill_rest
          STA IRQSlotIdx,Y
          INX : INY
          JMP .load

.fill_rest:
          LDA #$FF : STA IRQSlotIdx,Y
          INY : JMP .fill_rest

.done:    STX MuxPtr
          ; IRQ auf Y-Position des ersten Sprites im Batch setzen
          LDA IRQSlotIdx
          CMP #$FF : BEQ .no_more
          TAX
          LDA SprLogY,X
          STA $D012              ; Nächster IRQ bei dieser Y-Zeile
          RTS

.no_more: ; Keine Sprites mehr → IRQ für nächsten Frame setzen
          LDA #0 : STA MuxPtr
          LDA #MuxIRQBase : STA $D012
          RTS
