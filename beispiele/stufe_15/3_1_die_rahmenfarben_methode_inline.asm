; ============================================================
; C64 Mastery — stufe_15_debugging_deep_dive
; Abschnitt: 3.1 Die Rahmenfarben-Methode (inline)
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Rahmenfarben-Profiling: Routine messen
lda #2 : sta $D020  ; Rahmen ROT — Routine beginnt

; ... die zu messende Routine ...
jsr meine_routine

lda #0 : sta $D020  ; Rahmen SCHWARZ — Routine ende

; Breite des roten Streifens im Rasterbalken = Zyklen/63 Rasterzeilen
