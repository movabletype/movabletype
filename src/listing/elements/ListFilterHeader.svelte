<script>
  import { ListingOpts, ListingStore } from "../ListingStore.ts";
  import ListFilterSelectModal from "./ListFilterSelectModal.svelte";

  function isAllpassFilter() {
    return $ListingStore.currentFilter.id == $ListingStore.allpassFilter.id;
  }

  function resetFilter(e) {
    //    listTop.opts.listActionClient.removeFilterKeyFromReturnArgs()
    //    listTop.opts.listActionClient.removeFilterItemFromReturnArgs()
    //    store.trigger('close_filter_detail')
    //    store.trigger('reset_filter')
    console.log(e);
  }
</script>

<div class="row">
  <div class="col-12 col-md-11">
    <ul class="list-inline mb-0">
      <li class="list-inline-item">
        {trans("Filter:")}
      </li>
      <li class="list-inline-item">
        <a
          href="#"
          id="opener"
          data-bs-toggle="modal"
          data-bs-target="#select-filter"
        >
          <u>{trans($ListingStore.currentFilter.label)}</u>
        </a>
        <ListFilterSelectModal />
      </li>
      <li class="list-inline-item">
        {#if isAllpassFilter() == false}
          <a href="#" id="allpass-filter" on:click={resetFilter}>
            [ {trans("Reset Filter")} ]
          </a>
        {/if}
      </li>
    </ul>
  </div>
  <div class="d-none d-md-block col-md-1">
    <button
      id="toggle-filter-detail"
      class="btn btn-default dropdown-toggle float-right"
      data-bs-toggle="collapse"
      data-bs-target="#list-filter-collapse"
      aria-expanded="false"
      aria-controls="list-filter-collapse"
    />
  </div>
</div>
