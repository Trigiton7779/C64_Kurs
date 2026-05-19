; ============================================================
; C64 Mastery — stufe_16_tastatur_joystick
; Abschnitt: 8.3 Vollständiger Plattformer-Input
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Platform-Steuerung: Joystick Port 2
; Links/Rechts → Bewegung, Up/Fire → Sprung (Edge-Triggered)

joy2_state = $02
joy2_edge  = $03
joy2_prev  = $04
on_ground  = $05         ; 1 = Spieler steht auf Boden

player_update_input:
    ; Joystick lesen + Edge Detection
    lda joy2_state
    sta joy2_prev
    lda $DC00
    eor #$1F             ; Bits 0–4 invertieren
    and #$1F
    sta joy2_state
    eor joy2_prev
    and joy2_state
    sta joy2_edge

    ; Horizontale Bewegung (gehalten, kein Edge nötig)
    lda joy2_state
    and #$04             ; Links
    beq .chk_right
    jsr player_move_left
.chk_right:
    lda joy2_state
    and #$08             ; Rechts
    beq .chk_jump
    jsr player_move_right

    ; Sprung: nur bei Edge, nur wenn auf dem Boden
.chk_jump:
    lda on_ground
    beq .done            ; in der Luft → kein Sprung
    lda joy2_edge
    and #$11             ; Up (Bit 0) ODER Fire (Bit 4)
    beq .done
    jsr player_jump      ; Sprung einleiten
.done:
    rts
