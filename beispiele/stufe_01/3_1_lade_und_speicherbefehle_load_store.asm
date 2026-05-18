; ============================================================
; C64 Mastery — stufe_01_6510_assembler
; Abschnitt: 3.1 Lade- und Speicherbefehle (Load / Store)
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Praxisbeispiel: 256 Bytes von Quelle nach Ziel kopieren
; Quelle: $C000–$C0FF, Ziel: $D000–$D0FF

        ldx #0             ; X = 0 (Schleifenzähler)
copy_loop:
        lda $c000,x     ; Byte von Quelladresse + X laden
        sta $d000,x     ; Byte an Zieladresse + X speichern
        inx             ; X erhöhen (X=0 → 1 → 2 → ... → 255 → 0)
        bne copy_loop   ; Wenn X noch nicht 0 geworden: weiter
        rts             ; Fertig — 256 Bytes kopiert

; Anmerkung: INX setzt das Zero-Flag wenn X = 0 wird (nach 256 Iterationen).
; BNE springt nur wenn Z=0 → Schleife läuft genau 256 Mal.
