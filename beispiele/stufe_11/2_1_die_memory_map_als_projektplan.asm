; ============================================================
; C64 Mastery — stufe_11_spielentwicklung_workflow
; Abschnitt: 2.1 Die Memory-Map als Projektplan
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; ================================================================
; memory_map.asm — Zentrale Speicher-Konstantendatei
; Alle Module !source diese Datei als erstes
; ================================================================

; ── System-Bereiche (fix) ────────────────────────────────────
SCREEN_RAM      = $0400      ; 40x25 Zeichen
COLOR_RAM       = $D800      ; Farb-RAM (fix)
BASIC_START     = $0801      ; BASIC-Stub startet hier

; ── Zero Page — Spielvariablen ($30–$7F für uns) ─────────────
ZP_PLAYER_X     = $30        ; Spieler X-Position (Pixel)
ZP_PLAYER_Y     = $31        ; Spieler Y-Position (Pixel)
ZP_PLAYER_VY    = $32        ; Vertikalgeschwindigkeit (signed)
ZP_SCORE_LO     = $33        ; Score Low-Byte (BCD)
ZP_SCORE_HI     = $34        ; Score High-Byte (BCD)
ZP_FRAME_CNT    = $35        ; Frame-Zähler (0–49, für 50 Hz)
ZP_GAME_STATE   = $36        ; Aktueller Spielzustand
ZP_PTR_LO       = $FC        ; Universalzeiger Low (Standard-ZP)
ZP_PTR_HI       = $FD        ; Universalzeiger High

; ── Spielzustände ────────────────────────────────────────────
STATE_TITLE     = 0
STATE_GAME      = 1
STATE_GAMEOVER  = 2

; ── Modul-Adressen ───────────────────────────────────────────
MODULE_GAME     = $0900      ; Game-Loop
MODULE_INPUT    = $0A00      ; Input-Handler
MODULE_PLATFORM = $0B00      ; Plattform-Engine
MODULE_SID      = $1000      ; SID-Player (extern)

; ── Asset-Bereiche ────────────────────────────────────────────
CHARSET_DATA    = $2000      ; Zeichensatz (2 KB)
SPRITE_DATA     = $2800      ; Sprites (64*8 = 512 Bytes)
MUSIC_DATA      = $3000      ; SID-Musik-Daten (bis $3FFF)
