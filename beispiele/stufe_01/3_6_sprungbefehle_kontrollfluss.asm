; ============================================================
; C64 Mastery — stufe_01_6510_assembler
; Abschnitt: 3.6 Sprungbefehle — Kontrollfluss
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Vergleich von A mit einem Wert:
; CMP setzt: Z=1 wenn A==op, C=1 wenn A>=op, N=1 wenn A<op (vorzeichenlos)

        lda $50          ; Wert laden
        cmp #10          ; Mit 10 vergleichen
        bcc kleiner     ; Springe wenn A < 10 (C=0 nach CMP bedeutet "kleiner als")
        beq gleich      ; Springe wenn A == 10 (Z=1)
; Hier: A > 10
        jmp groesser
kleiner:
        jmp done
gleich:
        jmp done
groesser:
done:   rts

; If-Then-Else Konstrukt in Assembly:
; if (A == 5) { Rahmen=Blau } else { Rahmen=Schwarz }
        cmp #5
        bne else_teil   ; Wenn A != 5, spring zum else-Teil
; then-Teil (A == 5):
        lda #6           ; Blau
        sta $D020
        jmp ende_if
else_teil:
        lda #0           ; Schwarz
        sta $D020
ende_if:
        rts
