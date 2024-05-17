<script>
  import SS from "../../ss/elements/SS.svelte";

  export let isTooNarrowWidth;
  export let movePage;
  export let store;
</script>

<ul class="pagination__mobile d-md-none">
  <li class="page-item{isTooNarrowWidth ? ' me-auto' : ''}">
    <!-- svelte-ignore a11y-invalid-attribute -->
    <a
      href="javascript:void(0);"
      class="page-link"
      disabled={store.page <= 1}
      data-page={store.page - 1}
      on:click={movePage}
    >
      <SS
        title={window.trans("Previous")}
        class="mt-icon--inverse mt-icon--sm"
        href={window.StaticURI + "images/sprite.svg#ic_tri-left"}
      />
    </a>
  </li>

  {#if store.page - 4 >= 1 && store.pageMax - store.page < 1}
    <li class="page-item{isTooNarrowWidth ? ' me-auto' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={store.page - 4}
        on:click={movePage}
      >
        {store.page - 4}
      </a>
    </li>
  {/if}

  {#if store.page - 3 >= 1 && store.pageMax - store.page < 2}
    <li class="page-item{isTooNarrowWidth ? ' me-auto' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={store.page - 3}
        on:click={movePage}
      >
        {store.page - 3}
      </a>
    </li>
  {/if}

  {#if store.page - 2 >= 1}
    <li class="page-item{isTooNarrowWidth ? ' me-auto' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={store.page - 2}
        on:click={movePage}
      >
        {store.page - 2}
      </a>
    </li>
  {/if}

  {#if store.page - 1 >= 1}
    <li class="page-item{isTooNarrowWidth ? ' me-auto' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={store.page - 1}
        on:click={movePage}
      >
        {store.page - 1}
      </a>
    </li>
  {/if}

  <li class="page-item active{isTooNarrowWidth ? ' me-auto' : ''}">
    <!-- svelte-ignore a11y-missing-attribute -->
    <a class="page-link">
      {store.page}
      <span class="visually-hidden">(current)</span>
    </a>
  </li>

  {#if store.page + 1 <= store.pageMax}
    <li class="page-item{isTooNarrowWidth ? ' me-auto' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={store.page + 1}
        on:click={movePage}
      >
        {store.page + 1}
      </a>
    </li>
  {/if}

  {#if store.page + 2 <= store.pageMax}
    <li class="page-item{isTooNarrowWidth ? ' me-auto' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={store.page + 2}
        on:click={movePage}
      >
        {store.page + 2}
      </a>
    </li>
  {/if}

  {#if store.page + 3 <= store.pageMax && store.page <= 2}
    <li class="page-item{isTooNarrowWidth ? ' me-auto' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={store.page + 3}
        on:click={movePage}
      >
        {store.page + 3}
      </a>
    </li>
  {/if}

  {#if store.page + 4 <= store.pageMax && store.page <= 1}
    <li class="page-item{isTooNarrowWidth ? ' me-auto' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={store.page + 4}
        on:click={movePage}
      >
        {store.page + 4}
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
      on:click={movePage}
    >
      <SS
        title={window.trans("Next")}
        class="mt-icon--inverse mt-icon--sm"
        href={window.StaticURI + "images/sprite.svg#ic_tri-right"}
      />
    </a>
  </li>
</ul>
