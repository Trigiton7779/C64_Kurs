; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 5.1 Adress-Patching
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Statt Index-Register für Quelladresse zu verwenden:
; Direkte Modifikation des LDA-Operanden

CopyWithSMC:
          LDA #<Source      ; Low-Byte der Quelladresse
          STA SMC_Src+1     ; Patch: Operand des LDA-Befehls unten
          LDA #>Source
          STA SMC_Src+2     ; High-Byte des LDA-Operanden

          LDA #<Dest
          STA SMC_Dst+1
          LDA #>Dest
          STA SMC_Dst+2

          LDX #$00
.loop:
SMC_Src:  LDA $0000,X       ; ← Operand wird zur Laufzeit gepatcht!
SMC_Dst:  STA $0000,X       ; ← Dieser auch
          INX
          BNE .loop
          RTS

; Vorteil: Keine Zero-Page-Pointer nötig → spart (zp),Y Overhead
; LDA abs,X = 4+1 Zyklen (aber kein 2-Zyklus-Indirekt-Overhead)
; LDA (zp),Y = 5+1 Zyklen
