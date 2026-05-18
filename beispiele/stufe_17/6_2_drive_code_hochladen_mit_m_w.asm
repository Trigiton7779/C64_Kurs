; ============================================================
; C64 Mastery — stufe_17_floppy_fastloader
; Abschnitt: 6.2 Drive-Code hochladen mit M-W
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Drive-Code in die 1541 hochladen
; Der Code landet im 1541-RAM ab Adresse $0300 (freier RAM-Bereich)
; M-W Format: "M-W" + Low + High + Länge + Daten

upload_drive_code:
    ; Kommandokanal öffnen
    lda #15 : ldx #8 : ldy #15
    jsr $FFBA
    lda #0 : ldx #0 : ldy #0
    jsr $FFBD
    jsr $FFC0            ; OPEN

    lda #15
    jsr $FFC9            ; CHKOUT — Kanal 15 als Output

    ; M-W-Header senden: "M-W" + Adresse Low/High + Länge
    lda #'M' : jsr $FFD2
    lda #'-' : jsr $FFD2
    lda #'W' : jsr $FFD2
    lda #<$0300           ; 1541-Zieladresse Low
    jsr $FFD2
    lda #>$0300           ; 1541-Zieladresse High
    jsr $FFD2
    lda #drive_code_end - drive_code
    jsr $FFD2            ; Länge (max. 32 Bytes pro M-W-Kommando!)

    ; Drive-Code-Bytes senden
    ldx #0
.send_loop:
    lda drive_code,x
    jsr $FFD2            ; CHROUT
    inx
    cpx #drive_code_end - drive_code
    bcc .send_loop

    jsr $FFCC            ; CLRCHN
    lda #15 : jsr $FFC3  ; CLOSE
    rts

; M-E: Drive-Code ausführen
; "M-E" + Adresse Low/High (ohne Längenbyte!)
execute_drive_code:
    ; Gleiches Schema: SETLFS/OPEN/CHKOUT, dann senden:
    ; 'M', '-', 'E', <$0300, >$0300, CLRCHN, CLOSE
    rts

; Hinweis: M-W überträgt max. 32 Bytes pro Kommando.
; Für größere Drive-Programme: mehrere M-W mit ansteigender Zieladresse.

drive_code:
    ; Hier liegt der 1541-6502-Assembler-Code
    ; (auf dem C64 als Datenbytes abgelegt — nicht direkt ausführbar)
    !byte $EA, $EA, $60  ; Beispiel: 2× NOP + RTS
drive_code_end:
