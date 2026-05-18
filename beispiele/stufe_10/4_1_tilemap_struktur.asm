; ============================================================
; C64 Mastery — stufe_10_meisterschaft
; Abschnitt: 4.1 Tilemap-Struktur
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Tilemap: 128×20 Kacheln (5120 Bytes), jede Kachel 8×8 Pixel
; Gesamt: 1024×160 Pixel Spielwelt
; Sichtbarer Bereich: 40×25 Kacheln = Screen-RAM

MAP_WIDTH  = 128   ; Kacheln horizontal
MAP_HEIGHT = 20    ; Kacheln vertikal
SCREEN_W   = 40
SCREEN_H   = 25

MapScrollX:  !byte 0     ; Pixel-Scroll X (0-7)
MapOffsetX:  !byte 0     ; Kachel-Offset X (0-88)
MapScrollY:  !byte 0     ; Pixel-Scroll Y (0-7)
MapOffsetY:  !byte 0     ; Kachel-Offset Y (0-0 für Height=25)

MapData:     !fill MAP_WIDTH * MAP_HEIGHT, 0  ; Level-Daten
