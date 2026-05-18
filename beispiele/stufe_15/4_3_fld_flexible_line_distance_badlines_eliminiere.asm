; ============================================================
; C64 Mastery — stufe_15_debugging_deep_dive
; Abschnitt: 4.3 FLD — Flexible Line Distance: Badlines eliminieren
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; fld_disable — Verhindert Badlines in kritischen Rasterzeilen
; Muss im Raster-IRQ jeder betroffenen Zeile aufgerufen werden
; Prinzip: YSCROLL jede Zeile erhöhen → Bedingung nie erfüllt

VIC_CTRL1  = $D011
VIC_CTRL2  = $D016
RASTERLINE = $D012

fld_yscroll: !byte 3   ; Aktueller YSCROLL-Wert

fld_irq_handler:
    pha
    lda #$01 : sta $D019  ; IRQ quittieren

    ; YSCROLL erhöhen (modulo 8) → Badline verschiebt sich um 1
    lda fld_yscroll
    clc
    adc #1
    and #%00000111        ; Auf 0-7 begrenzen
    sta fld_yscroll

    ; In $D011 einschreiben (Bits 2-0 = YSCROLL, Bits 7-3 unverändert)
    lda VIC_CTRL1
    and #%11111000        ; YSCROLL-Bits löschen
    ora fld_yscroll
    sta VIC_CTRL1

    ; Nächste IRQ-Zeile setzen (eine Zeile tiefer)
    lda RASTERLINE
    clc
    adc #1
    sta RASTERLINE
    pla
    rti
