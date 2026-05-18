; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 7.1 Bad Lines — Die teuersten Zeilen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Auf Bad Lines stiehlt der VIC-II 40 zusätzliche Zyklen!
; Normale Zeile:   63 Zyklen für CPU verfügbar
; Bad Line:        63 - 40 = 23 Zyklen für CPU verfügbar

; YSCROLL-Trick: Bad Lines verschieben
; Normalerweise: YSCROLL=3 → Bad Lines auf Zeilen 3,11,19,27,35...

; IRQ-Handler auf einer Bad Line ist deutlich eingeschränkt!
; Lösung: IRQ auf Nicht-Bad-Lines legen

; Prüfen ob aktuelle Zeile eine Bad Line ist:
          LDA $D011        ; YSCROLL
          AND #$07         ; Bits 0-2
          STA TmpA
          LDA $D012        ; Aktuelle Rasterzeile
          AND #$07
          CMP TmpA
          BEQ IsBadLine    ; Gleich → Bad Line!
