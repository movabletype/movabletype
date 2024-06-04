<script>
  import ContentFieldOptionGroup from './ContentFieldOptionGroup.svelte';
  import ContentFieldOption from './ContentFieldOption.svelte';

  export let fieldId;
  export let options;
  export let label;
  export let isNew;

  const type = "date-and-time";
  const _type = type.replace(/-/g, "_");
</script>

<ContentFieldOptionGroup
  type="{type}"
  fieldId={ fieldId }
  options={ options }
  bind:labelValue={ label }
  isNew={ isNew }
>
  <svelte:fragment slot="body">
    <ContentFieldOption
        id="{_type}-initial-date_value"
        label={ trans("Initial Value (Date)") }
        showLabel={ true }
    >
      <svelte:fragment slot="inside">
        <input ref="initial_date" type="text" name="initial_date" id="{_type}-initial_date" class="form-control date-field w-25" value={ options.initial_date } placeholder="YYYY-MM-DD">
      </svelte:fragment>
    </ContentFieldOption>
  
    <ContentFieldOption
      id="{_type}-initial-timevalue"
      label={ trans("Initial Value (Time)") }
      showLabel={ true }
    >
      <svelte:fragment slot="inside">
        <input ref="initial_time" type="text" name="initial_time" id="{_type}-initial_time" class="form-control time-field w-25" value={ options.initial_time } placeholder="HH:mm:ss">
      </svelte:fragment>
    </ContentFieldOption>
  
  </svelte:fragment>
</ContentFieldOptionGroup>
