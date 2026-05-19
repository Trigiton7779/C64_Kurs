; ============================================================
; C64 Mastery — stufe_17_floppy_fastloader
; Abschnitt: 2.1 Datei speichern mit SAVE
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; SAVE: Speicherbereich auf Disk schreiben
; $FB/$FC = Startadresse, $AE/$AF = Endadresse+1
kernal_save_file:
    lda #1
    ldx #8
    ldy #1               ; SA=1: Zieladresse aus X/Y-Register
    jsr $FFBA            ; SETLFS
    lda #savename_end - savename
    ldx #<savename
    ldy #>savename
    jsr $FFBD            ; SETNAM

    lda #<$C000          ; Zeiger auf Startadresse (als ZP-Adresse übergeben!)
    sta $FB
    lda #>$C000
    sta $FC
    lda $FB              ; SAVE erwartet ZP-Adresse der Startadresse in A
    ldx #<$CFFF          ; Endadresse+1 Low
    ldy #>$CFFF          ; Endadresse+1 High
    jsr $FFD8            ; SAVE
    rts
savename: !text "SAVEGAME"
savename_end:
