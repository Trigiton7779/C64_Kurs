; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 2.2 Zero-Page-Layout-Beispiel
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Zero-Page-Layout für ein Spiel
*= $0002

; --- Allgemeine Pointer (4 × 2 Bytes = 8 Bytes) ---
SrcPtr:   !byte 0, 0   ; Quell-Pointer (Lo/Hi)
DstPtr:   !byte 0, 0   ; Ziel-Pointer
TmpPtr:   !byte 0, 0   ; Temporärer Pointer
MapPtr:   !byte 0, 0   ; Map-Pointer

; --- Spielzustand ---
PlayerX:  !byte 0     ; Spieler X-Position
PlayerY:  !byte 0     ; Spieler Y-Position
Score:    !byte 0, 0 ; 16-Bit Punktestand
Lives:    !byte 3     ; Leben
GameState:!byte 0     ; 0=Titel 1=Spiel 2=GameOver

; --- Zähler und Flags ---
FrameCount: !byte 0   ; Frame-Zähler
Flags:      !byte 0   ; Bit-Flags
TmpA:       !byte 0   ; Scratch A
TmpX:       !byte 0   ; Scratch X
TmpY:       !byte 0   ; Scratch Y

; --- Sprite-Daten ---
SprX:       !fill 8, 0 ; X-Pos für 8 Sprites
SprY:       !fill 8, 0 ; Y-Pos für 8 Sprites
SprFrame:   !fill 8, 0 ; Animations-Frame

; Verwendung: STA SrcPtr    ; Schreibt in ZP → 4 Zyklen
;             LDA (SrcPtr),Y; Indirekter ZP-Zugriff → 5+1 Zyklen
