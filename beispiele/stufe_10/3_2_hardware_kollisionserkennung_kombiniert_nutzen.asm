; ============================================================
; C64 Mastery — stufe_10_meisterschaft
; Abschnitt: 3.2 Hardware-Kollisionserkennung kombiniert nutzen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Kombinierter Ansatz: Hardware für erste Grob-Prüfung,
; dann BBox für genaue Bestimmung

CheckCollisions:
          ; Phase 1: Hardware-Register lesen
          LDA $D01E          ; Sprite-Sprite Kollision (LÖSCHT sich beim Lesen!)
          BEQ .check_bg      ; Keine Sprite-Kollision
          STA CollidedSprites

          ; Prüfe welche Sprites kollidierten (Bit-Scan)
          LDX #0
.bits:    LSR CollidedSprites
          BCC .next_bit
          ; Sprite X hat Hardware-Kollision → BBox prüfen
          ; (Partner nicht direkt bekannt → alle anderen prüfen)
          JSR FindCollisionPartner  ; X = Sprite-Index
.next_bit:INX
          CPX #8 : BNE .bits

.check_bg:
          LDA $D01F          ; Sprite-Hintergrund Kollision
          BEQ .done
          STA CollidedBG
          ; Sprites mit BG-Kollision verarbeiten
          LDX #0
.bgbits:  LSR CollidedBG
          BCC .next_bg
          JSR HandleSprBGCollision
.next_bg: INX : CPX #8 : BNE .bgbits
.done:    RTS
