; ============================================================
; C64 Mastery — stufe_03_bildschirm_zeichen
; Abschnitt: 6.1 Aktivierung
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Multicolor-Zeichenmodus aktivieren:
lda $d016
ora #%00010000  ; Bit 4 (MCM) setzen
sta $d016
