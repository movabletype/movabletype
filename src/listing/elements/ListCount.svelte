<script lang="ts">
  import { ListStore } from "types/listing";

  export let store: ListStore;

  $: count = store.count == null ? 0 : store.count;
  $: limit = store.limit == null ? 0 : store.limit;
  $: page = store.page == null ? 0 : store.page;

  $: from = count == 0 ? 0 : limit * (page - 1) + 1;
  $: to = limit * page > count ? count : limit * page;
</script>

<div>
  {from} - {to} / {count}
</div>
