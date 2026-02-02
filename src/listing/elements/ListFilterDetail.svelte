<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import ListFilterItem from "./ListFilterItem.svelte";
  import ListFilterButtons from "./ListFilterButtons.svelte";

  type Props = {
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
    store: Listing.ListStore;
  };
  let {
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
    store,
  }: Props = $props();

  const addFilterItem = (e: Event): void => {
    if ((e.currentTarget as HTMLElement)?.classList.contains("disabled")) {
      e.preventDefault();
      e.stopPropagation();
      return;
    }
    const filterType =
      (e.currentTarget as HTMLElement)?.dataset.mtFilterType || "";
    listFilterTopAddFilterItem(filterType);
  };
</script>

<div class="row">
  <div class="col-12">
    <ul class="list-inline">
      <li class="list-inline-item">
        <div class="dropdown">
          <button
            class="btn btn-default dropdown-toggle"
            data-bs-toggle="dropdown"
          >
            {window.trans("Select Filter Item...")}
          </button>
          <div class="dropdown-menu">
            {#each filterTypes as filterType}
              {#if filterType.editable}
                <!-- svelte-ignore a11y-invalid-attribute -->
                <a
                  class:disabled={isFilterItemSelected(
                    currentFilter,
                    filterType.type,
                  )}
                  class="dropdown-item"
                  href="#"
                  data-mt-filter-type={filterType.type}
                  onclick={addFilterItem}
                >
                  {@html filterType.label}
                </a>
              {/if}
            {/each}
          </div>
        </div>
      </li>
    </ul>
  </div>
</div>
<div class="row mb-3">
  <div class="col-12">
    <ul class="list-group">
      {#each currentFilter.items as item, index}
        <!-- remove "item" property because it is not output in Riot.js -->
        <li
          data-is="list-filter-item"
          data-mt-list-item-index={index}
          class="list-group-item"
        >
          <ListFilterItem
            {currentFilter}
            {filterTypes}
            {item}
            {listFilterTopAddFilterItemContent}
            {listFilterTopRemoveFilterItem}
            {listFilterTopRemoveFilterItemContent}
            {localeCalendarHeader}
          />
        </li>
      {/each}
    </ul>
  </div>
</div>
<div class="row">
  <div data-is="list-filter-buttons" class="col-12">
    <ListFilterButtons
      {currentFilter}
      {listFilterTopGetItemValues}
      {listFilterTopIsUserFilter}
      {listFilterTopValidateFilterDetails}
      {objectLabel}
      {store}
    />
  </div>
</div>
