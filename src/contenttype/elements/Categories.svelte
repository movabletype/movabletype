<script lang="ts">
  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  import StatusMsg from "./StatusMsg.svelte";

  // svelte-ignore unused-export-let
  export let config: MT.ContentType.ConfigSettings;
  export let fieldId: string;
  export let id: string;
  export let isNew: boolean;
  export let label: string;
  export let options: MT.ContentType.Options;
  export let optionsHtmlParams: MT.ContentType.OptionsHtmlParams;

  const categorySets: Array<{ id: string; name: string }> =
    optionsHtmlParams.categories.category_sets;

  if (options.multiple === "0") {
    options.multiple = 0;
  }

  if (options.can_add === "0") {
    options.can_add = 0;
  }

  let multiple = options.multiple;
</script>

<ContentFieldOptionGroup
  type="categories"
  {fieldId}
  {id}
  {isNew}
  bind:label
  {options}
>
  <ContentFieldOption
    id="categories-multiple"
    label={window.trans("Allow users to select multiple categories?")}
  >
    <input
      {...{ ref: "multiple" }}
      type="checkbox"
      class="mt-switch form-control"
      id="categories-multiple"
      name="multiple"
      bind:checked={multiple}
    /><label for="categories-multiple" class="form-label">
      {window.trans("Allow users to select multiple categories?")}
    </label>
  </ContentFieldOption>

  <ContentFieldOption
    id="categories-min"
    label={window.trans("Minimum number of selections")}
    attrShow={multiple ? true : false}
  >
    <input
      {...{ ref: "min" }}
      type="number"
      name="min"
      id="categories-min"
      class="form-control w-25"
      min="0"
      value={options.min ?? ""}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="categories-max"
    label={window.trans("Maximum number of selections")}
    attrShow={multiple ? true : false}
  >
    <input
      {...{ ref: "max" }}
      type="number"
      name="max"
      id="categories-max"
      class="form-control w-25"
      min="1"
      value={options.max ?? ""}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="categories-can_add"
    label={window.trans("Allow users to create new categories?")}
  >
    <input
      {...{ ref: "can_add" }}
      type="checkbox"
      class="mt-switch form-control"
      id="categories-can_add"
      name="can_add"
      bind:checked={options.can_add}
    /><label for="categories-can_add" class="form-label">
      {window.trans("Allow users to create new categories?")}
    </label>
  </ContentFieldOption>

  <ContentFieldOption
    id="categories-category_set"
    label={window.trans("Source Category Set")}
    required={1}
  >
    {#if categorySets.length > 0}
      <select
        {...{ ref: "category_sets" }}
        name="category_set"
        id="categories-category_set"
        class="custom-select form-control html5-form form-select"
      >
        {#each categorySets as cs}
          <option value={cs.id} selected={cs.id === options.category_set}>
            {cs.name}
          </option>
        {/each}
      </select>
    {:else}
      <StatusMsg id="no-cateogry-set" class="warning" canClose={0}>
        <svelte:fragment slot="msg">
          {window.trans(
            "There is no content type that can be selected. Please create new content type if you use Content Type field type.",
          )}
        </svelte:fragment>
      </StatusMsg>
    {/if}
  </ContentFieldOption>
</ContentFieldOptionGroup>
