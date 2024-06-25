<script lang="ts">
  import { afterUpdate, onDestroy } from "svelte";

  import ContentFieldTypes from "../ContentFieldTypes";

  export let config: MT.ContentType.ConfigSettings;
  export let fieldIndex: number;
  export let fieldsStore: MT.ContentType.FieldsStore;
  export let gather: (() => object) | null | undefined;
  export let optionsHtmlParams: MT.ContentType.OptionsHtmlParams;

  let customContentFieldObject: MT.ContentType.CustomContentFieldObject | null;
  let target: Element;
  let type: string | null;

  $: field = $fieldsStore[fieldIndex];
  $: customContentFieldMountFunction = ContentFieldTypes.getCustomType(
    field.type,
  );

  afterUpdate(() => {
    if (field.type !== type && customContentFieldObject) {
      customContentFieldObject.destroy();
      customContentFieldObject = null;
      gather = null;
    }

    if (!customContentFieldObject && customContentFieldMountFunction) {
      customContentFieldObject = customContentFieldMountFunction(
        {
          config: config,
          fieldIndex: fieldIndex,
          fieldsStore: fieldsStore,
          optionsHtmlParams: optionsHtmlParams,
        },
        target,
      );
      gather = customContentFieldObject?.gather;
    }

    type = field.type;
  });

  onDestroy(() => {
    if (customContentFieldObject) {
      gather = null;
      customContentFieldObject.destroy();
      customContentFieldObject = null;
    }
    type = null;
  });
</script>

<!-- added block in Svelte implementation -->
<div
  id="mt-custom-content-field-{field.id}"
  class="mt-custom-content-field__container"
  bind:this={target}
></div>
