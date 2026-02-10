<script lang="ts">
  import { setContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";
  import ListPagination from "./ListPagination.svelte";

  let { context }: { context: ListStoreContext } = $props();

  setContext("listStore", context);
</script>

<ListPagination />
