<script lang="ts">
  import { untrack } from "svelte";
  import type * as ContentType from "../../@types/contenttype";

  import ContentFieldTypes from "../ContentFieldTypes";

  let {
    config,
    fieldIndex,
    fieldsStore,
    gather = $bindable(),
    optionsHtmlParams,
  }: {
    config: ContentType.ConfigSettings;
    fieldIndex: number;
    fieldsStore: ContentType.FieldsStore;
    gather: (() => object) | null | undefined;
    optionsHtmlParams: ContentType.OptionsHtmlParams;
  } = $props();

  let customContentFieldObject =
    $state<ContentType.CustomContentFieldObject | null>(null);
  let target = $state<Element | null>(null);
  let type = $state<string | null>(null);

  let field = $derived($fieldsStore[fieldIndex]);
  let customContentFieldMountFunction = $derived(
    ContentFieldTypes.getCustomType(field.type),
  );

  $effect(() => {
    const currentFieldType = field.type;
    const currentType = untrack(() => type);
    const currentObject = untrack(() => customContentFieldObject);

    if (currentFieldType !== currentType && currentObject) {
      currentObject.destroy();
      customContentFieldObject = null;
      gather = null;
    }

    if (
      !untrack(() => customContentFieldObject) &&
      customContentFieldMountFunction &&
      target
    ) {
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

    type = currentFieldType;

    return () => {
      if (untrack(() => customContentFieldObject)) {
        gather = null;
        customContentFieldObject?.destroy();
        customContentFieldObject = null;
      }
      type = null;
    };
  });
</script>

<!-- added block in Svelte implementation -->
<div
  id="custom-content-field-block-{field.id}"
  class="mt-custom-contentfield"
  bind:this={target}
></div>
