; ============================================================
; C64 Mastery — stufe_02_adressierung_speicher
; Abschnitt: 1.7 Zero Page, Y — Nullseiten-Indizierung mit Y
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Zero Page,Y: NUR für LDX und STX verfügbar!
LDX $20,Y        ; Korrekt: Lädt X aus ZP-Adresse ($20 + Y) mod 256
STX $20,Y        ; Korrekt: Speichert X an ZP-Adresse ($20 + Y) mod 256

; Häufiger Fehler-Versuch (COMPILIERT NICHT KORREKT):
; LDA $20,Y → Dies wird als Absolute,Y $0020,Y übersetzt! Nicht ZP,Y!
