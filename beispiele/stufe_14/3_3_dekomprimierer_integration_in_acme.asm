; ============================================================
; C64 Mastery — stufe_14_modern_workflow
; Abschnitt: 3.3 Dekomprimierer-Integration in ACME
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; exomizer_loader — Lädt komprimiertes Daten-File und dekomprimiert
; Der Exomizer-Dekruncher (decrunch.asm) wird als Binärdatei eingebunden
; Komprimierte Daten liegen bei PACKED_ADDR, Ziel bei TARGET_ADDR

PACKED_ADDR   = $C000   ; Komprimierte Daten: temporär hier laden
TARGET_ADDR   = $2000   ; Ziel: Bitmap-RAM
DECRUNCH_ADDR = $0900   ; Dekruncher liegt hier

; Dekruncher einbinden (Binärdatei erzeugt mit: exomizer level ...)
* = DECRUNCH_ADDR
!bin "decrunch.bin"

load_and_decrunch:
    ; Komprimierte Daten per KERNAL laden
    lda #1
    ldx #8               ; Gerät 8 (Floppy)
    tay
    jsr $FFBA            ; SETLFS
    lda #filename_end-filename
    ldx #<filename
    ldy #>filename
    jsr $FFBD            ; SETNAM
    lda #0               ; Load-Flag (kein Verify)
    ldx #<PACKED_ADDR
    ldy #>PACKED_ADDR
    jsr $FFD5            ; LOAD
    bcs load_error

    ; Dekomprimieren: Quelle = PACKED_ADDR, Ziel = TARGET_ADDR
    lda #<PACKED_ADDR
    sta $FD              ; Dekruncher-ZP: Quell-Zeiger
    lda #>PACKED_ADDR
    sta $FE
    jsr DECRUNCH_ADDR    ; Dekruncher aufrufen → entpackt nach TARGET_ADDR
    rts

filename:      !pet "bitmap.exo"
filename_end:
