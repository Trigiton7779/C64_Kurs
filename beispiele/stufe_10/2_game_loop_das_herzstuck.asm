; ============================================================
; C64 Mastery — stufe_10_meisterschaft
; Abschnitt: 2. Game Loop — Das Herzstück
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Vollständiger Game Loop
; Läuft synchron mit dem VBlank-IRQ

VBlankFlag: !byte 0   ; Gesetzt vom VBlank-IRQ

GameLoop:
          ; Auf VBlank warten (Synchronisation mit 50 Hz)
.wait:    LDA VBlankFlag
          BEQ .wait
          LDA #0 : STA VBlankFlag   ; Flag zurücksetzen

          ; === PHASE 1: INPUT (sofort, keine Verzögerung) ===
          JSR ReadJoystick
          JSR ReadKeyboard

          ; === PHASE 2: UPDATE (Spiellogik) ===
          LDA CurrentState
          ASL : TAX
          LDA StateUpdateTable,X   : STA Tmp16
          LDA StateUpdateTable+1,X : STA Tmp16+1
          JSR CallTmp16            ; Update für aktuellen Zustand

          ; === PHASE 3: SPRITE-SORT (VBlank-Mitte) ===
          JSR SortSprites          ; Y-Sortierung für Multiplexer
          JSR UpdateAnimations     ; Frame-Counter, Sprite-Animationen

          ; === PHASE 4: MUSIC UPDATE ===
          JSR MusicUpdate          ; Nächsten Musik-Frame spielen

          ; === PHASE 5: FRAME-COUNTER ===
          INC FrameCount
          BNE .next
          INC FrameCount+1
.next:
          JMP GameLoop

CallTmp16:
          JMP (Tmp16)

; VBlank-IRQ (Zeile 250)
VBlankIRQ:
          PHA
          LDA #$01 : STA $D019
          LDA #1 : STA VBlankFlag  ; Game Loop aufwecken
          ; VBlank-IRQ für nächsten Frame setzen
          LDA #251 : STA $D012
          PLA : RTI
