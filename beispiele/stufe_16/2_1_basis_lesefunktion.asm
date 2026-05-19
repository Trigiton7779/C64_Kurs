; ============================================================
; C64 Mastery — stufe_16_tastatur_joystick
; Abschnitt: 2.1 Basis-Lesefunktion
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Joystick Port 2 lesen — gibt invertierten Wert zurück
; (0 = gedrückt → nach EOR: 1 = gedrückt, intuitiver)
read_joy2:
    lda $DC00           ; Port A lesen (Joystick Port 2)
    eor #$FF            ; Invertieren: 1=gedrückt, 0=losgelassen
    and #$1F            ; Nur Bits 0–4 (Up/Down/Left/Right/Fire)
    rts                 ; A enthält Joystick-Zustand

; Auswertung nach read_joy2:
;   AND #$01 → Up    (Bit 0)
;   AND #$02 → Down  (Bit 1)
;   AND #$04 → Left  (Bit 2)
;   AND #$08 → Right (Bit 3)
;   AND #$10 → Fire  (Bit 4)

; Joystick Port 1 lesen
read_joy1:
    lda $DC01           ; Port B lesen (Joystick Port 1)
    eor #$FF
    and #$1F
    rts
