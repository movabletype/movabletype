<script lang="ts">
  import { getContext, onMount } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";

  import ListPaginationForMobile from "./ListPaginationForMobile.svelte";
  import ListPaginationForPc from "./ListPaginationForPc.svelte";

  const { store, reactiveStore } = getContext<ListStoreContext>("listStore");

  let isTooNarrowWidth: boolean = $state(false);

  let page = $derived($reactiveStore.page || 0);
  let previousDisabledProp: { disabled?: string } = $derived(
    page <= 1 ? { disabled: "disabled" } : {},
  );
  let nextDisabledProp: { disabled?: string } = $derived(
    page >= $reactiveStore.pageMax ? { disabled: "disabled" } : {},
  );

  onMount(() => {
    checkTooNarrowWidth();
  });

  const checkTooNarrowWidth = (): void => {
    isTooNarrowWidth = $reactiveStore.pageMax >= 5 && window.innerWidth < 400;
  };

  const movePage = (e: Event): boolean => {
    const currentTarget = e.currentTarget as HTMLElement;
    if (currentTarget.getAttribute("disabled")) {
      return false;
    }

    let nextPage: number;

    /* Comment out old unused code */
    // if (target.tagName === "INPUT") {
    //   if (e.which !== 13) {
    //     return false;
    //   }
    //   nextPage = Number((target as HTMLInputElement).value);
    // } else {
    //   nextPage = Number(currentTarget.dataset.page);
    // }
    nextPage = Number(currentTarget.dataset.page);

    if (!nextPage) {
      return false;
    }
    const moveToPagination = true;
    store.trigger("move_page", nextPage, moveToPagination);
    return false;
  };
</script>

<svelte:window
  onresize={checkTooNarrowWidth}
  onorientationchange={checkTooNarrowWidth}
/>

<div class="col-auto mx-auto" class:w-100={isTooNarrowWidth}>
  <nav aria-label={store.listClient.objectType + " list"}>
    <ListPaginationForPc
      {movePage}
      {nextDisabledProp}
      {page}
      {previousDisabledProp}
    />
    <ListPaginationForMobile
      {isTooNarrowWidth}
      {nextDisabledProp}
      {page}
      {previousDisabledProp}
      {movePage}
    />
  </nav>
</div>
