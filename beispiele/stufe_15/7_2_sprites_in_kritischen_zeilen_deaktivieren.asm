; ============================================================
; C64 Mastery — stufe_15_debugging_deep_dive
; Abschnitt: 7.2 Sprites in kritischen Zeilen deaktivieren
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; irq_sprite_aware — Raster-IRQ der Sprites temporär deaktiviert
; wenn zu viele Zyklen in einer kritischen Zeile gebraucht werden
; Nützlich für Raster-Effekte die präzises Timing benötigen

sprites_enabled: !byte $FF  ; Gespeicherter Sprite-Enable-Wert

irq_sprites_off:
    lda $D015              ; Aktuellen Sprite-Enable-Wert sichern
    sta sprites_enabled
    lda #0 : sta $D015      ; Alle Sprites aus
    rts

irq_sprites_on:
    lda sprites_enabled
    sta $D015              ; Sprites wiederherstellen
    rts

; Verwendung im Raster-IRQ für zeitkritischen Effekt:
;   jsr irq_sprites_off    ; Sprites aus → 63 volle Zyklen
;   ... zeitkritischer Rastereffekt-Code ...
;   jsr irq_sprites_on     ; Sprites wieder an
