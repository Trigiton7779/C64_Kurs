; ============================================================
; C64 Mastery — stufe_02_adressierung_speicher
; Abschnitt: 1.8 Absolute — Vollständige 16-Bit-Adressierung
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Absolute Adressierung: 3 Bytes, 4 Zyklen
; Maschinencode: [Opcode] [Low-Byte] [High-Byte]

LDA $D020        ; Maschinencode: [AD] [20] [D0] — VIC-II Rahmenfarbe lesen
STA $D020        ; Maschinencode: [8D] [20] [D0] — Rahmenfarbe setzen
STA $0400        ; Erstes Zeichen des Screen-RAM beschreiben
LDA $FFE4        ; Aus KERNAL-ROM lesen (Adresse im ROM-Bereich)

; Symbolische Namen statt rohe Adressen (bessere Lesbarkeit):
VICBORDER = $D020
VICBGCOL  = $D021
SCREENRAM = $0400

LDA #2           ; Farbe 2 = Rot
STA VICBORDER   ; Rahmen rot
STA VICBGCOL    ; Hintergrund ebenfalls rot
