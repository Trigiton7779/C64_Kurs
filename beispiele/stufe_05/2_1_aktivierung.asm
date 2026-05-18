; ============================================================
; C64 Mastery — stufe_05_bitmap_grafik
; Abschnitt: 2.1 Aktivierung
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Hires-Bitmap-Modus aktivieren:
lda $d011
ora #%00100000  ; Bit 5 (BMM) setzen
sta $d011

; MCM (Multicolor) muss 0 sein:
lda $d016
and #%11101111  ; Bit 4 löschen
sta $d016
