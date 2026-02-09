<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";
  import { onMount } from "svelte";

  let {
    config: _config,
    field = $bindable(),
    gather = $bindable(),
    id,
    options,
    optionsHtmlParams: _optionsHtmlParams,
  }: ContentType.ContentFieldProps = $props();

  onMount(() => {
    if (options.multiple === "0") {
      options.multiple = 0;
    }

    if (options.allow_upload === "0") {
      options.allow_upload = 0;
    }

    options.min ??= "";
    options.max ??= "";

    // changeStateMultiple was removed because unused
  });
</script>

<ContentFieldOptionGroup type="asset-video" bind:field {id} {options}>
  <ContentFieldOption
    id="asset_video-multiple"
    label={window.trans("Allow users to select multiple video assets?")}
  >
    <!-- onclick was removed and bind is used -->
    <input
      {...{ ref: "multiple" }}
      type="checkbox"
      class="mt-switch form-control"
      id="asset_video-multiple"
      name="multiple"
      checked={options.multiple}
    /><label for="asset_video-multiple" class="form-label">
      {window.trans("Allow users to select multiple video assets?")}
    </label>
  </ContentFieldOption>

  <ContentFieldOption
    id="asset_video-min"
    label={window.trans("Minimum number of selections")}
    attrShow={options.multiple ? true : false}
  >
    <input
      {...{ ref: "min" }}
      type="number"
      name="min"
      id="asset_video-min"
      class="form-control w-25"
      min="0"
      value={options.min}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="asset_video-max"
    label={window.trans("Maximum number of selections")}
    attrShow={options.multiple ? true : false}
  >
    <input
      {...{ ref: "max" }}
      type="number"
      name="max"
      id="asset_video-max"
      class="form-control w-25"
      min="1"
      value={options.max}
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
      checked={options.allow_upload}
    /><label for="asset_video-allow_upload" class="form-label">
      {window.trans("Allow users to upload a new video asset?")}
    </label>
  </ContentFieldOption>
</ContentFieldOptionGroup>
