import type { uploadAssets } from "./api/uploadAssets";
import type { sendHttpRequest } from "./api/sendHttpRequest";
import type { getJSON } from "./api/getJSON";
import type { Alert } from "./api/Alert";
import type { Logger } from "./api/Logger";

declare global {
  interface MTAPIMap {
    uploadAssets: typeof uploadAssets;
    sendHttpRequest: typeof sendHttpRequest;
    getJSON: typeof getJSON;
    Alert: typeof Alert;
    Logger: typeof Logger;
  }
}

export function exportAll(): void {
  ["uploadAssets", "sendHttpRequest", "getJSON", "Alert", "Logger"].forEach(
    async (k) => {
      const { resolve } = await window.MT.export(k);
      const module = await import(`./${k}.js`);
      resolve(module[k]);
    },
  );
}
