; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 2.3 Geschwindigkeitsvergleich
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Variable in absolutem RAM: $1000
          LDA $1000     ; 4 Zyklen, 3 Bytes
          STA $1001     ; 4 Zyklen, 3 Bytes
; Summe: 8 Zyklen, 6 Bytes

; Gleiche Variable in Zero Page: $02
          LDA $02       ; 3 Zyklen, 2 Bytes
          STA $03       ; 3 Zyklen, 2 Bytes
; Summe: 6 Zyklen, 4 Bytes → 25% schneller, 33% kleiner!

; Bei 1000 Zugriffen pro Frame:
; Absolut: 8000 Zyklen
; Zero Page: 6000 Zyklen → 2000 Zyklen gespart = ~32 Rasterzeilen!
