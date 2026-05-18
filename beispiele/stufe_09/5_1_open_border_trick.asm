; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 5.1 Open Border Trick
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Der berühmte "Open Border" Effekt: oberen/unteren Rand öffnen
; Trick: Raster-Register für den oberen Rand manipulation
;
; Unterer Rand öffnen:
; Kurz vor Zeile 300 (Ende des sichtbaren Bereichs):
; 1. Auf 24-Zeilen-Modus wechseln (Bit 3 von $D011 löschen)
; 2. Sofort zurück auf 25-Zeilen-Modus
; Das "verwirrt" den VIC-II Border-Detektor

OpenBorderIRQ:
          PHA
          LDA #$01 : STA $D019

          LDA $D012
          CMP #300-8 : BNE .check
          ; Zeile ~292: kurz auf 24-Zeilen-Modus
          LDA $D011
          AND #$F7              ; Bit 3 löschen (24-Zeilen)
          STA $D011

.check:   CMP #300-4 : BNE .done
          ; Zeile ~296: zurück auf 25-Zeilen
          LDA $D011
          ORA #$08              ; Bit 3 setzen
          STA $D011

.done:    ; Nächsten IRQ setzen
          LDA $D012
          CLC : ADC #1
          STA $D012
          PLA : RTI
