; ============================================================
; C64 Mastery — stufe_05_bitmap_grafik
; Abschnitt: 3.3 Koala-Format
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Koala-Bild anzeigen (Annahme: bereits bei Standard-Adressen geladen)
; Bitmap bei $6000, Screen bei $7F40, Color bei $8328, BG bei $8710

ShowKoala:
        ; Multicolor-Modus aktivieren
        lda #$3b : sta $d011    ; BMM + 25 Zeilen + Y-Scroll=3
        lda #$18 : sta $d016    ; MCM + 40 Spalten

        ; Bitmap bei $6000: VIC-Bank auf $4000-$7FFF (Bank 1)
        lda $dd00
        and #%11111100
        ora #%00000010  ; Bank 1 ($4000-$7FFF)
        sta $dd00

        ; Screen bei $7F40: Offset in Bank 1 = $7F40-$4000 = $3F40
        ; $D018 Bits 7-4: $3F40 / $0400 = 15 → Wert $F → Bits 7-4 = %1111
        ; Bitmap bei $6000: Offset $6000-$4000 = $2000 → Bit 3 = 1
        lda #%11111000  ; Screen=$3C00 in Bank... (vereinfachte Version)
        ; Korrekt: Screen $7F40 - VIC-Bank-Basis $4000 = $3F40
        ; $3F40 / $0400 = 15 (gerundet auf nächste $0400-Grenze = $3C00)
        ; Hinweis: Koala lädt normalerweise auf feste Adressen, Details je nach Version

        ; Hintergrundfarbe setzen
        lda $8710
        sta $d021

        ; Color-RAM füllen (1000 Bytes von $8328 nach $D800 kopieren)
        ldx #0
@clr1:  lda $8328,x : sta $d800,x
        lda $8428,x : sta $d900,x
        lda $8528,x : sta $da00,x
        inx : bne @clr1
        ldx #0
@clr2:  lda $8628,x : sta $dae8,x
        inx : cpx #232 : bne @clr2

        rts
