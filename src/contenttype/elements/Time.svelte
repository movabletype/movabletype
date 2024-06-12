<script lang="ts">
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";
  import ContentFieldOption from "./ContentFieldOption.svelte";

  export let fieldId: string;
  export let options: any;
  export let label: string;
  export let isNew: boolean;

  export let id: string;

  const type = "time-only";
  const _type = type.replace(/-/g, "_");
</script>

<ContentFieldOptionGroup
  {type}
  {id}
  {fieldId}
  {options}
  bind:labelValue={label}
  {isNew}
>
  <svelte:fragment slot="body">
    <ContentFieldOption
      id="{_type}-initial-value"
      label={window.trans("Initial Value")}
    >
      <svelte:fragment slot="inside">
        <input
          {...{ ref: "initial_value" }}
          type="text"
          name="initial_value"
          id="{_type}-initial-value"
          class="form-control time-field w-25"
          value={options?.initial_value}
          placeholder="HH:mm:ss"
        />
      </svelte:fragment>
    </ContentFieldOption>
  </svelte:fragment>
</ContentFieldOptionGroup>
