# C64 Mastery System

Ein vollständiger Commodore-64-Assembler-Lehrgang im Fachbuch-Stil — vom ersten Hallo-Welt bis zur fertigen Demo oder zum eigenen Spiel. Alle Inhalte sind statische HTML-Dateien, die ohne Server-Setup direkt im Browser geöffnet werden können.

---

## Inhalt

### 16 Lernstufen (Stufe 00–15)

| Stufe | Datei | Thema |
|------:|-------|-------|
| 00 | `stufe_00_fundament.html` | Geschichte, Hardware-Architektur, Entwicklungsumgebung |
| 01 | `stufe_01_6510_assembler.html` | 6510-CPU, Register, Flags, vollständiger Befehlssatz |
| 02 | `stufe_02_adressierung_speicher.html` | Adressierungsarten, C64-Speicherkarte $0000–$FFFF |
| 03 | `stufe_03_bildschirm_zeichen.html` | VIC-II Grundlagen, Zeichenmodus, benutzerdefinierter Charset |
| 04 | `stufe_04_sprites_animation.html` | Hardware-Sprites, Animation, Kollisionserkennung |
| 05 | `stufe_05_bitmap_grafik.html` | Hires-Bitmap, Multicolor, FLI-Technik |
| 06 | `stufe_06_sid_sound.html` | SID-Chip, ADSR, Wellenformen, Musikprogrammierung |
| 07 | `stufe_07_interrupts_timing.html` | IRQ/NMI, Raster-IRQ, CIA-Timer, stabile Interrupts |
| 08 | `stufe_08_optimierung.html` | Cycle Counting, Zero Page, unrolled Loops, LUT-Tricks |
| 09 | `stufe_09_demo_effekte.html` | Rasterbars, Scroller, Plasma, Open Border & Vollbild-Effekte |
| 10 | `stufe_10_meisterschaft.html` | Spielarchitektur, Sprite-Multiplexer, Tilemap, Disk-I/O |
| 11 | `stufe_11_spielentwicklung_workflow.html` | Spielentwicklung von A–Z: GDD, Asset-Pipeline, Release |
| 12 | `stufe_12_demo_entwicklung_workflow.html` | Demo-Entwicklung von A–Z: Musik-Sync, Parts, D64-Release |
| 13 | `stufe_13_hardware_erweiterungen.html` | REU 1750 DMA, EasyFlash, Userport, VIC-II Banking |
| 14 | `stufe_14_modern_workflow.html` | VS Code, Makefile, Exomizer, GitHub Actions CI/CD |
| 15 | `stufe_15_debugging_deep_dive.html` | VICE-Monitor, Badlines, CPU-Profiling, Stack-Overflow |

### 8 Referenz-Anhänge (A–H)

| Anhang | Datei | Inhalt |
|--------|-------|--------|
| A | `anhang_opcodes.html` | Vollständige 6510-Opcode-Tabelle (filter- & sortierbar) |
| B | `anhang_speicherkarte.html` | C64-Speicherkarte $0000–$FFFF mit Erklärungen |
| C | `anhang_vic_register.html` | Alle VIC-II-Register $D000–$D02E mit Bit-Diagrammen |
| D | `anhang_sid_register.html` | SID-Register $D400–$D41C + vollständige Notenfrequenztabelle |
| E | `anhang_cia_register.html` | CIA1/CIA2 komplett + Tastaturmatrix-Diagramm |
| F | `anhang_petscii.html` | PETSCII-Tabelle (Codes 0–255) mit C64-Zeichendarstellung |
| G | `anhang_farben.html` | C64-Farbpalette mit RGB-Werten und Farbkombinations-Tipps |
| H | `anhang_kernal_routinen.html` | KERNAL-Jump-Tabelle $FF81–$FFF3, Zero-Page-Variablen, 5 Code-Beispiele |

---

## Schnellstart

```bash
# Repository klonen
git clone https://github.com/Trigiton7779/c64_kurs.git
cd c64_kurs

# Einfach im Browser öffnen — kein Server nötig
xdg-open index.html        # Linux
open index.html            # macOS
start index.html           # Windows
```

