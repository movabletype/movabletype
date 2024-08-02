<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  import StatusMsg from "./StatusMsg.svelte";

  // svelte-ignore unused-export-let
  export let config: ContentType.ConfigSettings;
  export let field: ContentType.Field;
  // svelte-ignore unused-export-let
  export let gather = null;
  export let id: string;
  export let options: ContentType.Options;
  export let optionsHtmlParams: ContentType.OptionsHtmlParams;

  const categorySets: Array<{ id: string; name: string }> =
    optionsHtmlParams.categories.category_sets;

  if (options.multiple === "0") {
    options.multiple = 0;
  }

  if (options.can_add === "0") {
    options.can_add = 0;
  }

  options.min ??= "";
  options.max ??= "";

  // changeStateMultiple was removed because unused
</script>

<ContentFieldOptionGroup type="categories" bind:field {id} bind:options>
  <ContentFieldOption
    id="categories-multiple"
    label={window.trans("Allow users to select multiple categories?")}
  >
    <!-- onclick was removed and bind is used -->
    <input
      {...{ ref: "multiple" }}
      type="checkbox"
      class="mt-switch form-control"
      id="categories-multiple"
      name="multiple"
      bind:checked={options.multiple}
    /><label for="categories-multiple" class="form-label">
      {window.trans("Allow users to select multiple categories?")}
    </label>
  </ContentFieldOption>

  <ContentFieldOption
    id="categories-min"
    label={window.trans("Minimum number of selections")}
    attrShow={options.multiple ? true : false}
  >
    <input
      {...{ ref: "min" }}
      type="number"
      name="min"
      id="categories-min"
      class="form-control w-25"
      min="0"
      bind:value={options.min}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="categories-max"
    label={window.trans("Maximum number of selections")}
    attrShow={options.multiple ? true : false}
  >
    <input
      {...{ ref: "max" }}
      type="number"
      name="max"
      id="categories-max"
      class="form-control w-25"
      min="1"
      bind:value={options.max}
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
    {#if categorySets && categorySets.length > 0}
      <!-- selected was removed and bind is used -->
      <select
        {...{ ref: "category_sets" }}
        name="category_set"
        id="categories-category_set"
        class="custom-select form-control html5-form form-select"
        bind:value={options.category_set}
      >
        {#each categorySets as cs}
          <option value={cs.id}>
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
