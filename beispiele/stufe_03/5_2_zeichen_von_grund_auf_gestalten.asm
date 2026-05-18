; ============================================================
; C64 Mastery — stufe_03_bildschirm_zeichen
; Abschnitt: 5.2 Zeichen von Grund auf gestalten
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Beispiel: Raumschiff-Zeichen (Draufsicht, 8×8)
; Visualisierung:
;  Zeile 0:  ........ = 00000000 = $00
;  Zeile 1:  ...##... = 00011000 = $18
;  Zeile 2:  .######. = 01111110 = $7E
;  Zeile 3:  ###..### = 11000011 = $C3 -- Fehler, besser:
;  Zeile 3:  ###.#### = 11101111 = $EF -- Triebwerke
;  Zeile 4:  #.####.# = 10111101 = $BD
;  Zeile 5:  .######. = 01111110 = $7E
;  Zeile 6:  ..#..#.. = 00100100 = $24
;  Zeile 7:  ........ = 00000000 = $00

ShipChar:
        !byte $00,$18,$7e,$ef,$bd,$7e,$24,$00
