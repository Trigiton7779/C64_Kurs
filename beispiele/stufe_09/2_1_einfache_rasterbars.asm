; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 2.1 Einfache Rasterbars
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Setup: Raster-IRQ für erste Bar
SetupRasterBar:
          SEI
          LDA #$7F : STA $DC0D  ; CIA IRQs aus
          LDA #$7F : STA $DD0D

          LDA #$01 : STA $D01A  ; VIC Raster-IRQ ein

          LDA #BarStart         ; Erste Zeile der ersten Bar
          STA $D012
          LDA $D011
          AND #$7F : STA $D011  ; Raster MSB = 0

          LDA #<RasterBarIRQ
          STA $0314
          LDA #>RasterBarIRQ
          STA $0315
          CLI
          RTS

; Farbtabelle: 16 Einträge für eine vollständige Bar
BarColors:
          !byte 0, 6, 6, 14, 14, 3, 3, 1  ; Schwarz→Blau→Cyan→Weiß
          !byte 1, 3, 3, 14, 14, 6, 6, 0  ; ...zurück
BarColorsEnd:

BarStart = 50                    ; Erste Zeile der Bar
BarHeight = 16                   ; Zeilen pro Bar

; IRQ-Handler: Ändert Farbe für jede Zeile der Bar
RasterBarIRQ:
          PHA : TXA : PHA : TYA : PHA

          LDA #$01 : STA $D019  ; Raster-IRQ quittieren

          ; Für jede der 16 Bar-Zeilen: Farbe setzen + auf nächste Zeile warten
          LDX #0
.barloop:
          LDA BarColors,X       ; Nächste Farbe
          STA $D021             ; Hintergrundfarbe setzen

          ; Warte auf nächste Rasterzeile (Busy-Wait Methode)
          LDA $D012             ; Aktuelle Zeile lesen
.wait:    CMP $D012
          BEQ .wait             ; Warten bis Zeile weitergeht

          INX
          CPX #BarHeight
          BNE .barloop

          ; Bar fertig, Hintergrund zurücksetzen
          LDA #0 : STA $D021

          ; Nächsten IRQ für nächsten Frame setzen
          LDA #BarStart : STA $D012

          PLA : TAY : PLA : TAX : PLA
          RTI

; HINWEIS: Der Busy-Wait-Ansatz ist einfach aber ungenau.
; Professionelle Rasterbars nutzen den Double-IRQ-Trick (Stufe 07)
; für pixel-genaues Timing ohne Jitter.
