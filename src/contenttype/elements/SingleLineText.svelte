<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  // svelte-ignore unused-export-let
  export let config: ContentType.ConfigSettings;
  export let field: ContentType.Field;
  // svelte-ignore unused-export-let
  export let gather = null;
  export let id: string;
  export let options: ContentType.Options;
  // svelte-ignore unused-export-let
  export let optionsHtmlParams: ContentType.OptionsHtmlParams;

  options.min_length ??= 0;
  options.max_length ??= 255;
  options.initial_value ??= "";
</script>

<ContentFieldOptionGroup type="single-line-text" bind:field {id} bind:options>
  <ContentFieldOption
    id="single_line_text-min_length"
    label={window.trans("Min Length")}
  >
    <input
      {...{ ref: "min_length" }}
      type="number"
      name="min_length"
      id="single_line_text-min_length"
      class="form-control w-25"
      min="0"
      bind:value={options.min_length}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="single_line_text-max_length"
    label={window.trans("Max Length")}
  >
    <input
      {...{ ref: "max_length" }}
      type="number"
      name="max_length"
      id="single_line_text-max_length"
      class="form-control w-25"
      min="1"
      bind:value={options.max_length}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="single_line_text-initial_value"
    label={window.trans("Initial Value")}
  >
    <input
      {...{ ref: "initial_value" }}
      type="text"
      name="initial_value"
      id="single_line_text-initial_value"
      class="form-control"
      bind:value={options.initial_value}
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
