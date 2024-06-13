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
  type="date_only"
  {id}
  {fieldId}
  {options}
  bind:label
  {isNew}
>
  <ContentFieldOption
    id="date_only-initial-date_value"
    label={window.trans("Initial Value")}
  >
    <!-- I guess id attribute should be date_only-initial_value. But original date.tmpl uses initial_value -->
    <input
      {...{ ref: "initial_value" }}
      type="text"
      name="initial_value"
      id="initial_value"
      class="form-control date-field w-25"
      value={options.initial_value ?? ""}
      placeholder="YYYY-MM-DD"
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
