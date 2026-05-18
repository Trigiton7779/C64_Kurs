; ============================================================
; C64 Mastery — stufe_02_adressierung_speicher
; Abschnitt: 1.6 Zero Page, X — Nullseiten-Indizierung mit X
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Zero Page,X: Effektive Adresse = ($Operand + X) & $FF (nur in ZP!)
LDA $20,X        ; Adresse: ($20 + X) mod 256  — immer in Zero Page
STA $20,X        ; Schreibt A an ($20 + X) mod 256

; Anwendung: 8 Spieler-Scores in Zero Page $30-$37
; X = Spieler-Nummer (0-7)
LDX #3           ; Spieler 3
LDA $30,X        ; Lädt Score[3] aus $0033
CLC
ADC #10          ; +10 Punkte
STA $30,X        ; Score[3] speichern

; WRAPAROUND DEMONSTRATION:
LDX #$F0
LDA $20,X        ; Effektive Adresse: ($20 + $F0) = $110 → $10 (ZP-Wraparound!)
