; ============================================================
; C64 Mastery — stufe_02_adressierung_speicher
; Abschnitt: 1.14 Relative — Bedingte Sprünge mit Reichweitenbeschränkung
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Branch-Befehle und ihre Bedingungen:
BEQ Label        ; Branch if Equal (Zero-Flag gesetzt)
BNE Label        ; Branch if Not Equal (Zero-Flag nicht gesetzt)
BCS Label        ; Branch if Carry Set
BCC Label        ; Branch if Carry Clear
BMI Label        ; Branch if Minus (Negative-Flag gesetzt)
BPL Label        ; Branch if Plus (Negative-Flag nicht gesetzt)
BVS Label        ; Branch if Overflow Set
BVC Label        ; Branch if Overflow Clear

; REICHWEITENPROBLEM: Wenn Label zu weit entfernt → Assembler-Fehler!
; Lösung: Logik umkehren + absoluter JMP

; Problematisch (wenn @weit_entfernt > 127 Bytes entfernt):
;   BEQ @weit_entfernt   ← Assembler-Fehler!

; Lösung: Branch umkehren + JMP
        bne @skip           ; NICHT gleich → überspringen
        jmp WeitEntfernt    ; Gleich → absoluter Sprung (3 Bytes, 3 Zyklen)
@skip:
        ; Hier weiterarbeiten wenn nicht gleich...

; Zyklen-Übersicht für BNE als Beispiel:
; Nicht gesprungen (Zero-Flag gesetzt):      2 Zyklen
; Gesprungen, kein Page-Crossing:            3 Zyklen
; Gesprungen, Page-Crossing (selten!):       4 Zyklen
