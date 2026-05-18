; ============================================================
; C64 Mastery — stufe_07_interrupts_timing
; Abschnitt: 2.3 CIA2 — VIC-Bank und IEC ($DD00–$DDFF)
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; VIC-Bank wechseln (CIA2 $DD00 Bits 0-1, invertiert!)
; Bank 0 ($0000): %11 → $DD00 Bits 0-1 = %11 → AND-Maske: ORA $DD00 mit %00000011
; Bank 1 ($4000): %10 → Bits 0-1 = %10
; Bank 2 ($8000): %01 → Bits 0-1 = %01
; Bank 3 ($C000): %00 → Bits 0-1 = %00

SetVICBank1:   ; Auf Bank 1 ($4000-$7FFF) wechseln
        lda $dd00
        and #%11111100  ; Bits 0-1 löschen
        ora #%00000010  ; %10 = Bank 1
        sta $dd00
        rts
