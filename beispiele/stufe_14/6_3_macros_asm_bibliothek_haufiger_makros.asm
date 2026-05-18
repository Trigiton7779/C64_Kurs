; ============================================================
; C64 Mastery — stufe_14_modern_workflow
; Abschnitt: 6.3 macros.asm — Bibliothek häufiger Makros
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; macros.asm — Wiederverwendbare ACME-Makros
; Einbinden: !source "src/macros.asm" (nur einmal in main.asm)

; Warten bis VBlank (Rasterzeile > 250)
!macro wait_vblank {
    bit $D011        ; Bit 7 = Rasterzeile-Bit-8
    bpl *-3          ; Warten bis im oberen Raster-Bereich
    bit $D011
    bmi *-3          ; Warten bis zurück im sichtbaren Bereich
}

; Zero-Page-Variablen sichern und wiederherstellen (für IRQ-Handler)
!macro save_zp .from, .to {
    ldx #(.to - .from)
.loop:
    lda .from,x
    sta zp_save_buf,x
    dex
    bpl .loop
}

!macro restore_zp .from, .to {
    ldx #(.to - .from)
.loop:
    lda zp_save_buf,x
    sta .from,x
    dex
    bpl .loop
}

; Sprite an (X,Y) positionieren (X: 0-319, Y: 0-255)
!macro set_sprite_pos .num, .x, .y {
    lda #(.x AND $FF)
    sta $D000 + (.num * 2)
    lda #(.y AND $FF)
    sta $D001 + (.num * 2)
    !if (.x > 255) {
        lda $D010 : ora #(1 sta $D010
    } else {
        lda $D010 : and #(255 - (1 sta $D010
    }
}
