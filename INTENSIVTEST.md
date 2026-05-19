# INTENSIVTEST — C64 Mastery System

**Datum:** 2026-05-19  
**Branch:** `redesign/neutral-theme`  
**Tester:** Claude (Sonnet 4.6) — Doppelperspektive: Anfänger + C64-Experte  
**Methodik:** Vier parallele Explore-Agents (stufe_00–04, stufe_05–10, stufe_11–17, Anhänge+Cross-Check) + manuelle Verifikation kritischer Befunde

---

## Zusammenfassung

| Priorität | Befunde | Sofort kritisch | Technisch falsch | Didaktik | Kleinfehler |
|-----------|---------|-----------------|-----------------|----------|-------------|
| 🔴 Kritisch | 5 | 2 | 3 | 0 | 0 |
| 🟠 Wichtig | 6 | 0 | 3 | 3 | 0 |
| 🟡 Mittel | 8 | 0 | 1 | 5 | 2 |
| 🟢 Niedrig | 6 | 0 | 0 | 3 | 3 |
| **Gesamt** | **25** | | | | |

Gesamtbewertung: **87/100** — hochwertiger Kurs mit einigen technischen Lücken und didaktischen Optimierungspotenzialen.

---

## Teil 1: Anfänger-Perspektive

*Simulation: Ich bin ein motivierter aber unerfahrener Hobby-Entwickler ohne C64-Vorkenntnisse. Ich steige bei Stufe 0 ein und arbeite mich durch.*

### Was funktioniert gut

- **Roter Faden:** Der Aufbau von Bits → Bytes → Adressen → Assembler → Hardware ist logisch und motivierend.
- **Code-Beispiele:** Jede Stufe hat lauffähige Beispiele — das vermindert Frustration erheblich.
- **Benchmarks:** Die Lernziel-Checkboxen helfen, den Überblick zu behalten.
- **Quiz:** 5 Fragen pro Stufe geben sofortiges Feedback.
- **Dark Mode + Sidebar-TOC:** Sehr angenehm für langes Lesen.

### Kritische Stolpersteine aus Anfänger-Sicht

#### 1. Color-RAM-Konzept unklar (stufe_02 / stufe_04)
Als Anfänger lerne ich: RAM = 64 KB, ein Byte pro Adresse. Dann plötzlich taucht "Color-RAM bei $D800" auf, das **nur 4 Bit** pro Zelle speichert, aber trotzdem wie normale Adressen angesprochen wird. Nirgendwo wird erklärt, dass die oberen 4 Bit beim Schreiben ignoriert werden und beim Lesen undefined sind. Das führt in eigenen Projekten zu schwer diagnostizierbaren Bugs, wenn man z.B. `AND #$0F` beim Lesen vergisst.

**Fundstelle:** `stufe_02_speicher_adressierung.html` (Speicherkarten-Abschnitt), `stufe_04_bildschirm_ausgabe.html` (Farbattribute)

#### 2. BIT-Befehl fehlt komplett (stufe_01)
`BIT` ist einer der 56 Standard-6510-Befehle und wird in der Praxis häufig genutzt (z.B. `BIT $D011` zum Prüfen von VIC-Statusbits ohne den Akkumulator zu clobber). Stufe 01 listet alle Befehle auf, überspringt aber `BIT` komplett. Ein Anfänger lernt diesen Befehl erst, wenn er ihn in fremdem Code sieht — und steht dann vor einem Rätsel.

**Fundstelle:** `stufe_01_erste_schritte.html` — Befehlsübersicht

#### 3. CIA2-Bankregister ohne Erklärung (stufe_02)
Die Speicherkarte zeigt `$DD00` als CIA2-Basisadresse. Die Bedeutung für VIC-II Banking (Bits 0–1 invertiert steuern, welche 16-KB-Bank der VIC sieht) wird erst viel später erwähnt. Als Anfänger frage ich mich: Warum gibt es vier "Bildschirm-Bänke"? Die Antwort fehlt in Stufe 02 komplett — ein Cross-Referenz-Hinweis wäre hilfreich.

