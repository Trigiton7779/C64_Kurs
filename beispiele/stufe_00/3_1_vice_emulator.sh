#!/bin/bash
# C64 Mastery — stufe_00_fundament
# Abschnitt: 3.1 VICE Emulator
# Linux (Debian/Ubuntu/Mint):
sudo apt update && sudo apt install vice

# macOS (mit Homebrew):
brew install vice

# Windows:
# Installer von https://vice-emu.sourceforge.io/ herunterladen
# VICE enthält mehrere Emulatoren: x64sc ist der präziseste C64-Emulator

# Nach der Installation: x64sc starten (der 'sc' steht für 'super cpu accurate')
x64sc
