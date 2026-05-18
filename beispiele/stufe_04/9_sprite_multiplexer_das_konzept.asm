; ============================================================
; C64 Mastery — stufe_04_sprites_animation
; Abschnitt: 9. Sprite-Multiplexer — Das Konzept
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Grundprinzip Sprite-Multiplex (2 logische Sprites mit 1 Hardware-Sprite):
;
; IRQ auf Y-Position von Sprite A (z.B. Y=80):
;   → Hardware-Sprite auf A-Daten zeigen
;   → Nächsten IRQ auf Y-Position von Sprite B setzen
;
; IRQ auf Y-Position von Sprite B (z.B. Y=140):
;   → Hardware-Sprite auf B-Daten zeigen
;   → Nächsten IRQ auf Y-Position von Sprite A setzen
;
; So wechseln sich A und B ab. Voraussetzung: Y-Abstand > 21 Pixel!

; Dieser Multiplexer wird in Stufe 7 (Interrupts) vollständig implementiert.
