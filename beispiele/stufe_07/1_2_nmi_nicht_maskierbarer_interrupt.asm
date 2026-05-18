; ============================================================
; C64 Mastery — stufe_07_interrupts_timing
; Abschnitt: 1.2 NMI — Nicht-Maskierbarer Interrupt
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; RESTORE-Taste abfangen (NMI übernehmen):
        lda #<MyNMIHandler
        sta $0318
        lda #>MyNMIHandler
        sta $0319

MyNMIHandler:
        ; Eigene Aktion bei RESTORE-Taste
        ; z.B.: Spiel pausieren, Menü anzeigen
        lda #$00 : sta $d020    ; Border kurz aufleuchten
        ; Nach Verarbeitung normale Rückkehr:
        rti
