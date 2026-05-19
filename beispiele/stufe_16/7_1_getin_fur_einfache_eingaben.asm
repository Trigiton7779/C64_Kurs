; ============================================================
; C64 Mastery — stufe_16_tastatur_joystick
; Abschnitt: 7.1 GETIN für einfache Eingaben
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Non-blocking Tastenabfrage mit GETIN
poll_key:
    jsr $FFE4            ; GETIN
    tax                  ; Taste in X sichern
    beq .no_key          ; A=0 → kein Zeichen
    ; A enthält PETSCII-Code der Taste
    cmp #$51             ; 'Q' in PETSCII
    beq .quit
    cmp #$11             ; Cursor Down
    beq .cursor_down
.no_key:
    rts
