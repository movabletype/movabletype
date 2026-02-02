
(function(l, r) { if (!l || l.getElementById('livereloadscript')) return; r = l.createElement('script'); r.async = 1; r.src = '//' + (self.location.host || 'localhost').split(':')[0] + ':35737/livereload.js?snipver=1'; r.id = 'livereloadscript'; l.getElementsByTagName('head')[0].appendChild(r) })(self.document);
(function () {
    'use strict';

    var _a;
    if (document.querySelector(`[name="type"][value="dashboard_widget"]`)) {
      (_a = document.querySelector(`[name="name"]`)) === null || _a === void 0 ? void 0 : _a.remove();
      const nameInput = document.querySelector(`[name="name_display"]`);
      nameInput.name = "name";
      nameInput.disabled = false;
      document.querySelectorAll(`#useful-links a[href$="#system"], .plugin-actions`).forEach((el) => el.classList.add("d-none"));
    }

})();
//# sourceMappingURL=edit_template.js.map
