<script lang="ts">
  import { onMount } from "svelte";

  import { ListStore } from "types/listing";

  import ListPaginationForMobile from "./ListPaginationForMobile.svelte";
  import ListPaginationForPc from "./ListPaginationForPc.svelte";

  export let store: ListStore;

  let isTooNarrowWidth: boolean;

  $: page = store.page == null ? 0 : store.page;

  let previousDisabledProps: { disabled?: string } = {};
  $: {
    previousDisabledProps = {};
    if (page <= 1) {
      previousDisabledProps.disabled = "";
    }
  }

  let nextDisabledProps: { disabled?: string } = {};
  $: {
    nextDisabledProps = {};
    if (page >= store.pageMax) {
      nextDisabledProps.disabled = "";
    }
  }

  onMount(() => {
    checkTooNarrowWidth();
  });

  const checkTooNarrowWidth = (): void => {
    isTooNarrowWidth = store.pageMax >= 5 && window.innerWidth < 400;
  };

  const movePage = (e): boolean => {
    if (e.currentTarget.disabled) {
      return false;
    }

    let nextPage;
    if (e.target.tagName === "INPUT") {
      if (e.which !== 13) {
        return false;
      }
      nextPage = Number(e.target.value);
    } else {
      nextPage = Number(e.currentTarget.dataset.page);
    }
    if (!nextPage) {
      return false;
    }
    let moveToPagination = true;
    store.trigger("move_page", nextPage, moveToPagination);
    return false;
  };
</script>

<svelte:window
  on:resize={checkTooNarrowWidth}
  on:orientationchange={checkTooNarrowWidth}
/>

<div class="col-auto mx-auto{isTooNarrowWidth ? ' w-100' : ''}">
  <nav aria-label={store.objectType + " list"}>
    <ListPaginationForPc
      {movePage}
      {nextDisabledProps}
      {page}
      {previousDisabledProps}
      {store}
    />
    <ListPaginationForMobile
      {isTooNarrowWidth}
      {nextDisabledProps}
      {page}
      {previousDisabledProps}
      {movePage}
      {store}
    />
  </nav>
</div>
