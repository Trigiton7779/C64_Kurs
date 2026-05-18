; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 3.1 Einfaches Unrolling
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Original: 256 Bytes kopieren
; Zyklen pro Iteration: LDA(4) + STA(5) + INX(2) + BNE(3) = 14
; Gesamt: 14 × 256 = 3584 Zyklen

CopyNaive:
          LDX #$00
.loop:    LDA $C000,X
          STA $D000,X
          INX
          BNE .loop
          RTS

; Unrolled: ×8 — 8 Kopieroperationen ohne Schleifentest
; Overhead: nur noch DEX + BNE alle 8 Bytes = 5/32 Iterations
; Zyklen pro Gruppe: (4+5)×8 + 2 + 3 = 77 statt 14×8=112
; Gesamt: 77 × 32 = 2464 Zyklen → 31% schneller!

CopyUnrolled:
          LDX #32      ; 32 Gruppen à 8 Bytes
          DEX          ; X = 31 (letzter Index für 0-basiert)
.loop:
          LDA $C000+(7*1),X ; Trick: Wir kopieren rückwärts
; Einfacher: Vorwärts mit Offset-Tabelle

; Praktischste Form: Vollständig unrolled für kleine Größen
Copy32:
!for i, 0, 31 {
          LDA $C000 + i
          STA $D000 + i
}
          RTS
; 32 × (4+4) = 256 Zyklen für 32 Bytes! (ohne STA absolut,X)
; Aber: 32 × 6 Bytes = 192 Bytes Code-Größe
