; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 8.2 Zwei-Screen-Puffer für flimmerfreie Charset-Updates
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Problem: Zeichensatz während des Bildaufbaus ändern → sichtbares Flimmern
; Lösung: Zwei Zeichensatz-Puffer, zwischen Frames umschalten

; Puffer 1: $2000-$27FF (2 KB Zeichensatz)
; Puffer 2: $2800-$2FFF
; $D018 Bits 1-3: Zeichensatz-Startadresse (in 2KB-Schritten im VIC-Bank)

ActiveCharset: !byte 0   ; 0 = Puffer 1, 1 = Puffer 2

SwapCharset:
          LDA ActiveCharset
          EOR #1
          STA ActiveCharset
          BEQ .puffer1
          ; Puffer 2 aktiv machen
          LDA $D018
          AND #$F1           ; Bits 1-3 löschen
          ORA #$0A           ; Puffer 2 = Offset 5 × 2KB = $2800
          STA $D018          ; Erst VBlank abwarten für flimmerfrei!
          RTS
.puffer1: LDA $D018
          AND #$F1
          ORA #$08           ; Puffer 1 = $2000
          STA $D018
          RTS

; Schreibe in INAKTIVEN Puffer (während VIC den aktiven zeigt)
GetInactiveBase:
          LDA ActiveCharset  ; 0=aktiv1, schreib in 2; 1=aktiv2, schreib in 1
          BEQ .return2
          LDA #$20 : RTS     ; High-Byte von $2000
.return2: LDA #$28 : RTS     ; High-Byte von $2800
