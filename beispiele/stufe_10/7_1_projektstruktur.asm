; ============================================================
; C64 Mastery — stufe_10_meisterschaft
; Abschnitt: 7.1 Projektstruktur
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; STARBLASTER.ACM — Haupt-Datei

!source "engine/gameloop.asm"     ; Game Loop, State Machine
!source "engine/input.asm"        ; Joystick-Handler
!source "engine/sprite_mux.asm"   ; Sprite-Multiplexer
!source "engine/collision.asm"    ; BBox Kollision
!source "engine/sid_player.asm"   ; Musik-Player
!source "game/player.asm"         ; Spieler-Logik
!source "game/enemies.asm"        ; Feind-KI
!source "game/bullets.asm"        ; Schuss-System
!source "game/starfield.asm"      ; Hintergrund
!source "game/hud.asm"            ; Anzeige
!source "data/sprites.asm"        ; Sprite-Grafiken
!source "data/music.asm"          ; SID-Musikdaten
