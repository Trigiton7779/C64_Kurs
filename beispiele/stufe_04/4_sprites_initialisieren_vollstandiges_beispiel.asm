; ============================================================
; C64 Mastery — stufe_04_sprites_animation
; Abschnitt: 4. Sprites initialisieren — vollständiges Beispiel
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; =====================================================
; Sprite-Demo: 8 Sprites, jeder mit anderer Farbe
; Sprite-Daten bei $0C00 (Pointer $30)
; =====================================================

!to "sprites.prg", cbm
* = $0801
!byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00
* = $080d

main:
        ; Bildschirm schwarz
        lda #0 : sta $d020 : sta $d021

        ; Sprite-Daten initialisieren (Stern-Form bei $0C00)
        jsr CopyStarSprite

        ; Alle 8 Sprite-Pointer setzen (alle auf denselben Datensatz $0C00)
        lda #$30        ; $0C00 / 64 = $30
        ldx #7
@ptr:   sta $07f8,x
        dex
        bpl @ptr

        ; Sprites positionieren (horizontal verteilt)
        lda #0
        sta $d010       ; X-MSB: alle auf unter 256
        ldx #0
@pos:   lda StartX,x    ; X-Position
        sta $d000,x     ; Sprite n X
        lda #120        ; Alle auf Y=120
        sta $d001,x     ; Sprite n Y
        inx
        inx
        cpx #16
        bne @pos

        ; Farben setzen (jeder Sprite eine andere Farbe)
        lda #1  : sta $d027  ; Sprite 0: Weiß
        lda #7  : sta $d028  ; Sprite 1: Gelb
        lda #5  : sta $d029  ; Sprite 2: Grün
        lda #3  : sta $d02a  ; Sprite 3: Cyan
        lda #6  : sta $d02b  ; Sprite 4: Blau
        lda #4  : sta $d02c  ; Sprite 5: Violett
        lda #2  : sta $d02d  ; Sprite 6: Rot
        lda #8  : sta $d02e  ; Sprite 7: Orange

        ; Alle 8 Sprites aktivieren
        lda #%11111111
        sta $d015

        ; Endlosschleife
@loop:  jmp @loop

StartX: !byte 30,65,100,135,170,205,240,275
; Achtung: Sprite 7 X=275 > 255, X-MSB Bit 7 muss gesetzt sein!
; Für dieses Beispiel vereinfacht (275 -> überschreitet 255)

; Sternförmiges Sprite in $0C00 schreiben
CopyStarSprite:
        ldx #0
@cp:    lda StarData,x
        sta $0c00,x
        inx
        cpx #64
        bne @cp
        rts

StarData:
        !byte %00000001,%10000000,%00000000  ; Zeile 0
        !byte %00000001,%10000000,%00000000  ; Zeile 1
        !byte %00000001,%10000000,%00000000  ; Zeile 2
        !byte %00000001,%10000000,%00000000  ; Zeile 3
        !byte %00000001,%10000000,%00000000  ; Zeile 4
        !byte %00000001,%10000000,%00000000  ; Zeile 5
        !byte %01111111,%11111111,%11111110  ; Zeile 6 -- waagrecht
        !byte %01111111,%11111111,%11111110  ; Zeile 7
        !byte %00000001,%10000000,%00000000  ; Zeile 8
        !byte %00000001,%10000000,%00000000  ; Zeile 9
        !byte %00000001,%10000000,%00000000  ; Zeile 10
        !byte %00000000,%00000000,%00000000  ; Zeile 11-20
        !byte 0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0
        !byte 0,0,0, 0,0,0, 0,0,0, 0,0,0
        !byte 0  ; 64. Byte
