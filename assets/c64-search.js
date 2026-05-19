/* C64 Mastery System — Client-side Search */
(function () {
  'use strict';

  var INDEX = null;
  var SHOWN = 0;
  var RESULTS = [];
  var PAGE_SIZE = 20;
  var debounceTimer = null;

  function loadIndex(callback) {
    fetch('assets/search-index.json')
      .then(function (r) { return r.json(); })
      .then(function (data) { INDEX = data; callback(); })
      .catch(function () {
        document.getElementById('c64-search-stats').textContent =
          'Suchindex konnte nicht geladen werden.';
      });
  }

  function tokenize(text) {
    return text.toLowerCase().replace(/[^a-z0-9äöüß$#%]/g, ' ')
      .split(/\s+/).filter(function (t) { return t.length >= 2; });
  }

  function scoreEntry(entry, terms) {
    var total = 0;
    var titleLc = (entry.title || '').toLowerCase();

    terms.forEach(function (term) {
      if (titleLc.indexOf(term) !== -1) total += 60;
    });

    entry.sections.forEach(function (sec) {
      var hLc = (sec.heading || '').toLowerCase();
      var tLc = (sec.text    || '').toLowerCase();
      terms.forEach(function (term) {
        if (hLc.indexOf(term) !== -1) total += 40;
        if (tLc.indexOf(term) !== -1) total += 20;
      });
    });

    /* multi-term bonus */
    if (terms.length > 1) total = Math.round(total * 1.15);
    return total;
  }

  function highlight(text, terms) {
    if (!text) return '';
    var out = text;
    terms.forEach(function (term) {
      if (!term) return;
      try {
        var re = new RegExp('(' + term.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + ')', 'gi');
        out = out.replace(re, '<mark class="c64-highlight">$1</mark>');
      } catch (e) {}
    });
    return out;
  }

  function breadcrumb(entry) {
    if (entry.type === 'stufe' && entry.stufe) {
      return 'Stufe ' + parseInt(entry.stufe, 10) + ' · ' + (entry.title || '');
    }
    if (entry.type === 'anhang') {
      return 'Anhang · ' + (entry.title || '');
    }
    return entry.title || entry.url;
  }

  function buildResult(entry, sec, terms) {
    var url  = entry.url + (sec.id ? '#' + sec.id : '');
    var head = highlight(sec.heading || entry.title, terms);
    var snip = highlight(sec.text ? sec.text.slice(0, 200) + (sec.text.length > 200 ? '…' : '') : '', terms);
    return '<div class="search-result">' +
      '<div class="sr-breadcrumb">' + breadcrumb(entry) + '</div>' +
      '<a class="sr-heading" href="' + url + '">' + head + '</a>' +
      (snip ? '<p class="sr-snippet">' + snip + '</p>' : '') +
      '</div>';
  }

  function runSearch(query) {
    var terms = tokenize(query);
    if (!terms.length) {
      RESULTS = [];
      render([]);
      document.getElementById('c64-search-stats').textContent = '';
      return;
    }

    var scored = [];
    INDEX.forEach(function (entry) {
      var s = scoreEntry(entry, terms);
      if (s <= 0) return;

      /* flatten: one result per matching section + one for title match */
      entry.sections.forEach(function (sec) {
        var secScore = 0;
        var hLc = (sec.heading || '').toLowerCase();
        var tLc = (sec.text    || '').toLowerCase();
        terms.forEach(function (t) {
          if (hLc.indexOf(t) !== -1) secScore += 40;
          if (tLc.indexOf(t) !== -1) secScore += 20;
        });
        if (secScore > 0) {
          scored.push({ entry: entry, sec: sec, score: secScore + (s - 20) });
        }
      });

      /* Also add page-level hit if title matches strongly */
      var titleScore = 0;
      terms.forEach(function (t) {
        if ((entry.title || '').toLowerCase().indexOf(t) !== -1) titleScore += 60;
      });
      if (titleScore > 0 && entry.sections.length === 0) {
        scored.push({ entry: entry, sec: { id: '', heading: entry.title, text: '' }, score: titleScore });
      }
    });

    scored.sort(function (a, b) { return b.score - a.score; });

    /* Deduplicate identical urls */
    var seen = {};
    RESULTS = scored.filter(function (r) {
      var key = r.entry.url + '#' + (r.sec.id || '');
      if (seen[key]) return false;
      seen[key] = true;
      return true;
    });

    SHOWN = 0;
    var statsEl = document.getElementById('c64-search-stats');
    statsEl.textContent = RESULTS.length
      ? RESULTS.length + ' Treffer für „' + query + '"'
      : 'Keine Treffer für „' + query + '"';

    render(terms);
  }

  function render(terms) {
    var container = document.getElementById('c64-search-results');
    var slice = RESULTS.slice(0, SHOWN + PAGE_SIZE);
    SHOWN = slice.length;

    var html = slice.map(function (r) {
      return buildResult(r.entry, r.sec, terms);
    }).join('');

    if (RESULTS.length > SHOWN) {
      html += '<button class="sr-more-btn" id="sr-more">Mehr anzeigen (' +
        (RESULTS.length - SHOWN) + ' weitere)</button>';
    }

    container.innerHTML = html;

    var moreBtn = document.getElementById('sr-more');
    if (moreBtn) {
      var currentTerms = terms;
      moreBtn.addEventListener('click', function () {
        render(currentTerms);
      });
    }
  }

  function init() {
    var input = document.getElementById('c64-search-input');
    if (!input) return;

    /* pre-fill from URL ?q= */
    var qParam = new URLSearchParams(location.search).get('q');
    if (qParam) input.value = qParam;

    loadIndex(function () {
      if (qParam) runSearch(qParam);
    });

    input.addEventListener('input', function () {
      clearTimeout(debounceTimer);
      var val = input.value.trim();
      debounceTimer = setTimeout(function () { runSearch(val); }, 200);
    });

    input.focus();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
