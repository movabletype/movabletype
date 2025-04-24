<script lang="ts">
  import type * as Listing from "../../@types/listing";

  export let store: Listing.ListStore;

  $: count = store.count || 0;
  $: limit = store.limit || 0;
  $: page = store.page || 0;

  $: from = count === 0 ? 0 : limit * (page - 1) + 1;
  $: to = limit * page > count ? count : limit * page;
</script>

<div>
  {from} - {to} / {count}
</div>
