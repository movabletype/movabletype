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
  type="date-and-time"
  {id}
  fieldId={field.id ?? ""}
  {options}
  bind:label
  isNew={field.isNew ? true : false}
>
  <ContentFieldOption
    id="date_and_time-initial-date_value"
    label={window.trans("Initial Value (Date)")}
  >
    <input
      {...{ ref: "initial_date" }}
      type="text"
      name="initial_date"
      id="date_and_time-initial_date"
      class="form-control date-field w-25"
      value={options.initial_date ?? ""}
      placeholder="YYYY-MM-DD"
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="date_and_time-initial-timevalue"
    label={window.trans("Initial Value (Time)")}
  >
    <input
      {...{ ref: "initial_time" }}
      type="text"
      name="initial_time"
      id="date_and_time-initial_time"
      class="form-control time-field w-25"
      value={options.initial_time ?? ""}
      placeholder="HH:mm:ss"
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
