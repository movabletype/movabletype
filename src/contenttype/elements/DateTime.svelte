<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  let {
    config,
    field = $bindable(),
    gather = $bindable(),
    id,
    options,
    optionsHtmlParams,
  }: ContentType.ContentFieldProps = $props();

  options.initial_date ??= "";
  options.initial_time ??= "";
</script>

<ContentFieldOptionGroup type="date-and-time" bind:field {id} {options}>
  <ContentFieldOption
    id="date_and_time-initial-date_value"
    label={window.trans("Initial Value (Date)")}
  >
    <input
      {...{ ref: "initial_date" }}
      type="text"
      name="initial_date"
      id="date_and_time-initial_date"
      class="form-control date-field w-25"
      value={options.initial_date}
      placeholder="YYYY-MM-DD"
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="date_and_time-initial-timevalue"
    label={window.trans("Initial Value (Time)")}
  >
    <input
      {...{ ref: "initial_time" }}
      type="text"
      name="initial_time"
      id="date_and_time-initial_time"
      class="form-control time-field w-25"
      value={options.initial_time}
      placeholder="HH:mm:ss"
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
