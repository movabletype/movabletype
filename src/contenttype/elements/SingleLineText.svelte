<script lang="ts">
  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  // svelte-ignore unused-export-let
  export let config: MT.ContentType.ConfigSettings;
  export let field: MT.ContentType.Field;
  export let id: string;
  export let label: string;
  export let options: MT.ContentType.Options;
  // svelte-ignore unused-export-let
  export let optionsHtmlParams: MT.ContentType.OptionsHtmlParams;
</script>

<!-- convert snake case to chain case in Riot.js implementation -->
<ContentFieldOptionGroup
  type="single-line-text"
  fieldId={field.id || ""}
  {id}
  isNew={field.isNew ? true : false}
  bind:label
  {options}
>
  <ContentFieldOption
    id="single_line_text-min_length"
    label={window.trans("Min Length")}
  >
    <input
      {...{ ref: "min_length" }}
      type="number"
      name="min_length"
      id="single_line_text-min_length"
      class="form-control w-25"
      min="0"
      value={options.min_length || 0}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="single_line_text-max_length"
    label={window.trans("Max Length")}
  >
    <input
      {...{ ref: "max_length" }}
      type="number"
      name="max_length"
      id="single_line_text-max_length"
      class="form-control w-25"
      min="1"
      value={options.max_length || 255}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="single_line_text-initial_value"
    label={window.trans("Initial Value")}
  >
    <input
      {...{ ref: "initial_value" }}
      type="text"
      name="initial_value"
      id="single_line_text-initial_value"
      class="form-control"
      value={options.initial_value ?? ""}
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
