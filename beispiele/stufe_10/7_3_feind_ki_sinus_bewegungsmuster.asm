; ============================================================
; C64 Mastery — stufe_10_meisterschaft
; Abschnitt: 7.3 Feind-KI: Sinus-Bewegungsmuster
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Feinde bewegen sich in Sinus-Wellen horizontal
; + langsam nach unten (auf den Spieler zu)
NUM_ENEMIES = 8

EnemyAngle: !fill NUM_ENEMIES, 0   ; Phase per Feind
EnemyBaseX: !fill NUM_ENEMIES, 0   ; Basis-X (Mitte der Welle)
EnemyAlive: !fill NUM_ENEMIES, 0   ; 1=lebt, 0=tot

EnemyUpdate:
          LDX #0
.loop:    LDA EnemyAlive,X : BEQ .skip

          ; Sinus-X: BaseX + sin(Angle) * 30
          LDA EnemyAngle,X : TAY
          LDA SinTable,Y
          SEC : SBC #128     ; -128..127
          ; Skalieren: /4 → -32..31
          CMP #$80 : BCC .pos
          SEC : SBC #0       ; War negativ: Vorzeichen erhalten
.pos:     ASL : ASL          ; × 4 rückgängig für /4: → ASR ASR
          ; Vereinfacht: nur +/- offset auf BaseX
          LDA SinTable+1,X   ; Anderer Ansatz...

          ; Sinus ÷ 4 = Amplitude 30 Pixel
          LDA EnemyAngle,X : TAY
          LDA SinTable,Y
          LSR : LSR          ; /4
          CLC : ADC EnemyBaseX,X
          STA SprLogX + 1,X  ; +1 weil Index 0 = Spieler

          ; Langsam nach unten
          LDA SprLogY + 1,X
          CLC : ADC #1
          CMP #230 : BCC .ok_y
          LDA #50            ; Oben neu erscheinen
.ok_y:    STA SprLogY + 1,X

          INC EnemyAngle,X   ; Phase weiterbewegen

.skip:    INX : CPX #NUM_ENEMIES : BNE .loop
          RTS
