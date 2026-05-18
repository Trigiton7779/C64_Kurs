; ============================================================
; C64 Mastery — stufe_16_tastatur_joystick
; Abschnitt: 8.2 High-Score-Namenseingabe
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; High-Score-Namenseingabe: bis zu 8 Zeichen, A–Z + RETURN
; name_buf: 8-Byte-Puffer, name_len: aktuelle Länge

name_buf = $C0           ; 8 Bytes
name_len = $C8           ; aktuelle Länge 0–8
NAME_MAX = 8

hiscore_input_loop:
.poll:
    jsr $FFE4            ; GETIN (wartet nicht, Non-Blocking)
    beq .poll            ; kein Zeichen → weiter warten

    cmp #$0D             ; RETURN → fertig
    beq .done

    cmp #$14             ; DEL → letztes Zeichen entfernen
    bne .check_letter
    lda name_len
    beq .poll            ; schon leer
    dec name_len
    jsr hiscore_draw
    jmp .poll

.check_letter:
    ; Nur A–Z (PETSCII Großbuchstaben $41–$5A) akzeptieren
    cmp #$41
    bcc .poll            ; kleiner als 'A' → ignorieren
    cmp #$5B
    bcs .poll            ; größer als 'Z' → ignorieren
    ldx name_len
    cpx #NAME_MAX
    bcs .poll            ; Puffer voll
    sta name_buf,x       ; Zeichen speichern
    inc name_len
    jsr hiscore_draw
    jmp .poll

.done:
    lda name_len
    beq .poll            ; leerer Name nicht erlaubt
    rts
