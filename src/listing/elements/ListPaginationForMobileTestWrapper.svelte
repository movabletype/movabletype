<script lang="ts">
  import { setContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";
  import ListPaginationForMobile from "./ListPaginationForMobile.svelte";

  let {
    context,
    isTooNarrowWidth,
    movePage,
    nextDisabledProp,
    page,
    previousDisabledProp,
  }: {
    context: ListStoreContext;
    isTooNarrowWidth: boolean;
    movePage: (e: Event) => void;
    nextDisabledProp: { disabled?: string };
    page: number;
    previousDisabledProp: { disabled?: string };
  } = $props();

  setContext("listStore", context);
</script>

<ListPaginationForMobile
  {isTooNarrowWidth}
  {movePage}
  {nextDisabledProp}
  {page}
  {previousDisabledProp}
/>
