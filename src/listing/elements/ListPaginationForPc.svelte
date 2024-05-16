<script>
  export let listStore;
  export let movePage;
</script>

<ul class="pagination d-none d-md-flex">
  <li class="page-item">
    <!-- svelte-ignore a11y-invalid-attribute -->
    <a
      href="javascript:void(0);"
      class="page-link"
      disabled={listStore.page <= 1}
      data-page={listStore.page - 1}
      onclick={movePage}
    >
      {window.trans("Previous")}
    </a>
  </li>

  {#if listStore.page - 2 >= 1}
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

  {#if listStore.page - 3 >= 1}
    <li class="page-item" aria-hidden="true">...</li>
  {/if}

  {#if listStore.page - 1 >= 1}
    <li class="page-item {listStore.page - 1 == 1 ? 'first-last' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={listStore.page - 1}
        onclick={movePage}
      >
        {listStore.page - 1}
      </a>
    </li>
  {/if}

  <li class="page-item active">
    <!-- svelte-ignore a11y-missing-attribute -->
    <a class="page-link">
      {listStore.page}
      <span class="visually-hidden">(current)</span>
    </a>
  </li>

  {#if listStore.page + 1 <= listStore.pageMax}
    <li
      class="page-item {listStore.page + 1 == listStore.pageMax
        ? 'first-last'
        : ''}"
    >
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={listStore.page + 1}
        onclick={movePage}
      >
        {listStore.page + 1}
      </a>
    </li>
  {/if}

  {#if listStore.page + 3 <= listStore.pageMax}
    <li class="page-item" aria-hidden="true">...</li>
  {/if}

  {#if listStore.page + 2 <= listStore.pageMax}
    <li class="page-item first-last">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={listStore.pageMax}
        onclick={movePage}
      >
        {listStore.pageMax}
      </a>
    </li>
  {/if}

  <li class="page-item">
    <!-- svelte-ignore a11y-invalid-attribute -->
    <a
      href="javascript:void(0);"
      class="page-link"
      disabled={listStore.page >= listStore.pageMax}
      data-page={listStore.page + 1}
      onclick={movePage}
    >
      {window.trans("Next")}
    </a>
  </li>
</ul>
