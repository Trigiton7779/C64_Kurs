; ============================================================
; C64 Mastery — stufe_12_demo_entwicklung_workflow
; Abschnitt: 9.6 Integration und Timing-Feinschliff
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Sync-Tabelle finalisieren (reale Werte nach Messung)
sync_table:
        !word 50  : !byte EVENT_BEAT        ; Gemessen: Frame 50
        !word 100 : !byte EVENT_SCROLLER     ; Refrain: Frame 100
        !word 175 : !byte EVENT_PART2_INIT   ; Break: Frame 175
        !word 225 : !byte EVENT_PLASMA_MAX   ; Höhepunkt: Frame 225
        !word 380 : !byte EVENT_PART3_INIT   ; Outro: Frame 380
        !word 500 : !byte EVENT_END          ; Ende: Frame 500
        !word $FFFF                           ; Sentinel
