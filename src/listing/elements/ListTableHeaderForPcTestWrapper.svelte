<script lang="ts">
  import { setContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";
  import ListTableHeaderForPc from "./ListTableHeaderForPc.svelte";

  let {
    context,
    hasListActions,
    toggleAllRowsOnPage,
    toggleSortColumn,
  }: {
    context: ListStoreContext;
    hasListActions: boolean;
    toggleAllRowsOnPage: () => void;
    toggleSortColumn: (e: Event) => void;
  } = $props();

  setContext("listStore", context);
</script>

<table>
  <thead>
    <ListTableHeaderForPc
      {hasListActions}
      {toggleAllRowsOnPage}
      {toggleSortColumn}
    />
  </thead>
</table>
