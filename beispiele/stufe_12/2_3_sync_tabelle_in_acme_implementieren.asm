; ============================================================
; C64 Mastery — stufe_12_demo_entwicklung_workflow
; Abschnitt: 2.3 Sync-Tabelle in ACME implementieren
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; ── Timing-Tabelle: Events als Frame-Nummer + Event-Code ─────
; Format: !word Frame, !byte Event-Code
; Abschluss: !word $FFFF (Sentinel)

EVENT_NONE       = 0
EVENT_BEAT       = 1     ; Kurzer Farb-Impuls
EVENT_PART2_INIT = 2     ; Zu Part 2 wechseln
EVENT_PART3_INIT = 3     ; Zu Part 3 wechseln
EVENT_FLASH      = 4     ; Bildschirm-Flash
EVENT_PLASMA_MAX = 5     ; Plasma-Geschwindigkeit Maximum
EVENT_SCROLLER   = 6     ; Scroller ein/aus
EVENT_END        = $FF   ; Demo endet

sync_table:
        !word 25  : !byte EVENT_BEAT
        !word 50  : !byte EVENT_SCROLLER
        !word 75  : !byte EVENT_BEAT
        !word 100 : !byte EVENT_FLASH
        !word 150 : !byte EVENT_PART2_INIT
        !word 200 : !byte EVENT_PLASMA_MAX
        !word 350 : !byte EVENT_PART3_INIT
        !word 500 : !byte EVENT_END
        !word $FFFF           ; Sentinel: Ende der Tabelle

; ── Event-System im IRQ ───────────────────────────────────────
sync_index:     !byte 0    ; Zeiger in sync_table (Byte-Index)
frame_counter:  !word 0    ; Globaler Frame-Zähler (16-Bit)

check_sync_events:
        ; Frame-Zähler erhöhen
        inc frame_counter
        bne .no_hi
        inc frame_counter+1
.no_hi:
        ; Aktuellen Tabelleneintrag lesen
        ldx sync_index
        lda sync_table,x      ; Low-Byte Frame-Nummer
        cmp frame_counter
        bne .no_event
        lda sync_table+1,x    ; High-Byte Frame-Nummer
        cmp frame_counter+1
        bne .no_event

        ; Event ausführen
        lda sync_table+2,x    ; Event-Code lesen
        jsr dispatch_event

        ; Zum nächsten Tabelleneintrag (3 Bytes pro Eintrag)
        clc
        txa
        adc #3
        sta sync_index
.no_event:
        rts

dispatch_event:
        ; Verzweigung anhand des Event-Codes
        cmp #EVENT_BEAT      : beq do_beat
        cmp #EVENT_FLASH     : beq do_flash
        cmp #EVENT_PART2_INIT: beq init_part2
        cmp #EVENT_PART3_INIT: beq init_part3
        cmp #EVENT_END       : beq demo_end
        rts
