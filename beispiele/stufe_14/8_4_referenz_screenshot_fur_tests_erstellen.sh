#!/bin/bash
# C64 Mastery — stufe_14_modern_workflow
# Abschnitt: 8.4 Referenz-Screenshot für Tests erstellen
# Einmalig: Referenz-Screenshot erzeugen und einchecken
make build
x64sc -headless -autostart build/meinspiel_pal.prg \
      -limitcycles 300000 -screenshot test/reference.png -1
git add test/reference.png
git commit -m "chore: add CI reference screenshot"
