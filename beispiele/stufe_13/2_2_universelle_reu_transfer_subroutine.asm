; ============================================================
; C64 Mastery — stufe_13_hardware_erweiterungen
; Abschnitt: 2.2 Universelle REU-Transfer-Subroutine
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; reu_transfer — Universelle DMA-Subroutine
; Parameter werden über Zero-Page übergeben:
;   REU_C64_LO  ($10): C64-Basisadresse Low
;   REU_C64_HI  ($11): C64-Basisadresse High
;   REU_ADDR_LO ($12): REU-Adresse Low
;   REU_ADDR_MI ($13): REU-Adresse Middle
;   REU_ADDR_HI ($14): REU-Adresse High (Bank in Bits 0-2)
;   REU_LEN_LO  ($15): Transferlänge Low
;   REU_LEN_HI  ($16): Transferlänge High
;   REU_CMD     ($17): Befehl ($81=C64→REU, $82=REU→C64, $83=Swap)
; Verändert: A

REU_STATUS  = $DF00   ; Status-Register
REU_COMMAND = $DF01   ; Befehl (Bit 7 = sofort auslösen)
REU_C64_LO  = $10    ; ZP: C64-Adresse Low
REU_C64_HI  = $11    ; ZP: C64-Adresse High
REU_ADDR_LO = $12    ; ZP: REU-Adresse Low
REU_ADDR_MI = $13    ; ZP: REU-Adresse Mid
REU_ADDR_HI = $14    ; ZP: REU-Adresse High/Bank
REU_LEN_LO  = $15    ; ZP: Länge Low
REU_LEN_HI  = $16    ; ZP: Länge High
REU_CMD     = $17    ; ZP: Befehl

reu_transfer:
    lda REU_C64_LO
    sta $DF02            ; C64-Adresse Low
    lda REU_C64_HI
    sta $DF03            ; C64-Adresse High
    lda REU_ADDR_LO
    sta $DF04            ; REU-Adresse Low
    lda REU_ADDR_MI
    sta $DF05            ; REU-Adresse Mid
    lda REU_ADDR_HI
    sta $DF06            ; REU-Adresse High (Bank)
    lda REU_LEN_LO
    sta $DF07            ; Länge Low
    lda REU_LEN_HI
    sta $DF08            ; Länge High
    lda REU_CMD
    ora #$80             ; Bit 7 = sofort ausführen
    sta $DF01            ; Transfer starten!
.wait:
    lda $DF00            ; Status lesen
    and #$40             ; Bit 6 = End-of-Block
    beq .wait            ; Warten bis fertig
    rts
