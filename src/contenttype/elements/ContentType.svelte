<script lang="ts">
  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  import StatusMsg from "./StatusMsg.svelte";

  // svelte-ignore unused-export-let
  export let config: MT.ContentType.ConfigSettings;
  export let field: MT.ContentType.Field;
  export let id: string;
  export let options: MT.ContentType.Options;
  export let optionsHtmlParams: MT.ContentType.OptionsHtmlParams;

  const contentTypes: Array<{ id: string; name: string }> =
    optionsHtmlParams.content_type.content_types;

  if (options.multiple === "0") {
    options.multiple = 0;
  }

  if (options.can_add === "0") {
    options.can_add = 0;
  }

  if (options.min === null) {
    options.min = "";
  }

  if (options.max === null) {
    options.max = "";
  }

  let multiple = options.multiple;
</script>

<ContentFieldOptionGroup
  type="content-type"
  fieldId={field.id ?? ""}
  {id}
  isNew={field.isNew ? true : false}
  bind:label={field.label}
  bind:options
>
  <ContentFieldOption
    id="content_type-multiple"
    label={window.trans("Allow users to select multiple values?")}
  >
    <input
      {...{ ref: "multiple" }}
      type="checkbox"
      class="mt-switch form-control"
      id="content_type-multiple"
      name="multiple"
      bind:checked={multiple}
    /><label for="content_type-multiple" class="form-label">
      {window.trans("Allow users to select multiple values?")}
    </label>
  </ContentFieldOption>

  <ContentFieldOption
    id="content_type-min"
    label={window.trans("Minimum number of selections")}
    attrShow={multiple ? true : false}
  >
    <input
      {...{ ref: "min" }}
      type="number"
      name="min"
      id="content_type-min"
      class="form-control w-25"
      min="0"
      bind:value={options.min}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="content_type-max"
    label={window.trans("Maximum number of selections")}
    attrShow={multiple ? true : false}
  >
    <input
      {...{ ref: "max" }}
      type="number"
      name="max"
      id="content_type-max"
      class="form-control w-25"
      min="1"
      bind:value={options.max}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="content_type-source"
    required={1}
    label={window.trans("Source Content Type")}
  >
    {#if contentTypes.length > 0}
      <select
        {...{ ref: "source" }}
        name="source"
        id="content_type-source"
        class="custom-select form-control html5-form form-select"
        bind:value={options.source}
      >
        {#each contentTypes as ct}
          <option value={ct.id}>
            {ct.name}
          </option>
        {/each}
      </select>
    {:else}
      <StatusMsg id="no-content-type" class="warning" canClose={0}>
        <svelte:fragment slot="msg">
          {window.trans(
            "There is no content type that can be selected. Please create a content type if you use the Content Type field type.",
          )}
        </svelte:fragment>
      </StatusMsg>
    {/if}
  </ContentFieldOption>
</ContentFieldOptionGroup>
