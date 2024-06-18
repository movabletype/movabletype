<script lang="ts">
  import { afterUpdate } from "svelte";

  import { addRow, deleteRow, validateTable } from "../SelectionCommonScript";

  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  // svelte-ignore unused-export-let
  export let config: MT.ContentType.ConfigOpts;
  export let fieldId: string;
  export let id: string;
  export let isNew: boolean;
  export let label: string;
  export let options: MT.ContentType.Options;
  // svelte-ignore unused-export-let
  export let optionsHtmlParams: MT.ContentType.OptionsHtmlParams;

  let refsTable: HTMLTableElement;

  // <mt:include name="content_field_type_options/selection_common_script.tmpl">
  // Copy from selection_common_script.tmpl below
  let values: Array<MT.ContentType.SelectionValue> = options.values;
  if (!values) {
    values = [
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
      values: values,
    };
  };
  // Copy from selection_common_script.tmpl above
  // <mt:include name="content_field_type_options/selection_common_script.tmpl">

  const enterInitial = (index: number): void => {
    values.forEach(function (v: MT.ContentType.SelectionValue) {
      v.checked = "";
    });
    values[index].checked = "checked";
    refreshView();
  };

  const refreshView = (): void => {
    // eslint-disable-next-line no-self-assign
    values = values;
  };
</script>

<ContentFieldOptionGroup
  type="radio-button"
  {fieldId}
  {id}
  {isNew}
  bind:label
  {options}
>
  <ContentFieldOption
    id="radio_button-values"
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
            <th scope="col">
              {window.trans("Selected")}
            </th>
            <th scope="col">
              {window.trans("Label")}
            </th>
            <th scope="col">
              {window.trans("Value")}
            </th>
            <th scope="col"></th>
          </tr>
        </thead>
        <tbody>
          {#each values as v, index}
            <tr class="text-center align-middle">
              <td
                ><input
                  type="radio"
                  class="form-check-input mt-3"
                  name={id + "-initial"}
                  checked={v.checked ? true : false}
                  on:change={() => {
                    enterInitial(index);
                  }}
                /></td
              >
              <td
                ><input
                  type="text"
                  class="form-control required"
                  name="label"
                  bind:value={v.label}
                /></td
              >
              <td
                ><input
                  type="text"
                  class="form-control required"
                  name="value"
                  bind:value={v.value}
                /></td
              >
              <td
                ><button
                  on:click={() => {
                    values = deleteRow(values, index);
                  }}
                  type="button"
                  class="btn btn-default btn-sm"
                  ><svg role="img" class="mt-icon mt-icon--sm"
                    ><title>{window.trans("delete")}</title><use
                      xlink:href="{window.StaticURI}images/sprite.svg#ic_trash"
                    ></use></svg
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
        values = addRow(values);
      }}
      type="button"
      class="btn btn-default btn-sm"
      ><svg role="img" class="mt-icon mt-icon--sm"
        ><title>{window.trans("add")}</title><use
          xlink:href="{window.StaticURI}images/sprite.svg#ic_add"
        ></use></svg
      >{window.trans("add")}</button
    >
  </ContentFieldOption>
</ContentFieldOptionGroup>
