; ============================================================
; C64 Mastery — stufe_17_floppy_fastloader
; Abschnitt: 7.2 Krill's Loader integrieren
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; ─── Krill's Loader Integration (vereinfacht) ──────────────────
; Voraussetzung: Krill's Loader Quellcode im Projekt-Verzeichnis
; Source: https://csdb.dk/release/?id=<krill-loader-id>
;
; 1. Loader-Code einbinden
!source "krills_loader/loader.asm"

; Krill's Loader belegt typischerweise ~$0200 Bytes unter der Zieladresse
; und einige Zero-Page-Adressen. Genau im loader.asm prüfen!

; 2. Loader initialisieren (einmalig beim Programmstart)
init_loader:
    jsr LOADER_INSTALL    ; Drive-Code hochladen + Loader aktivieren
    ; Gibt zurück wenn Drive bereit ist
    ; Fehler: Carry set wenn kein Laufwerk gefunden
    bcs .no_drive
    rts
.no_drive:
    ; Fallback: KERNAL-Load verwenden
    rts

; 3. Datei laden
; Parameter: A = Dateinummer (aus Datei-Index), X/Y = Zieladresse
load_with_krill:
    ldx #<$4000           ; Zieladresse Low
    ldy #>$4000           ; Zieladresse High
    lda #1               ; Datei-Index (1-basiert, aus Disk-Directory-Reihenfolge)
    jsr LOADER_LOAD      ; Krill's Load-Routine
    ; Carry clear = OK, Carry set = Fehler
    ; X/Y enthalten Endadresse+1 nach dem Laden
    rts

; 4. Fortschritts-Callback (optional)
; Krill's Loader ruft eine Callback-Routine während des Ladens auf.
; Ideal für Lade-Bildschirm / Fortschrittsbalken.
krill_progress_cb:
    ; A = Anzahl geladener Blöcke (0 bis max)
    ; Routine muss alle Register erhalten (kein Clobber)
    pha
    jsr update_progress_bar
    pla
    rts
