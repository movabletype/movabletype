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
    optionsHtmlParams: _optionsHtmlParams,
  }: ContentType.ContentFieldProps = $props();

  onMount(() => {
    options.initial_value ??= "";
  });
</script>

<ContentFieldOptionGroup type="date-only" bind:field {id} bind:options>
  <ContentFieldOption
    id="date_only-initial-date_value"
    label={window.trans("Initial Value")}
  >
    <!-- id attribute should be date_only-initial_value. But original date.tmpl uses initial_value -->
    <input
      {...{ ref: "initial_value" }}
      type="text"
      name="initial_value"
      id="initial_value"
      class="form-control date-field w-25"
      value={options.initial_value}
      placeholder="YYYY-MM-DD"
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
