; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 8.4 16-Bit-Arithmetik optimieren
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; 16-Bit Addition (häufige Operation):
; Standard:
          LDA Val16Lo      ; 3
          CLC              ; 2
          ADC Add16Lo      ; 3
          STA Val16Lo      ; 3
          LDA Val16Hi      ; 3
          ADC Add16Hi      ; 3
          STA Val16Hi      ; 3
; Total: 20 Zyklen

; Wenn Add16 eine Konstante: Unmittelbar statt Laden
; Z.B. +1 (INC-Methode):
          INC Val16Lo      ; 5 (ZP: 5 statt 6)
          BNE .done        ; 3/2 → meist 2 (kein Überlauf)
          INC Val16Hi      ; selten ausgeführt
.done:                     ; Total: 7 Zyklen im Normalfall!

; Für häufige +256 Addition (High-Byte nur):
          INC Addr+1       ; 6 Zyklen: Nur High-Byte inkrementieren
; Äquivalent zu: 16-Bit-Pointer um 256 vorwärts bewegen
