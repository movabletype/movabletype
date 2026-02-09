<script lang="ts">
  import { onMount } from "svelte";
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

  onMount(() => {
    if (field.isNew) {
      options.full_rich_text = 1;
    }

    if (options.full_rich_text === "0") {
      options.full_rich_text = 0;
    }

    // changeStateFullRichText was removed because unused

    options.initial_value ??= "";
  });
</script>

<ContentFieldOptionGroup type="multi-line-text" bind:field {id} {options}>
  <ContentFieldOption
    id="multi_line_text-initial_value"
    label={window.trans("Initial Value")}
  >
    <textarea
      {...{ ref: "initial_value" }}
      name="initial_value"
      id="multi_line_text-initial_value"
      class="form-control"
      value={options.initial_value}
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
      value={options.input_format}
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
      checked={options.full_rich_text}
    /><label for="multi_line_text-full_rich_text" class="form-label">
      {window.trans("Use all rich text decoration buttons")}
    </label>
  </ContentFieldOption>
</ContentFieldOptionGroup>
