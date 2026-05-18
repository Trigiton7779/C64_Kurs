; ============================================================
; C64 Mastery — stufe_13_hardware_erweiterungen
; Abschnitt: 6.4 Vollständige VIC-Banking-Konfiguration
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; vic_bank_setup — Vollständige VIC-II Bank-Konfiguration
; Ziel-Layout in Bank 1 ($4000-$7FFF):
;   Screen-RAM:   $4000 (Offset 0 × $0400 = $0000 in Bank)
;   Charset:      $4800 (Offset 1 × $0800 = $0800 in Bank) [kein ROM-Overlay in Bank 1]
;   Sprite-Daten: $4FC0 (Sprite-Pointer bei $4FF8: Wert $3F = $4000 + $3F*$40 = $4FC0)
;   Bitmap:       $6000 (Offset 4 × $2000 = Bitmap-Basis $4000+$2000 = $6000, Bit0=1)

CIA2_PORT  = $DD00
VIC_CTRL1  = $D011
VIC_MEMCTL = $D018

vic_bank_setup:
    ; CIA2: VIC-Bank 1 aktivieren ($4000-$7FFF)
    ; Bank 1 = CIA2-Bits 1:0 = 10 binär
    lda CIA2_PORT
    and #%11111100       ; Bits 0+1 löschen
    ora #%00000010       ; Bank 1 = 10 binär (invertiert!)
    sta CIA2_PORT

    ; $D018: Screen bei Offset 0 ($4000), Charset bei Offset 1 ($4800)
    ; Bits 7-4 = Screen-Offset = 0 → $0000 in Bank = $4000
    ; Bits 3-1 = Charset-Offset = 1 → $0800 in Bank = $4800
    lda #%00000010       ; Screen=0 ($4000), Charset=1 ($4800)
    sta VIC_MEMCTL

    ; Sprite-Pointer im Screen-RAM ($4FF8-$4FFF) setzen
    ; Sprite 0 Daten bei $4FC0: Pointer = ($4FC0-$4000)/$40 = $3F
    ldx #7
.sptr_loop:
    lda #$3F
    sta $4FF8,x          ; Alle 8 Sprites auf $4FC0
    dex
    bpl .sptr_loop
    rts
