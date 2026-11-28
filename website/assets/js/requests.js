(function () {
  "use strict";

  var site = window.ModiSite;
  var listEl = document.getElementById("request-list");
  var emptyEl = document.getElementById("empty");
  var summaryEl = document.getElementById("summary");
  var lookupEl = document.getElementById("lookup");
  var clearArea = document.getElementById("clear-area");
  var clearBtn = document.getElementById("clear-btn");

  // Demo progress steps. A real system would move requests along these steps.
  var STEPS = ["Submitted", "In review", "Quoted or scheduled", "Completed"];

  function formatDate(iso) {
    var d = new Date(iso);
    return isNaN(d.getTime()) ? "" : d.toISOString().slice(0, 10);
  }

  function allRequests() {
    var quotes = site.readJson(site.KEYS.quotes, []).map(function (r) {
      return { kind: "quote", kindLabel: "Quotation", id: r.id, createdAt: r.createdAt, status: r.status, raw: r };
    });
    var services = site.readJson(site.KEYS.services, []).map(function (r) {
      return { kind: "service", kindLabel: r.typeLabel + " service", id: r.id, createdAt: r.createdAt, status: r.status, raw: r };
    });
    return quotes.concat(services).sort(function (a, b) {
      return (b.createdAt || "").localeCompare(a.createdAt || "");
    });
  }

  function details(item) {
    var r = item.raw;
    if (item.kind === "quote") {
      var total = r.lines.reduce(function (sum, l) { return sum + l.unitPrice * l.quantity; }, 0);
      var currency = r.lines.length ? r.lines[0].currency : "";
      return [
        ["Company", r.name],
        ["Contact", r.contact],
        ["Items", r.lines.length + (r.lines.length === 1 ? " product" : " products")],
        ["Indicative total", currency + site.formatAmount(total) + " (demo)"]
      ];
    }
    return [
      ["Equipment", r.equipment],
      ["Location", r.location],
      ["Preferred date", r.preferredDate]
    ];
  }

  function cardHtml(item) {
    var currentIndex = 0;
    var steps = STEPS.map(function (label, i) {
      var cls = i < currentIndex ? "done" : (i === currentIndex ? "current" : "");
      return '<li class="' + cls + '"' + (i === currentIndex ? ' aria-current="step"' : "") + ">" + site.escapeHtml(label) + "</li>";
    }).join("");
    var rows = details(item).map(function (pair) {
      return "<dt>" + site.escapeHtml(pair[0]) + "</dt><dd>" + site.escapeHtml(pair[1]) + "</dd>";
    }).join("");
    return '<article class="card request" data-ref="' + site.escapeHtml(item.id) + '">' +
      '<div class="request-head">' +
        "<h3>" + site.escapeHtml(item.kindLabel) + "</h3>" +
        '<span class="ref">' + site.escapeHtml(item.id) + "</span>" +
      "</div>" +
      '<p class="muted small" style="margin:var(--space-2) 0 0">Submitted ' + site.escapeHtml(formatDate(item.createdAt)) + "</p>" +
      "<dl>" + rows + "</dl>" +
      '<p class="small" style="margin:0"><strong>Status:</strong> ' + site.escapeHtml(STEPS[currentIndex]) + " (demo)</p>" +
      '<ol class="steps" aria-label="Progress">' + steps + "</ol>" +
      "</article>";
  }

  function render() {
    var items = allRequests();
    var q = lookupEl.value.trim().toLowerCase();
    var visible = items.filter(function (item) {
      return q === "" || item.id.toLowerCase().indexOf(q) !== -1;
    });
    listEl.innerHTML = visible.map(cardHtml).join("");
    emptyEl.hidden = items.length > 0;
    clearArea.hidden = items.length === 0;
    if (items.length === 0) {
      summaryEl.textContent = "";
    } else if (visible.length === 0) {
      summaryEl.textContent = "No request matches that reference in this browser.";
    } else {
      summaryEl.textContent = visible.length + " of " + items.length + (items.length === 1 ? " request" : " requests") + " shown";
    }
  }

  lookupEl.addEventListener("input", render);
  document.getElementById("lookup-form").addEventListener("submit", function (e) { e.preventDefault(); });

  clearBtn.addEventListener("click", function () {
    if (!window.confirm("Remove all demo quotation and servicing requests saved in this browser?")) return;
    site.writeJson(site.KEYS.quotes, []);
    site.writeJson(site.KEYS.services, []);
    site.toast("Demo requests cleared.");
    render();
  });

  render();
})();
