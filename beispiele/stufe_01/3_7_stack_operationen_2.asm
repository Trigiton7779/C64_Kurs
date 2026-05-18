; ============================================================
; C64 Mastery — stufe_01_6510_assembler
; Abschnitt: 3.7 Stack-Operationen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Unterprogramm mit vollständiger Register-Sicherung:
; Rettet A, X, Y auf dem Stack, führt Arbeit durch, stellt alles wieder her.

mein_unterprogramm:
        pha             ; A sichern
        txa             ; X → A (damit PHA X sichern kann)
        pha             ; X (über A) sichern
        tya             ; Y → A
        pha             ; Y (über A) sichern

        ; Stack-Zustand: [SP+1]=Y, [SP+2]=X, [SP+3]=A (von unten nach oben)
        ; Hier kann beliebiger Code stehen, der A, X, Y verändert
        ldx #255
        ldy #0
        lda #$FF
        ; ...

        ; Register in UMGEKEHRTER Reihenfolge wiederherstellen:
        pla             ; Y wiederherstellen (durch A)
        tay
        pla             ; X wiederherstellen (durch A)
        tax
        pla             ; A wiederherstellen
        rts
