import observable from "@riotjs/observable";

import ListTop from "./listing/elements/ListTop.svelte";

declare global {
  interface Window {
    riot: any; // eslint-disable-line @typescript-eslint/no-explicit-any
    svelteMountListTop: (props: any) => void; // eslint-disable-line @typescript-eslint/no-explicit-any
  }
}

function getListTopTarget(): Element {
  const listTopTarget = document.querySelector('[data-is="list-top"]');
  if (!listTopTarget) {
    throw new Error("Target element is not found");
  }
  return listTopTarget;
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
function svelteMountListTop(props: any): void {
  new ListTop({
    target: getListTopTarget(),
    props: props,
  });
}

if (!window.riot) {
  window.riot = {};
}
window.riot.observable = observable;
window.svelteMountListTop = svelteMountListTop;
