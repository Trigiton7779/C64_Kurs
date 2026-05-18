; ============================================================
; C64 Mastery — stufe_02_adressierung_speicher
; Abschnitt: 2.4 Das Bank-Switching-System — Register $0001
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; KONFIGURATION 1: Standard nach Reset ($37)
; BASIC + KERNAL + I/O sichtbar
        lda #$37
        sta $01

; KONFIGURATION 2: Nur RAM (alle ROMs ausgeblendet)
; Maximaler freier RAM: 64 KB minus Stack, ZP, I/O-Bereich
        lda #$30
        sta $01
        ; ACHTUNG: Ab hier kein KERNAL mehr! JSR $FFD2 geht in eigenen Code!

; KONFIGURATION 3: Zeichensatz-ROM lesen ($33)
; Nützlich um den ROM-Zeichensatz in eigenes RAM zu kopieren
        lda $01
        and #%11111100     ; Bits 2-0: I/O aus, Charset-ROM ein
        ora #%00000011     ; HIRAM+LORAM setzen für BASIC+KERNAL ROM
        ; Ergebnis: %xxxxxx11 aber mit CHAREN=0 → $33
        lda #$33           ; Einfacher: direkt setzen
        sta $01
        ; Jetzt: Charset-ROM bei $D000 lesbar, I/O NICHT verfügbar!
        ; VIC-II, SID, CIA sind jetzt NICHT erreichbar bis...
        lda #$37           ; ...I/O wieder einblenden
        sta $01

; SAFE BANKING: Nur Bits 0-2 ändern, andere Bits (Datenleitungen) bewahren
SetBankingConfig:
        ; A = gewünschte Konfiguration (Bits 0-2)
        pha
        lda $01
        and #%11111000     ; Bits 0-2 löschen
        sta $fb             ; Aktuellen Wert (maskiert) speichern
        pla
        and #%00000111     ; Nur Bits 0-2 von Eingabe
        ora $fb             ; Kombinieren
        sta $01
        rts
