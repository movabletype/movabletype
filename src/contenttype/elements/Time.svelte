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

<ContentFieldOptionGroup
  type="time-only"
  bind:field
  fieldId={field.id ?? ""}
  {id}
  isNew={field.isNew ? true : false}
  bind:options
>
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
      bind:value={options.initial_value}
      placeholder="HH:mm:ss"
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
