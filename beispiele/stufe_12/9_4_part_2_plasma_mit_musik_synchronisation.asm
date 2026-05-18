; ============================================================
; C64 Mastery — stufe_12_demo_entwicklung_workflow
; Abschnitt: 9.4 Part 2: Plasma mit Musik-Synchronisation
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Plasma-Geschwindigkeit wird durch Sync-Events gesteuert
plasma_speed:   !byte 1    ; Startet langsam
plasma_decay:   !byte 0    ; Countdown für Rückkehr zur Normalgeschwindigkeit

update_part2:
        ; Plasma-Geschwindigkeit abklingen lassen
        lda plasma_decay
        beq .no_decay
        dec plasma_decay
        bne .no_decay
        lda #1               ; Zurück auf Normalgeschwindigkeit
        sta plasma_speed
.no_decay:
        ; Plasma-Phase um plasma_speed erhöhen
        lda plasma_speed
        clc
        adc plasma_phase1
        sta plasma_phase1
        ; ... Phase 2 analog ...
        jsr render_plasma
        rts

; Beat-Event im Plasma: Geschwindigkeit kurz erhöhen
do_event_plasma_max:
        lda #4               ; 4× normale Geschwindigkeit
        sta plasma_speed
        lda #30              ; 30 Frames schnell, dann abklingen
        sta plasma_decay
        rts
