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
    optionsHtmlParams: _optionsHtmlParams,
  }: ContentType.ContentFieldProps = $props();

  let displayOptions = $derived({
    ...options,
    min_length: options.min_length ?? 0,
    max_length: options.max_length ?? 255,
    initial_value: options.initial_value ?? "",
  });
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
      value={displayOptions.min_length}
      onchange={(e) => {
        options.min_length = e.currentTarget.value;
      }}
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
      value={displayOptions.max_length}
      onchange={(e) => {
        options.max_length = e.currentTarget.value;
      }}
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
      value={displayOptions.initial_value}
      onchange={(e) => {
        options.initial_value = e.currentTarget.value;
      }}
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
