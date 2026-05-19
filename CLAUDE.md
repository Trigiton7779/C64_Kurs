# CLAUDE.md — C64 Mastery System

Statische HTML-Lernseite für C64 6510-Assembler-Programmierung.
Kein Server, kein Framework — reines HTML/CSS/Vanilla-JS.

## Aktueller Stand

**Branch:** `redesign/neutral-theme`  
**Seiten:** 30 HTML-Dateien im Root + `tools/register_rechner.html` + `beispiele/index.html`  
**Curriculum:** Stufe 00–17 + Anhänge A–J + Volltextsuche + Register-Rechner

## Dateistruktur

```
C64_Kurs/
├── index.html                          ← Übersicht & Lernpfad
├── stufe_00_fundament.html             ← Stufen 00–17
│   ...
├── stufe_17_floppy_fastloader.html
├── anhang_opcodes.html                 ← Anhänge A–J (alle 10)
│   ...
├── anhang_j_illegale_opcodes.html
├── suche.html                          ← Volltextsuche (client-side)
├── assets/
│   ├── c64-base.css                    ← Gemeinsame Styles (Farben, Layout, Komponenten)
│   ├── c64-interactive.css             ← Dark Mode, Copy-Buttons, Quiz, Scroll-Spy, Suche
│   ├── c64-interactive.js              ← Alle shared JS-Features (init-Funktionen)
│   ├── c64-print.css                   ← Print-Styles (nur bei Anhängen, media="print")
│   ├── c64-search.js                   ← Nur für suche.html: fetch + filter + render
│   ├── quiz-data.js                    ← 90 Quiz-Fragen (18 Stufen × 5)
│   ├── search-index.json               ← Generiert von tools/build_search_index.py
│   └── sidebar.js                      ← Generiert Sidebar dynamisch (Single Source of Truth)
├── tools/
│   ├── build_search_index.py           ← Erzeugt search-index.json (nach Content-Änderungen)
│   ├── extract_examples.py             ← Extrahiert <pre>-Blöcke → beispiele/stufe_XX/*.asm
│   ├── register_rechner.html           ← Register-Visualizer Tool (lädt ../assets/)
│   ├── apply_redesign.py               ← Einmalig genutzt — nicht erneut ausführen
│   └── migrate_all.py                  ← Einmalig genutzt — nicht erneut ausführen
├── beispiele/
│   ├── index.html                      ← Zeigt alle .asm-Dateien
│   └── stufe_00/ … stufe_17/           ← Extrahierte Code-Beispiele als .asm-Dateien
└── vice.vicerc                         ← VICE-Emulator-Konfiguration (als Download angeboten)
```

## HTML-Format (einheitlich seit sidebar.js-Migration)

Alle 31 HTML-Dateien (30 Root + tools/register_rechner.html) nutzen dasselbe Format:
- Sidebar: `<aside class="sidebar"></aside>` — **leerer Platzhalter**, wird von `sidebar.js` befüllt
- Ladereihenfolge: `c64-base.css` → seitenspezifischer `<style>` → `c64-interactive.css` → Inhalt → `sidebar.js` → `c64-interactive.js`
- **Ausnahme suche.html**: lädt zusätzlich `c64-search.js` *vor* `sidebar.js`
- **Alle Anhang-Seiten**: laden zusätzlich `c64-print.css` mit `media="print"` nach `c64-interactive.css`

### Was sidebar.js tut
- Erkennt aktuellen Dateinamen per `location.pathname` → setzt `class="active"` auf den passenden Link
- Erkennt `tools/`-Unterverzeichnis → verwendet `../`-Prefix für alle Pfade
- Generiert Auto-TOC aus `main > section[id]` (schließt `benchmark`, `exercises`, `learning-objectives` aus)
- Läuft **synchron** bei Script-Ausführung (nicht bei DOMContentLoaded), damit `.toc-link`-Elemente beim anschließenden Scroll-Spy-Init bereits im DOM sind

### Altes Format (stufe_00–07, index.html) — Altlast
- Enthält noch inline-CSS-Block (~60–150 Zeilen) mit alten `.sidebar nav ul li a`-Regeln
- Diese Regeln sind Dead Code (passen nicht auf neue Sidebar-Struktur) — harmlos, nicht löschen nötig
- `c64-base.css` wurde per Migration **hinzugefügt** (vor dem inline `<style>`)

