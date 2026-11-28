/* Shared behaviour for the customer website (MVP demo).
 * Everything here runs in the browser. Nothing is sent to a server.
 */
(function () {
  "use strict";

  var KEYS = {
    quote: "modi.demo.quoteSelection",
    quotes: "modi.demo.quoteRequests",
    services: "modi.demo.serviceRequests"
  };

  function readJson(key, fallback) {
    try {
      var raw = window.localStorage.getItem(key);
      return raw ? JSON.parse(raw) : fallback;
    } catch (e) {
      return fallback;
    }
  }

  function writeJson(key, value) {
    try {
      window.localStorage.setItem(key, JSON.stringify(value));
    } catch (e) {
      /* Storage can be disabled (private mode). The demo still works in memory. */
    }
  }

  function escapeHtml(value) {
    return String(value).replace(/[&<>"']/g, function (c) {
      return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c];
    });
  }

  function formatAmount(value) {
    var digits = String(Math.round(value));
    var out = "";
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 === 0) out += ",";
      out += digits[i];
    }
    return out;
  }

  function priceLabel(product) {
    return product.currency + formatAmount(product.price);
  }

  function reference(prefix) {
    var stamp = Date.now().toString(36).toUpperCase().slice(-5);
    var rand = Math.floor(Math.random() * 1296).toString(36).toUpperCase().padStart(2, "0");
    return prefix + "-DEMO-" + stamp + rand;
  }

  function toast(message) {
    var el = document.getElementById("toast");
    if (!el) {
      el = document.createElement("div");
      el.id = "toast";
      el.className = "toast";
      el.setAttribute("role", "status");
      el.setAttribute("aria-live", "polite");
      document.body.appendChild(el);
    }
    el.textContent = message;
    el.classList.add("show");
    clearTimeout(toast._t);
    toast._t = setTimeout(function () { el.classList.remove("show"); }, 2600);
  }

  function quoteSelection() {
    return readJson(KEYS.quote, {});
  }

  function setQuoteSelection(selection) {
    writeJson(KEYS.quote, selection);
    updateQuoteCount();
  }

  function selectionCount() {
    var sel = quoteSelection();
    return Object.keys(sel).reduce(function (n, id) { return n + (sel[id] > 0 ? 1 : 0); }, 0);
  }

  function updateQuoteCount() {
    var count = selectionCount();
    document.querySelectorAll("[data-quote-count]").forEach(function (el) {
      el.textContent = count;
      el.hidden = count === 0;
    });
  }

  function setupNav() {
    var toggle = document.querySelector(".nav-toggle");
    var nav = document.getElementById("site-nav");
    if (!toggle || !nav) return;
    toggle.addEventListener("click", function () {
      var open = nav.classList.toggle("open");
      toggle.setAttribute("aria-expanded", open ? "true" : "false");
    });
  }

  function init() {
    setupNav();
    updateQuoteCount();
  }

  window.ModiSite = {
    KEYS: KEYS,
    readJson: readJson,
    writeJson: writeJson,
    escapeHtml: escapeHtml,
    formatAmount: formatAmount,
    priceLabel: priceLabel,
    reference: reference,
    toast: toast,
    quoteSelection: quoteSelection,
    setQuoteSelection: setQuoteSelection,
    updateQuoteCount: updateQuoteCount
  };

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
