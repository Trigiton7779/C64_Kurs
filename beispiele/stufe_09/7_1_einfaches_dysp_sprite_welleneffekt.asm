; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 7.1 Einfaches DYSP (Sprite-Welleneffekt)
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; 1 Sprite physisch, erscheint aber 24× in einer Welle
; Raster-IRQ für jede "Instanz"

DYSP_Y:    !fill 24, 0   ; Y-Position jeder Instanz
DYSP_X:    !fill 24, 0   ; X-Position
DYSP_Ptr:  !byte 0       ; Aktuell angezeigte Instanz

; Berechne Sinus-Wellen-Positionen im VBlank
UpdateDYSP:
          LDA DYSPPhase
          LDX #0
.loop:    TXA
          CLC : ADC DYSPPhase
          TAY
          LDA SinTable,Y       ; Sinus-Wert für diese Position
          LSR : LSR            ; /4 → 0-63
          CLC : ADC #100       ; Y-Basis = 100
          STA DYSP_Y,X         ; Y-Position dieser Instanz

          TXA
          ASL : ASL : ASL      ; × 8 → X-Abstand
          CLC : ADC #20        ; X-Basis
          STA DYSP_X,X

          INX
          CPX #24 : BNE .loop
          INC DYSPPhase
          RTS

; DYSP-IRQ: Für jede Instanz aufgerufen
DYSP_IRQ:
          PHA : TXA : PHA

          LDA #$01 : STA $D019  ; Quittieren

          LDX DYSP_Ptr
          LDA DYSP_X,X : STA $D000  ; X setzen
          LDA DYSP_Y,X : STA $D001  ; Y setzen

          INX
          CPX #24 : BNE .setnext
          LDA #0 : STX DYSP_Ptr
          LDA DYSP_Y         ; Y-Pos der ersten Instanz für nächsten Frame
          STA $D012
          PLA : TAX : PLA
          RTI

.setnext: STX DYSP_Ptr
          LDA DYSP_Y,X : STA $D012  ; Nächster IRQ bei Y dieser Instanz
          PLA : TAX : PLA
          RTI
