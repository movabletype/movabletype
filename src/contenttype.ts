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
function svelteMountContentFields(props: {
  config: MT.ContentType.ConfigOpts;
  optionsHtmlParams: MT.ContentType.OptionsHtmlParams;
  opts: MT.ContentType.ContentFieldsOpts;
}): void {
  const target = getContentFieldsTarget();
  new ContentFields({
    target: target,
    props: {
      config: props.config,
      optionsHtmlParams: props.optionsHtmlParams,
      opts: props.opts,
      root: target,
    },
  });
}

export { observable, svelteMountContentFields };
