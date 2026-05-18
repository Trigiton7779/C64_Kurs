; ============================================================
; C64 Mastery — stufe_17_floppy_fastloader
; Abschnitt: 9.1 Loader-Einstieg mit Fortschrittsanzeige
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; ─── loader.asm — Wird zuerst von Disk gestartet ───────────────

*= $0801                 ; BASIC-Startadresse
!byte $0B,$08,$01,$00,$9E,$32,$30,$36,$31,$00,$00,$00
                         ; BASIC-Stub: 10 SYS 2061

*= $080D
    jsr init_screen       ; Schwarzer Hintergrund, Lade-Screen aufbauen
    jsr LOADER_INSTALL    ; Krill's Loader einrichten
    bcs .fallback_kernal

    ; MAIN laden (Datei-Index 2 auf Disk)
    ldx #<$1000
    ldy #>$1000
    lda #2               ; MAIN.PRG
    jsr LOADER_LOAD
    bcs .load_error

    ; MUSIC laden
    ldx #<$E000
    ldy #>$E000
    lda #6               ; MUSIC.PRG
    jsr LOADER_LOAD
    bcs .load_error

    ; Kontrolle an MAIN übergeben
    jmp $1000

.fallback_kernal:
    ; KERNAL-Fallback wenn Krill's fehlschlägt
    jsr kernal_load_main
    jmp $1000

.load_error:
    ; Fehlermeldung anzeigen (z.B. "LOAD ERROR")
    jmp *                ; Einfrieren

; Fortschrittsbalken-Update (Krill's Callback)
update_progress_bar:
    ; A = geladene Blöcke (jeder Block = 254 Bytes)
    ; Balken in Bildschirmzeile 12: $04C0 + Offset
    pha
    cmp #38              ; Max 38 Zeichen breit
    bcs .full
    tax
    lda #$A0             ; Gefülltes Quadrat (Bildschirmcode)
.bar_loop:
    sta $04C0,x          ; Bildschirmspeicher Zeile 12
    dex
    bpl .bar_loop
.full:
    pla
    rts
