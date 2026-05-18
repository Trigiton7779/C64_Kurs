; ============================================================
; C64 Mastery — stufe_01_6510_assembler
; Abschnitt: 5.1 Zählschleifen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; ── MUSTER 1: Aufwärtszählung, 256 Iterationen ──────────────────────
; X läuft von 0 bis 255 (INX bei 255 → 0, BNE springt nicht mehr)
        ldx #0
loop256:
        ; Ihr Code hier
        inx
        bne loop256    ; 256 Iterationen (X: 0→1→2→...→255→0)

; ── MUSTER 2: Countdown, N Iterationen ──────────────────────────────
; Effizienter als Aufwärtszählung wenn N bekannt ist
        ldx #40         ; 40 Iterationen (z.B. 40 Spalten)
countdown:
        ; Ihr Code hier
        dex             ; X--
        bne countdown   ; Springe wenn X != 0

; ── MUSTER 3: Verschachtelte Schleifen (äußere: X, innere: Y) ───────
; Beispiel: 25 Zeilen × 40 Spalten = 1000 Iterationen
        ldx #25         ; 25 Zeilen (äußere Schleife)
outer_loop:
        ldy #40         ; 40 Spalten (innere Schleife) — Y bei jeder Iteration neu setzen!
inner_loop:
        ; Code für jede Zelle (X = Zeilennr., Y = Spaltennr.)
        dey
        bne inner_loop  ; Innere Schleife
        dex
        bne outer_loop  ; Äußere Schleife

; ── MUSTER 4: Schleife mit Abbruchbedingung in der Mitte ─────────────
; Suche nach Wert $FF in einem Array ab Adresse $0300
        ldx #0
search_loop:
        lda $0300,x
        cmp #$FF        ; Sentinel-Wert?
        beq found       ; Ja → gefunden
        inx
        bne search_loop ; Weiter (maximal 256 Einträge)
; Nicht gefunden:
        lda #0
        rts
found:
        ; X enthält den Index des gefundenen Elements
        stx $60          ; Index speichern
        lda #1           ; 1 = "gefunden"
        rts
