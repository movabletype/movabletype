<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import { afterUpdate, onMount } from "svelte";

  import DisplayOptions from "./DisplayOptions.svelte";
  import DisplayOptionsForMobile from "./DisplayOptionsForMobile.svelte";
  import ListActions from "./ListActions.svelte";
  import ListCount from "./ListCount.svelte";
  import ListFilter from "./ListFilter.svelte";
  import ListPagination from "./ListPagination.svelte";
  import ListTable from "./ListTable.svelte";

  export let buttonActions: Listing.ButtonActions;
  export let disableUserDispOption: boolean;
  export let filterTypes: Array<Listing.FilterType>;
  export let hasListActions: boolean;
  export let hasMobilePulldownActions: boolean;
  export let hasPulldownActions: boolean;
  export let listActionClient: Listing.ListActionClient;
  export let listActions: Listing.ListActions;
  export let localeCalendarHeader: Array<string>;
  export let moreListActions: Listing.MoreListActions;
  export let objectLabel: string;
  export let objectType: string;
  export let objectTypeForTableClass: string;
  export let plural: string;
  export let useActions: boolean;
  export let useFilters: boolean;
  export let singular: string;
  export let store: Listing.ListStore;
  export let zeroStateLabel: string;

  $: hidden = store.count === 0;

  onMount(() => {
    store.trigger("load_list");
  });

  // sub_fields are not updated yet in store.on("refresh_view", ...)
  afterUpdate(() => {
    updateSubFields();
  });

  store.on(
    "refresh_view",
    (args?: { moveToPagination?: boolean; notCallListReady?: boolean }) => {
      if (!args) args = {};

      update();

      if (args.moveToPagination) {
        window.document.body.scrollTop = window.document.body.scrollHeight;
      }
      if (!args.notCallListReady) {
        jQuery(window).trigger("listReady");
      }
    },
  );

  const changeLimit = (e: Event): void => {
    store.trigger("update_limit", (e.target as HTMLSelectElement)?.value);
  };

  const update = (): void => {
    // eslint-disable-next-line no-self-assign
    store = store;
  };

  const updateSubFields = (): void => {
    store.columns.forEach((column) => {
      column.sub_fields.forEach((subField) => {
        const selector = "td." + subField.parent_id + " ." + subField.class;
        if (subField.checked) {
          jQuery(selector).show();
        } else {
          jQuery(selector).hide();
        }
      });
    });
  };

  const tableClass = (): string => {
    return "list-" + (objectTypeForTableClass || objectType);
  };
</script>

<div class="d-none d-md-block mb-3" data-is="display-options">
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
<div class="row" {hidden} style:display={hidden ? "none" : ""}>
  <ListPagination {store} />
</div>
<DisplayOptionsForMobile {changeLimit} {store} />
