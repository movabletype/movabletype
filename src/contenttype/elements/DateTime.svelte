<script lang="ts">
  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  export let fieldId: string;
  export let id: string;
  export let isNew: boolean;
  export let label: string;
  export let options: MT.ContentType.Options;
</script>

<ContentFieldOptionGroup
  type="date_and_time"
  {id}
  {fieldId}
  {options}
  bind:label
  {isNew}
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
