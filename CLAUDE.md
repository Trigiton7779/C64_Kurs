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
│   ├── search-index.json              ← Generiert von tools/build_search_index.py
│   └── sidebar.js                     ← Generiert Sidebar dynamisch (Single Source of Truth)
├── tools/
│   ├── build_search_index.py           ← Erzeugt search-index.json (nach Content-Änderungen ausführen)
│   ├── extract_examples.py             ← Extrahiert <pre>-Blöcke in beispiele/stufe_XX/*.asm
│   ├── apply_redesign.py               ← Einmalig für Redesign genutzt
│   ├── migrate_all.py                  ← Einmalig für sidebar.js-Migration genutzt
│   └── register_rechner.html          ← Register-Visualizer Tool (lädt ../assets/)
└── beispiele/
    ├── index.html                      ← Zeigt alle .asm-Dateien
    └── stufe_00/ … stufe_17/          ← Extrahierte Code-Beispiele
```

## HTML-Format (einheitlich seit sidebar.js-Migration)

Alle 31 HTML-Dateien (Root + tools/) nutzen seit der `sidebar.js`-Migration dasselbe Format:
- Sidebar: `<aside class="sidebar"></aside>` — **leerer Platzhalter**, wird von `sidebar.js` befüllt
- Ladereihenfolge: `c64-base.css` → seitenspezifischer `<style>` → `c64-interactive.css` → Inhalt → `sidebar.js` → `c64-interactive.js`

### Was sidebar.js tut
- Erkennt aktuellen Dateinamen → setzt `class="active"` auf den passenden Link
- Erkennt `tools/`-Unterverzeichnis → verwendet `../`-Prefix für alle Pfade
- Generiert Auto-TOC aus `main > section[id]` (excludiert benchmark/exercises/learning-objectives)

### Altes Format (stufe_00–07, index.html) — Altlast
- Hat noch inline-CSS-Block (~60–150 Zeilen) mit alten `.sidebar nav ul li a`-Regeln
- Diese Regeln sind Dead Code (passen nicht auf neue Sidebar-Struktur) — harmlos
- `c64-base.css` wurde **hinzugefügt** (vor dem inline `<style>`)
- Visuelle Konsistenz durch `c64-base.css` + `c64-interactive.css` sichergestellt

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

## JS-Architektur

### sidebar.js (NEU — läuft VOR c64-interactive.js)
Generiert die komplette Sidebar-HTML synchron beim Laden. Muss vor `c64-interactive.js`
stehen, damit `.toc-link`-Elemente beim Scroll-Spy-Init bereits im DOM sind.

### c64-interactive.js — Alle Features als benannte Funktionen in `init()`:

| Funktion | Wirkung |
|---|---|
| `initDarkMode()` | Toggle-Button, `c64_dark_mode` localStorage |
| `initMobile()` | Hamburger-Menü für < 900px |
| `initCopyButtons()` | Kopier-Button für alle `<pre>`, auto-collapse > 22 Zeilen |
| `initProgress()` | Checkboxen in `.benchmark-list li`, `c64_bench_{stufe}_{idx}` |
| `initIndexProgress()` | Fortschrittsbalken auf `.stufe-card` auf index.html |
| `initScrollSpy()` | IntersectionObserver auf `.toc-link`, `.toc-active` Klasse |
| `initSearchLink()` | Fallback: injiziert Suche-Links falls `a[href$="suche.html"]` fehlt |
| `loadQuizData()` + `initQuiz()` | Lädt `quiz-data.js` dynamisch, Quiz nach `.benchmark` |

**localStorage-Keys:**
- `c64_dark_mode` — "1" oder "0"
- `c64_bench_{stufe}_{idx}` — "1" oder "0" (z.B. `c64_bench_07_3`)
- `c64_quiz_{stufe}_score/best/done` — Quiz-Ergebnisse

## Seitenstruktur (alle Dateien nach Migration)

```html
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
  <script src="assets/sidebar.js"></script>      ← Sidebar vor Interactive!
  <script src="assets/c64-interactive.js"></script>
```

## Häufige Aufgaben

### Navigation updaten (neuer Link oder neue Stufe in Sidebar)
Nur `assets/sidebar.js` editieren — eine Zeile hinzufügen mit `lnk(...)`:
```javascript
lnk('stufe_18_new_topic.html', '18 &middot; Neues Thema')
```
Kein Python-Script mehr nötig — Sidebar wird dynamisch generiert.

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
1. HTML-Datei im neuen Format erstellen (Struktur von stufe_17 kopieren, Sidebar = `<aside class="sidebar"></aside>`)
2. chapter-nav in vorheriger Stufe anpassen
3. **Nur `assets/sidebar.js` editieren** — eine `lnk()`-Zeile hinzufügen
4. `python3 tools/build_search_index.py` ausführen
5. `python3 tools/extract_examples.py` ausführen
6. Quiz-Fragen in `assets/quiz-data.js` ergänzen (Key = stufe_num als String z.B. `'18'`)

### Neue Anhang-Seite hinzufügen
Wie neue Stufe, aber:
- Dateiname: `anhang_X_name.html` (X = Buchstabe)
- In `sidebar.js` in der Sektion "Anhänge & Referenz" einfügen
- Lädt zusätzlich `assets/c64-print.css`

## Bekannte Quirks

- **Alte Dateien (stufe_00–07)**: benchmark-Items haben `<div class="benchmark"><ul>` ohne `.benchmark-list` — daher greifen `initProgress()` Checkboxen dort nicht. Noch nicht migriert.
- **Quiz-Keys null-padded**: `stufeId()` gibt `"07"` zurück (nicht `7`). Quiz-Daten müssen `'07'` als Key haben.
- **tools/register_rechner.html** liegt in `tools/` → lädt `../assets/` (ein Verzeichnis höher).
- **sidebar.js ist jetzt Single Source of Truth** für Navigation. `initSearchLink()` ist nur noch Fallback (prüft `a[href$="suche.html"]` mit Suffix-Selektor).
- **VIC-Bank CIA2**: Bits 0–1 von $DD00 sind **invertiert** — %11 = Bank 0, %00 = Bank 3.
