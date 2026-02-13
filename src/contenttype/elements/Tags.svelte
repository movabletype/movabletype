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
    multiple: options.multiple ?? false,
    can_add: options.can_add ?? false,
    min: options.min ?? "",
    max: options.max ?? "",
    initial_value: options.initial_value ?? "",
  });
</script>

<ContentFieldOptionGroup type="tags" bind:field {id} bind:options>
  <ContentFieldOption
    id="tags-multiple"
    label={window.trans("Allow users to input multiple values?")}
  >
    <!-- onclick was removed bacause unused -->
    <input
      {...{ ref: "multiple" }}
      type="checkbox"
      class="mt-switch form-control"
      id="tags-multiple"
      name="multiple"
      checked={displayOptions.multiple}
      onchange={(e) => {
        options.multiple = e.currentTarget.checked;
      }}
    /><label for="tags-multiple" class="form-label">
      {window.trans("Allow users to select multiple values?")}
    </label>
  </ContentFieldOption>

  <ContentFieldOption
    id="tags-min"
    label={window.trans("Minimum number of selections")}
    attrShow={displayOptions.multiple}
  >
    <input
      {...{ ref: "min" }}
      type="number"
      name="min"
      id="tags-min"
      class="form-control w-25"
      min="0"
      value={displayOptions.min}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="tags-max"
    label={window.trans("Maximum number of selections")}
    attrShow={displayOptions.multiple}
  >
    <input
      {...{ ref: "max" }}
      type="number"
      name="max"
      id="tags-max"
      class="form-control w-25"
      min="1"
      value={displayOptions.max}
      onchange={(e) => {
        options.max = e.currentTarget.value;
      }}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="tags-initial_value"
    label={window.trans("Initial Value")}
  >
    <input
      {...{ ref: "initial_value" }}
      type="text"
      name="initial_value"
      id="tags-initial_value"
      class="form-control"
      value={displayOptions.initial_value}
      onchange={(e) => {
        options.initial_value = e.currentTarget.value;
      }}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="tags-can_add"
    label={window.trans("Allow users to create new tags?")}
  >
    <input
      {...{ ref: "can_add" }}
      type="checkbox"
      class="mt-switch form-control"
      id="tags-can_add"
      name="can_add"
      checked={displayOptions.can_add}
      onchange={(e) => {
        options.can_add = e.currentTarget.checked;
      }}
    /><label for="tags-can_add" class="form-label">
      {window.trans("Allow users to create new tags?")}
    </label>
  </ContentFieldOption>
</ContentFieldOptionGroup>
