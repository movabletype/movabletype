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
  type="time_only"
  {id}
  {fieldId}
  {options}
  bind:label
  {isNew}
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
      value={options?.initial_value}
      placeholder="HH:mm:ss"
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
