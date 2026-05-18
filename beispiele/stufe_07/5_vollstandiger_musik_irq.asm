; ============================================================
; C64 Mastery — stufe_07_interrupts_timing
; Abschnitt: 5. Vollständiger Musik-IRQ
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; =====================================================
; Kombination: Raster-IRQ für Grafik + Musik-Update
; Musik-Player wird im vertikalen Blankintervall aufgerufen
; =====================================================

MUSIC_LINE = 250    ; Rasterzeile im VBlank-Bereich (PAL)

SetupMusicIRQ:
        SEI
        LDA #$7F : STA $DC0D : STA $DD0D
        LDA $DC0D : LDA $DD0D

        LDA #<MusicIRQ : STA $0314
        LDA #>MusicIRQ : STA $0315

        LDA #MUSIC_LINE : STA $D012
        LDA $D011 : AND #$7F : STA $D011
        LDA #$01 : STA $D01A
        CLI
        RTS

MusicIRQ:
        LDA #$01 : STA $D019    ; Quittieren
        JSR MusicUpdate         ; Musik-Player aufrufen (aus Stufe 6)
        JMP $EA31               ; KERNAL-IRQ weiter
