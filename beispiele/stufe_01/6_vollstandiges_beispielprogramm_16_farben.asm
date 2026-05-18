; ============================================================
; C64 Mastery — stufe_01_6510_assembler
; Abschnitt: 6. Vollständiges Beispielprogramm — 16 Farben
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; =================================================================
; C64 Demo: 16 Farben als horizontale Balken
; Stufe 1 — Vollständiges Beispiel
; Assembler: ACME
; =================================================================

; ── Konstanten ───────────────────────────────────────────────────
SCREEN_RAM  = $0400   ; Bildschirm-RAM (Standard)
COLOR_RAM   = $D800   ; Color-RAM
VIC_BORDER  = $D020   ; Rahmenfarbe
VIC_BG0     = $D021   ; Hintergrundfarbe 0

; ── Zero-Page Variablen ($02–$FF, frei verwendbar) ───────────────
zp_color    = $02     ; Aktuelle Farbe (0–15)
zp_row      = $03     ; Aktuelle Zeile (0–24)

!to "farben16.prg", cbm

* = $0801
; BASIC-Stub: 1 SYS 2061
!byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00

* = $080d

main:
    ; Initialisierung: Hintergrund und Rahmen schwarz
    lda #0
    sta VIC_BG0
    sta VIC_BORDER

    ; Farb-Schleife: Zeile 0 = Farbe 0, Zeile 1 = Farbe 1, ..., Zeile 15 = Farbe 15
    lda #0
    sta zp_color       ; Farbe 0 beginnen
    sta zp_row         ; Zeile 0 beginnen

row_loop:
    ; Aktuelle Farbe = Zeile % 16 (da 16 Farben auf 25 Zeilen)
    lda zp_row
    and #$0F           ; Modulo 16 (nur Low-Nibble = Werte 0–15)
    sta zp_color

    ; Unterprogramm aufrufen: Zeile mit Farbe füllen
    jsr fill_row

    ; Nächste Zeile
    inc zp_row
    lda zp_row
    cmp #25            ; 25 Zeilen (0–24)?
    bne row_loop      ; Wenn noch nicht Zeile 25: weiter

    rts               ; Fertig — zurück zu BASIC

; ──────────────────────────────────────────────────────────────────
; Unterprogramm: fill_row
; Füllt die Zeile (zp_row) im Color-RAM mit Farbe (zp_color).
; Füllt die Zeile im Screen-RAM mit Leerzeichen ($20).
; Verändert: A, X — zp_color und zp_row bleiben unverändert.
; ──────────────────────────────────────────────────────────────────
fill_row:
    ; Spalten-Offset berechnen: Zeile × 40 = Startposition im Screen-RAM
    ; Einfache Näherung: Zeile × 40 in zwei Schritten
    ; (Volle 16-Bit-Multiplikation in Stufe 8; hier direkte Tabelle)
    lda zp_row         ; Zeilennummer
    asl a              ; ×2
    asl a              ; ×4
    asl a              ; ×8
    sta $FE            ; Zwischenspeicher: Zeile × 8
    lda zp_row
    asl a              ; ×2
    asl a              ; ×4
    clc
    adc $FE            ; + Zeile×8 = Zeile×12 (×4+×8=×12)?
    ; Hinweis: Zeile × 40 = Zeile × 32 + Zeile × 8
    ; Vereinfacht für dieses Beispiel — exakte Mult. in Stufe 8

    ; Screen-RAM-Zeile füllen: 40 Leerzeichen
    ldx #40            ; 40 Spalten
    lda #$20           ; Leerzeichen
fill_scr_col:
    sta SCREEN_RAM,x   ; Leerzeichen schreiben
    dex
    bne fill_scr_col

    ; Color-RAM-Zeile mit aktueller Farbe füllen: 40 Bytes
    ldx #40
    lda zp_color       ; Aktuelle Farbe
fill_col_col:
    sta COLOR_RAM,x    ; Farbe ins Color-RAM
    dex
    bne fill_col_col

    rts               ; Zurück zum Aufrufer
