; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 1. Cycle Counting — Jeder Takt zählt
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; PAL-Timing:
; 985248 Hz / 50 Frames = 19704,96 Zyklen pro Frame
; 19705 Zyklen / 312 Zeilen = 63,15 ≈ 63 Zyklen pro Zeile
; Sichtbarer Bereich: 200 Zeilen × 63 Zyklen = 12600 Zyklen
; VBlank: 112 Zeilen × 63 Zyklen = 7056 Zyklen

; NTSC-Timing:
; 1022727 Hz / 60 Frames = 17045,45 Zyklen pro Frame
; 17045 Zyklen / 263 Zeilen = 64,8 ≈ 65 Zyklen pro Zeile
