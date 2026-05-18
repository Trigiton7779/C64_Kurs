; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 7.2 Sprite-Stretching (Horizontale Vergrößerung)
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Sprite horizontal strecken durch schnelles X-Positions-Update
; Trick: Pro Rasterzeile des Sprites wird $D000 verschoben
; → Sprite "bricht" horizontal auseinander

StretchIRQ:
          PHA : TXA : PHA

          LDA #$01 : STA $D019

          LDA $D012            ; Aktuelle Zeile
          SEC : SBC SpriteTop  ; Zeile relativ zum Sprite-Anfang
          TAX
          LDA StretchX,X       ; Vorberechnete X-Verschiebung
          CLC : ADC BaseSprX
          STA $D000            ; Sprite 0 X-Position

          LDA $D012
          CLC : ADC #1
          CMP StretchEnd : BNE .next
          LDA SpriteTop        ; Zurück zum Anfang
.next:    STA $D012
          PLA : TAX : PLA
          RTI

; Stretch-Tabelle: Sinus-Kurve für Stretch-X pro Zeile
StretchX:
!for i, 0, 20 {
    !byte <(sin(i / 21.0 * 3.14159) * 30)
}
