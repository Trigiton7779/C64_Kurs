; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 8.1 Stack als schneller Puffer
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Der Stack ($0100–$01FF) ist eine Zero-Page-ähnliche Region
; Direkter Zugriff über TSX + LDA $0100,X ist möglich!

; Stack als temporären Datenpuffer nutzen
SaveRegisters:
          PHA              ; A sichern: 3 Zyklen
          TXA : PHA        ; X: 2+3=5 Zyklen
          TYA : PHA        ; Y: 2+3=5 Zyklen
; Total: 13 Zyklen für A,X,Y

; Alternativ: Zero Page ist schneller wenn häufig genutzt
; STA Save_A: 3, STX Save_X: 3, STY Save_Y: 3 → 9 Zyklen

; Stack-Pointer-Trick: Direkter Datenpuffer
; Setze SP auf $FF-N → nächste N PHA-Befehle landen im "Puffer"
          LDX #$C0         ; SP = $C0 (64 Bytes Puffer: $01C1-$01FF)
          TXS
          ; Jetzt: PHA schreibt in $01FF, $01FE, ... rückwärts
          ; Lesen mit TSX / LDA $0101,X / INX...
