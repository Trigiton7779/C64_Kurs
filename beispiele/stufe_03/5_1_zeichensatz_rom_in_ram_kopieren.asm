; ============================================================
; C64 Mastery — stufe_03_bildschirm_zeichen
; Abschnitt: 5.1 Zeichensatz-ROM in RAM kopieren
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; =====================================================
; ROM-Zeichensatz nach $3800 kopieren und modifizieren
; Ziel: $3800-$3FFF (2 KB für 256 Zeichen)
; VIC-II wird dann auf diesen Bereich gelenkt
; =====================================================

CopyAndModifyCharset:
        ; Schritt 1: I/O ausblenden, Zeichensatz-ROM sichtbar
        lda $01
        and #%11111011  ; Bit 2 (CHAREN) = 0 → Charset ROM erscheint bei $D000
        sta $01

        ; Schritt 2: 2048 Bytes von $D000 nach $3800 kopieren
        ldx #0
@copy:
        lda $d000,x     ; Aus Charset-ROM (Großbuchstaben/Zeichen Set 1)
        sta $3800,x
        lda $d100,x
        sta $3900,x
        lda $d200,x
        sta $3a00,x
        lda $d300,x
        sta $3b00,x
        lda $d400,x
        sta $3c00,x
        lda $d500,x
        sta $3d00,x
        lda $d600,x
        sta $3e00,x
        lda $d700,x
        sta $3f00,x
        inx
        bne @copy

        ; Schritt 3: I/O wieder einblenden
        lda $01
        ora #%00000100
        sta $01

        ; Schritt 4: Zeichen 'A' (Screen-Code $01) modifizieren
        ; Neues 'A' als Herz-Symbol
        ldx #0
@mod:   lda HeartChar,x
        sta $3808,x     ; Zeichensatz-Basis $3800 + Code 1 * 8 Bytes = $3808
        inx
        cpx #8
        bne @mod

        ; Schritt 5: VIC-II auf neuen Zeichensatz zeigen
        ; Screen-RAM bei $0400: $D018 Bits 7-4 = %0001
        ; Charset bei $3800: Offset in Bank 0 = $3800 / $800 = 7 → Bits 3-1 = %111
        ; $D018 = 0001 111 0 = $1E
        lda #$1e
        sta $d018
        rts

HeartChar:
        !byte %00000000  ; ........
        !byte %01100110  ; .##..##.
        !byte %11111111  ; ########
        !byte %11111111  ; ########
        !byte %01111110  ; .######.
        !byte %00111100  ; ..####..
        !byte %00011000  ; ...##...
        !byte %00000000  ; ........
