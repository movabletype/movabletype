
(function(l, r) { if (!l || l.getElementById('livereloadscript')) return; r = l.createElement('script'); r.async = 1; r.src = '//' + (self.location.host || 'localhost').split(':')[0] + ':35738/livereload.js?snipver=1'; r.id = 'livereloadscript'; l.getElementsByTagName('head')[0].appendChild(r) })(self.document);
(function () {
    'use strict';

    var _a, _b, _c;
    const label = (_a = document.querySelector("script[data-dashboard-widget-template-widget-l10n-dashboard-widget]")) === null || _a === void 0 ? void 0 : _a.dataset.dashboardWidgetTemplateWidgetL10nDashboardWidget;
    const newTemplateType = document.querySelector("#new-template-type");
    if (newTemplateType) {
      const option = document.createElement("option");
      option.value = "dashboard_widget";
      option.textContent = label;
      const widgetOption = newTemplateType.querySelector(`option[value*="edit_widget"]`);
      newTemplateType.insertBefore(option, widgetOption);
    }
    const quickFilterWidgetSet = document.querySelector(`#quickfilters #widget-set-tab`);
    if (quickFilterWidgetSet) {
      const quickFilterDashboardWidgetSource = quickFilterWidgetSet.outerHTML.replace(/widget-set/g, "dashboard_widget");
      const quickFilterTemplate = document.createElement("template");
      quickFilterTemplate.innerHTML = quickFilterDashboardWidgetSource;
      const quickFilterDashboardWidget = quickFilterTemplate.content;
      quickFilterDashboardWidget.querySelector("a").textContent = label;
      (_b = quickFilterWidgetSet.parentNode) === null || _b === void 0 ? void 0 : _b.insertBefore(quickFilterDashboardWidget, quickFilterWidgetSet);
    }
    (_c = document.querySelector(`#actions-bar-top-dashboard_widget-listing-form option[value="refresh_tmpl_templates"]`)) === null || _c === void 0 ? void 0 : _c.remove();

})();
//# sourceMappingURL=list_template.js.map
