<script>
  import { recalcHeight, update } from "../Utils.ts";
  import { cfields } from "../Store.ts";
  //  import ContentType from './ContentType.svelte';
  import SingleLineText from "./SingleLineText.svelte";
  //  import MultiLineText from './MultiLineText.svelte';
  import Number from "./Number.svelte";
  import URL from "./URL.svelte";
  import DateTime from "./DateTime.svelte";
  import Date from "./Date.svelte";
  import Time from "./Time.svelte";
  //  import SelectBox from './SelectBox.svelte';
  //  import RadioButton from './RadioButton.svelte';
  //  import Checkboxes from './Checkboxes.svelte';
  //  import Asset from './Asset.svelte';
  // AssetAudio
  // AssetVideo
  // AssetImage
  // EmbeddedText
  //  import Categories from './Categories.svelte';
  //  import Tags from './Tags.svelte';
  //  import List from './List.svelte';
  //  import Table from './Table.svelte';
  //  import TextLabel from './TextLabel.svelte';
  //  import Common from './Common.svelte';
  // selection_common_script

  export let id;
  export let isNew;
  export let isShow;
  export let item;
  export let label;
  export let realId;
  export let type;
  export let typeLabel;
  export let itemIndex;
  export let gatheringData;
  export let isEmpty;

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const deleteField = () => {
    const label = item.label ? item.label : window.trans("No Name");
    if (
      !confirm(
        window.trans("Do you want to delete [_1]([_2])?", label, item.typeLabel)
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

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const duplicateField = (e) => {
    let newItem = jQuery.extend({}, $cfields[itemIndex]);
    // const field = document.querySelectorAll(
    //   ".content-field [data-is='" + newItem.type + "']"
    // );
    const options = gatheringData("content-field-block-" + e.target.dataset.id);
    newItem.options = options;
    newItem.id = Math.random().toString(36).slice(-8);
    let label = document.querySelector(
      "#field-options-" + e.target.dataset.id + ' input[name="label"]'
    ).value;
    if (!label) {
      label = jQuery("#content-field-block-" + e.target.dataset.id)
        .find('[name="label"]')
        .val();
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
  <div class="col-auto">
    <ss
      title={window.trans("Move")}
      class="mt-icon"
      href="{window.StaticURI}/images/sprite.svg#ic_move"
    />
  </div>
  <div class="col text-wrap">
    <ss
      title={window.trans("ContentField")}
      class="mt-icon--secondary"
      href="{window.StaticURI}images/sprite.svg#ic_contentstype"
    />{label || ""} ({typeLabel}) {#if realId}<span>(ID: {realId})</span>{/if}
  </div>
  <div class="col-auto">
    <!-- svelte-ignore a11y-invalid-attribute -->
    <a
      data-id={id}
      href="javascript:void(0)"
      on:click={duplicateField}
      class="d-inline-block duplicate-content-field"
      ><ss
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
      ><ss
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
      ><ss
        title={window.trans("Edit")}
        class="mt-icon--secondary"
        href="{window.StaticURI}images/sprite.svg#ic_collapse"
      /></a
    >
  </div>
</div>
<div
  data-is={type}
  class="collapse mt-collapse__content {isShow}"
  id="field-options-{id}"
  fieldid={id}
  options={this.options}
  isnew={isNew}
>
  {#if type === "single-line-text"}
    <SingleLineText
      fieldId={id}
      bind:label
      options={{
        description: "",
        required: "",
        displays: "",
        initial_value: "",
        min_length: "",
        max_length: "",
      }}
      {isNew}
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
      fieldId={id}
      bind:label
      options={{
        description: "",
        required: "",
        displays: "",
        initial_value: "",
        min_value: "",
        max_value: "",
        decimal_places: "",
      }}
      {isNew}
    />
  {:else if type === "url"}
    <URL
      fieldId={id}
      bind:label
      options={{
        description: "",
        required: "",
        displays: "",
        initial_value: "",
      }}
      {isNew}
    />
  {:else if type === "date-and-time"}
    <DateTime
      fieldId={id}
      bind:label
      options={{
        description: "",
        required: "",
        displays: "",
        initial_date: "",
        initial_time: "",
      }}
      {isNew}
    />
  {:else if type === "date-only"}
    <Date
      fieldId={id}
      bind:label
      options={{
        description: "",
        required: "",
        displays: "",
        initial_value: "",
      }}
      {isNew}
    />
  {:else if type === "time-only"}
    <Time
      fieldId={id}
      bind:label
      options={{
        description: "",
        required: "",
        displays: "",
        initial_value: "",
      }}
      {isNew}
    />
  {:else if type === "select-box"}
    <!--
    <SelectBox
      fieldId={ id }
      bind:label={ label }
      options={ { "description": "", "required": "", "displays": "", "multiple": 0, "min": "", "max": "", "can_add": "", "values": "" } }
      isNew={ isNew } />
-->
  {/if}
</div>