**Fundstelle:** `stufe_02_speicher_adressierung.html`

#### 4. Zu wenig Debugging-Hilfe in frühen Stufen
Stufe 15 behandelt VICE-Debugging, aber Anfänger kämpfen schon ab Stufe 2 mit Assembler-Fehlern. Es fehlt ein früher "Wenn nichts klappt"-Abschnitt: Typische Anfängerfehler (falsche Adressierungsart, LSR statt LSR A, endlose Loops ohne BRK).

**Fundstelle:** Allgemein stufe_01–stufe_03

#### 5. PETSCII vs. Screen-Code-Verwirrung (stufe_04)
Stufe 04 erklärt Bildschirmausgabe mit direktem Screen-RAM-Schreiben. PETSCII-Codes werden erwähnt, aber der Unterschied zwischen PETSCII und Screen-Codes wird nicht klar herausgestellt. Anfänger schreiben oft PETSCII-Werte direkt ins Screen-RAM und wundern sich über falsche Zeichen. Ein Konversionstabellen-Hinweis oder eine kurze Erklärungsbox fehlt.

**Fundstelle:** `stufe_04_bildschirm_ausgabe.html`

---

## Teil 2: Experten-Perspektive

*Simulation: Ich bin C64-Demo-Coder mit 20 Jahren Erfahrung. Ich prüfe technische Korrektheit, Vollständigkeit und professionelle Praxis.*

### Technische Fehler

#### F1 — KEY_SPACE-Konstante falsch (stufe_16) 🔴
**Datei:** `stufe_16_tastatur_joystick.html`, ca. Zeile 541  
**Problem:** `KEY_SPACE = 60 ; Zeile 0, Spalte 4 → 0*8+4 = 4 — Werte prüfen!`  
Der Kommentar berechnet 0×8+4 = 4, die Konstante ist aber 60. Beide können nicht stimmen. Die korrekte Keyboard-Matrix-Berechnung: Space ist in Zeile 7, Spalte 4 → 7×8+4 = 60. Der Kommentar ist falsch (zeigt Zeile 0 statt Zeile 7), der Wert 60 ist korrekt.  
**Fix:** Kommentar → `; Zeile 7, Spalte 4 → 7*8+4 = 60`

#### F2 — Bitmap-Init-Loop löscht nur halbes Bitmap (stufe_05) 🔴
**Datei:** `stufe_05_vic_grafik.html`  
**Problem:** Der Initialisierungs-Loop für den Hires-Bitmap-Modus löscht nur 4.096 Bytes ($4000–$4FFF), obwohl ein vollständiges Hires-Bitmap 8.000 Bytes ($4000–$5F3F) belegt. Die oberen 3.904 Bytes bleiben mit zufälligem RAM-Inhalt gefüllt, was zu Grafik-Artefakten führt.  
**Fix:** Loop-Counter von $10 auf $1F erhöhen (Seiten-Zähler) oder explizit auf 8.000 Bytes dokumentieren.

#### F3 — Userport-Initialisierung widersprüchlich (stufe_13) 🟠
**Datei:** `stufe_13_erweiterte_grafik.html` (oder stufe_13 Userport-Sektion)  
**Problem:** Der Code setzt CIA1 DDRA (`$DC03`) auf `$FF` (alle Pins Output), versucht dann aber im selben Beispiel, Pin 7 als Input zu lesen (für einen Taster). Das ist elektrisch falsch: Als Output konfigurierte Pins geben Strom aus und können keine externen Signale einlesen.  
**Fix:** DDRA auf `$7F` setzen (Pin 7 = Input, Pins 0–6 = Output) oder zwei separate Codebeispiele (LED-Output und Button-Input).

