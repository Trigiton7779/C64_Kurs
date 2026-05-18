; ============================================================
; C64 Mastery — stufe_03_bildschirm_zeichen
; Abschnitt: 6.3 Multicolor-Zeichendefinition
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Multicolor-Zeichendefinition: jede Zeile = 4 Pixel-Paare
; %11 = Color-RAM-Farbe, %10 = $D023, %01 = $D022, %00 = $D021

; Beispiel: Kleiner Pilz (Mario-Style)
MushroomMC:
        !byte %00111100   ; ..##..  (00 = BG, 11 = Color-RAM)
        !byte %11111111   ; ########
        !byte %11001100   ; ##..##..
        !byte %11111111   ; ########
        !byte %00111100   ; ..####..
        !byte %00001100   ; ....##..
        !byte %00111100   ; ..####..
        !byte %00000000   ; ........
