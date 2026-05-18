; ============================================================
; C64 Mastery — stufe_05_bitmap_grafik
; Abschnitt: 2.3 Bitmap-Byte-Layout
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
Byte-Adresse eines Pixels an (px, py):
  Zellen-Spalte  = px / 8
  Zellen-Zeile   = py / 8
  Pixel-in-Zelle-X = px MOD 8
  Pixel-in-Zelle-Y = py MOD 8

  Byte-Offset = (Zellen-Zeile × 320) + (Zellen-Spalte × 8) + Pixel-in-Zelle-Y
  Bit-Position = 7 - Pixel-in-Zelle-X

Beispiel: Pixel (100, 75)
  Zellen-Spalte  = 100/8 = 12
  Zellen-Zeile   = 75/8  = 9
  PinZ-X = 100 MOD 8 = 4
  PinZ-Y = 75 MOD 8  = 3

  Byte-Offset = (9×320) + (12×8) + 3 = 2880 + 96 + 3 = 2979
  Bit = 7 - 4 = 3 → Maske = %00001000 = $08
