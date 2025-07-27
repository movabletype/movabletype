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
  export let optionsHtmlParams: ContentType.OptionsHtmlParams;

  const textFilters: Array<{ filter_label: string; filter_key: string }> =
    optionsHtmlParams.multi_line_text.text_filters;

  if (field.isNew) {
    options.full_rich_text = 1;
  }

  if (options.full_rich_text === "0") {
    options.full_rich_text = 0;
  }

  // changeStateFullRichText was removed because unused

  options.initial_value ??= "";
</script>

<ContentFieldOptionGroup type="multi-line-text" bind:field {id} bind:options>
  <ContentFieldOption
    id="multi_line_text-initial_value"
    label={window.trans("Initial Value")}
  >
    <textarea
      {...{ ref: "initial_value" }}
      name="initial_value"
      id="multi_line_text-initial_value"
      class="form-control"
      bind:value={options.initial_value}
    ></textarea>
  </ContentFieldOption>

  <ContentFieldOption
    id="multi_line_text-input_format"
    label={window.trans("Input format")}
  >
    <!-- selected was removed and bind is used -->
    <select
      {...{ ref: "input_format" }}
      name="input_format"
      id="multi_line_text-input_format"
      class="custom-select form-control form-select"
      bind:value={options.input_format}
    >
      {#each textFilters as filter}
        <option value={filter.filter_key}>{filter.filter_label}</option>
      {/each}
    </select>
  </ContentFieldOption>

  <ContentFieldOption
    id="multi_line_text-full_rich_text"
    label={window.trans("Use all rich text decoration buttons")}
  >
    <!-- onclick was removed and bind is used -->
    <input
      {...{ ref: "full_rich_text" }}
      type="checkbox"
      class="mt-switch form-control"
      id="multi_line_text-full_rich_text"
      name="full_rich_text"
      bind:checked={options.full_rich_text}
    /><label for="multi_line_text-full_rich_text" class="form-label">
      {window.trans("Use all rich text decoration buttons")}
    </label>
  </ContentFieldOption>
</ContentFieldOptionGroup>
