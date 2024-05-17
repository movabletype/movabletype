<script>
  import ListFilterDetail from "./ListFilterDetail.svelte";
  import ListFilterHeader from "./ListFilterHeader.svelte";

  export let filterTypes;
  export let listActionClient;
  export let localeCalendarHeader;
  export let objectLabel;
  export let store;

  $: currentFilter = store.currentFilter;

  // TODO
  function addFilterItem() {}
  function addFilterItemContent() {}
  function createNewFilter() {}
  function getItemValues() {}
  function isAllpassFilter() {}
  function isListFilterItemSelected() {}
  function isUserFilter() {}
  function removeFilterItem() {}
  function removeFilterItemContent() {}
  function validateFilterDetails() {}
</script>

<div class="card-header">
  <ListFilterHeader
    {currentFilter}
    {isAllpassFilter}
    listFilterTopCreateNewFilter={createNewFilter}
    {listActionClient}
    {store}
  />
</div>
<div id="list-filter-collapse" class="collapse">
  <div id="filter-detail" class="card-block p-3">
    <ListFilterDetail
      {currentFilter}
      {filterTypes}
      {isListFilterItemSelected}
      listFilterTopAddFilterItem={addFilterItem}
      listFilterTopAddFilterItemContent={addFilterItemContent}
      listFilterTopGetItemValues={getItemValues}
      listFilterTopIsUserFilter={isUserFilter}
      listFilterTopRemoveFilterItem={removeFilterItem}
      listFilterTopRemoveFilterItemContent={removeFilterItemContent}
      listFilterTopValidateFilterDetails={validateFilterDetails}
      {localeCalendarHeader}
      {objectLabel}
      {store}
    />
  </div>
</div>
