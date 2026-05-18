; ============================================================
; C64 Mastery — stufe_13_hardware_erweiterungen
; Abschnitt: 7.3 Universelle Erkennungsroutine für Erweiterungen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; hardware_detect — Erkennt verfügbare Erweiterungen
; Ergebnis in hw_flags:
;   Bit 0 = REU vorhanden
;   Bit 1 = EasyFlash vorhanden
;   Bit 2 = 1764/1750 (REU >= 256KB)

hw_flags: !byte 0

hardware_detect:
    lda #0 : sta hw_flags
    ; REU-Test: Schreibe Kennung in REU, lies zurück
    jsr detect_reu
    beq .check_ef
    lda hw_flags
    ora #%00000001       ; REU-Bit setzen
    sta hw_flags
    ; REU-Größe prüfen: $DF00 Bit 4 = 0 → 512KB
    lda $DF00
    and #$10
    bne .check_ef
    lda hw_flags
    ora #%00000100       ; 512KB-Bit setzen
    sta hw_flags
.check_ef:
    ; EasyFlash-Test: $DE00 schreiben und prüfen ob Freeze-Button reagiert
    lda $DE02            ; Mode-Register lesen
    cmp #$FF             ; $FF = kein EasyFlash (ungültiger Wert)
    beq .done
    lda hw_flags
    ora #%00000010       ; EasyFlash-Bit setzen
    sta hw_flags
.done:
    rts
