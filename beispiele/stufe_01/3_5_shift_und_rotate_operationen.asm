; ============================================================
; C64 Mastery — stufe_01_6510_assembler
; Abschnitt: 3.5 Shift- und Rotate-Operationen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Einfache Shifts — Multiplikation und Division durch 2
        lda #10          ; A = 10
        asl a           ; A = A * 2 = 20 (Linksshift)
        asl a           ; A = 20 * 2 = 40 (nochmal)
        lsr a           ; A = 40 / 2 = 20 (Rechtsshift)

; 16-Bit Linksshift (×2) eines 16-Bit-Werts in $20/$21
        asl $20          ; Low-Byte verschieben; Carry = altes Bit 7 des Low-Bytes
        rol $21          ; High-Byte rotieren (Carry = neues Bit 0 des High-Bytes!)
; Resultat: 16-Bit-Wert um 1 nach links geschoben (×2)

; Bits eines Bytes einzeln auswerten (Bit-Test durch Rotation)
        lda $50          ; Byte laden
        lsr a           ; Bit 0 → Carry; Rest nach rechts
        bcc bit0_clear  ; Springe wenn Carry = 0 (Bit 0 war 0)
; Hier: Bit 0 war 1
bit0_clear:
; Hier: Bit 0 war 0
