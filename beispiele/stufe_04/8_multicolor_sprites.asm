; ============================================================
; C64 Mastery — stufe_04_sprites_animation
; Abschnitt: 8. Multicolor-Sprites
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Multicolor-Sprite aktivieren (Sprite 0):
lda $d01c
ora #%00000001  ; Bit 0 = Sprite 0
sta $d01c

; Farben setzen:
lda #7  : sta $d025  ; MC Farbe 0 (für %01 Bits) = Gelb
lda #1  : sta $d026  ; MC Farbe 1 (für %11 Bits) = Weiß
lda #2  : sta $d027  ; Sprite 0 Individualfarbe (für %10 Bits) = Rot
; %00 Bits = transparent (unsichtbar)
