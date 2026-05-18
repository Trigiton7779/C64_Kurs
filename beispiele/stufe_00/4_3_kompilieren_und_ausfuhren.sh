#!/bin/bash
# C64 Mastery — stufe_00_fundament
# Abschnitt: 4.3 Kompilieren und Ausführen
# ACME aufrufen:
acme -f cbm -o farben.prg farben.asm

# Bei Erfolg erscheint: "ACME -- the ACME Cross-Assembler [...]"
# Kein Output = Erfolg (Fehler werden explizit angezeigt)

# Programm in VICE öffnen:
x64sc farben.prg

# Im C64-BASIC prompt erscheint "READY." — jetzt RUN eingeben und Enter drücken
# Ergebnis: Blauer Hintergrund, schwarzer Rahmen, weißer leerer Bildschirm
