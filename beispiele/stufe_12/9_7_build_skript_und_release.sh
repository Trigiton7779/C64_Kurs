#!/bin/bash
# C64 Mastery — stufe_12_demo_entwicklung_workflow
# Abschnitt: 9.7 Build-Skript und Release
#!/bin/bash
# build_bitwave.sh — Vollständiger Build der BITWAVE-Demo
set -e

echo "=== BITWAVE BUILD ==="

# Alle Teile kompilieren
acme --cpu 6510 -f cbm -o loader.prg src/loader.asm
acme --cpu 6510 -f cbm -o part1.prg  src/part1.asm
acme --cpu 6510 -f cbm -o part2.prg  src/part2.asm
acme --cpu 6510 -f cbm -o part3.prg  src/part3.asm
echo "Kompilierung abgeschlossen."

# D64-Image erstellen
rm -f bitwave.d64
c1541 -format "bitwave,99" d64 bitwave.d64 \
  -write loader.prg "loader" \
  -write musik.prg  "musik"  \
  -write part1.prg  "part1"  \
  -write part2.prg  "part2"  \
  -write part3.prg  "part3"
echo "D64-Image: bitwave.d64 ($(du -k bitwave.d64 | cut -f1) KB)"

# VICE starten
x64sc bitwave.d64 &
echo "VICE gestartet."
