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

<ContentFieldOptionGroup type="embedded-text" bind:field {id} bind:options>
  <ContentFieldOption
    id="embedded_text-initial_value"
    label={window.trans("Initial Value")}
  >
    <!-- "embeddedded" that may be a typo, is same as Riot.js implementation -->
    <textarea
      {...{ ref: "initial_value" }}
      name="initial_value"
      id="embeddedded_text-initial_value"
      class="form-control"
      value={displayOptions.initial_value}
      onchange={(e) => {
        options.initial_value = e.currentTarget.value;
      }}
    ></textarea>
  </ContentFieldOption>
</ContentFieldOptionGroup>
