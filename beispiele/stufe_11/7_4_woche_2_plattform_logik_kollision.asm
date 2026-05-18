; ============================================================
; C64 Mastery — stufe_11_spielentwicklung_workflow
; Abschnitt: 7.4 Woche 2: Plattform-Logik + Kollision
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Plattform-Datenstuktur (16 Bytes pro Plattform)
; Offset 0: X-Position (Zeichen-Koordinate, 0–35)
; Offset 1: Y-Position (Pixel, 0–255)
; Offset 2: Breite (2–6 Zeichen)
; Offset 3: Flags (Bit 0 = aktiv)

NUM_PLATFORMS   = 8
PLAT_STRIDE     = 4          ; Bytes pro Plattform-Eintrag

platforms:      ; 8 Plattformen × 4 Bytes
        !fill NUM_PLATFORMS * PLAT_STRIDE, 0

update_platforms:
        ldx #0               ; Plattform-Index
.loop:
        lda platforms+3,x   ; Flags lesen
        and #$01
        beq .next           ; Nicht aktiv: überspringen

        ; Y-Position um 1 erhöhen (nach unten)
        inc platforms+1,x

        ; Untere Grenze prüfen
        lda platforms+1,x
        cmp #220
        bcc .next           ; Noch im Bild

        ; Plattform oben neu platzieren
        lda #20              ; Neue Y-Position oben
        sta platforms+1,x
        ; Neue X-Position zufällig (Pseudo-RNG via Uhr)
        lda $DC04            ; CIA1 Timer A Low = Zufallswert
        and #$1F             ; Modulo 32 → Wert 0–31
        sta platforms,x
.next:
        txa
        clc
        adc #PLAT_STRIDE
        tax
        cpx #(NUM_PLATFORMS * PLAT_STRIDE)
        bcc .loop
        rts
