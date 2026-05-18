; ============================================================
; C64 Mastery — stufe_01_6510_assembler
; Abschnitt: 3.7 Stack-Operationen
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
Stack ($0100–$01FF) — Nach Reset, SP = $FF:

  $01FF: [leer]   ← SP zeigt hier (nächster freier Platz)
  $01FE: [leer]
  $01FD: [leer]
  ...
  $0101: [leer]
  $0100: [leer]

Nach PHA (A = $42):
  $01FF: $42      ← Wert wurde hier geschrieben
  $01FE: [leer]   ← SP zeigt jetzt hier (SP wurde von $FF auf $FE dekrementiert)
  ...

Nach JSR $C000 (PC = $080F, also "return address" = $080E gespeichert):
  $01FF: $42
  $01FE: $08      ← High-Byte der Return-Adresse
  $01FD: $0E      ← Low-Byte der Return-Adresse (JSR speichert PC-1!)
  $01FC: [leer]   ← SP = $FC
  ...
