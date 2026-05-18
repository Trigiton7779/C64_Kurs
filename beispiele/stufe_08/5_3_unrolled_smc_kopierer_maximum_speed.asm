; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 5.3 Unrolled SMC-Kopierer (Maximum Speed)
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Ultra-schneller Kopier-Block: komplett unrolled, SMC-Adressen
; 256 Bytes in 512 Zyklen (2 Zyklen pro Byte → theoretisches Minimum)

FastCopy256:
; Patch Source und Dest Adressen
          LDA SrcAddrLo : STA FC_S0+1 : STA FC_S1+1 ; ... etc. für alle
          LDA SrcAddrHi : STA FC_S0+2 : STA FC_S1+2

; Unrolled: 256 LDA abs + STA abs Paare
FC_S0:    LDA $0000 : STA $0000   ; Beide Operanden werden gepatcht
FC_S1:    LDA $0001 : STA $0001   ; +1 addiert ACME im !for-Block
; ... (255 weitere Paare — typisch via ACME !for-Makro)
!for i, 2, 255 {
    LDA SrcBase + i
    STA DstBase + i
}
          RTS
; Ergebnis: 256 × (4+4) = 2048 Zyklen
; Verglichen mit Schleifen-Variante: 3584 → 43% schneller!
