; ============================================================
; C64 Mastery — stufe_02_adressierung_speicher
; Abschnitt: 2.2 Die Zero Page — Heiliger Boden der C64-Programmierung
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Zero-Page-Belegung für "Space Invaders Clone":
ptr_src      = $FB  ; 16-Bit Quell-Zeiger  ($FB/$FC)
ptr_dst      = $FD  ; 16-Bit Ziel-Zeiger   ($FD/$FE)
player_x     = $50  ; Spieler X-Position
player_y     = $51  ; Spieler Y-Position
frame_count  = $52  ; Frame-Zähler
game_state   = $53  ; Spielzustand (0=Menu, 1=Game, 2=GameOver)
bullet_x     = $54  ; Schuss-Position X
bullet_y     = $55  ; Schuss-Position Y
