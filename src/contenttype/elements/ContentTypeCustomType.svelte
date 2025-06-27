<script lang="ts">
  import { Writable } from "svelte/store";
  import type * as ContentType from "../../@types/contenttype";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  // svelte-ignore unused-export-let
  export let config: ContentType.ConfigSettings;
  export let fieldIndex: number;
  export let fieldsStore: Writable<Array<ContentType.Field>>;
  // svelte-ignore unused-export-let
  export let optionsHtmlParams: ContentType.OptionsHtmlParams;

  const id = `field-options-${$fieldsStore[fieldIndex].id}`;

  export let type: string;
  export let customElement: string;
  export let updateOptions: (options: ContentType.Options) => void;

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

<ContentFieldOptionGroup
  {type}
  bind:field={$fieldsStore[fieldIndex]}
  {id}
  bind:options={$fieldsStore[fieldIndex].options}
>
  <svelte:element
    this={customElement}
    data-options={JSON.stringify($fieldsStore[fieldIndex].options)}
    use:initElement
  />
</ContentFieldOptionGroup>
