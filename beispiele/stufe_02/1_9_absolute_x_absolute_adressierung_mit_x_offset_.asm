; ============================================================
; C64 Mastery — stufe_02_adressierung_speicher
; Abschnitt: 1.9 Absolute, X — Absolute Adressierung mit X-Offset und Page-Crossing
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Absolute,X: Effektive Adresse = Basisadresse + X

LDA $C000,X      ; Effektive Adresse = $C000 + X
                 ; X=$00 → $C000 (4 Zyklen, keine Page-Crossing)
                 ; X=$FF → $C0FF (4 Zyklen, noch auf Seite $C0)
LDA $C0FF,X      ; X=$01 → $C100 (5 Zyklen! Seitengrenze $C0/$C1 überschritten)

; PAGE CROSSING BEISPIEL:
; Basis: $C080, X = $90 → Effektiv: $C110 → Page-Crossing! (+1 Zyklus)
; Basis: $C080, X = $7F → Effektiv: $C0FF → Kein Page-Crossing (4 Zyklen)

; Tabellen-Lookup: Sinus-Tabelle
SinusLookup:
    ; 256 Einträge, X = Winkel (0-255)
    LDA SinusTable,X  ; Sinus[X] lesen

; Optimierung: Tabelle an Seitenanfang platzieren → kein Page-Crossing möglich
; SinusTable bei $1200 → $1200 + $FF = $12FF (immer Seite $12)
        *= $1200   ; Tabelle erzwingen auf Seitenbeginn
SinusTable:
        !byte 128,131,134...  ; 256 Werte
