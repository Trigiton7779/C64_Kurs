; ============================================================
; C64 Mastery — stufe_15_debugging_deep_dive
; Abschnitt: 5.3 Tabellen page-aligned ablegen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; PROBLEM: Sinustabelle NICHT page-aligned — bei X > n kostet LDA sin_table,X 5 statt 4 Zyklen
* = $1050         ; Tabelle bei $1050 → endet bei $114F → überschreitet $1100!
sin_table:  !byte 128,140,...  ; 256 Bytes — aber $1050+$FF = $114F → Page-Cross bei X>$AF

; LÖSUNG: Tabelle explizit page-aligned ablegen
; Methode 1: Direkte Adresse wählen
* = $1100         ; Exakt auf Seitengrenze $xx00
sin_table:  !byte 128,140,...  ; $1100+$FF = $11FF → KEIN Page-Cross!

; Methode 2: ACME-Ausdruck für automatische Ausrichtung
* = ((*+255)/256)*256  ; Auf nächste 256er-Grenze aufrunden
sin_table:  !byte 128,140,...

; Zyklen-Vergleich (innerste Schleife, 256 Iterationen):
;   Ohne Page-Align: ~128 Page-Crosses × 1 Zyklus = 128 Mehrzyklen
;   Mit Page-Align:  0 Page-Crosses = 0 Mehrzyklen
; Bei 50 Hz: 128 × 50 = 6400 verschwendete Zyklen pro Sekunde
