<script>
  import ListTableHeaderForMobile from "./ListTableHeaderForMobile.svelte";
  import ListTableHeaderForPc from "./ListTableHeaderForPc.svelte";

  export let hasListActions;
  export let hasMobilePulldownActions;
  export let store;

  function toggleAllRowsOnPage() {
    store.trigger("toggle_all_rows_on_page");
  }

  function toggleSortColumn(e) {
    const columnId = e.currentTarget.parentElement.dataset.id;
    store.trigger("toggle_sort_column", columnId);
  }
</script>

<ListTableHeaderForPc
  {hasListActions}
  {store}
  {toggleAllRowsOnPage}
  {toggleSortColumn}
/>
<ListTableHeaderForMobile
  {hasMobilePulldownActions}
  {store}
  {toggleAllRowsOnPage}
/>
