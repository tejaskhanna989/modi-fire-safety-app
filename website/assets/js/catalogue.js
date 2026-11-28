(function () {
  "use strict";

  var data = window.MODI_DATA;
  var site = window.ModiSite;
  var state = { category: "all", query: "" };

  var CODES = {
    extinguishers: "EX", alarms: "AL", hoses: "HR", blankets: "FB",
    ppe: "PP", "first-aid": "FA", signage: "SG", kitchen: "KS"
  };

  var chipsEl = document.getElementById("category-chips");
  var gridEl = document.getElementById("product-grid");
  var emptyEl = document.getElementById("empty");
  var countEl = document.getElementById("result-count");
  var searchEl = document.getElementById("search");

  function categoryName(id) {
    var found = data.categories.filter(function (c) { return c.id === id; })[0];
    return found ? found.name : id;
  }

  function renderChips() {
    var all = [{ id: "all", name: "All" }].concat(data.categories);
    chipsEl.innerHTML = all.map(function (c) {
      var pressed = state.category === c.id;
      return '<button type="button" class="chip" data-id="' + site.escapeHtml(c.id) +
        '" aria-pressed="' + pressed + '">' + site.escapeHtml(c.name) + "</button>";
    }).join("");
  }

  function matches(product) {
    var inCategory = state.category === "all" || product.categoryId === state.category;
    var q = state.query.trim().toLowerCase();
    var haystack = (product.name + " " + categoryName(product.categoryId)).toLowerCase();
    return inCategory && (q === "" || haystack.indexOf(q) !== -1);
  }

  function cardHtml(product, selected) {
    var code = CODES[product.categoryId] || "";
    var label = selected ? "Added to quote" : "Add to quote";
    return '<article class="card product">' +
      '<div class="thumb" aria-hidden="true">' + site.escapeHtml(code) + "</div>" +
      '<div class="body">' +
        '<span class="badge">Demo item</span>' +
        '<h3 style="margin-top:var(--space-3);font-size:1rem">' + site.escapeHtml(product.name) + "</h3>" +
        '<p class="muted small" style="margin:0">' + site.escapeHtml(categoryName(product.categoryId)) + "</p>" +
        '<div class="price">' + site.escapeHtml(site.priceLabel(product)) + "</div>" +
        '<p class="notice">' + site.escapeHtml(data.notice) + "</p>" +
        '<button type="button" class="btn btn-small ' + (selected ? "btn-secondary" : "btn-primary") +
          '" data-add="' + site.escapeHtml(product.id) + '" aria-pressed="' + selected + '">' + label + "</button>" +
      "</div></article>";
  }

  function renderGrid() {
    var sel = site.quoteSelection();
    var visible = data.products.filter(matches);
    gridEl.innerHTML = visible.map(function (p) {
      return cardHtml(p, (sel[p.id] || 0) > 0);
    }).join("");
    emptyEl.hidden = visible.length > 0;
    countEl.textContent = visible.length + (visible.length === 1 ? " item" : " items") + " shown";
  }

  function toggle(productId) {
    var sel = site.quoteSelection();
    if (sel[productId]) {
      delete sel[productId];
      site.toast("Removed from your quote request.");
    } else {
      sel[productId] = 1;
      site.toast("Added to your quote request.");
    }
    site.setQuoteSelection(sel);
    renderGrid();
  }

  chipsEl.addEventListener("click", function (event) {
    var btn = event.target.closest("[data-id]");
    if (!btn) return;
    state.category = btn.getAttribute("data-id");
    renderChips();
    renderGrid();
  });

  gridEl.addEventListener("click", function (event) {
    var btn = event.target.closest("[data-add]");
    if (!btn) return;
    toggle(btn.getAttribute("data-add"));
  });

  searchEl.addEventListener("input", function () {
    state.query = searchEl.value;
    renderGrid();
  });

  renderChips();
  renderGrid();
})();
