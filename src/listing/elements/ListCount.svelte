<script lang="ts">
  /* eslint @typescript-eslint/no-explicit-any: 0 */
  export let store: any;

  $: count = store.count == null ? 0 : store.count;
  $: limit = store.limit == null ? 0 : store.limit;
  $: page = store.page == null ? 0 : store.page;

  $: from = count == 0 ? 0 : limit * (page - 1) + 1;
  $: to = limit * page > count ? count : limit * page;
</script>

<div>
  {from} - {to} / {count}
</div>
