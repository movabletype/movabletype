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

  let refsTable: HTMLTableElement;

  // <mt:include name="content_field_type_options/selection_common_script.tmpl">
  // copied some functions from selection_common_script.tmpl below
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

  const enterInitial = (index: number): void => {
    options.values.forEach(function (v: ContentType.SelectionValue) {
      v.checked = "";
    });
    options.values[index].checked = "checked";
    refreshView();
  };

  // deleteRow was moved to SelectionCommonScript.svelte

  // added in Svelte
  const refreshView = (): void => {
    // eslint-disable-next-line no-self-assign
    options = options;
  };
</script>

<ContentFieldOptionGroup type="radio-button" bind:field {id} bind:options>
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
          {#each options.values as v, index}
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
        options.values = addRow(options.values);
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
