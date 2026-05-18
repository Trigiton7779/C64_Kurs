; ============================================================
; C64 Mastery — stufe_13_hardware_erweiterungen
; Abschnitt: 4.3 Bank-Switching in ACME
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; bank_switch — EasyFlash-Bank aktivieren
; Eingabe: A = Banknummer (0-63)
; GAME/EXROM auf 16KB-Cartridge-Modus ($04)

EF_BANK  = $DE00   ; Bank-Register
EF_MODE  = $DE02   ; Mode-Register

bank_switch:
    sta EF_BANK          ; Bank 0-63 aktivieren
    lda #$04             ; GAME=1, EXROM=0 → 16KB Cartridge Mode
    sta EF_MODE          ; Modus setzen
    rts

; Beispiel: Code aus Bank 3 aufrufen
; In Bank 3 liegt Routine 'gfx_init' bei $8200
call_bank3_routine:
    lda #3
    jsr bank_switch      ; Bank 3 aktivieren
    jsr $8200            ; Routine in ROML aufrufen
    lda #0
    jsr bank_switch      ; Zurück zu Bank 0
    rts
