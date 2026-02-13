<script lang="ts">
  import { setContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";
  import DisplayOptionsColumns from "./DisplayOptionsColumns.svelte";

  let {
    context,
    disableUserDispOption,
  }: { context: ListStoreContext; disableUserDispOption: boolean } = $props();

  setContext("listStore", context);
</script>

<DisplayOptionsColumns {disableUserDispOption} />
