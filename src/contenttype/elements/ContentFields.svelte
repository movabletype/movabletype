<script>
  import ContentField from "./ContentField.svelte";
  import { recalcHeight, update } from "../Utils.ts";
  import { cfields, mtConfig } from "../Store.ts";

  export let opts;
  export let config;

  const Debug = false;
  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const consoleLog = (message) => {
    if (Debug) {
      console.log(message);
    }
  };

  cfields.set(opts.fields);
  mtConfig.set(config);
  let isEmpty = $cfields.length > 0 ? false : true;
  self.data = ""; // TODO
  let droppable = false;
  let dragged = null;
  let draggedItem = null;
  self.placeholder = document.createElement("div"); // TODO
  self.placeholder.className = "placeholder"; // TODO
  let dragoverState = false;
  self.labelFields = []; // TODO
  let labelField = opts.labelField;

  const invalid_types = opts.types
    .filter(function (field_type) {
      return field_type.warning;
    })
    .reduce(function (hash, field_type) {
      hash[field_type.type] = true;
      return hash;
    }, {});

  jQuery(document).on("dragstart", ".mt-draggable", function (event) {
    consoleLog("dragstart");
    var jqThis = jQuery(this);
    jqThis.attr("aria-grabbed", true);
    var fieldtype = jqThis.data("field-type");
    event.originalEvent.dataTransfer.setData("text", fieldtype);
    handleMtDragStart();
  });

  jQuery(document).on("dragend", ".mt-draggable", function () {
    consoleLog("dragend");
    var jqThis = jQuery(this);
    jqThis.attr("aria-grabbed", false);
    handleMtDragEnd();
  });

  // Drag start from content field list
  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const handleMtDragStart = () => {
    consoleLog("handleMtDragStart");
    droppable = true;
  };

  // Drag end from content field list
  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const handleMtDragEnd = () => {
    consoleLog("handleMtDragEnd");
    droppable = false;
    onDragEnd();
  };

  // Show dettail modal
  jQuery(document).on("show.bs.modal", "#editDetail", function () {
    consoleLog("show.bs.modal");
    rebuildLabelFields();
    update();
  });

  // Hide detail modal
  jQuery(document).on("hide.bs.modal", "#editDetail", function () {
    consoleLog("hide.bs.modal");
    if (jQuery("#name-field > input").mtValidate("simple")) {
      opts.name = jQuery("#name-field > input").val();
      window.setDirty(true);
      update();
    } else {
      return false;
    }
  });

  // Shown collaped block
  jQuery(document).on(
    "shown.bs.collapse",
    ".mt-collapse__content",
    function () {
      consoleLog("show.bs.collapse");
      const target = document.getElementsByClassName("mt-draggable__area")[0];
      recalcHeight(target);
    }
  );

  // Hide collaped block
  jQuery(document).on(
    "hidden.bs.collapse",
    ".mt-collapse__content",
    function () {
      consoleLog("hidden.bs.collapse");
      const target = document.getElementsByClassName("mt-draggable__area")[0];
      recalcHeight(target);
    }
  );

  // Cannot drag while focusing on input / textarea
  jQuery(document).on(
    "focus",
    ".mt-draggable__area input, .mt-draggable__area textarea",
    function () {
      consoleLog("focus");
      // const target = document.getElementsByClassName("mt-draggable__area")[0];
      jQuery(this).closest(".mt-contentfield").attr("draggable", false);
    }
  );

  // Set draggable back to true while not focusing on input / textarea
  jQuery(document).on(
    "blur",
    ".mt-draggable__area input, .mt-draggable__area textarea",
    function () {
      consoleLog("blur");
      jQuery(this).closest(".mt-contentfield").attr("draggable", true);
    }
  );

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const onDragOver = (e) => {
    consoleLog("onDragOver");
    // Allowed only for Content Field and Content Field Type.
    if (droppable) {
      if (
        e.target.className !== "mt-draggable__area" &&
        e.target.className !== "mt-draggable" &&
        e.target.className !== "mt-contentfield"
      ) {
        e.preventDefault();
        return;
      }

      // Highlight droppable area
      if (!dragoverState) {
        if (e.target.classList.contains("mt-draggable__area")) {
          e.target.classList.add("mt-draggable__area--dragover");
        } else if (e.target.classList.contains("mt-contentfield")) {
          e.target.parentNode.classList.add("mt-draggable__area--dragover");
        }
        dragoverState = true;
      }

      if (dragged) {
        if (e.target.className === "mt-contentfield") {
          // Inside the dragOver method
          self.over = e.target;
          const targetRect = e.target.getBoundingClientRect();
          const parent = e.target.parentNode;
          if ((e.clientY - targetRect.top) / targetRect.height > 0.5) {
            parent.insertBefore(self.placeholder, e.target.nextElementSibling);
          } else {
            parent.insertBefore(self.placeholder, e.target);
          }
        }
        if (e.target.className === "mt-draggable__area") {
          const fields = e.target.getElementsByClassName("mt-contentfield");
          if (
            fields.length === 0 ||
            (fields.length === 1 && fields[0] === dragged)
          ) {
            e.target.appendChild(self.placeholder);
          }
        }
      } else {
        // Dragged from content field types
        if (e.target.classList.contains("mt-draggable__area")) {
          e.target.appendChild(self.placeholder);
        } else if (e.target.classList.contains("mt-contentfield")) {
          e.target.parentNode.appendChild(self.placeholder);
        }
      }
      e.preventDefault();
    }
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const onDrop = (e) => {
    consoleLog("onDrop");
    if (dragged) {
      var pos = 0;
      var children;
      if (self.placeholder.parentNode) {
        children = self.placeholder.parentNode.children;
      }
      if (!children) {
        e.target.classList.remove("mt-draggable__area--dragover");
        e.preventDefault();
        return;
      }
      for (var i = 0; i < children.length; i++) {
        if (children[i] == self.placeholder) break;
        if (
          children[i] != dragged &&
          children[i].classList.contains("mt-contentfield")
        ) {
          pos++;
        }
      }
      _moveField(draggedItem, pos);
      window.setDirty(true);
      update();
    } else {
      // Drag from field list
      const fieldType = e.dataTransfer.getData("text");
      const field = jQuery("[data-field-type='" + fieldType + "']");
      const fieldTypeLabel = field.data("field-label");
      const canDataLabel = field.data("can-data-label");

      const newId = Math.random().toString(36).slice(-8);
      const newField = Object.assign(field, {
        type: fieldType,
        typeLabel: fieldTypeLabel,
        id: newId,
        isNew: true,
        isShow: "show",
        canDataLabel: canDataLabel,
      });
      cfields.update((arr) => [...arr, newField]);
      window.setDirty(true);
      isEmpty = false;
      update();

      recalcHeight(document.getElementsByClassName("mt-draggable__area")[0]);
    }
    rebuildLabelFields();

    e.target.classList.remove("mt-draggable__area--dragover");
    e.preventDefault();
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const onDragLeave = (e) => {
    consoleLog("onDragLeave");
    if (dragoverState) {
      if (e.target.classList.contains("mt-draggable__area")) {
        e.target.classList.remove("mt-draggable__area--dragover");
      } else if (e.target.classList.contains("mt-.fieldscontentfield")) {
        e.target.parentNode.classList.remove("mt-draggable__area--dragover");
      }
      dragoverState = false;
    }
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const onDragStart = (e) => {
    consoleLog("onDragStart");
    dragged = e.target;
    draggedItem = e.item;
    e.dataTransfer.setData("text", e.item.id);
    droppable = true;
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const onDragEnd = () => {
    consoleLog("onDragEnd");
    if (self.placeholder.parentNode) {
      self.placeholder.parentNode.removeChild(self.placeholder);
    }
    droppable = false;
    dragged = null;
    draggedItem = null;
    dragoverState = false;
    update();
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const stopSubmitting = (e) => {
    consoleLog("stopSubmitting");
    if (e.which === 13) {
      e.preventDefault();
      return false;
    }
    return true;
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const canSubmit = () => {
    consoleLog("canSubmit");
    if ($cfields.length === 0) {
      return true;
    }
    var invalidFields = $cfields.filter(function (field) {
      return invalid_types[field.type];
    });
    return invalidFields.length == 0 ? true : false;
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const submit = () => {
    consoleLog("submit");
    if (!canSubmit()) {
      return;
    }

    if (!_validateFields()) {
      return;
    }

    rebuildLabelFields();
    window.setDirty(false);
    const fieldOptions = [];
    if ($cfields) {
      //TODO content-fields tag does not exist
      //var child = self.tags['content-field']
      let child = document.querySelectorAll(".content-field");
      if (child) {
        if (!Array.isArray(child)) {
          child = [child];
        }

        child.forEach(function (c, i) {
          // var field = c.tags[c.type];
          var options = gatheringData();
          var data = {};
          data.type = c.type;
          data.options = options;
          if (c.isNew) {
            data.order = i + 1;
          } else {
            data.id = c.id;
            var innerField = $cfields.filter(function (v) {
              return v.id == c.id;
            });
            if (innerField.length) {
              data.order = innerField[0].order;
            } else {
              data.order = i + 1;
            }
          }
          fieldOptions.push(data);
        });
        self.data = JSON.stringify(fieldOptions);
      }
    } else {
      self.data = "";
    }
    update();
    document.forms["content-type-form"].submit();
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const gatheringData = (id) => {
    consoleLog("gatheringData");
    let data = {};
    const flds = document.querySelectorAll("#" + id + " *[ref]");
    Object.keys(flds).forEach(function (k) {
      const f = flds[k];
      if (f.type === "checkbox") {
        const val = f.checked ? 1 : 0;
        if (f.name in data) {
          if (Array.isArray(data[f.name])) {
            data[f.name].push(val);
          } else {
            const array = [];
            array.push(data[f.name]);
            array.push(val);
          }
        } else {
          data[f.name] = val;
        }
      } else {
        data[f.name] = f.value;
      }
    });

    // TODO
    //    if (typeof this.gather === 'function') {
    //      const customData = this.gather();
    //      jQuery.extend(data, customData);
    //    }
    return data;
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const rebuildLabelFields = () => {
    consoleLog("rebuildLableFields");
    var fields = [];
    for (var i = 0; i < $cfields.length; i++) {
      var required = jQuery("#content-field-block-" + $cfields[i].id)
        .find('[name="required"]')
        .prop("checked");
      if (required && $cfields[i].canDataLabel === 1) {
        var label = $cfields[i].label;
        var id = $cfields[i].unique_id;
        if (!label) {
          label = jQuery("#content-field-block-" + $cfields[i].id)
            .find('[name="label"]')
            .val();
          if (label === "") {
            label = window.trans("No Name");
          }
          id = "id:" + $cfields[i].id;
        }
        fields.push({
          value: id,
          label: label,
        });
      }
    }
    self.labelFields = fields;
    update();
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const changeLabelField = (e) => {
    consoleLog("changeLabelField");
    self.labelField = e.target.value;
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const _moveField = (item, pos) => {
    consoleLog("_moveField");
    for (let i = 0; i < $cfields.length; i++) {
      var field = $cfields[i];
      if (field.id === item.id) {
        cfields.update((arr) => {
          // same as splice(i, 1)
          const newArray = arr.slice(0, i).concat(arr.slice(i + 1));
          return newArray;
        });
        break;
      }
    }
    $cfields.splice(pos, 0, field); //TODO
    for (let i = 0; i < $cfields.length; i++) {
      $cfields[i].order = i + 1;
    }
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const _validateFields = () => {
    consoleLog("_validateField");
    const requiredFieldsAreValid = jQuery(".html5-form").mtValidate("simple");
    const textFieldsInTableAreValid = jQuery(
      ".values-option-table input[type=text]"
    ).mtValidate("simple");
    const tableIsValid = jQuery(".values-option-table").mtValidate(
      "selection-field-values-option"
    );
    const contentFieldBlockIsValid = jQuery(".content-field-block").mtValidate(
      "content-field-block"
    );
    const uniqueFieldsAreValid = jQuery(
      "input[data-mt-content-field-unique]"
    ).mtValidate("simple");

    const res =
      requiredFieldsAreValid &&
      textFieldsInTableAreValid &&
      tableIsValid &&
      contentFieldBlockIsValid &&
      uniqueFieldsAreValid;

    if (!res) {
      jQuery(".mt-contentfield").each(function (i, fld) {
        const jqFld = jQuery(fld);
        if (jqFld.find(".form-control.is-invalid").length > 0) {
          jqFld.find(".collapse").collapse("show");
        }
      });
    }

    return res;
  };
</script>

<form name="content-type-form" action={window.CMSScriptURI} method="POST">
  <input type="hidden" name="__mode" value="save" />
  <input type="hidden" name="blog_id" value={opts.blog_id} />
  <input type="hidden" name="magic_token" value={opts.magic_token} />
  <input type="hidden" name="return_args" value={opts.return_args} />
  <input type="hidden" name="_type" value="content_type" />
  <input type="hidden" name="id" value={opts.id} />
  {#if self.data}
    <input type="hidden" name="data" value={self.data} />
  {/if}

  <div class="row">
    <div class="col">
      {#if opts.id}
        <div id="name-field" class="form-group">
          <h3>
            {opts.name}
            <button
              type="button"
              class="btn btn-link"
              data-toggle="modal"
              data-target="#editDetail">{window.trans("Edit")}</button
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
                    class="close"
                    data-dismiss="modal"
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
                      <select
                        id="label_field"
                        name="label_field"
                        class="custom-select form-control html5-form"
                        onchange={changeLabelField}
                      >
                        <option value="" selected={labelField === ""}
                          >{window.trans(
                            "Show input field to enter data label"
                          )}
                          {#each self.labelFields as l}
                            <option
                              value={l.value}
                              selected={l.value === parent.labelField}
                              >{l.label}</option
                            >
                          {/each}
                        </option></select
                      >
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
                          "Allow users to change the display and sort of fields by display option"
                        )}</label
                      >
                      <input
                        type="checkbox"
                        class="mt-switch form-control"
                        id="user_disp_option"
                        checked={opts.user_disp_option}
                        name="user_disp_option"
                      /><label for="user_disp_option" class="last-child"
                        >{window.trans(
                          "Allow users to change the display and sort of fields by display option"
                        )}</label
                      >
                    </div>
                  </div>
                </div>
                <div class="modal-footer">
                  <button
                    type="button"
                    class="btn btn-default"
                    data-dismiss="modal">{window.trans("close")}</button
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
      {#each $cfields as f, fieldIndex}
        <div
          id="content-field-block-{f.id}"
          class="mt-contentfield"
          draggable="true"
          aria-grabbed="false"
          on:dragstart={onDragStart}
          on:dragend={onDragEnd}
          style="width: 100%;"
        >
          <div class="content-field">
            <ContentField
              {...f}
              item={f}
              itemIndex={fieldIndex}
              {gatheringData}
              bind:isEmpty
            />
          </div>
        </div>
      {/each}
    </div>
  </fieldset>
</form>
<button
  type="button"
  class="btn btn-primary"
  disabled={!canSubmit()}
  on:click={submit}>{window.trans("Save")}</button
>

<style>
  :global(.placeholder) {
    height: 26px;
    margin: 4px;
    margin-left: 10px;
    border-width: 2px;
    border-style: dashed;
    border-radius: 4px;
    border-color: #aaa;
  }
</style>
