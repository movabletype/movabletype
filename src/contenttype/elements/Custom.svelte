<script lang="ts">
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

  let customContentFieldObject = $state<ContentType.CustomContentFieldObject | null>(null);
  let target = $state<Element | null>(null);
  let type = $state<string | null>(null);

  let field = $derived($fieldsStore[fieldIndex]);
  let customContentFieldMountFunction = $derived(
    ContentFieldTypes.getCustomType(field.type),
  );

  $effect(() => {
    if (field.type !== type && customContentFieldObject) {
      customContentFieldObject.destroy();
      customContentFieldObject = null;
      gather = null;
    }

    if (!customContentFieldObject && customContentFieldMountFunction && target) {
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

    return () => {
      if (customContentFieldObject) {
        gather = null;
        customContentFieldObject.destroy();
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
