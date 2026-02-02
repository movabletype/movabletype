<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  let {
    config,
    field = $bindable(),
    gather = $bindable(null),
    id,
    options = $bindable(),
    optionsHtmlParams,
  } : ContentType.ContentFieldProps = $props();

  options.initial_value ??= "";
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
      bind:value={options.initial_value}
      placeholder="YYYY-MM-DD"
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