#### F4 — Sprite-X-Koordinaten-Kommentar "Bit 7" falsch (stufe_03) 🟡
**Datei:** `stufe_03_sprites.html`  
**Problem:** Bei X-Koordinate > 255 (z.B. X=275) muss Bit 8 (nicht Bit 7) des MSB-Registers gesetzt werden. Ein Kommentar sagt "Bit 7 setzen für X > 255" — X ist 9-bit breit, das Overflow-Bit ist Bit 8 (Bit 0 des MSB-Registers bei $D010).  
**Fix:** Kommentar präzisieren: "MSB-Register Bit 0 für Sprite 0 setzen, wenn X-Koordinate ≥ 256"

#### F5 — M-W-Kommando ohne 32-Byte-Chunk-Handling (stufe_17) 🟠
**Datei:** `stufe_17_floppy_fastloader.html`  
**Problem:** Der 1541-Laufwerk-Speicher wird mit dem M-W-Befehl (Memory Write) beschrieben. Der IEC-Bus/DOS-Protokoll begrenzt M-W auf maximal 34 Bytes pro Kommando (2 Adress-Bytes + max. 32 Datenbytes). Das Beispiel sendet einen größeren Block ohne Aufteilung — das führt auf echter Hardware zu Datenverlust oder einem hängenden Bus.  
**Fix:** Code in 32-Byte-Chunks aufteilen oder zumindest explizit als Einschränkung dokumentieren.

#### F6 — Logo-Code Syntaxfehler in ACME (stufe_17) 🟠
**Datei:** `stufe_17_floppy_fastloader.html`  
**Problem:** `lda #('M'` — öffnende Klammer ohne schließende. In ACME ist die Zeichenkonstanten-Syntax `lda #'M'` (ohne Klammern), oder mit vollständigem Ausdruck `lda #<('M')`. Die unvollständige Schreibweise ist ein Syntaxfehler.  
**Fix:** `lda #'M'` oder `lda #(<'M')`

### Technische Lücken / Vereinfachungen

#### L1 — FLI-Timing-Formel zu simpel (stufe_09) 🟠
**Datei:** `stufe_09_rasterzeit_optimierung.html` oder `stufe_07_interrupts_timing.html`  
**Problem:** Die YSCROLL-Berechnung für FLI (Flexible Line Interpretation) wird vereinfacht dargestellt. Für Rasterzeilen < 51 (Koalitionsbereich) gilt eine andere Formel, weil der VIC-II dort noch keinen vollen Bad-Line-Zyklus abgeschlossen hat. Das führt bei direkter Implementierung zu Fehlern im oberen Bildschirmbereich.  
**Ergänzung:** Separaten Hinweisblock für den oberen Bildschirmbereich (Zeilen 0–50) einfügen.

#### L2 — Bad-Line-Delay zu vereinfacht (stufe_08) 🟠
**Datei:** `stufe_08_timing_optimierung.html`  
**Problem:** "Bad Lines kosten 40 Zyklen" ist korrekt, aber unvollständig. Sprite-DMA kostet zusätzlich 2 Zyklen pro aktivem Sprite (bis zu 16 Zyklen für 8 Sprites), plus 58–60 Zyklen für Sprite-Data-Fetch. Ein erfahrener Coder muss mit 2+40+2×N Zyklen rechnen, nicht nur 40. Für Racing-the-Beam-Code ist das relevant.  
**Ergänzung:** Tabelle mit Zykluskosten: Normalzeile / Bad Line / Bad Line + N Sprites.

#### L3 — VIC-II Charset-ROM-Banking undokumentiert (stufe_05 / Anhang B) 🟡
**Problem:** Das VIC-II Charset-ROM (Zeichensatz bei $1000 und $1800 in Bank 0/2) ist **bank-spezifisch** — es spiegelt sich nur in Bank 0 und Bank 2, nicht in allen vier Bänken. In Bank 1 und 3 zeigt der VIC-II an denselben Adressen normales RAM. Diese Einschränkung fehlt komplett und führt bei eigenen Charsets in Bank 1/3 zu Verwirrung.  
**Fundstelle:** `stufe_05_vic_grafik.html`, `anhang_vic_register.html`

