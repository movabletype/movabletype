<script lang="ts">
  import SS from "../../ss/elements/SS.svelte";

  export let listFilterTopCreateNewFilter: Filter;
  export let store: ListStore;

  let isEditingFilter: { [key: string]: boolean } = {};

  const applyFilter = (filterId: string): void => {
    closeModal();
    store.trigger("apply_filter_by_id", filterId);
  };

  const startEditingFilter = (filterId: string): void => {
    stopEditingAllFilters();
    isEditingFilter[filterId] = true;
  };

  const stopEditingAllFilters = (): void => {
    isEditingFilter = {};
  };

  const stopEditingFilter = (filterId: string): void => {
    isEditingFilter[filterId] = false;
  };

  const closeModal = (): void => {
    // FIXME
    // jQuery("#select-filter").modal("hide");
    bootstrap.Modal.getInstance("#select-filter").hide();
    // bootstrap.Modal.getInstance(this.refs.modal).hide();
  };

  const createNewFilter = (): void => {
    closeModal();
    store.trigger("open_filter_detail");
    listFilterTopCreateNewFilter();
    store = store;
  };

  const renameFilter = (filterId: string, filterLabel: string): void => {
    store.trigger("rename_filter_by_id", filterId, filterLabel);
    isEditingFilter[filterId] = false;
  };

  const removeFilter = (
    filterId: string,
    filterLabel: string
  ): boolean | void => {
    const message = window.trans(
      "Are you sure you want to remove filter '[_1]'?",
      filterLabel
    );
    if (confirm(message) == false) {
      return false;
    }
    store.trigger("remove_filter_by_id", filterId);
  };
</script>

<div class="modal fade" id="select-filter" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">{window.trans("Select Filter")}</h5>
        <button type="button" class="close btn-close" data-dismiss="modal"
          ><span>×</span></button
        >
      </div>
      <div class="modal-body">
        <div class="filter-list-block">
          <h6 class="filter-list-label">{window.trans("My Filters")}</h6>
          <ul id="user-filters" class="list-unstyled editable">
            {#each store.filters as filter}
              {#if filter.can_save == "1"}
                <li
                  class="filter line"
                  data-mt-list-filter-id={filter.id}
                  data-mt-filter-label={filter.label}
                >
                  {#if !isEditingFilter[filter.id]}
                    <!-- svelte-ignore a11y-invalid-attribute -->
                    <a href="#" on:click={() => applyFilter(filter.id)}>
                      {filter.label}
                    </a>
                    <div class="float-end d-none d-md-block">
                      <!-- svelte-ignore a11y-invalid-attribute -->
                      <a
                        href="#"
                        on:click={() => startEditingFilter(filter.id)}
                      >
                        {window.trans("rename")}
                      </a>
                      <!-- svelte-ignore a11y-invalid-attribute -->
                      <a
                        href="#"
                        class="d-inline-block"
                        on:click={() => removeFilter(filter.id, filter.label)}
                      >
                        <SS
                          title={window.trans("Remove")}
                          class="mt-icon mt-icon--sm"
                          href={window.StaticURI + "images/sprite.svg#ic_trash"}
                        />
                      </a>
                    </div>
                  {/if}
                  {#if isEditingFilter[filter.id]}
                    <div class="form-inline">
                      <div class="form-group form-group-sm">
                        <input
                          type="text"
                          class="form-control rename-filter-input"
                          value={filter.label}
                        />
                        <button
                          class="btn btn-default form-control"
                          on:click={() => renameFilter(filter.id, filter.label)}
                        >
                          {window.trans("Save")}
                        </button>
                        <button
                          class="btn btn-default form-control"
                          on:click={() => stopEditingFilter(filter.id)}
                        >
                          {window.trans("Cancel")}
                        </button>
                      </div>
                    </div>
                  {/if}
                </li>
              {/if}
            {/each}
            <li class="filter line d-none d-md-block">
              <!-- svelte-ignore a11y-invalid-attribute -->
              <a
                href="#"
                id="new_filter"
                class="icon-mini-left addnew create-new apply-link d-md-inline-block"
                on:click={createNewFilter}
              >
                <SS
                  title={window.trans("Add")}
                  class="mt-icon mt-icon--sm"
                  href={window.StaticURI + "images/sprite.svg#ic_add"}
                />
                {window.trans("Create New")}
              </a>
            </li>
          </ul>
        </div>
        {#if store.hasSystemFilter()}
          <div class="filter-list-block">
            <h6 class="filter-list-label">
              {window.trans("Built in Filters")}
            </h6>
            <ul id="built-in-filters" class="list-unstyled">
              {#each store.filters as filter}
                {#if filter.can_save == "0"}
                  <li
                    class="filter line"
                    data-mt-list-filter-id={filter.id}
                    data-mt-list-filter-label={filter.label}
                  >
                    <!-- svelte-ignore a11y-invalid-attribute -->
                    <a href="#" on:click={() => applyFilter(filter.id)}>
                      {filter.label}
                    </a>
                  </li>
                {/if}
              {/each}
            </ul>
          </div>
        {/if}
      </div>
    </div>
  </div>
</div>
