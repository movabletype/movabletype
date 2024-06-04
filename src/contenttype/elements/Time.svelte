<script>
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";
  import ContentFieldOption from "./ContentFieldOption.svelte";

  export let fieldId;
  export let options;
  export let label;
  export let isNew;

  const type = "time-only";
  const _type = type.replace(/-/g, "_");
</script>

<ContentFieldOptionGroup
  {type}
  {fieldId}
  {options}
  bind:labelValue={label}
  {isNew}
>
  <svelte:fragment slot="body">
    <ContentFieldOption
      id="{_type}-initial-value"
      label={window.trans("Initial Value")}
      showLabel={true}
    >
      <svelte:fragment slot="inside">
        <input
          ref="initial_value"
          type="text"
          name="initial_value"
          id="{_type}-initial-value"
          class="form-control time-field w-25"
          value={options.initial_value}
          placeholder="HH:mm:ss"
        />
      </svelte:fragment>
    </ContentFieldOption>
  </svelte:fragment>
</ContentFieldOptionGroup>
