; ============================================================
; C64 Mastery — stufe_17_floppy_fastloader
; Abschnitt: 4.4 D64-Datei-Layout auf dem PC
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; D64-Offset-Berechnung für Track/Sektor (auf dem PC/Host)
; track: 1–35, sector: 0–20
; Offset = (Summe aller Sektoren in Tracks 1..track-1) * 256 + sector * 256
track_offsets:
    !word 0        ; Track 1 (Zone 1: 21 Sektoren)
    !word 5376     ; Track 2
    ; ... bis Track 35
    ; Track 18 (Directory) beginnt bei Offset 107520 ($1A400)
