; ============================================================
; C64 Mastery — stufe_10_meisterschaft
; Abschnitt: 6. Disk-I/O via KERNAL
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; KERNAL-Routinen für Disk-I/O
SETLFS   = $FFBA   ; Logical File, Device, Sekundäradresse setzen
SETNAM   = $FFBD   ; Dateiname setzen
OPEN     = $FFC0   ; Datei öffnen
CHKIN    = $FFC6   ; Eingabe-Kanal setzen
CHRIN    = $FFCF   ; Zeichen lesen
CLOSE    = $FFC3   ; Datei schließen
CLRCHN   = $FFCC   ; Kanal zurücksetzen
LOAD     = $FFD5   ; Programm/Daten laden
ST       = $90     ; ZP-Status-Byte

; Datei laden: Dateiname in FilenamePtr (ZP), Länge in FilenameLen
; Ladeadresse: LoadAddrLo/Hi
LoadFile:
          ; KERNAL temporär einschalten (falls ausgeschaltet)
          LDA $01
          PHA
          LDA #$37 : STA $01    ; BASIC+KERNAL+I/O ein

          ; Dateiname setzen
          LDA FilenameLen
          LDX FilenamePtr
          LDY FilenamePtr+1
          JSR SETNAM

          ; Logical File 1, Device 8 (1541), Sekundäradresse 0
          LDA #1 : LDX #8 : LDY #0
          JSR SETLFS

          ; LOAD: Akku=0 = laden (nicht verify), X/Y = Zieladresse
          LDA #0
          LDX LoadAddrLo
          LDY LoadAddrHi
          JSR LOAD              ; Lädt direkt in den Speicher!

          LDA $90               ; Status prüfen
          STA LoadStatus        ; 0 = OK, sonst Fehler

          ; KERNAL zurückschalten auf vorherigen Zustand
          PLA : STA $01
          RTS

; Dateinamen-Definition
Level1Name: !text "LEVEL1.DAT"
Level1NameLen = * - Level1Name

; Level laden:
LoadLevel1:
          LDA #<Level1Name : STA FilenamePtr
          LDA #>Level1Name : STA FilenamePtr+1
          LDA #Level1NameLen : STA FilenameLen
          LDA #<MapData : STA LoadAddrLo
          LDA #>MapData : STA LoadAddrHi
          JSR LoadFile
          RTS
