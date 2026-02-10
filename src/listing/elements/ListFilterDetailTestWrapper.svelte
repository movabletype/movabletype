<script lang="ts">
  import { setContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";
  import type * as Listing from "../../@types/listing";
  import ListFilterDetail from "./ListFilterDetail.svelte";

  let {
    context,
    currentFilter,
    filterTypes,
    isFilterItemSelected,
    listFilterTopAddFilterItem,
    listFilterTopAddFilterItemContent,
    listFilterTopGetItemValues,
    listFilterTopIsUserFilter,
    listFilterTopRemoveFilterItem,
    listFilterTopRemoveFilterItemContent,
    listFilterTopValidateFilterDetails,
    localeCalendarHeader,
    objectLabel,
  }: {
    context: ListStoreContext;
    currentFilter: Listing.Filter;
    filterTypes: Array<Listing.FilterType>;
    isFilterItemSelected: (filter: Listing.Filter, type: string) => boolean;
    listFilterTopAddFilterItem: (filterType: string) => void;
    listFilterTopAddFilterItemContent: (
      itemIndex: string,
      contentIndex: string,
    ) => void;
    listFilterTopGetItemValues: () => void;
    listFilterTopIsUserFilter: () => boolean;
    listFilterTopRemoveFilterItem: (itemIndex: string) => void;
    listFilterTopRemoveFilterItemContent: (
      itemIndex: string,
      contentIndex: string,
    ) => void;
    listFilterTopValidateFilterDetails: () => boolean;
    localeCalendarHeader: Array<string>;
    objectLabel: string;
  } = $props();

  setContext("listStore", context);
</script>

<ListFilterDetail
  {currentFilter}
  {filterTypes}
  {isFilterItemSelected}
  {listFilterTopAddFilterItem}
  {listFilterTopAddFilterItemContent}
  {listFilterTopGetItemValues}
  {listFilterTopIsUserFilter}
  {listFilterTopRemoveFilterItem}
  {listFilterTopRemoveFilterItemContent}
  {listFilterTopValidateFilterDetails}
  {localeCalendarHeader}
  {objectLabel}
/>
