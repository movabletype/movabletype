<script lang="ts">
  import ListTableHeaderForMobile from "./ListTableHeaderForMobile.svelte";
  import ListTableHeaderForPc from "./ListTableHeaderForPc.svelte";

  export let hasListActions: boolean;
  export let hasMobilePulldownActions: boolean;
  export let store: ListStore;

  const toggleAllRowsOnPage = (): void => {
    store.trigger("toggle_all_rows_on_page");
  };

  const toggleSortColumn = (columnId: string): void => {
    store.trigger("toggle_sort_column", columnId);
  };
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
