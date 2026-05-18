; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 6.1 LAX — Lade A und X gleichzeitig
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Ohne LAX: Pointer laden für (zp),Y Zugriff
          LDA PointerLo    ; 3 Zyklen
          STA $FB          ; 3 Zyklen
          LDA PointerHi    ; 3 Zyklen
          STA $FC          ; 3 Zyklen
          LDX PointerLo    ; 3 Zyklen → X für anderes
; Total: 15 Zyklen

; Mit LAX: A und X gleichzeitig laden
          LAX PointerLo    ; 3 Zyklen → A=X=PointerLo
          STA $FB          ; 3 Zyklen
          LDA PointerHi    ; 3 Zyklen
          STA $FC          ; 3 Zyklen
; Total: 12 Zyklen → 20% schneller, X hat PointerLo als Bonus

; Praktisches Beispiel: Sprite-Daten kopieren mit LAX
CopySpriteData:
          LDY #62
.loop:
          LAX SpriteData,Y   ; A = X = SpriteData[Y]
          STA $0340,Y        ; In Sprite-Block schreiben (Absolut)
          ; X hat denselben Wert für anderweitige Nutzung
          DEY
          BPL .loop
          RTS
