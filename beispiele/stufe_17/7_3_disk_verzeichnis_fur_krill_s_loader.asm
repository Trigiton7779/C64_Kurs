; ============================================================
; C64 Mastery — stufe_17_floppy_fastloader
; Abschnitt: 7.3 Disk-Verzeichnis für Krill's Loader
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Disk erstellen mit c1541 (Makefile-Beispiel):
; Reihenfolge bestimmt Krill-Datei-Index!

# Makefile-Snippet
mygame.d64: loader.prg main.prg level1.prg level2.prg gfx.prg music.prg
    c1541 -format "mygame,mg" d64 $@ \
        -write loader.prg  LOADER  \
        -write main.prg    MAIN    \
        -write level1.prg  LEVEL1  \
        -write level2.prg  LEVEL2  \
        -write gfx.prg     GFX     \
        -write music.prg   MUSIC

; Krill-Indices:
; 1 = LOADER (wird automatisch gestartet)
; 2 = MAIN   → lda #2 / jsr LOADER_LOAD
; 3 = LEVEL1 → lda #3 / jsr LOADER_LOAD
; ...
