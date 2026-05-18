; ============================================================
; C64 Mastery — stufe_16_tastatur_joystick
; Abschnitt: 3.2 Vollständiger Spieler-Handler mit Diagonal und Fire-Repeat
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Joystick-Konstanten
JOY_UP    = $01
JOY_DOWN  = $02
JOY_LEFT  = $04
JOY_RIGHT = $08
JOY_FIRE  = $10

; Zero-Page
joy_curr     = $02
joy_prev     = $03
joy_edge     = $04
fire_repeat  = $05      ; Frame-Zähler für Auto-Repeat des Feuerknopfes
player_vx    = $06      ; Geschwindigkeit X (-1, 0, +1)
player_vy    = $07      ; Geschwindigkeit Y

FIRE_REPEAT_DELAY = 8   ; Frames bis Auto-Repeat beginnt
FIRE_REPEAT_RATE  = 4   ; Frames zwischen wiederholten Schüssen

joy_full_update:
    ; --- Zustand lesen + Edge Detection ---
    lda joy_curr
    sta joy_prev
    lda $DC00
    eor #$FF
    and #$1F
    sta joy_curr
    eor joy_prev
    and joy_curr
    sta joy_edge

    ; --- Bewegung: X-Achse ---
    lda #0
    sta player_vx
    lda joy_curr
    and #JOY_LEFT
    beq .check_right
    lda #$FF             ; -1 (links)
    sta player_vx
.check_right:
    lda joy_curr
    and #JOY_RIGHT
    beq .check_up
    lda #1
    sta player_vx       ; +1 (rechts) — überschreibt links bei Konflikt

    ; --- Bewegung: Y-Achse ---
.check_up:
    lda #0
    sta player_vy
    lda joy_curr
    and #JOY_UP
    beq .check_down
    lda #$FF             ; -1 (oben)
    sta player_vy
.check_down:
    lda joy_curr
    and #JOY_DOWN
    beq .fire_check
    lda #1
    sta player_vy

    ; --- Feuer mit Auto-Repeat ---
.fire_check:
    lda joy_curr
    and #JOY_FIRE
    bne .fire_held
    lda #0               ; Feuer losgelassen → Reset Counter
    sta fire_repeat
    rts

.fire_held:
    lda joy_edge         ; Gerade erst gedrückt?
    and #JOY_FIRE
    bne .fire_now        ; Ja → sofort schießen
    inc fire_repeat
    lda fire_repeat
    cmp #FIRE_REPEAT_DELAY
    bcc .no_fire_yet
    ; Auto-Repeat-Phase
    lda fire_repeat
    sec
    sbc #FIRE_REPEAT_DELAY
    and #(FIRE_REPEAT_RATE-1)  ; Modulo FIRE_REPEAT_RATE (muss Potenz von 2 sein)
    bne .no_fire_yet
.fire_now:
    jsr player_shoot
.no_fire_yet:
    rts
