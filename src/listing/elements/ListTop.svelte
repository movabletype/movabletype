<script>
  import { onMount } from "svelte";

  import { ListingOpts, ListingStore } from "../ListingStore.ts";

  import DisplayOptions from "./DisplayOptions.svelte";
  import DisplayOptionsForMobile from "./DisplayOptionsForMobile.svelte";
  import ListActions from "./ListActions.svelte";
  import ListCount from "./ListCount.svelte";
  import ListFilter from "./ListFilter.svelte";
  import ListPagination from "./ListPagination.svelte";
  import ListTable from "./ListTable.svelte";

  export let allpassFilter;
  export let buttonActions;
  export let disableUserDispOption;
  export let filterTypes;
  export let hasListActions;
  export let hasMobilePulldownActions;
  export let hasPulldownActions;
  export let initialFilter;
  export let listActionClient;
  export let listActions;
  export let localeCalendarHeader;
  export let moreListActions;
  export let objectLabel;
  export let objectType;
  export let objectTypeForTableClass;
  export let plural;
  export let useActions;
  export let useFilters;
  export let singular;
  export let store;
  export let zeroStateLabel;

  let opts = {};
  ListingOpts.set(opts);
  ListingStore.set(store);

  // export let listStore = window.listStore;

  onMount(() => {
    store.trigger("load_list");
  });

  store.on("refresh_view", (args) => {
    if (!args) args = {};

    updateSubFields();
    if (args.moveToPagination) {
      window.document.body.scrollTop = window.document.body.scrollHeight;
    }
    if (!args.notCallListReady) {
      jQuery(window).trigger("listReady");
    }

    store = store;
  });

  function updateSubFields() {
    store.columns.forEach(function (column) {
      column.sub_fields.forEach(function (subField) {
        const selector = "td." + subField.parent_id + " ." + subField.class;
        const element = document.querySelector(selector);
        if (subField.checked) {
          element.style.display = "block";
        } else {
          element.style.display = "none";
        }
      });
    });
  }

  function tableClass() {
    return "list-" + (objectTypeForTableClass || objectType);
  }
</script>

<div class="d-none d-md-block mb-3">
  <DisplayOptions {store} />
</div>
<div id="actions-bar-top" class="row mb-5 mb-md-3">
  <div class="col">
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
  </div>
  <div class="col-auto align-self-end list-counter">
    <ListCount count={store.count} limit={store.limit} page={store.page} />
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
<DisplayOptionsForMobile limit={store.limit} {store} />
