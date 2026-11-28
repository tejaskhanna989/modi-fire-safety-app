(function () {
  "use strict";

  var site = window.ModiSite;
  var form = document.getElementById("service-form");
  var resultEl = document.getElementById("result");
  var TYPE_LABELS = { servicing: "Servicing", refilling: "Refilling", inspection: "Inspection" };

  var dateEl = document.getElementById("s-date");
  var today = new Date();
  dateEl.min = new Date(today.getTime() - today.getTimezoneOffset() * 60000).toISOString().slice(0, 10);

  function setError(id, message) {
    var el = document.getElementById(id + "-err");
    if (el) el.textContent = message || "";
    var field = document.querySelector('[data-field="' + id + '"]');
    if (field) field.classList.toggle("invalid", !!message);
  }

  form.addEventListener("submit", function (event) {
    event.preventDefault();
    var f = form.elements;
    var checks = [
      ["equipment", f.equipment.value.trim() !== "", "Describe the equipment or enter its asset tag."],
      ["location", f.location.value.trim() !== "", "Enter the site or location."],
      ["date", f.date.value !== "" && f.date.value >= dateEl.min, "Choose a preferred date from today onward."]
    ];
    var ok = true;
    checks.forEach(function (c) {
      setError(c[0], c[1] ? "" : c[2]);
      if (!c[1]) ok = false;
    });
    if (!ok) {
      var firstInvalid = form.querySelector(".invalid input, .invalid textarea");
      if (firstInvalid) firstInvalid.focus();
      return;
    }

    var type = form.querySelector('input[name="type"]:checked').value;
    var request = {
      id: site.reference("SV"),
      createdAt: new Date().toISOString(),
      type: type,
      typeLabel: TYPE_LABELS[type],
      equipment: f.equipment.value.trim(),
      location: f.location.value.trim(),
      preferredDate: f.date.value,
      notes: f.notes.value.trim(),
      status: "SUBMITTED"
    };
    var list = site.readJson(site.KEYS.services, []);
    list.push(request);
    site.writeJson(site.KEYS.services, list);

    form.hidden = true;
    resultEl.innerHTML =
      '<span class="badge ok">Demo request saved</span>' +
      '<h2 style="margin-top:var(--space-3)">' + site.escapeHtml(request.typeLabel) + " request received</h2>" +
      '<p>Your reference is <span class="ref">' + site.escapeHtml(request.id) + "</span>. Preferred date: " +
      site.escapeHtml(request.preferredDate) + ".</p>" +
      '<p class="muted small">This is a demo. The request is stored in this browser and no technician has been dispatched.</p>' +
      '<div class="actions"><a class="btn btn-primary" href="requests.html">View my requests</a>' +
      '<a class="btn btn-secondary" href="services.html">Make another request</a></div>';
    resultEl.hidden = false;
    resultEl.focus();
  });
})();