## CSS-Variablen (c64-base.css)

```css
--c64-blue:    #1a3f80   /* Primärfarbe, Sidebar-Header, Buttons */
--c64-green:   #00cc66   /* Akzent, aktive Links, Code-Text */
--c64-dark:    #1a1a2e   /* Code-Hintergrund, Sidebar-Hintergrund */
--c64-darker:  #0d0d1a   /* Scrollbar-Track */
--paper:       #f8f6f0   /* Seitenhintergrund */
--paper-dark:  #ede9df   /* Zebra-Zeilen, Karten-Hintergrund */
--text:        #1a1a2e   /* Fließtext */
--text-light:  #444466   /* Sekundärer Text */
--theme-color: #1a3f80   /* Einheitlich für alle Seiten */
--theme-dark:  #0d1f40   /* Thead-Hintergrund, dunkle Akzente */
--theme-light: #00cc66   /* Alias für --c64-green */
```

Dark Mode: `body.dark-mode` in `c64-interactive.css` überschreibt alle relevanten Variablen.

## JS-Architektur

### sidebar.js — Sidebar-Generator
Generiert die komplette Sidebar-HTML synchron beim Laden. Muss **vor** `c64-interactive.js` stehen.

Interne Funktionen:
- `lnk(href, text)` — erzeugt `<a>` mit korrektem Pfad-Prefix und `class="active"` wenn nötig
- `lbl(text)` — erzeugt `<div class="section-label">`

### c64-interactive.js — Feature-Init

**Utility-Funktionen:**
- `stufeId()` — extrahiert Stufennummer aus URL: `stufe_07_...html` → `"07"` (String, null-padded). Gibt `null` zurück auf Nicht-Stufen-Seiten.
- `benchKey(stufe, idx)` — erzeugt localStorage-Key: `"c64_bench_07_3"`

**Init-Funktionen (alle aufgerufen aus `init()` via DOMContentLoaded):**

| Funktion | Wirkung |
|---|---|
| `initDarkMode()` | Injiziert `<button id="c64-dark-toggle">` in `<body>`, liest/schreibt `c64_dark_mode` |
| `initMobile()` | Injiziert `#c64-hamburger` + `#c64-overlay` für Sidebar bei < 900px |
| `initCopyButtons()` | Fügt Kopier-Button zu allen `<pre>` hinzu; blendet Inhalt > 22 Zeilen ein/aus |
| `initProgress()` | Injiziert Checkboxen in `.benchmark-list li` und `.skill-benchmark ul li` |
| `initIndexProgress()` | Zeichnet Fortschrittsbalken auf `.stufe-card`-Links auf index.html |
| `initScrollSpy()` | IntersectionObserver auf `.toc-link`-Elementen → setzt/entfernt `.toc-active` |
| `initSearchLink()` | **Fallback:** injiziert Suche-Links nur wenn kein `a[href$="suche.html"]` existiert |
| `loadQuizData(stufe, cb)` | Lädt `quiz-data.js` dynamisch per `<script>`-Tag, ruft dann `cb()` |
| `initQuiz()` | Findet `#benchmark`/`.benchmark`, fügt danach `<section id="c64-quiz">` ein |

**localStorage-Keys:**
- `c64_dark_mode` — `"1"` (dunkel) oder `"0"` (hell)
- `c64_bench_{stufe}_{idx}` — `"1"` oder `"0"` (z.B. `c64_bench_07_3`)
- `c64_quiz_{stufe}_score` — letzter Rohpunktestand
- `c64_quiz_{stufe}_best` — bester Rohpunktestand
- `c64_quiz_{stufe}_done` — `"1"` wenn Quiz je abgeschlossen

### quiz-data.js — Format

```js
var C64_QUIZ = {
  '07': [   // Key = stufeId()-Rückgabe: null-padded String "07", nicht 7
    {
      q: 'Fragetext',
      options: ['A) …', 'B) …', 'C) …', 'D) …'],
      correct: 1,         // 0-basierter Index der richtigen Antwort
      explanation: '…'    // Erklärung, erscheint nach Antwort
    },
    // … 4 weitere Fragen
  ],
  '00': […], '01': […], … '17': […]
};
```

18 Stufen × 5 Fragen = 90 Fragen insgesamt. Key muss exakt dem `stufeId()`-Rückgabewert entsprechen.

