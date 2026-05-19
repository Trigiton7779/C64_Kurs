/* C64 Mastery System — Dynamic Sidebar Generator
   Injects full navigation into <aside class="sidebar"></aside>.
   Must load BEFORE c64-interactive.js so scroll-spy finds .toc-link elements. */
(function () {
  'use strict';

  var aside = document.querySelector('aside.sidebar, nav.sidebar');
  if (!aside) return;

  var isTools = location.pathname.indexOf('/tools/') !== -1;
  var p       = isTools ? '../' : '';
  var current = location.pathname.split('/').pop() || 'index.html';

  function lnk(href, text, attrs) {
    var isActive = href.split('/').pop() === current;
    var cls = isActive ? ' class="active"' : '';
    return '<a href="' + p + href + '"' + cls + (attrs || '') + '>' + text + '</a>';
  }

  function lbl(text) {
    return '<div class="section-label">' + text + '</div>';
  }

  /* ── Auto-TOC from main > section[id] ─────────────────────── */
  var skipCls = /\b(benchmark|exercises|learning-objectives)\b/;
  var skipId  = /^(benchmark|exercises)$/;
  var tocLinks = [];
  document.querySelectorAll('main > section[id]').forEach(function (sec) {
    if (skipCls.test(sec.className) || skipId.test(sec.id)) return;
    var h = sec.querySelector('h2, h3');
    if (!h) return;
    tocLinks.push('<a href="#' + sec.id + '" class="toc-link">'
      + h.textContent.trim() + '</a>');
  });
  var tocHtml = tocLinks.length
    ? lbl('Diese Seite') + tocLinks.join('')
    : '';

  /* ── Build sidebar HTML ────────────────────────────────────── */
  aside.innerHTML =
    '<div class="sidebar-header">'
      + '<div class="logo">&#9632; C64 MASTERY</div>'
      + 'Professioneller Lehrgang'
    + '</div>'
    + '<nav>'
    + lbl('Curriculum')
    + lnk('index.html',                              '&#9672; &Uuml;bersicht &amp; Lernpfad')
    + lnk('stufe_00_fundament.html',                 '00 &middot; Fundament')
    + lnk('stufe_01_6510_assembler.html',            '01 &middot; 6510 &amp; Assembler')
    + lnk('stufe_02_adressierung_speicher.html',     '02 &middot; Adressierung &amp; Speicher')
    + lnk('stufe_03_bildschirm_zeichen.html',        '03 &middot; Bildschirm &amp; Zeichen')
    + lnk('stufe_04_sprites_animation.html',         '04 &middot; Sprites &amp; Animation')
    + lnk('stufe_05_bitmap_grafik.html',             '05 &middot; Bitmap-Grafik')
    + lnk('stufe_06_sid_sound.html',                 '06 &middot; SID-Sound')
    + lnk('stufe_07_interrupts_timing.html',         '07 &middot; Interrupts &amp; Timing')
    + lnk('stufe_08_optimierung.html',               '08 &middot; Optimierung')
    + lnk('stufe_09_demo_effekte.html',              '09 &middot; Demo-Effekte')
    + lnk('stufe_10_meisterschaft.html',             '10 &middot; Meisterschaft')
    + lbl('Workflow &amp; Release')
    + lnk('stufe_11_spielentwicklung_workflow.html', '11 &middot; Spiel-Workflow')
    + lnk('stufe_12_demo_entwicklung_workflow.html', '12 &middot; Demo-Workflow')
    + lbl('Erweiterte Stufen')
    + lnk('stufe_13_hardware_erweiterungen.html',    '13 &middot; Hardware-Erweiterungen')
    + lnk('stufe_14_modern_workflow.html',           '14 &middot; Moderner Workflow')
    + lnk('stufe_15_debugging_deep_dive.html',       '15 &middot; Deep Debugging')
    + lnk('stufe_16_tastatur_joystick.html',         '16 &middot; Tastatur &amp; Joystick')
    + lnk('stufe_17_floppy_fastloader.html',         '17 &middot; Floppy &amp; Fastloader')
    + tocHtml
    + lbl('Suche &amp; Werkzeuge')
    + lnk('suche.html',                    '&#8981; Volltextsuche')
    + lnk('tools/register_rechner.html',   '&#9881; Register-Rechner')
    + lbl('Anh&auml;nge &amp; Referenz')
    + lnk('anhang_opcodes.html',           'A &middot; Opcode-Referenz')
    + lnk('anhang_speicherkarte.html',     'B &middot; Speicherkarte')
    + lnk('anhang_vic_register.html',      'C &middot; VIC-II Register')
    + lnk('anhang_sid_register.html',      'D &middot; SID Register')
    + lnk('anhang_cia_register.html',      'E &middot; CIA Register')
    + lnk('anhang_petscii.html',           'F &middot; PETSCII-Tabelle')
    + lnk('anhang_farben.html',            'G &middot; C64-Farben')
    + lnk('anhang_kernal_routinen.html',   'H &middot; KERNAL-Routinen')
    + lnk('anhang_i_acme_referenz.html',   'I &middot; ACME-Referenz')
    + lnk('anhang_j_illegale_opcodes.html','J &middot; Illegale Opcodes')
    + lbl('Downloads')
    + lnk('beispiele/index.html',          'Beispielcode (.asm)')
    + '<a href="' + p + 'vice.vicerc" download>VICE Konfiguration</a>'
    + '</nav>';
})();
