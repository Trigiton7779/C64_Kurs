; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 4.2 Multiplikations-LUT (a²/4 Methode)
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Quadrat/4 Tabelle: sq4[i] = (i*i)/4 für i = 0..511
; Benötigt 512 Bytes, spart aber VIEL Rechenzeit

; Multiplikation: A × B → Ergebnis in $10/$11 (16-Bit)
; A in Akku, B in X-Register bei Aufruf

Multiply:
          STX TmpX          ; B sichern
          STA TmpA          ; A sichern

          ; Berechne (A+B)/4 → Sq4Lo/Hi
          CLC
          ADC TmpX          ; A+B
          TAX
          LDA Sq4Lo,X
          STA $10
          LDA Sq4Hi,X
          STA $11

          ; Berechne (A-B)/4 → subtrahieren
          LDA TmpA
          SEC
          SBC TmpX          ; A-B (kann negativ sein → 256+Ergebnis nutzen)
          TAX
          LDA $10
          SEC
          SBC Sq4Lo,X
          STA $10
          LDA $11
          SBC Sq4Hi,X
          STA $11
          RTS

; sq4-Tabelle: 512 Einträge à 2 Bytes (Lo/Hi getrennt)
; sq4[i] = (i*i)/4
Sq4Lo:
!for i, 0, 255 { !byte <((i*i)/4) }
!for i, 256, 511 { !byte <((i*i)/4) }

Sq4Hi:
!for i, 0, 255 { !byte >((i*i)/4) }
!for i, 256, 511 { !byte >((i*i)/4) }
