// Timeline filters: one tag, one calendar month, one age (in months).
// The current filter lives in the URL hash (e.g. #tag=funny&age=3) so it
// survives reloads and tag links from entry pages land on the right view.
(function () {
  var chips = document.querySelectorAll('.chips button');
  var month = document.getElementById('f-month');
  var age = document.getElementById('f-age');
  var entries = document.querySelectorAll('.timeline .entry');
  var sections = document.querySelectorAll('.timeline .month');
  var noMatch = document.getElementById('no-match');

  function read() {
    var f = { tag: '', month: '', age: '' };
    location.hash.replace(/^#/, '').split('&').forEach(function (kv) {
      var p = kv.split('=');
      if (p[0] in f) f[p[0]] = decodeURIComponent(p[1] || '');
    });
    return f;
  }

  function write(f) {
    var parts = [];
    for (var k in f) if (f[k]) parts.push(k + '=' + encodeURIComponent(f[k]));
    history.replaceState(null, '', parts.length ? '#' + parts.join('&') : location.pathname);
    apply(f);
  }

  function apply(f) {
    chips.forEach(function (b) { b.setAttribute('aria-pressed', String(b.dataset.tag === f.tag)); });
    month.value = f.month;
    age.value = f.age;
    var shown = 0;
    entries.forEach(function (e) {
      var ok = (!f.tag || (' ' + e.dataset.tags + ' ').indexOf(' ' + f.tag + ' ') !== -1) &&
               (!f.month || e.dataset.month === f.month) &&
               (!f.age || e.dataset.age === f.age);
      e.hidden = !ok;
      if (ok) shown++;
    });
    sections.forEach(function (s) { s.hidden = !s.querySelector('.entry:not([hidden])'); });
    noMatch.hidden = shown > 0;
  }

  chips.forEach(function (b) {
    b.addEventListener('click', function () { var f = read(); f.tag = b.dataset.tag; write(f); });
  });
  month.addEventListener('change', function () { var f = read(); f.month = month.value; write(f); });
  age.addEventListener('change', function () { var f = read(); f.age = age.value; write(f); });
  document.getElementById('f-clear').addEventListener('click', function () { write({}); });

  // Tag links inside entries on this page: filter instead of reloading.
  document.querySelectorAll('.timeline a.tag').forEach(function (a) {
    a.addEventListener('click', function (ev) {
      ev.preventDefault();
      write({ tag: a.textContent.trim() });
      window.scrollTo(0, 0);
    });
  });

  window.addEventListener('hashchange', function () { apply(read()); });
  apply(read());
})();
