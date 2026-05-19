; ============================================================
; C64 Mastery — stufe_17_floppy_fastloader
; Abschnitt: 8.2 C64-Empfänger-Code (vereinfacht)
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Mini-Fastloader: 2-Bit-Empfang von 1541
; Dieses Beispiel zeigt das Prinzip — echter Fastloader benötigt
; genaues Timing, PAL/NTSC-Kompensation und Fehlerbehandlung

; CIA2-Bit-Masken
IEC_CLK_IN  = %01000000   ; $DD00 Bit 6: CLK von Laufwerk
IEC_DAT_IN  = %10000000   ; $DD00 Bit 7: DATA von Laufwerk
IEC_CLK_OUT = %00010000   ; $DD00 Bit 4: CLK an Laufwerk
IEC_ATN     = %00001000   ; $DD00 Bit 3: ATN

; Ein Byte empfangen (stark vereinfacht)
receive_byte:
    sei                  ; IRQ sperren — Timing kritisch!

    ; Warten bis 1541 Bereit-Signal sendet (CLK + DATA = High)
.wait_ready:
    lda $DD00
    and #(IEC_CLK_IN | IEC_DAT_IN)
    cmp #(IEC_CLK_IN | IEC_DAT_IN)
    bne .wait_ready

    lda #0
    sta $03              ; Akkumulator für Byte-Aufbau

    ; 4 Mal: 2 Bits gleichzeitig lesen
    ldx #4
.receive_pair:
    ; Warten bis CLK auf Low geht (Bit liegt an)
.wait_clk_low:
    bit $DD00
    bvs .wait_clk_low   ; Bit 6 (CLK IN) = 1 → noch High

    ; DATA-Bit lesen (Bit 7)
    lda $DD00
    and #IEC_DAT_IN
    clc
    ror                  ; DATA-Bit in Carry
    ror $03              ; in Empfangsbyte schieben
    ; CLK-Bit (Bit 6) lesen und schieben
    lda $DD00
    and #IEC_CLK_IN
    clc
    ror
    ror
    ror $03

    ; Warten bis CLK wieder High (Bit-Ende)
.wait_clk_high:
    bit $DD00
    bvc .wait_clk_high   ; Bit 6 = 0 → noch Low

    dex
    bne .receive_pair

    cli
    lda $03              ; Empfangenes Byte in A
    rts

; Wichtig: Der Drive-Code (6502-Code FÜR die 1541) muss separat
; in ACME für CPU-Adressraum der 1541 assembliert und dann
; als Datenbytes im C64-Code eingebettet werden.
