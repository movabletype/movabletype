<script lang="ts">
  import { onMount } from "svelte";

  import ContentFieldOption from "./ContentFieldOption.svelte";
  import { recalcHeight, update } from "../Utils";

  export let id: string;
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
  const self: { options?: any; id?: any; fieldId?: string; isNew?: boolean } =
    {}; // FIXME
  self.options = options;
  if (!self.options) {
    self.options = {};
  }
  self.options.displays = {};
  self.options.displays.force = "";
  self.options.displays.default = "";
  self.options.displays.optional = "";
  self.options.displays.none = "";
  if (self.options.display) {
    self.options.displays[self.options.display] = "selected";
  } else {
    self.options.displays["default"] = "selected";
  }
  self.id = id;
  self.fieldId = fieldId;
  self.isNew = isNew;

  onMount(() => {
    const root = getRoot();
    if (!root) {
      return;
    }

    const elms = root.querySelectorAll("*");
    Array.prototype.slice.call(elms).forEach(function (v) {
      if (v.hasAttribute("id")) {
        v.setAttribute("id", v.getAttribute("id") + "-" + id);
      }
      if (v.tagName.toLowerCase() == "label" && v.hasAttribute("for")) {
        v.setAttribute("for", v.getAttribute("for") + "-" + id);
      }
    });
  });

  const inputLabel = (e: Event): void => {
    const target = e.target as HTMLInputElement;
    labelValue = target.value;
    update();
  };

  // move gatheringData to Utils.ts

  const closePanel = (): void => {
    const root = getRoot();
    if (!root) {
      return;
    }

    let className = root.className;
    root.className = className.replace(/\s*show\s*/, ""); // TODO
    const target = document.getElementsByClassName("mt-draggable__area")[0];
    recalcHeight(target);

    jQuery("a[aria-controls='field-options-" + fieldId + "']").attr(
      "aria-expanded",
      "false",
    );
  };

  const changeStateRequired = (e: Event): void => {
    const target = e.target as HTMLInputElement;
    options.required = target.checked;
  };

  const getRoot = (): Element | null => {
    return document.querySelector("#field-options-" + fieldId);
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
      value={options?.description}
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
      checked={options?.required || false}
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
      <option value="force" selected={options?.displays?.force}
        >{window.trans("Force")}</option
      >
      <option value="default" selected={options?.displays?.default}
        >{window.trans("Default")}</option
      >
      <option value="optional" selected={options?.displays?.optional}
        >{window.trans("Optional")}</option
      >
      <option value="none" selected={options?.displays?.none}
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
