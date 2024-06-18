<script lang="ts">
  import { onMount } from "svelte";

  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  // svelte-ignore unused-export-let
  export let config: MT.ContentType.ConfigSettings;
  export let field: MT.ContentType.Field;
  export let id: string;
  export let isNew: boolean;
  export let label: string;
  export let options: MT.ContentType.Options;
  // svelte-ignore unused-export-let
  export let optionsHtmlParams: MT.ContentType.OptionsHtmlParams;

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

<!-- convert snake case to chain case in Riot.js implementation -->
<ContentFieldOptionGroup
  type="text-label"
  fieldId={field.id ?? ""}
  {id}
  {isNew}
  bind:label
  {options}
>
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
      class="form-control">{options.text ?? ""}</textarea
    >
  </ContentFieldOption>
</ContentFieldOptionGroup>
