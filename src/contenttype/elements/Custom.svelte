<script lang="ts">
  import { afterUpdate, onDestroy } from "svelte";
  import { Writable } from "svelte/store";

  export let config: MT.ContentType.ConfigSettings;
  export let fieldIndex: number;
  export let fieldsStore: Writable<Array<MT.ContentType.Field>>;
  // svelte-ignore unused-export-let
  export let gather: (() => object) | undefined;
  export let optionsHtmlParams: MT.ContentType.OptionsHtmlParams;

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  let component: any;
  let target: Element;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  let type: any;

  afterUpdate(() => {
    const field = $fieldsStore[fieldIndex];

    if (type !== field.type && component) {
      component.$destroy();
      component = null;
    }

    type = field.type;

    if (component) {
      component.fieldIndex = fieldIndex;
      component.fieldsStore = fieldsStore;
      component.id = `field-options-${field.id}`;
      /* @ts-expect-error : window.svelteAdditionalTypes is not defined */
    } else if (window.svelteAdditionalTypes[field.type]) {
      /* @ts-expect-error : window.svelteAdditionalTypes is not defined */
      component = window.svelteAdditionalTypes[field.type](
        {
          config: config,
          fieldIndex: fieldIndex,
          fieldsStore: fieldsStore,
          id: `field-options-${field.id}`,
          optionsHtmlParams: optionsHtmlParams,
        },
        target,
      );
    }
  });

  onDestroy(() => {
    if (component) {
      component.$destroy();
      component = null;
    }
    type = null;
  });
</script>

<div class="custom-content-field-container" bind:this={target}></div>
