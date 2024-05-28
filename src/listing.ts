import observable from "@riotjs/observable";

import ListTop from "./listing/elements/ListTop.svelte";

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

export { observable, svelteMountListTop };
