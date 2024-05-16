<script>
  import SS from "../../ss/elements/SS.svelte";

  export let listStore;
  export let movePage;
  export let isTooNarrowWidth;
</script>

<ul class="pagination__mobile d-md-none">
  <li class="page-item{isTooNarrowWidth ? ' me-auto' : ''}">
    <!-- svelte-ignore a11y-invalid-attribute -->
    <a
      href="javascript:void(0);"
      class="page-link"
      disabled={listStore.page <= 1}
      data-page={listStore.page - 1}
      on:click={movePage}
    >
      <SS
        title={window.trans("Previous")}
        class="mt-icon--inverse mt-icon--sm"
        href={window.StaticURI + "images/sprite.svg#ic_tri-left"}
      />
    </a>
  </li>

  {#if listStore.page - 4 >= 1 && listStore.pageMax - listStore.page < 1}
    <li class="page-item{isTooNarrowWidth ? ' me-auto' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={listStore.page - 4}
        on:click={movePage}
      >
        {listStore.page - 4}
      </a>
    </li>
  {/if}

  {#if listStore.page - 3 >= 1 && listStore.pageMax - listStore.page < 2}
    <li class="page-item{isTooNarrowWidth ? ' me-auto' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={listStore.page - 3}
        on:click={movePage}
      >
        {listStore.page - 3}
      </a>
    </li>
  {/if}

  {#if listStore.page - 2 >= 1}
    <li class="page-item{isTooNarrowWidth ? ' me-auto' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={listStore.page - 2}
        on:click={movePage}
      >
        {listStore.page - 2}
      </a>
    </li>
  {/if}

  {#if listStore.page - 1 >= 1}
    <li class="page-item{isTooNarrowWidth ? ' me-auto' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={listStore.page - 1}
        on:click={movePage}
      >
        {listStore.page - 1}
      </a>
    </li>
  {/if}

  <li class="page-item active{isTooNarrowWidth ? ' me-auto' : ''}">
    <!-- svelte-ignore a11y-missing-attribute -->
    <a class="page-link">
      {listStore.page}
      <span class="visually-hidden">(current)</span>
    </a>
  </li>

  {#if listStore.page + 1 <= listStore.pageMax}
    <li class="page-item{isTooNarrowWidth ? ' me-auto' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={listStore.page + 1}
        on:click={movePage}
      >
        {listStore.page + 1}
      </a>
    </li>
  {/if}

  {#if listStore.page + 2 <= listStore.pageMax}
    <li class="page-item{isTooNarrowWidth ? ' me-auto' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={listStore.page + 2}
        on:click={movePage}
      >
        {listStore.page + 2}
      </a>
    </li>
  {/if}

  {#if listStore.page + 3 <= listStore.pageMax && listStore.page <= 2}
    <li class="page-item{isTooNarrowWidth ? ' me-auto' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={listStore.page + 3}
        on:click={movePage}
      >
        {listStore.page + 3}
      </a>
    </li>
  {/if}

  {#if listStore.page + 4 <= listStore.pageMax && listStore.page <= 1}
    <li class="page-item{isTooNarrowWidth ? ' me-auto' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={listStore.page + 4}
        on:click={movePage}
      >
        {listStore.page + 4}
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
