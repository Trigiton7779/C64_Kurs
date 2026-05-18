; ============================================================
; C64 Mastery — stufe_13_hardware_erweiterungen
; Abschnitt: 5.3 LED-Ausgabe und Taster-Eingabe
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; userport_leds — Schreibt LED-Muster an Userport-Pins PB0-PB7
; Eingabe: A = LED-Bitmuster (Bit 0 = LED 1, Bit 7 = LED 8)
; userport_read_buttons — Liest Tasterstatus mit 3-Frame-Debounce
; Rückgabe: A = gedrückte Tasten (0=gedrückt da Pull-Up)

CIA2_PORTB  = $DD01   ; Port B Datenregister
CIA2_DDRB   = $DD03   ; Port B Direction (1=Ausgang)

userport_init_output:
    lda #$FF             ; Alle Pins als Ausgang
    sta CIA2_DDRB
    lda #$00             ; Alle LEDs aus
    sta CIA2_PORTB
    rts

userport_leds:
    sta CIA2_PORTB       ; LED-Muster direkt schreiben
    rts

userport_init_input:
    lda #$00             ; Alle Pins als Eingang
    sta CIA2_DDRB
    rts

btn_prev:   !byte $FF  ; Vorheriger Zustand
btn_count:  !byte 0   ; Debounce-Zähler (Frames)

userport_read_buttons:
    lda CIA2_PORTB       ; Port lesen (0=gedrückt wegen Pull-Up)
    cmp btn_prev
    beq .same            ; Gleich wie vorher?
    sta btn_prev         ; Neuer Zustand
    lda #0
    sta btn_count        ; Debounce-Zähler reset
    lda #$FF             ; Noch kein stabiles Ergebnis
    rts
.same:
    inc btn_count
    lda btn_count
    cmp #3               ; 3 Frames stabil = entprellt
    bcc .not_stable
    lda btn_prev         ; Stabilen Zustand zurückgeben
    rts
.not_stable:
    lda #$FF
    rts
