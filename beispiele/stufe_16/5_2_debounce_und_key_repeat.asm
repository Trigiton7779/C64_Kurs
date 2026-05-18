; ============================================================
; C64 Mastery — stufe_16_tastatur_joystick
; Abschnitt: 5.2 Debounce und Key-Repeat
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Einfaches 2-Frame-Debounce für eine einzelne Taste
; key_raw: direkt vom Scan, key_db: entprellter Zustand
key_raw = $06
key_db  = $07

debounce_update:
    lda key_raw         ; neuer roher Wert
    and key_db_prev      ; Taste muss in BEIDEN Frames gedrückt sein
    sta key_db           ; entprellter Wert
    lda key_raw
    sta key_db_prev      ; aktuell für nächsten Frame sichern
    rts

; Key-Repeat: erst nach REPEAT_DELAY Frames, dann alle REPEAT_RATE Frames
key_repeat_cnt = $08    ; Frame-Zähler
REPEAT_DELAY = 20       ; 20 Frames ≈ 400 ms bei 50 Hz
REPEAT_RATE  = 3        ; alle 3 Frames ein Repeat ≈ 60 ms

key_repeat_tick:
    lda key_db           ; Taste gedrückt?
    beq .reset_cnt
    inc key_repeat_cnt
    lda key_repeat_cnt
    cmp #REPEAT_DELAY
    bcc .no_repeat
    lda key_repeat_cnt
    sec
    sbc #REPEAT_DELAY
    ; Modulo REPEAT_RATE (= 3 → nicht Potenz von 2, daher CMP)
    cmp #REPEAT_RATE
    bne .no_repeat
    lda #REPEAT_DELAY    ; Zähler auf Delay-Wert zurücksetzen
    sta key_repeat_cnt
    jsr handle_repeated_key
    rts
.no_repeat:
    rts
.reset_cnt:
    lda #0
    sta key_repeat_cnt
    rts
