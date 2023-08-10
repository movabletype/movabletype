<script>
import { ListingStore, ListingOpts } from "../ListingStore.ts";

export let movePage;
</script>

<ul class="pagination d-none d-md-flex">
  <li class="page-item">
    <a href="javascript:void(0);"
      class="page-link"
      disabled={ $ListingStore.page <= 1 }
      data-page={ $ListingStore.page - 1 }
      onclick={ movePage }
    >
      { trans('Previous') }
    </a>
  </li>

{#if $ListingStore.page - 2 >= 1 }
  <li class="page-item first-last">
    <a href="javascript:void(0);"
      class="page-link"
      data-page={ 1 }
      onclick={ movePage }
    >
      1
    </a>
  </li>
{/if}

{#if $ListingStore.page - 3 >= 1 }
  <li class="page-item" aria-hidden="true">
    ...
  </li>
{/if}

  {#if $ListingStore.page - 1 >= 1}
    <li
      class="page-item {$ListingStore.page - 1 == 1 ? 'first-last' : ''}"
    >
      <a href="javascript:void(0);"
        class="page-link"
        data-page={ $ListingStore.page - 1 }
        onclick={ movePage }
      >
        { $ListingStore.page - 1 }
      </a>
    </li>
  {/if}

  <li class="page-item active">
    <a class="page-link">
      { $ListingStore.page }
    </a>
  </li>

  {#if $ListingStore.page + 1 <= $ListingStore.pageMax}
    <li
      class="page-item {$ListingStore.page + 1 == $ListingStore.pageMax ? 'first-last' : ''}"
    >
      <a href="javascript:void(0);"
        class="page-link"
        data-page={ $ListingStore.page + 1 }
        onclick={ movePage }
      >
        { $ListingStore.page + 1 }
      </a>
    </li>
  {/if}

{#if $ListingStore.page + 3 <= $ListingStore.pageMax }
  <li class="page-item" aria-hidden="true">
    ...
  </li>
{/if}

{#if $ListingStore.page + 2 <= $ListingStore.pageMax }
  <li class="page-item first-last">
    <a href="javascript:void(0);"
      class="page-link"
      data-page={ $ListingStore.pageMax }
      onclick={ movePage }
    >
      { $ListingStore.pageMax }
    </a>
  </li>
{/if}

  <li class="page-item">
    <a href="javascript:void(0);"
      class="page-link"
      disabled={ $ListingStore.page >= $ListingStore.pageMax }
      data-page={ $ListingStore.page + 1 }
      onclick={ movePage }
    >
      { trans('Next') }
    </a>
  </li>
</ul>
