
(function(l, r) { if (!l || l.getElementById('livereloadscript')) return; r = l.createElement('script'); r.async = 1; r.src = '//' + (self.location.host || 'localhost').split(':')[0] + ':35731/livereload.js?snipver=1'; r.id = 'livereloadscript'; l.getElementsByTagName('head')[0].appendChild(r) })(self.document);
const widgetContainer = document.querySelector("#main-widget-container");
const baseOrder = 1e3;
const updateWidgetLayout = () => {
  const widgets = {};
  document.querySelectorAll(".mt-widget--resizable").forEach((el, index) => {
    widgets[el.id] = {
      order: baseOrder + (index + 1) / 1e3,
      // 1000.001, 1000.002, ...
      size: el.classList.contains("mt-widget--half") ? "half" : "full"
    };
  });
  const body = new FormData();
  body.append("__mode", "update_widget_prefs");
  body.append("widget_action", "save_layout");
  body.append("xhr", "1");
  body.append("magic_token", widgetContainer.dataset.magicToken);
  body.append("widget_scope", widgetContainer.dataset.currentWidgetScope);
  body.append("widget_layout", JSON.stringify(widgets));
  fetch(window.CMSScriptURI, {
    method: "POST",
    body,
    headers: {
      "X-Requested-With": "XMLHttpRequest"
    }
  }).then(async (res) => {
    const data = await res.json();
    if (data.error) {
      throw new Error(data.error);
    }
  }).catch((err) => {
    alert(err.message);
  });
};
let isSorting = false;
jQuery(widgetContainer).sortable({
  items: ".mt-widget--resizable",
  handle: ".mt-widget__title .mt-icon",
  placeholder: "placeholder",
  forcePlaceholderSize: true,
  tolerance: "pointer",
  start: () => {
    isSorting = true;
    jQuery(widgetContainer).sortable("refreshPositions");
  },
  stop: () => {
    isSorting = false;
  },
  update: () => {
    updateWidgetLayout();
  }
});
document.querySelectorAll(".mt-widget--resizable").forEach((el) => {
  let isFirst = true;
  let resizedWidth;
  const observer = new ResizeObserver((entries) => {
    if (isFirst) {
      isFirst = false;
      return;
    }
    if (isSorting) {
      return;
    }
    for (const entry of entries) {
      if (resizedWidth === void 0) {
        window.addEventListener("mouseup", () => {
          if (!resizedWidth) {
            return;
          }
          const containerWidth = el.parentElement.clientWidth;
          const ratio = resizedWidth / containerWidth;
          resizedWidth = void 0;
          setTimeout(() => {
            el.style.width = "";
            let changed = false;
            if (ratio > 0.7) {
              if (el.classList.contains("mt-widget--half")) {
                el.classList.remove("mt-widget--half");
                changed = true;
              }
            } else {
              if (!el.classList.contains("mt-widget--half")) {
                el.classList.add("mt-widget--half");
                changed = true;
              }
            }
            if (changed) {
              updateWidgetLayout();
            }
          });
        }, {
          once: true,
          passive: true
        });
      }
      resizedWidth = entry.contentRect.width;
    }
  });
  observer.observe(el);
});
//# sourceMappingURL=dashboard.js.map
