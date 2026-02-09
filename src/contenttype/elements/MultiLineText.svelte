<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  let {
    config: _config,
    field = $bindable(),
    gather = $bindable(),
    id,
    options = $bindable(),
    optionsHtmlParams,
  }: ContentType.ContentFieldProps = $props();

  // svelte-ignore state_referenced_locally
  const textFilters: Array<{ filter_label: string; filter_key: string }> =
    optionsHtmlParams.multi_line_text.text_filters;

  let displayOptions = $derived({
    ...options,
    initial_value: options.initial_value ?? "",
    full_rich_text: field.isNew
      ? true
      : options.full_rich_text === 1 ||
        options.full_rich_text === "1" ||
        options.full_rich_text === true,
  });
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
      value={displayOptions.initial_value}
      onchange={(e) => {
        options.initial_value = e.currentTarget.value;
      }}
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
    <input
      {...{ ref: "full_rich_text" }}
      type="checkbox"
      class="mt-switch form-control"
      id="multi_line_text-full_rich_text"
      name="full_rich_text"
      checked={displayOptions.full_rich_text}
      onchange={(e) => {
        options.full_rich_text = e.currentTarget.checked ? 1 : 0;
      }}
    /><label for="multi_line_text-full_rich_text" class="form-label">
      {window.trans("Use all rich text decoration buttons")}
    </label>
  </ContentFieldOption>
</ContentFieldOptionGroup>
