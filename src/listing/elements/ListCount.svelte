<script lang="ts">
  import type * as Listing from "../../@types/listing";

  let { store }: { store: Listing.ListStore } = $props();

  let count = $derived(store.count || 0);
  let limit = $derived(store.limit || 0);
  let page = $derived(store.page || 0);

  let from = $derived(count === 0 ? 0 : limit * (page - 1) + 1);
  let to = $derived(limit * page > count ? count : limit * page);
</script>

<div>
  {from} - {to} / {count}
</div>
