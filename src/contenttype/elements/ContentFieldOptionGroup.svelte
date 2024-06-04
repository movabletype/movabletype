<script>
  import ContentFieldOption from './ContentFieldOption.svelte';
  import { recalcHeight, update } from "../Utils.ts";

  export let isNew;
  export let fieldId;
  export let type;
  export let labelValue;
  export let options;

  // Initialize
//  this.options = opts.options
//  if ( !this.options )
//    this.options = {}
//
//  this.options.displays = {}
//  this.options.displays.force = ""
//  this.options.displays.default = ""
//  this.options.displays.optional = ""
//  this.options.displays.none = ""
//  if ( this.options.display )
//    this.options.displays[this.options.display] = "selected"
//  else
//    this.options.displays['default'] = "selected"
//  this.id = opts.id
//  this.fieldId = opts.fieldid
//  this.isNew = opts.isnew
//
//  this.on('mount', function() {
//    elms = this.root.querySelectorAll('*')
//    Array.prototype.slice.call(elms).forEach( function (v) {
//      if ( v.hasAttribute('id') ) {
//        v.setAttribute('id', v.getAttribute('id') + '-' + opts.id)
//      }
//      if ( v.tagName.toLowerCase() == 'label' && v.hasAttribute('for') ) {
//        v.setAttribute('for', v.getAttribute('for') + '-' + opts.id)
//      }
//    })
//  })

  function inputLabel(e) {
    labelValue = e.target.value;
    update();
  }

  function changeStateRequired(e) {
    options.required = e.target.checked;
  }

  function closePanel(e) {
    const root = document.querySelector('#field-options-' + fieldId);
    let className = root.className;
    root.className = className.replace(/\s*show\s*/,'');
    const target = document.getElementsByClassName('mt-draggable__area')[0];
    recalcHeight(target);

    jQuery("a[aria-controls='field-options-" + fieldId + "']").attr('aria-expanded', false);
  }
</script>

{#if isNew }
<input type="hidden" ref="id" name="id" id="single-line-text-id" class="form-control" value={ 'id:' + fieldId } >
{:else}
<input type="hidden" ref="id" name="id" id="single-line-text-id" class="form-control" value={ fieldId } >
{/if}

<ContentFieldOption
  id="{type}-label"
  label={ trans("Label") }
  required={ true }
  showLabel={ true }
>
  <svelte:fragment slot="inside">
    <input type="text" ref="label" name="label" id="{type}-label" class="form-control html5-form" on:input={ inputLabel } value={ labelValue || '' } required data-mt-content-field-unique>
  </svelte:fragment>
</ContentFieldOption>

<ContentFieldOption
  id="{type}-description"
  label={ trans("Description") }
  showLabel={ true }
  showHint={ true }
  hint={ trans("The entered message is displayed as a input field hint.") }
>
  <svelte:fragment slot="inside">
    <input type="text" ref="description" name="description" id="{type}-description" class="form-control" aria-describedby="{type}-description-field-help" value={ options.description }>
  </svelte:fragment>
</ContentFieldOption>

<ContentFieldOption
  id="{type}-required"
  label={ trans("Is this field required?") }
  showLabel={ true }
>
  <svelte:fragment slot="inside">
    <input ref="required" type="checkbox" class="mt-switch form-control" id="{type}-required" name="required" checked={ options.required } on:click={ changeStateRequired }><label for="{type}-required">{ trans("Is this field required?") }</label>
  </svelte:fragment>
</ContentFieldOption>

<ContentFieldOption
  id="{type}-display"
  label={ trans("Display Options") }
  showLabel={ true }
  required={ true }
  hint={ trans("Choose the display options for this content field in the listing screen.") }
  showHint={ true }
>
  <svelte:fragment slot="inside">
    <select ref="display" name="display" id="{type}-display" class="custom-select form-control form-select">
      <option value="force" selected={ options.displays.force }>{ trans("Force") }</option>
      <option value="default"  selected={ options.displays.default }>{ trans("Default") }</option>
      <option value="optional" selected={ options.displays.optional }>{ trans("Optional") }</option>
      <option value="none" selected={ options.displays.none }>{ trans("None") }</option>
    </select>
  </svelte:fragment>
</ContentFieldOption>

<slot name="body"/>

<div class="form-group-button">
  <button type="button" class="btn btn-default" on:click={ closePanel }>{ trans("Close") }</button>
</div>

<slot name="script" />
