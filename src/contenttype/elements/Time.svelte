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
    options,
    optionsHtmlParams: _optionsHtmlParams,
  }: ContentType.ContentFieldProps = $props();

  onMount(() => {
    options.initial_value ??= "";
  });
</script>

<ContentFieldOptionGroup type="time-only" bind:field {id} {options}>
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
      value={options.initial_value}
      placeholder="HH:mm:ss"
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
