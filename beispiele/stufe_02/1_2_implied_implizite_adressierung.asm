; ============================================================
; C64 Mastery — stufe_02_adressierung_speicher
; Abschnitt: 1.2 Implied — Implizite Adressierung
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Implied-Befehle: Typische Anwendungen
NOP             ; No Operation — 2 Zyklen Zeitverschwendung (oder Timing-Pad)
CLC             ; Clear Carry Flag — vor ADC zwingend!
SEC             ; Set Carry Flag — vor SBC zwingend!
CLI             ; Clear Interrupt Disable — IRQs erlauben
SEI             ; Set Interrupt Disable — IRQs sperren
CLD             ; Clear Decimal Mode (auf C64 nach Reset nötig)
SED             ; Set Decimal Mode (BCD-Arithmetik)
CLV             ; Clear Overflow Flag
INX             ; Increment X — X++
DEX             ; Decrement X — X--
INY             ; Increment Y — Y++
DEY             ; Decrement Y — Y--
TAX             ; Transfer A → X
TAY             ; Transfer A → Y
TXA             ; Transfer X → A
TYA             ; Transfer Y → A
TXS             ; Transfer X → SP (Stack-Pointer setzen — KEIN Flag-Update!)
TSX             ; Transfer SP → X
PHA             ; Push A auf Stack
PLA             ; Pull A vom Stack (setzt N und Z Flags!)
PHP             ; Push Processor-Flags auf Stack
PLP             ; Pull Processor-Flags vom Stack
RTS             ; Return from Subroutine — liest Adresse vom Stack
RTI             ; Return from Interrupt — liest Flags + Adresse vom Stack
BRK             ; Software-Interrupt — löst BRK-IRQ aus
