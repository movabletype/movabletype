<script lang="ts">
  import { SvelteComponent } from "svelte";

  import { Filter, ListStore } from "types/listing";

  import ListFilterSaveModal from "./ListFilterSaveModal.svelte";

  export let currentFilter: Filter;
  export let listFilterTopGetItemValues: () => void;
  export let listFilterTopIsUserFilter: () => boolean;
  export let listFilterTopValidateFilterDetails: () => boolean;
  export let objectLabel: string;
  export let store: ListStore;

  let listFilterSaveModal: SvelteComponent;

  const applyFilter = (): boolean | void => {
    if (!listFilterTopValidateFilterDetails()) {
      return false;
    }
    listFilterTopGetItemValues();
    const noFilterId = true;
    store.trigger("apply_filter", currentFilter, noFilterId);
  };

  const saveFilter = (): boolean | void => {
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
  };

  const saveAsFilter = (): boolean | void => {
    if (!listFilterTopValidateFilterDetails()) {
      return false;
    }
    listFilterSaveModal.openModal({
      filterLabel: currentFilter.label,
      saveAs: true,
    });
  };
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
