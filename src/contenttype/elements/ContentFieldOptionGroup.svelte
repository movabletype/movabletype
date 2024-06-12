<script lang="ts">
  import { onMount } from "svelte";

  import ContentFieldOption from "./ContentFieldOption.svelte";
  import { recalcHeight, update } from "../Utils";

  export let id: string;
  export let isNew: boolean;
  export let fieldId: string;
  export let type: string;
  export let label: string;
  export let options: { [key: string]: any } = {};

  // Initialize
  options.displays = {};
  options.displays.force = "";
  options.displays.default = "";
  options.displays.optional = "";
  options.displays.none = "";
  if (options.display) {
    options.displays[options.display] = "selected";
  } else {
    options.displays["default"] = "selected";
  }

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
    label = target.value;
    update();
  };

  // move gatheringData to Utils.ts

  const closePanel = (): void => {
    const root = getRoot();
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
  id="{type}-id"
  class="form-control"
  value={isNew ? `id:${fieldId}` : fieldId}
/>

<ContentFieldOption
  id="{type}-label"
  label={window.trans("Label")}
  required={1}
>
  <input
    type="text"
    {...{ ref: "label" }}
    name="label"
    id="{type}-label"
    class="form-control html5-form"
    on:input={inputLabel}
    value={label || ""}
    required
    data-mt-content-field-unique
  />
</ContentFieldOption>

<ContentFieldOption
  id="{type}-description"
  label={window.trans("Description")}
  showHint={1}
  hint={window.trans("The entered message is displayed as a input field hint.")}
>
  <input
    type="text"
    {...{ ref: "description" }}
    name="description"
    id="{type}-description"
    class="form-control"
    aria-describedby="{type}-description-field-help"
    value={options?.description}
  />
</ContentFieldOption>

<ContentFieldOption
  id="{type}-required"
  label={window.trans("Is this field required?")}
>
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
  <select
    {...{ ref: "display" }}
    name="display"
    id="{type}-display"
    class="custom-select form-control form-select"
  >
    <option value="force" selected={options.displays.force}
      >{window.trans("Force")}</option
    >
    <option value="default" selected={options.displays.default}
      >{window.trans("Default")}</option
    >
    <option value="optional" selected={options.displays.optional}
      >{window.trans("Optional")}</option
    >
    <option value="none" selected={options.displays.none}
      >{window.trans("None")}</option
    >
  </select>
</ContentFieldOption>

<slot />

<div class="form-group-button">
  <button type="button" class="btn btn-default" on:click={closePanel}>
    {window.trans("Close")}
  </button>
</div>
