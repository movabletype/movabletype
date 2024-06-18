<script lang="ts">
  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  // svelte-ignore unused-export-let
  export let config: MT.ContentType.ConfigSettings;
  export let field: MT.ContentType.Field;
  export let id: string;
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
  type="asset-video"
  fieldId={field.id ?? ""}
  {id}
  isNew={field.isNew ? true : false}
  bind:label
  {options}
>
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
      bind:checked={multiple}
    /><label for="asset_video-multiple" class="form-label">
      {window.trans("Allow users to select multiple video assets?")}
    </label>
  </ContentFieldOption>

  <ContentFieldOption
    id="asset_video-min"
    label={window.trans("Minimum number of selections")}
    attrShow={multiple ? true : false}
  >
    <input
      {...{ ref: "min" }}
      type="number"
      name="min"
      id="asset_video-min"
      class="form-control w-25"
      min="0"
      value={options.min ?? ""}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="asset_video-max"
    label={window.trans("Maximum number of selections")}
    attrShow={multiple ? true : false}
  >
    <input
      {...{ ref: "max" }}
      type="number"
      name="max"
      id="asset_video-max"
      class="form-control w-25"
      min="1"
      value={options.max ?? ""}
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
      bind:checked={options.allow_upload}
    /><label for="asset_video-allow_upload" class="form-label">
      {window.trans("Allow users to upload a new video asset?")}
    </label>
  </ContentFieldOption>
</ContentFieldOptionGroup>
