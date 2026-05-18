; ============================================================
; C64 Mastery — stufe_01_6510_assembler
; Abschnitt: 3.3 Arithmetik — Addition und Subtraktion
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; 8-Bit Subtraktion: A = 200 - 50 = 150
        sec             ; Carry setzen! IMMER vor SBC
        lda #200
        sbc #50         ; A = 200 - 50 - (1-1) = 150, C=1 (kein Borrow)

; 8-Bit Subtraktion mit Unterlauf: A = 50 - 200 → negatives Ergebnis
        sec
        lda #50
        sbc #200        ; A = 50 - 200 - 0 = -150. Als Byte: 256-150=106, C=0 (Borrow!)

; 16-Bit Subtraktion: val1 - val2 → result
        sec             ; Carry setzen vor dem Low-Byte
        lda $20          ; Low-Byte von val1
        sbc $22          ; - Low-Byte von val2; Borrow-Bit ins C-Flag
        sta $24          ; → result Low-Byte
        lda $21          ; High-Byte von val1
        sbc $23          ; - High-Byte von val2 - Borrow vom Low-Byte!
        sta $25          ; → result High-Byte
