import type { Writable } from "svelte/store";
import type * as Listing from "../@types/listing";

export type ReactiveStoreData = Omit<
  Listing.ListData,
  // 37個のメソッドを除外
  | "addFilterItem"
  | "addFilterItemContent"
  | "checkAllRows"
  | "clickRow"
  | "createNewFilter"
  | "getCheckedRowCount"
  | "getColumn"
  | "getCheckedColumnIds"
  | "getCheckedRowIds"
  | "getFilter"
  | "getListEnd"
  | "getListStart"
  | "getMobileColumnIndex"
  | "getNewFilterLabel"
  | "getSubField"
  | "hasMobileColumn"
  | "hasSystemFilter"
  | "isCheckedAllRowsOnPage"
  | "isFilterItemSelected"
  | "movePage"
  | "removeFilterItemByIndex"
  | "removeFilterItemContent"
  | "resetAllClickedRows"
  | "setFilter"
  | "setFilterById"
  | "setDeleteFilterResult"
  | "setResult"
  | "setSaveFilterResult"
  | "toggleAllRowsOnPage"
  | "toggleColumn"
  | "toggleRow"
  | "toggleSortColumn"
  | "toggleSubField"
  | "resetColumns"
  | "updateAllRowsOnPage"
  | "updateIsLoading"
  | "updateLimit"
>;

export type ListStoreContext = {
  store: Listing.ListStore;
  reactiveStore: Writable<ReactiveStoreData>;
};

export function createReactiveStoreData(
  store: Listing.ListStore,
): ReactiveStoreData {
  return {
    objects: store.objects || [],
    count: store.count || 0,
    limit: store.limit || 0,
    page: store.page || 0,
    pageMax: store.pageMax || 0,
    columns: store.columns || [],
    showColumns: store.showColumns || [],
    isLoading: store.isLoading || false,
    sortBy: store.sortBy || "",
    sortOrder: store.sortOrder || "",
    filters: store.filters || [],
    currentFilter: store.currentFilter || { items: [], label: "" },
    allpassFilter: store.allpassFilter || { items: [], label: "" },
    checkedAllRows: store.checkedAllRows || false,
    checkedAllRowsOnPage: store.checkedAllRowsOnPage || false,
    editableCount: store.editableCount || null,
    disableUserDispOption: store.disableUserDispOption || false,
    objectType: store.objectType || "",
    DefaultPage: store.DefaultPage || 1,
  };
}
