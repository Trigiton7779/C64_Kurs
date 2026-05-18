; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 8.1 Rotierende Zeichen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Zeichen animieren: ROL/ROR auf die Zeichendaten jeden Frame
; Effekt: Zeichen "rotiert" sich Pixel für Pixel

AnimateChar:
          LDA CharAddr+1   ; High-Byte der Zeichen-Adresse (SMC)
          LDX #7           ; 8 Bytes pro Zeichen
          CLC
.loop:    LDA CustomChar,X
          ROL              ; Rotiere links (Bit 7 → Carry → Bit 0)
          STA CustomChar,X
          DEX
          BPL .loop
          RTS

; Waving-Text: Jede Zeile des Zeichens aus versetzter Sinus-Phase

WavePhase: !byte 0

AnimateWave:
          LDX #0
.charloop:; Für jedes animierte Zeichen
          LDA WavePhase
          CLC : ADC CharOffsets,X  ; Zeichen-eigene Phase
          TAY
          LDA SinTable,Y   ; Sinus-Wert
          LSR : LSR : LSR  ; /8 → 0-31
          STA WaveRow      ; Welche Zeile soll "hell" sein

          ; Zeichendaten schreiben: nur WaveRow ist "breit"
          LDY #0
.rowloop: CPY WaveRow
          BNE .normal
          LDA #$FF         ; Volle Zeile
          JMP .write
.normal:  LDA NormalChar,Y ; Normale Zeichen-Daten
.write:   STA (CharPtr),Y
          INY : CPY #8 : BNE .rowloop

          INX
          CPX NumAnimChars : BNE .charloop

          INC WavePhase
          RTS
