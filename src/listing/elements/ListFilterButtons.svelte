<script>
  import ListFilterSaveModal from "./ListFilterSaveModal.svelte";

  export let currentFilter;
  export let listFilterTopGetItemValues;
  export let listFilterTopIsUserFilter;
  export let listFilterTopValidateFilterDetails;
  export let objectLabel;
  export let store;

  let listFilterSaveModal;

  function applyFilter() {
    if (!listFilterTopValidateFilterDetails()) {
      return false;
    }
    listFilterTopGetItemValues();
    const noFilterId = true;
    store.trigger("apply_filter", currentFilter, noFilterId);
  }

  function saveFilter() {
    if (!listFilterTopValidateFilterDetails()) {
      return false;
    }
    if (listFilterTopIsUserFilter()) {
      listFilterTopGetItemValues();
      store.trigger("save_filter", currentFilter);
    } else {
      const filterLabel = store.getNewFilterLabel(objectLabel);
      listFilterSaveModal.openModal({
        filterLabel: filterLabel,
      });
    }
  }

  function saveAsFilter() {
    if (!listFilterTopValidateFilterDetails()) {
      return false;
    }
    listFilterSaveModal.openModal({
      filterLabel: currentFilter.label,
      saveAs: true,
    });
  }
</script>

<button
  class="btn btn-primary"
  disabled={currentFilter.items.length == 0}
  on:click={applyFilter}
>
  {window.trans("Apply")}
</button>
<button
  class="btn btn-default"
  disabled={currentFilter.items.length == 0 || currentFilter.can_save == "0"}
  on:click={saveFilter}
>
  {window.trans("Save")}
</button>
{#if currentFilter.id && currentFilter.items.length > 0}
  <button class="btn btn-default" on:click={saveAsFilter}>
    {window.trans("Save As")}
  </button>
{/if}
<ListFilterSaveModal bind:this={listFilterSaveModal} {store} />
