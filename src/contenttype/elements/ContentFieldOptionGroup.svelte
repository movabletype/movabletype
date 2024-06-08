<script lang="ts">
  import ContentFieldOption from "./ContentFieldOption.svelte";
  import { recalcHeight, update } from "../Utils";

  export let isNew: boolean;
  export let fieldId: string;
  export let type: string;
  export let labelValue: string;
  export let options: {
    description?: string;
    displays?: {
      force?: boolean;
      default?: boolean;
      optional?: boolean;
      none?: boolean;
    };
    required?: boolean;
  };

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

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const inputLabel = (e) => {
    labelValue = e.target.value;
    update();
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const changeStateRequired = (e) => {
    options.required = e.target.checked;
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const closePanel = () => {
    const root = document.querySelector("#field-options-" + fieldId);
    if (!root) {
      return;
    }

    let className = root.className;
    root.className = className.replace(/\s*show\s*/, "");
    const target = document.getElementsByClassName("mt-draggable__area")[0];
    recalcHeight(target);

    jQuery("a[aria-controls='field-options-" + fieldId + "']").attr(
      "aria-expanded",
      "false",
    );
  };
</script>

<input
  type="hidden"
  {...{ ref: "id" }}
  name="id"
  id="single-line-text-id"
  class="form-control"
  value={isNew ? `id:${fieldId}` : fieldId}
/>

<ContentFieldOption
  id="{type}-label"
  label={window.trans("Label")}
  required={1}
>
  <svelte:fragment slot="inside">
    <input
      type="text"
      {...{ ref: "label" }}
      name="label"
      id="{type}-label"
      class="form-control html5-form"
      on:input={inputLabel}
      value={labelValue || ""}
      required
      data-mt-content-field-unique
    />
  </svelte:fragment>
</ContentFieldOption>

<ContentFieldOption
  id="{type}-description"
  label={window.trans("Description")}
  showHint={1}
  hint={window.trans("The entered message is displayed as a input field hint.")}
>
  <svelte:fragment slot="inside">
    <input
      type="text"
      {...{ ref: "description" }}
      name="description"
      id="{type}-description"
      class="form-control"
      aria-describedby="{type}-description-field-help"
      value={options.description}
    />
  </svelte:fragment>
</ContentFieldOption>

<ContentFieldOption
  id="{type}-required"
  label={window.trans("Is this field required?")}
>
  <svelte:fragment slot="inside">
    <input
      {...{ ref: "required" }}
      type="checkbox"
      class="mt-switch form-control"
      id="{type}-required"
      name="required"
      checked={options.required || false}
      on:click={changeStateRequired}
    />
    <label for="{type}-required">
      {window.trans("Is this field required?")}
    </label>
  </svelte:fragment>
</ContentFieldOption>

<ContentFieldOption
  id="{type}-display"
  label={window.trans("Display Options")}
  required={1}
  showHint={1}
  hint={window.trans(
    "Choose the display options for this content field in the listing screen.",
  )}
>
  <svelte:fragment slot="inside">
    <select
      {...{ ref: "display" }}
      name="display"
      id="{type}-display"
      class="custom-select form-control form-select"
    >
      <option value="force" selected={options.displays?.force}
        >{window.trans("Force")}</option
      >
      <option value="default" selected={options.displays?.default}
        >{window.trans("Default")}</option
      >
      <option value="optional" selected={options.displays?.optional}
        >{window.trans("Optional")}</option
      >
      <option value="none" selected={options.displays?.none}
        >{window.trans("None")}</option
      >
    </select>
  </svelte:fragment>
</ContentFieldOption>

<slot name="body" />

<div class="form-group-button">
  <button type="button" class="btn btn-default" on:click={closePanel}>
    {window.trans("Close")}
  </button>
</div>

<slot name="script" />
