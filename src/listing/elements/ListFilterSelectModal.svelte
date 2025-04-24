<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import SVG from "../../svg/elements/SVG.svelte";

  export let listFilterTopCreateNewFilter: (filterLabel?: string) => void;
  export let listFilterTopUpdate: () => void;
  export let store: Listing.ListStore;

  let isEditingFilter: { [key: string]: boolean } = {};
  let modal: HTMLDivElement;

  const applyFilter = (e: Event): void => {
    closeModal();
    const filterId = (e.target as HTMLElement).parentElement?.dataset
      .mtListFilterId;
    store.trigger("apply_filter_by_id", filterId);
  };

  const closeModal = (): void => {
    /* @ts-expect-error : bootstrap is not defined */
    bootstrap.Modal.getInstance(modal).hide();
  };

  const createNewFilter = (): void => {
    closeModal();
    store.trigger("open_filter_detail");
    listFilterTopCreateNewFilter();
    listFilterTopUpdate();
  };

  const renameFilter = (e: Event): void => {
    const target = e.target as HTMLElement;
    const filterId =
      target.parentElement?.parentElement?.parentElement?.dataset
        .mtListFilterId;
    const filterLabel = (target.previousElementSibling as HTMLInputElement)
      .value;
    if (!filterId) {
      return;
    }
    store.trigger("rename_filter_by_id", filterId, filterLabel);
    isEditingFilter[filterId] = false;
  };

  const removeFilter = (e: Event): boolean | void => {
    const filterData = (
      (e.target as HTMLElement).closest(
        "[data-mt-list-filter-label]",
      ) as HTMLElement
    ).dataset;
    const message = window.trans(
      "Are you sure you want to remove filter '[_1]'?",
      filterData.mtListFilterLabel || "",
    );
    if (confirm(message) === false) {
      return false;
    }
    store.trigger("remove_filter_by_id", filterData.mtListFilterId);
  };

  const startEditingFilter = (e: Event): void => {
    const filterData = (e.target as HTMLElement).parentElement?.parentElement
      ?.dataset;
    const filterId = filterData?.mtListFilterId || "";
    if (filterId === "") {
      return;
    }
    stopEditingAllFilters();
    isEditingFilter[filterId] = true;
  };

  const stopEditingAllFilters = (): void => {
    isEditingFilter = {};
  };

  const stopEditingFilter = (filterId: string): void => {
    isEditingFilter[filterId] = false;
  };
</script>

<div
  class="modal fade"
  id="select-filter"
  tabindex="-1"
  {...{ ref: "modal" }}
  bind:this={modal}
>
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">{window.trans("Select Filter")}</h5>
        <button type="button" class="close btn-close" data-bs-dismiss="modal"
          ><span>×</span></button
        >
      </div>
      <div class="modal-body">
        <div class="filter-list-block">
          <h6 class="filter-list-label">{window.trans("My Filters")}</h6>
          <ul id="user-filters" class="list-unstyled editable">
            {#each store.filters as filter}
              {@const filterId = filter.id ?? ""}
              {#if filter.can_save?.toString() === "1"}
                <li
                  class="filter line"
                  data-mt-list-filter-id={filter.id}
                  data-mt-list-filter-label={filter.label}
                >
                  {#if !isEditingFilter[filterId]}
                    <!-- svelte-ignore a11y-invalid-attribute -->
                    <a href="#" on:click={applyFilter}>
                      {filter.label}
                    </a>
                    <div class="float-end d-none d-md-block">
                      <!-- svelte-ignore a11y-invalid-attribute -->
                      <a href="#" on:click={startEditingFilter}>
                        [{window.trans("rename")}]
                      </a>
                      <!-- svelte-ignore a11y-invalid-attribute -->
                      <a
                        href="#"
                        class="d-inline-block"
                        on:click={removeFilter}
                      >
                        <SVG
                          title={window.trans("Remove")}
                          class="mt-icon mt-icon--sm"
                          href={window.StaticURI + "images/sprite.svg#ic_trash"}
                        />
                      </a>
                    </div>
                  {/if}
                  {#if isEditingFilter[filterId]}
                    <div class="form-inline">
                      <div class="form-group form-group-sm">
                        <input
                          type="text"
                          class="form-control rename-filter-input"
                          value={filter.label}
                          {...{ ref: "label" }}
                        />
                        <button
                          class="btn btn-default form-control"
                          on:click={renameFilter}
                        >
                          {window.trans("Save")}
                        </button>
                        <!-- add filter.id to argument because Event object cannot be gotten in on:click function -->
                        <button
                          class="btn btn-default form-control"
                          on:click={() => stopEditingFilter(filterId)}
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
                <SVG
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
                {#if filter.can_save?.toString() === "0"}
                  <li
                    class="filter line"
                    data-mt-list-filter-id={filter.id}
                    data-mt-list-filter-label={filter.label}
                  >
                    <!-- svelte-ignore a11y-invalid-attribute -->
                    <a href="#" on:click={applyFilter}>
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
