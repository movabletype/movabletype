<script>
  import { recalcHeight, update } from "../Utils.ts";
  import { cfields } from "../Store.ts";
//  import ContentType from './ContentType.svelte';
  import SingleLineText from './SingleLineText.svelte';
//  import MultiLineText from './MultiLineText.svelte';
  import Number from './Number.svelte';
  import URL from './URL.svelte';
  import DateTime from './DateTime.svelte';
  import Date from './Date.svelte';
  import Time from './Time.svelte';
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

  function deleteField() {
    const label = item.label ? item.label : trans('No Name');
    if (!confirm(trans('Do you want to delete [_1]([_2])?', label, item.typeLabel))) {
      return;
    }
    cfields.update(arr => {
      const newArray = arr.slice(0, itemIndex).concat(arr.slice(itemIndex + 1));
      return newArray;
    });
    update();
    isEmpty = $cfields.length > 0 ? false : true;
    const target = document.getElementsByClassName('mt-draggable__area')[0];
    recalcHeight(target);
  }

  function duplicateField(e) {
    let newItem = jQuery.extend({}, $cfields[itemIndex]);
    const field = document.querySelectorAll(".content-field [data-is='" + newItem.type + "']");
    const options = gatheringData('content-field-block-' + e.target.dataset.id);
    newItem.options = options;
    newItem.id = Math.random().toString(36).slice(-8);
    let label = document.querySelector('#field-options-' + e.target.dataset.id + ' input[name="label"]').value;  
    if (!label) {
      label = jQuery('#content-field-block-' + e.target.dataset.id).find('[name="label"]').val();
      if (label === '') {
        label = trans('No Name');
      }
    }
    newItem.label = trans('Duplicate') + '-' + label;
    newItem.options.label = newItem.label;
    newItem.order = $cfields.length+1;
    newItem.isNew = true;
    newItem.isShow = 'show';
    cfields.update(arr => [...arr, newItem]);
    const target = document.getElementsByClassName('mt-draggable__area')[0];
    recalcHeight(target);
    update();
  }
</script>

<div class="mt-collapse__container">
  <div class="col-auto"><ss title="{ trans('Move') }" class="mt-icon" href="{ StaticURI }/images/sprite.svg#ic_move"></ss></div>
  <div class="col text-wrap"><ss title="{ trans('ContentField') }" class="mt-icon--secondary" href="{ StaticURI }images/sprite.svg#ic_contentstype"></ss>{ label || '' } ({ typeLabel }) {#if realId}<span>(ID: { realId })</span>{/if}</div>
  <div class="col-auto">
      <a data-id="{ id }" href="javascript:void(0)" on:click={ duplicateField } class="d-inline-block duplicate-content-field"><ss title="{ trans('Duplicate') }" class="mt-icon--secondary" href="{ StaticURI }images/sprite.svg#ic_duplicate"></ss></a>
    <a href="javascript:void(0)" on:click={ deleteField } class="d-inline-block delete-content-field"><ss title="{ trans('Delete') }" class="mt-icon--secondary" href="{ StaticURI }images/sprite.svg#ic_trash"></ss></a>
    <a data-bs-toggle="collapse" href="#field-options-{ id }" aria-expanded="{ isShow === 'show' ? 'true' : 'false' }" aria-controls="field-options-{ id }" class="d-inline-block"><ss title="{ trans('Edit') }" class="mt-icon--secondary" href="{ StaticURI }images/sprite.svg#ic_collapse"></ss></a>
  </div>
</div>
<div data-is={ type } class="collapse mt-collapse__content { isShow }" id="field-options-{id}" fieldid={ id } options={ this.options } isnew={ isNew }>
{#if type === "single-line-text"}
    <SingleLineText
      fieldId={ id }
      bind:label={ label }
      options={ { "description": "", "required": "", "displays": "", "initial_value": "", "min_length": "", "max_length": "" } }
      isNew={ isNew } />
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
      fieldId={ id }
      bind:label={ label }
      options={ { "description": "", "required": "", "displays": "", "initial_value": "", "min_value": "", "max_value": "", "decimal_places": "" } }
      isNew={ isNew } />
{:else if type === "url"}
    <URL
      fieldId={ id }
      bind:label={ label }
      options={ { "description": "", "required": "", "displays": "", "initial_value": "" } }
      isNew={ isNew } />
{:else if type === "date-and-time"}
    <DateTime
      fieldId={ id }
      bind:label={ label }
      options={ { "description": "", "required": "", "displays": "", "initial_date": "", "initial_time": "" } }
      isNew={ isNew } />
{:else if type === "date-only"}
    <Date
      fieldId={ id }
      bind:label={ label }
      options={ { "description": "", "required": "", "displays": "", "initial_value": "" } }
      isNew={ isNew } />
{:else if type === "time-only"}
    <Time
      fieldId={ id }
      bind:label={ label }
      options={ { "description": "", "required": "", "displays": "", "initial_value": "" } }
      isNew={ isNew } />
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
