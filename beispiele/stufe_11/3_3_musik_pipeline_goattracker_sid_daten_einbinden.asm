; ============================================================
; C64 Mastery — stufe_11_spielentwicklung_workflow
; Abschnitt: 3.3 Musik-Pipeline: GoatTracker → SID-Daten einbinden
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Musik-Player in den IRQ einbinden
; Schritt 1: Beim Start initialisieren (Lied 0 starten)
init_music:
        lda #0               ; Lied-Nummer 0
        jsr SID_INIT         ; GoatTracker Init-Routine
        rts

; Schritt 2: Im Raster-IRQ jeden Frame aufrufen
irq_handler:
        lda #$01
        sta $D019            ; IRQ quittieren

        jsr SID_PLAY         ; Musik einen Frame vorspielen
        jsr game_update      ; Spiellogik

        jmp $EA81            ; Weiter mit Standard-KERNAL-IRQ

; Schritt 3: GoatTracker-Code einbinden
        * = MUSIC_DATA       ; = $3000
        !source "assets/musik.asm"  ; Definiert SID_INIT, SID_PLAY
