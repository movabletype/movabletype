<script>
  import { onMount } from "svelte";

  import ListPaginationForMobile from "./ListPaginationForMobile.svelte";
  import ListPaginationForPc from "./ListPaginationForPc.svelte";

  export let listStore;

  let isTooNarrowWidth;

  onMount(() => {
    checkTooNarrowWidth();
  });

  function checkTooNarrowWidth() {
    isTooNarrowWidth = listStore.pageMax >= 5 && window.innerWidth < 400;
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
    listStore.trigger("move_page", nextPage, moveToPagination);
    return false;
  }
</script>

<svelte:window
  on:resize={checkTooNarrowWidth}
  on:orientationchange={checkTooNarrowWidth}
/>

<div class="col-auto mx-auto{isTooNarrowWidth ? ' w-100' : ''}">
  <nav aria-label={listStore.objectType + " list"}>
    <ListPaginationForPc {listStore} {movePage} />
    <ListPaginationForMobile {isTooNarrowWidth} {listStore} {movePage} />
  </nav>
</div>
