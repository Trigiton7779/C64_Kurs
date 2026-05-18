#!/bin/bash
# C64 Mastery — stufe_11_spielentwicklung_workflow
# Abschnitt: 2.2 Modul-Aufteilung und Multi-File-Projekte mit ACME
; ================================================================
; main.asm — Einstiegspunkt des Projekts
; Kompilieraufruf: acme --cpu 6510 -f cbm -o jumpmaster.prg main.asm
; ================================================================

; Zieladresse: BASIC-Programmstart
        * = $0801

; 1. Konstanten und Speicher-Map zuerst
        !source "memory_map.asm"

; 2. BASIC-Stub (SYS 2062)
        !byte $0B,$08,$0A,$00,$9E,$32,$30,$36,$32,$00,$00,$00

; 3. Initialisierung
        * = $080E
        !source "init.asm"

; 4. Game Loop
        * = MODULE_GAME
        !source "gameloop.asm"

; 5. Einzelne Module
        * = MODULE_INPUT
        !source "input.asm"

        * = MODULE_PLATFORM
        !source "platforms.asm"

; 6. Asset-Daten (binär eingebettet)
        * = CHARSET_DATA
        !bin "assets/charset.bin"

        * = SPRITE_DATA
        !bin "assets/sprites.bin"

; 7. Musik zuletzt (kann groß sein)
        * = MUSIC_DATA
        !source "assets/musik.asm"
