; ============================================================
; C64 Mastery — stufe_12_demo_entwicklung_workflow
; Abschnitt: 3.3 Fade-to-Black implementieren
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Fade-to-Black: 16 Frames, schrittweise alle Sprite-Farben auf 0
; und Hintergrundfarbe auf 0

fade_counter:   !byte 0

start_fade_out:
        lda #16              ; 16 Schritte
        sta fade_counter
        rts

update_fade:
        lda fade_counter
        beq .fade_done       ; Fertig: nichts mehr tun

        dec fade_counter

        ; Hintergrundfarbe abdunkeln (geht nur in Schritten, da C64
        ; keine RGB-Kontrolle hat — wir schalten einfach auf Schwarz)
        lda fade_counter
        cmp #8               ; Ab Mitte: auf Schwarz setzen
        bcs .bg_still_on
        lda #0               ; Schwarz
        sta $D021            ; Hintergrundfarbe
        sta $D020            ; Rahmenfarbe
.bg_still_on:
        ; Sprites deaktivieren bei 0
        lda fade_counter
        bne .fade_done
        lda #0
        sta $D015            ; Alle Sprites aus

        ; Nächsten Part initialisieren
        jsr init_next_part
.fade_done:
        rts
