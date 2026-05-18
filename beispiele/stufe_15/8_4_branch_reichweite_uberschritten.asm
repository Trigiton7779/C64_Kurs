; ============================================================
; C64 Mastery — stufe_15_debugging_deep_dive
; Abschnitt: 8.4 Branch-Reichweite überschritten
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; PROBLEM: BNE springt weiter als 127 Bytes
; LÖSUNG: Invertiere die Bedingung und springe zu einem nahen JMP
original_code:
    cmp #10
    bne far_target      ; FEHLER: zu weit weg

fixed_code:
    cmp #10
    beq .skip           ; Bedingung invertiert: gleich → überspringen
    jmp far_target      ; JMP hat volle 16-Bit-Reichweite
.skip:
