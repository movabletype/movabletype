<script lang="ts">
  import { setContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";
  import ListCount from "./ListCount.svelte";

  let { context }: { context: ListStoreContext } = $props();

  setContext("listStore", context);
</script>

<ListCount />
