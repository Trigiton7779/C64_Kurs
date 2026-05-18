; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 9.2 Vertikaler Open Border (oben und unten)
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Vertikalen Border öffnen: oben UND unten
; Zwei IRQ-Ebenen bei den kritischen Rasterzeilen

; --- Setup: IRQ installieren ---
InitOpenBorder:
          SEI
          LDA #<IRQ_Bottom   ; Zuerst: Bottom-Border-IRQ
          STA $0314
          LDA #>IRQ_Bottom
          STA $0315
          LDA #251           ; PAL: Bottom-Border beginnt bei 251
          STA $D012
          LDA $D011
          AND #$7F           ; Bit 7 von $D012 (Raster-Hi-Bit) löschen
          STA $D011
          LDA #$01
          STA $D01A          ; Raster-IRQ erlauben
          CLI
          RTS

; --- IRQ bei Rasterline 251: Bottom-Border öffnen ---
IRQ_Bottom:
          LDA $D011
          AND #$F7           ; Bit 3 löschen → 24-Zeilen-Modus
          STA $D011
          ; Sofort auf nächste kritische Zeile vorbereiten
          LDA #255
          STA $D012
          LDA #<IRQ_BottomRestore
          STA $0314
          LDA #>IRQ_BottomRestore
          STA $0315
          ASL $D019          ; IRQ-Flag löschen
          RTI

; --- IRQ bei Rasterline 255: Modus zurücksetzen ---
IRQ_BottomRestore:
          LDA $D011
          ORA #$08           ; Bit 3 setzen → 25-Zeilen-Modus (normal)
          STA $D011
          ; Umschalten zu Top-Border-IRQ
          LDA #51            ; PAL: Top-Border-Ende bei Rasterline 51
          STA $D012
          LDA #<IRQ_Top
          STA $0314
          LDA #>IRQ_Top
          STA $0315
          ASL $D019
          RTI

; --- IRQ bei Rasterline 51: Top-Border öffnen ---
IRQ_Top:
          LDA $D011
          AND #$F7           ; Kurz in 24-Zeilen-Modus
          STA $D011
          LDA #55
          STA $D012
          LDA #<IRQ_TopRestore
          STA $0314
          LDA #>IRQ_TopRestore
          STA $0315
          ASL $D019
          RTI

; --- IRQ bei Rasterline 55: zurückschalten, dann wieder zu 251 ---
IRQ_TopRestore:
          LDA $D011
          ORA #$08           ; zurück zu 25-Zeilen (normal)
          STA $D011
          LDA #251           ; Zyklus neu starten
          STA $D012
          LDA #<IRQ_Bottom
          STA $0314
          LDA #>IRQ_Bottom
          STA $0315
          ASL $D019
          RTI
