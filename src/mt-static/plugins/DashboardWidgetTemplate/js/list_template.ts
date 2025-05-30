const label = document.querySelector<HTMLScriptElement>(
  "script[data-dashboard-widget-template-widget-l10n-dashboard-widget]",
)?.dataset.dashboardWidgetTemplateWidgetL10nDashboardWidget as string;

const newTemplateType = document.querySelector(
  "#new-template-type",
) as HTMLSelectElement;
const option = document.createElement("option");
option.value = "dashboard_widget";
option.textContent = label;
const widgetOption = newTemplateType.querySelector(
  `option[value*="edit_widget"]`,
);
newTemplateType.insertBefore(option, widgetOption);

const quickFilterWidgetSet = document.querySelector(
  `#quickfilters #widget-set-tab`,
) as HTMLElement;
const quickFilterDashboardWidgetSource = quickFilterWidgetSet.outerHTML.replace(
  /widget-set/g,
  "dashboard_widget",
);
const quickFilterTemplate = document.createElement("template");
quickFilterTemplate.innerHTML = quickFilterDashboardWidgetSource;
const quickFilterDashboardWidget = quickFilterTemplate.content;
(
  quickFilterDashboardWidget.querySelector("a") as HTMLAnchorElement
).textContent = label;
quickFilterWidgetSet.parentNode?.insertBefore(
  quickFilterDashboardWidget,
  quickFilterWidgetSet,
);

document
  .querySelector(
    `#actions-bar-top-dashboard_widget-listing-form option[value="refresh_tmpl_templates"]`,
  )
  ?.remove();
