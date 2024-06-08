<script lang="ts">
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";
  import ContentFieldOption from "./ContentFieldOption.svelte";

  export let fieldId: string;
  export let options: {
    description?: string;
    displays?: {
      force?: boolean;
      default?: boolean;
      optional?: boolean;
      none?: boolean;
    };
    required?: boolean;
    initial_value?: string;
    [key: string]: any;
  };
  export let label: string;
  export let isNew: boolean;

  const type = "date-and-time";
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
      id="{_type}-initial-date_value"
      label={window.trans("Initial Value (Date)")}
      showLabel={true}
    >
      <svelte:fragment slot="inside">
        <input
          {...{ ref: "initial_date" }}
          type="text"
          name="initial_date"
          id="{_type}-initial_date"
          class="form-control date-field w-25"
          value={options.initial_date}
          placeholder="YYYY-MM-DD"
        />
      </svelte:fragment>
    </ContentFieldOption>

    <ContentFieldOption
      id="{_type}-initial-timevalue"
      label={window.trans("Initial Value (Time)")}
      showLabel={true}
    >
      <svelte:fragment slot="inside">
        <input
          {...{ ref: "initial_time" }}
          type="text"
          name="initial_time"
          id="{_type}-initial_time"
          class="form-control time-field w-25"
          value={options.initial_time}
          placeholder="HH:mm:ss"
        />
      </svelte:fragment>
    </ContentFieldOption>
  </svelte:fragment>
</ContentFieldOptionGroup>
