; ============================================================
; C64 Mastery — stufe_02_adressierung_speicher
; Abschnitt: 2.3 Der Hardware-Stack ($0100–$01FF)
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Stack-Mechanismus im Detail:
; PHA: Schreibe A nach [$0100 + SP], dann SP--
; PLA: SP++, dann lese A von [$0100 + SP]
; JSR: Push (PC+2) Low dann High, dann PC = Zieladresse (SP -= 2)
; RTS: Pop High dann Low, PC = Wert + 1 (SP += 2)

; Typische Verwendung: Register sichern/restaurieren
MeineRoutine:
        pha                 ; A sichern
        txa
        pha                 ; X sichern (via A)
        tya
        pha                 ; Y sichern (via A)

        ; ... eigentliche Arbeit ...

        pla
        tay                 ; Y restaurieren
        pla
        tax                 ; X restaurieren
        pla                 ; A restaurieren
        rts
