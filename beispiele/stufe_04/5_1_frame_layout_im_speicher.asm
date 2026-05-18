; ============================================================
; C64 Mastery — stufe_04_sprites_animation
; Abschnitt: 5.1 Frame-Layout im Speicher
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; 4-Frame-Animation bei $0C00:
; Frame 0: $0C00–$0C3F (Pointer $30)
; Frame 1: $0C40–$0C7F (Pointer $31)
; Frame 2: $0C80–$0CBF (Pointer $32)
; Frame 3: $0CC0–$0CFF (Pointer $33)

; Animations-Steuerung
anim_frame   = $60   ; Aktueller Frame (0–3)
anim_timer   = $61   ; Countdown (Verzögerung zwischen Frames)
ANIM_SPEED   = 6     ; Frames warten (6 × 50Hz ≈ 120ms pro Frame)
FRAME_BASE   = $30   ; Basis-Pointer ($0C00 / 64 = $30)
NUM_FRAMES   = 4

UpdateAnimation:
        dec anim_timer
        bne @skip

        lda #ANIM_SPEED
        sta anim_timer

        ; Nächsten Frame
        inc anim_frame
        lda anim_frame
        cmp #NUM_FRAMES
        bne @set_ptr
        lda #0
        sta anim_frame

@set_ptr:
        ; Pointer = FRAME_BASE + aktueller Frame
        clc
        adc #FRAME_BASE
        sta $07f8       ; Sprite 0 Pointer aktualisieren

@skip:  rts
