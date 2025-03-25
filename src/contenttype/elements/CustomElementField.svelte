<script lang="ts">
  import { untrack } from "svelte";
  import type * as ContentType from "../../@types/contenttype";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  type Props = {
    config?: ContentType.ConfigSettings;
    fieldIndex: number;
    fieldsStore: ContentType.FieldsStore;
    optionsHtmlParams?: ContentType.OptionsHtmlParams;
    type: string;
    customElement: string;
    updateOptions: (options: ContentType.Options) => void;
  };
  let { fieldIndex, fieldsStore, type, customElement, updateOptions }: Props =
    $props();

  let field = $state<ContentType.Field>({} as ContentType.Field);
  let options = $state<ContentType.Options>({});
  let id = $derived(`field-options-${field.id}`);

  $effect(() => {
    const storeField = $fieldsStore[fieldIndex];
    if (!storeField) return;
    untrack(() => {
      field = { ...storeField };
      options = { ...(storeField.options || {}) };
    });
  });

  const initElement = (
    el: HTMLElement & { options: ContentType.Options },
  ): void => {
    const elOptions = el.options;
    el.options = new Proxy(elOptions, {
      set(_, property, value) {
        elOptions[property as keyof ContentType.Options] = value;
        const fieldStore = $fieldsStore[fieldIndex];
        if (fieldStore.options) {
          fieldStore.options[property as keyof ContentType.Options] = value;
        }
        updateOptions(elOptions);
        return value;
      },
    });
  };
</script>

<ContentFieldOptionGroup {type} bind:field {id} bind:options>
  <svelte:element
    this={customElement}
    data-options={JSON.stringify(options)}
    use:initElement
  />
</ContentFieldOptionGroup>
