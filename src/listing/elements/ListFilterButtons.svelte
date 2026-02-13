<script lang="ts">
  import { getContext } from "svelte";
  import type * as Listing from "../../@types/listing";

  import ListFilterSaveModal from "./ListFilterSaveModal.svelte";
  import type { ListStoreContext } from "../listStoreContext";

  type Props = {
    currentFilter: Listing.Filter;
    listFilterTopGetItemValues: () => void;
    listFilterTopIsUserFilter: () => boolean;
    listFilterTopValidateFilterDetails: () => boolean;
    objectLabel: string;
  };
  let {
    currentFilter,
    listFilterTopGetItemValues,
    listFilterTopIsUserFilter,
    listFilterTopValidateFilterDetails,
    objectLabel,
  }: Props = $props();

  const { store } = getContext<ListStoreContext>("listStore");

  type ListFilterSaveModalInstance = {
    openModal: (args?: { filterLabel?: string; saveAs?: boolean }) => void;
  };
  let saveModal: ListFilterSaveModalInstance;

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
      saveModal.openModal({
        filterLabel: filterLabel,
      });
    }
  };

  const saveAsFilter = (): boolean | void => {
    if (!listFilterTopValidateFilterDetails()) {
      return false;
    }
    saveModal.openModal({
      filterLabel: currentFilter.label,
      saveAs: true,
    });
  };
</script>

<button
  class="btn btn-primary"
  disabled={currentFilter.items.length === 0}
  onclick={applyFilter}
>
  {window.trans("Apply")}
</button>
<button
  class="btn btn-default"
  disabled={currentFilter.items.length === 0 ||
    currentFilter.can_save?.toString() === "0"}
  onclick={saveFilter}
>
  {window.trans("Save")}
</button>
{#if currentFilter.id && currentFilter.items.length > 0}
  <button class="btn btn-default" onclick={saveAsFilter}>
    {window.trans("Save As")}
  </button>
{/if}
<ListFilterSaveModal {listFilterTopGetItemValues} bind:this={saveModal} />
