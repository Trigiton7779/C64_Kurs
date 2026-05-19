# Testergebnisse — C64 Mastery System

Systematischer Test als Anwender. Stand: 2026-05-19  
Geprüft: 30 Root-HTML-Dateien, tools/register_rechner.html, assets/quiz-data.js, assets/search-index.json

---

## 🔴 Kritisch — Falsche technische Informationen

### 1. CIA-Timer-Wert falsch (stufe_07_interrupts_timing.html)

**Wo:** Kommentar und Code-Beispiel im Abschnitt „CIA1-Timer als IRQ-Quelle"

```asm
; PAL: 985248 Hz, 985248 / 50 = 19704,96 ≈ 19704 Zyklen = $4CC8   ← FALSCH
LDA #$C8        ; $4CC8 Low-Byte
```

**Fehler:** `19704 dezimal = $4CF8`, nicht `$4CC8`.  
Das ist ein Tippfehler im Hex: `F` wurde zu `C` — Low-Byte sollte `$F8` sein, nicht `$C8`.

**Korrekt:**
- 985248 ÷ 50 = 19704,96 → abgerundet 19704 = **$4CF8** oder gerundet 19705 = **$4CF9**
- $4CC8 = 19656 Zyklen → tatsächliche Frequenz: **50,12 Hz statt 50 Hz**

---

### 2. Quiz-Antwort falsch: CIA-Timer-Wert (assets/quiz-data.js, Stufe '07')

**Wo:** Frage 2 in `'07': [...]`

```js
options: ['A) $EA60 (60000)', 'B) $4CC9 (19657)', 'C) $2710 (10000)', 'D) $9C40 (40000)'],
correct: 1,
explanation: '985248 ÷ 50 = 19704,96 ≈ 19705. Hexadezimal: $4CC9. ...'
```

**Fehler:** Option B wird als richtig markiert, ist aber doppelt falsch:
- `$4CC9 = 19657` — nicht 19705 wie die Erklärung behauptet
- Der korrekte Hex-Wert für 19705 ist **$4CF9**, nicht $4CC9
- Der korrekte Wert für 19704 ist **$4CF8**

---

### 3. SID-Frequenzbeispiele falsch (stufe_06_sid_sound.html)

**Wo:** Inline-Berechnungen zu Beginn des Abschnitts „Frequenzsteuerung"

| Note | Datei (falsch) | Korrekt berechnet | Differenz |
|------|---------------|-------------------|-----------|
| C4 (261,63 Hz) | 4452 = $1164 | **4455 = $1167** | −3 |
| A4 (440,00 Hz) | 7484 = $1D3C | **7493 = $1D45** | −9 |
| C5 (523,25 Hz) | 8905 = $22C9 | **8910 = $22CE** | −5 |

Formel: `f_reg = note_hz × 16777216 / 985248`

Die falschen Werte stehen sowohl im Kommentar als auch im Code-Beispiel (`LDA #$64 / $11` für $1164).

---

### 4. CPY-Eintrag in Opcode-Tabelle defekt (anhang_opcodes.html, Zeile 346)

**Wo:** JavaScript-Daten-Array `OPCODES` in `anhang_opcodes.html`

```js
// CPX korrekt (7 Felder):
["ARITH","CPX","Abs","$EC",3,"4","* - - - - - * *","Vergleiche X absolut"],

// CPY defekt (6 Felder — "Abs" fehlt):
["ARITH","CPY","$CC",3,"4","* - - - - - * *","Vergleiche Y absolut"],
```

**Folge:** Die Tabellen-Rendering-Logik interpretiert `"$CC"` als Adressierungsart statt als Opcode. Bytes, Zyklen und Flags sind alle um eine Spalte verschoben.

**Fix:** `"Abs"` als drittes Feld einfügen:
```js
["ARITH","CPY","Abs","$CC",3,"4","* - - - - - * *","Vergleiche Y absolut"],
```

---

## 🟠 Wichtig — Fehlende Inhalte in index.html

### 5. Stufe 16 & 17 fehlen im Übersichts-Grid

**Wo:** `index.html` — Stufen-Karten-Grid

Das Grid enthält Karten für Stufe 0–15, dann endet es abrupt. **Stufe 16 (Tastatur & Joystick)** und **Stufe 17 (Floppy & Fastloader)** haben keine Karte. Ein Nutzer der die Übersichtsseite besucht sieht diese beiden Stufen nicht.

---

### 6. Zeitplanung-Tabelle endet bei Stufe 10

**Wo:** `index.html` — Abschnitt „Zeitplanung und Lernempfehlungen"

Die Tabelle hat Einträge für Stufen 0–10 (Meisterschaft) und endet dann. **Stufen 11–17 fehlen vollständig** — kein Zeitaufwand, kein Schwierigkeitsgrad, keine Voraussetzungen angegeben.

---

### 7. Lernpfad-Diagramm zeigt nur Phasen 1–3 (Stufen 0–10)

**Wo:** `index.html` — ASCII-Diagramm im Abschnitt „Lernpfad und Phasen-Struktur"

Das Diagramm zeigt:
```
PHASE 1: GRUNDLAGEN (Stufen 0–2)
PHASE 2: GRAFIK & SOUND (3–6)
PHASE 3: FORTGESCHRITTEN (7–10)
```

