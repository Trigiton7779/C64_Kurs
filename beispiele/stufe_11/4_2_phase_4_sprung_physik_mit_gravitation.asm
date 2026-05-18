; ============================================================
; C64 Mastery — stufe_11_spielentwicklung_workflow
; Abschnitt: 4.2 Phase 4: Sprung-Physik mit Gravitation
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; ── Physik-Konstanten ────────────────────────────────────────
GRAVITY         = 1          ; Pixel/Frame² nach unten
JUMP_VELOCITY   = $F2       ; -14 als Zweierkomplement (signed)
MAX_FALL_SPEED  = 8          ; Maximale Fallgeschwindigkeit
GROUND_Y        = 220        ; Y-Pixel-Koordinate des Bodens

; ── Spieler-Physik pro Frame ─────────────────────────────────
update_physics:
        ; Gravitation anwenden (VY += GRAVITY)
        clc
        lda ZP_PLAYER_VY
        adc #GRAVITY
        sta ZP_PLAYER_VY

        ; Fallgeschwindigkeit begrenzen (signed, daher: VY 
        cmp #MAX_FALL_SPEED
        bmi .no_cap         ; Noch unter Max: ok
        lda #MAX_FALL_SPEED
        sta ZP_PLAYER_VY
.no_cap:
        ; Neue Y-Position berechnen (Y += VY)
        clc
        lda ZP_PLAYER_Y
        adc ZP_PLAYER_VY    ; signed Addition: VY kann negativ sein
        sta ZP_PLAYER_Y

        ; Boden-Kollision prüfen
        cmp #GROUND_Y
        bcc .in_air         ; Noch in der Luft
        lda #GROUND_Y
        sta ZP_PLAYER_Y     ; Auf Boden setzen
        lda #0
        sta ZP_PLAYER_VY    ; Geschwindigkeit auf 0
.in_air:
        rts

; ── Sprung auslösen (nur wenn am Boden) ─────────────────────
do_jump:
        lda ZP_PLAYER_Y
        cmp #GROUND_Y       ; Steht Spieler auf dem Boden?
        bne .no_jump        ; Nein: kein Doppelsprung
        lda #JUMP_VELOCITY   ; Negative Geschwindigkeit = nach oben
        sta ZP_PLAYER_VY
.no_jump:
        rts
