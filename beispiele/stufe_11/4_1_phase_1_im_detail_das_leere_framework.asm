; ============================================================
; C64 Mastery — stufe_11_spielentwicklung_workflow
; Abschnitt: 4.1 Phase 1 im Detail: Das leere Framework
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; ================================================================
; init.asm — System-Initialisierung
; ================================================================

start:
        ; CPU-Interrupts deaktivieren während Setup
        sei

        ; VIC-II: Hintergrundfarbe, Rahmenfarbe
        lda #0               ; Schwarz
        sta $D020            ; Rahmen
        sta $D021            ; Hintergrund

        ; Raster-IRQ einrichten
        lda #sta $0314            ; IRQ-Vektor Low
        lda #>irq_handler
        sta $0315            ; IRQ-Vektor High
        lda #252             ; Rasterzeile für IRQ
        sta $D012
        lda $D011
        and #$7F             ; Bit 8 von $D012 = 0
        sta $D011
        lda #$01             ; Raster-IRQ aktivieren
        sta $D01A

        ; Startzustand setzen
        lda #STATE_TITLE
        sta ZP_GAME_STATE

        ; Musik initialisieren
        jsr init_music

        ; IRQ wieder erlauben
        cli

main_loop:
        ; Game-Loop wartet auf IRQ-Flag
        lda ZP_FRAME_CNT     ; Wurde ein neuer Frame gezeichnet?
        beq main_loop        ; Nein: warten
        lda #0
        sta ZP_FRAME_CNT     ; Frame-Flag zurücksetzen
        jsr game_dispatch    ; State Machine aufrufen
        jmp main_loop

irq_handler:
        lda #$01
        sta $D019            ; IRQ quittieren
        jsr SID_PLAY
        lda #1
        sta ZP_FRAME_CNT     ; Neuen Frame signalisieren
        jmp $EA81            ; KERNAL-IRQ-Ende
