; ============================================================
; C64 Mastery — stufe_13_hardware_erweiterungen
; Abschnitt: 2.4 REU-Erkennung beim Programmstart
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; detect_reu — Prüft ob REU vorhanden und ermittelt Kapazität
; Rückgabe: A = 0 (keine REU), 128 (128KB), 256 (=0 = 256KB), 2 (512KB)
; Methode: Schreibe Test-Byte in REU-RAM, lese zurück. Kein REU → Schreiben wirkungslos.

detect_reu:
    lda $DF00           ; Status lesen
    and #$10            ; Bit 4 = Size-Flag (0=512KB, 1=kleinere Modelle)
    sta reu_size_flag
    ; Test: Schreibe $55 ins REU-RAM an Adresse $00000
    lda #$55
    sta test_byte
    lda #<test_byte
    sta $DF02           ; C64-Adresse = &test_byte
    lda #>test_byte
    sta $DF03
    lda #$00 : sta $DF04  ; REU-Adresse = $000000
    lda #$00 : sta $DF05
    lda #$00 : sta $DF06
    lda #$01 : sta $DF07  ; Länge = 1
    lda #$00 : sta $DF08
    lda #$81            ; Stash (C64→REU) + sofort
    sta $DF01
    ; Ändere C64-Byte, dann Fetch zurück
    lda #$AA : sta test_byte
    lda #$82 : sta $DF01  ; Fetch (REU→C64) + sofort
    lda test_byte
    cmp #$55            ; $55 zurückgekommen? Dann REU vorhanden
    bne .no_reu
    lda #1              ; REU gefunden
    rts
.no_reu:
    lda #0
    rts
