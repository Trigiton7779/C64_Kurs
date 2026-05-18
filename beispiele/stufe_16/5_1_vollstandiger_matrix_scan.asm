; ============================================================
; C64 Mastery — stufe_16_tastatur_joystick
; Abschnitt: 5.1 Vollständiger Matrix-Scan
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; key_state: 64-Byte-Array, 1=gedrückt, 0=losgelassen
; key_prev:  vorheriger Zustand (für Edge Detection)
; Beide im RAM (nicht ZP nötig, Zugriff ist unkritisch)
key_state  = $0340       ; 64 Bytes
key_prev   = $0380       ; 64 Bytes (für Edge Detection)

; Row-Select-Tabelle: 8 Werte für $DC00
row_mask:
    !byte $FE, $FD, $FB, $F7, $EF, $DF, $BF, $7F

scan_keyboard:
    sei                  ; IRQ sperren während Scan
    ldx #0               ; Zeilen-Index
.row_loop:
    ; Vorherigen Zustand dieser Zeile sichern
    ldy #7
.save_prev:
    lda key_state,x      ; Hinweis: x+y wäre ideal, aber X ist Zeile×8
    sta key_prev,x
    inx
    dey
    bpl .save_prev
    txa
    sec
    sbc #8
    tax                  ; X zurück auf Zeilenanfang

    ; Zeile auswählen
    lda row_mask,x       ; Falsch: X ist hier Zeilen-Idx 0–7, nicht ×8
    ; Korrekte Implementierung mit separatem Zähler:
    rts                  ; (vereinfacht — siehe vollständige Version unten)

; ── Sauberere Implementierung ───────────────────────────────────
scan_keys_full:
    sei
    ldx #7              ; Zeilen-Index 7..0
.row:
    lda row_mask,x
    sta $DC00            ; Zeile auswählen
    nop                  ; kurz warten (Signal stabilisiert sich)
    lda $DC01            ; Spalten lesen
    eor #$FF             ; Invertieren: 1=gedrückt
    sta $02              ; zwischenspeichern
    ldy #7              ; Spalten-Index 7..0
.col:
    ; Scan-Code = Zeile×8 + Spalte
    txa
    asl
    asl
    asl                  ; ×8 → Offset für diese Zeile
    sty $03
    clc
    adc $03              ; + Spalte
    tay                  ; Y = Scan-Code (Index ins key_state-Array)
    lda $02
    and col_bit_mask,y   ; Spalten-Bit isolieren
    beq .not_pressed
    lda #1
    bne .store
.not_pressed:
    lda #0
.store:
    sta key_state,y
    ldy $03
    dey
    bpl .col
    dex
    bpl .row
    lda #$FF
    sta $DC00            ; Alle Zeilen wieder abwählen
    cli
    rts

col_bit_mask: !byte $01,$02,$04,$08,$10,$20,$40,$80
