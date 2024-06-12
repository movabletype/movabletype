<script lang="ts">
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";
  import ContentFieldOption from "./ContentFieldOption.svelte";

  export let fieldId: string;
  export let id: string;
  export let options: any;
  export let label: string;
  export let isNew: boolean;
</script>

<ContentFieldOptionGroup
  type="url"
  {id}
  {fieldId}
  {isNew}
  bind:labelValue={label}
  {options}
>
  <svelte:fragment slot="body">
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
        value={options?.initial_value}
      />
    </ContentFieldOption>
  </svelte:fragment>
</ContentFieldOptionGroup>
