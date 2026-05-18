; ============================================================
; C64 Mastery — stufe_07_interrupts_timing
; Abschnitt: 3.2 Präziser 50 Hz Timer-IRQ
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; CIA1 Timer A für exakt 50 Hz (PAL) konfigurieren
; PAL: 985248 Hz, 985248 / 50 = 19704,96 ≈ 19704 Zyklen = $4CC8

InitTimer50Hz:
        SEI
        ; Alle CIA-IRQs deaktivieren
        LDA #$7F
        STA $DC0D       ; CIA1: alle IRQs aus (Bit 7=0 → Bits löschen)
        STA $DD0D       ; CIA2: alle IRQs aus
        LDA $DC0D       ; Pending-Bits löschen (durch Lesen)
        LDA $DD0D

        ; Eigenen IRQ-Vektor setzen
        LDA #<TimerHandler
        STA $0314
        LDA #>TimerHandler
        STA $0315

        ; Timer A Latch auf 19704 ($4CC8) setzen
        LDA #$C8        ; $4CC8 Low-Byte
        STA $DC04       ; Timer A Low (schreibt Latch)
        LDA #$4C        ; $4CC8 High-Byte
        STA $DC05       ; Timer A High (schreibt Latch)

        ; Control Register A: Continuous + Systemclock + sofortiges Laden + Start
        LDA #%00010001  ; Bit 4 (LOAD) + Bit 0 (START)
        STA $DC0E

        ; Timer A IRQ aktivieren
        LDA #%10000001  ; Bit 7=1 (Bits setzen), Bit 0=Timer A
        STA $DC0D

        CLI
        RTS

TimerHandler:
        LDA $DC0D       ; Interrupt-Status lesen (quittiert CIA1-IRQ!)
        ; Eigener Code hier...
        JMP $EA31       ; KERNAL-IRQ für Tastatur etc. aufrufen
