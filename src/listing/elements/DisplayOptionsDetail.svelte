<script>
  import DisplayOptionsColumns from "./DisplayOptionsColumns.svelte";
  import DisplayOptionsLimit from "./DisplayOptionsLimit.svelte";

  export let listStore;

  function resetColumns(e) {
    listStore.trigger("reset_columns");
  }
</script>

<div id="display-options-detail" class="collapse">
  <div class="card card-block p-3">
    <fieldset class="form-group">
      <div data-is="display-options-limit" id="per_page-field">
        <DisplayOptionsLimit {listStore} limit={listStore.limit} />
      </div>
    </fieldset>
    <fieldset class="form-group">
      <div data-is="display-options-columns" id="display_columns-field">
        <DisplayOptionsColumns {listStore} />
      </div>
    </fieldset>
    <div
      if={!listStore.disableUserDispOption}
      class="actions-bar actions-bar-bottom"
    >
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        id="reset-display-options"
        on:click={resetColumns}
      >
        {window.trans("Reset defaults")}
      </a>
    </div>
  </div>
</div>
