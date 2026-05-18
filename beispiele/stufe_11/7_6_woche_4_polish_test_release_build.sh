#!/bin/bash
# C64 Mastery — stufe_11_spielentwicklung_workflow
# Abschnitt: 7.6 Woche 4: Polish, Test, Release-Build
#!/bin/bash
# build.sh — JUMPMASTER Build-Skript
set -e  # Abbrechen bei Fehler

# Kompilieren
acme --cpu 6510 -f cbm -o jumpmaster.prg main.asm
echo "Kompilierung erfolgreich: $(wc -c # D64-Image erstellen
rm -f jumpmaster.d64
c1541 -format "jumpmaster,01" d64 jumpmaster.d64 \
      -write jumpmaster.prg "jumpmaster"
echo "D64-Image erstellt: jumpmaster.d64"

# Starten
x64sc jumpmaster.d64 &
