<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import { onMount } from "svelte";

  import ListPaginationForMobile from "./ListPaginationForMobile.svelte";
  import ListPaginationForPc from "./ListPaginationForPc.svelte";

  export let store: Listing.ListStore;

  let nextDisabledProp: { disabled?: string } = {};
  let isTooNarrowWidth: boolean;
  let previousDisabledProp: { disabled?: string } = {};

  $: page = store.page || 0;
  $: {
    previousDisabledProp = {};
    if (page <= 1) {
      previousDisabledProp.disabled = "disabled";
    }
  }
  $: {
    nextDisabledProp = {};
    if (page >= store.pageMax) {
      nextDisabledProp.disabled = "disabled";
    }
  }

  onMount(() => {
    checkTooNarrowWidth();
  });

  const checkTooNarrowWidth = (): void => {
    isTooNarrowWidth = store.pageMax >= 5 && window.innerWidth < 400;
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
  on:resize={checkTooNarrowWidth}
  on:orientationchange={checkTooNarrowWidth}
/>

<div class="col-auto mx-auto" class:w-100={isTooNarrowWidth}>
  <nav aria-label={store.listClient.objectType + " list"}>
    <ListPaginationForPc
      {movePage}
      {nextDisabledProp}
      {page}
      {previousDisabledProp}
      {store}
    />
    <ListPaginationForMobile
      {isTooNarrowWidth}
      {nextDisabledProp}
      {page}
      {previousDisabledProp}
      {movePage}
      {store}
    />
  </nav>
</div>
