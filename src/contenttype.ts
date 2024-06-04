import observable from "@riotjs/observable";

import ContentFields from "./contenttype/elements/ContentFields.svelte";

function getContentFieldsTarget(): Element {
  const target = document.querySelector('[data-is="content-fields"]');
  if (!target) {
    throw new Error("Target element is not found");
  }
  return target;
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
function svelteMountContentFields(props: any): void {
  new ContentFields({
    target: getContentFieldsTarget(),
    props: props
  });
}

export { observable, svelteMountContentFields };
