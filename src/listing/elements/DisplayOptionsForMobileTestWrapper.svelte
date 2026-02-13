<script lang="ts">
  import { setContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";
  import DisplayOptionsForMobile from "./DisplayOptionsForMobile.svelte";

  let {
    context,
    changeLimit,
  }: { context: ListStoreContext; changeLimit: (e: Event) => void } = $props();

  setContext("listStore", context);
</script>

<DisplayOptionsForMobile {changeLimit} />
