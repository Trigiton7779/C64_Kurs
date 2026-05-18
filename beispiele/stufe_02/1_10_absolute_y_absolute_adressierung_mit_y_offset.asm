; ============================================================
; C64 Mastery — stufe_02_adressierung_speicher
; Abschnitt: 1.10 Absolute, Y — Absolute Adressierung mit Y-Offset
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Absolute,Y: Effektive Adresse = Basisadresse + Y
LDA $D800,Y      ; Color-RAM: Farbe an Position Y lesen
STA $D800,Y      ; Color-RAM: Farbe an Position Y schreiben

; Zeile des Screen-RAM mit Farbe füllen (Y = Spalte 0-39)
LDY #39          ; Von Spalte 39 rückwärts
LDA #7           ; Gelbe Farbe
@ColorRow:
    STA $D800,Y    ; Farbe in Color-RAM Zeile 0
    DEY
    BPL @ColorRow  ; Bis Y < 0
