; ============================================================
; C64 Mastery — stufe_11_spielentwicklung_workflow
; Abschnitt: 5.2 Cycle-Budget überwachen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Cycle-Budget-Messung — Debugging-Tool
; IRQ 1: Messung starten
irq_measure_start:
        lda #1              ; Rahmen = Weiß: Messung beginnt
        sta $D020
        jsr game_update     ; ← HIER wird der Code gemessen
        lda #0              ; Rahmen = Schwarz: Messung endet
        sta $D020
        jmp $EA81

; Schmaler weißer Streifen = wenige Zyklen = gut
; Breiter weißer Streifen = viele Zyklen = Frame-Overrun droht
; Streifen reicht bis zum unteren Rand = Frame-Overrun: Problem!
