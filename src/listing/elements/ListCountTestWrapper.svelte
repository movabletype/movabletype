<script lang="ts">
  import { setContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";
  import ListCount from "./ListCount.svelte";

  let { context }: { context: ListStoreContext } = $props();

  // svelte-ignore state_referenced_locally
  setContext("listStore", context);
</script>

<ListCount />
