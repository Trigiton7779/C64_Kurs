; ============================================================
; C64 Mastery — stufe_02_adressierung_speicher
; Abschnitt: 1.11 Indirect — Indirekter Sprung (nur JMP)
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Indirect JMP: Sprungtabelle für Unterprogramm-Dispatch
JumpTable:
    !word RoutineA          ; $0: Adresse von RoutineA (Low, High)
    !word RoutineB          ; $2: Adresse von RoutineB
    !word RoutineC          ; $4: Adresse von RoutineC

; Dispatch: A = Routine-Nummer (0, 1, 2)
Dispatch:
    ASL A               ; × 2 (weil jeder Eintrag 2 Bytes)
    TAX                 ; Offset in X
    LDA JumpTable,X     ; Zieladresse Low-Byte
    STA $FB             ; In ZP-Zeiger $FB
    LDA JumpTable+1,X   ; Zieladresse High-Byte
    STA $FC             ; In ZP-Zeiger $FC
    JMP ($FB)           ; Indirekter Sprung über ZP-Zeiger (KEIN $FF-Problem wenn $FB)
