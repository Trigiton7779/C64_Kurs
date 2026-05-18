; ============================================================
; C64 Mastery — stufe_15_debugging_deep_dive
; Abschnitt: 6.2 Stack-Overflow erkennen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; stack_guard — Canary-Byte gegen Stack-Overflow
; Schreibt bekanntes Muster an unteres Stack-Ende
; IRQ-Handler prüft regelmäßig ob Canary intakt ist

STACK_CANARY_ADDR = $0101  ; Tiefstes erreichbares Stack-Byte
CANARY_BYTE       = $C3    ; Zufälliger Wert — unwahrscheinlich als Zufallswert

install_stack_guard:
    lda #CANARY_BYTE
    sta STACK_CANARY_ADDR
    rts

; Im IRQ-Handler aufrufen (oder periodisch im Hauptprogramm)
check_stack_guard:
    lda STACK_CANARY_ADDR
    cmp #CANARY_BYTE
    beq .stack_ok
    ; CANARY ÜBERSCHRIEBEN → Stack-Overflow aufgetreten!
    brk                    ; Monitor öffnen für Post-Mortem-Analyse
.stack_ok:
    rts

; Im Monitor: "r" zeigt SP — wenn SP 
; "m 0100 01FF" zeigt kompletten Stack-Inhalt
