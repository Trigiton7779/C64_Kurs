; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 1.2 Part-Wechsel-Mechanismus
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Part-Wechsel: jeder Part läuft N Frames, dann weiter

CheckPartChange:
          INC PartTimer
          BNE .noHi
          INC PartTimer+1
.noHi:
          LDA PartTimer+1      ; High-Byte
          CMP #1               ; 256 Frames = ca. 5 Sekunden
          BNE .done

          ; Part-Wechsel!
          LDA #0
          STA PartTimer
          STA PartTimer+1

          INC DemoState
          LDA DemoState
          CMP #3               ; 3 Parts? Von vorn
          BNE .switch
          LDA #0
          STA DemoState

.switch:  JSR SwitchPart       ; IRQ umhängen, neue Daten
.done:    RTS
