<script>
  import ListFilterDetail from "./ListFilterDetail.svelte";
  import ListFilterHeader from "./ListFilterHeader.svelte";

  export let filterTypes;
  export let listActionClient;
  export let localeCalendarHeader;
  export let store;

  $: currentFilter = store.currentFilter;

  // TODO
  function addFilterItem() {}
  function addFilterItemContent() {}
  function createNewFilter() {}
  function isAllpassFilter() {}
  function isListFilterItemSelected() {}
  function removeFilterItem() {}
  function removeFilterItemContent() {}
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
      listFilterTopRemoveFilterItem={removeFilterItem}
      listFilterTopRemoveFilterItemContent={removeFilterItemContent}
      {localeCalendarHeader}
      {store}
    />
  </div>
</div>
