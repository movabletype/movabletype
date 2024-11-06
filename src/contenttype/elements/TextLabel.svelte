<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import { onMount } from "svelte";

  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  // svelte-ignore unused-export-let
  export let config: ContentType.ConfigSettings;
  export let field: ContentType.Field;
  // svelte-ignore unused-export-let
  export let gather = null;
  export let id: string;
  export let options: ContentType.Options;
  // svelte-ignore unused-export-let
  export let optionsHtmlParams: ContentType.OptionsHtmlParams;

  options.text ??= "";

  onMount(() => {
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

<ContentFieldOptionGroup type="text-label" bind:field {id} bind:options>
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
      bind:value={options.text}
    ></textarea>
  </ContentFieldOption>
</ContentFieldOptionGroup>
