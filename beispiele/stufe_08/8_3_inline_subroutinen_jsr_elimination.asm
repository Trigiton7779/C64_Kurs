; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 8.3 Inline-Subroutinen (JSR-Elimination)
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; JSR + RTS kostet: 6 + 6 = 12 Zyklen Overhead!
; Für kleine, oft aufgerufene Routinen: Inline-Code

; Schlecht: Winzige Subroutine mit Overhead
DoubleA:  ASL  : RTS       ; 2+6=8 Zyklen für den Aufruf
          JSR DoubleA      ; 6 Zyklen → 14 total für 2 Zyklen Arbeit!

; Gut: Direkt inline
          ASL              ; 2 Zyklen — nur die Arbeit selbst

; ACME Makro für wiederverwendbaren Inline-Code:
!macro DoubleA {
          ASL
}
          +DoubleA         ; Expandiert zu: ASL — kein Overhead!
