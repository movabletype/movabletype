<script lang="ts">
  import { setContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";
  import DisplayOptionsDetail from "./DisplayOptionsDetail.svelte";

  let {
    context,
    changeLimit,
    disableUserDispOption,
  }: {
    context: ListStoreContext;
    changeLimit: (e: Event) => void;
    disableUserDispOption: boolean;
  } = $props();

  // svelte-ignore state_referenced_locally
  setContext("listStore", context);
</script>

<DisplayOptionsDetail {changeLimit} {disableUserDispOption} />
