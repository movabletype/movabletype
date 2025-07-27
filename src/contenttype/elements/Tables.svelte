<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  // svelte-ignore unused-export-let
  export let config: ContentType.ConfigSettings;
  export let field: ContentType.Field;
  // svelte-ignore unused-export-let
  export let gather = null;
  export let id: string;
  export let options: ContentType.Options;
  // svelte-ignore unused-export-let
  export let optionsHtmlParams: ContentType.OptionsHtmlParams;

  if (options.increase_decrease_rows === "0") {
    options.increase_decrease_rows = 0;
  }
  if (options.increase_decrease_cols === "0") {
    options.increase_decrease_cols = 0;
  }

  options.initial_rows ??= 1;
  options.initial_cols ??= 1;
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
      bind:value={options.initial_rows}
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
      bind:value={options.initial_cols}
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
      bind:checked={options.increase_decrease_rows}
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
      bind:checked={options.increase_decrease_cols}
    /><label for="tables-can_increase_decrease_cols" class="form-label">
      {window.trans("Allow users to increase/decrease cols?")}
    </label>
  </ContentFieldOption>
</ContentFieldOptionGroup>
