<script lang="ts">
  // copied from lib/MT/Template/ContextHandlers.pm

  import type * as ContentType from "../../@types/contenttype";

  import { onMount } from "svelte";

  import { recalcHeight } from "../Utils";

  import ContentFieldOption from "./ContentFieldOption.svelte";

  export let field: ContentType.Field;
  export let id: string;
  export let options: ContentType.Options;
  export let type: string;

  if (!type) {
    console.error('ContentFieldOptionGroup: "type" attribute is required.');
  }

  $: {
    // Initialize
    if (!options.display) {
      options.display = "default";
    }
  }

  onMount(() => {
    const root = getRoot();
    if (!root) {
      return;
    }

    const elms = root.querySelectorAll("*");
    Array.prototype.slice.call(elms).forEach(function (v) {
      if (
        v.hasAttribute("id") &&
        !v.classList.contains("mt-custom-contentfield") // do not change id in Custom.svelte
      ) {
        v.setAttribute("id", v.getAttribute("id") + "-" + id);
      }
      if (v.tagName.toLowerCase() === "label" && v.hasAttribute("for")) {
        v.setAttribute("for", v.getAttribute("for") + "-" + id);
      }
    });
  });

  // inputLabel was removed because unused

  // gatheringData was moved to ContentFields.svelte

  const closePanel = (): void => {
    const root = getRoot();
    if (!root) {
      return;
    }

    let className = root.className;
    root.className = className.replace(/\s*show\s*/, "");
    const target = document.getElementsByClassName("mt-draggable__area")[0];
    recalcHeight(target);

    jQuery("a[aria-controls='field-options-" + field.id + "']").attr(
      "aria-expanded",
      "false",
    );
  };

  // changeStateRequired was removed bacause unused

  // $script was removed, and script is written in content field svelte file

  // added in Svelte
  const getRoot = (): Element | null => {
    return document.querySelector("#field-options-" + field.id);
  };
</script>

<!-- merge 2 input tags in Riot.js implementation to 1 input tag -->
<input
  type="hidden"
  {...{ ref: "id" }}
  name="id"
  id="{type}-id"
  class="form-control"
  value={field.isNew ? `id:${field.id}` : field.id}
/>

<ContentFieldOption
  id="{type}-label"
  label={window.trans("Label")}
  required={1}
>
  <!-- oninput was removed and bind is used -->
  <input
    type="text"
    {...{ ref: "label" }}
    name="label"
    id="{type}-label"
    class="form-control html5-form"
    bind:value={field.label}
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
    bind:value={options.description}
  />
</ContentFieldOption>

<ContentFieldOption
  id="{type}-required"
  label={window.trans("Is this field required?")}
>
  <!-- onclick was removed and bind is used -->
  <input
    {...{ ref: "required" }}
    type="checkbox"
    class="mt-switch form-control"
    id="{type}-required"
    name="required"
    bind:checked={options.required}
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
  <!-- selected was removed and bind is used -->
  <select
    {...{ ref: "display" }}
    name="display"
    id="{type}-display"
    class="custom-select form-control form-select"
    bind:value={options.display}
  >
    <option value="force">{window.trans("Force")}</option>
    <option value="default">{window.trans("Default")}</option>
    <option value="optional">{window.trans("Optional")}</option>
    <option value="none">{window.trans("None")}</option>
  </select>
</ContentFieldOption>

<slot />

<div class="form-group-button">
  <button type="button" class="btn btn-default" on:click={closePanel}>
    {window.trans("Close")}
  </button>
</div>
