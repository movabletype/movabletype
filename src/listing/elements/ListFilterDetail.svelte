<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import ListFilterItem from "./ListFilterItem.svelte";
  import ListFilterButtons from "./ListFilterButtons.svelte";

  export let currentFilter: Listing.Filter;
  export let filterTypes: Array<Listing.FilterType>;
  export let isFilterItemSelected: (
    filter: Listing.Filter,
    type: string,
  ) => boolean;
  export let listFilterTopAddFilterItem: (filterType: string) => void;
  export let listFilterTopAddFilterItemContent: (
    itemIndex: string,
    contentIndex: string,
  ) => void;
  export let listFilterTopGetItemValues: () => void;
  export let listFilterTopIsUserFilter: () => boolean;
  export let listFilterTopRemoveFilterItem: (itemIndex: string) => void;
  export let listFilterTopRemoveFilterItemContent: (
    itemIndex: string,
    contentIndex: string,
  ) => void;
  export let listFilterTopValidateFilterDetails: () => boolean;
  export let localeCalendarHeader: Array<string>;
  export let objectLabel: string;
  export let store: Listing.ListStore;

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
                  on:click={addFilterItem}
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
