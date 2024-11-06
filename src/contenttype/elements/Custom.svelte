<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import { afterUpdate, onDestroy } from "svelte";

  import ContentFieldTypes from "../ContentFieldTypes";

  export let config: ContentType.ConfigSettings;
  export let fieldIndex: number;
  export let fieldsStore: ContentType.FieldsStore;
  export let gather: (() => object) | null | undefined;
  export let optionsHtmlParams: ContentType.OptionsHtmlParams;

  let customContentFieldObject: ContentType.CustomContentFieldObject | null;
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
  id="custom-content-field-block-{field.id}"
  class="mt-custom-contentfield"
  bind:this={target}
></div>
