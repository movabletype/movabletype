<script lang="ts">
  import { getContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";

  type Props = {
    listFilterTopGetItemValues: () => void;
  };
  let { listFilterTopGetItemValues }: Props = $props();

  const { store, reactiveStore } = getContext<ListStoreContext>("listStore");

  let modal: HTMLDivElement;
  let filterName: HTMLInputElement;
  let saveAs: boolean | undefined = $state(undefined);

  const closeModal = (): void => {
    /* @ts-expect-error : bootstrap is not defined */
    bootstrap.Modal.getInstance(modal)?.hide();
  };

  export function openModal(
    args: { filterLabel?: string; saveAs?: boolean } = {},
  ): void {
    if (!args) {
      args = {};
    }
    /* @ts-expect-error : mtUnvalidate is not defined */
    jQuery(filterName).mtUnvalidate();
    if (args.filterLabel) {
      filterName.value = args.filterLabel;
    }
    saveAs = args.saveAs;
    /* @ts-expect-error : bootstrap is not defined */
    let bsmodal = new bootstrap.Modal(modal, {});
    bsmodal.show();
  }

  const saveFilter = (): boolean | void => {
    /* @ts-expect-error : mtValidate is not defined */
    if (!jQuery(filterName).mtValidate("simple")) {
      return false;
    }
    listFilterTopGetItemValues();
    $reactiveStore.currentFilter.label = filterName.value;
    if (saveAs) {
      $reactiveStore.currentFilter.id = "";
    }
    store.trigger("save_filter", $reactiveStore.currentFilter);
    closeModal();
  };
</script>

<div
  id="save-filter"
  class="modal fade"
  tabindex="-1"
  {...{ ref: "modal" }}
  bind:this={modal}
>
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">
          {saveAs
            ? window.trans("Save As Filter")
            : window.trans("Save Filter")}
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
            {...{ ref: "filterName" }}
            bind:this={filterName}
          />
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary" onclick={saveFilter}>
          {window.trans("Save")}
        </button>
        <button
          class="btn btn-default"
          data-bs-dismiss="modal"
          onclick={closeModal}
        >
          {window.trans("Cancel")}
        </button>
      </div>
    </div>
  </div>
</div>
