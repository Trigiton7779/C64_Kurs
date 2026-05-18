; ============================================================
; C64 Mastery — stufe_05_bitmap_grafik
; Abschnitt: 2.5 Pixel setzen und löschen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Pixel setzen (1) oder löschen (0)
; Eingabe: $60 = px (0-319), $62 = py (0-199), $64 = Aktion (0=löschen, 1=setzen)

SetPixel:
        ; Byte-Adresse berechnen
        ; Zellen-Zeile = py/8, Zellen-Spalte = px/8
        lda $62         ; py
        lsr
        lsr
        lsr             ; py/8 = Zellen-Zeile (0-24)
        tax             ; X = Zellen-Zeile
        lda RowOffsLo,x ; Low-Byte des Zeilen-Offsets
        sta $fb
        lda RowOffsHi,x ; High-Byte
        sta $fc         ; $fb/$fc = Zellen-Zeile * 320

        ; Zellen-Spalte * 8 addieren
        lda $60         ; px
        and #%11111000  ; px & ~7 = (px/8)*8
        clc
        adc $fb
        sta $fb
        bcc @noc1
        inc $fc
@noc1:
        ; py MOD 8 addieren
        lda $62
        and #$07        ; py & 7 = py MOD 8
        clc
        adc $fb
        sta $fb
        bcc @noc2
        inc $fc
@noc2:
        ; Bitmap-Basis $2000 addieren
        lda $fc
        clc
        adc #$20        ; Hi-Byte von $2000
        sta $fc

        ; Bit-Maske berechnen: Bit = 7 - (px MOD 8)
        lda $60
        and #$07        ; px MOD 8
        tax
        lda BitMasks,x  ; Bit-Maske

        ; Pixel setzen oder löschen
        ldy #0
        bit $64
        beq @clear_pixel
        ora ($fb),y     ; Bit setzen (OR)
        bne @store
@clear_pixel:
        eor #$ff        ; Invertieren für AND-Maske
        and ($fb),y     ; Bit löschen
@store: sta ($fb),y
        rts

BitMasks: !byte $80,$40,$20,$10,$08,$04,$02,$01

; Zeilen-Offset-Tabelle: Zellen-Zeile N * 320 (Lo/Hi)
RowOffsLo:
        !byte (0*320),>(1*320),>(2*320),>(3*320),>(4*320)
        !byte >(5*320),>(6*320),>(7*320),>(8*320),>(9*320)
        !byte >(10*320),>(11*320),>(12*320),>(13*320),>(14*320)
        !byte >(15*320),>(16*320),>(17*320),>(18*320),>(19*320)
        !byte >(20*320),>(21*320),>(22*320),>(23*320),>(24*320)
