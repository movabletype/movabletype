<script>
  import ListTableHeaderForMobile from "./ListTableHeaderForMobile.svelte";
  import ListTableHeaderForPc from "./ListTableHeaderForPc.svelte";

  export let listStore;
  export let opts;

  function toggleAllRowsOnPage(e) {
    listStore.trigger("toggle_all_rows_on_page");
  }

  function toggleSortColumn(e) {
    const columnId = e.currentTarget.parentElement.dataset.id;
    listStore.trigger("toggle_sort_column", columnId);
  }
</script>

<ListTableHeaderForPc
  {listStore}
  {opts}
  {toggleAllRowsOnPage}
  {toggleSortColumn}
/>
<ListTableHeaderForMobile {listStore} {opts} {toggleAllRowsOnPage} />
