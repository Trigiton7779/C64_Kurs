/* C64 Mastery System — Shared Interactive Script */
(function () {
  'use strict';

  var DARK_KEY = 'c64_dark_mode';
  var BENCH_PREFIX = 'c64_bench_';

  /* ── Utility ──────────────────────────────────────────────────── */
  function stufeId() {
    var m = location.pathname.match(/stufe_(\d+)/);
    return m ? m[1] : null;
  }

  function benchKey(stufe, idx) {
    return BENCH_PREFIX + stufe + '_' + idx;
  }

  function totalBenchmarks(stufe) {
    var total = 0;
    var i = 0;
    while (localStorage.getItem(benchKey(stufe, i)) !== null || i === 0) {
      if (localStorage.getItem(benchKey(stufe, i)) !== null) total = i + 1;
      i++;
      if (i > 100) break;
    }
    return total;
  }

  function doneBenchmarks(stufe) {
    var done = 0;
    var total = totalBenchmarks(stufe);
    for (var i = 0; i < total; i++) {
      if (localStorage.getItem(benchKey(stufe, i)) === '1') done++;
    }
    return done;
  }

  /* ── Dark Mode ────────────────────────────────────────────────── */
  function initDarkMode() {
    var dark = localStorage.getItem(DARK_KEY) === '1';
    if (dark) document.body.classList.add('dark-mode');

    var btn = document.createElement('button');
    btn.id = 'c64-dark-toggle';
    btn.textContent = dark ? '☀ Hell' : '☾ Dunkel';
    btn.setAttribute('aria-label', 'Dark Mode umschalten');
    document.body.appendChild(btn);

    btn.addEventListener('click', function () {
      var isDark = document.body.classList.toggle('dark-mode');
      localStorage.setItem(DARK_KEY, isDark ? '1' : '0');
      btn.textContent = isDark ? '☀ Hell' : '☾ Dunkel';
    });
  }

  /* ── Mobile Hamburger ─────────────────────────────────────────── */
  function initMobile() {
    var sidebar = document.querySelector('.sidebar');
    if (!sidebar) return;

    var hamburger = document.createElement('button');
    hamburger.id = 'c64-hamburger';
    hamburger.innerHTML = '&#9776;';
    hamburger.setAttribute('aria-label', 'Navigation öffnen');
    document.body.appendChild(hamburger);

    var overlay = document.createElement('div');
    overlay.id = 'c64-overlay';
    document.body.appendChild(overlay);

    function openNav() {
      sidebar.classList.add('open');
      overlay.classList.add('visible');
    }
    function closeNav() {
      sidebar.classList.remove('open');
      overlay.classList.remove('visible');
    }

    hamburger.addEventListener('click', function () {
      sidebar.classList.contains('open') ? closeNav() : openNav();
    });
    overlay.addEventListener('click', closeNav);

    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') closeNav();
    });
  }

  /* ── Copy Buttons ─────────────────────────────────────────────── */
  function initCopyButtons() {
    var pres = document.querySelectorAll('pre');
    pres.forEach(function (pre) {
      /* skip if already wrapped */
      if (pre.parentNode.classList.contains('pre-wrapper')) return;

      var wrapper = document.createElement('div');
      wrapper.className = 'pre-wrapper';
      pre.parentNode.insertBefore(wrapper, pre);
      wrapper.appendChild(pre);

      /* copy button */
      var btn = document.createElement('button');
      btn.className = 'copy-btn';
      btn.textContent = 'Kopieren';
      wrapper.appendChild(btn);

      btn.addEventListener('click', function () {
        var text = pre.textContent;
        if (navigator.clipboard && navigator.clipboard.writeText) {
          navigator.clipboard.writeText(text).then(function () {
            flashCopied(btn);
          }).catch(function () {
            fallbackCopy(text, btn);
          });
        } else {
          fallbackCopy(text, btn);
        }
      });

      /* collapsible for long blocks */
      var lineCount = pre.textContent.split('\n').length;
      if (lineCount > 22) {
        wrapper.classList.add('collapsible');
        pre.classList.add('collapsed');

        var colBtn = document.createElement('button');
        colBtn.className = 'collapse-btn';
        colBtn.textContent = '▼ Mehr anzeigen (' + lineCount + ' Zeilen)';
        wrapper.appendChild(colBtn);

        colBtn.addEventListener('click', function () {
          var isCollapsed = pre.classList.toggle('collapsed');
          colBtn.textContent = isCollapsed
            ? '▼ Mehr anzeigen (' + lineCount + ' Zeilen)'
            : '▲ Weniger anzeigen';
        });
      }
    });
  }

  function flashCopied(btn) {
    btn.textContent = '✓ Kopiert!';
    btn.classList.add('copied');
    setTimeout(function () {
      btn.textContent = 'Kopieren';
      btn.classList.remove('copied');
    }, 1800);
  }

  function fallbackCopy(text, btn) {
    var ta = document.createElement('textarea');
    ta.value = text;
    ta.style.cssText = 'position:fixed;top:-9999px;left:-9999px';
    document.body.appendChild(ta);
    ta.select();
    try {
      document.execCommand('copy');
      flashCopied(btn);
    } catch (e) {
      btn.textContent = 'Fehler';
    }
    document.body.removeChild(ta);
  }

  /* ── Benchmark Checkboxes ─────────────────────────────────────── */
  function initProgress() {
    var stufe = stufeId();
    if (!stufe) return;

    var items = document.querySelectorAll('.benchmark-list li, .skill-benchmark ul li');
    if (!items.length) return;

    items.forEach(function (li, idx) {
      var key = benchKey(stufe, idx);
      var done = localStorage.getItem(key) === '1';

      var cb = document.createElement('input');
      cb.type = 'checkbox';
      cb.className = 'bench-checkbox';
      cb.checked = done;
      cb.setAttribute('aria-label', 'Erledigt markieren');

      if (done) li.classList.add('bench-done');

      li.insertBefore(cb, li.firstChild);

      cb.addEventListener('change', function () {
        localStorage.setItem(key, cb.checked ? '1' : '0');
        li.classList.toggle('bench-done', cb.checked);
        updateSidebarBar(stufe, items.length);
      });

      li.addEventListener('click', function (e) {
        if (e.target !== cb) {
          cb.checked = !cb.checked;
          cb.dispatchEvent(new Event('change'));
        }
      });
    });

    /* sidebar mini-bar */
    updateSidebarBar(stufe, items.length);
  }

  function updateSidebarBar(stufe, total) {
    var done = 0;
    for (var i = 0; i < total; i++) {
      if (localStorage.getItem(benchKey(stufe, i)) === '1') done++;
    }
    var pct = total > 0 ? Math.round((done / total) * 100) : 0;

    var existing = document.getElementById('c64-spb-' + stufe);
    if (existing) {
      existing.querySelector('.spb-fill').style.width = pct + '%';
      existing.querySelector('.spb-label').textContent = done + '/' + total + ' erledigt';
      return;
    }

    /* find active sidebar link and insert bar below */
    var activeLink = document.querySelector('.sidebar a.active, .sidebar a[aria-current="page"]');
    if (!activeLink) {
      var links = document.querySelectorAll('.sidebar a');
      links.forEach(function (a) {
        if (a.href && location.pathname.indexOf('stufe_' + stufe) !== -1 &&
            a.href.indexOf('stufe_' + stufe) !== -1) {
          activeLink = a;
        }
      });
    }
    if (!activeLink) return;

    var wrap = document.createElement('div');
    wrap.id = 'c64-spb-' + stufe;
    wrap.className = 'spb-wrap';
    wrap.innerHTML =
      '<div class="spb-track"><div class="spb-fill" style="width:' + pct + '%"></div></div>' +
      '<div class="spb-label">' + done + '/' + total + ' erledigt</div>';

    activeLink.parentNode.insertBefore(wrap, activeLink.nextSibling);
  }

  /* ── Index Page: Progress Bars on Stage Cards ─────────────────── */
  function initIndexProgress() {
    /* Only run on index.html */
    if (location.pathname.indexOf('index') === -1 &&
        location.pathname.replace(/.*\//, '') !== '' &&
        location.pathname.replace(/.*\//, '') !== 'index.html') {
      /* check if this really is the index by looking for stage cards */
      var cards = document.querySelectorAll('.stage-card, .stufen-card, [data-stufe]');
      if (!cards.length) return;
    }

    /* look for links to stufe files to determine which stages exist */
    var stageLinks = document.querySelectorAll('a[href*="stufe_"]');
    var processed = {};

    stageLinks.forEach(function (a) {
      var m = a.href.match(/stufe_(\d+)/);
      if (!m) return;
      var stufe = m[1];
      if (processed[stufe]) return;
      processed[stufe] = true;

      /* count stored benchmark items for this stufe */
      var total = 0;
      var done = 0;
      for (var i = 0; i < 30; i++) {
        var val = localStorage.getItem(benchKey(stufe, i));
        if (val !== null) {
          total = i + 1;
          if (val === '1') done++;
        }
      }

      if (total === 0) return; /* not visited yet */

      var pct = Math.round((done / total) * 100);

      /* try to find the closest card container */
      var card = a.closest('.stage-card, .stufen-card, li, .card');
      if (!card) card = a.parentNode;

      if (card.querySelector('.stage-progress-bar')) return;

      var barDiv = document.createElement('div');
      barDiv.className = 'stage-progress-bar';
      barDiv.innerHTML =
        '<div class="spb-track"><div class="spb-fill" style="width:' + pct + '%"></div></div>' +
        '<div class="spb-label" style="color:#666;font-size:11px;margin-top:2px">' +
        done + '/' + total + ' Benchmarks — ' + pct + '%</div>';

      card.appendChild(barDiv);
    });
  }

  /* ── Init ─────────────────────────────────────────────────────── */
  function init() {
    initDarkMode();
    initMobile();
    initCopyButtons();
    initProgress();
    initIndexProgress();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

})();
