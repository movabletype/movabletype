<script lang="ts">
  import { getContext } from "svelte";

  import ListTableHeaderForMobile from "./ListTableHeaderForMobile.svelte";
  import ListTableHeaderForPc from "./ListTableHeaderForPc.svelte";
  import type { ListStoreContext } from "../listStoreContext";

  type Props = {
    hasListActions: boolean;
    hasMobilePulldownActions: boolean;
  };
  let { hasListActions, hasMobilePulldownActions }: Props = $props();
  const { store } = getContext<ListStoreContext>("listStore");

  const toggleAllRowsOnPage = (): void => {
    store.trigger("toggle_all_rows_on_page");
  };

  const toggleSortColumn = (e: Event): void => {
    const columnId = (e.currentTarget as HTMLElement)?.parentElement?.dataset
      .id;
    store.trigger("toggle_sort_column", columnId);
  };
</script>

<ListTableHeaderForPc
  {hasListActions}
  {toggleAllRowsOnPage}
  {toggleSortColumn}
/>
<ListTableHeaderForMobile {hasMobilePulldownActions} {toggleAllRowsOnPage} />
