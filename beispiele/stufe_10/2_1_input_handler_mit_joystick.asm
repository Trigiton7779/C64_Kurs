; ============================================================
; C64 Mastery — stufe_10_meisterschaft
; Abschnitt: 2.1 Input-Handler mit Joystick
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Joystick Port 2 = $DC00
; Bits: 0=Up, 1=Down, 2=Left, 3=Right, 4=Fire (active LOW)

JoyState:    !byte 0   ; Aktueller Zustand (invertiert: 1=gedrückt)
JoyStatePrev:!byte 0   ; Vorheriger Zustand
JoyPressed:  !byte 0   ; Gerade gedrückt (flankengetriggert)
JoyReleased: !byte 0   ; Gerade losgelassen

JOY_UP    = %00000001
JOY_DOWN  = %00000010
JOY_LEFT  = %00000100
JOY_RIGHT = %00001000
JOY_FIRE  = %00010000

ReadJoystick:
          LDA JoyState : STA JoyStatePrev

          LDA $DC00
          EOR #$FF           ; Invertieren (active LOW → active HIGH)
          AND #$1F           ; Nur Bits 0-4
          STA JoyState

          ; JoyPressed = neue Bits (jetzt 1, vorher 0)
          EOR JoyStatePrev
          AND JoyState
          STA JoyPressed

          ; JoyReleased = verschwundene Bits (jetzt 0, vorher 1)
          LDA JoyState
          EOR JoyStatePrev
          AND JoyStatePrev
          STA JoyReleased
          RTS

; Verwendung:
;   LDA JoyState
;   AND #JOY_RIGHT
;   BNE .moving_right
;
;   LDA JoyPressed
;   AND #JOY_FIRE
;   BNE .just_fired   (nur im ersten Frame)
