<script lang="ts">
  import { Filter, ListStore } from "types/listing";

  export let currentFilter: Filter;
  export let listFilterTopGetItemValues: () => void;
  export let store: ListStore;

  let modal: HTMLDivElement;
  let filterName: HTMLInputElement;
  let refModalProp = { ref: "modal" };
  let refFilterNameProp = { ref: "filterName" };
  let saveAs: boolean | undefined;

  const closeModal = (): void => {
    bootstrap.Modal.getInstance(modal).hide();
  };

  export const openModal = (args: {
    filterLabel?: string;
    saveAs?: boolean;
  }): void => {
    if (!args) {
      args = {};
    }
    jQuery(filterName).mtUnvalidate();
    if (args.filterLabel) {
      filterName.value = args.filterLabel;
    }
    saveAs = args.saveAs;
    let $bsmodal = new bootstrap.Modal(modal, {});
    $bsmodal.show();
  };

  const saveFilter = (): boolean | void => {
    if (!jQuery(filterName).mtValidate("simple")) {
      return false;
    }
    listFilterTopGetItemValues();
    currentFilter.label = filterName.value;
    if (saveAs) {
      currentFilter.id = "";
    }
    store.trigger("save_filter", currentFilter);
    closeModal();
  };
</script>

<div
  id="save-filter"
  class="modal fade"
  tabindex="-1"
  {...refModalProp}
  bind:this={modal}
>
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">
          {window.trans(saveAs ? "Save As Filter" : "Save Filter")}
        </h5>
        <button
          type="button"
          class="close"
          data-bs-dismiss="modal"
          aria-label="Close"
        >
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div style="padding-bottom: 30px;">
          <h6>{window.trans("Filter Label")}</h6>
          <input
            type="text"
            class="text full required form-control"
            name="filter_name"
            {...refFilterNameProp}
            bind:this={filterName}
          />
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary" on:click={saveFilter}>
          {window.trans("Save")}
        </button>
        <button
          class="btn btn-default"
          data-bs-dismiss="modal"
          on:click={closeModal}
        >
          {window.trans("Cancel")}
        </button>
      </div>
    </div>
  </div>
</div>
