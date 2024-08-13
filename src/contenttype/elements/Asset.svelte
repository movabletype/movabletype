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

  if (options.multiple === "0") {
    options.multiple = 0;
  }

  if (options.allow_upload === "0") {
    options.allow_upload = 0;
  }

  // changeStateMultiple was removed because unused

  options.min ??= "";
  options.max ??= "";
</script>

<ContentFieldOptionGroup type="asset" bind:field {id} bind:options>
  <ContentFieldOption
    id="asset-multiple"
    label={window.trans("Allow users to select multiple assets?")}
  >
    <!-- onclick was removed and bind is used -->
    <input
      {...{ ref: "multiple" }}
      type="checkbox"
      class="mt-switch form-control"
      id="asset-multiple"
      name="multiple"
      bind:checked={options.multiple}
    /><label for="asset-multiple" class="form-label">
      {window.trans("Allow users to select multiple assets?")}
    </label>
  </ContentFieldOption>

  <ContentFieldOption
    id="asset-min"
    label={window.trans("Minimum number of selections")}
    attrShow={options.multiple}
  >
    <input
      {...{ ref: "min" }}
      type="number"
      name="min"
      id="asset-min"
      class="form-control w-25"
      min="0"
      bind:value={options.min}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="asset-max"
    label={window.trans("Maximum number of selections")}
    attrShow={options.multiple}
  >
    <input
      {...{ ref: "max" }}
      type="number"
      name="max"
      id="asset-max"
      class="form-control w-25"
      min="1"
      bind:value={options.max}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="asset-allow_upload"
    label={window.trans("Allow users to upload a new asset?")}
  >
    <input
      {...{ ref: "allow_upload" }}
      type="checkbox"
      class="mt-switch form-control"
      id="asset-allow_upload"
      name="allow_upload"
      bind:checked={options.allow_upload}
    /><label for="asset-allow_upload" class="form-label">
      {window.trans("Allow users to upload a new asset?")}
    </label>
  </ContentFieldOption>
</ContentFieldOptionGroup>
