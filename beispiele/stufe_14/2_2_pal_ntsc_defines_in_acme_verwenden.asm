; ============================================================
; C64 Mastery — stufe_14_modern_workflow
; Abschnitt: 2.2 PAL/NTSC-Defines in ACME verwenden
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; In ACME: PAL/NTSC-bedingte Raster-Werte
!ifdef NTSC {
    RASTER_IRQ   = 230   ; NTSC: 263 Rasterzeilen
    FRAMES_PER_S = 60
} else {
    RASTER_IRQ   = 250   ; PAL: 312 Rasterzeilen
    FRAMES_PER_S = 50
}