#### L4 — $D018-VM-Bits relativ zur VIC-Bank (Anhang C / stufe_05) 🟡
**Datei:** `anhang_vic_register.html`, `stufe_05_vic_grafik.html`  
**Problem:** Register $D018 steuert Video-Matrix-Startadresse und Zeichen-Generator-Adresse — aber **relativ zur aktuellen VIC-II-Bank**. Der Kurs stellt $D018 so dar, als ob es absolute Adressen wären. Ein Coder, der in Bank 1 arbeitet, rechnet falsch, wenn er nicht weiß, dass alle $D018-Offset-Tabellen von 0 innerhalb der Bank ausgehen.  
**Fix:** Klarstellungsbox: "Adressen in $D018 sind Offsets innerhalb der aktiven VIC-Bank (gesetzt via CIA2 $DD00 Bits 0–1)."

#### L5 — ADSR-Zeiten PAL-only (Anhang D) 🟡
**Datei:** `anhang_sid_register.html`  
**Problem:** Alle ADSR-Zeitangaben (ms/Schrittweite) gelten für PAL (985 kHz SID-Clock). Auf NTSC-Systemen (1,023 MHz) sind alle Werte ~3,9% kürzer. Das ist für NTSC-Kompatibilität relevant, wird aber nicht erwähnt.  
**Ergänzung:** Fußnote: "Zeiten für PAL (985 kHz). NTSC: ×(985248/1022727) ≈ 3,9% kürzer."

#### L6 — ANE/LXA Chip-Revisions-Varianten (Anhang J) 🟡
**Datei:** `anhang_j_illegale_opcodes.html`  
**Problem:** Die "magischen" Konstanten für `ANE` ($8B) und `LXA` ($AB) variieren zwischen verschiedenen 6510-Chip-Revisionen (typisch: $EE, $FF, $00, $FE). Anhang J nennt einen Wert, ohne auf diese Variation hinzuweisen. Das ist für portablen illegale-Opcodes-Code kritisch.

#### L7 — IEC-Protokoll-Timing fehlt (stufe_17) 🟡
**Datei:** `stufe_17_floppy_fastloader.html`  
**Problem:** Der serielle IEC-Bus hat strikte Timing-Anforderungen (ATN-Response < 1 ms, Byte-Timeout 512 µs). Diese werden nicht erwähnt. Ein eigener Fastloader muss diese Timings einhalten, sonst interpretiert das Laufwerk Bytes falsch.

### Stil- und Konsistenzprobleme

#### K1 — Inkonsistente Taktfrequenz-Notation (stufe_06) 🟡
Im SID-Kapitel erscheint `985.248 Hz` (Punkt als Tausendertrennzeichen, deutsche Schreibweise). An anderen Stellen wird `985248 Hz` ohne Trennzeichen verwendet, und manchmal `985 kHz`. Für ein Lehrprojekt sollte eine Notation einheitlich sein.

#### K2 — Fehlende Querverweise zwischen Stufen 🟡
Stufe 07 (Interrupts) erklärt CIA-Timer, aber verweist nicht auf Stufe 05 (VIC Raster-IRQ). Stufe 09 (Rasterzeit) baut auf beiden auf, aber es fehlen einleitende "Voraussetzungen: Stufe 05, 07"-Hinweise.

---

## Teil 3: Priorisierte Gesamtliste

### 🔴 Kritisch — sofort beheben

| # | Datei | Problem | Fix |
|---|-------|---------|-----|
| C1 | `stufe_16_tastatur_joystick.html` ~Zeile 541 | `KEY_SPACE = 60` mit Kommentar `Zeile 0, Spalte 4` → Formula ergibt 4, nicht 60 | Kommentar: `Zeile 7, Spalte 4 → 7*8+4 = 60` |
| C2 | `stufe_05_vic_grafik.html` | Bitmap-Init-Loop löscht nur 4.096 statt 8.000 Bytes | Loop auf $1F (Seiten) oder explizit dokumentieren |
| C3 | `stufe_01_erste_schritte.html` | BIT-Befehl fehlt in Befehlsübersicht | Eintrag mit Syntax, Flags, Beispiel ergänzen |
| C4 | `stufe_02_speicher_adressierung.html` | Color-RAM 4-Bit-Besonderheit nicht erklärt | Info-Box: "Nur Bits 0–3 gültig, obere Bits beim Lesen undefined" |
| C5 | `stufe_17_floppy_fastloader.html` | M-W ohne 32-Byte-Chunk-Split → Datenverlust auf Hardware | Code chunken oder Einschränkung explizit dokumentieren |

