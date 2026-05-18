; ============================================================
; C64 Mastery — stufe_02_adressierung_speicher
; Abschnitt: 1.5 Zero Page — Die Nullseite als Schnellzugriffs-Ressource
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Zero Page Adressierung: Syntax und Maschinencode-Größe
LDA $42          ; 2 Bytes: [A5] [42] — Lädt Inhalt von $0042, 3 Zyklen
STA $42          ; 2 Bytes: [85] [42] — Speichert A in $0042, 3 Zyklen
INC $42          ; 2 Bytes: Erhöhe Inhalt von $0042 um 1, 5 Zyklen

; Zum Vergleich: Absolute Adressierung derselben Stelle
LDA $0042        ; 3 Bytes: [AD] [42] [00] — Lädt Inhalt von $0042, 4 Zyklen

; Praktisches Beispiel: Schleifenzähler in Zero Page
LDX #$00
MainLoop:
    INC $FB         ; ZP-Variable $FB inkrementieren (5 Zyklen)
    LDA $FB         ; Wert lesen (3 Zyklen)
    CMP #100        ; Mit 100 vergleichen
    BNE MainLoop    ; Schleife bis 100 erreicht
