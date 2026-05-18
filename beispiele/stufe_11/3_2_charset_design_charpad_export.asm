; ============================================================
; C64 Mastery — stufe_11_spielentwicklung_workflow
; Abschnitt: 3.2 Charset-Design: CharPad → Export
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Charset in VIC-II-Bank laden (hier: $2000)
load_charset:
        lda #$36              ; Kernal aus, RAM an $D000
        sta $01               ; Charset-ROM ausblenden
        ldy #0
.loop:
        lda charset_src,y    ; Quelle (eingebettete Daten)
        sta CHARSET_DATA,y   ; Ziel: $2000
        iny
        bne .loop
        lda #$37              ; Kernal wieder einschalten
        sta $01
        rts

; Charset-Daten eingebettet
charset_src:
        !bin "assets/charset.bin"   ; 2048 Bytes

; VIC-II auf Charset-Position $2000 zeigen lassen:
; $D018: Bits 3-1 = Charset-Block → $2000 = Bank 0 + Block 4
; Wert: Screen-RAM $0400 (Bits 7-4 = 1) + Charset $2000 (Bits 3-1 = 4)
; = %00010100 = $14
        lda #$14
        sta $D018
