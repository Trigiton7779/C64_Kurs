; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 6.2 DCP — Decrement und Compare
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Standard: Zähler dekrementieren und prüfen
          DEC Counter      ; 5 Zyklen (Absolut)
          LDA Counter      ; 4 Zyklen
          CMP #5           ; 2 Zyklen
          BEQ Match        ; 3/2 Zyklen
; Total: 14 Zyklen

; Mit DCP (Zero Page!)
          DCP CounterZP    ; 5 Zyklen: DEC ZP + CMP A → Flags gesetzt!
          BEQ Match        ; 3/2 Zyklen
; Total: 8 Zyklen → 43% schneller!
; Achtung: DCP vergleicht mit dem Akkumulator-Wert VOR dem DEC
