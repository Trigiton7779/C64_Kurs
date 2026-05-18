#!/bin/bash
# C64 Mastery — stufe_00_fundament
# Abschnitt: 3.3 Empfohlener Build-Workflow
#!/bin/bash
# build.sh — Einzeiler-Build-Skript für C64-Projekte

# ACME kompilieren (Quelle: prog.asm → Ausgabe: prog.prg)
acme -f cbm -o prog.prg --labeldump prog.sym prog.asm

# Nur wenn Kompilierung erfolgreich war ($? = 0): VICE starten
if [ $? -eq 0 ]; then
    echo "Kompilierung erfolgreich — starte VICE..."
    x64sc prog.prg
else
    echo "Fehler beim Kompilieren!"
fi
