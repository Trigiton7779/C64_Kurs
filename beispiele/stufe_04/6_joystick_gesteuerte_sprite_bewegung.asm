; ============================================================
; C64 Mastery — stufe_04_sprites_animation
; Abschnitt: 6. Joystick-gesteuerte Sprite-Bewegung
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; =====================================================
; Sprite 0 mit Joystick-Port 2 bewegen
; Zero-Page Variablen:
sprite_x    = $60   ; X-Position Low
sprite_xhi  = $61   ; X-Position Bit 8
sprite_y    = $62   ; Y-Position
SPEED       = 2     ; Pixel pro Frame
X_MIN       = 24    ; Linker Bildschirmrand
X_MAX       = 295   ; Rechter Bildschirmrand (mit X-MSB-Handling)
Y_MIN       = 50    ; Oberer Bildschirmrand
Y_MAX       = 230   ; Unterer Bildschirmrand
; =====================================================

MoveSprite:
        ; Port A auf $FF (Tastatur-Scan deaktivieren für sauberes Joystick-Lesen)
        lda #$ff
        sta $dc00
        lda $dc00       ; Joystick 2 lesen
        tax             ; Wert sichern

        ; --- OBEN (Bit 0): wenn 0 = gedrückt ---
        lsr             ; Bit 0 → Carry
        bcs @not_up
        lda sprite_y
        sec
        sbc #SPEED
        cmp #Y_MIN
        bcs @store_y
        lda #Y_MIN
@store_y:
        sta sprite_y
        jmp @check_down

@not_up:
        ; --- UNTEN (Bit 1) ---
@check_down:
        txa
        and #%00000010  ; Bit 1 isolieren
        bne @not_down
        lda sprite_y
        clc
        adc #SPEED
        cmp #Y_MAX
        bcc @store_y2
        lda #Y_MAX
@store_y2:
        sta sprite_y

@not_down:
        ; --- LINKS (Bit 2) ---
        txa
        and #%00000100
        bne @not_left
        lda sprite_x
        sec
        sbc #SPEED
        bcs @chk_min    ; Kein Unterlauf
        lda #X_MIN      ; Auf Minimum begrenzen
        ldx #0
        stx sprite_xhi
        jmp @store_x

@chk_min:
        cmp #X_MIN
        bcs @store_x
        lda #X_MIN
@store_x:
        sta sprite_x
        ; X-MSB berechnen
        lda sprite_xhi
        ; Bei einfachem Decrement: X_HI kann nur 0 werden
        lda #0
        sta sprite_xhi

@not_left:
        ; --- RECHTS (Bit 3) ---
        txa
        and #%00001000
        bne @not_right
        lda sprite_x
        clc
        adc #SPEED
        bcc @chk_max    ; Kein Überlauf
        ; Überlauf: X-MSB setzen
        inc sprite_xhi
        lda #$ff        ; Maximal X
        jmp @store_x2

@chk_max:
        ; Wenn X_HI = 0 und X < X_MAX, ok
        sta sprite_x
        jmp @apply_pos

        lda #$ff
@store_x2:
        sta sprite_x

@not_right:

@apply_pos:
        ; Register aktualisieren
        lda sprite_x
        sta $d000       ; Sprite 0 X
        lda sprite_y
        sta $d001       ; Sprite 0 Y
        ; X-MSB: Bit 0 von $D010 für Sprite 0
        lda $d010
        and #%11111110  ; Bit 0 löschen
        ora sprite_xhi  ; Bit 0 aus xhi (nur Bit 0 relevant)
        sta $d010
        rts
