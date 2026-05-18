; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 8.2 Indirekte Dispatch-Tabellen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Game-State-Machine: schneller Dispatch ohne if-else-Ketten

GameLoop:
          LDA GameState     ; 0=Titel, 1=Spiel, 2=GameOver, 3=Pause
          ASL               ; × 2 für Word-Tabelle
          TAX
          JMP (StateTable,X) ; 5 Zyklen — direkter Sprung!

StateTable:
          !word DoTitleScreen
          !word DoGameplay
          !word DoGameOver
          !word DoPause

DoTitleScreen:
          ; ... Titelbildschirm-Logik ...
          RTS ; (oder JMP GameLoop)

DoGameplay:
          ; ... Spiel-Logik ...
          RTS
