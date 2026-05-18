; ============================================================
; C64 Mastery — stufe_11_spielentwicklung_workflow
; Abschnitt: 3.1 Sprite-Design: SpritePad → ACME-Integration
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Sprite-Daten einbinden (z.B. 4 Sprites = 256 Bytes)
        * = SPRITE_DATA         ; = $2800
        !bin "assets/sprites.bin", 256   ; Genau 256 Bytes einlesen

; Sprite-Pointer setzen (Pointer-Seite: $07F8–$07FF)
; Sprite 0 liegt bei $2800 → Block $2800/64 = $A0 = 160
init_sprites:
        lda #160                ; Sprite-Block-Nummer
        sta $07F8              ; Sprite 0 Pointer
        sta $07F9              ; Sprite 1 Pointer
        lda #%00000011         ; Sprites 0 und 1 einschalten
        sta $D015
        rts
