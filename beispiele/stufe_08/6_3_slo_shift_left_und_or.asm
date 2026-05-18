; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 6.3 SLO — Shift Left und OR
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Bit-Manipulation: Byte shiften und in Akku mergen
; Standard:
          ASL $FB          ; 5 Zyklen
          LDA Akku_save    ; 3 Zyklen
          ORA $FB          ; 3 Zyklen
; Total: 11 Zyklen

; Mit SLO:
          SLO $FB          ; 5 Zyklen: ASL $FB + ORA $FB → Akku
; Total: 5 Zyklen → Hälfte! Useful für Pixel-Bit-Packing
