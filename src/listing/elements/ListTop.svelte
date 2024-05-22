<script lang="ts">
  import { afterUpdate, onMount } from "svelte";

  import {
    ButtonActions,
    FilterType,
    ListActionClient,
    ListStore,
    MoreListActions,
  } from "types/listing";

  import DisplayOptions from "./DisplayOptions.svelte";
  import DisplayOptionsForMobile from "./DisplayOptionsForMobile.svelte";
  import ListActions from "./ListActions.svelte";
  import ListCount from "./ListCount.svelte";
  import ListFilter from "./ListFilter.svelte";
  import ListPagination from "./ListPagination.svelte";
  import ListTable from "./ListTable.svelte";

  export let buttonActions: ButtonActions;
  export let disableUserDispOption: boolean;
  export let filterTypes: Array<FilterType>;
  export let hasListActions: boolean;
  export let hasMobilePulldownActions: boolean;
  export let hasPulldownActions: boolean;
  export let listActionClient: ListActionClient;
  export let listActions: ListActions;
  export let localeCalendarHeader: Array<string>;
  export let moreListActions: MoreListActions;
  export let objectLabel: string;
  export let objectType: string;
  export let objectTypeForTableClass: string;
  export let plural: string;
  export let useActions: boolean;
  export let useFilters: boolean;
  export let singular: string;
  export let store: ListStore;
  export let zeroStateLabel: string;

  onMount(() => {
    store.trigger("load_list");
  });

  // sub_fields are not updated yet in store.on("refresh_view", ...)
  afterUpdate(() => {
    updateSubFields();
  });

  store.on("refresh_view", (args) => {
    if (!args) args = {};

    if (args.moveToPagination) {
      window.document.body.scrollTop = window.document.body.scrollHeight;
    }
    if (!args.notCallListReady) {
      jQuery(window).trigger("listReady");
    }

    // eslint-disable-next-line no-self-assign
    store = store;
  });

  const changeLimit = (selectedValue: string): void => {
    store.trigger("update_limit", selectedValue);
  };

  const updateSubFields = (): void => {
    store.columns.forEach(function (column) {
      column.sub_fields.forEach(function (subField) {
        const selector = "td." + subField.parent_id + " ." + subField.class;
        const element: HTMLElement | null = document.querySelector(selector);
        if (!element) {
          return;
        }

        if (subField.checked) {
          element.style.display = "block";
        } else {
          element.style.display = "none";
        }
      });
    });
  };

  const tableClass = (): string => {
    return "list-" + (objectTypeForTableClass || objectType);
  };
</script>

<div class="d-none d-md-block mb-3">
  <DisplayOptions {changeLimit} {disableUserDispOption} {store} />
</div>
<div id="actions-bar-top" class="row mb-5 mb-md-3">
  <div class="col">
    {#if useActions}
      <ListActions
        {buttonActions}
        {hasPulldownActions}
        {listActions}
        {listActionClient}
        {moreListActions}
        {plural}
        {singular}
        {store}
      />
    {/if}
  </div>
  <div class="col-auto align-self-end list-counter">
    <ListCount {store} />
  </div>
</div>
<div class="row mb-5 mb-md-3">
  <div class="col-12">
    <div class="card">
      {#if useFilters}
        <ListFilter
          {filterTypes}
          {listActionClient}
          {localeCalendarHeader}
          {objectLabel}
          {store}
        />
      {/if}
      <div style="overflow-x: auto">
        <table id="{objectType}-table" class="table mt-table {tableClass()}">
          <ListTable
            {hasListActions}
            {hasMobilePulldownActions}
            {store}
            {zeroStateLabel}
          />
        </table>
      </div>
    </div>
  </div>
</div>
{#if store.count != 0}
  <div class="row">
    <ListPagination {store} />
  </div>
{/if}
<DisplayOptionsForMobile {changeLimit} {store} />
