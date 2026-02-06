<script lang="ts">
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

  options.text ??= "";

  $effect(() => {
    // description, required, display field is hidden.
    (
      document.getElementById(
        "text-label-description-field-" + id,
      ) as HTMLElement
    ).style.display = "none";
    (
      document.getElementById("text-label-required-field-" + id) as HTMLElement
    ).style.display = "none";
    (
      document.getElementById("text-label-display-field-" + id) as HTMLElement
    ).style.display = "none";
  });
</script>

<ContentFieldOptionGroup type="text-label" bind:field {id} {options}>
  <ContentFieldOption
    id="text_label-text"
    label={window.trans("__TEXT_LABEL_TEXT")}
    hint={window.trans(
      "This block is only visible in the administration screen for comments.",
    )}
    showHint={1}
  >
    <textarea
      {...{ ref: "text" }}
      name="text"
      id="text_label-text"
      class="form-control"
      value={options.text}
    ></textarea>
  </ContentFieldOption>
</ContentFieldOptionGroup>
