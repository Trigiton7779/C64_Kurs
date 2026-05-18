; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 1.2 Cycle Counting in der Praxis
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Naive Kopierschleife — Analyse
;                    Zyklen   Gesamt (×256)
          LDX #$00   ; 2      512
CopyLoop:
          LDA $C000,X ; 4      1024
          STA $D000,X ; 5      1280
          INX         ; 2      512
          BNE CopyLoop ; 3/2   768/512 (letzter Durchlauf: 2)
; Total (Schleife): 14 Zyklen × 256 = 3584 Zyklen für 256 Bytes
; = ca. 57 Rasterzeilen!

; Optimiert mit unrolled loop (×8) — siehe Abschnitt 3
