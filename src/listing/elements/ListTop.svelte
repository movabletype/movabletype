<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import { onMount, setContext } from "svelte";
  import { writable, type Writable } from "svelte/store";
  import {
    createReactiveStoreData,
    type ReactiveStoreData,
  } from "../listStoreContext";

  import DisplayOptions from "./DisplayOptions.svelte";
  import DisplayOptionsForMobile from "./DisplayOptionsForMobile.svelte";
  import ListActions from "./ListActions.svelte";
  import ListCount from "./ListCount.svelte";
  import ListFilter from "./ListFilter.svelte";
  import ListPagination from "./ListPagination.svelte";
  import ListTable from "./ListTable.svelte";

  type Props = {
    buttonActions: Listing.ButtonActions;
    disableUserDispOption: boolean;
    filterTypes: Array<Listing.FilterType>;
    hasListActions: boolean;
    hasMobilePulldownActions: boolean;
    hasPulldownActions: boolean;
    listActionClient: Listing.ListActionClient;
    listActions: Listing.ListActions;
    localeCalendarHeader: Array<string>;
    moreListActions: Listing.MoreListActions;
    objectLabel: string;
    objectType: string;
    objectTypeForTableClass: string;
    plural: string;
    useActions: boolean;
    useFilters: boolean;
    singular: string;
    store: Listing.ListStore;
    zeroStateLabel: string;
  };

  let {
    buttonActions,
    disableUserDispOption,
    filterTypes,
    hasListActions,
    hasMobilePulldownActions,
    hasPulldownActions,
    listActionClient,
    listActions,
    localeCalendarHeader,
    moreListActions,
    objectLabel,
    objectType,
    objectTypeForTableClass,
    plural,
    useActions,
    useFilters,
    singular,
    store,
    zeroStateLabel,
  }: Props = $props();
  let callListReady = false;

  // svelte-ignore state_referenced_locally
  const reactiveStore: Writable<ReactiveStoreData> = writable(
    createReactiveStoreData(store),
  );
  // svelte-ignore state_referenced_locally
  setContext("listStore", { store, reactiveStore });

  let hidden = $derived($reactiveStore.count === 0);

  onMount(() => {
    store.trigger("load_list");

    store.on(
      "refresh_view",
      (args?: { moveToPagination?: boolean; notCallListReady?: boolean }) => {
        if (!args) args = {};

        update();

        if (args.moveToPagination) {
          window.document.body.scrollTop = window.document.body.scrollHeight;
        }
        if (!args.notCallListReady) {
          // trigger a "listReady" event in afterUpdate() after the DOM has been updated
          callListReady = true;
        }
      },
    );
  });

  $effect(() => {
    // update sub_fields not managed in the svelte lifecycle
    updateSubFields();

    if (callListReady) {
      callListReady = false;
      jQuery(window).trigger("listReady");
    }
  });

  const changeLimit = (e: Event): void => {
    store.trigger("update_limit", (e.target as HTMLSelectElement)?.value);
  };

  const update = (): void => {
    reactiveStore.set(createReactiveStoreData(store));
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
  <DisplayOptions {changeLimit} {disableUserDispOption} />
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
      />
    {/if}
  </div>
  <div class="col-auto align-self-end list-counter">
    <ListCount />
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
        />
      {/if}
      <div style="overflow-x: auto">
        <table id="{objectType}-table" class="table mt-table {tableClass()}">
          <ListTable
            {hasListActions}
            {hasMobilePulldownActions}
            {zeroStateLabel}
          />
        </table>
      </div>
    </div>
  </div>
</div>
<div class="row" {hidden} style:display={hidden ? "none" : ""}>
  <ListPagination />
</div>
<DisplayOptionsForMobile {changeLimit} />
