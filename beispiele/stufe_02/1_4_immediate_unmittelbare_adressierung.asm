; ============================================================
; C64 Mastery — stufe_02_adressierung_speicher
; Abschnitt: 1.4 Immediate — Unmittelbare Adressierung
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Verschiedene Literal-Formate für denselben Wert (65 dezimal = $41 = %01000001):
LDA #65          ; Dezimal: Wert 65
LDA #$41         ; Hexadezimal: $41 = 65
LDA #%01000001   ; Binär: %01000001 = 65
LDA #'A'         ; ASCII-Zeichen: 'A' = 65 (Assembler-abhängig)

; DER KRITISCHE UNTERSCHIED:
LDA #$42         ; Immediate: Lädt den WERT 66 in A
LDA $42          ; Zero Page: Lädt den INHALT von Adresse $0042 in A!
LDA $0042        ; Absolute: Lädt den INHALT von Adresse $0042 in A (3 Bytes!)

; Typische Verwendung: Vergleiche und Initialisierungen
CMP #$0D         ; Vergleiche A mit Return-Zeichen (13)
LDX #$00         ; X auf 0 setzen (Zähler initialisieren)
LDA #%00110111   ; Banking-Register: Bitmuster direkt als Binär
ORA #%10000000   ; Bit 7 setzen ohne andere Bits zu verändern
AND #%01111111   ; Bit 7 löschen ohne andere Bits zu verändern
