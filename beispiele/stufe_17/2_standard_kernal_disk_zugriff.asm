; ============================================================
; C64 Mastery — stufe_17_floppy_fastloader
; Abschnitt: 2. Standard KERNAL-Disk-Zugriff
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; ─── Robuste KERNAL-Laderoutine ────────────────────────────────
; Lädt eine Datei von Disk ins RAM
; Parameter: filename_ptr/$FB (Low/High), filename_len/$FD,
;            load_addr/$FE/$FF (Zieladresse — ignoriert wenn Sekundäradresse=1)
; Rückgabe: Carry clear = OK, Carry set = Fehler in A

kernal_load_file:
    ; 1. SETLFS: Logische Dateinummer, Gerätenummer, Sekundäradresse
    lda #1               ; Logische Dateinummer (1–255)
    ldx #8               ; Gerätenummer (8 = erste Floppy)
    ldy #0               ; Sekundäradresse 0 = Ladeadresse aus Datei-Header
    jsr $FFBA            ; SETLFS

    ; 2. SETNAM: Dateiname
    lda $FD              ; Dateinamen-Länge
    ldx $FB              ; Namens-Adresse Low
    ldy $FC              ; Namens-Adresse High
    jsr $FFBD            ; SETNAM

    ; 3. LOAD: Datei laden
    lda #0               ; 0=LOAD (1=VERIFY)
    ldx $FE              ; Zieladresse Low (nur wenn SA=1)
    ldy $FF              ; Zieladresse High
    jsr $FFD5            ; LOAD

    ; 4. Fehlerprüfung
    bcs .load_error      ; Carry set = KERNAL-Fehler
    jsr $FFB7            ; READST — Status-Byte lesen
    and #$BF             ; Bit 6 (EOI) ist normal, ignorieren
    beq .load_ok         ; Status 0 = alles gut

.load_error:
    sec                  ; Fehler signalisieren
    rts
.load_ok:
    clc
    rts

; Hilfsmakro: Dateiname als String-Literal übergeben
; Verwendung:
;   lda #<levelname : sta $FB
;   lda #>levelname : sta $FC
;   lda #levelname_end-levelname : sta $FD
;   jsr kernal_load_file
levelname:      !text "LEVEL1"
levelname_end:
