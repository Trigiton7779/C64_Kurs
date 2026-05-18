; ============================================================
; C64 Mastery — stufe_13_hardware_erweiterungen
; Abschnitt: 3.1 Screen-Buffer im REU — Sofortige Screen-Umschaltung
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; screen_save — Sichert Screen-RAM + Color-RAM in REU
; screen_restore — Lädt Screen+Color aus REU zurück
; REU-Layout: $00000-$003E7 = Screen-RAM (1000 Bytes)
;             $003E8-$007CF = Color-RAM  (1000 Bytes)

screen_save:
    ; Screen-RAM ($0400) → REU $00000
    lda #$00 : sta $DF02  ; C64: $0400
    lda #$04 : sta $DF03
    lda #$00 : sta $DF04  ; REU: $000000
    lda #$00 : sta $DF05
    lda #$00 : sta $DF06
    lda #$E8 : sta $DF07  ; Länge = 1000 = $03E8
    lda #$03 : sta $DF08
    lda #$81 : sta $DF01  ; Stash (C64→REU)
    ; Color-RAM ($D800) → REU $003E8
    lda #$00 : sta $DF02
    lda #$D8 : sta $DF03  ; C64: $D800
    lda #$E8 : sta $DF04  ; REU: $0003E8
    lda #$03 : sta $DF05
    lda #$00 : sta $DF06
    lda #$E8 : sta $DF07
    lda #$03 : sta $DF08
    lda #$81 : sta $DF01
    rts

screen_restore:
    ; REU $00000 → Screen-RAM ($0400)
    lda #$00 : sta $DF02
    lda #$04 : sta $DF03
    lda #$00 : sta $DF04
    lda #$00 : sta $DF05
    lda #$00 : sta $DF06
    lda #$E8 : sta $DF07
    lda #$03 : sta $DF08
    lda #$82 : sta $DF01  ; Fetch (REU→C64)
    ; REU $003E8 → Color-RAM ($D800)
    lda #$00 : sta $DF02
    lda #$D8 : sta $DF03
    lda #$E8 : sta $DF04
    lda #$03 : sta $DF05
    lda #$00 : sta $DF06
    lda #$E8 : sta $DF07
    lda #$03 : sta $DF08
    lda #$82 : sta $DF01
    rts
