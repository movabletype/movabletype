<script lang="ts">
  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  export let fieldId: string;
  export let id: string;
  export let isNew: boolean;
  export let label: string;
  export let options: MT.ContentType.Options;
  // svelte-ignore unused-export-let
  export let optionsHtmlParams: MT.ContentType.OptionsHtmlParams;

  if (options.multiple === "0") {
    options.multiple = 0;
  }

  if (options.can_add === "0") {
    options.can_add = 0;
  }

  let multiple = options.multiple;
</script>

<ContentFieldOptionGroup
  type="tags"
  {fieldId}
  {id}
  {isNew}
  bind:label
  {options}
>
  <ContentFieldOption
    id="tags-multiple"
    label={window.trans("Allow users to input multiple values?")}
  >
    <!-- onclick is removed bacause it is not needed  -->
    <input
      {...{ ref: "multiple" }}
      type="checkbox"
      class="mt-switch form-control"
      id="tags-multiple"
      name="multiple"
      bind:checked={multiple}
    /><label for="tags-multiple" class="form-label">
      {window.trans("Allow users to select multiple values?")}
    </label>
  </ContentFieldOption>

  <ContentFieldOption
    id="tags-min"
    label={window.trans("Minimum number of selections")}
    attrShow={multiple ? true : false}
  >
    <input
      {...{ ref: "min" }}
      type="number"
      name="min"
      id="tags-min"
      class="form-control w-25"
      min="0"
      value={options.min ?? ""}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="tags-max"
    label={window.trans("Maximum number of selections")}
    attrShow={multiple ? true : false}
  >
    <input
      {...{ ref: "max" }}
      type="number"
      name="max"
      id="tags-max"
      class="form-control w-25"
      min="1"
      value={options.max ?? ""}
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
      value={options.initial_value ?? ""}
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
      bind:checked={options.can_add}
    /><label for="tags-can_add" class="form-label">
      {window.trans("Allow users to create new tags?")}
    </label>
  </ContentFieldOption>
</ContentFieldOptionGroup>
