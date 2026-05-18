; ============================================================
; C64 Mastery — stufe_15_debugging_deep_dive
; Abschnitt: 3.2 cycle_measure Makro — CIA2-Timer-basierte Messung
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; cycle_measure_start — Startet CIA2-Timer für Zeitmessung
; cycle_measure_stop  — Stoppt Timer und gibt Ergebnis aus
; Ergebnis: monitor-Ausgabe via BRK mit Zyklenzahl in X/Y

CIA2_TA_LO  = $DD04
CIA2_TA_HI  = $DD05
CIA2_CRA    = $DD0E

cycle_measure_start:
    lda #$FF : sta CIA2_TA_LO  ; Timer auf $FFFF laden
    lda #$FF : sta CIA2_TA_HI
    lda #$01 : sta CIA2_CRA    ; Timer starten (Bit 0)
    rts

cycle_measure_stop:
    lda #0 : sta CIA2_CRA     ; Timer stoppen
    lda CIA2_TA_HI : sta measure_hi
    lda CIA2_TA_LO
    ; Zyklen = $FFFF - Timer-Wert
    eor #$FF : sta measure_lo
    lda measure_hi : eor #$FF : sta measure_hi
    ; Breakpoint: Monitor zeigt Zyklenzahl an
    brk                        ; Monitor öffnet sich; "r" zeigt A,X,Y

measure_lo: !byte 0
measure_hi: !byte 0

; Verwendung:
;   jsr cycle_measure_start
;   jsr meine_teure_routine
;   jsr cycle_measure_stop
; → Monitor öffnet sich → "m measure_lo" zeigt 16-Bit-Zyklenzahl
