<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import { afterUpdate } from "svelte";

  import { addRow, deleteRow, validateTable } from "../SelectionCommonScript";

  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  // svelte-ignore unused-export-let
  export let config: ContentType.ConfigSettings;
  export let field: ContentType.Field;
  export let id: string;
  export let options: ContentType.Options;
  // svelte-ignore unused-export-let
  export let optionsHtmlParams: ContentType.OptionsHtmlParams;

  if (options.can_add === "0") {
    options.can_add = 0;
  }

  if (options.multiple === "0") {
    options.multiple = 0;
  }

  options.min ??= "";
  options.max ??= "";

  let refsTable: HTMLTableElement;

  // <mt:include name="content_field_type_options/selection_common_script.tmpl">
  // copoied some functions from selection_common_script.tmpl below
  if (!options.values) {
    options.values = [
      {
        checked: "",
        label: "",
        value: "",
      },
    ];
  }

  afterUpdate(() => {
    validateTable(refsTable);
  });

  export const gather = (): object => {
    return {
      values: options.values,
    };
  };
  // copied some functions from selection_common_script.tmpl above
  // <mt:include name="content_field_type_options/selection_common_script.tmpl">

  // deleteRow was moved to SelectionCommonScript.svelte

  const enterInitial = (e: Event, index: number): void => {
    const target = e.target as HTMLInputElement;
    const state = target.checked;
    const block = jQuery(e.target as HTMLElement).parents(".mt-contentfield");

    // Clear all check when not to allow multiple selection
    if (
      !options.multiple ||
      options.multiple === 0 ||
      options.multiple === false
    ) {
      _clearAllInitial(block);
    }

    // Set current item status
    (e.target as HTMLInputElement).checked = state;
    options.values[index].checked = state ? "checked" : "";

    if (options.multiple || options.multiple === 1) {
      _updateInittialField(block);
    }

    // added in Svelte
    refreshView();
  };

  const changeStateMultiple = (e: Event): void => {
    const target = e.target as HTMLInputElement;
    const block = jQuery(target).parents(".mt-contentfield");
    options.multiple = target.checked;
    if (
      !options.multiple &&
      block.find(".values-option-table").find('input[type="checkbox"]:checked')
        .length > 1
    ) {
      _clearAllInitial(block);
    }
    refreshView();
  };

  const enterMax = (e: Event): void => {
    const block = jQuery(e.target as HTMLElement).parents(".mt-contentfield");
    _updateInittialField(block);
  };

  const _updateInittialField = (block: JQuery<HTMLElement>): void => {
    const max = Number(block.find('input[name="max"]').val());
    const cur = block
      .find(".values-option-table")
      .find('input[type="checkbox"]:checked').length;
    if (max === 0 || cur < max) {
      const chkbox = block
        .find(".values-option-table")
        .find('input[type="checkbox"]');
      jQuery.each(chkbox, function (i: number) {
        jQuery(chkbox[i]).prop("disabled", false);
      });
    } else {
      const chkbox = block
        .find(".values-option-table")
        .find('input[type="checkbox"]:not(:checked)');
      jQuery.each(chkbox, function (i: number) {
        jQuery(chkbox[i]).prop("disabled", true);
      });
    }
  };

  const _clearAllInitial = (block: JQuery<HTMLElement>): void => {
    const initials = block
      .find(".values-option-table")
      .find('input[type="checkbox"]');
    if (initials.length > 1) {
      jQuery.each(initials, function (v: number) {
        const elm = jQuery(initials[v]);
        elm.prop("checked", false);
        elm.prop("disabled", false);
      });
    }
    options.values.forEach(function (v: ContentType.SelectionValue) {
      v.checked = "";
    });
  };

  // added in Svelte
  const refreshView = (): void => {
    // eslint-disable-next-line no-self-assign
    options = options;
  };
</script>

<ContentFieldOptionGroup type="select-box" bind:field {id} bind:options>
  <ContentFieldOption
    id="select_box-multiple"
    label={window.trans("Allow users to select multiple values?")}
  >
    <input
      {...{ ref: "multiple" }}
      type="checkbox"
      class="mt-switch form-control form-check-input"
      id="select_box-multiple"
      name="multiple"
      bind:checked={options.multiple}
      on:click={changeStateMultiple}
    /><label for="select_box-multiple" class="form-label"
      >{window.trans("Allow users to select multiple values?")}</label
    >
  </ContentFieldOption>

  <ContentFieldOption
    id="select_box-min"
    label={window.trans("Minimum number of selections")}
    attrShow={options.multiple ? true : false}
  >
    <input
      {...{ ref: "min" }}
      type="number"
      name="min"
      id="select_box-min"
      class="form-control w-25"
      min="0"
      bind:value={options.min}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="select_box-max"
    label={window.trans("Maximum number of selections")}
    attrShow={options.multiple ? true : false}
  >
    <input
      {...{ ref: "max" }}
      type="number"
      name="max"
      id="select_box-max"
      class="form-control w-25"
      min="1"
      bind:value={options.max}
      on:change={enterMax}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="select_box-values"
    required={1}
    label={window.trans("Values")}
  >
    <div class="mt-table--outline mb-3">
      <table
        class="table mt-table values-option-table"
        {...{ ref: "table" }}
        bind:this={refsTable}
      >
        <thead>
          <tr>
            <th scope="col">{window.trans("Selected")}</th>
            <th scope="col">{window.trans("Label")}</th>
            <th scope="col">{window.trans("Value")}</th>
            <th scope="col" />
          </tr>
        </thead>
        <tbody>
          {#each options.values as v, index}
            <tr class="text-center align-middle">
              <td
                ><input
                  type="checkbox"
                  class="form-check-input mt-3"
                  checked={v.checked ? true : false}
                  on:change={(e) => {
                    enterInitial(e, index);
                  }}
                /></td
              >
              <td
                ><!-- oninput was removed and bind is used -->
                <input
                  type="text"
                  class="form-control required"
                  name="label"
                  bind:value={v.label}
                /></td
              >
              <td
                ><!-- oninput was removed and bind is used -->
                <input
                  type="text"
                  class="form-control required"
                  name="value"
                  bind:value={v.value}
                /></td
              >
              <td
                ><button
                  on:click={() => {
                    options.values = deleteRow(options.values, index);
                  }}
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
    <button
      on:click={() => {
        options.values = addRow(options.values);
      }}
      type="button"
      class="btn btn-default btn-sm"
      ><svg role="img" class="mt-icon mt-icon--sm"
        ><title>{window.trans("add")}</title><use
          xlink:href="{window.StaticURI}images/sprite.svg#ic_add"
        /></svg
      >{window.trans("add")}</button
    >
  </ContentFieldOption>
</ContentFieldOptionGroup>
