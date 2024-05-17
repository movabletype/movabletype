<script>
  import ListFilterDetail from "./ListFilterDetail.svelte";
  import ListFilterHeader from "./ListFilterHeader.svelte";

  export let listStore;
  export let opts;

  $: currentFilter = listStore.currentFilter;

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
    {listStore}
    {opts}
  />
</div>
<div id="list-filter-collapse" class="collapse">
  <div id="filter-detail" class="card-block p-3">
    <ListFilterDetail
      {currentFilter}
      {isListFilterItemSelected}
      listFilterTopAddFilterItem={addFilterItem}
      listFilterTopAddFilterItemContent={addFilterItemContent}
      listFilterTopRemoveFilterItem={removeFilterItem}
      listFilterTopRemoveFilterItemContent={removeFilterItemContent}
      {listStore}
      {opts}
    />
  </div>
</div>
