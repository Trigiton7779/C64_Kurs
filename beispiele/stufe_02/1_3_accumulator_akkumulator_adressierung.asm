; ============================================================
; C64 Mastery — stufe_02_adressierung_speicher
; Abschnitt: 1.3 Accumulator — Akkumulator-Adressierung
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
ASL A           ; Arithmetic Shift Left: A = A << 1, Bit 7 → Carry, 0 → Bit 0
LSR A           ; Logical Shift Right: A = A >> 1, Carry ← Bit 0, 0 → Bit 7
ROL A           ; Rotate Left: A = A << 1 (durch Carry), Bit 7 → Carry
ROR A           ; Rotate Right: A = A >> 1 (durch Carry), Carry → Bit 7

; Anwendungsbeispiel: Multiplikation × 2 und Division / 2
LDA #$18         ; A = 24
ASL A           ; A = 48 (× 2 durch Links-Shift)
ASL A           ; A = 96 (× 4 durch zweiten Links-Shift)
LSR A           ; A = 48 (÷ 2 durch Rechts-Shift)
