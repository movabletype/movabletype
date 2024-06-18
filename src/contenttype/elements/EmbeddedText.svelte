<script lang="ts">
  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  // svelte-ignore unused-export-let
  export let config: MT.ContentType.ConfigSettings;
  export let field: MT.ContentType.Field;
  export let id: string;
  export let options: MT.ContentType.Options;
  // svelte-ignore unused-export-let
  export let optionsHtmlParams: MT.ContentType.OptionsHtmlParams;

  if (options.initial_value === null) {
    options.initial_value = "";
  }
</script>

<!-- convert snake case to chain case in Riot.js implementation -->
<ContentFieldOptionGroup
  type="embedded-text"
  fieldId={field.id ?? ""}
  {id}
  isNew={field.isNew ? true : false}
  bind:label={field.label}
  bind:options
>
  <ContentFieldOption
    id="embedded_text-initial_value"
    label={window.trans("Initial Value")}
  >
    <!-- "embeddedded" is not modified, because matching the Riot.js implmentation -->
    <textarea
      {...{ ref: "initial_value" }}
      name="initial_value"
      id="embeddedded_text-initial_value"
      class="form-control"
      bind:value={options.initial_value}
    ></textarea>
  </ContentFieldOption>
</ContentFieldOptionGroup>
