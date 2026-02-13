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
    initial_value: options.initial_value ?? "",
  });
</script>

<ContentFieldOptionGroup type="time-only" bind:field {id} bind:options>
  <ContentFieldOption
    id="time_only-initial-value"
    label={window.trans("Initial Value")}
  >
    <input
      {...{ ref: "initial_value" }}
      type="text"
      name="initial_value"
      id="time_only-initial-value"
      class="form-control time-field w-25"
      placeholder="HH:mm:ss"
      value={displayOptions.initial_value}
      onchange={(e) => {
        options.initial_value = e.currentTarget.value;
      }}
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
