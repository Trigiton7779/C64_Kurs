; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 7.2 Sprite-DMA-Kosten
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Sprite-DMA Kosten pro Zeile im Sprite-Bereich:
; 1 Sprite:  2 Zyklen Diebstahl pro Zeile
; 4 Sprites: 8 Zyklen Diebstahl
; 8 Sprites: 16 Zyklen Diebstahl

; Aber: Sprite-Fetch geschieht NUR in den Zeilen wo das Sprite sichtbar ist!
; Bei Sprite-Y-Pos = 100: Fetch von Zeile 100 bis 120 (21 Zeilen)

; Optimierung: Sprites in vertikalen Clustern anordnen
; Statt 8 Sprites gleichmäßig verteilt → 8 Sprites eng beieinander
; Damit ist der DMA-Overhead auf wenige Zeilen konzentriert,
; und der Rest des Bildschirms hat volle 63 Zyklen (minus Bad Lines)
