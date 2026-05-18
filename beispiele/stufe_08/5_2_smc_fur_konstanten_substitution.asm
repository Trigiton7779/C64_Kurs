; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 5.2 SMC für Konstanten-Substitution
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Anpassbare Zeichensatz-Ausgabe ohne Parameterübergabe

DrawChar:
; Patch: Zeichennummer direkt im LDA-Immediate eintragen
SMC_Char: LDA #$41           ; Byte 1 = LDA-Opcode ($A9), Byte 2 = Wert
          ASL                ; × 8 (8 Bytes pro Zeichen im Charset)
          ASL
          ASL
          ; ... Zeichendaten ausgeben
          RTS

; Aufrufer patcht die Zeichennummer:
          LDA CharCode
          STA SMC_Char+1     ; Byte nach dem Opcode = Immediate-Wert
          JSR DrawChar
