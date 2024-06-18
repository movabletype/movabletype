<script lang="ts">
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";
  import ContentFieldOption from "./ContentFieldOption.svelte";

  // svelte-ignore unused-export-let
  export let config: MT.ContentType.ConfigSettings;
  export let field: MT.ContentType.Field;
  export let id: string;
  export let options: MT.ContentType.Options;
  // svelte-ignore unused-export-let
  export let optionsHtmlParams: MT.ContentType.OptionsHtmlParams;
</script>

<ContentFieldOptionGroup
  type="url"
  {id}
  fieldId={field.id ?? ""}
  isNew={field.isNew ? true : false}
  bind:label={field.label}
  {options}
>
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
      value={options.initial_value ?? ""}
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
