<script lang="ts">
  import { ListStore } from "types/listing";

  export let movePage: (e: Event) => void;
  export let nextDisabledProps: { disabled?: string };
  export let page: number;
  export let previousDisabledProps: { disabled?: string };
  export let store: ListStore;
</script>

<ul class="pagination d-none d-md-flex">
  <li class="page-item">
    <!-- svelte-ignore a11y-invalid-attribute -->
    <a
      href="javascript:void(0);"
      class="page-link"
      {...previousDisabledProps}
      data-page={page - 1}
      on:click={movePage}
    >
      {window.trans("Previous")}
    </a>
  </li>

  {#if page - 2 >= 1}
    <li class="page-item first-last">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={1}
        on:click={movePage}
      >
        1
      </a>
    </li>
  {/if}

  {#if page - 3 >= 1}
    <li class="page-item" aria-hidden="true">...</li>
  {/if}

  {#if page - 1 >= 1}
    <li class="page-item {page - 1 == 1 ? 'first-last' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={page - 1}
        on:click={movePage}
      >
        {page - 1}
      </a>
    </li>
  {/if}

  <li class="page-item active">
    <!-- svelte-ignore a11y-missing-attribute -->
    <a class="page-link">
      {page}
      <span class="visually-hidden">(current)</span>
    </a>
  </li>

  {#if page + 1 <= store.pageMax}
    <li class="page-item {page + 1 == store.pageMax ? 'first-last' : ''}">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={page + 1}
        on:click={movePage}
      >
        {page + 1}
      </a>
    </li>
  {/if}

  {#if page + 3 <= store.pageMax}
    <li class="page-item" aria-hidden="true">...</li>
  {/if}

  {#if page + 2 <= store.pageMax}
    <li class="page-item first-last">
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={store.pageMax}
        on:click={movePage}
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
      {...nextDisabledProps}
      data-page={page + 1}
      on:click={movePage}
    >
      {window.trans("Next")}
    </a>
  </li>
</ul>