Die Dateien funktionieren direkt als `file://`-URLs. Für die Code-Beispiele wird [ACME Assembler](https://sourceforge.net/projects/acme-crossass/) und [VICE Emulator](https://vice-emu.sourceforge.io/) empfohlen.

---

## Beispiel-Dateien

Alle Codeblöcke aus den Lernstufen sind als fertige ACME-Quelldateien extrahiert:

```
beispiele/
├── index.html          ← Übersicht aller Beispiele (im Browser öffnen)
├── stufe_00/           ← 5 .asm-Dateien (Setup, erstes Programm)
├── stufe_01/           ← Assembler-Grundlagen
│   ...
├── stufe_09/           ← 23 .asm-Dateien (Demo-Effekte inkl. Open Border)
├── stufe_15/           ← Debugging-Beispiele
└── ...                 ← 165 .asm-Dateien gesamt
```

Neue Quelldateien aus den HTML-Dateien extrahieren:

```bash
python3 tools/extract_examples.py
```

---

## VICE-Konfiguration

Die Datei `vice.vicerc` enthält empfohlene VICE-Einstellungen (PAL, reSID, True Drive Emulation, Tastatur-Joystick). Einfach in das VICE-Konfigurationsverzeichnis kopieren:

```bash
# Linux / macOS
cp vice.vicerc ~/.config/vice/vicerc

# Oder gezielt für eine Session
x64sc -config vice.vicerc meinprogramm.prg
```

---

## Technischer Aufbau

```
C64_Kurs/
├── index.html                          ← Einstiegsseite & Curriculum-Übersicht
├── stufe_00_fundament.html             ┐
│   ...                                 │ 16 Lernstufen
├── stufe_15_debugging_deep_dive.html   ┘
├── anhang_opcodes.html                 ┐
│   ...                                 │ 8 Referenz-Anhänge
├── anhang_kernal_routinen.html         ┘
├── assets/
│   ├── c64-base.css                    ← Gemeinsames Layout & Typografie
│   ├── c64-interactive.css             ← Dark Mode, Copy-Buttons, Mobile
│   ├── c64-interactive.js              ← Interaktivität (Benchmark-Checkboxen, Suche)
│   └── c64-print.css                   ← Print-Stylesheet für Referenzseiten
├── beispiele/
│   ├── index.html                      ← Beispiel-Übersicht
│   └── stufe_XX/                       ← .asm-Quelldateien je Stufe
├── tools/
│   └── extract_examples.py             ← Extrahiert Codeblöcke aus HTML
└── vice.vicerc                         ← VICE-Emulator-Konfiguration
```

### Features der HTML-Dateien
- **Dark Mode** — Toggle in der Sidebar, speichert Präferenz im `localStorage`
- **Copy-Buttons** — Jeder Codeblock hat einen Kopieren-Button
- **Benchmark-Checkboxen** — Lernfortschritt wird pro Stufe im `localStorage` gespeichert
- **Responsive** — Hamburger-Menü auf Mobilgeräten
- **Print-freundlich** — Anhänge lassen sich als Cheat-Sheet ausdrucken
- **Filterbare Tabellen** — Opcode-Referenz (Anhang A) ist live filterbar und sortierbar

---

## Voraussetzungen & Werkzeuge

| Werkzeug | Zweck | Download |
|----------|-------|---------|
| VICE x64sc | C64-Emulator (cycle-exact, PAL) | [vice-emu.sourceforge.io](https://vice-emu.sourceforge.io/) |
| ACME | Cross-Assembler für 6510 | [acme-crossass.sourceforge.net](https://sourceforge.net/projects/acme-crossass/) |
| SpritePad | Sprite-Editor | [subchristsoftware.com](https://subchristsoftware.com/spritepad/) |
| CharPad | Charset-/Tileset-Editor | [subchristsoftware.com](https://subchristsoftware.com/charpad/) |
| GoatTracker | SID-Musikeditor | [cadaver.github.io](https://cadaver.github.io/goattrk2.html) |
| Exomizer | Datenkompression für PRG-Dateien | [bitbucket.org/magli143/exomizer](https://bitbucket.org/magli143/exomizer/) |

---

## Lernpfad

```
Anfänger        Stufen 00–03    Grundlagen, VIC-II, erster Charset
Fortgeschritten Stufen 04–07    Sprites, SID, IRQ, Timing
Experte         Stufen 08–10    Optimierung, Demo-Effekte, Spieleprogrammierung
Profi           Stufen 11–12    Vollständige Spiel- und Demo-Workflows
Spezialist      Stufen 13–15    Hardware-Erweiterungen, CI/CD, Deep Debugging
Referenz        Anhänge A–H     Opcode-Tabelle, Register, PETSCII, KERNAL
```

Geschätzter Zeitaufwand: **~140 Stunden** für den vollständigen Durchgang.
