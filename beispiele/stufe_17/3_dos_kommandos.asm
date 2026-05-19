; ============================================================
; C64 Mastery — stufe_17_floppy_fastloader
; Abschnitt: 3. DOS-Kommandos
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; DOS-Kommando senden (Kanal 15 = Kommandokanal)
; cmd_ptr/$FB/$FC = Zeiger auf Kommando-String
; cmd_len/$FD = Länge
send_dos_cmd:
    lda #15              ; Logische Dateinummer 15
    ldx #8               ; Gerätenummer
    ldy #15              ; Sekundäradresse 15 = Kommandokanal
    jsr $FFBA            ; SETLFS
    lda $FD              ; Kommandolänge
    ldx $FB
    ldy $FC
    jsr $FFBD            ; SETNAM (Kommando ist der "Dateiname")
    jsr $FFC0            ; OPEN (sendet Kommando)
    lda #15
    jsr $FFC3            ; CLOSE
    rts

; Datei löschen: "S0:DATEINAME"
dos_delete:
    !text "S0:LEVEL1"
dos_delete_end:

; Datei umbenennen: "R0:NEUNAME=ALTNAME"
dos_rename:
    !text "R0:LEVEL2=LEVEL1"
dos_rename_end:

; Disk formatieren (mit ID): "N0:DISKNAME,ID"  — VORSICHT!
dos_format:
    !text "N0:MY DISK,MD"
dos_format_end:

; Fehlerkanal lesen — nach kritischen Operationen immer prüfen
read_error_channel:
    lda #15
    ldx #8
    ldy #15
    jsr $FFBA
    jsr $FFBD            ; SETNAM mit Länge 0 (kein Name)
    jsr $FFC0            ; OPEN — liest Fehlerkanal
    lda #15
    jsr $FFC6            ; CHKIN — Input auf Kanal 15 umlenken
    ; Jetzt per CHRIN ($FFCF) Fehlerstring lesen bis CR
    ldx #0
.read_loop:
    jsr $FFCF            ; CHRIN — ein Byte lesen
    cmp #$0D             ; CR = Ende des Fehlerstrings
    beq .done
    sta error_buf,x
    inx
    bne .read_loop
.done:
    lda #0
    sta error_buf,x      ; String null-terminieren
    jsr $FFCC            ; CLRCHN
    lda #15
    jsr $FFC3            ; CLOSE
    rts
error_buf: !fill 40, 0
