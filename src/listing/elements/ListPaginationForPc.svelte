<script>
  export let movePage;
  export let store;
</script>

<ul class="pagination d-none d-md-flex">
  <li class="page-item">
    <!-- svelte-ignore a11y-invalid-attribute -->
    <a
      href="javascript:void(0);"
      class="page-link"
      disabled={store.page <= 1}
      data-page={store.page - 1}
      onclick={movePage}
    >
      {window.trans("Previous")}
    </a>
  </li>

  {#if store.page - 2 >= 1}
    <li class="page-item first-last">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={1}
        onclick={movePage}
      >
        1
      </a>
    </li>
  {/if}

  {#if store.page - 3 >= 1}
    <li class="page-item" aria-hidden="true">...</li>
  {/if}

  {#if store.page - 1 >= 1}
    <li class="page-item {store.page - 1 == 1 ? 'first-last' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={store.page - 1}
        onclick={movePage}
      >
        {store.page - 1}
      </a>
    </li>
  {/if}

  <li class="page-item active">
    <!-- svelte-ignore a11y-missing-attribute -->
    <a class="page-link">
      {store.page}
      <span class="visually-hidden">(current)</span>
    </a>
  </li>

  {#if store.page + 1 <= store.pageMax}
    <li class="page-item {store.page + 1 == store.pageMax ? 'first-last' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={store.page + 1}
        onclick={movePage}
      >
        {store.page + 1}
      </a>
    </li>
  {/if}

  {#if store.page + 3 <= store.pageMax}
    <li class="page-item" aria-hidden="true">...</li>
  {/if}

  {#if store.page + 2 <= store.pageMax}
    <li class="page-item first-last">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={store.pageMax}
        onclick={movePage}
      >
        {store.pageMax}
      </a>
    </li>
  {/if}

  <li class="page-item">
    <!-- svelte-ignore a11y-invalid-attribute -->
    <a
      href="javascript:void(0);"
      class="page-link"
      disabled={store.page >= store.pageMax}
      data-page={store.page + 1}
      onclick={movePage}
    >
      {window.trans("Next")}
    </a>
  </li>
</ul>
