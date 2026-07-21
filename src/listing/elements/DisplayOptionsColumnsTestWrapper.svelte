<script lang="ts">
  import { setContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";
  import DisplayOptionsColumns from "./DisplayOptionsColumns.svelte";

  let {
    context,
    disableUserDispOption,
  }: { context: ListStoreContext; disableUserDispOption: boolean } = $props();

  // svelte-ignore state_referenced_locally
  setContext("listStore", context);
</script>

<DisplayOptionsColumns {disableUserDispOption} />
