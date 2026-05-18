; ============================================================
; C64 Mastery — stufe_01_6510_assembler
; Abschnitt: 3.3 Arithmetik — Addition und Subtraktion
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Zähler an Adresse $60 erhöhen (ohne Akkumulator zu verändern)
        inc $60          ; [$60] = [$60] + 1

; Gleiches mit Akkumulator — schlechter, da 2 Befehle mehr:
        lda $60
        clc
        adc #1
        sta $60          ; Funktioniert, aber kostet mehr Zyklen und verändert A

; Countdown-Schleife mit DEX:
        ldx #10         ; 10 Iterationen
loop:
        ; ... Code ...
        dex             ; X--; setzt Z=1 wenn X jetzt 0
        bne loop        ; Springe wenn X != 0
