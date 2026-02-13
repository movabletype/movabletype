<script lang="ts">
  import { getContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";

  const { reactiveStore } = getContext<ListStoreContext>("listStore");

  let count = $derived($reactiveStore.count || 0);
  let limit = $derived($reactiveStore.limit || 0);
  let page = $derived($reactiveStore.page || 0);

  let from = $derived(count === 0 ? 0 : limit * (page - 1) + 1);
  let to = $derived(limit * page > count ? count : limit * page);
</script>

<div>
  {from} - {to} / {count}
</div>
