<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  // svelte-ignore unused-export-let
  export let config: ContentType.ConfigSettings;
  export let fieldIndex: number;
  export let fieldsStore: ContentType.FieldsStore;
  // svelte-ignore unused-export-let
  export let optionsHtmlParams: ContentType.OptionsHtmlParams;

  export let type: string;
  export let customElement: string;
  export let updateOptions: (options: ContentType.Options) => void;

  $: field = $fieldsStore[fieldIndex];
  $: options = field.options || {};
  $: id = `field-options-${field.id}`;

  const initElement = (
    el: HTMLElement & { options: ContentType.Options },
  ): void => {
    const options = el.options;
    el.options = new Proxy(options, {
      set(_, property, value) {
        options[property as keyof ContentType.Options] = value;
        $fieldsStore[fieldIndex].options![
          property as keyof ContentType.Options
        ] = value;
        updateOptions(options);
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
