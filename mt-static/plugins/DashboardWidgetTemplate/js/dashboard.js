
(function(l, r) { if (!l || l.getElementById('livereloadscript')) return; r = l.createElement('script'); r.async = 1; r.src = '//' + (self.location.host || 'localhost').split(':')[0] + ':35736/livereload.js?snipver=1'; r.id = 'livereloadscript'; l.getElementsByTagName('head')[0].appendChild(r) })(self.document);
(function () {
    'use strict';

    const initWidgets = () => {
      document.querySelectorAll(".dashboard-widget-template form").forEach((form) => {
        form.action = window.CMSScriptURI;
      });
    };

    initWidgets();

})();
//# sourceMappingURL=dashboard.js.map
