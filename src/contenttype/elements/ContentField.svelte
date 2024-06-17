<script lang="ts">
  import { recalcHeight, update } from "../Utils";
  import { cfields } from "../Store";

  import SVG from "../../svg/elements/SVG.svelte";

  //  import ContentType from './ContentType.svelte';
  import SingleLineText from "./SingleLineText.svelte";
  //  import MultiLineText from './MultiLineText.svelte';
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

  export let id: string;
  export let isNew: boolean;
  export let isShow: string;
  export let item: MT.ContentType.Field;
  export let realId: string;
  export let type: string;
  export let typeLabel: string;
  export let itemIndex: number;
  export let gatheringData: (c: HTMLDivElement, index: number) => object;
  export let isEmpty: boolean;
  export let parent: HTMLDivElement;
  export let gather: (() => object) | undefined;
  export let optionsHtmlParams: MT.ContentType.OptionsHtmlParams;

  let label = item.label || "";

  const deleteField = (): void => {
    const label = item.label ? item.label : window.trans("No Name");
    if (
      !confirm(
        window.trans(
          "Do you want to delete [_1]([_2])?",
          label,
          item.typeLabel,
        ),
      )
    ) {
      return;
    }
    cfields.update((arr) => {
      const newArray = arr.slice(0, itemIndex).concat(arr.slice(itemIndex + 1));
      return newArray;
    });
    update();
    isEmpty = $cfields.length > 0 ? false : true;
    const target = document.getElementsByClassName("mt-draggable__area")[0];
    recalcHeight(target);
  };

  const duplicateField = (): void => {
    const newItem = jQuery.extend({}, $cfields[itemIndex]);
    newItem.options = gatheringData(parent, itemIndex);
    newItem.id = Math.random().toString(36).slice(-8);
    let label = item.label;
    if (!label) {
      label = jQuery("#content-field-block-" + item.id)
        .find('[name="label"]')
        .val() as string;
      if (label === "") {
        label = window.trans("No Name");
      }
    }
    newItem.label = window.trans("Duplicate") + "-" + label;
    newItem.options.label = newItem.label;
    newItem.order = $cfields.length + 1;
    newItem.isNew = true;
    newItem.isShow = "show";
    cfields.update((arr) => [...arr, newItem]);
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
    {label} ({typeLabel})
    {#if realId}<span>(ID: {realId})</span>{/if}
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
      href="#field-options-{id}"
      aria-expanded={isShow === "show" ? "true" : "false"}
      aria-controls="field-options-{id}"
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
  data-is={type}
  class="collapse mt-collapse__content"
  class:show={isShow === "show"}
  id="field-options-{id}"
  {...{ fieldid: id, isnew: isNew }}
>
  {#if type === "single-line-text"}
    <SingleLineText
      id={`field-options-${id}`}
      {isNew}
      fieldId={id}
      bind:label
      options={item.options || {}}
    />
  {:else if type === "multi-line-text"}
    <!--
    <MultiLineText
      fieldId={ id }
      bind:label={ label }
      options={ { "description": "", "required": "", "displays": "", "initial_value": "", "input_formats": "", "full_rich_text": "" } }
      isNew={ isNew } />
-->
  {:else if type === "number"}
    <Number
      id={`field-options-${id}`}
      {isNew}
      fieldId={id}
      bind:label
      options={item.options || {}}
    />
  {:else if type === "url"}
    <Url
      id={`field-options-${id}`}
      fieldId={id}
      bind:label
      options={item.options || {}}
      {isNew}
    />
  {:else if type === "date-and-time"}
    <DateTime
      id={`field-options-${id}`}
      {isNew}
      fieldId={id}
      bind:label
      options={item.options || {}}
    />
  {:else if type === "date-only"}
    <Date
      id={`field-options-${id}`}
      {isNew}
      fieldId={id}
      bind:label
      options={item.options || {}}
    />
  {:else if type === "time-only"}
    <Time
      id={`field-options-${id}`}
      {isNew}
      fieldId={id}
      bind:label
      options={item.options || {}}
    />
  {:else if type === "select-box"}
    <SelectBox
      id={`field-options-${id}`}
      {isNew}
      fieldId={id}
      bind:gather
      bind:label
      options={item.options || {}}
    />
  {:else if type === "radio-button"}
    <RadioButton
      id={`field-options-${id}`}
      {isNew}
      fieldId={id}
      bind:gather
      bind:label
      options={item.options || {}}
    />
  {:else if type === "checkboxes"}
    <Checkboxes
      id={`field-options-${id}`}
      {isNew}
      fieldId={id}
      bind:gather
      bind:label
      options={item.options || {}}
    />
  {:else if type === "asset"}
    <Asset
      id={`field-options-${id}`}
      {isNew}
      fieldId={id}
      bind:label
      options={item.options || {}}
    />
  {:else if type === "asset-audio"}
    <AssetAudio
      id={`field-options-${id}`}
      {isNew}
      fieldId={id}
      bind:label
      options={item.options || {}}
    />
  {:else if type === "asset-video"}
    <AssetVideo
      id={`field-options-${id}`}
      {isNew}
      fieldId={id}
      bind:label
      options={item.options || {}}
    />
  {:else if type === "asset-image"}
    <AssetImage
      id={`field-options-${id}`}
      {isNew}
      fieldId={id}
      bind:label
      options={item.options || {}}
    />
  {:else if type === "embedded-text"}
    <EmbeddedText
      id={`field-options-${id}`}
      {isNew}
      fieldId={id}
      bind:label
      options={item.options || {}}
    />
  {:else if type === "categories"}
    <Categories
      id={`field-options-${id}`}
      {isNew}
      fieldId={id}
      bind:label
      options={item.options || {}}
      {optionsHtmlParams}
    />
  {:else if type === "tags"}
    <Tags
      id={`field-options-${id}`}
      {isNew}
      fieldId={id}
      bind:label
      options={item.options || {}}
    />
  {:else if type === "list"}
    <List
      id={`field-options-${id}`}
      {isNew}
      fieldId={id}
      bind:label
      options={item.options || {}}
    />
  {:else if type === "tables"}
    <Tables
      id={`field-options-${id}`}
      {isNew}
      fieldId={id}
      bind:label
      options={item.options || {}}
    />
  {:else if type === "text-label"}
    <TextLabel
      id={`field-options-${id}`}
      {isNew}
      fieldId={id}
      bind:label
      options={item.options || {}}
    />
  {/if}
</div>
