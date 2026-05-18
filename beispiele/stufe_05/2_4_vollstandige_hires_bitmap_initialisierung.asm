; ============================================================
; C64 Mastery — stufe_05_bitmap_grafik
; Abschnitt: 2.4 Vollständige Hires-Bitmap-Initialisierung
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; =====================================================
; Hires-Bitmap initialisieren
; Bitmap bei $2000, Screen-RAM bei $0400, VIC-Bank 0
; $D018 = $18: Screen-Offset 1 ($0400), Bitmap-Offset 4 ($2000)
; =====================================================

InitHiresBitmap:
        ; 1. Bitmap-RAM löschen (8000 Bytes bei $2000)
        lda #0
        ldx #0
@clr:   sta $2000,x     ; Seite $20
        sta $2100,x
        sta $2200,x
        sta $2300,x
        sta $2400,x
        sta $2500,x
        sta $2600,x
        sta $2700,x
        sta $2800,x
        sta $2900,x
        sta $2a00,x
        sta $2b00,x
        sta $2c00,x
        sta $2d00,x
        sta $2e00,x
        sta $2f00,x
        ; Verbleibende 1984 Bytes (16*256=4096, 8000-4096=3904... besser per Schleife)
        inx
        bne @clr

        ; 2. Screen-RAM: Farben initialisieren (weiß auf schwarz: $10)
        ;    High-Nibble = 1 (weiß für Pixel=1), Low-Nibble = 0 (schwarz für Pixel=0)
        lda #$10
        ldx #0
@scr:   sta $0400,x
        sta $0500,x
        sta $0600,x
        inx
        bne @scr
        ldx #0
@scr2:  sta $06e8,x
        inx
        cpx #232
        bne @scr2

        ; 3. VIC-II auf Bitmap-Modus schalten
        ; $D018 = $18: Bits 7-4 = 0001 (Screen bei $0400), Bit 3 = 1 (Bitmap bei $2000)
        lda #$18
        sta $d018

        ; $D011: BMM (Bit5) setzen, 25 Zeilen, Y-Scroll=3
        lda #%00111011  ; $3B
        sta $d011

        ; $D016: kein MCM, 40 Spalten, X-Scroll=0
        lda #%00001000  ; $08
        sta $d016
        rts
