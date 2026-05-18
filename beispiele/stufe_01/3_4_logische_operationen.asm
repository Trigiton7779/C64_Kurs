; ============================================================
; C64 Mastery — stufe_01_6510_assembler
; Abschnitt: 3.4 Logische Operationen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Bit-Manipulation — Die drei Grundmuster:

; 1. Bestimmte Bits LÖSCHEN (AND mit Maske, 0 = löschen, 1 = behalten)
        lda $D011        ; VIC-II Steuerregister lesen
        and #%01111111   ; Bit 7 löschen (RST8 — Rasterzeile-Bit 8)
        sta $D011        ; Zurückschreiben

; 2. Bestimmte Bits SETZEN (ORA mit Maske, 1 = setzen, 0 = unverändert)
        lda $D011
        ora #%00100000   ; Bit 5 setzen (Bitmap-Modus aktivieren)
        sta $D011

; 3. Bestimmte Bits UMSCHALTEN (EOR mit Maske, 1 = umschalten, 0 = unverändert)
        lda $D011
        eor #%00010000   ; Bit 4 umschalten (Multicolor-Modus toggeln)
        sta $D011

; Praktisches Beispiel: Low-Nibble aus Byte isolieren
        lda $50
        and #$0F         ; #$0F = %00001111 → High-Nibble löschen, Low-Nibble behalten
; A enthält jetzt nur noch die Bits 0–3 (Werte 0–15)
