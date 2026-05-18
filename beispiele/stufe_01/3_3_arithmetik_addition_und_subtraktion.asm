; ============================================================
; C64 Mastery — stufe_01_6510_assembler
; Abschnitt: 3.3 Arithmetik — Addition und Subtraktion
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; 8-Bit Addition: A = 100 + 150 = 250 → kein Carry
        clc             ; Carry löschen! IMMER vor ADC
        lda #100         ; A = 100 ($64)
        adc #150         ; A = 100 + 150 + 0 = 250 ($FA), C=0

; 8-Bit Addition mit Überlauf: A = 200 + 100 = 300 = $12C
        clc
        lda #200         ; A = 200 ($C8)
        adc #100         ; A = 200 + 100 + 0 = 300. Ergebnis im Byte: 300-256=$2C, C=1
; → A = $2C (44), C = 1 (Carry = das Bit, das nicht mehr ins Byte passt)

; 16-Bit Addition: (val1_hi:val1_lo) + (val2_hi:val2_lo) → result
; Variablen in Zero-Page: val1 bei $20/$21 (lo/hi), val2 bei $22/$23
        clc             ; Carry vor dem Low-Byte löschen
        lda $20          ; Low-Byte von val1
        adc $22          ; + Low-Byte von val2; möglicher Carry ins C-Flag
        sta $24          ; → result Low-Byte
        lda $21          ; High-Byte von val1
        adc $23          ; + High-Byte von val2 + Carry vom Low-Byte!
        sta $25          ; → result High-Byte
; Kein CLC vor dem High-Byte! Das Carry vom Low-Byte wird gebraucht.
