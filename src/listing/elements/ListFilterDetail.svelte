<script>
  import { ListingOpts, ListingStore } from "../ListingStore.ts";
  import ListFilterItem from "./ListFilterItem.svelte";
  import ListFilterButtons from "./ListFilterButtons.svelte";

  function addFilterItem(e) {
    //    if (e.currentTarget.classList.contains('disabled')) {
    //      e.preventDefault()
    //      e.stopPropagation()
    //      return
    //    }
    //    const filterType = e.currentTarget.dataset.mtFilterType
    //    listFilterTop.addFilterItem(filterType)
    console.log(e);
  }
</script>

<div class="row">
  <div class="col-12">
    <ul class="list-inline">
      <li class="list-inline-item">
        <div class="dropdown">
          <button
            class="btn btn-default dropdown-toggle"
            data-toggle="dropdown"
          >
            {window.trans("Select Filter Item...")}
          </button>
          <div class="dropdown-menu">
            {#each $ListingOpts.filterTypes as type}
              {#if type.editable}
                <!-- svelte-ignore a11y-invalid-attribute -->
                <a
                  class="disabled dropdown-item"
                  href="#"
                  data-mt-filter-type={type}
                  on:click={addFilterItem}
                >
                  {@html type.label}
                </a>
              {/if}
            {/each}
          </div>
        </div>
      </li>
    </ul>
  </div>
</div>
<div class="row mb-3">
  <div class="col-12">
    <ul class="list-group">
      {#each $ListingStore.currentFilter.items as item, index}
        <li data-mt-list-item-index={index} class="list-group-item">
          <ListFilterItem />
        </li>
      {/each}
    </ul>
  </div>
</div>
<div class="row">
  <div class="col-12">
    <ListFilterButtons />
  </div>
</div>
