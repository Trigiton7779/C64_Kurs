; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 4.1 Datenstrukturen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Logische Sprites: bis zu 24 Sprites
MAX_SPRITES = 24

; Arrays für alle logischen Sprites (in Zero Page oder nahe ZP)
SprLogX:    !fill MAX_SPRITES, 0   ; X-Position (0-255, +$D010 für >255)
SprLogY:    !fill MAX_SPRITES, 0   ; Y-Position (50-250 sinnvoll)
SprLogFrame:!fill MAX_SPRITES, 0   ; Grafikzeiger ($07F8-Format)
SprLogColor:!fill MAX_SPRITES, 0   ; Farbe
SprLogActive:!fill MAX_SPRITES, 0  ; 0=inaktiv, 1=aktiv

; Sortiertabelle: Indizes in aufsteigender Y-Reihenfolge
SortedIdx:  !fill MAX_SPRITES, 0

; IRQ-Slots: 8 Einträge für die 8 Hardware-Sprites im nächsten IRQ
IRQSlotY:   !fill 8, $FF   ; Y-Position für jeden Slot
IRQSlotIdx: !fill 8, $FF   ; Logischer Sprite-Index
NumIRQSlots: !byte 0
