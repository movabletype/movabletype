<script lang="ts">
  import { setContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";
  import ListPaginationForPc from "./ListPaginationForPc.svelte";

  let {
    context,
    movePage,
    nextDisabledProp,
    page,
    previousDisabledProp,
  }: {
    context: ListStoreContext;
    movePage: (e: Event) => void;
    nextDisabledProp: { disabled?: string };
    page: number;
    previousDisabledProp: { disabled?: string };
  } = $props();

  setContext("listStore", context);
</script>

<ListPaginationForPc
  {movePage}
  {nextDisabledProp}
  {page}
  {previousDisabledProp}
/>
