<script>
  import { onMount } from "svelte";

  import { ListingStore, ListingOpts } from "../ListingStore.ts";
  import ListPaginationForPc from "./ListPaginationForPc.svelte";
  import ListPaginationForMobile from "./ListPaginationForMobile.svelte";

  let isTooNarrowWidth;

  onMount(() => {
    checkTooNarrowWidth();
  });

  function checkTooNarrowWidth() {
    isTooNarrowWidth = $ListingStore.pageMax >= 5 && window.innerWidth < 400;
  }

  function movePage(e) {
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
    $ListingStore.move_page(nextPage, moveToPagination);
    return false;
  }
</script>

<svelte:window on:resize={checkTooNarrowWidth} />

<div class="col-auto mx-auto{isTooNarrowWidth ? ' w-100' : ''}">
  <nav aria-label={$ListingStore.objectType + " list"}>
    <ListPaginationForPc move_page={movePage} />
    <ListPaginationForMobile {isTooNarrowWidth} move_page={movePage} />
  </nav>
</div>
