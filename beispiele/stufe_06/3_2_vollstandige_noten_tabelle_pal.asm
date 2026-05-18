; ============================================================
; C64 Mastery — stufe_06_sid_sound
; Abschnitt: 3.2 Vollständige Noten-Tabelle (PAL)
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Frequenztabelle für PAL (A4 = 440 Hz, gleichschwebend temperiert)
; Oktaven 1-6, je 12 Noten (C,C#,D,D#,E,F,F#,G,G#,A,A#,B)
; Format: Lo-Byte, Hi-Byte für jede Note

NoteTabLo:
  ; Oktave 1
  !byte $0d,$1c,$2c,$3e,$51,$65,$7b,$93,$ad,$c9,$e7,$08
  ; Oktave 2
  !byte $1b,$38,$58,$7b,$a2,$ca,$f5,$26,$5b,$93,$ce,$0e
  ; Oktave 3
  !byte $35,$6f,$ac,$f0,$41,$94,$ea,$4c,$b5,$25,$9b,$1a
  ; Oktave 4 (mittlere Lage)
  !byte $6a,$de,$58,$de,$82,$28,$d4,$97,$69,$4a,$35,$33
  ; Oktave 5
  !byte $d4,$bc,$af,$bc,$04,$4f,$a8,$2d,$d2,$94,$6a,$66
  ; Oktave 6
  !byte $a7,$77,$5e,$77,$08,$9e,$50,$5a,$a3,$28,$d4,$cc

NoteTabHi:
  ; Oktave 1
  !byte $01,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$03
  ; Oktave 2
  !byte $03,$03,$04,$04,$05,$05,$05,$06,$07,$07,$07,$08
  ; Oktave 3
  !byte $09,$0a,$0b,$0b,$0d,$0e,$0f,$11,$12,$14,$15,$17
  ; Oktave 4
  !byte $11,$13,$16,$18,$1b,$1e,$22,$26,$2b,$30,$35,$3b  ; (Beispielwerte)
  ; Oktave 5
  !byte $22,$26,$2c,$30,$36,$3c,$44,$4c,$56,$60,$6a,$76
  ; Oktave 6
  !byte $44,$4c,$58,$60,$6c,$78,$88,$98,$ac,$c0,$d4,$ec
