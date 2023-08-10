<script>
  import { ListingOpts, ListingStore } from '../ListingStore.ts';
  import ListFilterSaveModal from "./ListFilterSaveModal.svelte";

  function applyFilter(e) {
//    if (!this.listFilterTop.validateFilterDetails()) {
//      return false
//    }
//    this.listFilterTop.getItemValues()
//    var noFilterId = true
//    this.store.trigger('apply_filter', this.listFilterTop.currentFilter, noFilterId)
  }

  function saveFilter(e) {
//    if (!this.listFilterTop.validateFilterDetails()) {
//      return false
//    }
//    if (this.listFilterTop.isUserFilter()) {
//      this.listFilterTop.getItemValues()
//      this.store.trigger('save_filter', this.listFilterTop.currentFilter)
//    } else {
//      var filterLabel = this.store.getNewFilterLabel(this.listTop.opts.objectLabel)
//      this.tags['list-filter-save-modal'].openModal({ filterLabel: filterLabel })
//    }
  }

  function saveAsFilter(e) {
//    if (!this.listFilterTop.validateFilterDetails()) {
//      return false
//    }
//    this.tags['list-filter-save-modal'].openModal({
//      filterLabel: this.listFilterTop.currentFilter.label,
//      saveAs: true
//    })
  }
</script>

<button class="btn btn-primary"
disabled={ $ListingStore.currentFilter.items.length == 0 }
on:click={ applyFilter }
>
{ trans('Apply') }
</button>
<button class="btn btn-default"
disabled={ $ListingStore.currentFilter.items.length == 0
  || $ListingStore.currentFilter.can_save == '0'
}
on:click={ saveFilter }
>
{ trans('Save') }
</button>
{#if $ListingStore.currentFilter.id && $ListingStore.currentFilter.items.length > 0}
<button
class="btn btn-default"
on:click={ saveAsFilter }
>
{ trans('Save As') }
</button>
{/if}
<ListFilterSaveModal />
