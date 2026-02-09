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
    multiple:
      options.multiple === 1 ||
      options.multiple === "1" ||
      options.multiple === true,
    allow_upload:
      options.allow_upload === 1 ||
      options.allow_upload === "1" ||
      options.allow_upload === true,
    min: options.min ?? "",
    max: options.max ?? "",
    preview_width: options.preview_width ?? 80,
    preview_height: options.preview_height ?? 80,
  });
</script>

<ContentFieldOptionGroup type="asset-image" bind:field {id} bind:options>
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
      checked={displayOptions.multiple}
      onchange={(e) => {
        options.multiple = e.currentTarget.checked ? 1 : 0;
      }}
    /><label for="asset_image-multiple" class="form-label">
      {window.trans("Allow users to select multiple image assets?")}
    </label>
  </ContentFieldOption>

  <ContentFieldOption
    id="asset_image-min"
    label={window.trans("Minimum number of selections")}
    attrShow={displayOptions.multiple}
  >
    <input
      {...{ ref: "min" }}
      type="number"
      name="min"
      id="asset_image-min"
      class="form-control w-25"
      min="0"
      value={displayOptions.min}
      onchange={(e) => {
        options.min = e.currentTarget.value;
      }}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="asset_image-max"
    label={window.trans("Maximum number of selections")}
    attrShow={displayOptions.multiple}
  >
    <input
      {...{ ref: "max" }}
      type="number"
      name="max"
      id="asset_image-max"
      class="form-control w-25"
      min="1"
      value={displayOptions.max}
      onchange={(e) => {
        options.max = e.currentTarget.value;
      }}
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
      checked={displayOptions.allow_upload}
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
      value={displayOptions.preview_width}
      onchange={(e) => {
        options.preview_width = e.currentTarget.value;
      }}
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
      value={displayOptions.preview_height}
      onchange={(e) => {
        options.preview_height = e.currentTarget.value;
      }}
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
