<script>
  import { ListingOpts, ListingStore } from '../ListingStore.ts';

  function applyFilter(e) {
//    closeModal()
//    const filterId = e.target.parentElement.dataset.mtListFilterId
//    $ListingStore.trigger('apply_filter_by_id', filterId)
  }

  function startEditingFilter(e) {
//    stopEditingAllFilters()
//    const filterData = e.target.parentElement.parentElement.dataset
//    isEditingFilter[filterData.mtListFilterId] = true
  }

  function stopEditingAllFilters() {
    $ListingStore.isEditingFilter = {}
  }

  function stopEditingFilter(e) {
//    const filterData = e.target.parentElement.parentElement.parentElement.dataset
//    isEditingFilter[filterData.mtListFilterId] = false
  }

  function closeModal() {
//    jQuery('#select-filter').modal('hide')
  }

  function createNewFilter(e) {
//    closeModal();
//    store.trigger('open_filter_detail')
//    listFilterTop.createNewFilter()
//    listFilterTop.update()
  }

  function renameFilter(e) {
//    const filterData = e.target.parentElement.parentElement.parentElement.dataset
//    store.trigger(
//      'rename_filter_by_id',
//      filterData.mtListFilterId,
//      refs.label.value
//    )
//    isEditingFilter[filterData.mtListFilterId] = false
  }

  function removeFilter(e) {
//    const filterData = e.target.closest('[data-mt-list-filter-label]').dataset
//    const message = trans(
//      "Are you sure you want to remove filter '[_1]'?",
//      filterData.mtListFilterLabel
//    )
//    if (confirm(message) == false) {
//      return false
//    }
//    this.store.trigger('remove_filter_by_id', filterData.mtListFilterId)
  }

  function hasSystemFilter() {
    return $ListingStore.filters.some(function (filter) {
      return filter.can_save == '0';
    });
  }


</script>

<div class="modal fade" id="select-filter" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">{ trans( 'Select Filter' ) }</h5>
        <button type="button" class="close" data-dismiss="modal"><span>×</span></button>
      </div>
      <div class="modal-body">
        <div class="filter-list-block">
          <h6 class="filter-list-label">{ trans( 'My Filters' ) }</h6>
          <ul id="user-filters" class="list-unstyled editable">
            {#each $ListingStore.filters as { id, filter }}
              {#if filter.can_save === "1"}
                <li class="filter line"
                  data-mt-list-filter-id={ id }
                  data-mt-list-filter-label={ filter.label }
                >
                  {#if !parent.isEditingFilter[id]}
                    <a href="#" onclick={ applyFilter }>
                      {@html filter.label }
                    </a>
                    <div class="float-right d-none d-md-block">
                      <a href="#" on:click={ startEditingFilter }>[{ trans( 'rename' ) }]</a>
                      <a href={ $ListingOpts.StaticURI + 'images/sprite.svg#ic_trash' } class="d-inline-block" on:click={ removeFilter } title={ trans('Remove') }>
                        <svg class="mt-icon mt-icon--sm">
                          <use xlink:href={$ListingOpts.StaticURI + 'images/sprite.svg#ic_trash'}></use>
                        </svg>
                      </a>
                    </div>
                  {/if}
                  <div class="form-inline" if={ parent.isEditingFilter[id] }>
                    <div class="form-group form-group-sm">
                      <input type="text" class="form-control rename-filter-input" value={ filter.label } ref="label" />
                      <button class="btn btn-default form-control" on:click={ renameFilter }>
                        { trans('Save') }
                      </button>
                      <button class="btn btn-default form-control" on:click={ stopEditingFilter }>
                        { trans('Cancel') }
                      </button>
                    </div>
                  </div>
                </li>
              {/if}
            {/each}
            <li class="filter line d-none d-md-block">
              <a href={ $ListingOpts.StaticURI + 'images/sprite.svg#ic_add' }
                id="new_filter"
                class="icon-mini-left addnew create-new apply-link d-md-inline-block"
                on:click={ createNewFilter }
                title={ trans('Add') }
              >
                <svg class="mt-icon mt-icon--sm">
                  <use xlink:href={$ListingStore.StaticURI + 'images/sprite.svg#ic_add'}></use>
                </svg>
                { trans( 'Create New' ) }
              </a>
            </li>
          </ul>
        </div>
        <div class="filter-list-block" if={ hasSystemFilter() }>
          <h6 class="filter-list-label">{ trans( 'Built in Filters' ) }</h6>
          <ul id="built-in-filters" class="list-unstyled">
            {#each $ListingStore.filters as { id, filter }}
              {#if filter.can_save === "0"}
                <li
                  class="filter line"
                  data-mt-list-filter-id={id}
                  data-mt-list-filter-label={filter.label}
                >
                  <a href="#" on:click={applyFilter}>
                    {@html filter.label}
                  </a>
                </li>
              {/if}
            {/each}
          </ul>
        </div>
      </div>
    </div>
  </div>
</div>
