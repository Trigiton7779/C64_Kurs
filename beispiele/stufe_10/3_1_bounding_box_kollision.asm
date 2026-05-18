; ============================================================
; C64 Mastery — stufe_10_meisterschaft
; Abschnitt: 3.1 Bounding-Box-Kollision
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Axis-Aligned Bounding Box (AABB) Kollision
; Für zwei Rechtecke A und B:
; Kein Overlap wenn: A.x2 
;                 ODER A.y2 

; Sprite-Bounding-Boxen
; (kann pro Sprite-Typ unterschiedlich sein)
BBoxOffX: !byte 2    ; Links-Offset vom Sprite-Ursprung
BBoxOffY: !byte 2    ; Oben-Offset
BBoxW:    !byte 20   ; Breite der BBox
BBoxH:    !byte 17   ; Höhe

; Prüfe ob Sprite A (Index in X) und Sprite B (Index in Y) kollidieren
; Ergebnis: Carry gesetzt = Kollision, Carry gelöscht = kein Kontakt
CheckBBoxCollision:
          ; A.x1 = SprLogX[A] + BBoxOffX
          LDA SprLogX,X
          CLC : ADC BBoxOffX
          STA AX1

          ; A.x2 = A.x1 + BBoxW - 1
          CLC : ADC BBoxW
          SBC #1
          STA AX2

          ; B.x1, B.x2
          LDA SprLogX,Y
          CLC : ADC BBoxOffX
          STA BX1
          CLC : ADC BBoxW
          SBC #1 : STA BX2

          ; Horizontal: A.x2 >= B.x1 AND B.x2 >= A.x1
          LDA AX2 : CMP BX1 : BCC .no_collision
          LDA BX2 : CMP AX1 : BCC .no_collision

          ; A.y1, A.y2
          LDA SprLogY,X
          CLC : ADC BBoxOffY : STA AY1
          CLC : ADC BBoxH : SBC #1 : STA AY2

          LDA SprLogY,Y
          CLC : ADC BBoxOffY : STA BY1
          CLC : ADC BBoxH : SBC #1 : STA BY2

          ; Vertikal
          LDA AY2 : CMP BY1 : BCC .no_collision
          LDA BY2 : CMP AY1 : BCC .no_collision

          SEC : RTS           ; Kollision!
.no_collision:
          CLC : RTS
