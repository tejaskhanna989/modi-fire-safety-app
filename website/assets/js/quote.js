(function () {
  "use strict";

  var data = window.MODI_DATA;
  var site = window.ModiSite;

  var form = document.getElementById("quote-form");
  var linesEl = document.getElementById("product-lines");
  var resultEl = document.getElementById("result");

  function renderLines() {
    var sel = site.quoteSelection();
    linesEl.innerHTML = data.products.map(function (p) {
      var qty = sel[p.id] || 0;
      var checked = qty > 0 ? " checked" : "";
      var value = qty > 0 ? qty : 1;
      return '<div class="qty-row">' +
        '<label class="name"><input type="checkbox" data-check="' + site.escapeHtml(p.id) + '"' + checked + '>' +
        site.escapeHtml(p.name) + ' <span class="muted small">(' + site.escapeHtml(site.priceLabel(p)) + ")</span></label>" +
        '<label><span class="sr-only" style="position:absolute;left:-9999px">Quantity for ' + site.escapeHtml(p.name) + '</span>' +
        '<input type="number" min="1" max="999" step="1" value="' + value + '" data-qty="' + site.escapeHtml(p.id) +
        '" aria-label="Quantity for ' + site.escapeHtml(p.name) + '"></label>' +
        "</div>";
    }).join("");
  }

  function setError(id, message) {
    var el = document.getElementById("q-" + id + "-err");
    if (el) el.textContent = message || "";
    var field = document.querySelector('[data-field="' + id + '"]');
    if (field) field.classList.toggle("invalid", !!message);
  }

  function validEmail(value) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
  }

  linesEl.addEventListener("change", function (event) {
    var target = event.target;
    var sel = site.quoteSelection();
    if (target.hasAttribute("data-check")) {
      var id = target.getAttribute("data-check");
      var qtyInput = linesEl.querySelector('[data-qty="' + id + '"]');
      if (target.checked) {
        sel[id] = Math.max(1, parseInt(qtyInput.value, 10) || 1);
      } else {
        delete sel[id];
      }
    } else if (target.hasAttribute("data-qty")) {
      var pid = target.getAttribute("data-qty");
      var qty = Math.max(1, Math.min(999, parseInt(target.value, 10) || 1));
      target.value = qty;
      if (sel[pid]) sel[pid] = qty;
      var box = linesEl.querySelector('[data-check="' + pid + '"]');
      if (box && !box.checked) box.checked = true;
      if (box && box.checked && !sel[pid]) sel[pid] = qty;
    }
    site.setQuoteSelection(sel);
  });

  form.addEventListener("submit", function (event) {
    event.preventDefault();
    var f = form.elements;
    var ok = true;

    var checks = [
      ["name", f.name.value.trim() !== "", "Enter the company or customer name."],
      ["contact", f.contact.value.trim() !== "", "Enter the contact person."],
      ["phone", f.phone.value.trim() !== "", "Enter a phone number."],
      ["email", f.email.value.trim() !== "" && validEmail(f.email.value.trim()), "Enter a valid email address."]
    ];
    checks.forEach(function (c) {
      setError(c[0], c[1] ? "" : c[2]);
      if (!c[1]) ok = false;
    });

    var sel = site.quoteSelection();
    var lines = data.products.filter(function (p) { return (sel[p.id] || 0) > 0; })
      .map(function (p) { return { id: p.id, name: p.name, quantity: sel[p.id], unitPrice: p.price, currency: p.currency }; });
    document.getElementById("lines-err").textContent = lines.length ? "" : "Select at least one product.";
    if (!lines.length) ok = false;

    if (!ok) {
      var firstInvalid = form.querySelector(".invalid input, .invalid textarea");
      if (firstInvalid) firstInvalid.focus();
      return;
    }

    var request = {
      id: site.reference("QT"),
      createdAt: new Date().toISOString(),
      name: f.name.value.trim(),
      contact: f.contact.value.trim(),
      phone: f.phone.value.trim(),
      email: f.email.value.trim(),
      notes: f.notes.value.trim(),
      lines: lines,
      status: "SUBMITTED"
    };
    var list = site.readJson(site.KEYS.quotes, []);
    list.push(request);
    site.writeJson(site.KEYS.quotes, list);
    site.setQuoteSelection({});

    form.hidden = true;
    resultEl.innerHTML =
      '<span class="badge ok">Demo request saved</span>' +
      '<h2 style="margin-top:var(--space-3)">Thank you, ' + site.escapeHtml(request.contact) + ".</h2>" +
      '<p>Your reference is <span class="ref">' + site.escapeHtml(request.id) + "</span>. Keep it for any follow-up.</p>" +
      '<p class="muted small">This is a demo. The request is stored in this browser and was not sent to Modi International.</p>' +
      '<div class="actions"><a class="btn btn-primary" href="requests.html">View my requests</a>' +
      '<a class="btn btn-secondary" href="catalogue.html">Back to catalogue</a></div>';
    resultEl.hidden = false;
    resultEl.focus();
  });

  renderLines();
})();
