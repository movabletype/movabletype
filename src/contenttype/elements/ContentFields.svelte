<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import { afterUpdate } from "svelte";

  import { recalcHeight } from "../Utils";

  import ContentField from "./ContentField.svelte";
  import SVG from "../../svg/elements/SVG.svelte";

  export let config: ContentType.ConfigSettings;
  export let fieldsStore: ContentType.FieldsStore;
  export let optionsHtmlParams: ContentType.OptionsHtmlParams;
  export let opts: ContentType.ContentFieldsOpts;
  export let root: Element;

  $: isEmpty = $fieldsStore.length > 0 ? false : true;
  let data = "";
  let droppable = false;
  const observer = opts.observer;
  let dragged: EventTarget | null = null;
  let draggedItem: ContentType.Field | null = null;
  const placeholder = document.createElement("div");
  placeholder.className = "placeholder";
  let dragoverState = false;
  let labelFields: Array<{ value: string; label: string }> = [];
  let labelField = opts.labelField;
  let isExpanded = false;

  const gathers: { [key: string]: (() => object) | undefined } = {};
  const tags: Array<HTMLDivElement> = [];

  afterUpdate(() => {
    const select = root.querySelector("#label_field") as HTMLSelectElement;
    jQuery(select)
      .find("option")
      .each(function (index, option) {
        if (option.attributes.getNamedItem("selected")) {
          select.selectedIndex = index;
          return false;
        }
      });
  });

  // Drag start from content field list
  observer.on("mtDragStart", function () {
    droppable = true;
  });

  // Drag end from content field list
  observer.on("mtDragEnd", function () {
    droppable = false;
    onDragEnd();
  });

  // Show detail modal
  jQuery(document).on("show.bs.modal", "#editDetail", function () {
    rebuildLabelFields();
    // update is not needed in Svelte
  });

  // Hide detail modal
  jQuery(document).on("hide.bs.modal", "#editDetail", function () {
    /* @ts-expect-error : mtValidate is not defined */
    if (jQuery("#name-field > input").mtValidate("simple")) {
      opts.name = jQuery("#name-field > input").val()?.toString() || "";
      window.setDirty(true);
      // update is not needed in Svelte
    } else {
      return false;
    }
  });

  // Shown collaped block
  jQuery(document).on(
    "shown.bs.collapse",
    ".mt-collapse__content",
    function () {
      const target = document.getElementsByClassName("mt-draggable__area")[0];
      recalcHeight(target);
      updateFieldsIsShowAll(); // need to update in Svelte
      updateToggleAll();
    },
  );

  // Hide collaped block
  jQuery(document).on(
    "hidden.bs.collapse",
    ".mt-collapse__content",
    function () {
      const target = document.getElementsByClassName("mt-draggable__area")[0];
      recalcHeight(target);
      updateFieldsIsShowAll(); // need to update in Svelte
      updateToggleAll();
    },
  );

  // Cannot drag while focusing on input / textarea
  jQuery(document).on(
    "focus",
    ".mt-draggable__area input, .mt-draggable__area textarea",
    function () {
      jQuery(this).closest(".mt-contentfield").attr("draggable", "false");
    },
  );

  // Set draggable back to true while not focusing on input / textarea
  jQuery(document).on(
    "blur",
    ".mt-draggable__area input, .mt-draggable__area textarea",
    function () {
      jQuery(this).closest(".mt-contentfield").attr("draggable", "true");
    },
  );

  const onDragOver = (e: DragEvent): void => {
    // Allowed only for Content Field and Content Field Type.
    if (droppable) {
      const currentTarget = e.currentTarget as HTMLElement;
      const target = e.target as HTMLElement;

      if (
        target.className !== "mt-draggable__area" &&
        target.className !== "mt-draggable" &&
        target.className !== "mt-contentfield"
      ) {
        e.preventDefault();
        return;
      }

      // Highlight droppable area
      if (!dragoverState) {
        // replace with e.currentTarget in Svelte
        currentTarget.classList.add("mt-draggable__area--dragover");
        dragoverState = true;
      }

      if (dragged) {
        if (target.className === "mt-contentfield") {
          // Inside the dragOver method

          // comment out because unused
          // self.over = e.target;

          const targetRect = target.getBoundingClientRect();
          const parent = target.parentNode as ParentNode;
          if ((e.clientY - targetRect.top) / targetRect.height > 0.5) {
            parent.insertBefore(placeholder, target.nextElementSibling);
          } else {
            parent.insertBefore(placeholder, target);
          }
        }
        if (target.className === "mt-draggable__area") {
          const fieldElements =
            target.getElementsByClassName("mt-contentfield");
          if (
            fieldElements.length === 0 ||
            (fieldElements.length === 1 && fieldElements[0] === dragged)
          ) {
            target.appendChild(placeholder);
          }
        }
      } else {
        // Dragged from content field types

        // replace with e.currentTarget in Svelte
        currentTarget.appendChild(placeholder);
      }

      e.preventDefault();
    }
  };

  const onDrop = (e: DragEvent): void => {
    const currentTarget = e.currentTarget as HTMLElement;
    if (dragged) {
      let pos = 0;
      let children: HTMLCollection | null = null;
      if (placeholder.parentNode) {
        children = placeholder.parentNode.children;
      }
      if (!children) {
        currentTarget.classList.remove("mt-draggable__area--dragover");
        e.preventDefault();
        return;
      }
      for (let i = 0; i < children.length; i++) {
        if (children[i] === placeholder) break;
        if (
          children[i] !== dragged &&
          children[i].classList.contains("mt-contentfield")
        ) {
          pos++;
        }
      }
      if (draggedItem) {
        _moveField(draggedItem, pos);
      }
      window.setDirty(true);
      // update is not needed in Svelte
    } else {
      // Drag from field list
      const fieldType = e.dataTransfer?.getData("text") || "";
      const field = jQuery("[data-field-type='" + fieldType + "']");
      const fieldTypeLabel = field.data("field-label");
      const canDataLabel = field.data("can-data-label");

      const newId = Math.random().toString(36).slice(-8);
      const newField: ContentType.Field = {
        type: fieldType,
        typeLabel: fieldTypeLabel,
        id: newId,
        isNew: true,
        isShow: "show",
        canDataLabel: canDataLabel,
        options: {}, // add in Svelte
      };
      fieldsStore.update((fields: ContentType.Fields) => [...fields, newField]);
      window.setDirty(true);
      // update is not needed in Svelte

      recalcHeight(document.getElementsByClassName("mt-draggable__area")[0]);
    }
    rebuildLabelFields();

    currentTarget.classList.remove("mt-draggable__area--dragover");
    e.preventDefault();
  };

  const onDragLeave = (e: DragEvent): void => {
    if (dragoverState) {
      // replace with e.currentTarget in Svelte
      (e.currentTarget as HTMLElement).classList.remove(
        "mt-draggable__area--dragover",
      );
      dragoverState = false;
    }
  };

  const onDragStart = (e: DragEvent, f: ContentType.Field): void => {
    dragged = e.target;
    draggedItem = f;
    (e.dataTransfer as DataTransfer).setData("text", f.id || "");
    droppable = true;
  };

  const onDragEnd = (): void => {
    if (placeholder.parentNode) {
      placeholder.parentNode.removeChild(placeholder);
    }
    droppable = false;
    dragged = null;
    draggedItem = null;
    dragoverState = false;
    // update is not needed in Svelte
  };

  const stopSubmitting = (e: KeyboardEvent): boolean => {
    // e.which is deprecate
    if (e.key === "Enter") {
      e.preventDefault();
      return false;
    }
    return true;
  };

  const canSubmit = (): boolean => {
    if ($fieldsStore.length === 0) {
      return true;
    }
    const invalidFields = $fieldsStore.filter(function (field) {
      return opts.invalid_types[field.type];
    });
    return invalidFields.length === 0 ? true : false;
  };

  const submit = (): void => {
    if (!canSubmit()) {
      return;
    }

    if (!_validateFields()) {
      return;
    }

    rebuildLabelFields();
    window.setDirty(false);
    const fieldOptions: Array<ContentType.SubmitFieldOption> = [];
    if ($fieldsStore) {
      for (let i = 0; i < $fieldsStore.length; i++) {
        const c = tags[i];
        const options = gatheringData(c, i);
        const newData: ContentType.SubmitFieldOption = {};
        newData.type = $fieldsStore[i].type;
        newData.options = options;
        if (!$fieldsStore[i].isNew && options["id"].match(/^\d+$/)) {
          newData.id = options["id"];
        }
        const innerField = $fieldsStore.filter(function (v) {
          return v.id === newData.id;
        });
        if (innerField.length && innerField[0].order) {
          newData.order = innerField[0].order;
        } else {
          newData.order = i + 1;
        }
        fieldOptions.push(newData);
      }
      data = JSON.stringify(fieldOptions);
    } else {
      data = "";
    }

    // bind:value={data} does not work
    addInputData();

    // update is not needed in Svelte

    document.forms["content-type-form"].submit();
  };

  // recalcHeight was moved to Utils.ts

  const rebuildLabelFields = (): void => {
    const newLabelFields: Array<{ value: string; label: string }> = [];
    for (let i = 0; i < $fieldsStore.length; i++) {
      const required = jQuery("#content-field-block-" + $fieldsStore[i].id)
        .find('[name="required"]')
        .prop("checked");
      if (required && $fieldsStore[i].canDataLabel === 1) {
        let label = $fieldsStore[i].label;
        let id = $fieldsStore[i].unique_id;
        if (!label) {
          label =
            jQuery("#content-field-block-" + $fieldsStore[i].id)
              .find('[name="label"]')
              .val()
              ?.toString() || "";
          if (label === "") {
            label = window.trans("No Name");
          }
        }
        if (!id) {
          // new field
          id = "id:" + $fieldsStore[i].id;
        }
        newLabelFields.push({
          value: id,
          label: label,
        });
      }
    }
    labelFields = newLabelFields;
    // update is not needed in Svelte
  };

  // changeLabelFields was removed because unused

  const toggleAll = (): void => {
    isExpanded = !isExpanded;
    const newIsShow = isExpanded ? "show" : "";
    fieldsStore.update((fields: ContentType.Fields) =>
      fields.map((field: ContentType.Field) => {
        field.isShow = newIsShow;
        return field;
      }),
    );
  };

  const updateToggleAll = (): void => {
    const collapseEls = document.querySelectorAll(".mt-collapse__content");
    let isAllExpanded = true;
    collapseEls.forEach((collapseEl) => {
      if (collapseEl.classList.contains("show")) {
        isAllExpanded = true;
      } else {
        isAllExpanded = false;
      }
    });
    isExpanded = isAllExpanded ? true : false;
  };

  const _moveField = (item: ContentType.Field, pos: number): void => {
    fieldsStore.update((fields: ContentType.Fields) => {
      for (let i = 0; i < fields.length; i++) {
        let field = fields[i];
        if (field.id === item.id) {
          fields.splice(i, 1);
          break;
        }
      }
      fields.splice(pos, 0, item);
      for (let i = 0; i < fields.length; i++) {
        fields[i].order = i + 1;
      }
      return fields;
    });
  };

  const _validateFields = (): boolean => {
    /* @ts-expect-error : mtValidate is not defined */
    const requiredFieldsAreValid = jQuery(".html5-form").mtValidate("simple");
    const textFieldsInTableAreValid = jQuery(
      ".values-option-table input[type=text]",
      /* @ts-expect-error : mtValidate is not defined */
    ).mtValidate("simple");
    /* @ts-expect-error : mtValidate is not defined */
    const tableIsValid = jQuery(".values-option-table").mtValidate(
      "selection-field-values-option",
    );
    /* @ts-expect-error : mtValidate is not defined */
    const contentFieldBlockIsValid = jQuery(".content-field-block").mtValidate(
      "content-field-block",
    );
    const uniqueFieldsAreValid = jQuery(
      "input[data-mt-content-field-unique]",
      /* @ts-expect-error : mtValidate is not defined */
    ).mtValidate("simple");

    const res =
      requiredFieldsAreValid &&
      textFieldsInTableAreValid &&
      tableIsValid &&
      contentFieldBlockIsValid &&
      uniqueFieldsAreValid;

    if (!res) {
      jQuery(".mt-contentfield").each(function (_i, fld) {
        const jqFld = jQuery(fld);
        if (jqFld.find(".form-control.is-invalid").length > 0) {
          /* @ts-expect-error : collapse is not defined */
          jqFld.find(".collapse").collapse("show");
        }
      });
    }

    return res;
  };

  // copied from lib/MT/Template/ContextHandler.pm
  const gatheringData = (c: HTMLDivElement, index: number): object => {
    const data = {};
    const flds = c.querySelectorAll("[data-is] [ref]");
    Object.keys(flds).forEach(function (k) {
      const f = flds[k];
      if (f.type === "checkbox") {
        const val = f.checked ? 1 : 0;
        if (f.name in data) {
          if (Array.isArray(data[f.name])) {
            data[f.name].push(val);
            /* comented out because never used */
            // } else {
            //   const array = [];
            //   array.push(data[f.name]);
            //   array.push(val);
          }
        } else {
          data[f.name] = val;
        }
      } else {
        data[f.name] = f.value;
      }
    });

    const fieldId = $fieldsStore[index].id;
    if (fieldId) {
      const gather = gathers[fieldId];
      if (gather) {
        const customData = gather();
        jQuery.extend(data, customData);
      }
    }

    return data;
  };

  // create in Svelte
  const updateFieldsIsShowAll = (): void => {
    const collapseEls = document.querySelectorAll(".mt-collapse__content");
    fieldsStore.update((fields: ContentType.Fields) =>
      fields.map((field: ContentType.Field, i: number) => {
        if (collapseEls[i].classList.contains("show")) {
          field.isShow = "show";
        } else {
          field.isShow = "";
        }
        return field;
      }),
    );
  };

  // create in Svelte
  const addInputData = (): void => {
    const form = document.forms.namedItem(
      "content-type-form",
    ) as HTMLFormElement;
    const inputId = form.querySelector('input[name="id"]') as Element;
    const inputData = document.createElement("input") as Element;
    inputData.setAttribute("type", "hidden");
    inputData.setAttribute("name", "data");
    inputData.setAttribute("value", data);
    form.insertBefore(inputData, inputId.nextElementSibling);
  };
