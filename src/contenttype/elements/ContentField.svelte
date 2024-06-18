<script lang="ts">
  import { fieldsStore } from "../Store";
  import { recalcHeight, update } from "../Utils";

  import SVG from "../../svg/elements/SVG.svelte";

  import ContentType from "./ContentType.svelte";
  import SingleLineText from "./SingleLineText.svelte";
  import MultiLineText from "./MultiLineText.svelte";
  import Number from "./Number.svelte";
  import Url from "./Url.svelte";
  import DateTime from "./DateTime.svelte";
  import Date from "./Date.svelte";
  import Time from "./Time.svelte";
  import SelectBox from "./SelectBox.svelte";
  import RadioButton from "./RadioButton.svelte";
  import Checkboxes from "./Checkboxes.svelte";
  import Asset from "./Asset.svelte";
  import AssetAudio from "./AssetAudio.svelte";
  import AssetVideo from "./AssetVideo.svelte";
  import AssetImage from "./AssetImage.svelte";
  import EmbeddedText from "./EmbeddedText.svelte";
  import Categories from "./Categories.svelte";
  import Tags from "./Tags.svelte";
  import List from "./List.svelte";
  import Tables from "./Tables.svelte";
  import TextLabel from "./TextLabel.svelte";
  //  import Common from './Common.svelte';
  // selection_common_script

  export let config: MT.ContentType.ConfigSettings;
  export let field: MT.ContentType.Field;
  export let fieldIndex: number;
  export let gatheringData: (c: HTMLDivElement, index: number) => object;
  export let isEmpty: boolean;
  export let parent: HTMLDivElement;
  export let gather: (() => object) | undefined;
  export let optionsHtmlParams: MT.ContentType.OptionsHtmlParams;

  if (field.isNew === null) {
    field.isNew = false;
  }

  if (field.isShow === null) {
    field.isShow = "";
  }

  if (field.realId === null) {
    field.realId = "";
  }

  const ContentfieldMap = {
    "content-type": ContentType,
    "single-line-text": SingleLineText,
    "multi-line-text": MultiLineText,
    number: Number,
    url: Url,
    "date-and-time": DateTime,
    "date-only": Date,
    "time-only": Time,
    "select-box": SelectBox,
    "radio-button": RadioButton,
    checkboxes: Checkboxes,
    asset: Asset,
    "asset-audio": AssetAudio,
    "asset-video": AssetVideo,
    "asset-image": AssetImage,
    "embedded-text": EmbeddedText,
    categories: Categories,
    tags: Tags,
    list: List,
    tables: Tables,
    "text-label": TextLabel,
  };

  const deleteField = (): void => {
    const label = field.label ? field.label : window.trans("No Name");
    if (
      !confirm(
        window.trans(
          "Do you want to delete [_1]([_2])?",
          label,
          field.typeLabel,
        ),
      )
    ) {
      return;
    }
    fieldsStore.update((arr) => {
      const newArray = arr
        .slice(0, fieldIndex)
        .concat(arr.slice(fieldIndex + 1));
      return newArray;
    });
    update();
    isEmpty = $fieldsStore.length > 0 ? false : true;
    const target = document.getElementsByClassName("mt-draggable__area")[0];
    recalcHeight(target);
  };

  const duplicateField = (): void => {
    const newItem = jQuery.extend({}, $fieldsStore[fieldIndex]);
    newItem.options = gatheringData(parent, fieldIndex);
    newItem.id = Math.random().toString(36).slice(-8);
    let label = field.label;
    if (!label) {
      label = jQuery("#content-field-block-" + field.id)
        .find('[name="label"]')
        .val() as string;
      if (label === "") {
        label = window.trans("No Name");
      }
    }
    newItem.label = window.trans("Duplicate") + "-" + label;
    newItem.options.label = newItem.label;
    newItem.order = $fieldsStore.length + 1;
    newItem.isNew = true;
    newItem.isShow = "show";
    fieldsStore.update((arr) => [...arr, newItem]);
    const target = document.getElementsByClassName("mt-draggable__area")[0];
    recalcHeight(target);
    update();
  };
</script>

<div class="mt-collapse__container">
  <div class="col-auto p-0">
    <SVG
      title={window.trans("Move")}
      class="mt-icon"
      href="{window.StaticURI}/images/sprite.svg#ic_move"
    />
  </div>
  <div class="col text-wrap p-0">
    <SVG
      title={window.trans("ContentField")}
      class="mt-icon--secondary"
      href="{window.StaticURI}images/sprite.svg#ic_contentstype"
    />
    {field.label} ({field.typeLabel})
    {#if field.realId}<span>(ID: {field.realId})</span>{/if}
  </div>
  <div class="col-auto p-0">
    <!-- svelte-ignore a11y-invalid-attribute -->
    <a
      href="javascript:void(0)"
      on:click={duplicateField}
      class="d-inline-block duplicate-content-field"
      ><SVG
        title={window.trans("Duplicate")}
        class="mt-icon--secondary"
        href="{window.StaticURI}images/sprite.svg#ic_duplicate"
      /></a
    >
    <!-- svelte-ignore a11y-invalid-attribute -->
    <a
      href="javascript:void(0)"
      on:click={deleteField}
      class="d-inline-block delete-content-field"
      ><SVG
        title={window.trans("Delete")}
        class="mt-icon--secondary"
        href="{window.StaticURI}images/sprite.svg#ic_trash"
      /></a
    >
    <a
      data-bs-toggle="collapse"
      href="#field-options-{field.id}"
      aria-expanded={field.isShow === "show" ? "true" : "false"}
      aria-controls="field-options-{field.id}"
      class="d-inline-block"
      ><SVG
        title={window.trans("Edit")}
        class="mt-icon--secondary"
        href="{window.StaticURI}images/sprite.svg#ic_collapse"
      /></a
    >
  </div>
</div>
<div
  data-is={field.type}
  class="collapse mt-collapse__content"
  class:show={field.isShow === "show"}
  id="field-options-{field.id}"
  {...{ fieldid: field.id, isnew: field.isNew }}
>
  <svelte:component
    this={ContentfieldMap[field.type]}
    {config}
    bind:field
    bind:gather
    id={`field-options-${field.id}`}
    isNew={field.isNew}
    bind:label={field.label}
    options={field.options || {}}
    {optionsHtmlParams}
  />
</div>
