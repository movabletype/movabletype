<script lang="ts">
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";
  import ContentFieldOption from "./ContentFieldOption.svelte";
  import { mtConfig } from "../Store";

  export let fieldId: string;
  export let options: any;
  export let label: string;
  export let isNew: boolean;
  export let id: string;

  const type = "select-box";
  const _type = type.replace(/-/g, "_");

  if (options.can_add === "0") {
    options.can_add = 0;
  }

  if (options.multiple === "0") {
    options.multiple = 0;
  }

  // <mt:include name="content_field_type_options/selection_common_script.tmpl">
  // Copy from selection_common_script.tmpl below
  let values = options.values;
  if (!values) {
    values = [
      {
        checked: "",
      },
    ];
  }

  // TODO When is updated event triggered?
  //  this.on('updated', function() {
  //    validateTable();
  //  })

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const addRow = () => {
    console.log("addRow");
    values.push({ checked: "" });
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const enterLabel = (e) => {
    console.log("enterLabel");
    console.log(e);
    e.item.label = e.target.value;
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const enterValue = (e) => {
    console.log("enterValue");
    e.item.value = e.target.value;
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  // const gather = () => {
  //   console.log("gather");
  //   return {
  //     values: values,
  //   };
  // };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  // const validateTable = () => {
  //   console.log("validateTable");
  //   // TODO refs.table の別呼び出し方法
  //   const jqTable = jQuery(this.refs.table);
  //   const tableIsValidated = jqTable.data("mtValidator") ? true : false;
  //   if (tableIsValidated) {
  //     const jqNotValidatedLabelsValues = jqTable.find(
  //       "input[type=text]:not(.is-invalid)"
  //     );
  //     if (jqNotValidatedLabelsValues.length > 0) {
  //       jqNotValidatedLabelsValues.mtValidate("simple");
  //     } else {
  //       jqTable.mtValid({ focus: false });
  //     }
  //   }
  // };
  // Copy from selection_common_script.tmpl above

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  // const deleteRow = (e) => {
  //   console.log("deleteRow");
  //   item = e.item;
  //   index = values.indexOf(item);
  //   values.splice(index, 1);
  //   if (values.length === 0) {
  //     values = [
  //       {
  //         checked: "checked",
  //       },
  //     ];
  //   } else {
  //     found = false;
  //     values.forEach(function (v) {
  //       if (v.checked === "checked") {
  //         found = true;
  //       }
  //     });
  //     if (!found) {
  //       values[0].checked = "checked";
  //     }
  //   }
  // };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const enterInitial = (e) => {
    console.log("enterInitial");
    var target = e.target;
    var state = target.checked;
    var block = jQuery(e.target).parents(".mt-contentfield");

    // Clear all check when not to allow multiple selection
    if (
      !options.multiple ||
      options.multiple === 0 ||
      options.multiple === false
    ) {
      _clearAllInitial(block);
    }

    // Set current item status
    const item = e.item;
    const index = values.indexOf(item);
    e.target.checked = state;
    values[index].checked = state ? "checked" : "";

    if (options.multiple || options.multiple === 1) {
      _updateInittialField(block);
    }
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const changeStateMultiple = (e) => {
    console.log("changeStateMultiple");
    var block = jQuery(e.target).parents(".mt-contentfield");
    options.multiple = e.target.checked;
    if (
      !options.multiple &&
      block.find(".values-option-table").find('input[type="checkbox"]:checked')
        .length > 1
    ) {
      _clearAllInitial(block);
    }
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const enterMax = (e) => {
    console.log("enterMax");
    var block = jQuery(e.target).parents(".mt-contentfield");
    _updateInittialField(block);
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const _updateInittialField = (block) => {
    console.log("_updateInittialField");
    var max = Number(block.find('input[name="max"]').val());
    var cur = block
      .find(".values-option-table")
      .find('input[type="checkbox"]:checked').length;
    if (max === 0 || cur < max) {
      let chkbox = block
        .find(".values-option-table")
        .find('input[type="checkbox"]');
      jQuery.each(chkbox, function (i) {
        jQuery(chkbox[i]).prop("disabled", false);
      });
    } else {
      let chkbox = block
        .find(".values-option-table")
        .find('input[type="checkbox"]:not(:checked)');
      jQuery.each(chkbox, function (i) {
        jQuery(chkbox[i]).prop("disabled", true);
      });
    }
  };

  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
  const _clearAllInitial = (block) => {
    console.log("_clearAllInitial");
    var initials = block
      .find(".values-option-table")
      .find('input[type="checkbox"]');
    if (initials.length > 1) {
      jQuery.each(initials, function (v) {
        var elm = jQuery(initials[v]);
        elm.prop("checked", false);
        elm.prop("disabled", false);
      });
    }
    values.forEach(function (v) {
      v.checked = "";
    });
  };
</script>

<ContentFieldOptionGroup {type} {id} {fieldId} {options} bind:label {isNew}>
  <ContentFieldOption
    id="{_type}-multiple"
    label={window.trans("Allow users to select multiple values?")}
  >
    <input
      {...{ ref: "multiple" }}
      type="checkbox"
      class="mt-switch form-control form-check-input"
      id="{_type}-multiple"
      name="multiple"
      checked={options.multiple}
      on:click={changeStateMultiple}
    /><label for="{_type}-multiple" class="form-label"
      >{window.trans("Allow users to select multiple values?")}</label
    >
  </ContentFieldOption>

  <ContentFieldOption
    id="{_type}-min"
    label={window.trans("Minimum number of selections")}
    attr="show={options.multiple}"
  >
    <input
      {...{ ref: "min" }}
      type="number"
      name="min"
      id="{_type}-min"
      class="form-control w-25"
      min="0"
      value={options.min}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="{_type}-max"
    label={window.trans("Maximum number of selections")}
    attr="show={options.multiple}"
  >
    <input
      {...{ ref: "max" }}
      type="number"
      name="max"
      id="{_type}-max"
      class="form-control w-25"
      min="1"
      value={options.max}
      on:change={enterMax}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="{_type}-values"
    required={1}
    label={window.trans("Values")}
  >
    <div class="mt-table--outline mb-3">
      <table class="table mt-table values-option-table" {...{ ref: "table" }}>
        <thead>
          <tr>
            <th scope="col">{window.trans("Selected")}</th>
            <th scope="col">{window.trans("Label")}</th>
            <th scope="col">{window.trans("Value")}</th>
            <th scope="col" />
          </tr>
        </thead>
        <tbody>
          {#each values as v}
            <tr class="text-center align-middle">
              <td
                ><input
                  type="checkbox"
                  class="form-check-input"
                  checked={v.checked}
                  on:change={enterInitial}
                /></td
              >
              <td
                ><input
                  type="text"
                  class="form-control required"
                  name="label"
                  on:input={enterLabel}
                  value={v.label}
                /></td
              >
              <td
                ><input
                  type="text"
                  class="form-control required"
                  name="value"
                  on:input={enterValue}
                  value={v.value}
                /></td
              >
              <td
                ><button
                  on:click={parent.deleteRow}
                  type="button"
                  class="btn btn-default btn-sm"
                  ><svg role="img" class="mt-icon mt-icon--sm"
                    ><title>{window.trans("delete")}</title><use
                      xlink:href="{window.StaticURI}images/sprite.svg#ic_trash"
                    /></svg
                  >{window.trans("delete")}</button
                ></td
              >
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
    <button on:click={addRow} type="button" class="btn btn-default btn-sm"
      ><svg role="img" class="mt-icon mt-icon--sm"
        ><title>{window.trans("add")}</title><use
          xlink:href="{window.StaticURI}images/sprite.svg#ic_add"
        /></svg
      >{window.trans("add")}</button
    >
  </ContentFieldOption>
</ContentFieldOptionGroup>
