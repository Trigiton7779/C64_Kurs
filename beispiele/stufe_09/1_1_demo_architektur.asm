; ============================================================
; C64 Mastery — stufe_09_demo_effekte
; Abschnitt: 1.1 Demo-Architektur
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Typische Demo-Struktur
*= $0801
; BASIC-Stub: SYS 2080
!byte $0b,$08,$e2,$07,$9e,$20,$32,$30,$38,$30,$00,$00,$00

*= $0820
Init:
          SEI                  ; Interrupts sperren während Setup
          LDA #$35
          STA $01              ; BASIC aus, KERNAL aus, I/O an

          JSR InitSID          ; SID initialisieren
          JSR LoadMusicData    ; Musik-Daten laden
          JSR InitPart1        ; Ersten Teil vorbereiten
          JSR SetupIRQ         ; Raster-IRQ installieren
          CLI                  ; Interrupts freigeben

MainLoop:
          JMP MainLoop         ; Endlosschleife — IRQs machen alles

; --- Globale Variablen ---
DemoState:   !byte 0    ; 0=Part1, 1=Part2, 2=Part3
PartTimer:   !word 0    ; Frames in diesem Part
SyncFlag:    !byte 0    ; Gesetzt vom IRQ, gelesen im Mainloop
