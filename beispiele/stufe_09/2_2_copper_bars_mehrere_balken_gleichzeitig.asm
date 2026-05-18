; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 2.2 Copper-Bars — Mehrere Balken gleichzeitig
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Copper-Bars: Liste von (Zeile, Farbe) Paaren
; Abarbeitung wie der Amiga-Copper, aber alles in Software

; Copper-Liste Format:
; !byte Zeile, Farbe (oder $FF,$FF für Ende)
CopperList:
          !byte  40, 0   ; Zeile 40: Schwarz
          !byte  50, 2   ; Zeile 50: Rot
          !byte  60, 8   ; Zeile 60: Orange
          !byte  70, 7   ; Zeile 70: Gelb
          !byte  80, 5   ; Zeile 80: Grün
          !byte  90, 3   ; Zeile 90: Cyan
          !byte 100, 6   ; Zeile 100: Blau
          !byte 110, 4   ; Zeile 110: Lila
          !byte 120, 0   ; Zeile 120: Schwarz (Ende der Bar)
          !byte $FF, $FF ; Ende der Liste

CopperIndex: !byte 0  ; Aktueller Index in CopperList

SetupCopperIRQ:
          SEI
          LDA #$7F : STA $DC0D
          LDA #$01 : STA $D01A
          LDA CopperList       ; Erste Zeile
          STA $D012
          LDA #0 : STA CopperIndex
          LDA #<CopperIRQ : STA $0314
          LDA #>CopperIRQ : STA $0315
          CLI
          RTS

CopperIRQ:
          PHA : TXA : PHA
          LDA #$01 : STA $D019   ; IRQ quittieren

          LDX CopperIndex
          LDA CopperList+1,X     ; Farbe für diese Zeile
          BMI .reset             ; $FF → Ende erreicht
          STA $D021              ; Farbe setzen

          INX : INX              ; Nächsten Eintrag
          STX CopperIndex
          LDA CopperList,X       ; Nächste Zeile
          BMI .reset
          STA $D012              ; IRQ für nächste Zeile
          PLA : TAX : PLA
          RTI

.reset:   LDA #0 : STA CopperIndex
          LDA CopperList         ; Zur ersten Zeile zurück
          STA $D012
          LDA #0 : STA $D021     ; Hintergrund zurück
          PLA : TAX : PLA
          RTI
