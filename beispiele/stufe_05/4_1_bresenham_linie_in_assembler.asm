; ============================================================
; C64 Mastery — stufe_05_bitmap_grafik
; Abschnitt: 4.1 Bresenham-Linie in Assembler
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Bresenham-Linie zeichnen
; Eingabe: $60/$61 = x0/y0, $62/$63 = x1/y1
; Setzt Pixel in Hires-Bitmap bei $2000

DrawLine:
        ; Differenzen berechnen
        lda $62 : sec : sbc $60 : sta dx  ; dx = x1 - x0 (vorzeichenbehaftet)
        lda $63 : sec : sbc $61 : sta dy  ; dy = y1 - y0

        ; Steigung bestimmen und Hauptachse wählen
        ; (vereinfachte Version für positive dx, dy)

        lda dx : sta step_count  ; Schrittzahl = max(dx, dy)
        lda dy : cmp dx
        bcc @dx_major
        sta step_count

@dx_major:
        ; Schritt-Schleife (für horizontale Hauptachse)
        lda #0 : sta err
        lda $60 : sta cx    ; cx = x0
        lda $61 : sta cy    ; cy = y0
        ldy step_count

@loop:
        ; Pixel an (cx, cy) setzen
        lda cx : sta $60
        lda cy : sta $62
        lda #1 : sta $64
        jsr SetPixel

        ; Fehlerterm aktualisieren
        ; (vollständige Implementierung benötigt vorzeichenbehaftete Arithmetik)
        inc cx
        lda err
        clc
        adc dy
        sta err
        cmp dx
        bcc @no_step_y
        inc cy
        lda err : sec : sbc dx : sta err

@no_step_y:
        dey
        bne @loop
        rts

dx: !byte 0
dy: !byte 0
cx: !byte 0
cy: !byte 0
err: !byte 0
step_count: !byte 0
