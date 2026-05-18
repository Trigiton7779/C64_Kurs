; ============================================================
; C64 Mastery — stufe_12_demo_entwicklung_workflow
; Abschnitt: 6.3 Bewegungsgeschwindigkeiten anpassen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Geschwindigkeits-Tabelle: PAL vs. NTSC
; Auf NTSC: Effekte 5/6 so schnell bewegen wie auf PAL
; Einfachste Methode: jeden 6. Frame auf NTSC überspringen

ntsc_skip_counter: !byte 0

should_update:
        lda is_ntsc
        beq .always_update   ; PAL: immer updaten

        ; NTSC: jeden 6. Frame überspringen
        inc ntsc_skip_counter
        lda ntsc_skip_counter
        cmp #6
        bne .always_update
        lda #0
        sta ntsc_skip_counter
        clc                  ; Carry = 0: diesen Frame überspringen
        rts
.always_update:
        sec                  ; Carry = 1: normaler Frame
        rts
