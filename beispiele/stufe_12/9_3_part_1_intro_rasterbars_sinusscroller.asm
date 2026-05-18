; ============================================================
; C64 Mastery — stufe_12_demo_entwicklung_workflow
; Abschnitt: 9.3 Part 1: Intro — Rasterbars + Sinusscroller
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Part 1: Sinus-Scroller mit Rasterbars
; Scroll-Register $D016 Bits 0-2 für horizontales Soft-Scroll

scroll_x:       !byte 7    ; Aktuelle Scroll-Position
text_offset:    !byte 0    ; Offset in scroll_text
rasterbar_color: !byte 6   ; Aktuell Blau

update_part1:
        ; Scroll-Register dekrementieren
        dec scroll_x
        bpl .no_shift        ; Noch positiv: nur Pixel-Scroll

        ; Auf 7 zurücksetzen und Zeichenreihe verschieben
        lda #7
        sta scroll_x
        jsr shift_screen_left ; Alle 40 Zeichen in Zeile 24 um 1 links
        jsr append_next_char  ; Nächstes Zeichen des scroll_text rechts einfügen
.no_shift:
        ; Scroll-Register setzen
        lda scroll_x
        and #$07
        ora #$C8             ; Bits 7-4: Standard + 38 Spalten (schmaler Rand)
        sta $D016
        rts

scroll_text:
        !pet "     bitwave by yourgroup ... music: yourtune ... greetings to the world     "
        !byte 0             ; Terminierung

; Beat-Event-Handler: Rasterbar-Farbe kurz auf Grün (Blitz-Effekt)
do_beat:
        lda #5              ; Grün
        sta rasterbar_color
        lda #8              ; 8 Frames Grün bleiben
        sta beat_decay
        rts
