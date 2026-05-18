; ============================================================
; C64 Mastery — stufe_13_hardware_erweiterungen
; Abschnitt: 8.2 Hauptschleife mit DMA-Screen-Wechsel
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; slideshow_loop — Hauptschleife der REU-Slideshow
; Wechselt alle 150 Frames (3 Sek. PAL) zum nächsten Screen

frame_count:    !byte 0
current_screen: !byte 0

; REU-Basisadressen pro Screen (High-Byte und Mid-Byte)
reu_screen_hi: !byte $00,$04,$08,$0C  ; Bitmap High-Bytes
reu_color_hi:  !byte $01,$05,$09,$0D  ; Color-RAM High-Bytes (Offset $1F40)

slideshow_loop:
.wait_vbl:
    lda $D011
    bpl .wait_vbl        ; Warten bis Bit 7 = Rasterzeile > 255

    inc frame_count
    lda frame_count
    cmp #150
    bcc .no_switch

    ; Screen wechseln
    lda #0 : sta frame_count
    inc current_screen
    lda current_screen
    cmp #4
    bcc .do_fetch
    lda #0 : sta current_screen

.do_fetch:
    ldy current_screen

    ; Bitmap: REU → $2000 (Hires-Bitmap-Adresse in Bank 0)
    lda #$00 : sta $DF02  ; C64: $2000
    lda #$20 : sta $DF03
    lda #$00 : sta $DF04
    lda reu_screen_hi,y
    sta $DF05            ; REU-Adresse Mid
    lda #$00 : sta $DF06
    lda #$40 : sta $DF07  ; Länge $1F40 = 8000 Bytes
    lda #$1F : sta $DF08
    lda #$82 : sta $DF01  ; Fetch (REU→C64)

    ; Color-RAM: REU → $D800
    lda #$00 : sta $DF02
    lda #$D8 : sta $DF03
    lda #$40 : sta $DF04  ; Offset $1F40 innerhalb des Blocks
    lda reu_color_hi,y
    sta $DF05
    lda #$00 : sta $DF06
    lda #$E8 : sta $DF07  ; Länge $03E8 = 1000 Bytes
    lda #$03 : sta $DF08
    lda #$82 : sta $DF01

.no_switch:
    jmp slideshow_loop
