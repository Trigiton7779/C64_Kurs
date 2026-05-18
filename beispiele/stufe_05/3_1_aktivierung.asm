; ============================================================
; C64 Mastery — stufe_05_bitmap_grafik
; Abschnitt: 3.1 Aktivierung
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Multicolor-Bitmap aktivieren:
lda #%00111011  ; $D011: BMM setzen
sta $d011
lda #%00011000  ; $D016: MCM (Bit4) + 40 Spalten
sta $d016