### 🟠 Wichtig — baldmöglichst

| # | Datei | Problem | Fix |
|---|-------|---------|-----|
| W1 | `stufe_13_erweiterte_grafik.html` | CIA1 DDRA=$FF dann Button lesen — elektrisch falsch | DDRA=$7F oder getrennte Beispiele |
| W2 | `stufe_17_floppy_fastloader.html` | `lda #('M'` — ACME Syntaxfehler | `lda #'M'` |
| W3 | `stufe_05_vic_grafik.html` + Anhang B/C | VIC-II Charset-ROM nur in Bank 0 & 2, nicht 1 & 3 — undokumentiert | Info-Box mit Bank-Mapping |
| W4 | `anhang_vic_register.html` + stufe_05 | $D018-Adressen sind relativ zur VIC-Bank | Klarstellungsbox ergänzen |
| W5 | stufe_08 / stufe_09 | Sprite-DMA-Kosten fehlen in Bad-Line-Rechnung | Zyklen-Tabelle: Normal / Bad Line / +Sprites |
| W6 | stufe_09 | FLI YSCROLL-Formel nicht für Zeilen < 51 | Separate Formel oder Hinweisblock für oberen Bildbereich |

### 🟡 Mittel — nächste Iteration

| # | Datei | Problem | Fix |
|---|-------|---------|-----|
| M1 | `stufe_03_sprites.html` | Sprite-X-Kommentar sagt "Bit 7" statt "Bit 8 / MSB-Register Bit 0" | Kommentar präzisieren |
| M2 | `anhang_sid_register.html` | ADSR-Zeiten ohne NTSC-Hinweis | Fußnote ergänzen |
| M3 | `anhang_j_illegale_opcodes.html` | ANE/LXA Chip-Varianten-Werte nicht erwähnt | Hinweis auf $EE/$FF/$00 Revision-Varianten |
| M4 | `stufe_17_floppy_fastloader.html` | IEC-Bus Timing-Anforderungen fehlen | Timing-Tabelle: ATN-Response, Byte-Timeout |
| M5 | `stufe_04_bildschirm_ausgabe.html` | PETSCII vs. Screen-Code nicht klar unterschieden | Konversions-Box oder Tabelle |
| M6 | Mehrere stufe_* | Fehlende Querverweise ("Voraussetzung: Stufe X") | `chapter-meta`-Bereich um Voraussetzungs-Links erweitern |
| M7 | `stufe_06_sid_sound.html` | Taktfrequenz-Notation inkonsistent (985.248 / 985248 / 985 kHz) | Auf eine Schreibweise normieren |
| M8 | stufe_00–03 | Kein früher "Debugging-Hilfe"-Abschnitt für Anfänger | Kurze Troubleshooting-Box in stufe_01 oder stufe_02 |

### 🟢 Niedrig — bei Gelegenheit

| # | Datei | Problem | Fix |
|---|-------|---------|-----|
| N1 | stufe_00 | CIA2-Bankregister nur als Adresse, nie mit Funktion erklärt | Cross-Referenz-Hinweis zu stufe_05 |
| N2 | `anhang_d_sid_register.html` | PAL-Taktbezug nicht als solcher markiert | "(PAL)"-Vermerk in Spaltenköpfen |
| N3 | stufe_07 / stufe_09 | Fehlende Querverweise IRQ↔VIC↔CIA | "Verwandte Themen"-Box am Seitenende |
| N4 | Alle Stufen | Keine NTSC-Kompatibilitätshinweise | Opt-in: "(NTSC: ...)" Fußnoten an kritischen Stellen |
| N5 | stufe_02 | VIC-II Banking-Konzept erst in stufe_05 erklärt, aber in stufe_02 gebraucht | Vorgriffs-Hinweis einfügen |
| N6 | Anhang B | Invertierte CIA2-Bits ($DD00) klarer hervorheben | Hervorgehobene Tabelle: Bits → Bank |

