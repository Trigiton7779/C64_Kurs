; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 4.2 Y-Sortierung
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Insertion Sort für Sprite-Y-Positionen
; Muss jeden Frame im VBlank ausgeführt werden
; Eingabe: SprLogY[], SprLogActive[]
; Ausgabe: SortedIdx[] in aufsteigender Y-Reihenfolge

SortSprites:
          ; Phase 1: SortedIdx mit aktiven Sprite-Indizes füllen
          LDX #0
          LDY #0
.fill:    LDA SprLogActive,Y    ; Aktiv?
          BEQ .skip
          TY : STA SortedIdx,X
          INX
.skip:    INY
          CPY #MAX_SPRITES
          BNE .fill
          STX NumActive         ; Anzahl aktiver Sprites

          ; Phase 2: Insertion Sort auf SortedIdx nach SprLogY
          LDX #1
.outer:   CPX NumActive : BEQ .done
          LDA SortedIdx,X       ; Aktueller Index
          STA TmpIdx
          LDA SprLogY,X         ; Aktueller Y-Wert
          STA TmpY
          TXA : TAY             ; Y = aktuell
.inner:   CPY #0 : BEQ .insert
          DEY
          LDA SortedIdx,Y
          TAX
          LDA SprLogY,X         ; Vorheriger Y-Wert
          CMP TmpY
          BEQ .insert : BCC .insert  ; Vorheriger ≤ aktueller: einfügen
          ; Vorheriger > aktueller: nach rechts schieben
          LDA SortedIdx,Y
          STA SortedIdx+1,Y
          JMP .inner
.insert:  LDA TmpIdx
          STA SortedIdx+1,Y
          INX
          JMP .outer
.done:    RTS
