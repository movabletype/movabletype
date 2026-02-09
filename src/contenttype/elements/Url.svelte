<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";
  import ContentFieldOption from "./ContentFieldOption.svelte";
  import { onMount } from "svelte";

  let {
    config: _config,
    field = $bindable(),
    gather = $bindable(),
    id,
    options = $bindable(),
    optionsHtmlParams: _optionsHtmlParams,
  }: ContentType.ContentFieldProps = $props();

  onMount(() => {
    options.initial_value ??= "";
  });
</script>

<ContentFieldOptionGroup type="url" {id} bind:field {options}>
  <ContentFieldOption
    id="url-initial_value"
    label={window.trans("Initial Value")}
  >
    <input
      {...{ ref: "initial_value" }}
      type="text"
      name="initial_value"
      id="url-initial_value"
      class="form-control"
      value={options.initial_value}
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