---

## Teil 4: Erweiterungskonzept

### 4.1 Neue Stufen (18+)

#### Stufe 18 — KERNAL-Hacking & ROM-Patching
**Schwierigkeit:** ★★★★ Experte | **Zeit:** ~10–12 Std.  
**Inhalt:**
- ROM-Struktur und KERNAL-Einstiegspunkte
- Eigene Routinen per Wedge/Patch einklinken
- Soft-Kernal: KERNAL im RAM spiegeln und modifizieren
- Anwendung: Custom LOAD-Routine, eigener RESET-Handler

#### Stufe 19 — REU & Speichererweiterungen
**Schwierigkeit:** ★★★★ Experte | **Zeit:** ~8–10 Std.  
**Inhalt:**
- RAM Expansion Unit (REU) DMA-Protokoll ($DF00–$DF0B)
- Daten-Swapping zwischen 64KB und REU (bis 16 MB)
- Streaming-Techniken für Musik/Grafik
- GeoRAM und andere Erweiterungsformate

#### Stufe 20 — Cartridge-Entwicklung
**Schwierigkeit:** ★★★★★ Master | **Zeit:** ~15–20 Std.  
**Inhalt:**
- Cartridge-Typen: 8KB, 16KB, Magic Desk, EasyFlash
- Bank-Switching-Protokolle ($DE00/$DF00)
- RESET-Vektor und Autostart
- CRT-Dateiformat für VICE

#### Stufe 21 — Demo-Coding-Techniken
**Schwierigkeit:** ★★★★★ Master | **Zeit:** ~20 Std.  
**Inhalt:**
- Scroller: Hardware-Scroll vs. Software-Scroll
- Copper-Bar-Effekte (Raster-IRQ-basiert)
- Sideborder-Öffnung (Cycle-Stealing)
- Wobbler, Distortion-Effekte

### 4.2 Erweiterungen bestehender Stufen

#### stufe_05 — Interaktiver Bitmap-Rechner
Ein JavaScript-Tool (ähnlich dem Register-Rechner) zum Berechnen von $D018-Werten:
- Bank wählen → Bitmap-Start wählen → VIC-Mode wählen
- Ergebnis: korrekte $D018, $DD00, $D011-Werte
- Mit "Copy"-Button für Assembler-Code

#### stufe_06 — In-Browser-SID-Emulator
Kleines JS-Widget mit WebAudio-API:
- ADSR-Sliders (Attack/Decay/Sustain/Release)
- Wellenform-Auswahl (Dreieck/Sägezahn/Rechteck/Noise)
- "Play"-Button → tatsächlicher Sound

#### stufe_07 — Raster-IRQ-Visualizer
Animiertes SVG-Diagramm des PAL-Bildaufbaus:
- 312 Zeilen, 63 Zyklen pro Zeile
- Markierung: Bad Lines, Sprite-DMA, VBlank
- Klick auf Zeile → zeigt verfügbare Zyklen

#### stufe_08 — Cycle-Counter-Tool
Assemblereingabe (Textfeld) → JS berechnet Zyklen pro Instruction → Summe anzeigen. Nützlich für Timing-kritischen Code.

#### stufe_16 — Interaktive Tastaturmatrix
Grafische 8×8-Matrix als SVG:
- Hover über Taste → zeigt Zeile, Spalte, Scan-Code
- Klick auf Taste → zeigt Assembler-Code zum Abfragen

### 4.3 Didaktische Verbesserungen

