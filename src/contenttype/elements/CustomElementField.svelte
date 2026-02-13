<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  type Props = {
    config: ContentType.ConfigSettings;
    fieldIndex: number;
    fieldsStore: ContentType.FieldsStore;
    optionsHtmlParams: ContentType.OptionsHtmlParams;
    type: string;
    customElement: string;
    updateOptions: (options: ContentType.Options) => void;
  };
  let {
    config: _config,
    fieldIndex,
    fieldsStore,
    optionsHtmlParams: _optionsHtmlParams,
    type,
    customElement,
    updateOptions,
  }: Props = $props();

  let field = $derived($fieldsStore[fieldIndex]);
  let options = $derived(field.options || {});
  let id = $derived(`field-options-${field.id}`);

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
