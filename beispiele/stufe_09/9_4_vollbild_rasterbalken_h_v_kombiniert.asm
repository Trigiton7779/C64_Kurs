; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 9.4 Vollbild-Rasterbalken (H + V kombiniert)
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Vollbild-Rasterbalken: H-Border offen, Farbe wechseln
; Jede Zeile: $D016 kurz auf 38 Spalten, $D020 = neue Farbe

FullwidthBar_IRQ:
          LDY $D012          ; aktuelle Rasterzeile
          LDA ColorTable,Y   ; Farbe für diese Zeile
          ; H-Border öffnen + Farbe setzen (in einem Atemzug)
          LDX $D016
          TXA
          AND #$F7           ; 38-Spalten
          STA $D016
          STA $D020          ; Border-Farbe
          STA $D021          ; Hintergrund-Farbe (optional)
          ; Kurze Verzögerung (bleibt im HBlank)
          NOP : NOP : NOP
          TXA
          ORA #$08           ; zurück zu 40 Spalten
          STA $D016
          ASL $D019
          JMP $EA7E          ; IRQ-Ende (ohne KERNAL)

ColorTable:
          !fill 312, 0         ; 312 Einträge für alle PAL-Zeilen
