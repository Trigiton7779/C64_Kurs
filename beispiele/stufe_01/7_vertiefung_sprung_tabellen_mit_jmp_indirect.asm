; ============================================================
; C64 Mastery — stufe_01_6510_assembler
; Abschnitt: 7. Vertiefung: Sprung-Tabellen mit JMP (indirect)
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Sprung-Tabelle: Ruft je nach Wert in A (0–3) verschiedene Routinen auf
; Methode: JMP über indirekte Adressierung (JMP ($addr))

dispatch:
    ; A enthält den Selektor (0, 1, 2 oder 3)
    ; Sprung-Vektor-Adresse berechnen: Tabelle + (A × 2)
    asl a              ; A × 2 (jeder Tabelleneintr. = 2 Bytes)
    tax               ; Als Index-Register
    lda jump_table,x   ; Low-Byte der Zieladresse
    sta $FE            ; In ZP-Pointer speichern
    lda jump_table+1,x ; High-Byte der Zieladresse
    sta $FF            ; In ZP-Pointer+1 speichern
    jmp ($FE)          ; Indirekter Sprung über $FE/$FF

jump_table:
    !word routine_0    ; Eintrag 0: Adresse von routine_0
    !word routine_1    ; Eintrag 1: Adresse von routine_1
    !word routine_2    ; Eintrag 2: Adresse von routine_2
    !word routine_3    ; Eintrag 3: Adresse von routine_3

routine_0:  lda #0  sta $D020  rts   ; Rahmen schwarz
routine_1:  lda #1  sta $D020  rts   ; Rahmen weiß
routine_2:  lda #2  sta $D020  rts   ; Rahmen rot
routine_3:  lda #6  sta $D020  rts   ; Rahmen blau
