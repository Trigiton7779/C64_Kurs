; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 7.3 Refresh-Zyklen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Der VIC-II benötigt 5 DRAM-Refresh-Zyklen pro Zeile
; Diese 5 Zyklen sind immer weg, auch ohne Sprites oder Bad Lines
; Tatsächlich verfügbare Zyklen pro normaler Zeile:
; 63 - 5 (Refresh) = 58 Zyklen maximal
; Minus Bad Line: 58 - 40 = 18 Zyklen!
; Minus 8 Sprites: 58 - 16 = 42 Zyklen (normale Zeile, kein Bad Line)

; Rasterzeilen-Budget-Rechner:
; Verfügbare Zyklen = 63 - 5 (Refresh)
                         - (IsBadLine ? 40 : 0)
                         - (NumActiveSprites * 2)
