<script lang="ts">
  export let store: ListStore;

  const closeModal = (): void => {
    //    jQuery(this.refs.modal).modal('hide')
  };

  const openModal = (args: object): void => {
    //    if (!args) {
    //      args = {}
    //    }
    //    jQuery(this.refs.filterName).mtUnvalidate()
    //    if (args.filterLabel) {
    //      this.refs.filterName.value = args.filterLabel
    //    }
    //    this.saveAs = args.saveAs
    //    jQuery(this.refs.modal).modal()
  };

  const saveFilter = (): void => {
    //    if (!jQuery(this.refs.filterName).mtValidate('simple')) {
    //      return false
    //    }
    //    this.listFilterTop.getItemValues()
    //    this.listFilterTop.currentFilter.label = this.refs.filterName.value
    //    if (this.saveAs) {
    //      this.listFilterTop.currentFilter.id = null
    //    }
    //    this.store.trigger('save_filter', this.listFilterTop.currentFilter)
    //    this.closeModal()
  };
</script>

<div id="save-filter" class="modal fade" tabindex="-1">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">
          {window.trans(store.saveAs ? "Save As Filter" : "Save Filter")}
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
