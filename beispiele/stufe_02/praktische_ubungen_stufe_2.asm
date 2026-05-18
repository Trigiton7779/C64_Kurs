; ============================================================
; C64 Mastery — stufe_02_adressierung_speicher
; Abschnitt: Praktische Übungen — Stufe 2
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
LDA #$FF     ; 1. ___
STA $0400   ; 2. ___
INX          ; 3. ___
LDA $20,X   ; 4. ___ (wenn X=$05, Eff.Addr=?)
JMP ($4000) ; 5. ___
LDA ($FB),Y ; 6. ___
BNE -5      ; 7. ___
ASL A        ; 8. ___
LDA $C000,Y ; 9. ___ (Page-Crossing wenn Y=?)
STX $50,Y   ; 10. ___
LDA ($20,X)  ; 11. ___
RTS          ; 12. ___
LDA $D800,X ; 13. ___
CMP #0      ; 14. ___
LDA $FC     ; 15. ___
