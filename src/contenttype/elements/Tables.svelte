<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  let {
    config: _config,
    field = $bindable(),
    gather = $bindable(),
    id,
    options = $bindable(),
    optionsHtmlParams: _optionsHtmlParams,
  }: ContentType.ContentFieldProps = $props();

  let displayOptions = $derived({
    ...options,
    increase_decrease_rows: options.increase_decrease_rows ?? false,
    increase_decrease_cols: options.increase_decrease_cols ?? false,
    initial_rows: options.initial_rows ?? 1,
    initial_cols: options.initial_cols ?? 1,
  });
</script>

<ContentFieldOptionGroup type="table" bind:field {id} bind:options>
  <ContentFieldOption
    id="tables-initial_rows"
    label={window.trans("Initial Rows")}
  >
    <input
      {...{ ref: "initial_rows" }}
      type="number"
      name="initial_rows"
      id="tables-initial_rows"
      class="form-control w-25"
      min="1"
      value={displayOptions.initial_rows}
      onchange={(e) => {
        options.initial_rows = e.currentTarget.value;
      }}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="tables-initial_cols"
    label={window.trans("Initial Cols")}
  >
    <input
      {...{ ref: "initial_cols" }}
      type="number"
      name="initial_cols"
      id="tables-initial_cols"
      class="form-control w-25"
      min="1"
      value={displayOptions.initial_cols}
      onchange={(e) => {
        options.initial_cols = e.currentTarget.value;
      }}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="tables-can_increase_decrease_rows"
    label={window.trans("Allow users to increase/decrease rows?")}
  >
    <input
      {...{ ref: "increase_decrease_rows" }}
      type="checkbox"
      class="mt-switch form-control"
      id="tables-can_increase_decrease_rows"
      name="increase_decrease_rows"
      checked={displayOptions.increase_decrease_rows}
      onchange={(e) => {
        options.increase_decrease_rows = e.currentTarget.checked;
      }}
    /><label for="tables-can_increase_decrease_rows" class="form-label">
      {window.trans("Allow users to increase/decrease rows?")}
    </label>
  </ContentFieldOption>

  <ContentFieldOption
    id="tables-can_increase_decrease_cols"
    label={window.trans("Allow users to increase/decrease cols?")}
  >
    <input
      {...{ ref: "increase_decrease_cols" }}
      type="checkbox"
      class="mt-switch form-control"
      id="tables-can_increase_decrease_cols"
      name="increase_decrease_cols"
      checked={displayOptions.increase_decrease_cols}
      onchange={(e) => {
        options.increase_decrease_cols = e.currentTarget.checked;
      }}
    /><label for="tables-can_increase_decrease_cols" class="form-label">
      {window.trans("Allow users to increase/decrease cols?")}
    </label>
  </ContentFieldOption>
</ContentFieldOptionGroup>