</script>

<form name="content-type-form" action={window.CMSScriptURI} method="POST">
  <input type="hidden" name="__mode" value="save" />
  <input type="hidden" name="blog_id" value={opts.blog_id} />
  <input type="hidden" name="magic_token" value={opts.magic_token} />
  <input type="hidden" name="return_args" value={opts.return_args} />
  <input type="hidden" name="_type" value="content_type" />
  <input type="hidden" name="id" value={opts.id} />
  <!-- input[name="data"] is added in addInputData() -->

  <div class="row">
    <div class="col">
      {#if opts.id}
        <div id="name-field" class="form-group">
          <h3>
            {opts.name}
            <button
              type="button"
              class="btn btn-link"
              data-bs-toggle="modal"
              data-bs-target="#editDetail">{window.trans("Edit")}</button
            >
          </h3>
          <div
            id="editDetail"
            class="modal"
            data-role="dialog"
            aria-labelledby="editDetail"
            aria-hidden="true"
          >
            <div class="modal-dialog modal-lg" data-role="document">
              <div class="modal-content">
                <div class="modal-header">
                  <h4 class="modal-title">{window.trans("Content Type")}</h4>
                  <button
                    type="button"
                    class="close btn-close"
                    data-bs-dismiss="modal"
                    aria-label="Close"
                  >
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
                <div class="modal-body">
                  <div class="col">
                    <div id="name-field" class="form-group">
                      <label for="name" class="form-control-label"
                        >{window.trans("Content Type Name")}
                        <span class="badge badge-danger"
                          >{window.trans("Required")}</span
                        ></label
                      >
                      <input
                        type="text"
                        name="name"
                        id="name"
                        class="form-control html5-form"
                        value={opts.name}
                        on:keypress={stopSubmitting}
                        required
                      />
                    </div>
                  </div>
                  <div class="col">
                    <div id="description-field" class="form-group">
                      <label for="description" class="form-control-label"
                        >{window.trans("Description")}</label
                      >
                      <textarea
                        name="description"
                        id="description"
                        class="form-control">{opts.description}</textarea
                      >
                    </div>
                  </div>
                  <div class="col">
                    <div id="label-field" class="form-group">
                      <label for="label_field" class="form-control-label"
                        >{window.trans("Data Label Field")}</label
                      >
                      <!-- onchange and selected were removed and bind is used -->
                      <select
                        id="label_field"
                        name="label_field"
                        class="custom-select form-control html5-form form-select"
                        bind:value={labelField}
                      >
                        <option value=""
                          >{window.trans(
                            "Show input field to enter data label",
                          )}</option
                        >
                        {#each labelFields as lf}
                          <option value={lf.value}>
                            {lf.label}
                          </option>
                        {/each}
                      </select>
                    </div>
                  </div>
                  <div class="col">
                    <div id="unique_id-field" class="form-group">
                      <label for="unique_id" class="form-control-label"
                        >{window.trans("Unique ID")}</label
                      >
                      <input
                        type="text"
                        class="form-control-plaintext w-50"
                        id="unieuq_id"
                        value={opts.unique_id}
                        readonly
                      />
                    </div>
                  </div>
                  <div class="col">
                    <div id="user_disp_option-field" class="form-group">
                      <label for="user_disp_option"
                        >{window.trans(
                          "Allow users to change the display and sort of fields by display option",
                        )}</label
                      >
                      <!-- checked="checked" is not added to input tag after click checkbox,
            but check parameter of input element returns true. So, do not fix this. -->
                      <input
                        type="checkbox"
                        class="mt-switch form-control"
                        id="user_disp_option"
                        checked={opts.user_disp_option ? true : false}
                        name="user_disp_option"
                      />
                      <label for="user_disp_option" class="last-child">
                        {window.trans(
                          "Allow users to change the display and sort of fields by display option",
                        )}
                      </label>
                    </div>
                  </div>
                </div>
                <div class="modal-footer">
                  <button
                    type="button"
                    class="btn btn-default"
                    data-bs-dismiss="modal">{window.trans("close")}</button
                  >
                </div>
              </div>
            </div>
          </div>
        </div>
      {:else}
        <div id="name-field" class="form-group">
          <label for="name" class="form-control-label"
            >{window.trans("Name")}
            <span class="badge badge-danger">{window.trans("Required")}</span
            ></label
          >
          <input
            type="text"
            name="name"
            id="name"
            class="form-control html5-form"
            value={opts.name}
            on:keypress={stopSubmitting}
            required
          />
        </div>
      {/if}
    </div>
  </div>
</form>

<form>
  <fieldset id="content-fields" class="form-group">
    <legend class="h3">{window.trans("Content Fields")}</legend>
    <div class="mt-collapse__all">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        data-bs-toggle="collapse"
        on:click={toggleAll}
        href=""
        aria-expanded={isExpanded ? "true" : "false"}
        aria-controls=""
        class="d-inline-block"
      >
        {isExpanded ? window.trans("Close all") : window.trans("Edit all")}
        <SVG
          title={window.trans("Edit")}
          class="mt-icon--secondary expand-all-icon"
          href="{window.StaticURI}images/sprite.svg#ic_collapse"
        />
      </a>
    </div>
    <!-- svelte-ignore a11y-no-static-element-interactions -->
    <div
      class="mt-draggable__area"
      style="height:400px;"
      on:drop={onDrop}
      on:dragover={onDragOver}
      on:dragleave={onDragLeave}
    >
      {#if isEmpty}
        <div class="mt-draggable__empty">
          <img
            src="{window.StaticURI}images/dragdrop.gif"
            alt={window.trans("Drag and drop area")}
            width="240"
            height="120"
          />
          <p>{window.trans("Please add a content field.")}</p>
        </div>
      {/if}
      {#each $fieldsStore as field, fieldIndex}
        {@const fieldId = field.id ?? ""}
        <div
          class="mt-contentfield"
          draggable="true"
          aria-grabbed="false"
          data-is="content-field"
          on:dragstart={(e) => {
            onDragStart(e, field);
          }}
          on:dragend={onDragEnd}
          style="width: 100%;"
          id="content-field-block-{fieldId}"
          bind:this={tags[fieldIndex]}
        >
          <ContentField
            {config}
            bind:field
            bind:fields={$fieldsStore}
            {fieldIndex}
            {fieldsStore}
            {gatheringData}
            parent={tags[fieldIndex]}
            bind:gather={gathers[fieldId]}
            {optionsHtmlParams}
          />
        </div>
      {/each}
    </div>
    <div class="mt-collapse__all">
      <a
        data-bs-toggle="collapse"
        on:click={toggleAll}
        href=".mt-collapse__content"
        aria-expanded={isExpanded ? "true" : "false"}
        aria-controls=""
        class="d-inline-block"
      >
        {isExpanded ? window.trans("Close all") : window.trans("Edit all")}
        <SVG
          title={window.trans("Edit")}
          class="mt-icon--secondary expand-all-icon"
          href="{window.StaticURI}images/sprite.svg#ic_collapse"
        />
      </a>
    </div>
  </fieldset>
</form>
<button
  type="button"
  class="btn btn-primary"
  disabled={!canSubmit()}
  on:click={submit}>{window.trans("Save")}</button
>

<!-- style was moved to edit_content_type.tmpl, because style did not work here -->
