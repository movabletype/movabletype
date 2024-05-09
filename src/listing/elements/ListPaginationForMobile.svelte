<script>
  import { ListingStore, ListingOpts } from "../ListingStore.ts";

  export let movePage;
  export let isTooNarrowWidth;
</script>

<ul class="pagination__mobile d-md-none">
  <li class="page-item {isTooNarrowWidth() ? 'mr-auto' : ''}">
    <a
      href="javascript:void(0);"
      class="page-link"
      disabled={$ListingStore.page <= 1}
      data-page={$ListingStore.page - 1}
      on:click={movePage}
    >
      <ss
        title={window.trans("Previous")}
        class="mt-icon--inverse mt-icon--sm"
        href={window.StaticURI + "images/sprite.svg#ic_tri-left"}
      />
    </a>
  </li>

  {#if $ListingStore.page - 4 >= 1 && $ListingStore.pageMax - $ListingStore.page < 1}
    <li class="page-item {isTooNarrowWidth() ? 'mr-auto' : ''}">
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={$ListingStore.page - 4}
        on:click={movePage}
      >
        {$ListingStore.page - 4}
      </a>
    </li>
  {/if}

  {#if $ListingStore.page - 3 >= 1 && $ListingStore.pageMax - $ListingStore.page < 2}
    <li class="page-item {isTooNarrowWidth() ? 'mr-auto' : ''}">
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={$ListingStore.page - 3}
        on:click={movePage}
      >
        {$ListingStore.page - 3}
      </a>
    </li>
  {/if}

  {#if $ListingStore.page - 2 >= 1}
    <li class="page-item {isTooNarrowWidth() ? 'mr-auto' : ''}">
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={$ListingStore.page - 2}
        on:click={movePage}
      >
        {$ListingStore.page - 2}
      </a>
    </li>
  {/if}

  {#if $ListingStore.page - 1 >= 1}
    <li class="page-item {isTooNarrowWidth() ? 'mr-auto' : ''}">
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={$ListingStore.page - 1}
        on:click={movePage}
      >
        {$ListingStore.page - 1}
      </a>
    </li>
  {/if}

  <li class="page-item {isTooNarrowWidth() ? 'mr-auto' : ''}">
    <a class="page-link">
      {$ListingStore.page}
      <span class="sr-only">(current)</span>
    </a>
  </li>

  {#if $ListingStore.page + 1 <= $ListingStore.pageMax}
    <li class="page-item {isTooNarrowWidth() ? 'mr-auto' : ''}">
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={$ListingStore.page + 1}
        on:click={movePage}
      >
        {$ListingStore.page + 1}
      </a>
    </li>
  {/if}

  {#if $ListingStore.page + 2 <= $ListingStore.pageMax}
    <li class="page-item {isTooNarrowWidth() ? 'mr-auto' : ''}">
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={$ListingStore.page + 2}
        on:click={movePage}
      >
        {$ListingStore.page + 2}
      </a>
    </li>
  {/if}

  {#if $ListingStore.page + 3 <= $ListingStore.pageMax && $ListingStore.page <= 2}
    <li class="page-item {isTooNarrowWidth() ? 'mr-auto' : ''}">
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={$ListingStore.page + 3}
        on:click={movePage}
      >
        {$ListingStore.page + 3}
      </a>
    </li>
  {/if}

  {#if $ListingStore.page + 4 <= $ListingStore.pageMax && $ListingStore.page <= 1}
    <li class="page-item {isTooNarrowWidth() ? 'mr-auto' : ''}">
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={$ListingStore.page + 4}
        on:click={movePage}
      >
        {$ListingStore.page + 4}
      </a>
    </li>
  {/if}

  <li class="page-item">
    <a
      href="javascript:void(0);"
      class="page-link"
      disabled={$ListingStore.page >= $ListingStore.pageMax}
      data-page={$ListingStore.page + 1}
      on:click={movePage}
    >
      <ss
        title={window.trans("Next")}
        class="mt-icon--inverse mt-icon--sm"
        href={window.URI + "images/sprite.svg#ic_tri-right"}
      />
    </a>
  </li>
</ul>
