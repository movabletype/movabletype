<script lang="ts">
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";
  import ContentFieldOption from "./ContentFieldOption.svelte";

  export let fieldId: string;
  export let options: any;
  export let label: string;
  export let isNew: boolean;

  export let id: string;

  const type = "date-only";
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
      id="{_type}-initial-date_value"
      label={window.trans("Initial Value")}
    >
      <svelte:fragment slot="inside">
        <!-- I guess id attribute should be date_only-initial_value. But original date.tmpl uses initial_value -->
        <input
          {...{ ref: "initial_value" }}
          type="text"
          name="initial_value"
          id="initial_value"
          class="form-control date-field w-25"
          value={options.initial_value}
          placeholder="YYYY-MM-DD"
        />
      </svelte:fragment>
    </ContentFieldOption>
  </svelte:fragment>
</ContentFieldOptionGroup>
