<script>
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";
  import ContentFieldOption from "./ContentFieldOption.svelte";

  export let fieldId;
  export let options;
  export let label;
  export let isNew;

  const type = "single-line-text";
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
      id="{_type}-min_length"
      label={window.trans("Min Length")}
      showLabel={true}
    >
      <svelte:fragment slot="inside">
        <input
          ref="min_length"
          type="number"
          name="min_length"
          id="{_type}-min_length"
          class="form-control w-25"
          min="0"
          value={options.min_length || 0}
        />
      </svelte:fragment>
    </ContentFieldOption>

    <ContentFieldOption
      id="{_type}-max_length"
      label={window.trans("Max Length")}
      showLabel={true}
    >
      <svelte:fragment slot="inside">
        <input
          ref="max_length"
          type="number"
          name="max_length"
          id="{_type}-max_length"
          class="form-control w-25"
          min="1"
          value={options.max_length || 255}
        />
      </svelte:fragment>
    </ContentFieldOption>

    <ContentFieldOption
      id="{_type}-initial_value"
      label={window.trans("Initial Value")}
      showLabel={true}
    >
      <svelte:fragment slot="inside">
        <input
          ref="initial_value"
          type="text"
          name="initial_value"
          id="{_type}-initial_value"
          class="form-control"
          value={options.initial_value}
        />
      </svelte:fragment>
    </ContentFieldOption>
  </svelte:fragment>
</ContentFieldOptionGroup>
