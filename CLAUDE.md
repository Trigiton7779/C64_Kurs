# CLAUDE.md — C64 Mastery System

Statische HTML-Lernseite für C64 6510-Assembler-Programmierung.
Kein Server, kein Framework — reines HTML/CSS/Vanilla-JS.

## Aktueller Stand

**Branch:** `redesign/neutral-theme`  
**Seiten:** 30 HTML-Dateien im Root + `beispiele/index.html`  
**Curriculum:** Stufe 00–17, Anhänge A–J, Suche, Register-Rechner

## Dateistruktur

```
C64_Kurs/
├── index.html                          ← Übersicht & Lernpfad
├── stufe_00_fundament.html             ← Stufen 00–17
│   ...
├── stufe_17_floppy_fastloader.html
├── anhang_opcodes.html                 ← Anhänge A–J
│   ...
├── anhang_j_illegale_opcodes.html
├── suche.html                          ← Volltextsuche (client-side)
├── assets/
│   ├── c64-base.css                    ← Gemeinsame Styles (Farben, Layout, Komponenten)
│   ├── c64-interactive.css             ← Dark Mode, Copy-Buttons, Quiz, Scroll-Spy, Suche
│   ├── c64-interactive.js              ← Alle shared JS-Features (init-Funktionen)
│   ├── c64-print.css                   ← Print-Styles für Anhänge
│   ├── c64-search.js                   ← Nur für suche.html: fetch + filter + render
│   ├── quiz-data.js                    ← 90 Quiz-Fragen (18 Stufen × 5)
│   └── search-index.json              ← Generiert von tools/build_search_index.py
├── tools/
│   ├── build_search_index.py           ← Erzeugt search-index.json (nach Content-Änderungen ausführen)
│   ├── extract_examples.py             ← Extrahiert <pre>-Blöcke in beispiele/stufe_XX/*.asm
│   ├── apply_redesign.py               ← Einmalig für Redesign genutzt
│   └── register_rechner.html          ← Register-Visualizer Tool (lädt ../assets/)
└── beispiele/
    ├── index.html                      ← Zeigt alle .asm-Dateien
    └── stufe_00/ … stufe_17/          ← Extrahierte Code-Beispiele
```

## Zwei HTML-Formate (wichtig!)

### Altes Format — stufe_00 bis stufe_07, index.html
- Sidebar: `<nav class="sidebar"><ul><li>` mit inline CSS
- Inline-CSS-Block ~200 Zeilen oben in der Datei
- Laden: `c64-interactive.css` + `c64-interactive.js`

### Neues Format — stufe_08+, alle Anhänge, suche.html
- Sidebar: `<aside class="sidebar"><nav>` mit `<div class="section-label">` + `<a>`
- Nutzt `c64-base.css` (kein inline CSS für Layout/Farben)
- Seitenspezifische Styles in `<style>`-Block für spezielle Klassen (z.B. `.joy-bit-table`)
- Lädt: `c64-base.css` → page-`<style>` → `c64-interactive.css` → Inhalt → `c64-interactive.js`

## CSS-Variablen (c64-base.css)

```css
--c64-blue:   #1a3f80   /* Primärfarbe, Sidebar-Header, Buttons */
--c64-green:  #00cc66   /* Akzent, aktive Links, Code-Text */
--c64-dark:   #1a1a2e   /* Code-Hintergrund */
--paper:      #f8f6f0   /* Seitenhintergrund */
--text:       #1a1a2e   /* Fließtext */
--theme-color: #1a3f80  /* Einheitlich für alle Seiten — kein Per-Seite-Override */
```

Dark Mode: `body.dark-mode` in `c64-interactive.css` überschreibt alle Variablen.

## JS-Architektur (c64-interactive.js)

Alle Features als benannte Funktionen, aufgerufen in `init()` via `DOMContentLoaded`:

| Funktion | Wirkung |
|---|---|
| `initDarkMode()` | Toggle-Button, `c64_dark_mode` localStorage |
| `initMobile()` | Hamburger-Menü für < 900px |
| `initCopyButtons()` | Kopier-Button für alle `<pre>`, auto-collapse > 22 Zeilen |
| `initProgress()` | Checkboxen in `.benchmark-list li`, `c64_bench_{stufe}_{idx}` |
| `initIndexProgress()` | Fortschrittsbalken auf `.stufe-card` auf index.html |
| `initScrollSpy()` | IntersectionObserver auf `.toc-link`, `.toc-active` Klasse |
| `initSearchLink()` | Injiziert "⌕ Suche" + "⚙ Register-Rechner" in Sidebar |
| `loadQuizData()` + `initQuiz()` | Lädt `quiz-data.js` dynamisch, Quiz nach `.benchmark` |

**localStorage-Keys:**
- `c64_dark_mode` — "1" oder "0"
- `c64_bench_{stufe}_{idx}` — "1" oder "0" (z.B. `c64_bench_07_3`)
- `c64_quiz_{stufe}_score/best/done` — Quiz-Ergebnisse

## Seitenstruktur (neues Format)

```html
<aside class="sidebar">…</aside>
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
  <script src="assets/c64-interactive.js"></script>
</main>
```

## Häufige Aufgaben

### Navigation in allen Dateien updaten
Immer per Python-Script — niemals manuell in allen 30 Dateien:
```bash
python3 tools/update_sidebar.py   # oder inline Python schreiben
```
Pattern für neues Format: `<a href="…">X · Name</a>` direkt in `<aside><nav>`  
Pattern für altes Format: `<li><a href="…">X — Name</a></li>`

### Search-Index neu bauen (nach Content-Änderungen)
```bash
python3 tools/build_search_index.py
# → assets/search-index.json (211 Sektionen aus 29 Seiten)
```

### Code-Beispiele extrahieren
```bash
python3 tools/extract_examples.py
# → beispiele/stufe_XX/*.asm aus allen <pre>-Blöcken
```

### Neue Stufe hinzufügen
1. HTML-Datei im neuen Format erstellen (Sidebar von stufe_16/17 kopieren)
2. chapter-nav in vorheriger Stufe anpassen
3. Navigation per Python-Script in alle 30 Dateien einfügen
4. `python3 tools/build_search_index.py` ausführen
5. `python3 tools/extract_examples.py` ausführen
6. Quiz-Fragen in `assets/quiz-data.js` ergänzen (Key = stufe_num als String z.B. `'18'`)

### Neue Anhang-Seite hinzufügen
Wie neue Stufe, aber:
- Dateiname: `anhang_X_name.html` (X = Buchstabe)
- In Sidebar-Sektion "Anhänge & Referenz" einfügen
- Lädt zusätzlich `assets/c64-print.css`

## Bekannte Quirks

- **Alte Dateien (stufe_00–07)**: benchmark-Items haben `<div class="benchmark"><ul>` ohne `.benchmark-list` — daher greifen `initProgress()` Checkboxen dort nicht. Noch nicht migriert.
- **Quiz-Keys null-padded**: `stufeId()` gibt `"07"` zurück (nicht `7`). Quiz-Daten müssen `'07'` als Key haben.
- **tools/register_rechner.html** liegt in `tools/` → lädt `../assets/` (ein Verzeichnis höher).
- **Sidebar-Link-Injection** (`initSearchLink()`) prüft ob `a[href="suche.html"]` schon existiert — nicht doppelt einfügen auf suche.html und register_rechner.html (die haben die Links hardcodiert).
- **VIC-Bank CIA2**: Bits 0–1 von $DD00 sind **invertiert** — %11 = Bank 0, %00 = Bank 3.
