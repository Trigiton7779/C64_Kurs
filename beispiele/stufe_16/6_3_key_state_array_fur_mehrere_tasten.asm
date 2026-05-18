; ============================================================
; C64 Mastery — stufe_16_tastatur_joystick
; Abschnitt: 6.3 Key-State-Array für mehrere Tasten
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Scan-Code-Konstanten für häufige Tasten
KEY_DEL    = 0
KEY_RETURN = 1
KEY_F1     = 60
KEY_F3     = 61
KEY_F5     = 62
KEY_F7     = 63
KEY_SPACE  = 60     ; Zeile 0, Spalte 4 → 0*8+4 = 4 — Werte prüfen!
KEY_LSHIFT = 48     ; Zeile 6, Spalte 0 → 6*8+0 = 48
KEY_STOP   = 7      ; Zeile 0, Spalte 7

; Prüfen ob RETURN gedrückt:
is_return_pressed:
    lda key_state + KEY_RETURN
    rts                  ; A ≠ 0 → gedrückt

; Prüfen ob SHIFT + RETURN gedrückt (gleichzeitig):
is_shift_return:
    lda key_state + KEY_RETURN
    beq .no
    lda key_state + KEY_LSHIFT
    rts                  ; A ≠ 0 → Shift+Return gedrückt
.no:
    lda #0
    rts
