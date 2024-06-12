<script lang="ts">
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";
  import ContentFieldOption from "./ContentFieldOption.svelte";

  export let fieldId: string;
  export let id: string;
  export let isNew: boolean;
  export let label: string;
  export let options: MT.ContentType.Options = {};
</script>

<ContentFieldOptionGroup type="url" {id} {fieldId} {isNew} bind:label {options}>
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
