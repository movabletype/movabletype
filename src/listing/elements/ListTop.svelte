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

  export let opts;
  export let store;

  ListingOpts.set(opts);
  ListingStore.set(store);

  export let listStore = window.listStore;

  onMount(() => {
    listStore.trigger("load_list");
  });

  listStore.on("refresh_view", (args) => {
    if (!args) args = {};

    updateSubFields();
    if (args.moveToPagination) {
      window.document.body.scrollTop = window.document.body.scrollHeight;
    }
    if (!args.notCallListReady) {
      jQuery(window).trigger("listReady");
    }

    listStore = listStore;
  });

  function updateSubFields() {
    listStore.columns.forEach(function (column) {
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
    const objectType = opts.objectTypeForTableClass || opts.objectType;
    return "list-" + objectType;
  }
</script>

<div class="d-none d-md-block mb-3">
  <DisplayOptions {listStore} />
</div>
<div id="actions-bar-top" class="row mb-5 mb-md-3">
  <div class="col">
    <ListActions {listStore} {opts} />
  </div>
  <div class="col-auto align-self-end list-counter">
    <ListCount
      count={listStore.count}
      limit={listStore.limit}
      page={listStore.page}
    />
  </div>
</div>
<div class="row mb-5 mb-md-3">
  <div class="col-12">
    <div class="card">
      {#if opts.useFilters}
        <ListFilter />
      {/if}
      <div style="overflow-x: auto">
        <table
          id="{opts.objectType}-table"
          class="table mt-table {tableClass()}"
        >
          <ListTable />
        </table>
      </div>
    </div>
  </div>
</div>
{#if listStore.count != 0}
  <div class="row">
    <ListPagination />
  </div>
{/if}
<DisplayOptionsForMobile {listStore} limit={listStore.limit} />
