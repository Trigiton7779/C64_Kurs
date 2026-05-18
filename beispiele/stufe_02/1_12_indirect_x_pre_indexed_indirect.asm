; ============================================================
; C64 Mastery — stufe_02_adressierung_speicher
; Abschnitt: 1.12 (Indirect, X) — Pre-Indexed Indirect
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; (Indirect,X): Effektive Adresse = Inhalt von [($Operand + X) mod 256]
; Schritt 1: ZP-Zeiger-Adresse = ($20 + X) & $FF
; Schritt 2: Low-Byte = [$ZP-Zeiger], High-Byte = [$ZP-Zeiger + 1]
; Schritt 3: Effektive Adresse = High*256 + Low → Daten lesen/schreiben

LDA ($20,X)         ; 6 Zyklen

; Praktisches Beispiel: Dispatch-Tabelle für 4 Aktionen
; In Zero Page ab $20: 4 × 2-Byte-Zeiger auf Handler-Routinen
; $20/$21 = Zeiger auf Handler 0
; $22/$23 = Zeiger auf Handler 1
; $24/$25 = Zeiger auf Handler 2
; $26/$27 = Zeiger auf Handler 3

; Setup:
    LDA #<Handler0     ; Low-Byte von Handler0
    STA $20
    LDA #>Handler0     ; High-Byte von Handler0
    STA $21

; Aufruf mit Action-ID in X (0, 2, 4, 6 — da 2-Byte-Zeiger):
    LDX #0              ; Action 0 auswählen
    JMP ($20,X)         ; Springt zu Handler0 (liest Zeiger aus $20/$21)
    LDX #2              ; Action 1: Zeiger bei $22/$23
    JMP ($20,X)         ; Springt zu Handler1
