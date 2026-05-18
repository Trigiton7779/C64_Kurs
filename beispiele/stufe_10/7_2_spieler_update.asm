; ============================================================
; C64 Mastery — stufe_10_meisterschaft
; Abschnitt: 7.2 Spieler-Update
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Spieler bewegen (8 Richtungen, Grenzen beachten)
PLAYER_SPEED = 2
PLAYER_X_MIN = 20 : PLAYER_X_MAX = 220
PLAYER_Y_MIN = 50 : PLAYER_Y_MAX = 220

PlayerUpdate:
          LDA JoyState

          LSR                ; Bit 0 = Up
          BCC .no_up
          LDA SprLogY       ; Spieler ist immer Index 0
          SEC : SBC #PLAYER_SPEED
          CMP #PLAYER_Y_MIN : BCS .ok_up
          LDA #PLAYER_Y_MIN
.ok_up:   STA SprLogY
.no_up:

          LSR                ; Bit 1 = Down
          BCC .no_down
          LDA SprLogY
          CLC : ADC #PLAYER_SPEED
          CMP #PLAYER_Y_MAX : BCC .ok_down
          LDA #PLAYER_Y_MAX
.ok_down: STA SprLogY
.no_down:

          LSR                ; Bit 2 = Left
          BCC .no_left
          LDA SprLogX
          SEC : SBC #PLAYER_SPEED
          CMP #PLAYER_X_MIN : BCS .ok_left
          LDA #PLAYER_X_MIN
.ok_left: STA SprLogX
.no_left:

          LSR                ; Bit 3 = Right
          BCC .no_right
          LDA SprLogX
          CLC : ADC #PLAYER_SPEED
          CMP #PLAYER_X_MAX : BCC .ok_right
          LDA #PLAYER_X_MAX
.ok_right: STA SprLogX
.no_right:

          ; Fire
          LDA JoyPressed : AND #JOY_FIRE : BEQ .no_fire
          JSR SpawnBullet
          JSR PlayLaserSound
.no_fire: RTS