Stufen 11–17 (Workflow, Debugging, Tastatur, Floppy) fehlen im Diagramm und in den darauffolgenden `phase-block` Texten.

---

### 8. Frequenztabelle mit Platzhalter-Werten (stufe_06_sid_sound.html)

**Wo:** Assembler-Code `NoteTabHi`, Oktave 4

```asm
!byte $11,$13,$16,$18,$1b,$1e,$22,$26,$2b,$30,$35,$3b  ; (Beispielwerte)
```

Der Kommentar `(Beispielwerte)` signalisiert dass dies Platzhalter sind. Die restlichen Oktaven (1–3, 5–6) haben keinen solchen Hinweis. Die Werte für Oktave 4 müssten mit der korrekten Formel neu berechnet werden.

---

## 🟡 Mittel — Inkonsistenzen und Darstellungsfehler

### 9. PAL-Frequenz im Hardware-Diagramm falsch (stufe_00_fundament.html)

**Wo:** ASCII-Chip-Diagramm am Anfang der Seite

```
║   1.023 MHz PAL  ║   16 KB Zugriff  ║   3 Stimmen Synthese   ║
```

**Fehler:** 1,023 MHz ist der **NTSC**-Wert. PAL läuft mit **0,985 MHz**.  
Der Fließtext darunter ist korrekt: *„Die Taktfrequenz beträgt exakt 0,985 MHz im PAL-Betrieb."*  
Nur das Diagramm hat den falschen Wert.

---

### 10. Inkonsistentes Titel-Format (alle stufe_*.html)

Drei verschiedene Formate werden verwendet:

| Seiten | Format | Beispiel |
|--------|--------|---------|
| stufe_00–02 | `Stufe X — Thema \| C64 Mastery System` | `Stufe 0 — Das Fundament \| C64 Mastery System` |
| stufe_03–17 | `C64 Mastery — Stufe X: Thema` | `C64 Mastery — Stufe 3: VIC-II & Zeichenmodus` |
| stufe_08 | — | `C64 Mastery — Stufe 8: Optimierung & Profitechniken` (kein `&amp;`) |

Ein einheitliches Format sollte durchgehend verwendet werden.

---

### 11. Inkonsistente Anhang-Titel (anhang_*.html)

| Format | Seiten |
|--------|--------|
| `C64 Mastery — Anhang: Thema` | Anhänge A–H (8 Seiten) |
| `C64 Mastery — Anhang I: ACME Assembler Referenz` | Anhang I |
| `C64 Mastery — Anhang J: Illegale Opcodes` | Anhang J |

Nur I und J haben den Buchstaben im Titel. A–H sollten entweder auch den Buchstaben bekommen oder I+J ohne Buchstaben bleiben.

---

### 12. Stufe 10 hat keine Übungs-Sektion

**Wo:** `stufe_10_meisterschaft.html`

Alle anderen Stufen (01–09, 11–17) haben am Ende eine Übungs-Sektion. Stufe 10 hat stattdessen ein vollständiges Mini-Spiel (`STARBLASTER`) als Kapitelabschluss. Das könnte bewusst so sein — sollte aber zumindest eine kurze Übungsaufgaben-Box am Ende haben, damit die Konsistenz gewahrt bleibt.

---

## 🟢 Niedrig — Strukturelle Altlasten (stufe_00–07)

### 13. Lernziele: class="objectives" vs. class="learning-objectives"

- stufe_00–07: `<section class="objectives">` (altes Format)
- stufe_08–17: `<section class="learning-objectives">` (neues Format)

Funktioniert visuell, aber CSS-Regeln für `.learning-objectives` (in c64-interactive.css Dark Mode) gelten nicht für alte Seiten.

### 14. Übungsbereich: `<div>` vs. `<section>`

- stufe_00–07: `<div class="exercises-section">`
- stufe_08–17: `<section class="exercises">`

Semantisch inkorrekt für die alten Seiten — kein funktionaler Fehler.

### 15. Keine Navigation zwischen Anhang-Seiten

Keiner der 10 Anhänge hat eine `chapter-nav`-Zeile. Ein Nutzer der z.B. Anhang C (VIC-II Register) liest, kann nicht per Klick zu Anhang D (SID Register) wechseln — er muss über die Sidebar navigieren.

---

## Zusammenfassung

| Priorität | Anzahl | Beschreibung |
|-----------|--------|-------------|
| 🔴 Kritisch | 4 | Falsche technische Werte (Timer, SID, Opcode-Tabelle) |
| 🟠 Wichtig | 4 | Fehlende Inhalte in index.html, Platzhalter in Frequenztabelle |
| 🟡 Mittel | 4 | Inkonsistenzen Titel, PAL-Diagramm, fehlende Übungen in Stufe 10 |
| 🟢 Niedrig | 3 | Altlast-Strukturen aus altem HTML-Format |

**Keine kaputten Links gefunden.**  
**Alle chapter-nav Ketten korrekt (stufe_00 → stufe_01 → … → stufe_17).**  
**Alle Asset-Dateien vorhanden und korrekt eingebunden.**
