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

  /* ── Scroll-Spy ───────────────────────────────────────────────── */
  function initScrollSpy() {
    var tocLinks = document.querySelectorAll('.toc-link[href^="#"]');
    if (!tocLinks.length) return;
    if (!('IntersectionObserver' in window)) return;

    var sections = [];
    tocLinks.forEach(function (a) {
      var id = a.getAttribute('href').slice(1);
      var el = document.getElementById(id);
      if (el) sections.push({ el: el, a: a });
    });
    if (!sections.length) return;

    var activeLink = null;

    function setActive(link) {
      if (link === activeLink) return;
      if (activeLink) activeLink.classList.remove('toc-active');
      activeLink = link;
      if (!activeLink) return;
      activeLink.classList.add('toc-active');
      var sidebar = document.querySelector('.sidebar');
      if (sidebar) {
        var linkTop = activeLink.offsetTop;
        var sh = sidebar.clientHeight;
        if (linkTop < sidebar.scrollTop + 40 || linkTop > sidebar.scrollTop + sh - 60) {
          sidebar.scrollTop = linkTop - sh / 2;
        }
      }
    }

    var observer = new IntersectionObserver(function (entries) {
      var visible = [];
      entries.forEach(function (e) { if (e.isIntersecting) visible.push(e.target); });
      if (!visible.length) return;
      visible.sort(function (a, b) {
        return a.getBoundingClientRect().top - b.getBoundingClientRect().top;
      });
      for (var i = 0; i < sections.length; i++) {
        if (sections[i].el === visible[0]) { setActive(sections[i].a); break; }
      }
    }, { rootMargin: '0px 0px -60% 0px', threshold: 0 });

    sections.forEach(function (s) { observer.observe(s.el); });
  }

  /* ── Search Nav Link ──────────────────────────────────────────── */
  function initSearchLink() {
    if (document.querySelector('a[href="suche.html"]')) return;
    var labels = document.querySelectorAll('.sidebar .section-label');
    if (!labels.length) return;
    var last = labels[labels.length - 1];
    var nav = last.parentNode;

    var aSearch = document.createElement('a');
    aSearch.href = 'suche.html';
    aSearch.textContent = '⌕ Suche';
    nav.insertBefore(aSearch, last.nextSibling);

    var aReg = document.createElement('a');
    aReg.href = 'tools/register_rechner.html';
    aReg.textContent = '⚙ Register-Rechner';
    nav.insertBefore(aReg, aSearch.nextSibling);
  }

  /* ── Quiz System ──────────────────────────────────────────────── */
  function loadQuizData(stufe, callback) {
    if (typeof C64_QUIZ !== 'undefined') { callback(); return; }
    var s = document.createElement('script');
    s.src = 'assets/quiz-data.js';
    s.onload = callback;
    s.onerror = function () {};
    document.head.appendChild(s);
  }

  function buildQuizHTML(stufe, questions) {
    var n = questions.length;
    var html = '<h2 class="c64-quiz-title">Wissenstest — Stufe ' + parseInt(stufe, 10) + '</h2>';
    html += '<p class="c64-quiz-meta">' + n + ' Fragen &mdash; Teste dein Wissen aus diesem Kapitel</p>';

    questions.forEach(function (q, i) {
      html += '<div class="c64-quiz-q"' + (i > 0 ? ' style="display:none"' : '') +
              ' data-idx="' + i + '">';
      html += '<div class="c64-quiz-qnum">Frage ' + (i + 1) + ' von ' + n + '</div>';
      html += '<p class="c64-quiz-question">' + q.q + '</p>';
      html += '<ul class="c64-quiz-options">';
      q.options.forEach(function (opt, oi) {
        html += '<li><button class="c64-quiz-opt" data-opt="' + oi + '">' + opt + '</button></li>';
      });
      html += '</ul>';
      html += '<div class="c64-quiz-explanation" style="display:none"><strong>Erklärung:</strong> ' +
              q.explanation + '</div>';
      html += '</div>';
    });

    html += '<div class="c64-quiz-nav">';
    html += '<button class="c64-quiz-submit" disabled>Antwort prüfen</button>';
    html += '<button class="c64-quiz-next" style="display:none">Nächste Frage &#x2192;</button>';
    html += '</div>';
    html += '<div class="c64-quiz-result" style="display:none">';
    html += '<div class="c64-quiz-score-display"></div>';
    html += '<button class="c64-quiz-restart">Quiz wiederholen</button>';
    html += '</div>';
    return html;
  }

  function bindQuizEvents(container, stufe, questions) {
    var currentQ = 0, score = 0, selected = -1, answered = false;
    var SCORE_KEY = 'c64_quiz_' + stufe + '_score';
    var BEST_KEY  = 'c64_quiz_' + stufe + '_best';
    var DONE_KEY  = 'c64_quiz_' + stufe + '_done';

    function showQ(idx) {
      container.querySelectorAll('.c64-quiz-q').forEach(function (el) { el.style.display = 'none'; });
      var qEl = container.querySelector('.c64-quiz-q[data-idx="' + idx + '"]');
      if (qEl) qEl.style.display = 'block';
      selected = -1; answered = false;
      var submit = container.querySelector('.c64-quiz-submit');
      var next   = container.querySelector('.c64-quiz-next');
      submit.disabled = true; submit.style.display = 'inline-block';
      next.style.display = 'none';
      container.querySelectorAll('.c64-quiz-opt').forEach(function (b) {
        b.classList.remove('correct', 'wrong', 'selected'); b.disabled = false;
      });
      if (qEl) qEl.querySelector('.c64-quiz-explanation').style.display = 'none';
    }

    container.addEventListener('click', function (e) {
      var t = e.target;

      if (t.classList.contains('c64-quiz-opt') && !answered) {
        container.querySelectorAll('.c64-quiz-opt').forEach(function (b) { b.classList.remove('selected'); });
        t.classList.add('selected');
        selected = parseInt(t.getAttribute('data-opt'), 10);
        container.querySelector('.c64-quiz-submit').disabled = false;
      }

      if (t.classList.contains('c64-quiz-submit') && selected >= 0 && !answered) {
        answered = true;
        var correct = questions[currentQ].correct;
        container.querySelectorAll('.c64-quiz-opt').forEach(function (b) {
          b.disabled = true;
          var o = parseInt(b.getAttribute('data-opt'), 10);
          if (o === correct) b.classList.add('correct');
          else if (o === selected) b.classList.add('wrong');
        });
        var qEl = container.querySelector('.c64-quiz-q[data-idx="' + currentQ + '"]');
        qEl.querySelector('.c64-quiz-explanation').style.display = 'block';
        if (selected === correct) score++;
        t.style.display = 'none';
        var next = container.querySelector('.c64-quiz-next');
        next.style.display = 'inline-block';
        next.textContent = currentQ < questions.length - 1
          ? 'Nächste Frage →' : 'Ergebnis anzeigen';
      }

      if (t.classList.contains('c64-quiz-next')) {
        currentQ++;
        if (currentQ < questions.length) {
          showQ(currentQ);
        } else {
          container.querySelectorAll('.c64-quiz-q').forEach(function (q) { q.style.display = 'none'; });
          container.querySelector('.c64-quiz-nav').style.display = 'none';
          var result = container.querySelector('.c64-quiz-result');
          result.style.display = 'block';
          var pct = Math.round((score / questions.length) * 100);
          var stars = ['★☆☆☆☆', '★★☆☆☆',
                       '★★★☆☆', '★★★★☆',
                       '★★★★★'];
          var si = Math.min(Math.max(score - 1, 0), 4);
          result.querySelector('.c64-quiz-score-display').innerHTML =
            '<div class="c64-quiz-stars">' + stars[si] + '</div>' +
            '<div class="c64-quiz-score-text">' + score + ' von ' + questions.length +
            ' richtig &nbsp;(' + pct + '&#x25;)</div>';
          localStorage.setItem(SCORE_KEY, score);
          var best = parseInt(localStorage.getItem(BEST_KEY) || '0', 10);
          if (score > best) localStorage.setItem(BEST_KEY, score);
          localStorage.setItem(DONE_KEY, '1');
        }
      }

      if (t.classList.contains('c64-quiz-restart')) {
        currentQ = 0; score = 0; selected = -1; answered = false;
        container.querySelector('.c64-quiz-result').style.display = 'none';
        container.querySelector('.c64-quiz-nav').style.display = 'block';
        showQ(0);
      }
    });
  }

  function initQuiz() {
    var stufe = stufeId();
    if (!stufe || typeof C64_QUIZ === 'undefined' || !C64_QUIZ[stufe]) return;
    var questions = C64_QUIZ[stufe];
    var anchor = document.querySelector('#benchmark, section.benchmark, .benchmark');
    if (!anchor) return;
    var container = document.createElement('section');
    container.id = 'c64-quiz';
    container.className = 'c64-quiz-section';
    container.innerHTML = buildQuizHTML(stufe, questions);
    anchor.parentNode.insertBefore(container, anchor.nextSibling);
    bindQuizEvents(container, stufe, questions);
  }

  /* ── Init ─────────────────────────────────────────────────────── */
  function init() {
    initDarkMode();
    initMobile();
    initCopyButtons();
    initProgress();
    initIndexProgress();
    initScrollSpy();
    initSearchLink();
    var s = stufeId();
    if (s) loadQuizData(s, initQuiz);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

})();
