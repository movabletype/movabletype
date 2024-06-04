<script>
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";
  import ContentFieldOption from "./ContentFieldOption.svelte";
  import { mtConfig } from "../Store.ts";

  export let fieldId;
  export let options;
  export let label;
  export let isNew;

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

  function addRow(e) {
    console.log("addRow");
    values.push({ checked: "" });
  }

  function enterLabel(e) {
    console.log("enterLabel");
    console.log(e);
    e.item.label = e.target.value;
  }

  function enterValue(e) {
    console.log("enterValue");
    e.item.value = e.target.value;
  }

  function gather() {
    console.log("gather");
    return {
      values: values,
    };
  }

  function validateTable() {
    console.log("validateTable");
    // TODO refs.table の別呼び出し方法
    const jqTable = jQuery(this.refs.table);
    const tableIsValidated = jqTable.data("mtValidator") ? true : false;
    if (tableIsValidated) {
      const jqNotValidatedLabelsValues = jqTable.find(
        "input[type=text]:not(.is-invalid)"
      );
      if (jqNotValidatedLabelsValues.length > 0) {
        jqNotValidatedLabelsValues.mtValidate("simple");
      } else {
        jqTable.mtValid({ focus: false });
      }
    }
  }
  // Copy from selection_common_script.tmpl above

  function deleteRow(e) {
    console.log("deleteRow");
    item = e.item;
    index = values.indexOf(item);
    values.splice(index, 1);
    if (values.length === 0) {
      values = [
        {
          checked: "checked",
        },
      ];
    } else {
      found = false;
      values.forEach(function (v) {
        if (v.checked === "checked") {
          found = true;
        }
      });
      if (!found) {
        values[0].checked = "checked";
      }
    }
  }

  function enterInitial(e) {
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
    item = e.item;
    index = values.indexOf(item);
    e.target.checked = state;
    values[index].checked = state ? "checked" : "";

    if (options.multiple || options.multiple === 1) {
      _updateInittialField(block);
    }
  }

  function changeStateMultiple(e) {
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
  }

  function enterMax(e) {
    console.log("enterMax");
    var block = jQuery(e.target).parents(".mt-contentfield");
    _updateInittialField(block);
  }

  function _updateInittialField(block) {
    console.log("_updateInittialField");
    var max = Number(block.find('input[name="max"]').val());
    var cur = block
      .find(".values-option-table")
      .find('input[type="checkbox"]:checked').length;
    if (max === 0 || cur < max) {
      var chkbox = block
        .find(".values-option-table")
        .find('input[type="checkbox"]');
      jQuery.each(chkbox, function (i) {
        jQuery(chkbox[i]).prop("disabled", false);
      });
    } else {
      var chkbox = block
        .find(".values-option-table")
        .find('input[type="checkbox"]:not(:checked)');
      jQuery.each(chkbox, function (i) {
        jQuery(chkbox[i]).prop("disabled", true);
      });
    }
  }

  function _clearAllInitial(block) {
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
  }
</script>

<ContentFieldOptionGroup
  {type}
  {fieldId}
  {options}
  bind:labelValue={label}
  {isNew}
>
  <svelte:fragment slot="body">
    <ContentFieldOption
      id="{_type}-multiple"
      label={trans("Allow users to select multiple values?")}
      showLabel={true}
    >
      <svelte:fragment slot="inside">
        <input
          ref="multiple"
          type="checkbox"
          class="mt-switch form-control form-check-input"
          id="{_type}-multiple"
          name="multiple"
          checked={options.multiple}
          on:click={changeStateMultiple}
        /><label for="{_type}-multiple" class="form-label"
          >{trans("Allow users to select multiple values?")}</label
        >
      </svelte:fragment>
    </ContentFieldOption>

    <ContentFieldOption
      id="{_type}-min"
      label={trans("Minimum number of selections")}
      showLabel={true}
      attr="show={options.multiple}"
    >
      <svelte:fragment slot="inside">
        <input
          ref="min"
          type="number"
          name="min"
          id="{_type}-min"
          class="form-control w-25"
          min="0"
          value={options.min}
        />
      </svelte:fragment>
    </ContentFieldOption>

    <ContentFieldOption
      id="{_type}-max"
      label={trans("Maximum number of selections")}
      showLabel={true}
      attr="show={options.multiple}"
    >
      <svelte:fragment slot="inside">
        <input
          ref="max"
          type="number"
          name="max"
          id="{_type}-max"
          class="form-control w-25"
          min="1"
          value={options.max}
          onchange={enterMax}
        />
      </svelte:fragment>
    </ContentFieldOption>

    <ContentFieldOption
      id="{_type}-values"
      required={true}
      label={trans("Values")}
      showLabel={true}
    >
      <svelte:fragment slot="inside">
        <div class="mt-table--outline mb-3">
          <table class="table mt-table values-option-table" ref="table">
            <thead>
              <tr>
                <th scope="col">{trans("Selected")}</th>
                <th scope="col">{trans("Label")}</th>
                <th scope="col">{trans("Value")}</th>
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
                        ><title>{trans("delete")}</title><use
                          xlink:href="{mtConfig.static_uri}images/sprite.svg#ic_trash"
                        /></svg
                      >{trans("delete")}</button
                    ></td
                  >
                </tr>
              {/each}
            </tbody>
          </table>
        </div>
        <button on:click={addRow} type="button" class="btn btn-default btn-sm"
          ><svg role="img" class="mt-icon mt-icon--sm"
            ><title>{trans("add")}</title><use
              xlink:href="{mtConfig.static_uri}images/sprite.svg#ic_add"
            /></svg
          >{trans("add")}</button
        >
      </svelte:fragment>
    </ContentFieldOption>
  </svelte:fragment>
</ContentFieldOptionGroup>
