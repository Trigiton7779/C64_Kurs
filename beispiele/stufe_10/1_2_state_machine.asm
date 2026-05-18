; ============================================================
; C64 Mastery — stufe_10_meisterschaft
; Abschnitt: 1.2 State Machine
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Spielzustände
STATE_TITLE    = 0
STATE_STORY    = 1
STATE_GAME     = 2
STATE_PAUSE    = 3
STATE_GAMEOVER = 4
STATE_WIN      = 5

; State-Tabellen: Init-, Update-, Draw-Funktionen pro Zustand
StateInitTable:
          !word TitleInit, StoryInit, GameInit
          !word PauseInit, GameOverInit, WinInit

StateUpdateTable:
          !word TitleUpdate, StoryUpdate, GameUpdate
          !word PauseUpdate, GameOverUpdate, WinUpdate

StateDrawTable:
          !word TitleDraw, StoryDraw, GameDraw
          !word PauseDraw, GameOverDraw, WinDraw

CurrentState: !byte STATE_TITLE
PrevState:    !byte $FF   ; Für Übergangs-Erkennung

; Zustandswechsel mit Init-Aufruf
ChangeState:
          ; A = neuer Zustand
          CMP CurrentState : BEQ .same
          STA CurrentState
          ASL : TAX
          LDA StateInitTable,X   : STA Tmp16
          LDA StateInitTable+1,X : STA Tmp16+1
          JMP (Tmp16)            ; Init-Funktion aufrufen (indirekter Sprung)
.same:    RTS
