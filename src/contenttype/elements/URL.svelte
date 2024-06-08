<script lang="ts">
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";
  import ContentFieldOption from "./ContentFieldOption.svelte";

  export let fieldId;
  export let options;
  export let label;
  export let isNew;

  const type = "url";
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
      id="{type}-initial_value"
      label={window.trans("Initial Value")}
      showLabel={true}
    >
      <svelte:fragment slot="inside">
        <input
          {...{ ref: "initial_value" }}
          type="text"
          name="initial_value"
          id="{type}-initial_value"
          class="form-control"
          value={options.initial_value}
        />
      </svelte:fragment>
    </ContentFieldOption>
  </svelte:fragment>
</ContentFieldOptionGroup>
