<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import SVG from "../../svg/elements/SVG.svelte";

  export let isTooNarrowWidth: boolean;
  export let movePage: (e: Event) => void;
  export let nextDisabledProp: { disabled?: string };
  export let page: number;
  export let previousDisabledProp: { disabled?: string };
  export let store: Listing.ListStore;
</script>

<ul class="pagination__mobile d-md-none">
  <li class="page-item" class:me-auto={isTooNarrowWidth}>
    <!-- svelte-ignore a11y-invalid-attribute -->
    <a
      href="javascript:void(0);"
      class="page-link"
      {...previousDisabledProp}
      data-page={page - 1}
      on:click={movePage}
    >
      <SVG
        title={window.trans("Previous")}
        class="mt-icon--inverse mt-icon--sm"
        href={window.StaticURI + "images/sprite.svg#ic_tri-left"}
      />
    </a>
  </li>

  {#if page - 4 >= 1 && store.pageMax - page < 1}
    <li class="page-item" class:me-auto={isTooNarrowWidth}>
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={page - 4}
        on:click={movePage}
      >
        {page - 4}
      </a>
    </li>
  {/if}

  {#if page - 3 >= 1 && store.pageMax - page < 2}
    <li class="page-item" class:me-auto={isTooNarrowWidth}>
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={page - 3}
        on:click={movePage}
      >
        {page - 3}
      </a>
    </li>
  {/if}

  {#if page - 2 >= 1}
    <li class="page-item" class:me-auto={isTooNarrowWidth}>
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={page - 2}
        on:click={movePage}
      >
        {page - 2}
      </a>
    </li>
  {/if}

  {#if page - 1 >= 1}
    <li class="page-item" class:me-auto={isTooNarrowWidth}>
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

  <li class="page-item active" class:me-auto={isTooNarrowWidth}>
    <!-- svelte-ignore a11y-missing-attribute -->
    <a class="page-link">
      {page}
      <span class="visually-hidden">(current)</span>
    </a>
  </li>

  {#if page + 1 <= store.pageMax}
    <li class="page-item" class:me-auto={isTooNarrowWidth}>
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

  {#if page + 2 <= store.pageMax}
    <li class="page-item" class:me-auto={isTooNarrowWidth}>
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={page + 2}
        on:click={movePage}
      >
        {page + 2}
      </a>
    </li>
  {/if}

  {#if page + 3 <= store.pageMax && page <= 2}
    <li class="page-item" class:me-auto={isTooNarrowWidth}>
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={page + 3}
        on:click={movePage}
      >
        {page + 3}
      </a>
    </li>
  {/if}

  {#if page + 4 <= store.pageMax && page <= 1}
    <li class="page-item" class:me-auto={isTooNarrowWidth}>
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={page + 4}
        on:click={movePage}
      >
        {page + 4}
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
      on:click={movePage}
    >
      <SVG
        title={window.trans("Next")}
        class="mt-icon--inverse mt-icon--sm"
        href={window.StaticURI + "images/sprite.svg#ic_tri-right"}
      />
    </a>
  </li>
</ul>
