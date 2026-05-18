; ============================================================
; C64 Mastery — stufe_03_bildschirm_zeichen
; Abschnitt: 3.2 Vollständiges Beispiel: Text ohne KERNAL ausgeben
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; =====================================================
; Direkte Bildschirmausgabe ohne KERNAL
; Assembliert mit ACME
; =====================================================

!to "direkt.prg", cbm

* = $0801
!byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00

* = $080d

main:
        ; Hintergrund schwarz, Border dunkelblau
        lda #0
        sta $d021       ; Hintergrundfarbe = Schwarz
        lda #6
        sta $d020       ; Border = Blau

        ; Bildschirm löschen (Leerzeichen = Screen-Code $20)
        lda #$20
        ldx #0
@clr:   sta $0400,x
        sta $0500,x
        sta $0600,x
        inx
        bne @clr
        ; Letzte 1000-(3*256)=232 Zeichen
        ldx #0
@clr2:  sta $06e8,x
        inx
        cpx #232
        bne @clr2

        ; Farbe für alle Zeichen auf Weiß (1) setzen
        lda #1
        ldx #0
@col:   sta $d800,x
        sta $d900,x
        sta $da00,x
        inx
        bne @col
        ldx #0
@col2:  sta $dae8,x
        inx
        cpx #232
        bne @col2

        ; Text schreiben: "HALLO C64!" ab Position (5,12)
        ; Zeile 12, Spalte 5 -> Adresse $0400 + 12*40 + 5 = $0400 + 485 = $05E5
        ldx #0
@txt:   lda MsgScreenCodes,x
        beq @done_txt
        sta $05e5,x
        ; Gelbe Farbe (7) für diesen Text
        lda #7
        sta $dde5,x     ; $D800 + $05E5 - $0400 = $D9E5...
        ; Korrekt: Color-RAM Offset = Screen-RAM Offset
        ; Screen bei $0400, Color bei $D800 -> Offset identisch
        ; $05E5 - $0400 = $01E5 -> Color-RAM: $D800 + $01E5 = $D9E5
        lda #7          ; Gelb
        sta $d9e5,x
        lda MsgScreenCodes,x
        sta $05e5,x
        inx
        jmp @txt
@done_txt:
        rts

; PETSCII zu Screen-Code Konvertierung:
; Großbuchstaben A-Z: PETSCII $41-$5A -> Screen-Code $01-$1A
; Leerzeichen: PETSCII $20 -> Screen-Code $20
; Ziffern 0-9: PETSCII $30-$39 -> Screen-Code $30-$39
MsgScreenCodes:
        !byte $08,$01,$0c,$0c,$0f,$20,$03,$36,$34,$21,$00
        ; H    A    L    L    O   SPC C    6    4    !   Ende
