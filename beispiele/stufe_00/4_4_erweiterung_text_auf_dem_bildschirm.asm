; ============================================================
; C64 Mastery — stufe_00_fundament
; Abschnitt: 4.4 Erweiterung: Text auf dem Bildschirm
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Fortsetzung nach color_loop (vor dem rts):

; "HALLO" auf dem Bildschirm ausgeben — Zeile 0, ab Spalte 0
; Bildschirm-RAM: $0400 = Position (Zeile 0, Spalte 0)
; PETSCII: H=8, A=1, L=12, L=12, O=15 (Großbuchstaben: Wert = Buchstabe-'A'+1)

    lda #8              ; 'H' im PETSCII
    sta $0400           ; Position (0,0)

    lda #1              ; 'A' im PETSCII
    sta $0401           ; Position (0,1)

    lda #12             ; 'L' im PETSCII
    sta $0402           ; Position (0,2)
    sta $0403           ; Position (0,3) — zweites L

    lda #15             ; 'O' im PETSCII
    sta $0404           ; Position (0,4)

    rts
