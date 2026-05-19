; ============================================================
; C64 Mastery — stufe_17_floppy_fastloader
; Abschnitt: 9.2 Level-Streaming während des Spiels
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Level laden während das Spiel läuft (zwischen Spieler-Tod und Respawn)
; Krill's Loader ist noch aktiv — erneuter LOADER_INSTALL nicht nötig!

current_level = $C0      ; 0-basierter Level-Index

load_next_level:
    ; Level-Daten-Index auf Disk: Levels starten bei Datei-Index 3
    lda current_level
    clc
    adc #3               ; Krill-Index (3=Level0, 4=Level1, ...)
    ldx #<level_data_ptr
    ldy #>level_data_ptr
    jsr LOADER_LOAD

    ; Zeige kurze "LEVEL N STARTING"-Meldung während Laden
    ; (Krill ruft progress_cb auf, kann dort auch Text-Update machen)
    rts

level_data_ptr = $5000   ; Festes RAM-Ziel für Level-Daten
