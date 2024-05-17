<script>
  import ListFilterItem from "./ListFilterItem.svelte";
  import ListFilterButtons from "./ListFilterButtons.svelte";

  export let currentFilter;
  export let filterTypes;
  export let isListFilterItemSelected;
  export let listFilterTopAddFilterItem;
  export let listFilterTopAddFilterItemContent;
  export let listFilterTopGetItemValues;
  export let listFilterTopIsUserFilter;
  export let listFilterTopRemoveFilterItem;
  export let listFilterTopRemoveFilterItemContent;
  export let listFilterTopValidateFilterDetails;
  export let localeCalendarHeader;
  export let objectLabel;
  export let store;

  function addFilterItem(e) {
    if (e.currentTarget.classList.contains("disabled")) {
      e.preventDefault();
      e.stopPropagation();
      return;
    }
    const filterType = e.currentTarget.dataset.mtFilterType;
    listFilterTopAddFilterItem(filterType);
  }
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
            {" " + window.trans("Select Filter Item...") + " "}
          </button>
          <div class="dropdown-menu">
            {#each filterTypes as filterType}
              {#if filterType.editable}
                <!-- svelte-ignore a11y-invalid-attribute -->
                <a
                  class="{isListFilterItemSelected(filterType.type)
                    ? 'disabled '
                    : ' '}dropdown-item"
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
      {#each store.currentFilter.items as item, index}
        <li class="list-group-item" data-mt-list-item-index={index}>
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
  <div class="col-12">
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
