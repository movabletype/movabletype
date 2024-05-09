<script>
  import { ListingStore, ListingOpts } from "../ListingStore.ts";
  import ListPaginationForPc from "./ListPaginationForPc.svelte";
  import ListPaginationForMobile from "./ListPaginationForMobile.svelte";

  function isTooNarrowWidth() {
    return $ListingStore.pageMax >= 5 && window.innerWidth < 400;
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

<div class="col-auto mx-auto w-100: isTooNarrowWidth()">
  <nav aria-label={$ListingStore.objectType + " list"}>
    <ListPaginationForPc {isTooNarrowWidth} move_page={movePage} />
    <ListPaginationForMobile {isTooNarrowWidth} move_page={movePage} />
  </nav>
</div>
