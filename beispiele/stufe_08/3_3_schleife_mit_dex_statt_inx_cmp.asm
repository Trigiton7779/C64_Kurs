; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 3.3 Schleife mit DEX statt INX+CMP
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Falsch (ineffizient):
          LDX #0
.loop:    LDA Data,X
          ; ... verarbeiten ...
          INX
          CPX #128   ; 2 Zyklen extra pro Iteration!
          BNE .loop

; Richtig — rückwärts zählen, BNE als Zero-Test:
          LDX #128
.loop:    LDA Data-1,X   ; Offset -1 wegen DEX vorher
          ; ... verarbeiten ...
          DEX            ; 2 Zyklen
          BNE .loop      ; 3/2 Zyklen — setzt Z-Flag direkt!
; Erspart CPX #N (2 Zyklen) pro Iteration → bei 128 Iterationen: 256 Zyklen gespart
