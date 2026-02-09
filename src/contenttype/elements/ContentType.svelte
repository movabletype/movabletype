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
  const contentTypes: Array<{ id: string; name: string }> =
    optionsHtmlParams.content_type.content_types;

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

<ContentFieldOptionGroup type="content-type" bind:field {id} bind:options>
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
      checked={displayOptions.multiple}
      onchange={(e) => {
        options.multiple = e.currentTarget.checked ? 1 : 0;
      }}
    /><label for="content_type-multiple" class="form-label">
      {window.trans("Allow users to select multiple values?")}
    </label>
  </ContentFieldOption>

  <ContentFieldOption
    id="content_type-min"
    label={window.trans("Minimum number of selections")}
    attrShow={displayOptions.multiple}
  >
    <input
      {...{ ref: "min" }}
      type="number"
      name="min"
      id="content_type-min"
      class="form-control w-25"
      min="0"
      value={displayOptions.min}
      onchange={(e) => {
        options.min = e.currentTarget.value;
      }}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="content_type-max"
    label={window.trans("Maximum number of selections")}
    attrShow={displayOptions.multiple}
  >
    <input
      {...{ ref: "max" }}
      type="number"
      name="max"
      id="content_type-max"
      class="form-control w-25"
      min="1"
      value={displayOptions.max}
      onchange={(e) => {
        options.max = e.currentTarget.value;
      }}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="content_type-source"
    required={1}
    label={window.trans("Source Content Type")}
  >
    {#if contentTypes.length > 0}
      <!-- selected was removed and bind is used -->
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
      {#snippet statusMsgContent()}
        {window.trans(
          "There is no content type that can be selected. Please create a content type if you use the Content Type field type.",
        )}
      {/snippet}
      <StatusMsg
        id="no-content-type"
        class="warning"
        canClose={0}
        msg={statusMsgContent}
      />
    {/if}
  </ContentFieldOption>
</ContentFieldOptionGroup>
