; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 2.3 Sinusbewegung der Rasterbars
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Rasterbars auf Sinuskurve auf und ab bewegen
; RasterAngle: 0-255 Schrittzähler, wird jeden Frame erhöht

RasterAngle: !byte 0

UpdateRasterPos:
          LDX RasterAngle
          LDA SinTable,X         ; 0-255
          LSR : LSR              ; /4 → 0-63
          CLC
          ADC #40                ; Basis-Y = 40
          STA CopperList         ; Ersten Copper-Eintrag updaten

          INC RasterAngle
          RTS
