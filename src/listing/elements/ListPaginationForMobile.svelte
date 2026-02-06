<script lang="ts">
  import { getContext } from "svelte";

  import SVG from "../../svg/elements/SVG.svelte";
  import type { ListStoreContext } from "../listStoreContext";

  type Props = {
    isTooNarrowWidth: boolean;
    movePage: (e: Event) => void;
    nextDisabledProp: { disabled?: string };
    page: number;
    previousDisabledProp: { disabled?: string };
  };
  let {
    isTooNarrowWidth,
    movePage,
    nextDisabledProp,
    page,
    previousDisabledProp,
  }: Props = $props();

  const { reactiveStore } = getContext<ListStoreContext>("listStore");
</script>

<ul class="pagination__mobile d-md-none">
  <li class="page-item" class:me-auto={isTooNarrowWidth}>
    <!-- svelte-ignore a11y_invalid_attribute -->
    <a
      href="javascript:void(0);"
      class="page-link"
      {...previousDisabledProp}
      data-page={page - 1}
      onclick={movePage}
    >
      <SVG
        title={window.trans("Previous")}
        class="mt-icon--inverse mt-icon--sm"
        href={window.StaticURI + "images/sprite.svg#ic_tri-left"}
      />
    </a>
  </li>

  {#if page - 4 >= 1 && $reactiveStore.pageMax - page < 1}
    <li class="page-item" class:me-auto={isTooNarrowWidth}>
      <!-- svelte-ignore a11y_invalid_attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={page - 4}
        onclick={movePage}
      >
        {page - 4}
      </a>
    </li>
  {/if}

  {#if page - 3 >= 1 && $reactiveStore.pageMax - page < 2}
    <li class="page-item" class:me-auto={isTooNarrowWidth}>
      <!-- svelte-ignore a11y_invalid_attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={page - 3}
        onclick={movePage}
      >
        {page - 3}
      </a>
    </li>
  {/if}

  {#if page - 2 >= 1}
    <li class="page-item" class:me-auto={isTooNarrowWidth}>
      <!-- svelte-ignore a11y_invalid_attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={page - 2}
        onclick={movePage}
      >
        {page - 2}
      </a>
    </li>
  {/if}

  {#if page - 1 >= 1}
    <li class="page-item" class:me-auto={isTooNarrowWidth}>
      <!-- svelte-ignore a11y_invalid_attribute -->
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

  <li class="page-item active" class:me-auto={isTooNarrowWidth}>
    <!-- svelte-ignore a11y_missing_attribute -->
    <a class="page-link">
      {page}
      <span class="visually-hidden">(current)</span>
    </a>
  </li>

  {#if page + 1 <= $reactiveStore.pageMax}
    <li class="page-item" class:me-auto={isTooNarrowWidth}>
      <!-- svelte-ignore a11y_invalid_attribute -->
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

  {#if page + 2 <= $reactiveStore.pageMax}
    <li class="page-item" class:me-auto={isTooNarrowWidth}>
      <!-- svelte-ignore a11y_invalid_attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={page + 2}
        onclick={movePage}
      >
        {page + 2}
      </a>
    </li>
  {/if}

  {#if page + 3 <= $reactiveStore.pageMax && page <= 2}
    <li class="page-item" class:me-auto={isTooNarrowWidth}>
      <!-- svelte-ignore a11y_invalid_attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={page + 3}
        onclick={movePage}
      >
        {page + 3}
      </a>
    </li>
  {/if}

  {#if page + 4 <= $reactiveStore.pageMax && page <= 1}
    <li class="page-item" class:me-auto={isTooNarrowWidth}>
      <!-- svelte-ignore a11y_invalid_attribute -->
      <a
        href="javascript:void(0);"
        class="page-link"
        data-page={page + 4}
        onclick={movePage}
      >
        {page + 4}
      </a>
    </li>
  {/if}

  <li class="page-item">
    <!-- svelte-ignore a11y_invalid_attribute -->
    <a
      href="javascript:void(0);"
      class="page-link"
      {...nextDisabledProp}
      data-page={page + 1}
      onclick={movePage}
    >
      <SVG
        title={window.trans("Next")}
        class="mt-icon--inverse mt-icon--sm"
        href={window.StaticURI + "images/sprite.svg#ic_tri-right"}
      />
    </a>
  </li>
</ul>
