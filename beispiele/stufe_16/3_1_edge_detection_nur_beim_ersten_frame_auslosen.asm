; ============================================================
; C64 Mastery — stufe_16_tastatur_joystick
; Abschnitt: 3.1 Edge Detection — nur beim ersten Frame auslösen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Zero-Page-Variablen
joy_curr = $02          ; aktueller Joystick-Zustand
joy_prev = $03          ; Zustand vom letzten Frame
joy_edge = $04          ; Bits die GERADE neu gedrückt wurden

; Joystick-Update — einmal pro Frame im IRQ oder Game-Loop aufrufen
joy_update:
    lda joy_curr        ; vorherigen Zustand sichern
    sta joy_prev
    lda $DC00
    eor #$FF
    and #$1F
    sta joy_curr        ; aktuellen Zustand speichern
    eor joy_prev        ; XOR: welche Bits haben sich geändert?
    and joy_curr        ; AND: nur Bits die jetzt gedrückt sind (= neue Drücke)
    sta joy_edge        ; Edge-Bits speichern
    rts

; Verwendung im Game-Loop:
check_fire_once:
    lda joy_edge
    and #$10            ; Fire-Button Edge?
    beq .no_fire
    jsr player_shoot    ; Nur einmalig auslösen
.no_fire:
    rts
