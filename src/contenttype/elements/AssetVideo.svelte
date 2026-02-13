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
  });
</script>

<ContentFieldOptionGroup type="asset-video" bind:field {id} bind:options>
  <ContentFieldOption
    id="asset_video-multiple"
    label={window.trans("Allow users to select multiple video assets?")}
  >
    <input
      {...{ ref: "multiple" }}
      type="checkbox"
      class="mt-switch form-control"
      id="asset_video-multiple"
      name="multiple"
      checked={displayOptions.multiple}
      onchange={(e) => {
        options.multiple = e.currentTarget.checked ? 1 : 0;
      }}
    /><label for="asset_video-multiple" class="form-label">
      {window.trans("Allow users to select multiple video assets?")}
    </label>
  </ContentFieldOption>

  <ContentFieldOption
    id="asset_video-min"
    label={window.trans("Minimum number of selections")}
    attrShow={displayOptions.multiple}
  >
    <input
      {...{ ref: "min" }}
      type="number"
      name="min"
      id="asset_video-min"
      class="form-control w-25"
      min="0"
      value={displayOptions.min}
      onchange={(e) => {
        options.min = e.currentTarget.value;
      }}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="asset_video-max"
    label={window.trans("Maximum number of selections")}
    attrShow={displayOptions.multiple}
  >
    <input
      {...{ ref: "max" }}
      type="number"
      name="max"
      id="asset_video-max"
      class="form-control w-25"
      min="1"
      value={displayOptions.max}
      onchange={(e) => {
        options.max = e.currentTarget.value;
      }}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="asset_video-allow_upload"
    label={window.trans("Allow users to upload a new video asset?")}
  >
    <input
      {...{ ref: "allow_upload" }}
      type="checkbox"
      class="mt-switch form-control"
      id="asset_video-allow_upload"
      name="allow_upload"
      checked={displayOptions.allow_upload}
      onchange={(e) => {
        options.allow_upload = e.currentTarget.checked ? 1 : 0;
      }}
    /><label for="asset_video-allow_upload" class="form-label">
      {window.trans("Allow users to upload a new video asset?")}
    </label>
  </ContentFieldOption>
</ContentFieldOptionGroup>