## Seitenstruktur (alle Dateien nach Migration)

```html
<!DOCTYPE html>
<html lang="de">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>C64 Mastery — Seitentitel</title>
  <link rel="stylesheet" href="assets/c64-base.css">
  <style>/* seitenspezifische Klassen — keine Layout/Farb-Overrides */</style>
  <link rel="stylesheet" href="assets/c64-interactive.css">
  <!-- Nur Anhang-Seiten: -->
  <link rel="stylesheet" href="assets/c64-print.css" media="print">
</head>
<body>

<aside class="sidebar"></aside>   ← Platzhalter, sidebar.js füllt ihn

<main>
  <header class="chapter-header">
    <div class="chapter-number">Stufe N — Kategorie</div>
    <h1>Titel</h1>
    <div class="chapter-meta"><span>★★ Schwierigkeit</span>…</div>
  </header>
  <section class="learning-objectives">…</section>
  <section id="abschnitt-id"><h2>N. Titel</h2>…</section>
  …
  <section id="benchmark" class="benchmark">
    <ul class="benchmark-list"><li>…</li></ul>
  </section>
  <!-- Quiz wird hier automatisch per JS eingefügt -->
  <section class="exercises">…</section>
  <nav class="chapter-nav">← Zurück | Weiter →</nav>
</main>
  <script src="assets/sidebar.js"></script>      ← vor c64-interactive.js!
  <script src="assets/c64-interactive.js"></script>
</body>
</html>
```

## Häufige Aufgaben

### Navigation updaten (neuer Link in Sidebar)
Nur `assets/sidebar.js` editieren — eine `lnk()`-Zeile einfügen:
```javascript
lnk('stufe_18_new_topic.html', '18 &middot; Neues Thema')
```
Kein Python-Script, keine 31 Dateien anfassen.

### Search-Index neu bauen (nach Content-Änderungen)
```bash
python3 tools/build_search_index.py
# → assets/search-index.json (aktuell ~211 Sektionen aus 29 Seiten)
```

### Code-Beispiele extrahieren
```bash
python3 tools/extract_examples.py
# → beispiele/stufe_XX/*.asm aus allen <pre>-Blöcken
```

### Neue Stufe hinzufügen
1. HTML-Datei erstellen — `stufe_17_floppy_fastloader.html` als Vorlage, Sidebar bleibt `<aside class="sidebar"></aside>`
2. `chapter-nav` in der vorherigen Stufe anpassen (Weiter-Link)
3. **`assets/sidebar.js`** — eine `lnk()`-Zeile in der richtigen Sektion ergänzen
4. **`assets/quiz-data.js`** — 5 Fragen unter dem neuen Stufen-Key ergänzen (null-padded String)
5. `python3 tools/build_search_index.py` ausführen
6. `python3 tools/extract_examples.py` ausführen

### Neue Anhang-Seite hinzufügen
Wie neue Stufe, aber:
- Dateiname: `anhang_X_name.html` (X = nächster Buchstabe)
- `c64-print.css` mit `media="print"` einbinden
- In `sidebar.js` in der Sektion "Anhänge & Referenz" einfügen
- Kein Quiz nötig

## Bekannte Quirks

- **Benchmark-Checkboxen in stufe_00–07**: Diese Dateien verwenden `<div class="benchmark"><ul><li>` ohne `.benchmark-list`-Klasse → `initProgress()` greift nicht. Noch nicht migriert.
- **Quiz-Keys null-padded**: `stufeId()` gibt `"07"` zurück, nicht `7`. Keys in `quiz-data.js` müssen exakt passen.
- **tools/register_rechner.html** liegt in `tools/` → lädt `../assets/` (ein Verzeichnis höher). sidebar.js erkennt das automatisch per `location.pathname`.
- **sidebar.js ist Single Source of Truth** für Navigation. `initSearchLink()` ist nur noch Fallback und wird durch sidebar.js praktisch immer deaktiviert (früher Return).
- **apply_redesign.py und migrate_all.py** sind einmalige Migrations-Scripts — nicht erneut ausführen, sie überschreiben Sidebar-Inhalte mit Platzhaltern.
- **VIC-Bank CIA2**: Bits 0–1 von $DD00 sind **invertiert** — %11 = Bank 0, %00 = Bank 3.
