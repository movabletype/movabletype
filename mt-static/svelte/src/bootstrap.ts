import { Exporter } from "./exporter";
import { UI } from "./ui";
import { exportAll as exportAllAPI } from "./api";
import ComponentList from "../svelte/ComponentList.svelte"

type TypeOfExporter = typeof Exporter;
export declare interface MT extends TypeOfExporter {
  UI: typeof UI;
}

declare global {
  interface Window {
    MT: MT;
  }
}

const MT = {
  UI,
  ...Exporter,
};
if (window.MT) {
  Object.assign(window.MT, MT);
} else {
  window.MT = MT;
}

exportAllAPI();

export {};
