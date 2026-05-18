; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 9.5 Vollbild-Laufschrift inkl. Border-Bereich
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Vollbild-Sprite-Scroller: 8 Sprites nebeneinander
; Jedes Sprite = 24 Pixel breit. Mit Stretch (Double-Width): 48 Pixel
; 8 × 48 = 384 Pixel — deckt volle PAL-Breite (403 Pixel) fast komplett

; --- Sprite-Initialisierung ---
ScrollInit:
          LDA #$FF
          STA $D015          ; alle 8 Sprites ein
          LDA #$FF
          STA $D01D          ; alle Sprites doppelt breit (X-Stretch)
          LDA #1             ; Farbe: Weiß
          LDX #7
.colloop: STA $D027,X        ; Sprite 0–7 Farbe setzen
          DEX : BPL .colloop

          ; Sprite Y-Position: Zeile 240 (unterer Bereich)
          LDA #240
          LDX #0
.yloop:   STA $D001,X        ; Y-Position (ungerade Adressen $D001,$D003,...)
          INX : INX
          CPX #16 : BNE .yloop
          RTS

; --- Scroll-Update (einmal pro Frame im VBlank) ---
ScrollX:  !byte 0, 0         ; Lo/Hi des globalen X-Offsets (0–511)

ScrollUpdate:
          ; Alle 8 Sprites gleichmäßig nach links schieben
          ; Sprite 0 beginnt bei ScrollX, jedes weitere +48 (Double-Width-Abstand)
          LDA ScrollX
          SEC
          SBC #2             ; 2 Pixel pro Frame nach links
          STA ScrollX
          BCS .no_borrow
          DEC ScrollX+1
.no_borrow:
          LDX #0
          LDA #0
          STA $D010          ; X-MSB-Register zurücksetzen

.sprloop: ; X-Position für Sprite X berechnen
          LDA ScrollX        ; Basis-X
          CLC
          ADC SprOffsets,X   ; + Sprite-Abstand (0,48,96,144,...)
          STA $D000,X        ; X-Position Lo (gerade Adressen)
          ; X-Bit 8 korrekt setzen
          LDA ScrollX+1
          ADC #0             ; Carry aus Addition
          AND #1
          BEQ .no_msb
          LDA $D010
          ORA BitTable,X     ; Bit für dieses Sprite setzen
          STA $D010
.no_msb:  INX : INX
          CPX #16 : BNE .sprloop
          RTS

SprOffsets: !byte  0,  0, 48,  0, 96,  0,144,  0   ; Lo-Bytes der Abstände
BitTable:   !byte $01,$02,$04,$08,$10,$20,$40,$80
