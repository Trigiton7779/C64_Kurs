; ============================================================
; C64 Mastery — stufe_12_demo_entwicklung_workflow
; Abschnitt: 7.2 Raster-Jitter mit VICE diagnostizieren
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Jitter-Test: Wenn der weiße Strich unscharf oder gewellt ist → Jitter
raster_irq_test:
        lda #1              ; Weiß
        sta $D020

        ; ... IRQ-Arbeit ...

        lda #0              ; Schwarz
        sta $D020
        jmp $EA81

; Lösung: Double-IRQ-Technik aus Stufe 07 anwenden
; Erster IRQ NOP-Schleife bis zur stabilen Phase,
; Zweiter IRQ macht die eigentliche Arbeit
