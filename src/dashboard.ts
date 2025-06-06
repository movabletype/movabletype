const widgetContainer = document.querySelector(
  "#main-widget-container",
) as HTMLElement;

const baseOrder = 1000;
const updateWidgetLayout = (): void => {
  const widgets: Record<
    string,
    {
      order: number;
      size: "half" | "full";
    }
  > = {};
  document
    .querySelectorAll<HTMLElement>(".mt-widget--resizable")
    .forEach((el, index) => {
      widgets[el.id] = {
        order: baseOrder + (index + 1) / 1000, // 1000.001, 1000.002, ...
        size: el.classList.contains("mt-widget--half") ? "half" : "full",
      };
    });

  const body = new FormData();
  body.append("__mode", "update_widget_prefs");
  body.append("widget_action", "save_layout");
  body.append("xhr", "1");
  body.append("magic_token", widgetContainer.dataset.magicToken as string);
  body.append(
    "widget_scope",
    widgetContainer.dataset.currentWidgetScope as string,
  );
  body.append("widget_layout", JSON.stringify(widgets));

  fetch(window.CMSScriptURI, {
    method: "POST",
    body,
    headers: {
      "X-Requested-With": "XMLHttpRequest",
    },
  })
    .then(async (res) => {
      const data = await res.json();
      if (data.error) {
        throw new Error(data.error);
      }
    })
    .catch((err) => {
      alert(err.message);
    });
};

let isSorting = false;
jQuery(widgetContainer).sortable({
  items: ".mt-widget--resizable",
  handle: ".mt-widget__title .mt-icon",
  tolerance: "pointer",
  start: () => {
    isSorting = true;
  },
  stop: () => {
    isSorting = false;
  },
  update: () => {
    updateWidgetLayout();
  },
});

document
  .querySelectorAll<HTMLElement>(".mt-widget--resizable")
  .forEach((el) => {
    let isFirst = true;
    let resizedWidth: number | undefined;
    const observer = new ResizeObserver((entries) => {
      if (isFirst) {
        isFirst = false;
        return;
      }
      if (isSorting) {
        return;
      }
      for (const entry of entries) {
        if (resizedWidth === undefined) {
          window.addEventListener(
            "mouseup",
            () => {
              if (!resizedWidth) {
                return;
              }
              const containerWidth = el.parentElement!.clientWidth;
              const ratio = resizedWidth / containerWidth;
              resizedWidth = undefined;
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
            },
            {
              once: true,
              passive: true,
            },
          );
        }
        resizedWidth = entry.contentRect.width;
      }
    });

    observer.observe(el);
  });
