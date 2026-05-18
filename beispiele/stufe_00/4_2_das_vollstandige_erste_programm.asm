; ============================================================
; C64 Mastery — stufe_00_fundament
; Abschnitt: 4.2 Das vollständige erste Programm
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; ================================================================
; Erstes C64-Programm: Bildschirmfarbe und -inhalt setzen
; Assembler: ACME  |  Ziel: VICE Emulator (PAL)
; Adresse:   $0801 (BASIC-Start)
; Autor:     C64 Mastery System — Stufe 0
; ================================================================

; Ausgabedatei und Format definieren
!to "farben.prg", cbm

; Konstanten definieren (Lesbarkeit und Wartbarkeit)
VIC_BORDER  = $d020   ; VIC-II Rahmenfarbe
VIC_BG0     = $d021   ; VIC-II Hintergrundfarbe
SCREEN_RAM  = $0400   ; Standard-Bildschirm-RAM
COLOR_RAM   = $d800   ; Color-RAM (Vordergrundfarben)

; Farb-Konstanten (C64 Farbpalette)
COL_BLACK   = 0
COL_WHITE   = 1
COL_RED     = 2
COL_CYAN    = 3
COL_PURPLE  = 4
COL_GREEN   = 5
COL_BLUE    = 6
COL_YELLOW  = 7

; BASIC-Programm beginnt immer bei $0801
* = $0801

; ---- BASIC-Stub: entspricht "1 SYS 2061" ----
!byte $0b,$08   ; Nächste Zeile bei $080B
!byte $01,$00   ; Zeilennummer: 1
!byte $9e       ; Token: SYS
!byte $32,$30,$36,$31  ; ASCII: "2061"
!byte $00       ; Ende der Zeile
!byte $00,$00   ; Ende des BASIC-Programms

; ---- Maschinenprogramm bei $080D (= 2061 dezimal) ----
* = $080d

start:
    ; --- Schritt 1: Farben setzen ---
    lda #COL_BLUE       ; Farbe Blau (#6) in Akkumulator laden
    sta VIC_BG0         ; → Hintergrundfarbe Register

    lda #COL_BLACK      ; Farbe Schwarz (#0) in Akkumulator
    sta VIC_BORDER      ; → Rahmenfarbe Register

    ; --- Schritt 2: Bildschirm-RAM mit Leerzeichen füllen ---
    ; Der Bildschirm hat 40×25 = 1000 Zeichen → 4 Blöcke à 256 Bytes
    lda #$20            ; $20 = Leerzeichen im C64-Zeichensatz (PETSCII)
    ldx #0             ; X-Register als Schleifenzähler starten

fill_loop:
    sta SCREEN_RAM,x    ; Zeichen in $0400+X schreiben
    sta SCREEN_RAM+$100,x ; Zeichen in $0500+X schreiben
    sta SCREEN_RAM+$200,x ; Zeichen in $0600+X schreiben
    sta SCREEN_RAM+$300,x ; Zeichen in $0700+X schreiben (letzte 256 - 24 Bytes)
    inx                 ; X erhöhen
    bne fill_loop       ; Springe wenn X != 0 (also 256 mal)

    ; --- Schritt 3: Color-RAM mit weißer Farbe füllen ---
    lda #COL_WHITE      ; Weiß (#1) für alle Zeichen
    ldx #0

color_loop:
    sta COLOR_RAM,x     ; Farbe in $D800+X
    sta COLOR_RAM+$100,x ; Farbe in $D900+X
    sta COLOR_RAM+$200,x ; Farbe in $DA00+X
    sta COLOR_RAM+$300,x ; Farbe in $DB00+X
    inx
    bne color_loop

    ; --- Fertig: Zurück zum BASIC-Interpreter ---
    rts                 ; Return to BASIC
