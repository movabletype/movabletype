<script lang="ts">
  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  // svelte-ignore unused-export-let
  export let config: MT.ContentType.ConfigSettings;
  export let field: MT.ContentType.Field;
  export let id: string;
  export let isNew: boolean;
  export let label: string;
  export let options: MT.ContentType.Options;
  export let optionsHtmlParams: MT.ContentType.OptionsHtmlParams;

  const textFilters: Array<{ filter_label: string; filter_key: string }> =
    optionsHtmlParams.multi_line_text.text_filters;

  options.input_formats = {};
  textFilters.forEach((filter) => {
    options.input_formats[filter.filter_key] = "";
  });

  if (options.input_format) {
    options.input_formats[options.input_format] = "selected";
  }

  if (isNew) {
    options.full_rich_text = 1;
  }

  if (options.full_rich_text === "0") {
    options.full_rich_text = 0;
  }
</script>

<ContentFieldOptionGroup
  type="multi-line-text"
  fieldId={field.id ?? ""}
  {id}
  {isNew}
  bind:label
  {options}
>
  <ContentFieldOption
    id="multi_line_text-initial_value"
    label={window.trans("Initial Value")}
  >
    <textarea
      {...{ ref: "initial_value" }}
      name="initial_value"
      id="multi_line_text-initial_value"
      class="form-control">{options.initial_value ?? ""}</textarea
    >
  </ContentFieldOption>

  <ContentFieldOption
    id="multi_line_text-input_format"
    label={window.trans("Input format")}
  >
    <select
      {...{ ref: "input_format" }}
      name="input_format"
      id="multi_line_text-input_format"
      class="custom-select form-control form-select"
    >
      {#each textFilters as filter}
        <option
          value={filter.filter_key}
          selected={options.input_formats[filter.filter_key]}
          >{filter.filter_label}</option
        >
      {/each}
    </select>
  </ContentFieldOption>

  <ContentFieldOption
    id="multi_line_text-full_rich_text"
    label={window.trans("Use all rich text decoration buttons")}
  >
    <input
      {...{ ref: "full_rich_text" }}
      type="checkbox"
      class="mt-switch form-control"
      id="multi_line_text-full_rich_text"
      name="full_rich_text"
      checked={options.full_rich_text}
    /><label for="multi_line_text-full_rich_text" class="form-label">
      {window.trans("Use all rich text decoration buttons")}
    </label>
  </ContentFieldOption>
</ContentFieldOptionGroup>
