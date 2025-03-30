<script lang="ts">
  import { setContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";
  import DisplayOptionsForMobile from "./DisplayOptionsForMobile.svelte";

  let {
    context,
    changeLimit,
  }: { context: ListStoreContext; changeLimit: (e: Event) => void } = $props();

  // svelte-ignore state_referenced_locally
  setContext("listStore", context);
</script>

<DisplayOptionsForMobile {changeLimit} />
