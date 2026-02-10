<script lang="ts">
  import { setContext, type Snippet } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";

  let { context, children }: { context: ListStoreContext; children: Snippet } =
    $props();

  setContext("listStore", context);
</script>

{@render children()}