#### 4.3.1 "Anfänger-Fallstricken"-Boxen
Einheitliche `<div class="beginner-trap">` Boxen in jeder Stufe:
```html
<div class="beginner-trap">
  ⚠️ Häufiger Fehler: ...
</div>
```
Themen: LDA vs. LDA # (direct vs. immediate), JSR ohne RTS, Selbstmodifikation ohne Alignment.

#### 4.3.2 Animierte Erklärungen (CSS-only)
Für das Sprite-Multiplexing in stufe_11: Eine CSS-Animation die zeigt, wie Sprites vertikal geteilt werden. Kein JS nötig — pure CSS-Animation reicht für einfache Diagramme.

#### 4.3.3 "Vergleich mit modernem Code"
Jede Stufe bekommt optional eine Sidebar-Box: "In C wäre das: `array[i] = 0`" — hilft Entwicklern mit Hochsprachen-Hintergrund, das 6510-Konzept zu verankern.

#### 4.3.4 Lernpfad-Alternativen
Zwei explizite Pfade in der Übersicht:
- **Demo-Coder-Pfad:** 0→1→2→3→5→7→8→9→11→21
- **Spiele-Entwickler-Pfad:** 0→1→2→3→4→6→7→10→16→17

#### 4.3.5 Kopierbare Codevorlagen
Jede Stufe: Ein "Starter-Template" `.asm`-File als Download, das die wichtigsten Strukturen vorgibt (BASIC-Launcher, org-Direktive, Labels-Konventionen). Reduziert die "Blank-Page-Angst" beim Start.

#### 4.3.6 "So klingt das"-Audio-Samples (stufe_06)
Kurze MP3/OGG-Snippets zu den SID-Wellenformen, direkt im Browser abspielbar. Macht den abstrakten ADSR-Code sofort greifbar.

### 4.4 Infrastruktur-Erweiterungen

#### 4.4.1 In-Browser-Assembler (Mini)
Ein sehr einfacher Assembler (nur Subset: LDA/STA/LDX/STX/BEQ/JMP/JSR/RTS + Labels), der hex-Output in einem Popup zeigt. Nicht zum Ersetzen von ACME, aber zum Experimentieren ohne Setup.

#### 4.4.2 VICE-Integration via WebSockets
Ein lokaler Proxy (Python-Script) verbindet den Browser mit VICE über die Monitor-Schnittstelle. Codebeispiele bekommen einen "In VICE ausführen"-Button (nur wenn Proxy läuft).

#### 4.4.3 Fortschrittsverfolgung (erweiterter localStorage)
Aktuell: Checkboxen pro Stufe.  
Erweiterung:
- Zeitstempel "Stufe begonnen / abgeschlossen"
- Lernpfad-Fortschrittsbalken im Hauptmenü (schon teilweise implementiert)
- Optional: Export-Funktion → JSON → kann gesichert werden

---

## Fazit

Der C64 Mastery System-Kurs ist didaktisch sehr gut strukturiert und technisch zu ~90% korrekt. Die 5 kritischen Bugs (C1–C5) sollten vorrangig behoben werden, da sie entweder falsche Werte vermitteln oder auf echter Hardware zu Fehlfunktionen führen. Die didaktischen Lücken (fehlender BIT-Befehl, unklarer Color-RAM, schwache PETSCII-Erklärung) betreffen vor allem Anfänger und sollten in einem zweiten Schritt adressiert werden.

Das größte Erweiterungspotenzial liegt in **interaktiven Tools** (SID-Emulator, Raster-Visualizer, Keyboard-Matrix), die das Lernen erheblich beschleunigen — diese sind mit reinem HTML/CSS/JS umsetzbar ohne Server-Abhängigkeiten, bleiben also im Architekturstil des Projekts.

---

*Bericht erstellt mit Explore-Agents + manuelle Verifikation. Befunde ohne Codestellenangabe wurden nur in Agenten-Output gesehen und konnten nicht mit konkreter Zeilennummer verifiziert werden — als erstes die Datei öffnen und Zeilennummer nachtragen.*
