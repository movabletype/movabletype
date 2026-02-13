<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  import StatusMsg from "./StatusMsg.svelte";

  let {
    config: _config,
    field = $bindable(),
    gather = $bindable(),
    id,
    options = $bindable(),
    optionsHtmlParams,
  }: ContentType.ContentFieldProps = $props();

  // svelte-ignore state_referenced_locally
  const categorySets: Array<{ id: string; name: string }> =
    optionsHtmlParams.categories.category_sets;

  let displayOptions = $derived({
    ...options,
    multiple:
      options.multiple === 1 ||
      options.multiple === "1" ||
      options.multiple === true,
    can_add:
      options.can_add === 1 ||
      options.can_add === "1" ||
      options.can_add === true,
    min: options.min ?? "",
    max: options.max ?? "",
  });
</script>

<ContentFieldOptionGroup type="categories" bind:field {id} bind:options>
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
      checked={displayOptions.multiple}
      onchange={(e) => {
        options.multiple = e.currentTarget.checked ? 1 : 0;
      }}
    /><label for="categories-multiple" class="form-label">
      {window.trans("Allow users to select multiple categories?")}
    </label>
  </ContentFieldOption>

  <ContentFieldOption
    id="categories-min"
    label={window.trans("Minimum number of selections")}
    attrShow={displayOptions.multiple}
  >
    <input
      {...{ ref: "min" }}
      type="number"
      name="min"
      id="categories-min"
      class="form-control w-25"
      min="0"
      value={displayOptions.min}
      onchange={(e) => {
        options.min = e.currentTarget.value;
      }}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="categories-max"
    label={window.trans("Maximum number of selections")}
    attrShow={displayOptions.multiple}
  >
    <input
      {...{ ref: "max" }}
      type="number"
      name="max"
      id="categories-max"
      class="form-control w-25"
      min="1"
      value={displayOptions.max}
      onchange={(e) => {
        options.max = e.currentTarget.value;
      }}
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
      checked={displayOptions.can_add}
      onchange={(e) => {
        options.can_add = e.currentTarget.checked ? 1 : 0;
      }}
    /><label for="categories-can_add" class="form-label">
      {window.trans("Allow users to create new categories?")}
    </label>
  </ContentFieldOption>

  <ContentFieldOption
    id="categories-category_set"
    label={window.trans("Source Category Set")}
    required={1}
  >
    {#if categorySets && categorySets.length > 0}
      <select
        {...{ ref: "category_sets" }}
        name="category_set"
        id="categories-category_set"
        class="custom-select form-control html5-form form-select"
        value={options.category_set}
      >
        {#each categorySets as cs}
          <option value={cs.id}>
            {cs.name}
          </option>
        {/each}
      </select>
    {:else}
      {#snippet statusMsgContent()}
        {window.trans(
          "There is no category set that can be selected. Please create a category set if you use the Categories field type.",
        )}
      {/snippet}
      <StatusMsg
        id="no-category-set"
        class="warning"
        canClose={0}
        msg={statusMsgContent}
      />
    {/if}
  </ContentFieldOption>
</ContentFieldOptionGroup>
