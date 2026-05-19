; ============================================================
; C64 Mastery — stufe_16_tastatur_joystick
; Abschnitt: 8.1 Menü-Navigation
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Menü-Steuerung: Cursor Up/Down + RETURN
; Verwendet GETIN für einfache, robuste Implementierung

menu_cursor  = $C0       ; aktuelle Menüposition (0-basiert)
MENU_ITEMS   = 4         ; Anzahl Menüeinträge

menu_handle_input:
    jsr $FFE4            ; GETIN
    beq .done

    cmp #$11             ; Cursor Down (PETSCII $11)
    bne .check_up
    inc menu_cursor
    lda menu_cursor
    cmp #MENU_ITEMS
    bcc .draw
    lda #0               ; Wrap-around
    sta menu_cursor
    bne .draw

.check_up:
    cmp #$91             ; Cursor Up (PETSCII $91)
    bne .check_fire
    lda menu_cursor
    beq .wrap_up
    dec menu_cursor
    bne .draw
.wrap_up:
    lda #(MENU_ITEMS-1)
    sta menu_cursor
    bne .draw

.check_fire:
    cmp #$0D             ; RETURN (PETSCII $0D)
    bne .check_joy_fire
    jsr menu_select_item ; Auswahl bestätigen
    rts

.check_joy_fire:
    lda $DC00
    and #$10             ; Joy2 Fire (Bit 4, active low)
    bne .done            ; Bit gesetzt = nicht gedrückt
    jsr menu_select_item
    rts
.draw:
    jsr menu_draw_cursor
.done:
    rts
