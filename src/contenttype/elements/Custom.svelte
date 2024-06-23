<script lang="ts">
  import { afterUpdate, onDestroy } from "svelte";
  import { Writable } from "svelte/store";

  export let config: MT.ContentType.ConfigSettings;
  export let fieldIndex: number;
  export let fieldsStore: Writable<Array<MT.ContentType.Field>>;
  // svelte-ignore unused-export-let
  export let gather: (() => object) | undefined;
  export let optionsHtmlParams: MT.ContentType.OptionsHtmlParams;

  let customComponentObject: MT.ContentType.CustomComponentObject | null;
  let destroyComponentFunction: (() => void) | null;
  let target: Element;
  let type: string | null;

  $: field = $fieldsStore[fieldIndex];

  afterUpdate(() => {
    if (field.type !== type && customComponentObject) {
      customComponentObject.destroy();
      customComponentObject = null;
    }

    /* @ts-expect-error : window.svelteAdditionalTypes is not defined */
    if (!customComponentObject && window.svelteAdditionalTypes[field.type]) {
      /* @ts-expect-error : window.svelteAdditionalTypes is not defined */
      customComponentObject = window.svelteAdditionalTypes[field.type](
        {
          config: config,
          fieldIndex: fieldIndex,
          fieldsStore: fieldsStore,
          optionsHtmlParams: optionsHtmlParams,
        },
        target,
      );
    }

    type = field.type;
  });

  onDestroy(() => {
    if (customComponentObject) {
      customComponentObject.destroy();
      customComponentObject = null;
    }
    type = null;
  });
</script>

<div
  id="mt-custom-content-field-{field.id}"
  class="mt-custom-content-field__container"
  bind:this={target}
></div>
