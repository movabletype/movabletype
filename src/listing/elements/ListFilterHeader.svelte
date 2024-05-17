<script>
  import ListFilterSelectModal from "./ListFilterSelectModal.svelte";

  export let currentFilter;
  export let isAllpassFilter;
  export let listFilterTopCreateNewFilter;
  export let listStore;
  export let opts;

  function resetFilter() {
    opts.listActionClient.removeFilterKeyFromReturnArgs();
    opts.listActionClient.removeFilterItemFromReturnArgs();
    listStore.trigger("close_filter_detail");
    listStore.trigger("reset_filter");
  }
</script>

<div class="row">
  <div class="col-12 col-md-11">
    <ul class="list-inline mb-0">
      <li class="list-inline-item">
        {window.trans("Filter:")}
      </li>
      <li class="list-inline-item">
        <!-- svelte-ignore a11y-invalid-attribute -->
        <a
          href="#"
          id="opener"
          data-bs-toggle="modal"
          data-bs-target="#select-filter"
        >
          <u>{window.trans(currentFilter.label)}</u>
        </a>
        <ListFilterSelectModal {listFilterTopCreateNewFilter} {listStore} />
      </li>
      <li class="list-inline-item">
        {#if isAllpassFilter() == false}
          <!-- svelte-ignore a11y-invalid-attribute -->
          <a href="#" id="allpass-filter" on:click={resetFilter}>
            [ {window.trans("Reset Filter")} ]
          </a>
        {/if}
      </li>
    </ul>
  </div>
  <div class="d-none d-md-block col-md-1">
    <button
      id="toggle-filter-detail"
      class="btn btn-default dropdown-toggle float-end"
      data-bs-toggle="collapse"
      data-bs-target="#list-filter-collapse"
      aria-expanded="false"
      aria-controls="list-filter-collapse"
    />
  </div>
</div>
