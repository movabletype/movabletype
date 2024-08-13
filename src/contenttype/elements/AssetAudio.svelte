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

<ContentFieldOptionGroup type="asset-audio" bind:field {id} bind:options>
  <ContentFieldOption
    id="asset_audio-multiple"
    label={window.trans("Allow users to select multiple assets?")}
  >
    <!-- onclick was removed and bind is used -->
    <input
      {...{ ref: "multiple" }}
      type="checkbox"
      class="mt-switch form-control"
      id="asset_audio-multiple"
      name="multiple"
      bind:checked={options.multiple}
    /><label for="asset_audio-multiple" class="form-label">
      {window.trans("Allow users to select multiple assets?")}
    </label>
  </ContentFieldOption>

  <ContentFieldOption
    id="asset_audio-min"
    label={window.trans("Minimum number of selections")}
    attrShow={options.multiple ? true : false}
  >
    <input
      {...{ ref: "min" }}
      type="number"
      name="min"
      id="asset_audio-min"
      class="form-control w-25"
      min="0"
      bind:value={options.min}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="asset_audio-max"
    label={window.trans("Maximum number of selections")}
    attrShow={options.multiple ? true : false}
  >
    <input
      {...{ ref: "max" }}
      type="number"
      name="max"
      id="asset_audio-max"
      class="form-control w-25"
      min="1"
      bind:value={options.max}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="asset_audio-allow_upload"
    label={window.trans("Allow users to upload a new audio asset?")}
  >
    <input
      {...{ ref: "allow_upload" }}
      type="checkbox"
      class="mt-switch form-control"
      id="asset_audio-allow_upload"
      name="allow_upload"
      bind:checked={options.allow_upload}
    /><label for="asset_audio-allow_upload" class="form-label">
      {window.trans("Allow users to upload a new audio asset?")}
    </label>
  </ContentFieldOption>
</ContentFieldOptionGroup>
