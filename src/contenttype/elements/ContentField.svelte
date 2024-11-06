<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import ContentFieldTypes from "../ContentFieldTypes";
  import { recalcHeight } from "../Utils";

  import Custom from "./Custom.svelte";
  import SVG from "../../svg/elements/SVG.svelte";

  export let config: ContentType.ConfigSettings;
  export let field: ContentType.Field;
  export let fields: ContentType.Fields;
  export let fieldIndex: number;
  export let fieldsStore: ContentType.FieldsStore;
  export let gatheringData: (c: HTMLDivElement, index: number) => object;
  export let parent: HTMLDivElement;
  export let gather: (() => object) | undefined;
  export let optionsHtmlParams: ContentType.OptionsHtmlParams;

  $: id = `field-options-${field.id}`;

  $: {
    if (field.isNew === null) {
      field.isNew = false;
    }

    if (field.isShow === null) {
      field.isShow = "";
    }

    if (field.realId === null) {
      field.realId = "";
    }

    if (field.options === null) {
      field.options = {};
    }
  }

  let gatherCore: (() => object) | undefined;
  let gatherCustom: (() => object) | undefined;
  $: {
    if (ContentFieldTypes.getCoreType(field.type)) {
      gather = gatherCore;
    } else {
      gather = gatherCustom;
    }
  }

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
    fields = fields.slice(0, fieldIndex).concat(fields.slice(fieldIndex + 1));
    // update is not needed in Svelte
    const target = document.getElementsByClassName("mt-draggable__area")[0];
    recalcHeight(target);
  };

  const duplicateField = (): void => {
    const newItem = jQuery.extend({}, field);
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
    newItem.order = fields.length + 1;
    newItem.isNew = true;
    newItem.isShow = "show";
    fields = [...fields, newItem];
    const target = document.getElementsByClassName("mt-draggable__area")[0];
    recalcHeight(target);
    // update is not needed in Svelte
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
    {field.label ?? ""} ({field.typeLabel})
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
  {id}
  {...{ fieldid: field.id, isnew: field.isNew }}
  bind:this={parent}
>
  <svelte:component
    this={ContentFieldTypes.getCoreType(field.type)}
    {config}
    bind:field
    bind:gather={gatherCore}
    {id}
    bind:options={field.options}
    {optionsHtmlParams}
  />
  <Custom
    {config}
    {fieldIndex}
    {fieldsStore}
    bind:gather={gatherCustom}
    {optionsHtmlParams}
  />
</div>
