<script lang="ts">
  import type * as Listing from "../../@types/listing";

  type Props = {
    movePage: (e: Event) => void;
    nextDisabledProp: { disabled?: string };
    page: number;
    previousDisabledProp: { disabled?: string };
    store: Listing.ListStore;
  };
  let { movePage, nextDisabledProp, page, previousDisabledProp, store }: Props =
    $props();
</script>

<ul class="pagination d-none d-md-flex">
  <li class="page-item">
    <!-- svelte-ignore a11y-invalid-attribute -->
    <a
      href="javascript:void(0);"
      class="page-link"
      {...previousDisabledProp}
      data-page={page - 1}
      onclick={movePage}
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
        onclick={movePage}
      >
        1
      </a>
    </li>
  {/if}

  {#if page - 3 >= 1}
    <li class="page-item" aria-hidden="true">...</li>
  {/if}

  {#if page - 1 >= 1}
    <li class="page-item" class:first-last={page - 1 === 1}>
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={page - 1}
        onclick={movePage}
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
    <li class="page-item" class:first-last={page + 1 === store.pageMax}>
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={page + 1}
        onclick={movePage}
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
      {...nextDisabledProp}
      data-page={page + 1}
      onclick={movePage}
    >
      {window.trans("Next")}
    </a>
  </li>
</ul>
