<script>
  import ListFilterSaveModal from "./ListFilterSaveModal.svelte";

  export let currentFilter;
  export let listStore;

  function applyFilter(e) {
    if (!this.listFilterTop.validateFilterDetails()) {
      return false;
    }
    this.listFilterTop.getItemValues();
    const noFilterId = true;
    listStore.trigger("apply_filter", currentFilter, noFilterId);
  }

  function saveFilter(e) {
    if (!this.listFilterTop.validateFilterDetails()) {
      return false;
    }
    if (this.listFilterTop.isUserFilter()) {
      this.listFilterTop.getItemValues();
      listStore.trigger("save_filter", currentFilter);
    } else {
      const filterLabel = listStore.getNewFilterLabel(opts.objectLabel);
      this.tags["list-filter-save-modal"].openModal({
        filterLabel: filterLabel,
      });
    }
  }

  function saveAsFilter(e) {
    if (!this.listFilterTop.validateFilterDetails()) {
      return false;
    }
    this.tags["list-filter-save-modal"].openModal({
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
<ListFilterSaveModal {listStore} />
