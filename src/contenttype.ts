import observable from "@riotjs/observable";

import ContentTypeEditor from "./contenttype/ContentTypeEditor";

declare global {
  interface Window {
    ContentTypeEditor: ContentTypeEditor;
    riot: any; // eslint-disable-line @typescript-eslint/no-explicit-any
  }
}

const getConfigName = (key: string): string => {
  const tmp = key.substring(6);
  return tmp.substring(0, 1).toUpperCase() + tmp.substring(1);
};

if (!window.riot) {
  window.riot = {};
}
window.riot.observable = observable;
window.ContentTypeEditor = ContentTypeEditor;

const scriptContenttype = document.getElementById("script-contenttype");
if (scriptContenttype) {
  for (const key in scriptContenttype.dataset) {
    if (!key.startsWith("config")) {
      continue;
    }
    const configName = getConfigName(key);
    if (configName === "") {
      continue;
    }
    ContentTypeEditor.config[configName] = scriptContenttype.dataset[key];
  }

  if ("optionsHtmlParams" in scriptContenttype.dataset) {
    let optionsHtmlParams = {};
    try {
      optionsHtmlParams = JSON.parse(
        scriptContenttype.dataset["optionsHtmlParams"] || "{}",
      );
    } catch (error) {
      console.log(error);
    }
    ContentTypeEditor.optionsHtmlParams = optionsHtmlParams;
  }
}
