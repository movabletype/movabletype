<script lang="ts">
  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  // svelte-ignore unused-export-let
  export let config: MT.ContentType.ConfigSettings;
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

  if (options.allow_upload === "0") {
    options.allow_upload = 0;
  }

  let multiple = options.multiple;
</script>

<ContentFieldOptionGroup
  type="asset-image"
  {fieldId}
  {id}
  {isNew}
  bind:label
  {options}
>
  <ContentFieldOption
    id="asset_image-multiple"
    label={window.trans("Allow users to select multiple image assets?")}
  >
    <input
      {...{ ref: "multiple" }}
      type="checkbox"
      class="mt-switch form-control"
      id="asset_image-multiple"
      name="multiple"
      bind:checked={multiple}
    /><label for="asset_image-multiple" class="form-label">
      {window.trans("Allow users to select multiple image assets?")}
    </label>
  </ContentFieldOption>

  <ContentFieldOption
    id="asset_image-min"
    label={window.trans("Minimum number of selections")}
    attrShow={multiple ? true : false}
  >
    <input
      {...{ ref: "min" }}
      type="number"
      name="min"
      id="asset_image-min"
      class="form-control w-25"
      min="0"
      value={options.min ?? ""}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="asset_image-max"
    label={window.trans("Maximum number of selections")}
    attrShow={multiple ? true : false}
  >
    <input
      {...{ ref: "max" }}
      type="number"
      name="max"
      id="asset_image-max"
      class="form-control w-25"
      min="1"
      value={options.max ?? ""}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="asset_image-allow_upload"
    label={window.trans("Allow users to upload a new image asset?")}
  >
    <input
      {...{ ref: "allow_upload" }}
      type="checkbox"
      class="mt-switch form-control"
      id="asset_image-allow_upload"
      name="allow_upload"
      bind:checked={options.allow_upload}
    /><label for="asset_image-allow_upload" class="form-label">
      {window.trans("Allow users to upload a new image asset?")}
    </label>
  </ContentFieldOption>

  <ContentFieldOption
    id="asset_image-preview_width"
    label={window.trans("Thumbnail width")}
  >
    <input
      {...{ ref: "preview_width" }}
      type="number"
      class="form-control w-25"
      id="asset_image-preview_width"
      name="preview_width"
      value={options.preview_width || 80}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="asset_image-preview_height"
    label={window.trans("Thumbnail height")}
  >
    <input
      {...{ ref: "preview_height" }}
      type="number"
      class="form-control w-25"
      id="asset_image-preview_height"
      name="preview_height"
      value={options.preview_height || 80}
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
